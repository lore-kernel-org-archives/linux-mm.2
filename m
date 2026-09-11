Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1551C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 15:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B45E86B008A; Fri, 11 Sep 2026 11:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7486B008C; Fri, 11 Sep 2026 11:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97DE96B0096; Fri, 11 Sep 2026 11:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DC096B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 11:58:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C670314027F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:58:41 +0000 (UTC)
X-FDA: 85201939242.16.30908B7
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf23.hostedemail.com (Postfix) with ESMTP id DC02E140007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:58:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L oj+n/1";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nBokoZMl;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="L oj+n/1";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nBokoZMl;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789142319;
	b=l8MxLZAsEQVBK4cdozxUMV4wZrpR4UCb4AbRimkxW9Yr5LTTXys+tnlaewr/9EQbCCWxJW
	9YWA0ybrfDITZSmhZUSAAAcuPT71P24RamPu+E6v30+T1Cpy9agrvhNBUtJYlkMTom6HwL
	yClKfBCIj7RMU7/RE4kwWV+kTMlEGBU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789142319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsR0HR0pw4kDSImLViPVSWsm/iy2iIyQ6XZ5SwWZypI=;
	b=hlnyzBNoQK6JUNAmmiWK736o0k/es+pdDqJBh5Roa5S2wNueT/ZoMqKWp7oQDVKa0m4n6g
	Q3AVrGShR47s52AS4QD6jw+nS6xWVBw9xYdDEFB4ej+0yf3k+F8K4FeqDwtST/y3OFxK4+
	o3gy8t+ksdAVw0nwiCozhX+x1eE01I4=
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 625251400169;
	Fri, 11 Sep 2026 11:58:39 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Fri, 11 Sep 2026 11:58:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789142319; x=
	1789228719; bh=SsR0HR0pw4kDSImLViPVSWsm/iy2iIyQ6XZ5SwWZypI=; b=L
	oj+n/1IcBV5tie3ucxFuz0Mq0YWToLY/MVqGmLm6ii17ZQU/gNJ88//SSWBbdyfc
	r577ztUjMOqBrzBuH0zV3z9/hATRnI+dH45sYcTTSPbLp7HepzEz4C18cwTHpA/y
	/pfci+MFrAMYVSU2NiC5qnaZpZ5otGXHw9Mns/VdAAql6R5S+eWYs3RtQF+u1jp3
	wQyhYim/xT6Tgs82VgEanlUOvS3Ma7L6A27IC6bCEr/X7gqd5xnl6n12I24P08Bz
	3tNwMS/qWoL8LKo2b5BRnr24ExSvfXbYcy5pfyJJ+pbTCBO+SSv5ZOmgLpUpQuhx
	A4Cnb61DI8yH12esD4emw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789142319; x=1789228719; bh=SsR0HR0pw4kDSImLViPVSWsm/iy2iIyQ6XZ
	5SwWZypI=; b=nBokoZMlEzRdfFPUxlPf7Vqb9NkuBzeXPOfLgLznwLCQhdxYjg2
	dA1gRdcmPfx3DCljiRkvQ1TY/vmmhC74pxSIu0NnuW4XlMi1joiOgvhPZlZs9jOS
	3LiegcM63Yw2fjDCcQqi9L9zOu2v54aThpkzUef+G7lmp+aPokyPJdiylz+Bcc5P
	lPqq5BzmWwNZjyq+e+hk7yg+t7cB+XO0nNUsWlO7KWFNsP4jOdqeyWEXJtu2zZFZ
	3k4PBnJp5/hpXtwmiUfLJLTt5O1Dqh8B24xJZGHfUuqAoHOFSM88DoCygItT5BmQ
	KHoUJjoNMzl+bJiGaBPLv5UUNPjlAj1lFTg==
X-ME-Sender: <xms:LyWkaklElL8-UqaR_ApPPDHUFDdoTSYD2eSVyKN4on9NekW9X10zPg>
    <xme:LyWkauo6_9fulllf-atV_oFqQO_f22akuVvMuAQhSWY5Za0YjCSKL5-8ywnoH42oY
    JjKkxEvcqVAZZtXcgEetL0gdXA0VmUvvqhIlidDHumVQYuzF-_7YYzTSA>
X-ME-Received: <xmr:LyWkag4eelSPg12kYSnFjvj-lWwecMqtxvW_fxPBpvIkBbAG1jOKw04bozk>
X-ME-Proxy-Cause: dmFkZTFdhIIRaHoHvxR/i3qDB+Toan8xhX/BO4+LAXG6YR9Th32opelHKVqK5DPv2w5l2g
    mk7hR63FLrTi9H9OKaK3FiFYCj8H06se6Ibg178Z/kVc0sDSIeQHfNcAVGtagcp0fyGWsF
    2KZVKsddUect1FLwMOhtJQIBUA7GSldxWIBYXSmvpmeJ6hLC38qM8vk4TrNBAB4AGNTUas
    SDP5i7H1AkLaCnj/QE3E5gOS2I6JpFXPLLknYD/tT/JFvbDfCQBmeW0g178/yGlRvxQiyk
    gglF+PN2p3sWtGuVoTd1Kwhv5qSHxGsS1Bbqn+//ovzyjuutXkqlvJIzc84yAaW/XKBnRO
    pNd0f/HXf5ohF0TXEbleZGrqvr/hVH/Anh6pVivhVTVoK5u8TjqSI38QVOzH5zl5K9PCcU
    JMVM0UdLNUyLs19KnbqHDdYrM0XGHKIJxknY7xk3/UU5PGYr+jD6uKcK+S4c9ZmUP0/Iwa
    si4UoXGrCG07kirb46RsyitgqMIJspSCWViXGvzXDCldU0QLpWZP7aGSt5JmOGNufGfVMI
    QE3NBIinwblebkIrlnNlzizraov7Vxj5N10BpPXJ/L9zdYSH7qbTH6GBB3Tepd/rHOZq9b
    RT9+IsuPaQmDTv8q62Zb7BwajhOjixcd1TwzYVH8XetVQgJSr3y5dN9fGg7Q
X-ME-Proxy: <xmx:LyWkagIYz5HiGTNwJGREkKRD1yEIqzoAM7trsGL0k8BeKK2Oo-XzNA>
    <xmx:LyWkasmFJuag4G8hEs9fDAqmm2hA7buaLhbdY4wXdmRKyHI6l6NQpA>
    <xmx:LyWkan_Xw0j3uiadsf0_iByBlQKHzL722WsULuGVhM_tGGEKOXynZA>
    <xmx:LyWkaj73Z3fuvARAyA56H20_4UEC_VJxuW2XEKARQ7P4eGziMRSZKA>
    <xmx:LyWkaufG0P7HmwZ0YBjnA1JeIe1B4GjdcooRK8-BLoDm83ECZMNsgp_2>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 11 Sep 2026 11:58:38 -0400 (EDT)
Date: Fri, 11 Sep 2026 16:58:37 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH v2 00/12] mm/collapse: separate a collapse from its
 callers
Message-ID: <aqQlBzxvNVObNSxg@thinkstation>
References: <20260910120238.2529819-1-kirill@shutemov.name>
 <8170ef17-0de3-45dc-8c8c-de15f088214d@kernel.org>
 <aqQf9hSy0iNjnL6t@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqQf9hSy0iNjnL6t@thinkstation>
X-Rspam-User: 
X-Rspamd-Queue-Id: DC02E140007
X-Stat-Signature: 7f7hyashaw9oudm9k3xyoxynoazk3kzz
X-Rspamd-Server: rspam01
X-HE-Tag: 1789142319-814843
X-HE-Meta: U2FsdGVkX19m54GbAvGNdiPswBTvA3VDOE3vXWuKD72m1+32qiTcI0LFtKWrw2jJgEPknFOsfZUQnbyh0BNKPTsZqLXQz0KdgvXixQVxI6UrppFti72X8g+eoDcXVE/7L/pcEL1LpsrDs5MaWQMW4PSeIhrhWivE1/SY1brYTxgK0Vxn7HeKLRGzwe7NQVL1V2DUa9EjfbLzH49QjKQWCp02AHopLdKjGnKn22hJGsPYnNKpe7IRs7MrTdwJQiMysxastq/WePDlfVp/r7vTOLjIUxsVAhGamQrPRnGiJeGARsT3i/mDAj8d3fJHbYcaUWfEkWSCD2qoK64nMeDPeHP79Ce+IrBKgGcN1LWu/AmM7DXct6qDkPxJktOJZWqEVvtx0aw9E8etLPuNoiMttcfsCP1UogEx5NHvC52Wz2hcgsW/ky+eMkLX2nWoqINP34w02oqCfAr6eGwT7xelAYpGTozrfljIxQ8GMRirTu1aoX/6LM/uMOuXlcOVtNsgdZ6Gso4Tr++QlwzZOqTqvtRrk/SfqkN8CbUhoooEQ5bWe7ZDwAhGYsPbXdMFVBbWAYMBSkun8GTBBEXM2QRcJpscPVn1C9CEJpW/LkwDC/H1A4FfxbGMOvetp2/8F703vsn5UYc87qO8B0KuldBcaNACtZO/DH2DGuRRCDIxjLitwM+tDyxKAA0F0IWkklCbHTpD2xnCdBQiKyz9GC+1BK4QOUOoR8nGdxsyZX5atwU1YSMHB9K3X0i+BqoqewtYe24gZNd7LduFiHWdDl8HJ4Lyn0EfvRlxDFgmuUDt8KzdVchrDA2iCp3kUd+rG9g/fQxPLy/tOSnP5KpE4/KusZGakTP0O8/4AiWXfDLwV1bwO5BI8KHKBXv/3y2Ab143wAlAqC6vJMJFi1q3J1UEmeJwU2lxCDmyInwiF4LVNaj3hzGp7UIY8SdTQX+1NvHMnNvFdSkbNv4u1trnAtn
 EjxVsXrL
 XNJVx3usKc1IbxJscwoU21eCvK4etSIqHxckWJ3BFd+Gpgh4axv319MeDRHlgRIKALnxg1rdC7EnqvBWChBBmjH1OJbxa7QefjhXKvycuzIj3hsiu19+fslcp7WM0o0U8XsGTLRbI61oXz/t7yYn4DzilgznuIcHvUOE1rMsiFXwz5sSorYiaFl/L3JAIvcGc75f0Qww+C6GHZo94UBAz0zIrfTUym5LuJEsawBR369rLZqaNa7qAD2+xtn6zvqsFXlaoZ8rAIIRpA5mSOlm/T4AVgMZh8nlI9XT8gVcR0cpy3LV2OObj8K5LntvONzsjt2aS0jGTFUIgyjmAXg8fsRRjOicgH+sTc8jaQqmuUjdhjz6jvrvKBBjVwoZuNusQQW2G7PZZfGDQJ41OXbUvA6KeKJJF3aBuCvLsaBMRsaVbetIqrHw+ZBqW77Eb4LxsRzoDF8MXTE6N2tm3slq+oqAeCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 04:56:06PM +0100, Kiryl Shutsemau wrote:
> On Fri, Sep 11, 2026 at 05:06:58PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/10/26 14:02, Kiryl Shutsemau wrote:
> > > From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> > > 
> > > [ This is the first of the cleanups I said I would front-load ]
> > > 
> > > There is no line between the collapse engine and the callers that ask for
> > > a collapse.  khugepaged.c holds both, and they reach into each other.
> > > 
> > >  - Sixteen tests through the collapse path read cc->is_khugepaged to work
> > >    out what they are allowed to do, when every one of those decisions was
> > >    made by the caller before it asked.
> > > 
> > >  - collapse_single_pmd() does both halves of a collapse behind one call and
> > >    drops mmap_lock somewhere in the middle.  Which of its paths dropped it
> > >    is not something a caller can see, so it hands back a bool and the
> > >    caller keeps track.
> > > 
> > >  - MADV_COLLAPSE's implementation -- the walk over the user's range, the
> > >    per-PMD loop, the errno translation -- sits in khugepaged.c, which is
> > >    the daemon's file.
> > > 
> > > So: draw the line.  State what a caller allows in a policy, split the call
> > > in two with the lock as the boundary, and move the syscall to madvise.c.
> > > What the engine offers is then four calls, with the lock state written
> > > down against each, and a policy the caller fills for itself:
> > > 
> > >     collapse_control_init(cc)         once, before the first table
> > >     collapse_policy_*(&cc->policy)    what this caller allows
> > >     collapse_scan_pmd(vma, addr, ...) per table, under mmap_lock
> > >     collapse_run_pmd(mm, addr, cc)    when a scan found work, no mmap_lock
> > >     collapse_control_release(cc)      once, when done
> > > 
> > > The engine stays in khugepaged.c for now; what changes is that it has an
> > > interface, and that neither half has to ask about the other.  madvise.c
> > > gains the operation it should have had all along.
> > > 
> > > Changes since v1
> > > ================
> > > 
> > >   https://lore.kernel.org/all/cover.1788533997.git.kas@kernel.org/
> > > 
> > >  - Rebased onto mm-new with Vernon Yang's tracepoint fixes in it.  Patch 8
> > >    no longer merges the two calls to each scan tracepoint, since the base
> > >    already has one; its changelog now says what the status field reports.
> > > 
> > >  - Patch 3: nr_occupied_ptes is nr_eligible_ptes, and the mthp_collapse()
> > >    comment counts eligible PTEs too (Zi, Baolin).
> > > 
> > >  - Patch 4: no comments on the two constants (Baolin).
> > > 
> > >  - Patch 5: one line per policy field (Baolin).
> > > 
> > >  - Patch 8: the file side is split like the anonymous one (Zi).
> > >    collapse_scan_file() runs under mmap_lock in the scan and only judges;
> > >    collapse_file() runs in the run.  See Behaviour below.
> > > 
> > >  - Reviewed-by from Zi Yan and Baolin Wang on 1-4, 6 and 7.
> > > 
> > 
> > I'll hopefully get too look at this soon (after digging through older stuff in
> > my queue).
> > 
> > Skimming over some patches,  a note that we should not be undoing recent
> > cleanups without a very good reason.
> 
> I don't think we undo it.
> 
> Both madvise and khugepaged use the same interface to the collapse
> engine. Anon and file paths are handled internally in the engine. What
> changed is that we have two calls into the engine instead of one.
> 
> Collapse consists of two phases: finding what to collapse and collapsing
> the found range. These two phases have vastly different locking
> expectations.
> 
> The scan reads a PTE table under mmap_lock, fails often and doesn't drop
> the lock to move to next range.
> 
> The collapse allocates, may sleep in writeback and takes mmap_lock for
> write itself. So the lock inherited from scan is no good.
> 
> collapse_single_pmd() hid that boundary inside one call. It had to drop
> the lock somewhere in the middle, on some paths and not others, and the
> only way for the caller to find out was the lock_dropped bool.
> 
> With scan and run as separate calls each has one lock rule: scan is
> called locked and returns locked, run is called unlocked. There is
> nothing left to report, so the ugly lock_dropped goes away.
> 
> It is the same move as Nico's da98790891a4 ("require collapse_huge_page
> to enter/exit with the lock dropped"), one level up.

Forgot to mention, this kind of split by lock boundary makes it trivial
to switch scan to per-VMA locking.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

