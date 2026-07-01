Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 359EDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A9D6B00AF; Wed,  1 Jul 2026 13:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BAF76B00B0; Wed,  1 Jul 2026 13:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE346B00B1; Wed,  1 Jul 2026 13:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C84046B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:24:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DDCD1A0489
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:24:29 +0000 (UTC)
X-FDA: 84940881858.24.0A33C27
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf23.hostedemail.com (Postfix) with ESMTP id AAE3F140002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:24:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Mf04VCvT;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782926667;
	b=HPiQgIlE3OMeJmZbStvikj9rGdodhml9J4ODvGW+czWzN3tuL4Jx6W9fmujjXTYUQUnp9Y
	BofQe0CyeRTOf2BGCELtzhoESRacV8Ju62tBW45P+DO3anML1FU0qH2N0rbCuE81Ewkd8z
	EvaEzsUxrNVAU/xLEXZie7xBsBHL9+8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbvWGJKElR/rTbCtbGCSktloNZd5j7nEevslzR82294=;
	b=iETkLOPIu8pHD/WFWo2WsEdXrV2xNruFdJBz3oDhAyxHTGXED4QXK8ZKzhHfl5MMqDZj0E
	3Sze9avgGKmilY6uzz51MIP426SchM8JORYVhJBZ+M5o535OTfO9NC5gg4zBOpZeTga5OJ
	QwAqYRKmy2eMWcNIu3w5qhzISpXALxc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Mf04VCvT;
	spf=pass (imf23.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=HbvWGJKElR/rTbCtbGCSktloNZd5j7nEevslzR82294=; b=Mf04VCvT26F5DejxVyk2Ofq/TW
	C03tHntseOXOSqM2Ux7b9JWhWUVLn8Xa1XV1qdKvJdZnWvKgO99yqO9aCD8KS8h0+n45kuntk9cnf
	25G+3xuhr5/EU6ohEwubdBQBano/2MFMhIQ+XljgOkR0AdsE8kbUmImL+mTk8ojbkzdzi1bDtA8OU
	JZ7GSOjAILAmkvRPK+nxoqoKJaFiJM3eVM9RngEoBNZLSqKXSLV1vpA5h60hdfDEQ7P8zzfp+hFyL
	2N5vPlt7jcv+Nm5EOsm0DJw5IjOvX24V3tT0NsSdj1Ef9MXpt8fSnsAUD5CH+GH14xvMJGc4ow/wg
	dnmIbZxg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1weyfY-000000001HY-1Meb;
	Wed, 01 Jul 2026 13:24:16 -0400
Message-ID: <9df36c6f5819f7decb188f0fcf1b199b68e238e0.camel@surriel.com>
Subject: Re: [PATCH] mm/huge_memory: set PG_has_hwpoisoned only after new
 folio head is established
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com, linux-mm@kvack.org, akpm@linux-foundation.org, 
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, 	npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, 	lance.yang@linux.dev,
 yang@os.amperecomputing.com
Date: Wed, 01 Jul 2026 13:24:16 -0400
In-Reply-To: <d267004c-a09e-4f04-9635-d1acc579d89f@kernel.org>
References: <20260701134622.3152896-1-riel@surriel.com>
	 <d267004c-a09e-4f04-9635-d1acc579d89f@kernel.org>
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
X-Stat-Signature: 78chnyiwu5uhqb4aixcxg3nbpuzjxmkn
X-Rspam-User: 
X-Rspamd-Queue-Id: AAE3F140002
X-Rspamd-Server: rspam02
X-HE-Tag: 1782926667-894167
X-HE-Meta: U2FsdGVkX19WPQWF/ZVA59V3ouN2vsAcI2fhSFpYc2UO3NfCc9LP8vrzY3EKBS6UcfmKqx4TKCoDJdl5iXKDf+SdVYdg5RYnDn6+toTwPdqjYldjxoeXpNyuyvp77ZaWfwAV8E8jWg11agLJVH9vTi6fWvY2cH8yxVw+BHGKEKlLh3wQ/FipCuOEDNFCecgtpdkucz3x++TtAPZu2CHdpCmSZRUAOYlcZATMDUEyN4Zf3JiZqtLjp67utuDo1Qd4e6luhhNaDjNl5fqmiaa4DjdEaUeUYJVHiuk0okepVZXbMA6cOTA5Ns2QQvYpKaD3pZwKbzAlxnvXuf6uJAU6nNg9WFI+s1BhLcGe9JQrI+H3WWLIbAJIJry5UXXhKlPf1f7ypghaUnNKUFQiLDZ2RSQWoq2kSNHbIKKI6DNJ3cjsEQU9Uz+vE01+ixZT9ogmdDkc1AHilUUcLgRvt2w6E2QJrHiyvQ7BXLQRTlNCdZZcHaWw4YJBkiqhJCg3bIBY42aNvAvGbuW5F7OUrOjDtKDDifDlJipbfti+teEYaJfTHJa05qziRZtQtCrx/CPyV0ovHyWrYhsI+eNk8xKZyf7DyN32tb07wd/Sf2gr9jp4HNQgxTRTD9vB1onDQJwrWPD17mUGW0Ygzdma5PKEGU7cJ0Ot6d06K/lr9DraGyYGed5ovctT1aXVo6cWK0Ll9Z2dFD8764K76qZgZoCNPHLMNgHWjzyhmVoq+Sz4VwPXpABLfkh2KqS/Nb9vL9EEfUS0v95KfhN/u1cc7iYb1q/esV+IkcUiDL4J/6m97cruVpXY2/zOpDHZPl39IUe6RGSVOVar6WXaGDwE7nJfw4AWz1QnnX2/idko62FqQbC9yST7HHO7sIB0Rt/1Jy3zkipkDo2hW2poBInOKdCB/9jfjovop9AlfhbEtnF9fJLVQHOneZFO8eeNHd2WD7Tzyvf09TEUnDPWIfCAa3y
 CuunwNaD
 PTBF4ysnxk96rhnquVJNIaDYHWV9GJeDBszeeQR5cyjumiMZ1BUABbmapvMGp9OXjmkO17SQPQETdEgW8XlnGn3RotbotolAz2aKyBJVtyuhShuHQzJ95Xm1HXN+7U8TF3kFsBIv93E28Jo0OZ+CGEkpIsYaUHf7bzPcW3tar9XWxj1h2QYOUPxrcHuIPooJ5qOWM0ZLhyCqOU4n2R6lweLjQ1IKVpWTixXEeFUwqEdKwqeNa8u0ifnAf+YF6FB8FMyl9fXu4okdX9IMkApMfNhWgng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-07-01 at 18:33 +0200, David Hildenbrand (Arm) wrote:
>=20
> There is some grammatical issue that makes me wonder whether you are
> talking
> about the present or the past.
> >=20

Changelog issues fixed for v2. Thank you.

> > Reproduced by syzkaller: hwpoison-inject a few subpages of a large
> > shmem
> > folio, then MADV_REMOVE (fallocate punch hole) on the same range,
> > which
> > splits the partial folio to a non-zero order.
>=20
> As Lance says, after we do the TestSetPageHWPoison() in
> memory_failure(), we
> call try_to_split_thp_page(). Does that already suffice, even without
> the
> MADV_REMOCE.

While fa5a06170036 was created to deal with having
the folio split to >0 order, in this case it looks
like the try_to_split_thp_page() call from memory_failure()
failed, presumably because folio_ref_freeze() could not=C2=A0
freeze the order 7 folio, because the reproducer had=C2=A0
multiple threads poking at that folio simultaneously.

This test case is rather contrived, like most syzkaller
tests, but given that the try_to_split_thp_page() call
could fail for various reasons, we do need this fallback
path.



--=20
All Rights Reversed.

