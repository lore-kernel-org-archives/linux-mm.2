Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB419606A337
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lPgY3ZKm
Received: by kanga.kvack.org (Postfix)
	id CD3276B05B3; Mon, 16 Nov 2026 08:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C82476B05B4; Mon, 16 Nov 2026 08:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A846B05B5; Mon, 16 Nov 2026 08:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1A06B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:39:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3212BA0697
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:39:11 +0000 (UTC)
X-FDA: 85441088502.07.62F6957
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 78B0BC000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:39:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPgY3ZKm;
	spf=pass (imf10.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794836349;
	b=CxdBZXNv2itcHUUcn2/dZVFC/gy1Zh6PBU6Cb2KIkzYCkcWu0D1bS1FvoGVT2UUOe3776d
	tv3qAiCUGupBisoHKoUHbeR1kHTlxYWn9asCOyI/9JtbYJt2GBKsg8Ppb+3ACIdQOEifGl
	vIBUneHeH9w53UfR5aCmWUvGWsjStlM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPgY3ZKm;
	spf=pass (imf10.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794836349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v+u8WOi6enSXf9p1uj17AxTmnZ64Z9UB12nhM5b0wBk=;
	b=LurCS4YmsStlj1JtfSsGMmw2BvaKcdrNqvAMeiQoGR4WDeeBVqexPpiF4Px+lbIYxSm5Gh
	MHlHPplaSZmsmp4amUcvoqkmgZSLRgCEYVEqhxAWGGNWYwBGPMQ+KoQLTIErxSy0qkq1au
	U/L0WOEU1t9SBbZ0SS3Q6XXm7cXCUyQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE8A961D1F;
	Mon, 16 Nov 2026 13:39:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809881F000C9;
	Mon, 16 Nov 2026 13:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794836348;
	bh=v+u8WOi6enSXf9p1uj17AxTmnZ64Z9UB12nhM5b0wBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lPgY3ZKmD+AWK6OsqmvR2cCzK6j6u/WxfP3iaSyX9l+sr/3pxKSwrPdAxFUmB9xHS
	 Te4LG33kqlHxat/w0CkHdvZDbte0OMXN6muIL0x7x/arXg19Oq+TkrYgugukT86AIP
	 fBQDoHj+srBScbYERGJVtYGkySVWbQmNxiPyppwSnff8r1Gg1X48YTJ0M5spgri9sZ
	 cgtJFF25gMSdEn28dVFmDAaN0XSm5PAYY5CqRCitHfF55dnu7PV8zepEY0Q/zX8K79
	 MrjkPdaIuSw/y1vNQhJjd47gBkODFnoQwepsvQQyFNRel7sOC5ngZ+n7SoMLX7mQHl
	 QgBPPOdHcj0UQ==
Message-ID: <afebfaf5-f3ee-4234-875d-e5ebf1ee64fd@kernel.org>
Date: Mon, 16 Nov 2026 14:38:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/10] powerpc: kvm: allow flexible PAGE_OFFSET
To: Arnd Bergmann <arnd@kernel.org>, linux-mm@kvack.org
Cc: Arnd Bergmann <arnd@arndb.de>, Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Linus Walleij <linusw@kernel.org>,
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Lucas Stach <l.stach@pengutronix.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Malin Jonsson <malin.jonsson@est.tech>, Matthew Wilcox
 <willy@infradead.org>, Michael Ellerman <mpe@ellerman.id.au>,
 Michal Simek <monstr@monstr.eu>, Mike Rapoport <rppt@kernel.org>,
 Nicholas Piggin <npiggin@gmail.com>, Nishanth Menon <nm@ti.com>,
 Richard Weinberger <richard@nod.at>, Russell King <linux@armlinux.org.uk>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-5-arnd@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <20261116124832.662455-5-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hmm5irgpqxrey6cp84a63yipedfk1o6u
X-Rspamd-Queue-Id: 78B0BC000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794836349-783754
X-HE-Meta: U2FsdGVkX1/T59bWI4MLmMpTwSRvb+/AMqBu3kYA8QRYXgjbKYPlP2Fbik0RaU1o5Ve9vg3IRcYZB4FX1GOwHjMUQMEURuQEBxaJG5VTj2vi7kL0Sng7TVdczx736QBEEbHS0H2UxpMrWvfVVivnjP7bekbdlNVYyizvq6GJxpTP+vEYkgf1J/+Dj5tfJn/y+zXtsbGiLdsljq9oBnhpmuhvkjwRpfELKdHUW72sr6en2+6t9ySY9Fku8bKqDEUaySu/UqO0fUNjqwTJzLKrmkwXPetngzL8Ws2IKX/MIcUyMctfTrS9lhrSkT17JPncxLSCPcC5we6hhmKlUPCgplxr5UBFG2Im+h+e/HMtN1flDZup+lIq7dGUtae+PSaefZVaW4SLv2J/K1P/5MOH7SnFvqjbH3xYZyfqtvbJzHHoC3mTvdKs/6a72CxL+Epuw8VKxT3dFOtHha+5wJOg8LcgeUBH+Nbc7As2KdVcbsJeLANBxT51lzacrJZSduYng0mGyMLj1OsdLx6ITZpmvhBXfFUeemmu16AK0YAgOtlPRq+IuugJ9zuoGuJ2+syD8kexvc4+L02EWuAm2nVhm6QKbH0ig+rvW7Jyj4W38YbzCX8htwrm1T7ruRsNq4GeAXsL4SclcILk7BxDSV2XtiMFDchkOFaV/w6VmZFROJvTD472O8TbcTRIbGIeAZu7rwBURlXfca+kCawMUg7fEhLD7nY0OTv0MhPN+c22H9WpMc48juozNw9eeSEcw9qfS8FJkriuMIzWP3Qral5ZaU2ag2tdse/0vfgYzm/ZNl31BN1kpfwmMX17fc1RNSHP/H7IBYRDU7RR5+i1sI7aLofqIv6bqKD6hHA2SEeEsbj4zAfTt21S8Dx5Rkn5EgN9goraGi7EdOfaI88V7WkiZXYsll9oU/95HhyOY22gOgyBKjgyV4IxjgIXumX+UFMPMV/PRI+2trNw/Zpz7bJ
 y69sidgP
 yY5IXsv2LGVXAJZP+ESpIHWqhdfAeoHfhmf0wAc9hZysPQLMgtiEMlZWQHj1dYCNgvPPK8WwaYwoMmhzDr5xYvgQtBQ6hordzUO39bupHv0Uz0SaM8aW74OZgwze4fd7LiIaC4oIY3ND98w6UdatKDBl/Nmk0civB7pd4HNT1yCMBlykoLn0gFQ3eL94xtAWwlUwPmu5aB0hE1mSnpivdktJbAEsbhv+NTGtBFVfCV3NOxQLW/NzlaGHXvcE2tcH9HnonGkZgbQdp/4JDACBUKC7kknkrjAzEA2vqGs+cKHfVvGuBtWbaRva9kwc0WL6lNLj0sJsS8Qk8nis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Arnd,

Le 16/11/2026 à 13:48, Arnd Bergmann a écrit :
> From: Arnd Bergmann <arnd@arndb.de>
> 
> As described by the Sashiko bot, the KVM code on powerpc has multiple
> hardcoded PAGE_OFFSET values. In order to change the default, make these
> compute the correct register values from configuration symbols.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   arch/powerpc/kvm/book3s_32_sr.S     | 4 ++--
>   arch/powerpc/kvm/booke_interrupts.S | 4 ++--
>   arch/powerpc/kvm/e500_mmu_host.c    | 3 ++-
>   3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/powerpc/kvm/book3s_32_sr.S b/arch/powerpc/kvm/book3s_32_sr.S
> index 6cfcd20d4668..0d8a7857f2bd 100644
> --- a/arch/powerpc/kvm/book3s_32_sr.S
> +++ b/arch/powerpc/kvm/book3s_32_sr.S
> @@ -113,8 +113,8 @@
>   
>           li      r0, 4
>           mtctr   r0
> -	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * 0xc))
> -        lis     r4, 0xc000
> +	LOAD_REG_IMMEDIATE(r3, 0x20000000 | (0x111 * (PAGE_OFFSET >> 28)))
> +        lis     r4, (PAGE_OFFSET >> 16)

This is not enough I think. You need to load ctr with the number of 
segments you want to populate. Here above it is hardcoded to 4.

>   3:      mtsrin  r3, r4
>           addi    r3, r3, 0x111     /* increment VSID */
>           addis   r4, r4, 0x1000    /* address of next segment */
> diff --git a/arch/powerpc/kvm/booke_interrupts.S b/arch/powerpc/kvm/booke_interrupts.S
> index 205545d820a1..ede394f3f63f 100644
> --- a/arch/powerpc/kvm/booke_interrupts.S
> +++ b/arch/powerpc/kvm/booke_interrupts.S
> @@ -230,8 +230,8 @@ _GLOBAL(kvmppc_resume_host)
>   #endif
>   
>   	/* Restore host IVPR before re-enabling interrupts. We cheat and know
> -	 * that Linux IVPR is always 0xc0000000. */
> -	lis	r3, 0xc000
> +	 * that Linux IVPR is always PAGE_OFFSET. */
> +	lis	r3, PAGE_OFFSET >> 16

Maybe use PAGE_OFFSET@h instead of PAGE_OFFSET >> 16.

>   	mtspr	SPRN_IVPR, r3

That's probably valid but wouldn't it be more correct to use 
interrupt_base@h as in head_44x.S and head_85xx.S :

	lis	r4,interrupt_base@h	/* IVPR only uses the high 16-bits */
	mtspr	SPRN_IVPR,r4

>   
>   	/* Switch to kernel stack and jump to handler. */
> diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
> index fa6128119874..9edad9bed589 100644
> --- a/arch/powerpc/kvm/e500_mmu_host.c
> +++ b/arch/powerpc/kvm/e500_mmu_host.c
> @@ -115,7 +115,8 @@ static u32 get_host_mas0(unsigned long eaddr)
>   	mtspr(SPRN_MAS6, 0);
>   	mas4 = mfspr(SPRN_MAS4);
>   	mtspr(SPRN_MAS4, mas4 & ~MAS4_TLBSEL_MASK);
> -	asm volatile("tlbsx 0, %0" : : "b" (eaddr & ~CONFIG_PAGE_OFFSET));
> +	asm volatile("tlbsx 0, %0" :
> +		: "b" (eaddr & (rounddown_pow_of_two(PAGE_OFFSET)-1)));

I think this is not valid.

With PAGE_OFFSET equal to 0xc0000000,

Before:

eaddr & 0x3fffffff

Now:

eaddr & (0x80000000 - 1) = eaddr & 0x7fffffff

>   	mas0 = mfspr(SPRN_MAS0);
>   	mtspr(SPRN_MAS4, mas4);
>   	local_irq_restore(flags);

Christophe

