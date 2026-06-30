Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B838C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014306B00AD; Tue, 30 Jun 2026 09:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FC56B00B4; Tue, 30 Jun 2026 09:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43E56B00B5; Tue, 30 Jun 2026 09:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B29906B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:15:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FE1F404F0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:15:53 +0000 (UTC)
X-FDA: 84936626586.11.8FFA2F9
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [207.226.244.123])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6B54340013
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:15:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of machao26@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=machao26@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782825351;
	b=t2CyledOodoaGceSf3j1vceuhWLp7/onSoChK1tRI8+anOCm9vEMxnyKKkZ9xLY60HoK09
	FYwO61P/TjjxDTU0/FJ8vo2Zc6ASEFnSq+0qZOgozpJjR9rDu0Adkf0ZzGUkKec6K9Mp0o
	zs9BwCHKSOOKYRyyMl+xi+8UGsq8h48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782825351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YBgx6x4zs6ZlO56XW98vMzwkObgeY6b+aZh0Ee0OFq8=;
	b=5jehw/Da0jItJ1lIBhi9hLBQcDJcSvJ3q8ddwSN2AHy881u/FQwIzvY+WUX+Jakx4j4Jy9
	3fb0li1Ov/aT5iZ6//nK+dCxccFXPrBJcrL8ozLI0a78NspEZO4bf3gdGoLOvgTYqTGVkD
	0MXs7iqAHu4ZlAkvB+L1jgGPxKaF7r4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of machao26@xiaomi.com designates 207.226.244.123 as permitted sender) smtp.mailfrom=machao26@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
X-CSE-ConnectionGUID: jx67LCH3TRmByzysTriVuQ==
X-CSE-MsgGUID: dEPxJpnCR8+JKFLO05GFRQ==
X-IronPort-AV: E=Sophos;i="6.24,233,1774281600"; 
   d="scan'208,217";a="180719597"
From: =?gb2312?B?wu2zrA==?= <machao26@xiaomi.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, =?gb2312?B?zO/QorHz?=
	<tianxiaobin@xiaomi.com>, =?gb2312?B?0+G2q7Hz?= <yudongbin@xiaomi.com>,
	=?gb2312?B?wO7F9LPM?= <xiaoyaoli@xiaomi.com>
Subject: [BUG] shmem: shmem_get_folio_gfp livelock
Thread-Topic: [BUG] shmem: shmem_get_folio_gfp livelock
Thread-Index: Ad0IicmxtmIrTZWQT5i671sASycsWgAACTVQAACz3LAAAWN2wA==
Date: Tue, 30 Jun 2026 13:15:45 +0000
Message-ID: <700a2cbf90a2484f979aac858f08f5d4@xiaomi.com>
References: <e1c290782eeb419e8c3e18ac6b1f49eb@xiaomi.com>
 <126cb4ced14f4a3fa40c3189bf8a5920@xiaomi.com>
 <49858bc642844e3bbf6449c0f241af04@xiaomi.com>
In-Reply-To: <49858bc642844e3bbf6449c0f241af04@xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.237.88.13]
Content-Type: multipart/alternative;
	boundary="_000_700a2cbf90a2484f979aac858f08f5d4xiaomicom_"
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: 3iegrcymnzhw8hsg61hw3mbexnozitsn
X-Rspamd-Queue-Id: 6B54340013
X-Rspamd-Server: rspam06
X-HE-Tag: 1782825349-885968
X-HE-Meta: U2FsdGVkX1/V5dyWZkSfNnQmVPCJCVj2B3FcsIk4o9vkVrzdXAp02ALaRgqE+9RHSRRSBr7zPThwgO8Vak4yRppGBPCxvLFUsFVC/D4bhjIE9pvpsTUiOhtpSPMIqaadEgUS9MU9NQXT4qW8j7+Py75gIJsCBLQIG+UnNkMZo4q0Ziy7nNIRokYAr5zLJ/hbAvgMc4+vf+tqxo21eWlHNvNY4buU8ln5Wc4+okKngsZ6YJIf4HYqdrCTKRmMcxXcRKuw8VEzbF1fgQjMX0GrUqtXKdwhvpUaYx4fpMuFmYyS0AEIGzLZnbpY3QR4bFBIrT9PA8iVoUGILx6BLUEeO+L9m+tVB82dPrNzGjH1LIoi+La53V1oVeHCfwAbXg3K1IKJzjNmthjqX3mq380l9EkZEaekmqVDx58NwC64VA0jTBEBuX6mTLl/8Z8pO/IePNTwA91Mw1ddJkS0mFdSTQVV/xYMTdgJhCDKDU5oDO5pFlx6Fn9vF1e+2bNzPnyRvrwc7PXVK1wbb6Agm949ofczu23Fxfbe8Lu3J+IfiQdldNUs/7a9vArDD5HqIic18UdNpx/FP2qZtaeWSAXo63bN1Zbr5f/5201XBMrmzTSur8oPmLHoHhUarvpIKxbn3j6y9iWbHkAbz8O27Sx7ix7Sv5DjFE4aucp0jX0IOrvbJeDdrTSKNmycFrA+21YlSyoQBDjwLUJVUMISMzaj/17r6/ML2o6MpCx97Jn5AnC5I/94JDgllEUFL3mDOUQDl+ZTe7BQ1mpU2P2vn8wKnp1xIXpcP4poi+C/zOSxeE3FdtiT92z0+EpQuBuLKIXqL85qt/4Z+EnabDZH25TW5i03xmyNuQLTMDDPao6WQxIy3O/esFJPwZDnOgxPadiLa+JEYM/60ezBPfgtamh/3jQ6r0w22dK1bIm2XAA7MEnMStvzYwOLBQLrOGBpv4AKmYap8NE1TzhHqNXutWr
 va4FL+fO
 yvMGVdCra/69UYX6UTeak5jOe/M8J/I+hFn6nNef+/qBBYigX96PcZCYkXXjnfDRuXkhU1UvPUAao9j8vWyZAreAhpNdNW7J8je239SP2Shj90hmnMPgH6gosl0opUKYvLLky97gSNHpuGUvn7IA9XAvxbWsrQ2eCNcy0cXiriMbm48i51PYHIQnxwtHxZ39ED5stT+KiA3UwL4erYakSNw0/2NkT1oJR7ZOdfSl7ogpyJgJ7xfwopYzghUriaa/6+m2Z1y/CSWmmBAz8PDJaBNYz73uSj9AzhYKPrydcokh7ASgLQeo84HlhUDtfaURiBx9k28Sfhl6e6QHZa2E/xf+EArQ0POqwBW4yWhXeghuTZEAElhMUBvKLndwkqdtHXPLvB7cwcgpbcKFUCak/K1IwiBKfwFqLGwlgeNPRxMmRj/9liXZw0obwDzGEt1OkHegFTK7BHuNVkY3N7mle+zOkd3TbjFztA39O5zv+fSi6fXw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--_000_700a2cbf90a2484f979aac858f08f5d4xiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQpJIGVuY291bnRlcmVkIGEgYnVnIGluIHRoZSBzaG1lbSBzdWJzeXN0ZW0uIERldGFp
bHMgYmVsb3cuDQoNCltTdW1tYXJ5XQ0Kc2htZW1fZ2V0X2ZvbGlvX2dmcCgpIGNhbiBsaXZlbG9j
ayB3aGVuIG11bHRpcGxlIHRocmVhZHMgZmF1bHQgb24gdGhlDQpzYW1lIHNobWVtIHBhZ2UgY29u
Y3VycmVudGx5LiBUaGUgLUVFWElTVCByZXRyeSBsb29wIChnb3RvIHJlcGVhdCkgaGFzDQpubyBj
b25kX3Jlc2NoZWQoKSwgY2F1c2luZyBidXN5LWxvb3BpbmcgdGhyZWFkcyB0byBzdGFydmUgdGhl
IHRocmVhZA0KdGhhdCBob2xkcyB0aGUgc3dhcGNhY2hlIHNsb3QsIHJlc3VsdGluZyBpbiBhbiBp
bmRlZmluaXRlIFJDVSBzdGFsbCBhbmQNCnN5c3RlbSBoYW5nLg0KW0Vudmlyb25tZW50XQ0KMS5L
ZXJuZWw6IDYuMTguMjEgKEFSTTY0LCBQUkVFTVBULCBDT05GSUdfTFJVX0dFTj15KQ0KMi5Ucmln
Z2VyZWQgYnk6IG11bHRpLXRocmVhZGVkIGFwcCB3aXRoIHRocmVhZHMgY29uc3RyYWluZWQgdG8g
MiBDUFVzDQp2aWEgY3B1c2V0DQpbUm9vdCBDYXVzZV0NCldoZW4gbXVsdGlwbGUgdGhyZWFkcyBp
biB0aGUgc2FtZSBwcm9jZXNzIGZhdWx0IG9uIHRoZSBzYW1lIHNobWVtDQpzd2FwIGVudHJ5Og0K
MS5UaHJlYWQgQSBlbnRlcnMgc2htZW1fc3dhcF9hbGxvY19mb2xpbygpLCBzdWNjZWVkcyBhdA0K
c3dhcGNhY2hlX3ByZXBhcmUoKSAoc2V0cyBTV0FQX0hBU19DQUNIRSksIHRoZW4gZW50ZXJzDQp3
b3JraW5nc2V0X3JlZmF1bHQoKSCh+iBscnVfZ2VuX3JlZmF1bHQoKSCh+iByY3VfcmVhZF9sb2Nr
KCkuDQpXaGlsZSBpbnNpZGUgdGhlIFJDVSByZWFkLXNpZGUgY3JpdGljYWwgc2VjdGlvbiwgaXQg
aXMNCnByZWVtcHRlZCB2aWEgcHJlZW1wdF9zY2hlZHVsZV9pcnEgKElSUSBleGl0IHBhdGggZGV0
ZWN0cw0KVElGX05FRURfUkVTQ0hFRCkuDQoyLlRocmVhZHMgQiAmIEMgZW50ZXIgc2htZW1fc3dh
cF9hbGxvY19mb2xpbygpLCBmYWlsIGF0DQpzd2FwY2FjaGVfcHJlcGFyZSgpIChzbG90IGFscmVh
ZHkgdGFrZW4gYnkgQSksIHJldHVybiAtRUVYSVNULg0KMy5JbiBzaG1lbV9nZXRfZm9saW9fZ2Zw
KCk6DQogICAgZXJyb3IgPSBzaG1lbV9zd2FwaW5fZm9saW8oLi4uKTsNCiAgICBpZiAoZXJyb3Ig
PT0gLUVFWElTVCkNCiAgICAgICAgZ290byByZXBlYXQ7Ly8gbm8gY29uZF9yZXNjaGVkKCksIHRp
Z2h0IGxvb3ANCjQuVGhyZWFkcyBCICYgQyBzcGluIGF0IDEwMCUgQ1BVIG9uIHRoZSByZXRyeSBs
b29wLiBBbGwgdGhyZWUNCnRocmVhZHMgc2hhcmUgdGhlIHNhbWUgY3B1c2V0IChDUFUwLTEsY3B1
c19hbGxvd2VkPTB4MykuVGhyZWFkIEENCmlzIHBlcnBldHVhbGx5IHByZWVtcHRlZCBhbmQgc3Rh
cnZlZCChqiBpdCBjYW5ub3QgY29tcGxldGUgdGhlDQpmZXcgaW5zdHJ1Y3Rpb25zIG5lZWRlZCB0
byBjYWxsIHJjdV9yZWFkX3VubG9jaygpLg0KNS5UaGUgaGVsZCBSQ1UgcmVhZCBsb2NrIGJsb2Nr
cyB0aGUgZ3JhY2UgcGVyaW9kIGluZGVmaW5pdGVseSwNCmNhdXNpbmcgYWxsIHN5bmNocm9uaXpl
X3JjdSgpIGNhbGxlcnMgKGNncm91cCBvcGVyYXRpb25zLA0KZmQgYWxsb2NhdGlvbiwgZXRjLikg
dG8gaGFuZywgZXZlbnR1YWxseSBibG9ja2luZyBpbml0Lg0KW1NjaGVkdWxpbmcgRGV0YWlsc10N
CktleSBvYnNlcnZhdGlvbnM6DQoxLlRocmVhZCBBIHdhcyBSQ1UtYm9vc3RlZCB0byBwcmlvIDk4
IGJ1dCBhY2N1bXVsYXRlZCBvbmx5DQo5OW1zIG9mIGV4ZWN1dGlvbiBvdmVyIHRoZSBlbnRpcmUg
c3RhbGwgcGVyaW9kICh+MTIwMHMpLg0KSXQgd2FzIGVmZmVjdGl2ZWx5IHN0YXJ2ZWQgZGVzcGl0
ZSB0aGUgcHJpb3JpdHkgYm9vc3QuDQoyLlRocmVhZHMgQiAmIEMgaGF2ZSB2cnVudGltZT0wIGFu
ZCBwcmlvIDkxLCBpbmRpY2F0aW5nDQp0aGV5IHJ1biBpbiBhbiBSVC1lcXVpdmFsZW50IHNjaGVk
dWxpbmcgY2xhc3MgKFNDSEVEX0ZJRk8vUlQNCnBvbGljeSkuIEVhY2ggYWNjdW11bGF0ZWQgfjEx
MzQgc2Vjb25kcyBvZiBleGVjdXRpb24gd2l0aA0Kb25seSB+MTYwMCBjb250ZXh0IHN3aXRjaGVz
LCBtZWFuaW5nIHRoZXkgcmFuIHVuaW50ZXJydXB0ZWQNCmZvciB+NzAwbXMgcGVyIHNjaGVkdWxp
bmcgcXVhbnR1bSBvbiBhdmVyYWdlLg0KMy5UaHJlYWQgQSBjYW5ub3QgcHJlZW1wdCBUaHJlYWRz
IEIgJiBDOiBBbHRob3VnaCBSQ1UgYm9vc3QNCnJhaXNlZCBUaHJlYWQgQSB0byBwcmlvIDk4LCBU
aHJlYWRzIEIgJiBDIGF0IHByaW8gOTEgKGxvd2VyDQpudW1lcmljIHZhbHVlID0gaGlnaGVyIHBy
aW9yaXR5IGluIFJUIGNsYXNzKSBoYXZlIGVxdWFsIG9yDQpoaWdoZXIgZWZmZWN0aXZlIHByaW9y
aXR5LiBUaGUgYnVzeS1sb29waW5nIHRocmVhZHMgbmV2ZXINCnZvbHVudGFyaWx5IHlpZWxkIChu
byBjb25kX3Jlc2NoZWQoKSwgbm8gYmxvY2tpbmcgY2FsbHMgaW4NCnRoZSBsb29wKSwgc28gVGhy
ZWFkIEEgbmV2ZXIgZ2V0cyBzY2hlZHVsZWQuDQo0LkNQVSBjb250ZW50aW9uOiBDUFUwIGhhZCBu
cl9ydW5uaW5nPTI4IGFuZCBDUFUxIGhhZA0KbnJfcnVubmluZz0yNCwgd2l0aCAzLTQgUlQgdGFz
a3MgcGVyIENQVS4gVGhyZWFkIEEgY29tcGV0ZWQNCndpdGggVGhyZWFkIEIgb24gQ1BVMCBidXQg
Y291bGQgbm90IHdpbiBzY2hlZHVsaW5nLg0KW09ic2VydmVkIEltcGFjdF0NCjEuUkNVIHN0YWxs
IGxhc3RpbmcgOTEwKyBzZWNvbmRzICgxOSBjb25zZWN1dGl2ZSBzdGFsbA0Kd2FybmluZ3MsIGdy
YWNlIHBlcmlvZCBnPTQzOTg3NjEgbmV2ZXIgYWR2YW5jZWQpDQoyLnN5bmNocm9uaXplX3JjdV9l
eHBlZGl0ZWQoKSBjYWxsZXJzIGJsb2NrZWQgNzQyKyBzZWNvbmRzDQozLmluaXQgcHJvY2VzcyBo
dW5nID4gNzIwIHNlY29uZHMgofogc3lzdGVtIHVucmVzcG9uc2l2ZQ0KW0NhbGwgVHJhY2VzXQ0K
VGhyZWFkIEEgKFJDVSBzdGFsbCBzb3VyY2UsIHNhbXBsZWQgMTkgdGltZXMgaWRlbnRpY2FsbHkp
Og0KX19zd2l0Y2hfdG8rMHgxYTQvMHgzNjAgKFQpDQpfX3NjaGVkdWxlKzB4OTZjLzB4ZjNjDQpw
cmVlbXB0X3NjaGVkdWxlX2lycSsweGVjLzB4MTk4DQpyYXdfaXJxZW50cnlfZXhpdF9jb25kX3Jl
c2NoZWQrMHgyYy8weDQ0DQppcnFlbnRyeV9leGl0KzB4MzgvMHg2NA0KZXhpdF90b19rZXJuZWxf
bW9kZSsweDI4LzB4MzgNCmVsMV9pbnRlcnJ1cHQrMHg1Yy8weGE4DQplbDFoXzY0X2lycV9oYW5k
bGVyKzB4MTgvMHgyNA0KZWwxaF82NF9pcnErMHg4NC8weDg4DQp3b3JraW5nc2V0X3JlZmF1bHQr
MHgxNmMvMHg3OWMgKFApDQogIHNobWVtX3N3YXBpbl9mb2xpbysweDhlNC8weGQ0NA0KICAgIHNo
bWVtX2dldF9mb2xpb19nZnArMHhiOC8weDcxMA0KICAgICAgc2htZW1fZmF1bHQrMHhhMC8weDE3
NA0KICAgICAgICBfX2RvX2ZhdWx0DQpkb19wdGVfbWlzc2luZw0KaGFuZGxlX21tX2ZhdWx0DQpk
b19wYWdlX2ZhdWx0DQplbDBfaWENCg0KVGhyZWFkIEIgKGJ1c3ktbG9vcCBvbiBDUFUwLCBzdW1f
ZXhlY19ydW50aW1lPTExMzRzKToNCnhhc19sb2FkKzB4NzgvMHhlNCAoUCkNCiAgc2htZW1fc3dh
cGluX2ZvbGlvKzB4OTUwLzB4ZDQ0DQogICAgc2htZW1fZ2V0X2ZvbGlvX2dmcCsweGI4LzB4NzEw
DQogICAgICBzaG1lbV9mYXVsdCCh+iAuLi4gofogZWwwX2lhDQoNClRocmVhZCBDIChidXN5LWxv
b3Agb24gQ1BVMSwgc3VtX2V4ZWNfcnVudGltZT0xMTM0cyk6DQp4YXNfbG9hZCsweDUwLzB4ZTQg
KFApDQogIHNobWVtX3N3YXBpbl9mb2xpbysweGQ4LzB4ZDQ0DQogICAgc2htZW1fZ2V0X2ZvbGlv
X2dmcCsweGI4LzB4NzEwDQogICAgICBzaG1lbV9mYXVsdCCh+iAuLi4gofogZWwwX2lhDQpbUXVl
c3Rpb25dDQpXaGF0IGlzIHRoZSByZWNvbW1lbmRlZCBhcHByb2FjaCB0byBmaXggdGhpcyBsaXZl
bG9jaz8NCldlIGFyZSBjb25zaWRlcmluZyBhZGRpbmcgYSBjb25kX3Jlc2NoZWQoKSBiZWZvcmUg
dGhlDQpnb3RvIHJlcGVhdCBpbiBzaG1lbV9nZXRfZm9saW9fZ2ZwKCkgdG8gYnJlYWsgdGhlIHRp
Z2h0DQpsb29wIGFuZCBhbGxvdyB0aGUgc3dhcGNhY2hlLWhvbGRpbmcgdGhyZWFkIHRvIG1ha2UN
CnByb2dyZXNzLiBXb3VsZCB0aGlzIGJlIGFuIGFjY2VwdGFibGUgZml4LCBvciBpcyB0aGVyZQ0K
YSBiZXR0ZXIgc3RyYXRlZ3kgKGUuZy4sIGJvdW5kZWQgcmV0cnkgd2l0aCBmYWxsYmFjaywNCm9y
IHlpZWxkaW5nIHRvIHRoZSBzcGVjaWZpYyB3YWl0ZXIpPw0KDQpUaGFua3MsDQpDaGFvIE1hDQoj
LyoqKioqKrG+08q8/rywxuS4vbz+uqzT0NChw9e5q8u+tcSxo8Pc0MXPoqOsvfbP3tPat6LLzbj4
yc/D5rXY1rfW0MHQs/a1xLj2yMu78si61+mho7371rnIzrrOxuTL+8jL0tTIzrrO0M7Kvcq508Oj
qLD8wKi1q7K7z97T2sirsr+78rK/t9a12NC5wrahori01sahorvyyaK3oqOpsb7Tyrz+1tC1xNDF
z6Kho8jnufvE+rTtytXBy7G+08q8/qOsx+vE+sGivLS157uwu/LTyrz+zajWqreivP7Iy7Kiyb6z
/bG+08q8/qOhIFRoaXMgZS1tYWlsIGFuZCBpdHMgYXR0YWNobWVudHMgY29udGFpbiBjb25maWRl
bnRpYWwgaW5mb3JtYXRpb24gZnJvbSBYSUFPTUksIHdoaWNoIGlzIGludGVuZGVkIG9ubHkgZm9y
IHRoZSBwZXJzb24gb3IgZW50aXR5IHdob3NlIGFkZHJlc3MgaXMgbGlzdGVkIGFib3ZlLiBBbnkg
dXNlIG9mIHRoZSBpbmZvcm1hdGlvbiBjb250YWluZWQgaGVyZWluIGluIGFueSB3YXkgKGluY2x1
ZGluZywgYnV0IG5vdCBsaW1pdGVkIHRvLCB0b3RhbCBvciBwYXJ0aWFsIGRpc2Nsb3N1cmUsIHJl
cHJvZHVjdGlvbiwgb3IgZGlzc2VtaW5hdGlvbikgYnkgcGVyc29ucyBvdGhlciB0aGFuIHRoZSBp
bnRlbmRlZCByZWNpcGllbnQocykgaXMgcHJvaGliaXRlZC4gSWYgeW91IHJlY2VpdmUgdGhpcyBl
LW1haWwgaW4gZXJyb3IsIHBsZWFzZSBub3RpZnkgdGhlIHNlbmRlciBieSBwaG9uZSBvciBlbWFp
bCBpbW1lZGlhdGVseSBhbmQgZGVsZXRlIGl0ISoqKioqKi8jDQo=

--_000_700a2cbf90a2484f979aac858f08f5d4xiaomicom_
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
span.EmailStyle19
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
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Hello,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">I encountered a bug in the shmem subsystem. Details be=
low.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">[Summary]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">shmem_get_folio_gfp() can livelock when multiple threa=
ds fault on the
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">same shmem page concurrently. The -EEXIST retry loop (=
goto repeat) has<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">no cond_resched(), causing busy-looping threads to sta=
rve the thread
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">that holds the swapcache slot, resulting in an indefin=
ite RCU stall and<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">system hang.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">[Environment]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">1.Kernel: 6.18.21 (ARM64, PREEMPT, CONFIG_LRU_GEN=3Dy)=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">2.Triggered by: multi-threaded app with threads constr=
ained to 2 CPUs
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">via cpuset<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">[Root Cause]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">When multiple threads in the same process fault on the=
 same shmem
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">swap entry:<o:p></o:p></span></p>
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
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp; error =3D shmem_swapin_folio(...);<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp; if (error =3D=3D -EEXIST)<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto repeat=
;// no cond_resched(), tight loop<o:p></o:p></span></p>
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
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">[Scheduling Details]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Key observations:<o:p></o:p></span></p>
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
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
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
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">[Call Traces]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Thread A (RCU stall source, sampled 19 times identical=
ly):<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">__switch_to&#43;0x1a4/0x360 (T)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">__schedule&#43;0x96c/0xf3c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">preempt_schedule_irq&#43;0xec/0x198<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">raw_irqentry_exit_cond_resched&#43;0x2c/0x44<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">irqentry_exit&#43;0x38/0x64<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">exit_to_kernel_mode&#43;0x28/0x38<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">el1_interrupt&#43;0x5c/0xa8<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">el1h_64_irq_handler&#43;0x18/0x24<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">el1h_64_irq&#43;0x84/0x88<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">workingset_refault&#43;0x16c/0x79c (P)<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp; shmem_swapin_folio&#43;0x8e4/0xd44<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp; &nbsp;&nbsp;shmem_get_folio_gfp&#43;0xb8/0x710<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; shmem_fault&#43;0xa0/0x=
174<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __do_fault
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">do_pte_missing<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">handle_mm_fault<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">do_page_fault<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">el0_ia<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Thread B (busy-loop on CPU0, sum_exec_runtime=3D1134s)=
:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">xas_load&#43;0x78/0xe4 (P)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp; shmem_swapin_folio&#43;0x950/0xd44<o:p></o:p></=
span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp; shmem_get_folio_gfp&#43;0xb8/0x710<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; shmem_fault
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=FA<spa=
n lang=3D"EN-US"> ... </span>
=A1=FA<span lang=3D"EN-US"> el0_ia<o:p></o:p></span></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">Thread C (busy-loop on CPU1, sum_exec_runtime=3D1134s)=
:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">xas_load&#43;0x50/0xe4 (P)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp; shmem_swapin_folio&#43;0xd8/0xd44<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp; shmem_get_folio_gfp&#43;0xb8/0x710<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; shmem_fault
</span><span style=3D"font-size:12.0pt;font-family:=CB=CE=CC=E5">=A1=FA<spa=
n lang=3D"EN-US"> ... </span>
=A1=FA<span lang=3D"EN-US"> el0_ia<o:p></o:p></span></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">[Question]<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">What is the recommended approach to fix this livelock?=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">We are considering adding a cond_resched() before the<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">goto repeat in shmem_get_folio_gfp() to break the tigh=
t<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">loop and allow the swapcache-holding thread to make
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">progress. Would this be an acceptable fix, or is there=
<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">a better strategy (e.g., bounded retry with fallback,<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5">or yielding to the specific waiter)?<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US" style=3D"font-size:12.0pt;font-=
family:=CB=CE=CC=E5"><o:p>&nbsp;</o:p></span></p>
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

--_000_700a2cbf90a2484f979aac858f08f5d4xiaomicom_--

