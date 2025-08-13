Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E76C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 11:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C8F90005B; Wed, 13 Aug 2025 07:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A542E900044; Wed, 13 Aug 2025 07:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96A3F90005B; Wed, 13 Aug 2025 07:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 874F6900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 07:05:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47B19117099
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:05:58 +0000 (UTC)
X-FDA: 83771454396.28.F846659
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 18B64140014
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:05:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVTzChft;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755083156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hM+Slp2YEWSOnKVLukwoyPz7xqtb3tc2PHy5G90+KBA=;
	b=BJ8NQfK6vuC/4XHWPElM8hNOYDaS+tfe80kuM1pE7TeOEaaDzpXZC2iqoa1KjYOFIN/B1d
	FxlDvpCpMgs3I/bj53RnoutITYDgAi4viKyTqzQKKW14F7PionKwwnsoepC1yzEboWAqKB
	FRdgYi3KmXfinTDGu8x3T5GQ4X2Vq68=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755083156; a=rsa-sha256;
	cv=none;
	b=uSMgP+FezakCoxnTY/MJznV4weqGydSBkEWmQo2Ka/fk36myUSSb1KtFPEdzN7UK649NZ0
	YqiihiTmH4dM8gkvF0xB4C74Ik15FvVC0C+MSSFHdGgcgFeswijWi4BBQ62ywPJLVyDkxx
	yy7xKBd0Dxu7Wsfeu5O+naYUIRPVWnQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MVTzChft;
	spf=pass (imf09.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 981B445C45;
	Wed, 13 Aug 2025 11:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6582C4AF09;
	Wed, 13 Aug 2025 11:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755083154;
	bh=Eeai9dFb+kti/XBjctJ0qi3uDnJFrbSx2nI6I5JGe/E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MVTzChftScPnIhxRPn8iBvhpswPvTTD7XJdoJRL5fBd4cGnDY147IceWpItrWMjXd
	 UH4TRrFVaIvcvApQdJngb8q5PoXFbziVSqaagOsRUiw0xsgoPMLu1LShmIkMccyVk/
	 TBdPXJ0X12q2Xb8tshmKCRA2Bys7mXSmWvZ7jPOn10Vpbr1N9VigSHX2ecwEfGWOyy
	 swLaZU2Mx5hOTCUDwCMZoDQLuGSxpCIuC1EFGbpyoU/7ZPcFeqzvMWKyKLa01LjW1I
	 ACpzsBVtl7eri031qavtb2t/ANcXzqI2q8UUJK6nmuprtAoI0+ELc1GFr83rzgP00s
	 sgGTupaRgOd3g==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id C67FBF40066;
	Wed, 13 Aug 2025 07:05:50 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Wed, 13 Aug 2025 07:05:50 -0400
X-ME-Sender: <xms:jnGcaIn1p1K9MU1fRyGWzjV0QaDIUTi1zfT2zv7WE8pQiJPkWaIniw>
    <xme:jnGcaDirxVSukN94gQyZs3OTr1Hv2zcp7-fY0tX4suwMW5O1Tc05PrOfPH8osxTk-
    DZ_Z53N-m5mWnXpi4M>
X-ME-Received: <xmr:jnGcaGiopsJBn_DNCn5MLY1IKyfdRiKLiB--lqw0M91wsxo3D_kQT-Rhkv4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufeektdegucetufdoteggodetrf
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
X-ME-Proxy: <xmx:jnGcaBXUyqFUPMfew4Z5OWLnQYxm0ELK4l60pGN0JZUamPnkFvEXsg>
    <xmx:jnGcaJyWZOPfBrlyFhEBMM7Izc5tbQBmTrmwEKpAcSs1ax97Lv_30g>
    <xmx:jnGcaCZ1SA6oP89KZrD-pcDTmqZEteJLkTO4D3FxGwNjGKkQTMcQ7w>
    <xmx:jnGcaPdCHDN46QC0c0e8jPbv5rGJ_dGyrlROhniLqDa5XRLH8zB5wA>
    <xmx:jnGcaK8yJwFwK7u2RhqfCBJLM8kFptKWxfpX2bimCMLEY2zof4O9jhyL>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Aug 2025 07:05:49 -0400 (EDT)
Date: Wed, 13 Aug 2025 12:05:47 +0100
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
Message-ID: <ebl5meuoksen5yzpzbc5lcafcgzy3esfq7c47puz4tefeskkos@f5wzzg4fjrfz>
References: <cover.1755004923.git.maciej.wieczor-retman@intel.com>
 <mt3agowg6ghwhvcjqfgqgua3m3al566ewmvwvqkkenxfkbslhq@eun5r3quvcqq>
 <rzlimi2nh4balb2zdf7cb75adoh2fb33vfpsirdtrteauhcdjm@jtzfh4zjuwgl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rzlimi2nh4balb2zdf7cb75adoh2fb33vfpsirdtrteauhcdjm@jtzfh4zjuwgl>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 18B64140014
X-Stat-Signature: 13y7w6yeeaja5tue1yoxkdftb4zz13aw
X-HE-Tag: 1755083155-755829
X-HE-Meta: U2FsdGVkX1835trNEKPAM4E6NngGgQCz/ELKElENpIR76nS5PaVhbgdM3tTjhfT3xQxeQ3Brc7c1uKQ9xH4JfYSVqy/8x7Us869KMRbqFQKjzUuQNuKGFYscnTKSDUt49c9buDisE9KnTSm0CJfKo5+nRfM5W9zEqg/mD6eKHJ+UnIt6mWNGCIbbOKOF6/iQPq4wowA32a/Z+ROD1Fonf5EFhm+NbLFjpB+HKXuVaLuxwilFWVvWHoZcX+OEZq5pb8GMuR/Fk+TEpG/VsdCFoueQ+aqplaohA1Gjf7VPuQTk5Hm3g4YuB6GAY2wcOk9QekGeaIF8NAYABgXo5iGyY3en9doFcHlKloD98JXMoAXqEjaH4trNe/QbrZJZQ0A9ZgvQ9oKzkhknvfg8t1nuNIQFSyGM5ZKmxm636pYPAEJoMNu20IpqXA9c/0TfQI2llzXmsD1Ezp5H0kjNQdqwF/4v1tHGtMgdW+OkQ8655Jyycfth1NdYDtHBn73KGA3ExnJOzl9hMjbaH5SjZgmSveP7qWWA2CQgRPER0u1kdWUMOpiQtQy/6w/wOdyqR91aLhAENKulg/dFXwxHRQy3058Xy+uaQ0zWDMLPegfeKbAKlGrHZyEM54f0P32k6J/576eMFxDYKFCxJiqjTd6kxAWW28q8I2FTEbnKHEeliLlzZre/Itk2SJDbiX8REO+lrD2kZB9AjBk7qZ0Zp4nuVatab2pnGv/xUEPuoGhhSDQeTAvCDXnpKDBxkV4+0Tg2UT33iKM8poR0GuhXANsDnSH6ufO2+SFuRKS4ctN09m8MmVD+M5jTHggrhVtgAV22VPNwNahySqbUNwZRNy4Ye/2d75AjbfUMCXiNYPb1dXZeTxsNIPIUarBguKIbyo2tnmVV95o3AyhklyI2ritGwvyW0x2hXBmfQbMHmsUNJ++nb1Irfd6mO1hcG9dmmepcBt5RhbCEZWHHHon/nMH
 VHbeoYFD
 MY+KafjNrYjOSDQxy/ZY0v1CoIdJgeN9pbyzmcb7ovwP/ehiIAb8CLVC9IbrtYhvNgMk0p6haw5npiTuUrgqu6fPoqyEKf9QeU/dmnOW1WYjQ5RNH/CLIoXgz13H3wz/QoJ5ABYqsToh0fSBOvvF4VLJQCwhg3Q/6PJ8H4/j3yx5FVivcI7FsRyx+d6tf1rvU0sEaXJvaON69WkGXejGj6GpYdAJWVS4nfpusoBuVo9ox9p3BmMA8ZXneuLSQleQFXX7rFIZFKWyWJcLiiDPqIV38wE8uMCK84YsSAjbVEhtQ+1d4Cr766l5RODOBnt6c3/WUwikpao91reEwbcIYRnefBvhtrpwKmnhC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:39:35PM +0200, Maciej Wieczor-Retman wrote:
> On 2025-08-13 at 09:16:29 +0100, Kiryl Shutsemau wrote:
> >On Tue, Aug 12, 2025 at 03:23:36PM +0200, Maciej Wieczor-Retman wrote:
> >> Compilation time comparison (10 cores):
> >> * 7:27 for clean kernel
> >> * 8:21/7:44 for generic KASAN (inline/outline)
> >> * 8:20/7:41 for tag-based KASAN (inline/outline)
> >
> >It is not clear if it is compilation time of a kernel with different
> >config options or compilation time of the same kernel running on machine
> >with different kernels (KASAN-off/KASAN-generic/KASAN-tagged).
> 
> It's the first one, I'll reword this accordingly.
> 
> When you said a while ago this would be a good thing to measure, did you mean
> the first or the second thing? I thought you meant the first one but now I have
> doubts.

I meant the second. We want to know how slow is it to run a workload
under kernel with KASAN enabled.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

