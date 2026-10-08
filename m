Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87936CA600D
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 17:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8576B008A; Thu,  8 Oct 2026 13:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A8AD6B008C; Thu,  8 Oct 2026 13:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 297A46B0092; Thu,  8 Oct 2026 13:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA0C46B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 13:58:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71DD7A0358
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 17:58:34 +0000 (UTC)
X-FDA: 85300218948.24.F84A84E
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 76653140003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 17:58:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ekGQBH9e;
	spf=pass (imf23.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791482312;
	b=UpRvOU5tzP0VykzELNEc2COIv5tHCxM2n0MVAaBYkca87cZTVUSw0EBpj5BhobrgCefaXw
	aylfPRooMaL2OToZOpPmgJnZ1Xrz0vc+wJZ8ZvZKLpcUbK4XYIv3vlKAsaHQddfCQgAR5H
	eInBvN5Dcr+hs9M6OGbt1oU+mGeEW68=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ekGQBH9e;
	spf=pass (imf23.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791482312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t87G03YJP+Jtnvd/a8HSoKeiu6kRlnnSEIlqeg1Cd6Q=;
	b=7Qx6S3G3YoE11BCLixifNpyZK91JZqQbqth7wg71VgBPVD57anFl9RbH8E1QtN583CvzUH
	3Kqv5S9k/I43vZto7eslr/KTF948hi6//1J1YcRcT7SAq3X1cY6fSfxciqrIzk6NJkopQt
	7MmLd8lNDaZI4voUzzHTiHx1Vmckmdk=
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-8244537ab76so1683337a34.2
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 10:58:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791482311; cv=none;
        d=google.com; s=arc-20260327;
        b=LUxUmITjJREQ+egOFWOQS8Q4h1JlRn2cPPIQRnlVwSu0IWiJgHS40vVryULCQssyZ3
         nxZlzKOTSWGTRM8gfYljmHMNB9Q5J/Plx/SzQBYjZcSoVfAV9FSj+3Zvww5k8N95l6zr
         mCxY5rMadpnsnF/6q0ebgTVj5y9uCU7WRNixbw1hv9UzNBKhnch9jVlDWf6tLUgEoG3x
         qMpMPFzA7SeaEfzhGwcz83aXCcShgdEUEyK5RnyL/JCqc4tY+5E8oyb8aPPLneO8deV2
         DviARTBgi5ssDVDsvDahWsc9moQfoXq9aZVZt0dtdp/ljEyiS5CvTtLiv6u9smDN28pn
         XK5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t87G03YJP+Jtnvd/a8HSoKeiu6kRlnnSEIlqeg1Cd6Q=;
        fh=ls6VcMm2ZUIeiB1rTSkQy74K1betVRrzlCQ705PWAzA=;
        b=UL3sh3HtPquN9k6WI+z6aQCchWIvYKJeEYYMCVJZn3aD+R5Q0Cy9KN9nV92GNQvQMq
         0mRZZRInFizgsP7Rz+Q7ol0aLgy5o7RwafXHPHYchQjxXpw/hKQfkUGeWn0m+tAK/mKU
         HpRd23sTZcicJKj3tnk74yW7LEMUoM1Enq+XHsglxktipCTHrk/hS9LdALyxTYzMaKmw
         7i1Tt1v0oDonJ6YdKYoFHeQ7QV1TONmNlptQLlfKmXBKDNqVPScKnMVvpL5uvA+n99IA
         /2hXeF1NZIHN/SHJ4CpTlR7B+DI5ZTI6P6Vw+GSa6JvCfacuxzrosZnv01yIlT9av+zE
         xbQg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791482311; x=1792087111; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t87G03YJP+Jtnvd/a8HSoKeiu6kRlnnSEIlqeg1Cd6Q=;
        b=ekGQBH9euZQW7roJHVUTz78IZH5BMW+575ULZsfu8rzZcbwfUBNGEQSXXha3ln6ADp
         b8EzU98q2RXr8vF78d8UHlU5u0N3G1vd8mH1uxIP0oU1dCReElKvbXqQKk0ZlWE4qQMr
         x9SOmxKkB71GqM52R9GRERr6fRMBEc/B2ScEO7g2Oi3C1zesNKJ8ubN+HXoGEqDWsz0q
         7jxcOg17CD1G3p17Zcck7yjw1jrQyvvLKx7ENMtuxEpa8Pex6Pr+THcJqlVkelBCZyJJ
         ifUCwrJ6jvv7rApZD7iCS7ZHtDAdzPUbpeC/91bzc1yQXc0nrIhvDZ5sjJN+fEDvAXHW
         ZuIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791482311; x=1792087111;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t87G03YJP+Jtnvd/a8HSoKeiu6kRlnnSEIlqeg1Cd6Q=;
        b=uVaPPmOLkLGD/IYkKT1cHFd598T6Jfv6l1NDTjzQBd67BFdUCDkbi9MVo5NI2palJe
         Lwag0TdPhfyap2lRt95MafCDmjX8IisxNutEWKylyP02dTVouVNmPNG4RV6Ld0qK5Wdr
         9FU8hf6xwlvM1F96muiuCOEDbB8SpBK65JKFNUwtBfu6apec5G2OIMs1mvAENRb4KkIR
         OU7aOyi4NVgQQmNefKAkUkLLh3k3HgjM1N4Xcvit5Zdd6VwypS2DoULah1huYTTYv8XW
         j9Xfb0TuLCDcPlBdv7NYmCVBC8IxgNsHY8C6myBzqvKoTjE/4oDO0/tuzfWjAdIQz0LM
         JvWw==
X-Forwarded-Encrypted: i=1; AKwUvBxcZc5bwz+zMU9HxYPMR6nNPAmT8tn/ijoqorHJAdq6KOrOdZzFX4bKgB3zlfnP4cZfW9dF2YC9Qw==@kvack.org
X-Gm-Message-State: AFuF++lVCOavraO5DP4wSajW94RlVkP2XOhcZtzi7Ai1OeP26hI+NXf2
	qzETARRHgZjAJ8QFoPV4HiKxWLencXier5RyZ+U5ZfPUz7XxBLM4OJBi14YaHRMRT8VEqD7Jafy
	JB6UXSyHK7t2BEYvDRnfef/YzQhdI0Kw=
X-Gm-Gg: AYBFou1cVlTmY3fpdjQuZOxIZoPuoCpBNBkBxMHC2Vd1xouW44B17nM9K2VBUpuHed+
	NBzJGnE89rdEh3Zr5nxztb7dQTYqzWtPxZNv4gcaCSsodpuKJBj8jNdEAmHKI0owDfgb73nwsNF
	gXGxls9UdIGRwcgBbq+HQtVmwDLCWNx8AVAUeCOsMAaG/fJ7ICwYwg5Yh3WQ+D7EziRgXRTuG8L
	waViDw2H9nTAwHh6qXIrx7ZVjkGvd7X8HxhHAlKSpWuG2JONc/bHefKfV4OnYjLx9Qy+o7/kAcL
	Qdo3RHh1qdm2DgPOf3qN1uDSdxac2jrmhu3Znvq9EYDIDKPwAgSUh7U=
X-Received: by 2002:a05:6830:6ad8:b0:804:d4b0:a36 with SMTP id
 46e09a7af769-82ad06ca857mr5680753a34.27.1791482311350; Thu, 08 Oct 2026
 10:58:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com> <ac2a8f1c-295e-4791-b233-cc8549430e07@oss.qualcomm.com>
In-Reply-To: <ac2a8f1c-295e-4791-b233-cc8549430e07@oss.qualcomm.com>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Thu, 8 Oct 2026 18:58:18 +0100
X-Gm-Features: AclHuK8_IR-ipfDqjHPYRkAYBCIcO3XOLSiPBhuHH-voREme2zuF2x6jh8EHKeg
Message-ID: <CAG4KcRLk3FdV1uKHhiTtr8uAuEB+Z=rBnrHgzPwPxQRsLyo-CA@mail.gmail.com>
Subject: Re: [PATCH v23 0/2] ACPI: Add support for ACPI RAS2 feature table
To: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org, 
	rppt@kernel.org, dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, Yazen.Ghannam@amd.com, 
	mchehab@kernel.org, ashok.raj@oss.qualcomm.com, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76653140003
X-Stat-Signature: eitcc4jhgh1k3oo4kpum3txoen5kx518
X-HE-Tag: 1791482312-82735
X-HE-Meta: U2FsdGVkX194BXE1gD9SwQkFzdDxjINepXuUMktWjGXWZWxgK1C1ivHh65+I4U8Z2Xezd9a3ZjZvqBPoks+aikobfpFmG1myj63nNsPGVvgsaoDx4GjrXVsO11d4tGLRgiOJqYfiMze7znpVZB9nqEocqdLGFZeWg+2bybuNou5P16eQfI012oACRZ98L8lNDppsllzn/rxB/A9PAz1QJHIzvrKP/FVAeaZ8ajuR9h+w5fHb/yoKLu1H5CmthcLd/4CyyXFXdKNuP++25av75ZHdLdj0JAsvMybrf0f9rH16V/pOd5YoJRNADy77rc2XarktXVzLlTmAgd87+uwuFK+GQ3dUk0BZSKcQxIRBAYTOCrMtUnBMXFcejwW+mez59NKrvhjf8JK1FFx4CXiYRJAM9gXT2rTeGIH56nr2VaaT3mW0m+/OASsyYEFn6MEroqU+BhP7lxj+1cIj1J/u3Fe7Bgw2GZe/C1KIUC/GdjIkxkzLZBHhnw2Skj7HveEMOHMOu6dewagFwWZt6x/G67tGG/P8fDnBoBc4XBuE8+0SwbBl86vGgcWqMxCHcWUZEg98lWWMQSwYCuy7L6gVo1vitWhv3wQn8KnPxS7UIbMXHEZEIlDOx2mho4jfH5WTCp46Q0pUT9xbMuZw3utThpMEn0TgcMupdGUwR0JQITXlFNAyop2R1Vl72JjCbUsbvqdoNvQGOC3eZqZBm5NI2B267V195UDPrqCm1HV1KJhCBVda86GkGrELHads8vqiLD3IxKbPBbYzHepwKRnTkynht0WJz2yUeaQV1V2BxjtaKgmdKaEn2HdX0JSCaZdEBa/QW8piaJxhZSgNkBQxDKowe8ZhDWkqv8S9llnmllNOwfPeHi68hJlwaoMNWqmPyi1mUSHTrYsNjKWDlL3BHekK8eTZ4RM8esrNv2Lr+BYV7mQP+jtLNlMz8X3DGPoGoMx3C+6UEWm2ByA39eg
 mZ9VlsZC
 oDXi3LFqcH6icNIJyjlRun4xbmNYn3ZMITGxyAnW4PeRYny30QSS55C7wNqwfjbxkGO2gBj0fuv2nK2MA9cxt+kf9T32gE+iN9bo8jgTZ4JhOcdLPSLmUosp1Qyr58AjohiEw3hoKoRcxzbEwYKZuaWJiE9S1iq7HiTJN0864Xr+9kgwwjfyYZJ1ZIXys3uuZwXptj50xaKg5B9i+gB6Y+dv3XF783ChQAjxZFsnjZtrb82JUwy5LI/SjxsNaR+LOEuwJVnzVgUkxeAaEdbOLz3CZ343laH2ipT9TKj+rwMFa0F2MPvVRyY0uNt2gOyRcB+6j+LtGgzsEvbDWdV0H/ENUy7MIJyIGzBbGWXlJ6Yc1fUeURWyZucX7ebwJip72+YVN1Jb10NjWvnPLfO2rwGiPFb2Fl2Wlco7QeDeZygSqJHLd5JYSY31gYet/ixB5tP18eTBmTcglHXnqLamXcfnNKBWD5t+vEuOIU08tOxwxdgS3c1Ik8Zneq0++cBGUfmO2VipHCjD9S9RPL3iwvthrlNT8HRPOp2smc4wuswunwSADN5Oc0hV+Og==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sathvika,

Thanks for verifying and confirming.

Hi Boris,

Can you merge this change or Do you want me to send another version
with the change?

Thanks,
Shiju


On Thu, Oct 8, 2026 at 8:38=E2=80=AFAM Sathvika Vasireddy
<sathvika.vasireddy@oss.qualcomm.com> wrote:
>
> Hi Shiju,
>
> On 27-07-2026 02:58, shijujose2008@gmail.com wrote:
> > From: Shiju Jose <shijujose2008@gmail.com>
> >
> > Add support for ACPI RAS2 feature table (RAS2) defined in the
> > ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
> > scrubbing feature.
> >
> > ACPI RAS2 patches were part of the EDAC series [1].
> >
> > The code is based on linux.git v7.2-rc2 [2].
> >
> > 1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@h=
uawei.com/
> > 2. https://github.com/torvalds/linux.git
> >
>
> [snip]
>
> > Shiju Jose (2):
> >    ACPI:RAS2: Add driver for the ACPI RAS2 feature table
> >    ras: mem: Add ACPI RAS2 memory driver
> >
> >   Documentation/ABI/testing/sysfs-edac-scrub |  20 +-
> >   Documentation/edac/scrub.rst               |  70 +++
> >   drivers/acpi/Kconfig                       |  11 +
> >   drivers/acpi/Makefile                      |   1 +
> >   drivers/acpi/bus.c                         |   3 +
> >   drivers/acpi/ras2.c                        | 509 +++++++++++++++++
> >   drivers/edac/scrub.c                       |  12 +
> >   drivers/ras/Kconfig                        |  13 +
> >   drivers/ras/Makefile                       |   1 +
> >   drivers/ras/acpi_ras2.c                    | 624 ++++++++++++++++++++=
+
> >   include/acpi/ras2.h                        |  86 +++
> >   include/linux/edac.h                       |   4 +
> >   12 files changed, 1349 insertions(+), 5 deletions(-)
> >   create mode 100644 drivers/acpi/ras2.c
> >   create mode 100644 drivers/ras/acpi_ras2.c
> >   create mode 100644 include/acpi/ras2.h
> >
>
> I applied the v23 RAS2 series on top of Linux v7.2-rc2 and tested it.
>
> Verified ACPI RAS2 and PCCT discovery, PCC mailbox registration, EDAC
> scrub device creation, scrub capability sysfs attributes, background
> scrub control, and demand scrub operations.
>
> I also reproduced the PCC TX ticker issue reported during Ashok's review
> of patch 1/2 and confirmed that the proposed fix (initializing
> mbox_client.knows_txdone before pcc_mbox_request_channel()) resolves it.
>
> Without the proposed fix:
>
>    # d=3D/sys/bus/edac/devices/acpi_ras_mem0/scrub0
>    # echo 0x8000000000 > $d/addr
>    # echo 0x1000000 > $d/size
>    # echo 1 > $d/enable_demand
>
>    [125.577700] PCCT PCCT: Client can't run the TX ticker
>    [125.577704] PCCT PCCT: Client can't run the TX ticker
>
> After applying the proposed fix and repeating the same test, the PCC TX
> ticker error was no longer observed.
>
> Based on the above testing of the complete v23 series together with the
> proposed PCC fix, feel free to add:
>
> Tested-by: Sathvika Vasireddy <sathvika.vasireddy@oss.qualcomm.com>
>
> Thanks,
> Sathvika
>

