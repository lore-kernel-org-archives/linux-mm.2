Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A538DE8784D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:03:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC93B6B00A5; Tue,  3 Feb 2026 12:03:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74D96B00A8; Tue,  3 Feb 2026 12:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA19A6B00AA; Tue,  3 Feb 2026 12:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B5C936B00A5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:03:49 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D62359757
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:03:49 +0000 (UTC)
X-FDA: 84403767378.02.ABA86EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A9C2D100003
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:03:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RdxzCnvF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770138227; a=rsa-sha256;
	cv=none;
	b=x+eMIBIKxfDsf0ThvXj7MvvHTheimNRK9RVrksl3zjqNjllPgso6SNXCrzMkkcARgPPLDH
	WwvVcCVQQrNIR9PFqxlQuL9uv8/rRKhd7Q3Bmm5M8E3Nt+c3TqXLcahaN16dFiKWPa2Tbd
	nH/1JhLf3NY/nLxRt/2WbU7ZKWZC0Is=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RdxzCnvF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770138227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZBIMWogOdg/RnmZ59uwk044Dba8AFr35GQKwqqE3TY=;
	b=ywxAFQOq5Ka9MDCpvSHpaL/1to5pck1B1Lga7HbnCIhMaPIAC08HM1M99pHJRYyZPNnzAe
	7Ho9MdzLBbO64UvVTvum7u+ZUgoHjUR7t1i3+ymMrcUMMDCHE/LDKsEJ29rdAJU7pOtHNc
	6UKX0B+aTCxokBueck39rh4sarUa2YQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 62A8C44193;
	Tue,  3 Feb 2026 17:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 078B9C116D0;
	Tue,  3 Feb 2026 17:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770138226;
	bh=Rz1ZH7cwBMEcc8pY8rqoH/bXe+tMJW7kk/yerwU8P9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RdxzCnvF9/9K4BIJpoa4VFdo4EKLFQj2KonO3t3fqpBr9IK0kXzCg6LjA/+5GGC2T
	 CQFWYMMuYHqoTe+KyAXloSkpg5xjW1qvQamKc7clWJk17XPU4SESQ/zFYvHtWWM8Z+
	 5/JEHZRh/JQCh2bbcBSJqinQi22QzstH+GvviE/nFDvvrdWYULyVvbsYFzLO5IapCO
	 6aMeCj4Lx4fPfKJ9/xcvYcgxpD5jlQ0rSbOBYJxlf2f3c24f/Yp0jfp7wGH886EjCi
	 JdGkipBOLrN6nQZlGFssROtYbt4cXeXH58eaFpL28fYRKDRVXb0rKFMntOkiaG9mN2
	 7HMNlpf1YzyOQ==
Date: Tue, 3 Feb 2026 19:03:39 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 0/3] Convert 64-bit x86/mm/pat to ptdescs
Message-ID: <aYIqa6jxn0TnpuKN@kernel.org>
References: <20260202172005.683870-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202172005.683870-1-vishal.moola@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A9C2D100003
X-Stat-Signature: rajbd3bzy99nz9k887iwgx7pat731rqe
X-HE-Tag: 1770138227-946672
X-HE-Meta: U2FsdGVkX1+EFiBjha1V1KbUsN4mraTFyV7fJyHSCZSn0rwx8rxngiwHVKFjWc3q4ZuzcQJYGPakGhm3o3znnaVqloeAI7JK+zwCPtS66BlTaQJKOwqVzzykd03ynHQTf3H/nuvBtWf+On+eXQUcBEA7qvoQsLse5xQbKf3E1QHuE3HmuFa6f9yM0k5OR7tvCK9VgV/7LjfqkQvUu498VtGA/eCwFTlPXxzDtkHIrX+Ux/72xZQ1bIZZniMFpn/KZMfwPVoh334pvK6VcyEp2EtLqQocMk+6P3ZFN++zmDyId4Zc8nDoz4tPXVvP1F8sZjEJipQVnmpoSX0mitJgCK6+dRsV1jj6bbt07Fd0zzrqXizqeRV9nhD4sdGSy+NYHk83s3IzEi/QzDrhe1LCV7iCOuvJMd+9s0ahjgwUxY7kZ6o9h6WUvF/NHGegxyZf/+kHk6+COBfob6BxkgYHaRBylzDbEY20xWVDe3KgW5xpvg5xJSW8drJr7UYixIk6xLU8a3cuNGjWNyctWlx/Gfzlp8kVPYsWqcuCJEsQ0eV4OPiyQ1sW6j78+2ldUF+6bFIrk8XZ7RZ9/WIHoEbo4BwFDB13eT8YmVieIubURCs6sulOMcAdmy2dnWXL28mbZ1biQ7qPINsKXwtIj8XNU8n9rikErQQ9qhlgufb07AIoDgDANckN1me1BCZplaFfSNfEEc2jgQRGCMBbYeR8aRdjswWqBdRS6Hd/DL3ifEqHzyyxUwXHOdcTfwYrp8I2kSTIx24VUztxWajWieEKViq1XbukY6ODY1Dh8pHPAYEzCT7DhN4/i1YdTAvD1cXv5/1BvEmUOlpp1YCYUTwAqhTGrXp5tlD8eiJqrW9Oo5EH/5B8QuFsMJKXqMV+lSLziLx+NcBIJ8cEOlyedEvzjEGoMphjgJjByuQUxYpZ1HsIBKOfoK1+0kw9PtWw3vNvptVXzYc4mG7sMqHN/kL
 UNP308B/
 p3qeSoYzk/C+x1nSS5SncTe9H+FDCGZVXtwg45u8AR/Ti16ABIq10z0atU7mcHt8y4Js0mFEHDU35/UGQz/PeX57Slhxm2sDkxOcsMgvgnKKPdin7ktUN/wV5ajlCGNSJLiIkv9iDJbDoYzv1gymeBFDb2ECJuHXeCc0KiBNHZBIo2O26CSl1CUiVXt4tqZrHtMAGKm/EJsyLBqVSZYrlTrqRjPVONGMy6QV9aLo0fvyDo4US/6p8m4VIYdBSLMxLyWLYomcwSfGqnS19RgTU/TYURaC3LkL7AM0kgjUKn8n6VcSID9Ge2XE7gRyYPRyR4rZu5gqxBAk+UZOWlbpAqXMNCTYDPq342Hki7XW8AG8vcEk7rD6u7PI8grbFFsSCMdCYF6Sq0ih2qINRcctnqxpjUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 09:20:02AM -0800, Vishal Moola (Oracle) wrote:
> x86/mm/pat should be using ptdescs. One line has already been
> converted to pagetable_free(), while the allocation sites use
> get_free_pages(). This causes issues separately allocating ptdescs
> from struct page.
> 
> These patches convert the allocation/free sites to use ptdescs. In
> the short term, this helps enable Matthew's work to allocate frozen
> pagetables[1]. And in the long term, this will help us cleanly split
> ptdesc allocations from struct page.
> 
> The pgd_list should also be using ptdescs (for 32bit in this file). This
> can be done in a different patchset since there's other users of pgd_list
> that still need to be converted.
> 
> [1] https://lore.kernel.org/linux-mm/20251113140448.1814860-1-willy@infradead.org/
> [2] https://lore.kernel.org/linux-mm/20251020001652.2116669-1-willy@infradead.org/
> 
> ------
> 
> I've also tested this on a tree that separately allocates ptdescs. That
> didn't find any lingering alloc/free issues.
> 
> Based on current mm-new.
> 
> v3:
>   - Move comment regarding 32-bit conversions into the cover letter
>   - Correct the handling for the pagetable_alloc() error path
> 
> Vishal Moola (Oracle) (3):
>   x86/mm/pat: Convert pte code to use ptdescs
>   x86/mm/pat: Convert pmd code to use ptdescs
>   x86/mm/pat: Convert split_large_page() to use ptdescs

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

With some minor comments in patch 1/3
 
>  arch/x86/mm/pat/set_memory.c | 56 +++++++++++++++++++++---------------
>  1 file changed, 33 insertions(+), 23 deletions(-)
> 
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

