Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BF51D116F1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 02:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9032F6B000D; Mon,  1 Dec 2025 21:53:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9C46B0011; Mon,  1 Dec 2025 21:53:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 817236B0024; Mon,  1 Dec 2025 21:53:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 734BA6B000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:53:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74854140467
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:53:25 +0000 (UTC)
X-FDA: 84173009970.11.359CD83
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5CB9F40007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 02:53:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=VikGKJ+n;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764644003; a=rsa-sha256;
	cv=none;
	b=QVdZ4LUfYRLg0qMWOMkpOZ9v4XCE7fYcjZzKeCIXc6JKfGO6KbNDfYvb4p0hMyhnYg9eB7
	G7JeK61Ei4AdDPxkZdn2NLfQTYXuMf27bL04JAHBV/HV1po+jtxNbWigpzxjIt6nFbW6aH
	08FCoR/4udivwKQS3Qds+/6y34MZbr8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=VikGKJ+n;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764644003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQEVZ3zykOevsdXz6RetEkX7VDXIDzKoQwO4ZFh9KPk=;
	b=SsReSPY5t++JCdEKKLrgj7eeWjAIqqPRGVmmVUgrL5rRWzLcbKdpzzFBG81Lh79gvKJyvH
	W8TUhkAcORql4ME4ZNDxkXDaDakwCMoK2GI149wNg0QxK0OHwjUX10v//1R5zAWzH07ZCr
	mBBuAblDYVANmo8UE0LoWLIss49m7G0=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=ZQEVZ3zykOevsdXz6RetEkX7VDXIDzKoQwO4ZFh9KPk=;
	b=VikGKJ+nNh2FmbQj+vHkX/5IKZNXBKVjjrVTOpr+hw4J4gO+yUfO2aK987qXwi4srI4OzHiKl
	SOOa4gEc7XPxNkUvkJS8+jlaeybk4CLQ3o75ZM1l5fRrxU3U5gl+E6K4BZeoherdasZZKw0S/79
	3JoV+YT4RPqRARkb44HXqCg=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dL4zJ4YpZzYlGYB;
	Tue,  2 Dec 2025 10:51:24 +0800 (CST)
Received: from a013.hihonor.com (10.68.22.170) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 2 Dec
 2025 10:53:17 +0800
Received: from w002.hihonor.com (10.68.28.120) by a013.hihonor.com
 (10.68.22.170) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Tue, 2 Dec
 2025 10:53:17 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Tue, 2 Dec 2025 10:53:17 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Yuanchu Xie <yuanchu@google.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "david@redhat.com"
	<david@redhat.com>, "axelrasmussen@google.com" <axelrasmussen@google.com>,
	"mhocko@kernel.org" <mhocko@kernel.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao
	<tao.wangtao@honor.com>, wangzhen 00021541 <wangzhen5@honor.com>, "zhongjinji
 00025326" <zhongjinji@honor.com>, Kairui Song <ryncsn@gmail.com>, Yuanchu Xie
	<yuanchu@google.com>, Barry Song <21cnbao@gmail.com>
Subject: RE: [PATCH 2/3] mm/lru_gen: add configuration option to select
 debugfs/procfs for lru_gen
Thread-Topic: [PATCH 2/3] mm/lru_gen: add configuration option to select
 debugfs/procfs for lru_gen
Thread-Index: AQHcYBJL4aaRxfOT9U6Z/I5UwCrlA7UMznaAgADYJYA=
Date: Tue, 2 Dec 2025 02:53:16 +0000
Message-ID: <96ebbb5fb5f14322b0df5714fc23097a@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <20251128025315.3520689-3-wangzicheng@honor.com>
 <CAJj2-QFM3iwO==3JKQ4nnHfAxYJuyYXZ6uNJUR8rQdf_Q_1x0A@mail.gmail.com>
In-Reply-To: <CAJj2-QFM3iwO==3JKQ4nnHfAxYJuyYXZ6uNJUR8rQdf_Q_1x0A@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5CB9F40007
X-Stat-Signature: d4twdnamwkh9mox5u1uay14y15x8c8g3
X-Rspam-User: 
X-HE-Tag: 1764644002-188706
X-HE-Meta: U2FsdGVkX19yE5JGah1umnehsNbM44tCjIoIl4cUMMkQNyKw5ZheiinRYpYWi8CyEQkFa09nTWBO0ALsQXpJNDpAXajK1i2r8RgAQIbSJ2I1RMJx7wqmaZ+9AYr6cTXwDoGwG1xwwOIlcCSesxUk8zmxp94/ZZKERWCkDFH5R/wvsj+JNtS31xmKZy6mNMWhJl30T7875go2jjW6xIL4iA/K+uZVDu1neLuL8wovj2w8zj+K3eSY0brsqnmDMKVzVpV/DaWc/m7jQcK8uM1j/mrVbqBtn7KlhHzDjk0dkAgV03XqFhXMu50042nDjM7duhXQ4IG2rLvdRdh+XCRIZMw+ubUG4HG/j5YIG7eQvJIkk14Hao3u3EFCNrzLqfyAxrvVDvL5FUWLhKSeST6vErjrVxQ9yo3x2L05tZalbbBSCr+1NNzTMwTjzmeb5Sy51R85uFNj1QV9UK7rWuc0l/24DKTzdKoXNwrznNCoLtiqySWt+f0hbdgN61qC0l14HBgyT4Z9tLHuhsx/o1U0pLNz0fJQxkP05404Sj2La1dpFTP9eQdksBe3rqQN4AlDno+I0QTE9mJAXWj10VumNYjzQgan7+qIAHjnW1kTbzYh61tPORJtzpH+tA2gZdnt4qyjglWUwv4QHNSDIIA4RFvDiIQFtcfBauD5By4jLEamtd707I8yVcgFRy0iz6f5G9sDNEwkniGBcbNBejJTtOdXB/QICs75BSmxuo9l82Jvyl8akst0rDTyrXoU8Hr9ecJxIrbPi+hzkSdA9fcB4Y3leP9T5HJljI6bU0cDC6TuoA1ibSpGj9b0kpfGLOWqpCco5p3NqCRBchF0VN1vVKwXwFVAIib22cQcgL7AAwouAwPoAqny7FWu+/iyz6CBVzfSwPAS+TLy24aK8waKCz9wARJHMAwEuYbn9HFkx4m6WF2Cshnf3LokZRlyOQ5N2+lTn+Gp4S7iRgYq4zj
 Yvfx45AL
 gYjKdIT20Q3THHWukrDfCC94dFTgXaLpq6A5S8HXwZEO/jDBvehR4Fu+7Zu0VyndnShgBo8GPQz48n9Brgf+aakJIPW/jkEg9S/QnpskRQYHF4X2RW7WtgyOZS3S0vubuTR0CgZXAbPhta2Ul7Juj1VLxkzAMv2b5eHW1m4Ec35rrYciP/dpMIpno5Vw1MTNuqpg2RCqbo4wspvM4jue0P+8dN6UG0KNCQ/AzuawlidWjLrErZmItDn9xByflhWIDpfREchZX/yBckT1q+NtnBGI6KiqnBe2a6rv46Bk38I58GHWpR+6F49EkikSchWiwLSmNBPfaOvniBzHPwwzfYAxdrjWaQZIZGw+b+kOZPy+myu1VO5K3/SdQ5CclICtM8cyTFzc2tfbCK0d4ku0eaR4ychlMtnvITS25cmq5AvrVTjMEDbQ75YYyyTZT+OQ70r6QToC0EzwdET3se5BELZVe9yaMzmdy+8wNiQt32zNYhdXi+f1GvKryvPyhOkNwFtwL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgWXVhbmNodSwNCg0KPiANCj4gT24gVGh1LCBOb3YgMjcsIDIwMjUgYXQgODo1NOKAr1BNIFpp
Y2hlbmcgV2FuZyA8d2FuZ3ppY2hlbmdAaG9ub3IuY29tPg0KPiB3cm90ZToNCj4gPg0KPiA+IFNp
Z25lZC1vZmYtYnk6IFppY2hlbmcgV2FuZyA8d2FuZ3ppY2hlbmdAaG9ub3IuY29tPg0KPiA+IC0t
LQ0KPiA+ICBtbS9LY29uZmlnIHwgMTAgKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdlZCwg
MTAgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL21tL0tjb25maWcgYi9tbS9L
Y29uZmlnDQo+ID4gaW5kZXggZTQ0M2ZlOGNkLi5iZTdlZmE3OTQgMTAwNjQ0DQo+ID4gLS0tIGEv
bW0vS2NvbmZpZw0KPiA+ICsrKyBiL21tL0tjb25maWcNCj4gPiBAQCAtMTMyNSw2ICsxMzI1LDE2
IEBAIGNvbmZpZyBMUlVfR0VOX1NUQVRTDQo+ID4gIGNvbmZpZyBMUlVfR0VOX1dBTEtTX01NVQ0K
PiA+ICAgICAgICAgZGVmX2Jvb2wgeQ0KPiA+ICAgICAgICAgZGVwZW5kcyBvbiBMUlVfR0VOICYm
IEFSQ0hfSEFTX0hXX1BURV9ZT1VORw0KPiA+ICsNCj4gPiArY29uZmlnIExSVV9HRU5fUFJPQ0ZT
X0NUUkwNCj4gPiArICAgICAgIGJvb2wgIk1vdmUgbHJ1X2dlbiBmaWxlcyBmcm9tIGRlYnVnZnMg
dG8gcHJvY2ZzIg0KPiA+ICsgICAgICAgZGVwZW5kcyBvbiBMUlVfR0VOICYmIFBST0NfRlMNCj4g
PiArICAgICAgIGhlbHANCj4gPiArICAgICAgICAgTW92ZSBscnVfZ2VuIG1hbmFnZW1lbnQgZnJv
bSBkZWJ1Z2ZzIHRvIHByb2NmcyAoL3Byb2MvbHJ1X2dlbikuDQo+ID4gKyAgICAgICAgIFRoaXMg
cHJvZHVjdGlvbi1yZWFkeSBmZWF0dXJlIHByb3ZpZGVzIGNyaXRpY2FsIG1lbW9yeSByZWNsYWlt
DQo+ID4gKyAgICAgICAgIHByZWRpY3Rpb24gYW5kIGNvbnRyb2wuIEl0IGlzIG5vIGxvbmdlciBl
eHBlcmltZW50YWwuDQo+ID4gKyAgICAgICAgIFRoZSBtaWdyYXRpb24gZW5zdXJlcyBhdmFpbGFi
aWxpdHkgaW4gY29tbWVyY2lhbCBwcm9kdWN0cyB3aGVyZQ0KPiA+ICsgICAgICAgICBkZWJ1Z2Zz
IG1heSBiZSBkaXNhYmxlZC4NCj4gSGkgWmljaGVuZywNCj4gDQo+IEEgY29uZmlnIG9wdGlvbiBk
ZXRlcm1pbmluZyB3aGVyZSBMUlVfZ2VuIGZpbGVzIHJlc2lkZSBjcmVhdGVzIGENCj4gZnJhZ2ls
ZSBwcm9jZnMgaW50ZXJmYWNlLiBDb25zaWRlciBhZGRpbmcgYSBzaW1pbGFyIGludGVyZmFjZSB3
aXRoDQo+IGxlc3MgaW1wbGVtZW50YXRpb24gZGV0YWlsIHRvIC9zeXMva2VybmVsL21tL2xydV9n
ZW4vIGlmIHRoZSBnb2FsIGlzDQo+IHRvIHN0YWJpbGl6ZSB0aGUgZGVidWdmcyBBUElzLg0KDQpU
aGFuayB5b3UgZm9yIHRoZSBjb21tZW50cy4NCllvdXIgc3VnZ2VzdGlvbiBvbiBzeXNmcyByZWFs
bHkgbWFrZSBzZW5jZS4gVGhlIG9ubHkgY2hhbGxlbmdlIGlzIHRoZSBzaG93DQpidWZmZXJzIG9m
IHN5c2ZzIGFyZSBsaW1pdGVkIHRvIFBBR0VfU0laRSBhY2NvcmRpbmcgdG8gdGhlIGtlcm5lbCBk
b2MuDQpJdCBjYW4gaGFyZGx5IHNob3cgYWxsIG1lbWNnIGluZm9zIGluIGEgc2luZ2xlIHJlYWQs
IGFzIGRlYnVnZnMgZmlsZQ0KY3VycmVudGx5IGRvZXMuDQoNCj4gDQo+IElmIHRoZSBnb2FsIGlz
IHRvIHByb2FjdGl2ZWx5IGFnZSBscnV2ZWNzIHRoYXQgaGF2ZSBiZWVuIGF0DQo+IE1JTl9OUl9H
RU5TIGZvciBzb21lIHRpbWUvZXZlbnRzL2V0YywgaXMgaXQgcG9zc2libGUgdG8gaW50ZWdyYXRl
IHRoaXMNCj4gaW50byB0aGUga2VybmVsIGFuZCBhdm9pZCBsZWFraW5nIE1HTFJVIGltcGxlbWVu
dGF0aW9uIGRldGFpbHMgaW50bw0KPiB1c2Vyc3BhY2U/DQoNCldlIHdpbGwgZXhwbG9yZSB0aGUg
cG9zc2libGUgb3B0aW9ucyBpbiB0aGUgbmV4dCB2ZXJzaW9uLiA6LSkNCg0KPiANCj4gVGhhbmtz
LA0KPiBZdWFuY2h1DQoNCkJlc3QsDQpaaWNoZW5nDQo=

