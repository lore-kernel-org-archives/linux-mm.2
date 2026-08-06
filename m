Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD8B6C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912796B0092; Thu,  6 Aug 2026 10:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAC76B0093; Thu,  6 Aug 2026 10:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 826C66B0096; Thu,  6 Aug 2026 10:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 528376B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:13:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D30881A0789
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:13:53 +0000 (UTC)
X-FDA: 85071038346.12.F64C8B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 248D540008
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:13:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8v1pNGM;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786025632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GUMeeKsz24PpxZAbkO6Pk82CWiUyq2afca9g6wm5yyI=;
	b=TBFEiEn0tIicERXo7zCbKvSAKDmCxbiv+Cx7AUY91iEKxiu+VJzc3lD8XihKInclx1jJbW
	rjjOCXOh3pEQsiNAXJPft3cpN6p6OFgArZNEpcDKaqjnms9lIxQbDt1r/WQJ+IJk6k0bGT
	h6E9zlch9BbaBjzhRseLWzsuGnxbbQ0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H8v1pNGM;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786025632;
	b=8juMXYfq6m7fQA4dm+n1kpLsPtpWpUMKc+oDUxLsKtNtMoL9Ht+0/jJUnxhcelgOZwa1nf
	XJQjPwnEiiOvKHOIkpT0k0GQJXHaVShe4w4cnaw/u+ajmAZzHgIRq5oC67xuL+tH7tFkgA
	Z/+6vqIeiYK/VijcOrc/znxzhGRSvMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5441441840;
	Thu,  6 Aug 2026 14:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113591F000E9;
	Thu,  6 Aug 2026 14:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786025631;
	bh=GUMeeKsz24PpxZAbkO6Pk82CWiUyq2afca9g6wm5yyI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H8v1pNGMRAtUFKh788pnMEkbQIpZ20rnktk9mYX9rjM1PoYcM8bc5YpWooSpPLAO1
	 00XbKpd1zEgr9tfMupjyO3SGhW8CQCbVNTn/PrWt7zArAv9lcqeauwSb4X5nWYAKRw
	 YxNuyjUxPI2GMkC1L04UmG0fAt59ErhzyQ8npl4BiU+/1ghYOxsfRf2NnGG+a9G64O
	 0/+N5OaIl4KeJo3qVnWIR745mF4z63xWJsaGSC5THmvIkoq0SyGBJ063mRzQ2LgkjN
	 7A7taiMkfLtg0K/ewHb0CXuarnzS++zadX4+8/xCg3t1B3A6uB2k8M41GRj7Wfsan0
	 P2WdzjY7JM+Ag==
Date: Thu, 6 Aug 2026 15:13:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sparkhuang <huangshaobo3@xiaomi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Kees Cook <kees@kernel.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] fork: reset pointer tag of vmapped thread stack before
 vfree
Message-ID: <anSVlVpUXrA8ra_z@lucifer>
References: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 248D540008
X-Stat-Signature: unhajp7ndh9juncx5i8aqeshtem5q1xp
X-HE-Tag: 1786025631-880619
X-HE-Meta: U2FsdGVkX1/dBxidMqeX8OYoNtcLcbX6D0DpCpJ4z8TGI95df80dr8JtBHR1zN24/g+gYNtllrlBK5CFDdO8lsG9Se0UfU2IHzHRcFBhNI+kzqRCAdn4/BXvpyqIY3s6pF83fYrgpSLYoaxrJX5D0UfzZUJOs1uYTwsWjM/BYGEOp801aJKys9CkaGq6nDvMamjnW8EOLwrW3DIFwzs1f+1q07ry2usDt1WHq1R64Vn5dThfY3EW1Q17RoxBEAJlU3J91AUyLQ7FOs9sBjwKUXAkoCT27BKWbO6QDrjo6mIXlJJxNU9Qpi4uFwKsZMWLuwffvn5A0HvWfCVPkOUDSQYki6kTg6CUGPxk1dGrWglahpjy9S6Q7Sy4h1+glNzHAXp/PCtydcyT9797JFEWVLqDyfDB5y6qDp2aDh1hHetqvyC7symq+pxLz+2yDyIqks0GrrKwHDeUqetioTOF0dOIsTSB6iUm9NmWLFcXyFX1qDNIsH+3D6FF754Tl2Uu5mL7q9wsP/+fmkxuo69N0/QSkmONomGMaMAKyfjbU3TDOfYARMFHrbhWgCZ4VEJRfE1iY8yQ7xyK1ZyNUs2s38pDBrz84YeAls+X+I2w7KM0hJcDsk3vJaLbjdZKdChhxlaCsDB7t0djNGLBpg2xVm7eKgwAk8bwdEK8gAxQzjCjBpnijVzpGBr3nUN01RLGyA8dyMTTqbz96cAov8B2HkUJb6Q0iulQL3F2sv++dqwqZdh+drcZow8O0unIPVLHGS6lTUMAfR+LJinccsXck4WJrakQHtxM870Rvw63AJjvXR2iRA0QgDUAqkTc6OkXOoQ9YUGkkWTv5Wj2cmUKSZ6wdxguVWnGR5h5mFl1bd0OSvCdHElxCxqKBw0FsZ1KjXcTxkLevMFRLbGv0m2k8OGXS7Hqp/Ax5GDx5Ac4pVq2CAHH3fEDmZtBLYQLD+bAKPX07xeU6q+/jnD2zjY
 pvT0FAuk
 BWtYR04wcx946NFLuuD0XKKxGz0zIPq9cj7LW9AUoktndrBGUgiHeJZJUV2DEoDFGA91PYe8IK7vgmeZ4b3zNn6g3zzSJTXGuyhMaXblWbrn8PVTG3Mq16Y/gUZiFEZrUAXgIjFxvjiOscBgGjG5ab2Jl5ShCbj8Mgo8nKxshuQ5B3jRg8PhNo+3gLbD8JO578D2UMikoaX12qZiAxOiUuOVO6euojjOSWm57aPgOLg7JLiIwgX+9GixJIAsgjVaRc6aQlKCizRDFImISG08zOlDPx2AR75F7JSQnKN9GIRUWcaQLkD7RayBxBAwLBW9EINzmOEPFk46dZ8lM0xB6Zbxa9Z9LMIctVMviYoyW0fskpoz3OFl3+gYuVHDChw0VRcFly/pPfOtlGxqIaMx4Xez4MAgIsFgJK0Qjkne4XE1NNfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This looks AI-generated but I see no Assisted-by tag, please follow kernel
procedure on this please.

https://docs.kernel.org/process/coding-assistants.html

None of your 4 patches pre-dating the slopularity look anything like this.

Also please use a real name.

On Thu, Aug 06, 2026 at 08:30:20PM +0800, sparkhuang wrote:
> When a thread stack is freed via RCU callback,
> thread_stack_free_rcu() calls vfree(vm_area->addr).  In RCU callback
> context (e.g. from rcu_nocb_cb_kthread with BH disabled, or from
> RCU_SOFTIRQ), in_interrupt() returns true, so vfree() routes to
> vfree_atomic().
>
> vfree_atomic() uses the freed memory as llist storage by calling
> llist_add((struct llist_node *)addr, &p->list), which writes 8 bytes
> to the address being freed.  With KASAN SW_TAGS enabled,
> vm_area->addr carries a random tag assigned during allocation by
> kasan_unpoison_vmalloc().  If the shadow memory covering this region
> has been set to KASAN_TAG_KERNEL (0xFF) — e.g. by
> kasan_unpoison_task_stack() using task->stack, which was already
> reset to 0xFF by kasan_reset_tag() at allocation time — the shadow
> byte (0xFF) no longer matches the pointer tag on vm_area->addr,
> and the write in llist_add triggers a KASAN invalid-access report:
>
>   ==================================================================
>   BUG: KASAN: invalid-access in vfree_atomic+0x90/0x150
>   Write of size 8 at addr c2ffffc0a8f70000 by task rcuop/7/75
>   Pointer tag: [c2], memory tag: [ff]
>
>   CPU: 5 UID: 0 PID: 75 Comm: rcuop/7 Tainted: G S      W  OE
>   Hardware name: XiaoMi Xring_o1 UDP PHONE (DT)
>   Call trace:
>    show_stack+0x18/0x28
>    __dump_stack+0x28/0x3c
>    dump_stack_lvl+0xac/0xf0
>    print_address_description+0x7c/0x25c
>    print_report+0x70/0x8c
>    kasan_report+0xdc/0x13c
>    __hwasan_store8_noabort+0xe8/0xf8
>    vfree_atomic+0x90/0x150
>    vfree+0x220/0x298
>    thread_stack_free_rcu+0x3c/0x4c
>    rcu_do_batch+0x308/0xaf0
>    rcu_nocb_cb_kthread+0x33c/0x708
>    kthread+0x364/0x3cc
>    ret_from_fork+0x10/0x20
>
>   The buggy address belongs to a 8-page vmalloc region starting at
>   0xc2ffffc0a8f70000 allocated at copy_process+0x1ac/0x12e4
>
>   Memory state around the buggy address:
>    ffffffc0a8f6ff00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>   >ffffffc0a8f70000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>                       ^
>    ffffffc0a8f70100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>   ==================================================================
>
> The tag on tsk->stack was already reset to KASAN_TAG_KERNEL (0xFF) by
> commit c08e6a1206e6 ("kasan, fork: reset pointer tags of vmapped
> stacks"), but vm_area->addr still carries the original random tag.
> This is the same class of bug that was fixed for shadow call stacks
> in scs_free() by commit 528a4ab45300 ("scs: Release kasan vmalloc
> poison in scs_free process").
>
> Fix it by resetting the pointer tag before calling vfree(), so that
> vfree_atomic()'s llist_add write uses KASAN_TAG_KERNEL (0xFF), which
> makes KASAN bypass tag checks for that write in all modes (SW_TAGS,
> HW_TAGS, and Generic).
>
> kasan_unpoison_vmalloc() is not needed alongside kasan_reset_tag():
> in HW_TAGS, __kasan_unpoison_vmalloc() is a no-op without
> KASAN_VMALLOC_VM_ALLOC (only KASAN_VMALLOC_PROT_NORMAL is passed);
> in SW_TAGS and Generic, the 0xFF-tagged pointer already bypasses
> shadow checks, so the shadow state is irrelevant.

Output from a repro that you don't share, brilliant.

>
> Fixes: 0f110a9b956c ("kernel/fork: use vfree_atomic() to free thread stack")

A 2016 Fixes for some KASAN state bug? Really?

> Cc: stable@vger.kernel.org

And of course Cc: stable...

> Signed-off-by: sparkhuang <huangshaobo3@xiaomi.com>
> ---
>  kernel/fork.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f0e2e131a..2fd6fd25c 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -280,7 +280,19 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
>  	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
>  		return;
>
> -	vfree(vm_area->addr);
> +	/*
> +	 * Reset the pointer tag before vfree(): in RCU callback context
> +	 * vfree() routes to vfree_atomic(), which writes to the freed
> +	 * memory as llist storage.  Resetting the tag to KASAN_TAG_KERNEL
> +	 * (0xFF) makes KASAN bypass tag checks for that write in all modes
> +	 * (HW_TAGS, SW_TAGS, Generic), avoiding a false tag-mismatch report.
> +	 *
> +	 * kasan_unpoison_vmalloc() is not needed here: in HW_TAGS it is a
> +	 * no-op without KASAN_VMALLOC_VM_ALLOC, and in SW_TAGS/Generic the
> +	 * 0xFF pointer already bypasses shadow checks.  This mirrors the
> +	 * intent of the fix in scs_free() (commit 528a4ab45300).
> +	 */

Nobody in their right mind does a comment like this for a kasan_reset_tag().

> +	vfree(kasan_reset_tag(vm_area->addr));
>  }
>
>  static void thread_stack_delayed_free(struct task_struct *tsk)
> --
> 2.34.1
>

--
Cheers, Lorenzo

