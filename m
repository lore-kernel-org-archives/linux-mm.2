Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA82C107BCD0
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 17:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211316B0088; Fri, 13 Mar 2026 13:46:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BEF66B0089; Fri, 13 Mar 2026 13:46:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A16F6B008A; Fri, 13 Mar 2026 13:46:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF7786B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 13:45:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 95E6B1A0282
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:45:59 +0000 (UTC)
X-FDA: 84541768038.14.CE8AAC2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9074714000E
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 17:45:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=QbZ8IcW4;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf26.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773423957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jT3Ic7K943eCVdL1yBCzSGEjIRzk6AZraG0sDVfNqqI=;
	b=aWwFEsrL+tE+fYPn5tx5u8XpKw03yDifDwtlBOx1a9WlbkBRqpRvDpMHN55Y5SKCvrD+AN
	/icB2LyvRNd34XN8Wpsgei6or6Eh0qoFnRJA/oJx83EBwsOyXkKtRwsEq6o8aREYMXy/Hq
	vyjKMLItjfP3dpHfdN6Cvi5hgXk5z3g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=QbZ8IcW4;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf26.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773423958; a=rsa-sha256;
	cv=none;
	b=l/X18cNcpE0s9Qx5T7u+gEBfEXt4a3VDr9KbEFhppZhPhEKxbbjajGfRxNKR1JCB1eVWtN
	S1hYbLuqYa8rvEvUnn7aEedK1BcsO5+yUVN5ppMvFdQOUU/H89XiLumfRSk4TkspWsWkjU
	YDroi+Co85++tcRdCXNtZIaZJkEjM2c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773423954;
	bh=T9aamq2yo0HMqv1Jkdy4l6sGV0d7EEk4IPc7FyjxaZA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=QbZ8IcW4JHGAMYXu00b68izz85X/OeSPnxidT+oajlEnYp0fQDUw6qBGK5zVwAFj0
	 rsW+lBsRYU9vvg1Ekauiunq9R/JnoTZ8eakQf9qQIrRrPjQ2c4xFEmtUcgbb1hIViN
	 4g8eeLbSg3vyfY8MtO3Zb2ASD1/26tV18JhYuKJJfltB2fGAwN+rC4LdI8DfEApLNv
	 BKSdvOaL07HWWIstLMeRhCHk0CR/g5TGFeZKIHRK2dUcDoKX3GmloqJkt3vjzWepgr
	 TYoj41wQYZpQuxwkpWFtS7VbgdSQbWqSZaOI6QRq60XQO/GhlzgvYc/1EL6en/rhOQ
	 65xJGiKB/HX5w==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 4C1E717E127A;
	Fri, 13 Mar 2026 18:45:54 +0100 (CET)
Date: Fri, 13 Mar 2026 18:45:49 +0100
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
Message-ID: <20260313184549.08656eed@fedora>
In-Reply-To: <20260313135521.07823792@fedora>
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
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9074714000E
X-Stat-Signature: p3n7xu1hiz9yz583b6d1cii6pc1h6zyx
X-Rspam-User: 
X-HE-Tag: 1773423957-259813
X-HE-Meta: U2FsdGVkX1/3EnrdCy1rmee/UQHFoUAFD+cK3brvDfLNxoUAErmmf68Gt7c8hnbNTmRCyT4ih+M5lkrjF/6lfQRqGUCP/JpgbEOiVt8HUow96SNwaQPJvNWVHwj4E180O5rQJCqWjjdJa0hblIMHm9AESu+Plx1j9Hmcefhr6RAdU279+2tficXnXH5/u4z6uGrfg7bJK8FaRFeJ9ClvV1mg/MOZHRhWE+FonanD7EiRcAt8qNcDPFQUXb3F4gyWwDUeA47ND6rVdC3ZftwsyOdhVVY3M7vrMzCe0A4xaAc+h7mBKIsbPUj5l7zF3oqfx6kz4ZhHDlVLuqJlSjZoP7Sr5sB0KDkXuxjsdg2I/XXdpgBB85uDw9Omr1yMxaAUtDIriHyntwjOekaET1avoroGg6Z+dd5DzjUowWvS5q9pKV51YsKlcaUwcCgK5N2s6bUcSXQX3yHPqu7qBP6rlsZtvodJhVbaJf2sONX5BSma6GW4WaeCAVxu3sjgQ3N61aio8WtRZdfoNf1KaGrRLFHIzom10dO51gdR6prM55GufpP3Xjj+xxC6lweIZbPCkWAu2aa2tG4EBaGWnd4RJQQh68WcLNFP5EyNNsot1XDesG2v+owrM4hh+u3bXyoWe5rrUAKxnzu6PvXqTbhl+Vcm38h0lXNPGa+gWknyUKuxRgQsp5mXSNfGN/43tOVsIJKjQMzo/sdI+UkZGXJQx/upNOFS2/xL58eyVVSrPPXaWZicdC+DRNBilBcNEo/4LchLpUYW1NqXG2AY/t+tfT3CUb+9Yw4qfE6PqYSPOMiBNeOTyDcAFu2JeydARGlrL/L56tfgPvMnC0zH6pWJERhgJijJGB0kmeUaHdxdLrni1ojnWcq4alhsL3KObky6bnhaTscaHj8H47aouM91nyKUiiU/ijJOr3aLM5djh8d5zeIRGBpoUBv3OBVYa7IjKWGOGEnuEhYhI8MP5os
 p8gnrii7
 duuIAi9NlASGruTXXeG5hG3lRVyAbOdhK6ToXqkAErIRiTC2FJuBEp7JrExohqJ2sc9kVA1ajY4cljwQmsDgCWwDxsx64ShJikEOq/WC9A+2R3B9ss0UmvzbYlvodxGf/p+GUhZnZkIvh81I8LRtYq6QmC8G6i++K/l+z4Lwo8zq3BmEV4XxW69MlKrf8K6FjrhCgp+HRyh8Pgn9xEJ0btzypAmnyhTEJDYkV88GvjCPIlEPtS+kPo7DBvkKfG72PtIJZfS2Wu0t3xVqCv1LdwoxV4eiyUpE/kIT8ciOu+MCki4OLwGlki3OswPXgSBRa4Bu6MdezuDb82dxCHm/Vp8ykby9x+oDD71KnYxdE3uV4+Qt2xE/Z3kNEGhEcf1cHme/kCoQ6DIbg9vRw1fwt/uvu7TunxM4d1WTEmOfyKxpCtAbQ4baRCW3Yy75j3MWEhT0JDyCmUVYde/FcyaqbJ+hR5A6tmS7SkxHJaS1y/2eHPqsPzhoaouUGtAxSBUujI2UUpCGolhS8acW0LDv8VuPoZfDSXqL1moI2+KY7DYrg9//q2vJhNHRpibu7nYRGhRVslTYAuvX4FcA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 13:55:21 +0100
Boris Brezillon <boris.brezillon@collabora.com> wrote:

> On Fri, 13 Mar 2026 13:43:28 +0100
> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> 
> > On Fri, 13 Mar 2026 13:18:35 +0100
> > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >   
> > > On Fri, 13 Mar 2026 12:04:25 +0000
> > > Biju Das <biju.das.jz@bp.renesas.com> wrote:
> > >     
> > > > > -----Original Message-----
> > > > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of Boris Brezillon
> > > > > Sent: 13 March 2026 11:57
> > > > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> > > > > 
> > > > > On Fri, 13 Mar 2026 11:29:47 +0100
> > > > > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > > > >         
> > > > > > Hi
> > > > > >
> > > > > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > > > > [...]        
> > > > > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> > > > > > >>>>> +		return VM_FAULT_SIGBUS;
> > > > > > >>>>> +
> > > > > > >>>>> +	file_update_time(vma->vm_file);
> > > > > > >>>>> +
> > > > > > >>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset]));        
> > > > > > > Do we need a folio_mark_dirty_lock() here?        
> > > > > >
> > > > > > There is a helper for that with some documentation. [1]        
> > > > > 
> > > > > This [1] seems to solve the problem for me. Still unsure about the folio_mark_dirty_lock vs
> > > > > folio_mark_dirty though.
> > > > > 
> > > > > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/        
> > > > 
> > > > FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.      
> > > 
> > > The patch I pointed to has nothing to do with folio_mark_dirty_lock(),
> > > It's a bug caused by huge page mapping changes.    
> > 
> > Scratch that. I had a bunch of other changes on top, and it hangs again
> > now that I dropped those.  
> 
> Seems like it's the combination of huge pages and mkwrite that's
> causing issues, if I disable huge pages, it doesn't hang...

I managed to have it working with the following diff. I still need to
check why the "map-RO-split+RW-on-demand" approach doesn't work (races
between huge_fault and pfn_mkwrite?), but I think it's okay to map the
real thing writable on the first attempt anyway (we're not trying to do
CoW here, since we're always pointing to the same page, it's just the
permissions that change). Note that there's still the race fixed by
https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargomes@gmail.com/
in this diff, I just tried to keep the diffstat minimal.

--->8---
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 4500deef4127..4efdce5a60f0 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -561,9 +561,8 @@ static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(struct vm_fault *vmf, unsigne
        bool aligned = (vmf->address & ~PMD_MASK) == (paddr & ~PMD_MASK);
 
        if (aligned && pmd_none(*vmf->pmd)) {
-               /* Read-only mapping; split upon write fault */
                pfn &= PMD_MASK >> PAGE_SHIFT;
-               return vmf_insert_pfn_pmd(vmf, pfn, false);
+               return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_FLAG_WRITE);
        }
 #endif
 
@@ -597,8 +596,12 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 
        pfn = page_to_pfn(page);
 
-       if (folio_test_pmd_mappable(folio))
+       if (folio_test_pmd_mappable(folio)) {
                ret = drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
+               if (ret == VM_FAULT_NOPAGE && vmf->flags & FAULT_FLAG_WRITE)
+                       folio_mark_dirty(folio);
+       }
+
        if (ret != VM_FAULT_NOPAGE)
                ret = vmf_insert_pfn(vma, vmf->address, pfn);
 

