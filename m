Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09731FC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AC86B008A; Thu, 26 Feb 2026 05:11:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 408E86B008C; Thu, 26 Feb 2026 05:11:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 314796B0093; Thu, 26 Feb 2026 05:11:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4636B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:11:12 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3CE75C408
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:11:11 +0000 (UTC)
X-FDA: 84486189942.28.00785C4
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id 743434000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:11:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="M6N/h2qz";
	spf=pass (imf27.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772100669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hZ4kwGEVmfL7JmiI1pOJDdfjg4dkqnPS73mfNeDC/I=;
	b=5PnbjkVot/LavN2DQ33u2CmsIqwXDBnJm+DDcT+GSTTiGQd1N4BAePsLUHl1QZjvPIuNIW
	ZczqXn0CkyFnwNbBbY2d0q1LTP6cY1JA85LxT1IIl5MxVKFocOvvu7bbLgyEsmABDCpWwO
	IKAeV7QMvK9efw2rmTUzLoJ1zicFJx4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="M6N/h2qz";
	spf=pass (imf27.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772100669; a=rsa-sha256;
	cv=none;
	b=nmFFIZItosTkQtCtrMW9iFnqiIgWXVfUkgiB8FeSR1p8gY9xX0AaPC8AmUTtZcPGk00CU+
	XYZD6dkPY5/J4IpP2qux/uYQmJOMoCy5gLl5183UX+3UjvmOgzqoCkNFBON10wHNjqZ/Ic
	VghKS5I7llU0RPjAHGxUJvOhxIeZ/P0=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=6hZ4kwGEVmfL7JmiI1pOJDdfjg4dkqnPS73mfNeDC/I=;
	b=M6N/h2qzSInEkG4dHqvQcZo8VhwMUD6DmjCnrVLf1qWN8TMfBInw5yjOP5Wwpjc979g1ZWo9C
	jLDrVSarWebivHliA5xupFedxMmoht3nx04tDUMRyvVYJsIUf33oUrzfW7s7nO963sNOClsZ/AF
	4fcXf8urU73Km7TszsVC+Zs=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fM6Zt3x4XzYl4J6;
	Thu, 26 Feb 2026 18:07:34 +0800 (CST)
Received: from a008.hihonor.com (10.68.30.56) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 18:11:00 +0800
Received: from w002.hihonor.com (10.68.28.120) by a008.hihonor.com
 (10.68.30.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 18:10:59 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Thu, 26 Feb 2026 18:10:59 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Kairui Song <ryncsn@gmail.com>, Kalesh Singh <kaleshsingh@google.com>
CC: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, linux-mm <linux-mm@kvack.org>, android-mm
	<android-mm@google.com>, Suren Baghdasaryan <surenb@google.com>, "T.J.
 Mercier" <tjmercier@google.com>, Barry Song <21cnbao@gmail.com>, wangtao
	<tao.wangtao@honor.com>, gao xu <gaoxu2@honor.com>, wangxin 00023513
	<wangxin23@honor.com>
Subject: RE: [LSF/MM/BPF TOPIC] Improving MGLRU
Thread-Topic: [LSF/MM/BPF TOPIC] Improving MGLRU
Thread-Index: AQHcps0J+PDZ3nUMx0eaL3unLwaLnrWUwUSQ
Date: Thu, 26 Feb 2026 10:10:59 +0000
Message-ID: <ef2fa069021a4310af8cebfebb1a13d1@honor.com>
References: <CAMgjq7BoekNjg-Ra3C8M7=8=75su38w=HD782T5E_cxyeCeH_g@mail.gmail.com>
 <CAC_TJvfi_5n2crGHbRVO0R8jdYcSCmgzUJPzhtSvWeCN6fCbQg@mail.gmail.com>
 <CAMgjq7BeBEeV1yHYd0fh74m452nOY2sSMbmGBakuiLVRy0CkdQ@mail.gmail.com>
In-Reply-To: <CAMgjq7BeBEeV1yHYd0fh74m452nOY2sSMbmGBakuiLVRy0CkdQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: 743434000B
X-Rspamd-Server: rspam02
X-Stat-Signature: pqkhkghhackhp1d8niwjeqd8myn56rtq
X-HE-Tag: 1772100668-370035
X-HE-Meta: U2FsdGVkX18NoTVMwV+XFIrcu7Eoc4ifZ4uFtSeeD2a3d2prSJJdGlG/1nEw/z64PNbewDiTtCeh00iCW05aAcLqfhv7JFrDAWg6Kc9pDmYBYpwEjI436rgnUzy3LfUiHbNTIKli0RHG+o0n1Y/TDWKt45JkrPxrekySnCyBZ2OyVgRturz84o5fZX0IPd6bgAuVcdperZErIN2uCKF94XPkSc6KwAfyLGtm2YvrkY02dEnA3rfsHkUYngZG+CyQwhmfVX/rcmPn5aDIMj4sbC1IWSB3hhPlbNqXhLq3EheWFRMW3s/6YdK5Q/Cbx/AgqpHQppSwI5urTjIYvFcH042WeXydGl+IGu0sVJ++7y/U1Eha00LjUq+5H4pGHoTelQRCjIRV8X3FnGhjDLKGSVTl8sAly30/Y53kBcTQc52TztsyTl4lp5wO7sJpoA+5Q7pn5H+C5V2R/vDJgsUpeJyRkcUOkkD7Bqo1UG6QV/8dDGuo5fRVyz0obkHe4USUKYkVFJyhAmUq5gm2WQ3WdL3Y/SIIZFikGxJB435Q7fEsVdnI4rzoJbco1QYCawL4XyXe/70fbCMnIUSISM1oXQToPKd0HTGAmD3Lcm2oNviz0/TSIQVYVu1WelAqxEaYr33jZMcEeAnceH1M7Bl06/J4NA3foc7TVBENCTSCHxJUO3xYR+RB3yja6KWLwpnTuUqo2DnBHO4XHYIvBmbtjAGBTiqfL0+upmdVrtcQzGDU6rB5LULte0TMAy4pJvyeaR9BWQOcQ0RjctzSvlDXz3+ne+pFCY9SPQQBT7iJ/j/fVix16mEe392Ske3klsBsFVqe5t642jq5Gl2MxN+mTozr3ztlLO/mAjxGNN8BI5lIiEoloS7ST4yXjai2HraBxDGr0w6a9oCmdeNCl8UfNHuYQQODX85SebbrVl33/ofUj7i4IP27XlvhNhK0/x2gv7hTFdQOerdiVli06fG
 Ko9HRUT5
 qXntii/QGWZa9WrfS7zfVJ21ow/gXhdwHbGYDdWtsIVzzHmnmjrAtydxhmlMjg+yJa2aLEhRhQkpW6n4sX+b9LdgnH+jK9AhpDnXt22zR9NmmmN+ijMJ/GaGQusf4rAF74K+odHhYrJe6qnuQlGKMDieKVYsWQz8psWIQFCev5yvaHl7dSD9JCoWTQ4q2vEv+X03L2/EashlhseF1heHxjFhMsgBMSH5cgwomtRFKFb8Y5pP0FewaIfFPbw9hQUKZojJUy0Qm2pd2wubyqAkNg64fcLcbeAJpE19YnDcVVQ6zb5brUN+NUKHz1ufAY56lsffNt/TRNYLt5R7f9wo9R9Xq9y3nTJcnWjWB8OPLKmdSADDSzvAVnGOvmkgnfA2ZNSm9v8u/oCjGGr3Y1ZIj8R0/QouqFfT9vGgsCtpuzzWC9hQcpyhO69Tr+b7oE1WGELn8F0e5mwuuVYDTstovcDKHeWAC/6RE2rC16SvkTX5zNuDXHCL4FBWw8XYAD6K7L4FMIXUc6cHrC5bkicixQKYNVJO/lCJNY/2wcsLeYID/82CTjlZ27yQcnSI+33wO/rJk9qfj/N3inQ02feuBqEyK5pSSnTr2QmnIDUhjPU6ldFGOo7WyrzT+ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS2FpcnVpIFNvbmcgPHJ5
bmNzbkBnbWFpbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAyNiwgMjAyNiAxMTow
NyBBTQ0KPiBUbzogS2FsZXNoIFNpbmdoIDxrYWxlc2hzaW5naEBnb29nbGUuY29tPjsgd2FuZ3pp
Y2hlbmcNCj4gPHdhbmd6aWNoZW5nQGhvbm9yLmNvbT4NCj4gQ2M6IGxzZi1wY0BsaXN0cy5saW51
eC1mb3VuZGF0aW9uLm9yZzsgQXhlbCBSYXNtdXNzZW4NCj4gPGF4ZWxyYXNtdXNzZW5AZ29vZ2xl
LmNvbT47IFl1YW5jaHUgWGllIDx5dWFuY2h1QGdvb2dsZS5jb20+OyBXZWkNCj4gWHUgPHdlaXh1
Z2NAZ29vZ2xlLmNvbT47IGxpbnV4LW1tIDxsaW51eC1tbUBrdmFjay5vcmc+OyBhbmRyb2lkLW1t
DQo+IDxhbmRyb2lkLW1tQGdvb2dsZS5jb20+OyBTdXJlbiBCYWdoZGFzYXJ5YW4gPHN1cmVuYkBn
b29nbGUuY29tPjsNCj4gVC5KLiBNZXJjaWVyIDx0am1lcmNpZXJAZ29vZ2xlLmNvbT47IEJhcnJ5
IFNvbmcgPDIxY25iYW9AZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW0xTRi9NTS9CUEYgVE9Q
SUNdIEltcHJvdmluZyBNR0xSVQ0KPiANCj4gT24gVGh1LCBGZWIgMjYsIDIwMjYgYXQgOTo1NeKA
r0FNIEthbGVzaCBTaW5naCA8a2FsZXNoc2luZ2hAZ29vZ2xlLmNvbT4NCj4gd3JvdGU6DQo+ID4N
Cj4gPiBPbiBUaHUsIEZlYiAxOSwgMjAyNiBhdCA5OjI24oCvQU0gS2FpcnVpIFNvbmcgPHJ5bmNz
bkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IEhpIEFsbCwNCj4gPiA+DQo+ID4gPiBB
cG9sb2dpZXMgSSBmb3Jnb3QgdG8gYWRkIHRoZSBwcm9wZXIgdGFnIGluIHRoZSBwcmV2aW91cyBl
bWFpbCBzbw0KPiA+ID4gcmVzZW5kaW5nIHRoaXMuDQo+ID4gPg0KPiA+ID4gTUdMUlUgaGFzIGJl
ZW4gaW50cm9kdWNlZCBpbiB0aGUgbWFpbmxpbmUgZm9yIHllYXJzLCBidXQgd2Ugc3RpbGwgaGF2
ZQ0KPiB0d28gTFJVcw0KPiA+ID4gdG9kYXkuIFRoZXJlIGFyZSBtYW55IHJlYXNvbnMgTUdMUlUg
aXMgc3RpbGwgbm90IHRoZSBvbmx5IExSVQ0KPiBpbXBsZW1lbnRhdGlvbiBpbg0KPiA+ID4gdGhl
IGtlcm5lbC4NCj4gPiBIaSBLYWlydWksDQo+ID4NCj4gPiBJIHdvdWxkIGJlIHZlcnkgaW50ZXJl
c3RlZCBpbiBqb2luaW5nIHRoaXMgZGlzY3Vzc2lvbiBhdCBMU0YvTU0uDQo+ID4NCj4gPiBXZSB1
c2UgTUdMUlUgb24gQW5kcm9pZC4gV2hpbGUgdGhlIHJlZHVjZWQgQ1BVIHVzYWdlIGxlYWRzIHRv
IHBvd2VyDQo+ID4gaW1wcm92ZW1lbnRzIGZvciBtb2JpbGUgZGV2aWNlcywgd2UndmUgcnVuIGlu
dG8gYSBmZXcgbm90YWJsZSBpc3N1ZXMNCj4gPiBhcyB3ZWxsLg0KPiANCj4gSGkgS2VsYXNoLA0K
PiANCj4gR2xhZCB0byBkaXNjdXNzIHRoaXMgd2l0aCB5b3UuDQo+IA0KPiA+DQo+ID4gT2ZmIHRo
ZSB0b3Agb2YgbXkgaGVhZDoNCj4gPg0KPiA+IDEuIERpcmVjdCBSZWNsYWltIExhdGVuY3k6IFdl
J3ZlIG9ic2VydmVkIHRoYXQgZGlyZWN0IHJlY2xhaW0gdGFpbA0KPiA+IGxhdGVuY2llcyBjYW4g
c29tZXRpbWVzIGJlIHNpZ25pZmljYW50bHkgaGlnaGVyIHdpdGggTUdMUlUuDQo+ID4NCj4gPiAy
LiBQU0kgYW5kIE9PTSBSZXNwb25zZTogVHlpbmcgZGlyZWN0bHkgaW50byB5b3VyIHBvaW50IGFi
b3V0IG1ldHJpY3MsDQo+ID4gdGhlIFBTSSBtZW1vcnkgcHJlc3N1cmUgZ2VuZXJhdGVkIGJ5IE1H
TFJVIGlzIGNvbnNpc3RlbnRseSAzMCUgdG8gNDAlDQo+ID4gbG93ZXIgdGhhbiB0aGUgQWN0aXZl
L0luYWN0aXZlIExSVSBvbiBBbmRyb2lkIHdvcmtsb2Fkcy4gQmVjYXVzZQ0KPiA+IHVzZXItc3Bh
Y2UgT09NIGRhZW1vbnMgbGlrZSBsbWtkIHJlbHkgaGVhdmlseSBvbiB0aGVzZSBtZXRyaWNzLCB0
aGlzDQo+ID4gY2F1c2VzIHRoZW0gdG8gYmUgbGVzcyBxdWljayB0byByZWFjdCB0byBhY3R1YWwg
bWVtb3J5IHByZXNzdXJlLg0KPiANCj4gWWVzLCB0aGlzIGlzIG9uZSBvZiB0aGUgbWFpbiBpc3N1
ZXMgZm9yIHVzIHRvby4gUGVyIG91ciBvYnNlcnZhdGlvbg0KPiBvbmUgY2F1c2UgZm9yIHRoYXQg
aXMgTUdMUlUncyB1c2FnZSBvZiBmbGFncyBsaWtlIFBHX3dvcmtpbmdzZXQgaXMNCj4gZGlmZmVy
ZW50IGZyb20gYWN0aXZlIC8gaW5hY3RpdmUgTFJVLCBhbmQgZmxhZ3MgbGlrZSB0aGUgUEdfd29y
a2luZ3NldA0KPiBmbGFncyBhcmUgYm91bmQgd2l0aCB0aWVyaW5nIG5vdywgc28gY2hhbmdpbmcg
dGhhdCByZXF1aXJlcyBzb21lDQo+IHJlZGVzaWduIG9mIGhvdyB0aWVyaW5nIHdvcmtzIHRvby4g
V2hpY2ggaXMgb25lIG9mIHRoZSBtb3RpdmF0aW9ucw0KPiBiZWhpbmQgdGhlIExGVSBsaWtlIHRp
ZXJpbmcgZGVzaWduIEkgbWVudGlvbmVkLiBUaGF0IHNob3VsZCBtYWtlDQo+IHRoaW5ncyBsaWtl
IFBTSSBvciByZWFkYWhlYWQgc3RhYmxlIGFnYWluLg0KPiANCj4gPiAzLiBNaXNsZWFkaW5nIENv
bnZlbnRpb25hbCBMUlUgTWV0cmljczogV2UndmUgbm90aWNlZCBwYXR0ZXJucyBpbg0KPiA+IHN0
YW5kYXJkIG1lbW9yeSB0cmFja2luZyB3aGVyZSBucl9hY3RpdmUgYW5kIG5yX2luYWN0aXZlIHNo
b3cgc2hhcnANCj4gPiB2ZXJ0aWNhbCBjbGlmZnMgYW5kIHJpc2VzLiBTaW5jZSBNR0xSVSBkZXJp
dmVzIHRoZXNlIG1ldHJpY3MgYnkNCj4gPiBtYXBwaW5nIHRoZSB0d28geW91bmdlc3QgZ2VuZXJh
dGlvbnMgdG8gImFjdGl2ZSIgYW5kIHRoZSB0d28gb2xkZXN0IHRvDQo+ID4gImluYWN0aXZlLCIg
ZXZlcnkgdGltZSBhIG5ldyBnZW5lcmF0aW9uIGlzIGNyZWF0ZWQgKGluY3JlbWVudGluZyB0aGUN
Cj4gPiBzZXEgY291bnRlciksIHRoZSBzZWNvbmQgeW91bmdlc3QgZ2VuZXJhdGlvbiAoYmVmb3Jl
IHRoZSBpbmNyZW1lbnQpIGlzDQo+ID4gc3VkZGVubHkgcmVjYXRlZ29yaXplZCBhcyBpbmFjdGl2
ZSAoYWZ0ZXIgdGhlIGluY3JlbWVudCkuIEJlY2F1c2UgdGhlDQo+ID4gbmV3bHkgY3JlYXRlZCBn
ZW5lcmF0aW9uIGlzIGVtcHR5LCB0aGlzIG1hbmlmZXN0cyBhcyBhIG1hc3NpdmUsDQo+ID4gaW5z
dGFudGFuZW91cyBkcm9wIGluIGFjdGl2ZSBwYWdlcyBhbmQgYSBjb3JyZXNwb25kaW5nIHNwaWtl
IGluDQo+ID4gaW5hY3RpdmUgcGFnZXMuDQo+IA0KPiBUaGF0J3MgYWxzbyBhIG1ham9yIHByb2Js
ZW0gZm9yIHRoaW5ncyBsaWtlIEs4cy4gVGhlIGNsaWZmcyBhbmQgcmlzZXMNCj4gY29uZnVzZXMg
dGhlIGNsb3VkIHNjaGVkdWxlci4gT3VyIHNvbHV0aW9uIGlzIGFsc28gYmFzZWQgb24gdGhhdCBu
ZXcNCj4gdGllcmluZyBkZXNpZ24sIGFuZCBjb3VudGluZyB0aGUgbnVtYmVyIG9mIGZvbGlvcyBp
biBkaWZmZXJlbnQgdGllcnMNCj4gaW5zdGVhZCBvZiBnZW5zIHdpbGwgZ3JlYXRseSBpbXByb3Zl
IHRoZSB1c2FiaWxpdHkgb2YgbnJfYWN0aXZlIC8NCj4gbnJfaW5hY3RpdmUuIFdoZXRoZXIgdGhp
cyBpcyBhIGdvb2QgZGVzaWduIGNhbiBiZSBkaXNjdXNzZWQuDQo+IA0KPiA+DQo+ID4gSSdkIGxv
dmUgdG8gcGFydGljaXBhdGUgYW5kIGRpc2N1c3MgaG93IHdlIG1pZ2h0IHRhY2tsZSB0aGVzZQ0K
PiA+IHJlZ3Jlc3Npb25zIGFuZCBtZXRyaWNzLg0KPiANCj4gTG9va2luZyBmb3J3YXJkIHRvIHRo
YXQhDQo+IA0KPiBJIGFsc28gbm90aWNlZCBaaWNoZW5nIGhhcyBhbm90aGVyIHByb3Bvc2FsLCBJ
J3ZlIGRpc2N1c3NlZCB3aXRoIGhpbQ0KPiB0b28gcHJldmlvdXNseSBhYm91dCBzb21lIGlkZWFz
LCBob3BlZnVsbHkgd2Ugd2lsbCBtYWtlIHNvbWUgcHJvZ3Jlc3MNCj4gb24gdGhpcy4NCg0KSGkg
S2FpcnVpLCBoaSBLYWxlc2gsDQoNClllcywgd2XigJlyZSBpbnRlcmVzdGVkIGluIHRoaXMgd29y
ay4NCg0KV2Ugc2VlIGZpbGUgcGFnZXMgYmVpbmcgdW5kZXItcHJvdGVjdGVkIGluIHNtYXJ0cGhv
bmUgd29ya2xvYWQsIGFuZCBhbiBMRlUtbGlrZQ0KYXBwcm9hY2ggc291bmRzIHByb21pc2luZyB0
byBiZXR0ZXIgcHJvbW90ZSBhbmQgcHJvdGVjdCBob3QgZmlsZSBwYWdlcy4NCkthaXJ1aSBoYXMg
c2hhcmVkIHRoZSBwYXRjaGVzOyB3ZeKAmWxsIGJhY2twb3J0IHRoZW0gdG8gb3VyIHRyZWUgYW5k
IHJlcG9ydCBiYWNrDQpvbmNlIHdlIGhhdmUgcmVzdWx0cyBmcm9tIG91ciB3b3JrbG9hZHMuDQoN
CkJlc3QsDQpaaWNoZW5nDQoNCg==

