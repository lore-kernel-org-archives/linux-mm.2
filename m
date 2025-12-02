Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490FAD116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 02:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B526B0011; Mon,  1 Dec 2025 21:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803486B0012; Mon,  1 Dec 2025 21:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73FDB6B0022; Mon,  1 Dec 2025 21:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61F146B0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:28:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ED2D858FA9
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:28:13 +0000 (UTC)
X-FDA: 84172946466.09.09B2630
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7DD19C0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:28:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764642492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KTeiarc1R6RZdee8q1HNyhHEwwTrgEZzcxMvKZpBErE=;
	b=tVbD8+Oyrf9R/1vNXsmNIbp2/XbGaBw9jwSrcLMRHxwjAUxazXFJx8TEbnG3AV2wbrXJIK
	gcRMK/KU8H6vLH7FoD1Z3Qx6AdI4jCwpE/NW+mItsoul4fJkMEZ/ReVf39oc00rHylHaNr
	Y1kPTqtsMjQSVZhm575iKzk3BRNkxyk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764642492; a=rsa-sha256;
	cv=none;
	b=2lvK8YGlu6Lh+RUUjcqBFitM5eRJ3E73C75KpQl6QCDzGQ4EW3Pp46r903kof8wqhDSasr
	BgpMCI36KLYrDzbjegNbLdFRTqR8VChFabDMGkbwN3BU8nCEPHQkqZcP9Ih31QHiyOL4B0
	EiTbzL4po61/U3WeakQeE1pKY0RtWwg=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dL4Qq0TGlzYky8L;
	Tue,  2 Dec 2025 10:26:43 +0800 (CST)
Received: from w006.hihonor.com (10.68.23.5) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Tue, 2 Dec
 2025 10:28:07 +0800
Received: from w002.hihonor.com (10.68.28.120) by w006.hihonor.com
 (10.68.23.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 2 Dec
 2025 10:28:06 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Tue, 2 Dec 2025 10:28:06 +0800
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
 00025326" <zhongjinji@honor.com>, Kairui Song <ryncsn@gmail.com>, Yuanchu Xie
	<yuanchu@google.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Topic: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Index: AQHcYBJK8KKXMResfEqv9fHMnnJz9rUHrbeAgAAP74CAA+3ugIAApiiQ//+VEACAAImM4P//h9UAgACJZRD//5W2AAAWOtvA//+33AD//t6j0A==
Date: Tue, 2 Dec 2025 02:28:06 +0000
Message-ID: <77df8abc718148169e72d6a132d302ba@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
 <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com>
 <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
 <66c62243a510421db938235a99a242bf@honor.com>
 <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
 <dc8ce4f329d74a24bde62c93818df44a@honor.com>
 <CAGsJ_4w16G+AngPu48SEy1H+ZuE1AQngiY=cSfEs9V6=OUKX_Q@mail.gmail.com>
 <48ba80e93270438994db78f74a7acdb9@honor.com>
 <CAGsJ_4yY5MxOYjkQx07U2UzgL8mCZWCaVXyJ7e6hQ8UyVCcC8g@mail.gmail.com>
In-Reply-To: <CAGsJ_4yY5MxOYjkQx07U2UzgL8mCZWCaVXyJ7e6hQ8UyVCcC8g@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: f71s14mi53tozen17feg37rbqiatpzts
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DD19C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764642491-643059
X-HE-Meta: U2FsdGVkX1+sMLxse+6CC5n+VU1ZtY6KfEUAi11dLpPyGKz4PnoCV9Fu/63Q+e9fvqNmH1cVpAoCJRBcJIN2clINBykPuMNe4zTQNOPssniDnDmDVmmNdnL2QGUNSu3I6ZuqAJmBY7SL+wMWiLiFD5CuYSaiECViCs4oPAAUmKRjdOAuuSG3ba+5QgXJV/zRAfVKCdsZvUt/zx9QR2VLWygJnjhqgScyfxV7aHw7km0qt+LoCF1etn4Bu01+zSKcDrU2hKSsXN2aqjtMVpECFLDQgjSqUP5IS9Gh0DdWLxGPaaQTNe2iHtsT9kzo7SEaCF/stpKG8NardTVV67gGih5fEPrNoNH2oDmoP1i3MutKsaNkpXV3+bweIZ0veEzVFiHTvDwDSLf7nPzBvk0Z6Zv7NG0kMJLX+dVezG7WYof5dOG/p2eTWBelke0H5sdZXslZHc6hTfrBYbaXkYkVPNlJnH/8kiGBF58bvbhqubsRnyaZWMwv9UrnGGdK75VbFJFHGBxi7FWhhqDAONEju/5UuUwKXKaPOUhmJIpzoe82DuoPDC/a+544JH4wJv/Z/dwedZ6OGNqmxm52WfA4UQwUnAB3Bu1bBjEpa/jHuuxwcgJj37v+xCRKH5dTUn2m+f4RHxIZs87efx+9ZDB35YtZn3n/47MWPvUR+0zePsYqbsgsjdUMB+ED9l3Zc9dBckxoJ2j+uC9CDBHLN3xlbq3izg9hX3MyVXV/2xTfE5cr/IOltsFZx92GUdI6i2vZX14LASfu5TIsvVn7mkmElpFSGtW37hrh+ThCo4cWwLMqSMQ/0SYhL9LxOaTcwJHu1QE5fu3klHoSGu0oODyZelmB4cCnKn+lJ/WNGTIgAfBN0vxY0ks8k6/tn7yeX+eiFi8XVcdHUOXtlTJlsrI/H80d18063gQs3+nC2MGi8Fea8GtqLhaJYpN3NtA8/aafTIY/1REjSdTkNTlORLh
 Rtnd25PQ
 cHYsZSKY/1ODWRvm1vPpjFOuXmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNCj4gVGhlbiBwbGVhc2UgY2hlY2sgd2l0aCBTdXJlbiB3aGV0aGVyIGl0IGlz
IHBvc3NpYmxlIHRvIGJhY2twb3J0IHRoaXMgdG8NCj4gdGhlIEFuZHJvaWQgY29tbW9uIGtlcm5l
bC4NCj4gTXkgdW5kZXJzdGFuZGluZyBpcyB0aGF0IHRoaXMgc2hvdWxkIGFscmVhZHkgYmUgcHJl
c2VudCBpbiB0aGUgQW5kcm9pZCA2LjEyDQo+IGtlcm5lbC4NCj4gDQpUaGFua3MgZm9yIHRoZSBy
ZW1pbmRpbmcuDQoNCj4gPg0KPiA+IFNpbmNlIHRoZSBtYXggc3dhcHBpbmVzcyBpcyAyMDAsIHRo
ZXJlIGFyZSBxdWl0ZSBzY2VuYXJpb3MgdGhhdCBmaWxlDQo+ID4gcGFnZXMgYXJlIHRoZSBvbmx5
IG9wdGlvbi4NCj4gPg0KPiA+IFF1b3RlIGZyb20ga2FpcnVpJ3MgcmVwbHk6DQo+ID4gPiBSaWdo
dCwgd2UgYXJlIHNlZWluZyBzaW1pbGFyIHByb2JsZW1zIG9uIG91ciBzZXJ2ZXIgdG9vLiBUbyB3
b3JrYXJvdW5kDQo+ID4gPiBpdCB3ZSBmb3JjZSBhbiBhZ2UgaXRlcmF0aW9uIGJlZm9yZSByZWNs
YWltaW5nIHdoZW4gaXQgaGFwcGVucywgd2hpY2gNCj4gPiA+IGlzbid0IHRoZSBiZXN0IGNob2lj
ZS4gV2hlbiB0aGUgTFJVIGlzIGxvbmcgYW5kIHRoZSBvcHBvc2l0ZSB0eXBlIG9mDQo+ID4gPiB0
aGUgZm9saW9zIHdlIHdhbnQgdG8gcmVjbGFpbSBpcyBwaWxpbmcgdXAgaW4gdGhlIG9sZGVzdCBn
ZW4sIGEgZm9yY2VkDQo+ID4gPiBhZ2Ugd2lsbCBoYXZlIHRvIG1vdmUgYWxsIHRoZXNlIGZvbGlv
cywgd2hpY2ggbGVhZHMgdG8gbG9uZyB0YWlsaW5nDQo+ID4gPiBpc3N1ZXMuIExldCdzIHdvcmsg
b24gYSByZWFzb25hYmxlIHNvbHV0aW9uIGZvciB0aGF0Lg0KPiA+DQo+IA0KPiBXZSBhbGwgYWdy
ZWUgdGhhdCBNR0xSVSBoYXMgdGhpcyBnZW5lcmF0aW9uIGlzc3VlLiBZb3UgbWVudGlvbmVkIGl0
LCBJDQo+IGFncmVlZA0KPiBhbmQgbm90ZWQgdGhhdCBib3RoIEthaXJ1aSBhbmQgSSBoYWQgb2Jz
ZXJ2ZWQgaXQuIFRoZW4gS2FpcnVpIHJlcGxpZWQgdGhhdCBoZQ0KPiBoYWQgaW5kZWVkIHNlZW4g
aXQgYXMgd2VsbC4gTm93IHlvdSBhcmUgdXNpbmcgS2FpcnVp4oCZcyByZXBseSB0byBhcmd1ZSBh
Z2FpbnN0DQo+IG1lLCBhbmQgSSBob25lc3RseSBkb27igJl0IHVuZGVyc3RhbmQgdGhlIGxvZ2lj
IGJlaGluZCB5b3VyIHJlc3BvbnNlcy4NCj4gDQoNCk15IGFwb2xvZ2l6ZSBpZiBteSBwcmV2aW91
cyB3b3JkaW5nIGNhdXNlZCBhbnkgY29uZnVzaW9uLg0KDQpUaGUgb25seSB0aGluZyB0aGUgcGF0
Y2hzZXQgKHdhbnQgdG8pIGRvIGlzIGZvcmNpbmcgMi8zIGdlbnMgYWdpbmcgcmlnaHQgYmVmb3Jl
IHByb2FjdGl2ZQ0KcmVjbGFpbSwgYW5kIGl0IGhlbHBzIHJlY2xhaW0gbW9yZSBhbm9uIHBhZ2Vz
IGFuZCBwcmVzZXJ2ZSBtb3JlIGZpbGUgcGFnZXMgdW5kZXINCmNlcnRhaW4gd29ya2xvYWQuICg0
MDB+ODAwTUIgTWVtQXZhaWxhYmxlIGltcHJvdmVtZW50KS4NCg0KVGhlIHJlYXNvbiBmb3IgcXVv
dGluZyBLYWlydWkncyByZXBseToNCmBmb3JjZSBhZ2luZyAyLzMgZ2VucyBiZWZvcmUgcmVjbGFp
bWAgd291bGQgYmUgcm91Z2hseSBzaW1pbGFyIGluIHNwaXJpdCB0byB3aGF0IEthaXJ1aQ0KcmVm
ZXJyZWQgdG8gYCBmb3JjZSBhbiBhZ2UgaXRlcmF0aW9uIGJlZm9yZSByZWNsYWltaW5nYCwgZnJv
bSBteSB1bmRlcnN0YW5kaW5nLg0KDQpJZiBteSB1bmRlcnN0YW5kaW5nIGlzIGluYWNjdXJhdGUs
IHBsZWFzZSBmZWVsIGZyZWUgdG8gY29ycmVjdCBtZS4NCg0KPiA+IEFnYWluLCB0aGFuayB5b3Ug
Zm9yIHlvdXIgZ3VpZGFuY2UuIFdlIHdpbGwgY2FyZWZ1bGx5IGV2YWx1YXRlIHRoZQ0KPiA+IFBh
dGNoc2V0WzFdIHlvdSByZWNvbW1lbmRlZC4NCj4gPg0KPiA+ID4gSGkgWmljaGVuZywNCj4gPiA+
DQo+ID4gPiBPbiBNb24sIERlYyAxLCAyMDI1IGF0IDU6NTXigK9QTSB3YW5nemljaGVuZyA8d2Fu
Z3ppY2hlbmdAaG9ub3IuY29tPg0KPiA+ID4gd3JvdGU6DQo+ID4gPiA+DQo+ID4gPiA+IEhpIEJh
cnJ5LA0KPiA+ID4gPg0KPiA+ID4gPiBUaGFuayB5b3UgZm9yIHRoZSBjb21tZW50LCBhY3R1YWxs
eSB3ZSBkbyBrbm93IHRoZSBjZ3JvdXAgZmlsZS4NCj4gPiA+ID4NCj4gPiA+ID4gV2hhdCB3ZSBy
ZWFsbHkgbmVlZCBpcyB0byAqcHJvYWN0aXZlIGFnaW5nIDJ+MyBnZW5zKiBiZWZvcmUgcHJvYWN0
aXZlDQo+ID4gPiByZWNsYWltLg0KPiA+ID4gPiAoZXNwZWNpYWxseSBhZnRlciBjb2xkIGxhdW5j
aGVzIHdoZW4gbm8gYW5vbiBwYWdlcyBpbiB0aGUgb2xkZXN0IGdlbnMpDQo+ID4gPiA+DQo+ID4g
PiA+IFRoZSBwcm9hY3RpdmUgYWdpbmcgYWxzbyBoZWxwcyBkaXN0cmlidXRlIHRoZSBhbm9uIGFu
ZCBmaWxlIHBhZ2VzIGV2ZW5seQ0KPiBpbg0KPiA+ID4gPiBNR0xSVSBnZW5zLiBBbmQgcmVjbGFp
bWluZyB3b24ndCBmYWxsIGludG8gZmlsZSBjYWNoZXMuDQo+ID4gPg0KPiA+ID4gSeKAmW0gbm90
IHF1aXRlIHN1cmUgd2hhdCB5b3UgbWVhbiBieSDigJxyZWNsYWltaW5nIHdvbuKAmXQgZmFsbCBp
bnRvIGZpbGUNCj4gY2FjaGVzLuKAnQ0KPiA+ID4NCj4gPiA+IEkgYXNzdW1lIHlvdSBtZWFuIHlv
dSBjb25maWd1cmVkIGEgaGlnaCBzd2FwcGluZXNzIGZvciBNR0xSVQ0KPiBwcm9hY3RpdmUNCj4g
PiA+IHJlY2xhbWF0aW9uLCBzbyB3aGVuIGJvdGggYW5vbiBhbmQgZmlsZSBoYXZlIGZvdXIgZ2Vu
ZXJhdGlvbnMsDQo+ID4gPiBgZ2V0X3R5cGVfdG9fc2NhbigpYCBlZmZlY3RpdmVseSBhbHdheXMg
cmV0dXJucyBhbm9uPw0KPiA+ID4NCj4gPiA+ID4NCj4gPiA+ID4gPiBBbHNvIG5vdGUgdGhhdCBt
ZW1jZyBhbHJlYWR5IGhhcyBhbiBpbnRlcmZhY2UgZm9yIHByb2FjdGl2ZQ0KPiByZWNsYW1hdGlv
biwNCj4gPiA+ID4gPiBzbyBJ4oCZbSBub3QgY2VydGFpbiB3aGV0aGVyIHlvdXIgcGF0Y2hzZXQg
Y2FuIGNvZXhpc3Qgd2l0aCBpdCBvciBleHRlbmQNCj4gPiA+ID4gPiBpdCB0byBtZWV0IHlvdXIg
cmVxdWlyZW1lbnRz4oCUd2hpY2ggc2VlbXMgcXVpdGUgaW1wb3NzaWJsZSB0byBtZQ0KPiA+ID4g
PiA+DQo+ID4gPiA+ID4gbWVtb3J5LnJlY2xhaW0NCj4gPiA+ID4gPiAgICAgICAgIEEgd3JpdGUt
b25seSBuZXN0ZWQta2V5ZWQgZmlsZSB3aGljaCBleGlzdHMgZm9yIGFsbCBjZ3JvdXBzLg0KPiA+
ID4gPiA+DQo+ID4gPiA+ID4gICAgICAgICBUaGlzIGlzIGEgc2ltcGxlIGludGVyZmFjZSB0byB0
cmlnZ2VyIG1lbW9yeSByZWNsYWltIGluIHRoZQ0KPiA+ID4gPiA+ICAgICAgICAgdGFyZ2V0IGNn
cm91cC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+ICAgICAgICAgRXhhbXBsZTo6DQo+ID4gPiA+ID4N
Cj4gPiA+ID4gPiAgICAgICAgICAgZWNobyAiMUciID4gbWVtb3J5LnJlY2xhaW0NCj4gPiA+ID4g
Pg0KPiA+ID4gPiA+ICAgICAgICAgUGxlYXNlIG5vdGUgdGhhdCB0aGUga2VybmVsIGNhbiBvdmVy
IG9yIHVuZGVyIHJlY2xhaW0gZnJvbQ0KPiA+ID4gPiA+ICAgICAgICAgdGhlIHRhcmdldCBjZ3Jv
dXAuIElmIGxlc3MgYnl0ZXMgYXJlIHJlY2xhaW1lZCB0aGFuIHRoZQ0KPiA+ID4gPiA+ICAgICAg
ICAgc3BlY2lmaWVkIGFtb3VudCwgLUVBR0FJTiBpcyByZXR1cm5lZC4NCj4gPiA+ID4gPg0KPiA+
ID4gPiBUaGlzIHJlbWluZCBtZSB0aGF0IGFkZGluZyBhIGBtZW1vci5hZ2luZ2AgdW5kZXIgbWVt
Y2cgZGlyZWN0b3JpZXMNCj4gPiA+ID4gcmF0aGVyIHRoYW4gYWRkaW5nIG5ldyBwcm9jZnMgZmls
ZXMgaXMgYWxzbyBhIGdyZWF0IG9wdGlvbi4NCj4gPiA+DQo+ID4gPiBJIHN0aWxsIGRvbuKAmXQg
dW5kZXJzdGFuZCB3aHkuIEFnaW5nIGlzIHNvbWV0aGluZyBNR0xSVSBpdHNlbGYgc2hvdWxkDQo+
ID4gPiBoYW5kbGU7IGNvbXBvbmVudHMgb3V0c2lkZSBNR0xSVSwgc3VjaCBhcyBjZ3JvdXAgdjIs
IGRvIG5vdCBuZWVkIHRvDQo+IGJlDQo+ID4gPiBhd2FyZSBvZiB0aGlzIGNvbmNlcHQgYXQgYWxs
LiBFeHBvc2luZyBpdCB3aWxsIGxpa2VseSBsZWFkIHRvIGFub3RoZXINCj4gPiA+IGltbWVkaWF0
ZSBOQUsuDQo+ID4gPg0KPiA+ID4gSW4gc2hvcnQsIGFnaW5nIHNob3VsZCByZW1haW4gd2l0aGlu
IE1HTFJV4oCZcyBpbnRlcm5hbCBzY29wZS4NCj4gPg0KPiA+IEkgd291bGQgbGlrZSB0byBleHBy
ZXNzIGEgZGlmZmVyZW50IHBvaW50IG9mIHZpZXcuIFdlIGFyZSB3b3JraW5nIG9uDQo+IHNvbWV0
aGluZw0KPiA+IEludGVyZXN0aW5nIG9uIGl0LCB3aWxsIGJlIHNoYXJlZCBvbmNlIHJlYWR5Lg0K
PiANCj4gWW91IGFyZSBhbHdheXMgd2VsY29tZSB0byBzaGFyZSwgYnV0IHBsZWFzZSB1bmRlcnN0
YW5kIHRoYXQgbWVtb3J5LmFnaW5nDQo+IGlzDQo+IG5vdCBvZiBpbnRlcmVzdCB0byBhbnkgbW9k
dWxlIG91dHNpZGUgdGhlIHNjb3BlIG9mIE1HTFJVIGl0c2VsZi4gQW4NCj4gaW50ZXJmYWNlDQo+
IGlzIGFuIGludGVyZmFjZSwgYW5kIGludGVybmFsIGltcGxlbWVudGF0aW9uIHNob3VsZCByZW1h
aW4gaW50ZXJuYWwuIEluIG90aGVyDQo+IHdvcmRzLCB0aGVyZSBpcyBubyByZWFzb24gZm9yIGNn
cm91cHYyIHRvIGJlIGF3YXJlIG9mIHdoYXQg4oCcYWdpbmfigJ0gaXMuDQo+IA0KPiBZb3UgbWF5
IHN1Ym1pdCB5b3VyIG5ldyBjb2RlIGFzIGEgImZpeCIgZm9yIHRoZSBnZW5lcmF0aW9uIGlzc3Vl
IHdpdGhvdXQNCj4gaW50cm9kdWNpbmcgYSBuZXcgaW50ZXJmYWNlLiBUaGF0IHdvdWxkIGJlIGEg
Z29vZCBzdGFydGluZyBwb2ludCBmb3INCj4gZGlzY3Vzc2luZyBob3cgdG8gcmVzb2x2ZSB0aGUg
cHJvYmxlbS4NCj4gDQoNCkNvbXBsZXRlbHkgYWdyZWUgd2l0aCB5b3VyIGd1aWRhbmNlLg0KV2Ug
d2lsbCByZXZpc2l0IHRoZSBkZXNpZ24gYW5kIHRoaW5rIGFib3V0IHRoZSBuZXh0IHZlcnNpb24s
IGFuZCB0cnkgdG8ga2VlcCB0aGUNCm1lY2hhbmlzbSBpbnRlcm5hbGx5Lg0KDQo+ID4NCj4gPiA+
DQo+ID4gPiBCdXQgaXQgc2VlbXMgeW91IGRvIHdhbnQgc29tZSBwb2xpY3kgY29udHJvbCBmb3Ig
eW91ciBwcm9hY3RpdmUNCj4gPiA+IHJlY2xhbWF0aW9uLCBzdWNoIGFzIGFsd2F5cyByZWNsYWlt
aW5nIGFub24gcGFnZXMgb3IgcmVjbGFpbWluZyB0aGVtDQo+ID4gPiBtb3JlIGFnZ3Jlc3NpdmVs
eSB0aGFuIGZpbGUgcGFnZXMuIEkgYXNzdW1lIFpob25na3Vu4oCZcyBwYXRjaCBbMV0gd2UNCj4g
PiA+IG1lbnRpb25lZCBlYXJsaWVyIHNob3VsZCBwcm92aWRlIHN1cHBvcnQgZm9yIHRoYXQsIGNv
cnJlY3Q/DQo+ID4gPg0KPiA+ID4gQXMgYSB3b3JrYXJvdW5kLCB5b3UgY2FuIHNldCBgc3dhcHBp
bmVzcz1tYXhgIGZvciBgbWVtb3J5LnJlY2xhaW1gDQo+ID4gPiBiZWZvcmUNCj4gPiA+IHdlIGlu
dGVybmFsbHkgaW1wcm92ZSB0aGUgaGFuZGxpbmcgb2YgdGhlIGFnaW5nIGlzc3VlLiBJbiBzaG9y
dCwNCj4gPiA+IOKAnHByb2FjdGl2ZSBhZ2luZ+KAnSBhbmQgc2ltaWxhciBtZWNoYW5pc21zIHNo
b3VsZCBiZSBoYW5kbGVkDQo+IGF1dG9tYXRpY2FsbHkNCj4gPiA+IGFuZCBpbnRlcm5hbGx5IHdp
dGhpbiB0aGUgc2NvcGUgb2YgdGhlIE1HTFJVIGNvZGUuDQo+ID4NCj4gPiBTdXJlLCB3ZSB3aWxs
IG1ha2UgYSBjYXJlZnVsIGV2YWx1YXRpb24uDQo+IA0KPiBUaGFua3MNCj4gQmFycnkNCg0KQmVz
dCwNClppY2hlbmcNCg==

