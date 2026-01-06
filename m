Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 819EACD0430
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0C56B0005; Mon,  5 Jan 2026 22:51:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8936B0088; Mon,  5 Jan 2026 22:51:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEE516B0093; Mon,  5 Jan 2026 22:51:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACAA6B0005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:51:05 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5D0581A0387
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:51:05 +0000 (UTC)
X-FDA: 84300163290.12.79AF95E
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7F90D20002
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:51:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="R J2rhie";
	spf=pass (imf13.hostedemail.com: domain of 00107082@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767671463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBEA6cq8aVqiISMY9JznRyEbKyiqm6xzqmL9rcIBaUQ=;
	b=QkUK92GnVHzcspdDyTja2FhTal2wjCWczIA9mJXnPDIWzUSsBAYcadYi7r5t8eF/D26K+N
	4DevzSkF+Vm2LJPvWP+obUd7s/NCnMkgfNUgWmBaIWfz0tohnyWhjfMB5S4hQqK8TZxrTZ
	Rm9+3hkCaWrhx/n+hoaX7SQRvYQp6AU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767671463; a=rsa-sha256;
	cv=none;
	b=w27LyW2mDJPfmxw9IriQ639fM1BY1pCh3pwl3IM/qtGWkdmlh3phqdqtzZaoUBG1FLs9IQ
	wlS3B3ZYqccoVXxgU/qux/9YKn5MTmY4Mp20YXW/CaumzPK/17BEfozUtvoVcppe+ShIpD
	dVM/wI9C9sueAAWjdK03a9hqfkTvZ7Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="R J2rhie";
	spf=pass (imf13.hostedemail.com: domain of 00107082@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=yBEA6cq8aVqiISMY9JznRyEbKyiqm6xzqmL9rcIBaUQ=; b=R
	J2rhieq8FjCnuMqmerXdT9wzasR+5g5TlcM0hpB1RyrO7TbVRr2QbyqMgZdovC/r
	de4Gxx3/CZrWNSQUl5fb1otxlZ3s3hJRPyHrgKcqs0Tf2rXm6cXkaBrnJkd346+y
	fEa95JkKIneNKQICCYXXeBDt1EI1vP+n5LgfI9Ylxw=
Received: from 00107082$163.com ( [111.35.191.26] ) by
 ajax-webmail-wmsvr-40-132 (Coremail) ; Tue, 6 Jan 2026 11:50:36 +0800 (CST)
X-Originating-IP: [111.35.191.26]
Date: Tue, 6 Jan 2026 11:50:36 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Suren Baghdasaryan" <surenb@google.com>
Cc: kent.overstreet@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	pasha.tatashin@soleen.com, souravpanda@google.com, vbabka@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag
 along callchain
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20250723(a044bf12) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
References: <20251216064349.74501-1-00107082@163.com>
 <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
X-NTES-SC: AL_Qu2dBfqcvkwo4CSaZekZnEYQheY4XMKyuPkg1YJXOp80myX30Tk4REZIM2H6zfiQFgq8iBqTdyJ+zd18X5laXJ6Q9DryY2BjVv7ci3/46UPb
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:hCgvCgD3H2qNhlxpdC1QAA--.17582W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbC7Q024Glcho0+wQAA33
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Stat-Signature: 4k9hzg6i5ox6bmpu7hamcj8dadc6e5mx
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F90D20002
X-Rspam-User: 
X-HE-Tag: 1767671462-630542
X-HE-Meta: U2FsdGVkX19PmbniPmK6Gj5sjYvQ3XZyz8zaR3cNSRgN9B+HJe23iOG4XbH7sxmWTrvWFGWi8YIheuOTQKBGyOpJ3qibwUnhbzMR8F36KyedLnE/9hT9RF8WhYYeeeF6Y6WoRv/c5VxgakYohF8g5JYKVkg+TMoAiZVRy0YCaG+OYmj41w8+y7Mcy1M2/7QUJXauFOmpIVNoER9hyLmPzUlv/G7PMH+jS7749Ifm7p42wcs+dHIX7AhqUAQr9A7Vc8DDA600xAYphLyqptYFmY1bSKSMvFg6w1iyw1Uki652Xyhp4HCaP8rGyq7DCuYu1sW2Ce1vv8xNrfCDgzxUgiX/Dop4qPBfKl8kDqOskXSIlaJcTYY6wTTC92Tk5VkucH/l6Tq3wwDw2gRcrNS9jG4ScZS1DEyJCpjAimTaoJdfUr+0FZgNaF7d3k4dAP1NNcfpT8zBKh2w7IeZURkExNdm0QhGySaAeqrwFvVHtdMhh6Apioou68FSIRy1ayGKLncOeCzc7AZmmL6maQan8nQq9u58Q925TIM06fVHdExNWJK4jowaY5wt6jgA0+lWTrWaXcDFuAsYdo+Ade+0BbUnsLBsGsoS8DzNP4htJRsEiCH6cZ6kPRymDnN1rlWBakRGIAHgXJRkDBdUZ17ePiaTDEQ4++QldiD3zQjyJA+UoTn4fdaTSLkOe8Q48kPT/hMUCJjdOHgkapp2tTsxgSgcL+6voOmR8H6eiR+b9YL0MRBaQJiu63aaay4/Y8wstZ1rUK2eZr90EHhea5PuTA9P5HRBQntjMXDpI70zWy0GP4e6CN/G8kJdQB1o/EAu2yzO3299COQx5EVThNFIpaPtDAtMX2Oexp6Fu+alNj6VLrTpY1wxKxdIEwxBYDV/cCxjbv0xv5XTSLVIh6h4cwnSb1ZGho9bv0FJb7diKT+Jz77Gervyxb2TpbZ/lj6DIr1oE8UlPn+5AhOHTYg
 eukcoJaz
 fseG453PmNM5B54dmC9LqyZVJ6yjrjMqRWzBN/WbMyYFW0v7uGu0lTmT3AH1tnWvy9cFAJ383Nlw4eCNuNGRCGfSATScnj6UTZsGSCfXxUhCcLJlgwHibYmFTh0W16F2z9DzvtE34hhXb3UPE5waqjlDWnny4322b7/LMFN4DyVb4IZnXHEJpmJvNj9itb+Sc2/tBtYKUQrkoKKGDZ6mLdsv9UVVJ+xi6nNKzzGX4Gz6VTjvbACVuFssl7o6s4AGb6HcdZ2StrzLxUY0NzSXuyjqIw6UaV4o2zIFOUtsv5FsAVO5E45hugCyjJL8jPvpuzKV19heOAIHELiz8qz0do0KTythC9kH2LTtf89/5caL6IdNZAxYrXN0Rd+5zEcnY2RGSmrkTWHdxqEbyKBKqQcfBqcLUlTePoJ/6+As0g4I37f8WsUQBF2IlN5F4BUy4J37syuQ4kI18h6FC4lp9s3wrTcuNlB8cQgORi0Kdz9HEkn56F3KiEf75Pf92dwBDqfNCNZtqk76H6yUyif1+V9F6aWXDevhWzZlNedr6K1PRGzcXnjqvdyU1Ke+ZPX5UY1A9Q5ITBTZrUBM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

QXQgMjAyNi0wMS0wNiAwNToxMjo0OCwgIlN1cmVuIEJhZ2hkYXNhcnlhbiIgPHN1cmVuYkBnb29n
bGUuY29tPiB3cm90ZToKPk9uIE1vbiwgRGVjIDE1LCAyMDI1IGF0IDEwOjQ04oCvUE0gRGF2aWQg
V2FuZyA8MDAxMDcwODJAMTYzLmNvbT4gd3JvdGU6Cj4+Cj4+IFdoZW4gdHJhY2tpbmcgbWVtb3J5
IGFsbG9jYXRpb24gZm9yIHNvbWUgc3BlY2lmaWMgZnVuY3Rpb24sCj4+IHBpY2tpbmcgdGhlIGZp
cnN0IGNvZGV0YWcgaXMgbW9yZSBkZXNpcmVkLCBiZWNhdXNlIHRoZXJlCj4+IGlzIG5vIG5lZWQg
dG8gdHJhY2sgZG93biBhbGwgYWxsb2NhdGlvbiBzaXRlcyBpbiB0aGUgY2FsbAo+PiBncmFwaCBh
bmQgY2hhbmdlIHRoZW0gdG8gX25vcHJvZiB2ZXJzaW9uLCB3aGljaCBpcyBxdWl0ZQo+PiBpbmZs
ZXhpYmxlIHdoZW4gdGhlIGNhbGwgZ3JhcGggaXMgY29tcGxleC4KPj4KPj4gRm9yIGV4YW1wbGUs
IGNvbnNpZGVyIGEgc2ltcGxlIGdyYXBoOgo+Pgo+PiBBIC0tLT4gQiAtLS0+IEMgPT09PiBECj4+
ICAgICAgICBFIC0tLT4gQwo+Pgo+PiA9PT0+IG1lYW5zIGEgY2FsbCB3aXRoIGNvZGV0YWcKPj4g
LS0tPiBtZWFucyBhIGNhbGwgd2l0aG91dCBjb2RldGFnCj4+Cj4+IFRvIHByb2ZpbGluZyBtZW1v
cnkgYWxsb2NhdGlvbiBmb3IgQSwgdGhlIGNhbGwgZ3JhcGggbmVlZHMKPj4gdG8gYmUgY2hhbmdl
ZCB0bwo+PiBBID09PT4gQiAtLS0+IEMgLS0tPiBECj4+ICAgICAgICBFID09PT4gQwo+PiBUaHJl
ZSBjYWxsIHNpdGVzIG5lZWRzIHRvIGJlIGNoYW5nZWQuCj4+Cj4+IEJ1dCBpZiBwaWNrIHRoZSBm
aXJzdCBjb2RldGFnLCBvbmx5IG9uZSBjaGFuZ2UgaXMgbmVlZGVkLgo+PiBBID09PT4gQiAtLS0+
IEMgPT09PiBECj4+ICAgICAgICBFIC0tLT4gQwo+Pgo+PiBUaGUgZHJhd2JhY2sgaXMgc29tZSBh
Y2NvdW50aW5nIGZvciBDIGlzIHNwbGl0ZWQgdG8gQSwKPj4gbWFraW5nIHRoZSBudW1iZXIgbm90
IGFjY3VyYXRlIGZvciBDLiAoQnV0IHRoZSBvdmVyYWxsCj4+IGFjY291bnRpbmcgaXMgc3RpbGwg
dGhlIHNhbWUuKQo+Pgo+PiBUaGlzIGlzIHVzZWZ1bCB3aGVuIGRlYnVnIG1lbW9yeSBwcm9ibGVt
cywgbm90IG1lYW50IGZvcgo+PiBwcm9kdWN0aW9uIHVzYWdlIHRob3VnaC4KPgo+SGkgRGF2aWQs
Cj5Tb3JyeSBmb3IgdGhlIGRlbGF5LiBEbyB5b3UgaGF2ZSBzcGVjaWZpYyBleGFtcGxlcyB3aGVu
IGFsbG9jYXRpb24KPm5lZWRzIHRvIGJlIGFjY291bnRlZCBhdCB0aGUgaGlnaGVzdCBsZXZlbApI
aSwgCgpJIGRvIG5vdCBoYXZlIGEgdmVyeSBjb252aW5jaW5nICBwcmFjdGljYWwgZXhhbXBsZSB5
ZXQuIDooCkkgc3RhcnRlZCB0byB0aGluayBhYm91dCB0aGlzIGluIHRoaXMgdGhyZWFkWzFdLCBk
ZWJ1Z2dpbmcgcG9zc2libGUgbWVtb3J5IGxlYWsgaW4gY2VwaGZzLgpJZiBtb2R1bGVzIHdhbnQg
dG8gYWNjb3VudCBpdHMgbWVtb3J5IHVzYWdlLCB0aGV5IGNhbiBwbGFudCBjb2RldGFncyBpbiB0
aGVpciBjb2RlcGF0aAp3aXRob3V0IHdvcnJ5aW5nIGFib3V0IGNvZGV0YWdzIGRlZXBlciBpbiB0
aGUgY29kZSBjaGFpbi4KCkFuZCBJIG5vdGljZWQgdGhhdCBzb21lIGNhbGxzaXRlcycgbWVtb3J5
IHVzYWdlIGlzIGluY29tcGxldGUsIGJlY2F1c2UgaXRzIGFjY291bnRpbmcKaXMgc3BsaXQgYnkg
Y29kZXRhZ3MgZGVlcGVyIGluIHRoZSBjb2RlIGNoYWluIApGb3IgZXhhbXBsZSwgb24gbXkgc3lz
dGVtLCBJIGhhdmUKNTEyICAgICAgICAxIGRyaXZlcnMvdXNiL2NvcmUvaHViLmM6NjA4MCBbdXNi
Y29yZV0gZnVuYzp1c2JfaHViX2luaXQKYnV0IGlmIHBpY2sgZmlyc3QgY29kZXRhZywgSSB3b3Vs
ZCBoYXZlCjIwOTkyICAgICAgICAxMCBkcml2ZXJzL3VzYi9jb3JlL2h1Yi5jOjYwODAgW3VzYmNv
cmVdIGZ1bmM6dXNiX2h1Yl9pbml0CgpPbmUgY2FsbCBjaGFpbiAgCiAgICB1c2JfaHViX2luaXQ9
PT5hbGxvY193b3JrcXVldWUtLS0+X19hbGxvY193b3JrcXVldWUgLS0+YWxsb2Nfbm9kZV9ucl9h
Y3RpdmU9PT5remFsbG9jX25vZGUKaGFzIHR3byBjb2RldGFncywgYW5kIGl0cyBtZW1vcnkgaXMg
bm90IGFjY291bnRlZCB0byB1c2IgZHJpdmVycy4KCklmIGludGVyZXN0ZWQgaW4gbW9kdWxlJ3Mg
bWVtb3J5IHVzYWdlLCAgcGlja2luZyB0aGUgZmlyc3QgY29kZXRhZyB3b3VsZCBiZSBwcmVmZXJy
ZWQsIEkgZ3Vlc3MuCgoKVGhhbmtzCkRhdmlkCgpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwv
MmE5YmE4OGUuM2FhNi4xOWIwYjczZGQ0ZS5Db3JlbWFpbC4wMDEwNzA4MkAxNjMuY29tLyAgWzFd
Cgo+T3VyIHVzdWFsIGFwcHJvYWNoIGlzIHRoYXQgd2UgYWNjb3VudCBhbGxvY2F0aW9uIGF0IHRo
ZSBsb3dlc3QKPiJhbGxvY2F0b3IiIGxldmVsIGFuZCBpZiB0aGF0IGFsbG9jYXRvciB1c2VzIGxv
d2VsIGxldmVsIGFsbG9jYXRvcnMgaXQKPnNob3VsZCB1c2UgX25vcHJvZiB2ZXJzaW9ucyBzbyB0
aGF0IGFsbG9jYXRpb24gaXMgc3RpbGwgZG9uZSBhdCB0aGUKPnJpZ2h0IGxldmVsLiBJIHdvdWxk
IGxpa2UgdG8ga2VlcCB0aGF0IHNpbXBsZSBhcHByb2FjaCBidXQgaWYgdGhlcmUKPmFyZSBjYXNl
cyB3aGVuIHRoYXQncyBub3QgZW5vdWdoLCBJIHdvdWxkIGxpa2UgdG8ga25vdyBtb3JlIGFib3V0
IHRoZW0KPmJlZm9yZSB0cnlpbmcgdG8gYWRkcmVzcyB0aGVtLgo+VGhhbmtzLAo+U3VyZW4uCj4K
Pj4KCg==

