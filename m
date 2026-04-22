Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B17F9B60F
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6CC06B00A5; Wed, 22 Apr 2026 06:32:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6E26B00A6; Wed, 22 Apr 2026 06:32:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11E46B00A7; Wed, 22 Apr 2026 06:32:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0496B00A5
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:32:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BB89BE2FB
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:32:27 +0000 (UTC)
X-FDA: 84685827534.05.94412AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7582D40002
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:32:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776853945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EBLRoguYPTJkYc4j73JHc0CKxdjDeJCctv0xDRPaXgU=;
	b=ik2dap9g5JRaCgbZEly46rAlTPH9HA1W0wqSYcjc+ao74YTszcqRox36l+nkCVX39ytDk6
	N4uwJbt/ESGpsamr3xZjnfsFMTLI0s4HIpDc585rtlk9RgauTAtlVgXIV+F3bCZxIjTok3
	dWaSgn4GaArGwFszMYMoo8LMdptz7l4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776853945; a=rsa-sha256;
	cv=none;
	b=QKLiYk3YYG8vmco5QBaj3QkbO47IFP3PlLZxiZi9SgKp6KuhxPqeeQVyOnhNSkW3f0URPH
	3FWz3kgy7mMcD9giusg0QUdFdZsUUIkVjiY9dP2lFGLPJY80SlPlOXHEMxHL5AeydZqQKr
	PURSoQ6w7gYp3UO+huudB/IkuFbXgQs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7921540DA4;
	Wed, 22 Apr 2026 10:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19ABEC19425;
	Wed, 22 Apr 2026 10:32:20 +0000 (UTC)
Date: Wed, 22 Apr 2026 11:32:18 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>, Dev Jain <dev.jain@arm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page_alloc: fix initialization of tags of the huge
 zero folio with init_on_free
Message-ID: <aeiivYFfC_EfGuFC@arm.com>
References: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
X-Stat-Signature: jxt45n6gxdyreesya1ifebjnbu6enedb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7582D40002
X-Rspam-User: 
X-HE-Tag: 1776853945-460279
X-HE-Meta: U2FsdGVkX1/BM1pzwEpV5DBv9KyCZ5UFGyoZ11Ts6fl3ag+8XE1si1ZBYbYFiq09yk192WJMbKw1ajCyB16ct6DXRrZOYERLq4cXJ2xwR7frffVXUjcxoFzgNkOaBMs1uhS1OENYUNESiugmA35q8g8ngC6gzhYsOdln43V/rO2PVXd+uq3af89XvUKtaC0/PHg9WVLbIm5WJkZpuF99fvfkk4p+vCG4ZAwyahTU8ObRIlyjxQvyKISCJ5knOTVJ/f2fPpg9sLKcRtjyUt+3enx4/ZiwnqXhF5CJJhYyeYem9ohqqHLyt172GoOCcqaGCpLtqkOdZiWyBqXRHwt5NjMGMN84AwauzsImjacY0TDJqL2jWJJDGS8gzK4CIBAkToaLU0ArPTIhhqxuRn27DC9i/n7HxGivnpj3fYHybRsApASuxemXl4sp0JqvxaNgBETIGYXBIkgcuS/T7YYxnKScemG+G84r6GvD3uZpyioh3IEv+heSpo/LIyOYuclNPxeFllXtbM+WVFqOckvPHARpP+hFJ42os0hC9kcBOj6XVDOV9dkUQRvHCg3/0mdAOxCGJjHVPgmT0UCuP81QQd+qyNVp/fVQexiWdL1BKB7ouGXGg4+c8a6s5TKEw6oUHRjui5FFU4UKSaIXP4/xZgHZ4kdChY9YCirtRvncK+2X5jg/Vag8zlDBd9fX9UhySO42R0zfykI3O3Kyz+ZuyYdkTLBMO2MujhF8hmSAmGmvU6lhARYzn+y17IPh3dZq/ikOvJr0tL2aMbFVxDTz2QZPzdmB2QJtcjNQz4xzDRgqdC+mPRi28/Ei5DG3IOIfQ06y9pwBvPqaRUrAMacBIc9mAIuctJ3D+MiWHTjyX17ph2UpZfiWK/32sDqDK3ThpeOCo4eNWkOvXCuv5/63chNsaa5MSw7Q71jKOprS0oDOtKhrPfyeIa+/UxJifYOh265KKWR1Ngq5CX8KECF
 qa2hcLhT
 /zV7PRdTeJ0QECLx0hMGwBUvy2f3aP2NO2SbqgQ9UFS+mc+MXOpQLFl8CLN727b1t6abrgz9y6RmiMyk2Sw705+c/ZrAr9VL9z7TQgiPDIVQUNFANgufzJHHo/i54/AfWe5dI0s7oPicTcH1uh/TcFdi5mu2eDC7R0wqPJ1XqMwcPb4iEEfJB1ziFhW4GroeCNsyzk7xfFt6PT2TBt/GpPiLbAv0bWSd+f89Vw05rghmtpLZH5VnaAS7OVZJKGKFHVKehReCfC/EElHvdZPES7CWHs0Re17H4DwNYEymTdKfp2+reCyaPiLri8NiDX9fPUfAsA+0VA8JXsrk6gj0lKc+BeskNnT7KdoEIbycE5DQZNuTdcn+KX6UGHoX160DMUUvNsIjgmatsHiqvCRdvOywjOZ5mOCv+bzX0C5/37n98CXCtY+6iwMo4wPlKnJK1CFca750QWs023L92wjtNee6I2XYrPjGPNok9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 05:39:07PM +0200, David Hildenbrand wrote:
> __GFP_ZEROTAGS semantics are currently a bit weird, but effectively this
> flag is only ever set alongside __GFP_ZERO and __GFP_SKIP_KASAN.
> 
> If we run with init_on_free, we will zero out pages during
> __free_pages_prepare(), to skip zeroing on the allocation path.
> 
> However, when allocating with __GFP_ZEROTAG set, post_alloc_hook() will
> consequently not only skip clearing page content, but also skip
> clearing tag memory.
> 
> Not clearing tags through __GFP_ZEROTAGS is irrelevant for most pages that
> will get mapped to user space through set_pte_at() later: set_pte_at() and
> friends will detect that the tags have not been initialized yet
> (PG_mte_tagged not set), and initialize them.
> 
> However, for the huge zero folio, which will be mapped through a PMD
> marked as special, this initialization will not be performed, ending up
> exposing whatever tags were still set for the pages.
> 
> The docs (Documentation/arch/arm64/memory-tagging-extension.rst) state
> that allocation tags are set to 0 when a page is first mapped to user
> space. That no longer holds with the huge zero folio when init_on_free
> is enabled.
> 
> Fix it by decoupling __GFP_ZEROTAGS from __GFP_ZERO, passing to
> tag_clear_highpages() whether we want to also clear page content.
> 
> Invert the meaning of the tag_clear_highpages() return value to have
> clearer semantics.
> 
> Reproduced with the huge zero folio by modifying the check_buffer_fill
> arm64/mte selftest to use a 2 MiB area, after making sure that pages have
> a non-0 tag set when freeing (note that, during boot, we will not
> actually initialize tags, but only set KASAN_TAG_KERNEL in the page
> flags).
> 
> 	$ ./check_buffer_fill
> 	1..20
> 	...
> 	not ok 17 Check initial tags with private mapping, sync error mode and mmap memory
> 	not ok 18 Check initial tags with private mapping, sync error mode and mmap/mprotect memory
> 	...
> 
> This code needs more cleanups; we'll tackle that next, like
> decoupling __GFP_ZEROTAGS from __GFP_SKIP_KASAN.
> 
> Fixes: adfb6609c680 ("mm/huge_memory: initialise the tags of the huge zero folio")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

The logic looks fine to me. Thanks!

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

