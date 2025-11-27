Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC31CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 10:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4649B6B0023; Thu, 27 Nov 2025 05:33:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDDE6B0026; Thu, 27 Nov 2025 05:33:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E5F6B0027; Thu, 27 Nov 2025 05:33:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 136806B0023
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:33:08 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1221160A44
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:33:07 +0000 (UTC)
X-FDA: 84156024414.15.1CDC37F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8E89940003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 10:33:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YDx0BW//";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764239585; a=rsa-sha256;
	cv=none;
	b=7c7ylI0Bu8dkyzhD/gvXmErFnvt4gsxI/31BC7+yvM8hef+5fKERIv5FkGTfd2e5+wUt0b
	tN+aS/4Cg5QmtJ8mvoskBIEgmzYEiPyyQTPtFheE7Q0OsZalyP/HAJyk1a7iKC5C0MKooH
	Senu3MVpOxEDBeLRMFR47EV8OjtoC7k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="YDx0BW//";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764239585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MXFfhQs7mxMJIEFBG/HEl1H8TpF5l6jUE4M4FcTLd+I=;
	b=z2aKWssEFEpf5SrUOrvnFVlg26ajZaPgM/UNwHEyU8Y1mE2HFk/NdqmtP3SJ3WBOwvYaJX
	9AipvK7pFcZYjy454YKNS7l+j2MmA685VIw/rQaXnLJzurh1FvT6ZP4acY/uDT05dIXGR1
	Qc1WPOFRf4UlGwCIBvxsRnSdkklyeN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764239584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MXFfhQs7mxMJIEFBG/HEl1H8TpF5l6jUE4M4FcTLd+I=;
	b=YDx0BW//6GGpu2UZ32dKfV3MOvrzrF6NJqvz8MWdLRswa/IgO960ZvWFOamp9KxzYgy7bn
	XwiIQdxDWXr1sBmTKQ8OT+go9k5eZeyhDKT1Dd+0B+CnJ113/T7HqHx45+z1LovgMK4yc+
	tL8neTxwXNKpSSWwPNDjwuVyFykyYFk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-IlQ6mVIEP-GKH_3ZCnPi8g-1; Thu,
 27 Nov 2025 05:33:01 -0500
X-MC-Unique: IlQ6mVIEP-GKH_3ZCnPi8g-1
X-Mimecast-MFC-AGG-ID: IlQ6mVIEP-GKH_3ZCnPi8g_1764239580
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E31018001D1;
	Thu, 27 Nov 2025 10:32:59 +0000 (UTC)
Received: from localhost (unknown [10.72.112.107])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9E37119560B0;
	Thu, 27 Nov 2025 10:32:57 +0000 (UTC)
Date: Thu, 27 Nov 2025 18:32:53 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSgo1Xjc+WWEIQwH@MiWiFi-R3L-srv>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
 <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
 <aSgGoLLOQgFCrsMu@MiWiFi-R3L-srv>
 <aSgbEQCWZaSUvO9S@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aSgbEQCWZaSUvO9S@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jf2ibp4SNzDVvZCjdPhxe2Rgrn-5dwOt1wIw6OQmBJU_1764239580
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8E89940003
X-Stat-Signature: 6wg7cei9tn8q8oqa6s3gefc9a4f1ohw1
X-Rspam-User: 
X-HE-Tag: 1764239585-845294
X-HE-Meta: U2FsdGVkX198tb1UrO3ibuHujoHjs2/jWwvojFuBEwFzqmfvjDOmSQyskBsxs+VhaSfk/2sAqwi+RsWwUVvqyjbxgiqogqDbJlZq/isb7gowBR4DYMrO56ThEQFIO6CBOEnyTeoqflW2VG7qQGD6pzjeVqR8z2bulGV+npZ0Q2b9rmZh9LB7cRdaa1lv/1ee201/O5rqkTtySK1zdSHHbOYWcSSNQp0UVPzMEOiK7OwXDsp2ncLLzvuipwu9Xp9J9+obp6t+yqXOyw9APHSK8y1MYCAiYWEDeCOrKtDI3gKieuusAxynp1U60tkdHaygJtsEq5nEpUZpWT/ISHvwsVobAsPuBvntsgCiXy1fZ8+/Mrw75RRW0kMV+Kj951eg7ncVq3FYI/glyyrXDgMYdRQ3rtDpmawJ+y43TCMOSZXVOlagc6h0TLm6N69uk5GYaKxztFhBBgqIAxF9eqo9RbkPjKFt7E8bp6iyM5auOVjSJ6XG5kGvtus/FGq1AqwqtNHwwA9LqtLpmwuhry4fA6OMx5U1oB5AtluYTbxX3I2EJwfGuodEvP1kYWLq9Ts3fKZjLUJIUQTnBwJziYDaDGNUFgilHpRGFYrZizcxMO/aM1+ivrOBdPo/AVCJUrOtCqkg/VinuQcRBBAXU+kRJlSI8XJAjp7FcQZVuUKQGQMZ3xrgUvi0g+y248wf18KSteRxuO+rULcsVe65mCa3vmIOE+KpuRD5YKblSHx2PGTmCwGUB0nGhG0E8a4DyQDG09IjpteiRP/vIhrmJgIOZ9lcLHEZ2F1237XcjXNEypg9OUQ/XqN5SGBV8zxnfQhmJ25ieo9688M9+r7/qGO8LPMqBMmrTLFjjsGGvRLocufr6VZDlB7b4DzzvsAdtm6yrJpvyKf/637if5hk9RmfWjtrqwqJFbGw7m05GByV63ZrSRsN6yFyzBm0YmJOZDOf40FFpBk6MllSRUxTiM8
 MtVW6dRi
 EKLFxG9P8RaIkEvv07e2+BZFdawW0OyoNZJ5U3VEgy8WJGv9uYM6GnHM0+Nd3InkllqYHLuCpQjrPMnR8aQwuAxTUMSolnCeqlVL4SKp5Jsoqn1inQbhDubSFMmiTuNRCe/6oDltKAYELeIVKbehBoKquwgkaOIw+F8UZ/2O47v3PlagbBkbeOhtYt9wKeejjLmXaVyr9tfcqmxoBz8Rx5Sr6mdWijSIwqSqc66f+1pDsJjwRVDpjIibgD1MAa9VunhYwIc+Z4riRfejZBlzqaMSZteW78Ktauv7rEnC3yTMs1kBow7xnHgJFc1rJEW2BzLrid7B4EL+9h2x+egYDHoUsiTWrtD8o4jj0mzCSSySYP7/2qODl8pReSxTEXTMgCRtiR10m4o9N+taQ7CEyYUbba+yMiuAVUNUK3Tm4w6fqtwDsxQSUYIXPDHPKcj2biRkyeSJbiQ3vanHj6h6UpoavOyoo7RY+3c98OYNEfqDfxenzklKT5NkE6a63locelA2vpS6iRop/HMaTnbbun+RMIOzIWgrmDYdC0RxtnYJmsn4erE3886fu51kNEOTo7fiA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 at 06:34pm, YoungJun Park wrote:
> On Thu, Nov 27, 2025 at 04:06:56PM +0800, Baoquan He wrote:
> > On 11/27/25 at 02:42pm, YoungJun Park wrote:
> > > On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> > > > On 11/26/25 at 01:30am, Youngjun Park wrote:
> > > > > swap_sync_discard() has an issue where if the next device becomes full
> > > > > and is removed from the plist during iteration, the operation fails
> > > > > even when other swap devices with pending discard entries remain
> > > > > available.
> > > > > 
> > > > > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > > > > when the next node is removed during discard operations.
> > > > > 
> > > > > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > > > > swap_active_head. This means the iteration is only affected by swapoff
> > > > > operations rather than frequent availability changes, reducing
> > > > > exceptional condition checks and lock contention.
> > > > > 
> > > > > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > > > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > > > ---
> > > > >  mm/swapfile.c | 18 +++++++++++-------
> > > > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > > > 
> > > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > > index d12332423a06..998271aa09c3 100644
> > > > > --- a/mm/swapfile.c
> > > > > +++ b/mm/swapfile.c
> > > > > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> > > > >  	bool ret = false;
> > > > >  	struct swap_info_struct *si, *next;
> > > > >  
> > > > > -	spin_lock(&swap_avail_lock);
> > > > > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > > > > -		spin_unlock(&swap_avail_lock);
> > > > > +	spin_lock(&swap_lock);
> > > > > +start_over:
> > > > > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > > > > +		spin_unlock(&swap_lock);
> > > > >  		if (get_swap_device_info(si)) {
> > > > >  			if (si->flags & SWP_PAGE_DISCARD)
> > > > >  				ret = swap_do_scheduled_discard(si);
> > > > >  			put_swap_device(si);
> > > > >  		}
> > > > >  		if (ret)
> > > > > -			return true;
> > > > > -		spin_lock(&swap_avail_lock);
> > > > > +			return ret;
> > > > > +
> > > > > +		spin_lock(&swap_lock);
> > > > > +		if (plist_node_empty(&next->list))
> > > > > +			goto start_over;
> > > 
> > > By forcing a brief delay right before the swap_lock, I was able to observe at
> > > runtime that when the next node is removed (due to swapoff), and there is no
> > > plist_node_empty check, plist_del makes the node point to itself. As a result,
> > > when the iteration continues to the next entry, it keeps retrying on itself,
> > > since the list traversal termination condition is based on whether the current
> > > node is the head or not.
> > > 
> > > At first glance, I had assumed that plist_node_empty also implicitly served as
> > > a termination condition of plist_for_each_entry_safe.
> > > 
> > > Therefore, the real reason for this patch is not:
> > >     "swap_sync_discard() has an issue where if the next device becomes full
> > >     and is removed from the plist during iteration, the operation fails even
> > >     when other swap devices with pending discard entries remain available."
> > > but rather:
> > >     "When the next node is removed, the next pointer loops back to the current
> > >     entry, possibly causing an loop until it will be reinserted on the list."
> > > 
> > > So, the plist_node_empty check is necessary — either as it is now (not the original
> > > code, the patch I modified) or as a break condition 
> > > (if we want to avoid the swap on/off loop situation I mentioned in my previous email.)
> > 
> > OK, I only thought of swap on/off case, didn't think much. As you
> > analyzed, the plist_node_empty check is necessary. So this patch looks
> > good to me. Or one alternative way is fetching the new next? Not strong
> > opinion though.
> > 
> >                 if (plist_node_empty(&next->list)) {
> >                         if (!plist_node_empty(&si->list)) {
> >                                 next = list_next_entry(si, list.node_list);
> >                                 continue;
> >                         }
> >                         return false;
> >                 }
> 
> Thank you for the suggestion :D
> I agree it could be an improvement in some cases.
> Personally, I feel the current code works fine, 
> and from a readability perspective, the current approach might be a bit clearer.
> It also seems that the alternative would only make a difference in very minor cases.
> (order 0, swapfail and swapoff during on this routine)

Agree. Will you post v2 to update the patch log? I would like to add my
reviewing tag if no v2 is planned.


