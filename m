Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554F3606A88C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=LcA0587v
Received: by kanga.kvack.org (Postfix)
	id 776AB6B05C5; Tue, 17 Nov 2026 07:07:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFB06B05C6; Tue, 17 Nov 2026 07:07:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A28F6B05C7; Tue, 17 Nov 2026 07:07:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFDF6B05C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:54 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A22111403C4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:53 +0000 (UTC)
X-FDA: 85444487226.03.78B7B87
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id B344F14000E
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LcA0587v;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwmBcFAvKpsoHZ/5BcpLZO38brajTDnaS36NnWhFMMI=;
	b=twh5zt7u7Rqn8UJZzROdCipZm6wjCpo6f+3bxQjggQqNJMyAZvKhbBSR2cj4VWdmX3cXXk
	eyqMhd2nPOgHCQObURjvjXn5gmFai/b6ztT6LRXD4sEBHx4sow5l/XlrXECeY0w2KdnPhO
	qjd7JXv8rIr+QxcUXXpIT931x0KrJos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=LcA0587v;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917271;
	b=pD6fZIp2lXhUAm1dIJtau2gqPyqFkLgDeIZAhu1Obiea0dytc6rjaYpoWDrCM2Q156BEGA
	kl3rlCbympk1lHFx6nVtz+R+QbmkyJKbPW6k4k0QQRGkhkEKsUDZ00wsHGiUDvVY3B6HRM
	jEij3zJoxgrhe/0xTMGY+LizAUHrUXI=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1b244fb7fffso5454414c88.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917270; x=1795522070; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RwmBcFAvKpsoHZ/5BcpLZO38brajTDnaS36NnWhFMMI=;
        b=LcA0587vz30ZnOj2HVRT7/wVvXjQv3TT8LRGyvdkkFbnbZ6Ux9vtPW7iOZPAUQzyoV
         9Pka1Kocrd7e3tR76h/xBuxRwDDqbvWg3doGmf+m0Fg2G+Mf6HWx7Hzn1D1KARJbU2iB
         T2Is18NWq2+aDvhwlKwRmhI0pcXnugH0qW2LySe0j3IXSV0e9LS5tm2qqCymAAnEcQ1g
         z/c63U16lhlUFLwAzX4Ere1DG6QGAvhx9EO3PCmOEfuxnEBNvSbyL8rcVPX8UVqNIYih
         OARl7s+2Bdo4Z4eHYbH4Zj0LisVIQMeKXyOMUMdiQQZ+KTEquVG+NKdLUmW1GbAinC4e
         WmVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917270; x=1795522070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RwmBcFAvKpsoHZ/5BcpLZO38brajTDnaS36NnWhFMMI=;
        b=gBeI2yEGGV8cJRCz+PuvLj1jbGUusCKtvTCL+j5GXK7qd/AQZCi8EudzLOLc/UY7Qi
         iYe0t0lNcQaDEFraF4HURXMsY4t8URoO/d84wYMMXGYBHCfSxee92QQ15Z+Js6BQXU1f
         qBry7enndC4f0V0IV2lKTJvRnl3u8JY3ltN6ORzSGbbZDbOjma2eTQLuxgM1/GrFt2WN
         SoCFwo2a2mA6BYmLg98ynzmVJmG5ajApBMaTZ1tlkUImjVABVTzvIyRoj9/kI5zmmYBL
         Dis0E24gHy4Z7dp/rd65NDAkRhY0ocDkXd8YLOIoml3uKyijPhBSlwS1Lo8SgPtz61f0
         AlNw==
X-Forwarded-Encrypted: i=1; AL+hErFzr5BhoP2v7jYLK3VlZTZpNJULnD2FTAJjoDKKdw91QtOhFiwYn5rOGwilS7bFGUjlKW0iDpAA2w==@kvack.org
X-Gm-Message-State: APuU4Z/v7JD7xi90sSK51TwWs7GgZJ6dkkaDRbf2ti2gKE9PUtCMkg5F
	BEK57nGUI7F/PSotW5dKvv6dcdWGc7Hcjl1oV8swnjom+7yjqbqPb3vew+lKvtAwq0k=
X-Gm-Gg: AYBFou1cuYBuoGvLBaFzhq+OO1boyXGYG6+Y6BeqjwIR6S4+76tLRfW2JgTa+8pWl8G
	/6BpyvmsjwjEBPKw21pEx9FM/atxh2g/NnbkQAQbnX2iebNsahDu2q6nk4YbtTvRh3e+qbTudEA
	/RLsvaqq0SA+hNkJQzO7e/5cAKofCA6bnl6dDTUYT3uK79NbV3/Ep7mqgLJ+ssEBTMXd1lOOzvh
	oXgAS3B2ENWZX7nrKQguqUsDy3cDXRwVy2YQM+wQWL5nHMo4BdburGkXA2VKdRUAEASbpOzCK+A
	2QnmGLmau1c9KqeXO4jk85c7PUIedr3EjQuOEOHtUKVJgcSb7nvtlLqFVQt10R2Dau+89eE/xPG
	HapajDA5Fw/dDkrorXe+T7CGDofPdEJTPgyUrUmFGpWKJOLbUwrXMcGuTA/OcHEVfSMMfLuVI2+
	KsFJWtnPVsNSmkTMs9JB8VR7mdum17brCqPRGmApjRdUUB7Dt41Dqp02u3mkpTmU6HOBHgGFIQE
	VmWhtY/1aZU4Y1YAGk3Za5xUJFxoR2/bUqEmzjIwVkN7cQkJGLNJZpDLAYNd44sb9MLc5DqoFuH
	FUy8XVhBfLlx6fkiLleGO5gvJL0pkKg49lAzXKMRFIsSQ33H0n1Sp+JHA3wxon55XbtbDL683eE
	qpSOhlTVIDraD
X-Received: by 2002:a05:7022:408d:b0:1b2:42db:8a54 with SMTP id a92af1059eb24-1b50310591dmr12810999c88.23.1794917270047;
        Tue, 17 Nov 2026 04:07:50 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:49 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 7/7] kmsan: fix metadata loss during HugeTLB struct page reinitialization
Date: Tue, 17 Nov 2026 20:06:27 +0800
Message-ID: <20261117120627.50601-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B344F14000E
X-Stat-Signature: rmwj7caym3fsh4sd6rydjy4833eitoek
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794917271-655820
X-HE-Meta: U2FsdGVkX1+yPnBG/rSm3Niu50Re1wts5ZGIRQk7JMUVNi+gJyN26nndaSluB2llRQ3gOjsv47x2bgOIqOuHbjH5fuXF1PL5GCL8PMAZv+1rhE1fWcpmb5Jv4L1oP46h6gNx7E8A8bmiZn1Eph0dxgLH+WeQQnvfIKgDtyZc92+5Q2CKkSPCh6dN8/GF9Buf3ouTkwAoSK+myQ4BduvmLI75uAAbB7ODNuHMA5okbl04PinjuMEdWeIBAgrWD94u6X3KHdHxHbvlm9JU2Fn/g8hhufU0iB2h9WeWWAX/OgdsCP0xmHydUp6u8l6lpvUAM1bqPMkje7kZv5Iohrw69V1zUFIj8Wx5YHp801n72S8s9wB5PPwznMOl7KQYJOvwseRrI2CXG8yn6ulWprI8Q/3qM1Rt8dIKk7n0R9zO3ue6xdku+fa110LoRWljwxoHn5jsU3uI9LDOtNkw6jb/mehkQ26zVx1CIcRfjWPPkpUv4qx9Ox9AjXQHpmRpaaH/IQCLXMvnMyREF71ZJamt5vOyJWdVS1xIYtBlRhwjsfVV2/TPT0zgZRm6V5vjHTwxie7MuzAPxNJfweFYV26A2km1RHdD90Anno3Ce84+7gEF4URFhSLBV//W+Ii2dTynuU5CV0vCLQcAaZ0Tg3TpYiVHRHHwH8q9IDid/j2gbrhpqA5QAIikkUiEr6tP/ZSfXALBCIUeUAowIB3Tkgu4HC3tADqFUoRlSHxQryqtvzIDnMY8PLEotUjr+qpbLbMrO8SvjaPMvT6QhBRibPDsnA82FfqvDlzbY2IeX0zoCNp4rLhE1aswTtIGcAK0qx589BVK/NjJk58VNuA/kqACaywfMTNmHfC4J5W96sP8opEi9sz3EvlnB7u2IaYVwBXF8uzRkbme4YTHk38mRgQEzvsRZocEn3NmqGUfxm57GbrTG+950/+NGmoKns/OOJc0I0yAKCNXsPpVmVPWKqo
 pTR6w/He
 YenrNBXh5AxLsBTchmDXfsQLlHuNu1ntuDE7mW1TSJ9eLCwLTa9+kUJUk/fMsr6aoLJUpkQJ45+9+5XoNrMcRg+F4uvwY1cVv2g27DkQtfGe+hIPF4ur3maH2HWLOXQFYeL7ydLg8EsznErpSF0IY+Q7AcZejzvXyP0DL8gO8g0DpYtk3LIO5J4eMXZCOfdgpK/ItvdtqrVBP12EKLItUqxuD7r2W63SZV1BRTClnhC7k0eMpGSsFkWePvBmzq6m1yQqca0X7s6ope0G4oyPA5rcSV+rfi2h2+aR4t1pT6cMIXvxeEx8D51Fswq79IrJFjgEqZ/ljwrvfdRw+mDvIJHLHQ1UpyHBkjoZt/D/U6KwhPfAYlRXjGS1b9ubREDLX2kAcACPDOJiogwk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMSAN stores each page's shadow and origin pointers in struct page.
Boot-time gigantic HugeTLB pages are reinitialized after
kmsan_init_shadow() installs these pointers, dropping the mappings and
leaving the allocated metadata pages unreachable.

Move the pointers to page_ext, whose boot-time storage is available
before kmsan_init_shadow() and survives struct page reinitialization.
Use the inline unchecked lookup under notrace preemption so metadata
lookup cannot recurse through instrumented hooks.

This shrinks struct page from 80 to 64 bytes on x86-64 KMSAN builds,
making its size a power of two and allowing HugeTLB Vmemmap Optimization
with KMSAN.

Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-ac161ba4-30cc-4bd3-b93c-ab7af8a6f64f
---
v2:
- Update __mm_zero_struct_page() for the smaller struct page.
- Keep the unchecked lookup inline in KMSAN and leave page_ext.c
  instrumented (suggested by Chris Down)
- Document page_ext metadata storage and KMSAN HVO support (suggested
  by Chris Down)
- Use the common boot-time page_ext allocation instead of need_early
---
 Documentation/dev-tools/kmsan.rst |  8 +++---
 include/linux/kmsan.h             |  2 ++
 include/linux/mm.h                | 12 +++------
 include/linux/mm_types.h          | 12 ---------
 lib/Kconfig.kmsan                 |  1 +
 mm/kmsan/shadow.c                 | 45 ++++++++++++++++++++++++++-----
 mm/page_ext.c                     |  4 +++
 7 files changed, 52 insertions(+), 32 deletions(-)

diff --git a/Documentation/dev-tools/kmsan.rst b/Documentation/dev-tools/kmsan.rst
index 0dc668b183f6..5330d21d141d 100644
--- a/Documentation/dev-tools/kmsan.rst
+++ b/Documentation/dev-tools/kmsan.rst
@@ -376,13 +376,11 @@ Metadata allocation
 
 There are several places in the kernel for which the metadata is stored.
 
-1. Each ``struct page`` instance contains two pointers to its shadow and
-origin pages::
+1. Each page frame has a corresponding ``struct page_metadata`` entry containing
+two pointers to its shadow and origin pages::
 
-  struct page {
-    ...
+  struct page_metadata {
     struct page *shadow, *origin;
-    ...
   };
 
 At boot-time, the kernel allocates shadow and origin pages for every available
diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 7da9fd506b39..08fb79566235 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -15,12 +15,14 @@
 #include <linux/types.h>
 
 struct page;
+struct page_ext_operations;
 struct kmem_cache;
 struct task_struct;
 struct scatterlist;
 struct urb;
 
 #ifdef CONFIG_KMSAN
+extern struct page_ext_operations kmsan_ops;
 
 /**
  * kmsan_task_create() - Initialize KMSAN state for the task.
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45..9349209cd2c0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -133,7 +133,7 @@ extern int mmap_rnd_compat_bits __read_mostly;
  * define their own version of this macro in <asm/pgtable.h>
  */
 #if BITS_PER_LONG == 64
-/* This function must be updated when the size of struct page grows above 96
+/* This function must be updated when the size of struct page grows above 80
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
  * combine write statements if they are both assignments and can be reordered,
@@ -144,18 +144,12 @@ static inline void __mm_zero_struct_page(struct page *page)
 {
 	unsigned long *_pp = (void *)page;
 
-	 /* Check that struct page is either 56, 64, 72, 80, 88 or 96 bytes */
+	/* Check that struct page is either 56, 64, 72 or 80 bytes */
 	BUILD_BUG_ON(sizeof(struct page) & 7);
 	BUILD_BUG_ON(sizeof(struct page) < 56);
-	BUILD_BUG_ON(sizeof(struct page) > 96);
+	BUILD_BUG_ON(sizeof(struct page) > 80);
 
 	switch (sizeof(struct page)) {
-	case 96:
-		_pp[11] = 0;
-		fallthrough;
-	case 88:
-		_pp[10] = 0;
-		fallthrough;
 	case 80:
 		_pp[9] = 0;
 		fallthrough;
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ed35d258d2e..dc73f9f5a51b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -208,18 +208,6 @@ struct page {
 #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
 	int _last_cpupid;
 #endif
-
-#ifdef CONFIG_KMSAN
-	/*
-	 * KMSAN metadata for this page:
-	 *  - shadow page: every bit indicates whether the corresponding
-	 *    bit of the original page is initialized (0) or not (1);
-	 *  - origin page: every 4 bytes contain an id of the stack trace
-	 *    where the uninitialized value was created.
-	 */
-	struct page *kmsan_shadow;
-	struct page *kmsan_origin;
-#endif
 } _struct_page_alignment;
 
 /*
diff --git a/lib/Kconfig.kmsan b/lib/Kconfig.kmsan
index cae1ddcc18e1..015e85c70793 100644
--- a/lib/Kconfig.kmsan
+++ b/lib/Kconfig.kmsan
@@ -10,6 +10,7 @@ config KMSAN
 	depends on HAVE_ARCH_KMSAN && HAVE_KMSAN_COMPILER
 	depends on DEBUG_KERNEL && !KASAN && !KCSAN
 	depends on !PREEMPT_RT
+	select PAGE_EXTENSION
 	select STACKDEPOT
 	select STACKDEPOT_ALWAYS_INIT
 	help
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 300b48818af1..fa2a403d87c2 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -13,6 +13,7 @@
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/page_ext.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
@@ -24,23 +25,55 @@
 #define KMSAN_META_MASK_SHADOW		BIT(0)
 #define KMSAN_META_MASK_ORIGIN		BIT(1)
 
+/*
+ * KMSAN metadata for this page:
+ *  - shadow page: every bit indicates whether the corresponding
+ *    bit of the original page is initialized (0) or not (1);
+ *  - origin page: every 4 bytes contain an id of the stack trace
+ *    where the uninitialized value was created.
+ */
 struct page_metadata {
 	struct page *shadow;
 	struct page *origin;
 };
 
+static __init bool need_page_metadata(void)
+{
+	return true;
+}
+
+struct page_ext_operations kmsan_ops = {
+	.size	= sizeof(struct page_metadata),
+	.need	= need_page_metadata,
+};
+
 static inline struct page_metadata get_page_metadata(struct page *page)
 {
-	return (struct page_metadata) {
-		.shadow = page->kmsan_shadow,
-		.origin = page->kmsan_origin,
-	};
+	struct page_metadata meta = {};
+	struct page_ext *page_ext;
+
+	/*
+	 * Avoid instrumented preemption debug and tracing hooks while resolving
+	 * KMSAN metadata, as they would recurse back into metadata lookup.
+	 */
+	preempt_disable_notrace();
+	page_ext = __page_ext_lookup(page_to_pfn(page));
+	if (page_ext)
+		meta = *(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops);
+	preempt_enable_no_resched_notrace();
+
+	return meta;
 }
 
 static inline void set_page_metadata(struct page *page, struct page_metadata meta)
 {
-	page->kmsan_shadow = meta.shadow;
-	page->kmsan_origin = meta.origin;
+	struct page_ext *page_ext;
+
+	preempt_disable_notrace();
+	page_ext = __page_ext_lookup(page_to_pfn(page));
+	if (page_ext)
+		*(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops) = meta;
+	preempt_enable_no_resched_notrace();
 }
 
 static inline void *shadow_ptr_for(struct page_metadata meta)
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 0f31e2da2611..274c3e778be6 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kmsan.h>
 #include <linux/slab.h>
 
 /*
@@ -87,6 +88,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_PAGE_TABLE_CHECK
 	&page_table_check_ops,
 #endif
+#ifdef CONFIG_KMSAN
+	&kmsan_ops,
+#endif
 #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
 	&page_iommu_debug_ops,
 #endif
-- 
2.54.0


