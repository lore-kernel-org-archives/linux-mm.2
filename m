Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A250EC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BC0F6B0092; Wed, 23 Sep 2026 13:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992FC6B0093; Wed, 23 Sep 2026 13:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85AF66B0095; Wed, 23 Sep 2026 13:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5337A6B0092
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:26:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4AA8A08E0
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:26:33 +0000 (UTC)
X-FDA: 85245706266.24.939FA5E
Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	by imf25.hostedemail.com (Postfix) with ESMTP id CE084A000C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:26:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Euw84leh;
	spf=pass (imf25.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790184391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iDfKiTdrpXplViiKJrQEoO3nFWUHXMki5lh4/edWQY=;
	b=N0FCFcuLUoN/M6NX7Y9LDEDbdFUx+6vpYWUC6/dZgx2Ru6dx9XJpRg5rJyEH1v0gtQ46zv
	gPPv+kafksDAG8Zks+vK61Lj/8bAkJtRPrOR+Wb/IC26qaUrLv15TUe2PLxhgIwMD4vUFT
	ct6bzYFbyuJo1OW+SEfc1KnjVzp/6DM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790184391;
	b=nVK2Gt8RcXbgRhTIWE3vEUhw+x7W2B2XhUjopD2DDYpceOZSxny+u+UjA1VU5U9D0oLTn8
	ZXdDhvU/yUGTrLdydckD9eykZUHJArPTERptyVCY0AASHnwWfXlq29KC5I8QXiaL191X2t
	cBkIavMAQBxQGLp2IN5rG0mcF2Xv4Qc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Euw84leh;
	spf=pass (imf25.hostedemail.com: domain of klarasmodin@gmail.com designates 74.125.229.204 as permitted sender) smtp.mailfrom=klarasmodin@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b899413537so1627896e87.1
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790184390; x=1790789190; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8iDfKiTdrpXplViiKJrQEoO3nFWUHXMki5lh4/edWQY=;
        b=Euw84lehYeqn3Fv2nmDi7R46mbMiXY/h7GDi+aow7SHgkzpVKm0OHTc/aefyMm2Ioq
         kKt+eae8TZNseCG+icbmWipCsCoUYH6y8An4CY7j/aUgzrHBzuTevstlK0OywMBZ9TUK
         kAja4MTiW2/UxfY6K4eCKxILeg8OctLbTvAD9SL+QUffGIe7I9uafbQRQjXlCFi4o894
         IUykEFxnWzWRS2uzlnPCT39RlauhZ+JQ2GHF+cRkYL9ZMiavDlasx0dKCsquuT5o+AS0
         0THIzlRrn8xCwzMwuNifFzfBw5f5flO18W5hVcv6W99a0+tIlBO6LR/F1Oo7BY99F8pe
         W90Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790184390; x=1790789190;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8iDfKiTdrpXplViiKJrQEoO3nFWUHXMki5lh4/edWQY=;
        b=lNb+m+GN8LfgsQ5dMW7nRP5Z97BzGgry9KA02GVGexUBmi8UF9xiIUeHWmjc7feGPH
         IT2nucvTHYfSyRyOCBF+vaoo8x2WY7EQ8hd2ByRnUb8myTjYtKbfFPD7yRntlxi1hWLj
         FhNyEkNE357mqfUoqhaVJFuABJ7els8AfRR3kH+3qH2pf0zcaSx5Ms9fh4DUcMNxLqES
         boixUUQ1NzpS6sj+W+AHOoMzzXzB/8MBvXZ/bkJmV75jpsvCxm/baNnDHa3mpvbALDMM
         /URVgns1u+SBWxK+wDVr5aIBXExN4/2MvJIL3O+umpXDEq902PVHbn6+auD7QkjygO/z
         g/fA==
X-Forwarded-Encrypted: i=1; AKwUvBxdHkN0EHKVlgjvMbq4DFsrNdel+F1t+S0l88RhRrqQGB/Xj6mkCGNy3OpJSEOCEhkqWZF+KbPR5w==@kvack.org
X-Gm-Message-State: AFuF++kMaxEGQhuOxXsjCYFaKjojI57ZfGl99cZWgprM1wAnb5RDLC9S
	wuHVqlIR7EunRbX/k3nEoOhwdJnBXHmu1+V4f8OXqjaObTGKF7QY+mmr
X-Gm-Gg: AYBFou36Y+UZSYsyhsEESFXoNnTvIxsHhJlgDwdQZNmFn7d3vUqAthMBNTyuVtPv0UC
	CKZ0p9a2Ltif3xnQGqbqCfyEh/Ucd1SWu1v82dO8/XDVB1+6GsSypCSnUpplJSNjFZZHc/Lx6Bl
	TFFm7h+BfOrALPshxT+MkGFNTotnLd5tyvU5UgzNtDwWaWYmY6pgD96UqbQ7BVdP9rRlfpiW4df
	omZ6ANQgLf5VkcnWKXcyTu2RI/j3IyNyg2tpOHljF1ytcSjIVuv4kudvHAdPTu+TJwrVaW6sNlI
	OYDLTI0KJVXu6qQvI0HoFd5F56dyRkU7wzHlCkLCy8UICfvZNCnXu7HbByrVBGGua/5LTHghED1
	oUKaRkgaBthv1kQyebYa99pC0ZBhstb75n87TrSgJXQw1NqorxSGdtE070Cu8XypJNLdewNmZU6
	lK79Pphjg/mGgigmCU+i2NF/dVBm9Cf3Q+lEqdwYtM0wY/jJLHmElAv10TlAUad+Acgp9CBoPvE
	QrB5j2UscjCdKC2wZthFWiGWhDl
X-Received: by 2002:ac2:5696:0:b0:5b6:183b:d20b with SMTP id 2adb3069b0e04-5b8d89c2a97mr1393127e87.50.1790184389706;
        Wed, 23 Sep 2026 10:26:29 -0700 (PDT)
Received: from localhost (sol-eduroam-pathost130.ki.se. [130.237.96.130])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d85787b0sm784443e87.16.2026.09.23.10.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:26:28 -0700 (PDT)
Date: Wed, 23 Sep 2026 19:26:27 +0200
From: Klara Modin <klarasmodin@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arQHTTeLIsmw5NiJ@parmesan.int.kasm.eu>
References: <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <arKbXe1Qe-FDCTMM@gourry-fedora-PF4VCD3F>
 <CACePvbWW4avTV2WB6iRU+LN5zqkMTg3UhBrq41R0iw91-7Ni0g@mail.gmail.com>
 <5a7ad159b2fabf377b7e1fc4248c433287ac11fb.camel@surriel.com>
 <CACePvbUtEdQLmmudON_qC2aKuLYCNktBuAecFKiSvDC6eTfXeQ@mail.gmail.com>
 <arO0RCCE3Woh_I_z@parmesan.int.kasm.eu>
 <CAKEwX=Mw8DsieAeEK=Wjb2d2o=wxEN3QOoOR153u7Ki28003gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=Mw8DsieAeEK=Wjb2d2o=wxEN3QOoOR153u7Ki28003gw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE084A000C
X-Stat-Signature: grwnofzg9f3bf3uu537hkfsk6gg9wgd7
X-Rspam-User: 
X-HE-Tag: 1790184391-949837
X-HE-Meta: U2FsdGVkX19QX6o75XWtLF3hFYnxtmLmNGu0cZFabH99PWqVzDHG9eCbjLjuK/BvZkT5eX1V5I7Sl98MfYfiMPEKPaISTJOpHq1hgluRbYlTlNkF/Z7kmcFV66Z/1cadmK9pzCysfjQHJzXZR6VC7I1HXC/1UO/AWuSmwILOZ8qK0I7QAaYM66z0cARyl79PWRCcn7sHz2cfIPRtvpM/cgXfPZkvwsIeG3RmiDuxJFA97wS6CNR8aGTwO9/HJIayAwUE1ZiCaW27Ek+tDy3Ehk6EB9gRSltmr517j72jgTNsDMPQeFyrcf1VUsfvxfzPoQMWeLOmX1A1vUS66tl1uUXz2Ys02NxuqO4zCmuO5h3ve43FWQ1/igKY060dXEv+BoaMDIQb5ZPSVDUVRMRqhHjJs6Aoprb1MA7jNW42FMwQQ+umZvyMoI8GnjoPUIx/pkcnUDJNNPcoXnV1esQVx9yBcV8iysybr/453BNuix92Gu8ugQ2DFTh/fwLssFy6Z96+7K12Y4YC6x03OY0OMa4vsMQJN1xFeGU7W0rPOsk9iTImI1WmoKSWS7mkPf32EwZSmMWxCVG2KibkQ933BYO4nXON0eupOWEp+bjYOVzQJ5RfoQcit+kuKx6MAcXVQZnOeqrbiooewtPvYWHt6mRclM5VLw8905ClZEBeXC+1fFmG8eKZCjWEkSZwZgJU9r9cZCHIhuAb1ofus8ZY2ySe1O/8c+laQCGNFBz2Vmyt4Jm+lbxgbFsn7CuiyiBM+5vJWWtW+/tfxDFGS8xyWfH2dugLUzUEkvrsXSiEttPXer+ccOM8aAZNyRc8pr2YvL/Jyfsybksv8nT+HcOkXvfoRajK//+igD+Rq0b3rNGCLvd8dQs9ImJK24iKK1+mpTbMn9uRMovDeMN19PZpIIesuIoWvP6wIHZ+lqYtA0+nVvuP1NiintgNGD6u/SpT9ubBkMhJ+sQip2SzEiP
 YGgv3a0C
 vGfrxa+8s2AMXiK1iTb3j+9ZwFsgk6y0gFFPn3GPWFR0Sb8Bctr7/w/OiyS812tdck8w5gzNR+F8N4djy4CmaTpAohMVMbqlr0EEbgIreulLpCxrG9agK4IHdkjl/MaMM61QXVokCcV8PV0DN5mxpGQAfipnjYj1fJNp2nk5qCkxPm3UYia1LXSSzZ1fWmBsCsJllpR5XFulfEQP0hoOzANnCScbs6XgFFRaLSj4EAirYndWSZPbtIe7xgHATiZj2YlCsgHyOu4ldhY+ndWVCJcp3hbTpsdrW+tIhn5FRGCuCLp134voWM040xotejQJokEJ0xHU/g+/btfblqu2bTJtMpChg5e8ctNntk2bWkCybHnZgIYuokIWEYH49qpDQDMgYlVk7udhc/gK+AQGcoNxu/FqL7+BkDZugzCH6SZ3V2UJ5tmOXkZZ3LMXJvhpgzsV/2/CKQ0fbSicI7JjKpox7xx7+V36waEPTaA9Gw6DwIx5gvqKBiWsculdFNcv/d1Ylsj3RWnrVmxp9Ce+8r8iA0ETFutMp6QIZ88azLFkDaf/u3f1T+K1L0EYEgGAj0DPP51XR9yDsYcbX//+CwU4GyVJrQHDmmx6egAiWQa0aGR1CZQ0PD4cytptOClYoiPqe3U2uWk4IzLDaJUtJ6uVkrStB5Ff1nyxntfMKq88DjQ3bKJR4NA5XdB/pY7EnA4hrbouqHDPMLSPVV2zubnZmL4fhw5jBP1rD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-23 08:43:41 -0700, Nhat Pham wrote:
> On Wed, Sep 23, 2026 at 5:52 AM Klara Modin <klarasmodin@gmail.com> wrote:
> >
> > Hi,
> >
> > On 2026-09-22 21:10:53 -1000, Chris Li wrote:
> > > On Tue, Sep 22, 2026 at 5:53 AM Rik van Riel <riel@surriel.com> wrote:
> > > >
> > > > On Tue, 2026-09-22 at 05:43 -1000, Chris Li wrote:
> > > > > On Tue, Sep 22, 2026 at 5:20 AM Gregory Price <gourry@gourry.net>
> > > > > wrote:
> > > > > >
> > > > > > On Tue, Sep 22, 2026 at 03:32:44AM -1000, Chris Li wrote:
> > > > > > > > Right now it has 64GB of memory.
> > > > > > >
> > > > > > > That is exactly my point. You are running 1/8 = 12.5% system ram.
> > > > > > >
> > > > > >
> > > > > > Chris you are missing the point
> > > > > >
> > > > > > Zswap:           8812236 kB
> > > > > > Zswapped:       24927876 kB
> > > > >
> > > > > I am well aware of the point. The 7%-10% data I provided is before
> > > > > compression. After compression, the real saving is about 1.5% - 2%.
> > > > >
> > > > Here I'm at 28% without any issues, with room for
> > > > more.
> > >
> > > 28% is one thing, 100% is a difference beast completely. If you
> > > haven't tried it, don't assume 100% will behave the same as 28%. There
> > > is a point where too much zswap makes the system unusable. It is hard
> > > to pinpoint the exact upper boundary. However, figuring out the upper
> > > bound larger than that exact boundary is not hard at all. I haven't
> > > seen any one can use 100% system RAM sized memory swap out to zswap.
> > > If you have a data point showing what that system with 100% swap to
> > > zswap looks like, please share it.
> > >
> >
> > Chiming in as more of a user perspective.
> >
> > On my 4 GiB BPI-F3, I can reach more than 10:1 compression ratio on
> > zswap during some parts when building GCC 17 snapshots. E.g:
> >
> > MemTotal:        3966864 kB
> > SwapCached:        31872 kB
> > SwapTotal:      16777212 kB
> > SwapFree:       16638128 kB
> > Zswap:            280140 kB
> > Zswapped:        2859840 kB
> > AnonPages:       2927376 kB
> > AnonHugePages:   1409024 kB
> >
> > While this is 72 % rather than the 100 % you asked for, I think this
> > shows that what size a potential limit on the uncompressed size of zswap
> > is suitable heavily depends on the workload.

Just for completeness, here is later during the second stage of the GCC
17 build:

MemTotal:        3966864 kB
SwapCached:       100488 kB
SwapTotal:      16777212 kB
SwapFree:       16500688 kB
Zswap:            371128 kB
Zswapped:        3995796 kB
AnonPages:       2792748 kB
AnonHugePages:   1026048 kB

And we are past 100 % of MemTotal.

> >
> > I have been using vswap consistently on all my machines since about
> > August, and I have also tried one or two versions of xswap (but the
> > current lack of writeback makes it inconvenient for me). I really
> > appreciate the work being put in to decouple zswap from needing a
> > physical swap device to work.
> >
> > > >
> > > > > You are not listening. The boundary was set due to feedback from the
> > > > > application SLO. Those are real deployments not imaginary usage.
> > > > > Please respect the user.
> > > > >
> > > > Different users need different things.
> > > >
> > > > The kernel needs to be able to accommodate all of them.
> > > >
> > > > The kernel default should accommodate the people who
> > > > are least capable of configuring their systems.
> > > >
> > > > Hyperscalers can set their own defaults across their
> > > > fleets. They know how to adjust settings.
> > >
> > > They can use a safe value, e.g., 100% of RAM. Let the people who know
> > > exactly what they want to swap configure the boundary they want.
> >
> > My personal preference would be for a default uncapped (or very high,
> > and I don't think 100 % of RAM is high) limit on the uncompressed data
> > which is backed by zswap, since that would mean one less knob to tune.
> >
> 
> Thanks for the data, and for the testing. Please let me know if you
> have any requests or encounter any problems :)

Thanks for the good work!

> 
> And yes, I completely agree with you. We're having a very backward
> conversation. The default should ALWAYS be less hassle for userspace.
> Ergo, as transparent as possible.
> 
> Exposing priority, sizing, etc. is *adding work* to userspace. That's
> the position that needs justification, not the other way around.

