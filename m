Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8791CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 11:32:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23D880139; Tue, 28 Oct 2025 07:32:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAD3E80131; Tue, 28 Oct 2025 07:32:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9E180139; Tue, 28 Oct 2025 07:32:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BA18480131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 07:32:41 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6AC94586F1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:32:41 +0000 (UTC)
X-FDA: 84047310522.26.147642C
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id A8AFC2000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:32:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oSyA08+J;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761651159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/79zVvk1KSb/1ysL0Z+zygitKh9g9fDoyZAQOQU3Vq8=;
	b=GVn64SaScJa1LUayWM4B/O4o9g/jIBJkeUJhdm1ThMlkxcTIG5ubo0K2Q2RSDSY3NP8aYC
	/5EamldA0Hm17mkKnLgDsQhuBpofFH4GYMREaZXrDLOc7ikKmP7dzhPBoagIAnGNPPhuOy
	wj8TUmLOqPNfr5/MQ1UMhUjvRwyOqQk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761651159; a=rsa-sha256;
	cv=none;
	b=3UfDNucZAGvOxKKejtgERNamcz8lCUBF1MorZmdF/U5+e9rQJcPaPqK4ycywAICItWhHo9
	fSv9ucYZo43mObu+ZKWS5UwLrTv7+wJ5WWoCCNeZ2AtSfNpX3h/J3PjHXrOLKWNE5OfZc1
	zHP659+LzJKMXN8QAmldiaixQCckPuU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=oSyA08+J;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/79zVvk1KSb/1ysL0Z+zygitKh9g9fDoyZAQOQU3Vq8=;
	b=oSyA08+J90SDBadgg1pwlhIFpD0CZu5RDDWLekG9xYWktMBBtqTpwbn/a7fyU3PIcD26un8KR
	xEKNLfiqyTyWpHx1IjpOsxke0p6R09t4NHEkSTeESybB+v0rVe4QHlMU5CX0MJCP4TRH3V1z9PM
	EJEl42XK+UtjQtpndVQlfVw=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4cwpBC0MWPz1prLt;
	Tue, 28 Oct 2025 19:32:03 +0800 (CST)
Received: from dggpemf200009.china.huawei.com (unknown [7.185.36.246])
	by mail.maildlp.com (Postfix) with ESMTPS id C18F11401F4;
	Tue, 28 Oct 2025 19:32:31 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf200009.china.huawei.com (7.185.36.246) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Oct 2025 19:32:31 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 28 Oct 2025 19:32:31 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: David Hildenbrand <david@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Wangkefeng (OS Kernel Lab)"
	<wangkefeng.wang@huawei.com>, Sunnanyong <sunnanyong@huawei.com>
Subject: Re: [RFC PATCH 2/3] mm/mincore: Use can_pte_batch_count() in
 mincore_pte_range() for pte batch mincore_pte_range()
Thread-Topic: [RFC PATCH 2/3] mm/mincore: Use can_pte_batch_count() in
 mincore_pte_range() for pte batch mincore_pte_range()
Thread-Index: AdxH/BcTwK17Rhx6T1qkj45y9MTgGg==
Date: Tue, 28 Oct 2025 11:32:31 +0000
Message-ID: <1cd515972cbd4be9ac8b5abb635c052a@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: A8AFC2000D
X-Rspamd-Server: rspam02
X-Stat-Signature: orwg4gytcxum6zrnzp811568c9diw5rn
X-HE-Tag: 1761651157-198673
X-HE-Meta: U2FsdGVkX19KpdXxvSC4dq97dY2j2fQReYwXXWHYErhCLHBIktDRyvs4EBbRo9Q6ZX/JQ63u3ayD/kwtIeQcMANWp/xaMYXsYCqqUb/T3eIO69iLPf5FOUk6bVrJ11aJsonM0zJX/h/N5XvitjEwEiKrZEZfJElXMI2WCn1lJEGbRsqtdpwSnw+LlcOSObp0sH9oY5w6jt7stZjTsmjFiZIG+Y/I/UWfnsFEy3njdCrZ3fQb9EFiPe3IxIz95g3rDHrNFkZIaovEGEGIiTPg29TqvgOR2dKZAw9+fKxPmzAPf4dBnmKn5IA3VDZi6yANQRc/geW7LSp2wp1vp4OvShksZ2ddfJL0IXKJhJknQJoeKGWOLtpWdh14BqjwZ3RyUuVuTNP/zRrHZu/erDmtkesZVyumECdtDMKGjPnxJI4huUHWltWprpO0lGO/jT4mzwXVdFwU2a6qWX4fPFkY4Wtmg0UmIyzToJqWXyKY6gY01/XgwiuZbS/rIZOkCxDBNaNHqmpDKFcRw/gSkhqLapet9pcV3/rtvuREG0W/5QrvWhfWWC40IhS4kXupwiOWmHxXalWVtRToykBiwZNxohQtL+GpxrpRpVKfr8oDfJcZXUSu/1Ah875EhriboC2uxGlevRdSKtx50agEd6dCvMy1FaBSlWz07Lap8tkDKecS/ZbjixiZnTeTonyj1TxHeb5I+J6lVU0atJKO5m03Fwd7vLK8lz6IxI77Y6NsjYWYZVyv8DsdxOeosvmujCh9oFIkrw8idoFdR41UPYsLfvU0wNVv+VKVfKBPFa1wdiVnwa4fcreVZM84Ph566fqwXIqUy2O/s9rlmu4/dDiYJHzW/7oAQ24/aQUS4D9xKXvXOtlfN+KBiD/wV3MHsD71V1j/cMpFAEsnQIk09RoOisSpADDEjtkQJmWzrI6HuZ8hXLlGU11JEEHHmeWSOqDcXDIlE845O8UgIZqFZau
 CcdH0A9U
 QhiWXrwA7UFd9W2cfKEQAAN62fRMli6npHO/b1k3ox8zmHIJ0nn4DhGI8RCoe+bpWGZbq3H48qWMrwK5x/UKb3K4RO4MvX132zmvuJC1CbITlXh3L8Y3gyflkc/M7IooM0pYOutWTDz6tFEtcaiEC/cGmNjrZ6sXbbrMoc2XoAtwxtGExIfmkbS59xVF1q0tL0yjeV6hQtbQOxKI732oLSwyXnrQZK04Hd6J1TYTuY2jEYHT7TyV2j9cgu/MhxJ7kqWOwLiatVpApP1jadnf/s/9Zkp/gM1Y6o2TDknn3JGjinJBinEMZfvkbrNEvK9legWZZ9U+DE2uG3nHYhcsiPju1MOzUqLBAGKoGYHVxgiA9ic6kLi8h50VBuDAhTaQRXOoW+srhAwNw4iGtFtbkwrBgeS8wpsJmBKLZkQHfOSF3a7OG3Jphcc6h0+f8UiOHzqDHfdYfNAxCczyq0fGHBEYE+3p3MBHEHsWg0soDZI9ClrWUlwf7IZ+eNHX/9Tqi3wu7LwIHZmj8fP7TRGQAb7Qbqw3UHrjbGGv2giPfkjcCEP9ubiV/H1J4Hw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiBPbiAyNy4xMC4yNSAxNTowMywgWmhhbmcgUWlsb25nIHdyb3RlOg0KPiA+IEluIGN1cnJlbnQg
bWluY29yZV9wdGVfcmFuZ2UoKSwgaWYgcHRlX2JhdGNoX2hpbnQoKSByZXR1cm4gb25lIHB0ZSwN
Cj4gPiBpdCdzIG5vdCBlZmZpY2llbnQsIGp1c3QgY2FsbCBuZXcgYWRkZWQgY2FuX3B0ZV9iYXRj
aF9jb3VudCgpLg0KPiA+DQo+ID4gSW4gQVJNNjQgcWVtdSwgd2l0aCA4IENQVXMsIDMyRyBtZW1v
cnksIGEgc2ltcGxlIHRlc3QgZGVtbyBsaWtlOg0KPiA+IDEuIG1tYXAgMUcgYW5vbiBtZW1vcnkN
Cj4gPiAyLiB3cml0ZSAxRyBkYXRhIGJ5IDRrIHN0ZXANCj4gPiAzLiBtaW5jb3JlIHRoZSBtbWFw
ZWQgMUcgbWVtb3J5DQo+ID4gNC4gZ2V0IHRoZSB0aW1lIGNvbnN1bWVkIGJ5IG1pbmNvcmUNCj4g
Pg0KPiA+IFRlc3RlZCB0aGUgZm9sbG93aW5nIGNhc2VzOg0KPiA+ICAgLSA0aywgZGlzYWJsZWQg
YWxsIGh1Z2VwYWdlIHNldHRpbmcuDQo+ID4gICAtIDY0ayBtVEhQLCBvbmx5IGVuYWJsZSA2NGsg
aHVnZXBhZ2Ugc2V0dGluZy4NCj4gPg0KPiA+IEJlZm9yZQ0KPiA+DQo+ID4gQ2FzZSBzdGF0dXMg
fCBDb25zdW1lZCB0aW1lICh1cykgIHwNCj4gPiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tfA0KPiA+IDRrICAgICAgICAgIHwgNzM1NiAgICAgICAgICAgICAgICB8DQo+ID4gNjRr
IG1USFAgICAgfCAzNjcwICAgICAgICAgICAgICAgIHwNCj4gPg0KPiA+IFBhdGhlZDoNCj4gPg0K
PiA+IENhc2Ugc3RhdHVzIHwgQ29uc3VtZWQgdGltZSAodXMpICB8DQo+ID4gLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gPiA0ayAgICAgICAgICB8IDQ0MTkgICAgICAgICAg
ICAgICAgfA0KPiA+IDY0ayBtVEhQICAgIHwgMzA2MSAgICAgICAgICAgICAgICB8DQo+ID4NCj4g
DQo+IEkgYXNzdW1lIHlvdSdyZSBvbmx5IGx1Y2t5IGluIHRoYXQgYmVuY2htYXJrIGJlY2F1c2Ug
eW91IGdvdCBjb25zZWN1dGl2ZSA0aw0KPiBwYWdlcyAvIDY0ayBtVEhQIGZyb20gdGhlIGJ1ZGR5
LCByaWdodD8NCg0KWWVhciwgdGhlIGRlbW8gY2FzZSBpcyByZWxhdGl2ZWx5IHNpbXBsZSwgd2hp
Y2ggbWF5IHJlc3VsdCBpbiBzdHJvbmdlciBjb250aW51aXR5DQpvZiBhbGxvY2F0ZWQgcGh5c2lj
YWwgcGFnZSBhZGRyZXNzZXMuIA0KVGhpcyBjYXNlIHByaW1hcmlseSBhaW1zIHRvIHZhbGlkYXRl
IG9wdGltaXphdGlvbiBlZmZlY3RpdmVuZXNzIGluIGNvbnRpZ3VvdXMgcGFnZQ0KYWRkcmVzcy4g
TWF5YmUgd2UgYWxzbyBuZWVkIHdhdGNoIHNpZGUgZWZmZWN0aXZlbmVzcyBpbiBub24tY29udGln
dW91cyBwYWdlDQphZGRyZXNzLg0KDQo+IA0KPiBTbyBJIHN1c3BlY3QgdGhhdCB0aGlzIHdpbGwg
bW9zdGx5IGp1c3QgbWFrZSBhIG1pY3JvIGJlbmNobWFyayBoYXBweSwgYmVjYXVzZQ0KPiB0aGUg
cmVhbGl0eSB3aGVyZSB3ZSBhbGxvY2F0ZSByYW5kb21seSBvdmVyIHRpbWUsIGZvciB0aGUgUENQ
LCBldGMgd2lsbCBsb29rDQo+IHF1aXRlIGRpZmZlcmVudC4NCj4gDQo+IC0tDQo+IENoZWVycw0K
PiANCj4gRGF2aWQgLyBkaGlsZGVuYg0KPiANCg0K

