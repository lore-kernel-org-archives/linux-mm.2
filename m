Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57B5CCE8D52
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA9C8E0009; Fri, 14 Nov 2025 11:21:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1AB8E0005; Fri, 14 Nov 2025 11:21:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C7AE8E0009; Fri, 14 Nov 2025 11:21:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7919A8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:21:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C7AE12E166
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:21:10 +0000 (UTC)
X-FDA: 84109727100.07.0B63D0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 46D02180005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:21:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFKJbFmP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763137268; a=rsa-sha256;
	cv=none;
	b=bWv92fYcqdwBP0qtIDOmMKGOryKdLnzUK+7lsh13Ilj0IA+njc5jQ0GjOwJt5vbQdsvRtQ
	myQ3HIXNg32+e2JDPY15k55A/O6D6tBcrqTKIUZHKo0k456xIqMJtgvBULXbIrljr7dA5+
	yAH9iFveJgHGoVFTbKEoikpKGuph1U0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HFKJbFmP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of luto@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763137268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqvTff2Pj5HRqpyM5KNpmtDRL7l0ixQO80OhutcIkUI=;
	b=hlwBjBKwboSA8NxuOiMHu5bjNrSxzw8e9+5QxtBxyFHnkKqD6BlfJLFB1BYv038kmlevl1
	VMQ/K1bV2UiVbWrtgU7VJ1GL440IhDbCcCglOV21iKLYJUEFI7biyEMvxMBaqGQ/yipXTi
	tCoPVOWKqIthWDedlbaWplRBfs31/KI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 926BB6017A;
	Fri, 14 Nov 2025 16:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D38C4AF09;
	Fri, 14 Nov 2025 16:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763137267;
	bh=sdAOBvzBQbQ58hWdafyr1VicSS+CMEqs0nYJg4IbVNc=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=HFKJbFmP9Ujt3AKc7/UDrJzlJi7JumxeosLUkWEyPeklpq5OZZt72yyohcI3A8DjR
	 Q5Vh2zAeFMd2IiCnte0N/XnGK6DNbDRQ/7YvQ5lhwqg9RolCuYDSpfKJqS1B0vZukv
	 WRM5Cfpv4s2uQBT9XQpMmVhLg7RU2QrLO7TehZVkVvfsiLOIriL0AHuR7xxhksMb0r
	 rQ1Xr54dcBhj8eF/NMqOjBRjmPKn9v4PpWEBURevuz0YH6yMHvvs4zxmhQOC1HiZt1
	 eaXuznue691T9OUZ0Tb36FWCOYcv7m6yoU4B67wWFVQhqHzZSTrRZF2fY0n7ubjqfK
	 3ELPPESaDQuog==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2A926F4006D;
	Fri, 14 Nov 2025 11:21:05 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 14 Nov 2025 11:21:05 -0500
X-ME-Sender: <xms:8FYXaX1xeo7cwPzIqK0lN7OWVpvdACGCH0_QR-xqptpdj06yrqDiMg>
    <xme:8FYXaQ5044wGZzeghlvmdCODRvYE2agaizWczUnN-jUKKWRJl7iq7FAPf_6mDi1Nk
    _cq58VZC_S-DwQ4rAg_2zGQMltJ_hj7flJjkLTIUdudS5euDrsHNIs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvuddtvdelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehnugih
    ucfnuhhtohhmihhrshhkihdfuceolhhuthhosehkvghrnhgvlhdrohhrgheqnecuggftrf
    grthhtvghrnhepkefhieejfedvueejheehiefgvdfhjeefjeelvdfghfelgeejudevleej
    uddvvefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    eprghnugihodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduudeiudekheei
    fedvqddvieefudeiiedtkedqlhhuthhopeepkhgvrhhnvghlrdhorhhgsehlihhnuhigrd
    hluhhtohdruhhspdhnsggprhgtphhtthhopeegkedpmhhouggvpehsmhhtphhouhhtpdhr
    tghpthhtohepjhgsrghrohhnsegrkhgrmhgrihdrtghomhdprhgtphhtthhopegsphesrg
    hlihgvnhekrdguvgdprhgtphhtthhopegrrhhnugesrghrnhgusgdruggvpdhrtghpthht
    ohepuggrvhgvmhesuggrvhgvmhhlohhfthdrnhgvthdprhgtphhtthhopehmrghthhhivg
    hurdguvghsnhhohigvrhhssegvfhhfihgtihhoshdrtghomhdprhgtphhtthhopegsohhq
    uhhnrdhfvghnghesghhmrghilhdrtghomhdprhgtphhtthhopehurhgviihkihesghhmrg
    hilhdrtghomhdprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhr
    tghpthhtohepjhgrnhhnhhesghhoohhglhgvrdgtohhm
X-ME-Proxy: <xmx:8VYXaavy2Rcw5_KExroGJoSP4RswQNujNsiylB0Zboj1MLJmYGXRMQ>
    <xmx:8VYXaZY6rZhPaBTbMRdgxZfVoWO_tE57Uf8RTZRFKYMUkM6OhPqO7w>
    <xmx:8VYXaXq_i9JHyksMPvKjGa4dS9KQQoAc-nePruIhtsmCgMAuL00tWQ>
    <xmx:8VYXaQqiB1qrgBqZ3MW1P6T2OaapMG_gHq2V-9XZpin12vZyrdLMFw>
    <xmx:8VYXaUXaaOeVLlHat2d5uQs_qjo-uL7EhSwfZcFtiahVbx-tqC236JT4>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D4A0C700054; Fri, 14 Nov 2025 11:21:04 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ATddxb8eqn9V
Date: Fri, 14 Nov 2025 08:20:42 -0800
From: "Andy Lutomirski" <luto@kernel.org>
To: "Valentin Schneider" <vschneid@redhat.com>,
 "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
 linux-mm@kvack.org, rcu@vger.kernel.org,
 "the arch/x86 maintainers" <x86@kernel.org>,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, linux-arch@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "Peter Zijlstra (Intel)" <peterz@infradead.org>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>,
 "Josh Poimboeuf" <jpoimboe@kernel.org>,
 "Paolo Bonzini" <pbonzini@redhat.com>, "Arnd Bergmann" <arnd@arndb.de>,
 "Frederic Weisbecker" <frederic@kernel.org>,
 "Paul E. McKenney" <paulmck@kernel.org>,
 "Jason Baron" <jbaron@akamai.com>,
 "Steven Rostedt" <rostedt@goodmis.org>,
 "Ard Biesheuvel" <ardb@kernel.org>,
 "Sami Tolvanen" <samitolvanen@google.com>,
 "David S. Miller" <davem@davemloft.net>,
 "Neeraj Upadhyay" <neeraj.upadhyay@kernel.org>,
 "Joel Fernandes" <joelagnelf@nvidia.com>,
 "Josh Triplett" <josh@joshtriplett.org>,
 "Boqun Feng" <boqun.feng@gmail.com>,
 "Uladzislau Rezki" <urezki@gmail.com>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>,
 "Mel Gorman" <mgorman@suse.de>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Masahiro Yamada" <masahiroy@kernel.org>,
 "Han Shen" <shenhan@google.com>, "Rik van Riel" <riel@surriel.com>,
 "Jann Horn" <jannh@google.com>,
 "Dan Carpenter" <dan.carpenter@linaro.org>,
 "Oleg Nesterov" <oleg@redhat.com>, "Juri Lelli" <juri.lelli@redhat.com>,
 "Clark Williams" <williams@redhat.com>,
 "Yair Podemsky" <ypodemsk@redhat.com>,
 "Marcelo Tosatti" <mtosatti@redhat.com>,
 "Daniel Wagner" <dwagner@suse.de>, "Petr Tesarik" <ptesarik@suse.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>
Message-Id: <c4768cf3-f131-44e6-9b25-ebeb633f32ee@app.fastmail.com>
In-Reply-To: <20251114150133.1056710-1-vschneid@redhat.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
Subject: Re: [PATCH v7 00/31] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46D02180005
X-Stat-Signature: emjqww6fzrukijgky18epih9saurgshc
X-HE-Tag: 1763137268-698323
X-HE-Meta: U2FsdGVkX1/IpyrfmU3sWEttPZDrtR/oEwQ6Iqgv+F1Wo5QlupkgltC3DI3VoXFOkJed0DxIUz+sOQSocQy/5YkSTp60h721+930uLnsxPEDwhSMC9Zwl1Uv2pbJcSHA4FWJZ9+U0sfbNmX2ww/A8X6YbY0HPz07dWz/FpbxEm3ARrbIUzp4JyGVBi7b44PoNSmYqTkoxYSIy1zebaFtp//6LQ+1TwrnMlQGPdgyPFopIQcw95U5qwK4/uPsH5YXadzQ1Ra0Z3a5Ev/qVTEyf/w6e5xdjpHBu5M5hPONDVPYjr5UfqK8k6dIvAUX1U0sUBB6FrR9Kjtp7Se/U24JEx2jaNuQmeh3lC0wQLckWH9k/Tt3xnaDwNZ8DPtx7wPDP/klbQmPOpYlLZZ5NBU4y75zaehmL4Q1xVZ1ktlJYJ/tkANbZJM824muHR4EU/SO61HhWx1134UonAeTyR+QkkAwkIIZ5j8JPINA9ohD/j6LXZ23SQXnIxJTMHfySUxuXOuggUHXkH5C9pjVxs24+lNArwSm7fk4d7IaSKuwbYDuLTyKRdGdhO9H6cuLzyiWGyD4RrKBEKJ/NKJ+NI4S0hBHbHIvDwSkf2QLGDqtHhLkZRjvQe12Jb0Qy2ZBp5wXmIuuwG/4vIUJaOXCLMgrYPLuLTMJyqc+5le2JaOTDb+/TWJlPTacTI2NNqv7suDMVhTs5M07n1luEbHY7WjseONXHv1anCb/9ondk81/KYTcw3VKGy11Ovk9MmHItUgZ7FJ1ZXJ3OKgXYNE0/8tQvBO5kaZTZaV6NUBV6YuSAjHTjFahaL28uDKf7ZvZiXExQaeSCmpGRVbbR3qfG91Jhd/ePuAlZQCCW3LVYj7hnt5561kQ/WnrDzy4UCY57sTaUUg5OFfOTTD0IJp1RS+w0xRbzzvCEALIGBGMOD6v2BsY0KBJKUjmav0LX9uuvhRomWF7qzVCxwqHHBU33Wq
 N17EATue
 lLjMjk0T5/otkXjEq5nJuGhgFe3XEHJ2mcYd3fPGKnApyiLK1Y5K0xXRZwOLFLs1z834Pjl2fYWWOMJdWVXVw6xQN1Hy9C0rGiM6zRBUMZLLdR2LHWf/u5cdl3kGauZINIeDuPSo51NTV8frhOU8NYQ/VzSNQb8fbKim15OSrYOcyDs0XhYI9dfiK1QylHTGwdLLvIrZV0yKRpYSy7McPmKEqjnZhSasE1bek4vpr8/MZCPM6TsUsk6B86I7h6hm0jDdgU7BRmmQUz11TNRAlVDuazZuXteQtVF2SuQbUrDKJRiD56hRCDS+5Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, Nov 14, 2025, at 7:01 AM, Valentin Schneider wrote:
> Context
> =======
>
> We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
> pure-userspace application get regularly interrupted by IPIs sent from
> housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
> leading to various on_each_cpu() calls, e.g.:
>

> The heart of this series is the thought that while we cannot remove NOHZ_FULL
> CPUs from the list of CPUs targeted by these IPIs, they may not have to execute
> the callbacks immediately. Anything that only affects kernelspace can wait
> until the next user->kernel transition, providing it can be executed "early
> enough" in the entry code.
>

I want to point out that there's another option here, although anyone trying to implement it would be fighting against quite a lot of history.

Logically, each CPU is in one of a handful of states: user mode, idle, normal kernel mode (possibly subdivided into IRQ, etc), and a handful of very narrow windows, hopefully uninstrumented and not accessing any PTEs that might be invalid, in the entry and exit paths where any state in memory could be out of sync with actual CPU state.  (The latter includes right after the CPU switches to kernel mode, for example.)  And NMI and MCE and whatever weird "security" entry types that Intel and AMD love to add.

The way the kernel *currently* deals with this has two big historical oddities:

1. The entry and exit code cares about ti_flags, which is per-*task*, which means that atomically poking it from other CPUs involves the runqueue lock or other shenanigans (see the idle nr_polling code for example), and also that it's not accessible from the user page tables if PTI is on.

2. The actual heavyweight atomic part (context tracking) was built for RCU, and it's sort or bolted on, and, as you've observed in this series, it's really quite awkward to do things that aren't RCU using context tracking.

If this were a greenfield project, I think there's a straightforward approach that's much nicer: stick everything into a single percpu flags structure.  Imagine we have cpu_flags, which tracks both the current state of the CPU and what work needs to be done on state changes.  On exit to user mode, we would atomically set the mode to USER and make sure we don't touch anything like vmalloc space after that.  On entry back to kernel mode, we would avoid vmalloc space, etc, then atomically switch to kernel mode and read out whatever deferred work is needed.  As an optimization, if nothing in the current configuration needs atomic state tracking, the state could be left at USER_OR_KERNEL and the overhead of an extra atomic op at entry and exit could be avoided.

And RCU would hook into *that* instead of having its own separate set of hooks.

I think that actually doing this would be a big improvement and would also be a serious project.  There's a lot of code that would get touched, and the existing context tracking code is subtle and confusing.  And, as mentioned, ti_flags has the wrong scope.

It's *possible* that one could avoid making ti_flags percpu either by extensive use of the runqueue locks or by borrowing a kludge from the idle code.  For the latter, right now, the reason that the wake-from-idle code works is that the optimized path only happens if the idle thread/cpu is "polling", and it's impossible for the idle ti_flags to be polling while the CPU isn't actually idle.  We could similarly observe that, if a ti_flags says it's in USER mode *and* is on, say, cpu 3, then cpu 3 is most definitely in USER mode.  So someone could try shoving the CPU number into ti_flags :-p   (USER means actually user or in the late exit / early entry path.)

Anyway, benefits of this whole approach would include considerably (IMO) increased comprehensibility compared to the current tangled ct code and much more straightforward addition of new things that happen to a target CPU conditionally depending on its mode.  And, if the flags word was actually per cpu, it could be mapped such that SWITCH_TO_KERNEL_CR3 would use it -- there could be a single CR3 write (and maybe CR4/invpcid depending on whether a zapped mapping is global) and the flush bit could depend on whether a flush is needed.  And there would be basically no chance that a bug that accessed invalidated-but-not-flushed kernel data could be undetected -- in PTI mode, any such access would page fault!  Similarly, if kernel text pokes deferred the flush and serialization, the only code that could execute before noticing the deferred flush would be the user-CR3 code.

Oh, any another primitive would be possible: one CPU could plausibly execute another CPU's interrupts or soft-irqs or whatever by taking a special lock that would effectively pin the remote CPU in user mode -- you'd set a flag in the target cpu_flags saying "pin in USER mode" and the transition on that CPU to kernel mode would then spin on entry to kernel mode and wait for the lock to be released.  This could plausibly get a lot of the on_each_cpu callers to switch over in one fell swoop: anything that needs to synchronize to the remote CPU but does not need to poke its actual architectural state could be executed locally while the remote CPU is pinned.

--Andy

