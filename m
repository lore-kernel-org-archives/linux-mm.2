Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44DDBC982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 19:02:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271FF6B0088; Sat, 19 Sep 2026 15:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223B56B008A; Sat, 19 Sep 2026 15:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13A286B008C; Sat, 19 Sep 2026 15:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E048D6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:02:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71A76A5686
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:02:44 +0000 (UTC)
X-FDA: 85231433448.07.6A73D85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 73B4A20003
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:02:42 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SwSsWnoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789844562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pdt+VykzrSdAH3Ihk6G7KeWETmDZjvYwTDnvxuPWWYc=;
	b=7dprDDkpNTd5/PWu0I85VWtUSCyako8heP5pWQDfF7ZKlUt79eMiG2yIMy1O2J51AQjSQ7
	UC6QZB5T2YbWcKwloeUsJMP+3lwZ11/71pzUwiKfioc0xBS0BC3Uw9m3OoT/82F7lWHHfn
	ZiY8Xty51IkgpCeCIwWZMrpObYyx4T4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789844562;
	b=yG/MlAFq+f5qenImgwvSuTO6lxbzlrGdCM8Vd77araW/oc5WOryRuzw0Xj2FAax+itXVMs
	HROzxULRIu6Xy+JlctY75246SzwP177ezTa3uXJJVsVVfE31gNNasySGz/YemrGjp4siVj
	1QzM8N7imJ5DPev9OYN+xY8kRg0nlP4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SwSsWnoF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48D5F447F5
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:02:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC601F0089C
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789844561;
	bh=Pdt+VykzrSdAH3Ihk6G7KeWETmDZjvYwTDnvxuPWWYc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SwSsWnoFcrQOKgRuytKcpjfsIrzNHOKZ014DWMcXuKQz7Hs959kApuIO1h+WWQ6nz
	 kPaToMBXOsZGrk7VuOZ5hhviYnA6zzGJTgjF/RB+RhMBDxhGr590P1SzKdOcRsXFkC
	 5lQESFgXXA58/1TMYaEkg99/Y8CwZOP5Cyff0P0PCXwdqXwO89UdtEKVTQ1v01xF4c
	 UGgobhkmrzxvipIzSSEKxC1qq7lksO/rcwJ6I4l7UDBYrAYfbAddAS6/+g7BSc5UQp
	 b2rw/SIdtWqIYmPuRFXODhXLFiW3n3BOhN7QYJYlkz8ByLXnwx/E/5LMzMBzCRaKmO
	 dFVZhb865hyKg==
Received: by mail-yx2-f42.google.com with SMTP id 956f58d0204a3-6729ca45e37so451815d50.2
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 12:02:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwlJaCuE2PYdzAfCxu/UVf75a+NHbKCDwp07Tct6RpS9HZLZzRV6a+Ib7v5fFwoqQgRJoi4p9+5/g==@kvack.org
X-Gm-Message-State: AFuF++kJTLqDwEgsBAmDDo3KnnbOtULGkkFiVCwrRmY8ajp4S3HSwLXd
	L8fL23Jhv/uIEM0TjbSNWnKgu5/gMH3wZCG3i6hWY9pe61mgVMpgD6kKe2jZefIdFfMIUZJ66gY
	DryHJCBSr5Px2GxOh9cRgaEN86CmC+1G6eYlwa0vlDQ==
X-Received: by 2002:a05:690e:418c:b0:672:99e0:ebf1 with SMTP id
 956f58d0204a3-67299e0efe2mr784209d50.137.1789844560242; Sat, 19 Sep 2026
 12:02:40 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
In-Reply-To: <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 09:02:28 -1000
X-Gmail-Original-Message-ID: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
X-Gm-Features: AcwNN1XjloUiBKubGVavEZ51xBIrMqQYV_VtL3A0tpER26tTv3nQ8ltxbACyHsc
Message-ID: <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Gregory Price <gourry@gourry.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 73B4A20003
X-Stat-Signature: fh93rdh5tpu3d9zap83t6pkgd4x43g7s
X-HE-Tag: 1789844562-760990
X-HE-Meta: U2FsdGVkX1/jemCUxeDeJ7Ye/L2UX02B3Y2/7HPXp+97NnG1j2UOJXQsosEkLiumEacwQtFLopH+X8nnYN3Kkov5t/avyjpkfNkHg34Wz/gwDmTrFhLE0AKSr8Zb7K6FxN+twQLwZsCPqHtff949t1Ay0hchilAkMWFaRNb0aG98NzeKjCHb06nIZSPe3EdZkp4cCplFE8+HBM9WMBUOBnzcBcMqXZXJNBrUI+Ygpx9ZxDGKMoUFNfyak4xjJHiUMM95BilS2ZfYUZ0lWYCGMT71pxboxpbTiakqYBxnBYMYnD2t0XOGWszpWwortvjjBWgHcb/55ApI8FiCPxkxdpY0BU4MUPPZAUNssxHdeeaoSWSToxDN4qOCIqLT1AXJi8hBWvUn/mFpojcT2GOMWUKQnEbXY5ChvRe/IJljAftws5zE+vcl1j8UlMVgmrQM6FjCSUWqdk49YpViC4mq6PUwQgOWLiMLfIgPg/3Jwk2e4gEpLqIKPT3ogM/KXNpKpyY81OoxtKK+XQV9u/QKAuj3ogXG8yJELefJEkJHPQwaJan2/6Ylsuao5c4y2Mi/WmAU+8mzSRmRe6W+S0w2q2jgJPFB1vsAQFlVz3Nam29OBeF8pnEsHEhAH0lLasHLeS5a0si2KjL3LIeM9uOJUu+5R/oPbdbOdivfIuZxRmefq288dlKcUlYZs7wywbh1xjbbsVIFOVFkqwGCZAULDErzorhCWE5+ABEvA/rxnUKLjRayWT9Krm85v5nMRizFwI2kOyf1y2wf/zBltcn0+YOhp3f6+MytJxzOGXCRuTuBQz+Rh8O9iksATGClzxyEPPuPd/XYNTOK2VWHoF7XXkqFQOw9+Ra1Yn3NFZRgDzC1EdaxsA4UvITlTHAsGFC5EZVmvNrU8ItwiKYoFI1OJFwOr8d32aiOx4IE8zhi1RCRDx51r8FqY0Oq9ut6zifYI83/epb4I0Whwt6hagt
 5aNCznXG
 YfjanGqWHwtVWtu77DSMYb0fouFkwsK3+Ks7OGJfL53byE+Phpd3h8wiMGNTABYI4pDu8xmW89snBWgBLQNOhS08edPY4mRHHfMeCnMvkEJjx1HmdAaljrmNKVAIpBcachfnSMrz8MKqtxhO0BhXBj3I5w8pyecNEX6AOvQZlo+rw0iAbN6jSaEH9k1T++4ZpcmvdPc/y8rsii5Qhp1VKcThGGKsTTbPlYOeilujA6rvgFektG+xaBXP/EAKSvHm4luZkg5cqDgWo+LDuG0kbijz3EQI+D3K7yplLQcm5N0tylVIHCE1u9iIdeUVcsSwBK4jacJwPsjJUsXhG00TPxvE0hEEf6N1g12udVzxRFDmyU9r1/5lOCNJ1jKFV+Sfu+u6mXz7SAtEHKJGN2Ohen7IkYpvpXKV+3cxQDnUG8YBpi9oOxJpZorst6mCuignLYrXp7cM9ZBQht1bT2BEWHsvARA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 6:08=E2=80=AFAM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Sat, Sep 19, 2026 at 03:45:03AM -0500, Chris Li wrote:
> >
> > I found this new concept of "compression space" very confusing to me.
> > Can you explain the swap behavior and problem using only normal memory
> > usage reduction and latency without introducing a new term or new
> > metrics?
> >
> > The normal user doesn't even know what compression space is, let alone
> > what makes it transparent.
> >
>
> Sure they do - it's the amount of memory consumed by compressed data,
> including the metadata associated with it.
>
> converting Johannes statement to diagram:
>
> >> Compression space is not a separate resource. It's page tables,
> >> backing pages, and swap descriptors. It's just MEMORY.
>
>                           Page Data (PD)
>   [page tables][                uncompressed page                  ]
>
>
>                         Compressed Data (CD)
>   [      recovered space     ][pte][swap meta data][compressed page]
>                               |                                    |
>                               |---------compression space----------|
>
>
>                         Memory Pre-Compression
>  |[  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ][  PD  ]|
>
>
>                         Memory Post-Compression
>  |[CD][CD][CD][CD][CD][CD][CD][CD]-------- free space ------------|
>    ^----------------------------^
>          Compression Space

Thanks for the explanation. So the compression space is just the
actual data store backing the zswap/xswap/zram.

> It's actually really confusing to represent this space as a traditional
> swap device - built on the assumption of a pre-defined size limit - when
> that size limit has already been defined (the memory itself).

First of all, the traditional swap counter has a very well-defined
meaning. It is the size of the memory that, when accessed, requires a
page fault. A page fault adds significant latency to memory access
compared to access without one. Whether the memory is backed by SSD or
compressed RAM, this is an invariant of that definition. If you change
the behavior by not charging to swap when swapping out to compressed
memory, it will break our deployment, causing many OMGs. Kairui also
mentioned that this will break their usage as well.

Therefore, I must push back on this. Please don't change the swap
counter charging behavior due to the risk of SLO violations for users.
This is a user-visible behavior change.

Secondly, I notice that you are reasoning from the memory usage
aspect. That is a different usage requirement angle than the SLO
violations. Maybe we need a separate counter to track actual memory
usage, regardless of compression status.

Let's figure out a way to make your usage case work as well, not at
the cost of breaking existing usage requirements from an SLO violation
perspective.

> Baking any kind of pre-defined limit *into the infrastructure* (whether f=
or
> an optimization or ease of implementation) is what requires users to know
> what compression space is.
>
> Even using memory capacity at boot as a limit is wrong - hotplug exists.

This reinforces the point that viewing things through the lens of
"compression space" is confusing and muddy. That is not my mental
model. I want to add support for your usage case as well. Please
clearly specify what user usage you want, what the expected outcome
is, and why you want that.

>
> > Why does the user need to care about compression space again?
>
> They shouldn't need to, that's very much the point.

Great, Sounds like I can safely bypass it.

Chris

