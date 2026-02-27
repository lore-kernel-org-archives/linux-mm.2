Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 127C4104891E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 22:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54C2F6B00BB; Fri, 27 Feb 2026 17:20:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 537DB6B00BE; Fri, 27 Feb 2026 17:20:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C1B6B00C0; Fri, 27 Feb 2026 17:20:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29C866B00BB
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:20:19 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB2881A0A02
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:20:18 +0000 (UTC)
X-FDA: 84491656116.28.4F6D149
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id A89B0C000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 22:20:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GnV4jaPd;
	spf=pass (imf28.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772230816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
	b=OS+foA7YjYSWnJUGUrPNLFSdZdGFsM5HEzsBut8J/LB+Nau9TBwvC2PH3jiwfk6f8uoHhj
	gxqf08Eyr6VsBZjMK/iw8fW5YiJXV/DqOKPkT/UeVikiTlZMWPtxEotDvMBJx/hfkE8U8p
	9gsg9aD8uVqdDmECDKjwTtY6IdAGF8U=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GnV4jaPd;
	spf=pass (imf28.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772230816; a=rsa-sha256;
	cv=pass;
	b=gtoccTW4iEt8FMXJBg8kwTvyLc2DiV55SrRxn5SKGR/AgrX6/Ir53OXwZqCwJffLnrYVJg
	1THA1I1NpkQC2ugSr8OAr2g8xuQwE7XmV4A2kic+NkYz4ZnmKUUUAIHEqOcAjRLybFs5xm
	iWNmvz2VzIJ2X2lcXVcPmKjqXO17uKo=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-38704f70ea3so36506501fa.2
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 14:20:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772230815; cv=none;
        d=google.com; s=arc-20240605;
        b=feXZ6Q/WnlaGQwDdmaAoahTflIrpo+EJBzlRXWn4DYBmHbDSD+SNjTo9rnE5ZD9ngQ
         5Sp02WItHbGHegXkXYT9nzuKKEEeCiCl7ptdx0arf2srWogNryMpUesmHMubIpXaB+HW
         JhyGx+wsjb/ZONFW4AzrXHgk4Io1iRuSrTzbugHuvnJT2Phvxx8+BGPPePkdeKzFfiQr
         k/02fZEoE1swnqu6M59JVadRr0Rd3aCwMewEgKNja7ILlNbKFW5o3oDMoxkzotGlpUCN
         nU95NnB7BRJB+f/Pfwo1gFONEqgnoY22VF1wmZbDxPmBZk9qmXpBFm9sVvSMcxvYyUlF
         notQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
        fh=PMQh3GA7oOMnqGx7cIkZXJAoxuBuoEDzk7wb3jEcpvg=;
        b=MsFLKGcAAxhwEJq05KnjvMGC1QGyz9fnmryV6MdKemifKr6gCtzhNyJDUMnCd4axoY
         8MVFmLcj4A9zkGxGpdTWrdYQ/xZ5wkrKEjXvK8UeNa9TTnt96NVTLSBG29KMU8oKlrRU
         Gvhn00XoOn3GSdsWKyki/JGbqms3yMcc3hoXlcqLhGERQ2f8+OnaMJ13xN9LWewmThXw
         JJ7KTf/yrOubkfgTnsVUoeREP6lN6U3/EoOo7yBt2z7Hv2tnJQqBwmeGxyZj/AqFmGF+
         r/IEqXO1IcWqtjedr9AKYlKhTliwAZJZef/9exVtaSxC3YECNrlnd6GPd9TCXz8jqp6b
         1WSg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772230815; x=1772835615; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
        b=GnV4jaPdIiMuuutejUmS4ndloBKcEloQq03x2MJF01vmqwYT4KGFry59PP87Qu3VJB
         Nkd4AW6iwPwuQr+2U9+SUgTbUSItqP5JJRHWZh1e4lsVNvu4n6BQ2nSaV0d9Kdby+oqX
         S53g7N4CMxvhj3QHFuo+l0JQgiwqg/AT9uSGeLhhEBK99J0RhegGxDJzcVPKopg8hTJk
         mB9V4Ysk0WZ6kNOfmyFpKr+9Dwy5XJvndqWVsWyR5dOdKSvw/4hZAYjhv/oBp7Nh2SKJ
         ssiud7CjxlKIHE/kzEiyI97q/nH5uoRMtOVDd8amQBALxsUvGNjo+bVCcAgs5Q7eGP7c
         n3GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772230815; x=1772835615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WC3H5DEaZJ5Vspp5jAs+PxKz8E7K+Tp6LHW5IP31g2M=;
        b=piwubgFyQ3ymdFXiCjQVImTcADQ2wBuLpcEvKnkOwI/zvyyt3YqOR/AzRumjFw9kwW
         9o9CAT7DoJxr9qQE9lCwcKMqwB++raLm18iKvrCm0POzI7UslklVeglv7DN3RE2/VxJG
         HKaAHy57aCz8qfy2ujI5Y9SsZx3xwJn7JQ5EDftl7u6+7fObTjl3ZJFiJ1hUMxnoYLOv
         LuI0q8fE5B9G9PhaYxnVOqmKgKuVbQmCl5loFuPEBWXMvdm6f/xvRakJrrjm+9d27FIb
         KaTQCQZMY7bxmPxuPJrKMpe4zs/VajFcCckKib2zB/NqnyIWAPIc/3MBBlin9Ps0QARf
         rHdw==
X-Forwarded-Encrypted: i=1; AJvYcCUC36VVCnTvGD6ADw+LdTgEZGzvHDniLkuA0NRX1VtrdIlaJSKx85PNFu1fqayFf8EZ8ioMoeM6UA==@kvack.org
X-Gm-Message-State: AOJu0YyrnyJPQCAecQoY+nUIbo1STg+4BWt9wMJrWzmBvjDCYkQNkN1V
	4Z3eYh2649r7iTI2IbzU+yRpRbmh/ILfMvwg6zuBuiJF/OgQkjlJl0ZsyObBJLvyZWRmNbhdtys
	Cqn7cP0n78sSFIthA/Fbr9253P4Y5k+b6gzBNDJRv
X-Gm-Gg: ATEYQzzD1IwYvZT5GyQnGTk5oWI9QbucJW/LUyKxeAywUBBoWjZX9EjLgVTyRXlJuxU
	i6gwLT92i9Rc0vBuWV3tZmRxE3xuJZPFBIlA/9vrTvb8mJ0vLc8z94gpFRoIA6eNQkPxT5jbr2k
	t6wtlC6SJTpP5wtKxpKZwULJ4POepfNJhVUyDNGA1tsK5UwkHgq8rfEY08Tzpc4NW4ucl/9/rcx
	8iE8v2zucvldc0xf0CRL/SpvV1mvaZ3oGUfeyr4BZ0+YGDbZvOyRvdvZDJm6kt6Dgwl4Mer/ETv
	0oNbYmYHKSb181CiuA==
X-Received: by 2002:a2e:be9b:0:b0:389:fcc6:4923 with SMTP id
 38308e7fff4ca-389ff36c676mr32953561fa.36.1772230814172; Fri, 27 Feb 2026
 14:20:14 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-3-dmatlack@google.com> <20260225224651.GA3711085@bhelgaas>
 <aZ-TrC8P0tLYhxXO@google.com> <20260227093233.45891424@shazbot.org>
 <CALzav=dxthSXYo13rOjY710uNbu=6UjzD-OJKm-Xt=wR7oc0mg@mail.gmail.com> <20260227112501.465e2a86@shazbot.org>
In-Reply-To: <20260227112501.465e2a86@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Fri, 27 Feb 2026 14:19:45 -0800
X-Gm-Features: AaiRm50CpBktJDVkdNswfpkBixm1XqIc04gAiSgoLOF5-QNcfKrgPA3B04Dkoqw
Message-ID: <CALzav=egQgG-eHjrjpznGnyf-gpdErSUU_L8y82rbp5u=rQ83A@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Alex Williamson <alex@shazbot.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
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
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A89B0C000F
X-Stat-Signature: tuxe9g3dcfcy9ofme7mfguxhzc5gbru8
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772230816-823021
X-HE-Meta: U2FsdGVkX18brVeMSXVQpnk8H7/q/6xCYBjorvjgKAz52atK0XTX6gxdJ46poy/mwVVMacL05vIi/uvawoQcSO5yNAVcA+ZWTTEJMutNqroK1a74egcACb0Pi0NtObnq5XEmWICpFsXWm7P8mfW0Ow1160Hqv1CI2P6rEQTmdTTTV4f9WTzaZbm6zrf1HfAE5oP1G9ODuoNeUT1ocQn/gneifgK+G6p9gP7tqvdcFZqIp7KbCdsdaANGt1/2bXWPPJ2DVlAdBeiqzdt/C2GhmhTEBxGplo0YEkrKKH+nI+DS7kLT6Y6hKp9Er9oCQ7FBfONxMkZ0wk5jgl21LsoGTeoh8Hsp9vgFi8HQOqwD5rKPLOqvwzeMFy8Kl3RscxoCT8ObqecqnC+r2hgOfN/+wtSd8zFA352LilnokvJ08XYIgoKGbhteiygMCc/nfZwZDiAIujsNkwpdv5iRoPZCZC26rBBxKdI64zfEw8wFojAcDQzMXhPB+oa1YICpV81CdF2O/O0TsQ1VvOObkJoqThN2d/FOXbT0vtpNM9+vN/Lwxui2R/V16aHYoSM271qTiMhtJBJOs71FAL724S5ZA7Ztg9BSMmR+9heLDsHovWoi3TXsd0gqJEJu2uJcby0ahstX6AL9ce5mPGvpyi3RWa2DK+W3eB5fcCUbsaHQZSMzVol1U6LhoAgthZfA/Z3lZm7s9P5G/OdJinlX6td2r77/ORX3IgVNXsfPzOBNNNwa0Ow6eaptgiAL5Yp97bhwQjBaKLTk/6EIEfwoOkzyuP0pw3e7s5eAC5G7IeYkThRN0zyzyuOW7PuevLJWOgJljilDaL4wMhWj45H5QyPrYCZgbfkJvF7QomJ5GlKp+BzT+1LL+FP2dWAkRuamsBv/pRpX7IBjcCNTLl6l2WzJ/51Si469LLhA+itznu0ebM2ytTYBUyOzR21okLuXANxug+SW27fPr3viaI+Fvih
 qhaVB4+m
 I5pIGbfCCmILLfn+nlUEUHvBTbHEebmzxJ2j0sLZ3KcsjiJQWpVYH5ImzDad1+1xKQUSu3CSI+ErX25TqPWrsGhBlwmMd9zQJsJA/xCs7Itjae1ncZ4XOyoMt6Fq03j2++Q4hSt10K0TT8ak1nlWVUBoQ9HZ4TJnzrKCv4ktIF1WyfGM9UY6Vjc23cGArZWrO3Uc/i8W3b9TQ1Qt5CUPHFGoBlUPXQuM7MepgMXiWEyodOionxZnSIW5Lir0OZE7xm1zew3fApGdMlwG4re8Mek/i9mFOTa3U6ch8jCqUtBkvRJ4iXehB/kt8RD2pyuljBXafFL8FVeduHPXaaIyuW/QM81z8knhSiM3KgQXFaJXdJI1BSVfSRLvbmU1igZn/ZZkM0fVW2UBBRuLDP3pfe9Vy0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 10:25=E2=80=AFAM Alex Williamson <alex@shazbot.org>=
 wrote:
>
> On Fri, 27 Feb 2026 09:19:28 -0800
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Feb 27, 2026 at 8:32=E2=80=AFAM Alex Williamson <alex@shazbot.o=
rg> wrote:
> > >
> > > On Thu, 26 Feb 2026 00:28:28 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > > > > +static int pci_flb_preserve(struct liveupdate_flb_op_args *arg=
s)
> > > > > > +{
> > > > > > + struct pci_dev *dev =3D NULL;
> > > > > > + int max_nr_devices =3D 0;
> > > > > > + struct pci_ser *ser;
> > > > > > + unsigned long size;
> > > > > > +
> > > > > > + for_each_pci_dev(dev)
> > > > > > +         max_nr_devices++;
> > > > >
> > > > > How is this protected against hotplug?
> > > >
> > > > Pranjal raised this as well. Here was my reply:
> > > >
> > > > .  Yes, it's possible to run out space to preserve devices if devic=
es are
> > > > .  hot-plugged and then preserved. But I think it's better to defer
> > > > .  handling such a use-case exists (unless you see an obvious simpl=
e
> > > > .  solution). So far I am not seeing preserving hot-plugged devices
> > > > .  across Live Update as a high priority use-case to support.
> > > >
> > > > I am going to add a comment here in the next revision to clarify th=
at.
> > > > I will also add a comment clarifying why this code doesn't bother t=
o
> > > > account for VFs created after this call (preserving VFs are explici=
tly
> > > > disallowed to be preserved in this patch since they require additio=
nal
> > > > support).
> > >
> > > TBH, without SR-IOV support and some examples of in-kernel PF
> > > preservation in support of vfio-pci VFs, it seems like this only
> > > supports a very niche use case.
> >
> > The intent is to start by supporting a simple use-case and expand to
> > more complex scenarios over time, including preserving VFs. Full GPU
> > passthrough is common at cloud providers so even non-VF preservation
> > support is valuable.
> >
> > > I expect the majority of vfio-pci
> > > devices are VFs and I don't think we want to present a solution where
> > > the requirement is to move the PF driver to userspace.
> >
> > JasonG recommended the upstream support for VF preservation be limited
> > to cases where the PF is also bound to VFIO:
> >
> >   https://lore.kernel.org/lkml/20251003120358.GL3195829@ziepe.ca/
> >
> > Within Google we have a way to support in-kernel PF drivers but we are
> > trying to focus on simpler use-cases first upstream.
> >
> > > It's not clear,
> > > for example, how we can have vfio-pci variant drivers relying on
> > > in-kernel channels to PF drivers to support migration in this model.
> >
> > Agree this still needs to be fleshed out and designed. I think the
> > roadmap will be something like:
> >
> >  1. Get non-VF preservation working end-to-end (device fully preserved
> > and doing DMA continuously during Live Update).
> >  2. Extend to support VF preservation where the PF is also bound to vfi=
o-pci.
> >  3. (Maybe) Extend to support in-kernel PF drivers.
> >
> > This series is the first step of #1. I have line of sight to how #2
> > could work since it's all VFIO.
>
> Without 3, does this become a mainstream feature?

I do think there will be enough demand for (3) that it will be worth
doing. But I also think ordering the steps this way makes sense from
an iterative development point of view.

> There's obviously a knee jerk reaction that moving PF drivers into
> userspace is a means to circumvent the GPL that was evident at LPC,
> even if the real reason is "in-kernel is hard".
>
> Related to that, there's also not much difference between a userspace
> driver and an out-of-tree driver when it comes to adding in-kernel code
> for their specific support requirements.  Therefore, unless migration is
> entirely accomplished via a shared dmabuf between PF and VF,
> orchestrated through userspace, I'm not sure how we get to migration,
> making KHO vs migration a binary choice.  I have trouble seeing how
> that's a viable intermediate step.  Thanks,

What do you mean by "migration" in this context?

