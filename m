Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C2FCA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363C78E000F; Mon,  1 Sep 2025 16:50:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313D28E0009; Mon,  1 Sep 2025 16:50:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBE38E000F; Mon,  1 Sep 2025 16:50:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06CD78E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:47 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9FC58862E6
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:46 +0000 (UTC)
X-FDA: 83841875292.06.20BDB2C
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id B8AEE20008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NGzoyLWk;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759844; a=rsa-sha256;
	cv=none;
	b=ZYcgKZpEeXTdDOv+dqiadMpf2XUqMYzzv6USo0iqDmEcHFrsfb80MV4O7TtrtbFhw3DQ0I
	rEAS5DTWC/ztpmgjg5iJ3q8PWZlWqnmkhykEJWWQ6xPgx0BqcXj52HNcu+HTz79hsUcYul
	IlIqQ644LiEAG5DS145kVk9uKVvctt8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NGzoyLWk;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf03.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc7ijYojCT4luS7LR3VDEJwaByj8Czavl1FcpBrU7UU=;
	b=i8tgrrrXQxOPH32X8/bIvxuQJFvCYMCK4A2CX1FtttWz9XZGoRB2knpG/PQnXYgPof3du9
	RVpSjthI2oZJR/bvRPNVUSfrdJ/Pp3tU3QV2K8xnXlc0sDQNsQMRj82O3OatGZiZKRusi/
	TqsmYmVXJB08dtmI3QwYvY7IubIAv3E=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b042ec947e4so210469966b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759843; x=1757364643; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xc7ijYojCT4luS7LR3VDEJwaByj8Czavl1FcpBrU7UU=;
        b=NGzoyLWk3Usx273znp4XtbLO1zG+0lH1IHj1tfKXR0q2LXNouL+kp7Gu5eEw8EliAq
         Er9Hn/QP9bwJwNTc3rBQf9xBbw0HHe8h18K+J+wCWzItgtorjrvmPj5O2CiCtRiFPqKy
         BePXcOEoYcRjYQn4ERj/5/xKKI9Mf6KF/JK4LPrGapuNYriILOi8qiKCPWFwN4avzqKY
         cwpPnqu/xsQSzh02l/56u2kOoIE1bvAON4TSVi2x4P+NxEK1AsbnNmuy3hWY7tO53fdO
         SQmK4rj+3KSO+CgWI2VVC9bCpIK2xEPSUk7qUhsXn0kCvFRhT0PrL3XAPuFsES+w4NYG
         w1eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759843; x=1757364643;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xc7ijYojCT4luS7LR3VDEJwaByj8Czavl1FcpBrU7UU=;
        b=kS78e9cW5lbihe+VKt2C+/CpUCEseuoyMtOjnaNOq0ne72+evzo76RmgeXnvr1Vm9R
         tfThM3KcBoQ6O3FaIeFdAGu5bdVbpgUQLB0g3nohjY1tGawN1wfn3fEo/ee0OJTwQVjS
         gu/pexkl9nFGXjV7b1Ysvm4mEGYGQkel0plMI9gRY8ycr/8dVu2GIHbVGID28hbT2wqb
         /EXN7U3bpM7RiXMvHsM1sx0Je8gBvoi5yPi2ZSq5a8cJr/0iSAUMs+fDbeJf2uhEf3tj
         BOZw2Zpvqk2/+GOi25xhHXUgzE50MLGQWb+FF1S+oRNrijPLDEPFerBSizjWGfZdNv+o
         +VXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn3GoTiEFYUZqNlW2KNTJenPmx3OkcicGQFGM1HexOV6adu8Koub/mJMAoV2EYwxS+1Wve/gNDrg==@kvack.org
X-Gm-Message-State: AOJu0Ywvj+g3utMcj8XPVFYUR/Thxq9sUlxg+WQhIZkXP+2SYYkd1dzZ
	fvWdBsOJFVHJG+fhuC1NujcugbVOlljpMr3DFgXWGP04wmQuaNjJC0Yu2WDaSBrURuw=
X-Gm-Gg: ASbGncuQBqFbppfMQCr1kfIs32KqlVgETWS+ZfhxVMzAO7kldCGIbUj9Zr9TJPzRAS6
	tn9JtoppSpAchjCd+y2VnH6ilX9Z+G1J871h1ZnBGPsjwWOTNPJFN+LFbXdXDjkxIqAHOkKzkUa
	2s5nQpWDbKUDjAvfJg+X6yAZgHJvyFE3jsv9h6D/MNOE4W8vPVdScULDe5jKVTQJZx6yHD5l1fe
	fJq4BMVqlXKeAMa9IV/qGK+cUYDo/AbUqqJZMhjKiArc7if8iqsWcKJvkQy1zuBEVWMRMFPZpJt
	+lWI0EqVSQeal8/CmihRI7WO1ZVGVIAbB9j/3QdRXQ1H0H/HP/RL//0PHxMptotOvITphfVqHBZ
	2syO0DQJLK9imfTY7wYzDvB4PyWDroutxp1jIog2grvvNZf3rwD/JbjfGpNtE+S9XWY+HwmouXo
	9Wj0z9gbIGqvfjU4eTr7fEtlibEhZw3Xqc
X-Google-Smtp-Source: AGHT+IGzJPehXmI9EiALURY/rXkYz5IeFVzDP1ESKudUiTiCx5T7yEPplQz84NPBzI/8iDTakDOKMg==
X-Received: by 2002:a17:907:60d3:b0:ae0:b3be:f214 with SMTP id a640c23a62f3a-b01d8a267damr879923866b.9.1756759843094;
        Mon, 01 Sep 2025 13:50:43 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:42 -0700 (PDT)
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
Subject: [PATCH v6 08/12] mm: constify arch_pick_mmap_layout() for improved const-correctness
Date: Mon,  1 Sep 2025 22:50:17 +0200
Message-ID: <20250901205021.3573313-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8AEE20008
X-Stat-Signature: 4gph3i8h8h5jr6mnbckffrhcssw76jfo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756759844-670123
X-HE-Meta: U2FsdGVkX18S+9HKPEnVRzYymbUjMvfKDtef9HxjJ8vyycsDx6GhbCPfEZ2Dch6ZYd2lAi5K2JwTHyFjHMCnqH/mRJgmLOst9hyCk+CM7JchM1EkvmpnHWsePYe2wkzvYoezyfY23x0lA2txS8M+jMWSWgPK2Tx/6wzY3RARhJiIqztrkS6Ty+MDqxXcUN1HdB418TO1ZFdL5tVvv2ZHbAFVb6bs0ijUPKRXriNhLrrO/TTWPdKmzDVxyYrfiVFFwk/4ikb41HddFYDx0N1lVCY0WmT8lK7bOXgv9PsOOuANbopayUkzSpK7DMRFnAG4wGlBJvEj/sT2G9AYYBc+r5gC2r7diYiGoX88AxQUnf5QaF6dNfdrv3VRDJJeiMQUR+Y8+bbx8+zHeBI4OCiAXUTSDovjWC4SHfqmeFOq5vArZeOHSzPwvKihx0GoxcMoeSpgo/kzD1mKsBddfTNbDzTL8sh4X60AwmnCVLg0kTUpJXwBjUkvqCk/fUwPqTegCKOZkt7RNKPicTlgRcIVgt3foJFfZQsiaKDr2CRp+AjrHBVgK0Ptl0gBpypgiMse2oOgsHcnYXBpGeOGQ+4PsKl2leIPt3dhB9y36N7CiPxh2W2J1bXEbehd6XRKm3yv6CuSHRdKtnFEp3Z2GzMduZgmND1EUM7A9z8nL9IYugPEnOxttp97WzeKp9L6YDYAhivcViqUvka2wGXaKdGUgyv/ucW9tmHzmrxpdDfMdh2vJ4faF3vn2mUq86CYR/nXdqXQrcrUvFMmENC6tu/s8fy08mPrrA8jQQPU78UOD33cZ4F3/KpR9bX4ZYhfy8z6ag1UfVltnCKzZfU+JiryweE4y4PElBAY9gZMi5B1KIKKo5hZeLztJaWwdwIEfMmmNdUiMxd914UColt2eKOauesl1y2MzV9SrZsKEJ2CSwh36WqRyUQPcNKAT4SxNMLa4/Svg6dWv+gXolz0sKZ
 mXa46gOx
 8Pl8ychNV7oaNiu9TXCa89UAB07vXPwCDUYs11J9v8BmJbIqeDFfyQqpm837Ea61Fbv0HvrfGiBJyHzcqvGo0FyJT5w9EQcmZpFo6ZmOyH3hrToualLYtBlwT3j7BGwHyfycLFuCA4C5UsFe7Gp6Vx5n0u1mZKC/T+uDb/nZ81g4Dqi7/FmVzKYvP6QdqJc7DKvoEJU5fl94XzlOOSmMN90Y+sPuy5a1ZWuIqS4a6CP011QuXnqx0T+X5BLPrWQ/3sYNK/ITSalco8ORlfepYhkNQSIhapW9DC25qLTkzIiRquZlybLJqh61sfsa/3UoCFk6Ut5ONKnwIo7f7f4UnHbvC6mdLJ5Go7U55mVhZoQuqqJPbnGVUc8lLxYMpkpvqAbel3z+a80WhkN8HGGytAX9UrdMQ6TQzZd7JWOD2BePeEg5YyT6N+vlZW4LkVzYC7W4D9yk8zS9oCKJrBoj2c83/52jWHEDyoRZtZN2wVXh+Ggr9/VKtxaa44cFplZOkPvD5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This function only reads from the rlimit pointer (but writes to the
mm_struct pointer which is kept without `const`).

All callees are already const-ified or (internal functions) are being
constified by this patch.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/s390/mm/mmap.c              | 4 ++--
 arch/sparc/kernel/sys_sparc_64.c | 2 +-
 arch/x86/mm/mmap.c               | 6 +++---
 include/linux/sched/mm.h         | 4 ++--
 mm/util.c                        | 6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index e188cb6d4946..197c1d9497a7 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -47,7 +47,7 @@ static unsigned long mmap_base_legacy(unsigned long rnd)
 }
 
 static inline unsigned long mmap_base(unsigned long rnd,
-				      struct rlimit *rlim_stack)
+				      const struct rlimit *rlim_stack)
 {
 	unsigned long gap = rlim_stack->rlim_cur;
 	unsigned long pad = stack_maxrandom_size() + stack_guard_gap;
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
index 241d2eaf26ca..77462027ad24 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -431,7 +431,7 @@ static int mmap_is_legacy(const struct rlimit *rlim_stack)
 #define MIN_GAP		(SZ_128M)
 #define MAX_GAP		(STACK_TOP / 6 * 5)
 
-static unsigned long mmap_base(unsigned long rnd, struct rlimit *rlim_stack)
+static unsigned long mmap_base(const unsigned long rnd, const struct rlimit *rlim_stack)
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


