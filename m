Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89079606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A4kiSoWN
Received: by kanga.kvack.org (Postfix)
	id CF0226B0749; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE4B6B074B; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F376B074C; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83ACF6B0749
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:30:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2A13A0C8D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:32 +0000 (UTC)
X-FDA: 85470399504.01.7E4F347
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2846C20017
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4kiSoWN;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534231;
	b=BDMGtdXldQ4eJz7rZjQiPuUBU9O5T4xg1J1DXGA5jgdUXqD4cRa+3p2yJ3pksXXEPcvpFD
	MHwzSLciNWbWnQPr8mcC/9xlwaDgujqaGBoZL5JOXHpRa5w0f4DZS9dPdZ80MzCi21hco1
	iU8maevLx3dqO4ljISUa/PBx7/TygNQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtGnH1j+k8K1i0C8+rWDE5CfsWDYKesCWpGj2PsQngk=;
	b=odfsK+woDjYcUGsaQglQTmXBuQFboi0yaSrGDMmycybrXt6MtW/rRTXjYGJlEY4Khf0p67
	INy2WHoU+Wi9f25PTnMANbsIWH4V82fioTAXf+f9dqdZ8mWlg6t5HyhPpN4L8D4V4U9NR/
	AJ6yMDRy9EsOZTUGMVTmd8iYlvcQ268=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A4kiSoWN;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61402447BE;
	Tue, 24 Nov 2026 15:30:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116CB1F000EE;
	Tue, 24 Nov 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534230;
	bh=vtGnH1j+k8K1i0C8+rWDE5CfsWDYKesCWpGj2PsQngk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4kiSoWNXQe9RE7ah6INVKCZhCr9v/oYj+yH5c+YKcRFU4Q5Hl20XtdjchLw2Wpwg
	 lFurLsHrl2ZlsERTDsrTXbKfb+7FSUA/Jl6KmQImydd6LRowqNBpwnbxAMls6k2c+R
	 ieJrolvXUXnk9lWsr1AM06JgHExkq0/iq7IQePjZYS8HJLXIWXozi0EXAyTjHmkbp9
	 QCXQRtOUevM/Wip6RzkYg+sJV2EM4WFgpCIRO8cnBBvcu9/nSLf53C/c+prihMKCKT
	 jSb17tZVK4gKfnyBcDu4iM9mYoS1H5zJ3ITe9e+NJffmuPCZQwAYmlruCM4ZExfLGD
	 ggDlLNXGTwc1g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 1/4] mm/damon/paddr: skip non-LRU folios as a whole in pageout
Date: Tue, 24 Nov 2026 07:30:17 -0800
Message-ID: <20261124153021.90142-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153021.90142-1-sj@kernel.org>
References: <20261124153021.90142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2846C20017
X-Stat-Signature: cp7ti5adxopea15o1j9ma835yin5xbdd
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534230-181524
X-HE-Meta: U2FsdGVkX194AIMosk2bFyrXHHLubxa4PJ7QAcPluAEvupHXntW5cSAjPYrmExSMZDhDvt1+TctRCVHE0OlRWU5FVQpdbz9mh2eqJk7dfJp8+EmMh1hNlz3C2Gd5Xn3bUgOmAEx4aklfjbI5LSCCaVIg9dy/C2EuQeKKX93+ZOpMuAJzD0RXZFnLBNOXuTkDSZBo9dbRT/W2bGZGzQzLskl8Y52DfccSQbUj7vvsk+6zW0Pg43vdW732Eq+Dpsy5kklbjF2pp3+kqERUyEUFkxuGUu17Ra9JkAcnpXDwqcUNgKsD5N44+XSiywwitKnOwh9GnMbE5n779OOS4maSnZxebaKxFY9IceVwqvatc/TmjqHLKMRZw6FQzMmHw+AJZjG2Ya82pMzn0G7Gbbr00RcbrnR7d3YEEuqgMOogUv7pqjNRy7413vaYCE8cFQnpex7P1X/rVHyYBPJ6AIIYIt5iyZh5GliL+weR/t7hA5Oh529kBoKpARqgmJ9l8OiTKYDzoDmNJj4Y87npcKK/4wWkFFR08B/iYTvmMyy/+FLWqWJXhQ7Q3VLkR9vlJK2cVfVtK7rovehqNB+lSH3N7IgE7/4BA4VvwfrAQLlE80PuQoX9LzyohzsCSjYzquk0EFlrdoK5JdGFHE4ikp+5fpfdmjFKyWZx7eR06TF4WUTWBTeTfB9mLD8UHebJBC0eQalxwzEdVxFUDFWI2T3MKaNGRLPcHyFv8eHJ8yu5pGExQgi6uVseD37UP56e3Uu0b3ZMd6eYzHp4WRSPLtijeCJr/AdJOp4CiKVngSejUFOWvN+H1oFJmZW0ZaKItTiriG8g7hFuHDFGOxnfzbIb6C4zqpF8X9avjPbwSUPcRvxjn+DzBy6h9/cLjCAc1rBBxSULnXlciwZtftJ+6j5UglxsyEZtfG5BUyD51+vVXIBfNHZTGtQUIJ8/pXk/EsJDuDcTpFe6ez/ow+xY8wq
 yH9XK1oi
 a6dLS7Rs99OM7TdcBZTGd86n5SPFcUdNj1iUpJK0txNwahnKPcdwZ3bQcF/FX7J0+Q8uwaj4biNM+v6imIGoKc2QXc1Na6mB8xtjhcWSGMl5YvtKSC/vaCBhhnt13uEY39wJWE8rfaugGM+zJ95bWTpNzXl6Opt0H+O2+hOfiJtaAEVM0+/Li3Rtfhz+1W8yXs2HQwWNP1g/cjk3SucC1gftg89pmoKwoSI0BUVCVxs2GHeQlbkTfPopM8jlxmQtqFVtFDvaGyoI6k1RnVjbl4CH5/En6tZXmYWmbFoum6Lvn1AoUlFVwMCGJnWOgHWVo3+Poqqw2jkSWxTYDSoC7SrJBa8otbIEen5o1HZ94l1wJ9zMkDAB/wc1nW1MhzxgtgICe4Xu5WfSJcQRrNO4/6y1ojaECRW6FCjUAUGhG90qXK19hrtQhAgTAK52JACYcuZ/aHHDe6H/tZwAN/BsBUuuARLWOG/W01reC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

damon_pa_pageout() uses damon_get_folio(), which rejects folios that are
not on the LRU.  For a large non-LRU folio such as a hugetlb folio, the
loop then looks up the same folio once per base page even though
pageout cannot reclaim it.

Use damon_get_monitor_folio() and skip any returned non-LRU folio as a
whole by advancing to its end.  Do this before the filters, the
accounting and the last_applied check, so that adjacent regions within
the same non-LRU folio are not walked by base page either.

In an x86-64 KVM pageout microbenchmark, traversal time dropped by
about 99.7% for regions covering whole 2 MiB hugetlb folios. For
4 KiB regions within hugetlb folios, traversal took about 1 ns more
per region.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20261118-fix-damon-hugetlb-pageout-20261117-v2-1-547a65a3206e@gmail.com
- Collect R-b: from Enze and SJ.
- Rebase to the latest mm-new.
Changes in v2:
- v1: https://lore.kernel.org/20261117-fix-damon-hugetlb-pageout-20261117-v1-1-054ef8760a92@gmail.com
- Drop the redundant hugetlb check and update the subject and
  description as suggested by SJ.

 mm/damon/paddr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 411e1d557ba3f..83bc173c30504 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -268,7 +268,9 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
-		folio = damon_get_folio(PHYS_PFN(addr));
+		folio = damon_get_monitor_folio(PHYS_PFN(addr));
+		if (folio && !folio_test_lru(folio))
+			goto put_folio;
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;
-- 
2.47.3

