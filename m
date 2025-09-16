Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C008CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 07:18:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630AB8E000C; Tue, 16 Sep 2025 03:18:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607F18E0001; Tue, 16 Sep 2025 03:18:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E458E000C; Tue, 16 Sep 2025 03:18:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 41BAB8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:18:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02A93C08CA
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:18:37 +0000 (UTC)
X-FDA: 83894260716.30.CC82354
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2E8F81C0010
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 07:18:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yRkJtSdR;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758007116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEIJopGBHha5mxI192yQ8swZlaL8UDF92y3iDqtrvSw=;
	b=U9/XhqOWe+iP/kaYbQxXK9XMqm+6i00UXJFaEPK7bp3VImPD5zdKwnUH9TA7F32mGo61ry
	FnlZbHPI6suleiziK3ebVk6UkBykNP0Zr6f4tx+q2MeS7F7OqpXq5abLIvO70wGS9Q92qh
	eIO6ASNNHX9OpbeWhD5uuQlmDAnupiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758007116; a=rsa-sha256;
	cv=none;
	b=74iQxW7vlwR+AnG+TawkCQ/W/xugU4XsJ/WoFvY+B1m4c2M+jTeC2fxoA7AypFGdw3Q3Xk
	Cl7IdN1Ea6cu/y3UUyIDbWv1NJ5DqJxP3uxci16UMM3Iqfn9rGjE2ESfe+LnmxvHKtz80N
	WNlOdPObvuxNY22zooeJWlZUrZSOaQ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=yRkJtSdR;
	spf=pass (imf21.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758007110; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jEIJopGBHha5mxI192yQ8swZlaL8UDF92y3iDqtrvSw=;
	b=yRkJtSdRa4nNTuUhn6dBrl4BnP1fbPlCCgA61veAq/5eOI9wFb7iabiu2DpxgKwFIHheVFOtzgjfoP+xrW3P1hVaJEE6GvjoQGj6fgkZktMdEicuzWeV81VCEumUILnAharjPdkzsg50rhTbi6X/fakF6rpT4opAX8ywMloQ7jM=
Received: from 30.74.146.196(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wo7PMF3_1758007109 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Sep 2025 15:18:29 +0800
Message-ID: <6ebb5cd0-0897-4de7-9303-422d0caa18cb@linux.alibaba.com>
Date: Tue, 16 Sep 2025 15:18:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <9b01a2cc-7cdb-e008-f5bc-ff9aa313621a@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2E8F81C0010
X-Stat-Signature: fqmpb7qw5491zkk1caqpesqchkp4yps1
X-Rspam-User: 
X-HE-Tag: 1758007113-185217
X-HE-Meta: U2FsdGVkX1+9I3FCOFz8q+wWVqwfNbxGcZqRMF/0IgV6nSg2M0nBxXGNtTCntJcgrD1FUlp0C+so8JcV8MbrlAOes6HcBPxUVUCAE2x6uYDOLr/I80dqQtHmRL/QCeFuXyYYWhY2tfBtkK410ak/5XgkuGJnQcjqwteDYnyyBQZe/cIfaY2IixURphNk7+og1rx95sDg90afVfYrYhRFv6aW6zP0IxWw1+DF1kTkSjCSXRPF/yrEp2zMZa4TcBRF1BookOd7IR1fNf+yPbwCXG3aK8eXVaIL9ySEs+8nIcZU9QGgxTIAAHTtUpX1BKlIo1CmFMJvGcNXFD0M9bpGiX8NmXaNwnsfq061YuKJTa7LDWwRUR/yu3q+Nes6hXjsTeYBFnZbqCZn+R94LwvTt0grQjr+rbP20KFms5wyZXhRQP3zJWkMUACWCRQBeGPw0re5105YupU5xRn0kBdTTGFhz9R5czrGSg0GkKKMw8LFzVfOeuGTTjNLIPwJA7y9Oxv7UmJQWW3sOcU4lRsHVOZ2vyhsZrrfbao9JvwjNMy5CLaINU7Uq3McmTNnPitygQFRpnjJUe5yGd79jVrEqwDfPOa3lR415XmnXPVY67BVwr/tNozFC/gJYSOSxp94lCF9VzC9YUqFJWXMY4+kD14v6P81veUKPEz+4KKyg48pS7SvhhuiKjaTQFlEIpEuM3SttpGRxApBi9o07fiON/pt0U1yUqQBiCzdkXEIFfxX66ocbwmF7I+6LiU5iAwotRapoUdgDGN68p1o0lsfgSOzalRvzsk9vjR3FkhnVbZ0/x7EIMovljmJdmKptgfm1tM6YHIkkS8AEwxRbRDv/eukOibTDPkliJc8MHsIxb0RYDZzVV9RV4zYLIDwL4EOby5gsa10Ahcmim5mAcVwzmL1dzYC8zJNfgrgNw+5viEHu/bpijI6PHjr+/ODXwMW+92BVy7jwzE7BndiZZx
 BeqgUTZ9
 h6h0j/wFzhKN++4gSM3t4lVqyOQHRGtd3UHSHHq7MIUiCQD3zgvkeOB2cxtdzpO8RHfxe9ekp31aYxBy23gUYBmJDTfuZpN/bjbIUMJwFTDUIwwROmIPKxBdzzN82ezjizcdISz0m67yUGA+aXX+D/4Fp2ZHDvKxc7piwy9byHcalKq2RhSficvdqL/rjHYlTS69p4SYggYIHLS1VLZ2lFoGvYnPt+CwMVhcm2knKkQQiEkzEdNHkdfJT2GGFXIf+5V45tIOaAvTG+lI3YYmTj572zU+nhippBgCkPFu9n9dITnymvXRuLcX4ZAYJ994BrUwsXYbVSN9rQqEdK2TUzDNeTKN54Y7pkA24iRs9Z3WVQOF0wEFdEvxRxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/16 12:00, Hugh Dickins wrote:
> On Sat, 13 Sep 2025, Baolin Wang wrote:
>> On 2025/9/13 00:13, Shakeel Butt wrote:
>>> On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
>>>> Currently, we no longer attempt to write back filesystem folios in
>>>> pageout(),
>>>> and only tmpfs/shmem folios and anonymous swapcache folios can be written
>>>> back.
>>>> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
>>>> which means no fs-private private data is used. Therefore, we can remove
>>>> the
>>>> redundant folio_test_private() checks and related buffer_head release
>>>> logic.
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    mm/vmscan.c | 16 +---------------
>>>>    1 file changed, 1 insertion(+), 15 deletions(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index f1fc36729ddd..8056fccb9cc4 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct
>>>> address_space *mapping,
>>>>      * swap_backing_dev_info is bust: it doesn't reflect the
>>>>      * congestion state of the swapdevs.  Easy to fix, if needed.
>>>>      */
>>>> -	if (!is_page_cache_freeable(folio))
>>>> +	if (!is_page_cache_freeable(folio) || !mapping)
>>>>    		return PAGE_KEEP;
>>>> -	if (!mapping) {
>>>> -		/*
>>>> -		 * Some data journaling orphaned folios can have
>>>> -		 * folio->mapping == NULL while being dirty with clean
>>>> buffers.
>>>> -		 */
>>>
>>> Can this case not happen anymore and try_to_free_buffers is not needed?
>>
>> For dirty file folios, pageout() will return PAGE_KEEP and put them back on
>> the LRU list. So even if mapping = NULL, background workers for writeback will
>> continue to handle them, rather than in shrink_folio_list().
> 
> You've persuaded everyone else, but I'm still not convinced:
> what are those "background workers for writeback",
> that manage to work on orphaned folios with NULL mapping?

Sorry for not being clear. The ‘background workers for writeback’ here 
refer to the workers responsible for handling the writeback of dirty 
data (see wb_workfn()).

> I think *this* is the place which deals with that case, and you're
> now proposing to remove it (and returning PAGE_KEEP not PAGE_CLEAN,
> so it misses the filemap_release_folio() below the switch(pageout())).
> 
> There's even a comment over in migrate_folio_unmap():
> "Everywhere else except page reclaim, the page is invisible to the vm".
> 
> And your argument that the code *afterwards* rejects everything but
> shmem or anon, and neither of those would have folio_test_private(),
> certainly did not convince me.
> 
> Please persuade me.  But I've no evidence that this case does or does
> not still arise; and agree that there must be cleaner ways of doing it.

I did some further analysis, and seems you are right. The flush worker 
does check the folio mapping when writeback, but it does not further 
release the private data, for example, in mpage_prepare_extent_to_map():

/*
  * If the page is no longer dirty, or its mapping no
  * longer corresponds to inode we are writing (which
  * means it has been truncated or invalidated), or the
  * page is already under writeback and we are not doing
  * a data integrity writeback, skip the page
  */
if (!folio_test_dirty(folio) ||
     (folio_test_writeback(folio) &&
      (mpd->wbc->sync_mode == WB_SYNC_NONE)) ||
     unlikely(folio->mapping != mapping)) {
	folio_unlock(folio);
	continue;
}

This is somewhat beyond my expectations. I expected the flush worker 
could handle such cases, allowing page reclaim to skip from handling 
dirty file folios to improve reclaim efficiency. Obviously, I overlooked 
this corner case.

Additionally, I'm still struggling to understand this case where a folio 
is dirty but has a NULL mapping, but I might understand that ext3 
journaling might do this from the comments in truncate_cleanup_folio().

But I still doubt whether this case exists because the refcount check in 
is_page_cache_freeable() considers the pagecache. This means if this 
dirty folio's mapping is NULL, the following check would return false. 
If it returns true, it means that even if we release the private data 
here, the orphaned folio's refcount still doesn't meet the requirements 
for being reclaimed. Please correct me if I missed anything.

static inline int is_page_cache_freeable(struct folio *folio)
{
         /*
          * A freeable page cache folio is referenced only by the caller
          * that isolated the folio, the page cache and optional filesystem
          * private data at folio->private.
          */
         return folio_ref_count(folio) - folio_test_private(folio) ==
                 1 + folio_nr_pages(folio);
}


