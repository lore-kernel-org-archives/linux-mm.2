Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EDBCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D1298E0026; Mon,  6 Oct 2025 16:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A8C68E0002; Mon,  6 Oct 2025 16:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E5C98E0026; Mon,  6 Oct 2025 16:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBD08E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:15:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3B781A06BC
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:15:28 +0000 (UTC)
X-FDA: 83968794336.19.983F262
Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	by imf07.hostedemail.com (Postfix) with ESMTP id A206940009
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:15:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759781727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LhjB5H9mrCqOGAXj5HXNdyEVYPj6mQQyTvJX1KEHiMI=;
	b=A52WRKiM/qMj2f8OC4RLT8b03gGNTcYotRrHsZIhjSz8RHv6wqONu/Gkp8C9Uj1dRUuJpB
	hbvepf71W4wLQwxlg/6/ryDNLwh7jgDQG/JGX2xepENssfcnszuziYP3SqzBWH+gSv/tKK
	nz5TmAj71CTPXW/CYaqkf6hu0WIiCOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759781727; a=rsa-sha256;
	cv=none;
	b=DLMleOu6W4DIjbsDe1Q2uvQzBwOPRSpEtXmcrgIat1SSOM03wz9pAwc67aqymkc6BV3DZe
	HSPxqDT45FZYwE3pxQhEbuKe9z/Vu+3G+/voipLgkJd51QY2Rda+T1dlvK6Nw8nyaTh3rS
	WszBiOy0jkv6boZYlE6gdLSeWEDbGsM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of richard@nod.at designates 116.203.167.152 as permitted sender) smtp.mailfrom=richard@nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 853FF2B4F9D;
	Mon,  6 Oct 2025 22:15:23 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id JD4v2hnJ6q9P; Mon,  6 Oct 2025 22:15:22 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 0C4012B03C9;
	Mon,  6 Oct 2025 22:15:22 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id j6VbrBHYDJpt; Mon,  6 Oct 2025 22:15:21 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id B486A2ABFC1;
	Mon,  6 Oct 2025 22:15:21 +0200 (CEST)
Date: Mon, 6 Oct 2025 22:15:21 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Dave Hansen <dave@sr71.net>, ksummit <ksummit@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, 
	linux-mips <linux-mips@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, imx <imx@lists.linux.dev>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, 
	Lucas Stach <l.stach@pengutronix.de>, 
	Linus Walleij <linus.walleij@linaro.org>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, 
	Ankur Arora <ankur.a.arora@oracle.com>, 
	David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, vbabka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, 
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>, 
	heiko <heiko@sntech.de>, 
	Alexander Sverdlin <alexander.sverdlin@gmail.com>, 
	"Chester A. Unal" <chester.a.unal@arinc9.com>, 
	Sergio Paracuellos <sergio.paracuellos@gmail.com>, 
	Andreas Larsson <andreas@gaisler.com>
Message-ID: <1190290449.3827.1759781721487.JavaMail.zimbra@nod.at>
In-Reply-To: <4fcd272f-81e3-4729-922b-588ad144e39b@app.fastmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com> <497308537.21756.1757513073548.JavaMail.zimbra@nod.at> <dec53524-97ee-4e56-8795-c7549c295fac@sr71.net> <640041197.22387.1757536385810.JavaMail.zimbra@nod.at> <4fcd272f-81e3-4729-922b-588ad144e39b@app.fastmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF141 (Linux)/8.8.12_GA_3809)
Thread-Topic: Reaching consensus on CONFIG_HIGHMEM phaseout
Thread-Index: 4qe/Jvt6A7Z6bNoIFm3Eugvg7UbUaA==
X-Rspamd-Server: rspam01
X-Stat-Signature: kdmktinqubxy4cz8ey9n6gyjmdnubsej
X-Rspam-User: 
X-Rspamd-Queue-Id: A206940009
X-HE-Tag: 1759781726-796619
X-HE-Meta: U2FsdGVkX1/s76MnZl82yw4zxX5+mffWITK8d3rEj5CiHCnC0gH5w541hEWQsaR14gtjTbMsvQxLWD/RBKAbmJwFKkMJecVI3+QRNJzLh0HvWgO+EkbJvqfN9z/WCLeARMSsDG275PPrU7AVLLdV9QN46MPUOjV7ODNFcaqn8Bxo/CRXmptMMBe0SeRPojHUew4Ppq6Z0g5i2nJRKOeCKDs6CgSWasveGmGxhfRjLZTppvbTqCx3LF12tCneDPYbhRryozT9G+2sSNVTNyy2vlqTVyKrqx1kbZcfCWyKq8G8QEXdTAUYtp1/8+MxnSjqHitShddtIxTSo/stxFO1WnWe5e0WEoHyVC0ShcQ0asQrOjf///nzEydqkU4UiYySzvJ5kd/HYWVKG+9+HMzLso6z8jFD7oYIcCZ/vVsZR++PpiqghF/ORmxG0lMvTbEkfcV/NTbv30+1/D3JEz+NhYg1b73+okRQXYxi7xS+KrLhBYOSlo5BzORBw1gYofxewVkqW4GMrm1qegRSr+ecCbOlJprEpg0v9tvd76d8RHABJeZgosJe01MxYZ05MyiAx/8+SHQvFUB81l6J9pUD0sgZlQynThwhppuYF4LqPGYlMvrVqEqbMCvz3hfaDKj0nokBW89Mrm9g/ZmaAztFHFfcCJgSRHuWdebYzHr6j3bnG8UFYU7SPBaQxsrhc1HwxcMj9PMnksxxbYYedVxq4lq+jjXfu8Sj717M3LADnerlQV//wFdI4ie7hPrOCebq6BSmvaA2YStW+0Yx/R1Q2dgene7IpOnkYgX7yC9e8IlkzGF8i8TS6324kxsz/5oPqen41Ty9tqk4MvODUiMV4BeNvkPMZRAlVVTLX0Og8jIUx24RzrVaGdC16PClJyf9XRaJeBS+bpmTsFL8Ab3nqrZR9lUaDMFxntqF7Xwd7v0T2QGZ/giqa2Rzw8MiY0/QDOTGiudbVuZL3g3YBSR
 gik552C1
 U6Aa5JupSp3vAwIL0FdQ13PcxyrVZSh+B9HABvqsZ3V+dK20etZat3iZn182OA8qVMdMTD8MAr3nD+qsFdew8gKQDA61oBA8RPyGKWKYzBuE6Wb7604MvSCzPtWG+A0/X7OhwaVmwvuliju+FK2OGupiRiL5nErdvwJyhqeeX+sPD1rgcILmCgWN/fVgTFBG1IXdvkNAg21fQa9LNXyu1c6yYBs1lXAAXVy1aK+KbM3DWoBFbc04GdjC6Z3TnbDuCPH9FZzilaY6WEwsPoUIovGiEeSVpNzXFfIS0dQt8bq/G22KnpOqxnSobDERDv0Qu8ha8w4ykpgFz69j+Mk5HKMg+5pEzqxpWwdN+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

----- Urspr=C3=BCngliche Mail -----
> Von: "Arnd Bergmann" <arnd@arndb.de>
>>> Has anybody run into actual end user visible problems when using one of
>>> weirdo PAGE_OFFSET configs?
>>
>> In the past I saw that programs such as the Java Runtime (JRE) ran into
>> address space limitations due to a 2G/2G split on embedded systems.
>> Reverting to a 3G/1G split fixed the problems.
>=20
> Right, that makes sense, given the tricks they likely play on the
> virtual address space. Are the 2GB devices you maintain using a JRE,
> or was this on other embedded hardware? How common is Java still in
> this type of workload?

Sorry for the late reply, I was on vacation.

No, the devices with the JRE issues are from a different customer.
Since I work as a consultant lots of strange issues get thrown my way

I wouldn't say Java is super common but I still see it from time to time.
=20
Thanks,
//richard

