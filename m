Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBDA606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 15:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BuxeSr53
Received: by kanga.kvack.org (Postfix)
	id 95E906B07BE; Tue, 27 Oct 2026 11:16:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910286B07BF; Tue, 27 Oct 2026 11:16:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FED76B07C0; Tue, 27 Oct 2026 11:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5860B6B07BE
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:16:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 026461C444D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:16:10 +0000 (UTC)
X-FDA: 85368756942.21.59154DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22FE914000D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:16:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuxeSr53;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793114169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WyoOBEMd5hZXCT3U6GbGErLU5iMuF52Y0APEdOL8vu8=;
	b=cyFU2MHruS73Ud4L7NqdfgjrQCQOnNXyFRXpozq1h7CBU+sQxv1f13r+aTBUkPVJ0OFqmD
	+PJsPLB4h5yWy5/1m03gQBDT0gSYAgEaPCGM/S8Fxuul1BYb6k+M7wTaNk/pc0ROY81yeD
	Az72yuRAWvD7edoXp0M6BK9iwzNm7eE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuxeSr53;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793114169;
	b=2AaMnapV4Yp9NN8xcOP6RJKqi9BWlGK8usUIpTRcTpBa6QxCJW8tFJEtO+azp2LzMTsWoE
	2qMvbj3j3V6X1/H6jp4lO15maeoaogUgwx3CHovGhCV/P8cQquDeUjDMFiCLhMpL4fdOEv
	t8QCZYhU8A4lvlkIbrKBPifBe6nIYn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68F2942DF8;
	Tue, 27 Oct 2026 15:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B361F031E1;
	Tue, 27 Oct 2026 15:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793114167;
	bh=WyoOBEMd5hZXCT3U6GbGErLU5iMuF52Y0APEdOL8vu8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=BuxeSr53N6HezVPXpkTBwQAyxXiQXQMGirT/jWdAIMpopdRAYo1tvjPz9Mj4TZHOA
	 kCKNMi0nV3dg0g3jZfLVdgzt3vZSG9lLq4AlcR0a+e3VBnedC3bymzXL9oG1SO4iWE
	 fJACOUUU87ggc+1eu6u1/KKjtn7CLcF6A2wbcLzhoj+dB1tLXLa4KYbKieq7i748iY
	 o2gmuzLNkgoyi0AYn+LoxhMR9H3ei2rAbSx/PGsiegdwDvsYnH1pr2f40NOC0DMtB9
	 f87YgVhTqm0YPh9Nk+7DlZiCPK/LFgzZC/NqNbunFZp6vNHVfwUP/noI2x1kVbeQS1
	 xgersgMKHm9Ew==
Message-ID: <5d431bf7-8813-4e2c-a40d-b45d4ff39a5b@kernel.org>
Date: Tue, 27 Oct 2026 16:15:48 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 10/46] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, stable@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
 <auCw2-_yjh1_RjiO@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <auCw2-_yjh1_RjiO@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 22FE914000D
X-Stat-Signature: jr6nbp3e6hy3i5joi83qpr5twi89fimk
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793114168-952519
X-HE-Meta: U2FsdGVkX1+/4sA+T3Snb96rasO+YZPD4bIISqrh+LshaYd3Nt5X741ldzMDDiI3AMk1xLVjCVHwfUGsoEZ6/efSXllfGe/LKrAjOba35rQULaeWtKLI5K6nt/ayqLrVUi88zMgpHReK/6Sph4eSbIAnvismTcwv8edUwjec2KMA8wMgcnm5bIhTXsj9BH6fM0Y+BqkGuQx98lTT7NE6gWHX3e//B7dDTpQIaZrPPrxgOOm9pb0Sjh4HY9/SD91mMf2Su1AVwiMKjoeXY8u2SWJo3cVFetqx7tDKx3m+vehEKd6HNGy++P4zO5eufNQEay7cHg63LQ0cfdwqxtPjx1KKXrg3aDz44IOSyxrrcbrxyUoYBfnevZ1pVY374z8UAbYOPYJDF9M5DeZkcl5jfOuTA6qZeWxp47upVIkHLb9mbwCtvexNDqUG5HxWSBG9hL0hsb93H4pV57X/1fir//W/SOpp9TN9zdNxZWkxDpJg/evzdw8/i9a7d0dpUVk4DAFC7idV8MPuLm47drtURqj860NScDDL98hYIYy1qhXcqCj0F7baqPfbEQQBwXmD4qHKkgvcqPlbkXSlNyJgd2YV0+Mh3GvFmZ6VUrNZroHi1HnsacymgxDGNv+BLbl0nW+tQpHZmOrS/aZe0Zj7PuWKbYwdbdIo+HBnloCNlBuFCmXKrt/a4+jcjX7kLbLwt6RLGgplV2s3gp/Dj0oQaYgK3KITNOs3hepaP8bplKcQKzAKOfvMG4v1LlUJAcWPOyojezoThF52TIg6Ug3riuz7mUJ1o1/AluAQqBDLcApc38j+pZVuMmiRTJ2FvGBrLIIAGkCUSRPQb65xb67H6Qtca6f4UzSvlk3fLXVTN1n+O5YLtJJnTWAQbosgxtasnKffDE6cvJATkrCg119Lx8RLOA5KH22Q1CkzXMUasSkMvwwSkkDZAsUy816y+Us4uclc2VQocK6C/xYkyrb
 r155UlMQ
 UTutWnlmIYR6QTQMqGMSyzABPomAJDwefdlKAVT8jAOvrqBAdOKQKktG4ZZ5qrEZQJjo+XIiUBwKUFRUZkQktnJM+mzENDmQvdjweJrkL1MO+k3Y5ChPDYjhgXm/fg/QQlRrAbJ22XiOQFxHfyXeINj64AdagkMokBsncKdpuvyhOjAx7VIQwbop+DavQuGdi+jAgZiN3SUzR1SnYjOMvfuTc4L0VKtgmtuh53PlOeGZFYVtMzZw07terVJQO/cAXzRvJsJc4qYV2V+jqpyhIUIrcpQgeyJbGYZlFAL7+bYd0lFBv3jlxaEaL2eMTFAdjnO/ynvkKXSpHRr6gPtTxVeHs1HBn5eQiEmE63RxtGWuuQsgay4FhsgstbFFdSY1JD/NRXbgIGklgvV/XdyMTt6ahm0ABYnEAa4EL17IdjObqOBqHQdylI1LWlziC118ZwKrb3Tox0QM5TlHQGyyxfQ0gSNcWUjJxGFKoK6F0bHw6127LyKHXHluzll1q3hN+ze4XCTzIrf4e2gYOQ62O/nonvvyJpbjJ3gXWgwg3j5FTlrlMIWXJr30iCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 15:10, Johannes Weiner wrote:
> On Tue, Oct 27, 2026 at 12:17:30AM +0100, David Hildenbrand (Arm) wrote:
>> Since the deferred split queue became a list_lru, the isolate callback
>> moves the folios it took a reference on to an on-stack list, linked
>> through folio->_deferred_list, and deferred_split_scan() takes them off
>> that list with list_del_init() without holding the list_lru lock.
>>
>> deferred_split_folio() does not know about the on-stack list. It only
>> holds the list_lru lock when it looks at the same list_head, and it can
>> run for such a folio: a THP is queued when it is mapped, as a candidate
>> for the underused check, and is queued "again" when a part of it gets
>> unmapped:
>>
>>   CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
>>   list_del_init(&folio->_deferred_list)
>>     next->prev = prev
>>     prev->next = next
>>     entry->next = entry
>>                                       list_lru_lock_irqsave()
>>                                       folio_set_partially_mapped()
>>                                       __list_lru_add()
>>                                         list_empty(item)  -> true
>>                                         list_add_tail(item, &l->list)
>>                                           item->next = &l->list
>>                                           item->prev = tail
>>     entry->prev = entry
>>
>> The folio now sits on the list_lru with ->prev pointing to itself. The
>> next removal leaves the neighbours pointing to it, and they still do so
>> after the folio has been freed. With CONFIG_DEBUG_LIST:
>>
>>   list_del corruption. prev->next should be ffd4000000270090, but was
>>   ffd4000000278090. (prev=ffd4000000270090)
>>
>> Fix it by grabbing the lock around list_del_init() so
>> deferred_split_folio() cannot race with it.
>>
>> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
>> Cc: stable@vger.kernel.org
>> Reported-by: Josef Bacik <josef@toxicpanda.com>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

While I have your attention: This variant works, a different proposal used

list_del_init_careful()

instead. However, that is documented to require list_empty_careful().

Do you think it's worth looking into?


https://lore.kernel.org/all/20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu/

-- 
Cheers,

David

