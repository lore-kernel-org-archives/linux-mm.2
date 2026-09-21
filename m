Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D439C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 10:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4884B6B00DF; Mon, 21 Sep 2026 06:55:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4126F6B00E1; Mon, 21 Sep 2026 06:55:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3285A6B00E2; Mon, 21 Sep 2026 06:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0246B00DF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:55:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 833B9A2F34
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:55:09 +0000 (UTC)
X-FDA: 85237462338.22.2912AA0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 94D101A0006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:55:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TcrqUl2G;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789988107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JOIIwBcHwXvhGohwhLmN0ckUZewr1XmsdIkqY7rlIfU=;
	b=7R8L1AFdco3Vt1HukrA6SAnrvpWfU2qXaGGL7fS7IY+6Q2q2PikD7WWU1Q0WE0DdZpk57k
	zgyB5yzArPfnYsHNAGz0hjLIk6i/yjfVLZH29/hMUeVbtpbuKu6WqWH8Z06kx9ECe7Yu/A
	ZP5013Rfw63tBrOF3rMFejrIPmy7s78=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=TcrqUl2G;
	spf=pass (imf19.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789988107;
	b=OMAWNANljq2eGcrj2BLWfPF2+hdZBNxZ3Uexw3WJ1kyTDZ0ttbFebfVEGlc1Un1IzUqOap
	AH3rpfq6Ko9jeDMuDl2Ofr66yRGZlgqB09T2Lbj++oQb7Drtd7qD9bjwYXhSFrMDwSvvBI
	PsaIRq0Ab2EmkbUHvdkRKZLcfEb2+o4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23B091570;
	Mon, 21 Sep 2026 03:55:03 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B1D1C3F86C;
	Mon, 21 Sep 2026 03:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789988106; bh=VeIsaNzzDd9f9NeJzVh3EXPEgrmVN3PnEqsJPHZMPRs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TcrqUl2GOeCmADC+jcCe/JsSC8+pdpNPcZ+lZEqkLwHaF82/grSesMT2K8TGrEkh8
	 Qc3oT/5ZQjSahcQhuvh7uXmdSxiUefczLAMViYr1PQ+k3g3NIwl+tJWn304rX67Hed
	 cHuJUz2DRzDomCBX+TgkYOUQ70K+qqdbA41d7D/k=
Message-ID: <9aed35be-a411-4d9d-805c-03c836e9e56a@arm.com>
Date: Mon, 21 Sep 2026 11:55:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260903060657.2717457-1-anshuman.khandual@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260903060657.2717457-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7tuzu4oyipg1y7z5ka8y6hbzjeu64q4e
X-Rspamd-Queue-Id: 94D101A0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789988107-390008
X-HE-Meta: U2FsdGVkX19Boox8FpNoL3skmn+rIJ7lSTodmvedlg3lGLBkJOSoLZggR5ZMlfPwdaP/321wfO2K4AZcGEhK8l67ck82Koq85XClNVeaLQg6T2NRBrR2zuEuKpCrDBnGZEgcwIhcr7g8h/iolo52GdOsZQRfvK4CiWKm4ueLxeKq6FkPn2VTvpoKQ59KfeQLUqwmcPSJ4hnCXWwBpng6cuaEgT4cdMyW6sAjOZbwodH8Se9V4sQZIEOigdcTosFVQ/Ra7AbosDUP3xB0yCOUydOdmFvS/WwYYhUQ0CnU8N2xKtizQnsDdPxhLJKUCqX/iGJm6gP1wgdtwAU73SN4tKt3tn+a4iGCqPI3/tjjFD5uinZNF4e2TIgpCfC9UHZNKSk20yuttBpogxI6AzR8wtfpAVbLg8Ide7C8NVRYnu1fFpdcb0y5MVePmR7esWl3+tDkp8ADlwYCGTmHGCRpay93wale++0EEXw5I7rursVjO1opj5p0uX0RBENOBcVQzlIYvW+6EMVCTEwBrDUjmDfmgON30CqXdJD/j0DsNlwTjVK4OdP0rwfoKSwBgXjojswve6tNMYvrc/Qwfl4Rip4RIpdgR4aMPXNjeRXSd7g34jzAWmYsNK/JgEetSSAoveXCWQp0v3z1OigUjFknmyquGX/eZAYp1Fx9MLqZTHx0uvZSA19wcjZgMsizSmW6gR8U23EyB8EgwK+6QlDy4C2k6euhoda2e7nJhAPsHEOvnn6SyO0BEve/8j8nq1SJ9AK4zPr9o3ZAHVhpZhdbidjPUjZRxqFUlJTddRcX+gnItQTleECg+ePPSEf6VNXYQGMBH3gxJixSNIVffp8G6lSrNQ6qQgKzDPmgipZYjCTQ+82WtsMgFwmxVmdgoLC5giA0WIyn6KNXpn39qwIz8QsRCIG0vi1/H0tUkq4rZg0LH+S5VudObzutp/6UMHx833HmZi8BS4ekzoOipLB
 msgRRs/f
 4GHcWqsVNEL+iTwQLN0z6zMatRHPphPWyRStBSjK+S3KkCVe/oHbnBaw2oi2k2obnc+RppparZwpZ2WNqMbDM+4BtD100ODlmhsW9FzC5uF5F8VY6Q2747mCQmpE9l0An9ygCShZa55ElG2VC8Ji/+6e7sj+XS4zjI4pCcLvTygU+1iqqhhNttymDHtb3p7pS57BB3YP3mGtzE7xv7OBKPTeUkLYIdRsn63yPEn95hAs2xl6treQeGn/UWR0sXq6VLfbZCHEGiOnMTa75aiilT8miVtNbCc3cKrO1QC3XydjxKF3zCRBciEAABZkTjl88evR3W2udVvZG6McwQjRsfT2/L0CUXwLGo89GHP9zOhK4rk6iGJKrQ5Ld9N+7juHmS5NZy+EBKhjUpEsMqhfRp0e/Xe5R1By9lgwtmdhGqBSXcjqh1ZMZ0zmnPTN+b9/GAJIMbGco6NOIok9mW2iYUDCpIA2EJoGXocLSFpHlc4FzPc4h6tuddYSTnHIegqPoxUB+RJsl+mvdRJpvIhc3amnIkA8HGlXbSLgxLqpNFdWhlAL0fZsCHQT5nKncHXShrXHU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/09/2026 07:06, Anshuman Khandual wrote:
> Route READ_ONCE() accesses on pgtable entries via level specific generic MM
> pxdp_get() helpers which platforms could then override when required. These
> accessors on arm64, will help in ensuring page table accesses are performed
> in an atomic manner while reading 128 bit page table entries later. But for
> now they just default to READ_ONCE(), thus preserving existing behaviour on
> current D64 translation.
> 
> This is similar to generic MM, where all atomic accesses have already been
> converted from READ_ONCE() into pgtable level specific accessors.
> 
> These are preparatory patches for D128 enablement, although standing their
> own for D64 translation as well. These patches are split from earlier D128
> V1 series. There are no functional changes here, and besides mm kselftests
> do not show any regression.
> 
> https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/
> 
> This series applies on v3.7-rc1 but after applying the following patches

I assume you meant v7.3-rc1 here?

> related to pgtable entry print standardization posted earlier.
> 
> https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

This applies.

> 
> https://lore.kernel.org/linux-mm/20260901065454.1906343-1-anshuman.khandual@arm.com/

This fails:
---8<---
$ b4 shazam 20260901065454.1906343-1-anshuman.khandual@arm.com
Grabbing thread from
lore.kernel.org/all/20260901065454.1906343-1-anshuman.khandual@arm.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
  Added from v3: 3 patches
  Added from v2: 3 patches
Analyzing 14 messages in the thread
Looking for additional code-review trailers on lore.kernel.org
Will use the latest revision: v3
You can pick other revisions using the -vN flag
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH v3 1/2] arm64/mm: Move __check_safe_pte_update()
  ✓ [PATCH v3 2/2] arm64/mm: Standardize printing for pgtable entries
  ---
  ✓ Signed: DKIM/arm.com
---
Total patches: 2
---
Applying: arm64/mm: Move __check_safe_pte_update()
Applying: arm64/mm: Standardize printing for pgtable entries
Patch failed at 0002 arm64/mm: Standardize printing for pgtable entries
When you have resolved this problem, run "git am --continue".
If you prefer to skip this patch, run "git am --skip" instead.
To restore the original branch and stop patching, run "git am --abort".
error: patch failed: arch/arm64/mm/fault.c:160
error: arch/arm64/mm/fault.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
---8<---

And as a result I can't apply this series. Any tips?

Thanks,
Ryan


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
>   arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
>   arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
>   arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
>   arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD
> 
>  arch/arm64/include/asm/pgtable.h |  6 ++--
>  arch/arm64/mm/fault.c            |  8 ++---
>  arch/arm64/mm/fixmap.c           |  6 ++--
>  arch/arm64/mm/hugetlbpage.c      | 10 +++---
>  arch/arm64/mm/kasan_init.c       | 18 +++++-----
>  arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
>  arch/arm64/mm/pageattr.c         |  8 ++---
>  arch/arm64/mm/trans_pgd.c        | 14 ++++----
>  8 files changed, 66 insertions(+), 64 deletions(-)
> 


