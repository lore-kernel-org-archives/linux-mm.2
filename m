Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE3BEC55171
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 23:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52DB6B008C; Fri, 31 Jul 2026 19:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A5F6B0092; Fri, 31 Jul 2026 19:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9680B6B0093; Fri, 31 Jul 2026 19:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79E366B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 19:59:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DE161A01D1
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:59:40 +0000 (UTC)
X-FDA: 85050741720.16.C2D04E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8B2E8160008
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:59:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKlE9Vcx;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785542378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XA1kKM3E+TpKdyNI13D9hg7MTBUHQOPfee6xIaIE/BI=;
	b=aVJAOTIKRhM/ZsOpFV1OQ/a83DLDlJwz1/mDmTRwIAckkTy4hUc38K+x1aM7Vqetk6nT7M
	U57HUdQvpqogsBeY1T5Agu5xn1qh/vzVJ9ktwALpnh0hlTVoehBbSY9/RQVGWJL4f1NHNf
	pc5zTZzA8fLJ0+5OLIsM6cbnI+v/Q0Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKlE9Vcx;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785542378;
	b=z91G0QeroDVl4dRJs9lJWh8ZXZ4kMBgmKc1klbsxEg1GdSdcym/ZWgDVwM8LqWXI4A9DHN
	a6gRN7u2CJzmGkDbWNisxzW7J7N5ax6rXsF1Mh4hKxfL6U7lE2oMKc2ht6ZIPiPSqicLtb
	xSEeyexh90ZVecQokaSvGVP4Qzr66pU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0971437D3;
	Fri, 31 Jul 2026 23:59:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943BA1F00AC4;
	Fri, 31 Jul 2026 23:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785542377;
	bh=XA1kKM3E+TpKdyNI13D9hg7MTBUHQOPfee6xIaIE/BI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UKlE9Vcx+ibmwZLg8uTgDhwFr1MQKvh4COZdEA29Zk4+a0WEHLRHV+s0GW3A7iSHe
	 3HD4/3g/v7nfvJumkgVcBV6bvBu1SfB7gaIyD4dF2MbygEzfAackvuElPeKYN09ozI
	 vNr2sH/bIqJTIJ/1Sh8QjXQC23L52Z4YVCtA2hQVxOb8dltXl6qMLWG7NCwcIO0/qd
	 Cd1Or+kj2bGVCdnHe9tbzDuwafP4AW8GXLqzKcY9q8OjsvcroCAcjGJeEecCteY5vk
	 2NzvhxfvKva7KE8T2F6nN/SVnRI+4YH8G/vz9LxdcQS01ioUBR5erT0qJtsRngShCP
	 EDSvUcG27ePBg==
Date: Fri, 31 Jul 2026 23:59:35 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 05/26] x86: move PAE PMD preallocation defines to
 header
Message-ID: <am02PmF4-lPErIVd@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-5-6f5729aa9832@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260726-page_alloc-unmapped-v3-5-6f5729aa9832@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B2E8160008
X-Rspamd-Server: rspam01
X-Stat-Signature: k89x5ipthnsi6azssbkzyiahu4saq4pu
X-HE-Tag: 1785542378-633832
X-HE-Meta: U2FsdGVkX1+iRyjA1/d1UJFMcsJu17pHr9WX2SfHEBDllTxYA9hdI1D/HxVsP144qMrZvWj0hcCZrg8FLwXDvTIKYEuEgnCzAe+EXDM+ZrBykfCaUY1vHBhmyY2t9Uha3ayO73BBgYR3mPwmt+06//IcveEZUcUs//6fdbc/yHftTNcKvPaI5n+RhdMKUUrUt7G6mAoYB2Bkzm9IWifIpdlDvvstdLxC91/SV523JTnRAVS2bYP59LiMqJrHXLpScAbKEn3XNjqcLpws9Vg6bdduKt8kEx4xRgdjLDhLPdTcvuFSfyJycMhFeWvxkAl4atTh+UUpABQ8Iv/PdoeOo+XvzQGIRuh/7+gsU14aLkDrUbGvjgn6M/A7CtWlaa6dHOPHva5Pn/L6dU9AnpJRjwWe+QLJL4LWdhW3U3SThFuFSZddJ4k6lZopa5s/gYtwrDKluFfNr8QrHCBDPbrMEi4292lFTWEsuTWlzcbvo0YdKrnlnRvRBADZKXuUMZxpuUHOP0TMs9eYPBTqUkR/eGnJBiR/PqFLqxZ+O3h2wjFk4fsU8WHNOfzJzNRa8BKKZQ6c7mW0vpbO7M2kKi0el7JzUps1lvAW1ThfoileupzvEjCTwI8YeelUS/n9FNwBUqjZcBFvaIVayNNII5+61uXJEYNHMzP6x6wY6qdTAJivEmZOhXjrQd2LeyHnIGW8DpJ5+S/2RqMeWqwxC9DIEhYwZRtSYnDuAue5anN03gUb7ZMZM7dw8+pLyOKJykoH5h0UtfO4V0hbAHPLgduwW8e51wsvPNduclgRjqKovCP7P3X4KZ+r7yM3lLoP+kpTv3lQV1iqzroiZhyXvRlu5phOmli6i6l6QUNrbO/xNH9MiyOw1Psvf+juM5DJwlfs4oSJZmNZGQE9kOAKy6lQRMn1jn/SG0xzS5pzuqBmnn2qic6CIB/nEEvOGj1gheW1DiSLqU37oLm6FiQgTVs
 gDPCaE2G
 cpTPRCjG8NOlr+ZrbrbXP2sORPWH3xFuUoGWHYojacytEHAgTJ8zG6+cutfN+j05TMKQJnFeRZHOMpYxeY0D17S8LWoSK7HRmAKoBuJXT0FgIWSwI6e3iC0kj3pdsjQRTOS0QNDryV8Z5lD/dz57IJe6NXlGJdCEGw4PUXdoXW9XT0/C/X+Yr/EHU6s/uI+Zn0JtWyRhIKhX64gY/64KLr3Y9nl7n2N1rR+HASYC03BMFMTozU40WCxtY42+tOrbg7IuVj753zbBcZDtJ2BmXPEbHSyIoVpWjUC+E/++f5fYOOjYWBq6WcZj0bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 10:22:38PM +0000, Brendan Jackman wrote:
> In a subsequent patch these defines will need to be referenced from a new
> file, move them as a separate patch for easy review.
> 
> The comments have style violations (personal pronouns etc), do not fix
> them as this is just code movement.
> 
> No functional change intended.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

AFAICT, this is only needed to expose PREALLOCATED_PMDS for
mm_local_map_to_user() in patch #7. The only usage is a BUILD_BUG_ON().

I wonder if it would be more preferrable to keep the definitions in
pgtable.c and add a runtime check instead in mm_local_map_to_user(),
something like:

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 09b8d8e6a56ea..15055cb80092c 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -268,7 +268,6 @@ static inline pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)

 static inline int mm_local_map_to_user(struct mm_struct *mm)
 {
-       BUILD_BUG_ON(!PREALLOCATED_PMDS);
        pgd_t *k_pgd = pgd_offset(mm, MM_LOCAL_BASE_ADDR);
        pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
        pmd_t *k_pmd, *u_pmd;
@@ -277,6 +276,9 @@ static inline int mm_local_map_to_user(struct mm_struct *mm)
        k_pmd = pgd_to_pmd_walk(k_pgd, MM_LOCAL_BASE_ADDR);
        u_pmd = pgd_to_pmd_walk(u_pgd, MM_LOCAL_BASE_ADDR);

+       if (WARN_ON_ONCE(!k_pmd || !u_pmd))
+               return -EINVAL;
+
        BUILD_BUG_ON(MM_LOCAL_END_ADDR - MM_LOCAL_BASE_ADDR > PMD_SIZE);

        /* Preallocate the PTE table so it can be shared. */

