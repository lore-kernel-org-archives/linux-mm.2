Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C60D73E87
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5D76B0088; Thu, 29 Jan 2026 19:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88CE36B0089; Thu, 29 Jan 2026 19:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AC5B6B008A; Thu, 29 Jan 2026 19:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5BD6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:29:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F747B9559
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:29:13 +0000 (UTC)
X-FDA: 84386745786.17.158F8E0
Received: from out203-205-221-192.mail.qq.com (out203-205-221-192.mail.qq.com [203.205.221.192])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5862E20009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:29:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="Fw8nxr/n";
	spf=pass (imf03.hostedemail.com: domain of shengminghu512@qq.com designates 203.205.221.192 as permitted sender) smtp.mailfrom=shengminghu512@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769732951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aCbldkPWDDDUKUh1xdZelu6yUIrmPWNqD/yMJVqg5Mk=;
	b=oSp0xwPlwZgfs/yZc/01wz7sdDalM4EGCNYCIc//H9xBSccYMZKbzMTgmbY/a5QXLqBSMs
	w/V46A2wZUq61YnW3/Sc4iN/nQ7A8bhiswfNZRRH5xPxJr84U6T2u+irU+oP4na3yrRtx2
	r0G/D7TkWnbH/p4YD9eHARItaS5gG5c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b="Fw8nxr/n";
	spf=pass (imf03.hostedemail.com: domain of shengminghu512@qq.com designates 203.205.221.192 as permitted sender) smtp.mailfrom=shengminghu512@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769732951; a=rsa-sha256;
	cv=none;
	b=OKZrTtaO3SZXtDytQp0oJXWEH8avEUbc9yMmFykuhr5KvtbpgZFQDpnOEH99w223BQv5Ce
	ZOLG0K5L1NSUc1tvAzCGj708mScuczTmfanWCy+zav+f5PObdO0h/4LT5HwDiDm7jpOz3n
	hpB5UurVkV/vS+wueq0AsGMtVS+LFNE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1769732946; bh=aCbldkPWDDDUKUh1xdZelu6yUIrmPWNqD/yMJVqg5Mk=;
	h=From:To:Cc:Subject:Date:References:In-Reply-To;
	b=Fw8nxr/njtdTLGUlUxzwBI0NjCI060JS0/eA+iTPZ3ecOjw+6rtd+vCoIQOADMOgr
	 /QcSlj2zK1a+8X3Q5SrZfxBvhHv5QC0JKoGig8bKP8CJRzWsDt076SvKJZ9+ynF+wi
	 cRQf+adeAZ6LtuBM8eTMtpAocZv8Qy2wlDnG5IfE=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-XMAILINFO: NjP9ocx9gc745POsmID55Q4NoR2YxCUys2mSSg1rBGt/aYCfikevtI7y3RoQ/q
	 LP+GIsugKmbTRMntkTUDzxTSxHaQLx0azrs1H7h86X6pxNHYSV+TNnTZN7G+shTmNGObl5MBhuPS9
	 R8PlhjrCu9yRdNF+9giDBh8LBvdXz4EKwgTewUddBZvqoGXLrA2NoUrmpBpndz8pRmNo9W75+ktiG
	 QXizrPu366qw3VznR6YPfYJe9RyrDnlcT7ZM/I2gO3V2F/5aqk1FN6cWWky3bb2IDlNerUbCbhAI2
	 hWwhAncnNlflLIFbSvDdlFOF5vQ/u3Tk6E054dNsppTuNs5XvESb7JOgJQn+flpv9Bma6qvkG6tAz
	 tomuhCSgeb2wNtBGrZQkgJ+MikB6wwjZMefxbAJRBnjidmX2CO94HHyQ2R28BuPM1ONBdmc9y3OTh
	 XEmj+OhzvIGxqzwEcGnuCrbpfyK8VSf+zfQ+zzQWCUaPR9IUiL5VEyRB8HGRNKRlKkedlD6sJtwQ5
	 HI4EGZDWveWWWA5QUnIrBFCDuABaqlOKM2Y1Ce/s9BzkB4uwD0UZpnkR1e3qzqcr2ldB9vUxGw8fQ
	 YCW1FBDUaXF9ut1rrbuN4H5HyFBk5KvAkoSIvmwybQbvT2ThVdCcQtDjUx6qk2lhcWxDpFzY0kEzl
	 yVEPDBlJ0CdGcePY0vT9Ux8U0LfsNvDUNkPzp58PE7mSKHTvkw3nisD51BaTa7FK3xAQeGizoMDd/
	 +csbWsgbKBxItwdyJXKr9IKA3IFd1Jfk2y+IU/LE0OOI/xQ2wA3qBdWkVxpc/UyX04mRjbuYeDjcg
	 pDvdXH/5MtQEgdNkl0J7e3u7kBL6e4xDiEIlQ8n/XCXuPGt2BSXUt8T/8UWqnS8+UrkSzOPFJdgTU
	 zu/8AB7T+EJTwX16JqXG6XUjCAPeRaxSk1CHd7BriOjmCa3OB10s6PJKu6KnbEZ5QIi8ksZfKSm6x
	 WLSU7Cn9ZbQgDbx9cHNfkOIC9YUjlnnOfshuKJWGZ7G1AVbFv9y9TdYo2ESlsPCpwwPrzCJN6u7An
	 pQ3cHwYW6WeGJv3ZZg0BiEh0M2Q==
From: "=?utf-8?B?c2hlbmdtaW5naHU1MTI=?=" <shengminghu512@qq.com>
To: "=?utf-8?B?QW5kcmV3IE1vcnRvbg==?=" <akpm@linux-foundation.org>
Cc: "=?utf-8?B?dmJhYmth?=" <vbabka@suse.cz>, "=?utf-8?B?c3VyZW5i?=" <surenb@google.com>, "=?utf-8?B?bWhvY2tv?=" <mhocko@suse.com>, "=?utf-8?B?amFja21hbmI=?=" <jackmanb@google.com>, "=?utf-8?B?aGFubmVz?=" <hannes@cmpxchg.org>, "=?utf-8?B?eml5?=" <ziy@nvidia.com>, "=?utf-8?B?bGludXgtbW0=?=" <linux-mm@kvack.org>, "=?utf-8?B?bGludXgta2VybmVs?=" <linux-kernel@vger.kernel.org>, "=?utf-8?B?aHUuc2hlbmdtaW5n?=" <hu.shengming@zte.com.cn>, "=?utf-8?B?emhhbmcucnVu?=" <zhang.run@zte.com.cn>
Subject: Re: [PATCH linux-next] mm/page_alloc: avoid overcounting bulk allocin watermark check
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64
Date: Fri, 30 Jan 2026 08:29:05 +0800
X-Priority: 3
Message-ID: <tencent_BAE640F74B4B0434E930276D1AD12E67FB08@qq.com>
X-QQ-MIME: TCMime 1.0 by Tencent
X-Mailer: QQMail 2.x
X-QQ-Mailer: QQMail 2.x
References: <tencent_F36C5B5FB4DED98C79D9BDEE1210CD338C06@qq.com>
	<20260129141057.b577100c834c726f01a602b9@linux-foundation.org>
In-Reply-To: <20260129141057.b577100c834c726f01a602b9@linux-foundation.org>
X-QQ-mid: xmsepub7-0t1769732945tq0l74hr5
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5862E20009
X-Stat-Signature: xc176wjkfpqz4dzu87qc1r1g9h3iz3ta
X-Rspam-User: 
X-HE-Tag: 1769732950-734509
X-HE-Meta: U2FsdGVkX1+PJp6X28QmQQutBC02/TjxoeV5GWfgfpismYkP4KqRapSIeIRBSLo+eXE5W2UNjy2CJJGjvUXp76hvA8ZbKs3cIXePXulIK+Q11fpIHEDXoPZ72THxZ/ZJtpmb5SBA2g9Z2cmzWRGf2CdKnj2jXkZ4U0sh9gOU15kx5qTvi9sdhtlmL5PN4UYD6sVkVq+5swVal/k5o4+1aYrV/zADRbkdixHENT84KeZKGzTIL9qy//BD6dL9FNP6M7lV4+z8cEl+jiSfqONQ4dAMAAPhkr5w1k0tdR1xofz4vtiQYvjyqcBK92gIUrSuVbN7fe+T4jjYpBnLv1oYxPGY2h/iYObjMQgz4hr6Tq226aDTTiLU/7oZcmPaONlHmXmW83N2C3Ftx/z5VA4A5VLOcHGkgaEJgtuXs50/MczKabqDrQrGkqcdZ3CZoN+WCuy/zKrRpdvwSfc7HPkTckpvuolEllrRDX/4ifqUiQ6cFCaguAXAwjJou6Z0qeS1Gn8yAOUGHbU/Q27HnB4oInjCU9ExDIcAbBdCczP6MIzxUzcni7AsZHLpgLWxizYJ3tti19xVAnyZ6JLq9thgOgzOhx/AIgeognd/GzG9fbbngerScrPWqNeduoklj0phBfORK1Ecux3UlbiQfWDnRDWNQgKz93WdDtXE9DXq6cgO0fVVILnfyjwJgnWNk2lGmzZfRw+t4v4cFDi9sX9CBnQsidLglsA8VocUIqKtsm4Bp8hO6TnRrSCEH/AskqO6dTflZ6ZcPb9l5EFEyAG7oqlYd6mosMbmBw37rbupw7iq/UgahkPOmopWfuVMhc7UJRdNNNbAfLWPrsv9ZiNl2gEPP9s+tS2UUaV80Nf3YEqHSe2X3zapE7uI9Br5Xtr7bR0chm8O6L0LulTVuHwq7UIAypSPeSHBae27dJxLHblCfC0ZfVFxwWKH+TPsRDbckOpH3icWiXZRN2Tq0aA
 xlBUilRQ
 P2eixHg6qod3LS1PbXbOeQ8/q1B9YxsG9Hw3x3eue2TuxN6JgT5dSFTIUH0gVEgYYUF/uQ8SEMx0SJW7xYhMfhBovvE7PP/sObLCZXIr2+9TyGBDrotgLrisuNJhWINRLgovR1a1hPLy+AIU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiBUaHUsIDI5IEphbiAyMDI2IDIyOjM4OjE0ICswODAwICJzaGVuZ21pbmdodTUxMiIg
PHNoZW5nbWluZ2h1NTEyQHFxLmNvbT4gd3JvdGU6DQo+IA0KPiA+IEZyb206IFNoZW5nbWlu
ZyBIdSA8aHUuc2hlbmdtaW5nQHp0ZS5jb20uY24+DQo+ID4gDQo+ID4gYWxsb2NfcGFnZXNf
YnVsa19ub3Byb2YoKSBvbmx5IGZpbGxzIE5VTEwgc2xvdHMgYW5kIGFscmVhZHkgdHJhY2tz
IGhvdyBtYW55DQo+ID4gZW50cmllcyBhcmUgcHJlLXBvcHVsYXRlZCB2aWEgbnJfcG9wdWxh
dGVkLg0KPiA+IA0KPiA+IFRoZSBmYXN0IHdhdGVybWFyayBjaGVjayB3YXMgYWRkaW5nIG5y
X3BhZ2VzIHVuY29uZGl0aW9uYWxseSwgd2hpY2ggY2FuDQo+ID4gb3ZlcmVzdGltYXRlIHRo
ZSBkZW1hbmQuIFVzZSAobnJfcGFnZXMgLSBucl9wb3B1bGF0ZWQpIGluc3RlYWQsIGFzIGFu
IA0KPiA+IHVwcGVyIGJvdW5kIG9uIHRoZSByZW1haW5pbmcgcGFnZXMgdGhpcyBjYWxsIGNh
biBzdGlsbCBhbGxvY2F0ZSB3aXRob3V0DQo+ID4gc2Nhbm5pbmcgdGhlIHdob2xlIGFycmF5
Lg0KPiANCj4gVGhhbmtzLg0KPiANCj4gPiAtLS0gYS9tbS9wYWdlX2FsbG9jLmMNCj4gPiAr
KysgYi9tbS9wYWdlX2FsbG9jLmMNCj4gPiBAQCAtNTEzMCw3ICs1MTMwLDcgQEAgdW5zaWdu
ZWQgbG9uZyBhbGxvY19wYWdlc19idWxrX25vcHJvZihnZnBfdCBnZnAsIGludCBwcmVmZXJy
ZWRfbmlkLA0KPiA+ICANCj4gPiAgIGNvbmRfYWNjZXB0X21lbW9yeSh6b25lLCAwLCBhbGxv
Y19mbGFncyk7DQo+ID4gIHJldHJ5X3RoaXNfem9uZToNCj4gPiAtIG1hcmsgPSB3bWFya19w
YWdlcyh6b25lLCBhbGxvY19mbGFncyAmIEFMTE9DX1dNQVJLX01BU0spICsgbnJfcGFnZXM7
DQo+ID4gKyBtYXJrID0gd21hcmtfcGFnZXMoem9uZSwgYWxsb2NfZmxhZ3MgJiBBTExPQ19X
TUFSS19NQVNLKSArIG5yX3BhZ2VzIC0gbnJfcG9wdWxhdGVkOw0KPiA+ICAgaWYgKHpvbmVf
d2F0ZXJtYXJrX2Zhc3Qoem9uZSwgMCwgIG1hcmssDQo+ID4gICB6b25lbGlzdF96b25lX2lk
eChhYy5wcmVmZXJyZWRfem9uZXJlZiksDQo+ID4gICBhbGxvY19mbGFncywgZ2ZwKSkgew0K
PiANCj4gU28gdGhhdCBsaXR0bGUgb3B0aW1pemF0aW9uIGhhc24ndCBiZWVuIHdvcmtpbmcg
Zm9yIGZvdXIgeWVhcnM/DQoNClllYWgsIGxvb2tzIGxpa2UgaXTigJlzIGJlZW4gY29uc2Vy
dmF0aXZlIGZvciBhIGxvbmcgdGltZSA6KQ0KDQpJdCBkaWRu4oCZdCBicmVhayBjb3JyZWN0
bmVzcywgYnV0IGl0IGxpa2VseSBtYWRlIHRoZSBmYXN0IHdhdGVybWFyayBjaGVjaw0KbGVz
cyBlZmZlY3RpdmUgYnkgb3ZlcmVzdGltYXRpbmcgZGVtYW5kIChjb3VudGluZyBhbHJlYWR5
LXBvcHVsYXRlZCBlbnRyaWVzDQphZ2FpbiksIHNvIHdl4oCZZCBkcm9wIG91dCBvZiBgem9u
ZV93YXRlcm1hcmtfZmFzdCgpYCBlYXJsaWVyIGFuZCBoaXQgdGhlDQpzbG93IHBhdGggbW9y
ZSBvZnRlbi4NCg0KLS0NCldpdGggQmVzdCBSZWdhcmRzLA0KU2hlbmdtaW5nDQo=


