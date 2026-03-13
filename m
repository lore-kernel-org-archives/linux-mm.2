Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCA6105F7A4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 12:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47BD6B0005; Fri, 13 Mar 2026 08:43:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEB36B0088; Fri, 13 Mar 2026 08:43:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B350A6B0089; Fri, 13 Mar 2026 08:43:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2CE56B0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 08:43:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FB0B1A010F
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:43:37 +0000 (UTC)
X-FDA: 84541006074.27.EF4298B
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6CA26A0004
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 12:43:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=VFDaKRdD;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773405815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vDOsE+r3zQwneCpP5dg28qkqCcVIVxRzf4RYCMNq6U=;
	b=GDGetrTXsYS64M0nFetEeGdxfq2qcR0RHG9uMqN4pOBqNFgNjqadQ3iCWS1BJsv6n7tz91
	vUOO4FtqdYFvQfEdR1BgZjJluUC02/HEpdsr5Vi7FhyUDRLIweX3SlengjobcK0phbHOui
	eHvFkBLcau/9wX0krse+Dl0a33Uf3k8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=VFDaKRdD;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773405815; a=rsa-sha256;
	cv=none;
	b=rjnAJvAGxwiad7KvIGSDzZfo4o+zeOkvqcS5wczsIlerH7vEvDPQ0Auf0cSCE6hLrQFKNi
	jm0RNOMmJ7OWZ+24J4GZ08+ZgKipn0FASCr7RV2G0GCliOMC9rD7ad0BZ65h/66GpPZ9/9
	pZTkaByXMaAvO7irzAkuZFbx723z6dQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773405812;
	bh=7Pm6mMExEx5lWIW38xNWnPfp0ZKZGLwsfIxn+Dyg4g8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VFDaKRdDnGGghZnpZSW5mYj6SElB0veOlaUHJBhuFwiI3B9kWjoza7aYGqqXgqzov
	 VW1C5bH1/NQuk5QKAvSQFMwNgHRxYhOFrYwdi8pGsEFaZvdUWDTNeDV13YBGfon++x
	 M9jTcWmLZs94YinJ977RvGdsMFkGLLthv7ULiu2nV0eSUQ5GOCo91T5sr5BgnbAh2G
	 6aPoOKsoYa5GU71v8sxS5d1SC8KxdkibvS/QtxyKqQFobAAVyL8TBsHb18xtFip/26
	 Pj/x4fZ7LjZ44pQbTFE3me4vTBuzFtzE/ipkQporhzIvByi0mux4US8NEcuf8jOP8S
	 fR5XDqhUjKp0A==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 1DBC717E0222;
	Fri, 13 Mar 2026 13:43:32 +0100 (CET)
Date: Fri, 13 Mar 2026 13:43:28 +0100
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
Message-ID: <20260313134328.3166c4d0@fedora>
In-Reply-To: <20260313131835.52c5c935@fedora>
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
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6CA26A0004
X-Stat-Signature: x1a5iyk88iqs4f6e38yjsmg4geh1u13x
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773405815-412920
X-HE-Meta: U2FsdGVkX1/PgsfylUceT67K5dfMr2p4wozf5Gyjizg8F7ilxUn62W2gbtteirDyF6Qz+cCWmWOyF3B83VkbDkeolBJaf0TGBLrD9qs381mJ3HLtyHrwt7wDyHcBSRINnOk/itOLEcG3mfIiAyIuBNjaTOp8WyMGBcCOGB67JVK+/rl3QRQyM6HimOsYI+qoFNylYSxhhoHP8r/Ha3CZGCRnKP1TW2W2Va6JER9m3mjpFSPZQ8bX+ABkkGVGxmlJXi1eIGQZ+k3tXRHc2Irpe9wGUnASwwbrClngynKX51++FfVXMy6cx4jw0fGrPHkbArCjDXc/jRRbC7idpSkQqrpWxu+O6Pa0PkZ2ff7OaMofvEJW3u3gCUdoXDuilPv1o6PqcMzyf30SHoFfuLp288UnNE0JOy57he4KswecMexnz7iEnXB9ldC5GvDY85UmpJ3qNRhe7rOeZ0rzBslHN5rDpWhVyAK8xne6T3kSkqwa4ex5FmVi65dIaqBm8+UZe7TU9+q39O5z2jYEoVa1NAv31M5o7CO1HkZOMHWd6FDto4YZwGpDKgVOH5ge26vuQISgEOtSkVSXsAgqhX//xtRyst5D8cEkODtRDFf0VR8oYZyCmoXa4Cp04dDKGWdytevFB31cbm8gjrm3xsP8mWMtN4VWf2sJhIQYHr1LvMy4W3M8XV6FmCXZ4z7NeQjnPgaqS7eYtHFSmaPbT+dxs3hqsMonrsDbHxu+jxfmImrscW9sdQd9qBOzZggGX7sS2Heg8E7RmkAyiIitwbua/EgmibdakgQHdCaqBELn0lQLdz6mDB6Lqu3CRelAK9Iesa6VprzdMZ3XWdx1yxQgU9oNgpMfkNTYdZdH/+jDw1nsiNLWZuSxr/DEkz4quddYCIK1eTtY3itIved5auWejPbZsiscPhGQAOfT1Zxj+UKi5SqLtpi3CYIg6LIUSmZcKZyRu6fnZAwkiL3Gvk+
 I8dZTbXv
 aF+t003kXS1gsVpYgh0Pre9bEmv0iRH4TEkY7pPXZnZhcPTeOOdUW+Bt6BN3OsOdzcbj96M5ighzMWqpd8DydQ7lIYYr6FN5maP8/yz0v8PO6+b2RlnyHkqz9xQpVUcOqDZY0WaxHvpyp8Q08cU0OslRfXTyO5OdzOiPFGM15KB97GB/Q3CpFyOwLFRE64kGH4iHDWP48ApX6izWi90VQXIpe3GbfFxxL78RTegGOPjn4OmhKHGWZyKOYIIZ2XzKZOuoAazypvqSgBqBMfrfMdSXacHmB0+plHuNjVxDkpHZcWPxmxV8H08tyaZqWyx3LU+17OaG1zSLIZws5GqVY4Ldt8MkboBAadCEk0RkCsLtK5Hqrdkq/RH7RpxQclOqF3K+jhOVOra+MS2XfRQhL5ghpGz2TNXrHO5gV/06TsFqMr8ng4VEE93r/aihube1Hx6QofXQefANMVPyJMt+Mzd9Y6iKhL6ceE1x9UnNAvGWAd8KxpItRjhS9CrRunc9eU6uJnwCrOZ3vW0jv5qNJLVhiv50BR0NTsdEiZ2W2PqSF0VaJ+Jkg/bB70mLINomPxPYRisVfZFBN/Qo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 13:18:35 +0100
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Fri, 13 Mar 2026 12:04:25 +0000
> Biju Das <biju.das.jz@bp.renesas.com> wrote:
> 
> > > -----Original Message-----
> > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Boris Brezillon
> > > Sent: 13 March 2026 11:57
> > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> > > 
> > > On Fri, 13 Mar 2026 11:29:47 +0100
> > > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > >     
> > > > Hi
> > > >
> > > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > > [...]    
> > > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> > > > >>>>> +		return VM_FAULT_SIGBUS;
> > > > >>>>> +
> > > > >>>>> +	file_update_time(vma->vm_file);
> > > > >>>>> +
> > > > >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));    
> > > > > Do we need a folio_mark_dirty_lock() here?    
> > > >
> > > > There is a helper for that with some documentation. [1]    
> > > 
> > > This [1] seems to solve the problem for me. Still unsure about the folio_mark_dirty_lock vs
> > > folio_mark_dirty though.
> > > 
> > > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/    
> > 
> > FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.  
> 
> The patch I pointed to has nothing to do with folio_mark_dirty_lock(),
> It's a bug caused by huge page mapping changes.

Scratch that. I had a bunch of other changes on top, and it hangs again
now that I dropped those.

