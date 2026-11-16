Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5043606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 03:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=LyRAVFev
Received: by kanga.kvack.org (Postfix)
	id CB8DE6B05B1; Sun, 15 Nov 2026 22:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91326B05B2; Sun, 15 Nov 2026 22:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7876B05B3; Sun, 15 Nov 2026 22:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95BFA6B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:16:42 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2755A055F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:16:40 +0000 (UTC)
X-FDA: 85439519760.25.565E957
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C2F9F1C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:16:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LyRAVFev;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794798999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9vMUAln9RF4ExbyRQjC3UtblgMb7Qet2HsLNIFFgQk=;
	b=mk5+DOULAxumRjkxVj1LWGQMGmZ9b5PhdEFGtzEqKjoUZV5YEFn1LMMf77hqUkwnHtdovM
	J/u9VAUlHWnZGgk4moZqNkdGbiy+lRjSM3wDfOX4wIN+jRfJSDPUexMJcZjwwFgdHgRioQ
	nyTTl8SInphuPYVCZCeysVl68kEnlNU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794798999;
	b=KPPuFfzk5pId3KfmHNNLayt3ygV949LywVazLwjQR0W5zqfrddxeT/SEmzJOD1hCb0z4Lo
	4sTcAmRsN76La/W/HvCXHOT68WuZqM14lcEGuR3m+9zw9LhdtvsSjeYwzYuQAx5q26kIKH
	5vcho6LiIRNFsE8sis3HZtZkPUH1OrA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LyRAVFev;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72D843532;
	Mon, 16 Nov 2026 03:16:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EC701F000C4;
	Mon, 16 Nov 2026 03:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794798997;
	bh=f9vMUAln9RF4ExbyRQjC3UtblgMb7Qet2HsLNIFFgQk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LyRAVFevgYPkx5MazjZeILe8nf+HIaMipxE5RhUD9KN0zKvQ9SX4LhtRQ6w0wax5b
	 pl6MKCva03CSsRGh5DEW5ZknGlva63h0SQAVEpY2Jx+/r7drr1fqCizZdoMW4lzrmO
	 qrvDPmonNiAAfQOtlW/qtNHjnRTJAVZMiZvyNHdM=
Date: Sun, 15 Nov 2026 19:16:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiebin Sun <jiebin.sun@intel.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, linux-rt-devel@lists.linux.dev,
 tim.c.chen@linux.intel.com, tianyou.li@intel.com, wangyang.guo@intel.com
Subject: Re: [PATCH] lib/percpu_counter: allow concurrent sums with an
 rwlock
Message-Id: <20261115191636.f18859e4dd5f58b9a33e7814@linux-foundation.org>
In-Reply-To: <20261116015655.2744577-1-jiebin.sun@intel.com>
References: <20261116015655.2744577-1-jiebin.sun@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: imycywb31a1qntkmaj8wxe5jbtfkzjk6
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2F9F1C0004
X-Rspam-User: 
X-HE-Tag: 1794798998-881233
X-HE-Meta: U2FsdGVkX18xkxqoqwquaax/6oVYCvt16eOR6mh7N1mXt8X83M0uLYTdxHSpocQqrhzOs7r503YGR7HdxeO7XrVHgVQl4MxJ8q+tsd8y5Uu63Vq9/CR5y259kGtuaRv/H1GksB4oryEnncnXzHKNy/5W6lnyCDuHq7AQy/0jTI7mo9pPsAveGc0Yg0zuCSgmGipiMSvL5TkbwHVyTua9v4sT6AxYmQRrVbYe+NDXA1+F9vwYaA8WHt6MzB1F6IUUbqYJ4HjeHk4axBgzwrlm/GhUd7/MJaTm2Z5XwP59iZ1BIiAAwNZ+sa3qKXfFGsbzMd55exe4Z4I2AbJU8UcPXD4s2W3mNo4YpDQXAT0Bfz5pY2Tv8zSoUBeGBZ72F3f+Z0KrD+I6oGljzkaqR5CstqdlCWA3522k53wkdHfrGkWdGFb+tLkU+rZHfLLyd4cBw5LGQNddgoQ3/CfWkKczT0dPDQTHayGS0/Wr4+OxraxXMPcJdJXSvCjICTOv22ynSqbnIzlquvqAwK45E2xvqObV5P4XFi1Ycet6lgZamT+IvjTMU088pV6QlvBgkvQAUKoFn0Puw5xfMZ+3MHVM2jkDHkfT+cyGgZEhyiBFMNJSulJAGdaxOv74i88JDvKAqmRKVoXueAuia05gFzQPegKcEofgO5dqxSpv2Sj9ZrHU7nX8Cb5WL/m3IDdgLTfMzjWneByyGeag8cgG49XXWfITra4a7p7Grxeo0l7EkU3MRiO+a7rOztCGQR3E2NGgTdBjLcCnLmShyM+eKteh5MeE0kKODcZDLD5mGzjqygb+bsBFyRUMZ6o5O/WLJaZLCQTA5K1U+ykJTf8pWb83J46ruQJ9dt7taMand0np58lGhfIj4/9Obr02ozH/qRZzqtYjr41IooacX6z0JsbPjWjMT1yIlhKoIewjDJu1eMQBkmuIR8y4YrOjFlVd6g9wyaHO+3hWH3k521XlCad
 Qzln+EW5
 t1ZdQ3DMXkwjQibotvVVQiXK+DkD2w2lYCPd5WOQN5qlAxdURIjgNAfRLEz/CfneYVe+ViHkbmq6KCAmw3jVGJDSwacg6NHCf/btOYEmiUjnCm/BoMH9di1+ZANtvp2mRlwdxuGJl8UYJB82acxV6S7wYEt/bLgRv+umB7k/dx17/f2bglCzgT8vuaV/tXFGshimFzXKoZ5gwZVMiujgzuMh6LLhi0b6cFWYseBAKurdwQ4ahPrv1MZ/yQhglv4OHgUe6s4akJ6gvNJNt9fHRR/FI5weWxq5fCWsijMORTSbhSvEHpG1wsvetRGP3yMQsl78x8PS2x9C9f70I/cSm3r+71A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 09:56:55 +0800 Jiebin Sun <jiebin.sun@intel.com> wrote:

> __percpu_counter_sum() holds a raw spinlock while reading the global
> count and per-CPU deltas, serializing concurrent sums of the same
> counter. Since a sum changes neither the global count nor the per-CPU
> deltas, use rwlock_t on !PREEMPT_RT to allow concurrent sums with a
> read lock. Global updates take the write lock. The per-CPU fast path
> remains lockless, so sums keep their existing snapshot semantics.
> 
> stress-ng dentry reaches this path through ext4_statfs():
> 
>   statfs -> ext4_statfs -> __percpu_counter_sum
>          -> native_queued_spin_lock_slowpath
> 
> Keep the raw spinlock on PREEMPT_RT, where rwlock_t can sleep.
> Global counter updates can run in atomic context and must not sleep.
> 
> stress-ng dentry test average throughput change:
> 
>   +------------------------+------------+--------------------+
>   | Case                   | Unit       | Average change (%) |
>   +------------------------+------------+--------------------+
>   | Dentry, 64 workers     | bogo ops/s |             +47.34 |
>   +------------------------+------------+--------------------+
> 
> Dentry ran on ext4 with 64 workers pinned to physical CPUs:
> 
>   stress-ng --dentry 64 --dentries 4096 --timeout 20s

lol, this is a fun patch - it reminds me of the old days.  All those
mission-critical workloads which sit in a loop running statfs will love
it!

I had $sidekick do a scan and it told me "the only plausible routine
win is dirty throttling: with low dirty limits, concurrent writers sum
the same counters.  ext4 and XFS sum near ENOSPC, where updates also
contend.  BFQ's sums are debug-only and serialized.  Most other callers
report statistics".  You might want to add something like this to
changelog.

Also mention that percpu_counter_sum_positive callers will benefit.

> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -20,7 +20,11 @@
>  #ifdef CONFIG_SMP
>  
>  struct percpu_counter {
> +#ifdef CONFIG_PREEMPT_RT

Might be worth a wee comment telling readers why RT is special?

>  	raw_spinlock_t lock;
> +#else
> +	rwlock_t lock;		/* shared for sums, exclusive for updates */
> +#endif
>  	s64 count;
>  #ifdef CONFIG_HOTPLUG_CPU
>  	struct list_head list;	/* All percpu_counters are on a list */
>
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -15,6 +15,46 @@ static LIST_HEAD(percpu_counters);
>  static DEFINE_SPINLOCK(percpu_counters_lock);
>  #endif
>  
> +/*
> + * Non-RT sums share the lock; global updates take it exclusively.
> + * Keep raw spinlocks on RT: rwlocks may sleep and their irqsave variants
> + * do not disable interrupts. Updates run in atomic contexts and need
> + * IRQ exclusion for CPU-local read-modify-write sequences.
> + */
> +#ifdef CONFIG_PREEMPT_RT
> +#define fbc_lock(fbc)			raw_spin_lock(&(fbc)->lock)
> +#define fbc_unlock(fbc)			raw_spin_unlock(&(fbc)->lock)
> +#define fbc_lock_irqsave(fbc, f)		raw_spin_lock_irqsave(&(fbc)->lock, f)
> +#define fbc_unlock_irqrestore(fbc, f)	raw_spin_unlock_irqrestore(&(fbc)->lock, f)
> +#define fbc_read_lock_irqsave		fbc_lock_irqsave
> +#define fbc_read_unlock_irqrestore	fbc_unlock_irqrestore
> +#else
> +#define fbc_lock(fbc)			write_lock(&(fbc)->lock)
> +#define fbc_unlock(fbc)			write_unlock(&(fbc)->lock)
> +#define fbc_lock_irqsave(fbc, f)		write_lock_irqsave(&(fbc)->lock, f)
> +#define fbc_unlock_irqrestore(fbc, f)	write_unlock_irqrestore(&(fbc)->lock, f)
> +#define fbc_read_lock_irqsave(fbc, f)	read_lock_irqsave(&(fbc)->lock, f)
> +#define fbc_read_unlock_irqrestore(fbc, f) read_unlock_irqrestore(&(fbc)->lock, f)
> +#endif

Please, no!

https://www.google.com/search?q=why+does+Andrew+Morton+prefer+static+inlines+over+macros

lots of good stuff there ;)



