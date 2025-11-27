Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ECA2D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 09:34:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE9C6B0022; Thu, 27 Nov 2025 04:34:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD5EA6B0023; Thu, 27 Nov 2025 04:34:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4D66B0024; Thu, 27 Nov 2025 04:34:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8C526B0022
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 04:34:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4141CC0942
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:34:16 +0000 (UTC)
X-FDA: 84155876112.06.AAB2CAD
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf08.hostedemail.com (Postfix) with ESMTP id D815116000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 09:34:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764236054; a=rsa-sha256;
	cv=none;
	b=zH2IbOfdbtFRja1+qHdh6Wb9LyRPt6vyE0HuT+BxOZjXpjZT3h/YRE2Rw9wPCg5bGfvkX5
	ezAXK9jkxNnL1DRE8AMvXhPhnkbEfpu8dixttW6eFZEfhxApCDA7MBCNuVDBnNLgzo8NFU
	JTWhfu5jRGzxualpcKhJsLa7lRizv9k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764236054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jmjQVq/TFIzWjnSW6Mwr5wDkIPfK8qAij87eSbdoJw=;
	b=gDtyqGIM2KoWVW/RT5a3kEURCE8+4aZxjN8LF/kvEYg69V/URNBvycDi8em+xZU4E67Pjf
	SoSMdPRprqo56cOBkGq+W7lH6vqUME4uQpMCzl2/PTwZoDMZCmLcIGKc9PyuvZt17D6Lh9
	pjpOGBVP+cwCIF/K1Io/2f7YwfGQG8A=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 27 Nov 2025 18:34:09 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 27 Nov 2025 18:34:09 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <bhe@redhat.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSgbEQCWZaSUvO9S@yjaykim-PowerEdge-T330>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
 <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
 <aSgGoLLOQgFCrsMu@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aSgGoLLOQgFCrsMu@MiWiFi-R3L-srv>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D815116000E
X-Stat-Signature: p9ww3qmiqgrmujigfpk6p49o7cwqpsyc
X-Rspam-User: 
X-HE-Tag: 1764236052-744033
X-HE-Meta: U2FsdGVkX1/zeW/5bCYgzT3512eiLequ/bcxbzt9lZYP7VUMf+gB7/o4jXHqMJ8F73EVKSxxLPZfw1vsidNWLWQcF2j92AdSya5crjWl+KwdGNkLQr4cBwpE/8+vRbE1O62zKkefcGEWgURIi0MuWjRjXKTVf3FXKeav726xX8xhdpfceJwqhw2G/er4oKt/TDdM0Cojc12CAOPjDGiDRqJVvotljP0dkeEUuNtt0IKY+JIxORuJrNsa03ihusBUfv7Ebr7gb092oZkLwzWoE2NpxGdncNGN99lmqbTLnGnB1XTD7bLMGgeTp0OFZG5aKDlaJI0bm/+iCd/+k7CpyZky6zj2aOxsxHXm85LQx9WtXZTHmQWQDQKb3RVNcMU+2Hr3wxnZT62A2wjJlN1bQeli50mq27OxkEM/WVGvXBpbEaQ5I8tXfQ20HnhFONRr+uLLsr/30T11sUo7pA1moEfpgfexjvx4zFdhmEIstNJ4cO6ZflX19zKandTz2MUUa/FP2g+njLvj6XRN+K37ritZLXYeAIg1YeAPgo6FGqWfPwl8xQKXkFNlubgkIYGSfahigCUXhGhScWJwtITotsvsmGP+0UK0l+c8IXcN5/nZqLO7I7Owd6eBG8K8FGOYrErVEtNXjFrsbhwx8ywIwNYBYo2Uos3XTGyzWhqtuAmuSutWqBeJ7FXfL8k/EeCYAPpcxwpFANNZrC0Nz3R2YA8XSrhtbOafYhXFAzediY4Svo+O9vbWoU6aa1Oqt3EAQ39KU3LAVL01icYNs0DPuVm7Z04oRDPkAaeg1NXbJq58+eyMWI94q7xXggyziI4npwuP735Z77Gw2xhiizYDy2wqR08EQ8pbb7glUEcYA7m8Ed+edWY4RL52yMqMXegdTEZGfmFkIurSfM13f0yp/OCKcgUZPn8zBBLyzeYYFOTH2s92BwNC3cZAPv6vN6og6ArSlNQ6M1uFDF9JWEk
 7IHkDk2d
 2n0kOwaj3GX53cx45GzVhFqerbUJ50Ee+tGm6biMonLT/XGtmQDLm0rHWTGc6zxFd2+b8yfvVVV88QQ/Qh524MZa/kLv6xenSyr4zhGoqcvxq1P8q7KFvWghnaAZQtTkQB764uw9g5MjLId9h5Z83/KqqwUnP78kxTqCxZWPKEtFbkIU0c+ikjMngMVnDI7o7DYqSD9tlpU7C8kw5rpp9bUyEkW7VrqsKNCCW+ZbClcw/cJ+DApWzjSX/rfelFXPVhndtYEV49MSJk8ITQkrcNqliAk3tOOL3HPZAqqn5SjS5bbaPtMgfq4FKpljtaqFHEMX6OUh5BB0mX18=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 27, 2025 at 04:06:56PM +0800, Baoquan He wrote:
> On 11/27/25 at 02:42pm, YoungJun Park wrote:
> > On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> > > On 11/26/25 at 01:30am, Youngjun Park wrote:
> > > > swap_sync_discard() has an issue where if the next device becomes full
> > > > and is removed from the plist during iteration, the operation fails
> > > > even when other swap devices with pending discard entries remain
> > > > available.
> > > > 
> > > > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > > > when the next node is removed during discard operations.
> > > > 
> > > > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > > > swap_active_head. This means the iteration is only affected by swapoff
> > > > operations rather than frequent availability changes, reducing
> > > > exceptional condition checks and lock contention.
> > > > 
> > > > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > > ---
> > > >  mm/swapfile.c | 18 +++++++++++-------
> > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index d12332423a06..998271aa09c3 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> > > >  	bool ret = false;
> > > >  	struct swap_info_struct *si, *next;
> > > >  
> > > > -	spin_lock(&swap_avail_lock);
> > > > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > > > -		spin_unlock(&swap_avail_lock);
> > > > +	spin_lock(&swap_lock);
> > > > +start_over:
> > > > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > > > +		spin_unlock(&swap_lock);
> > > >  		if (get_swap_device_info(si)) {
> > > >  			if (si->flags & SWP_PAGE_DISCARD)
> > > >  				ret = swap_do_scheduled_discard(si);
> > > >  			put_swap_device(si);
> > > >  		}
> > > >  		if (ret)
> > > > -			return true;
> > > > -		spin_lock(&swap_avail_lock);
> > > > +			return ret;
> > > > +
> > > > +		spin_lock(&swap_lock);
> > > > +		if (plist_node_empty(&next->list))
> > > > +			goto start_over;
> > 
> > By forcing a brief delay right before the swap_lock, I was able to observe at
> > runtime that when the next node is removed (due to swapoff), and there is no
> > plist_node_empty check, plist_del makes the node point to itself. As a result,
> > when the iteration continues to the next entry, it keeps retrying on itself,
> > since the list traversal termination condition is based on whether the current
> > node is the head or not.
> > 
> > At first glance, I had assumed that plist_node_empty also implicitly served as
> > a termination condition of plist_for_each_entry_safe.
> > 
> > Therefore, the real reason for this patch is not:
> >     "swap_sync_discard() has an issue where if the next device becomes full
> >     and is removed from the plist during iteration, the operation fails even
> >     when other swap devices with pending discard entries remain available."
> > but rather:
> >     "When the next node is removed, the next pointer loops back to the current
> >     entry, possibly causing an loop until it will be reinserted on the list."
> > 
> > So, the plist_node_empty check is necessary — either as it is now (not the original
> > code, the patch I modified) or as a break condition 
> > (if we want to avoid the swap on/off loop situation I mentioned in my previous email.)
> 
> OK, I only thought of swap on/off case, didn't think much. As you
> analyzed, the plist_node_empty check is necessary. So this patch looks
> good to me. Or one alternative way is fetching the new next? Not strong
> opinion though.
> 
>                 if (plist_node_empty(&next->list)) {
>                         if (!plist_node_empty(&si->list)) {
>                                 next = list_next_entry(si, list.node_list);
>                                 continue;
>                         }
>                         return false;
>                 }

Thank you for the suggestion :D
I agree it could be an improvement in some cases.
Personally, I feel the current code works fine, 
and from a readability perspective, the current approach might be a bit clearer.
It also seems that the alternative would only make a difference in very minor cases.
(order 0, swapfail and swapoff during on this routine)

Youngjun Park

