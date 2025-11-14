Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87D93CE8D66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB44A8E0043; Fri, 14 Nov 2025 12:23:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B2B8E0010; Fri, 14 Nov 2025 12:23:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0BE8E0043; Fri, 14 Nov 2025 12:23:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C99918E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:23:02 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A371B160434
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:23:02 +0000 (UTC)
X-FDA: 84109883004.15.A5C0096
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 814A01C0004
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:23:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SilCQx3X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140980; a=rsa-sha256;
	cv=none;
	b=odCST5+tQTBUm8OP3PffUnKxpSKYCIFoP5cZaYCnDmI0yYP56KnOnYUYAzld/OWv3NZRMR
	D69HAiYp6iOW4xurob1AE4QmVk7s5anvZH02QcnKZyYlZ529OXXHLqxtNFiirkRKxeZTBd
	/xjrpE5btQ7B5QD2rKFgYo+YqJyTq3M=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SilCQx3X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ktqio2OEURAwhleSq3+vUMIBSRgZxdIBnxmsmD6CCRo=;
	b=74Jfx/Aum5wNfNCfE0Pxj3VoWYSkvtciiWXlVxdljRRIUD54a34waxDuE5XnQClYrhBHVa
	SylAvimUZTYGKcfcntkAxJhb+ZBtdvvvfJVIEAFGtZeiUztZfB9+smn8HF8o74XnJJJks+
	UPAxnmd10HpbjlVdXongiU0zN3O0+28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BEC74024E;
	Fri, 14 Nov 2025 17:22:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3554C2BCAF;
	Fri, 14 Nov 2025 17:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763140979;
	bh=Wn21IOPfie55Agjgm4yTzq64wt8lPfqbNjOydlIl3ks=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=SilCQx3XmZ/NT8jwjxoviXOlaW0MBhdKaK6ghe5sIAgoz9gNP5gqiGgaBzCDfxJZ2
	 uwfxVWw9QqMQf3GbzhmEL3u6qpm8JOKoFwj8Q7DAuUncFSOrJM/hzT6qwnHvwqvbfQ
	 oDrzf/fHlG/2xevvDVaAtI02uGwk1Pv+dAR79Ks1zmz/u3yWKFR5UOt0JXli8z4LnR
	 KTi5T+TeAhz1F5mjqdf98BKqgS8vj9Tp0ZwQoPoleNSgSmWtvgvTrEfi11mRoMfNNI
	 SSI1qvuG5BkP5bBCd95C1BWlAQl3+FrhQcJj8NmGaoz0snW0FJ6l60v4DX0whLV1QC
	 pJGqjk8r/bbPA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 89FE8F4007E;
	Fri, 14 Nov 2025 12:22:56 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Fri, 14 Nov 2025 12:22:56 -0500
X-ME-Sender: <xms:cGUXabwEqVEpa1Pu5wTjk4joAbVQryrNMlkH96m6Rqbgt7emLRj7LA>
    <xme:cGUXaeG_FuBKBhhpWNSN54290UOZDu1nnTWl9eTRn5OyT5oiOC7K0UK5QkLRFRCCH
    _hZOI__w0Gxd-nD_URIR5GlTla4_kE-BTWFle1bK4W2HQwmeUxvlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvuddtgedtucetufdoteggodetrf
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
X-ME-Proxy: <xmx:cGUXaUDpJ_uK79SK7Sbacr87uFV8wZEsIf2pIISOfwTkBCtvWlzrEw>
    <xmx:cGUXae5Y61eVBcZCaJHzDtO62XxeGCqtc9VUtRcQqNlU6sq2BPHPDw>
    <xmx:cGUXaR33ueH3p4j58OA_EkrtZ_VytmnamzZ896qedlQfrBIvZjLmpg>
    <xmx:cGUXafVOzTzxUTLUMYvZY7NoWG8psGhITslD4bm_amg0iRE7ssFf3w>
    <xmx:cGUXaWk7Pm5SeQEG2tIMjhRAiJsTdItwmKq4_ZH92byZlKEjJy-RgVcM>
Feedback-ID: ieff94742:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 490B2700063; Fri, 14 Nov 2025 12:22:56 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: ATddxb8eqn9V
Date: Fri, 14 Nov 2025 09:22:35 -0800
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
Message-Id: <beb46a02-b902-438b-8b6d-b5f0d7ad0ae6@app.fastmail.com>
In-Reply-To: <c4768cf3-f131-44e6-9b25-ebeb633f32ee@app.fastmail.com>
References: <20251114150133.1056710-1-vschneid@redhat.com>
 <c4768cf3-f131-44e6-9b25-ebeb633f32ee@app.fastmail.com>
Subject: Re: [PATCH v7 00/31] context_tracking,x86: Defer some IPIs until a
 user->kernel transition
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 814A01C0004
X-Stat-Signature: rjrxyc7xg5xp3hj8q4yk376z81i5zen3
X-HE-Tag: 1763140980-24035
X-HE-Meta: U2FsdGVkX18oTTKMaLSm0l4GbW1tMLDqBvp5MBtADzuTbgy8F0iqTtIpp8wNID5kQ7IqzOLZoS3THLCxtV7RX+QhXGKImHFUaPxNE4LhSW1LViOb1b9VMmhgfmV1HfHBuqgSjgtds9Qlcx0whPODkCylQLV06B8DlC841rrV+3g5xGnJsX/RbKOIhv4CAoY3GBcpSU6uyOvlGwlAoIIrsnGP1aM0CiO7leHrd7mr2ZNvmiUjoPZYwY3eka0s7/PZKCRymzFn1EMvlV9/EJs0VIeXDO4n+DNeQ6ihT6H055dWTMg7+wgGWH8cZ7zzgBokZNebsMsayleTLfPqznu0dw+IqJfV9DD22cm7fUozddFRhVW75nOFRJF2ltimvDc2mmbHfHQ9D4Ly7Bz1AM43am0iS5q+u+DC6uefBo3LqjTcRoHJR7z5NCaQZAxNiNPA90eCDZyHgeuxm3hWbz0xR7jtccnyPoXK6Yi1yu+Ie2wBeNggQjA1WT/QhmQDht3pI6//BXCdf8bxi8+jr+CQyGB1cXZY+Gy4lwu5HuCmFKcwxT1Ve8qPwALI0arvBqFu2XsbsUOb2VsQ+eth4ad4323E6XOi/1PbORzQG51J/msinvo5bSq6WEwwDSDNKTyBM0XNcXh8IeLLzwlvj9rW5zxZoVWpT/Tn23w45nqwHaN4ivGTPxvq+F61mu6fipFtfI8KoYt2wWdPGeTob16yGZcQYnfKc6oDEEVyG4UdZQbLISvv7LqvnOUe9RR3ybB6a3eJ9E0y98z+fC7SGWU4VM/9p4DeXa8pez1j7vVeiP2s7xfdR3DYWisD4c1g2ogpUapkH78BX/lrrKRnG2mQ3Fj9dj9mRSwFI2PRSKCLPcnO+/FeaKuk29FxyXoGt7HyfXTvDOZAskmUp5H07f/0TPAthZvdgHZH38dadlWPwQ51nX8LUqb2zTFTVk6pFFJjTcKy32+u+teIC2bCqhs
 PuoGxX7Z
 pa1Nqm9bpgeDWRVMKNHBQj5ll9/SILd20NEvdiaqL0fQdzIJbK55DwUH8Pa6RHme8FiLjnNSMwXN6BuK4LSxaF8gFLCno9f2tal8Q3A5HM39HZZWqHvSCah/GtBQl2drG4ao5B3GAvz/OFFDo1+Zk7QD/4gtdu5QoWJ6AUdSukKMB3fg7iZImnXMj439MKSAWgKFbA0yaWHgW4BM3if9UCShac4dLKTxb0RRr9zehRdV6vgKJaHm+FVgzJrC4RhBO7mEpJo/R2t0hAcf91/yRQCPTnqZ1L5anERqEjo5PWMAZG2SYEhrEopseOLVWh8oqaUbj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, Nov 14, 2025, at 8:20 AM, Andy Lutomirski wrote:
> On Fri, Nov 14, 2025, at 7:01 AM, Valentin Schneider wrote:
>> Context
>> =======
>>
>> We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
>> pure-userspace application get regularly interrupted by IPIs sent from
>> housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
>> leading to various on_each_cpu() calls, e.g.:
>>
>
>> The heart of this series is the thought that while we cannot remove NOHZ_FULL
>> CPUs from the list of CPUs targeted by these IPIs, they may not have to execute
>> the callbacks immediately. Anything that only affects kernelspace can wait
>> until the next user->kernel transition, providing it can be executed "early
>> enough" in the entry code.
>>
>
> I want to point out that there's another option here, although anyone 
> trying to implement it would be fighting against quite a lot of history.
>
> Logically, each CPU is in one of a handful of states: user mode, idle, 
> normal kernel mode (possibly subdivided into IRQ, etc), and a handful 
> of very narrow windows, hopefully uninstrumented and not accessing any 
> PTEs that might be invalid, in the entry and exit paths where any state 
> in memory could be out of sync with actual CPU state.  (The latter 
> includes right after the CPU switches to kernel mode, for example.)  
> And NMI and MCE and whatever weird "security" entry types that Intel 
> and AMD love to add.
>
> The way the kernel *currently* deals with this has two big historical oddities:
>
> 1. The entry and exit code cares about ti_flags, which is per-*task*, 
> which means that atomically poking it from other CPUs involves the 
> runqueue lock or other shenanigans (see the idle nr_polling code for 
> example), and also that it's not accessible from the user page tables 
> if PTI is on.
>
> 2. The actual heavyweight atomic part (context tracking) was built for 
> RCU, and it's sort or bolted on, and, as you've observed in this 
> series, it's really quite awkward to do things that aren't RCU using 
> context tracking.
>
> If this were a greenfield project, I think there's a straightforward 
> approach that's much nicer: stick everything into a single percpu flags 
> structure.  Imagine we have cpu_flags, which tracks both the current 
> state of the CPU and what work needs to be done on state changes.  On 
> exit to user mode, we would atomically set the mode to USER and make 
> sure we don't touch anything like vmalloc space after that.  On entry 
> back to kernel mode, we would avoid vmalloc space, etc, then atomically 
> switch to kernel mode and read out whatever deferred work is needed.  
> As an optimization, if nothing in the current configuration needs 
> atomic state tracking, the state could be left at USER_OR_KERNEL and 
> the overhead of an extra atomic op at entry and exit could be avoided.
>
> And RCU would hook into *that* instead of having its own separate set of hooks.
>
> I think that actually doing this would be a big improvement and would 
> also be a serious project.  There's a lot of code that would get 
> touched, and the existing context tracking code is subtle and 
> confusing.  And, as mentioned, ti_flags has the wrong scope.
>
> It's *possible* that one could avoid making ti_flags percpu either by 
> extensive use of the runqueue locks or by borrowing a kludge from the 
> idle code.  For the latter, right now, the reason that the 
> wake-from-idle code works is that the optimized path only happens if 
> the idle thread/cpu is "polling", and it's impossible for the idle 
> ti_flags to be polling while the CPU isn't actually idle.  We could 
> similarly observe that, if a ti_flags says it's in USER mode *and* is 
> on, say, cpu 3, then cpu 3 is most definitely in USER mode.  So someone 
> could try shoving the CPU number into ti_flags :-p   (USER means 
> actually user or in the late exit / early entry path.)
>
> Anyway, benefits of this whole approach would include considerably 
> (IMO) increased comprehensibility compared to the current tangled ct 
> code and much more straightforward addition of new things that happen 
> to a target CPU conditionally depending on its mode.  And, if the flags 
> word was actually per cpu, it could be mapped such that 
> SWITCH_TO_KERNEL_CR3 would use it -- there could be a single CR3 write 
> (and maybe CR4/invpcid depending on whether a zapped mapping is global) 
> and the flush bit could depend on whether a flush is needed.  And there 
> would be basically no chance that a bug that accessed 
> invalidated-but-not-flushed kernel data could be undetected -- in PTI 
> mode, any such access would page fault!  Similarly, if kernel text 
> pokes deferred the flush and serialization, the only code that could 
> execute before noticing the deferred flush would be the user-CR3 code.
>
> Oh, any another primitive would be possible: one CPU could plausibly 
> execute another CPU's interrupts or soft-irqs or whatever by taking a 
> special lock that would effectively pin the remote CPU in user mode -- 
> you'd set a flag in the target cpu_flags saying "pin in USER mode" and 
> the transition on that CPU to kernel mode would then spin on entry to 
> kernel mode and wait for the lock to be released.  This could plausibly 
> get a lot of the on_each_cpu callers to switch over in one fell swoop: 
> anything that needs to synchronize to the remote CPU but does not need 
> to poke its actual architectural state could be executed locally while 
> the remote CPU is pinned.

Following up, I think that x86 can do this all with a single atomic (in the common case) per usermode round trip.  Imagine:

struct fancy_cpu_state {
  u32 work; // <-- writable by any CPU
  u32 status; // <-- readable anywhere; writable locally
};

status includes KERNEL, USER, and maybe INDETERMINATE.  (INDETERMINATE means USER but we're not committing to doing work.)

Exit to user mode:

atomic_set(&my_state->status, USER);

(or, in the lazy case, set to INDETERMINATE instead.)

Entry from user mode, with IRQs off, before switching to kernel CR3:

if (my_state->status == INDETERMINATE) {
  // we were lazy and we never promised to do work atomically.
  atomic_set(&my_state->status, KERNEL);
  this_entry_work = 0;
} else {
  // we were not lazy and we promised we would do work atomically
  atomic exchange the entire state to { .work = 0, .status = KERNEL }
  this_entry_work = (whatever we just read);
}

if (PTI) {
  switch to kernel CR3 *and flush if this_entry_work says to flush*
} else {
  flush if this_entry_work says to flush;
}

do the rest of the work;



I suppose that a lot of the stuff in ti_flags could merge into here, but it could be done one bit at a time when people feel like doing so.  And I imagine, but I'm very far from confident, that RCU could use this instead of the current context tracking code.


The idea behind INDETERMINATE is that there are plenty of workloads that frequently switch between user and kernel mode and that would rather accept a few IPIs to avoid the heavyweight atomic operation on user -> kernel transitions.  So the default behavior could be to do KERNEL -> INDETERMINATE instead of KERNEL -> USER, but code that wants to be in user mode for a long time could go all the way to USER.  We could make it sort of automatic by noticing that we're returning from an IRQ without a context switch and go to USER (so we would get at most one unneeded IPI per normal user entry), and we could have some nice API for a program that intends to hang out in user mode for a very long time (cpu isolation users, for example) to tell the kernel to go immediately into USER mode.  (Don't we already have something that could be used for this purpose?)

Hmm, now I wonder if it would make sense for the default behavior of Linux to be like that.  We could call it ONEHZ.  It's like NOHZ_FULL except that user threads that don't do syscalls get one single timer tick instead of many or none.


Anyway, I think my proposal is pretty good *if* RCU could be made to use it -- the existing context tracking code is fairly expensive, and I don't think we want to invent a new context-tracking-like mechanism if we still need to do the existing thing.

--Andy

