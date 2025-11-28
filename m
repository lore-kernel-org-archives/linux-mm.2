Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB78D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86F676B002B; Fri, 28 Nov 2025 12:22:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 846F76B0062; Fri, 28 Nov 2025 12:22:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CAE6B007B; Fri, 28 Nov 2025 12:22:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63E666B002B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:22:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 14F39B7C09
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:22:49 +0000 (UTC)
X-FDA: 84160685658.30.E4E2996
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3D65C1C0004
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:22:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="exD/y7j9";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=M4CSl6gq;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf18.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764350567; a=rsa-sha256;
	cv=none;
	b=a61EEqlyAgK3wAq/Ury1lBI3XGdq9pz2+DBi+FeMoNAtZSmlf6v4WREYzbx7pyOF5gC2or
	x2amtXHCPpftjV0VRd6HzIXbt+gyWB3Gq3maa6RxEFPccdMQHbJIlIpb1Biw0AnSwzSl04
	cRwkOFfjB8G15OQD1Tay86Wb+OwvfNc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="exD/y7j9";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=M4CSl6gq;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf18.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764350567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdQDOqyfil+DNkwzLkg7VF450RbTdgCc8NqtMW6uRW4=;
	b=Hz6DGSvGYrCB+dFW8KU9lY6aZ3IcjwG1OVaKnDWJF8GCsq8pbrtvdRwLJX0pfLMCz22b7y
	FCkMlGndTMx4JKprD/42/zCOU5rIVsPEEslB88PPA9PudoJDTa6rgCHsYTwyj1K0Ty8vHX
	hn+inUHLA5M0VNsriB83g+hdZDyEumU=
Date: Fri, 28 Nov 2025 18:22:42 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764350564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdQDOqyfil+DNkwzLkg7VF450RbTdgCc8NqtMW6uRW4=;
	b=exD/y7j999jCv6bS9IMXmr8sD3f5ooPKDx0FbXkjx8Zj/4jZp0LGdf83r48cRlz7csM4Ga
	774RSGWxq23m0i77jv/+q1WYKBFSNoHeK0SHXnAycfz20MDDwCsouqDKIt0UomOqQW2JEt
	Ifm/vEMXWcO7DbLtSF415CnpmUT2oDJIBZ9e17a+9JOTcn0g0uIN9m0bLfNklQ8Xln2Xu6
	LvEijg/kINBpfKtj9Zr2zSHXizNpjkYvM1MVykXCXlUGgNkpllZmDS64AXJTlju+wuK9M6
	r6QIBEfXSaR7tiPshZakf/KZ37DzfOetx999jxpGfk44srLtQmtiUsi98BQykQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764350564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdQDOqyfil+DNkwzLkg7VF450RbTdgCc8NqtMW6uRW4=;
	b=M4CSl6gqnCuJP+oILiEsB+RMaQsPNdVWA8BsfnJdgpZXuMRB31+BAQu7VwjE/LRYhROu4e
	95a+J06qa8kBsGCA==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Xie Yuanbin <xieyuanbin1@huawei.com>, akpm@linux-foundation.org,
	arnd@arndb.de, brauner@kernel.org, david.laight@runbox.com,
	hch@lst.de, jack@suse.com, kuninori.morimoto.gx@renesas.com,
	liaohua4@huawei.com, lilinjie8@huawei.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, marc.zyngier@arm.com, nico@fluxnic.net,
	pangliyuan1@huawei.com, pfalcato@suse.de, punitagrawal@gmail.com,
	rjw@rjwysocki.net, rppt@kernel.org, tony@atomide.com,
	vbabka@suse.cz, viro@zeniv.linux.org.uk, wangkefeng.wang@huawei.com,
	will@kernel.org, wozizhi@huaweicloud.com
Subject: Re: [RFC PATCH v2 1/2] ARM/mm/fault: always goto bad_area when
 handling with page faults of kernel address
Message-ID: <20251128172242.cCNBVf7H@linutronix.de>
References: <20251127145127.qUXs_UAE@linutronix.de>
 <20251128022756.9973-1-xieyuanbin1@huawei.com>
 <20251128120359.Xc09qn1W@linutronix.de>
 <aSnVXrnuY9QKjTKg@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aSnVXrnuY9QKjTKg@shell.armlinux.org.uk>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D65C1C0004
X-Stat-Signature: tusr4i4hno8qejaimkucs7fzw35zyx9c
X-Rspam-User: 
X-HE-Tag: 1764350567-972064
X-HE-Meta: U2FsdGVkX1+tPBGZa3dRz5wev2C60gMNSi3VbDWAHKFXsFN8DEz/xGHZBVpSK/9nu1TjXfgZWs+avCmB0uMYmZlEhMmZRItWk1NUPR74iNrPRy9Ha1Z/yCtXKV1VeA+HJoVG6kU78HKJPWZKJVEV6mQRXOUZd6AR70lKi57umtvaqiuzK01d5VvmVGyEFdyU/GE6Plqi1zLTCQ9H2r2fr45GXPLGPF2sjf8XMeK1gLkceZ6EmMHJBlhZPIJWs8QuRyBo0nhejvPhXl8TdWmfTAJGiN9trP8JusOXAfPtb2kw6mdRPCfRiODeaMzqM55/BR+/O3/igHNNQVWSLoPgK9rWXRWazQ/qPYeqTAyK9CD9gDKbw1l8axr+RZJhnGswRjtYjd6SJUpnK7i4r1rkwREgg+fUHLI7cj4EyV0bZ5c9PUDayAzYJf7KPPs6MfOsNxShONklGdEl0R8ekeuOH7SksfXctVOckw+6plZ3M3BmK2O3SzJmZgnQnOUlxFw1mHRmIgowbLmYMCYgVLIEWRRVGGxLXZB1QwDTzNiSByiKsTbJFhYfKE/F+iMTjUDpQKBSBnQBNbTh9Za2XNgdLgO8/dYCI7Eizi6mD9rIqB02bVXZf9KU+iKdpp/7xXWsgG5Fefjiwip+bROMUkDDqLYLi/We1qdNAi/Y6BWrlfyqHqlNdeIyVPKpImrZqK08e81+CdcgcZcDwk8lJRI6WvHr8EfQZ2HM06XVrLBLk/yDRGGBqSsVVM0r3Qx8KD3yhTa4yAf6yes9VUb5yp+L8XBfejyvwwzwa21k+mz4TlJnJeQS/s9sHwYHmifJ4Fav/DGUeOTp+U4koIYXtVlmuoOH9koqcLfSMZsqc5sZMf0rxZKOZrRkavqwJjZMvtdrDIXBQvHUL6bHwyuwvw+gOpobMZo7Z6IagnnPkK/gAVOHNMt9VdXzMc/grMaZOaNLgdew8/CVeP/vCH4cTuF
 yRvGeLqQ
 gw/JBnp5x4aDJhsNs7FZ9KzW2E9BgZaPjqgcxDQoRoMP7ke9e2wO+V5S9kw30N+K3wnZaDdf+GPU5ML5LDE3+xONMKiHXCT39uhu+w92Diujs2tiw5OGWH/f4f/bHoq7ntTZzd73NJPXRrC/4cyUAXaZXjwAnCJfCTn2hZI6EunVuFP9Ltc9sm5fm2C4tqWvjyTzw/gO6gURt7H7eFwzlGx4CQWMYGdON16tZc1P4cmn239CHSTAevJFFrBNcNv2ObS63yT8PabjIdW8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-28 17:01:18 [+0000], Russell King (Oracle) wrote:
> > I hope Russell will add them once he gets to it. They got reviewed, I
> > added them to the patch system.
> 
> I'm not sure which patches you're talking about, but discussion is
> still ongoing, so it would be greatly premature to merge anything.

This thread
	https://lore.kernel.org/all/20251110145555.2555055-1-bigeasy@linutronix.de/

and the patches are 9459/1 to 9463/1 in your patch system. They address
other issues, not this one.

> https://lore.kernel.org/r/aSmUnZZATTn3JD7m@willie-the-truck
> 
> There are now many threads each with their own discussion, which
> makes it more difficult to work out which is the implementation that
> should be merged. Clearly, not everyone knows about the other
> discussion threads.

So Will suggested to let change the handler and handle this case. The
other patch is avoiding handling addr > TASK_SIZE.
Any preferences from your side?

Sebastian

