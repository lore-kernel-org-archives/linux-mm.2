Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD58606A32C
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nJWLtLVs
Received: by kanga.kvack.org (Postfix)
	id 9EC876B05B2; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5AD6B05B3; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D90F6B05B5; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7287C6B05B3
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03A3FA85C4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
X-FDA: 85387204602.04.4634BC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A7A9180002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nJWLtLVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1pJ4mfGksx99HkJq8FYvOx6HIQ0+ynloGyB5SLePdU=;
	b=jmPEgtq4GCZaBqZePuGbAvamAhrxkUlMSCga+3ozaOZqx5OQrOK4t4R2b0/+0Ieud7fpm5
	H8JTzwY9PmZ+g8MMX9B+zizAVHV/1QrQnYlJf4CtwX8ZJnfochd5m3FfkYiw0IeVyQnCyj
	pDMI6g70qyHDbTuk3JWXetVqYNp1Dvo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nJWLtLVs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553399;
	b=XjLdXqq4EomxEdThFEuVTfCTEiY4r+Zv84/xycZAwCDUCJ09vUgFkkRwddOPpRwlVU6kUQ
	F6cjJouIcK4azHfBpU8DApqvxqmAYi+2mfgt7yN3iDbLM8IlwP905qBwlSKWn3G8b6L+NJ
	AwYVUVVoIDx7WDzH+hrhaZIOCBO3D64=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B509043EBD;
	Sun,  1 Nov 2026 17:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74EEC1F00A18;
	Sun,  1 Nov 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553398;
	bh=m1pJ4mfGksx99HkJq8FYvOx6HIQ0+ynloGyB5SLePdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nJWLtLVsdCYbZA4+cjGbxi6M0J9O8mfTXbAm5CRGXomgvXSAUq/D9DfnSl27G7prw
	 up6J/VDaP6Fckh+RxgIkQnd4QUG5pNOyreJC55WY4rg3q0a6rFRv6J2/sbObhjDeJ8
	 vX2lbQZO1yIqJhITenS9963uinxRDkwgFSx/Z31YesSlJWeDI/BYomtZcGCyvjrH6Z
	 bhGoX6vJ5wr7Axc8EqtVX7vicLNdQBn9eSLdHDHBGL6xmLoPXNQg5bdOMR/3GqioIk
	 22gqLcMVRIC0yo7yLXjysIa9BX6otAs+/ZJ3ojXUDUlT5o6eljxG3wmnHCBJl3N5FQ
	 LXqRRG04YekDQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/6] mm/damon/vaddr: advance migration attempt in folio level for filter out
Date: Sun,  1 Nov 2026 09:16:24 -0800
Message-ID: <20261101171630.81477-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101171630.81477-1-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6A7A9180002
X-Stat-Signature: 4o6xwwh3ecqcz41ybims5miycgzszehz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793553399-976508
X-HE-Meta: U2FsdGVkX19sQgDEJhcFYGQsFWPAJqgSyOV42xsg2fqj2wt01BELrCRczDMvhz0MDYebbFf2ugZ5x2wxRgxGYExecMNoa5qxFnuXWc1Ck2yLoL3qcggUjN5WbcIbTpEqUBPkLXwYStGnNzhN1sOIV+xVdPmLFEQ9zqgy2dsVJVbX0fGZOpXLALrDkwc9U0up3eSnbETqGMoPccHhxXK3mHM5nCDW1tLPMLZ0Ah0OMp7ssP+0R+7DO6FjuKQEFuKp8caPSCAp2B5LJBqpdLydGmp0MnItl7t9Ea8nnG2uHB5l3PUsVrneDljTcZGxr8XWSoPmwSBCThD/1QrIz12Yr0Xle3cfEv3oQCq7HjCrl9QbXRJJUYeOMgsZKaYH30w8FPAihOF4zET4VZiXAGE1QsTYb4J8Ndm/HWw+qOVB/jEs8Xd9Ilxh8orJw9tENUSBok7IaDnJdlM1cKigBxmTcu3H3ZiN1QAWE7RtNjeDXtAVbEuGItLSGXyuHTJoaTyuP/XLUv+R3lPBUfeMMsE0xzQW20GII/FqXmq5NZVatP1/RqnjI5CywNuxkQavLhik8xLNJxVDpmaaeKLafuA6XTjOg3J+OnoPdd0Kgo+rYpFv63LBMLdXQanoPjUkQ+h9EUJDT6aMkhzPkfXFkW9vVTKsFBmvk3/IxkqdZYobKbTWViGM46iTVqv4G1Q/skskyqFs9hi5/bCPhrJzX234sgBivYfgM7/lgNhnK8KXKgNu4bnU1DqjEogWO0D2/1eVpMMcvIVIB3j5oKFFwRrxC4BY+Vn2IBcQXThhKHGgCA/uGyWcwydpUvM4HA71IYXFYfx+WkZaF7ZrfQgLr0fsm6beuvqu5MTFCDtR2cw8ScVj4Qpj7xIIN5rJcfUU9uT23pe4aaWNSvvd+/amo/knoa3j0+mt6rW3AsuwN/s8VspSnvtIGDVDO141XgRhDIFD1XPR4F9ysif6EFtd2me
 mNz2VxCM
 QurwH/tqdwL4wB6glpwBQ7t190PyFRnGshnNN3d98/q0nebCRfinhE3FMA6eizPshBDzVOqbqI5yjJSd44aiC2jJ26QxLE9AdDvMcF9ey/NAadUyX3a0NazRRt05+Ga7rXuQNRuoBLAaFtd5sACq60TsxWEOOcNgoMSPfYq/JPq4tXWPK6sVMUU0HnfPdngLsrWMqgoMEC+l4U9oVEbRRDhWpffYYnNuZNEqw0AiSpuZMGFYytXJ5jzyoRWaA68ohCHxdm/jR+DRQCOWcdxHyjCNMqiNk5zAJiXV3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damos_va_migrate_pmd_entry() finds folios to migrate under the given
pmd, using a loop for the pmd address range.  The loop advances in page
size if a given folio is excluded by DAMOS ops filters.  DAMOS ops
filters work in folio granularity.  Hence it is more efficient and makes
sense to advance in the folio size.

Advance the loop in folio size for the ops filter out decision.  For
that, do the folio size based loop advancement offset update before
applying DAMOS ops filters.

Closes: https://sashiko.dev/#/bug/linux-67c34df7-6dfb-4e18-9ce0-0d26915e5785
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b549496ea8e2c..c271b6d63c027 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -881,12 +881,12 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		folio = vm_normal_folio(walk->vma, addr, ptent);
 		if (!folio)
 			continue;
+		page_idx = folio_page_idx(folio, pte_page(ptent));
+		nr = folio_nr_pages(folio) - page_idx;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
-		page_idx = folio_page_idx(folio, pte_page(ptent));
-		nr = folio_nr_pages(folio) - page_idx;
 	}
 	pte_unmap_unlock(start_pte, ptl);
 	return 0;
-- 
2.47.3

