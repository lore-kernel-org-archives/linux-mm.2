Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E709C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462186B00A1; Thu, 24 Sep 2026 09:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413796B00A2; Thu, 24 Sep 2026 09:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 328F16B00A4; Thu, 24 Sep 2026 09:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA9A6B00A1
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:15:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 79D7FC035A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:15:33 +0000 (UTC)
X-FDA: 85248702546.14.E01C13E
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42468100006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:15:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Q/MlswJ3";
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RtV4STCFxzd8n2asolNk7YsXcAewSFwDk+o1y7oOLs=;
	b=eT51W8CCSlJpBpmnHAcNi0L5PY8GFY1EFcwVd0GX3pauhdsT9Cm7YtQ7PZCgEGv8kKCrlD
	+wJkc8GiQmH4kSRpyvwfA82uyxUSfsGaNwB4NjLFcURZFUibihFMdlXTeLZnMTA0Xyn0JS
	gWZRjkfNUqtoay3P4StDcUum3CeV3aU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255731;
	b=NBb64a+jW0Ap6dR1Gb/snM/VHtNFHBniFvF8aXeaEUBHczbuWtkAF6IUm5oe0idsPfzgZ5
	zohqTdEVMLIJIQCCj2Aa2+2mf8Si2MWpFsWxLgVCL07tzxhiyMyMoV8f1WlOsn3tQvW1GF
	buvCNWucR+jk4VwkGuzvjoXe9oF4JVE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Q/MlswJ3";
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VAqY47MliHFwSb5df7rFV+UkhNv2LqwPUXS4WaUskXI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790255729; v=1; x=1790860529;
 b=Q/MlswJ3E6lYNWfz6+0G+LQQKNGmbkg5FUehv60tWlpTYbOYWDIwchm6Yk4J9WVp/YAg3HuS
 0fe20OgOBNCZOSuyK3sRZmDfWduxSuMICexS9RzuUcBZ+91TRQR+dsC7LAA6vB5nQeh5ICd9ggo
 DdUH8zOXr2l3JGrbDNMHTNCM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 15fed9b4dac8ae4f;
	Thu, 24 Sep 2026 13:15:21 +0000
X-Mizu-Trace-ID: 15fed9b4dac8ae4f
X-Migadu-Flow: FLOW_OUT
Date: Thu, 24 Sep 2026 06:15:07 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Rik van Riel <riel@surriel.com>, 
	Baoquan He <baoquan.he@linux.dev>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Kunwu Chan <kunwu.chan@linux.dev>, Meta kernel team <kernel-team@meta.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <20260924125040.GA25882@shakeel.butt@linux.dev>
References: <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com>
 <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
 <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
 <f3ca71f1c561f28a341de0e5a1b3f24bd4da3201.camel@surriel.com>
 <CACePvbX5Oy98DygLZjC=Z03Lqb0nk50_OEKQCT9svbQOOwwDew@mail.gmail.com>
 <CAKEwX=Mv+tnL8K4rfPuof6mKaLQp=tqR_qjtKrtY0-5L85FLfw@mail.gmail.com>
 <CACePvbUF2QQMh_GiCNQn-RTmZNkkLWkmaHSYzdQwv2fupjNQiw@mail.gmail.com>
 <arP8vXdJAL6ZJ1Os@linux.dev>
 <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbV8zprLuiWMdYAOLRy=TwRx9WjSahCWySf53o0d_myJ8A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42468100006
X-Stat-Signature: d3cnpb9f68xh5533nf61mkqnzts8cift
X-HE-Tag: 1790255731-126687
X-HE-Meta: U2FsdGVkX1+r90ELGPtMckPNSWNjPjMEzfWyOPq/DDfS9yzptWjAZfJ1QV419Z27tvZpHoT9VdCb6rXXwZoRx6X0P8twhIp2VLAWqjq6aw3Jz5ALi1q8wf9F1tg8ukaPQuQTpiGlLmVVg+vrWCfSQ1B0fBay12nF7q6NmQ/2g7mGpxeznAIhbaQ5pSBnkhAXvfHo15bYDrnoGvQ4+7RSTOwclc9x/kqWVVYn0Q9SRg7DBNhCQVfUXeob60r0Al6jmXVJykwCbHIuz1eWYTjPv2j+wwpmBqxlxmDZkoW0qTLua1uoIUAbtXsVQzp8DTb5HDJLH9T4OF9GPm+eYzRxerUxsNbyp+XTVyf7Gl29aGBLAqVScKB5W42Y5PeQdnK2MurtxukTkxV++ZCy/uOrGNmCo3nvxTgtPSwo+RvETcxzcTj5GQ/8ob6GAwH40Skyi4hV2WyifzjFVbuTNlesDhkb2p7OTChcHDxQJYkbi2cT8EEbZwXvnJ9Dl3/Xrv0Srhy//8MQFWuG02GvrNk4WUJuN2lAAxxui3Tl8tTuGKhXdoyErmdekCGduwLNL69KHD+aIf+ij3K+fNPNwMXk6p18d1V8MUETCIfE3v66+5NEe9VoKIx2IqI+t7toXpphj8A01wka8KrQwkc92UDjnbNZp6x4DiYpZDyhNOoO8lQjR4WI9cEYyUA7ENvuwcPERuPykv33mUYvfxaWRadJSbto+N6/GawE8qk9FLh8Bs5xjmIfvq+Gvo6cozXal46dilkn5DwpcV/i6gXzpDL1W7jbjJ9dQ7xotFhP4F7iIULq5UadNY+9UBEKH6LyeP/NemWfofjM1fNqUN0l6KqdounqRLqUB5puXx3YyidA1ADJt7NKEpm2CGtYpNRBiDNKf7wN5gTyYhrgMumSA6YlCT7cWRk3KaYoPQswAflFnnKdk7XHZVsWYI6OMfBHhMHLDCdCzjavv8nzcu41a2Q
 91+GmcRm
 n4aKm9RqISnk4GmHpakxIIXQgYhYyKDxAx6iG0r3GI/381Od4R47DIxh2NW7QtfMffD2EANkj6L8OopG3FD04kojVfnv6LGg/GKrUsUY0kht1RlQ8K4pIrEnjYWcjxZvZNRodpvt/ab6vqyJG+mm9SM6NZthiDlcs3ibiEyqlRSYhRlsWh/LeWh6CrxuvP45e7uwQeyCIrp5bcfbswQxE/hHxzeuqU4GevOj+wEvczZhI5rVeo96CCcaYxYvy7fo0m/FlxW+MAmtE/1SxAVWwHRPJy7gZuT8Vg+zYb61dNa5UJBcH8kw7ApilWyFbEIAK8lvsFruVFsfuoDnd/o4/nanavuusJ2lN6DXm4VDz9BRpYUqYsX4zQjmQK9Wj5fbehCmTXQCTpmZe718bVHknTw0F9RSqlA/8ERmK+ivAupcAMCHEgTCWc1DkcjTIJMdRTK/vuTm2s+29fTZdVPjifu+wPXpRjz/xGQPmY4JHNrS0ck49hsyOjgDiM+b5a8IohAMz80LSOOfIsbCvLeILbfYxBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 01:27:41AM -1000, Chris Li wrote:
> On Wed, Sep 23, 2026 at 6:30 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> 
> > > BTW, I already shared that changing swap counter charging will break
> > > our and others' existing deployments.
> >
> > What do you mean here by "break our deployment"? We are talking about
> > memory.swap usage and limits here. Google is still on v1 and using memsw
> > usage and limit and I don't see how vswap is breaking memsw?
> 
> Your information is no longer accurate. I got this from our internal
> AI: "While Google's internal production fleet has historically relied
> on cgroup v1, there is an active migration to cgroup v2 to align with
> the upstream Linux community. Meanwhile, in Google Cloud (especially
> Google Kubernetes Engine - GKE), cgroup v2 is already widely deployed
> and is the default for newer node pools."

So, using AI to provide more vague statements. Let me help in providing
more clear statements:

1. Google shared borg is still on v1.
2. Google cloud (GCE) is still on v1.
3. GKE running on VMs is on v2.

Another very vague statement is "active migration". This migration plan
has been active since 2018 [1].

[1] https://lpc.events/event/2/contributions/204/attachments/143/378/LPC2018-cgroup-v2.pdf

> 
> About the V1 to V2 migration, it uses the memory.current and
> memory.swap.* counter to simulate the memsw counter for providing the
> metrics singal.

What does metrics signal mean here? From [2] it seems like there is
intention to propose addition of memsw to v2 and from my last
conversation with Sweet Tea, he was interested in exploring BPF to
provide memsw semantics.

[2] https://lore.kernel.org/all/7a5619a6d27119fcf566e43563a72396@dorminy.me/

> 
> > Are you making these false claims just to derail the conversation?
> 
> You should apologize for your accusation.

I am actually more convinced that you just want to derail the
conversation by providing AI generated vague statements. However I
accept that there are parts in Google like GKE which are on v2. The good
thing is that vswap is opt-in, so GKE can just not use it.


