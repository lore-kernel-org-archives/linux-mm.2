Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED95CA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4C6B6B0006; Tue,  2 Sep 2025 09:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A244E6B0007; Tue,  2 Sep 2025 09:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939BB6B0008; Tue,  2 Sep 2025 09:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80FF76B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:05:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 158C4138D15
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:05:02 +0000 (UTC)
X-FDA: 83844330444.04.CDFEA8D
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf18.hostedemail.com (Postfix) with ESMTP id A998E1C0018
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:04:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yuhao.zhang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yuhao.zhang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756818299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9S5ggAris22eza8Vgn21ReT2ZYzJGB8tbqQzEXCN4Pw=;
	b=V2txHPbMEJWp4nOpFmaaKpbdGYncujRo4e34r1sLxInnNCmUWQ/eOwPqeTVY5/wqnLnoyB
	IrSy0qBvVrAeuYiNA9Sf9PyRUMuYbcRfxvE/Wh1P5MZx3V9nHXgTFuAeTnEJ/JKo7ECbEa
	GADtfYeNcrTVTregwa3+1coS+Mq+dqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756818299; a=rsa-sha256;
	cv=none;
	b=pvKXpMyiyVEtX8M5T6RzLfzqA3zirNavHtW77T5owaDI312SIKBm88xOc+RhtNxFXB5q3h
	w4hzN7XzIsGqBu3JVjVTwnbZdCDpkSuEtu5BRP39KtqX3Ng1wz7UWydVbAlX3o/2iZoiyK
	Jbcx0ogzwuOmZz/dtolV3YKXIDy+Izk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yuhao.zhang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yuhao.zhang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cGQpj3BfPz13NTJ;
	Tue,  2 Sep 2025 21:01:01 +0800 (CST)
Received: from kwepemj200002.china.huawei.com (unknown [7.202.194.14])
	by mail.maildlp.com (Postfix) with ESMTPS id 9E7C1140202;
	Tue,  2 Sep 2025 21:04:51 +0800 (CST)
Received: from kwepemj100003.china.huawei.com (7.202.195.248) by
 kwepemj200002.china.huawei.com (7.202.194.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 21:04:51 +0800
Received: from kwepemj100003.china.huawei.com ([7.202.195.248]) by
 kwepemj100003.china.huawei.com ([7.202.195.248]) with mapi id 15.02.1544.011;
 Tue, 2 Sep 2025 21:04:51 +0800
From: Zhangyuhao <yuhao.zhang@huawei.com>
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard
	<jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Joerg Roedel
	<joro@8bytes.org>, Will Deacon <will@kernel.org>, Robin Murphy
	<robin.murphy@arm.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
Subject: RE: Issues with Pinning User Pages for SVA on IOMMUs Lacking IOPF
Thread-Topic: Issues with Pinning User Pages for SVA on IOMMUs Lacking IOPF
Thread-Index: AdwbQ8jtyLdUfE4eSeWgQaAe9dULRf//jTWA//4BcbA=
Date: Tue, 2 Sep 2025 13:04:51 +0000
Message-ID: <54be598d93404e7185ecfbe49f7fe93c@huawei.com>
References: <08c869037c6d4bd2bd9bc5e2bcfb7e7c@huawei.com>
 <fc37388a-dc09-4a71-bd79-c0d09e482c21@redhat.com>
In-Reply-To: <fc37388a-dc09-4a71-bd79-c0d09e482c21@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.108.235.196]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A998E1C0018
X-Stat-Signature: 1m3en4ksd36q6595fw8b3q3o71eap9q6
X-HE-Tag: 1756818297-753913
X-HE-Meta: U2FsdGVkX1+G39iA126T3wUaA36oHHxamWc1vBcWKSz27Ng4syNvmHw0n/l+IX1ey66PQrUsVUiSgmvl3L3RcMj7mTLRo02jImZU5iIibK5TGAXW2QPaPnk7DdEjcaDzOPfE1iYg/lhl6o2lOTWZcyKpORcSo6DoUeckW1+nHHiDwMdDgJchUnEkFcIV3R81jYnjS9vp7FLvXp+AsEsOrS49ZWtbBX+HEFkNxzphMxBJPbw1Vn9ERbPt0n6dYVFFB8XucMNLVSyjprZB5qJFPjhQ550s4rltjjTmxzq1W4FIS6knvxyT4CullazhTuSHm45HpX6TrHYY26WFSIzfESLS2X9CP61jnutfMg05DIL9MZ0nXxkgWuDhatd4eQY0CySGIhQdKUym3Fke+CqSrtu145SBwWTe0m7EumSQWMQGmP/hS1HuZ2jQeF3H0IfdHIzNmHy6U44SjRudyil0mdgzfbFb6qLddP43pFpAA8j8E5M9zPeSaOepgsgogi/IxPRkUrQdRV111o/CQPUDW89ZCryrL44gzAxB4SsiGa2uBacQ58rqYSxUaXWDQzaZBfNThRUas8b0l2gulbobw2OyhWbsIKJkIS9GI6DHfaUmtssh68Knkg1A/Yu+BNIVGfiTnDHavD9z5sbdKUe24+u2RkbQmq2PjRke4plIHvLQ3YZndj8D4j+yVQfAuQTfySmTTSu5mFAJNiVkX0JDHIVY6dsDBw4TLuLAO7zevjlvlwhmprfFPnz68wy5JZncJM4sdD1hajuCJJEUmy8Xn8AEk10Aqh+ObyqdQTHGv33g3R6FUzG/IpbxeLdMjRQMRtnsuaAMUNAp/C7NQ0ldfZmzKrB/wktQRK6YdFvv89PA5nAmux4DnI+jl3Z3iHjiWgL8JtAcEzjk1vKpwRaLv6Zd+QCV2P8GiSxK4fY1DxqbeZUUJ+voyS2x2VtJVIzBWqEGw59pWxKUi5+vmIQ
 Famr06uq
 WJHmdbOpjvfiQpZmB5KCTtcyVW+tVUaHsX61VQyRzEgGuejgdD7bIEUzoUzmEj6kDrHx/29EQBXGO4L08nDZ6FhhlV2y5fYZ4iFOuauCdq7eJ52CO22Bsqc6v2bS32Z2E8dz+1NAqbYi3MyXY4XUzygbSySseCy6Auj90CzZ5Yka3jLhU+t0OOZ7FzevjBgY6xO+NjYZ7ne5K2vrp7RCIVgrHdAhlV5QcT610hBkR9s0Zxvm5JFidUProSB309+etPZ/flOpJ6SInG2mjJdomb9AI9wYsmp3Z41ES8F2XWpJtNAHH6c3+hEsx5+0SLfYbmlmI5/I/uGAw1eR0WpCAVBZA6A7U5CpiMWGqSb5sG6CQWkPs7AOI0Yleh1+eA8FwOztaHTKFyo3Kw01ZmT7HN+4aa6hPF6zIxCBPe+JPNr7LjL1PGvMx2bGA2o+rpAI2Obe2wrSA+zEfGLpKBBKtEka8uDS+PPNe2tO1JWBYiOY4RXhNThjFug5dci5a+R4sacQxUDEnyH3zTy3Ybc5oZ1EJ1W+KytTKb9MHT7A+8Md8xt69p2oVL1ZuyK5tj0rhsKgXZxWJNpKjkx6MF9peuq6xnlzw/bK4qf3qWsGxgTWUPasy+4b+TwfEPM057LVUcLRh+FKFrTtOabq5oN5FjfySoV0/Nf33/d+7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

W0FkZGluZyBsaW51eC1rZXJuZWwgbWFpbGluZyBsaXN0IGZvciB2aXNpYmlsaXR5XQ0KDQpCZXN0
LA0KWXVoYW8NCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9tOiBEYXZpZCBIaWxkZW5i
cmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT4gDQpTZW50OiBNb25kYXksIFNlcHRlbWJlciAxLCAyMDI1
IDEwOjM0IFBNDQpUbzogWmhhbmd5dWhhbyA8eXVoYW8uemhhbmdAaHVhd2VpLmNvbT47IEFuZHJl
dyBNb3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+OyBKYXNvbiBHdW50aG9ycGUgPGpn
Z0B6aWVwZS5jYT47IEpvaG4gSHViYmFyZCA8amh1YmJhcmRAbnZpZGlhLmNvbT47IFBldGVyIFh1
IDxwZXRlcnhAcmVkaGF0LmNvbT47IEpvZXJnIFJvZWRlbCA8am9yb0A4Ynl0ZXMub3JnPjsgV2ls
bCBEZWFjb24gPHdpbGxAa2VybmVsLm9yZz47IFJvYmluIE11cnBoeSA8cm9iaW4ubXVycGh5QGFy
bS5jb20+DQpTdWJqZWN0OiBSZTogSXNzdWVzIHdpdGggUGlubmluZyBVc2VyIFBhZ2VzIGZvciBT
VkEgb24gSU9NTVVzIExhY2tpbmcgSU9QRg0KDQpPbiAwMS4wOS4yNSAxNTo0MywgWmhhbmd5dWhh
byB3cm90ZToNCj4gSGVsbG8gTGludXgga2VybmVsIGNvbW11bml0eSwNCg0KSGksDQoNCj4gDQo+
IEN1cnJlbnQgSU9NTVUgU1ZBIHN1cHBvcnQgcmVsaWVzIG9uIGhhcmR3YXJlIElPUEYgKElPIFBh
Z2UgRmF1bHQpLiBXZSBoYXZlIG9ic2VydmVkIHRoYXQgY2VydGFpbiBJT01NVSBkZXZpY2VzIGRv
IG5vdCBzdXBwb3J0IElPUEYuDQo+IEJ1dCBXZSBhcmUgc3RpbGwgZXhwbG9yaW5nIGhvdyB0byBl
bmFibGUgU1ZBIGluIHN1Y2ggc2NlbmFyaW9zLg0KPiANCj4gVG8gYWRkcmVzcyB0aGlzLCB3ZSBh
dHRlbXB0ZWQgdG8gcGluIG1lbW9yeSB0byBwcmV2ZW50IGRldmljZSBhY2Nlc3NlcyBmcm9tIHRy
aWdnZXJpbmcgSU8gcGFnZSBmYXVsdHMuDQo+IA0KPiBTb2x1dGlvbiAxOiBVc2VyLXNwYWNlIG1s
b2NrICsgbWFkdmlzZShNQURWX1BPUFVMQVRFX1dSSVRFKQ0KPiANCj4gaWYgKG1hZHZpc2UoYnVm
LCBzaXplLCBNQURWX1BPUFVMQVRFX1dSSVRFKSAhPSAwKSB7DQo+ICAgICAgZnJlZShidWYpOw0K
PiAgICAgIHJldHVybiAxOw0KPiB9DQo+IGlmIChtbG9jayhidWYsIHNpemUpICE9IDApIHsNCj4g
ICAgICBmcmVlKGJ1Zik7DQo+ICAgICAgcmV0dXJuIDE7DQo+IH0NCj4gUmVzdWx0OiBQYWdlIGZh
dWx0cyBzdGlsbCBvY2N1cnJlZCBkdWUgdG8gcGFnZSBtaWdyYXRpb24uDQoNClllcywgTlVNQS1o
aW50aW5nIG1pZ2h0IHNpbWlsYXJseSBhZmZlY3QgdGhpcyAoZXZlbiB3aGVuIHBhZ2Ugbm90IG1p
Z3JhdGVkKS4NCg0KPiANCj4gU29sdXRpb24gMjogS2VybmVsLXNwYWNlIHBpbiB2aWEgSU9DVEwN
Cj4gDQo+IHJldCA9IHBpbl91c2VyX3BhZ2VzX2Zhc3QoY3VyX2Jhc2UsIG5wYWdlcywgRk9MTF9M
T05HVEVSTSwgcGFnZV9saXN0KTsNCj4gDQo+IFJlc3VsdDogUGFnZSBmYXVsdHMgb2NjdXJyZWQg
b2NjYXNpb25hbGx5LCB0cmFjZWQgdG8gTlVNQSBiYWxhbmNpbmcgbWFya2luZyBwYWdlcyBhcyBp
bnZhbGlkLg0KDQpBaCwgdGhlcmUgeW91IHRhbGsgYWJvdXQgTlVNQSBiYWxhbmNpbmcuDQoNCj4g
DQo+IFRvIHNvbHZlIHRoZSBwcm9ibGVtLCB3ZSB1c2VkIEZPTExfTE9OR1RFUk0gfCBGT0xMX0hP
Tk9SX05VTUFfRkFVTFQgdG8gcGluIHVzZXIgcGFnZXMuDQo+IA0KDQpTZWUgcHJvdF9udW1hX3Nr
aXAoKTogd2Ugc2tpcCBETUEtcGlubmVkIGZvbGlvcyBpbiBDT1cgbWFwcGluZ3Mgb25seS4gU28g
SWYgeW91IHdvdWxkIGhhdmUgYSAhQ09XIG1hcHBpbmcgKGUuZy4sIE1BUF9TSEFSRUQgc2htZW0p
LCB0aGF0IHdvdWxkbid0IHdvcmsgcmVsaWFibHkgSSB0aGluay4NCg0KSSB0aGluayB3ZSBjb3Vs
ZCBjaGFuZ2UgdGhhdCB3aXRob3V0IGNhdXNpbmcgdG9vIG11Y2ggaGFybS4NCg0KZGlmZiAtLWdp
dCBhL21tL21wcm90ZWN0LmMgYi9tbS9tcHJvdGVjdC5jIGluZGV4IDExM2I0ODk4NTgzNDEuLjE3
ODA5Yzg2MDRmMjUgMTAwNjQ0DQotLS0gYS9tbS9tcHJvdGVjdC5jDQorKysgYi9tbS9tcHJvdGVj
dC5jDQpAQCAtMTM3LDggKzEzNywxMSBAQCBzdGF0aWMgYm9vbCBwcm90X251bWFfc2tpcChzdHJ1
Y3Qgdm1fYXJlYV9zdHJ1Y3QgKnZtYSwgdW5zaWduZWQgbG9uZyBhZGRyLA0KICAgICAgICAgICAg
ICAgICBnb3RvIHNraXA7DQogIA0KICAgICAgICAgLyogQWxzbyBza2lwIHNoYXJlZCBjb3B5LW9u
LXdyaXRlIHBhZ2VzICovDQotICAgICAgIGlmIChpc19jb3dfbWFwcGluZyh2bWEtPnZtX2ZsYWdz
KSAmJg0KLSAgICAgICAgICAgKGZvbGlvX21heWJlX2RtYV9waW5uZWQoZm9saW8pIHx8IGZvbGlv
X21heWJlX21hcHBlZF9zaGFyZWQoZm9saW8pKSkNCisgICAgICAgaWYgKGlzX2Nvd19tYXBwaW5n
KHZtYS0+dm1fZmxhZ3MpICYmIGZvbGlvX21heWJlX21hcHBlZF9zaGFyZWQoZm9saW8pKQ0KKyAg
ICAgICAgICAgICAgIGdvdG8gc2tpcDsNCisNCisgICAgICAgLyogRm9saW9zIHRoYXQgYXJlIHBp
bm5lZCBhbmQgY2Fubm90IGJlIG1pZ3JhdGVkIGVpdGhlciB3YXkuICovDQorICAgICAgIGlmIChm
b2xpb19tYXliZV9kbWFfcGlubmVkKGZvbGlvKSkNCiAgICAgICAgICAgICAgICAgZ290byBza2lw
Ow0KICANCiAgICAgICAgIC8qDQoNCg0KPiBUaGlzIGFwcHJvYWNoIGhhcyBiZWVuIHRlc3RlZCBh
bmQgc3VjY2Vzc2Z1bGx5IHByZXZlbnRzIElPIHBhZ2UgZmF1bHRzIHNvIGZhci4NCj4gDQo+IFdl
IHdvdWxkIGxpa2UgZ3VpZGFuY2UgZnJvbSB0aGUgY29tbXVuaXR5Og0KPiANCj4gQ2FuIHRoaXMg
YXBwcm9hY2ggcmVsaWFibHkgcHJldmVudCBhbGwgSU8gcGFnZSBmYXVsdHM/DQoNClNlZSB0aGUg
Y2FzZSBhYm92ZSByZWdhcmRpbmcgbm9uLWNvdyBtYXBwaW5ncy4NCg0KV2UgZXNzZW50aWFsbHkg
bmVlZCB0byBtYWtlIHN1cmUgdGhhdCB3ZSBkb24ndCAodGVtcG9yYXJpbHkpIHVubWFwIGZvciBt
aWdyYXRpb24vcmVjbGFpbS9zcGxpdC93aGF0ZXZlciBpZiBhIGZvbGlvIG1heWJlIHBpbm5lZC4N
Cg0KV2UgYmFjayBvdXQgaW4gYWxsIGNhc2VzICh1bmV4cGVjdGVkIHJlZmVyZW5jZSksIGJ1dCB3
ZSdsbCBoYXZlIHRvIHNhbml0eS1jaGVjayB3aGV0aGVyIHdlIHJlamVjdCBtYXliZV9waW5uZWQg
Zm9saW9zIGVhcmx5IHRvIG5vdCB0ZW1wb3JhcmlseSB1bm1hcC4NCg0KPiANCj4gSXMgdGhlcmUg
YSBiZXR0ZXIgb3IgcmVjb21tZW5kZWQgbWV0aG9kIHRvIHBpbiB1c2VyIHBhZ2VzIGZvciBTVkE/
DQoNCk1vc3QgdXNlIGNhc2VzIHVzZSBsb25ndGVybSBwaW5uaW5ncyB0byB0aGVuIGNvbmZpZ3Vy
ZSB0aGUgaW9tbXUgbWFudWFsbHkuIFRoZW4sIGl0IGRvZXMgbm90IHJlYWxseSBtYXR0ZXIgd2hh
dCBoYXBwZW5zIHRvIHlvdXIgcHJvY2VzcyBwYWdlIHRhYmxlcy4NCg0KU28geW91ciB1c2UgY2Fz
ZSBpcyByYXRoZXIgbmV3IDopDQoNCkJ1dCB5ZXMsIGEgbG9uZ2VybSBwaW5uaW5nIHdoaWxlIHJl
c29sdmluZyBOVU1BLWhpdG5pbmcgZmF1bHRzIHNob3VsZCBpbiB0aGVvcnkgd29yay4NCg0KV2Ug
anVzdCBoYXZlIHRvIG1ha2Ugc3VyZSB0aGF0IGV2ZXJ5Ym9keSBlbHNlIHBsYXlzIG5pY2UgZWFy
bHkgd2l0aCBkbWEtcGlubmVkIGZvbGlvcy4NCg0KLS0NCkNoZWVycw0KDQpEYXZpZCAvIGRoaWxk
ZW5iDQoNCg0K

