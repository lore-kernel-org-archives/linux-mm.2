Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B59CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41CF26B008A; Fri, 16 Oct 2026 05:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F49C6B0092; Fri, 16 Oct 2026 05:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B126B0096; Fri, 16 Oct 2026 05:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05E016B008A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:57:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 71C45C0342
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:57:57 +0000 (UTC)
X-FDA: 85328038194.04.1BAF62D
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf05.hostedemail.com (Postfix) with ESMTP id 685D5100002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:57:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nhFnmMHD;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792144675;
	b=cJJfcQPwT7A/KO3ak+TBzyLKCQuCBwMVBlFbEZOMPwfht4ndbEKdwzFmlgs79QzEIu89VP
	ruZ45jGW2l5q7UMonIQjiV9JwBFxIY6kWAkC867C+z1IVk1xQvPsHD9/pdqoEEdXnvbO4K
	Y6eKOiu8b8dQr3FpOJ2H7GQ5RLgwt8g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nhFnmMHD;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf05.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792144675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAt144Vk7k8qMXgrEGhDpPZonayJjWzttOQo4WX8s+E=;
	b=VrGkK9FbyXcPSjtks1zqV1FyKQFEqHLauGg3oTbe4mJsmwF7Nzy3yW8+KlcFeAnn/GexEQ
	xFF/nyzQPqyWV3mN26dnyo3hcW3IS9JEv2UbZld88McEp1XhTVNUZbNRW2QNKWjQDW3jC5
	mQZsBKEeDL9I+RBbrOHexRg728ej2fU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792144671; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hAt144Vk7k8qMXgrEGhDpPZonayJjWzttOQo4WX8s+E=;
	b=nhFnmMHDHnjzq15dBktsdEUzJpEBg53m0WsPLhpDlfwb9mes4Ng/rWHE1BU8oLjj9emUb07NZGam9r1x3o5mQ4shq9z4yTVacziYB7VgbNR9g/U1hCTeK3yfSp4V7HObsQmzctSEWR0+Ry+ADdF0NyoodURLTsk7pYMWwpvPjvI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XCuU.YY_1792144668;
Received: from 30.74.144.163(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCuU.YY_1792144668 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 16 Oct 2026 17:57:49 +0800
Message-ID: <27e5aadc-2d68-428f-a958-308e4a75c058@linux.alibaba.com>
Date: Fri, 16 Oct 2026 17:57:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: david@kernel.org, ziy@nvidia.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
 ngocthang2710.1999@gmail.com, willy@infradead.org, rppt@kernel.org,
 ljs@kernel.org
References: <20261016065920.4153-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261016065920.4153-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ptzt3gjjhdimh1j6ozxnsai3yzxh7qdu
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 685D5100002
X-HE-Tag: 1792144674-269946
X-HE-Meta: U2FsdGVkX19fiKQp4CWiK0MfMOtyj5+ycsZm8KC0JYFVjJ5p2XPxYGkb5t3QyMN78oxcNxNdzLthuSb9pg5EzhXpN1E7w7hmOI/Bq3ImgAZ7Whl0Mm+0Rf7hUowkiLZ0/3Xf9hcd4FV2Li+kT3nLq9gslGWlTvqnWNptxXMjbpfDUYphLHXHg/MwnVLV5YpSZF9ppBHBSbghC1EptnY9Sf0uycOJNC5Jj9/oBkwypwyG463wDDsPVovG5nR9dv5ED4TY/XmHOmX0Ao0Pb0EcfKn+jjnKdduymEMZ+kPkdjcj4JIIZiso80PM+cMuu2ixPg70xB+NUq8amkw0/EFVtMBJxdrFLsv6udONCi4D4G2f4wcnbsQ7qNjsbYOLBBM582lCyFLVZJF25eG/ILl1UTvtFHKu8u27yzEcidkcD76L7wlAt/9PvCc5dnqD0MbPcEU5NBLGSwDANIL6gA1WdI++V5zfGpcA0CGi6zxriSm+gi0uhvIaXo73DzC6XTnLbaXo7v+oMvYMUFDXOsCwrY5agnd7cAyBHHc9ZZq2gkIfCDL/Tth0ENVO1kjvXmjmRJTjjzOeJZhbH+mvDnk3zQo+jVJpN7wtBNEp3Ut3uq+TYpmRWdW9x60a2w7qIw58C33p01dR+rshY19j09mnsdLvKbrKKKlpj2XVjLpyglvBRL/qexBXpvfJgkjk8NCsBPK4u4Q96DfisMkcbNzWvozZuB8yUivuwkYkK1xPSmB9eWeMNjqZNljDGBSiYvoqjZn9h2XEfkvrTtCwpq3ylbtYLvS7GFuYv1xT6ktTuvWnriMRdDh7szveFLP2G9hlkVN2Ri2lp776E77/t5vh2HrhAI/gxbvHqh0dN4H6sPQLorPQ/T7Bvet+eiw+I/P/VOzTo+OtIlakKkaVie6bA+5dbsQDD+W0hiD9HnWfk0cUXxU42oeztOeqVKLX45MUPpdi34Phz7ckIEJzXny
 uMQh58Ub
 bhbw0cLuELbPflVok2ezxQV5DufipMxTf0ziJLKDiW9wYwZxLh+f3o2QXx5OFL+jA9QwNNCvi9JnUPtMsrivOa288ZuFZCBlUGXY6sLpC2geYziArwF1LxE5vxyME5D8VqdyRu0t7/dgDPLR1t8BAcrApxGjOMANyqRPgtFdTWxIC4VZrxFAxNcQ1mhg06z6yPxctfgA+nch+uDjuxkIygAXl8xFtebsVlqMkf2LZG5zDDy+PVkBleD7hFGmDY0NO36KJn3sAsClZvettISEgOleI3uDUl72vICOdO14OWgGL8pbA4YTTir74PBeHBz6xKg39AOACsN88fCC/4ZLdh+QVDjLMJhtI6Esc174h/WAc/GR+m76vsE8BjcSU3NHV0AqI1bifnxw9055m1Qhl7J+5XQjHxm5u7QVp2T7RyHk2mnJp4j032epvKOKvbHSezacPIDF5JPbHqg6t4kvlv+c88+hpn+JPFSeBgiuPJLN/SiahxjUO+MszmDCRXZbTZyg6P9eRFH/Qi7iNZ6em0+aTh6aewcahgBpsoYyhkkIxnJDCoXqn32Q2nbHPC/i8YGgX/Kz0yCuu81Mz/f4A/VbpAM6Exh37rETbmWVjYzfOSZ5DO0VzhAZbRQluInWgHZB2xmM79+8W+KdGo4DNra3su2H5tck62lDRfLqXqa31qTYxtlRdcmf2VLKR4rqSag7XC/jVJPUGN2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 2:59 PM, Lance Yang wrote:
> collapse_file() can end up calling page_cache_sync_readahead() with
> source folios from earlier in the range still locked. If truncate already
> holds mapping->invalidate_lock exclusively and is waiting for one of
> those folios, readahead blocks on the same invalidate_lock and neither
> side can make progress.
> 
> Do readahead in a separate pass before we start holding source folios
> locked for collapse. Keep page_cache_sync_readahead() and its existing
> policy, and drop each folio's lock and reference after checking that it
> is uptodate. If truncate or reclaim removes a folio between the two
> passes, roll back instead of doing readahead again with source folios
> locked.
> 
> Shmem handles swapin and fallocated folios through shmem_get_folio()
> without taking mapping->invalidate_lock, so it isn't affected by this
> lock inversion.
> 
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Thanks for the fix.

> Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
> happy to take this over.
> 
> Some older stable trees lack the folio infrastructure used here, and the
> code will differ for each stable tree, so each backport will need quite a
> bit of rework and its own review. I'm not sure whether to Cc stable here.
> Once we agree on the fix, I'll send a separate backport for each maintained
> stable tree except 5.10, which isn't affected.
> 
> v2 -> v3:
>   - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
>     a preparation pass using page_cache_sync_readahead().
>   - Roll back on a new page cache miss during collapse.
>   - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/
> 
>   mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
>   1 file changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index ef5cd6fda34f..b3f67617caf0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	new_folio->index = start;
>   	new_folio->mapping = mapping;
>   
> +	if (!is_shmem) {
> +		/*
> +		 * Populate the range before accumulating locked source folios:
> +		 * readahead may block on invalidate_lock.
> +		 */
> +		for (index = start; index < end;) {

why drop xas_unlock_irq()?

> +			folio = filemap_lock_folio(mapping, index);
> +			if (IS_ERR(folio)) {
> +				page_cache_sync_readahead(mapping, &file->f_ra,
> +							  file, index, end - index);
> +				folio = filemap_lock_folio(mapping, index);
> +				if (IS_ERR(folio)) {
> +					result = SCAN_FAIL;
> +					goto rollback;
> +				}
> +			}
> +			if (!folio_test_uptodate(folio))
> +				result = SCAN_FAIL;

Do we need to check PG_uptodate after locking the folio? If we 
successfully lock the folio, doesn't that mean the read I/O has 
completed? The following code also checks the writeback flag, so the 
uptodate check seems unnecessary to me.

> +			index = folio_next_index(folio);
> +			folio_unlock(folio);
> +			folio_put(folio);
> +			if (result != SCAN_SUCCEED)
> +				goto rollback;
> +		}
> +		/* drain lru cache to help folio_isolate_lru() */
> +		lru_add_drain();
> +	}

Could we factor this code out into a small helper?

> +
>   	/*
>   	 * Ensure we have slots for all the pages in the range.  This is
>   	 * almost certainly a no-op because most of the pages must be present
> @@ -2320,17 +2348,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   			}
>   		} else {	/* !is_shmem */
>   			if (!folio || xa_is_value(folio)) {
> -				xas_unlock_irq(&xas);
> -				page_cache_sync_readahead(mapping, &file->f_ra,
> -							  file, index,
> -							  end - index);
> -				/* drain lru cache to help folio_isolate_lru() */
> -				lru_add_drain();
> -				folio = filemap_lock_folio(mapping, index);
> -				if (IS_ERR(folio)) {
> -					result = SCAN_FAIL;
> -					goto xa_unlocked;
> -				}
> +				/* The range changed after the preparation pass. */
> +				result = SCAN_PAGE_LOCK;
> +				goto xa_locked;
>   			} else if (folio_test_dirty(folio)) {
>   				/*
>   				 * This page is dirty because it hasn't


