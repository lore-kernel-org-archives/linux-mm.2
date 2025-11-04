Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A831CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 18:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 888168E0006; Tue,  4 Nov 2025 13:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 839168E0002; Tue,  4 Nov 2025 13:14:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775598E0006; Tue,  4 Nov 2025 13:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6540E8E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 13:14:19 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEDFF5951E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 18:14:18 +0000 (UTC)
X-FDA: 84073724196.13.4CC6FC4
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id E3EF61C0004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 18:14:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYncNzCz;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762280057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NAWdqQAMF5nun7wl28IZyFWxTMsXgZF6tpsdkVCFUVk=;
	b=0toqr+R1zxRKh44nmNNoiiBkNzHzGwjicr2vGKcvVvDWUclJS7UHd3+L5JAhiiWxTk3Gd0
	P9c/LZWjyEEZB6KoFXHxHguDs31fQXWR1Cr5UQUGj4yCfO2ZQsllNEhOCW7d6tgRptBFQ/
	0KWxQZdotejM4i/Z+/Y+UzG4JO0Wm6I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYncNzCz;
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762280057; a=rsa-sha256;
	cv=none;
	b=qW/Z4FtXKkkw1xkwqctRRaUU7ikzXwodPcG9RprxB3ramPlHrZ50ylMLDv3WKbTKJo/dCa
	2pTdw8DhFPPhbbRKMQRgF44ejiNpvEBWhfr6t+Z+oWQ2bzIw2CVlLh0gst7ewOtKK/9aW/
	sXerC1L3grjHdAcmPjRG5sPVDQSZG6I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762280054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NAWdqQAMF5nun7wl28IZyFWxTMsXgZF6tpsdkVCFUVk=;
	b=CYncNzCzYkQqitwhPYqZZ2XB5M4zBBImGrmM8RswwHaI5fjYIChKwb+qJ+P6ev/4Y8jaEV
	UINgarZFhBJlyEkb3eGVjNfCyAerXhNhDDKh9POde27z+UNbv9dAnXxmOAcCOohdCIqP0I
	m20QJOx7Cz/kEmiqvkHdkwAZ8kL8w+w=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org,  Alexei Starovoitov <ast@kernel.org>,
  Suren Baghdasaryan <surenb@google.com>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Johannes Weiner <hannes@cmpxchg.org>,  Andrii
 Nakryiko <andrii@kernel.org>,  JP Kobryn <inwardvessel@gmail.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,  bpf@vger.kernel.org,
  Martin KaFai Lau <martin.lau@kernel.org>,  Song Liu <song@kernel.org>,
  Kumar Kartikeya Dwivedi <memxor@gmail.com>,  Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 06/23] mm: introduce BPF struct ops for OOM handling
In-Reply-To: <aQm2zqmD9mHE1psg@tiehlicka> (Michal Hocko's message of "Tue, 4
	Nov 2025 09:18:22 +0100")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<aQR7HIiQ82Ye2UfA@tiehlicka> <875xbsglra.fsf@linux.dev>
	<aQj7uRjz668NNrm_@tiehlicka> <87a512muze.fsf@linux.dev>
	<aQm2zqmD9mHE1psg@tiehlicka>
Date: Tue, 04 Nov 2025 10:14:05 -0800
Message-ID: <87h5v93bte.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E3EF61C0004
X-Stat-Signature: t9rittdbacmk1cpngi95u1totkq7qm3e
X-Rspam-User: 
X-HE-Tag: 1762280056-806169
X-HE-Meta: U2FsdGVkX1/t1DEEvPh8wW+CilxddJgbS4YCLoaIsLokJhnH/IPkB7JrkLMvHlxTHTvAD1HbsGcV1GL3e8/RnjHjAgXiJ3sKlgLFDJ5RgBSgTPYXLXFaU4rh5MyQhyjVxNSySeqbyi+tNyVm978gaBL8DFsqZq2ujzMxdmRVTpkaj5q2eEZ3gCk5QxEw5au4nI4Pj++XtdNO8/B/r8xCVGwviwo6W3hS5B932Y2Ck5ZZUYImwTcIVscY8gTKnzLjZMFQHaJCpyuvCw8FColuWITwwkHWQWx+VhNFYLQ22q5I+svtLhUrwl7WGyTCmpNmFfaW/w9dDFR6vKrR4unFI1xQOZCAGKSSNUCAmJQxjuR486WT1UCJ5hHLKGCj9Y6MZRzQWPSEYkrunDbEMDEfN6qXUFawn5vL1J/KnzHZy09akYf2ulltgRonNqQC59cKZya0WPkKtncQwCnIinTywUFIMUHPS1HQphTeAhvjr2S1EG2V2UgTEezzpCiHDWiPXbN/T4Akprn850qXpet7PFPvsXjGRlM5vTaZi063o0AAN0hBtYW9tPkfLwOC/S6wZa2LqTI1eE3aPdlXSOpx3XFguISxOTRajICAW9ZP3zjIFaYvU8pSVH9OxtqOA7ei+YSV7Jj8p6ahQ+V++xpyhjcUK3mXGrjWy96zK6+kud6eUeZAbddLkLrNpGGsSwbDjnQJFS6zYMgi+IrqTD9OZGbbu+Xy7wL7LsZSDDku30crnRsBoQwB9/huBXkX0BPzz8trpcKQLsjEmju2yab0iIXejJT+F+zJchAF2NmhiC/AzxkXm+AZGSr+RrmGgC1FNrhXYQmiLSda9sh8ISk3PalpbQpmUmnVEhkSPaXZePehLN5JaRDyInbxOZrItpb/PGj80drOb0pr5NY5k2kYV6iuq4aw6r10jrSCIdnLEDxt+HguSFa+HiVw0aqN6yhFZ78bAr8lFex+ii++6iX
 VObBlVWY
 IMRas2kF7Du4sjq+taeqs2hP/W3u0kICb78X6MkJrVzMobTFScjuQC7oilC/KBJv8EowjUErVprKYdc1btDfUr0W9u6hErq+xaMnV8IfV4PjfvFPAILjMheCSUJvME6n9ifgC2eRxEgFJ+ItFZp0GB1zN69cBs0diG/nsCXJsvUq9ZRPl9Z4eCdpfAoAHnOntol1YHWkolxD5TR4fksgC3/UuJEdhPUYCTOd9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Mon 03-11-25 17:45:09, Roman Gushchin wrote:
>> Michal Hocko <mhocko@suse.com> writes:
>> 
>> > On Sun 02-11-25 13:36:25, Roman Gushchin wrote:
>> >> Michal Hocko <mhocko@suse.com> writes:
> [...]
>> > No, I do not feel strongly one way or the other but I would like to
>> > understand thinking behind that. My slight preference would be to have a
>> > single return status that clearly describe the intention. If you want to
>> > have more flexible chaining semantic then an enum { IGNORED, HANDLED,
>> > PASS_TO_PARENT, ...} would be both more flexible, extensible and easier
>> > to understand.
>> 
>> The thinking is simple:
>> 1) Most users will have a single global bpf oom policy, which basically
>> replaces the in-kernel oom killer.
>> 2) If there are standalone containers, they might want to do the same on
>> their level. And the "host" system doesn't directly control it.
>> 3) If for some reason the inner oom handler fails to free up some
>> memory, there are two potential fallback options: call the in-kernel oom
>> killer for that memory cgroup or call an upper level bpf oom killer, if
>> there is one.
>> 
>> I think the latter is more logical and less surprising. Imagine you're
>> running multiple containers and some of them implement their own bpf oom
>> logic and some don't. Why would we treat them differently if their bpf
>> logic fails?
>
> I think both approaches are valid and it should be the actual handler to
> tell what to do next. If the handler would prefer the in-kernel fallback
> it should be able to enforce that rather than a potentially unknown bpf
> handler up the chain.

The counter-argument is that cgroups are hierarchical and higher level
cgroups should be able to enforce the desired behavior for their
sub-trees. I'm not sure what's more important here and have to think
more about it.
Do you have an example when it might be important for container to not
pass to a higher level bpf handler?

>
>> Re a single return value: I can absolutely specify return values as an
>> enum, my point is that unlike the kernel code we can't fully trust the
>> value returned from a bpf program, this is why the second check is in
>> place.
>
> I do not understand this. Could you elaborate? Why we cannot trust the
> return value but we can trust a combination of the return value and a
> state stored in a helper structure?

Imagine bpf program which does nothing and simple returns 1. Imagine
it's loaded as a system-wide oom handler. This will effectively disable
the oom killer and lead to a potential deadlock on memory.
But it's a perfectly valid bpf program.
This is something I want to avoid (and it's a common practice with other
bpf programs).

What I do I also rely on the value of the oom control's field, which is
not accessible to the bpf program for write directly, but can be changed
by calling certain helper functions, e.g. bpf_oom_kill_process.

>> Can we just ignore the returned value and rely on the freed_memory flag?
>
> I do not think having a single freed_memory flag is more helpful. This
> is just a number that cannot say much more than a memory has been freed.
> It is not really important whether and how much memory bpf handler
> believes it has freed. It is much more important to note whether it
> believes it is done, it needs assistance from a different handler up the
> chain or just pass over to the in-kernel implementation.

Btw in general in a containerized environment a bpf handler knows
nothing about bpf programs up in the cgroup hierarchy... So it only
knows whether it was able to free some memory or not.

>
>> Sure, but I don't think it bus us anything.
>> 
>> Also, I have to admit that I don't have an immediate production use case
>> for nested oom handlers (I'm fine with a global one), but it was asked
>> by Alexei Starovoitov. And I agree with him that the containerized case
>> will come up soon, so it's better to think of it in advance.
>
> I agree it is good to be prepared for that.
>
>> >> >> The bpf_handle_out_of_memory() callback program is sleepable to enable
>> >> >> using iterators, e.g. cgroup iterators. The callback receives struct
>> >> >> oom_control as an argument, so it can determine the scope of the OOM
>> >> >> event: if this is a memcg-wide or system-wide OOM.
>> >> >
>> >> > This could be tricky because it might introduce a subtle and hard to
>> >> > debug lock dependency chain. lock(a); allocation() -> oom -> lock(a).
>> >> > Sleepable locks should be only allowed in trylock mode.
>> >> 
>> >> Agree, but it's achieved by controlling the context where oom can be
>> >> declared (e.g. in bpf_psi case it's done from a work context).
>> >
>> > but out_of_memory is any sleepable context. So this is a real problem.
>> 
>> We need to restrict both:
>> 1) where from bpf_out_of_memory() can be called (already done, as of now
>> only from bpf_psi callback, which is safe).
>> 2) which kfuncs are available to bpf oom handlers (only those, which are
>> not trying to grab unsafe locks) - I'll double check it in thenext version.
>
> OK. All I am trying to say is that only safe sleepable locks are
> trylocks and that should be documented because I do not think it can be
> enforced

It can! Not directly, but by controlling which kfuncs/helpers are
available to bpf programs.
I agree with you in principle re locks and necessary precaution here.

Thanks!

