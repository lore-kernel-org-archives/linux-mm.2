Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB661C87FC9
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 08:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDA356B007B; Sat,  2 Aug 2025 04:45:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B146B0089; Sat,  2 Aug 2025 04:45:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0C76B008A; Sat,  2 Aug 2025 04:45:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AA3026B007B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 04:45:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42D7F1DD068
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 08:45:09 +0000 (UTC)
X-FDA: 83731182738.17.65832A3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf11.hostedemail.com (Postfix) with ESMTP id A304F4000B
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 08:45:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="J sW2txt";
	spf=pass (imf11.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754124307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQurX7qlpm2RHiXjf3A34wQyMy/544f2GInFbz4FXLo=;
	b=NmuUc9cZZ1gItfhkXiijVd44/EK0GED2gnbk9aexw1nuAcv76e8DeZMklvmqnriYNo++3y
	V/TIKQ9YCyBpBDEaPSLOVI3+6ImXt5h/Ohedvaq3FT/lLX8Hp9+MEI2qlPG8wdndPu9VTP
	Oy/xriSfXXuTlPytyu3upCr9HZxLrPE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=163.com header.s=s110527 header.b="J sW2txt";
	spf=pass (imf11.hostedemail.com: domain of yangshiguang1011@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=yangshiguang1011@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754124307; a=rsa-sha256;
	cv=none;
	b=3CKHZy7H2o4ZakUXTNrjfB9UK2RyLsrenqCuwnDRZ1otE7PPhm1K1f29vxqujIzWGQi1Dt
	wjHoijl2SyOUPlk7rXhijut4/nAyZIHB3olTr+4R+dQCHEZsyCeuopGsFtxM0fEdTT+SNw
	q+okjW6zMlH6vT7+7RrkQ/ifOVikgkk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=NJOAT41SB6X70t/KJZ9koLJ37OoQBjoVAxO6XCBzlyM=; b=J
	sW2txtpkhYqlAVvYa8zsJzjrbUMQjOtuosnf45QY9tcwRYtKVPN8Zl6yEsbROqVO
	gge25p0Z5svj59oZNLukMB5OyXcf8qzUmm9oMqggfEbZv+Pype3xMRNvynvDlpp5
	aFw6LvnWdwn7OWVcMMX8cXs02ITZPuuD88rWOR8uD0=
Received: from yangshiguang1011$163.com (
 [2408:8607:1b00:8:9e7b:efff:fe4e:6d16] ) by ajax-webmail-wmsvr-40-140
 (Coremail) ; Sat, 2 Aug 2025 16:44:54 +0800 (CST)
X-Originating-IP: [2408:8607:1b00:8:9e7b:efff:fe4e:6d16]
Date: Sat, 2 Aug 2025 16:44:54 +0800 (CST)
From: yangshiguang  <yangshiguang1011@163.com>
To: "Harry Yoo" <harry.yoo@oracle.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re:Re: [PATCH] mm:slub:avoid wake up kswapd in set_track_prepare
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.14 build 20250519(9504565a)
 Copyright (c) 2002-2025 www.mailtech.cn 163com
In-Reply-To: <aIyJzh2-0YLydvlB@hyeyoo>
References: <20250801065121.876793-1-yangshiguang1011@163.com>
 <aIyJzh2-0YLydvlB@hyeyoo>
X-NTES-SC: AL_Qu2eBv2Zu0oi4iSZYekfmUkbg+k2X8K1u/Uv2IBTOZx+jB/o1A4FT1lMAH/d1/OOORqqkReYVyV8zt5iWadpT74q4HGuYKerygAoA/WlCw8a8Q==
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <366fbd5f.2240.19869f49914.Coremail.yangshiguang1011@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:jCgvCgDnb5EG0I1opEsRAA--.63399W
X-CM-SenderInfo: 51dqw25klj3ttqjriiqr6rljoofrz/xtbBMQmc5WiMXox4SQANsL
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspam-User: 
X-Rspamd-Queue-Id: A304F4000B
X-Rspamd-Server: rspam06
X-Stat-Signature: qkh1w7f1o73zdfrs4zq4w5a66ii6g6ae
X-HE-Tag: 1754124304-263326
X-HE-Meta: U2FsdGVkX1+wjdqt7b9mx1N5HjT2t+ib5aqnY01sBAKZubwjoQuclYPepUnGMkfZeaUyS1h+IqTRkoflDBjqaPLZcyvuTAhb1Qn6QPNj4IJatL6sGAZLx8Y9xc+cldhVbfMrzpJuK0T4PEuenSaNxARd8zc9FR/H//YClIktM7bbvJaq7BNoaG9H9aPbR1uOddbTTSuA712Ry+j5/xk5EBPi/LEJOg+sbtEzHv1PbHzl1Be0JmBwkzcs0/1+c7QGVgbrRVlMQIdLWGpK19vUGjKdLWaJL6megpRo7cKgm0zAr0i7SftN7PGzSar3zhUucYm6SMKlGah0dv9wgeIiFGGhBFWHFKxsTjlk/LJ3AEcU/sTiSZP6Yb/l4L/ABwCNuB8qz2sM4o88gM42zhZSSa74ojT8ZHsIY4h+o0CsdBtdJE4gDCRHXhKJV6ni0hF7qaUVbpwcnvNsOtvXxhfX/nxRP3VPIb67MvU5YnpST/qdsiiHDYPBiE1z1uXlPRlL/CcqMp/NTaxXASVQaglTGZh3SXJoaPiFa7C3AzKO9xPmRjoCBnjAnbcsrFBJ198gmZUMNnN1bnRGdhdabYCQ0FvOUxHyRJ/BX9VeZeXRrjgUP0uzJUwMge+FSxc6k5n02fb2PdPmJ5D9aCWsvgT1GQzyECg71ohy1wmg6HuwFtHfF85oCmYchAyhfQO2C8Q0gcG0RzQ2589HeWT38sGrRIfhatfUcQOyF7U+wNRZ2D4CcLougfnLusPF4g6Cc9lNBL4LDac4rRSfWzB+FE2lucilrGLYYNcxuxHNcvCPvfLlyujnBMCcdWJ7SiIoebvj70y7UeVnMrLcgre606VV45h4ftl5r86Zuf+cyTQTRfXcQePe/bV8Pe/0nL/ThTR6LOMvX/Wvq3Je4JTPoR92RtLSTKyEzqf8kv1Xg7MlQiPJiu+o0SBd3tefkXUEz8aZQqMISeNXusmbD506BTa
 9Iomt5wu
 RGEyQT1zUGeGTe+2voLX2y6B1UzeNK1BYB6nfM4cLXIUKqNvSLs5Z8OeyYUWhvo00Qt6pwMlj0tUWL1hoVm59ZKlASrR9QsT3IRDn17QjzZP2f+FJZtsGHrC8St4A3QM3+1kpsY12zVgOQUzN5yzm3KZnwX3bNuvsCRuz9JfHPACbMfMtuyGHiUSDWMjINLKTYPBTx3Dawu/YbMO+fASAOBYr0vyvwxTOvjvODuh29ej7MTR9Dh+nmiHBujk+SaLUKjEu91kiILISFPyRHoNuKtPC37sKNy6myxnQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgpBdCAyMDI1LTA4LTAxIDE3OjMzOjMxLCAiSGFycnkgWW9vIiA8aGFycnkueW9vQG9yYWNsZS5j
b20+IHdyb3RlOgo+bml0OiB0aGUgc3ViamVjdCBuZWVkcyBhIHdoaXRlc3BhY2UgYmV0d2VlbiBz
dWJzeXN0ZW1zIGFuZCB0aGUgaGVhZGVyLgo+Im1tOiBzbHViOiBhdm9pZCB3YWtpbmcgdXAga3N3
YXBkIGluIHNldF90cmFja19wcmVwYXJlKCkiPwo+CgpUaGFua3MgZm9yIHRoZSByZW1pbmRlci4K
Cj5PbiBGcmksIEF1ZyAwMSwgMjAyNSBhdCAwMjo1MToyMVBNICswODAwLCB5YW5nc2hpZ3Vhbmcx
MDExQDE2My5jb20gd3JvdGU6Cj4+IEZyb206IHlhbmdzaGlndWFuZyA8eWFuZ3NoaWd1YW5nMTAx
MUAxNjMuY29tPgo+PiAKPj4gc2V0X3RyYWNrX3ByZXBhcmUoKSBjYW4gaW5jdXIgbG9jayByZWN1
cnNpb24uCj4+IFRoZSBpc3N1ZSBpcyB0aGF0IGl0IGlzIGNhbGxlZCBmcm9tIGhydGltZXJfc3Rh
cnRfcmFuZ2VfbnMKPj4gaG9sZGluZyB0aGUgcGVyX2NwdShocnRpbWVyX2Jhc2VzKVtuXS5sb2Nr
LCBidXQgd2hlbiBlbmFibGVkCj4+IENPTkZJR19ERUJVR19PQkpFQ1RTX1RJTUVSUywgbWF5IHdh
a2UgdXAga3N3YXBkIGluIHNldF90cmFja19wcmVwYXJlLAo+PiBhbmQgdHJ5IHRvIGhvbGQgdGhl
IHBlcl9jcHUoaHJ0aW1lcl9iYXNlcylbbl0ubG9jay4KPj4gCj4+IFNvIGF2b2lkIHdha2luZyB1
cCBrc3dhcGQuVGhlIG9vcHMgbG9va3Mgc29tZXRoaW5nIGxpa2U6Cj4+IAo+PiBCVUc6IHNwaW5s
b2NrIHJlY3Vyc2lvbiBvbiBDUFUjMywgc3dhcHBlci8zLzAKPj4gIGxvY2s6IDB4ZmZmZmZmOGE0
YmYyOWM4MCwgLm1hZ2ljOiBkZWFkNGVhZCwgLm93bmVyOiBzd2FwcGVyLzMvMCwgLm93bmVyX2Nw
dTogMwo+PiBIYXJkd2FyZSBuYW1lOiBRdWFsY29tbSBUZWNobm9sb2dpZXMsIEluYy4gUG9wc2lj
bGUgYmFzZWQgb24gU004ODUwIChEVCkKPj4gQ2FsbCB0cmFjZToKPj4gc3Bpbl9idWcrMHgwCj4+
IF9yYXdfc3Bpbl9sb2NrX2lycXNhdmUrMHg4MAo+PiBocnRpbWVyX3RyeV90b19jYW5jZWwrMHg5
NAo+PiB0YXNrX2NvbnRlbmRpbmcrMHgxMGMKPj4gZW5xdWV1ZV9kbF9lbnRpdHkrMHgyYTQKPj4g
ZGxfc2VydmVyX3N0YXJ0KzB4NzQKPj4gZW5xdWV1ZV90YXNrX2ZhaXIrMHg1NjgKPj4gZW5xdWV1
ZV90YXNrKzB4YWMKPj4gZG9fYWN0aXZhdGVfdGFzaysweDE0Ywo+PiB0dHd1X2RvX2FjdGl2YXRl
KzB4Y2MKPj4gdHJ5X3RvX3dha2VfdXArMHg2YzgKPj4gZGVmYXVsdF93YWtlX2Z1bmN0aW9uKzB4
MjAKPj4gYXV0b3JlbW92ZV93YWtlX2Z1bmN0aW9uKzB4MWMKPj4gX193YWtlX3VwKzB4YWMKPj4g
d2FrZXVwX2tzd2FwZCsweDE5Ywo+PiB3YWtlX2FsbF9rc3dhcGRzKzB4NzgKPj4gX19hbGxvY19w
YWdlc19zbG93cGF0aCsweDFhYwo+PiBfX2FsbG9jX3BhZ2VzX25vcHJvZisweDI5OAo+PiBzdGFj
a19kZXBvdF9zYXZlX2ZsYWdzKzB4NmIwCj4+IHN0YWNrX2RlcG90X3NhdmUrMHgxNAo+PiBzZXRf
dHJhY2tfcHJlcGFyZSsweDVjCj4+IF9fX3NsYWJfYWxsb2MrMHhjY2MKPj4gX19rbWFsbG9jX2Nh
Y2hlX25vcHJvZisweDQ3MAo+PiBfX3NldF9wYWdlX293bmVyKzB4MmJjCj4+IHBvc3RfYWxsb2Nf
aG9va1tqdF0rMHgxYjgKPj4gcHJlcF9uZXdfcGFnZSsweDI4Cj4+IGdldF9wYWdlX2Zyb21fZnJl
ZWxpc3QrMHgxZWRjCj4+IF9fYWxsb2NfcGFnZXNfbm9wcm9mKzB4MTNjCj4+IGFsbG9jX3NsYWJf
cGFnZSsweDI0NAo+PiBhbGxvY2F0ZV9zbGFiKzB4N2MKPj4gX19fc2xhYl9hbGxvYysweDhlOAo+
PiBrbWVtX2NhY2hlX2FsbG9jX25vcHJvZisweDQ1MAo+PiBkZWJ1Z19vYmplY3RzX2ZpbGxfcG9v
bCsweDIyYwo+PiBkZWJ1Z19vYmplY3RfYWN0aXZhdGUrMHg0MAo+PiBlbnF1ZXVlX2hydGltZXJb
anRdKzB4ZGMKPj4gaHJ0aW1lcl9zdGFydF9yYW5nZV9ucysweDVmOAo+PiAuLi4KPgo+U28gc29t
ZSBhbGxvY2F0aW9ucyBjYW4ndCBldmVuIHVzZSBfX0dGUF9LU1dBUERfUkVDTEFJTSAoZS5nLiwg
ZWI3OTkyNzlmYjEKPigiZGVidWdvYmplY3RzOiBEb24ndCB3YWtlIHVwIGtzd2FwZCBmcm9tIGZp
bGxfcG9vbCgpIikpIGFuZAo+c3RhY2tfZGVwb3Rfc2F2ZSgpIGRvZXMgbm90IHJlc3BlY3QgdGhh
dC4KPgoKeWVzLHlvdSBhcmUgcmlnaHQuCgo+PiBTaWduZWQtb2ZmLWJ5OiB5YW5nc2hpZ3Vhbmcg
PHlhbmdzaGlndWFuZzEwMTFAMTYzLmNvbT4KPj4gLS0tCj4KPkluIGdlbmVyYWwsCj5SZXZpZXdl
ZC1ieTogSGFycnkgWW9vIDxoYXJyeS55b29Ab3JhY2xlLmNvbT4KPgoKVGhhbmtzLgoKPkxldCdz
IGFkZCBGaXhlczogNWNmOTA5YzU1M2U5ICgibW0vc2x1YjogdXNlIHN0YWNrZGVwb3QgdG8gc2F2
ZSBzdGFjawo+dHJhY2UgaW4gb2JqZWN0cyIpIGFuZCBwb3RlbnRpYWxseSBDYzogc3RhYmxlQHZn
ZXIua2VybmVsLm9yZyB0b28/Cj4oSXQncyBoYXJkIHRvIGltYWdpbmUgdXNlIGJvdGggY29uZmln
cyBpbiBwcm9kdWN0aW9uLCB0aG91Z2gpCj4KT2ssaXQgaXMgbmVjZXNzYXJ5Lgo+PiAgbW0vc2x1
Yi5jIHwgMiArLQo+PiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pCj4+IAo+PiBkaWZmIC0tZ2l0IGEvbW0vc2x1Yi5jIGIvbW0vc2x1Yi5jCj4+IGluZGV4IGNm
N2M2MDMyZDVmZC4uMTRlM2JhYzBjNmFkIDEwMDY0NAo+PiAtLS0gYS9tbS9zbHViLmMKPj4gKysr
IGIvbW0vc2x1Yi5jCj4+IEBAIC05NjksNyArOTY5LDcgQEAgc3RhdGljIG5vaW5saW5lIGRlcG90
X3N0YWNrX2hhbmRsZV90IHNldF90cmFja19wcmVwYXJlKHZvaWQpCj4+ICAJdW5zaWduZWQgaW50
IG5yX2VudHJpZXM7Cj4+ICAKPj4gIAlucl9lbnRyaWVzID0gc3RhY2tfdHJhY2Vfc2F2ZShlbnRy
aWVzLCBBUlJBWV9TSVpFKGVudHJpZXMpLCAzKTsKPj4gLQloYW5kbGUgPSBzdGFja19kZXBvdF9z
YXZlKGVudHJpZXMsIG5yX2VudHJpZXMsIEdGUF9OT1dBSVQpOwo+PiArCWhhbmRsZSA9IHN0YWNr
X2RlcG90X3NhdmUoZW50cmllcywgbnJfZW50cmllcywgX19HRlBfTk9XQVJOKTsKPgo+SW4gdGhl
IGZ1dHVyZSwgcGVyaGFwcyBpdCBtaWdodCBiZSBiZXR0ZXIgdG8gcHJvcGFnYXRlIGdmcCBmbGFn
cyB0bwo+c2V0X3RyYWNrX3ByZXBhcmUoKSBhbmQgcGFzcyBpdCB0byBzdGFja19kZXBvdF9zYXZl
KCk/IFRoYXQncyB3aGF0IEtBU0FOCj5kb2VzLgo+CgpUaGFua3MgZm9yIHlvdXIgYWR2aWNlLlRo
aXMgbWlnaHQgYmUgYSBnb29kIGlkZWEuCklmIG9ubHkgQ09ORklHX0RFQlVHX09CSkVDVFNfVElN
RVJTIGlzIGVuYWJsZWQsIHRoZXJlIGlzIGEKcmlzayBvZiByZWN1cnNpdmUgbG9jay4gQ2FuIF9f
R0ZQX0tTV0FQRF9SRUNMQUlNIGJlIHJlbW92ZWQKaW4gdGhpcyBjYXNlPyBKdXN0IGxpa2U6Cgpk
aWZmIC0tZ2l0IGEvbW0vc2x1Yi5jIGIvbW0vc2x1Yi5jCmluZGV4IGNmN2M2MDMyZDVmZC4uM2Iz
NWI2Y2JkZDQwIDEwMDY0NAotLS0gYS9tbS9zbHViLmMKKysrIGIvbW0vc2x1Yi5jCkBAIC05Njcs
OSArOTY3LDE3IEBAIHN0YXRpYyBub2lubGluZSBkZXBvdF9zdGFja19oYW5kbGVfdCBzZXRfdHJh
Y2tfcHJlcGFyZSh2b2lkKQogICAgICAgIGRlcG90X3N0YWNrX2hhbmRsZV90IGhhbmRsZTsKICAg
ICAgICB1bnNpZ25lZCBsb25nIGVudHJpZXNbVFJBQ0tfQUREUlNfQ09VTlRdOwogICAgICAgIHVu
c2lnbmVkIGludCBucl9lbnRyaWVzOworICAgICAgIGdmcF90IGZsYWdzID0gR0ZQX05PV0FJVDsK
KworI2lmZGVmIENPTkZJR19ERUJVR19PQkpFQ1RTX1RJTUVSUworICAgICAgIC8qCisgICAgICAg
ICogRG9uJ3Qgd2FrZSB1cCBrc3dhcGQsIHRvIGF2b2lkIHBvdGVudGlhbCByZWN1cnNpdmUgbG9j
ay4KKyAgICAgICAgKi8KKyAgICAgICBmbGFncyAmPSB+X19HRlBfS1NXQVBEX1JFQ0xBSU07Cisj
ZW5kaWYKIAogICAgICAgIG5yX2VudHJpZXMgPSBzdGFja190cmFjZV9zYXZlKGVudHJpZXMsIEFS
UkFZX1NJWkUoZW50cmllcyksIDMpOwotICAgICAgIGhhbmRsZSA9IHN0YWNrX2RlcG90X3NhdmUo
ZW50cmllcywgbnJfZW50cmllcywgR0ZQX05PV0FJVCk7CisgICAgICAgaGFuZGxlID0gc3RhY2tf
ZGVwb3Rfc2F2ZShlbnRyaWVzLCBucl9lbnRyaWVzLCBmbGFncyk7CiAKICAgICAgICByZXR1cm4g
aGFuZGxlOwogfQoKV2hhdCBkbyB5b3UgdGhpbmsgb2Y/Cgo+LS0gCj5DaGVlcnMsCj5IYXJyeSAv
IEh5ZW9uZ2dvbgo=

