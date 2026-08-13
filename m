Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0B55C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDD896B0502; Thu, 13 Aug 2026 10:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67F16B0503; Thu, 13 Aug 2026 10:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FB56B0504; Thu, 13 Aug 2026 10:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA28A6B0502
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:06:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C3DCC013E
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:06:02 +0000 (UTC)
X-FDA: 85096420164.12.E4F7F5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 65C4F1C0019
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:06:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=tqB3xWDe;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786629960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEYWS270K59Ox4tUaRT3lRn2hLg74twP6msTkfS+Pzk=;
	b=YZ6R8LTZ2cqKAsnxTjjcnWWGBpQBibp/9BdXRY+FXCthCwzVs5NEcli+jDBLuTixplIxlP
	yA8Sbh5m7bIfU5T5U11h5aMmytVTzJC+ieVE5HDyw/Aa9As0cBLhWd2qxEhYAx9PKAugAO
	pZKHh9vDtj5S7RSb7wgTusPJG82AmL0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=tqB3xWDe;
	spf=pass (imf21.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786629960;
	b=DYY7EHeLEdElrXjTYKqk3UxT/bZoeKFhZTW+/EkLITRJ/oq/iPSLle795RyFYq+vr6H8JC
	0wgG8KxcClI2Nn/9qHXeZzjFMs0fzeVmydj2awpV3IxHLKHIalMYBIVmJH2Z0uw7/uKH4l
	g8drNblcYDOA893Xis0khp04Wfi1LK8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 72B7E43BED;
	Thu, 13 Aug 2026 14:05:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5EB1F000E9;
	Thu, 13 Aug 2026 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786629959;
	bh=aEYWS270K59Ox4tUaRT3lRn2hLg74twP6msTkfS+Pzk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=tqB3xWDezE1LwSz+0bKaNH6xsJMSj5Y1HTz9b+hD1+mufvVsmG1QxrkrpvtQ6PQOZ
	 3T5EXSBwisyEGRYcEiCeQYuWP/FdTnBIQFRNrFnSp4QMLSurTLF0lZb530rOj/mUF0
	 2da8sgzIjM29NlgtQeYHl0ydstkdDOF72Li2eP5c=
Date: Thu, 13 Aug 2026 23:04:25 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Hajime Tazaki <thehajime@gmail.com>, linux-mm@kvack.org,
	geert@linux-m68k.org, daniel@thingy.jp,
	Arnd Bergmann <arnd@arndb.de>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <2026081330-music-peso-26c2@gregkh>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
 <2026081355-remold-sterility-84f9@gregkh>
 <an3E-5BuWLgwzrd-@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <an3E-5BuWLgwzrd-@casper.infradead.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65C4F1C0019
X-Stat-Signature: 8k61aq4ruidit6ybjwhy8khkhiq5uhmf
X-Rspam-User: 
X-HE-Tag: 1786629960-382916
X-HE-Meta: U2FsdGVkX1+4rrG4VPAEufpc9j+h6a4+DQpsv+HfI9XtXt+ah0hYxilOgXXVvIkYJo4/QD9nrr0SQE7SBS5FtRhhcnJkNUNMrUcmVd5NIThICvVRAFujILooJDmb7Y45vJJSQ0deccjdpKLQdlCqJB8mSYNEd+7fK36fChIgoQWXKYl4/Hal5Y9OZhSgeSJ7RHZmt59F88xqfFN3jeeEMIFrzW6yfJrDvZuG3J+G2n0oSHLKuLRhw6dAM9c/X7JmI7cqr7/YRXarfblE/yVT7CrKyv29zkQeHAVpTopvGxT5AVPnPtAREIgsaAOfswEO0Y7joxUrLwU1LH2j6mc3cuesjQZfavlDHoF2BKkywJNZaPXjVRRO6JAVuhoqu7iyD9jPtbGfDOYTTxDSAwvWRxi63Mlp1Etu8l3DFAW3zGejydmsxJREI7Uc5uImP6KbgLKrhxsXO2rUASFM1OLOl/VuPcMeZqDNIrZ7IurRuqyUIijBRwcS3ZEzQ/E/ve8Orp4NZQf0hxK2RBwlLC7Vysysn4GW4MCGSnucauIQYhDvPoazZG7tasXGZMn14oJJaxGyGSgOJzfBG9HgoiGE67VSlsDBlfYk7CSX2HnqiLTom6pv8594Q74Kp56KqfuQVjgUlrCaj4CQeWlfRGMqf842Q+xEP8RaWGY/ENNAItRY4Rn71NA/0zGi53ztsFG/D05Uz5k4U6/DtCDgp2bPy0J2NfTSJLryXjxyrnxky2ivY5cO0VdyftLBcanRM6JrC3u/gJcW5EBdHvlYFfTjs2PB5raXgbQUz336WSi/zLBHbdlJS9zYY0zrqLIuS1+4D1A+Cr4+qSq5LQIuGAcgewRcAC1oP1PjqUZevSp91BVCJRGilMtnn3ojCp9ObZfp/0NbCxnO7dPfCJaMkArFbT7J6fxmRCjU2Ko/uN8hhUBv+/vXDSj/k2b9EB0vV9XM9ZH0DFa7xag9dzGgPNW
 v5V/uNXk
 MNa+PFjYK6YVxcBY9mKxs8jhN1CEE67D2RrGomMxgYWi+I53y8Al1u6CyR6qhP7TQfLiSScrJ+Ccbfcnq+/6q34Plx7BanBHw7kJoCCcOfwdUfeHRI90Bk4dCJ1ic4r38iG3BFX3VYp1X3uY716ZOFeETlCkCWuF94yNbof6jXCsYBhmAf6gN9IbKvaXJBYRavNOHrmxjme587C6d0D4eSFg3w8wUtx29pQZOICxFIjWM8/jMkhzc0nuGIsPou/86Hz5DVQZ2vD9MUYxKBQUhOqZqBE06T09UCMN147v4oFQVRtRw2wRIJN66bVDG6CgIDw8HNpefQUY98lbPL6ZIgSpF+6/ZMA6DplHX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 02:22:03PM +0100, Matthew Wilcox wrote:
> On Thu, Aug 13, 2026 at 09:19:47PM +0900, Greg Kroah-Hartman wrote:
> > On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> > > Upon a private file mapping request to /dev/zero, it calls
> > > kernel_read() in do_mmap_private(), getting a failure with the message
> > > like: "kernel reads not supported for file /dev/zero", which is because
> > > zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> > > definitions.
> > 
> > Do you actually use a no-mmu system?
> 
> If you look at Hajime's contributions, you'll see they're far from an AI
> slopper.
> 
> https://lore.kernel.org/linux-mm/?q=hajime+tazaki

That's not what I asked at all.

This patch is fixing /dev/zero which was broken in 2020 for these
systems.  I think my question was a legit one, I was not casting
aspersions about any slop here in any way.

> > > @@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
> > >  
> > >  	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
> > >  
> > > -	if (!file) {
> > > +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> > > +	 * and /dev/zero is marked by them at .mmap_prepare,
> > > +	 * which should be _before_ this point.
> > > +	 */
> > 
> > Wrong coding style for the comment, which is very typical of
> > LLM-generated stuff.  Always rewrite the output of these tools to
> > actually be sane.
> 
> A lot of humans write comments like this too.  Indeed, it used to be
> the preferred style for net/

Yes, but it's not for anything outside of net/

thanks,

greg k-h

