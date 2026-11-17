Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7FD606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 03:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dZ3oK/EA
Received: by kanga.kvack.org (Postfix)
	id 1B5026B00EF; Mon, 16 Nov 2026 22:57:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BF26B05B0; Mon, 16 Nov 2026 22:57:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9EB6B05B3; Mon, 16 Nov 2026 22:57:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D769E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 22:57:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5882A1402AA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:57:46 +0000 (UTC)
X-FDA: 85443252132.30.D161B51
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf08.hostedemail.com (Postfix) with ESMTP id 37F32160004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 03:57:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dZ3oK/EA";
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794887864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izXu3SEz8eIFng5c+cQzMPJh1su6k7eUDwqgFAEy9no=;
	b=S44I5vnx5ThKinNifv8hvDpaLbyrZIkvCwRHCxnwaLCPcxJDbJgido+sPHiByDW2J85daB
	96ai3CXqsrtx6LgyhMKGact1vYS1hNBiVGNGgct4j5CusJi8ytkTSPMYBY7TEA5LjRjl25
	w4gVimCtFXVQnnnBPKUDLoJpSSuv+B8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794887864;
	b=GK9fp175/SIo0R7N0h+ZD258+F1G/iRCOFP63EgA2NYA7OpPnqmkgJrjsZx+W48Zy1e63u
	Pp6K0Izaff4I7uowBOXAiFCNiDfODVG9teYeRRXhvTAHEXzlTQdSLEhZlh0w6chFnoRJ7v
	d8Sf07UDf1/2jUo5MgllHH4yZuX+9E0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="dZ3oK/EA";
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5Txe0D+CvURkPmiB6vwpp+Xu6DG12FpQu2ufKeIMMqA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794887862; v=1; x=1795492662;
 b=dZ3oK/EAar9zcpIqddMZXYRE/bC8qGS96x9te7lMTiyEodAkOYd4rN6fNsGaCFvc7fKRwrYa
 CU9UfWEUBlQiN6hHxN9Mxy1yBZzH5J9qRsnJOBboe1q5W9Wje/B168qEuhArLTOa7iFGxocbNp4
 TLyk25XCYiMYfVAZGLQnUrOU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id dfb182efd82b894e;
	Tue, 17 Nov 2026 03:57:42 +0000
X-Mizu-Trace-ID: dfb182efd82b894e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 00/14] mm: Unify memmap initialization for compound
 pages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179482576829.2379196.3205677806966393313.b4-review@b4>
Date: Tue, 17 Nov 2026 11:57:22 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Li Zhe <lizhe.67@bytedance.com>,
 Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <A4F207DD-9535-42EC-B9A6-88578BFE369B@linux.dev>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <179482576829.2379196.3205677806966393313.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37F32160004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: yzidi3uxey5zirizhhnxkcc13f5byig8
X-HE-Tag: 1794887863-763980
X-HE-Meta: U2FsdGVkX18UQrX+4L7UFtO6KwUzOjcBbDwrMWhobh7QpMon8Varemqxj+Bnr1Ww0yWYgeWSXKu904ekXy/gxnVgS1mGrF2CX5UnExMPAyUQwbi8NzRvpUdV4u07/Lg58+XTWdngzMQfmyAzh86phMJ+YzJezXrzRwp3HqM41j6DMn/TDHGxVCMaHz6W9YGlGVF3WzKOQgwL03NnGVt55ycQL/gGMTw2tQLv2RBp22bLyMQCWqi7vDtmB5KtLwoW6RZmLAA9fLGSR52GyY5Kua8Y061a1q/LMprOaIL0aeFZ7qLn9bJUkqazf578iUrYXI+qwkunXMHnm7q9YDydqOE2QumlVtGZmx54LmnbTC/yvsZKKvOGZGIGXIcMaTClCdCH02T7whADv7uXHgPuwpMj1NpZoIf1xlxLbsffqcu7saMuE2gfdqs8ssa7Mc3DcdC4hMr2UwFa63QgojbdExnp2vVWWTfUyMyD6dJ3oxrDWyzGj4x5iPoEB3kc0IZ8lpUMbtQkFiju54qRFVF3ZHknUpxvp4mPU668BkLPxr7yERL8hyN33VVQqkGpcrBz7UpIIYUhWuF4y83/VqenP6Ejz3xvEao4t1HwarXcll5+cG1i3VnmZej95DKoP+lgOpwn/TBuzXDhSB+QpYkIS/anG+4EtZotULMzFU18oF2d3/t2eKTBWP8YnZ/JsbjhVqdrUqQ1L9OigSfdiUGQXaqyyEcJnWjo+plng0iiEzVwFU7dacd4UGxWlbG+ZKdyup1IIVKiHiRdF+eu2ipRXyXn8GvbVEpAwGRyLYCWKAP7/J+bS0obMh6ESQNZi9GsHKlEx+uXWt179CunBcZ+GDYWRX1pxejM7EadZyeGyEjQbKFdeiP4sHWQJNAAvjFW73lU300wQa8gcNmJW8HiuRZ1x7AKNrHyYx98TboGi5n3OUeX63qMJPQuzpyVitHn2OHFgCqeS3GPT4Sg80c
 eZtsN6dL
 Kzoy/MVL02E6itwHKBYBAI9Sw83AGMs4wmWYVQ8fxRSI+Ta0T1E18NGtqwTlXk+DqtRAmF8GJQQ/ibhmWaCgafL3PtQbvi6GqfqxP1YlhDVmDaRsCqcJt15NgarylGETtxVq+++gW/ClV08FS751wN8eWKaqVYnAwHSum1mjYMVQMJZ0r2UxFcT+LvKniuRiaCMRZm1y8GuHuWF889EvdTHd5xFrL+flxGzPzlBrsfZM6lGWLN6dFWpeW0aYGrhe07Jcg/17yu+WAsARyBiKOkJzRAB40+2ilHFpT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 16, 2026, at 18:42, Mike Rapoport <rppt@kernel.org> wrote:
> 
> Hi,

Hi Mike,

> 
>> Hi,
>> 
>> This v2 is based on the mm-new branch at commit daed51c91051.
>> 
>> This series is split out from the earlier, larger series
>> "mm: Generalize HVO for HugeTLB and device DAX" [1]. That series
>> generalized vmemmap optimization across HugeTLB and device DAX. One
>> remaining piece is the separate compound struct page initialization used
>> by boot-time gigantic HugeTLB pages and compound ZONE_DEVICE ranges.
>> 
>> This v2 also folds in Li Zhe's two-patch series, using that series' v2
>> as the integration point [2].
>> 
>> Li Zhe (2):
>>  mm/mm_init: factor out memmap_init_page_from_template()
>>  mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>> 
>> Muchun Song (12):
>>  mm/mm_init: verify zones for template-initialized pages
>>  mm/mm_init: factor out common struct page initialization
>>  mm/mm_init: simplify zone device page initialization
>>  mm/mm_init: factor out frozen compound page initialization
>>  mm/hugetlb: drop boot-time HVO handling for gigantic folios
>>  mm/hugetlb: initialize all struct pages for bootmem hugepages
>>  mm/hugetlb: use common compound page initialization helper
>>  mm/mm_init: make __init_single_page() static
>>  mm/mm_init: make memmap_init_page_from_template() static
>>  mm/cma: centralize CMA pageblock initialization
>>  mm/cma: localize init_cma_pageblock() to cma.c
>>  mm/mm_init: move pageblock migratetype init to memmap helpers
>> 
>> include/linux/mm.h   |   8 --
>> mm/cma.c             |  24 +++--
>> mm/hugetlb.c         | 111 ++-----------------
>> mm/hugetlb_vmemmap.c |  17 +--
>> mm/mm_init.c         | 247 +++++++++++++++++--------------------------
>> mm/mm_init.h         |  13 +--
>> mm/sparse-vmemmap.c  |   7 +-
>> 7 files changed, 129 insertions(+), 298 deletions(-)
> 
> That's nice :)
> 
> The series would be easier to review if Li Zhe's patches were integrated
> rather than stacked in. I hoped that the changes for template
> initialization would fit into the patches that rework other parts.

I have a much clearer idea of what you mean by integration now. I'll push
out a new version once the Zhe data testing is finished.

> 
> The way it's done now several patches in the beginning of the series
> change code that the later patches remove or turn some of new functions
> into static.
> 
> Another thing is that the numbers Li Zhe measured were for a different
> implementation, so they would be stale for the state after these
> changes.
> 
> I have some nits and naming comments in a few patches, other than that
> the series LGTM.

Thanks for your review.

Muchun

> 
> -- 
> Sincerely yours,
> Mike.



