Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDA0CA1006
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E29518E000A; Mon,  1 Sep 2025 02:12:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2198E0006; Mon,  1 Sep 2025 02:12:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C04AC8E000A; Mon,  1 Sep 2025 02:12:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B17DD8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:43 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60DBD14063B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:43 +0000 (UTC)
X-FDA: 83839662606.12.D73E2FB
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6A81680003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=DQmhK66o;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707161; a=rsa-sha256;
	cv=none;
	b=uj5tmBVH00ncquVN/CqO8I1C90yBRXA5sUUQLR5FF/4hMgwwYeV/ONNxYiKveulkG3/6ST
	Mnpaviwb2Re6fy4RvijUUiRz4HMfZPGZUJCSMpwqa5venH5H7b3i1e7MvHGCB9WcOEejcn
	hosANCGkq8FcgFpIGL6/XJywkITxg1M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=DQmhK66o;
	dmarc=pass (policy=reject) header.from=ionos.com;
	spf=pass (imf30.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OMV7fZLCTw91Ub0dFNNIHemoRG98amxSAwmTMmAcs0c=;
	b=LP7dyf2cVTJbsNjijo23wbIG6n9mzi91uP3qZzTJQ9yrNAMIREkVGrRSihTUXLDM7p2fbe
	ytn4sNELwiUF0hfNAeoxxTh912nX40lO6dJUJ4LejXM4Xv+JhHxF/jLdxWquY9PYyztuf6
	CCRvLIlhOl2GvmRFfNsqX26lG6p/0Q0=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61e4254271dso1379195a12.2
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707160; x=1757311960; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OMV7fZLCTw91Ub0dFNNIHemoRG98amxSAwmTMmAcs0c=;
        b=DQmhK66oize5sY5ZdK6odIilUkCTyiADbQFNDCs2a70SA8cUQ8rTAHuuJcKYfDPnqH
         zr9AP6xyuu9xr4kXFjXgjbeq0HVGRMgveSd+l2L1XZsVIKk6CSPlPHoqhjEf4NIBFmVW
         k0c0IObNW3/+/pjlGtI1bTvapaKrrU2C0YcKDr/Iw092KTfm0P9Zo0IVXMss8HoJ4EOj
         E7o881u1MiQiYFXvpG/nagQQa8Sy00dCzyR0Mj/K3Rams09VGH36sa30X3HXSscEGfVe
         8awdRImNNCpjNk4k595jNKwEMb7upEcjdLG6+ahyEu7ON9PIPGZgSfXeYtNcCjSNldqZ
         ioOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707160; x=1757311960;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OMV7fZLCTw91Ub0dFNNIHemoRG98amxSAwmTMmAcs0c=;
        b=lX0Xh6HmFBOjUgw3iixJrHYh0vINKtgsZ8k2agykgV83ff40r5JB3jO5G0yWzUt0kI
         l9LPJZ7dZBWghq7Qp+aLHIquOEOwRCJgExiTl543ZpQdwSs6xLkHhq84+mebwUgx4tIk
         3WrphhO/nK6ubzA5a1toSpoctzR92UVgZ+J3kcA3PFDI8bqXI/hdLIqzBG/F8A0IploJ
         B3e2559ZA9Bh+GPldTyREYmylZ9VOhFmYM/ZrlXddSYnbgv8gqUKvKqK8RL1bjgv8iuL
         1nq7MSauLP8FQ9LB7zUiemosgFmx5fahTWAl0Q0nGfg5k3f1+TJZTsDZvJBpbtvL0YKO
         8uhw==
X-Forwarded-Encrypted: i=1; AJvYcCX9yBEWbUnFMoFYdTUqJ2Z0WKqD1T4izFrKz+DXhyS9yljbs69NJsazFB3E9z5/Y8XfVVf3zHNRxA==@kvack.org
X-Gm-Message-State: AOJu0YydELJx5xmWxjd2eejr+R+glTKvN2LP8rQKzz0TFfYBGpavroG4
	nyjplHBJoucgoSXXtasef9OQet1EGak+nTm8FfDBYpiXrV/0xgIDA7hza+I/VnI6Y5o=
X-Gm-Gg: ASbGncsNvFIyVD0PZxsLrM5CQsZaG39i8XZosK/QFH/iCDayGlNXZH/doQnVmG5wOBv
	94/aTLI4SIzgpNHXg0qOYvt/35GYTx5U9/4PVl83vWxbI9iVDGV1wHY9cQSlC9Z5X5Xs8Z0kAva
	f6J1l1jmqYpiv6bw5KqDNw1ogac3OBKdlAnJxEEcC0Ck8c3Hlj+Q3kFBKkn5eepvKy4o4jnmoLX
	jxudvFnTq2jHe4Xvwyu5fyjVVwLbXwS+2q18iLXPy/lyocjZU2b79ckhf0TejVXiiG1FWPcMh+i
	nYEphjf6iI49NTsfNnbTKAEy7R6IQb9fV9AEQJi6B8bwc4fKLeu2GdPCN6XCcM0Y5jImRlLZ2wF
	RsGSF6jKpwQyDDqVqDsSwjE7p2RB1hsh8XxALW5ZoDJK2yY+gxQqN0+V788DLEP7uCZ65ABJz0v
	8yvLo92ctKTsF9T5DdQupxjw==
X-Google-Smtp-Source: AGHT+IE61/JzTZaY6T03P50LVJL6zTCqVRZn14C1mT9luFPyfmIAshvEk3NBGAkYGLzTsD9oi5e6pg==
X-Received: by 2002:a05:6402:2351:b0:61d:2096:1e92 with SMTP id 4fb4d7f45d1cf-61d269882d3mr6111842a12.15.1756707160010;
        Sun, 31 Aug 2025 23:12:40 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:39 -0700 (PDT)
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
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 08/12] mm/util, s390, sparc, x86: add const to arch_pick_mmap_layout() parameter
Date: Mon,  1 Sep 2025 08:12:19 +0200
Message-ID: <20250901061223.2939097-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A81680003
X-Stat-Signature: fhuqhhd767h68jpffw9mdtkht8ecdro7
X-HE-Tag: 1756707161-193511
X-HE-Meta: U2FsdGVkX1+9wzuVdpf5JAOioWqLY4xsqlReRPpIHE0hmARcY7yAySWA2EW0aXNoUOrKf5bzerLbMX5oTUeQthV0p0KMH1fyUz33IOAyGYz6hftTG8RrZGHRPeUhgZJuOvripYR1Q3tE2uwfWrpUAz/IxGYA3X7y8DM3Mn3FjSoNyT7zZ7P51ZF36Piu1fnIQ/pJifI8qYeBnncZYF7/YripDnce70qVSnLj6juY84U/WPWo0pN8Dthk2jWjM9P/GEzcSU5WKDtVhcWCyiZ6yv38Vpk5y7RsZyD2nt1kCiJotySgKyYyYjcl4fbPvG2rDp4QME5zy6oOKDcsA44icsd9ssDhJDi41l1OBvXBiP3SHpV5N5WntT4/hH3YWKKKvK/q/zES5edYCIK5knEAP25TV06vEqeSD5ex2DUVBChJWxucc9MIlXIuevg6HNeQBOOGLEYdJEifWFAXQgXd2sp6iWvLHiPTK6A0fiPgkNBzSMOTfnSBgsXcsqlB4860f44RfK7BCiuuEDyxM4anQgdDDEO9wrbRSMOs9yxOz3kNvDAKYjXwTjmG3am24vVr/s6WosVd4hl14REzX/Pu5ilTSrPLs9RMv7l+g8zrS1mmilT7R/1mFrXCTW9E+jgQd1PA/c2PJV24D4t/52CVUX/IL7vxEilHogqq1iSThKJk+gxFEn5x3EQTajBaUzhrksNWfDM0/dP//CMHzBbaa1o9h956l8SP6MOqjeWsn2aYepfVa76Z9GhvWzqQbgg1FFWSyfS7KriuUhYglDTYyd/ZJ9VQSVZoCNjJdgGxytPsA1ZpqbMtGK06eqjvY06AYyCTggvbFLRZ1x6R+bvjI3tQFauo0MKFNzIrPMNNdpg/yS+czTlsv5SXUVwGKA6T5X74UVdpNP1seKI0Ca0ACOFloy8KPZ9hkptRmF590vh3hjeDmw1h2KKDv+9h6NTiCrF3jUsV2AppyR8VkA8
 TqywIkEB
 2r7D4xNXKkJxqVEVIKEaxLDzm2jD5xtMNPn7LzxdjDKWSREbUeGqIvqGJpkKneRHdpmRv1ky2W1n75cszk9GaBEWKWfICTo69z6UKxjKypjIm2MZo6Hhl435ufbgSP9QHtu49QaoJ09MxbJvgQo1n0oEbrtUmNHTrSHx0EZJFaxNQuKiOTMFWlEDREZVJsaYq4bn4HVCj8uPYvs4K0RBj/+9WsQgzXhfUp5lsTIVsju16gTak6HQATGpaaf5pRC7/CYnZryOBbiZd8QeuNkJgtQ546FAitIvjD2VA3kssVwMrw33nnr+OPWYyDRaYksnTo48AiC4ZhpFm7ecbu6OUdq0QABvEZtms51QguCGGA2fE/bYG/RfwVLZpbgJy5uvVIXdZ1JwZUOesSWoEwpgKtKDfUkiJ8en+DfvbrcesE1VmjIkLFEGzG1g/7RCIL6lCpKCVrDDLQ4eQnOhGi1knJfghSjuHYI0/iJfzPzmj4AB4DwqUtI2Sfd3Ul7UYcZ1W+1dR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
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


