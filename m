Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47E14606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mykMNeh5
Received: by kanga.kvack.org (Postfix)
	id 6DDEB6B05B0; Thu, 12 Nov 2026 07:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B60C6B05B1; Thu, 12 Nov 2026 07:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F3636B05B9; Thu, 12 Nov 2026 07:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E51FF6B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:00:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 09DE912057C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:00:26 +0000 (UTC)
X-FDA: 85426324452.24.E41177A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D81FC000F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:00:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mykMNeh5;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794484824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wTN3UxTT/XXw7NH/F07ZSE1+SznsV7bVJZdXlw3Sm0E=;
	b=5O+XW2RcQkp0irLfIHPki84ucMEZWRiafIlput8lEWnJiJrzfMc2gKXjbgLC89TdzX6eba
	9COjo/MqjvHN9uXV3d3kpfUEcCYtKqSnNPmOwoeuLlAEAJbye14gEy8WpJhWyeujDYu/Ub
	bEyiQGmDxkhoeeIG5pcefAEyACeCrq8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794484824;
	b=AibzNPp0CEEatdQwCOpSg0eJzlPc2+LH3BvtrEZxep0YXsQkk1WoNUQs3ACqf+AiJUJdIZ
	Obp7MPm4jrOHi9YzgizA/gxVqOOMUhDIPvCout84pyLU+uGo7j/V/3nFPux34jy/sChCit
	TXTvR19u5AAyx12CPt4XLwx9Av4b49Q=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mykMNeh5;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E06B163950;
	Thu, 12 Nov 2026 12:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869391F00A05;
	Thu, 12 Nov 2026 12:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794484823;
	bh=wTN3UxTT/XXw7NH/F07ZSE1+SznsV7bVJZdXlw3Sm0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mykMNeh5BtXxUerEKT1YuKhyGYJ7QWD8IG5KpF4NuP4taMISSoglro4vnkkgm5jw7
	 WQS/4vwRcKImTEfxhMYZ5wbg4cf0zsqSfNSCuEwHpTxLLpdEiTkzuh28KNZeLAVJNg
	 ZfCkbQmePV1CQjWwx2EMjuLDIhpJighraQGEfBeHC2UHTK/MwHz7f2oBCj4SrVNuE8
	 h5IIE+hXfIdS625oF8CuXci5blOoZ0531mmkrv2ibJ2+zxzA7PXsQSYWh5mHmJWrB0
	 v/bWt32FVQ52/8TNJggbPdO6bVuM9pAUdH6G57AlDfNOf/PKeeT3jQZcm5rv//GblC
	 jWyGILzZ6HoIw==
Date: Thu, 12 Nov 2026 14:00:11 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Malin Jonsson <malin.jonsson@est.tech>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michal Simek <monstr@monstr.eu>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nishanth Menon <nm@ti.com>,
	Lucas Stach <l.stach@pengutronix.de>
Subject: Re: [PATCH v2 5/6] arch/*: increase lowmem size to avoid highmem use
Message-ID: <avWqSw2YrUmfAX62@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-6-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-6-arnd@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1ww39q5o3ba8htgc7mtym3hqxk6d5raz
X-Rspamd-Queue-Id: 6D81FC000F
X-Rspam-User: 
X-HE-Tag: 1794484824-874486
X-HE-Meta: U2FsdGVkX19D24k4bqy83BTaAvPVYIhaOTqTjnrkSAcLy2LGWBOJ19ZkjOKQG4NT5YOKyUVXtwgL5cKaTEBRSs+gyZ5mr09V7Ai0xIvvxnovN8RIOEIn+5QbCtXRa6ZkHKKvzeHoaniSfUcbj+cCI1leZ2bBs48R3bCe68lnReK+52wF9/co+oOwF1/6xCXqUmuBICUau2Hmyje5dM/Te2exDeW4Hv2Nx+M8s4yc96/ago0FPtEb6qQUubLZslpJOkUcrxaW3oKAad7Ph43MBtPhRWEl9f4B9K5oPNIRQ2EJTzRwyJJC+61YCCYW/fmManP9nIYHl344vAAW37Sxl8uMVgbPyK2w6EPfJd3jEipQflLJOnWY56HDru9Xl4g2iXzBRrAsAy55txRSIf2TIWs62S8BspK3WWvjsAt7sDoDAA2UH0bfBHTkp1tshSMfc6j5r26LbEeC+SseN88LPk+HTpcbjEeJW5BsfeB9Q9ugUbltuuB4tvfJV07rw5mA3rUf0+ThTsOD/fzeBB2ONrl/esctxklw4PH8lN9t0q4d58QrNK8JxNxVzRuuqPz6w9Z5GejOuDBR8xLFTnPStCYLAkbGlphXh/gfF8nhoJ/AD7kbpAD7f4U4WdgRj0n7gAhUldhnPrPpCP9GhiJkhhFrzvz28mhPFU0ax/rZk5OJzVsb28/o1/Z3iz2hWlzmkPv8+4RwLGsc33pLf4eBT9dfunpmsMBwTP9beUI4cW02cUAQVZa3PE/6XQqCZLR35Tifyo4bNZGOn3gsxli+ITj6qwFtRz6DmsTOHcunNqxlOBR54ckIqGKtOdQfv380Kut5QpVQ1hyWJwt/beW6oqd4WH1+3rrx2IXS44v0z8I24vQTybGcWXDpSEDlC1AFStEfUZY6Zx3fcB80OIOmSvPa0yzIkqAlnAPvGBHlTkgA/gfd89S7mhcSUnvRqujhFyHX/dreUZhQBsur/nk
 pDO4dgiD
 44f0mp7yO9esuiEUmvoFxxTiSN/elfNF3mephYalJ5QX4WC2LoXdpI8I0h9/ySuujviMqXkxD6TwDQ6VfUHzYaamlmCxtYtFUsuGiuXjXmeyjD3KRKfEV+GNIwM/TWy+KUa7rF7Jyl7Mojp2V2mZ65fHsMcpA+6puWn9XT2saulXRycILUPXP+QB6CQoJEM2/alBa8TGIjahBj6+Mj4jg58tUed76pnrc7ZcOoYvB+tmWZ8ZbAItRaCBjNNx9LmEDvUcCKYO6TUbNjT51hbwP3MKgDgyzSkcEWhr0DnSiEYCz+0o5f6jJIPeNx20AHjNWEhjAwVNG6EjlymWmR7NppBlKyQ066i+rKFLQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:27PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Most of the common 32-bit architectures (x86, arm, powerpc) all use the
> default virtual memory layout that was already in place for i386 systems
> in the 1990s, using exactly 3GiB of user TASK_SIZE, with the upper 1GiB
> of addresses split between (at most 896MiB) lowmem and vmalloc.

...

> Based on the above observations and the discussion at the kernel summit,
> change the defaults to the most appropriate values: use 1GiB of lowmem on
> non-highmem configurations, and either 2GiB or 1.75GiB of lowmem on highmem
> builds, depending on what is available on the architecture.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  arch/arm/Kconfig                            |  5 ++++-
>  arch/arm/configs/aspeed_g5_defconfig        |  1 -
>  arch/arm/configs/u8500_defconfig            |  1 -
>  arch/arm/configs/vt8500_v6_v7_defconfig     |  2 --
>  arch/arm/mach-omap2/Kconfig                 |  1 -
>  arch/microblaze/Kconfig                     |  9 ++++++---
>  arch/microblaze/configs/mmu_defconfig       |  1 -
>  arch/powerpc/Kconfig                        | 14 +++++++++-----
>  arch/powerpc/configs/44x/akebono_defconfig  |  1 -
>  arch/powerpc/configs/85xx/ksi8560_defconfig |  1 -
>  arch/powerpc/configs/85xx/stx_gp3_defconfig |  1 -
>  arch/x86/Kconfig                            |  4 +++-
>  12 files changed, 22 insertions(+), 19 deletions(-)

-- 
Sincerely yours,
Mike.

