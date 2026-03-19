Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97D621090236
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 14:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C293E6B04E7; Thu, 19 Mar 2026 10:50:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9FD6B04E8; Thu, 19 Mar 2026 10:50:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2B46B04E9; Thu, 19 Mar 2026 10:50:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 91E576B04E7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:50:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4743459B7D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:50:39 +0000 (UTC)
X-FDA: 84563098998.05.CB42F55
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf14.hostedemail.com (Postfix) with ESMTP id 38A28100005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:50:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=M8WZ5Uqd;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773931837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vjm+3VevxYP97ctZWWpBU6ykqSUjIHlLbx+Q5HoX2yk=;
	b=ll1NcSS/V2WjL0pobcK2WujEQTi6GFkwqxj3/20dwjFxxxwC7l/1UGY3syUDQs+xZue9hX
	loElAo6JlkopJbLBCJquTGrZy4VRF+b4zeUX3xbPaTOZE1l65JoUICUa8v9cq5zGufxSCS
	FtN/7Mq5jj9wKLNT7bM1ONvdba8zks4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=M8WZ5Uqd;
	spf=pass (imf14.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773931837; a=rsa-sha256;
	cv=none;
	b=n5nQNtiMTjV1Wo+wbLbKGWA8SRnwRFA369sSlCRBACES3mjvg8nGZBc8zOm+P/9/nBNeTs
	zK60g/YL9B0mqs4kstpjDXzP1d5KIwCPyhnXKU71+8wg/eWxBywQGYiDe6MLKj9yzLJTlV
	JJLeQ5tv/9Kl14sdSyMUHiYYGpQqUdY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773931834;
	bh=8uEKlohVDFJIreqh6b7uaXm+Pd0ZHiALqi93j4h6mxE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M8WZ5UqdAO/Qhvi8JhChSPAToE70flx212ykDr+x/wmWttA95vqIXKY2hOF1XSsvk
	 1ekwv07TcvHQ8TSsNkwSUfHfjTA20wQnJ94iAtCxK8Q37eCAs8Fr5qqTFXmzD9m3KF
	 lhuGg5vbZbmvd6Z1tf+Sam6FRn2uOdMCbE2EHW99HGWjj8+Y5sg+hJXJeNc0le+h1C
	 miXxzTIZ4rQ5FpC2fyC6X4V7Q58AlTx6FrExKim8tyfM8JnnoW+yn7lnud+8xWBRS4
	 FYGX2zlRbpXwxfR9r4hfUFY/rGVXR5F8trzNngtfWZZ5MfxzSmfXkJ7ATD3B4kJ1aq
	 QrhAQsYGWmDPg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B7D6617E1005;
	Thu, 19 Mar 2026 15:50:33 +0100 (CET)
Date: Thu, 19 Mar 2026 15:50:28 +0100
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
Message-ID: <20260319155028.291f3157@fedora>
In-Reply-To: <TY3PR01MB11346CEBB1B1A5FCB69D247EB864FA@TY3PR01MB11346.jpnprd01.prod.outlook.com>
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
	<TY3PR01MB11346AEACA195A53E54101A4D8642A@TY3PR01MB11346.jpnprd01.prod.outlook.com>
	<TY3PR01MB11346CEBB1B1A5FCB69D247EB864FA@TY3PR01MB11346.jpnprd01.prod.outlook.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38A28100005
X-Stat-Signature: d59kr3qhude7j8cx57i8puhdrs4pd4w9
X-Rspam-User: 
X-HE-Tag: 1773931837-421005
X-HE-Meta: U2FsdGVkX19U+hLDPQEh6imnmarQSgGMwviTf9tU4rYJ/VfaVhHq8jBGD3E16SBDzoVdTSNLE2rfvnbFcHwy4509sp5T1Mz6QBAe6foiZVxLK3XpO9IOuFB1DkqZhkKznjMSZNd4Ht/+B+0fzvU+/ye+X/XUpMIp0Bq5lDNXIT85hsCLrx7ixNMz/nB32nJaNgl5iRMwf8EwBWuCR1CCVBigbGZk6BBwUGHg0jEEMgTBrDlk8IhqYySwipByvPIxlyLeO8qiRimLHPiAXVK5d4oY2QU//RY66kdg1rWCdyWYsz4eMlKwZKMnpEe1OeBeXtCQOMtQYkLTzzGxhlGN1e9zKvIOp2TNiw+dyyRzY2ZS+YtAkxq8bDZTJ5bsYs8LjZTJbjV/CZ1hzxS8TECZEQrOQnTFFhkUZL4dyhEok2m/CVrALuVP0WBQPUzd9CX+RQ4cmLGKns0PH2DBdYDcursKQ4hqrj/k/Lb/Id3Qpk65yJDgEeO6uOr9mvh1RK3pK9W1YNwVYwphZaikj3m8cR6zSaTSJXOqXK6Qm9HYtz/jy432rfv9so/Jon/xk4tgJA9D2ZoKfOkCb2uIHpeUcBSat4X264u8IKet4XGD2YfoqXiIB3UaEidvkBrNb/PvZa2zY15YiG0Hms5vOV3Grhd9YicNK/37pYUaLSnFS0Q2rWK30xEq1uxRLa5q+EjqjU26K0FKTnyB3SW6qAoVSM0sLDw9eC5zio4NdPf5sXthlHams71Ofkk+UeRJSaGR/UdRI8oBAIKhYv/ovk7CMbUOngJ1aRSHnce+om1+FHj76adFnNv7PokNIT46B972c0Redr5mrtx+cEQ6v6Hp6SnNIP6CZ/M7vFf6jCI+WgZLjHhqw036rxHYCYLlUu6nxR6vlwpUSyYgExIJylYR1H33z7IRHGvKtiOBkX87wh4MSebg6PLLN+dE0Xn5xxB1oN+evdc3fLJ6GVbw741
 XNjluPqI
 uDuW74hE6L0z4HGgoZvHtRd4kGDjWWdxsIk5LIyqg9nsPzbJLVeQj6fMn1ZFL9/0gm6PgATxTimdN8RKUa2xMamQdqbWGxppdakj9A3AHN9/DiCQiPsAGk4YH4qsAggMjR0tORXE2xg/slP3R3KERcsWCt3FvlHEsCVOxR0UQrPvDWjABP0A0KQV+ahdGCi7eIyOOMlN0+IOms236foIb3vO5zEZKM/blv5mBgT2VivYf/crqxQNZQyqVWzO3diC5tHObYDkuEb+CPSmgWT0SNeD5/gawr8Loq0kHTvzpFp8oqbfe47m9/1tqBje0n7hIdXnZTgW4JMHdwYTHxdJmRrYZm8NfNsfb6rStZQwfgN4/WOaxdn2kjDS7Atkbx/EQcLtShUURHJwnq1+RuHPT9ZZvcDdQ0KawTpgg4++bDBRz71vbao++8zHl0k/nuvBjRJv2upFs80ZdGoGKxMWgzIqOEG8rtkQvbpZPclP+1jyZwMZ4VQ1X/4ZN+qAUjshvfwaHc+pXoiUDRRN8Y36KpAu88uoluqcy4bG1CiSp+ooQttOYVZktCbmQry5j90AkCueh+M+k9HwkDp0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 19 Mar 2026 14:17:31 +0000
Biju Das <biju.das.jz@bp.renesas.com> wrote:

> Hi All,
> 
> > -----Original Message-----
> > From: Biju Das
> > Sent: 14 March 2026 09:43
> > Subject: RE: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty status in mmap
> > 
> > Hi Boris Brezillon,
> >   
> > > -----Original Message-----
> > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behalf Of
> > > Boris Brezillon
> > > Sent: 13 March 2026 17:46
> > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/dirty
> > > status in mmap
> > >
> > > On Fri, 13 Mar 2026 13:55:21 +0100
> > > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> > >  
> > > > On Fri, 13 Mar 2026 13:43:28 +0100
> > > > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> > > >  
> > > > > On Fri, 13 Mar 2026 13:18:35 +0100 Boris Brezillon
> > > > > <boris.brezillon@collabora.com> wrote:
> > > > >  
> > > > > > On Fri, 13 Mar 2026 12:04:25 +0000 Biju Das
> > > > > > <biju.das.jz@bp.renesas.com> wrote:
> > > > > >  
> > > > > > > > -----Original Message-----
> > > > > > > > From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On
> > > > > > > > Behalf Of Boris Brezillon
> > > > > > > > Sent: 13 March 2026 11:57
> > > > > > > > Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio
> > > > > > > > accessed/dirty status in mmap
> > > > > > > >
> > > > > > > > On Fri, 13 Mar 2026 11:29:47 +0100 Thomas Zimmermann
> > > > > > > > <tzimmermann@suse.de> wrote:
> > > > > > > >  
> > > > > > > > > Hi
> > > > > > > > >
> > > > > > > > > Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> > > > > > > > > [...]  
> > > > > > > > > >>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >= num_pages))
> > > > > > > > > >>>>> +		return VM_FAULT_SIGBUS;
> > > > > > > > > >>>>> +
> > > > > > > > > >>>>> +	file_update_time(vma->vm_file);
> > > > > > > > > >>>>> +
> > > > > > > > > >>>>> +
> > > > > > > > > >>>>> +folio_mark_dirty(page_folio(shmem->pages[page_offse
> > > > > > > > > >>>>> +t]));  
> > > > > > > > > > Do we need a folio_mark_dirty_lock() here?  
> > > > > > > > >
> > > > > > > > > There is a helper for that with some documentation. [1]  
> > > > > > > >
> > > > > > > > This [1] seems to solve the problem for me. Still unsure
> > > > > > > > about the folio_mark_dirty_lock vs folio_mark_dirty though.
> > > > > > > >
> > > > > > > > [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-
> > > > > > > > pedrodemargomes@gmail.com/  
> > > > > > >
> > > > > > > FYI, I used folio_mark_dirty_lock() still it does not solve the issue with weston hang.  
> > > > > >
> > > > > > The patch I pointed to has nothing to do with
> > > > > > folio_mark_dirty_lock(), It's a bug caused by huge page mapping changes.  
> > > > >
> > > > > Scratch that. I had a bunch of other changes on top, and it hangs
> > > > > again now that I dropped those.  
> > > >
> > > > Seems like it's the combination of huge pages and mkwrite that's
> > > > causing issues, if I disable huge pages, it doesn't hang...  
> > >
> > > I managed to have it working with the following diff. I still need to
> > > check why the "map-RO-split+RW- on-demand" approach doesn't work
> > > (races between huge_fault and pfn_mkwrite?), but I think it's okay to
> > > map the real thing writable on the first attempt anyway (we're not
> > > trying to do CoW here, since we're always pointing to the same page,
> > > it's just the permissions that change). Note that there's still the
> > > race fixed by
> > > https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargom
> > > es@gmail.com/ in this diff, I just tried to keep the diffstat minimal.  
> > 
> > I confirm with this diff, weston is now coming up on RZ/V2L SMARC EVK.
> > 
> > I am just using drm-misc-next + this diff + arm64 defconfig + Poky (Yocto Project Reference Distro)
> > 5.0.11 + Mesa
> > 
> > Cheers,
> > Biju
> >   
> > >  
> > > --->8---  
> > > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > index 4500deef4127..4efdce5a60f0 100644
> > > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > > @@ -561,9 +561,8 @@ static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(struct vm_fault *vmf, unsigne
> > >         bool aligned = (vmf->address & ~PMD_MASK) == (paddr &
> > > ~PMD_MASK);
> > >
> > >         if (aligned && pmd_none(*vmf->pmd)) {
> > > -               /* Read-only mapping; split upon write fault */
> > >                 pfn &= PMD_MASK >> PAGE_SHIFT;
> > > -               return vmf_insert_pfn_pmd(vmf, pfn, false);
> > > +               return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags &
> > > + FAULT_FLAG_WRITE);
> > >         }
> > >  #endif
> > >
> > > @@ -597,8 +596,12 @@ static vm_fault_t drm_gem_shmem_fault(struct
> > > vm_fault *vmf)
> > >
> > >         pfn = page_to_pfn(page);
> > >
> > > -       if (folio_test_pmd_mappable(folio))
> > > +       if (folio_test_pmd_mappable(folio)) {
> > >                 ret = drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> > > +               if (ret == VM_FAULT_NOPAGE && vmf->flags & FAULT_FLAG_WRITE)
> > > +                       folio_mark_dirty(folio);
> > > +       }
> > > +
> > >         if (ret != VM_FAULT_NOPAGE)
> > >                 ret = vmf_insert_pfn(vma, vmf->address, pfn);
> > >  
> 
> Any patch available to fix the weston issue? Still the issue is present with drm-misc-next
> Please let me know.

Not yet. I want to land [1] first. I'll try to post an official version
of the proposed fix tomorrow, though I'd really like to have some
inputs from the MM maintainers before claiming this is the right fix...

[1]https://yhbt.net/lore/dri-devel/20260319015224.46896-1-pedrodemargomes@gmail.com/

