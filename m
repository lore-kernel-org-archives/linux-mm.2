Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCF5C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE8B6B0098; Fri, 18 Sep 2026 08:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795D86B0099; Fri, 18 Sep 2026 08:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685086B009B; Fri, 18 Sep 2026 08:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DB836B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:06:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF6281A05F7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:06:28 +0000 (UTC)
X-FDA: 85226755656.11.643D372
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0FD9180005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:06:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oz8yUNnm;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789733187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPwaVlnc3sz2QE0jM9J/1CQZrwxrqd5GuKxMszFpe8Q=;
	b=J2P5ZebL/FpBxTmEwE+1GpsBAYzBdD6J128m1H5izCnkJmoOkzT5YikSxOrzEd6GSdCpwf
	zboKqdd8oiLNWy1wKfzoSdDkHu6LsjpyzKKw8g7G5bVx9aoDkb8oLVeK2N5sSTlMFjoSC6
	IWAY/VyyaXmAGDzr0elJdPhYFxV33tI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Oz8yUNnm;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789733187;
	b=ZqTFUvg/X71lwjhaDU5BsIAw4xqr5YuvQlPd6E+fDKf7VlQ0PBDcpXyPpYIq4fZr/Owp65
	W2qHbi9yM5+0XB+wf8AjyAAb58Jqm8+DuwuIJBXDzmQlRgkpfH4lfT0kCSheDJJSZDZ+VV
	9xuhulv8XvrS7kKfq+ZNTcxF3l3e3vM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C5FB60A82;
	Fri, 18 Sep 2026 12:06:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720381F000FF;
	Fri, 18 Sep 2026 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789733186;
	bh=uPwaVlnc3sz2QE0jM9J/1CQZrwxrqd5GuKxMszFpe8Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Oz8yUNnmOyeIhfOdjbDFnXivKktAfCxHChfWTeLIwOIXV3cT+wdC3fTxDA5ODRao+
	 m3MiliFrl1iFF8/iUeWqbr4GW5bnUSKNQaLwIz/iZmQak2arBaCS+K9YwkPHoHl1Hq
	 YDqngpGK7GsMA7Cj20DaJT2YlJhTzyYR3kQfk+DxJPxtUSrhnMR1byiRJaDBYvtevP
	 iz0x0tP90etyXFjOC01WEme34O5Po00ZaxxfcT2ZYKChWX79LT1RrQBzpmUF2gFD6C
	 eOr3WcwREkVbQ86BiG4w5MLZImk86Bw8NDMJWlDn456G77sYFN2oL53nAJqdSayJz5
	 Y3eTjfpEcZzig==
Message-ID: <1e178509-89fa-4496-85b8-5354c594c2ae@kernel.org>
Date: Fri, 18 Sep 2026 14:06:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: implement and use vma_has_anon_rmap(), silence
 KCSAN
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry@kernel.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
References: <20260917-vma-is-faulted-v3-0-5c22314a72e7@kernel.org>
 <20260917-vma-is-faulted-v3-2-5c22314a72e7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260917-vma-is-faulted-v3-2-5c22314a72e7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 3oq4kw1wyfbct4db7wo8tdtggnbe7btn
X-Rspamd-Queue-Id: 0FD9180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789733186-873660
X-HE-Meta: U2FsdGVkX18nKpL3Bs1CZ9dT4t/4dHrMfRR54CmPMln0oK8+KRtF2tny2cBxtxfCKDyfgi4TuT2mp5rpjZMpT38xJvdz5YqYmGcJS3W/mjMmCd11BuZSfc/OO5o14bXBxn+nTP/s1eK7b5Xp6F2w7J2fD54ZYK/5zBh7rofX8IR3E2q4Fkkf3BZ2wy5qvCQ57sItVMBdHDEzjSc7HNUoL/OzBlCezXvmOHMHe8taW7r6Ii3ixwv9WHxB+Z1m1oR5iOZL3e8UWfFOi2d32uqF+jlV1JvQGjGrYDO/3lPmpB9WGIaQZAsyEEOa47t6ZabEdTVpAYJzYYABxQem85Mc3xKg6mX43u3Ip3p/WykSy3ht+5zdupOBCf1CJGHa1iJaZraKtoDbK3OGBCkRZgRUlPuuLoAuyUstqXkhkCT8JtYtfvNz92gqeNqUDLdK76bHnWTSo8nIOzPC18fs9AtxnbisfhiA+ZX7VwGqLiKAj1ydzs1GJLb6ziS0qjo63q7ZA1RU55fWUK2YCwIVpf8CS0O1glc5nvfdvYUPC2qF83ZlgOepmiz/8tY5DFpsRcUq4ntzYAV2jWPXC9UNkB8tQUgEtxA81aMQB+ABGZVYelwBmNZitEkliC4gF0xyKqeITqAL3eSKReQvh92FAZQmQFsalsP5+ernG/rozvuBzj7EFm0+6XMCL7fM1j7lkRAzZlzevQ6mVMjeAlcD64YZmSgtplfzqrUqr5MruCs3PnGA66eTpAXuoSda38Zd9PRkWyC5x0BBFJJ1gPMFF36hXP6T3d2/pQnZAUcHgRB2jbi8mvo7p+wFr98sUWLZVXIn0QuBukVjtf2aTTKhLJb9OeQLPIWFYwDzNSjH6lzTECYg2Mx5FGjyclR9L/nUmaxJqdg+1W+MEV01gZiwflbT1hs5aPJ0REphYE0lG36SrKQFnCxac7fP1qQHfdG7J9Ho+JtZuMHEk9QBVQNpuMB
 TflIkspy
 2QRdkFwe0XVnEFgVO0So+P13/C0aDKzQBgPMTuWzIleLPqBZ3pqI6Q/2Git4aQsx11abGQZ/wC+Xb7DgaziKf8eqTgHoPUARikTFH7YkSUpsu0j3Rn0tMoLGOgyuX3vCHQi4dqrVqWylU/A6OaBRbrUWxGlQwxZKIMk6aVOw7YdqJEOI9+FxBf7e4zwZvLp67ntbJm3gVgrTKICNdMKKwXkpbYMn8ZhfJZ1eDpWTDitMbJoo7w0Xroi5ttbAw33l7+HusoJUQdpo4K7C3ovIbRZoFgfG86e0Yp75reNHYzM4JVPOpaYG5ZssG3I9WcRZcq3Ct24n7pFhmQ5SCljHPrZZ/N+EeTYchj8XwlXgdfi3afO+th3EVNCQ7TVMX8jBlubpsthTVeS8BaPzWukT/RvGxo5ovpBUxkEd/3DZVVtKZVbQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 21:47, Lorenzo Stoakes (ARM) wrote:
> Provide a function to abstract the common task of checking whether
> a VMA has an anonymous reverse mapping associated with it.
> 
> If the VMA is attached, a VMA or mmap lock must be held when calling this
> function.
> 
> For an attached, anonymous, VMA:
> 
>           Transition          |              VMA/mmap Lock state
>  -----------------------------|-------------------------------------------
>    No anon rmap to anon rmap  | Write lock/read lock + mm->page_table_lock
>    Anon rmap to no anon rmap  | Write lock
> 
> vma_has_anon_rmap() never provides a false positive (the lock precludes
> it), but if only a read lock is held, a negative result must be re-checked
> with mm->page_table_lock held.
> 
> A VMA obtains an anonymous reverse mapping when first faulted or forked
> and it is removed when it is freed.
> 
> Detached VMAs cannot be concurrently manipulated as they are removed from
> the maple tree so require no guarantees.
> 
> Use data_race() to silence KCSAN about non-existent data races between
> concurrent vma->anon_vma read/write on optimistic fault tests.
> 
> Update the core VMA merge/split, rmap, mremap, KSM, fork,
> khugepaged and fault preparation callers which test vma->anon_vma directly
> to use vma_has_anon_rmap() instead.
> 
> Finally, update comments that reference anon_vma to reference the anon rmap
> instead.
> 
> Since the lockless read in reusable_anon_vma() is doing more than checking
> whether the VMA has anon rmap - it is returning the anon_vma to be used on
> fault - do not alter it.
> 
> There is one odd one out - file_backed_vma_is_retractable() - which holds
> neither a VMA nor mmap lock and is stabilised by the file rmap lock only,
> so simply add a comment to explain why it's necessary.
> 
> Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

