Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDE2CA1002
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 20:50:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC33F8E000D; Mon,  1 Sep 2025 16:50:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73328E0009; Mon,  1 Sep 2025 16:50:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3AD88E000D; Mon,  1 Sep 2025 16:50:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFCF98E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:50:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AF2811A5A8
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:42 +0000 (UTC)
X-FDA: 83841875124.04.842E2B7
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id B992914000C
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 20:50:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=XdYsJuHI;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756759840;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sn4h0BpPfxBDaFwO8h+hIU8dGesIzlZ2oiTQdwK6a9M=;
	b=tuNIeVm4m+Y+7wgDLi1iYdBOfYfB926z9xleFReB0QbYsMAoJgiKSNdBcPTAvHh0dM9UWj
	6qu9+kofqfGt8fe37f600IpnljPZ2nnFRA83Lt5lPrxN6s1s3TuzYat6K8kh45tTx0wC/A
	67mv4chFTsaBR+9xNXpCkkLofkfmgUs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=XdYsJuHI;
	spf=pass (imf26.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756759840; a=rsa-sha256;
	cv=none;
	b=YhyzffRnrNQXihIfJFoYMh9seJXBoB89nz7cZM3mvb2kDy/Mm0ZNcPazkCQLPBk0/YZ/Ix
	hyZMjqJj8J79mCq/+dqtymd0rYZzrY0r4PSONPZKXAgykbxAr0FJcLeWO5eNONYsaNgFgp
	IAC1J/q0k6dmHcMz8jAbD52AeO1eGos=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b0415e03e25so228760066b.0
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 13:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756759839; x=1757364639; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sn4h0BpPfxBDaFwO8h+hIU8dGesIzlZ2oiTQdwK6a9M=;
        b=XdYsJuHICrgmBeKGDxUPtR4iJkRDk0EP5dReDL3BBS7X5w53V+kvWF5ythgYFqb/Da
         Eg9h2RadexcVRxvBsWKqYyh2zMD4OkD1B9KL3P6WF8TAYA7p1xMixVSxfNi0fTWgQHGm
         pDrtq1Ct1ZfHbC7BA78X3TZco2vs34mRxaeYptxZAgOAOj3uzo+sXA00fkxJQEwtwfuu
         KkebF1P7RZCfen1RsfvZqDVTMXBnFwJMOO7nA548bedc+00rQ1h0KQUhtZaTIugBULPa
         U9raQjztcc5B9mxNRn7eGj7z0AQKo2MglOvpNcdHVziyzAhdZqgZk0KEU/ln2zOPP2Tp
         fw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756759839; x=1757364639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sn4h0BpPfxBDaFwO8h+hIU8dGesIzlZ2oiTQdwK6a9M=;
        b=cH7NNWo1UMck9QXKF5s+bBpuc3f6yrLGYVrfcIM3+cDwgYNYFyItIb3qaQrzVF8yVy
         mAffO0DaOGtTsqTQnffaTMnBejfPRTlcZh8a6YJDQ5j63F/Z3mHoUn3sRLTQdRdq2ATo
         UdXJpNagZTH5jZyYFXoKzFsBX0nb9PtoqUp0Gz3j5Tpy9aRBPuczmsSMXFDeLoL/fiSo
         sVQ5srji3No+oj+I/exCdztW+uTVttuwd+At7ATYuQYqFyWfPU1DtQW2p/5z6UvcbVZ5
         42CSAlIaH748TdQGW4jsO6Su3uYClFGz/7yRGdn/9u79imGsITh7/o5EpTxeviaEHoJI
         jHGA==
X-Forwarded-Encrypted: i=1; AJvYcCUtb39Z0l2ZsrmOhFk/37RbOKs9qA96JY2s0mojueHvWbOE6fK2/GGzj2RB5Y9oi0V5wVQ05+tnIg==@kvack.org
X-Gm-Message-State: AOJu0YzoHWn3chRzGdeBbTdMglurJRO6q8IHKXxa+7NDNy4aoCcocaTB
	AjQ+hpXWeEVyKSlBdPX6+eifX8u71MC8JhqHr6D7SoIJaZ80Dpe669upJKn1TMROfG8=
X-Gm-Gg: ASbGncvcqUr+9peAgz8OgdMvrntXcatLENd1d4Sz4IJX8DIBr2dyWZBOoxFX90Dhx94
	108c2J8/txzjlW6ereUxnegQU8TPKdvaD6E87WbXgzn22mV31F0xkzyfzCorLPCn40EUoKw8a6y
	Zv3mBUdU2GG3WHC5adKv+H3ZZzrUL4Si5sN6WxVk4sco6H8ViDAbVQElQGUUrLCsvO9hp5eeQhm
	PuTzL315htyCmU+JJVJIm0q1cQga3WQkASLdz03ScGLZ5RdUVm1539yG8qbIdeEuB+UZyZIWx/a
	Xn69LTC1Wt158QnJuwgy3MKnOin+cgYiA4nQmi3GScmyxf1l6Zyvrng17qNBf8CPRsU3FCS1Gt7
	DGsH94p2wMCefgpfkb6ZWFSFGz2IWheqk8fcet5ojqe4e2fYb/os/gpbv4ScARGjaP0GnXggKq1
	ZEmrFJNHonCb3/lCRF7YgbfA==
X-Google-Smtp-Source: AGHT+IH0D71brvthuz6NiuqLrZIK2MWi3wUSZ97rcXr8aVNySfvYxdzD2MYQW/mxQZhh964lwy06dA==
X-Received: by 2002:a17:906:ee85:b0:afe:9e58:7550 with SMTP id a640c23a62f3a-b01d8a7131dmr869222766b.19.1756759839098;
        Mon, 01 Sep 2025 13:50:39 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd9090sm937339066b.69.2025.09.01.13.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 13:50:38 -0700 (PDT)
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
Subject: [PATCH v6 06/12] mm, s390: constify mapping related test/getter functions
Date: Mon,  1 Sep 2025 22:50:15 +0200
Message-ID: <20250901205021.3573313-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901205021.3573313-1-max.kellermann@ionos.com>
References: <20250901205021.3573313-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B992914000C
X-Stat-Signature: jpftine4ycoh8gpmg49tccab5pd48zuw
X-Rspam-User: 
X-HE-Tag: 1756759840-194440
X-HE-Meta: U2FsdGVkX19ok8/PumV8cQGgE8tkxHJ3sfipzQDoSrq4NHTeMTNLmyFEAc3ID6qCru8+LtypJCSrY+iTBv3L3+FRTauFHltAl5b1WR4QkK70S+KoOqi8ZD8mHryB9K3N4BhGoFtey3YsGHt55+I17KQ1ms37A4N+JYYjtFmObk6QnFrwVgKZyZFR2PctHailyuGhNMEFdVEsEaj4njhEhmtIygo64THHu4wd8EWvc2oR+8vT067pmzOgt6/Z52Rlhe9hD0v960PXOVPUksCnU5ZLyrgdG+EshR6sCG02lMDeQwMcU/nDIs9xuQle8JfPpgBAMnWL0Z+yzprJLoiyH4ArwZiTOou4lMe16XqMCRQgGfMrEb/2hAidv6LxaVRhdKTjyyQjpmYKvL7FvC4NQpRX68/vgh94GXUWTrSHZpjyg/m94Aiya7qtvT0aXmWKRMecNlWEQGL5jp+0HG2qjKyYa6qL9lu6qc4QG5NkGQimJYCkBLM98VMGRzZYpIGXtmXiTaxidPsEefnA5WIuRC73YcTSVm3dYwOBmsVgqMuFfNQmEeOd6+dEa77VXrr+WagdJhkQKZr11oadxUvIAenvANVqbJgxO0PSSHdompcYvJ0NRgnjeMPN+FAEV3/Kr5K2idxNazHLH358ZrHUwlU2hUQujKqvSIt2z/icu2Q+hcM2pXE8zKuRGimoWMpbGd/0gnnyYzDKEFPPwmPnbTA54Fs2OhUJUr6jm9uP5XzBlDs/L0Evm8SSy9PN9AqbBnekxrB5gfiK4Jmu40P+SMlakbjMzBlaQX/vC2aQCCpfUqPBgeQ1ZLKoWU3cZ0onfSOPz9YUN6OdzU3V0BbWNlfYWtvrotBxWtBkXo/ndtLUIP3wdrCgQ6fstSKya2esL1cTrvRYaFzJlz5+xw2OBtyWIxV6xK5jWUxJRC8irb2nE+zWvh5VXPKmvpb+oav8gw2zDkUBswhoHcea2VZ
 ZDJkEn/X
 6YaT1rHt7ki+Q4s3UdguTqAkGbeHwdrZUUoESPRiIXk9RL7fRcmpTgy0lBDLhN7D0uBjSRv+Eei2UgQKClAiWWeIJPYIBGQtVTxYC55E8ml21z6E+QtVFctsp/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

We select certain test functions which either invoke each other,
functions that are already const-ified, or no further functions.

It is therefore relatively trivial to const-ify them, which
provides a basis for further const-ification further up the call
stack.

(Even though seemingly unrelated, this also constifies the pointer
parameter of mmap_is_legacy() in arch/s390/mm/mmap.c because a copy of
the function exists in mm/util.c.)

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/s390/mm/mmap.c     |  2 +-
 include/linux/mm.h      |  6 +++---
 include/linux/pagemap.h |  2 +-
 mm/util.c               | 10 +++++-----
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 547104ccc22a..e188cb6d4946 100644
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
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f70c6b4d5f80..23864c3519d6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -986,7 +986,7 @@ static inline bool vma_is_shmem(const struct vm_area_struct *vma) { return false
 static inline bool vma_is_anon_shmem(const struct vm_area_struct *vma) { return false; }
 #endif
 
-int vma_is_stack_for_current(struct vm_area_struct *vma);
+int vma_is_stack_for_current(const struct vm_area_struct *vma);
 
 /* flush_tlb_range() takes a vma, not a mm, and can care about flags */
 #define TLB_FLUSH_VMA(mm,flags) { .vm_mm = (mm), .vm_flags = (flags) }
@@ -2585,7 +2585,7 @@ void folio_add_pin(struct folio *folio);
 
 int account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc);
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim);
+			const struct task_struct *task, bool bypass_rlim);
 
 struct kvec;
 struct page *get_dump_page(unsigned long addr, int *locked);
@@ -3348,7 +3348,7 @@ void anon_vma_interval_tree_verify(struct anon_vma_chain *node);
 	     avc; avc = anon_vma_interval_tree_iter_next(avc, start, last))
 
 /* mmap.c */
-extern int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin);
+extern int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin);
 extern int insert_vm_struct(struct mm_struct *, struct vm_area_struct *);
 extern void exit_mmap(struct mm_struct *);
 bool mmap_read_lock_maybe_expand(struct mm_struct *mm, struct vm_area_struct *vma,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 1d3803c397e9..185644e288ea 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -551,7 +551,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
 #endif
 }
 
-struct address_space *folio_mapping(struct folio *);
+struct address_space *folio_mapping(const struct folio *folio);
 
 /**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff..241d2eaf26ca 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -315,7 +315,7 @@ void *memdup_user_nul(const void __user *src, size_t len)
 EXPORT_SYMBOL(memdup_user_nul);
 
 /* Check if the vma is being used as a stack by this task */
-int vma_is_stack_for_current(struct vm_area_struct *vma)
+int vma_is_stack_for_current(const struct vm_area_struct *vma)
 {
 	struct task_struct * __maybe_unused t = current;
 
@@ -410,7 +410,7 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static int mmap_is_legacy(struct rlimit *rlim_stack)
+static int mmap_is_legacy(const struct rlimit *rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_IF_KUNIT(arch_pick_mmap_layout);
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim)
+			const struct task_struct *task, bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
 	int ret = 0;
@@ -688,7 +688,7 @@ struct anon_vma *folio_anon_vma(const struct folio *folio)
  * You can call this for folios which aren't in the swap cache or page
  * cache and it will return NULL.
  */
-struct address_space *folio_mapping(struct folio *folio)
+struct address_space *folio_mapping(const struct folio *folio)
 {
 	struct address_space *mapping;
 
@@ -926,7 +926,7 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
+int __vm_enough_memory(const struct mm_struct *mm, long pages, int cap_sys_admin)
 {
 	long allowed;
 	unsigned long bytes_failed;
-- 
2.47.2


