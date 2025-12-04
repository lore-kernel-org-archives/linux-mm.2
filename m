Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9652CD1F9CB
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9F26B0022; Thu,  4 Dec 2025 07:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981696B0023; Thu,  4 Dec 2025 07:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BE3D6B0024; Thu,  4 Dec 2025 07:30:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2966B0022
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:30:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3916A13665C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:30:27 +0000 (UTC)
X-FDA: 84181721694.02.107EA9E
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf28.hostedemail.com (Postfix) with ESMTP id 210E0C000C
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:30:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zqi9wdG+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764851425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8n8MncgiagcATAavJwnGHHjCaEvtYSrB3GNKh7foFns=;
	b=6eBcO/YTjUF4AzBK3ayGV7EQvquc0hnJuq1WLg20dZfTpK8Uw+656Td4qDOLNLCQdnsXTE
	CMJZ6BNAQtgREFMLnmoudMJmh455SNnbpTKU+LiiacRtJ/QgG7ANepWD+UAX2gVOn45wPI
	5wbTin5wm5PWbXpV74r/JTT1U6Fe32Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Zqi9wdG+;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764851425; a=rsa-sha256;
	cv=none;
	b=yxRU803g7BJHBbzFDIiTHBotMP1hltw8irn+CgEABiArppxQjVF0N0ijdt58e3GenifkSw
	dHfLIw5OxDdgl48WzfOMsaD/bAAwQuf4XwxGjOLsyv3uZEGXjB/GPqIQDOe8JmZ5DyONap
	3BAN+jTEDqOAa87zX+6ryxLPg+sjmCc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1764851418; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=8n8MncgiagcATAavJwnGHHjCaEvtYSrB3GNKh7foFns=;
	b=Zqi9wdG+kqBqaC2M5lnLU/1TSZsq1S2q9YxTYVeVeMgAYCRbrlNlI0KQSvMGxN8A7OGWnUdw7gX7IWnnKdYBAfifQNrQFzsxS3l9c3Oj2FdHxHYy8iRyfj98hvaECWsSubQLU+4TrkYYglHRkn/p7qj5a+IEH7q/gZWfoI+hDJ4=
Received: from 30.28.193.34(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wu4HxQj_1764851411 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 04 Dec 2025 20:30:13 +0800
Message-ID: <6d88bc71-bc5c-4f5f-8ca9-5bd0e2677fb6@linux.alibaba.com>
Date: Thu, 4 Dec 2025 20:30:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/19] mm/shmem: never bypass the swap cache for
 SWP_SYNCHRONOUS_IO
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, David Hildenbrand <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Youngjun Park <youngjun.park@lge.com>,
 Hugh Dickins <hughd@google.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
 <20251125-swap-table-p2-v3-7-33f54f707a5c@tencent.com>
 <64ae5450-b74d-452e-a9ae-486c57efa092@linux.alibaba.com>
 <CAMgjq7DcpMgLjX1m=+4SM=zMe5+H4qDLqdOUGnYGNBQ_HsKw-w@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7DcpMgLjX1m=+4SM=zMe5+H4qDLqdOUGnYGNBQ_HsKw-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 210E0C000C
X-Rspamd-Server: rspam11
X-Stat-Signature: kia9tiahdpa5fufxj15e9f9ouy439sdc
X-HE-Tag: 1764851423-966621
X-HE-Meta: U2FsdGVkX1+OyuiaFA3vB96H6khbLGr6gnlQb25mCjbarlNb9BOXDtSmNoX1MM+Dk5opvbLR6htc+qLyglJpHEhMXHNb8Qedd280i77WlOs8Z+D3kXhWh58RfpBCCEXdfP3ukJ0bW103el5yQOKix4EddT23UzqQSbCEZ6EAXe7lueeBKMMeYoDZol4ls39DuNsvozTUHPwlRUHIao9ZdIpK7IiMKBbcQLZxu1yKjbvipUfMA4uIfE52x33zlSKbHMvg63TyGESm3OPj8vtu9DUDBReBL5A+Wq6SLLFFbfKQzgnQ9TDhf/CD6l1yUcjeOfhL0TtktVs1vnJPBozxPdJ+9SVZlh2kZFgPZ0awxRUo6qizMU0WGtKOJRDhPvlhRJNs5VeHqzhXgRrmthYl8ZxSTkFrBRWbqolz6uiyZFr854F0sqxPSNmExFMNWO/y+yATtuMVhOl9cLIaeZl2PA+mQMwjPgKzp7zz05hYaqhT4CRxlWoMpmwwBXpxN8XJAoc0yseIxfjuXFaaqX1xQ5YWFij4fREOXV0bZ2kuVRuVfK0Alk+9ihp7YEiKo1HXOdf+OQbnlq8/zxVBHQo7EQbWcm87DnSkny8uOYXMAWJ5w3Mjh6JDuAsOv0FogCPVJrXMzrnhDYQGcnr9TyC/QputveOb23dw0w/7cAdcyfZfbPUFAJ5wfa2tN7o4qmnVVRq+1R8xMIWrOWk4DUOIfsAeTRUWnEvfrfc2oERblzcuNEeJW3Njs8b3gkNuEaFFaECWiCsb8jplgcIUto9KZX60CwSIl7hgfirSlUt5dXNC3QZPU/MPtvrpPHNDwsE73Gg9iBSGpF8e4oKXWFhuJs95kCVM78OylcnAN+6GCIXi8MXGMTG/st3MOScXoNKDQ6Id9VhQtr8UGTvy+ifj9gpBHAhEmb6ZfsfurTb8XRYl3dPxm98hJRHlBZhkxmcHqRiqt0uuAK0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/3 13:33, Kairui Song wrote:
> On Tue, Dec 2, 2025 at 3:34 PM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> Hi Kairui,
>>
>> On 2025/11/25 03:13, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> Now the overhead of the swap cache is trivial to none, bypassing the
>>> swap cache is no longer a valid optimization.
>>>
>>> We have removed the cache bypass swapin for anon memory, now do the same
>>> for shmem. Many helpers and functions can be dropped now.
>>>
>>> Signed-off-by: Kairui Song <kasong@tencent.com>
>>> ---
>>
>> I'm glad to see we can remove the skip swapcache logic. I did a quick
>> test, testing 1G shmem sequential swap-in with 64K mTHP and 2M mTHP, and
>> I observed a slight drop, which could also be fluctuation. Can you also
>> perform some measurements?
>>
>> 64K shmem mTHP:
>> W/ patchset     W/o patchset
>> 154 ms          148 ms
>>
>> 2M shmem mTHP
>> W/ patchset     W/o patchset
>> 117 ms          115 ms
> 
> Hi Baolin,
> 
> Thanks for testing! This patch (7/19) is still an intermediate step,
> so we are still updating both swap_map and swap table with higher
> overhead. And even with that, the performance change looks small
> (~1-4% in the result you posted), close to noise level.
> 
> And after this whole series, the double update is *partially* dropped,
> so the performance is almost identical to before:
> 
> tmpfs with transparent_hugepage_tmpfs=within_size, 3 test run on my machine:
> Before       [PATCH 7/19]         [PATCH 19/19]
> 5.99s          6.29s            6.08s (~1%)
> 
> Note we are still using swap_map so there are double lookups
> everywhere in this series, and I added more WARN_ON checks. Swap is
> complex so being cautious is better I think. I've also mentioned
> another valkey slight performance drop in the cover letter due to
> this, which is also tiny and will be improved a lot in phase 3 by
> removing swap_map and the double lookup, as demonstrated before:
> https://lore.kernel.org/linux-mm/20250514201729.48420-1-ryncsn@gmail.com/
> 
> Last time I tested that branch it was a clear optimization for shmem,
> some of the optimizations in that series were split or merged
> separately so the performance may look go up / down in some
> intermediate steps, the final result is good.

Sounds good. Better to mention this (including your data) in the commit 
message. With that, please feel free to add:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> swap_cgroup_ctrl will be gone too, even later maybe though.
> 
>>
>> Anyway I still hope we can remove the skip swapcache logic. The changes
>> look good to me with one nit as below. Thanks for your work.
>>
>>>    mm/shmem.c    | 65 +++++++++++++++++------------------------------------------
>>>    mm/swap.h     |  4 ----
>>>    mm/swapfile.c | 35 +++++++++-----------------------
>>>    3 files changed, 27 insertions(+), 77 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index ad18172ff831..d08248fd67ff 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -2001,10 +2001,9 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>>                swp_entry_t entry, int order, gfp_t gfp)
>>>    {
>>>        struct shmem_inode_info *info = SHMEM_I(inode);
>>> +     struct folio *new, *swapcache;
>>>        int nr_pages = 1 << order;
>>> -     struct folio *new;
>>>        gfp_t alloc_gfp;
>>> -     void *shadow;
>>>
>>>        /*
>>>         * We have arrived here because our zones are constrained, so don't
>>> @@ -2044,34 +2043,19 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>>                goto fallback;
>>>        }
>>>
>>> -     /*
>>> -      * Prevent parallel swapin from proceeding with the swap cache flag.
>>> -      *
>>> -      * Of course there is another possible concurrent scenario as well,
>>> -      * that is to say, the swap cache flag of a large folio has already
>>> -      * been set by swapcache_prepare(), while another thread may have
>>> -      * already split the large swap entry stored in the shmem mapping.
>>> -      * In this case, shmem_add_to_page_cache() will help identify the
>>> -      * concurrent swapin and return -EEXIST.
>>> -      */
>>> -     if (swapcache_prepare(entry, nr_pages)) {
>>> +     swapcache = swapin_folio(entry, new);
>>> +     if (swapcache != new) {
>>>                folio_put(new);
>>> -             new = ERR_PTR(-EEXIST);
>>> -             /* Try smaller folio to avoid cache conflict */
>>> -             goto fallback;
>>> +             if (!swapcache) {
>>> +                     /*
>>> +                      * The new folio is charged already, swapin can
>>> +                      * only fail due to another raced swapin.
>>> +                      */
>>> +                     new = ERR_PTR(-EEXIST);
>>> +                     goto fallback;
>>> +             }
>>>        }
>>> -
>>> -     __folio_set_locked(new);
>>> -     __folio_set_swapbacked(new);
>>> -     new->swap = entry;
>>> -
>>> -     memcg1_swapin(entry, nr_pages);
>>> -     shadow = swap_cache_get_shadow(entry);
>>> -     if (shadow)
>>> -             workingset_refault(new, shadow);
>>> -     folio_add_lru(new);
>>> -     swap_read_folio(new, NULL);
>>> -     return new;
>>> +     return swapcache;
>>>    fallback:
>>>        /* Order 0 swapin failed, nothing to fallback to, abort */
>>>        if (!order)
>>> @@ -2161,8 +2145,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
>>>    }
>>>
>>>    static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>>> -                                      struct folio *folio, swp_entry_t swap,
>>> -                                      bool skip_swapcache)
>>> +                                      struct folio *folio, swp_entry_t swap)
>>>    {
>>>        struct address_space *mapping = inode->i_mapping;
>>>        swp_entry_t swapin_error;
>>> @@ -2178,8 +2161,7 @@ static void shmem_set_folio_swapin_error(struct inode *inode, pgoff_t index,
>>>
>>>        nr_pages = folio_nr_pages(folio);
>>>        folio_wait_writeback(folio);
>>> -     if (!skip_swapcache)
>>> -             swap_cache_del_folio(folio);
>>> +     swap_cache_del_folio(folio);
>>>        /*
>>>         * Don't treat swapin error folio as alloced. Otherwise inode->i_blocks
>>>         * won't be 0 when inode is released and thus trigger WARN_ON(i_blocks)
>>> @@ -2279,7 +2261,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>        softleaf_t index_entry;
>>>        struct swap_info_struct *si;
>>>        struct folio *folio = NULL;
>>> -     bool skip_swapcache = false;
>>>        int error, nr_pages, order;
>>>        pgoff_t offset;
>>>
>>> @@ -2322,7 +2303,6 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>                                folio = NULL;
>>>                                goto failed;
>>>                        }
>>> -                     skip_swapcache = true;
>>>                } else {
>>>                        /* Cached swapin only supports order 0 folio */
>>>                        folio = shmem_swapin_cluster(swap, gfp, info, index);
>>> @@ -2378,9 +2358,8 @@ static int shmem_swapin_folio(struct inode *inode, pgoff_t index,
>>>         * and swap cache folios are never partially freed.
>>>         */
>>>        folio_lock(folio);
>>> -     if ((!skip_swapcache && !folio_test_swapcache(folio)) ||
>>> -         shmem_confirm_swap(mapping, index, swap) < 0 ||
>>> -         folio->swap.val != swap.val) {
>>> +     if (!folio_matches_swap_entry(folio, swap) ||
>>> +         shmem_confirm_swap(mapping, index, swap) < 0) {
>>
>> We should still keep the '!folio_test_swapcache(folio)' check here?
> 
> Thanks for the review, this one is OK because folio_test_swapcache is
> included in folio_matches_swap_entry already.

OK.

