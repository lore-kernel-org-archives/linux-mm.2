Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA20C5DF9D
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 05:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE4466B0088; Thu, 27 Aug 2026 01:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A951E6B008A; Thu, 27 Aug 2026 01:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985496B008C; Thu, 27 Aug 2026 01:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 699316B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:28:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBDDA1602DF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:28:21 +0000 (UTC)
X-FDA: 85145918802.19.C231DBE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id C8561180005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:28:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Qbvokt9Y;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787808500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1H2HKWXQ51kiTh+XvcBnYz+8AssjoQxnEuTfe7RXVqU=;
	b=smfrlXXruUGv8j3PMyO06H0ngTMWjwPOHN5WBKrfAmeSr5EH5PzW/zecbbDkBKhEXjUDpS
	rAE8r/ouPqCvJTfiSS46oR+6ibfe7McC8KOGt64tIJ2Xb5j8BVzNpru5J2aaGNop3QDsRu
	zzDmrdsnqsen7bI3tjwg07jkWnjet2w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787808500;
	b=SdlAZ0SizosXTOZbE+y6j5Ea2+t3/Xi8DcLUwCT0JwKbTHJJCPtg0/LSp2drPxtdGA4T5Y
	S+5yYEAHTX7XJ9XjIx2mHhTGAz00U4JjNSomedoubL0vqlxHfWkM7CLEZb+ZyP9LIot1es
	H61taN7EnCkKoqpTT6rTqu6oiGTRki8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Qbvokt9Y;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E07A71691;
	Wed, 26 Aug 2026 22:28:14 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE0D43F66F;
	Wed, 26 Aug 2026 22:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787808498; bh=r3zpWAjSDYwO4obpTt1hi/LzERvjZcV2ma+xAQZJE1k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qbvokt9YNMXIimouS57c8IUjHG3UY/NxbyriHVJNF09htLAHlcOYfMdqN9rNk2Y3/
	 mSu7y20m+SkO9PdnMyXySHrLzwhN7q5RvdaRZuxZGl6y42IopDCGHEBnjAJBHjcg2R
	 GlMX/PkmQ3bkQo82ApB3CeCPp5qCKqiyYLpu1D5M=
Date: Thu, 27 Aug 2026 10:58:15 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>, 
	Rich Felker <dalias@libc.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, 
	linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-um@lists.infradead.org, 
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Geert Uytterhoeven <geert@linux-m68k.org>, linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org
Subject: Re: [RFC V3 8/8] mm: Drop pxd_ERROR()
Message-ID: <ajnoyja6a3hi2b7zn52n4dwrnpaa3ofpk6enekdan3babfsmbv@lnc3mbpogtq5>
References: <20260818040041.1891769-1-anshuman.khandual@arm.com>
 <20260818040041.1891769-9-anshuman.khandual@arm.com>
 <6dae9cae-9665-4dc8-9a49-d6e5acda221b@sifive.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6dae9cae-9665-4dc8-9a49-d6e5acda221b@sifive.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C8561180005
X-Stat-Signature: kf1xxes7km39xrwtqozwxgmai6f8qafz
X-HE-Tag: 1787808499-528387
X-HE-Meta: U2FsdGVkX18mnK109WFnUSE3CGJKtLaDtOjG6SGW+f6b8c701QCOhEgIKEUd0ZKkaj0Smup1n+d+KUm5CypGBjwYvI3mWFWKzR+OV7l6taWqIpEHCBp/zbs4SwqOM8Puq8izu8TOBM6KleYcGsN5h2gNmskWXkiDOnFpsV4gxPLcj5Uufuhizfl5f3THhfcqjvbJcry7jT5DND6K4zwjsXiq7crbK9/Y/zpaH+/NF74k5tvSJszbMRYCCjdFLgHQ+WojEMb6JRKsjh/QS0TmRVz2BmJz/Ivs6qgI4Bb3ZkfMkN6VLIgKZb8yIjsnMkjLmgaiYgRN73OesJOy61mxhNgsgE9KmbHqqJGy6Eyn+zv54yQPlJi/WXhC+Wpndik1S7UfhXkpVNeQo6BeZkLULwYZM15+/WMnIWJj1R/Uua2Pk4oqUt2YQxYErJ1bV9s7srYtZJNw+R10tuXOYPhVQghhCTv6pYzz0RV2cDa2a/dNA2clT7P/fKygLdMuDEluJkZutGz5F6oV1IAfUeqhsiCc3E/DNIGSLnFDRNojnBNP4qlUJIGYMxTG8VGV/ItzgeWn0Cpz8/2raK4Kyb8jDL1C6RW6YFq03HwSFs8JHhgGmZGsBTEpA3bmTd5B060uoC8JnSDXOx5LXN8IkgfERK/ycLC1uC3EgmRlRSvKDKM4ndTV5pqdDQhuTDZLUXC87r3xJ6KDl2kINhtJIfOxdBBaKNsnOUgHzJjSahsAX6BXwvIxitfw4eFjEPyT4vzMOxBM0A5rgs7LXlWals2eWNr6s7EzQPgGZ+6d/3qQKol2ryTwwDmPv7nQGw+zBxDQRZVlGyoyjraRzoFrn0ZkD9IM9iOdmPVi+RhFg1XFrsm4/Nqfsa5iHevWSgJG0WgzDOfqxn5r5z70/AaMxbX6ohMSeYNXloo/5vVkYeMjT9W8spm7bbvk08lfPDaWZJW77QG1lUw49Q2I+XxqzNi
 53/vbVPT
 11982c6triHzu4qlx95svY2iiLkV7uDUaC3PNp1Zlr+cHspVY39FAIkD8pldGAbCusUYriKuBJvHtaK2fUPxidF63Cmbxt/GkQ/FsiU+xxZLp333hXF0GdJ8s5csn5VQpmbGPoLwn6rMZlFuMRpiSPCEhlq9dyNGjURxe3qVoHQmdMSDmCsGoR0d33A9SLjlb5C/tK2LqdFD0RistzQ007liSK/jUP1smj+v84FagfLigpdmJmTqcLnsIMxB5/fstHpVdWMw19iq3ygje+oyA3La/eJTyRb8PVQvqX3n2HjA1WU7L42zlum6WbX9yEzP43zkL2AIrCIstzL9yw//fgOiV1nsuIeKJTK+NIoET8AXPSAN9dSeix+uliVOZG1QEJql3hKHj9duneEo4qeVbg5kqQcpT6DxhKQDdZbj3mviGz9vTqiIjTi5E/wY/6u7XfnsS4oCeQXZqn82I5xpzXV2LrMIFPrGjIP4TXVe8JFjz296v3EaWfFGoHjL0uMhgKjqSGGru4Yz5lft6T/crJd/VfLrQJKmR2ho8ytl9WlUqcJM6iHoT6BrfcFCh22xHFH14eqSFd9Vyyrd7CFQNtl0ujUi1T0+TWMfpalpkQY77x9nyhajdqqBnA0wxnLCkvxFkEotAOk6XHxrgs5tLRoLt1OGy5szo1Iijlyy0fG5FQkYW7L3O1Agw/mSV1UxUt2Zy5GrlwaP5HBUYv49dEKXgYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 10:50:37AM -0500, Samuel Holland wrote:
> On 2026-08-17 11:00 PM, Anshuman Khandual wrote:
> > There are no more users left for any pxd_ERROR() either in generic MM or in
> > the platform MM. Hence all these platform macros along with their generic
> > fallback could be dropped across the tree.
> > 
> > Cc: linux-alpha@vger.kernel.org
> > Cc: linux-snps-arc@lists.infradead.org
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-csky@vger.kernel.org
> > Cc: linux-hexagon@vger.kernel.org
> > Cc: loongarch@lists.linux.dev
> > Cc: linux-m68k@lists.linux-m68k.org
> > Cc: linux-mips@vger.kernel.org
> > Cc: linux-openrisc@vger.kernel.org
> > Cc: linux-parisc@vger.kernel.org
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: linux-riscv@lists.infradead.org
> > Cc: linux-s390@vger.kernel.org
> > Cc: linux-sh@vger.kernel.org
> > Cc: sparclinux@vger.kernel.org
> > Cc: linux-um@lists.infradead.org
> > Cc: linux-arch@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> > Changes in RFC V3
> > 
> > - Moved ptrval_to_str() as header in a [PATCH 1/8]
> > - Stopped using pxd_ERROR() in generic MM in [PATCH 2/8]
> > - Dropped pxd_ERRO() macros from all platforms in this patch
> > 
> >  arch/alpha/include/asm/pgtable.h               |  7 -------
> >  arch/arc/include/asm/pgtable-levels.h          | 11 -----------
> >  arch/arm/include/asm/pgtable.h                 |  7 -------
> >  arch/arm/kernel/traps.c                        | 17 -----------------
> >  arch/arm64/include/asm/pgtable.h               | 15 ---------------
> >  arch/csky/include/asm/pgtable.h                |  4 ----
> >  arch/hexagon/include/asm/pgtable.h             |  3 ---
> >  arch/loongarch/include/asm/pgtable.h           | 11 -----------
> >  arch/m68k/include/asm/mcf_pgtable.h            |  6 ------
> >  arch/m68k/include/asm/motorola_pgtable.h       |  8 --------
> >  arch/m68k/include/asm/sun3_pgtable.h           |  7 -------
> >  arch/microblaze/include/asm/pgtable.h          |  7 -------
> >  arch/mips/include/asm/pgtable-32.h             | 10 ----------
> >  arch/mips/include/asm/pgtable-64.h             | 13 -------------
> >  arch/nios2/include/asm/pgtable.h               |  7 -------
> >  arch/openrisc/include/asm/pgtable.h            |  7 -------
> >  arch/parisc/include/asm/pgtable.h              |  9 ---------
> >  arch/powerpc/include/asm/book3s/32/pgtable.h   |  2 --
> >  arch/powerpc/include/asm/book3s/64/pgtable.h   |  7 -------
> >  arch/powerpc/include/asm/nohash/32/pgtable.h   |  2 --
> >  .../powerpc/include/asm/nohash/64/pgtable-4k.h |  3 ---
> >  arch/powerpc/include/asm/nohash/64/pgtable.h   |  5 -----
> >  arch/riscv/include/asm/pgtable-64.h            |  9 ---------
> >  arch/riscv/include/asm/pgtable.h               |  4 ----
> >  arch/s390/include/asm/pgtable.h                | 11 -----------
> >  arch/sh/include/asm/pgtable-3level.h           |  3 ---
> >  arch/sh/include/asm/pgtable_32.h               |  8 --------
> >  arch/sparc/include/asm/pgtable_32.h            |  3 ---
> >  arch/sparc/include/asm/pgtable_64.h            | 10 ----------
> >  arch/um/include/asm/pgtable-2level.h           |  7 -------
> >  arch/um/include/asm/pgtable-4level.h           | 13 -------------
> >  arch/x86/include/asm/pgtable-2level.h          |  5 -----
> >  arch/x86/include/asm/pgtable-3level.h          | 11 -----------
> >  arch/x86/include/asm/pgtable_64.h              | 18 ------------------
> >  arch/xtensa/include/asm/pgtable.h              |  4 ----
> >  include/asm-generic/pgtable-nop4d.h            |  1 -
> >  include/asm-generic/pgtable-nopmd.h            |  1 -
> >  include/asm-generic/pgtable-nopud.h            |  1 -
> >  38 files changed, 277 deletions(-)
> > ...
> > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> > index 5d5756bda82e..993a6505eb8f 100644
> > --- a/arch/riscv/include/asm/pgtable.h
> > +++ b/arch/riscv/include/asm/pgtable.h
> > @@ -559,10 +559,6 @@ static inline pte_t pte_modify(pte_t pte, pgprot_t newprot)
> >  	return __pte((pte_val(pte) & _PAGE_CHG_MASK) | newprot_val);
> >  }
> >  
> > -#define pgd_ERROR(e) \
> > -	pr_err("%s:%d: bad pgd " PTE_FMT ".\n", __FILE__, __LINE__, pgd_val(e))
> 
> We can drop the PTE_FMT macro now too.

Agreed, will just fold in the following changes.

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index 709a36fb4323..b4bbae55e931 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -76,12 +76,6 @@ typedef struct page *pgtable_t;
 #define __pgd(x)       ((pgd_t) { (x) })
 #define __pgprot(x)    ((pgprot_t) { (x) })

-#ifdef CONFIG_64BIT
-#define PTE_FMT "%016lx"
-#else
-#define PTE_FMT "%08lx"
-#endif
-
 #if defined(CONFIG_64BIT) && defined(CONFIG_MMU)
 /*
  * We override this value as its generic definition uses __pa too early in

> 
> Regards,
> Samuel
> 

