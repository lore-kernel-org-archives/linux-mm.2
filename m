Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF22CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 12:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC5E8E0046; Mon,  1 Sep 2025 08:30:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B143C8E0013; Mon,  1 Sep 2025 08:30:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89F168E0046; Mon,  1 Sep 2025 08:30:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 676688E0013
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:30:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05C8BC0756
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:52 +0000 (UTC)
X-FDA: 83840615544.15.0F25886
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1E6C514000F
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:30:49 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IezX3kFN;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756729850; a=rsa-sha256;
	cv=none;
	b=Jqir37TECCaSJ8UyczAIV9tBsDw9l6oXOg0M+KWjSQT4fkztxexGxBe9V4iaVqHrev/MpL
	G9Tcd7y27amM2TYYFr6P7840ohLKhNKB3Y+OwQm8zVw7sFeE4VNkXDAf9OC7RnuHy8hZss
	U5O0dSLU20LqG/iUCLXdJKrO3O2tQAQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=IezX3kFN;
	spf=pass (imf23.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756729850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wDGNHui84WsHVpXgfTg7/ZQpp3R8ARaLofrymMcz4P4=;
	b=rSNc+3zXe1QzOuw0lha/BJzKLDGsuRI1eVmuEw5D5HKffwoMig5I6tP16MmzuEnRnHtkwI
	mkLJt5fhAg7cBPKWKXpqMQPFLkKIMW3YgMTKVIawTQk5J5a/ssJ/EEVI2RVJlK5uK8W3JX
	KniqL6bvoCC7t5BKP30rmUo7Z/jHC+E=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad681so5237651a12.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 05:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756729849; x=1757334649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wDGNHui84WsHVpXgfTg7/ZQpp3R8ARaLofrymMcz4P4=;
        b=IezX3kFNi51dp2/dHETYGRd5B//QXZKG66MpfXqp7o/5VoYjNhZp49rv7+GfSiqcr6
         /vDZpfn4dIi+hqDayCIHD+gTlUzKvNmt/DcvjjcrTDiN3gvoKJIIsaKkaRtBwFC9u63B
         45O3XQkqP3eSTYP2/rfWKP1Dwla6uwhjAyxl7QbYRxGxq91/6WX2Ud29BmIiWkv50QCi
         i0yU1ivgxe3RuCLkucAgRivpZkOQLxm4ZsqwWBcv5ompwPpAHSltrnR6r0NHeyZ6SFeO
         jIbCwccIM+zka+0jp/9rY2VhyHe+eex6H3EO1A2Ufz+bTX4VMY8tsGxfX+DAC12uT8Au
         n//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756729849; x=1757334649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wDGNHui84WsHVpXgfTg7/ZQpp3R8ARaLofrymMcz4P4=;
        b=nhIUXj6PxnxbU41cfBB9ZUOdPlxyet8QM9eqHPXAD9/PS6e2GlRW+sPr7K9jjmjt2+
         vLm4zqvdQrYxXsZTKoKeWTsJwl6d6xOFR8q7AgnnUJzdCN7qBr6lPwSjwKNW0KM7bJCQ
         YRbdbi6RPecZMIC5gv3GQjYnATqstBdNnH03+sjQAW2vetkFGV+CMp0MipO+2EC02U7v
         vTqbUaMhFFQCpwiMbcM8p89Y5Sh9tV0ijVKIpba3TIAgu27yaA05VASf7RLnaWRlQvXH
         x0DhQrDSWMpmozLJo94E+b0mZbDs6BNLt7aL5zWLsbSMC8cdnD0YPYcIh/RtIJfzFj9+
         SKKg==
X-Forwarded-Encrypted: i=1; AJvYcCXJPQnsEB5qYzUEDguz8BRqxrQEAEsCNR+8IDths7Vr3YnMOowv5S9g2iQkpZ1/nRFhmoFt8MgjJA==@kvack.org
X-Gm-Message-State: AOJu0Yxl4rSEbt1ieAl1BnnXyVoyae2MaoLJ7GI7HNPl1HiWdSb8RnQl
	6sNe7RFp1JUxdzMjHAgs5o1FrBGJHY40ErMdRHXdsbGIaK7/gW3aOwdKjzdIyU/+Aro=
X-Gm-Gg: ASbGncuL5P/fQOmaie4rkw9s4s3/WTzzGwtPxLMOXRiQompGq/1tjr6QfTkVv4fz2Qn
	bzyoFCvlrjVBzQ55efXOIr2UcjhMFQL9HlY11XBBk8pGuI6FiN6T4jHt5cTRx+sWEIiamfD4KLB
	PQTwcbWlod5LHSAKEWFTzzKHUFrLvITxtTExcnoCmcqmTASDfuSib7bWZrLCCXYHTylu36p6xEI
	3ID7YvLacALsUA+bBYW3c+xhhAhKFpJpQWCz7pghUSMnw/+quUo51QnGy9opoFilBXVIAvOW4oI
	FJOfr26T6v2TQW6WEaf8MHJqEQPKNWsA63tj6b8sLbKtecfflsvbBabivf2rX9JJ/k7AiBI+1IQ
	MkrZgVeDN7h2QKnc2m0cwRMTzRj9EhT8sKLzX5eUVkHbKNGBC93Fa9++gn4DiMBaX+8um1lnec6
	VBjXXDCt7HxhimlsUuKW9EO/5t8zQ8OsJF
X-Google-Smtp-Source: AGHT+IFKdIH/XV8PMBLWofBOVQFCiNzD1MryqiWSI9A5CR0R39RCWddVIJNZ79UXnDKy/e8yeVnjDw==
X-Received: by 2002:a05:6402:2549:b0:618:afa:70b1 with SMTP id 4fb4d7f45d1cf-61d26c32e70mr6177153a12.20.1756729848021;
        Mon, 01 Sep 2025 05:30:48 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61eaf5883b6sm255566a12.20.2025.09.01.05.30.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 05:30:47 -0700 (PDT)
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
Subject: [PATCH v5 08/12] mm: constify arch_pick_mmap_layout() for improved const-correctness
Date: Mon,  1 Sep 2025 14:30:24 +0200
Message-ID: <20250901123028.3383461-9-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901123028.3383461-1-max.kellermann@ionos.com>
References: <20250901123028.3383461-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E6C514000F
X-Stat-Signature: 1zc81nq81yq63rg4p9x4tnfix35wipwu
X-Rspam-User: 
X-HE-Tag: 1756729849-889023
X-HE-Meta: U2FsdGVkX18GAy2Xyi0MERfrQFp3OW7HZFKPo/Hn+otx6bLnhg2cmZocD6w3bcoUGkCPyAh1T7W/q532Jo3PYQcaf2e2GFHsMwihcjfb9OCynakkGNkCvyYhfOTYpufaHH5dg8LQqRRLQyq7BvdaVppSrCSV/cdkhX6PQZyzI0+LANnkq5ioqfGwZbMXJ6EOfvl39Fg8J/wTXzt1C0MxEtU4KfZS6WRC0jnzfPKwv9d1I/OEaw4lBtNVNbE2kGlC1yIjtnazk7AKMtLEuDsMrJlX4WUN+vwajDj0/6bLe6N8+NERjMme7fG1gvKBTvCR21MKEFQLXpLJGteqo0P8OV5i+mbmJ2jsm6unUlbKwKnw1zdwAZIxchZ4i5HhSMS7l1ZoZjyuOd5UYNmFR6VKVMZoWE6CjGSkiBaYnObqfXTCbzD20ahNxTSBqAV0uDl+4WK4DPdkz9tNIMeUGjj3ZctkJ9YWIbUFG2O0yICZpaiiOVMLF7eNMMYlyuigFU51QVm7xGKlbfXNsNJs1tt2ho+p8jcDJBo6SQMBOdr2lVkGMgMkyfCUEfGwtxQhSXSGsTOyO+T5JoXGtsDQahht1K97EKeiH7am1FZNdzfY/GV2YklfBsd78CnRF3AlFwkHs3ZST49+uBjePzJ7sLWVXFWyr1Ttl0htGl1DSxg+c1xp1t1XaP4b3V/9JvB6NqOkiMIGhQJ3BJfet+prnvyMafGpezMbO5gGYXDwmxSLMBLX+lZklErCns1jNfckDmPsOCOZM5tEAQses8jbAwAV4B1lzdzoaUpNb+okwlSvrvnMiLrqvbMHimRSPI4xjNA4SxHtpTVEUZeOzcaRS6tmXhKuCxWArTPkrM7YVmEOvbuRdp81OkKNqpmJMXzlV0Q6720u+QTF8opbAM8aPQ4C2Zegu4rNqWuGe/QDD5d1rv3LwcgnpNzIaBtsKiOULeordcNTfUJgZk0e9m8It/V
 RUnvab8W
 dW/9C0v1z8ixYkAiJshLPv/mTmoW5k67I+mhK1sdfbvLhl7gPP+pgGnmC3LkR6hn46SquqqwMG3lTyj1Us3xAlIeuE+ouM9vFgqbEPdabsBo1rdasVHEKWCHYvozZd/EzKrjBX5YBPAvmxSlbehUw4K1vyqcYB8sVGqTc7kkTXE0vQVuqYQn3WWk49j1L2b0VuS3gtn3vqHS8JAwKFKkXXtCMEExtrG6BhuYIHzGaVGa/M//c5f32dk3RQVU/a2/rbq6rOQ7V442ywwjTRtIFgQQP1g3Kjqp7xdDBQwyoU4q+XsauypSy5xYFH3QaGN9QU+vxSuaPS73o25kH9uzyHYntcJ9e+eEOZiPiM/a+OtOAkjGqt3jGxiCFQGiL7dS0FtsCs/s7GE/GQFd31gRHFFesbv/ZOvtpcgEZoZV2pP0AbvLU8v89dhN0sesnHQmZsPbKFah5vOa407YCqOtivoQ5++w0Ndjs+HoIlnKiYrXseEldnVCXBmTpTYPODidVoHne
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


