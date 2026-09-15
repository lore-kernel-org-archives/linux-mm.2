Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01C9DC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 05:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9896B0092; Tue, 15 Sep 2026 01:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83186B0093; Tue, 15 Sep 2026 01:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A3F6B0095; Tue, 15 Sep 2026 01:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 917AE6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:48:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ACCCE802D6
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:48:15 +0000 (UTC)
X-FDA: 85214916150.15.9A3F00A
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6D577140002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 05:48:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0N2JM8j;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789451293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Km8B53KS1RZ0Ko11USDusqf4soeZDfw/DQQ88YPqFw=;
	b=tcqLYPyp8lb6jWzsS+i3+kHmiRS9VzpfqktsHBxs/9rt0kki2GqNlZlar0I/ii/y7YsKzq
	/rJknvMymySauoN+P+BzzMOMcuLtIKIazMQdr3KeCWGdepOOt//wUoMvQtyvC5phkiH5mS
	yvb4dmcCSfaOOhKbcJvoVkxoNrGtbLI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789451293;
	b=S18NUdxZM4Sd79uL0oINfl9DdWA3HtV884JqNOIPnEqB9Zznaf7BK3cpIRgw+wnB67jC5T
	HJE/l21iR7pqLdiAiIbv2q3EDyoG+RWKltHI0F4ILWsFCnDZUbD7VXvldfizkfuoHvZW4+
	AupeI3jce8T32Rhu3WwXR0J/hFVGOk4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P0N2JM8j;
	spf=pass (imf26.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1SMCEB2g0ru+dqQbzOuDzgyYF3rYputEIdw/bgUlvZg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789451292; v=1; x=1790056092;
 b=P0N2JM8jBAMAw6rEN9c03+yVfqQ0gHCf9zJCW4aiHnxNmCBMZkivhfBHad5/qSSnJgaYU5EO
 Pf6qio/eXiBcPLnZUuBtSf91txLIS28C+SKkOePm5xfspolIkq0vY8RXmF6fVxVBAOVTD7Qhz82
 iLnRyJjETaAs+CYesPH4trHs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 789024df115dfd94;
	Tue, 15 Sep 2026 05:48:11 +0000
X-Mizu-Trace-ID: 789024df115dfd94
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 13:48:05 +0800
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
Message-ID: <aqjcFb6MFNiA6n4V@fedora>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLZ5TVDAqEbIeMN@linux.dev>
 <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQrPLPXHXiuKup0@linux.dev>
X-Stat-Signature: 6nnyrrrgbs7pdp16h8ambxqddnxm51s7
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D577140002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789451293-185517
X-HE-Meta: U2FsdGVkX181e4z/eDUsaXvR675vZjI/VxdpUGXQ5DCFd8ggNykSjH1MbuiHxr7CN9LJ+HwA5EMdUIWkQCjeRyk46DfozhYwvb6Q/tSgbu50/ZUOuNQyB7uSqJLBhI4g2hyc06txurJCLxkNwX7JMqkJPXTmLqCKnvI679v+lgJhYwoJuFdBqCT/sSXZ54/HbnBxC/8Ugq9ZhepiQb7fOpG7oShBO6VsLkXZROn3FeQ84B0vt63kUKWdRt5VJMjZWh/E55Ef31KBIiLKHsYUp95aDZXZSTflbq9UwH1aP4rIcPvqsPszOMwdG/CfHn/3Upj9tN7FIAZC+eInIMO7uOzXNLRRn78wYXrtDB0ePjaBEETJNk0Y1TElAVYxO8CZQjutZzBZifddRr8IG+0E15ACsi9uCKK7A/TuQZGlRNiUTDar/x8luccw+5w4fU5WNyqNkWuTSrnCmoqlleA1RaOfs+YWZ2a2xy/xgrKe8NL9aN4tzBf5Xgr8/YxhR+ayMHAl+/p4jr6DPBwQ+ILttyYkn1vKYMF9wDm+uClVS+32+esPU0D4ZvI6f8NXxtFG/75P0s4pOsXYqaXFTDc2WIr9SysUuX94fCqkRR16IbHeYM8OosuoiaaZbj7aLLoWb2YL9WFC6it19GJKNiJwDQ+/kqeA2AEbJB0V9Cx65D+5A7lEXCmq8+o7qWGO+t+3g4rOJkqXC/2URqh/KImme+Bss0DNZfUTpwjhYBLNy3xofAyTdwDVWT/9vA+o/KlvAf+8vyFk3+vh4FbyD+Yp94wg40Lh4eftiFPDa5fYLe/QzxI7/Fy6hZITpOVcN9jMbvHpAKuWGFvodaTFNpZRL6yBBh/mdMLT96sRyIjoEpEt2dNW921TRPEm97sfHSEXVYfNiVU0f3E9Hsi3/FQxFdv8dCMpNjf4E6sq2q9rGQ8+EBZYg81RzDiTsmDPm4fJ2gApisbDDIIEEHEccGc
 0OgyGpP+
 Nh1AqRMs3I+LUoXlahlMBFoDlV+O/b6Au8dlQfxrf4lRlxxyDJ3BhL/SVdeNMTKB7yvr6yBgQfLiWCBk5pgS1Ps3K5bv6kNx0RRk65PQ+Dd/zUlVavmWibORAx1YUsbEoGx+Fx2JENS437xD4MRv+Qc3DEnK2bHPGaBLfmoGAeYfvMJh6eo85s33B1I1u63Iq+KVCrovN3ObNHfY/PV81vR965L9g8VpzHi4yZdhC4whiCse+hsGLr8UUhHfxIuxlb9iXRY/3CFvAl6vrmTcfe1qsI8sbuCF2xloJpqJZ6XLPeubl5zG1nbTn3HXKmI1Zpd7IifpdfnTlYLS282OfavlHqIGofL2Oa5B7gbQA/+3lSIP+v4AGIGx7mKXuR06xdXwJOyhvzB+pWbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/11/26 at 09:45am, Shakeel Butt wrote:
> On Fri, Sep 11, 2026 at 09:06:29PM +0800, Baoquan He wrote:
> > On 09/10/26 at 09:39am, Shakeel Butt wrote:
> > > On Thu, Sep 10, 2026 at 03:09:59PM +0800, Baoquan He wrote:
> > > > Hi Nhat,
> > > > 
> > > > On 09/04/26 at 02:14pm, Nhat Pham wrote:
> > > > .....snip...
> > > 
> > > [...]
> > > 
> > > > With VM_SPARSE, xswap's cluster access is exactly the plain-array line the
> > > > rest of swap already uses:
> > > > 
> > > >     return &si->cluster_info[offset / SWAPFILE_CLUSTER];
> > > > 
> > > > no branch, no RCU discipline, no tear-down state machine, and no NULL
> > > > return. So VM_SPARSE doesn't add complexity to close a gap; it lets the
> > > > cluster layer stay as simple as it already is, which is precisely the
> > > > part later work (writeback, rmap lookup, memcg charging, THP) has to sit
> > > > on.
> > > > 
> > > > I'm not going to claim xswap wins on throughput. I measured it:
> > > > on a 64G/64-thread swapout, xswap, vswap and plain swap+zswap are all
> > > > within ~2-3% of each other, effectively identical. 
> > > 
> > > So the claim is VM_SPARSE is simpler than xarray based approach. I feel like
> > > we are discussing implementation details before deciding the design and
> > > architecture. So, instead of VM_SPARSE vs xarray, let's discuss and decide the
> > > need for dynamic growth. Why we want dynamic growth upfront or can it be added
> > > later? Once we decide that then it will be very easy to pick an implementation
> > > that would take us there.
> > 
> > Hi Shakeel,
> > 
> > Thank you for joining the discussion and for taking the time to comment.
> 
> Hi Baoquan,
> 
> I am mainly trying to facilitate the discussion but your use of LLM is causing
> more confusion. LLM use is fine but please at least re-read before sending that
> the sentences flow and makes sense.

Sorry, my bad. I used LLM to find Nhat's words. But I did check it by
myself. I wrote most of them by myself. While at it ath the moment, my
logic could be unclear.

As said, how swap_cluster_info[] is built is the foundation. Whatever
you do, you have to make swap_cluster_info[] ready, then you can do
writeback, rmap lookup, thp support, etc, on top of it.
swap_cluster_info[] is the basement, then you continue building 2nd
floor, 3rd floor, till a high building is done with things added. Nobody
wants to claim he just need the high building, while no basement.

Now, the foundation has been built with the lazy vmalloc, it can grow on
demand. It keeps swap_cluster_info accessing as swap_cluster_info[],
a basic array semantics. And since we our target is to support a very
large swap device with an extendable logical space, grow on demand and
shrink becomes important. Now it is there.

That's my understanding, not sure if there's anything I can't get so
that writeback need be made first.

[I type each of above by hand.]
> 
> > 
> > Agreed on requirement first - but this one was already decided, and not by me. In
> > the July ghost swapfile thread Nhat rejected exactly the shape of "grow only, can
> > be added later":
> > 
> >     "Except for my virtual swap design, which does support dynamic growth AND
> >      shrinking of capacity on demand ;) If it cannot grow (and furthermore, if it
> >      requires userspace operation to trigger swapfile growth), why do we need this
> >      at all? Might as well create a new swapfile with swapon?"
> > 
> > To me what it converged on was "dynamic growth and shrink, no writeback yet".
> 
> I am not getting how out of context above paragraph shows the conclusion about
> dynamic growth/shrink and *no writeback*.
> 
> > So automatic growth *and* shrink is the requirement, and the simpler alternative
> > was already on the table.
> > 
> > And I keep mentioning it in the cover-letter of each version of my posting. I
> > only did the foundtation via lazy vmalloc. And Nhat will do the core
> > part including writabck, rmap lookup, memcg accounting, zero page fill,
> > etc.
> 
> I don't see any evidense of this decision. Actually this whole email thread
> shows that there is no such decision.
> 
> > 
> > What is still genuinely open, and I would like us to settle, is how large the
> > device's address space should be, because the metadata scales with it:
> 
> With dynamic growth/shrink, is this really a blocker?
> 
> Anyways, I will let Nhat and others discuss the technical details (unless I am
> asked for it). My main reason to join the conversation is to converge the
> discussion to a decision and resolution.

