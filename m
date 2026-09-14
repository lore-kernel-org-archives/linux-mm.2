Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16D6C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 09:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B12C6B0088; Mon, 14 Sep 2026 05:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961C56B0095; Mon, 14 Sep 2026 05:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B826B0096; Mon, 14 Sep 2026 05:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60D9F6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 05:44:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A376C01AC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:44:36 +0000 (UTC)
X-FDA: 85211882952.16.ED719F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8DD914000C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:44:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWt7mu4E;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789379074;
	b=SHKdHbdC4rzgX0EQ+18rM+8wVFWEQ++zt5ddnlnIGqIUeqervs+weT8Qit8Njx8qcq2rSI
	E+Yfb08zvQoW468MuWtLn0GByF/gsGyMA63l+G8FcNWXfkrD+gL0JIrrMj2IBKqkArtPiM
	BY+PjgDrZST9mSFPiRA7y1pk+gH35+o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWt7mu4E;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789379074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RqhRsSPgAhnByvBCyGHJb2bv4q3f94ZzhrbaeD0aH4U=;
	b=3870YDEqKv5kFwRnzZVUTwZEQqoHZcMg2NXWZudgXWgjCwM6fyeeeqDnp43DWru5Gnnusd
	OgHnnIypdyYEAK87ZzDn+sXKuKgioMQUKTZx9fbWu5XQK6v0q5vR79/J/qa3PB0WyS5AUy
	g0d1aoqXP+7dOEq/YmEZR4gcfIS/tOs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81DDE60008;
	Mon, 14 Sep 2026 09:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177691F000FF;
	Mon, 14 Sep 2026 09:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789379074;
	bh=RqhRsSPgAhnByvBCyGHJb2bv4q3f94ZzhrbaeD0aH4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KWt7mu4ELgJGrcVZ0DL9s5IU+inozxhjLkG/29VpB9RV7Eo8oIiU70bBDZPvPzneS
	 LiqWlP2EdIpLG2EUdBQtTTOFwV1nba+iVAEALW6zYxPLztIlB7nwlNuTeoVYhL9FUl
	 hFHXZ199IV6x6mUAumxMRUlCu8ojrfM4kFiBfFpJZlE/Mwt2S25JOPSJx2e1TfZVgN
	 WkBkFLiCFqDUutsuMD2zaG7JOW/CT7l41NeiKp2xG0x7cIywTEsePSq0Ow3wyeTrLd
	 EA7TSY4wyjToX5H+p57WAQLh3Y4UCDQcnwge3VevFbQjxtR4tfd+edoCXs9QTZlKta
	 SZkcnHI0SWyxg==
Date: Mon, 14 Sep 2026 10:44:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Shaobo Huang <huangshaobo3@xiaomi.com>
Cc: mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, kees@kernel.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, 
	vschneid@redhat.com, kprateek.nayak@amd.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, ryabinin.a.a@gmail.com, 
	glider@google.com, andreyknvl@gmail.com, dvyukov@google.com, 
	vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>
Subject: Re: [PATCH v2] fork: reset pointer tag of vmapped thread stack
 before vfree
Message-ID: <aqfBDEkiRmlb0WWZ@gremlin>
References: <20260806123020.90869-1-huangshaobo3@xiaomi.com>
 <20260914093300.100495-1-huangshaobo3@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914093300.100495-1-huangshaobo3@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8DD914000C
X-Stat-Signature: q6cg6f7hcfnqgka446sem9dbo13xk7hw
X-HE-Tag: 1789379074-245344
X-HE-Meta: U2FsdGVkX194tAWvv1fc1yWxy2z1GFMMyKepuNWC/ls1mRfiH15UtbyOqL/N+utUghCDh5SI4BbsEX1yxdJYjjhFkaNCrkfJ9v9W0yrKxr7LKST9ddaz4bpf5/AAj+8UbwpRzYFnjtXkjpii8fmSmzErEztV0TCly0PlfIiiemLcd9DyoCm/a62vSaAEyMwVbMLhRzfsc/0hOwW7++iRPbCPYmFw5Wx+bd6IW8GwfuTez3miGBAcmVYk1tq1E+u20e7aFe3D2cpj4Se5ZW1O+y2E6QXMT+O3IQOr8n+TbrX0HH4Ky5283ZF/HwtyEKTKmrd54GuLAh4ZGwxDfuDvAnt1PRnPsUeqeqVp/M7pENGEDJ/Qs6SId6MwtAYyLbSPXIOqrfiH2aXsaRWIwT3TdLHPX2cHOQacqsypMCjXEnJ3U92ucr00wPKPu2hE6JO92Uzrw+Nv1vjH6hQByNTOV1F30N1dxo10PwdfJPfFrMc7zoYfuL/yOb2wzUDNnhIhVwNfVs+VPf0BjdAtJEFCHAT4K8xDFF04LFKCNgdk4ezYta9v/NNmnMymeTzZky91If85Tra19hQY/ONQKZM4Ed9ax5oPUlO0a7Euilp+G5oNmHyJH6330As29Bj6Mo2zW57KVLjvhUXcXXorU2xPu2v0z8LCB01S4CJhxA8mRQWHDqqQ5Xx1Dwv4laoukJYKSa0wqliXqdjrHndR49OsuskG77eYij7pXsdr5qrsonU/BaTJj7gElgAP63Ys4DfQJq6sTJxhFmQwFKbwWrXgmSXk9ZcbPGtxy1OjA2T2taYQVtrWsGCHcu2tpr+MVhNJ/l4UQ9u4lIJ7QlOnkQfOndFrpY4eax06FQtIRFnm+3N6qbRSiLqEkUbg0JALZfF7Xgs1pRqUobthlw7Y6qJTORCbYwwwpqipmj6FRvvOJ5RU+KcE9P/gVgW/tefLxiEsLw4UDDqkeJbF7V21Mc3
 2JbNa6LR
 6XjYfoDYb3S/bAMHhODikifpSRGdMyrZJURR2uW6p6bvdhsNz8J71p2yUSGSYeUXLTLKnz9NecsPhUrOF2kEHGGL4rs1j0BZBX4ZnIaJ0ata6CWShn2jURYthcQ6KcdapuRwIfck8SSgKTxcrveNEmwUESVOFmGPp95fHN8cbEsgTlEaoG51NWKTprq2gAWVUCjmie21AaWqsC9H5uzLUK1f4A3dn8CO1qjF5xhgQy15GCoLvG9dF3BdCViWqngdXEQUpt6lSAMVYhQXU/Z8e0Yz6n2+rj9HckMqAR2KHVTArOyrlNgltgUHBnXhCGVplkckuCO4Zq6AvGJkKVfZ4tpFtp2ylRas2eU+qAauqF7MnoavkQa71uI2xOgnwy3JpuCGSyORVe2dextn7xysZUyZekA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Ulad for vmalloc stuff.

Please don't send a v2 in-reply-to a v1 or any other email.

Send the patch entirely separately.

I really need to write a bot to say this :)...

On Mon, Sep 14, 2026 at 05:33:00PM +0800, Shaobo Huang wrote:
> thread_stack_free_rcu() frees the vmalloc'd thread stack via
> vfree(vm_area->addr).  In RCU callback context, vfree() routes to
> vfree_atomic(), which calls llist_add((struct llist_node *)addr, ...)
> and writes 8 bytes to the base of the region being freed.
>
> With KASAN_SW_TAGS, vm_area->addr carries a random tag.  If
> kasan_unpoison_task_stack_below() has rewritten the shadow covering
> [base, sp] to KASAN_TAG_KERNEL (0xff) -- which it does on every CPU
> resume for the current task's stack -- the llist_add store checks
> shadow[base] (0xff) against the pointer tag (random) and reports an
> invalid-access, although writing to the base of a stack queued for
> deferred free is legitimate.
>
> Reset the pointer tag to KASAN_TAG_KERNEL before vfree() so that
> kasan_check_range() short-circuits the check, the same way the task
> accesses its own stack at runtime via sp.  The vmalloc lookup is safe:
> __find_vmap_area() resets the tag before comparing against va_start.
>
> Fixes: 9f7d416c3612 ("kprobes: Unpoison stack in jprobe_return() for KASAN")
> Cc: stable@vger.kernel.org
> Assisted-by: zhipuai:glm-5.2

Thanks for adding this!

New convention is to say:

	Assisted-by: LLM

Rather than to list the agent.

See https://docs.kernel.org/process/coding-assistants.html

> Signed-off-by: Shaobo Huang <huangshaobo3@xiaomi.com>

Looks reasonable to me so, with nits addressed:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

But I would like Ulad's input on this from vmalloc side.

> ---
> Changes since v1:

Thanks for adding this!

Nit, but nicer to say 'v2:' here I think.

> - Drop the 12-line comment; keep just the one-line fix.
> - Fix the Fixes: tag to point to the commit that introduced
>   kasan_unpoison_task_stack_below (9f7d416c3612), which added
>   both the function definition and the _cpu_resume call site, not
>   the 2016 vfree_atomic commit.
> - Add Assisted-by tag per Documentation/process/coding-assistants.rst.
> - Use real name (Shaobo Huang) instead of "sparkhuang".
> - Trim the commit message; remove the full KASAN dump.

Please give credit to reviewers for each change, e.g. 'as per XXX' :)

> v1:
>   https://lore.kernel.org/all/20260806123020.90869-1-huangshaobo3@xiaomi.com/
> ---
>  kernel/fork.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 45300f59cf2c..9a66b10749de 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -238,7 +238,7 @@ static void thread_stack_free_rcu(struct rcu_head *rh)
>  	if (try_release_thread_stack_to_cache(vm_stack->stack_vm_area))
>  		return;
>
> -	vfree(vm_area->addr);
> +	vfree(kasan_reset_tag(vm_area->addr));
>  }
>
>  static void thread_stack_delayed_free(struct task_struct *tsk)
> --
> 2.34.1
>

--
Cheers, Lorenzo

