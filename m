Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51184C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2E16B00AA; Thu,  9 Jul 2026 20:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A3ED6B00AB; Thu,  9 Jul 2026 20:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA416B00AC; Thu,  9 Jul 2026 20:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3F8E6B00AA
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:44:51 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 70DD31C8808
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:44:51 +0000 (UTC)
X-FDA: 84971021982.11.D93096C
Received: from outbound.baidu.com (mx13.baidu.com [220.181.3.100])
	by imf20.hostedemail.com (Postfix) with SMTP id 589041C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:44:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=XBK13c3m;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=md164599CE4E=lirongqing@baidu.com" designates 220.181.3.100 as permitted sender) smtp.mailfrom="prvs=md164599CE4E=lirongqing@baidu.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783644289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzEKyACiG1UKTaCYkAzpxLPpJAo1Rv7G1I2xvVMzqps=;
	b=k0iUT2ccfJGhC2nfs4cHLWfc4NoF2yHKOujz0v+FBVFe1J8Le4f/fNlBHwqqQEsp/EhJu8
	doUQnCpCjY3hN8zm98L+zYnudHBPxGeUcV7NfJMJlHXJuTUTsNfPNfUfhAIafD11JBBPoS
	PaFtrWUttuPzDPhOlb/ZlyQYZ4DDohQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=XBK13c3m;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=md164599CE4E=lirongqing@baidu.com" designates 220.181.3.100 as permitted sender) smtp.mailfrom="prvs=md164599CE4E=lirongqing@baidu.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783644289;
	b=IMRq39zVgEUh/jDqLfMfdNsIJWLG6gtE3210t7FfVrq6AZYDf9vPDcabY0i5ZSfMrhNR5F
	f2l0dnC7T/QK8+08VEc0hhS1uSvBwKOvgJ+nztc0FI3j9i3SrNiPz4eAY3NK/+KQMKOb00
	BycsGa0afvB6ocsQsEWkjXU+bTicHY4=
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.45
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: =?gb2312?B?tPC4tDogWz8/Pz9dIFJlOiBbUEFUQ0hdIG5vZGVtYXNrOiB1c2UgbnJfbm9k?=
 =?gb2312?B?ZV9pZHMgaW5zdGVhZCBvZiBNQVhfTlVNTk9ERVMgaW4gX19ub2RlbWFza19w?=
 =?gb2312?Q?r=5Fnumnodes()?=
Thread-Topic: [????] Re: [PATCH] nodemask: use nr_node_ids instead of
 MAX_NUMNODES in __nodemask_pr_numnodes()
Thread-Index: AQHdD3MKs5fBK4e+NUaHhHHa3NakYrZlVkIAgACU7dA=
Date: Fri, 10 Jul 2026 00:44:29 +0000
Message-ID: <e86f64e7da3849e8b1be762f1ea14f3f@baidu.com>
References: <20260709071739.2408-1-lirongqing@baidu.com>
 <20260709164952.6630ce13f63a3104c2c53572@linux-foundation.org>
In-Reply-To: <20260709164952.6630ce13f63a3104c2c53572@linux-foundation.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.31.62.19]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1783644282;
	bh=fzEKyACiG1UKTaCYkAzpxLPpJAo1Rv7G1I2xvVMzqps=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=XBK13c3mhFMySAQZfYPCUn1CgR0Q1+ct1yL8RuT00XFW61xl4y09Avqt0eVomPMfk
	 54OBKRxch1I78f+SaxQw5Y6qHHNxPou5dpk+jPBRv95eeAln9f7VvUBV6yQ6uSG5LL
	 IXlr7VlBne7OMgYmEwT3KWAzcQ50DGmtrC5CTaZFFk5avyhSz1GTmBYPF/RNSzURK6
	 B2TkCMoF69fGf8DEgYvvK+kt7G5G5KbZDVoWyD6vS1HAMoLLhZL1xlG/khSpOR7pp5
	 KJnNyuYbyOhp8CpZn7YaldwXxxI5jjgAmh+1/wU0J7uHqz7g2xkyzOoso+7k4eVqff
	 jutZGvyDkMRmA==
X-Rspamd-Queue-Id: 589041C0003
X-Stat-Signature: r7s6zwdj8ebeiyp8ygp7faoha33ozx38
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783644285-289236
X-HE-Meta: U2FsdGVkX1//ZDCzAvZmZ2/A8HSmkrmt94rWGPRKjWjXr7C/JJl4UuNpRxEfFugSljPOe79fc/u5wfiKMjWGz4F8Lm+6cX5q5F8WVvoAK7g0idrsUavUdy72YL5a8hTUEwQS6jFKsdhYbgZPcRRi173aFPXdLMipHgQpZ8GKf47s/qjkxiQfTQo38Pi5bF6KwF0iAW4pTkzKKnyKsYYb5oFf6nPHTvAeAyz442gJN7DOeEXw4rZZVc4yKRajZ7rt/lrgl26Anu5sRc50qaXPUt4f5ed/byGV7gVWYng4cq2f2frzcFFXvT8XNB5z++xCiKedWJSexCA2G4N/4qYz8BG5ae+0JWGWCfjRpNx8jDbmdkCfMxCZLhvDhHCL3UUDWAGIAX1bnYI4YO3aTm8EGi4jThUEjBGZAxx+zWK+4f7JT5uubLkAjuTRS751tbImsVUIfETZKGWIMhPfQ69DF6Hdd4J067uyahU8fQmv1h9jdA2m/QXtWx/XJZ6yL94Ezenb9c1Zj2XSfU04PaXzMNS/GhvbjW/fA08LH8cZUbz20sd3uFykm+o8yfnGuVK/jzrm3fQ9mgpcC4NYuj4xej1c3LYAPVllo59Ho0gvSZe83lhncyoEf1iY6AXECFOV3eXi+ALQZmQF+YfmWXMwfWOxZYNqPBjKjP6zBlfln+TZTo4J7bfR7MV0igxEXMIzMkyU/bRBNYjOT+LuTZoQCDjBssE1PI/DlLbmi+1c8kXehVddZACFEtNpb1qyRcSiJPmB3I6678boD/jF3rlngYUh3BS5dyREzYX5chJIqJw6LCrw0gu/j4uHUcN5jywRHkfYhH/y0f3bWk8lPWkChsuVFS8r40H4sp6Zr1SCj8ohuoUFaANbFRE54QdHlLHcYwEEQV5rwOf8qD7tINKaclU1aAKcni5jA8tUx9DbRbMn9f/tnRWort09tPVfOqVrjO+er2YR0WQF4AX+oQe
 lKfNqTfg
 ja4fnMgDYyRDCDGjhfWci1rLKkHp6NFUqxloEUKXk7PTDnZMIIt5HzF/8Wgb9hZZZiaKuOUzDcMIPptK3253l06q0YsMd27UkaVWHWqY33DlyK1jxd0bzgxMVaTtLaNt+mm8lsfFZY0zQxcPX3wxWZwnHotXiBq4pAR+xJOX9RciHbS4vjxv+fpyUa2CzWGUd+VxEf4iG0zIKVI+aayfz/wUhOEE8DO1YJ1t2eQ2lcggiwlczAfQvQY/YSB7kos5jKB8+3V4WAUxZTCgTvHu4lqVKUKErEYaModorW1Jn1xUCq8qfp+mRGh91rBtk7MLprpoJutGEmxZD4HoeGMMY43wNbWMEzxeTcMABO7zUGq5rW1vbamYVnc7BNIbfr7tCaxox/1xSL8UztuLOQi39sIbO/ctcliw7dUI20GsDjGK1fPTqcyuHomyas7sCgYgr4eNNLtSE8H716+tMImdiyEMFahGGBX9a3nlK5rXnkfNMzMhaaeUeL5lSsQJdejoDVp4dJvxxXJCwRhb27K3LTcTYQM8Jf4HuFMZA5ckO4fMrazkxBTS4l+AswBtFpEv2aK/f+ylK4yInAcOjXTG+PP33G9LSgazXFeSmRQEEmMXFzI9G51NH/YiodpJ1NUizn+CBHDmqvjHWHxvsWfGhoInOCVyO2lhltn5+AdADx0EbWt2OUZQWohNhziFpfNIg0YYpAlJEoZGLVxEydH6wHqmBFWYT9C73wZO2WIdimbtOMuU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiBUaHUsIDkgSnVsIDIwMjYgMTU6MTc6MzkgKzA4MDAgbGlyb25ncWluZyA8bGlyb25ncWlu
Z0BiYWlkdS5jb20+DQo+IHdyb3RlOg0KPiANCj4gPiBGcm9tOiBMaSBSb25nUWluZyA8bGlyb25n
cWluZ0BiYWlkdS5jb20+DQo+ID4NCj4gPiBfX25vZGVtYXNrX3ByX251bW5vZGVzKCkgcmV0dXJu
cyBNQVhfTlVNTk9ERVMsIGEgY29tcGlsZS10aW1lDQo+ID4gY29uc3RhbnQsIGFzIHRoZSB3aWR0
aCBmb3IgJyUqcGJbbF0nIG5vZGVtYXNrIHByaW50aW5nLiBPbiBzeXN0ZW1zDQo+ID4gd2l0aCBm
ZXcgTlVNQSBub2RlcyB0aGlzIHByb2R1Y2VzIGV4Y2Vzc2l2ZSB6ZXJvLXBhZGRpbmcsIGUuZy4g
d2l0aA0KPiA+IE1BWF9OVU1OT0RFUz0xMDI0IGJ1dCBvbmx5IDIgbm9kZXM6DQo+ID4NCj4gPiAg
IE1lbXNfYWxsb3dlZDogMDAwMDAwMDAsMDAwMDAwMDAsLi4uLDAwMDAwMDAzICAoMzIgZ3JvdXBz
KQ0KPiANCj4gUGxlYXNlIGxldCdzIGNvbXBsZXRlbHkgZGVzY3JpYmUgdGhlIGVmZmVjdHMgb2Yg
dGhpcy4NCj4gbm9kZW1hc2tfcHJfYXJncygpIGlzIHVzZWQgaW4gc2V2ZXJhbCBwbGFjZXMgc28g
SSBiZWxpZXZlIHRoYXQgYSBudW1iZXIgb2YNCj4gdXNlcnNwYWNlLWZhY2luZyBzdHJpbmdzIHdp
bGwgbm93IGFwcGVhciBkaWZmZXJlbnRseT8gIExldCdzIHNwZWxsIG91dCB3aGljaA0KPiB1c2Vy
c3BhY2UgaW50ZXJmYWNlcyBhcmUgYWZmZWN0ZWQsIGFuZCBob3cuDQo+IA0KDQpUaGlzIGFmZmVj
dHMgZXZlcnkgbm9kZW1hc2tfcHJfYXJncygpIHVzZXIuICBVc2Vyc3BhY2UtdmlzaWJsZSBvdXRw
dXQNCmluY2x1ZGVzIG5vZGUgc3RhdGUgc3lzZnMgZmlsZXMgdW5kZXIgL3N5cy9kZXZpY2VzL3N5
c3RlbS9ub2RlLywgTlZNZQ0KbXVsdGlwYXRoIG51bWFfbm9kZXMsIG1lbW9yeSB0aWVyIG5vZGVs
aXN0LCBjcHVzZXQgbWVtcy9lZmZlY3RpdmVfbWVtcw0KZmlsZXMsIC9wcm9jLzxwaWQ+L3N0YXR1
cyBNZW1zX2FsbG93ZWQqLCBtZW1wb2xpY3kgc3RyaW5ncyBzdWNoIGFzIHRob3NlDQpzaG93biBp
biAvcHJvYy88cGlkPi9udW1hX21hcHMsIGFuZCBzbHViIGRlYnVnZnMgIm5vZGVzPSIgb3V0cHV0
LiAgS2VybmVsDQpsb2cgbWVzc2FnZXMgdGhhdCBwcmludCBub2RlbWFza3MsIHN1Y2ggYXMgY3B1
c2V0IHdhcm5pbmdzLCBhbGxvY2F0aW9uDQpmYWlsdXJlIHdhcm5pbmdzIGFuZCBPT00gZGlhZ25v
c3RpY3MsIGFyZSBhZmZlY3RlZCBhcyB3ZWxsLg0KDQpUaGUgc2VtYW50aWMgdmFsdWUgaXMgdW5j
aGFuZ2VkLiAgT25seSB0aGUgcHJpbnRlZCB3aWR0aCBjaGFuZ2VzIGZyb20NCk1BWF9OVU1OT0RF
UyBiaXRzIHRvIG5yX25vZGVfaWRzIGJpdHMsIHJlbW92aW5nIHRyYWlsaW5nIHplcm8gd29yZHMg
b24NCnN5c3RlbXMgYnVpbHQgd2l0aCBhIGxhcmdlIE1BWF9OVU1OT0RFUyBidXQgYm9vdGVkIHdp
dGggYSBzbWFsbGVyDQpwb3NzaWJsZS1ub2RlIHJhbmdlLiAgTGlzdCBvdXRwdXRzICglKnBibCkg
cmVtYWluIHVuY2hhbmdlZCBmb3IgY29tbW9uDQpjb250aWd1b3VzIG5vZGUgcmFuZ2VzIHN1Y2gg
YXMgIjAtMSI7IGJpdG1hcCBvdXRwdXRzICglKnBiKSwgc3VjaCBhcw0KL3Byb2MvPHBpZD4vc3Rh
dHVzIE1lbXNfYWxsb3dlZCwgYmVjb21lIHNob3J0ZXIuDQoNCg0KPiA+IFVzZSBucl9ub2RlX2lk
cyAodGhlIHJ1bnRpbWUgaGlnaGVzdC1ub2RlLWlkICsgMSkgaW5zdGVhZCwgbWF0Y2hpbmcNCj4g
PiB0aGUgYmVoYXZpb3Igb2YgY3B1bWFza19wcl9hcmdzKCkgd2hpY2ggdXNlcyBucl9jcHVfaWRz
Og0KPiA+DQo+ID4gICBNZW1zX2FsbG93ZWQ6IDAwMDAwMDAzDQo+ID4NCj4gPiBNb3ZlIHRoZSBu
cl9ub2RlX2lkcyBkZWNsYXJhdGlvbiBlYXJsaWVyIGluIHRoZSBmaWxlIChndWFyZGVkIGJ5DQo+
ID4gX19ub2RlbWFza19wcl9udW1ub2RlcygpLCBhbmQgcmVtb3ZlIHRoZSBub3ctZHVwbGljYXRl
IGRlY2xhcmF0aW9ucy4NCj4gPg0KPiA+IC4uLg0KPiA+DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51
eC9ub2RlbWFzay5oDQo+ID4gKysrIGIvaW5jbHVkZS9saW51eC9ub2RlbWFzay5oDQo+ID4gQEAg
LTk1LDYgKzk1LDEyIEBADQo+ID4NCj4gPiAgZXh0ZXJuIG5vZGVtYXNrX3QgX3VudXNlZF9ub2Rl
bWFza19hcmdfOw0KPiA+DQo+ID4gKyNpZiBNQVhfTlVNTk9ERVMgPiAxDQo+ID4gK2V4dGVybiB1
bnNpZ25lZCBpbnQgbnJfbm9kZV9pZHM7DQo+ID4gKyNlbHNlDQo+ID4gKyNkZWZpbmUgbnJfbm9k
ZV9pZHMJCTFVDQo+ID4gKyNlbmRpZg0KPiA+ICsNCj4gPiAgLyoqDQo+ID4gICAqIG5vZGVtYXNr
X3ByX2FyZ3MgLSBwcmludGYgYXJncyB0byBvdXRwdXQgYSBub2RlbWFzaw0KPiA+ICAgKiBAbWFz
a3A6IG5vZGVtYXNrIHRvIGJlIHByaW50ZWQNCj4gPiBAQCAtMTA1LDcgKzExMSw3IEBAIGV4dGVy
biBub2RlbWFza190IF91bnVzZWRfbm9kZW1hc2tfYXJnXzsNCj4gPiAgCQkJCV9fbm9kZW1hc2tf
cHJfYml0cyhtYXNrcCkNCj4gPiAgc3RhdGljIF9fYWx3YXlzX2lubGluZSB1bnNpZ25lZCBpbnQg
X19ub2RlbWFza19wcl9udW1ub2Rlcyhjb25zdA0KPiA+IG5vZGVtYXNrX3QgKm0pICB7DQo+ID4g
LQlyZXR1cm4gbSA/IE1BWF9OVU1OT0RFUyA6IDA7DQo+ID4gKwlyZXR1cm4gbSA/IG5yX25vZGVf
aWRzIDogMDsNCj4gPiAgfQ0KPiA+ICBzdGF0aWMgX19hbHdheXNfaW5saW5lIGNvbnN0IHVuc2ln
bmVkIGxvbmcgKl9fbm9kZW1hc2tfcHJfYml0cyhjb25zdA0KPiA+IG5vZGVtYXNrX3QgKm0pICB7
IEBAIC00MzgsNyArNDQ0LDYgQEAgc3RhdGljIF9fYWx3YXlzX2lubGluZQ0KPiB1bnNpZ25lZA0K
PiA+IGludCBuZXh0X21lbW9yeV9ub2RlKGludCBuaWQpDQo+ID4gIAlyZXR1cm4gbmV4dF9ub2Rl
KG5pZCwgbm9kZV9zdGF0ZXNbTl9NRU1PUlldKTsgIH0NCj4gPg0KPiA+IC1leHRlcm4gdW5zaWdu
ZWQgaW50IG5yX25vZGVfaWRzOw0KPiA+ICBleHRlcm4gdW5zaWduZWQgaW50IG5yX29ubGluZV9u
b2RlczsNCj4gDQo+IExldCdzIHJlbG9jYXRlIG5yX29ubGluZV9ub2RlcyBhbHNvPyAgVG8ga2Vl
cCB0aGVtIHRvZ2V0aGVyLg0KDQoNCkkgd2lsbCByZWxvY2F0ZSBpdCBpbiBWMg0KDQpUaGFua3MN
Cg0KW0xpLFJvbmdxaW5nXSANCg0KDQoNCj4gDQo+ID4gIHN0YXRpYyBfX2Fsd2F5c19pbmxpbmUg
dm9pZCBub2RlX3NldF9vbmxpbmUoaW50IG5pZCkgQEAgLTQ4MCw3ICs0ODUsNg0KPiA+IEBAIHN0
YXRpYyBfX2Fsd2F5c19pbmxpbmUgaW50IG51bV9ub2RlX3N0YXRlKGVudW0gbm9kZV9zdGF0ZXMg
c3RhdGUpDQo+ID4gICNkZWZpbmUgZmlyc3RfbWVtb3J5X25vZGUJMA0KPiA+ICAjZGVmaW5lIG5l
eHRfb25saW5lX25vZGUobmlkKQkoTUFYX05VTU5PREVTKQ0KPiA+ICAjZGVmaW5lIG5leHRfbWVt
b3J5X25vZGUobmlkKQkoTUFYX05VTU5PREVTKQ0KPiA+IC0jZGVmaW5lIG5yX25vZGVfaWRzCQkx
VQ0KPiA+ICAjZGVmaW5lIG5yX29ubGluZV9ub2RlcwkJMVUNCj4gPg0KPiA+ICAjZGVmaW5lIG5v
ZGVfc2V0X29ubGluZShub2RlKQkgICBub2RlX3NldF9zdGF0ZSgobm9kZSksIE5fT05MSU5FKQ0K
PiA+IC0tDQo+ID4gMi45LjQNCg0K

