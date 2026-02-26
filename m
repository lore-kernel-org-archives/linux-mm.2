Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D3E1FD460B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 03:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05E46B00A7; Wed, 25 Feb 2026 22:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9997B6B00A8; Wed, 25 Feb 2026 22:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867926B00A9; Wed, 25 Feb 2026 22:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 715786B00A7
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:37:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20E8C13BB09
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:37:18 +0000 (UTC)
X-FDA: 84485197356.21.EE47E04
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id F333B100002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 03:37:15 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3i9M8/E3";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772077036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jg3R22OOVfrafHOHSh0bSMLnUJD5uZeRUb4Z2gkWz+8=;
	b=Ztw8OVF6CcCdE/nonaL8ghw77FepcD3XahoEqpw65p1HmNN/08MrA1TQ99LoxoW/28dCFP
	wUJRSroY8bN5HyIV7NG/px2PfYl5ffriwm7uV8wRY0QbEA3bO2tPsjb3bitBjJ4ylNm5Xq
	HJVVDzeChVRg4phR4hRX+c/Qk90IeUQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772077036; a=rsa-sha256;
	cv=pass;
	b=FKA/ykFGyQDemIpKhb9BAVrhiaxixxvsf25uZ7L6ha98tIBFVF5vs4CDrBT3BHJlu+Ymmu
	YC3rt4Xpi3skHcPb7fViHwM1Gncg4cwQMOU58az16vV4JJGdWFTdqwUQuyWJnUR/Ly4J9b
	x7ed6hLw+7YNz1AMt8vC80JuZLTZ4Xk=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="3i9M8/E3";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of ackerleytng@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ackerleytng@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-389fad34e2eso18291fa.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:37:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772077034; cv=none;
        d=google.com; s=arc-20240605;
        b=kPJxiE8Q6wlQ/HwtrPqA7YEipO4g+RC79qtndM2JghLGH6xI3J7/t+zgCr5bmgMQuT
         WLKK+1f1IOZ00o7L0VeFNnvD6bKmLk6eWb0mcmLz8CWyNqbTttWfkAFFcCojSeZZHKSg
         KgUxdy9d2/EpAvysOz419ExSjhGyJiCxgWrtORkOGtPpqaHeS3T8q01VRkAqp40BwLhU
         mC/BeiW0PC4O/PAl9pxKwYc4o9OwuAppbrK7gr01SY/s/YfwXCCOv2CiN7AcsWSOEoND
         Kl/+N906D4sZu6GeEWmMJgVNshG3HJ6dLgJJsXE9QBQzK1kPvDC22TwMfG/HLbw/cW/Q
         KQyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=jg3R22OOVfrafHOHSh0bSMLnUJD5uZeRUb4Z2gkWz+8=;
        fh=qVg7EYrL1yyKvSBEgq15UJT+pmRsePMRgkp829ifELI=;
        b=GPZZ7zs+xcpOsrN+65ONAo5vUyBBP+fwNG7RPm9Rw8r36zGrNjUfQ+D3sD2UmUIf+9
         ARUP/SsUxioFCrPXJ5CoJsy2Q5IspR88WQ3knBa33Vdn3gbyLag1JkX6CZu4ScfHLPGx
         ONJxYn8q8n8De31qyF35e1OZK3cF3EfMbvYEXakzf13lwHKdi12q1FqAFy4IylJKNVA9
         pChnhCLmRhAVLcK41WIFGEg24c54KmUCqEnWoDW/xTq3SFagrqo4LninOdK26ROjNftY
         fPMGWyjIP4+xK/PhpLcCV30MwTr22TI8Wpqrrn0SXpTwSiLueTe76KY+rQHJ0ged+jIH
         zqww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772077034; x=1772681834; darn=kvack.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=jg3R22OOVfrafHOHSh0bSMLnUJD5uZeRUb4Z2gkWz+8=;
        b=3i9M8/E38k/7dNTL+GPnLyfEcYPKXt3OJ9D0FTKbMAa6oiQ4KOQa1BepnP+wmnL13Q
         DGO5r2fjdpuc1GO6D1HKIGMayg7Q/mxKx6w7f8my+O1eElMLNCCI/kPq+FQTQydjFPBY
         e+Xy+fvKU5YTgL4ijZoIb+QNPC2/L9niMlu0+NCT4MXJamg2uop414z4dV3l18RbyjUv
         rCe6v7DqvDybAiCJYW9z8v698W1ihpN6I4II7AhfFL8A9QSt2uVjbabd+SQuhRzGDL4V
         3izCUMkUOGO92PVui9VzvmbDr5T0F53nXCwL22EGl5k39daUp5WB96xVdYgQvITYi+l7
         S3BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772077034; x=1772681834;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jg3R22OOVfrafHOHSh0bSMLnUJD5uZeRUb4Z2gkWz+8=;
        b=n++/gEGW4jef70MGQrqYpBl1XpXF9eH2XYrpqOry3FmnIN+Gf8c26JTOaa0yhdekrn
         qRtvHpw3bXwdNg9j4DXCj6DFJJ7ZIF0uNNOqxBE6vVPdzPSoCFS0SUl8xF2QaEAHF8B9
         3UU0eQFqAS5QEenDAiJZK9ohSoRu66W6Y+FvliXq3V6vb0lz5p0hFCxSbq1dbAfT9Ylx
         Bi6APp8pphxhwO0vywZE8kUpJ9r3YNf91HaQdsKQE3dCdoZk7NCe0pngHPBDDicnqRYI
         luEu6GO0URtoLI3U/yqwiJ9N8p8mrCu64uoRKnbHlt3ypTUL021F7NqLFGHC7AaJJzd+
         sfjg==
X-Forwarded-Encrypted: i=1; AJvYcCU3gQsLBD/xwWuyQoQ+pV7BbLjtymkSFxgzBnuioIrsP0IM+eXaZzMkiXqAuaKZeXHPdQhAdyiQ8w==@kvack.org
X-Gm-Message-State: AOJu0YxPu/uaWqjyPRK8V0Z1jjLky/4YiPrMteQdJDxsYfASr5xfiNnY
	ExhD1wovDEIVObjd7o/iR2/AKDqysB/QieHLVOZ56Vw6jkseLfGKks6ROzE9uh+PuZWORmchcmI
	rLmo1vwPdBA0+jzd5SWwxUcF2J9ZwCiqFgBSh5ykp
X-Gm-Gg: ATEYQzzDwkJg4A4PKYLeDhABN7PBOS+/TlQULcwTREYltRoCPsYN651ibNDypdOcSjt
	j4a5EwV/ToYDDxVI60qneO27WxQV0IAtJakC93T++/nE9Q5398gmEwrt1JfczYeDiXsN3q7XdR0
	oTjH3tfkM/jx0G9hwq1/H50nuKhNGeG7JgKqT4R6wCVBfB9h1oUxr8gGvroy/3tWWtSG0pJAFy/
	Ju8W490gv+P3Dllr/lnuc6K/gM1FlmJ7xIdHKyaQmjYt2pw7KMgRZuDwb859igcTPXjwSX5pJhV
	v+sLjmECdxzSB39xrmEoJ6CjYjcvISoYZqpWvEdczNIeOXQHLU2viTZX1us/aVvEelaGiQ==
X-Received: by 2002:a05:6512:3d8b:b0:59e:5c8f:75ff with SMTP id
 2adb3069b0e04-5a105eacea6mr921238e87.35.1772077033614; Wed, 25 Feb 2026
 19:37:13 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 19:37:04 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 25 Feb 2026 19:37:04 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20260225202437.4077364-1-joshua.hahnjy@gmail.com>
References: <20260225202437.4077364-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Date: Wed, 25 Feb 2026 19:37:04 -0800
X-Gm-Features: AaiRm50_sTs9jAEWMqZ835Cj7pEpp2iIBtsZ9twJbpGr-Sc3zM2ecvbh25350Y4
Message-ID: <CAEvNRgGaJXbOGPQSgvo3rVDfis22DC4hYy=2Rczas0Vm3o66kQ@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/7] Open HugeTLB allocation routine for more
 generic use
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: km6tfcuzsihsghpua5cjdf3io9h75t5w
X-Rspamd-Queue-Id: F333B100002
X-Rspam-User: 
X-HE-Tag: 1772077035-124996
X-HE-Meta: U2FsdGVkX18fzc6Epn5VDFKmh+ezYNVHDXw/owrVsz6Z1IkaYvUWiEhCUBJglggirQvP9U0kMnf5MG5qHsXYLl88UpJiXSJJfoRefpyFdwl4WiqKy52RYYwID5SacSQDYJlrAj+OdphpM1BYld6JD5o0A82u5MJOLSv2U4zTODrFxfVwK/ojWbyZMp5zKI534WmOaBgpu1ucLhtF0F02c4T4mSMba1cJ4/pXYjvsN6BVPIpNr0HSsRxc/AC70324dA0yO5H9m7N6k/mU/uGKxwAJMIV6rluuEVhdW8iiErIOP3RQk2Z2VzRQFn3nqvylyLYw0Xx47Wui8KJzaxBc64oUawXKnlAPeoatJHQY7OvDCjyLwzabqZcwp51oKcU/uNY/oLYAvIK6dQ0H5s2ExWLznaYWY66ew/KYX/7lyK6hRGP6srtQdVjbrD4l7z4M4EZxk8/fmKvcVnYDtPtfsTZKWgLJXwSPP6eUzY9BG387/wr7uVEFWRXLwEQM/Dg8B5clAFCZTEdcn6Ln3jCdOvRhKLgeMqqDMMIjiWc1MQNOY8FHYEwPro8UgZTxdqWpoTjbS/pP4sXGSXmZwQlQe3Lo2linQtgeD70H5fz3VsVfhZHzsWHcOgKVhY7fr1fbrYD4vd1tUdRieW88DsRqP4trUwVGXfQyl0HnMZWzvaTbF3FqcgmOVE0Mechk7GmPI8yS+9zxWWcT79s5cTW/QBmsfqYv35dBP65GQ/nMkYDOA9S7W5ux7Hv8xZMFzokQjqna0d+oIEeKAOTUUIlTJmP3p9GMIG0CxEcoOwx9svHTSyz+/PSSXJYIO+3OKwY/uZ/i7UslGYtYb5maf+1BpMxcIHpyJKonO0/XIQ/kpB1U3k8M0l80Yo2K/fK2u1PRVIStkgSH8isqjbAsbqWS9GVUaVfRsamkpWMNRPlqyLRMFCHxKmHYfiZExBsyZljuHrUQ6cDZ5nwyUF7bTn9
 g0jBFHNr
 UPJ3DEUPNTxi+0kRFr8Y3pAXvfBKiWeTEHLNnWAdR4cpJ3ga01q0B6zA87w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> On Wed, 11 Feb 2026 16:37:11 -0800 Ackerley Tng <ackerleytng@google.com> wrote:
>
> Hi Ackerly, I hope you're donig well!
>
> [...snip...]
>
>> I would like to get feedback on:
>>
>> 1. Opening up HugeTLB's allocation for more generic use
>
> I'm not entirely familiar with guest_memfd, so pleae excuse my ignorance
> if I'm missing anything obvious.

Happy to take questions! Thank you for your thoughts and reviews!

> But I'm wondering what hugeTLB offers
> that other hugepage solutions cannot offer for guest_memfd, if the
> goal of this series is to decouple it from hugeTLBfs.
>

The one other huge page source that we've explored is THP pages from the
buddy allocator. Compared to HugeTLB, huge pages from the buddy
allocator

+ Has a maximum size of 2M
+ Does not guarantee huge pages the way HugeTLB does - HugeTLB pages are
  allocated at boot, and guest_memfd can reserve pages at guest_memfd
  creation time.
+ Allocation of HugeTLB pages is also really fast, it's just dequeuing
  from a preallocated pool

The last reason to use HugeTLB is not because of any inherent advantage
of using HugeTLB over other sources of huge pages, but for
administrative/scheduling purposes:

  Given that existing non-guest_memfd workloads are already using
  HugeTLB, for optimal scheduling, machine memory is already carved up
  in HugeTLB pages for these workloads. Workloads that require using
  guest_memfd (like Confidential VMs) must also use HugeTLB to
  participate in optimial workload scheduling across machines.

>> 2. Reverting and re-adopting the try-commit-cancel protocol for memory
>>    charging
>
> On the second point, I am wondering if reintroducing the try-commit-cancel
> protocol is tied to factoring out hugetlb_alloc_folio. When I removed
> the protocol a while back, the justification was that for the most part,
> grabbing a hugetlb folio was a relatively cheap & fast operation, since
> hugetlb mostly operates out of a preallocated pool.
>
> So the cost of being wrong, going above the limit, and having to return
> the hugetlb folio was also relatively low.
>

Thanks for this! I saw your patch to just optimistically grab a HugeTLB
page :) For that patch, the primary reason was to simplify the logic,
and the simplification was justifiable because grabbing a folio is
cheap, right? (And so grabbing a folio being cheap wasn't a reason in
itself?)

> It seems like this patch series introduces some new paths for hugetlb
> pages to be consumed (specifically, without a reservation or vma).
> I imagine that these new paths make the slowpath for hugetlb more frequent,
> which makes the cost of assuming that the memcg limit is OK higher?
> I think explicitly spelling this out in the justification for reintroducing
> the charging protocol could be helpful.
>

Yes, I should have done that. Will copy the following to the next
revision.

The main reason is that reintroducing the charging protocol is the
clearest way (for me) to cleanly refactor out hugetlb_alloc_folio()
without worrying about the edge cases around HugeTLB reservations and
charging.

If I didn't reintroduce the charging protocol, I would have to depend on
freeing the new hugetlb folio on memcg charging failure, and the freeing
in turn depends on the subpool correctly being set in the folio, and the
presence of the subpool influences (in free_huge_folio()) whether the
reservation was returned to the global hstate. Aaannnd... there's also a
hugetlb_restore_reserve flag that controls whether to return the folio
to the subpool (and the hstate). I find folio_clear_hugetlb_restore_reserve()
on certain code paths kind of magical/unexplained too.

I would rather iron out those charging and reservation details
separately from this series (with more testing support).


On the other hand, reintroducing the charging protocol has the benefit
of avoiding allocations (not just dequeuing, if surplus HugeTLB pages
are required) if the memcg limit is hit. Also, if the original reason
for removing the protocol was to simplify the code, refactoring out
hugetlb_alloc_folio() also simplifies the code, and I think it's
actually nice that memcg charging is done the same way as the other two
(h_cg and h_cg_rsvd charging). After hugetlb_alloc_folio() is refactored
out, the gotos make all three charging systems consistent and symmetric,
which I think is nice to have :)

I hope the consistent/symmetric charging among all 3 systems is welcome,
what do you think?

> Thank you for the series, again. I hope you have a great day!
> Joshua
>
>> To see how hugetlb_alloc_folio() is used by guest_memfd, the most
>> recent patch series that uses this more generic HugeTLB allocation
>> routine is at [1], and a newer revision of that patch series is at
>> [2].
>>
>> Independently of guest_memfd, I believe this change is useful in
>> simplifying alloc_hugetlb_folio(). alloc_hugetlb_folio() was so
>> coupled to a VMA that even HugeTLBfs allocates HugeTLB folios using a
>> pseudo-VMA.
>>
>> [1] https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com/T/
>> [2] https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25
>>
>> Ackerley Tng (7):
>>   mm: hugetlb: Consolidate interpretation of gbl_chg within
>>     alloc_hugetlb_folio()
>>   mm: hugetlb: Move mpol interpretation out of
>>     alloc_buddy_hugetlb_folio_with_mpol()
>>   mm: hugetlb: Move mpol interpretation out of
>>     dequeue_hugetlb_folio_vma()
>>   Revert "memcg/hugetlb: remove memcg hugetlb try-commit-cancel
>>     protocol"
>>   mm: hugetlb: Adopt memcg try-commit-cancel protocol
>>   mm: memcontrol: Remove now-unused function mem_cgroup_charge_hugetlb
>>   mm: hugetlb: Refactor out hugetlb_alloc_folio()
>>
>>  include/linux/hugetlb.h    |  11 ++
>>  include/linux/memcontrol.h |  21 +++-
>>  mm/hugetlb.c               | 228 +++++++++++++++++++++----------------
>>  mm/memcontrol.c            |  77 ++++++++-----
>>  4 files changed, 212 insertions(+), 125 deletions(-)
>>
>>
>> base-commit: db9571a66156bfbc0273e66e5c77923869bda547
>> --
>> 2.53.0.310.g728cabbaf7-goog
>>

