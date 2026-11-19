Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8749560A2600
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 09:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NBOLjtDN
Received: by kanga.kvack.org (Postfix)
	id 9CA006B05E0; Thu, 19 Nov 2026 04:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B626B05E1; Thu, 19 Nov 2026 04:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 841D26B05E2; Thu, 19 Nov 2026 04:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 573136B05E0
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 04:10:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C335AC09B3
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:10:02 +0000 (UTC)
X-FDA: 85451296644.25.02651CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1C7C540007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 09:10:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBOLjtDN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795079401;
	b=wnmkKBm7th5QKxpbUDz1FZpXI+KOUV9PbRbTtjoNv/eas2mhu+r3xBySjIrZCTORrVJJ6D
	mfrOC9xBhswUBxtZceYjoUD0JzFu+B4t0CJEGUBEpBZWU9kDxhFwvIOG0/GXVVjCzRwtUJ
	UVS1b6lpoqiM9GQRqDlOPxFjAR93lBI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795079401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGhE24qIBqiTNN8z+BFa93ke6YAjy7suuxpu/4LDT3E=;
	b=6hU+Q1LvIhOKn9CwulRIcZmbY3I+lBO1VHqSBnxCcJwfrjTi5hsRJMXlkF5eWDAm8KXgDv
	nL+18UZhwdAXp89NjNZsM5ASEwcfy5n6zECg/OfnsXDJNq95IfpDXTnqPusP1tz7zmctmN
	hM27Lg8bwizb2V8JClMcL+U8lH5N6jM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NBOLjtDN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1612343B8D;
	Thu, 19 Nov 2026 09:10:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C2A51F000C4;
	Thu, 19 Nov 2026 09:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795079400;
	bh=ZGhE24qIBqiTNN8z+BFa93ke6YAjy7suuxpu/4LDT3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NBOLjtDNHucTwb27MjevugAZuIv7/bosEyeF0DijnNaXGSk17S47LQkxkz6Wi2F02
	 +bEWRZhQGyz1eabWT0EqltvKgLkeniA4fJ+KRGAhWgvhip5VALR992fXbQDwRqbhpz
	 KpUWQc60q5yZcpiUVe8o4+EjpocWIzN075V/ZUg90SIx7d6cICIXOCxGc9oKiYeHLT
	 zOxQUhJHODAaVcgTSL6YBIpPUOiX8/6xnbJbJZb/lm+rArzgjy1fOiKtj47JjLHy2f
	 H2MhsQ01rf8p0pTvHKT3BkH/KsDrBKz8g17dBXVKzS60/L2AHKoCMYG6nMpy01udOW
	 QygD50i/z1d8Q==
Date: Thu, 19 Nov 2026 10:09:48 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	stable@kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH v2 08/15] mm/hugetlb: serialize page-cache allocations
 with truncation
Message-ID: <av683B0FDj-xB-7w@localhost.localdomain>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
 <20261116-fixes_hugetlb-v2-8-4dd9e94ea9ac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261116-fixes_hugetlb-v2-8-4dd9e94ea9ac@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1C7C540007
X-Stat-Signature: cui847uybxm1y156whc5gqm3y3t88knn
X-HE-Tag: 1795079400-732611
X-HE-Meta: U2FsdGVkX18FxDLcwvLBXEmXzA6fgMF2+mPNE2+SJAKW7uAEvKiz4d7ezVurP+9ZFiLT7cQDeDeDdKataGD6vAWUliqOv09H0owivoIUcPzJPhwZMPv5smwV0LLuF/dHLHlC+23AGk5U04lpHT6VQ7tDmxRVWFYXOmKW1mGJ+quOBlMHPfuG+mXm0w8qNax2QSy8O6VFgviHeK7xAk0iKYjN4s0WGLRvA/AOnqzWm9jx9Zb8Fcm3+hSfnDZee3okZYNmS8J0utvB6ek72IJs9hgwQ2UAWqtA2MLX2AdfYDuIrw7KTKfpZCYoGJOwYTrDw5fmBU5sFMDP9WZfGUDgQ8iqdgQJAcb5Cawh4dECi0Q42B0UBaPS5uxBWvADUPotu99IvWXncJeyrcmB3mScwVDg+sgNTqmIJwDtBJ9fG2ExiG0CzDvvNPx/Wm2y6EwLU3OxDld/ZaknV5ddnRsybHQMLJ/AfY+oBDF51Hc9DOXHyCfo70xa6GdEekzkrKOpT0WW2qAXOsr/FVqj/h8Xx1u1xyT3HKG61FqsALOxO2WgQU9n/K1kZ0Go0Yg19UeMHgd0JbHKQeAf0ZTk/QklY48Jl3xJM+7Aw1zmReaQAKXP8qZ97dQ2gcO2oMV4HicciQZVO7yilLUOGGioNrvOLATzyBVPEXizwH+jhzWx+bgiX5sADYtPDcYUzhXOJvAkyGqNY5QUblWZJZtAre3dERd6cW0yhd2CpYhII4Cw9RiREGetn4gSTm7Z+cljXYodRgqLgufxPWpGkvqcRBXxvHDm/N+Qbc19PejkkAhor8pt7u6gaV40CA8dvRjJCResp7OmH73hx9rb/5Mpn+Grdq4kB1Oz47U0xZiSX2oX1PBdY3Q6wzPGARw66+qppZFG81l7OGpY56FOC/YvfBVBPTtrvCd18IBQCJyII1xgpZOnWxl4w1J98xn0jxfzwecR0CvXcae6rwS1k9TeOxy
 S/1WZy7M
 ucK7EIXB8Gy+jU3OcQ/Ksqek2C5olujCSq/pqJ/T9IuJ+rVma3H8KCvasRN5yR0HdHPyji+QTVj5KiZD5WN1cuy/laqZBwFyX3j7sDtheJ6j4/QUE1u+akFaNnwt7MI90rGgnfgMfujdOJOZK55MlRGI4r23E5F1/isAw+QByi9f+qDwCNauJBEy3ZJmiJ6v4uo4w7QuLBnRz7ENUU9n2FYgDVPaGy9h4QaPcvAuB/z+KqfEaZI7ePsWlScdjZGQd9G+pLe5sz8jnUGzt/ap8YuwOn4SI60ZE0lKMfst5oHsAWHhVr0WNQDX6rr131V4BA/T9S6oht7Us8IGI0C76dboc6AyRxNkvvS2GqYNnBwwbqYZKrvr8rRRBvMxOnQHEh0BEPyYC8Fva5Ujh2hzE69g4uz6CYs83rcg48iAPI4bM37mx1t3agFLYbzhJW+OOGKe5K6peqmI2yKNt9S7+t2w+JGOmXZLojFg55odPvyYLHKGmX/O3qpP7obpe1NyjnCt4rgPJ1ZGeR/mj5yHWYzhwZKTrBVmX5JhGYkdMBDonvX7ot4o43KfMqKTxV337rakNmFWV726EZh0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 07:29:29PM +0100, David Hildenbrand (Arm) wrote:
> Truncation can remove an inode reservation while a fault is still
> allocating its folio. UFFDIO_COPY and memfd pinning can also consume
> reservations beyond the new i_size. This can underflow resv_huge_pages
> and leave folios beyond EOF.
> 
> The main issue is that truncation takes the fault mutex for folios in
> the page-cache, but it has no clue about faults that are still being
> processed concurrently.
> 
> Matthew Wilcox raised mapping->invalidate_lock in a different upstream
> hugetlb locking discussion:
> 
>   "although I wonder if we still need the fault mutex array, given that we
>    now have mapping->invalidate_lock?"
> 
> While it likely cannot remove the mutex array entirely (concurrent page
> faults have to sync ... ), we can at least use it to fix this problem.
> 
> Hold mapping->invalidate_lock shared across the size check, allocation
> and page cache insertion or reservation rollback. Truncation takes it
> exclusively around i_size_write() only for now: it waits for concurrent
> allocations to finish updating the page-cache or rolling back reservations
> before changing the size. Subsequent allocations see the updated i_size.
> 
> Let truncation release the lock for now before unmapping and removing
> folios to preserve the existing lock ordering. Cached-folio faults and
> private allocations do not acquire the new lock.
> 
> Use it to synchronize with truncation, keeping the fault mutexes to
> serialize allocations for the same index.
> 
> Locking order is now:
> 
>   fault mutex -> hugetlb VMA lock (read) -> invalidate lock (read) ->
>   folio lock -> PTE lock
> 
> And on truncation:
> 
>   i_rwsem (write) -> invalidate lock (write)
> 
> Add hugetlb_pgoff_valid() to not repeat the same size check multiple
> times. Memfd needs a bit of care, as it traditionally allowed partial
> folios to be pinned: the size check in memfd_pin_folios() allows for
> that.
> 
> Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
> Fixes: 188a39725ad7 ("hugetlbfs: revert use i_mmap_rwsem to address page fault/truncate race")
> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Cc: stable@kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Link: https://lore.kernel.org/all/ajMfdQf-Fspwmstr@casper.infradead.org/
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

Just one thing:

mm/rmap.c has a description of the lock ordering for hugetlb:

 "
   * hugetlbfs PageHuge() take locks in this order:
   *   hugetlb_fault_mutex (hugetlbfs specific page fault mutex)
   *     vma_lock (hugetlb specific lock for pmd_sharing)
   *       mapping->i_mmap_rwsem (also used for hugetlb pmd sharing)
   *         folio_lock
 "

We should update it to reflect the updated locking order, right?

 

-- 
Oscar Salvador
SUSE Labs

