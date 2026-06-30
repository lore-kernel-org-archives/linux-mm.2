Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 467ECC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 19:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D72186B00C2; Tue, 30 Jun 2026 15:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFB7D6B00C4; Tue, 30 Jun 2026 15:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9ED26B00C5; Tue, 30 Jun 2026 15:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7DE6B00C2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:33:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0BEAE140578
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:33:12 +0000 (UTC)
X-FDA: 84937577424.21.F74C64B
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4304740008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 19:33:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=FescMT3i;
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782847990;
	b=7e1FeK62K7pYv+e6TLdnjkXEEXinN+BV+f867ezQnr8h/ZitOoicl3jSTSZGVGIDVzl2Es
	W9MUu881Xouo6VHHa39oVii8No2mgXGoxWVNAARAL4cwTCvo2Z2oP40RXmZKgy5+l8sWwY
	nyyQKrcTKgFw3y8M26wlfJpEidIgI8E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782847990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSyZS1TOzJuDNaIHWvzKHOzXwZwWpLUZ5WG7d7inBJo=;
	b=xAv8rZawRfSajnsmRZ7VK/i6BNV95FjLlLYBNjHhYlMv1R5dLm8DDl7hu/FSf09KYflZJu
	V+E/TqN8Jvk8dmhLjtEJ1eZq/2ELRs2MdIgpcehQILzRCSDVmX/mf80S7ZntnkAsiJTbfW
	FalUGUclbibShiImDcraSiNgsDMAwuI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=FescMT3i;
	spf=pass (imf17.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZSyZS1TOzJuDNaIHWvzKHOzXwZwWpLUZ5WG7d7inBJo=; b=FescMT3iIb2vsUaxrZ+YG03EvL
	ll2tGC6rK1lI6hIMUz/EYpaUERW+RsT2vBmfhfj8BBdXVWvIgX9MVMm4Rhi5dz0Bh82vuelRCKSe/
	TI6OmIVcz1t2OYEM59MT+l+ifKBDf7SMFYdM7cfDc/n4CwHKQuptxCo+APNXzm63eLj/vYJjQXEpR
	xGl0r4GUV7l0Y2NilvPLFQgOubXU0ysU2TtFfkRjWSwsRXbofBGUeogdijzMorh0EQ5UX0TFr2PHZ
	ZUpzAXRJuaqsqPxfESfVRH2NvoJ8e4KKt2tMlJJ/GqxueatwLWMxyT6UgAZ6lmi6VoZPwBAVCbkRX
	LWOoe+lw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1weeCN-000000008Bg-40Uc;
	Tue, 30 Jun 2026 15:32:47 -0400
Message-ID: <e374aa8bc576e73ec8365b1e57e6c10b9b679db2.camel@surriel.com>
Subject: Re: [PATCH v2 13/19] maple_tree: Document that erase may use
 GFP_KERNEL for allocations
From: Rik van Riel <riel@surriel.com>
To: "Liam R. Howlett (Oracle)" <liam@infradead.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, Jason Gunthorpe <jgg@ziepe.ca>
Date: Tue, 30 Jun 2026 15:32:47 -0400
In-Reply-To: <20260630190843.3563858-14-liam@infradead.org>
References: <20260630190843.3563858-1-liam@infradead.org>
	 <20260630190843.3563858-14-liam@infradead.org>
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
X-Stat-Signature: pf7xqqzmzb6bfitjqiykj4da4y6jwxmi
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4304740008
X-HE-Tag: 1782847990-827034
X-HE-Meta: U2FsdGVkX19mlPsh8FFS+GHFBymzKk4EgbbMp/rCpb5tqIQHZcc8Ewrqqxsnzp9FnbzgeKFyNMtiQo126xXfQB75yjmYwSeRRUv1WJ2MriRPLKM5KlFnjjFRM2aGilYak0eundrkUHcYS1OJDT8r26nwAk4p3FqRK2kdti+FXNisVL9y7xdAkXRYKhQuXMAv3mV89TYy9iG+fW0Ay6N3lrNbbq77br6jfsFOMvVx4tmVAjrz2ER3RmIirA2hx8YFioQIeomCAiM5TONWTvElfvzqMdUzyHOiLSvOi3kcrQcajufj14UVysldEtOzxjV441vN09RxA9IzNUm+q0viVfxbcvhNtwAZlDgcmbYKdTEc0hhcqQSNVdmxvPHLvWp7UUgWMqqzKE3/ftJjlTZq2EhffMaarU7sMz6f8xRVSePmn1darQ+evhTUtirKuMcjiWYU3ere2l03my3QcoYB2h1NcByun4ybBzSkLa/RHz85oAzjg9qGKQgtBQLJ1KKZJ8Oxfq0ianq5Sk59ek4sXS+Qc6aXh3t7y9EV+tU9F1FTSgClN6QFk2wNg+dT/+OSrKm7dvI/tMgtdd5B9k/cM3vWNaEb/U9VBkA6H4+nRC219j+Uxsa3+02Ed59VilrZB0JlvoOmXQ4sz1/GkM56GH8PwAHidRe0KeGRMIKNycLB/xUpx6RflkcNTDW9jcVznyXrcNjB3M5+/yew9KnsBjfH2AE7/n1v2PTCTPYmT6mRiCKzZMg2O3mMtdkqfyWoCpfTBCGjU2dK0i2uqc/XePpEFO/ExrIB5T5wVUFk8HhawsKokMdzpOJloXewpYeI4Eb3hndrzCtF/zGy9DVBDMagedYCqhlxD/W1WBk3r4KwKxa+Y1nRhJogxdXlqx9RRLs0PE16iMVboCJ1CWULn/TDvYsE/mN78hJdBPMdeFKii8Wi0h2J2T1JGiqqm+FuPqCg72Edk/MatVWLNW5
 x0wUvcSj
 9ZLZ4Iqx0s4YmdlNcObNvm95SazWGKUEhM2UDvHuFedUhQp235h4yRdW9QgRm/Q7lXE/60T+Y70+eYdRRucGGLkAdTRtYWYea/zvNPyY8VdMUhPkGb35MJV91ejb3VZJs81jg4rpEOEl092Lzhrdg5y/PL+F2W/E7wHIVKpQUnlafUn7kukfyeSamtI6ae9JGgIcxp9rOz0d43q90mWaKWJU6ld9i72qkqvA5y2NahQ7CLVDqCJLy8XkXj6EHZl800exFma5+XPl+5Ws0B48nTjhNLLZs/6xyh6WjwPMPqm0UwxcMIfAPHl9Ng0j8w1rPu6shEDn0TqVKpCS5tIXxrAvSwTYfi2QLlKGg4lmXfmSX8E04JHgER1v4mZaV8WDI6iC4W7IqA2gLed1bxO/93fJ9I7AWVnV4cY9IyYLT8Kxu+OdArB3pSr3Zkaz3m+UPemWy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-06-30 at 15:08 -0400, Liam R. Howlett (Oracle) wrote:
> State that the mas_erase() and mtree_erase() functions may use
> GFP_KERNEL on allocation retry.=C2=A0 Don't just depend on people reading
> the
> documentation by adding a check that will warn of the use.
>=20
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Rik van Riel <riel@surriel.com>
> Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
>=20

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

