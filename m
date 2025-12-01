Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E2ED111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 07:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFC16B0011; Mon,  1 Dec 2025 02:03:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D8266B0022; Mon,  1 Dec 2025 02:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0141A6B0023; Mon,  1 Dec 2025 02:03:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6BF56B0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:03:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A09B1160BB6
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:03:00 +0000 (UTC)
X-FDA: 84170010120.15.FC46F36
Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C79A180009
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 07:02:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764572578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=keLVryX8GeIo0Mn0JMDPzQGbake1lsSDO9bIs82o8/A=;
	b=o4RE68/x+To0331Spdb+hD1P4rdUxB++x4z3z+ZW/ZBWdJOtLSckBlgsYouOOI7WvRVQo8
	smij+Dk1vcyOH/3Ot+D6zF7j2QTVRt123U3gMyTpZiAQmNF7Kp4Mx/CKfLqTF0itxhhtu+
	TrjVXrmgWkKhDZHeQ2VwUb1c4Zmv3HA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764572578; a=rsa-sha256;
	cv=none;
	b=NH1Nm5Lr0UOo+/Jbpj5/JZSIClsMw76UgANl79To8Jhu9CBqEXr2hByPlZESy3CO40iKmo
	7wxJjJoSpFnDxOO65N1mOVSYIt63XkgNl6BAmx6Z0JDNhS8prcDnrU1cv5wE8SMB4Qs6zp
	LVH9dEOztiUconTszOXgj62V7mMe6Zk=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4dKZZL3V3YzYl9BZ;
	Mon,  1 Dec 2025 15:01:30 +0800 (CST)
Received: from w007.hihonor.com (10.68.16.91) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 15:02:54 +0800
Received: from w002.hihonor.com (10.68.28.120) by w007.hihonor.com
 (10.68.16.91) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Mon, 1 Dec
 2025 15:02:53 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Mon, 1 Dec 2025 15:02:53 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Matthew Wilcox <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "david@redhat.com" <david@redhat.com>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "mhocko@kernel.org" <mhocko@kernel.org>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"weixugc@google.com" <weixugc@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, wangtao <tao.wangtao@honor.com>, "wangzhen
 00021541" <wangzhen5@honor.com>, zhongjinji 00025326 <zhongjinji@honor.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Topic: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Index: AQHcYBJK8KKXMResfEqv9fHMnnJz9rUHrbeAgAAP74CAA+3ugIAApiiQgAAOWIA=
Date: Mon, 1 Dec 2025 07:02:53 +0000
Message-ID: <e4cc633a77cb46b6bea4667d3886c000@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
 <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com>
In-Reply-To: <86c62472b5874ea2833587f1847958df@honor.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: ju8ibwkeauqhjsibmzqk7eshmto5f7wu
X-Rspam-User: 
X-Rspamd-Queue-Id: 2C79A180009
X-Rspamd-Server: rspam09
X-HE-Tag: 1764572577-658289
X-HE-Meta: U2FsdGVkX19lM7eDeBIuf6IC0whHSVDBl3mmV/zl2D9fTbSZAbO1VGol3xKhbbZY/r7+25pcr/zsTQ0W8L3I3tlFJfaHbp+k5RS2hxk/NI04ZDVf8FvqedDqm3USdu0tLSkgbwSGtE/h88/DmpMeQ+vXqkj8aICIceKef8C8abCkqwReA0ZcbHZDqgMw895CRcgqLGSNiwFKSOE4AWFMN4QaU8X7n6YgUx8OcNJlL28ZC/aXISflME7qivEOuesT8kboRonCtJ04dJBzqJihpzAo2AKa06EdQPJHZR09B5V65wwDn7ulb4XcD5BkIhQ6iCVu+l0Af443Nq7C9v24A5+Gem173r0EATXwQkKRpWRNy8JYvxj56T1C5rjEwxOW8C5vtZg/4NHahKadqrPo7mva1qeLKP5+JecdB5IA4p6JFoBrm9FG7uD85qVLk3z0dwe6wdVMD5j05w3hcqKPKVlOERG+GTJbvrbPxMmhl/I4GD+VzUz5ZAzInYx397ObOv7PEaRS2BcrHNJBGLknm4BgxHdSeO8durVrvItEIz2h8SpFqjfRbN9wG32+c8zFP6RvxqFIq7B/XqdqtWfsLQbX/JhzZaF8w+LDxQfjD4CjVjoud052NXm5g2Uq3GfjTl5LtVDPg+9r/vtW1YFCbHZOOgHCBtZ0YiOo/1naMq2SiK/tsvLva+irgy6mwXUqG5QF2+EOa4XMlL0aRKKUjQ2OIVbSRAK2jaojiW7Ye5bI4B415bN7ARnkK6ARy+NhDIxGqcZbdn5dKjNLld8ZX5un4n5UezgvZuSjrTdVdwP4ekcjyg2tmiyrwEmXBqOwoLXVZsfWA4VDP4zmd3qirDLgcvYbgnVVRJlSHpT07P27zkUTwcqsJwTsFPQlECFXl3MxNRyUa5bU67Qfl/Ctwk//t7MdqrLMyuITCPMwLMAVPHdoySN0Q3CA+jGdlqYBzHxPvot/BQhRCnVJQr0
 CReJ/YnS
 0NcpswvSn/nQFzlIhlaCM+sBh04gApjkX5/pGkZsRda9R3+WYqkv1x83P0zymiu7r1j5DRWwpDCK4OAKwzSSoR4+6bDbR3Esqhu+BOFbyJ87Uh2iZFEq/hC7YQvY/plnD3Mlr2IBFRdb/ZH9775SWlI0+UxlRzDgBuLdQdYPJBp/+YU+16ProECKxRidlDDoaSdY/jQ24uQPPzy3xiDHbG3ENeJtCuuGbibVWXHcJueXq2MrfnnZpTHdzAsm8sas5g5RuhDiyawH/kMfa5jngfaxu9deG7btn22QkSouJHVGhnA1FDwHFVs0JTZEtSgoBbWmxd5MAJpoJAo3qDWDcJdGqjPVzVKWe4hqt3cd2WAQZhKvGnIpaY1wLbd0qwJ55zKl7O/99E6D93Dhj2fQEWh2JnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+ID4NCj4gPiA+IFsxXS4NCj4gPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDI1
MDUxNDA3MDgyMC41MTc5My0xLTIxY25iYW9AZ21haWwuY29tDQo+ID4gPiAvDQo+ID4gPg0KPiA+
DQo+ID4gVGhhbmtzDQo+ID4gQmFycnkNCj4gDQo+IFNpbmNlIHRoZSBzZW1hbnRpYyBnYXAgYmV0
d2VlbiB1c2VyL2tlcm5lbCBzcGFjZSB3aWxsIGFsd2F5cyBleGlzdC4NCj4gSXQgd291bGQgYmUg
Z3JlYXQgYmVuZWZpdHMgZm9yIGxlYXZpbmcgc29tZSBBUElzIGZvciB1c2VyIGhpbnRzLCBqdXN0
IGxpa2UNCj4gbW1hZHZpc2UvdXNlcmZhdWx0L3BhcmEtdmlydHVhbGl6YXRpb24uDQo+IEV4cG9z
aW5nIHN1Y2ggaGludHMgdG8gdGhlIGtlcm5lbCBjYW4gaGVscCBpbXByb3ZlIG92ZXJhbGwgc3lz
dGVtDQo+IHBlcmZvcm1hbmNlLg0KPiANCj4gQmVzdCwNCj4gWmljaGVuZw0KDQpNb3JlIHByZWNp
c2VseSwgaXTigJlzIGEgZm9ybSBvZiAqcHJvYWN0aXZlIHNjYW5uaW5nIGFuZCBhZ2luZyouDQoN
CkVuc3VyZSBhIG1vcmUgZXZlbiBnZW5lcmF0aW9uYWwgZGlzdHJpYnV0aW9uIGJldHdlZW4gZmls
ZSBhbmQgYW5vbnltb3VzIHBhZ2VzLg0KDQpCZXN0LA0KWmljaGVuZw0K

