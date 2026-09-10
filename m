Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53E78C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 17:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFF106B009E; Thu, 10 Sep 2026 13:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB00A6B009F; Thu, 10 Sep 2026 13:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50216B00A0; Thu, 10 Sep 2026 13:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91E8D6B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 13:16:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 479DF1205B7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:45 +0000 (UTC)
X-FDA: 85198507170.15.57C0D4B
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3A89FC000E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:16:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nwous61S;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789060603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
	b=kYjQWmJG2Q8AgyNesLpUlpqnfTrKEfJpAykEr5QPhDgZP98kSoK/Dg8hih/KDVsSoaZUPw
	z/ODtqOUG52dtUr/H8GlzsdYYvdCG56fa1CP6mY+fG1Pa9cYBaUBurw6T2ypiX4Jr60lhl
	0ENwCkLMwF6UeUgyihG70byBmRB7gNI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789060603;
	b=FhBqfI7w+ZVwUe+FG82vfGUFRDfQ+f/jZ3P+WuRwpGCXhcXRRPZTUNvhAwoBFF2+9l7mLv
	tp9iNilQp+6MxwIEk5nM2z9dSSbM3ClarZpHNAOAs/BN+quCfBHUXd5CqIbQ1zFwzcoaLn
	LQ4U4twsF3+UIUOWmCEkKJd0MTbQxFc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nwous61S;
	spf=pass (imf28.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd38e0e5dso1019575e9.2
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:16:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789060602; cv=none;
        d=google.com; s=arc-20260327;
        b=I1z5aioTYqqCOiSmzzbLzfVUmsD6wlUy6kesY1qvgUnCkBeSrGuX54PWbNmdVHP5t2
         eBIOWrOa9dts7lfX8b6y/eQzFFNNgLcTIRWziRULqjxRGHiB4/jyR/h80s/K4c+WGyNf
         cfA0v7b2lfMyPA8gXurSAZ/Pb+XRAiWAM1pnxH2t01Wrb9MpoczXDk3rTAyEfJ2NWA7v
         MvzLIdmfWMvRhZi1RAs/kZ3ViyWiritC5YzxQrRzgSe6WjXk0YC4PdaXWqOSCIvTA56J
         GaBwqEWpRMHXR507N9G2MyqYD2TPBUkWNq1+6WbmTdeul07niJmfsUYJe/E79wQgwusj
         XTYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
        fh=GDVQ87zA3vHATlG0tduG/9eKIQknCr7lb20kzqRuOCU=;
        b=UorFsezAKwmu4V6eHYkmDujIpa3wj/0qplU3ooA9fGk9A2ICerbW5kEfQrSu/UrdNl
         xHSsrEub10hKDcYxjjrJzHkretTP/7nfa8aV+G9MBM/10Tcp+on/34kV6mZsC/CC7vXm
         6J6k4vSk2fwwL4X6vXephQAoPt16MfXPo+UbGE0Udl9DaJrCFim30Jh1qxq0Bd0RmF7o
         XDO6YsPj+H+22wUXMuG+pofVQ5liiwAoEW/92ZWkEvJGK8k/4f+7ZoTugx5P0wkZJzwy
         /j9fim4DeN2dirm8bCwk7IG15secFwNmt5fBZg+GG1FYXhpOCx3NUQ3SJQ2bG5aNxKCe
         1VqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789060602; x=1789665402; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
        b=nwous61SDKKUv80zT+ghF+CmkdotxPUKCHB8afW62lsjYlCqI7uLHhQpHOEuun2xuN
         R3Dax4hue0jrmuT25bNRAvX7IEU50qDX8QiZpmyJytQoUdBd9H4yZ7+KjfsdqIBn84zW
         pLFefTWHwybep6RUZyHMVxyVIUK0Ty9I61kNN7UlbqZWUbvb518OVSTw3KafmDy+OnFM
         l+0hcwv51d5anI//7qj3YH3/EDjtdSkfe1/dqcvwdIpGRgiROWBAezBBNftl9Fv1uB0f
         lHTOqCrr+L+8Qe32Z0ogeexlKqJ11IlayMPiXFttkEj/mE2fKiKxy6MyC4kG6dLdI7KF
         Mwnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789060602; x=1789665402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Un/VHATR/EGghh0ufBgw09ip6SjFofuvZJfHCoUMPHk=;
        b=E1sF03XpIy7KvFPvWYAg90mHl9Vq4iHjlpNQz+CBiS2QvQ/Y7OtzofUM55VGVo3LcK
         jNa+JEOUNUbBd4RGwnBs4/BYCllbEYHDVQR9HCPEMEc6mBlSPS5fg1U1sPQYIIvTQVxL
         n/T0r26kjpvHw3FmdLZzkTgmRB/U1LKmSybIsS1hxScnyzTDEdsa8ScOAXVj6UIM7ahP
         SP7FT4C+FAFTCf6LUAsWSw6TouGuiVtyUhyGsxKwjPNYBiP/R6aufLhKvHPskXUSTINt
         U0SlIC5Nh+Y7wRfGZUyREsLUKhJ7ut/PI97iuoex/82e1eCIHd0ZKkyssg8qwZUc069z
         LT+Q==
X-Forwarded-Encrypted: i=1; AKwUvBxVhyBNiPtqDXL9/gJLixcanqIWkRMixl7umt8gti9paHkp3f3HEqriYmZiRIVtk0UvKOA0/VuhpA==@kvack.org
X-Gm-Message-State: AFuF++m6tQVUYDhxn+d+MNbIWWU7+zgOpdbWDj4v1Frs/57rPz2+4P/F
	xD+hawXyQkHbSp92x0sT4n1nOFyneAknPe2Oul+8kgCfEthOS84CfPcOKlE+w7sXtPzGRjhO18P
	sFlkmY21JQYm6xEEwF+3/dRthr0Q9S30=
X-Gm-Gg: AYBFou227IukXM/BsWSkfGsrqDV+gqUOZ8v9kxMtikfUCguvoFgfWMubarnUgSZZ5nJ
	s3TQKzl+yyymuvN2tHZzkc/3at72CXS5vIxA91BQmnw4Rg5YkIPJq3B3JdjBL3A3uoDUYzJr7kf
	PImJbhnBdWTxmUCpzlEVcD/sQ8lBn+A00DftClLlsviLKiCHlXgjxRbF/5e6axl/Ftltsw7UucZ
	/nQ48Q2IIDhcc/nzjiCZzKb/M+78S3RTbHEq9ooxwNAVsSqeTWihEYZjlncNBvlWHOttjyxkWZH
	q7D/9/4YnYFH1aSm95t4E1Rp3Rl0uGznQhmhMuqg/XmZ4861cMHeK/UghRMfB5cOzHyI8eqnuDI
	3Wy7daZLA54Bv
X-Received: by 2002:a05:600c:8b88:b0:49c:f512:2361 with SMTP id
 5b1f17b1804b1-49d2593842emr197602865e9.14.1789060601172; Thu, 10 Sep 2026
 10:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
In-Reply-To: <aqJXx2vtbKaRLt3x@fedora>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 10 Sep 2026 10:16:28 -0700
X-Gm-Features: AcwNN1VTPR2ZTAJOXYkJZpQy9m22jjFCFlr0LTd8tBFFtkKWaolpETKGFGCIdxs
Message-ID: <CAKEwX=PaQG68C6=jpaRmAXrzw4c_90rv1YwGdmrEWq_RXqVeEA@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Baoquan He <baoquan.he@linux.dev>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3A89FC000E
X-Stat-Signature: aitqw8ngu8cu77qe47cknatdi1rgaauf
X-Rspam-User: 
X-HE-Tag: 1789060603-141428
X-HE-Meta: U2FsdGVkX18z44/t9lo5TpXzJ5TjCI8yiuawFYOiHo4PZEjACRBylkTuaZ/zmjRO7BLpVCXU5GcmccUFXs95rnFpECKW8KMNYAI+ofRIkw0+6ITgTk4OICLkYkn73Obo56gF2ys4+hjo5GIxzfTXDoh//hp1ysflHya7tynQ0wqz3gB7MhO49p5NvKH7X3Xr/f4fptkcURwj9u40jyLRFvPBajCOcPtCBfgCxOnoK549NWcFbZfPabwoYJbPyJxUszoxIurI845kr2XUE/rUxyol3IP1WxRPItfXKOkAhHKO5yDwukWpu1AJ5R2F54+EY/rEge9Xdje8FOsGMcx6snUPhXNAua9seam3XF664KGEpHslPFU0MaoY6j4tg1/tCQyH//IKk0jIa7jQ7L8SRbGvT5XyXG7Aq3jx9NVWdPfvEeQcVkUSp85iLLoEjcCBqL/hNvUMy0jaV87SRtcy7OoWvF8NRPVlEHZY+OEygy1MYQ5JvD/9JT69Bqy3Fm4LNHOCsGFl5TcGZvPAQ6ofhh0sz6RndjGESj0SM15wRWwcIo+MkM1I1C4Uj3mFA+D2U+nZeI1b+8piuGrAUEk7pxF+xbf1Vq8f2I42VbXymvT7bhpdlxguoPBIlNBofhkvUXuKO3uchZeo4PluArBsBRZ+Fmhl8DYaje3+jt9JaYe3t35WDG55uLhAVRtJ5zMlSWO3B1CqnJZOePyOTTzDMW7vwdey/3lvWUd26UGRt3R6g8bX9iMxy3cuI8qOsAg62j8r1kQ3cE3twaF/tYdFFKz7CZ5XA/s4XkKXlkMqE9Qan84BCowAMzSUId/hDvqqmqTnXT/HbJUFmcjmtuZqrUJDBrd2pf7yzt9nmYeskr59zSWlpboChgN0Le6glg1b3/glhlF+5e+naT+UqAf9x4xCAFiJRHJaxm9NxjxnWTpGi8Wiyd1p6v/+OPWXBCa4u57T4X9kHbwT9aCFBhW
 KL5AT6qZ
 1DwA9U9kHhEIDSrOSCTqcob/tJaAkJvPBzHQh4uVpjQ6R3Ffx+UMo2NJjD/ErwyybLLpU9h0OSobL2PWj+vACotTFLTXCRyljQ3U+g1EqIavvH//5QNPb9G+e8xKmJyATT5iCVf7IiXCFxqJ7nc3/YoqONJrQ7zVGfRPNzpvg8ahf+/OZ/1WAzEcjtZuBYi8jBnigLrVfs2kqqZHzwYz90COTxAqfEQ1iSJ3Gjy8bEO0hepmWDavMQhugJWSa6iD97DHZ/uPo4S1OitbLvMaAW+hP0Ryko/A0peycNfA4aH1V9WbpsilU2GHuTvvPNAmI3VoI08rH7B4ndQqHfG+mxkLazNTumLVDW0ZjailpZD68aeCKYQC8mjZBVgRWLK9IcLfwa9KFhp9EvmyeZ8RaK+UjElXDZzBsv7YbPpf586D9yeYIgSVpTVGH1Hi82E5LN9ms5kAAKfWEEFpaVHjWi8d94KpTC4IuJJUZ8H65NoE3GnX8GBRMCMK27+5bGBb45NmPANVcsbehb9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 12:10=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> =
wrote:
>
> Hi Nhat,

Hi Baoquan,

Thanks for the detailed explanations. I'm glad it's all laid out - I
think this clarifies a lot of the confusions both of us have about
each other's perspectives so far. I suspect we're talking past each
other a bit (hence the effort to organize some form of VC, or
preferably a room where we can whiteboard things).

It's a very dense conversation, so I hope I don't miss any of your points.

>
> On 09/04/26 at 02:14pm, Nhat Pham wrote:
> .....snip...
> > Now, on xswap. Baoquan's working on a series [15] that covers some of t=
he
> > same ground, and the VM_SPARSE cluster_info idea in it is genuinely goo=
d.
> > I've been reviewing that lineage since July [16] and I'd like whatever
> > lands to end up with the best parts of both. From my perspective the
> > differences are:
> >
> > 1. Userspace knobs. xswap asks the admin for a size (a percent of RAM) =
plus
> >    a per-device limit to tune afterwards. I'm not aware of any use case
> >    that needs those, and I don't think users have a good way to answer =
the
> >    question anyway - sizing swap for compressed memory depends on memor=
y
> >    size, workload, and compression ratio all at once. That's precisely =
the
> >    provisioning problem vswap exists to remove. The kernel should be as
> >    transparent and dynamic as possible here, and not add knobs unless
> >    there's a use case for them.
> >
> > 2. Writeback support. Writeback is core functionality for zswap, not an
> >    add-on, and a design needs to account for it from the start. This ca=
me
> >    up before, in the discussion around Chris' ghost swapfile RFC [17]: =
for
> >    a solution here to be acceptable, it has to work with the primary
> >    usecase and support disk writeback. Without it, whatever zswap won't
> >    take (incompressible pages especially) has nowhere to go, and cold
> >    compressed data can never leave RAM.
> >
> > 3. Cgroup charging behavior. vswap/xswap shouldn't be charged against t=
he
> >    swap usage counter. It's fundamentally a different resource from
> >    physical swapfile space, and memory.swap.* should read 0 when nothin=
g is
> >    on disk [18]. I made the longer argument for this in [19].
> >
> > 4. Data structure (xarray vs sparse vmalloc array). Even with xarray, v=
swap
> >    is already on par with or beating baseline. I like the sparse array
> >    idea, but why are we landing an optimization before the feature itse=
lf,
> >    without any A/B data showing the difference matters?
>
>
> Thanks for laying this out, and for the honest push to converge. Let me
> be equally direct about the ordering: I think the xswap base should land
> first, and the things vswap demonstrates -  writeback, rmap lookup, the
> charging semantics, later THP -- should be built on top of it. Because
> it is the foundation that keeps the swap core simpler, and the first thin=
g
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
>         atomic_long_t *virtual_table;   /* Backing pointers for vswap slo=
ts */
> };
>
> To support dynamic growth and shrink, vswap stores its cluster metadata
> in an xarray, and that forces two things the plain swap_cluster_info[]
> array never needed:
>
> 1. Every cluster has to carry an extra index and an rcu_head =E2=80=94
> 24 bytes per cluster =E2=80=94 purely so the xarray can locate it and fre=
e
> it safely.

I will flip it the other way around too.

With this approach, you induce 8 bytes of overhead even on physical
cluster that has no business storing vswap related information. This
overhead exists as long as you build with CONFIG_XSWAP, even on
cgroups that don't use it.

That's sort of why I went with the new cluster struct embedding the
existing struct, rather than adding the vtable/xs_table to the
existing struct in v3 and v4. I mean it's small, but why do it if it's
avoidable?

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

I think if you extend the vmalloc approach to cover the writeback use
case, you'll find equally many places where you want to check for
vswap.

It's simply cannot be avoided - if anything, for correctness. Some of
it will go away as we evolve the code (for e.g, if vswap becomes the
sole way we can use zswap).

> - __swap_offset_to_cluster() branches into xa_load() for vswap vs the
>   flat array otherwise, and the xarray path can return NULL (a cluster
>   can be torn down);

The xa_load() I have no arguments for. It's just data-structure
requirements, but it should go away were you to move to vmalloc array
down the line.

But the NULL-check is not an xarray property. It's a fundamental
requirement for true dynamicity - i.e if the cluster can go away under
us, then we have to null check wherever we do not have a surefire
reference, no? For e.g, in do_swap_page(), before adding the page into
swap cache, you cannot be certain that the swap entry is staying
around...

> - __swap_cluster_lock() branches into __vswap_cluster_lock(), which
>   wraps every access in rcu_read_lock() and a CLUSTER_FLAG_DEAD check,
>   plus kfree_rcu()/container_of()/rcu_head plumbing for node lifetime.
>
> With VM_SPARSE, xswap's cluster access is exactly the plain-array line th=
e
> rest of swap already uses:
>
>     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
>
> no branch, no RCU discipline, no tear-down state machine, and no NULL
> return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> cluster layer stay as simple as it already is, which is precisely the
> part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> on.

Except you have to write multiple patches to handle dynamic growth
(and a limited version of the shrinking).

I don't think it's a fair characterization to say "vmalloc is simpler
(if you just avoid these multiple patches I wrote to custom roll an
extensible array)".

>
> I'm not going to claim xswap wins on throughput. I measured it:
> on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> within ~2-3% of each other, effectively identical. Because the cost is
> dominated by zswap compression, not the cluster table. So the ordering
> question is not "which is faster" but "which structure should the use-cas=
e
> layer be built on". If vswap is chosen, the xarray-based table is an
> intermediate form. Your own ablative study already showed the flat array
> wins, and VM_SPARSE is exactly that flat array plus lazy mapping.

I need to clarify this point in particular. What my experiments on the
synthetic/semi-synthetic benchmarks show is

1. Baseline (old code) / vswap / baseline + flatarray (i.e replacing
zswap xarray with a flat array) performs within noises in most
benchmarks, on most metrics

2. vswap and baseline + flatarray both outperforms baseline on free
time of usemem, by the same margin.

Basically, what I wanted to show that a huge part of the wins come
from zswap's xarray being very inefficiently used in free path (for
e.g during process exit). Vswap also uses xarray, but in a more
optimized way in this path (one single tree walk + one flat array
walk).

So I'm not quite sure your characterization of "flat array wins" here
is quite fair. It wins... compared to status quo, not vswap.

So IOW, vmalloc array approach does NOT outperform xarray approach, in
both of our testing.

>
> On the metadata side I want to be precise, because it is easy to overstat=
e:
> the per-cluster cost that xswap saves is the xarray-induced index + rcu_h=
ead
> (20 bytes/cluster or 24bytes for alignment), small.

Thanks for verifying my analysis. I understand that this overhead was
a long-time concern for folks - Chris pushed me a lot to minimize
this. Took me awhile to realize I could get around it.

>
> On writeback: agreed it is required in the end. But it is a consumer of
> the foundation, not a reason to pick a different one. xswap is deliberate=
ly
> the base;
> - writeback
> - rmap lookup
> - THP support
> - memcg accounting
> All these can land on top of the xswap base rather than be stranded on a =
table
> we later replace. As we have discussed and I have been mentioning in each
> cover-letter, I didn't touch these core changes, glad to see your work bu=
ilt
> on top of it.
>
> On the interface, xswap v2 drops the percent knob entirely (your point ab=
out
> "why not just max out" is taken): create now takes only an optional
> priority, a device starts at full RAM, which is free because the VM_SPARS=
E
> area is mapped lazily, with an optional per-device size limit for admins
> who want a ceiling. More importantly, xswap keeps per-device instances
> because the swap->ops and swap tiering that come next need per-device
> operations. A single boot-time vswap can't express that, and it breaks th=
e

Why do we need multiple devices to support per-device operations.

I have decided not to opt it in to swapops yet (vswap swapops),
because it just doesn't really buy anything quite yet.  But vswap is
just a normal swap device, no? It can have its own swap device
operations etc.

> per-device conventions the rest of swap already follows. When I tested it=
,
> there is no way to disable it at runtime, so it can't even be A/B-tested
> against regular swap in the same boot. So I think a boot-time vswap is an
> independent issue which deserves a separate patch posting with a convinci=
ng
> justification later.


I think it's the other way around. We need justifications for why we
should expose virtual swap device to the swap tiering abstraction.

I think we should leave virtual swap device out of this interface (i.e
being transparent to the user), and add it only IF both are true:

1. There are some cgroups where we want vswap, and other that we don't.

AND

2. This is not something the kernel can decide based on the
information it already has.

1 seems reasonable, but for the use case I can think of, I can almost
always come up with a heuristics to decide whether vswap can be
bypassed (for e.g, if a cgroup only allows for physical swap devices,
it seems like there's no good reason to use vswap at the moment -
you're just unnecessarily paying indirection cost). So we don't need
extra userspace input here.

Of course, this might change in the future. But I struggle to see how
vswap cannot be extended to fit in the swap tiering model? It's just a
normal swap device - you can export some special identifier for it,
and user can echo <that identifier> to the cgroup's swap tiering file.

>
> So concretely: xswap base first (runtime file-less device + VM_SPARSE
> cluster foundation + sysfs create/destroy), then the use-case layer, wher=
e
> your writeback work, etc is very welcome. The base should be the one that
> doesn't need to be redone; by both our measurements, that is the flat-clu=
ster
> substrate.

It's not quite as simple as that.

I think the other concerns is that can xswap be extended to support
vswap's full scope. I will note that as of the v1 of your patch
series, even the dynamic growth portion itself of xswap is still a bit
buggy. Maybe v2 will fix this, but that would be multiple more
versions to even unblock a subset of the use cases. Vswap meanwhile
has more efforts poured into it, including production workload
exposure. You're asking us to invalidate all of this effort, which
will set us back quite a bit of time.

