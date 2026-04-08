Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44AAB10F9968
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 20:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 980A96B0089; Wed,  8 Apr 2026 16:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 930ED6B008A; Wed,  8 Apr 2026 16:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9CA6B008C; Wed,  8 Apr 2026 16:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FEFD6B0089
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 16:23:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 15E6D160288
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:36 +0000 (UTC)
X-FDA: 84636514032.12.C1B16B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4109440002
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 20:23:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E/izRV4W";
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775679814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7hGKGZGeLjF560FpYHuHn8OsBr5eDLDlL3Qi8Vk24g=;
	b=paOpklBEL8Rff9zuglnl9HQDNpk3jBudbyWJjsnFel4xrPUWi5dhJYCqg772L9CAPPr1IK
	HH6C/URigJnuBnME5SVk3rbESbgGcchBISHsdIExNkfrQlOhia2cvyi9i+YhMoGX/R3/6j
	XBoPjowzvqwoKPlWcQjnWlN3rmOM1Fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775679814; a=rsa-sha256;
	cv=none;
	b=5jAZDkIoxrCWgTLzMaX050eFSZzvgqk1sbk7352WKgWyYqnqHB30IkFCnEnoDHqNinsE3N
	BBCmlJFlQD65/KvpwrZyCcUrIT4x81pB3sH+ADB99Uu6pgVw1Owlwlib3WjepO3Gcc1USF
	S1qMgibeKQtHMyBIQwdwTta7Se+EyXU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="E/izRV4W";
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775679813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+7hGKGZGeLjF560FpYHuHn8OsBr5eDLDlL3Qi8Vk24g=;
	b=E/izRV4WKMMINTXmzcZSnHbKD4BWYknoq6260tsWRmDAVceFOawAWouqVjNFKgm8PJgcSC
	/+oO60vXW6n3BS/9FFC/aSQspn9ceoZ0W42V1ftfB7D28ZMuJdzEssMsICn++aEdtC/UYO
	hNgllma2wcCq4DeguKn1RDHON0bQ0TY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-570-2BpvvUxYPdC4kJPgcnusLw-1; Wed,
 08 Apr 2026 16:23:30 -0400
X-MC-Unique: 2BpvvUxYPdC4kJPgcnusLw-1
X-Mimecast-MFC-AGG-ID: 2BpvvUxYPdC4kJPgcnusLw_1775679808
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CAA51955F16;
	Wed,  8 Apr 2026 20:23:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.88.140])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4FFE2180075B;
	Wed,  8 Apr 2026 20:23:27 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v3 09/10] mm: thp: always enable mTHP support
Date: Wed,  8 Apr 2026 16:23:04 -0400
Message-ID: <6dea717fe8c86003e7da33c9a7623b834649d5ee.1775679721.git.luizcap@redhat.com>
In-Reply-To: <cover.1775679721.git.luizcap@redhat.com>
References: <cover.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: TcHrH3n-8yIn02cy5vBXvBG4HTPNHnByEe7mVCKkvsY_1775679808
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 4109440002
X-Stat-Signature: o9p6c9ytzos3th7rm5abffp365apmnr7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775679814-839758
X-HE-Meta: U2FsdGVkX194zT56hs1WmYj0KFmokP2d9QGzw/2IDQtMxiTvygj8+1KAiCtBE9qkyE7suJVHktWAbt+JxtTtEMo4WvNmx4ThOKghKd61tgXdU94usmPhGOMq/Om2vlPKYEwun29SC8nhl1bzixMo/cNSmOytSwXjCdf1QS16cF4pOyll+GMhkskiQEvEwqUIRQqA3gHBVcadoU5Yn03+RQitzNeHulS2DXAso7scwVgjpaWBwB91W/0RIbYHtXdy+EmffMIQA3gBddErqerFpig6tcq/8BAdt9gF0plxgdkYiINHqE3VAuObkd32zwNhdISCia8TvKezYmG3s++Aq98cHV8ez3YUV18t21XypP6UPRTxPBUxMqsnbGhl+zHNblhc7U5i9i0SazBvKA8LAk2L/nEO8ZKNGrl32l9TVwge6LwrLw7ZY0gvc7+DDwOGMbZ4dVsvzpNcM60+hHQQozQQu+6AKfVpIhkW+Go9wHanbPGZOmDw5B7zB5l+cXKXSMkTspFzn1YAvIj7SPWqMI4U4no+nSnhpQjvXiYbPepA1LKQKCYA1KLZCvKzmF7y1E0itjHvELWZnPjE51EsXkbgZ5HC41B/hTjKOLbyYUmJHLIjEWlotiqsTm1tV4Ze1+LNlw0j0ra3JZ0Ejyq9Udw0ZBwSn2qApNjjuqXfDGbWeZ9OH1+weBqLrvr/4RyRn6yDSpJl0dJ9aYiedWpHBtm79DRSb2wP1JO3XgKbs3tZXbOgwsWVQgO2Pm6l+MxKYb3idMYOdV4KUhCxOR57eZ7NP9dFQ20mUPhEWw4SJ9s7UCD8Cpt6XEfJGlapN21yjuxdl3AhyjKXiMCwtuzgOj2UWhjmzCmH7BwcPqynjuU7ICLQV/3JuZ36kUn5MdnY3sDlieX/BB+3KtC+6bzWKA7RuS3F5DDquxteukoez2EQA9zDQBBF4yTAIfgU39eaNRBXqDERP2b1qN8CYGW
 oibxVliA
 J+JebdN98E+zVfhe+46T70zXEIOvByKhAWNLcoWEfuDeWhUyVk2XHKik3+tREn+Lcsbrqg81EPvC8KYnL3kgj4l1Elu0E2pWf5XdUTzWV9It0oaUQXC2lPjQXNO2+i6Q+4adwPRWYQKFcvD7P3yvjgSJxZtGbBcaa26fwe9sU/qEbIiAgDO17UmhmDUDIVvPJWL7CZshbpWEH7+EMBXLGCdZTIvrXKKEwmdecvIniKTqErUVe7aDVJMnQCpOK+rmh4oHnjR8GBqdY+nqdaAq83dNRuwr2HRNyo17a8XUeTYVqk7Taqxz195nAMbVlyLD1//Tv8wVYDDmY3Wc/RNCixgVxkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If PMD-sized pages are not supported on an architecture (ie. the
arch implements arch_has_pmd_leaves() and it returns false) then the
current code disables all THP, including mTHP.

This commit fixes this by allowing mTHP to be always enabled for all
archs. When PMD-sized pages are not supported, its sysfs entry won't be
created and their mapping will be disallowed at page-fault time.

Similarly, this commit implements the following changes for shmem:

 - In shmem_allowable_huge_orders(): drop the pgtable_has_pmd_leaves()
   check so that mTHP sizes are considered
 - In shmem_alloc_and_add_folio(): don't consider PMD and PUD orders
   when PMD-sized pages are not supported by the CPU

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 13 ++++++++-----
 mm/shmem.c       |  4 +++-
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 86e489c0a150..6de3d8ebc35c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -118,6 +118,9 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves())
+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -125,7 +128,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -787,7 +790,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured)
+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
@@ -809,6 +812,9 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves())
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -908,9 +914,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index 613393eae5a9..b49a30475cb0 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1839,7 +1839,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
@@ -1947,6 +1947,8 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		orders = 0;
+	else if (!pgtable_has_pmd_leaves())
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
 
 	if (orders > 0) {
 		suitable_orders = shmem_suitable_orders(inode, vmf,
-- 
2.53.0


