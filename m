Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E17D8606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 08:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lrkj80Hq
Received: by kanga.kvack.org (Postfix)
	id EAA7D6B0615; Tue, 27 Oct 2026 04:18:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E81FB6B0617; Tue, 27 Oct 2026 04:18:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D710E6B0618; Tue, 27 Oct 2026 04:18:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8BD86B0615
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:18:06 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BD84A8364
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:18:06 +0000 (UTC)
X-FDA: 85367703372.23.2381747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACD9D40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 08:18:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrkj80Hq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793089084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D64FFgpc7INZHjHGIMuz6fOYnjN+R/6alnjku+MmCwI=;
	b=2vMwvTRz6C7FzI1Lqaq+9TeH+/i16TxyrTpSeDRo/lNzuuPp9CkVCol/ZudrgIUkXfVcar
	xAdoBCR3FMGHcD/z8JX7b7WMbMPGJRbkVC2oeJP6M03itB9JXIFuBR1bJm0fBELIW57QaZ
	aHqT4ayfjNGmdmmJ7W/cw5nry22SntI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lrkj80Hq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793089084;
	b=g0OhKSllPMjKTyIIIS9BSENNgfHYlDpJJqpdk9CAdezI/qqQHLJ3huvhorf8aYVmYzhPER
	i6BM56A2bSAlYBBKkBOUOTl18FDyJ/F0b+o33vNaYZ954C8cEbKJbnqol85Q6rZlaefeud
	3xCAvRcg/y5MTg1bHjKAff/DZTcamN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B349601F0;
	Tue, 27 Oct 2026 08:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8565F1F01825;
	Tue, 27 Oct 2026 08:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793089083;
	bh=D64FFgpc7INZHjHGIMuz6fOYnjN+R/6alnjku+MmCwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lrkj80HqsRK7SmEUA0UlfQ9awwfrnZbTGOTFJ38sN0K5sYRFKCiWceFy/zEcA5N7K
	 X/+Ja8dZnecwCLwqQW2Q53xYQZvfTTZvXc/UlZpQ3ww44q5sovpt7pTsmVFSsALwmW
	 con0FeRikx0qegOPeuI08/JqIvHO7h8RUPar2Oksdd8psB92RcYHO67CJO4Oifo4bl
	 4OdMIpYuvOM127oapLRHduPwvwZb4shBXArXcUwWQ3OGDl6t28H8bKbs77c3ilGNzD
	 RxpfugSOkHtwZ9bqmFJhB2XCngY1YfFKNWjupoESw2HcBJREXTXw0o5pJ9DqJ4U+FM
	 VgHlaWwITa29Q==
Date: Tue, 27 Oct 2026 10:17:41 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH 24/46] mm/userfaultfd: wake all waiters on unregister
Message-ID: <auBeJeLTUg4VlHjc@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-24-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-24-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: ACD9D40007
X-Rspam-User: 
X-Stat-Signature: ic3zxo8xu5n59w1b4k6tqu3ctxrkzrkd
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793089084-316801
X-HE-Meta: U2FsdGVkX1/GDzlRr9Dq9ONjFRykvoFLYDzfKBFuVEBP+lbMtiSkZfihvPvqUmwE26jJWPS9M/dwKhTuf4yoJDeK7L1H8NicCDiHf7kq23GaVDYmpuEtvYTZq/RVUUIjtfd7zGAuWuOqOgFJXkbkECaf2FdJ1PsOcOOlhDs0Rr+9XtyNvcBMJEdjXiBkNaqqLg634eZRieE5zExhG/lOga89IaksJXwcZRg3Oc9gtxdV2zHIAbfSnTO9b+ZuEuohp4XceHlF9dA+FNHck3eXmIBm3tFRcWOng/aw7RBI2JBgLCoxBWqwFvxLRf83AHqxqXQkcexBCcDOAaMDC/9G5lzzOd3dAQ7DFN5bmA7t8rj9U8zx8j1SFAwzBXDFiPus2njqyVMnhI+1fAqBtv75Y6m6PiLbTVK6J80qAh4zl8a/BqfLtcLfrc6rvLPJY5aQjMN/Uwsry36TE5MdPqoKCAcvlqmHKt8SzuubrtWrAC5uDmFANbfcdKfX1wzPnDLQCTUUdo4mcIjCUlWUKsphurylHYoNpMpqanIKnQhAABZTT4vZpUMKP9BKfUrt1Y6wkZF2KzaWdP74eQlJyduDV+jSYDcPVkHZJ7UQtZddGaz3C1N30dKKb7pARirwZlyBfbDS1w26EnEumWMM6q0y/U59u+VcTpd2FNtN867oyUzVy+nd+9R9a30L1hsDkqE4QAO7O8HgJGT7MF6DwV+e/lG6q4gTq0ul3j651RookzZ9OOAa2onVi/16C0k7u8N359Nc4Gon09GpnH8RISDsvSQR1Ylewl/YT/FTOxrreG7L0bWv+QtSbd9nqW/iFR2XSfXPWd72n16qfjTUbs94tzDpod2pVI0JrioeNQ3/I8KRLbCPFCovxf6oSYiPjwMGDsRgfT0lTYvZL54F8B4NaCeVp3UNuex2mCu5RXCjCl1DHQ+ZNMxtH8HGO1gz8IcizJ8G+K5+fz9DjZGQT9U
 A3P9/y4Z
 4/alaOhSZ8qMm3u4bhNSL5kKFMihTRd11YM7LmldgOS5Bs6h0egp2qenOtpabvXt9K5fO0hVGTXLyNzrNlLHtdwcRTV05cOBMWpYux1VlnAbBhu19y0x66ahZlCAxJOhEYDfSp+MxmC9mWaniZpOEolMIqo2wY2lPpjsSOrq5IfhbCLLHVQLDNxFNGSSkHFBto+y/VXiYZCxoeDw8Kx1Sr1B4vMKx1EfkmjSSVTOqaaE5fyqgdgCrr99QGQeIg2c3DriFUYa4/our2oE9QfIA2Fwdk7fENgDIobbqCZPplt//ISZburios+DXlaJox3jZvYzlqWC6Q7luHmYhpqkNm12FLgKj9NjSZEX0OBET6tX3X9xSwxxv0rA/HDu/UoscpP5un4SQ7LOW7GSu8KEA56zr7hxj3oai6PJx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:44AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> UFFDIO_UNREGISTER only wakes pending faults if VM_UFFD_MISSING is set.
> Threads waiting on write-protect, minor or RWP faults can therefore remain
> asleep after unregistering a range that does not track missing faults.
> 
> Wake pending faults regardless of the registration mode so they can retry
> without an explicit UFFDIO_WAKE or closing the userfaultfd. This matches
> the existing behavior for missing faults, including removing unread fault
> messages for the woken waiters.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: rebase; simplify description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 7e30b5ff17be1..2122676c4220f 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -3977,6 +3977,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  
>  	ret = 0;
>  	for_each_vma_range(vmi, vma, end) {
> +		struct userfaultfd_wake_range range;
> +
>  		cond_resched();
>  
>  		/* VMA not registered with userfaultfd. */
> @@ -3994,18 +3996,14 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
>  		/* Prevent new userfaults from being queued after the wakeup. */
>  		vma_start_write(vma);
>  
> -		if (userfaultfd_missing(vma)) {
> -			/*
> -			 * Wake any concurrent pending userfault while
> -			 * we unregister, so they will not hang
> -			 * permanently and it avoids userland to call
> -			 * UFFDIO_WAKE explicitly.
> -			 */
> -			struct userfaultfd_wake_range range;
> -			range.start = start;
> -			range.len = vma_end - start;
> -			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
> -		}
> +		/*
> +		 * Wake any concurrent pending userfault while we unregister,
> +		 * so they will not hang permanently and it avoids userland to
> +		 * call UFFDIO_WAKE explicitly.
> +		 */
> +		range.start = start;
> +		range.len = vma_end - start;
> +		wake_userfault(ctx, &range);
>  
>  		vma = userfaultfd_clear_vma(&vmi, prev, vma,
>  					    start, vma_end);
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

