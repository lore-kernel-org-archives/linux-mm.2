Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBE5FF6E82
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 21:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C6A6B0093; Tue, 17 Mar 2026 17:32:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3C56B0095; Tue, 17 Mar 2026 17:32:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2F56B0096; Tue, 17 Mar 2026 17:32:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AB7AD6B0093
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:32:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ADF5B8F84
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:32:32 +0000 (UTC)
X-FDA: 84556854144.18.7703640
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A8BC40006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:32:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uorNsQCe;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773783150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eaVVTt78dt2IOUr/WJrEfVNvHIkRI9uCxJf+IAlfUTo=;
	b=lXIWuJ4dI04MuCNMT3wVm62CDGHYuS615SlQhtZIFDhjbOA7vPoMPUlEHP+kW4AzqtCJ1r
	5RfVn7rjPnkNWBTBoMpo9YOXni1BfjBCcwJsSUKoZ36N6VafljEdXbQppcgeQgp7vd+TQr
	J2HftmQ/GyWXM4ucYLY9n46LlT9UYeo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uorNsQCe;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773783150; a=rsa-sha256;
	cv=pass;
	b=MB6LOLq5CILoLlH+9LMiNxXfx8TkCZ79oCuYWfUMKI+lVOnoY+sHhsy/m8QVTBYhD08Lq2
	2yIk5F1uQo3A9qQmfwyhyGTqh3vf2OSDHQYknrW5ouRlmnrPallodQ71ltgZ8kdbebwUrl
	i4K3yN16TrGz7UusKJ2nnSU226lSVDo=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-5091ed02c54so88971cf.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773783149; cv=none;
        d=google.com; s=arc-20240605;
        b=M6qHYo1MZqOI3HTkIBTQfERiSqTnNIETxNUE82RECyjOLpImhdoXMXRNNW+C1l88lO
         5/40ThxBeZXDta6tDzXkn3znJ29UkCgxjrRdtd9uiij5XPunBXP++d+xlFjewSmAnoNS
         jQc14HTBh9iLN5SExk98GS9z96qpkaSePlRQjWVcO0nfv5ypqatYtlOFEN3yy7rdwMJC
         Jy4PFdfibUrYvykOYh97lMsaYTGOPdx4xedCVtUGwFWpwsRgnUvHATIGyEAcfcPTdHIf
         2AfbDlnWVUArfNiBbuJcrZhuDS3EWpnPBXwLLIqdPdyBIVWuJB1e1NXYw67aVu28XLrl
         qmZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eaVVTt78dt2IOUr/WJrEfVNvHIkRI9uCxJf+IAlfUTo=;
        fh=jEo4HLoVHxug8TR91M9OCRg5mrQBf09ZI7esfzSgegU=;
        b=g5U2o/rBwtIxF9fdYm+Fj0w5nRB/hzWDyS/8RinxJFPIijVEllnKQkGRI59y17Pz5z
         VzEsgbb1JOu4AFSGE/3xuwUOvwqvma9ZBtJy3XRPSPLzbD2Dms1Z1/4aFGta8FW1zwAT
         QDyqKNvWJB5WMux2GV3FVOxtQiPkzn1ildLJRiefUvYAAQXrscKH5AuR71U0rrgCRgoO
         UdSBYLUylfgR+TT6qtNtXPtqvqa/4ECohJtMOF5eyl4JGAX8vy4iVgsQea0b41xVs2ok
         djj7khPVlIe8h08PN6tFZ3qTN9NWB3tfDEagkDV3HyLPh2D3cyIQ7TO0w7eLs3y3LuNM
         39AQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773783149; x=1774387949; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eaVVTt78dt2IOUr/WJrEfVNvHIkRI9uCxJf+IAlfUTo=;
        b=uorNsQCejHAhIgrkMYAFe0f9wPWFFw5a2dHKEFTDOJ2RSUb8EkvFB2JzLN84Cm00WI
         Uu7ZoHvar5HFUbnwb+u0sF0VbgQRHgFqTloBM0eOmDqED3sC2ldBSPk/2ar/0uhDTin9
         ogGUqYOcXsiA1Zcpl3prqSEtWUXHTdw+DsZwAjDz2FJjc1mskDcBf0+PdbC6Sx/9BSXr
         hmplkKo+vNY5zC3GltV3Wk7aqhMo7Xst9G01x8dIWiY+oFrB2rDPk7BF4jsERUHE3rf+
         DxO7Vf3H2NZYxMj9RHWzgvA4L+8CPwreRV7DiZ0iQDSPR2MKzhETvjICWF2rdSyB/fT1
         DXpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773783149; x=1774387949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eaVVTt78dt2IOUr/WJrEfVNvHIkRI9uCxJf+IAlfUTo=;
        b=UKuBZBZGCLMOweAfg9AIygKlv0/PWIIhvOSZNK06pzZufUeYqbgtG+Xmaz2ynj+7dJ
         7RXm6C9E2tTQkc0EaYH6Vh8tRRMKqgVwP2T0gAJwT51Ob9E4rfL7xxidR1QmcIc95rOg
         5M5E1bFpDDjxZdSkcaY/+77qWkVC9vjUpidJ4ouudNLMXzjFYw9hGT0/X91sXGKIx4Bb
         gWcH2NHkHtPmU6ICaewbjsbxkryNftaJD6YNutIwGFqC8K9JmAlqHOr0qrEuqfDaokPA
         rZrfRVmUOEjOr/jZwevibg0a49Utrobds9XM/TwPRhLif7ljDTItEJylBzAm3xA+pmkO
         +RqA==
X-Forwarded-Encrypted: i=1; AJvYcCWuFqwP0T048r5PM66vdKOiRfeCaSgRv/oeHNRC9dMbtMqNIemTKHWcgtr/7jKc0eaVPxUm5ne0/A==@kvack.org
X-Gm-Message-State: AOJu0YwurlZdA33LdlZupP7lSkJ4eSOvqx0U0R+P2A0UY/JEZPvL0T0n
	z5sDYsdzAbxbn2xi/m2WcfjvjZ/42S9SwQuKu2FDCAwGUXkMV/oJ/8MqkkhCYY4rSBsp94keO9m
	qnxcLtwLcMGLLC4/mGI/AR6+BraEmf4htq4pVi71T
X-Gm-Gg: ATEYQzwlO8AAiZLNtBJCY39V5p9hGxYPzZzCfb3ZqeOx08TZZYV+sbieuDxakJyOw2q
	uwQ0jGdyPjT6NpEoSmiw1ja26156iQlwDSQ7mh5jBcIT55ajsYOYZEEPC1uz8lIYgioyDiQySR4
	ES5uC65l0bTiPSe/XSP5On8kIumChqyBon4GAYYpKlQEzeoBgYRQbFATc831WGI1hgXawY8/3yi
	e+F423E7m6Crmv2lW1VA5AF8+P/n6r9r5aEFjXGi6s3QE8Jir6EaBHvj+8Xqkv/nhQkXvY0ssbn
	M+hfbW+e3GPtO6SOXeBgvXFlWcDTsuDc4KrVwA==
X-Received: by 2002:a05:622a:1a9b:b0:501:3b94:bcae with SMTP id
 d75a77b69052e-50b1480564fmr4695911cf.8.1773783147340; Tue, 17 Mar 2026
 14:32:27 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1773695307.git.ljs@kernel.org> <48c6d25e374b57dba6df4fdddd4830d3fc1105be.1773695307.git.ljs@kernel.org>
 <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
In-Reply-To: <CAJuCfpFXuHg4KPY27pqMC-xV5y9ZY2W72_R8_rxO0DvrJ=_yvw@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 17 Mar 2026 14:32:16 -0700
X-Gm-Features: AaiRm50LOaxRG8hnm9GByPrpi5KQ-jnLdYLBR44IEnVyj1qDMmlGA-pMovuTqLE
Message-ID: <CAJuCfpE5qZmi43EeZiRcy78pD6YvJb5n_xnoUJfwEjomowu0=A@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] staging: vme_user: replace deprecated mmap hook
 with mmap_prepare
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
X-Rspamd-Queue-Id: 3A8BC40006
X-Rspamd-Server: rspam07
X-Stat-Signature: hxg9epo6tih6pi14rwonmbqxeg5rcp5w
X-Rspam-User: 
X-HE-Tag: 1773783150-91879
X-HE-Meta: U2FsdGVkX19uuyWPZ/mCyqjp1WXCIgQt1kNCsy+BPOPXki9HLg1wsUVYuJi4WFPoAGupWr65gNKH9itSb+NZ/stkwMw9cEJzDvsHUcRKiaEkvJdlvrxJkO8gloruBhseqeacfI9nlrM7mIqeRa4kRO2HtfirNMLD2nRFJkjV4y0U3rCT/5pYz/pNES4+0fRsU+3wJKKRuKzOWodRlc5/62HlQdUgY+kxsiKtwt5WcDrMPi7DJcV38dsTqoIAmmaXPIgS1CvJzh+xCQjn0dBK3AKBt/+u54NVuVu8/pHEsWcWalwmMeT0idP5FWD/dtpnR0j+/KI/AehqFR6cy7aTSNPdQoVOG48kseM3o74L1XQ9u79A7ptZnFh4J0oy1Ik61gjRovfAa8qvJ3EQSTxScqn1YRY/d2CIBs7LzeAbEcoiIHTMdWIQfHF4HVg+tJN17+rlUJKHNdiK+f5Bwo4YKLy90e15HzuOwpTm9bb1tqRiVyqIaHb+MEkzKp2GhrvqdyrnyspwB9gBJe8eB/XC+YG1zc8sklESkPSt4v8kYOcy6r6euHJjcP8GBSRphu4oD8MEHWlQmlnzxL/jZ+dl0DPBbMWlAm3fEKLiUP2eb+Ws9246WgzG5OtlCSERZ73W4s7LEZl5S6MmNNCKrh4Mq3OzQCpNz6rwDL/3Z8luYcwlfmUSdEKWRrosUsR97xTzLV91VMS7raiEIv4HC7h5WIb32BZ4a3mgfzS1WYOYnkAFSgRwHXL+M7EE8WZk/ujGeAzz8Xz0qC/Ax0Xoc/yIEKFnXvHvjrvauGUIwDeLXeB1unWBp/OraEwvLVlvulofuwiflG5M0GsSswudOi8kiEFkuKd8zrZKzCZ89fO8plJSmr40w+r6uF4m92jcTMxKB5/Ly1hMLaBQEDr4uhuCZIHikFVGxrzBW+xHxp3qPGXnfadB/B551Tu9SDrtaHy+Sn8YlL2EmOwytFoYgTD
 Ylj5pauS
 QxCzXR3ydvYICMOL6TDqdct4d8gDZ/myz0bdwcpTC5LqJfmniwJO8YnV9B+WD6baqHuQgfXtXiAEUhJ492VQ/TtiFAstYW/8pRwH8rFLy2Bx34UAkt+vJDaj/0PVhTwOqfzoD4TWnpXCi6M7FDvtfD7tUl03J4Ivu1KC5BfwEsqBMANfFRRqzftzjduOzN9L3ABFK/yJ8ajZR2Tei2b1Vp3wb0oYhvYf7ua/Xz5cMQWWZ74FMU3b9xw5KRrqCm2BcVOBbTxiFFtFpRSn3wiWNGYWtFyByEgzB0mmDr1yDOfirbFq8jqMK1znoHBfFzrFupNnQp34VJaJrHzQ0KmGDrf6FQiwFcINproRrqkEeAHqO2eHmEFc6dHna2h19cBYlp1cK4NTF00BhHohDWR6OnfqBxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 2:26=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Mon, Mar 16, 2026 at 2:14=E2=80=AFPM Lorenzo Stoakes (Oracle) <ljs@ker=
nel.org> wrote:
> >
> > The f_op->mmap interface is deprecated, so update driver to use its
> > successor, mmap_prepare.
> >
> > The driver previously used vm_iomap_memory(), so this change replaces i=
t
> > with its mmap_prepare equivalent, mmap_action_simple_ioremap().
> >
> > Functions that wrap mmap() are also converted to wrap mmap_prepare()
> > instead.
> >
> > Also update the documentation accordingly.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >  Documentation/driver-api/vme.rst    |  2 +-
> >  drivers/staging/vme_user/vme.c      | 20 +++++------
> >  drivers/staging/vme_user/vme.h      |  2 +-
> >  drivers/staging/vme_user/vme_user.c | 51 +++++++++++++++++------------
> >  4 files changed, 42 insertions(+), 33 deletions(-)
> >
> > diff --git a/Documentation/driver-api/vme.rst b/Documentation/driver-ap=
i/vme.rst
> > index c0b475369de0..7111999abc14 100644
> > --- a/Documentation/driver-api/vme.rst
> > +++ b/Documentation/driver-api/vme.rst
> > @@ -107,7 +107,7 @@ The function :c:func:`vme_master_read` can be used =
to read from and
> >
> >  In addition to simple reads and writes, :c:func:`vme_master_rmw` is pr=
ovided to
> >  do a read-modify-write transaction. Parts of a VME window can also be =
mapped
> > -into user space memory using :c:func:`vme_master_mmap`.
> > +into user space memory using :c:func:`vme_master_mmap_prepare`.
> >
> >
> >  Slave windows
> > diff --git a/drivers/staging/vme_user/vme.c b/drivers/staging/vme_user/=
vme.c
> > index f10a00c05f12..7220aba7b919 100644
> > --- a/drivers/staging/vme_user/vme.c
> > +++ b/drivers/staging/vme_user/vme.c
> > @@ -735,9 +735,9 @@ unsigned int vme_master_rmw(struct vme_resource *re=
source, unsigned int mask,
> >  EXPORT_SYMBOL(vme_master_rmw);
> >
> >  /**
> > - * vme_master_mmap - Mmap region of VME master window.
> > + * vme_master_mmap_prepare - Mmap region of VME master window.
> >   * @resource: Pointer to VME master resource.
> > - * @vma: Pointer to definition of user mapping.
> > + * @desc: Pointer to descriptor of user mapping.
> >   *
> >   * Memory map a region of the VME master window into user space.
> >   *
> > @@ -745,12 +745,13 @@ EXPORT_SYMBOL(vme_master_rmw);
> >   *         resource or -EFAULT if map exceeds window size. Other gener=
ic mmap
> >   *         errors may also be returned.
> >   */
> > -int vme_master_mmap(struct vme_resource *resource, struct vm_area_stru=
ct *vma)
> > +int vme_master_mmap_prepare(struct vme_resource *resource,
> > +                           struct vm_area_desc *desc)
> >  {
> > +       const unsigned long vma_size =3D vma_desc_size(desc);
> >         struct vme_bridge *bridge =3D find_bridge(resource);
> >         struct vme_master_resource *image;
> >         phys_addr_t phys_addr;
> > -       unsigned long vma_size;
> >
> >         if (resource->type !=3D VME_MASTER) {
> >                 dev_err(bridge->parent, "Not a master resource\n");
> > @@ -758,19 +759,18 @@ int vme_master_mmap(struct vme_resource *resource=
, struct vm_area_struct *vma)
> >         }
> >
> >         image =3D list_entry(resource->entry, struct vme_master_resourc=
e, list);
> > -       phys_addr =3D image->bus_resource.start + (vma->vm_pgoff << PAG=
E_SHIFT);
> > -       vma_size =3D vma->vm_end - vma->vm_start;
> > +       phys_addr =3D image->bus_resource.start + (desc->pgoff << PAGE_=
SHIFT);
> >
> >         if (phys_addr + vma_size > image->bus_resource.end + 1) {
> >                 dev_err(bridge->parent, "Map size cannot exceed the win=
dow size\n");
> >                 return -EFAULT;
> >         }
> >
> > -       vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);
> > -
> > -       return vm_iomap_memory(vma, phys_addr, vma->vm_end - vma->vm_st=
art);
> > +       desc->page_prot =3D pgprot_noncached(desc->page_prot);
> > +       mmap_action_simple_ioremap(desc, phys_addr, vma_size);
> > +       return 0;
> >  }
> > -EXPORT_SYMBOL(vme_master_mmap);
> > +EXPORT_SYMBOL(vme_master_mmap_prepare);
> >
> >  /**
> >   * vme_master_free - Free VME master window
> > diff --git a/drivers/staging/vme_user/vme.h b/drivers/staging/vme_user/=
vme.h
> > index 797e9940fdd1..b6413605ea49 100644
> > --- a/drivers/staging/vme_user/vme.h
> > +++ b/drivers/staging/vme_user/vme.h
> > @@ -151,7 +151,7 @@ ssize_t vme_master_read(struct vme_resource *resour=
ce, void *buf, size_t count,
> >  ssize_t vme_master_write(struct vme_resource *resource, void *buf, siz=
e_t count, loff_t offset);
> >  unsigned int vme_master_rmw(struct vme_resource *resource, unsigned in=
t mask, unsigned int compare,
> >                             unsigned int swap, loff_t offset);
> > -int vme_master_mmap(struct vme_resource *resource, struct vm_area_stru=
ct *vma);
> > +int vme_master_mmap_prepare(struct vme_resource *resource, struct vm_a=
rea_desc *desc);
> >  void vme_master_free(struct vme_resource *resource);
> >
> >  struct vme_resource *vme_dma_request(struct vme_dev *vdev, u32 route);
> > diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/staging/vme_=
user/vme_user.c
> > index d95dd7d9190a..11e25c2f6b0a 100644
> > --- a/drivers/staging/vme_user/vme_user.c
> > +++ b/drivers/staging/vme_user/vme_user.c
> > @@ -446,24 +446,14 @@ static void vme_user_vm_close(struct vm_area_stru=
ct *vma)
> >         kfree(vma_priv);
> >  }
> >
> > -static const struct vm_operations_struct vme_user_vm_ops =3D {
> > -       .open =3D vme_user_vm_open,
> > -       .close =3D vme_user_vm_close,
> > -};
> > -
> > -static int vme_user_master_mmap(unsigned int minor, struct vm_area_str=
uct *vma)
> > +static int vme_user_vm_mapped(unsigned long start, unsigned long end, =
pgoff_t pgoff,
> > +                             const struct file *file, void **vm_privat=
e_data)
> >  {
> > -       int err;
> > +       const unsigned int minor =3D iminor(file_inode(file));
> >         struct vme_user_vma_priv *vma_priv;
> >
> >         mutex_lock(&image[minor].mutex);
> >
> > -       err =3D vme_master_mmap(image[minor].resource, vma);
> > -       if (err) {
> > -               mutex_unlock(&image[minor].mutex);
> > -               return err;
> > -       }
> > -
>
> Ok, this changes the set of the operations performed under image[minor].m=
utex.
> Before we had:
>
> mutex_lock(&image[minor].mutex);
> vme_master_mmap();
> <some final adjustments>
> mutex_unlock(&image[minor].mutex);
>
> Now we have:
>
> mutex_lock(&image[minor].mutex);
> vme_master_mmap_prepare()
> mutex_unlock(&image[minor].mutex);
> vm_iomap_memory();
> mutex_lock(&image[minor].mutex);
> vme_user_vm_mapped(); // <some final adjustments>
> mutex_unlock(&image[minor].mutex);
>
> I think as long as image[minor] does not change while we are not
> holding the mutex we should be safe, and looking at the code it seems
> to be the case. But I'm not familiar with this driver and might be
> wrong. Worth double-checking.

A side note: if we had to hold the mutex across all those operations I
think we would need to take the mutex in the vm_ops->mmap_prepare and
add a vm_ops->map_failed hook or something along that line to drop the
mutex in case mmap_action_complete() fails. Not sure if we will have
such cases though...

>
> >         vma_priv =3D kmalloc_obj(*vma_priv);
> >         if (!vma_priv) {
> >                 mutex_unlock(&image[minor].mutex);
> > @@ -472,22 +462,41 @@ static int vme_user_master_mmap(unsigned int mino=
r, struct vm_area_struct *vma)
> >
> >         vma_priv->minor =3D minor;
> >         refcount_set(&vma_priv->refcnt, 1);
> > -       vma->vm_ops =3D &vme_user_vm_ops;
> > -       vma->vm_private_data =3D vma_priv;
> > -
> > +       *vm_private_data =3D vma_priv;
> >         image[minor].mmap_count++;
> >
> >         mutex_unlock(&image[minor].mutex);
> > -
> >         return 0;
> >  }
> >
> > -static int vme_user_mmap(struct file *file, struct vm_area_struct *vma=
)
> > +static const struct vm_operations_struct vme_user_vm_ops =3D {
> > +       .mapped =3D vme_user_vm_mapped,
> > +       .open =3D vme_user_vm_open,
> > +       .close =3D vme_user_vm_close,
> > +};
> > +
> > +static int vme_user_master_mmap_prepare(unsigned int minor,
> > +                                       struct vm_area_desc *desc)
> > +{
> > +       int err;
> > +
> > +       mutex_lock(&image[minor].mutex);
> > +
> > +       err =3D vme_master_mmap_prepare(image[minor].resource, desc);
> > +       if (!err)
> > +               desc->vm_ops =3D &vme_user_vm_ops;
> > +
> > +       mutex_unlock(&image[minor].mutex);
> > +       return err;
> > +}
> > +
> > +static int vme_user_mmap_prepare(struct vm_area_desc *desc)
> >  {
> > -       unsigned int minor =3D iminor(file_inode(file));
> > +       const struct file *file =3D desc->file;
> > +       const unsigned int minor =3D iminor(file_inode(file));
> >
> >         if (type[minor] =3D=3D MASTER_MINOR)
> > -               return vme_user_master_mmap(minor, vma);
> > +               return vme_user_master_mmap_prepare(minor, desc);
> >
> >         return -ENODEV;
> >  }
> > @@ -498,7 +507,7 @@ static const struct file_operations vme_user_fops =
=3D {
> >         .llseek =3D vme_user_llseek,
> >         .unlocked_ioctl =3D vme_user_unlocked_ioctl,
> >         .compat_ioctl =3D compat_ptr_ioctl,
> > -       .mmap =3D vme_user_mmap,
> > +       .mmap_prepare =3D vme_user_mmap_prepare,
> >  };
> >
> >  static int vme_user_match(struct vme_dev *vdev)
> > --
> > 2.53.0
> >

