Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88714CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9638E0003; Fri, 19 Sep 2025 10:22:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942B58E0001; Fri, 19 Sep 2025 10:22:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BC818E0003; Fri, 19 Sep 2025 10:22:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 60A508E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:22:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D953887567
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:22:56 +0000 (UTC)
X-FDA: 83906216352.03.9D68358
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf04.hostedemail.com (Postfix) with ESMTP id C778A40013
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:22:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=3P7vtOxX;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="N wEFh+E";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758291775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DGBIXWoQfciFg5TTWblokxBsiewcOE1bszsE8YzDKWM=;
	b=T9iabEFKngf77+6c/buP3mcYnTkV8o/oPPOP8wTKhkw+7IlNsm9RALwJpV67R0X6S5Gt1R
	cyUrlyhQkio8By7RfWB89sAaM0zR8WHJYPTH8UKf45wIooTdYgpfrLv4ezqKjX4lFm7WWp
	Oal7jTwqhdbxSuLg2eNPytRNShKQ4vU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758291775; a=rsa-sha256;
	cv=none;
	b=Snqg2ruqPdALCMDh8vLoneXeYslGNerc5tgHMz8UHRQngJHa0XfTSxvp1A/DZA5VXShPWf
	EqeQo2Ju93/Lcj9dqkcNWT0ZwSIWyMsPgeHdPtFJANW4TyYo5JJAmUGOUgCJImaMw6K125
	m59yhApuIk33JgzHKOADwOVo4Vc4Jf8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=3P7vtOxX;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="N wEFh+E";
	spf=pass (imf04.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.154 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 3BC477A0068;
	Fri, 19 Sep 2025 10:22:53 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 19 Sep 2025 10:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758291773;
	 x=1758378173; bh=DGBIXWoQfciFg5TTWblokxBsiewcOE1bszsE8YzDKWM=; b=
	3P7vtOxXTlRKZGWlZLsRFVQlQg4bj5SvQvb5v1zmryo4PCz5xUCZ/fSZUuL33qsW
	2XFxpoh130HNWVqUH00GYFR2OLcWx0fbXjhyeBAR8yseNvBXLhN/0OOMJL6U3cy9
	NOxQGScNJsPb3WM84wfJPFb4rdhDXJNr0eUbkkBFZAqgCNYQVkp1Eolbo7eGfx6T
	UIhoCwGZmmCD2l9Vdt05U1amomaUxFZDiopcE8Uiha2UPEfSrnPL/cBLPrd/w2SK
	AOAYXKR8GES89WQNC+kxfLcj7gP5oZndIPzi3FtUM0Qapm2gqlAC8zK00Iux7Czt
	u3Hzk4X0b7bccGPCfsVDGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758291773; x=
	1758378173; bh=DGBIXWoQfciFg5TTWblokxBsiewcOE1bszsE8YzDKWM=; b=N
	wEFh+Ehq8I5Ne8BUFO132THoMndwZ6szg6zS6b+qZvszYrP+sSryFfqlrr++t+re
	52mUZjJS/MqYpcQK4IrqneI3Q+QV87n44m8BdrbXyltTFUsKqWVoFc7LxhztSzR1
	/CyOnK6h4cAgGvOrrvZPqQ+kytQaKCIBFxaNl1m4svOmCOmwcwS8Yq4fdKJu928x
	+iYoSc2Dwk0r2zFgWPLHA2uWyYEEbO2I/L1Q2EIYz5f60VEk6QPi921HwITH7WAh
	xpt1386OGSe7LQJ7/CDBPPYMPl7W+ZdVVK91Q5wl7+/wWjKCPzRy6B5d7I5vClBH
	kLIZeQgRg6fEx8N/FKj5Q==
X-ME-Sender: <xms:O2fNaHPZsDEluqQ3K1xXVYzEPxMOHfVlGvrDBsZCIGFfPOnh7MIMIw>
    <xme:O2fNaB8EpINHV6429QucyQqOJUWdlBgZRzftFfr0w1fqno7OIhXeVkca9g9sUwCxx
    WJ4lzYGsR2mwvafSTA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegleeggecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeeftddpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheptghhvghsthgvrhdrrgdruhhnrghlsegrrhhinhgtledrtghomhdprh
    gtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhr
    tghpthhtoheprghnughrvggrshesghgrihhslhgvrhdrtghomhdprhgtphhtthhopehgvg
    gvrhhtodhrvghnvghsrghssehglhhiuggvrhdrsggvpdhrtghpthhtoheprghlvgigrghn
    uggvrhdrshhvvghrughlihhnsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgvrhhgih
    hordhprghrrggtuhgvlhhlohhssehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhurhgv
    nhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrg
    gurdhorhhgpdhrtghpthhtohepihhrrgdrfigvihhnhiesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:O2fNaLcxJAwbyL7fF-hDxzqk5CnB_5srfmblzDObKefDa2_Yw3Nu9Q>
    <xmx:O2fNaI_XmRHiAy2z_8UrPdVkq5oq8nmdQ4T2W7CdP781TiN2_pBACw>
    <xmx:O2fNaJixEsf2I4UZLqtJvoBDqXbeFMrBT42lISbnoEN9uVt68m1a8w>
    <xmx:O2fNaE_oeBhVK0r7xewR08-ipIjEJmwOjKy_oXBB5MOm1ZA557kJ_A>
    <xmx:PWfNaL2dV5R9mOO8RHYelr4frobgiBB2zH1lISJhguP3OD7Lp1pVdNvG>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 04B80700098; Fri, 19 Sep 2025 10:22:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AneuvEk2E7Kg
Date: Fri, 19 Sep 2025 16:22:20 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: "Jason Gunthorpe" <jgg@nvidia.com>, ksummit@lists.linux.dev,
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
Message-Id: <547dcb81-434d-4910-aa7c-1d69019fcb3d@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xes6ckbsq87a53oy8ucmxu99b44yikdg
X-Rspamd-Queue-Id: C778A40013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758291774-457551
X-HE-Meta: U2FsdGVkX1/QxhvJYhDEyXg616BCXu9b6P9/rmoe5pQbz9twzn5qBV/p7GUyBtDXHaKE/w98kyZFcFCSyj3ks4jFXrQH/dQ5GAnLiVnmKEYmtcnOPcfOTLU26p8w9d8mFwt2AUHasQ+daL81+V+wrYPQQezwLyZWPHxP4CgzTWgJEccszSWx7MKk5mLqLqt9E5cnQlNSXzIvFPSA5+qMUO4IYLbBuXp/8zjZFTYMtspwomsztYzpR+U4KOv0ddF7h5+KRd8fdMvXXrYqsuFOTIEhgOvAQPhAXrcSJ8Ga4gN60iaW8bU7yEFBXdNBpsyoeso3Pm97UtjlZ0uyxqklYFAV4BskR18xpOyAW33Uuq0l2+1vq98t67ryBaHsJpVmta2qsFAH3cTYN2Yvj3soqGRaitF1J1l2jHD6JAtOQqtD+AVLkkxCzkTjNubknKaTW7HKz1eInx+4axNZW4rjmJ+XNRgWDBwEMsN1UCZsw1XX6WxI2ngJWLzY/YR3U4ieWNqXbb/vC41IRbr5nfLaLd5RCpUKJ0B52Jjydrn2JRih04J3e05DOde8AByK3hNZ8HODi55jajJxpxvET5+jjcTiM5u5nxOIeYqp9EYNk3mWGyvY7+C6NQnXmBROly4E78fFsb1QvhoGrRqQ6vJwS654la+GlHnoCk+bp+UQIzVqVpPATAq/6NqGZi4cxqiosNsMBjQAkomj5x/iYp1mCxe0gwq/lxuX81RZkGo07L5ZIJVRNHV8mS4rOuupQ9buP4r9IL4BXkTWlFZvpDUD2LqSnrQeeTaCW7QpNIK8c36hqU2iuJv9S1RZnmoN/AhWKpp7wIGrVHdwkduPPNl8P/W5mFqTY+bpbQjdJ9AZuEMYOsX45SIzYf0fkGqq3xCHifO3V06SRm58VF+1PY67DLnYcWkHmh/1bpTLjfF2cewfbOu7Ps1H9+nx2bOfRsxa2/VIBIO0XUmsnyOZzqC
 pwtW8g1x
 dbY3vPhdQCZs98vJHtiPB/gCqnrk4b0GhUMFeF2ZEjfqlnVKFxNoUDdAMXb6OO/NakfoXKu3dKnhKVORdERKnjiOOKep1zahtFHEWXZYRyw/dORAUGeMyIky4aaMUSi+tK9r3lnEKEZwWLB7k/0KmWsUnZj4kdFyVi3RxH5fT9qPPgpwyHoUqY15H9G7v0W6MLnM8emQRqKSnE/OKQE9bB/MGVBv8bwrnX/jQ53WX7ulL2QoAovXEOnxmC3rZClX0M3YLkMezfcua0BShdzCJaYaw9VCwb1YikWO5RZU5NFbDkSBM1Gcfy1TVwTlruSRzrMQYoKfV2IkDsevJ3yNpI6geItkAi/JiAs2b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025, at 09:17, Geert Uytterhoeven wrote:
> On Thu, 18 Sept 2025 at 15:13, Arnd Bergmann <arnd@arndb.de> wrote:
>> On Wed, Sep 17, 2025, at 14:59, Jason Gunthorpe wrote:
>> > On Tue, Sep 09, 2025 at 11:23:37PM +0200, Arnd Bergmann wrote:
>
>> * Microchip SAM9x7 is the newest ARMv5 chip, clearly does
>>   get kernel updates, and the only one I can think of with
>>   DDR3 support, but seems to be limited to 256MB total memory.
>
> Are they limited to DDR3?
>
> IIRC, someone (you? ;-) told me at ELCE that Microchip keeps on spinning
> new variants of old SoCs, to accommodate the changing DDR landscape
> and market.  So perhaps they also accept larger RAM sizes?

Yes, that was me. The previous SAM9x60 was released in 2020
and I think that one was an upgrade to a smaller process node,
raising the clock frequency to 600MHz and adding more modern
peripherals, but I see now that this used the same SDRAM/LPDDR/DDR2
memory controller as previous chips, with a limit of 128MB
total DRAM.

SAM9X7 in 2023 added DDR3 mode with up to 256MB according to
the datasheet, no idea why they chose not to support more,
since a 32-bit wide DDR3 bus should allow up to 1GB with two
256Mbit x16 chips that are widely available, or even more using
expensive 512Mbit x16 or 1Gbit x8 chips.

       Arnd

