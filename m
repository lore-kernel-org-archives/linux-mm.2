Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15720CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:04:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0394D6B0092; Mon, 12 Oct 2026 07:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C246B0095; Mon, 12 Oct 2026 07:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43696B0096; Mon, 12 Oct 2026 07:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C24776B0092
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:04:19 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7975EA0B58
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:04:18 +0000 (UTC)
X-FDA: 85313690196.01.361207E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B278440010
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:04:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F++r00nm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791803056;
	b=epgubXVPdli8dALhSSkJ0QSe0SmY3hpNnwWvI3iP82EPa0LOKpD5wKLhd+THQi5Mxqgzrw
	8FaaEoipH3i4z6oHVhjvGfKMd6h6qhrqVWhUgyqbRbkmEDcCG11t1mcFwK0c0M4yRhgy+6
	YdwjU7KxU9mwknXIl/XY8z21cOIahMY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F++r00nm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf17.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791803056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R17cvAYx5n+2t7QO4oy03VUEubeAV3RNvz9xwe9MG9g=;
	b=h8pk4brVxvPoXDx0lPoX4cERjyXTneq085wCLQpyHwL/4oUQXSZUiNoZO17uYtj4QQzJW/
	IyVVNYQvyO1k/XLxRy8m3EX2WEW2fYey5VqnMgo2YGHt/takR4nBdTRDg6+PAnZ6MRRY+g
	1hN6Ut4cJ3cbTb/NqswcHPNEnryvkS4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F2BB1A00;
	Mon, 12 Oct 2026 04:04:12 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 196FF3F882;
	Mon, 12 Oct 2026 04:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791803055; bh=GCUhwqR9gUHDDQkSnLEoqzzvzh0xq7rUr9tQxJpA+Tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F++r00nmSoucDHHIsuKWsEv8xVrypp0HtBNdtRJkDKmLkBuJP64zRrb/xJIShO22H
	 uzo9MhZARvb/XeMwbi4x6xH3NT4IvmY4wF11YylB9B5Dtu48YuFY4E4Wms0ChMknp5
	 vAcbnxdzzKSKleLIyoOeqv3IWqJ/z9HrDI5yVhac=
Date: Mon, 12 Oct 2026 12:04:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH V3 1/4] arm64/mm: Use pmdp_get() for PMD accesses
Message-ID: <asy-q5SBnrBQSadP@arm.com>
References: <20260924062214.1635078-1-anshuman.khandual@arm.com>
 <20260924062214.1635078-2-anshuman.khandual@arm.com>
 <asPCv5Icdm7Z9mWF@arm.com>
 <lqjq64vw6mlm27kp6ffms6auerj67avecc4ongedouumsrspjh@2f2eblm7wi4u>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lqjq64vw6mlm27kp6ffms6auerj67avecc4ongedouumsrspjh@2f2eblm7wi4u>
X-Stat-Signature: k8hbztjqhaadcfqafgmf7adxta8xxqqj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B278440010
X-HE-Tag: 1791803056-308164
X-HE-Meta: U2FsdGVkX1/b6tgSgzw63bUx/dcnA9NCA8Szy00VUs3zPVP79ewTkICb6kqleNvJUp2WbiPPXvHi7EgSqmoDCqZBAHMkrkIPcgA8M3UqL8Jv8acHaAh+0SU4xO4a3ibsgSQaKpJNLZVMs69X6bd3v2P71tjbqPgI9opO+PsuGPngelt8X1Ps7p3fxojAPl8tkPH6Fi5dWPjLBE+tyiJtBQpCA7csIyOqRIQDwkFytnG5h5C8DlSf0vWcnpC0v+gzmlVLNwMoGFFL61GWEwIn/x8oqUJd/f6YXK4EApt4il63gO9XKHJF81k2OlhyQ0Fsv2GNasxfEhVSJ4MtZ0x5MbM8t2yP0l/Zs9m6rlbJWr21EqTlxZRBrwLejpMW9C3mQ/VDK/xuaA74QbkJqM8wrn7gZM7gLvoGYT6Ujof89fylaixE5TSPeqBQ2cElbWcVUwpYhGH+46rpisB2VzOPwWQ/vgMZemdzs6+cL8HJVP3jbxAFLTroXK1TxM6iybF+1D4/6Pe5nb3g3cMW2bWbm6bpE4bOi5/60YvnstL/aK1BqIRQgOaht6GRfDeAMw66XaeFAGdmKipp4VYl2x+Rx56yqGuLh6LFY2rSx7b6v7UcPuVkaacjLwa+Ta5FMsNbdhjKnvYJMXV+S6Zd0niEmjIiicsSTJLU6l+G22IIm0Rpghku51/lBH5j34b0RpfRHlVRNEnFDF6ASbPDgMMAimZYuehVGx6NrDumyFWkJEUaTAXq6iOVSFxEgZFqRhvkQ4mmF//7q2AItuoFvSXBmcYObXJFeM/gqz+Cg1XfnQ1H29gz4+UMgbQefpwzJpiwvbF4ynj30HA+aHUpdA5YOlj80Tozx5gNbX07ITxtqI3FBPnJaid5THe4b717ptbHS3gmhcFMEYRnIxNpov276c66saQgWXlh25yRy9Fi/x5lSdM0Yz7NYEgqgDeGDZ5SFsR22WsE3S8lkXyWS9X
 3+NCEYIk
 gxqH/cwh8UUkCiQx9BvI440wBO9kYyr8v4yMC14oh5jPy/UpIgQSsajVhCzx6qr5vFGVSLxXvu0oov6xGFxJZ+e5wWrdukAgGtqIZGdMJ3qpker1CpDQwdDR0XwdfiQ9PL9biS9nqVo5Wz6wD7cfO82AP5aRhVm20ZJZnb+lFRdkJGEgDigdFi6kCUYHX+bMRnAmp6FuVxBb2gxELyI+i6EYWqyXJlKeSHo20NUTCeGv3OFfGIdBI1PfQiloKSCPiqd6mdPhtDvjh7etGUbIBFuUkYN0imh+JXpF8Ks8U6RJwI09A+PYeCukXaVyhFMllBuGUuo6Xpbx4sGBQFidLIh4UJlDD0mAYbr2IKULDY9aNa4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 07, 2026 at 08:11:52AM +0530, Anshuman Khandual wrote:
> On Mon, Oct 05, 2026 at 04:31:28PM +0100, Catalin Marinas wrote:
> > On Thu, Sep 24, 2026 at 11:52:11AM +0530, Anshuman Khandual wrote:
> > > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > > index 763c5a411d64..9ad2d03e86ad 100644
> > > --- a/arch/arm64/include/asm/pgtable.h
> > > +++ b/arch/arm64/include/asm/pgtable.h
> > > @@ -84,6 +84,12 @@ static inline void arch_leave_lazy_mmu_mode(void)
> > >  	arch_flush_lazy_mmu_mode();
> > >  }
> > >  
> > > +#define pmdp_get pmdp_get
> > > +static inline pmd_t pmdp_get(pmd_t *pmdp)
> > > +{
> > > +	return READ_ONCE(*pmdp);
> > > +}
> > 
> > This is the same as the generic version. Does it need redefining?
> 
> Without this pmdp_get() override, replacing READ_ONCE() in pmdp_test_and_clear_young()
> with pmdp_get() causes a build failure as pmpd_get() which is defined in the generic
> pgtable header is not visible from inside platform specific pgtable header, even with
> a forward declaration.
> 
> Earlier had moved pmdp_test_and_clear_young() inside arch/arm64/mm/mmu.c to avoid the
> above described dependency problem. But then realised that pmdp_get() gets eventually
> overridden on arm64 platform for D128, why not just redefine here it now as standard
> READ_ONCE() to avoid the current build problem and the code movement.
> 
> Please find some context here from earlier discussions during V2.
> 
> https://lore.kernel.org/all/212067fe-1b16-4b87-87a7-4ce50847eb24@arm.com/

Thanks for link summary of the past discussion. I agree, for D128 we'll
have to define our p*d_get() but I haven't decided D128 is worth merging
yet (it depends on future hardware availability, I need to get more
visibility into this).

For the time being, I'd keep the p*d_get() accessors generic and move
pmdp_test_and_clear_young() to mmu.c.

> > >  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > >  #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
> > >  
> > > @@ -811,7 +817,8 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
> > >  }
> > >  
> > >  /* Find an entry in the third-level page table. */
> > > -#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
> > > +#define pte_offset_phys(dir, addr)	(pmd_page_paddr(pmdp_get(dir)) + \
> > > +					 pte_index(addr) * sizeof(pte_t))
> > 
> > Why not make this change in the generic version?
> 
> Could you please elaborate on this ? pte_offset_phys() is arm64 specific helper which
> is also local to this header file. AFAICT there is no generic version for this helper.

You are right, I got confused.

Anyway, I'd push this series post -rc1. It depends on the mm tree and
it's getting pretty close to the merging window.

-- 
Catalin

