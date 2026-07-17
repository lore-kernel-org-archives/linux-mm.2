Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A03DC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66E96B00B5; Fri, 17 Jul 2026 12:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E403F6B00B7; Fri, 17 Jul 2026 12:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D542E6B00B8; Fri, 17 Jul 2026 12:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8175A6B00B5
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:52:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1BA740176
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:27:14 +0000 (UTC)
X-FDA: 84998495988.21.CB4FDB9
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 395CF80006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:27:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C6Yr8VoP;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298432;
	b=JgdQ/pU8Bl/kPRiCUnI4Lj6nuLVdMlP+puUT6dQJTripNrORHumvyan7Hel7c5nt5rb0EL
	e5WNCkUJ1MRzQ5DeJUEb6nV6ZX0d+iA1NGJ6Ts7VlLUU95MGB+5OsCsO4CVwRQF6qi4Y2r
	liOrFU02HtRg3p1Lnx2E3UIzFF83k7c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C6Yr8VoP;
	spf=pass (imf02.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JwUlLLKebphfCZUI9OSd5TG1SsZvmuLzd82pDv18lMs=;
	b=0xbClzdbtrcSKEcYyRsyR9k30+apC6l4rtKtfqn+SakbkbuH1RoiU8ejnGgvcutSjXU0aN
	40tH/7l6i3bXgsb4eBNGlXBUi9ryKyTeLoy0EuD2c3r0tst1gqEuKsTC22aOUBl1N6Na1T
	VFhOB+CQMt9GynQeFJOn3gXtla8bfsc=
Date: Fri, 17 Jul 2026 22:27:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784298430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JwUlLLKebphfCZUI9OSd5TG1SsZvmuLzd82pDv18lMs=;
	b=C6Yr8VoPlS770QJmaqAuRHD/59NVlN8Si9z7X7ViOB5SCH29GsqRZnrhM3MUgM1LjfvsGR
	TbmRSEQYunl/+F6l1kGJPnzq/8BS4ZVfxLZaGb7C+4CSSf06FckT+ztdos9Vh+8dJDRHcI
	ZNXv+TgO5D5vwjtx1bi1KLcQebsetUQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, baohua@kernel.org, youngjun.park@lge.com,
	hannes@cmpxchg.org, yosry@kernel.org, chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
Message-ID: <alo7tuEKLjA0IZQe@MiWiFi-R3L-srv>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
 <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
 <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv>
 <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
 <CAKEwX=Pm_C6OD1jAo818wzFVVhLwgVFu-4bLdNrmUZ01URpLTQ@mail.gmail.com>
 <CACePvbV62T9LA894vTXzBZQ2PNh6iYZD7eH6=UjeFSWhUW2aDA@mail.gmail.com>
 <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=NXJ1LKQOA8Qy_4YOS6v+jGbAJnbD5K0=jNbgC8Da0iKw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 395CF80006
X-Stat-Signature: fxmgi81jbpyei4ur8mm4zssgd541qwim
X-HE-Tag: 1784298432-704152
X-HE-Meta: U2FsdGVkX19oq2lgVmPJPaQooq9tdYyHut9fPuhlHlPQaBxSY/kF6D+ifIbfmveerk5CRhWdTn6u5YO8vDxoDBFntO+BSGRUv2SdEHQre1s/PYflGIQlnBpcYyM65F3Bp3UnMzwc6zYHFObKMccZCLsYTlW9KRibYRlnsCQSQma1CdeyWnmRRTImBlw01PN54odayr/PnfWIiAj7wpzPb1v+aDbqa6PWPyL3dnE6QZN0o2DHAfqHXgyRjHWAqjF0KWBkSKxewHGgtTIUglW4r7sxDXbet46Cuqh9HjgG5okKvNqfAAA21QoBBC9hf16HIO/2J4IJRBcnuloRwWV9e1THWHdivMXZbWnWASoUoEnPXoJOCOynoTRiT9BbKgF2gX1VA7eI5Pa19jG0oFSOCzbLstDjjJAs61QGQ0NQ+9e3Kcz3QQHwZD3F234+FUQrSkm/X9IvhgIrrJzkeiZWB/GcA1rz3QiX7gd74IhWIhVynPK05w8YhSFI/HFcYQx7mkFaQOECtWdFT4497gjyUPdi7kecc07bWgRIH789DtWavOlAf/dxtZUJ6XACwV/pfIX/xWG7YduFFnGGmjBSDBAtK0l8aOPFiwHE4zR6cjtXJrM7hIkwUoey+LfIdqi3PtechmJeJ7KmuMTi9Xockltd+mCUKDZe/1F5l/sl96KFn0FgSpvL9cutk4Q0XprWsfaTI2KAnu/wjfRUtzUIOGy5Eb3JRYMnI/WIsH+5hB5tjM3xvrbnHaqrA4VKYmVOxeaaMmpnIvco2/VGnaCwRsha4Kp2U1Tm8gBoG8SydQwTxuXUveMQ+kiTeCRxSzgssnuRbFj1SL76RIZicp8Mow9BTtWH1FisdK/bXYUcNOyNo12tfUFm3p/mILGBct2YXCrA6l3+DliTVYS0cf0fN3KFAezsO9ufEScwqe7Lxfa+1V5k7kd1WKWsUJ3LlEB7c479Q5vhGiTJIdFrcyp
 d7YNBpQH
 EFX2fcuJot4X55HL7GgzoJz83g+vXEFY8RwkfDFmfmgU1VoGKUsYOvlw/OW3b58pnePKL4gKTSnmQEZ8w6IPEMQiYcXI7pS7PJ4uGll4ubF6Jj7mSdVKZxiHGBAYERggyDRmcqT9jxauILrDWbkE1fkd676CZPLm+N2lXn9puZgqvlG7Az6VXkwoI0XHKEjaYAGPZE8RgyXUNBtyH+NPXYQSkBhf4ncsaZ2hUd1NdUf3MJmGQ7XskR8wK7NvLor+xA2RzK9XbeAeyvIozOkgJL6J8FH8No5vlqVBnMUkHNHEGbNUtpgzMuIVSntYH712SX1pp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/16/26 at 09:49am, Nhat Pham wrote:
> On Wed, Jul 15, 2026 at 4:04 PM Chris Li <chrisl@kernel.org> wrote:
> >
> > On Wed, Jul 15, 2026 at 9:18 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > >
> > > On Wed, Jul 15, 2026 at 7:19 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > > >
> > > > On 07/15/26 at 07:21pm, Baoquan He wrote:
> > > > > Hi Nhat,
> > > > >
> > > > > On 07/12/26 at 05:02pm, Nhat Pham wrote:
> > > > > > On Thu, Jul 9, 2026 at 4:39 AM Baoquan He <baoquan.he@linux.dev> wrote:
> > > > > ...snip...
> > > > >
> > > > > Sorry, I won't reply to each comment individually. I'll just leave
> > > > > a summary reply at the end.
> > > > >
> > > > > > > I think VSS goes beyond solving the "zswap without backing store"
> > > > > > > problem — it is fundamentally an architectural restructuring of the
> > > > > > > swap subsystem, with virtual swap as a first-class abstraction layered
> > > > > > > above physical devices.  That is both its strength (comprehensive,
> > > > > > > future-proof) and its trade-off (more invasive to existing paths).
> > > > > > > I respect that.
> > > > > > >
> > > > > > > My goal with ghost swap is different: address the immediate pain point
> > > > > > > with the smallest possible change to the existing infrastructure.  Both
> > > > > > > approaches have value, and I hope the community discussion will help
> > > > > > > identify the right balance.
> > > > > >
> > > > > > That's because I believe "zswap without backing store" just by itself
> > > > > > is a bit narrow of a problem. It's certainly nice to fix, but it's
> > > > > > more of a nuisance - you already have userspace hacks for it (as I
> > > > > > mentioned above).
> > > > > >
> > > > > > The problem I'm trying to solve is to support:
> > > > > >
> > > > > > 1. Writeback.
> > > > > >
> > > > > > 2. Dynamicity.
> > > > > >
> > > > > > 3. Decoupled backends.
> > > > > >
> > > > > > all of which are motivated by real production issues, not some
> > > > > > theoretical problems. I'm concerned that if we only focus on the third
> > > > > > goal, we'll dig ourself into a hole that prevents us from solving 1
> > > > > > and 2 efficiently down the line.
> > > > > >
> > > > > > >
> > > > > > > Thank you again for the detailed review — it has already clarified
> > > > > > > which parts of the design need more thought and documentation, and will
> > > > > > > make the next version stronger.
> > > > > >
> > > > > > I really don't want to be antagonistic, but I hope you'd take the real
> > > > > > production pains that we've had (and have tried to communicate in
> > > > > > multiple mailing threads, across a timeline of almost 2 years at this
> > > > > > point) seriously.
> > > > > >
> > > > > > Collaborations should go both ways. I've gone out of my way to try to
> > > > > > address the concerns of various parties, from spending *multiple
> > > > > > weeks* testing and investigating performance regression on zram
> > > > > > backend (which my company does not use), to a rewrite/re-design of
> > > > > > virtual swap to accommodate parties who wished to opt out of virtual
> > > > > > swap for now.
> > > > > >
> > > > > > I hope you can extend the same good will to our needs :) I've included
> > > > > > you (and other swap folks such as Chris and Kairui) in my cc-lists. If
> > > > > > you have concerns, you could have commented. Instead, you decided to
> > > > > > send a patch series, which is basically just the ghost swapfile, with
> > > > > > a bit of afterthought to handle writeback and dynamicity, rather
> > > > > > inefficiently (no dedicated per-CPU caching), and not even correctly
> > > > > > (the lack of rmap means swapoff / swap-cache-only physical swap slot
> > > > > > reclaim is broken).
> > > > > >
> > > > > > I respect you and Chris very much to assume bad faith, but please work
> > > > > > with me rather than against me.
> > > > >
> > > > > Before I get into the technical discussion, I want to address something
> > > > > you raised at the end of your reply — the concern that I'm working
> > > > > against you rather than with you. Our paths in MM simply haven't crossed
> > > > > much until now. I can't think of reason why I would want to target you
> > > > > or your work.
> > > > >
> > > > > I respect the work you've put into VSS. I did check it. Honestly I am not
> > > > > fan of it. In your v2: 2244 insertions, 250 deletions, 15 files touched,
> > > > > a new 455-line header (vswap.h). While swap subsystem has just absorbed the
> > > > > swap table series. Then another 2200 lines of architectural restructuring
> > > > > on top is added. Not sure if anybody raise concern about your solution,
> > > > > or anybody suggests other directions.
> > >
> > > Yes, it's a big patch series. But as you pointed out earlier, it
> > > solves a larger problem with a single coherent design :)
> > >
> > > > >
> > > > > I posted ghost swap because I saw a concrete, narrow problem that I believed
> > > > > could be solved with a small change. It makes decoupling and dynamic
> > > > > growth with the minimum possible mechanism.  Writeback is explicitly deferred
> > > > >  — not because it's unimportant, but because it's a separate problem that
> > > > > shouldn't block the common case. With my shallow knowledge, it's optimal
> > > > > solution to the encountered problem. If you agree, you can change to
> > >
> > > The problem is not the lack of writeback support per se. I understand
> > > that sometimes pieces of a design can be deferred to a follow-up patch
> > > series.
> > >
> > > I'm more concerned that the ghost direction so far does not seriously
> > > take it into account in the design at all, which might make it either
> > > impossible or very hard to redesign around down the line. I don't want
> > > to rip a huge chunk of it out down the line later - we just avoided it
> > > with the swap table with Kairui's proposal.
> > >
> > > >
> > > > Part of above sentence is missing. I meant if you agree on the ghost
> > > > solution, you can change to take its way and continue, just add me to
> > > > CC. Or we can work together.
> > >
> > > How about this - let's solve one piece of the puzzle together, one at a time.
> > >
> > > First, your optimization patch series. Have you taken a look at my
> > > proposal ([1])? I believe that design should be cleaner, while still
> > > allowing you to put it all you want to get (elimination of xarray
> > > being the chief benefit), without requiring you to modify swap cache
> > > and swap count operations (since you don't have to move the metadata
> > > in and out of struct zswap_entry). It does require a bit more code to
> > > dynamically allocated the backend array, but should be trivial IMHO.
> > >
> > > [1]: https://lore.kernel.org/all/CAKEwX=OvR7GbU_9f2h_MtU4m0g6s-esHmNQKYNhJz610M0P3Sw@mail.gmail.com/
> >
> > Hi Nhat,
> >
> > Sorry for the late reply. I've been busy and just saw this.  First
> > impression looks promising, it is better than any previous version of
> > VS. Thanks for incorporating Kairui's feedback. Please give me some
> > time to sleep on it. I will get back to you on that.
> 
> Please take a look. I was waiting for your response as well :)
> 
> The patch series is large, yes, but it's an RFC meant to show case the
> final end design.
> 
> >
> > > Next, if you just want pure ghost swapfile without writeback support,
> > > maybe something similar to the first 2 patches in my RFC? i.e up to
> > > this patch:
> > >
> > > https://lore.kernel.org/all/20260612193738.2183968-3-nphamcs@gmail.com/
> > >
> > > I'm sure you could find issues/bugs in it too with some extensive
> > > testing (a lot of my performance testing is done on the entire series
> > > as a whole), but from a design point of view it should achieve what us
> > > both want, no? It's literally just a ghost swap device - most of the
> > > other design elements of vswap (the new charging behavior, rmap,
> > > support for writeback) comes in latter patches. I think the difference
> > > is:
> > >
> > > 1. It's transparently dynamic, whereas in your RFC it's driven by a
> > > userspace knob. Do you think there are inherent values in a userspace
> > > knob?
> > >
> > > 2. The address space can also shrink when swap usage drops at runtime.
> > >
> > > 3. The dynamic address space is backed by an xarray. Note that it's
> > > structured differently than zswap's one (it's an xarray pointing to
> > > clusters). If you have rationales or numbers to show that vmalloc
> > > array is superior (while still support the kernel-driven expansion and
> > > shrink), please let me know.
> > >
> > > If you have no faith in me and do not like my code, you can take the
> > > code as a starting point, or just the idea, and drive it yourself. Or
> > > let me know if you're unhappy with any piece of it - we can discuss
> > > further.
> > >
> > > >
> > > > > Otherwise, please continue to push virtual swap forward. I'll stop and
> > > > > wait.
> > >
> > > Look man, I care about the problems being solved and I'm a sucker for
> > > good ideas, but I'm not married to anything, be it my code or my
> > > ideas.
> > >
> > > I have literally dropped my old code and adopted Kairui's suggestions
> > > after playing with it and liking it, to make sure every party's
> > > concern is met.
> > >
> > > If you have concerns, please let me know, or keep sending code if you
> >
> > May I add one wishlist item related to ghost swapfile here? I will
> > reply to your VS thread for other feedback.
> >
> > For the ghost swapfile usage case (no writeback). Can VS support this
> > usage case while maintaining per-swap-slot metadata usage comparable
> > to the ghost swapfile implementation? If we have to put a number to
> > it, let's say the increase in metadata is less than 1 byte per swap
> > slot compared to the ghost swapfile implementation.
> >
> > We have large deployments of ghost swapfile in the fleet. I want an
> > upstream aligned solution that does not increase the existing memory
> > overhead compared to the current ghost swapfile deployment, for that
> > usage. As you know, memory pricing and optimization pressure are high.
> > The ghost swapfile patch itself is relatively simple. If VS can
> > address this usage case, it will remove a lot of incentive to explore
> > ghost swapfile-like solutions.
> 
> Hi Chris. I have some thoughts on this - let me know what you think.
> 
> I understand the memory overhead discussion here. In the case where
> vswap slot is backed by a real swapfile, I have not figured out a way
> to make the overhead disappear yet. The damn rmap is very annoying - I
> have some strategies to get around it for certain operations, but none
> of it can be done without a full fledged patch series of its own.
> 
> However, with the ghost zswap swapfile backend specifically, I think
> the overhead is going to be negligible compared to the status quo
> upstream (things might be different internally at Google - please let
> me know!). This is because the main remaining per-slot overhead comes
> in the form of one per-cluster array to store the "backend", here it's
> going to store struct zswap_entry pointers. This is not extra overhead
> though, because it basically replaces the xarray (that you added all
> those years ago)!
> 
> The rest is small stuff here and there that is not O(slot) but rather
> O(cluster). For example one struct rcu_head per cluster, xarray
> overhead for the dynamicization - note that this xarray manages
> cluster, not slot. I think that's all, unless I miss something.
> 
> So if you don't writeback, i.e no physical swapfile, then I think
> there is negligible overhead (no rmap and all that jazz).
> 
> Does this sound acceptable to you?
> 
> Baoquan, what do you think?

Thanks for the thoughtful reply and the very constructive proposal.
Your suggestion about moving forward in small, incremental steps in
last mail is really appealing — I think that's the right way to make
progress on this. I need a little time to think it through more
carefully before giving you a proper response. Will get back to you
soon.

Thanks
Baoquan

