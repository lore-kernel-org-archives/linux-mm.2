Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFF0DC88E59
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26286B0096; Fri, 11 Sep 2026 12:46:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D67C6B0098; Fri, 11 Sep 2026 12:46:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C51D6B0099; Fri, 11 Sep 2026 12:46:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60B646B0096
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:46:04 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B156F14029A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:46:03 +0000 (UTC)
X-FDA: 85202058606.21.F08EDED
Received: from mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4CFA8180002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:45:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ipDHnnk0;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nH9yz8sYb6ilBEnZkuGYCZ7btVu1Ulx8yeloY3t9XPU=;
	b=VMQ7kap9ahFrfvlE/AUBC+2tOf3tuJP5/uETfhcU4lZwwFOFF0QBqe6rZDymdkmKSC0j/p
	xtiOxBNNoTb9Si2nx3whwotPsw1Xn/4EVxDjYJozRLZP7cBVge02Nxk0snlGJ5Ui7sv53D
	E4Ph8Woclu0dgRHDFt8qIWzhKnolxJw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ipDHnnk0;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145161;
	b=Tp12Fi7Ako9I90P3JsvLIJlZTUiuZ261lBaWBKkbagQ/3Wz9s12iEoN5cm+aqn55+Z+cXB
	u7WnKEESLPeH+vZHhSiFrZEHItd9a+ZRqo2gKcYg3qxESBahxBTj4V0JCSZb1E9wQvK5uY
	cIHiXMafA8JnOylqfA+c+DClSA2P9GQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iVjHC+6s8+AGQU6RRqV42Jq80JuEkr3tyj+AhFd+fe8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789145154; v=1; x=1789749954;
 b=ipDHnnk0VRcBMvNduGCJFtepe3w0LLG7UlPAnox8ngTrZ9q3T/Jx/ZAHhc91zmP5+amXtTqE
 MSKCAEGVXd/NiDt2TGf7VdtUGdg8+2r6OeKhE8eL/1l73NeYvyENpGlEm0UyC8GhkHuvZUIx5dg
 owyA2XgfG8+8zFdx89iEDbVo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6c76367668246014;
	Fri, 11 Sep 2026 16:45:54 +0000
X-Mizu-Trace-ID: 6c76367668246014
X-Migadu-Flow: FLOW_OUT
Date: Fri, 11 Sep 2026 09:45:52 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
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
Message-ID: <aqQrPLPXHXiuKup0@linux.dev>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
 <aqP81aqNbwAbs2P0@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqP81aqNbwAbs2P0@fedora>
X-Rspam-User: 
X-Stat-Signature: xdx6hhzomfkgn4ae3exax9zdfpakghuy
X-Rspamd-Queue-Id: 4CFA8180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789145159-506902
X-HE-Meta: U2FsdGVkX18FcNKJTX/hxQ/r6vv5ZxU/jRrD0sP0I28Q8qD7eqrxbLk/WRduGEcOpVubW7gnwxlj2ZHy4vCqLQj0bdIzRsMDZfJafY/FFmm+QrQfrkI4sSn+BpP1hB+3UgLdUjxXr9zA2qa7zgBK+49KogCIt8zG/662lkOggPDzhZajjHyvtfuGGinCbowJakSW3CkvSWY4PL3sXn4M47YfhvB+uoNtf82SJm1NDS1ruMEqEFN3dBvIJgjXCKjnrcy48/OxVTln77KVAF6RMZm0wIYEkB48lL5Y64n5Dk/f+56T8MFIQeIRf+TPkepUmWANk2SJpKAdDw8nFJenidVb+fC+23McIhHX60J2bMQ8sQ2LNjZgUDfwS+4zoq3f8NoNzyGf1TM7gCWT2jXzGPrsEad+Tone9S9Hfd0f68T6hTkN152e+0VPiLLMKUipMeuj3gd+JAPjaEXQnS9GMLFjc2Tzf8flA4DAC4oiA5kyYroeNg8fi5uB+FFKt/a+8Ab3DUn786Dr+n64hUDb02t9Vc7LuqVf9XDmEJs6ksxUhDwqPlmOuwn+LBAQy5olYvvzmtMycnO3G9d14ETNCgrkRLnvVb3rqlTSR2Yxq/5ZGipHfr5GTzfClBrMcwcw1c7aw1ffzt9tMtL/ttC0A6Hm5LhPD2jVwH8oFdfqe9hDQ4EvRgInf2zHMIdVQ6jjEc6nesmYb77uBAZ4IxnKcRkBdy83bqTj+dfr350xkBQINucHM5DyeNlGGugK/83pQLL4vXYQbVAftIGoybagspEMYbrdbr88FRnhI+4Wxhk74LzWryMH/M3U8J/8H5xRYNteNO/qL8PqG9Wj+e78Rdkdnfnc8VDQ8OeNrAuUBXbwGFfZQdxUvK13lgDU8Fm2AtXKweqRJsGiEt8RY93OnvEKqxCw08D7FoRovnsgsj2RN5mZqZmWDPY7WGYGR87RCvAWDXC4JeG7JaEGnFb
 Ml6I0aI8
 fqHKFwZhkCx5DCOpiLiHHkF5INzerKZxxnrfSWLAB+pvgdivt1x6cIGfPhKMzycGG92PLjUwphHApAzuGkyHpO8nOc9XRh8gndf9DrcFErAd3BnRk4miVqLoN+R4fwTA2Pl1Z7geS5LR7AQJK2OiqzZHawhk/syHCWC93nIAKl8IauZgOjdZ3mIIRvUA1wS1GGIig8QseZpRIWNaInb7tmGGyQCNDk85TRp5HIUZLJvX9/91mDLYO5tER1nAsUI3lih+9OUSi6rmmnNzrYNWMZin1IuTSR2hXuu7c4ioWHSCNQcUiPaQkRmVn5FL+tyY9CgsUeMSvkiiT2gppG4+Bvxip6zmX3H6T62xi2GroW94t1SBjdMVLgSrAsfwaQzLb9kCtNgRXkw3DCS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > Hi Nhat,
> > > 
> > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > .....snip...
> > 
> > [...]
> > 
> > > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > > rest of swap already uses:
> > > 
> > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > 
> > > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > > cluster layer stay as simple as it already is, which is precisely the
> > > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > > on.
> > > 
> > > I'm not going to claim xswap wins on throughput. I measured it:
> > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > > within ~2-3% of each other, effectively identical. 
> > 
> > So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> > we are discussing implementation details before deciding the design and
> > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> > need for dynamic growth. Why we want dynamic growth upfront or can it be added
> > later? Once we decide that then it will be very easy to pick an implementation
> > that would take us there.
> 
> Hi Shakeel,
> 
> Thank you for joining the discussion and for taking the time to comment.

Hi Baoquan,

I am mainly trying to facilitate the discussion but your use of LLM is causing
more confusion. LLM use is fine but please at least re-read before sending that
the sentences flow and makes sense.

> 
> Agreed on requirement first - but this one was already decided, and not by me. In
> the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
> be added later":
> 
>     "Except for my virtual swap design, which does support dynamic growth AND
>      shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
>      requires userspace operation to trigger swapfile growth), why do we need this
>      at all? Might as well create a new swapfile with swapon?"
> 
> To me what it converged on was "dynamic growth and shrink, no writeback yet".

I am not getting how out of context above paragraph shows the conclusion about
dynamic growth/shrink and *no writeback*.

> So automatic growth *and* shrink is the requirement, and the simpler alternative
> was already on the table.
> 
> And I keep mentioning it in the cover-letter of each version of my posting. I
> only did the foundtation via lazy vmalloc. And Nhat will do the core
> part including writabck, rmap lookup, memcg accounting, zero page fill,
> etc.

I don't see any evidense of this decision. Actually this whole email thread
shows that there is no such decision.

> 
> What is still genuinely open, and I would like us to settle, is how large the
> device's address space should be, because the metadata scales with it:

With dynamic growth/shrink, is this really a blocker?

Anyways, I will let Nhat and others discuss the technical details (unless I am
asked for it). My main reason to join the conversation is to converge the
discussion to a decision and resolution.

