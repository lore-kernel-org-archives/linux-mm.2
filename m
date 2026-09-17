Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DF4C982CD
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 06:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7826B008A; Thu, 17 Sep 2026 02:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 189386B008C; Thu, 17 Sep 2026 02:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 078516B0092; Thu, 17 Sep 2026 02:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D76CC6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 02:30:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 903C21A0255
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:30:07 +0000 (UTC)
X-FDA: 85222279254.01.70E85C8
Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id A8F6440008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 06:30:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s1KaiysV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jingxiangzeng.cas@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=jingxiangzeng.cas@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789626605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
	b=1mV/IdWvc7uZanKVi+3kxeJZ4E5jC0MJJQBXR2GMUFA4mqSEJEfulka/AIOMOXVOhkAS7J
	k8sPG+VSgfKyWQl4xfKUiUv37pfzvCgp+xGmYlQ2rAyekhsGI+8NBsbvAAX0JuzR53nm+e
	3Ezv+bOYZy1Srm/wa4YqkCwVyqdpzA4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789626605;
	b=JKj0EhjDPMofHf0/tpnEGKCQxgBVoDZjT3q6axndjjtDpL9v0n9COTvzuPUHyZ0vTd+QwM
	e5zNCx3eIp30/ms3BkYv0OQN+kNg08/XWoGCiqCAxXLcstkE18ZdBvlcj02fRu2VJAeAu4
	jXyuGhsWUqd0zEEPhSaa/7v3XY1Pqow=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s1KaiysV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of jingxiangzeng.cas@gmail.com designates 74.125.228.41 as permitted sender) smtp.mailfrom=jingxiangzeng.cas@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469b35601so302830b3a.3
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:30:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789626604; cv=none;
        d=google.com; s=arc-20260327;
        b=m9SeAY1cplkt3VreJeTAMlBfsm3HLNZ3H1St3UJh05WNHKjGAQgtJ3kQNAJikrwl9K
         2+vPctNAscjS7Oj2zOCj2aPoMOFuG7FYQVRLpY60kivMrVHzV9rFmephmSSTYxJsAUFN
         Jk9zWJAnL1gfGNW+PmEdYW9DZ6Of/kr+C1pr0GwbBbrXZ0WkzIqYhgWhUB576sAQMEew
         OOvGSalLQjqhWPD+kOqHH2DelfFrg3JafkmaMJvMO4hQOWg5ncg8kXzmVPaB7zQLWwGf
         jOD5KOo2DiJce+irrFdB/DynHdtVZkrh1RrtzfUOsVxpbnIqcfY20VgAX6EyktcGwrBc
         EFeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
        fh=wMOIVRaDpVNQyRQDa92dbwclg4IMwf4K5Gyk0EAdZ/4=;
        b=LPYRDpprKLEO/5/lOwAdTEXEzanFfCcJZ+f2PLhYRU5Id2WhWrrRN2EIA8fVdHpWT5
         SHyBCi3uiEtUSJ73cjz0to7+5KFoc3j+Y7jJ6VR/Rml8Zw+8q7TQufmHpDwIgspZ9s/r
         VFfmyb6rddtNhKQXy9CunUs2yA9WwAGebRhYkehxIlF/A1HbylXxLkaY96IwG4N/bi8+
         aKunHImBg89qnDc4bEwVbfnJKagyt2sPwWbDbcYeSLKkplUCLaIWdgH48pDsKt7HVdGZ
         Rr3AVot3ONfU7nfzZ0Krc9e55mmYxrbqjAIboPX1DZopliHc6gO/rCSXlurudE9iHTF6
         2eQA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789626604; x=1790231404; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
        b=s1KaiysVtafO4OA4w2s/eJuRxXXS346P04M3U83vAcY7AX315atrytCULdnY+n/g5F
         chR1MtrDeGgVdjD75Wbqc0M30Jjeo7WQr46X0N6G3Rys5/dPEF3wlcfEgitUjmq/sVO3
         QEeJoW6DnWmfScZqzIy9Lzgyjl0nsesR/pnqgAPt7+C3Z1KE2EVhkLjyVviQKEei4B2S
         k427dp8VC71Rfb9aiT1EqQTifGwiCn/9OiKWE5ZfplU9sw12n2Gh7hfX6QCmOMewM/yZ
         4egBiKPpZpb/qsLfLq4nVpMuwm7FUVV5n7UufQNqYBTlXsjCTA2st8ocIilkJazmJ2TQ
         es/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789626604; x=1790231404;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f6s3jd19IN086xpWWaFW+yKBtO38Ikk4W70kReBkn/M=;
        b=k/iApkVyu2Nzm6nEkjtABBy316ADySv7zYGRBG2nowzAPPcU4A/8xPRCHYNkGSAo/m
         UUgRVRGuB6zTHeg/BpfgS4JEUMH1UHxHr/y6RIS1p4vxh8uqZC1dksj0hIOFflfgmJAa
         CJzTOvDJcpgS5IaBQBJRjdxrUwzm5CftCG41/FKaPKKQNtCZ/3BfXTccfvjlDW0OBKyT
         X3dU89D07UJVDhtxhcJBGfnGdyaQYpHYrT/l6eKTYE1RTwBugNaAuOMPzODWtHcMQl9U
         FqNRSfxBE5px7BeQIKws28Qz/Y6nmNtMPBnn8dTkfDmD+OGoIlvZxUSdAIGT0HuTX4jF
         /Rhw==
X-Forwarded-Encrypted: i=1; AKwUvBwN1OunZny2Pq0LLS3nyJs9HWOWwCWReVN1UdNGYEbgQItOeT7osHRbtTNDp+bSBhdh4drIUPj1nA==@kvack.org
X-Gm-Message-State: AFuF++n7E2qqNSElOP2I8wxHTqgD6bwtw3vhMjr+l/IluShpPYc8FYyl
	z1aSYU9ak4FOB8HfYyrgDOa4O9HKWZxJdKUyPODxCyK5DRoNoOxARtuObvEoJGAvRcT9s+bGXrC
	RzgyzKIdPd9DfNzN699Dl4zczVqhtrkQ=
X-Gm-Gg: AYBFou1BYM5/Ag9JeRcRu4/Ddb/fHESwo2XOVX3WafDdwv9E+TMnhnqdfZ0NjmNcO5f
	ycSaDy5FBqCFGZ3KmUkesMLuhFzsmfWg9kEEcmessYGGAHU+HyVgNIMOKtheQ7ZHO2CuMbFxxb4
	0VSBEaqulfeJtIx01XjJMLu05EA8aKdEV/532prhWN+f5YV0+eIR59mjLV4sfjv7GBRFQgIGD0f
	ZM/PFtBmBPpFqOwk4dvpJG4jrHuGw62GFFC3UA6C4qc50SKTvSk3DCss69XKPeQ1liH7Qb0wvmU
	t2n26uth7rpJuDsIa/ZDyamB2WvPOCMEnzB2ZSBOFJJXVmiNOiIQ4+yD7g==
X-Received: by 2002:a05:6a20:d70f:b0:3db:2c66:6638 with SMTP id
 adf61e73a8af0-3dd5f471e3emr15031230637.10.1789626603999; Wed, 16 Sep 2026
 23:30:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com> <aqQZus_Cc3mRiuXn@localhost.localdomain>
In-Reply-To: <aqQZus_Cc3mRiuXn@localhost.localdomain>
From: jingxiang zeng <jingxiangzeng.cas@gmail.com>
Date: Thu, 17 Sep 2026 14:29:50 +0800
X-Gm-Features: AcwNN1UARSNuee55eRj5g9Q9pOjCPBt25LiYNXQWqlZv1UTyIwozsFpLVuPTTQA
Message-ID: <CAJqJ8ihb71wv9qaKvoP990oKmoA+ErB7MB1sksjNhJf3enwJww@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: page_counter: move hierarchical protection out
 of struct page_counter
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: linuszeng@tencent.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
	Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A8F6440008
X-Stat-Signature: fyxziq753aa7ep3f3tzh8e14mpjs1ge1
X-HE-Tag: 1789626605-975757
X-HE-Meta: U2FsdGVkX1/1Md4J1UpdqhYKRrCzYK8DhQV7BOJyWSTZ6RygX/XtmC3kJSO5iecwW5FQckOlrh21h2ivMbWsNrSc1l3HvLBDC1/CCsnLcGB7DpMFZYvhKVxoN+Bt28CBHCKCgH0mgFFlTbp0rcn7pap3EYSilZD2zcALYDMjtjP+Yxk0G5oNh8SdUOYV8ORE1oWqp2jSvKYOl+SEeJHx7ozf+pWn77xq2S3l5Ev2oiKZQWEwmzqWhsX3TftjvmBNkMJ6qtO4UiC3qU+E97RTMDXbRo8iQXJ7HSnXS8/XRWKL2yTAPgX5O2K+q97JTHS9Zv45yu7JOMY9aBFK6Ai19ivM7GAVfa4NCkkFbfCgVOcElvwvkBt58nvJCT9JJRPh2tPapiBRj17ZurqBV2XJ6NtZ9SaFnmyn57/72JPrVy8mP+DLeLd+b2KXbN4gGfKT74+KieRjNuDVeecvn4nPVb4x+MexhWP9+Mows0pC4bzj+UOGeAOaidguI41ZnausxBq95TK2MvBu7dFyz4SEAYoPLuJ2lFDFzJSa4b1aM2Xfsto9EHK1pUBIC4+UeOyxK/v6539/MYnqZtU/fZvkBCdUrJFTG4biprZ4Izooyf4LlTkmMklLn/Iv12GISbt64M0EQEpEucbnXl5XEa/Na1qeYMIG4jXBWJaKwclADiq1OglXkQTRVOEczvu0xTqfUi2n6HB2xcMfW2h2tqcB7ESlA/YtR1yN4HizvPCQ8enMEl7W/jIZsImy5gZrQIXXUjdU+Wo91JBch8pyMym7tknuH+ceoLviXArWqudXfLPVUUIYRMbpfV6UvqxCteUO5pzR8d88ZfKIhbDKKAOoQi8umYBxGHHTFAV8os1+4EfYC6ngkf/BepOvnRg7QuAOlZlOz1A0u+sxT9ZdqgCUNyOlge45XMqljnIu/PlBMd1mrxg56mLExtOMnl/bv82sSzMGcbzMr9TAR9LFblI
 mpbGqE2f
 g/8ATCDd7G8cLpuKNApxyN6kvjoUQ+u3d6QF4BVuClR0RZJ+nZt+GZ5ilJQ/CLc/Znodp6l1ZUTyiUjZMu2ETbskKxknlVBMfgBehFUn47hiJbrguUHb/kDMuxxszkzlF7AR7kjP9KzLlnXK4pOhxADdtaOsIDQEfcAWktOaF5eenLic/pRQZIAa8+cLFx2e8kOxC+6vgCtECyh8tNrv7RdM31MD90w5sqILw/mf7nhsf8l3QpITA0wj0h2VI05u2T5+ySQSTNX6aD6BOk5yBbg8+HvL4Xntuw7kVhLyyD8GlVTE54jCdi+fSpWeCrnTJU+vfBjCb07qDf73moTOYBBb0rRGJL2nWq9Ewz8ojLIp4vTBFapmcocppbpnFUsGsSfrucURkhODF67Ct/HEgwCfjO56HztyvC67THIVOqJcahD7S4E6w5zSqt7A07d9YPNRJoDnu0BTdVTCCYjQmwyItcNb4xMJuebIUqFsojGClYaTyeIhXpX3av5Lv0yjuuTh4U/hSfXauaZtZtTxfJve8DsF+2KNsFCgnh+OnqSRrGIFyNeoRFAMVHcP0ofPI0ciDzvLcYaRG68t/COH/E4Vivw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sept 2026 at 23:17, Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> Hi.
>
> On Wed, Sep 09, 2026 at 05:44:18PM +0800, linuszeng via B4 Relay <devnull=
+linuszeng.tencent.com@kernel.org> wrote:
> > No functional change is intended: protection semantics and the cgroup
> > v1/v2 behaviour are preserved.
>
> It is not clear from the description what is the intention then :-)

You are right, and that is my fault for posting these three patches
without the context they came from.

They implement what Johannes asked for when I last tried to make a
combined memory+swap limit available on the default hierarchy [1]:

  My suggestion is to factor out from struct page_counter all the stuff
  that is not necessary for all users, and then have separate counters
  for swap and memsw.

  The protection stuff is long overdue for this. It makes up nearly half
  of the struct's members, but is only used by the memory counter. Even
  before your patches this is unnecessary bloat in the swap/memsw, kmem
  and tcpmem counters.

  Fix that and having separate counters is a non-issue.

and, in the same thread, about the cost of a second counter [2]:

  It seems like a good opportunity to refactor struct page_counter.

So the intention is not the cache footprint on its own.

The combined memory+swap counter is the one v1 exposes as
memsw.limit_in_bytes.  On the default hierarchy it does not exist:
struct mem_cgroup keeps swap and memsw in a union, because v1 only ever
charges memsw and v2 only ever charges swap, so the two never needed to
be live at the same time.  Making the combined limit available on v2
means charging both on both hierarchies, which means giving them separate
page counters.

That is where struct page_counter comes in.  Adding a counter costs a
cgroup one more of them, and at 192 bytes each that is 192 bytes per
cgroup for a feature most of them will not use.  Trimming the counter to
128 bytes first frees 128 bytes per cgroup, which is very nearly what the
new counter then costs, so the combined limit becomes close to free in
struct mem_cgroup rather than something every cgroup pays for.  This is
the "good opportunity to refactor struct page_counter" from [2], and it
is why the preparation is a prerequisite rather than a cleanup I happened
to do on the side.

The follow-up is written and tested; I should have posted it together
with these patches instead of sending the preparation on its own, and I
will do that now (details at the end).

>
> Do you have any measurements that the reduced cache footprint
> changes performance for setups without protection?

No.  So far I have only used pahole to look at the cache line footprint
of struct mem_cgroup and struct page_counter (pahole, x86_64,
64-byte cache lines, CONFIG_MEMCG_V1=3Dy)::

  struct page_counter             192 -> 128 bytes  (3 -> 2 cache lines)
  struct page_counter_protection    -  ->  72 bytes
  struct mem_cgroup              2176 -> 2048 bytes

The four embedded counters lose 64 bytes each and the one protection
context takes 72 back, which nets out to 128 bytes per cgroup.  The
counters that never participate in protection - swap/memsw, kmem, tcpmem
and hugetlb - are also down from three cache lines to two.

The reason I need these patches is the prerequisite
above, and those 128 bytes are exactly what the follow-up needs to afford
splitting the swap and memsw counters.

> And what is the positive impact on protected scenarios where the
> counters are in (possibly) different cacheline and one indirection
> further?

There is none, and in the form I posted it was worse than before.  Your
reading of the layout was correct.

propagate_protected_usage() runs once per level on every charge and
uncharge, and touches min, low, min_usage, low_usage and the parent's
children_{min,low}_usage.  Counting the cache lines each level touches:

  before this series   page_counter 3 + parent 1 =3D 4, no indirection
  v2 as posted         page_counter 2 + prot 2 + parent prot 1 =3D 5
  with the fix below   page_counter 2 + prot 1 + parent prot 1 =3D 4

In v2 the new structure kept the field order of the old one, which put
min at offset 56 and low at 64.  The two values the propagation path
reads together ended up on either side of a cache line boundary, while
emin and elow - which are only recomputed by
page_counter_calculate_protection() during reclaim - occupied the first
line.  That is how the count got to 5.

The seven fields the charge path touches are 56 bytes and do fit in one
line, so I have reordered the structure to parent, min, low, min_usage,
low_usage, children_min_usage, children_low_usage, then emin and elow
last.  Both embedders already place the context on a cache line boundary
- offset 384 in struct mem_cgroup, 192 in the dmem pool state - so no
alignment attribute is needed and the structure stays 72 bytes.  That
brings the per-level line count back to what it was before the series.

The dependent load of ->prot stays; it cannot be removed while the state
lives outside the counter.  The pointer shares a line with ->parent and
->local_watermark, which the same loop reads anyway, so it costs an
address dependency rather than an extra miss.

To summarise honestly: this series is size-neutral for a cgroup and,
after the reorder, layout-neutral for protected charging.  It earns its
place only as groundwork for the combined limit.

So rather than reposting these three patches on their own, I am going to
send them as the first half of

  [PATCH 0/6] mm/memcontrol: implement the memsw limit on cgroup v2

which is not posted yet; it will follow shortly after this reply, with
the reordered protection context folded into patch 1.  The second half
builds directly on them: it splits the swap and memsw page counters out
of their union - which is what needs struct page_counter to have stopped
carrying the protection state - maintains the combined counter on both
hierarchies, and adds memory.memsw.current and memory.memsw.max to the
default hierarchy.

[1] https://lore.kernel.org/all/20250320144722.GH1876369@cmpxchg.org/
[2] https://lore.kernel.org/all/20250320142846.GG1876369@cmpxchg.org/

Thanks for looking at this.

>
> Thanks,
> Michal

