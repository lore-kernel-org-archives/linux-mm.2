Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BE0FFED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62C876B00A4; Fri, 24 Apr 2026 15:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58F336B00A5; Fri, 24 Apr 2026 15:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3946E6B00A6; Fri, 24 Apr 2026 15:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 230D16B00A4
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:17:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0A041202BA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:10 +0000 (UTC)
X-FDA: 84694407420.27.D9A4EBD
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1BE2420006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:17:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VDanVKNs;
	spf=pass (imf03.hostedemail.com: domain of 3s8HraQgKCDwqrctclqbemmejc.amkjglsv-kkitYai.mpe@flex--stevensd.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3s8HraQgKCDwqrctclqbemmejc.amkjglsv-kkitYai.mpe@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVunvLNRu5wU/C5dXUrSh/20awEeZOSQNdDKwzJM0Dk=;
	b=p3kt91RD8xjiWo9l7akKjOHf2YzFUxNbq16B//KN0f3DWbuqtGBxwoKYECvaFVP+aPnpTx
	auVoUAplfdBFM3FlKSsLyhy280Wt3qgI7dkexRKLDRC4r+u1n1WsTh74wldoRnexz4Xl7d
	S15LoryxZo1K9ebUzDp7h55CCpce6SM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VDanVKNs;
	spf=pass (imf03.hostedemail.com: domain of 3s8HraQgKCDwqrctclqbemmejc.amkjglsv-kkitYai.mpe@flex--stevensd.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3s8HraQgKCDwqrctclqbemmejc.amkjglsv-kkitYai.mpe@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058229; a=rsa-sha256;
	cv=none;
	b=ipXufaOJTrsELBSd9v2tkVhjQ7Z31h/vmTYPkNA1b77oLfi80v1sqrtbqOxMwiSqSEdlLP
	Tnx+oNbtnMB5pgYLJim/1YflJ7DsZlWEujncgL3FYX75WufS9JhBsR3Opw6AlTrR71LI1D
	JsCCQh1lICkHTYmaIUwuVyqQrARKnmw=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12dba1e866dso2820952c88.1
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058228; x=1777663028; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVunvLNRu5wU/C5dXUrSh/20awEeZOSQNdDKwzJM0Dk=;
        b=VDanVKNsXzUmsw4LJm4gk18+jO3cufVEU4K5bm6LlOCjfHSUwS2MXS6w7P7Xvni4Mi
         dYLtdWfQVxAkYlZi570i0PwyO7OrLPqx5O+K6c0m3npzkUjlJsxRXsf1wYZ/w8qD9jIr
         BN/ToKr0BfynnE7MbhuxBtNpFJ7KrnIG3MrpJwJG31lcGsjcApsBgtSS4rD5l+/4NbH2
         +T4pzG+g+QBpUOpMjCJYC0tiEeSGzTKsklGfQnvV+3WTRQ4r2heUMa8PsmafxK+cgTOl
         DtEEobWSC8vc8NxZ764IDR8ijXS7o6/ad/VYo+g91GGbjp5OBMBkmeLcbrJBilxAkKh7
         znRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058228; x=1777663028;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LVunvLNRu5wU/C5dXUrSh/20awEeZOSQNdDKwzJM0Dk=;
        b=Ojxbx7vPGeGPuBq7I/nC/6t0rNWrAcJNtk2O42Mn0dOOncKVZuBH5FngRoqHTzyUD5
         IgUy4zcLQOd8WgnWSFiZFrime5sQvWu6VJQxkt5WyJjhEDJ3GvagvloqKyEJ5hQLtHY7
         GLqtleRbL+A5/Dmxu2c/TWd5F3QrEfNBX/8GP+gpua807XiRZZ4dQw8HpvjbnoKm9FbS
         s5ggl2kCJ9PEzEMEJFlkQdhxAh+Ce70C6CFXEXd2E/TqargRWA6NcDoL1zNMBlF2MvCW
         2+Xd18ymicHqoZoZRrdy/UZ7/jvSpd8BGnVzTf0aT7vRxn2u73VUYja3Rf2FiyJpZ/1q
         sIyQ==
X-Forwarded-Encrypted: i=1; AFNElJ/Ufcxt/72EGtZndXrgS6mtp53qs39bKnBnZx+Z3oxKLzLUjIdoa4BgwbuI6EqcICRA2j3v4NOlZQ==@kvack.org
X-Gm-Message-State: AOJu0YwaC7Lxq2w0lLb0zhlQ0AnX16D7qYmqtUokmvf5/UxQVtYBngs2
	OFF+bZkiqPT+Zhn9co+/IwunPceS5g9I0G9Oy7efFVYNNIY0TZOHsFcMSQ4HvEbakJ/Xf4DxIIe
	VUQgat1XFMhyW4w==
X-Received: from dybnj5.prod.google.com ([2002:a05:7300:d085:b0:2dd:4573:2897])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:b0d:b0:12c:8eb:80b9 with SMTP id a92af1059eb24-12c73afa081mr12946449c88.6.1777058227667;
 Fri, 24 Apr 2026 12:17:07 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:53 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-11-stevensd@google.com>
Subject: [PATCH v2 10/13] fork: Store task pointer in unpopulated stack ptes
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hz936kqjqp3ykbywod5er173jnezps9q
X-Rspamd-Queue-Id: 1BE2420006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777058228-73508
X-HE-Meta: U2FsdGVkX199wqqGRyOtnLrpDBxIPrRF+RPtzgUzfd+sAXM8bEhwfilmRqJldcorButorO9OUhU8m5/kFkC6VCnqO1XEahjh9gP9YweccyyrlRhWjPcf24Ep2I1P55lhQAA5XpzfCsVg8t0nf0ARfY6VwhTUEOTFNmxlnSIQuSM6UrBxaDjFJUHGPawTO124TGlQg1aqNaAO3qyRaT6aZXz5N/O+4y3PXbALzoFo1vxJkIFPUv3rhvtmAzI+yz7DSPuLun0z6OZGmJe24BTAlgON9ziOWqT14Dd267GMXV0J27yOgHHGVxS/FRub5epFw4TIDZ3LBRIN5yJ7mGNT7/LuykyaBG2ThCfS/vSjH5yNOb9PlsWY8r82BcrcZnEtZH8h65mFkvDoT/2rXGUnIohEx6vooQny84zblcOEbu4CrhWzngZQMIHq9/FxQ7rPV+hmMiSPZnQVeBpJoOi8ohDeTjBTkvKwUz0M1Symde58+/qKip/a6uKyCllCV9FDhkmHuEAIw6sblYUKuUH7GNRXQVDrLZQr6BUlJecTssCjxsmmoNi6aAdadh+k+tppfmjtu7yGK82GD03pq1ehg7Hzg/A8K7xJEeZ7ImP0cM9nFWC306KC40hfgWlElvXKhUy5CD5Fj4vFCcCAX1Lncad1ktstzX/2D60IulSjd1qxl7yhdSJOtOu+5J7mu0Daz1R2QuBcpNwrclTtcI0xS3I5d4xeSEGVL8S+YDRlJqDjdQ8vTszw44kX0JpubcrISyGlf62/LTqRD2Tr0p8mFkP8gMgtwuxWoVkssZjoO9D8/4FWMejO3IOglpp1CsxbrMLdSNQ8IxzNpI5NYz8IipmWVs8tlUx/uyQ3LqU83xfaOSdBANXMQ+93hw20qgaF6lQyC7ixGokeWkzjdKXFxIAra1KsCfUvi+F2Ql5NERNoP+lPXz2z9KSEwcvKch1bEfZ/AC/c5CcMLRejEbp
 ZNLYtfLI
 U3L5KQJQKPLz1Au5Y4itCuuBlGFJkjHSzIqwlQbK2t/rcGz7FveIP6qZKEinQdU6/I1JxWhhmE3kUhhdQJb5rjTynByjEmYYFOWAROBBKGm6SevejPrFN+ZylB5aND1Ckj/LqPskaOIi8uCwXKlrHkPUMc16K2L14UmKSg42NeWqBU4ly5QLt12UNX8nz81kIrJ7gE+Gm0c3x8CvwQTy5hHwfq0TCT7uW1ieWHz79Bc+1yrYTKLhYuw3Xk0Uei0SH9o95/nPafl4wv7GonfAIm0vhehXl5MsBVvmN3GwpfdZ9MYOXWmVr8XA/GK4BZCIbxc8hz26/oKoC96whbKP8v2p1JSZO1avOwQgltAYEaJTesJlrgw6IcOaoW1nPU8rHJ2IyF9dwqbfKVltB2LF/B1dnEIyDW+HUGi3zSjuMw3Z7yQA2ktVgSSEj4/EHOV3c+aFI77P8E3+Y5fg8wPXqIodpwJoHY5sOo+8Kg65mfDPXIHppW8mQ15MB7gBb6zdach+CXz7E8HaDb7ww81oKJ9sJYUWvh+aYA1RZT5r34GLqkf9LDW0LqvfuI0KbUD4oXvkQZKsGGAFz6iuY4pc2W0kqXUb06QuLXC4K0AA+VviqJiyjTSTbVHMJ2YKyjMZkLWWluk+416uJEvg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Store the task pointer in the ptes of the unpopulated pages of dynamic
stacks, to allow the vm_struct pointer to be retrieved without relying
on any locks or current.

This relies on being able to pack the struct task_struct pointer into a
pte. Since the struct is 64 byte aligned, that gives 5 bits of leeway,
which should be viable on most architectures.  Any architecture which
enables dynamic thread stacks must provide make_data_kpte() and
unpack_data_kpte(), which pack/unpack a right shifted pointer value
into/from a pte.

Signed-off-by: David Stevens <stevensd@google.com>
---
 include/linux/sched/task_stack.h |  1 +
 kernel/fork.c                    | 74 +++++++++++++++++++++++++++++---
 mm/vmalloc.c                     |  2 +-
 3 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/include/linux/sched/task_stack.h b/include/linux/sched/task_stack.h
index 7dcff2836d7e..7cf00ce97f7c 100644
--- a/include/linux/sched/task_stack.h
+++ b/include/linux/sched/task_stack.h
@@ -105,6 +105,7 @@ void exit_task_stack_account(struct task_struct *tsk);
 void dynamic_stack_refill_pages(void);
 unsigned long dynamic_stack_accounting(struct task_struct *tsk, bool finalize);
 bool dynamic_stack_fault(struct task_struct *tsk, unsigned long address, bool *on_stack);
+struct task_struct *task_from_stack_address(unsigned long address);
 
 /*
  * Refill and charge for the used pages.
diff --git a/kernel/fork.c b/kernel/fork.c
index 9ac9d23f5f4b..733fc1f58b8b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -296,16 +296,40 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 
 static DEFINE_PER_CPU(struct page *, dynamic_stack_pages[DYNSTK_PAGE_POOL_NR]);
 
+#define TASK_PTR_SHIFT (ilog2(__alignof__(struct task_struct)))
+
 static void link_vmap_stack_to_task(struct task_struct *tsk, struct vm_struct *vm_area)
 {
+	int i;
+	unsigned long addr;
+	pte_t *ptep, pte;
+
+	pte = make_data_kpte(((unsigned long)tsk) >> TASK_PTR_SHIFT);
+
 	tsk->stack_vm_area = vm_area;
 	tsk->packed_stack = (unsigned long)kasan_reset_tag(vm_area->addr);
+
+	addr = (unsigned long)vm_area->addr;
+	ptep = virt_to_kpte(addr);
+	for (i = vm_area->nr_pages; i < THREAD_SIZE >> PAGE_SHIFT;
+	     i++, addr += PAGE_SIZE, ptep++)
+		set_pte_at(&init_mm, addr, ptep, pte);
 }
 
-static void free_vmap_stack(struct vm_struct *vm_area)
+static void free_vmap_stack(struct vm_struct *vm_area, bool was_mapped)
 {
 	int i;
 
+	/* Clear data kptes since vunmap expects present or none. */
+	if (was_mapped) {
+		unsigned long addr = (unsigned long)vm_area->addr;
+		pte_t *ptep = virt_to_kpte(addr);
+		unsigned int nr_to_clear = (THREAD_SIZE >> PAGE_SHIFT) - vm_area->nr_pages;
+
+		if (nr_to_clear)
+			clear_ptes(&init_mm, addr, ptep, nr_to_clear);
+	}
+
 	remove_vm_area(vm_area->addr);
 
 	for (i = 0; i < vm_area->nr_pages; i++)
@@ -354,7 +378,7 @@ static struct vm_struct *alloc_vmap_stack(int node)
 
 	return vm_area;
 cleanup_err:
-	free_vmap_stack(vm_area);
+	free_vmap_stack(vm_area, false);
 	return NULL;
 }
 
@@ -477,6 +501,42 @@ unsigned long dynamic_stack_accounting(struct task_struct *tsk, bool finalize)
 	return i;
 }
 
+noinstr struct task_struct *task_from_stack_address(unsigned long address)
+{
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+
+	BUILD_BUG_ON((BITS_PER_LONG - TASK_PTR_SHIFT) > KPTE_AVAILABLE_DATA_BITS);
+
+	if (!is_vmalloc_addr((void *)address))
+		return NULL;
+
+	pgd = pgd_offset_k(address);
+	if (pgd_none(*pgd) || pgd_leaf(*pgd))
+		return NULL;
+
+	p4d = p4d_offset(pgd, address);
+	if (p4d_none(*p4d) || p4d_leaf(*p4d))
+		return NULL;
+
+	pud = pud_offset(p4d, address);
+	if (pud_none(*pud) || pud_leaf(*pud))
+		return NULL;
+
+	pmd = pmd_offset(pud, address);
+	if (pmd_none(*pmd) || pmd_leaf(*pmd))
+		return NULL;
+
+	pte = pte_offset_kernel(pmd, address);
+	if (pte_present(*pte) || pte_none(*pte))
+		return NULL;
+
+	return (struct task_struct *)(unpack_data_kpte(*pte) << TASK_PTR_SHIFT);
+}
+
 bool noinstr dynamic_stack_fault(struct task_struct *tsk, unsigned long address, bool *on_stack)
 {
 	unsigned long stack, hole_end, addr;
@@ -570,7 +630,7 @@ static inline struct vm_struct *alloc_vmap_stack(int node)
 	return stack ? find_vm_area(stack) : NULL;
 }
 
-static inline void free_vmap_stack(struct vm_struct *vm_area)
+static inline void free_vmap_stack(struct vm_struct *vm_area, bool was_mapped)
 {
 	vfree(vm_area->addr);
 }
@@ -590,7 +650,7 @@ static void thread_stack_free_work(struct work_struct *work)
 	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
 		return;
 
-	free_vmap_stack(vm_area);
+	free_vmap_stack(vm_area, true);
 }
 
 static void thread_stack_delayed_free(struct task_struct *tsk)
@@ -618,7 +678,7 @@ static int free_vm_stack_cache(unsigned int cpu)
 		if (!vm_area)
 			continue;
 
-		free_vmap_stack(vm_area);
+		free_vmap_stack(vm_area, true);
 		cached_vm_stack_areas[i] = NULL;
 	}
 
@@ -653,7 +713,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		unsigned long memset_offset = 0;
 
 		if (memcg_charge_kernel_stack(vm_area)) {
-			free_vmap_stack(vm_area);
+			free_vmap_stack(vm_area, true);
 			return -ENOMEM;
 		}
 
@@ -674,7 +734,7 @@ static int alloc_thread_stack_node(struct task_struct *tsk, int node)
 		return -ENOMEM;
 
 	if (memcg_charge_kernel_stack(vm_area)) {
-		free_vmap_stack(vm_area);
+		free_vmap_stack(vm_area, true);
 		return -ENOMEM;
 	}
 	link_vmap_stack_to_task(tsk, vm_area);
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 39b7e118cbce..76955c101180 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -76,7 +76,7 @@ early_param("nohugevmalloc", set_nohugevmalloc);
 static const bool vmap_allow_huge = false;
 #endif	/* CONFIG_HAVE_ARCH_HUGE_VMALLOC */
 
-bool is_vmalloc_addr(const void *x)
+noinstr bool is_vmalloc_addr(const void *x)
 {
 	unsigned long addr = (unsigned long)kasan_reset_tag(x);
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


