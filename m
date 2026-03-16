Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD0BF46437
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 09:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AE96B016E; Mon, 16 Mar 2026 05:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1E5E6B0170; Mon, 16 Mar 2026 05:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6176B0171; Mon, 16 Mar 2026 05:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5F66B016E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 05:36:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C8EFE55CBC
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:36:30 +0000 (UTC)
X-FDA: 84551420940.19.0195C96
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id BAD3DA0002
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 09:36:28 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZqfE+Xr0;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773653789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FAZxuOuesdOV9NjkSi8fhr6bVpPIXzbaq7Qfk5kbsM=;
	b=Nf2uqjQHsRRkxlkSIvCN+4K8/7IzgL+809XRNNSbr2yCFJB9BCZKhxdMfJX+7j+QLEjHkF
	rnHeNyVDbinaMqhqikt3V53Yi5g3HBtSGM57Nj4IOLPyYYvXbnddoaEaTuRqxRqabzySaR
	+QCH4BiHMZEvGa/cm8kAzhvfmY1Fip8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773653789; a=rsa-sha256;
	cv=none;
	b=zGoI1QormjtIMElk6NaVzCSVa9WzTv7fJ0VsNAUKwJOOmcpy3U6i+KZrzq1O4NBH/xyxAT
	lHyYPOH5Et3YpOe+Owlg4mePNDLMy7YRiiZI2ofIBIbn6VukXgA3BBOMGJHAPx7xROQz5y
	dYogLlGwZYZiCeynARHj7MaPArhIwbc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZqfE+Xr0;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1773653785;
	bh=b6yw9/4PD62KvEkjXC+VuOM1Xiu3UE6oxg4mQOWuyyA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZqfE+Xr0seBjKzJ8F/GeZgHtrYib2K35hJUB+Lc7YPKHX0x/I4OyS5iyI54kKHNyV
	 4fI71r2LukOT7UstwBHdb5acjgQP7kmP3LR5M3C3PGAHLMaCYb6lr38T0BXtKzTD98
	 V9dcyx3rbkvXVN7IrU8VVYckXSUgf+kAmi1JDGy3AcrKit3kG5j3YgW+JDipiy2K/6
	 cK3Q21vuWCHYdntPr6OU5i1wVhoAmbvjuJZWEcuOoptWlWHdNfwJcN5ylzRK/l+oCL
	 0qDICIm6zWndtsJglZ17MGpQ9fGSJ1g2BPUbef9+OxWacRO6bqYqEI90WJohSPbyJU
	 dEqE6qyhlgztA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 39AE317E1330;
	Mon, 16 Mar 2026 10:36:25 +0100 (CET)
Date: Mon, 16 Mar 2026 10:36:21 +0100
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
Message-ID: <20260316103621.6ed48b68@fedora>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: xsxc3a5xkm8b1ukbyu7meicgowcoyks6
X-Rspamd-Queue-Id: BAD3DA0002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773653788-409256
X-HE-Meta: U2FsdGVkX19UPtvbX39O+75l9MMRorDrb4s7frleIimJKyHValJ6KVoFDFELfizLXxQf8QpGpaWZp83hCaBj/8rful9N9a7tQYieOtQlLu0zTOSxI21i9FpxiISBPpf+lcmaPHR0P5KCD4KIw2efy6HSj2H2xLKwyKDqb8lXOyEr8YpML5K+Fc+R/TJJG6SD5rSVTtGsIyrimOfJ3UATMKby7EMxCDKmyfMhyebnVXRpWCOMwR3qc/6tDa5Z4nKptFgAeb0ez8CEYH2ILIeYjyx31Pob36dog224s421bZsP7hkjU1c/TOjj1fZ2S6xaZInPRF5UTUMdY2EkQ6GL0pEBjic3kSCNQTZHmQF0hYUj/UDMjuexo3VFKo+/egW8MA4v8Voy50CNTPXhJYkV9ApN47oplqLMSxxC0KBeBpRmWY9LAscgZqRHpORszUlhDh44b+zZ3nwTHFHe2uILAgYvbp9Mcj+BqlQky5uQCXq+8Ruwz9fZl74GCjQ9JdFBfjl8aLbw3pfj9kLvmokGOGMhmJBJZasWQ40mUCwwF57FeHmEPsnx7KN3emcK+NsSt22kzWkimC0KPn371EbFyiPRgLcnbYTybpDBYSZu7gJxTPFr4TOvP3zw8TtI29qxgaG0T1FnbALRUO2cjfMPARd9HHWsGmMPQdjJBon9sKohUMP1pE0NVR5wqHkCVK+nBHlZHhvzmF3YcYS2WR9t7J3K0bhpt5SVL5OCen+0VEN2YuzeTIomMcIvYt7WnNB53L805wCZ6PC3zLF3w/8ZG+/DpNwe03BFg+fKxcvSHvFMO6vOqDVyOaKbiMDI2eqJktRKzI4AAF3eLU17fuyL3yOSF+fDQveLpaZfVvN5iwl27wOzB7E5YDCVtdndm66LeEzeXcpmhSGSwM6IJMNWj+clBZrFSRvJq97SN0G2ahXRD3AUJeAgfJDQgb2lZTox5lwD25Y5/3wrgbQJH1w
 fTCh2R3B
 IRNIi4igt4+xOstI0fGRPQmkC5bwadfzwR01xnsVjDMQzh48nnVwWLm4wDbZzjVcAu6KoxgCzUqXp/SkWsYLxW1/CL2XhE4UAbEATriaKHE4ZJreQROr0H54MedlP/cTQ4qF9CHG26m2nacInFW9tXlaBNOGnNS4s7QX3vyL5UvRF4GSKloXwjFtqGJTdjrZBUQW4uWCUsILyplb1JKTk0FjVB8MrNNbaSr0p6URD+QRBA6ieJrKpfdw+C2fvSlf5PfIXhwPFSGJqUJTQa/qPfwWAaz7zebr5SQM9TIRR8g7RZj48gYGVf9JnWNsPRRWYboRZDt5iI90yNfevCNIqpW8xpE1YJdzRXueoFKUeXbaAcppwRA0Zwk4QjI/71/FJMVjMDt9fSGtwz9F/HcQMoSUJhATr+hHuIrlyo7R3Rmm9gAIdDVzMGzNSzMsvUaQVqzoM7JmQV0m92Am3IBbX8tPEIwXCftlE0TflvNhvU5wxq5TZqIwCvYvx2bkbUb52GdcRiRMxCOSJI4hIUZHScvSC1idkmtfL8XyHXWwPzTtce1Bf8eD+uMTSQ4F9NKkRXzDS21s5kKvkzAA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Mar 2026 09:45:49 +0100
Thomas Zimmermann <tzimmermann@suse.de> wrote:

> Hi Boris,
>=20
> thanks for investigating this problem.
>=20
> Am 13.03.26 um 18:45 schrieb Boris Brezillon:
> > On Fri, 13 Mar 2026 13:55:21 +0100
> > Boris Brezillon <boris.brezillon@collabora.com> wrote:
> > =20
> >> On Fri, 13 Mar 2026 13:43:28 +0100
> >> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >> =20
> >>> On Fri, 13 Mar 2026 13:18:35 +0100
> >>> Boris Brezillon <boris.brezillon@collabora.com> wrote:
> >>>     =20
> >>>> On Fri, 13 Mar 2026 12:04:25 +0000
> >>>> Biju Das <biju.das.jz@bp.renesas.com> wrote:
> >>>>       =20
> >>>>>> -----Original Message-----
> >>>>>> From: dri-devel <dri-devel-bounces@lists.freedesktop.org> On Behal=
f Of Boris Brezillon
> >>>>>> Sent: 13 March 2026 11:57
> >>>>>> Subject: Re: [PATCH v4 5/6] drm/gem-shmem: Track folio accessed/di=
rty status in mmap
> >>>>>>
> >>>>>> On Fri, 13 Mar 2026 11:29:47 +0100
> >>>>>> Thomas Zimmermann <tzimmermann@suse.de> wrote:
> >>>>>>           =20
> >>>>>>> Hi
> >>>>>>>
> >>>>>>> Am 13.03.26 um 11:18 schrieb Boris Brezillon:
> >>>>>>> [...] =20
> >>>>>>>>>>>> +	if (drm_WARN_ON(obj->dev, !shmem->pages || page_offset >=
=3D num_pages))
> >>>>>>>>>>>> +		return VM_FAULT_SIGBUS;
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +	file_update_time(vma->vm_file);
> >>>>>>>>>>>> +
> >>>>>>>>>>>> +	folio_mark_dirty(page_folio(shmem->pages[page_offset])); =
=20
> >>>>>>>> Do we need a folio_mark_dirty_lock() here? =20
> >>>>>>> There is a helper for that with some documentation. [1] =20
> >>>>>> This [1] seems to solve the problem for me. Still unsure about the=
 folio_mark_dirty_lock vs
> >>>>>> folio_mark_dirty though.
> >>>>>>
> >>>>>> [1]https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrod=
emargomes@gmail.com/ =20
> >>>>> FYI, I used folio_mark_dirty_lock() still it does not solve the iss=
ue with weston hang. =20
> >>>> The patch I pointed to has nothing to do with folio_mark_dirty_lock(=
),
> >>>> It's a bug caused by huge page mapping changes. =20
> >>> Scratch that. I had a bunch of other changes on top, and it hangs aga=
in
> >>> now that I dropped those. =20
> >> Seems like it's the combination of huge pages and mkwrite that's
> >> causing issues, if I disable huge pages, it doesn't hang... =20
> > I managed to have it working with the following diff. I still need to
> > check why the "map-RO-split+RW-on-demand" approach doesn't work (races
> > between huge_fault and pfn_mkwrite?), but I think it's okay to map the
> > real thing writable on the first attempt anyway (we're not trying to do
> > CoW here, since we're always pointing to the same page, it's just the
> > permissions that change). Note that there's still the race fixed by
> > https://yhbt.net/lore/dri-devel/20260312155027.1682606-1-pedrodemargome=
s@gmail.com/
> > in this diff, I just tried to keep the diffstat minimal.
> > =20
> > --->8--- =20
> > diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/d=
rm_gem_shmem_helper.c
> > index 4500deef4127..4efdce5a60f0 100644
> > --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> > +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> > @@ -561,9 +561,8 @@ static vm_fault_t drm_gem_shmem_try_insert_pfn_pmd(=
struct vm_fault *vmf, unsigne
> >          bool aligned =3D (vmf->address & ~PMD_MASK) =3D=3D (paddr & ~P=
MD_MASK);
> >  =20
> >          if (aligned && pmd_none(*vmf->pmd)) {
> > -               /* Read-only mapping; split upon write fault */
> >                  pfn &=3D PMD_MASK >> PAGE_SHIFT;
> > -               return vmf_insert_pfn_pmd(vmf, pfn, false);
> > +               return vmf_insert_pfn_pmd(vmf, pfn, vmf->flags & FAULT_=
FLAG_WRITE);
> >          }
> >   #endif
> >  =20
> > @@ -597,8 +596,12 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fa=
ult *vmf)
> >  =20
> >          pfn =3D page_to_pfn(page);
> >  =20
> > -       if (folio_test_pmd_mappable(folio))
> > +       if (folio_test_pmd_mappable(folio)) {
> >                  ret =3D drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
> > +               if (ret =3D=3D VM_FAULT_NOPAGE && vmf->flags & FAULT_FL=
AG_WRITE)
> > +                       folio_mark_dirty(folio);
> > +       }
> > +
> >          if (ret !=3D VM_FAULT_NOPAGE)
> >                  ret =3D vmf_insert_pfn(vma, vmf->address, pfn); =20
>=20
> All these branches with NOPAGE seem confusing. Can we change the overall=
=20
> logic here? Something like:
>=20
> if (folio_test_pmd_mappable()) {
>  =C2=A0 =C2=A0 ret =3D try_insert_pfn_pmd()
>  =C2=A0 =C2=A0 if (ret =3D=3D VM_FAULT_NOPAGE) {
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 folio_mark_accessed()
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (flags & FLAG_WRITE)
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 folio_mark_dirty()
>  =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto out;
>  =C2=A0 =C2=A0 }
> }
>=20
> ret =3D vmf_insert_pfn()
> if (ret =3D=3D NOPAGE)
>  =C2=A0 =C2=A0 folio_mark_accesed()
>=20
> out:
>  =C2=A0 ...
>=20
>=20
> This would keep the huge-page code within the first branch. And if it=20
> fails, it still does the regular page fault.

Well, in practice that's not what we want anyway (see the other fix for
the huge_fault vs regular fault race), so I'd still be inclined to have
the folio_mark_accessed() handled in the common path and have the pmd
vs regular pfn insertion in some if/else branches. Something like that:

	if (pmd_insert)
		ret =3D drm_gem_shmem_try_insert_pfn_pmd(vmf, pfn);
	else
		ret =3D vmf_insert_pfn(vma, vmf->address, pfn);

	if (ret =3D=3D VM_FAULT_NOPAGE) {
		folio_mark_accesed(folio);

		/* Normal pages are mapped RO, and remapped RW afterwards. */
		if (pmd_insert && vmf->flags & FAULT_FLAG_WRITE)
			folio_mark_dirty(folio);
	}

