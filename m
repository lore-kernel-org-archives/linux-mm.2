Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E289C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 12:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 916636B008C; Wed, 23 Sep 2026 08:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7336B0093; Wed, 23 Sep 2026 08:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AF06B008C; Wed, 23 Sep 2026 08:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5876B6B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:12:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB244C0768
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:12:06 +0000 (UTC)
X-FDA: 85244913852.23.0ED12A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id EBE6BC0005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 12:12:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WfbrlIJc;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790165525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lp3GpBA3Y7sFKEN6GNg6Oh9HFoOvWd8VUghdJIukW0=;
	b=nHOS8i7Ey0jP46e12wDFdAGXvmrss7fFi7YzmHsSfyuLEYlYoCYpLvq14pi0Ogydy0whvr
	Fuq6z3Rh78V8ru9nkvH+jC7/no8v2Y59a6jqwROQ/yJEbfxfgbnOMcI851XmVotw4t6+ib
	OmN+1xlSp0c0Dt/0H/JLVBzxrUPJfcw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WfbrlIJc;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790165525;
	b=QiBn5XHEgCK7I5drNx7Ni1PlATFyBXM2KssLBa+r29qvP1tmCpBPSS+Dbey41X9afc2tCI
	NB2SYvEZ5r5cg4WF2UHBrKfkgxg/dHI6dRKTnipkeSI9bVepuA++z8H/hWijf/ZS4rv1Ur
	owcnu48ri70goGqCjMRV3hFJkIvsDOc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 782041570;
	Wed, 23 Sep 2026 05:12:00 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 44B4E3F86C;
	Wed, 23 Sep 2026 05:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790165524; bh=xi8NIofPhpB3H7iilBZyGWD0DeG69Ptc46KK7MjGIYc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WfbrlIJc6PIRO3QJdGN02l6yILN8LZNb5gXKSL0optlm3pfpEn+tM3q/hDkuH2wlp
	 b7m0xt9GrefxYQL48XX0paq0rO+hkAkx9VGwwoGQs06sTvHhKkn6+2nLuuHUhWCUuO
	 poloeD0oI3YcPeBHHqLRi6Bgs2yqbLb4hXKdEUic=
Date: Wed, 23 Sep 2026 17:42:00 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Helge Deller <deller@gmx.de>, loongarch@lists.linux.dev, 
	linux-s390@vger.kernel.org, linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] s390/mm: Drop all pxdp_get()
Message-ID: <echvqvjj435meeh6gcrqewysdqbtkrsgayvsyfcr3q6h3bh7fn@hsa7xh22l4rj>
References: <20260923043226.331880-1-anshuman.khandual@arm.com>
 <20260923043226.331880-2-anshuman.khandual@arm.com>
 <20260923091629.9636A36-hca@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923091629.9636A36-hca@linux.ibm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EBE6BC0005
X-Stat-Signature: bmm3ujmtkj4y3e1685cn31qw9tw6rt7b
X-Rspam-User: 
X-HE-Tag: 1790165524-855846
X-HE-Meta: U2FsdGVkX19EKl9h+maas9cSHutfzWShit5asJpZsG8708hKbkY4+rd0ZC++9JCEuj79N3dI3jZRyfYveUKRcP7qY8oaIR90ltcfPkYTYd/H3/Bq5lZfdCg0aHXNM7wUr8jge4q6tScBypb/niV74EG5mt3V/eyeFlqH0MmxaSWit1YWZkplH+lXLHvzwxcP/gVF9Uax2UKL6FXVsx/MBMxvMunul2pkvr7MNX1ByH/AwclwmogUGRAVIDuDXaySNHXckHYy3e3W0/XXW/NSY+4fOOIKH9dmm4qMHgdFLnWUQ/0uX4PWOSkYWpNaTlnQEAUH7VgmWV/IyLVCaGqbvS7r1qntFf0MyFYHhPcOJK1dH0px0fhd04voUS+1gDJlWU7I8+m0SiFjqxOzGg2vI5OYcvWV7H9HcsaTcVHuycDwd9TQAhdM7vXS1D7gniw+FFngcjfpgjFpGp9PIbaIP9AyBl/45ZLphjjiUq792O+9U1JSpNjE0Z+iqb/y58ri3taZvIWeBAgItUa/MU2HltdXsZg7YP+p/4OiLQQNi0HRoT84n/V2epiZ7aBWqFSw3/+c2PAyvVc5tkLvITgOd0dSSwbTjYgc9THmC3plPylJIsKYnpeUiyNLXVZbaI1IYFE3EMZXtSp0OyYaN/a+Y1z/Xs//68PlLNSuo4X2N4YhVMI6JXi7JpsHOm/td17ppMSGyeHCi/a5yaw3yxW+qJHVOxQ8eZAaYSl/ZQYBcoYClcOYfyE5ls8r96FCb9lP+MeGZt64FdTTANFDiGwzR/ZcWpcL3CfY07PDQjslzDN6L4qBDsYcX7VfDygQbha/mAw7U3pVMvsm93audPYl/5MD4bsULctm/Gpf0HhmplRGu/RDYZ1iTGkp4C5RFej7pRkxweZVN9y2Mbd8MbZR7y/ULIZrJijuzcPPD2cNIGOnVvcVRd+DzLA6nE1qQFcj/H3Xb7Ti/8a6xVq1qiF
 U3LA/opN
 +Dv6I7kkuSjtzBMiHBiZfKjjGiTjJurSezE1THQAQO5sus86mVFv3eBMVVt9Jryc3lRI5/X/MNEOwxTjATApBquqvqPRD5AjAkwmnsOaH2YiKD6GFHgZ/MzQbPm0En5HlyBoD+ipFZ5AKGdirNR6VLmprmieY4AYLctmT5BDNga03HniU2ao6nOe4G6bLlqxb7U6kCLf8vl1jSYgqcK/ZD/N4BxN53jJZf9myVNpzuuMC/JqGcZQ8I5/9505wUloq2so/vnwbyaD8lX0dnPe6Fap27djOxA4KtUb6AcQOSGM9xmdVcZbhSdT8xfqBi8KGomMneq8uGCRQB+awNbJ4wQf+HvXtX6DVSJXWk++BATxVN2wkNIOr+SPo+laNpygCfIC+B/Q8vhiCwECmK3wsWazL6+rjAiv4nlARAA/3uP3+VJc0DyqiuTLcsmS7u/7zMw3Lv7vcBk6/MS4nTRzhQapFjUfokBNk0IpxvN1pGSAaUog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 11:16:29AM +0200, Heiko Carstens wrote:
> On Wed, Sep 23, 2026 at 10:02:20AM +0530, Anshuman Khandual wrote:
> > Current platform specific pxdp_get() helpers are exact same as the default
> > ones defined in the generic MM header (include/linux/pgtable.h) thus making
> > them redundant. Just add required forward declarations.
> > 
> > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
> > Cc: linux-s390@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/s390/include/asm/pgtable.h | 35 +++++----------------------------
> >  1 file changed, 5 insertions(+), 30 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> > index e882663a58e77..0a0b0ec42b624 100644
> > --- a/arch/s390/include/asm/pgtable.h
> > +++ b/arch/s390/include/asm/pgtable.h
> > @@ -25,6 +25,11 @@
> >  #include <asm/page.h>
> >  #include <asm/uv.h>
> >  
> > +static inline pte_t ptep_get(const pte_t *ptep);
> > +static inline pud_t pudp_get(const pud_t *pudp);
> > +static inline p4d_t p4dp_get(const p4d_t *p4dp);
> > +static inline pgd_t pgdp_get(const pgd_t *pgdp);
> > +
> >  extern pgd_t swapper_pg_dir[];
> >  extern pgd_t invalid_pg_dir[];
> >  extern void paging_init(void);
> > @@ -985,36 +990,6 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
> >  	WRITE_ONCE(*ptep, pte);
> >  }
> >  
> > -#define ptep_get ptep_get
> > -static inline pte_t ptep_get(pte_t *ptep)
> > -{
> > -	return READ_ONCE(*ptep);
> > -}
> 
> As reported by Sashiko, this results in a compile error due to conflicting
> types; but I don't see too much value with this patch if a forward declaration
> of the common code implementation needs to be added instead. Looks like s390
> would be the only architecture which would have that.

We could move pxdp_get() caller functions from this header inside C files
like other platform changes proposed here. Would that be better instead ?

> 
> Besides that the s390 implementation of ptep_get() will be filled with
> more content "soon", when Alexander's lazy mmu work will be merged.

Hmm, okay. I don't have strong opinion either way.

