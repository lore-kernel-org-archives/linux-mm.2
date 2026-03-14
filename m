Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E96D10706CF
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74EC56B0088; Sat, 14 Mar 2026 07:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1686B0089; Sat, 14 Mar 2026 07:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4426B008A; Sat, 14 Mar 2026 07:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB3E6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:48:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCA5D1CEE6
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:48:35 +0000 (UTC)
X-FDA: 84544496190.08.DF7669E
Received: from lgeamrelo07.lge.com (lgeamrelo07.lge.com [156.147.51.103])
	by imf04.hostedemail.com (Postfix) with ESMTP id E0CA540002
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:48:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773488914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oTCbrCXZqZKDQ/zm1HNI7H3J33u+gY5m7CAg7N5j7xc=;
	b=2LvW45YN+lRQ8vQevhuQz9hfcUyDLz8fok9dwlyEPsDXlPMHN4uRyYoE3a/Z22DTq730nT
	D+Sow+mszwrFg77454GDmFlRGS9i8+gRwRNKmDe8dHgcLv3LWLcGzCi3uZyRUtmYCpqJ+m
	/zeVzrO6AkKLDlGFD6V7OWlBuAk+S/g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.103 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773488914; a=rsa-sha256;
	cv=none;
	b=HM+mf3kYcLpckhduCqLl2DMoKjTNJRyFPzpgofrNtQvyF9GuRplXSa15NCHLyqFP5ACFya
	lWN9+jq1XrpPP+szZ3FifV4GrILSj0QExHaM7Pw2vJ+KP2hX+t4G7032JHamz54rHGpThv
	p+TOU1LsrfLDRMjEK0/rFhM2A6GIQ98=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.103 with ESMTP; 14 Mar 2026 20:48:28 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Sat, 14 Mar 2026 20:48:28 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, chrisl@kernel.org,
	kasong@tencent.com, pavel@kernel.org, shikemeng@huaweicloud.com,
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org,
	usama.arif@linux.dev, linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RESEND RFC PATCH v3 1/2] mm/swap, PM: hibernate: fix swapoff
 race in uswsusp by getting swap reference
Message-ID: <abVLDJq/mn5tFkfe@yjaykim-PowerEdge-T330>
References: <20260312112511.3596781-1-youngjun.park@lge.com>
 <20260312112511.3596781-2-youngjun.park@lge.com>
 <abQMiv6Y4WEKTLng@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQMiv6Y4WEKTLng@KASONG-MC4>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0CA540002
X-Stat-Signature: 86a6rsstbsicfksxa4os16erzd4134eh
X-Rspam-User: 
X-HE-Tag: 1773488912-644711
X-HE-Meta: U2FsdGVkX19ULAIStzMcpA0efbuJ2+ncHdWxSabWUZglOE7kQJefYPoV3t1aIvlOMTmmKFmoGsRO4i1rfBbEzXeTKcTXvox0M09wUTW+6SbpA24YpExT++yqSVyw/507u/qq4P7En7y9PmRENtEFmdaKlPdxSOkbrNc9XzqEQPEL2+KhObLYA+uWaSEeKJCcriZ9hgmWNo+xNd+RK/0WyOEq5CgqXzkeJm4QAnrRvlaFwuNiMzMj6VuMfN8+bRs4bjPxQSmmqPtmtCTjEG/Z65kVTNZD5K8HK8RYgxNRP8AgUwnn5KNSSsmaI+O8ZRmJeGviLVqec4mfTP5rgheKOQThF0xlAjst6YtHmWvx8pGykOUDm0IJZPzQGmAmNVsffrYKyHi+Xd7cStmTqp+p3wBFvDoD1j4is/cqzcn/lhCq3t3+yDwmnlxiZe+p3X5S/LKXAeeeCbnbMDR9+SdYH0jU9wpJjF165aGGzNvcLgk5rJMkiAxOZgrMexi5JHTNp3iI/81N09NMMVLzVvyotXSH6XotQohOp8CUB3SAJ1VPeHaLf2DIK0aCEcXUOPP3kTr8NIWdtCFI2i+6jsjFA6tYSG7J8s+EsvCZvLlcVkgBlkM/WB4uLRoIWU7ESxnLSz6KclCPolSuEc6frGn4+RuSF7VcLRWkGbZVMduHM3kdF0mte5emyEA2JBn83WoM9O2FhOiXAEvOFRUHwABbnbuloabfmVgSbCwQba+G+++kKgGw9hZ+QyxU399hqUasBIPh049msSYjJ+BFVVgTTm3BvYZewQZJ6NWFhbvFsquQxYKgopPpoUItB6yHdj86EA2ASUaxdljyzjeG6XdAhQs8TtY5iaxJGIZZ7OneLkaOce/It4zd7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi, YoungJun
>
> Nice work! Thanks for improving the swap part of hibernation.

Hello Kairui :D

> Some comments below:
>
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index 7a09df6977a5..ecf19a581fc7 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -433,8 +433,9 @@ static inline long get_nr_swap_pages(void)
> >  }
> >
> >  extern void si_swapinfo(struct sysinfo *);
> > -int swap_type_of(dev_t device, sector_t offset);
> > +int swap_type_of(dev_t device, sector_t offset, bool ref);
> >  int find_first_swap(dev_t *device);
> > +void put_swap_device_by_type(int type);
> >  extern unsigned int count_swap_pages(int, int);
> >  extern sector_t swapdev_block(int, pgoff_t);
> >  extern int __swap_count(swp_entry_t entry);
>
> I think the `ref` parameter here is really confusing. Maybe at
> lease add some comment that some caller will block swapoff so
> no ref needed.
>
> Or could we use a new helper to grab the device? Or better, is
> it possible to grab the swap device then keep allocating it,
> instead of check the device every time from hibernation side?
>
> The combination of swap_type_of & put_swap_device_by_type call
> pair really doesn't look good.

Initially, I considered making the function grab the reference
by default and renaming it accordingly to better reflect its
role in acquiring a swap device for hibernation.

However, based on Chris Li's earlier review, this approach
would require adding a significant amount of error-handling
code to release the reference in the regular (non-uswsusp)
hibernation path. After further consideration, I concluded
that the regular hibernation path genuinely does not need the
reference, since user-space processes are already frozen.

So I will either introduce a separate helper function for
grabbing the reference or add comments to clarify the
distinction. I will also improve the naming of the put
function to make the pairing more intuitive.

> > diff --git a/kernel/power/user.c b/kernel/power/user.c
> > index 4401cfe26e5c..7ade4d0aa846 100644
> > --- a/kernel/power/user.c
> > +++ b/kernel/power/user.c
> > @@ -235,11 +238,13 @@ static int snapshot_set_swap_area(
> >             offset = swap_area.offset;
> >     }
> >
> > +   put_swap_device_by_type(data->swap);
> > +
> >     /*
> >      * User space encodes device types as two-byte values,
> >      * so we need to recode them
> >      */
> > -   data->swap = swap_type_of(swdev, offset);
> > +   data->swap = swap_type_of(swdev, offset, true);
>
> For example this put_swap_device_by_type followed by
> swap_type_of looks very strange. I guess here you only want to
> get the swap type without increasing the ref.

The put here is needed because the SNAPSHOT_SET_SWAP_AREA ioctl
can be called more than once. If the swap type changes between
calls, we need to release the reference from the previous one.
That said, if the type remains the same, there is no need to
call swap_type_of again. I think this part needs some
refinement.

> > +           if (ref && get_swap_device_info(sis)) {
> > +                   spin_unlock(&swap_lock);
> > +                   return type;
>
> This part seems wrong, if ref == false, it never returns a
> usable type value.

Oops, you are right. It should be something like:

	if (ref && !get_swap_device_info(sis))
		continue;

	spin_unlock(&swap_lock);
	return type;

> > +   if (type < 0 || type >= MAX_SWAPFILES)
> > +           return;
>
> Maybe we better have a WARN if type is invalid? Caller should
> never do that IMO.

Agreed, will add that.

> > +   sis = swap_info[type];
>
> We have __swap_type_to_info and swap_type_to_info since reading
> swap_info have some RCU context implications (see comment in
> __swap_type_to_info) and these helpers have better debug checks
> too.
>
> Maybe you can just use swap_type_to_info and add a check for
> type < 0 in swap_type_to_info, and WARN on NULL in
> put_swap_device_by_type. How do you think?

Thank you for the review. I will switch to swap_type_to_info
and add the WARN as you suggested in the next revision.

Best regards,
Youngjun Park

