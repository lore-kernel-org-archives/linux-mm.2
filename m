Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E50A1105F7A7
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDBF16B0005; Fri, 13 Mar 2026 08:55:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9C826B0088; Fri, 13 Mar 2026 08:55:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9EB06B0089; Fri, 13 Mar 2026 08:55:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A971F6B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:55:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4260356081
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:55:30 +0000 (UTC)
X-FDA: 84541036020.14.6A824E7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 738FC4000A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:55:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=SWH6jPaU;
	spf=pass (imf17.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773406528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oH8mqllp+qqr4gnAjc4UIMbHb7vQyqkZGVydQCFuyYw=;
	b=2xjEtZLQm05J51gTeoxetlwTbX7HpIoa7m8SHmVO21j06e7ebUcdJvaYtg2EhCtFwpiAss
	ZCdYcjl9pr8udvXEXOQRu3pXWuA4eq1Qg5sxC6SOO7OFSkWCbYvvdmphH7GRq2ZMbO0axX
	17bShj8HcSfgqS9DGGPZlI8IkK0pmBE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773406528; a=rsa-sha256;
	cv=none;
	b=Fmg838EvuGlT2k+ZXQoyj1RpIV6CO9Pz1RX/WQnDE6AlzblpNa8GaYI4HkJsQk/BmEYQNW
	HRXTNe9RHeh9A9LCXF+2rx0OK+QQYkNFNGJSX3f/uf8DgoM4fv1GfzxUPX9Rw285hfPSzo
	FhsTN/rvJgJvW9xAjwIwKTvKcN80Gpw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=SWH6jPaU;
	spf=pass (imf17.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773406525;
	bh=NCXnzrq2A1QW1RDxmrjE1LGSy0pWXHheSFQWOUDwhh4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SWH6jPaUpOc3lGvw4TCDoo9W9Qn8tDU5LLjiQ4Y2ipCzP5m0UNuz4qx985Bz86alW
	 HsnvE3FN8+MU+C3dKMVbcL+ZWAHDWEVCa+Joj0mHbRA/BlCxJ3Uu70ho/zICVwFnZS
	 ItST95C90KB0MCDO2jcaNKBYLRjSF4QURroz3mtmS8uRY60G5Zvnk1ooycDIjOEaGr
	 sZcTun1BZvCMRQHvWtDCqaqmr752DfIWLzzw50T26bQPNOnziS+Eyf7Qs626Fbn0P0
	 LzHqJT7pWSC2pHctShTxBS0dJaJue3+tn8aGNJZ2cYuCB/IUnNfeVKYGjTYxwm4rOr
	 +BwojEDw3hgVA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 17C2717E0222;
	Fri, 13 Mar 2026 13:55:25 +0100 (CET)
Date: Fri, 13 Mar 2026 13:55:21 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Biju Das <biju.das.jz@bp.renesas.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>, Tommaso Merciai
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
Message-ID: <20260313135521.07823792@fedora>
In-Reply-To: <20260313134328.3166c4d0@fedora>
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
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 738FC4000A
X-Stat-Signature: inukosgqfoh5ubp1sgbsy3qaosqoq5fs
X-Rspam-User: 
X-HE-Tag: 1773406528-595103
X-HE-Meta: U2FsdGVkX19MdNR5RjnwOwmkYFv3iUz2MsoeZejcNRzPg79KVo+UJdVEXrTbFHFrXK8dOdrOqr1I7vfvzVR32DhX1Q2GdEQOc2wCKEVWwrlFyUE0uNP33zim/F+34DhZ0uALXfVddFOfDzp+lnVbmCL4bOETFK6LAZ63oB22y6vyZCbVVvIt5c7Vd3k4zuh/f8dBpCZdLcP9oAxPXr3cHa6TS0yC4gD7HW5fpJhu6qMPDtnWOKgwryV2T10CuChppW1fc3W5BcTCTrP5avYPz0z58OHKJ/6cRmT+0BujeOAwHK0vL7ulFvRef1mGEMYPl4c5BTMGWUN3vKszdymopudTaKtNMNJtFd7E34HgrejfKF0HZ8Afyq0rg/dxiqfaHqjF3DTBZmgCsdmvXgk3cT6T4VYyUm0jQIqhGjNvWuygEgPdCpVcwW3VOo6rwtNTAj57pQxadZ0AFA6+7O81NaKn2khCxg1ieZwQyFAOkOrDN6wnEd0Xkol4qYfvL1TzLbM7GRd1G80gIOwq/DGEZRAA/muLnImee2YERGn4xnXnPH4JJ6kX5MUQKs3PSgJiopcCIJfKojgliB/qZYd8zIkUfAAOLtfHOhQervkJA1BniS89+mqfzLFDO344j/gY3AF2YrYQAmNTmmYsXVQsRrx5Oc2T6P/Bzdv27k+2nJ01e2AHy3W6FnHRIwVasF208pqCESD7DHB3IOZIYKFLLie4y3c6tFH6LGd8VFPP5PADUNi7TYtkxbEglZNDjtWuRmZv6aBf92KVaDixpwJuQSv4R+hHRzbY75K+E5U7y3XC10Pr0BL4ZeMOYlNKIhiuFSaZ8p6we1RHEMbm4rzpy7L5NKw384LwyBctDIEcrPE+6NgvIvedHPY5B9qxuoLULDTqLyyCKNYmmmdcFCPVSNxC3c+iG9pxdoItelMrWyFM/r1jkHA/lvxNDxwBKMIzq7QvTcWDpPWCj7cyHu3
 SrreS9JO
 10oIQto+J+BFXviaBs75qfw8uIodDkw9Q5udb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 13:43:28 +0100
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Fri, 13 Mar 2026 13:18:35 +0100
> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> 
> > On Fri, 13 Mar 2026 12:04:25 +0000
> > Biju Das <biju.das.jz@bp.renesas.com> wrote:
> >   
> > > > -----Original Message-----
> > > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Boris Brezillon
> > > > Sent: 13 March 2026 11:57
> > > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> > > > 
> > > > On Fri, 13 Mar 2026 11:29:47 +0100
> > > > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > > >       
> > > > > Hi
> > > > >
> > > > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > > > [...]      
> > > > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> > > > > >>>>> +		return VM_FAULT_SIGBUS;
> > > > > >>>>> +
> > > > > >>>>> +	file_update_time(vma->vm_file);
> > > > > >>>>> +
> > > > > >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));      
> > > > > > Do we need a folio_mark_dirty_lock() here?      
> > > > >
> > > > > There is a helper for that with some documentation. [1]      
> > > > 
> > > > This [1] seems to solve the problem for me. Still unsure about the folio_mark_dirty_lock vs
> > > > folio_mark_dirty though.
> > > > 
> > > > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/      
> > > 
> > > FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.    
> > 
> > The patch I pointed to has nothing to do with folio_mark_dirty_lock(),
> > It's a bug caused by huge page mapping changes.  
> 
> Scratch that. I had a bunch of other changes on top, and it hangs again
> now that I dropped those.

Seems like it's the combination of huge pages and mkwrite that's
causing issues, if I disable huge pages, it doesn't hang...

