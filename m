Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911E7606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cfI/L2eY
Received: by kanga.kvack.org (Postfix)
	id B21876B05BB; Fri, 13 Nov 2026 13:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABA0D6B05BC; Fri, 13 Nov 2026 13:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6986B05BD; Fri, 13 Nov 2026 13:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0F56B05BB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:42:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0056740248
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:42:01 +0000 (UTC)
X-FDA: 85430965284.10.FC0A461
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 659A8180007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:42:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cfI/L2eY";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595320;
	b=Rr1NGGQuOgOdu5q7lsyyESXhYAahompdUDmMa2pgZrxS5jdVsZN6Gfq2uRVGvdJNkkIPxm
	hIixFHgMjACh7MQJLEONfm/jg1zMBc1mAiIMISMSa2iJ5GtYvkuYcEJewlDllZ3Rxq/eiZ
	Qybp6xNIsjATR/0qfmuEte5f4aZIpRU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cfI/L2eY";
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VytgQi4p8wcmmELrEfY15mVmpLYzi4XAlS7bqFMpaOA=;
	b=P/k8IFbCZNsC0OX067n0/yZXaoAOma/smVpk1gPoGIWpAsTpc7vvZGU8X2XmEdpHjCb19q
	dMvI00hUJPWJP4kX2GSSPBbMxQH7R4OIgRlyjqDzj2yFldLNjCJUPw3IAMsX7uFMEQEIsM
	ITMzp17QuMBHOdYPX1IirkeFJ4ht5Nc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CFC84615E4;
	Fri, 13 Nov 2026 18:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E0221F000C4;
	Fri, 13 Nov 2026 18:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595319;
	bh=VytgQi4p8wcmmELrEfY15mVmpLYzi4XAlS7bqFMpaOA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cfI/L2eY2qjwVL7APHC67QJOIGk/JNOUabcKBMNTHVN19Rcz72eUV6Yh3y5Ea/LHZ
	 z5QbQ0lofex0YKPkP/CrCot0WtLB3Iun9cb9TpGzWGq7i0diBi7RiTfH+PMAtEzL2+
	 C0j/tS7srsbkDAQQkLK7ashTa4LxtBlawzOcVQduTw15A7JC0FoBx70BE+lVHeY9Dq
	 c07fq9ZOjzPKmREqLefO5blbiTlVapyN80u0xRg/xm4Y01ZY7klw7sdg1ydyXEPskb
	 46DP+YMZNRJ2jvH8liJQifBhGUdO/X8ERo88dTaNWRmserH3XKGKSg7PzJ1GdT/0k3
	 sU3CZpk80JuTg==
Date: Fri, 13 Nov 2026 18:41:52 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Matthew Wilcox <willy@infradead.org>, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 3/6] ARM: drop CONFIG_HIGHPTE support
Message-ID: <avdZ5SCLnUg29Te8@gremlin>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-4-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-4-arnd@kernel.org>
X-Stat-Signature: pjnos565aodko6dy8ksef76fek4shi8a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 659A8180007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794595320-130487
X-HE-Meta: U2FsdGVkX18CB3+XZ11T1k1ZZi+IoYAKsnGiPOs1w/0NTOvodyHWfleUS3xKRGWf6Xvjxhe6QT2A7OLce+pixResxs6adRgbf2u3NIzMM5uLDaWFY3XwoSmk0AMraNMN1fCT6xf0k8DpAeT7nQ27BpdsFOwuGG2JMaf0GJ4rKBgTocIudI0QFLDWsnFE8St9EvNokYoWKOa+5zbC5VD7K4lJpnK40UPIqtecyuMwGNOF4wCM/AS7WG9j9b3JIZWk99GRZ13WomjQM8ajv1NKFiQikQ0oNlf5bPnJq1uA20Xzf0avob1iv/EXr7emdg9C+f0XWUw2oH9jCJ7sN++TiSW8alIEsNZuWim8cXEqZB0xawrfDXjvYbolEfPeU2iBwn1/65bHKVO90dPALJ1YC0ThJ4ACBvvWKVaJHii3AAY+hSEMKVzcadwP9CzJB9zRjNA1RVSkKk0gAHFLa5a8YYlxOdlmzeI6CIv1slys+EPlICcsX1eODwBGc+Xa7cWrUk+xmDDFDGK7E6oESxeMFnNwO13b3p4OUntuonicUHFfWYA6G5rIp3QFXxF/DoTXxZlTYv4XtkQNslvFFOvmpfolljXSk1jCxjSa+YEgzwgqeVg9nQEy886+vkoUHB27XZoG4Dz27635uhaDbJVBiy0DgESHrbiyiivxVmnIHGuCtps0IjjhD9CtnKE/7ThjKSwVJ0eZ+GRC0iWFWKd73X+zIYzVc7h/eqexAokPbmUKWUtD9pLfgnGtDhH31Z8fH/7tSLIj6EDC5wFhquc6QGPZQZEK6+xMHmSbc+uW9WkITbRafOlVWB+G7YKm4vZvPn57ZSlUhDgHYJ8+ZEu5ucYExNs6Z9PndtdgtnWjkYo0PV6NmvuWu/vCR0teoKVcHmp2hbIuEt7UVGtPXps8LZCxSOA9nI+fJOFcUpr6J1XksgHPjS1/yaZ8+fB4jgybZt4hIRMUosJCW3ZJkDp
 xKilae5N
 rZwohI5jGCWObROMeuIsCzv5ehVX2dCUilgI+tjDk7+Y039h5VV/rL6Ed7vYQrEPTRs7VIJyGKhjwZxa+696uLb7WhPwn4d7WBicNryVeNDJT4ZVSmHp3b08SKSq/ewUX2wlDIKbRfrM1VS5kIWLBprOsA3FBoiFbTg/YQprcfwQjiMP8nFevPhR62szMHEz7dQUIBnY5vQ07VtrPOTheILQHrjL0k9zILhlPCdD0pB4M/5YK109rhH5+PHiGjOaKf4GQB3cJc6ikSFqZMF5uHz6W3PJv7VHzoiaslxvBwmkj8FgZ4e20CZBRi1db7VNGHTM6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:25PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> CONFIG_HIGHPTE was added in linux-2.6.32, a few years before 64-bit
> support. At the time it made sense, as the CONFIG_ARM_LPAE option allowed
> systems with 16GB of memory that made lowmem a particularly scarce
> resource, and the HIGHPTE implementation gave feature parity with 32-bit
> x86 and frv machines.
>
> Since Arm is the last architecture remaining that uses this, and almost
> no 32-bit machines support more than 4GB of RAM, the cost of continuing
> to maintain HIGHPTE seems unjustified, so remove it here to allow
> simplifying the generic page table handling.
>
> Link: https://lore.kernel.org/lkml/20241204103042.1904639-8-arnd@kernel.org/T/#u
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I sent a patch to drop HIGHPTE support on x86 today, see
> https://lore.kernel.org/lkml/20241210144945.2325330-9-arnd@kernel.org/T/#u
>
> If that one gets merged, we can merge this one instead of the one
> that makes HIGHPTE depend on !PREEMPT_RT, but if we decide against
> the x86 change, then we probably don't want this one either.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

With Mike's change applied, LGTM and:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm/Kconfig               | 11 -----------
>  arch/arm/include/asm/pgalloc.h |  8 +-------
>  2 files changed, 1 insertion(+), 18 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index fd01ccab9c12..fc66d52d847e 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1225,17 +1225,6 @@ config HIGHMEM
>
>  	  If unsure, say n.
>
> -config HIGHPTE
> -	bool "Allocate 2nd-level pagetables from highmem" if EXPERT
> -	depends on HIGHMEM && !PREEMPT_RT
> -	default y
> -	help
> -	  The VM uses one page of physical memory for each page table.
> -	  For systems with a lot of processes, this can use a lot of
> -	  precious low memory, eventually leading to low memory being
> -	  consumed by page tables.  Setting this option will allow
> -	  user-space 2nd level page tables to reside in high memory.
> -
>  config ARM_PAN
>  	bool "Enable privileged no-access"
>  	depends on MMU
> diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
> index a17f01235c29..ef6cb3e6d179 100644
> --- a/arch/arm/include/asm/pgalloc.h
> +++ b/arch/arm/include/asm/pgalloc.h
> @@ -85,18 +85,12 @@ pte_alloc_one_kernel(struct mm_struct *mm)
>  	return pte;
>  }
>
> -#ifdef CONFIG_HIGHPTE
> -#define PGTABLE_HIGHMEM __GFP_HIGHMEM
> -#else
> -#define PGTABLE_HIGHMEM 0
> -#endif
> -
>  static inline pgtable_t
>  pte_alloc_one(struct mm_struct *mm)
>  {
>  	struct page *pte;
>
> -	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
> +	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER);
>  	if (!pte)
>  		return NULL;
>  	if (!PageHighMem(pte))
> --
> 2.53.0
>

--
Cheers, Lorenzo

