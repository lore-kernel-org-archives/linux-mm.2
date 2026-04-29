Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68C6BFF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 10:28:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB2656B0093; Wed, 29 Apr 2026 06:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A416B0095; Wed, 29 Apr 2026 06:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F846B0096; Wed, 29 Apr 2026 06:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 954966B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 06:28:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 614F2A0114
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:06 +0000 (UTC)
X-FDA: 84711218172.05.6A0F45A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC2EB8000E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 10:28:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=opc+blul;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777458484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WirQ/DIFzxt3c1dIWUAd7uNLeSVb+PDMO+/Zfkr8D24=;
	b=bas27My9AsIKYcHSVrS6VUWEZBPWFh6Ry4Z5Wvu99PUGgldU1yb3bbQYSII+IzM9Q5Cuy3
	tmzOuiDGGFKxGwnwXfgqt0HY/uVVtCcdRBgS7ViSel1v5IQBBvf41GZBQpb2jg3aMoPwCU
	CmHGmUdZndHpt/omtYX2hKJrIafzkjQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=opc+blul;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777458484; a=rsa-sha256;
	cv=none;
	b=FrZUG6BCxgLxTnprilMb3duYLeJSaa7UuatnBwixv+ip2NnCw9sfFNW2djA8BPgf6CSFTt
	WsMgTqBnMrDsn25OoW1LmF3YSrxh8OOIlqOh3csySCqiv4A1r6whQV3JXAhwn8nqlrSPSB
	N9AJNBxn9Lg1A2sRmYMfI+MJtzQ7KWE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 338632A68;
	Wed, 29 Apr 2026 03:27:58 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5AF023F763;
	Wed, 29 Apr 2026 03:27:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777458483; bh=YrVa8QM82FyivasB4c6vnJvcttIXWoFHfA8m9suAaJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opc+blulF41XR2gdMM77FjNEu7ajZWNaYa0gS9RSolSJOFVKz7RXsOzo5BdWPydZx
	 H3d72HfpHJ188WWApaaZeXaPT7fL7GAriBJ2izZYIXt/eOIKW2Ii03okk0tCtlZCno
	 0t4ESg+0jOqTYdL3fe+4f/92M5fvzvWBLYXP78DQ=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	arnd@arndb.de
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	tglx@kernel.org,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	ryan.roberts@arm.com,
	catalin.marinas@arm.com,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v4 1/3] vmalloc: add __GFP_SKIP_KASAN support
Date: Wed, 29 Apr 2026 15:57:02 +0530
Message-Id: <20260429102704.680174-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260429102704.680174-1-dev.jain@arm.com>
References: <20260429102704.680174-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC2EB8000E
X-Rspam-User: 
X-Stat-Signature: bojzg5p9smnd9qf3afst1oezkixtog9w
X-HE-Tag: 1777458484-588883
X-HE-Meta: U2FsdGVkX18mKCpc8RTv8aElSOeCM3DD5+MhVpb18FT1CV2DPHA44dp4/nyfvbFePSNv1RU6SeXMGE4jDvLXABfSnMl+rzq6SctEp/QnLCb7j5f0/z8LtwHo2CrlSyowQjKNJFk0gQmRi1CvQobOHBvZ31KDnN+yCwMxX+HWL3/tCQuAzMvDg160Mo1bXr7JZOL33TFa7RDNU+rYKX6HrUvYjN/+H3dgKo7r37PG17LXSpBuUesk85hPLP4gC7AD+VVihvCXPjXJLBODKw8kEdoVWtJRAtZcKcJXQiQYlWuy45f0iRdSYem3uRM4egYPEjHTJl6rV+ZpLnrzf9STl7evt0mk0ZYYIqAO9IKyg4RALiBs6v3Mvy2PW5MtXv3SgatzNO9S0m9hEniRAz3EK9yKbsB0keKQrlkYmfTYZDxirVvpYYiqu6kgMzTPqm65OK8CrEkGKW+k9blOeMwjdqe9t8iCGfi92p88DoyGNxder+nYLSFKy18yGRYYAx2zMCKDc7sxnruGW7pQ1VLUxNM6TerDnMc7S8x/x191+YrPqvbHyZGfMVuBrKGr8RKYZiaDvqkeW4p0XJcqD1R0zWdwXvYIIA4PmvbpghqPeoe/c/E7z/AvlvhICXlrhfKgeGr9ii5OmJNqTGjZEicHCo65zOeeo03tBEdIT6IrpmuMFtlNo99ktg/CAeIRnmH/8Ud6jOEc93WKruJKZE+eL5tK6grwtd4Kvi3CoeK6JDjO33N8ZAEcqQ8/OExFRyQlDX5Sk+XkjPZUpDbpG9tAPgBUI5zRyx7Xn9EU+eIuhXH8/shEAMqGeXHtPj3AZwV2Lk/Q42P6mJZ404X/OPum0sOtBy4+bZTacGTwxnS3jVsbbtyRTTkOx1mwTQ46ftBGS+JrnXcC00Yi6B4S+E5LtJTXHqam/mSApaGQdMJhvbUPkFd4Twvf2DccAIqbJFmC3guG0REKlRdOzn3LgHO
 hGcDwsQa
 B7V8b+lY7If+X5zLkDlzDQltx+GuECgkz0AChyxJs+bUf/9G26YSQaoQLmtDx5p5eqXppZECKEWIt8ORfCXAmqF+lO3kdAUGDiyk+izGwHdh/O2rc+NN5o0Hvls/yqdch4JDze2t7FL1Q/rLxt9ck/uK5nTwDJPSp5xi7LRZ1KIwxpExJdKxhDddByusxq8Z5Au348p2PyaLN6Jnt/S9ceyhNves/jluPuSvYtFCoCuUuInXxVB9jVk0roVULj641cUR6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

For allocations that will be accessed only with match-all pointers
(e.g., kernel stacks), setting tags is wasted work. If the caller
already set __GFP_SKIP_KASAN, skip tag setting of vmalloc pages.

Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
APIs. So it wasn't being checked. Now its being checked and acted
upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN is
ignored for them in the page allocator, and in vmalloc too we ignore
this flag for them.

This is a preparatory patch for optimizing kernel stack allocations.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/gfp_types.h |  6 +++---
 mm/vmalloc.c              | 13 +++++++++----
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 6c75df30a281d..c2bd723c8ec62 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -281,9 +281,9 @@ enum {
  *
  * %__GFP_SKIP_KASAN makes KASAN skip unpoisoning on page allocation.
  * Used for userspace and vmalloc pages; the latter are unpoisoned by
- * kasan_unpoison_vmalloc instead. For userspace pages, results in
- * poisoning being skipped as well, see should_skip_kasan_poison for
- * details. Only effective in HW_TAGS mode.
+ * kasan_unpoison_vmalloc instead. If passed to vmalloc, kasan_unpoison_vmalloc
+ * is skipped too. For userspace pages, results in poisoning being skipped as
+ * well, see should_skip_kasan_poison for details. Only effective in HW_TAGS mode.
  */
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index aa08651ec0df6..708ccac293cef 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				__GFP_NOFAIL | __GFP_ZERO |\
 				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
-				GFP_USER | __GFP_NOLOCKDEP)
+				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
 
 static gfp_t vmalloc_fix_flags(gfp_t flags)
 {
@@ -3980,6 +3980,9 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
+ * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
+ * (when prot=%PAGE_KERNEL).
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -3993,6 +3996,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
 	unsigned long original_align = align;
 	unsigned int shift = PAGE_SHIFT;
+	bool skip_vmalloc_kasan = kasan_hw_tags_enabled() && (gfp_mask & __GFP_SKIP_KASAN);
 
 	if (WARN_ON_ONCE(!size))
 		return NULL;
@@ -4023,7 +4027,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 again:
 	area = __get_vm_area_node(size, align, shift, VM_ALLOC |
 				  VM_UNINITIALIZED | vm_flags, start, end, node,
-				  gfp_mask, caller);
+				  gfp_mask & ~__GFP_SKIP_KASAN, caller);
 	if (!area) {
 		bool nofail = gfp_mask & __GFP_NOFAIL;
 		warn_alloc(gfp_mask, NULL,
@@ -4041,7 +4045,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	 * kasan_unpoison_vmalloc().
 	 */
 	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		if (kasan_hw_tags_enabled()) {
+		if (kasan_hw_tags_enabled() && !skip_vmalloc_kasan) {
 			/*
 			 * Modify protection bits to allow tagging.
 			 * This must be done before mapping.
@@ -4078,7 +4082,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
+	if (!skip_vmalloc_kasan)
+		area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
-- 
2.34.1


