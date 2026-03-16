Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6C34F53D67
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 15:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037C46B02E2; Mon, 16 Mar 2026 11:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00F596B02E4; Mon, 16 Mar 2026 11:30:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84326B02E5; Mon, 16 Mar 2026 11:30:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D80466B02E2
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:30:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83F651602D6
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:30:13 +0000 (UTC)
X-FDA: 84552312306.10.9110213
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 80934180010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:30:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AjB2ahiD;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773675011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U7slseaDj6C8xVlIDRB7RUZn6pKjdSWyND29MxBSYuw=;
	b=R+eqOTnWabMCjKP+Yh0rSkLgjx+G7qfsOCohdL6/rPeH2W8qNPEwqsfW4LEyyoxtxQX8bF
	PfLL+/A6T7/QWFoNwCioVEV37j3YxXZt8D9C6B/mLLls2M7VewMBHZD86HoIjWUoDdA+CM
	kb3kDbqm1LYyyerglvN4qltr7IdPWHU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773675011; a=rsa-sha256;
	cv=none;
	b=gZD0m9Z1rb89DPz9ed4NyQh0kmuTzuYcFc5p1LZlO+9JspTMhvj/JGroIdWorxQRM1hOfv
	Bc9UQ10CJY62LfYPyYQz+WPnTp9elgpXpUq8K5ChzkkE/spUvoeSVF+tzaGubLcFlhtk+d
	Qk82acQHVSJnbv7M92Yj0VFQLAuYViU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=AjB2ahiD;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773675008;
	bh=sJlh9H3N2opqWbIg/g+qK1TX2NRyE9ISgUQRRxJCTOU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AjB2ahiDilqjYy0u/5XQ84g9XV1/7Ng8t8Adp0N445JowglBk6dMAF0PnkXSYZ+9R
	 ld5VQY8Us/oJHn3rMNvvG6tYjEK3cwzSMHvzW2mYadKU0jwFmDoOCVrjGWU3io+WJZ
	 o0bDDFRNM+/chrU4cQSfRiVwP74gTC3bYRzEJwGkUz31k8yUOEZ7eDSuDyPox5iwyg
	 oeL2/0Zw3DNyYHaGNXBykgMryprB6ZrJ5AX4ouWscJWl5fEzNMBNrt5h7JWbvkaFL0
	 ud8rk/wfaZM7nC7uQ/QLxpK6hMDHYAq+PvE7NP6ZdNtvR9Ej5QHMcQbo23mPyEsrds
	 8848+e6u0bbvw==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id EE1A517E1330;
	Mon, 16 Mar 2026 16:30:07 +0100 (CET)
Date: Mon, 16 Mar 2026 16:30:04 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Biju Das <biju.das.jz@bp.renesas.com>, Tommaso Merciai
 <tommaso.merciai.xr@bp.renesas.com>, "loic.molinari@collabora.com"
 <loic.molinari@collabora.com>, "willy@infradead.org" <willy@infradead.org>,
 "frank.binns@imgtec.com" <frank.binns@imgtec.com>, "matt.coster@imgtec.com"
 <matt.coster@imgtec.com>, "maarten.lankhorst@linux.intel.com"
 <maarten.lankhorst@linux.intel.com>, "mripard@kernel.org"
 <mripard@kernel.org>, "airlied@gmail.com" <airlied@gmail.com>,
 "simona@ffwll.ch" <simona@ffwll.ch>, "linux-mm@kvack.org"
 <linux-mm@kvack.org>, "dri-devel@lists.freedesktop.org"
 <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260316163004.1f8a6d8c@fedora>
In-Reply-To: <53f11658-5466-49a3-816a-ff6fd2e1da6f@suse.de>
References: <20260227114509.165572-1-tzimmermann@suse.de>
	<20260227114509.165572-6-tzimmermann@suse.de>
	<abL5rcYIaFFO3GW2@tom-desktop>
	<TY3PR01MB113460CA616D3576DA0C3FC698644A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<TY3PR01MB113461ACB668738E1952EC8898645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<20260313111851.4c1f89f3@fedora>
	<f3384342-cdc5-4260-b670-4ffde76a2802@suse.de>
	<20260313125644.65131b27@fedora>
	<TY3PR01MB1134662A395AA0A048CEE152E8645A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<20260313131835.52c5c935@fedora>
	<20260313134328.3166c4d0@fedora>
	<20260313135521.07823792@fedora>
	<20260313184549.08656eed@fedora>
	<53f11658-5466-49a3-816a-ff6fd2e1da6f@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80934180010
X-Stat-Signature: un8bh63ogojrim6j7wimh5ej3imk8iio
X-Rspam-User: 
X-HE-Tag: 1773675011-680968
X-HE-Meta: U2FsdGVkX1/umkE4CL5+skXQjSzilzbChAmPSqjbiTv63lc78rddCMTqsu/lKv5LWnzHl6Y8QDonCS9aWeqSwTG8yXid2wTZBBvF36k0X7pLh/kzdT2CKSJp3oBOM06obvcNIIfHQgdXxuAZtIE9GjxhsBITk3VIKeBCqRl1lqrkemWKoI1VVCarB5c9qYunWZOkViujD+8Tlp+mP/QiABQXB7oU9oNFnLiQS7VQqL58UrIrO7zWjJohsHREXYbabODVs1MRSArt4gn0R+kyM3I3FPOgIKKUvtlj9HATlFs3XftV4ZHbG2Bd/1d0au5ZrXQfNcMJ+DzpSigPOVeQ2jvQxmQfVwpS5x2/IVL8p+uaAH+Gk9wtJzhwB7jk2oF/ItgauRLQqvoEXe/+vqDhzALfWK2C9ukRp+//k2nctVZvsCSdDfQnw08fxYmrCw856mHXkZn8j9izLCPtxafo4W9iIIiqk3y00ROGL0xqBsiKd5YcCmsFXsDOWjX96jkPSRp2Hg1ndIDwjVT28u0v0o0uEKDjBcYUnrX8WI4GXn8Q0rQmWoMY5Ef09+ZCYGFZk6CRnBWAKUbj30HHFs9cnkTQPynjmSkNlhyOoZA1zYuNRS0sWTuQNWj9Rvnql82LLSXdODyio3xgM6C5L+f0QlnDSU4N/pO56SVPztuV7qCqYyqvMesFoYdImyRBqPii522MJA6MNANmXywAsjDWvKMAnTCWytxj5BFIcIM4qEX6SpTpFN7B+BiyVp6Bddlg/QDtYjmeoXgGgBw6Oe1I53NYpdCW1xwnUoLUYZ+L9irDoPWwUQDK8H6780eUCQGuni7wQ0MTegAyBJz5w6mNhGRktREOpaS/1mtAKlWfkolW7k3YPwj6g1bXp8fwySJ65GKBHVkT8C86aHZrBvc7Gi85dWRjiVW/6h0mb4mUi3h2aYqf70kB9g2S9r5/OYK2CkO8KJCr1aTZzC9l1m2
 1u+tX5K5
 RNv/NctRDq2LINu2xg7mxoL54atyzG4E0aIoq10kmNPhLwG6iQTOBI838Q0XSRQ5VXt7cKv0r9UHIEXY/tkC9epPecfpOWs3OaB7hxQwyl2CtL5zYuxgTyhD56C3fI9cE8wHdPnk+FNvXvh9sOeMP9OTAhIi66+5SS1jh0EKTHj2Zls6t7MMsYWHiLd9v4vbyCPoTc05JcwwqkRYNHJNy+kZ8MfX3KLvQah8U91FGw2R6QzvNUwb7fVueTJc66gg+HnEQQWfIhMsRpeVdCdrJqVeeJ12zTE+/65he/hu87fFTLpQmOE8aisB7usPcXXXt1Fz1Ir63/zT66ponOfrHRsdRU4rlSCpNYeAm9/aERSDju386BXZKEXNbsU7Dz2THGHizIWTqStKGZl09mrbCAxNKg0tyo//KW6+yziPUAzCVuPhmz1SOWh9Q+XsKp9B6+ck3XLGbhqhbX62qOedCi1ijDLfYAywFqB/nqcj0Lf/2Vqt9wnnM9OPGQOBPqlNhK3mbuNXqzUSk2HYY3lQ/pprM/8ydKhI3vpE+I1TDq0O2pYAPcyi6/XQh5ql5izqoQilz4/fA9jg6AFFewDaAKHzCgcZYrdU0yQaNfz8kgiu9HnnIDpvyewadkjaZJ4uHoxqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 09:45:49 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi Boris,
> 
> thanks for investigating this problem.
> 
> Am 13.03.26 um 18:45 schrieb Boris Brezillon:
> > On Fri, 13 Mar 2026 13:55:21 +0100
> > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >  
> >> On Fri, 13 Mar 2026 13:43:28 +0100
> >> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >>  
> >>> On Fri, 13 Mar 2026 13:18:35 +0100
> >>> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >>>      
> >>>> On Fri, 13 Mar 2026 12:04:25 +0000
> >>>> Biju Das <biju.das.jz@bp.renesas.com> wrote:
> >>>>        
> >>>>>> -----Original Message-----
> >>>>>> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Boris Brezillon
> >>>>>> Sent: 13 March 2026 11:57
> >>>>>> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> >>>>>>
> >>>>>> On Fri, 13 Mar 2026 11:29:47 +0100
> >>>>>> Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >>>>>>            
> >>>>>>> Hi
> >>>>>>>
> >>>>>>> Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> >>>>>>> [...]  
> >>>>>>>>>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> >>>>>>>>>>>> +		return VM_FAULT_SIGBUS;
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +	file_update_time(vma->vm_file);
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));  
> >>>>>>>> Do we need a folio_mark_dirty_lock() here?  
> >>>>>>> There is a helper for that with some documentation. [1]  
> >>>>>> This [1] seems to solve the problem for me. Still unsure about the folio_mark_dirty_lock vs
> >>>>>> folio_mark_dirty though.
> >>>>>>
> >>>>>> [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/  
> >>>>> FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.  
> >>>> The patch I pointed to has nothing to do with folio_mark_dirty_lock(),
> >>>> It's a bug caused by huge page mapping changes.  
> >>> Scratch that. I had a bunch of other changes on top, and it hangs again
> >>> now that I dropped those.  
> >> Seems like it's the combination of huge pages and mkwrite that's
> >> causing issues, if I disable huge pages, it doesn't hang...  
> > I managed to have it working with the following diff. I still need to
> > check why the "map-RO-split+RW-on-demand" approach doesn't work (races
> > between huge_fault and pfn_mkwrite?), but I think it's okay to map the
> > real thing writable on the first attempt anyway (we're not trying to do
> > CoW here, since we're always pointing to the same page, it's just the
> > permissions that change). Note that there's still the race fixed by
> > https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/
> > in this diff, I just tried to keep the diffstat minimal.

    ^ "that's not present in this diff"

sorry for the confusion.

Aside from that, I've been looking more closely at the code in
mm/memory.c, and other implementations of .pfn_mkwrite(), and I'm still
not confident that:

- we can call folio_mark_dirty() without the folio lock held in that
  path unless we have the GEM resv lock held (the pte lock is released,
  and I'm not sure there's anything else holding on the folio).
- we can claim that the huge vs normal-page paths are race-free. That's
  probably okay as long as we only do the dirty bookkeeping in
  pfn_mkwrite (we might flag the folio dirty before we know the
  writeable mapping has been setup propertly, but that's probably
  okay). What worries me a bit is the fact most implementations call
  their fault handler from pfn_mkwrite() and do the page table update
  from there. There's also this comment [1] that makes me doubt we're
  doing the right thing here.

Would be good if someone from MM could chime in and shed some light
on what's supposed to happen in pfn_mkwrite (Matthew, perhaps?).

[1]https://elixir.bootlin.com/linux/v6.17.2/source/fs/xfs/xfs_file.c#L1899

