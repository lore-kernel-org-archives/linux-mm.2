Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA9EDC79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:03:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BC16B008C; Thu, 10 Sep 2026 13:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0BFB6B0092; Thu, 10 Sep 2026 13:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D223F6B0093; Thu, 10 Sep 2026 13:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFA046B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:03:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 449378058B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:03:45 +0000 (UTC)
X-FDA: 85198474410.12.996324B
Received: from mail-qv2-f12.google.com (mail-qv2-f12.google.com [74.125.230.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id F35D140012
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:03:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iKxgs4v8;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iKxgs4v8;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.140 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789059823;
	b=RfQ4gpQD+799bPId3nB6MlnoCsYkK1P2kAGCW3cdRVrCy+Jcr/erT0AAi8xpz/IH9mQPec
	RoR9itVq+bNDSZWS9JnH9VnSHIXoyQ95TqJ7talc0IBUiVMWiSMWpLrksfN2KFbK77Qgii
	Ir+CZeg+/ybRpgSLAhQ24I1z5M/nmYQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789059823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xk2OdPLDjL26fb8Tc2Cwml2fZiaKkha+GiG5IQjjOVM=;
	b=fYs0rv/On2mq3MsBiccAEJGDUs18J3yymzm9fozFkOTbg6IZSiu1cZsLq0IvI1sSErMvcT
	uU0oRIWYMyX2hY3ZnzjFZhHgWT4w1nBQIhIMcUq58B9E1xXhOwm/BcivNDHAMCVXexv92k
	dC410V4tVA+uO6PW5EjahjP+5delMek=
Received: by mail-qv2-f12.google.com with SMTP id 6a1803df08f44-90cdfcc3e03so13846576d6.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1789059822; x=1789664622; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xk2OdPLDjL26fb8Tc2Cwml2fZiaKkha+GiG5IQjjOVM=;
        b=iKxgs4v8QY1W3T6YoifHPndsDmEh8VeUdVQCFO+8ar4oysAZPTVlXOO1U8FDNkZn54
         8V5u55wOFdMNjB1LMrcz3QU5yMACBysRSzpGyzb0pgNJv0jBt0i+MW/uBh1Ldt8LeITH
         yvT4rGyC5bFTd8CCTlDiuRUy1ib3YYEUqutnTqRW7Hqy26pMQb2Ft2JRsHLHV0EJModd
         h3Oc/41pRym6hCJUn5Dyb1T3avYr84JpUaKxYEyMNGATTC8ypO4LRYJPW0b28Ber1aJi
         hHOkvR5G6V8YdW+kpVXzhxND7izmbycBp+5yLyKcbylIeKa39ZJNgfY7mwVcpR5xXGBn
         ewuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789059822; x=1789664622;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Xk2OdPLDjL26fb8Tc2Cwml2fZiaKkha+GiG5IQjjOVM=;
        b=SZ0LG3Qf1ewJFRjRbLa9POx3AC8wT5xxe9rdXArKU/QH8zwEuqqYAPBAvVODeNGMxv
         /eAka8XPpUFpvrPgqHwnqMec3FFFkgXXcAfV9BPX42l8x1rY6y2aOIuCfVPNxvHyxHQz
         wqslqV+Mp+p3XSra+S8TQq9GcoJA4CUAnZ3kTsqNGtfKgh0rcWfgaUD3+Yp5LAdLbXhR
         ZcUUkX63qLEGzpZ+CrxHrWdhPMbsfZyrMP3LxLUAqgI72FMVg1xg7VlycB5iT/G6w+xN
         01/Ai1ZDEBHGCi6R+T6dHnH75h7Xgjnv6eticuT/xtHNdhCTGTNIkgo9KzCQjzAcBaDt
         PVwg==
X-Forwarded-Encrypted: i=1; AKwUvByeDvOF7b7MplLNakLbJJk2cGH0Q/0sjTxhWEljVEWS9UYu+Cfo99C47en27Plas72N8uIZcIyIVA==@kvack.org
X-Gm-Message-State: AFuF++nnXudzW/dRoM2A2hCugVOQGynsGgSouWHWsJkhXIz3M4nJ6mGq
	e3AFUdq0+UUTf3cVM5/HrqKFgeapRYMLNQRpu6wt8JrFXod+eGM2tU4MqkzjrtGFntw=
X-Gm-Gg: AYBFou1VvBdXZFoFtK0njYeEmtaF4KV3UzRh2coEJab7PZ2zOarrVZgbGPjt/aOQGyC
	BSzwgp952AJvDZXuuhJRWioyzX45Qkex7coN4iM/OcdO84fTDb1W6yjOqr8hZb9U6qt70cYNdg9
	NjpR082o1Q+ZXGKa2YFKlxycKTXYdj/V6Jyc59fKBvYhzE8MBPIFM13Zod4kEiYxdgJ2ISgYktQ
	+beWrTBRNyb67psRJ089stngaxV1imM88YQMhATHAyYWfyQRuez0PBHQmaLjSFGOypGevhY5BAe
	sUZB1sI7y8Nf4M9DV8RCckEYPHCxa7FHEYj1mrFVGdXvXOYaAW6bylS01wQbrqaLqUpN90luUfc
	CyjBxG6hUgur/KH9gye0rPp8hTnpa3uDv6vdgg9dStpHzjiGklK/PjPwsFYGYHmIBGDIQDfeQuA
	EMfX5Vf3iHO+V4wfl0Zz61UI4G8l7H/XqoyFl3t7W5DUlczwuRwWoLwb0ycv1a/+r6HtIVxQ==
X-Received: by 2002:a05:6214:2a4d:b0:911:9375:905e with SMTP id 6a1803df08f44-9120e7339bbmr5689416d6.0.1789059821830;
        Thu, 10 Sep 2026 10:03:41 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f20367dsm669896d6.6.2026.09.10.10.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 10:03:40 -0700 (PDT)
Date: Thu, 10 Sep 2026 13:03:37 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>,
	Wenchao Hao <haowenchao22@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-doc@vger.kernel.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqLi6cIjD2wJwk0B@cmpxchg.org>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqJXx2vtbKaRLt3x@fedora>
X-Rspam-User: 
X-Rspamd-Queue-Id: F35D140012
X-Stat-Signature: syjrenot4ynkn9mczhxxcn33tdxkebek
X-Rspamd-Server: rspam01
X-HE-Tag: 1789059822-489205
X-HE-Meta: U2FsdGVkX18Mm/cx2JdOzYpT7W24cY6G5UY7/Rf9pplKkz52zsINUSI4eoNYrWqvwsfaTt02F0uiImmFjfFfc90Nb3uJElO1lq0KC+mkHZSBJeui1xmv3L45h4JJSb4HyV4f2Xd7AJl70ZnYyCoy7mtzWrvyEfUSlfYhaIzHNBkZRMgqmz+WD4ZXZ8RkCVhT72GOSmH1Td6TevK/fp8phC7cT59sRXCwhnAQUhr7LdVmT5+bVRABZ2Jg2IJ55CFX7Pt9hNByxZiqf6SmNo8RRhb1BITGC8G4td/wHCm82rq+tx0iA0hwJ4wIR74svnSZr3hNrRkciOUVtMUs2l358Tg9LaMYujEYHCftTmSSWSZDp9uIBW/qSSAMw/mQazzd7r1onjHohM0XIJlqqW64otnRJUXoOpqaV5mVXz4AyqPr4hh3TcGmfERP5lOQv51ghqWK3EOH0BxCGqABrkmRRHRwBkdht7EA20A0Um1jccnVqdFgJlQM88SBsUMBtSQbPaNi4eLcYCDF6q1v6JysHGe1+QM2buIlDiwb0Tfe4UzOSoUmRpoIcGOnJne5yK1ayoezq4rW9JdGTAK488eyPq+dyhq9U9KMAQdHcm/yVY3jLAkeYIVbTElbXWkEtkr8xto7PY9ftpdPinZaK+quZIHG4TIYrYl8wm9e+NSrc/9dmlnh/+tcNPrrBwngCD9X9jDVasulOcnfzSYf9/Kc/Owmufqt8uwtGRZST4HUX21HxS4jEtrL2I9+eVC8ehexmHhUoPW3hWyl8xkvGG1rFDrI5zT9JYwp/RpwZrT+Yc9LYmLEiGIj7r3z21yR0Rtmtc342tm+Fse2c6qBxb5Ovf8cSdpeaRPZLRPf5K32faEvT1ofLGJ1Hrmcd3SrgIkPyJ6YiMU/vHN5EsyCgPI8j7Xq57GrilpmM0L9+/IjEbVCCByTzGurE7G9oMtD63IB4AWr/0vDyxRXEjJDZnh
 9VOOfzWY
 69bp6nrN/6eP1nTSqD6r3K70HR7iBDbOZ5FbobfaVkBtFSp2tWaYTEQ2Tmp3fCQjMXryQsNbbMiSE//By9zkxGVG4erI1Cn+E11AIOlrpOapP/uI9gcehQqt6WNE5SHu0W76E2aqp7Ghcn0gkbvRyGmABg7wlfQVwGq63EpUIGxAJFWa12mimcgbWPg5d9/8DNfEuQcohrmUzIEQwOk/tOIBmUfKA25Q43/Y9iijDBQ9OkBN0pIXOXBH4H1aeOwYMndbz1BpiYCM6how25stsZhFtJiFLdUBkzC7t2vPyZ6VvvtTpsM42szW3Gxj5vGVASEhuiii1x3aWtYyjVYfTaTIbAeArvsRed8TN4rGC/2LGqdhYW+XJUROaYaP8Q3qUoQYJlJ8KpN1XJ7dYBokPLrEWGIh+4uMNqcObsQ1vcUwN1GiFK+0E8ffl+C8FWfbzySPtWQqBPFvks26SH8NPuD+Ra6NTO4ZK6LAYvJcyIWa8FfcADIBEXKq1lBsMxcVN7czo9/5UWcmT0xgkK062HdTocRl2z4bZHIiH11eR2TOGMhk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[This reply was not LLM-generated.]

On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> Hi Nhat,
> 
> On 09/04/26 at 02:14pm, Nhat Pham wrote:
> .....snip...
> > Now, on xswap. Baoquan's working on a series [15] that covers some of the
> > same ground, and the VM_SPARSE cluster_info idea in it is genuinely good.
> > I've been reviewing that lineage since July [16] and I'd like whatever
> > lands to end up with the best parts of both. From my perspective the
> > differences are:
> > 
> > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) plus
> >    a per-device limit to tune afterwards. I'm not aware of any use case
> >    that needs those, and I don't think users have a good way to answer the
> >    question anyway - sizing swap for compressed memory depends on memory
> >    size, workload, and compression ratio all at once. That's precisely the
> >    provisioning problem vswap exists to remove. The kernel should be as
> >    transparent and dynamic as possible here, and not add knobs unless
> >    there's a use case for them.
> > 
> > 2. Writeback support. Writeback is core functionality for zswap, not an
> >    add-on, and a design needs to account for it from the start. This came
> >    up before, in the discussion around Chris' ghost swapfile RFC [17]: for
> >    a solution here to be acceptable, it has to work with the primary
> >    usecase and support disk writeback. Without it, whatever zswap won't
> >    take (incompressible pages especially) has nowhere to go, and cold
> >    compressed data can never leave RAM.
> > 
> > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against the
> >    swap usage counter. It's fundamentally a different resource from
> >    physical swapfile space, and memory.swap.* should read 0 when nothing is
> >    on disk [18]. I made the longer argument for this in [19].
> > 
> > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, vswap
> >    is already on par with or beating baseline. I like the sparse array
> >    idea, but why are we landing an optimization before the feature itself,
> >    without any A/B data showing the difference matters?
> 
> 
> Thanks for laying this out, and for the honest push to converge. Let me
> be equally direct about the ordering: I think the xswap base should land
> first, and the things vswap demonstrates -  writeback, rmap lookup, the
> charging semantics, later THP -- should be built on top of it. Because
> it is the foundation that keeps the swap core simpler, and the first thing
> to merge should be the one that doesn't have to be redone.
> 
> The VM_SPARSE array is not an optimization to bolt on later; it is a
> structural choice, and the code reflects it. In vswap, the cluster
> metadata lives in a dynamically-allocated xarray.
> 
> struct swap_cluster_info_dynamic {
>         struct swap_cluster_info ci;
>         unsigned int index;             /* for cluster_index() */
>         struct rcu_head rcu;
>         atomic_long_t *virtual_table;   /* Backing pointers for vswap slots */
> };
> 
> To support dynamic growth and shrink, vswap stores its cluster metadata
> in an xarray, and that forces two things the plain swap_cluster_info[]
> array never needed:
> 
> 1. Every cluster has to carry an extra index and an rcu_head —
> 24 bytes per cluster — purely so the xarray can locate it and free
> it safely.
> 2. To keep that bookkeeping from leaking into the normal-swap code, the
> cluster had to be wrapped in a container, swap_cluster_info_dynamic,
> so the xarray holds a pointer to the wrapper instead of an inline
> array element.
> 
> So in vswap, every cluster access in the shared hot path has to answer
> "is this a vswap device?" and take a separate branch:
> 
> - swap_is_vswap() is checked in 36 places across page_io.c, swapfile.c,
>   zswap.c and swap.h;
> - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
>   flat array otherwise, and the xarray path can return NULL (a cluster
>   can be torn down);
> - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
>   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
>   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.

Well to state the obvious: the reason it does all that is to make the
compression space transparent to the user.

The user can answer a simple boolean question: whether they want
compression or not. And it will work on tiny machines, on humongous
machines, and everything in between. That's a simple policy question
with a clear answer.

What you're doing, asking the user for a static size, is much more
difficult and has usability issues.

You're comparing implementations that don't accomplish the same thing.

The problem we're trying to solve is implementing a clean compression
space abstraction. I'm arguing that vswap does, and xswap does not.

While they're both using parts of the swap device code to implement a
compression space, xswap actually PRESENTS IT TO THE USER as a swap
device, and then makes optimizations BASED ON BAKED IN LIMITATIONS.

But a conventional, statically sized swap device is a bad abstraction
for the compression space. Here is why:

In conventional swap space, one memory page translates to one swap
page. Compression space doesn't act this way: a memory page can
consume anything between a few bytes to a full page in compression
space. It depends on memory contents and compression algorithm. So
right off the bat, this is a hard question to answer at the host level
which could run all kinds of workloads.

In conventional swap space, the resource consumed is a different
one. You're offloading memory by consuming disk space. This eats into
the space available to the filesystem, which is totally unrelated.
Asking the user for this tradeoff is a legitimate policy question.

Compression space is not a separate resource. It's page tables,
backing pages, and swap descriptors. It's just MEMORY. There isn't a
size tradeoff, because moving pages from memory space into compression
space DOES NOT CONSUME A NEW RESOURCE. It's still just memory. All you
need for containment already exists: rlimits, OOM killer, cgroup
memory controls.

By making this a user-visible virtual swap device, you're sending
users down the wrong path. You're asking them to set a new limit on a
resource that's already limited by other means. You're framing the
question as conventional swap which behaves completely differently.

If you ask them "how much swap space", they WILL reference this to
available RAM capacity. Maybe half of ram, maybe twice the RAM.

But when compression space is referenced to RAM, it's trivial to fill
it up with zeroed pages or easily compressible data LONG BEFORE the
process or container would hit any of its MEMORY limits.

This creates an artificial resource shortages. It forces a competition
where there shouldn't be one. And then you need new controls to manage
a competition that doesn't have to exist.

Like I said before, including compression space (which is memory) in
memory.swap.* (which is for disk space) is not going to be acceptable
from the cgroup side. We can talk about that if you want.

But asking the user questions they shouldn't have to answer, or
already answered elsewhere, is weak interface design. Allowing, let
alone encouraging, answers that create a whole new host of
organizational issues is outright bad interface design.

So if you want to compare implementations, you first have to actually
implement the same thing:

Stop asking user "how large". Let compression space expand towards
existing memory limits, such that it doesn't create an awkward and
artificial new resource competition.

Then we can compare implementations.

If the optimizations still apply under those constraints, great.

Until then, there is little point in discussing differences that, by
your own admission, have little to no impact on real world performance.

