Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0658CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 09:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA7408E0029; Mon,  1 Sep 2025 05:19:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59F48E0002; Mon,  1 Sep 2025 05:19:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC10A8E0029; Mon,  1 Sep 2025 05:19:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 993948E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 05:19:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A336C074C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:42 +0000 (UTC)
X-FDA: 83840133804.24.05893BA
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5C74D1C0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 09:19:40 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=WbVe87dn;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756718380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VyTvV8Ns7WO4gxFocxj6W6Ayk33Z4Ny3qHSpu0QqE7M=;
	b=FV4LvwKapjrQj3Bd4l+pf3Tw9J7NEdfKQtXPt/pW1QmVmmntc8+Zc+GaAKYJl2lj03VGi6
	Qh/vm8HLYrFnn+utbDZQDAXU3CZRCiNhlEg4plU85l04fTI2bqT5v16+g3sGDaz9x7t5fd
	Ei42WWIWULt4KKRvWVPCuwsTQvuK+MA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=WbVe87dn;
	spf=pass (imf18.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756718380; a=rsa-sha256;
	cv=none;
	b=gbnkmwK3Dkhp+plVIQI1PzCAQ8AxDoUb107he8NDVJWtZB3N63Wg1s9woboXFcZQYFHjNV
	niO6QFDeyrgjsDlyFrrAqRWYpzZ84KngNUWXr3GbJpGz/bbsgtdJE6MyssFAWcBZYta2qd
	a7i3lTXwjrTLiV+c9Hn+pQjzMHBNqpk=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b0415e03e25so139406366b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 02:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756718379; x=1757323179; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VyTvV8Ns7WO4gxFocxj6W6Ayk33Z4Ny3qHSpu0QqE7M=;
        b=WbVe87dnMdXk3JSVCW5Gxv4+ocS5XEd1soY9doDfU2sOKAiYUs8E80ajtxdQNQsWAe
         Pn+j4tJ5z4rzhVktEhseVkKqaUI/MVF5w3C9CuWni4wOutWwOoAlnDYj6rtlIW6G+uyg
         algOIS9MQ781FvBS6avBFQod7K7DPaWLESgquwuZ02jJ5pSocrwywZfGWPv028EX8NYf
         cxf8Ic1uXnDhPyj53SkLmqPn0w+oqacvGiwTElePhC5mbkcaPFUzRtQMI3lZ6rgYOX28
         CcOfZAUpw6lSRBvkJtxv3jAAdKHlQ8YtkI+uBHLoaiQs9gbzBz/MoMhkrph8sYJEDKgM
         oJJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756718379; x=1757323179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VyTvV8Ns7WO4gxFocxj6W6Ayk33Z4Ny3qHSpu0QqE7M=;
        b=VR3t1pX3sFO6h+4q46DIEs3wi1jweBO+Hlpm3gygqFZlOzev6/A0wwod2VXPVt+5gJ
         tDFX2YcUT0a1Mcz/CA3FrhJHtypqEF/DGDm8a/bkiKRX30uBRm1n7FYAyjLYE56kAs8C
         JqOem3bPcUFmjKk2EhE7gIMKgOJAwpCwPCGqZdP3mCgc3CnrHhFJa8gMTfhtz0EDhlVA
         jXVO5Vx+fTtB1vuGEojUnuzCcnsGs+mEtnVC8PQTHBrEevn+6Ner+1eB1lgIrjnUDBOc
         NkiedBvT+Nj9edbMTjLC5TenIalQGvZrtx+cKIh2aQqsuQQBGzCDw08i3sqiF1o+x9ZS
         NRPw==
X-Forwarded-Encrypted: i=1; AJvYcCU1yAu7KAINOLTALc5+uJlkaCH7w0Hod/ta7EmQnYGvwVfVA8kihcQMrV3ieewHec1eV3f6bheI9Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1rdbIyrLmASkmxoMrIoFvpTWyJ9Xy5VfV+0iBGRN5bK3WyjOE
	hh2lcEg8MwdYZpLj7WB8bD8RWhGWcjIuJGdLIEUp6zH7BUhAz2iKL0hKqmvbjRI9204=
X-Gm-Gg: ASbGncvUHl4NWsB4v305Ju1UtqmenurU8UcIlSLzFi+FUCLG2LbL4sS7LPDBMFUNB7Y
	0ORWvWrJvVOAnA0GeJo7hWSmMtreK1+Y8XM5C7icpZzyYf+q+wpt9GCWY7AUuvuZHHxF5XVpXp7
	c8FLjj16t+K0zxZZSWEz+NO/6pfj63GTm2cPkeQjL+bDsXKyAobXIzd87lSjLuC4rBqFfuU5qXK
	8krg2uRxFNuryrzcQxNYvyieYsQEi/b9YG9W6QdzN5d07Wfyho0Ue68uqJyL+xy7DG3lMMAnl5X
	6lx6LRK9hYZbeF/n2FS3jPNQqBPqOCdJatqAWANL/OA4sI2AFX65kj9NZntNZ2OHe+s/HaqN1yM
	ohQv8dz/R6G/F+E4CsOls6Y9eWoYkyWJ76m5hH2O2IczZbU6WiAEe9FLX1uNqK7QFzPdZkAYhUB
	MG2YLzvaL+N/KA8wnLDu4abu2rLyKwYACu
X-Google-Smtp-Source: AGHT+IFURNncMT6SvBoURvT042bjNg1LI6qShCkJRT6YVDiOMF2e2u0BBNq2L9LyHNh03wQZAbf6oA==
X-Received: by 2002:a17:907:3f10:b0:af6:2f1d:a73f with SMTP id a640c23a62f3a-b01d976e782mr721360666b.53.1756718378728;
        Mon, 01 Sep 2025 02:19:38 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b01902d0e99sm541005766b.12.2025.09.01.02.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 02:19:38 -0700 (PDT)
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
	surenb@google.com,
	vishal.moola@gmail.com,
	linux@armlinux.org.uk,
	James.Bottomley@HansenPartnership.com,
	deller@gmx.de,
	agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	davem@davemloft.net,
	andreas@gaisler.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	chris@zankel.net,
	jcmvbkbc@gmail.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	weixugc@google.com,
	baolin.wang@linux.alibaba.com,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	max.kellermann@ionos.com,
	thuth@redhat.com,
	broonie@kernel.org,
	osalvador@suse.de,
	jfalempe@redhat.com,
	mpe@ellerman.id.au,
	nysal@linux.ibm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 08/12] mm/util, s390, sparc, x86: add const to arch_pick_mmap_layout() parameter
Date: Mon,  1 Sep 2025 11:19:11 +0200
Message-ID: <20250901091916.3002082-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901091916.3002082-1-max.kellermann@ionos.com>
References: <20250901091916.3002082-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5C74D1C0009
X-Stat-Signature: sug9bxcdgmqtzek6k8h8atnqn8ajm6d4
X-Rspam-User: 
X-HE-Tag: 1756718380-696866
X-HE-Meta: U2FsdGVkX18ucorP/SDTyoi0Ql03qi7bLFXrwWGu5LYMTO1CJa7XXFkIrVf6mLJRyRuMY6jopM51MYKH0tesyY4i3/50WhWzR8lDrk8odEdObTQCiYawrJg1pnj+yXd3NtNTaKu1LXFvK9k1FeUqrgqywLQy4WHcYn9/5+ahiC3hBra/Oj5OjJEK9mhR3jvMtBMLqU0OrEFY0oNGkSMNZgkPvWVRZoNEyqhsfyZl+XuJpoKZIoVCOjeO6agK0ExXyds9lGZsns6hZ5gW0niKbER7T66onLdUHp3TWYIJBFR/e1rMCCmvDwUUTI8goEhKOszEr2oZvSxir4iJ4iNoJON2LT6skYW1HLUeFPdue/WRXyNHYBw2wNhBdq4FVvqlD0pvuIHe4QnW+3Z1pMJn7frHpY2eqoD3UvmbSvKNCm8ZtmhxPuI6RnusCEa57AH14eQK/CgVIy7YqEy9ZUMLY03nAvRADjlk6AUxgdPquffr3/xw771NzaA94Y3WjVdnE4hS9ZmqJ/VjQk6pLw6aZWOEWi2MJlClfmqse+8uM1J72Qf8w5h3Cwl5Yy49Q7NeWUkGX7gmBYus3kj0nK5wEy7zIkWDQAA0Adk5a5mC56p8cJBduMQYiQMfnBPzvpWPa9UvtpPJe/G6rK6nLdchW3PADtsnzuQyQFcbJF9QOHRzcjaFeTXR2jtZlcnuiA9Q0rgs/lYW9n5mRVjWVuBPoxlF59iI09Q8VTFEm9FQGicDlBemqSpC0ZiV7+G5pC95dK5omWtMBDMRBTQAN58riWjz3hIdWR3PQN6vMa55FUlFrl6W3hH+fXXUZvolY7Xz4/iWh+WoQbV4LXP67QFPnhbtTmWA6Bg1r/5lmw3h0WXvXBUcGh4M0998Ste3z0Mn7yK39MltNP1eoq4dvzaPrk9n6IFeHed54JeDf7adwL3qHrFb6fE4YZ7ufhX+szKJyuaHGzGHsM2zePSaaVL
 T6S6Kzh0
 zEVA3nWmN4gm8wst0mxK5J3nbckStbil1Mt9KDafOHetnjm7oeAFwt9CzjecFhoQ/+WxWhh1+bAWVFFcy4uQ9oLJHXgKeM7DwmpFBeLs8JyFKUvM0SBNk/668OnJLridbczl5wyBA0rd2qcWxvptejvbWHnPYsPBboGm0IMwZ5/Fj2MYC0P9CF/hA+/wkgHLwHLPOKeFdHUNrsYZcZQgXj3Ti05yJTu6TFykwNrzs5hH7nBZIgq8XtWCGMOf1BudsyheKf4agbVZX4AlUtjVMtXrFmzsTKoH2ElhfxuawJEMepYBOt0fSlWKsOGWyV3U1LMIluGLh2ed+6TAu+yPgyR/uFb4Uncu61dRmR09wJ0V2XeF4GHXxc1ioxSRMu8QLxSluFYGwMKy4mnuULGyaK6kl91FgY68twKEfqdgTtWwXWXY2OtmhaJdOqL2rt5nucGGERd1amkhEcwVaEr4pkgebEeAul5rNHr9zLZ5CYxuqdFg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memory management (mm) subsystem is a fundamental low-level component
of the Linux kernel. Establishing const-correctness at this foundational
level enables higher-level subsystems, such as filesystems and drivers,
to also adopt const-correctness in their interfaces. This patch lays
the groundwork for broader const-correctness throughout the kernel
by starting with the core mm subsystem.

This patch adds const qualifiers to mm_struct and rlimit pointer
parameters in arch_pick_mmap_layout() across multiple architectures,
improving type safety and enabling compiler optimizations.

Functions improved:
- arch_pick_mmap_layout() (s390, sparc, x86, and generic mm/util.c)
- mmap_base() (x86)

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 arch/s390/mm/mmap.c              | 5 +++--
 arch/sparc/kernel/sys_sparc_64.c | 3 ++-
 arch/x86/mm/mmap.c               | 7 ++++---
 include/linux/sched/mm.h         | 4 ++--
 mm/util.c                        | 9 ++++++---
 5 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index c0f619fb9ab3..a47c7133d82a 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -47,7 +47,7 @@ static unsigned long mmap_base_legacy(unsigned long rnd)
 }
 
 static inline unsigned long mmap_base(unsigned long rnd,
-				      struct rlimit *rlim_stack)
+				      const struct rlimit *const rlim_stack)
 {
 	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_maxrandom_size() + stack_guard_gap;
@@ -169,7 +169,8 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
  * This function, called very early during the creation of a new
  * process VM image, sets up which VM layout function to use:
  */
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *const mm,
+			   const struct rlimit *const rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index 785e9909340f..1c243bb461b2 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -294,7 +294,8 @@ static unsigned long mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *const mm,
+			   const struct rlimit *const rlim_stack)
 {
 	unsigned long random_factor = mmap_rnd();
 	unsigned long gap;
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 708f85dc9380..13bde4ba2f24 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -80,7 +80,7 @@ unsigned long arch_mmap_rnd(void)
 }
 
 static unsigned long mmap_base(unsigned long rnd, unsigned long task_size,
-			       struct rlimit *rlim_stack)
+			       const struct rlimit *const rlim_stack)
 {
 	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_maxrandom_size(task_size) + stack_guard_gap;
@@ -110,7 +110,7 @@ static unsigned long mmap_legacy_base(unsigned long rnd,
  */
 static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
 		unsigned long random_factor, unsigned long task_size,
-		struct rlimit *rlim_stack)
+		const struct rlimit *const rlim_stack)
 {
 	*legacy_base = mmap_legacy_base(random_factor, task_size);
 	if (mmap_is_legacy())
@@ -119,7 +119,8 @@ static void arch_pick_mmap_base(unsigned long *base, unsigned long *legacy_base,
 		*base = mmap_base(random_factor, task_size, rlim_stack);
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *const mm,
+			   const struct rlimit *const rlim_stack)
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
index f5a35efba7bf..24f08217cd95 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -431,7 +431,8 @@ static int mmap_is_legacy(const struct rlimit *const rlim_stack)
 #define MIN_GAP		(SZ_128M)
 #define MAX_GAP		(STACK_TOP / 6 * 5)
 
-static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
+static unsigned long mmap_base(const unsigned long rnd,
+			       const struct rlimit *const rlim_stack)
 {
 #ifdef CONFIG_STACK_GROWSUP
 	/*
@@ -462,7 +463,8 @@ static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
 #endif
 }
 
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *const mm,
+			   const struct rlimit *const rlim_stack)
 {
 	unsigned long random_factor = 0UL;
 
@@ -478,7 +480,8 @@ void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
 	}
 }
 #elif defined(CONFIG_MMU) && !defined(HAVE_ARCH_PICK_MMAP_LAYOUT)
-void arch_pick_mmap_layout(struct mm_struct *mm, struct rlimit *rlim_stack)
+void arch_pick_mmap_layout(struct mm_struct *const mm,
+			   const struct rlimit *const rlim_stack)
 {
 	mm->mmap_base = TASK_UNMAPPED_BASE;
 	mm_flags_clear(MMF_TOPDOWN, mm);
-- 
2.47.2


