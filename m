Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C91BCD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 07:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DA16B0088; Thu, 28 May 2026 03:47:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61E226B008A; Thu, 28 May 2026 03:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D386B008C; Thu, 28 May 2026 03:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7AE6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 03:47:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC5071618E8
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:47:42 +0000 (UTC)
X-FDA: 84816049164.27.8CDFC3D
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6361D1C0006
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:47:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779954460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6LyOaRHgM7bNmxfx7oQssI+MuLm0BMEi7VTJSUIFus=;
	b=yg6s79dGzGy0wnUkiEslgDcLWh3+dknXNQ0SBsfzdIBKUAU75qadX4u56i0SJ2HF/cIAOT
	UDPtk8pG0VW11d9D5iOEvDV0dFVDbGNHmY/WlLF//je/opRdjk788hK0B5nZXr6CuRNlMY
	KLBIeE+PVSntjhyPMs5USB2J75ZYPZg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of tao.wangtao@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=tao.wangtao@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779954460; a=rsa-sha256;
	cv=none;
	b=Fg6BCARGPoGHUSMj8I9p+lPfx5IuK4qy6/9mxsSUeiV7abb/UF7+9wSmgbsAXIDPl5HbLx
	pkPC9+KbVRTUdpwdGYE1C9odITiD6FTdaLREtRB6NiyMVFg+6tt+d1aYzb3+FB4oledtC9
	M3NNoYFNr7CN0GOMr9+zSf6EnsxMqXI=
Received: from TW001.hihonor.com (unknown [10.77.229.151])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4gQz7V6dNhzYmnW4;
	Thu, 28 May 2026 15:45:58 +0800 (CST)
Received: from TA001.hihonor.com (10.77.210.32) by TW001.hihonor.com
 (10.77.229.151) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 15:47:35 +0800
Received: from TA003.hihonor.com (10.72.0.43) by TA001.hihonor.com
 (10.77.210.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.37; Thu, 28 May
 2026 15:47:39 +0800
Received: from TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1]) by
 TA003.hihonor.com ([fe80::998f:47ec:980d:bdf1%7]) with mapi id
 15.02.2562.037; Thu, 28 May 2026 15:47:35 +0800
From: wangtao <tao.wangtao@honor.com>
To: Lorenzo Stoakes <ljs@kernel.org>
CC: "catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>, "willy@infradead.org"
	<willy@infradead.org>, "sj@kernel.org" <sj@kernel.org>, "kees@kernel.org"
	<kees@kernel.org>, "luizcap@redhat.com" <luizcap@redhat.com>,
	"zhangjiao2@cmss.chinamobile.com" <zhangjiao2@cmss.chinamobile.com>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"liam@infradead.org" <liam@infradead.org>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "jack@suse.cz"
	<jack@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "harry@kernel.org"
	<harry@kernel.org>, "jannh@google.com" <jannh@google.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
	"npache@redhat.com" <npache@redhat.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "dev.jain@arm.com" <dev.jain@arm.com>,
	"baohua@kernel.org" <baohua@kernel.org>, "lance.yang@linux.dev"
	<lance.yang@linux.dev>, "xu.xin16@zte.com.cn" <xu.xin16@zte.com.cn>,
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>,
	"nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>,
	"joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>, "rakie.kim@sk.com"
	<rakie.kim@sk.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "apopple@nvidia.com" <apopple@nvidia.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"damon@lists.linux.dev" <damon@lists.linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "ryncsn@gmail.com" <ryncsn@gmail.com>,
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "jparsana@google.com"
	<jparsana@google.com>, "dvander@google.com" <dvander@google.com>, zhangji
	<zhangji1@honor.com>, wangzicheng <wangzicheng@honor.com>
Subject: RE: [PATCH 01/15] mm/rmap: introduce anon_rmap APIs for anonymous
 folios
Thread-Topic: [PATCH 01/15] mm/rmap: introduce anon_rmap APIs for anonymous
 folios
Thread-Index: AQHc7ckRwxjcs/8lx0W0uDFJW08PjLYhOs2AgAHQxJA=
Date: Thu, 28 May 2026 07:47:34 +0000
Message-ID: <d02134e2a17041e2bcc0a8779e5e7127@honor.com>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <20260527110147.17815-2-tao.wangtao@honor.com> <ahbWKJL8TtGsFV4r@lucifer>
In-Reply-To: <ahbWKJL8TtGsFV4r@lucifer>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.240]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: qqyixw8i3jniuy7r3xgjme9n866rquqy
X-Rspamd-Queue-Id: 6361D1C0006
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779954460-63199
X-HE-Meta: U2FsdGVkX19hw+dPwjS5vKU6E0BZnHO/S18z7PYm8BjnyiBJRxyp+AGnaLWA9IKKZPOluHRe21f5zJDji43QQFqUC/xRTmRu8DMOCoC+Mzul+24W17IhHXglJrcIpYzw8Lpo8ac3Xo7Pk011jgzxHVQyVnPZcgSusNx2kVeP3ypP5tvsxQ9tcYO4M7gBSnZa50W/FsnEkbnxzwlUPvBoFPfCiU5pOwGQa6Uht7zj1TLVBtRzc7wHwqvVuDytNF4Vv2BdLQ9n3fFPdQ2uSuHXlrJuv8jWGyhQAjVK6ptpzYBcpUxIe88Tf8lYrbn7uvXzsqh6pgRH1F7kYJ2RH3K1CktV195i6UBl+Qc8S3dGsa7knRgE6mjnvfRBxQvRqcodf/PCGpaBi7Vmm72UdLC5F7GQk8RmgMfX7PHkLcnC2rG/AqWZ1ewCzYyLHw4sKIWjcT2kaVCE2Em2VsdyJ4JPq+xVp3Nq9ADdz7ryu2RG3SrxiLqDhDu+STlLrxrfV7Jpir7SDL67hJfsO/tpKP1nR2n+Mg1vyy5WlUWJCBywgUjOGGnri6EHiy4eHm91eC2590znK1EabOJQ6e2qzyACmBQ1mpCFrA+RpcrbatCZfD/b3jkPWF6tPiuORx6G5ZFnGCgt4gbbJJDcI+crnnlpCw+L5dvDz+mhAHrPmWdCfArbJAV/M3pi6IspUHRqau6WFC6rdSVXq3d8c6D1h9mWjT4AMYUwYUSb/CGbTMcwCrpfiF+ErcV1eyK7WnYayKnpprU19rpDand7A9zvMR9Se7CMv6TMSq3VVYa6SbW70D8R7AI4yMdx1/Pd8pT9PSC1f/EZX9m7USCgEzigwHGMe32jO2V23F4AzN/8dJNhJklDjnl7NQVgNG3Sq1Zb06XYWl3oTBa73MfgNmtshL47zQfs4OoOvib6chB035fZDqiADddXexk1w6g+XrqYmiArT70VS7u2W6R5Glhpf+V
 LpqCaH38
 0Q5r1grnsl0+0MrnEo1vxApGZOzJB8cbRz5d024x3dHZIV+lcYaZHt2dDwI20ZX8GUr2JS2XKI4uPQdnzNSwhYwYBsvccNT6BpHfwBfFWaIiux2j1eZVoy/RLe+8rqEtiQI0aqwEWRkfi36U7ooKvjKKVilJs3dQn/RhM0mVLFfbRlPz7ahZJj4TEpvqXGr1aXDn9b0ii/UjJ0Oy5BFh1m//aSB6IZs+4MgwKvR+EAnaD/QLaK5pUh0zc/M4IekNM7js/Y0ioKf9xu4CMFyITwFUvvREpVHYzuejuTtqkHS1qcKA+e1pkSLc/6N6Mt911np17ws8jMxOrQpCpVaAwLOlBB6fu0p3DWgoBKUcByeI3QlOpnx2NaY9CfER8ijq5vTXhwV1ewC62ijunkBYBYvZ97K9pVJXQ8B25hh+DK4mzUu1FINFLfOY9SHF/ZPxaYo3ecDLk4lUY9JDEIbPlRtyQW46hR5OEvTqi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiANCj4gT24gV2VkLCBNYXkgMjcsIDIwMjYgYXQgMDc6MDE6MzNQTSArMDgwMCwgdGFvIHdyb3Rl
Og0KPiA+IEFkZCBhIHNldCBvZiBhbm9uX3JtYXAgQVBJcyB0byBvcGVyYXRlIG9uIHRoZSByZXZl
cnNlIG1hcHBpbmdzIG9mDQo+ID4gYW5vbnltb3VzIGZvbGlvcy4NCj4gPg0KPiA+IEludHJvZHVj
ZSBhbm9uX3JtYXBfZm9yX2VhY2hfdm1hKCkgYXMgYSB3cmFwcGVyIGFyb3VuZA0KPiA+IHZtYV9p
bnRlcnZhbF90cmVlX2ZvcmVhY2goKSwgc28gY2FsbGVycyBubyBsb25nZXIgYWNjZXNzIHRoZSBp
bnRlcnZhbA0KPiA+IHRyZWUgZGlyZWN0bHkuDQo+ID4NCj4gPiBUaGlzIHByZXBhcmVzIHRoZSBy
bWFwIGNvZGUgZm9yIHVwY29taW5nIEFOT05fVk1BX0xBWlkgc3VwcG9ydCBhbmQNCj4gPiBSQ1Ut
YmFzZWQgbG9ja2xlc3Mgcm1hcCB0cmF2ZXJzYWwuDQo+ID4NCj4gPiBObyBmdW5jdGlvbmFsIGNo
YW5nZSBpbnRlbmRlZC4NCj4gDQo+IFRoaXMgY29tbWl0IG1lc3NhZ2UgaXMgdG90YWwgZ2FyYmFn
ZS4gWW91J3JlIG5vdCBleHBsYWluaW5nIFdIWSB5b3UncmUgdXNpbmcNCj4gd29yZHMgdG8gZGVz
Y3JpYmUgd2hhdCB0aGUgY29kZSBkb2VzLiBJIGNhbiByZWFkIHRoZSBjb2RlPw0KPiANCj4gPg0K
PiA+IFNpZ25lZC1vZmYtYnk6IHRhbyA8dGFvLndhbmd0YW9AaG9ub3IuY29tPg0KPiANCj4gVGhp
cyBpcyBhbGwgaG9ycmlibGUsIGhvcnJpYmx5IGludmFzaXZlLCBhbmQgYWRkaW5nIGEgcGlsZSBv
ZiBjcmFwIG9uIG1hY2hpbmVyeQ0KPiB3ZSB3YW50IHRvIGdldCByaWQgb2YuDQo+IA0KPiBZb3Un
dmUgYWRkZWQgemVybyBleHBsYW5hdGlvbiBvciBjb21tZW50cy4gVGhpcyBpcyBqdXN0IG5vdCB1
cHN0cmVhbWFibGUsDQo+IGFuZCBldmVuIGlmIHlvdSBkaWQgZXhwbGFpbiB5b3Vyc2VsZiB3ZSBk
b24ndCB3YW50IHRvIGV4dGVuZCBhIGJyb2tlbg0KPiBhYnN0cmFjdGlvbiB3aXRoIG1vcmUgYnJv
a2VuIGNvbXBsZXhpdHk/DQo+IA0KPiBZb3UncmUgYWxzbyBzZWVtaW5nbHkgaW50cm9kdWNpbmcg
YSB0eXBlc2FmZSB3cmFwcGVyIHRvIHdyYXAgYW4gYXJiaXRyYXJ5DQo+IHZhbHVlPw0KPiANCg0K
SSB0aG91Z2h0IHRoZXNlIHdlcmUganVzdCBzaW1wbGUgd3JhcHBlcnMsIHNvIHRoZXkgc2VlbWVk
DQpzdHJhaWdodGZvcndhcmQsIHNvIEkgYWRkZWQgdGhlbSBpbiB0aGUgbmV3IHBhdGNoLg0KDQo+
ID4gLS0tDQo+ID4gIGluY2x1ZGUvbGludXgvcm1hcC5oIHwgNjgNCj4gKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gPiAgbW0vcm1hcC5jICAgICAgICAgICAgfCA3
Mw0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAy
IGZpbGVzIGNoYW5nZWQsIDE0MSBpbnNlcnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEv
aW5jbHVkZS9saW51eC9ybWFwLmggYi9pbmNsdWRlL2xpbnV4L3JtYXAuaCBpbmRleA0KPiA+IDhk
YzA4NzFlNWYwMC4uYzQyMzE0ZWE0MzYyIDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvbGludXgv
cm1hcC5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9ybWFwLmgNCj4gPiBAQCAtOTM3LDYgKzkz
Nyw0NCBAQCBpbnQgcGZuX21rY2xlYW5fcmFuZ2UodW5zaWduZWQgbG9uZyBwZm4sDQo+IHVuc2ln
bmVkDQo+ID4gbG9uZyBucl9wYWdlcywgcGdvZmZfdCBwZ29mZiwgIHZvaWQgcmVtb3ZlX21pZ3Jh
dGlvbl9wdGVzKHN0cnVjdCBmb2xpbw0KPiAqc3JjLCBzdHJ1Y3QgZm9saW8gKmRzdCwNCj4gPiAg
CQllbnVtIHR0dV9mbGFncyBmbGFncyk7DQo+ID4NCj4gPiArLyogUmV2ZXJzZSBtYXBwaW5nIGhh
bmRsZSBmb3IgYW5vbnltb3VzIGZvbGlvIHJtYXAgaGVscGVycy4gKi8NCj4gPiArdHlwZWRlZiBz
dHJ1Y3QgYW5vbl9ybWFwIHsNCj4gPiArCXVuc2lnbmVkIGxvbmcgcm1hcDsNCj4gPiArfSBhbm9u
X3JtYXBfdDsNCj4gDQo+IEkgZG8gbm90IGtub3cgd2h5IHlvdSdyZSB1c2luZyBhIHR5cGVkZWYg
d2hlbiB5b3UganVzdCB0cmVhdCBpdCBhcyBhbg0KPiBhcmJpdHJhcnkgdmFsdWU/DQo+IA0KYW5v
bl9ybWFwX3QgcHJvdmlkZXMgZnVuY3Rpb25hbGl0eSBleHRlcm5hbGx5LCBzbyB1c2luZyBhIHN0
cnVjdA0KaXMgcmVsYXRpdmVseSBtb3JlIHJvYnVzdCBhbmQgaGVscHMgcHJldmVudCBtaXN1c2Uu
DQoNCj4gPiArDQo+ID4gKyNkZWZpbmUgQU5PTl9STUFQX05VTEwgbWFrZV9hbm9uX3JtYXAoMCkN
Cj4gDQo+IFRoaXMgaXMganVzdCBlcXVpdmFsZW50IHRvIGEgTlVMTCB2YWx1ZT8uLi4NCj4gDQo+
ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5lIGFub25fcm1hcF90IG1ha2VfYW5vbl9ybWFwKGNvbnN0
IHZvaWQgKmFub25fbWFwcGluZykNCj4gew0KPiA+ICsJcmV0dXJuIChhbm9uX3JtYXBfdCl7IC5y
bWFwID0gKHVuc2lnbmVkIGxvbmcpYW5vbl9tYXBwaW5nLCB9OyB9DQo+IA0KPiBZb3UncmUgaW50
ZW50aW9uYWxseSBkZWZlYXRpbmcgdHlwZSBzYWZldHkgdG8gc3RvcmUgYXJiaXRyYXJ5IHZhbHVl
cz8uLi4NCj4gDQo+ID4gKw0KPiA+ICtzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgYW5vbl9y
bWFwX3ZhbHVlKGFub25fcm1hcF90IGFub25fcm1hcCkgew0KPiA+ICsJcmV0dXJuIGFub25fcm1h
cC5ybWFwOw0KPiA+ICt9DQo+IA0KPiAnVW50eXBlIHNhZmUgbXkgYXJiaXRyYXJpbHkgdHlwZSBz
YWZlIHdyYXBwZWQgdHlwZScuLi4/DQo+IA0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSBhbm9u
X3JtYXBfdCBhbm9uX3ZtYV90b19hbm9uX3JtYXAoY29uc3Qgc3RydWN0DQo+IGFub25fdm1hDQo+
ID4gKyphbm9uX3ZtYSkgew0KPiA+ICsJcmV0dXJuIG1ha2VfYW5vbl9ybWFwKGFub25fdm1hKTsN
Cj4gPiArfQ0KPiA+ICsNCj4gPiArc3RhdGljIGlubGluZSBzdHJ1Y3QgYW5vbl92bWEgKmFub25f
cm1hcF90b19hbm9uX3ZtYShhbm9uX3JtYXBfdA0KPiA+ICthbm9uX3JtYXApIHsNCj4gPiArCXVu
c2lnbmVkIGxvbmcgcm1hcCA9IGFub25fcm1hcF92YWx1ZShhbm9uX3JtYXApOw0KPiA+ICsNCj4g
PiArCXJldHVybiAoc3RydWN0IGFub25fdm1hICopcm1hcDsNCj4gPiArfQ0KPiANCj4gQSB0b24g
b2Ygbm9pc2UgZm9yIHNlZW1pbmdseSBubyB2YWx1ZT8NCj4gDQoNCj4gPiArDQo+ID4gK2Fub25f
cm1hcF90IHZtYV9nZXRfYW5vbl9ybWFwKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hKTsgdm9p
ZA0KPiA+ICtwdXRfYW5vbl9ybWFwKGFub25fcm1hcF90IGFub25fcm1hcCk7IHZvaWQNCj4gPiAr
YW5vbl9ybWFwX2xvY2tfd3JpdGUoYW5vbl9ybWFwX3QgYW5vbl9ybWFwKTsgaW50DQo+ID4gK2Fu
b25fcm1hcF90cnlsb2NrX3dyaXRlKGFub25fcm1hcF90IGFub25fcm1hcCk7IHZvaWQNCj4gPiAr
YW5vbl9ybWFwX3VubG9ja193cml0ZShhbm9uX3JtYXBfdCBhbm9uX3JtYXApOyB2b2lkDQo+ID4g
K2Fub25fcm1hcF9sb2NrX3JlYWQoYW5vbl9ybWFwX3QgYW5vbl9ybWFwKTsgaW50DQo+ID4gK2Fu
b25fcm1hcF90cnlsb2NrX3JlYWQoYW5vbl9ybWFwX3QgYW5vbl9ybWFwKTsgdm9pZA0KPiA+ICth
bm9uX3JtYXBfdW5sb2NrX3JlYWQoYW5vbl9ybWFwX3QgYW5vbl9ybWFwKTsNCj4gDQo+IFllcyBs
ZXQncyBhZGQgYSBidW5jaCBvZiBleHRyYSBicm9rZW4gYWJzdHJhY3Rpb25zIG9uIHRoZSBicm9r
ZW4gYWJzdHJhY3Rpb24uDQo+IA0KPiBBbmQgbGV0J3Mgbm90IGNvbW1lbnQgYW55dGhpbmchDQo+
IA0KPiA+ICsNCj4gPiAgLyoNCj4gPiAgICogcm1hcF93YWxrX2NvbnRyb2w6IFRvIGNvbnRyb2wg
cm1hcCB0cmF2ZXJzaW5nIGZvciBzcGVjaWZpYyBuZWVkcw0KPiA+ICAgKg0KPiA+IEBAIC05Njks
NiArMTAwNywzNiBAQCB2b2lkIHJtYXBfd2Fsa19sb2NrZWQoc3RydWN0IGZvbGlvICpmb2xpbywN
Cj4gPiBzdHJ1Y3Qgcm1hcF93YWxrX2NvbnRyb2wgKnJ3Yyk7ICBzdHJ1Y3QgYW5vbl92bWENCj4g
KmZvbGlvX2xvY2tfYW5vbl92bWFfcmVhZChjb25zdCBzdHJ1Y3QgZm9saW8gKmZvbGlvLA0KPiA+
ICAJCQkJCSAgc3RydWN0IHJtYXBfd2Fsa19jb250cm9sICpyd2MpOw0KPiA+DQo+ID4gK2Jvb2wg
Zm9saW9fbWF5YmVfc2FtZV9hbm9uX3ZtYShjb25zdCBzdHJ1Y3QgZm9saW8gKmZvbGlvLA0KPiA+
ICsJY29uc3Qgc3RydWN0IHZtX2FyZWFfc3RydWN0ICp2bWEpOw0KPiANCj4gV2hhdCB0aGUgaGVs
bCBpcyB0aGlzPw0KPiANCj4gDQo+ID4gK2Fub25fcm1hcF90IGZvbGlvX2dldF9hbm9uX3JtYXAo
Y29uc3Qgc3RydWN0IGZvbGlvICpmb2xpbyk7DQo+ID4gK2Fub25fcm1hcF90IGZvbGlvX2xvY2tf
YW5vbl9ybWFwX3JlYWQoY29uc3Qgc3RydWN0IGZvbGlvICpmb2xpbywNCj4gPiArCXN0cnVjdCBy
bWFwX3dhbGtfY29udHJvbCAqcndjKTsNCj4gPiArDQo+ID4gK3N0YXRpYyBpbmxpbmUgc3RydWN0
IHZtX2FyZWFfc3RydWN0ICphbm9uX3JtYXBfaXRlcl9maXJzdF92bWEoDQo+ID4gKwlhbm9uX3Jt
YXBfdCBhbm9uX3JtYXAsIHVuc2lnbmVkIGxvbmcgc3RhcnQsIHVuc2lnbmVkIGxvbmcgbGFzdCwN
Cj4gPiArCXN0cnVjdCBhbm9uX3ZtYV9jaGFpbiAqKmF2YykNCj4gPiArew0KPiA+ICsJc3RydWN0
IGFub25fdm1hICphbm9uX3ZtYSA9DQo+IGFub25fcm1hcF90b19hbm9uX3ZtYShhbm9uX3JtYXAp
Ow0KPiA+ICsNCj4gPiArCSphdmMgPSBhbm9uX3ZtYV9pbnRlcnZhbF90cmVlX2l0ZXJfZmlyc3Qo
JmFub25fdm1hLT5yYl9yb290LA0KPiBzdGFydCwgbGFzdCk7DQo+ID4gKwlyZXR1cm4gKmF2YyA/
ICgqYXZjKS0+dm1hIDogTlVMTDsNCj4gPiArfQ0KPiANCj4gU28gd2UncmUgYWxsb3dpbmcgZm9y
IGZvbGlvcyB0byBoYXZlIE5VTEwgZW50cmllcyAocmVhbGx5IHRoZSBjb21taXQgbWVzc2FnZQ0K
PiBzaG91bGQgaGF2ZSB0aGF0LCByYXRoZXIgdGhhbiBtZSBzY2FubmluZyB0aHJvdWdoIHVuY29t
bWVudGVkIGNvZGUpLCBidXQNCj4gaW4gd2hhdCB3b3JsZCBhcmUgd2Ugb2sgd2l0aCBhbiBhbm9u
IGZvbGlvIE5PVCBCRUlORyBMSU5LRUQgQkFDSyBUTyBJVFMNCj4gVk1BPw0KPiANCj4gVGhhdCdz
IGJyb2tlbiBubz8NCj4gDQpJ4oCZbSBub3Qgc3VyZSBJIHVuZGVyc3RhbmQgeW91ciBxdWVzdGlv
bi4gQXJlIHlvdSBhc2tpbmcgd2hldGhlciB3ZSBzaG91bGQgY2hlY2sgdGhhdCAqYXZjIGlzIG5v
buKAkU5VTEw/DQoNCkhlcmUsIGFub25fcm1hcF9mb3JlYWNoX3ZtYSgpIGlzIHVzZWQgdG8gcmVw
bGFjZSBhbm9uX3ZtYV9pbnRlcnZhbF90cmVlX2ZvcmVhY2guDQpBZnRlciBvYnRhaW5pbmcgYXZj
LCB3ZSB0aGVuIGNoZWNrIHRoYXQgaXQgaXMgbm9u4oCRTlVMTC4NCg0KI2RlZmluZSBhbm9uX3Zt
YV9pbnRlcnZhbF90cmVlX2ZvcmVhY2goYXZjLCByb290LCBzdGFydCwgbGFzdCkJCSBcDQoJZm9y
IChhdmMgPSBhbm9uX3ZtYV9pbnRlcnZhbF90cmVlX2l0ZXJfZmlyc3Qocm9vdCwgc3RhcnQsIGxh
c3QpOyBcDQoJICAgICBhdmM7IGF2YyA9IGFub25fdm1hX2ludGVydmFsX3RyZWVfaXRlcl9uZXh0
KGF2Yywgc3RhcnQsIGxhc3QpKQ0KDQoNCj4gPiArDQo+ID4gK2Jvb2wgZm9saW9fbWF5YmVfc2Ft
ZV9hbm9uX3ZtYShjb25zdCBzdHJ1Y3QgZm9saW8gKmZvbGlvLA0KPiA+ICsJY29uc3Qgc3RydWN0
IHZtX2FyZWFfc3RydWN0ICp2bWEpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBhbm9uX3ZtYSAqYW5v
bl92bWE7DQo+ID4gKwlzdHJ1Y3QgYW5vbl92bWEgKnRndF9hbm9uX3ZtYSA9IHZtYS0+YW5vbl92
bWE7DQo+ID4gKwlib29sIHNhbWUgPSBmYWxzZTsNCj4gPiArDQo+ID4gKwlyY3VfcmVhZF9sb2Nr
KCk7DQo+ID4gKwlhbm9uX3ZtYSA9IGZvbGlvX2Fub25fdm1hKGZvbGlvKTsNCj4gPiArCWlmIChh
bm9uX3ZtYSAmJiB0Z3RfYW5vbl92bWEpDQo+ID4gKwkJc2FtZSA9IGFub25fdm1hLT5yb290ID09
IHRndF9hbm9uX3ZtYS0+cm9vdDsNCj4gPiArCXJjdV9yZWFkX3VubG9jaygpOw0KPiA+ICsJcmV0
dXJuIHNhbWU7DQo+IA0KPiBXaGF0IFZNQSBsb2NrcyBhcmUgYmVpbmcgaGVsZCBhdCB0aGlzIHBv
aW50PyBZb3UgYXNzZXJ0IG5vbmUuDQo+IA0KPiBXaHkgaXMgaXQgbWF5YmU/DQo+IA0KPiBXaHkg
YXJlIHlvdSB0YWtpbmcgdGhlIFJDVSBsb2NrPw0KPiANCg0KVXNpbmcgb25seSBhbm9uX3ZtYS0+
cm9vdCBpcyBqdXN0IGEgc2ltcGxlIHByZWxpbWluYXJ5IGNoZWNrOyBpdCBpcw0KbmVjZXNzYXJ5
IHRvIG9idGFpbiB0aGUgUFRFIHRvIGRldGVybWluZSB3aGV0aGVyIHRoZSBwYWdlIGlzIGFjdHVh
bGx5DQp1c2VkIGJ5IHRoaXMgYW5vbl92bWENCg0KVGhlIGFub25fdm1hIG9idGFpbmVkIGZyb20g
Zm9saW9fYW5vbl92bWEoZm9saW8pIG11c3QgYmUgYWNjZXNzZWQNCnVuZGVyIFJDVTsgb3RoZXJ3
aXNlIGl0IG1heSBhbHJlYWR5IGhhdmUgYmVlbiBmcmVlZC4NCg0K

