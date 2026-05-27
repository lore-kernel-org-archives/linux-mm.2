Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F24CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 15:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9801E6B00AA; Wed, 27 May 2026 11:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958126B00AB; Wed, 27 May 2026 11:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86BA96B00AC; Wed, 27 May 2026 11:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 742836B00AA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:41:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A9111405DF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:41:26 +0000 (UTC)
X-FDA: 84813614172.24.8901B18
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 691E8180003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 15:41:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="GEnwN/FA";
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779896484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oikUtBRFh/gGkdwzqzvGVc48zMkmVITOctUzSsP8HHk=;
	b=M6u3ebsrMigOVHPIqVT8sTuyI0+HI6a60A+BRLhciU1DxFaBiKkk5Hy+NRxxmfPsCPAUlF
	tiU7vyIlFsYUlSsq9Gmw3RXwiDsKrpX97dsPb4dnaXMqKhXHRCGyziLkdd5xAX688gmGJX
	tB8KI7pkKFpbJs9lZUd7BKgQkY2pNog=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="GEnwN/FA";
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779896484; a=rsa-sha256;
	cv=none;
	b=IR7wBc3O5ToOlJjTM4UKd5kn4SIlC/G6XvZhdkMyRZvoI6ClqZjOsQscFlZctrZ5IkPUG/
	e862x04LhY2NRqoHIFMH6KebPrl+G9KmiVz8Rfnw0s5rQDzF1Fho2Oa8Xo3lMj++Uhg+8a
	Vr5uFv6deXufBJCG0k0fANuCzj66k0o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oikUtBRFh/gGkdwzqzvGVc48zMkmVITOctUzSsP8HHk=; b=GEnwN/FAU0Tlq02oj3pLcpuzji
	+kRli8umqeCjmk8Bx0fB4zeC7dar9/rXPYOT9iER+KSmtPh1wZX4+bSxqA4A7QUFNbm/vuTPEoV0H
	t+p++TWHiGBpMD56VidMG/OxCEbW2JRkmZV0vrLZ1lil12Wua/81eniQsLDfhwXOYQ8+dclFv/6WE
	QecROif82UlI2ySdP/ogG91qgIRHgR13/TIRODYP/0DGv7qEz8KP8KGuMpqs4N3ksosySwP+/6BiN
	60dh16nTjptoRt0k628WKTOiDJ3a3jaeIshOjc2WgtkQ1XneGkQMgYZxnR+sHVrjusWYuLDOTz/tP
	I4UOS1Xw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wSGNV-000000005VD-2o8E;
	Wed, 27 May 2026 11:41:05 -0400
Message-ID: <2ecf71858845e7d14c718b1a6845389cb78b986e.camel@surriel.com>
Subject: Re: [RFC PATCH 05/40] mm: page_alloc: remove watermark boost
 mechanism
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, 	ljs@kernel.org, ziy@nvidia.com, fvdl@google.com
Date: Wed, 27 May 2026 11:41:05 -0400
In-Reply-To: <20260526140204.1390573-1-usama.arif@linux.dev>
References: <20260526140204.1390573-1-usama.arif@linux.dev>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 691E8180003
X-Stat-Signature: mjq35a8mzawekpfsfrepazf7p96sq7ew
X-HE-Tag: 1779896483-145496
X-HE-Meta: U2FsdGVkX1+7BMtdHDBxroflEnqCwH2ezg4YFgmkWa4vKRX1vRakB7swO4iiy6kEl22kd1TXYUZjhRsTdbxgRozfkrUKbwqXl6LS5AQf9UxrYtUNWh+ancP316UOyXRnH6SZyrEGm4En+8NrqPKM+qWCa8opN9yFmo4t0r/LdnML5hG8DEytWqIKz83WqPhPkh1pv8WbnIXz33lEdK4Tl1sZy1pJNO0jSUUerlegMWnXjTKRKmNUwxKjaMPqIjRSfrexzeQyi8SKBdmp2ppqrDhx3NJvAzO29Uud64cEBqZhCmAQnt2oUymBdxVdt13E/PwxZi49ehlwXVg5IB5Da5YrHvn/URniM+n5xMfauu5XtwiXyb89Ei/Y3dqT/cNmyFGp9n2MF3sc5kst2EXz6N8FNneEEMsvaThakLEgWIKqhKbgLk1AJRAnLIwSv5SCa/I1zvDp1Pr7RaU5cH7iKuJUFPeasJOVgHJMIpzIQ+OHffmzXkOgBeGznVH4qv3+Ix6ku9Qi/QGcM63OGha0ADLtS+hE/rgCKVHsgk/dfjiDZ+LJDM3BN9x6Nx+36lvtsf2EoT94oadxhPUrdPIWRz5iZT3WWpQBT9IB2VkEOVlu07NUIodSlK4tpMktgTEBLZ8shVwLIWSTSeDQTBFW4VUM58O6mcy8ZcA0HukEDqkSf5IzpCPqk9TgLILWqLNNs8S/9edGmuihodgS+5Xyp/sCjIOmMBIfTUefqjvzqKG9iWrzMX/Jpsn8/8yhwSWOQM5NLr3BKQ704cbb+q4S9HaeXopHU8wOTMHOKbzBXRR7fwOzcwkx1fAXrt6wo8lVn7U4tmm1jZdhIFraeI33TgZSOQdls5A7goNXmExkdwWD7WpK/rluFdsADHVMdWyTz57+DBD+eC0T+c2cyyhC5mS2isxAbm+hbUk6GGAjcvBfsZUu90hUU73/2gI5xGHK2CEb0fC3dPQNNtM32Qj
 klU5er2Q
 B6zP75A5rMLVkhJ2BRq+RDBbwXikpY1G6KemYCeDBNGpjv0Eh0xeH3mpTQBMIoVzd+qS38arjGuqx04j/NexEr0zcGSbGfaVxs2n8I5UbpGhZfky53lzFAvc4lRPiPcDiajVBJaBrLDBpknONUGEbfG/EcnTgmRV78A9x8eq0iBSYMBhgR1xl06KVylHj5biqL5LsKhEV3b+3XTmstyTMJuepJoBF7vXPI5wmq+90Qt4yz+CWwY1szk97Mt+zrzp6W/HUv3zDmd6lCTG4GYBQWuKU3SsSWXD4gWe3CvrPLXbDvi1VCed1CBb2PQ+OLPwnQQd7+n1/xoREb+U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-05-26 at 07:02 -0700, Usama Arif wrote:
> On Wed, 20 May 2026 10:59:11 -0400 Rik van Riel <riel@surriel.com>
> wrote:
>=20
> > @@ -7187,14 +7117,6 @@ static const struct ctl_table
> > page_alloc_sysctl_table[] =3D {
> > =C2=A0		.proc_handler	=3D min_free_kbytes_sysctl_handler,
> > =C2=A0		.extra1		=3D SYSCTL_ZERO,
> > =C2=A0	},
> > -	{
> > -		.procname	=3D "watermark_boost_factor",
> > -		.data		=3D &watermark_boost_factor,
> > -		.maxlen		=3D
> > sizeof(watermark_boost_factor),
> > -		.mode		=3D 0644,
> > -		.proc_handler	=3D proc_dointvec_minmax,
> > -		.extra1		=3D SYSCTL_ZERO,
> > -	},
>=20
>=20
> This is a userspace-visible removal. Writes to
> /proc/sys/vm/watermark_boost_factor will now return -ENOENT instead
> of being
> accepted, breaking userspace.
>=20
> I am not sure whats been done in the past, but we need to add a
> Documentation/ABI/removed/ note explaining what replaces it (SPB
> steering).
> and also maybe keep the sysctl entry as a no-op with warning for a
> few
> cycles before deletion?

I'll just drop this patch for now.

While we no longer need it, and the watermark boosting
can cause a little bit of harm at times, this probably
isn't worth the extra code churn in this series.

--=20
All Rights Reversed.

