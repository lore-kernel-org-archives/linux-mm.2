Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49433C4453E
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:11:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E856B00F0; Wed, 22 Jul 2026 12:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 301336B00F2; Wed, 22 Jul 2026 12:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C89E6B00F3; Wed, 22 Jul 2026 12:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB7206B00F0
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:11:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44723A0130
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:11:13 +0000 (UTC)
X-FDA: 85016902026.10.AF971BB
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 56B9E20008
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:11:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Syjy27n9;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784736671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IcI5qs7jN/uu8ChWZU0RS5LTqt9hibuExW779DaX+1k=;
	b=3dJd4xSxyOB+pPPs2vksxyC1yekLBqLszzTIfPoNQyN6FGB6wuvzoQ6yp6yTbXg2TPusU/
	HTXGsEL9fh7YAgfrsJYw7khLGm4ZX5lUy8nUyiYCl0+YyMZ42REn8bGkTRa3mEN1tZCgES
	er6cD4ruewNlQJyH+RZxRc/PkikuEWs=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Syjy27n9;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.42 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784736671;
	b=psM8oTPIzGUww8SNHIW/873reIHDJuobfxhLNVps5H0f4/aIUMHnQkq/MALQBKDosLmIF/
	TbsOm121duEGMhEFs+Z3w26mbA3RUbCw4ARVM2WBwbxN25nOjwVeh9G0zNZFm1ug+S1d8i
	i0uRmIGur25BzntHJF33y7LOcBQ5RAc=
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5aec6360133so10641752e87.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:11:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784736669; cv=none;
        d=google.com; s=arc-20260327;
        b=KEBPf3NSP3o1VHBd7OaBt56y4LnAxs0VlZ2eLlAf2ZhAe88IzQ0w7AtEQiOnQ6xkhD
         L8KsnTPh9nsVJmxWkwQegRveSnczDTifTe/bca03lan5W8ifg+X/WPCOy0LiOZdUpepX
         1KR7nZGX8VbdNUKeUaGmfkPP6Oq/jeHugcLO7/Fp/P6tHKYB4bK2KJ7+OuC5W1Cdezfa
         sfEAWOUIFPQyI4j93pYdW5ha3jgM6HoboTPHDKRrW/uC89aSraq3ciO5r2uRbOF3NLgr
         HUs9OsuibJC/xQCaJF9voeNTGoqJBIRqJMcsl+pq6wSezCX+cTD4WhOHImu2CkhHVY7R
         xy7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IcI5qs7jN/uu8ChWZU0RS5LTqt9hibuExW779DaX+1k=;
        fh=YN//dpCd+uzz0XbTdxSj4UxzfFX1TmBT4obOLaZvfSQ=;
        b=oNTfiicSsX2/i9kJ7gMykk7goSXzCUm6yKkAcp6uwA7V+am4o8uRdDcSUABPk5CI0L
         jmHUdmCb6GahYMxXe0WVFobXyTVJ7pLf7V+XSsJlh8+TiU09bFDVldj1hl6dAD7BIQZD
         pfSqD+3LEvCXlZcolAJ5lE6PUbshOWxKOvkNw7KfIfgBi+VFFaB+rq2uNrCNsrNKaG47
         bEcM2Da8EZDrOSo/Xa8zRJZ25nhaOk4k6afOK6OV8m1SjSYJCzZSuF1UpT/M02p6CpHK
         HoRbqDQaY80NsD8VtzKDweSTV2QTkt7oWZVpF3cErGIK8to/vyieRYWrE2wJ9OWfBNCZ
         jy6A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784736669; x=1785341469; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IcI5qs7jN/uu8ChWZU0RS5LTqt9hibuExW779DaX+1k=;
        b=Syjy27n96NpgYrjhYYMOCirP9tTyWoYHbDEco2F5VJu1WYsRcwJUOPcZKss82R1K1h
         bZVdLFN9v8Kx8liuLI4w6sUnjbcwRziOa6igPiSqrzoEbatw/Y42yCJYS/7D/5SJwsa6
         D3u2Ihk0948pSL6sFFmiNDnTpqemudf2vEqH0byrx+9LTywGFNtQJQxfY/rBB33Z0W+l
         Q3li7G7MGvvmed/mbONtdTwcdZW7QQEusd01YTYbE18snG12HAj5FIf9E0yj7b6Q/6ig
         jDz7LAX222B/1MOuKacqm1JxFcQHP/6d9+QBPnOMvMLiaRhuGjTVbxGJKOhMe4XBLk1Z
         p47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784736669; x=1785341469;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IcI5qs7jN/uu8ChWZU0RS5LTqt9hibuExW779DaX+1k=;
        b=rfPe53qih0J0toerBWFfagib5HoLDYnpuEaNBJOJbIuncbGGAoAE1DDMHVV4XNvz8m
         CQ1COwNtDLJiJOiB1aH5639DpEq5IG/FQqll4YmCAgvihTZjUBNoGZwJ5e7k6/SP5aEq
         8V8LMHmOSKQnxF6SQLZWDltdCyGnL6c6wE+XLiIEbc1dENfCkleorGbria5hLlAzsfPc
         kko+17PU/zYfunqeV8+6Z1E2LRK5jT+ngA4GofJWUQkGJMIj9rX5O8UPOa6NkmCXRTdd
         hXpDujaO6c/XkWkF8BUFZfUGn7nZVlL4QyAW/hnVi0+OGsyUorlFhd2ZK+ZN26ArWmAE
         ZTJQ==
X-Forwarded-Encrypted: i=1; AHgh+RqBePrnr/8YZaBbjfu7dwlFI3Y5Nf6eXA71QfPVyfBGzVdpAgZ7av86G0c6pTzWJSflcFVk18NTRQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+heGWjT5KequIJnt4SLC1JvYPcz8QAogTqgtWgDWXAT9Jwgpw
	NvLq9lMlX8HAKO8o1BZ6di6dbDfrcysj/FsH39fghqkM1dD5l7R1TxXcvm4yqMGUmckDaG7FRtL
	Ku0q0LyV3Z9b7jSBjSelGf9D29tGPyYUZJMTcevPw
X-Gm-Gg: AR+sD13ovhpcdd6B5yV04TnFCXqzfloy1RR51Nx4dNvlXVOWiRg1+KnfG8xCPMlzC41
	yTwjOTyyLXyjm0oQ7blGRzfwmuj9wHc1Pz06LjJFklUStdA80Mli3JAgOTPHvLwEBwLkfN5s2DU
	7xTEKRxfUUfXaogrPRRHX7oiXU+D09esJ0wTJlDIRF4NHm27uWJ3GSE05Jn8JvwhrzhNbWyrmv8
	7+LyxLjCAq4qKMBaWIprwRfyP2daZc/sm22eY9AIl7v3E823klXOtZMEtEtc/iSHCsVU0R/x19L
	T+ClOwEdIlLFOSui
X-Received: by 2002:a05:6512:124f:b0:5b0:1ace:3bca with SMTP id
 2adb3069b0e04-5b28fac59dcmr5709185e87.65.1784736669024; Wed, 22 Jul 2026
 09:11:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <20260717163820.6bc8c13b@shazbot.org> <CALzav=eQ-0rbxh6Eekbt4zUoNGNZc_THmSCvVWVwE3om1BPtdw@mail.gmail.com>
In-Reply-To: <CALzav=eQ-0rbxh6Eekbt4zUoNGNZc_THmSCvVWVwE3om1BPtdw@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 22 Jul 2026 09:10:35 -0700
X-Gm-Features: AUfX_myAcr2geqnXYh1xnj0XUmNEe2bz-zIOTwyIeRO5MtevXktrjd32lAucA7Y
Message-ID: <CALzav=ej05tZbVJUqZC4BOSCtZ=EkQ8GsckqLN61qKbyMHWfKg@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Alex Williamson <alex@shazbot.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 56B9E20008
X-Rspam-User: 
X-Stat-Signature: j9xrr584cygxk43ao18au341ebhk7rij
X-Rspamd-Server: rspam04
X-HE-Tag: 1784736671-391371
X-HE-Meta: U2FsdGVkX19ggiVP587V5IHhNDtsp7flZkpF+2tFW/cFcqK+4mxzS7DSYL1lkewGzD4dv6Hnd2Ijjyk6FysyTFODnmW6S/52TYsCirPiKPjO727++iOOROj/cCt2gPynD8u/4XNUMOu9oR8m+eLEVQLK/7VSt0T6eKgkk/if+k7bFiNTOOlKtXFNwrNDZXmXYydJ/ysuFK5Giv0CL/cx0S0LEN9LK1RRqF7sDGo6F1o08VFuaqFivuUKODr9a+sVkEU0eXIJx4UIiknS0szyj5ZUvPCNdcx2PsZmXVNC+RTZfKiM16wSNF69zLGpCsxy/Dnzi5FPLa/6Wl2vVn1AyRsD6kZCXShJG6xgfM6cmb4syJGSQ04gvk6Sl4tcBreVjMJvJR4szRNT/+Xdhb/HP2dZ5cl7nZj3EKiNL/H/5kpUARFZfgXFiyyHbSjbOtHOhZxAA+qiN+JmX3nshMp1vDPuzxECWwoDuRN3nKGwwLZB03k1RuMCx1/06d0OL7N0pxskwBzbmlHf7HhMSrxayGvebqiJJ4qSZOSR6jrepzKLUWY4QRz8kOCQlJ+bhRhoB69IXZyOYOtnvgLkgyvGsXR6g/EM0bRui/kUgiJogxZAfDDrvUavHQPv2ytEdU3OUrWD9l1Vf5jioNmjSirWuFIZDvojsXkSHB2ofHzCiw0MylH2JebYj0X2pF3UJ/84SlUVHA31ngi9g40uzM6T/5IqxQQKdTeuRqgcokEsV4DKXQLTbwGMnqUJR84WamDsj4BC3D1HRQaY/DhW/yOSjBs94FwPrunX0YTgH/Ly/nZDzLjL6L6uD2Dh0nhYJLo6wEmp9aiY0NX7T7kDM7F/SzJhOwu1vrX2w45KDC/XQCBgAZ0ZbszORMbLOpyb1CggDDvLl7quzgLkDLWwzfbfWtK6U9Hal4MeAdQrHq5/sHFwL7E72HKlhlQMvTjviJWnmpyrqJp3aUcOODyeUSc
 0pFGoqfk
 qyBOZf+G5WpBeu84+K9KG9T6oN0bXT4jyTNCFfX6gliy2pR+tCfIDNrFhuMIQq0Qz3uV/ohObVaaWrSV/55wH3YmUgq7ZSZVdWHXI2Sf0FGT+24dxC/q7C9AWSYP7S9pzcBB3ijHJme/Atp5rrWQ5A0jzVFj785xIILE8Pd+WkO1C5ogIfLMdgZb5IdmSqvTzOwCYQbeaYBmRKK+Fc9MRLlNVORTdwwK2BDApdE+oW9qMU/9K7inay9Qgr+kQOHTrcS3frVZgzPSSU1mlR93f40NH/nmPY98HKbK+n4uV5v6cR9NwCX3mjp86xlWFizaEyKjd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 3:00=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Fri, Jul 17, 2026 at 3:38=E2=80=AFPM Alex Williamson <alex@shazbot.org=
> wrote:
> >
> > On Fri, 10 Jul 2026 21:26:06 +0000
> > David Matlack <dmatlack@google.com> wrote:
> >
> > > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *d=
ev)
> > >  }
> > >  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> > >
> > > +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void=
)
> > > +{
> > > +     struct pci_flb_incoming *incoming =3D NULL;
> > > +     int ret;
> > > +
> > > +     ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void =
**)&incoming);
> > > +
> > > +     /* Live Update is not enabled. */
> > > +     if (ret =3D=3D -EOPNOTSUPP)
> > > +             return NULL;
> > > +
> > > +     /* Live Update is enabled, but there is no incoming FLB data. *=
/
> > > +     if (ret =3D=3D -ENODATA)
> > > +             return NULL;
> > > +
> > > +     /*
> > > +      * Live Update is enabled and there is incoming FLB data, but n=
one of it
> > > +      * matches pci_liveupdate_flb.compatible.
> > > +      *
> > > +      * This could mean that no PCI FLB data was passed by the previ=
ous
> > > +      * kernel, but it could also mean the previous kernel used a di=
fferent
> > > +      * compatibility string (i.e. a different ABI).
> > > +      */
> > > +     if (ret =3D=3D -ENOENT) {
> > > +             pr_info_once("No incoming FLB matched %s\n", pci_liveup=
date_flb.compatible);
> > > +             return NULL;
> > > +     }
> > > +
> > > +     /*
> > > +      * There is incoming FLB data that matches pci_liveupdate_flb.c=
ompatible
> > > +      * but it cannot be retrieved.
> > > +      */
> > > +     if (ret)
> > > +             panic("Failed to retrieve incoming FLB data (%d)\n", re=
t);
> > > +
> > > +     return incoming;
> > > +}
> >
> > I'm having trouble following the error escalation here.  What's
> > fundamentally the difference between FLB data being provided and not
> > compatible (subtle log message) versus FLB data being provided and
> > compatible but we cannot access it (panic!)?
>
> There is no fundamental difference IMO and I think we should handle
> them the same way (panic). The problem is the PCI core cannot actually
> distinguish between "PCI FLB provided and not compatible" (should
> panic) and "no PCI FLB provided" (should log). I would like to propose
> changes to LUO so that the FLB handlers can detect the former
> situation but that requires some non-trivial work that I didn't want
> to block on.
>
> For now, I guess you could say it is up to the user to not perform
> Live Update between incompatible versions. I can update the
> documentation.

An alternative approach would be to make the PCI compatibility string
just "pci" and then put the version number as the first field in
struct pci_ser. That would ensure the PCI core can always fetch its
FLB data and panic on a version mismatch. I think first-class handling
in LUO would be better, but that is a larger problem to solve; it also
needs to be solved for file handlers.

Pasha and Sami, what do you think?

> >
> > Don't both suggest devices are running but we can't get their FLB data
> > to continue letting them run?
> >
> > The errno interpretation is also slightly different than the comment
> > above liveupdate_flb_get_incoming():
> >
> >  * Return: 0 on success, or a negative errno on failure. -ENODATA means=
 no
> >  * incoming FLB data, -ENOENT means specific flb not found in the incom=
ing
> >  * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
> >  * live update is disabled or not configured.
>
> I think the only disagreement is the lack of specific -ENODEV
> handling. Is that what you are referring to?
>
> >
> > Thanks,
> > Alex

