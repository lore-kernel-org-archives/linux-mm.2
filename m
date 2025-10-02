Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F825CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 08:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B18D8E0008; Thu,  2 Oct 2025 04:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662068E0002; Thu,  2 Oct 2025 04:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529708E0008; Thu,  2 Oct 2025 04:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3DA8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 04:00:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2EFD1DF6BE
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:00:03 +0000 (UTC)
X-FDA: 83952425886.03.5A075FC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE64640013
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 08:00:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ekOTAKfm;
	spf=pass (imf01.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759392001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twdF5Ghf90omLm8FmG8vqty38VLg0uYT52OZEV9+SEc=;
	b=CTm/tHqXBdA3r5XB/WLISfP249A/jX1pIiViZovTAoYSOgG7NR2vmZzXbMfiORMUuDwfn5
	Nav7+IN95iETcn8/4VBjAsrXiXd9/mnbaBMhMaXWoig7xFqIBDB9lDfsUKNPSChhMNG4/T
	5+l4xZCH5w0mCp59ZpDuEI9FfuUwgF0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759392001; a=rsa-sha256;
	cv=none;
	b=vTbq0ly0MdyTEpLMeiOeMlqPAVrooyweMXj1Z/8XyX30RelZVOYjIpwR/FFegdAxUL7Ydt
	j3LY+/pFjI8lAjYjzWkhKRVdtQfoqzvTwXjFrMUZDC8Ud9552Mc3ggQXiX/RPCV/jMVAWt
	1KiIAy3k2rY+2lM19vDnn2lF2zBED44=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ekOTAKfm;
	spf=pass (imf01.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759392001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=twdF5Ghf90omLm8FmG8vqty38VLg0uYT52OZEV9+SEc=;
	b=ekOTAKfmvKAKWodPP+9Q48QMPiCf1jjanz2H3Pkax9CBJIxFs9qagnJBqvVNM05mQDOBE+
	tV+5RI1rv4insBjs400AAoeZg2eeYiNawqNescb2rqJaqD3KMF1kA5xcKeDom0+5eHHO5g
	MsaCjvq5aY03fdMWes4NcTIhSbuNctw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-uiBevIzvNi2tcZxne-NogQ-1; Thu, 02 Oct 2025 03:59:57 -0400
X-MC-Unique: uiBevIzvNi2tcZxne-NogQ-1
X-Mimecast-MFC-AGG-ID: uiBevIzvNi2tcZxne-NogQ_1759391996
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso1024354f8f.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 00:59:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759391996; x=1759996796;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twdF5Ghf90omLm8FmG8vqty38VLg0uYT52OZEV9+SEc=;
        b=ICzWjtSx6MxVCZeI9iVj1zgOzF+Opw7eU6sD+WTaggLjSwmmJs5v6GT8Qjb+swa7hB
         qkL9rsGwHuNvwCwscTfw/Ef+2DSZLNS9IMYl7FsHrgxeTdvkmF54OkDiJ6sRVVBkMWpg
         /0PgzFjR7GqSI7Gaue/ZNs+SKUzbBs4YgnEmVNjiEypUmJ3gn0V8ne6MeC0aO5qAhK3Q
         WRC0wdH4/cDIRS5FxoDDbRTQmULkl7YhQBrSB8TR8FdaADpCHk8Cw8tdW+nfBPws21Lg
         21NJQUq12TwgDzAGt7n8kznRw7TQys9h5xcOyNkHbfjyaILsSyxgx4+7MJITvehfuWxR
         eMnw==
X-Forwarded-Encrypted: i=1; AJvYcCU37zBs9eb8iWpdp+acIti+9BxF9l+jh12zYhVPc8P0TpJ63CncBvsjDjTY2X9C+57EgqHM0tX1kg==@kvack.org
X-Gm-Message-State: AOJu0YwkCwjXqEkJ28rZqt93BzsOw1K2yNzVSKeLwTaO8hBADjKQ9yIA
	aSrb3vGkAAGe0tL+Bm5AyaVoUNyYGulsKq+q8Ndkd4Lz/JzGet5Kone/4jOOgUIm/ehesZrBnia
	/dZBA59zVcVzFfZym2E/kpIW/Qu403MLOi3oPbwLpYj2fFKCcVBXg
X-Gm-Gg: ASbGncseqrv0I6aYh1WXIvm8i/UDIatBnH84rXOnAtQsDf3bE4ziXPT7XVfO+/S7MNF
	2CwnbNH+Q3LVYbiQcvxDaVAeokQmfcleXDOZ0n00YOKh5uO8f4pkC0gIwAt0P+FT8kMdfzzP2Ks
	ioxZFz87WamkAQ1I/H/hJOxO39maURWyShgCWNBkjpknWcsbQAN8Ya8S/n2e7mGjEZi5aP265Yq
	i5PD/U57nb7wdzD6vaMVfw+YCQ2o9wqrZmDT5sHJX1XWW9TLwRSOUSZ9tJ9yDE6IZoyG+8UijME
	2VI71JJDS3skDqpCEEHbWw==
X-Received: by 2002:a5d:5f48:0:b0:3e7:617f:8458 with SMTP id ffacd0b85a97d-4255d2ca82cmr1522910f8f.24.1759391996221;
        Thu, 02 Oct 2025 00:59:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqvfeqwKeBIWk9I362srSwTFSWrOClY9YoEOQMVFqHTivLzqDGGJkfLFwQp6Kk579V7lD3LQ==
X-Received: by 2002:a5d:5f48:0:b0:3e7:617f:8458 with SMTP id ffacd0b85a97d-4255d2ca82cmr1522879f8f.24.1759391995724;
        Thu, 02 Oct 2025 00:59:55 -0700 (PDT)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e9719sm2540317f8f.31.2025.10.02.00.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 00:59:55 -0700 (PDT)
Date: Thu, 2 Oct 2025 09:59:54 +0200
From: Maxime Ripard <mripard@redhat.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: John Stultz <jstultz@google.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, 
	linux-tegra@vger.kernel.org, linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
Message-ID: <20251002-cute-loud-eel-67f9a0@houat>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-5-thierry.reding@gmail.com>
 <CANDhNCoM4RFX-QccF7xT=+-tduGj9OZ_8SgrTVyRucMwyVc73Q@mail.gmail.com>
 <e6twhwxi55eesb7xirei7wezzb77qjiji2mccgqlziisjzl3q5@3ny5e6lbgebz>
 <CANDhNCrO21O_URa1iHuroOoG-g61DL7uvECTwVxiuitCTi=i4g@mail.gmail.com>
 <sb76bsg5d45r5qgq4zy3svbh42ydkk4vrh6a7vh73eibvqbfjd@3r4exdhogde6>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="wnfwjjw7bbsf5d2u"
Content-Disposition: inline
In-Reply-To: <sb76bsg5d45r5qgq4zy3svbh42ydkk4vrh6a7vh73eibvqbfjd@3r4exdhogde6>
X-Stat-Signature: yrcd9j4h7ofnc8ujpmj9xxu7kyz4pikw
X-Rspam-User: 
X-Rspamd-Queue-Id: BE64640013
X-Rspamd-Server: rspam10
X-HE-Tag: 1759392001-918271
X-HE-Meta: U2FsdGVkX18WP+LO6l3IhiXRflR40Mtbp2+G9sPk4rzLKDzxVHMo7UdU+dIxtwSYzjIsG6WVWDCYW5HmMKBuj8KGGUZHLtDzOtjOQSX64bxocYQTHeqPP0DPOtkTKdPhPvUMnBIN40VV10KJ4VqG7RHxFfbilNfjdJKEjbVDWseQE4S3IXNJqj7swzVKNfSeJSUdmHHgjHgjSDFtfM6Wl3VaPXqxERcOQRVc6tAGJ8gE2uK4zoODdKa41REVcCODWzoXrki+Zg7WuLXwg2oJ57C60/ewFkJnX1/8ipaqg3HlLHcSaGwk0G9sxiOZOiWCHAdXiVnNgMobsI9IbVCVAPHivXb/R77DUFVEUjE/VnagFv22Jk52PscE7tqfmN7atAoa33n9YDia4T4AEsANFMjpx6SsHY74654MS7ZrpacP9jwlDes6KubVtYr++6BwxBDvz4+xkYN3mvf2Hq7IELhmbDBsYBoZ3Sg37yY3SXPvNDvQOfrZTEH17RPR17Resrb1UeDmhKuKQ2DKwrYRsAyQEHNPZ9s7TOpVVo3yAllPluEaUSV3f1h1AhygbacJqmhEw2ryAGii+aSNBMUoH+tZVLyD/mfb27PSCSMJygo1Z8ZusvgehqhHodNZkPVDYbMEl9/6yz7G2Ff7K5NQVeC3RF6u7QO5JSWRKee/nynMBBmrqeCT6H9PlksuJU0fy6BgZoSaKUZFLkh6ZWA9CToLazCbE00bR5cxdPrs4GA4DQke8rdX50ZlbDlCWDJP0wlU6/R6HqtEhmx7Pe04USIc5J9LrpZG8+L3QmnVyoI91k8ikC6TNBFELCHyO1Kb52YSLoNCGwpggaZbKpNRYnwWwjzlg5v170yeDWsKiCSYyWz6cix0ToEfUSWrCv9iCc1LxhhtG/E40J2fHN+XpwemNgffd5P9rPgeqjiXRWgIKMiSIzieAoJJEs9ilrHrB8bUNvL1ugbxIXWzR7T
 baZPAEZg
 zXEBqY2Gsl+JpUKtERMo/9YJXNtufePl5qRtb1/okwP0YVw+gsDQg6IVbW/f0HTZPf1Wi4mnhigT1w1gjsnjztd4N+xuLnd9k08gQowXiT/Z/82U92PozFncKuiOwRF3wkXOstr/KW8kldEk4A3OBABakn+HTCQmGFkdizrkA1GCmUKRbgVrMAhW6kM+Ni1R1dI/kwUON/+/urygXzOXxRSjCQMDziI1uKeCkQMICHVwwvv1ISiN9LOuccKlhVKcBLBDcedu8dZS0INwX/Z6EzoHx7afjVbRb4yXZNYrosavrM6fYXFYQ9R9PMIOhzyy6HiP+f5d8phHlc2/BjlAkcSkG7gvqeo+uRXT2MQbMFCK3VVZSkZy543PEHQL/CRdjLd1S05D5uyWy1t3zYY7SG9RU0LigXQyrESAWy0y2mU9vuxHSMxbbvt42KJuDA6iW/9RuQoclNTpJvAYDBBEWotDQzfVBfqCzzLzEBvB7QDYEHPVNFFMfnEDtuezgsaWvq2N1Y65IFghSN23wYr7M1H5S/HlX4nOJIg+KsEQYLyBM/ExC+prSSUx32HTKbc3Ppc7+BaV4DuAU4dKYdM7DviJJd0pdH+1cniJejPqSeXryMYEY+rzwf+sZFzp/pYmVGInVZtbPIBzZaMc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wnfwjjw7bbsf5d2u
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 4/9] dma-buf: heaps: Add debugfs support
MIME-Version: 1.0

On Thu, Sep 04, 2025 at 02:04:05PM +0200, Thierry Reding wrote:
> On Wed, Sep 03, 2025 at 11:48:38AM -0700, John Stultz wrote:
> > On Wed, Sep 3, 2025 at 8:38=E2=80=AFAM Thierry Reding <thierry.reding@g=
mail.com> wrote:
> > >
> > > On Tue, Sep 02, 2025 at 03:37:45PM -0700, John Stultz wrote:
> > > > On Tue, Sep 2, 2025 at 8:46=E2=80=AFAM Thierry Reding <thierry.redi=
ng@gmail.com> wrote:
> > > > >
> > > > > From: Thierry Reding <treding@nvidia.com>
> > > > >
> > > > > Add a callback to struct dma_heap_ops that heap providers can imp=
lement
> > > > > to show information about the state of the heap in debugfs. A top=
-level
> > > > > directory named "dma_heap" is created in debugfs and individual f=
iles
> > > > > will be named after the heaps.
> > > > >
> > > >
> > > > I know its debugfs, but this feels a little loosey-goosey as an uAP=
I.
> > >
> > > Well, the whole point of debugfs is that it's not really an ABI. Noth=
ing
> > > should ever rely on the presence of these files.
> > >
> > > > Is there any expected format for the show function?
> > > >
> > > > What would other dmabuf heaps ideally export via this interface?
> > >
> > > I've thought about this a bit and I'm not sure it makes sense to
> > > standardize on this. I think on one hand having a list of buffers
> > > exported by the dma-buf heap is probably the lowest common denominato=
r,
> > > but then there might be a bunch of other things that are very heap-
> > > specific that some heap might want to export.
> > >
> > > > Is there some consistent dma_heap-ish concept for it to justify it
> > > > being under a dma_heap directory, and not just an independent debug=
fs
> > > > file for the driver implementing the dmabuf heap?
> > >
> > > Well, I think just the fact that it's a dma-heap would qualify its
> > > corresponding debugfs to be in a well-known location. We could of cou=
rse
> > > pick some arbitrary location, but that's just a recipe for chaos beca=
use
> > > then everybody puts these whereever they want. There's really no
> > > standard place for driver-specific debugfs files to go, so putting it
> > > into some "subsystem"-specific directory seems like the better option.
> >=20
> > Ok, I guess I was thinking if the files are organizationally cohesive
> > to be under the dma-heap directory, they ought to have some
> > consistency between them.
>=20
> As far as I can tell there's not even enough information in a dma-heap
> to add any common debugfs snippets. As I mentioned earlier, a list of
> buffers allocated from a dma-heap is about the only generic piece of
> information that I can think of, but we don't track these buffers in a
> generic way. None of the existing heaps do so either seem to be
> interested in this either.
>=20
> It's also not like it's very useful information most of the time, it's
> mainly in this driver so that it can be inspected at runtime to see what
> the allocation pattern looks like at various stages and maybe help tune
> the division into chunks.

It is somewhat useful when we're talking about cgroup though :)

I think the buffer tracking / debugging mechanism itself is redundant
with what dmem/memcg would provide, so we probably want to just enable
dmem (probably?) here?

Of course, it doesn't help with additional heap specific debugging
information, so this patch might still have value.

Maxime

--wnfwjjw7bbsf5d2u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaN4w+gAKCRAnX84Zoj2+
drPIAXwN+Pi8yzwK6HH6eGaV4PuBhOENbMJ5om+Sbvf7UIv1i3YsGC9zQ5e+WgxM
4TB85TUBgMDvDSgCCaar57VP6ejj5nEexJYbycU0O7aIS8YHI8OUUt+RA2Us7hS/
M7QuNSDL9Q==
=wm+r
-----END PGP SIGNATURE-----

--wnfwjjw7bbsf5d2u--


