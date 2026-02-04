Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80B59E83F05
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 18:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1C556B0089; Wed,  4 Feb 2026 13:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9FE26B0093; Wed,  4 Feb 2026 13:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9EE26B0096; Wed,  4 Feb 2026 13:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 964386B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 13:24:49 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 687F61A020F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:24:49 +0000 (UTC)
X-FDA: 84407600298.25.E57C0F9
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf25.hostedemail.com (Postfix) with ESMTP id E02DEA0004
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 18:24:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=I0BY7Y2K;
	spf=pass (imf25.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770229488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdUb25hwDf7Td6RZQE9eems/6ez37ij9pWo0A8i9afc=;
	b=Zn+MxyDJ6RME9fmmnZtK5Shz5BKHg8W1iXr2bz3SyRUU5JihsA5mg/yh0wiFw2CYoJFJ+O
	hDMOK2y/VRF95iJJO3fGMQtNwQWFG+pppkRdYuQCQLjy7to2qmt0NsRa/z3ehMPrJxv41i
	qEMvezpBib4AruxOXz1ITkuQipefodg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=I0BY7Y2K;
	spf=pass (imf25.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770229488; a=rsa-sha256;
	cv=none;
	b=giZ/i84zM7D8p32OhXb8eOIDZhuj/fBt9rnBnUYu3jb5/oeeQvlucM0ezBrmO5Q9zJTAKG
	kvGGHl+unNx8wh1OqoUGc/PNV0/2XDEXJhlItbr3VcpmCrvWm/crBIQSZnpBv10tU5z6vf
	iSzynTMvR02Hce1bwbfdIicVU5gCauk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1770229486;
	bh=OdUb25hwDf7Td6RZQE9eems/6ez37ij9pWo0A8i9afc=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=I0BY7Y2Ka/1RFhZQ0vnJeovKXCgV64QfqBLB20+WoAG393kfyRXpGop8523cdl0VA
	 dzsVy17LbKM3hf65ipzajQZTot0/H11NeCXwD+vyWP8lZnbpMvbf/NHRoS+yVYF7YQ
	 Z/izDqFw7B8V9Orz+bH1Ur0dya3OhhPoiq7Axm1k=
Received: by gentwo.org (Postfix, from userid 1003)
	id 98963401E2; Wed, 04 Feb 2026 10:24:46 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 95C19400CA;
	Wed, 04 Feb 2026 10:24:46 -0800 (PST)
Date: Wed, 4 Feb 2026 10:24:46 -0800 (PST)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Vlastimil Babka <vbabka@suse.cz>
cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
    Petr Tesarik <ptesarik@suse.com>, David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Uladzislau Rezki <urezki@gmail.com>, 
    "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
    bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
    kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org, 
    "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH v4 00/22] slab: replace cpu (partial) slabs with
 sheaves
In-Reply-To: <665ff739-73d8-4996-95e0-f09c3e5b6552@suse.cz>
Message-ID: <2abde505-1e35-8d74-2806-7a3cd430e306@gentwo.org>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz> <imzzlzuzjmlkhxc7hszxh5ba7jksvqcieg5rzyryijkkdhai5q@l2t4ye5quozb> <390d6318-08f3-403b-bf96-4675a0d1fe98@suse.cz> <pdmjsvpkl5nsntiwfwguplajq27ak3xpboq3ab77zrbu763pq7@la3hyiqigpir>
 <665ff739-73d8-4996-95e0-f09c3e5b6552@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: E02DEA0004
X-Rspamd-Server: rspam07
X-Stat-Signature: shj4oa796ejd314uyssh8jjchiqghudb
X-HE-Tag: 1770229487-632895
X-HE-Meta: U2FsdGVkX19vKSXZ6Phc7hAAb02rmplvEvoFEby8jBp/9Sv0eRJwiJNSdIYdF9No3zsk3EiWUMuPCToaOZlhc+8rWUTvkMjkRSprOrI70bAGBNeV5Cara8shdjOuYmj3mqr+kXtb/59p2Uk/1h3CpaJfWy3ESX2aKJbwcFi1QQ0co8T1dLHuq5KueaC3lG3Hj9w8YtKUHvA3r3dTZbFMCM9WmFHrpRd8fD3X89vSl30dY7IZ0aH6G5X/uByab1QghHjghUX6GOAPqAUuo9bTwHwP5ZujOeIaYhTWNTgTbLANKmh2u4kRitpJlUNR6vlGIxGgFO54q9Fg+IdncetSEt+IAfqOH+BTVvss7DnFrZyz7WqH96ujU13RjHVXeB9uXCKMW+UiUdu8SpitxUC6HkuZ8vuVQYapw3ULnel5Y8rzc118Z69jreCBVk9/oI1q5U1B0Lqi5sO3kRioY7YjfMoO28NgGHt5rTtYchtRZMwITD1g9qaQA7rthFwu5Id3tvoICvZv8w0bjIF9yqhTDPeaG2gauGyR/DrVEcazEAxdY6R8tfZZsNOWQByASmgUDlTn3w9snS8nQBz5UuJ5tGZU1sijK2rt9RqT31LRlzMiwvAbfuZ3MZoAsD0xrT887h0JP9HGNBbLyZuoTW+dYFj4O/eBFzPXSyrMnJk1zZlxaW6yQNGzoabSZc4mVHm34+QI7zvTCJxVud82h7L3eHtE5KAggctdBfC2CPJEOlOafvjT5dgykeMxh21/nRGbW56GsR1CRZeKH39I2LkDphT2q3FlFgeVvzEcey4wI1uYqA0APmstGhI+2toOkNiOdEH8In7MSdehLPP4QFeSIQlvzGRiaSokovw4QsgvoU1rZqjT1+Dnt/bdDkI24KKkYO8xujKwGAha0WUrlTP+wZODRIUkgC07I0uUP6Ub/1U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 4 Feb 2026, Vlastimil Babka wrote:

> > So I think the performance of the percpu partial list and the sheaves mechanism
> > is roughly the same, which is consistent with our expectations.
>
> Thanks!

There are other considerations that usually do not show up well in
benchmark tests.

The sheaves cannot do the spatial optimizations that cpu partial lists
provide. Fragmentation in slab caches (and therefore the nubmer of
partial slab pages) will increase since

1. The objects are not immediately returned to their slab pages but end up
in some queuing structure.

2. Available objects from a single slab page are not allocated in sequence
to empty partial pages and remove the page from the partial lists.

Objects are put into some queue on free and are processed on a FIFO basis.
Objects allocated may come from lots of different slab pages potentially
increasing TLB pressure.



