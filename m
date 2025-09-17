Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BE8CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CD68E0005; Tue, 16 Sep 2025 23:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53B78E0001; Tue, 16 Sep 2025 23:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90708E0005; Tue, 16 Sep 2025 23:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8DBC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:30:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63881C03ED
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:30:43 +0000 (UTC)
X-FDA: 83897315166.22.0FFD743
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id CD02FC0004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:30:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Kry9SWYt;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758079841; a=rsa-sha256;
	cv=none;
	b=SyrBn313WZHgkvt6Y3lh6IT6aSRRIq3OJkGh4UJuAtYyntWEuW2KDShz+MJK+jXqOBho+7
	A8UNBv6w7Pmlu8jiPnfxrWSx9vsETESrPWIEzjTJlCqxd8c/gyXDf/Ykz4/bHCBfylwruO
	DKm4OJOZ3WxdELXrq47Y8bfSnUCJpmY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Kry9SWYt;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758079841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAVDs1VLham54ZqxWN+SHa6U1EiRrERwJc+azYqy1+I=;
	b=eOypaw4kVeEkeUskaLqeoPqkn0hrM1+OrnhZOSnuoctA6jxbO40itRicgvymXbIHDyodtA
	KyYRw4/Re6f1s4UlJZulzHbdl7ORQHJJ2UWXEUyeTDddIGwKI8MrES+5GJXUqnWT2JyVfx
	tH8iZ6ohIpI8rdUWlWz1mAv91YJDnKw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UAVDs1VLham54ZqxWN+SHa6U1EiRrERwJc+azYqy1+I=; b=Kry9SWYtgvdutxvXmjz7kw2FjM
	D4Mh+YtXTIKEFOeFDFrG/Bs5kNB2DI0eCiJBF9ohZNNXeq4rT2h4WQ0Mj5VddscfGpMjkhpwEzPP1
	k9Jk65lptDjMFQ1n5wKbUMNl1cixjK1hCGT6sKxuL8UM5OU/jEohuJWv9W9ps8HAFECu5rVSE9aH3
	GALfPULwTqOmjtJc4lj7X1HCOeVELOJdXDob2cfiPWUFqNI7Ats4xtjXF4GBCoRkFydXdbkBZJIj/
	AcIpXLmHIVtcxTGBJ2bxNRsE5RWsJ/lfck6GQAtXFo5td7mpCKI9ouhrnjaeETlwY/KZkNaKQ6hNB
	vWMBRKoA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uyis8-000000003qc-1Q3q;
	Tue, 16 Sep 2025 23:30:20 -0400
Message-ID: <190cd3842bc0776611c73a439e49ba57c86849d1.camel@surriel.com>
Subject: Re: [RFC PATCH 06/12] mm/cma: define and act on CMA_BALANCE flag
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Tue, 16 Sep 2025 23:30:20 -0400
In-Reply-To: <20250915195153.462039-7-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-7-fvdl@google.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD02FC0004
X-Stat-Signature: xbh9qdj6r3xa5rrqngwdu7i6sf5usaoh
X-Rspam-User: 
X-HE-Tag: 1758079841-581087
X-HE-Meta: U2FsdGVkX1+wEqi2Sdl9RWp9ifar4zXFrYhPB+5y8dokn2XqLp3OW4K3aSWi9cH1cFqtddVgV+GgmN59Jul4EMZx1kNkrrcC1yLSUL6SvKWaLBKdE0WeRyvRUHxXygui0u02GInXO20668AE/GJoWREDAZU0nj0+gevURgW7kdvpsU3UF7dZeBSm/q3rb5l1Ox2HqdNGnWyITkS0KKqSOGHnucaXfaHGdPQFQdRzsO4yusrBDTYdUdJtEghom/koPDVNd1p0FhLoYziUajmcB9y0l6uQTX/WAl8xAA9Rz4XnrB/VpH62g412ehlDKxiZTg4L1xZTKvPwSfj57dJk3GvLkJW8CcU5Y9VMPY9xRIO6WCY4C8Omk2P4gaE1blmymPna75brnFGkbohXW+rYqb1/lbZS+KDyHXXojWxEAUlhjDOJWyUeQBjmsqE7m1RMHesDQJlbEegvaUWOQ6HwsbhhaACNQA/XrOOSwYBJyn0TIeIcNdpLzRuN1vTi1wT7LfQsT22Iu68poBQGvletTBu5ZLyG2xpeBW0upZPQEh/pJQ1xNXsxotsLDUWm9KiuQwtlh/s/kSL1tsbMr/WVqVb3vG5LSOnpz0tKJ+0Ayq9kqSz5CfSDjC4q9sIKGq30tFyPl2HUZgmuYA404vP4U2FQ3pEDCMLnkPsfjDqlsnZmuOFuetCfarEPVWhKAZ3IvkKuzzHLm5srGReldwoZVI+RRCiTrjJm9ogG3azNtF1BZAxvqhbx4AFzvNCmUSFcX+tcxq8zxwOanbtw6iXjKXjy0aWAaUk9phhJanZcXnE2QEIoyeQmXpC8/eu6hB2H83qv+pmj3y9f89TdxwKbQmSMW6EkE7sTm07L+RS5DJFB0W1gDv4Z6MeGHJAANlysvuPnyF8+nc8u2vOASjuVdvu/7xAaVdAx4wVjWaMdwTOL8fc6X8PGrmM9X1LgVZH7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
>=20
> @@ -851,7 +862,10 @@ int __init
> cma_declare_contiguous_multi(phys_addr_t total_size,
> =C2=A0	list_for_each_safe(mp, next, &ranges) {
> =C2=A0		mlp =3D list_entry(mp, struct cma_init_memrange,
> list);
> =C2=A0		list_del(mp);
> -		list_insert_sorted(&final_ranges, mlp, basecmp);
> +		if (flags & CMA_BALANCE)
> +			list_insert_sorted(&final_ranges, mlp,
> revbasecmp);
> +		else
> +			list_insert_sorted(&final_ranges, mlp,
> basecmp);
> =C2=A0		sizesum +=3D mlp->size;
> =C2=A0		if (sizesum >=3D total_size)
> =C2=A0			break;

Wait, what is this supposed to do when presented
with a mix of CMA_BALANCE and !CMA_BALANCE ranges?

I can't convince myself this would always keep
the CMA_BALANCE range near the top of the list,
and the others near the bottom.

Also, does the regular compaction code pay any
attention to the order of this list?

I have the feeling I am overlooking something big
in how this patch is supposed to work, but I am
not sure what that would be...

> @@ -866,7 +880,12 @@ int __init
> cma_declare_contiguous_multi(phys_addr_t total_size,
> =C2=A0	list_for_each(mp, &final_ranges) {
> =C2=A0		mlp =3D list_entry(mp, struct cma_init_memrange,
> list);
> =C2=A0		size =3D min(sizeleft, mlp->size);
> -		if (memblock_reserve(mlp->base, size)) {
> +		if (flags & CMA_BALANCE)
> +			start =3D (mlp->base + mlp->size - size);
> +		else
> +			start =3D mlp->base;
> +
> +		if (memblock_reserve(start, size)) {
> =C2=A0			/*
> =C2=A0			 * Unexpected error. Could go on to
> =C2=A0			 * the next one, but just abort to
>=20

--=20
All Rights Reversed.

