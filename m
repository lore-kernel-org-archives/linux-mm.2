Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E5C60A260C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ct/g+c2T
Received: by kanga.kvack.org (Postfix)
	id AFCF76B05B5; Thu, 12 Nov 2026 11:34:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD43C6B05B6; Thu, 12 Nov 2026 11:34:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12326B05B8; Thu, 12 Nov 2026 11:34:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8166B6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:34:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BA98C0646
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:34:48 +0000 (UTC)
X-FDA: 85427015856.02.171B042
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F230120004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 16:34:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ct/g+c2T";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794501286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fM6KLKOJO3YyJn3UQnE5Pf8Vkdal0xJx57r6jbj/dk=;
	b=MJ3pcqhBCiw8k4L7lFqppshVqXiNbOkB/lig6YpUWPergc3XV5lGHZRV2f1TV3ZD8JMyMT
	HhO5PzpfPEipc3+76Aued/A+xQ2BfdIVNWW+n3O6ve/KKDuEs4Y8jyMltKGWKMgqcmH0nW
	LPitiMNkwBVpVz4KEQUlzFsO5aKHSEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794501286;
	b=tgUMyuEiFYsCQnM6rNSptL4ortcp9SPGPK/DPiHaW3SwwwrNQHZrpwzUWhH0XWO+oar/nd
	AZbc40wPo2LIdq0Xgn/lvQitMF/0zERVTEd3qPgx5rtl4CeTnz1TBPsaQJ/8M4rvrBIa/A
	W5p3eFSq2dBRoK5xr0OHD2d0WNmkwAs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ct/g+c2T";
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D33FB60E12;
	Thu, 12 Nov 2026 16:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483081F000C4;
	Thu, 12 Nov 2026 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794501285;
	bh=3fM6KLKOJO3YyJn3UQnE5Pf8Vkdal0xJx57r6jbj/dk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ct/g+c2Tav6x0NHCaTpZEnj2FLRtf/WNxdWzWyAoIN3jDV8HceQCz4uJVhQvhMKZH
	 a1wGEhp69gapxoQ/mo582ztvpDrB9RM5HjVKAE9mnDVqKK6ZU3ROfLPkOjhrl7d9JC
	 igX4MeEEzW3Y03hNnIHyDmFRyYP5JMG5z7yK/GrwwNFyu9uGYK+Y4JyEJCbAuKFtVN
	 dMJ45hIGPWvSFbo1nA6/VWM0O9A4ayD1/1uaSumIo2n0EMc9cTU0mxejjUT7Xp+pMJ
	 hD0cu8eX9Aur0yDVWwqHo8kcHWguW8zBEsyHM5q+oIXHzTGigLF0QQcSVWo3Yocg/+
	 oBWFOeJDlEusQ==
Date: Thu, 12 Nov 2026 18:34:40 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, apopple@nvidia.com, balbirs@nvidia.com,
	david@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/2] mm: optimize HugeTLB bootmem hugepage init
Message-ID: <avXqoKO_5_tPRZ4g@kernel.org>
References: <20261112112816.55095-1-lizhe.67@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112816.55095-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: gjfautsp1ieteitaxuxd7i9nnwyikb9r
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5F230120004
X-Rspam-User: 
X-HE-Tag: 1794501286-355408
X-HE-Meta: U2FsdGVkX1+4wrHtLhzk69vpEMt+Lk0Yv1RVVJOFwNZ3qgcjASNDszYdpCsOzIM8mOoXF/IuGiskocP6SuaFU8vsLoAflb7fffhImO0HK52D3r5j1vocXnaYidJzz3r8uilNSa2X5JcMOeX2UDGMhwmePkTndFx/rs/N9mEB0VbsSryKHuvwpD8FpSSM8iCX/hYmbWpH/a/i6hFm9R7n2tELXXMsy2WuFjt2oaZlN+IJEOzT+8dzIaeKA1jRyFz0Xft/aCTpmjm5wCklF2J7uj1mvA2hZGW3XdqlkQniy18CaEemT4hWkLiDgrGSS01htiyXf7CrIS1FU2as/XNuyQoRpZPwM1qyaYKAi9bFt0qMIOVxSfA7vxxQ8OatYulCs8fCSzDFO0a3lvd/YKuvsEglTpRxCKo2p62pAGHPHSNS33mPiBkRdshCsqdvC2PH8H2MbD/X0Du7AEDYigulW3H9oF8KdCPSM95XXYLAW3Ab5erW5z9dI/kUBD9rQRgLCHiL70EkF7ZrEtzdTQVbCX+NnvmDYXA3RaPo+3VpzVkBwwjxQI5puQS81JURbmj3El5JnQmNRrf6XwihI/g+t5dCeO7nx9nTekeuNyRnWhgqhNEpU/jzOCVVdBwQdzEk6OnHRcC/uhseDDylfpQYVAIuUSlpOkxW5bypBArMr51/muZnlWYKL3OT7Udw5BuwkJ5cloZOxGo2g9vP5pk5m1DIiEiOXfDCfy9uFgyZTs9seBdK5lkV998MnD6njw9C6t2PCSp7Il4nHjkHTX1iem6z5/PhYG+ib7gf1phADGl5eQjS341bH7J1N+m/BlDO9Mgo0ts0eqBgZk3uPjgpARqz1k80Zy7iZ6QQPa54eAU3oqWaIZDwUB/5jcqDOa1pdIIgQkzeByhtmqoJ3LN3VzOQqLJdDM/Q76CqVpRiFkY4qH3p5tV+NyxWGXksOa1BV/w5lqIHYZyeZ3LxGao
 ngaL2Ae/
 514Kn5F77SWk0Axi8dBZFFe7CGqp4RBKKOwEoE/UOqTXAGazmG0EZQX8w/vcNG3oWOOKdocDGSmSzWOE0pATMlTf5WaBIeFJdwUoTiT8De9tCzCtgL0Ah5kInWcfoNNtnDczpHOthYv5zPYH/rwW+Lwvm+n/8MP+ch/yJ9sZQkwHR304inIKWY5/vo5me8R6qqefdGAKxDJ7hPsyUPdlWjqfr0ux45gRMulWX6jDw3t6wPcNq7spcN1QQrUdziVsZLp04
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Thu, Nov 12, 2026 at 07:28:14PM +0800, Li Zhe wrote:
> This series speeds up the fallback initialization path for HugeTLB tail
> struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
> optimization (HVO) is unavailable or fails.
> 
> Patch 1 factors the PFN-dependent template refresh from the ZONE_DEVICE
> template-copy path into memmap_init_refresh_pfn_fields().  The
> ZONE_DEVICE path keeps its memcpy_nontemporal() copy primitive.
> 
> Patch 2 adds a HugeTLB-specific copy helper in
> hugetlb_folio_init_tail_vmemmap(): initialize the first tail page
> normally, then initialize the remaining tail pages by copying that page
> with memcpy() and refreshing only PFN-dependent fields in the destination
> page.
> 
> Tested on a v7.4-rc2 base with 4K base pages and 64 boot-time 1G
> hugepages, measured with a temporary jiffies-based printk.  HVO is
> unavailable on arm64; on x86-64, hugetlb_free_vmemmap=off was used to
> exercise the fallback path.
> 
>   arch    base      with this patch  reduction
>   arm64   360.8 ms  256.0 ms         29.05%
>   x86-64  171.0 ms  165.0 ms          3.51%

Thanks for the numbers!
 
The changes are fine, but since they are going to be merged into Muchun's
series, I'll wait for that for the detailed review.

> Li Zhe (2):
>   mm/mm_init: factor out memmap_init_refresh_pfn_fields()
>   mm/hugetlb: optimize bootmem hugepage tail vmemmap init
> 
>  mm/hugetlb.c | 23 ++++++++++++++++++-----
>  mm/mm_init.c | 11 ++++++-----
>  mm/mm_init.h | 11 +++++++++++
>  3 files changed, 35 insertions(+), 10 deletions(-)

-- 
Sincerely yours,
Mike.

