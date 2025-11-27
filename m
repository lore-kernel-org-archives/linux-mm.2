Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54A57D116EC
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93A016B000E; Wed, 26 Nov 2025 21:54:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9D06B0010; Wed, 26 Nov 2025 21:54:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827136B0022; Wed, 26 Nov 2025 21:54:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 716DB6B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:54:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7FA6507E5
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:54:55 +0000 (UTC)
X-FDA: 84154869750.03.9E7E93A
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf09.hostedemail.com (Postfix) with ESMTP id 70F2C14000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:54:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764212094; a=rsa-sha256;
	cv=none;
	b=IRqm8NGQ1cOyRtyUU+h4gzZNwJ9+8ZzDTRpVhiYJy5a3S8hpyjTRht9kI4EpakS6ufc56K
	pLgivo+VK+vBMcMDP+iPNqKscHCnoK9s4/BG1A1PSfhqG1lfK4fpp5/lR5WjK9jLkemco5
	IBfJVhSWoDnI3Wul+6wdWlibgdCvuB8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764212094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cbw/iYbpemJBG5VI9bE28+uQfyAzlYkiUyD4eiXiB18=;
	b=p+wZkiR83Jx1KPrtYDqUGy8ocQxDcpUINUu03KN9QqDyEaYUx4TNwoEkTHp0xthdsmLWo6
	QjqI5Gmh8lj7zZwxu9ns/YQfss0ijVi2Wqk1xk9ydQ57hvFfNL245/dmDJMhHGSUOv0WXG
	Jf/r04c70fXh8LlEsg4BvLHL+5dAKKo=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 11:54:49 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 27 Nov 2025 11:54:49 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSe9eckUCGP9eTS+@yjaykim-PowerEdge-T330>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70F2C14000B
X-Stat-Signature: 7ej5m6ng87k48w6wmtrjkqam1s3i7zyr
X-Rspam-User: 
X-HE-Tag: 1764212092-677516
X-HE-Meta: U2FsdGVkX19Y8wBLwGfzTXM47csre1Fli0uayhFeg2IsiwJHDbzQ5So2fyEnjwV6ugCpMgQWhOb1lF5THodEvwsYrsBDuhmOuEKqPenScHU+sPL/LJIGFj0UCibk4TLQCLfeQP6e37OApV9IR54Ipo51LK8kzfmjDTuyHpfODyO6cljnJwMqczx0GyRMGHUAHoSNgcRlsaa33R/uQlXGlVx09VPZr8PETEJwJuIwSus836lzgNwO7bxiygtN1e7D11upi731+u/oLVeUjISIM2KwlitEucHnHX40CWf8ZXYWUNjHVVvGyw3dljS/d9ESL+U2Gp4gs5KcG7auiFbvnwajUUNtu3m8wvXNNXTBKOx2DynPZpAYI7HKS60d/FEgxhIh1rvbs9o/8puj5yAd1+KRPAEa+3UuyGYwbnPW5GhXK3bqgiFzF5XGztdEgktseD8xdh3/ykeFw2pMbbVjohv3U9VJ2KNHQSwQk8ptm24dHKcIayri3i0uDiQV0nlxeuycUZf1SQVVfh97IcgIguPfrhe93t3vMqE4q0ueureRdaT0DZ49vrdr3HrmIGTzAZlueLHiff2kS1VqNrWYLGxZM5v/aOnPxE9d4AsLduoiVqrPLoik24EYGllHlS5Y34z4PR7WKC2xuXRsS9Cq7UfJlUIqTxwqejpCvNuT3dU4T7RzqvNHiusHVE1mYhBjCs2vSIKQa03BVk5GnZWgG45mkWSEkGbo3MzXDwHDNaYlbmgn3wMaePWyZT2WSCEic16/aqaMc2HcSPKbpZnyVTNDL1lWwEsUSCYa4b518HQZhfgbHm/S1tR/SCHrtZWwfET1qdvVTYQHkt2QacldDjm1nL8mXba6hkpbNLGKCg7pfpfsoiVzzVZHtdm2uNldDlkjakZAZuOupuXvuzz/KNHbUZv7xk6pjql55ro5fddO1QU1HrojZMFGd9hQHbmFnNdKHznhvk1elnFz0xo
 j3U8z6H0
 sXidVgk77RzzE+KezveVnydPxZWVIqYy6mfTxEO0B1CTYocoN7Q7zhaGGT4E1ldcRPdwUjXDCcY507vECptpG+dUesw2G4rIiOrJt1RAoVUxBrz3yYcAQ9EZPy0jc/l+9RGjW8yBnVOHyVxvAtcTPwElOXjxCpNWwuRFlMlJC99+sbOSlJRDsIMboRtvZEmP8vvNyCI+/Quh+R6Mmz0NglTxVIeMEM37QQKW1jbNtXJFKeUdqwC6f60jZaXHVfjfD55LIKQsgDNV0BY6BJh1q3W9GZFhBfJedW7RPhdOa3RbiEWig8fuCOmoEZGic7f/KAJB7SSf9K9PdXZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> On 11/26/25 at 01:30am, Youngjun Park wrote:
> > swap_sync_discard() has an issue where if the next device becomes full
> > and is removed from the plist during iteration, the operation fails
> > even when other swap devices with pending discard entries remain
> > available.
> > 
> > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > when the next node is removed during discard operations.
> > 
> > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > swap_active_head. This means the iteration is only affected by swapoff
> > operations rather than frequent availability changes, reducing
> > exceptional condition checks and lock contention.
> > 
> > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 18 +++++++++++-------
> >  1 file changed, 11 insertions(+), 7 deletions(-)
> > 
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index d12332423a06..998271aa09c3 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> >  	bool ret = false;
> >  	struct swap_info_struct *si, *next;
> >  
> > -	spin_lock(&swap_avail_lock);
> > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > -		spin_unlock(&swap_avail_lock);
> > +	spin_lock(&swap_lock);
> > +start_over:
> > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > +		spin_unlock(&swap_lock);
> >  		if (get_swap_device_info(si)) {
> >  			if (si->flags & SWP_PAGE_DISCARD)
> >  				ret = swap_do_scheduled_discard(si);
> >  			put_swap_device(si);
> >  		}
> >  		if (ret)
> > -			return true;
> > -		spin_lock(&swap_avail_lock);
> > +			return ret;
> > +
> > +		spin_lock(&swap_lock);
> > +		if (plist_node_empty(&next->list))
> > +			goto start_over;
> 
> If there are many si with the same priority, or there are several si

Is this because of the requeue that happens while iterating over
`swap_avail_head`? But, requeue does not make node empty.
Also,  since we are iterating over `swap_active_head`,
it seems like it wouldn’t happen. 

> spread in different memcg when swap.tier is available, are we going to
> keep looping here to start over and over again possibly?

I think loop cannot happen on here by that reason.
But, Loop can possbily happen between swap_alloc_slow and swap_sync_discard.

If `swap.tier` is applied, I think you’re referring to the situation where
`si`s not belonging to the current tier are discarded successfully, and then
the next iteration goes through the available list again for the swap devices
in the same tier. As you mentioned, a needless looping situation could occur. 
(if discards accumulate very quickly, could it even lead to an infinite loop.)
If `swap.tier` is applied, this part may also need to be modified.

> The old code is supposed to go through the plist to do one round of discarding? 

After your review, I thought more about it — if continuous swap on/off occurs
while the `swap_lock` is released, it seems that we could keep hitting
`plist_node_empty`.
However, I think this case is very unlikely, so it
shouldn’t be a problem. 
Actually, swap_alloc_slow already works that way.
What do you think?

In the old code, if a swapoff occurs and swap usage becomes zero, causing it
to be removed from the `avail_list`, it ends up doing a one-round discarding.
If we don’t like the idea of looping due to continuous swap on/off, we could
consider adding a retry count or removing the `plist_node_empty` check.

> Not sure if I got the code wrong, or the chance it very tiny.
> Thanks
> Baoquan

I answered based on my understanding, but please correct me if I misunderstood your point.

Thanks for the review.
Youngjun Park

