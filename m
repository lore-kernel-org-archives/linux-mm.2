Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3EA5CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 06:41:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9D06B0088; Mon,  5 Oct 2026 02:41:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B146B0099; Mon,  5 Oct 2026 02:41:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB10B6B009B; Mon,  5 Oct 2026 02:41:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A1B096B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 02:41:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 246F5C014D
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:41:41 +0000 (UTC)
X-FDA: 85287626802.03.80171E1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 46360140003
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 06:41:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iJBOFkhy;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791182499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=321duBp0aPp9ESQIUn3PgEtVLnGlcLT2lvoMXfWxb2Y=;
	b=1f+cPvX57RGO9CvXk6BrK6yzKE35+eeOvquoz8tLTEn3ugWGK1N3HHmVcw2K4OSymWn9lE
	DErOocpShbDLqz8ysejc1AWVtt5Q/MSmYvrSr0HZroyuQpCxdJvv36bU/aPpuSPzy/+lWO
	NFarFmurt1ah4l0He9SBGTic+W9WUDg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iJBOFkhy;
	spf=pass (imf26.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791182499;
	b=H+PGLb7iNjGuYTQunyTJ/fmtrUaG7rVl9so4Tnz107TCFfNZTUcv5Q8PgnU+HbbEACK++Q
	+9Ys5FCRoI0iC5V6iX1eS9aMFWavOg5R5gOD7c0hc4GgHiREBJ+rq3989CA4ZBUi8vJRUZ
	sKcHO4Gk9PSEqQaVgTO0ZNEPVJC+51g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DBACF1595;
	Sun,  4 Oct 2026 23:41:34 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88A5B3F763;
	Sun,  4 Oct 2026 23:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791182498; bh=gPS4BaPCtTXPkS/p8WI2ZOze4/Fjezx1OmLe4zcOaeU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=iJBOFkhyRkxDNSYu02g9UxsbHGxbruPrgL0D5tGBG06toBL2lw8y5vZyyuenf0q+4
	 1eOIIWsEa7tWNBClthYMJ/VFcNqRFOCoGaSYEujimXlW7ms7jJX8ZxyFPait/jXuUx
	 Hrf3cEXGPzzoFMxv490xa3FwfIB0J1XyQUHUg8/M=
Date: Mon, 5 Oct 2026 12:11:34 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org, 
	catalin.marinas@arm.com
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH V3 0/4] arm64/mm: Convert pgtable READ_ONCE() as
 pxdp_get()
Message-ID: <6eghulpg35z63dpimrtw6p6x3zwfllfzjhpkpmgs5vcz4mpoda@poqgboea7nz5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924062214.1635078-1-anshuman.khandual@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 46360140003
X-Stat-Signature: gbbngsky3c8p68bxbkw7ijbqnr85dke6
X-HE-Tag: 1791182499-426457
X-HE-Meta: U2FsdGVkX1+eNXvB41dwZs9WzFc+Jeo+xIZzVD1xfXqnZYXD4dsLX7jNWZ1v8Vwf28B4Td5xPpFoZJcuDl65LPErUn4NDqyj4+S2rTWB34N/aCR40Hozpu79AZfkVhvLK5mxQ44okzSjE3KBiNmgwtXZHqSNA0Cq/kLCc6Zkx+mrDpWovQ3C+WZehMYYMP7omoMHOxX1iKRYrZsRPBweIyoJ8qQHI76p24x+3/fq/UW/+fKWo8t7gZVqjrfOkCyfdit0vGdR9OVOm6AIEB/Sh39J4XnwinLrbpsPE2EcsIvlYtnUsnCGU14K5JrTzuQvsqYwlF6uOJ7+7+cXnWeSKF1VW6+Aj0mQUBY5UYgPLG5bT+XOCsI6SDNzKd3Tb2Bx6eaXEQKOdBvU0efndugXp1JDnYwcVPfFJ/YrEhugTjNJbrzxL7OeISRoC+VKtVwEtppxowR7YtONWoGEaDgai7ETXMSloQDxUT+M2c+Kgvz6mxfAV8ulZp33TXVkh5I1CLuFrC58fvwrLNVMhw8MbHhG3Hs3jU04p/1moYIyybgnkZJPsVCqjFw9MyIwDQsLsWRjR1yZxFSls4XwYPFuXDbKI7HKSQrDFzy4YzO9+BSI6ONk4zKhENfgWmAvxZO/ck5XQm0Kh1dHjDmacEUi+UGr0ceVj2ry/MxXmTYqE6XMeOPSr6tLOKkORJhKZJtjnIGaoj/ejuMPv2apFVT1xnBC2BmaNZA1tuhMk7mzrax37tIRFBciW/LyUW5My0xOkePibqvVW2XOXgQJT+Aj0MCAoCS7e1ylyJ/CYom+cuVGdXgpNPHjp21lbFTsjCaku517qNwgusmDIQag1tpj1tF8Gk/8xNo+KV1IvPB/wX7FhpjhenuX81+yqAZUPfz0lgzBs6opm1rznNBMty6ZjClk9Vbz8Ist/vR2Vckokn1jUToZZW/mSumbjBUZr2m1umzVN0Cfnu79fEYkyY7
 cdVuIJVn
 BhTaFxfHxWqehXgY3pk02plVuEDVQYtQSRn003WgvVpcf1ZQ4Pc+kIqlGngxq2Meh8Kzss2S6XT7CIX8iZz0UeANd5tE0PKUXtU1NYsRMnGyS/qfZPpwzwjf3qNuxdVR+1VlvWx9K/usp25idIlv964DjpFGUxlSQ6wInHsE+cOO1kr0G+S37QP259oh2s94mXP0LRIl5TC14gxTEr6yPaZs5oxZNC03Q7Q1ArhqEzDgIg5d25nEFejQGBABY4exiqc+Zle0eRthafpCuOkIsotmiT9Oimoa0/+D4i2mv0gHZlJaOvkISB2CcNX9Io5/Bcx1K49RH/H+/OwCX7TLLHKpc8CpCWRalfv8R14P3N6ufy1KCXt0fhix6qhZQEAc1akrMc1U7OxHlb9ZR/9rBamLfa4CLt+u2Tl/g5V664Gb5udJiVul8tNd88eKBSiODJQ+RieINamfrfv13hxPFvyFkJPn/OGSK8O8LF2KO5eg/XpnNd3L4SGhEEZwT4DUutHb+Qu13WFedCiCZpotg8SOF4f3IMGKuLrteYgFc88xIWX840RmHRnNFtpTCdisLivR4jdzoaGQ0lLMZzUoYhSK2EdxHRRK6YuQUcd/rNfcHj4IFqBviaClNjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 11:52:10AM +0530, Anshuman Khandual wrote:
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
> V1 series. There are no functional changes here and besides mm kselftests
> do not show any regression.
> 
> https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/
> 
> This series applies on v7.3-rc4 but after applying the following patches on
> pgtable entry print standardization posted earlier.
> 
> https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/
> 
> https://lore.kernel.org/linux-mm/20260916044933.2689426-1-anshuman.khandual@arm.com/

Hello Catalin/Andrew,

The above mentioned dependencies are already in mm-unstable, thus reflecting
in linux-next as well. Just to rule out merge conflict - this series applies
cleanly, builds and boots on latest tag next-20261002, which contains above
dependencies. But please do let me know if there are still some issues in
resolving this situation - will be happy to help. Thank you.

- Anshuman

> 
> These patches have been hosted here as well.
> 
> git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v3)
> 
> Changes in V3:
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
>  arch/arm64/include/asm/pgtable.h | 40 +++++++++++++++++----
>  arch/arm64/mm/fault.c            |  8 ++---
>  arch/arm64/mm/fixmap.c           |  6 ++--
>  arch/arm64/mm/hugetlbpage.c      | 10 +++---
>  arch/arm64/mm/kasan_init.c       | 18 +++++-----
>  arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
>  arch/arm64/mm/pageattr.c         |  8 ++---
>  arch/arm64/mm/trans_pgd.c        | 14 ++++----
>  8 files changed, 95 insertions(+), 69 deletions(-)
> 
> -- 
> 2.43.0
> 

