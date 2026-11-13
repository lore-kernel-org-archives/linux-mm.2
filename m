Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F26E1606A8BD
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=EXQ5r4iB
Received: by kanga.kvack.org (Postfix)
	id 2459E6B05B3; Fri, 13 Nov 2026 14:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C816B05B4; Fri, 13 Nov 2026 14:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10CD06B05B5; Fri, 13 Nov 2026 14:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB6796B05B3
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:58:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3255F1401D4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:58:17 +0000 (UTC)
X-FDA: 85431157434.07.191D391
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 541CE180002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:58:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=EXQ5r4iB;
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.131 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794599895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SA/I1XcNdOqWCHpHPoabvJbPaHjQpV93aW+4lUY75XM=;
	b=c+FteXd88e47oiZoQKmS8uCObdMJUv7V1thP4s1HMWZCavEoi2jLo7gsMEAzuhV3xAQOFn
	2c3STGpNOa3+2UKHi/vqMfdvahrRul6EXukwVWOq7+dOwsoGd9eQjx6iWPzRbIegAaqi+x
	AXNfhHuENi6vKxmPOlUd0w16mbJc04Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=EXQ5r4iB;
	spf=pass (imf16.hostedemail.com: domain of chris@chrisdown.name designates 74.125.227.131 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794599895;
	b=QXwtVMV5KAtRj0MNf4EoI6PAvijAAZFWhpiD7+5Z3BDmom05OO7Gsii6VW0Fp202328y7I
	VMNzP7YiXwQWpDhKykIx2mJQcco/xn91hDa6MB84ECJrniG636T+Zk57UKwx+gLN+KBCtw
	jVM4Dz5jpMzHNoAC09wCTTam7QctuGM=
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3adc0ac3564so321582a91.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794599894; x=1795204694; darn=kvack.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SA/I1XcNdOqWCHpHPoabvJbPaHjQpV93aW+4lUY75XM=;
        b=EXQ5r4iBBFCJ10ofqrtyJ7tsDDRHmMy/CkwzpzqG9ymmM16hROzX7lz7ydXee3Ner9
         LFRXj76pbhDEQ8gmIY2mZPEZSO8WfevF8WOZAJoSXvYk5ALr+6AEF6Qc1iKMqDSBhzbB
         gHZONl3f8lR8DHUKq/v7k/pPVRkdGn0ajDBYo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794599894; x=1795204694;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SA/I1XcNdOqWCHpHPoabvJbPaHjQpV93aW+4lUY75XM=;
        b=ocMcktTmUfFVQ1LqM+AYyOXbatQsAAZ1pVCECEDgtflbw/+hFQ8XGD6Yy+XFJlGWrQ
         Kql3krTVmdoMbZI2/v/6dslJLaVaa+Ow87LqJPbA/37iQ78v0n6M1tzsa8eItk92wOJc
         ohAJwo6Gi73dMhzTLyK/33cGCDn0SZ7o9mmakacPxahdoC3mSZgoE6DPBo444jeWHOay
         0pLLWEjnuL6/LMHJwhEj777/HPeUw5CY2605kshu8UFMzJ20R8bqXDsmrR9bTTvugA48
         qDV8tfZkN8ah2ln8gd0KtE1PkuqVmohqFD1/V3L7Kw+u1XtcJ9/jStFDMuaL9cnZlVYv
         uwdw==
X-Forwarded-Encrypted: i=1; AL+hErGVMoyo6uyucHaWMvl25qCHLYdvvysY4fOKbyi44fTzDkmgpFAYwlgf6Hm3wUFMWdah/YTnT86mtA==@kvack.org
X-Gm-Message-State: APuU4Z/m9X3KGw4k4XK8xDUxdWW/3Aoeqd/QYwjUhUG1CmM7fIDPWmOo
	8DHTDMrcVFN2zmysqFPux0hmNaAVWAjdmgg52rGppAPPsjCJ+GQ/hZkVLe5zLtmntZQ=
X-Gm-Gg: AYBFou0vC/BzPJSfdSz+Is0tKG3JKdDGVbkXnF+tLt4wA9bHYeKgIIHHB/S+0SjKr42
	SqVpPwUVecCudL3DqD4bCKPAyXK6RVfRogpnLGkoyMiMDF58EuQjMjCyrN+BWIzPIFynZst2OWe
	O0+JDiohP0dJ1um5liz5Lf4aqLWIpcW11wu3md4b+mPG+QyEBMYh7VGfG3YPmYl6eShsE6EPITM
	51GYGRaz5tpxWu8Y5AbH0S4/B/T/G2DsPoon8gAnnSs4eF+FkJujEz8VhdViN6YvudVBvN9PcGb
	JB8O+Yq7hhHWYsKzqCIj6c4yLY0zBINZd3pfsc8OnLUPGysmvUbsR0kQoqAId4DIiE4uspdkB2T
	ML3tOiOj4S8TSqAjCKpi2xg8ARs3Js+/bfKEi3r3mRc7THCpT8IN9k+uOH67drnlj3UEldqqU8i
	dM7B6KQ6KqcqROjxLHUkhupx79lzIVN7IcAJsr2GlJxkU4biE9sJsaYhuRjV8r4R/tkgmHJhPxl
	XWdrSfqCV3oFYlzKq8agg935RBgLWxy0QkJAGRPlqpYrQGWOJ+zgyJ7xfgWlNlZwxwhwsVn8y4G
	m5q2JfWJWcnxgqA6TTkGKf5E9kLgQpkXzB1n5RJmDrUWFwZCJSV7QtAjaGWySKPUNImIca0Gvne
	3/UrVblkxD4eHRrqZBk0lSssgzJHiTkgGbclgW8JLrYF3t76x1f+RYIVt2Bp+MdjU/wYBr0UAKp
	Zv+CUkxd92VgF5l4oZ8uuCI+r34cFs2+SCfRVwv4YR+ua9cCZl4NQ5XVLNHIEvNhY2kjs1cSsRV
	qFja7Gr
X-Received: by 2002:a17:90b:394e:b0:3ab:be66:ddbf with SMTP id 98e67ed59e1d1-3b1b0b60493mr3259630a91.54.1794599894079;
        Fri, 13 Nov 2026 11:58:14 -0800 (PST)
Received: from [172.22.0.2] ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1aec66f4csm5853480a91.14.2026.11.13.11.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 11:58:13 -0800 (PST)
Date: Fri, 13 Nov 2026 11:58:10 -0800
From: Chris Down <chris@chrisdown.name>
To: Vineet Gupta <vineet.gupta@linux.dev>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, peterz@infradead.org, mingo@redhat.com, will@kernel.org, boqun@kernel.org, longman@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, acme@kernel.org, yonghong.song@linux.dev, eddyz87@gmail.com, martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com, morbo@google.com, justinstitt@google.com, llvm@lists.linux.dev
Subject: Re: [RFC PATCH 2/2] local_lock: do not put btf_type_tag on the lock guard type
In-Reply-To: <20261110012235.1024461-3-vineet.gupta@linux.dev>
References: <20261110012235.1024461-1-vineet.gupta@linux.dev> <20261110012235.1024461-3-vineet.gupta@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <20261113115810.cd33f9ed58c02dd9@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)
X-Stat-Signature: fpmqb47rwe8yp5uf3ncqitwf6r7aiuwj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 541CE180002
X-HE-Tag: 1794599895-158573
X-HE-Meta: U2FsdGVkX18bp9iLu//CQXzQwF3i7rRsbscZBxW0MEwntx4ly8KVro/RZwQLvfNveN/S8p5W4JWZ0+LDofmB8aybt7qECXrmCzdN4sB+e19eHJIwFIleO8RQ7GNj+Mm3peWhjzvNqoBexYrwkHiVGR/8B10JrRYt9itnsM0aietmZzswDTuDGLzkqDu9Xorj8iSS7iCL316oNZYn4l2WcU6AMje03E2si6BdLhaSp9KlWdWYVDTexXkQgyXLzNCewAdg/E6Yq4P8XV36DJOe6Vspe9GOaCGim8Hyna/DOk+SizkfSgD0piy/ftSwni+RObgWePPuPMh4hi9WerTIfDQtgjfagaZx9g05HgSZWRmB7G7vSyo2jh5pvByUPO/lpWs5L91pMDfs49G0hp5xdom15NXe6ezzjt7HwSTPClBSRChWpuUoBC13BCQ3QRKyXUqPeeR08tcM0Bg8fUsmETsft+UNQiKfECqJBd9DHOhm2KuWnFLVMQsVIUT3+IB+a6gbch+dGm19rID/+o3aZimxWSr123SgwCeqazG1iT2JSz3TjHBpAN/FPlvIK1TkYSWSmXxXD6hoAwzewbFuGsydQkAWWPLSmivQaKqeMIaU7aExBsLUD7cbl9ZwT1SNMhqpShe3ltRgUTMuIJXicKOsR7Fu7PvLElP1L6WYXQXPohvsj9EmKIIYrvSg6bTMAokRqNAlqJ4mdHcwrWzO6LjWA8kOELIBNtysOmw6B6lq1HRMLtyDhoYT1CRvFBTMmxz4EcZqp8LG5aREqAz6Jl577437+wu7pkr1D//z2kuwKvbIQZqdfRAZpFdh2iJntdMSrb0iG8sNY0vCXPXmulJRRyVmvASo6IzWpAGHNJmGWhVlrVjlbPEafZaS/wTWYsgtMZJgmq/UoGwwlRfwIDGt2Crc/u9gExXTbos73ysvau+bw/I4XX7RZYnSOWVUts1IYGSYn7qlb7pCIk4
 P6l1ffE/
 PUF6/PuqKIf4sNdisbkIAsknJxKZtljQwVbEP/K9ouqN5DH0Xr4LEx1lpB8Qfuk4UgM8np4GYvPYMZh/1Z+jRffXA+lIgLuPAw5rMA1zfqxVd/Ryex4PI3r+rgBS6vdMVgPodDy822dadbgy4pS1Jeyo8ExpFlXSpcARLMzhA8aEBqkI9o8qkSAM2S4AWDjDKy3UFKfa+G70Cmlh4WCvpsIZDP400iSaUEBrt5SWQn2mXOkXcfokM99TRwYP8CTMuP/f9sRrha4hryG6UO3Z75ac56tMDAJKSIQT4uPMpkQm+0HXS+oIxfYCTWW0kyHnlLeaeBv+0B/7euLqqGDmU/QAXu6s+EdYOwBmwSWj5kkCtdkS0B6TBOAux1R1Kn0uqeVnCkDY4nxN/l9am+l/HQ6Pw7RIAqOBk/Wu1HRW6ngvRGhVup7J7HU7xEgYexdGng1Tl6HwS1Sv6L4+9EN6VwbtQpq2Q7n0142Ct3zzvFuCXx64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vineet,

Vineet Gupta <vineet.gupta@linux.dev> writes:
>	typedef local_lock_t __seg_gs
>	__attribute__((btf_type_tag("percpu"))) lock_local_lock_t;
>
>	typedef struct { local_lock_t __seg_gs
>	__attribute__((btf_type_tag("percpu"))) *lock; } class_local_lock_t;
>
>Both put the tag on local_lock_t, an aggregate: the first on a typedef of
>it, the second on the pointee of the guard's member.

The typedef is the aggregate case, and it's the only one of the two that
GCC warns about. But the second one is just the "T __percpu *p" spelling
that 1/2 keeps the tag for. _T->lock really is a pointer to per-cpu memory,
since local_lock() passes it to this_cpu_ptr(). So the tag is correct
there. This patch drops it from the guard's lock member and the
constructor's argument as well, not only from the typedef. I think it
should keep the tag on those two and only drop it from the typedef.

>Every variant of an
>aggregate shares one DIE, so there is nowhere to record it, exactly as for
>DECLARE_PER_CPU() of a struct. clang writes the annotation into DWARF
>without complaint, but pahole does not translate it from that position,
>so with today's toolchains it reaches BTF from neither compiler.

That's true of the typedef, but not of the member. With clang 23 and
pahole 1.32 the lock member comes out as PTR -> TYPE_TAG 'percpu' ->
local_lock_t, the same as any other per-cpu pointer.

For the typedef, clang 23 puts the annotation on the typedef's own DIE, as
you say, so there is somewhere to record it. It's only pahole that doesn't
pick it up yet. You also mentioned GCC patches for type tags on typedefs
in the pahole thread [0]. Once those land, does this warning go away?

>Unlike the per-cpu declarations this changes no BTF at all. A tag in that
>position was never recorded, so there is nothing to remove, and the one
>percpu TYPE_TAG that does reach a local_lock type comes from those casts,
>which keep it. An x86 defconfig built with clang is identical with and
>without this patch: 152551 BTF types and a 6828300 byte .BTF either way,
>and .text is unchanged. The patch removes a GCC diagnostic and no more.

The defconfig BTF only stays the same because nothing in a defconfig uses
these guards. lib/test_context-analysis.c is the only user in the tree.
With CONFIG_CONTEXT_ANALYSIS_TEST=y, class_local_lock_t,
class_local_lock_irq_t, class_local_lock_irqsave_t and
class_local_lock_nested_bh_t all lose the percpu tag on lock with this
patch applied.

Nothing in BPF looks at those types today, so this doesn't break anything.
But it does remove correct annotations to get rid of a warning that is
only ever caused by the typedef itself. When the guards were added, the
type was only ever used as _type *. The typedef came later with
3931d4b98039 ("cleanup: Basic compatibility with context analysis"). If
GCC isn't going to accept the tag on a typedef, could this be limited to
that typedef in cleanup.h instead, so the guard's pointer keeps its tag?
As far as I can see, lock_##_name##_t is only ever used through a
pointer, in DECLARE_LOCK_GUARD_1_ATTRS().

[0] https://lore.kernel.org/r/252c53f3-3f06-40f4-9cd3-795eb298687c@linux.dev

Thanks!

Chris

