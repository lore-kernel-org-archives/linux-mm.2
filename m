Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 598A3CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C50F8E00C7; Thu, 18 Sep 2025 03:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8762E8E0093; Thu, 18 Sep 2025 03:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B7C8E00C7; Thu, 18 Sep 2025 03:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 64B758E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:37:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 254B213BC1C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:37:57 +0000 (UTC)
X-FDA: 83901566994.29.3A847B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5CDBF4000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:37:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758181075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PGJbPdY0/ky+SaDe3WA5fLfzhl9ficxgVLA3dvDna6E=;
	b=naUh8Tf5MQ1Atu8xNNpV38c8RcLW7Mjlic6So7lWzL62Muw3carb5AOAzvEIcPtBzCqxnU
	LfEqTIejcjUS8VIjgmFZn9EDrCetyEgpIZJaEjwBLwNORmrRB3YKig20YRbk2DQ/0m6rUl
	2fJIYwQma9T/zgcrrbmROY0IU1USwJo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758181075; a=rsa-sha256;
	cv=none;
	b=U9jzhMw9GMBFSvFsG1W+K6jWLydZ6t7b7YP0KmtWSmXXZwOKs8VIz6HioK9B32Xz+n0Nhr
	0bqIo4gL4X1a2KuC3zx4y3NIxYv7Rv8ob3g65x/fu+QEBE6Md/0zHF+Imi0yO+0a4EhE+z
	Mwg+eued5ElP1azYNtXuWEV7WrqTrQ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E00DD1A25;
	Thu, 18 Sep 2025 00:37:45 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 71EAE3F66E;
	Thu, 18 Sep 2025 00:37:49 -0700 (PDT)
Message-ID: <f6073afe-a604-485a-8cea-7aa08e46a0cf@arm.com>
Date: Thu, 18 Sep 2025 13:07:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
 mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250918050431.36855-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5CDBF4000D
X-Stat-Signature: enu5nmdix39pwbakx3p4hsikni3ap8hd
X-Rspam-User: 
X-HE-Tag: 1758181075-587376
X-HE-Meta: U2FsdGVkX18aQYZ7MR67/hhoPTkLe3uxlhe1Tc9Zo4oeTiGWEYZMPwVcEbufPMBY7nEq7JZKNGcWeR0vpDjTUMLgppDUkm3MIddiBApC6JdDWntM4B4EGeQ9igprkFVZxGs+zpyfXJA+FBi+8q2pq4XCPfknVvyPv0qpeNrbDVr+GDKf4L7QFTuSv/mSK7qmBEBv58v7kNmHNQEr8R2Dy2bWMfN5DckFcbRmT6VhwGO1sBltiZeUAIZBFLP62G61Y697kwMIFc7BTAY/qs057g4P6hbd3y2BpG3pemJ2OJwtEMLSrKd9XwXSHPcgYDIEWqD4AYq7GVH6Bu8IMpnlz8Uiq1l4zLihF71ZlDkAyQlLXBOHh1mhvH3NJBp25319BrMhvUuO/1N/WCC7ya/mKZFHPIxSU2GhcwDJ52YZGRq5HiJe2kKvcvsKBijpYwVZCdOTqiOMLVZOIhO13ZwFdqZF1mMvruMCfBD/mYxb90iNrqhkcnkHPjDJ9mCdkJq0i8MBShgBcwvahGUJj/qBoVN5s2wUSJyNtzIHF42xu8WzrwWk7kBkdu/GxDOdPHtdMyyKY4FEzjl3JzegQZmqAAUlrf3weix1gj7/7d4PzRFbHlzUQL+O9Qnho+G/0Yj4kI92o2wCz4aE1l8jcS0Sw/3MW827pAVVWS9IoEO/9NUadb5lt4hgXUw7QzcozaxVzyTDVGVyumfUY+Ha28TCLYRZPu+pGV0NuY5fBDAf48+ypznFr5QebddrUK5V46fugagHz1ybMaBm/E8IUL4CKSKCn78/GpY7/Nd7fiilUSjbMM7eBvDhakdlGDPth5Za9kpcaBUPtuxxjt0Zzt6uoB7/BEhjzD3KI8b20KZmvsA9z2Fy3616mhGkJDcWN1P9I8oR4kAqhAHONQYV+ANsq5GEJ3tsC1iACMIoq2pTt1R+H6WPizp03ipjvPsLo5ecxo0YDUrFoX8DmeuIlSg
 FWhptQUx
 YIgpCYFd3nk10p8YYtTuJLiInyNaiDPIkJYWdAsvGjx7mzE3Cm704KELAOp3UKcc5+k0ojNSIlm1jtI6QKqvfHfTuTY4fjbRU/H62T8V24/ncubfbUmHW7Og/q/mukGVa60ftLh2cm99yVyubUu8yNMKpMEk7BRBzmdiFNLB9tHiLOvM+k0zTiXdS/OMd9sWL0VIcOuHClkUFwLTRGKE+e0F/ar7CKLGspJHvdEcu6T8ke6FOcfqMT/WZGtWzK1MY8lgz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/09/25 10:34 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
> lightweight guard regions.
>
> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
> encountering such a range.
>
> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
> the special marker in __collapse_huge_page_swapin().
>
> hpage_collapse_scan_pmd()
>   `- collapse_huge_page()
>       `- __collapse_huge_page_swapin() -> fails!
>
> khugepaged's behavior is slightly different due to its max_ptes_swap limit
> (default 64). It won't fail as deep, but it will still needlessly scan up
> to 64 swap entries before bailing out.
>
> IMHO, we can and should detect this much earlier.
>
> This patch adds a check directly inside the PTE scan loop. If a guard
> marker is found, the scan is aborted immediately with SCAN_PTE_NON_PRESENT,
> avoiding wasted work.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/khugepaged.c | 10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9ed1af2b5c38..70ebfc7c1f3e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1306,6 +1306,16 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   					result = SCAN_PTE_UFFD_WP;
>   					goto out_unmap;
>   				}
> +				/*
> +				 * Guard PTE markers are installed by
> +				 * MADV_GUARD_INSTALL. Any collapse path must
> +				 * not touch them, so abort the scan immediately
> +				 * if one is found.
> +				 */
> +				if (is_guard_pte_marker(pteval)) {
> +					result = SCAN_PTE_NON_PRESENT;
> +					goto out_unmap;
> +				}
>   				continue;
>   			} else {
>   				result = SCAN_EXCEED_SWAP_PTE;
>
>

I would like to hear everyone else's thoughts on
https://lore.kernel.org/linux-mm/750a06dc-db3d-43c6-b234-95efb393a9df@arm.com/
wherein I suggest that we should not continue to try collapsing other regions
but immediately exit. The SCAN_PTE_NON_PRESENT case does not exit.


