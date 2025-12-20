Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2667CD78797
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 12:18:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9BE6B0088; Sat, 20 Dec 2025 07:18:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D0D6B0089; Sat, 20 Dec 2025 07:18:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61A96B008A; Sat, 20 Dec 2025 07:18:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C332C6B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:18:45 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44E9A8B283
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:18:45 +0000 (UTC)
X-FDA: 84239753010.05.9469949
Received: from fout-a8-smtp.messagingengine.com (fout-a8-smtp.messagingengine.com [103.168.172.151])
	by imf18.hostedemail.com (Postfix) with ESMTP id 20FFD1C0012
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 12:18:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=ZMNUJHqa;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="q ZCZMqR";
	spf=pass (imf18.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766233123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0+iYPCNdQLGxjMdcbwA/gTR2x+sGNDsrapagDJOjyk=;
	b=JIFCqmktF+f4rjKcfp8AnE1H4f+27EPm6i3vbKrbxpnx8OsZNP2E0wbJVM4IZPjC+YO6TA
	Ec2d7/veyVmLjn+l1P91IlauQar8nSa2SDf+6LHd0HL91sZy34AfTMVnHgjlmLQvb9lT8i
	/pPGZ2pje3hQZ2fqnDkObq7Lq2XwaKE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=ZMNUJHqa;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="q ZCZMqR";
	spf=pass (imf18.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.151 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766233123; a=rsa-sha256;
	cv=none;
	b=JKlA98ueWkQDWhZI3Ot6x6b7gYWzt9XnBjSJ9IjwqbME1t2d1rH+3P8u7xg1vtRUMGGYTm
	VXH3D67wACsCtHzJcT3RWJ/AD2aHR/W1IBSquxXgu6BmvtS4JaQVS4tA8rubvk36pcF+G7
	55antf8wsTba+qzLYgC5aIcfXzapCcU=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 38167EC00C6;
	Sat, 20 Dec 2025 07:18:42 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Sat, 20 Dec 2025 07:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1766233122;
	 x=1766319522; bh=J0+iYPCNdQLGxjMdcbwA/gTR2x+sGNDsrapagDJOjyk=; b=
	ZMNUJHqaIlhxOZxNF5kSN9cyqEffKO1N6c+BEpBlv8VjXQMbHQE7yoALKJ0HjI/b
	XvGAc6Nr/uXvXo9lym6t/FhNbTT8hJ0mSSBz+fmaESsNJJOl7jlu7LgAT+0sDIu3
	9Ki9V/JcUOfgAwGFROotsToxiJrzZ2HbHUg/qvUaZIsoyJuKUij2LQthPHxIVZHT
	8dPzn3VcdepxgSOgThr/jM4iCzdR6eBphXPpTptuUXHjKJRJy4wlZja4j/aSTymk
	QtqFEZPslcpgA2KOsgjQagojGoMci4HnQdqU53UAPoZV6TEruD3xNxW9FNgzp4rX
	rCThjZ3LfEUaBUqtpw6mWQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766233122; x=
	1766319522; bh=J0+iYPCNdQLGxjMdcbwA/gTR2x+sGNDsrapagDJOjyk=; b=q
	ZCZMqRFfdIVy+pv6ds6PnALhXDnC0sRLUaAmzj3s4eVEqx67+Ol363oA9MOttWV2
	j6hXQPA/CRtlNilvr4HTv16wkfHYlGm9V6j7lI69yUJ3XWv2O6KxcLjZB0OGGlW7
	9Pb6sKpvPbvw3pOLBVtxWWn+Gos1HAh5Vj93mri1hme7FUkzJuZiJJ0PCEni5MfC
	6qQ40JesdRdWISaTK2J+CavcrMWFx0ijMPey4PXY9Owlvp6KchmrR39qmMPIz3Ra
	164FxKRCIRTCLjUZGZtgfcqqiEVjq0sisy6FgxS0o+vS4efs1uxSgU2KGk1LftxX
	zoQDQ7mzZgTT8pMwzmq3Q==
X-ME-Sender: <xms:H5RGaeWggCPW-3VtQo0jpC7-99pN-EJCk2wblScdGz1-ni6zzovHpQ>
    <xme:H5RGaVYT_XLO9OmSwEzEJsXvW2S4qWUO59PT1vBDEEtjuR17lQ2yRdmUOnh16NRBk
    N4b2YhYcXMwf3mfadzQdQvw6TUuKClb1exusXGWb9um0WliqAYI0RC9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdehudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeeffedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtoheplhhinhhugiesrg
    hrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdr
    ihgurdgruhdprhgtphhtthhopegrnhgurhgvrghssehgrghishhlvghrrdgtohhmpdhrtg
    hpthhtohepnhhpihhgghhinhesghhmrghilhdrtghomhdprhgtphhtthhopehsuhhrvghn
    sgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhr
    tghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:H5RGaQN7rv5zp-HFb4nG5aaO04M6xP8R7qsDCEyc91z_HfiEw9u7pw>
    <xmx:H5RGabPeugWqp3_PtYsF-HqGb-Qi4TuBmur4HsG9oKOJ7JXp_YbzCw>
    <xmx:H5RGaUNckeV1xAQTE2DLNCcunDp1dlhBcx2IoeXkPzkj3nzshhpIWw>
    <xmx:H5RGaXb7G2ORik0ZKe9tiOzWwycV_3Ybzkw_-C8JbPSkIm3ilKdNHg>
    <xmx:IpRGaSEvRduNosmd8e790xMBHZoVrcyCL5X-_b1o6s4G1yFIMK_FSZ54>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id C2004C40054; Sat, 20 Dec 2025 07:18:39 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AhgucsMdbVXw
Date: Sat, 20 Dec 2025 13:17:14 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Dave Hansen" <dave.hansen@intel.com>, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>, "Michal Simek" <monstr@monstr.eu>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Nishanth Menon" <nm@ti.com>,
 "Lucas Stach" <l.stach@pengutronix.de>
Message-Id: <25642e76-43d6-4b17-94a9-e7dc53512223@app.fastmail.com>
In-Reply-To: <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
 <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
 <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com>
 <a2ce2849-e572-404c-9713-9283a43c09fe@intel.com>
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 20FFD1C0012
X-Stat-Signature: gf7tmoqw4uoumkwe5y35bmbk8bxex6cq
X-HE-Tag: 1766233122-391009
X-HE-Meta: U2FsdGVkX1+j5aVduGuRRh/UItcXlY5DMixneXTidMJ36vzUUxyqucLJxazC9CRkGtRQXp+XhJYtmf0+9yjAadlMsM1dLMHJ35DhXOnx15vr6snDrh748hpV4wTRFpAQSUZ78rjVf8FM0COZQ26EAjXyBXHMulbN4vk/XDVpZOmfTr8rG06f/962PZGYL4KFq87EktFHs7MYv0Lrg5wz+ui82HdB0u+fQgJOcLRWBmReyQBYAzFYEiwQ5dgO6tqy9ci/OhpJDbzgkUXNUuukFDKLc8GU+yi5Cit8iKIjJmSSG+wC9eW417dpVupCbw0hkfPA7q3c2OFkQc5HJj8JcgqaRW5voYuIFMw7USciGE1NtgxtM02hPPY7i6Qi2GhZSU6TtVg0k4GUCuRDjqTICGOLr28oeAktfoXXAjK01nMxN8xmi/t45uSJ/M0xR5Uh370zrrGqAQZydvcQSJhBaKAU3cLnzJQ7RE5EM4cS8wFhwdMtFWeJ6bXjlzxDfuG9JJu1D1sAqplxMRnYjk1xaHLlhhbnmEL5jaxFjWLLX93mJ4E1CrbNraRW0EXyjprJtIR+7uJ0r1YuR0yT91X1x73HSkqzhLstAoxbxrtBEIC5PEfSRq+vuq8uISTplakVAUpskRZL4HJfk8br0C5iHScCzLNKWsDoBRzcHgkcGZX25ZnyWJbgKRX7gfBKPS5gPmBBdtGNSbpguzQ8KL63tf/xgz2c1NopIGWdU9j46QvuyDPLgiBdaWzPFjPclPmoxhSjJqnB6JHjIwJbUqvO0GsKzG930bGIgkRWoaB/6/QCQ9LLIuJC+Y+IETTAIghQVE5f8mp2bjHx3lg9QzLqrScuzykHBI+7adepCTqrxkpOCU74mnw78aVFmk3OZrBj1CKqlLEVH8vzGeYqJgrvvoNdadywZOeHi1BpX9U90LBRVtXrDZI8LMCDLUsSuxy5Ty1t1Avu2U4MeHpG3Wc
 KOl2hrym
 CuOn6W2vtpqKdrD15/NersS5bsgccsG8zCqjpUaAm2EuNVNBIbcmfgRyHGxJTTAiDyp7B0LAZjPcbE07ZJ1YvCTg1H+sXoyzsnTNn2aTfj9XY2WbR+DPkQJ4jA0eIbd+XQ1qt2EOPpL1RwbRSjIQYJES0TwPxsPTTzmUvt+1RK265ZVyn455HOpHO7bIVociqYHc3MkbipsIO1apDoX6kpcJQy3vsEBOGHjGv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025, at 21:52, Dave Hansen wrote:
> On 12/19/25 12:20, Arnd Bergmann wrote:
>>> But, in the end, I don't this this matters all that much. If you think
>>> having x86 be consistent with ARM, for example, is more important and
>>> ARM really wants this complexity, I can live with it.
>> Yes, I think we do want the default of VMSPLIT_3G_OPT for
>> configs that have neither highmem nor lpae, otherwise the most
>> common embedded configs go from 3072 MiB to 1792 MiB of virtual
>> addressing, and that is much more likely to cause regressions
>> than the 2816 MiB default.
>
> The only thing we'd "regress" would be someone who is repeatedly
> starting from scratch with a defconfig and expecting defconfig to be the
> same all the time. I honestly think that's highly unlikely.

The entire vmsplit selection is guarded by a CONFIG_EXPERT conditional,
so I would expect it to change both for embedded distros that store
a project specific defconfig and for individual users that have a full
.config. If someone sets CONFIG_EXPERT, they do indeed keep any
previous defaults, but I'm also less worried about them.

In the Arm version, the 'choice' statement itself does not depend
on CONFIG_EXPERT, but I've added 'depends on !HIGHMEM || EXPERT'
in VMSPLIT_3G and VMSPLIT_3G_OPT for a similar effect.

> If folks are upgrading and _actually_ exposed to regressions, they've
> got an existing config and won't be hit by these defaults at *all*. They
> won't actually regress.
>
> In other words, I think we can be a lot more aggressive about defaults
> than with the feature set we support. I'd much rather add complexity in
> here for solving a real problem, like if we have armies of 32-bit x86
> users constantly starting new projects from scratch and using defconfigs.
>
> I'd _really_ like to keep the defaults as simple as possible.

I'm fine with 

	default VMSPLIT_2G_OPT if !X86_LPAE
	default VMSPLIT_2G

and dropping the VMSPLIT_3G_OPT default for non-highmem x86
builds if you think that's better. I still think we need the
special case for X86_LPAE/NX users to get to the point of having
VMSPLIT_2G_OPT as the default across architectures for current
HIGHMEM users that have exactly 2GB.

I honestly don't know enough about x86-32 users to have
a good idea who should be optimizing for. The embedded systems
(vortex86 and geode) seem to mostly have 512MB or less and no
PAE, so it probably works either way. As with similar
Arm configurations, these seemed like the highest priority
to me.

I see there are a few rare vortex86dx3 boards and the
upcoming vortex86ex3 that can have 2GB and would be using
HIGHMEM=y but PAE=n today, and these really want the 2G_OPT
split by default, not VMSPLIT_2G.

Hobbyists running on vintage PC systems instead may have
intentionally seeked out the few machines that actually support
2GB or 3.5GB of RAM on late Pentium-M or early Atom CPUs,
though most of the historic machines between the i486 and
the last 32-bit desktops would likely have much less.

    Arnd

