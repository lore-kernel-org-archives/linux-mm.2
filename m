Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68235C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 18:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3E56B00A6; Tue, 30 Jun 2026 14:45:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54326B00A8; Tue, 30 Jun 2026 14:45:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D2D6B00A9; Tue, 30 Jun 2026 14:45:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6216B00A6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:45:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DBAD61C717C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:45:04 +0000 (UTC)
X-FDA: 84937456128.10.6B809FA
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7FA6B1A0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:45:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CEPvZMAE;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782845103;
	b=11P3MQfBWPBE2Yl9FjGQVV/paJwE76/lzKT87t4yZKcQLg9MP7zMvQcRnGbu1ql6K+SfyX
	Yyzzy1twCJvyP77ii4ZdUvmF88MJbEmICh3bEf2nzYEG8NYQg2Ivqwne9bvA2Td9ETx0CP
	aneNrCm2z6Ys/FaMcnwCEH7MzI2vjD0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782845103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jReEXMEt9w7e8G03i0VZobwWvCQscFhS+MP89RBwgUY=;
	b=rmTSz/LZ3znDZ9lxRwuoH1jc7t0qMuet9LM5K7kdz963OFE8dBuV3TUXMOlqiywSV3Z3cj
	pYEcx/ekzNbNTz/up/KQUkMN0X0a6lh4vmQf1ofzTevgq8NzfstZ6+AsdSY2L0PvtLqG2p
	1vwGQ3JfLd7KCLoL4MkqTCv98Qw2llo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CEPvZMAE;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jReEXMEt9w7e8G03i0VZobwWvCQscFhS+MP89RBwgUY=; b=CEPvZMAEUl5oWd4tHF/wDMOX+Z
	V/7/eF8tTgTAjXDeLq16jkyOqccJFN7TCrkdiUJxXrOlZeSBmj4xmXWDSFgnPtjmwN6krQWCS9td9
	OCrBkvICmi8YoAsgTYlXO/0sivMgUtErAjsNqYqFC9JYj6+0w8j4su2Ftxd2n62XJPCAoVw84iJyl
	tBWqAFrGXnnvJy5G/vjIjZIiPVvlHcJ+DDopZDCd2UrYtJn/6N7GZYo+H24+5UdClwS0lvkSlZJLy
	c96SrpxUj7cVrPtSRerCMsGs5pdXR2S41++hC1UW0oYybqIk7b8bCXEdDpon4STiYT/Uabl9XA6Hn
	cpLP1XvA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wedRo-00000005O2g-2yzs;
	Tue, 30 Jun 2026 18:44:40 +0000
Date: Tue, 30 Jun 2026 19:44:40 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm: rename swap.c to folio.c
Message-ID: <akQOmJOy1TYrhlq5@casper.infradead.org>
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
 <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-2-d4f648963382@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-2-d4f648963382@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7FA6B1A0002
X-Stat-Signature: c837tzkd69d3qhnukarpzk4oik37pbzy
X-HE-Tag: 1782845102-943817
X-HE-Meta: U2FsdGVkX1+gpSrZZIw6G3mf5N8jSRWmMzCJbVX5yQKM1sQzZouBVZpaNV6jqIXiel6Na+ucNNilU+QA3RNcY8oIUDoJhG0CF64EE95km9hhqCVY7odwyL1cyPVECsvz/K9z6bBGmZhXPOptPGZOHifqQGVKCsw5oF7nFQl9KO3iMT2LqIQRUexG/GOovLjZJrH7TlDCfRbFsELp7BZ+CDi9ve20PxXPHj50Iw1EvGHHKM7EIKOFhN+cT+pH4GsbK5Fw4A6rB5MjU9/4zoSrS8SU5jOdQF/kobd+7sKFCa/I/26KGWHQSyNmLAY8fz8xTEyIX+fFLqKoWQmUtHtZReVOYCyQ8PCovPCqI7FuSxG1VfgrZG8DqC+f+sVR+gLyYiOxd9nS3UPmtmzhzJuo28yELHcVRC/ML5MsBwXGtkjaIr1KhM+EOyKnrs+vqQ4EU0XmVTkBxqsxBor6OLCBlVg+QKX0fzoydoA5j0+d2SBWnFrAqOwA1jYjQjSqu1j9J/J8Q7RGmZSRPnFQpc5+3wKDc1Ec7BVQcTcangujw1Hy2N6MBMNSCX/IweX0n/CeLjSNNfWmYHXRgZUUf7dpyEZ4zrClDW44j40lI4aN9J6Hw7P2qk1W+EZ+62PI/CBWc1UA4gaCloJp6BJCBvUgD7Sk7kP8rCtNK3mJAVcap4pc9NB1zScugWccB9mcQ1yjDvN9RR9W1+OXQ1l6Mj+b4LZk5PeHcwuDjDk00503x+XBlQnZR6Efg8axgDHMLIj1IQklR/4jU7epBy//UhHjTPJY9ZP43UFTLjo2K1ECV90zdtrfkZaoWRELGHwBi9Z/oxaE+N9YBp/FVQWdjXWczmeXApkCFqq8Y1ULfv++7F8JWzxEuU5EN7Ii7UlWQ/XoankmoYf5b6C7S4MRtZoHNCbrsP6atHJe8ASs2WXUlvW+F3xu8XI8SAmqgm2JriBPbE4KMOPsoP9MFipKllE
 cq4YOTg1
 1eqqAM1Ns8CCCiomUQ2Kc0CYtBVR2eJ77UN420hduCPkr9x81IYJsww/vCFgxRSqL+dQcH/cnb0hGRf2dygxPn0fVM4trxX1EFal98VpX+HVkBBeRtcZDX4JK1bh2ouyhz8iQt3Uj3GbePF0viFgF53kOxyhfu/ny3OOHjcV1s9YYGsYcDVGsM10ogD9vqY4Nk6m2j1/TakafKNg+HHIggyA2pFjsyp5qYDIeuRmg7kLLapgRdxvnQnvpAjzXARLtx3DfFbq/vgfFs8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 12:27:33AM +0800, Jianyue Wu wrote:
> @@ -17057,7 +17057,6 @@ F:	include/linux/swap.h
>  F:	include/linux/swapfile.h
>  F:	include/linux/swapops.h
>  F:	mm/page_io.c
> -F:	mm/swap.c
>  F:	mm/swap.h
>  F:	mm/swap_table.h
>  F:	mm/swap_state.c

I would argue that folio.c is now not part of the "MEMORY MANAGEMENT -
SWAP" responsibility.  Agree that it's part of the LRU maintainership
still.


