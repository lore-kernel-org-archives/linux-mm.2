Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F60CA0ED1
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44C5490011C; Thu, 14 Aug 2025 05:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423E9900088; Thu, 14 Aug 2025 05:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3612490011C; Thu, 14 Aug 2025 05:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25CBA900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:12:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2A9E138407
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:12:17 +0000 (UTC)
X-FDA: 83774796714.01.915B017
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A58020006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:12:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755162736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cdh0zTD/t86eAaBCB5KBD/LSSP761qDBJYGWKjhobFA=;
	b=j/oiz+r26huUjkCRtZWPIFzaI9tI3/Our9W+mYv9JFx39ueStx5EPsPhp7JZgMWuDXnrct
	bYcIOEWUqSzN4VJTUAuCvpnS6PL6Z488YTWALTz3rWPOU5il9GPw1KLAoUvSCLbRtpIaRw
	IFQtLiXq7GwqozYude2n+GL170NTh4M=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755162736; a=rsa-sha256;
	cv=none;
	b=1fBpCsMuyPTAUEUTiXIT1KvqabaCsiMGuhd4EM5oxTueT7hsUo3ib7xCy7fZCHHkoN+fqQ
	e/zd9thA+0Wk3WWFuVma0r7DzQi0mSIcOodbZNgJdYH95lShNqqgrfm499Ow/B+NoET6qF
	vwUQ6vTM0PtUwV25m3ddQ10W30sOkhc=
From: "Li,Rongqing" <lirongqing@baidu.com>
To: David Hildenbrand <david@redhat.com>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "osalvador@suse.de" <osalvador@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?UkU6IFvlpJbpg6jpgq7ku7ZdIFJlOiBbUEFUQ0hdIG1tL2h1Z2V0bGI6IGVh?=
 =?utf-8?B?cmx5IGV4aXQgZnJvbSBodWdldGxiX3BhZ2VzX2FsbG9jX2Jvb3QoKSB3aGVu?=
 =?utf-8?B?IG1heF9odWdlX3BhZ2VzPTA=?=
Thread-Topic: =?utf-8?B?W+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0gbW0vaHVnZXRsYjogZWFybHkg?=
 =?utf-8?B?ZXhpdCBmcm9tIGh1Z2V0bGJfcGFnZXNfYWxsb2NfYm9vdCgpIHdoZW4gbWF4?=
 =?utf-8?B?X2h1Z2VfcGFnZXM9MA==?=
Thread-Index: AQHcDPWdEVeaWFKf20iTJyL51FqmTLRhVBAAgACIHxA=
Date: Thu, 14 Aug 2025 09:12:06 +0000
Message-ID: <8db5f7f3b66a40af8abf921290db42ab@baidu.com>
References: <20250814082950.2888-1-lirongqing@baidu.com>
 <7e88d01a-10bb-4edb-9010-f9c0bca31a46@redhat.com>
In-Reply-To: <7e88d01a-10bb-4edb-9010-f9c0bca31a46@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.22]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.3.13
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A58020006
X-Rspamd-Server: rspam06
X-Stat-Signature: wgbrcmjnca4r587uyu54focba4z1yzi1
X-HE-Tag: 1755162734-194288
X-HE-Meta: U2FsdGVkX1+ldZUZEFMCWy/gl7WtNdchxMK52zeCTvoZeHNq/ym0o1qZrSUJYBAOP/TW+FNKDOZhigSiMmGYpLJWLASefLYAPC5Xo3r9LhS/56+/Y3QHteSHxqfvZdYO/Bugu5XYlMc5S1wi2rcpTbQH1AS5Wjkjeld47fmEo0q+DJdk7Z3koewmmA5pW4EyTPbUnxYz1GHXiDrYPZX5qbS1mqR6/wCLpAvegmoQ4i/zHjVw8Jk7xzpGH9xI60NVbYG7JnW/en+yswoCyrhPrqGDBrZB3yZ0PS0lrfhlkyIUz0Irce2VTEUTzj+kJkVoW1mAACeX88xlexe9TG6xxpz5V5w6Ptiykd5xiD16HOCzRxkmzowlwJEuinfTuieQkmlxjLuX6YytEg8JI2hcBtej+8PlkYEY420ifNLdtBYWD4uGGRSNv7VWOILgLYKINwg2PYSUmOgghm+am/M+d1nmaUynX5b8S6ddJ/8BvI+iv/AvgJ7uUMcAvRamZaDNkD+UZYkzns37KLOuvnwLc7JGPC4cBI4i2h0k4Lk5xh2kihsdFc7NhGD7zy+pBeehn2iBwnWM/Z9If6dOIqFNhM7S1AF3MPPjNjcaP1GEkASZN8nI78GAD1VrCaQ9LV07o4wDw5JM2EpIJSWN2HscqNgRboClKtQEkVtuu0rFNYGfAs76Kp1+bAp7stGFaBalKT9NAfKObN4BUKLEKpvrIXE2hy0tIAHvcpPEVEc8QX66V4jvDJBJjrocJ3gI9b2HGxoPYzJqYKPzN1q1i38yFA83PAvJ3gVsveSFjjiG76LK4B78LrJgSDHjO1T5t5u2Xwp9t++NxOO3DUm9HuluIXeW/7QFMEqfieZt9jIHrlTZG1lHiKgl6ktWoMbnlwVFBSuMIxalpbQfNxBI5fBlBtJKYay7FN6KfBAm5x1k54K1R1PwyptnNAOAfFNbXh9eXuQgo9/cL8I1JgCDYgo
 YUTnbQga
 iYqYrZtsie10Z94SzXRb0u22numNz8LX0QxQatYTj8KtgEaET+ztnibsR1A0cTshia4nt0FztZJr020N1fwaI4Q0RpDiz102nLxW2pWBiz9vIRbLoI5hTA06OYrpv0wMYcKFUI9VHYYnlSE4h1MDQwxn5FnIzIyZJ5B8vMmBGmdrDGLm0xCqoXP3mo5aQB8s3fLhg9tLfME7q4WZVR4Kk7kQlC4+PwG5RcaCs5FANhvkCyWs4EDzVxaDCDI+y++XMArErntY0QAxENnMcYziGpjWdQCi3LIZDM+yEgrU6GnslL5Ex7o8ozxtOltTu1JNlyybyxiO79JhL6ZKEgvyblmA0SpDeDhRNrGXWTuR+805U/VkS6R9rsM3hih9d1ghDH7P8VdZyAwUFSaQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiAxNC4wOC4yNSAxMDoyOSwgbGlyb25ncWluZyB3cm90ZToNCj4gPiBGcm9tOiBMaSBSb25n
UWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4NCj4gPiBPcHRpbWl6ZSBodWdldGxiX3Bh
Z2VzX2FsbG9jX2Jvb3QoKSB0byByZXR1cm4gaW1tZWRpYXRlbHkgd2hlbg0KPiA+IG1heF9odWdl
X3BhZ2VzIGlzIDAsIHNhdmluZyBjeWNsZXMgd2hlbiBodWdlcGFnZXMgYXJlbid0IGNvbmZpZ3Vy
ZWQgaW4NCj4gPiB0aGUga2VybmVsIGNvbW1hbmQgbGluZS4NCj4gDQo+IERvIHdlIHJlYWxseSBj
YXJlPw0KPiANCg0KSSBmaW5kIHRoaXMgd2hlbiBJIHNlZSB0aGUgYm9vdCBsb2csIEkgdGhpbmsg
dGhpcyBsb2cgaXMgdW5uZWNlc3NhcnkgaWYgdXNlciBkaWQgbm90IGNvbmZpZ3VyZSBodWdldGxi
ZnMgaW4ga2VybmVsIGNtZGxpbmUNCg0Ka2VybmVsOiBIdWdlVExCOiBhbGxvY2F0aW9uIHRvb2sg
MG1zIHdpdGggaHVnZXBhZ2VfYWxsb2NhdGlvbl90aHJlYWRzPTMyDQoNCg0KQnINCi1MaQ0KDQo+
IC0tDQo+IENoZWVycw0KPiANCj4gRGF2aWQgLyBkaGlsZGVuYg0KDQo=

