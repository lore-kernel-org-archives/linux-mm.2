Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB44BCA0EFF
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 437A58E000B; Sun, 31 Aug 2025 05:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3743D8E0001; Sun, 31 Aug 2025 05:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E4D8E000B; Sun, 31 Aug 2025 05:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 084448E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C15BDB9573
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:44 +0000 (UTC)
X-FDA: 83836555488.30.DB9586A
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id D1D7840008
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=eW6ltQih;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CA7/Z0h4l3VUXRftUOxDU1DV2lHah2+SGvyysIvLq/0=;
	b=wfh5YWzqeZqc8u21MacF3rVKrcfkSv+wG7Ns0JoYwocYU0lKaGkiFNelNrxF5LJEE03JNx
	a3GnH00Sg2ARzjrkNWiVB7klOtwbeysycbY5IIjposeDoCqsYU2ZlAh+nsYGTxX4VNoo0j
	5eD+XOp5QWIaJzCWorFeBKtTHRidpy4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=eW6ltQih;
	spf=pass (imf07.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633182; a=rsa-sha256;
	cv=none;
	b=gSgoW5J+wu1xnmK2IKkqimgZtWteeo5738GfxZdgGU0AJ7+L9Dt53fXlvAs9cnzTClXOoa
	4BUQs/fxqaDelz+s5paHm7xKN4TA5Ss+ZYFl4KA80jrO6BOYrRWI2Y03nkNO9J89BhbAE0
	q7VSzr9SjNFq1iTMIktPD+F25kOTZdU=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b04163fe08dso80355666b.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633181; x=1757237981; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CA7/Z0h4l3VUXRftUOxDU1DV2lHah2+SGvyysIvLq/0=;
        b=eW6ltQih/bqcg60w1GDUTCTF+0RUVMo20ESMMVEWVWnGp4sXyf384UX12dmQMLwmrU
         afbgZYAc2fdEcBl+SHwmdXifpvc8mGPhz4gSl9pcd64x4ce7SkMt4Z2kyEm0KyCgRzyS
         GvvJEt6wgxHoY9zWH7fszwTb5SuFE1QjWM3H1fzr5Ss1oguJzDIY6UwH0y2cKK0/LmBB
         omMoPQoZR/zw3x90NJKey5n3Y/Epzv+tJBZ6MhN2qeGpWkbfA88exyJy7niPwZVM5xsa
         R6URcmvAl9T8+xTGgWyrd94y9Hc5Oj6cQkwiVmObaqXTdwMAKBG/cJpRG9M1Ep7CwK1u
         wX4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633181; x=1757237981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CA7/Z0h4l3VUXRftUOxDU1DV2lHah2+SGvyysIvLq/0=;
        b=fc9IMI9uX5nw5DfFKCt8vNxTD7sMG6Zf+g6MLnXc5OqHhKN7MaqDoONh+beJQt0ctl
         +NtFXYtUsTA4+5gTi+dxRXWRf6AC9ip3rj/S8QrvBuhTZKvex/ygrqgHIzIegPwkZbUx
         w8/8a9IG1IzxqEsE6A/GMg9ZOyo82EZAt8z4lhG4RTo7LVJMhFU3gQqX6MIq+2tSMBCC
         EXptNAVpYBqkjKZ0nWfzYpClCnaUKjHoaTbz31gw0Ypb7rrmGMA2bXmxK1mLVpNWlmZG
         ScRnDpKSCSlAMRrMMXrlsvXoUgRFMsGWF9qJ2FQee2UhG4+gb8OaM8Y89sHXbqhF5UYt
         MIyA==
X-Forwarded-Encrypted: i=1; AJvYcCWj1PkI/h08yCA0QUmpJalcwXzv90V3gOibpcPDW3O+ZDcrk01FRXMVxsqNHsRvP8ltmE8N72xuVQ==@kvack.org
X-Gm-Message-State: AOJu0Yz2/Ic6YeKspkZ8Uk0FEN0IKOSC6LaWz0tWO5U3P2GOEsy4zANM
	8H3TBSIyspnsgmehxkyTIz1fcQOCoSz+jb7Ug1v0z/dt7O5CZfrLFaaaKqeTYlYxgJY=
X-Gm-Gg: ASbGnctMeoFpZOAkv2id4w9y/164/DUwtbR1Xe9EWEQQ0nNYhqCg1Q/v79oo6tudwDD
	y9kXs/p/Ts+fDLwv7NImkNRYtVXjdpUhQd2P3g+URkMHDSgzcWaHH+K5BvB2HYbqLj7ukWGFoQU
	+fcXoJSMqb2tNzHWvc+Z3RSVJ3SIWVFi8so3DFVRfbvqIokMNfgHpfIqEjN1xFKTwKRBMfii9RQ
	RrMW3YvwtNCJwBaHYkLrEyIEfcPyOyhzwr/EG1zkjITwsJeCLoI+MyLVZtxgM6OkGHvH5KfSNwF
	JBV3/p4ZDnw1lVsEInctckA37OLE0U722PKoDGKcaSIWU0TR9nkeDfh53fzOYfGG1SeVuz2fbNl
	IzzewgiuMH/WsotD3RIZAIz1OuGMqAYs7AZJHnzqa7EY8YvZSyeqHRXmebLUQhF1tgxfvaa9zgp
	xxngCvUTtHNWpH34RSP4zKpQ==
X-Google-Smtp-Source: AGHT+IF97ktlnWZNvlYV47UHXkNu5gmgjhCz45wCbFG7Qfw8zaP0gxXJmVUcuyEw2604qQrSFAsTAQ==
X-Received: by 2002:a17:907:7f1c:b0:afe:87df:b94 with SMTP id a640c23a62f3a-b01d8a266cemr430994766b.6.1756633181339;
        Sun, 31 Aug 2025 02:39:41 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:41 -0700 (PDT)
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
Subject: [PATCH v2 06/12] mm/util: add `const` to several pointer parameters
Date: Sun, 31 Aug 2025 11:39:12 +0200
Message-ID: <20250831093918.2815332-7-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1D7840008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 4onz9ao6wjebhbz9r9zibn3e3hz866pc
X-HE-Tag: 1756633182-387459
X-HE-Meta: U2FsdGVkX1/4AOV7nXFE2cna1uzUPi90IiJKq8uDR8iRxUq/A50xsgt6XSV2yEOGIxOjMri+x35m6QXapwfli5ahNXaBER7iVPAvC9Xe7OpQdoYN5nXI8CziUcEUyA9IHEs+scV0RiNKpLzzgQLohBlHKVoVrVbXZXX7sDkLlyNwHzvwQHNwZtHc1bG4OHb7QKZgZTLoTlVDPnoSr/m8OL1XLM8rvW8dsTxE/Pqi4Q2FI7XcPiZkA2iq2/kBHdZ5WU+bqyMsB7fl+A9+5LpLuA9uFbE3KBHxhLkxPFIugo7hvMWVqKwxI0vACDjbEG+KvUlDYvyojkHpkhy9FgifOiCVpaCcs0g2SnEV/NW5gBxmrYXa0Z+7q73d/wEIm4wreChcRqvS3wL/3tm5MulwcHREAFNVLAw/ejceX0l+V/YimyGyMCbtzQlyE4bX1n0byXqTeEMNdIlP+7AE5bebgkYm1wJDjx2AErvnz8wFkBv5vZPJpfWRGSRDyMpOE5wfZMV1rUx2li2gwv9925XSTsJfTr6sDittCVjmtywMOYgKfjCAfj2yl5zftHwv1A/IoN4h9hvDG6b6CJv2Rax0b2Mt4KO2bP+kCtXVTV4PqsCDcMVtQIrEYjWhyF8a04W3DGxBp4MJKM1KyeOpW6g5WcTRSbgZTY0O2/9LTWke9xnm0TXKfD/tNbnMbbQdD16isRt9RvZaz0mws6MUe3JWWoBGZBKAH58mP4H7OL2VuvHZAvixbRcOU/GVj3OKy9TNczAiloqRTabghR4RLEciaHa7wVoxU7tPjsy3g8U5RZSf/FfukEHsGKu6TVSQu6DhcJWcaqs32Tkslv4MjCSMhF95aejDRoami2TOZISTnWKTdOVzkzihJ/61fh0kXv96NhxQ5EX9M3vDbemSzVjJNY7FAp7LWJB2WpRiZK/LDrGMwzsDMYfMiDa1nJSPHqxZYFyQD0p08byExABaMdR
 qwnUpt4U
 RmMdRpugRXbA3jCSeu48kr5FoYZViNaOF+51iQ8op8MGUoFOrc2Z8LMrdh2HKt7BGRGqvxRubYbxtLw5OCfvcByrd1X0+2yEO5XmMQy2p6dAvt+bF2KAV+VfcaVVKsg6Gr1WvWrot1YnBkbhE/zt4yGZ1mkE2hZ91mc9IJgRVaJXTrmwX3iXBsAEHTuj+sAaQvDuxhWq8uaP550GiCRrZTk/aYQiU0wihF2WAdnElEc+hU87OFluLDtgvCYlqTO9EpcmV0mKdAsXdWT9jedH5QOLkCbQqVJ3qHCtTZT+ZI/q0D3MNIEb5lr5NsXpeIQUA1eXcDJVoYqCyI+Vgr3pXzh8AsiQavGzYnBJVcz0kdYGcPf5Lz0RczObflfKHn4/KpHPLfgQ/LteMFC9g/V5qd7/SNbE26bC86n01Ex6w14KgiByhHn9BGKopDifPJiE/KxLRJi8FAZi2EoN5+tB9lqrMOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

(Even though seemingly unrelated, this also constifies the pointer
parameter of mmap_is_legacy() in arch/s390/mm/mmap.c because a copy of
the function exists in mm/util.c.)

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/s390/mm/mmap.c     |  2 +-
 include/linux/mm.h      |  6 +++---
 include/linux/pagemap.h |  2 +-
 mm/util.c               | 11 ++++++-----
 4 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 547104ccc22a..c0f619fb9ab3 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -27,7 +27,7 @@ static unsigned long stack_maxrandom_size(void)
 	return STACK_RND_MASK << PAGE_SHIFT;
 }
 
-static inline int mmap_is_legacy(struct rlimit *rlim_stack)
+static inline int mmap_is_legacy(const struct rlimit *const rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1c18b89c2d28..d12550ae9814 100644
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
index d1244e7dcf0e..37a05de82140 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -549,7 +549,7 @@ static inline void filemap_nr_thps_dec(struct address_space *mapping)
 #endif
 }
 
-struct address_space *folio_mapping(struct folio *);
+struct address_space *folio_mapping(const struct folio *folio);
 
 /**
  * folio_flush_mapping - Find the file mapping this folio belongs to.
diff --git a/mm/util.c b/mm/util.c
index d235b74f7aff..f5a35efba7bf 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -315,7 +315,7 @@ void *memdup_user_nul(const void __user *src, size_t len)
 EXPORT_SYMBOL(memdup_user_nul);
 
 /* Check if the vma is being used as a stack by this task */
-int vma_is_stack_for_current(struct vm_area_struct *vma)
+int vma_is_stack_for_current(const struct vm_area_struct *const vma)
 {
 	struct task_struct * __maybe_unused t = current;
 
@@ -410,7 +410,7 @@ unsigned long arch_mmap_rnd(void)
 	return rnd << PAGE_SHIFT;
 }
 
-static int mmap_is_legacy(struct rlimit *rlim_stack)
+static int mmap_is_legacy(const struct rlimit *const rlim_stack)
 {
 	if (current->personality & ADDR_COMPAT_LAYOUT)
 		return 1;
@@ -504,7 +504,7 @@ EXPORT_SYMBOL_IF_KUNIT(arch_pick_mmap_layout);
  * * -ENOMEM if RLIMIT_MEMLOCK would be exceeded.
  */
 int __account_locked_vm(struct mm_struct *mm, unsigned long pages, bool inc,
-			struct task_struct *task, bool bypass_rlim)
+			const struct task_struct *const task, const bool bypass_rlim)
 {
 	unsigned long locked_vm, limit;
 	int ret = 0;
@@ -688,7 +688,7 @@ struct anon_vma *folio_anon_vma(const struct folio *folio)
  * You can call this for folios which aren't in the swap cache or page
  * cache and it will return NULL.
  */
-struct address_space *folio_mapping(struct folio *folio)
+struct address_space *folio_mapping(const struct folio *const folio)
 {
 	struct address_space *mapping;
 
@@ -926,7 +926,8 @@ EXPORT_SYMBOL_GPL(vm_memory_committed);
  * Note this is a helper function intended to be used by LSMs which
  * wish to use this logic.
  */
-int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
+int __vm_enough_memory(const struct mm_struct *const mm,
+		       const long pages, const int cap_sys_admin)
 {
 	long allowed;
 	unsigned long bytes_failed;
-- 
2.47.2


