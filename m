Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEBE0C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:33:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9937C6B00CD; Fri,  3 Jul 2026 08:32:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96AA26B00CE; Fri,  3 Jul 2026 08:32:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7D96B00CF; Fri,  3 Jul 2026 08:32:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 634DE6B00CD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:32:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8193C2885
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:42 +0000 (UTC)
X-FDA: 84947404164.03.802DB46
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 339C840007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:32:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kuJpEVi/";
	spf=pass (imf11.hostedemail.com: domain of 356tHaggKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=356tHaggKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081961;
	b=SYW8RmCsXhnXdMkjjUAsQpKhatc8xTU6BU2Kr5x66eNVSzBM4CeYGXPIJlNvCC3zGU9T4e
	eytdkjyVf5BuoPDnBLOoSYaIFCOCXuxDskkIVGId//1p2PtS5gR+yIE/HSBTfLLPEOdCDC
	CJn0bswh+rkuJcnEYR/DZLLP7Y93Cpg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6S3JNEhTHh8S5PWRfrbe8AKMasrMsda1UyR5Zu08tMA=;
	b=eP56vbYg6N8mAJfRJTggbR1tKO568oJnGvx84uzcrzQmpDgk5Eor/Wq8LYPHtuvinnHkLu
	hDcDV2iuSGWYI53q7RSmDXNEyTg1MkXn7RVkA5kk1ZvRaIIDahpIv3nd94M9akN5hrfWqK
	gS/5tjoZM4xgvdxsB6w2KITMOptpfOA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="kuJpEVi/";
	spf=pass (imf11.hostedemail.com: domain of 356tHaggKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=356tHaggKCLYfWYgiWjXckkcha.Ykihejqt-iigrWYg.knc@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493caa3c54eso5191995e9.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783081960; x=1783686760; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6S3JNEhTHh8S5PWRfrbe8AKMasrMsda1UyR5Zu08tMA=;
        b=kuJpEVi/FRf+N7dVr7Tova04SLDjP3bKJhkrlcowZVKEwFJKSXchY8S28fdsc01bU5
         n+nVKGU4AUTcTpcJBtO0bZ/OmNnYTXL65VSmFqFvPan+s96LCuIJ4Nh+HXnBMDZNURAl
         3w+wrvCkhAKFkz1stx5fhVJUVta99qq/4MVKHGxBg0ekOZ8WW6Y/qO+336iitBFMxIuy
         CyFGYX6E1CxLK3RqqMKeZoCYXYdk2WqsDlwueoGFcp3+4Z1q4UjmiBN4yybxjVRkfSrv
         KN/N6eO25FartKuRHNnv1faZc+3ZxTHQGJp2k1uPUv3fcHApKyLVrgUuC6CkVBAkdXTr
         uxsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081960; x=1783686760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6S3JNEhTHh8S5PWRfrbe8AKMasrMsda1UyR5Zu08tMA=;
        b=OS/8ofbEHJHlKKd4BS3Qh1IsvCibSg/rRWEOpL8yXuhp4WpuwCYwFrkP82DtbYYNJ8
         vv+y1I8jIQx/RYuYJfOwbEumr5FZXzKUHwdaxZQ/xwXyo/BPVESl5ZaVgCHpWWbgN+WV
         PFP4QRa1obO8oRomqkyDwlXCxubSY+Qx1/BqQiW2rec0anqESlbmGuOu99CAfkH4cMNp
         Adb0xC5GcvBy1sGl5elIhFt3kKFibOqmB0ryKja1qyV/SbbDtH4WfFAErBU/ndv5ekzy
         oeM2ZuvpU1C0Ur0zkpXIBAyzXXicIudQxD13DnANb9Bq3R45ZT0uRVk58QGYu+dOs5ch
         IGVA==
X-Forwarded-Encrypted: i=1; AFNElJ+CIyi3tK4S3vQRRlA38FCojSdNO6KbksQpvAQX2QN7WBJNXpVqoiy9GbuDMVSGOZYGwerxpD8bFQ==@kvack.org
X-Gm-Message-State: AOJu0Yzrgo5vfDRzMckpjsF3mlLEh6h7kQJmFfq3UFaRGns3UPYRHRXf
	/aRUYZ3kUonvBQGNM0hVVQuCPm36SH6MEc0dKbsu5lSyz/5euxXR6mT9FmLSpcI67Lx2jqdNKr5
	Qp2KmQO6f9jy9yQ==
X-Received: from wmg3.prod.google.com ([2002:a05:600c:22c3:b0:492:4659:9cd8])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34d4:b0:493:b8cf:cc8a with SMTP id 5b1f17b1804b1-493c2b3ccd2mr128779195e9.4.1783081959528;
 Fri, 03 Jul 2026 05:32:39 -0700 (PDT)
Date: Fri, 03 Jul 2026 12:31:56 +0000
In-Reply-To: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
Mime-Version: 1.0
References: <20260703-alloc-trylock-v5-0-c87b714e19d3@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260703-alloc-trylock-v5-16-c87b714e19d3@google.com>
Subject: [PATCH v5 16/18] mm: remove the __GFP_NO_OBJ_EXT flag
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	derkling@google.com, reijiw@google.com, Brendan Jackman <jackmanb@google.com>, 
	Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 339C840007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 8qdxiqxafri6xu8x4p5onq5o4sgmzmfc
X-HE-Tag: 1783081961-503261
X-HE-Meta: U2FsdGVkX1+YZO9QbMH142purpAqVmQ7xR+PQ/mnQ60qL0ZQ3ABi8tDjr5j9rovigHX7g5N/fTy3kGy/2VuyL3x7ZtvTbzF0gJMXQrws5yuv1aSIKJI7iMUQR5QAwH7zFbod8j5C0TDqouYs5RY/NF4iVG4ev6tYr66q56c8Ica28gxsg23tBZqHdRzRgLa0Fg8/KYQyMzvk0rw1mbgAKGodHSScPzoW5QcrSre1HISHjeRALGFKPkivDyK27Wu5qnyLY6GiItgesWVSapmee1H9C9ow+pfidHkt8H+PT4iJ88+2whv02okZSx8hqMM2GNco3DnzVLeOWlU8/JfI4n8HIr7K+ni09m5kNzXvg+jMhEiC/UScHwy8raRNYLjyzw0sMfNRoojMdVmIO7jalsF1RdBl6HVZK5uDcSlgpQEIbE8uYN4yEPieCf3il2bCeQ4CXLVda6Ga1+LFwT/tQ4qJKsGRbLw04CmpwfGiB2V1yzJtZNAkHqMj+7bTr381bKDYOZIY6I36AlBe4erkmzuuDUvJv1j8qEwJhQt9H2HbNaA05EzqK2oGvxFVRZ1MvFcHsV5uMabYyxV5ceFo50ANjouORrJ2AflEWGEFn6kPPpDHA+lu82492JxblLvesPcAb4axxfEXdQA1411VSwn/I3R5QKYBSzFN6WjT1bK90sKzrX9f2HRjqAYdyHudFFzoU85GpYZ2csAz+Dh2N1in/WAiRlkNh5zAzdQX9N2ht0njT2DFdsM2ik3TAlsBGY67uMDB9NuDji+HZLJpgu3xD+RN/O1QV/X4Ouw7uO6s5u5VcJrY+IHAHZwfNVx3IjcpIfDMxa1py1S7EmSOA673AxwDerT52vzxfevlabEcwZXFg26vLZ7Keveyzwo/zl7NgGF1CyRbV1dbMlVh3mjzo1H8zqLUwl7QPKKLv8MJ2Qt1ah8y36QFaRX9F6IrtePpKs+sUyAkirYuQpj
 7fTX53yv
 7yIEBwjZzI1SAIyfJqrVrPnEwqaDu8+elpFgDLWi45isL4zM8OIsUMLsXAkslbVoXGwafFoAfuEsM0W4858H0Bfp0ibYnOl4zfV3mlnLJw1pMuo04EdsmQHBF7z1DDku7LLISBg2eOri6Z9Ifp6yg1qjDi8Cl0n8+pglezTQpQwoSwVJEUdJFC15BlsfRusoXjU36ML589x1ws8+jG8s4UfLZ9BeaWzvWwTJS4DwMd0ctkNLX9jIWHZkuabbUYPBIcmeiBIhVh0mTZOFArv1peMOAz98Fkfr2xx0jwWRKat/WK1hE1R6uzyeVUHeAfpk7EWgv6nJfQsHoommjdWEBE+QBblVRZVOQitCwY6LkePl805SJmVmiTxZF0i9B8ryQy4KIX9UmMCTY72tJQDTweeYS8x5yBh1FVI4HOxqkW+S79c489tdMacyJKRD/MyCxr7XtLMoT4joySb7im1CcOwLevuIIsS416iK1YI/yXf+/s8mrws7PNKVoI16R/YftpITk6sHzQ53RLaYumWg6q/cmoNGgEhpgP0ZqgUCdJVi40N0CuoXeTlKqrLO1EDkyqeWxzMwSaKsszvasVXJKPRBaYdtlBCf+oPhsGv93jTnHW5MWeOC2lZXpD8C4RdAVk2+lcQbsXfWp+Fth1bdhlKF3XQ/e1PO0DpHgwXB+fMsVxVSjTALeiwskYSWLz0vpXXO+HaKk8uDLvYo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>

All users of the flag are converted to SLAB_ALLOC_NO_RECURSE or
ALLOC_NO_CODETAG (from __GFP_NO_CODETAG which reused the NO_OBJ_EXT bit).
Free up the flag bit.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
[Rebased onto __GFP_NO_CODETAG removal]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp_types.h       |  7 -------
 include/trace/events/mmflags.h  | 10 +---------
 tools/include/linux/gfp_types.h |  7 -------
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 463b551d12d99..190191411009f 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -138,17 +136,12 @@ enum {
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to the active
  * cgroup context.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b429..c1a05ff0feab0 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -54,18 +54,10 @@
 # define TRACE_GFP_FLAGS_LOCKDEP
 #endif
 
-#ifdef CONFIG_SLAB_OBJ_EXT
-# define TRACE_GFP_FLAGS_SLAB			\
-	TRACE_GFP_EM(NO_OBJ_EXT)
-#else
-# define TRACE_GFP_FLAGS_SLAB
-#endif
-
 #define TRACE_GFP_FLAGS				\
 	TRACE_GFP_FLAGS_GENERAL			\
 	TRACE_GFP_FLAGS_KASAN			\
-	TRACE_GFP_FLAGS_LOCKDEP			\
-	TRACE_GFP_FLAGS_SLAB
+	TRACE_GFP_FLAGS_LOCKDEP
 
 #undef TRACE_GFP_EM
 #define TRACE_GFP_EM(a) TRACE_DEFINE_ENUM(___GFP_##a##_BIT);
diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
index 6c75df30a281d..a93b8bd200b76 100644
--- a/tools/include/linux/gfp_types.h
+++ b/tools/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -137,17 +135,12 @@ enum {
  * node with no fallbacks or placement policy enforcements.
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers

-- 
2.54.0


