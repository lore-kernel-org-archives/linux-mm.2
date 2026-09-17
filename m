Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1A0C982D0
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726316B008C; Thu, 17 Sep 2026 01:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FFE06B0098; Thu, 17 Sep 2026 01:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63B7A6B009D; Thu, 17 Sep 2026 01:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4014F6B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:44:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D25CF1401D4
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:26:15 +0000 (UTC)
X-FDA: 85221967110.12.FBE5D4A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3529620002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:26:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LYojUdTg;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789619174;
	b=i+xgbZA24gGlM4UFgeTErn1xoJwNsmNJe0kIDBgRuRYB4NxiPcXz2PYHw8awkXICS+cLNl
	ezJwm6KXNhVtMmXDdoQgIrg+Yhi2puf3nMFLZEeJ8syLRF5fsgtuizpNMRcuaYB7eLRzLA
	OwMxfzszJxoOxk/qYC5D5kTfJO0yAnI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LYojUdTg;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789619174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/TSlRmA9IxlgW+MUHKGWkJT1WvuwQwh9/IuOpZ/lzHA=;
	b=8QHOyQdL8Ciih8QC20+owRaeeHfUZfA3ADnEhCsNMSvnZ2nNVtqr3W7cMcGtufVLsTZHwY
	OpsDMVPAlj/DIvu6IvTNHYDdo2+58SgJeKjMo8WmOsyOGz899i6t6xZ7giWxS8I89q6qqE
	CwArJrTmc+wsO0rN9ITtGe/7210SnFY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A1E361476;
	Wed, 16 Sep 2026 21:26:09 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 713783F882;
	Wed, 16 Sep 2026 21:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789619173; bh=EgXTNuPyQIL5qR2/Uw/QQJ0weEFCg16n/wsDo/uqsqw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LYojUdTgIB2UPdkBV85+uIudRJGbmFduw8RmczXhFdRRGnBzUEGmqZPPxq8lAzPMQ
	 UlnzPf852DScCiQ9xzX6ugLDLyZlTF3Vrvc7mgae38oSyuBdnMzK8ZOvPcUS5ue7U2
	 Nyc2E8MlEPVadDDIUDzOmU/1qSSPUItaMJjfZaCM=
Date: Thu, 17 Sep 2026 09:56:09 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V2 02/14] arm64/mm: Route all pgtable reads via
 ptval_get()
Message-ID: <yjqldpl7il6uqfoqrszaopchqthhlffssprmlqjkljvpkbpwkt@zetb5hyvllsl>
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-3-anshuman.khandual@arm.com>
 <05a7ac7a-b7bb-4f75-a395-6854874fb8c7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05a7ac7a-b7bb-4f75-a395-6854874fb8c7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3529620002
X-Stat-Signature: epw9fwisxdfe6qgup4d5tmzzw75objtx
X-HE-Tag: 1789619174-826595
X-HE-Meta: U2FsdGVkX1/JXN6ezQWLSFyQp1s5+RG1PiFKMAqE9qSWNlG7xTbhCUXq04sh8ANfrZRCjRbi4pOHufe02EvGfJdLtZHYy6tWUaX4LqV3Jn+8Ty0wQ+qlLrHjde57Zw/ktn/oPnEmnXptv4Vz9IZZX4SPSpsikiKZ0MVGpj4jYXujYWAbmZyJwuSCu4ZLehQ2hu+0IB4n54dzITTdjdsGDUx9UsGZVM3038HYw0lRMkYAw8pMPXaTYFUKmxjhjCKkmvB9ghOVVlkEho+2qgWylHlUwwlZB7kabdDRs7VtPenr5Gmro8MYenJk+CV/AWkzCDykzaQm1FgGFEpTzg4MgxhT9dw2AAYJGi2wl+S1syQM8wYk1rUb+5ys1ZE6RIQlo6o4wmw/z19SFCUpXzTwFShFs1JV0x/lKJTKXAGnVlBvQjYO2I4LTWJ2st4avfwab7G2SjFarGbP1IhjydVoPBsHHmzKAvlBiwLG+DzeNlYVzkbdzc+tV1n0QeNWTXbXAFBANid+cjrE4GWizRCP/O1Np9VHfEqNnhkQgD9i+i00ilvAG8MGpR+H+SKdxOJdj6cgj/LkJgLwunX9jbuMcsgAJbQ1Mlywb4B3Q6xfRki3l+WGdOW1f6pNXHHRhodFcgrDzRB7j/9o8P+aKCvL72u3QiAVP/IHjuX9ZGdtiipRMm1WG73AWvCABSPxVE4xXQzm7KlSN/VjVarzAjdjLGxJFTDPNF9GzkbiyACsT7/X/bK44TvpUS6+b8fSevHfEYCU4T7ZKDIdNet3VHGZVtdmLWeJE5ukfBOeXBuclPi7CfPHzn31BEYo1Qa7pygQ5+NKgWKtaJKDNibvrVXFyeg/qzAhhymVaZRhNa2kC8PmODipjOMJ47y5xPZ2QOUQivoXUSwOhwOPSmhU0UBTZI2IKDMfL5ZbG3ZHaS0be45HEnKPHW8rfsem4JGP7fhZ21mWE/SZqVLG9u2pa/Z
 rLp4ra1x
 3LNZkN8YO0jxK34+kvJIZDYxooyp7mx9edd8GfFZgZCxCwBMHFkF3itg7C8eUkVD43BIoiaqi+oxRPj0H7FaduSCSwMtOjsDk/CUcB4PPg9KINmQOYNDFtDW2z5nspeVI75cwka0DhB1QFmPOfagigWzjcgun7G5x/8p4Y/Wwbf+lMuG3YpBEX8uCj/Lq1gn4Mv8gxxEjCZNLX0oYoJ0ROEO/wRK/fcTmj5ZwpLv30leRfCBalh51NmYGSWx2+b27gRvCuGjxM3kMslarmZ84SqIKGdjbU/9C1cJLodIMf01QsAdvVLWcgP0dKp0CeA793LmyyUUKEeETkw7BaQ7XiDCE6zlffdhxLRte0Ew+HAUCiWY/7iTo5kOVJbZYv/jLkv7VVfZP87GAW0REh1kOF4hXhPxpRuizXW2mGN+krHAmmBgEBtlAvNM+koPNqMR7A4zIjAdj22ziNvevtT8G3kaZeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 03:38:13PM +0200, David Hildenbrand (Arm) wrote:
> On 9/7/26 05:50, Anshuman Khandual wrote:
> > Define arm64 platform specific implementations for new pxdp_get() helpers.
> > These resolve into READ_ONCE(), thus ensuring required single copy atomic
> > semantics for the page table entry reads.
> > 
> > In future this infrastructure can be used for D128 to maintain single copy
> > atomicity semantics with inline asm blocks.
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > ---
> >  arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
> >  1 file changed, 32 insertions(+), 6 deletions(-)
> > 
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> > index 83087b70f192..f764132ca34e 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
> >  	arch_flush_lazy_mmu_mode();
> >  }
> >  
> > +#define ptval_get(x)		READ_ONCE(x)
> > +
> > +#define pmdp_get pmdp_get
> > +static inline pmd_t pmdp_get(pmd_t *pmdp)
> > +{
> > +	return ptval_get(*pmdp);
> > +}
> Ah, one thing: you could pass a const pointer to all these read helpers.

Sure but first will have to change their defaults in include/linux/pgtable.h

> 
> -- 
> Cheers,
> 
> David

