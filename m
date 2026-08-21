Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E4DDC5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:38:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0066B0095; Fri, 21 Aug 2026 15:38:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6708A6B009B; Fri, 21 Aug 2026 15:38:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538986B00A1; Fri, 21 Aug 2026 15:38:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 146466B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:38:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A9D351C0E5C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:38:36 +0000 (UTC)
X-FDA: 85126288632.09.2E00668
Received: from mail-ed2-f10.google.com (mail-ed2-f10.google.com [74.125.228.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id BF7DC4000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:38:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vl4473Cv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of memxor@gmail.com designates 74.125.228.74 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787341114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA4Ufzhn7RgFBDdlpRY4ipCaqygjEyBt0gBKZ9kn2Z4=;
	b=1bXiogmwJIkvsHxSQLrSEJLS5oG1FG7FT4UTrZIxylgb4EEJ+DneViFjvpqMhKj0pRrlz8
	RPoMhT5JPFUxpGz8ZE0mBRFDMXlXMhMucKNH2WKfaF+fOd5+5Yuf8H6+e9fl6cxbYrYjl0
	ATE6HbL5A3jWUWCVExYISOg/UJui4hs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vl4473Cv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of memxor@gmail.com designates 74.125.228.74 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787341114;
	b=KCmD4VI4Vkejc/GQG+lRTFT7/Lci1awSO8fWo4tX/0Qe/bjZGvrD3M3tOdEGU+Qfmc2HNT
	iM60+Kys2dLF9D0Ub1Zfwb8Y+LQtflmrEjcBce9mrtYaEXJOQ6eVPfjtZPt37tM+aZTYod
	WRmToeLqfyRJxqfKwbApi4y4ILCl0ow=
Received: by mail-ed2-f10.google.com with SMTP id 4fb4d7f45d1cf-6a1e7e293c9so969148a12.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787341113; x=1787945913; darn=kvack.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xA4Ufzhn7RgFBDdlpRY4ipCaqygjEyBt0gBKZ9kn2Z4=;
        b=Vl4473CvZvilGwXdUUVW0CKmZSwJxxBQV5GS4onyGdBH1C0GzxItufkEUs241yIMYN
         Q13ZNviNZzBV5WJdTYdaI7e2W/fA2IDBWocsLdeH4b0Am/b7Wg+D1bhkHGJ/haRDDYhg
         qwi7wFzqK0GwrYH7D3CQYYHk/f7Qxu7IDH767pdImnAfioJpiUxgwZ+R2QZJHVEgkPbq
         5iWS5VPJ1jgzGOM6dzWcjyds+QDYcxHXMdWgFf9CBmgw1TIQTFzhLYG0QazAPlDn1tf/
         ykXTZq/duPi04YB9+5mZ+UQfjyCbsHbR6dg4khbdeYgjkIak07GlhYHBvMU6JY9LUEP6
         iclg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787341113; x=1787945913;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xA4Ufzhn7RgFBDdlpRY4ipCaqygjEyBt0gBKZ9kn2Z4=;
        b=bjORTEknyDI4GVZwPFH92Dbf9ldj8QNu5R4L3EUK0REpZa0Hj1wxICBafwAkmNcXuS
         p/y7WHJ5yrK83vYr2EdgVA1a7/RdBkj9aDmAXr7snRXdkzXBDtXdMIfb8sqd08x4Ed0Q
         driXPKsRZU2JU3v/CPiBk2rTjnPJQiPH/Nowe02oJsCy8XzZ5R9y/ldtJzd5AtSv0VAm
         8Ty1QCBhqNWl13cQePHHdnt9M2DBmB+JeZlQ+SY6i/hX+FICErWXvFDZiJIvToxG+sqs
         TuN/Nnis+bl+Kq7MQFrjy92/1caxZr/UIldAcjTZ+m4cCJONDE4DrEobGkze1D3NH7XU
         tHoA==
X-Forwarded-Encrypted: i=1; AHgh+RrnEHkCiHVbIE9aEyL8o/to2z0SPPXAW5RWCBLXOY5FSZvbLWqsMnY/f3V2wsqn4lLGYE0noD3T+A==@kvack.org
X-Gm-Message-State: AFuF++kpnke1Gd52v+h7yHSl/wKexteNWD7hOxiaHVboHSMvcvZ4+iX9
	lcy8oSqh08b1v9pdjw1u0jaHxC4IOUlrOop/e1zyNFVkgfbRjuYyjAwX
X-Gm-Gg: AR+sD10JFwh2AOecPIISD8P2KDDg667/+oHuYhgumcNH7yztevfWdvsrLGaKD4yU9lx
	qFHjYdy7hLm8BiLetZrPcOvL+J3mBzwJ1O8enTUdyoyknuh32wrtYLKGRUazDG9wYiGSIHKZocJ
	qdLTHsMCq918D2U26TP2NRC+EgR1KJwBo25yeSp8mwADoOLv2QC5PflEAYBJjAsd38Pjki49AQ4
	fZcHip+CmLlNTjQAIXghNfoxweq+3x1so8PoYs+p6m6RRI87iaUBNjpFZlSz8HZmBf+MTYGWT2C
	zEOymrYrPI422zEFiKfukconWEN8ihpvuOLy2ImgMV8Mw1487ctwybSqnhCAE1h2+rlocxF2KOl
	uIpQHJK19xvyNCcV7qYaEhhNgUFcc0jIRrYpAZlivN/kFX0NnEAdHe4xXDb3xjf5owt3eA0nmNY
	8wRI8WPiQtaAClPbvBNZ41DH24fYZf2r86y/nT/0mwrZ9SYOcohknfWSq4n4Ey8tljaUg3VQirN
	wHN+ADGCRVZG1OnMRNe0bEnPgqnUtBXIZ0pLqTTXrinSRgKo2UwHXc3SOYl4XjmAhCwABeeIJMs
	ROWt5PzniDgkhay+zx5Y+aVfLt0=
X-Received: by 2002:a17:907:930a:b0:c24:680b:3944 with SMTP id a640c23a62f3a-c24925e416dmr54569566b.13.1787341112895;
        Fri, 21 Aug 2026 12:38:32 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c245919888dsm586894466b.29.2026.08.21.12.38.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 12:38:32 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 21 Aug 2026 21:38:31 +0200
Message-Id: <DKUVJN7NQMAI.2JXLSBOGJTI1W@gmail.com>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "JP Kobryn"
 <inwardvessel@gmail.com>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Andrii Nakryiko" <andrii@kernel.org>,
 "Eduard Zingerman" <eddyz87@gmail.com>, "Ihor Solodrai"
 <ihor.solodrai@linux.dev>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>, "Martin KaFai Lau"
 <martin.lau@linux.dev>, "Song Liu" <song@kernel.org>, "Yonghong Song"
 <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>, "Emil
 Tsalapatis" <emil@etsalapatis.com>, "Shuah Khan" <shuah@kernel.org>, "Barry
 Song" <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, "Hui Zhu"
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v4 1/2] mm/bpf: Add bpf_proactive_reclaim
 kfuncs
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Andrii Nakryiko" <andrii.nakryiko@gmail.com>, "Hui Zhu"
 <hui.zhu@linux.dev>
X-Mailer: aerc 0.21.0
References: <cover.1787205002.git.zhuhui@kylinos.cn>
 <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
 <CAEf4Bza0KYB+OHpa89K16+ptUQuQDJKyxxNCyDPcgQaO1mtxjg@mail.gmail.com>
In-Reply-To: <CAEf4Bza0KYB+OHpa89K16+ptUQuQDJKyxxNCyDPcgQaO1mtxjg@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 55ye4ida6135afrhkk1xnsoebhokerse
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BF7DC4000A
X-HE-Tag: 1787341114-6456
X-HE-Meta: U2FsdGVkX1+kpTVv5VUqAxA/lx36PRqGW9PyyWHLbTojGR49iOKwngjnIG0eRd8WyOTvS8RBFRLVE3qIrqfZ77QOJvLmkp5Ab/6K8qL0Czc9Ga68L/BSrphX5k4oGI7hohiIwFEObxB65bKbe3bdsU8RsFUfRyutRgHxODDejUH77gODyIbrV2gz4xP5PD1PFEkv4wNuLU9EheXUnTzcDc17hHcmLah/5p37RBp35i7DQg44xAOFNkhQDwzbabdGMor4biMSv3ij5BFJs8SMDbhSe7PkDeQF8KA1MoSl0WDMPXm0HQQTzwZqq44PkfXXXtZqNxXZK/2zGuY4fcnaqaDUq6GbAv5L5Jk7JblHKafn12adbrJjpRLbrm0GaFA0ZQMfsn/mT5JucY61xO2rlK81wNVAnIkFfxEJJQpmthMvkhPj0bSbhwBdfgR0902T2qVHkz8E6dsaufr8pgn82uq7kRBeUxWGRcsvBswB2p/kDXIVqJMPWZIev6nt9jkVvkZVWR4lK5eiyls1liaZUf1RxcyJCyTk0PxxAfzh7UuQ6gDUPmQfLqUq4x7s4lNViX8S1htOGumaPpaRDZRaT6cGD3i6Qc/xdkk7rzu40hyjEmYx++NQu5wWDvCzxKCFYnvPS3z/Oz6SwcB60xE0Rcz3igIh3dEovBPYsvIIGwyBCHe9Ric0txVC6o263hgMJl7IWhLnK+wTtXsAw7QXGe+c9i+i86FNejjqHGA1K5erobig2c5W4mG5vS2W//EaDeZPXE1001FTsKgC59CA7T+zpvendVsjwPLGi+4S6a/e1yXXttU1lI8w+BZIisSrW81nVthDvxlfIKT0DvQphfYJZ4G189TeE9zPdbiU0IZ+Tat1hXLK/WmGJXEi26jTboj224zBlimNL6nV/jZb2SfzicGl4zDaEaZe+y4530wX1Xkd5pCnvk8Mf3L1miPtfaKPD9XS/Dycw1uPD7q
 CV5zYimW
 y/dsTgjnmlp4P3q5EoOqFhGjOEFLJfKbHMbZbp7p72Ynhr04i+t6DqGBovh1zT6qNxWLrxfPFP4jeixTIlWnblRB8nvI5yRqlSOf1DlSpAs7bjQ7XowMYsNA+MNPmdo2+Hm+tzsNoETx03P04bF5MTXqCK+ATUx0etFpZ5uqQQxP7jd8rmv8qHWXOkfKn5xa47tO36knAB1epwMCK80NdCd/z6j9/X3bHzhOJupD0UB9/bt554s4FqhY1Yr3MT1bwmtIpNlfbE53b4WbKAIYgnpfzo1e84Igmt+JPGK6GwnbzCcO8/Cfe5qbz7NzbmmleakMe205J40Gti8ZM50PBH0pzn5E4d6KDSinNjGPOhr6jIQ89mJYPu1w2x05aXhXKqbfUJ64j81rPSoomAfsqJ+EQnDqA83s0/fRsKvuaJjIExmbftDi3fvNtQFBP+lQoUHHOoMSkIPUL0ztNN73Kf4k7ZY0L0d7gPYOIoR3VHbktmjZiw36tQpusbZnsiT9AH9W2MXO/AXBWNgA2zxjzvK5O+1vVO6PFcqsxltyqJNUDbDBLqPXEzam6zlL+vhVOA/pAUfbreiIc4T0pmfkhprVHpg5Id6EZNa5OfPQfmty6zlA8V6u6aB+4vQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 21, 2026 at 9:12 PM CEST, Andrii Nakryiko wrote:
> On Wed, Aug 19, 2026 at 11:12=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrot=
e:
>>
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Expose memcg proactive reclaim to sleepable BPF programs:
>> unsigned long bpf_proactive_reclaim(memcg, size);
>> unsigned long bpf_proactive_reclaim_swappiness(memcg, size, swappiness);
>>
>> They perform one reclaim pass on @memcg, like a write to memory.reclaim:
>> swap is allowed, and the anon/file balance follows the cgroup's
>> swappiness or an explicit override in [MIN_SWAPPINESS, MAX_SWAPPINESS]
>> plus SWAPPINESS_ANON_ONLY. Both go through a shared helper,
>> bpf_proactive_reclaim_pages(), which guards against reclaim recursion
>> and calls try_to_free_mem_cgroup_pages() with GFP_KERNEL and
>> MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE, the same parameters
>> user_proactive_reclaim() uses, and unlike memory.reclaim they do not
>> retry until @size is reached.
>>
>> Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>> current->reclaim_state on entry and NULLs it on exit, so a nested call
>> from an in-flight reclaim would corrupt the outer reclaim state (e.g.
>> MGLRU dereferences current->reclaim_state->mm_walk). Both kfuncs
>> therefore refuse to reclaim when PF_MEMALLOC is set or
>> current->reclaim_state is non-NULL. The latter check also closes the
>> window in try_to_free_mem_cgroup_pages() where reclaim_state is already
>> installed but PF_MEMALLOC is not: only a tracepoint call sits in
>> between, and while a sleepable BPF program cannot attach to the
>> tracepoint itself, it can attach to the generated trace iterator
>> function (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry.
>>
>> The kfuncs take @size in bytes; the return value is normalized to bytes
>> as well, matching the byte-based unit of bpf_mem_cgroup_usage() and
>> bpf_mem_cgroup_page_state(), so callers can mix them without manual
>> page/byte conversions.
>>
>> An out-of-range @swappiness is reported with (unsigned long)-1 instead
>> of 0, following the convention of bpf_mem_cgroup_vm_events() and
>> bpf_mem_cgroup_page_state(), as 0 cannot be told apart from a
>> successful pass that reclaimed nothing.
>>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>>  mm/bpf_memcontrol.c | 118 ++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 118 insertions(+)
>>
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 716df49d7647..dc51868b3acf 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -6,6 +6,7 @@
>>   */
>>
>>  #include <linux/memcontrol.h>
>> +#include <linux/swap.h>
>>  #include <linux/bpf.h>
>>
>>  __bpf_kfunc_start_defs();
>> @@ -159,6 +160,120 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct=
 mem_cgroup *memcg)
>>         mem_cgroup_flush_stats(memcg);
>>  }
>>
>> +/*
>> + * Reclaim must not recurse. try_to_free_mem_cgroup_pages() uncondition=
ally
>> + * overwrites current->reclaim_state on entry and resets it to NULL on =
exit.
>> + * So invoking it from an in-flight reclaim would clobber the outer rec=
laim
>> + * state and corrupt its accounting.
>> + *
>> + * The guards are PF_MEMALLOC and current->reclaim_state. Every reclaim
>> + * entry point marks the current task with PF_MEMALLOC for the whole
>> + * reclaim window: try_to_free_mem_cgroup_pages() and __perform_reclaim=
()
>> + * do so via memalloc_noreclaim_save(), and kswapd keeps it set for its
>> + * entire lifetime. A hook inside the reclaim path (shrink_node,
>> + * shrink_slab, ...) executes in the context of the reclaiming task, wh=
ere
>> + * current->flags already carries the flag. The page allocator, the mem=
cg
>> + * charging path and node_reclaim() rely on the same flag to avoid recl=
aim
>> + * recursion.
>> + *
>> + * reclaim_state is checked in addition because it is set slightly befo=
re
>> + * PF_MEMALLOC in try_to_free_mem_cgroup_pages(), with only a tracepoin=
t
>> + * call in between. A sleepable BPF program cannot attach to the tracep=
oint
>> + * itself, but it can attach to the generated trace iterator function
>> + * (__traceiter_mm_vmscan_memcg_reclaim_begin) via fentry, so PF_MEMALL=
OC
>> + * alone would leave that window open.
>> + *
>> + * Also, PF_MEMALLOC is set in some non-reclaim contexts (e.g. direct c=
ompaction
>> + * and vmalloc), where the kfunc conservatively refuses to reclaim as w=
ell.
>> + */
>> +static bool bpf_in_reclaim_context(void)
>> +{
>> +       return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>> +}
>> +
>> +/*
>> + * Shared implementation of the proactive reclaim kfuncs: performs one
>> + * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, an=
d
>> + * @swappiness as the anon/file balance override (NULL to follow the
>> + * cgroup's own swappiness setting). Returns the reclaimed amount in
>> + * bytes, keeping the byte-based unit of the kfuncs' @size argument.
>> + */
>> +static unsigned long
>> +bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_=
pages,
>> +                           int *swappiness)
>> +{
>> +       unsigned long nr_reclaimed;
>> +
>> +       if (!nr_pages || unlikely(bpf_in_reclaim_context()))
>> +               return 0;
>> +
>> +       nr_reclaimed =3D try_to_free_mem_cgroup_pages(memcg, nr_pages, G=
FP_KERNEL,
>> +                                                   MEMCG_RECLAIM_MAY_SW=
AP |
>> +                                                   MEMCG_RECLAIM_PROACT=
IVE,
>> +                                                   swappiness);
>> +
>> +       return nr_reclaimed * PAGE_SIZE;
>> +}
>> +
>> +/**
>> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
>> + *                         cgroup
>> + * @memcg: the target memory cgroup to reclaim from
>> + * @size:  the amount of memory to reclaim, in bytes
>> + *
>> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
>> + * the memory.reclaim cgroup file: pages are reclaimed according to the
>> + * cgroup's own swappiness setting and swap is allowed. Note that,
>> + * unlike memory.reclaim, this does not retry until @size is reached;
>> + * callers can invoke it again if needed.
>> + *
>> + * The reclaim runs with GFP_KERNEL, so this function must not be calle=
d
>> + * from a context that holds a filesystem lock (e.g. an LSM hook invoke=
d
>> + * with inode_lock held): the reclaim path may enter filesystem shrinke=
rs
>> + * and deadlock trying to reacquire the lock. Contexts that set
>> + * PF_MEMALLOC_NOFS/NOIO are handled by the gfp context inheritance.
>> + *
>> + * Return:
>> + *   The amount of memory actually reclaimed, in bytes (rounded to full
>> + *   pages), or 0 if @size is smaller than a page or the calling task i=
s
>> + *   already in a reclaim/freeing context (PF_MEMALLOC).
>> + */
>> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memc=
g,
>> +                                               unsigned long size)
>> +{
>> +       return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE, NULL=
);
>> +}
>> +
>> +/**
>> + * bpf_proactive_reclaim_swappiness - proactively reclaim memory from a
>> + *                                    memory cgroup with an explicit
>> + *                                    swappiness
>> + * @memcg:      the target memory cgroup to reclaim from
>> + * @size:       the amount of memory to reclaim, in bytes
>> + * @swappiness: swappiness override for this reclaim pass
>> + *
>> + * Same as bpf_proactive_reclaim(), except that the anon/file reclaim
>> + * balance is controlled by @swappiness instead of the cgroup's
>> + * swappiness setting. Valid values are [MIN_SWAPPINESS, MAX_SWAPPINESS=
]
>> + * and SWAPPINESS_ANON_ONLY, which restricts reclaim to anon folios.
>> + *
>> + * Return:
>> + *   The amount of memory actually reclaimed, in bytes (rounded to full
>> + *   pages), (unsigned long)-1 if @swappiness is out of range, or 0 if
>> + *   @size is smaller than a page or the calling task is already in a
>> + *   reclaim/freeing context (PF_MEMALLOC).
>> + */
>> +__bpf_kfunc unsigned long
>> +bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned lon=
g size,
>> +                                int swappiness)
>> +{
>> +       if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_=
ONLY)
>> +               return (unsigned long)-1;
>> +
>> +       return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
>> +                                          &swappiness);
>> +}
>
> I haven't followed previous discussion, so I apologize if this was
> discussed, but if not, isn't it a bit an overkill to have second
> variant just to provide optional swappiness? Valid range of swappinees
> seems to be non-negative [0, 200], that special ANON is 201, so why
> can't we defined that <0 swappiness just means no swappiness was
> provided and get away with just one kfunc?
>

I think my understanding of Shakeel's suggestion was that we only add one
bpf_proactive_reclaim() for now, if swappiness parameter is necessary we ca=
n
introduce the second API later. But given it seems Hui wants to add both, I
think it would make sense to do what Andrii said and just introduce one kfu=
nc
with the swappiness parameter now.

But Hui, please wait for Shakeel to comment before respinning again.

>> +
>>  __bpf_kfunc_end_defs();
>>
>>  BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> @@ -172,6 +287,9 @@ BTF_ID_FLAGS(func, bpf_mem_cgroup_usage)
>>  BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state)
>>  BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_SLEEPABLE)
>>
>> +BTF_ID_FLAGS(func, bpf_proactive_reclaim, KF_SLEEPABLE)
>> +BTF_ID_FLAGS(func, bpf_proactive_reclaim_swappiness, KF_SLEEPABLE)
>> +
>>  BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
>>
>>  static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set =3D {
>> --
>> 2.53.0
>>


