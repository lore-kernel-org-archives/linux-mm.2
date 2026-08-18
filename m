Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73FE9C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 13:30:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FBE6B018F; Tue, 18 Aug 2026 09:30:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6202E6B0190; Tue, 18 Aug 2026 09:30:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D016B0191; Tue, 18 Aug 2026 09:30:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301186B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:30:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAEDF12019C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:30:35 +0000 (UTC)
X-FDA: 85114474830.12.99322BE
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf21.hostedemail.com (Postfix) with ESMTP id 796331C000E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 13:30:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf21.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787059833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=veu5lxEZo70nkgyZ54ZlVCmRuccBltE/LFHX/VgPqtM=;
	b=3+7jXyqlGUIXGcWCXHzJCxLZEuS88PHudkRIB17sVFJsiHcfmuDeVeVnGGUrR8hR2GBwQ9
	MmfW391TxyDBcYMEi+bdx4HcLnBnv4l3gEsa0+sC+v5bYf/X61fgSBkA+HIVqTsQjNg7WR
	UdSmBx/W4EiEiOz4yhlIS/sLzVHiPnA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf21.hostedemail.com: domain of gaoxiang17@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=gaoxiang17@xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787059833;
	b=IyDZynFlmQqa9U4zDyjcMLKnbC1gpuOKd04Z1LIzPawg55nXLTyepjwIMLoBwnheEtyDdK
	mBWeau0MyQZX4hmxZNCRwLWcoNLroopJrscHDSR9jgPjBmamP0IpS3Agd3vISail+QJLrn
	DwqLOb+ELEvpmP8qPDE4ljaqjzyo6F0=
X-CSE-ConnectionGUID: l2fBTLqZS3uBftne3vGRGw==
X-CSE-MsgGUID: zMk+FQlnQQuhqWSsXNqvkg==
X-IronPort-AV: E=Sophos;i="6.25,230,1779120000"; 
   d="scan'208,217";a="186014059"
From: =?gb2312?B?uN/P6A==?= <gaoxiang17@xiaomi.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: Xiang Gao <gxxa03070307@gmail.com>, Masami Hiramatsu
	<mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lorenzo Stoakes <ljs@kernel.org>, gao xu <gaoxu2@honor.com>,
	=?gb2312?B?06G0sw==?= <yinchuang1@xiaomi.com>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?gb2312?B?tPC4tDogW0V4dGVybmFsIE1haWxdUmU6IFtSRkNdIHRyYWNpbmc6IGFnZ3Jl?=
 =?gb2312?Q?gate_ring-buffer_usage_statistics?=
Thread-Topic: [External Mail]Re: [RFC] tracing: aggregate ring-buffer usage
 statistics
Thread-Index: AQHdKZr3AIp7eq0PuUyEknsvZXxszLaaZZoy//+kuACAAeZA14ACmlvfgAVNR3U=
Date: Tue, 18 Aug 2026 13:30:26 +0000
Message-ID: <11242d2e40eb4fd4b439ac66ebbe26ed@xiaomi.com>
References: <20260811114818.1449933-1-gaoxiang17@xiaomi.com>
	<20260811100830.7976bbe8@gandalf.local.home>
	<cd441eb194d54265b1bf9ab659716c45@xiaomi.com>,<20260812114704.2f61bc5a@gandalf.local.home>,<d5bb28119dbb4ff1ab1059bb2564ad29@xiaomi.com>,<0e42953988164786aafe175ef0f4e745@xiaomi.com>
In-Reply-To: <0e42953988164786aafe175ef0f4e745@xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.8.165]
Content-Type: multipart/alternative;
	boundary="_000_11242d2e40eb4fd4b439ac66ebbe26edxiaomicom_"
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: msgs6etwehaprxu7yy5goxo9fcig8ei3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 796331C000E
X-HE-Tag: 1787059832-722598
X-HE-Meta: U2FsdGVkX1+8AzwZPI2UleJiTqZOkv8kLL6BJXCAlbu4NORI9dVldKmGXruLBrgS9mwJQlYCJ/qxt2/LdXa0LipHCDhT6q9zZyhjHc3+QaKflBJtVJ28zKXdzWclKAnLbamDPpONgpy2GTdJJ58aiDQyKKt78E1rkGMg3nvzG9GxD+R+KVAFprY4e+VDzlMBRlmdVhA6mKf3MTfQ968Grk+YhQBvvTHuh/z/ZB2S/EEFGxi4saJU2UBX4s58GYa2NFophU8RyL6NY7U52M1q5nu5qtbGTZa7Sl29PLgzJaV8R1Ngpp+mU+kfHdcSc6l1vaiOsdD0Zd7QI62byzkP0KK2+fFlPGwP2/G7zg8lTghPAH3OREANo0IbzRVUfn10nSlnp76WLcjOr4fbi/fjsQ00V5B4uliq3jy67yHwcb5xd4K4K6JwP1b70x2c1a7j+AQuDOXbBfafR+9sLSCfC7bgZyBIA9jIytRUtqxbx2GXeleGVzuHCzVK+vgfU4L3mKfIhpo3DjTynZBibcmTI2deJXgAUwQqgAd2tUa0sJeZT6f+E34xNvJwv5FiWTpts78ZxUE5TK4ukW/ZmRsF83nsidSMepIuPMuXZ5QFuNCZDf0Iq0zYvXB0p9KGALxSvI3uv9niLmj5v/penlqKYhUvTPehAd99WpPFZJez2qIZ+CuhFyf2atOm3OMmaoX1r9Awfg22MBebvPNLnsWhGctjMdJhUfetrP3+7u61CMnFZ9271GEvCSOFdiAuhl5AU+wL4nN/hgs1c1oWReWz4t4lvT2Klx4kOAnqCIFJKUja9Os7QCl3tbjLSwTsPm1Nd9ORryZ19y4Gq4oK0c5CjVLDaC7gcudko9he2Thda8g5IgXgnhAIQilglrw51Ey61AirKvan8HoGPr+pNn/28LljVAOnb3qHgZRQ7QnA9Rng1rSKUHV5l4vgf1kckZSq3lplgp5WzSKY6qpa+7g
 ZJowzTb5
 8d69ChGvAKUdJcPYMHILCMRfPEDjqEzbM3fswrU6T3h67CCmyQSlYWBjCKoPC8Yzk4QMNBiEqhEcu9vgzn1UGrvz5iyAp75vvOJ7EkJ4jUoBojNYfpxb2CxfVHBg36MyWruOmbsn1t4P+fWiWszdsJXkivOUtuO7Ki3KFZUKJxMgwf4galZzhK/xw1d+Lta6/kgts+/pdOGbmDhj9aZJ+FXmvWg/G2BUhRkLdsRNTtt3vVI3dzq/yijW8R+gwrsLJBbFrN3Mp34TtcqhPXyLUPL4OT1lDAPpyuk5I+YBKQkCiDQFvAxq7GgznBMuw2r4ZV1hH9sGIcRm/1U3gdISVSNHUBqWicLHJCuR7RylF2vdqP+rFr0mV6H0kd7XUmTOHBpHSOPNcRGlMleDDSVlR8mS82WtyhqmnzRPDiO8Kn8wOVzfwfkLlMqnss6aadfhjCtsAvWcycPW9boLiHjeE4NNbhQBhOkNL53HqzJzV4SjAPBZx7KOur5aJ17giSKoORmFkD7F7+f/LuDiiR2U+9zbiMr+DtUschVql
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_11242d2e40eb4fd4b439ac66ebbe26edxiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGkgU3RldmUsDQoNCg0KSnVzdCBhIGdlbnRsZSBwaW5nLiBJIGhhdmUgdGhlIFJGQyBwYXRjaCBy
ZWFkeSBmb3INCnRyYWNlX3N0YXRzL3RvdGFsX21lbW9yeV9rYiwgd2l0aCB0aGUgYnVmZmVyc19t
ZW0gYW5kDQpzbmFwc2hvdF9idWZmZXJzX21lbSBicmVha2Rvd24uDQoNCg0KV291bGQgeW91IHBy
ZWZlciBJIHBvc3QgdGhlIFJGQyBwYXRjaCBmb3IgcmV2aWV3LCBvciBpcyB0aGVyZSBhbnl0aGlu
Zw0KeW91IHdvdWxkIGxpa2UgdG8gY2xhcmlmeSBhYm91dCB0aGUgYWNjb3VudGluZyBzY29wZSBm
aXJzdD8NCg0KDQpUaGFua3MsDQpYaWFuZw0KDQoNCg0KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX18NCreivP7IyzoguN/P6A0Kt6LLzcqxvOQ6IDIwMjbE6jjUwjE1yNUgMTI6MzM6MTQN
CsrVvP7IyzogU3RldmVuIFJvc3RlZHQNCrOty806IFhpYW5nIEdhbzsgTWFzYW1pIEhpcmFtYXRz
dTsgTWF0aGlldSBEZXNub3llcnM7IExvcmVuem8gU3RvYWtlczsgZ2FvIHh1OyDTobSzOyBsaW51
eC10cmFjZS1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOyBsaW51eC1tbUBrdmFjay5vcmcNCtb3zOI6ILTwuLQ6IFtFeHRlcm5hbCBNYWlsXVJlOiBb
UkZDXSB0cmFjaW5nOiBhZ2dyZWdhdGUgcmluZy1idWZmZXIgdXNhZ2Ugc3RhdGlzdGljcw0KDQoN
CkhpLCBTdGV2ZS4NCg0KDQpPbmUgYWNjb3VudGluZyBkZXRhaWwgSSB3b3VsZCBsaWtlIHRvIGNs
YXJpZnkgYmVmb3JlIGltcGxlbWVudGluZyB0aGlzOg0Kc2hvdWxkIGJ1ZmZlcnNfbWVtIGFuZCBz
bmFwc2hvdF9idWZmZXJzX21lbSBpbmNsdWRlIGFsbCBtZW1vcnkgb3duZWQgYnkNCnRoZSBidWZm
ZXJzLCBpbmNsdWRpbmcgc2xhYi1hbGxvY2F0ZWQgcmluZy1idWZmZXIgbWV0YWRhdGEgYW5kIHJl
YWRlcg0KcGFnZXMsIG9yIG9ubHkgdGhlIGZ1bGwgcGFnZXMgYmFja2luZyB0aGUgcmluZy1idWZm
ZXIgZGF0YT8NCg0KDQpNeSBvcmlnaW5hbCBsb3N0LVJBTSB1c2UgY2FzZSBwcmltYXJpbHkgbmVl
ZHMgdGhlIG5vbi1zbGFiIHBhZ2UgbWVtb3J5LA0Kc2luY2Ugc2xhYiBpcyBhbHJlYWR5IGFjY291
bnRlZCBmb3Igc2VwYXJhdGVseS4gQnV0IEkgdW5kZXJzdGFuZA0KImJ1ZmZlcnNfbWVtIiBhbmQg
InRvdGFsIG1lbW9yeSIgbWF5IGJlIGludGVuZGVkIHRvIGluY2x1ZGUgYm90aCBwYWdlDQphbmQg
c2xhYiBhbGxvY2F0aW9ucy4NCg0KDQpUaGFua3MsDQpYaWFuZw0KDQoNCg0KX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX18NCreivP7IyzoguN/P6A0Kt6LLzcqxvOQ6IDIwMjbE6jjUwjEz
yNUgMjA6NDc6NDQNCsrVvP7IyzogU3RldmVuIFJvc3RlZHQNCrOty806IFhpYW5nIEdhbzsgTWFz
YW1pIEhpcmFtYXRzdTsgTWF0aGlldSBEZXNub3llcnM7IExvcmVuem8gU3RvYWtlczsgZ2FvIHh1
OyDTobSzOyBsaW51eC10cmFjZS1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmcNCtb3zOI6ILTwuLQ6IFtFeHRlcm5h
bCBNYWlsXVJlOiBbUkZDXSB0cmFjaW5nOiBhZ2dyZWdhdGUgcmluZy1idWZmZXIgdXNhZ2Ugc3Rh
dGlzdGljcw0KDQoNClRoYW5rcywgU3RldmUuDQoNClVuZGVyc3Rvb2QuDQoNCkkgd2lsbCBhZGQ6
DQoNCiAgL3N5cy9rZXJuZWwvdHJhY2luZy90cmFjZV9zdGF0cy90b3RhbF9tZW1vcnlfa2INCg0K
VGhlIGZpbGUgd2lsbCByZXBvcnQ6DQoNCiAgdG90YWw6DQogIGJ1ZmZlcnNfbWVtOg0KICBzbmFw
c2hvdF9idWZmZXJzX21lbToNCg0KVGhlIHZhbHVlcyB3aWxsIGNvdmVyIHRoZSBtYWluIGFuZCBz
bmFwc2hvdCBidWZmZXJzIG9mIHRoZSBnbG9iYWwgdHJhY2UNCmFycmF5IGFuZCBhbGwgdHJhY2lu
ZyBpbnN0YW5jZXMgYWNyb3NzIGFsbCB0cmFjaW5nIENQVXMuDQoNCkZvciB0aGUgcGVyLUNQVSB2
aWV3LCBJIHdpbGwgZm9sbG93IHRoZSBleGlzdGluZyB0cmFjZWZzIGxheW91dCBhbmQgYWRkOg0K
DQogIC9zeXMva2VybmVsL3RyYWNpbmcvdHJhY2Vfc3RhdHMvcGVyX2NwdS9jcHVOL3RvdGFsX21l
bW9yeV9rYg0KDQpFYWNoIHBlci1DUFUgZmlsZSB3aWxsIHJlcG9ydCBvbmx5IHRoZSBjb3JyZXNw
b25kaW5nIENQVSdzIGJ1ZmZlcnMNCmFjcm9zcyB0aGUgZ2xvYmFsIHRyYWNlIGFycmF5IGFuZCBh
bGwgdHJhY2luZyBpbnN0YW5jZXMuDQoNClRoYW5rcywNClhpYW5nDQoNCg0KDQpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fXw0Kt6K8/sjLOiBTdGV2ZW4gUm9zdGVkdCA8cm9zdGVkdEBn
b29kbWlzLm9yZz4NCreiy83KsbzkOiAyMDI2xOo41MIxMsjVIDIzOjQ3OjA0DQrK1bz+yMs6ILjf
z+gNCrOty806IFhpYW5nIEdhbzsgTWFzYW1pIEhpcmFtYXRzdTsgTWF0aGlldSBEZXNub3llcnM7
IExvcmVuem8gU3RvYWtlczsgZ2FvIHh1OyDTobSzOyBsaW51eC10cmFjZS1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5v
cmcNCtb3zOI6IFJlOiBbRXh0ZXJuYWwgTWFpbF1SZTogW1JGQ10gdHJhY2luZzogYWdncmVnYXRl
IHJpbmctYnVmZmVyIHVzYWdlIHN0YXRpc3RpY3MNCg0KW83isr/Tyrz+XSC0y9PKvP7AtNS009rQ
ocPXuavLvs3isr+jrMfrvffJ97SmwO2ho8j0ttTTyrz+sLLIq9DUtObSyaOsx+u9q9PKvP7Xqrei
uPhtaXNlY0B4aWFvbWkuY29tvfjQ0Le0wKENCg0KT24gV2VkLCAxMiBBdWcgMjAyNiAxMzoyMToy
OSArMDAwMA0KuN/P6CA8Z2FveGlhbmcxN0B4aWFvbWkuY29tPiB3cm90ZToNCg0KPiBUaGFua3Ms
IFN0ZXZlLg0KPg0KPiBGb3IgdGhlIGluaXRpYWwgaW1wbGVtZW50YXRpb24sIEkgcGxhbiB0byBh
ZGQ6DQo+DQo+ICAgL3N5cy9rZXJuZWwvdHJhY2luZy90cmFjZV9zdGF0cy90b3RhbF9tZW1vcnlf
a2INCj4NCj4gVGhlIGZpbGUgd291bGQgdXNlIGFuIGV4dGVuc2libGUga2V5L3ZhbHVlIGZvcm1h
dC4gSW5pdGlhbGx5IGl0IHdvdWxkDQo+IHJlcG9ydCB0aGUgcmluZy1idWZmZXIgZGF0YSBjYXBh
Y2l0eToNCj4NCj4gICB0b3RhbDogICAgICAgICAgICAgICAgICAgMzk1NjY0DQo+ICAgcmluZ19i
dWZmZXI6ICAgICAgICAgICAgIDM5NTY2NA0KPiAgIHJpbmdfYnVmZmVyX2xpdmU6ICAgICAgICAz
OTU1NDQNCj4gICByaW5nX2J1ZmZlcl9zbmFwc2hvdDogICAgICAgMTIwDQoNCllvdSBjYW4gcmVu
YW1lIHRoZSBhYm92ZSB0bzoNCg0KICAgdG90YWw6DQogICBidWZmZXJzX21lbToNCiAgIHNuYXBz
aG90X2J1ZmZlcnNfbWVtOg0KDQpObyBuZWVkIHRvIHVzZSAicmluZyIgYW5kIGl0IGtlZXBzIGNv
bnNpc3RlbnQgd2l0aCAiYnVmZmVyX3NpemVfa2IiLg0KDQpJIGFkZGVkIHRoZSAibWVtIiBwYXJ0
IHRvIGRpc3Rpbmd1aXNoIHRoZSBkaWZmZXJlbmNlIGJldHdlZW4gdGhlc2UgbnVtYmVycw0KYW5k
IHRoZSBidWZmZXJfc2l6ZV9rYiwgYXMgdGhlc2UgbnVtYmVycyBhcmUgYWJvdXQgdG90YWwgbWVt
b3J5IHdoZXJlYXMNCnRoZSAiYnVmZmVyX3NpemVfa2IiIGlzIGFib3V0IHVzYWJsZSBtZW1vcnku
DQoNClRoZXJlJ3MgYWxyZWFkeSBhIHRvdGFsIGZvciBhbGwgbWVtb3J5IGxpc3RlZC4gV2UgZG9u
J3QgbmVlZCB0byBoYXZlIGENCnRvdGFsIGZvciB0aGUgImxpdmUiIGFuZCAic25hcHNob3QiLg0K
DQo+DQo+IEhlcmUsIHJpbmdfYnVmZmVyIGlzIHRoZSBzdW0gb2YgcmluZ19idWZmZXJfbGl2ZSBh
bmQNCj4gcmluZ19idWZmZXJfc25hcHNob3QuIFRoZSB2YWx1ZXMgY292ZXIgdGhlIGdsb2JhbCB0
cmFjZSBhcnJheSBhbmQgYWxsDQo+IHRyYWNpbmcgaW5zdGFuY2VzIGFjcm9zcyBhbGwgdHJhY2lu
ZyBDUFVzLg0KPg0KPiBBZGRpdGlvbmFsIGFjY291bnRlZCBjYXRlZ29yaWVzLCBzdWNoIGFzIGV2
ZW50IG1lbW9yeSwgY291bGQgYmUgYXBwZW5kZWQNCj4gbGF0ZXIgYW5kIGluY2x1ZGVkIGluIHRv
dGFsLiBQZXItQ1BVIHN0YXRpc3RpY3MgY291bGQgYmUgZXhwb3NlZA0KPiBzZXBhcmF0ZWx5IHVu
ZGVyIHRyYWNlX3N0YXRzL3Blcl9jcHUvY3B1Ti8gdG8gYXZvaWQgbWl4aW5nIGFnZ3JlZ2F0ZSBh
bmQNCj4gcGVyLUNQVSB2YWx1ZXMgaW4gb25lIGZpbGUuDQoNCkFncmVlZCwgdGhpcyBmaWxlIHNo
b3VsZCBleGlzdCBpbiB0aGUgY3B1Ti8gZGlyZWN0b3JpZXMgYW5kIGJlIG9ubHkgZm9yDQp0aG9z
ZSBpbnN0YW5jZXMuDQoNCj4NCj4gVXNlcnNwYWNlIHdvdWxkIHBhcnNlIGZpZWxkcyBieSBuYW1l
IGFuZCBpZ25vcmUgdW5rbm93biBmaWVsZHMsIHNvIG5ldw0KPiBjYXRlZ29yaWVzIGNhbiBiZSBh
ZGRlZCB3aXRob3V0IGNoYW5naW5nIHRoZSBleGlzdGluZyBmb3JtYXQuDQoNClJpZ2h0LiBJIHdv
dWxkIGV4cGVjdCBhZGRpdGlvbmFsIGl0ZW1zIHRvIGJlIGFkZGVkIGhlcmUuDQoNCj4NCj4gRG9l
cyB0aGlzIGluaXRpYWwgZm9ybWF0IGxvb2sgcmVhc29uYWJsZT8NCj4NCg0KWWVzLCB0aGFua3Mg
Zm9yIGRvaW5nIHRoaXMuDQoNCi0tIFN0ZXZlDQo=

--_000_11242d2e40eb4fd4b439ac66ebbe26edxiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Exchange Server">
<!-- converted from text --><style><!-- .EmailQuote { margin-left: 1pt; pad=
ding-left: 4pt; border-left: #800000 2px solid; } --></style>
</head>
<body>
<style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;margi=
n-bottom:0;} --></style>
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p></p>
<div>Hi Steve,<br>
<br>
<br>
Just a gentle ping. I have the RFC patch ready for<br>
trace_stats/total_memory_kb, with the buffers_mem and<br>
snapshot_buffers_mem breakdown.<br>
<br>
<br>
Would you prefer I post the RFC patch for review, or is there anything<br>
you would like to clarify about the accounting scope first?<br>
<br>
<br>
Thanks,<br>
Xiang<br>
<br>
</div>
<br>
<p></p>
</div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>=B7=A2=BC=FE=C8=CB:</b> =B8=DF=
=CF=E8<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C215=C8=D5 12:33:14<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Steven Rostedt<br>
<b>=B3=AD=CB=CD:</b> Xiang Gao; Masami Hiramatsu; Mathieu Desnoyers; Lorenz=
o Stoakes; gao xu; =D3=A1=B4=B3; linux-trace-kernel@vger.kernel.org; linux-=
kernel@vger.kernel.org; linux-mm@kvack.org<br>
<b>=D6=F7=CC=E2:</b> =B4=F0=B8=B4: [External Mail]Re: [RFC] tracing: aggreg=
ate ring-buffer usage statistics</font>
<div>&nbsp;</div>
</div>
<div><style type=3D"text/css" style=3D"display:none;"><!-- P {margin-top:0;=
margin-bottom:0;} --></style>
<div id=3D"divtagdefaultwrapper" style=3D"font-size:12pt;color:#000000;font=
-family:Calibri,Helvetica,sans-serif;" dir=3D"ltr">
<p></p>
<div>Hi, Steve.<br>
<br>
<br>
One accounting detail I would like to clarify before implementing this:<br>
should buffers_mem and snapshot_buffers_mem include all memory owned by<br>
the buffers, including slab-allocated ring-buffer metadata and reader<br>
pages, or only the full pages backing the ring-buffer data?<br>
<br>
<br>
My original lost-RAM use case primarily needs the non-slab page memory,<br>
since slab is already accounted for separately. But I understand<br>
&quot;buffers_mem&quot; and &quot;total memory&quot; may be intended to inc=
lude both page<br>
and slab allocations.<br>
<br>
<br>
Thanks,<br>
Xiang<br>
<br>
</div>
<br>
<p></p>
</div>
<hr style=3D"display:inline-block;width:98%" tabindex=3D"-1">
<div id=3D"divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" st=
yle=3D"font-size:11pt" color=3D"#000000"><b>=B7=A2=BC=FE=C8=CB:</b> =B8=DF=
=CF=E8<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C213=C8=D5 20:47:44<br>
<b>=CA=D5=BC=FE=C8=CB:</b> Steven Rostedt<br>
<b>=B3=AD=CB=CD:</b> Xiang Gao; Masami Hiramatsu; Mathieu Desnoyers; Lorenz=
o Stoakes; gao xu; =D3=A1=B4=B3; linux-trace-kernel@vger.kernel.org; linux-=
kernel@vger.kernel.org; linux-mm@kvack.org<br>
<b>=D6=F7=CC=E2:</b> =B4=F0=B8=B4: [External Mail]Re: [RFC] tracing: aggreg=
ate ring-buffer usage statistics</font>
<div>&nbsp;</div>
</div>
<div>
<meta content=3D"text/html; charset=3DUTF-8">
<style type=3D"text/css" style=3D"">
<!--
p
	{margin-top:0;
	margin-bottom:0}
-->
</style>
<div dir=3D"ltr">
<div id=3D"x_divtagdefaultwrapper" dir=3D"ltr" style=3D"font-size:12pt; col=
or:#000000; font-family:Calibri,Helvetica,sans-serif">
<p></p>
<div>Thanks, Steve.</div>
<div><br>
</div>
<div>Understood.</div>
<div><br>
</div>
<div>I will add:</div>
<div><br>
</div>
<div>&nbsp; /sys/kernel/tracing/trace_stats/total_memory_kb</div>
<div><br>
</div>
<div>The file will report:</div>
<div><br>
</div>
<div>&nbsp; total:</div>
<div>&nbsp; buffers_mem:</div>
<div>&nbsp; snapshot_buffers_mem:</div>
<div><br>
</div>
<div>The values will cover the main and snapshot buffers of the global trac=
e</div>
<div>array and all tracing instances across all tracing CPUs.</div>
<div><br>
</div>
<div>For the per-CPU view, I will follow the existing tracefs layout and ad=
d:</div>
<div><br>
</div>
<div>&nbsp; /sys/kernel/tracing/trace_stats/per_cpu/cpuN/total_memory_kb</d=
iv>
<div><br>
</div>
<div>Each per-CPU file will report only the corresponding CPU's buffers</di=
v>
<div>across the global trace array and all tracing instances.</div>
<div><br>
</div>
<div>Thanks,</div>
<div>Xiang</div>
<div><br>
</div>
<br>
<p></p>
</div>
<hr tabindex=3D"-1" style=3D"display:inline-block; width:98%">
<div id=3D"x_divRplyFwdMsg" dir=3D"ltr"><font face=3D"Calibri, sans-serif" =
color=3D"#000000" style=3D"font-size:11pt"><b>=B7=A2=BC=FE=C8=CB:</b> Steve=
n Rostedt &lt;rostedt@goodmis.org&gt;<br>
<b>=B7=A2=CB=CD=CA=B1=BC=E4:</b> 2026=C4=EA8=D4=C212=C8=D5 23:47:04<br>
<b>=CA=D5=BC=FE=C8=CB:</b> =B8=DF=CF=E8<br>
<b>=B3=AD=CB=CD:</b> Xiang Gao; Masami Hiramatsu; Mathieu Desnoyers; Lorenz=
o Stoakes; gao xu; =D3=A1=B4=B3; linux-trace-kernel@vger.kernel.org; linux-=
kernel@vger.kernel.org; linux-mm@kvack.org<br>
<b>=D6=F7=CC=E2:</b> Re: [External Mail]Re: [RFC] tracing: aggregate ring-b=
uffer usage statistics</font>
<div>&nbsp;</div>
</div>
</div>
<font size=3D"2"><span style=3D"font-size:10pt;">
<div class=3D"PlainText">[=CD=E2=B2=BF=D3=CA=BC=FE] =B4=CB=D3=CA=BC=FE=C0=
=B4=D4=B4=D3=DA=D0=A1=C3=D7=B9=AB=CB=BE=CD=E2=B2=BF=A3=AC=C7=EB=BD=F7=C9=F7=
=B4=A6=C0=ED=A1=A3=C8=F4=B6=D4=D3=CA=BC=FE=B0=B2=C8=AB=D0=D4=B4=E6=D2=C9=A3=
=AC=C7=EB=BD=AB=D3=CA=BC=FE=D7=AA=B7=A2=B8=F8misec@xiaomi.com=BD=F8=D0=D0=
=B7=B4=C0=A1<br>
<br>
On Wed, 12 Aug 2026 13:21:29 &#43;0000<br>
=B8=DF=CF=E8 &lt;gaoxiang17@xiaomi.com&gt; wrote:<br>
<br>
&gt; Thanks, Steve.<br>
&gt;<br>
&gt; For the initial implementation, I plan to add:<br>
&gt;<br>
&gt;&nbsp;&nbsp; /sys/kernel/tracing/trace_stats/total_memory_kb<br>
&gt;<br>
&gt; The file would use an extensible key/value format. Initially it would<=
br>
&gt; report the ring-buffer data capacity:<br>
&gt;<br>
&gt;&nbsp;&nbsp; total:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 395664<br>
&gt;&nbsp;&nbsp; ring_buffer:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; 395664<br>
&gt;&nbsp;&nbsp; ring_buffer_live:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
; 395544<br>
&gt;&nbsp;&nbsp; ring_buffer_snapshot:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
120<br>
<br>
You can rename the above to:<br>
<br>
&nbsp;&nbsp; total:<br>
&nbsp;&nbsp; buffers_mem:<br>
&nbsp;&nbsp; snapshot_buffers_mem:<br>
<br>
No need to use &quot;ring&quot; and it keeps consistent with &quot;buffer_s=
ize_kb&quot;.<br>
<br>
I added the &quot;mem&quot; part to distinguish the difference between thes=
e numbers<br>
and the buffer_size_kb, as these numbers are about total memory whereas<br>
the &quot;buffer_size_kb&quot; is about usable memory.<br>
<br>
There's already a total for all memory listed. We don't need to have a<br>
total for the &quot;live&quot; and &quot;snapshot&quot;.<br>
<br>
&gt;<br>
&gt; Here, ring_buffer is the sum of ring_buffer_live and<br>
&gt; ring_buffer_snapshot. The values cover the global trace array and all<=
br>
&gt; tracing instances across all tracing CPUs.<br>
&gt;<br>
&gt; Additional accounted categories, such as event memory, could be append=
ed<br>
&gt; later and included in total. Per-CPU statistics could be exposed<br>
&gt; separately under trace_stats/per_cpu/cpuN/ to avoid mixing aggregate a=
nd<br>
&gt; per-CPU values in one file.<br>
<br>
Agreed, this file should exist in the cpuN/ directories and be only for<br>
those instances.<br>
<br>
&gt;<br>
&gt; Userspace would parse fields by name and ignore unknown fields, so new=
<br>
&gt; categories can be added without changing the existing format.<br>
<br>
Right. I would expect additional items to be added here.<br>
<br>
&gt;<br>
&gt; Does this initial format look reasonable?<br>
&gt;<br>
<br>
Yes, thanks for doing this.<br>
<br>
-- Steve<br>
</div>
</span></font></div>
</div>
</body>
</html>

--_000_11242d2e40eb4fd4b439ac66ebbe26edxiaomicom_--

