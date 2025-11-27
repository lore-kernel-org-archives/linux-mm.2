Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B297ACFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144896B000E; Thu, 27 Nov 2025 03:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121D56B0010; Thu, 27 Nov 2025 03:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0318B6B0011; Thu, 27 Nov 2025 03:07:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E4AC66B000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:07:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49C835B9FA
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:07:20 +0000 (UTC)
X-FDA: 84155657040.17.05C86EF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2128420007
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:07:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLUXuWQp;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764230838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FL538VFzS2lYuHN188p0Ripjd642cwdZay0zTaRWDfw=;
	b=Hx8VEK5c3uBafknLm4ovdm9Y2OItS676xcYDfJ48OON5w7+Y8ie08teu8LFdvWqd5g0XZ6
	b5FI/zg5vXTkjM+hzux1S1pXqcYs4PQBfJ5gqrI8MFzgZZ+y+pdr7Pbr4CoMj4HH8SwItB
	thV+jph+CIYq7RYYRVattxonntGVT7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764230838; a=rsa-sha256;
	cv=none;
	b=eP5rUecJUT/2G6pLUeqoFW6vhjYJdhYzD//vdkY0mhyho4LJFAaiykTjCP+i3wB+RsSn8N
	95zWzTIo4L0Y7j3lH1L4PB/rJ9I12a9QzBYSyinwPMdqE5MFRuMayGCbnQmiY7ApFajrAh
	TGlubcKrWThj0tESK9RfJJmMMbbXYic=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JLUXuWQp;
	spf=pass (imf03.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764230835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FL538VFzS2lYuHN188p0Ripjd642cwdZay0zTaRWDfw=;
	b=JLUXuWQpp/sqeNcsoHkFuNwyPfS5VOZ9fDwVrswOccHaYKVoNbahMC/95E0VprU06+Jqf1
	vVPoGb/A7nzip5gdM2AZ9YLFeYSamGuBBu+0KnmsOAbcU5bOdZrXaX7+WSsRO2LYaq785I
	YnhcJnTHN4NDehvVVrn1ouOwZOqZRSg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-307-f6hhPDx3MMKCwST5ldynjg-1; Thu,
 27 Nov 2025 03:07:09 -0500
X-MC-Unique: f6hhPDx3MMKCwST5ldynjg-1
X-Mimecast-MFC-AGG-ID: f6hhPDx3MMKCwST5ldynjg_1764230823
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F3B4B1956058;
	Thu, 27 Nov 2025 08:07:02 +0000 (UTC)
Received: from localhost (unknown [10.72.112.107])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6156730001A4;
	Thu, 27 Nov 2025 08:07:01 +0000 (UTC)
Date: Thu, 27 Nov 2025 16:06:56 +0800
From: Baoquan He <bhe@redhat.com>
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baohua@kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm/swapfile: fix list iteration in swap_sync_discard
Message-ID: <aSgGoLLOQgFCrsMu@MiWiFi-R3L-srv>
References: <20251125163027.4165450-1-youngjun.park@lge.com>
 <20251125163027.4165450-2-youngjun.park@lge.com>
 <aSe0VrozSSD0xeGl@MiWiFi-R3L-srv>
 <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
MIME-Version: 1.0
In-Reply-To: <aSfkrpV7T7g5mhpI@yjaykim-PowerEdge-T330>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: CCTzlONuMEr-wUcENqM7w5noUuPobjpIo0ztGtK02xY_1764230823
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2128420007
X-Stat-Signature: pkcmj81atda3y931y4osnm8timhqiuj5
X-Rspam-User: 
X-HE-Tag: 1764230835-81523
X-HE-Meta: U2FsdGVkX19KRkB2/4Mecvz+p0zXJEa7QUlgm/CesIwUFJgnrjv1fo1R8fvfigbMWGCQhi1mZiNm+ukoS8/geZHph9CQ4gWWT7V1rMN6K0fb1XQ0Bm7W+/omG0RVKqc/MVHgrTzGmmEVCyyilFdHigXr9pQD1QqjkCpyQhTKx5AzbpGBVuR+HOxwVzVC1oZ0kUzMgX25oJ5UTRnkElmOaCU5VaUMbFoSxAO2CA6wmc08AW7AgyndtFns6TC3zGmpmIBd6l+uYFBcG5GyNf1kZAKtNB2InhRsGfrOnIZuQahRDmvDYuNEtHFoUtf7FoyaCCbPZnz1H1q4OmRoBofCjyevAO+WTPbtGRxnjacgMrbGZUif8aceOSvEoxjSSRddYOJiSz6NFOuQkwVhk+AFxXOMbeILOCTpAhpfATU/e4epwgBaTl5ZL9IxLfAgbK1M2j2cxha+jfKroYPBuJ1CSK8zqLBPe6QJcnCUO+sRkjkGXsgddIPn3kRB3rpaijWevcIcNWyeLLIdIS9WIq1yXjR//R0go6Nm0asT5rz6ZrJRNcD5344dPFBQXr+egB91Z9Ku+odipGpKOk153BHmC7DWaaPjMbFqOHJybmpwxfam3O0qAwieYZr/ctttnwc6RXEsKntZ7aF076leMUVZL/BZNYHQyU8xlPecNrvfcr9uKWE42zfoUiR4qrlEHbJprLn3WpObxj1TQfaOayEmcDJvvQ3VlRwrM1lTma3FMEuWwb+Rhu5r6bolkR96c/f9icSzMsL+CMMujuNsHUEaFQEG4T8nRRTuI5VZMmzXT58myplooYP5NS8/1k5E08jBAWHwhNG/UbQ8D+GMVi9VyiwOETc6uX4mn8o7fIu5eegFXDreWoIrUZXue5I5gDgmutkunMgWKJo+0n1hha+u/1Uw4aJiKw/f/491wZVJO0q8OYq4BtLkC+BSg44997GKJUpy1PtYh4gAuQuoLmy
 qMRPfxJa
 +l4if9hry4SYpMnL2iwm+r9TpA5qPaRBdYmLqaIMPChf7kLiBlfDwyDmmZZbRwGjcakEfp+bz1F8RV3huvTGQcA5Vdv5Od/rZS9G0n3moivf1fmp05dTe/PCSnbolT940cz1NmTIQZb+DirGqVcH3RqO/4gpH/uua1Am19yt+bqwyvZrS41VBltTYRbkFgdxVApMZsvDMn/BLzJxyGRWB81XkvqusV6nuWxHzpG9RqEOxfVz8ZZ3C8yeegznIl4wAvXrYBa4PobUlq4Qerp9lS6vT90WgsjyDXAbAE8rXTXAAGhrs7Qfxoh6oMCFcDyrFvoJouZxZwU+XvZ8IaZ0SQqN83JaaCWwQRfSuIn4sUZcvVPI8d5YLp7dplpgSRIheObIerFArWJ7CjtL/jjZz+k7Syo5jxCZSrQ8UyezFFzbDsPTSIOTuVdBV8U9zOXWy07/x/nq5ixCazwwj9XT5Fhat6TMQKpt4Dm7PtbZ8t0Bm5oVXxXNW9tPtPR/awon6TsVIQNWblPcefIDJ93AvOeRnICq8+hztRKSTsSnVq+m958167BBA//akCpSA8OXinYD+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 at 02:42pm, YoungJun Park wrote:
> On Thu, Nov 27, 2025 at 10:15:50AM +0800, Baoquan He wrote:
> > On 11/26/25 at 01:30am, Youngjun Park wrote:
> > > swap_sync_discard() has an issue where if the next device becomes full
> > > and is removed from the plist during iteration, the operation fails
> > > even when other swap devices with pending discard entries remain
> > > available.
> > > 
> > > Fix by checking plist_node_empty(&next->list) and restarting iteration
> > > when the next node is removed during discard operations.
> > > 
> > > Additionally, switch from swap_avail_lock/swap_avail_head to swap_lock/
> > > swap_active_head. This means the iteration is only affected by swapoff
> > > operations rather than frequent availability changes, reducing
> > > exceptional condition checks and lock contention.
> > > 
> > > Fixes: 686ea517f471 ("mm, swap: do not perform synchronous discard during allocation")
> > > Suggested-by: Kairui Song <kasong@tencent.com>
> > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > ---
> > >  mm/swapfile.c | 18 +++++++++++-------
> > >  1 file changed, 11 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index d12332423a06..998271aa09c3 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -1387,21 +1387,25 @@ static bool swap_sync_discard(void)
> > >  	bool ret = false;
> > >  	struct swap_info_struct *si, *next;
> > >  
> > > -	spin_lock(&swap_avail_lock);
> > > -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> > > -		spin_unlock(&swap_avail_lock);
> > > +	spin_lock(&swap_lock);
> > > +start_over:
> > > +	plist_for_each_entry_safe(si, next, &swap_active_head, list) {
> > > +		spin_unlock(&swap_lock);
> > >  		if (get_swap_device_info(si)) {
> > >  			if (si->flags & SWP_PAGE_DISCARD)
> > >  				ret = swap_do_scheduled_discard(si);
> > >  			put_swap_device(si);
> > >  		}
> > >  		if (ret)
> > > -			return true;
> > > -		spin_lock(&swap_avail_lock);
> > > +			return ret;
> > > +
> > > +		spin_lock(&swap_lock);
> > > +		if (plist_node_empty(&next->list))
> > > +			goto start_over;
> 
> By forcing a brief delay right before the swap_lock, I was able to observe at
> runtime that when the next node is removed (due to swapoff), and there is no
> plist_node_empty check, plist_del makes the node point to itself. As a result,
> when the iteration continues to the next entry, it keeps retrying on itself,
> since the list traversal termination condition is based on whether the current
> node is the head or not.
> 
> At first glance, I had assumed that plist_node_empty also implicitly served as
> a termination condition of plist_for_each_entry_safe.
> 
> Therefore, the real reason for this patch is not:
>     "swap_sync_discard() has an issue where if the next device becomes full
>     and is removed from the plist during iteration, the operation fails even
>     when other swap devices with pending discard entries remain available."
> but rather:
>     "When the next node is removed, the next pointer loops back to the current
>     entry, possibly causing an loop until it will be reinserted on the list."
> 
> So, the plist_node_empty check is necessary — either as it is now (not the original
> code, the patch I modified) or as a break condition 
> (if we want to avoid the swap on/off loop situation I mentioned in my previous email.)

OK, I only thought of swap on/off case, didn't think much. As you
analyzed, the plist_node_empty check is necessary. So this patch looks
good to me. Or one alternative way is fetching the new next? Not strong
opinion though.

                if (plist_node_empty(&next->list)) {
                        if (!plist_node_empty(&si->list)) {
                                next = list_next_entry(si, list.node_list);
                                continue;
                        }
                        return false;
                }


