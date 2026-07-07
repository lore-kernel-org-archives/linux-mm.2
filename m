Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 315D4C43602
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE30A6B009D; Tue,  7 Jul 2026 08:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAC16B009E; Tue,  7 Jul 2026 08:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0EA6B009F; Tue,  7 Jul 2026 08:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A7BE96B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:46:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 432A14043B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:46:33 +0000 (UTC)
X-FDA: 84961954266.09.29BFCFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B171F16000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:46:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rjy0cnLi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783428391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ewdqf09/9A0MElDORLS07X9p5VzrfDnnvCn9V/hQNQs=;
	b=WcYqss6YwuAz3DrlAn2bHcJFkYrvkErogqEIlCuYdSnEm7kd9wsqaDHrk6EoJZvTOz/R/5
	mpcLluyyoypAe9zkV0OCmk0Vy45CjslG0T/rmqb7owJ7N+nZL7MivsA4G+aAKfA17mpOuH
	weeCr0zhauCK+2a1pDVwqL13NA75xJ0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rjy0cnLi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783428391;
	b=SQF3GZkfP/NgeedC2FvdGdQTetZ0SG9gw6Ty/31s+7eXVyJRNraYBwh2tyjzshl8R3YyjA
	W4nto8TykJaxhZRBtYRkVFYdgVE2+iMjhqbOUGGPLk2Zeih7l+bt8H1eq/FKpYAqcDepa/
	8p8cpIdbUIY7dPOolT64SBIpFMVHQT0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0FAEB60018;
	Tue,  7 Jul 2026 12:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD181F000E9;
	Tue,  7 Jul 2026 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783428390;
	bh=Ewdqf09/9A0MElDORLS07X9p5VzrfDnnvCn9V/hQNQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rjy0cnLisBi/mSGas37kSJEpI9VAejdyGuMOsAFnwpaMXWu6H9/WK70LPa1xkEoKZ
	 4b6kCyS0M3vkqr2+GfByl/DG/qJUwgrvZlSpddhx1d6XbaO2a551L70HBpSZG03924
	 pmeYYxEJs5qEqpzeMi1gJeqnHo3hpAnUwN1v3HYDCT4BxPgtzCDOoPmnYneUd4hK8c
	 ryoIxcYXyJ0usBMe8qWST91pCaeYMq239IlRiwqiMdF5BtY+s3ruk4KM+ytwM8pxy1
	 cIu5giQhHvAzfe2yXvCGJ7/SWBx06xdh7lOYWHnBbh+m4HIxyvbotZ3iPD/E47iLyU
	 eGiVf2Ev5yJSA==
Date: Tue, 7 Jul 2026 13:46:19 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: xiqi2@huawei.com, akpm@linux-foundation.org, linux@armlinux.org.uk, 
	david@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, linusw@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sunnanyong@huawei.com, 
	linux-mm@kvack.org, lilinjie8@huawei.com, liaohua4@huawei.com
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
Message-ID: <akzgsZi6aKCFWg_U@lucifer>
References: <20260626073048.3595106-2-xiqi2@huawei.com>
 <20260706133247.145485-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706133247.145485-1-xieyuanbin1@huawei.com>
X-Rspamd-Queue-Id: B171F16000E
X-Stat-Signature: zn85opyydg49nqa6qkd9naahbahsmn8r
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783428391-551776
X-HE-Meta: U2FsdGVkX1/+3POsVJoTbtyNhvMyCcuAl03Op7SC55UnIKWhu977qYR7CvpkH4LoVNVCNWHWz/gVX1kkplLZ1TIeF8th0bVXjsVL2n2my9ELvs1788RwEuunOs/HWdyWFeH2AWjfGBiATBRMeFVf6WNuMCez/oXuZLIlGavqO4TKXQp8UVC30drdeVYNusNeSPl+PHB06qD6yCcwnfJBVyS1UrocGjAqfDoAiA5jyR4p9JgJ03SvtYpRXClh7HU5SDdegLhJEyDG1n2y8ltXwiNc8YGRqJJnKKEki0/Xs21jpYpMrJduq2heV8Ug2KygOYTLCMtI/lmCD/EcAVADBEb2w8VBlwEf/+Gj8AYMMfJe7i0h6rG+HX4Kz7g+wYC4sRnv0whEwPhOf85bzWnf4LuufW3mUdjlCI3OZx/9Jhzvu65c0zP5DYnwIeCF6hktfnQYkpYRI85Wh42DRfx9Il7LmNFPbszd4mdUQCJyxL7la4sU2VU97h4xd6tpCXMy2WPbENRs9JgnSjD1NpzhGI9trqGUuGzaLt/NmXqdRm01qzTQ23sxlidj5xUoGbxbjHrUokhKawxraXxOWWGjUJzMqZHcxeX5d4xoDBdfamRYMotJPb7tpjPo0UTr4TjUkuEUE4f80SfyXjg5f3P1T30HNPgIOttwTBcm3lidZK5rQZja1uGf1mjxz+o33/YduNtR3w5S/wLUd5go8g6tK2GS5PpqbrYKs1Va2uCEV3JZwH/CDwbndFmQDwh58pV9OwGGlcAVLNENBpFRz+Rfotnlcgc5myhEVJSs/kJWaU74iS224cd5WO/ZBJCuGqhlitGBmeqwuvkSr9mJmQQpgVGrr3Mt1JmFbhsXkZTidx6B00ouaMMPnOtjTSHyOvi1ZYEdqFwzqKFRHDPKghizcbPLVRXT18czB8FxbR3NAPtqvfZDVvhez4oGrlSRlK3SvWg+N5YXG4yuKTmC7yl
 0jy8Sahg
 u6hJobgPrXvR7m7sCqOwMD05cbaeb15dSqPrAsSHbzmp9XZiIlPiLdOMIqWgXU8iGkzqeswBolBnLoY03/wiN8sEOv9TvsIpU3/rV0YuZBALkBXM+01pIoLuUPx/UND671jVCLXnWrkCc7lQouhOD+Kea4xP6vqauDBYAxMvrcSO7ZwpF9QOP7vYO5aS1TPeuSe046J3it+CzUjFtHABaFVLIYKOtmV5q8JNzrYWp6V6biJuJt7e8JAfAxA2ZZSkRfGdr7lP44iz3/sqjUsDTp1PSJhLvkNb8eukJz/M80wG1ywRMkrHldIzUNPKPELuIHnug2+ztXq7eGVgmBdAtATzoPX17P/eEl+TXM00R3nad7DALxsEi+8M4Ut4tP/3+eKoHmxIOCC6mx7kDWPWStq9RCPdJyUaoQK8N6T9oZuqq9pEoWI1vAKieGAwBw8RnBXlP9ByZ2p6oNtAnwiOmNJjKo/TP6Wxb+Q2g2+aPLKDKB0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 06, 2026 at 09:32:47PM +0800, Xie Yuanbin wrote:
> On Fri, 26 Jun 2026 15:30:47 +0800, Qi Xi wrote:
> > @@ -181,7 +181,9 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
> >  		pr_err("8<--- cut here ---\n");
> >  		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
> >  		       tsk->comm, sig, addr, fsr);
> > +		mmap_read_lock(tsk->mm);
> >  		show_pte(KERN_ERR, tsk->mm, addr);
> > +		mmap_read_unlock(tsk->mm);
> >  		show_regs(regs);
> >  	}
> >  #endif
>
> I found that this fix does not completely solve the problem. For a user
> fault, the addr could also be a kernel address. For arm32/x86, the kernel
> address space and user address space share the same pgd page table,
> but the kernel address space's page table is not protected by
> current->mm->mmap_lock.
>
> I have written a use case to construct and verify this point. When A user
> program accesses a kernel address and triggers __do_user_fault(),
> show_pte() will directly print the kernel page table.
>
> So, I suggest that:
> ```c
> 	if (user_mode(regs)) {
> 		struct mm_struct *const pt_mm = addr >= TASK_SIZE ?
> 			&init_mm : current->mm;
>
> 		mmap_read_lock(pt_mm);
> 		show_pte(KERN_ALERT, pt_mm, addr);
> 		mmap_read_unlock(pt_mm);
> 	} else {
> 		// .. keep nothing change
> 		show_pte(KERN_ALERT, current->mm, addr);
> 	}
> ```
>
> I have read this article:
> Link: https://docs.kernel.org/mm/process_addrs.html
> `mmap_read_lock(&init_mm)` should be able to ensure that the kernel
> address's page tables can be traversed. But I'm not quite sure if

I added a section specifically about this -

https://docs.kernel.org/mm/process_addrs.html#traversing-non-vma-page-tables

But note:

"Since, aside from vmalloc and memory hot plug, kernel page tables are not torn
down all that often - this usually suffices, however any caller of this
functionality must ensure that any additionally required locks are acquired in
advance."

With the latter part being particularly important - you really need to be sure
you aren't going to be raced on page table teardown by anything.

However:

	* You're safe from vmalloc trying to install a huge page table (only way
	  it removes intermediate page tables) since !HAVE_ARCH_HUGE_VMAP.

	* And since arm32 !ARCH_ENABLE_MEMORY_HOTPLUG you're safe from that too
          :)

(Really I think you should be using walk_page_range_debug() here ultimately but
that's a future refactor).

BUT see below:

> `mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
> addresses?

OK so this _does_ need addressing, and I covered it in the document:

	We also permit a truly unusual case is the traversal of non-VMA ranges
	in userland ranges, as provided for by walk_page_range_debug().

	We must take great care in this case, as the munmap() implementation
	detaches VMAs under an mmap write lock before tearing down page tables
	under a downgraded mmap read lock.

	This means such an operation could race with this, and thus an mmap
	write lock is required.

I.e. you need a write lock.

So in conclusion the patch should be:

diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
index e62cc4be5a..1f2a85e1fa 100644
--- a/arch/arm/mm/fault.c
+++ b/arch/arm/mm/fault.c
@@ -181,7 +181,9 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
 		pr_err("8<--- cut here ---\n");
 		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
 		       tsk->comm, sig, addr, fsr);
+		mmap_write_lock(tsk->mm);
 		show_pte(KERN_ERR, tsk->mm, addr);
+		mmap_write_unlock(tsk->mm);
 		show_regs(regs);
 	}
 #endif

>
> Also cc to mm maintainers:
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Linus Walleij <linusw@kernel.org>

Thanks :)

Cheers, Lorenzo

