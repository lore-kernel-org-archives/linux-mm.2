Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39DA9CAC587
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 03:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3665C8E0003; Fri, 12 Sep 2025 23:24:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E1D8E0001; Fri, 12 Sep 2025 23:24:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27A328E0003; Fri, 12 Sep 2025 23:24:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 152528E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:24:45 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8C2CA1A0A26
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 03:24:44 +0000 (UTC)
X-FDA: 83882784888.09.19A054D
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06651A0011
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 03:24:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OE+Xq6IS;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757733883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3I2VSj+5/i2iRYQrnjqI4t6HKmkDRL5/Des0wQPmt0=;
	b=Md7Gju6N8lAGLKbAh1YWO+8lTOtIvMzAJPYpID1YHA+MepAWAkjcHCR18j8nCUzqZJH6bh
	dd7tCWmCl9aw5St2kdJb+9tFvqecVM46e1qCT+7gKjQm0j4ABq/3wKPt38MyuTv2OCkSl+
	I5PzKsXo/rZ3mlXO2rP/Qu4Q8914r84=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757733883; a=rsa-sha256;
	cv=none;
	b=38odV3vu0OOeEqG6nY+lgxwl8n90wKSYC1yBrwNX73qUFQy0GWtWsCuPbqXYJx0y0C6RnR
	CKjqHVyz1qbEjPbIHavCeTJtfhcZBUJhinkuOHSvWXYVhAb+BpWGJCaqlL80gyYDQP2o/2
	22PJkahfVC/IfLulFc82VpIZPuVk7fQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=OE+Xq6IS;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757733877; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Q3I2VSj+5/i2iRYQrnjqI4t6HKmkDRL5/Des0wQPmt0=;
	b=OE+Xq6ISQlEqNRRGoO9wxgrvv8nh0tK39sZOgKQlm06sDllm+qdFyZUsUCa5L+bzIGemELhrqKQDgcwjLd+AC9DCCXzxfhkz0yHiiIFD3gg6biJnK/2GLsG+lex0ebbvTTPbsi1lzP2D0piZKl+2cJTwpAgRG1hNuWYFzgsUDlg=
Received: from 30.134.50.220(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wnsej1J_1757733876 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 13 Sep 2025 11:24:36 +0800
Message-ID: <02798d6c-1ad3-4109-be3a-e09feb5e4eda@linux.alibaba.com>
Date: Sat, 13 Sep 2025 11:24:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@redhat.com,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 hughd@google.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <qe56xt2natnxnkht7wgknsb5nqjhinaaajomvvvgnfpwry2jih@hsj2w5zqj6wv>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06651A0011
X-Stat-Signature: eowxskgry83ouurw9e147p41yf45i9wg
X-Rspam-User: 
X-HE-Tag: 1757733880-487214
X-HE-Meta: U2FsdGVkX1+69ThX7ZC5SgSRe6Isvk4FVeWwsaRqcAGPlA5A4l2dmyI0atsh1qrXDVK3gx0VEQufvxm7oPUFwWLXngsBNdTi0xASIldeCn7gMdCw0+qBbT+QMj0rS4yAga+nOvSjsQ5Y0nHoUsmvPGhAHW607dH127NE8MO3CKczwzreb6eoklbswZreaZrYcBmwnmO52N7yk8CKE/lKqtrMk9hL+9hWYd9+LXDspN5C6MV51IyaxNdByFvdKZjT0YqGBWqLvb+LQoKwJ0R0yRT5mdP6WfefDIvJWcqeNihMs991ZbnsNsDmLGqmvDpb897eeXF/TGMGaMdU05vt+/IpHViVoBla/WHdqUTfkGbYTRonAdEODFdQbHJWfLnIqEZ53dbwbxmSbMo+l/49RO1BdyrOvgKUMMkpjWRRKZoEKLmSE7dIz0iRZ10bFRvoATfG0cHWu52mo7bRuus0kYIRQv16ULEtRmDtebimXWZ4l1hbpLbPUPwsVB9D9VkGwUV4JXpxg8eoj8Depivt6aq0Bm5YomySfBTmORULKQxcKM5zELqaD/Ogmez9oKsjsI3aDtD7mCjXYIH1K7aEbqRxAePcjg6/soJcUKAoAfD2kgM/ie9BlLJFUSIqbpMuXERCQwZ+0Yl6i+EBykC+rgclTitccACl39JdQkp5eVlo3dhBr8ewjRuw63zBap935GqP2pd3PmjAiLCDDwtVS4fAG+OkDGyjzjZ710P7VFrXn+fuLEIQcNmdncvuNTgKbpbUboix9v1HZBGsxBwoEoDtqeLofmgll6NGbA0/RbiR2l0yZPgFJYTmRbmkRofo4mYLPArGp5W9MU9A7YpoImYJbIlc4nOxI8QCVU5moulQ2LBv6MfLLoxKuc69etoqE3nITHjpUBDTxvLMgaD8O48XMGRzpx0OMeo2JXKUqPCijE2tivxTnLY4OETnS/z5L1Tlxm9G2Py5hJ+PubC
 0J9JrlQ/
 a9pZwJmb24L1VYT5+HyNpXLs8qJNzp/WrwrTMOOHKhMp7XDtZVAYp/VXuFeBt9HEpfZOQzYFQSUXY+3PVbhCo8v8gtZxlx8pNKn2NsywUaMDBlxXFLYczl+90n3hiM0OA99qOBQlxEDhDaL6pv7d3eQcSDR8UGKmiq5Gew9XxT01OYBTIWQwOs7j3PbuMOl3YC8znwuB2URH/gvgQytwSLo6SEQ/er7KFPTjuBI1XFwLARERIvjteJ5CnUcrkRoJuSCbXcw0jiz0lOtb98lFtNQgKSZYjQJMygsnrwvAOkqPhGFrtDR6nfROidg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/13 00:13, Shakeel Butt wrote:
> On Fri, Sep 12, 2025 at 11:45:07AM +0800, Baolin Wang wrote:
>> Currently, we no longer attempt to write back filesystem folios in pageout(),
>> and only tmpfs/shmem folios and anonymous swapcache folios can be written back.
>> Moreover, tmpfs/shmem and swapcache folios do not use the PG_private flag,
>> which means no fs-private private data is used. Therefore, we can remove the
>> redundant folio_test_private() checks and related buffer_head release logic.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/vmscan.c | 16 +---------------
>>   1 file changed, 1 insertion(+), 15 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index f1fc36729ddd..8056fccb9cc4 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -697,22 +697,8 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>>   	 * swap_backing_dev_info is bust: it doesn't reflect the
>>   	 * congestion state of the swapdevs.  Easy to fix, if needed.
>>   	 */
>> -	if (!is_page_cache_freeable(folio))
>> +	if (!is_page_cache_freeable(folio) || !mapping)
>>   		return PAGE_KEEP;
>> -	if (!mapping) {
>> -		/*
>> -		 * Some data journaling orphaned folios can have
>> -		 * folio->mapping == NULL while being dirty with clean buffers.
>> -		 */
> 
> Can this case not happen anymore and try_to_free_buffers is not needed?

For dirty file folios, pageout() will return PAGE_KEEP and put them back 
on the LRU list. So even if mapping = NULL, background workers for 
writeback will continue to handle them, rather than in shrink_folio_list().

For clean file folios, the !mapping case will be be handled later in 
shrink_folio_list(), please see the following comments:

/*
  * If the folio has buffers, try to free the buffer
  * mappings associated with this folio. If we succeed
  * we try to free the folio as well.
  *
  * We do this even if the folio is dirty.
  * filemap_release_folio() does not perform I/O, but it
  * is possible for a folio to have the dirty flag set,
  * but it is actually clean (all its buffers are clean).
  * This happens if the buffers were written out directly,
  * with submit_bh(). ext3 will do this, as well as
  * the blockdev mapping.  filemap_release_folio() will
  * discover that cleanness and will drop the buffers
  * and mark the folio clean - it can be freed.
  *
  * Rarely, folios can have buffers and no ->mapping.
  * These are the folios which were not successfully
  * invalidated in truncate_cleanup_folio().  We try to
  * drop those buffers here and if that worked, and the
  * folio is no longer mapped into process address space
  * (refcount == 1) it can be freed.  Otherwise, leave
  * the folio on the LRU so it is swappable.
  */

>> -		if (folio_test_private(folio)) {
>> -			if (try_to_free_buffers(folio)) {
>> -				folio_clear_dirty(folio);
>> -				pr_info("%s: orphaned folio\n", __func__);
>> -				return PAGE_CLEAN;
>> -			}
>> -		}
>> -		return PAGE_KEEP;
>> -	}
>>   
>>   	if (!shmem_mapping(mapping) && !folio_test_anon(folio))
>>   		return PAGE_ACTIVATE;
>> -- 
>> 2.43.7
>>


