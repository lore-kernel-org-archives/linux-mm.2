Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C03ACAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 06:59:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6716D8E0005; Mon, 22 Sep 2025 02:59:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6499B8E0001; Mon, 22 Sep 2025 02:59:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F0F8E0005; Mon, 22 Sep 2025 02:59:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 429A08E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:59:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CCC951A026B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:59:32 +0000 (UTC)
X-FDA: 83915985384.22.173C9EC
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf26.hostedemail.com (Postfix) with ESMTP id D94A414000C
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:59:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="l/zsR0G5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q zwoyyB";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758524370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tw7JZ6uQ+dSxRm1cR3ykcHwmxGgsza4QaeIC4IgS1AM=;
	b=cy/UcrpC9tn4W2f/QJCu7GeFNgOE6oQVPa4KzjkyRaXzzTW+BCc6ls0L/uK5lBpMCf6hpL
	DUO+VDrvvHojPtTm7zCZVNrbqlIjtges0NCOdXKJt7uEM/5MhtvJ3BhfC7R+/9IzYqG4R1
	Kd1SNWcj5HkzRK7hdm8ejYCjb7Ts6to=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758524370; a=rsa-sha256;
	cv=none;
	b=Vv8fkCFleKWOX9WhSrj3F2501hRx7cfDI9VpVpr3/oDgi1EbEgFxQM/kWRk0tkCC9c895J
	jAuIaqr4dpT4ZyXaDhxLuQU3v00uYo4QvX4qTULzNCPu6ErMGydbYZ361Deg7AakyIBERf
	LEjCJKp7LO5oCkzB1Qgr1DzLW8o80CQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b="l/zsR0G5";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="Q zwoyyB";
	spf=pass (imf26.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 535241D0018C;
	Mon, 22 Sep 2025 02:59:29 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-05.internal (MEProxy); Mon, 22 Sep 2025 02:59:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1758524369;
	 x=1758610769; bh=tw7JZ6uQ+dSxRm1cR3ykcHwmxGgsza4QaeIC4IgS1AM=; b=
	l/zsR0G5eT2gz2q4CXpfCwEpXLiXIWeuSMMOfqTnOtjbPdFXKq1o5OVaHjeuQvok
	O/W1x65coIcNpApW8qDJuJ4wKYWnuGNwyn7j6woJVBtie9xTAb11d6HngQbvPBKf
	HkCNYVpWqebU7GhZ9Qey2zLtrgNjUWrVxAmBONRPhSMCY64Yky9DXR9XDsvA3+XZ
	ZbbjO4HokYqsR0tDqaso05RrMm8/wXDNhWRhP1S8JSdqgGPk660msIOs8xolJTTe
	2E/lysfyyJ9YlxYZ8Aor/xg7B2nhZhTFHzG0yoqk3Jvxl/t/B3hFBhIboNtcexas
	F/U17mzbpFvEthrXVADCEg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1758524369; x=
	1758610769; bh=tw7JZ6uQ+dSxRm1cR3ykcHwmxGgsza4QaeIC4IgS1AM=; b=Q
	zwoyyBXTJ/xlyTuAl6eaDR08Yk7cKQ/BYb5Q+OZLHccYXOTq0s/D4PTdaj96/BWY
	ggJn+VsyjX4BR1Hr2f98K40hOZatGzQ2cuJfCPnbWUbSoltfyoQfrYcbTyI5AP3z
	cdO1sLjEizaP++pe3JWdqMUu8E/hcLc6Ezoa3b1J8l3zBl/LcuFy2NWUviuBLo+j
	hEda/Sd5M2ZGiE+v/q3X7Sq/5MeU9PWw3eI+9cHwC3G6RvYy60ZxsD8o6B1XVsHD
	/+UIoZdinlSwV09zE0r1PRQKkYVnb6LlKZJUsMPxXN8tUA+c46acCx0AdynNnU3F
	AWgKAlnztXyZ2gLYJNgsQ==
X-ME-Sender: <xms:z_PQaHJgzXYKoYDzZ-ssaOLFznF26Q_ZnAG6-dRyqJQJmlL_yyLZLQ>
    <xme:z_PQaLKYJie8lkusfN2_LRJLymKL9CiEKO2L9JMaW6nU_INMf_a-KAqcU9AVkuY7H
    Dtm7lvTZTS76OqV9zI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdehjedulecutefuodetggdotefrod
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
X-ME-Proxy: <xmx:z_PQaO-AbAyrchLt1gPFzz5ImqtdsCE4MtwCgozi9Nvp6tIrZcpE2Q>
    <xmx:z_PQaOrgvuN6qNmRYjHfGwBTMsdEkP_7cBTz8lKVYq6AnPpCxT48tA>
    <xmx:z_PQaPkdEcrkiW2nIGq5bH_Mu4Fdt4bCb8JYLLnUSHz6JcSrKkzR9Q>
    <xmx:z_PQaLbNi1YcKXD1-mIpvlgsrc7fhhvtK_CV_WIUToIeUNXLq5ldZg>
    <xmx:0fPQaCrlRiKZ3grcKLdDxNAcmQRYM5wxeUnR0jLm2DG7jGDKd4pLMQoQ>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 79F2D700065; Mon, 22 Sep 2025 02:59:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AneuvEk2E7Kg
Date: Mon, 22 Sep 2025 08:58:57 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: "Geert Uytterhoeven" <geert@linux-m68k.org>, ksummit@lists.linux.dev,
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
 "Andreas Larsson" <andreas@gaisler.com>,
 "Nicolas Schichan" <nschichan@freebox.fr>
Message-Id: <44f910bf-ac2c-4b2f-8e50-5cfc7dd0761a@app.fastmail.com>
In-Reply-To: <20250919143436.GC2132010@nvidia.com>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
 <20250917125951.GA1390993@nvidia.com>
 <02b0f383-1c43-4eeb-a76f-830c2970b833@app.fastmail.com>
 <CAMuHMdVecUeLZ2LPpa457C0a=uduvDhQ4KZJx-++dEFJraRi3w@mail.gmail.com>
 <547dcb81-434d-4910-aa7c-1d69019fcb3d@app.fastmail.com>
 <20250919143436.GC2132010@nvidia.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D94A414000C
X-Stat-Signature: ssyjz9mkypgd7y354diwszp16jwxxa19
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758524370-290541
X-HE-Meta: U2FsdGVkX195MGnxXXxATKQzUx5enkkG7xw1pZ13gSoIcTPea0uw7E6h6K5F+52JrYGbEE9Ps9A9nLHqsJIXc8PIyMRQQAZUxUyrQ+lGfiaTFynk6H6ltA7+6GrprVeIIlAvwoNQt/xAAGstktvqU9Imep4E8246rx0s2emsDb0jaec4l8Z455oq1T+owDmWjUvPhjI7KjS1YLhZ9mKHuu7XSGNu2d5+pRq53F+1DJsEU1yp6N7UBkjEN1nH5mfO69YgroEJ+BZZjUIgu1Mdxku4sljPZqXrRLEyD7KEP6DZgvVGQBMkOkT1jzh88ZinsI8G+KOJHAxF5g6bClaUqOhQKTGJck9kNNIdiwFCvKPFJLi7sKDW5ZpliW4UH2rijK3s5w6mMUgY1ZykXUbAU/NUHqOp3aX8ks+G8XrSGnHwfI5JK6P2TtZdXxp5VQC87EstUtHDG6F7B9U8n9Pqxbu1jZRvF12OHGokQVo6RE+Wa4PgLJLlQLNZjcFW/95LQkZ8V36mpQKu58YStuvxhUjjcstIEOI4RLeuUqWf+wBxjdnvdq1kGN+WV2o2wBf66ukP3ISKZsrXK8Qta/h2CXiPcpq4mVRy1QzdhYNei6tTr+wqL3GqgLR0V0oCJWtD0153iUzvKF508Z7kyRO/yyFkcPFLMczhyztzUah/SM1IGpMvNdM+6+FqqqcRKy5iFVJwziKUtMXsbRmAfM/CNO8hJR3dMeU8YymCyo733EY4/lMwL4YkLxY+rn0n0cY2M9h0OCKyW9c46OPHFOPQ0AnNIoNshWEf2OxbDI8UdguWSqNu8GXx9wpANo73wN/gEcQiuxOwf0CXLY4du+Pj1f7b6ENSc97gofcgQMoxsZS02nN7he96JiF6aO+D/zjaHzzq22huW19BXtfeBw419AEj7yVOKsuk4vEo8UH1VzwazK3Ddt7nkX9v1vuJd5cGD+g/uhvLp6WoUODYUiU
 dU3BY1hg
 zN/zhz6Xa1FM5p61Di/VrDN8JBe5brLiZD5PijuQGsOI0BlzM6DSMCAkJDy8bvlGqxuXjotwWPvZa+PdPdf7PCQIJjz0QjELxi2FqJ3eGMVgS8WHL7NT3gOruKkR9kLwEtrOgeoUwIyYWOjvH2pqoNoZH2ykIUihwKoJWeGRwW5G3xEU3zN7NCWjmwNSYaccXDvHjl6nn17g3L711yxjmrsCQim1HDjEJ+V5ng7n+KgbsBG99pGlnYmb0c1X67d2nQ9MsPZwuQiqgx1fuZ1VefGc5cJHl8O1DlAgyBSryY0rQ+sFx8Fjkm7mdo6s4PyRIL/JqfxcrPQrOhHWspMfpxCFeiEqlR6PcYXBC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 19, 2025, at 16:34, Jason Gunthorpe wrote:
> On Fri, Sep 19, 2025 at 04:22:20PM +0200, Arnd Bergmann wrote:
>
>> SAM9X7 in 2023 added DDR3 mode with up to 256MB according to
>> the datasheet, no idea why they chose not to support more,
>
> Quite possible the internal SOC wiring only has 28 address lines. :)
>
> I am right it sounds like we can drop vivt cache support with highmem?
> vivt is alot easier to understand if kmap isn't running around
> creating virtual addresses aliases!

I think so, yes. I've prototyped a patch for it to add a dependency
on !VIVT and the drop the code paths that are clearly no longer
needed without it. This obviously needs proper testing, but the
diffstat is promising:

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index f14bac913d50..0a31cfaf3818 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1214,6 +1214,7 @@ config ARCH_SPARSEMEM_ENABLE
 config HIGHMEM
        bool "High Memory Support"
        depends on MMU
+       depends on !CPU_CACHE_VIVT
        select KMAP_LOCAL
        select KMAP_LOCAL_NON_LINEAR_PTE_ARRAY
        help
 arch/arm/Kconfig                    |  1 +
 arch/arm/configs/gemini_defconfig   |  1 -
 arch/arm/configs/multi_v5_defconfig |  1 -
 arch/arm/configs/mvebu_v5_defconfig |  1 -
 arch/arm/include/asm/highmem.h      | 56 +-----------------------
 arch/arm/mm/cache-feroceon-l2.c     | 31 +------------
 arch/arm/mm/cache-xsc3l2.c          | 47 +++-----------------
 arch/arm/mm/dma-mapping.c           | 14 ++----
 arch/arm/mm/flush.c                 | 19 ++------
 mm/highmem.c                        | 86 +++++--------------------------------
 10 files changed, 27 insertions(+), 230 deletions(-)

I did get an email from Nicolas Schichan (added to Cc here),
and he is still supporting a widely deployed Kirkwood based
platform that uses 1GB RAM configurations. He should get
a chance to test that with CONFIG_VMSPLIT_3G_OPT, but I
would expect that to continue working, possibly with minor
bugfixes.

For the timeline, the coming merge window is for an LTS
release, so if we remove VIVT highmem support in 6.19,
any remaining users we missed at least still be able to
use 6.18 for a couple of years and get security updates.

      Arnd

