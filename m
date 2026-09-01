Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D27C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD63A6B00D8; Mon, 31 Aug 2026 23:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADE86B00DA; Mon, 31 Aug 2026 23:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4DD16B00DB; Mon, 31 Aug 2026 23:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 790336B00D8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E88F71A0324
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:46 +0000 (UTC)
X-FDA: 85163723652.06.19B1F4C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0E28C4000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h88B9BUY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OpWaOvwdnfJBr1Jj4YAaiCB/uPhe5itjUn7qv1f4qI=;
	b=g7M+Tt1vSGf179bmHz4xxcMXp9VbzQrdWRp/yycD0aqi9ZPV0fhq3IGXEU+EeLIIc7Zi7J
	IryU0dQ8XzsXDGb6V68masRX08E4x12wcbcOMg7hkDJMh2k4ChaGuNemBChLm+qkIp/+o2
	XDLOHH7yQFTNBK6JgAOp1iQpg8ub+aM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=h88B9BUY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232425;
	b=EDyLvOXwGF44Vbx/OO5WjOHii/Ia9I2Qy01mCT4V6WjmYJrSh3wCXRurqrY8HJLOp6tuna
	7pS9FnAG24wG1IkAfF1psrtXS+cU8GF+D9JVNYYuiKFhNI2xbXqOW52DERPL8XMtMFbWHO
	a0EbWdCZrd3DP5L2l5m25Z0OmIoxS4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0OpWaOvwdnfJBr1Jj4YAaiCB/uPhe5itjUn7qv1f4qI=;
	b=h88B9BUYgZeVI2aTDBcL9Z7XvuRS/ETXfP6TmZgIwO1pOdvUs2KG8+g+byaA3viBUwfYL3
	zmX+JikHlv8ytfqUM85ZJh8tL0MTtariG5AYkMgOTsSTNc/cpqt/YSKbfMklo+7gga8N5A
	qt/kg7PISQ4xJRkTk1sx5Hz1GVJyIfk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-X8UupBHrPEWy_Dsv-WJmlA-1; Mon,
 31 Aug 2026 23:13:39 -0400
X-MC-Unique: X8UupBHrPEWy_Dsv-WJmlA-1
X-Mimecast-MFC-AGG-ID: X8UupBHrPEWy_Dsv-WJmlA_1788232416
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25377184B397;
	Tue,  1 Sep 2026 03:13:36 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AC66718005B7;
	Tue,  1 Sep 2026 03:13:32 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ziy@nvidia.com,
	lance.yang@linux.dev
Cc: corbet@lwn.net,
	tsbogend@alpha.franken.de,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	x86@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hughd@google.com,
	dave.hansen@linux.intel.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	yintirui@huawei.com,
	dev.jain@arm.com,
	usama.arif@linux.dev
Subject: [PATCH v7 14/14] mm: thp: always enable mTHP support
Date: Mon, 31 Aug 2026 23:12:18 -0400
Message-ID: <0d7adcd340c1703b5eda63bd001537242cee7822.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: K22xCdAS0V9KJHx1JJsor9lo207ivgIsBfjUlcwcLGQ_1788232416
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cgr9t84d4ko3wd89ymwpcbtht68i5n4k
X-Rspamd-Queue-Id: 0E28C4000E
X-HE-Tag: 1788232424-585139
X-HE-Meta: U2FsdGVkX18u/LNKsE1KHKXmgsSY8svvcUFWEJgMEBxnzp9vmnPY7VbKnmdmsxxsjuzfyICa5kiwgQNTKp7jMSQpYL/MOkW4fOnNAGPHOVj6uFTBRuzAaY0fvpUKlKQVbL0wC1yzz37z55r9S3MpeG2O6FyM6n1h5n+8uEt8xX09lDHKsmd//lz+0sl+zkxqsGxDAT8jk+ul/F9HWEBYzCXmltYeQWXPs4WwMqVq4hN8BbcQ0rPodbim7ug28iLWaUUT6ke5DXjBD8tou/Bf2XI9WE1pnl9UrQgNYD14EVNjtFSpVdtah62XOkA+caMYrFpMWprO/J2ZFsei2jp7Cn2JPBuIHqnwvbV2uL8l7NBGRGTAnt6mVPo5dRW5f015hrREoqlOKtf4cL7fhF8/Nqqmc4J2qL6oJhHEb6w+aq6K84od4lgqjZsvkTzBcwSDW1DoXrHEaiXza2w3EoL+H8r9fBlu3vV6a3wZ9jEOodKayif/dL8c76jm27t9IMtDDYM2sy21eUekS6fvBG1FTe/BEMOIc/EkYF2Au13fp0TTXzWKi+CbVmKvnqg8WVfKcGWCK85sKXbayFHIVdTOcvlIA0naezAi5tkQLuDD33gRIjoRPnvea2/sVPPYFwCh46BZjQAAlDu5lmKWlxSR9rkbL92qks8Qe5AxJcGzG9RkQWzUpRpjnEOfAdkWBdmHJ1YKJ2vcvk5pOEsN1mjURAyDP6cMdwr4nY/uRPmkY15WltefwJcMm3AL/zTkLcjrM1J10Y/RQaZL/+B4AFUpv6V6sdNwkq87sh0W5wttMXD3v34t4cmhP8VEwEhe/AQGWAh3v/JFHvkK/Qmr7JIZjJcf0EwDUCpw71nLZl6ZgKj6Wn/u6XqzI+A0lQOYAxex2LY7p9f8wQQyzEOim37s4zn2SiBOXcSc7UH8X/ejg6PquU+S2LDeJASj15oP91DdNLnuiiTILbc+GLlbIIb
 hg1AsFxo
 rFxesdJYLugMGDbBStfZQ706T/TasTN5P1h8ip3H00AoNEFC4TD7tyUwlrmyoBO3j1WCxlOeIvx8h6gatOs4lKb+9o6AWvZAjjetaSreesnrVix9itOdttRW8vXcaHKsbPIX59CUDsnvTBN5v7/RBOHfhE81mxWj+VqI43yJuAoe0uV9bECzupn2U1hs9PYAE5B43IvSnsOl7gGGg0txvE8aVEXvZQ095naVahwFcB6x5OzjlH8QmiUFlhFh+Ph6x8xoIyncj+PW/9/mUPy9BwABUxGKkm6XHGTEIw6a9ydLLqGtyrxJnRc815db1Qkows6A1O7aYEusUsBuQWPxD8NyOLpEJCZW0ydsO1xEGxiLvwzk=
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

Similarly, this commit implements the following changes for shmem in
shmem_allowable_huge_orders():

 - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
   considered
 - Filter out PMD and PUD orders from allowable orders when
   PMD-sized pages are not supported by the CPU

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/huge_memory.c | 25 ++++++++++++++++++++-----
 mm/shmem.c       | 14 +++++++++-----
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d5e65cac6a16..95b2191174fc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -197,6 +197,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	else
 		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
 
+	if (!pgtable_has_pmd_leaves()) {
+		/*
+		 * If the CPU does not support PMD leaves, assume for
+		 * now that it does not support PUD leaves and disable
+		 * both folio orders.
+		 */
+		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+	}
+
 	orders &= supported_orders;
 	if (!orders)
 		return 0;
@@ -204,7 +213,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
+	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
@@ -984,7 +993,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
 	 * constant so we have to do this here.
 	 */
-	if (!anon_orders_configured)
+	if (!anon_orders_configured && pgtable_has_pmd_leaves())
 		huge_anon_orders_inherit = BIT(PMD_ORDER);
 
 	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
@@ -1006,6 +1015,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
 	}
 
 	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
+	if (!pgtable_has_pmd_leaves()) {
+		/*
+		 * If the CPU does not support PMD leaves, assume for
+		 * now that it does not support PUD leaves and disable
+		 * both folio orders.
+		 */
+		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
+	}
+
 	order = highest_order(orders);
 	while (orders) {
 		thpsize = thpsize_create(order, *hugepage_kobj);
@@ -1095,9 +1113,6 @@ static int __init hugepage_init(void)
 	int err;
 	struct kobject *hugepage_kobj;
 
-	if (!pgtable_has_pmd_leaves())
-		return -EINVAL;
-
 	/*
 	 * hugepages can't be allocated by the buddy allocator
 	 */
diff --git a/mm/shmem.c b/mm/shmem.c
index 73281fa060ed..163e7dc4b2a8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2045,16 +2045,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
-	unsigned int global_orders;
+	unsigned int global_orders, disabled_orders = 0;
 
-	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
+	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
 		return 0;
 
+	if (!pgtable_has_pmd_leaves())
+		disabled_orders = BIT(PMD_ORDER);
+
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
 						  shmem_huge_force, vma, vm_flags);
 	/* Tmpfs huge pages allocation */
 	if (!vma || !vma_is_anon_shmem(vma))
-		return global_orders;
+		return global_orders & ~disabled_orders;
 
 	/*
 	 * Following the 'deny' semantics of the top level, force the huge
@@ -2068,7 +2071,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	 * means non-PMD sized THP can not override 'huge' mount option now.
 	 */
 	if (shmem_huge == SHMEM_HUGE_FORCE)
-		return READ_ONCE(huge_shmem_orders_inherit);
+		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
 
 	/* Allow mTHP that will be fully within i_size. */
 	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
@@ -2079,6 +2082,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	if (global_orders > 0)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
+	mask &= ~disabled_orders;
 	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
@@ -5626,7 +5630,7 @@ void __init shmem_init(void)
 	 * Default to setting PMD-sized THP to inherit the global setting and
 	 * disable all other multi-size THPs.
 	 */
-	if (!shmem_orders_configured)
+	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
 		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
 #endif
 	return;
-- 
2.55.0


