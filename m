Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E9FC606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SfPvoyK+
Received: by kanga.kvack.org (Postfix)
	id 689D66B05C0; Thu, 19 Nov 2026 06:07:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662C56B060C; Thu, 19 Nov 2026 06:07:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59F826B05ED; Thu, 19 Nov 2026 06:07:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 322236B060C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:07:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06D5980A5E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:07:40 +0000 (UTC)
X-FDA: 85451593080.24.ECFAD5C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 61F12C0004
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:07:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfPvoyK+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795086458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROUL/Vc/05NVBxBY34tWsXgeOJdPCC39DtodeyW5ZQg=;
	b=bQCeOJc5mYbmMvUvZR/5z9QE+HoaFx8ezUQGrZ74XjZ8oRKnsKe79mb1EvkV+dDqOXa08E
	GaND261LB67xZCcxJ6sFqFYdiWq2lc7X2qM6dV1hS75WR9UEtbM/Ya6Uz5a8uZ06C+cOP+
	nBfiAaMUABe59INx9PUo4A/9X42GA78=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SfPvoyK+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795086458;
	b=T7Izm8K6J8QkAZbPv/b52mO3kAtgn20UURqEE4IO5p/JODLujuXhDx6nIiKYInPECGNpVT
	Kd97Y3enZlV8uYQZUMjuVMzq+0sUrNzeG7RC+vu/xfJ2kx4dRUd3ew3aWmq0V3j6LL0YHg
	fGyiZ4CjgmbNVHn2HwZW5LmpJbi4CH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D94F962E21;
	Thu, 19 Nov 2026 11:07:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB51F000C4;
	Thu, 19 Nov 2026 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795086457;
	bh=ROUL/Vc/05NVBxBY34tWsXgeOJdPCC39DtodeyW5ZQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SfPvoyK+9KlmRpG703U6jl/NLnRdSEjycGz0XJ/6xbWJPMUIWmjVPJAGkRBrB8KaU
	 b/+gGVKmCIFIXoYZvOXm0ljG8iAQUdrW9zDMXb35+msUCr0JIBP0vVzWTcpm/rCpHt
	 L9tSUsDHSSuzeYEaLENZnN8gFbzOysB/MbJHrztkIlY8/c0xJQf1DA9/AnUqBiKEXz
	 X9jJYLcJuma7wp1N5DaWfiZ/0SJx6xotaGh4We2okitxksgBlQQ4CHWeYm51YBPaUp
	 oc9NtOvq8BoktlekVvP80SK6F2UzvgHzskz381t8TFJsG60HPJsaS6ePYwuo/jbBlr
	 8fOQg3IuNNb0g==
Date: Thu, 19 Nov 2026 13:07:32 +0200
From: Mike Rapoport <rppt@kernel.org>
To: George Guo <dongtai.guo@linux.dev>
Cc: chenhuacai@kernel.org, kernel@xen0n.name, liukexin@kylinos.cn,
	guodongtai@kylinos.cn, loongarch@lists.linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] LoongArch: Allow memblock arrays to resize
Message-ID: <av7YdBobrANyYgqg@kernel.org>
References: <20261119100216.10182-1-dongtai.guo@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119100216.10182-1-dongtai.guo@linux.dev>
X-Stat-Signature: wjz4tdmsa9gaco8hq4abse6sctts4w1c
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61F12C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795086458-970615
X-HE-Meta: U2FsdGVkX1/dOCvya9f1dpcoON7RZW0T6y25UI7qPCJNkbWH8jA7b4+Gbgs9LuI1cEu/1x5dSMzBxiMyXJNVe8M5BpPKAic5Ird4XhUR2AxjJagIQQ6VOyynZkSFIt+JR+On1XiRmFkVDITOnpZWs/0U2BvuxukBVmuOL4yIJrvAI58pHnkh9ZBtbI7dTx7FsiarJoMkBbu3kWoCZ66gbuE9HuYdnMrveLVT54qoIryo4Nyfzl1rxDQduIFsviBhkcFokB0im2bTBiDpAQBMdHb4pWcOABFgLIroKmID/OTHo5iCu5Bz8cE8g/epYYl2ffmIqVO+7jdvFMDpiiMEzGLhM4OQx63iptCrnb22KrWzTf6mpmyCZxJ6O5V9iFINHroaZvtOW2apER5w/WH+fNdxIrWGQ0a/sRwpD9CoeZhoB8hHHMJpX+eF4UC+B1J7BVPMW+LEPlvoj+vrRrWjZsWRB6Gq1ZaoNrphvQETJE5qPzh7Pk1hdQ2XYEWhmnh2rIooz7kLc0yACEI/NrCfI0VPVVqWmEePMCT0FAyqi+Ut+GNz6FyQ1M96gV804AMNlpwS5Mu8FD8yu7Em9Dy7krZSSX1BPnkgy5gJzZAbC2SEhc6T2GSbdrZyWvvpBbvXDsY+nLlTJZ4ArqxVM3Opi+8x0Oi8zN2tBs7+UyHYKFGXrbJ6PuWKtDiz+2/w4S8E8Fv/K1KfDjKD2tV8xBqAcO8W8MarjLaN+I3jf2sHYrP4QjM6BjM1xMHs1RHTcjRADZLhIS71yjx0r6OwWu6aKuN7RQNRQeoK+EOjEorZ+zHfrsxMwQ0h6Yin38h/A3B7zDlfbMNf/xsyeuS/JbpGoMYFCTDmwf1C+msUHT7RcJxJgc/ZMKw+Va5y9cy3BW+VSBrnVDT+//4AjRtqbgEwpbp5KXpmnvltJLPG8qe/NT2r0Fljhsus1iWHcwYDJoR60i9thwg1Gqe8+z6YNbB
 72OZSjig
 Zr3LrgKXdEJihpeWIBUaSIOKSUMesfsPc6MUCHoQslYUmejfTArEVBVzt+Tzo+r741P01B6A3w+BGCA4KRxyxJjl8W9heASOiQqdVU4D/neSusESkm0uv1GGX+Ox378ABXVlo0i7udGYSGkz0S69b1jx+Z/Y8QdxforzDrE1CuYL9u5H00CNKQxi1mI9bhPSsAQKVG9uW6Hz98+VCdlu0X1eJjJk2LX+bC729gC6ChSVjXKMeA2QIekflMPB9umaRj1Nq2K6ZjBUyrdpxT5vcu+eyiZM16XgptVcVcVMwLMBaR0qH2tZizawLvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 07:02:16PM +0900, George Guo wrote:
> From: George Guo <guodongtai@kylinos.cn>
> 
> LoongArch never calls memblock_allow_resize(), so the memblock region
> arrays cannot grow beyond their static sizes. For the reserved array
> that is INIT_MEMBLOCK_RESERVED_REGIONS (INIT_MEMBLOCK_REGIONS +
> NR_CPUS) entries. Once it is full, the next reservation that needs a
> new region panics:
> 
>   Kernel panic - not syncing: memblock: cannot resize reserved array
> 
> The memory setup code was derived from MIPS, which never enables
> resizing either. Nothing on LoongArch needs the arrays to stay static.
> 
> When an array is full, memblock allocates a bigger one from free
> memory, so resizing is only safe once all memory in use is reserved.
> By the time setup_arch() calls arch_mem_init(), the kernel image, the
> initrd, the firmware memory map, the device tree reserved-memory
> regions and the crash kernel are reserved, so enable resizing there.
> 
> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
> Signed-off-by: George Guo <guodongtai@kylinos.cn>
> ---
> This was patch 5/8 of the LoongArch KHO series v6 [1]. Mike suggested
> fixing it independently of KHO, and Huacai preferred arch_mem_init()
> to platform_init() [1].
> 
> KHO for LoongArch needs this: after kexec, kho_memory_init() reserves
> every preserved range, and luo_stress_files with 500 files overflows
> the reserved array without CONFIG_SMP. A bigger array cannot land on
> preserved memory, because KHO limits memblock allocations to its
> bootmem areas by then.
> 
> Changes since v6 5/8:
> - Sent on its own, without the KHO series.
> - Reworded the commit message and the comment so they do not depend
>   on KHO.
> 
> [1] https://lore.kernel.org/all/20261029172956.20791-6-dongtai.guo@linux.dev/
> 
>  arch/loongarch/kernel/setup.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/loongarch/kernel/setup.c b/arch/loongarch/kernel/setup.c
> index 6fa4a22a58fd..8c33346a123a 100644
> --- a/arch/loongarch/kernel/setup.c
> +++ b/arch/loongarch/kernel/setup.c
> @@ -402,6 +402,9 @@ static void __init arch_mem_init(char **cmdline_p)
>  
>  	check_kernel_sections_mem();
>  
> +	/* All memory in use is reserved now, so memblock can grow its arrays. */
> +	memblock_allow_resize();
> +
>  	memblock_set_bottom_up(true);

The placement seems about right to me :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
  
>  	swiotlb_init(true, SWIOTLB_VERBOSE);
> 
> base-commit: 422e532809572ba1043192bf6a0c653bc68b3140
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

