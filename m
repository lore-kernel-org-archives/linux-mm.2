Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA28C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 12:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C720C6B0098; Tue, 21 Jul 2026 08:39:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD4886B0099; Tue, 21 Jul 2026 08:39:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78146B009B; Tue, 21 Jul 2026 08:39:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77EED6B0098
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 08:39:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1C7DD1C0029
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:39:16 +0000 (UTC)
X-FDA: 85012739112.13.51C8C0C
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4629880003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:39:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of chengfenglin@stu.xmu.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=chengfenglin@stu.xmu.edu.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784637554;
	b=5DTavaiQcwHcCOWRI4zEUmzQr82V+kCWe8dPUpWaNTOzyXuMSlGuCFPZxo8B21N4r6Hlxm
	487mxFUc6bdadUQduLrEczCWSpSdsd0UOxarIzqBOrX303C7E7hgHzJF4Rx6XssAQ1Y1ys
	IVTU1a9wXmIjjPOT8lLvg+ox5C8hlMM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of chengfenglin@stu.xmu.edu.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=chengfenglin@stu.xmu.edu.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784637554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J9o7MHeYrhqvMtTxAxjODO81wUU1IlSjmrdACYphAuk=;
	b=wu5ITj5f2y9Y1X9IVBNECCdHw31fbcxUBTLej4ZZGdEJx5k2J+84snBXQERdRfTRCNIL8V
	eIO5A74k9KNYTWg1WzUB6VD8JXdGHoJwfYAF+3Q3OHk3GlkfOJ92N3qJWynntOgeLSu74h
	bp3RKrC2UxBhnJQpAnFZQ1Do7p1AsNo=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-6 (Coremail) with UTF8SMTP id AQAAfwA3GJloaF9qMU8yAA--.18095S2;
	Tue, 21 Jul 2026 20:39:04 +0800 (CST)
Received: from chengfenglin$stu.xmu.edu.cn ( [23.249.17.80] ) by
 ajax-webmail-mail (Coremail) ; Tue, 21 Jul 2026 20:39:01 +0800 (GMT+08:00)
X-Originating-IP: [23.249.17.80]
Date: Tue, 21 Jul 2026 20:39:01 +0800 (GMT+08:00)
X-CM-HeaderCharset: UTF-8
From: "Chengfeng Lin" <chengfenglin@stu.xmu.edu.cn>
To: "Pedro Falcato" <pfalcato@suse.de>,
	"Andrew Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: "Liam R. Howlett" <liam@infradead.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Jann Horn" <jannh@google.com>, linux-kernel@vger.kernel.org,
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] mm/mprotect: shared-dirty base-page toggle slower
 since v6.17
X-Priority: 3
X-Mailer: Coremail Webmail Server Version 2025.3-cmXT6 build
 20260202(ad063891) Copyright (c) 2002-2026 www.mailtech.cn OP_ICM_ICMVM
In-Reply-To: <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
References: <7c9eeb21.1c04f.19efaacbb2f.Coremail.chengfenglin@stu.xmu.edu.cn>
 <433d619a.1e8a6.19f1d4d1be6.Coremail.chengfenglin@stu.xmu.edu.cn>
X-CM-CTRLMSGS: =?B?+TW9bjiH6nJ5xwDR7hwMki1N8jM=
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <6c8d9b6c.24a8b.19f84afccdd.Coremail.chengfenglin@stu.xmu.edu.cn>
X-Coremail-Locale: zh_CN
X-CM-TRANSID:AQAAfwAXMvNlaF9qBIjCAA--.14436W
X-CM-SenderInfo: astqjiysvrikiuszmqhvwxh5lpxovvfxof0/1tbiAQALEGpZQDgCZ
	QAFsz
X-Coremail-Antispam: 1Uk129KBjvJXoW7uw1DWry7WF1rXw17Gw4rXwb_yoW8Cw1DpF
	ZxCry5Gr4kCw1jy392van7WrWrCr93Ja15Jrs5K34xZas8GF9FyrWSy3W8ZF4jgr10v34Y
	vrs8Kw17Jrs8uaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Stat-Signature: qdwzkifebpen41k3tbeuop4n1bkgtw1c
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4629880003
X-Rspam-User: 
X-HE-Tag: 1784637552-610191
X-HE-Meta: U2FsdGVkX1/7E0AGPKpw/9RbSfv6y7MepenQMDkmJ5DimwaCJXxeCZO721sy1VbrUtF0kIoUCVDWv69QtNjdCWnxT0o5KrYMhneT3Y0c5MbTs7pfYoKqKx5xqw4ZWwC1+5C5Ba+bzjiF+NTKM68XWYT4+kEhaw5baCQIa2uANSwAIP7PKfaFCAh4/oWhN+HD6ZczOVFyq/EiXTDauilaufJ4HWtHcWJvrLlF+p2SLFPJPoWLKLfuDp71pZgIe6cD/q1aCZJx53fU2u/adH7Gq9SqOwYMt1atRRFmD9t8BTYWLZVFxKKWQJy29J93E+2uTqOiD4nXBHkWWfYZAWCl2gkNrOXBI+NWYa0paK4GrNoGQLddB8ojLSTZMBoVKBdmZDas7vmZ5ccS7XkvV6Fo4eARCZWH9W+YzCFYN/bRnZtHq4VpYeHPuTLLYUIY1WUZvD9ovF+S8tT73cY1mKtTQt1PT0A1ghdVfZzkHYdsyNJ9g7cqLahRFG8787RhdDFv7mECoyy4IFMEVuFXwpcgimj/MngQ9oVwAB97DaeIvhjiOQSQsh0AxfBEJAMRBiKzmmAgYHxO3KWlICAfgNH5+HuMQAb/Xbjk7jwRnk7hsRpE5t8Maztgyde+wm+n2d46NsMZl9FJ8ppj0OeaA3igeMRkSTNXPduaJjmrpWqMG+hLK+WLcbznOhwAEdHC4BfhPRmoc5foLr7/Ty2wH1VrdoGN1KFTYRm2FfI3NbQ249pgBR83HiKUwiVAQPTrNUbPeQSxc+X7HphYGj3vi1P/RdS3xribsIILcvuLh5Vn2V60TwBV+Zm3Kfsunk67ae6KJpR63l0D//rKiZYcFdh3GidjcEI4erYFt/SNnFITHvlAb5FzniQdkQR3z5ovzdVFeYFMEegQK3YbHLilsDgrTb8kr4gjE64m3qONgC6WmLkvhWrRhb49bdRoT/ape6X3E7dVMWpW3c9mAmTSz/x
 BQSBgyZN
 GQM5aobd/fhQ2xYQsb2Ny6L6TV8pTUwM6vbvnHfEOpVqeSIA8JOTm4iUnqiEWr0yzK0QScXdH2PrfkSYJRhyjAcFB5HfU1orYjwYVWRA6tzMsw6uAj99NvBCrF/2F8BEHpqA6DqjVpB5Ka1Y2C3iipiHHCunmA9o/m0H7QSay4w0FF4N3nXfcnVGutVz9udpUGOWVK5rjDppZzOhw5cKhvpjifVz+4ahzJaFT0Jki6aAgctjU9dYLA0xWCDnxcNWieB7lBi3+5pMG2voUgcBbT4hi+7ISDJOtmYJmHvqG74VEWzaCZ/ixdhdVz0V9TjtQqe+7B3aukEzFd0NSlNDOa8KvEJ3YpTHiHaA5bhLeX7HU16w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGksCgpKdXN0IGEgZ2VudGxlIHBpbmcsIHdpdGggcmVzdWx0cyBmcm9tIGFuIGV4YWN0IGNvbW1p
dC1sZXZlbCBjaGVjay4KCkkgdGVzdGVkIGNhYzFkYjhjM2FhZCAoIm1tOiBvcHRpbWl6ZSBtcHJv
dGVjdCgpIGJ5IFBURSBiYXRjaGluZyIpCmFnYWluc3QgaXRzIGRpcmVjdCBwYXJlbnQgNDUxOTlm
NzE1Yjc0LiBFYWNoIHBvaW50IHVzZWQgYSBmcmVzaCBib290OgoKICA0NTE5OWY3MTViNzQgcGFy
ZW50IEEgLT4gY2FjMWRiOGMzYWFkIGNoaWxkIC0+CiAgNDUxOTlmNzE1Yjc0IHBhcmVudCBCCgpJ
IHVzZWQgdGhlIHNhbWUgbmFycm93IDY0IE1pQiBzaGFyZWQtZGlydHkgNCBLaUIgYmFzZS1wYWdl
IHRvZ2dsZQp3b3JrbG9hZCBmcm9tIHRoZSByZXBvcnQuIEVhY2ggcG9pbnQgaGFkIDMgd2FybS11
cCBwcm9jZXNzZXMgYW5kCjE1IG1lYXN1cmVkIHByb2Nlc3Nlcy4gRWFjaCBtZWFzdXJlZCBwcm9j
ZXNzIHJhbiAxLDAwMCBpdGVyYXRpb25zLgpUaGUgcHJpbWFyeSByZXN1bHQsIGl0ZXJhdGlvbl9u
c19wZXJfcGFnZSAobG93ZXIgaXMgYmV0dGVyKSwgd2FzOgoKICBwb2ludCAgICAgICBtZWFuIG5z
L3BhZ2UgICAgU0QKICBwYXJlbnQgQSAgICAgICAgICAzOC4xMzMgIDAuNzQzCiAgY2hpbGQgICAg
ICAgICAgICAgNTMuNTMzICAwLjUxNgogIHBhcmVudCBCICAgICAgICAgIDM4LjQ2NyAgMC42NDAK
ClRoZSBwYXJlbnQgbWlkcG9pbnQgd2FzIDM4LjMwMCBucy9wYWdlLiBUaGUgY2hpbGQgd2FzIDM5
Ljc3JSBzbG93ZXIsCndoaWxlIHBhcmVudCBCIGRpZmZlcmVkIGZyb20gcGFyZW50IEEgYnkgb25s
eSAwLjg3JS4gRHJvcHBpbmcgdGhlIGZpcnN0Cm1lYXN1cmVkIHByb2Nlc3MgZnJvbSBldmVyeSBw
b2ludCBsZWZ0IGEgMzkuNTMlIGNoaWxkIGRlbHRhLgoKQWxsIDQ1IG1lYXN1cmVkIHByb2Nlc3Nl
cyBwYXNzZWQgdGhlIHNlbWFudGljIGNoZWNrcyBhbmQgdXNlZCA0IEtpQgpwYWdlcyB3aXRoIG5v
IFRIUC4gVGhlIHByb3RlY3QgYW5kIHJlc3RvcmUgY29tcG9uZW50cyBlYWNoIGluY3JlYXNlZApm
cm9tIDEzIG5zL3BhZ2UgaW4gdGhlIHBhcmVudCBjb250cm9scyB0byAyMCBucy9wYWdlIGluIHRo
ZSBjaGlsZC4KVGhlIHBvc3QtdG91Y2ggY29tcG9uZW50IHN0YXllZCBjbG9zZSB0byAxMiBucy9w
YWdlLgoKVGhlIGV4YWN0IGNvbW1pdCBjaGFuZ2VzIG9ubHkgbW0vbXByb3RlY3QuYy4gQm90aCBr
ZXJuZWxzIHdlcmUgYnVpbHQgZnJvbQp0aGUgZXhhY3QgY29tbWl0cyB3aXRoIHRoZSBzYW1lIG5v
cm1hbGl6ZWQgY29uZmlnLCBHQ0MgMTUuMi4wLCBhbmQgS2J1aWxkCm1ldGFkYXRhLiBFdmVyeSBw
b2ludCB1c2VkIHRoZSBzYW1lIENQVSBzZXR0aW5ncyBhbmQgcnVudGltZSBwcmVlbXB0PW5vbmUu
CgpGb3IgdGhpcyBuYXJyb3cgd29ya2xvYWQsIHRoZSBleGFjdCBwYXJlbnQvY2hpbGQgcmVzdWx0
IGlkZW50aWZpZXMKY2FjMWRiOGMzYWFkIGFzIHRoZSBzb3VyY2Ugb2YgdGhlIG1lYXN1cmVkIHNs
b3dkb3duLiBJIGFtIG5vdCBjbGFpbWluZwphIGdlbmVyaWMgbXByb3RlY3QoKSBvciBhcHBsaWNh
dGlvbi1sZXZlbCByZWdyZXNzaW9uLgoKRXZpZGVuY2U6CgogIGh0dHBzOi8vZ2l0aHViLmNvbS9s
Y2YwMzk5L2xpbnV4LXJlZ3Jlc3Npb24tZXZpZGVuY2UvdHJlZS9hM2FlN2JmMWE1MGU0ZDg4YjU3
MmM2MDA1YTAzNzY3OTUzMGM5YjFmL21wcm90ZWN0LXNoYXJlZC1kaXJ0eS10b2dnbGUvYmFyZS1t
ZXRhbC8yMDI2MDcyMS1jYWMxZGI4YzNhYWQtZXhhY3QtYWIKCiNyZWd6Ym90IGludHJvZHVjZWQ6
IGNhYzFkYjhjM2FhZDk3ZDZmZmI1NmNlZDg4NjhkNmNiYmJkMmJmYmUKCklmIHVzZWZ1bCwgSSBj
YW4gc3RpbGwgY29sbGVjdCBhIHBlcmYgcHJvZmlsZSBvZiB0aGUgY2hpbGQgYXJvdW5kCmNoYW5n
ZV9wdGVfcmFuZ2UoKS4KClRoYW5rcywKQ2hlbmdmZW5nCg==


