Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4F1ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:13:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C918E0109; Thu, 18 Sep 2025 09:13:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C388E0093; Thu, 18 Sep 2025 09:13:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E3F58E0109; Thu, 18 Sep 2025 09:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE6F88E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:13:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D94B1601C4
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:13:43 +0000 (UTC)
X-FDA: 83902413126.01.A1CF5A4
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf29.hostedemail.com (Postfix) with ESMTP id F36E3120008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:13:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=1ak7ojNe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="N 58W3tD";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.156 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLSf0bVUw5MCqJYDkX+vxsx4UdqQkDXJOmyg/3GZX6I=;
	b=8O4ZxY05R3pAY1eBscCVVbgsbE/K0uzCw5selCGRw78cE64gaRY71HGQVmu1M7qiyHQ+OL
	yimqc7BHNANTE1oRvLK2L2ogQ05ZYduICCD76Yc7dsfcqV4vOpKSnfIEqiHqSmVG2zkMk5
	RRBtilgopaPThMd7CSrTRKJ+SxLeS1I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=1ak7ojNe;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="N 58W3tD";
	spf=pass (imf29.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.156 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201221; a=rsa-sha256;
	cv=none;
	b=NTaMqOiU6UygG8K4EEEgni01XBsQL0sWYNXeyslr9OWnZrcaRcTkMvmi+IkEcQlqVXMA1t
	w2AKWeIKdWyQUrg2I70lShmowwdJglPy7omIogxUTx2ztcvjhZygbs8i0HsqVLQePy6PVW
	VaEEbGTxA4WsrIVPCTYpz0v8oJRYzFU=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 4D4921400123;
	Thu, 18 Sep 2025 09:13:40 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Thu, 18 Sep 2025 09:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758201220;
	 x=1758287620; bh=pLSf0bVUw5MCqJYDkX+vxsx4UdqQkDXJOmyg/3GZX6I=; b=
	1ak7ojNef1e3g67ZCzGe8Cr86CQBJ+FtYUUdZ98wga8fH+3vuc+RwkTppRISmifj
	TUQF2YYM9tYsbtzlw4/SjUUoGGdmMBn5Tx06zjVUjlInz+zUP3GqpAoEjzvsx869
	wddDDt+HjXSiHs17uF5aM1hYdPjyFfy6k5SzRR6jWICdWQiEVv359WWJgj132jJJ
	07v99j6h/aqeBEffHIyXve8yXE+JF2yzFo9WhjAf903RFRHGDj74a+pThncDZ43U
	cChz0t8T2JlvSu/bhlxR1hPt7TnIjh7DK2BI84tuHaRAr5IdA5Jn/e/MNKeBZUvX
	Ow885bcZSVPcmIgNRzukfQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758201220; x=
	1758287620; bh=pLSf0bVUw5MCqJYDkX+vxsx4UdqQkDXJOmyg/3GZX6I=; b=N
	58W3tD5qawBw1eKsBN+kr6ZcUHb/ofQFbLKmLhZdv+qguzRhHYAyDLKSfwESXhrf
	aIY6l97xj+oglomqiNtEG7VTMJ9wGTjdZMtSQXPvA0EL9TgggVm3rQC5HzIiRV2m
	5xDJYwe8g7qsIUc9Kj38PQcYSOITY0LVGaKueq50doFP6bW244OFrN22sPeENXIY
	jA1EycAhUpQLSIWjFRVFE+zrgWjqWlsWl40HCwEKhwWQaCWvW/njRnEmJDgdvYsK
	zw0up4/m7eOD9/kuy1jxPa2+IOIk6ItpAJZUa8eKMXOtJiiJT+cAySSGyZ4hEycm
	gElUUMqK3gL3+zK38/pmw==
X-ME-Sender: <xms:ggXMaPqxmIxuS57jlyxuYXMmHn12czYQdlZwV1PqJq6k9KYeiwbKhQ>
    <xme:ggXMaJp_WDMqihTWUxA0KZ9pJgwdVmKsCp-Vn1fdREcdFTwl75fs0leTwW73akmHR
    JcpMICm3hi5jq9-VNY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdegieegvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopedvledpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtoheptghhvghsthgvrhdrrgdruhhnrghlsegrrhhinhgtledrtghomhdprh
    gtphhtthhopegthhhrihhsthhophhhvgdrlhgvrhhohiestghsghhrohhuphdrvghupdhr
    tghpthhtoheprghnughrvggrshesghgrihhslhgvrhdrtghomhdprhgtphhtthhopehgvg
    gvrhhtodhrvghnvghsrghssehglhhiuggvrhdrsggvpdhrtghpthhtoheprghlvgigrghn
    uggvrhdrshhvvghrughlihhnsehgmhgrihhlrdgtohhmpdhrtghpthhtohepshgvrhhgih
    hordhprghrrggtuhgvlhhlohhssehgmhgrihhlrdgtohhmpdhrtghpthhtohepshhurhgv
    nhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrg
    gurdhorhhgpdhrtghpthhtohepihhrrgdrfigvihhnhiesihhnthgvlhdrtghomh
X-ME-Proxy: <xmx:ggXMaPyueOXB7yEQObwBgenAb7JQTgJqnB9NOI6UKzHpBn4i9VSQEg>
    <xmx:ggXMaOPqe_O8XUcPksli8MZC-GvW0FcpQCzBR-ts3xEmFaWKO-kRlw>
    <xmx:ggXMaPyfz-9UNPjw4MTfZh2k7kwzHQF2IHlbqQH8wuFNANzoleY-xA>
    <xmx:ggXMaICP5uqRm6gPGSMpHGW8PXzZmSwLVbGztYAkXSxcjxhxDrjnJw>
    <xmx:hAXMaDehpAP39-4S3Q408oZS3Swdc4rSB0uIxx1VQvIAhJfZ8ILlFImQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 85F7270006B; Thu, 18 Sep 2025 09:13:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AneuvEk2E7Kg
Date: Thu, 18 Sep 2025 15:12:46 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
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
Message-Id: <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
In-Reply-To: <20250917125951.GA1390993@nvidia.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F36E3120008
X-Stat-Signature: ifxdops6f9r6m6jb5u6sagrzxftfky4h
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758201220-471279
X-HE-Meta: U2FsdGVkX19DPlQjZhsCmDaXZ90ITTEP8h5kU7wNUfWJMlQIn8UE+/kZUwtw7O92D4fuL+wXvdkJbCEjt6clG4xqqs40XwLqGG8JUmymfS2nG2NUnHOYcO9UqdRrIm2VyU3NPYIgjIut+wmdrjSNfrgIe4vQqDqJpdR/wdMn/XflHQTVGIRE1idT1UrZZAbjLrf5IphCzo+6OdiNyW5tM4xJDEXGGE5fGFRSSCs5+WrqNK8x1XHBpMN5mI5Y36qhGGzSEoCErAW8Y6c5yFrQrIdmNcYZz6+qXP2Kp19hIPxazE/liiZL8MdO45eQgCl1BNLX3aXYYFVSLvD2byrZZKW2UI9k/w2EVVa1lWG89Zkpi0hX/n1qAzg0gDu1x4tMLzX+HyOvNyJ2oTQmHN5PheT3tH6a6TSWzeiIb8XtIKZPJjytdF8OWTNTM7ZcKwLP+9dbLCZzaY8/HmGmkFviyS0xU0K/x3lKxbBsVjvdeX9bf48rR6wmh8K5GoyRC3aM7pgYxVOYJUasfq6+uuNzxI6BxQ91/7RA07Kti5Zcytccq+6gPJsi7n0153lLCIy0yWPIXyx95fbF0JKyPwWpW1FCWB4do1za614ReJQPqYXoUvQ8asygNTYhDwPYIpn1S49MOtROpVm79H9QFikWogMAe7BNohtgQpbdS0iGWDyGlqpKNyE3UQhXZl9vgipE3JzPsLpaxobcLm1A9+Au5uaNHpnQXkGUeTV76FlguIkuy9uh0B0LDG86NdGRdqZhrazA6hZ4FzG0+wsThlOILcLusV97uJRkVbkVtDXOugbzTpgF//LmiUDbdf9YGZoKo86U90nKlhV7anZ7vqfRz8WDrCMy3I4soa+B7lb1QOB1lcrKIhZ+Yw5VC46lFTQRQN7QIDit/6QAWacbyC++63bto2JS9xT9442+7OJjIJkTKPRmkmGTf+takHYnr6RcDBxskRaApHJV5+n3bCI
 VWFVvr2J
 OddeCiR2D8DZ6gxA4CliElRUKspgMcBbWhDOOVi3Is07g0tYMhkuK2YvFu7kI3/o6mptdI75PXHOLtqEE5M6hS1SeGhxgUZGi1iOpHUlAa1ULkLiPiFtQihLDtkktpJlPDIQzvPi4ZGcc+WN9XOgMlKC9pOwZwhm0q5UYcfT+E1HJmY7bb6xGQwvk4kUL/YsisqIFO6hlOFwdJAA6lcc1IxdP38VcyVkljhzGcn6XlHrAaVxGdwf8D7eYRMgm1NU1PiCbeOaiypVjqT2vMfIGh1Sww9FG51jUXe9UqHQfdm87DArYPfM9mxj7xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025, at 14:59, Jason Gunthorpe wrote:
> On Tue, Sep 09, 2025 at 11:23:37PM +0200, Arnd Bergmann wrote:
>
>> I'm still collecting information about which of the remaining highmem
>> users plan to keep updating their kernels and for what reason. 
>
> On this topic of removing some parts of highmem, can we say goodbye to
> kmap_high_get()? Only ARM uses it and only for
> !cache_is_vipt_nonaliasing() systems.

Good idea. I think we are almost there, just need to verify that
there is actually no impact for existing users. I already knew
that there is very little highmem usage on ARMv6 and earlier, but
I tried to recheck all platforms that might be affected:

* As you say (and contrary to what the code comments suggest),
  all ARMv7 and most ARMv6 systems have non-aliasing VIPT or
  PIPT caches, so kmap_high_get() does nothing, and we could
  just turn it off for those configurations.

* ARMv6 with aliasing VIPT caches exist but are fairly rare,
  and I think there are no ARMv6 machines left that actually
  use highmem. AST2500 is commonly used and has aliasing
  caches, but I only see machines with 512MB or less, and
  its aspeed_v5_defconfig enables CONFIG_SMP (for AST2600).
  OMAP2 and realview are in the same category but less
  important. imx3, s3c64xx and bcm2835 are non-aliasing
  (and don't have highmem either).

* VIVT caches are used on all ARMv5 and earlier, so removing
  kmap_high_get() would effectively break highmem these.
  Most ARMv5 use very small amounts of memory (<256M) in
  a single physical address range, so they are unaffected,
  we just have to go through the ones that are left.

* Intel IOP (armv5 xscale) certainly had highmem but was
  removed a while ago.

* Marvell mv78xx0 and kirkwood (armv5 pj1) were fairly
  powerful in 2008 and could support at least 1GB of RAM,
  but I only found one machine (OpenBlocks A7) that does
  this. It's unclear if anyone is still updating kernels
  on this machine, but they could /probably/ use
  VMSPLIT_3G_OPT if they do.

* Microchip SAM9x7 is the newest ARMv5 chip, clearly does
  get kernel updates, and the only one I can think of with
  DDR3 support, but seems to be limited to 256MB total memory.

* The Gemini (ARMv4) platform enabled highmem as part of
  commit c12d7e9fe9af ("ARM: defconfig: Update Gemini defconfig"),
  but I don't see why, as the machine cited there only has
  128MB of RAM in a contiguous chunk.

* A few ARMv4/v5 machines (omap1, davinci, ep93xx, clps71xx,
  sa1100, riscpc) used to select CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
  or SPARSEMEM, which would indicate that they might need
  highmem even for <1GB configurations if their memory banks are
  far apart in physical memory. I checked those and as far
  as I can tell, they are always within 768MB or less.

     Arnd

