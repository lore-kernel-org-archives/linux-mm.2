Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D6A41061B1F
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 20:39:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601B06B008C; Mon, 30 Mar 2026 16:39:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2E76B0095; Mon, 30 Mar 2026 16:39:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8596B0096; Mon, 30 Mar 2026 16:39:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5B46B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 16:39:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAFD6140918
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:39:16 +0000 (UTC)
X-FDA: 84603894312.01.2D63BD6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FDA914000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 20:39:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l8LPnS44;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774903155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZ6WUinnysEHCtSpqyhnLVTbweKlEmJrGiTY1JV+7VI=;
	b=r7alsvkXdXwfoD3eX9ffWg2jCXexR4w66Vh8cdg9+cxeBVZq6oDiprn6fXbdb2iqvaiUEd
	phcQ8jlErbMoKfKAQxCtPCE0bWfM3yWPcRHibvTmfk2cFJCT89Jos/pYqsfdL893gwgaPX
	sttVtS6zvNjYne0zgLMZ9kb2i5AHcdk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774903155; a=rsa-sha256;
	cv=none;
	b=PzEEEJvnaJYX1mBf3N/gxc7zuu+qwc5p048hqSUoT9kgKm/HPB/AX+rr2u8NdV/iXA24Oe
	fnvDOMwxALdBshEMBHikjqSdPgyGbpHffobTAyDfFuNmLBvv7qcN4EbOpOGitduVf2Nj1t
	H37V2W0xbYi9pHKYBULj4HWvM+rj9tM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l8LPnS44;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B98D2880;
	Mon, 30 Mar 2026 13:39:07 -0700 (PDT)
Received: from [10.1.194.63] (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7E71C3F7D8;
	Mon, 30 Mar 2026 13:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774903153; bh=57yEmJLr5ZH4sNztAyV4c9hHBxfBM+qcR9YdxTsp5s0=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=l8LPnS44n+fwwNRwgxDikVoU6C12MVa7wcE3uFJGICd/Jo67jMkKvDRRq1PCWMVn3
	 ShCVzHwevb83snR2cJ9JQpBhw/m9WTfpD/IiRorgC23ySnRYp0EuGau2UkQGQklMO/
	 usGz1Vshh1seKIXi7EtMBkRVx0vK15331BbJ9F88=
Message-ID: <1dfbe39b-d052-4810-81d8-2ab74263bd7a@arm.com>
Date: Mon, 30 Mar 2026 21:39:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm, KMSAN: Add missing shadow memory initialization in
 special allocation paths
To: Ke Zhao <ke.zhao.kernel@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, John Hubbard <jhubbard@nvidia.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
References: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260330-fix-kmsan-v1-1-e9c672a4b9eb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9FDA914000A
X-Stat-Signature: oqim48z45hept3tr1txqfmtrhq1e998w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774903154-578251
X-HE-Meta: U2FsdGVkX1+gLeFIHyCP9DxCrTplVsHQwkXcid9SvUADWcbjTn9GVEXFIBCnekp5Phd/xHcIPDh07Lo/cKOu38jSwZKN9EqBqBP1z/W4Wl+ZsJvwCDqlo+yNRJvY639sSxm4fYLVJ+ci5M+pb3SY4Owrofdy94l2S6yOhqqtrYaH5fmHjjVTXJ24WpHl1ctJR3J6zuo7Zj/NOEQnBViQReWuIyoeDNlMA3bzZxSgWMw0Ibz1ofFXmTHTdWR7uQq143ovxOTSk+vazq1gABw6EspuA7cxTtmxdiD/FB1WyvP5BMDqC2Qa8Ay0z+31Hi9F+t/6CQfyQhPZI67zup8L4B+pPJPsVGznqOmU420GMWdXzjCvcQOze8oKxXTCXrQ9VddNo3zlcqrwaQQ9ewccHo3XCG53JiV/mTqAL0L0WH0BqwVuSamx8ZERzIXOQ6OX1AF0E1a8hx6UhKEzIiqnmFaQYycPn31zsykpvE+HnGsDDz09e1wBp3oeXJN/Z8l9T8dcvo+PxLZeqfWMk4jTvgPh9EYbeWBgDtjXg4zX5S3QPG8ghjUrrI7J9QC2A13YrkcflCjoR/es0ml+rYRvL1SxqPnQ5Parbw64y0eC2iHCpT1zGy2mdGXz/muGxZWJAdkgHZdb71OKarCgPVfa12fNMcNfLscOIOjXNffOQSKVuljqvAHu3cme2BOz64ghNLB0amh9z3BE06gVXDqZVUI8uP/BPrgvT4iU17j+uNOIaxMqxiVY7sy/LqJH+kMzeY0UYsrvaa85aVd41ooBnskpC8+oZxZalExmFV+9kY3cjEsR8xOOX7j0Mj/frFaDlpQ9rwqgNMKZG48YfUJghtt2V5h/mnnUqWZCpG/IhXSfGViapI4kRF7PHJ8Gidj0XjTJDZQUZj5XULY9bK9AEB/hYSHX/E5IG7dvQG77G2Y8iP1PcMlqVGM2bqGDdwv8pzSbHdoCyjTfpoHSloV
 oAuWBSCK
 pnYEF+DSn91ZSQQbcbWmadVCaZlBlyxMi2troiKLFb42AmQyp9PAXvNEvAryrrXLwEVIfsoErWDOH25yzcrN/6Szfzdb3raIVRqVcd5RDE6Z+bkFjmh26evqmZI+vextVrvWFHBCqgaa6UJ8QJBEbF76yP0h1wT73uYp1dR0Q33VbJhY82NJqaHsBRhBEJBEJubs/7QdbZyFqNslVX3swAScolO5itLNUtBaVphq2C5V2XsLzfsBBBN/kQrMuD9tAWfCChu282bol92hIdmGjerMAY3/J6McK3K1ejVD6R1fGnmAb48fMbOfAX0e4dVvScDiPiw6+BqJIdvh+W+pjNRqgfdzb6LgttUpcsoOhGKawKvfIqnfQ2RReI36+XpxG9/vkuhajuS7T4+BTTSXplhYGGzkjXv6VVP791cdQuSKGYJHbOAyt4+tQUrGK5gP/K8oKJng+OoWQQa3RO6T7L5NkCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/03/2026 9:36 am, Ke Zhao wrote:
> Some page allocation paths that call post_alloc_hook() but skip
> kmsan_alloc_page(), leaving stale KMSAN shadow on allocated pages.
> Fix this by explicitly calling kmsan_alloc_page() after they
> successfully get new pages.
> 
> Reported-by: syzbot+2aee6839a252e612ce34@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=2aee6839a252e612ce34
> 
> Signed-off-by: Ke Zhao <ke.zhao.kernel@gmail.com>
> ---
>  mm/page_alloc.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..6435e8708ef4 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5189,6 +5189,10 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		set_page_refcounted(page);
> +
> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
> +		kmsan_alloc_page(page, 0, gfp);
> +
>  		page_array[nr_populated++] = page;
>  	}
>  
> @@ -6911,6 +6915,12 @@ static void split_free_frozen_pages(struct list_head *list, gfp_t gfp_mask)
>  			int i;
>  
>  			post_alloc_hook(page, order, gfp_mask);
> +			/*
> +			 * Initialize KMSAN state right after post_alloc_hook().
> +			 * This prepares the pages for subsequent outer callers
> +			 * that might free sub-pages after the split.
> +			 */
> +			kmsan_alloc_page(page, order, gfp_mask);
>  			if (!order)
>  				continue;
>  
> @@ -7117,6 +7127,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, 0);
> +
> +		trace_mm_page_alloc(page, order, gfp_mask, get_pageblock_migratetype(page));
> +		kmsan_alloc_page(page, order, gfp_mask);
There is no page defined in this function. Most probably you wanted
to use head in place of page here.

How did you compiled and tested this change?

>  	} else {
>  		ret = -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> 
> ---
> base-commit: bbeb83d3182abe0d245318e274e8531e5dd7a948
> change-id: 20260325-fix-kmsan-e291f752a949
> 
> Best regards,

Thanks,
Usama

