Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C8DCA0EFF
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 02:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EB38E0002; Sun, 24 Aug 2025 22:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E367D8E0001; Sun, 24 Aug 2025 22:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CA08E0002; Sun, 24 Aug 2025 22:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C06398E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 22:28:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D0B1160231
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:28:12 +0000 (UTC)
X-FDA: 83813695224.15.71C1882
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FCFE20008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 02:28:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf13.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756088890; a=rsa-sha256;
	cv=none;
	b=O4kspBw2melV2cr917YABaua2+6yi6rO49KZiTm5KF6HA7Of7HjBtTioQZax+y51tib2NU
	6VZzKgjsYO6qODZpdjugP6kMvlazG0YWa1uyhGGUlMeRtZPpKfr7tRRBBd2u2KnksL9jSw
	v5rhR8jdHmjjdv4vQZAcY5wA8yAVH/I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=baidu.com;
	spf=pass (imf13.hostedemail.com: domain of lirongqing@baidu.com designates 220.181.50.185 as permitted sender) smtp.mailfrom=lirongqing@baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756088890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=7fCCuMgtgCwFugKYlGknU1YQmGykr3blxZBGdiTWGqk=;
	b=V2Uc6rwVQobttcrS4G3LbxDUPy+4FobaC/0njyQUJKkts8fzxjyYyTkC1CJwOZKovoLXE7
	4TNeIxx3xJMaSQgaA0/fHpdHekZ7g6LR6Rna1j42xoKpdXI9UQRqxbuw91RPBDmgefld6T
	yHINGyRI/WV1kUvz4ZQMhHcbGxp08rU=
From: "Li,Rongqing" <lirongqing@baidu.com>
To: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"muchun.song@linux.dev" <muchun.song@linux.dev>, "osalvador@suse.de"
	<osalvador@suse.de>, "Xu,Wenjie(ACG CCN)" <xuwenjie04@baidu.com>
Subject: RE:  Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Thread-Topic: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Thread-Index: AdwVZvlMyZG+t/+FSoO+KsNcdGLEBA==
Date: Mon, 25 Aug 2025 02:27:58 +0000
Message-ID: <5516a0e446294c158492c410100f4bc9@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.127.72.30]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-FEAS-Client-IP: 172.31.51.14
X-FE-Policy-ID: 52:10:53:SYSTEM
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FCFE20008
X-Stat-Signature: kn1xbu3d84gfctp4si4nhcijobddap17
X-HE-Tag: 1756088887-174387
X-HE-Meta: U2FsdGVkX1/hvhBH5bXQyDkntNRsmfmrqHJtQUBQS0bSA8rV091QNia/FVQlQBWK/STyOxcLPWfscxBGr3nWkwINEVQqjy2DKvcFJ+o9D9HILCEa59kjq13NGExWjbBTxveyyzkAtPBiDNUxB67ZCXTY5xc1eVt7/WfSYlGMMbnpX96yg4YaL3aVCnR2pHLu4eXjsBvAKZ5nwqzk0VifRSmsXjbKP+E7BtkYpMQi3cJhRgx9bnDESf9rZzyjFFPBlK7wleTmfe6R84ITBATypUdP/VtCdZjba3l8R4RslUmo4fbw9DYw+WZ25iOmtNf2tUxTSWlqhlnBEbAkHZ05/JAKuqow4qYJRHjsyyduDBtPkIeQkMR9as7F3ysdjhh0QVrRcv1e6BHixO5EFwKejhosGLCecQWDaGZXSoQ2BJVjk18zsm+2A/HX4NxJEvISvOj0Ey/6XXkyKrlNtN+eTaF1S1lva79L/WovPVP9j/0NycfR/rSCwdQsFO5li6FhfD1yPuqiEAgHNjbrLzq/4ZofyUWBQ9nzGf5MNDJeanNbsTqkK6hB1PrlOwXvwccAnZLASyWq7YRxCFBjjYBOkZl+X0NC8i49hGcdS6PaaC6hS+c+ZP0k6Ci3b5FoOXidXH/KTUw/OSt63oXaUYfFrxFgslEx0OSK4ITNCWtiiOh3Q7eEB/oRjN//lSiWhSa0cAfWKRjHdpF2dMuZ+ju+FuYcMr6hZ7/1cyeiz0uz8OptKVjO+VHjV9HsWydfxaaCaXgwPckx5WkhT19K0wLqCmz2xxNy6xoMRKdq9EnSwewtsod9XDFW33t9DQNUbuv2MBg9j3sxsqFdnB3Y66oS/z4b440fkNAIXjTj4irFfgtWeH+ucMlCjsxL21ybYxWgpAjM6ifeOk/CHdFb3hLjiGc0fEUJSmdg5kgq5MEO+kv24gOFMNEsdcKjF6FdIPA1Ks6w8KqLVN8G+MVQbCV
 0nwfTYNa
 fMeBNgdN3Ouqsvm7xEknR9vvrS+/Zw5vRwXpwPYq1TkxTPzdRnMr/ETHTqUSv6baSGYmCBdIODSgVnvrRCa5IuYr6ANuClWMq3eooRb2GyN8EK2FNpQ6QfZ6C/6yrEQPQpccOrFqeBOjfLHGyFy/1pK/KhRdAJ+0AV1gBu3eqjQmKxfjP61LnmrQe5X3MIlWx9AqGlnpz/IRf48fesNRRoFBm/jimVaK5IeamQUaP/Xe6orkan1CwFUYGdJjPPyMhWO3LCTBzWPM2ZQK7TSdITpYzKZ5de/lxcONr1e6ZBKlgoF1AdbZAkEqgv7y97aYF61yTgwx9luxx3FM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000048, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiANCj4gSGkgdGhlcmUuIFRoZSA5MCUgc3BsaXQgaXMgc29saWQuIFdvdWxkIGl0IG1ha2Ugc2Vu
c2UgdG8gKGEpIGxvZyBhIG9uZS10aW1lDQo+IHdhcm5pbmcgaWYgdGhlIHNlY29uZCBwYXNzIGlz
IHRyaWdnZXJlZCwgc28gb3BlcmF0b3JzIGtub3cgd2h5IGJvb3Qgc2xvd2VkLA0KDQpPaw0KDQo+
IGFuZCAoYikgbWFrZSB0aGUgOTAlIGNhcCBhIEtjb25maWcgZGVmYXVsdCByYXRpbywgc28gZGlz
dHJvcyBjYW4gbG93ZXIgaXQNCj4gd2l0aG91dCBwYXRjaGluZz8gQm90aCBhcmUgbG93LXJpc2sg
YW5kIGRvbuKAmXQgY2hhbmdlIHRoZSBBQkkNCj4NCg0KSSB0aGluayBpdCBpcyBiZXR0ZXIgdG8g
YWRkIGEgY21kbGluZSBvcHRpb24NCg0KLUxpDQoNCg0K

