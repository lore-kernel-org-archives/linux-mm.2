Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 698FFCAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 07:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A894D8E0003; Thu, 11 Sep 2025 03:55:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61288E0001; Thu, 11 Sep 2025 03:55:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 976ED8E0003; Thu, 11 Sep 2025 03:55:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 866578E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:55:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 228CE1DE67B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:55:51 +0000 (UTC)
X-FDA: 83876210502.01.C59EF3C
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf07.hostedemail.com (Postfix) with ESMTP id 130F740003
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 07:55:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b="Iu/xuWao";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="X IlM4cT";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.153 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757577349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xezEPREPJQkkrl73Yff7UEqumVCaWAif9r9fc2gAvZU=;
	b=SVrBtbIyVpIYKx2wsmBgjn2BKmZ3uJNKsgwDEpvI4v1TEOjLKEcFOyoIto6LIEVatafcGr
	QNBkDypI9zM2IiR8cLa77fDY1i/vXTyKauGD0yn8l/nelj5dyKemmCwavpMmCqiPxltpnU
	5El39S2RT5sYPJctNcxrbzt5FB+7OS0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757577349; a=rsa-sha256;
	cv=none;
	b=5kaCTKxFVFhJeizrbAH6BbpBJBD0M5bN2K3xfnJT6hr+82YiDuRSYR0meJSHttXftpqipb
	WnGdMznHYkuPnElLKYbcB9iO7gLHwkBSCIaA48tGJXTLqbGK5Z5rCuNVgUoj9Ih2wVVvz2
	wzUCNbuJk6iwS3lbsroOEvU7gaWuAeo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b="Iu/xuWao";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="X IlM4cT";
	spf=pass (imf07.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.153 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 612031400147;
	Thu, 11 Sep 2025 03:55:48 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Thu, 11 Sep 2025 03:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757577348;
	 x=1757663748; bh=xezEPREPJQkkrl73Yff7UEqumVCaWAif9r9fc2gAvZU=; b=
	Iu/xuWaoII7KNzuVcloK0wQmhd56+d5wX0Bleltp/a1sZa3XhGzX/yG9JsPSkl/7
	2cu0Mu9lmvGcmqeKU6/KrMP/1aCgzIef4N/ewbqrmGkduxdjqLHlEalPav5le4TA
	+jbgQ1Z+mvU5GokUwPzbGIhEj3HxlMneK0jBDzXQV6kMI00VxiXlnhook7P+C5Y7
	UriP1BgBZbVa1zMIyagjnMw+2sY7iskhAR0+3srbSjSH0y3Yg7G1I2wCRXsEXXYs
	8KS2JECjFLMhfIZNMjx0egOaiCksw2shqo/EvFx/UtUO1SZUtqDZzPy4b136cHwy
	fnHZvT9pGYqsuKxHDCD1Vw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757577348; x=
	1757663748; bh=xezEPREPJQkkrl73Yff7UEqumVCaWAif9r9fc2gAvZU=; b=X
	IlM4cTNCufTDuTwE3rh5KIXiSVCwiy8YX9A8fo53sWQ4p2TKGrlQ/9DVCBOHTBG0
	ffEsLPh+36l9na0nrD2CgxP/dy96GoNkRtEQRzG5aK6nn56aYQGtYTO9P7Y8UiUs
	an20A9oCUfkbsypc1JODoplvQuBjF8st8s1x31lQ2U0SYE4Jn1XlEMxhnjGHJwJg
	CNtYItDmOsxdBDmvbtNp8EHZzfn0AGkDnlRRUoNT54QTlsnpmjuslvLqJymldyuB
	7h+E3hJYEoPPv37Hpq0Dkh4acaBuHq9oAPE4oR1s4jxxyqb8Wde0k9toW89TrDKm
	U4uNM1J+ErI42a2u/TYQg==
X-ME-Sender: <xms:goDCaKLlbLhafX1ItUb5fO7F7xQAPgD71xlygMsk3wgbEP7eJM2VEQ>
    <xme:goDCaCJu-9GwvmuDVC8Y37QomJEPe0pHbKXVqPPiqeh9QFxf908KEUF8un4MQt4Yp
    DHkwlYQwPBqiaQ5cv4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvheeivdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheptghhvghsthgvrhdrrgdruhhnrghlsegrrhhinhgtledrtghomhdprh
    gtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhr
    tghpthhtoheprghnughrvggrshesghgrihhslhgvrhdrtghomhdprhgtphhtthhopehgvg
    gvrhhtodhrvghnvghsrghssehglhhiuggvrhdrsggvpdhrtghpthhtoheprghlvgigrghn
    uggvrhdrshhvvghrughlihhnsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgvrhhgih
    hordhprghrrggtuhgvlhhlohhssehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhurhgv
    nhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrg
    gurdhorhhgpdhrtghpthhtohepihhrrgdrfigvihhnhiesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:g4DCaPln0xPi_AdWtVR-mPv6uC8M-3Q_mjf16Kd5LjcVVSzFRbJ7CA>
    <xmx:g4DCaDlZzyLWYRlZII_JRVLfe6viWHF9oK_S1UNgWncQPOR1vmL64w>
    <xmx:g4DCaJdy81733zjxS4Q3r5w2j6PHhciLt1QMfw2trLXRldoMsUuYcw>
    <xmx:g4DCaJIi6RXGIaczaDEPnKMDiC-8AkssR85-snNhqeii8rn1LFIfJA>
    <xmx:hIDCaH7vVqOM0fbJf4funeExzGloqdRoMAB7v2eOhCknP0mHQleXCcBx>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D083E700065; Thu, 11 Sep 2025 03:55:46 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AmcCJOTBQ5ho
Date: Thu, 11 Sep 2025 09:53:45 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Andreas Larsson" <andreas@gaisler.com>, ksummit@lists.linux.dev
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
 "Sergio Paracuellos" <sergio.paracuellos@gmail.com>
Message-Id: <363853cd-7f10-4aa9-8850-47eee6d516b9@app.fastmail.com>
In-Reply-To: <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <5d2fec2b-8e59-417e-b9e6-12c6e27dd5f0@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9akiedugbkinusjtm36xudsy6kgii9iw
X-Rspam-User: 
X-Rspamd-Queue-Id: 130F740003
X-Rspamd-Server: rspam10
X-HE-Tag: 1757577348-540332
X-HE-Meta: U2FsdGVkX1+3gLFfCtPSliZNmk3pFGKrmyha8Vy4X6Wq3ORTxqSf9e/ZVbRrIVu4et1YSWdHeDoiMPs6lPvOdp99NrsvgSeeCBDT+MbLv+BYMBhXmj1DTQhA3p8NLeeWStR0tWkn9+kJqIxVSDuOKXG1V49G/e4RLkIXrKQ434PrRtpYpZmul2M4pTpFAV/D3ergyg/47BnylkYptMwTJ31zpp4mdC5DLs7b+GDXsMuOEWLQ7uEC6tieTGUeSTSsxhAkVaAIP5Tp544NZxfuOVhMO+VTInD0GdktECTIP0xmSfMUoiDz9de8kCb9aPOvoPRaBZvQrdvQSdT7+UflJAl9kwKqMIufhSzGhlglk7yyD0mIP5fI+R+mUUyBJcojq/fvOo+rc6z5SIzVRNhq9p7XCxTQz+eE3L9VbP9LuHP8IHYnHSotgFqQBa/3rEWTdBiKKvfE+XcY0K58bmR+zzrYGsb2HMDPgCCEeI5rgCaJeHJLn+eEE/kqGWnaH5gkrqaD8jNSd7rs+Ru30N2CTc9h96kOjnJKN/rV74BEMCQMqGt+zQ/rS75g6zPDAnG+wvK5qWhiINMbB8GmumNy9kVhqIxdj1Ez5MgFukqPd71CQ4mXsVAOOtaUH4LjY9LaBDTdsYHWMLBCrwQ6cr7R8f/sQ7omfYrVVNbvL9BqluAqzuvuIopDjzNhmYrg4OBax7PQQRHdEeumVW+1W6U8lENBU8/tG3TwgOrNPV3Wuv3Hduq40Ex1qjj3Mhwwohqpd8RMrr2a8gyMvHnmU3mLDpXYiI+6O+gq5qTMf5BIbbLEVsJxzcE30QD95TGqif9ACRJ1Pkc7w3TPg+3katG6+Nb18Z7jKGt8lkV9uh6n/EICeOs2mp70YGQf26ProTXTiDv+DtkEBCHgPI3k78v1OawmBFF1IQsmf8hXwxsN/B14YZ6WRO4JzMELzTe+ApnahYyUhLiBCZh+ENYc3WJ
 b3MawB/5
 M/LqsZZ5hZDKozZk2aNVTowDmJeLEKtruRRKEYVFuARzf8+Lrbk61SbP77p+G4Dt8qe55mIVwOfQSfGxb0scbxFY4Mutdfw6uSI5j2dkqGY5+CNsWA1Aycx/kZNGttfyA6NmwrZuU5Ka8V1VtXLQXv94t1ObU746l5qCW4UREmMY1PsNi/oICl+rxYj5Ces0bjV7yWQu00s9pcs8GRldq72NUvXN5gl5YqpUERsd2ZHqM3c0az2MoI6gfOLqmi9IyvF3eIpo7yQl83pQlUeqGMVPK4Ga6+0qlTfMAr90y8c37y+GZ6ssGs7IVYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025, at 07:38, Andreas Larsson wrote:
>
> We have a upcoming SoC with support for up to 16 GiB of DRAM. When that is
> used in LEON sparc32 configuration (using 36-bit physical addressing), a
> removed CONFIG_HIGHMEM would be a considerable limitation, even after an
> introduction of different CONFIG_VMSPLIT_* options for sparc32.

I agree that without highmem that chip is going to be unusable from Linux,
but I wonder if there is a chance to actually use it even with highmem,
for a combination of reasons:

- sparc32 has 36-bit addressing in the MMU, but Linux apparently never
  supported a 64-bit phys_addr_t here, which would be required.
  This is probably the easiest part and I assume you already have patches
  for it.

- As far as I can tell, the current lowmem area is 192MB, which would
  be ok(-ish) on a 512MB maxed-out SPARCstation, but for anything bigger
  you likely run out of lowmem long before being able to touch the
  all highmem pages. This obviously depends a lot on the workload.

- If you come up with patches to extend lowmem to 2GB at the expense
  of a lower TASK_SIZE, you're still  looking at a ration of 7:1 with
  14GB of highmem on the maxed-out configuration, so many workloads
  would still struggle to actually use that memory for page cache.

- If we remove HIGHPTE (as discussed in this thread) but keep HIGHMEM,
  you probably still lose on the 16GB configuration. On 4GB configurations,
  HIGHPTE is not really a requirement, but for workloads with many
  concurrent tasks using a lot of virtual address space, you would
  likely want to /add/ HIGHPTE support on sparc32 first.

When you say "used in LEON sparc32 configuration", does that mean
you can also run Linux in some other confuration like an rv64
kernel on a NOEL-V core on that chip?

Aside from the upcoming SoC and whatever happens to that, what is
the largest LEON Linux memory configuration that you know is used
in production today and still requires kernel updates beyond ~2029?

      Arnd

