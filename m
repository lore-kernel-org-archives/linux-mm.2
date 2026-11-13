Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F323B606A88C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cQzJAi9q
Received: by kanga.kvack.org (Postfix)
	id 9D3166B05F8; Thu, 12 Nov 2026 22:28:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AAF96B0661; Thu, 12 Nov 2026 22:28:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C28B6B0664; Thu, 12 Nov 2026 22:28:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4956B05F8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:28:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDA8DA8CD4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:28:57 +0000 (UTC)
X-FDA: 85428664314.29.23B7411
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id DBC7420006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:28:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cQzJAi9q;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOwK+5oLftQk320DH0GEbzZnadmplgpiQL2jCJ+yV24=;
	b=XHq0EDC0Swkr9lHWZMQqjtCOZcSHBL9HPiNX0HI/QaoVjNAkU0p6ERxl3axhtCt1ZFzutM
	HIafCDNKpy5obgZ+/MclqTCgYdyJWpaywucKnIq2iXQ/YCwGrdMRMkRdzzVThrDd/qM5Vx
	Q9BSVeN1Lk051z46HNvSvI+7U/xE+SI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540536;
	b=Y3B334NLM7MNOrP9sZQCdPGzZDKPHvZfNXeZyPSbDRq7KqX5QStEM6kPylXIl2XgHWXK2T
	tlA6lF8E4tBm50hZ3sN9423UnWnWx3maHyhaXXyxBQP3dOvK2u0ZG77oMdWoJjqWH931PJ
	OgVG2YONQNxACYvDE73pXqDoSapnec0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cQzJAi9q;
	spf=pass (imf03.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6D24175A;
	Thu, 12 Nov 2026 19:28:51 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 106C63F632;
	Thu, 12 Nov 2026 19:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794540534; bh=kLEU3+bkOweqD+kWRCMnCgNUSxxZISweiL/OZrrvsQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cQzJAi9qDEf+g9Wu+39XmiWj8YhBA0INOILUGffcjMUE8/Tf9z7R4Xduj/J3XnJva
	 NIkTXHmTBtDOBXymBVjpVAXOyuDh6Q8LHelosDBddoa2rtGosn/7Xf/ohNpiQnHq7C
	 yISkFw1TmXdLfYUuB5eNB4w4khmLNN95v7wKKgUE=
Date: Fri, 13 Nov 2026 08:58:51 +0530
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
Message-ID: <vtaekdnpxd5avhpv3hlmeswwq5raf57ila2qyilxvddu3w5nnq@lkenzauzv7hy>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105043403.3326445-1-anshuman.khandual@arm.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBC7420006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: tokn6aju3ahpmrdfx67ketrsdf48rc4x
X-Rspam-User: 
X-HE-Tag: 1794540535-437342
X-HE-Meta: U2FsdGVkX18p9peBqJFHQuubYrPX8iD9RYVruUb0/0+Q3kSmjI5JP++K7V1DwufGPjqIInokgDlwbK/ayxn8bz/p4YBLGp9QhMl04Z9AnKcrx21VDAgQ9sHFmp2QwwRNsqWYaC0eBSzklMzPWUZkUqsQH37SBrqs8F88DNmX1oOtGWOt3Mkc1hR0/l3vHBoytQkrR7F56FlSVhLMVuqrMfPnzhNHk+1+mZLxQyKPhyI18RUncKA3hlM7V4cDYKokkA0jIbgwrQ5Kpa0aIiLFSWou5jOABBx3YAvjvWTfbJ3NiraXEDCtF6atYRNWmiEZcla5A/sj9+9jivkrYhEPPgMP61PZs+cUg95iHq6umFTuwmx2ty+AeQaRIhvloEP1fq5d8tR8WgP+NqFh3+O5MAvGMMeFFjWTXeNu1OO71mAW4pRWgSzSAGAr5VcBzfGam9EoqOGLSuKfv+uwzhXGMEWbeObaptHwhunuheoZTmTUkhQgZYTkpSObLmr4q4h22m06QEH5Wd2X2tt6kR8kTBPg3TY3nZ6y1PBl17cn5kq4R239eR1Hkz3XyYgfoWCeg76A2hQomeK0+MylCSPxhUoJ7qSQlFIeQSI8xTUXFVUmsx4Lp13EczsT0b2zfVb465zAZ4ZaAxhXvk0iS0GhI6G53ZkFgyfLylITtigu1NOPiBi/rfhPaYVSqmrfPggu0Qn1VTFLD617N2nTxfBwdi3T849gH0f+QBfSO7z38J3K25oVQbSKW/qBm2X2LGpVuDcx2hPYyTMHxQ+311DvE5CPKXauP2T2FkM+CeZRQ+mJBGEJIhKGlnWZh/tuKm3w2pO1JCI4P45ixuUtjv0/qR/Q2t693HfAm8FqfNu5Btqur30WgSrSIp1CuwQ+1VeMOviJCkNVqwgzVamjz+qNLoFULuq2xkL/wq+xrQ6sw3Dr4RDcCvrC/Agh6a1ssj34YZBCopunCPqZ01E/5K3
 vUw2x9+u
 5TC66x3fQg0Z4aOYvUOuaZweXVUdQkvVw50r/dPrqec4/Yy1NOOdmPJI2kBb3it5BAGKFhnxoejiZolFXY6BjChG/m1mZrZ10aTCCFt8qf471bPYRhb7SkqSJx4vkORaJ5El8UF7VZxoqQ6zpKqtS7QSX3RTRYjg7MwgKW0b9KQcTY3PSYHy+UemFAx6iSDZOEQhSXNt9jttVAj09s5/tz7HYzV+nO2T9CBXQ8sm27LCSIKc6vik/oKRp6wsPWXJBbRFMmGwhTaabMo+GANhB0P7pukoeN/qpc+Lvzv9xHIBNOb5ZzkJ/OqHogUPkAJoiF1NYiimaT2CTXYnBO3tUN7vuyNDHg3Sq+KysE6bmX9LtMNc4xBe1HfXEqrEjg2TOpYsBPtl9IjpzjadW5NoNumzmpXStdsRTXrHFNSVtEm/b9OrdCH+0jZDIa2I7VB2DQthaWk3mvz5Mfa2KD5hHIvcQMhzwOdMAmy/WapBHANT1GGJpwim6oKawWiPcI4yc/uMiBHQLozykYcHCi9pvYdcKhP09nbrISrpkwPFRCrYqNPp0uhGuVghP+KQ1EMAb+OOuycGkGLX2ne8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 10:03:59AM +0530, Anshuman Khandual wrote:
> Route READ_ONCE() accesses on pgtable entries via level specific generic MM
> pxdp_get() helpers which platforms could then override when required. These
> accessors on arm64, will help in ensuring page table accesses are performed
> in an atomic manner while reading 128 bit page table entries later. But for
> now they just default to READ_ONCE(), thus preserving existing behaviour on
> current D64 translation a well.
> 
> This is similar to generic MM where all atomic accesses have already been
> converted from READ_ONCE() into pgtable level specific accessors.
> 
> These are preparatory patches for D128 enablement, although standing their
> own for D64 translation as well. These patches are split from earlier D128
> V1 series. There are no functional changes here, and besides mm kselftests
> do not show any regression.
> 
> https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/
> 
> This series applies on v7.4-rc1 and have been hosted below for reference.
> 
> git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v4)
> 
> Changes in V4:
> 
> - Dropped all pxdp_get() platform overrides per Catalin
> - Moved pmdp_test_and_clear_young() and [pud|p4d]_offset[_phys]()
>   helpers inside arch/arm64/mm/mmu.c to avoid build problems
> - Updated all commit messages as required

This series has run into some KASAN fault issues during boot with 5 level
pgtables but also unlike Sashio suggestions these would require more code
churn to fix. Please find the details below.

https://lore.kernel.org/all/ohyhflzuoxdemccemutoosmj5hsfwylrlt6tvnyehulerk7gf3@ada6wu4zrzkp/

NOTE: somehow Sashiko had dropped LAKML from the thread although it shows
up in MM list.

Given the above scenario, I would suggest falling back on the V3 series,
that defined and override pxdp_get() helpers for arm64 platform. Although
similar to generic MM default fallback, they prevented code movement into
arch/arm64/mm/mmu.c file causing these KASAN issues in the first place.

https://lore.kernel.org/all/20260924062214.1635078-1-anshuman.khandual@arm.com/

V3 series apples cleanly, builds, boots and also clears MM selftests on
v7.4-rc2 as well.

> 
> Changes in V3:
> 
> https://lore.kernel.org/all/20260924062214.1635078-1-anshuman.khandual@arm.com/
> 
> - Added overrides for pxdp_get() and replaced remaining READ_ONCE()
> - Updated all commit messages as required
> - Dropped previous tags
> 
> Changes in V2:
> 
> https://lore.kernel.org/all/20260922061638.3967467-1-anshuman.khandual@arm.com/
> 
> - Rebased on v7.3-rc4 along with all latest dependencies
> - Updated commit messages per Ryan
> - Added tags from Ryan
> 
> Changes in V1:
> 
> https://lore.kernel.org/all/20260903060657.2717457-1-anshuman.khandual@arm.com/
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Linu Cherian <linu.cherian@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mm@kvack.org
> 
> Anshuman Khandual (4):
>   arm64/mm: Use pmdp_get() for PMD accesses
>   arm64/mm: Use pudp_get() for PUD accesses
>   arm64/mm: Use p4dp_get() for P4D accesses
>   arm64/mm: Use pgdp_get() for PGD accesses
> 
>  arch/arm64/include/asm/pgtable.h | 38 +++----------
>  arch/arm64/mm/fault.c            |  8 +--
>  arch/arm64/mm/fixmap.c           |  6 +-
>  arch/arm64/mm/hugetlbpage.c      | 10 ++--
>  arch/arm64/mm/kasan_init.c       | 18 +++---
>  arch/arm64/mm/mmu.c              | 97 ++++++++++++++++++++++----------
>  arch/arm64/mm/pageattr.c         |  8 +--
>  arch/arm64/mm/trans_pgd.c        | 14 ++---
>  8 files changed, 108 insertions(+), 91 deletions(-)
> 
> -- 
> 2.43.0
> 

