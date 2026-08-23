Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2287C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 06:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AFFE6B0095; Sun, 23 Aug 2026 02:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2601F6B009B; Sun, 23 Aug 2026 02:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D946B009D; Sun, 23 Aug 2026 02:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E24E86B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 02:51:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6379414026E
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 06:51:00 +0000 (UTC)
X-FDA: 85131611880.07.48D3466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D75E40004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 06:50:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPSFldhZ;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787467858;
	b=qghxEYQf7dKH9+sNwhUVj2mg5q5G917umEKLyG+PPGzmGMQ0e6H1a5DCEGnAJI0pE2GEYL
	vSPO7nlkBIaasffzjNT+B3QwFvOCCzOY2gDtwEgtLXLeT8ox5kZP5ZSyvquV1Glo4oaocZ
	k1o0S6xSleRDFLRdzK+OCAnu3QAcEfM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPSFldhZ;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787467858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PxHus4vSfS5CQqnKuDATVr2Sh5vCyrMBO6sWrbzlMGU=;
	b=kQMpPO/f8/QrAa7nlMLwzURetnj6ZQqYQbRGeRFvy20EizjJOUklqm+j3SyCHDp4mNmvEZ
	3Mi+cSwKwNz5+D8C6egVY7vGPaI08V/h7B197ipTABPx9KBkcugOzBTbblREZVgh+ETTQv
	CKYViLtqNKTAXNmxtpulam8Dt0j9n50=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4DAA242DDB;
	Sun, 23 Aug 2026 06:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E531F000E9;
	Sun, 23 Aug 2026 06:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787467857;
	bh=PxHus4vSfS5CQqnKuDATVr2Sh5vCyrMBO6sWrbzlMGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lPSFldhZWKsCQ8AGQqYAuquWRS9TzZqMwiUcVMs+0BySD3vagvlLEkEJCg93UdPyW
	 N+ICTFk+RFOsP4Dhox9+lwUmTkWOQe/wtA6WvXU4nyW0SvEXOUih7VIQfhIHmVmuc2
	 LSfNxqY7WQXEWTzVkOPVXMbgwruz/9uGE0axKAqNWgvEv4GphVR4bN9Z8bkea0Zu9x
	 GcsHbfF7d08egVV10MRPheMou2fqf0ILLKn8JL5dmWNvN8J38/2rgZE+XskopkA3Pu
	 SVFWVACMBBmB3CwY0NMt/L23BDtqm89EMJ/WgTHH+4bqcDFKvhrJ0kY75HIN6u4q2t
	 An1hwJnQWYPwg==
Date: Sun, 23 Aug 2026 09:50:51 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm: Drop pxd_ERROR()
Message-ID: <aoqYS9eFTPqtgFMn@kernel.org>
References: <20260806080639.1916749-1-anshuman.khandual@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806080639.1916749-1-anshuman.khandual@arm.com>
X-Rspamd-Queue-Id: 9D75E40004
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: abikr5m89zzseud3o4rsx3qutburjuw3
X-HE-Tag: 1787467858-543904
X-HE-Meta: U2FsdGVkX191hGVmcFuVN6WoyYBtybVBImYF+WMn+QRc/D+/c3n973nHqERMFnDSjS+JcKPu8QFmDkiV7wDr8KDezLmIV2pFoyZE231xMPVYGyXUevo2GXx5VyteLsKVIawPix8jLs2839hVEhRMCoYuMDThAxWP2ASOD7q102OEq76/GbRHZw3nAYsbAxGZo0Pwhf0EDcMWFUjTrWzRGSIOJYr8k2jIYV2HmQfoFlPtRSEtcwTBPra4cskEWdFqvCq/9vV/G9tdFMVIKF0PW1jfocGSnwahHi2Dd8uoYjD81OoHA7OBO/Cmz605+kFHj8n6AXkwcq7DnpJ3JBpAhczOkacgubqSvClo/+BjmyLzxffPHTvhn1u1iuwwzZfrKktsL7bUdMdWrLuKyX+JNK6H4ljiIMBOk8Up7GLoFBGJWONLaq/dR7ZPEZ0F7zX+JUzcWVnfOQltbw9pCs/uq1w4AKNe3J+RquRc9dW69qA9fQTQ+fcBwHTfQHE1Uxw0ai4ZP3lRiiVZei+bE7db3ouvumSOK8iQaX/OGVbHXOBbRAb3BAlA8+tu1OyHKW6OndW7o+RF0+/psHyHJjYEg6kKey9UM5ox39deo4L+lInYt2lRQ/p3e+f/K+92wv3HUF1epGXfc0BPTt/BEUC/IDaYKMRW/QSe1q3bEkzF1DpERtGlcGfE2OEFf3Zijn8dmsxHgdMuLGu7rw6i0Dw2MaVZ37EaAWbWPV0a3JW6nPTPTxcRqHZNBZbE7jICAmTP83TQ+HQltcr175bMJJn3BS6WTkWF4dJG4nDD549aPAUScEGTRbv1YfCjRjMc+/w8ruxk6UR2tSgKf+cmTqxc1KMOxX3YbeSOfb5B4dhlY3bw8WeT3rWvJivJdCEWhQK4G0dELTGIxAgnSL3qci8FEU2xY6UPGnivN44472YGbnWkWnSAP1r9mc5AUF74lDmjFZvyGlrOgpCMCRNv5BN
 4n3OFVwx
 /fuE8X8jg9OQriSeAAIiw7Js9BzVV9zADdHRuCtjC0kTODjbPD+rHIr8/B3GxGB7AJ2V7Xeuk22CAMKC3LZaKmKt+D+lKbcu36dfwjHAZJdfCMba0QJwL7R50YfzZ+088onglj0mqwafR01pWaCwnoU7txlwjNatcV7NW4eQm0HpSJVPSHToHxNFPtbbb5B6i5Z/vt+xItcXYuwdCZlvvzdiJUvhF/EefJW5Q2u6u3HBTpbDxJsh3KlzRNy/zTBWMAX6yvCu+nzhXDVZ9IaBHuV1YnSiQ07MvxwmtM6CbrnhY93ZLiPmUVugbPlGPP90No6QqnDmo/dOuVtgP425kQ349dAK5BJZVT3NQAechPmZQlAwGn0TnYYkN5LmxbsaU/v+1E6QQdHneclOBI+Le2Ii/aX++fTpqLdHkQB2iOgS/4didbdPgQUUssxJjYrDFY+aoiLULPvQY5MGgggaswAru2f8sWBYcE0HAtoqabPI5J3zw1+QQ8w47qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 01:36:39PM +0530, Anshuman Khandual wrote:
> pxd_ERROR() has been used in generic mm just to print the page table entry
> in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> pxd_ERROR() macros have been provided by all platforms which basically did
> the same thing.
> 
> Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> page table entries thus completely dropping dependency on platform provided
> pxd_ERROR() macros which can then be dropped off. First move all required
> helpers in core MM into a header file which could then be used else where.
> 
> Although some platforms still use those macros internally as well. In which
> case just move these macros inside the platform for now.
> 
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org> 
> Cc: linux-arch@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
> This applies on v7.2-rc6 but after the following patch
> 
> https://lore.kernel.org/all/20260709044334.1741263-1-anshuman.khandual@arm.com/
> 
> Would it also make sense to just drop __FILE__ and __LINE__ from the output
> in pxd_clear_bad() helpers as they always print the same details regardless
> the error path and does not add much value.

Maybe replace them with the caller address?
 
> Build tested for various architectures.
> 
>  arch/alpha/include/asm/pgtable.h              |  7 ----
>  arch/arc/include/asm/pgtable-levels.h         | 11 -----
>  arch/arm/include/asm/pgtable.h                |  7 ----
>  arch/arm/kernel/traps.c                       | 17 --------
>  arch/arm64/include/asm/pgtable.h              | 15 -------
>  arch/csky/include/asm/pgtable.h               |  4 --
>  arch/hexagon/include/asm/pgtable.h            |  3 --
>  arch/loongarch/include/asm/pgtable.h          | 10 -----
>  arch/m68k/include/asm/mcf_pgtable.h           |  6 ---
>  arch/m68k/include/asm/motorola_pgtable.h      |  8 ----
>  arch/m68k/include/asm/sun3_pgtable.h          |  7 ----
>  arch/microblaze/include/asm/pgtable.h         |  7 ----
>  arch/mips/include/asm/pgtable-32.h            | 10 -----
>  arch/mips/include/asm/pgtable-64.h            | 13 ------
>  arch/nios2/include/asm/pgtable.h              |  7 ----
>  arch/openrisc/include/asm/pgtable.h           |  7 ----
>  arch/parisc/include/asm/pgtable.h             |  3 +-
>  arch/powerpc/include/asm/book3s/32/pgtable.h  |  2 -
>  arch/powerpc/include/asm/book3s/64/pgtable.h  |  7 ----
>  arch/powerpc/include/asm/nohash/32/pgtable.h  |  2 -
>  .../include/asm/nohash/64/pgtable-4k.h        |  3 --
>  arch/powerpc/include/asm/nohash/64/pgtable.h  |  5 ---
>  arch/riscv/include/asm/pgtable-64.h           |  9 ----
>  arch/riscv/include/asm/pgtable.h              |  4 --
>  arch/s390/include/asm/pgtable.h               | 11 -----
>  arch/sh/include/asm/pgtable-3level.h          |  6 +++
>  arch/sparc/include/asm/pgtable_32.h           |  3 --
>  arch/sparc/include/asm/pgtable_64.h           | 10 -----
>  arch/um/include/asm/pgtable-2level.h          |  7 ----
>  arch/um/include/asm/pgtable-4level.h          | 13 ------
>  arch/x86/include/asm/pgtable-2level.h         |  5 ---
>  arch/x86/include/asm/pgtable-3level.h         | 11 -----
>  arch/x86/include/asm/pgtable_64.h             | 18 --------
>  arch/xtensa/include/asm/pgtable.h             |  4 --
>  include/asm-generic/pgtable-nop4d.h           |  1 -
>  include/asm-generic/pgtable-nopmd.h           |  1 -
>  include/asm-generic/pgtable-nopud.h           |  1 -
>  include/linux/mm_types.h                      | 40 ++++++++++++++++++
>  mm/memory.c                                   | 41 +------------------
>  mm/pgtable-generic.c                          | 21 ++++++++--
>  40 files changed, 65 insertions(+), 302 deletions(-)

This is nice :)
 
> diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
> index 467b8547ac8b..cca30bf11b4c 100644
> --- a/arch/parisc/include/asm/pgtable.h
> +++ b/arch/parisc/include/asm/pgtable.h
> @@ -75,12 +75,11 @@ extern void __update_cache(pte_t pte);
>  
>  #endif /* !__ASSEMBLER__ */
>  
> -#define pte_ERROR(e) \
> -	printk("%s:%d: bad pte %08lx.\n", __FILE__, __LINE__, pte_val(e))
>  #if CONFIG_PGTABLE_LEVELS == 3
>  #define pmd_ERROR(e) \
>  	printk("%s:%d: bad pmd %08lx.\n", __FILE__, __LINE__, (unsigned long)pmd_val(e))
>  #endif
> +

Stray whitespace change?

>  #define pgd_ERROR(e) \
>  	printk("%s:%d: bad pgd %08lx.\n", __FILE__, __LINE__, (unsigned long)pgd_val(e))
>  
> diff --git a/arch/sh/include/asm/pgtable-3level.h b/arch/sh/include/asm/pgtable-3level.h
> index d1ce73f3bd85..3cfbec15de2f 100644
> --- a/arch/sh/include/asm/pgtable-3level.h
> +++ b/arch/sh/include/asm/pgtable-3level.h
> @@ -28,6 +28,12 @@
>  #define pmd_ERROR(e) \
>  	printk("%s:%d: bad pmd %016llx.\n", __FILE__, __LINE__, pmd_val(e))
>  
> +#define pud_ERROR(e) \
> +	printk("%s:%d: bad pud %016llx.\n", __FILE__, __LINE__, pud_val(e))
> +
> +#define p4d_ERROR(e) \
> +	printk("%s:%d: bad p4d %016llx.\n", __FILE__, __LINE__, p4d_val(e))
> +

I'd expect that all arch changes would only remove code. Why sh needs
those?

>  typedef union {
>  	struct {
>  		unsigned long pmd_low;
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..1025b9140c0b 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -2001,4 +2001,44 @@ static inline unsigned long mmf_init_legacy_flags(unsigned long flags)
>  	return flags & MMF_INIT_LEGACY_MASK;
>  }
>  
> +static inline void ptval_bytes_to_hex_str(char *buf, size_t buf_size, const void *entry, size_t entry_size)

include/linux/pgtable.h seems more natural home for this

> +{
> +	if (WARN_ON_ONCE(buf_size < entry_size * 2 + 1)) {
> +		snprintf(buf, buf_size, "overflow");
> +		return;
> +	}

-- 
Sincerely yours,
Mike.

