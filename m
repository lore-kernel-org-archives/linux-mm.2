Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E8A4C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 07:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A006B0132; Wed, 27 Aug 2025 03:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53AF86B0133; Wed, 27 Aug 2025 03:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 450776B0134; Wed, 27 Aug 2025 03:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2E04C6B0132
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 03:46:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1F971A04DF
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:46:20 +0000 (UTC)
X-FDA: 83821754520.13.18C05AD
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0B71020002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 07:46:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="L GzVdU1";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf13.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756280778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MmrPy+E8embJExjeJmQiky6NuUvRVQ/YGgyEIJXCLY=;
	b=n7m6NFv03ZKjS00a64aNWk3RAAJGj1Gn1pTNFJ3p/ypAbHJ/aM3U0aM7pAhBT/VBwNc1g4
	DB3OAS/sA+fdfwrCVtb7JJJ8ymlOGlnLDtEm3mDaWHFFnjZr0PJ0aiS8+9duNHqy21PTh8
	bOK3IWYjhZRQ8Yw8h7R3swIhfURTGg0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="L GzVdU1";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf13.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756280778; a=rsa-sha256;
	cv=none;
	b=g+JmFMRSYwdMCqIg60ymnotZByCpDSXsyFLXy6ezF3DcfEptlQssm9+DuM8GS0Lsp7Ytc9
	mwQzTAErhvs/Oa3kXX2RA75/MHdS/gCZZIVdkDf0k5y8Qa3pYZmRGMG+qApFoN9i6fYcPt
	T1jLTIsIyQHp8TQEVweosZQjZy8cR1A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=2Q4BVcfMJ9wvZWMC/mZ7cNqnTcVJUHQ74bJz30nxEJQ=; b=L
	GzVdU1vI/trXXe3VPhkZrntZSiOp0+sLZDHI4PjQh4amNDClKG+uCaNgiaA2K4Gm
	8hz333L/LBsNFOCPreA2udFPNEnXTkKaebazpgT6JFDVpSuoLZo7xZz0bCIhfa4s
	MIemJRxq2XaRtDbW1pjFkhOBV8Bqdjx6T46lvhojk4=
Received: from yangshiguang1011$163.com ( [1.202.162.48] ) by
 ajax-webmail-wmsvr-40-108 (Coremail) ; Wed, 27 Aug 2025 15:45:48 +0800
 (CST)
X-Originating-IP: [1.202.162.48]
Date: Wed, 27 Aug 2025 15:45:48 +0800 (CST)
From: yangshiguang  <yangshiguang1011@163.com>
To: "Harry Yoo" <harry.yoo@oracle.com>
Cc: "Vlastimil Babka" <vbabka@suse.cz>,
	"Matthew Wilcox" <willy@infradead.org>, akpm@linux-foundation.org,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	glittao@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	yangshiguang <yangshiguang@xiaomi.com>, stable@vger.kernel.org
Subject: Re:Re: [PATCH v3] mm: slub: avoid wake up kswapd in
 set_track_prepare
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20250519(9504565a)
 Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <aK6U61xNpJS0qs15@hyeyoo>
References: <20250825121737.2535732-1-yangshiguang1011@163.com>
 <aKxZp_GgYVzp8Uvt@casper.infradead.org>
 <54d9e5ac-5a51-4901-9b13-4c248aada2d7@suse.cz> <aK6U61xNpJS0qs15@hyeyoo>
X-NTES-SC: AL_Qu2eBP6Tv08v7iadbekfmUgRj+k6WsK3s/sn3oNfP5B+jCLp1RAuT3NTGmvR89CDKD2NnQiHYDh85sR+ZaZKQoML7HSsXXB4Qm/WIcirldzZ5g==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <6e1ab9d8.6595.198ea7d7a78.Coremail.yangshiguang1011@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bCgvCgD3v1ett65oVdEiAA--.1986W
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/1tbiEA625WiuiUfH0QAGsV
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0B71020002
X-Stat-Signature: roif5gcokna88crd9y13emxsase835hc
X-Rspam-User: 
X-HE-Tag: 1756280774-362467
X-HE-Meta: U2FsdGVkX19RVwFAys4+OICePVp+76O5u30GJNn5qRqbnMCuf0o/N+ZkszlQvvYcEeCmyqUkJIXc98VzsUnuP/vUFpaISvLYq7HuolSNxyjDAoOV3ikdvbl60VVH6BONJGJXBFYQvXiW0I1PsfFKEaJh0EBS7S1IHP7ZZoJvI3Qojnlz2nKCR7nV6wC3GW4gtEAa04EFCY7KWtGI5huHz6gEPMUNkZgE9FHEX5PkMvImqnFJ1nTgVGZZ5wPfuUdNqXlLomfkrbVKd9jHJoZywOTJkbWarMvD/6SiuOemqCToZ9Dv5gsg2TYLYM0mwdR2nvSO6lzhcY1lqDscu8Lr7uH49Nv1t6UeOmI0Slk5EEsh3mLrjp7cGpcXBfLZX/GeyiyZ9Pb2XvK0U8fK3k6YYODjYlZUvoPEPwlU6oZdnoaovo1jaV/UgqxnZ1xYMosDNJla4AcA4d3VhgLy+AYZy4BoS5MFHrVMDmuvj9SToi5JaG11RrZZKBCYAe8rQ/0f7y3RPfkLqf7xjtCW0aLrT6HXG+88GUurkShqX4UgVDp5dGbjG3+aCwi3bbpHkD2YD/rqerP5eVdjEgv1um1O4MQm9oueLIMhFxLPmaeKJFq8I/mVwF1vF3kzF/yMvjuN+P5lNYcV6KuW98+iW1hcHwdWwtu7OK/2yAgghDJIWvPcgwhMnocd9+85qPiodw1ui5SwOc5gxLffGrJu1/78LfHmZEZ2IjglRfY3UzwOQGdf9yDEyAUYlSbZlAvU/a+nTuyFDML4yWcgBWg3gVUlbXvby0+QUt0mccgt2ikWt+LAaZ/4UimLL0xCy3wSswsPbauzFw1GE6JXKRPgooGG+pDMM63myTkiQfZXwJPyAgKhmrL8x8o+mKgrqkXLHlcNbDRAgIHOLvSnfv7j4qVyK/TRtbByyd1z+p9cRMtEjJe5YEuqGyMDKGXiiNUJfMAxlBJg8NZbjbYQGGcXEfL
 GUtW+bJQ
 eGQXTHYYs4EXTIgUK6Ekbv48I2Bj9H8aWzy6z9v5jLjtwRlc/v/CreyUeNalvfG/3qte+mWpBoFJl5ZvHHNqeRr+AgufRwpMdhGyTzL53G4PMloYfevLPW3WN5u7oC6O1QtDvyMGrzAR09Z0aMR6nvMt7IuNkah7lPQ5knMUh3Vx/WmPGKwsNFKP0jnZnrl7eBsxKa+bYLDElEl/qQOyHfRIS7bNl45anf/Xd9dKIfBwvYZXOLFiB4wU4ixAhJnQ1kaSw5ecFiAkUaiMzfsYl2XIm++K6zyr5EVU05ch4x0r4si5Gi1yQs/WY3SXqr00120YMdMrveG7j11Ehay2aB8J6Y4fyMQLlc/hAcchfc+xxozDDm7rYisdPKjd40bwv+Lypjmk/9080cAjrbOX7vz3hJQXdlEhxjPRIOW7tnrv4P/BOdrpuvvCggQouu4NUj9jUayLk/nisLag15wO7Q31mcQ68IFRaRT2HpnbBh9GABGQZULUjbn8WBq8cWhbNEgRMxUSP7kR6qAbugpFR9pKojo3uBia1tdFZXuMEFgTzd80Y6i/Fof01xYcmlfxhuzny0fabNTBmR7uwP1vBfjGv6UNC4HVVoX0mze3XusZvAsqJN7VIjpadtPbgk+ra2BcAsIYCzwObGTX1+CLYbb/DvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgoKCkF0IDIwMjUtMDgtMjcgMTM6MTc6MzEsICJIYXJyeSBZb28iIDxoYXJyeS55b29Ab3JhY2xl
LmNvbT4gd3JvdGU6Cj5PbiBNb24sIEF1ZyAyNSwgMjAyNSBhdCAwNTo0Mjo1MlBNICswMjAwLCBW
bGFzdGltaWwgQmFia2Egd3JvdGU6Cj4+IE9uIDgvMjUvMjUgMTQ6NDAsIE1hdHRoZXcgV2lsY294
IHdyb3RlOgo+PiA+IE9uIE1vbiwgQXVnIDI1LCAyMDI1IGF0IDA4OjE3OjM3UE0gKzA4MDAsIHlh
bmdzaGlndWFuZzEwMTFAMTYzLmNvbSB3cm90ZToKPj4gPj4gQXZvaWQgZGVhZGxvY2sgY2F1c2Vk
IGJ5IGltcGxpY2l0bHkgd2FraW5nIHVwIGtzd2FwZCBieQo+PiA+PiBwYXNzaW5nIGluIGFsbG9j
YXRpb24gZmxhZ3MuCj4+ID4gWy4uLl0KPj4gPj4gKwkvKiBQcmVlbXB0aW9uIGlzIGRpc2FibGVk
IGluIF9fX3NsYWJfYWxsb2MoKSAqLwo+PiA+PiArCWdmcF9mbGFncyAmPSB+KF9fR0ZQX0RJUkVD
VF9SRUNMQUlNKTsKPj4gPiAKPj4gPiBJZiB5b3UgZG9uJ3QgbWVhbiBfX0dGUF9LU1dBUERfUkVD
TEFJTSBoZXJlLCB0aGUgZXhwbGFuYXRpb24gbmVlZHMgdG8KPj4gPiBiZSBiZXR0ZXIuCj4+IAo+
PiBJdCB3YXMgc3VnZ2VzdGVkIGJ5IEhhcnJ5IGhlcmU6Cj4+IGh0dHBzOi8vbG9yZS5rZXJuZWwu
b3JnL2FsbC9hS0toVW9Va1JORGtGWVliQGhhcnJ5Cj4+IAo+PiBJIHRoaW5rIHRoZSBjb21tZW50
IGlzIGVub3VnaD8gRGlzYWJsaW5nIHByZWVtcHRpb24gbWVhbnMgd2UgY2FuJ3QgZGlyZWN0Cj4+
IHJlY2xhaW0sIGJ1dCB3ZSBjYW4gd2FrZSB1cCBrc3dhcGQuIElmIHRoZSBzbGFiIGNhbGxlciBj
b250ZXh0IGlzIHN1Y2ggdGhhdAo+PiB3ZSBjYW4ndCwgX19HRlBfS1NXQVBEX1JFQ0xBSU0gYWxy
ZWFkeSB3b24ndCBiZSBpbiB0aGUgZ2ZwX2ZsYWdzLgo+Cj5UbyBtYWtlIGl0IGEgbGl0dGxlIGJp
dCBtb3JlIHZlcmJvc2UsIHRoaXMgXl4gZXhwbGFuYXRpb24gY2FuIGJlIGFkZGVkIHRvIHRoZQoK
PmNoYW5nZWxvZz8KCgpvaywgd2lsbCBiZSBlYXNpZXIgdG8gdW5kZXJzdGFuZC4KCj4KPj4gQnV0
IEkgdGhpbmsgd2Ugc2hvdWxkIG1hc2sgb3VyIGFsc28gX19HRlBfTk9GQUlMIGFuZCBhZGQgX19H
RlBfTk9XQVJOPwo+Cgo+VGhhdCBzb3VuZHMgZ29vZC4+Cj4+ICh3ZSBzaG91bGQgZ2V0IHNvbWUg
Y29tbW9uIGhlbHBlcnMgZm9yIHRoZXNlIGtpbmRzIG9mIGdmcCBmbGFnIG1hbmlwdWxhdGlvbnMK
Pj4gYWxyZWFkeSkKPgo+QW55IGlkZWFzIGZvciBpdHMgbmFtZT8KPgo+Z2ZwX2RvbnRfdHJ5X3Rv
b19oYXJkKCksCj5nZnBfYWRqdXN0X2xpZ2h0d2VpZ2h0KCksCj5nZnBfYWRqdXN0X21heWZhaWwo
KSwKPi4uLgo+Cj5JJ20gbm90IGdvb2QgYXQgbmFtaW5nIDovCgo+CgpIb3cgYWJvdXQgdGhpcz8g
CgogICAgICAgIC8qIFByZWVtcHRpb24gaXMgZGlzYWJsZWQgaW4gX19fc2xhYl9hbGxvYygpICov
Ci0gICAgICAgZ2ZwX2ZsYWdzICY9IH4oX19HRlBfRElSRUNUX1JFQ0xBSU0pOworICAgICAgIGdm
cF9mbGFncyA9IChnZnBfZmxhZ3MgJiB+KF9fR0ZQX0RJUkVDVF9SRUNMQUlNIHwgX19HRlBfTk9G
QUlMKSkgfAorICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgX19HRlBfTk9X
QVJOOwoKID4tLSAKPkNoZWVycywKPkhhcnJ5IC8gSHllb25nZ29uCg==

