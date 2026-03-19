Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEBC1090237
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:15:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03A66B04FC; Thu, 19 Mar 2026 11:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4DA6B04FE; Thu, 19 Mar 2026 11:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CC16B04FF; Thu, 19 Mar 2026 11:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71E176B04FC
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:15:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 35080C2095
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:15:13 +0000 (UTC)
X-FDA: 84563160906.02.E64697D
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3127EC0005
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:15:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bjwAHlfa;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773933310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rDGWj2LZwlvIkcEpInl/kcvhbo0ZpIck8KTLQAEkgQo=;
	b=NqdPXhKP0LYNAqEaOVn8Me4bVNy2m6+DPfhL9uQpdqPNjYINtRMDCCxSMc8LpxDQlbgxPa
	fxqCGZ/5PPTI4WlDAPlBRMTXvI/5zkdwFlpzWg4b7Jy1aY0gT9Ih05VJNzVuiBY+9QY3Vg
	QjqtGSd/9zHQpXqX5kSmNZ+y1lYQ5+g=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bjwAHlfa;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773933310; a=rsa-sha256;
	cv=pass;
	b=DHP24IGX4ssVUK2Xucf6Gsg8tFDSDBLfsrtGqZ+u1WAeYtPmpD2vjU27Fcj2BN++f6kq0R
	4qGaO6ywtJIo5dE+FTX0LgwmVQIWsTOY0lu1sxe8gZpmB1PCPYfEo3qpbxCpOIF+/YzQt5
	8ruahrNyg2QTwatXHwI3j+tGQBjJKhE=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-661ce258878so12017a12.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:15:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773933308; cv=none;
        d=google.com; s=arc-20240605;
        b=GVbHDc2dj5VBE4ok8VWXvSsRKj1oVWSXBDw0ZxIUP2x+AxQrMh8NbdAZo7Q6adXmuJ
         jzn3cpHANaWt+cnNLmsHfoYjsRZiHS0tCvhJjJ4tUO6WeiYjGHJ9wEnvOYcAQcAM2/FZ
         wlpUbGMdXiSartIU/u92LsxgjLlK61ToxoEF1mYm0wQEI21urvhbF4ul9F+87jT8fKvZ
         tvAYIdfCv48Bi1bshS5QFyINBBIklnmA8cbCUfe2QxDtXlOvjIi4BETn3VoH4gjWOhg5
         3v72sfEO1FF++ujeseKZzipeW+8PJN2Yndc+4DxcbYtiTeI6iRWFrwu8gIzGx/e4i0qQ
         qMrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rDGWj2LZwlvIkcEpInl/kcvhbo0ZpIck8KTLQAEkgQo=;
        fh=82Ui/xWb30ZylaEOLPhr0X+XEm1Tw9lUydXd3HBHwYU=;
        b=U6OpbHmYjO5UrpmZm5onoo/OdSFeEP3FnhLLZgbxzCVLzShh43pOBQAnCZO43cn4do
         dylaRU2UQfjha3p81tUt+rSaHhrLgw90oQxB4jia1zs86wNND9wOIERCaqc2N/ruR8YT
         ZK852J+f4vxdyuNP7I7fmmChEiuBRthV/wh0t8GdFfvw706XFl5Rwp6Oi8P4Tf1D9b+c
         7aSpYD753Ddm9Rjzst5CTZjP5EyXhDS2GVT6jB+hDiNVaHHzi9HITUWhpShcA48qFzqu
         l+96+fJ2saW93Hrd+hESpZ8tCkRXuQk159oMP2sl2pQN2Cm6JnmlK3G4NKY1fBY5LSOb
         bF4g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773933308; x=1774538108; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDGWj2LZwlvIkcEpInl/kcvhbo0ZpIck8KTLQAEkgQo=;
        b=bjwAHlfaM2p+xATJdi5EpZsAEzIN81Pp3aMPjIGrY7HHMlqwcMhYPNfE6i4xwFqMvQ
         Ve9Ooe1r31XuACLG79KHFdZ6XNcya70T5+Jvk9Ndh+UQB8FRTt3JN2CcX+WMrOgMOfvG
         J0G7ThtheCo1rLYCJvCUY3YfRREc6RUqVtGWrGthLPnvtgn1dB42cRutcSiw7AF8ICME
         QfToSJ9TxFEo2vl5iMsHEJHJ8zfoBl+DuIJtPvIYZkrRcDCeWVYtWYJMAq1Sg8Ujl7pj
         AaPhw4fXNql7gePD9yVwQcnocIepcOzC/pMjWfexIK1krwL6kjnNuD1nknA6LW/GRkG/
         vXUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773933308; x=1774538108;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rDGWj2LZwlvIkcEpInl/kcvhbo0ZpIck8KTLQAEkgQo=;
        b=X3RKFmjUx9QRIpxWAV/Igg5ux1svF9w3ImFwpH9NTpW2hQjdPOLvJ9FP1lg1MGOBz+
         WnN2pU20EQYXHCu8HR2O82EVuOsP0lKkXjWNd7G0cl8Xl07fdxyMFQVXH6EE/P7y83OD
         DjFI8eWNpJuRJ34JuFqJzl9snW7x5fv18i1c27iOx6hF7S8gxF0oKdp/U0h33GFpbMSW
         6y5JhGsUiyDEhNr8rT4Dan1m5OxpuuDrmSGUvhFhk45vj/9yuQIJVV9rb6FORymiXGg1
         984vOaTcpvyUwx+RbwIZnTZIRFdAFWpM0VY4QWrzsVXIJPPGeaTibQHUZtZXO9ZaU1g6
         6EEg==
X-Forwarded-Encrypted: i=1; AJvYcCW8bc6e0z2vz89ShlnbijBwUFcfWJRyxcjnOJEqkchLx6+/+lavpl9Q9IWosyEZMl1+Mt5AZyquxQ==@kvack.org
X-Gm-Message-State: AOJu0YyG7aN/tYaKIhRwaORgzzugsS8GQmqux8joFn8Hu9W8/pqqP6O7
	yfuNGKeHgewfMxwrW7Rsab7tvnjQqjIusmCCkgIaoJBO1rsoLUGNqD5bZMWEG1MpjYU+otUjcRJ
	hzkfsLztGFYUGQUERfEkmhosUlgOVBOpTVgfHBVGB
X-Gm-Gg: ATEYQzzuakQ6Ju0n/Fk/D1vxXEJVRJnOwHLguCEhIt1NVFCY0CrC5AwW729r62xF3Qi
	Dze4jSds8A4lwl23gv84TKEF0YtTmVwLyduIw5OZ3FunRkSgj4Fk4bbD4CAQkwcqNuoM0VTIe0V
	ALT67HQiiJO79OPHngd0o6sADryXp9KTEzBrqHA5qIyNtBDIAer3B1+5xtKdVGIFrZIGoUj9LjD
	BoMnB9wc4ebnDgzvYziIjesh16VZVlmxxtN5SU+ppES9ii+dut6YjxsFkHQOaGDR4jUFeBDpTyt
	GzyEMGY5uWUWjCpNBl2kiWnlvuTOq8SSYxec
X-Received: by 2002:a05:6402:a518:20b0:660:f90b:a19b with SMTP id
 4fb4d7f45d1cf-66852d86339mr28785a12.8.1773933307787; Thu, 19 Mar 2026
 08:15:07 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <8e28e4b63bae67bfa1a59ccbac9dc6db1442d75d.1773695307.git.ljs@kernel.org>
 <CAJuCfpF6eS18HLgNvQtkLGd=7N0_L1JPmF0GzM-Z0QimRWT7AQ@mail.gmail.com> <d877ee66-1ac9-4b1b-b860-6919dc58edfe@lucifer.local>
In-Reply-To: <d877ee66-1ac9-4b1b-b860-6919dc58edfe@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 19 Mar 2026 08:14:54 -0700
X-Gm-Features: AaiRm50TBB0_y5-6zEqCgnFax1lp80ds7Lm1WJGU5srttqxVqxdb1y_yg1RHpJs
Message-ID: <CAJuCfpGsKgOEGA3rh+fMwv4BMMb0tZ5ZxVWeLCyOEvq7J12xOg@mail.gmail.com>
Subject: Re: [PATCH v2 15/16] mm: add mmap_action_map_kernel_pages[_full]()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
	Clemens Ladisch <clemens@ladisch.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "K . Y . Srinivasan" <kys@microsoft.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
	Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Richard Weinberger <richard@nod.at>, 
	Vignesh Raghavendra <vigneshr@ti.com>, Bodo Stroesser <bostroesser@gmail.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, 
	linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org, 
	target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Ryan Roberts <ryan.roberts@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3127EC0005
X-Stat-Signature: o3ud8khznc4fq6kd61cgf9ygh4f8xas6
X-Rspam-User: 
X-HE-Tag: 1773933309-440036
X-HE-Meta: U2FsdGVkX19APwgyC9Uo4Ent4mMRlTWcWnpuRF4UIY2mYWQO4Scobp1Q4+fmP1G03M5Ejj8D4kxALQJ1rpm8/8EHec68C3xK1BbEHtKrWEU1sb1pCu9t0VAm+W+012QXKe5zngPwRzj5dzVkJjP2/SdlPaLeA8yK8naZvbLyeqVwDKoBPUu0p66pfzaw50y0PBRe3u0fTPcVnEdkaD6fsufB/v6s+LexRAj7Alq1W7dy54cukE33VuB2wzuEoQdwcwXfxwoA8dDZz/mibe7rXKQzMGpX4Fwyvq5jig4h5QBP3TsHdmAcn+eo0680FpBdSyyEw74o2vF0yYrM45MPBYC23YFKYI2EgO4CIKMsQ0bzADGCmivv1yVGq6bOmC2T8nIhfAxepAz/vZR0ZapcGxj+nqxK5k3jPvEPUzXvXOjO7fEYgQkDDpIoE3SjGvunTUCToQC4oeNAYl1KYpT2S8hn9dq75K2CGhDkTnaMu/zz6jP22mUwfve+sw/G3wQOzDrO2SVDw4nbNzKYDPoRUGvmb8qMkb3btIV+wkspZ35/ROwaxPJ4FEfxwPwMhrnmk23t0SxRHKgaVC2hzJO1jRT6yd3VizXSEbsuw6DxLxa9SRgFMD6FLtQ881f4158/nRwvhNDr5P6Rloj24pG0oeYcSHZnZTvmlkdGWwApy/wFxN1DI13gYHOaFt1+Aga+9FKGvSpcJWUXkI39J7bZtAzjn+1wsS2GtB1VwghoLOeor/I5MvEx33kIN0KPk97kmrGkrBqAUTxBt31yhRVoWQpYsxR51sojolhTWJ6+pI+z2GYee2vz/snWn3LuB6jG0i24vNuMqzdOQH913xGRiEux2knPEpNhH1k2vCy/NhP1s8UfLwuhs+D8rriw1m3td7KBAk+MtKqTpXqfB/+J1mB9JEOZV5CEmoU8c/Uu2AQV9o1qjOxm7P395tVruDuKE/cL18zWhpbmPfc22FL
 FDxWIZvH
 oaZ3LHBraYWjn6KTa+jq1hKQD4aLXrFhqEWgjGMYU1eiUoPe2/NUU2sXzKwOQX/f3RQiFAxT5jXKnCwFaRhn4jLamt1UZ9zZX8a+423E+taH/1xu94Sky1JKP4KG1cKbmUOp2bW1dK40gjKdWM/CdZzVIoZJZTuFsJZ2O+MExxyfC0Y1q5Anxai9S52i4reQZIDqa/nDFrl87P54ByOZmBfvvkFypNjgo9z0f6trTSzJdToSytfAuoD70OkuNGE57TvLy11i9oHtvRCv/Vaxy7/3LGyQrodQBEn2N5R7HMmnr6P0Y+AXlYbUMxHOGIp73tZjxTqIJtK1izv3BWS4mWtom/bYEYGXDqV+fRuaBprqlOTHAmT6vMmvcedkxIbKaxzKv2HrJMijYms7AxDQ3Xt+BzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 8:05=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Wed, Mar 18, 2026 at 09:00:13AM -0700, Suren Baghdasaryan wrote:
> > On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@k=
ernel.org> wrote:
> > >
> > > A user can invoke mmap_action_map_kernel_pages() to specify that the
> > > mapping should map kernel pages starting from desc->start of a specif=
ied
> > > number of pages specified in an array.
> > >
> > > In order to implement this, adjust mmap_action_prepare() to be able t=
o
> > > return an error code, as it makes sense to assert that the specified
> > > parameters are valid as quickly as possible as well as updating the V=
MA
> > > flags to include VMA_MIXEDMAP_BIT as necessary.
> > >
> > > This provides an mmap_prepare equivalent of vm_insert_pages().
> > >
> > > We additionally update the existing vm_insert_pages() code to use
> > > range_in_vma() and add a new range_in_vma_desc() helper function for =
the
> > > mmap_prepare case, sharing the code between the two in range_is_subse=
t().
> > >
> > > We add both mmap_action_map_kernel_pages() and
> > > mmap_action_map_kernel_pages_full() to allow for both partial and ful=
l VMA
> > > mappings.
> > >
> > > We also add mmap_action_map_kernel_pages_discontig() to allow for
> > > discontiguous mapping of kernel pages should the need arise.
> > >
> > > We update the documentation to reflect the new features.
> > >
> > > Finally, we update the VMA tests accordingly to reflect the changes.
> > >
> > > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> > With one nit,
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>
> Thanks!
>
> >
> > > ---
> > >  Documentation/filesystems/mmap_prepare.rst |  8 ++
> > >  include/linux/mm.h                         | 95 ++++++++++++++++++++=
+-
> > >  include/linux/mm_types.h                   |  7 ++
> > >  mm/memory.c                                | 42 +++++++++-
> > >  mm/util.c                                  |  6 ++
> > >  tools/testing/vma/include/dup.h            |  7 ++
> > >  6 files changed, 159 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/Documentation/filesystems/mmap_prepare.rst b/Documentati=
on/filesystems/mmap_prepare.rst
> > > index be76ae475b9c..e810aa4134eb 100644
> > > --- a/Documentation/filesystems/mmap_prepare.rst
> > > +++ b/Documentation/filesystems/mmap_prepare.rst
> > > @@ -156,5 +156,13 @@ pointer. These are:
> > >  * mmap_action_simple_ioremap() - Sets up an I/O remap from a specifi=
ed
> > >    physical address and over a specified length.
> > >
> > > +* mmap_action_map_kernel_pages() - Maps a specified array of `struct=
 page`
> > > +  pointers in the VMA from a specific offset.
> > > +
> > > +* mmap_action_map_kernel_pages_full() - Maps a specified array of `s=
truct
> > > +  page` pointers over the entire VMA. The caller must ensure there a=
re
> > > +  sufficient entries in the page array to cover the entire range of =
the
> > > +  described VMA.
> > > +
> > >  **NOTE:** The ``action`` field should never normally be manipulated =
directly,
> > >  rather you ought to use one of these helpers.
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index df8fa6e6402b..6f0a3edb24e1 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -2912,7 +2912,7 @@ static inline bool folio_maybe_mapped_shared(st=
ruct folio *folio)
> > >   * The caller must add any reference (e.g., from folio_try_get()) it=
 might be
> > >   * holding itself to the result.
> > >   *
> > > - * Returns the expected folio refcount.
> > > + * Returns: the expected folio refcount.
> >
> > nit: I see both "Returns:" and "Return:" being used in the codebase
> > but this header file uses "Return:", so for consistency you should
> > probably do the same. This also applies to later instances in this
> > patch.
>
> Well here I'm just adding the colon, while I'm here (maybe have been an
> update in response to feedback actualy).
>
> And this function that's not part of my change already uses 'Returns' and
> I'm pretty sure that's the correct form.
>
> So I think not a big deal to keep using that?

Correct. Anything I mark as "nit:" is not critical and can be ignored.

>
> >
> > >   */
> > >  static inline int folio_expected_ref_count(const struct folio *folio=
)
> > >  {
> > > @@ -4364,6 +4364,45 @@ static inline void mmap_action_simple_ioremap(=
struct vm_area_desc *desc,
> > >         action->type =3D MMAP_SIMPLE_IO_REMAP;
> > >  }
> > >
> > > +/**
> > > + * mmap_action_map_kernel_pages - helper for mmap_prepare hook to sp=
ecify that
> > > + * @num kernel pages contained in the @pages array should be mapped =
to userland
> > > + * starting at virtual address @start.
> > > + * @desc: The VMA descriptor for the VMA requiring kernel pags to be=
 mapped.
> > > + * @start: The virtual address from which to map them.
> > > + * @pages: An array of struct page pointers describing the memory to=
 map.
> > > + * @nr_pages: The number of entries in the @pages aray.
> > > + */
> > > +static inline void mmap_action_map_kernel_pages(struct vm_area_desc =
*desc,
> > > +               unsigned long start, struct page **pages,
> > > +               unsigned long nr_pages)
> > > +{
> > > +       struct mmap_action *action =3D &desc->action;
> > > +
> > > +       action->type =3D MMAP_MAP_KERNEL_PAGES;
> > > +       action->map_kernel.start =3D start;
> > > +       action->map_kernel.pages =3D pages;
> > > +       action->map_kernel.nr_pages =3D nr_pages;
> > > +       action->map_kernel.pgoff =3D desc->pgoff;
> > > +}
> > > +
> > > +/**
> > > + * mmap_action_map_kernel_pages_full - helper for mmap_prepare hook =
to specify that
> > > + * kernel pages contained in the @pages array should be mapped to us=
erland
> > > + * from @desc->start to @desc->end.
> > > + * @desc: The VMA descriptor for the VMA requiring kernel pags to be=
 mapped.
> > > + * @pages: An array of struct page pointers describing the memory to=
 map.
> > > + *
> > > + * The caller must ensure that @pages contains sufficient entries to=
 cover the
> > > + * entire range described by @desc.
> > > + */
> > > +static inline void mmap_action_map_kernel_pages_full(struct vm_area_=
desc *desc,
> > > +               struct page **pages)
> > > +{
> > > +       mmap_action_map_kernel_pages(desc, desc->start, pages,
> > > +                                    vma_desc_pages(desc));
> > > +}
> > > +
> > >  int mmap_action_prepare(struct vm_area_desc *desc);
> > >  int mmap_action_complete(struct vm_area_struct *vma,
> > >                          struct mmap_action *action);
> > > @@ -4380,10 +4419,59 @@ static inline struct vm_area_struct *find_exa=
ct_vma(struct mm_struct *mm,
> > >         return vma;
> > >  }
> > >
> > > +/**
> > > + * range_is_subset - Is the specified inner range a subset of the ou=
ter range?
> > > + * @outer_start: The start of the outer range.
> > > + * @outer_end: The exclusive end of the outer range.
> > > + * @inner_start: The start of the inner range.
> > > + * @inner_end: The exclusive end of the inner range.
> > > + *
> > > + * Returns: %true if [inner_start, inner_end) is a subset of [outer_=
start,
> > > + * outer_end), otherwise %false.
> > > + */
> > > +static inline bool range_is_subset(unsigned long outer_start,
> > > +                                  unsigned long outer_end,
> > > +                                  unsigned long inner_start,
> > > +                                  unsigned long inner_end)
> > > +{
> > > +       return outer_start <=3D inner_start && inner_end <=3D outer_e=
nd;
> > > +}
> > > +
> > > +/**
> > > + * range_in_vma - is the specified [@start, @end) range a subset of =
the VMA?
> > > + * @vma: The VMA against which we want to check [@start, @end).
> > > + * @start: The start of the range we wish to check.
> > > + * @end: The exclusive end of the range we wish to check.
> > > + *
> > > + * Returns: %true if [@start, @end) is a subset of [@vma->vm_start,
> > > + * @vma->vm_end), %false otherwise.
> > > + */
> > >  static inline bool range_in_vma(const struct vm_area_struct *vma,
> > >                                 unsigned long start, unsigned long en=
d)
> > >  {
> > > -       return (vma && vma->vm_start <=3D start && end <=3D vma->vm_e=
nd);
> > > +       if (!vma)
> > > +               return false;
> > > +
> > > +       return range_is_subset(vma->vm_start, vma->vm_end, start, end=
);
> > > +}
> > > +
> > > +/**
> > > + * range_in_vma_desc - is the specified [@start, @end) range a subse=
t of the VMA
> > > + * described by @desc, a VMA descriptor?
> > > + * @desc: The VMA descriptor against which we want to check [@start,=
 @end).
> > > + * @start: The start of the range we wish to check.
> > > + * @end: The exclusive end of the range we wish to check.
> > > + *
> > > + * Returns: %true if [@start, @end) is a subset of [@desc->start, @d=
esc->end),
> > > + * %false otherwise.
> > > + */
> > > +static inline bool range_in_vma_desc(const struct vm_area_desc *desc=
,
> > > +                                    unsigned long start, unsigned lo=
ng end)
> > > +{
> > > +       if (!desc)
> > > +               return false;
> > > +
> > > +       return range_is_subset(desc->start, desc->end, start, end);
> > >  }
> > >
> > >  #ifdef CONFIG_MMU
> > > @@ -4427,6 +4515,9 @@ int remap_pfn_range(struct vm_area_struct *vma,=
 unsigned long addr,
> > >  int vm_insert_page(struct vm_area_struct *, unsigned long addr, stru=
ct page *);
> > >  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> > >                         struct page **pages, unsigned long *num);
> > > +int map_kernel_pages_prepare(struct vm_area_desc *desc);
> > > +int map_kernel_pages_complete(struct vm_area_struct *vma,
> > > +                             struct mmap_action *action);
> > >  int vm_map_pages(struct vm_area_struct *vma, struct page **pages,
> > >                                 unsigned long num);
> > >  int vm_map_pages_zero(struct vm_area_struct *vma, struct page **page=
s,
> > > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > > index 7538d64f8848..c46224020a46 100644
> > > --- a/include/linux/mm_types.h
> > > +++ b/include/linux/mm_types.h
> > > @@ -815,6 +815,7 @@ enum mmap_action_type {
> > >         MMAP_REMAP_PFN,         /* Remap PFN range. */
> > >         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> > >         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> > > +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from array. =
*/
> > >  };
> > >
> > >  /*
> > > @@ -833,6 +834,12 @@ struct mmap_action {
> > >                         phys_addr_t start_phys_addr;
> > >                         unsigned long size;
> > >                 } simple_ioremap;
> > > +               struct {
> > > +                       unsigned long start;
> > > +                       struct page **pages;
> > > +                       unsigned long nr_pages;
> > > +                       pgoff_t pgoff;
> > > +               } map_kernel;
> > >         };
> > >         enum mmap_action_type type;
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index f3f4046aee97..849d5d9eeb83 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -2484,13 +2484,14 @@ static int insert_pages(struct vm_area_struct=
 *vma, unsigned long addr,
> > >  int vm_insert_pages(struct vm_area_struct *vma, unsigned long addr,
> > >                         struct page **pages, unsigned long *num)
> > >  {
> > > -       const unsigned long end_addr =3D addr + (*num * PAGE_SIZE) - =
1;
> > > +       const unsigned long nr_pages =3D *num;
> > > +       const unsigned long end =3D addr + PAGE_SIZE * nr_pages;
> > >
> > > -       if (addr < vma->vm_start || end_addr >=3D vma->vm_end)
> > > +       if (!range_in_vma(vma, addr, end))
> > >                 return -EFAULT;
> > >         if (!(vma->vm_flags & VM_MIXEDMAP)) {
> > > -               BUG_ON(mmap_read_trylock(vma->vm_mm));
> > > -               BUG_ON(vma->vm_flags & VM_PFNMAP);
> > > +               VM_WARN_ON_ONCE(mmap_read_trylock(vma->vm_mm));
> > > +               VM_WARN_ON_ONCE(vma->vm_flags & VM_PFNMAP);
> > >                 vm_flags_set(vma, VM_MIXEDMAP);
> > >         }
> > >         /* Defer page refcount checking till we're about to map that =
page. */
> > > @@ -2498,6 +2499,39 @@ int vm_insert_pages(struct vm_area_struct *vma=
, unsigned long addr,
> > >  }
> > >  EXPORT_SYMBOL(vm_insert_pages);
> > >
> > > +int map_kernel_pages_prepare(struct vm_area_desc *desc)
> > > +{
> > > +       const struct mmap_action *action =3D &desc->action;
> > > +       const unsigned long addr =3D action->map_kernel.start;
> > > +       unsigned long nr_pages, end;
> > > +
> > > +       if (!vma_desc_test(desc, VMA_MIXEDMAP_BIT)) {
> > > +               VM_WARN_ON_ONCE(mmap_read_trylock(desc->mm));
> > > +               VM_WARN_ON_ONCE(vma_desc_test(desc, VMA_PFNMAP_BIT));
> > > +               vma_desc_set_flags(desc, VMA_MIXEDMAP_BIT);
> > > +       }
> > > +
> > > +       nr_pages =3D action->map_kernel.nr_pages;
> > > +       end =3D addr + PAGE_SIZE * nr_pages;
> > > +       if (!range_in_vma_desc(desc, addr, end))
> > > +               return -EFAULT;
> > > +
> > > +       return 0;
> > > +}
> > > +EXPORT_SYMBOL(map_kernel_pages_prepare);
> > > +
> > > +int map_kernel_pages_complete(struct vm_area_struct *vma,
> > > +                             struct mmap_action *action)
> > > +{
> > > +       unsigned long nr_pages;
> > > +
> > > +       nr_pages =3D action->map_kernel.nr_pages;
> > > +       return insert_pages(vma, action->map_kernel.start,
> > > +                           action->map_kernel.pages,
> > > +                           &nr_pages, vma->vm_page_prot);
> > > +}
> > > +EXPORT_SYMBOL(map_kernel_pages_complete);
> > > +
> > >  /**
> > >   * vm_insert_page - insert single page into user vma
> > >   * @vma: user vma to map to
> > > diff --git a/mm/util.c b/mm/util.c
> > > index a166c48fe894..dea590e7a26c 100644
> > > --- a/mm/util.c
> > > +++ b/mm/util.c
> > > @@ -1441,6 +1441,8 @@ int mmap_action_prepare(struct vm_area_desc *de=
sc)
> > >                 return io_remap_pfn_range_prepare(desc);
> > >         case MMAP_SIMPLE_IO_REMAP:
> > >                 return simple_ioremap_prepare(desc);
> > > +       case MMAP_MAP_KERNEL_PAGES:
> > > +               return map_kernel_pages_prepare(desc);
> > >         }
> > >
> > >         WARN_ON_ONCE(1);
> > > @@ -1472,6 +1474,9 @@ int mmap_action_complete(struct vm_area_struct =
*vma,
> > >         case MMAP_IO_REMAP_PFN:
> > >                 err =3D io_remap_pfn_range_complete(vma, action);
> > >                 break;
> > > +       case MMAP_MAP_KERNEL_PAGES:
> > > +               err =3D map_kernel_pages_complete(vma, action);
> > > +               break;
> > >         case MMAP_SIMPLE_IO_REMAP:
> > >                 /*
> > >                  * The simple I/O remap should have been delegated to=
 an I/O
> > > @@ -1494,6 +1499,7 @@ int mmap_action_prepare(struct vm_area_desc *de=
sc)
> > >         case MMAP_REMAP_PFN:
> > >         case MMAP_IO_REMAP_PFN:
> > >         case MMAP_SIMPLE_IO_REMAP:
> > > +       case MMAP_MAP_KERNEL_PAGES:
> > >                 WARN_ON_ONCE(1); /* nommu cannot handle these. */
> > >                 break;
> > >         }
> > > diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/incl=
ude/dup.h
> > > index 6658df26698a..4407caf207ad 100644
> > > --- a/tools/testing/vma/include/dup.h
> > > +++ b/tools/testing/vma/include/dup.h
> > > @@ -454,6 +454,7 @@ enum mmap_action_type {
> > >         MMAP_REMAP_PFN,         /* Remap PFN range. */
> > >         MMAP_IO_REMAP_PFN,      /* I/O remap PFN range. */
> > >         MMAP_SIMPLE_IO_REMAP,   /* I/O remap with guardrails. */
> > > +       MMAP_MAP_KERNEL_PAGES,  /* Map kernel page range from an arra=
y. */
> > >  };
> > >
> > >  /*
> > > @@ -472,6 +473,12 @@ struct mmap_action {
> > >                         phys_addr_t start;
> > >                         unsigned long len;
> > >                 } simple_ioremap;
> > > +               struct {
> > > +                       unsigned long start;
> > > +                       struct page **pages;
> > > +                       unsigned long num;
> > > +                       pgoff_t pgoff;
> > > +               } map_kernel;
> > >         };
> > >         enum mmap_action_type type;
> > >
> > > --
> > > 2.53.0
> > >

