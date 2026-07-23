Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 569FDC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:43:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C48566B00A5; Thu, 23 Jul 2026 13:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF82E6B00A6; Thu, 23 Jul 2026 13:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0ED76B00A7; Thu, 23 Jul 2026 13:43:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8566B00A5
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:43:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F2B59A00B8
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:43:39 +0000 (UTC)
X-FDA: 85020763758.05.C536573
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf16.hostedemail.com (Postfix) with ESMTP id 62D5518000B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:43:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of chengfenglin@stu.xmu.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=chengfenglin@stu.xmu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u2ztcILl2aTcBDKu4FgKWIcqDEZIrdTwbJEIGB7kdcQ=;
	b=O14pHj9sIx3b02rse4uNQTURslVe/iK/Qk74wOGDBE0zYeVnWIMRjWts9kWe15zGjXM0x6
	LZFEbxBZma4U40OIb/fL1WFOIgUSxTqukHt87XlTDXx/J6GwZT1v19yrJL/1XWv5IAWm7x
	+iX0AnE+P8daWhcjbljHbQPv9mIBsn8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of chengfenglin@stu.xmu.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=chengfenglin@stu.xmu.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828618;
	b=LebErRn8mh3OOw75uKLQETBkBSMCx94qYcfnFwwzU/zenpDtsBgb0IQueTGBFc4hWdt3id
	/e9gSMOZzas9uAWmPquDlGUHIIFHugruEgx/clu4WB1MKq6M0JtTKjcOx3zGHE8KzO7aGi
	zxPzHmfP40Gd6ugx0TL79llQ4rvG2jU=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with UTF8SMTP id AQAAfwA3GJnFUmJqoQNkAA--.23686S2;
	Fri, 24 Jul 2026 01:43:33 +0800 (CST)
Received: from chengfenglin$stu.xmu.edu.cn ( [23.249.17.30] ) by
 ajax-webmail-mail (Coremail) ; Fri, 24 Jul 2026 01:43:31 +0800 (GMT+08:00)
X-Originating-IP: [23.249.17.30]
Date: Fri, 24 Jul 2026 01:43:31 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chengfeng Lin" <chengfenglin@stu.xmu.edu.cn>
To: "Dev Jain" <dev.jain@arm.com>
Cc: "Pedro Falcato" <pfalcato@suse.de>,
	"Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org,
	"Liam R. Howlett" <liam@infradead.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Jann Horn" <jannh@google.com>, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/mprotect: shared-dirty base-page toggle slower
 since v6.17
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2025.3-cmXT6 build
 20260202(ad063891) Copyright (c) 2002-2026 www.mailtech.cn OP_ICM_ICMVM
In-Reply-To: <03f91210-e0b7-43b9-9a95-755b986b3c40@arm.com>
References: <7c9eeb21.1c04f.19efaacbb2f.Coremail.chengfenglin@stu.xmu.edu.cn>
 <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
 <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
 <dc402537-1527-4433-839e-960b6eb32bc4@arm.com>
 <4dceab6f.24e3b.19f8966e8ed.Coremail.chengfenglin@stu.xmu.edu.cn>
 <03f91210-e0b7-43b9-9a95-755b986b3c40@arm.com>
X-CM-CTRLMSGS: =?B?Hs6GYTiH6nJ5xwDR7hwMki1N8jM=
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6aa94b03.25351.19f90134c6a.Coremail.chengfenglin@stu.xmu.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwCXsfLEUmJqAmnOAA--.15800W
X-CM-SenderInfo: astqjiysvrikiuszmqhvwxh5lpxovvfxof0/1tbiAQAQEGpf17YD4
	QADs0
X-Coremail-Antispam: 1Uk129KBjvJXoWxGF4DAw4xWr1fWw15Cw1kAFb_yoWrGryUpF
	Zak3ZxJrWDGr1Iya48Aw4UXFWFkrs5Ja18XF1kGryfAa95CF1I9rZ3t3W0qFy3Gryvqa4F
	vFs5C34kJFn8CaDanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 62D5518000B
X-Stat-Signature: xs75see3ajzh7ij4bwsrjwopjf7w4wfx
X-HE-Tag: 1784828616-109505
X-HE-Meta: U2FsdGVkX1/YLZFMpLe3L1ZaNvXSOGjjz2stOQSC6Yn2Wg0cAiiNXHaL30yR9+8Z43iRAXTpxJdRz7GYKWMFGg8CmKTotWjf2oX9sU1wpSYRVUQ+rEiCd6x4r+aZxK3NH+Cjtbkno1XGRlVAPHhIgyQ/0iRk6LbkOlxewZmhQXGSAoNwJr9KokGxze0OZ7EuH9RuCZkEzy9ubepCed/sNCAYhIs4R8gN+Wo6Sr/5KY4uEC4lXe4nCq/8Bb7po311xTDoSXZS1NhVTsI+m4tJslnkHuJ3ofb2Y5zlfMCks7gbKqY8w7QULmcbwk3GENe4+cOuJLTqqdSXptIdYHKQLddTokwe5HLVlp9KZ6iQo44+Px7aASdI8KdnBDDmXl6IKaqQKQjAzdXdzucVjMeSUzsWQKRB/hzEtxOv9sel4pTerB2sMY0FrVnuOJCzVuSFXekFxTeO5D3B3I3nZLZtoZcG7NqpzDJz3NVx7ADrenai4QN2fpUeelrex5G+JT+mRirVHB1yLrkSGX3hrb92sHXpJhPR0Gxrfc1G5t+kzzcJUPQfab0dO1PypHucaXHqz40mLGYnc+ZXeZCWVX1cxwZuzvou3o5f/RejIau4a3b2oIhCU4+e7OXVojAM/0Ef+U/BINzOHb0jonQNNXsBQM6+0WWNrCtPhOD9ThtJjmh/kCMVjoca9Z0PLtLNjD2wU3g/FPNXb3gpaO6Kvv7JdE6nJDJps4AT7cXDiKaVVANaFQLaLTPwnbIw/L4wy7Q8Jv54xjkKBpohxPoOsBMMjpsAirUbWfrm43AEjIwLBnqSuvc5+b0cJ3/k4dIBk2K86pxHgGU/sq2rUmLe/rrwWxCLE8CvSqTAgfrf7x95sxI5ZvJ0nfKorrG0g7GbS4rAGKmcKb78ftARZ4d+2svIMpGSoK2lhdMtvcW4TdSnM9wxmHyp7IcDfNeZEIWwnBVPgTV31NG1YgT9sOAlylh
 n9w9SjNh
 74GkU9wo8sNthCzaaGEzU4s+V7q9OAx4brZPr/dl7fUWU5x78aL+hUrsQIf6E2HjUYMlLL30RyLdNIU4VLWYgmBVJpDUKUG83rVSZGDMDE8Zy5XZezx6XdKprS390bk1YYetM8wS6F2pWkMCJmc0YAHFbhd7Mwkx6wB0YuMN8ScodAZXwNevxg60xOOTY2l4Wx7wYi4QSZ0ToqCYGSRl7l3F50aDDsVPuEOxv0aMOmYGSi2+dM5c8s4W7kqvgAvyaOiMCROu3aC9rejU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksCgpUaGFua3MgZm9yIHRoZSBjb21tZW50cy4KCkZpcnN0LCB0aGUgZXhhY3QgZGlyZWN0IHBh
cmVudC9jaGlsZCB0ZXN0IHNob3dlZCB0aGF0IGNhYzFkYjhjM2FhZAooIm1tOiBvcHRpbWl6ZSBt
cHJvdGVjdCgpIGJ5IFBURSBiYXRjaGluZyIpIG1hZGUgdGhpcyB3b3JrbG9hZCAzOS43NyUgc2xv
d2VyLgpBIHNlcGFyYXRlIG1hdGNoZWQgUGVkcm8gdjMgdGVzdCBkaWQgbm90IGhlbHA6IG9uIHY3
LjEuMywgZnVsbC12MyB3YXMgNi4yMCUKc2xvd2VyIHRoYW4gdGhlIG1pZHBvaW50IG9mIHRoZSBu
by12MyBjb250cm9scy4gSSBkbyBub3QgdHJlYXQgdGhhdCBzbWFsbApkaWZmZXJlbmNlIGFzIGEg
c2VwYXJhdGUgcmVncmVzc2lvbi4KCkZvciBjb250ZXh0LCB0aGlzIHJlbWFpbnMgdGhlIHNhbWUg
bmFycm93IHN5bnRoZXRpYyBtaWNyb2JlbmNobWFyazogYSA2NCBNaUIKc2hhcmVkIGFub255bW91
cyBtYXBwaW5nLCBkaXJ0eSA0IEtpQiBiYXNlIHBhZ2VzIHdpdGggbm8gVEhQLCBhbmQgcmVwZWF0
ZWQKZnVsbC1yYW5nZSBwcm90ZWN0LCByZXN0b3JlLCBhbmQgd3JpdGUtdG91Y2ggY3ljbGVzLgoK
RXhhY3QtY29tbWl0IGRlY29tcG9zaXRpb24KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCkkg
cmFuIGEgbmluZS1wb2ludCwgZnJlc2gtYm9vdCBuZXN0ZWQgYWJsYXRpb24gYXJvdW5kIHRoZSBl
eGFjdCBwYXJlbnQvY2hpbGQKcGFpciwgcmV0dXJuaW5nIHRocm91Z2ggbWF0Y2hlZCBjb250cm9s
cyB0byBsaW1pdCB0aW1lIGRyaWZ0LiBJdCByZXByb2R1Y2VkIGEKMzYuNTElIGNoaWxkIHNsb3dk
b3duLiBNZWFzdXJlZCBhcyBhIGZyYWN0aW9uIG9mIHRoYXQgZ2FwOgoKICBkaWFnbm9zdGljIGNo
YW5nZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZ2FwIHJlY292ZXJlZAog
IHBhcmVudC1zdHlsZSBzaW5nbGUtUFRFIHVwZGF0ZS9mbHVzaCBwYXRoICAgICAgICAgICAgICAg
ICAgICAgIDQzLjA2JQogIHNraXAgbm9ybWFsLXBhdGggYmF0Y2ggZGlzY292ZXJ5ICAgICAgICAg
ICAgICAgICAgIG5vIG1lYXN1cmFibGUgZWZmZWN0CiAgYWRkaXRpb25hbGx5IHNraXAgdGhlIG5v
cm1hbC1wYXRoIGZvbGlvIGxvb2t1cCAgICAgICAgICAgICAgICAgNDQuNDclCiAgYWxsIHRocmVl
IGRpYWdub3N0aWMgY2hhbmdlcyBjb21iaW5lZCAgICAgICAgICAgICAgICAgICAgICAgICAgODcu
MjklCgpUaGUgZmlyc3QgZGlhZ25vc3RpYyBrZXB0IHRoZSBjaGlsZCdzIGxvb2t1cCBhbmQgYmF0
Y2ggZGlzY292ZXJ5IHVuY2hhbmdlZCwKcmVzdG9yaW5nIHRoZSBwYXJlbnQtc3R5bGUgdXBkYXRl
L2ZsdXNoIHBhdGggb25seSB3aGVuIGRpc2NvdmVyeSByZXR1cm5lZCBvbmUKUFRFLiBJdCByZWNv
dmVyZWQgNDMuMDYlIG9mIHRoZSBnYXAsIHBsYWNpbmcgYSBzdWJzdGFudGlhbCBjb3N0IGFmdGVy
CmRpc2NvdmVyeSBpbiB0aGUgZ2VuZXJpYyBzaW5nbGUtUFRFIGhhbmRsaW5nLCB0aG91Z2ggbm90
IGF0IGEgc3BlY2lmaWMKaW5zdHJ1Y3Rpb24uIEluIHRoZSBuZXN0ZWQgc2VxdWVuY2UsIHRoZSBp
bnRlcm1lZGlhdGUgZGlzY292ZXJ5IGJ5cGFzcyBoYWQKbm8gbWVhc3VyYWJsZSBlZmZlY3Q7IGFk
ZGl0aW9uYWxseSBza2lwcGluZyB0aGUgbm9ybWFsLXBhdGggZm9saW8gbG9va3VwCnJlY292ZXJl
ZCBhbm90aGVyIDQ0LjQ3JSwgc28gbG9va3VwIGNvbnRyaWJ1dGVzIGEgc2ltaWxhcmx5IGxhcmdl
IHNoYXJlLgpUaGVzZSBjb3N0cyBvY2N1ciBpbiBzZXF1ZW5jZSwgYW5kIGJvdGggdGhlIHByb3Rl
Y3QgYW5kIHJlc3RvcmUgd2Fsa3MgcGF5CmJvdGguCgpUaGUgY29tYmluZWQgcHJvYmUgd2FzIHN0
aWxsIDQuNjQlIHNsb3dlciB0aGFuIHRoZSBwYXJlbnQsIGxlYXZpbmcgMTIuNzElIG9mCnRoZSBv
cmlnaW5hbCBnYXAgdW5leHBsYWluZWQuIEFsbCAxMzUgbWVhc3VyZWQgcHJvY2Vzc2VzIHBhc3Nl
ZCB0aGUgc2VtYW50aWMKYW5kIDQgS2lCL25vLVRIUCBjaGVja3M7IHRoZSBtYXhpbXVtIENWIHdh
cyAxLjU2JS4KCnY3LjEuMyBsb29rdXAgc2FmZXR5IGNoZWNrCi0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCgpUaGUgZXhhY3Qgc2VxdWVuY2UgYWJvdmUgdXNlcyB0aGUgY2FjMWRiOGMzYWFkIGNo
aWxkLCB3aGljaCBjYWxscwp2bV9ub3JtYWxfZm9saW8oKS4gVGhpcyBzZXBhcmF0ZSBjaGVjayB1
c2VzIHVubW9kaWZpZWQgdjcuMS4zLCB3aGVyZSB0aGUKY29ycmVzcG9uZGluZyBwYXRoIGNhbGxz
IHZtX25vcm1hbF9wYWdlKCkgZm9sbG93ZWQgYnkgcGFnZV9mb2xpbygpOyBpdHMKcGVyY2VudGFn
ZXMgYXJlIG5vdCBwYXJ0IG9mIHRoZSBleGFjdC1jb21taXQgZGVjb21wb3NpdGlvbi4KCkZvciBh
IHNoYXJlZCwgbm9uLU5VTUEgUFRFIHdpdGggcHRlX2JhdGNoX2hpbnQoKSA9PSAxLCBhIGRpYWdu
b3N0aWMgdGhhdCBza2lwcwp0aGUgY3VycmVudCBwYWdlL2ZvbGlvIGxvb2t1cCBhbmQgYmF0Y2gg
ZGlzY292ZXJ5IHdhcyAxNy4zNiUgZmFzdGVyIG9uIHRoZQo0IEtpQiB3b3JrbG9hZC4gQSBwYWly
ZWQgdHJhY2UgcmVtb3ZlZCBleGFjdGx5IDIsMDQ4IHZtX25vcm1hbF9wYWdlKCkgY2FsbHMsCmJ1
dCB0aGlzIGlzIG5vdCBhIHN0YW5kYWxvbmUgdGltaW5nIG9mIHRoYXQgZnVuY3Rpb24uCgpUaGUg
c2FtZSBkaWFnbm9zdGljIHdhcyA2NS44MCUgc2xvd2VyIGZvciBhIHZlcmlmaWVkIHNoYXJlZCAy
IE1pQiBmb2xpbyBtYXBwZWQKYnkgNTEyIFBURXMsIGJlY2F1c2Ugb24geDg2IHRoZSBoaW50IGlz
IGFsc28gb25lIGFuZCB0aGUgZGlhZ25vc3RpYyBkaXNhYmxlcwpmb2xpbyBiYXRjaGluZy4KCkFs
bCB0ZXN0cyB1c2VkIGZyZXNoIGJvb3RzIG9uIGFuIGk3LTEyNzAwS0Ygd2l0aCAzMiBHaUIgUkFN
LiBXaXRoaW4gZWFjaApjb21wYXJpc29uLCBidWlsZHMgdXNlZCBtYXRjaGVkIGNvbmZpZ3MgYW5k
IEdDQyAxNS4yLjAuIFRoZSBiZW5jaG1hcmsgdXNlZApQLWNvcmUgQ1BVIDIsIHBlcmZvcm1hbmNl
IGdvdmVybm9yIGFuZCBFUFAsIFR1cmJvIG9mZiwgYW5kIHByZWVtcHQ9bm9uZS4KClRodXMsIHRo
ZSBnZW5lcmljIHNpbmdsZS1QVEUgdXBkYXRlL2ZsdXNoIHBhdGggYW5kIHRoZSBsb29rdXAgYWNj
b3VudCBmb3IKYWJvdXQgODclIG9mIHRoZSBleGFjdC1jb21taXQgZ2FwLiBUaGUgdjcuMS4zIGJ5
cGFzcyBpcyB1bnNhZmUgZm9yIFBURS1tYXBwZWQKbGFyZ2UgZm9saW9zLCBzbyBJIGFtIG5vdCBw
cm9wb3NpbmcgaXQgYXMgYSBmaXguCgpQZWRybyBkaWQgbm90IG9ic2VydmUgdGhlIHNhbWUgbG9v
a3VwIGNvc3Qgb24gaGlzIGRlc2t0b3AuIFRoYXQgZGlmZmVyZW5jZQptYXkgYmUgbWFjaGluZS1z
cGVjaWZpYywgYnV0IEkgaGF2ZSBub3QgdGVzdGVkIGVub3VnaCBzeXN0ZW1zIHRvIGVzdGFibGlz
aAp3aHkuIEkgaGF2ZSBhbHNvIG5vdCBtZWFzdXJlZCBhcHBsaWNhdGlvbi1sZXZlbCBpbXBhY3Qu
CgpDb21wYWN0IGV2aWRlbmNlIGJ1bmRsZToKCiAgaHR0cHM6Ly9naXRodWIuY29tL2xjZjAzOTkv
bGludXgtcmVncmVzc2lvbi1ldmlkZW5jZS90cmVlL2VhM2VjMmQ0MTcwMjUwMjMzNmI5ODU0Yjlk
YTc4YzQzODQwYjg2ZTgvbXByb3RlY3Qtc2hhcmVkLWRpcnR5LXRvZ2dsZS9iYXJlLW1ldGFsCgpT
dGFuZGFsb25lIHJlcHJvZHVjZXJzOgoKICBodHRwczovL2dpdGh1Yi5jb20vbGNmMDM5OS9saW51
eC1yZWdyZXNzaW9uLWV2aWRlbmNlL3RyZWUvZWEzZWMyZDQxNzAyNTAyMzM2Yjk4NTRiOWRhNzhj
NDM4NDBiODZlOC9tcHJvdGVjdC1zaGFyZWQtZGlydHktdG9nZ2xlL3JlcHJvZHVjZXIKClRoYW5r
cywKQ2hlbmdmZW5nCgo=


