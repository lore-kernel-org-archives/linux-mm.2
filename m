Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 509D8CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C9FD6B002B; Fri, 29 Aug 2025 14:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CD86B002C; Fri, 29 Aug 2025 14:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47DC86B002D; Fri, 29 Aug 2025 14:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31ADB6B002B
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:32:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F336EC094D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:17 +0000 (UTC)
X-FDA: 83830639914.13.9CB0083
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id EB48E140008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:32:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=W2uatzY1;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756492336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WZ7PnN3wq5wKP2KT/uKeKbuD4jQQEwrG/IUaCtApCAs=;
	b=mmr+Oc6UVLMZYO4Ra/XTzpOXyzWc/DCIf6G/CKQixMt9CKpqnr4kBfZCcJQvjy9MVmBprZ
	tnSR4oTd39JWEpaHbIpQj6DXFQcczr6A4iwnxmsJ/44ilYdp2uzPCu7v/OuQYiguYANfzw
	0weCpW2iXMR0+AmMrLidmmNxBuvb5go=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=W2uatzY1;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756492336; a=rsa-sha256;
	cv=none;
	b=RnfYiLEy+mO0+6Ev1xN3a9W6+plHeb3mEGLLm2Qt7tlx3Awtwt3bngwDHaKWFhOwIdY6QU
	hFsK0Dn/16eOBBIdhJh9ChWkguGSu5/+yJMpkm+fTyeu6DgLh/yrAgOLM3GNGMgwHqm59r
	ZN6RnnppiTH0VlwlTCZKCrBFp2N7F3Y=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-afec5651966so443750766b.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:32:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756492334; x=1757097134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZ7PnN3wq5wKP2KT/uKeKbuD4jQQEwrG/IUaCtApCAs=;
        b=W2uatzY1e+z/kbdouL4Po/a4qraTKIHtAqug4MSTjvpU35qQgG4umJhkY+zmMzRlff
         hHgnn6RP/cnFiHMeXQU96e5i4kSTCkmIoEua9FQhLH+dfq/9NWA4tFcdIzJOkceZHPp0
         RHP7Na4zjO8ke3BcSlC4pBTl9TvYnEYlJJIAOiMIJy1f5yAWg07TiwT/pgvYRQRSqqSi
         PMpfRVtNfrM99ToUjCHLxDgRSXJ0bx8yi7SjWDu+4eIVrhKg8YK8t43NUwQMI/Qv/bWq
         8OfCe/4By1Ffp8yC62GwZ12lDUbZh+ba5FbFhpMAlyegrUOLNNpzSuiL+XQV9IhoQ2pK
         sEYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756492334; x=1757097134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZ7PnN3wq5wKP2KT/uKeKbuD4jQQEwrG/IUaCtApCAs=;
        b=NWTBC+eXL+5T8jYsVzZnTiE/Pmi/f0p5jqDCsFJzF0M3ONJaaTG4uYrY3Z7+nfCFuA
         6g13cxKWDNdtqgk8f4iJPEv35/Q7K4r9zefoKLGYkhtDJeZv6gKE8/2H2QyNitQYhCPB
         A/JIbrPBGDDuQmjdseIknIkG4GXXMQdRyb4VUMyeuz8qMSnI44q9WoMnjI5GVBliCCkX
         W4QdSPvdH2Q7W30O0rnjm9sj3LigxR6mKIuXZ9ejzkbR/MnJZRG/2kvdK6AoW3IZwk0C
         oidHYEuDgayX5MrjpoO60jfRVQg95U2NhrF4escxeBkFaeEWl9T3r2bOTo7qHy83TuUt
         6inw==
X-Forwarded-Encrypted: i=1; AJvYcCXgBNw4+s7FIFKfjQWs1HbGBWEGQTvpxBy4btVUKGMaASGR+usemi7ai7dslbYrTUDZL/7OT+ZT8Q==@kvack.org
X-Gm-Message-State: AOJu0YwHPrkh3VAhzwmgJPdJRKrd7U6XLkv/gLAV/1Vw5LQQhZByjJX6
	PTUiDQX7boo0REBnMDg9hHM//FXlZkgiorPZHXlVlScMMRMhiZ2LytDIDDLow92d/ne9iZDQHmY
	1mUIo
X-Gm-Gg: ASbGncuX7eek+rsZZuIAZReRlBC8XbkWfSScO+5cXT5sxHewpgV0xjqWg/EGmN6qoMQ
	nK00bnNDXz3Lch4bZaowAMoHzCGiW5QVSBn3/SdFGYlLKru+k395M1IivyH2XDCg3xBA4xzW+I1
	vYsjTPxTq81kG4ETUwb5FiP6bQs904SrRgpTwtVSdW642M/GXJ7MxreP8jS0f9xFNCRbK90ZKDA
	Rm2XX/qAY79mYnMsay+SsiLyeZ7JLLnshxO92H8NK7tgxWAOZUSVyhsTFq4xXGLtn8J71YmH1HE
	uMEobn2F/6H4sT9be+WK0Q0LKYrviC7FpMCelEpkX739RDdNEUT6MDapq9Wke3nkmK+dWdADqT7
	EDIe8/Gbvo4NIKozlFieTxWuWC/mHRc39h5IhzNzlKQ3IkLslQ1vU1IGBZA6rk4qjsvDaqlqjpr
	VHmuPgmOGYCSFFIMcHx5yhJ5GIpZDSBk6Q
X-Google-Smtp-Source: AGHT+IHzJOTy2luKB32sVUhBKgOt2xF3771qGw0tmV3b7MRDICZMtNEq1NDAa3bFUq1AzPVA5KaLMg==
X-Received: by 2002:a17:906:2a07:b0:afe:844c:bdd9 with SMTP id a640c23a62f3a-afe844cc4e4mr1495547066b.11.1756492334350;
        Fri, 29 Aug 2025 11:32:14 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefc7f1174sm257964466b.9.2025.08.29.11.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 11:32:13 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 08/12] arch, mm/util: add const to arch_pick_mmap_layout() parameter
Date: Fri, 29 Aug 2025 20:31:55 +0200
Message-ID: <20250829183159.2223948-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250829183159.2223948-1-max.kellermann@ionos.com>
References: <20250829183159.2223948-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB48E140008
X-Stat-Signature: gys6m87udzcue8yxjkhr8e9xodok6ajy
X-Rspam-User: 
X-HE-Tag: 1756492335-934217
X-HE-Meta: U2FsdGVkX19fuL4bM3r+UhQEUG2vuzW2FUdugsOFt8cf2xjCz0051aLLRLrwkukG0JO8zkLvKeI50dKmIGCl57uxotHVWIWlk19XXT+NtAIotlkP+QE3Zwdmz4CVUgBYkcfhtPT0sy5jx4eiq4MLXxlYoazHTeVQX1XcjMhBV3isd91mHSAeJPe2DaqE1Ic/pp7I1lYt0UGDDrPv0Lv3JzZhZf/bNM4/9RLZb5Yy860j3aETceFJlBIkZCxHnFWdCxUGYzi8weIj/cWXFsUdqLOO7UKOFEwKByYnJ6W1j38gl+XQGzNx5oe7N/fIVGpQU3rlUommOyrruZRTX8CPHRR7oiXlbL3gUHHlP78eODp/+W9dlnH3mGJ8J13u9YR8YdkHo0Y4m8tvmWfAHwU7WbVYYjCv0ck94b4eC3v8pp2FKFRhXoM8fKMJWClUxyt7tUNyr2KC4WeqwctuWmB0KTbYVySU1myxKDJn248PbSrWVwikw6sD/RwhQAe6fTSNpBX6O9vZGoDm5khvKL2F8KHINKaVUDdpgciH2zZbBVMOukQL8sVqZKFipZue4UptfGcYBIG4JntYFBYWQvarsISuLeoOeFgK4Ggmo6LuhGtAfi0JQ9fYzT2zicxGLZHWUXZr2EjJJFApo/TzSSSOMvfiktiJlikNS2y2sGorD96FedvPZY/6fwIRiOPUlE03mcnpzWi5SqZvk/f2kgsFprhsKWrzHQAyOHtbKa/oD5jIb2SANUavey5RmnIIsx0pSAXDa5ufunQIMDIzf2RCu6tw86nqtJx9ml++eG/zxj/6UU3Df9kXkOmsK5NQ4VESgIckh5rQ1cOZr9+iJcVi3l9QDhgMttUju6MQXeb1O960wWFqqvBNu/aS6jluAaaH6fp81MlluWq9nwn1uY1xR+c1nUNQtGzzel1r4cCUrt7uQm5lNmb5izGG55/inKCXfK3cp7J1hOepDeARdTF
 6ccyQ7cD
 vX946tBXoyuL482ABRyK2V5lG90xGEpTKHQCwlof9lckOeLs0z5httyJhCKVxoUCElHotXgS1j9lg2+s9pc/LrKGwNtuiDpvF8IG84juVCgzadCWtAwoB4CaDVeOozEJog9MUlk7Du18ZiHt4XQ5P37BkZN/xF82kEZUbA/A8QPl5q6aalHc6ka/dAaOqym017NK2iezTbcDPdv4vtVLbMWroia1BOpY7x9JVffyslwsLMexFLm9zdaxqD1xSJTXCmlNp2ZClEcEUIe4Fo+gkjS9fST/0umkyQi0zT7gQcscRQ6lL7hA6PkBbgaDR+WGKwnXU4VtLdgSiwaPkw6kpAs/zu48kNQVIqcOePmnCXzuo1T8S50aTpaMKyMhkJTMotQB+IzLPq24+2++tNkRuHirJ9WkOFBk/n4Em
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 arch/s390/mm/mmap.c              | 4 ++--
 arch/sparc/kernel/sys_sparc_64.c | 2 +-
 arch/x86/mm/mmap.c               | 6 +++---
 include/linux/sched/mm.h         | 4 ++--
 mm/util.c                        | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 547104ccc22a..767c5c26f9a3 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,7 +27,7 @@ static unsigned long stack_maxrandom_size(void)
 	return STACK_RND_MASK << PAGE_SHIFT;
 }
 
-static inline int mmap_is_legacy(struct rlimit *rlim_stack)
+static inline int mmap_is_legacy(const struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
@@ -169,7 +169,7 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 785e9909340f..55faf2effa46 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -294,7 +294,7 @@ static unsigned long mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = mmap_rnd();
 	unsigned long gap;
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 708f85dc9380..82f3a987f7cf 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -80,7 +80,7 @@ unsigned long arch_mmap_rnd(void)
 }
 
 static unsigned long mmap_base(unsigned long rnd, unsigned long task_size,
-			       struct rlimit *rlim_stack)
+			       const struct rlimit *rlim_stack)
 {
 	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_maxrandom_size(task_size) + stack_guard_gap;
@@ -110,7 +110,7 @@ static unsigned long mmap_legacy_base(unsigned long rnd,
  */
 static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
 		unsigned long random_factor, unsigned long task_size,
-		struct rlimit *rlim_stack)
+		const struct rlimit *rlim_stack)
 {
 	*legacy_base = mmap_legacy_base(random_factor, task_size);
 	if (mmap_is_legacy())
@@ -119,7 +119,7 @@ static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
 		*base = mmap_base(random_factor, task_size, rlim_stack);
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
 {
 	if (mmap_is_legacy())
 		mm_flags_clear(MMF_TOPDOWN, mm);
diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
index 2201da0afecc..0232d983b715 100644
--- a/include/linux/sched/mm.h
+++ b/include/linux/sched/mm.h
@@ -178,7 +178,7 @@ static inline void mm_update_next_owner(struct mm_struct *mm)
 #endif
 
 extern void arch_pick_mmap_layout(struct mm_struct *mm,
-				  struct rlimit *rlim_stack);
+				  const struct rlimit *rlim_stack);
 
 unsigned long
 arch_get_unmapped_area(struct file *filp, unsigned long addr,
@@ -211,7 +211,7 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 				  unsigned long flags, vm_flags_t vm_flags);
 #else
 static inline void arch_pick_mmap_layout(struct mm_struct *mm,
-					 struct rlimit *rlim_stack) {}
+					 const struct rlimit *rlim_stack) {}
 #endif
 
 static inline bool in_vfork(struct task_struct *tsk)
diff --git a/mm/util.c b/mm/util.c
index 241d2eaf26ca..38f8b9fa297c 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -431,7 +431,7 @@ static int mmap_is_legacy(const struct rlimit *rlim_stack)
 #define MIN_GAP		(SZ_128M)
 #define MAX_GAP		(STACK_TOP / 6 * 5)
 
-static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
+static unsigned long mmap_base(unsigned long rnd, const struct rlimit *rlim_stack)
 {
 #ifdef CONFIG_STACK_GROWSUP
 	/*
@@ -462,7 +462,7 @@ static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 #endif
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
@@ -478,7 +478,7 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 	}
 }
 #elif defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *mm, const struct rlimit *rlim_stack)
 {
 	mm->mmap_base = TASK_UNMAPPED_BASE;
 	mm_flags_clear(MMF_TOPDOWN, mm);
-- 
2.47.2


