Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF4B8C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:39:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56DA6B0249; Tue,  1 Sep 2026 10:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E386B024A; Tue,  1 Sep 2026 10:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6D436B024B; Tue,  1 Sep 2026 10:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB96E6B0249
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:39:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 47CFBA045F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:39:41 +0000 (UTC)
X-FDA: 85165452162.07.5640623
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7422240003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:39:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UaaDtqHc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGPRzkwM3s4uAqmW6A+0BM2kjJ4fklHUcyodXSytQxo=;
	b=ywOAbgZNivqx9t/QvPDYntydndHHO6jw1uHnwhy50+pOVU1Da9S7OzRTiHK3GWdqsPfi6m
	kNok08HgTCB5zbBsaF2vnLujce3Gu0JwoUMmMrkF4jSK/Rp1IQCodgwWODL1MMk3FNfkXH
	JpdiSiUrc2/anF03CGLYIJ5Tp8Rhp1s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UaaDtqHc;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273579;
	b=oZHhcEx5WfZoWKSqX8Wm726lROhRkDygi/6MZfjRo7spPE6pN4wvRfgqYMo7OTP4ofFk1L
	IVpBHKrNf9CducRC5FIvXFn1Gug7c81EnZNpj2jVWtP7W/udyyjWK8agUKb3DBHmXHZjdU
	PVhOvscemuT5qZxCBL/av7Cazmueits=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 96AD21756;
	Tue,  1 Sep 2026 07:39:34 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 98E993F882;
	Tue,  1 Sep 2026 07:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788273578; bh=KmiAFVuFMCiQ3kijocFjf2AEfhNaMl006eWKr1VxZWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UaaDtqHcIV5ry2ml0i7WogPk4YgXZq6+Vz7uOn4AHpoOLjAHrS3Gt0mi0drzIiTGw
	 QJ2c3z9zO9IlLLoALRJ0uXpCEpw+yPtuAEkE+DluchNpazNFM+uecD/ULnvr3RZxj0
	 lmNvFugY29d55iuycNOG+caifQwbMfIUamHeDOCQ=
Date: Tue, 1 Sep 2026 20:09:34 +0530
From: Linu Cherian <linu.cherian@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-hardening@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
	Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	=?iso-8859-1?Q?Pierre-Cl=E9ment?= Tosi <ptosi@google.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Subject: Re: [PATCH RFC v9 03/25] arm64: mm: Enable overlays for all EL1
 indirect permissions
Message-ID: <apbjpkTgtdXZQ9Sm@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: qr6nbg1ogofard4gruxegypepstwooak
X-Rspamd-Queue-Id: 7422240003
X-HE-Tag: 1788273579-560247
X-HE-Meta: U2FsdGVkX19gahAzE4gGht/S89Lpok0Yj4FFICFlieR6MWrq3aMWg+jw+yyo8uMIeIZRuS7lHU99/vO0baKf2wFerNoyp4y5sJMyCY6KaUB6CumtZcNukXseJDVpYkTap7qRgLIld0MPWx1lhvBuuWlMVX5DwYfoH2KoFr2htJtiofOlrRYSbKZBVrknifsr8SYUshE41Fi1q1VR1fgDAZNqtfn/rMXHO/insDfOTVctKDhOoEh8K7srbq9sYaj0yv2wCvipEBobq2nn22fZ37xQsxbEjf1Fo9yrrbkaDIJF7ySJXkaAy3pHDGnLR4kJbYRsBALieXOQ65J/pYdgbPrsDUGkCe7j3D0q9yreL4G6RvdH9xi7hCOPZ9Tm6x2LHyTzXcCeEhNT/lGtDvJkCduZP9lk6iMk4/xMzyPN67MIYf7CfhJx1h8/C+tY0ZPib/c5/+Dmg88hwEPJ26JPYideQ3yDWZVBfqDtleTK2jYkh982hd/BW9C92Ekm7HeYfX4UYgoHEYfqMdyu+mKTuk+FfvFHWnKK38Ohw8XsELAlwNyRZQCJA6ha2p8s4c2HeyoY00hJ7f2XEZ4wgHdXtgEZjSoLnH5j+k9Zt+CpGUDT+7r0xcWaRue5CRv1UikkXrZynnZNfktlSakd2xqI7lgn8P4m4VHfOaxeNH04iWAJilF48oxDKXwhCne08YxtblbouEq0UQnFtXJuFiwoMnshjN3Ue3kVxVRp6rFmnuCn0XHrx58bEhELfYAD0b9D3I0RV/NrnMnmKBtz8fHO2we184pDw+lY4rjC7OLLVZadVkXhwmKIlN73gl8T+sAjqMuKO2HTsGv3qExeGST13KvqmxG1XFrpsGM/diy6mNyg6abiiT2gh2SrvieHx0wolYk4PI2ZspUJs0EYt89Qe99I6rANmWPfsSWhF9xhOcI5qzZWZ2+yq8c6t7GAhiEDCYkqSLT5Nl3DRjr0Kni
 y8KpeP/v
 Wqc5jtUYjpgl3EMw1CdbY4nfi4iHVywpNu/X/kNfPwP0enRznsXIOrEEjessYZjEJrx6U8K0sEtp9YYWQJrCcypDLe6SR3ULTii3+ctEkZNIBmA7S4ANFYt32BQefczTGvb0/4PTwUa/SDcyp/yz7jwc/U2ageTk/k1IULiwQ6os05KX87fGaLNrIGQ+NHyOIuewXL0PHwLnTcFOc17Lcgsurpcdv0e5XiupIsPXvZFix06zBeyjZJcN719JX3okxY4US7pbJ7SCe0GxZgbtxaqKIYfDLZ3xlD13FCYOR0xytj14osjgbA64EQLonLVjIdXzVnz0nj5XLQs6z6svkDkav37KRfl8HBK/Jqtn9vmo2NLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kevin,

On Tue, Aug 18, 2026 at 03:08:45PM +0100, Kevin Brodsky wrote:
> In preparation of using POE inside the kernel, enable "Overlay
> applied" for kernel memory types in PIR_EL1. This ensures that the
> permissions set in POR_EL1 affect all kernel mappings.
> 
> User memory types must be left untouched (overlays not applied)
> because any privileged access to user memory (e.g. futex atomic
> without FEAT_LSUI) would then be mistakenly checked against POR_EL1.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  arch/arm64/include/asm/pgtable-prot.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 212ce1b02e15..d4d45ab86a5a 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -183,9 +183,9 @@ static inline bool __pure lpa2_is_enabled(void)
>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED_EXEC),   PIE_RW)     | \
>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_READONLY),      PIE_R)      | \
>  	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_SHARED),        PIE_RW)     | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX)     | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX)    | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R)      | \
> -	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW))
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_ROX),    PIE_RX_O)   | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_EXEC),   PIE_RWX_O)  | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
>  
>  #endif /* __ASM_PGTABLE_PROT_H */

IMHO its better to have this patch just before, "arm64: Enable kpkeys" for
easier review. Otherwise,

Reviewed-by: Linu Cherian <linu.cherian@arm.com>

 

