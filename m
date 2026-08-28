Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED6CC61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 21:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C106B0088; Fri, 28 Aug 2026 17:18:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFDD06B008A; Fri, 28 Aug 2026 17:18:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC7A6B008C; Fri, 28 Aug 2026 17:18:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 767D16B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:18:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEB6A12058E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:18:07 +0000 (UTC)
X-FDA: 85151941014.28.D80BD9A
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id ABBFA14000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:18:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=umJtOws6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of stevensd@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787951885;
	b=d7vT68lrvZ79fjY5e2QKWLkGVy3WpCfDVWrvqbOLjex0rDh8Wk7H6NHNj/Xq6neQDfCQWQ
	qr2nDi0kdasSbULy4ARyi+O7FcLDJc8ffcqOh+ltu9TkuyN1VC3oB9GEiwamuSzmMClMAR
	mvjRUP/0g+rD5FGV1LmNm4phhtY7Mws=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=umJtOws6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of stevensd@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=stevensd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787951885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ox47LSGNLn4iYQakTpAdrm+z1IZQvt0QyHLEVX+5st8=;
	b=SAr8okkMvLpAV6n/pakABuimNQalb7ajnGJoTSKCJ5d2/FuUv/kaClI/oXmwVuWVpTHHgN
	Sc4IrSB/qb0pYKXLDIWHc57tBj/50kHwj3cOtlLcDS4asHaU6E1uVAw/O4GGv13vt9R5Yx
	xdJJBKG9j3YRj4zCvRz6BgA3jYoacNs=
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so586e87.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:18:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787951884; cv=none;
        d=google.com; s=arc-20260327;
        b=oUM/MvNJYr2djmo5XhHCg+482OYfB3ovdt1TMtXnGvIl8HqnwHx/321x5tQ9fekPZ4
         Af1H7PYi8xFPX3a5D/F4Xr1vFlVRV4zaZ83g1fA3weSiLSh+9p3QQyDb2n+qvlQkiNwF
         in7dH0g5saK+/PL2C1cQeR3fppO+hVqfZG+DuqqU51hZ58ImEjuzHn757qDzVUYLwJXc
         3yXwMvSH6/D7TPXKeEJZ/TZlNK3FllLYbyh2Sp3rTD/4JHQyW9YcDz+zeFQLlscSxbkT
         AXUmVb+KU5/67Yc232UlQr8JxSDjbGeKVrPfykQBTb+HVF21MslBUj9UCloC6Y1ig19O
         K1KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ox47LSGNLn4iYQakTpAdrm+z1IZQvt0QyHLEVX+5st8=;
        fh=URv6Jm4OymUrbg0Diea9Y4/a/WAW7vZNdyJ15uj60Ss=;
        b=W6RWsoMd1CXxo20uD1zFlXJWPUuhncke9yUcq+vzf776HrH0HM56r60gXBIsNwtQfe
         w9+qTG3fg7OEQyCJxcKPky9Z/9iv8EoMT5Z0gfi/n9M4e4GeyVgwuH9zUCuQkh98SNXP
         Rrbwi+3wab3bj+0VlwcbEEsuB02gL96wT9VbdmgtpjmTcFESbbDP2xTa7Rky4884xK/8
         u8ngb1cIYSHHibsO3aqFuTpo29BUbaBXBZLEBwejPJ8kYxTppe4YNB/uba/0WRDX6KUW
         a5iiOFt35axoNFrEEk8Y+j69CwKCLaT/ylw91PqxOfkmEOydZ9DRJVIE14Td7/4fK1Dn
         CmLQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787951884; x=1788556684; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ox47LSGNLn4iYQakTpAdrm+z1IZQvt0QyHLEVX+5st8=;
        b=umJtOws6OmxFfCh0O9Jo6IZ/9GpmPcptf8uAh/RISOonmXVWE6xFZXFN6Ui/7PcUnz
         mGD1XE1xaZkrkF2+kExctC5X4/mlOStXViDxxE3SW0PMDJd9IqGtyXVl61SRxe5ifLMT
         cMMcwAlloV47YV1XgHrP4k77/sOvedxgBLk/KGgA72XDpd/8xWwlJdK0Si9DPnNAaL8S
         e6TOjbU7exxv4+BVp9M1DuOayEDoPGWtEzrl5kBWesfJYuYspwzu6+6k+TfANCxNyw74
         MOUKUxhf2DhOBoPaHMFnreIZvthYSsvZpoTVdacGQBdtmK8kK3oTzxns4K4eCX3zyf55
         iMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787951884; x=1788556684;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ox47LSGNLn4iYQakTpAdrm+z1IZQvt0QyHLEVX+5st8=;
        b=rRFul0zQ7v61sD23VCQpT2YBLC4+9neIRxQEG1rbWJJJBwx2gKXRK4VRTehlD37f+1
         3qGHScaco162IMkvXP9zp56dE9fMMZ3MOV9PYHT0PwA51h9jlRuimrylXJtRoQjmdo0/
         /dSp8UAWpc9MiWfAygRhvSvUYRFdPFMW/OjYA1JzzxS97R+4vPMXr0V26dx887tHen5R
         udHT5ZgXoxaNUbW5kyJ9lbbfpjCPHu9vwhrHEsMPb4iTulF+YLfG/rEJEGt54MsmhNmx
         tR31GAiV/f2T2ibnOvY4Q6E7d8M0Vjn8R5OjYfFIrB8uUU0NAKJUq0NT43m2wEwyFTgP
         R5tw==
X-Forwarded-Encrypted: i=1; AHgh+Rr2F8UGPCmPTrBWbsJGz3Xte2CKWSzXwWQ5f+KumEhsq6Dse0BCWZrXlAsrEMy5+zEfmH2Ba1SpQQ==@kvack.org
X-Gm-Message-State: AFuF++kw1Go0n4FL3Ulq+a7KkTE4TbjRDojk+ZLzSwDEpbrQ/jsEVr7H
	rAGeLTkArGLSMJkyeY7lOFVVAr2bcwDjTI2UMp7YXisYK7FaUBAgAG+jLc4Q3jYu6fS4Ybul+fg
	yLje5tSlonI/1g/EdgK2gO0cxdUcTs8Af8RiunXej
X-Gm-Gg: AR+sD10vv/gzFVWO9/JCoUlI8hAWXADyCMRX3Brw3UfZB/6dTUHMt1rZX8sNn/T0F0y
	o4fWLKbPigA0Xasptfcy5fG0a/H5GjjTCAevuYLOjZ3kmVcL9grVqxAFAESSFSe/J1sQP5UG8M8
	Czh5kBRbxbLO3I00ba5fY/PCt0DOZ/gjTu2wjWT9+o+W33JEyjELqkPpNXUTps5+k2u/krtdQBf
	NlsQLFAaK2siqyXVx6gF29Iykss6pBHi1iYYn32teP2aOxF/PgJc8QbYui3YxHttv/VOqIwReVA
	0iBFskSsdC3Yf/Dovs7OQo2LZIbNjSuBRvpZi6HMD4c4adhzQuYKMzfNCOw1nuqn51SPOdaU20N
	B
X-Received: by 2002:a05:6512:1594:b0:5b2:a967:c0c9 with SMTP id
 2adb3069b0e04-5b5ef2283a7mr31129e87.7.1787951883225; Fri, 28 Aug 2026
 14:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com> <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
In-Reply-To: <20260828133620._x2XfJR_@linutronix.de>
From: David Stevens <stevensd@google.com>
Date: Fri, 28 Aug 2026 14:17:49 -0700
X-Gm-Features: AcwNN1XPwhnUNeipFck3Fo-JT824naG0Joeg5blGOWBTdqacwVpK3ww48maahZk
Message-ID: <CAOiLmNHK5Hw55omycg_EAHzi=g1iqJn1NTap1Mt98im3xTXcvA@mail.gmail.com>
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABBFA14000A
X-Stat-Signature: 11hnztksd98arm783jhnpzoao31dq16c
X-Rspam-User: 
X-HE-Tag: 1787951885-930236
X-HE-Meta: U2FsdGVkX18FmeM/XHisNG14kJ1Tngapwu3hOC9qJfVL1zZ0a3Lo42WULc58/xDeWldpOgWeJB+FJ01nIXlss+3uhv7b3vEK04hutLv4BMOD2O3a/+DN/tHut+3nsstn80oclcL/cbHQiYbmvre+qDyOCsWT4oN0QUiDE8KnbBitf0gJaLriVvjebjyh1TcE4FyrhnSQqpAXEmuY/OxvQ4vDELRchHirkSaKuT0ZvUmwCpZy/zftIy6ZcdIwoRqlHEuLLtZBHeJWPADSyQggMdkXSPLuINWISKJiZsuaky5YRXTibLoGTXH2BBcoBUkEMt4YCaQsRJbK8nYn0m3lKJEUwiKcXHBZOH9Vw53eeNem+avJoaPyRhEtUB6QufQckuWSV6MmYl7m6/aDAjaRwvUM69zqsPGTP6lj3xBttu6Ta67TSr+VUmHvK7zC/0iz5v3jDXLlChQZU2tFw8CHRq+casK9mhsEpOrbSbjr9AZkdDNOBsEYq29/elhtRPJBBJqluA3vCOGlinv0c3PhN4NboW7C7rS1Ziq2zUeM9fYHBCqyGB9fcNjgOhhdSaTPF6x8gpQnmy6VwV1zfTJSZFpACRsDKpbERz0xqV5zHbdg9TPjNMO91Es3cON8nESp3KXkKPEUMSxKT7eIVYNdMkIq1dkOSVhI7J6gfCxB0uFoGsSu2EQlzarZLNmxrR1AJX0lL0azeg8BY7vF5AagbApUb48A70oJHOYy3+OI9N4PTnEsv3cxkBKA6BglPUUIkhiNXYrtPAj+ECSz0oIAXIP8Ada5U2x5+RKLjL2woSGu9k1DvCDq5gzaf7MnoGD4xuQVtanQdy2wNAfFNCdgJOKf0OdxUZ/3jsR+D2hNMuEDeW5RjI97s15X2DrQODUnNhyPIo49Yoc9E8wlrJKyX4qJt4JSByD+kCCZfOYLKGY2gLXOg8voVVibPsNjAppKFld5bFFGhBV+c1wB0GA
 eGe2S6Xh
 99eeOjwgum5Oh8KgexF8ny0QFP0JTpTjTZPs6n6lVlZgbEcITe6q8CRB6J9WuI6KR1z3P8vMKp/s51zYPT3ZfTfgwvoiMTFOgDDQYbRY/hho7agfsWFvw5pK7Ri4nR0UiNHr2PMEIZgASKtqwpw2MG3i+qJqzFrVYJzkTsf1RNld+H7Q0OcUVD38aErdPCJnwxeELBBMO5rJf2x0S/N8gWpPthSBoRZEsQQ2moR4NuZdKdFZV7aTPp453sl4R6gv04Y9tnF2LDiK0PS+0h/dfQw21pn3IRo/4WCIc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 6:36=E2=80=AFAM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2026-08-27 16:29:44 [-0700], David Stevens wrote:
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index fa7507ac8e13..adb4a5957996 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -1534,6 +1534,24 @@ config VMAP_STACK
> >         backing virtual mappings with real shadow memory, and KASAN_VMA=
LLOC
> >         must be enabled.
> >
> > +config HAVE_ARCH_RECLAIMABLE_STACK
> > +     def_bool n
> > +
> > +config RECLAIMABLE_STACK
> > +     default !PREEMPT_RT && !PROC_KCORE
>
> This shouldn't default like this for RT. It either is useable or it is
> not.
>
> > +     bool "Allow stacks of some blocked threads to be reclaimed"
> > +     depends on VMAP_STACK && !STACK_GROWSUP
> > +     depends on HAVE_ARCH_RECLAIMABLE_STACK
> > +     depends on !DEBUG_STACK_USAGE
> > +     depends on !KASAN_VMALLOC # TODO: add support for this
> > +     depends on !DEBUG_KMEMLEAK # TODO: add support for this
> > +     help
> > +       Enable this to allow the unused portion of kernel stacks of mos=
t
> > +       blocked tasks to be reclaimed.
> > +
> > +       The wakeup latency of tasks with reclaimed stacks may increase,
> > +       especially while the system is under memory pressure.
>
> It says *may* increase and on RT it _definitely_ will increase since
> there is a kworker involved not to mention the memory allocation itself.

You're correct that this phrasing is wrong. A more accurate way to say
it might be: "Under memory pressure, tasks that are not scheduled for
extended periods may have their stacks reclaimed. Such tasks will
experience increased wakeup latency."

> Anyway. This either needs to stay away from PREEMPT_RT or find a way to
> exclude at the very least mlock()ed tasks.

Disabling kernel stack reclaim for mlockall() tasks definitely makes sense.

> Did lockdep see this?

What are you referring to by "this"? I did stress testing with lockdep
enabled and didn't see any errors, although I will admit the bulk of
that stress testing was !PREEMPT_RT.

> If I understood the whole exercise correct then you have a kernel stack
> of two pages and in best case you can unmap and release the second page
> while the task is napping.
>
> What might be a tad simpler is to memset(,0,) the remaining part of the
> stack. Since the stack is vmap-ed it should be swapped out on its own
> without additional tricks. That memset() would help zram to compress
> better so it uses less memory. ta-da.
>
> What also should be simpler (and I am not saying just to move you away
> from the scheduler) is to have a shrinker which iterates over all tasks
> which are marked for reclaim and then similar to swap just unmap both
> stack pages and release the second page which is not used.
> Upon wake up the task should create a page_fault which would be used to
> allocate the second stack page and map the whole stack again.
>
> This sounds simpler.

There is no swap for kernel memory, only user memory. I did contribute
to some previous work that aimed to only only prepopulate one page of
each kernel stack and then to dynamically fault in further pages as
needed [1], but handling that architecturally and guaranteeing that
memory is available when needed is difficult. Full-on swap to zram
within the kernel would complicate pre-allocating pages for kernel
stack faults further, since you could start getting inter-thread
kernel stack faults due to blocked tasks putting pointers to their
stacks into waitqueues and similar structures.

[1] https://lore.kernel.org/linux-mm/20260424191456.2679717-1-stevensd@goog=
le.com/#r

