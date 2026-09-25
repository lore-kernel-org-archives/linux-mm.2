Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD524C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05B9E6B008A; Fri, 25 Sep 2026 15:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033316B008C; Fri, 25 Sep 2026 15:00:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65336B0092; Fri, 25 Sep 2026 15:00:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C63A26B008A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:00:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4388912072D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:00:51 +0000 (UTC)
X-FDA: 85253201502.30.903A2EF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD79C180007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:00:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="VA8kCM U";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790362849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cp3KpeoSWqR5DrpiHmEm+y4xxrxVLkmSxI1ryA+o7ns=;
	b=c6weJD21PQ97LdfbU3Y9HnFtDLOK3Gwjx47SBfppCZqmdzvRIZ88U50P61DVrcp0twcPaV
	afgJyDxv/fG+sh+JCa+jD9/a2lkh8LCXtG0N8QHxUU05+QXZiwuz1bmvJbbUaudLjSOeQw
	5n7aiHBtmVOerGvFIbstAor0QoaMVaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790362849;
	b=332kPOD0mdbQAK+LEtHxzVslpTkLC3QikRcB0EZA94Jv48xrb/y/SrKQOK1JkWHyS9cuud
	UaMoBwNo//4GeWk5kaUTO7iiIBSKrsFXr8HnR2sdFabnGDOHXBMfyHFC5hcKbMuNgKSgp0
	weXlJt0g9co+6PkR/H0nXJn8v0kN2hk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="VA8kCM U";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=cp3KpeoSWqR5DrpiHmEm+y4xxrxVLkmSxI1ryA+o7ns=; b=VA8kCM
	U2XQAteHMN1acW47NufAGdhZPD1ooxBi7kh9whJOeSyIr//j0lyhZd4fyKo0PaFB33k6oo9QZSM3O
	YSWXSGnfCUNu2DK5KPiuxFBAQ8dB/ZlgtyAkefIO95VDAuMJJtr+8p4xmwJPLOc4GeuDGr+FDwpct
	KWbh3wZ6yLbvsJkxtZVzfDjwPNHgS0V71410DaIMKmEmwuZ6Hvspb46rfa/sWWOkNCaMMdD6Qy3zx
	8uC8EL1iseMq9VZK/iE4ro+hFDfpZtd4BhV/BeHGuBjxl32+a8jmB6IZaa7uDKd5yvKlERb6AL8ya
	0odqnoUIWuulxh2CAbJssW3a3Irg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xAB9I-00000006GnA-05It;
	Fri, 25 Sep 2026 18:59:56 +0000
Message-ID: <f2cdc9352e4fa67d2ab4797b6b781e36e8b77129.camel@surriel.com>
Subject: Re: [PATCH] mm/vma: don't remove VMA from rmap if pgoff unchanged
From: Rik van Riel <riel@surriel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Andrew Morton	
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike
 Rapoport <rppt@kernel.org>,  Suren Baghdasaryan	 <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Harry Yoo <harry@kernel.org>,  Jann Horn
 <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, Pedro Falcato
 <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Pan Deng
	 <pan.deng@intel.com>
Date: Fri, 25 Sep 2026 14:59:54 -0400
In-Reply-To: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
References: <20260925-speed-up-inplace-rmap-v1-1-babc48ce7c83@kernel.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BD79C180007
X-Stat-Signature: mnrz5gsd19zncox8n8jcwqw6a3dwrr4y
X-HE-Tag: 1790362847-387332
X-HE-Meta: U2FsdGVkX1/Ar7J/OWjShYuq3rgkW3spiS0SjD8Kdh1vcqDu27lB4QVdZCpmUjQ3mSgjHUVbAHbNYiQZa201lJyGSEXkhYaOurYCcDZ3V0q2Y7TcxehXgSE4ClrM3Qc3ipcbGIa1ddXY2LDWpafCX8Gt5NtobAbKf/3qj6Wy+6PyClZvsXbk0yq71ZPhXP47CFpQ0A8IkwVRyHY4IVcsaLlUKSvffLi7vSFn/mSDYBaj44j8cDKN/AnmuCTCa/y0GKBrHxIdC1cOJRv3E/yPYMnNHytSoqe6l5yiUYwQ0L4yyqmK8dUEx0g4bHkqm5ft32hYBAF5B+Rijikej169ROtGOzwfB9iIEZHESepG/PaRNEZ+udE11QTu5Ip7cY0WgsEaDeUeJHEAiy1/ixJNs+PTnV2p4IiKLb2FUTB/KJpr+3BH8yOCgtGc2Lo7+5iTbEKAD/Ujli7hkZSR+Og6ian6+vR0yEx3goX3XzLZtkL/AJFn1y64A4b6kGBAnMFJXzymZ4kG2JYpb2EOgcqY702lVsUxNEWvmky+wc7eGk7x6/p0AwsNarzevN73t3JW/f41qL9nKvt/45p7CR1mcoe/t0oF6RNbP5B+ejAXrfkwqjhee62DWieASUug+Av/AxAmXfDBMK/C/ZRp9+eBOSL9kNuXe+Ay6aBe5ho+xj0AkaNOB6RqH4Rqt03BrcoobqXGEuitFo9Gme/0Nv5Ws9SuahZBplYaC8cy9d1ARJWXP1Wmfvk2Jlxpm1er4TJ8xzUP9GxMvIT4JxIYRtpP+z3rxJEIYXYBMpOAwpHkHCapdjGhbR1nBknFQSyHh2vFYp3sLWsh68s+aS/bZ3eDsA50ELdkHNB03oxw8jiO6teLBvsqiHoJKQR8fVQFXxLZZcXLZsQWSpWHS5Sbm4/SW74vFhIkrhCG6EGRELXiCRviwudFjDSmpYsJyvzjO6Hh2AMNk+d22Ju2mMPxb16
 qgcsBDiE
 CqsX4gVKnc2BuwILyFHGw56yiv1A8mcoJye7eOCRkf92s1tLshpheioyBVXIDH/ErGCj4TYq0Lv9zNpRlicvAUX7vSzLxBzo5jlbjwLYcvcHhXWG7bJ1yi2iY/9UMkqi5iMqCSCY1ZPgl/apWsEOjxWBRvWXGh4tJYVji/CrHo5q2VMjY2H8q/VeTXGZNL00qMxGdFomWUkhFmpWRxAhWPJsP6M9kzxld2jFjVJxr06hoaj1fQCf3S35eYcJo7bKi5PX4FLT9xWj0kYEpxdIZbusOY0P4wxVsFvIhLN8SOrd9fVo2CdnSGzUQdDCLS2RvxhSY6pNmq+GAiA4nLD/2SVPpjWPiy55M6IrWxFNtx0gIDvQHIpI5UPMzWZL8gzt6260j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-09-25 at 19:32 +0100, Lorenzo Stoakes (ARM) wrote:
>=20
> When performing a VMA shrink or a split where the VMA is the lower
> one, the
> page offset cannot change, so set the flags unconditionally in these
> cases.
>=20
> When merging VMAs the page offset is unchanged only in some cases, so
> update init_multi_vma_prep() to set the flags only if the page
> offsets
> remain the same.
>=20
> These changes ultimately result in less rmap lock contention.
>=20
> Reported-by: Pan Deng <pan.deng@intel.com>
> Closes:
> https://lore.kernel.org/linux-mm/20260924054301.2330822-1-pan.deng@intel.=
com/
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Nice optimization.

Reviewed-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

