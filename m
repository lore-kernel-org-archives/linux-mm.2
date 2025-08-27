Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9704CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 04:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FF06B020B; Wed, 27 Aug 2025 00:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819E56B020D; Wed, 27 Aug 2025 00:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709236B020F; Wed, 27 Aug 2025 00:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C0786B020B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:13:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0F486845A2
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:13:01 +0000 (UTC)
X-FDA: 83821216962.07.2DDE348
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B42D40003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:12:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756267979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=FwKGMJa1YOKpFW+ky8zIIrquwgW58xBTUeC+8VrZPms=;
	b=kdIfAm8km2iIVwraPuocAcB2ik84S41HZ6sUNfoxDulEovd7wXefP01xHoZ97miFkkBZ8O
	hbTJ+xTOKfKa/fjzDB9jHtuox4upPCyXfM5sp8/dyGklMj89Ug+npN/pZwXme47+piSBLt
	FF8j0jJuPOieGqHbF/30PLrmSp9Yj/I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com;
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756267979; a=rsa-sha256;
	cv=none;
	b=7X0sJ9CqULqUs1ADlEM0zGhOlBWiw8TsmIR/VRdiRXBYyZEq+uJMmVDIaxmGTAIxt8MSBH
	GwMhvZ1l0DYgpZ11G679xJ5uX6xLU91tC+H1GLAsVf15+AF0pVFgaUnVgxUAYLZLr8bRA/
	E9KY6Z2V4lKehbIaucew+rUodE0AZFw=
From: "Li,Rongqing" <lirongqing@baidu.com>
To: David Hildenbrand <david@redhat.com>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "osalvador@suse.de" <osalvador@suse.de>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "giorgitchankvetadze1997@gmail.com"
	<giorgitchankvetadze1997@gmail.com>
CC: "Xu,Wenjie(ACG CCN)" <xuwenjie04@baidu.com>
Subject: RE:  Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Thread-Topic: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Thread-Index: AdwXCKQKyZG+t/+FSoO+KsNcdGLEBA==
Date: Wed, 27 Aug 2025 04:12:48 +0000
Message-ID: <33c9676b1fda4cbaa42857787e03c7ec@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.30]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.4.11
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Queue-Id: 7B42D40003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9hepzjnhc15zzxyrfcag1fhj5n5ghe3j
X-HE-Tag: 1756267976-667237
X-HE-Meta: U2FsdGVkX198dLF0+jZDQQsxFQ63W2VVLiBj3HfV3TP037HwEQeQcJl0NZKW4I7MnrjrjjN3JtPOH5v/OIZVhcumNHJuZDDVm2+UT0oKqH4K3+W2Bb4N61GqtUqrmWiRMb//J1rjTPI/R4TOzTZUdQJJLfm55UXHsRNMynpUBN+3CgaBFdUrL4+w/8QmslrjFbZg88zwMUMO2zDEkHOoT9W0KoRJwcN3eMeq4cYvAAjclu6I4v/2CXBfACpb78ygJWHILKSBK6xjSyV2HhNz8naEoFGv/DgM4CpCfsWESbHnNd9egIuGCpfMX11r3KrXOGgz7kpBcoZ3MBEFLKni2gbwYFUu4g1FiAL6wdH3hK87UaPLCM8KebMTXD8CO1oGDS7dk5ppPHGIp7cHZiFPYrUNq34gRg4eDReaKC4n9j7qns5w+zMzHwoiJ5FcEl5i3e667rcWYaitv/vt6O6nwMIMWyJZwl5UJeKwSt4JRIl8YZq13i9bXJ91pVGaUvBb3zClO8r0egySaYzMFUyG9a4OA4pMGD7XxPrn2t2D50rmQMSMIS7lB1rQ2rc7sWvLfY5wO+Bc6JkcUiBCj5f1QeA3gyL6Z7dHtLFxV7aF3kSe7I64lYP8Y1NwKPbzIRMKqz6R9rXBgMtrXLWckG9kf3UGTOfyD7pBzXB9LrYShYEwNV1llZhUUTYYsN/4N4P79pHk5ztgCsNLIcopmfOCZaUEgoqW/UjteEjSELmXWJynrDPmzuyMBfTuhARDZZ5w1x80HOQ7EvTJ+otGZUPPhrpuz18tWT0qnTWs0Bh3CqL+uFgEk9T6pN5w+8T6Y9+19aiWslj1veXHzxFJUOmi9plNlNwQ4P8uo4uiUhChPLSsN7rTmGFqlvoEyRRxkR+rC4SqsbSXQHRuKmy13+Ld0ir9aVwt5vM00u++v0a+H2j03A9YkQw6pKWEmfBnL++OGrnrvxtXCeTYZy8zfcb
 NtTTAT9V
 jSmpQ1liKWSnTa6QRiGFUvm3i0wR4XdLQ6g/pfWBLfW2at97VVJ1qGUqIAHZifJZKeZHC342KyrZPV7vawEKaWXb70Nra9B8WA0uGG6jSxp51YOaLhXn+ku08w/ETYXnuOH7ESTTtnpn3StBsw/5Y+4Sc2A2PvSVvvrwy0Dm/onJ5Y3q59zpGYfx3rHK5XGa+D/d6kcPN9drWwOrQb10u4hpZV/rnpjR3GqPXQRgWDnrguSb4sb5xTxNx1up/V+jMHyWLrSR0fOjaOYk29VmLaYSYfF63euXOT5KQZ1qHVYQHIzXtWE3mEdZMsvpktqs7W6nIJk2olrF2Wm8VFUinbCBacZEFfijxgHTZJgkyTF2sW9UomT5JL9Tj90tUchSJbPGtgzvGLse8xeb0hDeb52rC7jSQp1lMJYNS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQouDQo+IA0KPiBBbHNvLCBjYW4ndCB3ZSBmYWlsIGxpZ2h0bHkgZHVyaW5nIHRoZSBmaXJzdCBh
dHRlbXB0IGFuZCBkeW5hbWljYWxseSBkZWNpZGUgaWYgd2UNCj4gc2hvdWxkIGRvIGEgc2Vjb25k
IHBhc2U/DQo+IA0KDQoNCkdvb2QgaWRlYSwgbGlrZSBiZWxvdw0KDQpkaWZmIC0tZ2l0IGEvbW0v
aHVnZXRsYi5jIGIvbW0vaHVnZXRsYi5jDQppbmRleCA3NTNmOTliLi40MjVhNzU5IDEwMDY0NA0K
LS0tIGEvbW0vaHVnZXRsYi5jDQorKysgYi9tbS9odWdldGxiLmMNCkBAIC0zNTg5LDYgKzM1ODks
NyBAQCBzdGF0aWMgdW5zaWduZWQgbG9uZyBfX2luaXQgaHVnZXRsYl9wYWdlc19hbGxvY19ib290
KHN0cnVjdCBoc3RhdGUgKmgpDQoNCiAgICAgICAgdW5zaWduZWQgbG9uZyBqaWZmaWVzX3N0YXJ0
Ow0KICAgICAgICB1bnNpZ25lZCBsb25nIGppZmZpZXNfZW5kOw0KKyAgICAgICB1bnNpZ25lZCBs
b25nIHJlbWFpbmluZzsNCg0KICAgICAgICBqb2IudGhyZWFkX2ZuICAgPSBodWdldGxiX3BhZ2Vz
X2FsbG9jX2Jvb3Rfbm9kZTsNCiAgICAgICAgam9iLnN0YXJ0ICAgICAgID0gMDsNCkBAIC0zNjIw
LDYgKzM2MjEsMTggQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgX19pbml0IGh1Z2V0bGJfcGFnZXNf
YWxsb2NfYm9vdChzdHJ1Y3QgaHN0YXRlICpoKQ0KDQogICAgICAgIGppZmZpZXNfc3RhcnQgPSBq
aWZmaWVzOw0KICAgICAgICBwYWRhdGFfZG9fbXVsdGl0aHJlYWRlZCgmam9iKTsNCisNCisgICAg
ICAgaWYgKGgtPm5yX2h1Z2VfcGFnZXMgIT0gaC0+bWF4X2h1Z2VfcGFnZXMgJiYgaHVnZXRsYl92
bWVtbWFwX29wdGltaXphYmxlKGgpKSB7DQorICAgICAgICAgICAgICAgcmVtYWluaW5nID0gaC0+
bWF4X2h1Z2VfcGFnZXMgLSBoLT5ucl9odWdlX3BhZ2VzOw0KKyAgICAgICAgICAgICAgIC8qIHZt
ZW1tYXAgb3B0aW1pemF0aW9uIGNhbiBzYXZlIGFib3V0IDEuNiUgKDQvMjUwKSBtZW1vcnkgKi8N
CisgICAgICAgICAgICAgICByZW1haW5pbmcgPSBtaW4ocmVtYWluaW5nLCAoaC0+bnJfaHVnZV9w
YWdlcyAqIDQgLyAyNTApKTsNCisNCisgICAgICAgICAgICAgICBqb2Iuc3RhcnQgICAgICAgPSBo
LT5ucl9odWdlX3BhZ2VzOw0KKyAgICAgICAgICAgICAgIGpvYi5zaXplICAgICAgICA9IHJlbWFp
bmluZzsNCisgICAgICAgICAgICAgICBqb2IubWluX2NodW5rICAgPSByZW1haW5pbmcgLyBodWdl
cGFnZV9hbGxvY2F0aW9uX3RocmVhZHM7DQorICAgICAgICAgICAgICAgcGFkYXRhX2RvX211bHRp
dGhyZWFkZWQoJmpvYik7DQorICAgICAgIH0NCg0KVGhhbmtzDQoNCi1MaQ0KDQo+IC0tDQo+IENo
ZWVycw0KPiANCj4gRGF2aWQgLyBkaGlsZGVuYg0KDQo=

