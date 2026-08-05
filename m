Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77A4CC56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6628F6B009B; Wed,  5 Aug 2026 06:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AA96B00A0; Wed,  5 Aug 2026 06:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552286B00A1; Wed,  5 Aug 2026 06:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FE686B009B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:42:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 129C2803FD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:28 +0000 (UTC)
X-FDA: 85066876776.06.C44A843
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 094B412000D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:42:25 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ai1MPx4+;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785926546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4K8KezGj1uNtUBla4Um/QhzlQ9Qk/rg7DVPoMDL72Q=;
	b=UhhmFE/ztZSsjL9gRagmHm9/u6cGRL2yfT5zwOtu3dUKAlo4GNqhqBRmlsaSqknwdoNA+9
	bviBt+/G/DbNMOc8k/4K6BS8sOg8pnJANhEtRrdfXTQRU7lqY2KmVyx+0XNS3qnFOnNoCJ
	17ck3YAxo02vp8OJqFkwsrVUeuWCpAE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ai1MPx4+;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785926546;
	b=u36y5CfzC/IEQEwR0TKjsf4thU4OZJa2o5av3A85nsObmFdYXN3tHNIrfN1oQgX1a+7NrM
	EpOYvNTfkevIBlPDOdqm0SEeXiLlPxv2vopBIbhAauT+eneWp+89t6MilTMrLoW4H6Txm8
	RTS6Lw2pYNWOj9UKCVhQtKs7KUxHmD8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA2D2153B;
	Wed,  5 Aug 2026 03:42:20 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2E9F63F632;
	Wed,  5 Aug 2026 03:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785926544; bh=dLnCHFABrcZb/4lMb8OKip2XrApMrTNt9jLEKjSti1o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ai1MPx4+Ir9VhFeH2HWxjevL9kszGJ6grspTTZUKC4wtSs46+DRMHe7SevW8UESlp
	 nEm2r4W4I9DKOG0PZ90sfhgLuvCLZGB6e8v5MNNQqPMOIVLQnZJ/pyE+ZB356so1Ga
	 R5xoG9ECl/ieCh3WindUP/tPTEQ7Blav4otAFLv8=
Date: Wed, 5 Aug 2026 16:12:21 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kevin Brodsky <kevin.brodsky@arm.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] mm: add basic PTE const type-safety
Message-ID: <a5afofuxhzwkeb76jdheottyxt4mms3arg2iucunztczbmd3lf@wiqp7yccjzlt>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 094B412000D
X-Stat-Signature: u6kxj811znbzqgioj4pwj45ke66sx7wj
X-HE-Tag: 1785926545-618822
X-HE-Meta: U2FsdGVkX1+L4NSZNOzMkXs07cXeUBavWpS42vJP80E2xN1nWF+H2rAnKYRPaM9QL5ChTjpfVDPzEs3rWYNuy5BiMBQPMgzVMfLB/i6aKzCa0VxJs1KFH3XRjvF65gJhcqu9TZLR+k6E9i+GLwhlQvpuPRIYaZhrCRS0AwgkvHrKLrPk5aY7cWBrkpF4ru+yOlKT+ytHkHUj0mDfxwsW2Z84Qj7gtDrQ6OItLUV7ScWsH3A+MoqXcS/zuOSr47Q5fpa2Mdqh8IrtiteRvvdqBvmYo6T5d4D/CcT+u5L0V7YHplJtLTlj5XZ+jqBtXTnNVGQvI1FukXwSmZ/IU1qpGXblU8XkMY1zSNFouoGwkO5ZycT9BQ268+hZt0rTnA+vQsn59d3LsGT2OjtrdGZ51ygCcBhh3pLMqlL8CNMqu2J8OcwagvMn2spzWg10AM5bqpYkvHCdPpSREoUsU4DbM3LOcjKnj9WVdz6c0MeHIRiAkXFjniDvoO2gLpn0U7eM5IlN+hFzSJ8uOQ6DNbi3jt2Fta+nUvuKNto+1pNwT9tbHGIo0gBJDzCq6o4dZFUD+SaSxd8UACUr01KYBhhLO5oVAvjmhytl6yLV0YGgRajxMgqfE+IZZSGk8PIoJpv/g9gnnfIynuXl9WEo5+lCAZSssVOBr+sb2hJ+rsIyiwsFIVaVzYRuhZGyexVwfPsvWpKitFBajFiJenvKWwQmRqIMReErFT0ndA/PNyGOzW/mFlHS1yWvKr0Hd2ftomYNYHmnpbMCPbCWy3CpPUZku+JZ0QNOy2lLdlmdOobtovwXCYz861eVr7IDHEve7imuxvljC0AVqP5Gi59rcEQ6G4seeO4U3ijccDMK/lmYb2bXF10MBB4m6jht4+K54H8Y4BwyEdEMH+kAejbVZ/CrT3ZFR4gG8w82siO6aXNRWRohvZKg/Rk1KpxwPy7kvISxfmFy/HnyJiFtWk0cMj/
 gp1S7T4x
 scg7Y8v3ABeS+L9GLbRI/qIaacrJyMvKW4LTm6C2s7XXbNPFZq6/ZtxDEAd56t+USHe3racbCW7DPIIPmZy3MrKddVZ0d36ZcCIIro0vEDuBIEnl/dTMyIUg8M1njBCvwd6fnZCuZ9TswOYh4Xw85NksXijDNzfchlGQcCmFJTHodR6Hgvkr2Mqz1kL0qsS3vmaHonOYEMW8N0fo1ZhZf5pmyrOGME5o78H5y17hTgGuctS/nu0cS+5GDNLXHSrLrSHzPZ42irL+lRvmO2AU0acPnemO11zHufBoXgg+tFeSKmqotYr2kmXD1guYZoDRr93zggc+x7Y0nbvk6373OorBsyWHgZpKwb6NrqdFbArJh2E1ty0MlOkig9lekY+u1F+Rz5S3syfPRcS2C3UyZnb+pNtBwvGQYtlqs2WRuMOQQb7ozW0hAQWhDR+kXvYx6y6YnS5HSeMKl5GrAjVbcJ2TEGBzimhAGj9LSO9xwEXRyo3DgVSDxMLSSBXJXfgaHC3sk9ZHoO/e/Wcb6OUwhVxgIY6r8WFA67G7sTZ5hkFrnTKpuSj6xgOnNOVOdbMk0HNxbAU/e62iSXW5TtPQeQEFIhxtsnbzBmKlqLSuYaxuKVwXp9Bhr3DWRfiOABzCxvOwdae751EfmE4dXfOXKB/ilEKM65GZjUp1OjWiTV5KPUxjM605pGOex+E+zIYf1di+yf4bqw6OqRV91bU9K6xVM03LCff7IoB0/c/XssQzsYyLTU4QG1ON6raA/L4csMztZ2lxBsWE1Wo9DBPyA2pntcEl2cDCs/5M7h/T+zlauiP9lZQq25W09BAo10pfphoCjsPHVNnXOd3Emrl3B7xVnHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 05:43:54PM +0100, Pedro Falcato wrote:
> Since forever, MM code has thrown pte_t * around with no concern for const
> safety, or typesafety of any kind. This is confusing. Attempt to address it
> by:
> 1) Making sure pte_get*() helpers can cope with const pte_t * arguments
> 2) Constifying the pte_offset_map_ro_nolock() return type, which by definition
> already pledges that users will not write to it.
> 
> These two simple steps were already able to uncover code smell from
> khugepaged + do_swap_page().
> 
> Separate steps could include introducing pte_offset_map_ro_lock() for more
> widespread usage of this.
> 
> Benefits of this include less confusion and better type-safety. It could also
> futurely aid in efforts such as [0] which may want semantic annotation of these
> accesses.
> 
> Based on mm-unstable and compile-tested on a handful of architectures.
> 
> No functional changes intended.

Even though the pte accesses should always be type-safe, this series does
not really address the problem completely and instead changes things only
for a small set of pte access sites. So just wondering how much beneficial
this series really is ?

> 
> [CC list editorially trimmed for brevity reasons; apologies if you're not on it]
> 
> Link: https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-0-eaaacdacc67c@arm.com/#t [0]
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
> Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-mm@kvack.org
> Cc: linux-fsdevel@vger.kernel.org
> 
> v2:
>  - Small fixups on the arm64 side
>  - Re-order patches in a way such that bisection is preserved
>  - Pick up Helge's patch dropping parisc ptep_get()
>  - Constify s390's ptep_get() as well
> 
> Helge Deller (1):
>   parisc: Drop own implementations for ptep_get() and
>     ptep_test_and_clear_young()
> 
> Pedro Falcato (5):
>   mm/arm64: constify pte_get*() and contpte get logic
>   mm/powerpc/8xx: constify ptep_get() argument
>   mm/s390: constify ptep_get() argument
>   mm: constify generic pte_get*()
>   mm: constify the pte_offset_map_ro_nolock() return value
> 
>  arch/arm64/include/asm/pgtable.h             | 10 +++++-----
>  arch/arm64/mm/contpte.c                      | 11 ++++++++---
>  arch/parisc/include/asm/pgtable.h            | 20 --------------------
>  arch/powerpc/include/asm/nohash/32/pte-8xx.h |  2 +-
>  arch/powerpc/mm/pgtable.c                    |  2 +-
>  arch/s390/include/asm/pgtable.h              |  2 +-
>  include/linux/mm.h                           |  4 ++--
>  include/linux/pgtable.h                      |  8 ++++----
>  mm/filemap.c                                 |  2 +-
>  mm/khugepaged.c                              |  2 +-
>  mm/pgtable-generic.c                         |  4 ++--
>  11 files changed, 26 insertions(+), 41 deletions(-)
> 
> -- 
> 2.55.0
> 

