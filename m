Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2143D116E2
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE236B0010; Mon,  1 Dec 2025 03:14:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E9F6B0022; Mon,  1 Dec 2025 03:14:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BABA46B0023; Mon,  1 Dec 2025 03:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AA1176B0010
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:14:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA8EF16068D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:14:23 +0000 (UTC)
X-FDA: 84170190006.17.413B7E3
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf01.hostedemail.com (Postfix) with ESMTP id B85EA40008
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:14:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764576861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4W91DC4srourSKv6KoDRLsqHbZbIZMR8Hu3Xm+Wqip0=;
	b=Qd/XseaigB1KflRLvFWZGcLVsjvpV7z0H9u7pyqlpMYClMcwMYSq6W/f44TLug6CTw6KDe
	wnFgCt4ZjssiIzhJUEf0MkT4IRbhcI1mvLMMJDrD0SzTslM/2QwO7IoACI+B3Jt+U2xQQL
	X5dvCH4KzRRsMH1idQP+fYSXwvsapWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764576861; a=rsa-sha256;
	cv=none;
	b=WYtm6Lx4JFwYZeYtB4ThVjEBTwxVrBup0pn6Dp1udcDE2f4J8FQYO9HDtVD6mGGAhP6c1w
	hei7ErSdqOySw3vJwPugzDqJ1wkuiGL5iFFr6mY3R4ZTcJ5t1LMsmhFMCLt2ehYOfBhfqq
	D81Q9JCxA331lAbkzqQRhyt+yRVf0Tc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4dKc7W6jvzzYlt03;
	Mon,  1 Dec 2025 16:11:51 +0800 (CST)
Received: from w002.hihonor.com (10.68.28.120) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 16:14:14 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Mon, 1 Dec 2025 16:14:14 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"mhocko@kernel.org" <mhocko@kernel.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao
	<tao.wangtao@honor.com>, wangzhen 00021541 <wangzhen5@honor.com>, "zhongjinji
 00025326" <zhongjinji@honor.com>, Kairui Song <ryncsn@gmail.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Topic: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Index: AQHcYBJK8KKXMResfEqv9fHMnnJz9rUHrbeAgAAP74CAA+3ugIAApiiQ//+VEACAAImM4A==
Date: Mon, 1 Dec 2025 08:14:14 +0000
Message-ID: <66c62243a510421db938235a99a242bf@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
 <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com>
 <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
In-Reply-To: <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B85EA40008
X-Stat-Signature: p546hbwyw6k5d86qmsksduqsbhfwhq8r
X-Rspam-User: 
X-HE-Tag: 1764576860-436951
X-HE-Meta: U2FsdGVkX1/raawW5xltMQrB9eRlGSlJWoFGbvNQPlZfyGjO9ia5EE4rtpOBpcIHKWPG1KMz8Zzku1Emh9jmTU7ywwS+9wVwYR0caNKkhhzQj6OzGraSP9srcR85RKRoLyuu1aOJCkVNbfA4NcLOnqDAoblHz+NQ6ldyIRhpb61PJGyxJS7fFKYtNWw5kRt/zuSTnFzhPcHomahM9hQgYHudN9CyDke5vML5wiXyzb8YwWbEUsgflzuKzkiMlz193Vpl3BrauRTlLJ7Al2fe7yrNdxArhPmXqS5A8cLBX88Mmaf9IDqtkXkYtKeHv8ODe9/m00pIuS2cRqKP+BSy76R7WwALekRUXlTFabXpYpj/YLUjb7gmdb4YU3uQaxELko+NgMdnxgk5wSykogycOd9vznUOiCAPMPEXQ9xRYBHYxLUNCerSdo5ZZ2ol4F5MNl1N70zDsjneLvzRCx3wwP+Orjm3yrAq2nyuEbPQwWpAvrAIaVRbk7ATsU2jzYXw+rx33UvgANAfLhuuORD9g87RgAW7lcbYDyMfpmMsHzLugqjXtnQd5GRVRoBIpD/lOAY3dQJsA1ybGR8+uczET5m4upHtW1qLgQrlDu7OrNA8pqKmiiQYDyQj2efvUNO6xMiGvYEr8tu79iFEWcXjeUQJKFVRK7AgixrJNNs+KRDx6cTI33ZmwFp58VWLKsfWr4qmBq+yUR4s1ZN7cUrSw9XaZHjwclHJsNgUDRG5cEaLud98zjnLO2BguNKkIZ5qZGL2V/t18LV64Z3dNRqIsOD1ttE1K2HXCkdE2S4Wdc7eLk7GbgBpuISsV/fG8bXuFIxwhzfYOjdyARlu7W0wQ3+78W43XXgL1q5IHVCAHTffp4KQzfR93KxU5l0fM2cIrDrz3igDJ0xboC+xJT4S9hSn5b5MnEDhLk2+sRRBNyIIHf9JRXv88+AbOp7CAJJvvZtgV9ENM9XZjwzfE++
 L8UYnDTn
 /d0UOw51Zv3J7PHQJzmm6im1Y40HdHoxlQTP2MJxWFha4PjrzNf+NTpR66nFM0cipzqwD9zpa0zuJbkHjSFTGVm8gaKGeH/yHincvbqejnxrjR18spnNgJXR/McbAUj/MSNwfRp2CBBQxHR4E2Jj1+z1b8L7hdkZkRg00D1Ak+XogZEN9UYaS69ZtJk5fCP7STpIQ/pka+RtxjVWZP08DrRKtUpxnGrvGnB5MvklRiKkuy/YhDnsrw6YHV17vzXNnI33B1SCfKEgAq0BVsT+uMvzi2Y2tfcOK2LmI3Sjqj68Iiu+EoLj1qutHVRQvnFT2OvB5jWr8/oYionpugX7FuaM6E0690rnlO7gkLrnRLvFxuJQD5CTP2zYEE7CkoPo37MWs8akzJpDyFC0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiANCj4gSSBzdHJvbmdseSByZWNvbW1lbmQgc2VwYXJhdGluZyB0aGlzIGZyb20geW91ciBwYXRj
aHNldC4gQXZvaWQgaW5jbHVkaW5nDQo+IHVucmVsYXRlZCBjaGFuZ2VzIGluIGEgc2luZ2xlIHBh
dGNoc2V0Lg0KPiANClRoYW5rIHlvdSBmb3IgdGhlIGNsYXJpZmljYXRpb24sIHNlcGFyYXRpbmcg
aXQgZnJvbSBvdXIgcGF0Y2hzZXQgbWFrZXMgc2Vuc2UuDQoNClJlY2FsbCB0aGF0IGltYmFsYW5j
ZSBmaWxlL2Fub24gZ2VuZXJhdGlvbnMgaXMgb25lIG9mIHRoZSByZWFzb25zIHRvIG1vdmUgYGxy
dV9nZW5gDQpmaWxlcyBvdXQgb2YgdGhlIGRlYnVnZnMuDQoNCj4gTUdMUlUgaGFzIGEgbWVjaGFu
aXNtIHRvIGVuc3VyZSB0aGF0IGZpbGUgYW5kIGFub24gcGFnZXMgY2FuIGtlZXAgcGFjZQ0KPiB3
aXRoIGVhY2ggb3RoZXIuIEluIHRoZSBuZXdlc3Qga2VybmVsLCB0aGUgbWluaW11bSBnZW5lcmF0
aW9uIGlzIDIuIEZvcg0KPiBleGFtcGxlLCBpZiBhbm9uIGhhcyBvbmx5IDIgZ2VuZXJhdGlvbnMg
bGVmdCBhbmQgd2UgZGVjaWRlIHRvIHJlY2xhaW0gYW5vbg0KPiBmb2xpb3MsIHdlIHdpbGwgZmFs
bCBiYWNrIHRvIHJlY2xhaW1pbmcgZmlsZSBwYWdlcy4gU29tZXRpbWVzLCB0aGlzIG1lYW5zIHRo
YXQNCj4gYW5vbiByZWNsYW1hdGlvbiBpcyBpbnN1ZmZpY2llbnQgd2hpbGUgZmlsZSBwYWdlcyBh
cmUgb3Zlci1yZWNsYWltZWQuDQo+IA0KPiBzdGF0aWMgaW50IHNjYW5fZm9saW9zKHVuc2lnbmVk
IGxvbmcgbnJfdG9fc2Nhbiwgc3RydWN0IGxydXZlYyAqbHJ1dmVjLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgIHN0cnVjdCBzY2FuX2NvbnRyb2wgKnNjLCBpbnQgdHlwZSwgaW50IHRpZXIsDQo+
ICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGxpc3RfaGVhZCAqbGlzdCkgew0KPiAgICAg
ICAgIC4uLg0KPiAgICAgICAgIGlmIChnZXRfbnJfZ2VucyhscnV2ZWMsIHR5cGUpID09IE1JTl9O
Ul9HRU5TKQ0KPiAgICAgICAgICAgICAgICAgcmV0dXJuIDA7DQo+ICAgICAgICAgLi4uDQo+IH0N
Cj4gDQo+IFRoaXMgaXMgcHJvYmFibHkgbm90IGEgYnVnLCBidXQgdGhpcyBkZXNpZ24gY2FuIHNv
bWV0aW1lcyB3b3JrIHN1Ym9wdGltYWxseS4NCj4gDQoNClllcywgb3VyIHBhdGNoc2V0IGFsc28g
YWltcyB0byBzb2x2ZSBzaW1pbGFyIGNhc2VzIGJ5IHByb2FjdGl2ZSBhZ2luZyAyLzMgZ2Vucy4N
Cg0KPiBSZWdhcmRpbmcgdGhpcyBpc3N1ZSwgYm90aCBLYWlydWkgKGZyb20gdGhlIExpbnV4IHNl
cnZlciBzaWRlLCBjYy1lZCkgYW5kIEkNCj4gKGZyb20gdGhlIEFuZHJvaWQgc2lkZSkgaGF2ZSBv
YnNlcnZlZCBpdC4gVGhpcyBzaG91bGQgYmUgYWRkcmVzc2VkIGluDQo+IE1HTFJVJ3MgY29kZSwg
YW5kIHdlIGFscmVhZHkgaGF2ZSBrZXJuZWwgY29kZSBmb3IgdGhhdC4gSXQgaXMgdW5yZWxhdGVk
IHRvDQo+IHlvdXIgcGF0Y2hzZXQsIHNvIHlvdSBzaG91bGRu4oCZdCBpbmNsdWRlIHNvIG1hbnkg
dW5yZWxhdGVkIGNoYW5nZXMgaW4gYQ0KPiBzaW5nbGUgcGF0Y2hzZXQuDQo+IA0KPiBQbGVhc2Ug
a2VlcCB5b3VyIHBhdGNoc2V0IGZvY3VzZWQgc29sZWx5IG9uIHdoZXRoZXIgdGhlIE1HTFJVIHBy
b2FjdGl2ZQ0KPiByZWNsYW1hdGlvbiBpbnRlcmZhY2Ugc2hvdWxkIGJlIHByb21vdGVkIHRvIHN5
c2ZzIChMUlVfR0VOIGFscmVhZHkgaGFzIGENCj4gZm9sZGVyIGluIHN5c2ZzKSBpbnN0ZWFkIG9m
IGRlYnVnZnMsIGlmIHRoZXJlIGlzIGEgdjIuDQo+IA0KPiBUaGUgZm9sbG93aW5nIGlzIHF1b3Rl
ZCBmcm9tDQo+IGBEb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL21tL211bHRpZ2VuX2xydS5yc3Rg
Lg0KPiANCj4gUHJvYWN0aXZlIHJlY2xhaW0NCj4gLS0tLS0tLS0tLS0tLS0tLS0NCj4gUHJvYWN0
aXZlIHJlY2xhaW0gaW5kdWNlcyBwYWdlIHJlY2xhaW0gd2hlbiB0aGVyZSBpcyBubyBtZW1vcnkg
cHJlc3N1cmUuIEl0DQo+IHVzdWFsbHkgdGFyZ2V0cyBjb2xkIHBhZ2VzIG9ubHkuIEUuZy4sIHdo
ZW4gYSBuZXcgam9iIGNvbWVzIGluLCB0aGUgam9iDQo+IHNjaGVkdWxlciB3YW50cyB0byBwcm9h
Y3RpdmVseSByZWNsYWltIGNvbGQgcGFnZXMgb24gdGhlIHNlcnZlciBpdCBzZWxlY3RlZCwNCj4g
dG8gaW1wcm92ZSB0aGUgY2hhbmNlIG9mIHN1Y2Nlc3NmdWxseSBsYW5kaW5nIHRoaXMgbmV3IGpv
Yi4NCj4gDQo+IFVzZXJzIGNhbiB3cml0ZSB0aGUgZm9sbG93aW5nIGNvbW1hbmQgdG8gYGBscnVf
Z2VuYGAgdG8gZXZpY3QgZ2VuZXJhdGlvbnMNCj4gbGVzcyB0aGFuIG9yIGVxdWFsIHRvIGBgbWlu
X2dlbl9ucmBgLg0KPiANCj4gICAgIGBgLSBtZW1jZ19pZCBub2RlX2lkIG1pbl9nZW5fbnIgW3N3
YXBwaW5lc3MgW25yX3RvX3JlY2xhaW1dXWBgDQo+IA0KPiANCj4gPg0KPiA+IFNlZSB0aGUgY2Fz
ZSBpbiB0aGUgY292ZXIgbGV0dGVyLg0KPiA+IGBgYA0KPiA+IG1lbWNnICAgIDU0IC9hcHBzL3Nv
bWVfYXBwDQo+ID4gbm9kZSAgICAgMA0KPiA+IDEgICAgIDExOTgwNCAgICAgICAgICAwICAgICAg
IDg1NDYxDQo+ID4gMiAgICAgMTE5ODA0ICAgICAgICAgIDAgICAgICAgICAgIDUNCj4gPiAzICAg
ICAxMTk4MDQgICAgIDE4MTcxOSAgICAgICAxODY2Nw0KPiA+IDQgICAgICAgMTc1MiAgICAgICAg
MzkyICAgICAgICAgMjQ0DQo+ID4gYGBgDQo+ID4NCj4gPg0KPiA+IFNpbmNlIHRoZSBzZW1hbnRp
YyBnYXAgYmV0d2VlbiB1c2VyL2tlcm5lbCBzcGFjZSB3aWxsIGFsd2F5cyBleGlzdC4NCj4gPiBJ
dCB3b3VsZCBiZSBncmVhdCBiZW5lZml0cyBmb3IgbGVhdmluZyBzb21lIEFQSXMgZm9yIHVzZXIg
aGludHMsIGp1c3QNCj4gPiBsaWtlIG1tYWR2aXNlL3VzZXJmYXVsdC9wYXJhLXZpcnR1YWxpemF0
aW9uLg0KPiANCj4gTm9wZS4gVGhpcyBpcyBqdXN0IGFuIGludGVybmFsIGRldGFpbCBvZiBNR0xS
VSBhbmQgc2hvdWxkbuKAmXQgYmUgZXhwb3NlZCBhcyBhbg0KPiBpbnRlcmZhY2UuDQo+IEhvcGVm
dWxseSwgS2FpcnVpIG9yIEkgd2lsbCBzZW5kIGEgcGF0Y2hzZXQgc29vbiB0byBhZGRyZXNzIHRo
ZSBiYWxhbmNlIGlzc3VlDQo+IGJldHdlZW4gZmlsZSBhbmQgYW5vbiBwYWdlcy4gRm9yIG5vdywg
eW91IGNhbiB1c2UgYHN3YXBwaW5lc3M9MjAxYCBhcyBhDQo+IHRlbXBvcmFyeSB3b3JrYXJvdW5k
LiBUYWtlIGEgbG9vayBhdCBieXRlZGFuY2UncyBwYXRjaHNldC5bMV0NCj4gDQpTb3VuZCBncmVh
dDopLCB3ZSBhcmUgbG9va2luZyBmb3J3YXJkIHRvIGl0Lg0KDQo+ID4gRXhwb3Npbmcgc3VjaCBo
aW50cyB0byB0aGUga2VybmVsIGNhbiBoZWxwIGltcHJvdmUgb3ZlcmFsbCBzeXN0ZW0NCj4gcGVy
Zm9ybWFuY2UuDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGludXgtDQo+IG1t
L2NvdmVyLjE3NDQxNjkzMDIuZ2l0LmhlemhvbmdrdW4uaHprQGJ5dGVkYW5jZS5jb20vDQo+IA0K
QW5kIHRoYW5rIHlvdSBmb3IgdGhlIGBzd2FwcGluZXNzPTIwMWAgd29ya2Fyb3VuZCwgd2Ugd2ls
bCByZXNlYXJjaCBvbiBpdC4NCg0KPiBUaGFua3MNCj4gQmFycnkNCg0KQmVzdCwNClppY2hlbmcN
Cg==

