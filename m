Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E19DF4BB8E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 22:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD9D6B0005; Tue, 24 Feb 2026 17:05:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47B036B0089; Tue, 24 Feb 2026 17:05:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3835D6B008A; Tue, 24 Feb 2026 17:05:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 247CE6B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:05:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A30DA1C314
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:05:06 +0000 (UTC)
X-FDA: 84480731412.04.81D2A8A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id D21274000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 22:05:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OG7FLWFm;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771970705; a=rsa-sha256;
	cv=none;
	b=HIXod11ZuwqzEjUtoV1JVgelj4bga3i/5OZ87KwJgAZzL8V73nHBSmo+3SMxvNzlchT9Sa
	uyNlSwpPVvftLwDuwQ4lib6VUQQXkZh5vkUUgPYOcYoJ28uaZI6iJM1x6G+Ws1M2s8sT7B
	okrJDilQMHm5Pu9CLZNnJ63fe0dADg0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=OG7FLWFm;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771970705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9pcvWKiqm2R1lSdEXlF00VSi11/PT+srxejSZf9A3ms=;
	b=r38+nm14oXqYPS0l5wBbkx0sRuCEkOVlozHZd0zcKzOkLkMZhDXexVJoUEBnT+jl2PNuFF
	xdfZszE3+ecV2U3F2QTDISvx1hOk8Z+MyOYT6uf7Avkll9z8MuihvrlBucLDayfQbTcxtq
	sDpvTp2IoW+RRk4OdSyHjV3MGWxE8g8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9pcvWKiqm2R1lSdEXlF00VSi11/PT+srxejSZf9A3ms=; b=OG7FLWFm13+E/xBP90cpFYkTiU
	xfm7k65ecZr0GAwsVpy+hGtOKngzR1laQKG2jSQWeK/DpGj13cR6+LbUNaFB6Wbg2DRGmnmSJJ9O5
	88EtIggsswe5Ji7XN3B4iWKrLnvNa8j66OzGUOL/hpytCmHqrJXE3fT4M5YsqO2uibyJI9OCnjZ+U
	PSMHs9Y8cmWO5nUO+koQvX+d8ecYNxAP9EnDc70GIgwx9GK7TypJuK4ulXnr9uoUt0tSsLUIODRb1
	zKhTbGZ0TVbDjH2+Tbcv+7a8ogDLdt3NV2uQ/iEuvDvAFjJ7XIRMdBUd9y9Kz7IbwYd20aR9l93E0
	SQwUsCPw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vv0VM-000000001sU-1Voz;
	Tue, 24 Feb 2026 17:03:45 -0500
Message-ID: <58e1883fe084d8284dac68dcd570f5a6c56c0abc.camel@surriel.com>
Subject: Re: [PATCH 3/5] mm: add a batched helper to clear the young flag
 for large folios
From: Rik van Riel <riel@surriel.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org, 
	david@kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com, 
	ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, 	surenb@google.com, mhocko@suse.com, harry.yoo@oracle.com,
 jannh@google.com, 	willy@infradead.org, baohua@kernel.org,
 dev.jain@arm.com, axelrasmussen@google.com, 	yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, 	zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 24 Feb 2026 17:03:45 -0500
In-Reply-To: <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
	 <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
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
X-Rspamd-Queue-Id: D21274000B
X-Stat-Signature: pnxd5cwmsnetoke3hopopewpqawcstpb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771970704-406454
X-HE-Meta: U2FsdGVkX18EJqqjnh7cm3gbIoDw2sDS5TQp8q8v4g2jjmrO4OSgPusjNP3HqhktlqUtdXkOmdvwFgLX/J/uZ8VuU+o4T2eKY9xbTEutEXJFmEtiDUU5R1WImkcl4xdmA0RnyP32/2ycCNwYv+r8zdcrkZA2aI0qWMt5mnGDqpuW6l5pB0J7OSZoBQtK7wtxxddpIxvdWNMnBhaMSmA1lhS2YyAACEwe+BHhwR/Ykg2cn12DspJy1vzsP9zg2fU7aRYpArxJCSff/zhjFPMb+zNKMTVNd1UnR+6gVsDgq366lOQp/kg04KSM4J/ZH/v8WDY/KPMD+AMGo4Rfb7pJhaT6tzD1Io9wW1Gk5hOpwHTTn3GWIyLyr40ikkG2Qx0rBvEo2+NtQqTVnMA7ULOVbVNZDehjragUWGUv6AYXP8nhHuft7OulDBHP5XtPrPGrBwXtpLh76rzKh5d1mtFTvUbWpdDBEd4SMTI3RGs7Btc48lbnNERpdrrMPoPcMP4JpQvPQvMEmN5Yynseul3zIYinNLXL60HBGQ8a5K0yPZhCFbRuV6rZhI7f6ryLl9WVvKSK7V40Gvxex5NR9jCDrXYJyR/hdsbIcFy035DLP8iZ4RzxJMdeh1F/FPX8SvWuWvocweI0bGDihMCC+2rFDNTn4dWjzpen51g72fN0Rl5lnKGoYDrnMHL4D0yT1yXiep+knysDEDZlS7ptq1uoeJjM+m+auq+oDx4wA7mW+jex1vABDPq6QdpKJoqqoavN4q19zXSdywe1tRjUWXf3wuzUKPDmpBOJo+Y0TbsVVjBiry798UM/N5J4Lgjpi9P24WA0KUC+yGDHNX75+A7hAjLdT+2UiyoovlnPccJmIebtWl+A2BXTQuZ6Z3mKlBuXbATTy9mR7a2tavNPT2LckGj1+jDCtOa5chBxNp/N4wzjAm4NxWKug8NC6pE+heTN6bRfj7AxfY6y6pJCM7b
 5eneXk9S
 QiUqepL3N1Et8o1/cU/OoiMa63mGRt0Fc4LIo9t/mQIcUs2YBjoknIHs1Jxdbr/vXcbmJ/tlB0HsHv4QGPsIVSFC7hWroyjneyJKFck/wp1ybTGwAeplM1E2OvYcTbnryWb/q9qUuSNPN6x6joWN7o1Masa53L/0Hj6OUjyrJbHUZDHpeGruNJDW7caNsdpxUfWn3C/G2AJTUIpOg+AAFUvXxzwUtCJoJA6iP4mteMDSrw+QpENfRmld+WhtMvc8I06DK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-24 at 09:56 +0800, Baolin Wang wrote:
>=20
> +static inline int test_and_clear_young_ptes(struct vm_area_struct
> *vma,
> +					=C2=A0=C2=A0=C2=A0 unsigned long addr,
> pte_t *ptep,
> +					=C2=A0=C2=A0=C2=A0 unsigned int nr)
> +{
> +	int young =3D 0;
> +
> +	for (;;) {
> +		young |=3D ptep_test_and_clear_young(vma, addr, ptep);
> +		if (--nr =3D=3D 0)
> +			break;
> +		ptep++;
> +		addr +=3D PAGE_SIZE;
> +	}

This may be a nitpick, but could the --nr thing be
stuck into the loop conditional?

Something that looks like an infinite loop just
seems wrong for something so bounded.

--=20
All Rights Reversed.

