Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE8A1606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 04:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=WvdJsXl6
Received: by kanga.kvack.org (Postfix)
	id 08FC16B08E9; Tue, 24 Nov 2026 23:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F8A6B08EA; Tue, 24 Nov 2026 23:35:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98EC6B08EB; Tue, 24 Nov 2026 23:35:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C33DA6B08E9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 23:35:59 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E0B9140C87
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:35:59 +0000 (UTC)
X-FDA: 85472378838.13.90E2A2A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F663A0005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:35:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WvdJsXl6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795581357;
	b=e4K/tWBbYQOafRMZpuWlIJoZIZfh00DPBHmgRYm/Bn9Zaf7erFwqv7BuTy99UNIYZycWiN
	K1FjHj7KyeUBe/2zU/B1JuX6utcoQ1DNvpi/ai5OptNyOBdIIkswe0ItunXViJ/bBtSuX3
	cgcB7N203uSlTHILryAJkZVhdd9eA3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795581357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jES9287MH9jWQ+5Q+HNtKHVTJlglstu0zwzo0JLxghQ=;
	b=xNhuBAqtS0fPV5O+Q3TpSI5mON0cw6sV5EVCZZ+yMFl++HixPm00sHPE+IokfGi7AaVCZM
	wJpr5j96jMfJrO/egtFBBUfU9grwK7njh+2KQLzzrAS19TfQbaAmM8igQVgwA/zGMEhkh7
	2WsW3ZcdKsFduU/rWTWTQ9zdc5PtHEc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WvdJsXl6;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51F1E339;
	Tue, 24 Nov 2026 20:35:53 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7362C3F86C;
	Tue, 24 Nov 2026 20:35:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795581356; bh=WlnWqEgxHO9OwEFiPYTA4lAxgT8kQaGYI8IyY6i07ig=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WvdJsXl66Zo/MMmirsJhxVtTutvItNPxsf2hjTwX8JArGnZY1sqlJnFnZxUoci7C6
	 M4J5pEg+e+fg3cxlVQ3dFhXFyitJv7vnskpqvh3rclkYNRgMFSfnrx9Z/Cdr/JMwKE
	 7dLyjzgFZBoJAJm8ecQJ8l4oHqEQa4b/CunjKtGE=
Date: Wed, 25 Nov 2026 10:05:52 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org, Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V3 00/14] arm64/mm: Enable 128 bit page table entries
Message-ID: <a54bdqfzj4eyoaaiekxxeqi27rc6pu6z2uufv3lblbyujclz36@egotqjcxv653>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
 <20261120190525.GC1133597@ziepe.ca>
 <aqcypbxidjbmjhuiujg2krseuy7v4lofrlq3upl4s7yjiq6bh2@3s4jqisdrkgd>
 <20261124135424.GL9566@ziepe.ca>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124135424.GL9566@ziepe.ca>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 3F663A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 35yg9bkxgtuxd38kry4pnm1qp6ett5uu
X-HE-Tag: 1795581357-759259
X-HE-Meta: U2FsdGVkX18kthu3b2CDfoN8xC1Ne1ep+LcV3o4/b2Fr/FWtnnFGiMLjBzKMKHSg+CldDcw4PzRrgB6if13Q3MJH23CBfjBcWJw2sVvkKnNzKQq4sUj1Dp8fYXNnW7uh6d1A66hmW9EMYFFeYcjBSfMEVRmFkWgSEVPlchnkT+A9sHl5kpxmhFnMNMc+9zqjLtOptpF2jRYtoSnOmRv90JbTuQ5NeCua1QdiY7xuISmcEdmdzmaxDZMuHm6ySJ2YuIVPJNJ2mFgJsvElARtkLUCtgMQSuxRTknsz1j73lbqpnBJ/7RKAdQmfSy8L6P6NUIOrzI5aSRCZoh3v1Nl2nkTTKPbTlYtNepY6Eo1FkkzwN/b9pv5P8X9Jol/nTTp2+1r2IXaN78wq3sA3WLb4RWqfGo4FmhFS1wri5pox8ugY0y88n7seEiyAU8w/0VgDgwBZL15pTbJFzh/f/u+0SQWRwJULoT9AdXzDY5FpSSektyYrzZcQ6TmG7C8+hCiVha3/7hxbt6abi0IowwF8HQ9trC1vqjX9BCTpjZ2yeXCV70olBG50poShu1Q9xUWzViXWZlnarRtGnY8RICRRqQX/kDSipVEkKW83TbEcGWgQ0AJo9nhMDLz2Ixv+57IAeDJ3JdXfcWQqHOwP2sygea4ZcHcEum78lbAFCAeIvHrktCZRhstcEC4WFGWf2gEhXRdaVPUIAmFJtpGlTICh9bJGhhOCDo1kAGH3JkySdzB7dLce1OzY2Z9JqhFGsixAmqgEWTuRUdK80Ot0HvFvFelN/M8HWtQQ6nizpGsUkMTpKYa9CQmb3pQ1ut3lmnYIqFqnsZclOAAURiydxWa4Tdc+ZtzEbfPar3dTUdRjxvn5k4pipe5/9XHenW0dEvoV9elOuhS78UazQXiE9n0RhSAwqjWRhEquflr2CqhmB9EOV/i1V945KIsn+H2iRdosf2/KA81O7Mue0oc51pu
 sbODt3+s
 FY8gn0ULoLMwGXhqNQcYkpI7iU+s41Sfc+wVo7CDZNZ7G90p38JfKcBUftglO5m09irHCwWY9iJ/fE5wNLJoC/k3YwfdqpKg1qXCntmyeE+/c7erff+zuiYTEa25oXWDK9gcgJQ9YXsbQ5eBBbDohyNJyGCITEEsYrU4K1aVs5+sJ8rSlx5FmV3dpM9cU7i3eZhl2UTkvEY3nCtsbaWyX0NeBFhxAK/ihZ8PEzLGL+gixzSf//96sQfZEul2ff121wpkXd5EOfraBW4ZpbzFKQokmDmBtJ4p4rffsJNNnvWnO1sL9J12Rd2xG+9qVs/lpEJ1VGFoc7NOdy9PIA7KJu5SfmgeOi2eFUsopH30Ux9CYiJDI0XxnHX4PcNbdhB1Q7HwD50jeyhIttsTX97CjSLk1ucv3gKqU7fd6/yFdBSiSLNTVtbajtT7xXJkB9miDxNkmruMgQrmGoBY4tCeJeQFUSXjVK4E3k4lqJbMKu7AvrwnFhRQxHFocz7pWV3zLvrUf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:54:24AM -0400, Jason Gunthorpe wrote:
> On Tue, Nov 24, 2026 at 09:29:27AM +0530, Anshuman Khandual wrote:
> > On Fri, Nov 20, 2026 at 03:05:25PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Nov 17, 2026 at 12:35:59PM +0530, Anshuman Khandual wrote:
> > > > FEAT_D128 is a new arm architecture feature adding support for VMSAv9-128
> > > > translation system. FEAT_D128 is an optional feature from ARMV9.3 onwards.
> > > > arm64 platforms with FEAT_D128 enabled will now have two different memory
> > > > translation systems i.e VMSAv8-64 and VMSAv9-128.
> > > 
> > > Please don't forget to update arm_smmu_sva_supported()
> > 
> > Sure, thanks for the pointer.
> > 
> > Fow now will disable SVA with CONFIG_ARM_D128 enabled but later it can
> > be enabled back with SMMU_IDR5.D128 feature. I will probably fold back
> > the following change in the series.
> > 
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -205,6 +205,9 @@ bool arm_smmu_sva_supported(struct arm_smmu_device *smmu)
> >         unsigned long asid_bits;
> >         u32 feat_mask = ARM_SMMU_FEAT_COHERENCY;
> > 
> > +       if (IS_ENABLED(CONFIG_ARM64_D128))
> > +               return false;
> 
> That seems wrong if the arch code is enabling this based on a CPU IDR.

D128 translation gets enabled when CONFIG_ARM64_D128 is enabled and also
HW has FEAT_D128 as detected via ID_AA64MMFR3_EL1.D128.

Besides if CONFIG_ARM64_D128 is enabled on any HW which does not support
FEAT_D128 the kernel would not even boot as there is no dynamic fallback
to D64 translation in such cases.

Hence a running kernel with CONFIG_ARM64_D128 enabled is running in D128
translation mode for sure.

> 
> I would expect distro kernels to enable this kconfig unconditionally,
> so this will break SVA for everyone.

ARM64_D128 actually depends on EXPERT and hence it would not be enabled
unconditionally in distros ?

