Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F458D0D152
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 17:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DCAF6B0088; Wed,  7 Jan 2026 12:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 460526B0092; Wed,  7 Jan 2026 12:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35EDA6B0093; Wed,  7 Jan 2026 12:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 206736B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 12:51:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3DB78BA75
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:51:15 +0000 (UTC)
X-FDA: 84305909310.06.6F0D6DB
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A07280012
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:51:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="e 5Ohp77";
	spf=pass (imf30.hostedemail.com: domain of 00107082@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767808273; a=rsa-sha256;
	cv=none;
	b=X6P0uqiX6/Jdj1QS2JeL8vnAvxrSzhINF9PpuVJQ25cg0ls1BPS0xmDKALa6dVfiO6hBf7
	RXfNZXlKqYwOv48hcGK36aoEVqGsbiCFN5RPjGp0gO+wVcvsBzuiMgF7YB0bvhWUJbOkCN
	zvSFaWn7GvI6s0vll2kMPOkisn5+cwc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="e 5Ohp77";
	spf=pass (imf30.hostedemail.com: domain of 00107082@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767808273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTx6Y6SMT4eKNM8piFgTgH02DqI/eVwh+UqE7DLgBw4=;
	b=rQRjwBS2Sg9CNpiQPbOP4iBJFyStICcVClHZfncXKvo5I1/MEUVNJXfxt+1ONtr/sh4tk6
	M/PwvKTWobykj7KcZZlkvBa3XsiBYTNJVrOJYFWogDmD5guJl0zTUKI2ITPd0MsWi2WxCf
	gFQuGT5DYR6c/Y/D2gpxDOgVyXOXeko=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=KTx6Y6SMT4eKNM8piFgTgH02DqI/eVwh+UqE7DLgBw4=; b=e
	5Ohp77DD8IDvx4pnxsBOHKM6WgtGctgjozz9SRMCc+rhUILBcjlPDXspwcsKSXxj
	pc5as9KvfzMI550lg2vrM3TNT5sW6xgTyulg0B1mOWn2IAL/G+/LOpNWiYLuDl0G
	ZjzuU9ctbXCp/B5kLNcgAUoR9M2Q7h7n8yIrsu2NuI=
Received: from 00107082$163.com ( [111.35.191.26] ) by
 ajax-webmail-wmsvr-40-109 (Coremail) ; Thu, 8 Jan 2026 01:50:44 +0800 (CST)
X-Originating-IP: [111.35.191.26]
Date: Thu, 8 Jan 2026 01:50:44 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Kent Overstreet" <kent.overstreet@linux.dev>, malcolm@haak.id.au
Cc: "Suren Baghdasaryan" <surenb@google.com>, akpm@linux-foundation.org,
	hannes@cmpxchg.org, pasha.tatashin@soleen.com,
	souravpanda@google.com, vbabka@suse.cz, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag
 along callchain
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <aV6BnhG9yjX10O27@moria.home.lan>
References: <20251216064349.74501-1-00107082@163.com>
 <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
 <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
 <aVzorksJEyI0wlxh@moria.home.lan>
 <37169c79.a0e5.19b93a2768f.Coremail.00107082@163.com>
 <aV2VWbY4Rb_w-QTs@moria.home.lan>
 <4736b304.38a2.19b96888104.Coremail.00107082@163.com>
 <aV3bykzqkyUcBJBf@moria.home.lan>
 <5b356cfa.4ab3.19b97196d49.Coremail.00107082@163.com>
 <aV6BnhG9yjX10O27@moria.home.lan>
X-NTES-SC: AL_Qu2dBfSbt0ov4iCbZOkZnEYQheY4XMKyuPkg1YJXOp80uyTyxQUKR3hlEVD23fqfBAehmSaeTjpOyOJbdol/Tr8mTQN56fqiVPAbQ+W5vydT
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <70ad6f1e.dba.19b99951948.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:bSgvCgDnb9n1nF5pPQNSAA--.21787W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbCxhVWAWlenPV-OgAA3f
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspamd-Queue-Id: 5A07280012
X-Rspam-User: 
X-Stat-Signature: 4p74sbr6tw19fbmak3ybx1fb9imq91xa
X-Rspamd-Server: rspam07
X-HE-Tag: 1767808271-813480
X-HE-Meta: U2FsdGVkX18pX4HwSOUxyULl2+Mmkfgs3cezTXmhlxlNIdJdGN0EVBMnycbuO2LqXzYpbcbgBvrL3vzX+Z8SRGK3fsqMTvxOb7zovMKZ2OTH7zTdb0PMglw6Lpo3vMMhhp9lvJJO8r6A+KxvgW746+lfzKNUzV/UxuTwUTztQ0xemVHZZgg7e5FbaUAasdB0JbNQZLgaoSiEkzIbcO1ppTWckhGMsNrDbf5DdVTJW4kwrsvDux7/mgPvBETi1ZRX4j7Cp7RboYLrpD2Fm4H1pJSO7uj4xdt9aqHjRBGKK72KWmwb/NfvHiaSPNO4nFth+FN7NjPjaCnLlNiomiuD3ShxaqNiOO4tmz69xARvxgSJhpLvzhOKkGlXiS+gzOCkrjDdULPmqTvyjnBvLLpUT775GJGieSNXcw1CoNKJh8e7WcVZj8e+niLGftT/w7Ap+rv/S6LCckAcbE2jMR132YcrHDax+7CU0IntcUfgVNXr3UQyCtZ8iPyYOROLe/GSXeC2GwER6t3Jm15p6VhTgxyghMUTqFS66L4pl6H8Ovgq16zkg2DRT+fokE1TfA2lq4uaQHMGL+Qiki0+TQI3O9uWONL2Qkk5h9qnmT4t/HoOPNROy3skcpNgyyTWbw6PG+m5vVrOanWpTKL8OZ5jk21XAM0BZKAqZs9osce18eTlsiHxSIvgy33csOL+2pqznFkbDTQP37LyMlCUFVBP8suZaKfhztVGoYGv/KBuSj/bpKF4C+M3XOJWXvFQcpktIuGVx6Ka/4NOFg30LS1z+RvgiCFK1UAgatP6cEicnt/ApNJeLR7H/5K+SeKzJFekidQASL/9iaD9Apu5HZvoAjXTNTtuIG6iRkO4o21j4S7zfDBBvVq1z3UWUm/jHse0wZ2q6i0+cJqBLBTIkIRkF9hd3YmL2UXiRks8/NTrXmYb113posdjqbuPxn/a6QyAPFkNT11WNejVSejOZhQ
 ZcjeirQl
 zSjsZ3xQsi9YxBLv0bxXQ/RM3q/mUKRuaO5hMV3HVg+PSDvr+JazeGmKcskDBU7MngsNdjlsPmUIZeNbLzIFhgfJXn7aTIugWH9ZVauh6F09yUaii/P1u86KA9BeRt0eiGSHVbXt14CW9i3zDEKPRl2/34f9fL1F4x/d97qfqHc3eF0AqfsdSsE84dBWwvhQZ+PxjIYJ/viRrSaPvuyJ5roJWxd9JHUyvUZf+DMFVlmMfzyDTM4WF/Z4L/swDWgdLWXzhgKvbaDu9i5Y520s4XSTlLhH1LWm5WfsRHfeGAIUmtDIZLUKU33eQ3uJHIizx0vThUpjVTFZRIFDGf+xH11emwH2n0bMUQwUuFXWktDxYYMBeLhsABtHnFaodBryyJNSppOuhMSV0F8XbnzSut3SF8gkjJW7UOgyGDiZC3AfewS6qol7RtAz0eHEBwnemoqRPfa3jo1UuP9drMU0Dyr7vyu5/7JdPh/2ouYKPfLD5e4g0ziXLJtiJJU01g53nvf7sbNF6bKeusY8Do1JKBuDXDA4pIXhBGR2LVGMXiFOhVCT9UQcbWOvy79Pjmsjlq6W0reirC0xDimwd8XYQk8iKx8ES6hB4VDvjMzItkOQdyeL65D9w1jHYu7k0vXk5Gf8Ipzsn2KF1MfWKDyl+kX/jWuxj6w+GlHW+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CgpBdCAyMDI2LTAxLTA4IDAwOjEzOjI1LCAiS2VudCBPdmVyc3RyZWV0IiA8a2VudC5vdmVyc3Ry
ZWV0QGxpbnV4LmRldj4gd3JvdGU6Cj5PbiBXZWQsIEphbiAwNywgMjAyNiBhdCAwMjoxNjoyNFBN
ICswODAwLCBEYXZpZCBXYW5nIHdyb3RlOgo+PiAKPj4gQXQgMjAyNi0wMS0wNyAxMjowNzozNCwg
IktlbnQgT3ZlcnN0cmVldCIgPGtlbnQub3ZlcnN0cmVldEBsaW51eC5kZXY+IHdyb3RlOgo+PiA+
SSdtIGN1cmlvdXMgd2h5IHlvdSBuZWVkIHRvIGNoYW5nZSBfX2ZpbGVtYXBfZ2V0X2ZvbGlvKCk/
IEluIGZpbGVzeXN0ZW0KPj4gPmxhbmQgd2UganVzdCBsdW1wIHRoYXQgdW5kZXIgInBhZ2VjYWNo
ZSIsIGJ1dCBJIGd1ZXNzIHlvdSdyZSBkb2luZyBtb3JlCj4+ID5pbnRlcmVzdGluZyB0aGluZ3Mg
d2l0aCBpdCBpbiBkcml2ZXIgbGFuZD8KPj4gCj4+IE9oLCAgaW4gWzFdLCAgIHRoZXJlIGlzIGEg
cmVwb3J0IGFib3V0IHBvc3NpYmxlIG1lbW9yeSBsZWFrIGluIGNlcGhmcywgKFRoZSBpc3N1ZSBp
cyBzdGlsbCBvcGVuLCB0cmFja2VkIGluIFsyXS4pLCAKPj4gbGFyZ2UgdHJ1bmsgb2YgbWVtb3J5
IGNvdWxkIG5vdCBiZSByZWxlYXNlZCBldmVuIGFmdGVyIGRyb3BjYWNoZS4KPj4gbWVtb3J5IGFs
bG9jYXRpb24gcHJvZmlsaW5nIHNob3dzIHRob3NlIG1lbW9yeSBiZWxvbmdzIHRvIF9fZmlsZW1h
cF9nZXRfZm9saW8sCj4+IHNvbWV0aGluZyBsaWtlIAo+PiA+PiA+IyBzb3J0IC1nIC9wcm9jL2Fs
bG9jaW5mb3x0YWlsfG51bWZtdCAtLXRvPWllYwo+PiA+PiA+ICAgICAgICAgMTJNICAgICAyOTg3
IG1tL2V4ZWNtZW0uYzo0MSBmdW5jOmV4ZWNtZW1fdm1hbGxvYyAKPj4gPj4gPiAgICAgICAgIDEy
TSAgICAgICAgMyBrZXJuZWwvZG1hL3Bvb2wuYzo5NiBmdW5jOmF0b21pY19wb29sX2V4cGFuZCAK
Pj4gPj4gPiAgICAgICAgIDEzTSAgICAgIDc1MSBtbS9zbHViLmM6MzA2MSBmdW5jOmFsbG9jX3Ns
YWJfcGFnZSAKPj4gPj4gPiAgICAgICAgIDE2TSAgICAgICAgOCBtbS9raHVnZXBhZ2VkLmM6MTA2
OSBmdW5jOmFsbG9jX2NoYXJnZV9mb2xpbyAKPj4gPj4gPiAgICAgICAgIDE4TSAgICAgNDM1NSBt
bS9tZW1vcnkuYzoxMTkwIGZ1bmM6Zm9saW9fcHJlYWxsb2MgCj4+ID4+ID4gICAgICAgICAyNE0g
ICAgIDYxMTkgbW0vbWVtb3J5LmM6MTE5MiBmdW5jOmZvbGlvX3ByZWFsbG9jIAo+PiA+PiA+ICAg
ICAgICAgNThNICAgIDE0Nzg0IG1tL3BhZ2VfZXh0LmM6MjcxIGZ1bmM6YWxsb2NfcGFnZV9leHQg
Cj4+ID4+ID4gICAgICAgICA2MU0gICAgMTU0NDggbW0vcmVhZGFoZWFkLmM6MTg5IGZ1bmM6cmFj
dGxfYWxsb2NfZm9saW8gCj4+ID4+ID4gICAgICAgICA3OU0gICAgIDY3MjYgbW0vc2x1Yi5jOjMw
NTkgZnVuYzphbGxvY19zbGFiX3BhZ2UgCj4+ID4+ID4gICAgICAgICAxMUcgIDI2NzQ0ODggbW0v
ZmlsZW1hcC5jOjIwMTIgZnVuYzpfX2ZpbGVtYXBfZ2V0X2ZvbGlvCj4+IAo+PiBBZnRlciBhZGRp
bmcgY29kZXRhZyB0byBfX2ZpbGVtYXBfZ2V0X2ZvbGlvLCBpdCBzaG93cwo+PiAKPj4gPiMgc29y
dCAtZyAvcHJvYy9hbGxvY2luZm98dGFpbHxudW1mbXQgLS10bz1pZWMKPj4gPiAgICAgICAgIDEw
TSAgICAgMjU0MSBkcml2ZXJzL2Jsb2NrL3pyYW0venJhbV9kcnYuYzoxNTk3IFt6cmFtXQo+PiA+
ZnVuYzp6cmFtX21ldGFfYWxsb2MgMTJNICAgICAzMDAxIG1tL2V4ZWNtZW0uYzo0MSBmdW5jOmV4
ZWNtZW1fdm1hbGxvYyAKPj4gPiAgICAgICAgIDEyTSAgICAgMzYwNSBrZXJuZWwvZm9yay5jOjMx
MSBmdW5jOmFsbG9jX3RocmVhZF9zdGFja19ub2RlIAo+PiA+ICAgICAgICAgMTZNICAgICAgOTky
IG1tL3NsdWIuYzozMDYxIGZ1bmM6YWxsb2Nfc2xhYl9wYWdlIAo+PiA+ICAgICAgICAgMjBNICAg
IDM1NTQ0IGxpYi94YXJyYXkuYzozNzggZnVuYzp4YXNfYWxsb2MgCj4+ID4gICAgICAgICAzMU0g
ICAgIDc3MDQgbW0vbWVtb3J5LmM6MTE5MiBmdW5jOmZvbGlvX3ByZWFsbG9jIAo+PiA+ICAgICAg
ICAgNjlNICAgIDE3NTYyIG1tL21lbW9yeS5jOjExOTAgZnVuYzpmb2xpb19wcmVhbGxvYyAKPj4g
PiAgICAgICAgMTA0TSAgICAgODIxMiBtbS9zbHViLmM6MzA1OSBmdW5jOmFsbG9jX3NsYWJfcGFn
ZSAKPj4gPiAgICAgICAgMTI0TSAgICAzMDA3NSBtbS9yZWFkYWhlYWQuYzoxODkgZnVuYzpyYWN0
bF9hbGxvY19mb2xpbyAKPj4gPiAgICAgICAgMi42RyAgIDY2MTM5MiBmcy9uZXRmcy9idWZmZXJl
ZF9yZWFkLmM6NjM1IFtuZXRmc10gZnVuYzpuZXRmc193cml0ZV9iZWdpbiAKPj4gPgo+PiAKPj4g
SGVscGZ1bCBvciBub3QsIEkgYW0gbm90IHN1cmUuIFNvIGZhciBubyBidWcgaGFzIGJlZW4gc3Bv
dHRlZCBpbiB0aGUgY2VwaGZzIHdyaXRlIHBhdGgsIHlldC4KPj4gQnV0IGF0IGxlYXN0LCBpdCBw
cm92aWRlcyBtb3JlIGluZm9ybWF0aW9uIGFuZCBuYXJyb3cgZG93biB0aGUgc2NvcGUgb2Ygc3Vz
cGljaW91cy4KPj4gCj4+IAo+PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzJhOWJhODhl
LjNhYTYuMTliMGI3M2RkNGUuQ29yZW1haWwuMDAxMDcwODJAMTYzLmNvbS8gIFsxXQo+PiBodHRw
czovL3RyYWNrZXIuY2VwaC5jb20vaXNzdWVzLzc0MTU2ICAgWzJdCj4KPldlbGwsIG15IGZpcnN0
IHRob3VnaHQgd2hlbiBsb29raW5nIGF0IHRoYXQgaXMgdGhhdCBtZW1vcnkgYWxsb2NhdGlvbgo+
cHJvZmlsaW5nIGlzIHVubGlrZWx5IHRvIGJlIGFueSBtb3JlIGhlbHAgdGhlcmUuIE9uY2UgeW91
J3JlIGRlYWxpbmcKPndpdGggdGhlIHBhZ2UgY2FjaGUsIGlmIHlvdSdyZSBsb29raW5nIGF0IGEg
Z2VudWluZSBsZWFrIGl0IHdvdWxkIHByZXR0eQo+bXVjaCBoYXZlIHRvIGJlIGEgZm9saW8gcmVm
Y291bnQgbGVhaywgYW5kIHRoZSBjb2RlIHRoYXQgbGVha2VkIHRoZSByZWYKPmNvdWxkIGJlIGFu
eXRoaW5nIHRoYXQgdG91Y2hlZCB0aGF0IGZvbGlvIC0geW91J3JlIGxvb2tpbmcgYXQgYSBwcmV0
dHkKPndpZGUgc2NvcGUuCj4KPlVuZm9ydHVuYXRlbHksIHdlJ3JlIG5vdCBncmVhdCBhdCB2aXNp
YmlsaXR5IGFuZCBpbnRyb3NwZWN0aW9uIGluIG1tLywKPmFuZCByZWZjb3VudCBidWdzIHRlbmQg
dG8gYmUgaGFyZCBpbiBnZW5lcmFsLgo+Cj5CZXR0ZXIgbW0gaW50cm9zcGVjdGlvbiB3b3VsZCBi
ZSBoZWxwZnVsIHRvIHNheSBkZWZpbml0aXZlbHkgdGhhdCB5b3UncmUKPmxvb2tpbmcgYXQgYSBy
ZWZjb3VudCBsZWFrLCBidXQgdGhlbiBvbmNlIHRoYXQncyBkZXRlcm1pbmVkIGl0J3Mgc3RpbGwK
PmdvaW5nIHRvIGJlIHByZXR0eSBwYWluZnVsIHRvIHRyYWNrIGRvd24uCj4KPlRoZSBhcHByb2Fj
aCBJIHRvb2sgaW4gYmNhY2hlZnMgZm9yIHJlZmNvdW50IGJ1Z3Mgd2FzIHRvIHdyaXRlIGEgc21h
bGwKPmxpYnJhcnkgdGhhdCBpbiBkZWJ1ZyBtb2RlIHNwbGl0cyBhIHJlZmNvdW50IGludG8gc3Vi
LXJlZmNvdW50cywgYW5kCj50aGVuIGVudW1lcmF0ZSBldmVyeSBzaW5nbGUgY29kZXBhdGggdGhh
dCB0YWtlcyByZWZzIGFuZCBnaXZlcyB0aGVtCj5kaXN0aW5jdCBzdWItcmVmcyAtIHRoaXMgbWVh
bnMgaW4gZGVidWcgbW9kZSB3ZSBjYW4gaW5zdGFudGx5IHBpbnBvaW50Cj50aGUgZnVuY3Rpb24g
dGhhdCdzIGJ1Z2d5IChhbmQgZXZlbiBiZXR0ZXIsIHdpdGggdGhlIG5ldyBDTEFTUygpIGFuZAo+
Z3VhcmQoKSBzdHVmZiB0aGVzZSBzb3J0cyBvZiBidWdzIGhhdmUgYmVlbiBnb2luZyBhd2F5KS4K
Pgo+QnV0IGdyYWZ0aW5nIHRoYXQgb250byBmb2xpbyByZWZjb3VudHMgd291bGQgYmUgYSBoZWxs
IG9mIGEgY2hvcmUuCj4KPk9UT0gsIGNvbnZlcnRpbmcgY29kZSB0byBDTEFTUygpIGFuZCBndWFy
ZHMgaXMgbXVjaCBtb3JlCj5zdHJhaWdodGZvcndhcmQgLSBqdXN0IGEgbWF0dGVyIG9mIHdyaXRp
bmcgbGl0dGxlIGhlbHBlcnMgaWYgeW91IG5lZWQKPnRoZW0gYW5kIHRoZW4gYSBidW5jaCBvZiBt
ZWNoYW5pY2FsIGNvbnZlcnNpb25zLCBhbmQgaXQncyB3ZWxsIHdvcnRoIGl0Lgo+Cj5CdXQsIEkn
bSByZWFkaW5nIHRocm91Z2ggdGhlIENlcGggY29kZSwgYW5kIGl0IGhhcyAvbGVzcy8gY29kZSBp
bnZvbHZpbmcKPmZvbGlvIHJlZmNvdW50cyB0aGFuIEkgd291bGQgZXhwZWN0Lgo+Cj5IYXMgYW55
b25lIGNoZWNrZWQgaWYgdGhlIGJ1ZyByZXByb2R1Y2VzIHdpdGhvdXQgenN3YXA/IEkndmUgZGVm
aW5pdGVseQo+c2VlbiBhIGxvdCBvZiBidWcgcmVwb3J0cyBpbnZvbHZpbmcgdGhhdCBjb2RlLgoK
VGhhbmtzIGZvciB0aGUgaW5mb3JtYXRpb24sIGFuZCB5b3VyIHRpbWV+IQpBZGQgbWFsY29sbUBo
YWFrLmlkLmF1CgpBY3R1YWxseSBJIGRvbid0IGV2ZW4gaGF2ZSBhY2Nlc3MgdG8gYSBjZXBoZnMg
dG8gY29uZmlybSB0aGUgYnVnLApJIHdhcyBqdXN0ICAgaW50ZXJlc3RlZCBpbiAgIm1lbW9yeSBs
ZWFrIiB0aGluZy4uICwgIGFuZCAgdHJ5IHRvICJzZWxsIiAgbWVtb3J5IGFsbG9jYXRpb24gcHJv
ZmlsaW5nIHRoZXJlLiA6KQoKCgpUaGFua3MKRGF2aWQ=

