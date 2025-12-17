Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3CCD6554F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 12:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771AA6B0089; Wed, 17 Dec 2025 07:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74FFA6B008A; Wed, 17 Dec 2025 07:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670346B008C; Wed, 17 Dec 2025 07:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 553A66B0089
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:09:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 024CC605D7
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:09:17 +0000 (UTC)
X-FDA: 84228842796.08.7771047
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 98F8112000A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 12:09:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHGkerYQ;
	spf=pass (imf29.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765973356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LM540hUb28P/6ED7eYJxPCmTteIjDKTHmfy1Ey7dXUI=;
	b=YB1uBaPwdBTte1S0tgsXvukMSezxICcxN9eG/euu7JspEIrNR4RSXWxwPt+QcEPV884Yvv
	ZxYPqri1PdnxmL64cpl8f4cC9GHTur7hCO4lGxRoyPqyK7CnvRxDFNO2LHbKZuHC0T4qW6
	P3Oeyam8dT0xUTHX7inzbumK33MPWj8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHGkerYQ;
	spf=pass (imf29.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765973356; a=rsa-sha256;
	cv=none;
	b=kc7H7nJOXC/GPNm/kcvBECzJ8b8BdYHdn7i80/W/O9IR5lhGZIUsl2U7pkHxX6reqzEu12
	ld+cAoa9T9SEpjbLw4Eo7oR59fjNgwe5RCE5p6Qxtt0ePhdmms5jt22jVepHuV6iiyhGor
	XvRnQrpfu9VylOggCr/lOCy6On/PDEU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C55FE60556;
	Wed, 17 Dec 2025 12:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ACAC4CEF5;
	Wed, 17 Dec 2025 12:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765973355;
	bh=XqkQNpF8ME1hBE+b0FBunoFr4flf8biZ9M+St65icok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZHGkerYQQpCZRqgTasBEJuRZlEi95UWbFNGNAP+ikltfrpTgTNoae+CCb+NS842NR
	 Nh0XnKWmz9EMIsQdCoPdJfG5Q5T/kK0s6XEyDh/flPZQfOisnWZnn6SFQA72hCdDJS
	 /xdVx0eZvGqOR8nlI2xDCykgnwq6PRZGnu4c6S3YI6KPBT/SHA8TuIT3HhZAf7mZIg
	 JdMPAgJa4vnqu+ZRPB1UVvhgTg+i1GU+HC+N9pP+wFUI0X2Q/TFThkv2yg2IOr6xXU
	 JqdpWlyzwFkJmz90DGyFFdMJNQ24qZa4tO0NC/ijz2DZKdrSNjIonLNOGPRNXGSBFX
	 PDyWtiBxgi4Hw==
Date: Wed, 17 Dec 2025 13:09:08 +0100
From: Joel Granados <joel.granados@kernel.org>
To: Petr Mladek <pmladek@suse.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, John Ogness <john.ogness@linutronix.de>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hams@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH] sysctl: Remove unused ctl_table forward declarations
Message-ID: <44x5syvqsqy4bfjdc5r5hfwhppz74vxa3p74diwmnlls26yox2@xccmzuov2afw>
References: <20251215-jag-sysctl_fw_decl-v1-1-2a9af78448f8@kernel.org>
 <aUFUIfVvRcYN3_ID@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hawgbyhlcibefy4q"
Content-Disposition: inline
In-Reply-To: <aUFUIfVvRcYN3_ID@pathway.suse.cz>
X-Stat-Signature: 8g86yy5e7xz9p9geo4urygf4agbif4tu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 98F8112000A
X-HE-Tag: 1765973356-294031
X-HE-Meta: U2FsdGVkX19mu/KUS5pexHBO0cqtDj2Uza2/pcS0z7eIDshiSAGe61LqBOLWLSVUhzQ8Eq7hFD1YlZfIUKpqEpeX9RVRSmnGo+EiCz+qIG9QkFYnq4/ntl/IG/cGgOJK9fpdzPq2RiD/KBWjFklHQofmOg8sy6VRxrOMdhVlu/npvO13jnZ0ghbAxdnbSUqPInU3Devxq5k3YD0jOdXPstrSR10fPMvs8sDWn1vELuir2hzIkbsocJ7rcM0c++F9u4JWK1BnqUt8SrvQlCPyuPMaboYX2h+etBCSW3m5/7KU59q3eWA5oXQuMaW9v7gCV01fr66P2C7j4KajYV237ci+eSPwgSXzPLL9K43MFEon8LBEx69qmxEjpDWoJwDb1WrBvXyaYNm1T7vwf5/1TH1VGZNhLBHpYx7B9DcUbKVU/ysKQQ/XKpr9NC0k5iJ7t+9oSZo96xBmjghh6XlxSy/xOlvXiTE8uVrZ8deejpbC3uDjps/v6oMVc+S59nHrNNO+sNUy2nrGNKWKb5g9lY53GVzw35IDpDrxcI5jNPKmjeXJsJgV80GE4KI8+knG5yDsMiEdV0M3feLkxJcF5eiXnxaDWneUplRuWefQnKulgvhuIr4fWQQl+FnA0r02XX8noaUHjfQPyRLH3GKuqaI0oL05DIcpFDErI21VKEBB9WiMCtoYHxTBep8YvYsu4hGcgBNNtXNoAdcGIoJNpwbgL/9/tjMIbvYt4PoclrOgLPKHzPKq08XPXEb2i344zIF/Zfnpy++gEjV3m0S2T2nYnzrU9lLQ0HOoMrUSS6Z4WiZSQ3qRMK9MkOcMOXOBsP/sl0u5boAxFrU5J99gZ4JrQQ5dV38eZIb9YKk8QuaX4CYqsl3TYnqHY4bHnC+L5IcRWVMsVAxfvKRxmYbaigQnwSIonpaWHkTh5+JdJlwIrKbYv1629q/31fD/GZbxnwLA8Lfj/IE3cAbzIUW
 NZsuIPfs
 5Jd/B4yJTChshrH+p+GJiWqXNR2c4D8k+vgdXkIm2mPURKcasksEBwFDpQ0o+Zyu/iSLBsgN47u++A2tRpYVs51ItnlFdyUxsT4jB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--hawgbyhlcibefy4q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 01:44:17PM +0100, Petr Mladek wrote:
> On Mon 2025-12-15 16:25:19, Joel Granados wrote:
> > Remove superfluous forward declarations of ctl_table from header files
> > where they are no longer needed. These declarations were left behind
> > after sysctl code refactoring and cleanup.
> >=20
> > Signed-off-by: Joel Granados <joel.granados@kernel.org>
>=20
> For the printk part:
>=20
> Reviewed-by: Petr Mladek <pmladek@suse.com>
>=20
> That said, I have found one more declaration in kernel/printk/internal.h.
> It is there because of devkmsg_sysctl_set_loglvl() declaration.
> But I think that a better solution would be:
>=20
> diff --git a/kernel/printk/internal.h b/kernel/printk/internal.h
> index dff97321741a..27169fd33231 100644
> --- a/kernel/printk/internal.h
> +++ b/kernel/printk/internal.h
> @@ -4,9 +4,9 @@
>   */
>  #include <linux/console.h>
>  #include <linux/types.h>
> +#include <linux/sysctl.h>
> =20
>  #if defined(CONFIG_PRINTK) && defined(CONFIG_SYSCTL)
> -struct ctl_table;
>  void __init printk_sysctl_init(void);
>  int devkmsg_sysctl_set_loglvl(const struct ctl_table *table, int write,
>  			      void *buffer, size_t *lenp, loff_t *ppos);
> diff --git a/kernel/printk/sysctl.c b/kernel/printk/sysctl.c
> index bb8fecb3fb05..512f0c692d6a 100644
> --- a/kernel/printk/sysctl.c
> +++ b/kernel/printk/sysctl.c
> @@ -3,7 +3,6 @@
>   * sysctl.c: General linux system control interface
>   */
> =20
> -#include <linux/sysctl.h>
>  #include <linux/printk.h>
>  #include <linux/capability.h>
>  #include <linux/ratelimit.h>
>=20
> Feel free to add this into v2. Or we could do this in a separate patch.
>=20
> Best Regards,
> Petr

Very nice, thx.=20

I believe it fits inside the current commit (no need to make two).
I'll add this and send a V2. You can then add co-developed-by &
Signed-off-by if you want.

Best

--=20

Joel Granados

--hawgbyhlcibefy4q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmlCnWQACgkQupfNUreW
QU8WIAwAlXDIVtCbnzQInz9B4QixLTMB7RpOH2nNcUQUwOUdE/qfX2Kbwu/dXjAy
CGdwiVkAQIKkjCQTarmTjAdefqugLsww8q1am99VByg9gmupsvM/F2u8y0rFXzoQ
pgWaLO4o5L+U6yyp+vXV2g0GKtNZc719cyIncUOPF3Cjr9p1M2Iob3psSrkzTsGa
1W4g9MUTpRCnPCgsnQKirmCZSvjfHghg2xJPgV/nPrR7WLtT7AgV/VNjJig3mP1t
VDvkXoA0nIPfdiT9wBWDRO4UaacUIJyAglb0rXSIDarH3un2KgkoPdH3gJk0akmO
k8iquu/T9Z4ncxoyLkwuq4W1xvueV436iYn493pLhdr1qqZPsdZq6Tr42rgn/441
ccJJtwwvS2pdFlAttoOv70l1ZZAtG158VHtAOSXedkDiqWxSWnj6tuJIf9VmAndn
4Ngz8GGzJ4nj9m0LJl51YoD/1G6i2j+UQK0YV5vjhX3f4eQfiJ8nstHdNvRUWZko
AJWhoOxU
=u1jZ
-----END PGP SIGNATURE-----

--hawgbyhlcibefy4q--

