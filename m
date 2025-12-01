Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FBA0D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58A9A6B009F; Mon,  1 Dec 2025 04:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562E26B00A6; Mon,  1 Dec 2025 04:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479326B00A7; Mon,  1 Dec 2025 04:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32B486B009F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:55:06 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19D905959B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:55:04 +0000 (UTC)
X-FDA: 84170443728.04.49B0350
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3A20380006
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:55:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=GUiRtJcy;
	spf=pass (imf02.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764582902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R54PDiPJQHrypJ6nxOZU3QXEOxGBgYwWh5cI2BJ3WT8=;
	b=ch6HGQL/f5JFBSDzPXQPBDuJh9qvwNuElncNVz0fVeSJPDZsWMgjGCaFvvq53toe1aUxCC
	OVQGIUFVgfw2aEdAne5LQhrPrjH1q1KxFhKq3MbTtOB3Huimf0NweOPlAhdZCGNX5z9VDA
	0spFmAg6yDtmGBmWw1gKEZlQgPi+nA8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=GUiRtJcy;
	spf=pass (imf02.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764582902; a=rsa-sha256;
	cv=none;
	b=ftH93GHLF8U1UtM0kci2Yq8vGYVDztRXKhM+bOzXHDDQzdmYW4EQ0xdPXntahsCr0PYzj1
	fP3aStv9i9ACynf/MZnsw2PaU+1B2kSnQE4JTPSlMXJH+5A4LIKW0zqC0kdErzZAWpKWLb
	YDJEIn4OGQ/+euescRHVO6/+RMhs0L4=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=R54PDiPJQHrypJ6nxOZU3QXEOxGBgYwWh5cI2BJ3WT8=;
	b=GUiRtJcyQhrJ3N5tA5Ur5RhzdyuuJ4jnBvLaWcXzLc31HuDNnmmU6E21jin/4Kd28/OxS/2RV
	fBjcHob/ZsDC6W/278pAVP+wd/h/sCmWFMynDc6ZrA/v7k8V4OSbQRU1CoLAat1WQaqwmgSu3Yi
	F5y7V9tXYxY3zCXP5bFO4kM=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4dKfNJ5xwHzYl0TY;
	Mon,  1 Dec 2025 17:53:04 +0800 (CST)
Received: from w002.hihonor.com (10.68.28.120) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 1 Dec
 2025 17:54:57 +0800
Received: from w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3]) by
 w002.hihonor.com ([fe80::ef6f:d9c5:cf75:d4d3%14]) with mapi id
 15.02.2562.027; Mon, 1 Dec 2025 17:54:57 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Barry Song <21cnbao@gmail.com>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Matthew Wilcox
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"david@redhat.com" <david@redhat.com>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"mhocko@kernel.org" <mhocko@kernel.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "weixugc@google.com" <weixugc@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, wangtao
	<tao.wangtao@honor.com>, wangzhen 00021541 <wangzhen5@honor.com>, "zhongjinji
 00025326" <zhongjinji@honor.com>, Kairui Song <ryncsn@gmail.com>
Subject: RE: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Topic: [PATCH 0/3] mm/lru_gen: move lru_gen control interface from
 debugfs to procfs
Thread-Index: AQHcYBJK8KKXMResfEqv9fHMnnJz9rUHrbeAgAAP74CAA+3ugIAApiiQ//+VEACAAImM4P//h9UAgACJZRA=
Date: Mon, 1 Dec 2025 09:54:56 +0000
Message-ID: <dc8ce4f329d74a24bde62c93818df44a@honor.com>
References: <20251128025315.3520689-1-wangzicheng@honor.com>
 <aSm800KsCAptVZKu@casper.infradead.org>
 <ti7h5cbrg5s3zf7surof3zmxb6supnl34x7hsbziqutm7r2laf@zuunap5hwsbx>
 <CAGsJ_4xJ5qMght93FQOYrk1OiJTh-wFC4e8Nd4K0A156N3ZEBQ@mail.gmail.com>
 <86c62472b5874ea2833587f1847958df@honor.com>
 <CAGsJ_4w1jEej+ROuLta3MSuo4pKuA5yq7=6HS5yzgK39-4SLoA@mail.gmail.com>
 <66c62243a510421db938235a99a242bf@honor.com>
 <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4x0aVkDf-AhhGbBLU=LCxYFqYoFL0ovij-vFEQeJ46jYQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.229]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Stat-Signature: cc5qq4yir915q7hbybawaok7x8pogy9b
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A20380006
X-Rspamd-Server: rspam09
X-HE-Tag: 1764582900-232969
X-HE-Meta: U2FsdGVkX18yaazMdmzN6F+gRe//lxE9ZVa/GC8V0dKpFAiPaH+LmBqz+7JUh7iDmVdc/wTvyU69d6My9k0fv12KLfrZ9U9BjWTWMYS7ZD1GDsS7Acho1uN/BdYLQTpcvD/irZ1yO2JfnU03F1b9Dv141FUGCLOOIvkwLjW9X52W/Q5Q3UDaJiNunkinU08MgQyMtPHBQOziiv1Ra4/VamgZ2df8f44l9MVQ6hcbak/BqRtlmsuhgJDy2wDkCZ65us+I/5hKfAPEg9v0Dt+tJz+xgAOOjJ6Lmx7Xx4+W8wWqGH83yBB9lGlbrRa5FiF7M/sb+9nuu4hnez8ZNA+CUpRiUIGFmdKZqyYTJm+ECVXi503H01AtJ+pnuk4x21fKhw0zcIEiq2pUQ5kECA8Pv8CnPDAifnBdkWg0h+HAOzkp9qyxI4P59nFT2dfur/ko9/DBhcrogXNzsXA95wmiMgdNUCvtAY/8sf1AOJRKT5qXGR9GSnKCI96fiy+/eFU4N9UDNyDq/kCgNd/Ap4ZgbxTGWAS9jWdtJVG7F1raZwsvgqboCULarBbKjixMlzhnoL8Jm48cGIo8QydOpH2D+J007eGytl4GbZN7l7dxJd6VwKo9XlB+Hu8tz7DjfjGuRd3ELrYs5gYI9OYkh8RHLM7nB4hlpYoWB7TOjYDGHXodJkpjX/z1VSc1pecBqWHfn28QDVrtLmpuQFxR+ZoEEZ6c8gtiCcR1NJykqN7dox+Al32ZdBDIk1LIaf+z/dJ3F8cbX/ZAgu0c7u0PLb+uf+Z15425m6gsvKHMt0IJezyuD5KY7uMmt+JrK3Ing286xy0mtdJnezHB+Ujj7OBEmRckR+E2ElzG7f54ODPN2oh2IsVLIUyrlav56Y0bosEe+Isya/E5RWU8/kcnZDmFJipjBJG58Qy0T3Ijfmy0CQ12EIV0iThuiFcK3aqEmJ8AHrDdi1Id6pOHtl7KPUg
 OYmu4Nxq
 ssJ/rjRo6DYrvmGoyhA8ZGO7LRP9JTSGwe7gFXOXCnu9DIRyJelStcKd/ajDTxt997XXl2esmow7mcB3j+X7Ev25p1DHjxnsUsCarAJaTUZg9ZfiHHpl+lBJacQSRlDMChsrky9iWxlFw4dM1+35VXO5jK1DKPzD8JrdWXmBx1UoxH0IGTmYo8CzFVJ/+23SjZCZX1VjS6pqfWYmJhux4GoABrCVsS0L9la7EPp9skOOVc5ufQikbg7nWW6wdykikPytzmv/Suo+pGFns8duoc+ix71vMOlEHv72ZL1f9XdGHq0McosjhVslYI/jRvQVnpmbPzn2DLDxBbgqUE+6l/zubbjR0AGW8kdDK1mguYJHhhc4MHIZHMhJKBiFpxkoIa7WH9ictSEpRALP3h2UbnEnCHw0dEuXUyGWCIOVupSy3sybo+nYTaYovG3LqE53wJMBx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksDQoNClRoYW5rIHlvdSBmb3IgdGhlIGNvbW1lbnQsIGFjdHVhbGx5IHdlIGRvIGtu
b3cgdGhlIGNncm91cCBmaWxlLg0KDQpXaGF0IHdlIHJlYWxseSBuZWVkIGlzIHRvICpwcm9hY3Rp
dmUgYWdpbmcgMn4zIGdlbnMqIGJlZm9yZSBwcm9hY3RpdmUgcmVjbGFpbS4NCihlc3BlY2lhbGx5
IGFmdGVyIGNvbGQgbGF1bmNoZXMgd2hlbiBubyBhbm9uIHBhZ2VzIGluIHRoZSBvbGRlc3QgZ2Vu
cykNCg0KVGhlIHByb2FjdGl2ZSBhZ2luZyBhbHNvIGhlbHBzIGRpc3RyaWJ1dGUgdGhlIGFub24g
YW5kIGZpbGUgcGFnZXMgZXZlbmx5IGluIA0KTUdMUlUgZ2Vucy4gQW5kIHJlY2xhaW1pbmcgd29u
J3QgZmFsbCBpbnRvIGZpbGUgY2FjaGVzLg0KDQo+IEFsc28gbm90ZSB0aGF0IG1lbWNnIGFscmVh
ZHkgaGFzIGFuIGludGVyZmFjZSBmb3IgcHJvYWN0aXZlIHJlY2xhbWF0aW9uLA0KPiBzbyBJ4oCZ
bSBub3QgY2VydGFpbiB3aGV0aGVyIHlvdXIgcGF0Y2hzZXQgY2FuIGNvZXhpc3Qgd2l0aCBpdCBv
ciBleHRlbmQNCj4gaXQgdG8gbWVldCB5b3VyIHJlcXVpcmVtZW50c+KAlHdoaWNoIHNlZW1zIHF1
aXRlIGltcG9zc2libGUgdG8gbWUNCj4gDQo+IG1lbW9yeS5yZWNsYWltDQo+ICAgICAgICAgQSB3
cml0ZS1vbmx5IG5lc3RlZC1rZXllZCBmaWxlIHdoaWNoIGV4aXN0cyBmb3IgYWxsIGNncm91cHMu
DQo+IA0KPiAgICAgICAgIFRoaXMgaXMgYSBzaW1wbGUgaW50ZXJmYWNlIHRvIHRyaWdnZXIgbWVt
b3J5IHJlY2xhaW0gaW4gdGhlDQo+ICAgICAgICAgdGFyZ2V0IGNncm91cC4NCj4gDQo+ICAgICAg
ICAgRXhhbXBsZTo6DQo+IA0KPiAgICAgICAgICAgZWNobyAiMUciID4gbWVtb3J5LnJlY2xhaW0N
Cj4gDQo+ICAgICAgICAgUGxlYXNlIG5vdGUgdGhhdCB0aGUga2VybmVsIGNhbiBvdmVyIG9yIHVu
ZGVyIHJlY2xhaW0gZnJvbQ0KPiAgICAgICAgIHRoZSB0YXJnZXQgY2dyb3VwLiBJZiBsZXNzIGJ5
dGVzIGFyZSByZWNsYWltZWQgdGhhbiB0aGUNCj4gICAgICAgICBzcGVjaWZpZWQgYW1vdW50LCAt
RUFHQUlOIGlzIHJldHVybmVkLg0KPiANClRoaXMgcmVtaW5kIG1lIHRoYXQgYWRkaW5nIGEgYG1l
bW9yLmFnaW5nYCB1bmRlciBtZW1jZyBkaXJlY3Rvcmllcw0KcmF0aGVyIHRoYW4gYWRkaW5nIG5l
dyBwcm9jZnMgZmlsZXMgaXMgYWxzbyBhIGdyZWF0IG9wdGlvbi4NCg0KPiBUaGFua3MNCj4gQmFy
cnkNCg0KVGhhbmtzLA0KWmljaGVuZw0K

