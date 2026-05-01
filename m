Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A81CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 22:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5513C6B00B2; Fri,  1 May 2026 18:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5022A6B00B3; Fri,  1 May 2026 18:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4179E6B00B4; Fri,  1 May 2026 18:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 317A46B00B2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:00:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D1A0C12028E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:00:47 +0000 (UTC)
X-FDA: 84720221334.16.EFD0C69
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5D4794000E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 22:00:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777672846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wwwfe0obH20LpWlVotYjqydnyDPqLti6364XPkAjL3U=;
	b=pwXpl8MbUvdJQS6+bBJqHrIsETgwmY6LsdLuKqf9uF6IshK7Bn5kcHBw2zy8HewrZUYj8B
	YS1QiOjIjPXW2c1rH6MoYclNZeLYpjVqvZnSsUbjZLMsvxAwcaXs8OCaMEx1Q461CrD/sp
	FbfWUaZ8H6/C9+5DVXoEVH0xeTsz4CM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777672846; a=rsa-sha256;
	cv=none;
	b=eOZwXGvltcu45jghmniQ/srArp+EAkWVqqvvNKBzlJJgRfB3q2eUswVVb8mM1OkzXjMOXr
	jce6+67CMiM+I6gDsVeXQ9AcHzg089iDcncjgeHuiItD4UChccukDfUoVakQQbt+uVVSkX
	0MdFMpEG25s+7QZbb610zHinFMBUXe8=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 2 May 2026 07:00:39 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 2 May 2026 07:00:39 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: David Carlier <devnexen@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	charsyam@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH] mm/swap, PM: hibernate: atomically replace hibernation
 pin
Message-ID: <afUih+XwGTHsR0HY@yjaykim-PowerEdge-T330>
References: <20260430195651.287659-1-devnexen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430195651.287659-1-devnexen@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D4794000E
X-Rspamd-Server: rspam06
X-Stat-Signature: pg6zuerh8zru86sz93yhhphdkct1nef3
X-HE-Tag: 1777672843-525274
X-HE-Meta: U2FsdGVkX1/6F/Uc15OY16WdGMaBSoaC4N+9bEuNi0bC6E8O2ob0Z2yStDEAqoQ/XbASyqNxXVNr7O9BSyKAMeW/iAIEPi96tB3JQQOwM/X7bu/Gzr8fj5bZtJ5CSzfjrahbie6sGzEeF1cMawMwO9ZRDLxrNQTFTp6GuKm4MqP2OrHesucRFekIg1Ayz1IMgEzLXpccPdW92pO8lJZA8IXUrjs2i7Sg4a+qBEXSOu9UDFnZ+XanY8Wd/Db4fWHPQYRYDfF4tJIzYXIeUhFg/Ar3j9f31qTaK8y5oBYYzvshZrpKlR4ud6F9h3/KFKAMW04a4NRYkn+tJw5EnIXcJydxuUoEbk1VXLO5mOFZbjr7SMX+ijlpDffHW1zLjLWM/060vRsLPuSCwPguW5xMmfNX9UcD5M5/zRR//dnuzoxOiaEqnliC7Xdn9zgFX5GBcqmoHz0kNNe2KRo6ufg6LMtEzhvDjGE/OocsaYJRDBpZvRwSDv4SdrIidKJ7qlq0kpB1utBv5XxLnCii5hFkMw14geu0u5MsgaPiabRRBshHl9p9ifQLimZ1ah/lCo6tX+I6HISNNsKes9/ZvjGkFeZxb6e6CQYA26tkpq07R7iSCahB84dhqYRKzuV4a4Ie2gXxWY4QA/XatLEBt0Jof0p/g1SXmih4YrmtWzNqFrTdhLPySjT1Rb5sB53ajhKCSDqE72HGVGkROEi4f4ULqijSDb3d4R+gB/6psiX5S+wNwqsnLKO9bhXKAAMSJ/lhGNB6zMxBbamLsSwz3b2zGNQbVTY9TfMOwlRJ8rltsWVe/ovbPqiMJA+JCwBs0WH9bCLzPzwN4MHvHSLmi2N0lgxdChuIPXtwvUUY+b5u/FCJ0C9lGFUvY+mj1nUY6wbDUXY11KlUngQEJJ1at01KYIcO/YzOJtU8ZW066iFmjQ686S9reSxF1lWVCom4h7iFUYjJEW61hQuKfHhY857
 nsMII7f7
 fwtjI+yc2V5z9Pxnnex6dvE3b04L2xF/KBLk2eH06NKDSmknhSE8saHYdQn+vWNSfyArOhl80Jsyczwb+NpVpp7J+jQGi2LYVU6V4WKxri1vpHaVXZl9U5WPEFjHQpahe7wyEc++OPJ84QJfdKczg32mNP1EdIlan404B0MRoqF1lFnL48qsm24a3/W54h1QS+Zg1Hg0iT9MBzakmy9Gq8WdBLy8ess+bda96GlJAMmtQbp7KOMc2Sn0PX+l1jdB3y14AmLdf7o518gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 08:56:51PM +0100, David Carlier wrote:
> snapshot_set_swap_area() unpins the previously selected swap device
> and pins the new one in two separate swap_lock critical sections.
> In the gap between them, swapoff() observes SWP_HIBERNATION cleared,
> bypasses the guard, and tears down the device, reopening the race
> the SWP_HIBERNATION pin was meant to close. The window is reachable
> on any SNAPSHOT_SET_SWAP_AREA call after the snapshot device is
> opened for hibernation, and on any retry after the resume path's
> first selection.
> 
> Add repin_hibernation_swap_type(), which looks up the new device,
> clears the old SWP_HIBERNATION flag and sets the new one under a
> single swap_lock acquisition. The same-device case is short-
> circuited so userspace can re-select the same swap area without
> tripping WARN_ON_ONCE and -EBUSY. Switch snapshot_set_swap_area()
> to the new helper.
> 
> A failed lookup now preserves the previous pin instead of dropping
> it, so a bad SNAPSHOT_SET_SWAP_AREA leaves the prior selection
> intact. The open and release paths keep using
> pin_hibernation_swap_type() and unpin_hibernation_swap_type().
> 
> The race was identified during AI-assisted review of the
> SWP_HIBERNATION pinning series.
> 
> Fixes: 8e6e0d845823 ("mm/swap, PM: hibernate: fix swapoff race in uswsusp by pinning swap device")
> Assisted-by: Codex (gpt-5-codex)
> Signed-off-by: David Carlier <devnexen@gmail.com>
> ---
>  include/linux/swap.h |  2 ++
>  kernel/power/user.c  | 17 ++++--------
>  mm/swapfile.c        | 61 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 68 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 1930f81e6be4..213ecb627a39 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -436,6 +436,8 @@ static inline long get_nr_swap_pages(void)
>  extern void si_swapinfo(struct sysinfo *);
>  extern int pin_hibernation_swap_type(dev_t device, sector_t offset);
>  extern void unpin_hibernation_swap_type(int type);
> +extern int repin_hibernation_swap_type(int old_type, dev_t device,
> +                                       sector_t offset);
>  extern int find_hibernation_swap_type(dev_t device, sector_t offset);
>  int find_first_swap(dev_t *device);
>  extern unsigned int count_swap_pages(int, int);
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index d0fcfba7ac23..6e4f40e49319 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -218,6 +218,7 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
>  {
>  	sector_t offset;
>  	dev_t swdev;
> +	int new_type;
>  
>  	if (swsusp_swap_in_use())
>  		return -EPERM;
> @@ -238,19 +239,11 @@ static int snapshot_set_swap_area(struct snapshot_data *data,
>  		offset = swap_area.offset;
>  	}
>  
> -	/*
> -	 * Unpin the swap device if a swap area was already
> -	 * set by SNAPSHOT_SET_SWAP_AREA.
> -	 */
> -	unpin_hibernation_swap_type(data->swap);
> +	new_type = repin_hibernation_swap_type(data->swap, swdev, offset);
> +	if (new_type < 0)
> +		return new_type;
>  
> -	/*
> -	 * User space encodes device types as two-byte values,
> -	 * so we need to recode them
> -	 */
> -	data->swap = pin_hibernation_swap_type(swdev, offset);
> -	if (data->swap < 0)
> -		return swdev ? -ENODEV : -EINVAL;
> +	data->swap = new_type;
>  	data->dev = swdev;
>  	return 0;
>  }
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c7e173b93e11..4840fd40f36f 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2219,6 +2219,67 @@ int pin_hibernation_swap_type(dev_t device, sector_t offset)
>  	return type;
>  }
>  
> +/**
> + * repin_hibernation_swap_type - Atomically replace the hibernation pin
> + * @old_type: Swap type currently pinned (or < 0 if none).
> + * @device:   Block device of the new resume image.
> + * @offset:   Offset identifying the new swap area.
> + *
> + * Look up the swap device for @device/@offset and atomically transfer
> + * the SWP_HIBERNATION pin from @old_type (if valid) to the new device,
> + * all under a single swap_lock critical section. This closes the
> + * swapoff() window that exists when callers unpin and re-pin in two
> + * separate operations.
> + *
> + * If the new device cannot be located, the existing pin on @old_type
> + * is preserved and an error is returned. If @old_type already refers
> + * to the same swap_info_struct as the new lookup, no flag changes are
> + * made and @old_type is returned.
> + *
> + * Return:
> + * >= 0 on success (new swap type).
> + * -EINVAL if @device is invalid.
> + * -ENODEV if the swap device is not found.
> + * -EBUSY  if the new device is already pinned by another context.
> + */
> +int repin_hibernation_swap_type(int old_type, dev_t device, sector_t offset)
> +{
> +	struct swap_info_struct *old_si, *new_si;
> +	int new_type;
> +
> +	spin_lock(&swap_lock);
> +
> +	new_type = __find_hibernation_swap_type(device, offset);
> +	if (new_type < 0) {
> +		spin_unlock(&swap_lock);
> +		return new_type;
> +	}
> +
> +	new_si = swap_type_to_info(new_type);
> +	if (WARN_ON_ONCE(!new_si)) {
> +		spin_unlock(&swap_lock);
> +		return -ENODEV;
> +	}
> +
> +	old_si = swap_type_to_info(old_type);
> +	if (new_si == old_si) {
> +		spin_unlock(&swap_lock);
> +		return new_type;
> +	}
> +
> +	if (WARN_ON_ONCE(new_si->flags & SWP_HIBERNATION)) {
> +		spin_unlock(&swap_lock);
> +		return -EBUSY;
> +	}
> +
> +	if (old_si)
> +		old_si->flags &= ~SWP_HIBERNATION;
> +	new_si->flags |= SWP_HIBERNATION;
> +
> +	spin_unlock(&swap_lock);
> +	return new_type;
> +}
> +
>  /**
>   * unpin_hibernation_swap_type - Unpin the swap device for hibernation
>   * @type: Swap type previously returned by pin_hibernation_swap_type()
> -- 
> 2.53.0

I also caught up on this thread late due to travel.
Sorry.

Hello David Carlier,

It looks like the same issue and approach was raised previously:
https://lore.kernel.org/all/20260414143200.1267932-1-charsyam@gmail.com/#t
(+CC DaeMyung)

I had suggested improving the fix by reusing the existing APIs
rather than adding a new one. v2 was posted along those lines:
https://lore.kernel.org/all/20260414164937.1363887-1-charsyam@gmail.com/

To restate the points from that earlier review.

1. I think it is acceptable to release the existing pin when the
   new set operation fails. there is no significant side effect
   (see the earlier review for details).

2. If we still want to fix it, reusing the existing APIs seems
   preferable to adding a new one.

Chris, Andrew - please take the prior thread into account during review. 

Thanks,
Youngjun Park

