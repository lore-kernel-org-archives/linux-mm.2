Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5E2606A331
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=J1UhoB/9
Received: by kanga.kvack.org (Postfix)
	id 7B5D76B00EF; Mon, 16 Nov 2026 16:49:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765C56B05B0; Mon, 16 Nov 2026 16:49:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6552A6B05B1; Mon, 16 Nov 2026 16:49:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7876B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:49:12 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98D4C401CC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:49:11 +0000 (UTC)
X-FDA: 85442323302.21.2CACDEA
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5ACC4160003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:49:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J1UhoB/9";
	spf=pass (imf08.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794865749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJuKOBNNYnk1ty+KHw/zCYtkc5H0NaB5Yj6zALlwHps=;
	b=ijAeZyo+x5eFeQoT9k0+P6v1aS/qD99lr+ADZ4b4T60GIpMsil9PELGseJh6X9RYv4WRFx
	p79LIS2VXBgZrCutf+YIWRvurtiwiw/CCe4olHBdYEW/FZFFPwFzvsv6IckgjK1XtuCvTA
	pMar7WlwA2y89uXkaCQnIoK/6I6T09A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794865749;
	b=hnHtbUdAybPfAo7Ic4a7CIRB2RZZ6QJvf5ObLbD4TiQzDha6zeXza04z1uGC1tcyL/OooU
	7leVkAobuNHLsvafVFF/XDNHAEUYwdNO0XUUqq851JVnI0FjKqGyLx9PiHIou+VZj0rPau
	IZgAVcdLKLY/l3rNSg41Qp7mn6lhtc0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="J1UhoB/9";
	spf=pass (imf08.hostedemail.com: domain of vineet.gupta@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=vineet.gupta@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Oi5wYhbLjwdZu+R9/Qn3xoP1Vc2SrBmiTpo0zBudxz0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794865747; v=1; x=1795470547;
 b=J1UhoB/9/+fOB3vHOjJ5A4h6AVVjN3hYuRW08wofnUttUirmkSUBjzTI6JlepQw2+2X8w00F
 qbZoCe52zWoPnLFc3Tah3Vv8LNItCZodcMUgTslNN0BgB9TMjL9NpL/PcPghH8Msfwhbw/cAVm7
 eU/6cwrzJKyL4Rkbhdesh5p0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5853fed9c1d37e21;
	Mon, 16 Nov 2026 21:49:07 +0000
X-Mizu-Trace-ID: 5853fed9c1d37e21
X-Migadu-Flow: FLOW_OUT
Message-ID: <2e6d98fe-527f-4188-bca0-c9db1ad92bce@linux.dev>
Date: Mon, 16 Nov 2026 13:49:02 -0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] local_lock: do not put btf_type_tag on the lock
 guard type
To: Chris Down <chris@chrisdown.name>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, peterz@infradead.org,
 mingo@redhat.com, will@kernel.org, boqun@kernel.org, longman@redhat.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, acme@kernel.org,
 yonghong.song@linux.dev, eddyz87@gmail.com, martin.lau@linux.dev,
 nathan@kernel.org, ndesaulniers@google.com, morbo@google.com,
 justinstitt@google.com, llvm@lists.linux.dev
References: <20261110012235.1024461-1-vineet.gupta@linux.dev>
 <20261110012235.1024461-3-vineet.gupta@linux.dev>
 <20261113115810.cd33f9ed58c02dd9@chrisdown.name>
From: Vineet Gupta <vineet.gupta@linux.dev>
Content-Language: en-US
In-Reply-To: <20261113115810.cd33f9ed58c02dd9@chrisdown.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: femxmqutpyfhww6i3wjuebz18jokoui1
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ACC4160003
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794865749-928820
X-HE-Meta: U2FsdGVkX1/KMY+DgBi6DClW2ojY1VDc8p+hb1e1nX3RWyn46Lqi51dk3EmvJdshuDgahcnfiedVS5TVqd7nbUyZNRqHn9SZZbNeP+JJDes+6PJnRAEl1G5xuJ9tbj59u5L+aTH/fomoebBXah6gaMg3UsdvW6c7O4KIH7OZAp4LgpuB0SEbhprP+kxt08kkWQb5zAkpiB2feTdt6VK5dvCXczrO5zp5lQVRrz0/Z7/2XltwU5n/xgtbBsPXzx8uXlkqo4gbGTgoLG574BqEcAV4a4Sr+wTqeffzJDGRy81E067tIId5p6VrN7uK+6EWbnr8z3rcPk3nlUw05DL1T7RnsWSyu7qWxa+u4b7R3OcFpmKgBkWHPKfm8L1/wR/1VvyCDcKClqnD09rNo+wt+n2ej4aoPsMcI1UO7b3B3dBvszBmfe2iGMFvZ9fDh1J/cfT8LL6hBA8ppw5rd1pa9en8w+8vHTleSGCUPF9BEEPq1SH3q0ubp04qzcIQataFnFySfZ0ouGDP9jRpqGbWjxY9mU7AidbY7607Cm5GvILYLD/FeyjXU6Ng7kyYcYgObNXkeKFHjM3S/7IQkzCYlqi7ivCqFOkTlV6NZB7SrB5Y0ffCKTdXNb6Nv14nAKvvODE3xe9lUtpOuqrf4RXxfMn/qyrlNczLyr24Hx1Cr9Rpq19Dnm6Y5gLEYOGwFWZ6cHHfZv7oLhjqo+wxWNCcNVidnTgjJtClTqaegJvMl0SO0baLJl7ftopSAqfynhFYawvjObpnCsGVGlwXb42JNMS5q8H70qPDhMGRGc6IfBStmSPgrJ5hgSJDjgxDKj9cKEkPf0lxj8ujseGZdAIoZVsFLLXgWrj6U26ps3O7Se3Pfqzqnyct0CoGI+sph5ub5/+LgOFmMhmbc8VaxwC+ymTtUdQn+iczVjiMLrCZZVwUWkeSbOJQS4TTz74fWWJMiX/WlJX62x0pWKRM8pg
 7lNaJB1g
 02roTkhAVXQdWPIM8iMaNFjoqAVU4sKYXeQoRrU3CDp8aYth9S6ew0G7GBkMycGvNC0JCkmfbLPJyk8p1ZG6b4xDOYkMZYVFhPI869aHnFtIHmsgGWj2G0QBoLmcy/uvbY0GepPbRRvLgLHzAhfq9djfVg+MNV+oSsdlL7a93dfIIt/2GrUigKWzx/SEkMiaslsKq182hVosWCgLWpD5V6lhdTDFGbUuhtZoXQ/XNmqhvSIaGC+j5vZhDRVQWWA2imHRBHuXgA2ApPY5KFOoKKvv9XxksPhztVD2UZn3Y5w3QASfS1GDMX8daSBBzAa+cYeZDqKKN3WpyBW1uu6j99xjNsp3OAPBci7Ob88kKgbeTG0WGIkoJAEenuhYjiG/54EUArReSfyaCDOjwdhtFoVJg1ff/zDPO9JJsZvHHceciBj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 11:58 AM, Chris Down wrote:
> Hi Vineet,
>
> Vineet Gupta <vineet.gupta@linux.dev> writes:
>> 	typedef local_lock_t __seg_gs
>> 	__attribute__((btf_type_tag("percpu"))) lock_local_lock_t;
>>
>> 	typedef struct { local_lock_t __seg_gs
>> 	__attribute__((btf_type_tag("percpu"))) *lock; } class_local_lock_t;
>>
>> Both put the tag on local_lock_t, an aggregate: the first on a typedef of
>> it, the second on the pointee of the guard's member.
> The typedef is the aggregate case, and it's the only one of the two that
> GCC warns about. But the second one is just the "T __percpu *p" spelling
> that 1/2 keeps the tag for. _T->lock really is a pointer to per-cpu memory,
> since local_lock() passes it to this_cpu_ptr(). So the tag is correct
> there. This patch drops it from the guard's lock member and the
> constructor's argument as well, not only from the typedef. I think it
> should keep the tag on those two and only drop it from the typedef.

Yes you are right, the patch conflated them. And although the warning is 
same as in patch 1, there typedef is actually involved


>> Every variant of an
>> aggregate shares one DIE, so there is nowhere to record it, exactly as for
>> DECLARE_PER_CPU() of a struct. clang writes the annotation into DWARF
>> without complaint, but pahole does not translate it from that position,
>> so with today's toolchains it reaches BTF from neither compiler.
> That's true of the typedef, but not of the member. With clang 23 and
> pahole 1.32 the lock member comes out as PTR -> TYPE_TAG 'percpu' ->
> local_lock_t, the same as any other per-cpu pointer.

Yep it was wrong for the member. My config was lacking 
CONFIG_CONTEXT_ANALYSIS_TEST and hence it missed this part.

> For the typedef, clang 23 puts the annotation on the typedef's own DIE, as
> you say, so there is somewhere to record it. It's only pahole that doesn't
> pick it up yet. You also mentioned GCC patches for type tags on typedefs
> in the pahole thread [0]. Once those land, does this warning go away?

Correct, although [0] you referred to is a different, likely won't fix.
The fix you have in mind is PR125888 [1] and the patches are here [2]
This addresses the For BTF, as you say, pahole doesn't convert 
annotation from a typedef DIE so the

>> Unlike the per-cpu declarations this changes no BTF at all. A tag in that
>> position was never recorded, so there is nothing to remove, and the one
>> percpu TYPE_TAG that does reach a local_lock type comes from those casts,
>> which keep it. An x86 defconfig built with clang is identical with and
>> without this patch: 152551 BTF types and a 6828300 byte .BTF either way,
>> and .text is unchanged. The patch removes a GCC diagnostic and no more.
> The defconfig BTF only stays the same because nothing in a defconfig uses
> these guards. lib/test_context-analysis.c is the only user in the tree.
> With CONFIG_CONTEXT_ANALYSIS_TEST=y, class_local_lock_t,
> class_local_lock_irq_t, class_local_lock_irqsave_t and
> class_local_lock_nested_bh_t all lose the percpu tag on lock with this
> patch applied.

Yep I was missing that.

> Nothing in BPF looks at those types today, so this doesn't break anything.
> But it does remove correct annotations to get rid of a warning that is
> only ever caused by the typedef itself. When the guards were added, the
> type was only ever used as _type *. The typedef came later with
> 3931d4b98039 ("cleanup: Basic compatibility with context analysis"). If
> GCC isn't going to accept the tag on a typedef, could this be limited to
> that typedef in cleanup.h instead, so the guard's pointer keeps its tag?
> As far as I can see, lock_##_name##_t is only ever used through a
> pointer, in DECLARE_LOCK_GUARD_1_ATTRS().

I think GCC supporting them seems like a reasonable ask - fixes have 
been posted, lets see.

But to recap, I will drop this patch since it only needs to handle the 
warning which can't be fixed in source and relies on the GCC fix.

The point of this series was to do any needed kernel source changes 
which can't be addresses in GCC.
e.g. PR128480 [3] was deemed invalid/wont-fix on GCC side.

> [0] https://lore.kernel.org/r/252c53f3-3f06-40f4-9cd3-795eb298687c@linux.dev

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=125888
[2] 
https://inbox.sourceware.org/gcc-patches/20261112191815.884167-1-vineet.gupta@linux.dev/
[3] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=128480

Thanks again for chiming in.
-Vineet

