Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F1ECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835B46B0005; Fri, 12 Sep 2025 17:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D698E0002; Fri, 12 Sep 2025 17:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723356B000D; Fri, 12 Sep 2025 17:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B7BD8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:09:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 069195BD13
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:09:54 +0000 (UTC)
X-FDA: 83881840308.04.33AB362
Received: from fhigh-b8-smtp.messagingengine.com (fhigh-b8-smtp.messagingengine.com [202.12.124.159])
	by imf03.hostedemail.com (Postfix) with ESMTP id C5E8320008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:09:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=GI4t6+q5;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H g+efwL";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757711392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CLqRBKVf5IvTh800HM+2y42LrS7XFT+UlQoEp2IAPso=;
	b=rMGZR2J/VpFQzBVnfS12dE4IQA0219p0I4KCanM0UyJ8ghHAlp1xP5mAyBbAT09q2gNFkK
	gf2OGb+c3CjYeifUuZ8eXWLrpsCG8Ym7vi2QFuzfl5aHnQmTjAyQZDS8lfSB9WgBWsJ10u
	jYwpsklb0VvM4zYkhLWNvEMjhE9EAvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757711392; a=rsa-sha256;
	cv=none;
	b=kWXBgpC4Mb2dqxCLcL8p21KQHnAI09f97mI13x1zeSN1SWN+rb3NHLBI7qpoE313ymC2ek
	LalhnXq6uHCgEZ5kzWCB3ojUzBzndcjGnBsYwi1+yyam8FcQO4q/R2egEpjp8dPjZASPDL
	VVg8fq6+YRfis3f2IKmc8pqF3si3VRs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=GI4t6+q5;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="H g+efwL";
	spf=pass (imf03.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.159 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 128BF7A01CD;
	Fri, 12 Sep 2025 17:09:50 -0400 (EDT)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-05.internal (MEProxy); Fri, 12 Sep 2025 17:09:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757711389;
	 x=1757797789; bh=CLqRBKVf5IvTh800HM+2y42LrS7XFT+UlQoEp2IAPso=; b=
	GI4t6+q5kXjCO6cruisFBrxlfYspQdyR2nSwyVUifQzM7VEMrmYCNyjAVYjNhTgm
	WqCqX8kZdK2deNSwLTBVJ3N8pSl0NhU5c9HH2kyD2VdFMzafqFVFH9hpDeIJNrzj
	g4Qa7RVKOklHp6T9//Fk2QqJOmtlyMcvCzaPH7vzB72i03nMdNbtRdOZjHzQ4h/L
	ftry70985VVJ0JC8deKiZyhzurfBwKKn5fmc5YLwZO9NW0AWFO9cbhr6Oa1pnc8X
	IbeXUCwwcUmmLw1JIdKGv7tJjqaUU7L6MH1vAFkSQFJ8ZQ5CrDw16pFxmTMYZ3b4
	iRfechyn/kmAf/3LIGcGLw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757711389; x=
	1757797789; bh=CLqRBKVf5IvTh800HM+2y42LrS7XFT+UlQoEp2IAPso=; b=H
	g+efwLEojmMZRq8iZwYjjIYprH/XYxRGz4gmpycxwdhPe1s8+YfTor2bbGv0c0B2
	RLsa8YQz2KykS1Kzwhrjk5vc4sNyX55mlyEc/YPCTF+a+h5XGA1P5EP0qMtntlaW
	glaOlh/Kn+XcHwMTpuhR2UrjWZGj35jBvgxWwqm5OAUbjTj6+VnIzZ7ANky9E3Wz
	IpurPFx3x7zuk4nsRKyP70Og/99u4DsemcafNS5R+S7aIEm+gzBBWkmSBQ6mFI6Z
	sZlMDN5oUpNr0X2A2oOZa95CyTZTboiXtWUjzqMltgruej+lvRP5fnsTfi9FdrWx
	iwGev+FnsPgCi2tPWVfjQ==
X-ME-Sender: <xms:GozEaJ7WVeaEI1J4FNYCAeFSe1bMurC67OT_BB0Jbhk6PWXzJbvBLQ>
    <xme:GozEaG5x_FaTJVZFNRf7pkhjUFbOGrPCkzZW9DKjVtpsq9dK8yfY--QfEjU7m0KIT
    _ceh86DRDz2N8UZEKI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdeftddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpeevhfelgeefleefgedttefhgfffieejkefghfeghffhheelieeivdduteevhedvgeen
    ucffohhmrghinheplhifnhdrnhgvthenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggvpdhnsggprhgtphhtthho
    peefvddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheptghhvghsthgvrhdrrgdruh
    hnrghlsegrrhhinhgtledrtghomhdprhgtphhtthhopegrlhgvgigrnhgurhgvrdgsvghl
    lhhonhhisegsohhothhlihhnrdgtohhmpdhrtghpthhtoheptghhrhhishhtohhphhgvrd
    hlvghrohihsegtshhgrhhouhhprdgvuhdprhgtphhtthhopegrnhgurhgvrghssehgrghi
    shhlvghrrdgtohhmpdhrtghpthhtohepghgvvghrthdorhgvnhgvshgrshesghhlihguvg
    hrrdgsvgdprhgtphhtthhopegrlhgvgigrnhguvghrrdhsvhgvrhgulhhinhesghhmrghi
    lhdrtghomhdprhgtphhtthhopehsvghrghhiohdrphgrrhgrtghuvghllhhoshesghhmrg
    hilhdrtghomhdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:GozEaDU9e-ltO4GjQuBQZhofb5Kj9EDyPaq1nCnmbW-klx59mcvMXA>
    <xmx:GozEaKDK4yJBaHtkl_LHlcH0jkKXOLdoeoxqmFBWV2JzvB84rcbpfw>
    <xmx:GozEaCC2WD64DUi7GSydM1X-85yv-7hi6n4v8g8ii_kFrgTh92XlXw>
    <xmx:GozEaJphW--h3lZUWi9M-TVTnM42xRnish8dD4tvsnrWGtNkHbKeKA>
    <xmx:HYzEaKn6J5RHAuH4Qzhj_HsWd61NA-XKIndTEYj5XMySXeVQsv1vmoqt>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id AFA80C40077; Fri, 12 Sep 2025 17:09:46 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AneuvEk2E7Kg
Date: Fri, 12 Sep 2025 23:09:22 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nicolas Ferre" <nicolas.ferre@microchip.com>, ksummit@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, imx@lists.linux.dev,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
 "Richard Weinberger" <richard@nod.at>,
 "Lucas Stach" <l.stach@pengutronix.de>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "Ankur Arora" <ankur.a.arora@oracle.com>,
 "David Hildenbrand" <david@redhat.com>,
 "Mike Rapoport" <rppt@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Ira Weiny" <ira.weiny@intel.com>, "Nishanth Menon" <nm@ti.com>,
 =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
 "Alexander Sverdlin" <alexander.sverdlin@gmail.com>,
 "Chester A. Unal" <chester.a.unal@arinc9.com>,
 "Sergio Paracuellos" <sergio.paracuellos@gmail.com>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Mihai.Sain" <Mihai.Sain@microchip.com>,
 "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
 "Claudiu Beznea" <claudiu.beznea@tuxon.dev>
Message-Id: <1d58fc51-b921-4669-b6e2-f9a71d1eda58@app.fastmail.com>
In-Reply-To: <f931da29-5f10-494a-acc0-309bd805d41a@microchip.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <f931da29-5f10-494a-acc0-309bd805d41a@microchip.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rd5i6nucth5z8jqwkmfi4f5kc1w9jj5z
X-Rspamd-Queue-Id: C5E8320008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757711391-199958
X-HE-Meta: U2FsdGVkX19yUY5LT6KlDel4ykvxrQwJE3OGJ+hKL6sE6FiH/Wan/61tQzMkD3h/O6fVdaqT6yz+L7jj2pTySzDxkmDj+1lhJbAD8nE/i+RPyo3GpKNwRdKqAy3MJcwAbUW2rxTZnBs2+XGSXOyumFOmvKH5iNz46hsYkxNmeVchj4aEKBQQjBeMJ+h1XlTYsaJpGBSu6GRvLWzFIElxaYIegAq19a45ylKZnSJWfowdY6ncU9XtcjkB9GNS3mf9wj9kdpTU1OYY3nSgVfi9DZxhpk8tVQipiz/1d0JqiYc7F8XsuCmYJWl5JBox4v70n1PaiJkfh54tKEgSK+OKOZgBYa2PV/M6sMV0G0PlCvUgTuKsW+wyhnGS03xaLi+SvDQKtDZybvfBH8OcmV+6FuYMzhjaU2y5oke7NseOHV6aYRt9EYZe9MAQKu7+cdSaf8Hai2FI7yxdnaqEHLte8AsGmbmMAsIthMxFBj1r7tEDJ9ifLxV+JUxH8bfQ9D17McwZGTpelGXf274MhF/pgleEHryNT7M2DnK/ZzTpxGVguaYrvUyH/xZloMl2h07udJFKah0bAg0+ebj0CMDXW6rNRCZgfSzDJBVhndRLLr77YXWgKK0qB6ZYZuvnEWnlDTVgCQt2lIGWI/rBAyQuuyVtPmLG0bJJbgIFH5z5c3TmRMhUvxK/zzJn86ktWp1nknHpThVViUGwzhK+ivdBYk4+KxyJT8mT/6gPzCdE1YqEgRPXA6ROPRlpZUn8BCvxpWVnubnYEdrNYvpBBUZGl+RXyL+QDjlpRvCHyPzB3fnaj0tvqoU7Uz8IoBhycwQDmNIkSXLlnFY+Hm9TtMuqMQsMVk8KFnDALLYem1H/jXVlcbr0IhVzG1NRtKQDjYA85pO7FGTSHeUQXE7IxNx02TwkttHvpX+E0XGN99eG4voY2p6jkOFynvarg2GuAh+bJu3iWgzAR36GmrKbv6q
 mKqjHs42
 nVKAHT4MlJAn2MUE0lo5Gd9uH8sdmSRs4GBXq+QHOmIwmTxs6nZD0KyDjKBq3KUeqQZYwePwfcX4XojG4ZqgnSWxXevascHeNdV3SGI8iGHgBXBdJTKbG7bBZi2GL8VYBSsEvK/lZ14kba7xPOkDGp6Uu3Rko5vNLIwOskBMCvfsH2RRwLqSaCiMDhNjSmTtKvUnZE7AU4LkN3XizoODpJfgYhUYsnwbE2Q7O0rLPuflgZJfDNfAnYILe0dLvigli64n4lkd7hJ7CCh2X1QV+AiwqE/ZOLmfvqEQwBOPIZF2oiI410y+6qxiCuJkeE5AgOByThjKoc2i1yCOjWCvfhGu4S1YPgou909JB/+IKkFv8cwqmKMxlU7MNhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025, at 18:49, Nicolas Ferre wrote:
> Arnd,
>
> On 09/09/2025 at 23:23, Arnd Bergmann wrote:
>> I'm still collecting information about which of the remaining highmem
>> users plan to keep updating their kernels and for what reason.
>
> We have 1GB of memory on our latest Cortex-A7 SAMA7D65 evaluation boards 
> [1] (full production announced beg. 2025). The wide range of DDR types 
> supported make some of these types interesting to use at such density.
> Both our Cortex-A7 SoCs don't have IOMMU; core and DMAs can address the 
> full range of the 32 bit address space, so we're quite 
> standard/simplistic in this area. We use CMA with large chunks as our 
> camera or display interfaces address "modern-ish" resolutions (~1080p).
>
> We use CONFIG_HIGHMEM and activated it for simplicity, conformance to 
> usual user-space workloads and planned to add it to our sama7_defconfig 
> [2]. I understand that we might reconsider this "by default" choice and 
> move to one of the solutions you highlighted in your message, lwn.net 
> article or recent talk at ELC-E.

Hi Nicolas,

Thanks for your summary! I think with 1GB, you'll be mostly on the safe
side in general. I would definitely recommend using VMSPLIT_3G_OPT
as the default in the long run and turn off highmem on those.

My expectation is that VMSPLIT_3G_OPT may uncover application bugs, but
those should be fixed anyway, while using highmem is safer but makes
everything slightly worse through the added runtime overhead and
increased fragmentation risk. The 1GB case has caused additional bugs
because it has a very small highmem area on CONFIG_VMSPLIT_3G and
that can make it run out of highmem first. 

> Of course we plan to maintain these boards and keep updating our kernel 
> "offer" once a year for those associated SoCs (with maintaining 
> upstream, as usual). As you said, being ARMv7, we're quite confident for 
> now.
>
> As you mentioned, we've recently released one ARMv5te arm926ejs-based 
> soc: the SAM9x75 family. But we don't have the intention to use too big 
> memory sizes on them, even if they do address large screens, with LVDS 
> and MIPI or modern camera interfaces...
>
> I don't have too much info about our customer's use cases as they are 
> very, very diverse, but don't hesitate to reach out to me if you have 
> questions about a particular combination of use.
> Thanks for your regular update on these topics.

I'm curious about the AT91RM9200 part, which I think is the oldest 
SoC with Linux support that is still advertised as "in production".
I understand that Microchip hardly ever discontinues parts, and there is
clearly no need to stop supporting it as long as you maintain the SAM9
family, but I wonder how many users are still buying this part or
running the latest kernel on it. 

    Arnd

