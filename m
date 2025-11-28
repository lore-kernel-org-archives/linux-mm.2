Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32E32D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 07:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B46E6B0010; Fri, 28 Nov 2025 02:19:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E9C6B0022; Fri, 28 Nov 2025 02:19:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6064E6B0027; Fri, 28 Nov 2025 02:19:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4888E6B0010
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 02:19:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE217160488
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:19:09 +0000 (UTC)
X-FDA: 84159164418.07.A2D58C1
Received: from mta22.hihonor.com (mta22.honor.com [81.70.192.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7A3E51C000D
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 07:19:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="IzVfh/gL";
	spf=pass (imf21.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764314348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UD8lLk9lQrrraE2MEjqwZ/F6w1tL9dTzmGzaBm9Gjf8=;
	b=sFUb3pQAf9BSFxU8h4xpVKJPBFVJsDwuek+wKTzLgtqgTmyc2c4OTToRbL+GKWI7DZD26p
	BnAZO8ju89gcRZFJWhC5QHIeaF31n9NDfxZ67oizftMUbP7GNursK7rV2VhSyf2ozscqDb
	4EhGfLHW3RbbPC80ET7BTWP6vY5a33I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764314348; a=rsa-sha256;
	cv=none;
	b=T9uqgDWqJGuCLRnplWFBLY/1MqSRujNESWQpjQWf8cvBVU08/VoRroylyF4fG0Xtru7/dm
	+9NfTXVsx8LyKgBduuuZrNyUvbERiYY3j9ee929sOaevZaIfmo0Ann6oxS0Oi1rhN0iV//
	WDsq3jsadAGTrZR2zkt+hwDSeNkxTc8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="IzVfh/gL";
	spf=pass (imf21.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=UD8lLk9lQrrraE2MEjqwZ/F6w1tL9dTzmGzaBm9Gjf8=;
	b=IzVfh/gLVLxheXmRXbkEfFwl7gqGXCuI3oVa78TmLkanzJAd8M5uqW+/oJxEmPP41cSZZWz6I
	YPZthdU0pXTKr17z6k/nJUXp2DtAchGwYuZWHvR5iTAy3hQWkGLkMmoH86F5jp1JtgUNPDW86zN
	KrDRRzvdeQqTNdppUot//FY=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dHl3n6zfqzYl3Ls;
	Fri, 28 Nov 2025 15:17:09 +0800 (CST)
Received: from w009.hihonor.com (10.68.18.215) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 15:19:01 +0800
Received: from w002.hihonor.com (10.68.28.120) by w009.hihonor.com
 (10.68.18.215) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 28 Nov
 2025 15:19:00 +0800
Received: from w002.hihonor.com ([fe80::44a1:cc63:da29:b187]) by
 w002.hihonor.com ([fe80::44a1:cc63:da29:b187%14]) with mapi id
 15.02.1544.011; Fri, 28 Nov 2025 15:19:00 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Randy Dunlap <rdunlap@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>
CC: "mhocko@kernel.org" <mhocko@kernel.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/3] mm/lru_gen: add configuration option to select
 debugfs/procfs for lru_gen
Thread-Topic: [PATCH 2/3] mm/lru_gen: add configuration option to select
 debugfs/procfs for lru_gen
Thread-Index: AQHcYBJL4aaRxfOT9U6Z/I5UwCrlA7UG+f2AgAC0C4A=
Date: Fri, 28 Nov 2025 07:19:00 +0000
Message-ID: <7b24d6e38c9e46c4ae98211d5a815eb2@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <20251128025315.3520689-3-wangzicheng@honor.com>
 <040e35ca-848c-49cb-bd0c-f91f4a8e2c5d@infradead.org>
In-Reply-To: <040e35ca-848c-49cb-bd0c-f91f4a8e2c5d@infradead.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspamd-Queue-Id: 7A3E51C000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: ray5bhik9txew3rx8kjpx4aece1gfb4g
X-HE-Tag: 1764314346-236532
X-HE-Meta: U2FsdGVkX19z2WDyxkUJyEU/2jAjfqA+SMksHCDHUktfdNta8FfR9p36EoZ3ZRaQnHwXaP24C1ppWxCkCoy4sC7I/G14kyGdvWisiFt3zS17WJ1FnLEWto7TYEW+52WZVz1ulVRhxGPuO3A5Jdr5nOhMO6pM89Z9s4VZ0JjkFZt+y6l84QBm9goYCczlcxrktGzGuI0rNqumbXoNYLX3zqTddjpc5VvLMFa7qM/zcvBRywwAkiJWrHmFubpShU7efw/mgNtuwd+1TiL0shWu+1TfVUQQBllaDseia4QX2niWSlycgkzZ/gVMLOkeLXwMwCBb+f59qoC6wv82NAgHXV49/yXFwy0EoCU3tmYme2TmIywdQWULM0IRsHyI5GK7C6dGrHWvCnEl2BSU8S1KBsTgMZVGPf6uPm7Zzb147ZsXOk2iQpZ4MXaBW5AwWRk+iTH8u/1BgaGmon5ry/SzY21tRmVkHZf1hxT7bimHtqU9TaEEHGZ/1GASwX9Y9r+3tMfqAvedYaKpvnk/jxzOHXIp3BEtFLIOJnEdyZXytN4o6jCHlEucKu0k4lSrJYDSFXbRzepGU7VGOzq/O2Tbu4AlEHIc1jlxsGotKybYeTKyqM+ncKlAfp0agyL4Oop77JnWOR6GOy/r4ZWpXqvuIY045jmT5Km7rRPpgm/HysG/V0zGI1GxxrP/7/mWpdzLoiCbIYAi5wuWCL4ri6Anxv6jdpIRIMa2Ju1+TGtMxeUrnQ5WFSJWPBXUdf4+6sj1/cimnJ52L3Y4RJr2I6KRIf8dTbx36CeuG10mQqyvDQubKMo0rOWB+bnESsIraYClP6OnW3iL7AeWurZljqJs7A5yE5lbVmeJ53ajn61+vLElBrkuU2MoLReBIqfMzhzxTYt5FZZ6k7ANx72ccHWSDVJSzxEmIofzabTdAog2/xWllFpontHh6GMXnaZkEM9o08C/Lw/HenxY+inMdaa
 2NERV0NQ
 9MFCft839EPdc+VNIhmwx9xANYUFOk68aMhjP1hbvwnBK768IPnikbD1MhyNfBT+AaC1v9YBAp8Xm/iY0/DijYA8kZlX7n2NX5amwBbHGavM7vSm6sdZJi4dbiDNIB3eDNDKC1HdTjnjeKrlQ7PPIYPWxFxzrIhASEL6gSDCSFGbQLDBo+y4RzGnRCZUbrBEy1NHBiHkrKiWVB9Q/drtzO/YoZfqqYN8xVa7+kB6eR8Ju1tmoR+xtPUfF+/pDwL2790QmVNa8fLv2Zndox7AmkwOO4Q2DryoAS0BRZyuBZ2KfdzIFd2RenlhMXLImxkbjSHu6hHD/TW+Bj6QIN5vuJZeQciBE6XqYNjN48Sm/04lCxrUQfE13ViIty9Smej5kAz9GILonF1QCZfOunF4NpMPH1XpfPQN+BwYmKVO+mXCk6aGNiHNXJoMB6ghfMn+ORkCRYH6a/WWyx3T8gC24TOk9zn12AD4ESSyvDgiWukncoqvCSIe8XOEagrZFacfITHqNVYWiFwtCGN7ndeUYEw4TS2iTr/BUbwkoUj4W5DzAa5w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiAxMS8yNy8yNSA2OjUzIFBNLCBaaWNoZW5nIFdhbmcgd3JvdGU6DQo+ID4gU2lnbmVkLW9m
Zi1ieTogWmljaGVuZyBXYW5nIDx3YW5nemljaGVuZ0Bob25vci5jb20+DQo+ID4gLS0tDQo+ID4g
IG1tL0tjb25maWcgfCAxMCArKysrKysrKysrDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNl
cnRpb25zKCspDQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvbW0vS2NvbmZpZyBiL21tL0tjb25maWcN
Cj4gPiBpbmRleCBlNDQzZmU4Y2QuLmJlN2VmYTc5NCAxMDA2NDQNCj4gPiAtLS0gYS9tbS9LY29u
ZmlnDQo+ID4gKysrIGIvbW0vS2NvbmZpZw0KPiA+IEBAIC0xMzI1LDYgKzEzMjUsMTYgQEAgY29u
ZmlnIExSVV9HRU5fU1RBVFMNCj4gPiAgY29uZmlnIExSVV9HRU5fV0FMS1NfTU1VDQo+ID4gIAlk
ZWZfYm9vbCB5DQo+ID4gIAlkZXBlbmRzIG9uIExSVV9HRU4gJiYgQVJDSF9IQVNfSFdfUFRFX1lP
VU5HDQo+ID4gKw0KPiA+ICtjb25maWcgTFJVX0dFTl9QUk9DRlNfQ1RSTA0KPiA+ICsJYm9vbCAi
TW92ZSBscnVfZ2VuIGZpbGVzIGZyb20gZGVidWdmcyB0byBwcm9jZnMiDQo+ID4gKwlkZXBlbmRz
IG9uIExSVV9HRU4gJiYgUFJPQ19GUw0KPiA+ICsJaGVscA0KPiA+ICsJICBNb3ZlIGxydV9nZW4g
bWFuYWdlbWVudCBmcm9tIGRlYnVnZnMgdG8gcHJvY2ZzICgvcHJvYy9scnVfZ2VuKS4NCj4gPiAr
CSAgVGhpcyBwcm9kdWN0aW9uLXJlYWR5IGZlYXR1cmUgcHJvdmlkZXMgY3JpdGljYWwgbWVtb3J5
IHJlY2xhaW0NCj4gPiArCSAgcHJlZGljdGlvbiBhbmQgY29udHJvbC4gSXQgaXMgbm8gbG9uZ2Vy
IGV4cGVyaW1lbnRhbC4NCj4gPiArCSAgVGhlIG1pZ3JhdGlvbiBlbnN1cmVzIGF2YWlsYWJpbGl0
eSBpbiBjb21tZXJjaWFsIHByb2R1Y3RzIHdoZXJlDQo+ID4gKwkgIGRlYnVnZnMgbWF5IGJlIGRp
c2FibGVkLg0KPiANCj4gQS4gbWlzc2luZyBwYXRjaCBkZXNjcmlwdGlvbg0KPiBCLiBUaGUgaGVs
cCBtZXNzYWdlIGFib3ZlIHNvdW5kcyBsaWtlIGEgcGF0Y2ggZGVzY3JpcHRpb24uDQo+IA0KDQpU
aGFua3MgZm9yIHRoZSBjb21tZW50cywgd2lsbCBiZSBmaXggaW4gdGhlIG5leHQgdmVyc2lvbi4N
Cg0KPiBJZiBzb21lb25lIGRvZXMgbm90IGVuYWJsZSB0aGlzIGtjb25maWcgb3B0aW9uLCB3aGF0
IGhhcHBlbnM/DQo+IGEuIGxydV9nZW4gZmlsZXMgc3RheSBpbiBkZWJ1Z2ZzDQo+IGIuIGxydV9n
ZW4gZmlsZXMgYXJlIG5vdCBwcmVzZW50DQo+IGMuIHNvbWV0aGluZyBlbHNlLiBJZiBzbywgd2hh
dD8NCj4gDQo+IA0KPiAtLQ0KPiB+UmFuZHkNCg0KUmVnYXJkIHRvIHRoZSBxdWVzdGlvbnMsDQpJ
ZiB0aGlzIEtjb25maWcgb3B0aW9uIGlzIGVuYWJsZWQsIHRoZSBgbHJ1X2dlbmAgYW5kIGBscnVf
Z2VuX2Z1bGxgIGZpbGVzIHdpbGwgYXBwZWFyIHVuZGVyIC9wcm9jLy4NCklmIGl0IGlzIG5vdCBl
bmFibGVkLCB0aGUgZmlsZXMgcmVtYWluIHVuZGVyIGRlYnVnZnMsIHdoaWNoIGlzIHRoZSBjdXJy
ZW50IGRlZmF1bHQgYmVoYXZpb3IuDQoNClRoYW5rcywNClppY2hlbmcNCg==

