Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A623E81BD6
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 15:01:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8168E6B00A0; Mon,  9 Feb 2026 10:01:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7363E6B00A1; Mon,  9 Feb 2026 10:01:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BA0E6B00A3; Mon,  9 Feb 2026 10:01:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F4856B00A0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:01:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC0CBC0A20
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:01:19 +0000 (UTC)
X-FDA: 84425231478.25.86403B2
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id B30FA18001A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:01:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lcdXVf1L;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770649277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXGnnQUcY2aOozzzIKf6y8CmmXN5VARe55Bh5Lbx7Ro=;
	b=pLhVNfQIXXsTUb9FAWekEEE8RPEtaPaORQopz3/SXKBSLnYIf3Hkj3JGXxP5qAX9+7rfd8
	MOIAzBXOnW0nZifykiqks9nZJPwC1E34ApEfrfTfjPLRtgaKpG+lsbbM3Vj6NUGyLR62YL
	sUOZ2W17UQtbtI6QQl4hafZ0xfcElBc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=lcdXVf1L;
	spf=pass (imf24.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770649277; a=rsa-sha256;
	cv=none;
	b=m14+20uTvxQlUD+y2R/2UkPGbgNppbe0lG+NzCDexQKWqV5NP5yJsJrOjOdtcOWv1tnDCl
	ydHi8j6p1xLZwVTNXyuSsXP3mUISO2q2NQk9qUkhPadewiOyCyNY5pHc///QcBPJQcarzO
	UuAQcO+SewQAZDJB6Bv5Q6XAzX91xeU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770649274;
	bh=2Jn6ht9R44NVLk0YTLUNGVwTRbNRIHRw4ncSbNE5+Lc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lcdXVf1L5yg0p/y9x6biLEMw1DINlbMW4X95SONyD4ld0EbDvHzS1bkT7CNbO4Uzp
	 XxXBE+qUzdmMpqwAZxsKySKV5VkgNiv580PwhHr4tpFjCm//KFbLMZ7A0Da2x4wGQt
	 TRxlkmIK/A9nNJ2lkmcLiFf52US8l5HqEkakigsI3Jhlo/7i+NvifzAp4ZaKK06keT
	 ZSvcxO2/vMCqtpm/MmICIRqxWySpmQIGsSFNLm1v5mLUA8Ai+hwUjCfOyZC+7gRpH8
	 IkjUXP0bc0p7ufU6EFBJLSc3gwRpCEXxfx0HQd/PYkTyeVXO90UE14gwBoNKC2emew
	 UJhdxYD4L/pFA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id A229217E13D5;
	Mon,  9 Feb 2026 16:01:13 +0100 (CET)
Date: Mon, 9 Feb 2026 16:01:09 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: Thomas Zimmermann <tzimmermann@suse.de>
Cc: loic.molinari@collabora.com, willy@infradead.org,
 frank.binns@imgtec.com, matt.coster@imgtec.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, airlied@gmail.com,
 simona@ffwll.ch, dri-devel@lists.freedesktop.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 5/6] drm/gem-shmem: Track folio accessed/dirty status
 in mmap
Message-ID: <20260209160109.79a020ae@fedora>
In-Reply-To: <0d00a0f6-d0e4-41db-b48b-77157cd2e968@suse.de>
References: <20260209133241.238813-1-tzimmermann@suse.de>
	<20260209133241.238813-6-tzimmermann@suse.de>
	<20260209152340.16f9b30a@fedora>
	<0d00a0f6-d0e4-41db-b48b-77157cd2e968@suse.de>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gqddrscwwhrorof7ojc9g4dhsd6xqrid
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B30FA18001A
X-HE-Tag: 1770649276-508104
X-HE-Meta: U2FsdGVkX18bLKN5b8QwH53JpiMQH9asbPLueT7/v73Q1pu7bx3/aTd4eylhl5PeESznZRHL4hHRicAXVplyo6kf2siKqunVQLL55YtGRybr5xtye27jqWnVGJ00bPT7Oqu+ylou5ke4s6ZhoZtUgQUl3lnWi4zRzll30IHVkwSS1yXutgQJ3RKgUWtdvF9tB4RlBRjWyVoT1es7gn+wxwB+EmcauQJYEa/A/NNBy7UKCLVkaSHte/sGx0hrZkS3pqV1RWisvnlMHGO5OQDOujxeS3e5zMP91meOnLbMraFHoyHxxeYCB7fioaTwIpcKMS+BXeoxJXXpVgEnkcwGCLeG8FG676yxx+NmNPNCHko45eFE6SpTGfwv+TbInACJzOk5gZSnkHutn12MG5YJUgDKfaqHMp5Bo8ZC2tHCwFh6NkuHNqTE1wL4n7ppr0K7y7+6IHhNhxROJ2D5gpzUjKFX5AFGooH4L/1+dpmz6cHLWf6YyDZfXAGEjaMAvGeLkJjYssjXBd9b4XSC9VZbUCtYv06amOe3C/VBKb15wSe1z37uufnDjrRuz9KOb18YCniFJ+qQiSPG+rxviQzNU8xLxzStFT7gqXhSYDDSmxIT8WojfdrV2u3c86m3SxTxZY8iDM32oXy2Y5ffG2Q+Rz/pzdKjeiCptcm1FIPmtyK/CRQgiFg3h03HH3sASVSJts0dJGwEoGeGDyBXvW0tC4Gq5LVelLQLmFe/56EgW1krIw6yPRIjcGovYU1hHDh5Pog56YIZ02ajTwvC5+fJW2B+F2IZ+0qRyAxAhP9d2AwkPWAZuFj7BhHtRpC3LPawhoLd1nwEYq+hN75q2KyjvOFYeDHUE/s0vr+S4kRb5NiBLIyZzUv5AYpYmDB8NltsiqgTFbISMwqZ8EPR4b+HZVjM3DwKOI4N33lH5CGn02t6HVKCiJ1xUOk0K6fjOsnX81i9/qO9FAZcLskhrw7
 nfMkXzKk
 SDRgs7TVzLnCA1un28VPsPcOTSl2b5KiWLPfizBpe0yNXlShJusRUlvFesui/mNvdaeYZeZ2Vpwg7Yj2J/38KbtnOs53Y/1abxtSVnqBzenXDM6Q92bfPIfiVUKA2sE6QwxctghQdBGhS40v55fhpThqUVMnqeaaT7ItNOxiPdfp5jivEQWG3AoMXQjIUjYNNa9krmsvwq7ZHvJOFf9pDpIJK43dwh66nFIjIgroY+YuVQRSFyhiC0sXfE8/gPRlVbqzqaiZb/AIFhP1btBQ5ZcXQb9ilf1wPr1Be6Wkp9govj1yq6mrJt/+KEEN9teUzsrl0rRLnPTBf0n6Tpq/jUFJc/UoD0N6RkIwhkm6j7KmcVKv2cabPIcB8kJW9aFNNIWpoo1megldJF8aHqAYeESI0dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 9 Feb 2026 15:46:21 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi Boris,
>=20
> thanks for reviewing the series.
>=20
> Am 09.02.26 um 15:23 schrieb Boris Brezillon:
> > On Mon,  9 Feb 2026 14:27:14 +0100
> > Thomas Zimmermann <tzimmermann@suse.de> wrote:
> > =20
> >> Invoke folio_mark_accessed() in mmap page faults to add the folio to
> >> the memory manager's LRU list. Userspace invokes mmap to get the memory
> >> for software rendering. Compositors do the same when creating the final
> >> on-screen image, so keeping the pages in LRU makes sense. Avoids paging
> >> out graphics buffers when under memory pressure.
> >>
> >> In pfn_mkwrite, further invoke the folio_mark_dirty() to add the folio
> >> for writeback should the underlying file be paged out from system memo=
ry.
> >> This rarely happens in practice, yet it would corrupt the buffer conte=
nt.
> >>
> >> This has little effect on a system's hardware-accelerated rendering, w=
hich
> >> only mmaps for an initial setup of textures, meshes, shaders, etc.
> >>
> >> v3:
> >> - rewrite for VM_PFNMAP
> >> v2:
> >> - adapt to changes in drm_gem_shmem_try_mmap_pmd()
> >>
> >> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
> >> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> >> ---
> >>   drivers/gpu/drm/drm_gem_shmem_helper.c | 20 ++++++++++++++++++++
> >>   1 file changed, 20 insertions(+)
> >>
> >> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/=
drm_gem_shmem_helper.c
> >> index c3a054899ba3..0c86ad40a049 100644
> >> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> >> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> >> @@ -598,6 +598,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fa=
ult *vmf)
> >>   	if (ret !=3D VM_FAULT_NOPAGE)
> >>   		ret =3D vmf_insert_pfn(vma, vmf->address, pfn);
> >>  =20
> >> +	if (likely(!(ret & VM_FAULT_ERROR))) =20
> > Can't we just go
> >
> > 	if (ret =3D=3D VM_FAULT_NOPAGE)
> >
> > here? =20
>=20
> After reviewing the code in vmf_insert_pfn, I think so. All we'll see is=
=20
> _OOM and _SIGBUS; or _NOPAGE on success.=C2=A0 I'll change it then.
>=20
>=20
> > =20
> >> +		folio_mark_accessed(folio);
> >> +
> >>   out:
> >>   	dma_resv_unlock(obj->resv);
> >>  =20
> >> @@ -638,10 +641,27 @@ static void drm_gem_shmem_vm_close(struct vm_are=
a_struct *vma)
> >>   	drm_gem_vm_close(vma);
> >>   }
> >>  =20
> >> +static vm_fault_t drm_gem_shmem_pfn_mkwrite(struct vm_fault *vmf)
> >> +{
> >> +	struct vm_area_struct *vma =3D vmf->vma;
> >> +	struct drm_gem_object *obj =3D vma->vm_private_data;
> >> +	struct drm_gem_shmem_object *shmem =3D to_drm_gem_shmem_obj(obj);
> >> +	pgoff_t page_offset =3D vmf->pgoff - vma->vm_pgoff; /* page offset w=
ithin VMA */
> >> +	struct page *page =3D shmem->pages[page_offset]; =20
> > Should we have a
> >
> > 	if (WARN_ON(!shmem->pages ||
> > 		    page_offset <=3D (obj->size >> PAGE_SHIFT)))
> > 		return VM_FAULT_SIGBUS;
> >
> >
> > ? =20
>=20
> I left it out because it doesn't seem necessary.=C2=A0 In the fault handl=
er=20
> in drm_gem_shmem_fault(), I can see that we could get an OOB access. But=
=20
> we only call pfn_mkwrite() after going through _fault() first. I don't=20
> see a way of getting here unless we've already tested for the page in=20
> _fault().

I agree it's not supposed to happen, but isn't it what WARN_ON()s are
for (catching unexpected situations)?

