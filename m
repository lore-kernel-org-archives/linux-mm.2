Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B56D2F7D5
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 10:51:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97AE6B014D; Fri,  5 Dec 2025 05:51:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6F996B014E; Fri,  5 Dec 2025 05:51:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9853D6B014F; Fri,  5 Dec 2025 05:51:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 80A4E6B014D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 05:51:35 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D50F58E3D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:51:35 +0000 (UTC)
X-FDA: 84185101350.14.3E41D1A
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com [136.143.188.55])
	by imf26.hostedemail.com (Postfix) with ESMTP id 34298140008
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 10:51:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=pvHP9auW;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf26.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764931893; a=rsa-sha256;
	cv=pass;
	b=V2yohvwxhyv+DF0GC7HbggCHXkG/XdfeQZbaMgqSsdMF9NbLEkY8PZtBUs55WFDb3JQAj8
	cPU+FcKXNUTXQsOY/oPKFiLLD5aFfMy6iIeadW94dOJDGbFvXMqns3YjPSPaBhvV7btgFi
	tL13Auzd04DQlFvU7yMBmdbjb82Mavk=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=pvHP9auW;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf26.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764931893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0aNk6WgoSVmyUthi2xxqzMYT6K50Z030FubRRIwIgo=;
	b=bnRvyQxRVsryG3t7zoKvPQsZA4eytZAFSyk1WYhDOVFh1UC0EQOaxazvONB5SBkt7YoXuC
	fX7ync8myc0j0EJuA64dsJXLTCrKl0izab6HyvzNrxSblO1xCjh22sqJzF8nKuRMkrM4ge
	tP50ZOi7RLilM5Oyiv2Zw8QgryHyReU=
ARC-Seal: i=1; a=rsa-sha256; t=1764931881; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=lMp9ROJj1zjWnxOhXzpKhNn9HERNCqxwdL91vd4BzrcionxXi4l55ln13r6l+wyeMAyo75i+gs7lez2vc3bQez3dvfTcrIb2QPy3BgS42Z6f7QsJUmI6wxi+Z7v+4HkpYHYGrUVHQAF7w1n8psAIJ2UzosdFCGBmUY1u+Dmw/wE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764931881; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=d0aNk6WgoSVmyUthi2xxqzMYT6K50Z030FubRRIwIgo=; 
	b=li0emkERwFpCxP8Ig1JE48Tr3sld6IGCkZJW6FJlq+kIdccmYQy5LfRBmqtIWQncPBAsq3pm1heBGRp5ssGhAkzbBQRlSYDUTI4aXarL5V7pnjaE70KVg2HwUH4zzFY0LrLKI6UXPtlwuAav70aQAXb8DXl3kOfcbZJTkWO3RdE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764931881;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=d0aNk6WgoSVmyUthi2xxqzMYT6K50Z030FubRRIwIgo=;
	b=pvHP9auWvRir8+fatMnLF3Zf1ggo6NQ9l/Ny3Bp7QUzkGgVEqJLckxkKEmS4+Lj4
	TiBO+tZgRiSBhWOgysXynijtDizlqxriOBUfOoMaTrZ4K56QPwFb/euBnWPndweaU/9
	ATS087e33VTJl7Fco0Who5I1d4+aO86oTaAqEuB0=
Received: by mx.zohomail.com with SMTPS id 1764931879412666.8539055240332;
	Fri, 5 Dec 2025 02:51:19 -0800 (PST)
Message-ID: <edc1773d7d2e36682f607549a1f69b1bc503f72e.camel@mpiricsoftware.com>
Subject: Re: [PATCH v4] lib: xarray: free unused spare node in
 xas_create_range()
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, willy@infradead.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dev.jain@arm.com, janak@mpiricsoftware.com, shardulsb08@gmail.com
Date: Fri, 05 Dec 2025 16:21:13 +0530
In-Reply-To: <d651e943-99f5-431e-a67d-e4e6784e720e@kernel.org>
References: <20251204142625.1763372-1-shardul.b@mpiricsoftware.com>
	 <d651e943-99f5-431e-a67d-e4e6784e720e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.44.4-0ubuntu2.1 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34298140008
X-Stat-Signature: 9zx96wcrcu9b8g9jjn54hab8tzitnx63
X-Rspam-User: 
X-HE-Tag: 1764931893-339684
X-HE-Meta: U2FsdGVkX1/T+z5/CEPa9kDKsN9cViUucBp2nq2T3AbWoyasMfhx/8KeVx5rnFPd2T2CuDn66kwFU7pGmSAGtPWCvFGyZ/TVWEngXEvH11TM1kAkJCuJtxwxE2TfilCRjLLxQ34V4styoG+Z7gO1UXjmVFBfwToAaZC1ElRI3McQr8AURh7PgY77k2D2zn908ItRo93e3wDnCa/qioHWyLXd8Dy04OrdXtT5Nl9kRp2N85QYCZjlka9ILw5Lt/OI7+9C70dTvUkFxWmkqIfkzLZdukZ28NMcOLmqdAdA1tvcyWuIT/wbQvLZZ/ARyT2H9xDNLHMfkvUEwbxQILvw8Pkrkx2iRquH8bmN+LWKo+uEMw+muZi5J7l4ExlWgddfseOZ1j/rHaPYhBFoKNvnufTphC/6TUREAaKF/1YZOfimKslg1+bx6I9Mc24xZTER4to9ycZzAM8Pr7ohHm/6Tft2EcWWeoaHL6UZKH5GjLyRxTQCgTv86sY1pswgmOpxV/5mEeJ8GI6dq8Af3+l1PZ+ioxV6Sxvq04RScMExbDNvpVGWvFB5IuPunGoZrMcfxek8opOvUU7QUYqd4uDN6OZOKyxwK89ztWGg+Ow42Nn7eiBU6yQR7kfCbrapdFuORKCvfx3Pm2fQGMJcU3wz1dgEDKZqGAu/7EjjP7xUbokrHG411nJenLQSxjxunDCVE/apu/aM7imB+2QrBCLI+JFN6VleZRv6/2EFyo79bqtgy8IJA0eEJGe2BDTH7Y0XblztF8ret21hlZ0HUqnsVCT+NtFRHFdV81/trJLFs8aU7LT+5Hv1wq6MzKTrq/NMd+3W9fpcHrsZHqy2hzXiFMGBReuXxdBHLf6XUQlgDCP88vw8oC11XD8GitAMH0KgLp9SHKxAZltNGLC64eHXgXCZq/nz5twtKB3RBCUCVVXdS+QDp2qVb7IDiC6e9Ftl1UkAPCv+IUuu4UYt+Fi
 hP3E60MX
 UJmg2/5UMnesJfSs/Ywy8rTajHuBDALeykdCtnu2oE4VXkXOx7scPsGSC+3Nn1XDKA4xX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCAyMDI1LTEyLTA1IGF0IDA4OjIyICswMTAwLCBEYXZpZCBIaWxkZW5icmFuZCAoUmVk
IEhhdCkgd3JvdGU6Cj4gPiBMaW5rOgo+ID4gaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20v
YnVnP2lkPWEyNzRkNjVmYzczMzQ0OGVkNTE4YWQxNTQ4MWVkNTc1NjY5ZGQ5OGMKPiAuLi4KPiBS
ZXZpZXdlZC1ieTogRGF2aWQgSGlsZGVuYnJhbmQgKFJlZCBIYXQpIDxkYXZpZEBrZXJuZWwub3Jn
Pgo+IAo+IAo+IEJUVywgZG8gd2UgaGF2ZSBhIHdheSB0byB0ZXN0IHRoaXMgaW4gYSB0ZXN0IGNh
c2U/CkhpIERhdmlkLAoKVGhhbmtzIGZvciB0aGUgcmV2aWV3IGFuZCB0aGUgUmV2aWV3ZWQtYnku
CgpSZWdhcmRpbmcgYSB0ZXN0IGNhc2U6IEkgZG9u4oCZdCBoYXZlIGEgZm9jdXNlZCBzZWxmdGVz
dCBvciBmYXVsdC0KaW5qZWN0aW9uIHNldHVwIHlldCB0aGF0IHJlbGlhYmx5IGhpdHMgdGhpcyB4
YXNfbm9tZW0oKSArCnhhc19jcmVhdGVfcmFuZ2UoKSBjb3JuZXIgY2FzZS4gCkkgbm90aWNlZCB0
aGlzIHNwYXJlLW5vZGUgbGVhayB3aGlsZSBhbmFseXppbmcgdGhlIFN5emJvdCByZXBvcnQgSQpy
ZWZlcmVuY2VkIGluIHRoZSBMaW5rOiB0YWcsIGJ1dCB0aGUgcmVwcm9kdWNlciBJIHNlZSB0aGVy
ZSBkb2VzbuKAmXQKaXNvbGF0ZSB0aGlzIHBhdGggYW5kIHJlcG9ydHMgb3RoZXIga21lbWxlYWtz
LgoKRm9yIG5vdyBJ4oCZZCBwcmVmZXIgdG8gdHJlYXQgdGhpcyBhcyBhIHNtYWxsIGNvcnJlY3Ru
ZXNzIGZpeCBpbiB4YXJyYXkKaXRzZWxmLiBJZiBJIG1hbmFnZSB0byBjb21lIHVwIHdpdGggYSBy
b2J1c3Qgd2F5IHRvIGV4ZXJjaXNlIHRoaXMgcGF0aAppbiBhIHNlbGZ0ZXN0IChlLmcuIHZpYSB0
YXJnZXRlZCBmYXVsdCBpbmplY3Rpb24gaW4gbGliL3Rlc3RfeGFycmF5LmMpLApJIGNhbiBmb2xs
b3cgdXAgd2l0aCBhIHNlcGFyYXRlIHBhdGNoLCBidXQgSSBkb27igJl0IGhhdmUgYW55dGhpbmcg
c29saWQKdG8gcHJvcG9zZSB0b2RheS4KCj4gCj4gCj4gQSBmb2xsb3ctdXAgY2xlYW51cCB0aGF0
IGF2b2lkcyBsYWJlbHMgY291bGQgYmUgc29tZXRoaW5nIGxpa2UKPiAodW50ZXN0ZWQpOgo+IAo+
IAo+IGRpZmYgLS1naXQgYS9saWIveGFycmF5LmMgYi9saWIveGFycmF5LmMKPiBpbmRleCA5YThi
NDkxNjU0MGNmLi4zMjVmMjY0NTMwZmIyIDEwMDY0NAo+IC0tLSBhL2xpYi94YXJyYXkuYwo+ICsr
KyBiL2xpYi94YXJyYXkuYwo+IEBAIC03MTQsNiArNzE0LDcgQEAgdm9pZCB4YXNfY3JlYXRlX3Jh
bmdlKHN0cnVjdCB4YV9zdGF0ZSAqeGFzKQo+IMKgwqDCoMKgwqDCoMKgwqAgdW5zaWduZWQgbG9u
ZyBpbmRleCA9IHhhcy0+eGFfaW5kZXg7Cj4gwqDCoMKgwqDCoMKgwqDCoCB1bnNpZ25lZCBjaGFy
IHNoaWZ0ID0geGFzLT54YV9zaGlmdDsKPiDCoMKgwqDCoMKgwqDCoMKgIHVuc2lnbmVkIGNoYXIg
c2licyA9IHhhcy0+eGFfc2liczsKPiArwqDCoMKgwqDCoMKgIGJvb2wgc3VjY2VzcyA9IGZhbHNl
Owo+IMKgIAo+IMKgwqDCoMKgwqDCoMKgwqAgeGFzLT54YV9pbmRleCB8PSAoKHNpYnMgKyAxVUwp
IDw8IHNoaWZ0KSAtIDE7Cj4gwqDCoMKgwqDCoMKgwqDCoCBpZiAoeGFzX2lzX25vZGUoeGFzKSAm
JiB4YXMtPnhhX25vZGUtPnNoaWZ0ID09IHhhcy0KPiA+eGFfc2hpZnQpCj4gQEAgLTcyNCw5ICs3
MjUsMTEgQEAgdm9pZCB4YXNfY3JlYXRlX3JhbmdlKHN0cnVjdCB4YV9zdGF0ZSAqeGFzKQo+IMKg
wqDCoMKgwqDCoMKgwqAgZm9yICg7Oykgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHhhc19jcmVhdGUoeGFzLCB0cnVlKTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoeGFzX2Vycm9yKHhhcykpCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGdvdG8gcmVzdG9yZTsKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCBpZiAoeGFzLT54YV9pbmRleCA8PSAoaW5kZXggfCBYQV9DSFVOS19NQVNLKSkKPiAtwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgZ290byBzdWNjZXNzOwo+
ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBicmVhawo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICh4YXMtPnhhX2luZGV4IDw9IChpbmRleCB8
IFhBX0NIVU5LX01BU0spKSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIHN1Y2NlZXNzID0gdHJ1ZTsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgYnJlYWs7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
fQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHhhcy0+eGFfaW5kZXggLT0gWEFf
Q0hVTktfU0laRTsKPiDCoCAKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBmb3Ig
KDs7KSB7Cj4gQEAgLTc0MCwxNSArNzQzLDE3IEBAIHZvaWQgeGFzX2NyZWF0ZV9yYW5nZShzdHJ1
Y3QgeGFfc3RhdGUgKnhhcykKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB9Cj4g
wqDCoMKgwqDCoMKgwqDCoCB9Cj4gwqAgCj4gLXJlc3RvcmU6Cj4gLcKgwqDCoMKgwqDCoCB4YXMt
PnhhX3NoaWZ0ID0gc2hpZnQ7Cj4gLcKgwqDCoMKgwqDCoCB4YXMtPnhhX3NpYnMgPSBzaWJzOwo+
IC3CoMKgwqDCoMKgwqAgeGFzLT54YV9pbmRleCA9IGluZGV4Owo+IC3CoMKgwqDCoMKgwqAgcmV0
dXJuOwo+IC1zdWNjZXNzOgo+IC3CoMKgwqDCoMKgwqAgeGFzLT54YV9pbmRleCA9IGluZGV4Owo+
IC3CoMKgwqDCoMKgwqAgaWYgKHhhcy0+eGFfbm9kZSkKPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCB4YXNfc2V0X29mZnNldCh4YXMpOwo+ICvCoMKgwqDCoMKgwqAgaWYgKHN1Y2Nlc3Mp
IHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB4YXMtPnhhX2luZGV4ID0gaW5kZXg7
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKHhhcy0+eGFfbm9kZSkKPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgeGFzX3NldF9vZmZzZXQo
eGFzKTsKPiArwqDCoMKgwqDCoMKgIH0gZWxzZSB7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgeGFzLT54YV9zaGlmdCA9IHNoaWZ0Owo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIHhhcy0+eGFfc2licyA9IHNpYnM7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
eGFzLT54YV9pbmRleCA9IGluZGV4Owo+ICvCoMKgwqDCoMKgwqAgfQo+ICvCoMKgwqDCoMKgwqAg
LyogRnJlZSBhbnkgdW51c2VkIHNwYXJlIG5vZGUgZnJvbSB4YXNfbm9tZW0oKSAqLwo+ICvCoMKg
wqDCoMKgwqAgeGFzX2Rlc3Ryb3koeGFzKTsKPiDCoCB9Cj4gwqAgRVhQT1JUX1NZTUJPTF9HUEwo
eGFzX2NyZWF0ZV9yYW5nZSk7Cj4gCj4gCllvdXIgYm9vbC1iYXNlZCB2ZXJzaW9uIHJlYWRzIG5p
Y2VyOyBJ4oCZbSBoYXBweSB0byBmb2xsb3cgdXAgd2l0aCBhCnNtYWxsIGNsZWFudXAgcGF0Y2gg
b24gdG9wIHRoYXQgc3dpdGNoZXMgeGFzX2NyZWF0ZV9yYW5nZSgpIG92ZXIgdG8KdGhhdCBzdHls
ZSAod2l0aCBhIFN1Z2dlc3RlZC1ieSB0YWcpLgoKVGhhbmtzIGFuZCBSZWdhcmRzLApTaGFyZHVs
Cgo=


