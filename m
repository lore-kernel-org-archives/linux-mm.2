Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34AA3D5B87E
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6D16B0005; Mon, 15 Dec 2025 21:12:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964546B0089; Mon, 15 Dec 2025 21:12:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863346B008A; Mon, 15 Dec 2025 21:12:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71CD36B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:12:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 21A4C14042C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:12:19 +0000 (UTC)
X-FDA: 84223709598.03.C7212CB
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf20.hostedemail.com (Postfix) with ESMTP id D60431C0002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:12:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CI7GZIQU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765851137; a=rsa-sha256;
	cv=none;
	b=7JR9xT2h1dNZmN2ttF7CFJaTwydvWiTcoJg683Siu1qix+s+3jZDwF1OZpR4bdF65Qmd/A
	1yOKUk3Kns5BT3cGFkRL84iW1dsxp4J2WFX9i3XctViiBd8kLWRoKDnv6ATE6Ny0R8uOYL
	uBbfAPDBTct7LR24cYaPGqmHbclySNc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CI7GZIQU;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf20.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765851137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Ny61MqGFroEBN84CEhZ8ZqH1kOgw2JrvF+IHTRz9+B4=;
	b=wchMv8MzGvGPUw8Q2LIegm+5JTYhRQG5g7WGO+w3rWN+/HhBMiHGX/VJQVL0CIzvXWqd7m
	8eTrjgW32Xt4QRcSosdWv0Ob73QXIQq/ynKwWbpTDyAdKC+iMMUsTj4jbtBHldp4Ej6DaO
	HQG/z26pJ3FffZ24Ai4tp28uJDtPlYw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Ny61MqGFroEBN84CEhZ8ZqH1kOgw2JrvF+IHTRz9+B4=;
	b=CI7GZIQUTPuQLuGEgWYWj9pr8ko3O/HhHvYlo1byFV5Wl71mDONiwT1QyebJbxJItF5CAK737
	JOZhbgnxPXO/Y6FMtzOhFI9XYwILLcTHWfTmIdTvPfeo1TfzwfXyWutdTWyZKZRVQeks/wYVdUM
	1bN7V54OGKyvsgK3XCmrbQk=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dVgPH0yCwzmVVR;
	Tue, 16 Dec 2025 10:10:11 +0800 (CST)
Received: from dggpemf500009.china.huawei.com (unknown [7.185.36.50])
	by mail.maildlp.com (Postfix) with ESMTPS id 26A8E1800B2;
	Tue, 16 Dec 2025 10:12:11 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf500009.china.huawei.com (7.185.36.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 10:12:10 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 16 Dec 2025 10:12:10 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: Matthew Wilcox <willy@infradead.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@kernel.org" <david@kernel.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "corbet@lwn.net" <corbet@lwn.net>,
	"ziy@nvidia.com" <ziy@nvidia.com>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "npache@redhat.com" <npache@redhat.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "baohua@kernel.org" <baohua@kernel.org>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "Wangkefeng (OS
 Kernel Lab)" <wangkefeng.wang@huawei.com>, Sunnanyong
	<sunnanyong@huawei.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next 0/2] THP COW support for private executable file mmap
Thread-Topic: [PATCH next 0/2] THP COW support for private executable file
 mmap
Thread-Index: AdxuLvzPiGNlB0SW/Ee39Xxvv0vdtg==
Date: Tue, 16 Dec 2025 02:12:10 +0000
Message-ID: <c0ceb2104cac497383f7f7e5e7a00930@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D60431C0002
X-Stat-Signature: skeqdyrneq8twdji596rbgzhkbobsnf7
X-Rspam-User: 
X-HE-Tag: 1765851135-659859
X-HE-Meta: U2FsdGVkX18SsMTdh5AQi2h2OrLpOF/ECuo+y7ZUzGoz3eef/znZPbcPQ/QWLZdRBsC7qRkAPb2C3MVLwey+TfojpNAJFaXAsfmQmMlxZyU5Vq8b1yTIj3pi8fx/cOlbxXCyMEBufxoVjcz8KkdeyjMV/qHx4xDh72NQsrXoVpopiM4rk2jF69p7m0/xIT9m3RB4d2mC1HzPoEslWtjp0aabDiSWiroyYJ7BM3c+FlSd6fHrbMOd+VBZW73J3Cp+CY7w6bqpfhainlmczhnxZQ82FqkIUXaWRL7KDcLgryjStJYbUsd7h90DLxOXGtVYDOtcebxg5Db3mhcXllJqcuacAcT4KpP0uge65iL5YAhV21uvUg7Mr/Oe+Lh3JmIHyqTqQMnVyN90aSivs1DnHLTl8b6Li0Jt/w8oEdbg0xaWJ3Z7xO76IxjZ2ctjYE/QXlhsImkLjaCWUE91TCBbvb0AjqcXtjyU/cH0qTxYzirjPODYu4K25tHJieUFnfpCmtlZ5eEEFyiGdJW+PmBuOPK6Wht/P3Dcb2E/iIOFZWSBadS5SRVfot47ZmKpAakLvoe7aNRRe13aA8xYoUCi2WOzI26/4rIpFBxeYxYsswFJZTpfsQEwujgvwaG2vdeHIaje7Pv+WkLMkSa4RAg9qsrRrUwEOUwqnlYQ30nVQVb00PRq2aNwQKMrpVURVtttX4G23txiwQSYIxW/VS6CNLulE8eYWxsd8yEtDgu/dnXDbfMfjwCxaDYp3NSABCucR76CnR7fJlfTjDFqBmehq0rHizTEfTI8s+yaXA40Y+BWnd0Be4IWlK/j9hGxizBfC9Jn+yy2XG3b0UujlCE/eoJvD/cruV6/NK0gVn49HwV8Ouas+9X1cLgRZi/Y7smXzKijMaTtXboaDkJRWfUgZ1jIMwvCBjE1EV7lzfoaUapmo0yAbqjiHLz1iNX8hL3ebM2rhFauIpHsb0XRSmH
 InN8bCSA
 6/xceqOIv7ukZw5XNtXtciae2BM0r6mWA1TADtuq2VvMqG6/bUqxG3Ad3iQ6DO04gagrZdR1cmsToKDHj2y3/MQ13r/dr0UhC7d6IENJE5pe61SGIZTbqZ1OhsQh7s+F531P429pozpUa4hBAgUMmECJ+O/cObuAijyW2tQcHajQF/c6wnWce7kplmgBhBMkoZw0itz2zi/Ours2/EbRCcee1V/c2zuj/1ZPkmRJyrqCKM7/ORoFwskjkmyDuzhiQ6uHw68q43LHgx9ZzGdPv+M9JlyZDqWwp2/r0wnzT0uWDGi48fjoE26XlB9gFlmqw3CnHinyHQLcKnOdR64OLMtrnB4iT60sm6191AvWTwKksYvlu5bJxv8SrAMANkVpx72WISUejCQI1Nrx1FZnYdG9wCeJSymx2ekwmEvDPOvCvG4E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Dec 15, 2025 at 08:34:05PM +0800, Zhang Qilong wrote:
> > This patch series implementate THP COW for private executable file
> > mmap. It's major designed to increase the iTLB cache hit rate for hot
> > patching application, and we add a new sysfs knob to disable or enable
> > it.
>=20
> You're going to have to provide data to get this patch in.  We've deliber=
ately
> not done this in the past due to memory consumption overhead.

Year, memory consumption overhead is a serious issue, we will conduct a car=
eful evaluation

> So you need to prove that's now the wrong decision to make.
>=20
> Microbenchmarks would be a bare minimum, but what are really needed are
> numbers from actual workloads.

Okay, I'm also trying to gather some test data locally(include microbenchma=
rks and actual workloads).
I'll attach the results once I have finished. Thank you for your suggestion=
.

--
Thanks,

Zhang


