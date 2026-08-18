Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99D5AC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:02:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 899DA6B018D; Tue, 18 Aug 2026 13:02:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84A476B018E; Tue, 18 Aug 2026 13:02:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761CD6B018F; Tue, 18 Aug 2026 13:02:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 496A16B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:02:34 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C048B80180
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:02:33 +0000 (UTC)
X-FDA: 85115008986.13.5C8E65C
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id ABB0E20018
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 17:02:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f20eCJui;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787072551;
	b=uIdgHi5QztrM9A9UYLOm1+Y/z2EwKIH+9wK3fFZVYfSedowTxX+NiqfQmlhHUNjIkcYO/O
	ndQvnjJChyEaIqmGYloBQG468E0XS5GUEQKoBZTtnmYN18req+vUoES4RfO6/fYORR3jpi
	6kgtgY93umdko+WKGDXpBci/wo1JvrI=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=f20eCJui;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787072551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjtdIb6WLQbnwc+hZbvzaCjPXgJQSb26VEMl+8tkzq0=;
	b=nglRhzRnnbSaJiSbWnvkLLXQkV6vRhEVIzYsFL+oafERSCnvZAUSTpVV3Df029hLu3MVSk
	KmOnvHtzYzV92WMh5bQmjd+ArCmVmIt2Y7rNaEaWakJji4C+ciAA0BVUT0JUcOFslYvBKP
	mJCpAYvEDudS/+w4X5s1tfm3RR1xEL4=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5b01cb18515so122599e87.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787072550; cv=none;
        d=google.com; s=arc-20260327;
        b=pLC51FMV5wNRgFXr7ExjCf0az04PtL6JZp05X6FtlZ0ItS7Wp81RrRVemGWR/N1bS0
         jCQtYkv4oIHYVGgks+fCGpf7nEYJlBjzGkjr95kicTPncfMa38pskNJWsSLVLqYPkUoc
         OvH6/ulRzL6klwOXIAbZeRrUIRGlbkhLdk4sCZoNt2hZVt/iNyXNjLItiHUmvXlsO6hR
         Q/4ORsJIRQJPNyQkNyC9q4BTFcQuIBzorn4exhKaFGxewWkj+KY/6uLCudhFUXsYH9K1
         vDC5vwyO4kFlFRGZc0oDdK5XoUIGjHsw1OWmBLr8oWOtFopyGUS6u4EuNPzvAohGvUqx
         y1MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gjtdIb6WLQbnwc+hZbvzaCjPXgJQSb26VEMl+8tkzq0=;
        fh=XpSjZ/Xv/nj8vmmX9axNNExEkosDl/NmvxFOf7ofuxk=;
        b=G1KCsxTIa2rxSRSoWlunNKwzexAjvTI8Xqt67zx0fFaWTXeL1kr8vdktB+1qvDlpqF
         lUBSTTO6eo2Ap/zDwPJbkiM/IlDbj+0xZ3gNDsD0SS8zbCTS1rbH5aptcZzeA/oihLSJ
         LNcS6rzs+pu55MoNcQxtL1+RrqEyNAX18iUcckxcB1pcihFvU3MdHgyJw9iU42T7adTw
         O7qJDV2P6j5JVfVQN7OA2IIUdhc0mNY6b9ukHGcr79C03aI1Rps+jrssQDSFszdq90SB
         3wpZ6Q2uniXHuf037ffxx4br1LCivREt3G8tkxcvETy1TYLpj5j548Wm67sH0yTL9Pmd
         aBHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787072550; x=1787677350; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gjtdIb6WLQbnwc+hZbvzaCjPXgJQSb26VEMl+8tkzq0=;
        b=f20eCJuiVZc3nyRukIRWbBtZ2EPKlDiahTrKFTWNPDIC9mmiMbO5f4FDjzv5GO3bs4
         g8Fe5Bbhg/EOZtfciR3kNNsiJlz5kcoHpPEP7jSxxGt2x6UHQgPI/sAxxVEmiVl2UOnU
         gXtP64M21sfrCIgs8t28wQIzX9jRPveD0nY4lQSiMD1ELMwE57cXk/TcbObpxcNQe3nK
         Twb6/szH69c9evjqJ8I/eoW6ezhLPuAreMHgwceL/tUr2lVUE+uOe65mk4OeTrnmSneR
         XbtnglPooUX0zLzS3Ezxm7SCOeJyt7Gy08szzTF7g76O/mze+bUd589xWHEaLPYXICtL
         30/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787072550; x=1787677350;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gjtdIb6WLQbnwc+hZbvzaCjPXgJQSb26VEMl+8tkzq0=;
        b=Dg/4Ti+81Yh6mX4uTQdafgP8m5/y3R81QC0Te7Z2vFYXgVI+4oCyd2LmmGLR/sbjpB
         BDkxsaKszd+7F8Dfd2N5dndnmG+QC1+Q8Z0EcTpZU4ixudKCFku1eW6OJgJ3wJVU6/HY
         jierAQT/3tkB7YL+K1Z/NL1Bz7yLcr9khjp/RAcr74sIsrBw63EZQwa7IDdlY4KwdoAi
         EhTu2EapH99FkKj2o8394yR9F6ukv2PRO21HIVLkKkrCIcxrZgXOPkfJqB/58B3VN3du
         SLl7+avQPbSgrblyKDwsDXRTuhsHODvP0/IhoJL0PHjXvt1+yh6quj+C4FW5uKelXR7/
         G/Sw==
X-Forwarded-Encrypted: i=1; AHgh+RqCDoNBJ4Pu7/1s9s8G4k3Y511gjtUpCzxmuUMWm3/33aL8qLr11JpafNGl4uU4hcFdmvhYoaJTWg==@kvack.org
X-Gm-Message-State: AOJu0Yw5FOWcsT/Mlus68pKuXGdDVj//aDM8qQyKL3GC5cnHFJ7Kd17c
	PsWhMrwGJqKtkRtG76CpSfjLgqQ8KwRCVZfatHUSlU1p9W7JXQSbZDDob/CVhjjcZICChfot1hO
	4NDKLKMDaHe7UWxtO9VWBVN3/mB5SqZGzmGW2Rr6+
X-Gm-Gg: AR+sD11MWBosx90zyP/jQuQaMyrqtNWl9zC86s3UkZ9hLh1FU/TPj6P6L4EZhBk26yv
	VEfqJTYP/Bp4RnUzTflZiS9H8kxeXfS338jAabq/cc5lIHyvpZp/B3VpmTDlNZi5SyhhJ2K6BgZ
	Q1RBGfV3ZozJLOHwIvOAXgh79v1zKy7xrflQL4JI5cP4qA7n3ruSj1RlkGd4/7Gc2y2eaBugRRt
	vXDMb/fMTQhzWLqUSZcfAfD0PKBtD55uca0+W/33x+/teCBNf+ftR4r9UfT1BE0M+rNHUEIm8o8
	D5RP8yqXfjQPimNQbjomDRCMHUkgNbmoewqDccCkNOB6
X-Received: by 2002:a05:6512:6686:20b0:5b4:3ddd:8996 with SMTP id
 2adb3069b0e04-5b470676e75mr1757831e87.15.1787072549336; Tue, 18 Aug 2026
 10:02:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 18 Aug 2026 10:01:58 -0700
X-Gm-Features: AcwNN1V4a25Yv0iJ76SrkHBknW5LsS7U4x19BfrVjGgcR0yRKfOyORXyqOEjm-s
Message-ID: <CALzav=ezKW25+1h=xQCRx0TQDtpADKpXQcKfz-3vbapz5-zwvQ@mail.gmail.com>
Subject: Re: [PATCH v8 00/12] PCI: liveupdate: PCI core support for Live Update
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
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
X-Rspamd-Queue-Id: ABB0E20018
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: y8aja3wun3ihooq3ncrjotyd9uxcc8ak
X-HE-Tag: 1787072551-190283
X-HE-Meta: U2FsdGVkX1/4aLgSfeINGphZX8yeUuum7T4fcJL6sa3ho+bNudCynXJbYQ7e1bpADs9gcj5dRO6LRwsDThH2BdKVl0chPYotL63FkqQ3v0OiLrXLxxNTqpGl3dDnXkAtQFLaLxk516nW1JzcTfUCfBvmooJQb7IodwXJhglky7uSainhX+10y61ZQCAkMXFY1f2/DLpGI4PUHAMoitwW8bgZLAQfLopeyPBvQp84cZhuKuuVYomzh+Ha2aAEskJ8YLef4QU5MjbZLaT7MbRsiVtXjwTIggOX3JnFhf4Kr1bEwKgXlgIfZbGL45Vkft2W0k3m6+xojpDmxOxntNAMzDHQWRfPWx9uFSgYTQuY0aTBS2TbGzq0IXhRfuM4UirI+mR7eMw/S1CcEfXWTGYlkteh5PBb8eu3WLLlsuClhdJq8z/fwaqZIkp1yjv4s4vFsR+uuasKY1e5OfvEp3pKv6dZrkL1TyK9/tMn4W6Now/Bknq8ei1UoNMtY7Wc1wECNQblNCLhE9CpzXBRJ8haZEKmBaDEO/kIMGP7OYrDGFoO4dVCTnLOUSLerJcLSpXE60nR+CcJ7Tsp1lvYxyZ6VxnKc+t+fHx5oKrytf1h4XlbxinSZOoEb47uslnXH/PVhUid74LDzcYBIWdDwuzYWhB4iMJ7gNw9LtFfDERP5oVEHfmqM9zX5Bg01W+RvBxNcns4VWTNiyj5albYHzRFB9lR40yrNBdo0KmYgw4aYureb4Qmn+zxGGhK3834CHsqhCHdeEG7xxcQWHMpQAKuFzvnXa4OWZVdzIDfr6E1EuH11Pw6iAW/OVVxtELmuG8p0wpYitQVeD4txtH3BfOCdy++x0NeuIhqOhV6QrDhn/7vFeewhkAdLN9xvF/p9ps0zklp4VnBSsuGLkItI11vVOmGAVeGewoDf7fk2I+Oqp1U6wRWaUCbvM9ATUFtlgJPpKdXPqurvQyZ2ERSG9+
 i3EUebFb
 iUu9K2DVpzHdmGI5rOSxqX5Xwl4Bzq6U68H7HFYT8a+DFitp9BCf7kBPEjDnMjECBdJxUV3ILYqNueS4qn64egkpvsWJCxI6uQsamkj25n3G2Uyj5PUycaDS+0jeekQrZikxwZNeP7IgQIvWo2aOGqe9xVzlr0cunbUS+7cBp5h3XrZf0JKexzDQB+5SKgEg4nKcRDZ98OU7297Cy5tcK2KJRx16Wff7rs/PRA69clZ5YKR3Pd5WgANvEp6F83GW29KOHOe/61P1kqtA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 3:10=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
...
> Merge Plan
> ----------
>
> I propose we merge this series through liveupdate.git for 2 reasons:
>
>  1. There are some LUO core changes around how FLBs are refcounted in
>     the next branch of liveupdate.git that this series depends on.
>
>  2. We had previously agreed that the files covered by the PCI LIVE
>     UPDATE maintainer entry would be merged through the liveupdate.git
>     tree (which is the majority of this series), so this would be
>     following that process.
>
> This plan still needs to be Acked by Bjorn Helgaas as there are some PCI
> core changes in this series.
...
> David Matlack (12):
>   PCI: liveupdate: Set up FLB handler for the PCI core
>   PCI: liveupdate: Track outgoing preserved PCI devices
>   PCI: liveupdate: Track incoming preserved PCI devices
>   PCI: liveupdate: Document driver binding responsibilities
>   PCI: liveupdate: Preserve bus numbers during Live Update
>   PCI: liveupdate: Auto-preserve upstream bridges across Live Update
>   PCI: Refactor matching logic for pci_dev_acs_ops
>   PCI: liveupdate: Adopt ACS controls in incoming preserved devices
>   PCI: liveupdate: Adopt ARI Forwarding Enable on preserved bridges
>   PCI: liveupdate: Freeze preservation status during shutdown
>   PCI: liveupdate: Do not disable bus mastering on preserved devices
>     during kexec
>   Documentation: PCI: Add documentation for Live Update

Hi Bjorn,

Pasha and I discussed this series and are hoping to merge it into the
liveupdate tree by the first week of September so that it has enough
time to soak in linux-next before 7.4. I was wondering if you think
that is a reasonable plan and if you have any lingering concerns.

Thanks,
--David

