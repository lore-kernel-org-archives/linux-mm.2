Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15674C624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6D26B00C8; Mon, 31 Aug 2026 23:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49D66B00CA; Mon, 31 Aug 2026 23:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12266B00CB; Mon, 31 Aug 2026 23:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD0F6B00C8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:13:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3A80C02D1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:15 +0000 (UTC)
X-FDA: 85163722350.15.8F48C0F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F917180005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:13:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1Ex1FSt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788232394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jaZuFD7TaK5q+SRf/M6wNF+Sb+xKBaTWhSdcsCrRx7E=;
	b=zBpIxyL3ADtQTSEfWSoPL/q1fqpRGHAbNmU31+b1H8ixPiRPwNSUs0XKRQcLtdv4/ipS+h
	/Mh2AS89jOhR58t/rmEu+X9t3sfU7ucXZi+uaBCKmLuF7rSucHIuai1dY2gjI5LbQoc28R
	89obOSZuohBzACcuSYHCXQtd8WtUq5M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A1Ex1FSt;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788232394;
	b=2SU3aWoVC3BcgRQeGOImb6tarf2b1BgDzJ8y1KMOQaW7+OJXAGRrCEGMXiiTF2GToMq5Ze
	uZLgco8ppGCkC+9BEJl7lxvi5IBkOMl1aa/Zzv9So/sUqf0tizLcDpI73MDgw/6iKvYvva
	o7fOwZRM5DjJucvNzCbF69msKzm4cno=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788232393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaZuFD7TaK5q+SRf/M6wNF+Sb+xKBaTWhSdcsCrRx7E=;
	b=A1Ex1FSt/JK2TJ9/5aim4twxn92xGQRslz4DjpafxTwdE8vTddSTjbp3TAdLaDhgIkn/yo
	hdEWPQnd7WI2u+nY5g/Ufl0rR2D/n2yGzqQgVDl1DlGxNJGwuKW2fMRazEdyvubIl+Diz2
	Ub2egFRiy51q3aifRsDyCl61edrKmyk=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-0-t71zyqNBGa9_pVECkung-1; Mon,
 31 Aug 2026 23:13:09 -0400
X-MC-Unique: 0-t71zyqNBGa9_pVECkung-1
X-Mimecast-MFC-AGG-ID: 0-t71zyqNBGa9_pVECkung_1788232387
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E9281944A8E;
	Tue,  1 Sep 2026 03:13:06 +0000 (UTC)
Received: from fedora.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 181EA18005BD;
	Tue,  1 Sep 2026 03:13:01 +0000 (UTC)
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
Subject: [PATCH v7 06/14] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Mon, 31 Aug 2026 23:12:10 -0400
Message-ID: <23277327a26a0bcdc6efab1f699d266bbe729cbd.1788232334.git.luizcap@redhat.com>
In-Reply-To: <cover.1788232334.git.luizcap@redhat.com>
References: <cover.1788232334.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 6SCr6j9gelGCkhvirMesczZyYBE1kzW-Y5xgFIrtCKw_1788232387
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F917180005
X-Stat-Signature: 7771ro4y4dd7zqqo3suw6pmr3qgbinmb
X-Rspam-User: 
X-HE-Tag: 1788232393-817398
X-HE-Meta: U2FsdGVkX183y/t2BEn+cPUX6v0pkg3Z+9U4GZ0lUrBMBwkfFRng0/Kf7loy6QQ62y8Dd01h23dGGUP9NPEUAXUTM+Y4JtG2QjAHT6us7o5uaSEua24qKsON09hKJrkP/3A9TFK/hNJOpag8cG7xiiN1i8tJCyPKLL/wLd5tjCXe5YDitzoDVHbILSZ7oQQn/gbvXlzZT0JxJq1l2E1SVxdhM9F9Fy2AhrfNB3NmSp08ZIULkOL4uYssN2GZo4S+1IbxKKKrjr4x/ggIgpAtPhetDJjbaSnO7o3cVSCQ2oVj1ZX3uZjpUEK+vaYzialtNerAU7zG8RNa4sLt5wVNKH+LQ9dkJDRUR/732k/5prmVVc3DbUw83ZEzjWgxFrWVaI2KXwPNsnV2LEuP44rfZPqvA5IWX6nctnL47d9fNA74fAJXNKEHj7vSFRUo1hWYQ7s4U+P4e3K+AdIR7LmjWlAXSlZLSZc9f7Qrb5Kh3eCQ5ekRku/JqZk9XM1fPEzTo0zGsTyzc0aaWiljgruJPbe6uxPhEav626jYVf6xO9n0VqwiDaQt6FGhx5a1W0VRW1pPAw/NYhya+AH81VZ0xcHuKdg3HHmtpTdwfbuD61adI7i/4h5QL1Yz1uBwAKnSohNe/H7Xg84uq1G0G95xE3uTXrb2WBh7FcVbrdi4cuNxyxZmdx81/DSK5Shk2bPcdKjH0Re0SuPICrgCEk8IhfOAKQyIICdHSjjfyxFXcUm7N+Pju9890qfEDDRYykGHtnxAI0GaXCy2cOr4kjE5Iyojrc8DIafUUc/rS2GIVXiFMQZpo3fgaCOZfq7hOHWmg75hf+h2vMG/aXkv1qSwvRDzSsHGVfFUR1HUIHwVIUR+Xf5JxBUI92z8neXcP5acnWABgc3JNEZS/BAbCiOYQt2mEIcVWyrWqUPQmb2eFQbSJxodzcsGqzH0qnyVlKFFGfbHgtXilag7H9XDWvQ
 c/IOGxTx
 IHsJVrzEuvvbgfha1SPXE2xLZ5dJD3l1q99Bzu77/XjmqLqitSeFJOj5eK2b1d//qJ4HeIIgrEpr7siWtXrccNkqT9mBORcCmSqGTYzrRDaXQrSc85Tt7CmhmeVHGc3D+CHtNItZ7RbOqWezt88wj7kne8fRVsu6UV28xfKvlcBNCic8BxA9bYkXNCXyRfJOqzqcEY/SJvbafkpLfyRTpAmaBIevFZ4xwwqLPVOCM0zt084Aus4SQ5laKSaq5nbH7BG0kdF0inyxpYuA7Yghg5WJtTkuX69dKqFC7wQrzmbPaQBEKjL4HeOWEJe+OhSruDorWKBwaPo9f+pr1WKgYB8/wCtnkOvzHAMXj8r2AiryXFzo/vVZCSu8HUc+Jmh1YAR+wLXsK0qvLr+mnqqfixoG+TCbOgTTysqOM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
instead.

Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/debug_vm_pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 2875fd22d7bb..25038b74c7bc 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -177,7 +177,7 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
 	unsigned long val = idx, *ptr = &val;
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD basic (%pGv)\n", ptr);
@@ -222,7 +222,7 @@ static void __init pmd_advanced_tests(struct pgtable_debug_args *args)
 	pmd_t pmd;
 	unsigned long vaddr = args->vaddr;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	page = (args->pmd_pfn != ULONG_MAX) ? pfn_to_page(args->pmd_pfn) : NULL;
@@ -283,7 +283,7 @@ static void __init pmd_leaf_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD leaf\n");
@@ -688,7 +688,7 @@ static void __init pmd_protnone_tests(struct pgtable_debug_args *args)
 	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD protnone\n");
@@ -737,7 +737,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 	if (!pgtable_supports_soft_dirty())
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD soft dirty\n");
@@ -754,7 +754,7 @@ static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 	    !IS_ENABLED(CONFIG_ARCH_HAS_PMD_SOFTLEAVES))
 		return;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
@@ -825,7 +825,7 @@ static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 	swp_entry_t arch_entry;
 	pmd_t pmd1, pmd2;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD swap\n");
@@ -906,7 +906,7 @@ static void __init pmd_thp_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
-	if (!has_transparent_hugepage())
+	if (!pgtable_has_pmd_leaves())
 		return;
 
 	pr_debug("Validating PMD based THP\n");
@@ -997,7 +997,7 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage() &&
+	    pgtable_has_pmd_leaves() &&
 	    args->pmd_pfn != ULONG_MAX) {
 		debug_vm_pgtable_free_huge_page(args, args->pmd_pfn, HPAGE_PMD_ORDER);
 		args->pmd_pfn = ULONG_MAX;
@@ -1249,7 +1249,7 @@ static int __init init_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage()) {
+	    pgtable_has_pmd_leaves()) {
 		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PMD_ORDER);
 		if (page) {
 			args->pmd_pfn = page_to_pfn(page);
-- 
2.55.0


