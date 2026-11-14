Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A280606A33E
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=d6x05oqj
Received: by kanga.kvack.org (Postfix)
	id A53BC6B05B7; Sat, 14 Nov 2026 05:42:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BBD6B05B8; Sat, 14 Nov 2026 05:42:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91AAD6B05B9; Sat, 14 Nov 2026 05:42:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 602F96B05B7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:42:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBADFA0398
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:58 +0000 (UTC)
X-FDA: 85433386836.21.ACE445E
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id A24B180002
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 10:42:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=d6x05oqj;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794652977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gUXejsOVyeS4hm2x219vafr/Kz/IOGP2NyEF6CTVDz0=;
	b=PkE8UJvk8jRRzNjHUByuvjC3nMvvhBxML+IKLdA86AQAN6UOpxe9DG2u37+c/PQuGEbMqI
	xCnfb9+PG5/+SEGJXAWr4WoUWb+vuV1tdfkdymvytXrITK6J4+Qoks+i6q85d3JtN6IVNb
	wo3H+G80dlxMCQUoK8VUaicmg2p7m9c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=d6x05oqj;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794652977;
	b=tZvm/KS/LSsQSVvZuLvRaZylI/UzccNolHI6Wm+dFthsmrQkm31ye1ihKsVFgLNnB81HtV
	4KXCCcyH6ioO9EjpAGI1OsIwTEnjZIwR74XAzbHKjgBNyKpUOQHVyWh1sxotu0Z3SHeIy6
	a+TAUy5zYgq498r3WqNYBNGRGBo4Pxw=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-37198ed3727so3283057eec.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794652974; x=1795257774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gUXejsOVyeS4hm2x219vafr/Kz/IOGP2NyEF6CTVDz0=;
        b=d6x05oqjoyMLjTORBo3r5Ef4AvLXs8Iqj5BbjnXjNQC1b2uPoMDcAdiliRmvVGhB/0
         7ob/P8CMSEgRpzpLx0MSD3Yt/bQvAkKgxTTLFm1z4AQAM22bvAI2EOrjOx8+f1iqSThp
         Q8tcxtTcMRPIDXzph9ESr8sw2ofXzaP21gTo/OL9e2dB8HsfqiEspyjaK62wzOBHUe+4
         SHIzrGQuPi8x2jFtMBxVBNmXzvPuyE8wECXGvCu5rb17jAc3wNWghSMO5WMSxK/Uq20o
         9x8FcRJZK5ZSAfRZHlUcpLIt+BB9jyMeYpsrk6H6qjOiHRz+kXcRVSRF9ocQU8DVAO6s
         tLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794652974; x=1795257774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gUXejsOVyeS4hm2x219vafr/Kz/IOGP2NyEF6CTVDz0=;
        b=lkRgTSNWUfhmXbrslMfnIy4rUKFrHImfHVb2AXlg5VI/i7ai6sixcau0uoe6hO/1ax
         wlBKP5A/aeoylZIAEvBeDax5U+j2CR1nvhntLn48Y4J+EX9XXYFAVwx32b6Y2UYJZjVz
         xfJWLwth++S0R/v7Nm/7gffb/5p6rP65AXKslNq7//HtQ8rAArdlqbQ2cd5IFkUsLHGS
         7MXblkCnmVVsHX9VHh3wxJ8hgkyrYxrTgwJmUbzQTsDxYfVi4KZAyw3f59TZMIOI6gfZ
         knsC7bSUiDvlZKPcsPY+6jPDkapHULeh2bQrDxbRPvfaa7371yvQqhcCSOeMjxrC4ciQ
         TlWg==
X-Forwarded-Encrypted: i=1; AL+hErFCs/CpjeuMIsaNjf5hH9EO/FRLP0BVgCRAaDOmv2ncxQOmAIC7873Y6HZROhOmLyNtfdIBglyCdw==@kvack.org
X-Gm-Message-State: APuU4Z9sxB9IOTXsDGyoGt/kEKOw2iAgop/UWANkjndSq5ZN77teMNot
	ECfNtJDxQC9YqjLfwY6Yjr/dnSB26HEhOfnAq7MiGC/7enboZVIiCwStaLZ6PzEyWZo=
X-Gm-Gg: AYBFou0iTr2C2QBeZRIbKWHqnnvO2+BpDmv4iiM1eWm9YwxY0+3wqBA/31+qwgcRfFF
	jlDJu2XCWXzVb/TeNpp2CRliz0IA/boHqXFDva1lvuFDBycsUiRB/LlZjoiveRU9EAmIA44jy35
	aS1LNz8TBUJxtD9JUfyViWnnkvKsxyc+er8LIYh3BioEXmCvD0rr4RRk6/J4YCugIFndOaAaZg0
	G56VPVvnRdd3FKcDL2cR16H8AVyR8bX6Ijvr0LIimEb3x05KY5IVEZJgHAx9L+IgVUuRTKHMB+p
	n1Pzn3DybCux/7UCPOwSCQoa/zX9XsoNhKFbE94Vgbc4CR2HqFGbvrZZAviiy1h/4Z4gSLBr2Dx
	giXsG5snj305jUmA+SjCa89kj4RLXEpvD7EN4XIAdzWAu5xamB2t4X1+CzKntJnKGfvYPNn1nQk
	RMbMSwzI3NhcdDr5eGwLpzpA041Porj3lk7WqUvDulDxcXJliUPEDMwpmj+CuzM5o6SkLbVkxDq
	L49pDOY+u0ISdiOgJNmWXG1/jNybhKaUCmar3cblD9Qs1oUrPXnegM8kQRSA6Vqy8F2aTCF2EJF
	c3L2/qW2M6y4omD5OvZp53jk/czy+55oVTuVvqR6aBzKON4bBamWvLKS6nrYuiaU83NH7LZ+PEw
	yqPGd3A==
X-Received: by 2002:a05:693c:8244:b0:375:11dc:7222 with SMTP id 5a478bee46e88-377e16e4fd6mr8253235eec.21.1794652974225;
        Sat, 14 Nov 2026 02:42:54 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:9d36:3b30:f4a3:7b5f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3795533170csm15772917eec.7.2026.11.14.02.42.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 02:42:53 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
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
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Mostafa Saleh <smostafa@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Usama Arif <usama.arif@bytedance.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH 3/3] kmsan: fix metadata loss during HugeTLB struct page reinitialization
Date: Sat, 14 Nov 2026 18:41:49 +0800
Message-ID: <20261114104150.58424-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261114104150.58424-1-songmuchun@bytedance.com>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: urx1yjjxyn51bybrtbqjcep1rzq83z6a
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A24B180002
X-HE-Tag: 1794652975-525515
X-HE-Meta: U2FsdGVkX1/q+T2s49q1gJtgux+WCCATmAghqu1TFcososA2/8iAppWHO3PU0XRLNooSmB2trS5yqA8iSkvQg97rzKhmX+LxfeWsSnp2FO6okOD7Yhic+LArsuoldO/Rg3c1WTMHuIZqk4R/6TeeBtqvA+r+lJSfqn68wYb/Ks8a/ydAvZCw8ri0fF+Zu7OFUxhzmoiVcQVxSK3sVbWphjxNgOBXj7J8YG5gU1EWGgwcL546E7ZL6ehFGlx5/m8n7wnZG+wfuR2fqsG/QwtPqfqJB0AP5fpyS5C6kMmsb9bJwiYZr40LXyO9nl1lxhTwzSHCDVbj/CDBqlYPIBkX8/5G/bXjmEHVv0cpVXJLHUo65E2dwGiKq9W23TOp3i2aKK13JwSQO8h68xIayRsEvpQFAL5O8CoHPgkE2HbL8/sgmn7UnTB9dW7WZRZfUPHa1BkmVENXUHjsg2biumkacn/S97PXVuruht2bH5MR39AQQSgRUiTWg+D5Y2vzuzd+AY3YY6Do8vWCIPePUo9PKhQ7+39oZpe7wUhgmWaf6AvHEfzbEZgiYPRvi0XHpLwHgsqW6NBqMds0+CQh/Bh2frZGoobE/Bc30nNjKJQsI69F8Ffbw44llTO5jp8zh7G62nK9rfSkhvlkNYQeO9ngCMIOzA/Aoh2Zja8mgAuugA+Dl75Pd6Wj9W3vhLp4af3b0Bc1Vl1H2CeLDBBiChnWtwGii5IUdDiGIG5iPrILTc1voGTTpmEkyEXjSi/3SNuwQ9Djz4uScYw4TyGoDH30qirlgYgViCQlUECa3EX6yC0dw7kJZgv74TvIavldma78CE8AN+3gmrf4sx1pxUd2sfQyxUPUBdTK3XW4nbyVeyouAXRHJkwqwZ6zyByVMGt61gEfHudkU+bh4EHiCGg3N9Dp/FwIVQ24meULZp1RRBQZCZC2WCtbYk5i+iryiGlmka5YwBT749olpTNMjjF
 xbseT4iB
 ltVz6CSjb0Dxxmq5cDJAtU2V+e1cNdMplCgJ4iy4jcdcyUAkv0qW8c6ejnggeHSyyE4pdcl7M1I/w6zuvfWwBKQu74lOIjuQsW0EwxwRxN0r4jq4CU2fdp0jF5qYIldnRU4pyg1hSm2GxKDd17FMIt3s4EaPVaq/yMwQJI1givgrk8nv4ncBRTn/hLB7D+YkDYk7xA8HXq2l6cm5gmuQszGUMXgsxXeeaGLQFJVcunuq3zaHsYi3cTtFIITABHewa7y1szyrf1zuvpQjWG8BFNrQzm4CRp8aXa/Q5u1NV9pAhXbNLC08fatKgJBR5/P9dpDRbXic4I0XFMTwKaZA0TnTt8YXuLN2xShnKQG6G4SUUdTy/0oBb/N8d+Esjh668JJUqK7ujQpty9hE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMSAN stores each page's shadow and origin pointers in struct page. Late
initialization of boot-time gigantic HugeTLB pages rewrites page
descriptors after kmsan_init_shadow() has installed the metadata, losing
the mappings and leaking the metadata pages.

Store the pointers in page_ext, which survives struct page
reinitialization, and request early page extensions so they are available
when kmsan_init_shadow() runs.

Treat page_ext as part of the KMSAN runtime: use a raw lookup under notrace
preemption and compile page_ext without sanitizer, tracing, branch
profiling, or coverage instrumentation to avoid recursive metadata lookup.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-ac161ba4-30cc-4bd3-b93c-ab7af8a6f64f
Fixes: fde1c4ecf916 ("mm: hugetlb: skip initialization of gigantic tail struct pages if freed by HVO")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/kmsan.h    |  3 +++
 include/linux/mm_types.h | 12 -----------
 include/linux/page_ext.h |  1 +
 lib/Kconfig.kmsan        |  1 +
 mm/Makefile              |  8 +++++++
 mm/kmsan/shadow.c        | 46 ++++++++++++++++++++++++++++++++++------
 mm/page_ext.c            | 37 ++++++++++++++++++++++++++++----
 7 files changed, 86 insertions(+), 22 deletions(-)

diff --git a/include/linux/kmsan.h b/include/linux/kmsan.h
index 7da9fd506b39..d7498abe7d42 100644
--- a/include/linux/kmsan.h
+++ b/include/linux/kmsan.h
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 
 struct page;
+struct page_ext_operations;
 struct kmem_cache;
 struct task_struct;
 struct scatterlist;
@@ -22,6 +23,8 @@ struct urb;
 
 #ifdef CONFIG_KMSAN
 
+extern struct page_ext_operations kmsan_ops;
+
 /**
  * kmsan_task_create() - Initialize KMSAN state for the task.
  * @task: task to initialize.
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
diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 3b66720ddb18..4bca34450356 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -87,6 +87,7 @@ extern struct page_ext *page_ext_get(const struct page *page);
 extern struct page_ext *page_ext_from_phys(phys_addr_t phys);
 extern void page_ext_put(struct page_ext *page_ext);
 extern struct page_ext *page_ext_lookup(unsigned long pfn);
+struct page_ext *page_ext_lookup_raw(unsigned long pfn);
 
 static inline void *page_ext_data(struct page_ext *page_ext,
 				  struct page_ext_operations *ops)
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
diff --git a/mm/Makefile b/mm/Makefile
index 277b97f7f8d7..7655f87fe974 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -17,6 +17,14 @@ KCSAN_SANITIZE_page_alloc.o := n
 # But enable explicit instrumentation for memory barriers.
 KCSAN_INSTRUMENT_BARRIERS := y
 
+ifdef CONFIG_KMSAN
+KMSAN_SANITIZE_page_ext.o	:= n
+KCOV_INSTRUMENT_page_ext.o	:= n
+UBSAN_SANITIZE_page_ext.o	:= n
+CFLAGS_page_ext.o		+= -DDISABLE_BRANCH_PROFILING
+CFLAGS_REMOVE_page_ext.o	= $(CC_FLAGS_FTRACE)
+endif
+
 # These files are disabled because they produce non-interesting and/or
 # flaky coverage that is not a function of syscall inputs. E.g. slab is out of
 # free pages, or a task is migrated between nodes.
diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 8922d1ba9a0a..cab8896e1fc4 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -12,6 +12,7 @@
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
+#include <linux/page_ext.h>
 #include <linux/slab.h>
 #include <linux/smp.h>
 #include <linux/stddef.h>
@@ -20,23 +21,56 @@
 #include "../vmalloc.h"
 #include "kmsan.h"
 
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
+	.size		= sizeof(struct page_metadata),
+	.need		= need_page_metadata,
+	.need_early	= true,
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
+	page_ext = page_ext_lookup_raw(page_to_pfn(page));
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
+	page_ext = page_ext_lookup_raw(page_to_pfn(page));
+	if (page_ext)
+		*(struct page_metadata *)page_ext_data(page_ext, &kmsan_ops) = meta;
+	preempt_enable_no_resched_notrace();
 }
 
 static inline void *shadow_ptr_for(struct page_metadata meta)
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 8578f52a32db..caffe29421a1 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -12,6 +12,7 @@
 #include <linux/rcupdate.h>
 #include <linux/pgalloc_tag.h>
 #include <linux/iommu-debug-pagealloc.h>
+#include <linux/kmsan.h>
 #include <linux/slab.h>
 
 /*
@@ -94,6 +95,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
 #ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
 	&page_iommu_debug_ops,
 #endif
+#ifdef CONFIG_KMSAN
+	&kmsan_ops,
+#endif
 };
 
 unsigned long page_ext_size;
@@ -170,13 +174,12 @@ void __init page_ext_init(void)
 	invoke_init_callbacks();
 }
 
-static struct page_ext *lookup_page_ext(const struct page *page)
+static struct page_ext *__lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long index;
 	struct page_ext *base;
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
 	base = NODE_DATA(page_to_nid(page))->node_page_ext;
 	/*
 	 * The sanity checks the page allocator does upon freeing a
@@ -191,6 +194,12 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 	return get_entry(base, index);
 }
 
+static struct page_ext *lookup_page_ext(const struct page *page)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return __lookup_page_ext(page);
+}
+
 static int __init alloc_node_page_ext(int nid)
 {
 	struct page_ext *base;
@@ -249,13 +258,12 @@ static bool page_ext_invalid(struct page_ext *page_ext)
 	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
 }
 
-static struct page_ext *lookup_page_ext(const struct page *page)
+static struct page_ext *__lookup_page_ext(const struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
 	struct mem_section *section = __pfn_to_section(pfn);
 	struct page_ext *page_ext = READ_ONCE(section->page_ext);
 
-	WARN_ON_ONCE(!rcu_read_lock_held());
 	/*
 	 * The sanity checks the page allocator does upon freeing a
 	 * page can reach here before the page_ext arrays are
@@ -267,6 +275,12 @@ static struct page_ext *lookup_page_ext(const struct page *page)
 	return get_entry(page_ext, pfn);
 }
 
+static struct page_ext *lookup_page_ext(const struct page *page)
+{
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return __lookup_page_ext(page);
+}
+
 static __ref void *alloc_page_ext(size_t size, int nid)
 {
 	gfp_t flags = GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
@@ -553,6 +567,21 @@ struct page_ext *page_ext_lookup(unsigned long pfn)
 	return lookup_page_ext(pfn_to_page(pfn));
 }
 
+/**
+ * page_ext_lookup_raw() - Lookup a page extension without RCU checking.
+ * @pfn: PFN of the page we're interested in.
+ *
+ * The caller must prevent the page extension from being freed, for example by
+ * disabling preemption.  Unlike page_ext_lookup(), this function does not run
+ * lockdep checks and is safe to call from low-level sanitizer runtime code.
+ *
+ * Return: NULL if no page_ext exists for this page.
+ */
+struct page_ext *page_ext_lookup_raw(unsigned long pfn)
+{
+	return __lookup_page_ext(pfn_to_page(pfn));
+}
+
 /**
  * page_ext_get() - Get the extended information for a page.
  * @page: The page we're interested in.
-- 
2.54.0


