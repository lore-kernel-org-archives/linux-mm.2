Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4111093178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 05:49:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F35D6B03D2; Fri, 20 Mar 2026 01:49:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AA836B03D4; Fri, 20 Mar 2026 01:49:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA466B03D6; Fri, 20 Mar 2026 01:49:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37C096B03D2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:49:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC6E01608A6
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:48:59 +0000 (UTC)
X-FDA: 84565362798.21.E9FDE3B
Received: from outbound.baidu.com (jpmx.baidu.com [119.63.196.201])
	by imf12.hostedemail.com (Postfix) with SMTP id CFC9740007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:48:53 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=CvyLpR4s;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=md1533A93B40=lirongqing@baidu.com" designates 119.63.196.201 as permitted sender) smtp.mailfrom="prvs=md1533A93B40=lirongqing@baidu.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773985737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9g866NgVget0oa0rBxdfszMt1l12uESnpWQuAC7DtQA=;
	b=EOBucgrq7jFbBF+I4gD96J64116gxa5ivz2EcG3+PgBkSvDGsCFP6DtefWdVq/boP8AftG
	GXN659ACCyYvVV0cMeynXn/aIW/vf0gRQYBSCXksDjc02DO9DyTg3CzqvKzITr0FagR9Sk
	NrXkeeK+g4i0zgocDvbG7u14nUs/5jU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=CvyLpR4s;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf12.hostedemail.com: domain of "prvs=md1533A93B40=lirongqing@baidu.com" designates 119.63.196.201 as permitted sender) smtp.mailfrom="prvs=md1533A93B40=lirongqing@baidu.com"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773985737; a=rsa-sha256;
	cv=none;
	b=StWrdahxeTx9QfQsLm6e4KJQ0/6AoUIIdJ0Kfa4ylwGjl6rcM35lsyAap6cSBTSKjgE25I
	sF66A1tEmhIL6EkODKHFsDqako2fP8BulGXkAGBaIE2Sa0Ke5JpMiJ8zbsHwZmBJdSwTKF
	+PB7ck8Hm7SQnqsSQI3bzNsaCd//KX4=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.3.13
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: Uladzislau Rezki <urezki@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiA/PzogWz8/Pz9dIFJlOiBbUEFUQ0ggdjJdIG1t?=
 =?gb2312?B?L3ZtYWxsb2M6IHVzZSBkZWRpY2F0ZWQgdW5ib3VuZCB3b3JrcXVldWUgZm9y?=
 =?gb2312?Q?_vmap_area_draining?=
Thread-Topic: [????] Re: ??: [????] Re: [PATCH v2] mm/vmalloc: use dedicated
 unbound workqueue for vmap area draining
Thread-Index: AQHct3QMp/kETo0hbEihIC1lF1Yk9rW1E6OAgACG9xD//7eRgIABXptA
Date: Fri, 20 Mar 2026 05:48:46 +0000
Message-ID: <b85047633c5b47c19db52d68001d632f@baidu.com>
References: <20260319074307.2325-1-lirongqing@baidu.com>
 <abvEZehbufg4amhQ@pc636> <73a0ae8d2a334777a199a1555d6fdaaa@baidu.com>
 <abv42QtTuwJCv1St@milan>
In-Reply-To: <abv42QtTuwJCv1St@milan>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.27]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1773985730;
	bh=9g866NgVget0oa0rBxdfszMt1l12uESnpWQuAC7DtQA=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=CvyLpR4slypu232yVW92CdrD9XrnaYa54vX9Ptbf8ZskEzrykBocjH5cAz/+MRa76
	 CoHyjZlJVm/PgmSoL+Nv2qv1W7w4T2e+PDJqZ8Y2X3UOZPUeH9Cl4LMN4UjjCGKg7e
	 zeNAHacnKEF+kZgSAzb5vgf3YmwzSP+8Ld/WUERi9V5Ty4NArDCI1vvQ0K26Ay5nVB
	 bGjEUAvjsuIUiv42IZDazdW3TIO8pwUVJXpevBQjB0fLxzUVuP5e7/nGDYEPJvApd1
	 4zk7NFf9es2XUHjfA8eacJUuJWYOt2zYB6ckMJ/SUKi3ZKS2JPi9d7j/xX0uG1cmbn
	 sXilw4pwnmzxA==
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CFC9740007
X-Stat-Signature: t9dzr3c8d388tqpzfpec56n3pqe4ekbg
X-Rspam-User: 
X-HE-Tag: 1773985733-666238
X-HE-Meta: U2FsdGVkX1+lVJ1/0yHbEWHRMqmX4GvLRepE5tXfc2yfl2tNs2+DnWJRmSWkBdr6s5ETN6wWxqISvD+PHZHT9GtGmwCRCEGKBEpeHKvDVWX9nkzW1TXTR/1Xe6dgeYPuQ9+VvXae/AMrZBnienmp1hsp5aZptTRMx/2oFDOWpaMv/t8mcf+qZLkLbbk2bBVMS1hYGF5tIIkTvrogbySp/XT3gPYmlI8L/L3C4cI1bfuySqmYl0LuebzHczIimpC5i3zMqPMZW1XH/0B0cmySriIMQnMmmTVF5RTpIzwllafrUNyg4shgWkXo5NSHbFPuplXLNqODgtNCZ9VAc+cZVHIFYaycvhJcT9GsockuBDt5w1nTMY8bN/iTmyxr7BDR8vWcGoLMpDKbLXsCv5gKITqoB0EQTUVpace9Cvqb93+W/hHrF95NbEal65MdIE07YU7RswApW1d5XWh4INvDdcY6sHRxDjsiQRLAlaSJa1Xx2s9lr3VSzbQxiis1wVIvRfVye2UsddbcJ5L/fVkUDu7YLpiTug638FL5vg/fFqrvbDs54aH17MJPGPy06vOuu90jXeM3ki3irVK2ZHQjBvpjv4mP9+QzWXzbs7NM8b8PILSQIqY99XUYcazBLUi4YtrnCTSb0taE/JcRZbPcqVltAuOEu+Ayo0PUvgiCt4XS92rWxVgdN2Q4cw3Tf7m75zqQSaOoNdbN1o1ziuem1q6Oys6nsnx5N9QPdW1VVvGV0+9vtIWWRX4fmPvcEfmODYM5PDeq1TytvaQ51rQdI/N8pA8a/qGf1Wqcor4R8DPSYjaMD0g56OK2GTnAaN4dqIgA1DIokD7vGHdNB6r0PG2YO3hf/XlWsld8ndER6p92qQ7VEU7MX1p1YHSAcW43RAmFStqhVhjNbOhAVVCyvdEIt1bHz8y3Okg6UBXTh8wGqWtZC4hrZmkGX9SxrhdEqz3GK9gJIuzf9VcDTqL
 erkNLDUU
 unCK1Y30G5HgEtRjalEViTc+IXHVvixrHHAUcaU1YPaIjTG59fumMl/xzoPJUg7UcvQ5K+Gke+x69YzE5q6vOxQRnBKVPRCv/4xZxgi8X7ByPkyb6jAHwBg/CWsHsU9WMEanNMf4AIVNcsVb5jXS+mdVrqs8AekkzKksBnCf6WD0bYBeL2+XiTYuur5tgn+jpzSqK3aQ1etq5D6nJx90OUPA8deB8m1UDrdX2KbpHgf0ZVSKrwBc/nUHgC/OIpjfRJi78bj42yr+aTSr9/lemGJUiYCT5V+zyqklzntf4ZrxH/NcPpftHBEkyAITqXAACC90KCEQ24TozNhHW2J7AEdF6LdROgW4FkN+EzWXrKTR3UeGj0k24NQyJCeuVLKNR/Hae8QvboAfkY4NavzBfvCNgR8Jzun4aun0Il2aCY64hQEMFtmLEOjJGtYrrMSK+lRDtU/z5pKVf+ZZndUoRXe6tEgVgjJm5cdvOUWmRNRnRMhNifs+QwmzjLXp61vH8iKj9Bs+WJbup+oNhmLlkN5pjc8e1Cvwn7O6rHsCnbWF9R02/TUXTzEtRClb2XoLodEPnuiJaor3SPtf11+98AsS5X9mgGKzb3QUWz/Tud+XeUm4WR+ADWxU8b3qix/mgg4gYE+NEy+zq5ODCAyupiyDULA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBUaGF0IGlzIHRydWUuDQo+IA0KPiA8c25pcD4NCj4gZGlmZiAtLWdpdCBhL21tL3ZtYWxsb2Mu
YyBiL21tL3ZtYWxsb2MuYyBpbmRleA0KPiA2MWNhYTU1YTQ0MDIuLjgxZTFlNzQzNDZkNSAxMDA2
NDQNCj4gLS0tIGEvbW0vdm1hbGxvYy5jDQo+ICsrKyBiL21tL3ZtYWxsb2MuYw0KPiBAQCAtMTA2
Nyw2ICsxMDY3LDcgQEAgc3RhdGljIHZvaWQgcmVjbGFpbV9hbmRfcHVyZ2Vfdm1hcF9hcmVhcyh2
b2lkKTsNCj4gIHN0YXRpYyBCTE9DS0lOR19OT1RJRklFUl9IRUFEKHZtYXBfbm90aWZ5X2xpc3Qp
Ow0KPiAgc3RhdGljIHZvaWQgZHJhaW5fdm1hcF9hcmVhX3dvcmsoc3RydWN0IHdvcmtfc3RydWN0
ICp3b3JrKTsgIHN0YXRpYw0KPiBERUNMQVJFX1dPUksoZHJhaW5fdm1hcF93b3JrLCBkcmFpbl92
bWFwX2FyZWFfd29yayk7DQo+ICtzdGF0aWMgc3RydWN0IHdvcmtxdWV1ZV9zdHJ1Y3QgKmRyYWlu
X3ZtYXBfd3E7DQo+IA0KPiAgc3RhdGljIF9fY2FjaGVsaW5lX2FsaWduZWRfaW5fc21wIGF0b21p
Y19sb25nX3QgbnJfdm1hbGxvY19wYWdlczsgIHN0YXRpYw0KPiBfX2NhY2hlbGluZV9hbGlnbmVk
X2luX3NtcCBhdG9taWNfbG9uZ190IHZtYXBfbGF6eV9ucjsgQEAgLTI0MzcsNg0KPiArMjQzOCwx
NyBAQCBzdGF0aWMgdm9pZCBkcmFpbl92bWFwX2FyZWFfd29yayhzdHJ1Y3Qgd29ya19zdHJ1Y3Qg
KndvcmspDQo+ICAJbXV0ZXhfdW5sb2NrKCZ2bWFwX3B1cmdlX2xvY2spOw0KPiAgfQ0KPiANCj4g
K3N0YXRpYyB2b2lkDQo+ICtzY2hlZHVsZV9kcmFpbl92bWFwX3dvcmsodW5zaWduZWQgbG9uZyBu
cl9sYXp5LCB1bnNpZ25lZCBsb25nDQo+ICtucl9sYXp5X21heCkgew0KPiArCWlmICh1bmxpa2Vs
eShucl9sYXp5ID4gbnJfbGF6eV9tYXgpKSB7DQo+ICsJCXN0cnVjdCB3b3JrcXVldWVfc3RydWN0
ICp3cSA9IFJFQURfT05DRShkcmFpbl92bWFwX3dxKTsNCj4gKw0KPiArCQlpZiAod3EpDQo+ICsJ
CQlxdWV1ZV93b3JrKHdxLCAmZHJhaW5fdm1hcF93b3JrKTsNCj4gKwl9DQo+ICt9DQo+ICsNCj4g
IC8qDQo+ICAgKiBGcmVlIGEgdm1hcCBhcmVhLCBjYWxsZXIgZW5zdXJpbmcgdGhhdCB0aGUgYXJl
YSBoYXMgYmVlbiB1bm1hcHBlZCwNCj4gICAqIHVubGlua2VkIGFuZCBmbHVzaF9jYWNoZV92dW5t
YXAgaGFkIGJlZW4gY2FsbGVkIGZvciB0aGUgY29ycmVjdCBAQA0KPiAtMjQ3MCw4ICsyNDgyLDcg
QEAgc3RhdGljIHZvaWQgZnJlZV92bWFwX2FyZWFfbm9mbHVzaChzdHJ1Y3Qgdm1hcF9hcmVhDQo+
ICp2YSkNCj4gIAl0cmFjZV9mcmVlX3ZtYXBfYXJlYV9ub2ZsdXNoKHZhX3N0YXJ0LCBucl9sYXp5
LCBucl9sYXp5X21heCk7DQo+IA0KPiAgCS8qIEFmdGVyIHRoaXMgcG9pbnQsIHdlIG1heSBmcmVl
IHZhIGF0IGFueSB0aW1lICovDQo+IC0JaWYgKHVubGlrZWx5KG5yX2xhenkgPiBucl9sYXp5X21h
eCkpDQo+IC0JCXNjaGVkdWxlX3dvcmsoJmRyYWluX3ZtYXBfd29yayk7DQo+ICsJc2NoZWR1bGVf
ZHJhaW5fdm1hcF93b3JrKG5yX2xhenksIG5yX2xhenlfbWF4KTsNCj4gIH0NCj4gDQo+ICAvKg0K
PiBAQCAtNTQ4MywzICs1NDk0LDE1IEBAIHZvaWQgX19pbml0IHZtYWxsb2NfaW5pdCh2b2lkKQ0K
PiAgCXZtYXBfbm9kZV9zaHJpbmtlci0+c2Nhbl9vYmplY3RzID0gdm1hcF9ub2RlX3Nocmlua19z
Y2FuOw0KPiAgCXNocmlua2VyX3JlZ2lzdGVyKHZtYXBfbm9kZV9zaHJpbmtlcik7DQo+ICB9DQo+
ICsNCj4gK3N0YXRpYyBpbnQgX19pbml0IHZtYWxsb2NfaW5pdF93b3JrcXVldWUodm9pZCkgew0K
PiArCXN0cnVjdCB3b3JrcXVldWVfc3RydWN0ICp3cTsNCj4gKw0KPiArCXdxID0gYWxsb2Nfd29y
a3F1ZXVlKCJ2bWFwX2RyYWluIiwgV1FfVU5CT1VORCB8DQo+IFdRX01FTV9SRUNMQUlNLCAwKTsN
Cj4gKwlXQVJOX09OKHdxID09IE5VTEwpOw0KPiArCVdSSVRFX09OQ0UoZHJhaW5fdm1hcF93cSwg
d3EpOw0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICtlYXJseV9pbml0Y2FsbCh2bWFsbG9j
X2luaXRfd29ya3F1ZXVlKTsNCj4gPHNuaXA+DQo+IA0KDQpJIHRlc3QgdGhlIHVwcGVyIGNvZGVz
LCBpdCB3b3JrcyBmb3IgbWUsIERvIHlvdSBsaWtlIHRvIHNlbmQgYSBmb3JtYWwgcGF0Y2g/DQoN
ClJlcG9ydGVkLWFuZC10ZXN0ZWQtYnk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNv
bT4NCg0KdGhhbmtzDQoNCltMaSxSb25ncWluZ10gDQoNCg0KPiAtLQ0KPiBVbGFkemlzbGF1IFJl
emtpDQo=

