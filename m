Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 601A0CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 22:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 309546B00B4; Sun, 18 Oct 2026 18:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BA776B00B6; Sun, 18 Oct 2026 18:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182366B00B7; Sun, 18 Oct 2026 18:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D50FB6B00B4
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:56:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BB4B8058F
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:56:36 +0000 (UTC)
X-FDA: 85337257992.04.AE3266A
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 463FCC0004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:56:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rqDrR/Gx";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792364194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejS/LpjqoYagtCx8wF4IBCZ5sMYQJivNYsQq5fSIx44=;
	b=onSaHOlMkPotrxPoWV/4oagBQ+l1BkcpDrr9R7AcNPneYTWEqN1Zbay7GB4VEE+lyvmDYE
	vd86aqPReHrbGCij9zg1e6cIigs4qxO8vX4X523ELJ9vucpxD1wc5giT5IiQhnMsVG9VSB
	g1NnBDeMcIu9fleJwFUvfqyFta1asjI=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="rqDrR/Gx";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.42 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792364194;
	b=a4LBdYmx6g7GmXVWqh+dtn/GOkHTr07MtIm43zYZy0/AWo0VIwJZtt9MCtTQUSWgcB2PhQ
	+x8qjGGKd48CGi/HvR7+1HAgvzeAcSGRXUuZtZUDiUAkO2/Dj4YzNRfoa0YiMazWXIeQMe
	CqvM41ty2y4644ACgXUJe+lxA1kp9yM=
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-81ba09a5d23so1204303a34.3
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 15:56:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792364193; cv=none;
        d=google.com; s=arc-20260327;
        b=LWpEaEtRVlp96fyFw5/UFXextYirOGT4LoZzm106V0LJwTzp/LYhku1gTArYQKy8A5
         BmBJvI3MKHVfAXfxrCo3LuQJd7YrsCa0VqTA9oIRz1toxuWiQEYpbDQxqjv750khTDLN
         j071MtLN8k/6VFqyRaF7my6Dfv9qtr0mGmV45zkZrC6HXNGgDmjrV+c5cZsgKnGVLecZ
         7eHJxtprjy+zx/tntxpDe6duZWlsxpawvi051NxWUA7bflZEfUABpcZ1pfdzeu4bxrRG
         9oCoQTZnQl5AiDE5aQeRqwRvdMfLh8WyuL9AA5E0gFRgjIOuugAdSHbsCyKiLzeS9Q8m
         HRmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ejS/LpjqoYagtCx8wF4IBCZ5sMYQJivNYsQq5fSIx44=;
        fh=aOGHaxcnIeXsHCbTolS+Z+pNJkTPDB+XNvZB8SbgH6U=;
        b=UDK5qwhvZ0Ji72LWZrae612n23sIzSYpgMIC6rcDN64bDCIq1vUXjnkdfeiQ2sOrBu
         BH1tbqFBmc3TX2owabzlDAULcTfcOGYQLi7EdrOw7TNj3697s4jJkvxOsk6KQ6hLB5t4
         LTyVaOxijb7/J/nBvJwH+Q6FI/eMcEGPCIroiWnDUzSwQmfa41H22Q+wpDDUR75va3Qv
         dd3o2Hrh6/WIuKHksPksPNpgzfhxIaQjSNouMycZTqRnsxiqZeugFc28s5FOXBzlJdbZ
         fpgaXzXRkB1VBpKRvC2cTLSutW2Q9j5izFel0B7U6UaESSK4VRGw6ZvB54KcFOeo9qRS
         ucvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792364193; x=1792968993; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ejS/LpjqoYagtCx8wF4IBCZ5sMYQJivNYsQq5fSIx44=;
        b=rqDrR/Gx5MRoprvJobBiaIQeELQk3gyN85Co3K6+xAyfXlFOmeeiE+lgClMwzzgMrq
         u2xu0omMqt0Dm3vRJsY9ieCUhSYXRKU5rT/0HkANZVWIOL0R7/wN5dDtyhaou3S2gJ+l
         moze2Wwv+8GCYiW0MnN60yxrWaCwjAZr9rPTYCphSCkoCnb6mHz+J/xZcGdyR+9WVMFv
         njOjD5yOLKG9tsMBGw7v71jpv32y3AA3KPRNLWnVrddBLy9v4CXB/FOlFE43IoDqjd01
         j35LBC6QUP7E53CCk8bn/3nGlIByRgEAuk+V4BwsYd+GfghUSXTx9b5IBiyAyznqTFlF
         cfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792364193; x=1792968993;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejS/LpjqoYagtCx8wF4IBCZ5sMYQJivNYsQq5fSIx44=;
        b=t/GbaPfa7n6urOt0uxlfM5eMtcokkNDqeR8tOOFrdt4mJU8IWsoKE8odmCScTRDZyt
         5zcr65pOGRpi6lUA/xQjiOQzEHkGavs+NRTPQVKtzYo2rW7oLV/KihhkHtH1evy9e2w8
         bhS5RGrO8yL4aF05VJxM5/OkXhPQlBjy2xCOyy96g7K8tJ4h/MRVI8U2MtxgXdvlThV/
         alKgnHYhjBHXPcNqVhduxAI39HjTqKtQvcZgm865Mny1yh4T7OBQxoMg3jNFKdIpjOO8
         qKTyE2jDO0cNYXPULB7MwN/ju3laCrde24XBCyK5GTl/B8FJ8j1KN4C4lx/mC6LA6YM9
         vqSA==
X-Forwarded-Encrypted: i=1; AKwUvByAYOAaSKREI7f+9AnEPwWHMZ/qB2pWwwDJIWmHnHCJkamxuIFqnSfXOCGygVuZumO6oS/ckgmLvg==@kvack.org
X-Gm-Message-State: AFq9FYKtRbz5wwLqdW5arlYHfNKPDtR0voNuJ1AJozycPTonG6GVezjT
	OPw3yzQPBxyHq5avWDxxsRNBD+ruQ04x6z57KhXLR2dNlvNukt2Mck2tP87rpC82wDEJ2bp7KHk
	X6kuKYU0Ql2Todb6L2QHB5IclTcL92aY=
X-Gm-Gg: AYBFou3SH4sedbdstdMbndKwjMCF6vu9FBNUeYl39YM8s/cXyXzYYKsVjeOZsSJlIyi
	tUIZFLY2ucyDunDOQzxwE5Tr/TPclsxRX/pd2GZMW5OqQijacdmOUz9gordpyQElyieXoTkoSHa
	x4515137FkxCEgPRkGCod8Dfkfe0EXHiL6N75n53dM2zcRxVWFKzbgiSt4Vd5+MD+8tg1jZ3kVS
	o8vodjmA2c7ShYINYBWod3AX+z9NrM7dacqkbNxWJro9/ABlkTDme8Yq4SCtrfJNlmixwkABIEF
	WNvdGaE/VByXZjgi6c2GZL2FMMEmzSnpEeJx7aNnt/hl9lmgbz8Hdy8=
X-Received: by 2002:a05:6830:4128:b0:81d:8057:9b7f with SMTP id
 46e09a7af769-84500f4d898mr5770027a34.28.1792364193081; Sun, 18 Oct 2026
 15:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-3-shijujose2008@gmail.com> <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
In-Reply-To: <20261017055852.GBatMOnEl66YObvU5k@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sun, 18 Oct 2026 23:56:22 +0100
X-Gm-Features: AclHuK-FL-g-dxxplQ9WjTqpUo6LUA2zDPurgO-FQV-GA5RtzvuribE1sLlFWfg
Message-ID: <CAG4KcR+NOKHNzg6FN-oLLHgUxeitZHKXg9cN7dz24+Ap=RrwSA@mail.gmail.com>
Subject: Re: [PATCH v23 2/2] ras: mem: Add ACPI RAS2 memory driver
To: Borislav Petkov <bp@alien8.de>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org, 
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 463FCC0004
X-Stat-Signature: rf6c7b9wnyu4nbf56bx6d8d515tg58b4
X-Rspam-User: 
X-HE-Tag: 1792364194-749266
X-HE-Meta: U2FsdGVkX1+z1WFP9YypdVU9LYhvQb0y1Yb3xOqAIEgkmaMSKQjc+w2RKmhb1/QkQpq87EljLrOtzByXkUFppSuDl9aB5tRIDxFRfd3bduQ9Wg9ycBkNrC+iLrp4X71Il19/l1P97P3z65eV5pYF8AYkEvrXvoleJQj9AGQ+n1Gh5Wl8MN5zS9iBJ1f04+dSMWpVDAO2C4x+9J024f5YKi6Rd4IW/+uzgBYS/BT8m/ih+NaOG79gJtb/4eZP+66kzDasQEzouRF0RRxgftcWjN6TbQ3l2dRGUNBu3+Yai7WmSWydpRl9rY5LEKLi92OClXbc4v/nmQxFJiXxnMpLD2xUY8hVamqzIVLP9+yXvZXTFk2aeaSJBQINZK/nye5yn1dI6+XPVvDT78Xk9nUTkyTM5xI95CvslN8NOZCU56/180lbYD8MbKC/1wcqr8OPz118ZbZ3QDQRNVfl1QTeW7sukK/G1hacEJK7EbeEuaE26SefEOSXbI9TOggAk+CW5vqcQlEjlu+Qpz7RgCPEDqizqYUqd87KfNJDJtSiuwcBsc8gDb8n81m1wCSAOQPLcHOKrV8lXqIif29vfpB29lQkPr/bHyMzBKSkX112d53jIGE4bR9e8jDzntdFqCbD9R4qqKuRsICZI4RvuxT47e9Ruyz7zXqzWZ5oumnYl3XVfjWQxzwjkzhFZtM/fXvcafVXf8yIvV+l3IzJS0DUPxcqpXkU5e8fL47aT/JVQ3ReAMHV90VllY8ZuHoejgdqOtN9+cDl/NVFOAA9Ha2p/2gHcb191j+g2/gdTq11mS9LaZFSKAYOpqEddecdtvRH7I3HTYuJ5WbDiegRFg98myMWGe9jP6aB6aAETdEQ/XTAUu2t415eLKFneOS0Is6gwPxL2kPYXyKqO0McJEx8joCuk7hZEvtElf8ds2sPXvEvRORF64FyjD598ZdwXo44u951PPRB+rr7ldssf2h
 23VhvMUQ
 TiWyWMCQTNaDiZiaroKV3IU1vbIVGgdqyYXVdnkuQGDNxB6vArsqKOJXiipdtfo/1zpl6OBrOrCzpsRa3wrpu/tbspmUBrdwyP3nB/B7nFw9vVOuHkP4q7lcgQG8qOwJLjG5BKYIUbAYn5by5j6RLVb8wshhJ3wdiEWj78Xgnv6LhT/p3EC4R3yojEl/NSrCqP4YqPXVehRCbgpmOBWZWIoSKChVpuoOYnVqmdo44SQPYH803RJJ3pP1C8f+jT4UOLboKHfm73tMiwDEkWSY+718fhj0iRq4g88UQk4VAFtpYvySh3T3/CbCZ7m4lolvp/VV5BS95CU4uD/8RFKpjb54eNL9PDtHbgyOuIqlHF0VKEL24KcpTUYzWSajR78yPP9PI4FaEzielRIPusUBKrHVOhCGDsAfy0v8ll8WVOYuAYD3S5o2OfVYlD/tLJ67acnhEH84A2oWgRDiEkuGIBUljObk0eHyDDpHbranVVFdcstoaJ+cC/7YLXKpTuGL6knzn4IY4WlSdN7Ne1rtzAi/KqI+QSuDdqoPaDLbsGJAsVsvJqHzDcmam8GB1xxlYJIB3dELkRQBq6dLzl2FDcxFXJ3ARt8BFCn94v64nDMW0S2NsrV3zi6RPFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 6:59=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Sun, Jul 26, 2026 at 10:28:12PM +0100, shijujose2008@gmail.com wrote:
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
> > ACPI RAS2 auxiliary driver for the memory features binds to the auxilia=
ry
> > device, which is added by the RAS2 table parser in the ACPI RAS2 driver=
.
> >
> > Given the address range provided to the userspace may be the lowest scr=
ub
> > address range in the presence of disjoint address ranges, skipping addr=
ess
> > ranges that are from other NUMA nodes but happen to lie within this ran=
ge.
> >
> > Driver retrieves the PA range of the NUMA domain and use it as the
> > 'Requested Address Range', when send RAS2 command GET_PATROL_PARAMETERS
> > to get parameters that apply to all addresses in the NUMA domain.
> >
> > Device with ACPI RAS2 scrub feature registers with EDAC device driver,
> > which retrieves the scrub descriptor from EDAC scrub and exposes
> > the scrub control attributes for RAS2 scrub instance to userspace in
> > /sys/bus/edac/devices/acpi_ras_memX/scrub0/.
> >
> > Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
> > the demand scrub, which is used in the RAS2 demand scrub control.
> > When a demand scrub is started, any background scrub currently in progr=
ess
> > will be stopped and then automatically restarted at the beginning when =
the
> > demand scrub has completed.
> >
> > Co-developed-by: Jonathan Cameron <jic23@kernel.org>
> > Signed-off-by: Jonathan Cameron <jic23@kernel.org>
> > Tested-by: Daniel Ferguson <danielf@os.amperecomputing.com>
> > Signed-off-by: Shiju Jose <shijujose2008@gmail.com>
> > ---
> >  Documentation/ABI/testing/sysfs-edac-scrub |  20 +-
> >  Documentation/edac/scrub.rst               |  70 +++
> >  drivers/edac/scrub.c                       |  12 +
> >  drivers/ras/Kconfig                        |  13 +
> >  drivers/ras/Makefile                       |   1 +
> >  drivers/ras/acpi_ras2.c                    | 624 +++++++++++++++++++++
> >  include/acpi/ras2.h                        |  29 +
> >  include/linux/edac.h                       |   4 +
> >  8 files changed, 768 insertions(+), 5 deletions(-)
> >  create mode 100644 drivers/ras/acpi_ras2.c
>
> Was this supposed to build on x86?
>
> drivers/ras/acpi_ras2.c: In function =E2=80=98ras2_update_patrol_scrub_pa=
rams_cache=E2=80=99:
> drivers/ras/acpi_ras2.c:68:9: error: implicit declaration of function =E2=
=80=98iowrite64=E2=80=99; did you mean =E2=80=98iowrite32=E2=80=99? [-Werro=
r=3Dimplicit-function-declaration]
>    68 |         iowrite64(ras2_ctx->mem_base, &ps_sm->params.req_addr_ran=
ge[0]);
>       |         ^~~~~~~~~
>       |         iowrite32
> drivers/ras/acpi_ras2.c:99:34: error: implicit declaration of function =
=E2=80=98ioread64=E2=80=99; did you mean =E2=80=98ioread32=E2=80=99? [-Werr=
or=3Dimplicit-function-declaration]
>    99 |                 ras2_ctx->base =3D ioread64(&ps_sm->params.actl_a=
ddr_range[0]);
>       |                                  ^~~~~~~~
>       |                                  ioread32
> cc1: some warnings being treated as errors
> make[4]: *** [scripts/Makefile.build:290: drivers/ras/acpi_ras2.o] Error =
1
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [scripts/Makefile.build:551: drivers/ras] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:551: drivers] Error 2
> make[2]: *** Waiting for unfinished jobs....
>
> .config attached.

Hi Boris,

I have got an arm64 setup only, did not try to build for X86 recently
after adding the following change
of using iowrite64 and ioread64 as suggested by
https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com

Following change is required to build for X86_64 build when using
iowrite64 and ioread64, while it was
fine for the ARM64 build.
Note: I'm not sure whether RAS2 is needed for the 32 bit build or not
and the result of the 32 bit build.

diff --git a/drivers/ras/acpi_ras2.c b/drivers/ras/acpi_ras2.c
index 51adfcddfa99..cb389ae6a3fa 100644
--- a/drivers/ras/acpi_ras2.c
+++ b/drivers/ras/acpi_ras2.c
@@ -12,6 +12,7 @@
 #include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/edac.h>
+#include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/kthread.h>
 #include <linux/platform_device.h>
 #include <acpi/ras2.h>

Thanks,
Shiju

>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

