Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A6EC5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 04:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5CE96B01A4; Thu, 13 Aug 2026 00:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34246B01A6; Thu, 13 Aug 2026 00:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94A686B01A7; Thu, 13 Aug 2026 00:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B52B6B01A4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:34:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D800BA2105
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:34:21 +0000 (UTC)
X-FDA: 85094979522.08.A45F4EC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id D1765180003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 04:34:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ucFab0TP;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786595660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kny2Ta5Q0Z/mhUSVYxPhv0RFXJl0+qly565KZ2ki+8o=;
	b=yL7M95qOPzNMfDus2vm5sBY1qWvQo2zR4J/m9MkKKpk81/ZpC/jLusuQEadzhCDokiwQ+g
	UKYZ8HpZ0zFN94CJihHvhlhViKJacbirGZ7KVzprYWiMGnLdUez9V0h9WN9qnHd7A5zsoo
	NzJ9ploigzJh6KeOD0izktM87V9HVsY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ucFab0TP;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786595660;
	b=In7yOU7WbCMTW+0anrncjhC/tJKksWa2tCbptPxjwncUL4DlX902y7hnmZ88Fcl9bYgvfW
	OLqdo3+n15R3DiY6UmGyqXyGO3GCZrgaapsfqCFvpJdUXgB1sTrmcxWUb44WvplQSyh8W2
	GVvggvJFjmy2BNdFe3FnnfjGQMl1/I4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B8A551596;
	Wed, 12 Aug 2026 21:34:14 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E593D3F632;
	Wed, 12 Aug 2026 21:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786595658; bh=mO6mrRKNqP+ykHI/mGROppdDnXxIwgWT7LgXJj+JezI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ucFab0TPnxvbqz3KEVyBy+XPNcRzGlpGCroO3Eciy3LZ0+X/OxqSrfgUvooo+EVnM
	 CkkbCWk5eaKn4RSc34lEp7tZQ4pnzvhzXI1BWphp8/e5uuWc6hv5uSnA/KhXLfZVFZ
	 sIXAXG2CvPJZ7I27QA35Hy/JfVFzGZIK3afmsQfQ=
Date: Thu, 13 Aug 2026 10:04:15 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org, 
	linux-arm-kernel@lists.infradead.org, linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
	linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, 
	sparclinux@vger.kernel.org, linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC V2 1/6] loongarch/mm: Stop using pte_ERROR()
Message-ID: <qymuy4grl654s6jwwyhlwwo6kfr3ongxpfnxifojkvism2ddwg@5lyq7iooel6b>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-2-anshuman.khandual@arm.com>
 <e0ada89f-26b2-4e82-8273-8ea7b391c147@kernel.org>
 <9a66d741-536e-44ac-b02f-395b5fc8ab6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a66d741-536e-44ac-b02f-395b5fc8ab6d@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D1765180003
X-Stat-Signature: cbibbg5xb5piwrakhmgm9ifnet9914a5
X-Rspam-User: 
X-HE-Tag: 1786595659-66728
X-HE-Meta: U2FsdGVkX1/fiZdwbXFuW9wlVpIagqMLXUU7e7PtQ6KzTGCH68AcubcFaCGbXwmOcVAYoTLQbAQtWIi92lCkt9zGCz/6To/bC34zjkloLzF7U+YIgvvjn6+9T4fEf9DjJA3xQssNyKT0K4UEFiPBsVOfDKjuRBvDxj2sx8HGz3tCFDgSH+hdHVpAqDo9bNJof2MqNPS4gDhzGJWsHXhsvTTu8Fb7/qne8b6gStUDujC+UoqGeGe3dUEknRWyjDBstdPUALTXZKI/Z1jlTE3vRq4ZR1g1orXM513C8weWHN1w5upYYeDfSjCnEHFMivujIJltShuVtjGp5X35CQsA9YWlrnsnQ9OeYc55vabnFa+ZKFmNsUZlsWuTfMz1FIivBD0tp/itFG17EawNqDHE+Z3K66DYO4jY8oeK9sX1pdsJlJgbzzSNtbtF3gVzQElybHXK4/tiZSuOXJDdd/irUvtRAxB4VTJCw6QNPZYk051sBWrHIu+e+65ToEWEEKK7ctfbhMJ2HE4iPXNJFqX4zisS3K/fOEyGxFZpELH2kR94oQMPTQZCmclH+FElqeV4wucEEEGL7payYZrv1SWHYvoxHZi7ac50Hy0Mxkg33KXgI6edlMr1cHV/Dd5gZ9RPUZQ6SrCnXS0uhF/qepl2jgDVaPhnfK9JbgtU+tqXTOdJF5kxA4vnGH+nMrBUY3GA+GwjsK7IZaXjLLPkjkIIMbpdvcSfYXHS9TezOZWWcMRezBy2DSqqYg3HqW0Jjkj0UrGFxODIX9YUf9r2UWNOJFi5DyZQDJJaNRXiIaKbNRULltA27/o/ZB9Yqvvzw/b3dyCZQkPZZXacvE0B2wP9ksJRsaJeULNIW8gg+IqzCnZJGphNPtAsos5KWKvWWj3XKZjh4ZNZiFhAA7G6ecLcEgEnJUrV7FBu+0ONX6Beo9y9dK5W6JoY6eV5k3qjLdWZ1HUaGlr9dXQ8RxVath0
 s5J9wwyS
 933RpcXgKt/jiEjoyePE0oPDjOfnjbDyXi6A4ifkO5MyDZUctmGtoLtVsKlpCi4pY2yj/mM1oFnvxVH/qlkkCygyt+5HuTAAVj8TRU6YpCRfT51MWZ+TcibIgyMCo6XGorVEXrYzvvRiNXzVQultGhjG2oFOvyJuKoPdbds8lndPFqhSN4VgOXl/jGzXLlc4wUjhhGMhmx+G9FY8KJDIZJYTCW8vcqIdD37XPVMjb59BOxANP2I5c9/Rh20iLkbxRRa3yEl/0dwvw4HGO0GlWdqu+MlcdXzOGPddybz54zlSnTDdRm5lZql5byTKfqSzHc4M9HLsKekAy3hsAmWe/dC+mCWeS9cuKA675zrVJbp++iRY5TSAq6B8ISl9hwgfT2xo5IfnNpwAGxPPNWsCSjyCKxPW5Yf5EDAj55eQs4RqYVyCK+za2mLBaZKmZJpoBSZnM/vBJf3NropF/U0Vop5GTJnGdw1BAn1uPth0ER4Z2nmY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:27:54PM +0200, David Hildenbrand (Arm) wrote:
> On 8/12/26 13:19, David Hildenbrand (Arm) wrote:
> > On 8/11/26 06:21, Anshuman Khandual wrote:
> >> Directly use pr_err() in __set_fixmap() and drop pte_ERROR() which helps in
> >> eventually dropping pte_ERROR() macro across the tree. In this new printing
> >> __FILE__ and __LINE__ has been dropped because they are always the same and
> >> don't really add any value.
> >>
> >> Cc: Huacai Chen <chenhuacai@kernel.org>
> >> Cc: WANG Xuerui <kernel@xen0n.name>
> >> Cc: loongarch@lists.linux.dev
> >> Cc: linux-kernel@vger.kernel.org
> >> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> >> ---
> >>  arch/loongarch/include/asm/pgtable.h | 2 --
> >>  arch/loongarch/mm/init.c             | 2 +-
> >>  2 files changed, 1 insertion(+), 3 deletions(-)
> >>
> >> diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
> >> index 223528c04d73..a32a8fff70c1 100644
> >> --- a/arch/loongarch/include/asm/pgtable.h
> >> +++ b/arch/loongarch/include/asm/pgtable.h
> >> @@ -128,8 +128,6 @@ struct vm_area_struct;
> >>  #define ptep_get(ptep) READ_ONCE(*(ptep))
> >>  #define pmdp_get(pmdp) READ_ONCE(*(pmdp))
> >>  
> >> -#define pte_ERROR(e) \
> >> -	pr_err("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
> >>  #ifndef __PAGETABLE_PMD_FOLDED
> >>  #define pmd_ERROR(e) \
> >>  	pr_err("%s:%d: bad pmd %016lx.\n", __FILE__, __LINE__, pmd_val(e))
> >> diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
> >> index 3407030f3e7a..be9b127daef2 100644
> >> --- a/arch/loongarch/mm/init.c
> >> +++ b/arch/loongarch/mm/init.c
> >> @@ -203,7 +203,7 @@ void __init __set_fixmap(enum fixed_addresses idx,
> >>  
> >>  	ptep = populate_kernel_pte(addr);
> >>  	if (!pte_none(ptep_get(ptep))) {
> >> -		pte_ERROR(*ptep);
> >> +		pr_err("bad pte %016lx\n", pte_val(*ptep));
> >>  		return;
> >>  	}
> >>  
> > 
> > Ah, I missed that we want to print actual values, I somehow thought that we
> > would be printing pte_none() ...
> > 
> > Maybe we should just be more verbose while at it?

Initially thought that these new prints should be right close to the
original via pxd_ERROR() but I guess making them verbose while doing
the replacements should be indeed acceptable.

> > 
> > pr_err("unexpected set PTE at %ul in __set_fixmap: %016lx\n",
> >        addr, pte_val(*ptep));
> > 
> 
> On second thought, why not simply use ptval_to_str() here as well?

Sure will do the required changes - the following builds successfully.

--- a/arch/loongarch/mm/init.c
+++ b/arch/loongarch/mm/init.c
@@ -197,13 +197,15 @@ void __init __set_fixmap(enum fixed_addresses idx,
                               phys_addr_t phys, pgprot_t flags)
 {
        unsigned long addr = __fix_to_virt(idx);
+       char str[PTVAL_STR_MAX];
        pte_t *ptep;

        BUG_ON(idx <= FIX_HOLE || idx >= __end_of_fixed_addresses);

        ptep = populate_kernel_pte(addr);
        if (!pte_none(ptep_get(ptep))) {
-               pr_err("bad pte %016lx\n", pte_val(*ptep));
+               ptval_to_str(str, pte_val(*ptep));
+               pr_err("unexpected set PTE at %lx in __set_fixmap: %s\n", addr, str);
                return;
        }

> 
> -- 
> Cheers,
> 
> David

