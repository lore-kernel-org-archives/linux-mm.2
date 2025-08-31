Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430ACCA1001
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5968E0010; Sun, 31 Aug 2025 05:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22458E0001; Sun, 31 Aug 2025 05:39:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC3C08E0010; Sun, 31 Aug 2025 05:39:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B877B8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8346F1403D5
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:49 +0000 (UTC)
X-FDA: 83836555698.07.C201690
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B69440009
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="i9/XIrPO";
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzEgZJLUIP42C+8Yle96H0gi+Ol4omF0icbAf6DUhQg=;
	b=h6/8m0MXGT96jNCALMgvURFxrsKy7de0Xp6X/3eaLSVPybC030Exrz0+e/Xb84KgIXX2+K
	clwcTiuaFtso0u7cHFpPS6WAc2seOTBI5OwmxN/uGQoKv6UbtB6qDb71nLdExYU3gYuL6A
	uILP43coL49pPrN0BPvNJ4JF8AaNTcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633187; a=rsa-sha256;
	cv=none;
	b=aQzlVoBcFiAEnxZZi714A66ZmW3uywd68KFvI9iPYkzPPtr2SUwi/lo33rjci01IGzmMYr
	DNhMepM9lUAdgiwk8ft03XxTy2glwwFt5/1WpOI7z/n8ss/B3Zh1V0N32bOKoCNxaeNOLx
	cYlndq7LkCs2oVRJACzKghjjX4AquYU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="i9/XIrPO";
	spf=pass (imf17.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-afcb78f5df4so589610466b.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633186; x=1757237986; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rzEgZJLUIP42C+8Yle96H0gi+Ol4omF0icbAf6DUhQg=;
        b=i9/XIrPO24K7hY32kytPMSGV8SggmlGF8RUIjPZVxGgITiAbOTGGskn39vjlt/5BkL
         LxubkBINdzEKsNQlHITemJXIlw7vZ5DLAUTGge31zjhiB6FjbqUay009cBgWuHsYi4w7
         9seB2hixI+QI6CAU/GCA1YvIOMLPEDUuzSXVRT0grDxxKaUtcns2RBOQoV40hfqg/Igm
         jpn4+N4UFiLekIVMLGDeUizlkAhzxQnJ/ZisqTh0jMOiGCvfR3Alrz2TSAe+RPXG8pH8
         28pFOsg1RAVsbrpCspX3ntn8yZVpSKZwfqa4RUffPoN91LLUK9rAuZtnfzw6L9m7EHWH
         V4NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633186; x=1757237986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rzEgZJLUIP42C+8Yle96H0gi+Ol4omF0icbAf6DUhQg=;
        b=wmmIutu006P+c19CVlC2cWXbhCuuYykitP6moH5w6/vrKdey9YEagn33FFtWO5Ltbb
         VU81FF1CA4GcJMseziiCr9fwmiGgcN2mwj3YCTMLFuHiNZQW+b1XpjT8mGARksN8Urrs
         xEoMqx1J7ASluzS1rJSpVMa61lUZOYxeiYt8wQ2+TDipMIe/yq/GqOA9OTqAMA4K8O2+
         cSRo+BF4Vuadd7Koc+YLwxUzuM9kbmbUp+L0fXQe7qzsISY3W4/aaGOX4UMGmBjnRYsE
         VRqmgESyYe7ejb7C+z1KmVMHOxgCd6F57q/fyh/RNTjb4SvnTeGyTVSIFtyzbIPW2kNq
         yDSQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeCGb0hkgcIzOjLOkpUExKBlJH6xbmgFjklNEQ3wC/4vBLy9phQlqzhC+MUxS6AK6STVmF+dzIfA==@kvack.org
X-Gm-Message-State: AOJu0YzBmHj83yqWzg2O8VCsSIXPGfMjmQdry1F3cs4MDx/q598Cjgu/
	eaw+GXFvChNYw1QI8mYcwlD9R+M0Gg6g1umA1qVunilpLvC3OoB2HCup8LzICZ0lJ4I=
X-Gm-Gg: ASbGncuoQESMxA7IQQ3YRG9TZP2e0G1f3zaXVHW3n/RLKQVwbKLs0rTqOFevv1P2MGz
	oxKikIqzQneVuM7dpjU2KKHyb2cPC/NjldzRmLA/7j6YYiAGgAXOZ/3MhiE0SngmOPLGpUm9bGE
	lLnMj0eBxlxhwcu0rHGL+fsyDX8sly90WpD7h54SeuggDqnu2pTZFGvUDh7kJIprdOIwTTRC932
	L8xpsrh/TaHm+vwKkMo5K7qijOffRBPc1WFk5Y3gpQT+pq2qRzdkur05FKKyh5h2/Tt1bLUnk4q
	GMoKdmxbvL5gi6pEE5TqSX8eDHclmqRmjHsZW4Ud5Qd11FQhq5QWxy6xz8rRDfW0DmoStXAs5u1
	jizN8FvUi/lzHkX2i+NpjQZ07x3GekWlSLnUcJK56xDFj2iwiF6sCyBN+vDHn2SGlN9S1FUrb8h
	a2evYy6/1ywurQwzxAUnHVpA==
X-Google-Smtp-Source: AGHT+IEuD6oVNFdoCcKagugA75LHNebXvR8cOgEl3UMPjRhdvNPJVp574cFB+Bbnvq6T7+AbQgvIlg==
X-Received: by 2002:a17:907:970a:b0:afe:d3b2:8b1e with SMTP id a640c23a62f3a-b01d9743cffmr421146366b.38.1756633186146;
        Sun, 31 Aug 2025 02:39:46 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:45 -0700 (PDT)
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
Subject: [PATCH v2 11/12] include/mm.h: add `const` to lots of pointer parameters
Date: Sun, 31 Aug 2025 11:39:17 +0200
Message-ID: <20250831093918.2815332-12-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8B69440009
X-Stat-Signature: io75c7cctr33z5t7xhf9wzcxz5auf9zn
X-Rspam-User: 
X-HE-Tag: 1756633187-768539
X-HE-Meta: U2FsdGVkX1/41wtNpzz2JXwzakowUlRQcueapoqVH0FqfC4WJ7BxnSiDwRbxLXOg5yeh9rvgamfvazcGp0QQ1he9bZ49teEIVHDYnwuwFj8lWb3tycRUxTz00ta3lJImZQv+nxKvaG+mGmHzP/43a2+xlDjXcb6xRgeeXYl+DBHzB+3qpdLpmXCoCweKR8wBAY4n8Dv5KwAUZvH2eghJUBshLeVw4VYOK86wFKTCN6CTaAISq9idkcT7fSL6Jepg3gillHazhdNMeZ2+r0kgtAMGYNUygtkWoQkDoIKxOXIYXGUTsy0QG7unGvt4F9o18Bd5nLQXPS25jj0zSf1Y9HKAeMld9FXJ0fT7LOY4yRRO2PiQLAZEK5k/eEeZnLmlB6flxKYuZsVC3h+zABXje3YTd9Bj5hFw7UF2Gb8XGrabIsG5B236CpLgdC/vHFe0M+MEC++RDDPIOuNfknbuyBhCp8gVMAY0G7KWUuQMcRdFqjgTBXWQ79LX7a4ugtlnTEBiujDeVFtCuFeXgPYiBPL4yDrkakJQSoJtqWQ09F47Keo4JC7yUDbhOAW9pDOr2wpwjeuSOEpjoBDm9fOas2LuK29uNQpl5cZ7mBVZOu++4aFfcs775HR0a+kbGb+3DN6xOwGSlze5ku0peCJvpl/cHsqS76YzelS6XOmnmTzX1To0793rh3EXoLdJjN3a2w2D9jPWp80UkYwwuwWRAW778TsPKMdZV3JmuRDH6inmrGScMZYO1sTMo/LQ6calhmBdQRi54sX2bDFpJhIdj7Awfsep2TKIW1qqC+rCSnQZIy/vlEEkjZEryYex5rMVhs18/fgWilb/TuxrOt0HZvvBoCZT1J7u12rShmgK9JK9+oWoV7kANK0OP4GftyEhn6ABOcM+xLqfa2r8YlUQrGiGmrLLK7ZIk3HwIMl+mmO4ztQqtYnlEWJAu0El4nAJRqgKjUgOvDwYAe3cyrE
 T9i6qCzF
 wRcpMfjrPk02aWes4GaDfgWMJO+kgFGqBYViRSs4DV4PI6mp4+zzysSvi/oUO46ZGcnJ9gfRVAIUCpn4D2tdeMuhXuYceLEnoGyeDJYeYIULKXrNemXltlluAQqgPy2iL9Y4yye/SSnKmK0kDEKcZaC263xSMvALTOOmRMOg2F/Z/CElfT5z3xl3ipw8pStBQcDKD7SfqaiweIooTtxMWVSUdqvK8UhvY0x5MHOjb2frA2UaRK5lT8v+VQJy+5JYVxmXJOW7aVm1vh6oMQ4v9q9DgdY+KG5st8c7InswVF3OZXIQNnbJsm6k3ziFtwknXcCW9d/aunlOC/kDjB75xVYpWAHtq0kFmtCPfk7OflRT3lzBKyuS954/Yuav4w5MDtrj2Ys7i8CpW2vSlNEFJni9d57F0Qv38X0ofjmm77vldFM4z03f3vkmgovlQlzHDZqLU
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
 include/linux/mm.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d12550ae9814..7c8b7f6a14fb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -703,7 +703,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
 		mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(struct vm_fault *const vmf)
 {
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK)
 		vma_assert_locked(vmf->vma);
@@ -716,7 +716,7 @@ static inline void release_fault_lock(struct vm_fault *vmf)
 	mmap_read_unlock(vmf->vma->vm_mm);
 }
 
-static inline void assert_fault_locked(struct vm_fault *vmf)
+static inline void assert_fault_locked(const struct vm_fault *vmf)
 {
 	mmap_assert_locked(vmf->vma->vm_mm);
 }
@@ -859,7 +859,7 @@ static inline bool vma_is_initial_stack(const struct vm_area_struct *vma)
 		vma->vm_end >= vma->vm_mm->start_stack;
 }
 
-static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
+static inline bool vma_is_temporary_stack(const struct vm_area_struct *const vma)
 {
 	int maybe_stack = vma->vm_flags & (VM_GROWSDOWN | VM_GROWSUP);
 
@@ -873,7 +873,7 @@ static inline bool vma_is_temporary_stack(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool vma_is_foreign(struct vm_area_struct *vma)
+static inline bool vma_is_foreign(const struct vm_area_struct *const vma)
 {
 	if (!current->mm)
 		return true;
@@ -884,7 +884,7 @@ static inline bool vma_is_foreign(struct vm_area_struct *vma)
 	return false;
 }
 
-static inline bool vma_is_accessible(struct vm_area_struct *vma)
+static inline bool vma_is_accessible(const struct vm_area_struct *const vma)
 {
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
@@ -895,7 +895,7 @@ static inline bool is_shared_maywrite(vm_flags_t vm_flags)
 		(VM_SHARED | VM_MAYWRITE);
 }
 
-static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+static inline bool vma_is_shared_maywrite(const struct vm_area_struct *const vma)
 {
 	return is_shared_maywrite(vma->vm_flags);
 }
@@ -3488,7 +3488,7 @@ struct vm_area_struct *vma_lookup(struct mm_struct *mm, unsigned long addr)
 	return mtree_load(&mm->mm_mt, addr);
 }
 
-static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
+static inline unsigned long stack_guard_start_gap(const struct vm_area_struct *const vma)
 {
 	if (vma->vm_flags & VM_GROWSDOWN)
 		return stack_guard_gap;
@@ -3500,7 +3500,7 @@ static inline unsigned long stack_guard_start_gap(struct vm_area_struct *vma)
 	return 0;
 }
 
-static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_start_gap(const struct vm_area_struct *const vma)
 {
 	unsigned long gap = stack_guard_start_gap(vma);
 	unsigned long vm_start = vma->vm_start;
@@ -3511,7 +3511,7 @@ static inline unsigned long vm_start_gap(struct vm_area_struct *vma)
 	return vm_start;
 }
 
-static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
+static inline unsigned long vm_end_gap(const struct vm_area_struct *const vma)
 {
 	unsigned long vm_end = vma->vm_end;
 
@@ -3523,7 +3523,7 @@ static inline unsigned long vm_end_gap(struct vm_area_struct *vma)
 	return vm_end;
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
+static inline unsigned long vma_pages(const struct vm_area_struct *const vma)
 {
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
@@ -3540,7 +3540,7 @@ static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 	return vma;
 }
 
-static inline bool range_in_vma(struct vm_area_struct *vma,
+static inline bool range_in_vma(const struct vm_area_struct *const vma,
 				unsigned long start, unsigned long end)
 {
 	return (vma && vma->vm_start <= start && end <= vma->vm_end);
@@ -3656,7 +3656,7 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
  * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
  * a (NUMA hinting) fault is required.
  */
-static inline bool gup_can_follow_protnone(struct vm_area_struct *vma,
+static inline bool gup_can_follow_protnone(const struct vm_area_struct *const vma,
 					   unsigned int flags)
 {
 	/*
@@ -3786,7 +3786,7 @@ static inline bool debug_guardpage_enabled(void)
 	return static_branch_unlikely(&_debug_guardpage_enabled);
 }
 
-static inline bool page_is_guard(struct page *page)
+static inline bool page_is_guard(const struct page *const page)
 {
 	if (!debug_guardpage_enabled())
 		return false;
@@ -3817,7 +3817,7 @@ static inline void debug_pagealloc_map_pages(struct page *page, int numpages) {}
 static inline void debug_pagealloc_unmap_pages(struct page *page, int numpages) {}
 static inline unsigned int debug_guardpage_minorder(void) { return 0; }
 static inline bool debug_guardpage_enabled(void) { return false; }
-static inline bool page_is_guard(struct page *page) { return false; }
+static inline bool page_is_guard(const struct page *const page) { return false; }
 static inline bool set_page_guard(struct zone *zone, struct page *page,
 			unsigned int order) { return false; }
 static inline void clear_page_guard(struct zone *zone, struct page *page,
@@ -3899,7 +3899,7 @@ void vmemmap_free(unsigned long start, unsigned long end,
 #endif
 
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
 {
 	/* number of pfns from base where pfn_to_page() is valid */
 	if (altmap)
@@ -3913,7 +3913,7 @@ static inline void vmem_altmap_free(struct vmem_altmap *altmap,
 	altmap->alloc -= nr_pfns;
 }
 #else
-static inline unsigned long vmem_altmap_offset(struct vmem_altmap *altmap)
+static inline unsigned long vmem_altmap_offset(const struct vmem_altmap *altmap)
 {
 	return 0;
 }
-- 
2.47.2


