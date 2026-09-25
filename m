Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7656C9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 20:20:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 848B56B0088; Fri, 25 Sep 2026 16:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8056B008A; Fri, 25 Sep 2026 16:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BFCE6B008C; Fri, 25 Sep 2026 16:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31FF36B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 16:20:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB8D71A0714
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:20:40 +0000 (UTC)
X-FDA: 85253402640.27.EA38D89
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf05.hostedemail.com (Postfix) with ESMTP id 95EF4100007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:20:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W89Hyv6S;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.235 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790367638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHCr0O6x1oEoTdeKSMNckh0NZBgonxokbaxnCBlTws4=;
	b=0YAgv84mLOuGFkkum1nU2xFFJTfX0SXg4q0jPsHD/7lMnDDDZ/MJ8Otp9AMtmwAP+xPywt
	jFVAtojPOLEnUTRtvaISccgxSJMnOQ6C/AQ5zS1hJOlHyRgKI1G/8XB8M8/ZKNY/93KlNC
	O/nm3KWHFCWfvfTyw8aqkADoJ+6xBcY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=W89Hyv6S;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.235 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790367638;
	b=CUdA0rJnlbrbXpJRbYWxOz1KG5ylad6XQ2L9vWnFYkH8mRoytA7/2iS9jjMzwGGLJW4G4d
	tCpS6eZK9UwU6RKmEc/NIl5rXPUVHvmy2D31XMWAFK7oK9I9Jrsa/JUcejj0WLh7j9Et7L
	qGo7smEb4smtVz59iaZbRWLYbl9EmgA=
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93a2dea320fso129204985a.2
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 13:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790367637; x=1790972437; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jHCr0O6x1oEoTdeKSMNckh0NZBgonxokbaxnCBlTws4=;
        b=W89Hyv6S8q6BQRFL2VTbViEtcHwAI5jsSgu15dMnavvObnrlb/JiOumHgrMLZulVL1
         kEKgJ7GfSjcFiksplOVmg7wf+iGF0tgMKeFpT+Ex+alCHpd0vm69xCyz7uoXJUPs/6+X
         8F0E5ctXeKG4MIAPjyl4Ur2wXchT6dFDZJAKHbtW5Y0OwbtPjy6ljdllBShmWVa9w6tb
         OrZIw9L5W8qz3PijK5yIDNt2237AvER8KZNU1J8RBILnA3tX9OyTIMU+fdAWxqCtZ+Gs
         +kFA99nsleCwGUNsHK2rShWninFpztI97WMcTjOnv6de8L+ypCH470+xrFAoHHvH0IcI
         7kAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790367637; x=1790972437;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jHCr0O6x1oEoTdeKSMNckh0NZBgonxokbaxnCBlTws4=;
        b=27vJjsQROzReLdACzsG5DX2lAfdWceJInB4XMWRqziBxrG+4+RRFuSUSuU0Sf6ewO2
         n28yryfIp/OgfL8/ptGFGlEFcLDo7jSR6iGhicme7MBh5YcY14UpFJxWTsmqOXuT/oyA
         3qM8sQ2LVGAl+7/cbi2zk5psabBJJ++soLiI0wG6eXnOMEN1oXCagl/tkC+LdZnwrkv/
         OtnE7y+Ip9H/8wN2YhS5ZcotEH9WtXbkB32l8xy68O4ulIXDZd0pnr3GLC6hsKe2ApbQ
         /sSIKVaeC1mCqx7X0Z137jpLlH0pPyM0OIdT676Qv2aV0JcYNmvYT4H7rZrb0BlURDA7
         AMIA==
X-Forwarded-Encrypted: i=1; AKwUvBz3SjxgtkuPm5YVphoQN/j8bBTGPRsjV3WtTvVZgG/Gx3VpMLi220NLsU5Ni7E35WJiZEfK75ScpQ==@kvack.org
X-Gm-Message-State: AFuF++laUETlGml91iCvlkbmRMA6KTAi+rDJV+6ACQNxXQYW0EhbsZU3
	7WqPvxNe/VDYnnLRGjex9SdvPz+XR0+4TaRWz7B93M8/mpxcGwxqebs8c6GgnntlBEI=
X-Gm-Gg: AYBFou02w1roBImSd0ojNF1O8iF2j6geqzVbhkJEprb5+dpuOlReF7EObjlLW0Ssld3
	kVVYvKM7yt9QCp510f9NicEm07NmsOHmAugBaBuc6eurKVSMuLAzekEVP8ua0n0NSUeZDRw4Hm6
	xBQVsN6SrGb85hHaolqQqmNPNrhNVUFQcbXN2mfhok9phGh720e2yVvZhPVK0GxxpBdY9ZEgmaz
	6OvuxEIbAtu4rmPBqTwTbayhqI2BmE3jEhF1sE/wMuKDBy9k/OXlJCWA9dZnZhh1ovpQ3eRkIVK
	1J89vduYOOTRyIqZpdqxuclIol/Dy7l4fnjqgvqjJ9ieIyCmIE6GI6KXFndHGfJfttPMJA0z+m9
	5MDp/Dc99cXCVLhm3l1y1Yk4/103sof1MxDGWYIQcQQzePjOZ/n0rTlFH2Qva2A7Rc7kvKc80gj
	lj8G9uwKKSuLTrzDscKEVuByjYm/kLnRns6/x4No+EEeXyjVvlSX/JB2dkKNZycBpIBSf+
X-Received: by 2002:a05:620a:40ce:b0:939:a9d4:7022 with SMTP id af79cd13be357-93c43b5acadmr649894985a.8.1790367637558;
        Fri, 25 Sep 2026 13:20:37 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c448b06c9sm260456585a.11.2026.09.25.13.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 13:20:36 -0700 (PDT)
Date: Fri, 25 Sep 2026 16:20:32 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Barry Song <baohua@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Gregory Price <gourry@gourry.net>,
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
Message-ID: <arbXkEQ1cwOVMqEy@cmpxchg.org>
References: <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arUcil9kxUPiymXI@KASONG-MC4>
 <araWKyJ5MENBwXCL@cmpxchg.org>
 <arbHLt-iB4RHXyWt@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arbHLt-iB4RHXyWt@KASONG-MC4>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95EF4100007
X-Stat-Signature: pm1eoxpp6ethpto5hzuqs8a61aecpowm
X-HE-Tag: 1790367638-638769
X-HE-Meta: U2FsdGVkX18lZWI5lQ0m7kei5tXO6OQFy31Nns860XDKjrDBt2ZCV4h0AmFYjK5LMuaG0pbfw+Dv8x8JRmu0FK3DTZmcD2ceNnZXOun49MPmWZWfnV20nGjgxOvuJA0hiQllcY3g9zCvZ8NGXq+0iSoCLoKvhMEuzpZ4fuMssxC0X9d0SBVbXEIYbUziIlttO9MXJn8E2X0S/iG8n3sckqna+ORMT9jNVT5Rx18+Psp5JRsqHVCVVseW3jHExwvqg85c03F7lU+0+sgxwld2psOu94bcb0yxZj5xzR8E1w5YopSyn/hnGLv/6I5I6yNno7+32oOYi5IYtG8RgND/aWApF6uOs1VOwjw1LpVb/ll+8xbw7cErlU18BXOuiqizGIUwBaMlqn94DgPgZNEtwUxPSq2Zk6FIXL3R/yhpLwLshwX4DPoHo34E7IMoFep881rLomH+soHTQjAQRskiRCkg7z1AQaTanMcMVgPC7bvvom/OB3NsxUxfx6NMKfd+xQ9rF68AWz0555Ag94bixWNibO2u/Ols6jBXj3x4LEvkoR5KWpALkz6z3gi2nNazfk3yKfw2PTi2BueXxcLzMtxHu1uK6URVONEnp/ndF40gxnySTM71MUm4eFRBWmeTfJLnHDR9ifLs+NFnLYPWvrsTRlSYsaHCV803kXvMpJkIgXqE0qC6Wi1WFu20faifREMIkk1NWcMdvveUmA2Az4TJyqirkNSieuJzigokPHpjZUXLkgLtyL05lqZnDuhOs6JBC7t227/nltuVjLWI9g4NHdHS+J/SaDY/FfkDAJHgJDqZyZoNhIrKQQ0KlAMbk8DWTP2VGC3GhhXxl3H6NWuFY6+WKh3jHPDxZvKMxNhK39ZR78VwJyF4p/+KSmKljRpLxo7B+339MkvsEq4oEpf9te49oynGQe6EkGz+OR/gEjYjPlpR7k0KlczU5o+/nSEFPnxBNG7vY0lCJv8
 F/jhN/Ww
 isyG8H2Zz5J8c7zvckFFh5jffi7DaRRaehrlo3DGLXVzhkFJaLEjrp1aU38dTZGfPBhLtk4gnq8uRDzkfa4tAppIPCkbp5lT8rQaS15tj5dtnEQdvU5FiXAxLEJ7IvXNemyC2yuR7R3u5tksooNeOeq3QbnWN/7FF/lnZvawZdiNr4ZNDxvsD8fCBpvpJ0lmfqnh2hrf24IH8H0RUKLrkSgskM3tf/J70dmAOHCmYPfs1NbstUT/sEnlpRUQt9WgNfU4aA5KZCAvrV7pohaDLRx+85sKabSRTd6I0+KYpDnaA6GrMEK+mYnfgqXAmfOzk0hkyZILAUUvKw32oJckV7wj5C1owI5jHBxq7Hf16w2XykX3Iew0+R8RrSgRHmD1HYDH+8FTORyYSjjrYYPbymr7hoauLHSOTDsa6nZWjZMw8AVBtNA29yGonz6UuTqBgThQa1ITcRyhvrcJkIqdz3MViSTpSxlF8akIdL5t+2NCY4eImihrXAhPvH5Kw2TYV8VkHXD1HtOoeMH/tYsbR6rCrPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 03:21:30AM +0800, Kairui Song wrote:
> On Fri, Sep 25, 2026 at 11:41:31AM +0800, Johannes Weiner wrote:
> > 
> > Thanks for your thoughtful email, Kairui.
> 
> Hello Johannes,
> 
> > > I also want to separate two things that I think got bundled together
> > > here: not requiring a physical slot behind a compressed entry, and not
> > > charging the raw size to the swap counter. The first one is great, yeah,
> > > and it's exactly the part we want, it's what makes compression usable
> > > without provisioning disk. The second one is a policy change, maybe it's
> > > not needed for the first stage, charging a cgroup for the
> > > memories it has offloaded doesn't require any slot to exist behind them.
> > > If someone wants to run memory compression with no disk at all,
> > > memory.swap.max defaults to max, so that still works fine, right?
> > 
> > I think what we found out over the course of this discussion is that
> > people have been using memory.swap.max in two ways. Regardless of what
> > we do, we will "break" one side.
> > 
> > (1) The usecase you're describing. Use memory.swap.max, combined with
> > memory.max, to set a "total", predictable footprint of in-use
> > application address space. You can mmap whatever you want, but the
> > number of unique pages you can touch is limited to this sum. And you
> > can control residency vs non-residency through the invididual values
> > of those settings. If compressed entries are not included, this
> > usecase will break.
> 
> Right, thanks for the reply! residency vs non-residency is one of
> the issues here. It's also about how we consider these two kind of
> resources to balance the scheduling of containers.

Ack.

> > (2) The use case we have. Use memory.swap.max to divide a finite space
> > in storage. We only have so much space on disk, and we need to manage
> > fair access. Note that this isn't about speed. We have a mix of
> > containers where some use writeback and others do not. The ones who
> 
> Same for us, the usage is mixed.
> 
> > write back to the swapfile need to be able to get their fair share -
> > not more, not less. Including something that doesn't actually consume
> 
> Is that writeback compression rate based? I mean for zswap, you have to
> writeback uncompressable part, and then also do cold writeback through
> shrinker. The compressable part is hard to predict and control though?

It is compression rate based. And yes, the exact composition of what's
in zswap and what gets written back isn't very predictable.

We don't really care at the cgroup level, though. The goal at that
layer is isolation: a container gets a slice of memory and disk swap,
and the most important thing is that it stays within those confines
and doesn't become a noisy neighbor to the others.

We do care about workload health, too, but that sits one layer above
it. For example, we monitor memory pressure. If a workload expands
hard into (z)swap and starts thrashing, we kill it. But if it just has
a very large set of cold data that gets pushed into (z)swap without
any thrashing, we don't really care. Let it run. Maximizing
utilization in this case is more important than predictable capacity.

There is one exception, but it's narrow: when we run out of disk swap,
things can become very unstable. Especially when the workload is
mostly anon, and there is only a small share of file cache to absorb
pressure. So we kill when N% of disk swap is used.

But that's only for the cliff. If zswap didn't use disk slots, there
wouldn't be such a cliff. As long as you're within memory.max, put all
you want into zswap. We only kill if you start thrashing.

Neither of these need additional kernel interfaces. Just psi and swap
usage metrics that get polled every few seconds.

I think you could easily extend this mechanism to "predictable
capacity" by monitoring anon + shmem + a "vswap" counter and issue
kills when they go above some threshold you consider unreasonable.

It doesn't sound to me that you actually need synchronous,
cgroup-style enforcement for this? If a workload goes over, you kill
it within a few seconds.

