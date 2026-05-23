Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77AFECD5BB3
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:11:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02B3D6B0093; Fri, 22 May 2026 20:11:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7326B0095; Fri, 22 May 2026 20:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7216B0096; Fri, 22 May 2026 20:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C892F6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:11:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 648CB1A0849
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:11:14 +0000 (UTC)
X-FDA: 84796754868.25.F444083
Received: from outbound.baidu.com (mx14.baidu.com [220.181.3.101])
	by imf17.hostedemail.com (Postfix) with SMTP id 2F8EA40006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:11:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=fPnDdM+e;
	spf=pass (imf17.hostedemail.com: domain of "prvs=md159743950B=lirongqing@baidu.com" designates 220.181.3.101 as permitted sender) smtp.mailfrom="prvs=md159743950B=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0y3/20jeT3QLPjOmlySstDdGDYESAdmWP7j9Sn9QlsU=;
	b=mFmGTHosYBzIN1NAB6zHPu8NydEaJpp6Jq69Z6hStkckEL+1edoLZK1JRqcDpshDywZPdP
	UzaOC0xkzyknCshGMKrjxNQZy/zFe17cH9f3ihKcl92UbKlanP4JEEksrB+otCJ9zkHtfR
	IRfbRhgeJuYDSG0ZS1R+Y4FKmlO1g7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495072; a=rsa-sha256;
	cv=none;
	b=aIJNVmLwe8L+ixxmmuWkG+q8bkYeUxDjiJZMehDB3o7B9lNRul6Cj1hjSDnfwP0xfbB5HC
	9NIcB6vFXBzphACttBHfPiYRqJm8DrqJL+s7E3FgQM3JEHw0CydJl3wPNXFpdpyMDnSb8u
	GxMJrqxvovRv039VQEjUBKsEBhvEFWo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=fPnDdM+e;
	spf=pass (imf17.hostedemail.com: domain of "prvs=md159743950B=lirongqing@baidu.com" designates 220.181.3.101 as permitted sender) smtp.mailfrom="prvs=md159743950B=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.46
From: "Li,Rongqing(ACG CCN)" <lirongqing@baidu.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Harry Yoo
	<harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
Subject: =?utf-8?B?562U5aSNOiBb5aSW6YOo6YKu5Lu2XSBSZTogW1BBVENIXSBtbS9kbWFwb29s?=
 =?utf-8?Q?:_remove_redundant_DMAPOOL=5FDEBUG_macro?=
Thread-Topic: =?utf-8?B?W+WklumDqOmCruS7tl0gUmU6IFtQQVRDSF0gbW0vZG1hcG9vbDogcmVtb3Zl?=
 =?utf-8?Q?_redundant_DMAPOOL=5FDEBUG_macro?=
Thread-Index: AQHc6dlHSaeMnrsdT0Sxfvis9oS89bYZYAAAgAFdPuA=
Date: Sat, 23 May 2026 00:10:51 +0000
Message-ID: <3a5a50fe429b47d19d5f458ed89eebc9@baidu.com>
References: <20260522105346.2215-1-lirongqing@baidu.com>
 <6ba62058-e5f8-4212-b1a8-56047b4977db@kernel.org>
In-Reply-To: <6ba62058-e5f8-4212-b1a8-56047b4977db@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.31.62.13]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1779495064;
	bh=0y3/20jeT3QLPjOmlySstDdGDYESAdmWP7j9Sn9QlsU=;
	h=From:To:Subject:Date:Message-ID:Content-Type;
	b=fPnDdM+e93T9T7GZdJW2yyUaGKfdkWyibUc9uw4o849u5x9+jDRqlSns0K+BqWZs/
	 Hd1tN/RuoRS6JoEbUvwZRMc2ehH4YO3GlX+xFfO11GSP+GfytW5CJZ70xiyHw7XrJx
	 TtheJBa0vatsGRIVp3Hokd1K5bxswkqyJH/9wWzc+a87G4Sj6p8DVt/T/4JRwVFYkP
	 NaEww3nKIvTDBOlUhSl+qFZgSJ5PpYADAuh8i5ueiHdnb0jwgbChi7E6324W+4hhsX
	 A2v7Ae76EqAjLSTmCkWgLDw/ebGkbTcGYA6MWp26kqtq287bFuwg1HIoCl/2UTytnJ
	 pXo3jQv2/Dxwg==
X-Rspamd-Server: rspam11
X-Stat-Signature: w86jjn1jymqu576xu4iw976fppjinzdd
X-Rspamd-Queue-Id: 2F8EA40006
X-Rspam-User: 
X-HE-Tag: 1779495068-104994
X-HE-Meta: U2FsdGVkX18g1rE39EC+rRAOBBp0kwteSKeap0fDVzFyaINyNqMYuee+zJ45ii7eJUcPS8gRiZi/kk/WN0Kcc+6E7W2cNQcNQrWBRuah2P4Z7wismU4rqurzt/G3cmm3WEJMtvaR1xkZ8ShtGv8HmQ5UZwhQW5i1M8sYfYIzgvAmWkzlNyRkRuI10o5e2opcXU/MgSjY0B7XmVD/JUyMu2edyiBJ8F1xDbnEW9pab0MmvsE6qi8D0arKYdEbpLCeRi0yhaqted8TnY0MuMPEZvYQQbMMoKhRIPwNS6lTcjeCLQKrx3pVhuD4rovc4JwVg0HaGZ292Hielq7J8pRbs9eWPN7t+lTa9trZ5bTxm9wzbEPP+/3hd/jHjrKx790awJmyPuYxsUUGYHlD4j/LP+2CfqfFb8cESZ64Ylbiy51SzoD0UTR4dAzP6o/gHwqjhSdnqDV6bIt7rrqDZQ/AsmLvX/mDXgNaLF7N98GyUBlML05ghg+qDMpmwAF+MAMrXc0VYTDIZvTWMR/cZIMnz4bXwr8Z2tjBcl//QCfcl4rZDcD+2v9KiBbPDQFaRaSGl6L52LGAh0M2h8T6tryXglVvMZCjmCtXY4a7IH32FU69X+KVN71FIiijeHW89hTk937zt5U6Bnz+dxNPZ4oLMMxE2owS7mUIMJbl0YALZL/XqjBLzUtafU6IAdHUhgnTn2Jy31Z3CVM+WMXoXj0R5hEfy3aaudMFKMOgIPFwMHXwC2jOkXw/6BnFEqjq23BNKjHpWQHOMkhZ3tfy28bzbj4vMaqCHZpDJ10x8hykVCjS/s91JRE3v8oT4I7ctDmwFxjIXTvnDYYmwrx3OsNP2stOMsr4hNprrvPqSrZJvjEp5SzUvJbGUd9i/sdeQLwpVnFqDkdYBrt/kZGhHJZvUQoaU8LJxJXfeaOKExgikWBzbA4G4NDvZPUshMWBydAQiuJv0wN6dpc4cXM6MSF
 AHLQ5ME0
 xA80sb3BvIM9e0X6PORVK+pJ6AE/kmUjORuhhBcNXkXVLGLDZmF3gSFqqR6ZAVPMOV9WXYAzmdyhyt3aWB2ifQN4SPYBTyWloIqW5TEznOu/QwYx5PAmWb3MJCL4qQ87R8XJzOBC+BQktwJJeIxyj8nw4qHb/xr0Xbn06ErUP0iA11i5mGOFSWCXIJm2UFETSnwEIwvi7b3rpoLdoydlY71xDv4PNgoWCwXtsOlyaoYkaWFGjISFuIv7BlFNkg+v/B+XOH5uHPTmmIyNPUnM6SqkjJXus1PHXDVqi3JsnBMTohcXWu/CrvRwam3MqknTcRnifG22/B2Vc9Wb78ty+CnV7ft3ZbH0Z+11MXYfMPg9ybJKmgBAoD5Gw6kv5ie+ho5lDxnRgJ0nhznkmgfM1w/L3MsNLCtFJpYuRjb0esQeWV6BeP3Yvpzr79rmRgp5P4kLagk9/s74KgU4adBSL4m9jcfNk6FQy7FuwXB89PU5Adh1kOcToulgq/9RPFi34Tt5BuC4C5CJHTx3GOONgkUm1a9RgdEkkqp8yStF/bD6u9Ie8GGh7PQQ6+JIMe+JLQ9JPr/m8JTsSC47UUrANUQXcGT/SDwAFnkHJVrNIPnA6ByltTKq9iz6vLuQ+amCHygYq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiANCj4gSSB0aGluayBhIG1vcmUgdXNlZnVsIGNoYW5nZSB3b3VsZCBiZSB0byByZW1vdmUgdGhl
IHVzYWdlIG9mDQo+IENPTkZJR19TTFVCX0RFQlVHX09OIGNvbXBsZXRlbHkgYW5kIHJhdGhlciAo
cmUpdXNlIGEgYm9vdCBvcHRpb24gdGhhdA0KPiB1c2VzIGEgc3RhdGljIGtleS4gQ09ORklHX1NM
VUJfREVCVUdfT04gaXMgb25seSB1c2VmdWwgZm9yIGJvdHMgcnVubmluZw0KPiByYW5kY29uZmln
cywgb3RoZXJ3aXNlIG5vcm1hbGx5IGZvciBkZWJ1Z2dpbmcgYSBzcGVjaWZpYyBwcm9ibGVtIG9u
ZQ0KPiBkb2Vzbid0IHdhbnQgdG8gcmVidWlsZCBhIGtlcm5lbCB3aXRoIENPTkZJR19TTFVCX0RF
QlVHX09OLCBidXQganVzdA0KPiByZWJvb3Qgd2l0aCBhIGJvb3Qgb3B0aW9uIHNsYWJfZGVidWdb
PS4uLl0gKGZvciBzbGFiIGl0c2VsZikgb3INCj4gZGVidWdfcGFnZWFsbG9jPW9uIGV0Yy4NCj4g
DQo+IChzYW1lIHRoaW5nIHNob3VsZCBiZSBkb25lIGZvciB0aGUgdXNhZ2UgaW4gbW0vbWVtcG9v
bC5jIGJ0dykNCg0KR29vZCBpZGVhLCBJIHdpbGwgc2VuZCB2Mg0KDQpUaGFua3MNCiANCg0KW0xp
LFJvbmdxaW5nXSANCg==

