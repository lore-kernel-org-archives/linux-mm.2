Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26C1DE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858066B0089; Wed, 18 Feb 2026 06:01:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822DB6B008A; Wed, 18 Feb 2026 06:01:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738AB6B008C; Wed, 18 Feb 2026 06:01:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F1366B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:01:42 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 008DB1404F3
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:41 +0000 (UTC)
X-FDA: 84457286802.20.186C108
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6A19540012
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WAioAEop;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FMh+rgDyw3xzS+jZgtuRj4r4Zqfm/8GUbj/TT771fek=;
	b=VPVH+24nW9JAqeddKjf2oWSruY1B1dQTa1+VGl6yIUkaZniCl6mFPPx8UAXCGi2JDIl2mF
	DfNhl/kZVwPBqctDdn1lO6t74UjjvBT65ouJIQwh9PidQY7p1782oil5ZT8i57QwSQiLCv
	LG3som2rlBB0AWSNNGSheOHXKRa2klU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WAioAEop;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412500; a=rsa-sha256;
	cv=none;
	b=33ntzxYbw7zOhPgCEwGsfa4AOz85pIUgyZwnN8bFwGJzV7sZZScolI4TjJ0TuN7g1PrB/V
	PPZnf0wYN2D4k5m38QTOeVzQMG+EASUK5bH31ZidAifGIMtbUxXWEoo8q9t7skU7MqTZUF
	Qg/4U6H4qGlSmjw8uuLAD/ce5uMAmSg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EA5BB6132F;
	Wed, 18 Feb 2026 11:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2054C19425;
	Wed, 18 Feb 2026 11:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771412499;
	bh=8tgzchpV8d+z0g8pxmYh3QpOKC5UJ4tOe/CguvbW/eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAioAEop8PvlX0aN+H42ku2aA/91uZ2+X+OFiD+gYB5KrXphyNuGFEql8U2CwZOOB
	 xuDvlffJvNe2ESHvIOx+y3/rQYcUgowkbQAKb5MZR0zrsQ0xLx+RJ0uYtc7YM33sU3
	 Nmg8/DJkF4EeJrXBxBnnF1eStxDnlRMdeFAYzOhKdjFAZN6jVGcy6pWnGBpj2GDZPf
	 w5mvZH55aMxuuVUqqjTycLCq6VPgMy3KFl06H8ebVxprQCYtZgBTILT+We6sXy0O6J
	 /wot86el/wnhkbKFYJl2P90TKpXscqWgpJ8tZzlGKaNjTX73ODe094Q+C1ww80GmPO
	 u077j2bqbpK5Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	Miaohe Lin <linmiaohe@huawei.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Subject: [PATCH 5.15.y 1/6] mm/hugetlb: make detecting shared pte more reliable
Date: Wed, 18 Feb 2026 12:01:24 +0100
Message-ID: <20260218110129.41578-2-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218110129.41578-1-david@kernel.org>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a6h51qq8euqxautaod3gysieb8exk385
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A19540012
X-Rspamd-Server: rspam01
X-HE-Tag: 1771412500-734431
X-HE-Meta: U2FsdGVkX18FIgr6n/gvxaHWMsuOw3mPSRCRI75WF4TJyg04S4HIm2QbD0W/gi2hFH2+dygvQzHzwRUzlVzv5Cqi1/JRJIhUm2BD2g0GLTl2r6ksmq2ofCOOSrcfZfkY6dhJRpdkIo+Um6ht6AdppOaeLUD09YIfiqENAArEvHLCfP7HMXot40YaRZNnsb1jnHSNI+GeredF5Od7c/iWmZTi0tuc+aLUq/Ex15/Mom4bPGOHJIlbGYa4CTpAKLFTYmCynPcQsHeTIq5a1wn7iyNrGgL13FhK0FieWLor01dJKfIh0oi1n1Nsd9AHwTeltK73TRDwiAT1/xwM/invEEW8cIohtDxSwm3MVI1x2h3HvWPwhvVmYOD9r2CQ1HNLLwHXGOnSUWkfygPj8eJ8xho60Vzu7wGI85pQyMI2EZdu84D6hgnzbznTrSkrHEb5XLPP0IwiMtsXuQR5OmMna+dSWd7qVY8HLZxyivV4/xlUf3QEPxD1wqj9WhBfFD4VlULC//btjV9t1nYfp2hgKenSpiScy9wlPUUaSD8IJT1aXlZcXXZr8Fg0Nq7ki7deFkvnC7nx50jCMIKWGBM58rR/UByde0b5TYRmWorBHF11prQtEirBMNVNMXI8BzWD1Crni2Jli3levxK2/PkFiGcVduJ30eOzX9vPW6BDrxmgf4DdPjFUYuZKwPR17n1n7NcWZITSnAv3gCbAzlZVH1Kwsrx/db9e2YN294yh/VIPiaqxlnB6Z39F3232YmO6a55T3ehhd5rSN86m4uixqwfwz8dCvr562rZlm3kj9A5nS1zeu/Vxdd0U9Uf5pKDWQrknu4oPx4uFAHHjLJ4tOXg5cG8L1DVXWJPJHuSa2zxjwSy/0CYeHIg9ktdrgSSM5P35vm+FuhY8xe3EoWF40tHfw+2TpIWzQtT8QC4tRzZSgGAx2bZHK8XBGjdGEt/Yph7WnJ1pNaa7ReOvGgB
 K5pfW7F7
 vzHBGEgm/tMyaUt2SIVwYOlkySZ2us0tL3REiM7oA/XO25/mFugXNEyqp2yVwi9xcmaGVjkz03J+om8YLob29HQRo9UxLMZC0Z6InueKnaZdagh8CjPs2nBKx2pTH1Tne6Qwr27FCx7hpreSDcF3M6hOYqi3G92YDey0/ooEC7wWoS6jxAEwr21C5W3FgKf/6+GC3kEHj7ZB9uSvOftm1yvbsEES7PL7Kp/IwVGAhXsvCLddo3boYNMbN2RXeQ+hMqV6gATQlDFnW2qyKI7r9kZ5MadW2DS8viBytka/SrtB0V9qpesbPqA7k1vnhQO2xKrq+g/yrwCiZrFJEeVtTQPDA0GDMFzmIry3GcBm0ejEmtb59UPHX1yGZAQJ67Qu6U2KvhLa5yevfRJWZVyXhuTZg47sKOFePWiVM4E57j6VgoVUbQFnkD570zrpXVrNeSaWmIe8Z2fBZl24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Miaohe Lin <linmiaohe@huawei.com>

If the pagetables are shared, we shouldn't copy or take references.  Since
src could have unshared and dst shares with another vma, huge_pte_none()
is thus used to determine whether dst_pte is shared.  But this check isn't
reliable.  A shared pte could have pte none in pagetable in fact.  The
page count of ptep page should be checked here in order to reliably
determine whether pte is shared.

[lukas.bulwahn@gmail.com: remove unused local variable dst_entry in copy_hugetlb_page_range()]
  Link: https://lkml.kernel.org/r/20220822082525.26071-1-lukas.bulwahn@gmail.com
Link: https://lkml.kernel.org/r/20220816130553.31406-7-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 3aa4ed8040e1535d95c03cef8b52cf11bf0d8546)
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 70ceac102a8d..c0719ece2b7f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4304,7 +4304,7 @@ hugetlb_install_page(struct vm_area_struct *vma, pte_t *ptep, unsigned long addr
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
 {
-	pte_t *src_pte, *dst_pte, entry, dst_entry;
+	pte_t *src_pte, *dst_pte, entry;
 	struct page *ptepage;
 	unsigned long addr;
 	bool cow = is_cow_mapping(vma->vm_flags);
@@ -4343,28 +4343,23 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
 		/*
 		 * If the pagetables are shared don't copy or take references.
-		 * dst_pte == src_pte is the common case of src/dest sharing.
 		 *
+		 * dst_pte == src_pte is the common case of src/dest sharing.
 		 * However, src could have 'unshared' and dst shares with
-		 * another vma.  If dst_pte !none, this implies sharing.
-		 * Check here before taking page table lock, and once again
-		 * after taking the lock below.
+		 * another vma. So page_count of ptep page is checked instead
+		 * to reliably determine whether pte is shared.
 		 */
-		dst_entry = huge_ptep_get(dst_pte);
-		if ((dst_pte == src_pte) || !huge_pte_none(dst_entry))
+		if (page_count(virt_to_page(dst_pte)) > 1)
 			continue;
 
 		dst_ptl = huge_pte_lock(h, dst, dst_pte);
 		src_ptl = huge_pte_lockptr(h, src, src_pte);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		entry = huge_ptep_get(src_pte);
-		dst_entry = huge_ptep_get(dst_pte);
 again:
-		if (huge_pte_none(entry) || !huge_pte_none(dst_entry)) {
+		if (huge_pte_none(entry)) {
 			/*
-			 * Skip if src entry none.  Also, skip in the
-			 * unlikely case dst entry !none as this implies
-			 * sharing with another vma.
+			 * Skip if src entry none.
 			 */
 			;
 		} else if (unlikely(is_hugetlb_entry_migration(entry) ||
@@ -4423,7 +4418,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 					restore_reserve_on_error(h, vma, addr,
 								new);
 					put_page(new);
-					/* dst_entry won't change as in child */
+					/* huge_ptep of dst_pte won't change as in child */
 					goto again;
 				}
 				hugetlb_install_page(vma, dst_pte, addr, new);
-- 
2.43.0


