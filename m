Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2CACC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 01:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE4E6B0098; Thu, 15 Oct 2026 21:41:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D96A36B0099; Thu, 15 Oct 2026 21:41:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D646B009B; Thu, 15 Oct 2026 21:41:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AFBB6B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:41:57 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 133731A028A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:41:57 +0000 (UTC)
X-FDA: 85326788274.08.2DB5F34
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id 24708C0005
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 01:41:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V0P14co/";
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792114915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
	b=5zHNPE7Kc6+lqidfAbLz5/SzutO0d+/5GrjEq4boODyTrTa3dchZ8Sg9vvItUm61djT6HQ
	1TDRxso+4E9NspKifaZFsEY/DE1d2pWjMcViWiSaYWHcoOaihCF1w5VLlEpMs1iCdFy5Hj
	A0v4OlqnjChSaCJpXtcWNHh85Rkzizc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792114915;
	b=wWwtV35SJtoIDJ0m/ahf85D+TK6BrM1oVKEFj4o0q9VOTJNeigv2PWbgsKRpSSne1CwEFW
	uEIaKnSEPXqlsxD1QukUGAVHl0OyWNUOJJuHGJU7MsI6YVviHr7qD9v2Ct5+gtK1nIQVwS
	sx7Z1g+b8V9JvesSQCleUPyC1dnl4ns=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="V0P14co/";
	spf=pass (imf22.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a17baef589so23979565e9.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:41:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792114914; cv=none;
        d=google.com; s=arc-20260327;
        b=A8weyBl3jCZg0FanvdSLS7e09RmQzauN54Pbo1+Z52e+KYGO3uGhvFZdWn6deJ50oJ
         EE8u68jmpVX3JKTHiZnHEQq1qLhkaGgDloQOGX+bo+2yDPfE1LzYl0nRn44plgMyWaJG
         X0fwT8zR80IRU2e/mPPYCKiteupZwaWnfxV/VfRY33xLenQtDHwiHJXYlvVpojMyT70k
         WeSVcGWUChHfS59RDcc01hH4boFZJRkep/p2ZzRmrC5UaXLqjC0rHhKuXxlSB3k6Cg6H
         6sxA/M/jW4B/RUCX9loki8VUQVn+dgzisYUZk0fPlpsB/by4/WWyeJ+It87d+4eL2vuB
         H/xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
        fh=SO/mEMEa1qFLOTeYop8bWJY7GSSveo/OIhszsW0+Q80=;
        b=qs12lNqoXZoxYT+C/D26vZFkFFUIf2rOeIq5Rb4gb2ZAJiDDQYlXPMw6A6KRVQmjYA
         ytBa+IcYSvcj4wcrbhptYKIS0QkOJnzGiCiiISupG9Vgt43ZRty2aHG5eJ+X17e/2N41
         30y1gSY11c6YlO82+H9BnJcEiyczsO+k9/rOEmOY90NLPD/74RW0xe4SivYqWAi9cKNs
         3Xow5IuV0itaxUWTeFWOVTeJSoCMj1AuBSIk2cviDttr9itT5vkJQ/r9tHQcoFPLKCQ4
         QiS5Zh1Gn814M3fRSzVO7XI+J2++R1y7qsBD3z9D0akZB/K+Hf02nOqpmb90TiDUdsvn
         BaQQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792114914; x=1792719714; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
        b=V0P14co/6a/cdolDGvnQOledXWoBwowERv/7COvG0DmSCRQcs3jOgGOKqedY8vGIRb
         N+7LL4daGlzD3dpwGViaJRcDuSHYpBN44doOjrf5H6OG+IuRjDb4H1XaaSVO4/1lDDDE
         i4cD0GbTX1YaYZEDzHNSomZgYLssEYZa5cdeDMPOPKll0WbKnWDg8NoIJQBEM1sB0bFn
         0gmvqCToyLnzjuHgyG7X4Dp+XUFOIG5qJ61H5BfQCkV7EqBR8+3GhTK1mi+uPb8I1cuu
         KS+KX3+S356HE3pzqb4JnfE4xSt+O/wMDmAMgw+8+NNnCjfYG/dFmjccESsFmCUJ+qJx
         BFyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792114914; x=1792719714;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dQCjKnpPJ7GDMGuXaT1sL8RXqnIOzelAupnlRVaJRrM=;
        b=pUWJbfOzOtz0gtdX8uAYoPdpISwpE4icPjCvBnNdeywUzYk4RWLhL4TgZe0dRGHTJ5
         RWwuOu3pjUS+7Or0NX4rBJ6ew5G7PoOptnAehoebq8UtUV76vvmA7LPsUtgYJMihZ+1n
         yfe+haLH7VevFj6Sgs09B+SqnYIg8CedXZDkFx+pfZo8ixA/Qk1gJ68en++19WqUisHg
         sTnXYDpJlQcan8V4EvB9e8E1Yxu7GLxqgHMT3z4nRKU9vqsuOkAjrczhaR4xnrv/4uQ8
         3Qw2DBwaD9HwnOXeRLKOLepp+3cklu7c8DDmEMtsXdBzIqNQNZwcJiFBHnYvNLQUMQmp
         PEiA==
X-Forwarded-Encrypted: i=1; AKwUvBxke60ZRv8P/hjYzqsi23ObvdXnioY6B243yk3FcDnREOZ+jKVR9s5xxzPOOCbp+jdqJNm0tzyqYg==@kvack.org
X-Gm-Message-State: AFq9FYJyqDG7ZXGeE/eUPMmgHkl3po/DPbaNsQwwvX6xiXfrISnnzrhS
	MHWtTh/2aRYC8mXOz6DajT670kh7sLek9fKvhRDkWIgHOkjMCVRJkScGTgaHlCLFVsGu3+UdxqS
	SiefUzNF/BJTn5wT4FjVx8mfU3XPnq5g=
X-Gm-Gg: AYBFou1RLl6CZh+XutsnWTU1yrMgMAzU1gPamq/0Q8Q4LU4GdKpx2Gl3RwFoIwaW0Ca
	f8WSTwkqeWieltnOmRimlO3Hcdm3EaRe5bRacP4bIhTmpFX6x17XHZaw8wAorpp4MctakSZBft2
	n8oa5SlSeGuxA5m+zhDt9NRWdCNglBCGEJesH5qEDSSA7V6zpJnoiOcJpZBFsa9O/ycR8LAD5Xz
	g3OqfoRCKV8gtL+q1lj3SkmHsZJS/QtOzEXcyGmQysGSaxIbvHynjb/dzefOf60yn3o3iA1dcI7
	bGO3CIa5ifOb9zUdCDuvXMLjg/6tHKlFsUrtcAXnZeeHRCGpoCoRjF9hSiS/Qbp+wLRzFjFE1WA
	ihAywfbMVyz9Qq2a1hlI0hdKGr+T10GfRmBj/eg==
X-Received: by 2002:a05:600c:4e89:b0:4a0:12d7:4c88 with SMTP id
 5b1f17b1804b1-4a18e4ac77amr466612125e9.30.1792114913369; Thu, 15 Oct 2026
 18:41:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAJnrk1YifN22mA5PFRVrh3m_ygxax6x4_8nraG2hPqCzyzBj7A@mail.gmail.com>
 <anpsLy_pCanocgS1@google.com> <CAJnrk1Yoj7fqbzurmHkbA-vegpQu3cf-_dfvKor_VxuNhPR-AA@mail.gmail.com>
 <CAO9r8zPLipVW6bvyDK1ypSawbo=LHKvmLqWH0xA6WMR9GYNJpg@mail.gmail.com>
 <CAJnrk1ai-TqcudPoK-qFRYAJnUjBmg1kVa6Vxg3eDm5w5ivqSA@mail.gmail.com>
 <CAO9r8zNJ=Fpc0pZExrttVTDCM3yzSmLPCAU=+RS0k5Pm+hY96w@mail.gmail.com>
 <CADrL8HV7_f68qfd6hG=xCTqzupPqr77ynbwdz8jm0hzjdgDVeg@mail.gmail.com>
 <CAJnrk1aHdBm4CofvKfx7B3H-uF2xRXZUQs47J_4xeRmRZ4hcZg@mail.gmail.com>
 <CAO9r8zOkBVgxdb3pCyHs-ZQTxhwBmA1_+aH0snV7dzbVaVsPsg@mail.gmail.com>
 <CAJnrk1ayOhrFY8LOMYxqEMYZvhK10zjTTyOK93VzMgxpV5W5sA@mail.gmail.com> <as-fG4VB_4xnAI8n@google.com>
In-Reply-To: <as-fG4VB_4xnAI8n@google.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 15 Oct 2026 18:41:40 -0700
X-Gm-Features: AclHuK_QVOAQKY1S1XZkxawe6wbx-PftEnFXONrhi5eHzH2ij5-uw40iTGdk8vU
Message-ID: <CAJnrk1ZezmmzrYdf8KP6re_a76izMS=qGPeC8ZZXiteHyZZC-Q@mail.gmail.com>
Subject: Re: memcg stats flushing (WAS "Re: [PATCH] fuse: disable default bdi strictlimiting")
To: Yosry Ahmed <yosry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, James Houghton <jthoughton@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, kernel-team@meta.com, 
	fuse-devel <fuse-devel@lists.linux.dev>, Jingbo Xu <jefflexu@linux.alibaba.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm <linux-mm@kvack.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Yunzhao Li <yunzhao@cloudflare.com>, Song Hu <husong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 24708C0005
X-Rspam-User: 
X-Stat-Signature: 465o5ijmwc8m5fpajtp3xu3f49bh5x4h
X-HE-Tag: 1792114915-337645
X-HE-Meta: U2FsdGVkX19gOOFjBLHpGNGDGn/VBbvvp0y/+XQlJ6EtEbIaevYdRYCR6ikLzT/tIPHXXp1J3DiiL41YLg2WAwuJVq7hqglxDyxZU6SAyoQcNfNRmU10AsNMoH/l/KACjabjFtBIJABtKOkxG5QT6qcsH+GQyFap/kfCLYBblda8S+dikjpLkQi2wL2WQSakxwRAoXu5vmLZ8dlepLS+uqvMiGRIMir4X1WYpqeqJBlF7ge6SR6uGRd5V1/odrJtRyor70H/xI9oto6qP7MUREJDFfE41MwA+JXDUJ07AFLRLEYIuyC87NmUXVT23+S8RVIQ3BdjXWT0+7rIkxowytOLIB62dbqX//HwvHiWbEVkijTaYPRMXFSj0OK7CQiZ+5B53SKsA109feI+yGBsoCLGN3X3p3L+xvLMeZ7hSzR2V61PYJfhvewV6QjUy0wEShR/8iY/LeuXiA3PLu36vxyoEunKk3ZDM1o8YCwNSAG+7mhX3r4zUsUoTOlwykS+mqFcz50hDiQGMfPqIAfKEc6bNef7h4VQtpXRCdxCwcKdYai5NNr6VblB9jUv230wPlLRKOLlPielA7p+x6nRkC+Y/Z12IUijTO/bmEiG1iRXuV8yyyeyPpziJZyjW1wLVf3BtCIYU6h/gJ8rhnJ10c/dJqOfTAbnWjpudPkljsbsYhwPnGWFNwy6AzgGKF7FVds0/GnbEAt1q9hS9V7Y7UdFppd8Y4cvXOwLNh+hrKzd9IDevSsX9MhWtYl80gPK3m/Md2i0wfMQhNaB94Dojm8rxZmE68YIoxiUtWsuPMXNylk+/LqHjiaXXHDxGZI14hO3cKq7F7U2HiN1GO4uGkzPFs7/qgFk4OOh8li11WBNH32gzoNAqBYQIfb7dETUhAP2qKNHryCjSUwpT9Br1StuldJvzoBati8j9f405mXxxbrx2JfB0F3YajZl1dWpfpYmxkpBkcnVgZwmh85
 4SiHNE96
 SVHv95G4n1P0MUs67uj+s4ZdWsvcBaQsk0BBW7aonRu9gSUs8C/3bRDesCYOwB1iEBUjeKtU57YwUUPqmSz4KcIdqmTpLvVH5WOnnMtN5EG6L0Mu8wP+kKSH1X4KeLARMmTjtXovskUBA+XWp249tsXWZRTd0lGymTC2d9Qm2SPmHpmaV/3hPogzTKZlw2wLzd947DqeICgcwq+Sj46xpoGUofyh8rJCdiG/xQWZu4Bm696pl5fNlS5NTYI2hfSYWH/+DjxezzYrjKzhPd7SiJ7FwxhZZ22FBQy8szMx0EYlDYqUnHuS4PJfp+5lHbMbqq59QM0jkKZjjqtL2mpTBtFFRPxgVziGtz+LUkNKEqA320a99D3T4aPWKi7R8QoizYWeGgeMtWy6TEqycuQ6V+UXEVs1E36EJUk8Kwc07d9/Kdcuwqq0ufvQYzSqFqQiWqq63IIPLJ5fPX7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 8:34=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> > Thinking some more about how stats are used... I think there's two
> > categories the stats fall into: a) hot in-kernel ones (eg LRU sizes,
> > workingset counters, dirty/writeback, zswap) which are read very
> > frequently from the reclaim, refault, writeback and zswap paths and b)
> > userspace-only ones (everything else) that are read through
> > memory.stat / bpf / etc and much less often. The hot in-kernel ones
> > are a small subset (~20 of ~80). Most of the stats fall into category
> > b). However right now, a flush always aggregates *all* of these stats,
> > even when the caller only needs / cares about the hot in-kernel ones.
> > Flushing does all the work for the stats in category b), which the
> > in-kernel flushers don't need. With the per-node lruvec copies, a
> > flush goes through 100+ counters per cgroup per CPU vs ~30 for just
> > the hot in-kernel ones (on a single-node machine).
>
> I didn't measure this before, but I did tree adding a bitmask to check
> which stats have updates and that actually made flushing more expensive.
> It could have been the case that hot stats were distributed enough that
> all the cachelines were being fetched anyway and the bitmask was just
> added overhead.
>
> I think you should do a simple experiment first about how much flushing
> gets faster if you skip the stats not used by the kernel. It may or may
> not matter, depends on prefetching (conversely, I wonder if explicitly
> prefetching the entire stats array on each CPU would help).
>
> I think it would matter less if we manage to completely get rid of root
> flushes (except for userspace stat reads).

I ran some benchmarks on the split rstat trees idea. On an x86 80-cpu
2-node machine, it makes in-kernel flushing around 40% to 45% cheaper,
but for the userspace flushers, reading two rstat trees adds ~25%
overhead. I think this could be remedied though by just keeping the
existing tree as is for userspace flushers (eg hold all the stats, not
just the ones in-kernel flushers don't need) and adding a "slim" tree
with just the hot in-kernel stats for the in-kernel flushers. Reading
memory.stat would then just behave the same as it does now and the
in-kernel flushers would just walk the slim tree. This would add a bit
more overhead (and complexity) when updating hot stats though, but I
haven't yet benchmarked this "extra slim tree" idea nor pursued it
further. For the prefetching idea, when I ran some experiments with
prefetching the entire stats array on each CPU, I saw it made flushes
around 1% to 7% slower every time.

>
> >
> > What do you think about splitting the stats into two rstat trees, one
> > for each category? In-kernel flushers would then only flush the hot
> > tree (~30 counters). memory.stat would still flush both (eg userspace
> > would see the same thing as it sees today). Each tree would have its
> > own lock and its own stats_updates threshold.  I can run some
> > benchmarks but I think this would make flushes a lot cheaper, and
> > since flushes would hold the lock for less time, it should also reduce
> > the contention we see between concurrent flushers right now. Together
> > with using node counters for root readers, hopefully this will make
> > the non-ratelimited flush cheap enough for all non-root in-kernel
> > readers and ideally let us get rid of the ratelimiting variant
> > altogether.
> >
> > Do you think something like this makes sense?
>
> We have to consider the update side of things as well. How many code
> paths will need to update both trees? That could be a problem.

When I tried to measure the update cost of the split rstat trees (not
the slim tree variant), I was seeing a lot of inconsistent / noisy
numbers I couldn't get rid of even across boots of the same kernel and
even between memcgs on the same boot, which seemed weird. I ran perf
stat and that showed that the slow runs were executing the same number
of instructions but had a lot of extra stall cycles. The variation
between memcgs on the same boot pointed to maybe cacheline contention
being an issue and when I ran perf c2c, it showed that the most
contended cacheline between cpus was the first 64 bytes of
mem_cgroup_per_node, which is strange since those are only read on
stat updates and not written to.

That struct already has cacheline padding (_pad1_) to keep the memcg,
lruvec_stats_percpu, etc fields on a different cacheline from the
lruvec but apparently Intel/modern cpus do "spatial prefetching" that
pull in the adjacent cacheline (the Intel manual [1] says "This
prefetcher strives to complete every cache line fetched to the L2
cache with the pair line that completes it to a 128-byte aligned
chunk"). So I think basically every time we read lruvec_stats_percpu
(read on every per-node stat update), this pulls in the cacheline
holding the lru list heads. The lru list heads are constantly getting
written to by different cpus, so when the stat update happens and
pulls in that cacheline, that ends up introducing a lot of extra
overhead because it has to fetch that from another cpu, but also even
worse, whichever cpu holding lru_lock has to now invalidate that copy
before its next write and wait for all the acknowledgements to come
back, which adds extra latency to the lru critical section and
delays/hurts everyone who's waiting on the lru lock. I saw these same
results on the baseline kernel even without the split changes.

I think having the update path find the per-cpu counters through the
memcg instead of mem_cgroup_per_node fixes this. On a multi-threaded
fault benchmark in a single memcg, it improves shmem throughput by
~35% at 20 threads. I saw also that the inconsistent/noisy numbers I
was seeing across reboots / memcgs on the same boot disappeared too,
though I'm not sure yet why that fixed that issue. I'll clean up the
change in my tree and send that out as a patch.

But with that fix applied and with another series of local changes
that move LRU stat updates to outside the lru lock (I'll clean up and
send out this series as well, as it also applies to the base kernel
regardless of the split changes), I didn't see the split changes added
any update overhead that wasn't within noise. The lru stat updates
changes to move it outside the lru lock are necessary though, as
without that, there was around 2% increase in update overhead, since
it added more latency to the lru critical section. But after that was
moved out of the lru critical section, I didn't see any degradation
anymore.

>
> From a code perspective, it would also be a bit annoying to maintain. I
> would check if we can eliminate root flushes first tbh, then check any
> other potential optimizations on top. Subtrees should me a lot smaller
> than the entire tree.

Will do.

>
> > Separate from this but also kind of semi-related, I noticed
> > css_rstat_flush() takes the rstat lock for every possible cpu, even
> > cpus that have nothing to flush for the subtree. Maybe another
> > improvement is to just first check locklessly whether there's any
> > updates and then just skip the cpu if there aren't any. I can send a
> > patch out for this.
>
> Only the updated cgroups are on the update tree, not their ancestors,
> not until the flush time. We used to put the ancestors on the tree on
> the update side, but we don't anymore.
>
> So we can only check the if the per-subsystem list is empty, not the
> subtree specifically, right? Can we walk the per-subsystem list without
> holding the lock or deleting first?

My thinking was that on machines with hundreds of cpus, a good number
of them would likely have no memcg updates since the latest flush so
even the per-subsystem list would be empty a lot of the time. I can
try to find some data though on how often that actually happens in
prod.

I think maybe walking the per-subsystem list locklessly could be
slower in a lot of cases than just acquiring the lock? It seems like
we'd have to walk the whole list to know for certain if it's a
negative or not.

My plan is to clean up and send out the changes I have in my local
tree this next week (the cacheline fix, switching root readers to node
counters (getting rid of root flushes), updating stats outside the lru
lock, removing ratelimited variant of flushing (and then if needed,
more experimentation on the slim tree idea)).

Thanks,
Joanne

[1] https://www.intel.com/content/dam/doc/manual/64-ia-32-architectures-opt=
imization-manual.pdf
(bottom of page 62/800)

