Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 111A9606A8B5
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=google header.b=BunAqSiR
Received: by kanga.kvack.org (Postfix)
	id 1FF696B05B1; Mon, 16 Nov 2026 12:08:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18A966B05B3; Mon, 16 Nov 2026 12:08:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 076D26B05B4; Mon, 16 Nov 2026 12:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C62586B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:08:35 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50FDE1201DA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:08:35 +0000 (UTC)
X-FDA: 85441616190.05.6BCDFB0
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id 55126180003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:08:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BunAqSiR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794848913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/lO0d4awc7COFA/57IeDRMAZfL8lXDL1xwEp8NDS/0=;
	b=3Nuo/IDGljRicSc4YUJvM++SGuHbhqmgubMfQlqfIO5VzDcg8skW21C29cpOVV5euVG1E8
	8ciyYjCIPHueMBUGDqcCxijTt33fmSJBmCTSjEoB9fx1H6DETVuMVFMOBlTxxiKnO3NNg0
	skfNl7kvoFOQytqFq0ocklazyKETF/A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BunAqSiR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf16.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794848913;
	b=CZuT5s+jUr1QMgCDKPAUiw80teoHMBEcV199O7K6v1ziXpGSAZf+yDawydvo4bxUFnyqWw
	ox9ZfAuK8Dfq2yNQsN0MMe+4UsOFpc7ubhMPxf4YdllEVGE2cCBza04WXnpfSVCjHzPeHp
	DEECqYm+oQBAsNAytMKznxyKMY//t4I=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4b467581b98so32304765e9.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1794848912; x=1795453712; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=z/lO0d4awc7COFA/57IeDRMAZfL8lXDL1xwEp8NDS/0=;
        b=BunAqSiRUFID+3pT8TCJpRxfVvotAF1xt6skEL8qi5qIS3WsdXbkIzQ4ziSe3Ve3AL
         4uKWi9pbfGakez8lbxTBJ47vYe0bGfvb1Z2fLSQGpLk2oT9BuQhLfnLdYrz5HkQMdevC
         i936uUownddpsemhk05QztQw8eTwwT5ZWeM2WCBcf2nz08/1FXRx2T+GF6av8mCCERGp
         ejONwBKergYJkeZB+V+16SoHbYaph3cPpmt7YK++C2XixznSn1Bm0Hdho1ug3efACWyA
         k9cHNvv3BhhUvU5zxukB83qEgDWEN32fGgvYUiZXfrFFOd590KnMNiAvzcKYBmXI/r9U
         CiSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794848912; x=1795453712;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/lO0d4awc7COFA/57IeDRMAZfL8lXDL1xwEp8NDS/0=;
        b=mPNCk0dH25zfleb9c2ySxQ5cXt0WZLb6ceM0M/oEd6HxyrDwh8RD3kK/14zOt97vrY
         FkCjS0OQiV4j9toACfYpxq1AqUP4ITtLhzddke03qIZuXNshpOYoHa615aymDF4FvrhL
         8b6U5lOjT7TCo5n7VgW4GCdPVVX+ycx48LIavbobniFvwTQMYd4Kblo4eQULcYdZtQXa
         cdufLzHx5GjShmM+Uh8MusbF6BF7+1EuASfuoCiPRnSTz/PkxhpQPJuD6SAINhrD8MRQ
         jT7RQd0l1NrnCHTBjeFO3WPo/NShM/ofk4XLnlQf09lcCYobGEAYwFiQDc8E9D1yq1e3
         LszQ==
X-Forwarded-Encrypted: i=1; AL+hErF4pxktRC27LGIPva/JuvMS7Kw3KYzkxjyWuRXgr+aL2x8EJl8tKxoQtOpEd5+MK491Oy6zra85Sg==@kvack.org
X-Gm-Message-State: APuU4Z/oMLW+IgH8xGuqLxHnbfkTINHim/i2R707i3tkAS6OH0+laDKi
	poPdx+jnFpCUvZIQmYzQzB/W22PbtbucN8KQ5tUpi4jHtcuq8fWMQejUguqqZQrZBIs=
X-Gm-Gg: AYBFou1gjaRb/Vq5d+ZhJZlIEjVVSQ+UaKiZHyf0OlQ8wk6QD+duglaBz1g6S/lAO5d
	gNKTeHy+LTpiJkzuf1qZO0ntx8uPuyMWpl3FsLjc6cylpRAHNZpSF2iyCrxL5y6/mE/ptVZiNqn
	75hRCIaNUJdvV9GfLP6BcpofZ3JokMsxHrWagrs3qyEkZ5jk967t1zIf4hrH7frUI4E3/xLU0Dx
	KZxnLEc3CvEpcukBKP4IwZU9dtkTLtW4Y0j10IOfHuoeHQyx2iPe0yIoLH0/3KQRAsKnkGN+bji
	d4aL228liZUvzOlOclV7Bj2JgVeSkiAsB6yNw+4XMLJNP+KhOHkQE6cW9zuKERCYCB+ZRDpis8W
	BLTmDrY+Ap1gwBym/WGqBpBGH18QG16sCNetcOBKwMT36rkQJTnb6Y80yDWKt6tALT5L+8W1v/7
	f/B3eGocC1iJpg+c6lKg9VYuk3H1gV3VghkfGVRBvxrqO2R3XkDg/aXMpgz3V18nF38bXdTyVZa
	Xyu4p1mQ1N8h34UleDdhO6EMYyImT8J28hOPUGUc16/jKVqissxjSJloO1lDrC7WuGF6GsrMCmZ
	PwJRLzRTMVh1RF82uRWq7P8xqv6zQT8=
X-Received: by 2002:a05:600c:3494:b0:4bb:6c71:b268 with SMTP id 5b1f17b1804b1-4bb6c71c232mr97325545e9.6.1794848911805;
        Mon, 16 Nov 2026 09:08:31 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c77393700sm22964108f8f.18.2026.11.16.09.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 09:08:31 -0800 (PST)
Date: Mon, 16 Nov 2026 18:08:26 +0100
From: Petr Mladek <pmladek@suse.com>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: john.ogness@linutronix.de, rostedt@goodmis.org,
	senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
	vschneid@redhat.com, kprateek.nayak@amd.com,
	akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org,
	pasha.tatashin@soleen.com, pratyush@kernel.org,
	ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, kees@kernel.org, anna-maria@linutronix.de,
	frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev,
	hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de,
	clrkwllms@kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC PATCH v2 4/5] printk, tracing: Support console flush
 suppression and tail pinning
Message-ID: <avs4igB_mEc9U-Yw@pathway.suse.cz>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-5-atomlin@atomlin.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103024453.922373-5-atomlin@atomlin.com>
X-Rspamd-Queue-Id: 55126180003
X-Rspam-User: 
X-Stat-Signature: j9wm4mu9ha3i6zeaa3drp9nmfjp7ieum
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794848913-943819
X-HE-Meta: U2FsdGVkX18ibEDEgaXgzS/fAobKmVY38m2YdLVbo7CBwHXi2+6X0BGYfiHKqIiwjinS1Td4SX/hPN4TOvVVVOsAkuwl+IUci2mDCMHdSiEWLj8J/zjWiYNyU0wTMQxZTDfQhuUZ2xXiYCIaOFR+ayAERV6lfx0dUlRMk/eJR0h7ZFcdDEJhPYampyLjjCEi/gyZiXoSp3aUeZP6ZVwUmu6K7rt4H/H5cN0CmanfYNpWAqLIM2q5xsUShOIwdTJKrCbMriK0hliDsh0AcbO1+7GuVDpixiDM6Zp1xY+hhZiZ8MC9OqM0BByZcD3C11BnUVxHXcww6KDYrZwymSQfY4Xi+LgQ9HVFM8h49j+uQ7d7tWub1aH7f+2lVc2CNFtRwWDKX2o1h8lC/xEGa8XWT4ab8bAaqfZlnsUZvh2kk2ODmxC6M+NFav4GZG6FQyc0e5ykFlVurB2PggItqsuQi7zQxS41VErFUexSnertf4yuR0IFiBT7tJAbrpn9eEXKSD2Ui/Xbb/nB/ZKDY6x3dd5fXiGK48AivABqAnCm3C88I5E1jQEvLnHMeWUph373BFkqz9wH1wxg6kZnoYBBl6I0S0M63h7Y15EexhBlTyAsvZAq6+aWlf8CLRtWnouVuPTYJi0xlbZpzZS9wOLDDgW5JYKA7Od3RpvultPhHkzdI2dYbMxmsbvsHJC4ndtXog3JlcE57i3HGwKP8wr6Ve8y32XEuLWDfZC9fb62b0KS9EU4Qadmv43TFXv9wMDTJs/zE5JIpw5vkJ9NjJJxzxZJMMLoT27UJj32/AeEIerWl0XhzFiNCgoKwYAvKpXelA1XbC8MkBcijC16gyHo14MBcHZCR1qTePDyddggkMLTHeGNYj+nI4HSsXcQdIn0AFoQU+MzWH4+iki+Oae050xfrXFBUo+oSzvxGd/MsNFNpq6egu5z5VUIHSs+ZIVmSnlUbhZ4uyh94EGipPC
 7FwLrtm7
 sC8v/y1y3ss1s7a/GFd24lbcitOglWGi8a9ZVljF4dqwdWgRnRhi5TAiymL40a4Izmk5dVNFAIhdrUlcNVoejCZJWA1wkcmbaPxeoPorbGMWzethi8HCsJkeQF3d197cg1a0oEXVOR8X5U+0Ol95YPwFNilY6A/xAmDtOY5R43IpPQ41qWJEbyVw53UL3BX/MU9XlOQyLN6AglOvDPEjZeaI3CcWmGobz8SMPlrvkpu/v0JPqJQy3QHjxrsH9gGVHjdw8vyg3RBiLSWCGcq2OhtxT2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon 2026-11-02 21:44:52, Aaron Tomlin wrote:
> When collecting high-volume diagnostic output into the printk ring
> buffer during a kernel crash prior to kexec, synchronous console
> emission can stall the panicking CPU for tens of seconds on slow serial
> or IPMI Serial-over-LAN links, risking external hardware watchdog
> resets. At the same time, uninhibited ring buffer rotation can wrap and
> overwrite the initial Oops, faulting registers, and primary call trace.
> 
> Introduce two scoped mechanisms for in-memory crash telemetry
> collection:
> 
>     1.  Console flush suppression

Nit: We already use the word "suppress" for filtering less important
     messages on the console, see suppress_message_printing().

     I would prefer to use another name to avoid confusion.
     We basically want to "block" or "pause" consoles here.

> 
>         Provide printk_suppress_console_flush(bool) to clear the console
>         flush mask in printk_get_console_flush_type(), guard legacy
>         record emission and kthread wakeups, and suppress
>         wake_up_klogd() in vprintk_emit(). Records written via
>         vprintk_store() are stored in the in-memory ring buffer while
>         bypassing synchronous hardware console emission and kthread
>         wakeups.

We already have similar infrastructure for suspend, see
console_suspend_all().

We should not use a completely different aproach to achieve
the same. It would just complicate the code and design.

I suggest to add CON_PAUSED flag and handle it similar
way as CON_SUSPENDED flag. It should be enough to:

   + update console_is_usable().
   + add console_pause_all_in_panic()

, where the console_pause_all_in_panic() would do similar
things as console_suspend_all() with the following differences:

  + no flush
  + take console_srcu_read_lock() instead of console_list_lock()
  + no synchronize_srcu()

And I think that it will be only a one-way operation. We do not
need a resume part.


>     2.  Ring buffer tail pinning
> 
>         Provide printk_mark_panic_start(), printk_clear_panic_start(),
>         printk_freeze_tail(bool), and printk_is_tail_full(). Recording
>         the next reserved sequence number at the start of a crash (or
>         clamping to prb_first_valid_seq(prb) if the crash output itself
>         already wrapped the buffer) allows data_make_reusable() and
>         desc_push_tail() to continue recycling older pre-crash records
>         while refusing to advance the tail past the pinned crash
>         sequence number. Once the watermark is reached, prb_reserve(),
>         prb_reserve_in_last(), and ftrace_dump_one() finalize the last
>         record and stop reserving descriptors or consuming trace entries
>         so the primary crash context and remaining trace buffer remain
>         intact.
> 
> --- a/kernel/printk/printk_ringbuffer.c
> +++ b/kernel/printk/printk_ringbuffer.c
> @@ -377,6 +377,90 @@ static struct prb_data_block *to_block(struct prb_data_ring *data_ring,
>  	return (void *)&data_ring->data[DATA_INDEX(data_ring, begin_lpos)];
>  }
>  
> +static atomic64_t printk_panic_seq = ATOMIC64_INIT(U64_MAX);
> +static bool printk_tail_frozen;
> +static bool printk_tail_full;
> +
> +/**
> + * printk_mark_panic_start - record the ring buffer sequence at crash start
> + *
> + * Pin the next reserved sequence number at the beginning of a top-level Oops,
> + * fatal warning, or panic so subsequent tail freezing can recycle older
> + * pre-crash records without overwriting the primary crash output.
>
> + * Context: Any context.
> + * Return: true if this call newly pinned the crash start sequence from
> + *         U64_MAX, false if a crash start sequence was already active.
> + */
> +bool printk_mark_panic_start(void)
> +{
> +	s64 panic_seq = atomic64_read(&printk_panic_seq);
> +	u64 first_seq, next_seq;
> +	bool pinned;
> +
> +	do {
> +		first_seq = prb_first_valid_seq(prb);
> +		if ((u64)panic_seq == U64_MAX) {
> +			next_seq = prb_next_reserve_seq(prb);
> +			pinned = true;
> +		} else if ((u64)panic_seq < first_seq) {
> +			next_seq = first_seq;
> +			pinned = false;

What scenario does this handle, please?
Why do we need to move the "pin" when there are concurrent callers?
What happens when the original caller clears the pin and
the other racy caller continues with panic()?

> +		} else {
> +			return false;
> +		}




> +	} while (!atomic64_try_cmpxchg(&printk_panic_seq, &panic_seq, next_seq));

Are the atomic64 operations safe in NMI? I would expect that they use
some locking.

I am afraid that we might need another approach.

IMHO, it would be much easier when the caller knows whether it will
panic() or not. And the panicing caller would just freeze buffer so
that the next_seq will always stay there.

Finally, please split the console pausing and ring buffer freezing
into separate patches.

Best Regards,
Petr

