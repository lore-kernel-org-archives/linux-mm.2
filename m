Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E1E6C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FCC6B00A0; Mon, 24 Aug 2026 10:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9309C6B00A1; Mon, 24 Aug 2026 10:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86DF96B00A2; Mon, 24 Aug 2026 10:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 669D36B00A0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:22:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08E89120161
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:22:13 +0000 (UTC)
X-FDA: 85136377746.03.05E1912
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51A20140010
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:22:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KaO+iZO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787581331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5j5DWKJN3cdhmHqdN8rCpFWNLqVKoHQJspSwWStoi7I=;
	b=O769qy7536qjArK0m99LGGn/VL0n5FYQ3z8juXSgBkLA0W98PA082poKCcLTiC8bmfycku
	TBvmcIHUhobtTdPXnjn2/p/My7cvfj+fV28TUR4bRHye7vJ4CjP9t99zsOz5jQB8vSfoR9
	elf6MQDTgYuH1LakgckFHP6yhtirrb0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KaO+iZO2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787581331;
	b=zDG0l0/OqI56GuDWqKvxlNtzchK8CFZl+WkF/mid9ltuZ7CFMlq/p1/8zI0uDqQXWW5qLY
	hvO6OGz8bLUf0gxFiC9wUnIIw9I0F1WJLjpt33VBvRQHYTH7UsqeePLvn3IkqRqfJ/l+5w
	UA3Ob9sq/Knd6wqtd+Vhh0XRBN7fIkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73A6C41140;
	Mon, 24 Aug 2026 14:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142241F00A3A;
	Mon, 24 Aug 2026 14:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787581330;
	bh=5j5DWKJN3cdhmHqdN8rCpFWNLqVKoHQJspSwWStoi7I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KaO+iZO2NSk2Mb6Znp4wkLjU5Psq+sSLTkfTwe0+7WB9WPQgyt6fGHjYZV/zU3Ij4
	 jlJwIh1FB4tUanbeYBsel3kuT6oDpApt/nGc2A/jpsx8No/76t7v8SkSIGmFPCQZHq
	 x/stZ2CCZMEYIwBH2TMkf2I6Kb6U4Vb0qQpg+buiH2VOWmHgTwuJ7fLAW4vrSs/qqT
	 FFfr9sG3A9qW1t2+BBLBIHX/wpRTS0+mcevOWj9fdts3KEZ9zaJXvQwRkTw4iabRz2
	 MRD5fdodUOKKmoRUSt4jl6yvfX60M8VPs27KzmhOBhTfVgKE8xrxwTcZCVAJ/MhsjO
	 FxmiBGAPOYNOw==
Date: Mon, 24 Aug 2026 15:22:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	akpm@linux-foundation.org, nico.pache@linux.dev, baolin.wang@linux.alibaba.com, 
	baohua@kernel.org, dev.jain@arm.com, hughd@google.com, lance.yang@linux.dev, 
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, 
	shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, jannh@google.com, 
	willy@infradead.org, pfalcato@suse.de, rostedt@goodmis.org, mhiramat@kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 00/57] mm/collapse: rebuild collapse on migration
 primitives
Message-ID: <aoxRs0mjyQnpO-IT@gremlin>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <aoLAly-oL2OAa4n8@lucifer>
 <aoLkMUtmzRVuv2Hx@thinkstation>
 <aoQ77EcD3M2kjeya@lucifer>
 <0153303d-f9d6-45ea-a276-fbf2e5625ef9@kernel.org>
 <aoXn1B7cPnPq7uxd@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoXn1B7cPnPq7uxd@thinkstation>
X-Rspam-User: 
X-Stat-Signature: gdxm9pc67eosnxmh47fwm6gnsmkp8sd9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 51A20140010
X-HE-Tag: 1787581331-965195
X-HE-Meta: U2FsdGVkX19G77pBQ1G9mO9VAG9Se9ctsEfQBls4tnWdw6E50UUMND4ie27/vV7ts+N2z0hftBh/XS+NTkV6hQhz78ykSH0EKFGR+Jkhcseb4gst5J/ryK/4Bogwune4+GNpArLzsv2SLnhPh21joeWWT6q/JK8ivwo9KbOHGlPwU8czzYuc2wFDtMKUmMo7p+ka1bNhy8esi0+c0emLpLymLbFQOcx07Na6Qg2EGJReV8zU3dMHCVjyv/E8lv14DUg6hajZ9C1Swscrl/zy4/HwH+RJ7IXb9wzGOnNaH+lX1RyeNUSocMQmHNkV3MYDSBRPMLG0rQ8K2QpOlfSoyiUthCGpWZoAxmNeqn8NSNvshKha6HoKxJ5IsPhKUiNSF4YAIbC0o2A/MlDJdf4XCF4/V3P8h7n1v5DmC3HCfRd7BQKTIdazdM4xLnqtRLMRUhEjDXreaGTXDB0gQXRWx/5lcXiGj/RMPFUS5+QR/UHrvzeDToiK5SRiZNvr2G8dwH5hGLDuZNWljS00Rmsg8N+NJWWApWmlmVlyCNN+HaoOEKn2WBN/YlOPKZXpIvxNP1i02s27HDjftrmueHTKNkvXzKuxPdGBp/Eeubez6A617Nw6ivyP4kU1XoaFk6bbOzkdST+viDXT3fCm8XG9q0DKP+MTH5WjnBneh7910ZE2HsvMot56SQ34TxDv4/fxV8/ZRBAnA+Adg1rxPbREJobfiliZb5nWZpqiOlKgnR9xDisTJULGx8s3HropB6361VPIWvmmDsg3ODTxMFhfdZ8oqQyldaZCOxifhL3czXaGavazuhQTAt1a6i3i6IRnuXmUa/BNFJzX1c2Y+gRmpwUpFNkK7PXZMhadWHLum7qMeuL/m2x+r7AreM/P0g72r/NNqWUHN0un5v3rATNeK6+UYST6ApVRx1zc6+q2/5cfUC6t2CrconM3C3UlYfEEbj4epUtXSYNG0RzgS/D
 kKmXBlLL
 qh+Ps/vOCEY7RU1ZzNHBYWjNowRnl0eNxkdeLPpsBnDvoeoXvXZtzXi3N8tCa9ag1Fh9qGprKVsG5ifsR4F10TiSJunZbJ1anl+GhNMcCT+qDXQvyhtt/4msVHg4p8pPqV4TC8f7PqxU8OrevKvyatMEjPnv0QvcUY7mXM/rOlDJGzDFjFqnp+MLtWOx8COp1IJESyxq7kd/RqFlLUNYMAL1VcvaSF2NOv4qBqyyunm+K7N95k/PowvT0hhrqBWH+GvRl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 07:08:07PM +0100, Kiryl Shutsemau wrote:
> On Tue, Aug 18, 2026 at 04:12:17PM +0200, David Hildenbrand (Arm) wrote:
> > I think we all agree that there is a lot of room for improvement, but the big
> > question is:
> >
> > (a) When does it stop being a cleanup and is a new feature in disguise that
> >     makes the code more complicated and even harder to maintain.
> >
> > (b) Can it just naturally be made looking like a cleanup.
> >
> > Ideally, we'd get b), in small, nice-to-review chunks that incrementally improve
> > the code without inflating it heavily or moving everything around.
>
> It is not a cleanup and I would rather not sell it as one.  It replaces a
> mechanism, so judged as (b) it fails by construction.
>
> I believe the end result is much cleaner. But I might be biased. :)
>
> > The current locking is nasty, so anything that moves us one step closer into
> > something that is not only simpler but also more scalable is nice. I am a bit
> > concerned with the churn in the series as is.
> >
> > After this series, mm/collapse.c itself is way larger than just mm/khugepaged.c
> > originally, which raises some eyebrows.
>
> Line count is a poor proxy for simplicity or scalability.  What the
> engine changes is the serialization model, and that is the part collapse
> needs changed: the PMD granularity and the exclusion both come out of
> the locking.
>
> Incremental does not reach it, though.  The old mechanism is correct
> because it holds mmap_write_lock, the anon_vma write lock and a reference
> from the LRU; the engine is correct because the sources are frozen behind
> migration entries.  There is no halfway state that is correct under both,
> so the switch lands as one patch.
>
> What can be incremental is everything around it: the engine goes in beside
> the old mechanism, patch 25 points the anon path at it, and 28 removes what
> it replaces.  Until 28 both are in the tree with only one of them
> reachable, so the switch can be reverted on its own.
>
> > We should also be aware that people are proposing file/shmem mTHP collapse, so
> > ideally what we refactor would naturally unify some of these code paths.
> >
> > I am wondering whether shmem mTHP collapse should come first. (I'm hoping that
> > shmem mTHP collapse can unify some of the anon+file collapse code in a nice way,
> > to similarly just look like a cleanup while enabling a new scenario.
>
> mTHP collapse as it stands has limited usability: PMD-aligned windows only,
> and one VMA has to own the PMD.  Bolting file collapse onto the same
> structure adds to the debt instead of paying it down.
>
> It would fit the new design.  The frame -- scan, candidate selection, the
> round and its passes -- has nothing anon-specific in it; what is
> anon-specific sits in the freeze (folio_test_anon(), PageAnonExclusive())
> and the unshare in the fault-in pass.  A file source would bring its own
> check, freeze, copy and install.
>
> I am not sure it should, though.
>
> Do we want to find file collapse candidates by walking the virtual
> address space at all?
>
> collapse_file() already works on the mapping -- it builds the folio in
> the page cache and then repairs every mapping through
> retract_page_tables() -- so the VMA walk only picks which inode range to
> try, and it reaches only what a registered mm maps right now.  Large
> folios buy more than TLB reach: fewer page cache entries, cheaper
> writeback, natural locking batch, etc.  Those apply whether the file is
> mapped or not, and going at the inode directly would reach them.
>
> > Agreed, I think we really should unify+cleanup the existing code first before
> > doing more drastic changes.
> >
> > Having a series that throws all of khugepaged.c into a mixer and pours something
> > new into collapse.c is ... concerning :)
>
> The moving around is patches 29-35 and the tracing after them.  None of it
> is needed for the engine: 1-28 add it, switch the anon path over and delete
> the old mechanism, without moving anything else out of khugepaged.c.  If
> the churn is the problem, v2 can stop there and the moves can come later as
> their own series.

This whole reply seems AI-generated...

You replying only to David twice in this sub-thread which isn't exactly giving
me warm fuzzy feelings about the working-around-me concerns I raised here.

So simple feedback - send a relatively small, no-functional-change series that
improves THP code and lays foundations for future changes. After the merge
window.

Can you explicitly ack this please?

>
> --
>   Kiryl Shutsemau / Kirill A. Shutemov

--
Cheers, Lorenzo

