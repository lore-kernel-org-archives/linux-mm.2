Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3061D5B866
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 21:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C73056B0098; Mon, 15 Dec 2025 16:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC4B96B0099; Mon, 15 Dec 2025 16:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7766B009B; Mon, 15 Dec 2025 16:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AB606B0098
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 16:17:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 690AA13AA9C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:20 +0000 (UTC)
X-FDA: 84222966240.28.072CA8C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id D5A6040003
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:17:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="R/QXmn4I";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765833438; a=rsa-sha256;
	cv=none;
	b=wVwYPNSaqLrApNtTbnrfnn/Ht22urZT2zIqkvWWAQ5YUvqQyam7WxUBfjXNFmXnsky378N
	V92rB4fztnhO8BFzeTO8XR8G4g8tZHYI0sVn4/URd98Udx5dEMKkTenEsP0IaRD+sVRdW7
	MmFM2eQ/ZKOS1qKNF1+gm0mlzvHCP5Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="R/QXmn4I";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf12.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765833438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjZWbE0B0dxMbnF2Ya6GRRTVcHh7zJLEJhVHnnf4uaA=;
	b=t//TipzmfayE2TlcR2fhgimzhWvzIvvtSlQQbW1OQlpd9sfvaRMs19FeCXWwAHULR0Ri/d
	wvbLJiwTHRIHbJmpZBl7NVdSIVL9Do8Cxh9FCENWbEy8f4BekGU1OZViUkzWx51+lrhFB4
	SccVPjQ0PURcVcdaK9M/inq7Z5SkB9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765833438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OjZWbE0B0dxMbnF2Ya6GRRTVcHh7zJLEJhVHnnf4uaA=;
	b=R/QXmn4ItPB+d673rbZ6FFM1Vv6D0Psrh8bocvsx1GjFCyxfUDyiGW9/HGwmfTw+Q0HPos
	eZrGuusDK1XFkhik0r3Klifat52hc6vNA1+oy+4x8L1qJx/v11IAJAQGFx+Z2Dn01gEgA8
	dNXQs7y4THrDsn8ifmAScylVBRUQN60=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-wdfskrNeO_iyJluKfBjDeQ-1; Mon,
 15 Dec 2025 16:17:15 -0500
X-MC-Unique: wdfskrNeO_iyJluKfBjDeQ-1
X-Mimecast-MFC-AGG-ID: wdfskrNeO_iyJluKfBjDeQ_1765833434
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FE711800378;
	Mon, 15 Dec 2025 21:17:14 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0734D1956056;
	Mon, 15 Dec 2025 21:17:12 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH 06/11] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Mon, 15 Dec 2025 16:16:48 -0500
Message-ID: <6a4f0f6faf164aa3578d1c215fcd964fcd2f0659.1765833318.git.luizcap@redhat.com>
In-Reply-To: <cover.1765833318.git.luizcap@redhat.com>
References: <cover.1765833318.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: D5A6040003
X-Stat-Signature: t648dm8ssgwyetdg8qzibka6khtneqqn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765833438-35143
X-HE-Meta: U2FsdGVkX1++Q9NGDkiGRhWfk3upqlpBuzfoNa+I4dVrRr+/V6J9tr5dX6I55uS9OX7f0MjgRWY78D+cOou+yqoEZinqKhvtJYsungTDTw9nmr5yz2RCcF2D6+tLPnomtOb1YHY54kYYoNE2U0wbiXJPb0U+58dRahZyxDxaodBKF4lbgbWnLt4azvNUjvsh9UzOXXYqhAtR94S77aKB6jpXTd8P01YplPZxRhq9x79fXL8vuvTS2U0Yne28CZmBBVqYUTHRHiz6ixQM2zKpPbPCu88cnt6ubbH5T1bviHXbw/YuCxirtUNip/2eY8YjYpHJZxQabLswZmx99lVV1zbXONDbng07iQc4OuBMoAV9ygM2J/BDxvcsDrUCD3OpZAwnkXcXRyXxYFPawHPtnfq1KdUybNsHginq/0+K88vp+dWXodXbdVV8BjUjAqchbMjGFFAVHJrRewrbfYhf8/r0gPzTqNnjs3+7yUtDpEmE/oShB6A2VraiNQMXNSOMXxCGf5cZ6B9DtYJr1R5ipjMT6BKM6wmTgiNo1rtxWEmZ6UrbDNfM42QHNE4IgFFCXFeZ2KLBmC6Lv0SuL2Xqi3ffUkfAnmcCHzVDXkjPipopueuFYsA6gbG2eCM8uIALtIjoLckunD5MBrg4iTeD8nVrL4nnzM5BvHaiefnhDnUntwlr0FXjXv33dR6I/LXWyESBOIncktZpRHONTU6vyrFWbeFZfWTP1txnkyuoFSHTjxw2xuS5WTEu7ZSlcVTiP0NWNQqpvQkk+8s55LFduCElp4zB4j6mmvCdvhwEuXODe0SQCO1Vg4gdcusLMRDBfb9oYemnzEe1tF4RF5AAEZyoC69xzT5doN0740O5aLIRjtjYuGfZzGc8H2+A/euq5pM4o86JQ9hZkO8qvNN/ETq/e9xIC7b/iFX2RJgn4bsVxLnOZRB4DHogm5iEqpYezFRCOD/JAnYkmJmEu76
 sPSRTr6/
 oGAPMTk9PnU4XwwraX21jS2AtuH6Is6poyYOUPQRlA1IYWHuaKtv9IV6GfGWFHmtCGEYGtfd7wHD9L88UMjciYvAZ2sgGsloGUKa9Q85fiUqDKPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

debug_vm_pgtable calls has_transparent_hugepage() in multiple places to
check if PMD-sized pages are supported, use pgtable_has_pmd_leaves()
instead.

Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
---
 mm/debug_vm_pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index ae9b9310d96f..ec02bafd9d45 100644
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
 	if (!IS_ENABLED(CONFIG_NUMA_BALANCING))
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
 	    !IS_ENABLED(CONFIG_ARCH_ENABLE_THP_MIGRATION))
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
@@ -993,7 +993,7 @@ static void __init destroy_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage() &&
+	    pgtable_has_pmd_leaves() &&
 	    args->pmd_pfn != ULONG_MAX) {
 		if (args->is_contiguous_page) {
 			free_contig_range(args->pmd_pfn, (1 << HPAGE_PMD_ORDER));
@@ -1253,7 +1253,7 @@ static int __init init_args(struct pgtable_debug_args *args)
 	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
-	    has_transparent_hugepage()) {
+	    pgtable_has_pmd_leaves()) {
 		page = debug_vm_pgtable_alloc_huge_page(args, HPAGE_PMD_ORDER);
 		if (page) {
 			args->pmd_pfn = page_to_pfn(page);
-- 
2.52.0


