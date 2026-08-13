Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA41DC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 18:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1BF6B02B7; Thu, 13 Aug 2026 14:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB16F6B02B9; Thu, 13 Aug 2026 14:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7526B02BA; Thu, 13 Aug 2026 14:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 896716B02B7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:55:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32D3A160187
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:55:02 +0000 (UTC)
X-FDA: 85097148444.08.FCF280B
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 479A140003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 18:55:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QcEEWDWb;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786647300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4D8xAVPVQumphtAB0QLf5r82YP3dFNVcG1VBTYgExPI=;
	b=xX4S7bFlNpluXETBEVmTEPUmZOBE1qjUVdSzhRkQH1e7aOTiqRE+CNfOE55CDGNVxHhtot
	skxDA+Wa6NWXe/CBeNaV4JAwEaKm46fT0MV5M0wFUtnvJuydJIS/vUBWh4qspo3kjHR+MX
	KKcg+EQNLKkp8N/KMpSkGtygOLKOJhQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QcEEWDWb;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.167.181 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786647300;
	b=rNKCD5zZg8MwUNoc1uaIEUG2tPGrDu6IDLS7TorK+88IFy703BcUKCW+BPjTpPuWfA0Ymm
	BrRKpF/E0RzyC4PdALu8H3mLR6Ag0KOBY74v1Afp1lhJBrH4Q+Ct1WEwHKpaSMCw24UE+k
	0FQp0nXqs5bYVELOFgZUNqE7stPxIqs=
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-49fa951b2c6so83346b6e.1
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 11:55:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786647299; cv=none;
        d=google.com; s=arc-20260327;
        b=Z2fXJQPKFyxAuv8v3128D7MY29SqzSz6hXTQD7Ismuzhl4yITw2qeDgoQXsYwBiCNW
         awrg6ytZIUuiqIwq5J7S0psmofQHxIxsMsAn5ynWNKaRcpGxINkKL70BNFp+b2KlHzFA
         9G42M5Fyl7/8IM6x9jYs+9jYF1H4ooqr4XgnxjGLRljYmRHVoPJmvaHi+GK9ov8fYp//
         Vjy/bKvkar6wao6kIEtyhX9vxB2iqSNBnIX07EIZeoFPwml4SSA6unExuZfVdmeyaCRG
         66PuY+3HS/fkwbf6OmIDrDTWPb7VgNVSOVfGA3MEZVZPPRamlJ0Dd+zt49Yk5iPp7sBO
         bDuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4D8xAVPVQumphtAB0QLf5r82YP3dFNVcG1VBTYgExPI=;
        fh=hjUyEdERBGZnKKgRTr5BSavyoy87mtVDlHErtJqI3UY=;
        b=GjXKOJjdOQNBlFu8qQVuDO0y0Ktm8Vk9BRUG2w5MGbGqmaO6+5VVHesOEQNf3bQ1mq
         VnuAdvfowojAULh3cV0OntCu5Ke4axPbEJCinhCJNNDVU4+1RKA+pclqyzMqOinTeH9y
         cYVXReujfBA7SM2kgo+SwyayB9bruqH62mpG9/M6jOHpg7Uv5D+PQa3MGt40ka5jEexb
         0UIpYEtrUiu5hcjjAftyy4/qlbVS3lKqW6K6fgOyXDrx+vRzMIjFeWb3vOyQgMH8Vnby
         WYmKa+h7CnpSedzH98aoUjWkst8+Ptkm0SXW0SwncVufus4TPMO/LR58Zqf2ww2MmSc5
         QKsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786647299; x=1787252099; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4D8xAVPVQumphtAB0QLf5r82YP3dFNVcG1VBTYgExPI=;
        b=QcEEWDWbDId4nEVFxEe0rgEVHypp0sL/M+7EAK1LPFJnyitNaRzaWXSXZYbT560g/o
         3yHt70RM8Kj0UdriSXC+N3v/jEuPVJMUuQDIlvNQs7q4rF8E5x3RiGDA01y5rl23ghCK
         nkONlr7VedGMalJyDEzwfPQs7sUjVZsJKrVPcUx3tcv3gN7LEwDGVFY7d3VOY8x2QSRP
         Bhw0sXyCtbba1E6TZdoaOAzKWk7zXFE/zuV+vxoZQ4mnLEy/i9h7OppU75OPRPn6N5iw
         dLnCMvqAoONkeC+J3ti9zLQPSiMSzLRerlK9M6u47eiJGMaR8BacK7sUTQQo6I5cnply
         SBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786647299; x=1787252099;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4D8xAVPVQumphtAB0QLf5r82YP3dFNVcG1VBTYgExPI=;
        b=KS/5vgbJkWoEsPMPzUYGpexi+TM/newzjHe7SDouXee029ea8jRXqIGJ2MUUYiWe8S
         rc9e8LijZX8nIXqWnSrxWdnnYBNvcywjmeGm4EmVjIoCKqYsSSlh2PL/QvEr97XZeNHB
         QfPxvxYpLiM5mOEZu1Y14C0KCj9Q2VmUiu/awihw/kMb3E2c1U3ve2+OPzK7KGbAWY7s
         qGgKlv7kkfG8pRPukuT6/9JjnqnLr4I8ABmJfET3o0KLzxQ81U5tFuvSAjlAMl85YBbj
         UuiVhffkB2z8psKJg3D3TqAqqn3UoQRGSaa1CdPBw2X7M+sEiExH29IgfAk9a6qYQER1
         NfSw==
X-Forwarded-Encrypted: i=1; AHgh+Rq/lJB5G2lRJDLi0coiE0jCmEgrHolEgJFHvFVQ9/Q43QFYUzrjurPao3o85KDvlBSl1RuIOIzw1g==@kvack.org
X-Gm-Message-State: AOJu0YyiuhN7TFEvSMvL2FopwqqRSuCgTWbJ0thIzd5Dzap4uQXfzPA3
	x3bsQQi6x4Mkyw3K3uadGw+bALPrPre4M/q2bZ69u87kMDeQaf/JPLTO+F1+wlwwnknqDo/EbHv
	Pz97Ek2MECAzhH5gaRZCbsGRzA+vqb7qgzgs6yZQBtQ==
X-Gm-Gg: AR+sD13zAemoGTkqixepsn+/YbH0/48Wbz53mO5MEvJO4AR3v97lFcn/wSRSnaEcsPN
	7ak962CEnNq5nzgyeNcBSHPadckTESVFJ6z/L1Ulxq0ioStcQ1cVg5s0N4U8OCNL9Au7vHojhZb
	k0gvwosREoaepxjQwaNAKVNMb6msA+jGWaLvCaq+LwFBCM8K61g2PA+/k6lDfR26WHjqRSEt2oo
	IHAz8DD4JnAB/mjb+8mFo1bMLcbRnNGu4D8mlIc9gGIYBcELU6zmzFK/NjwDyJ1BWsNz0r8xLnP
	eNmuXa2CBJ5SeehIi+5gAxeMa0LKulUnXF/zRyO9cDzq
X-Received: by 2002:a05:6808:1456:b0:4b2:3e72:bab1 with SMTP id
 5614622812f47-4b2413e7cd2mr156530b6e.6.1786647299226; Thu, 13 Aug 2026
 11:54:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com> <anvRn4g9Ihn5eyVq@hu-ashoraj-lv.qualcomm.com>
In-Reply-To: <anvRn4g9Ihn5eyVq@hu-ashoraj-lv.qualcomm.com>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Thu, 13 Aug 2026 19:54:48 +0100
X-Gm-Features: AUfX_mzK2KYq66enN11TTUyY_bgBfEgK88jDGTBrTGSa-gkPWcIl2Tm-4YHdY2Q
Message-ID: <CAG4KcRJR9+KMsoWjUWjaMveTteqMUrFukTcRgb0SZ593Zqj=tQ@mail.gmail.com>
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
To: Ashok Raj <ashok.raj@oss.qualcomm.com>
Cc: rafael@kernel.org, bp@alien8.de, akpm@linux-foundation.org, 
	rppt@kernel.org, dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
	linux-acpi@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	tony.luck@intel.com, lenb@kernel.org, Yazen.Ghannam@amd.com, 
	mchehab@kernel.org, jic23@kernel.org, linuxarm@huawei.com, 
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com, 
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, james.morse@arm.com, 
	jthoughton@google.com, somasundaram.a@hpe.com, erdemaktas@google.com, 
	pgonda@google.com, duenwen@google.com, gthelen@google.com, 
	wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p9qxctsd7957tmf5dzyyc93fnrn48e7i
X-Rspamd-Queue-Id: 479A140003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786647300-267806
X-HE-Meta: U2FsdGVkX19vC1GzAwqFn19x69bGLx+wgLXhxbHSAV161FprP7HR14bal6RtzD3nNCfBjeCWeRjheETqBS6b/PA5ZRONuNt7Y+B0C/yIA8HOLXX+PsRWt/1HbhgkRRdPqiI4xvq1EwpaZ9JrxC1v8e9cJD4x8uwCGOV3rzMce6E5UB8rK3mXuP02J2WBSlbc1vAQRCkFIC8q1N/HQGtplAqr6I6WCuws/bX0gHuxrub4Cyp4cN5F6FdT5ZQrAzNmYpsTXl0RZzw5U7Mb1Y/DiIAbnesaKFyCis8sS2m0Zzl0JwMP2HI19qj4/+faqFvNb+mYkSRHmga3N4VUMhq7wyGRhPJPLovlSTSCSm+KDPHPbHjIDkt2lAMTvqeAtLWxeDzp03ETry928tMEjKP6LNTc0IhojwnU7YhGAZLdOhE3hXQFM9ZP7Op7vlkfVEzwr6Sb95XlW3PqcqiObHtt9yqwZRha5nL6K2CRoxkJR/kglAcYIRlU+lD0ncasGZeauS/XmyQ5MYVGBU1GGDYLwqt9mXuOHLt0OQ0a3pxX5kejUe9zixmlMwrfM24Y5jW+ON0HJABUgS4xfe0+umkUa/3GEl4hq48zgZT+V1YIHOxwTgWCmQQkInZuQkby7VXpjZZ051VrbURSQYmMqQ/ghrkcaDf9TTvv19h+JS8D4R/u4UAFoumF0TKUJnsQEPe7YrKbKpj4jYRrsMXQTeWyNylPcyfDKxt+q66e9xStqNStg2sWHZWpstC4ZBgRIFGeNVHEzhcUv45cQnKpFizKTRpv5YYRS65xRI3JHRitsTkGiFVsvtlZL/3H0il3u/GEbIod2NK3tbyop0mfShaPbb8FIpoGQ2/SgmVZo4oos4NwHe5a8LUALGLpjeZdLvzyDKrWzh5yYQYGfz+b2EkJxHuWM2FImW2Jcx151EvQ59gjV2hxjbpeqc7AKVyGfiw/kQq/WH/GVmYXHWUFTK+
 ANgykWuj
 848LBUP1g2r0EYu7FeNfZBWTGXqHX8hycmiTbwV9eS+la9SuAnUNLeDcgIKOEKQNmK0aGKXwGFgz5h3V3s5wcoIM5qxFP9E/iFaI9ZzAkHKfZQLDkhwa5tqwW3jc7AhHPmdEREjs6uqcMGbSZSuwZ8IAp9ZCX8BCKvGx/FmBeqF0UUOmJKFJcNXGXzG/3bHHC3NoRcUcYruGDJRvu28ITf4z3g9YSCaCI17CNPBPomyQnCTbuC9/o3wSGAYLE2am5p9NdvZYgODof+62NcWClOHqSHKN1II1qyKZCw8cZUsG134PN0IYwPeUczmWypO9lOy6Iwlu95c5NaHxDQsg79MHxSfoMnI3lBWyxnndJIXGU2HMaAzvaHerVzadZkwTnydS7M00ylWu/EUDlzswSD6+Xxbz4AOa1AoBr+zFnYZNmRg+ecULC0+yL+OSBeojz5s88l/nftHyDss9jJAtraatwbCrk8dTuQDceGc3Hd9PEIHh+WYc2pBoLwdnJiMwi809Tre3HLZJ316DP4+fWjp23GZiCXf5jvV70mOHDUVLVXvrr3JbeOOO59tTr1yR37myMmFF51MDOQ/7zqm6OovmfhQTpqxedc4nE+I5AZqbiCzpESjB2yIBJvrfSYwd1E7mI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 2:51=E2=80=AFAM Ashok Raj <ashok.raj@oss.qualcomm.c=
om> wrote:
>
> Hi Shiju
>
> On Sun, Jul 26, 2026 at 10:28:11PM +0100, shijujose2008@gmail.com wrote:
> > From: Shiju Jose <shijujose2008@gmail.com>
> >
> > ACPI 6.5 Specification, section 5.2.21, defined RAS2 feature table (RAS=
2).
> > Driver adds support for RAS2 feature table, which provides interfaces f=
or
> > platform RAS features, e.g., for HW-based memory scrubbing, and logical=
 to
> > PA translation service. RAS2 uses PCC channel subspace for communicatin=
g
> > with the ACPI compliant HW platform.
> >
> > Co-developed-by: A Somasundaram <somasundaram.a@hpe.com>
> > Signed-off-by: A Somasundaram <somasundaram.a@hpe.com>
> > Co-developed-by: Jonathan Cameron <jic23@kernel.org>
> > Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> > Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> > Reviewed-by: Ashok Raj <ashok.raj@oss.qualcomm.com>
> > Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
> > ---
> >  drivers/acpi/Kconfig  |  11 +
> >  drivers/acpi/Makefile |   1 +
> >  drivers/acpi/bus.c    |   3 +
> >  drivers/acpi/ras2.c   | 509 ++++++++++++++++++++++++++++++++++++++++++
> >  include/acpi/ras2.h   |  57 +++++
> >  5 files changed, 581 insertions(+)
> >  create mode 100644 drivers/acpi/ras2.c
> >  create mode 100644 include/acpi/ras2.h
> >
> > diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
>
> [snip]
>
> > +int ras2_send_pcc_cmd(struct ras2_mem_ctx *ras2_ctx, u16 cmd)
> > +{
> > +     struct acpi_ras2_shmem __iomem *gen_comm_base;
> > +     struct mbox_chan *pcc_channel;
> > +     struct ras2_sspcc *sspcc;
> > +     s64 time_delta;
> > +     u16 val;
> > +     int rc;
> > +
>
> [snip]
>
> > +
> > +     /* Ring doorbell */
> > +     rc =3D mbox_send_message(pcc_channel, &cmd);
> > +     /*
> > +      * mbox_send_message() returns a non-negative integer for success=
ful submission
> > +      * and a negative value on failure.
> > +      */
> > +     if (rc < 0) {
> > +             dev_warn(ras2_ctx->dev,
> > +                      "Error sending PCC mbox message command: 0x%x, r=
c:%d\n", cmd, rc);
> > +             /* Restore CMD COMPLETE bit on error */
> > +             val =3D ioread16(&gen_comm_base->status);
> > +             val |=3D PCC_STATUS_CMD_COMPLETE;
> > +             iowrite16(val, &gen_comm_base->status);
> > +             return rc;
> > +     } else {
> > +             rc =3D 0;
> > +     }
>
> Minor:
>
> Sorry, I missed in prior review.
>
> Can the else after return be removed?
> just set rc =3D 0 should be sufficient.

Hi Ashok,

Thanks for the feedback.
I will make this change if another version is needed.

Thanks,
Shiju

>
> Cheers,
> Ashok

