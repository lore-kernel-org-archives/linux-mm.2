Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1785DF4BB78
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B84C6B0088; Tue, 24 Feb 2026 14:17:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4999E6B0089; Tue, 24 Feb 2026 14:17:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 371C06B008A; Tue, 24 Feb 2026 14:17:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 241D76B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:17:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D6DFFB757C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:17:28 +0000 (UTC)
X-FDA: 84480308976.09.B6AF5FE
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf05.hostedemail.com (Postfix) with ESMTP id CABF3100009
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:17:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Qek/HBEX";
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771960646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
	b=Z97wqQcW5fhXQO69ZT47PxF6QsFOdvPWWdHsETRb9tfvOU/6HsFB/SnZfvH6qN+MSvwUeu
	htoUxP54zuKCBZqNU6RClL4y16dh/4Legz0xm7FnzK7blvUIyOavpYppreMOWTBMaibGlB
	kGL60EoXuu0wBTwrW1Iw+EEWyAZGro4=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Qek/HBEX";
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771960647; a=rsa-sha256;
	cv=pass;
	b=FiPKxCeVCY+7aVwVWfsoAefinkysTDIo1LHTwEpZqewsYJcQ3v5DntD2I6hxtKhE1xOacK
	0dUUUbvO0/UFZOqVbc5KTUgmTp6/O1vvGaOZgN9m4ZCpHlo9gkmhn3A5fUVWWkGUzhpcT4
	vFnFXfGIBQyDxX3PnwpkHDhqlYn8l+E=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38700168abaso47829191fa.3
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:17:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771960645; cv=none;
        d=google.com; s=arc-20240605;
        b=LDZgMIky+u0Y9rHwX4g30FFjdW1oDHo2+PvjBXm20Lv8Inbd1DgvgzBDNNIQLMrOeo
         4hp8TFD/bNTRLwiD9Q1JpuX8eh6JK+6tUzsTZ/MqwRrX6GE+RS7gj3XVfBZDAx9NdraK
         XhqvGbQsjsCzwsT9jXpQJ2bhsJkuzi5CPoc3CPvkvQL1AHJLk1GOXUtBme3jUHKECpZc
         43A8ASdxWBqoQWLkMkOPAOIc5mvEJ2M1fKEPFgH9rBGcE1+FMxnungZYpNQ3S0A0sQN6
         8nZvmix4cNplgp2ecdVLGzcsd3Gu2AFs5eEbCT3qKpDaCx0Ay89gsuxhtJoAvq+XSdUR
         5T2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
        fh=XpwA8cVW1SLqhna0IWKzAgIHEdbCQAXwGHm0ZAQudHA=;
        b=NrluqZIXnpqBRKykfleKERSHy2vMjgwvq2oy8R++fWFsJrlVsG6pco6SUUfwUNocJq
         4Rn3ZV+tovhQjCVgcddefMDfyPmFx0HaZkswEYcW1Zap84ZEQO99moZSZ60ayzREzsdo
         +t9cYM4CIYrcM/q99WcnHN6+wof2+8ts+ZSbcPF4we0WhD66zfkfwnT8o9x/WiXi5Pyq
         EUR5WxrXbFabxYGAc6vU8l4Hh9kI2AX6wh0036cUvMThdiTrsSQOZf1IF3MMNpKjlIDh
         Ocjbrn1KxYUa1KlGVNtLn3qCpEbK/un9yjIgWYil6zd5eRlvUaNdIxFxEI+mhBrlVJbl
         SKWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771960645; x=1772565445; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
        b=Qek/HBEXoWek+Su+9EHw2ASKLXwN/aJGiCfbfYxLII4UO2/XQ9qdf3HitCWssWDQXf
         LCf4cWU4xsVmXX6ZzfDWbfHJIGpKOW/IMe/MksU1mjXAwvPG/8COCbaUyswqSuN7OaIg
         bCheOcRZf50XToQt7pml/rMlQMlyU8cEWBqC9rZ4NjDXD0EcsqIwo9+SHZyIjqugo9UK
         72it+O7YJYdgIWr2Fw1qrPwR5KxwMD5S6n8I2840R23+xtfod0tycep2gZJYp71poPyO
         BFj+A0e59XfHm1l/6JMGC47KSG/k+d/iglZp+4lT2ejWkyh+WxGt08paXkVba927t0+P
         SipA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771960645; x=1772565445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z8YRbhMW1jrVERHtyC2DuVPZZxUiR82Iag5u5UTa32g=;
        b=XKzPUfFePJpAegVYw0D1yFjAbn594Lfbl1VCJdNBwtTLj9N6CLm6adWBfte5b78o6L
         mma2XlmgftuXJXbsiiz+iygfVPjctyCK1YHNtGvBzBAvc3qN/g0lQX5KTb8DeHrrKMCH
         uTcelN3sjiLttVb9aV8F7rxfbQIj4jgEMOR9rog62KRLxIaagN83JVT59awSCxfKGQP4
         X7EYdfKa32r9c8lXrQDAyJ7d2D4q7JghDsQyh6gDoVtlLWD/FVKzPnmv+RHfw3VYayzC
         2VRZVi6p9e7jim+DH1DvF/FsytCgsyt+iiPheEo6HU4hzwAONTJlLvcZjjj1meeg1OjG
         qkbQ==
X-Forwarded-Encrypted: i=1; AJvYcCU43b0DvynDoV947atqOrXBfFsPqWJzZTc8jIH67an4UivdDP/6f5LGBynU6xDz1o1z54PhPmR4bA==@kvack.org
X-Gm-Message-State: AOJu0YwqHmqheo/DZWjU1QLR3r3Z66vEBut//XWQnM+bv9EPHVnIEO5H
	Wgye8ck37ZQ4Gz2HbBVlEDOUkQDQMLvxYZA+0vDOgdcn7OUkjNFZ/BXJuVtSUpi0ENjlO7Alaox
	m3j7qR8npPnLIGQIECU4EsofpZ/RCV36v0jBQWqs2
X-Gm-Gg: ATEYQzw/jQWQbN77GnT+leJBcsRK/jh0PfuaDvb3/D0s+fd5eJrxQiTq+aBsaZcwJNj
	xFJymdLm16hr7tvZiLq3HL82znM033jstaPU7olK3atKdBIEYDQmj/gqh2LKeYAuTN1irfiH+Is
	VXbq/ask1P3oxvZN757fW64bGS0NjhFt5hgPFg7hww4/QF0K0Pb8ZPfGvN3Rc0H3mNXLZkR6lts
	CX13G79j1McaB8+PHGeWx4KXyArNJ2sjXCaAz7GW2+nX/nOC5coaswQ6bEqtsDcrgbJ+SRNsDao
	XJ5WAuo=
X-Received: by 2002:a2e:be8b:0:b0:386:e7a5:e26d with SMTP id
 38308e7fff4ca-389a5d5146bmr47895731fa.2.1771960644178; Tue, 24 Feb 2026
 11:17:24 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-6-dmatlack@google.com>
 <aZ3wBpYSF7mQv_GZ@google.com>
In-Reply-To: <aZ3wBpYSF7mQv_GZ@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Feb 2026 11:16:55 -0800
X-Gm-Features: AaiRm51YtBXd00PzQGhlvFr4r1F_UzQj5UbNk9Nur9O6pTAPmY6O7yFJgVZNGgc
Message-ID: <CALzav=cabKYFs3yhBEWOS9qseOY7rSh7F_Q40fu4spnYpmZMtQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across
 Live Update
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CABF3100009
X-Rspamd-Server: rspam02
X-Stat-Signature: jwd6iypx5ukkxhurf5a8e94qbzcieu3n
X-HE-Tag: 1771960646-169964
X-HE-Meta: U2FsdGVkX18jD8kK1BIip8Jw7YIJ7TErKYuVU1hVZTMpQdB6e5RRtgbbvcXPE4wPRE+/W9vw7h1qZrBGi5d5llYU3gYUwqalajg8UNaOmBl6RwLY0SDb2Ecll7lRVFFZq3cCd9XN81fQUbZkIT2aRCxd1qSeDz/vKo6KO6X6CtYMmVvKUwfLcHTn070FgT22I7XJ4IpIvHGwJgkoiiWipzlxBb1Ko+wyCq33igtzpZokci3f6R1j8+VO4l9RWCo1N2h6aYfCl2f1wieHJ0KVSGgmeyB3EHa6IQpa2yScdu9PnRETftVIjKT1fUJWbxOPDWa0eI4PUF3rZ6Bz+h9Us5EILUQWOWGF4OXWSUarLTtbO0+3ToJF8trri0HNMDqXshn7LAL5Qn573+FtM2aiv9mwSaxrYrilxjOeSK5NUkZ9X0K7+LDn848VRV9p0hxlKYP438nKhcJZnNWNG2Ojbhx0ByUoWH5glM6Xsh5v37OevVL5Bmuh4GAd/m4e7P2Vj3qxtorO3n/FigKlh/RNmai7rCbCnhpL6OVftlZ+ejrtMKeWrul3fYQgf3j4jKkAL8nD0fqAEYyrbhKdcIEcIr4H4DD4I3t/VZL10JK0wzgKUSj4M/ADjNziUMrAL0gcEVbUXFRdR0KV+H+O3xvQUO3lSXuiE6b6Sk/yCHlyAolTQelXtmyICQfTk4Dp01wZl7w/YavixxEsb2WAIt+7gwgmrDgMZecGQXOYTZGF/88D1ze3sKNFxC91Rpzb87oMMyZsPH/q9poEZJ3Fd7iLgGThFAfZeQU/WqktCd6lErNIZ20r+HYMRaM1iHLmVd0j2Z1tFgX0zCN5sPdBEKWBxA8kpf0PsXNvKRJ7dVYyQqCYXsmJ1hcw8sGH0hHBGX+djkQ9PMSUxFVwRAXddjtCDApHuTK9/lNmVsuR3s6gbu2I9RSlmnMMDzFR2cQINNcAATKyJb/sve/M8xcRggc
 AuFu9tOI
 Yq6qHhX69dzXDgr7utO0TQQ50om4is9kc28WlOwCz7WDa3KINed7mZCVIHYhED5bvekDmJej9mKVlbV4fWup64B3+hwnVxtDXio5dn2BrSYORFiI3lh6yCixUXd55vmbmHd75tTrl2fNNDMN+FAvfumV4FCp+M7Qy8JYF1w+s76TO5hVzxTf/m0ZBn2VveD2togDhCgmkcNSQZSQGcmJISntqZbUA/w9Y6vtHmHf9p3qcoGTGIvyLPcxMaiK9h7LgtL/Pap7Kj7ImsvA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 10:38=E2=80=AFAM Pranjal Shrivastava <praan@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:52PM +0000, David Matlack wrote:

> > +     /*
> > +      * Reset the device and restore it back to its original state bef=
ore
> > +      * handing it to the next kernel.
> > +      *
> > +      * Eventually both of these should be dropped and the device shou=
ld be
> > +      * kept running with its current state across the Live Update.
> > +      */
> > +     if (vdev->reset_works)
> > +             ret =3D __pci_reset_function_locked(pdev);
>
> I see the 'Eventually both of these should be dropped' comment,
> which acknowledges that a reset is a v1 crutch. However, I wanted to
> clarify the fallback strategy here.
>
> If vdev->reset_works is false, we skip the reset but still jump into the
> new kernel. For devices that don't support FLR, are we comfortable jumpin=
g
> with the device potentially still hot?

That situation is already possible today. Simply use a VFIO device
that does not support reset, close it, and then kexec into a new
kernel. vfio_pci_core_disable() (which runs when the last reference to
the VFIO device file is dropped) also skips the reset, and kexec does
not reset devices.

Note that we still restore the state, which at least will reset the
device's configuration back to a sane default, including disabling bus
mastering.

> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e90859956514..9aa1587fea19 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -81,6 +81,34 @@ struct vfio_device {
> >  #endif
> >  };
> >
> > +struct vfio_device_file {
> > +     struct vfio_device *device;
> > +     struct vfio_group *group;
> > +
> > +     u8 access_granted;
> > +     u32 devid; /* only valid when iommufd is valid */
> > +     spinlock_t kvm_ref_lock; /* protect kvm field */
> > +     struct kvm *kvm;
> > +     struct iommufd_ctx *iommufd; /* protected by struct vfio_device_s=
et::lock */
> > +};
> > +
> > +extern const struct file_operations vfio_device_fops;
> > +
>
> There seem to be two extern declarations for vfio_device_fops in both
> vfio_pci_priv.h and include/linux/vfio.h. Could we consolidate these?

Sure I can clean those up.

> > +static inline struct vfio_device_file *to_vfio_device_file(struct file=
 *file)
> > +{
> > +     if (file->f_op !=3D &vfio_device_fops)
> > +             return NULL;
> > +
> > +     return file->private_data;
> > +}
> > +
> > +static inline struct vfio_device *vfio_device_from_file(struct file *f=
ile)
> > +{
> > +     struct vfio_device_file *df =3D to_vfio_device_file(file);
> > +
> > +     return df ? df->device : NULL;
> > +}
> > +
>
> I'm a little uncomfortable with this part. Why is it necessary to expose
> the internal vfio_device_file structure to drivers? If this is only to
> support vfio_device_from_file(), could we not keep the structure private
> and just export the helper function instead?

Yeah, no problem.

> Exposing internal state into the public API introduces some maintenance
> constraints for e.g. if vfio_main.c ever changes how it tracks
> file-to-device mappings or its internal security state (like
> access_granted), it now has to worry about breaking external drivers.
>
> I believe we expose the struct just to power these static inline helper
> (mainly vfio_device_from_file) ? Instead, could we treat
> `vfio_device_file` as an opaque type in the public header (like struct
> iommu_group) and move the implementation of vfio_device_from_file() into
> vfio_main.c as an exported symbol? This gives drivers the vfio_device
> pointer they need without leaking the core's private internals.

Good points.

