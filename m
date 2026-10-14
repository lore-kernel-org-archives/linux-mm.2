Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19541C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC956B0088; Wed, 14 Oct 2026 16:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E46B86B008A; Wed, 14 Oct 2026 16:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE78C6B008C; Wed, 14 Oct 2026 16:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1B2D6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:24:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C7201607DD
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:24:46 +0000 (UTC)
X-FDA: 85322360172.02.17CF9F3
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 047E940005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:24:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iR4Y3Krt;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792009484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AZpHrF8jH8WXu6WIXCauYQ4g5rjWW4oCNhs7abbw/eA=;
	b=rMMhiwf3EzEdnksfD1ufmumXvELXn4JBmcMDpI4NNo1uUrPLuUUYH1ztYTwbiIXhNr6JPB
	Wje/mCOoCVLDai7zvUEj44Tj13IGOz0BWJU6wTBQTuik0Z2VX3lCb/6NcKPNSICCeTiU0k
	i0jzX2o7Q3kyWn7cRZpakTdcuZ505PY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=iR4Y3Krt;
	spf=pass (imf01.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792009484;
	b=iY0LzMANwyJAi86cSXEuXU+3v8davN97/d+77GTZoks10njZyoHiPbv1whcJoxJB6GZzkO
	U2wwJZpLZEkLnQ33bPDcfcnZlEMGTBi8uY+opuKwipmQNgXxMxFktVvqCVpdsUW92Q0hJB
	v7UhpK94xHCIrFCR+n2f9CMZegK3ekE=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93e7ad9f78dso539485885a.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1792009483; x=1792614283; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AZpHrF8jH8WXu6WIXCauYQ4g5rjWW4oCNhs7abbw/eA=;
        b=iR4Y3KrtnuvqtP8IITTgVgQso+3ihgjQoEq/iOYdoviu35mmnbasfFAX2ymYkONFkL
         2b07ELfaGh+wj90QReF4NG3cms4BDD9ob0QJPIC6aqn9/GyxoU2DZnhcyZjpKZtJD2Qm
         qiO71NReQh0n3llaeBgOPOwyzJxStEzR2e1Hn3hj4QGMXP/uyIw3ugojnpiUdRRGNh9E
         Y7gDdwnQJdedyywtBIRcq/rdzs6dvX7Yt4rVH2aQMW0+OQ/ru7KSH8sSfWO2WW/rfEfw
         NeLwcwakWHuplJv1QGKLyPnJL/Zed4GMzKqZ5qyUgGFpa73Ke6slpvmlW7BLpYDZhO6s
         LPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792009483; x=1792614283;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AZpHrF8jH8WXu6WIXCauYQ4g5rjWW4oCNhs7abbw/eA=;
        b=QTTsdoPl47jO6ZrhboxrkwmDOF4AmteY+pxa+L5i9i8S2Ei9FS2DiFMYBOpCq8fHhF
         sq+XWt0RCVuUiGrhuV56dIvuZID4fnlumsx+OGcVESO5KqhylwDl4UXThUmSFBi9cYef
         iBS9+3yGOZ1kw2qSA0tFQVrFNFxrb3qg5n9YFcZZZMOOBfUOYgpaKXBzdbKyJ1C3iMP9
         +7cuYvrydmqgFUAOnI75pGDO4ZSeZoWJbZuh54Yy0FvwWB2clwGyn5gNlfcAjsd0WqYA
         0CJec4SrHQdOzY4nOw2DZCqVOgb+tXjx8Mm3Z9XQb1seSwYM4LhpDbtZeUBKNkPEGhZX
         pM/A==
X-Forwarded-Encrypted: i=1; AKwUvBwBmBuqcrZk7zePxvmCkI4NeEDoG1PNS2vQYjGjSThHM5cIObz7Hx2H2llZmrs0KTQ0bkRsjyZTlw==@kvack.org
X-Gm-Message-State: AFq9FYJiXQ3CZOJUKR9YehdkuT3Q7crTntgurng4712IXXqdxfEpDwcc
	QSmj7brhyf35p9G86fnZvdICxbRd6tFWhp9YcJF02v4YFPyxJm+77sk4JLZPavmqpV4=
X-Gm-Gg: AYBFou1wvSNGNaIpxTcrI0TXSDqhgproRdiBe0ZbeU9pHjU7xxNGMzRgC7BjfK+t2C6
	SDR0Wdl2aFb5XPRPC0AF111ylUvCnBJDOj3GL/W8kKOpS30KzUp1phAsnUkt7EJCy3I8Rqww9a+
	AMLKLhraI24tSkXvAs4T/aNskP5pKY5TKf3bxXt5kaQIQnEIv6ed734QcE+PVimJdft5WJdgZBx
	WnPgYdBAJSvbPEI/0nXzrYWksDoMmDs6nmnKADdIvCXUHbnEU5RGuEtTy2RkfaJgLrYDqVCQ+fq
	feuMdK71HCcEFf9Q1g3jlFRaVxPO8+iCWh4X15fE+96WiocZ7awFGsrEC2OmFy3cSq/lK4f0RXd
	d1DSm7O86N5nsgmwWhscL4QLpErY2SOgYOFtxH20/gfklzNRamCbcRyUGh6YGneiwAnXw0vsDGE
	A3s6oy5FEVq6AY1dPsdcJvEwU7CoKgmmmwYAg2LN5ka3imyrGvstcBuAVglRvAb38Xv+wx
X-Received: by 2002:a05:620a:a0cd:20b0:93e:c12c:f149 with SMTP id af79cd13be357-93ec12d0893mr1925202885a.83.1792009482638;
        Wed, 14 Oct 2026 13:24:42 -0700 (PDT)
Received: from localhost ([2603:7001:f100:5081:9526:3c0:45cc:5ac6])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93ef4f49861sm582813585a.4.2026.10.14.13.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 13:24:40 -0700 (PDT)
Date: Wed, 14 Oct 2026 22:24:35 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>,
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
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <20261014202435.GB371161@cmpxchg.org>
References: <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org>
 <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora>
 <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org>
 <CACePvbVTnCOh51jvEpkDJ32idvCubgN1eHBps6vESjhVC8E_aQ@mail.gmail.com>
 <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7D_=_4ZsCWJYywpZhPtg+YeH8o=ymRrV3sQ_58G6rs0sg@mail.gmail.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 047E940005
X-Rspam-User: 
X-Stat-Signature: 5367q16i5xc4mtyr3nm4jqdn48r87i9k
X-HE-Tag: 1792009483-811845
X-HE-Meta: U2FsdGVkX19ejbZJkyvMN8FwGh2chRbiCraB/5qfdpMvBeSzqoTCN8dQdaMdQntIhcmdAIrW+Qh2kRLhpQgm5P2aV8a33qDzOCJzSHTVvzN/wvF0+18t11AezvHziZ3xrJ40DZHjg4OiFalzffZnzdxtY4+sjWBUXMD0UlFDQVRtfdavsTCHKS/HEKsTGwSOAwpo1KJnr4di/6UY1640SbBhEE3Qc9xKF/lhStkGbvcVr58+skgXjBHXHi+XTZ4d0CYx8bl41AKD8G3HRqWQ0AV9Klq+VCAPqki7Hm9Qoxz8/eEIcuTamJJwKgsByqxPIJ+a8gfI2QDEvhlRcNzbpKF3XEDqgNoPXjv0tfdJ4YdYhcH1QL1TeuOTIl5sgV6BeJzhyTiKGwws+6HttI07bzqOjeit4Ag9fsrPvdYLknwOg/tMNGRIaKrxioCaYXX6wqHgnfdJNCY7vDOPcAfZ6loJpNK2XQajnsPO+QRDXImqnqtl1/wOlz/DWxuxlEYRQ4srtsBAQ6SNey83CYfGuXUtN0A3bY8gN08xHLg5pBBMNejrgo1TEjYDKFdbk9ZT1hHeClyFqGJWJIKNYb4+fa7rjAsQDi7iJQjc1/TDvb7weWIOgtzUW/PabG6aDKXOmW2hfpMRqQcZ0PcgwlbJR0Lr2qgamT0FEytp02bjr+ssMU19waReWpFuiZUru7cf6INZtbvrXlZ2bgKqzUdopMpeaYpSAQdxiJfbpMs0rOhog/VjfOJdVWvS7ZsN0oWi3psCt4eGVsyBOi9KSxT5kan/FEtEHfbHwmGgyDD54slllIq/t3Fu21KERRbWZtfLAn6LbqlL8/Se7smtklkEoOzZJtCRvBUGuxJPOHBwGqj0VC1AesmYOHb0Mf5AykPvI9X8DT4/Aul21VybLcys15HvmB9+HkAsV58bPJSfFIf3C4A/A7oDzA1SIrnSTuyg+77llV3mAdb2dHjF+1/
 dyHWz7OT
 RwHAJum4ctMQNNk2/gjfcMtgGxCyTdVa6Pf7anh7HHB2TIdbhOUi6V1ZEzrML41ie2dVPXjLmJtaa+ppOhnnf4Cfk8gArt7xLVc3vmxfzbN92BOm84/R9EhY4l2PD86m3UZz3CGd2N50Y6LbHdgzTop2toHK5RRchU8dQLZJQkXuf33rOEvh/d7mB8mrXUL4Wr/Dqe52Wdalor2PJIJ2ri3E2I0FlKblscQAHlG3EypVF9EVyQXZ7t7H7i1C8g9Hk8p8HCthPR1T89HEWzxo3xMEVhRkDyPpn0SW3fhksFH4EUZAkOHPmekmhhXNs6OYBmTVUvYaIPXGRcVtBdqyvRIuxbqXR5EhOG6pOQ1v28FMzai60jIkoLsCGaEK9pB7YS+9KCZkJ0pekAa5W0u5XWZ61ZG/1JyqwocbyLrQe22Vyl3FPhfyfwYX1bn/8y7Vd/g4SiUEDBw1Ed5K7vOYdSP9GmFoURlYh8jkJsG6VPNmbbHzlAIs2QBedIM8eK2mmO0y56vTbBDiRqkYZB0Rx7ZQlS7GbGtzzXrkgIbDTCttQfalIT8z2rloF5MNBAYlI5CaZkFwTuTIO4jQzXTLxCl4mDeW5WnAyVZpIh2C8nlNQP0zLofsdi5nDj3dW/MLtJR5vijwVU/T84ys=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Suren, if you've not been following this, there is a question you
might be best equipped to answer below.

On Thu, Oct 15, 2026 at 01:17:21AM +0800, Kairui Song wrote:
> On Tue, Oct 13, 2026 at 1:27 PM Chris Li <chrisl@kernel.org> wrote:
> > I understand that you have some face-to-face discussions at the
> > conference. Do we have a list of what has been aligned and what is
> > pending to discuss? We should have an agenda to avoid repeating
> > already aligned items.
> 
> Right, from my perspective, here are the following key points we can
> discuss further in the incoming meeting (most of them are not fully
> concluded yet):
> 
> 1. A limitation for the logical size: from my side, there are real
> usages for a global non-memcg limitation of the non-physical swap
> space: e.g. thin VMs as containers/pods with no cgroup limitations
> inside but which need in-VM memory compression and a proper limitation
> to avoid thrashing; or low-end devices/desktops that want global
> (root) limitations. And also, Android have a limitation on the ZRAM
> size (well for this one I'm not from Android team though so that's
> just my personal development experience with Android, enlarging the
> ZRAM size on several Phone swill cause serious junky of Apps due to
> over compression).

Android monitors psi to kill on excessive pressure. This should
capture thrashing from over compression.

Suren is CC'd, we should get his opinion.

> Nhat is concerned that exposing the sizing allows users to tune it and
> potentially misconfigure the system. However, I think a user with root
> permission should be fully aware of what they are doing or they can
> easily mess up the system in many ways and swap limitation is a very
> minor concern to me.
> 
> I think the requirement for a logical non-cgroup limitation is strong,
> but the discussion hasn't concluded on the implementation method.
> Perhaps something like a Kconfig combined with an interface or command
> line? More ideas are welcome.

I agree that overcommit control can be useful. But there are setups
that implement pressure-based policies and do utilization monitoring
just fine from userspace; they have no need for logical overcommit
bounds inside the kernel itself. *Defaulting* to a static limit and/or
making a choice mandatory seems like a mistake to me. It would make
more sense to treat this as a related but separate problem.

I'm happy to brainstorm solutions. But we should be open to discussing
this from scratch - userspace monitoring; an extension of
/proc/sys/vm/overcommit_* etc.

> 2. Charging: If you consider memory.swap is physical only then indeed
> we should not charge it, however, user are already doing that for
> years so this is a behavior change and we are also pushing memsw into
> memcgv2 as a interface to limit the logical memory usage of a
> container. So charging of the logical space is useful, how to handle
> that is tricky though.
> 
> From our usage, this should at least not block adding memsw or
> anything similar for memcgv2, even if you want more customized cgroup
> accounting, we need to charge it into some counter (a page counter,
> not just a statistic) in some way.

A path for memsw in cgroup2 is generally unlikely, actually. It was
intentionally split into separate memory and swap counters and not
forward-ported as a combined control.

Like I said, we should discuss overcommit control from scratch as an
orthogonal issue. I'm happy to do this and help find a solution. But I
want to get out of repeating that this is not compatible with cgroup2.

> 3. Swapoff: This was discussed again too, as vswap was trying to
> remove it. I think the concern is mostly about maintenance,
> performance, and practicality. From my perspective it's a critical
> component both for preventing minor or major faults before predictable
> high traffic arrives, or for operations/debugging, and for releasing
> the swap metadata to rule out any potential swap / page fault effect.
> There are concerns about maintenance or suggestions to use MADV, while
> I'll be happy to explore and improve the current in-kernel
> implementation of swapoff later if needed but removing it is a really
> bad idea in my view.

Here too I think we should be open about discussing the problem and
what a solution could look like.

"Swapoff" seems to presume the virtual space in the shape of a
manageable swapfile through standard interfaces.

A separate knob to clear out the vswap space would accomplish the same
functionality without pulling in the entire swapfile interface e.g.

> 4. Writeback: No doubt we all agree that we definitely should have
> writeback support, Nhat's concern is that we should handle the case
> where some cgroup doesn't need zswap/compression and ensure that works
> well.

+1

> 5. Interface: Given the issues above, what should the interface look
> like (swapfile, sysfs, /proc, etc.) and how should multiple
> (non-physical) swapfiles be used? Nothing much is discussed about this
> part though. I've heard users mention the use case of multiple
> compression swap spaces, but I don't have a use case for that myself,
> so I don't have many comments.

+1

It would be good to collect usecases first. Interfaces are forever and
we shouldn't add them on speculation.

> 6. The one part that I think we can and should agree on it shat the
> implement approach: at this point I think VM_SPARSE is the right
> direction, Nhat is concerned about the testing on it, and I think we
> can have more data for that, and collabration is highly encouraged. I
> previously conducted many tests on everything posted from both sides,
> will try to post more on this too.

Here I think we're actually least aligned.

The VM_SPARSE implementation requires a static size, and prior
discussion has made it clear that we actually have no consensus on how
to pick reasonable values - be it in the kernel or in userspace.

The xarray proposal requires none of these choices or interfaces, and
nobody has been able to show that it's actually a performance concern.

