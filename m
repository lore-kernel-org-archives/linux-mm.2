Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4018CF6C18
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 09:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DE876B0092; Wed,  7 Jan 2026 04:06:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9126B0093; Wed,  7 Jan 2026 04:06:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A12B6B0095; Wed,  7 Jan 2026 04:06:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 039E66B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:06:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E9AC1A01B1
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:06:08 +0000 (UTC)
X-FDA: 84304586016.08.721AD2D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E4F7B1C000A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:06:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gp3clrex;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767776766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvnEwkDYSB/jihgGeK4Vpiag8LQBrUYYgwlxuwDfTA8=;
	b=5eb+UP/GwNiDoiuR43Fp90OKkFDU/cEqRYgY98gl/lGVSfMduIDepa6xZ+FvQ4BWyxShFw
	wf3xXFJCsTzJ/NJrIA8eMQi5DgefI6nxFhcC4a6wEqnUYwy1RIyq0Yhfg9noLHJeROcX9y
	fJEgUS7SMuiLms2iZNR5OpLDOepQLXE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Gp3clrex;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767776766; a=rsa-sha256;
	cv=none;
	b=oT3kIcc9hw2PMs/79d3gIOuEASZabIMKzZA2hAf0OWeVTzH1PGEOU8ksBrg6dAFj+Cwsiz
	lbuiLznoHw7dT0cmy/Eq+2tuoaZG5k1jv5d1yAZlOOZ1PlcAz2Q2+7OC4FA5YgOYi4AE6P
	xav/2/7EqMc6gNMyP3GKmIez2nK+xJE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E95CD60141;
	Wed,  7 Jan 2026 09:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E975C4CEF7;
	Wed,  7 Jan 2026 09:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767776765;
	bh=pMgU+C5FcOLCmP6ptKqgGVGjjrLsI8HbEkAssUEFqo0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gp3clrexlQYTflBjEroGcywSAtzuN1Rwv0/QCEq3+PrJVFxFCVnDuCiuhES9FxML1
	 +DUJuEGclss/ATJRkynVca+Jnh3h6LZ1jKDlpzlWcRAo6+izc5O03Sz6x9cKrXFMgx
	 Y9bLrHVqoYADWUH0XXdTVI1WfeT51LlKWgWoIjuvqFNTY1UuAQKsvL4rxcgKYa53RT
	 HwvCsYN0oC3j7a2aYW9dIrhGAdIXV+DZgKRIozZxrf5fhJ5MEoUdXKbMDnSFYYNvLk
	 A7qYfjWXWSXUlNaU2pK6XIEQpbQqJGgs3DYcZ5NSns73Gyit+KIQRcRWBuYWEkPzAs
	 SZx9UZSS/0clA==
Date: Wed, 7 Jan 2026 11:05:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: alexs@kernel.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Guo Ren <guoren@kernel.org>, Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Michal Simek <monstr@monstr.eu>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>, Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Rich Felker <dalias@libc.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"open list:ALPHA PORT" <linux-alpha@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:SYNOPSYS ARC ARCHITECTURE" <linux-snps-arc@lists.infradead.org>,
	"moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
	"open list:MMU GATHER AND TLB INVALIDATION" <linux-arch@vger.kernel.org>,
	"open list:MMU GATHER AND TLB INVALIDATION" <linux-mm@kvack.org>,
	"open list:C-SKY ARCHITECTURE" <linux-csky@vger.kernel.org>,
	"open list:QUALCOMM HEXAGON ARCHITECTURE" <linux-hexagon@vger.kernel.org>,
	"open list:LOONGARCH" <loongarch@lists.linux.dev>,
	"open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>,
	"open list:MIPS" <linux-mips@vger.kernel.org>,
	"open list:OPENRISC ARCHITECTURE" <linux-openrisc@vger.kernel.org>,
	"open list:PARISC ARCHITECTURE" <linux-parisc@vger.kernel.org>,
	"open list:RISC-V ARCHITECTURE" <linux-riscv@lists.infradead.org>,
	"open list:SUPERH" <linux-sh@vger.kernel.org>,
	"open list:USER-MODE LINUX (UML)" <linux-um@lists.infradead.org>
Subject: Re: [PATCH] mm/pgtable: convert pgtable_t to ptdesc pointer
Message-ID: <aV4h5vQUNXn5cpMY@kernel.org>
References: <20260107064642.15771-1-alexs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107064642.15771-1-alexs@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E4F7B1C000A
X-Stat-Signature: 61i7p73sopordmzhk6chdznnefc84non
X-Rspam-User: 
X-HE-Tag: 1767776766-548322
X-HE-Meta: U2FsdGVkX1/aUy/GlRmMB1dCBbD8XPzu5rfmrfiEwyiXSvcP6Jka8t0BZwdmwOrnNUZjYfZ6m/q0kkcCcghB9+u0R56TQ0iN0ra6iO6ZnplcKqvhrrRgO85UOckystLnvDnlHWg9U+o6bh9uvhMLkLcdm7lht+Zwz7fGMyP8zSvvtAhcV06eTMmneiuF2ZwULpLb74kiU+qiNywllGEaZEEgBhlR/T84h1Pu6yWWXeI1V6LNmh32/v7NWgmxrQJw3oYSjlNDe3sIwHc6KeyXNLO0o+C6S5zmOdOL9yB6D8En5u7jmenn/DuOQ9+KwORmD6l1+98ChwqTZnbd8uFND7Jqx8VIww2VtaS3huQRigl+oMoiMlzWqZrrqGPDzFoJrCKAS1qqDxEnAcGpOGmIwARKO0AU867IURB4KrMP1nROtRjx+HjFB5ES9SuIfb9OMh8Z7y4O7xZSOkxqaosR3u4Fk/G+MTJx9rtfkI737vMnmZlCSsaGN4+2sggKzfXb2hD20uzVTQcnqTG32mTe0eheXaBj3NIk7UlzDXJjY41mDa07AsUcgc6u8phYPBXImesLi3D9ocj4w3dhzlQ7R0VcmIjFengtYnWQZ/BJlHLiRC5zeL09/Ig8H/uEu0ZFiaSXW6VLKrnlKYEWaWGbEz9hLnxg1CSOewwambsl8+pxq008QRNvG7iOuEam3+qobcQCF4G3G8o0KpvFL7qruGEipE5lVh0Zsmx/950S97K891xs/VoHigSRHVebfnB8C2+Bi38PgIb2469WTbHVcQhpKQpw7cDoqqFgHltnk4L5wGYFMneRsEePY1xu8uDLNTTOQYp0Ah7FjZl4ObP+hrbajaC5sUvZCpTftUH+v1Mh7HkHovA5AlpkkIzv+JJPvKHYJCXTetztR2hwZhuF9hHKffiQLoKgW6kyaYDNUZFwQ+Dk2Zte8FhZbBVJwg2ws9K8pFxtla08cyp4VNE
 cvDlLY0P
 R5/xxVkturLtCBbXJZd+c1ioxhfsBDfOFWu2HVXnHkwl6EUFBeAF/iXvV2GObWATmVZhIkjfs1a9RY+5HjFuNRIss9jSFggfkx/ZviEGoOY9OITRXVCwzrHcOyJxPlounTDLiM1wM/fvKms1OZ9S+6v8RhOngdjnv7nRYFHdzt047efVh+gSJjKZPiP8tI9u6kjNUEPRA9tEe1EsxJPAHIowCyJqwt8QUMRu5cZcf/Ofgdns1R7zaGCLVoffPzc98YVVr+fuu5qDIDyNj8x7PYMTOybAHVdWm+ymtAHe9p4vyPsBet0dH9KTAV1z7RTCDQsFQyn6tXps76HnUTSbfyTnokykSL64WmRf9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:46:35PM +0800, alexs@kernel.org wrote:
> From: Alex Shi <alexs@kernel.org>
> 
> After struct ptdesc introduced, pgtable_t should used it instead of old
> struct page pointer. The only thing in the way for this change is just
> pgtable->lru in pgtable_trans_huge_deposit/withdraw.
> 
> Let's convert them into ptdesc and use struct ptdesc* as pgtable_t.
> Thanks testing support from kernel test robot <lkp@intel.com>
> 
> Signed-off-by: Alex Shi <alexs@kernel.org>
> ---

...

> diff --git a/arch/arm/include/asm/pgalloc.h b/arch/arm/include/asm/pgalloc.h
> index a17f01235c29..1a3484c2df4c 100644
> --- a/arch/arm/include/asm/pgalloc.h
> +++ b/arch/arm/include/asm/pgalloc.h
> @@ -96,12 +96,12 @@ pte_alloc_one(struct mm_struct *mm)
>  {
>  	struct page *pte;
>  
> -	pte = __pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM);
> +	pte = ptdesc_page(__pte_alloc_one(mm, GFP_PGTABLE_USER | PGTABLE_HIGHMEM));

When ptdesc will be separated from struct page, ptdesc_page() would fail if the
allocation failed. This line should be split into something like

	struct ptdesc *ptdesc = __pte_alloc_one(...);
	if (!ptesc)
		return NULL;
	pte = ptdesc_page(ptdesc);


>  	if (!pte)
>  		return NULL;
>  	if (!PageHighMem(pte))
>  		clean_pte_table(page_address(pte));
> -	return pte;
> +	return page_ptdesc(pte);
>  }
>  
>  static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t pte,

-- 
Sincerely yours,
Mike.

