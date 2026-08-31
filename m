Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A90C624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2AAE6B00A2; Mon, 31 Aug 2026 10:03:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D01CB6B00A3; Mon, 31 Aug 2026 10:03:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18076B00A4; Mon, 31 Aug 2026 10:03:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9007A6B00A2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:03:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CE101C037B
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:50 +0000 (UTC)
X-FDA: 85161733020.12.B4FDCDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 469E44000F
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:03:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DC63ksHd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788185028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HX9TYQjgO/5hXmQFqlxHA27MLAvo/v6Sb6ISr7PR1Q=;
	b=H0hpzxyC0j4VkRgYsVEEb6XN4u/cM0NhHsj9IwqH1M8lKH3K67913mcha4Q3grYXr5LgSJ
	l+j3o7SxFyw899qagGA2Zg0uNK5brWjjCkr2xeg3aDklNEtMyifCfGxtd1EpAwEmle2+x3
	HdpOudJdiqLgvQ24TWmmNyqA3nIJ0TA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DC63ksHd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788185028;
	b=TDnY+Yex5CXcImSH7ocICM+jNqmko0K3W+3i8F3/svleBAQtaUIMxYrOUQWerhlPPCR84n
	ZyGH8jhApVpDPGrE00jfy5ayOfOWQHrxBpgCjckyUWvHEEDjgXIok90j8klxiJhCnIcGV+
	IxnIAvocndISLnljvFCRWcueDFhSq4Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC42860229;
	Mon, 31 Aug 2026 14:03:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C681F00A3D;
	Mon, 31 Aug 2026 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788185027;
	bh=1HX9TYQjgO/5hXmQFqlxHA27MLAvo/v6Sb6ISr7PR1Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DC63ksHdTNXpk1d7LsdZXGkJ4TqoesWNQd4cA0cdBSN2sTz5oarOWquXAAe7Xne88
	 x2+W0buRDqFXeuIdOYmT/SKvqfrbNwFHWN7ihOHDbZt+bSCqz67ja1m8+d/tMnrnTj
	 mIlGeZbmnVY1BH9bhtNYamzgigzi5iLBVI+JBqh4oCQQg783Gs7v5Iw7Ym0936oesb
	 BoOyDnrhCglt26iK1OImhRBZEsl1owvpJVF67euhl7waxIXyn09LKFp9Uc91hAJVmA
	 eZaBpydeKgXBFIkT7tX1ms8GB0huF8Q0Crk4ypZoD5NpaNrSRbRfh3C4iKZXcAZD/r
	 sWBaijMSt89kg==
Message-ID: <0849e5ca-6dec-4cf9-83ac-89ab08364044@kernel.org>
Date: Mon, 31 Aug 2026 16:03:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Content-Language: en-US
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Stevens
 <stevensd@google.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H . Peter Anvin" <hpa@zytor.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Uladzislau Rezki
 <urezki@gmail.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
 <20260829084901.GA776954@noisy.programming.kicks-ass.net>
 <apLxcg3Lgy0-nXA4@casper.infradead.org>
 <20260831073619.Ssq-wt7s@linutronix.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260831073619.Ssq-wt7s@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1jsughg4u1n9tbs3iynzeeefrhm84is1
X-Rspamd-Queue-Id: 469E44000F
X-HE-Tag: 1788185028-476718
X-HE-Meta: U2FsdGVkX18a8tCcS0/VQeFg6/CX2aad9hLq7sTGScxWlxBr2qjD516A2PZDwJTvV6sVGc5pWlJJr723jPp0IGmB1yuyajzo82G+BiZKws5PM3cqudEeJNShhUUFGIwEI9lUKVgLJItyukw3xopYAnExCXtw+jOld7gMsHA2WjzJ0dOH4bvjMLgCVZCRSBgaoAnmazYyiCtTZwRv1rpD8J714V20k6tMTAM62d4dGc0G2pL66L7m6TIHxZrq91Stih7ZcJJAN/RceC/SwSBoSjvlb4CQ2qoxJetc2oJ0AzH7qEHDeyi4mr0hoAy9qkSYUwGzQoSytC8JErrXehCRzRtWhi27blCzaL/Lr7gu0gDlTUQ44T/27Lhf3dxFq86kLEfbVD379U7OU/nZ6cp+96AVAApRA93h6gIDunSiGpvIHLZbFCNtk8qyUMggOfT05HJZw/vmvrrHcF8iyVNbJestQxP+AFD6uA3xWSBCTzB5henI06vzWf1VRD/O7vzcHF7cHRcYat5RcD+8wS4D/TFsJepB2x0qNlV2ZhQ2GqhvODez9TjQNCd/eO3ra/RCitdEicNkg3czuoBc2B4OlLyxujjc5zaWM8a2yZYZCWgzguQ9YYKm0dIimeVmFBCI+AnIoEg6pBxacJSTZ7w4PJ8IpYPa7GlrCmFsUhPyOZMgV3Hv6MyZ8wmsKIkEUyPsBXFdkIWfwbUFrJkc/L8QVcDPnckuMv92FjWZpEj03cTpwtI/t5Gxc8KN7yjH0WlXQl40AmrQdVUKNWOhHJmrKB3aDUtxO/u0b/MhoT56Xqi1PqZycDYtSSI0r9kaE7LWQdvooKJra7T1A2jVkdAi+IUAxOZn5uw2/0WBQI9xHButFoHws+FywyTV4TgwwydOHoMB+CUju8BURgv6H7SieX7XPgkfch8o3ti9LTMIV/FmYx/XTMksoS+cj6vkdo+BBCk3em5BzgxD4cZVVc/
 Q4QkKqRS
 9yV/ykJZ4FytkctO2x1C6KIBe8S+iV9nJBb/fQ/JoC3soFvtzNK8/0yFQ8Wz6uNiWLgjPlo+XfRug39FnU9l6Wdq+8fMkfHAFC5iGPoNGMqrb7ZP6n1J5z9Ls6bYY/zesfOrms2PDW89zzsPWfxisqiN+5s/ulkfzxlUsdC4W6o1kZ7/AwbpoFDnkJOM0inQGOIOcWgzCt6n1kKeyWTeiHRyz9Vr5fQnEFR6ugsst5TOHJzj+cUBZocl2OpSSkYFPt7Lo2TMnDE31Okno6+6MbOTdaA0k1HznoO08p1PJF/ZS/Jt1/bFRpYRFtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/31/26 09:36, Sebastian Andrzej Siewior wrote:
> On 2026-08-29 15:49:22 [+0100], Matthew Wilcox wrote:
>> On Sat, Aug 29, 2026 at 10:49:01AM +0200, Peter Zijlstra wrote:
>> > > On PREEMPT_RT, it is necessary to skip the call to
>> > > alloc_pages_nolock_noprof() from under pi_lock, since with that
>> > > configuration spin_trylock can end up needing to take pi_lock. But at
>> > > least on !PREEMPT_RT, there is no risk of deadlock.
>> > 
>> > Yeah, which puts the lie to that horrific hack Alexei did. We should
>> > probably teach lockdep about spin_trylock() not being safe and see the
>> > house of cards crumble.

Is it already happening then?

https://lore.kernel.org/all/20260831053846.107974-1-ngocthang2710.1999@gmail.com/

>> Why is spin_trylock() unsafe on PREEMPT_RT?  It's not intuitive since
>> one can mutex_trylock() in interrupt context or under spinlock.
> 
> no, you shouldn't do mutex_trylock() in IRQ. There was something, I
> don't remember but that is the reason people use semaphores because it
> is okay to do down_trylock() in IRQ. It might be unlock path. 

Is it what this comment (recently moved to can_spin_trylock()) explains?

        /*
         * In PREEMPT_RT spin_trylock() will call raw_spin_lock() which is
         * unsafe in NMI. If spin_trylock() is called from hard IRQ the current
         * task may be waiting for one rt_spin_lock, but rt_spin_trylock() will
         * mark the task as the owner of another rt_spin_lock which will
         * confuse PI logic, so return immediately if called from hard IRQ or
         * NMI.
         *
         * Note, irqs_disabled() case is ok. spin_trylock() can be called
         * from raw_spin_lock_irqsave region.
         */
        if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))           
                return false;

Of course checking for being under raw_spinlock_t can't be added like this,
hm.

> Sebastian


