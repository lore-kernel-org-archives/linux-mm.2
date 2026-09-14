Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3A42C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 06:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580086B008C; Mon, 14 Sep 2026 02:31:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531196B0092; Mon, 14 Sep 2026 02:31:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445956B0093; Mon, 14 Sep 2026 02:31:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 290C96B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 02:31:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BDAEC16115B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:31:51 +0000 (UTC)
X-FDA: 85211397222.12.276F5F9
Received: from mta0.migadu.com (out-249.mta0.migadu.com [91.218.175.249])
	by imf19.hostedemail.com (Postfix) with ESMTP id 12DCE1A0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:31:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rPA0SIFn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789367510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoES8pAw1YoYzS2KrAnfhVCRFbha2HQJo3nHeeTRBwI=;
	b=PsSMa2UYJ0WnF2UL1b2eRn0G1Sf6md14joyyqHE8XMVtuSt0mV8n5pMISVL40sRUzVBn0j
	cSbt1Ab3JVzqbWhFCw6CeVR3ChiafIf5/yPpfCqnNk78Cq+q/YQfqhqbGrIGUf9jrrKyrr
	rN0c/CRpXNHLoQosjD1tNz8WlxCEU5k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789367510;
	b=LE6/wYMQaz/GDhrPJRqx259oF4OHPsBRMWmuDoJGJCfMeI4YwKGAqNi8OJgQWJydshdhUo
	x0ekn9pbXV1dARBd3d7vMFFVJY/E4UWOnY/Jst95IMwaxB4hiF+EGA5/WizUHhTSSm/dHP
	BpYpPmnAwoMQcWD5XoRCwZ4oZiW3O9s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rPA0SIFn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.249 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=fg55GBUUkV5XCXftDf2mzn4Rh5jpTy9Wzy8AZmn9baM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789367506; v=1; x=1789972306;
 b=rPA0SIFnK8LxlZHDkTpkItv3g1/wmeAar9MridGrm/fYoC0OdigVsBuEM4iASjN3wY8Vqc2t
 YIvWiA0jt1jqUydikfF48omMG/52WrCGzDR0Zgld6bQOZQaZDcpeG6VKI2IUWhZWW2uF+HbuEG6
 7y+noqSw93W755tRJ+thjRT8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d8fd9943a3e500eb;
	Mon, 14 Sep 2026 06:31:46 +0000
X-Mizu-Trace-ID: d8fd9943a3e500eb
X-Migadu-Flow: FLOW_OUT
Date: Mon, 14 Sep 2026 14:31:39 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, hannes@cmpxchg.org, yosry@kernel.org,
	nphamcs@gmail.com, chengming.zhou@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com, chrisl@kernel.org
Subject: Re: [PATCH] mm: zswap: return -ENOENT when the swap device is gone
Message-ID: <aqeUyxJmzC397G7j@fedora>
References: <20260913063031.1689420-1-hebaoquan@kylinos.cn>
 <20260913005149.a28c21aaca165fa0255f8475@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913005149.a28c21aaca165fa0255f8475@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 12DCE1A0002
X-Stat-Signature: mhzudd47ss9x15ztgk8wn3rfoxum6x8q
X-HE-Tag: 1789367507-139599
X-HE-Meta: U2FsdGVkX19lmanqf6P3i21XIf9ZqWXzPflrQujyVdgw4cIVN448Yl54oBOYW80nthIH1PeZ8ZLQ/UZ5GPEInDsaqRwfxH7a9oDnxnDCNbqVpBYLpfe5gsX+PdPLMMsdLVUyXb3yrEHR0HEFtz+zYWU6Ltz0F7o2YYC+1ZoNfUen0chEzJ1Jn15xRJ4efAClfYcmvo5Ql2garRIq3aT87huAmtUxXpqMFZE3Zkhs5pRJUZ2DTbOUZJkm/U6s/+OGd9R7qJaX1sSCIGx9HWsBwHsGa0KwkcWtGHeS95xjawtMKIQ8pisvP+vHcCuKBLdl60avsMJEExouqqfWJHd+Il25sqXDEipmnEmfB0THfa+kpH/Q+XpcRIvBWczSmC/FaXmSOehnREZ91LwZiVbUGUAuu/WlQs7wKJEnwMvx0nbb8pBIlgpw+DLgrGd6bkJXwDsPvDmFqeZima+peALKAvZAOxRiclp1INmmLYDUIDw7uIl0hAo7Yf0VBm40doe0ObDNdi+Mmbuhl/aiiOEy1Yv2NpDxkcg24lAKF8ViR3OJiBlPgNpxqktzgfbiwKAHbUGIy2AAzRs+opKOump8B8h4elzZQQERQ/kqNEI1HSdmJhQpdwxnGI5MStQUCRD6VdG5NNGOwixIfV6HOg+MmvVtU8Dt1dz7Tp/p4NeHbqS7gZjVJkh3wP0I/nB0GjRcsNQ5NnGfsRrDHfip3tVOavrlHpHSbiaZSsY8753FfwPV/xMp6i2JHRB7IUeggSiLTaEXvs4XcPUqaoI5aDynk7xwfLGLS7xwa4gQdPqnTfrz9GBN6W/9D1XmfxLXVISMk/gsjy4+dXVRb8lno/+f3Vl26m0kVIDbwe6Yug/XbES7ioaxDBac1nhxKcw+hY64tN9MXKN/B+YEwheBq40gfOMq/kunzpmpTXSUAZOrUzLvQV3HvlKFJaXGL1sS/sWE9qRqeQkFrGgKDGHXGzk
 cSJ0MT/h
 8VLEu/yQL3mf4iQ6Q5PCL/5xlVDceTxh+jpICsqTxJh5ygf2va3d+M6o9mxbswxwbkFfbuIoH/9NIfSPGYGptDU3C1tBewanAcC4lY9TUkHOqoKbf1Vuxd9UXSJ9kyWxAjl+NmXl5TYT4GydhQ0HjACoOqHSJqRlVt8Eze78uhQeLPmiv4jJZIatEiBdlH7lU8z2xuVyuyWAajJ4LR4r1Wl6MxQr5q+iGDOfTuvHajm0edb5pk9X2ODoCmtatduYgh87AJhTB7Lx0cYA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/13/26 at 12:51am, Andrew Morton wrote:
> On Sun, 13 Sep 2026 14:30:31 +0800 Baoquan He <hebaoquan@kylinos.cn> wrote:
> 
> > zswap_writeback_entry() returns -EEXIST when get_swap_device() finds no
> > device.  -EEXIST is the shrinker's "page already in swap cache" signal,
> > which makes zswap_shrinker_scan() stop shrinking entirely.  A NULL
> > get_swap_device() instead means the device is being swapped off, so the
> > entry is simply stale.
> > 
> > Return -ENOENT so the shrinker skips the stale entry and keeps scanning.
> > Independent of xswap; affects all swap devices.
> > 
> > ...
> >
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -998,7 +998,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
> >  	/* try to allocate swap cache folio */
> 
> Comment was always lame ("say why, not what").  It now seems flat out wrong?

Agree, the comment should be moved down to be cloe to
"mpol = get_task_policy(current);" line.

> 
> >  	si = get_swap_device(swpentry);
> >  	if (!si)
> > -		return -EEXIST;
> > +		return -ENOENT;
> 
> mm-new has changed.  I made this

Thanks. Does it need a v2? or just use ther version you tuned.

By the way, which mm branch is suggested to take as a base for mm
patches posting? I usually take mm-unstable branch, seems it's changed
to mm-new now?

> 
> 
> 	/* try to allocate swap cache folio */
> 	si = get_swap_device(swpentry);
> 	if (IS_ERR_OR_NULL(si))
> 		return -ENOENT;
> 
> 

