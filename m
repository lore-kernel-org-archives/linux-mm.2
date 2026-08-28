Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32037C61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 17:58:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 424656B0088; Fri, 28 Aug 2026 13:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AE2E6B008A; Fri, 28 Aug 2026 13:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251C96B0095; Fri, 28 Aug 2026 13:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB4486B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:58:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 77DE91A04F8
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:58:41 +0000 (UTC)
X-FDA: 85151438442.05.F6AD033
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B9FA1C0002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:58:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tn2v298X;
	spf=pass (imf20.hostedemail.com: domain of stevensd@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787939919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2koS2vCzM8w7VNNntAyqh354TzQoKL9/yGNgBa5fxE=;
	b=VTiDOnKvxWS1fzYUK37QE+gQ8QfxHf1eo0fgR/7ytyUW2In4wasJDED7sPLeM2NgRXK/S+
	VeJSqrZqwKBtgOOocVWV4784IYenxBITAybTVrre5o8BCRK71OUN8WkiWFTz378I0SHqhq
	9siFvJY3T+Sgc3wdkKKm2UaUSyF+MMo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787939919;
	b=sjP8eChpe28PRonwSsAxhH+771AD7gee6ceSGr5ZNZPQQueSQS7Cwo8PE1jTQ43SjLe5/E
	T53XzadvAbgZYEscRzJcAuocQU1ppbqtgaZnyp9ixpAnJiA1LmHXM1HfNmqhuq5Y9bjm7B
	Pr5j5MYam09QwDRVWXwM/lcSDh9ZJ5U=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tn2v298X;
	spf=pass (imf20.hostedemail.com: domain of stevensd@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-498012a61f6so3225e9.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 10:58:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787939918; cv=none;
        d=google.com; s=arc-20260327;
        b=eWa4kvTjCn1uYJUOMW6GeF/zzZ85Dxd0Qe2DjiUhQ9/tVkzQz6JQ2L0KH6isAQ8m1B
         W1tVJu0vBW66vci8AKQPZY6GyXVKmg/qFheI4hMqvk4uQwoeAtc4cObuVn5w5NXSNfen
         2ELKyzDL51NRS0DaBEWgNvTzy5Oljg5Aj/APznHRhI10ofTY8tuL0ucNBlMck0ZHT2p9
         PS6mieAGXBgm4NpIzgVzBt4M7EhOEzcX0NQ+GVR0BfXOiXodKwDzPi2sMi0e49xHq1wu
         8BG+PfLIaOHLE8Q1oP3isTKpamHA0WwGnnUZJ5x8omagcwEkH18DcoyrermHT4BMvhgh
         PfZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R2koS2vCzM8w7VNNntAyqh354TzQoKL9/yGNgBa5fxE=;
        fh=jY/JT3KP5QH39i/PW67cGKxhNqe2Wqnc1FsM5/6etuQ=;
        b=PvjKvelMwqmnaSTNR4AR/UnAwNamQXeUL2iI+4Y4t0IkIDRw8RwULmtXc25D2IqOPc
         zVQQRLscEGmaiuQuiCwpv8xWxXprMxt/3EcOT4gLApUq0fac3UYlRiqAnZFWVsg7uzZn
         fi+Mt0iAZmC6CZHCoNfzq0UTw4Zwe2HxCq9v2NoRNCPKoBEk1sl5LoqOwnzVBFDCLsWH
         v2YWXvCt5H0XdG1xbqcKprTBD8HzhDdxocRIdHes/IOiE1uTKnBmEXVYvoRNs35SkMZv
         fYOMWXoEWH5/vTuiNDFIPF0P7m7GkOkPlVreaUhL6gOAQsaCSEXN+CMs2J9FT7A/QboJ
         9zag==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787939918; x=1788544718; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R2koS2vCzM8w7VNNntAyqh354TzQoKL9/yGNgBa5fxE=;
        b=tn2v298X5xB6q4V3gNU1SLBl3wcOD99TI0YQeB/QU+i2xzvEWAPoqa6CXxSfyCydoV
         bbpncfxjOrAKIjwg3HK2rb06Sn09lDZqpruE5lbpXMqzYQZLS0f7XgDD2u2RL5nvARby
         NIPNDoXQDGOl98S6CngDZO+Ps2fFuFT2LA8P5KzJvvCDGv7PQsUU4dCgb/yIo25x3kEP
         S7VLTTIlyoMG0yLNzsCe7Qxax0R6Curuxc40g5k1ZhfVsLVIiVG+AJrsIhKS89gwdHAy
         aLxm4SkEyTRaaANUqDgLW1B6mpyhEiGh7rjHLWWLX4Ll9qMmwANN6g2qYNCHY2gKaKTq
         yMyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787939918; x=1788544718;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R2koS2vCzM8w7VNNntAyqh354TzQoKL9/yGNgBa5fxE=;
        b=MUGNJzt/lzB/y1BYnwpkMC3IDDXaVKFiugrHWRNQZ8fYFywLlrADnvfSFxhjddqmAF
         TRC8MUPOb5ITCEhqU5ED7Rn8KhhCphCvQjW9BVrJp62FYLQt1naDjy5/jUkKjQe3JdMy
         ZY4P5TciNoHAmPV5wT0mFCKQBzqDm/biZx+i9zUTtnN7DTyvnCOPFDg7XfB9UC6gKKbq
         NsHqUyiCdvQ22fyxi1e/XJBvsqY1npnedvOPiBF6H9N8BG3kgtkm7l3hplM747RVEeUp
         OCuilN7FtCW71Kl/aMv5nw9l41SM1+MNGqWOtN5UHOSUouxnGHbQW5b4ajtT/pVsmnHT
         NGaA==
X-Forwarded-Encrypted: i=1; AHgh+RqmoI33myPKNiUo1J/L/Y5ls2UAJo/QzXoXSzCRpSlKuUbrF0z7DC5U5fj1CQDndggDpi+R/oR3uw==@kvack.org
X-Gm-Message-State: AFuF++nNBCWZ/i7iZd3Q3upMW7KWuPrYumTRMg/LXb5uPSS+LPwPVqh8
	OXp8q+XMb4W2sLx+CJ4byQ2NIpIp3Qcs2yRopn0Wgp3p+f+LRQZbDTNfn1XDBKLcdDM550mALWo
	DVRQVPIGpvguTlP9bm9b3GKNZdXHtQhKLysEaDvtn
X-Gm-Gg: AR+sD13lw7Om4Dmx3BYP4m/7neCWllpvjeJrnWqEyCuY1aqtRHqzP1FL1aMLW1P5HGQ
	1XVWPpvuS9fdF1JgPZdOr//jLAuxdWhLDXVGm84Rp86o2y2+KmN5l0MNXihBufB7onLuFr+kBzZ
	kQ+/YvetvAWxuAycGjmRFa9zjAa1R2MjqtgynF+u+QDyLKDyFDhdbN53hCzlkJYOm89sz6M7ERl
	1P40XHEtMt4pnUK/NhWEuuaqKr/mm1G+tiPc4V51b9SYGmdUOJgM/Rqx0ChLpfGEhkL1rK8Uo2U
	yI13YNSOW95pXCy9ikYoVpHiakfOv+tknvEQK5P2J0RYXzyBIt8YmxBb1JvsXGoyIcV6Mkc+tNQ
	=
X-Received: by 2002:a05:600c:6051:b0:499:c46c:addc with SMTP id
 5b1f17b1804b1-49ccbb107damr76865e9.2.1787939917426; Fri, 28 Aug 2026 10:58:37
 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260828124758.GP687043@noisy.programming.kicks-ass.net>
In-Reply-To: <20260828124758.GP687043@noisy.programming.kicks-ass.net>
From: David Stevens <stevensd@google.com>
Date: Fri, 28 Aug 2026 10:58:25 -0700
X-Gm-Features: AcwNN1WqLTUUK7Ta5eHOzidgwYbjtzO211AQh82X2UkIHuKv6OJYSJ2tvHu1D2I
Message-ID: <CAOiLmNGr385FOvdd9utJ6VYmngvRPbg8v6KfVVhFwmQ4oxhLSg@mail.gmail.com>
Subject: Re: [RFC 00/10] Reclaimable kernel stacks
To: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, jstultz@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8B9FA1C0002
X-Stat-Signature: ach6wm4mnspdhm9x1zujpa8daifja5y8
X-HE-Tag: 1787939919-950053
X-HE-Meta: U2FsdGVkX18Gq5yclaJ/jTSjfD7r2RGbCu5ORNBJ/vcURDTeSZUdCWxm2Lm5JwWo7N22s5fMJTKdPkf8Wyq/vYTI73vosDZkkK829ICmgCqVNDbHRQU4XI5Iq69ikLTB70lGAy1CeFj/DIQZ5Kzmhmq1vUXnePt/zSzZyCnwEWFs5h8/ZSEDfWyLhzyGkfbmc4Xz7gvMcD/T5QShms1HxeHfAGhS90QEZNnHaQmgMdJX82nX+D0XEMJ8mtcv9PA/L7e9MCfihnI1HBOrPS35ecu56L5XfujCdma7znNI+Yh2S1UYFkAZIkW9iyvye0PIwmpBVVm778aaaz7+QzIc35p2G1jRCb5G2XfzsfnNlq1pDpV2pF8Nf9ZynooakAJswvWIlU1RoWGyr0yTTKLyL0XUWhthHOWmWXFwa0YnJNiVdLzuKlVg15OkCrfsLcF6AEyyz6u9GYs7O5JJt2pljXTtjXPjGCUGhKQ4YvXHsMzY+hsaM2SXl53SzwMvEQ3lKcDPEgLUK3OPPIz7yi3M2Aa2pv7n1AA+zN7rQtdur22RAMPGMOC2yFyIBL5z+3Ld9tlGKUdzamDhOyB/eUQEyqoZMtOFMrOkELdYh5HtcC7Y3zp/e2tRdF01kB4xdHYL0SpOPBGRO1c1mUmQ+3FdDDIw0N0wDfksbPvAXW6yT9vHXmeLqaCdbaY5JlQnm8W1V8BvohXpVH+A3AoTn8fHWo91UZk8m8swR82ChVN7hb1AdP/aSFyc/IOhB/q3yvpqZ9GSdRlpMoforDIxw13TO2pTMBQRkVAb8dU4AScj3TrDOgZLhDN21FhhVP4u36U4uJKU5Lhloy3vT52GUackjMPLTOkJVBAJ1vBRix7jr+KKNpUEmxMIas+P4gbPORt3dCpcpTP4mR06mGSntxAOifTJkgv73/77p331Vp1Yp5Q8bTucmrMhD1zSfFukkLJ/2y8QnIRv3liUtBB4Ym0
 xPnB2dw1
 kRthjwaAcyGCMtRRh5pii1JKeFW/V8hX26b9EeQEF6fPXESNG9NCa34xnx/MmWFqjm1OoPT8SvWGuI3bUrCbGRqAPt1uWF/bKr57BYMx4g2cN+rt4kV5coA8tZOhs0WhOzJ1issbKbNJm+9DkWqsYAG3EtTpXB5IAfv6ipqyw2cs9htJCOZ3E+3jEdcF9fRuazkolqdjpcmBjHEDfynEpoE7szeiiWfhzepooV+8dnFnT3GKxSajfjUlihqDKF1i+QMs4dmP3E9MElOVsMHmwcBEd8UOiQ8vdvlVgdMRBf2JuphA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 5:48=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Thu, Aug 27, 2026 at 04:29:38PM -0700, David Stevens wrote:
>
> > On Android, system processes typically have 2000-3000 threads. App
> > processes add 1000s more threads on top of this.
>
> WTF ?!? Why does that all spawn *that* many threads? Perhaps work on
> reducing that some?

I agree that the number of threads is rather excessive, and reducing
it in userspace is an ongoing effort. However, given Android's use of
Java and its heavily multi-process architecture, especially once apps
are involved, there are limits to how much the thread count can
realistically be reduced. And even if a 50% reduction in thread count
were somehow achieved, kernel stacks would still consume upwards of 1%
of system RAM on lower spec devices with 4GB of memory.

> > Tracking blocked state and when it is safe to reclaim a stack is done
> > via a series of hooks in the scheduler. The actual reclaim of stacks is
> > done asynchronously in a shrinker.
> >
> > Once a task's stack has been reclaimed, it cannot be rescheduled until
> > its stack is repopulated. Although there can be a repopulation fast pat=
h
> > within the scheduler, reliably allocating memory to repopulate the stac=
k
> > requires a fallback path that defers the repopulation and wakeup to a
> > workqueue context that can use GFP_KERNEL.
>
> I am really confused. On the one hand you have John working on proxy
> execution, with the aim on reducing latencies, and then here you are,
> posting something that will introduce basically unbound latencies.

The two projects aren't contradictory because they deal with different
types of latency.

Proxy execution aims to solve latency introduced by priority inversion
between background tasks and foreground tasks. This can happen at
basically any point if you get unlucky, resulting in unpredictable
latency spikes in high priority tasks.

The latency introduced by reclaimable stacks isn't substantially
different from the latency from refaulting evicted anon or file pages.
It's a tradeoff between the reduced cost of cold memory and the
increased latency when re-accessing that cold memory - clearly a
tradeoff that Linux already makes. In situations where reclaimed
stacks introduce latency, there will almost certainly already be extra
latency incurred from refaulting userspace pages. I don't yet have
production data, but the testing I've done so far doesn't show any
measurable negative impact on user visible latency metrics.

-David

