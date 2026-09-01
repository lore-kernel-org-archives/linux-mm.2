Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7075C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3736B025F; Tue,  1 Sep 2026 10:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B006B0261; Tue,  1 Sep 2026 10:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD78C6B0266; Tue,  1 Sep 2026 10:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE076B025F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:41:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A88CC03E9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:41:55 +0000 (UTC)
X-FDA: 85165457790.30.CD0958D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63F9640008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:41:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W6jAho6o;
	spf=pass (imf17.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788273713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cl6F6Miw8lEHct9STUMcq8GprLffBk/UweQG5DcsRjc=;
	b=WPIyTk8Kb/MFmOx47criFFQ1zDRBTbFmjsRah7i70aG5Z0NrLgA9g6IE1JkAdWpOWHWRio
	y2h5pzCg6YG912OmuoVxL3FcG+eoE3XZcCYKbP8/FeZg8nJLLEheZc1S/D86k21LaLbtM7
	Ex0MroVUiHsvK4xq6DqIwDDxjytDdqw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788273713;
	b=diOezuCc/51fE02DIU78qLrIgR7N7u9nQRD0/ieE66WXV2Ns5dNL60D/6FgREr/dwBOp0Q
	G4PFqvt6vUxjfgCVct9sdCR1L5/aJjoUctS99y6qAhyY5zkby9WqRWX3en3Zecavs0xyb0
	S6NHQ+Y/pOvD+MvKFI1E6orf3z2SFYQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W6jAho6o;
	spf=pass (imf17.hostedemail.com: domain of linu.cherian@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=linu.cherian@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D15FA1756;
	Tue,  1 Sep 2026 07:41:48 -0700 (PDT)
Received: from localhost (a079125.arm.com [10.164.21.43])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D44793F882;
	Tue,  1 Sep 2026 07:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788273712; bh=snJg8J7YvE9qwQxvspmDeoEOz9TuP5DGjyz2EhgFpiI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W6jAho6ofGyQs5GQnfQOW5uksCJ1e17WJJ7V7cqlXthypkpqFqQi0SVDcF3ENcGIi
	 p9fyye/phvqfqVjswNSqg+6c4K6KTZRA6g+RuZyXdhipmVupTw5yvtQ3tFecCsMCiJ
	 lVDOXidsWDyBk1tSPtcon61p30IJ3cQWyLhgdLfc=
Date: Tue, 1 Sep 2026 20:11:49 +0530
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
Message-ID: <apbkLbO40urPNmEH@a079125.arm.com>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-kpkeys-v9-3-743ad31b2c8f@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63F9640008
X-Stat-Signature: ajb54765nafp7k4sy6xh8jr66treyb7z
X-HE-Tag: 1788273713-995220
X-HE-Meta: U2FsdGVkX1+5PHsVUYkTTC7eC8IGkj4mpXc8zctri5WwdhUudlmSmSLFfp+2gbxwLmGROO7yoBjh9zYe6DYaX9bV2hpO37HeaPQIH4LtYq9IgEkTLtDWaOFAiKbSUA5+Ne+yeUNC23xE22o/0MV+R3PnHGwL37SSqkmsXAsExEkuXKNqIly7EqvVaWSvmsJkIS8SiZudWz1XAlgqOTAzcD76W2xQ3hrQpiwLeD5IH77vlX+asqr7bAjl/FVtMRqmqKRKO1jwi8N9W1QPCwFqmYy0emdehj8vpuzzyg7LevPbj7/CX8jou0K7GkjcZtRnOnNkcQLh1eaLjEGsessEwXMDKmt78IJ7TUvFH4bJ41bVSbuq2S9j30BI7pnB0OTx97wtmpE4BTgBe85WOeH9mIwsG909U3oTbBE7dzKmgUGxiNelYH0XOb6hBJtqj7MCzXDRC/4fLu3MsiyqPaKTVo93k2MFQBKitqNkfY4dHDK5ROYqvDm+IdbW6NMIjdJ15NC/M+3U4FQlw+tDfnwYVVJ0XXBkGsetPfZPwDZBakpJ4UtCKKxbGCL+VwXC7+q6vQ+TnNONALfmarDx0CT4l1nFOyRMWJ/8ruhY0kKdigM5+JTvUNYJR6xjz9QmNy9aKhTEM1Hv1DcihfkErpOVYy/M+bHth0lVHgk3A76x30p5nmqgbuQ5UY3MOMZB2JMfCvWPlN71XKj6gI8H3EXnF/iLfFLDOQjTdOos1wRdrNviAoDS7Xn6RyIH8zuxdWOdhQnmmc35tJO+TG59uBK0s7ryE+PhYaDbeWB3DwW0+6G9cpdZAXZcyuyEF17DalcDB4HhMTrvEvL3bMEAvG+PDoiKSyxRtoCzGDuH7jwvW6rLNhtA3qOLKOPr7KZnhJimuo1yRJDl1wp9dS+emvcvop9VlM++4Znf5pttvWh+QR6/Ju3IbTfAhk+r1mA3zTm49+VtKIAzs1uOz/8kRUG
 Ow1hA3Hu
 5LJuTSOwWrMcmnUObBPTdwKvZl+CcbYpMNcflATRRZABFPnufJ1X0VplbGPa/uHa8eZRnryXctvd2cr+j3oRv/2h7AYMIh4ByJAflgpPJmpSgdGS9DMlv6+2nfEHNKWk81ihRaTVA1GFmImtMHWIpoi73wnWxBjj6JQAFJ6wJb5gco5hrhM0mO/oi/WOlWi2MjT02EejPpu0Jj9Q3OLGHt8xw5vWDs8ZQRGg4lGadPZYMqjHyoP7IFFC0gtEHAfk7yr7va77Ti0FlfGnvU1yH/8aL2Usvb1f8lAlyij67Xl5rzW+jnQ9VmS/2fzOlo142VafzbCLtf3SHpFDBfhGJRFw5sQuEfs9f0+T11kNuzq5ay+s=
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

As part of hardening, should we really add more constraints to the
KERNEL_EXEC by making it PIE_X_O. 

Just trying to undersand, not a concern with the patch as such.

> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL_RO),     PIE_R_O)    | \
> +	PIRx_ELx_PERM_PREP(pte_pi_index(_PAGE_KERNEL),        PIE_RW_O))
>  
>  #endif /* __ASM_PGTABLE_PROT_H */
> 
> -- 
> 2.51.2
> 

