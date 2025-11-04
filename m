Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CC8CCFA03
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 01:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD808E00D7; Mon,  3 Nov 2025 20:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D51C8E0058; Mon,  3 Nov 2025 20:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 812338E00D7; Mon,  3 Nov 2025 20:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FE728E0058
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 20:45:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14DB2160393
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:45:21 +0000 (UTC)
X-FDA: 84071232042.26.ABAD4FF
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 28ED3120005
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:45:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eej7SG6K;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762220719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2r2L9mfw9r+buciI9SKXnid4aHeJcUG8hdz1itgchw=;
	b=M1GWRw8qadGd/8U+KY5L3kTs+lgPsFQ2n6chbYsBV3UtiAjDTdemIx0y8EMSc6HRpdE1JR
	N+x0BNjMSHvVbs9XW4GbP+5dVZoylLaxji45vzhmXo3hLCr5eK0YXWUBZ5jCN6g/S46a01
	+ke/AZsGZplFgcqi7WiUUGRriU5avJI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eej7SG6K;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762220719; a=rsa-sha256;
	cv=none;
	b=R4QB/Vf6Vk2fCq0m5beL0rQb6Tab4thdaJxtSu88Mm/VlAnIHUEkxiQXpSWs8i2yCPJhaj
	onfctc6qoYVXS+DspxNg27cyGqmNPrSKK1E6kuN5rycUaSy0PQ4X3mggqCgxM+bkzuTZcC
	U1XMfNErwXe7Mb9H3QMW7QpUAI0zEWc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762220716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=P2r2L9mfw9r+buciI9SKXnid4aHeJcUG8hdz1itgchw=;
	b=eej7SG6KYOyP3W/QXNmOQHfVG0rj2NyX9HRwoKpg+FWmsW7ArMfA2C/rXKHxlOZYdKzghs
	oqCvSSke2vPfqgIIicBVX3ygA8Fsiz0AOAIbO9KSQKL9jyicSmHTjkv1WG0pn5uuQu8j6t
	Ib+R2BY04rXYyG9jZXzc/7qccoD5dzg=
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
In-Reply-To: <aQj7uRjz668NNrm_@tiehlicka> (Michal Hocko's message of "Mon, 3
	Nov 2025 20:00:09 +0100")
References: <20251027231727.472628-1-roman.gushchin@linux.dev>
	<20251027231727.472628-7-roman.gushchin@linux.dev>
	<aQR7HIiQ82Ye2UfA@tiehlicka> <875xbsglra.fsf@linux.dev>
	<aQj7uRjz668NNrm_@tiehlicka>
Date: Mon, 03 Nov 2025 17:45:09 -0800
Message-ID: <87a512muze.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 28ED3120005
X-Stat-Signature: mzq4kiqyhufyskguknd75qaz8ymeroa9
X-Rspam-User: 
X-HE-Tag: 1762220718-803763
X-HE-Meta: U2FsdGVkX1+jKp5vRqfIHxL0aGd/q2Y41Hu6Z18xMTcoHY0KKfk4s7Y220YQTqBLtJIjc9r7lM1X6lVzht4IzvK+0IHCQnHG7+4DhBIrHMpjb3Y5ZaAWlBdAGGaQtVOSJDSBOTLrO65Hzuf1oTyMIRYSfW6k8Hgr5K8c3OWnpVNQUGz/eHJNMnNoBe88ts2fm+sF0YqnIvNbBRSp1hetm8lJYOgxHoe0t7tex7UHgJ6/HELoSgjFCY+MJBhOBbXhXtgxdWcQKTRmmTxl15maefIH5g3x0gqee3v8WZvdGo6KUZkeOkxftQ8ml9DpJQ32yu1p/pbJnaR1GOO1QnP414bLF8sIH5dTYKp5rn3bAchZsy8fnjJKXDWn3kWVNM8aDH1hdjuqDDcyYOVrABlqxdYDKYq5KD6TZoAMvic+PeTL44ciuyKN0SKBKnOgeyxawD4I8oOiiegjdLDtrlyB9m0EkiX5KUFSG1YdIdU7r/VYvKCqtPiYEcQv2KJKWLoM3+Sa8Tg4fzb2owJkDwDJORNmK6FdSDwC9fYDHUNiIDCqI6+SI/Nt1k/qkWEzu8chA9U9K5Ik8tzEYzdfzOEO40gKcmBv6ga9sFlOg4zCwcyOgAIHiVF1NKQ2PEjVoPSwdUdrUT/h9DdAwu1JQtS9EPerjVCvLIqrNZkNgKSrupFmDh0ZdmIVEjloqfc5Jill2zpm1qmiHdJ084MvZF6LGrXEccxKW0SzWuvC4l27hPRzLp3QyekueGs10dLi1p5wTfzHnUkdoqElMwYG532QpMAid83mXN0NeG8nNK538NiQf8pNBhXdegl0rY/TEzsCVlF+LZeOwTZXMY+M4p0z0awt6tV7tJ+u2wYhydg+KJjj5cQgTmJQBEAIv6wWffvbmX6hsVwBgPl3pUshGqrSmK3SJdjJns6z/VttDOw956cbURRXcbX/mSAZOR6mDxtWxFP7N8odFm7V2SiG0JM
 U4OEAIvT
 YDdzTN2SCLxxCSg3UwBc+2UaY205wJk4bYfOGNywTe5NEY9ST5A1ktdDKg1j/KWBBPvb9CUfTHSqUbxhyYtY3rA6oDHeFMAkjMR29GJGGiRJT6Jk6hrhlLE7EgVjstqusJic/xuQZ8rkUoSoaev/K1VjtamXXNj5FoTKBEm6Lm3kUXF2q92/H+PANxCZNpLyFcARYTJ8Qhvj+Hcm1E/hbrfKZPAufjznAj/iF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Hocko <mhocko@suse.com> writes:

> On Sun 02-11-25 13:36:25, Roman Gushchin wrote:
>> Michal Hocko <mhocko@suse.com> writes:
>> 
>> > On Mon 27-10-25 16:17:09, Roman Gushchin wrote:
>> >> Introduce a bpf struct ops for implementing custom OOM handling
>> >> policies.
>> >> 
>> >> It's possible to load one bpf_oom_ops for the system and one
>> >> bpf_oom_ops for every memory cgroup. In case of a memcg OOM, the
>> >> cgroup tree is traversed from the OOM'ing memcg up to the root and
>> >> corresponding BPF OOM handlers are executed until some memory is
>> >> freed. If no memory is freed, the kernel OOM killer is invoked.
>> >
>> > Do you have any usecase in mind where parent memcg oom handler decides
>> > to not kill or cannot kill anything and hand over upwards in the
>> > hierarchy?
>> 
>> I believe that in most cases bpf handlers will handle ooms themselves,
>> but because strictly speaking I don't have control over what bpf
>> programs do or do not, the kernel should provide the fallback mechanism.
>> This is a common practice with bpf, e.g. sched_ext falls back to
>> CFS/EEVDF in case something is wrong.
>
> We do have fallback mechanism - the kernel oom handling. For that we do
> not need to pass to parent handler. Please not that I am not opposing
> this but I would like to understand thinking behind and hopefully start
> with a simpler model and then extend it later than go with a more
> complex one initially and then corner ourselves with weird side
> effects.
>  
>> Specifically to OOM case, I believe someone might want to use bpf
>> programs just for monitoring/collecting some information, without
>> trying to actually free some memory.
>> 
>> >> The struct ops provides the bpf_handle_out_of_memory() callback,
>> >> which expected to return 1 if it was able to free some memory and 0
>> >> otherwise. If 1 is returned, the kernel also checks the bpf_memory_freed
>> >> field of the oom_control structure, which is expected to be set by
>> >> kfuncs suitable for releasing memory. If both are set, OOM is
>> >> considered handled, otherwise the next OOM handler in the chain
>> >> (e.g. BPF OOM attached to the parent cgroup or the in-kernel OOM
>> >> killer) is executed.
>> >
>> > Could you explain why do we need both? Why is not bpf_memory_freed
>> > return value sufficient?
>> 
>> Strictly speaking, bpf_memory_freed should be enough, but because
>> bpf programs have to return an int and there is no additional cost
>> to add this option (pass to next or in-kernel oom handler), I thought
>> it's not a bad idea. If you feel strongly otherwise, I can ignore
>> the return value on rely on bpf_memory_freed only.
>
> No, I do not feel strongly one way or the other but I would like to
> understand thinking behind that. My slight preference would be to have a
> single return status that clearly describe the intention. If you want to
> have more flexible chaining semantic then an enum { IGNORED, HANDLED,
> PASS_TO_PARENT, ...} would be both more flexible, extensible and easier
> to understand.

The thinking is simple:
1) Most users will have a single global bpf oom policy, which basically
replaces the in-kernel oom killer.
2) If there are standalone containers, they might want to do the same on
their level. And the "host" system doesn't directly control it.
3) If for some reason the inner oom handler fails to free up some
memory, there are two potential fallback options: call the in-kernel oom
killer for that memory cgroup or call an upper level bpf oom killer, if
there is one.

I think the latter is more logical and less surprising. Imagine you're
running multiple containers and some of them implement their own bpf oom
logic and some don't. Why would we treat them differently if their bpf
logic fails?

Re a single return value: I can absolutely specify return values as an
enum, my point is that unlike the kernel code we can't fully trust the
value returned from a bpf program, this is why the second check is in
place.

Can we just ignore the returned value and rely on the freed_memory flag?
Sure, but I don't think it bus us anything.

Also, I have to admit that I don't have an immediate production use case
for nested oom handlers (I'm fine with a global one), but it was asked
by Alexei Starovoitov. And I agree with him that the containerized case
will come up soon, so it's better to think of it in advance.

>> >> The bpf_handle_out_of_memory() callback program is sleepable to enable
>> >> using iterators, e.g. cgroup iterators. The callback receives struct
>> >> oom_control as an argument, so it can determine the scope of the OOM
>> >> event: if this is a memcg-wide or system-wide OOM.
>> >
>> > This could be tricky because it might introduce a subtle and hard to
>> > debug lock dependency chain. lock(a); allocation() -> oom -> lock(a).
>> > Sleepable locks should be only allowed in trylock mode.
>> 
>> Agree, but it's achieved by controlling the context where oom can be
>> declared (e.g. in bpf_psi case it's done from a work context).
>
> but out_of_memory is any sleepable context. So this is a real problem.

We need to restrict both:
1) where from bpf_out_of_memory() can be called (already done, as of now
only from bpf_psi callback, which is safe).
2) which kfuncs are available to bpf oom handlers (only those, which are
not trying to grab unsafe locks) - I'll double check it in thenext version.

Thank you!

