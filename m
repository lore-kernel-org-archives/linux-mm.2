Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26970CA9EBE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 08:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31E16B0092; Sat, 10 Oct 2026 04:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0A636B0095; Sat, 10 Oct 2026 04:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF94A6B0096; Sat, 10 Oct 2026 04:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBF7C6B0092
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 04:22:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3E4C3C07F6
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:22:40 +0000 (UTC)
X-FDA: 85306025280.10.94F8E2E
Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51F64A0002
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 08:22:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M7ZZ2JJo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791620558;
	b=w4LmaAk6rQmBmxEQIjf9iBdOLz4JfP+fMLyXVcl+xnlBCVXtFRjBAYoWxxtHFdJ9dAU7uO
	sWGF8iZlkGKqTflGK8hRB3tvu2APdONnLVTy5XN4OUnRTeWu/gZDSzu5aYg6Fj7GD3KMt0
	pCR81wvy1B1Ey38QympJWXRsMGxxMzw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=M7ZZ2JJo;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.210.47 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791620558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=leU69vU0901atm4DuawOU09rDiJ7Q9eEEaM1dv12Nfc=;
	b=dANyMiOEd5jDiLtS7ulZnYkVZcOC3EAFGrFTLw5gBf7ZPXBPBbePTJUQtJSohxnlSpQP0x
	j7xTh/6MtxrJugbBjUuNFoDsENcuUYsNgLOm6D45qf+1FGGtLoFDTR61q6T04+doBQayzh
	j6WeUVJRmNMQpOJtV/UlIZ+PbmaV/xQ=
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-82395ae2ea8so402730a34.1
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 01:22:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791620557; cv=none;
        d=google.com; s=arc-20260327;
        b=PnZ+RX/Lbb9FniRXUn45QIY/lc7t0nEuBm3PzXriv18h7SjHUXBkkoxqmQeczzr2jV
         y2RGNYa6W+tRzj+kYMKVk+n6FrVuGL5313q+i+wI84JLQ5nDHGYRpojGIrFrrM9N7P83
         a1sYn+PhGZ2TsTlgu16HzYkjoSi2wUf4Yga0fOjAF4w0h4cbwV3JHo7O/S2a9+UvkxYY
         4SmHN1e+mSlJjxvvkJPJkPbKpsakDlqUGeoVyDVBS/mPFSVmj8el10iwr9hw9Up80opX
         tzT00wamGQWHd9g5CdpmwnTYHCUocGNkabnfmGPE36JEKYB67l4EzGk+2BqW5Pjdp5pf
         vR2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=leU69vU0901atm4DuawOU09rDiJ7Q9eEEaM1dv12Nfc=;
        fh=iAoUxRnrNme+y0WAokTPa9OTA9OwHJ6XcuVmpDTTeiQ=;
        b=oFKd0kzCkOg3U/LwKk6mRRfCI+WAC/cZqe45bWUAHvVaCrAmNH97uYYEgVXWpKV456
         LejpVBVOb4cFbDFqG9W7aLWysBCzrz62/n0k5z8IazVlWZ+7fTOctUegfwfUn1i3nNB6
         Ep4EdlH0BjWt01i1LhEwVuLycvtO9QeD0D53TdcZRWtRZYTstoYDQdShCIuMx7zcwgum
         7T8SJOI6o8YEZcwzvtxOVXsx7JlNqij8qRU/hxRUY3bxxXeY2C0aepzalPpYoMC/Udip
         Mh71GrI0QC2qZY14fBr2WaLSH/EL7TNxG86Fpwv/bB4oIexwSzAq/HsoHXyNdeC30MlM
         yfvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791620557; x=1792225357; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=leU69vU0901atm4DuawOU09rDiJ7Q9eEEaM1dv12Nfc=;
        b=M7ZZ2JJoWo++NX2mz5S2PDrU/kTEhWkUQVSk48QOVTYApZYSK+2Q4e/4iSozrXgVPB
         1S8sk07AmsXPw0xxXCr4qj4hMcxDXi7T9SmgGWo68JVLWQAFiIuUmPVwBoqHaz/i2kh1
         UmTZ1plunsBWI5Gc12GX7xjMo/EJF+nh26Qh28CAgbmVLUA2XgRQX3sy9VFVV2hYkYaj
         wg2v8aPc1ulv5/pj/GJKiHtSZYJguH8LSaKScjSqoWTlQYYxSIG6i7bh8SxUOQmHBya6
         XP3ltTkpBF9lcl/yL0SiuCiGISU9dgDPfKMyiS6G1SNzxVtt2QlQSxGtEhCo+7RHg8mo
         Ok+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791620557; x=1792225357;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=leU69vU0901atm4DuawOU09rDiJ7Q9eEEaM1dv12Nfc=;
        b=nBXG2iS04Yjj3BCYOh46/BvpOBKPdTpD1DrEhjJ4AqfqvBwSjj/Dixjga9BlM4zld+
         nry+z6Mkea7HHXeTPfuxftWMG+7H59nzKk4ZahARyrOJPCJKe/nURsb7eA/FfjTZPxNE
         Hy1jHCVZKGtqSfyIe+4f7u5bpbGUhYHOU/kiBnDBcepUwcmSALAdLnNun0475gcUsKA6
         OyhxmoJ2Ftf6nVCCgOU1vixkwW/s3/3Fk2CU77fXA+vhOzTHAhL40qeEf2ZImr6Yd5AQ
         yqI+QDAIcp7SYnn+lZCYV3c4Hh55XPYZygRztuG/qn5eJkDSCdrFDsYIUTUV40jSVqbl
         cfpQ==
X-Forwarded-Encrypted: i=1; AKwUvBwRkt2/KJk+RaVh/DmAQoYjwcGmb3McAgt2g1kZdKZwM5YySRFYYaH+IItpMQzSGmhtew98JpI0mA==@kvack.org
X-Gm-Message-State: AFq9FYLpcfLRLG2u5OqLoE+uud2t9aNVgmskWwY4HUSWGvsap8XhA6qt
	ZbgHzeJ9aht/mWC7HLr9DRusAg09StxeAC0GQQ1/Ml3S8zmka5tZ/iyEIj/QyBrzYqVBsAs1KFd
	A10qQ8DY9rf11pqwy83jukwFaKP5PVFY=
X-Gm-Gg: AYBFou0y7p/AgWcM9BS1U9VtZCw9AYVJpOUxGR4YjiR1uWnoB3bUuhn7oDtFprn+DFH
	leCxrjMnmkYar7sWKKUJMGQy/fqfVatX1iXgNNbY/cpNyIUUqUI4I5HtWudaQzVHiXo2vziRPGC
	KURe7gbfayJwPFzAjzJ9XwUFAf1ZdETuu3340+O1TKcR5FGzRJuzsLrUh2TTwwel9I4PVBvUT78
	OD0/1xlMtRCQ82fa6Ndi5OWUzX0I+sZfVh9HTsZXB8KFK7OQ3SFvVrpCin4Wthocp+oNLu05viS
	NoXnk3IYw+o33XqQgVmUXGlL13Jn3xOXGTyc2M9k1mpECOCmza6t8y4=
X-Received: by 2002:a05:6820:1f12:b0:6cd:3fbd:1d6d with SMTP id
 006d021491bc7-6ef137a1e02mr2955151eaf.87.1791620557289; Sat, 10 Oct 2026
 01:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260726212812.89266-2-shijujose2008@gmail.com> <20261005235021.GBasQ3vXTivT3NLbBq@fat_crate.local>
 <asU7svV8g2Hb5DZl@hu-ashoraj-lv.qualcomm.com> <20261008030603.GAascImzt4cv8Gz49p@fat_crate.local>
 <CAG4KcRLhN9=6xeT4qfqKLFdukiZLUc7akGcWwXJUU1-qrfxTUQ@mail.gmail.com>
 <20261008174114.GAasfVutvsmAk8JGsD@fat_crate.local> <CAG4KcRLx69BK+aw+exUzPe+BW8exFM2LLvN9pEr-+1BoGVhFXg@mail.gmail.com>
 <20261010002159.GCasmFJy2F_2S22d4Y@fat_crate.local>
In-Reply-To: <20261010002159.GCasmFJy2F_2S22d4Y@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sat, 10 Oct 2026 09:22:26 +0100
X-Gm-Features: AclHuK9LcUUipyZ8Cr0mybpgES3o6Alw16f-sgFH5JuXkDfTNuU5e-v-mN4o-0Q
Message-ID: <CAG4KcR+xR8twgQdNABptYZDXXC3BUMNN=-7twEzRTOiz=VngUQ@mail.gmail.com>
Subject: Re: [PATCH v23 1/2] ACPI:RAS2: Add driver for the ACPI RAS2 feature table
To: Borislav Petkov <bp@alien8.de>
Cc: Ashok Raj <ashok.raj@oss.qualcomm.com>, rafael@kernel.org, 
	akpm@linux-foundation.org, rppt@kernel.org, dferguson@amperecomputing.com, 
	linux-edac@vger.kernel.org, linux-acpi@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org, 
	Yazen.Ghannam@amd.com, mchehab@kernel.org, jic23@kernel.org, 
	linuxarm@huawei.com, rientjes@google.com, jiaqiyan@google.com, 
	Jon.Grimm@amd.com, dave.hansen@linux.intel.com, naoya.horiguchi@nec.com, 
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com, 
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com, 
	gthelen@google.com, wschwartz@amperecomputing.com, wbs@os.amperecomputing.com, 
	nifan.cxl@gmail.com, tanxiaofei@huawei.com, prime.zeng@hisilicon.com, 
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com, 
	wanghuiqiang@huawei.com, ashoraj@qti.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 63da96fxek41qtibfqpwjy9jk9znsipt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 51F64A0002
X-HE-Tag: 1791620558-102807
X-HE-Meta: U2FsdGVkX19FcnTRojRfoeMtPNoMIxH/WQtHo1VVfKGhQ6BsPEyjVDR+xe7d6ULOukN4bmWJszfTlROvMtIpcNJx3ndYVRA9HvpHedtLUbw5lJ1tDR0dxTWnvqBJcaeMVQBAl91UkuczLlqOQrgKYSKeJTfEgnaFi5xCsOvn9NXtnQFSFM32SUtdWbCqKZOCKDikqjljqH/03mnsQDvRmxmcLiekKSIqT+MzUrGt/fVnTzdYFoeXDt4iBY8miPzRq6AZJOgygz4g22CgvTOtvl5FII5txGHrMvhX5De2sKGLJsdugXbio8BiMPYfVf4BiLn1/0ca/fN+cCRGaumu1QW+EjkdWWWN1mezcVnrLEGKe7IC+k/3SaPDOKk4hiYlt/zyLvdOt2rF0t9A6O15tORYs/IBsKTB2RwomJ724syCsxeM7IMMLf2xmdgMwScvzEb5ZG9JIY34vWwp1JbYsBFN0iGp1g8YqMuIn9nPFt9kpdgN/qg2hVhxF15e7iicIpkOjLNlvx8Bw+JfOUpxwlZuSw4EoSKWOlYOuZJofHxLx7oOlHRuelGzSUPBXX3ZXM7D7pe+LyxLF4VzA4+ZRzIL9s1IVXrPq+657fh0WnmSF5XL51PYjYNhqDfdhE5H/ZXtC1KxnvJF9uMVKA2ZCmbULxPdHLIUMICUi4G2/EHwphCtGDHA7qiiUVvhKbz0tGDWSIFcwDWmFG6Rqsdn1GzI81HjRtp2H5Lb3P+JRNpWU3AsHn8EayNQzy02II273kY8bIEKdPPjVEFGkDgOOrf9wf767Rg+atg/BG3K7z8dDKkyU5ec4HfG/u9DBZoOwwtOrsnOpNMbL9E/CxYOSVPsDMTx61Wf/dsQeHQek8vkVgvAj0bht2VKDoELn8arRA7T+CDXYwXjYbaMRzSO+kDMYYqO6M5xjGd+rykqJ0ZbbVuQPyLG96ofUrvgRxMpHS0LFSOeg6yWDcCY2T+
 ETZfrwHM
 TNgcNVw1HPgxTsG4Tah1VQ9fkyhfo8tm7hx9+1fxEYy8WK/IDzsNCdgbwHhzyjMEQP8QXSmzkoc0KoZmCg9iKuX8qrbbMdDWPvJiepvlpaiUuTTVzFwgHbfJ1sqEuROdUyprNNnphUentXgoydkAsBkIoKjI/sIZTq/Xrcfmg7iSAhky4PISFMI1rvErVMvFXnoxOXPqVfutatRUHLtr0iTHo65x8Uxgx/gjZ41nKyrr2u7CHG8vwd/86aERG39X7lU/8k6h8unb4xt0FsTyn7wxGxK4y+gBklwM9lqh9nDJcmSQh2kEVBJM4Gj8sE5Z/Ox3tqXqk9LAEvCLHfzHCrt8MeYnnUUl9O+PVcDaSmX+fH2RpkB913T6aKR8kolWbQUzQFBSmb+q6VKxczYWNmyLpVYhXlPk4EAoomlOUBRB6u1Yo44J8TTaX0jemDsDbze8zPLclLmR5d0/0EqapIWNO+cSwkdIyHGmRuyt8k95p3yiPC6ZNRv4ykBHqWEWrs2bkv2iguOloiw5hPzXDdu5zqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 10, 2026 at 1:22=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Thu, Oct 08, 2026 at 07:50:07PM +0100, Shiju Jose wrote:
> > Sorry. I meant the issue occurred when setting the PCC signalling mode
> > as polling for the RAS2 PCC
> > (In include/acpi/actbl2.h struct acpi_table_pcct: flags).
>
> Ok, did this:
>
> diff --git a/drivers/acpi/ras2.c b/drivers/acpi/ras2.c
> index 24514e2b99e9..c214e40355f4 100644
> --- a/drivers/acpi/ras2.c
> +++ b/drivers/acpi/ras2.c
> @@ -304,6 +304,13 @@ static int register_pcc_channel(struct ras2_mem_ctx =
*ras2_ctx, int pcc_id)
>         if (!sspcc)
>                 return -ENOMEM;
>
> +       /*
> +        * Make sure the binding to the mailbox channel switches to expli=
cit
> +        * ACKs so that ras2_send_pcc_cmd() can issue the ACK packet with
> +        * mbox_client_txdone().
> +        */
> +       sspcc->mbox_client.knows_txdone =3D true;
> +
>         pcc_chan =3D pcc_mbox_request_channel(&sspcc->mbox_client, pcc_id=
);
>         if (IS_ERR(pcc_chan)) {
>                 ret =3D PTR_ERR(pcc_chan);
> @@ -327,8 +334,6 @@ static int register_pcc_channel(struct ras2_mem_ctx *=
ras2_ctx, int pcc_id)
>         sspcc->pcc_mrtt         =3D pcc_chan->min_turnaround_time;
>         sspcc->pcc_mpar         =3D pcc_chan->max_access_rate;
>
> -       sspcc->mbox_client.knows_txdone =3D true;
> -
>         mutex_init(&sspcc->pcc_lock);
>         kref_init(&sspcc->kref);
>
> ---
>
> Here's the new version, pls run it:

Thanks Boris.

The new version tested fine in my test setup as well.

Thanks,
Shiju

>
> From fb7d2f51280072c266441b645c81258553f1c968 Mon Sep 17 00:00:00 2001
> From: Shiju Jose <shijujose2008@gmail.com>
> Date: Sun, 26 Jul 2026 22:28:11 +0100
> Subject: [PATCH] ACPI:RAS2: Add a driver for the ACPI RAS2 feature table
>
> The ACPI 6.5 Specification, section 5.2.21, defines a RAS2 feature table
> (RAS2). Add a driver supporting that RAS2 feature table and which provide=
s
> interfaces for platform RAS features, e.g., for HW-based memory scrubbing=
, and
> logical to PA translation service. RAS2 uses PCC channel subspace for
> communicating with the ACPI compliant HW platform.
>
[...]
> +#endif /* _ACPI_RAS2_H */
> --
> 2.53.0
>
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

