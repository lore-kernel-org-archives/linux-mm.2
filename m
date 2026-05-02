Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC48CD13DA
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 17:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EC716B0005; Sat,  2 May 2026 13:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D7D6B008A; Sat,  2 May 2026 13:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3096B008C; Sat,  2 May 2026 13:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 19C8D6B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 13:24:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFE8A1C057F
	for <linux-mm@kvack.org>; Sat,  2 May 2026 17:24:48 +0000 (UTC)
X-FDA: 84723154656.24.5CD6A21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 194194000A
	for <linux-mm@kvack.org>; Sat,  2 May 2026 17:24:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=l9t687VF;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777742687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilqZMYogT1UuGpTlmqcknMdLxMIwNJy78zxMy1wmMWY=;
	b=aa55OUEyszzdLQkHYnPWHe9E2p/jls5bTez2DjJLzSmK/BWuIggTVtfc+vrQyJ+ZIKY87A
	/AJZ5E40Amg1OfeLO8PFIu3mG1rrvoeBngDBn3O5e3J/WvEgdNf/wTQ3bQJ1yS22QhaWwH
	wU2GZLVIbyRYerHF6hXI1X0b+0EiCpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777742687; a=rsa-sha256;
	cv=none;
	b=2k5bQtKgftvFZewQYl4JIlhgR5xXQeOqkzK3tdTzehYjQQ9Pl7Mzhf5FY3OXdWKKcoZgPY
	+ffcv/NE4thaUXt5/T2gVwxfOmv0MfgDw5HfHDe/+7oA9rqgImYqAhXKcQQ0Y/pJm2vPT2
	HEdpAugg3mMAvIS9JopCPMr1kdrhGSY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=l9t687VF;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F8E560120;
	Sat,  2 May 2026 17:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FB3C19425;
	Sat,  2 May 2026 17:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777742685;
	bh=vmKzDutJWCWUsGIvxQ9ktxQxuZTD2fT0yAdNBt2VkvE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l9t687VF+510w1MStA0+8d/lbOqZ+cA9LKosEwhCpj44KI/tHY0mKU70II+E4n54S
	 yLST5xKVcnqWpazdY117VUBx1Gv+fMxyphrOPDi+0eK5uoBxidDznYHrZV9Dl+YcYr
	 rHVl4oY7tuRr/xSaEK3Czfzbnzc4flta+e5664Cs=
Date: Sat, 2 May 2026 10:24:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mohamed Ayman <mohamedaymanworkspace@gmail.com>
Cc: Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter
 Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Borislav Petkov (AMD)" <bp@alien8.de>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>, linux-mm@kvack.org (open list:EXEC & BINFMT API,
 ELF), linux-kernel@vger.kernel.org (open list:SCHEDULER), Davidlohr Bueso
 <dave@stgolabs.net>, Yiming Qian <yimingqian591@gmail.com>, Linus Torvalds
 <torvalds@linux-foundation.org>, Sebastian Andrzej Siewior
 <bigeasy@linutronix.de>
Subject: Re: [PATCH] futex: Drop CLONE_THREAD requirement for private
 default hash alloc
Message-Id: <20260502102436.79d5e53038169f38e4075137@linux-foundation.org>
In-Reply-To: <20260502155730.430232-1-mohamedaymanworkspace@gmail.com>
References: <20260502155730.430232-1-mohamedaymanworkspace@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 194194000A
X-Stat-Signature: n5gjoennnj5dt83ku7obe9gtf7jwudjd
X-Rspam-User: 
X-HE-Tag: 1777742686-112335
X-HE-Meta: U2FsdGVkX19tlWCK8fsFr9CQWWKxYvGuFfifa1NPoDoDjtIhxN+n6+xtGS91/l3DcUhWd+g4aoeowquNZfov6ZMnxHbh4PjTghZGsmuFYVpexrjN5FmlyB8ppwVIdnPLAXpgy2eRSqM22yWh8xlZV/gbcf2JbIIjyBN/YiB5+hBxCVMzrnGX3vmdDnQxtRi7PhEBynXVTk5/3FIkOdz8cWQ6neiCIf+mRfWgYD6Bti33oDuvNz23RFbViByllyUCA61XyPtjKGFNIJ2ZgZBBGG0z/BAtKtDkPZhU75va2TIAft3/HxGAUl+Pzq9fHUd8ihPp2gVTC9zFQ4tJ338geLrnJUS+VVPTXijaxiDhGHIx90GoY7McI55iJlAq5yUEX/FqdEMY+NnWy3epIERvDO7sbE2N08vkp06vwc3oFVVIcMfkpW5pLpwPucjpoIkm2HdNbLSa/DP5vYgvsfT98EoxTQAaqV68A1w+SghJxuIEyUado6CvcmnVumPzUxelHnz++dTL3mBXstlMyo01Wf+URv1Bi6w3XyXo5FISCOTriAIYdqHaYh60s+gj0odtcwyTpLF6u2xjmN5qnYijXi4sXJqdKHnJpF1rB4TXs4WNtIUl78FzFdDZxt/rZuLkh5tasukLJsvhuGbyQ/LWOEuszpEZBlg6lXWqqzfngtYh7JbNu8AYQPmXwwtJwDzep3fcr0lRUDqJxlf17a0DWHrOQwnCCTVMwm4bYkfA/dNsGc+H10FBoovo3hRmkEhTkNo855QnEbAR3SYCOCgDRs4esDFjuYQ9pwNSbBySmKF1Mj57Zpc0SefrOm03FEysVeRGuqQ4EtKJyDKziuG//RR6FYjmkdlWBmpoNhVIfOXhqnpF7E/+lW/pnXIYRwPJ++76C8DQNrkREmW2Ae/FmIU2xDFsfhsTgoTxPd/wYoKxl+uAFBPjzEhvp9tB1dUWxb4l0yhFBvyYlrUaqfg
 666iO9GH
 snhoE4+QiOLklZd2GZaFuNhZe2GjTbsmMPBX3E0eMC3k9Fh5bjhGX0SytClcMKA5kSyjP/kSVOMEKcH3IDyUGdNQVazFXZrzJpJNdahb9UQKbCb+Om3pmINqRkcf8YkhOwDF1XmKP4SwXbLi/HgVPyqkZ27ECHngsx7okZxUDF5GimopOyGikpM7lex+ZjpBo7DX5PeBxxmpwIRAN4KuiHpPJnsNcpPjW6txICI2wjszjjuSzYf+k4mQdupGIVvmmLwE57iGXozAaL6W65GqNCoYv94LhR7YKOAhuv4zLkR7b9Lc+n7uwuG1ZzFWzSzhhnStu0iz40TMRovLsT8icznnNp7GfK/fyRSTgblbhfW8Bg4NRGP9D7AcLcKqc5Vy2ZoLlV+G0mcLiMaEShfhMHMDeeSHkjPm7IVF8XrT1SxWJTD0UGJy4QCWtnoc7+hhdaXIEC6OpNK1bjG5Z1ryS0/pKpiaoso/76hl0R+X0zD2xDP0ZRJ1qa2TqyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat,  2 May 2026 18:57:29 +0300 Mohamed Ayman <mohamedaymanworkspace@gmail.com> wrote:

> From: Davidlohr Bueso <dave@stgolabs.net>
> 
> Currently need_futex_hash_allocate_default() depends on strict pthread
> semantics, abusing CLONE_THREAD.  This breaks the non-concurrency
> assumptions when doing the mm->futex_ref pcpu allocations, leading to
> bugs[0] when sharing the mm in other ways; ie:
> 
>     BUG: KASAN: slab-use-after-free in futex_hash_put
> 
> ... where the +1 bias can end up on a percpu counter that mm->futex_ref
> no longer points at.
> 
> Loosen the check to cover any CLONE_VM clone, except vfork().  Excluding
> vfork keeps the existing paths untouched (no overhead), and we can't
> race in the first place: either the parent is suspended and the child
> runs alone, or mm->futex_ref is already allocated from an earlier
> CLONE_VM.
> 
> Link: https://lore.kernel.org/all/CAL_bE8LsmCQ-FAtYDuwbJhOkt9p2wwYQwAbMh=PifC=VsiBM6A@mail.gmail.com/ [0]
> Fixes: d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
> Reported-by: Yiming Qian <yimingqian591@gmail.com>
> Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

I hate to get all bureaucratic, but....

Given what you've sent and from my reading of the security@ and
linux-kernel@ lists,

- I can't find a patch from Davidlohr which looks like this one - I
  can't figure out where you got that from.

- I can't find any code from Linus which would lead to the addition of
  his Signed-off-by:.  I don't know where you got that from either.

- Let's cc the author of the Fixes target, Sebastian?

I'd like to have this metadata tightened up, please - so a reader of
this patch can understand who did & said what and when and why.

Thanks.

>  kernel/fork.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f1ad69c6dc2d..5f3fdfdb14c7 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1951,9 +1951,11 @@ static void rv_task_fork(struct task_struct *p)
>  
>  static bool need_futex_hash_allocate_default(u64 clone_flags)
>  {
> -	if ((clone_flags & (CLONE_THREAD | CLONE_VM)) != (CLONE_THREAD | CLONE_VM))
> -		return false;
> -	return true;
> +	/*
> +	 * Allocate a default futex hash for any sibling that will
> +	 * share the parent's mm, except vfork.
> +	 */
> +	return (clone_flags & (CLONE_VM | CLONE_VFORK)) == CLONE_VM;
>  }
>  
>  /*
> @@ -2380,10 +2382,6 @@ __latent_entropy struct task_struct *copy_process(
>  	if (retval)
>  		goto bad_fork_cancel_cgroup;
>  
> -	/*
> -	 * Allocate a default futex hash for the user process once the first
> -	 * thread spawns.
> -	 */
>  	if (need_futex_hash_allocate_default(clone_flags)) {
>  		retval = futex_hash_allocate_default();
>  		if (retval)
> -- 
> 2.34.1

