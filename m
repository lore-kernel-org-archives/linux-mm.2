Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7058C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3566B0088; Wed, 23 Sep 2026 13:14:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953EA6B0092; Wed, 23 Sep 2026 13:14:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 842EB6B0093; Wed, 23 Sep 2026 13:14:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5EAA26B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:14:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DEFDA1C338C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:14:38 +0000 (UTC)
X-FDA: 85245676236.13.C648318
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 27AA218000B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:14:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mDZk1B/h";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790183677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rb+Cq8oR05KtpukUE9vRoODPKnztoTGRs8NKfaj7ft0=;
	b=InSOWdilur2FJTUI7x0VG/IemI5Hshq5JMiNZflvD2StHj0r6Pgy5SLzVbBYwz3idnm3oW
	lgWSTRno/WsEatts8TqQOPf5qzwrfZwLdnWQTq2I7yqHzMK5C+m1szjJTDkevJ3N95F6nw
	QkzI5OKpFqdj2iulStDM20JIb6czGa8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mDZk1B/h";
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790183677;
	b=TdXNda1hYWm/g8zb5SnkDI9MwznThB6KWx9feY8hD11wzpyw2U3LQJSwZSXu383TcLSe7Y
	agbYTGuCYw7rtj7fdAcpwXUwhW9mZKBmmBL0HCsW5oCPJHu4faxoT2rAuQKtI6f103Tipj
	GnGbOPIlCS0Ek27t2XNc+DbQCOlfMwM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FDC64399B;
	Wed, 23 Sep 2026 17:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A931F000FF;
	Wed, 23 Sep 2026 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790183676;
	bh=rb+Cq8oR05KtpukUE9vRoODPKnztoTGRs8NKfaj7ft0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mDZk1B/hl2XtyOeNXAwFCKEQb8I79T3hZm+ieG0KZ7/2+LbDR2vrarfRpdpwV2hFg
	 dXFcp2xZgmBz/FZqpbCJcJYYahWFzrhYgcwd24+xw+nILmK3rUYgD+wIKx/+CL5WxP
	 mpokFMBKGwu1YzoTQFZiisa9IFMSpe3e0poyeS2BCJYK5ymh/3724o92cve2UoHlwr
	 sMNOWtf7plyGOY+kdSRbuSmPgA1v98+uZ/dppv7siv5k1uG69vfBexsg8N6wW80iBP
	 bLnD11iASlLG1/Z/XTjCt1lpib/ng/dqwC6CGdm/pIcNcSxyH4SqCSyfLuMOnQc7J2
	 D2DfyK1O81cKg==
Date: Wed, 23 Sep 2026 18:14:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, david@kernel.org, vbabka@kernel.org, jannh@google.com, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org
Subject: Re: [PATCH 05/10] mm/madvise: factor huge-PMD folio processing
Message-ID: <arQItpXkh7WV4yyR@gremlin>
References: <20260922235830.2350770-1-gourry@gourry.net>
 <20260922235830.2350770-6-gourry@gourry.net>
 <arP4Igew3iL9qVKW@gremlin>
 <arQGK4RbYWYm4En7@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arQGK4RbYWYm4En7@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 27AA218000B
X-Stat-Signature: 9ctsc6kutzot5wou4cjcmaryp54f1wwz
X-Rspam-User: 
X-HE-Tag: 1790183677-163598
X-HE-Meta: U2FsdGVkX1/jwKhd/HeqQhhcQ+kRwd5GIFBc6ILi/67qzYZzmUKKe81J5PK8YbLteBmnXsyWrC5OIfPAmPiM4bGoVLu3VEDaOpIbT8hWmXL73eKB2L+EyiOvHcXNNzJtSS4eznttGcx23Fu6EJN5+/2F8k6qFisAb7LhVJ3WwutKoEQUZrnPIfYZRpofibDI+illZ0QN4QbVAJOz6DqLSv8MX4ImiGbS1OYCKp8qRmXQ2xZl6Yo7ltYTI8FYGtR9HUdEXLxX7TcOXMntH3KLWA5sF8k+VhgwYa3x6EIzOpg1YqQhg6eZbuGmaKaik/Pvn8SC7hKz6rAwBqKxyZF6eC903WXNtJhve/IPeLepPqZiH1QTyGpgNfTqqMH2eenwJhrGL3CIIn3k1CAxojboXrzg8S8+FFwgTLJ58a5zMBHgwPAqs7NSaz/f7++4CoiJ2KOWYRnEkKJ1lnk55reY2FQ5W/aguoZeWvJoQaBBhr1XNniiod0jO89qkeaVuNrm983HfhWN11Jl6+DnodRPXjRQuMiRq3zcn0Hx15/DStUKgtFfSiWvN7wlomBh1tXD6p/GbcIL541Wx3QsAWpw17OHSbMLOgO/FbNPdtgVjXpsK3wN/zXQ4cKJ0AdDH4ogWRETYpZmo+WQCv4G2RWv25dhVXL42FnhAzDxEB2idqoUI8zDpZnSq0HKr3TYArKguSqv7AXTogO2wWPM8y36vCHTnVX6ZAA+xCnUWfz5NZz85xV+fWEopQ40mlA5jYns76Y+mhq8v8uwJ2D/D4yEpOusi9AhGb7oHNys+EDhDWb+00yVbTDxm3umiQcWFF86H8TXsGfK6ypqYlnz+F6DAfL3YzwCERF+O1xFS+Bt00VnxueF3v+WlbgeBNSD8CRgbPFrby8YPfmsEE/+8wGPYSUCXj6Y1CvhiPyP/qBQ4jgifq6n5/tdmj2/08fSrl+cM4jOGdudfVFTWSTHex/
 kGnJqBET
 IJdH4+hz24pgNN6KIJ0APlxwdcQn+EPC9GRZ+2ix/M/a5yOtrIHJT9eqXo0CH3zuXcftyWtZEEuZHmjjev0cysVIiK5fshZYijGy1Ikaj3vNWh0qZK+Hhsqslgn3QkUL38vn1t2YYc80Suq82RvajW+EgXxWEBIdLj0AN5L+P1BIBGBbuTt2csi6m4l2kV5O7UcLvWSgRcG1J1f+e/I5zyMOATf/fbJNnGnRBqbb6AqT7ssH2SH6RAD7Hwa0bm78w8BiK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 01:06:45PM -0400, Gregory Price wrote:
> On Wed, Sep 23, 2026 at 05:43:59PM +0100, Lorenzo Stoakes (ARM) wrote:
> > > +/* Return a locked, referenced folio only when it must be split. */
> >
> > I find it really weird that when it:
> >
> > a. succeeds
> > b. mapped folio is missing/invalid/filtered
> >
> > In both cases it returns NULL.
> >
> > And it's also weirdly returning a folio in a kind of failure case, or it's
> > more like a defer-to-the-rest-of-the-code case I suppose.
> >
> > I wonder if the split could be done as part of the function?
> >
> > Then maybe have it return bool and document that true means it's fully
> > processed (invalid folio cases, success case), false means that it's been
> > split and the rest of the code should continue.
> >
> > Awkward one actually.
>
> Yes this was an awkward one to futz around with.  I took a couple tries
> at it and this is ultimately what fell out and passed the tests.
>
> I think there's some tweaks that could be made here, but I err'd on the
> side of "don't break shit" before I went twiddling.
>
> It is at least easier to understand, but certainly this shows how poorly
> the original code was structured.

Yeah, if this is an intermediate state I won't necessarily insist but it just
feels so odd.

Maybe have a look at it doing the split in the function and see how that
sits?

>
> >
> > > +static struct folio *
> > > +madvise_lru_huge_pmd_locked(pmd_t *pmd, pmd_t orig_pmd,
> > > +		unsigned long addr, unsigned long next, struct mm_walk *walk,
> > > +		struct list_head *folio_list, bool pageout_anon_only)
> > > +{
> > > +	const struct madvise_walk_private *private = walk->private;
> > > +	struct vm_area_struct *vma = walk->vma;
> > > +	struct folio *folio;
> > > +
> > > +	folio = vm_normal_folio_pmd(vma, addr, orig_pmd);
> > > +	if (!folio || folio_is_zone_device(folio))
> > > +		return NULL;
> > > +	if (madvise_lru_folio_is_filtered(folio, pageout_anon_only))
> > > +		return NULL;
> > > +
> > > +	if (next - addr != HPAGE_PMD_SIZE) {
> >
> > NIT: Maybe could define above as:
> >
> > 	const bool spans_pmd = next - addr == HPAGE_PMD_SIZE;
> >
> > And then make this:
> >
> > 	if (!spans_pmd)
> >
>
> seems reasonable. ack
>
> ~Gregory

--
Cheers, Lorenzo

