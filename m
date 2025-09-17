Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55DA7CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:50:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78ED78E0005; Tue, 16 Sep 2025 23:50:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7651D8E0001; Tue, 16 Sep 2025 23:50:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67A988E0005; Tue, 16 Sep 2025 23:50:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 529DC8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:50:18 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EACB7B8487
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:50:17 +0000 (UTC)
X-FDA: 83897364474.26.48F8021
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF0EF1C000B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:50:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dJoUTTF4;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758081016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vm9MyVs3qndFLbwrsQ4E2tRYO2NcQgheP6ENpSIsgMU=;
	b=Fb8dON8bFmUzozMcuwOEhTbjzlAqqDJCw0K8lBlM/sI51FXyhgtB3c+D7Xpc86ibFa2F9n
	N41KDWa75up7vYU0WW7pOP+3j48ulaR4RXsCpgn0Vn1JnBWTm6l0GEDF8Bw+m9nISpOhW8
	J8V3PeYU/kzuEuwg7lKusnZ7c6/FMII=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758081016; a=rsa-sha256;
	cv=none;
	b=I6oSH41wJ2uV10sJUU1Rp21mmPIR+93obWtAdgLChygUBD0gre6/5jS1pEX7XRuliRYgnb
	8d7PSzZ/CFosi9A+i5ByM7FUlGHVxiakWWa9O7c22H7h0B2kIUr7kRsStKiEYUNt8lh/SQ
	qNdNmbet2GHqVKpjqSRsBX/ZMkxkq7o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=dJoUTTF4;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758081011; h=Message-ID:Date:MIME-Version:Subject:From:To:Content-Type;
	bh=vm9MyVs3qndFLbwrsQ4E2tRYO2NcQgheP6ENpSIsgMU=;
	b=dJoUTTF4UoWR9Jsk2qJ9gKNVWgaRvf3F3u9NYHIGrgVVy0k6AIyeBVPU9Se4samx16fO8yn/BFdAjVqwGzV3rTDjUT7XeU+n14OiX/I5vbMiPcZTyF0OXoDMjzBFCuvFwIoUHi3Bp9Z9yr/7cuM4zNNc1ngdek/gUAWcgHP59LI=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoB5YhN_1758081010 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Sep 2025 11:50:10 +0800
Message-ID: <7eace9f6-e257-498d-ac10-ae86b5713e3a@linux.alibaba.com>
Date: Wed, 17 Sep 2025 11:50:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: Hugh Dickins <hughd@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, david@redhat.com, mhocko@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
 <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
 <9b01a2cc-7cdb-e008-f5bc-ff9aa313621a@google.com>
 <6ebb5cd0-0897-4de7-9303-422d0caa18cb@linux.alibaba.com>
In-Reply-To: <6ebb5cd0-0897-4de7-9303-422d0caa18cb@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tm8abbztnx5xa7qc84a5r67af4mr5ye4
X-Rspam-User: 
X-Rspamd-Queue-Id: BF0EF1C000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758081014-465723
X-HE-Meta: U2FsdGVkX1/UNi24FipNHG7up7IsKmdEoSxsZTSGV84iIaVtJlP/6GTwPJcGj/MfcNuhI/Rtt7sRdHGfqgCEsiIbYKpOwXKYp4SqZ1+v3RdY1I00BsVYZXr1Km87KQz8WzAEJ8GRepdE1egg41pEAtqXzjKZcc+Z1Ex1SWIR28/l1Ag3mPLQO35ARjd4ETHiTf4cbrnuEbzaIubPZmFSkLizqcS8fHfOKsyHgZW9Gt9ScuSsjlydCf0E/s4rCAVHoSKCrC/xwj5IpkRzOoEThQHqimojbFMZWFPziy5KNyLeT6A3kaK+Zz6WbWb6W3O/BzW7wzhNu6uynCKHBMn20gKvAEB7KMnjTUJNROasJMeFYuE7I2QzZCkYyY8QqD2kIg8v96D7tnpoLMrptpiCgO8Pv1PSGoaTgO+Z8NoE73DNdw3bOm0GFRc1LdGIWPrdk7MSQ9Eo7adCWOPQUbUyBork6bbMFJuOBMfSGh7EHLWYEvRe39GwPr12mwMZpZFg9YvxOHBYmAf0UA+ThHt9TSBTZ6DJtp90tHskpwZuWCusXbzlfpJvPTVCYg/8uYdKkoM/cg9Re99/EwT2c1tOZNqb9GA+r339DASr/QNWDMYus8RTWTB1pBrWLmqcsUEm+Diei3DvWbyvYNOv2x2QbH2u2MdWcDCsmB38fnl/EUqA9vUi8yDrBw0Iq8EwTMok6jjuGzSfklunOJhtJojghaFqsNHTbxwnAqisAcijTEh6YyyPYqSt/2xGefkLbnhAzu9brA5CM1WS+M4Vi30jGQ+qnIQfo/mXf3CG9J9rs75UiTZhJ8e5wwCyRP/bfHay4MB7heqyw1vPJMKGL4x6XwrETc80UT3Ykm8Rt+lT+SfSBlMKuQuSWEa/sN76y3xQPoSz9G34fBLu6ccXQZt1hP4gZoX0gQhO6iFife0/gaA/sdSvFpeBksjbFY73XtTrLkp6DSs5hxW8lDAF2HI
 NdPdLZTm
 yXZtTjsIepDmqk5cZT4hDuEJylYWIgqG16qvKFHy954X+qAn03HHxO8Ayk9q6iMt9JQbNcI4kKMs+mJW88L2A/5Tcc9AHBEjbJC+0ePUG7ePMSRQs1M69XdANwBl+2A18n+nbp+BC51ngQMG6bFwA6e0eu3As+X7cT2jZoNDzNhGfkgTmOpM5yjxr8uOw1wmiwnxF9MHz+DY3m/KHXQLAN5fnoO5QpUJBphv3uS5jU8sykuOw3gm3BN2GFmnCBO5lzumT8vN7NJjjYpQoowTd1bZhgSqwj7C4VX4nl4hGS7bKLcyF0VpMlQmAcs1YvSPRjJh5TEAgo7QJldH9wn0MSeWxoNk0KEjuSNJGboxFcQ7uDgxKLTPUAPJLuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/16 15:18, Baolin Wang wrote:
> 
> 
> On 2025/9/16 12:00, Hugh Dickins wrote:
>> On Sat, 13 Sep 2025, Baolin Wang wrote:
>>> On 2025/9/13 00:13, Shakeel Butt wrote:
>>>> On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
>>>>> Currently, we no longer attempt to write back filesystem folios in
>>>>> pageout(),
>>>>> and only tmpfs/shmem folios and anonymous swapcache folios can be 
>>>>> written
>>>>> back.
>>>>> Moreover, tmpfs/shmem and swapcache folios do not use the 
>>>>> PG_private flag,
>>>>> which means no fs-private private data is used. Therefore, we can 
>>>>> remove
>>>>> the
>>>>> redundant folio_test_private() checks and related buffer_head release
>>>>> logic.
>>>>>
>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> ---
>>>>>    mm/vmscan.c | 16 +---------------
>>>>>    1 file changed, 1 insertion(+), 15 deletions(-)
>>>>>
>>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>>> index f1fc36729ddd..8056fccb9cc4 100644
>>>>> --- a/mm/vmscan.c
>>>>> +++ b/mm/vmscan.c
>>>>> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, 
>>>>> struct
>>>>> address_space *mapping,
>>>>>      * swap_backing_dev_info is bust: it doesn't reflect the
>>>>>      * congestion state of the swapdevs.  Easy to fix, if needed.
>>>>>      */
>>>>> -    if (!is_page_cache_freeable(folio))
>>>>> +    if (!is_page_cache_freeable(folio) || !mapping)
>>>>>            return PAGE_KEEP;
>>>>> -    if (!mapping) {
>>>>> -        /*
>>>>> -         * Some data journaling orphaned folios can have
>>>>> -         * folio->mapping == NULL while being dirty with clean
>>>>> buffers.
>>>>> -         */
>>>>
>>>> Can this case not happen anymore and try_to_free_buffers is not needed?
>>>
>>> For dirty file folios, pageout() will return PAGE_KEEP and put them 
>>> back on
>>> the LRU list. So even if mapping = NULL, background workers for 
>>> writeback will
>>> continue to handle them, rather than in shrink_folio_list().
>>
>> You've persuaded everyone else, but I'm still not convinced:
>> what are those "background workers for writeback",
>> that manage to work on orphaned folios with NULL mapping?
> 
> Sorry for not being clear. The ‘background workers for writeback’ here 
> refer to the workers responsible for handling the writeback of dirty 
> data (see wb_workfn()).
> 
>> I think *this* is the place which deals with that case, and you're
>> now proposing to remove it (and returning PAGE_KEEP not PAGE_CLEAN,
>> so it misses the filemap_release_folio() below the switch(pageout())).
>>
>> There's even a comment over in migrate_folio_unmap():
>> "Everywhere else except page reclaim, the page is invisible to the vm".
>>
>> And your argument that the code *afterwards* rejects everything but
>> shmem or anon, and neither of those would have folio_test_private(),
>> certainly did not convince me.
>>
>> Please persuade me.  But I've no evidence that this case does or does
>> not still arise; and agree that there must be cleaner ways of doing it.
> 
> I did some further analysis, and seems you are right. The flush worker 
> does check the folio mapping when writeback, but it does not further 
> release the private data, for example, in mpage_prepare_extent_to_map():
> 
> /*
>   * If the page is no longer dirty, or its mapping no
>   * longer corresponds to inode we are writing (which
>   * means it has been truncated or invalidated), or the
>   * page is already under writeback and we are not doing
>   * a data integrity writeback, skip the page
>   */
> if (!folio_test_dirty(folio) ||
>      (folio_test_writeback(folio) &&
>       (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
>      unlikely(folio->mapping != mapping)) {
>      folio_unlock(folio);
>      continue;
> }
> 
> This is somewhat beyond my expectations. I expected the flush worker 
> could handle such cases, allowing page reclaim to skip from handling 
> dirty file folios to improve reclaim efficiency. Obviously, I overlooked 
> this corner case.
> 
> Additionally, I'm still struggling to understand this case where a folio 
> is dirty but has a NULL mapping, but I might understand that ext3 
> journaling might do this from the comments in truncate_cleanup_folio().
> 
> But I still doubt whether this case exists because the refcount check in 
> is_page_cache_freeable() considers the pagecache. This means if this 
> dirty folio's mapping is NULL, the following check would return false. 
> If it returns true, it means that even if we release the private data 
> here, the orphaned folio's refcount still doesn't meet the requirements 
> for being reclaimed. Please correct me if I missed anything.
> 
> static inline int is_page_cache_freeable(struct folio *folio)
> {
>          /*
>           * A freeable page cache folio is referenced only by the caller
>           * that isolated the folio, the page cache and optional filesystem
>           * private data at folio->private.
>           */
>          return folio_ref_count(folio) - folio_test_private(folio) ==
>                  1 + folio_nr_pages(folio);
> }
> 

I continued to dig into the historical commits, where the private check 
was introduced in 2005 by commit ce91b575332b ("orphaned pagecache 
memleak fix"), as the commit message mentioned, it was to address the 
issue where reiserfs pagecache may be truncated while still pinned:

"
Chris found that with data journaling a reiserfs pagecache may be 
truncate while still pinned.  The truncation removes the page->mapping, 
but the page is still listed in the VM queues because it still has 
buffers.  Then during the journaling process, a buffer is marked dirty 
and that sets the PG_dirty bitflag as well (in mark_buffer_dirty). 
After that the page is leaked because it's both dirty and without a mapping.

So we must allow pages without mapping and dirty to reach the 
PagePrivate check.  The page->mapping will be checked again right after 
the PagePrivate check.
"

In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3 
data=journal") seems to be dealing with a similar issue, where the page 
becomes dirty after truncation, and provides a very useful call stack:
truncate_complete_page()
       cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
       do_invalidatepage()
         ext3_invalidatepage()
           journal_invalidatepage()
             journal_unmap_buffer()
               __dispose_buffer()
                 __journal_unfile_buffer()
                   __journal_temp_unlink_buffer()
                     mark_buffer_dirty(); // PG_dirty set, incr. dirty pages

In this fix, we forcefully clear the page's dirty flag during truncation 
(in truncate_complete_page()).

However, I am still unsure how the reiserfs case is checked through 
is_page_cache_freeable() (if the pagecache is truncated, then the 
pagecache refcount would be decreased). Fortunately, reiserfs was 
removed in 2024 by commit fb6f20ecb121 ("reiserfs: The last commit").

