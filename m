Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15057CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 07:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720588E0011; Tue, 21 Oct 2025 03:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F87C8E0002; Tue, 21 Oct 2025 03:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635008E0011; Tue, 21 Oct 2025 03:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A5D8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 03:34:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DCF19119DCC
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:34:52 +0000 (UTC)
X-FDA: 84021309624.16.4CEE5A8
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7358814000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:34:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761032091; a=rsa-sha256;
	cv=none;
	b=NxX7+4trDSIVVRgMc6h7tKRYh6qQ+FU4e1AXLN+hhfZ6b6g2K/P0W5Fw5xMfc1NeD9QDI8
	hs/r6Esp+dlFaB+ALSvKsiVaH32tHhHNAtX98f6hAFWxd9q9Bw4XBUW090DTut7nJaE4nP
	27EgXn8A46EGi+E79G/IpMM8PSFrQkg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761032091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=47t0eoimZExNfbLR29YMNL3nVAbeYOLaNpy9TQkE1eA=;
	b=ogcKnwWrJUIwbkifomtfwntBMzTP4xLNMyLm6YkL8UphgkYbrEKOflFxywx4NjljCD1I/L
	Wo+QXOMvmh4uDT1niWPyCCtFcL9tY5FFSGRQkKT7A5FQQTLpTUj+AnYBLFZ6rBPHU1Bd09
	ky+EVeWNHUdb0m5+Hxbo66cLxsOs3uU=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 21 Oct 2025 16:34:46 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 21 Oct 2025 16:34:46 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: do not perform synchronous discard during
 allocation
Message-ID: <aPc3lmbJEVTXoV6h@yjaykim-PowerEdge-T330>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
 <CACePvbWs3hFWt0tZc4jbvFN1OXRR5wvNXiMjBBC4871wQjtqMw@mail.gmail.com>
 <CAMgjq7BD6SOgALj2jv2SVtNjWLJpT=1UhuaL=qxvDCMKUy68Hw@mail.gmail.com>
 <CACePvbVEGgtTqkMPqsf69C7qUD52yVcC56POed8Pdt674Pn68A@mail.gmail.com>
 <CACePvbWu0P+8Sv-sS7AnG+ESdnJdnFE_teC9NF9Rkn1HegQ9_Q@mail.gmail.com>
 <CAMgjq7BJcxGzrnr+EeO6_ZC7dAn0_WmWn8DX8gSPfyYiY4S3Ug@mail.gmail.com>
 <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7CsYhEjvtN85XGkrONYAJxve7gG593TFeOGV-oax++kWA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: ptkx8aba5cysg4r8oapwk6jhffgbgiuh
X-Rspamd-Queue-Id: 7358814000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761032089-429815
X-HE-Meta: U2FsdGVkX19thD/D/e3JzKXC5qzveTu3Et9KkdLEeUKCKMF+Mj9K8+y52brIBCQoCWW+q7RQ9G2nCt5L4LVpeiyjLkzyPqrobcQHsg8MKBv6CRIjG294ILE4Gowb89sp/lygsKGoq0K44zcHxQ1J+GFL6TAVeVofgI+OWCmeeSd1klkAZQoqqF7PyJ9c4BbdUh7X3X1sxt7U2jvEYarcUiz9mhdpyYumqhFhyTeBEqm/F3uGupzLIhjnS1o6pW7fl34YuV9zfvHOcIFdY4MNitAC5PrXCO/9T1PYkmYAGx2CiosjZtwikIpCn5LbwmB0QRS2WPRL+iWFTQ4vIctV7cwfw5cNPZK+059h0IFz9hvkiWegk8MrBOQ+FB+ZQ7jXIYIUj8DmJWK0Xz/6ANwvWaBYEgqJU+EZJQWqowLgZB9Hj9+qHDIZlCl54vwXXM4RZS6JYrEYJ6ncJlm+mYpchltkRO6nE/natd6MmfewB067DfJhl7Oi9KQIqRtK/QkqccgFx/J8LVTX79SDu7gMflD2PlFw8CipE2g9kORf7nEPSniPuPb3wOKMzk7+c1UMJIcpThIgVm06ZG6hRW1xgETgyVuYI07iCyLbWfKmuaYMohEOYPjRHn/7cyJQwKxGbeaKtt9fgnsafZCqgjEtYxm8t4i1pn1oaG4fLtn+tWoft6htHhJ9pJKfBmea4919TFUcRPZFDshQSuLHBV9fXkka1eYtIBdlI96YQwIqsmBbsuT2lhvVO/lyegemURrxifyD2bykDmXRGAitlLh0WQYlmcebP4qJFYZO7p+KfqRC1AFICm7TGifT9+IXYnTpRpq7x0NL+NI7LX8rFZRkLGTmfTkG2Q/8zvfkR0v8aQsTv45PjntzHS30PJe0i0wqS1+VHCszRQn5dTBBJtNeorLAqz2OLY+B+GbitgFm2pecn5sbwb99giVgG8zeq1E7fdK2uI1dsIHc0eM+Akb
 M9i12bTX
 363S5xEQfg/M4PHICsFSxYblO16Cpvz8FBO8j8/VuQRd0lWXF3kGT0T1fNae4Z56psPRHppSRmaXzbvlV+PgiHN+VT5idPEknPGG42fae3NMchllmQjQuuK4+NF5mcWl6R2Z32pP/CBV9Jfv+wkkOtt7osXsZCBdaCeI2E4H8qG0hUcS+xR3FdY9LGbczKn1KzodduLJHiuhKXTLrtFt8w+gcpmZ0JAbap0TmipI3dXw126N3Nh/5Th2ufw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Thanks, I was composing a reply on this and just saw your new comment.
> > I agree with this.
> 
> Hmm, it turns out modifying V1 to handle non-order 0 allocation
> failure also has some minor issues. Every mTHP SWAP allocation failure
> will have a slight higher overhead due to the discard check. V1 is
> fine since it only checks discard for order 0, and order 0 alloc
> failure is uncommon and usually means OOM already.

Looking at the original proposed patch.

 +	spin_lock(&swap_avail_lock);
 +	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
 +		spin_unlock(&swap_avail_lock);
 +		if (get_swap_device_info(si)) {
 +			if (si->flags & SWP_PAGE_DISCARD)
 +				ret = swap_do_scheduled_discard(si);
 +			put_swap_device(si);
 +		}
 +		if (ret)
 +			break;

if ret is true and we break, 
wouldn’t that cause spin_unlock to run without the lock being held?

 +		spin_lock(&swap_avail_lock);
 +	}
 +	spin_unlock(&swap_avail_lock); <- unlocked without lock grab.
 +
 +	return ret;
 +}

> I'm not saying V1 is the final solution, but I think maybe we can just
> keep V1 as it is? That's easier for a stable backport too, and this is
> doing far better than what it was like. The sync discard was added in
> 2013 and the later added percpu cluster at the same year never treated
> it carefully. And the discard during allocation after recent swap
> allocator rework has been kind of broken for a while.
> 
> To optimize it further in a clean way, we have to reverse the
> allocator's handling order of the plist and fast / slow path. Current
> order is local_lock -> fast -> slow (plist).
> We can walk the plist first, then do the fast / slow path: plist (or
> maybe something faster than plist but handles the priority) ->
> local_lock -> fast -> slow (bonus: this is more friendly to RT kernels

I think the idea is good, but when approaching it that way, 
I am curious about rotation handling.

In the current code, rotation is always done when traversing the plist in the slow path.
If we traverse the plist first, how should rotation be handled?

1. Do a naive rotation at plist traversal time. 
(But then fast path might allocate from an si we didn’t select.)
2. Rotate when allocating in the slow path. 
(But between releasing swap_avail_lock, we might access an si that wasn’t rotated.)

Both cases could break rotation behavior — what do you think?

> too I think). That way we don't need to rewalk the plist after
> releasing the local_lock and save a lot of trouble. I remember I
> discussed with Youngjun on this sometime ago in the mail list, I know

Recapping your earlier idea: cache only the swap device per cgroup in percpu, 
and keep the cluster inside the swap device.
Applied to swap tiers, cache only the percpu si per tier, 
and keep the cluster in the swap device.
This seems to fit well with your previous suggestion.

However, since we shifted from per-cgroup swap priority to swap tier, 
and will re-submit RFC for swap tier, we’ll need to revisit the discussion.

Youngjun Park

