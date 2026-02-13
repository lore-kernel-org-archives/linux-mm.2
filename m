Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C09CEDF17C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 16:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9993E6B0005; Fri, 13 Feb 2026 11:14:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971206B0088; Fri, 13 Feb 2026 11:14:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A8626B008A; Fri, 13 Feb 2026 11:14:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B5526B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 11:14:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46B9516049D
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:14:50 +0000 (UTC)
X-FDA: 84439931940.04.D1C8743
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 319381C0006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 16:14:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AU499Toi;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770999288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZFwpJkT77TkoxyNRZkgVKO9do/B8VZeBoF8eiGcyTY=;
	b=npKOM/Njfg/GJMTTu40OPnx72OCTzUUMEcB6y8THZEMM8H8CbVC+F8WkwPlbgSTwv+p7Hn
	+NB7kf2tjpL2FpxVkUFbLmcIp/fYSw7Ba0/BWv+ooZAgskF8tFe12AlX+4BdsfFxBBAWQA
	9coSgspA8uLxFJ9e1LbIREjVcUEX1MQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AU499Toi;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770999288; a=rsa-sha256;
	cv=none;
	b=19pNrlupDDoIER9H0UotvqZZ2/Q0fqSIYliC1zKwX/14LZsan6OuYO6WCEIcmmPZLXmMpy
	LUtDdxtNK3GpDag/ub0590Hdq6YD+J+/xWH1UKuiIJbIDr5/5898vMsh+YsurdCHDb4LMn
	9D+bUoePxYikSZRmm7rsvddIdWQ1awo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89CE44421A;
	Fri, 13 Feb 2026 16:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E81C19425;
	Fri, 13 Feb 2026 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770999286;
	bh=gJZ0H5g6MogpXiUv5VCMxrBmJWtE1/ypyfUmSRv+31M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AU499ToigZuK20hiWZbH7LCORa87aJXQCPe1/z1cQ4iwPfNPc9xs39+iHxiqIPpou
	 F32yb/TlE7gOpcotXGSzt6JIw/t4GtDmewPkiWPFdakP+sRnYX5tEw9xSmMbdVTK0N
	 WDpH0J7hsj5T7ejCY+tGMHwfM5AdVzVOWdgoGepEc9GYF6gEs0YMNPnlk2j6pD1QN/
	 /akVh7b/Y3TgiaaRo5ihIxL5vKsv1ds3u5FLUHnvQnCm+nUBEbrqOmU3hYBdvN/7Sb
	 r0LX1h1GNiSxU7olD7WhETRSpMdn19Nkign3YBE3Tzo7wIQIS2nlqAYOGlo1p43D8C
	 z0bVOkwxuTLog==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 01C01F40068;
	Fri, 13 Feb 2026 11:14:44 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Fri, 13 Feb 2026 11:14:45 -0500
X-ME-Sender: <xms:9E2PaTrENhaqbGlwHu-gUpK5LdGG6TBWH9Fs-AN_8zGb7w_-T8xc0g>
    <xme:9E2PaZG6XtqJC_AC4aaMILMBG1xV_-mzh0xAp9nAVO9TCZCGpNdAkZ0IGQqTGwMXv
    -RXFeLZE5To1r-OKNG2c7tHNW7eKex-ODTeX24b6vnWn5m8HKbTYLA>
X-ME-Received: <xmr:9E2Pae7bkCEUiVoaYkSHVgObc7qBJiyj9InIzlN1COFLvX1yImx5xknsTLXaww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvtdekjedtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvg
    hrnhepueeijeeiffekheeffffftdekleefleehhfefhfduheejhedvffeluedvudefgfek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepkhhirh
    hilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheeh
    qddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrd
    hnrghmvgdpnhgspghrtghpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhrtghpthhtoheprghrug
    gssehkvghrnhgvlhdrohhrghdprhgtphhtthhopehtghhlgieskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepmhhinhhgohesrhgvughhrghtrdgtohhmpdhrtghpthhtohepsghpse
    grlhhivghnkedruggvpdhrtghpthhtohepuggrvhgvrdhhrghnshgvnheslhhinhhugidr
    ihhnthgvlhdrtghomhdprhgtphhtthhopehthhhomhgrshdrlhgvnhgurggtkhihsegrmh
    gurdgtohhmpdhrtghpthhtohepgiekieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:9E2PaUCnT-wGATJhB9o97JOzceYK7wiKm_o_F4L0S2_tiSYpVnsFYQ>
    <xmx:9E2PaZQCeAXsXAH6HA8S9JXf4V6Rxaj6pm1yRK0_dOj9_GKjO3bV4w>
    <xmx:9E2PaUesNnJ8qKjA2_k5Y_Mcuq_xzzc_s7kSU43b9UMx8P-TY37Flg>
    <xmx:9E2PaSTVgSDOMpjnk3ZBfS0S5ER3GE538Y9er1clwcdzh4TiHPOZ-Q>
    <xmx:9E2PaQ0OZYszpOF6ZBWwYabHzAbCw0cUSzJyYrm8unRvaSqLdMLdpFc_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 13 Feb 2026 11:14:43 -0500 (EST)
Date: Fri, 13 Feb 2026 16:14:38 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org, 
	linux-efi@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Moritz Sanft <ms@edgeless.systems>
Subject: Re: [PATCH 1/2] efi: Fix reservation of unaccepted memory table
Message-ID: <aY9Mf8oZODGiDoXp@thinkstation>
References: <20260213154838.46567-1-kas@kernel.org>
 <20260213154838.46567-2-kas@kernel.org>
 <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3b073e4-d51e-4fd7-ad7c-7465dab412b6@intel.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: ezayjb3kin5hxpzkgrewdbpf6wb9cr1j
X-Rspam-User: 
X-Rspamd-Queue-Id: 319381C0006
X-HE-Tag: 1770999288-621396
X-HE-Meta: U2FsdGVkX1/1cP8TJRVYbnUWPTCYjaVbU5i2sIbcmK6E45AXFSudlyeFM7+vi5TPddUjJaqCgW8rOKBZ+E8HJ614EQQBu6APpQh0oGgup9W8LivWgzgLnbITZfOD0DVngkLBOQVcdgwnQ9pznv2hjjlZlYUeiPM7r28L3UYWDT34QHuAcQXBSirC1zlaB2kbaa0UffmMfp1rkOkWnp6d1PFCmaRrTwhQR2gulpH+HrUipnOsiMHTs3JgTwxTw7aCRifurrNnWY0ihB4gK6jesBfHyj9q+hFLVDiPBKgXif0S4yJqpVKjrA2K3D8deWISlv6SOBlBfz5e4TUsRz+sx8N7CpIQfnsyF7x0pq1sA9EsNOCRRk/Oedvl+TGSEBJn4ueuMBYFFtFtoMn7sLanMsCIcdNbUTYd0hTrYlXPSwnqimeILMuVyL/xlhSH4FZEVlqSyYeBHQBrxlslcI/3/qmauoCRTnyO26E0VnH0CuVQ1oPwBmvdD4djvR0DRtoXgRGlADJBQTCghpgje9NmVH9TMoh91FojvmsN3dRl+aK8QS/pLCsU6nKxyVTjKWivbqQ0pKWLUcoTZOCGZVltbUkvO1aQLOyywMSDlRo0jNmnIYegRs1Se2PCP5uueStEJSex4K7o0HH9ZI4llKYVd9uptELaxFVJqgqunWK2HrIY98vr1yFBgtUTV1tkFjdeVb6mXzIUeOfpXB/3kOPzPcOrPYuUvaO2llDAp9T3yzXzdrEZengmZ4D/LyGJtxVMt3eprIV1e3J41mtguIDgytClx9ftmx6glwNX3WWQh89BJlgcksNrpOO/3kAuNZYEO4l0bn85sf2sR5vvdFnnOFWiuLDf0dCWrIatxgv5t9DxdlM1pumprYtaJ90CwgyhfYpuCwhcYDcAr/S3atqh2+9g2MEhVAbS7h1NIbbwcELuY1GB+cjiRKcE+tPn+7CAa4nuY5RTByJhGg3Andx
 tkcbXc3R
 TTCwqFQy+bScbpFy2vGSUxPko5S1uEPgmutFCVLXCODorxGWIbmWt3cBQ42jTPE8xKuFdCHXJJsRvF8AmFFHjFqJRfaR+eZRUfSekc3oGpSqnIHYCcPmYYKpX+ybEyZ7HOCPSaBMLWOKIG/rd60dYwwrB1981uQAaJuM9hUxzIj/3ZJQTLf8GaNpF1W4OSIZaefXUn7PkdEScfggIBRpfavcCuutDMQu5ciziK1rUoLFB7Jkz7I/gHxGa1ogSPuBe0aNwgbMZ5JFjAiOOJpRvui4XQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 13, 2026 at 08:01:55AM -0800, Dave Hansen wrote:
> On 2/13/26 07:48, Kiryl Shutsemau (Meta) wrote:
> >  static __init void reserve_unaccepted(struct efi_unaccepted_memory *unaccepted)
> >  {
> > -	phys_addr_t start, size;
> > +	phys_addr_t start, end;
> >  
> >  	start = PAGE_ALIGN_DOWN(efi.unaccepted);
> 
> Why are we even aligning the start? Isn't *that* the bug?

How so? It is up to EFI how the table is allocated. We need to be sure
that this memory is mapped and not overwritten.

> The memblock code seems to be able to handle arbitrary alignment just fine.

Memblock will track it, but, as the comment says, anything smaller than
page size will not be mapped, but we need the table to be accessible by
kernel.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

