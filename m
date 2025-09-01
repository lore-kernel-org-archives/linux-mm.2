Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83428CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E5E8E0016; Mon,  1 Sep 2025 12:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106828E0009; Mon,  1 Sep 2025 12:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043A88E0016; Mon,  1 Sep 2025 12:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E96348E0009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:54:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93D671A09A2
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:54:55 +0000 (UTC)
X-FDA: 83841280950.02.D32E1F3
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id B4CDC80009
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:54:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F4vnRX6t;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756745693; a=rsa-sha256;
	cv=none;
	b=Vospz/PAJY5LGM6yBXL19GS8ksUs1cJNo5H9M1qALFdVeVTHmSg6MPAW2AzBCcivHBzJ5l
	x+do3pNqtuDowMsHa66ZQylds5INgJoUAqyoSQg87k5hWkGCXwUYYOYojccpfB1ifVVxeV
	4R9Zu7LMONMbHKs0o4PrzhsMgICKNqk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F4vnRX6t;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756745693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o279Shh53JnSEmHzGwRb/h+6P8VUc/oKT/oRF8TU58I=;
	b=N7/jg7Xwe2PFExYOWDmMjBBDiH33xfUU0wGYX8ah26b1Sueli4vQ0+rtiVYwh5RdoI+LxC
	bGk3pFWQhK6KWn2gDULJ9mgb8Egd+1qDEsvu7+omgCZHeHCBrarGHcBB0VtHr66DOHjOR0
	2Q/kk80T29oFDGfwWtdGQoRosJcJeok=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4b109c482c8so83948811cf.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1756745693; x=1757350493; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o279Shh53JnSEmHzGwRb/h+6P8VUc/oKT/oRF8TU58I=;
        b=F4vnRX6t+40o6BIineVOTnXJ/kSe20mpYrzxNzssU2t9yNOFqAiole64xdhb1Z41HN
         XRaFNpe4CI/RgkzRI6c/y5CCvvWFWYVO2PEwYjyopjkqeDuVe0iGVaefLBWFGTnoaxdY
         XmXsyTxgXLcUYI5BWII1CYqvsutyTZkdX9MzYuXjMyV/oW1B4fcmLsEqesXp9aP/nK9n
         7AB8zujdh257NJgbr1aL06wb7nHQpE97R0WlzMUGzs7uGhTtfBe786dyCGdsYPlIrZZJ
         n7mUI8tMvyj31/17xzi54H0g7Mq2S8nGDddgk+9vSXPOiz2MI/dARyIftJxV5TEvH6V9
         fZMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756745693; x=1757350493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o279Shh53JnSEmHzGwRb/h+6P8VUc/oKT/oRF8TU58I=;
        b=L5zPbjMQSBw9gafQv5VaOx22G2NkiSMF7XBmtBwrELWwyz4RQYxwlFZ2E7VBLCIdSS
         hv8qvu4Dmd+V2c80JmTfaVy9oh+Rf+gxqXA2BYbOqcF2eECEcKpyXVpro53pqtv7zBLN
         5QpAuoDmuwKGwCF4ncj3lEWE9u83Ap2U5Ri7ojtebOTM614ZqZWYmlqMshNC/2VeKE8d
         BkumOu9Ny5Jzxgwzn0DLsJdomtzSiO9dNvnoy+s4yHM0REzLQxiDoehrDJ0sQctrRz40
         nFYT7wT8Ac/rALx/394YMYmfCIb7uO3UxjeZ1bLI8bBscZczRKvUnqAXJJtVriCOBMqT
         sePg==
X-Forwarded-Encrypted: i=1; AJvYcCUx3FUCZPVeFH+rrLUIqfyqCejFjbCsIvJIHK1gb0astW0Gyi5GHnQonfnesIYfwx5Df9weSFPigA==@kvack.org
X-Gm-Message-State: AOJu0Ywe5mUK95R2Pn+vaIIeDFh2mPKQCAsaFErt+jrLcf6zNYvF48WO
	MlFo2Z/JiSNiwvLGIKPf1qM+eMw4BbJ4Gah3wVb/cZYcCoB5Pi44/FcnCu91FgWZ23cGxq4IZUo
	VZ7szCu+f23sglqcrfRsGQiF+eIt8C2NRH+5WzVPyOw==
X-Gm-Gg: ASbGnct+4ytPk5NYpMK9XyMbD8YFivUxQaYvG/53Jv1Y8+KQwpi8Tv3mJB6xfG4mY6S
	UPCwbL0L7grjVlesnUh25ePcP45PpFBBz+DL0/G1bAWUwofH6YO1OZCWqIramZZEeqygJBzLq5z
	wadrvoneOgBCbvOTVeOjmG4r+lY31soelv5KB0xmAeADHnAwRU9s5BEok42I28gfFThtDr20sbq
	o32
X-Google-Smtp-Source: AGHT+IHY/eg6lEzMqM6Ga55zC7XFq05s8YP913RvP8Vq9OFKOx955V1owXgBZfCIMqTYLUmetiFwFefB0L5EXnJijhY=
X-Received: by 2002:a05:622a:99a:b0:4b2:9620:33b3 with SMTP id
 d75a77b69052e-4b31da1d546mr115573791cf.34.1756745692646; Mon, 01 Sep 2025
 09:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-30-pasha.tatashin@soleen.com> <20250826162019.GD2130239@nvidia.com>
 <aLXIcUwt0HVzRpYW@kernel.org>
In-Reply-To: <aLXIcUwt0HVzRpYW@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 1 Sep 2025 16:54:15 +0000
X-Gm-Features: Ac12FXwjvuuXLl4TYrvSYicUEdLVOyp0TZPBIDlFXyKegWX4ZiFbjlDKbUPVZr0
Message-ID: <CA+CK2bC96fxHBb78DvNhyfdjsDfPCLY5J5cN8W0hUDt9KAPBJQ@mail.gmail.com>
Subject: Re: [PATCH v3 29/30] luo: allow preserving memfd
To: Mike Rapoport <rppt@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, pratyush@kernel.org, jasonmiu@google.com, 
	graf@amazon.com, changyuanl@google.com, dmatlack@google.com, 
	rientjes@google.com, corbet@lwn.net, rdunlap@infradead.org, 
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, ojeda@kernel.org, 
	aliceryhl@google.com, masahiroy@kernel.org, akpm@linux-foundation.org, 
	tj@kernel.org, yoann.congal@smile.fr, mmaurer@google.com, 
	roman.gushchin@linux.dev, chenridong@huawei.com, axboe@kernel.dk, 
	mark.rutland@arm.com, jannh@google.com, vincent.guittot@linaro.org, 
	hannes@cmpxchg.org, dan.j.williams@intel.com, david@redhat.com, 
	joel.granados@kernel.org, rostedt@goodmis.org, anna.schumaker@oracle.com, 
	song@kernel.org, zhangguopeng@kylinos.cn, linux@weissschuh.net, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, 
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com, 
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	rafael@kernel.org, dakr@kernel.org, bartosz.golaszewski@linaro.org, 
	cw00.choi@samsung.com, myungjoo.ham@samsung.com, yesanishhere@gmail.com, 
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com, 
	aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net, 
	brauner@kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	saeedm@nvidia.com, ajayachandra@nvidia.com, parav@nvidia.com, 
	leonro@nvidia.com, witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B4CDC80009
X-Stat-Signature: psdsmgrfg3nznbcbsqxe8qomsosejco3
X-HE-Tag: 1756745693-905172
X-HE-Meta: U2FsdGVkX190ViKk0D87gHgLgTcmVkzq1CJnAgCuLW7Fv8y5YXgwEB2PrEObkrDiLx7Sc8/xm+eW/kaFmiAu9A1Hzq9kTyQig986ynuL1/OMkmIHxJMzqgl0GY3/0ag+aAgbkwkxBaidOuwf8E0jXqT4sj+arQ72jPo2Ic+3mMh34mnyPaFyKFalkMbaID2ETRk3tyqo2yIlhf09KV8PkGVWNKmJHYpDXVsGuoM0koecP50e1RoUMYX40aAxMIDfhoNdxCZkuyxlw1H3myTjghvTL6d7Iq0ms1WorMhVUHI8Gx+17wPg/lS7yFPihVONokFTEJnX0tw3Xb3jsGJvQTCbYoUKvC8J0ImW/xGcYz2c/tpE4Srh3nQ/d+6JwQm7QhWZdppEMyZArgj6Rt9mE3wYoyJ6dAay5y51wobsft2e5u+6m+eqx8gPOH4Tu6QJr0OunwD6uhwteaHaEMDTusCYhbFX8w39aMcApp1ZIpQG7i2QWdal2AkfqmCsSfHxDSqdQcXfbxrcAEeDQ9jM2/H/E7mDebTf83O7LjfJ8xcjHBW0a9qznkj8dpURveMhPW4zaxOcsPxD3E1mxsea2RdfPh6lz3++/XxifdxDDs+k17EzDd15nCRgY2vD65QibFcmkLC89ostGBL54p6UIGxUDi4xBMejsqxzqNTacJAugAhCQJ4T6CQsx2XVaVSk/9UdATSof4PPuKgh8BzCyEIXIkteH4OWadhVTSnc4YLUkJVH44fWyzsJShvxEMOa0vw670Ep9Z0gNcJw1XsYnk1LY0vrvUU5WmtR2CuLqBANKWZ9n0XJepDa24zYAN6Jzhg+AY9nMTBNVB3yMWpG+pnbkYO/iyQqNu3o3MGUDf4fD/lvBv0oeqpz8HuQd6qqpiSHmsARiS3ONFQtGHWdO66qS9s3GAdB1RzweP1NdU+DVOubdaGWm8Zn79cjfdly5Ztw8WH7jIUj2Z+86Hf
 S+VUHxLd
 YPOpIoxBPlu4e07Ful8LEQzfBace9XWFdXPaasMSA3rxcwk/3mGU5M6Wf8zxxdw0mPnVNb3+VviVD4Y/The95gJdJa/BqTnPxoC1pRmf8rKfoCA+5EST9PtsOlcaAzcBP2opSngM+Qd22mQyz+qMlzHMgyXAb8Yzbrao1SznYLPflaP/frF1h1e64jKqeBc+wh65UEOA0Xo36tf5FsZ+o4zJ1lExoeZ/mLcyXmjh3TTeqQdBj79eIxsXC6W5A3GyTnzQVMMo7/VHXw5CiTR2NJ2qPpfCVNUvGj79L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 1, 2025 at 4:23=E2=80=AFPM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Tue, Aug 26, 2025 at 01:20:19PM -0300, Jason Gunthorpe wrote:
> > On Thu, Aug 07, 2025 at 01:44:35AM +0000, Pasha Tatashin wrote:
> >
> > > +   /*
> > > +    * Most of the space should be taken by preserved folios. So take=
 its
> > > +    * size, plus a page for other properties.
> > > +    */
> > > +   fdt =3D memfd_luo_create_fdt(PAGE_ALIGN(preserved_size) + PAGE_SI=
ZE);
> > > +   if (!fdt) {
> > > +           err =3D -ENOMEM;
> > > +           goto err_unpin;
> > > +   }
> >
> > This doesn't seem to have any versioning scheme, it really should..
> >
> > > +   err =3D fdt_property_placeholder(fdt, "folios", preserved_size,
> > > +                                  (void **)&preserved_folios);
> > > +   if (err) {
> > > +           pr_err("Failed to reserve folios property in FDT: %s\n",
> > > +                  fdt_strerror(err));
> > > +           err =3D -ENOMEM;
> > > +           goto err_free_fdt;
> > > +   }
> >
> > Yuk.
> >
> > This really wants some luo helper
> >
> > 'luo alloc array'
> > 'luo restore array'
> > 'luo free array'
>
> We can just add kho_{preserve,restore}_vmalloc(). I've drafted it here:
> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=3Dk=
ho/vmalloc/v1

The patch looks okay to me, but it doesn't support holes in vmap
areas. While that is likely acceptable for vmalloc, it could be a
problem if we want to preserve memfd with holes and using vmap
preservation as a method, which would require a different approach.
Still, this would help with preserving memfd.

However, I wonder if we should add a separate preservation library on
top of the kho and not as part of kho (or at least keep them in a
separate file from core logic). This would allow us to preserve more
advanced data structures such as this and define preservation version
control, similar to Jason's store_object/restore_object proposal.

>
> Will wait for kbuild and then send proper patches.
>
>
> --
> Sincerely yours,
> Mike.

