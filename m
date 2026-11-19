Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C52606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=EngVjozh
Received: by kanga.kvack.org (Postfix)
	id 1E36D6B05C0; Thu, 19 Nov 2026 02:01:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166B56B05C1; Thu, 19 Nov 2026 02:01:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E286B05C2; Thu, 19 Nov 2026 02:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1496B05C0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:01:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 563F7809A7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:01:53 +0000 (UTC)
X-FDA: 85450973706.24.88852F6
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf31.hostedemail.com (Postfix) with ESMTP id 475CF20004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:01:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EngVjozh;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071711;
	b=y4CWRo8a8z4ev8GE8VIwgJ2Klhxmcohp3xvy54lh+MwcFoQlwd0Uge+DN2jUcCXUOkj/xf
	PjP+mD+dSyG9iiHgiuczYgaH/F+j5e6Q66znYjaXC8hkPVHTPu+SSPRLtufJD0A6RuV5bJ
	aAZtUuMe6Tym4A1Td0cYkWK1rbP9CTE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wa6FffWSifqy9byjf3TnSCSaUIR9pC+Hc3W0NorYeDA=;
	b=h8I2kflKOi+DpkTlkyn51dnqOVSsMGEJaICc7HN9OD7VXjmCsitlwuRNWLPTalOcxlNF/F
	BlO5JkBy7cfNN+vDuar7pXIELeOIgnYGVYL3QAhGwcvgQ7NBJ9WlHj/qM5RgDrtGWYVuTJ
	7rc/qrpNrJpNLH5A2Eyx71vTSPWymjs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=EngVjozh;
	spf=pass (imf31.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3adac5b29ebso1229008a91.2
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071710; x=1795676510; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Wa6FffWSifqy9byjf3TnSCSaUIR9pC+Hc3W0NorYeDA=;
        b=EngVjozhF5kLAcduRVeEEHeTcSMYeBG1sIoN7R7fwirLlw95JM6OOu9FyVSdQFZRI9
         cKkPdMkYGPw40aEETrvhIm7vc9Ix/4jOq//8MIHY47dw1s+IxYnl3iSpRY5buHOnO5KE
         7bsBO80dZ2mR8iH+jvNs1QrhEZgtEIu4ulG/sHuPmeUT9MaWrTGR0a6NOFIe5iWGuU6j
         CakcPTGrmV1Zwvh2nZBUQ5XWsy/xUQbSmAAKCMyfy3RWcOXxDf55lL+QKobXFC8FudOy
         XdCMyNS82lzuudLQv00gAA12I9Gh26nnHR07EvYrNcXEKBQESPGp5/5mHqPy4yxFJhXo
         cJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071710; x=1795676510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Wa6FffWSifqy9byjf3TnSCSaUIR9pC+Hc3W0NorYeDA=;
        b=E+qDQltgDq/ahEXma5MlLigzZcvol9cR8gSYn0rh7EVEzll0Xw1Ii57KIjY7VslmKy
         4RPv1wgjQC/nkG8+EdBMUD53uM1AXQZzVHlCCa1zM5BFu3xuGsea3Hi5nM56gv53Enuj
         hoNuWu6kfGGarrhOlbApf+HwdhuQwUm3+ozXE46D6OU9I9TmqtajBnh9SW6K+9iLDhnG
         TwRwPtnwnZaqVgBAlphlHq/92NAncLH3mWWPK3dv3NR+la+qmcgfAPBmuuuaI4gokSy3
         VfEm8qRIxoPPBVGYJD/K06YA0EtoiAV7cMtn8Mt6P1UwCVTf64U71eleXAnfsK//g6ta
         Xqrg==
X-Forwarded-Encrypted: i=1; AL+hErHx0C6a0G3NN+hBwUT5uKnhq/56dzo39I/4fYXtlhxg3Tvc9bgfDOHMKS6xmIcaYHqyuC99xOMr3g==@kvack.org
X-Gm-Message-State: APuU4Z+dym6Thk8yK+f0ks+IVQrRdn2BwEED4Eit6pDPS4IOPDZAwbZK
	ejcJgNniCBzj+aflCRDvL1Vq7p/cHf38zLzYVyUrpc8JMPk5ku2WFTRqKMt8MMHjnRY=
X-Gm-Gg: AZFdTZdwyjgxsR/k+ysPTtOv1RDDYNBNNGnplLGqDSq4xI6J3QPWtbzf6bfl0E52T1l
	79DKKLrxWALyjycE97J2SYTgZg3uyMhbEHUkZZOwgbj2dE9brOpLnlDxQISjxWg9fKrHC8ujfmt
	cxKJf3kmFQWJBGX5fz8eGhVW3Ll86k7qpiMmzvkTs52HvhUNJTZmwSB/P+792tPtTWDSK5I5yIF
	Vx5VJRijNveK/pkFetPUdICmBo57sWji2CWevUTZqan39tUt//EWzc0RyNC0VmPTDossG1Qz5Fc
	GVm1ppkmqVTWf+9lZO3LbFidNcG7l27sZcUGOqkAOV43WJorI75iLTAcay9RXs4AdvnERw8GsH7
	zYh9LQ1dqL7Yfmg1dGvDaSwEUngqoSEVsNHP4t2Be93CNgrZGpeilKlzPU1BwHC1Jo0tt7cRZTA
	px8a/EW2Sy6mhgpmGpYQ+WnA/OVxKQc54pp4G3T3pqTOBPaCjPs0ky9gT6NccUUqpvlqCdIPzhN
	2lZtWk5d+zc3xHvPF4j6pudLivh0do5p+s8vTGdmCJNtaFZ+Hbs4QdV0+LUe+iaotLBhBdo2BfQ
	WtXSbGJ2x/GUSpbSgVyVSBdYBWaim1hqeaNkjO/Ml5V6aBpL5U4wMC02pVM=
X-Received: by 2002:a17:90a:ec88:b0:3b4:a63:d57a with SMTP id 98e67ed59e1d1-3b40a63da9fmr231139a91.1.1795071709630;
        Wed, 18 Nov 2026 23:01:49 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.23.01.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 23:01:49 -0800 (PST)
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
Subject: [PATCH v3 7/7] kmsan: fix metadata loss during HugeTLB struct page reinitialization
Date: Thu, 19 Nov 2026 14:58:12 +0800
Message-ID: <20261119065812.89959-8-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 475CF20004
X-Rspam-User:
X-Stat-Signature: p59ax67wasauaxuoi98dk9esiajtj7hx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795071711-278277
X-HE-Meta: U2FsdGVkX19glYrgpg8/BEGKHT/dwwaElboIG7yTYk+hhaJF1xRd1Vq6OGFwNDeHIPHn5+HHw6iRi9xkd4zoAomoKqWIC/n5IR5rHz+RAtJV6pBSrge4HzSxSLZbJVuYireT2SVLu2blkm16gUPFvQzgfrdDDa5hvK3AzI8dM340pbx7+vndb88aXJxxt6wA+95QOHuHEp0wmydYyYqrftEN7THMwd+b9WzhGRZLz0+xSg1BosXxkdgwRVKUfyj11dkVtFuMwFnGLkamftuXfLHHNv/OofRRliA/OCTwnZPDa9TMH9ptbokkoXZZ/WYjN+ymjSCCptSM5S/6IBkdnlnubPDXHHqINXFklIVqIaciw2eewRsid/OADRJ+DFPBK2Myt1owMLlBG3Hbvu4jJ1PEIVTZrzofjT+kNGJouGlLITvrnc+riLdL50TIpNZ5p8NeKzzaSvcT9uMdtYx78l8vsmallu5ttOAsBsT2+kOMUZfVvUCEU85MQObAZuBptvGd9S3gClK9o4KmeMm/k+yKIXZe4J8k8ppFfLAobHRb1wy5INVSw/c+dW/WC4YLzY6mzKxkViBuqE9kaca8FkJfQBx3iqqyGhLBktFj2cjGJLAFo6rVSlhjPkmgnp+ufAGBa0z36O5nzKH75qnhSkhr//I3OFgHbZuzi1fq8T19Lv75VMjNbZCg4BuWllVY0SJx4HaaBw4XYa8KZl6+zBQoXUoChfEDnUSXT8mDNd8PNV2HNKoBe5Cnxoov1Pctl62jLwr+5CCACiXJt8SgCiatvY/Aea6R6PeAWjmPmKkP7NVZtaLm9N4Sg9yKbggAAXcR4CNDlp2ycVOmlweM1xj5pqrLWws8Mi+XpmsGS1GUOi7pSocYFWPMyK6xU+9BNpvFSICrq1Nx9L5IayMMXDU/tNg9dOeM3S708RO0UaFxl+Ng9mmbenMISsjpV+rW/ajXF9PlFuPt0EH3Oq1
 6g1N1ycl
 WQU1hkC2TM6sf/NeFUObfmTAizFW8itTgCFZyCRDojmSTCoJ/cUAJ5nJb6DnYovH7xhGXZYQS0+eKX6NQf1siYJ3YkPiJVRIbKrXMuOdQ6JLynEtBT5lfCCbm18WaFIueL5qxOiyiT6PDWmchIMp6SgwXN0iTd57hfNSaSwXqC3mXEU6EbxUDYNHcNpSSqbXqRuo1RT9R+Bs5gAd6XlJQqy70BZ3OtGlExfmdG618jcotpXWqbk3MjShVnLJelZGG+mkzQiyMe5KEgelPfQe7jk6qqTghZ1iqGQqbrY+Vb5gOZC3JE/OyCrQmudtffll1MwBDWE4+mveOIJEVKtGOFhDgXwf4ss1FjdOsQLorF4CAC3AkSGCwP52KMF4iI612TuYr5eyMXtmJdf6I+s1YxfYa1lezxyteW5VGtfQGm8sjMMt7c5nQ3RIsK40WXnf7VWWTJigDj7RD+QeMZu5+vrQiv0/it5kjlTKx65vjrcVjGchIzEL2n6W9d1EZqLVt2cwYCfOGcXQQDdh3PJXCtNsfEVv5vo1hffESw2ugT1V4Q8U=
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
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
v3:
- Collect Reviewed-by and Tested-by from Chris Down

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
index 3578f53ea9cc..e04cd6289546 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -134,7 +134,7 @@ extern int mmap_rnd_compat_bits __read_mostly;
  * define their own version of this macro in <asm/pgtable.h>
  */
 #if BITS_PER_LONG == 64
-/* This function must be updated when the size of struct page grows above 96
+/* This function must be updated when the size of struct page grows above 80
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
  * combine write statements if they are both assignments and can be reordered,
@@ -145,18 +145,12 @@ static inline void __mm_zero_struct_page(struct page *page)
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
index 63af3d62ed74..985595bdf420 100644
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


