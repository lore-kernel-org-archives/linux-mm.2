Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50973EC1EA7
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 11:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59C66B0089; Thu,  5 Feb 2026 06:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24456B0092; Thu,  5 Feb 2026 06:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27076B0093; Thu,  5 Feb 2026 06:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF416B0089
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 06:57:17 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EDD51C39B
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:57:17 +0000 (UTC)
X-FDA: 84410252514.08.04C0DFE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A1DB94000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 11:57:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RnILbkFh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770292635; a=rsa-sha256;
	cv=none;
	b=I8ruD0yHSzq4RAN0MpCEr4gL0N/yntkclOJjxpEqLhdBNHsYR6SKd85j2Efrp31ZxNxs84
	bVRj/mPAnw83Fxwqi6OHC9TqOZOKS5MB8H6rwN3uuAr/ucmfGiwtEg4ixvt+/gcozd+Uei
	DJmzuIZ3KV6S1L8qRjSMm+t/CDun1ck=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RnILbkFh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770292635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VIYqTm6n65asiFSN3oWcVV517iDOrfBqZk3xsr17geg=;
	b=svj3lX7Swl+qqnJaKto6hRmSGVvD+EFE7gjLcQwxH9UfodJmKEgTir9u/VNw8d4nbzcwZE
	T07ZKkvsASrrMgfZskH3ZDSxKBKg8g0r/TpWCIDe2yprzGe/qv0a6pUcJ4RjuvgwIDpwyw
	RC1VyTBwkxHyrB0W7xIlZkeRyJdIWv8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9572660129;
	Thu,  5 Feb 2026 11:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F887C4CEF7;
	Thu,  5 Feb 2026 11:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770292634;
	bh=DguZDlWLWr8gBzpI5v+sNa53zJp0emvM6ED3g0V30eA=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=RnILbkFhe9J8jDu+iWhtbRqGytBrwBvVK4SDnatGYG4lu+On62wQ90h37szLQy+e3
	 IImIQUCBFCy0dKUZW+J7XTsfaNNwJ81h9x0Rg0AZLfsH9nuhj4NtNvX2Et3glYQHlt
	 i/qN0rdl7mXMhnIlTiN1yfFpqRE9f8qCdBG7OaBqhzebC0IWHN3y9qhZi2f9FoPCYh
	 ZtKJQdow2v/78XmUU/8U+F+4JYZvBPjfA/29vqOIcVpLLvpfKRKqTaGo9tkkC+cmPH
	 Wc1LFEjjEXrqFX2bcVAz5BGau0pg+Cbxt1z9GDvsUXh9SeKqfZOtN7vQsC+SZ2ksgl
	 GrQ+4ZyPuZO0A==
Message-ID: <d122f9be-48d6-40b1-9da8-cec445bd8daf@kernel.org>
Date: Thu, 5 Feb 2026 12:57:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: export zap_page_range_single and list_lru_add/del
From: "David Hildenbrand (arm)" <david@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alice Ryhl <aliceryhl@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Carlos Llamas <cmllamas@google.com>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Paul Moore <paul@paul-moore.com>,
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>, =?UTF-8?Q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>,
 Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>, kernel-team@android.com,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-mm@kvack.org,
 rust-for-linux@vger.kernel.org
References: <20260205-binder-tristate-v1-0-dfc947c35d35@google.com>
 <20260205-binder-tristate-v1-3-dfc947c35d35@google.com>
 <02801464-f4cb-4e38-8269-f8b9cf0a5965@lucifer.local>
 <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <21d90844-1cb1-46ab-a2bb-62f2478b7dfb@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A1DB94000E
X-Stat-Signature: njrmjyi5u1ucoh541johh99frhintkcg
X-HE-Tag: 1770292635-827321
X-HE-Meta: U2FsdGVkX1+7TKk/dFxycdwxl/dTSY3IWeYwU4UEwUZvB86KT0mFrR/HZhIkwkUo6Si+3N2GLTEbfUA+9cBAZobMRPYjJayf06wOaWAidBGKXL7aYgblsu946zUCpdC66C7VzFYYeX4Tf0QK/4t19/orvQKuOLl75N2V6YBmJU6KE9HEorxNdrRHJajMdTTU3J7r8o5OT+cybnycQDpqyWEZhcPdD26Owgd10/eEbAVCdZlPeikczZVCgLex/OnN13tYJUcN9a60qreb+zEzpUlcC9simgGOWZ/yPA92c3aXt7avOwKMo+zRQqKfChr2mjnBZs3Q7kD6DqPT+9S21OnwacjV8SKrwYhEsFBrlaKBcTRwZ7QhlPDbPmGzsbXHJLB4kwT1GefmkDI8aIp1Dp1sfLGDEfWArxE5in276lFRsTpmveBxFxqn0zvego9wEbTgU9izIf8GDPJ7e4LstQD8nnVlO9H5jt/ANcKn7bZi6eksRLvf0DtuIpyrhcuxsoUApZtRgMTYs4EPVpuhYFfCyIWLm2NspdttNX5OBJB8k35hCYR1ADpakrgYgMaCbM2eORMUS10bcs6/VQPfZ0mW2ZcqvGW+WNT0644KHkfMyB9d3V8RcDRryOVk4DmndXxz7cC/3Iid4YUZhlduZIZoI3M9CTfyK1m5fvqvjrshKyf5R3Fjq2RJm+8oggRVXPq0xalHArMLxV06lZuAxfUiMnrcAZY1A4wXtIn8LjK7VVoe6sNtMWvS1ufN1C1UH7hmZujMghdk7WndQm9VVaUaIX/50hOEMjEbXIbyXjtGnvvAHtoSZcL9HiWLbwmjvp4A8JlloWviYZnZ+y3XevOSzZuZUaAAuBGImPXKymVKQR1RID6RVxqXwIFNW05Ruser7t/whvzt2NUP7B5hm+Z2IGKcBACb1RiAtyML1YY9cZFnHrLztKLcBHN342QCvDJ+yhsBGXwNU+85PZo
 jb2U8Ca9
 ZUqBfE8dSaf+/pWIKkO5GRY3rrSTmO7MiIDLYPiTpoFSnbslFXRsPj6nQMmbaWQeQiyKl2/G6yjyde3RIXAnvN8LYSYKQlokV8pS0ULGVdw4ynyV0/WfNtP7118W+57y3EgYzS8z8Kjtl44PLm0HUjCgSihECqendeniViqGhbQhBG1WxFSOtbaXe8NPeTIn/u9o4v6PamRbiUXsfqOd6Ya2c/RhspD6JbTbTT3qg5mAGZi9ICwnzgLh4GHvHpAVk5yxTSWx8XwscOFq0PuSl+wWTgNFmz5RDrxdYpcnK+ZQRkVIYB21kqRW/co0v0Md2LLSbBP+QwhB8wjl13OqSxcB52Uq3nlEWOzWp1syYzGrSDMpKYtekKGSNqJexo3/bUCMyuP1FXDmEWcbV2lvy7rEY1u78D84MiLL8QpreQiVX+c7hIlmK4pm6QWxVaHPvxg+d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 12:43, David Hildenbrand (arm) wrote:
> On 2/5/26 12:29, Lorenzo Stoakes wrote:
>> On Thu, Feb 05, 2026 at 10:51:28AM +0000, Alice Ryhl wrote:
>>> These are the functions needed by Binder's shrinker.
>>>
>>> Binder uses zap_page_range_single in the shrinker path to remove an
>>> unused page from the mmap'd region. Note that pages are only removed
>>> from the mmap'd region lazily when shrinker asks for it.
>>>
>>> Binder uses list_lru_add/del to keep track of the shrinker lru list, and
>>> it can't use _obj because the list head is not stored inline in the page
>>> actually being lru freed, so page_to_nid(virt_to_page(item)) on the list
>>> head computes the nid of the wrong page.
>>>
>>> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
>>> ---
>>>   mm/list_lru.c | 2 ++
>>>   mm/memory.c   | 1 +
>>>   2 files changed, 3 insertions(+)
>>>
>>> diff --git a/mm/list_lru.c b/mm/list_lru.c
>>> index 
>>> ec48b5dadf519a5296ac14cda035c067f9e448f8..bf95d73c9815548a19db6345f856cee9baad22e3 100644
>>> --- a/mm/list_lru.c
>>> +++ b/mm/list_lru.c
>>> @@ -179,6 +179,7 @@ bool list_lru_add(struct list_lru *lru, struct 
>>> list_head *item, int nid,
>>>       unlock_list_lru(l, false);
>>>       return false;
>>>   }
>>> +EXPORT_SYMBOL_GPL(list_lru_add);
>>>
>>>   bool list_lru_add_obj(struct list_lru *lru, struct list_head *item)
>>>   {
>>> @@ -216,6 +217,7 @@ bool list_lru_del(struct list_lru *lru, struct 
>>> list_head *item, int nid,
>>>       unlock_list_lru(l, false);
>>>       return false;
>>>   }
>>> +EXPORT_SYMBOL_GPL(list_lru_del);
>>
>> Same point as before about exporting symbols, but given the _obj 
>> variants are
>> exported already this one is more valid.
>>
>>>
>>>   bool list_lru_del_obj(struct list_lru *lru, struct list_head *item)
>>>   {
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 
>>> da360a6eb8a48e29293430d0c577fb4b6ec58099..64083ace239a2caf58e1645dd5d91a41d61492c4 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -2168,6 +2168,7 @@ void zap_page_range_single(struct 
>>> vm_area_struct *vma, unsigned long address,
>>>       zap_page_range_single_batched(&tlb, vma, address, size, details);
>>>       tlb_finish_mmu(&tlb);
>>>   }
>>> +EXPORT_SYMBOL(zap_page_range_single);
>>
>> Sorry but I don't want this exported at all.
>>
>> This is an internal implementation detail which allows fine-grained 
>> control of
>> behaviour via struct zap_details (which binder doesn't use, of course :)
> 
> I don't expect anybody to set zap_details, but yeah, it could be abused.
> It could be abused right now from anywhere else in the kernel
> where we don't build as a module :)
> 
> Apparently we export a similar function in rust where we just removed 
> the last parameter.
> 
> I think zap_page_range_single() is only called with non-NULL from mm/ 
> memory.c.
> 
> So the following makes likely sense even outside of the context of this 
> series:

The following should compile :)

 From b1c35afb1b819a42f4ec1119564b3b37cceb9968 Mon Sep 17 00:00:00 2001
From: "David Hildenbrand (arm)" <david@kernel.org>
Date: Thu, 5 Feb 2026 12:42:09 +0100
Subject: [PATCH] mm/memory: remove "zap_details" parameter from
  zap_page_range_single()

Nobody except memory.c should really set that parameter to non-NULL. So
let's just drop it and make unmap_mapping_range_vma() use
zap_page_range_single_batched() instead.

Signed-off-by: David Hildenbrand (arm) <david@kernel.org>
---
  arch/s390/mm/gmap_helpers.c    |  2 +-
  drivers/android/binder_alloc.c |  2 +-
  include/linux/mm.h             |  5 ++---
  kernel/bpf/arena.c             |  3 +--
  kernel/events/core.c           |  2 +-
  mm/madvise.c                   |  3 +--
  mm/memory.c                    | 16 ++++++++++------
  net/ipv4/tcp.c                 |  5 ++---
  rust/kernel/mm/virt.rs         |  2 +-
  9 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index d41b19925a5a..859f5570c3dc 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -102,7 +102,7 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
  		if (!vma)
  			return;
  		if (!is_vm_hugetlb_page(vma))
-			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr, NULL);
+			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr);
  		vmaddr = vma->vm_end;
  	}
  }
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 979c96b74cad..b0201bc6893a 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -1186,7 +1186,7 @@ enum lru_status binder_alloc_free_page(struct list_head *item,
  	if (vma) {
  		trace_binder_unmap_user_start(alloc, index);
  
-		zap_page_range_single(vma, page_addr, PAGE_SIZE, NULL);
+		zap_page_range_single(vma, page_addr, PAGE_SIZE);
  
  		trace_binder_unmap_user_end(alloc, index);
  	}
diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc736..5764991546bb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2621,11 +2621,10 @@ struct page *vm_normal_page_pud(struct vm_area_struct *vma, unsigned long addr,
  void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
  		  unsigned long size);
  void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
-			   unsigned long size, struct zap_details *details);
+			   unsigned long size);
  static inline void zap_vma_pages(struct vm_area_struct *vma)
  {
-	zap_page_range_single(vma, vma->vm_start,
-			      vma->vm_end - vma->vm_start, NULL);
+	zap_page_range_single(vma, vma->vm_start, vma->vm_end - vma->vm_start);
  }
  void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
  		struct vm_area_struct *start_vma, unsigned long start,
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index 872dc0e41c65..242c931d3740 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -503,8 +503,7 @@ static void zap_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
  	struct vma_list *vml;
  
  	list_for_each_entry(vml, &arena->vma_list, head)
-		zap_page_range_single(vml->vma, uaddr,
-				      PAGE_SIZE * page_cnt, NULL);
+		zap_page_range_single(vml->vma, uaddr, PAGE_SIZE * page_cnt);
  }
  
  static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt)
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 8cca80094624..1dfb33c39c2f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6926,7 +6926,7 @@ static int map_range(struct perf_buffer *rb, struct vm_area_struct *vma)
  #ifdef CONFIG_MMU
  	/* Clear any partial mappings on error. */
  	if (err)
-		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE, NULL);
+		zap_page_range_single(vma, vma->vm_start, nr_pages * PAGE_SIZE);
  #endif
  
  	return err;
diff --git a/mm/madvise.c b/mm/madvise.c
index b617b1be0f53..abcbfd1f0662 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1200,8 +1200,7 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
  		 * OK some of the range have non-guard pages mapped, zap
  		 * them. This leaves existing guard pages in place.
  		 */
-		zap_page_range_single(vma, range->start,
-				range->end - range->start, NULL);
+		zap_page_range_single(vma, range->start, range->end - range->start);
  	}
  
  	/*
diff --git a/mm/memory.c b/mm/memory.c
index da360a6eb8a4..82985da5f7e6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2155,17 +2155,16 @@ void zap_page_range_single_batched(struct mmu_gather *tlb,
   * @vma: vm_area_struct holding the applicable pages
   * @address: starting address of pages to zap
   * @size: number of bytes to zap
- * @details: details of shared cache invalidation
   *
   * The range must fit into one VMA.
   */
  void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
-		unsigned long size, struct zap_details *details)
+		unsigned long size)
  {
  	struct mmu_gather tlb;
  
  	tlb_gather_mmu(&tlb, vma->vm_mm);
-	zap_page_range_single_batched(&tlb, vma, address, size, details);
+	zap_page_range_single_batched(&tlb, vma, address, size, NULL);
  	tlb_finish_mmu(&tlb);
  }
  
@@ -2187,7 +2186,7 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
  	    		!(vma->vm_flags & VM_PFNMAP))
  		return;
  
-	zap_page_range_single(vma, address, size, NULL);
+	zap_page_range_single(vma, address, size);
  }
  EXPORT_SYMBOL_GPL(zap_vma_ptes);
  
@@ -2963,7 +2962,7 @@ static int remap_pfn_range_notrack(struct vm_area_struct *vma, unsigned long add
  	 * maintain page reference counts, and callers may free
  	 * pages due to the error. So zap it early.
  	 */
-	zap_page_range_single(vma, addr, size, NULL);
+	zap_page_range_single(vma, addr, size);
  	return error;
  }
  
@@ -4187,7 +4186,12 @@ static void unmap_mapping_range_vma(struct vm_area_struct *vma,
  		unsigned long start_addr, unsigned long end_addr,
  		struct zap_details *details)
  {
-	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
+	struct mmu_gather tlb;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	zap_page_range_single_batched(&tlb, vma, start_addr,
+				      end_addr - start_addr, details);
+	tlb_finish_mmu(&tlb);
  }
  
  static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d5319ebe2452..9e92c71389f3 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2052,7 +2052,7 @@ static int tcp_zerocopy_vm_insert_batch_error(struct vm_area_struct *vma,
  		maybe_zap_len = total_bytes_to_map -  /* All bytes to map */
  				*length + /* Mapped or pending */
  				(pages_remaining * PAGE_SIZE); /* Failed map. */
-		zap_page_range_single(vma, *address, maybe_zap_len, NULL);
+		zap_page_range_single(vma, *address, maybe_zap_len);
  		err = 0;
  	}
  
@@ -2217,8 +2217,7 @@ static int tcp_zerocopy_receive(struct sock *sk,
  	total_bytes_to_map = avail_len & ~(PAGE_SIZE - 1);
  	if (total_bytes_to_map) {
  		if (!(zc->flags & TCP_RECEIVE_ZEROCOPY_FLAG_TLB_CLEAN_HINT))
-			zap_page_range_single(vma, address, total_bytes_to_map,
-					      NULL);
+			zap_page_range_single(vma, address, total_bytes_to_map);
  		zc->length = total_bytes_to_map;
  		zc->recv_skip_hint = 0;
  	} else {
diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index da21d65ccd20..b8e59e4420f3 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
          // sufficient for this method call. This method has no requirements on the vma flags. The
          // address range is checked to be within the vma.
          unsafe {
-            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
+            bindings::zap_page_range_single(self.as_ptr(), address, size)
          };
      }
  
-- 
2.43.0


-- 
Cheers,

David

