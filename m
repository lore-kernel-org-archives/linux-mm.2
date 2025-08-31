Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF16CA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 263E68E000D; Sun, 31 Aug 2025 05:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2152E8E0001; Sun, 31 Aug 2025 05:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1040A8E000D; Sun, 31 Aug 2025 05:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB4A58E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D0281DDB16
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:46 +0000 (UTC)
X-FDA: 83836555572.27.FC59667
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id B235B100005
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NdP9Y+x8;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633184; a=rsa-sha256;
	cv=none;
	b=XOKQElqr4M+NGqC1JLd6axelVFoi9K9kVyZXZDTzI1lw8SCaVrIxEV/UsLbiANuqdl3VMI
	nfgY2/vsovRxTLEsKzLnZpHkPJxO3vznAJdeJs8V6qzQG9tUJzQ6W1xKgtJyQM9HbZP6Kz
	bjctoxXIE+PSuvwEvYSqqPqsHguCe1I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=NdP9Y+x8;
	spf=pass (imf14.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwlx2EVOW3/w81+M3sGLOhoJXHsbq6RkIxTDAR9OjUU=;
	b=pQMhGxi5kUxj2qHLV5cG/BSJjE/xTc/pvpCta1UNsc+RoCp8Qd/ub2pheiexa4cm+a8CJU
	xeYBImHyAP12VhMcDGTcuUjRXEbSM/Wy3O7sWC2ufzYLR1qpM7mxpSXdxkZE7q/n+MRQxa
	Ndut+pyTj5Zn8qktDRKgb4o5M+pr8GY=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afee6037847so520756166b.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633183; x=1757237983; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwlx2EVOW3/w81+M3sGLOhoJXHsbq6RkIxTDAR9OjUU=;
        b=NdP9Y+x8pIgfjRpVGu6WBrjZqebiQ0CVEoJA9Dkl3zDCQy4voedpOUr5zbbLp0+rB2
         Mdy7RsU/Z2hfxVXhQfM9FdjEEfj2hkfsjmwjVEPkaTuUKd9jF8ZJ2ukd9Nl/XWRkacz2
         9qnlQQGzVhv8pswjKl533Rbw7i/c4cExYBOWwjJNOMOO31JxEwLtHGsQZjxxiOAsKnqG
         yUAiL0K9lJpegzsnktzdfX1GKHnS1SejcsPSIaKVjWIpPVILISajd4qhGQJHE5xypznM
         41YAd9ubGn3ddg6hDMygnxHuJDwvi6c8wG87IIime7f55U8Y0jLGAr45Blhm9mLnV2qd
         t82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633183; x=1757237983;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dwlx2EVOW3/w81+M3sGLOhoJXHsbq6RkIxTDAR9OjUU=;
        b=RihfGvtovvNWgI94hFm64JJCIhZwz9eY3NAPLfBQviyqIw9t0fCEEEsyrFZNEl/Psl
         +kzpCkZsjba4qFP/2a28sWMNQewaSKhSppBlXOr2MJ/CSnlPJNs0+dSA45BzUuIrwJO9
         qo3Ax504R9/VoiX9BdYQ6C2ICw7CJqXlKWW2L51Nlpf4M2BCp/jskZHVKVzpGOErduJq
         oA9HggzCaYe8PgWU3gaASRtuttf1lSdjl6Xkec5Szkt/0hcU0vwh6H2Uv8nB58ce14JD
         CJgKKocXOtVzSrWRwZ4+ibir3arc/H/5HIzA3Jc+s7Y1NSraeqAKa1jOyklKzKFhbXuh
         oD5w==
X-Forwarded-Encrypted: i=1; AJvYcCVTP5aTFPZW8Dd3otqD9ZbbED1pmqyILaWcQ2u0DL1g8nPZSLKSGQ/WidMCT3GJS+uDx5ci691QNg==@kvack.org
X-Gm-Message-State: AOJu0Yz1Ml0Sb+Z6k4Ei2g6eGvgarNg5lTNEPh7T5o5gfxlbfi6hINje
	lLcJlXER9NjXV4jWrT41b83c1fhvjsXrO4lmaRNU7GzJ+DHofm5agb79M5Gd3X1OLXU=
X-Gm-Gg: ASbGncvevUpQSPxqTccWxG8ErOc+dlWXv9DEzTtgz24Y1QtGnL2/0ZS5mcuYZD9jLpT
	d0/CqBtwIERih6guke3z/yp4egL0W/gaXEtkxW03SgWk9udJgrwF4YBFUuABWsacSfBirssnqUd
	9vsn0Kj49Zd0ExzsgStK62vUJ6K2Dtp7Kc56dBJAmtlhl0BPuoW8MdnmobuRdupjcnfvog4xGxj
	/nEqtJK4GsDej2dPr7T4NWUDLRbuOfa50kztmNXwrjs9QDTqTLxUz4mngqiyLjyRPiFr0AJAp/d
	eV+04POpfwqLCfBxG8aNaWSRF83cVZNct8TtINYtxrRewe+TtbC1OVTUZK+/WUZ/Xglh6/GFMbB
	5E8KTXLcTMw0uOLE9/3K0q7GgwbZ5Yfl0KUrS9IX6596aSuygByi/RXR76L4Xlgwlvw2vh2gSQW
	wKRKJ9lBRsW2LQnRMOzBjxvw==
X-Google-Smtp-Source: AGHT+IHHEsy3VYapgP6t68znKr4JYYpwjepZ2OnahYHw25+r/10lb4UhzW3CEgWSDi98yrsXnMghDg==
X-Received: by 2002:a17:906:eec3:b0:afd:c31c:2488 with SMTP id a640c23a62f3a-b01d97307b1mr425157266b.39.1756633183190;
        Sun, 31 Aug 2025 02:39:43 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:42 -0700 (PDT)
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
Subject: [PATCH v2 08/12] arch, mm/util: add const to arch_pick_mmap_layout() parameter
Date: Sun, 31 Aug 2025 11:39:14 +0200
Message-ID: <20250831093918.2815332-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B235B100005
X-Stat-Signature: fyc6qtkzz9daahuii6bisxzxj6g6giua
X-Rspam-User: 
X-HE-Tag: 1756633184-204141
X-HE-Meta: U2FsdGVkX1/Td8R7voyA9Kg50kRwJ5yMQE6njuDHjb7CWZio8rYJ3gPA4fkIpyP5C5evVpCoS+s85PdL2fXxQ3JwGu0HuGMd4lfvlstF2DBV1V9mjyyrtAejDJEA3B2lTgBT5/4A5LLgTFh4UciqvowINKYL5+cErwzYPwYpRNGKHJvFmBKtLvp60y5Ehzye4KDwzyF9Nr79RABVcKx/t7uCurjLp+wBCSmMHAledTk7sCOcVQD9KHxS8xndfeumvp/kmDZAmSqMxGStxaG+Q2y1nCMvxuMlgOqYpKAPlbNyMzDZ1DWgG47fLGNpHrJ5xkmxe7ZDPkpccRm+MZQzJ3KcSUKQNdD7SgTi6XE9oj7EvR3FtK2h1YTHSVneVY72Hqc1XdWOHjas4ZU3SvgyF3HznAmbLfCJpFrH0FHOtQ/4CxukM0BkC8caw8rk8G889SBtWs4X6b43mQr3g7OxkhUN0R11BoJqEbsb1DlmJoMEM8oAMxjapGy9o/CexLfQ0dcBkUQP/pry6ZEwOkEMC+bsxbxqX3cMM3mnLAd1DbLs8jols/eaUe+FfMFMwn3w+br7JTQY1WNpTm4BJXEL9XHsf6imSxkZz7XgnHzafVNkVGueJDFpz0VVyRVk3x7HQHBo+yJDjHcMazb0sjZV80Y33uxN7YQVE+expdG5Xtu1muESgamONrLDUM9yak/fLRpyUTyyd1clvVGK3/FHD8r7n/dy37uacyGKohXk8Vni8mZnrDq10pUx7ISav3sf9Cvl6TCTmQLwJlsD7oeQMw75LLvjjTuhhcUXP4Mfn6/oE/K3aSEhPgVYg5woZgBeYmM4esNHkniv6ouRn17fskeZi48iQ96pUzOv3kEnPSIWHWLoV3DZ3NEpRGIpqr5CeESXGo7YFVUh1v+8D1zSYHND931kV0pH4klFVWBOa5V+am6yGbZr/eqqvL+qSrDj6J2q2jqfTYYDDr4zwOn
 HITdcVcU
 H8cMANmurigLIC6mVuue3gerLLdGYevagamDjBJRRhklEczm4+j7etcpP3WePd9OeZt/4lOrI0hZ/YpJW1bUFVlmr+1OEhCdTXdm0IGhQ1pppIDPcGksB3FJ9zNecllAetQAxdcjX1/WioeF2QXiFkOYlentlL2B2jmNJYz8jE57TsBgH2buimczcvxjOI4JXqme6nVhcH7jPKy30kn50m+3ko1kyfao5/xvgGUM6hkfuwTl1VSUCgeQfexnfSPSwGaSP2C6vdme0RhlfxO4RTlLOeJ5HCR9CkW53MONOyErUIpO/R6Ii3Y9y27t2WpOckEHHER8aPCBjkdAWpnAvvXfeQjBledFxdn1UNNiWHN4DADt2ZIxR94XmZWbfHb4ZEEgypqUS9m6X/ucjhE9x0KBvIFqSKmDE/g/s0zqcssVy2KQYldslulbEJAaPQwSYzmUEURgyXm+O5bAeAHvD/6wUIoy71k1VxlBi1ytfS9NfUIPzfzjw/Y+KOBtl4Qq+DcQR
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
 arch/sparc/kernel/sys_sparc_64.c | 5 +++--
 arch/x86/mm/mmap.c               | 7 ++++---
 include/linux/sched/mm.h         | 4 ++--
 mm/util.c                        | 9 ++++++---
 5 files changed, 18 insertions(+), 12 deletions(-)

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
index 785e9909340f..e3f0d9b74b00 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+ickj// SPDX-License-Identifier: GPL-2.0
 /* linux/arch/sparc64/kernel/sys_sparc.c
  *
  * This file contains various random system calls that
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


