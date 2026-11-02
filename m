Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EA42606BA45
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ag3K53I0
Received: by kanga.kvack.org (Postfix)
	id D0CA76B05D8; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBD586B05D9; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF9976B05DA; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9892D6B05D9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:08:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 37ED3A6BD5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:08 +0000 (UTC)
X-FDA: 85390509456.25.1DC3A7E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9780C40010
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ag3K53I0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awuxY1FvzsoS1AnamJJIhHpAk0A733zuvxu39gKku+U=;
	b=KmtnnS++RXUUDfgxaGX6TOB8zNJPvNBhWwv0Pq5gQPoC8tBq8jJd7TjUl5ULYVGWsWn+km
	Ft2qg89urEFGS+fiIZ7KqHtme/DuOGIzH3R6Cr8poio55jjJbVRjcNyKMpHaVN8FhkhPYz
	muOYVBqnCkckMHOQP9RtkFBDYdN1NfU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ag3K53I0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632086;
	b=a06zzE2b4JotMM4wF7CMyKwECkhGKi3Ej+dVlx5pU2CNoiS061yDTwHMUP8wSEG/qhBTqW
	N4UAmfwr0fx9ox0dCVUsT6Z5jqBdPLFBUG6g5iEi8E/epXKc82NAVMdrNBFZVqh5Iv4FtS
	1rX+pnwScZgJ6gkngZjlXTL/DwWYEYo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 395996060F;
	Mon,  2 Nov 2026 15:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B9AF1F00A1D;
	Mon,  2 Nov 2026 15:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632085;
	bh=awuxY1FvzsoS1AnamJJIhHpAk0A733zuvxu39gKku+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ag3K53I0Csd3ikdmc6KReqMvi/VyGvfqEHpgseRbEL1brw4iXQitfE5arNES3VbsB
	 50u+rHAwCPanrp577miARyXu7d0J14BF952So/jncCy8Mhbj8Slb4Zp3jio3RV86J9
	 KT6Da6cOMPynOo0CwHrzLzWzlkV5G0lkfD0oURrHQFrzocfDppWxqL4fzxf7mfqJ1k
	 tiYd1ZTjd5hJqzG4DbnOP0+oKwfr3APif41tdiQPYW/8hGFFijtfUpz9/oK37+DQJI
	 39a6lz78YeIT5IZMmNOwIheYMUhGOg1jPy5GXwM8FcxmHA0e6wjVve3INVygwZ7ckA
	 qQr3r9LchhW/g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SJ Park <sj@kernel.org>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>
Subject: [PATCH 2/9] mm/damon/ops-common: align MMU notifier range when clearing PTE young bit
Date: Mon,  2 Nov 2026 07:07:49 -0800
Message-ID: <20261102150757.93058-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102150757.93058-1-sj@kernel.org>
References: <20261102150757.93058-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9780C40010
X-Stat-Signature: qgorb5ji98u7si8ij4qhdsoenwibgrfc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793632086-435357
X-HE-Meta: U2FsdGVkX1/BiXmXv3ElFx8Q7nh1C1dDEp8piEy05ppd9Vn3nEFuBf71Drj78MuAsqPon4Ysv+AkNWpefaTBHzaM72ObLU7trcNOdPCvRbH+0uaH8cmGd54pSBHEC1rQlGYAAL8D6ZFcniP3q3HGgBclpjEIMwvpjv0YETC+aTihlXSALLG3OL3s2xKkLMTfTiS3BMkSJ+fUM31C70ZfktdW2Zv9UHriTifF87hO7YQ5EUJMFA5mJhxO+upjZ2szppfNProSdbk3tfMFkbxtxybcznXCgwW33Ys/zEjLtsyJOAAQs8Pq0U1jEKgss5Axs0O8CTIaWqkD+gof3eOfY19ehx2Ibjud4mcS6rZSlc1JProdDE2f3LOOjrF05jw+b2NxCeowaRCbm7/J48zcQxlCNNJHEa/MYgXUlGlo9PQ181QWJEqI+S1ma8tJ9KbWcBBA5ztDi1S+IExpg8e7HcFsIlv/WFGePn2PFptOmCxknON0SOTbcIUD5AnZ5NnQz/zgXHx4wxZwHUuj5aFhNXL86LuQ/b1EiR1zP9/nJ8vi/BbwOV5+N9aUg75S0rNavy3uXHTbcmFf0FeY1FrxtwZJY1capmxz83RYFlxqcndcLkAJIdgFQzd4ohS/606A+0U526AsJY4UE3npcgZQndrNGlBuW2s8ZMHQFDsIvSaQMphqpu49DMPC266/xKt1vjL2uX9tiLzUXDIx5fqGaTnUPDYOM0a92h0d3vcvzwt+qSHUiyfsOlSxLd3UT1cs1Gv5rF5NfnvKfvtmYi/GuBcEcuklub7pccZiqrDjrSO94Wb11Mz3aJ8TPanbp6eN00ahZBEjGWlCl5bHQixTKr4T49EOvyXQRDfrraVToCPZO6vwrK5oLbft5AV///ZJyP2R7AY5Vj4gST0TJ9dghpjFKFUvYXQEa2Sib1dvBQSXrd86gDbTgLsLPYfBSjRnonjgQianRYbedq47Qnv
 7xU1pcrB
 dsqiT3cQejvSd0NgzQ4b9/M6u+llyrUx+H1nATB8H8S+chf8QeewRjCKhOhXLpuzGTgMqRzLSzBGxFrArFw3l6k4m5ws0oE653IYYYb8tWgjixAIngfvfE83qF2oBBIUblZYDefSU2H4m1J42zw5QC9p+kp/RkiWoxox2W/cf2Ob4P1Zrb8zg7MBasJZFKpYHLsTJ7p1HHSPHn1gY4KImhFTUbR8VT8E+fpf21zDA110VU+dBbxhDa4+jLbRImb9ULn8txOvUpemxO4Hxyj4C2Xq7DnecZy28ZaFCSd/1NKoZke6fRdDHeDhyig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Shubhang Kaushik (Ampere)" <sh@gentwo.org>

DAMON selects a byte-granular sampling address.  damon_ptep_mkold()
clears the young bit of the PTE covering that address, but passes the
unaligned range [addr, addr + PAGE_SIZE) to MMU notifiers.

For an unaligned address, that range extends into the following page.
KVM ages every guest page intersecting the notifier range, so it can age
a secondary mapping for the following page although DAMON cleared only
the sampled page's primary PTE.

Align the address before both the primary PTE operation and the
MMU notifier call so that they cover the same page.

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Signed-off-by: Shubhang Kaushik (Ampere) <sh@gentwo.org>
Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Tested-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org
- Collect R-b: from SJ.
- Collect R-b: and T-b: from Aveline.
- Update subject prefix.
- Rebase to latest mm-new.

 mm/damon/ops-common.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2f3bf86a221be..f88c6fd189fca 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -64,6 +64,8 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	bool young = false;
 	unsigned long pfn;
 
+	addr = PAGE_ALIGN_DOWN(addr);
+
 	if (likely(pte_present(pteval)))
 		pfn = pte_pfn(pteval);
 	else
@@ -83,8 +85,7 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 		 * Arch implementation of ptep_test_and_clear_young() may
 		 * require aligned @addr
 		 */
-		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
-				pte);
+		young |= ptep_test_and_clear_young(vma, addr, pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);
-- 
2.47.3

