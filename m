Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63017E94615
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 22:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC846B009B; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 241A76B009D; Mon,  9 Feb 2026 17:15:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EF556B009E; Mon,  9 Feb 2026 17:15:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E70826B009B
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 17:15:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6FB48B221
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:03 +0000 (UTC)
X-FDA: 84426324486.04.81E701A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id C5A9840008
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 22:15:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B6dlHI3T;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770675301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2aDuQebwrriItiELVe5G4jyMPSkZ29l0d0nlGBuor6U=;
	b=mMlk/Y32wGZTTrswdzuJ+eYOncVVUimZ/GOSui7xtVf0R8F3a5unjOeW0iwkC/y8Rjq/V0
	DRX+bppUwxustZjf2Qfy7LnK4Tfhk1RVXVEKkaZRJc3herKMb1QwPZWjHxa1G8btohaTe+
	HWYeUphsOYufICwSbjZcBedXQXS8zmM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B6dlHI3T;
	spf=pass (imf01.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770675301; a=rsa-sha256;
	cv=none;
	b=G27UpEQgUxOlyaxTenzLoz0Z9al8RYKapFohdELWbZAr6+DMj2YdOyE1MM3QpDzo1fAUip
	Qb76pvryrwHQsb0M8V7gqkImODw6lq+lRu/5Z2zLnY1vs88yX1BfwY0Z+e9IARibC/v2+7
	By1U8QRSgIgvr/Dxn4rWoK35CD8cxFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770675301;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2aDuQebwrriItiELVe5G4jyMPSkZ29l0d0nlGBuor6U=;
	b=B6dlHI3Tq9GCks4ia4DV5P3HN8Lxbg3KnqALv3aek6WcxZmynRPcV8pIoNHEXP5FPZE7Nu
	HDXctEG8rgWpXYBeP510+9eSPSrEnDVeDv4oO271l/tLG2hwmTM+pCMW3OVyaead7E127+
	2lCFP6SP7oZVtkgGZOCZKWgTkniVe6Q=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-172-YejKFO9-NpWpR8uJ1wiC4g-1; Mon,
 09 Feb 2026 17:14:57 -0500
X-MC-Unique: YejKFO9-NpWpR8uJ1wiC4g-1
X-Mimecast-MFC-AGG-ID: YejKFO9-NpWpR8uJ1wiC4g_1770675294
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7F6721956080;
	Mon,  9 Feb 2026 22:14:54 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.65.66])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 128E218003F6;
	Mon,  9 Feb 2026 22:14:52 +0000 (UTC)
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com
Cc: ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com
Subject: [PATCH v2 06/11] mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
Date: Mon,  9 Feb 2026 17:14:28 -0500
Message-ID: <5bf68bdcb28bb0462ccf8c2995cd8ebc07d79cee.1770675272.git.luizcap@redhat.com>
In-Reply-To: <cover.1770675272.git.luizcap@redhat.com>
References: <cover.1770675272.git.luizcap@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: 9mpT-iTK7t70vIjUSeBlGb9_VhDjFsa6KUdMPgbKlS8_1770675294
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5A9840008
X-Stat-Signature: gmieyar7hbsihtwthwp3gyuyxu36khy5
X-Rspam-User: 
X-HE-Tag: 1770675301-251767
X-HE-Meta: U2FsdGVkX191GhwELm1zPPcSJ93u4hMCYqoah7Gh6232nqEatFBm15wLoYZOmqz+W4Z03wjmwJo0PVTzOUqzvFhqabvW08hklDvVEcjbUDJwmPH+bYejclIkY1RnZy9GkZ+uMagHz8Brckh3jiu6FTVFDxw4bfq13reDIZaEJ4El80+7oYVzWlVHn4Xgmmm6Yg0R9Mbmm0Rv32cnyvmDHBLnfZtbWViTeV0TOg4GTKb1d88b+ZEhVuE9twSqcgo/QWFTt9vY+muJiuHJz680NqK1JBcE6vcLa3iGQSdja6h0CV5jrB1tdl6O7AzU4TkeBHx7mOMjMIj+sqLDQL7ut9dGIKxHe/gBWrz8QiAOAlyrxiIb5vnxqmPHfowVn0VFOu80A+BSsKoIODnxsY+EMcTum/2jZ0o5PWOTUe7HBa99ZXQkGURhCsPo96QAIPdFr7MQyUW4vgwB4Z+SryYi5mfQHHwcVqcUQKQcswWcW61LygtntCLuEe1C0zuiispjhVii/uXrRk0Npg+LtTtY+OsTfPDbHevlZc7jZ3w61Jmv4RlTJ3EVyBDk+oW6GgkovpCwAoK83OVwj7LVmkhxzOpGUwTJtTaYYjf+bCE3pNyxvRs4iZqZaJ0BpcWmI8vFohFahMe3Wi/mI+kLxmB67I6+TYfDtxnBbDP5iFeuzVmZ7g5KMYkiUdfcaVcAnILY3et4qGRaa9cJOxHdNP5q36cBITEIzfC2zPu9eOwHCEAqSFmzThFlkjoOrnebiYyhWx0enraOeihRRruiS6W811XK4vAXcKtffv2IBzFG1nHi+mQbJszJNYhJNL675yiqbipzcikPCCJpkzx2NWrtAJdf95ZAmqdTGF31pbF/iJOZ5/QFAOIRzUoJwrqNahicOZGq9URDzVPLBuMJiF6yXSE2aZgDl4H1gl0uI9LMuQaTfF3kGbhWdKvPqz6gmJdbFn3pMcGWHyQcbQ/nAh/
 ozRqTPqW
 ZRBeapJ+nfeqv5qvJcoQ74hwy+1XbG/6ADQXQzPcNefDPWea+IoLu/ACU4zQBwxaGvtnpbcY9I6Qc9M88DW8H8e5q13JVTsCr0f0Jkfc+/i9Zg0zIjkzC47wkqeGRn99Sai7zOO7Nv2R9TxiY8FywWop79k1wo+wY9QvXFm9MImuNoc4WIQUGysyybeuKBD/M+UubbYdLo1uJRn7dwdew+2zbYGLeK/9GCRsr4UwGqBKDc/ED6gR9R3ATDa+lxeOtMe+R18epRhJEDnLapr5cfKirm2E1lQr/X7RpJKl5ucnLw+BrwIT+qLju4nhjbV+pONTgFPQrjrI4DeOENc7dZd3YAmdT1gdWiNHOJ2pk4EM7Tku8gG2mqEsTnZqeunPxyDHy
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
2.53.0


