Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40DC7C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370B86B0088; Wed, 23 Sep 2026 08:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3225D6B008A; Wed, 23 Sep 2026 08:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9D06B008C; Wed, 23 Sep 2026 08:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE0366B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:11:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54F9D40781
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:11:59 +0000 (UTC)
X-FDA: 85244913558.26.DA60752
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf21.hostedemail.com (Postfix) with ESMTP id 722721C000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:11:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W3TXj+mO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790165517;
	b=G1+eOn3X9x/ozV0/TnsOnaHCZTqv2/0CpaqolRFTR8CETHGFbD8HvwvHahk3whnK0Aubfs
	vqv2wEqA8qNrYkvu1/Ji6knzWLqZX5E0UQxs+KyvWqofPAGzG6ccgIeBImO2OmTEUvNX7E
	eIAkTQenhoYjdAZ+EIosobp/UBZm2Do=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=W3TXj+mO;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790165517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPMTUmIFbMagr41QpNmtzeOVUfCnU5evjD/bYrUNYz4=;
	b=SX4HK+6ZWcLzy1jHCMwiUO4gI/frzRVJBcisugyqkZCelyRhJjYar+bNHtmp7tCTkB1Dmt
	thQgj1wEcflWCYP/2U0Z6KJ4QxMVgJr1DtFbos4ZIQeXLKbHIF9EwCg0mZa1AVy1RAmIzu
	4LEI0g43tSK/WU0nX8fNP4i+x0sdiQQ=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-532db7db0c6so7529901cf.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790165516; x=1790770316; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IPMTUmIFbMagr41QpNmtzeOVUfCnU5evjD/bYrUNYz4=;
        b=W3TXj+mOmhvvisEobh//E4u3FChNlmhXA4GFXSI7zqfl4HVZK8FlIsdjbKDCVT10dW
         QYohDOMDNR2T7jFxBjqZO3JQf8smEyEWkojcAKnQT0CKWl+W4DCMrODHBzDHTwbgb0mq
         5OYFaFfkC5Z2jpJeQMoyqOqSIniSTHDPI0gtnILB6IL8T1B+GGaiWx97THzcQcePVJfa
         lmrsixexkLbmsq4AL+XVU+PyyXO5TvpEHks7wS7U30j8Jvrqz4aKVIBuDjGVTf8rvrcq
         gbCOnDgfs2Quc7IQ8a3En07VdyA8lwMMfQJ6ploL6sJF3basNx9j8LtgNL0haXQ9buzU
         jgcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790165516; x=1790770316;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IPMTUmIFbMagr41QpNmtzeOVUfCnU5evjD/bYrUNYz4=;
        b=Coy9t0Tm/fgq/ghnymw9K9pxn/wKY7QOYCm19BeQMYi2o/hA1aYW8FV3RPss3QcwGF
         /iVzzEr6ZauY8nNa8hAZ6ALOBZVZ2oxZKMOCVwWkOI813v6yxYCEWRTm/qkqc3zkPfBP
         Y97UJsvE9o9XBQ1IvBl0SIgZ/l6EyZbRC//+Z6i/ikjYWJqT0MPHKLPz6qlhdBIglJcv
         1yqg/jaTx6Qwrf8W3u1WB3SXzgBPTdxIULrQNN5XsY1fSs/MiVCSWpEEfaMQCVwVs8cH
         MNs/CQSaCIo9v3at6DvsPyeA2zdWneKZFD+RY4kh0LBwnK9WF60hFfp72hCIzUwLJ07E
         WGQQ==
X-Forwarded-Encrypted: i=1; AKwUvBzuBPE2R+Oke2FqzFgHnnxR/MnUSP7yw4Ftk49DPg0X/vjAx9dBbAfH/BQy92dosMn2iHrBlVNlfA==@kvack.org
X-Gm-Message-State: AFuF++mq6mYJbspAwnOGxWM8textapCZugi4cp6pqirhkJZTQEzjfIKp
	Isowok999VJIcbISxUK+8abe+4lDKiQue4dYHY2xZX01W18gtaaIr4Mbj6Ll2hyvRWM=
X-Gm-Gg: AYBFou1EzU1gnQZxCjKl3VDtp1dblTUpKoctHF8HJvKAKZwmEmOJ2N6BTbSqbvzL9Yq
	P63d2Q5nisJTlv69KvG+nPBTWx2RP5HTkoWy/c/xKJ9ULPlSwlNeER4ZFuIOZVrSSI9Jy8SCi6Q
	fiUDoAN4ROLlKfXdVZFAUor5xmnw1KDyqnGf6ZJhxs9BNNq1pyb3DL3wpYHzD9H9c3tqF9IGpjS
	j8pdpsFJsrChEg3AK0/zbZt1E10bk03YHa3cKYJjTiAzE052Dw3G/NHGWPM0ImNroOedK/ZpuRs
	lQgLA4DK1lCFxdQSHrlNkuc4XlnXXahGT/LGH00XCYwoCn4DhDQVceUG2cgfLQvMgi9UkZG2Wsy
	UsWdHxlkA2igFxn4zELimp9zNN8d+5XKS5HWnHfzASSs943zFnmULSZagB26gheQds8tkELCeFt
	IMtDbjV90Gfuydp8dyMaoMcZHKmPF6YADheOXCQjNoX5B/hMaX3zNKJNKvGUHrv0rCgd6YCh8LQ
	VAQNxawvSJf0kurebVgu9hsUl29maXfTe4CT8WtkQnhMtJomry25zeAGM2AAkxJVw==
X-Received: by 2002:ac8:5cd1:0:b0:531:a6d:dafd with SMTP id d75a77b69052e-532eabb3c23mr38720741cf.7.1790165516357;
        Wed, 23 Sep 2026 05:11:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eaec166bsm18721651cf.4.2026.09.23.05.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 05:11:55 -0700 (PDT)
Date: Wed, 23 Sep 2026 08:11:53 -0400
From: Gregory Price <gourry@gourry.net>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <ryncsn@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arOtPQN5irtjXKh0@gourry-fedora-PF4VCD3F>
References: <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
 <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
 <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arOeYHEf9aO7AU5X@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam06
X-Stat-Signature: t95fkjy8jy9mtieimy1fhd1zkhqncbr1
X-Rspam-User: 
X-Rspamd-Queue-Id: 722721C000A
X-HE-Tag: 1790165517-795903
X-HE-Meta: U2FsdGVkX1/JlniZH2u6a7zvPYS3shQVVBJjMFk2a3XKYkpK7qxoMPf1/gxJsKeDTEG/f5IJnfh47w1LMEMB0hoh0MMOYSxd/oASaztOUcca1A0RxrrlnVGl0kU57XYf5GFtD0p4mjGTGLgro5EWmrDoNVi+x/HaIGCtdX0qCLO+3cmadFKy6ncrOnTio3f38sz2ZYowBjuotNhZV7fw1R1bhaOrq/x2UPniol0PxHgRXrx5clYM6ZlEW9tvFzhGoKaa6W47728yEmyEq3O4ajyZidGv/NCuM878EQQ0n87L/I5mJy+PCVX+zfr5LGRXDaR98A9aMW/EqNBpo/eMsdHxc4hA0FKIfZ+XqKZg16tg2u2fBMlPEVL4pAllFE20VksMarvmGrvqFeHzemfgHKccxqR9N5UsfbDOEUQguz0JD286ENeoQYO10c6yJK5fGfGVdV73B3y0Qc4xBWcTlk2a/ZGZQgV0Uc2dDYE+e2kO7jhvk7Zzjv8l8AIJcn96ttUJduYJZ4GPIvM0qXqIgN5raH1kBu8PI7hzjYvqpAFt0EBSTWqsmmbxPf18SqXIdRuX86BhhteGTs+Li0VR/8Lam1vgqdMfskRXKJTTy8T9lz4JjXICp2fryLf9i1Wqq9JYqPrYZeFL9wZhB2LZsLzeMF0+0QVJipnY0KFcGPCtmttQaBBK/VUO0E+mKmRtOW1WLPmPaY5/fjuivwhM0TJBofHP2dM4d8EvK0ohargnAbZi8B7PQNpiqNy33oBRhDPiJitTCCNTBhx5bVTSBtskpaIjaoLtayfMKIlWYxM1VFn43jF7A/I4xBspdNHZ2FOBSBqXTIpvnzRqWOSHZ7EqlNb5as7Zc6eab0OJOUmswbOvonJ9UU6MTBACc01EdGUyVPRjo4TkUGgrQmDPTvlByr73XZNCCQdehM0qKVdHbQReu0rDgxJof4H8ecqGg2xGQL/y+OUmUuXuYr3
 fE6nxCwH
 JCtKNe6Icvc2wR3Fr0JVX8UA2XRzHW15NHSM/Iv05qwCOdUp+Ge7RCvJ9mxn6Pqvtiho92QISTXPxvGMvGs8x2BSpeliBXCR8Gs/gC96GuMcEchVQqd/Mfr//Az5q64/uZOZKtvR2bYF1nxMTQeKYBL3t7ftItFy3fXoqs+4SdOuKa589kuwDr4kMMdO6snun9LJFFAcde4xJY0A8GTpLV88ZVPLpssQUKcIc7oL/sovgMMThxQjuSGa0Yn8GXk9saw9lB5PL/dRKdwUNtSpgSM2rjrBrHzcNUxAba041bmWENWmx6G15T69zZV5tAazml2fQFcQUxIVAfB4zcRE57tFjMCqCBbCXR8HyphMq0K07P2QvKLYT00ldMfo2OEF79kG15LKPqmYdOE0coSYXLYOWumkioag3CUMf68bRDZCEbpofoaWonBuaztdhhJil30fWTL6257ZkljzkshT17GVWT64U9+VAZ/9a0GMN13Xmw8VuuHSI+hoqaq93bq4tUvJTq0ADUy6XypLn33VO9XJpDvHYXp3QgciMzKeyR6XZHMTZuluWkQBHCHr7GKTxICBzmJjM7Si/+3jwqfXPP4DwOH5ckmi3xsPvrONVGIEWPjwemCGs8IahlNYgD6gszXcQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 05:39:44PM +0800, Baoquan He wrote:
> > 
> > That's an SLO interface.  memory.swap is a provisioning interface.
> > 
> > As it stands, I'm left viewing zswap's counter inclusion in swap as more
> > of a bug than a feature - they account for different things (memory vs
> > storage usage).
> 
> It's hard to say. When 37e84351198b ("mm: memcontrol: charge swap to
> cgroup2") introduced memory.swap.*, it was clearly defined as charging
> "the actual number of swap entries used by a cgroup". Please see the
> commit log. With that, zswap still reserved a swap slot even when the
> data never reached disk. And not to mention zram, it's backend is RAM,
> but not physical disk.
>

If you read the entire series, you will find this documentation update
to go along with that commit:

https://lore.kernel.org/linux-mm/dbb4bf6bc071997982855c8f7d403c22cea60ffb.1450352792.git.vdavydov@virtuozzo.com/

  For trusted jobs, on the other hand, a combined counter is not an
  intuitive userspace interface, and it flies in the face of the idea
  that cgroup controllers should account and limit specific physical
  resources.  Swap space is a resource like all others in the system,
  and that's why unified hierarchy allows distributing it separately.

So the counter was also intended to be a limit on swap space - not a
limit on the amount of virtual memory allowed to be swapped (via any
backend).

Johannes originally proposed this for the documentation:

https://lore.kernel.org/linux-mm/20151211194254.GF3773@cmpxchg.org/

  memory.swap.current

       The amount memory of this subtree that has been swapped to
       disk.

  memory.swap.max

       The maximum amount of memory this subtree is allowed to swap
       to disk.


It is clear from the outset that memory.swap was intended as a resource
consumption control (how many swap entries may be used), not as a
virtual memory consumption limit (how much memory can be swapped).

all the v1 discussions you will find these counters talked about
consistently in terms of "consumption":

https://lore.kernel.org/linux-mm/20151214153037.GB4339@dhcp22.suse.cz/

  I guess this was the reason why this approach hasn't been chosen before
  but I think we can come up with a way to stop the run away consumption
  even when the swap is accounted separately.

https://lore.kernel.org/linux-mm/20151215145011.GA20355@cmpxchg.org/

  Allowing the parent to exceed swap with separate counters makes even
  less sense, because every page swapped out frees up a page of memory
  that the child can reuse. For every swap page that exceeds the limit,
  the child gets a free memory page! The child doesn't even have to
  cause swapin, it can just steal whatever the parent tried to free up,
  and meanwhile its combined memory & swap footprint explodes.

https://lore.kernel.org/linux-mm/20151215202235.GB15672@cmpxchg.org/

  As far as the high limit goes, its job is to contain cache growth and
  throttle applications during somewhat higher-than-expected consumption
  peaks; not to contain "large unreclaimable high limit excess" from
  buggy or malicious applications, that's what the hard limit is for.

https://lore.kernel.org/linux-mm/5670E147.8060203@jp.fujitsu.com/

  The point is, at least for their customer, the swap is "resource",
  which should be under control. With their use case, memory usage
  and swap usage has the same meaning.


Now, with vswap - zswap becomes detached entirely from disk swap.

There's no (physical) swap slot being "reserved" by the zswap slot
usage and the slot is now just another chunk of memory. It is correct,
according to the definitions, to stop counting it in memory.swap.

Without detatching zswap from swap, this would be blatant breakage.

But, putting aside correctness, lets discuss usage of memory.swap as
an SLO signal, and whether this use case has merit.

> Now some deployments do use memory.swap.* as an SLO signal, and that is
> real use cases as Chris and Kairui told. So I don't think this is about
> who is right and who is wrong.
>
> To keep the existing deployment working and at the same time give the
> physical slot its own knob, I think the solution is to add a memory.pswap.*
> counter as you suggested. And that is not something we think of from a
> brain storm, it comes from real deployments which already depend on the
> current memory.swap.* behavior.
> 

Then let Chris make and defend a proposal for memory.pswap.* and
justify the redefinition of memory.swap to mean the total virtual
memory space eligible to be swapped.

If memory.swap has existed with dual meaning for long enough that users
depend on it to mean something other than the historical and documented
meaning - we should have this discussion.

That doesn't mean we should simply accept the redefinition, but the
proposal has some merit considering some ambiguity dating back 10 years.


I would like to know more about his use case and why it cannot be
accomplished by memory.low/min. I can see there being limitations to
those interfaces that need to be addressed, and maybe such a change to
the definition is warranted and a new interface needs to grow out of it.

This would also allow vswap=on or =off to work regardless of deployment.


Chris has done none of this - he has offered no solution or constructive
discussion. At best what Chris is doing is finding creative ways to say
"No" without engaging good faith discourse.

You'll notice Chris did not engage in the discussion around the
proposal which intended to solve his concerns

https://lore.kernel.org/linux-mm/CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com/

He asked no questions, he brought up a completely unrelated idea,
demanded justification for the unrelated idea, and then entirely
disengaged. He continues to demand workload numbers completely
detached from the discussion at hand, and makes dictations about what
an "appropriate amount" of compressed memory is.

He's more interested in fillibustering than finding a way forward,
and this behavior is quite innapropriate.

~Gregory

