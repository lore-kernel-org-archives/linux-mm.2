Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA6B8C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 17:41:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E36B6B0088; Mon, 27 Jul 2026 13:41:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7942B6B0095; Mon, 27 Jul 2026 13:41:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65E976B0098; Mon, 27 Jul 2026 13:41:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 392746B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 13:41:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2BB1A0157
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:41:23 +0000 (UTC)
X-FDA: 85035273246.08.0CC661E
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6F28100002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 17:41:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="b4sc3/pw";
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785174081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=goSDZrkoP4CAKwXn9vTqQBBWqi12AJrVoF+aHToitxQ=;
	b=hnKOc9yKpCKLB3G7lSSjioKqsNLgZdw5nsAYY6Z0bGRGzwSAqhiqWZxDVuiI7H/2QWyH3p
	XhzOJq+ftTCCtgxtkyuMxndQtW7PTxyAQG9iij8b6e1EbLuyXb0bc+ZnpCDsThFGhsppYS
	bKLRgFE3puCG8UvmmCPhle10Ev/b3wc=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785174081;
	b=Dl75HPPaG3RhgvgYY/H6QUEYTWKBvCSuSquGlZbBLpTXWCqIFVfffOLTW5yhuIBEns569U
	T84qdq7WRSLf2hzTjwz14a3NQKwQxAkGrIgKQDD+J9VM0VfX6zFfmCBiPUf+x9W2fKnbTJ
	C7v5iPyXCMFJ0PeUVMKF0J3hd1+NnGc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="b4sc3/pw";
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so2188150a91.2
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:41:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785174081; cv=none;
        d=google.com; s=arc-20260327;
        b=N8WQeT3rywxOHKwK+Ls47KWWRInLgw+49C89nLu8taApWoY6fnBFXLcAxrYgemzpd2
         zF7p0HZ2c2ZTiZ63DXFf3hXCCfkK9H7ZBI+BH1yJKIR8hPR+GLGdg4vKhhsNLTrmBulz
         NZ87heZJjHb0Ygdrg63zuOey163xM+tutfFAiCIgcZTySH4CEgRCapB5JdtIhOv2Wpbu
         QXkhKsl7N4t6gOnj/MZlBrAHzv1btc6gv5+mHRzyTjcHOGnq1UtpCmBQynNyRnycO6N8
         UzMA8C9LsFUI8vE4bfFDhW8O/F8Ang2fVl7M7omih43yEMuymvjIU2E29F+wfbYjaFYK
         uMYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=goSDZrkoP4CAKwXn9vTqQBBWqi12AJrVoF+aHToitxQ=;
        fh=r+9XsoKBIhH24EMWneO8ZvJ8CqKmknozt3NTuo3+guI=;
        b=A3FjC4b9Of3hAVjrLgGeHtom6C3K2E8c916kvaU9317BW4IzodIjUgH2KEaCOtfl8x
         Ji9Gg2zJyC6uCtv2eCJc/vgGW/CAO99j5UkF7ooId953sTlPcRiEGLxn93n0dhzGEqLH
         CBBOtIgs1aTI+tOKJXFm3O/8uYShwOAmwm3aR5lftyzJDtNIdmTSbkIruxRE3QDjGntE
         9DVFHFftQVvummxB5KBpLb1eoaam5Th9Kjfa/5XUPuL5mj91waQ4esTKP4SLtrTwSJEs
         79+IlhI/SOQvFvUpJZ2G7Op88UpgAtlFWwv058bVg98NpSfRaooD27lys/eQPShHoV5z
         RO3w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785174081; x=1785778881; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=goSDZrkoP4CAKwXn9vTqQBBWqi12AJrVoF+aHToitxQ=;
        b=b4sc3/pwLRu1TmYMp+dQCbVwpJjDcu/oLzLrAb+oPT4KS/r/KLVwWzu13RWK0HdAfT
         i+1w9z6PaPyGC/fFQKvroi7S4GOIfHmYCghCWbMDQf4E5pMSJJDQuQANvI1LsHYc8Xvm
         Rna5NINi9D0OPvCbSGL/pGvQIP8JLL+pa+oJY/o5W7d4vTjbNVYvtoX9uJ/igsGJdZZj
         yISWzVrSEygLylY6F/2EF6qHU0T4iP4D3ifADLFTPd+jO/jrWrso/PN61Y8aMvZkPE9p
         H9VrgXNcpWCioJRq1VKonrB36IkF219L7xynzdNR7HOVAAfHYRDkxr5+Iuy20fLALJGi
         JwrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785174081; x=1785778881;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=goSDZrkoP4CAKwXn9vTqQBBWqi12AJrVoF+aHToitxQ=;
        b=SWqBNJ11a4k/koliiDkho4+NVrTEE91JXCUHVCgWtERjt7goCQLMWBpGX6miF9j1Uj
         6h5bNKRUuyodcoQzCiutRyQFMYRODWy6liaaN/Qg/Hfyiiq4prD4bF7PNeArGuBss3cY
         bKxRqM0IPau09nqxwoBT9zcUhQwCy9lHCsOeadF7ran59OpsNEh/SXaxFQkiKEV7tSpI
         tWOAZh00COWoAdkRgu0IdIwzWfEBG3UDbKg2DXTHS0H7UuI0THTPO+GDqxfqXdKNQVy4
         YL2a8mpalCtdCAsTqWQtBEU3fPQKZ+TJSFC+mA9+UmHsMlOkweFTYC+l20am9U4E9aFk
         aT9Q==
X-Forwarded-Encrypted: i=1; AHgh+RqPdPMaArN58zAumxD0Kc/EHX3kZBm5/6P19YSu+2j8ktX3PAQHOOdT3g7w43Wq6goNUE6dnDy0NQ==@kvack.org
X-Gm-Message-State: AOJu0YxT66cJQ5dxrF6qEwldHNbfgnNQkx99yeaZrSS7PL3GWO6PSJqC
	62TJq122SQmsSK/NjrGUNeCKbT7jU0qSRvIKOCWccChI7bCcNUYm7uA60ZPiNfbL67KgDBdHpQT
	r9CQdsSdRrkVA3EvGmTxUodAAs3bGek2eyuHyuVb8
X-Gm-Gg: AR+sD13PVJUszxfTx26g+y3P87QGHZKsK9NRJPfe0Q4Dln9XgO0X78qQnRMDU+SvJ5T
	T6m8NbuL5IJ66RgxpILnhH/p218uOz0xjOer31EvIsgdFcU3j11Ldm4mXJVxJoeLGaR3l3vzK8U
	YxTxVK3/vOHiqzLEyv0nKHifiEKY4p43gqoWYqENHcRBDQlQqW38/Z41KGYW1fT+WckvZPXVji4
	xFlNgp9WybchzFsWgAkH7ommuRj3PQpu9pzCAxpXBf+jtP6ShD7C2BBY5zGfdsvQorixSE+jiFd
	8sm96udgpnw3OJVKICs37F6X5zyz3qBEFTbHQvQasY9F
X-Received: by 2002:a17:90b:3c8e:b0:38e:69ae:7148 with SMTP id
 98e67ed59e1d1-38f2960cb21mr8640703a91.24.1785174079933; Mon, 27 Jul 2026
 10:41:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-2-dmatlack@google.com> <20260723222106.GA867236@bhelgaas>
In-Reply-To: <20260723222106.GA867236@bhelgaas>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Jul 2026 10:40:52 -0700
X-Gm-Features: AUfX_myC2ShwJmehW74tz8H5rliP_ZZpqbkoGqNrvu-bKZjNzGADgRSnjM8EYT8
Message-ID: <CALzav=cRhFW+zNX6xCnhjJXXDHgyhOxuoX26FG2Ve8+wMccypg@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] PCI: liveupdate: Set up FLB handler for the PCI core
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
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
X-Stat-Signature: i5hxryboxafwefkhq6915w8xr7s1tj98
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B6F28100002
X-HE-Tag: 1785174081-606248
X-HE-Meta: U2FsdGVkX1/jEBiRxGQOk2Pbda7wXy0+S7Nbz2Ly130b6ZSTYo+dz+DU1FaGN15zdFlpFEwMNR90fbEIm94Yd/tMzC/aC1kmI6MnDIifnc7nWYK6FqexbnjkDHeWRxOtN6nUDsQsHFkmngQhE2RxFQXTlI9PozkmWz+xRaJ/GSdcEGt4hI53abJ2PIP01ZJe+1aOURLZzmqjt/qiXJhgQK02EOhVgtPArdsk2RRsRwvaahMavBhi+LBIF9pxRvpvtc+SeeZx6xB9iZvBnCnsrRvmYzt6CGPMyzS/CGPjYK5UNRouDlnIkEeNesQTL+JQGGpiO83IQw5tfTuOoF2wMngY8r0bcVrrFAWYLC0wfjfShKGy+X7x4s/lD5p7yszxKR6AHrnMLmAMJgHNB+4dtF9iFidjysBVFgiIW1yhZwBzZsh/7Hpmt7YjnrBwKO0lNJXlyQDLICtk1WDpHyFupGM1V2qLXUbcYKqPahc48sWXIK16GfIEHRvaD4bdr0bHMsNd4Th2MzZLAUys2KAyfTv1uJVJ3pI4IQlx/vKlLz6laqI8TI/UzkLNA4+3qhZthzh71EvbdLFpxcbQsEgPTTYY/rQPOF03jwNunz0/xBhMbEnvfydq6jJNMO/FwvrLwqXlGRfMjAmGLAfURqThG66mtKNBVRDMLRP5e6zGbCqvqRqz6mHzrm86J47asN1vdjW1c6kHBkli9yzUhglvxEY4XHxS1XHq/+vI/oU02OuskNMGRgIJg0zI/+9eRMjVifw1uoMnkG6C97e+dMMAAwbK930U4OT8tvDT6momwYK5E8QoHaxztJ2V88Ro5FjxC41aa1HvTjz8Dc0rkAYpTOXh+FdFJdZY4Pkcha50TMb9rPmkrcNbLCrbmgVQENFYpjmN/mjCXZ+Wi5kfKinM1OEQDablWhQsEuFMhmbIKiWMLZlfZxkNS5riIFwfLWf3UQCYEUoewyjRQN7xJRC
 eVCJMFOM
 o05TtMa7YoFLGgXOQCtQnmebcvGz3fKvlu+GrCeXUbpQrq4ugy3V3xWvr+ylk/UsLv1KYQPjw66McAVnxv6OLhBBy74ajoz98XUQz/RS4u44IqiBq1ggOsf1u0uB823tDaC5W12F1181macOjoxGichuWB4Uavgckn2PZsuMqTczhO62Ju3YTc+GkPsrcJT/nNwiyj+QIuHAm+bC8a/QU+QMYeiqWeIYnuZIOEq9EN4XeoC9Y5xhfHexMtO2GbFRYDu7Wuz9LNzVXfZw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 3:21=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> On Fri, Jul 10, 2026 at 09:26:04PM +0000, David Matlack wrote:
> > Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
> > it to participate in the preservation of PCI devices across Live Update=
.
> > Essentially, this commit enables the PCI core to allocate a struct
> > (struct pci_ser) and preserve it across a Live Update whenever at least
> > one device is preserved.
> > ...
>
> > +#define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
>
> Is KBUILD_BASENAME buying us something important here?  Just from
> code-reading perspective, it's more work because without some digging
> I don't know what it will end up looking like in a dmesg log.
>
> > +static void pci_flb_unpreserve(struct liveupdate_flb_op_args *args)
> > +{
> > +     struct pci_flb_outgoing *outgoing =3D args->obj;
> > +
> > +     WARN_ON(outgoing->ser->nr_devices);
> > +     kho_block_set_destroy(&outgoing->block_set);
> > +     kho_unpreserve_free(outgoing->ser);
> > +     kfree(outgoing);
> > +     pr_debug("Unpreserved struct pci_ser\n");
>
> If this pr_debug() is useful, maybe it should include an address and
> there should be a corresponding pr_debug() on the preserve side so we
> could find things in a crashdump?
>
> > +int pci_liveupdate_register_flb(struct liveupdate_file_handler *fh)
> > +{
> > +     pr_debug("Registering file handler \"%s\"\n", fh->compatible);
>
> Is fh->compatible enough to identify a driver?

Not necessarily. VFIO could theoretically have one file handler that
handles all the vfio-pci variant drivers. But I suspect we'll end up
with 1 fh per driver in practice.

Are you thinking about how we can ensure devices are bound to
compatible drivers after Live Update?

BTW, thank you for feedback on the rest of the series. I am addressing
all your comments in v8.

