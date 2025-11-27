Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A7A2CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F836B0027; Thu, 27 Nov 2025 05:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847306B0028; Thu, 27 Nov 2025 05:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7845F6B0029; Thu, 27 Nov 2025 05:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 629A56B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:44:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5231160A50
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:44:11 +0000 (UTC)
X-FDA: 84156052302.27.D2F3FDB
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8AD0F160005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:44:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764240250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JEGHMCHPmpQHUWZ2mQlhZMkjnnUBtYaNvSEZUTt61XU=;
	b=8cny8NyBsCfF3utLN5Tm7b7U6sRNLQ9QUSZyG6/4qMC2zQLADJeOq8xfpvWdGP7hHdGAb2
	De+XGNpFDKuXM7+/r94eqmIWRql37e1tQTbqt71fOGSJ0SVqfuc2K6BtFDHox1U8CM/VLt
	HxLrHadmWND88qfkjwDN+vga5H8dNXA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764240250; a=rsa-sha256;
	cv=none;
	b=Z7wkSGU7b7BZuvgOQWEYQrq9DCy/hNuwwDbKJNjZ7Vwc68t632zzuDjV5UEyiDFbDNR5r/
	K8HiHrwUf2HdgBYlKbCnS2FuZ56rGIgOVLbOeFkQLYF0g3i3Hf8LbGK+3McZ+0CqbSuvGq
	cEU280d2kEJ86+dpiDLYNE619yIGU+4=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 27 Nov 2025 19:44:04 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 27 Nov 2025 19:44:04 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSgrdLkaLjzVh6kv@yjaykim-PowerEdge-T330>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
 <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
 <aSgGoLLOQgFCrsMu@MiWiFi-R3L-srv>
 <aSgbEQCWZaSUvO9S@yjaykim-PowerEdge-T330>
 <aSgo1Xjc+WWEIQwH@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSgo1Xjc+WWEIQwH@MiWiFi-R3L-srv>
X-Stat-Signature: hxr1smrbk8sh78d34zxsgj6s9rooomtk
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AD0F160005
X-Rspamd-Server: rspam09
X-HE-Tag: 1764240248-334010
X-HE-Meta: U2FsdGVkX180IGo80zxClVaAlf31ZoiiIyuFQVOQpgeRXuWxDH+uqv+6tMXOep/gRxvDoc+H6tyHq8Sl4vR/LnnoUowFvjxZ+4aSrzUO9VUJEIigWaVqLRu45QxdT0DkWZGt08Pu/bh6yDGEj42fGwUMq+x0EqY/DParxP67mkDukgf4suQUPjbYZDFuepMboEkPRXU3XCdqZbL/hlU0shkRmiRQe7SMYWhLVF1W97wP9lBaxz+0U33DjtHajMCYd/joUsjvmhA2GRmKdiNaEAf8jTtWm7r/sl4aeZRxh7Y7R7ywU0qzfM6rCJar0lHadwFEkK7r2luzxJef7QNTQko5o7tGmuOb644sOVCRof3tkjC9J6nYN/OIPndTXbj9RliNye1Z/WQMAESJPubv6hTkLquTVBStWU1Gzd7XWSXx76OvOEc8Xi5lAIl4qw1h10pas4+U3z9FygdrFgoXPR7yZolUvvppQTuLIWcwe+IFwnF0QdoqvmcFJV5SLoD8Kj95jMLefHslaNxHLOxdQGuY9jj23KEer7t6Lbc2n9k/numeu96SIUVQjzfROFnu5C5M5SEhMnWsbSPSnJ9hS23ieiolKsNLr9hLRvF88U3HbQrmpB+ap/0lVEnB3SjF1OO2gHOsG3X7XHyvuF07mlQuElhKeBk/BhwimiM9HFdq5Xs5bc+nMaTbta35+kysef6WkQKHViV9yLJ4/n8/ePok9zq4dX2YHcqSAV8Z5gRJmVGkINzydDNZkC1EFXZWTPx4iy4KxuUGx4NI15Y371nHsdmVQePHpqEWr4c0hvPCMSckVNMzL1w7H4x91zEYzrr2XjIF5EVa0SxKtvbqT1x4xiGJLWiKMLLSgR8cI/rVuv8qZNGIDW1QxnQVJ52y1frezPJFSzkQen0+AHk1DESTMxVFIzcfcfET88rAd7lsKqmpPTE+LeO5u/NWShLHUUDO3agcKjAX6ooM062
 wH6N5jyE
 /8dwswVdFo/E4oh6/R/e1qDKD3WzdBdKUBC0Y3dulGCXLBG6MOQrC6ghu/rF64LoLyBh16yAKIFwNC2WDBiQXjPSFumolD/F6zvg9AhgcuwRIFJPNLp4/xRNBiaXT6PvBXYv+C/KwLWX9/a73YufhoquqgjEMsZquSXU2gcibODmzlHDSrc8ODz2f0Mnn9apbiz0YXiAL8nh+Hp10WLtDLDQtJ9/OD/Zoq2qo73mD4VDuIHMpn7NlR/CVnoWQN1cOODSVa71GV80fnbpRBJKZrSQj0XcYeChReD4W+waIYq9fXybEgcya2FbQRyaYDmg6d6vgf6l6OCKhURSUudo4aD4xcjNTAQxEci5gySJzfJqBVgQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 06:32:53PM +0800, Baoquan He wrote:
> On 11/27/25 at 06:34pm, YoungJun Park wrote:
> > On Thu, Nov 27, 2025 at 04:06:56PM +0800, Baoquan He wrote:
> > > On 11/27/25 at 02:42pm, YoungJun Park wrote:
> > > > On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> > > > > On 11/26/25 at 01:30am, Youngjun Park wrote:
> > > > > > swap_sync_discard() has an issue where if the next device becomes full
> > > > > > and is removed from the plist during iteration, the operation fails
> > > > > > even when other swap devices with pending discard entries remain
> > > > > > available.
> > > > > > 
> > > > > > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > > > > > when the next node is removed during discard operations.
> > > > > > 
> > > > > > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > > > > > swap_active_head. This means the iteration is only affected by swapoff
> > > > > > operations rather than frequent availability changes, reducing
> > > > > > exceptional condition checks and lock contention.
> > > > > > 
> > > > > > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > > > > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > > > > ---
> > > > > >  mm/swapfile.c | 18 +++++++++++-------
> > > > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > > > 
> > > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > > index d12332423a06..998271aa09c3 100644
> > > > > > --- a/mm/swapfile.c
> > > > > > +++ b/mm/swapfile.c
> > > > > > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> > > > > >  	bool ret = false;
> > > > > >  	struct swap_info_struct *si, *next;
> > > > > >  
> > > > > > -	spin_lock(&swap_avail_lock);
> > > > > > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > > > > > -		spin_unlock(&swap_avail_lock);
> > > > > > +	spin_lock(&swap_lock);
> > > > > > +start_over:
> > > > > > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > > > > > +		spin_unlock(&swap_lock);
> > > > > >  		if (get_swap_device_info(si)) {
> > > > > >  			if (si->flags & SWP_PAGE_DISCARD)
> > > > > >  				ret = swap_do_scheduled_discard(si);
> > > > > >  			put_swap_device(si);
> > > > > >  		}
> > > > > >  		if (ret)
> > > > > > -			return true;
> > > > > > -		spin_lock(&swap_avail_lock);
> > > > > > +			return ret;
> > > > > > +
> > > > > > +		spin_lock(&swap_lock);
> > > > > > +		if (plist_node_empty(&next->list))
> > > > > > +			goto start_over;
> > > > 
> > > > By forcing a brief delay right before the swap_lock, I was able to observe at
> > > > runtime that when the next node is removed (due to swapoff), and there is no
> > > > plist_node_empty check, plist_del makes the node point to itself. As a result,
> > > > when the iteration continues to the next entry, it keeps retrying on itself,
> > > > since the list traversal termination condition is based on whether the current
> > > > node is the head or not.
> > > > 
> > > > At first glance, I had assumed that plist_node_empty also implicitly served as
> > > > a termination condition of plist_for_each_entry_safe.
> > > > 
> > > > Therefore, the real reason for this patch is not:
> > > >     "swap_sync_discard() has an issue where if the next device becomes full
> > > >     and is removed from the plist during iteration, the operation fails even
> > > >     when other swap devices with pending discard entries remain available."
> > > > but rather:
> > > >     "When the next node is removed, the next pointer loops back to the current
> > > >     entry, possibly causing an loop until it will be reinserted on the list."
> > > > 
> > > > So, the plist_node_empty check is necessary — either as it is now (not the original
> > > > code, the patch I modified) or as a break condition 
> > > > (if we want to avoid the swap on/off loop situation I mentioned in my previous email.)
> > > 
> > > OK, I only thought of swap on/off case, didn't think much. As you
> > > analyzed, the plist_node_empty check is necessary. So this patch looks
> > > good to me. Or one alternative way is fetching the new next? Not strong
> > > opinion though.
> > > 
> > >                 if (plist_node_empty(&next->list)) {
> > >                         if (!plist_node_empty(&si->list)) {
> > >                                 next = list_next_entry(si, list.node_list);
> > >                                 continue;
> > >                         }
> > >                         return false;
> > >                 }
> > 
> > Thank you for the suggestion :D
> > I agree it could be an improvement in some cases.
> > Personally, I feel the current code works fine, 
> > and from a readability perspective, the current approach might be a bit clearer.
> > It also seems that the alternative would only make a difference in very minor cases.
> > (order 0, swapfail and swapoff during on this routine)
> 
> Agree. Will you post v2 to update the patch log? I would like to add my
> reviewing tag if no v2 is planned.

Oops, I’ve just posted v2 to update the patch log.
Link: https://lore.kernel.org/linux-mm/20251127100303.783198-1-youngjun.park@lge.com/T/#m920503bf9bac0d35bd2c8467a926481e58d7ab53

