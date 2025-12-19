Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BF5D74956
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 544366B0088; Fri, 19 Dec 2025 01:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1506B0093; Fri, 19 Dec 2025 01:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9B46B0098; Fri, 19 Dec 2025 01:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9D16B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:06:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 973BC8AC88
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:06:32 +0000 (UTC)
X-FDA: 84235186224.23.0BD55C5
Received: from mail-dl1-f66.google.com (mail-dl1-f66.google.com [74.125.82.66])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8CEBA1A0020
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:06:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=joelfernandes.org header.s=google header.b=YSfk+1ph;
	spf=pass (imf19.hostedemail.com: domain of joel@joelfernandes.org designates 74.125.82.66 as permitted sender) smtp.mailfrom=joel@joelfernandes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124390; a=rsa-sha256;
	cv=none;
	b=qYlFI+uSHPNiTWRrLa5AhgC/1qGVVRz4L+5E03F+YgpoazNCwWwHr7LNx8r0kvzF4GKRXW
	Lspd0RGZKvVAtLOap8c5ydveXHo/Kg9o9bzrSWUFs9REwlrVgglBPN19gVPC1DqQXldcNx
	i28JZyqs5a1Q8ykdBEii0wExGZo8agE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=joelfernandes.org header.s=google header.b=YSfk+1ph;
	spf=pass (imf19.hostedemail.com: domain of joel@joelfernandes.org designates 74.125.82.66 as permitted sender) smtp.mailfrom=joel@joelfernandes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4ASvqOPK+wdtj+DunJ4RuJFwNDx19O3Ghp3000vvXE=;
	b=kKPsPcCHSLQIoScSjayJE272qgLD3O6jrfTviwYSxiXqPPGnydFfVVwK9RfG+UkWB9WgqZ
	uR2zPBgPExqTbjer0/58Tvb7iM683MZAO4YA5TsAOpLHg/njbiWBCzrlVwAZwUIL1jnfQj
	v9rEM5HUSU+3PpJmT4usokGv7JInSDE=
Received: by mail-dl1-f66.google.com with SMTP id a92af1059eb24-11beb0a7bd6so3475161c88.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 22:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1766124389; x=1766729189; darn=kvack.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t4ASvqOPK+wdtj+DunJ4RuJFwNDx19O3Ghp3000vvXE=;
        b=YSfk+1ph1Pg2AxJddO8ehG8IgsSgs6ygdtnnap5Oj/Oxbb9oTILcUjcTA5TTFE6UZY
         h9ktloFId9DEDJFBYIAUpJBWnPF4i73mPCLcg6Hxd8v5YiRLiwrHclSKv+xFc1tvhm3y
         FNILhjY3IH5xZjbY2rTTJAl/9cFrFv8vF+764=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766124389; x=1766729189;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=t4ASvqOPK+wdtj+DunJ4RuJFwNDx19O3Ghp3000vvXE=;
        b=ffzhYctMjtjWiS5CqKB5Yy3Py3ypHjqMHf0cfHQpjDmfljQA1SD8JyuWSICTHiZT5j
         fP237PdYTIaMWcYTNMyxaNrkPJbWrMBZcJl7pjHXXnoUmtPSKMVE3nLuhD7m9aVduy4k
         TZjr3c6P7Wa9vjSA/kAA85BYkfTD6B5Anyp0jI8PKbpgrJBvLv0kq/QbWqBiUObyMBTm
         CqO129YNBuZFGYlC0SCVgmgMheB2wFLcwG6fSge7CuAxFDKw8537CDUzlEfK6VPsmRRq
         W8QoIKRF9iAZaf5asgSIfyHG1DDdQ9MWkJ6j7stPEcH7CWAedIe9RTj8hUliIUQJHuCa
         P2XA==
X-Forwarded-Encrypted: i=1; AJvYcCWFRoW1KhpnVS1BIPQ+MkhV+IH/O6UcQtIUoOBd0GLtIqSxGV8iV48jnlvgyp+vNECgRcaldK21vA==@kvack.org
X-Gm-Message-State: AOJu0YxvtTG8jV1DVeLgXuy4JbfkBkPS/3hDZmdqVqbtdec80j7/iX5Q
	TPXuW9BpOllVKZOu4px9w3Ry1pIIJlumokv7AwULdCuRF7qhuM9H32iHJ1yTF2lkDVk=
X-Gm-Gg: AY/fxX5+MqrolKFPwp4+pEzDXm3nWhj7fQbTAYais/NB7C0qQ/1YbycTYXgM3igKOUI
	RpngV/z1YQGE3z6QGN6Z2ua5zAmREOhA0gQ6wJUvKqFBje0GOmFowAljDEYzXkL2SMBEtrtqm/M
	3GbTVYwXW08GAxmMLsTjRAANSxP1TQ8GX01tDeuZIhJtnTQVJC4saN/Qvf23Co+n5g5UJ9sz636
	5fu1JZR8EVX7bbsut3aBxxHzf1hR4QoHp5fndNsJ0RP4zAAFAzXAqCT2ixqErwtORCnCBn7xFgc
	LOmstC02Z+Yr0j+Wzif7XeCgIAKY+gRcpuJp4pAIH/xria/Ko+v8BAXyrLCYCZZ+GEjhYsJsp48
	KcKLSgGaOQ1RPqvyttYf3Xll18uGgNXWktvrVmze9SF6CicCUyhkPmXRIlHoRahegmeKnz/RlgW
	+qqJ8KXce0y/RIUhU/FF5noIXz2980cYiAXg==
X-Google-Smtp-Source: AGHT+IGwMAZNN8AD5qW4BbAhXwX1eHbt0owrDB1h0dBh3YezG4fRDCPDgmTWlW9rY3wcM+7oOchshg==
X-Received: by 2002:a05:7022:698b:b0:11b:9386:a38f with SMTP id a92af1059eb24-12061991877mr5710079c88.22.1766124388926;
        Thu, 18 Dec 2025 22:06:28 -0800 (PST)
Received: from smtpclient.apple ([71.219.3.177])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724dd7f5sm5150094c88.5.2025.12.18.22.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 22:06:28 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [RFC PATCH v4 3/4] hazptr: Implement Hazard Pointers
Date: Fri, 19 Dec 2025 01:06:16 -0500
Message-Id: <BEBCE6F9-F76A-4443-AEF7-9E0D80039F41@joelfernandes.org>
References: <aUSbhiMgluudbVEG@tardis-2.local>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Paul E. McKenney" <paulmck@kernel.org>, linux-kernel@vger.kernel.org,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Alan Stern <stern@rowland.harvard.edu>, John Stultz <jstultz@google.com>,
 Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Frederic Weisbecker <frederic@kernel.org>,
 Josh Triplett <josh@joshtriplett.org>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang1211@gmail.com>,
 Ingo Molnar <mingo@redhat.com>, Waiman Long <longman@redhat.com>,
 Mark Rutland <mark.rutland@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
 Mateusz Guzik <mjguzik@gmail.com>,
 Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>, rcu@vger.kernel.org,
 linux-mm@kvack.org, lkmm@lists.linux.dev
In-Reply-To: <aUSbhiMgluudbVEG@tardis-2.local>
To: Boqun Feng <boqun.feng@gmail.com>
X-Mailer: iPhone Mail (23B85)
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CEBA1A0020
X-Rspamd-Server: rspam04
X-Stat-Signature: 7hqu4p6xzghn4rygzjq9q9j5rd3gcuuu
X-HE-Tag: 1766124390-944480
X-HE-Meta: U2FsdGVkX18AitkWlX1p6nktm7lszOGjjwqGXSG2ZdleEPEdhOVveX2nZp/wsL/rrPiIpgc44QW777PUu/WvLXoCkqG70CMAT9XMkkfZYKRcZxpOYvPCDZY22FTYOaObbuwDo5jXT1oXAActxoXx4vJ+RXP957/iHfhK3L8fS7TmG1l1M/QkGL2nBKYukNNbq3Lg4rpCec16up89bV7vcHKnQd8/oN1C/tny3wF+k80WVUFEDEqGGmbidQeHBArl2S9GNIM79HN7ujYkbBPWLRcd6TZhQk1JZWzRuVUCStpEzNYFbippHALa87udaeZMjPGPmKsY1uohLWdD60DG39zcdlgCI/HTCYtF4E4zhwz9PU3gTPYQLGu/fk9KA4KuCw7frBsBJNzc3CyedcHqew0oxOOzTuI5iCKJpLZryPaNkcn15Px+eHSndJLKmi+E5uuRYY0uzbgQGAsmMZ3jvKYuuEjL2A8aTM/WLnyFN6wOqwPvdHJ3HXQh5DaViD4a7NkODN4BF6G1na55Mfz+AvCuUPApArNy4und/4A19CFc67X8O8gz9pywvUSBBSBSDx8wC1kBwX2gpYH4a570I1BiFhtMxmif/V0sC6hWm8axlbEWzBxkLU07yxalCzarSkeV/WLGWVuXFFFgKTlH4VJsgFaOUfUUYh/AMfgPAZ5PYPczpH2exymOhkrdNSfoQumiZCqsfCEh44zRHwvcuFKprZJW1PoqOOVq3HAFWkbcbV1Kvjz8ETFtbeTMK+A/psfMW7zkJOADDj2oHjhHMMg1ZOEsE9gjt0hXk1oUk8YrDFJnI58BNSX6XAJDxBeD/w1CsPDmaazLyrRaBU7hGSL5m02M0jPp8dPsovyP/ROrIskdsGlr3p6xvLQ0Ke/w8FvTh2u1ZJ6yZglhmR2QhgavWCgnWY8060a2pqzbLFyLtZTvjw8tl6x43VKL8jo1Md6bcquEHDsQwUU49b5
 gd1n0Mlh
 cm05x6v60pN1cBG3OUHnB9BmjvXfcPcNqW4abgFnyDdDcUvg2EicLz9C0yCrWfW+i4u2d2Gq1IckFzEkAqZpk5ZpeqczNikXsF5Vcf64+lNNiTmEvkY4iuq25XlKBsteBUiqq/u1PiYeUNbL4UZFAVALwfEEYKX6RmxA4c+MU2Ld2B6yDg46lFdBufxjq2+W6ZLnFzZkTwbfVDp+hl1y+I7nGnRU5ZFGcbMtcwMAu35B2DxuOBpng5jdxIFc0F41WyyTjITJpviciHkLx9hu+fHizKlgvA1rqBMtAd5dM2+2vF6M/scfnyLWbL4wH6NgJNygkCkQ5c8bh/A+BCZWRRNuBXXzpx0lX4uhliurfRtHXYt/QlRDV6xZm1iraeqX9PSxBGxmAN536IMcufJuQwUTOAq1wWlB0CJ/EPJT+AgF6DLiyH+4wcM5QdB98bphEs/J/AkHw2a/reGCkfZR5ZtwXnsAXK690VffyK1VOWucAJKUZq6Dy5/yiiNcIAxz0yFhTlaoZJ6uYTTzkA7Ye+9EqumnZy4csNNvp43JXhFtm9PLEgPUAZzIBjvA5RmOfdYNT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boqun,

> On Dec 18, 2025, at 9:07=E2=80=AFPM, Boqun Feng <boqun.feng@gmail.com> wro=
te:
>=20
> =EF=BB=BFOn Thu, Dec 18, 2025 at 06:36:00PM -0500, Mathieu Desnoyers wrote=
:
>> On 2025-12-18 15:22, Boqun Feng wrote:
>> [...]
>>>>> Could you utilize this[1] to see a
>>>>> comparison of the reader-side performance against RCU/SRCU?
>>>>=20
>>>> Good point ! Let's see.
>>>>=20
>>>> On a AMD 2x EPYC 9654 96-Core Processor with 192 cores,
>>>> hyperthreading disabled,
>>>> CONFIG_PREEMPT=3Dy,
>>>> CONFIG_PREEMPT_RCU=3Dy,
>>>> CONFIG_PREEMPT_HAZPTR=3Dy.
>>>>=20
>>>> scale_type                 ns
>>>> -----------------------
>>>> hazptr-smp-mb             13.1   <- this implementation
>>>> hazptr-barrier            11.5   <- replace smp_mb() on acquire with ba=
rrier(), requires IPIs on synchronize.
>>>> hazptr-smp-mb-hlist       12.7   <- replace per-task hp context and per=
-cpu overflow lists by hlist.
>>>> rcu                       17.0
>>>> srcu                      20.0
>>>> srcu-fast                  1.5
>>>> rcu-tasks                  0.0
>>>> rcu-trace                  1.7
>>>> refcnt                  1148.0
>>>> rwlock                  1190.0
>>>> rwsem                   4199.3
>>>> lock                   41070.6
>>>> lock-irq               46176.3
>>>> acqrel                     1.1
>>>>=20
>>>> So only srcu-fast, rcu-tasks, rcu-trace and a plain acqrel
>>>> appear to beat hazptr read-side performance.
>>>>=20
>>>=20
>>> Could you also see the reader-side performance impact when the percpu
>>> hazard pointer slots are used up? I.e. the worst case.
>>=20
>> I've modified the code to populate "(void *)1UL" in the 7 first slots
>> at bootup, here is the result:
>>=20
>> hazptr-smp-mb-7-fail    16.3 ns
>>=20
>> So we go from 13.1 ns to 16.3 ns when all but one slots are used.
>>=20
>> And if we pre-populate the 8 slots for each cpu, and thus force
>> fallback to overflow list:
>>=20
>> hazptr-smp-mb-8-fail    67.1 ns
>>=20
>=20
> Thank you! So involving locking seems to hurt performance more than
> per-CPU/per-task operations. This may suggest that enabling
> PREEMPT_HAZPTR by default has an acceptable performance.

My impression is we do other locking on preemption anyway, such as the block=
 list for preempted RCU critical sections. So maybe that's okay. As you said=
, it is an acceptable performance.

>>>=20
>>>> [...]
>>>>=20
>>>>>> +/*
>>>>>> + * Perform piecewise iteration on overflow list waiting until "addr"=
 is
>>>>>> + * not present. Raw spinlock is released and taken between each list=

>>>>>> + * item and busy loop iteration. The overflow list generation is che=
cked
>>>>>> + * each time the lock is taken to validate that the list has not cha=
nged
>>>>>> + * before resuming iteration or busy wait. If the generation has
>>>>>> + * changed, retry the entire list traversal.
>>>>>> + */
>>>>>> +static
>>>>>> +void hazptr_synchronize_overflow_list(struct overflow_list *overflow=
_list, void *addr)
>>>>>> +{
>>>>>> +    struct hazptr_backup_slot *backup_slot;
>>>>>> +    uint64_t snapshot_gen;
>>>>>> +
>>>>>> +    raw_spin_lock(&overflow_list->lock);
>>>>>> +retry:
>>>>>> +    snapshot_gen =3D overflow_list->gen;
>>>>>> +    list_for_each_entry(backup_slot, &overflow_list->head, node) {
>>>>>> +        /* Busy-wait if node is found. */
>>>>>> +        while (smp_load_acquire(&backup_slot->slot.addr) =3D=3D addr=
) { /* Load B */
>>>>>> +            raw_spin_unlock(&overflow_list->lock);
>>>>>> +            cpu_relax();
>>>>>=20
>>>>> I think we should prioritize the scan thread solution [2] instead of
>>>>> busy waiting hazrd pointer updaters, because when we have multiple
>>>>> hazard pointer usages we would want to consolidate the scans from
>>>>> updater side.

Yeah the scan thread idea also fixes the scan cost issue with per-task slots=
 if we batch. If we implement a separate hazard pointer flavor along those l=
ines, then maybe we should definitely do a worker thread.

>>>> I agree that batching scans with a worker thread is a logical next step=
.
>>>>=20
>>>>> If so, the whole ->gen can be avoided.
>>>>=20
>>>> How would it allow removing the generation trick without causing long
>>>> raw spinlock latencies ?
>>>>=20
>>>=20
>>> Because we won't need to busy-wait for the readers to go away, we can
>>> check whether they are still there in the next scan.
>>>=20
>>> so:
>>>=20
>>>    list_for_each_entry(backup_slot, &overflow_list->head, node) {
>>>        /* Busy-wait if node is found. */
>>>        if (smp_load_acquire(&backup_slot->slot.addr) =3D=3D addr) { /* L=
oad B */
>>>            <mark addr as unable to free and move on>
>>=20
>> But then you still iterate on a possibly large list of overflow nodes,
>> with a raw spinlock held. That raw spinlock is taken by the scheduler
>> on context switch. This can cause very long scheduler latency.
>>=20
>=20
> That's fair.

What about combining both approaches? =20
Can we do the generation trick along with worker thread scanning? I feel tha=
t should be doable.

>=20
>> So breaking up the iteration into pieces is not just to handle
>> busy-waiting, but also to make sure we don't increase the
>> system latency by holding a raw spinlock (taken with rq lock
>> held) for more than the little time needed to iterate to the next
>> node.
>>=20
>=20
> I agree that it helps reduce the latency, but I feel like with a scan
> thread in the picture (and we don't need to busy-wait), we should use
> a forward-progress-guaranteed way in the updater side scan, which means
> we may need to explore other solutions for the latency (e.g.
> fine-grained locking hashlist for the overflow list) than the generation
> counter.

Hmm.. That only works I guess if there is no interference between the finger=
 grained list being iterated and the list being overflowed into. Otherwise, I=
 think it might run into the same issue, but I could be missing something ab=
out the idea.

thanks,

 - Joel


>=20
> Regards,
> Boqun
>=20
>> Thanks,
>>=20
>> Mathieu
>>=20
>> --
>> Mathieu Desnoyers
>> EfficiOS Inc.
>> https://www.efficios.com
>=20

