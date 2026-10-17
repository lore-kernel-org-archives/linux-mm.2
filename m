Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D29DFCC6B2A
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 04:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CCFE6B0088; Sat, 17 Oct 2026 00:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 758686B008A; Sat, 17 Oct 2026 00:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FC86B008C; Sat, 17 Oct 2026 00:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28DC96B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:22:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BA6D8020C
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:22:53 +0000 (UTC)
X-FDA: 85330822626.20.DB8BDAA
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8751620003
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 04:22:51 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=GqdIvXw8;
	spf=pass (imf31.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792210971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMn+4/ls3haDvnV9MZGT8OnYkW6GFPmivRBk6vudyGg=;
	b=A+7EoQrlHB5D26XADl4bdRl/4pBe+JyHtxrmBgYl+41POcsXrYJlTPYmoLQuaEm3GHHIGb
	XsHith6xD/Q++8zpZV+xPz5JfguZr+ovdkBZvRquFQ+r0a3wmQwXytjMFoFZKiQZ5vaQkd
	dSYeZVr6QnP7FJgkcJ2xZDQ3Jz4cIF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792210972;
	b=royauD1JDTC0y5lJ1K+jQxlaizhM0qS/lk7HLDPfQdxQnnzA/+1nV/x0NIIEbMC4lyxSkO
	Iu+Z3PQA7Ov67XSkV6fpZz47qaEnunLlTITeAmFo58xjngiazvn7VAQn55kn6czajcozWF
	e6KfFVJROG3hq5riyJ1PeUv4sQrzm9o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=alien8.de header.s=alien8 header.b=GqdIvXw8;
	spf=pass (imf31.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 5F26540E03BE;
	Sat, 17 Oct 2026 04:22:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id TUYCDTo08E0I; Sat, 17 Oct 2026 04:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1792210965; bh=kDZQQH7hqxy27MFGHbhtcoKGmXL6dyq5YBHj2HXhVsg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GqdIvXw8GTcynBcaSSC/jLrsVdzfNLOypcTTmoIwMf4sELi6zAZUEq4RUL7XO9Bdi
	 INSw2oxapHOv8JbF1PLl5soo1PDG3N/iOeI9YwzyLwCxNz49ofvnllEmK0CH5A0Omf
	 qhLRS+KI1XsQSIFc0G3UpzgQ8PghjJYGVchptViY07Zmc5UwyuvTkTAoZ5vxZBaGcf
	 5mSDWvNBC6EfMgkQYfASvtkS20GTucP7ZD8b7Xguil5cuovBsJcioh8LnvPN61e8Eh
	 VxMHFHEMn9Xe4IrDDSJECr0x474sJskG8+ZvZY+o9Q9EQjzn/iYPX6aEv14opfDXUr
	 9W9MUV5vjCbCFhVApkXOYaI5EhZjmNMeP++uiI/BbAJ3GvG5oVIoGcvMRr2T8bWHFx
	 QGEq9SbkwSRMkBQWykPO+OXotKuPWoo4pFHQRv6L/sf3kjsEtJTP0pQpSRIhdTGpxW
	 hacx1YYlDs4iVyTz5UXdxbZu/pZxrJj+ED6rhLq5cbAcNOBNhO9yuwviFagaMyVFbR
	 7SqDUlNhzLELw24/JqoPGRxXkDhAg3D4TeLaj/zOQrZKKFng+ChN8Z8pPy5v/Vsho6
	 ixdTKO+Zns8y1Rg3Ae24/T6z0Mk0b4/ODtaBCYZHWhfGf0LpaHYp5AligPDxps8vTB
	 1gv5ItyVg++gFtiJQrOP8WBY=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::3a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4471840E01B4;
	Sat, 17 Oct 2026 04:22:08 +0000 (UTC)
Date: Fri, 16 Oct 2026 21:22:04 -0700
From: Borislav Petkov <bp@alien8.de>
To: Shiju Jose <shijujose2008@gmail.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, rppt@kernel.org,
	dferguson@amperecomputing.com, linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, tony.luck@intel.com, lenb@kernel.org,
	Yazen.Ghannam@amd.com, mchehab@kernel.org,
	ashok.raj@oss.qualcomm.com, jic23@kernel.org, linuxarm@huawei.com,
	rientjes@google.com, jiaqiyan@google.com, Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com, naoya.horiguchi@nec.com,
	james.morse@arm.com, jthoughton@google.com, somasundaram.a@hpe.com,
	erdemaktas@google.com, pgonda@google.com, duenwen@google.com,
	gthelen@google.com, wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com, nifan.cxl@gmail.com,
	tanxiaofei@huawei.com, prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com, kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com
Subject: Re: [PATCH v23 0/2] ACPI: Add support for ACPI RAS2 feature table
Message-ID: <20261017042204.GAatL37AhysV7BZBod@fat_crate.local>
References: <20260726212812.89266-1-shijujose2008@gmail.com>
 <20260807055952.GIanV0WDlB9-eP9VdV@fat_crate.local>
 <CAG4KcRJcpLREkbmOEEw7nGD+_PNOd+fWHkODqfWo1M8hmxA_Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG4KcRJcpLREkbmOEEw7nGD+_PNOd+fWHkODqfWo1M8hmxA_Bg@mail.gmail.com>
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8751620003
X-Rspamd-Server: rspam08
X-Stat-Signature: 91tfaq6wyfasj6utnmdurt1qgksk5yks
X-HE-Tag: 1792210971-523350
X-HE-Meta: U2FsdGVkX185XwkSFVvLASovrRO6PeiHjJEQ0YEPa3ftj0+7RDfg3PDqsjFV1MbdICzXmH9PpmEhE4N1P5BXhqPTvUEO5x0HQ2qbikcerbxFN76b4w9z33t+TGghkSwfp1na0tvxi6U4F+Axu8gqEarYltdNd7E626LxILow6MVM+bgKFdX70rKXlmWESB8ZP8oPp1nAzZ0XNxZdyi7fpLX25Q3aZGcGwKZWJySi8HGab9eEwrugbHP66J7N8LImdhxb6P4GVLfoUZf5a8T2JaSlyH7PJsp/7WTp49WYsg3P7SXDA2WvDZJEkJ8YXPQfEciaZ+or6XXmqVq+PV6Bl8MUDWIw0gOz0V9EE1884Djfb2RP+TlX5yd5bfWvdv6tZb0/KY0Wgzvza2CHZz9bEmTB/VnyY+yYTq62c6Sd0/z//PcXs95f/V4bL5rJga4CYaC7y+xlB4P0NgfdWk79BcCafce0BUflYaxSugYaPOkGqM70DcltyoB8IvtwkwN8yveGn4vQ+GHX08uwjwbwf9Pr0zVDLk9lEhg2YTVsa7ltyEiERQLV/ivu1DQUK1v8U9RNltRPTjzbOogAKNyaIGarE5dpmuarAQ8cTx6s4/oTIhpXbO634EvKpzoPOpkpdQqs2ZMXyn/V5uUS2WDPstN94BcA/yFiVhTyAhG0tFgMnhVDAlEDE2UxnFtgYuzuTrWuKFNxPwcN1ycPidxO05YcFciYYjEvVFjHcM5POjS69vdRIIolfZgrnG2nRUqIJ/JKFZWWLQlo2BApVbhnKirWE39NVCDnP0KJebL7MrZ+5ubSw212kKCmlooV00Q/k/x1M1eVegyXqBRaFUeL0lBaC9BRBIo0Yh93oTFdlL+BSMh5HPSi4OnwxXm+PIF8cODukGbJhBmeb+QhE1ez3KWid45BtdcN4KPy8hKgmXRzlzY5hAeWNrNRk8MAZQefrEcxqhjUGt4CnTq2MGR
 1ZCsBffP
 y7fvOiuQadViH6HkWSctMyl0V7sem3Uz3J5ucuqSL1ZfFYsh69lCDnI/RhEJG8eB7U2dzE6bisTyG8r7/lecbTrhfdqJ0XUZDExZmDXS9Iy8J1mNAY2Gt3odoJE7qZcIx00HQ69MqHP6gdcuWXPaLvuuaS9WcoZsjxeh8BxYddgHPrFP9zP6QlqZhTwXWjdVCII585OqSy/gqrRbes8WAd1UNx6ObBQvkzJPfmjqVWI59EV9GN2NElad09NbVTClpxUij4TGF2Vnb9FcKO2d+yq8dt0onfW3tHpwickNg/32b+STnL3DL0aJ8/pt9jJOB8N8ipn5kCqpIElWu01XE3oMJgrSt2y2/Wy9NtgO317U1Hy+XBMKzs4yPrN0OCfmxeoqUsWB1isBlEqstxVUFlfeH00ydoe0zp00kV+z8+8jjhmkN7DZLjyvQXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 09, 2026 at 05:21:35PM +0100, Shiju Jose wrote:
> > +static int ras2_update_patrol_scrub_params_cache(struct ras2_mem_ctx=
 *ras2_ctx)
> > +{
> [ ... ]
> > + if  (ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING) {
> > + ras2_ctx->od_scrub =3D true;
> > + ras2_ctx->base =3D ioread64(&ps_sm->params.actl_addr_range[0]);
> > + ras2_ctx->size =3D ioread64(&ps_sm->params.actl_addr_range[1]);
> > + } else {
> > + ras2_ctx->od_scrub =3D false;
> > + }
> > +
> > + return 0;
> > +}
> Does this logic misidentify a pre-existing background scrub as a demand
> scrub?
> If the platform firmware has background scrubbing enabled prior to driv=
er
> initialization,

First of all, when and how can that even happen?

How can it happen that the platform has enabled background scrubbing befo=
re
the driver loads?

And if that behind the driver enabling is legitimate, the driver should l=
oad
and ask the hw what scrubbing is currently enabled and mirror that in its
internal structures tracking those settings, right?

I haven't looked in detail yet so perhaps you're doing it already. I need=
 to
clean up that code first, though, because it is very hard to read.

> ioread32() will read RAS2_PS_FLAG_SCRUB_RUNNING. Because
> the driver's internal bg_scrub state is initialized to false, this assu=
mes
> the active scrub is a demand scrub and sets od_scrub =3D true.
> Would this prevent the user from controlling hardware memory scrubbing =
via
> sysfs, since writing to enable_background might return -EBUSY and
> writing to enable_demand might return -EOPNOTSUPP?
>=20
> Shiju:  This is not a valid comment.
> Please find a description from the spec.ACPI spec 6.5 RAS2
> Table 5.87: Parameter Block Structure for PATROL_SCRUB:
> Flags (OUTPUT) : The platform returns this value in response to
> GET_PATROL_PARAMETERS:
> Bit [0]: Will be set if memory scrubber is already running for address
> range specified in =E2=80=9CActual Address

Which memory scrubber? The background one?

> Range=E2=80=9D.Bits [31:1]: Reserved, must be zero.
>=20
>  ioread32(&ps_sm->params.flags) & RAS2_PS_FLAG_SCRUB_RUNNING
>  ACPI spec 6.5 RAS2 Table 5.87: Parameter Block Structure for PATROL_SC=
RUB
>   Field: Flags (OUTPUT): bit[0] - returns status for demand scrub only,

You lost me here. Where is that stated in that table 5.87?

Confused just like the AI :)

The rest later.

--=20
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

