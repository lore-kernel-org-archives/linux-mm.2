Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2FE2C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 05:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04BD66B03AF; Thu, 13 Aug 2026 01:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17946B03B2; Thu, 13 Aug 2026 01:44:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C4F6B03B3; Thu, 13 Aug 2026 01:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1D886B03AF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:44:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3C81CA2AB9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:54 +0000 (UTC)
X-FDA: 85095157308.16.D63952C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 66855C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 05:44:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=anxqrjk0;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786599892;
	b=V0cGrEKKVNOU+7dKngsGdiHl0342iGIQlZqDhl8TF6TZrk8DwSzre4GleLJgV93CfvR7bn
	XNOM1M7Px8TPzTAiBKNmHu6Co4sQgdjJpoVEvGLDzT+G3aYfEadKuxFx4/0JRyaYOJ/evv
	zg40PWG0PbAMmRZ3tEir1ZKgeHa0YP8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=anxqrjk0;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786599892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZARLK//mxzBm5+oVQwAyaOB1/sFHwMbhqQJ5pXDXaA=;
	b=0t8ju3C3Fb2nWkXUa4cmBGGpwJSJP7R9oHf70208JStKH6QltCldSfL1TB5za5aX9wUdOM
	syG/kAno5dHnQllUFefJWPMQFxlDYNkFRy5gEQA65PI+Akz7Fi9M8OeLjRu2REyaB9FX3W
	9Y2s+hD0n0OuXK+/T5+RS3bXRLJwc7w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 708381516;
	Wed, 12 Aug 2026 22:44:47 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A22393F673;
	Wed, 12 Aug 2026 22:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786599891; bh=CoIN6guADWC+zDyPfhFO/S+t2cXcLfG3khdmtOUCkug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=anxqrjk0iLjQHV3BgBtB7FofiyVfbzxU/TOQyrqfHVrE3KY34mv1wfvSAdfZk8k+b
	 NqfdwWG4Em+MP9I5C6wmSIbC3ZhVt828UvY5voXcU42QX/ayulcSospBc/5SlZ/BEt
	 dTzsVhGl1W0qDqm43doqgOf533QinHxqjz/j8G+o=
Date: Thu, 13 Aug 2026 11:14:48 +0530
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
Subject: Re: [RFC V2 4/6] sh/mm: Stop using [p4d|pud|pmd]_ERROR()
Message-ID: <3bruvrvxg5blgzuhqg2f27yvfjvvsycx6lmt3jcianvpuqcs5n@zdgzfhmmhvom>
References: <20260811042119.3652929-1-anshuman.khandual@arm.com>
 <20260811042119.3652929-5-anshuman.khandual@arm.com>
 <94b52871-9cfc-42d6-b30f-545b722e71a0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94b52871-9cfc-42d6-b30f-545b722e71a0@kernel.org>
X-Rspamd-Queue-Id: 66855C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 6fwwc6dys8mkyx1rob67ihw1y9jyq8gf
X-HE-Tag: 1786599892-388314
X-HE-Meta: U2FsdGVkX1+gffwQDWY7FkOXwmVjmrQUAcHEO+JyddTwfdZA79FzMGXaqiKBKTtypzlppnOR/Oy/P6kEfFZNWT7bE08kS3EuFLv0tP9fU+4gh18ZHuvEL1Kl/7B+l4fejp+cXIYkCGNsyExtwN5wlLsaFxyrdXPNLqqIP4fqG/c6dCtncgPbXOrXrK26bSar1HR8vLInyr/HbgvjOODpfSE9elqzMoJOBay7mqxydBvdf/CN92eDp8FEF1Y1AXOFXcs3SP7nNDwuy4uUZb3qGcopDVLOvfdiil6v16E8SfraxjG2E09eg4wTeGfFVmqsVOAILCr0D8LInFQctreFll81VOtDrDYHYkNfItTbEaf5efL89osYdqJJ+eV0r35wPzvjaU6YfQd6ySBkLJDPoc52PoiFXF3aFSOADp2Ge4m21XrArT5JT46WyVBXWbJReq+9OoWoH1zsJvtrGaddjIkByfLCSy/oyN1Tp9Nqt8b1Lp6UEurGtqgSkZV9TY46qwk/jvdrLIvsp4l3aBQWyV8aU9pFSp1xgOEu4JDUkShm2abrv25liW0a+I/iKM6biwIko7PBAfhDlbZRKWULXk9d9LAUPiRKfEHI/7V0C4LvEUekNxAna4IiQq07PF4q9p25GKZUkHbhYv85kFSQoXU7KhWi0aP5GY71Ev0uF9oAs0XXTCM1jbst6/fLI7APr0uaGUDXlOg779kOilG6Hgf50+OLYd2wFkfU1AQqmbkNwiVkQrRiJKh7PriA6Tem7OFAcZWrDkFSDYD/O/Pzo4p3Y/2tB3+9T+8A40wuggPiHkNyFI+avGCESwcM8u5F1Zpj8H7xp8hRiHBbC3gvUWR6ugAZuRndA/beHZw3T9fIhpX3IIs7wZItHasPkbAk1DyMToe3VlqF9thZhEDW6vxzxIFNayIrqkJO56DGjK5wikmmF8cMhPSE0/TlPbbHnrkqYs6zBDRvfHjFaAk
 e2wLczIh
 0RuQqhuk4XJTLpt4ZW7YYn6KhDqVDytYBoIAbjBCaagabx61uUMCXtfNBpMNI5VtU1tQh1Rt9WmmcqL+7dKDuVk1S1e6sCowZAfY7Eob9XYgf/UsXSnHNO3GN8no4b8gqfGckCfvYQ3ZZJhkRAkHYdfjdNOYX23tG904pY9UyF2KvzdL8+HppIuixhK7Ah30f5s7ElojJ+8P8ZArbwPtzqNowM7HDPJ9/oRCi7AOCBWUXG9AI51mvSn1oTz+JdC6SJweSLGCm82UidbRoQJIf/eB18LIS7y20A4Q72ee+x9JDaP7BlntGXlT7CUxRJczpWeEpVXWhsNvFXFotQnqRzxJJcPzI188x6SARcr6/6/qu8APdUcha22Dz/RhNfks+BOFNVdm1tYFF+Q4tgSUinUC00rhO+z0tHSsEU9Eo4DryyXudydq9k2790Q1+wg5ymR+tu3QfoMziUGd3Eqqzd65CSnPfQBNor+cfwqv4/59TPDNfsaopVebRQ6v2nSw2rWmauF6zsGhgBfsYlNq17mf8PVdy2N125vZy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 01:21:28PM +0200, David Hildenbrand (Arm) wrote:
> On 8/11/26 06:21, Anshuman Khandual wrote:
> > Stop using [p4d|pud|pmd]_ERROR() in __get_pte_phys() as the pgtable entries
> > are known to be NULL and hence could not really be accessed.
> > 
> > Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> > Cc: Rich Felker <dalias@libc.org>
> > Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
> > Cc: linux-sh@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/sh/mm/init.c | 12 +++---------
> >  1 file changed, 3 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/sh/mm/init.c b/arch/sh/mm/init.c
> > index b3c7fd84ceb4..0bb8555568a4 100644
> > --- a/arch/sh/mm/init.c
> > +++ b/arch/sh/mm/init.c
> > @@ -58,22 +58,16 @@ static pte_t *__get_pte_phys(unsigned long addr)
> >  	}
> >  
> >  	p4d = p4d_alloc(NULL, pgd, addr);
> > -	if (unlikely(!p4d)) {
> > -		p4d_ERROR(*p4d);
> > +	if (unlikely(!p4d))
> >  		return NULL;
> > -	}
> >  
> >  	pud = pud_alloc(NULL, p4d, addr);
> > -	if (unlikely(!pud)) {
> > -		pud_ERROR(*pud);
> > +	if (unlikely(!pud))
> >  		return NULL;
> > -	}
> >  
> >  	pmd = pmd_alloc(NULL, pud, addr);
> > -	if (unlikely(!pmd)) {
> > -		pmd_ERROR(*pmd);
> > +	if (unlikely(!pmd))
> >  		return NULL;
> > -	}
> >  
> >  	return pte_offset_kernel(pmd, addr);
> >  }
> 
> Do we want to print an error like "allocating p4d table failed"?

Sure, will add error prints like the following.

--- a/arch/sh/mm/init.c
+++ b/arch/sh/mm/init.c
@@ -56,16 +56,22 @@ static pte_t *__get_pte_phys(unsigned long addr)
                return NULL;

        p4d = p4d_alloc(NULL, pgd, addr);
-       if (unlikely(!p4d))
+       if (unlikely(!p4d)) {
+               pr_err("allocating p4d table failed\n");
                return NULL;
+       }

        pud = pud_alloc(NULL, p4d, addr);
-       if (unlikely(!pud))
+       if (unlikely(!pud)) {
+               pr_err("allocating pud table failed\n");
                return NULL;
+       }

        pmd = pmd_alloc(NULL, pud, addr);
-       if (unlikely(!pmd))
+       if (unlikely(!pmd)) {
+               pr_err("allocating pmd table failed\n");
                return NULL;
+       }

        return pte_offset_kernel(pmd, addr);
 }

> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> -- 
> Cheers,
> 
> David

