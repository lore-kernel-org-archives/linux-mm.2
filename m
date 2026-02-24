Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B2EF4BB65
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:34:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47B56B0088; Tue, 24 Feb 2026 12:34:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF61B6B0089; Tue, 24 Feb 2026 12:34:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7AF6B008A; Tue, 24 Feb 2026 12:34:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7DA56B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:34:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 60F241B636F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:34:01 +0000 (UTC)
X-FDA: 84480048282.25.C7C9B61
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6C629180003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:33:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t45ctbqt;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771954439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
	b=ZMVwLo73rxtjCwvyueQkeUEqXRKMpLiAxBZ2PwnwIxwBhis1xT0/jLqmO3cilyGSrncykI
	tyWyJwEQLfvUDFuvRwg/qGT0v2i3yytvhwuIyCXFbaJJ35k0ncAJ4hzcm7Voo1vniPUiV0
	DicdEmwS1XcqT0TtJrxZl54lNtP6XS0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=t45ctbqt;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771954439; a=rsa-sha256;
	cv=pass;
	b=M8t7jqLvbXq4wsZnZkZ5RUDrLFDdSrEyGJjenDLhwlPZD+l8ydfVFpc6Qwk8SmV3Quj8kj
	66R154bK4d7sXKCoSxyiVg6nx9PKbFHyZ6Q5GeHFT+NJGXwWRDIDYrGUEfgwZWr5Jz2qsD
	FrUoMCI35Mgp9tB8MW4y4/550Uj5OkU=
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-5fe0959ae3dso23380137.1
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:33:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771954438; cv=none;
        d=google.com; s=arc-20240605;
        b=BIeyHcydbr/HReaTx8y5te90q3BNhaV3ufAvfPlJtAxEiFTvQkTlPUrggJIS7ftqvP
         gtgy54B18s3Xil5AUTRiA5dsIP2FNgomufn/cZ1K3c25WJbiLaUuiM8blLlnCUzv5CNx
         z6nyZMTWRF/HeKR6OH9F5of2PMuuOGaNO08clynaej7lnMS+H0giDulwzVRbtG0Jah3i
         aTBIzvJ+ZZqvs7HrF7PaCjPY5jiHepwqjIKvsplyrDPhtFY+3w4d5RXUIZMe+1NqrAEZ
         pcSDsT0KwBwyczYC8nDV0mFJwLGHKrUMUDgZRBn6WA9t6/qnq1WWuXPrDqikLb0fd/L7
         f2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
        fh=MVO0uIuaWwSnGXtQ2ByH/o/Ewpt/r/F1pqi85VcpPXY=;
        b=X/4ejR+Cv8eSqcw0mjnR4x5Ka495RyXQF0PZykH2NSwztFlHN+aAkytzYfLP2QBO7X
         sPjV3pgzY//CkkcGSxSXguGN2Mw8xNVVO4WHDXW63iD8KPYN1hgdL2lyERgCwxiL7pqt
         v3xtbAsvlTvRyRMRqW9k20feP+WmcjYIm2Hyle01wq3MsfuyY+4n0tf4/snLWW40PgkI
         TmQ34T1aZZAzRPQf1LClQf8eZNfcskCDtUOoEE0SFmyNt34eYufu82uaQanS1FdT768T
         SU/2j1z8+HeWvs0PzXQHWC2aNyluVCMwoKesychBh3vLpIF0POQ9kbklUpDDkVcJpkZ1
         D1hA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771954438; x=1772559238; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
        b=t45ctbqtQGbHSKt/yd5Su+B8oAIl6pqHvU592b5t+YOK0XSUuQpXEa1NC+o/+oWoPO
         H93MYWIhQSNXUjye0UOUsMi9lFmClYDnL+5jm4dIb1oWc5FPE1SMXF7y+SiJw0HK0J/7
         kI/DAm3mii658jAgR9aB954iOM+2Ovy0HWUuG5JvSg2T3qpPGIrKWaEq/z7Yk6TJs+oh
         WtRwIbucfymOu/IYDN4owVIHp8dJVzZv4yUeWEdXkGW6Xfld2IWd+LOfuVvQY2JIMn3d
         uLGINhaHJn7UQY0RpzEOFV9CFvQTJac4bDcU7p5B+29o/Dxv005Lz521QUz60mVI3yL5
         rJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771954438; x=1772559238;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ifttwnYsIrEN6pRSBIiuqj7H8s+5kPdjKC4U9v3r5Ew=;
        b=CEzW1B73cx5XJjOdDfT+udvNxiwXE/gHVZI3kWbEPtsCcPEwazV8Dd3aLrI9LPuOQy
         +JMghUg0XpQ/a9DIFV+ev+5lqYyUKS1eMQ1miyM1M7xa6qVk1ts7XscFN0c3OS5skzik
         yuYnLt9FiUenlcr8pEt9CRwrAuK1qnBqUUrYNe9D3vrS6zyezszpWsT50sUGNjCc2B37
         VYnMu9lHJIqgU9QCCrt8+RiGASh2X6q0EALjedE2ewxMWu/h7GyslnS0qOKmFhTrc9AA
         G4HX3sTg9CdRmSD2x+O3U6yiCQdpDXR5uLuvexpl9iseuV0VgTG+tNN0sNO4+AbTt2KU
         RZaw==
X-Forwarded-Encrypted: i=1; AJvYcCW71HFW2JlADYngzQdEipMWjt32CTzbeZbkAErmTLsbKHXKhtuC+tic2R/4gnAM1hkOpKf+UGmMpw==@kvack.org
X-Gm-Message-State: AOJu0YxI/soULKBXol/VFK38ARs6z8fb/gVUqzP2EkXIWXDpNFs+jwIH
	iGKSOmxZhVw3bYNO5NNTLmZ1x+Bw6GHotxjhx1iylPaWYKhTJqciGZJGHzAPZJZTkUs0W7PCY3e
	RWhW7p9PWOv2M5I5mANL7tIGdMnJwD1eu57CN2eNw
X-Gm-Gg: ATEYQzxckcuq2VdXYdSKoX4jxcsBIT1E+vqgjJdNnQO/5OK+Sds4OLbaA26QJQsAOr2
	S1IVIbXwNC0YrSZEGU0Il0AMsXekrkAgCoGCVlc7E9xmQikGwlW+XOu2wMbHonKQpVQ1/D0gg4w
	emO7qE8M0wV3/MRdFf7eXsgMRZbOl5vn7DV1gZ2Y3PndMLZKpyXRqrJiUaOzqLl909bA0AwIdlW
	GLPwN/x+jEdLO1/dx3Qn/aEAWCx9dDsfY1byK56k2ntu8GQGqBwiS8rX4YNbnWmpQc0FJJ5FD9Z
	LLEjkb0=
X-Received: by 2002:a05:6102:e0a:b0:5ef:b32c:dff8 with SMTP id
 ada2fe7eead31-5feffd8e046mr571923137.5.1771954437826; Tue, 24 Feb 2026
 09:33:57 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <aZ1svGur9IxQ7Td2@google.com>
In-Reply-To: <aZ1svGur9IxQ7Td2@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 24 Feb 2026 09:33:28 -0800
X-Gm-Features: AaiRm50ftzuk34ivxDcB4SNiM7gs91UDwPlTbTMB1CMe8djixeonPg3t_5VqAYg
Message-ID: <CALzav=fSpd6H5pQNtJoFHdNtWVO11vffhWQFsMFkM+osGuE0wQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
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
X-Rspamd-Queue-Id: 6C629180003
X-Rspamd-Server: rspam02
X-Stat-Signature: zotjcfax474xwtgkyfida4ed3ae9cq6h
X-HE-Tag: 1771954439-235859
X-HE-Meta: U2FsdGVkX1/RuDnCTlI3dXfrM1c795TgilnTb+ptW2vSKZcpBD7TGA6xvsrRRMLpR3IxVZ9X2oEOjmvNBTryuIfef+ZQPWbw37kYRdFLRqDz7uumNMXpt3bSR+uF8/sRJ6Tv7Ra1DTmGZSe8wd8rHudScBDNGk7ySk39DiHuBNqFKUPZVbBYzZP9Pys/AOApp5E4RuycsMXyaJZaq+XK1lu8o8SRy36alyHvJ0NKB7rA+ctwAey9noU7MiF5ZJ+AUaXmJN58XHL7pr8NNwVioewNDpNbZbdyuIUMw/PwgutEeCfjtsd1TzrMZkdEG5vYgKFXSHpKTfWVnB2l1DZZRsm+BypQzjciN73+vmJbmpTByiUYSQQYOiQGUbMiFI7oAHMLEJ7vx8SE5tjrkhf/xmNAFFOsNNe+KY1VM5EKHr1mea0mBVZE81runmuBicNzjeDJ5YXxWPMvl9eFtp5BBWWwRPiPGmLy/adWSmdbm1LR+xDBQKmRmJclwNn1r06eqmlG5ATinK/GDJFM3FESTzAXdR3IUA5Dz2stQEP7W6xm4KetUwuJeK5EJXr7srvJaDcRQt8tLN7nYbJ4ZFXQZl94ebdpRPA0gy842h/HvBvpjnApv0sLYptTMSnKSPQMkULmXM1IY05OBqhTZYRCDBIfTQ4+vcbw9FyA38I6VKEpTTOhn6Z/UeX7lDz/wAQbCF6p5q/W1xG7tN8qgcpYl5alwKuif2wsXr1yiD5jLJMEqjfAPdQlYv3BqtwOJXy9ISMWvx/te0bcdW1+tAC7vcePaSYqnGk6BZO6X7WN1h5JYHZ7U0vl7WmbPUoG/5m827heQZTAGjI40MJcKRn3QheMWAcpjhJmI1s3F231ojusCYyOstUzc1XV9rQdqM/dNgZ0ELJwRpwGNJNFkqeNdVYPZScjfW+HXS0ZXOgha9K7w/q8M59BzL6/LDoDgr1NVR7g6Wi20jNzpg+P6P5
 1DIQZABo
 I536nlH+6gPChOcxWMfpLsPoNhOPvnnPFsrGuRFdgdol+5OGlNw6B+75khmMGQJci2jAuts5cNcFT+EuTKhhwzQDdeCTzDAjR/wyxt7RiHNJZ2KJqmmF9vN5a60YK/a2NVimog2SRliMN//yrjNl+MUqt2iTR7thh+0IzWGFXisu9jUL1ou/PNqVwXipTyjdyvPPskAcCD1IBtVSUGE1CxfPELINCCqcn7ffrHeT54d4+jGJ9SLKxnd5B5/Vqll6tcnLFline3bEaPhA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 1:18=E2=80=AFAM Pranjal Shrivastava <praan@google.c=
om> wrote:
> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> > + * Copyright (c) 2025, Google LLC.
>
> Nit: Should these be 2026 now?

Yes! Thanks for catching that.

> > +int pci_liveupdate_outgoing_preserve(struct pci_dev *dev)
> > +{
> > +     struct pci_dev_ser new =3D INIT_PCI_DEV_SER(dev);
> > +     struct pci_ser *ser;
> > +     int i, ret;
> > +
> > +     /* Preserving VFs is not supported yet. */
> > +     if (dev->is_virtfn)
> > +             return -EINVAL;
> > +
> > +     guard(mutex)(&pci_flb_outgoing_lock);
> > +
> > +     if (dev->liveupdate_outgoing)
> > +             return -EBUSY;
> > +
> > +     ret =3D liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (ser->nr_devices =3D=3D ser->max_nr_devices)
> > +             return -E2BIG;
>
> I'm wondering how (or if) this handles hot-plugged devices?
> max_nr_devices is calculated based on for_each_pci_dev at the time of
> the first preservation.. what happens if a device is hotplugged after
> the first device is preserved but before the second one is, does
> max_nr_devices become stale? Since ser->max_nr_devices will not reflect
> the actual possible device count, potentially leading to an unnecessary
> -E2BIG failure?

Yes, it's possible to run out space to preserve devices if devices are
hot-plugged and then preserved. But I think it's better to defer
handling such a use-case exists (unless you see an obvious simple
solution). So far I am not seeing preserving hot-plugged devices
across Live Update as a high priority use-case to support.

> > +u32 pci_liveupdate_incoming_nr_devices(void)
> > +{
> > +     struct pci_ser *ser;
> > +     int ret;
> > +
> > +     ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return 0;
>
> Masking this error looks troubled, in the following patch, I see that
> the retval 0 is treated as a fresh boot, but the IOMMU mappings for that
> BDF might still be preserved? Which could lead to DMA aliasing issues,
> without a hint of what happened since we don't even log anything.

All fo the non-0 errors indicate there are 0 incoming devices at the
time of the call, so I think returning 0 is appropriate.

 - EOPNOTSUPP: Live Update is not enabled.
 - ENODATA: Live Update is finished (all incoming devices have been restore=
d).
 - ENOTENT: No PCI data was preserved across the Live Update.

None of these cover the case where an IOMMU mapping for BDF X is
preserved, but device X is not preserved. This is a case we should
handle in some way... but here is not that place.

>
> Maybe we could have something like the following:
>
> int pci_liveupdate_incoming_nr_devices(void)
> {
>         struct pci_ser *ser;
>         int ret;
>
>         ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&ser);
>         if (ret) {
>                 if (ret !=3D -ENOENT)
>                         pr_warn("PCI: Failed to retrieve preservation lis=
t: %d\n", ret);

This would cause this warning to get printed if Live Update was
disabled, or if no PCI devices were preserved. But both of those are
not error scenarios.

> > +void pci_liveupdate_setup_device(struct pci_dev *dev)
> > +{
> > +     struct pci_ser *ser;
> > +     int ret;
> > +
> > +     ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return;
>
> We should log something here either at info / debug level since the
> error isn't bubbled up and the luo_core doesn't scream about it either.

Any error from liveupdate_flb_get_incoming() simply means there are no
incoming devices. So I don't think there's any error to report in
dmesg.

> > +     dev->liveupdate_incoming =3D !!pci_ser_find(ser, dev);
>
> This feels a little hacky, shall we go for something like:
>
> dev->liveupdate_incoming =3D (pci_ser_find(ser, dev) !=3D NULL); ?

In my experience in the kernel (mostly from KVM), explicity comparison
to NULL is less preferred to treating a pointer as a boolean. But I'm
ok with following whatever is the locally preferred style for this
kind of check.

> > @@ -582,6 +583,10 @@ struct pci_dev {
> >       u8              tph_mode;       /* TPH mode */
> >       u8              tph_req_type;   /* TPH requester type */
> >  #endif
> > +#ifdef CONFIG_LIVEUPDATE
> > +     unsigned int    liveupdate_incoming:1;  /* Preserved by previous =
kernel */
> > +     unsigned int    liveupdate_outgoing:1;  /* Preserved for next ker=
nel */
> > +#endif
> >  };
>
> This would start another anon bitfield container, should we move this
> above within the existing bitfield? If we've run pahole and found this
> to be better, then this should be fine.

Yeah I simply appended these new fields to the very end of the struct.
If we care about optimizing the packing of struct pci_dev I can find a
better place to put it.

