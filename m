Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59106CA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917ED6B00B2; Mon, 28 Sep 2026 13:42:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87AC16B00B3; Mon, 28 Sep 2026 13:42:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CEE6B00B4; Mon, 28 Sep 2026 13:42:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7BF6B00B2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:42:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A7BA120258
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:07 +0000 (UTC)
X-FDA: 85263889494.11.B581FAB
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9FB961C0004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:42:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PX3CsWCi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 37Ka6aggKCIExrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=37Ka6aggKCIExrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617325;
	b=LfEXfmGJo+6Exhh9Ic7J7sKzH76RMlhJl2rVl3Ewj4OcDZ7yPn5Fq3SeO3TNk3WGpq7p57
	t5I+313Dz8jDyGKx0xg8Rl3wRaeGllYFBif0lGrAZoNxz+Pg79cjdeBcLcaZYf0kVYWs+b
	tOOc6Wuq15jB0DFgjBe7aXqlfcTNLiA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PX3CsWCi;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 37Ka6aggKCIExrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=37Ka6aggKCIExrtxyfkflttlqj.htrqnsz2-rrp0fhp.twl@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RH6hoqk7EsLMc9nVwpPE+90gab30BNeM/1qTHEr8Y8=;
	b=M2u346VKQBkdyzKPTTPf175AQ4BJVVgVtiVMI1/zcIDbg4HPXUJo1prH/zv4i8Z+MpAZUK
	upHlRcf27V3L5Uo++hM2epfyqyWW2VilYToQGAT5w1RESER4wjq0g/n/W21uHfNWrLCF6H
	Rz6M8RaWHMUOdYMlgLBR6hC0HuUlhp8=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49ccfad90f1so26755215e9.0
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617324; x=1791222124; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7RH6hoqk7EsLMc9nVwpPE+90gab30BNeM/1qTHEr8Y8=;
        b=PX3CsWCiDqs2sYBlq5gcWDA+ET6SAL2HjNcSSNk3S3mLs3AUhUIyqNEy5hysqUFvTB
         8ZLNtIY9QutnzLSoChfv5l1wGfqKNVgGDic9OmKNIw/HUsQKCLwtg6939OK15agG7Q87
         0tH/9HO9L9dIb+M3l1g+9doQPm9I2NIgnk/ypapyHhYHykTbIn15p0pAVL5zi7Sfz5BP
         e8xBdZEOYAG7Ei/oPhBa1WW8CKyFR//PjmMf2An9iCaM87RymVHrYbnjpqnLxcCjdd+9
         oifAoq3jHOXAnZUrG4REaz5LaGEz3zmv0eip/o6sm0quemz09oRr30M2TRk+I1mUyY8B
         UYKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617324; x=1791222124;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7RH6hoqk7EsLMc9nVwpPE+90gab30BNeM/1qTHEr8Y8=;
        b=okgOs0GZUk78uYusn9QQAv9KoUN8mZMydFO0SMEFe4g4v1tBcax73+NQ5kMnxbxYmc
         mPCBWG4m5vo9oH8LLLyV/t67nVAsDbg9MoFN6Jce7Y0uZGJuwCy1pes4oETBOtYBxEYZ
         M8+Ej/m5n8Dr32Zwa4ZBtGFnf412uwQqBbJFEro4aERHHhNc2VmDRIOyGoQGS1iIQP+J
         9UGDrlsOc9rRLVfsrP2ymVnR0di1co+CXmtBxG1UKkZbLhInmEFiytFsVdxUijuDhuGZ
         IVpuvq0M7rxxYqkovUoEWW6LBbsCn4TPIjb486aT4hWCuWv5F1rq3FpiraWlMNttVJ3+
         +e6A==
X-Forwarded-Encrypted: i=1; AKwUvBxAvsR0b2vQWiMUejAr4FZU86r+5e3VE4m2aeyRibHEpO6C+/4uKt6TDjuo5NtlR3Z/IjJi1yCz+A==@kvack.org
X-Gm-Message-State: AFuF++lRzbQKGxx2ZXWlJe9PEylcH3DqTL9m14ZZ9hV5XyMNgGEwCYLG
	kIIqh/4BcqxBlT+E5AinwsePEEYAOcEyaOZfcvjKiZP5DOvlG+h3Yb8X3cfypP4h3eiZKBoZYTq
	NcwHBwOuekdmWRA==
X-Received: from wmon22.prod.google.com ([2002:a05:600c:4656:b0:49e:7ce3:41f9])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a15:b0:49f:e444:cc4c with SMTP id 5b1f17b1804b1-49ff06bdb00mr183042675e9.12.1790617324124;
 Mon, 28 Sep 2026 10:42:04 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:20 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-14-smostafa@google.com>
Subject: [RFC PATCH 13/15] fork: Implement partial VMAP stack allocation
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Mostafa Saleh <smostafa@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Linus Walleij <linus.walleij@linaro.org>, David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: iyahg5oapj4rhbo85zidqnfuz557s589
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FB961C0004
X-HE-Tag: 1790617325-582590
X-HE-Meta: U2FsdGVkX1+WvRFiwVvh1Jd+7/p+aW7tu8M3LpRfPXTjZDWCHi6hIAItCR5Y2eJeMfwxyts3DeDfghy+QQqdcHeVcJV1AcIHLBYmSdrUYIVkKPd2bT2tL+/Q1BkiKIsUz7tI4DjmGaTl3NdIC6zwKck74EH9W/KBhI5HilwUs99lnXY7FRWIu6Z6BpsDMNvUTxnJKpuZuhgNpvQR53BV6SPeIH5KB+/yzN/RZUK9gvTxYDYF6KmIdhHA4DelNiXvdAvJSkIzOZ4be4WUBSZC0+VILYB9r+TsmxnLOyNdJTBAbIIB5KBs0FBT/AskFDxl6KGvA7jbVUI0H+UaSr1O7j/in8nHSNXngQXOiGPrcv4uM/r0ZnT5OanHWOOykSvvlsObbDWIS3TbC5Nr6i/czy1zOlwrugHahAbrdZCUideqipBXbduoPH3ykR5jT60OCt3k54trD47QmvewTJwLV01PefWwxQ5c5wTVK5l0k4gSHWbZX7S/zFJ/7lRtsQZlh8cYBwh3lrstRJ8zExLr2jGVVfSPPwnZww7D8y5ZNboJ5CzwfwxTf2mM9tx7jBncnz/vCjAJfdEphkAEhyW00afjia11gkxbJIAISniDdvJBYrTjvWgAjvtVfNodBxhwdiFLOTuTr3nTZgLeXvc9RNkEtS8yiQYjU7vE5xFKDNQouqoRFImZHLhIF1NQLaCVFxiAFDSTDjqwLhR71TCsa5IRLlwhZz9axzO4LONTNJAa3qbszHZa73jyIvqQV5xDAzWE7bTvKMr4vloR11INS5mGEYC1dbuo4YwL6PD/Iij5oPRA0H/UhJ7T5cFdcvUfEJaHlbiyoRk4WOW9jBIDR6wJfn4ZyFH6xDwU43qwpH0SGF4mBs7wFCX/2MLaqlh3U5pl0NWb9K4YLnhknSd9IoRON/z2xAS4NpXf3dGNab94F4gmVXL1BLDXT8UreS7BzgD+dtYeByI+oikYRSc
 f9nx7GIH
 kIalv6hq0iFB8TszmwYfuDKIcqYPpzMvxBYANf9KaiiQ6R/+2/OvwORx+ds9PfAD8yQAlyEJXxLCRO8iHnrytet+nk0z4xZFI2lE9r+bulHaXmbqPnssHsjKkFZib+IGDom6+Q3Xc4mCdXj/jAGH1Y80I59j33PS/B0EV7vhq3oHERxmFJ/AUP2CoHl+WaQeLoYFANHpxKwg4cDHgw/EMs6o7/RqXIFapQyclHXuBHf71aU3HjPxS5KZqVhw6Ylyzdz3D8LxrLdJgxJTHZeDWxqBtJGCrf0jG711GhPx6iMg4ayWjxgBndf/UPk906bPibGa9XcVbEwWh7puLUiJM8tn2/iZSOL/uBeyGAAIn/wU0GYNT7v79nv74L+9L4KB3HC6Lekq/KlsBkCoZWOt7jSlEu4pDKFORR3L9iTl06prszkc7LgFG3Qtv4wsg42sGAhFCCyuchn+NOv0D0RyJxZKcBkISZtt/bPho+TvkvUBjdqyNA+dVdbxe2XjmyUnSP7gvOtTRjBQPsG5hymTw9oOUPEf/eq/XiCiElgC9ID7IpQd/ByUpJ1XGkCRfxwEDBkPIi5dI7/9ZnLLwkpPBG2sqLHCQmgwq4giXKAguDPqGLMaxVdaXDsxpCo1FRDI48br8fBI+F+hAJJQ0XqRntao2t64TusKD9jMiiRNbwMytBM8+Z0tQJnuTRx96pNWIjIbMpUWlu3KGXyHRIoGHUNAbOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE is enabled, architectures can
allocate a VMAP stack that is smaller than the full THREAD_SIZE.

This introduces arch abstraction arch_vm_stack_pages() which defaults
to THREAD_SIZE / PAGE_SIZE.
During stack allocation, the kernel will map only the requested number
of pages at the top of the THREAD_SIZE virtual area (as the stack
grows down), leaving the bottom unmapped. This saves memory while
retaining the same virtual alignment and guard page overflow detection
characteristics.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Rebased, used vm_area->nr_pages directly in one instance]
[Depends on !PREEMPT_RT]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
[Fix races around accounting]
[Use GFP_ATOMIC when executing in the scheduler]
[Depend on INIT_STACK_ALL_* config]
[Fix bugs in some error paths and edge cases]
[Don't cache partially faulted stacks]
[Added out-var to tell if address is on target stack]
Signed-off-by: David Stevens <stevensd@google.com>
[Remove dynamic stack related code, and update commit message]
[Fix memory leak in error path of alloc_vmap_stack()] and use
 VM_UNINITIALIZED before installing the pages]
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 include/linux/thread_info.h |  8 +++++
 kernel/fork.c               | 68 +++++++++++++++++++++++++++++++++++++
 2 files changed, 76 insertions(+)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index 307b8390fc67..8f052ec82402 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -92,6 +92,14 @@ static inline long set_restart_fn(struct restart_block *restart,
 #define THREAD_ALIGN	THREAD_SIZE
 #endif
 
+/*
+ * Arch selecting CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE should override this
+ * with kernel stack size.
+ */
+#ifndef arch_vm_stack_pages
+#define arch_vm_stack_pages()	(THREAD_SIZE / PAGE_SIZE)
+#endif
+
 #define THREADINFO_GFP		(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_SKIP_KASAN)
 
 /*
diff --git a/kernel/fork.c b/kernel/fork.c
index ca8e68882316..66fbad3d4cbd 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -119,6 +119,8 @@
 
 /* For dup_mmap(). */
 #include "../mm/internal.h"
+/* For clear_vm_uninitialized_flag(). */
+#include "../mm/vmalloc.h"
 
 #include <trace/events/sched.h>
 
@@ -272,6 +274,71 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	return false;
 }
 
+#ifdef CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE
+static struct vm_struct *alloc_vmap_stack(int node)
+{
+	gfp_t gfp = GFP_VMAP_STACK;
+	unsigned long addr, end;
+	struct vm_struct *vm_area;
+	int err, i;
+
+	vm_area = get_vm_area_node(THREAD_SIZE, THREAD_ALIGN,
+				   VM_MAP | VM_UNINITIALIZED, node, gfp,
+				   __builtin_return_address(0));
+	if (!vm_area)
+		return NULL;
+
+	vm_area->pages = kmalloc_node(sizeof(void *) * (THREAD_SIZE >> PAGE_SHIFT),
+				      gfp, node);
+	if (!vm_area->pages)
+		goto cleanup_err;
+
+	for (i = 0; i < arch_vm_stack_pages(); i++) {
+		vm_area->pages[i] = alloc_pages_node(node, gfp, 0);
+		if (!vm_area->pages[i])
+			goto cleanup_err;
+		vm_area->nr_pages++;
+		mod_lruvec_page_state(vm_area->pages[i], NR_VMALLOC, 1);
+	}
+
+	end = (unsigned long)kasan_reset_tag(vm_area->addr) + THREAD_SIZE;
+	addr = end - (arch_vm_stack_pages() * PAGE_SIZE);
+
+	err = vmap_pages_range(addr, end, PAGE_KERNEL, vm_area->pages, PAGE_SHIFT);
+	if (err)
+		goto cleanup_err;
+
+	clear_vm_uninitialized_flag(vm_area);
+	return vm_area;
+
+cleanup_err:
+	remove_vm_area(vm_area->addr);
+	if (vm_area->pages) {
+		for (i = 0; i < vm_area->nr_pages; i++) {
+			mod_lruvec_page_state(vm_area->pages[i], NR_VMALLOC, -1);
+			__free_page(vm_area->pages[i]);
+		}
+		kfree(vm_area->pages);
+	}
+	kfree(vm_area);
+	return NULL;
+}
+
+static void free_vmap_stack(struct vm_struct *vm_area)
+{
+	int i;
+
+	remove_vm_area(vm_area->addr);
+
+	for (i = 0; i < vm_area->nr_pages; i++) {
+		mod_lruvec_page_state(vm_area->pages[i], NR_VMALLOC, -1);
+		__free_page(vm_area->pages[i]);
+	}
+
+	kfree(vm_area->pages);
+	kfree(vm_area);
+}
+#else
 static inline struct vm_struct *alloc_vmap_stack(int node)
 {
 	void *stack;
@@ -286,6 +353,7 @@ static inline void free_vmap_stack(struct vm_struct *vm_area)
 {
 	vfree(vm_area->addr);
 }
+#endif /* CONFIG_ARCH_HAS_VARIABLE_STACK_SIZE */
 
 static void thread_stack_free_work(struct work_struct *work)
 {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


