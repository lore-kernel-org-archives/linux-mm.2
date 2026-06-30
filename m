Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67285C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:56:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC696B00A7; Tue, 30 Jun 2026 08:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42F826B00A8; Tue, 30 Jun 2026 08:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D15E6B00A9; Tue, 30 Jun 2026 08:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE56F6B00A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:55:59 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E5671680E0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:55:59 +0000 (UTC)
X-FDA: 84936576438.27.41D4D51
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C3954000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:55:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of machao26@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=machao26@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782824156;
	b=U9OendRB3vk1orqG44+UaMPW5LedioEUJeb60em90nHT2MOzlAOPNXL3Z0JSbiYoEQLIo0
	tAaB0bD12wdXMznRpMW258ZCYIJY/n1ZyBWTYfFD/Mst8MPNvLoSbtT5sp0Nr7jqOEod0f
	Rb6xhIych8DWR7Kk6pKVX9AYxLmo52E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782824156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q4UPolrNuzIbJhk2ARCeFZofw4fdXXrgeJwBucTW398=;
	b=QQkZ90b/jKQArFWGPP72hD/p1waUTA7VgqAj+lweBHg/Q+srJTFdSiNuQk+uCjS0gaGnqW
	M3VB+iFtkc20WvaK0ju/DK8P8Ya+uFvFAWyHCYb+6iBjMB7iA3pArcWMVpTVpPeXBpM3zb
	tsaIMq6N8vdsdFqdd/PxVTINA8WTrjY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of machao26@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=machao26@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
X-CSE-ConnectionGUID: Gq+o20D1T1CfVM/MtuTTIw==
X-CSE-MsgGUID: ecEzfmEaTHCNbB1PsQ+Y3Q==
X-IronPort-AV: E=Sophos;i="6.24,233,1774281600"; 
   d="scan'208,217";a="180717247"
From: =?gb2312?B?wu2zrA==?= <machao26@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?gb2312?B?zO/QorHz?=
	<tianxiaobin@xiaomi.com>, =?gb2312?B?0+G2q7Hz?= <yudongbin@xiaomi.com>,
	=?gb2312?B?wO7F9LPM?= <xiaoyaoli@xiaomi.com>
Subject: [BUG] shmem: shmem_get_folio_gfp livelock
Thread-Topic: [BUG] shmem: shmem_get_folio_gfp livelock
Thread-Index: Ad0IicmxtmIrTZWQT5i671sASycsWgAACTVQAACz3LA=
Date: Tue, 30 Jun 2026 12:55:50 +0000
Message-ID: <49858bc642844e3bbf6449c0f241af04@xiaomi.com>
References: <e1c290782eeb419e8c3e18ac6b1f49eb@xiaomi.com>
 <126cb4ced14f4a3fa40c3189bf8a5920@xiaomi.com>
In-Reply-To: <126cb4ced14f4a3fa40c3189bf8a5920@xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_49858bc642844e3bbf6449c0f241af04xiaomicom_"
MIME-Version: 1.0
X-Rspamd-Queue-Id: 4C3954000A
X-Stat-Signature: f65gz3ygqpgac8xk18j7ip9z4rnqhajc
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782824154-416128
X-HE-Meta: U2FsdGVkX1+wZzWfLPTN0uOf9EdFmDCy4Mgz4WOJhY3bm0pCYRctHnE5cwJ/GoaXx7ZWPO/pB6yp6VVZ+r4s+qfhOg2WYu/zZkLhSD6EUaJUjOPagkgtILH0Zi+qbnzcy8JbgL0kzsZYZat3zpqCwQ18dMisHrSkekXq13Y8UyMIzWSS013LICxoWoXJVPar4WCoToac9FyuLqqDCdqAm4uNroF582WOrNr9/W1f0LwjTQOoQTs/tLOTiIpysT72TEKAhQeUWTMfBmxFZIloGAgIkE23pZgFa/GfCiDcoRJP7m96fnktkngnXZzhMwKShLS4dsPv5ZmeXUlIv3jHv6FLw9QMY99L2Rv4wa6RrzFo45f8rLZYzc2+04OPnPWtwvFBSpbyMIzDrM8noM4EARNJ1ix8y8ULuMzFzN1SnIUp5rh4hn9WPJEfJwoK4I2t/82w6uG9NMzFUEfMF1T2aUtXWtnGWCWx9rCXbGtea1WCdrv1p7ah7K8oOh5mVKNQEX+dCG57s15uYUi1LgB7eGwJGRSSnPcgu/2Vt95xUsClFBAKF+lRVikfLs8dWj307yqKlgJhw8oKHCdXEvKwUK0EqbgkDUc3DAra1uAMDdHRJNAeGGaTvedvUKAfpphtTbkzv4Z1Wfc+eaz7RmdqcmcvtCq0g187gMHCr2BVjt6dJl+5XRn5Tp+RR8X+HtV+4q8BYHCFxTkG6OXiLO4UIl84IrACFP9tCiof2k6rClOKO7pObgwxPi6Qd8zMjHTrcPi/5pjc0m19w/N5B+coFepcv2Az88CTiFKPVTDmCv9sc/50tEYV61yHfN7GpojNvd2MdrCmffd7f4iuaHQKfiKCE48XbRQAI/tBJwInnIwzfCQhdS/QuLtbCfA+llEHULqKpaIOS22/kV4n9oEGgbiimG2QGHBFRP7rs4pbOsYA1LvU2sgyVwBvTIkySAgEmIu0077tYVYUB2gh7Lj
 0RI1w9XG
 vN6UwnuyrSgkNpn5M77UAqNYURGqLyh5y063jv/x1wjWsEWjdxaOhalJzoPP+TLS3GNgIu2JbrKXjL+kOX7GdDcVSjEGOg5uVlh9x5n1oRr8KWZr9GYbMEgDnzcPEbG6ubsw+3fT3hZBxE7gCbCBgIa3ndCrkT496Ci9D6NBrmY0IJCiYMQw9Imy8KpPSD9uqP5dNf2lnXbWpPOyIveA3e+eMepdv7cizHVEpq55aczTfVMrx8t/stSCq/MpcWqYtXw0xAXfWB4saJFqakobPrFmF1fOZDTY5cM7sx3jItoLrxOqYkvZLD3Me/TbooMIy6yI8y4RrcAzOTNI0ns1iyC2uNnP88Dp6YaBRerFTPUZyoIrx6gHBTQmzR7uXy23L+nys+6kW6i8YYx8NdKpM0SVhHnEuGH7R3CN2rM3wFy9qo6qQTscfFFDEcuSV9ZSsyUV5A9IcYuv2KvHn32tgEWxCIpWmBldKk6nbBax8cz7bfew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_49858bc642844e3bbf6449c0f241af04xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQpJIGVuY291bnRlcmVkIGEgYnVnIGluIHRoZSBzaG1lbSBzdWJzeXN0ZW0uIERldGFp
bHMgYmVsb3cuDQpbU3VtbWFyeV0NCnNobWVtX2dldF9mb2xpb19nZnAoKSBjYW4gbGl2ZWxvY2sg
d2hlbiBtdWx0aXBsZSB0aHJlYWRzIGZhdWx0IG9uIHRoZQ0Kc2FtZSBzaG1lbSBwYWdlIGNvbmN1
cnJlbnRseS4gVGhlIC1FRVhJU1QgcmV0cnkgbG9vcCAoZ290byByZXBlYXQpIGhhcw0Kbm8gY29u
ZF9yZXNjaGVkKCksIGNhdXNpbmcgYnVzeS1sb29waW5nIHRocmVhZHMgdG8gc3RhcnZlIHRoZSB0
aHJlYWQNCnRoYXQgaG9sZHMgdGhlIHN3YXBjYWNoZSBzbG90LCByZXN1bHRpbmcgaW4gYW4gaW5k
ZWZpbml0ZSBSQ1Ugc3RhbGwgYW5kDQpzeXN0ZW0gaGFuZy4NCltFbnZpcm9ubWVudF0NCjEuS2Vy
bmVsOiA2LjE4LjIxIChBUk02NCwgUFJFRU1QVCwgQ09ORklHX0xSVV9HRU49eSkNCjIuVHJpZ2dl
cmVkIGJ5OiBtdWx0aS10aHJlYWRlZCBhcHAgd2l0aCB0aHJlYWRzIGNvbnN0cmFpbmVkIHRvIDIg
Q1BVcw0KdmlhIGNwdXNldA0KW1Jvb3QgQ2F1c2VdDQpXaGVuIG11bHRpcGxlIHRocmVhZHMgaW4g
dGhlIHNhbWUgcHJvY2VzcyBmYXVsdCBvbiB0aGUgc2FtZSBzaG1lbQ0Kc3dhcCBlbnRyeToNCjEu
VGhyZWFkIEEgZW50ZXJzIHNobWVtX3N3YXBfYWxsb2NfZm9saW8oKSwgc3VjY2VlZHMgYXQNCnN3
YXBjYWNoZV9wcmVwYXJlKCkgKHNldHMgU1dBUF9IQVNfQ0FDSEUpLCB0aGVuIGVudGVycw0Kd29y
a2luZ3NldF9yZWZhdWx0KCkgofogbHJ1X2dlbl9yZWZhdWx0KCkgofogcmN1X3JlYWRfbG9jaygp
Lg0KV2hpbGUgaW5zaWRlIHRoZSBSQ1UgcmVhZC1zaWRlIGNyaXRpY2FsIHNlY3Rpb24sIGl0IGlz
DQpwcmVlbXB0ZWQgdmlhIHByZWVtcHRfc2NoZWR1bGVfaXJxIChJUlEgZXhpdCBwYXRoIGRldGVj
dHMNClRJRl9ORUVEX1JFU0NIRUQpLg0KMi5UaHJlYWRzIEIgJiBDIGVudGVyIHNobWVtX3N3YXBf
YWxsb2NfZm9saW8oKSwgZmFpbCBhdA0Kc3dhcGNhY2hlX3ByZXBhcmUoKSAoc2xvdCBhbHJlYWR5
IHRha2VuIGJ5IEEpLCByZXR1cm4gLUVFWElTVC4NCjMuSW4gc2htZW1fZ2V0X2ZvbGlvX2dmcCgp
Og0KICAgIGVycm9yID0gc2htZW1fc3dhcGluX2ZvbGlvKC4uLik7DQogICAgaWYgKGVycm9yID09
IC1FRVhJU1QpDQogICAgICAgIGdvdG8gcmVwZWF0Oy8vIG5vIGNvbmRfcmVzY2hlZCgpLCB0aWdo
dCBsb29wDQo0LlRocmVhZHMgQiAmIEMgc3BpbiBhdCAxMDAlIENQVSBvbiB0aGUgcmV0cnkgbG9v
cC4gQWxsIHRocmVlDQp0aHJlYWRzIHNoYXJlIHRoZSBzYW1lIGNwdXNldCAoQ1BVMC0xLGNwdXNf
YWxsb3dlZD0weDMpLlRocmVhZCBBDQppcyBwZXJwZXR1YWxseSBwcmVlbXB0ZWQgYW5kIHN0YXJ2
ZWQgoaogaXQgY2Fubm90IGNvbXBsZXRlIHRoZQ0KZmV3IGluc3RydWN0aW9ucyBuZWVkZWQgdG8g
Y2FsbCByY3VfcmVhZF91bmxvY2soKS4NCjUuVGhlIGhlbGQgUkNVIHJlYWQgbG9jayBibG9ja3Mg
dGhlIGdyYWNlIHBlcmlvZCBpbmRlZmluaXRlbHksDQpjYXVzaW5nIGFsbCBzeW5jaHJvbml6ZV9y
Y3UoKSBjYWxsZXJzIChjZ3JvdXAgb3BlcmF0aW9ucywNCmZkIGFsbG9jYXRpb24sIGV0Yy4pIHRv
IGhhbmcsIGV2ZW50dWFsbHkgYmxvY2tpbmcgaW5pdC4NCltTY2hlZHVsaW5nIERldGFpbHNdDQpL
ZXkgb2JzZXJ2YXRpb25zOg0KMS5UaHJlYWQgQSB3YXMgUkNVLWJvb3N0ZWQgdG8gcHJpbyA5OCBi
dXQgYWNjdW11bGF0ZWQgb25seQ0KOTltcyBvZiBleGVjdXRpb24gb3ZlciB0aGUgZW50aXJlIHN0
YWxsIHBlcmlvZCAofjEyMDBzKS4NCkl0IHdhcyBlZmZlY3RpdmVseSBzdGFydmVkIGRlc3BpdGUg
dGhlIHByaW9yaXR5IGJvb3N0Lg0KMi5UaHJlYWRzIEIgJiBDIGhhdmUgdnJ1bnRpbWU9MCBhbmQg
cHJpbyA5MSwgaW5kaWNhdGluZw0KdGhleSBydW4gaW4gYW4gUlQtZXF1aXZhbGVudCBzY2hlZHVs
aW5nIGNsYXNzIChTQ0hFRF9GSUZPL1JUDQpwb2xpY3kpLiBFYWNoIGFjY3VtdWxhdGVkIH4xMTM0
IHNlY29uZHMgb2YgZXhlY3V0aW9uIHdpdGgNCm9ubHkgfjE2MDAgY29udGV4dCBzd2l0Y2hlcywg
bWVhbmluZyB0aGV5IHJhbiB1bmludGVycnVwdGVkDQpmb3IgfjcwMG1zIHBlciBzY2hlZHVsaW5n
IHF1YW50dW0gb24gYXZlcmFnZS4NCjMuVGhyZWFkIEEgY2Fubm90IHByZWVtcHQgVGhyZWFkcyBC
ICYgQzogQWx0aG91Z2ggUkNVIGJvb3N0DQpyYWlzZWQgVGhyZWFkIEEgdG8gcHJpbyA5OCwgVGhy
ZWFkcyBCICYgQyBhdCBwcmlvIDkxIChsb3dlcg0KbnVtZXJpYyB2YWx1ZSA9IGhpZ2hlciBwcmlv
cml0eSBpbiBSVCBjbGFzcykgaGF2ZSBlcXVhbCBvcg0KaGlnaGVyIGVmZmVjdGl2ZSBwcmlvcml0
eS4gVGhlIGJ1c3ktbG9vcGluZyB0aHJlYWRzIG5ldmVyDQp2b2x1bnRhcmlseSB5aWVsZCAobm8g
Y29uZF9yZXNjaGVkKCksIG5vIGJsb2NraW5nIGNhbGxzIGluDQp0aGUgbG9vcCksIHNvIFRocmVh
ZCBBIG5ldmVyIGdldHMgc2NoZWR1bGVkLg0KNC5DUFUgY29udGVudGlvbjogQ1BVMCBoYWQgbnJf
cnVubmluZz0yOCBhbmQgQ1BVMSBoYWQNCm5yX3J1bm5pbmc9MjQsIHdpdGggMy00IFJUIHRhc2tz
IHBlciBDUFUuIFRocmVhZCBBIGNvbXBldGVkDQp3aXRoIFRocmVhZCBCIG9uIENQVTAgYnV0IGNv
dWxkIG5vdCB3aW4gc2NoZWR1bGluZy4NCltPYnNlcnZlZCBJbXBhY3RdDQoxLlJDVSBzdGFsbCBs
YXN0aW5nIDkxMCsgc2Vjb25kcyAoMTkgY29uc2VjdXRpdmUgc3RhbGwNCndhcm5pbmdzLCBncmFj
ZSBwZXJpb2QgZz00Mzk4NzYxIG5ldmVyIGFkdmFuY2VkKQ0KMi5zeW5jaHJvbml6ZV9yY3VfZXhw
ZWRpdGVkKCkgY2FsbGVycyBibG9ja2VkIDc0Misgc2Vjb25kcw0KMy5pbml0IHByb2Nlc3MgaHVu
ZyA+IDcyMCBzZWNvbmRzIKH6IHN5c3RlbSB1bnJlc3BvbnNpdmUNCltDYWxsIFRyYWNlc10NClRo
cmVhZCBBIChSQ1Ugc3RhbGwgc291cmNlLCBzYW1wbGVkIDE5IHRpbWVzIGlkZW50aWNhbGx5KToN
Cl9fc3dpdGNoX3RvKzB4MWE0LzB4MzYwIChUKQ0KX19zY2hlZHVsZSsweDk2Yy8weGYzYw0KcHJl
ZW1wdF9zY2hlZHVsZV9pcnErMHhlYy8weDE5OA0KcmF3X2lycWVudHJ5X2V4aXRfY29uZF9yZXNj
aGVkKzB4MmMvMHg0NA0KaXJxZW50cnlfZXhpdCsweDM4LzB4NjQNCmV4aXRfdG9fa2VybmVsX21v
ZGUrMHgyOC8weDM4DQplbDFfaW50ZXJydXB0KzB4NWMvMHhhOA0KZWwxaF82NF9pcnFfaGFuZGxl
cisweDE4LzB4MjQNCmVsMWhfNjRfaXJxKzB4ODQvMHg4OA0Kd29ya2luZ3NldF9yZWZhdWx0KzB4
MTZjLzB4NzljIChQKQ0KICBzaG1lbV9zd2FwaW5fZm9saW8rMHg4ZTQvMHhkNDQNCiAgICBzaG1l
bV9nZXRfZm9saW9fZ2ZwKzB4YjgvMHg3MTANCiAgICAgIHNobWVtX2ZhdWx0KzB4YTAvMHgxNzQN
CiAgICAgICAgX19kb19mYXVsdA0KZG9fcHRlX21pc3NpbmcNCmhhbmRsZV9tbV9mYXVsdA0KZG9f
cGFnZV9mYXVsdA0KZWwwX2lhDQoNClRocmVhZCBCIChidXN5LWxvb3Agb24gQ1BVMCwgc3VtX2V4
ZWNfcnVudGltZT0xMTM0cyk6DQp4YXNfbG9hZCsweDc4LzB4ZTQgKFApDQogIHNobWVtX3N3YXBp
bl9mb2xpbysweDk1MC8weGQ0NA0KICAgIHNobWVtX2dldF9mb2xpb19nZnArMHhiOC8weDcxMA0K
ICAgICAgc2htZW1fZmF1bHQgofogLi4uIKH6IGVsMF9pYQ0KDQpUaHJlYWQgQyAoYnVzeS1sb29w
IG9uIENQVTEsIHN1bV9leGVjX3J1bnRpbWU9MTEzNHMpOg0KeGFzX2xvYWQrMHg1MC8weGU0IChQ
KQ0KICBzaG1lbV9zd2FwaW5fZm9saW8rMHhkOC8weGQ0NA0KICAgIHNobWVtX2dldF9mb2xpb19n
ZnArMHhiOC8weDcxMA0KICAgICAgc2htZW1fZmF1bHQgofogLi4uIKH6IGVsMF9pYQ0KW1F1ZXN0
aW9uXQ0KV2hhdCBpcyB0aGUgcmVjb21tZW5kZWQgYXBwcm9hY2ggdG8gZml4IHRoaXMgbGl2ZWxv
Y2s/DQpXZSBhcmUgY29uc2lkZXJpbmcgYWRkaW5nIGEgY29uZF9yZXNjaGVkKCkgYmVmb3JlIHRo
ZQ0KZ290byByZXBlYXQgaW4gc2htZW1fZ2V0X2ZvbGlvX2dmcCgpIHRvIGJyZWFrIHRoZSB0aWdo
dA0KbG9vcCBhbmQgYWxsb3cgdGhlIHN3YXBjYWNoZS1ob2xkaW5nIHRocmVhZCB0byBtYWtlDQpw
cm9ncmVzcy4gV291bGQgdGhpcyBiZSBhbiBhY2NlcHRhYmxlIGZpeCwgb3IgaXMgdGhlcmUNCmEg
YmV0dGVyIHN0cmF0ZWd5IChlLmcuLCBib3VuZGVkIHJldHJ5IHdpdGggZmFsbGJhY2ssDQpvciB5
aWVsZGluZyB0byB0aGUgc3BlY2lmaWMgd2FpdGVyKT8NCg0KVGhhbmtzLA0KQ2hhbyBNYQ0KIy8q
KioqKiqxvtPKvP68sMbkuL28/rqs09DQocPXuavLvrXEsaPD3NDFz6KjrL32z97T2reiy824+MnP
w+a12Na31tDB0LP2tcS49sjLu/LIutfpoaO9+9a5yM66zsbky/vIy9LUyM66ztDOyr3KudPDo6iw
/MCotauyu8/e09rIq7K/u/Kyv7fWtdjQucK2oaK4tNbGoaK78smit6KjqbG+08q8/tbQtcTQxc+i
oaPI57n7xPq07crVwcuxvtPKvP6jrMfrxPrBory0tee7sLvy08q8/s2o1qq3orz+yMuyosm+s/2x
vtPKvP6joSBUaGlzIGUtbWFpbCBhbmQgaXRzIGF0dGFjaG1lbnRzIGNvbnRhaW4gY29uZmlkZW50
aWFsIGluZm9ybWF0aW9uIGZyb20gWElBT01JLCB3aGljaCBpcyBpbnRlbmRlZCBvbmx5IGZvciB0
aGUgcGVyc29uIG9yIGVudGl0eSB3aG9zZSBhZGRyZXNzIGlzIGxpc3RlZCBhYm92ZS4gQW55IHVz
ZSBvZiB0aGUgaW5mb3JtYXRpb24gY29udGFpbmVkIGhlcmVpbiBpbiBhbnkgd2F5IChpbmNsdWRp
bmcsIGJ1dCBub3QgbGltaXRlZCB0bywgdG90YWwgb3IgcGFydGlhbCBkaXNjbG9zdXJlLCByZXBy
b2R1Y3Rpb24sIG9yIGRpc3NlbWluYXRpb24pIGJ5IHBlcnNvbnMgb3RoZXIgdGhhbiB0aGUgaW50
ZW5kZWQgcmVjaXBpZW50KHMpIGlzIHByb2hpYml0ZWQuIElmIHlvdSByZWNlaXZlIHRoaXMgZS1t
YWlsIGluIGVycm9yLCBwbGVhc2Ugbm90aWZ5IHRoZSBzZW5kZXIgYnkgcGhvbmUgb3IgZW1haWwg
aW1tZWRpYXRlbHkgYW5kIGRlbGV0ZSBpdCEqKioqKiovIw0K

--_000_49858bc642844e3bbf6449c0f241af04xiaomicom_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:=CB=CE=CC=E5;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:=B5=C8=CF=DF;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@=CB=CE=CC=E5";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@=B5=C8=CF=DF";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:=B5=C8=CF=DF;}
span.EmailStyle20
	{mso-style-type:personal-reply;
	font-family:=B5=C8=CF=DF;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-size:10.0pt;}
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word;text-justify-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:auto;mso-=
margin-bottom-alt:auto;text-align:left">
<span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">He=
llo,<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"mso-margin-top-alt:auto;mso-=
margin-bottom-alt:auto;text-align:left">
<span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">I =
encountered a bug in the shmem subsystem. Details below.<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Summary]<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">shmem_get_fo=
lio_gfp() can livelock when multiple threads fault on the
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">same shmem p=
age concurrently. The -EEXIST retry loop (goto repeat) has<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">no cond_resc=
hed(), causing busy-looping threads to starve the thread
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">that holds t=
he swapcache slot, resulting in an indefinite RCU stall and<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">system hang.=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Environment]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">1.Kernel: 6.18.21 (ARM64, PREEMPT, CONFIG_LRU_GEN=3Dy)=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">2.Triggered by: multi-threaded app with threads constr=
ained to 2 CPUs
<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"text-indent:6.0pt"><span lang=3D"EN-US" sty=
le=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">via cpuset<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Root Cause]<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">When multipl=
e threads in the same process fault on the same shmem
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">swap entry:<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">1.Thread A enters shmem_swap_alloc_folio(), succeeds a=
t
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">swapcache_prepare() (sets SWAP_HAS_CACHE), then enters
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">workingset_refault()
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=FA<spa=
n lang=3D"EN-US"> lru_gen_refault()
</span>=A1=FA<span lang=3D"EN-US"> rcu_read_lock(). <o:p></o:p></span></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">While inside the RCU read-side critical section, it is
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">preempted via preempt_schedule_irq (IRQ exit path dete=
cts
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">TIF_NEED_RESCHED).<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">2.Threads B &amp; C enter shmem_swap_alloc_folio(), fa=
il at
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">swapcache_prepare() (slot already taken by A), return =
-EEXIST.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">3.In shmem_get_folio_gfp():<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:10.5pt;mso-para-margin-left:1.0=
gd"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5=
">&nbsp;&nbsp;&nbsp;&nbsp;error =3D shmem_swapin_folio(...);<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal" style=3D"margin-left:10.5pt;mso-para-margin-left:1.0=
gd"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5=
">&nbsp;&nbsp;&nbsp;&nbsp;if (error =3D=3D -EEXIST)<o:p></o:p></span></p>
<p class=3D"MsoNormal" style=3D"margin-left:10.5pt;mso-para-margin-left:1.0=
gd"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5=
">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;goto repeat;// no cond_re=
sched(), tight loop<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">4.Threads B &amp; C spin at 100% CPU on the retry loop=
. All three
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">threads share the same cpuset (CPU0-1,cpus_allowed=3D0=
x3).Thread A
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">is perpetually preempted and starved
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=AA<spa=
n lang=3D"EN-US"> it cannot complete the
<o:p></o:p></span></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">few instructions needed to call rcu_read_unlock().<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">5.The held RCU read lock blocks the grace period indef=
initely,
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">causing all synchronize_rcu() callers (cgroup operatio=
ns,
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">fd allocation, etc.) to hang, eventually blocking init=
.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Scheduling Details]<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">Key observat=
ions:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">1.Thread A was RCU-boosted to prio 98 but accumulated =
only
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">99ms of execution over the entire stall period (~1200s=
).
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">It was effectively starved despite the priority boost.=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">2.Threads B &amp; C have vruntime=3D0 and prio 91, ind=
icating<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">they run in an RT-equivalent scheduling class (SCHED_F=
IFO/RT<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">policy). Each accumulated ~1134 seconds of execution w=
ith
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">only ~1600 context switches, meaning they ran uninterr=
upted<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">for ~700ms per scheduling quantum on average.<o:p></o:=
p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">3.Thread A cannot preempt Threads B &amp; C: Although =
RCU boost<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">raised Thread A to prio 98, Threads B &amp; C at prio =
91 (lower
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">numeric value =3D higher priority in RT class) have eq=
ual or
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">higher effective priority. The busy-looping threads ne=
ver
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">voluntarily yield (no cond_resched(), no blocking call=
s in<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">the loop), so Thread A never gets scheduled.<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">4.CPU contention: CPU0 had nr_running=3D28 and CPU1 ha=
d
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">nr_running=3D24, with 3-4 RT tasks per CPU. Thread A c=
ompeted<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">with Thread B on CPU0 but could not win scheduling.<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Observed Impact]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">1.RCU stall lasting 910&#43; seconds (19 consecutive s=
tall
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">warnings, grace period g=3D4398761 never advanced)<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">2.synchronize_rcu_expedited() callers blocked 742&#43;=
 seconds<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">3.init process hung &gt; 720 seconds
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=FA<spa=
n lang=3D"EN-US"> system unresponsive<o:p></o:p></span></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Call Traces]<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">Thread A</=
span></b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=
=CC=E5"> (RCU stall source, sampled 19 times identically):<o:p></o:p></span=
></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">__switch_to&=
#43;0x1a4/0x360 (T)<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">__schedule&#=
43;0x96c/0xf3c<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">preempt_sche=
dule_irq&#43;0xec/0x198<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">raw_irqentry=
_exit_cond_resched&#43;0x2c/0x44<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">irqentry_exi=
t&#43;0x38/0x64<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">exit_to_kern=
el_mode&#43;0x28/0x38<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">el1_interrup=
t&#43;0x5c/0xa8<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">el1h_64_irq_=
handler&#43;0x18/0x24<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">el1h_64_irq&=
#43;0x84/0x88<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">workingset_r=
efault&#43;0x16c/0x79c (P)<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp; shmem=
_swapin_folio&#43;0x8e4/0xd44<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp; shmem_get_folio_gfp&#43;0xb8/0x710<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; shmem_fault&#43;0xa0/0x174<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __do_fault
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"margin-left:84.0pt;text-alig=
n:left;text-indent:21.0pt">
<span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">do=
_pte_missing<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"margin-left:105.0pt;text-ali=
gn:left;text-indent:21.0pt">
<span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">ha=
ndle_mm_fault<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"margin-left:126.0pt;text-ali=
gn:left;text-indent:21.0pt">
<span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">do=
_page_fault<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"margin-left:147.0pt;text-ali=
gn:left;text-indent:21.0pt">
<span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">el=
0_ia<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5"><o:p>&nbsp;<=
/o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">Thread B</=
span></b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=
=CC=E5"> (busy-loop on CPU0, sum_exec_runtime=3D1134s):<o:p></o:p></span></=
p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">xas_load&#43=
;0x78/0xe4 (P)<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp; shmem=
_swapin_folio&#43;0x950/0xd44<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp; shmem_get_folio_gfp&#43;0xb8/0x710<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; shmem_fault
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=FA<spa=
n lang=3D"EN-US"> ... </span>
=A1=FA<span lang=3D"EN-US"> el0_ia<o:p></o:p></span></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5"><o:p>&nbsp;<=
/o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><b><span la=
ng=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">Thread C</=
span></b><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=
=CC=E5"> (busy-loop on CPU1, sum_exec_runtime=3D1134s):<o:p></o:p></span></=
p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">xas_load&#43=
;0x50/0xe4 (P)<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp; shmem=
_swapin_folio&#43;0xd8/0xd44<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp; shmem_get_folio_gfp&#43;0xb8/0x710<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; shmem_fault
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=FA<spa=
n lang=3D"EN-US"> ... </span>
=A1=FA<span lang=3D"EN-US"> el0_ia<o:p></o:p></span></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:16.0pt;font-=
family:=CB=CE=CC=E5">[Question]<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">What is the =
recommended approach to fix this livelock?<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">We are consi=
dering adding a cond_resched() before the<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">goto repeat =
in shmem_get_folio_gfp() to break the tight<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">loop and all=
ow the swapcache-holding thread to make
<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">progress. Wo=
uld this be an acceptable fix, or is there<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">a better str=
ategy (e.g., bounded retry with fallback,<o:p></o:p></span></p>
<p class=3D"MsoNormal" align=3D"left" style=3D"text-align:left"><span lang=
=3D"EN-US" style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">or yielding =
to the specific waiter)?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Thanks,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Chao Ma<o:p></o:p></span></p>
</div>
#/******=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=AC=D3=D0=D0=A1=C3=D7=
=B9=AB=CB=BE=B5=C4=B1=A3=C3=DC=D0=C5=CF=A2=A3=AC=BD=F6=CF=DE=D3=DA=B7=A2=CB=
=CD=B8=F8=C9=CF=C3=E6=B5=D8=D6=B7=D6=D0=C1=D0=B3=F6=B5=C4=B8=F6=C8=CB=BB=F2=
=C8=BA=D7=E9=A1=A3=BD=FB=D6=B9=C8=CE=BA=CE=C6=E4=CB=FB=C8=CB=D2=D4=C8=CE=BA=
=CE=D0=CE=CA=BD=CA=B9=D3=C3=A3=A8=B0=FC=C0=A8=B5=AB=B2=BB=CF=DE=D3=DA=C8=AB=
=B2=BF=BB=F2=B2=BF=B7=D6=B5=D8=D0=B9=C2=B6=A1=A2=B8=B4=D6=C6=A1=A2=BB=F2=C9=
=A2=B7=A2=A3=A9=B1=BE=D3=CA=BC=FE=D6=D0=B5=C4=D0=C5=CF=A2=A1=A3=C8=E7=B9=FB=
=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=D3=CA=BC=FE=A3=AC=C7=EB=C4=FA=C1=A2=BC=B4=B5=
=E7=BB=B0=BB=F2=D3=CA=BC=FE=CD=A8=D6=AA=B7=A2=BC=FE=C8=CB=B2=A2=C9=BE=B3=FD=
=B1=BE=D3=CA=BC=FE=A3=A1 This e-mail and its attachments contain confidenti=
al information from XIAOMI, which is intended only for the person or entity=
 whose address
 is listed above. Any use of the information contained herein in any way (i=
ncluding, but not limited to, total or partial disclosure, reproduction, or=
 dissemination) by persons other than the intended recipient(s) is prohibit=
ed. If you receive this e-mail in
 error, please notify the sender by phone or email immediately and delete i=
t!******/#
</body>
</html>

--_000_49858bc642844e3bbf6449c0f241af04xiaomicom_--

