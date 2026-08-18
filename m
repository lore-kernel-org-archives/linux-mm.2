Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24463C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 14:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C3126B018D; Tue, 18 Aug 2026 10:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C026B018F; Tue, 18 Aug 2026 10:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 264F06B0298; Tue, 18 Aug 2026 10:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 067A86B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:42:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93EAC402A3
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:42:06 +0000 (UTC)
X-FDA: 85114655052.23.13273CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CDDCC180011
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:42:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDQc3TbX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787064124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIgroO17cxW3StOu7FtwzJ0p4BsPX3URbvdP5tpra2A=;
	b=JW//GT+ytSYjQLGjryOUnNkZdc9yO0qGXBlch2xR+dr6xj9rqs6V1Sf5NXAAsx5ALjSA2/
	s3N1ZZq9jnRUXPxl32tb39uBOrG+PZ/blOSCJglI6OAAT8YaIXTHh63iGHj5Ojcr3/+yTD
	hc6k2N+cRv1l4KrTDEiZ5MWlLTDslgI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CDQc3TbX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787064124;
	b=Hu3k9Hp1myIHnvxxW7hoEv/ZTUnFFqvxkCo2aziAyhm0CTH9//bua8EvvleMUue737fc6z
	1w5eJ2i15xn6Bq2Gcoi+VM/ekWjDjQOF1PFFBZ40gi2SwO2yTwQ6GsQ1qbv8HlqWgSfhO2
	XnS8OINOotbZ3hPY64xQpnfiH/XhF7I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC22E40234;
	Tue, 18 Aug 2026 14:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2261F000E9;
	Tue, 18 Aug 2026 14:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787064123;
	bh=fIgroO17cxW3StOu7FtwzJ0p4BsPX3URbvdP5tpra2A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CDQc3TbXHMGHuOVnFhO/NrVr0MqkyFFMgQaU1KZKGPZQbiFQsjLNVGsur+cfMnnZO
	 UQPUWRzDS08US+P2dtx0QNBWWrenfUHoeJRTJTyWT+xDVcdAGiYgnODJzYbteqNI/1
	 LPdnZLcxdLysRPBDgdvowJ0y9rqygjW/gvqdAu64/kzb8UYZL9wzLY5hk0+SdEOfhB
	 J6s/JFVnqkhVvCOsSIb85qhuHJ/fUPElB2yxQ3YNC7EpiSHIEt4WOqosvz1N8aWpLm
	 qUIT+6t6QlJNDUnSwUmtIWnwtHjPiDoi7fk9PBqGmwtkC9fD//KBG8JCJDhpCu4PG8
	 vAgGurOJhSoHQ==
Date: Tue, 18 Aug 2026 15:41:40 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org, 
	nico.pache@linux.dev, baolin.wang@linux.alibaba.com, baohua@kernel.org, 
	dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, liam@infradead.org, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, shuah@kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, ziy@nvidia.com, 
	usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoRuqbgFAPyZtUli@lucifer>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <99138bda-55ba-4c58-9b79-b76e9daecdde@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99138bda-55ba-4c58-9b79-b76e9daecdde@kernel.org>
X-Rspamd-Queue-Id: CDDCC180011
X-Stat-Signature: 1pufzteua7kg5m5pk9u9dt3imzdgmjaw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787064124-976380
X-HE-Meta: U2FsdGVkX1+8hbBpJKuj2lW9gxgk3MTIAsxmSuTllzmz1/vGxoRvj7lWUEOXzKyajGRjkus4RMU5aTkpVPV3w/2tY/dTSfYnNq1dkpYz1fxs1p5I+Jug7nslCvjGEAiyJo6TXmkB7m5dMC+3hezsSxhiPcAMg1GnKR4d/wXhXAkAIywZfcN3yvoKdPx50lUex3aLTHhIXfumHrsEbRvTnjAAmEh7K1Bvr3EulrcK8RJaaXNEHBWEnBKTjOGdXsjA0g7mieK/abiaa6rLhDr7Ldd+SsvjOEokY3kDCeMbeARMNqmf+3+DKyA1R2lClAGD4X/0MK9nkaCjbzKlfw6m8pklm8BCElSauph+uLGSRsi4E8HNJ//622eB1dr/YSD0IE3iWKWnjOdXxMqvEuZyGjySttUzUestS+PhCBvZUCAxIzL/piKRh7LCmlfOREMMd+0b7GT7IqeIx6xiY8vfhpAaav685XAR1yQ6WTTYlfe0dbcEhu0HNVzHFvLMhTy/4+CVxmFqBgvdjB+Wc93aftG1i45k+CjvZul+3R5QKG2ZO2XWTjN03t3p2/+9qvU5lR3x3fWy5qVcMFs3TXNfWt2biBkNpyc5jSR5YS+Xmzfllk4nD2pgvCTZmh5cagIos0XQ9PxYrsRMzA22/V38x+f00Sp1oRfIaL5yQX9J6P3BXHPEQXgbO3BDl9iHKbrTaapWfzoRod5FVVj8EFt6zesj93UZEnebnhJh08ghV+VeZQTxJchN+cICxAaHP038Ugq9rxRr4Nxm5LpKdzN7sa6MgOKh6Upcfl88CrKQ5fqBeA9nrmBQmohoU6UJjLw6ekVINQxQJk75v1GhQo+FyJHvn29La2Q+LEWmzP11txemk6e4CzMAmwIj3vrZNA+NXxPRL8acEfRpKkErtZIeibvVCE6sOIfmC8hoSyQymaMSuNs3gLp3qgl0GQMBFPfbMJfVThC0qukY9KXKyb7
 cQWstcZ+
 68y0xwm5TSXihpuVrhIxtX3XvBYAs2j+6u4hkGKdYTNH2XUauGSsJBotEVcHmo1nLEU7o/BIGXWteXDa6JCCNmYJHOB2gDl5rkKC+0ddf4lcKS50buwLlZug372G1QU7n4Z6bDjoJOvgqYRv9mgpC6fTkhIB9QIWnU4ogH2lASe6nqvTwQtv+kYtGjF7ry22T8Sw1O76i3OxL/DYWeYtNE7c1/JMEZpZCLCU1GjFpC6G19s5cXOWeHeoD/Ms/Zv912CqZrel3jmRUaYHDBG9RT9y6KgNZtgmIH04XWcXLvAQQnM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 04:15:27PM +0200, David Hildenbrand (Arm) wrote:
> On 8/17/26 15:38, Kiryl Shutsemau wrote:
> > On Mon, Aug 17, 2026 at 09:52:13AM +0100, Lorenzo Stoakes (ARM) wrote:
> >> We have a THP cabal meeting every couple of weeks where it would have been
> >> useful for you to raise this first.
> >
> > Fair -- though my invite is on my old @linux.intel.com address.  Could
> > you forward it to kas@kernel.org?
> >
> >> In any case - this series is not something we'd consider at the moment,
> >> even broken into parts.
> >>
> >> David and I have put THP into feature freeze - until the codebase is
> >> subtantially improved we're not really interested in seeing significant
> >> development.
> >>
> >> The technical debt is substantial and has to be paid down first.
> >>
> >> See [0] for a rough list of TODOs in this regard.
> >
> > I read the TODO list and I'll pick from it -- though I notice the
> > technical debt section includes "Literally all of the code in
> > mm/huge_memory.c and mm/khugepaged.c", which I'd argue this series is a
> > fairly committed attempt at :)
> >
> > One clean up I wanted to do is consolidate code by functionality, not by
> > the THP/non-THP split.  Move all page fault handler code into mm/fault.c,
> > unmap code into mm/zap.c, fork's copying into mm/fork.c -- mirroring
> > kernel/fork.c, so the mm half of a subsystem sits under the same name.
> > Large folios are an integral part of mm nowadays and I don't think we
> > benefit from keeping THP in a separate file.  It is also an opportunity to
> > shift away from mm/memory.c being a kitchen sink.
> >
> > David and I talked about this at LSF/MM.
>
> Ah, I missed the context in my other reply. Lorenzo already had some patches at
> some point to split up mm/memory.c into better chunks that will also better help
> our subcomponent maintenance model.

Ah yeah I kinda lost those but indeed doing this is a good idea.

I should try to dig those out again or look again when I have a chance...

>
> I think the challenge is how to handle huge_memory.c, because ideally, we'd not
> have these stupid callbacks into huge_memory.c once we make PMDs just a
> first-class citizen.

Yes and another point and I think it's one that Kiryl also gets at is - can we
_please_ stop pretending huge folios == THP == what the page cache does == page
special cases like DAX? :)

I think Matthew had ideas (TM) about separating out CONFIG_THP from that stuff
but that's another way in which we can unwend some of the horrors.

>
> This is, unfortunately, also something that needs more thought, because we don't
> want to end up moving stuff back and forth.

Yeah annoyingly it's not all straightforward. I wonder if actually gauging off
of what series often touch in patches might be a good way of figuring out how to
separate, funnily enough (certainly for mm-next conflict resolution purposes
anyway).

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

