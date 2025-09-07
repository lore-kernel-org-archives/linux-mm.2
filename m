Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3673CA1017
	for <linux-mm@archiver.kernel.org>; Sun,  7 Sep 2025 17:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E992A8E0005; Sun,  7 Sep 2025 13:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70AA8E0001; Sun,  7 Sep 2025 13:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86A68E0005; Sun,  7 Sep 2025 13:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C4C008E0001
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 13:51:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79F941DF505
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 17:51:30 +0000 (UTC)
X-FDA: 83863196340.28.8E69E8D
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf24.hostedemail.com (Postfix) with ESMTP id B967B18000A
	for <linux-mm@kvack.org>; Sun,  7 Sep 2025 17:51:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757267488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UqSUBcaUaGvMCXj0T8YtoBxTk5+pyRO33HmMycuMOv0=;
	b=3my+FhVDP/5upFO4SKdWHXlIb98pFgLFQ4b5e4Bq0N2x6P5/py2R6oBAnhH5bfX+8MFZxT
	JhqsoO7W6Zqq6OKG7FK9HAMmTWjc+Z7guuQA1rSFmB0FYw1vZsSrTiBhYOvC3BXVTIaWWS
	m4VT7qVfZNnj8BpnoFARhQp9a7fZFKY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757267488; a=rsa-sha256;
	cv=none;
	b=v1+oyOVWWePhk9PWl4hJDqcyT32UM2Eg7HKSzjghdy4PFewZ+XdJhbFMBtCdoKoIG+yEh8
	utv5GdvmjytiZXPuP9paUwtrg/TYRoC+iQzrzh6Rp0bSzynDEVs3LZYFBzl3pbuywG514O
	j8YP8wR1CklcVM4fiEug9dXiSPbXFc0=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 8 Sep 2025 02:51:24 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 8 Sep 2025 02:51:24 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Chris Li <chrisl@kernel.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, gunho.lee@lge.com,
	iamjoonsoo.kim@lge.com, taejoon.song@lge.com,
	Matthew Wilcox <willy@infradead.org>,
	David Hildenbrand <david@redhat.com>,
	Kairui Song <ryncsn@gmail.com>, Wei Xu <weixugc@google.com>
Subject: Re: [PATCH 1/4] mm/swap, memcg: Introduce infrastructure for
 cgroup-based swap priority
Message-ID: <aL3GHJJ6+elPD7OP@yjaykim-PowerEdge-T330>
References: <CACePvbUJSk23sH01msPcNiiiYw7JqWq_7xP1C7iBUN81nxJ36Q@mail.gmail.com>
 <aLJ4fEWo7V9Xsz15@yjaykim-PowerEdge-T330>
 <CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com>
 <aLRTyWJN60WEu/3q@yjaykim-PowerEdge-T330>
 <CACePvbVu7-s1BbXDD4Xk+vBk7my0hef5MBkecg1Vs6CBHMAm3g@mail.gmail.com>
 <aLXEkRAGmTlTGeQO@yjaykim-PowerEdge-T330>
 <CACePvbXAXbxqRi3_OoiSJKVs0dzuC-021AVaTkE3XOSx7FWvXQ@mail.gmail.com>
 <aLqDkpGr4psGFOcF@yjaykim-PowerEdge-T330>
 <CAF8kJuPuOWUEMg6C9AnAA-mddgHRjuMVqURrbk6bUHxAmEvgFQ@mail.gmail.com>
 <CAF8kJuNW2kmxKYRE9t8WvSOad9JkLYt0WSAcFOQ9r9=2=XGc9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAF8kJuNW2kmxKYRE9t8WvSOad9JkLYt0WSAcFOQ9r9=2=XGc9Q@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B967B18000A
X-Stat-Signature: haad9weibzphx7ygtn9yxi6zo6mcpwj6
X-Rspam-User: 
X-HE-Tag: 1757267487-849842
X-HE-Meta: U2FsdGVkX1/kgGo7dqCIgbcrefg9kmA+q43aHlvzuESbzYFzwBYShihWQRr1EMsw9x8uBvIY2no8GWZrlHyyaXj/1Y7+472DDfibz48ymMNMFOC+WEfHcKCyMsV85aFKdMcKQQMY9ODaIJPZnP166yE6a+vfZVjOY3SLmjHLuccegvf+wSkHEy0EbiTXoBw5Zy/fLWoBwXO+yKteH8Y5K9pti4kmOptS4eBnQR+wVQC3P8pvWofG5aF4aLIc8y+uiL5HX8Uc4KZTqkUAF2U8sazpr3crIMhXXA5Eb0lJGHpfQBfapFomAuhYE/BTYeylow9V/3lNtE5dBeHFw4GkXIEjwvJbiNeeRWkYG4tDU94oG/gIvBiJ9PN6Qf/IgHNi8pu53/Sd6j5XAyjIaiiN9Y60x8129y7MWzdeZ/KS/9nRD0pAYXbp3ZLEgV5af5J1onBDkOtVhsSq6vhJJuXh0odDH1Okj8t7dZoDDiRgxhUoteLyiLLpj3336IljTZQsrtZBiHHs+xxEMBrFc8ANrMcPS+/EXi6ORaLQIYiKWHSToEsCH+86FbrcUthtEscTW0vw4CxRGK+qWMT6MH2svVkwfOoybWH4hCg5x81JjykrOXrWi574V7whlbtdg0WQb4jmHXJXjJ8b/jpV0wXM4tPK8B/3ou5/V+a4BvS6NEgcCIPc91ZjMD3C9Lo5S4DMqqNj7ARtf0GpoiH4C5ywASJuavLDcobhKCWRlp/XUi/Fm9PwkJKtJ9mxKVqVmozdiz8oAuldWqgY2WHXgWrsS0c4uAHeUgEPIXcBw3KMXShMT/XIEYXkH/UAigaFEroQAHzY76wViSb1iU+UUtfeniEWfypm+YIroep/capBPNm9z1Hoya5+GzwTBq3H+JOWA3u0iT3ORcqua6cTZbPmcWweitfq5/sN60j/S/eUdDHdDg5K3iXzMYGqKunhbXa5IbX//8oGPlSJC0CS6uR
 UeIQhW7N
 Fmp2bTXgmNOSn/PVEbiq123sot1cUHKhujxqtO85vdw2TQCGoSRFpJ/L70dBsUt0FMdprzAM7Pzf3Uf+TRLPNXmikj/AmyzonumosYSw4TBBVNqFXFxYPzcou8TVEw+t7ntTJxcgnJruVohT/nFSQaj8cmSNPbh51WXgo2ANvCIDet9/PmcCBAXR2SSeTka/PIWMqcqBiNjsNQY/2wKgCvBxvHpoSfR2EZV9JhjnZMoet2wxKMcNCLqn4YOU3R8EwbMD5W8cFVtvDj5Q3TQuNrb6oW9XOFXPUyzIXFjkjhmgEcXkkSI3VHHGzjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, Sep 5, 2025 at 4:45 PM Chris Li <chrisl@kernel.org> wrote:
> > >   - Mask computation: precompute at interface write-time vs runtime
> > >     recomputation. (TBD; preference?)
> >
> > Let's start with runtime. We can have a runtime and cached with
> > generation numbers on the toplevel. Any change will reset the top
> > level general number then the next lookup will drop the cache value
> > and re-evaluate.
>
> Scratch that cache value idea. I found the run time evaluation can be
> very simple and elegant.
> Each memcg just needs to store the tier onoff value for the local
> swap.tiers operation. Also a mask to indicate which of those tiers
> present.
> e.g. bits 0-1: default, on bit 0 and off bit 1
>        bits 2-3: zswap, on bit 2 and off bit3
>        bits 4-6: first custom tier
>        ...
>
> The evaluation of the current tier "memcg" to the parent with the
> default tier shortcut can be:
>
>         onoff = memcg->tiers_onoff;
>         mask = memcg->tiers_mask;
>
>         for (p = memcg->parent; p && !has_default(onoff); p = p->parent) {
>                 merge = mask | p->tiers_mask;
>                 new = merge ^ mask;
>                 onoff |= p->tiers_onoff & new;
>                 mask = merge;
>         }
>         if (onoff & DEFAULT_OFF) {
>                 // default off, look for the on tiers to turn on
>         } else {
>                 // default on, look for the off tiers to turn off
>         }
>
> It is an all bit operation that does not need caching at all. This can
> take advantage of the short cut of the default tier. If the default
> tier overwrite exists, no need to search the parent further.
>
> Chris
>

Hi Chris,

Thanks a lot for the clear code and explanation.

I’ll proceed with the runtime evaluation approach you suggested.  
I was initially leaning toward precomputing at write-time since (1) 
cgroup depth is might be deep, and (2) swap I/O paths are far more frequent than config
writes. Is your preference for runtime for implementation simpleness?
(Any other reasons I don't know?)

Thanks again

Best Regards
Youngjun Park

