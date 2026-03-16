Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A66C1F4644D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5E06B019A; Mon, 16 Mar 2026 06:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E69906B019C; Mon, 16 Mar 2026 06:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D88EC6B019D; Mon, 16 Mar 2026 06:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CAC3F6B019A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:54:02 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72382C080E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:54:02 +0000 (UTC)
X-FDA: 84551616324.19.681E3F2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id 889A61C000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:54:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eFppJ663;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf21.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773658440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QePMrUscrAyIHF9jGIWiLGXYna1M1Uo0MIGaLShcaF0=;
	b=fgiEIeXQAZ2R9RTJG7EItNl44ozGen8Mm/GHQwhhdzJGFlxrplP2ULnJe0Q7KWiRNa5ivD
	KUw3OwAcRUvPtYNCZtQySKvku+USg9Wa4tcvwIWnK02yim3TmzJlM8Z6Z1xTlXWPnHzmpY
	1NSgSwKJZlfau4E/+z607Rsv0RZxePE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773658440; a=rsa-sha256;
	cv=none;
	b=pejuCUisvyhiRaFHe/hjv3Kwfnxb6gXW/TV6qnD3CyyfWfRkNTSyw7lWAdZBNAvt6Lkc5S
	6q1dGHIwWBzYCpZ8W20B+dd0Hd1nl54MX8qf080BY/c4/jDKo3AYjQvBcyXZWk2/mfHjVU
	te7sNBjYpWPOqDGXRbp4Uok+Bg5+4Qw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=eFppJ663;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf21.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773658437;
	bh=3/krYZ6GCvKnFIo/XDaVM+GqnlDdX+4GULBc07rBNEY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eFppJ663mV+RnAiVhVjBzClTNPryo4e15RGAJX7qWbXVQhQPibU7XIgYyqpbTOxsA
	 pCbq6TAz6xn00DcoGfZeJP79fC+kUIaVHhMAYYwtkYY/zG1rHwNjAEaAn7Nt9GJq+u
	 l7KqLlOvNUHDO1aCb2KKl9+z7WLT9bgZSuN4waZwCQh7RRRgJmyqi1D6nFBe14/x4A
	 x4r8WkjRRd0/aM0hWphIj6b+rcDofoepfTEFcZUeoFyw4NcKtoVF5rCXOjOUGhJfxW
	 w2azexyPaYH79DqqH7TAY1oZDQCgrs1BoBcFE9HIqYPKRDO8V8VrOWA34d/rpAFiPe
	 orNi/w2JzV6Ug==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 104AB17E0D04;
	Mon, 16 Mar 2026 11:53:57 +0100 (CET)
Date: Mon, 16 Mar 2026 11:53:53 +0100
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
Message-ID: <20260316115353.45fadc81@fedora>
In-Reply-To: <21f56de3-ec1a-4d7b-8abf-c538584e18b2@suse.de>
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
	<20260316103621.6ed48b68@fedora>
	<21f56de3-ec1a-4d7b-8abf-c538584e18b2@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 889A61C000C
X-Stat-Signature: qqkpuupohz4hxwhzmscr8uhso338o6hg
X-Rspam-User: 
X-HE-Tag: 1773658440-542199
X-HE-Meta: U2FsdGVkX19wickiM2r9O1oA8xJ27CGzXCO9q+bF8565fD7Cg96xWj9j9rqCFW0EjNdeYsRS9nED6aR4acJctzuAHdVT2ZycB8gO29yAso0ZkrE/FbRffXomIcTKxf0SX1Sxo9x8hObxGC/hHaGphm8xZP/lgjBEUCv9mSIa7z1v//womy5324Sn3fyU6+B0GdQx6YLbFv7hvhOlRwGWCsLf6XubvtEaPJMhZg2n8dUG8bPXa7w94F4fgxALJUnH25zVnUvBNeD6O8c2W4T/83FDnAtZJbx64WbiNKIujy9R8uFofHwAaPPTuzk6XUJ67NJGQIPa5F18kzGWUHlUZ9ynn02ZNWwj23zPf5jBEK1skYsnILUI1utQOlVDIpu2dcMoYK7NoX2SqmS7RPQC8HQT8l+u0cX6s5rN7y3UOP4eNRv0bi0aljmI5HpjbfRUNjYe2W314cePYCCP3X7RJx267URvXwIaPCa91oAo/JF0eSWK4Xab1uB28sWwnXXVCH1D3RL7ZjfD7g1nQWG6EKqQ7v3qp6PRTvGGsAbafof3PpHH/wY5sJ0raR+19DVxAXSTixQtWSKJtwu8hJgUWdyuJy5vs3/ag6gE/NpvSY8ZqjSY+9c7ME5NcJoGiw+UUHtVmJYshU14mhd+iWtDrFKf0U+LWfooQZiK2KbKDURuN+/8AHB+uLbww0BPiV/xeVxW5BiPpDVI3IQtwmCOuGkyAIzxkEG04XsRVDutRi5owxEjoLeRZh/eesQOnQV//r25WtswcDwA0/jeF8C3jPU+JwEXDCOjQgcy1VQUiqPPZhC9nF6o2gYqjJrx+AgrixBZBTlUxuvaXw7eEohftcr9E3B37GHQ2CaeR8c8RRVMCo8f/pzXDGFWfDtWAY2G2g2ukqBzpHVB3cx75P5gen5pD/qCRLbXu3wn2NFL9qstXofb72oHFvbbxOEB1lpn8AUIV0BbhQb6DW0bEB8
 SFoIOnXO
 87pqZmQAOghraolyjvVd3/dgnpzFwaf4ozczLuWEN7TVeZMQh8kcVHGf3ZDuDs+M/KdYr+cIHVM7MLsCnXssQDllSfByqTGnxO+iV6BXe0bZJ66IIcgCKEAFFsk9dnV/NjBmdfgmvGTf/ytQtbeUc0fSzhWdoTWw70hh6co2qaYHUViWsHENjf7fvmyW3Ax+IH/uIevD7blB3nMh1RckHmji2JblfZboQ9YLw03EFOuSR+rCTKC7Z0F1JYRJjcZQmxO0s+H2rfUsYWFak5NJkfLGWHfhMSUTL8EYYglP7sfB6lxYcSnpwqhsDbuzk2eL/PwDxwoISawdYYSHApobRf3KBnMuM7wioSLH1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 11:22:49 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi
>=20
> Am 16.03.26 um 10:36 schrieb Boris Brezillon:
> [...]
> >> This would keep the huge-page code within the first branch. And if it
> >> fails, it still does the regular page fault. =20
> > Well, in practice that's not what we want anyway (see the other fix for
> > the huge_fault vs regular fault race), so I'd still be inclined to have
> > the folio_mark_accessed() handled in the common path and have the pmd
> > vs regular pfn insertion in some if/else branches. Something like that:
> >
> > 	if (pmd_insert)
> > 		ret =3D drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> > 	else
> > 		ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> >
> > 	if (ret =3D=3D VM_FAULT_NOPAGE) {
> > 		folio_mark_accesed(folio);
> >
> > 		/* Normal pages are mapped RO, and remapped RW afterwards. */
> > 		if (pmd_insert && vmf->flags & FAULT_FLAG_WRITE) =20
>=20
> This style mixes conditions from different branching depths. The first=20
> outermost branch uses pmd_insert to compute ret.=C2=A0 Any then both have=
=20
> changed places, so that ret is in the outer branch and pmd_insert is in=20
> the inner branch.=C2=A0 This is hard to maintain. It is already confusing=
 now=20
> and will be even more so to anyone locking at that code later on.

I guess that's another occurrence of us disagreeing on what's
easy/uneasy to maintain :P. I find it way easier to group things by
functionality (here that would be folio state tracking) at the cost of
having conditionals repeated (I trust the compiler to do the proper
optimization) than having multiple paths doing exactly the same thing.
The latter easily leads to one path being updated while the other path
is left behind when new features/fixes are proposed.

