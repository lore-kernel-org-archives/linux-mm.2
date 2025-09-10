Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E3C5CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 02:53:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E73326B00A6; Tue,  9 Sep 2025 22:53:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC9D8E0022; Tue,  9 Sep 2025 22:53:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E1B8E001C; Tue,  9 Sep 2025 22:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B38176B00A6
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 22:53:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 69A5813BAEC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:53:20 +0000 (UTC)
X-FDA: 83871819360.27.F2DAFCF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A297D120007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:53:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MF274h6e;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757472798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=as+LkD4yKxwJj0WQoTkHy12/iOYVkvqbtrxfhhnZqaE=;
	b=0Zcfi+WT93kj1lwN2l6jUVS7ZTZSnMfk9hYc4o2AeX48g4z285V5rHcpS1vvRlMX0b9xIy
	FwS5trOHV3xIrSNPXTjUWkRfeahw0sIab4H1iClattgU0imQ404JbLIrrLOoBmdBvpiroK
	vWSFYRNH3QHkLtCUk3nbRlS1rpZXAJY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MF274h6e;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757472798; a=rsa-sha256;
	cv=none;
	b=uiUd00Lfo0m0gtsLrcVOTSFT7+EK0y0WTexeGdTMT1iFpNXNwlb6JB8yWNedRyhUQ05KTm
	PpLuNVDFiHNKVO9K+qN1pjq74UymeuG3eGmyb4PKN7mDS5AVY+O1bsUIprKDK4wtqGUuCD
	KW3cGPDe4D1WTPz5jD1hDYyaxv5fHrE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A1CA7449C1;
	Wed, 10 Sep 2025 02:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4CFC4CEF4;
	Wed, 10 Sep 2025 02:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757472797;
	bh=GJ1MLCdme2x9qtynutCYrIHT4ATvii1OjG3O+Z1i030=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MF274h6eft90SnUARRBgSkYCpkeBr8kOTdZElVORVZFQQ8d03ixPeSXzq3Gwsm0TT
	 hzNwssYMRaTlqDrTPPLNlIQtqDnSUi+5XIc6w7CNpjG4oDlRbgjzewwgxrcEEZhCPs
	 OCo2bJYOWQlWwg+P7uGIvGeSwvCTOOVBoncaM9owtcdFyycl1AvCqeNm5XERvLgbmI
	 WC+az8697a/hHeHRG3PQKwoUGE1tDTb4VQSW9g52fbLBI7jgAx7IqMLmqjucc71k0d
	 PfZTF+A+XMP9WN8O1PtIHFlLBAGB+Bi4ehhDhxFFStOLyV0qFvtj9DSOQ6q7lq+lcv
	 67GCFdEOQIDrA==
From: SeongJae Park <sj@kernel.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache and switch API
Date: Tue,  9 Sep 2025 19:53:15 -0700
Message-Id: <20250910025315.109884-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250905191357.78298-12-ryncsn@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A297D120007
X-Stat-Signature: 6jebodwi1mqp6ub4zhdye5u1unuk7i5o
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757472798-66346
X-HE-Meta: U2FsdGVkX19gUkYFN6s/7lwqN4PSli8ntEiqFrYah1e2UZzAFMKoVOmR1DoqSxYPhRjiDHTXHcyq4I05xgc9HKOIhVdH8Jd30hzQ5ItWvwfwIjwnLLrTZ+rQmWCrUU+LP3UIpyapYaePMKuCwguuue1SIibTxfrcNzxozNlMmw2aHzhicDEAY+r0MsiA/1VwFXD85PdYOaay7Y2Qp1dShtONtX8JHOzoLcXPBcaADfQtereO7zcxSQAT8w7SKGzEHIO6CyEB0h+p/7Mu9lSKGr65xIY7mIGFnopPNdkyxTE1AfXS+BYACCq5Yt2chcOXD3++OWUSuDHokuRx4/HyXKKG7d7S1pMybBE5zkEYWWqJ1Wh0BIo/P1Pxjpysu231IU4s0xj6ccXBxaBsrLYo0g661ivIVAv4e9GUFHQxcPwtkIVVimaQF2pruzmIsP1QXZ1c3vy7cG2WorTa8Fmy42QHX6oNGyGLyBdqGMs9Czdn81/asVSERjvneQpMJWlbQMiQd69geinXHPJpMZPAk9BpytHF9MEzrqx3dio6AUG8U68f3WuMz0PKQfpp/Hk0wxgcwZFnhoWDHyKhQNnGgkBxRBMbnHO8tawpPluunwlma//Z5BLJVMfvOa4TXQqM3qRgQ6TddcBSCjkWgzKhxtel+kRJDMA/5ZSl5fQE4Q6gdvbtkB8UGp7xxZXZYNegKyjNrHQbV+VifxXxl04vMFOWFmF7i5DEHcBZ5lszo+qTxYLQjoKpIQGBryn3V6EsCPdBNZTfAdmiTPt+2zHfhcznfdgjxGSyR00IoEeX31dSzuennBLHrccI42aBtk8hewZhNHEUjSVvz5bB0D7+UCTZf8iCeBWlNh7Y1jsTszXpmIjyVf+uucYbQqeJefBNMggtYBwP2SNhWbz0pOQZZhJsD43yGM4peSgg8bVOV1vYGkz3BHs9Ao4064AqdHvNPxlDnwIA4lO3h5UUPws
 16gXhO3V
 iv0V2zXtbs5zuEhHTZFAmO2LaIC9yw9yn7v1+lZRIeSgaaPNBATJytexV9fvEz2SysNi5mFUZ6hdzq8MNNhSDyzP8a5A3TNFgWn+K0hBKNIhyqiZcs2Ozh9lOky7uM+uwbPgCkjRhSTc+s5DoOL1ft/aU64rhWogXHPYcQUFUwKl/ey9/cZBr2BMoBRfi2wHjYfUUH6vSoczJ7lo9mLO/Uog/KIw6V2snuBcZUTLQUtrY2VqXzSbpSYavOV0+agZp5m0c/s7riDDuSEC4bFqU4DjKWuZ1O7zYp3pNuYlItJ/3JuplS7WFFbp0O8U2DhH8kf7WEqh7/sXeAz0INEqWKQqlbnKEG0dxZ/ZqJfOiQ4kaKR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

On Sat,  6 Sep 2025 03:13:53 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> Introduce basic swap table infrastructures, which are now just a
> fixed-sized flat array inside each swap cluster, with access wrappers.
> 
> Each cluster contains a swap table of 512 entries. Each table entry is
> an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE),
> a folio type (pointer), or NULL.
> 
> In this first step, it only supports storing a folio or shadow, and it
> is a drop-in replacement for the current swap cache. Convert all swap
> cache users to use the new sets of APIs. Chris Li has been suggesting
> using a new infrastructure for swap cache for better performance, and
> that idea combined well with the swap table as the new backing
> structure. Now the lock contention range is reduced to 2M clusters,
> which is much smaller than the 64M address_space. And we can also drop
> the multiple address_space design.
> 
> All the internal works are done with swap_cache_get_* helpers. Swap
> cache lookup is still lock-less like before, and the helper's contexts
> are same with original swap cache helpers. They still require a pin
> on the swap device to prevent the backing data from being freed.
> 
> Swap cache updates are now protected by the swap cluster lock
> instead of the Xarray lock. This is mostly handled internally, but new
> __swap_cache_* helpers require the caller to lock the cluster. So, a
> few new cluster access and locking helpers are also introduced.
> 
> A fully cluster-based unified swap table can be implemented on top
> of this to take care of all count tracking and synchronization work,
> with dynamic allocation. It should reduce the memory usage while
> making the performance even better.

Thank you for continuing this nice work.  I was unfortunately unable to get
time to review this thoroughly, but found below.

> 
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
[...]
> --- a/mm/swap.h
> +++ b/mm/swap.h
[...]
> @@ -367,7 +452,7 @@ static inline int non_swapcache_batch(swp_entry_t entry, int max_nr)
>  static inline pgoff_t folio_index(struct folio *folio)
>  {
>  	if (unlikely(folio_test_swapcache(folio)))
> -		return swap_cache_index(folio->swap);
> +		return swp_offset(folio->swap);
>  	return folio->index;
>  }

This makes i386 build on my setup fails, like below:

    In file included from /mm/shmem.c:44:
    /mm/swap.h: In function ‘folio_index’:
    /mm/swap.h:462:24: error: implicit declaration of function ‘swp_offset’; did you mean ‘pmd_offset’? [-Werror=implicit-function-declaration]
      462 |                 return swp_offset(folio->swap);
          |                        ^~~~~~~~~~
          |                        pmd_offset
    In file included from /mm/shmem.c:69:
    /include/linux/swapops.h: At top level:
    /include/linux/swapops.h:107:23: error: conflicting types for ‘swp_offset’; have ‘long unsigned int(swp_entry_t)’
      107 | static inline pgoff_t swp_offset(swp_entry_t entry)
          |                       ^~~~~~~~~~
    /mm/swap.h:462:24: note: previous implicit declaration of ‘swp_offset’ with type ‘int()’
      462 |                 return swp_offset(folio->swap);
          |                        ^~~~~~~~~~
    cc1: some warnings being treated as errors

You may be able to reproduce this using my script [1].

I also found including swapops.h as below fix this on my setup.  I didn't read
this code thoroughly, so not really sure if it is the right approach, though.

    --- a/mm/swap.h
    +++ b/mm/swap.h
    @@ -3,6 +3,7 @@
     #define _MM_SWAP_H
    
     #include <linux/atomic.h> /* for atomic_long_t */
    +#include <linux/swapops.h>
     struct mempolicy;
     struct swap_iocb;

[1] https://github.com/damonitor/damon-tests/blob/master/corr/tests/build_i386.sh


Thanks,
SJ

[...]

