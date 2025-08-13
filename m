Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82407C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 08:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA4E900048; Wed, 13 Aug 2025 04:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA81900044; Wed, 13 Aug 2025 04:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A0D900048; Wed, 13 Aug 2025 04:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA0CE900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:16:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9160C82839
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:16:39 +0000 (UTC)
X-FDA: 83771027718.20.308DF07
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf10.hostedemail.com (Postfix) with ESMTP id BD1B2C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 08:16:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hkfryBge;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755072997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+u0wmRt6PJvGdFQtCZAI1oS3UKAenlpPK7AYmnU7pY=;
	b=JS67oK29ogHXlpzbvRyxXq8crbA1bwn8dJ90KeYurpPL58p+huXdZe8vjpbELQSnngImTw
	s/eevPJgiqN+aZtJ5GW4nS3aX8gEBCtXtvE2DZxUvpAaDuFSAXuDO03uuS8LCyNtJMmy5J
	oCIFfzxynnRS11BWX5FAisoCnY2f+Dc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hkfryBge;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755072997; a=rsa-sha256;
	cv=none;
	b=nqwQhv9QCFdRz2TmqnhOdGVG1fabs9J3h9bfXGfnmgi70Ww1fZfdEEn9Eb5wN9VM3udrkm
	jtgwqioQTqSoJXMw0S80LFGIeaNXxP9/1McJKmQ4NmiGDu8y5tDSrQ42fNHyBOCf3gFBlT
	XelAWWiLO4lcDhOEeVnfsg0l60W48Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 7BB725C1089;
	Wed, 13 Aug 2025 08:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAC9C4CEEB;
	Wed, 13 Aug 2025 08:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755072996;
	bh=HpmLvrPHn4sb+82i2lRKMP37vraziwdZWtrOQHjkRDc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hkfryBgeEEtiAWYIAQM4oQy2XQ9Z4BPn9Ge0qwzZB/gVcEWi6hUMZeyimxqR5eK1X
	 zMTyToZyJ8ClSiddiN5ACV823OpY68O96TkrI5PN5MYUWtCwhQn6KIAOstUth1wm9m
	 3U2Mvc1WWQkvIgF/2qfazdGDQdQ459nPKGN5DpWERkKNxbTdgQW/QTJ/mvQBq0c4mf
	 GMSeWyMjI6HSS0qu23qk5qvFLTe1Jp6m5Nw7wsouTSbfNL/1A43XbaY6YJwXZCORd2
	 oeQb3oNnUfp2IIoNUQgtKUI3/dx1R5sBbikq9o7AM439nJSrLoPFoy0dCuDTlpT24v
	 ZiA/xS2wWCHFw==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id B8421F40067;
	Wed, 13 Aug 2025 04:16:32 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 13 Aug 2025 04:16:32 -0400
X-ME-Sender: <xms:4EmcaJ9bYlqpENhWu9ZM3b1rkWpwlG0ejAGfN5hl5gpmWDsXJZb2dg>
    <xme:4EmcaENOzt1tVLSLCMXrultW8L17ql7E4FM4HK4IpxV0IwbEtdp1obf0VUusmmMyw
    IcwitAMdbROBw4JosY>
X-ME-Received: <xmr:4EmcaFQ0k6CLoJc_wiBIEX78Ie8QrsLWwJlSGdc_NpJQrnqaDtOjJI6MFkkG>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufeejjeduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepheeikeeuveduheevtddvffekhfeufefhvedtudehheektdfhtdehjeevleeuffeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepudejvddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepmhgrtghivghjrdifihgvtgiiohhrqdhrvghtmhgrnhesihhnthgvlhdrtghomh
    dprhgtphhtthhopehnrghthhgrnheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghr
    nhgusegrrhhnuggsrdguvgdprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhr
    tghpthhtohepuhhrvgiikhhisehgmhgrihhlrdgtohhmpdhrtghpthhtohepfihilhhlse
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehkrghlvghshhhsihhnghhhsehgohhoghhl
    vgdrtghomhdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:4EmcaG8rQsE8nkO8Pw7BXFUXXd-RiXJNyqApIZXatEwUdlY2ztWfjA>
    <xmx:4EmcaP1k2sWKIPsVnixXMBMnZq2BC4N6nxNUox2x8df5vJ19bCsHAA>
    <xmx:4EmcaIKL7gUAWTyNuo8HT5jw93fJosAdbDIZuVFUt4IZ5EQd4puIQA>
    <xmx:4EmcaN73ABzTnA_tXNVpp2lcwvZwZx0hbVCFteVB1zox2VpbNSuCPA>
    <xmx:4EmcaEjpfrJQy1TacPbbA7uC_HvJWGEvLn3o1pPc_tSJJSAJSSn_V_gA>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Aug 2025 04:16:31 -0400 (EDT)
Date: Wed, 13 Aug 2025 09:16:29 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: nathan@kernel.org, arnd@arndb.de, broonie@kernel.org,
 	Liam.Howlett@oracle.com, urezki@gmail.com, will@kernel.org,
 kaleshsingh@google.com, 	rppt@kernel.org, leitao@debian.org,
 coxu@redhat.com, surenb@google.com, 	akpm@linux-foundation.org,
 luto@kernel.org, jpoimboe@kernel.org, changyuanl@google.com,
 	hpa@zytor.com, dvyukov@google.com, corbet@lwn.net,
 vincenzo.frascino@arm.com, 	smostafa@google.com,
 nick.desaulniers+lkml@gmail.com, morbo@google.com, 	andreyknvl@gmail.com,
 alexander.shishkin@linux.intel.com, thiago.bauermann@linaro.org,
 	catalin.marinas@arm.com, ryabinin.a.a@gmail.com, jan.kiszka@siemens.com,
 jbohac@suse.cz, 	dan.j.williams@intel.com, joel.granados@kernel.org,
 baohua@kernel.org, 	kevin.brodsky@arm.com, nicolas.schier@linux.dev,
 pcc@google.com, 	andriy.shevchenko@linux.intel.com, wei.liu@kernel.org,
 bp@alien8.de, ada.coupriediaz@arm.com, 	xin@zytor.com,
 pankaj.gupta@amd.com, vbabka@suse.cz, glider@google.com,
 	jgross@suse.com, kees@kernel.org, jhubbard@nvidia.com,
 joey.gouly@arm.com, 	ardb@kernel.org, thuth@redhat.com,
 pasha.tatashin@soleen.com, 	kristina.martsenko@arm.com,
 bigeasy@linutronix.de, lorenzo.stoakes@oracle.com,
 	jason.andryuk@amd.com, david@redhat.com, graf@amazon.com,
 wangkefeng.wang@huawei.com, 	ziy@nvidia.com, mark.rutland@arm.com,
 dave.hansen@linux.intel.com, 	samuel.holland@sifive.com,
 kbingham@kernel.org, trintaeoitogc@gmail.com,
 	scott@os.amperecomputing.com, justinstitt@google.com,
 kuan-ying.lee@canonical.com, 	maz@kernel.org, tglx@linutronix.de,
 samitolvanen@google.com, mhocko@suse.com,
 	nunodasneves@linux.microsoft.com, brgerst@gmail.com,
 willy@infradead.org, ubizjak@gmail.com, 	peterz@infradead.org,
 mingo@redhat.com, sohil.mehta@intel.com, linux-mm@kvack.org,
 	linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 x86@kernel.org, 	llvm@lists.linux.dev, kasan-dev@googlegroups.com,
 linux-doc@vger.kernel.org, 	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/18] kasan: x86: arm64: KASAN tag-based mode for x86
Message-ID: <mt3agowg6ghwhvcjqfgqgua3m3al566ewmvwvqkkenxfkbslhq@eun5r3quvcqq>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BD1B2C0002
X-Rspamd-Server: rspam06
X-Stat-Signature: 3qyxggmgo1prmmdyjhsfkfy9erohwkq1
X-HE-Tag: 1755072997-346492
X-HE-Meta: U2FsdGVkX19hW2ADSfkpBrnSDFJbyzzo4bzVzRROguKXMHQh2EsMLDMhZ6GR/Ml0WtKpx+30HMMO2l3CmLw6vSklDSsa3YEK9/En8vNNXM2myjX5HMc5Ir/o5MfmJiN3plum9NJYg89MBBDQQyPm3iGGyCoCuXkjVO7zMXzyh7zV4lB5Cjl7bf3XWvU6YnGXqiEg0EQed11av1nDQhU94Q0lpMro4bIvEUlxNfsyJGrTXB3avlow1QzLXZo2flSiOXDTOMCfALrdcGcM40wnPnWbZf32xuwm8rXXlkIGZpLuKppWBSNe3xUSlu8BymAPg/Us1wd7Ssl1CinO/PPN+F2RNhKR+NVefSHe5Eb5X4iN+a66K1SwF964vHZrTVA98C7Whrvmgo5Lrl/PPWcPY7GsHL7ME3NGoEsLYcV2bP5md4usG66TaazX0zO9Qq74U5O8UvJPndIYDgvbog+11vqR0bf4fP3q9b6IMQGWEtgTq8pB7U0sE25qbuMZbafRL59iAoVerSYpDrb0fcQb0r2HNaybzC9MIr72vTl1S8zUiwERXoUin2wL76Nis2UDs1vjxt/DwYTDlxfSUvLXCZ6BnianL5ZWyjqQGMP29jYwgdapjHLPfRi0K6pogjnHUx7xKg/o9PtVUKvDzt3He5prQJa4vufrOkOuZZnii5La9mcf0r7doO4vZszkhdpE+hEbgrCpI03gvfYEv9jolyEAV2V0YFZ7YHzsvFGIdtI28v4KeoL5sSeBhjjtTZt8dKasBEhx/5W0kCkszMPfXIXOuAWV8t0rtpjBVFzwCpZYgGEvvejj1zDG150XdjSTEpIrxKUDpW28VFJ0vwEJ+wW3ujmO9Zn3NRJ3eYvGkvud6zZvwoeig80fmHEBqbCLldmsGfZn5zD4hKGg+3eEp/logMyVlklfYPzBpMapKnr0bKC3+Pi5mHFLoAI0pYjRsTzlfhHfsrq5orZ1Gko
 DHtbQ5/F
 UjtKoTteMz/XocdwuYjYbkvYzQ4crWCanxK4o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 03:23:36PM +0200, Maciej Wieczor-Retman wrote:
> Compilation time comparison (10 cores):
> * 7:27 for clean kernel
> * 8:21/7:44 for generic KASAN (inline/outline)
> * 8:20/7:41 for tag-based KASAN (inline/outline)

It is not clear if it is compilation time of a kernel with different
config options or compilation time of the same kernel running on machine
with different kernels (KASAN-off/KASAN-generic/KASAN-tagged).

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

