Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D943CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCEED8E0005; Mon, 22 Sep 2025 17:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C57498E0001; Mon, 22 Sep 2025 17:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1ECF8E0005; Mon, 22 Sep 2025 17:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 983958E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:23:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BCD7850F4
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:23:06 +0000 (UTC)
X-FDA: 83918161572.02.90F0952
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6443A14000A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:23:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=BOU6mVcT;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="g mHBoxt";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758576184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di8U+yHpW9PWxGMprMpa0qfyAiwc5nChUHQPZxjrHH8=;
	b=fhD8dqaAmR093E1sXUDhg7Idm587QWZvsnVlew0MHjxHG3turTSF3+RKQHxh7cwoNhK+tu
	bvXLVvlAVVATTTeIsj0iHiYCmCtVzUMsIZnYGB4fYyyg+Kz4g+bPfbf1PbYZShFzi0EP8K
	ck8IodqXiTNO8ExOOOUJwijvNXa0YBE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=BOU6mVcT;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="g mHBoxt";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.150 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758576184; a=rsa-sha256;
	cv=none;
	b=fYqmoNWyq6tsldR6uYZuFpMEJP9jb/WnC8wqmDU/FV3K1n1fry5q7bZUJtfcUYxdMX6ujI
	Gk/m18w2t6NLq1RTPwSI5/+rcVig83sXOzRbl/mDsU7MCtouqaD8wEYki3nAkMqPrh+5RC
	g9rowTMbCDeMW5WreQPl54bGWwo9EqE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 97915EC0301;
	Mon, 22 Sep 2025 17:23:03 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 22 Sep 2025 17:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758576183;
	 x=1758662583; bh=Di8U+yHpW9PWxGMprMpa0qfyAiwc5nChUHQPZxjrHH8=; b=
	BOU6mVcToMxa6qFUiC6cht0bV05a8ANyKR5ukskNj74Kgap+DqTUaWSu+IKdFe3l
	WRpUM30Wu3H0Q7A2y/voOAEVMz1ItWGdFd+w1g29YJ7Tjl2aT+hQdsIjBYzOSRat
	P6tosIN336s/ecXEeQ/mGTufNXrxc6oPikF3ykV/4Wx5E6r8XKZkcW5rH07dbYAi
	hVS+ZWgjs+wGKwhWw9MlR/A61u1V4gi072jORA/RDnj7Nu/QRBfiadbi2FwamY3C
	z1g3eaCmC+6ZV0VO36eJ9rA4ai9KBUyUl+kX8rwbdvVby3ynOJZk+yOUH9dNivMj
	J6BkZ2jlIo5ZNgAXnGA8VQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758576183; x=
	1758662583; bh=Di8U+yHpW9PWxGMprMpa0qfyAiwc5nChUHQPZxjrHH8=; b=g
	mHBoxtTQev5hHzzjS7DzOG6LjQc2O42dSxLb4L6WQb2WlRSURFQb5PpcuBN2HTms
	62d99pLVtJPUCF7OT5ICVSqlboyOqdGHXJIUax+oI0O3IgOolDGEnOWayvlw19bk
	GTctlMrBtCTrn15fz5C78bks5N4t7sTFyuHhpbp7bypfTbN9jsFm7miJXebzUTbu
	GkBm5/mf2z9Lam8hkmNkaZhD/Aa8ufZ9KIVP69Ld+kkRg/FCv7kH/PRqbJ/kSgjT
	Ys/j3Va2f5abW1fJBGV59q3b0QcV6n8w4sBB+Pm5+Jpany6I0MqmylWHR2hKS/7W
	p6MNsjIRV0fcgvwbafw5Q==
X-ME-Sender: <xms:Nb7RaHIv0elNNGqKqz2hq59PlbQ1WvH3PQekoKoYN6GHdrkbplcdZg>
    <xme:Nb7RaF9zWPO1z0eI-85xdehQcHCJ4U-ixtIweYwspyjZNwYzs6sJyQVkn2QKVroo2
    tuHZCnZ7Y6hRCAk3yvZYtO1xCbsZ8geow9JBfeHT6Z-a8qAnaICeO8>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehkeelvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeefuddpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheptghhvghsthgvrhdrrgdruhhnrghlsegrrhhinhgtledrtghomhdprh
    gtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhr
    tghpthhtohepnhhstghhihgthhgrnhesfhhrvggvsghogidrfhhrpdhrtghpthhtoheprg
    hnughrvggrshesghgrihhslhgvrhdrtghomhdprhgtphhtthhopehgvggvrhhtodhrvghn
    vghsrghssehglhhiuggvrhdrsggvpdhrtghpthhtoheprghlvgigrghnuggvrhdrshhvvg
    hrughlihhnsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgvrhhgihhordhprghrrggt
    uhgvlhhlohhssehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhurhgvnhgssehgohhogh
    hlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhg
X-ME-Proxy: <xmx:Nb7RaHyj4-U5cmLtj8aV6Obmj2wE8qDHFtnv04wApvnSKRdpvOTwyQ>
    <xmx:Nb7RaPNEf6QOHCcg2sOwG2YcDZEDgMATtieOS7b2v4iNsq7NAARQhg>
    <xmx:Nb7RaM7LJ7xoeWbjkfv203dQeqEDMpWgwtURBYX5yI5dIc7-dM-KOA>
    <xmx:Nb7RaGcvvcBerj7e35_eqxKXMQdHMfkXoSuoEeKpoVO0WLLALUm55w>
    <xmx:N77RaF-PoW2bovyuykM0k5mv84evTeZMjlxPQrSMV7i2vSrQZNKLFHZX>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2385C70006A; Mon, 22 Sep 2025 17:23:01 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AneuvEk2E7Kg
Date: Mon, 22 Sep 2025 23:22:30 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Nicolas Schichan" <nschichan@freebox.fr>
Cc: "Jason Gunthorpe" <jgg@nvidia.com>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>, ksummit@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
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
 "Andreas Larsson" <andreas@gaisler.com>
Message-Id: <598ab56d-7dd0-4adb-b0fe-30ad5cf24335@app.fastmail.com>
In-Reply-To: 
 <CAHNNwZCsBY+ta2-OqD40K0-C8N25PLMYfOJowiVeaEMotqR1nQ@mail.gmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
 <547dcb81-434d-4910-aa7c-1d69019fcb3d@app.fastmail.com>
 <20250919143436.GC2132010@nvidia.com>
 <44f910bf-ac2c-4b2f-8e50-5cfc7dd0761a@app.fastmail.com>
 <CAHNNwZCsBY+ta2-OqD40K0-C8N25PLMYfOJowiVeaEMotqR1nQ@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ed863j7beftksssaw6ko1rbsfm99tfm6
X-Rspam-User: 
X-Rspamd-Queue-Id: 6443A14000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1758576184-362957
X-HE-Meta: U2FsdGVkX1+rTMu9VRLUlurzr9RDJhEg1EmqGDwYeXXwjlwwujBIOKr52mxTQgM4nnmnyWkBGfGosznZew1Zo0zyjb3UkVuXTxcDI8+AzeCotAwSvzw103VVJDoM4EoVB0ln9mwAAF6GF1pQo5nMNOd86oZyUM4Gt5xD7kpPC84mc4OwvIIl03HUoMTh+RhlV8vEGc66TbAfnhPE9G4NWdVzOTN6QFK4bEO8o76VgOWaMatBU2jpqsCHupGSVxzmiZ9I3J5ababVYzvifM+K2IqyVg40oVm6rZz1ouXVipmzZxdQFGe9GLILkrrVwUiTjYMdYwhDwEMv2BQng/gaTH10M/vd9XOD0TRg7wkQZHsJDE0/7G+UbltSQJ/2sOrMKc94r23pFsIciOsvuUwoVE9gkOIdkdsUAJmijNowFkP2XXwq8+dDQaXdCeHhR96vaj9zoTrwxXkP1NwIPJu2tiNCtXKGBTTBz33dlKJORncbCB3V3XE7Fo40SQoYosfM+DnXgETZUcaz2sfVgyCRqEaPP7VCRhxmFKnWlcV9Fk3UxeB1TIF+RgK7rbl0KMDMOO3vIzIBRCKSK6SBogVuKfqpVjxqLhOsnLLq/W02bWbHi4cmnNbzWXaNOvODlj6KC+E7djHyWl6eIMs/3DihP4qGTjKSNhC6TpVfAJ+8p+tmOOc6T/3bHEpmK5Gt6DtR9XdPOaPA8rDSp02sOGyM8lRsPnC8n1j+vdUA12qoI1kS2o3lH+mBgJYZlLLfw0jDeHtMOXYeWxEQ9euArbaMtXcVxn8706iCQum1B3RD5t/Evdz3QIhC7XEEDWKDmpaVJDKijkfElAwVFU8949Km4ID1Ov+1TUn1xWRAoadPyGr/qcxMLTy9ug2HQA0GPW8J6QnR05hzKkyfYnFFRfmcXUHvnP//pMjWjdBfH2hSDt1tEw26PSaXC6fSqMrF6zaYe/MIsOHn2ftpiE8HeH+
 yoYoKPVV
 wCjvw8MqNSMXkDVAQHlf296MBNN6wQ5DEtKrmB8BbTlRGh78gXWl5lDDcOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025, at 19:05, Nicolas Schichan wrote:
>> On Fri, Sep 19, 2025, at 16:34, Jason Gunthorpe wrote:
>> > On Fri, Sep 19, 2025 at 04:22:20PM +0200, Arnd Bergmann wrote:
>>
>> I did get an email from Nicolas Schichan (added to Cc here),
>> and he is still supporting a widely deployed Kirkwood based
>> platform that uses 1GB RAM configurations. He should get
>> a chance to test that with CONFIG_VMSPLIT_3G_OPT, but I
>> would expect that to continue working, possibly with minor
>> bugfixes.
>
> We don't use HIGMEM on our Kirkwood platform, we are happy using a
> 2G/2G WMSPLIT. We don't need a lot of virtual address space for
> userland, and with the 2G split we don't waste physical memory.

Ok, good.

> I'm happy to test your patch serie with VMSPLIT_3G_OPT and see if it
> still boots with it once you send it.

The patches I did for turning off HIGHMEM on ARMv5 won't have
any effect if you are already running without highmem, so I
don't think we need to wait for your tests specifically.
Any testing would be useful of course just to check that
everything still works.

Jason, I think we can go ahead with your suggestion. I can
post my patches for review once I've done some testing on
them.

     Arnd

