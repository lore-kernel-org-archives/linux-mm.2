Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D9E0606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 12:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 885A86B00EF; Tue,  3 Nov 2026 07:46:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85E286B05B1; Tue,  3 Nov 2026 07:46:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74BDC6B05B2; Tue,  3 Nov 2026 07:46:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45EA76B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:46:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D442D803DA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:46:44 +0000 (UTC)
X-FDA: 85393781928.23.9BB90DD
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4B9A840005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:46:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf01.hostedemail.com: domain of donghui@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=donghui@xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793710003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=/zOyS6wF5V1b59ewwx7ShqgRWl14MZwd94MWewkUNL4=;
	b=ZQm1gi0ZrioYAldCmsu9vr++kbsJpjtQd8eerd+y97dh2lnHpgm2hE9jYJ5Hy7UqkMhD7C
	+RWPjNs01MRw4oSOZWKlbq1HK5SyL1//G2Xu8uIEg9GQ8m8vVtRKinMDSCLJap/stgHj29
	ncdH7rao82vF2Eu5VFUL0o3C+bm6k0k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793710003;
	b=V79PzVW22NpaOMqUzlJaKqZnP98u3h5+44WRcxZ8QAHwzNcQu6qsQ/MFZN97iteGJxNzE3
	pTtRJ2PX0QX3buxprJU2310DBCgORjNGXgsSzWU7dcTMRcVj59jLgeiEg6VglfEnwKXYJp
	IQ8MiOjnvVH7zCnHEdzada+Z7e2HpVg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com;
	spf=pass (imf01.hostedemail.com: domain of donghui@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=donghui@xiaomi.com
X-CSE-ConnectionGUID: FwfWwQXqRK6njFv5FdF79w==
X-CSE-MsgGUID: NI0sKgvIQwai8opO3k+XvA==
X-IronPort-AV: E=Sophos;i="6.27,193,1786982400"; 
   d="scan'208,217";a="167834197"
From: =?gb2312?B?tq271A==?= <donghui@xiaomi.com>
To: "linux-rt-devel@lists.kernel.org" <linux-rt-devel@lists.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	"\"Matthew Wilcox (Oracle)\"" <willy@infradead.org>, =?gb2312?B?zO/QorHz?=
	<tianxiaobin@xiaomi.com>, =?gb2312?B?wO7F9LPM?= <xiaoyaoli@xiaomi.com>,
	=?gb2312?B?xP7X87Hz?= <ningzuobin@xiaomi.com>, =?gb2312?B?xP6yqQ==?=
	<ningbo1@xiaomi.com>
Subject: [RFC] PREEMPT_RT: livelock between lockless page cache lookup and the
 folio freeze->removal window
Thread-Topic: [RFC] PREEMPT_RT: livelock between lockless page cache lookup
 and the folio freeze->removal window
Thread-Index: Ad1redQExug00yFvQd+N2JyjbQk6TA==
Date: Tue, 3 Nov 2026 12:46:36 +0000
Message-ID: <c2ff0c66422c4e2d869499a1186ff0ae@xiaomi.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: multipart/alternative;
	boundary="_000_c2ff0c66422c4e2d869499a1186ff0aexiaomicom_"
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Stat-Signature: ss3ypsmdzagcf6bbsb9gpthmpktgz34o
X-Spam-Status: No, score=-0.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4B9A840005
X-Rspam-User: 
X-HE-Tag: 1793710000-882404
X-HE-Meta: U2FsdGVkX1+1GdhHaitDLvNDFFMrbk5F11hFPs/yJyBc5L25ND5v3/H99Ecm9LUv8b9QwHsQhOEnnp6rCHMnvNX0JABKH8/LIHceH2jqGb2JoMtYo01QwZhY1WZtcLLszxLahnYdk2LMxHA/oUmG/1DC1kKDLEkknBzEnEaODNjxQYzZGWbUrD98RwJXFYnZJovfxj1MZt80QI7InYLYMo4qJFxBvAgHB55gN7Ifh3PmehGQTvU8vRDvzhy39NQuj4pyPuFHq+XFicwiD2X82MnqkePZy17HrMYQYnBcGOBha6FRZjdBV0AYIVxNPdSGcYCzt1UeQbZIPZuxU/eATUxwyhVlMghRgTeRiCClClg2tMFJ/lAggRAVmYqVuCSFPsJ1XoQvo2DGYrS6xFTJF2Yuea/MukXYNbxSvEo2MUgwVNNVQxi6Whar3ut3X5tPnfhxxhkaRKsi8q2L+6xnP7TadwXLmtdKpt4ejw6sxTVx1FHDBF9msmN9EzVYoBKvU7fu/sF70cZN/tzEJLDDGh7GFPTcul8nWs/5wrB+ox6/lhKAGa+38ljfkskHWpCjX7XD1d/uHSMs0lmRcgIiZkvBj5GRmQME1OzKNfQYrytdSvUdX3KmXRrdBfPLnLfKLnNsQ4Gz7w+Yt9dmeHFLji2ODeFkpozLZBXGiQrx+gmc7gWfosB/3acuRqTI6h+opB688jkCv5b+coisaV1aD2rKDufl37ePLj0BMzqwxKczfaD6oY5pGlmU0p7ECuTxujfypVhD9FuT7ClselVtVNwHTRpy3xcFhe4KndsqAjsbnXwb48pLNeEh42FN9gZGa2nzsAXoNrz36WoVLVIPTSNBwkzeovBXqdMrb8dw8LgGTLT4ZP7wlbkmiEPBtCQ3lVO1FX1GJ6VgsjWJEtMH+o4/QJv+I8dR7RS/5LZUybKBUlR1rJ9fqID+qllDg3+Gu7DTDWDZLNlqvGzL0rQ
 pOx8Yq2F
 59POZ5Kg+IXiYYqPW7MoollraZ3GuUQRCqYToMw4rH6WrQPhc1scefF2+wwJxrMlhrMyaYxeVTSyhMK790HaTP5Ne+H9m9wkjT7c4CTQF36rY4XK01L1ZMB5zGjfw4QJmuEOM3rSPCsGg9dCPVmoYvk8Q+GEuzjzqhVrTKpQzz2zOSACIpLhZHFaqqlkLs9ETG1CSctL6lqQz0VGPrX19XW0TNzdDiz5a8kseqt9uMAZyhzp/K4bYocMIbxdyATQsFizxigmJ+E76N7CMDbyBAiBLHy+ASGgUhsciAzgXWoWFQlYCmjnx4hqJJwTX6Wvi2P6qbRm7kBjiMWc8K4/34W/JkZzXhzPFEsWVCDmSsz3i6lVcJbVg6OCC3U+y/6w/ZoUYNWTMxjlC6ActXIYF0Adeeti1gAz20mpDnBAz1KvMDI5ZTPYtY6coGHeRnZp42gxzzAw30iCIAAf/VyHmyYRMdA8XB66ulztojlVZqLjqKtc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--_000_c2ff0c66422c4e2d869499a1186ff0aexiaomicom_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGVsbG8sDQoNCldlIGhpdCBhIHBlcm1hbmVudCBsaXZlbG9jayBvbiBhIFBSRUVNUFRfUlQgc3lz
dGVtIGFuZCB0cmFjZWQgaXQgdG8gYW4NCmludGVyYWN0aW9uIGJldHdlZW4gdGhlIGxvY2tsZXNz
IHBhZ2UgY2FjaGUgbG9va3VwIHJldHJ5IGxvb3AgaW4NCmZpbGVtYXBfZ2V0X2VudHJ5KCkgYW5k
IHRoZSBmb2xpbyBmcmVlemUgLT4geGFycmF5IHJlbW92YWwgd2luZG93IGluDQpfX3JlbW92ZV9t
YXBwaW5nKCkgKGFuZCB0aGUgbWlncmF0ZSBlcXVpdmFsZW50cykuIE9uIG5vbi1SVCB0aGF0IHdp
bmRvdw0KaXMgYXRvbWljIChJUlFzIGRpc2FibGVkKSBhbmQgdGhlcmVmb3JlIGJvdW5kZWQ7IG9u
IFBSRUVNUFRfUlQgaXQgaXMNCnByZWVtcHRpYmxlIGFuZCBjYW4gYmVjb21lIHVuYm91bmRlZCwg
d2hpY2ggdHVybnMgdGhlICJyZWZjb3VudCA9PSAwIGlzDQp0cmFuc2llbnQiIGFzc3VtcHRpb24g
b2YgdGhlIGxvb2t1cCBwYXRoIGludG8gYSBwZXJtYW5lbnQgc3Bpbi4NCg0KVGhlIGFmZmVjdGVk
IGNvZGUgaXMgdmFuaWxsYSB1cHN0cmVhbSAob3VyIG1tL2ZpbGVtYXAuYywgbW0vdm1zY2FuLmMN
CmFuZCBtbS9taWdyYXRlLmMgbWF0Y2ggNi4xMiBleGFjdGx5KTsgbm90aGluZyB2ZW5kb3Itc3Bl
Y2lmaWMgaXMNCmludm9sdmVkLg0KDQpUaGUgb2J2aW91cyBmaXggLS0gbWFraW5nIHRoZSB3aW5k
b3cgbm9uLXByZWVtcHRpYmxlIG9uIFJUIC0tIGRvZXMgbm90DQp3b3JrIGZvciB0aGUgcmVjbGFp
bSBwYXRoLCB3aGljaCBpcyB0aGUgb25lIHdlIGhpdCAoc2VjdGlvbiA0LjEpLiBXZSBhcmUNCmRl
bGliZXJhdGVseSBub3Qgc2VuZGluZyBhIHBhdGNoIHlldDogd2Ugd291bGQgbGlrZSB0byBoZWFy
IHdoaWNoDQpmaXggZGlyZWN0aW9uIHVwc3RyZWFtIHByZWZlcnMgYmVmb3JlIGdvaW5nIGZ1cnRo
ZXIuDQoNCjEuIFN5bXB0b20NCi0tLS0tLS0tLS0NCg0KLSA2LjEyLjczLXJ0MTUgKFBSRUVNUFRf
UlQpLCBhcm02NCwgMjAgQ1BVcy4NCi0gQSBTQ0hFRF9GSUZPIDk5IHVzZXJzcGFjZSB3b3JrbG9h
ZCB3YXMgcGFnZS1mYXVsdGluZyBvbiBmaWxlLWJhY2tlZA0KICBjb2RlIHBhZ2VzIG9mIGEgc2hh
cmVkIGxpYnJhcnkgKGxpYmMuc28uNiBpbiBvdXIgY2FzZSkgd2hpbGUgdGhlIHN5c3RlbQ0KICB3
YXMgdW5kZXIgbWVtb3J5IHByZXNzdXJlLg0KLSBPbmUgQ1BVIHJlcG9ydGVkIHJjdV9wcmVlbXB0
IHNlbGYtZGV0ZWN0ZWQgc3RhbGwgZXZlcnkgfjYzIHMgZnJvbSB0aGVuDQogIG9uOiA2NzArIHJl
cG9ydHMgb3ZlciB0aGUgfjEyIGhvdXJzIGNvdmVyZWQgYnkgb3VyIGNhcHR1cmVkIGxvZ3MuDQot
IFRoZSBuZXh0IGRheSwgYW5kIGFnYWluIGFib3V0IHR3byBkYXlzIGFmdGVyIHRoZSBmaXJzdCBz
dGFsbCwgd2UNCiAgaW5zcGVjdGVkIHRoZSBtYWNoaW5lIG92ZXIgSlRBRy4gSXQgd2FzIHN0aWxs
IHN0dWNrLCB3aXRoIHRoZSBzYW1lDQogIHJlZ2lzdGVyIHZhbHVlcyBhcyBpbiB0aGUgZmlyc3Qg
cmVwb3J0cy4gSXQgbmV2ZXIgcmVjb3ZlcmVkIG9uIGl0cw0KICBvd247IG9ubHkgYSByZWJvb3Qg
YnJvdWdodCBpdCBiYWNrLg0KLSBPbiB0aGF0IENQVSB0aGUgcnVubmluZyB0YXNrIHdhcyBzcGlu
bmluZyBpbiBmaWxlbWFwX2dldF9lbnRyeSgpIG9uIGENCiAgZm9saW8gd2hvc2UgX3JlZmNvdW50
IHdhcyAwIChmcm96ZW4pIHdoaWxlIHRoZSBmb2xpbyB3YXMgc3RpbGwNCiAgcmVhY2hhYmxlIGZy
b20gdGhlIG1hcHBpbmcncyB4YXJyYXkuDQotIGtzd2FwZDAgd2FzIGZvdW5kIHByZWVtcHRlZCBp
bnNpZGUgX19yZW1vdmVfbWFwcGluZygpLCBpdHMgc3RhY2sNCiAgZW5kaW5nIGluIF9fZmlsZW1h
cF9yZW1vdmVfZm9saW8oKSAtPiBmaWxlbWFwX3VuYWNjb3VudF9mb2xpbygpIC0+DQogIC4uLiAt
PiBwcmVlbXB0X3NjaGVkdWxlKCk6IHRoZSBmb2xpbyB3YXMgYWxyZWFkeSBmcm96ZW4gKHJlZmNv
dW50IDAsDQogIG9mZi1MUlUsIHVubWFwcGVkKSBidXQgbm90IHlldCByZW1vdmVkIGZyb20gdGhl
IHhhcnJheSwgYW5kIHRoZSB0YXNrDQogIHN0aWxsIGhlbGQgdGhlIHhhcnJheSBsb2NrLg0KDQpB
bGwgNjcwIHN0YWxsIHJlcG9ydHMgc2hvdyB0aGUgc2FtZSB0YXNrIGFuZCB0aGUgc2FtZSBmb2xp
by4gVGhlaXIgUEMNCnNhbXBsZXMgZmFsbCBpbnNpZGUgdGhpcyByZXRyeSBsb29wLCBtb3N0bHkg
aW4geGFzX2xvYWQoKTsgdGhlIHBhdGgNCnRha2VuIGFmdGVyIGEgc3VjY2Vzc2Z1bCByZWZjb3Vu
dCBpbmNyZW1lbnQgd2FzIG5ldmVyIHNhbXBsZWQuIEENCnNlY29uZCwgbm9uLVJUIHByb2Nlc3Mg
bGF0ZXIgaHVuZyBpbiB0aGUgc2FtZSBsb29wIG9uIHRoZSBzYW1lIGZvbGlvLA0Kc2hvd2luZyB0
aGF0IG9uY2Ugc3VjaCBhbiBlbnRyeSBleGlzdHMsIGV2ZXJ5IHJlYWRlciBvZiB0aGF0IHBhZ2Ug
aXMgYQ0KdmljdGltLg0KDQoyLiBSb290IGNhdXNlDQotLS0tLS0tLS0tLS0tDQoNCjIuMSBSZWFk
ZXI6IHVuYm91bmRlZCByZXRyeSBvbiByZWZjb3VudCA9PSAwDQoNCi8qIG1tL2ZpbGVtYXAuYywg
ZmlsZW1hcF9nZXRfZW50cnkoKSAqLw0KICAgICAgIHJjdV9yZWFkX2xvY2soKTsNCnJlcGVhdDoN
CiAgICAgICB4YXNfcmVzZXQoJnhhcyk7DQogICAgICAgZm9saW8gPSB4YXNfbG9hZCgmeGFzKTsN
CiAgICAgICBpZiAoeGFzX3JldHJ5KCZ4YXMsIGZvbGlvKSkNCiAgICAgICAgICAgICAgZ290byBy
ZXBlYXQ7DQogICAgICAgLyoNCiAgICAgICAqIEEgc2hhZG93IGVudHJ5IG9mIGEgcmVjZW50bHkg
ZXZpY3RlZCBwYWdlLCBvciBhIHN3YXAgZW50cnkgZnJvbQ0KICAgICAgICogc2htZW0vdG1wZnMu
ICBSZXR1cm4gaXQgd2l0aG91dCBhdHRlbXB0aW5nIHRvIHJhaXNlIHBhZ2UgY291bnQuDQogICAg
ICAgKi8NCiAgICAgICBpZiAoIWZvbGlvIHx8IHhhX2lzX3ZhbHVlKGZvbGlvKSkNCiAgICAgICAg
ICAgICAgZ290byBvdXQ7DQoNCiAgICAgICBpZiAoIWZvbGlvX3RyeV9nZXQoZm9saW8pKQ0KICAg
ICAgICAgICAgICBnb3RvIHJlcGVhdDsNCg0KVGhlIGxvb3AgdHJlYXRzIHJlZmNvdW50ID09IDAg
YXMgYSB0cmFuc2llbnQgc3RhdGUgYW5kIHJldHJpZXMuIEl0IG5ldmVyDQpzbGVlcHMgb3IgeWll
bGRzIHdoaWxlIGRvaW5nIHNvLCBhbmQgdGhlcmUgaXMgbm8gcmV0cnkgYm91bmQsIG5vIHRpbWVv
dXQNCmFuZCBubyB3YXJuaW5nLg0KDQoyLjIgV3JpdGVyOiB0aGUgd2luZG93IGlzIGJvdW5kZWQg
b24gbm9uLVJUDQoNCi8qIG1tL3Ztc2Nhbi5jLCBfX3JlbW92ZV9tYXBwaW5nKCkgKi8NCiAgICAg
ICBpZiAoIWZvbGlvX3Rlc3Rfc3dhcGNhY2hlKGZvbGlvKSkNCiAgICAgICAgICAgICAgc3Bpbl9s
b2NrKCZtYXBwaW5nLT5ob3N0LT5pX2xvY2spOw0KICAgICAgIHhhX2xvY2tfaXJxKCZtYXBwaW5n
LT5pX3BhZ2VzKTsNCiAgICAgICAuLi4NCiAgICAgICByZWZjb3VudCA9IDEgKyBmb2xpb19ucl9w
YWdlcyhmb2xpbyk7DQogICAgICAgaWYgKCFmb2xpb19yZWZfZnJlZXplKGZvbGlvLCByZWZjb3Vu
dCkpDQogICAgICAgICAgICAgIGdvdG8gY2Fubm90X2ZyZWU7DQogICAgICAgLyogbm90ZTogYXRv
bWljX2NtcHhjaGcgaW4gZm9saW9fcmVmX2ZyZWV6ZSBwcm92aWRlcyB0aGUgc21wX3JtYiAqLw0K
ICAgICAgIC4uLg0KICAgICAgICAgICAgICBfX2ZpbGVtYXBfcmVtb3ZlX2ZvbGlvKGZvbGlvLCBz
aGFkb3cpOw0KICAgICAgICAgICAgICB4YV91bmxvY2tfaXJxKCZtYXBwaW5nLT5pX3BhZ2VzKTsN
CiAgICAgICAuLi4NCmNhbm5vdF9mcmVlOg0KICAgICAgIHhhX3VubG9ja19pcnEoJm1hcHBpbmct
PmlfcGFnZXMpOw0KDQpSZWFkZXJzIG9uIG90aGVyIENQVXMgY2FuIGJyaWVmbHkgb2JzZXJ2ZSB0
aGUgZnJvemVuIGZvbGlvIGV2ZW4gb24NCm5vbi1SVCAtLSB0aGF0IGlzIHdoYXQgdGhlIHJldHJ5
IGxvb3AgaXMgZm9yLiBPbiBub24tUlQsIGhvd2V2ZXIsDQp4YV9sb2NrX2lycSgpIGRpc2FibGVz
IElSUXMgYW5kIHByZWVtcHRpb24sIHNvIHRoZSBpbnRlcnZhbCBmcm9tDQpmb2xpb19yZWZfZnJl
ZXplKCkgdG8gX19maWxlbWFwX3JlbW92ZV9mb2xpbygpIGNhbm5vdCBiZSBwcmVlbXB0ZWQNCmFu
ZCBjYW5ub3Qgb3V0bGl2ZSB0aGUgbG9ja2VkIGNvZGUgcGF0aDogdGhlIHdpbmRvdyBpcyBib3Vu
ZGVkLCBhbmQNCnRoZSByZXRyeSB0ZXJtaW5hdGVzIGFmdGVyIGEgZmV3IGl0ZXJhdGlvbnMuDQoN
CjIuMyBPbiBQUkVFTVBUX1JUIHRoZSB3aW5kb3cgaXMgdW5ib3VuZGVkIC0tIHRoaXMgaXMgdGhl
IGJyZWFrDQoNCk9uIFBSRUVNUFRfUlQgeGFfbG9ja19pcnEoKSBtYXBzIHRvIHJ0X3NwaW5fbG9j
aygpOiBhbiBydF9tdXRleA0KcGx1cyBtaWdyYXRlX2Rpc2FibGUoKSBhbmQgcmN1X3JlYWRfbG9j
aygpLiBJdCBkb2VzIG5vdCBkaXNhYmxlDQpwcmVlbXB0aW9uLiBBIHRhc2sgaW5zaWRlIHRoZSBm
cmVlemUgLT4gcmVtb3ZhbCB3aW5kb3cgY2FuIHRoZXJlZm9yZSBiZQ0KcHJlZW1wdGVkLCBhbmQg
dGhlIGZyb3plbiBmb2xpbyBzdGF5cyB2aXNpYmxlIGluIHRoZSB4YXJyYXkgd2l0aA0KcmVmY291
bnQgPT0gMCBmb3IgYXMgbG9uZyBhcyB0aGUgaG9sZGVyIGlzIG9mZi1DUFUgLS0gdGhlIHdpbmRv
dyBpcyBubw0KbG9uZ2VyIGJvdW5kZWQgYnkgdGhlIGxvY2tlZCBjb2RlIHBhdGgsIGJ1dCBieSBz
Y2hlZHVsaW5nLg0KDQptaWdyYXRlX2Rpc2FibGUoKSBhZ2dyYXZhdGVzIHRoaXM6IHRoZSBob2xk
ZXIgaXMgcGlubmVkIHRvIHRoZSBDUFUgaXQNCndhcyBwcmVlbXB0ZWQgb24uIFRoZSBob2xkZXIg
ZG9lcyBub3QgaGF2ZSB0byBiZSBrc3dhcGQ6IHRoZSBzYW1lDQpzaHJpbmtfZm9saW9fbGlzdCgp
IC0+IF9fcmVtb3ZlX21hcHBpbmcoKSBwYXRoIGlzIHVzZWQgYnkgZGlyZWN0DQpyZWNsYWltLCBz
byBhbnkgdGFzayBhbGxvY2F0aW5nIG1lbW9yeSBjYW4gYmUgdGhlIHZpY3RpbS4NCg0KMi40IEhv
dyBpdCBiZWNvbWVzIHBlcm1hbmVudDogcHJpb3JpdHkgaW52ZXJzaW9uDQoNCkluIG91ciBjYXNl
IGEgU0NIRURfRklGTyA5OSB0YXNrIHByZWVtcHRlZCB0aGUgaG9sZGVyIG9uIHRoZSBzYW1lIENQ
VSwNCnRoZW4gZmF1bHRlZCBvbiB0aGUgdmVyeSBwYWdlIGJlaW5nIHJlbW92ZWQgYW5kIGVudGVy
ZWQgdGhlDQpmaWxlbWFwX2dldF9lbnRyeSgpIHNwaW4uIFR3byBmdXJ0aGVyIFNDSEVEX0ZJRk8g
OTkgdGhyZWFkcyBvZiB0aGUNCnNhbWUgd29ya2xvYWQgYmxvY2tlZCBvbiB0aGUgc2FtZSB4YXJy
YXkgbG9jazsgdGhyb3VnaCBwcmlvcml0eQ0KaW5oZXJpdGFuY2UgdGhlIGhvbGRlciAoa3N3YXBk
KSB3YXMgYm9vc3RlZCBpbnRvIHRoZSBSVCBzY2hlZHVsaW5nIGNsYXNzDQphdCB0aGUgc2FtZSBl
ZmZlY3RpdmUgcHJpb3JpdHkgYXMgdGhlIHNwaW5uZXIuIFNDSEVEX0ZJRk8gZG9lcyBub3QNCnRp
bWUtc2xpY2UgYW1vbmcgZXF1YWwgcHJpb3JpdGllcywgc28gYSBzcGlubmVyIHRoYXQgbmV2ZXIg
YmxvY2tzIG5ldmVyDQpnaXZlcyB0aGUgQ1BVIGJhY2sgdG8gdGhlIGhvbGRlci4NCg0KVGhpcyBp
cyB3aGVyZSBzZWxmLWhlYWxpbmcgaXMgbG9zdC4gV2hpbGUgdGhlIGhvbGRlciByZW1haW5zIENG
UywgdGhlDQpSVCBiYW5kd2lkdGggbGltaXQgKHNjaGVkX3J0X3J1bnRpbWVfdXMsIDk1MCBtcyBw
ZXIgMSBzIHBlcmlvZCBieQ0KZGVmYXVsdCkgcmVzZXJ2ZXMgQ1BVIHRpbWUgZm9yIENGUyB0YXNr
cyBleGFjdGx5IHNvIHRoYXQgYSBydW4tYXdheSBSVA0KdGFzayBjYW5ub3QgbG9jayB1cCB0aGUg
bWFjaGluZSAoc2VlDQpEb2N1bWVudGF0aW9uL3NjaGVkdWxlci9zY2hlZC1ydC1ncm91cC5yc3Qp
OyB0aGUgaG9sZGVyIGNhbiBzdGlsbCBydW4NCmFuZCBjbG9zZSB0aGUgd2luZG93LiBPbmNlIFBJ
IHB1bGxzIHRoZSBob2xkZXIgaW50byB0aGUgUlQgY2xhc3MgaXQgaXMNCnRocm90dGxlZCB0b2dl
dGhlciB3aXRoIHRoZSBzcGlubmVyIGFuZCBubyBsb25nZXIgYmVuZWZpdHMgZnJvbSB0aGF0DQpy
ZXNlcnZlLiAoV2l0aCBzY2hlZF9ydF9ydW50aW1lX3VzID0gLTEgZXZlbiB0aGUgQ0ZTIGVzY2Fw
ZSBkb2VzIG5vdA0KZXhpc3QuKQ0KDQpUaGUgc3Bpbm5lciBpcyBpbnZpc2libGUgdG8gUEk6IGl0
IHdhaXRzIG9uIHRoZSBmb2xpbywgbm90IG9uIHRoZSBsb2NrLA0Kc28gbm90aGluZyBldmVyIGJv
b3N0cyB0aGUgaG9sZGVyIG9uIGl0cyBiZWhhbGYuDQoNClRoZSBmb3VyIG5lY2Vzc2FyeSBjb25k
aXRpb25zOg0KDQogIChhKSBmcm96ZW4tYnV0LXZpc2libGUgZm9saW8gLT4gcmVhZGVyIHNwaW5z
DQogICAgICB3aGVyZTogZmlsZW1hcF9nZXRfZW50cnkoKSByZXRyeSBsb29wDQogIChiKSB3aW5k
b3cgdW5ib3VuZGVkIChob2xkZXIgcHJlZW1wdGlibGUsIHBpbm5lZCkNCiAgICAgIHdoZXJlOiBQ
UkVFTVBUX1JUIHhhX2xvY2tfaXJxKCkgc2VtYW50aWNzDQogIChjKSB1bnlpZWxkaW5nIHNwaW5u
ZXIgb24gdGhlIHNhbWUgQ1BVDQogICAgICB3aGVyZTogU0NIRURfRklGTyA5OSBpbiB0aGUgcmV0
cnkgbG9vcA0KICAoZCkgUEkgcmVtb3ZlcyB0aGUgaG9sZGVyJ3MgQ0ZTIGJhbmR3aWR0aCByZXNl
cnZlDQogICAgICB3aGVyZTogUlQgd2FpdGVycyBvbiB0aGUgc2FtZSB4YXJyYXkgbG9jaw0KDQoz
LiBCbGFzdCByYWRpdXMNCi0tLS0tLS0tLS0tLS0tLQ0KDQpXZSB3ZW50IHRocm91Z2ggZXZlcnkg
Zm9saW9fcmVmX2ZyZWV6ZSgpL3BhZ2VfcmVmX2ZyZWV6ZSgpIHVzZXIgaW4NCjYuMTIuIFR3byBv
ZiB0aGVtIGNhbiBmcmVlemUgYSByZWd1bGFyIGZpbGUgZm9saW8gYW5kIGxlYXZlIGl0DQpyZWFj
aGFibGUgZnJvbSB0aGUgcGFnZSBjYWNoZSB4YXJyYXksIGFuZCBvbiBQUkVFTVBUX1JUIGJvdGgg
Y2FuIGJlDQpwcmVlbXB0ZWQgdGhlcmU6DQoNCiAgLSBtbS92bXNjYW4uYywgX19yZW1vdmVfbWFw
cGluZygpDQogICAgICB0cmlnZ2VyOiByZWNsYWltIC0tIGtzd2FwZCBvciBkaXJlY3QgcmVjbGFp
bQ0KICAtIG1tL21pZ3JhdGUuYywgX19mb2xpb19taWdyYXRlX21hcHBpbmcoKQ0KICAgICAgdHJp
Z2dlcjogY29tcGFjdGlvbiAvIENNQSAvIGhvdHBsdWcNCg0KQm90aCBob2xkIHRoZSB4YXJyYXkg
bG9jayBmcm9tIGJlZm9yZSB0aGUgZnJlZXplIHVudGlsIHRoZSBmb2xpbyBoYXMNCmJlZW4gcmVt
b3ZlZCwgb3IgcmVwbGFjZWQgYW5kIHVuZnJvemVuLg0KDQpUaGUgdW5ib3VuZGVkIHJlZmNvdW50
ID09IDAgc3BpbiBleGlzdHMgaW4gc2V2ZXJhbCBsb29rdXAgbG9vcHMsIG5vdA0KanVzdCBmaWxl
bWFwX2dldF9lbnRyeSgpOg0KDQotIGZpbGVtYXBfZ2V0X2VudHJ5KCkgLS0gZ290byByZXBlYXQs
IG5vIGJvdW5kDQotIGZpbmRfZ2V0X2VudHJ5KCkgLS0gZ290byByZXNldC9nb3RvIHJldHJ5LCBu
byBib3VuZA0KLSBmaWxlbWFwX2dldF9mb2xpb3NfY29udGlnKCksIGZpbGVtYXBfZ2V0X3JlYWRf
YmF0Y2goKSAtLSBnb3RvIHJldHJ5LA0KICBubyBib3VuZA0KLSBrc21fZ2V0X2ZvbGlvKCkgLS0g
d2hpbGUgKCFmb2xpb190cnlfZ2V0KGZvbGlvKSkgY3B1X3JlbGF4KCkgd2l0aCBhDQogIHN3YXBj
YWNoZS1mbGFnIGVzY2FwZQ0KDQprc20uYyBkb2N1bWVudHMgdGhlIHRyYW5zaWVudCBzdGF0ZSBl
eHBsaWNpdGx5ICgiaG93ZXZlciwgaXQgbWlnaHQNCm1lYW4gdGhhdCB0aGUgcGFnZSBpcyB1bmRl
ciBwYWdlX3JlZl9mcmVlemUoKS4uLiIpLCB3aGljaCBzdWdnZXN0cyB0aGUNCmZyb3plbi1idXQt
dmlzaWJsZSB3aW5kb3cgaXMgYSBrbm93biBzdGF0ZSBvZiB0aGUgZGVzaWduIC0tIHRoZSBmaWxl
bWFwDQpsb29wcyBzaW1wbHkgaGF2ZSBubyBib3VuZCBvbiBpdC4NCg0KNC4gRml4IGRpcmVjdGlv
bnMgd2UgaGF2ZSBjb25zaWRlcmVkDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0NCg0KNC4xIERpcmVjdGlvbiBBICh3cml0ZXIgc2lkZSk6IHJlc3RvcmUgbm9uLVJUIGF0b21p
Y2l0eSBvZiB0aGUgd2luZG93DQoNClRoZSBpZGVhOiBvbiBQUkVFTVBUX1JULCB3cmFwIHRoZSBm
cmVlemUgLT4geGFycmF5LXJlbW92YWwgaW50ZXJ2YWwgaW4NCnByZWVtcHRfZGlzYWJsZSgpL3By
ZWVtcHRfZW5hYmxlKCksIGtlZXBpbmcgdGhlIGxvY2sgYWNxdWlzaXRpb24NCml0c2VsZiBSVC1z
ZW1hbnRpYyAoaXQgbWF5IHNsZWVwIHdoaWxlIHdhaXRpbmcpLiBSZWFkZXJzIHN0YXkgdW50b3Vj
aGVkDQphbmQgInJlZmNvdW50ID09IDAgaXMgdHJhbnNpZW50IiBob2xkcyBhZ2FpbiwgZm9yIGV2
ZXJ5IHJlYWRlci4NCg0KQnkgaW5zcGVjdGlvbiB0aGlzIHdvcmtzIGZvciBfX2ZvbGlvX21pZ3Jh
dGVfbWFwcGluZygpLiBJdHMgd2luZG93LA0KZnJvbSB0aGUgZnJlZXplIHRvIHRoZSB4YXNfc3Rv
cmUoKSBvZiB0aGUgbmV3IGZvbGlvLCBjb250YWlucyBub3RoaW5nDQp0aGF0IHNsZWVwcyBvbiBS
VDogdGhhdCB4YXNfc3RvcmUoKSBjYWxsIGlzIG5vdCB3cmFwcGVkIGJ5DQptYXBwaW5nX3NldF91
cGRhdGUoKSwgc28gbm8gdXBkYXRlIGhvb2sgZmlyZXMuDQoNCkl0IGRvZXMgbm90IHdvcmsgZm9y
IF9fcmVtb3ZlX21hcHBpbmcoKSwgdGhlIHNpdGUgd2UgaGl0LiBUaGUNCnJlbW92YWwgaXRzZWxm
IHRha2VzIGEgc3BpbmxvY2tfdCB3aGVuZXZlciBzaGFkb3ctbm9kZSB0cmFja2luZyBjaGFuZ2Vz
Og0KDQogICAgICAgX19maWxlbWFwX3JlbW92ZV9mb2xpbygpDQogICAgICAgICBwYWdlX2NhY2hl
X2RlbGV0ZSgpDQogICAgICAgICAgIG1hcHBpbmdfc2V0X3VwZGF0ZSgpICAgLyogeGFfdXBkYXRl
ID0gd29ya2luZ3NldF91cGRhdGVfbm9kZSAqLw0KICAgICAgICAgICB4YXNfc3RvcmUoJnhhcywg
c2hhZG93KQ0KICAgICAgICAgICAgIHVwZGF0ZV9ub2RlKCkNCiAgICAgICAgICAgICAgIHhhc191
cGRhdGUoKQ0KICAgICAgICAgICAgICAgICB3b3JraW5nc2V0X3VwZGF0ZV9ub2RlKCkNCiAgICAg
ICAgICAgICAgICAgICBsaXN0X2xydV9hZGRfb2JqKCkgLyBsaXN0X2xydV9kZWxfb2JqKCkNCiAg
ICAgICAgICAgICAgICAgICAgIHNwaW5fbG9jaygmbmxydS0+bG9jaykgICAgLyogc3BpbmxvY2tf
dCAqLw0KDQpfX2RlbGV0ZV9mcm9tX3N3YXBfY2FjaGUoKSBpbnN0YWxscyB0aGUgc2FtZSBob29r
LCBzbyB0aGUgc3dhcGNhY2hlDQpicmFuY2ggaXMgYWZmZWN0ZWQgYXMgd2VsbC4gVGhpcyBoYXBw
ZW5zIHdoZW5ldmVyIGFuIHhhX25vZGUgYmVjb21lcw0Kc2hhZG93LW9ubHkgb3Igc3RvcHMgYmVp
bmcgc28sIHdoaWNoIGlzIHJvdXRpbmUgd2hlbiByZWNsYWltIGV2aWN0cyBhDQpydW4gb2YgZmls
ZSBwYWdlcy4gc2hhZG93X25vZGVzIGlzIGEgc2luZ2xlIGxpc3RfbHJ1IHdob3NlIHBlci1ub2Rl
DQpsb2NrIGlzIHNoYXJlZCBieSBhbGwgbWFwcGluZ3MgYW5kIGJ5IHRoZSBzaGFkb3ctbm9kZSBz
aHJpbmtlciwgc28gaXQNCmNhbiBiZSBjb250ZW5kZWQuIFVubGlrZSB0aGUgb3RoZXIgc2xlZXBp
bmcgY2FsbCB3ZSBmb3VuZCwgaXQgY2Fubm90IGJlDQptb3ZlZCBvdXQgb2YgdGhlIHdpbmRvdzog
aXQgaXMgdGFrZW4gZnJvbSBpbnNpZGUgdGhlIHZlcnkgeGFzX3N0b3JlKCkNCnRoZSB3aW5kb3cg
ZXhpc3RzIHRvIGNvdmVyLg0KDQooVGhlIG90aGVyIHNsZWVwaW5nIGNhbGwgaW4gdGhpcyBmdW5j
dGlvbiwgbWVtX2Nncm91cF9zd2Fwb3V0KCkgaW4gdGhlDQpzd2FwY2FjaGUgYnJhbmNoLCBjb3Vs
ZCBiZSBtb3ZlZDogd2l0aCBtZW1zdyBhY2NvdW50aW5nIGl0IHRha2VzDQpzd2FwX2Nncm91cCdz
IGN0cmwtPmxvY2sgaW4gc3dhcF9jZ3JvdXBfcmVjb3JkKCkuIEl0IHdvdWxkIGhhdmUgdG8NCnN0
YXkgdW5kZXIgdGhlIHhhcnJheSBsb2NrIHRob3VnaCwgYmVjYXVzZSBtZW1jZzFfc3dhcG91dCgp
IHJlbGllcyBvbg0KaW50ZXJydXB0cyBiZWluZyBkaXNhYmxlZCBieSBpdCBvbiBub24tUlQuKQ0K
DQpNYWtpbmcgZGlyZWN0aW9uIEEgd29yayBmb3IgcmVjbGFpbSB3b3VsZCBuZWVkIHRoZSBzaGFk
b3ctbm9kZSBsaXN0X2xydQ0KdXBkYXRlIHRvIGJlIGRlY291cGxlZCBmcm9tIHhhc19zdG9yZSgp
LCBmb3IgZXhhbXBsZSBkZWZlcnJlZCB1bnRpbA0KYWZ0ZXIgeGFfdW5sb2NrX2lycSgpLiBUaGF0
IGlzIGFuIHhhcnJheS93b3JraW5nc2V0IGNoYW5nZSBhZmZlY3RpbmcNCmV2ZXJ5IHBhZ2UgY2Fj
aGUgYW5kIHN3YXAgY2FjaGUgZGVsZXRpb24sIHdoaWNoIHdlIGRvIG5vdCB3YW50IHRvDQphdHRl
bXB0IHdpdGhvdXQgZ3VpZGFuY2UuDQoNCjQuMiBEaXJlY3Rpb24gQiAocmVhZGVyIHNpZGUpOiBi
b3VuZGVkIHJldHJ5ICsgYmxvY2tpbmcgZmFsbGJhY2sNCg0KRXZlcnkgZnJlZXplciBsaXN0ZWQg
aW4gc2VjdGlvbiAzIChCbGFzdCByYWRpdXMpIGhvbGRzIHRoZSB4YXJyYXkgbG9jayB1bnRpbCB0
aGUgZm9saW8NCmlzIG5vIGxvbmdlciBmcm96ZW4tYW5kLXZpc2libGUuIFNvIGEgcmVhZGVyIHRo
YXQga2VlcHMgZmFpbGluZyBjYW4NCnNpbXBseSB3YWl0IGZvciB0aGF0IGxvY2s6IG9uIFBSRUVN
UFRfUlQgaXQgc2xlZXBzIG9uIHRoZSBydF9tdXRleCwNCmdpdmVzIHRoZSBDUFUgYmFjaywgYW5k
IHByaW9yaXR5IGluaGVyaXRhbmNlIGJvb3N0cyB0aGUgaG9sZGVyLiBPbmNlIHRoZQ0KbG9jayBo
YXMgYmVlbiBhY3F1aXJlZCB0aGUgd2luZG93IGlzIGNsb3NlZCwgYW5kIHRoZSByZXRyeSBzZWVz
IHRoZQ0KZmluYWwgc3RhdGUgb2YgdGhlIHNsb3QuDQoNClRoaXMgaXMgdGhlIHNhbWUgZmFsbGJh
Y2sgY29tbWl0IDBmODgyMWRhNDg0NSB1c2VzIGluDQptbnRfZ2V0X3dyaXRlX2FjY2VzcygpIChm
cy9uYW1lc3BhY2UuYyk6IG9uIFBSRUVNUFRfUlQgdGhlIHNwaW5uZXIgb24NCk1OVF9XUklURV9I
T0xEIHN0b3BzIHNwaW5uaW5nIGFuZCB0YWtlcyB0aGUgd3JpdGVyJ3MgbG9jayBpbnN0ZWFkLA0K
c3BlY2lmaWNhbGx5IHRvIGF2b2lkIHRoaXMgbGl2ZWxvY2suDQoNClRoZSBjaGFuZ2Ugd291bGQg
YmUgc21hbGwgKG1tL2ZpbGVtYXAuYyBvbmx5LCB3ZSBlc3RpbWF0ZSBhYm91dCA4MCBsaW5lcyk6
DQoNCi0gQXBwbGllcyB0byB0aGUgZm91ciBmaWxlbWFwIGxvb3BzIGxpc3RlZCBpbiBzZWN0aW9u
IDMgKEJsYXN0IHJhZGl1cykuDQotIENvdW50cyBmYWlsZWQgYXR0ZW1wdHM7IGV2ZXJ5IDY0IG9m
IHRoZW0gdGhlIHJlYWRlciBjYWxscw0KICByY3VfcmVhZF91bmxvY2soKSwgdGhlbiB4YXNfbG9j
a19pcnEoKSArIHhhc191bmxvY2tfaXJxKCksIHRoZW4NCiAgcmN1X3JlYWRfbG9jaygpLCByZXNl
dHMgdGhlIHhhX3N0YXRlIGFuZCByZXRyaWVzIHRoZSBzYW1lIGluZGV4Lg0KICBOb3RoaW5nIGlz
IHNraXBwZWQgYW5kIG5vdGhpbmcgaXMgcmV0dXJuZWQgZWFybHksIHNvIHNlbWFudGljcyBkbyBu
b3QNCiAgY2hhbmdlOiBjYWxsZXJzIHN1Y2ggYXMgdHJ1bmNhdGlvbiBzdGlsbCBzZWUgZXZlcnkg
ZW50cnkuDQotIE9ubHkgb24gUFJFRU1QVF9SVDogdGhlIGNoZWNrIGNvbXBpbGVzIGF3YXkgb3Ro
ZXJ3aXNlLCBzbyBub24tUlQNCiAgYmVoYXZpb3IgaXMgaWRlbnRpY2FsLg0KLSBPbmx5IHdoZW4g
cHJlZW1wdGlibGUoKTogY2FsbGVycyB0aGF0IGNhbm5vdCBzbGVlcCwgc3VjaCBhcyBzb21lDQog
IEJQRi9wZXJmIHBhdGhzIHJlYWNoaW5nIGJ1aWxkX2lkX3BhcnNlX25vZmF1bHQoKSwga2VlcCBy
ZXRyeWluZyBhcw0KICBiZWZvcmUuIEFuIG91dGVyIHJjdV9yZWFkX2xvY2soKSBkb2VzIG5vdCBu
ZWVkIHNwZWNpYWwgaGFuZGxpbmc6DQogIFBSRUVNUFRfUlQgdXNlcyBwcmVlbXB0aWJsZSBSQ1Us
IHdoaWNoIGFsbG93cyBibG9ja2luZyBpbiBhDQogIHJlYWQtc2lkZSBzZWN0aW9uIChhdCB0aGUg
Y29zdCBvZiBhIGxvbmdlciBncmFjZSBwZXJpb2QpLg0KDQpXZSBoYXZlIG5vdCBwcm90b3R5cGVk
IG9yIHRlc3RlZCB0aGlzIHlldDsgdGhlIHNrZXRjaCBpcyBoZXJlIHNvIHRoZQ0KdHJhZGUtb2Zm
IGNhbiBiZSBqdWRnZWQgYmVmb3JlIHdlIGludmVzdCBpbiBhIHBhdGNoIHNlcmllcy4NCg0KLSBQ
cm9zOiBjb3ZlcnMgdGhlIHJlY2xhaW0gc2l0ZSB0aGF0IGRpcmVjdGlvbiBBIGNhbm5vdDsgY292
ZXJzIGV2ZXJ5DQogIGZyZWV6ZXIgdGhhdCBmb2xsb3dzIHRoZSAiaG9sZCB0aGUgeGFycmF5IGxv
Y2siIHJ1bGUsIGluY2x1ZGluZyBvbmVzDQogIGFkZGVkIGxhdGVyOyBhZGRzIG5vIG5vbi1wcmVl
bXB0aWJsZSB3aW5kb3cuDQotIENvbnM6IHRoZSBsb29rdXBzIGNhbiBub3cgc2xlZXAgb24gUFJF
RU1QVF9SVCBpbiBwcmVlbXB0aWJsZSBjb250ZXh0LA0KICBhbmQgd2UgaGF2ZSBub3QgYXVkaXRl
ZCBhbGwgb2YgdGhlaXIgY2FsbGVycy4gVHdvIHRoaW5ncyBuZWVkIGNoZWNraW5nOg0KICB0aGF0
IG5vIGNhbGxlciBob2xkcyBhIGxvY2sgd2hpY2ggaXMgdGFrZW4gaW5zaWRlIHRoZSB4YXJyYXkg
bG9jaw0KICAod2Ugc3BvdC1jaGVja2VkIGxpc3RfbHJ1IHdhbGtlcnMgYW5kIGZvdW5kIG5vIHN1
Y2ggY2FsbGVyLCBidXQgdGhpcw0KICB3YXMgbm90IGV4aGF1c3RpdmUpLCBhbmQgdGhhdCBldmVy
eSBjYWxsZXIga2VlcHMgdGhlIG1hcHBpbmcgYWxpdmUNCiAgYWNyb3NzIHRoZSByY3VfcmVhZF91
bmxvY2soKSwgbm90IGp1c3QgYnkgUkNVLg0KLSBOb3QgY292ZXJlZDogY2FsbGVycyB0aGF0IGNh
bm5vdCBzbGVlcCBjYW4gc3RpbGwgc3BpbiwgYW5kIHNvIGNhbg0KICBrc21fZ2V0X2ZvbGlvKCks
IHdoaWNoIGhhcyBubyBtYXBwaW5nIGF0IGhhbmQgdG8gd2FpdCBvbi4gS1NNIGlzDQogIGRpc2Fi
bGVkIG9uIG91ciBzeXN0ZW0sIHNvIHdlIGRpZCBub3QgbG9vayBmdXJ0aGVyIGludG8gaXQuDQoN
Ck91ciBjdXJyZW50IHZpZXcgaXMgdGhhdCBCIGFkZHJlc3NlcyB0aGUgcGF0aCB3ZSBoaXQsIHdo
aWxlIEEsIGF0IGJlc3QsDQpuYXJyb3dzIHRoZSBwcm9ibGVtIHRvIHRoZSBtaWdyYXRlIHBhdGgg
LS0gYnV0IHdlIG1heSBiZSBtaXNzaW5nIGENCnJlYXNvbiB3aHkgdXBzdHJlYW0gd291bGQgcmF0
aGVyIHJlc3RydWN0dXJlIHRoZSB3cml0ZXIgc2lkZS4NCg0KNS4gUXVlc3Rpb25zDQotLS0tLS0t
LS0tLS0NCg0KMS4gSXMgdGhlICJyZWZjb3VudCA9PSAwIGlzIHRyYW5zaWVudCIgYXNzdW1wdGlv
biBvZiB0aGUgbG9ja2xlc3MNCiAgIGxvb2t1cCBwYXRoIGRvY3VtZW50ZWQgYXMgZGVwZW5kaW5n
IG9uIHRoZSBmcmVlemUgLT4gcmVtb3ZhbCB3aW5kb3cNCiAgIGJlaW5nIG5vbi1wcmVlbXB0aWJs
ZT8gSWYgc28sIFBSRUVNUFRfUlQgYnJlYWtpbmcgaXQgaXMgYXJndWFibHkgYW4NCiAgIFJULXNp
ZGUgaW52YXJpYW50IGJyZWFrOyBpZiBub3QsIHNob3VsZCB0aGUgbG9va3VwIGxvb3BzIGdyb3cg
YQ0KICAgYm91bmQ/DQoyLiBHaXZlbiB0aGF0IHRoZSByZWNsYWltIHNpdGUgY2Fubm90IGJlIG1h
ZGUgbm9uLXByZWVtcHRpYmxlIGFzIGxvbmcgYXMNCiAgIHdvcmtpbmdzZXRfdXBkYXRlX25vZGUo
KSB0YWtlcyB0aGUgbGlzdF9scnUgc3BpbmxvY2tfdCBmcm9tIGluc2lkZQ0KICAgeGFzX3N0b3Jl
KCk6IGlzIGEgcmVhZGVyLXNpZGUgZmFsbGJhY2sgbGlrZSBkaXJlY3Rpb24gQiBhY2NlcHRhYmxl
LA0KICAgb3Igd291bGQgdXBzdHJlYW0gcmF0aGVyIGRlY291cGxlIHRoZSBzaGFkb3ctbm9kZSBM
UlUgdXBkYXRlIGZyb20NCiAgIHhhc19zdG9yZSgpIGFuZCB0aGVuIGZpeCB0aGUgd3JpdGVycz8N
CjMuIEZvciBkaXJlY3Rpb24gQjogaXMgaXQgYWNjZXB0YWJsZSB0aGF0IHRoZXNlIGxvb2t1cHMg
bWF5IHNsZWVwIG9uDQogICB0aGUgeGFycmF5IGxvY2sgb24gUFJFRU1QVF9SVCwgaW4gcHJlZW1w
dGlibGUgY29udGV4dCBvbmx5ICh0aGUNCiAgIHNhbWUgZmFsbGJhY2sgY29tbWl0IDBmODgyMWRh
NDg0NSB1c2VzIGluIG1udF9nZXRfd3JpdGVfYWNjZXNzKCkpPw0KICAgSXMNCiAgICJldmVyeSBm
cmVlemVyIGhvbGRzIHRoZSB4YXJyYXkgbG9jayB1bnRpbCB0aGUgZm9saW8gaXMgbm8gbG9uZ2Vy
DQogICBmcm96ZW4tYW5kLXZpc2libGUiIGFuIGludmFyaWFudCB3ZSBtYXkgcmVseSBvbiwgYW5k
IHNob3VsZCBpdCBiZQ0KICAgZG9jdW1lbnRlZCBuZXh0IHRvIHRoZSBsb2NrbGVzcyBwYWdlIGNh
Y2hlIHByb3RvY29sIGNvbW1lbnQ/DQo0LiBBcmUgdGhlcmUgb3RoZXIgZnJlZXplIHNpdGVzIHdl
IGhhdmUgbWlzc2VkPw0KNS4gV291bGQgYSBXQVJOX09OX09OQ0UoKSBvbiBleGNlc3NpdmUgcmV0
cnkgYmUgYWNjZXB0YWJsZSBhcyBhDQogICBkaWFnbm9zdGljLCBpbmRlcGVuZGVudCBvZiB0aGUg
Y2hvc2VuIGZpeD8NCg0KNi4gUmVwcm9kdWNlciBza2V0Y2gNCi0tLS0tLS0tLS0tLS0tLS0tLS0t
DQoNCjEuIFBpbiBhIFNDSEVEX0ZJRk8gOTkgdGFzayB0byBDUFUgWDsgaGF2ZSBpdCByZXBlYXRl
ZGx5IHBhZ2UtZmF1bHQgb24NCiAgIGZpbGUtYmFja2VkIGNvZGUgcGFnZXMgb2YgYSBzaGFyZWQg
bGlicmFyeSB1bmRlciByZWNsYWltIHByZXNzdXJlLg0KMi4gRHJpdmUgcmVjbGFpbSAobWVtb3J5
IHByZXNzdXJlIGlzIGVub3VnaDsgZGlyZWN0IHJlY2xhaW0gd29ya3MgdG9vKQ0KICAgc28gYSB0
YXNrIHJ1bnMgX19yZW1vdmVfbWFwcGluZygpIGZvciBvbmUgb2YgdGhvc2UgcGFnZXMgb24gQ1BV
IFguDQozLiBUaGUgRklGTyB0YXNrIHByZWVtcHRzIHRoZSBob2xkZXIgaW5zaWRlIHRoZSBmcmVl
emUgLT4gcmVtb3ZhbCB3aW5kb3cNCiAgIGFuZCBmYXVsdHMgb24gdGhlIGZyb3plbiBwYWdlIC0+
IHNwaW4uDQo0LiBUd28gbW9yZSBGSUZPIDk5IHRocmVhZHMgb2YgdGhlIHNhbWUgcHJvY2VzcyBm
YXVsdCBvbiBvdGhlciBwYWdlcyBvZg0KICAgdGhlIHNhbWUgbWFwcGluZyB0byBibG9jayBvbiB0
aGUgeGFycmF5IGxvY2sgYW5kIHRyaWdnZXIgUEkuDQoNCkFub255bWl6ZWQgZXZpZGVuY2UgKHJl
Z2lzdGVyIHNhbXBsaW5nLCBzdGFjayB0cmFjZXMgb2YgdGhlIHRocmVlIFJUDQp0aHJlYWRzIGFu
ZCBrc3dhcGQsIGRlY29kZWQgc3RydWN0dXJlIGR1bXBzKSBpcyBhdmFpbGFibGUgb24gcmVxdWVz
dC4NCklmIGRpcmVjdGlvbiBCIGlzIHRoZSBwcmVmZXJyZWQgb25lLCB3ZSB3aWxsIHR1cm4gdGhl
IHNrZXRjaCBhYm92ZSBpbnRvDQphIHBhdGNoIHNlcmllcyBhbmQgc2VuZCBpdCBmb3IgcmV2aWV3
Lg0KDQpCZXN0IHJlZ2FyZHMsDQpEb25naHVpDQojLyoqKioqKrG+08q8/rywxuS4vbz+uqzT0NCh
w9e5q8u+tcSxo8Pc0MXPoqOsvfbP3tPat6LLzbj4yc/D5rXY1rfW0MHQs/a1xLj2yMu78si61+mh
o7371rnIzrrOxuTL+8jL0tTIzrrO0M7Kvcq508OjqLD8wKi1q7K7z97T2sirsr+78rK/t9a12NC5
wrahori01sahorvyyaK3oqOpsb7Tyrz+1tC1xNDFz6Kho8jnufvE+rTtytXBy7G+08q8/qOsx+vE
+sGivLS157uwu/LTyrz+zajWqreivP7Iy7Kiyb6z/bG+08q8/qOhIFRoaXMgZS1tYWlsIGFuZCBp
dHMgYXR0YWNobWVudHMgY29udGFpbiBjb25maWRlbnRpYWwgaW5mb3JtYXRpb24gZnJvbSBYSUFP
TUksIHdoaWNoIGlzIGludGVuZGVkIG9ubHkgZm9yIHRoZSBwZXJzb24gb3IgZW50aXR5IHdob3Nl
IGFkZHJlc3MgaXMgbGlzdGVkIGFib3ZlLiBBbnkgdXNlIG9mIHRoZSBpbmZvcm1hdGlvbiBjb250
YWluZWQgaGVyZWluIGluIGFueSB3YXkgKGluY2x1ZGluZywgYnV0IG5vdCBsaW1pdGVkIHRvLCB0
b3RhbCBvciBwYXJ0aWFsIGRpc2Nsb3N1cmUsIHJlcHJvZHVjdGlvbiwgb3IgZGlzc2VtaW5hdGlv
bikgYnkgcGVyc29ucyBvdGhlciB0aGFuIHRoZSBpbnRlbmRlZCByZWNpcGllbnQocykgaXMgcHJv
aGliaXRlZC4gSWYgeW91IHJlY2VpdmUgdGhpcyBlLW1haWwgaW4gZXJyb3IsIHBsZWFzZSBub3Rp
ZnkgdGhlIHNlbmRlciBieSBwaG9uZSBvciBlbWFpbCBpbW1lZGlhdGVseSBhbmQgZGVsZXRlIGl0
ISoqKioqKi8jDQo=

--_000_c2ff0c66422c4e2d869499a1186ff0aexiaomicom_
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
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:=B5=C8=CF=DF;
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
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:=B5=C8=CF=DF;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:=B5=C8=CF=DF;}
/* Page Definitions */
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
<p class=3D"MsoNormal"><span lang=3D"EN-US">Hello,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">We hit a permanent livelock on =
a PREEMPT_RT system and traced it to an<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">interaction between the lockles=
s page cache lookup retry loop in<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">filemap_get_entry() and the fol=
io freeze -&gt; xarray removal window in<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">__remove_mapping() (and the mig=
rate equivalents). On non-RT that window<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">is atomic (IRQs disabled) and t=
herefore bounded; on PREEMPT_RT it is<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">preemptible and can become unbo=
unded, which turns the &quot;refcount =3D=3D 0 is<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">transient&quot; assumption of t=
he lookup path into a permanent spin.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The affected code is vanilla up=
stream (our mm/filemap.c, mm/vmscan.c<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">and mm/migrate.c match 6.12 exa=
ctly); nothing vendor-specific is<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">involved.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The obvious fix -- making the w=
indow non-preemptible on RT -- does not<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">work for the reclaim path, whic=
h is the one we hit (section 4.1). We are<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">deliberately not sending a patc=
h yet: we would like to hear which<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">fix direction upstream prefers =
before going further.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">1. Symptom<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US">----------<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- 6.12.73-rt15 (PREEMPT_RT), ar=
m64, 20 CPUs.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- A SCHED_FIFO 99 userspace wor=
kload was page-faulting on file-backed<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; code pages of a shared l=
ibrary (libc.so.6 in our case) while the system<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; was under memory pressur=
e.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- One CPU reported rcu_preempt =
self-detected stall every ~63 s from then<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; on: 670&#43; reports ove=
r the ~12 hours covered by our captured logs.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- The next day, and again about=
 two days after the first stall, we<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; inspected the machine ov=
er JTAG. It was still stuck, with the same<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; register values as in th=
e first reports. It never recovered on its<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; own; only a reboot broug=
ht it back.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- On that CPU the running task =
was spinning in filemap_get_entry() on a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; folio whose _refcount wa=
s 0 (frozen) while the folio was still<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; reachable from the mappi=
ng's xarray.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- kswapd0 was found preempted i=
nside __remove_mapping(), its stack<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; ending in __filemap_remo=
ve_folio() -&gt; filemap_unaccount_folio() -&gt;<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; ... -&gt; preempt_schedu=
le(): the folio was already frozen (refcount 0,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; off-LRU, unmapped) but n=
ot yet removed from the xarray, and the task<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; still held the xarray lo=
ck.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">All 670 stall reports show the =
same task and the same folio. Their PC<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">samples fall inside this retry =
loop, mostly in xas_load(); the path<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">taken after a successful refcou=
nt increment was never sampled. A<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">second, non-RT process later hu=
ng in the same loop on the same folio,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">showing that once such an entry=
 exists, every reader of that page is a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">victim.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2. Root cause<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">-------------<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2.1 Reader: unbounded retry on =
refcount =3D=3D 0<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">/* mm/filemap.c, filemap_get_en=
try() */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; rcu_read_lock();<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">repeat:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; xas_reset(&amp;xas);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; folio =3D xas_load(&amp;xas);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (xas_retry(&amp;xas, folio))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto repeat;<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; /*<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; * A shadow entry of a recently evicted page, or a swap entry from<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; * shmem/tmpfs.&nbsp; Return it without attempting to raise page count=
.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (!folio || xa_is_value(folio))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto out;<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (!folio_try_get(folio))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto repeat;<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The loop treats refcount =3D=3D=
 0 as a transient state and retries. It never<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">sleeps or yields while doing so=
, and there is no retry bound, no timeout<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">and no warning.<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2.2 Writer: the window is bound=
ed on non-RT<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">/* mm/vmscan.c, __remove_mappin=
g() */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (!folio_test_swapcache(folio))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; spin_lock(&amp;mapping-&gt;=
host-&gt;i_lock);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; xa_lock_irq(&amp;mapping-&gt;i_pages);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; ...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; refcount =3D 1 &#43; folio_nr_pages(folio);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; if (!folio_ref_freeze(folio, refcount))<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; goto cannot_free;<o:p></o:p=
></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; /* note: atomic_cmpxchg in folio_ref_freeze provides the smp_rmb */<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; ...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; __filemap_remove_folio(foli=
o, shadow);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xa_unlock_irq(&amp;mapping-=
&gt;i_pages);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; ...<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">cannot_free:<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; xa_unlock_irq(&amp;mapping-&gt;i_pages);<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Readers on other CPUs can brief=
ly observe the frozen folio even on<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">non-RT -- that is what the retr=
y loop is for. On non-RT, however,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">xa_lock_irq() disables IRQs and=
 preemption, so the interval from<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">folio_ref_freeze() to __filemap=
_remove_folio() cannot be preempted<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">and cannot outlive the locked c=
ode path: the window is bounded, and<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">the retry terminates after a fe=
w iterations.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2.3 On PREEMPT_RT the window is=
 unbounded -- this is the break<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">On PREEMPT_RT xa_lock_irq() map=
s to rt_spin_lock(): an rt_mutex<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">plus migrate_disable() and rcu_=
read_lock(). It does not disable<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">preemption. A task inside the f=
reeze -&gt; removal window can therefore be<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">preempted, and the frozen folio=
 stays visible in the xarray with<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">refcount =3D=3D 0 for as long a=
s the holder is off-CPU -- the window is no<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">longer bounded by the locked co=
de path, but by scheduling.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">migrate_disable() aggravates th=
is: the holder is pinned to the CPU it<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">was preempted on. The holder do=
es not have to be kswapd: the same<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">shrink_folio_list() -&gt; __rem=
ove_mapping() path is used by direct<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">reclaim, so any task allocating=
 memory can be the victim.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2.4 How it becomes permanent: p=
riority inversion<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">In our case a SCHED_FIFO 99 tas=
k preempted the holder on the same CPU,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">then faulted on the very page b=
eing removed and entered the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">filemap_get_entry() spin. Two f=
urther SCHED_FIFO 99 threads of the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">same workload blocked on the sa=
me xarray lock; through priority<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">inheritance the holder (kswapd)=
 was boosted into the RT scheduling class<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">at the same effective priority =
as the spinner. SCHED_FIFO does not<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">time-slice among equal prioriti=
es, so a spinner that never blocks never<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">gives the CPU back to the holde=
r.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">This is where self-healing is l=
ost. While the holder remains CFS, the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">RT bandwidth limit (sched_rt_ru=
ntime_us, 950 ms per 1 s period by<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">default) reserves CPU time for =
CFS tasks exactly so that a run-away RT<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">task cannot lock up the machine=
 (see<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Documentation/scheduler/sched-r=
t-group.rst); the holder can still run<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">and close the window. Once PI p=
ulls the holder into the RT class it is<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">throttled together with the spi=
nner and no longer benefits from that<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">reserve. (With sched_rt_runtime=
_us =3D -1 even the CFS escape does not<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">exist.)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The spinner is invisible to PI:=
 it waits on the folio, not on the lock,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">so nothing ever boosts the hold=
er on its behalf.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The four necessary conditions:<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; (a) frozen-but-visible f=
olio -&gt; reader spins<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
where: filemap_get_entry() retry loop<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; (b) window unbounded (ho=
lder preemptible, pinned)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
where: PREEMPT_RT xa_lock_irq() semantics<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; (c) unyielding spinner o=
n the same CPU<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
where: SCHED_FIFO 99 in the retry loop<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; (d) PI removes the holde=
r's CFS bandwidth reserve<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
where: RT waiters on the same xarray lock<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">3. Blast radius<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">---------------<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">We went through every folio_ref=
_freeze()/page_ref_freeze() user in<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">6.12. Two of them can freeze a =
regular file folio and leave it<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">reachable from the page cache x=
array, and on PREEMPT_RT both can be<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">preempted there:<o:p></o:p></sp=
an></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; - mm/vmscan.c, __remove_=
mapping()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
trigger: reclaim -- kswapd or direct reclaim<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; - mm/migrate.c, __folio_=
migrate_mapping()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
trigger: compaction / CMA / hotplug<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Both hold the xarray lock from =
before the freeze until the folio has<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">been removed, or replaced and u=
nfrozen.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The unbounded refcount =3D=3D 0=
 spin exists in several lookup loops, not<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">just filemap_get_entry():<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- filemap_get_entry() -- goto r=
epeat, no bound<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- find_get_entry() -- goto rese=
t/goto retry, no bound<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- filemap_get_folios_contig(), =
filemap_get_read_batch() -- goto retry,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; no bound<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- ksm_get_folio() -- while (!fo=
lio_try_get(folio)) cpu_relax() with a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; swapcache-flag escape<o:=
p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">ksm.c documents the transient s=
tate explicitly (&quot;however, it might<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">mean that the page is under pag=
e_ref_freeze()...&quot;), which suggests the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">frozen-but-visible window is a =
known state of the design -- the filemap<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">loops simply have no bound on i=
t.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">4. Fix directions we have consi=
dered<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">-------------------------------=
-----<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">4.1 Direction A (writer side): =
restore non-RT atomicity of the window<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The idea: on PREEMPT_RT, wrap t=
he freeze -&gt; xarray-removal interval in<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">preempt_disable()/preempt_enabl=
e(), keeping the lock acquisition<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">itself RT-semantic (it may slee=
p while waiting). Readers stay untouched<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">and &quot;refcount =3D=3D 0 is =
transient&quot; holds again, for every reader.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">By inspection this works for __=
folio_migrate_mapping(). Its window,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">from the freeze to the xas_stor=
e() of the new folio, contains nothing<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">that sleeps on RT: that xas_sto=
re() call is not wrapped by<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">mapping_set_update(), so no upd=
ate hook fires.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">It does not work for __remove_m=
apping(), the site we hit. The<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">removal itself takes a spinlock=
_t whenever shadow-node tracking changes:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; __filemap_remove_folio()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp; page_cache_delete()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; mapping_set_update()&nbsp;&nbsp; /* xa_update =3D =
workingset_update_node */<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp; xas_store(&amp;xas, shadow)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; update_node()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xas_update()<o:p></o:p></s=
pan></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; workingset_upd=
ate_node()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; li=
st_lru_add_obj() / list_lru_del_obj()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp; spin_lock(&amp;nlru-&gt;lock)&nbsp;&nbsp;&nbsp; /* spinlock_t */<=
o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">__delete_from_swap_cache() inst=
alls the same hook, so the swapcache<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">branch is affected as well. Thi=
s happens whenever an xa_node becomes<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">shadow-only or stops being so, =
which is routine when reclaim evicts a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">run of file pages. shadow_nodes=
 is a single list_lru whose per-node<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">lock is shared by all mappings =
and by the shadow-node shrinker, so it<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">can be contended. Unlike the ot=
her sleeping call we found, it cannot be<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">moved out of the window: it is =
taken from inside the very xas_store()<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">the window exists to cover.<o:p=
></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">(The other sleeping call in thi=
s function, mem_cgroup_swapout() in the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">swapcache branch, could be move=
d: with memsw accounting it takes<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">swap_cgroup's ctrl-&gt;lock in =
swap_cgroup_record(). It would have to<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">stay under the xarray lock thou=
gh, because memcg1_swapout() relies on<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">interrupts being disabled by it=
 on non-RT.)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Making direction A work for rec=
laim would need the shadow-node list_lru<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">update to be decoupled from xas=
_store(), for example deferred until<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">after xa_unlock_irq(). That is =
an xarray/workingset change affecting<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">every page cache and swap cache=
 deletion, which we do not want to<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">attempt without guidance.<o:p><=
/o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">4.2 Direction B (reader side): =
bounded retry &#43; blocking fallback<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Every freezer listed in section=
 3 (Blast radius) holds the xarray lock until the folio<o:p></o:p></span></=
p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">is no longer frozen-and-visible=
. So a reader that keeps failing can<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">simply wait for that lock: on P=
REEMPT_RT it sleeps on the rt_mutex,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">gives the CPU back, and priorit=
y inheritance boosts the holder. Once the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">lock has been acquired the wind=
ow is closed, and the retry sees the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">final state of the slot.<o:p></=
o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">This is the same fallback commi=
t 0f8821da4845 uses in<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">mnt_get_write_access() (fs/name=
space.c): on PREEMPT_RT the spinner on<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">MNT_WRITE_HOLD stops spinning a=
nd takes the writer's lock instead,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">specifically to avoid this live=
lock.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">The change would be small (mm/f=
ilemap.c only, we estimate about 80 lines):<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Applies to the four filemap l=
oops listed in section 3 (Blast radius).<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Counts failed attempts; every=
 64 of them the reader calls<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; rcu_read_unlock(), then =
xas_lock_irq() &#43; xas_unlock_irq(), then<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; rcu_read_lock(), resets =
the xa_state and retries the same index.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; Nothing is skipped and n=
othing is returned early, so semantics do not<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; change: callers such as =
truncation still see every entry.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Only on PREEMPT_RT: the check=
 compiles away otherwise, so non-RT<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; behavior is identical.<o=
:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Only when preemptible(): call=
ers that cannot sleep, such as some<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; BPF/perf paths reaching =
build_id_parse_nofault(), keep retrying as<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; before. An outer rcu_rea=
d_lock() does not need special handling:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; PREEMPT_RT uses preempti=
ble RCU, which allows blocking in a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; read-side section (at th=
e cost of a longer grace period).<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">We have not prototyped or teste=
d this yet; the sketch is here so the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">trade-off can be judged before =
we invest in a patch series.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Pros: covers the reclaim site=
 that direction A cannot; covers every<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; freezer that follows the=
 &quot;hold the xarray lock&quot; rule, including ones<o:p></o:p></span></p=
>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; added later; adds no non=
-preemptible window.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Cons: the lookups can now sle=
ep on PREEMPT_RT in preemptible context,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; and we have not audited =
all of their callers. Two things need checking:<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; that no caller holds a l=
ock which is taken inside the xarray lock<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; (we spot-checked list_lr=
u walkers and found no such caller, but this<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; was not exhaustive), and=
 that every caller keeps the mapping alive<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; across the rcu_read_unlo=
ck(), not just by RCU.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">- Not covered: callers that can=
not sleep can still spin, and so can<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; ksm_get_folio(), which h=
as no mapping at hand to wait on. KSM is<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp; disabled on our system, =
so we did not look further into it.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Our current view is that B addr=
esses the path we hit, while A, at best,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">narrows the problem to the migr=
ate path -- but we may be missing a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">reason why upstream would rathe=
r restructure the writer side.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">5. Questions<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">------------<o:p></o:p></span><=
/p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">1. Is the &quot;refcount =3D=3D=
 0 is transient&quot; assumption of the lockless<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; lookup path docume=
nted as depending on the freeze -&gt; removal window<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; being non-preempti=
ble? If so, PREEMPT_RT breaking it is arguably an<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; RT-side invariant =
break; if not, should the lookup loops grow a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; bound?<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2. Given that the reclaim site =
cannot be made non-preemptible as long as<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; workingset_update_=
node() takes the list_lru spinlock_t from inside<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; xas_store(): is a =
reader-side fallback like direction B acceptable,<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; or would upstream =
rather decouple the shadow-node LRU update from<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; xas_store() and th=
en fix the writers?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">3. For direction B: is it accep=
table that these lookups may sleep on<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; the xarray lock on=
 PREEMPT_RT, in preemptible context only (the<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; same fallback comm=
it 0f8821da4845 uses in mnt_get_write_access())?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; Is<o:p></o:p></spa=
n></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; &quot;every freeze=
r holds the xarray lock until the folio is no longer<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; frozen-and-visible=
&quot; an invariant we may rely on, and should it be<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; documented next to=
 the lockless page cache protocol comment?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">4. Are there other freeze sites=
 we have missed?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">5. Would a WARN_ON_ONCE() on ex=
cessive retry be acceptable as a<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; diagnostic, indepe=
ndent of the chosen fix?<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">6. Reproducer sketch<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">--------------------<o:p></o:p>=
</span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">1. Pin a SCHED_FIFO 99 task to =
CPU X; have it repeatedly page-fault on<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; file-backed code p=
ages of a shared library under reclaim pressure.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">2. Drive reclaim (memory pressu=
re is enough; direct reclaim works too)<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; so a task runs __r=
emove_mapping() for one of those pages on CPU X.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">3. The FIFO task preempts the h=
older inside the freeze -&gt; removal window<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; and faults on the =
frozen page -&gt; spin.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">4. Two more FIFO 99 threads of =
the same process fault on other pages of<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">&nbsp;&nbsp; the same mapping t=
o block on the xarray lock and trigger PI.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Anonymized evidence (register s=
ampling, stack traces of the three RT<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">threads and kswapd, decoded str=
ucture dumps) is available on request.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">If direction B is the preferred=
 one, we will turn the sketch above into<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">a patch series and send it for =
review.<o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Best regards,<o:p></o:p></span>=
</p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Donghui<o:p></o:p></span></p>
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

--_000_c2ff0c66422c4e2d869499a1186ff0aexiaomicom_--

