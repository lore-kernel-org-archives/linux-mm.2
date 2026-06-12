Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64F78CD98C7
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 01:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6E606B0088; Thu, 11 Jun 2026 21:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0E86B008C; Thu, 11 Jun 2026 21:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF436B0092; Thu, 11 Jun 2026 21:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 764036B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 21:11:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B3FA1A02E8
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:11:00 +0000 (UTC)
X-FDA: 84869481480.30.D4EE708
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7E512180003
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 01:10:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/ebhH3u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781226658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Nt7zTy7OwkHO+yy23DmbB2qHh++8NKVSmgy/TvQ9cw=;
	b=yvlWBGkhJW3kREtCpTvjYEd3WlgqosFQNDNraHwgf8biP1L3ah8qkQMPRtwQenKKngN/Hx
	bTlfJL1xU0Ko5H1PxnfvYPnAeTjcbfxS9+HXrxA1eb8EIgARs6Vh6ozxHSvReB9FdTdefr
	d5fADprkGBohTDw9Jon0gtVBshNsuIQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K/ebhH3u";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781226658;
	b=VxKWrxBiEaDnAmbkjgl0e9+2kUCWbpb8NgL7bJszMkoJEGULQYHIMw0gV7cPJsflCSjbcR
	7VASPXMgcBXa3eXrCcBbZ+S1wttY134iGJowQ1cTPH2EEzr3u8AnxwFgo4vN7QrwmcU3HO
	Bi85PtFR71/y2g44eJfnQ2DNfLxZJD4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CE14C600FC;
	Fri, 12 Jun 2026 01:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029811F000E9;
	Fri, 12 Jun 2026 01:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781226657;
	bh=8Nt7zTy7OwkHO+yy23DmbB2qHh++8NKVSmgy/TvQ9cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K/ebhH3uC6E2Exq+61ZEWztMIPk4YRRJLlxdF0tImKaO7Pulx8fUcCw5EAjS5dWwh
	 CrWmAh9m7eAliMCSb4PmrSoykALflrAEc2CohDRTdeG3Jjf5Zt+moL1/4i8BYeFtty
	 eIk9wHnCOLR1AB/7SyBbjq0X92u3+y/mD2alOLNCVNlLcvMiE3iT5BLE/6JMdcGan+
	 DcoRRlqbxoefSGjIZsUbdbfSBmhqVo6Zwm7nplyHcjle6GLcRhKobLZM4NSrCNNZzh
	 PyzIRxxql7Jcs89uniKkOKVvXaLWyBH4+WkE/fra00bR9W6HQQT4JXoTZsAUkUnM1/
	 WgVpovFv6TNew==
From: SeongJae Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SeongJae Park <sj@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task stacks
Date: Thu, 11 Jun 2026 18:10:48 -0700
Message-ID: <20260612011049.84146-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: brt5zc6sqrjzhp5yhhw8nx8of8mb6agp
X-Rspamd-Queue-Id: 7E512180003
X-HE-Tag: 1781226658-892399
X-HE-Meta: U2FsdGVkX18Tnm1L/0nmUDPGbQzLE29ak6Md8Vq0l3pPSHk7FUSqkr0Jh8h3WI/sAzHbIlhFpLZh8haIjECRJsK4jWdfBiSggbBEjO8u2Xb/JiLFbGB5glhZwEUk59fQ+Yh70XXlMYBZMpww8tWLhjWhGo3hU4wbE9FTHbhd8wWrix+XEsgrY2DFPrgDWLRsXTK1j1iSz+UQuFD9QYAnE1Ws3J98ldSUqpskKvknDximu9Hf7hhwT23VZ2hKSnyNtNx3uFJbBih0ZSLO30mCXkU24O76OZcmUjb43asRLWscJ53RJWo6OtWxYAWybYKNPXnJxdfkzZM7rpcUYVIT6mXoO1/+e4Gy/YU/uOFdblZFQOEToScM2KXHS1WqMLg6F7HUjK49rqFaZdR5cPtjJNctJjbSOfm6pe/Iw8nA2Y791I/IZdIr79ESbtl5lsR7IuEmbAF2QxaMABmxaylBqBcE5/3KJRG69sPpdVuqxbJJRv+i7RjhGrIU2bkJCR9cid1hvA5HnNuMFILbTXvnVL3eb1CcYSWjCff9Z90IMSvUBAz7Hw7vpExRRuuSYPuqqjBMGPDh41MW5bE1gwLQLadWTAiechY+MXeKfojzc09IFauOjwwclu2nZ/de2e2pVz1e6WOPu6NSEfSdtDzYqza63Hb5cN79KoRClnfV6odWPSZNQkMtdWRK/fl7SsIt6h3k81tkhqUx5ucf7jnKDIKZub64L0nw0LdRmM8pwz8ShKOy3idFJMj/3yx6ZBp86gsAx4Y+khjK3cAW+QMYkU1i4PCzG1lTbNAaOqm4O+/q7xrqDx/JiRXgpcGlnxk6CULp/1krd0p0DNT1pyiXEYDhcilSj/hHMOEE1RlRy7r8nCPcup8ByvXISmyVK0a0U6LndQkooyrgxK2PGdmmUcWg9lPvf9ejEFSIKU0KrVYGJ7+Sb/9f6WGalKI07lairFxvqp7ZapPh5MuzY7p
 xg+7V8SR
 IgbEwFxiJoWokicZYrobEiQMRNzIq7qz2ogOxsYUpaOKYv9eCQC67DVUsXBiT/ombKzsZvLcmGJatwQo6LeuVcYl/92b1QQr0npV7RrFjYbvumUphN6CQSMMSlR1paJVsYdgOaaw3ufT1oF4/JNKDYa0cium8jrg/AseT+xaM5fux8LY0lxqOZMJxHoWTygI+8VlyNPYYiCCz6SmNcU1wn+6vehH4G+gfq0y9AjqSvf/F8SOGrgIx4if6XZ3tiAM76vsCFM4IS6/g5cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 05:45:00 -0700 Breno Leitao <leitao@debian.org> wrote:

> kmemleak_scan() walks every thread and scans its kernel stack under a
> single rcu_read_lock() with no reschedule point. On a host with very
> many threads -- amplified by KASAN/lockdep in debug builds -- this loop
> can hog a CPU long enough to trip the soft lockup watchdog:
> 
>   watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
>    scan_block
>    kmemleak_scan
>    kmemleak_scan_thread
>    kthread
> 
> A cond_resched() cannot be added directly: the loop runs inside an RCU
> read-side critical section.
> 
> Split the scan in two parts:
> 
> 1) get the list of tasks (with RCU read lock) in an array
> 2) run scan_block() for the tasks (with cond_reschd()).
> 
> Is it a sane approach?
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/kmemleak.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 7c7ba17ce7af0..9f8a35ecbb50c 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -62,6 +62,7 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/sched/signal.h>
> +#include <linux/sched/stat.h>
>  #include <linux/sched/task.h>
>  #include <linux/sched/task_stack.h>
>  #include <linux/jiffies.h>
> @@ -1885,17 +1886,34 @@ static void kmemleak_scan(void)
>  	 * Scanning the task stacks (may introduce false negatives).
>  	 */
>  	if (kmemleak_stack_scan) {
> -		struct task_struct *p, *g;
> +		struct task_struct **tasks, *p, *g;
> +		unsigned int nr = 0, max, i;
>  
> +		max = nr_threads + 64;
> +		tasks = kvmalloc_array(max, sizeof(*tasks), GFP_KERNEL);
> +
> +		/* Snapshot the threads under RCU */
>  		rcu_read_lock();
>  		for_each_process_thread(g, p) {
> -			void *stack = try_get_task_stack(p);
> +			if (!tasks || nr >= max)
> +				break;

Why don't you check !tasks right after the allocation?

> +			get_task_struct(p);
> +			tasks[nr++] = p;
> +		}
> +		rcu_read_unlock();
> +
> +		/* now scan_block for the tasks above with cond_resched() */
> +		for (i = 0; i < nr; i++) {
> +			void *stack = try_get_task_stack(tasks[i]);
> +
>  			if (stack) {
>  				scan_block(stack, stack + THREAD_SIZE, NULL);
> -				put_task_stack(p);
> +				put_task_stack(tasks[i]);
>  			}
> +			put_task_struct(tasks[i]);
> +			cond_resched();
>  		}
> -		rcu_read_unlock();
> +		kvfree(tasks);
>  	}


Thanks,
SJ

[...]

