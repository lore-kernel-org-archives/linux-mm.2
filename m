Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D33EEC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB80D6B0088; Tue, 15 Sep 2026 02:45:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A90346B008C; Tue, 15 Sep 2026 02:45:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6B56B0092; Tue, 15 Sep 2026 02:45:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 68FEF6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:45:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6DB21602F1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:45:07 +0000 (UTC)
X-FDA: 85215059454.24.F0ABACD
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id F030DC0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:45:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/Xdn2g2";
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789454705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3gMa11Ohebq27YUAMt/eZ6bodDfNY5HH+fv02iKxiE=;
	b=O/Tb2UGaaxS6qPKg9FLYAospu2cZ/5FtuxmM0xO08o15zcdpuSwusqlJh+EPrhUj9vYF6L
	DgP51Miv+/4wnL7rKPX3Ftm4NjUTryBMN5YkoqutwiMyDsIcer+lnjQfcWSj0bFJfF5ftp
	mEBlNcbtWme8ZxZCJdAr+i5RwBIfh2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789454705;
	b=AC7O/mChv/nXhkpr5WB7DNUure0oOlrlfXkoSLYXUmWGsTXStnGJS1ji8VF0t7Cj5cciPS
	GT/xuOLiHQl1lTAsA1IZekdKjlP1YHq/D9mR1pvMqohb7NKGbgZocegKuSGsaGj4TJr/S1
	nDRyCJDzc/oTYHDidcxLgbLws+bS6OE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/Xdn2g2";
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VMJgWKEeLbEF+5uGy7m1N0gpmXanMrHiGWE7G/bgYUw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789454702; v=1; x=1790059502;
 b=T/Xdn2g2FUWeWKEVMnmA2X9N+5Wj8X5145Ho2+/kn5q16FacMLgJhDnHlupzglpeCZ2/Nbyh
 l1VmCndUDhsK7G8/j9WWJ+9oKzLzgCiDa1OtT8YTSmfje9hclk42/RU8I00bhSHQYn2bZkct+9b
 jb/PfoeO6b+O679kV6gEOe1U=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 79b6f2ba6867b9a0;
	Tue, 15 Sep 2026 06:45:00 +0000
X-Mizu-Trace-ID: 79b6f2ba6867b9a0
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 14:44:48 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
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
	Kairui Song <ryncsn@gmail.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <aqjpYHbZ14A8xRtK@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
 <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev>
 <aqjcFb6MFNiA6n4V@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqjcFb6MFNiA6n4V@fedora>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1ruacraaqbz73mqts95thhcuud55edj1
X-Rspamd-Queue-Id: F030DC0008
X-HE-Tag: 1789454703-340131
X-HE-Meta: U2FsdGVkX1/QzAxt/fsrigKNgZz6mY3zCSg8m+ebMj1SwutyrlanwGQ9Vmgz3iueSIBKhqHJQbSosjKOKLBDZGK+FsbVZgxLvs9RGgG5CF1LzxLk5MahdkR8FUbHwNQhZetGPWBQmM5dMQO4juQsc/YEl1vZ7QK9fFYnObvcojlTZ0cpNQ3h64I1N+Ev1NppFfEv5FvgMbSpSr3S7zoNWlt2TrQXM5t73bmii7iUGWJoyXboiKTYpka5AnjschsmR1r7Azh83myXR6B71OF66AQR0RhtgMQpF3OHksXhcNX4um++PPDukKfwnVLbLxSM7nvGqECvt29VH3ybV+7+upM6LLM9q5E5hmTZVGNex23TQalcEdRqKF3UqEeRAwyyRAYm95MHC1MO1qO+WBeSP3XvDbCYbe4tOGto3IhQVtexKRu7vhuca+JCN0fR+o0nMgJ36jdKC1Uq5+TURUgRQ00Yc9ByL8AfyrDlVloIE180IAAmTYh0STiBTjaDuL6wrtC17GFUqWQYHvr125mdsp9c7Xmwb8e5YRztj3BeUbmGwwi0JxZGWU2yAa5hCEQtM3ftp+vzH5qkDXib7g1zmiceoA4wbOrgm7CZek9jmtwSMpfz0sHh1nsvpxyLfvKLQ3Sw5Pr8+u8+6wDpNuJwJGXH1+YrA6b8yjqkmghgiHcEg/aMj4NMTuQpZrbDw6RqX3JnoiSWHN3xGTGGjLMc3/l9b3AkHODPYG/EPAh9wlrKcAkun6hnd9QmbveMzGHzgqGJynjyQqC4Hhe1raltno5YcZ55Ix+ZnGSMwMQ/jw74tkbLOHC6Hhm3jjk0eyVobbjoBfwp+j7IXPlyj6MuaEscQZqjQxJsQVijRSjZOiZXMGP3DQFnRbnaetRyh5ienNu61FmR78qB5TaFQNz2lZGquPBRRgaw+yIXXNLdOBwZpz/OFV108mT3AwibzwUzw0LoClOQveIOJRJIrUp
 UC1J4ifa
 9tKTfavh9WGV022pAwfzPlaKBTxy2QIQxq1gZ/DB6MV+9sriusWQa2H65rkfmV5dwX3vO3xRdBoZkpaPQfLrPaJs0IB4CwbG9khKJcNxTOy+Mo88RjkHzFwcEH/S2E0KFAt/8hmQ7a9GVWN0oRdmV1J5I3qSHqFoeZbfo28hsUQk7uoDWrkbKOepTO3zH4++2rMvmE9QnetWtUTOTXhBhLu9jih8ptpiOYp4FyMa4XiMX+NyDDCvH7tSXtWp7DzuCVuGzss4/ULjEu1xDJW63hH/7lSSI1GughSRAhx5bf+6h3KclZVD+Xdky2cjPFOxrUN+2lwdTOaPZaksuxZHrqYrMJnWQY5H21bNQVta+PkakNCMT75krUaznnwLWJ761tDSzBG2ccrZ7JCc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/15/26 at 01:48pm, Baoquan He wrote:
> On 09/11/26 at 09:45am, Shakeel Butt wrote:
> > On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > > Hi Nhat,
> > > > > 
> > > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > > .....snip...
> > > > 
> > > > [...]
> > > > 
> > > > > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > > > > rest of swap already uses:
> > > > > 
> > > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > > 
> > > > > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > > > > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > > > > cluster layer stay as simple as it already is, which is precisely the
> > > > > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > > > > on.
> > > > > 
> > > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > > > > within ~2-3% of each other, effectively identical. 
> > > > 
> > > > So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> > > > we are discussing implementation details before deciding the design and
> > > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> > > > need for dynamic growth. Why we want dynamic growth upfront or can it be added
> > > > later? Once we decide that then it will be very easy to pick an implementation
> > > > that would take us there.
> > > 
> > > Hi Shakeel,
> > > 
> > > Thank you for joining the discussion and for taking the time to comment.
> > 
> > Hi Baoquan,
> > 
> > I am mainly trying to facilitate the discussion but your use of LLM is causing
> > more confusion. LLM use is fine but please at least re-read before sending that
> > the sentences flow and makes sense.
> 
> Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
> myself. I wrote most of them by myself. While at it ath the moment, my
> logic could be unclear.
> 
> As said, how swap_cluster_info[] is built is the foundation. Whatever
> you do, you have to make swap_cluster_info[] ready, then you can do
> writeback, rmap lookup, thp support, etc, on top of it.
> swap_cluster_info[] is the basement, then you continue building 2nd
> floor, 3rd floor, till a high building is done with things added. Nobody
> wants to claim he just need the high building, while no basement.
> 
> Now, the foundation has been built with the lazy vmalloc, it can grow on
> demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
> a basic array semantics. And since we our target is to support a very
> large swap device with an extendable logical space, grow on demand and
> shrink becomes important. Now it is there.

By the way, with my understanding, only grow is enough for xswap. You
can reserve a huge space for it, while in fact you could only really use
it within a small space. Then it's fine, grow the swap_cluster_info[] to
the place it ever used, and it mostly will be used again. E.g on a small
system with 10G RAM, we set si->max as 2x10=20G. In fact it could only
reach 2G swap space. That's fine. 2G is the place we need, keep it. The
left 18G is untouched and surely no swap_cluster_info[] built for it.
Anyway, Nhat strongly suggested shrink is necessary. I am wondering if
there's really use case.

> 
> That's my understanding, not sure if there's anything I can't get so
> that writeback need be made first.
> 
> [I type each of above by hand.]
> > 
> > > 
> > > Agreed on requirement first - but this one was already decided, and not by me. In
> > > the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
> > > be added later":
> > > 
> > >     "Except for my virtual swap design, which does support dynamic growth AND
> > >      shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
> > >      requires userspace operation to trigger swapfile growth), why do we need this
> > >      at all? Might as well create a new swapfile with swapon?"
> > > 
> > > To me what it converged on was "dynamic growth and shrink, no writeback yet".
> > 
> > I am not getting how out of context above paragraph shows the conclusion about
> > dynamic growth/shrink and *no writeback*.
> > 
> > > So automatic growth *and* shrink is the requirement, and the simpler alternative
> > > was already on the table.
> > > 
> > > And I keep mentioning it in the cover-letter of each version of my posting. I
> > > only did the foundtation via lazy vmalloc. And Nhat will do the core
> > > part including writabck, rmap lookup, memcg accounting, zero page fill,
> > > etc.
> > 
> > I don't see any evidense of this decision. Actually this whole email thread
> > shows that there is no such decision.
> > 
> > > 
> > > What is still genuinely open, and I would like us to settle, is how large the
> > > device's address space should be, because the metadata scales with it:
> > 
> > With dynamic growth/shrink, is this really a blocker?
> > 
> > Anyways, I will let Nhat and others discuss the technical details (unless I am
> > asked for it). My main reason to join the conversation is to converge the
> > discussion to a decision and resolution.

