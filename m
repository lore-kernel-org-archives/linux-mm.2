Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B71DFCE07D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:29:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C0FE6B0098; Thu, 26 Feb 2026 08:29:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86DE86B0099; Thu, 26 Feb 2026 08:29:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750296B009B; Thu, 26 Feb 2026 08:29:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D9846B0098
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:29:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 12683C01E0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:29:50 +0000 (UTC)
X-FDA: 84486690540.17.191A22B
Received: from mta20.hihonor.com (mta20.hihonor.com [81.70.206.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1AA661C0005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:29:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772112588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ogpl6EvnzJExWSRYHZ/i6h9R9f7MhjUfWTiG+RMzFmk=;
	b=2OP+r2WmdpsRuLALK+Rv4mU7oJiaM2zTdUKrKbLxWqvqHv2U4kC45prNhMl6/vWaMgOq+1
	HobhRpUT6cpx2uLx89Z3EM0EIfyM75vMwbuPsBhYNJN9yNRTyRRE5Lxnu06iJaNDqFa7KD
	RO26klgFiMtxM7x7lywZz1NqfQtkSnY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772112588; a=rsa-sha256;
	cv=none;
	b=g/fjtBTy2et/Cn96t+9i7daV18h3x3420v7N1+ga1LLnoDPkgX/YwFUtvEcAxKxB3FDM9Q
	npM2Ri9uZKgien90UIKrKMxK6iQf8Yk2F5vv5NihN5T2k44dDMVAZeiYzoCWfaq0Jrzviy
	Pxy3hVDC/zPvnVHcL5FEM3FCzLs6BWg=
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4fMC0R0DsqzYl0xs;
	Thu, 26 Feb 2026 21:26:31 +0800 (CST)
Received: from a007.hihonor.com (10.68.22.31) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 21:29:42 +0800
Received: from w002.hihonor.com (10.68.28.120) by a007.hihonor.com
 (10.68.22.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Thu, 26 Feb
 2026 21:29:40 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Thu, 26 Feb 2026 21:29:40 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, wangxin 00023513
	<wangxin23@honor.com>, gao xu <gaoxu2@honor.com>, wangtao
	<tao.wangtao@honor.com>, liulu 00013167 <liulu.liu@honor.com>, zhouxiaolong
	<zhouxiaolong9@honor.com>, linkunli <linkunli@honor.com>,
	"kasong@tencent.com" <kasong@tencent.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"willy@infradead.org" <willy@infradead.org>, "surenb@google.com"
	<surenb@google.com>, yangxuzhe 00017436 <yangxuzhe@honor.com>, Kalesh Singh
	<kaleshsingh@google.com>, android-mm <android-mm@google.com>
Subject: RE: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Topic: [LSF/MM/BPF TOPIC] MGLRU on Android: Real-World Problems and
 Challenges
Thread-Index: AQHcpcuKJgNe9L/uMUapsJqAWXykl7WTOlwwgADgoACAANwjgA==
Date: Thu, 26 Feb 2026 13:29:40 +0000
Message-ID: <d91b347b9639488580182a9032ba1f2f@honor.com>
References: <e5c8b5b9e7574dce8e4d4744595123e2@honor.com>
 <CAGsJ_4zatnuLkCJyDe_o_yXmhngpc54kV6b7M3tu6JyvF-ZxDw@mail.gmail.com>
 <7ecdf6b68ace402f90a4685684bbe995@honor.com>
 <CAGsJ_4zPYpTDY4U0wSGhoa9dVHus_FChXaaD45H170TSXJ+RvQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4zPYpTDY4U0wSGhoa9dVHus_FChXaaD45H170TSXJ+RvQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AA661C0005
X-Stat-Signature: 1oshmcannstbrc47qimpqy337jtq6f1q
X-HE-Tag: 1772112586-565462
X-HE-Meta: U2FsdGVkX19X6+a2gQZSVZueHryWAboANt2cNaEyVLtUk7cAB4ppXahKqDBbKzqIUHXYnBdNxCvkAG9FNDsmfJgP8z1vxrcYEXr2u0QSl3crfT0cjKwN2aiCrEYFwBjF/HK7aUFnxGFzk+SSDsYEyfJ5k2cZqqKXj1+xP2+tpTnaNL6hLRgfWYoywPmuR+IO+bWvVVkUGKKJ+UJcyBkwfhZVQ4LQ05Oc3iohq/KU2ZIliXEbgatSpXoHMhMAwJ2i2ToDwu4Gb5fFXeDIprXWnX52JtQ9wM15DlOrKfIUvjgTfcFJDiLVY9eX10xCruor/Odph//MlgPZZPDKnUoiQUJ354pztC7RBdwo5sKrytx9qDVCFH/O92kCSu5VvY2kofiEtnP21vO3Ymy+mGDLunVTYChYUH3Y8XgJnT/FGLdUg9jl7MrTXMRR3wJyO9IV0HqJC19gWVOqZIV8MSJKrEUJHrOSi6fqVmcPiBmuQI/stkIWFQE/zH90BQZPMQL40VuqcoGvQlYyBDOU+Z4QJTXGvig5c71eeA5phfPyMBX6oKtfHIPvRYQif//3YwmSkCKehskarYiiU4cIYr5i8kIQhmbopRnRGnqY5QHnmbzKRXaIihWDzOg8DYdxedsCv+9nGZucePvCKQSpRwBjb/ujvDHq4twPYGQp0DpMYS0kHg2ypa2/ryulENmRkQi5wdIiQkGDE6JooHwiOpJ/mCpxazDLlqDavqd63Hyk9dsj0gIAFVu2VeixZ+2SD1T+kH0fBQ0LmbcNM1066NIbC4ZDxA1GvbmgcNNmBvmJgeelvr3t8tjyKKA5sYrs2sjcmelOQqvtScRf4PaHuS7lk9q/K2tCMYp5gDgdwoHoI/aUJIqPYD0+rnbZwSYK4s29RH2ZGXMXg9pUUfd9BfZkXBceAri/I2VgAAhh1Dlm0lXOJGPLLi9hpv3nQ4apPd4nM3Dt/2Bn5TJwZourPVX
 kxvcKkVK
 4ePOnVcoM+gfm2P3RG8/VItt1jYKhLOsKOkZtGFEL2XhDz8/cAvmaKLTIOLuB5EnMzZUPukI6ucqFcSn8F+gefILhDDdStXTPAD9AWC2edkXqEeVVRmAeCMR8smjDupPyFjSM1pek8p4BSTMoKJCUgmW5JCr4aZI/Tbk4M4y1FruajWtzpmm5CDZ8PCQ1xBLKbxO+0MrrTP/7qZJvEe3DhSHrxLcLmJ5SOaJGFPsBxI2FSkef9WMkUnmYozIlryw54tmfc06zbpNESfF0BRTk56ynuoFOhMNqmVBzdP/Z0diTIr5/Cv2LKPy6bsKi6B+eyecYhg2RhH4pBJOpbaWXgsTc1K6qCQTScsXU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+ID4gPiByZWNsYWltIHZpYSB0cnlfdG9fZnJlZV9tZW1fY2dyb3VwX3BhZ2VzKCkgbGFja3Mg
Y2xlYXIgYWJvcnQNCj4gPiA+ID4gc2VtYW50aWNzIGFuZCBjYW4gb3ZlcnNob290IHRoZSBpbnRl
bmRlZCByZWNsYWltIGFtb3VudC4NCj4gPiA+ID4gV2UgY3VycmVudGx5IHVzZSBPRU0gaG9va3Mg
WzJdIHRvIGVhcmx5LWV4aXQgb3IgYnlwYXNzIHJlY2xhaW0gdW5kZXINCj4gPiA+ID4gc29tZSBj
b25kaXRpb25zDQo+ID4gPiA+DQo+ID4gPiA+IFEzOiBIaWdoIHJlY2xhaW0gY29zdCBhbmQgbG9u
ZyB1bmludGVycnVwdGlibGUgc2xlZXAgb24gbG93ZXItZW5kDQo+ID4gPiA+IGRldmljZXMNCj4g
PiA+ID4gT24gbG93ZXItZW5kIGRldmljZXMsIHJlY2xhaW0gY29zdCBhbmQgbGF0ZW5jeSBhcmUg
aGFyZGVyIHRvIGNvbnRyb2w6DQo+ID4gPiA+IHRocm90dGxlX2RpcmVjdF9yZWNsYWltIGNhbiBt
YWtlIHRhc2tzIHdhaXQgZm9yIGtzd2FwZCBpbnN0ZWFkIG9mDQo+ID4gPiA+IGRvaW5nIGRpcmVj
dCByZWNsYWltOw0KPiA+ID4gPiBzb21ldGltZXMgdGhlIHRhcmdldCBnZW5lcmF0aW9ucyBpbiBt
YW55IG1lbWNncyBoYXZlIHZlcnkgZmV3DQo+ID4gPiA+IHJlY2xhaW1hYmxlDQo+ID4gPiA+IHBh
Z2VzLCBzbyB0aGUgQ1BVIHNwZW5kcyB0aW1lIHNjYW5uaW5nIHdpdGggbGl0dGxlIHByb2dyZXNz
Lg0KPiA+ID4gPiBXZSBvYnNlcnZlIHRhc2tzIHN0YXlpbmcgaW4gdW5pbnRlcnJ1cHRpYmxlIHNs
ZWVwIGluDQo+IHRyeV90b19mcmVlX3BhZ2VzKCkNCj4gPiA+ID4gV2UgaGF2ZW4ndCBmaW5kIGFu
eSBwcm9wZXIgd2F5cyB0byBmaXggaXQuDQo+ID4gPg0KPiA+ID4gSGF2ZSB5b3UgaWRlbnRpZmll
ZCB0aGUgZXhhY3QgbGluZSBvZiBjb2RlIHdoZXJlIGRpcmVjdCByZWNsYWltIGVudGVycw0KPiA+
ID4gdW5pbnRlcnJ1cHRpYmxlIHNsZWVwPyBJcyBpdCB3YWl0aW5nIG9uIGEgbG9jayBvciBzb21l
dGhpbmcgZWxzZT8NCj4gPiA+DQo+ID4gWWVzLCB3ZeKAmXZlIGlkZW50aWZpZWQgdGhlIGV4YWN0
IGNvZGUgbG9jYXRpb25zIHdoZXJlIHRoaXMgaGFwcGVuczoNCj4gPg0KPiA+IGluIHNsb3cgcGF0
aA0KPiA+DQo+ID4gc3RhdGljIGJvb2wgdGhyb3R0bGVfZGlyZWN0X3JlY2xhaW0oZ2ZwX3QgZ2Zw
X21hc2ssIHN0cnVjdCB6b25lbGlzdCAqem9uZWxpc3QsDQo+ID4gICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIG5vZGVtYXNrX3QgKm5vZGVtYXNrKQ0KPiA+IHsNCj4gPiAu
Li4NCj4gPiAgICAgICAgIGlmICghKGdmcF9tYXNrICYgX19HRlBfRlMpKQ0KPiA+ICAgICAgICAg
ICAgICAgICB3YWl0X2V2ZW50X2ludGVycnVwdGlibGVfdGltZW91dChwZ2RhdC0+cGZtZW1hbGxv
Y193YWl0LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGFsbG93X2RpcmVjdF9yZWNsYWlt
KHBnZGF0KSwgSFopOw0KPiA+ICAgICAgICAgZWxzZQ0KPiA+ICAgICAgICAgICAgICAgICAvKiBU
aHJvdHRsZSB1bnRpbCBrc3dhcGQgd2FrZXMgdGhlIHByb2Nlc3MgKi8NCj4gPiAgICAgICAgICAg
ICAgICAgd2FpdF9ldmVudF9raWxsYWJsZSh6b25lLT56b25lX3BnZGF0LT5wZm1lbWFsbG9jX3dh
aXQsDQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgYWxsb3dfZGlyZWN0X3JlY2xhaW0ocGdk
YXQpKTsNCj4gPiAuLi4NCj4gPiB9DQo+ID4NCj4gPiBpbiBrc3dhcGQNCj4gPg0KPiA+IHN0YXRp
YyBib29sIHByZXBhcmVfa3N3YXBkX3NsZWVwKHBnX2RhdGFfdCAqcGdkYXQsIGludCBvcmRlciwN
Cj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGludCBoaWdoZXN0X3pvbmVpZHgp
DQo+ID4gew0KPiA+IC4uLg0KPiA+ICAgICAgICAgaWYgKHdhaXRxdWV1ZV9hY3RpdmUoJnBnZGF0
LT5wZm1lbWFsbG9jX3dhaXQpKQ0KPiA+ICAgICAgICAgICAgICAgICB3YWtlX3VwX2FsbCgmcGdk
YXQtPnBmbWVtYWxsb2Nfd2FpdCk7DQo+ID4gLi4uDQo+ID4gfQ0KPiANCj4gVGhhbmtzLiBJIHVu
ZGVyc3RhbmQgaXQgY291bGQgYmUgcHJvYmxlbWF0aWMgaWYgdGhyb3R0bGluZyBvY2N1cnMsDQo+
IGVzcGVjaWFsbHkgb24gdGhyZWFkcyByZWxhdGVkIHRvIHVzZXIgZXhwZXJpZW5jZS4NCj4gDQpU
aGFuayB5b3UgZm9yIHRoZSBkZXRhaWxlZCBmb2xsb3dpbmcgdXAuDQoNCkZvciBRMywgdGhlIHRo
cm90dGxpbmcgaXMgZGFuZ2Vyb3VzIGZvciBVWOKAkWNyaXRpY2FsIHRocmVhZHMuIEthbGVzaCBh
bHNvIHNoYXJlZCBzaW1pbGFyDQpvYnNlcnZhdGlvbnMgYWJvdXQgbG9uZyBkaXJlY3QgcmVjbGFp
bSB0YWlsIGxhdGVuY2llcy4NCg0KPiA+DQo+ID4gPiA+DQo+ID4gPiA+IFE0OiBMYWNrIG9mIGds
b2JhbCBob3QvY29sZCArIHByaW9yaXR5IHZpZXcgd2l0aCBwZXItYXBwIG1lbWNnDQo+ID4gPiA+
IEFuZHJvaWQgdXNlcyBhIHBlci1hcHAgbWVtY2cgbW9kZWwgYW5kIGZvcmVncm91bmQvYmFja2dy
b3VuZA0KPiBsZXZlbHMNCj4gPiA+ID4gZm9yIHJlc291cmNlIGNvbnRyb2wuIHJvb3QgcmVjbGFp
bSBsYWNrcyBhIGNyb3NzLW1lbWNnIGhvdC9jb2xkIGFuZA0KPiA+ID4gPiBwcmlvcml0eSB2aWV3
Ow0KPiA+ID4gPiBmb3JlZ3JvdW5kIGFwcCBmaWxlIHBhZ2VzIG1heSBiZSByZWNsYWltZWQgYW5k
IHJlbG9hZGVkIGZyZXF1ZW50bHksDQo+ID4gPiA+IGNhdXNpbmcgdmlzaWJsZSBzdGFsbHM7DQo+
ID4gPiA+IFdlIGN1cnJlbnRseSB1c2UgYSBob29rIFszXSB0byBza2lwIHJlY2xhaW0gZm9yIGZv
cmVncm91bmQgYXBwcy4NCj4gPiA+DQo+ID4gPiBJbnRlcmVzdGluZy4gVGhpcyBzb21laG93IHJl
ZmxlY3RzIHRoYXQgdGhlIExSVSBsYWNrcyB0aGUgdXNlcuKAmXMNCj4gPiA+IGNvbnRleHQsIGVz
cGVjaWFsbHkgb24gQW5kcm9pZCBzeXN0ZW1z4oCUZm9yIGV4YW1wbGUsIHdoaWNoIGFwcHMgYXJl
IGluDQo+ID4gPiB0aGUgZm9yZWdyb3VuZCwgd2hpY2ggYXJlIGluIHRoZSBiYWNrZ3JvdW5kLCBh
bmQgaG93IGxvbmcgYW4gYXBwIGhhcw0KPiA+ID4gYmVlbiBpbiB0aGUgYmFja2dyb3VuZC4NCj4g
PiA+DQo+ID4gPiBCdXQgdGhpcyBpcyBub3Qgc3BlY2lmaWMgdG8gTUdMUlU7IGl0IGNhbiBhbHNv
IGJlIGFuIGlzc3VlIGZvciB0aGUNCj4gPiA+IGFjdGl2ZS9pbmFjdGl2ZSBMUlU/DQo+ID4gPg0K
PiA+IFRoYXQncyByaWdodCwgdGhpcyBhZmZlY3RzIGJvdGggTUdMUlUgYW5kIHRoZSB0cmFkaXRp
b25hbCBMUlUuDQo+ID4gV2UgYmVsaWV2ZSB0aGlzIGNvbWVzIGZyb20gYSBzZW1hbnRpYyBnYXAg
YmV0d2VlbiB0aGUga2VybmVsIGFuZA0KPiBBbmRyb2lkDQo+ID4gKGUuZy4gZmcvYmcsIHBlci1h
cHAgcHJpb3JpdGllcyksIGFuZCB0aGlzIGlzIG9uZSBvZiB0aGUgbWFpbiB0b3BpY3Mgd2XigJlk
IGxpa2UNCj4gdG8gZGlzY3Vzcy4NCj4gPiBBZGRpdGlvbmFsbHksIGV2ZW4gd2l0aCBNR0xSVeKA
mXMgbWVtY2ctTFJVLCB0aGlzIGlzc3VlIGlzIHN0aWxsIG5vdCBmdWxseQ0KPiByZXNvbHZlZA0K
PiA+IGluIG91ciB3b3JrbG9hZHMuDQo+IA0KPiBXZSBtaWdodCBiZSBhYmxlIHRvIGxldmVyYWdl
IHNvbWUgZXhpc3RpbmcgaW5mcmFzdHJ1Y3R1cmUuIE1HTFJVDQo+IG1haW50YWlucyBhbiBMUlUg
b2YgTFJVcywgYW5kIHdpdGhpbiB0aGlzIHN0cnVjdHVyZSwgaXQgbWF5IGJlDQo+IHBvc3NpYmxl
IHRvIGFkanVzdCBwb3NpdGlvbnMgYmFzZWQgb24gd2hldGhlciBhIGNncm91cCBpcyBpbiB0aGUN
Cj4gZm9yZWdyb3VuZCBvciBiYWNrZ3JvdW5kLiBJbiBvdGhlciB3b3JkcywgdGhlIExSVSBvZiBM
UlVzIGNvdWxkDQo+IHJlY2VpdmUgaGludHMgZnJvbSB1c2Vyc3BhY2UgdG8gaW5mbHVlbmNlIGEg
Y2dyb3Vw4oCZcyBwb3NpdGlvbi4NCj4gDQpSZWdhcmRpbmcgdGhlIExSVeKAkW9m4oCRTFJVcyBp
ZGVhLCB0aGF0IGRvZXMgc291bmQgbGlrZSBhIHByb21pc2luZyBkaXJlY3Rpb24gDQooY29tcGFy
ZSB0byB2ZW5kb3IgaG9vaykuDQpidXQgaXQgc2VlbXMgaGFyZGx5IHN1cHBvcnQgc29tZSBtb3Jl
IGNvbXBsZXggcG9saWNpZXMsIGUuZy4sDQotIHJlY2xhaW0gZnJvbSBiZyBhcHBzIGZpcnN0LCBi
dXQgY2FwcGluZyB0aGUgcmVjbGFpbSBhbW91bnQgYW5kIHByb3RlY3QgdGhlIGJnICdzdXBlciBh
cHBzJw0KLSBwcmVzZXJ2aW5nIG1lbWNnIE1HTFJVIGdlbmVyYXRpb24gaW5mbyBhZnRlciBhcHAg
ZnJvemVuIGFuZCBub3QgcnVubmluZy4NCkxvb2tpbmcgZm9yd2FyZCB0byB0aGUgZGlzY3Vzc2lv
bi4NCg0KPiA+DQo+ID4gPg0KPiA+ID4gQWRkaXRpb25hbGx5LCBJ4oCZZCBsaWtlIHRvIGFkZCBR
NSBiYXNlZCBvbiBteSBvYnNlcnZhdGlvbnM6DQo+ID4gPiBRNToNCj4gPiA+IE1HTFJVIHBsYWNl
cyByZWFkYWhlYWQgZm9saW9zIGluIHRoZSBuZXdlc3QgZ2VuZXJhdGlvbi4gRm9yIGV4YW1wbGUs
IGlmDQo+ID4gPiBhIHBhZ2UgZmF1bHQgb2NjdXJzIGF0IGFkZHJlc3MgNSwgcmVhZGFoZWFkIGZl
dGNoZXMgYWRkcmVzc2VzIDHigJMxNiwgYW5kDQo+ID4gPiBhbGwgMTYgZm9saW9zIGFyZSBwdXQg
aW4gdGhlIHlvdW5nZXN0IGdlbmVyYXRpb24sIGV2ZW4gdGhvdWdoIG1hbnkgbWF5DQo+ID4gPiBu
b3QgYmUgbmVlZGVkLiBUaGlzIGNhbiBzZXJpb3VzbHkgaW1wYWN0IHJlY2xhbWF0aW9uIHBlcmZv
cm1hbmNlLCBhcw0KPiA+ID4gdGhlc2UgY29sZCByZWFkYWhlYWQgZm9saW9zIG9jY3VweSBhY3Rp
dmUgc2xvdHMuDQo+ID4gPg0KPiA+ID4gU2VlIHRoZSBjb2RlIGJlbG93IGFuZCB0aGUgY2hlY2tz
IHBlcmZvcm1lZCBieSBscnVfZ2VuX2luX2ZhdWx0KCkuDQo+ID4gPg0KPiA+ID4gdm9pZCBmb2xp
b19hZGRfbHJ1KHN0cnVjdCBmb2xpbyAqZm9saW8pDQo+ID4gPiB7DQo+ID4gPiAgICAgICAgIC4u
Lg0KPiA+ID4gICAgICAgICAvKiBzZWUgdGhlIGNvbW1lbnQgaW4gbHJ1X2dlbl9mb2xpb19zZXEo
KSAqLw0KPiA+ID4gICAgICAgICBpZiAobHJ1X2dlbl9lbmFibGVkKCkgJiYgIWZvbGlvX3Rlc3Rf
dW5ldmljdGFibGUoZm9saW8pICYmDQo+ID4gPiAgICAgICAgICAgICBscnVfZ2VuX2luX2ZhdWx0
KCkgJiYgIShjdXJyZW50LT5mbGFncyAmIFBGX01FTUFMTE9DKSkNCj4gPiA+ICAgICAgICAgICAg
ICAgICBmb2xpb19zZXRfYWN0aXZlKGZvbGlvKTsNCj4gPiA+DQo+ID4gPiAgICAgICAgIGZvbGlv
X2JhdGNoX2FkZF9hbmRfbW92ZShmb2xpbywgbHJ1X2FkZCk7DQo+ID4gPiB9DQo+ID4gPiBFWFBP
UlRfU1lNQk9MKGZvbGlvX2FkZF9scnUpOw0KPiA+ID4NCj4gPiA+IEkgY291bGQgaGF2ZSBzdWJt
aXR0ZWQgYSBwYXRjaHNldCB0byBhZGRyZXNzIHRoaXMgYnkgaW5pdGlhbGx5IG1hcmtpbmcNCj4g
PiA+IG9ubHkgYWRkcmVzcyA1IGFzIGFjdGl2ZSwgYW5kIGFjdGl2YXRpbmcgdGhlIG90aGVyIGFk
ZHJlc3NlcyBsYXRlciB3aGVuDQo+ID4gPiB0aGV5IGFyZSBhY3R1YWxseSBtYXBwZWQgb3IgYWNj
ZXNzZWQuDQo+ID4gPg0KPiA+IFRoaXMgc291bmRzIHZlcnkgcmVhc29uYWJsZSB0byB1cywgYW5k
IHdlIGxvb2sgZm9yd2FyZCB0byBkaXNjdXNzaW5nDQo+ID4gYW5kIGV2YWx1YXRpbmcgdGhpcyBk
aXJlY3Rpb24gdG9nZXRoZXIuDQo+IA0KPiBJIHNlbnQgYW4gUkZDIHRvZGF5IGZvciBRNS4gSSBo
b3BlIHlvdSBjYW4gcmV2aWV3LCBjb21tZW50LA0KPiBhbmQgdGVzdCBpdCB0b2dldGhlcjoNCj4g
DQpGb3IgUTUsIHdlIGFyZSBoYXBweSB0byBzZWUgeW91ciBSRkMuIFdl4oCZdmUgYWxyZWFkeSBj
b21tZW50IHRvIHRoZSB0aHJlYWQNCmFuZCB3aWxsIHJ1biBpdCBvbiBvdXIgd29ya2xvYWRzIHRv
IHByb3ZpZGUgZmVlZGJhY2suDQoNClRoYW5rcywNClppY2hlbmcNCg0KPiBodHRwczovL2xvcmUu
a2VybmVsLm9yZy9saW51eC1tbS8yMDI2MDIyNTIyMzcxMi4zNjg1LTEtDQo+IDIxY25iYW9AZ21h
aWwuY29tLw0KPiANCj4gVGhhbmtzDQo+IEJhcnJ5DQo=

