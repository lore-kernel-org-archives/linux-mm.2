Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 204F2C982F7
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DAE96B00A0; Mon, 21 Sep 2026 08:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2AF6B00BF; Mon, 21 Sep 2026 08:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9256B00DB; Mon, 21 Sep 2026 08:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E73E46B00BF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:42:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 784F41A017F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:42:03 +0000 (UTC)
X-FDA: 85237731726.18.AFE4200
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6F1BF8000E
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:42:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ttcXOmh6;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789994521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5pK4pXIJRmKPUjKpkdsb4t/uRH+AebunEcLl0SfF61Y=;
	b=AdrnRqZR0SZUTy15QuJ7Yx5TlspTw6VtzfKLSippTZXO0cdJqiqjORu/0wQU8dqmEi+y4Z
	h0BdTw1TswZ6lag1fqXuZEfFfu7tbQdsG6QcFLAN5qxPxKEEl2fFQ/ZKFc4JQlrASqmZfT
	GgJxvtep35s+AWUEXhsmE5NYlteJGII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789994521;
	b=vsv3NrHDglYfDfSGT7geie0hZen/FAwVRqiRzd4mPzNxioNVBgJBwmH9uhKWqIVBF8wIXY
	+Wb57v+Ug7H/mkI9h4lfwwqU9tp6GpA1PoHCtK4zeFzKiiJymYYNkFGh7+z2zJxNBRnHIw
	CqXF50avd8lijCOR9JjpeIqf1R+kVy8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ttcXOmh6;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C956F1595;
	Mon, 21 Sep 2026 05:41:56 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94EAC3F86C;
	Mon, 21 Sep 2026 05:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789994520; bh=bI7w8gHGdhxh4VEARjnqWWbdnU1VuH+Od9f4EvEeVjw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ttcXOmh61SrOvoEOAPQ4GmU+Vn2kvt7wLlypDdYben4eNFpMKlX1kcQgIxYV6GTy/
	 se1zPGzMTveLaG5RWM9n6A9/lXq6GcG3cwCrNI9upyNip918OfA4DpZpyTTodfXvvu
	 tgI49nhw7/M9X/o3ScuCj0iBtTNzLWXay6LNgYNA=
Date: Mon, 21 Sep 2026 18:11:56 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Message-ID: <etkbm3mjzsrogpizjwutsqajslkjymjldpyf6robitdot4e23w@mqcikehwbqzv>
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
 <9aed35be-a411-4d9d-805c-03c836e9e56a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9aed35be-a411-4d9d-805c-03c836e9e56a@arm.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F1BF8000E
X-Stat-Signature: 8sc5rg6i89cwqfzbpf8wpw8n3iqqskqj
X-Rspam-User: 
X-HE-Tag: 1789994521-15478
X-HE-Meta: U2FsdGVkX1+cSw0KEHbx1x9K92FxeiT+FJraLaGg7wGSN+T+QB2ovjjbfpjItHmfDVyscn14mhnwXYbXiI2bBRkXuP8tXEXcdL8TCHnriaO4890hL08wvbTejoNQp9tv221ZRVDkwYuPjfX55ixrkeIlFDFigi53XrWomgiHf9r3/K7iabTDzZTWO1oAkpaziqyP1axi5LJiFeJ0X5526c9PaTPN9RTWGV4Arajp7HyXyi1M5Sm5eTy3ZphE82fGP4MNmewBp/Qt1lriBUAy9CZB/W/kFIDYuuizgNLPDubNnjJEytxUS9sncQWnLjC8XEwGfA8uSUCDwbdEOV1Mtbm6C4sPHdMTYMk5u+zzEhopyemdVUbVelKE/SusXgLovvpdIbI1Pn5OZB7PZuy2amIFE0plsllN2dRLXhZUbwihr5VbliV3n0HQbl3QDm+09uI21HczG+mUH/3q4SEiPVZJxgyqjADwfRK78VlDW2KRe/nTum2aqDibATbCO/P6bztYTJnLYIbc3pYrQCFUbl2bq8C4KKUi6RUTtvYFTSD6tRVW0MnoSenMfKy10/d1ffpxqW5ijxaiYRMxwGLC0MTw7g/YOJNnWNUCHqi9qsoV8I/jtjpMfzYhl2Mdj3IlSS1my4PpQ0BefuOyOxD/QVtJ+un4EPvUJdC/pTxyjU8waOQX3FNW/euATDZBTExssDgZK1HnQvs2NTBUxl1U89VkjdwpB32nKY+4bBqBfLhGIDl8C6NGmB9hluu57hD9/tDhfgQJTgFBw6uYi/pvx23dkwPerIubgwuVA7HMeLEYNtp7hugSevJvgXGeNjL2EL7WduVoOh3Tu6NtUNC8FspXKkKHkiAshdPm4iJOYq+b1V5eBnXAhHqAAH6VjIUJ5NncGn7QlhCLKpxTS8kYkbKSRL4xsCUR27AgLWws/aUAHDQMGoKYPOdoFV48B7Njp2myhkcRXo7Lq0wdAMb
 uxrRp0Y1
 OG/AFaK1h1KyI6Y/cx/sWBSlK1+CVX9LEu2YZNhqQ9FwVhcKv/BW2O0JN0hTnFya5VA44mhXCjX9/S7uu4XLR/cxn1kdG9SMOcZxPgzDo7VYJ/d1SXhRuA9Vv7w2Z1sRhStGQCttxUgPZcjI8mlhPWFxJo5kJ4BHFpnjfudJnBMd+NRoSdfjLCuFP6cpe4qFcUp3aaLiV7AgtZBgVvra6j1KwaTUODdnlojauIWu8RAK6ARKywRgyh9ZlnvVFAdwBuWJ/3DFirzJvhkCB40+406Q4UZjw+6IvVI5CBWE8o4i1bO23phEpRXbWcj4fV9+VaWQBGCmkMJ3apGMx57guZkykOGWrF583QWiUpcqn/KzdcTyYhvRS+Yo+uVNLA+NBNjWOVCtjIz+BoFIQGIF3YqnzJ7hs6d2OxSTxNYRkVuJdm82iIvWCo7trkicX+VmG2skGaPUUlJCruJENLCZlsBM0fSYlEEY/dSlzCn0TCDepSwO+inBr8Z5kZ25gmEB5jiy1BUPr68fxGc0jnrmIx1GkSHYEF5u/8f/zWSlAICYk3fUavnIHzjDQbZEztZHO9iU/sOLkIG+braESbQKhXmuQE4F0avRo0rM4s0ffqsEUNek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:55:02AM +0100, Ryan Roberts wrote:
> On 03/09/2026 07:06, Anshuman Khandual wrote:
> > Route READ_ONCE() accesses on pgtable entries via level specific generic MM
> > pxdp_get() helpers which platforms could then override when required. These
> > accessors on arm64, will help in ensuring page table accesses are performed
> > in an atomic manner while reading 128 bit page table entries later. But for
> > now they just default to READ_ONCE(), thus preserving existing behaviour on
> > current D64 translation.
> > 
> > This is similar to generic MM, where all atomic accesses have already been
> > converted from READ_ONCE() into pgtable level specific accessors.
> > 
> > These are preparatory patches for D128 enablement, although standing their
> > own for D64 translation as well. These patches are split from earlier D128
> > V1 series. There are no functional changes here, and besides mm kselftests
> > do not show any regression.
> > 
> > https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/
> > 
> > This series applies on v3.7-rc1 but after applying the following patches
> 
> I assume you meant v7.3-rc1 here?

Oops ! that's correct.

> 
> > related to pgtable entry print standardization posted earlier.
> > 
> > https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/
> 
> This applies.
> 
> > 
> > https://lore.kernel.org/linux-mm/20260901065454.1906343-1-anshuman.khandual@arm.com/
> 
> This fails:
> ---8<---
> $ b4 shazam 20260901065454.1906343-1-anshuman.khandual@arm.com
> Grabbing thread from
> lore.kernel.org/all/20260901065454.1906343-1-anshuman.khandual@arm.com/t.mbox.gz
> Checking for newer revisions
> Grabbing search results from lore.kernel.org
>   Added from v3: 3 patches
>   Added from v2: 3 patches
> Analyzing 14 messages in the thread
> Looking for additional code-review trailers on lore.kernel.org
> Will use the latest revision: v3
> You can pick other revisions using the -vN flag
> Checking attestation on all messages, may take a moment...
> ---
>   ✓ [PATCH v3 1/2] arm64/mm: Move __check_safe_pte_update()
>   ✓ [PATCH v3 2/2] arm64/mm: Standardize printing for pgtable entries
>   ---
>   ✓ Signed: DKIM/arm.com
> ---
> Total patches: 2
> ---
> Applying: arm64/mm: Move __check_safe_pte_update()
> Applying: arm64/mm: Standardize printing for pgtable entries
> Patch failed at 0002 arm64/mm: Standardize printing for pgtable entries
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
> error: patch failed: arch/arm64/mm/fault.c:160
> error: arch/arm64/mm/fault.c: patch does not apply
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> ---8<---
> 
> And as a result I can't apply this series. Any tips?

May be this is based on older dependant patches.

The latest V3 does apply - although this series does not any more. 

https://lore.kernel.org/linux-mm/20260916044933.2689426-1-anshuman.khandual@arm.com/

I will respin the series updating the commit message as suggested on
the other thread but probably with a hosted git branch for better
access - should have just done that earlier given multiple moving
pieces here.

> 
> Thanks,
> Ryan
> 
> 
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
> >   arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
> >   arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
> >   arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
> >   arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
> > 
> >  arch/arm64/include/asm/pgtable.h |  6 ++--
> >  arch/arm64/mm/fault.c            |  8 ++---
> >  arch/arm64/mm/fixmap.c           |  6 ++--
> >  arch/arm64/mm/hugetlbpage.c      | 10 +++---
> >  arch/arm64/mm/kasan_init.c       | 18 +++++-----
> >  arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
> >  arch/arm64/mm/pageattr.c         |  8 ++---
> >  arch/arm64/mm/trans_pgd.c        | 14 ++++----
> >  8 files changed, 66 insertions(+), 64 deletions(-)
> > 
> 

