Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA746F55444
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:50:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 204336B0005; Tue, 24 Feb 2026 21:50:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E5B96B0088; Tue, 24 Feb 2026 21:50:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E86E6B008A; Tue, 24 Feb 2026 21:50:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ED9176B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:50:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABDE6160448
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:54 +0000 (UTC)
X-FDA: 84481451628.09.AAA6B77
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf15.hostedemail.com (Postfix) with ESMTP id D05F0A000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:50:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="J Uw2en5";
	spf=pass (imf15.hostedemail.com: domain of 00107082@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771987852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BUewdg1wHSATjTW4it3R1EI6h1poyfTzxmODGl1Y9qY=;
	b=OiBYex88NZy55qTNr7aHKKBUbNB2PZwSQqsqDNTK5YsRNkfTAboIp9iIN7iCj6HM3RXOBK
	+FH64rPYoVkb1V+4U4EH90BPZKxHvVhTMph3TSgeCc3LcMW8NSiD90l2JW/JqI3yliyoik
	pxAty4h9IPRMJzcY6ZENIC1xD0f9T08=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="J Uw2en5";
	spf=pass (imf15.hostedemail.com: domain of 00107082@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=00107082@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771987852; a=rsa-sha256;
	cv=none;
	b=u+1OD3RW8qsQsd6laLKmoredkgf5WkJ7NXhoY+r7T6D9fEGc7PYhiKPV/l96t/4eGyPC6M
	dj2CMALmpcyR+dJ2cLrzNAD60YSHz08XGWj7h9djxcxlRc/ASf7UqNMcgCHgo2ltpplqmm
	PDtP7EhBj3OsMtzSBbPRIjUnr5MyUW8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Date:From:To:Subject:Content-Type:MIME-Version:
	Message-ID; bh=BUewdg1wHSATjTW4it3R1EI6h1poyfTzxmODGl1Y9qY=; b=J
	Uw2en5tSP5Hu/X/6Xo7A9xfDyMVFTCLINltKVc999KToM/fWHXJLy8+IOKfqC4A2
	TQohwqXYxUv53T18e2jIjqF1ETeRvpsHEMbLZ/lslY/dwaawXAuV2wFcvKzh9q/2
	qYU36yFoqyXAAgTPDb3tnTRZgNqzslyV/AHofUdJvg=
Received: from 00107082$163.com ( [111.35.188.114] ) by
 ajax-webmail-wmsvr-40-123 (Coremail) ; Wed, 25 Feb 2026 10:50:35 +0800
 (CST)
X-Originating-IP: [111.35.188.114]
Date: Wed, 25 Feb 2026 10:50:35 +0800 (CST)
From: "David Wang" <00107082@163.com>
To: "Suren Baghdasaryan" <surenb@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, harry.yoo@oracle.com,
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re:[PATCH v2 1/1] mm/slab: mark alloc tags empty for sheafs
 allocated with __GFP_NO_OBJ_EXT
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2023.4-cmXT build
 20251222(83accb85) Copyright (c) 2002-2026 www.mailtech.cn 163com
In-Reply-To: <20260224221132.1702713-1-surenb@google.com>
References: <20260224221132.1702713-1-surenb@google.com>
X-NTES-SC: AL_Qu2cA/WTuEAo4yKfZekXn0oTju85XMCzuv8j3YJeN500kSTS6iQcWlhvL3rp8P6UOjGQjBiQaRN/++VfUaJUT45D48UdzwFr+v1WFNUcgSCf
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=GBK
MIME-Version: 1.0
Message-ID: <6bebf90c.1ff0.19c92b4998d.Coremail.00107082@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:eygvCgDnj5x8Y55p1+lsAA--.7023W
X-CM-SenderInfo: qqqrilqqysqiywtou0bp/xtbC7hz5pGmeY3wUfQAA3u
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Rspam-User: 
X-Rspamd-Queue-Id: D05F0A000C
X-Rspamd-Server: rspam02
X-Stat-Signature: 4u733b8c7kag46zzk85i6eatjey19qx4
X-HE-Tag: 1771987851-180930
X-HE-Meta: U2FsdGVkX1+zr+T2VnS3STOOkvKeY4o/uuRu29dBGlaOwOa84JjrrqB1BqxuqExVIf5f7kd4IiaUCN7RTKziJX7stnTXI+/Rvt8bhljDc84+RtKi7nwfchBhb+lM5v8/azm8DqsnhwErLinNedBlWj318ZyXMh/7Z6Ec6DS5QvmjSvhOg7eT8UQ3EY5LJhjlBpc5PwFG521kTHXL0ICJOvFFMLR/+RCIQlEnDv6+Q36NxJxC3EzfG+PAXHWQyrbtYViKyTSSjIXNDqqzhLYhiLwELAtfo4IgmqNWfvgiPLvz2a/3ucAUHtHu5q9ogQZMH/qPkQ3IE8bFr2JKTYwuyCz4Saw56pA/KEL1og/Ux73skI6lefzcNdNrIrllMKQDpmr7BcmbidaJRFmYj5vGlX63bVlDhY8KWAIQB4i2wOV6V3kTdlSRE1RNz1G8ALTXzexvZc9SgN8wjok4/BF8ZZ2jTikszqEMNrDQIYuRzYsu829Jaft7TBAe9wHt5u0AmOMnsNXhA3y+pDt4fIabJQu9xi2mLrw/g+de6NRECWdqOlGurll9DUp3yjtX84/mwvRbmfAtL/sB6JSoIUYxmGLqnWnd9PDWcyyX2YhFY9zmzh0pfYvmrZ7ATYyo8EeYKjb4JMxMMNHlqk8uVtw9xYlbzRSROFE1YD+c40ZX3GiyDzyF7RZhHSKA2dX/uPYmxLTJDBHSmtaRCTrBdsOdkP7qkFMlRosLRc59vkwZ7x0bsQSKqgBUNupyq4et6w4cyE7VvmJiQ9dW4hv2cQ/khGzLWZSZFA+lReaWRg6+YCIb5M7rfaZN252bhXOT/tO09skoNu9ZJvdFXGwLj6hQ2TPaOcjKjh6mdfSegNcZFbmv8V2eae3FAJnNnwtjuPkjvMZe5TZjM6wAEO490GVvMMP1lfgVhT194eRM4axJhQstliOx46HmXsJ5bGSLgHSpQS36OII9StywFqlvHTz
 1aKvuUl5
 eM2OD7IqZ5z9enj2cRQ/mUR8dmGH5FrJek48DMOQZOjsQ0nxZSaICopX2CfqR7a0k9oFNQJKGYf3pBDHJJsh9Rqz8/qLhCWuslR2dbUGy97aVa5UQ0R4JeKs8Wwy9rbL7Yhyy1Kj9jwjTgkXI38E9qL2D30MM1eqLqvn86zEymHmtBdpysrEaE7P5dR9tU/sWZxbRv9Zw/DwtsubRHxQop7gUgjWxqgGtGPfMYFeYtOSj8YCwC8PNr0Z+AIP3blkse5t51aTK/lnki+/rCeYWOqRMtYHOn0oxycENjhfEBWdnFnmKJgyjxwT2gwR/fm8UBL3ddSsJMzyMjFR9Z4iHzTfTa7ZYOtRykR82ME4NYpvoc15jG08v7bRLNDCj5FS2HJ2FKXo5HwW4qDBN0TChCxHmREW5Iu4baYv+tIKuUGnki3Ng6Bv+iidPJRYDxQCpc85+3+ygDC3ELgvbAFCgb9xG+NuJ1x/krl1W6Bc7IskjO1S89IMmWPKvvbsVkZfXCLQTJF/NP0l0geis7D+1QbAdTGHI6/F+eHhp8M1KLW4ZY3Wkh/IQH9ak/c8qdDIzi0GtXQIF4Cmu6Sl8Lss9C2YjYUlBlgq/CEUe22Azitnw8P4W9LH/6ZxVKnaDPbsrSYVqUg5R/dj+oCAUamKVgMa0ItB+m9Qpm0USudnPj50B3iRvWmKmYfY2/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

QXQgMjAyNi0wMi0yNSAwNjoxMTozMiwgIlN1cmVuIEJhZ2hkYXNhcnlhbiIgPHN1cmVuYkBnb29n
bGUuY29tPiB3cm90ZToKPmFsbG9jX2VtcHR5X3NoZWFmKCkgYWxsb2NhdGVzIHNoZWFmcyBmcm9t
IFNMQUJfS01BTExPQyBjYWNoZXMgdXNpbmcKPl9fR0ZQX05PX09CSl9FWFQgdG8gYXZvaWQgcmVj
dXJzaW9uLCBob3dldmVyIGl0IGRvZXMgbm90IG1hcmsgdGhlaXIKPmFsbG9jYXRpb24gdGFncyBl
bXB0eSBiZWZvcmUgZnJlZWluZywgd2hpY2ggcmVzdWx0cyBpbiBhIHdhcm5pbmcgd2hlbgo+Q09O
RklHX01FTV9BTExPQ19QUk9GSUxJTkdfREVCVUcgaXMgc2V0LiBGaXggdGhpcyBieSBtYXJraW5n
IGFsbG9jYXRpb24KPnRhZ3MgZm9yIHN1Y2ggYWxsb2NhdGlvbnMgYXMgZW1wdHkuCj4KPlJlcG9y
dGVkLWJ5OiBEYXZpZCBXYW5nIDwwMDEwNzA4MkAxNjMuY29tPgo+Q2xvc2VzOiBodHRwczovL2xv
cmUua2VybmVsLm9yZy9hbGwvMjAyNjAyMjMxNTUxMjguMzg0OS0xLTAwMTA3MDgyQDE2My5jb20v
Cj5BbmFseXplZC1ieTogSGFycnkgWW9vIDxoYXJyeS55b29Ab3JhY2xlLmNvbT4KPlNpZ25lZC1v
ZmYtYnk6IFN1cmVuIEJhZ2hkYXNhcnlhbiA8c3VyZW5iQGdvb2dsZS5jb20+Cj4tLS0KPiBtbS9z
bGFiLmggfCAgNCArKy0tCj4gbW0vc2x1Yi5jIHwgMjMgKysrKysrKysrKysrKysrLS0tLS0tLS0K
PiAyIGZpbGVzIGNoYW5nZWQsIDE3IGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQo+Cj5k
aWZmIC0tZ2l0IGEvbW0vc2xhYi5oIGIvbW0vc2xhYi5oCj5pbmRleCA3MWM3MjYxYmY4MjIuLmY2
ZWY4NjJiNjBlZiAxMDA2NDQKPi0tLSBhL21tL3NsYWIuaAo+KysrIGIvbW0vc2xhYi5oCj5AQCAt
MjkwLDE0ICsyOTAsMTQgQEAgc3RhdGljIGlubGluZSB2b2lkICpuZWFyZXN0X29iaihzdHJ1Y3Qg
a21lbV9jYWNoZSAqY2FjaGUsCj4gCj4gLyogRGV0ZXJtaW5lIG9iamVjdCBpbmRleCBmcm9tIGEg
Z2l2ZW4gcG9zaXRpb24gKi8KPiBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGludCBfX29ial90b19p
bmRleChjb25zdCBzdHJ1Y3Qga21lbV9jYWNoZSAqY2FjaGUsCj4tCQkJCQkgIHZvaWQgKmFkZHIs
IHZvaWQgKm9iaikKPisJCQkJCSAgdm9pZCAqYWRkciwgY29uc3Qgdm9pZCAqb2JqKQo+IHsKPiAJ
cmV0dXJuIHJlY2lwcm9jYWxfZGl2aWRlKGthc2FuX3Jlc2V0X3RhZyhvYmopIC0gYWRkciwKPiAJ
CQkJIGNhY2hlLT5yZWNpcHJvY2FsX3NpemUpOwo+IH0KPiAKPiBzdGF0aWMgaW5saW5lIHVuc2ln
bmVkIGludCBvYmpfdG9faW5kZXgoY29uc3Qgc3RydWN0IGttZW1fY2FjaGUgKmNhY2hlLAo+LQkJ
CQkJY29uc3Qgc3RydWN0IHNsYWIgKnNsYWIsIHZvaWQgKm9iaikKPisJCQkJCWNvbnN0IHN0cnVj
dCBzbGFiICpzbGFiLCBjb25zdCB2b2lkICpvYmopCj4gewo+IAlpZiAoaXNfa2ZlbmNlX2FkZHJl
c3Mob2JqKSkKPiAJCXJldHVybiAwOwo+ZGlmZiAtLWdpdCBhL21tL3NsdWIuYyBiL21tL3NsdWIu
Ywo+aW5kZXggODYyNjQyYzE2NWVkLi41Yzc2ZTU1ZWVlN2QgMTAwNjQ0Cj4tLS0gYS9tbS9zbHVi
LmMKPisrKyBiL21tL3NsdWIuYwo+QEAgLTIwNDEsMTggKzIwNDEsMTggQEAgc3RhdGljIGlubGlu
ZSB2b2lkIGRlY19zbGFic19ub2RlKHN0cnVjdCBrbWVtX2NhY2hlICpzLCBpbnQgbm9kZSwKPiAK
PiAjaWZkZWYgQ09ORklHX01FTV9BTExPQ19QUk9GSUxJTkdfREVCVUcKPiAKPi1zdGF0aWMgaW5s
aW5lIHZvaWQgbWFya19vYmpleHRzX2VtcHR5KHN0cnVjdCBzbGFib2JqX2V4dCAqb2JqX2V4dHMp
Cj4rc3RhdGljIGlubGluZSB2b2lkIG1hcmtfb2JqZXh0c19lbXB0eShjb25zdCB2b2lkICpvYmop
Cj4gewo+LQlzdHJ1Y3Qgc2xhYiAqb2JqX2V4dHNfc2xhYjsKPisJc3RydWN0IHNsYWIgKm9ial9z
bGFiOwo+IAl1bnNpZ25lZCBsb25nIHNsYWJfZXh0czsKPiAKPi0Jb2JqX2V4dHNfc2xhYiA9IHZp
cnRfdG9fc2xhYihvYmpfZXh0cyk7Cj4tCXNsYWJfZXh0cyA9IHNsYWJfb2JqX2V4dHMob2JqX2V4
dHNfc2xhYik7Cj4rCW9ial9zbGFiID0gdmlydF90b19zbGFiKG9iaik7Cj4rCXNsYWJfZXh0cyA9
IHNsYWJfb2JqX2V4dHMob2JqX3NsYWIpOwo+IAlpZiAoc2xhYl9leHRzKSB7Cj4gCQlnZXRfc2xh
Yl9vYmpfZXh0cyhzbGFiX2V4dHMpOwo+LQkJdW5zaWduZWQgaW50IG9mZnMgPSBvYmpfdG9faW5k
ZXgob2JqX2V4dHNfc2xhYi0+c2xhYl9jYWNoZSwKPi0JCQkJCQkgb2JqX2V4dHNfc2xhYiwgb2Jq
X2V4dHMpOwo+LQkJc3RydWN0IHNsYWJvYmpfZXh0ICpleHQgPSBzbGFiX29ial9leHQob2JqX2V4
dHNfc2xhYiwKPisJCXVuc2lnbmVkIGludCBvZmZzID0gb2JqX3RvX2luZGV4KG9ial9zbGFiLT5z
bGFiX2NhY2hlLAo+KwkJCQkJCSBvYmpfc2xhYiwgb2JqKTsKPisJCXN0cnVjdCBzbGFib2JqX2V4
dCAqZXh0ID0gc2xhYl9vYmpfZXh0KG9ial9zbGFiLAo+IAkJCQkJCSAgICAgICBzbGFiX2V4dHMs
IG9mZnMpOwo+IAo+IAkJaWYgKHVubGlrZWx5KGlzX2NvZGV0YWdfZW1wdHkoJmV4dC0+cmVmKSkp
IHsKPkBAIC0yMDkwLDcgKzIwOTAsNyBAQCBzdGF0aWMgaW5saW5lIHZvaWQgaGFuZGxlX2ZhaWxl
ZF9vYmpleHRzX2FsbG9jKHVuc2lnbmVkIGxvbmcgb2JqX2V4dHMsCj4gCj4gI2Vsc2UgLyogQ09O
RklHX01FTV9BTExPQ19QUk9GSUxJTkdfREVCVUcgKi8KPiAKPi1zdGF0aWMgaW5saW5lIHZvaWQg
bWFya19vYmpleHRzX2VtcHR5KHN0cnVjdCBzbGFib2JqX2V4dCAqb2JqX2V4dHMpIHt9Cj4rc3Rh
dGljIGlubGluZSB2b2lkIG1hcmtfb2JqZXh0c19lbXB0eShjb25zdCB2b2lkICpvYmopIHt9Cj4g
c3RhdGljIGlubGluZSBib29sIG1hcmtfZmFpbGVkX29iamV4dHNfYWxsb2Moc3RydWN0IHNsYWIg
KnNsYWIpIHsgcmV0dXJuIGZhbHNlOyB9Cj4gc3RhdGljIGlubGluZSB2b2lkIGhhbmRsZV9mYWls
ZWRfb2JqZXh0c19hbGxvYyh1bnNpZ25lZCBsb25nIG9ial9leHRzLAo+IAkJCXN0cnVjdCBzbGFi
b2JqX2V4dCAqdmVjLCB1bnNpZ25lZCBpbnQgb2JqZWN0cykge30KPkBAIC0yMzEyLDYgKzIzMTIs
MTAgQEAgc3RhdGljIHZvaWQgYWxsb2Nfc2xhYl9vYmpfZXh0c19lYXJseShzdHJ1Y3Qga21lbV9j
YWNoZSAqcywgc3RydWN0IHNsYWIgKnNsYWIpCj4gCj4gI2Vsc2UgLyogQ09ORklHX1NMQUJfT0JK
X0VYVCAqLwo+IAo+K3N0YXRpYyBpbmxpbmUgdm9pZCBtYXJrX29iamV4dHNfZW1wdHkoY29uc3Qg
dm9pZCAqb2JqKQo+K3sKPit9Cj4rCj4gc3RhdGljIGlubGluZSB2b2lkIGluaXRfc2xhYl9vYmpf
ZXh0cyhzdHJ1Y3Qgc2xhYiAqc2xhYikKPiB7Cj4gfQo+QEAgLTI3ODMsNiArMjc4Nyw5IEBAIHN0
YXRpYyBpbmxpbmUgc3RydWN0IHNsYWJfc2hlYWYgKmFsbG9jX2VtcHR5X3NoZWFmKHN0cnVjdCBr
bWVtX2NhY2hlICpzLAo+IAo+IHN0YXRpYyB2b2lkIGZyZWVfZW1wdHlfc2hlYWYoc3RydWN0IGtt
ZW1fY2FjaGUgKnMsIHN0cnVjdCBzbGFiX3NoZWFmICpzaGVhZikKPiB7Cj4rCWlmIChzLT5mbGFn
cyAmIFNMQUJfS01BTExPQykKPisJCW1hcmtfb2JqZXh0c19lbXB0eShzaGVhZik7Cj4rCj4gCWtm
cmVlKHNoZWFmKTsKPiAKPiAJc3RhdChzLCBTSEVBRl9GUkVFKTsKPgo+YmFzZS1jb21taXQ6IDdk
ZmY5OWIzNTQ2MDFkZDAxODI5ZTE1MTE3MTE4NDZlMDQzNDBhNjkKPi0tIAo+Mi41My4wLjQxNC5n
ZjdlOWY2YzIwNS1nb29nCgpUZXN0ZWQtYnk6IERhdmlkIFdhbmcgPDAwMTA3MDgyQDE2My5jb20+
CgoKRGF2aWQK

