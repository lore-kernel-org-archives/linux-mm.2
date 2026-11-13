Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD1B606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=sCJ9eEuX
Received: by kanga.kvack.org (Postfix)
	id B2D956B05CD; Fri, 13 Nov 2026 01:48:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05416B05F7; Fri, 13 Nov 2026 01:48:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B066B05FA; Fri, 13 Nov 2026 01:48:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86A896B05CD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:48:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C58D16056D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:48:02 +0000 (UTC)
X-FDA: 85429166004.20.29C3D64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E49541A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:47:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sCJ9eEuX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794552480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2V+tV4ewaynofE8kPco4QPP/Avu9AgLsEkRfsCohWsI=;
	b=eMKmN6KGzJtRXSMhsXGhYGCGdWiIobPQ9AI3NXAidyM1/Pf8zjYC/l1IIhy4XLInGrssnl
	bWlpgEx10Xic3mts7M6cgzKxQPyreR29iUWks8PUGe10E4AZmuVUMZ8MXwrMufZxvf7BV5
	Ef9EUcd3YQEuPrrzv+z77wRTpLRJZjI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sCJ9eEuX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794552480;
	b=7VKOkTvStR3tCLD+6NkoBfDgbUhj+je87UsNsm42/wWB7uiD1tzrUHKfVntE4eTBO8w3iM
	tZC0hFUKVObcFjlucxBOLyaMhJJfxT4wGaSAeLkYeKbVQnnSKB3h28d80ecEmLJUmWHF74
	YdQ6YWrM94VG8VkiAt+nascbHAxnbF0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C066616F2;
	Thu, 12 Nov 2026 22:47:55 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0EFBB3F85F;
	Thu, 12 Nov 2026 22:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794552478; bh=5i7fDyuQrBPfqbfudFwvrfilL8nz8d+trbu034WceBU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sCJ9eEuXBnkpPB+5xYYSTJZKQIv2FyOza6IduZmLGvxBm/AjRigGwtWQ0bh8UmagQ
	 TbYwfJoXNo+ZuQpa2iGOFgo5MFSasfVKaJiXzi8QljIpJh8j533RoyPp5LSAlsh8rA
	 wz0XuEGtjc868dTQbbtg4WNXfApl4kI2T02vXAYo=
Date: Fri, 13 Nov 2026 12:17:55 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com, 
	will@kernel.org
Cc: Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V4 0/4] arm64/mm: Convert pgtable READ_ONCE() as
 pxdp_get()
Message-ID: <ikp346hhtfkswk4gabydkaxgtuvoygrj75clezzv25r2j7t6gz@q32fppupesvt>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
 <vtaekdnpxd5avhpv3hlmeswwq5raf57ila2qyilxvddu3w5nnq@lkenzauzv7hy>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vtaekdnpxd5avhpv3hlmeswwq5raf57ila2qyilxvddu3w5nnq@lkenzauzv7hy>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E49541A0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 1ujwd7rwym6d8xnekyjp1pd7gzkbd3u7
X-HE-Tag: 1794552479-718864
X-HE-Meta: U2FsdGVkX1/vDe9vNcIVZAS8RlBLISD2/k4fjX4rq3PfREL387WoUoEpiuEfJCz7gzG99nWQ/a4H0RNt8iJJYYKMWQqMgH/mnQpxm8xtq3B2Z+fkz+5OjomVzn7sDo0Ywgu1L3ndC9Y5+7NoJC9zrIQji4f+r2u3a4KqqJr2stzz46zNqTeOOly7s9NYcBoC3HDb+FbtWkadRSHx1/ZRL9FmhJZ9+UYrydoN2VPTcFmsIa19jseobrrSN2d0TqQTdwcHwP6Xm3oNX3nBzPl7Hx0P2+47qg3C2mReBGvpTomSSYJB+H75fYv/c1eNX+R7E3JddmvBvWNFMMVC3zc7guXw4fTqWZuThPGKgQgHTzMMUxWGUbgZE4xFDo0NEObkYPXAwpfm/nPC9/cbf07qKS1RWXsvzzNdCj5jAtMSON8A8lE+4eWClr9GbaJ3vSSPrNNhCw8bWCiJWwJ9m+9ouGIKHi+jpJ9OaD/vKOZjf/wLoE7ILvTqElzxPB68h/Obfz4IQ0OTdvNRaLscV/8wRstDeSAG27whYlFWCN0WlXF+TrNLSrXsb1L+pSod16x9xxa6EK/AsZo7f03H7dZpKJrla6t61WzBiN7z3UWIKgKpGBsZclHUfk1uTcs+7CarbblLBxtiDShTDXFjLcQZwEsLy2mCgYOEzv+FipgleFUTOXcz8unBXw4GsNjOZG9WmWUe+7xagDw4LF6kNU+h88qcHn+5CMrSMHHXeR8GJBCZjIDyzy/CLZlv0xwYbmm9DJe4ijKja+wffmjBT2sw68shOzMF5kGxM3LFCHM7uFdCQBs1C0nTNLzqLtxOs2DHcNyGkHI94k97rQ2XBa0SHQZfo/qmRt8nVtGlRKEE5Dmm9JNDKSzycbmJ4pNf52C77D78HI3IepHt8diZZQw8mrAr2nbRGieJ/7FRQP0pmfdAezZp0MIN8T19ed4sKx0vT3I9MLBcXIoCTuitupJ
 4TX+aubB
 ITW9nh14Q+at89O1iyf/tQFXQNYpe9Juse6eFyaxWhsxc/+LQHDRhLAU0hZRdvsDrv2mKEFvzNn5wcVaRJfkTPob3wNsIJLXK4OjLSi2OXxh6zCJ5VEf2yumqnrB0fu+g9hajx3giB9WEkad0AqV5uZKRXtVz0OlLTYWln1lmlrCzemdQMfIpMZq4J/iADDucULogQK9cS6+B+X8Dzj5Gam42pyuO3gCdSDXSOE3pS8IsSjgncnsXrldZYzFc/n+0miCdO1vzov4elAIKieg6cl5c7t+BxWk50hlbcvG7j8I46s8unLhFtc8Lpj62rHuO+gIH2d/GwQ7fdC+zTLJsbAIs/ZtDQzWfOU5zr6bnQc/jQgFLRJKvj31o5e02YScF+WqzMnvLNdrWjqfnWEqnWkXHDttFa9xHxojwBqgnWTXhJvE+AhswRLuQ6uK224EODeDnPjmGwKi0+Th5DGmQjdMB9ZdkhcxvIMAAyxkCBNpLSKsVjllzeE3n3hspRcx8FOgC6LaFlbJejgvoXQxzkS9cJZImekSpI0fV17GPNxUrSnHlDqdE4Y0hAqbxmUMBec53dXI8FQ28gPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 08:58:51AM +0530, Anshuman Khandual wrote:
> On Thu, Nov 05, 2026 at 10:03:59AM +0530, Anshuman Khandual wrote:
> > Route READ_ONCE() accesses on pgtable entries via level specific generic MM
> > pxdp_get() helpers which platforms could then override when required. These
> > accessors on arm64, will help in ensuring page table accesses are performed
> > in an atomic manner while reading 128 bit page table entries later. But for
> > now they just default to READ_ONCE(), thus preserving existing behaviour on
> > current D64 translation a well.
> > 
> > This is similar to generic MM where all atomic accesses have already been
> > converted from READ_ONCE() into pgtable level specific accessors.
> > 
> > These are preparatory patches for D128 enablement, although standing their
> > own for D64 translation as well. These patches are split from earlier D128
> > V1 series. There are no functional changes here, and besides mm kselftests
> > do not show any regression.
> > 
> > https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/
> > 
> > This series applies on v7.4-rc1 and have been hosted below for reference.
> > 
> > git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v4)
> > 
> > Changes in V4:
> > 
> > - Dropped all pxdp_get() platform overrides per Catalin
> > - Moved pmdp_test_and_clear_young() and [pud|p4d]_offset[_phys]()
> >   helpers inside arch/arm64/mm/mmu.c to avoid build problems
> > - Updated all commit messages as required
> 
> This series has run into some KASAN fault issues during boot with 5 level
> pgtables but also unlike Sashio suggestions these would require more code
> churn to fix. Please find the details below.
> 
> https://lore.kernel.org/all/ohyhflzuoxdemccemutoosmj5hsfwylrlt6tvnyehulerk7gf3@ada6wu4zrzkp/
> 
> NOTE: somehow Sashiko had dropped LAKML from the thread although it shows
> up in MM list.
> 
> Given the above scenario, I would suggest falling back on the V3 series,
> that defined and override pxdp_get() helpers for arm64 platform. Although
> similar to generic MM default fallback, they prevented code movement into
> arch/arm64/mm/mmu.c file causing these KASAN issues in the first place.
> 
> https://lore.kernel.org/all/20260924062214.1635078-1-anshuman.khandual@arm.com/
> 
> V3 series apples cleanly, builds, boots and also clears MM selftests on
> v7.4-rc2 as well.

The following upstream commit had changed pxdp_get() arguments as 'const'
(since V3 was posted) which would now require similar changes to be made
in all platform overrides for pxdp_get().

48bd5dc504cc ("constify arguments in default pxdp_get()")

Hence will repost V3 series as V5 after changing the arguments as 'const
pgprot_t *' if there are no other conerns.

> 
> > 
> > Changes in V3:
> > 
> > https://lore.kernel.org/all/20260924062214.1635078-1-anshuman.khandual@arm.com/
> > 
> > - Added overrides for pxdp_get() and replaced remaining READ_ONCE()
> > - Updated all commit messages as required
> > - Dropped previous tags
> > 
> > Changes in V2:
> > 
> > https://lore.kernel.org/all/20260922061638.3967467-1-anshuman.khandual@arm.com/
> > 
> > - Rebased on v7.3-rc4 along with all latest dependencies
> > - Updated commit messages per Ryan
> > - Added tags from Ryan
> > 
> > Changes in V1:
> > 
> > https://lore.kernel.org/all/20260903060657.2717457-1-anshuman.khandual@arm.com/
> > 
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Cc: Will Deacon <will@kernel.org>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Linu Cherian <linu.cherian@arm.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: linux-kernel@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > 
> > Anshuman Khandual (4):
> >   arm64/mm: Use pmdp_get() for PMD accesses
> >   arm64/mm: Use pudp_get() for PUD accesses
> >   arm64/mm: Use p4dp_get() for P4D accesses
> >   arm64/mm: Use pgdp_get() for PGD accesses
> > 
> >  arch/arm64/include/asm/pgtable.h | 38 +++----------
> >  arch/arm64/mm/fault.c            |  8 +--
> >  arch/arm64/mm/fixmap.c           |  6 +-
> >  arch/arm64/mm/hugetlbpage.c      | 10 ++--
> >  arch/arm64/mm/kasan_init.c       | 18 +++---
> >  arch/arm64/mm/mmu.c              | 97 ++++++++++++++++++++++----------
> >  arch/arm64/mm/pageattr.c         |  8 +--
> >  arch/arm64/mm/trans_pgd.c        | 14 ++---
> >  8 files changed, 108 insertions(+), 91 deletions(-)
> > 
> > -- 
> > 2.43.0
> > 

