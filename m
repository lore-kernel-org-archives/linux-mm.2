Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8140BE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31B26B008A; Wed, 18 Feb 2026 08:06:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC9C6B0092; Wed, 18 Feb 2026 08:06:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA6E6B008A; Wed, 18 Feb 2026 08:06:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B97C56B008A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 45CEF86838
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:12 +0000 (UTC)
X-FDA: 84457600584.11.FA773B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7EC222001C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKWrxb4U;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgGReFEUOJ0CSClaK4mJc+Y+4G1i2MN/X1ND3EJ6Zv8=;
	b=dYiubfZKOnj6/krDtHWoytcHhqnBJmeg/DQsELHQA3T8yhm+4Km8rpRtqBuvkeKCGI10fr
	5VskKTOiPvm6rNL45SFWLhdVUSjGjk9gisvdJ5aPHyF6C2eHAjIBoghteGFjKIIFVBtnkr
	aK1zSyF/91F84z8D3JoCr4VKdMo7HLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419970; a=rsa-sha256;
	cv=none;
	b=bKZgN4XcLADao2BqeYL7cVSvqRoYwGW2HxkjZZQalE9zu5Ze6GzOo9Mbb26E7m3fK/daaB
	HV/gF5GAIJ2G9LRa/EwLvjyq+PzGSTu6EBjT/yOeJIeDWobyu0mvk9ZJ+TArBxfeDNgmt8
	Wtn3iGZpsRT79a0t8Q9M+pr+A9BwQBE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kKWrxb4U;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A4BED405A9;
	Wed, 18 Feb 2026 13:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F87EC19421;
	Wed, 18 Feb 2026 13:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419969;
	bh=yPQ64QWQ9T5wbUESH7R0G/IVUMAoQRQgu3/n5Wr6IrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kKWrxb4UfOYype6XihUVGv5QYEukedHvuEXBMMTmSdtlZK+u8xZTaUY5RUTnI1Nl/
	 gc2cW0K/elejz0o99g0cUUpJs4fLpD8yzFtMBuqEYcNmb8OX6OQW/11eTkngH7HUAt
	 X7/LhU/ydvmeposd4O3TjVtgVJTjTkrmNPO1Z8oJZZhgt8N4O8NpwKr7IfuF50JuDH
	 5RTnz1UmZM4JebcnLs5zMboRLHa3Ds2mamNBRaHaXflJ+pz4G/4qWmn2SmrD+kmGpA
	 /UIr8wFhCkY+TVoyyyCVA11M8RUeQdBErLp/igtmOGrQbMo0ktUoCNrbQWeKvTTSFZ
	 xiLJfW1AjA5bQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 5.10.y 2/7] mm/hugetlb: make detecting shared pte more reliable
Date: Wed, 18 Feb 2026 14:05:47 +0100
Message-ID: <20260218130552.55727-3-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7EC222001C
X-Stat-Signature: i13txwwnfnxqugyahhwy4kxfxnyu5ns7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771419970-287450
X-HE-Meta: U2FsdGVkX1+9DntREnBeoAXp7w2hPJMgmlKSgtzMSzrqLAG0oOPDNtcfcISOmZ3UVfxFwMJbPPUbBmOiLT337HLrAxH+yWryM4W63yK44hFCDsgcMeDpu0tBYndc0OtH4w9FXbOqS5+04mHXZNP+Jls20Fv0BYQo3PgvSUBvRYuWgPrbR3ss5Im39OXDMFc0Svs0tRZ/au88SKWgQRuC4dZqcx3DTrf+7Ki8vKsQ+kV9b4ymN1vkL1qbNvdMv6ZhpHYEAAK60dwAoeGj9ZT3pmkIyfp1HlBHby8AHbc/mmhqnvDcJ0Xm1eXEwH5zLTr5TZfzbVqXotX+hMEdjJxafqHSfgFSV+8jyNk7WkXK5HGghC4MnTUIfIxy/GYTX0aYjv92qabmEayMtffdD/4wzNESHlivV/5WqOrl9xROOmLO0ehcQSbiSY8CfWce9cuaSkXpJhheNmCspDBhQhjIz6sV3zU6WeP4BvCwtX60hOMrlGDPj/ixaiYqHMZ1+Iz4vIkYF4eU8Mi3C/6ncAkWjJMvZ/U96SzmtlAtlioBOB0olANEyv626lyWngstbY7GJ94to+NKoIOEnbjqUfW7YZ/ewFgS3dZ1kVmc2jGuk+jSsiXMIL3uZf3oFhrRSKUlE36XgXZ1Qff1l0svOgTaWAkbmvA06bYZ54CsIIFoqwghnOFHmliDX53LM8HiBhScNAM/1aQTNTdvALwrZYXn8dnm3FuZ34JcnD8jNXYISajv8am7Jpk3AY1fGOZp8SiXIPNiQvRmHizHENOR4HH1xIGuon/HpDoSiv09rnMhW+141xXOpHmNrXh5bUBBdnkI7NoVmjY6l1mgF9UR8/oS42ieD1Ahcr+ZzBLFjDspY2gXozqQGWdOzl7fitNNnc9PXcW6pXf3JlhfejgZoXL7U5RwDeEAXfQ17LqPIKRRQoqUXFIO7prf+Rsp5WZAFnFQy4Ly4Yg41l8BeUQGMLR
 GqbU5H2z
 elTEIN9NTkNenhBJGREzs0VZW9A9CxcwxRZp7OCAUhKQBGJads42+/l5tsyEy+WagAFWYPuwPKC5biFhdrO8cmW4qql7D889FLk3KttlKh2hgrUv+dYomET3xUL/ACQFYFcQQET3jBz+xEKUX30Lqdp/LOAIIUGRwSQu38PuG4cGBv6LaI2R0dWHSwGG9blyyAxQRdEeiDb2Cp2HSR/4RUfkFQnLOOSM64avQAk7X53zrukUR5gyfvWowds5lBiE3+xk2DHkdHPfu+1EquuHTzUficWfw3rTmekRn94XwXNqfB8AEo91SVOpXGObWRKzu4NJYqB17VKVofCyTWHii4sMG/MTEGXxc7KLkLRhBWlPJveTk9uRrUUMtVj5A/rqpp+1/W5cuBFAWYMdFVwPQs+PlfwDpUdQFHieCsBzkqVRaY/CTrUVDFH1Rboxd4+KEw49JcG8Ep1Yuru8=
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
[ David: We don't have 4eae4efa2c29 ("hugetlb: do early cow when page
  pinned on src mm", so there are some contextual conflicts. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 99a71943c1f6..a2cab8f2190f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3827,7 +3827,7 @@ static bool is_hugetlb_entry_hwpoisoned(pte_t pte)
 int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 			    struct vm_area_struct *vma)
 {
-	pte_t *src_pte, *dst_pte, entry, dst_entry;
+	pte_t *src_pte, *dst_pte, entry;
 	struct page *ptepage;
 	unsigned long addr;
 	int cow;
@@ -3867,27 +3867,22 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 
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
-- 
2.43.0


