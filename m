Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 535BFCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9906A8E0011; Fri, 12 Sep 2025 06:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967EB8E000F; Fri, 12 Sep 2025 06:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856628E0011; Fri, 12 Sep 2025 06:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDC58E000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:31:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26811BB192
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:31:36 +0000 (UTC)
X-FDA: 83880231792.16.23B2844
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2800F14000F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:31:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=jT0WwhhK;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="k 1vyC6r";
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757673094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZnTz2gc51WJkMzlk/mlrEsU7FqUmmq3NOjbYK7bSYp4=;
	b=Sl/61TsrOp1STTpK/rD6PANlRoZdEX5QYX+m5IXcFPcZkozc7dkl+X3rzTI14IVTSQCEbm
	SMVvJb/ox7H/BQ2CJ9FyfrrEO5ZOe8H8Qnn7d4+EqVM3tFB0eXnKhMQ6pXYVEN4eYxEIDD
	jvjy7X4khroH1XB7r/LaPfwLHMuAL78=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm3 header.b=jT0WwhhK;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="k 1vyC6r";
	spf=pass (imf09.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757673094; a=rsa-sha256;
	cv=none;
	b=0h6VdmhfkcsDnCsTt5S+MewSnVluddotR8jBZFkQ2EF5gicnYSJ3B8RvggjsxLmQk1KcaE
	Wg12Sy9zKLZva6GPZhu7FjXJ/cNJBj1CVAPssg+SdEiP/sezbqTVlud01kES0bGM8oDkW1
	rGZ0+oSVvxyhzoy81BNWWWpe3f+XIJQ=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id AED0D1D003A5;
	Fri, 12 Sep 2025 06:31:32 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Fri, 12 Sep 2025 06:31:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1757673092;
	 x=1757759492; bh=ZnTz2gc51WJkMzlk/mlrEsU7FqUmmq3NOjbYK7bSYp4=; b=
	jT0WwhhKNltNjX6oy1wi2+oKiJaYylL7esPneJwhFB9N0maSA8KhckfKJ6NnZQXz
	bYSKUzEJ1WD8GBoOttQ4k4McWa7PUuOpoj8s0jC70raXwNw+Joio585FI3WnZjbl
	x3pSTwt/PxqKxJ9lJ31N1oKIcXKJBT4zXz+pCyvFVjV9Kraw9dayg9sb9jRwV+Nw
	ZCwIvDwoMDizk5Oy4w5Fq4PGMoCfY9L/WG+9W9or8bVbia9mvqlXoeo2P0NR+JgN
	5c355lhHhH91mQkZARqOAP1UqOJCYuCPS9yuex3K/8pU9ahBPN8OBiub5LCVDUWa
	qZJfE07pcyZBzcIZ+mGBAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1757673092; x=
	1757759492; bh=ZnTz2gc51WJkMzlk/mlrEsU7FqUmmq3NOjbYK7bSYp4=; b=k
	1vyC6rj2xmNIeSXoxg3bvnTWj9wX83aGkU2Em5DF79HTuHrMRkI/xWw7759LQ+5B
	bkcvjmV9Qcxb5zeuIlTgRw5J7nFj1ieCipA/jEvNGwd6HN40RiueQR16QHBzDb8h
	VtUVL9bF9ugklG9UPWPwK1OXzf1y5zcSOVT/aIDSE7/tpO+qIxlm036IloNQ38vX
	GYO835wCXejsuEjw7jRJxt+JFUijm5OA7IcHo9Ic5uxJrBm8P5nGWjGtURshGLI/
	Jm0wr8SJkFo/frJJBMF0lfIbNHl9FUpWia57G4LZzDDKNpmKp6M9YMb4iODMRpV9
	KmdcZMWP9FzP3F+KYOnRg==
X-ME-Sender: <xms:g_bDaJkb4BCSIXaN20hGGvDbpq_uYHUfXJVkDOB_mVGTfxamBLbrCg>
    <xme:g_bDaE1SOe8uQM2xOpAvalLtJNFp4-tFiBJJg00LzpboZKgRb_HiWpnQAMxIFtxov
    Y9ewlkME-ye5_zj9pk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvkeekudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpedvhfdvkeeuudevfffftefgvdevfedvleehvddvgeejvdefhedtgeegveehfeeljeen
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
X-ME-Proxy: <xmx:g_bDaFXJUTCPg8Gg2uXGQ5RgMU0uaHD5VVXSZgwboz-q7ftAYqBd_A>
    <xmx:g_bDaH89g0FuTDFfLJztpjIor2KN7O4LrVLiR6mLfjS9st6ed4KczQ>
    <xmx:g_bDaKpKyJokmXH4ARM6vTbfA_Kk9jW9MQRMrRlbx2LKjFb1x4w1Wg>
    <xmx:g_bDaLcx1abt47vng-9Brf4PakpSJA5ATOGTsoYy2HXs2gu4PoxW_w>
    <xmx:hPbDaDl4p91INzeg69byU-AorUJTlq5vFDDCdsqCRc1puYq7VFqbSjGD>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 9ED19700065; Fri, 12 Sep 2025 06:31:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AmcCJOTBQ5ho
Date: Fri, 12 Sep 2025 12:30:59 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Richard Weinberger" <richard@nod.at>, "Dave Hansen" <dave@sr71.net>
Cc: ksummit <ksummit@lists.linux.dev>,
 linux-kernel <linux-kernel@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
 linux-mips <linux-mips@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
 imx <imx@lists.linux.dev>,
 "Christophe Leroy" <christophe.leroy@csgroup.eu>,
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
Message-Id: <4fcd272f-81e3-4729-922b-588ad144e39b@app.fastmail.com>
In-Reply-To: <640041197.22387.1757536385810.JavaMail.zimbra@nod.at>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <497308537.21756.1757513073548.JavaMail.zimbra@nod.at>
 <dec53524-97ee-4e56-8795-c7549c295fac@sr71.net>
 <640041197.22387.1757536385810.JavaMail.zimbra@nod.at>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: jy3nen1zb48pk8rzjd8e1cbb6x858rqa
X-Rspam-User: 
X-Rspamd-Queue-Id: 2800F14000F
X-Rspamd-Server: rspam04
X-HE-Tag: 1757673094-868648
X-HE-Meta: U2FsdGVkX1/G0fFd20Djyw0Uaxk4VLxaJ6tGf504Z4l65BoElVRHv9Mq+AcOE1DBcMiAHAYNQ297fbCQKyC+IM9quKOMAxHiD53PQSSaYf8SqqC07Himrtoq+j+xxFagRT5fJOONhnzRFlP3RHBgcSwV6n02iAKV8nisJ2DhQ0IXXg3qhh7O3XXBxaIenurMb7drom8FKnfRZztDaOR92VwR3eUJJtk6l35WZ+DXiYfQfUy6o0vt9l4BHRe9H+HTENDtDeFqD+GmHZxLds5khs9g+YXjM/jD1zzH93CN8tSaDpqor3xMs4j1exC4ZVVwSRVXP0m5abTeCweor1aJ6BnjstwABYwPro1lvD50MS/EyMjTJ4mG464AZYN9RzlsvyxslxzB8ctNF2A9HKEFHnizr08uYzGBciiD/qyz21nTkLCcHx6jINucTlbDTJSmUL3lg1ROQAPhuWpn2yh64jr1QU4/FNLNRNZd67y7gtQb6ZbkbAuG5tciMhBPbWzvQKZwWLFOZz2z1SMA5htjmVAfRJ5jFM54BwtFx5WPfC2uKJoFaTUkiT5xMa84CJeKBNl8xEfAIR6pMm4MfvXI6JB12/ASKVOEq9zpI53xLqfca6erYpcGGtRItCTF8DE15sFC1MMIe/n+e+GMQHrEMsdZFje8H53C+jAGwc68FWmEJSyzkg9WnNORl56zJb05lUu6oXjSUzINQjA1uS9aheRUA9NNGd70ZQcwpnTI/3Nem7cYTo3s2og/sUIcJ2nQYMYTSvB9OmXGzDbXvo0xkCsD2PT3sdp7K3fdSk4IGp84zFKnJyZn3U/ZfBe4SlnzT3Aymq5VejQxJuqshlArc8vgzFyN6h0d325bu7c67suOaLA+1ySl4Bf+YZ/fA/tQ5rItgYPNW/AQIRZF+WRadv3h77z9hBKwhHKTxyoEwJEctOzXzPN3Bw+Y0wl0KgMLJK+SGfbG1HwVAfS41yS
 gCNYN3he
 u7WgUlOp22+zj2UU4j/e0Xj1VmU3zwaGjVySjF5flxh4N0wIIVT0U/i5fBbAAvbEb+qSBRJxa9kdHVpQnjXzopypNsAPW7uQ13764yiSLwrS96mE6BNPvcPG15KQ7mNcJRucjFAnZMBoQq5dPvbPovZFvMuq+QVa5e13hfx3rGz9BYiokcMUF3UOEPkkb+Qpux+TjfLLKrw0mJ2OCr9bGxP4FqfJLwSPIN+MJCCB7OEhxY43JkVbDrrp29ViTuimhlJwz0WF4asNLx3Mv4l9Bd4c8Mu8qAbB0Ri5OszjqAjafnC2FODh0xnqw/5/3N5Dqywmv+VeESEEQMgXMyHfXqtvwCipDWkur1HyrlKx5A9gNtA4iAmZVQ2296p2jjANlivbAXIqJJEoaiMIBSSAMKT0AyxByKjs394E/ZufByImO4iawvdRF1JTuK9Kk+b6PffF/7Aq/bE233Qk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025, at 22:33, Richard Weinberger wrote:
> ----- Urspr=C3=BCngliche Mail -----
>> Von: "Dave Hansen" <dave@sr71.net>
>>> Even with a new memory split, which could utilize most of the
>>> available memory, I expect there to be issues with various
>>> applications and FPGA device drivers.

I also remember driver problems on older Marvell NAS systems, which
we never fully figured out, my best guess in retrospect is that these
had devices with DMA address restrictions, and if lowmem is small
enough it would always work, but any lowmem allocation above the
hardware DMA address limit would cause data corruption.

A similar restriction exists on Raspberry Pi, which can run
both 32-bit and 64-bit kernels. The workaround in this case is
a combination of:

- correctly representing the DMA limits in the devicetree, using
  the 'dma-ranges' property.
- enabling SWIOTLB (which is not enabled by default on 32-bit
  Arm without LPAE).
- Using GFP_DMA or dma_alloc_noncoherent() allocations for
  streaming buffers if possible, to avoid extra bounces

(documenting this here, in case someone tries out VMSPLIT_2G
and runs into a similar bug on other hardware, I expect there
may be a few more of these, though most hardware should be fine)

>> I'd be really curious what the _actual_ issues would be with a
>> non-standard split. There are a lot of "maybe" problems and solutions
>> here, but it's hard to move forward without known practical problems =
to
>> tackle.
>>=20
>> Has anybody run into actual end user visible problems when using one =
of
>> weirdo PAGE_OFFSET configs?
>
> In the past I saw that programs such as the Java Runtime (JRE) ran into
> address space limitations due to a 2G/2G split on embedded systems.
> Reverting to a 3G/1G split fixed the problems.

Right, that makes sense, given the tricks they likely play on the
virtual address space. Are the 2GB devices you maintain using a JRE,
or was this on other embedded hardware? How common is Java still in
this type of workload?

Another type of software that I've seen mentioned struggling with
VMSPLIT_2G is web browsers, but I don't know if that is a similar
problem with a V8/spidermonkey JIT managing its own address space,
or more about general bloat exceeding 2GB of user addresses.

      Arnd

