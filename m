Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A125DCD484E
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 20:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F8AB6B00D4; Mon, 11 May 2026 16:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A9DB6B00D7; Mon, 11 May 2026 16:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB30D6B00D8; Mon, 11 May 2026 16:03:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5D496B00D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:03:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9FCB9C0D8C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:03:47 +0000 (UTC)
X-FDA: 84756214494.27.2395D5C
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id 93BDF8000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 20:03:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1pR6Tuv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778529825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQoo2L8EhaJ1Fc2RW4QQ6a7gHDjPWRMIXP79pVn/Lw8=;
	b=hVoJuglis8+OVwj2oOp+pTlswHLHctxU4X9e1qvtQZDiqXpwoLuxB2IQF6rRUSyqzkpHGX
	U7TDlupX1bweTDcmJlUqqzjkvmLWTJe649edUmRgIuyHRRnbLK+B3EFL+zjpFfhGp0U/jm
	FCCNkkibj7o7v20QsBPHYYUnH1VCdCo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778529825; a=rsa-sha256;
	cv=pass;
	b=SsbURYDIruxXzPsLOUAXDUvD20v3ijD2DP1wEMTfiyMKn+OAYo1X10oSSVo/ekt4S1MJL/
	08ozk2TUCePPK+KXM9vjLPzrD5Y1QiJtVBNL5e2aCx71uRnL9TN9q7t7K9JnarwCkEIOfJ
	gg8rjHE6kFeiBwWZqQJXMHOZ58xKZII=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=B1pR6Tuv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-678a16429c6so7259929a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 13:03:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778529824; cv=none;
        d=google.com; s=arc-20240605;
        b=ZiOPLsMrLWmmGjhZG5Ew6PIAanpW/TlJc+r8ZZcr5lQ3bW/KB9k8o8Y1Py0kSdnWjU
         OMIoDNhXH5yvtVhWDumwl0/W3WxwqFtXNHKAUSojqliYHiAaH8F43q/Yjjyn4QbuXGc6
         3iwR6DboJ/taAP7lYjIoIMr3z9aVE6T9lenKk9MG04VkCgRZ3dk6ySSzwVaNs/5glUN8
         FjKTUcYxfk/wwwyv7p5YM99O0u88ezvjYwM8IGG1Jr4FZaM4VAQNZTYmXD2B0CTYHk6L
         YLIwRY5H2tpIUv4DEljhPjbNZ5pCL4Zokto/Vty6zpCuMoUCvu9O+ZOJnJE9miMIxTUc
         VZrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IQoo2L8EhaJ1Fc2RW4QQ6a7gHDjPWRMIXP79pVn/Lw8=;
        fh=ywpuqWPtYOkNOav/wyjKygqFnOmcu7JsMto6UqBEYYM=;
        b=Ksb8Cmak0p3S5HJURrinvAJNEwVo2F/nv1vorGzC27cx8sJfi/hYMdCH+wnxqg9eQ7
         Q1vHajoJBdo5Sn5TP8yszkHaosgfBQiC4AhMsnrfnAx/51lRMlKextpOyiG5vkWzzW/H
         QpDJ4QwAzZptY+VtGxP8lXmVfVHutkETxSWzQXOi4zXvDBXjsu4BvZmSMZNYJa2QQeZ2
         yjJWB24tiPtwxBah4oFDjzfw6JZDvsqpwH2A2fGp9AR3Y/KFV2bZN5stwcaPWAgF29Bc
         KH67dbJakaDuhiMA7mWlSU5ytFsxKGSorZDL8ETAluCyTFBvXpEWUfsS0wah+IWy6rNd
         YWyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778529824; x=1779134624; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQoo2L8EhaJ1Fc2RW4QQ6a7gHDjPWRMIXP79pVn/Lw8=;
        b=B1pR6TuvsgndM/XOEUfpShfcQO+bVl7H66XgDOE1fdi2JQfo5oGDMa6hQTeQV4QA4Q
         zn7lVW8tkIywOX9QSh2ixkCVKvQEN3OxL6U/hiZ2cmSQggRxSceYo5wBdot7imcJMfAe
         ljW4IbncjuyxwhIYk3kIMWKnDo0R420nfrxYlpM1cGFDBo7JGgkcLhZ2qhiF/bM54P7u
         /Q8lUFqDh2OqtaoTL2IXhIfJ5vhuQ2ud3vpv0TTW1eH/xf0PpDiaRRRkjKfayTVCxRz7
         moAhQEkGEJ8WOcnDbTKH34lUO2f5onOfHbEPe2/b5TasdT3ahHIckUQeqfJ33hQ5z38X
         o1uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778529824; x=1779134624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQoo2L8EhaJ1Fc2RW4QQ6a7gHDjPWRMIXP79pVn/Lw8=;
        b=GkfihODbRKUrOEeVBpraFbwAUBMDkUbivR5V5rYO2WPay3pOnul48lrcs2X59nOAbr
         Yuf96sNYR82YOcZ/Q4wEt0UMkWqypYJIb5GEkMdcXosiVkZtXdvRnNacdEwY1gurf96u
         X4Ep2Is3BNQfPJUcx1Npcomzz85uO3GquJfyydjvk6UrY3UkG5RdiIzn9U2HdEKuduJk
         OtzF4vFXAejIAimStRa/LX+bA9kv5LK/n58cKLtnOY3JGPPq1cl4SQLcJ6cMooisUs9Y
         T/Qw6AjfIU9V86G8ref2DdV2bsotE4ygTtg0xLadl5hq7xy/9fZERt1HDtFnXHAZasGK
         mIuw==
X-Gm-Message-State: AOJu0YwG9N/ecP8ub9iXa5eCpVAXrYjCS6Ml9z4CIdWz49sOi+nclmD6
	EYOSg51fe+ykL03tpiLRRjxUwLVyJVAIpZUCPl6E75mQVygrj83oQu4odKZxLEQk507fMD+N+fv
	FrQiIUasP1CwlffQIUkTQGlcVzLqjt7M=
X-Gm-Gg: Acq92OHFM80ivCqAEw3BXanwp25wzEabS5AoTBiLwEvgJGJa+W+hUbJe/i6dLxio/0O
	EaO69KP9+9zsJ0UgooTvVku5zEjR9T9aYZQOlXwYJMHm/D+FGqqbq8X2n4HF3vqQyvJBPT0Kmyx
	HDG1G7NMGj7zmmXJK9ixfMeQrTecQKX4kEVwBGoMOfoKs4PtrmF/etQu0ZDfzZNMfxB9g/5ubDc
	+bU+w0RiO8l/IaexuJ4p+Z0PUCXVfjPvkARjjZtJnNY2EeTOEFBSsmODRJtj3ARS6cC1AXBwDos
	CXLOInJL7tG0eb4882aToQMALoliJZobpa1C7FRN
X-Received: by 2002:a05:6402:324d:b0:67b:7e67:7f5f with SMTP id
 4fb4d7f45d1cf-680b360118fmr374089a12.9.1778529823702; Mon, 11 May 2026
 13:03:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260423203445.2914963-1-joshua.hahnjy@gmail.com> <3ff8b23a-479d-46e8-b820-a23697587f01@kernel.org>
In-Reply-To: <3ff8b23a-479d-46e8-b820-a23697587f01@kernel.org>
From: Joshua Hahn <joshua.hahnjy@gmail.com>
Date: Mon, 11 May 2026 22:03:32 +0200
X-Gm-Features: AVHnY4K1a6nMigh3_903jx2K6M9LAk--_V64cSO-XxSGUFqXFVJ32lwBtBHSK00
Message-ID: <CAN+CAwPK4cW6k6LazZsbuvewswOwzM8VJgPvcg0jef7FwfF1qg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9 v2] mm/memcontrol: Make memory cgroup limits tier-aware
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Koutny <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Muchun Song <muchun.song@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Kaiyang Zhao <kaiyang2@cs.cmu.edu>, 
	David Rientjes <rientjes@google.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 93BDF8000F
X-Rspamd-Server: rspam04
X-Stat-Signature: 3ihepxc1yffcogki1cwr63k8ppjngcxd
X-HE-Tag: 1778529825-791900
X-HE-Meta: U2FsdGVkX18uey/YOiUbIeo6DuXNZFRoHyCA+oiHdqRa9FG7B6gHeGalWk7WFHeggup9F0RE7fzJoygbQoTwMXP+HdCTb2V4u5rFS0CYCc48O2CucMOg2CPnEjUrrMpnSMKK52s0uchgwpt7+yfAisfCIqEXB0HpTfgT9ecrYbmvnrMCmh2AlLVII2beyEgOQMAbu1Nx01LUxFEkwcWTMPbGvgLTphNDlRNENnTQsoR9Xq/wDCkf0MOJUyUgyNS2ZWwRMN2LiCkYBRJPHhPM+gaKozW2YJFjvy7jhMLdp/7OYt3vzRYAY8Xi7P17gWG6snGv6IrCjvURX2pWY2MIBljNfPhg1/8ztKDg24z5boJL+xmKzo0U9aj+nn/KWzyo6IMscEb2lWzSWbLVkzR0zWGyJTMQgGbAozPJvOAnLtg3tgJasgOWW+mGs2Uhf9tFLEHoZdLG08q8IZ5a3rHjyH5fXl3oxbwa5HVW6PKlgSqUrlQz2xQhGdUVJwPl1QR3C1Si2/VBG/q/Cp6fL0kisitIV2DFvUoefjSgmozw/ZDes1cWXxPeIWFHF+WND/GH1pcjGm3m28xpldQstNN/7TyLlBc0wGr1CpVtloObaX13Hoaba6gCR6OdVFejMnp6K/pl4YeZspnY//8LHRjMDQyWXKuVUN7mkPtpXECbuXKmAg830ibPBTkHPIIKoDeWc19Mn+ymDFfvtAiy5/l7oNiCLVQ3C+7UVQZr58BFqkiq7jJX20A1GdBOtGbzoU5g1K/EIGZfEUJiKcuwirEuvxlbstK0W1iYmr8tXBixnfUFQXr3kSE5qQKXqp4G8Mx3xtRMZ5eLrsfVCgPh1LPXs/a3XINpxqQwljf9/3CfbIOb73V/ZUGOWynFaqLZKL+YGWECCq6c2G55+HGoF7IwJpYoUvisn2pF3gTp07I6Z680Gg3tuKtCmBduF20lhkVLP9RAVxFFauAMiz71r0G
 ZyJD4xLb
 o9lzhHl9+VxMSY8URNqUSg32P60X+UJY6NBIVY/Yi64CT7Y0Z5UUJbkg7tYLq0NDif8cikyFxvlDMV2DhdJh5HgX0NOqMJ/Hc0erAaXsWweIaXcS/R/o5TvgNE/IYCRUoN9vwXR8/lRwP1BTF/7mFWPHkOJqWJmE3dA/Eh7p+p35ua0p2fogjZdmN9SKefOmGar8Im8+1HpUPgU/j2G7LMXvMt+x9Y7POtqsShZ8NhXlXpEyQnJEngfNT+4+5WMz9hCMScJodFl/S1NkDptqx2iwW9NOpOft9fGta6qUgMOB7CF9qX6y8VWN6ChbWPkut6LtEg/CXwbJdf9N3wFgCQc0X2pex5JAUg3lx2kABnpGpb4bhvTTwb49Km7oifkMR3BJKBfvDH+lAZpQJFhSQbmIWNkd8qty6P/BXmy2COnwcGqoVi5YjFEkve5mH7qWaCtOg4B90qPcGRgkeeWKP7EMoICPRetvLnev6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 5:56=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 4/23/26 22:34, Joshua Hahn wrote:
> > INTRODUCTION
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Memory cgroups provide an interface that allow multiple works on a host=
 to
> > co-exist via weak and strong memory isolation guarantees. This works, b=
ecause
> > for the most part, all memory has equal utility. Isolating a cgroup=E2=
=80=99s memory
> > footprint restricts how much it can hurt other workloads competing for =
memory,
> > or protects it from other cgroups looking for more memory.
> >
> > However, on systems with tiered memory (e.g. CXL), memory utility is no=
 longer
> > homogeneous; toptier and lowtier memory provide different performance
> > characteristics and have different scarcity, meaning memory footprint n=
o longer
> > serves as an accurate representation of a cgroup=E2=80=99s consumption =
of the system=E2=80=99s
> > limited resources. As an extreme example, a cgroup with 10G of toptier
> > (e.g. DRAM) memory and a cgroup with 10G of lowtier (e.g. CXL) memory b=
oth
> > appear to be consuming the same amount of system resources from memcg=
=E2=80=99s
> > perspective, despite the performance asymmetry between the two workload=
s.
> >
> > Therefore on tiered systems, memory isolation cannot currently happen, =
as
> > workloads that are well-behaved within their memcg limits may still hur=
t the
> > performance of other well-behaving workloads by hogging more than its
> > =E2=80=9Cfair share=E2=80=9D of toptier memory.
> >
> > Introduce tier-aware memcg limits, which establish independent toptier =
limits
> > that scale with the memory limits and the ratio of toptier:total memory
> > available on the system.
> >
> > INTERFACE
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D
> > This series introduces only one adjustable knob to userspace; a new cgr=
oup mount
> > option =E2=80=9Cmemory_tiered_limits=E2=80=9D which toggles whether the=
 cgroup mount will scale
> > toptier limits. It also introduces 4 new read-only sysfs entries per-cg=
roup:
> > memory.toptier_{min, low, high, max}.
> >
> > The new toptier memory limits are scaled according to the amount of top=
tier
> > memory and total memory available on the system as such:
> >
> > memory.toptier_high =3D (toptier_mem / total_mem) * memory.high
> >
> > For instance, on a host with 100GB memory, with 75G toptier and 25G CXL=
, the
> > =E2=80=9Ctoptier ratio=E2=80=9D would be 75 / 100 =3D 0.75. A cgroup wi=
th the following memcg
> > limits {min: 8G, low: 12G, high: 20G, max: 24G} might see toptier limit=
s scaled
> > at {min: 6G, low: 9G, high: 15G, max: 18G}.

Hi David!!

It was great seeing you at LSFMMBPF. I didn't get a chance to have a
conversation with you at Zagreb but hopefully I will be less shy and say
hello next conference : -)

> Assume you have a bigger hierarchy (HBP, DRAM, CXL), or assume you have m=
ultiple
> NUMA nodes with a hierarchy each.
>
> Your proposal doesn't really seem to be very versatile, or am I wrong?

Let me address these comments separately!

First, for the multi-numa-per-tier case, I think this is already pretty wel=
l
handled by my series. Once we realize that a memcg is consuming too much me=
mory
from a tier, we trigger reclaim from that memcg via
try_to_free_mem_cgroup_pages,
which as far as I can tell already handles the multi-numa per memcg case.
Other than restricting the scan_control's nodemask to target the nodes
from that tier, I don't think there's anything else to be done.

Next for the 3+ tier case, I think this is a lot more scalable than it seem=
s
at first. This series depends on another RFC that I sent out [1],
which pushes the concept of "stock" from memcg to page_counter, which means
that it is more scalable to just add more page counters to each memcg.
This means that each tier would just need another page_counter to track its
memory usage, and we trigger selective reclaim on the tier that is being
targeted via the scan control nodemask we introduce in this series.

At my talk in LSFMMBPF, Usama noted that the user-visible API should probab=
ly
remain the same, no matter what. The way I have currently established the
memcg files aren't really scalable, so Usama suggested turning the
"memory.toptier_XXX" sysfs files to "memory.tiered_XXX", which would includ=
e
a newline-separated / space-separated list of per-tier limits. Something li=
ke:

$ cat memory.tiered_max
tier_0 20971520
tier_1 31457280
...

So we have a way to make both the user-facing side stable, and the internal=
s
also more scalable.

With that said, I've opted to leave the internals to 2 tiers for now -- I t=
hink
it is not too late to add the generalization series when we start seeing
3+ tier systems out there in the wild. My goal was to introduce tieredness,
and we can work towards generalization in a future work.

On that note, it seems like in general mm is aware of 3+ tiers, but most of=
 the
existing work revolves around distinguishing between toptier/everything els=
e.
I got this impression from reading mm/memory-tiers.c -- but please feel fre=
e
to correct me if you feel like I have the wrong idea here : -)

So perhaps the generalization work would benefit from first introducing mor=
e
general tier awareness (not just toptier vs. rest) in memory-tiers.c.

What do you think? Does this approach of introducing toptier restriction fo=
r
now, and then generalizing in future work make sense to you?

Thanks again for your interest. Have a great day!
Joshua

[1] https://lore.kernel.org/all/20260410210742.550489-1-joshua.hahnjy@gmail=
.com/

