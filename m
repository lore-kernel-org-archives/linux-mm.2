Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02030F54AD7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 16:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4230F6B0088; Tue, 24 Mar 2026 12:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D38A6B0089; Tue, 24 Mar 2026 12:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2536B008A; Tue, 24 Mar 2026 12:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 18A226B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:33:45 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6CEBC183D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:33:44 +0000 (UTC)
X-FDA: 84581502768.25.13F6FC6
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id C92684000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:33:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DxEE3Ok2;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774370022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f++PU3wwkpbB0N6cii11zfED2xylkHlgqhKc/U2ncVo=;
	b=xW8/E1Y+pARqrOELEteGYho0Xz1mQddcte42hVT9aUv7isxZ09ubNbp9O7ToH0C+u4aeKV
	qTrEnbTimAb1Kgif5rwMPXn6UB8JzQ3pUJzU8JH5C4Zurd68zyoV2pSDIJHJe35r96hMbd
	BUW/D4HRCIWhFEcNMgE0xIIV2sbsYhw=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DxEE3Ok2;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774370022; a=rsa-sha256;
	cv=pass;
	b=lmOXE5mn1jaWFcMYh8NPeVQ5OQbtRiGFELlo1mSAS34c8Anz9zBnW0ydxlyLaD+we5x16s
	oSkKO70jJWSWTpYnPo5oY0IxbLYB/j1Srg9egk5CjWMSuEbHRWcoLKeNoU8r4eh0VvxXf3
	qZLbdHD2bio7L03TrSUWZJAaKI8pHLc=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5a126c8aab9so4759661e87.0
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:33:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774370021; cv=none;
        d=google.com; s=arc-20240605;
        b=gqJUF6Locue2Ksl8S6GoVeMjCJKAbi08JijA+ZlHCfKWdV9tine+e9+laVboBn9+mp
         3ay9a+Bpl4JJ+VqWdZPeOf1jJRWI5JE2k5eQth7LwvHVp+/ZIEJYrC4g4mxlZJpnbBye
         8KPSuN2rfXlPoCRO1xQWSLzAL/ys295q5ORArvyr+cFc6Alb91tev812JnRDKFDbqbas
         OLLsVHLP3FLaQ++MEzBOhwRoMdCzz6Vv/SyISAqekna/zfnpdLBtCVDkJu4Vs458seQv
         QDQrUndNmRz3V288P6PlBBOTNQza/T4uFPwtJ8hMF85udwia1Cr5s9SA06BaaYtPxPKG
         vjRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f++PU3wwkpbB0N6cii11zfED2xylkHlgqhKc/U2ncVo=;
        fh=Msf6RIJy41whJ0tKY3SDQgI3JZ6ZS1ZNsf1tuo0gNkY=;
        b=Lz3YULMlaw8XcRWFT6TGpCL6vGWcWggMLYbyEqgTdWmAFF3lqO/vVVsasjQKHlQHKj
         aTdnF6h5FfvqgRCxlv2TjUwnsvBYZXNQVNurqTvYoIW4SONHD3ZaKZH7sbFS3VIEuDzb
         ooHSXZELKM8FYoy5RsYvPGMRKrpyowjYH7Z1qXemvool/U7jW1ca0lfcJJP8BED35AX9
         kccvBpoHDdVgSM2VF0kFI03CPVW8x4/733R5E4QsQwgcGNA0w2cERsWZp9Cy333xlJ66
         pvPlBlHiaPxghvhGdIvLFXHevsvxLYcgnwZrsmm3UKhDEYLr6phm/LjJN/ulY4Nowwv/
         L/fA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774370021; x=1774974821; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f++PU3wwkpbB0N6cii11zfED2xylkHlgqhKc/U2ncVo=;
        b=DxEE3Ok2+XdhmCU6QponvkEABYo55xTd8baBnghWBzhxz1SxZVeeON48wK+ZhYPA8/
         55+fkqExoXOEme1nBoDbxRybHmOy+35VD7WBvXPbSzRY4ORx5uBs00CVhbxDk5aFwskw
         jZUS7S6m6xiKX5Cr/dLgay0FFauKLuZc8U71boyJjVJPw0v7yEp1RVTOSvm+DZcOGmJT
         rQnuttpTU1CjpS7n6DWB9F7fTaTSZ7eaKlVwjOASGUIMYaLxCSwC5nitW5ndXI9JZgMM
         lNzmx+u1dCSmvMn2b43q9s96vTisWzbtZ54XQDKCL38z8iTMlWe7QIN4HHjKFdt7h1Jy
         QJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774370021; x=1774974821;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f++PU3wwkpbB0N6cii11zfED2xylkHlgqhKc/U2ncVo=;
        b=K6sXYJcpPyP/BcnGWD3ea562h7BfP7rIQcfRX41ejlKVe52QCQu+UAA05dosCYI+vU
         2zBN0Kawa5wG1MYp0rm6/xSESnNlQtbs5AuA0EMm1y+PN5jWH8Fvf3V503+coz3kxN6u
         +hKD3wcJJmtEzsoUGb6lzLUrSdRA/szvGvhFJnt5TcTWN7h/Dik3oKSlRbqq3W8hJvV0
         mNqibCwU6cyOYd/sZstGP1VhfSuKDcvd/PVQMpC/I0lA4YM2ohqeHcAnsy+arzUbOIsz
         l4P3vF6Ey2o08K0turHPrLWGEs2tu05wi3Z3bn++XPmIlcyOGERiVIdDTYEU0YgCnVdW
         Lg9A==
X-Forwarded-Encrypted: i=1; AJvYcCVtflAaOQN7UXh6m2EmdFgWjYNfjdNzVw1bJ3WwDC1YgCkAEtQOLzf+oqXjRpvj0ICPx29o5VPWkQ==@kvack.org
X-Gm-Message-State: AOJu0Yybnl0pSedgGEeg2GWobLFsOrUe06/0xFvg1xxy00DXWgl1IJ/H
	wMA5Mq05GIIL0/bwWObRDZMKOHDn+6+DfAr93edq/jiwq2dD0xbNCDh8pBaKwz8GLDxi7mXjdUq
	pRrpAcn+WKtFbZGqzUTtIUGBXU3UVPYpiq889YTTj
X-Gm-Gg: ATEYQzz1RR33L5PKYfqI7xL2w8riwgT9AIEFQRNr5A5/pfwRMEv0WFBCp0j1TaXyu1+
	SFzCMmHXp0Z2AJ1PyKAmilVuZ0g4LbbaVgUdsRIiwwoDDMLFfyfpNfamXBoUVUpzAz1DviI/EDP
	e2iF3mKu2WBBnfJD30+JTD9nrI5tHNzyCKHwaK4bnYaTUH/hAy6KFvSrx/jPFH11WfojhK56dWT
	SPD8BPtCSzI/NPHxzKg78Qgy1ZUxme8mBElD3Yjm4eHShUCYXfTLGuEFpgzo/TvlPn+xipZ/6xl
	O3QKTvRk
X-Received: by 2002:a05:6512:3044:b0:5a1:1899:a0cb with SMTP id
 2adb3069b0e04-5a29b9a1efbmr55664e87.34.1774370018671; Tue, 24 Mar 2026
 09:33:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com> <20260323235817.1960573-7-dmatlack@google.com>
 <0d2eedec-01c1-41c9-bc74-0133ae6ebb04@intel.com>
In-Reply-To: <0d2eedec-01c1-41c9-bc74-0133ae6ebb04@intel.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Mar 2026 09:33:10 -0700
X-Gm-Features: AaiRm530aoKtDDdSXYb9CaNnVHDZa0HeKfsko4zWVykFU0w66CUzojlEOk9szPI
Message-ID: <CALzav=d65Z1Va14rmoRcx5WrK1GfRvuHmrqK16wJJeTiq28eCA@mail.gmail.com>
Subject: Re: [PATCH v3 06/24] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: Yi Liu <yi.l.liu@intel.com>
Cc: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@linux.alibaba.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Li RongQing <lirongqing@baidu.com>, 
	Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: C92684000E
X-Stat-Signature: cwmjme7t45hej7i7q49oe9ecjj78cr14
X-Rspamd-Server: rspam06
X-HE-Tag: 1774370022-22298
X-HE-Meta: U2FsdGVkX1852vSiHNy/869oRduNEUgJOQ4RsvhvzOivON/w3mKVHdrTL0FMZZ2vKCzk/K7PXSw0QIXaiemOVtCo6xWfZBUgzHG7aOctgkk2333kmnvQe/cu8NBZ/aNAumH43pUTJMwkoKUfr9asOIK+amby2r9PaDsLp4zAkroFgUFjDFpoqTzwWl9J5Cpnekz565EN2k7kNLTTSTt5wcd0EnWmRSQQOtG0nV9kbiuiLohD+Sbm0J8qCR12T8GhAro9SWS/jDVLfHsBnOd+xh8Nr1gIu4Qp+gvsbp+7Od8mYpVCNSvYoRyUOa0b+gRh8iwPW0V6ZeVAftOBTqFFA6PEydy3B8z8mnEV9TyM4FEBlQVcZ79islInGYGKRgGdwmiD8HrYOrpT0WhwF289sefnHu6rO1G2RTi9ZWxw/0IFI0R+aJrlOSTmjyko9LcY8rTg3JxCQ8VAgSGKTc0yAHbjKmqj4EF7ZRSbzZ/+50qlh+s0bWB/y+P55GUtfDNxXH7SEkjHLWI6XaD/r4Vja756M/Urh4G584qvy1yIBuP03Pc65FxI55IA9KN1OxfzGVx8XESDoXqv/DmJMfPsqb9TyFTnXcyLlT5hXkvZUo7HsKjfjcXerKzQgyWLjQlpblHwn/NE0TFcHW1iNPdhuN13nF0NNRygjkdcqvXkIN/i+zwdJh5NqULOiUzs+7Q2M5cx+Wq3nYsoZmxh9NWklY3Fyph71ajPknf3pD9JTeudmLctlIqehCpryc24smvVXrCn9f7sqBiYOzNi6/jHoNJhQtcooNDW02HMExyjL27C8DwqIzuhXeO5qUH/F+rxjbEEOA8J2mMyBOqbrUBPeMEAj6WptBJTl2WCRHakuTWTwAHKkc3yJo/RFV+p4PihjXiRayUsjk7N7JpZFShuvmZFn+ri7iyKH3xoz2PJ6oxdAZb1lucJ4xf4wOUaoltJf6LHU3sR1xk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 6:00=E2=80=AFAM Yi Liu <yi.l.liu@intel.com> wrote:
> On 3/24/26 07:57, David Matlack wrote:

> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -170,6 +170,7 @@ static int vfio_pci_probe(struct pci_dev *pdev, con=
st struct pci_device_id *id)
> >       ret =3D vfio_pci_core_register_device(vdev);
> >       if (ret)
> >               goto out_put_vdev;
> > +
>
> a meaningless line here.

Will fix in v4, thanks.

> > --- /dev/null
> > +++ b/include/linux/kho/abi/vfio_pci.h
> > @@ -0,0 +1,28 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +
> > +/*
> > + * Copyright (c) 2025, Google LLC.
>
> would be nice to update 2025 to 2026 now. :)

Oops, missed this one, thanks. Will fix in v4.

