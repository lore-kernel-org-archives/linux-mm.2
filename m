Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FA1C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F355B6B00AD; Wed, 15 Jul 2026 10:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E056B00AF; Wed, 15 Jul 2026 10:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D186B00B0; Wed, 15 Jul 2026 10:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C01226B00AD
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:19:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 391521201AA
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:19:31 +0000 (UTC)
X-FDA: 84991218942.18.A8CBAFE
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf06.hostedemail.com (Postfix) with ESMTP id 04A8A18000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:19:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZdJMwLJJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784125169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+W13oIaKJ2kJiG8pTbR7NdfVkDGpgODZQAAQ21qnls=;
	b=Dehc/6190dutfsz3Uv500/E8oqcuquO1mYR3F3wC+5GcBKpcUXCnK6MqpQZh2D/H7xk6Mv
	2FS70YuZNeJmxh15hJfAHIBm318ehQajQAg+vCZiBNjNnroFv0qbOv3CTslcXYu8kF+VrD
	k/rlC/TRy0wn3DilAGP3Mhyg/etqCl4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZdJMwLJJ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784125169;
	b=5mIHJZ04VlOWke7PovXSS2xdUTUISUi2JjoUdqD1UYslJCQNVhtjumwLX+lq7Wg7Pf7pYr
	azcKbl5zHehNKo8Hi8Io294eYvZzmCRaMafJSOIfeCFKUHw88zxBL0Ghk7iY3uVDJvh6Wu
	nz7M5Pd/68R29wUMiX7lmx2/F/YGKs0=
Date: Wed, 15 Jul 2026 22:19:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784125166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+W13oIaKJ2kJiG8pTbR7NdfVkDGpgODZQAAQ21qnls=;
	b=ZdJMwLJJSoBVXAlJ9Y0W7mljB+OphsYX2p4eS+IeHM6S3WnuUNBRPX6BBlbAwetvSY3uvF
	R994b0G8a0XVcEi2d9Eb4QcS4QsnckzAESWezf5bAfjB/vGZY39PoM7pTj7v8UnVTJXrZd
	4gcQctPnECI4gaZUrQ73kY2SuLFpQnE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, baohua@kernel.org,
	youngjun.park@lge.com, hannes@cmpxchg.org, yosry@kernel.org,
	chengming.zhou@linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/10] mm/swap: ghost swapfile with backend switching
 via Redirect entries
Message-ID: <aleW5xL2gYcU_Rl4@MiWiFi-R3L-srv>
References: <20260707082614.95030-1-baoquan.he@linux.dev>
 <CAKEwX=P50av2rfocpsqZoDQowZ=EEhQ-5vj5tBykbNz8vtKTzA@mail.gmail.com>
 <ak-IS61GeP85Jnxg@MiWiFi-R3L-srv>
 <CAKEwX=PEgnJ4nGFZYUwMryjq+Yp4v8Op_HdZ6_xEJ4n_MrM0Yw@mail.gmail.com>
 <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aldtS2S-TXc7ocsH@MiWiFi-R3L-srv>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 04A8A18000C
X-Stat-Signature: 65n6inw6ft4fgbq8mj7zzk7bbh715f97
X-Rspam-User: 
X-HE-Tag: 1784125168-393472
X-HE-Meta: U2FsdGVkX1/WCNQXxrQiS04y8usjzNhCYb+a2W2ZU9VxZo3o5uNICMAKL7oWmTQzctykaYcJJZc2BQOyd99XitUcYDuMEcOqZfmEubYbEdJ/3shMHCrIl+9SGYhFtNk5BKyKzLgitDDv5nfMGKg3n0XzyvNfwBKjH/AMijra/suqzWk9tomWA46GawXKi63r6lSi/CRUcNCq9a3KOZkA76MBje1NsVVecbwQF80xU314ZZTq/PGfM/i54CYmv7f7+97B8HePMp3MS8onAhbTpaJzfHMggbLCUa8XeSg1/GwBp8l89mGqO2Qaaa7PsSfAJWgMWcbQlEAVD4B8PctsQz9bZmxyr4L1vdEO7rfj/z9WpvrSiVytvbyJCgHay6BELAiF+HjhLHl+/CbdI+UHq9LVn4aPA+By+rFZVSg5fPN+EdlOOegD8WzWolvPhdUGTM/0p4TfXVRwzVgkY6WADLdQV3pFjV05O7c6Cko3obRMQCjgMviQxds8t8nTFaF+3q/RQiuntBTubZN3EusIPyjCTnmF7FwJo/zlVsI9VbIt/D2v0wJ05ps08FrU8GAUvdsweZPeXOLxyMU39DupiMU4xr5MnWpvrLBUg/IhSVIxyYhIYMGw5k56fflcYNOPZkiZSW1WzWtGd+FaytxTaNHjP8ZCDGhvilnlUXiRWqbWl4MMdl6R3j4+R52QqBSKz53qm5Xs1iiHlNgotOnbQdGcp2qSR6WVhcpJQjyFUN32FamBS0zEys8o7WMgBHcp94LAGum80DHIbDZ/F5sN6MeVeJIWwK+V4CbWx5YkJgMJYqJZx7eC2sZdW/HwhZc0UAybSwBYZSNnYPs/xs8B/ZOhRGZaUHAmrZIE4gi8CyU6RBt7UNMaNRXbeM2r5w+5La2d0gqcTrAu6CZQpuOKbt+i+0lcDMcykBhXHww5oZRCA1qyrCoo14gtMUB5DKK8sKVlSJyurUudtHWzJMx
 vVEGW03q
 dy8GClOx8CDbND+8UBB7QjzSag/t8mDiXOuZ89ybYsjyILvnp8nq/8l5EOsGL/gfX+4PE0rmJgUq4jhgSdG1ebPM9+6Ua6UnrVdVCiEqvhjegWYc5mKEDMN87PkfNhJUspUk7v+oErvPsRA+77qM7e2CozLS0xn+sLu8SGNyqVjBRjiFeXvFHJ066NtvC5tVGR6dUMvli3Qq11pELhbgghZ29l4i+UqBXnV2qlqB5qVUEOGiwZvcMIWCtHtXxw1Nj9ZN9Bak2i/v+SNdKPaWWwljToQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/15/26 at 07:21pm, Baoquan He wrote:
> Hi Nhat,
> 
> On 07/12/26 at 05:02pm, Nhat Pham wrote:
> > On Thu, Jul 9, 2026 at 4:39 AM Baoquan He <baoquan.he@linux.dev> wrote:
> ...snip...
> 
> Sorry, I won't reply to each comment individually. I'll just leave
> a summary reply at the end.
> 
> > > I think VSS goes beyond solving the "zswap without backing store"
> > > problem — it is fundamentally an architectural restructuring of the
> > > swap subsystem, with virtual swap as a first-class abstraction layered
> > > above physical devices.  That is both its strength (comprehensive,
> > > future-proof) and its trade-off (more invasive to existing paths).
> > > I respect that.
> > >
> > > My goal with ghost swap is different: address the immediate pain point
> > > with the smallest possible change to the existing infrastructure.  Both
> > > approaches have value, and I hope the community discussion will help
> > > identify the right balance.
> > 
> > That's because I believe "zswap without backing store" just by itself
> > is a bit narrow of a problem. It's certainly nice to fix, but it's
> > more of a nuisance - you already have userspace hacks for it (as I
> > mentioned above).
> > 
> > The problem I'm trying to solve is to support:
> > 
> > 1. Writeback.
> > 
> > 2. Dynamicity.
> > 
> > 3. Decoupled backends.
> > 
> > all of which are motivated by real production issues, not some
> > theoretical problems. I'm concerned that if we only focus on the third
> > goal, we'll dig ourself into a hole that prevents us from solving 1
> > and 2 efficiently down the line.
> > 
> > >
> > > Thank you again for the detailed review — it has already clarified
> > > which parts of the design need more thought and documentation, and will
> > > make the next version stronger.
> > 
> > I really don't want to be antagonistic, but I hope you'd take the real
> > production pains that we've had (and have tried to communicate in
> > multiple mailing threads, across a timeline of almost 2 years at this
> > point) seriously.
> > 
> > Collaborations should go both ways. I've gone out of my way to try to
> > address the concerns of various parties, from spending *multiple
> > weeks* testing and investigating performance regression on zram
> > backend (which my company does not use), to a rewrite/re-design of
> > virtual swap to accommodate parties who wished to opt out of virtual
> > swap for now.
> > 
> > I hope you can extend the same good will to our needs :) I've included
> > you (and other swap folks such as Chris and Kairui) in my cc-lists. If
> > you have concerns, you could have commented. Instead, you decided to
> > send a patch series, which is basically just the ghost swapfile, with
> > a bit of afterthought to handle writeback and dynamicity, rather
> > inefficiently (no dedicated per-CPU caching), and not even correctly
> > (the lack of rmap means swapoff / swap-cache-only physical swap slot
> > reclaim is broken).
> > 
> > I respect you and Chris very much to assume bad faith, but please work
> > with me rather than against me.
> 
> Before I get into the technical discussion, I want to address something
> you raised at the end of your reply — the concern that I'm working
> against you rather than with you. Our paths in MM simply haven't crossed
> much until now. I can't think of reason why I would want to target you
> or your work.
> 
> I respect the work you've put into VSS. I did check it. Honestly I am not
> fan of it. In your v2: 2244 insertions, 250 deletions, 15 files touched,
> a new 455-line header (vswap.h). While swap subsystem has just absorbed the
> swap table series. Then another 2200 lines of architectural restructuring
> on top is added. Not sure if anybody raise concern about your solution,
> or anybody suggests other directions.
> 
> I posted ghost swap because I saw a concrete, narrow problem that I believed
> could be solved with a small change. It makes decoupling and dynamic
> growth with the minimum possible mechanism.  Writeback is explicitly deferred
>  — not because it's unimportant, but because it's a separate problem that
> shouldn't block the common case. With my shallow knowledge, it's optimal
> solution to the encountered problem. If you agree, you can change to

Part of above sentence is missing. I meant if you agree on the ghost
solution, you can change to take its way and continue, just add me to
CC. Or we can work together.


> Otherwise, please continue to push virtual swap forward. I'll stop and
> wait.
> 
> Thanks
> Baoquan

