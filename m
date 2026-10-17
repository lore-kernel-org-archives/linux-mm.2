Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B342BCCF2C9
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 19:16:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C236B0088; Sat, 17 Oct 2026 15:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D1A6B008A; Sat, 17 Oct 2026 15:16:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3C046B008C; Sat, 17 Oct 2026 15:16:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 748456B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 15:16:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0559280310
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:16:24 +0000 (UTC)
X-FDA: 85333074330.28.23AB2C1
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 114B6120004
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:16:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H0Fi8Mwm;
	spf=pass (imf29.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792264583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3kpX1qw8aI9g0XRNJfIyX0LLMiylk567EvCY0vBBCeU=;
	b=gZ2oaElLZiL7sxqNZARO+2uGQfH4gZULJZqPlXd9FIDIEE90ncue+cgJAxPkjYBYwm6NNP
	YsQm9ByFBhcpcDpwjBeza9WI3oUO0fjroOvG3+1AfNe2p6pHo/uE/08weJvK2IEY1RgOzt
	KCbiixWAiNmlv1CU22AxgVz+LG0Qvh0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792264583;
	b=Wo5VL0Duz4+YrwhGv3JJzyGovoNpIVh3OodsyDHMpIQC7mWq0g4r4HEWssy1iRU9Uvx8GV
	ih8Tyi5VVNJSOMC8cT81mkzISSuf3L9cxpEx9XeFJcvG9qctGugbhYexUFrOqiMN2Uzi6V
	fMC09oKeZYwkTlL+0RuICV4J2ELudag=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H0Fi8Mwm;
	spf=pass (imf29.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6cfed5dd083so652617eaf.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:16:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792264582; cv=none;
        d=google.com; s=arc-20260327;
        b=ObIryIc0ctpCSvKfHQfTlx2QdTzjQjC38VDegEQzi+DbXEA+F7IzdGWF0C+q4BRNzm
         Y5PA59u6DR8r9kXxBtgKcvQxOZvqUSssGS5GzRXXD++2sMUJm8jVmAuWYYDLewZn4yKL
         3H/1CDiVPbna2dzS1xEKhuAFkiXlNP6maDpCrdR8aeA4J/SMuGRjVDFJIxOedwP0Wu4r
         QCes9k+xVv71a7djNwUn9sU+FAxt3fB0rLZGPUKyMZovFQFmimfEbFrOO8p/nrNxP/QE
         QRXg9/G+EhVvhHCeQfZgifeUmazhmHqhvF/S6Ip76d/XSK4L1kvuS1CYqx5ZZG75qMr3
         q9ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3kpX1qw8aI9g0XRNJfIyX0LLMiylk567EvCY0vBBCeU=;
        fh=VB8nzna+4of9eoXXaswHD5o4HbRcQbRS5WjMevpkgbs=;
        b=OvP7ml2i862VczhNbs+FL/FvCzx4FWoNbLhnjiPPMg2LS3ObyPkXilm0PJiAKXLIsb
         MtMq/7ddUFRk/ysemCbZRAynl1yyrZxkHCs2nNYLXNxHH3C/9kkjWI7g+SLLN3S6/JMm
         9ysDiy1kDkRRMgs803k0li6Uq+LI6vgkqnW+rh0MwJOc9rRvsPqs6I/re+fG+a74htVo
         fwCQ+/DtZtJZfblMWxfEu9DzS7h3IJSrw49LniM7KuZLNqn4EvEigpLoz+WqEWwDtIo7
         pEAymeLpFk9UKvNgUtGkBLU0OkGfEj73R2vlKU7vVnT6KaSfm0V4oCv3ZM3KBOH8rK4J
         JDZA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792264582; x=1792869382; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3kpX1qw8aI9g0XRNJfIyX0LLMiylk567EvCY0vBBCeU=;
        b=H0Fi8MwmP++ytCs+8IQUUwUFcWMYQ5vaXkNiwGNX7/WnZkdIE32SkCaaJc+IpKYJop
         NFpK8S/lsj6QsC0HyCX1Wv14MlrBip+AjT1ast1qHk+1vc9caLlUpcWPFEg35GT5c8r4
         3DuBTEIypa8k0aHiNqHgNmxDCmh9Odt2nMrGdQ7hO6OSZ/vpKEzE25WMEiIzDFa/rFfy
         aG/buLe/ZkfPIE4cW12RVDdbMvzyl/ik5nnXwY4F71NRJlOJBMc9jrARZa6PnHG3B3lw
         uVcjfHhDObve23E2vb0W6Dkvs+nFV66EKn9HURGQo3ty4H2nfZJai3YSXjQl78cwpT0F
         CQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792264582; x=1792869382;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3kpX1qw8aI9g0XRNJfIyX0LLMiylk567EvCY0vBBCeU=;
        b=aBTKFxurbyfsWspYbe9nBgouw17KL+dvw1RuXFxmFLgpaclrIq2vWpClip05XY72e+
         lukuqUaxqHNfgs5TcLoNojBkLsGIw7ACsi/JMSewfJTJRMHf9ctBHej4VsmZ3PIXSR6R
         aMkBKsY8r/R3evVfZK44stfwEfPeGkklHWTQFGfw/PGg35hw87gfFRq+AL9Cn/QoKqBh
         FydfQkAzVB0/LWEz8O1TIurouRVs9A2KSWS2jIx2hIhSc4BY0sQfKGKRk3/BdNt9Yr4Z
         HYilCp2PzPCbWrnoJMWyJ0TBqqcpmlJz4Yloq91QexQYNF7eUggfMcv7wvkq0nZRSVUs
         cMJg==
X-Forwarded-Encrypted: i=1; AKwUvBwzDFMGGrVlp+SAt6BSN/PasI7HRYWDDY9GGlYZ36fPmtHVwUVWfqsDCM2GIlKoW5iTFuJMVu6JVw==@kvack.org
X-Gm-Message-State: AFq9FYI0WAjBgn65yzYc+4WcXfUBWZAFkm2MjNjLABztxMkyX20G2Hy3
	+3z663ItkzOErBtLY88/MPhZqAAQJ3lZCGkcP2Bkg9yFe15crxq5pEJc/4/qWHbksNyoXwjOM6P
	IvY1xd3v3/bFk1BxfGAknzO5lrn0ixZM=
X-Gm-Gg: AYBFou3MowCjZPBVA6ojsh7frhsuqThTfu2gEMaHTGE6ZUT11Go/h0FJUO1wYwjrx11
	zO6d1jrd+1t6lSssw/FOj/SJbOYu5bu4vEP4UGv6zrAumy6CA8YZTZwYQBWXdUiietUs05McldM
	mkgTjHMy1v5zGz64JHIscYEt6gS1JgilRXwhi/BFDd2mDclYjo8DfoDnXAKqaDY/IS4S/sLd6EM
	FguCECLFFn2k/cIhppAxSnqTM4bOZc/SYRRJx9EDir8DXsbmSaxC3vZt5qLJdVJnqAZZMORbOPS
	LsgEVhPANGiItuWwaUolaM6R9hUcQyF3JU2ntilLYTjmsw+COUiK5mA=
X-Received: by 2002:a05:6820:208d:b0:702:96cf:69ae with SMTP id
 006d021491bc7-70357f996a6mr2222268eaf.73.1792264581908; Sat, 17 Oct 2026
 12:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260807055952.GIanV0WDlB9-eP9VdV@fat_crate.local> <CAG4KcRJcpLREkbmOEEw7nGD+_PNOd+fWHkODqfWo1M8hmxA_Bg@mail.gmail.com>
 <20261017042204.GAatL37AhysV7BZBod@fat_crate.local>
In-Reply-To: <20261017042204.GAatL37AhysV7BZBod@fat_crate.local>
From: Shiju Jose <shijujose2008@gmail.com>
Date: Sat, 17 Oct 2026 20:16:09 +0100
X-Gm-Features: AclHuK9ltyMIoKi-tNdGjK3uKrWCnIWl5RP71EvNz5XG4osLNZC_K9K1LqvUxuM
Message-ID: <CAG4KcR+9mHBBOpAw=_kN5Smd+KNCA=5-Fd5nkFgVRi5XC7Yf-A@mail.gmail.com>
Subject: Re: [PATCH v23 0/2] ACPI: Add support for ACPI RAS2 feature table
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 114B6120004
X-Stat-Signature: s3kksu771yrwss5b4fui7pdysqcyydpg
X-Rspamd-Server: rspam05
X-HE-Tag: 1792264582-965515
X-HE-Meta: U2FsdGVkX1/wsnWoMTjHyKVD4N9WXxZzj0KXkLJkmDX9kOyV+EIv8Ox3rWhpY5Yps1At6TX2eNS9ffl2Yg9UWjdczCd/0ZfZqriKPK3WAnbUNhXurCAJbTlOVR9M/Ui8DtQNwIwpB22fa69iBm1UlIbkQXfgRsI+SBMp4XGAC+Y3DxnOu0YeslVWlx3uMgnDrL9lIXrKmlfJq1ZwN0Me4V5RB2SScYcIB61uoKfQqktbkXC9Zpi5ZMalBg21ar+qxaEqOC5YrovD/6mwTqTPF7FPNtmINY3Ufu+XGWWSyVV5pfR1wf261SiiHl+ty196+8BQvh47BDzpsTOXa/9Oi6LwFQq7EkmC26aDPdiiU5EFJplpvUM7W3QGHT1da9qK5o47rh+ZLTxKPQrVEsXWIPp7qDKYUljSULpgaDS3Cv02przJb29pdIFEyMLkD3M0HXOhQtTsdSHxFaEU4yQk2Xj/8hXDh9DmnPXIyfJduxMzYyDM1HuB3aDPv+qfIaKYW07v6AFVF0KoLCy380Z2iitB8Hvc/BV5nXkgLK+++ARhutoHflbf46ufb/yq2iNCveWAWlNbhejyYZPDlFGpaWTPs63Gc9XCpSNbP9dz86E1OmqmaIgXgxe6ucx1nY454g3+IJJhji/tsAK1J/UDdBBQGIfSqQ6ldbHNYXAFNeOW0XKw3mjPIujDxCPU3cqbfrwFBz52tZPmNE/OXun/ubdO6ADikgXOuqoO5Q/0lOYPzDmgUdlJyBBQj/36czACPf5ewMX0YP2K+owmApbJnawsrL6X/AIZPKX6xC+QfqCNeYrZWRgHXsKXFb5an/F0RIm5xlY90pW43ZBgPNcOwNP8Tifuf23LVVgxs505BqCoyUSFoJK5o/lQe3FhN2hcSLcOMmmzBUiIzcS+V4rJ/NHNDqokQ8eWp0NlTeL45DnY2NsrL4THowN1sR7CoprXruiMqA6yii0Z0ZetzpO
 ucjZGOFN
 8p8+7mrLlle3LiX/m73girooIoPXTq9VnGXwNmNKW/Cs+j29xkopyy1g3xpN9AJZb/EwHRf3WqHz45zcpmjyjimdHKmfcPmKMzzKj+gEy7ZSUPtugWLl27eVsqZwe9l5CHubvPDjx3JCd9ZLoXMQIUVXo65yCMSAWnHprACV1q70I8ZFRBvQ3//sbNTKKqKTP+V/Q0tHtAEjQjwu8O5QlKKoPj/SfFojGKAhSCDSTQbubptzXJql4i/7mwLIUiyMpneQdqWiEUcp/xK8IViCiXoUW8VxT4ZPBSC2+F+kqExYFyjbO4FMyurQUWKMV3nTGuQTEe/OwtMby+ed+L3Kk8ebw+/ZtlxkcsOKVkwnzBVeG7aBs+XtgIb0rDVzq5Ff0N4QiFP5Dvv5+QiY6lAb6dWHUFrudTPhs7ihZsFtAbirSlS0enkb1xj6el4jC75CUwetISpgns66RjBIc5bjKpmMCk+x8WqyK+HXe8W85EHbGsnyhovzEThy0bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 5:22=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Sun, Aug 09, 2026 at 05:21:35PM +0100, Shiju Jose wrote:
> > > +static int ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx=
 *ras2_ctx)
> > > +{
> > [ ... ]
> > > + if  (ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
> > > + ras2_ctx->od_scrub =3D true;
> > > + ras2_ctx->base =3D ioread64(&ps_sm->params.actl_addr_range[0]);
> > > + ras2_ctx->size =3D ioread64(&ps_sm->params.actl_addr_range[1]);
> > > + } else {
> > > + ras2_ctx->od_scrub =3D false;
> > > + }
> > > +
> > > + return 0;
> > > +}
> > Does this logic misidentify a pre-existing background scrub as a demand
> > scrub?
> > If the platform firmware has background scrubbing enabled prior to driv=
er
> > initialization,
>
> First of all, when and how can that even happen?
>
> How can it happen that the platform has enabled background scrubbing befo=
re
> the driver loads?
Firmware can start the background scrubbing before the driver loads.

>
> And if that behind the driver enabling is legitimate, the driver should l=
oad
> and ask the hw what scrubbing is currently enabled and mirror that in its
> internal structures tracking those settings, right?
Yes .This is done in the ras2_mem_drv_probe() by calling
ret =3D ras2_update_patrol_scrub_params_cache(ras2_ctx);

>
> I haven't looked in detail yet so perhaps you're doing it already. I need=
 to
> clean up that code first, though, because it is very hard to read.
>
> > ioread32() will read RAS2_PS_FLAG_SCRUB_RUNNING. Because
> > the driver's internal bg_scrub state is initialized to false, this assu=
mes
> > the active scrub is a demand scrub and sets od_scrub =3D true.
> > Would this prevent the user from controlling hardware memory scrubbing =
via
> > sysfs, since writing to enable_background might return -EBUSY and
> > writing to enable_demand might return -EOPNOTSUPP?
> >
> > Shiju:  This is not a valid comment.
> > Please find a description from the spec.ACPI spec 6.5 RAS2
> > Table 5.87: Parameter Block Structure for PATROL_SCRUB:
> > Flags (OUTPUT) : The platform returns this value in response to
> > GET_PATROL_PARAMETERS:
> > Bit [0]: Will be set if memory scrubber is already running for address
> > range specified in =E2=80=9CActual Address
>
> Which memory scrubber? The background one?
Hi Boris,

demand scrubbing. Please see the reply below for more details.

>
> > Range=E2=80=9D.Bits [31:1]: Reserved, must be zero.
> >
> >  ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING
> >  ACPI spec 6.5 RAS2 Table 5.87: Parameter Block Structure for PATROL_SC=
RUB
> >   Field: Flags (OUTPUT): bit[0] - returns status for demand scrub only,
>
> You lost me here. Where is that stated in that table 5.87?
>
> Confused just like the AI :)
Please see three fields in the ACPI spec 6.5 RAS2 "Table 5.87:
Parameter Block Structure for PATROL_SCRUB"

"Requested Range(INPUT)"  & "Actual Address Range (OUT-PUT)"  -
(Description) "If OSPM requests default scrubbing through Bit 0 of
the Configure patrol scrubbing (background scrubbing) field, then
"this field must be ignored" by the platform".

Note: This states that both "address range" fields are valid for
demand scrubbing only.

Flags (OUTPUT) - (Description)The platform returns this value in
response to GET_PATROL_PARAMETERS:
Bit [0]: Will be set if memory scrubber is already running for address
range specified in =E2=80=9CActual Address
Range=E2=80=9D.
Note:  This states that  Bit [0]: of the "Flags" field is valid for
demand scrubbing only.

Thanks,
Shiju
>
> The rest later.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

