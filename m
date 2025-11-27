Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 112BCD11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546046B0027; Thu, 27 Nov 2025 05:50:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E276B0028; Thu, 27 Nov 2025 05:50:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45AFD6B0029; Thu, 27 Nov 2025 05:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35F8C6B0027
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:50:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D8746131CA0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:50:19 +0000 (UTC)
X-FDA: 84156067758.06.01FA848
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5382120003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:50:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f41hYMit;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764240617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qdcSqmaw8UInSRy2nsVACy/wHj1y2eMOITdLsJ3Tdzw=;
	b=mDomCVMJwJ6OYcsCmi1P5Qshm3WM6yVVCu+JcIbWayC1RZrA0yMER52iqBTqr8EZkchm7y
	NHoge0do+6Jun8DJEG+dS63BtktDXTENsgKCs/86wnyqJQCPvey/FfhQnoymEMrrRCPHS1
	LFklvwHUUN03E1zpTWcWQClGECVrmf0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f41hYMit;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf29.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764240617; a=rsa-sha256;
	cv=none;
	b=IeKCOqd65jfmXejI6WhdyCu/C1IfWGOrGziqzTuRSscA2aCLCYWc+CkG9sdhTjhM8Gj25O
	hwgvK+V4JO5uBY7hM97+PojPTRpX2KlSm4BZ2uqbaqmPqyj3AGAyUjicZD0QHhu9sxcszm
	ZLhglML0isjG8YNREgFXvVGaI7oxIJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764240617;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qdcSqmaw8UInSRy2nsVACy/wHj1y2eMOITdLsJ3Tdzw=;
	b=f41hYMits0Tv+z2K9ikXfl7gkBuLwf+KuPu2e0ivRKlqFdkTQJGMvIl4DY+cI3+Wtc9DLo
	Vdy15/Sb6b2JNLZgmA2+gy5G8npSowqzziVfvKLjY8FmurmkfZh6pEZsCvL7L6PBir5XfA
	v0XjQEsagF78dDovcptrRgUYP2nF3mI=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-wGlzJ6s_MbiegRvA-e1WFA-1; Thu,
 27 Nov 2025 05:50:11 -0500
X-MC-Unique: wGlzJ6s_MbiegRvA-e1WFA-1
X-Mimecast-MFC-AGG-ID: wGlzJ6s_MbiegRvA-e1WFA_1764240610
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54493195608D;
	Thu, 27 Nov 2025 10:50:09 +0000 (UTC)
Received: from localhost (unknown [10.72.112.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AB5A01956095;
	Thu, 27 Nov 2025 10:50:07 +0000 (UTC)
Date: Thu, 27 Nov 2025 18:50:03 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSgs2y3b/DhsMMHD@MiWiFi-R3L-srv>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
 <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
 <aSgGoLLOQgFCrsMu@MiWiFi-R3L-srv>
 <aSgbEQCWZaSUvO9S@yjaykim-PowerEdge-T330>
 <aSgo1Xjc+WWEIQwH@MiWiFi-R3L-srv>
 <aSgrdLkaLjzVh6kv@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aSgrdLkaLjzVh6kv@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iA4lEnkcw6IHx0deAr0c4gEbFdU0vPyI-0iLqofO5Ng_1764240610
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B5382120003
X-Rspamd-Server: rspam11
X-Stat-Signature: 8h3jctt3nfd6yp5u44s4te6xppy8ug4j
X-HE-Tag: 1764240617-769941
X-HE-Meta: U2FsdGVkX1+PIu4CQgB+uof7gUcb6hPpN61BdlNJPPBtgeruKCczwlC4Eqg6EQ1Q7EbcjAUps421ONLci/0ACYfeOm3Il9v9JZKsFrSw+FXSw0b5fOO1Sg/3dVt+hqf9TA3gI8JrJM8Hd3MjJZYeCircsVlpMab0w+q8lNzfpajLzKcgCwvVel5srH3nFKYmbEbaBP93bQ5yRN/XKSdasZYGBITSdsv/X27aRzs1uF8hSZry7Oxfykhym/aM09nDR3J/JndeXJv7oV5Yt4YWELubrUA0sL1rSG+vzAgzo2XVymK/xSVBysSw8AngHesqN9Jz493IGcdHTzUnzX4csA3kDJTjlzog4aC67Qqe3VgipnR8d0x3nYLHA9o9i+sTLxjQYQBLlupzCXU/Ai1fmiHIg6uyQcrjqaFs6pilirOISKAXh9r6BlF7QgDtJIFLp7yBjQWUga4usR1H/6DxteI1Ti01siU8vS045fwFLFUKCSE+088Ui1Zh1tu5IdgcrzSFP3FxyyJb9rYvp7XsO45GoBO6fbbrD5nA7/h2gnhbvzsvryayPrYgdqv/OmvASo8GIFs67sQ4kU9SsmykyJAFteYockwzpflX336mglqGTbfQFEYC8X5wAqwN4APtUHJYiajGiyqN2oRe1Xqx8t87AQCVgOTD0Og7F9GNO5Fi7aQ52zpqZEn2G0sF8S0h6mQvB21/MNUY+AEiaTi66hTjXMia9bIsvrx3q+ldwmg4p06RDYsW4wJL8BkkmxJJR+69JzPbKnfvf2IIm5Uf3bBsPdmlLI5xYk2fh88xuJaKci1w1qkIKRON+gMGMlH/OQzOaXPvxkJAucCSVau3u17JGK+iXIMBBxOp96Rkd86RJPuujw035r1b58Uls+d//Kac9hcoO3NuRLMqNZ2tRL96/bPP98Dge60qKsMRtR3kZE91L7GdEUe6ZCadKOpCXDHke4RDcJ4Vk2jB+Tg
 JipwI1u6
 C/u3feC5FGUjG06e6KuUSqKTKKI/nEFzEsWfW20Gbocuyndiag8/6/DY9zPnTqCOygsdkV85/1r3rVM5PIwtfSQcG6CG+gKBEczCRfJ+kgn0hy8fmR2HTquZW6FvXwRxAQwSb1upgnDyzlYjKpJ3U7kyQHYdbIfsjHJ7dYqfewOjAYYarpeQYoLbMEVI++DhSdpximH6alEoR+JeiTXYLgH2+1VokQcnYog/aMSR+i5sFXz+SM/1gXXsR6xznHrz38knJ4dpGMhWHnt2bn+FoeIwcDkmdvUylXfVXTi3tGE0GzSD4VK4SfFTKzVLJIhHDGdNsF/lwok1a/OS4A5uDom6Fd1qogDWVzYOOGNHoXfW6lSDIZUFf4UTRi4kcbvKjoBdtCMEh802ny3/JgirVsJvNM8YM4+WU7a46X0Wt/7h03UjTcljZXPyadxDx5Z47Sh+QjHNlPmAiLuMbPV7AIsud/cB/dU2C9vmo1mMgl3xTdLr1kEq/Q7eHflBV4CdwmwsnjNkzB5Z0M8QlYIgqEnB8Wp1AnNh86NetRbEX3OzueIIEnagEpbW8kgnfUagNzQwGuzhWj/YtcNO0xhsnFVX5wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 at 07:44pm, YoungJun Park wrote:
> On Thu, Nov 27, 2025 at 06:32:53PM +0800, Baoquan He wrote:
> > On 11/27/25 at 06:34pm, YoungJun Park wrote:
> > > On Thu, Nov 27, 2025 at 04:06:56PM +0800, Baoquan He wrote:
> > > > On 11/27/25 at 02:42pm, YoungJun Park wrote:
> > > > > On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> > > > > > On 11/26/25 at 01:30am, Youngjun Park wrote:
> > > > > > > swap_sync_discard() has an issue where if the next device becomes full
> > > > > > > and is removed from the plist during iteration, the operation fails
> > > > > > > even when other swap devices with pending discard entries remain
> > > > > > > available.
> > > > > > > 
> > > > > > > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > > > > > > when the next node is removed during discard operations.
> > > > > > > 
> > > > > > > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > > > > > > swap_active_head. This means the iteration is only affected by swapoff
> > > > > > > operations rather than frequent availability changes, reducing
> > > > > > > exceptional condition checks and lock contention.
> > > > > > > 
> > > > > > > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > > > > > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > > > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > > > > > ---
> > > > > > >  mm/swapfile.c | 18 +++++++++++-------
> > > > > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > > > index d12332423a06..998271aa09c3 100644
> > > > > > > --- a/mm/swapfile.c
> > > > > > > +++ b/mm/swapfile.c
> > > > > > > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> > > > > > >  	bool ret = false;
> > > > > > >  	struct swap_info_struct *si, *next;
> > > > > > >  
> > > > > > > -	spin_lock(&swap_avail_lock);
> > > > > > > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > > > > > > -		spin_unlock(&swap_avail_lock);
> > > > > > > +	spin_lock(&swap_lock);
> > > > > > > +start_over:
> > > > > > > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > > > > > > +		spin_unlock(&swap_lock);
> > > > > > >  		if (get_swap_device_info(si)) {
> > > > > > >  			if (si->flags & SWP_PAGE_DISCARD)
> > > > > > >  				ret = swap_do_scheduled_discard(si);
> > > > > > >  			put_swap_device(si);
> > > > > > >  		}
> > > > > > >  		if (ret)
> > > > > > > -			return true;
> > > > > > > -		spin_lock(&swap_avail_lock);
> > > > > > > +			return ret;
> > > > > > > +
> > > > > > > +		spin_lock(&swap_lock);
> > > > > > > +		if (plist_node_empty(&next->list))
> > > > > > > +			goto start_over;
> > > > > 
> > > > > By forcing a brief delay right before the swap_lock, I was able to observe at
> > > > > runtime that when the next node is removed (due to swapoff), and there is no
> > > > > plist_node_empty check, plist_del makes the node point to itself. As a result,
> > > > > when the iteration continues to the next entry, it keeps retrying on itself,
> > > > > since the list traversal termination condition is based on whether the current
> > > > > node is the head or not.
> > > > > 
> > > > > At first glance, I had assumed that plist_node_empty also implicitly served as
> > > > > a termination condition of plist_for_each_entry_safe.
> > > > > 
> > > > > Therefore, the real reason for this patch is not:
> > > > >     "swap_sync_discard() has an issue where if the next device becomes full
> > > > >     and is removed from the plist during iteration, the operation fails even
> > > > >     when other swap devices with pending discard entries remain available."
> > > > > but rather:
> > > > >     "When the next node is removed, the next pointer loops back to the current
> > > > >     entry, possibly causing an loop until it will be reinserted on the list."
> > > > > 
> > > > > So, the plist_node_empty check is necessary — either as it is now (not the original
> > > > > code, the patch I modified) or as a break condition 
> > > > > (if we want to avoid the swap on/off loop situation I mentioned in my previous email.)
> > > > 
> > > > OK, I only thought of swap on/off case, didn't think much. As you
> > > > analyzed, the plist_node_empty check is necessary. So this patch looks
> > > > good to me. Or one alternative way is fetching the new next? Not strong
> > > > opinion though.
> > > > 
> > > >                 if (plist_node_empty(&next->list)) {
> > > >                         if (!plist_node_empty(&si->list)) {
> > > >                                 next = list_next_entry(si, list.node_list);
> > > >                                 continue;
> > > >                         }
> > > >                         return false;
> > > >                 }
> > > 
> > > Thank you for the suggestion :D
> > > I agree it could be an improvement in some cases.
> > > Personally, I feel the current code works fine, 
> > > and from a readability perspective, the current approach might be a bit clearer.
> > > It also seems that the alternative would only make a difference in very minor cases.
> > > (order 0, swapfail and swapoff during on this routine)
> > 
> > Agree. Will you post v2 to update the patch log? I would like to add my
> > reviewing tag if no v2 is planned.
> 
> Oops, I’ve just posted v2 to update the patch log.
> Link: https://lore.kernel.org/linux-mm/20251127100303.783198-1-youngjun.park@lge.com/T/#m920503bf9bac0d35bd2c8467a926481e58d7ab53

Saw it, thanks.


