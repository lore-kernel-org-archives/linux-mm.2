Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8129C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE07A6B00DD; Wed, 15 Jul 2026 09:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB85F6B00E1; Wed, 15 Jul 2026 09:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACE756B00E2; Wed, 15 Jul 2026 09:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8659C6B00DD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:47:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C67054011E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:21:59 +0000 (UTC)
X-FDA: 84990771558.13.F11F03F
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id AA55540003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:21:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3Q4haA0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784114518;
	b=BgJg4dFkordjjtOMF1agpJ2GneZoCkvLh6XcyP9uVpTDrrKS/MtgSRGcc+UxS83YAT0gBV
	a21o+rIpYBIPv06ITLRXyW6YL25e3d7CVBF3SiSxYR2OoFPUi3kpFEvCZKzmzynN0yCQRU
	8kykdirGuKAKy+5meReB1hl3spNvoow=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r3Q4haA0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784114518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vuZDUV79ZgTnqtJKP5GUBOq9cZrf3SO80INLa2FcDD0=;
	b=QXuGWzexibjhHjNyqc5+Al2tvjvZDjBivZuWne1R5ATsaZrvkd0yEbYnjfb9bVhyn1z+b1
	XGTeo4qsxJYWwqt69iyJGn0IfRDS9xXcqe8AR69heCyMWvl3vRJ4APlJgNU7q3Wkxyh+dt
	oburyVOjlffbOT8V/UhS2pQ131MOYBs=
Date: Wed, 15 Jul 2026 19:21:47 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784114515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vuZDUV79ZgTnqtJKP5GUBOq9cZrf3SO80INLa2FcDD0=;
	b=r3Q4haA0HFuVl2emqUbDWIJ8/hC/gXaScj3Bw8OCGRSI5k2pNKOJw6thAY1RNIzWkgQ7ay
	NUnBoZLvcJFVnTEqo0qR63zh5GvdwBZh4gCnbIi92JUuI785/LSEQ1soPPuy0kDFN9I9eF
	7ZADhA4EA4fWjw50DaDKkryssDljCnE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
Message-ID: <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
 <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
 <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AA55540003
X-Rspam-User: 
X-Stat-Signature: mqpyypknymraf3kamkeze5apww3dz9qy
X-Rspamd-Server: rspam03
X-HE-Tag: 1784114517-947974
X-HE-Meta: U2FsdGVkX1+bOrqrFSEuJC9nd1uNCQgHtoHL8pItJESLBBX9C4SDSdLi4VGQ97d7OuAqwlmcCuRlpy1BhA1Tb7XYPg7YWODBH5hnuYtGq2KfxlHIDhNdr+2C2zjLnsVBySgx7l0smXQT/ditG49EIwvS2+bOPsB4mIqz5KDI2gEXu2yRajOuF+SdKsPLBoVb6sbw2FPHB5Nfw1KlFCk5RiT/M7Da1hRSNbywxAoTtSIOCr2UMFTUZNqNIyPALdXjD3a66OBGx3+AUPctgFrpfTCtj0n+hyPQYBuJ1p6sgJYromzMxLBhj5UcvMgDhuw8PhhAEtuAaxmZdwGAHyPRO4p1SAIfeai9W3s0p94Xo94l8ZOcMJgMuLrPtPv/r7QUlbCqfmD2ltH/zBTTQx7Q2X9k1XnFDhl9PhVdPhfPLpaoIVb8jenjj7R0dou06Gdni5rRFVNcOeV3zi94+DW8DfDfLm8CQSG9fdt2+nSm5jbI1O8Ku7WUkQH79x8V40/dgNhx0WZEpeym5c8GeTr8cXQyyKMBoMhdZOWMRNCeya9Q5mVo80Fn5U1kqeG1Hg3NOS7DHrufqKFE2rrS/FRNJUfVXm69Aky2DedsthqAiJVSXoOoKzmBXcsfn1LsKWvrxX7BrFzNyOxc3Gs6BTVfpdt4WUPQMXyXdYf9t401BHWdth/5Re19UrzuDrs3W7s0VGekOaATK5a2vAgirafayNgP3yIQjOjvCV+6CN61lFZPIDX+Scb0WChL7fXT7Ik/gP480zNgnImZDH5FG0JU6USWz2apXMZ4PohhJHAw6XgpZHoMWRl1ZNlS7WmL+1s5NFpCqtqq7FPmyLBq/sM40d0puISU6Aacu6MsdUHmMtj4zIZbg5mineyPfnOQ4mMzyuMXR65DBJ8K57PR7aazaLhHpUweCvrBDqEL5ZJj4yWJkdUAy0ylmYwyZ7hD2xW5XshRq9IMFZhqoB0lyYQ
 z7xMipRc
 V985aWd/zY4M7XqLSZNOim9HLnzctgyQeFGJlPxvYkibQ/fJ4SmN6lJ3+7uFHeHs3H989rrmtnsiaMiQsTWm2Zz4MH+uuV0P0WoMERbysqOq+p3Yf8373Zms35NVXnn/Oi1ViaI1jTT5nzCsGErveSzWM6icsF1ySe4kp+SDiTWdz449virPFUgSiKCnQZb96TbYp5I7Em+HQSyO4JoanukETL/gQNl6KhzXGjuONxljHAartzwZbjdD+N4G4teRsKO5aPwpJsDs7ZXhrAbET/Y14uA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On 07/12/26 at 05:02pm, Nhat Pham wrote:
> On Thu, Jul 9, 2026 at 4:39 AM Baoquan He <baoquan.he@linux.dev> wrote:
...snip...

Sorry, I won't reply to each comment individually. I'll just leave
a summary reply at the end.

> > I think VSS goes beyond solving the "zswap without backing store"
> > problem — it is fundamentally an architectural restructuring of the
> > swap subsystem, with virtual swap as a first-class abstraction layered
> > above physical devices.  That is both its strength (comprehensive,
> > future-proof) and its trade-off (more invasive to existing paths).
> > I respect that.
> >
> > My goal with ghost swap is different: address the immediate pain point
> > with the smallest possible change to the existing infrastructure.  Both
> > approaches have value, and I hope the community discussion will help
> > identify the right balance.
> 
> That's because I believe "zswap without backing store" just by itself
> is a bit narrow of a problem. It's certainly nice to fix, but it's
> more of a nuisance - you already have userspace hacks for it (as I
> mentioned above).
> 
> The problem I'm trying to solve is to support:
> 
> 1. Writeback.
> 
> 2. Dynamicity.
> 
> 3. Decoupled backends.
> 
> all of which are motivated by real production issues, not some
> theoretical problems. I'm concerned that if we only focus on the third
> goal, we'll dig ourself into a hole that prevents us from solving 1
> and 2 efficiently down the line.
> 
> >
> > Thank you again for the detailed review — it has already clarified
> > which parts of the design need more thought and documentation, and will
> > make the next version stronger.
> 
> I really don't want to be antagonistic, but I hope you'd take the real
> production pains that we've had (and have tried to communicate in
> multiple mailing threads, across a timeline of almost 2 years at this
> point) seriously.
> 
> Collaborations should go both ways. I've gone out of my way to try to
> address the concerns of various parties, from spending *multiple
> weeks* testing and investigating performance regression on zram
> backend (which my company does not use), to a rewrite/re-design of
> virtual swap to accommodate parties who wished to opt out of virtual
> swap for now.
> 
> I hope you can extend the same good will to our needs :) I've included
> you (and other swap folks such as Chris and Kairui) in my cc-lists. If
> you have concerns, you could have commented. Instead, you decided to
> send a patch series, which is basically just the ghost swapfile, with
> a bit of afterthought to handle writeback and dynamicity, rather
> inefficiently (no dedicated per-CPU caching), and not even correctly
> (the lack of rmap means swapoff / swap-cache-only physical swap slot
> reclaim is broken).
> 
> I respect you and Chris very much to assume bad faith, but please work
> with me rather than against me.

Before I get into the technical discussion, I want to address something
you raised at the end of your reply — the concern that I'm working
against you rather than with you. Our paths in MM simply haven't crossed
much until now. I can't think of reason why I would want to target you
or your work.

I respect the work you've put into VSS. I did check it. Honestly I am not
fan of it. In your v2: 2244 insertions, 250 deletions, 15 files touched,
a new 455-line header (vswap.h). While swap subsystem has just absorbed the
swap table series. Then another 2200 lines of architectural restructuring
on top is added. Not sure if anybody raise concern about your solution,
or anybody suggests other directions.

I posted ghost swap because I saw a concrete, narrow problem that I believed
could be solved with a small change. It makes decoupling and dynamic
growth with the minimum possible mechanism.  Writeback is explicitly deferred
 — not because it's unimportant, but because it's a separate problem that
shouldn't block the common case. With my shallow knowledge, it's optimal
solution to the encountered problem. If you agree, you can change to
Otherwise, please continue to push virtual swap forward. I'll stop and
wait.

Thanks
Baoquan

