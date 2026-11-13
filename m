Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0112606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 05:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=XiEM1jkt
Received: by kanga.kvack.org (Postfix)
	id 06EDE6B05D4; Fri, 13 Nov 2026 00:39:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01FEE6B05E1; Fri, 13 Nov 2026 00:39:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9EC66B05E7; Fri, 13 Nov 2026 00:39:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C82E46B05D4
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 00:39:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6042D1401F8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:39:27 +0000 (UTC)
X-FDA: 85428993174.17.CF4C6FC
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id 802CC140006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:39:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XiEM1jkt;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794548364;
	b=2nNzAfIfPReuyYmp82UUS70P+2InpoeR72LsV48OImGXuSa1Nnj5Vygq2XTNUxv/kN6lYy
	hwD0s9VHZ/epAcPGJNo6sStHsCJz8NjdzBdkcY0g7Ld5y7vR9/U9C0Ii+F2Vse89XPm7qh
	dO40cOUXlrMphpVdm6N++bNy3DREeVI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=XiEM1jkt;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794548364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rfDGBAcafKezqinDyA203mmJPgTuUKXlIMMfgq4UE8=;
	b=mWPkGEyPeV5QgMhjraGCo8QIXIvV+qL22w1OrF9rnbduWjvBp0sIIjU6cylK8FOEtDDtNk
	RxfVS/fQB68ei55EB9vUiZzQKFRsFB4eBL5EQC7OjcUW1rPW2qCdbB/Du091AhmOaA9l85
	lb7EbngOc6FfRA3aK4ih+1rh2cr4ffg=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794548360; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=0rfDGBAcafKezqinDyA203mmJPgTuUKXlIMMfgq4UE8=;
	b=XiEM1jkt2POCsHYNa9XX7GAdBifIErUVppJAKeCOVkhM46pZbPgDUuRX39b82RMnoNt2VIQ0RBxEG2Vj5LHqH1sGuSANs10ZP1yTTBIeUCvrzNL2+eE7Ggm6uE2l9a03hqNIo+qNicFjSnOr8DcSISnU2BEd/DOCx1yTT3cm1+U=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XEe.jFP_1794548359;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEe.jFP_1794548359 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 13:39:20 +0800
Message-ID: <8e342039-2e73-4657-9ff6-55a71b5cb678@linux.alibaba.com>
Date: Fri, 13 Nov 2026 13:39:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: drop the second folio batch from
 shmem_undo_range()
To: sashiko-reviews@lists.linux.dev, Qiliang Yuan <qiliang.yuan@linux.dev>,
 Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
 Jan Kara <jack@suse.cz>, Qiliang Yuan <odys.yuan@gmail.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, kernel test robot <lkp@intel.com>
References: <20261111-bug-mm-shmem-undo-frame-v1-1-e50a95b8f9b2@linux.dev>
 <sashiko-outbox-212134@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-212134@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 802CC140006
X-Stat-Signature: bq47okhu74a3gmt1ty5efz3jnfhutgb7
X-Rspam-User: 
X-HE-Tag: 1794548363-551057
X-HE-Meta: U2FsdGVkX1+EGEFcDQhMtaQqgL64IjWIS4aG47I9uwprD/KnHtLixAWJEjqCxSJ8uHreVmHxgMd6Qk2P/5MLliofsF/yRyHpoUzGpDf0jw3iP6CsbYal9T7+4k8usGs3ZmwWCLIMZ8VE89xvMcHNgKCuZPbHIkGZjhiSZjruGTgdFDXFazW/iuwQnLlelJLL5BUkcODTpdzXzaoR2BgOyAnSyVZ1HN7EwAbggNCD72IJUrVwGhCuzQPARNO++w5NxagCacA/jNmI3rOGLAiu6GjWrn+Or7JTnHSnHbfD829hgB68mOetXQQ8rH27TBkHl8LeySxBofN4XlXSf3SzUSKVRmpTcm0AK5tJBZIYtzIHJmvDZjYNCPNhvhC0MPgVrrjJIvHhKvjXHBRbhdfztdcmEQPmfKJUv1BbT4XOqSEi28daom4mmezNi+AvfVzJ0cD6Vrtd7GmgUGzf5OBj3WHS7r36Cv5wViSlJE1Jd6L35IvLPSS1CrnF/5JFzn9QGlVPZYTe9JuReCGTVfpIk3e7AMPNzE+tkExbrM7Ov4c+BCxGes+opCkC+g3LerxtgeCUZwjZsy4PjbFeI2H2ybwMhkQ4iXmMSwoxCm5Q7NFHdsZE0Ww3BfvmPGWMeksSjXcqB7L+vTmbJzbjUC+tA/MHD3a1TAEQhcuPtm18o/CivmAZNv8b3HJ62xN2N3Rcg2KtYOPVVSRHQ0CHlq/4VMnVyCOQ/WW2uvPjE+g0dY8Zeh0QEZEOXFy9ESMmXMkPLRd5kENWmJBd6RNnKMGhE5MnVjvezsB9aiL6RI7HTljUfKuTNGkIhph6TPxO4xFf4qJxcAqlJc694qZeIx+S3A5RZ9L8zsG1h1NDvbBXUJAnAodo7gDr8Vua+XHZFnRLtrA8JuZJbpHhMLpWy0mF2iiuMn0evrnpCw9PB7et9uaIf46qguK3KSkCg8IPBO5jV64HhoCtxpK/NMjq03T
 bNZa9xYn
 KwfMhM5XvYow0snf50OWmAwIIa0xTauV9UVkq/+Tcbrtyf98MxZca10HUExYnl9hJgAZ5yy+CkEVBsz+ib7t4klXOHXUWgAkX/HAZyDVR/Ud80H3PwhlYASf46U6LsrgHWjheonsbYKSVogIrNfNfy0kCPvBMEvW6e4ANkbSRkTSbug3IPTmLlnVPeysOVxFBKsRm847/DJXQC7k89CwkFSgioKnbdBZeQ6QnnmIozKAwzkElp1EmY1YC8E3dGxI5s2YylTnw6P0NkOYUARd87F3+3ndrcKq1iHO1dkl33//vaKhdzfTNsyLMmB0XyOi5JYo0IudwOdm44Tv8UcDqDAxWaEOfQSGcxvZ7/6HMj3x8fnor50sLABu0nW9kazxq2qSfBN2xiSj8y+HIPS1jCd23vc0s38no4NHqWrT+oNZboAzeCkrm9BxtuGqrxumWkbCxF/oJ2/lcFMvaA14wm+/4i/eVntGRNO9EQVUn4vNxq7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 11:39 AM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Critical] mm/shmem: skipped boundary zeroing on swapin failure in
>    shmem_undo_range() [1]
> --
> 
> commit 785bd3384006f8bb06c3c8f9b1b5d455eba3d449
> Author: Qiliang Yuan <qiliang.yuan@linux.dev>
> 
> mm/shmem: drop the second folio batch from shmem_undo_range()
> 
> This commit removes the second folio_batch from shmem_undo_range() by
> passing fbatch directly to delete_from_page_cache_batch() after removing
> swap entries, and using truncate_inode_folio() when undoing a failed
> fallocate().
> 
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 156469423a866..5bcbdd6078a73 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -1352,9 +1352,6 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>>   	index = start;
>>   	while (index < end && find_lock_entries(mapping, &index, end - 1,
>>   			&fbatch, indices)) {
>> -		struct folio_batch remove;
>> -
>> -		folio_batch_init(&remove);
>>   		for (i = 0; i < folio_batch_count(&fbatch); i++) {
>>   			folio = fbatch.folios[i];
>>   
>> @@ -1366,13 +1363,14 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
>>   				continue;
>>   			}
>>   
>> -			if (!unfalloc || !folio_test_uptodate(folio)) {
>> +			if (!unfalloc)
>>   				truncate_cleanup_folio(folio);
>> -				folio_batch_add(&remove, folio);
>> -			}
>> +			else if (!folio_test_uptodate(folio))
>> +				truncate_inode_folio(mapping, folio);
>>   		}
>> -		delete_from_page_cache_batch(mapping, &remove);
>>   		folio_batch_remove_exceptionals(&fbatch);
>> +		if (!unfalloc)
>> +			delete_from_page_cache_batch(mapping, &fbatch);
>>   		for (i = 0; i < folio_batch_count(&fbatch); i++)
>>   			folio_unlock(fbatch.folios[i]);
>>   		folio_batch_release(&fbatch);
> 
> [Severity: Critical]
> This problem wasn't introduced by this patch, but can shmem_undo_range()
> leave partial boundary ranges unzeroed when swapping in a boundary folio
> fails [1]?
> 
> Later in shmem_undo_range(), shmem_get_partial_folio() is called to fault
> in boundary folios at lstart >> PAGE_SHIFT and lend >> PAGE_SHIFT before
> passing them to truncate_inode_partial_folio():
> 
> mm/shmem.c:shmem_get_partial_folio() {
> 	...
> 	folio = NULL;
> 	shmem_get_folio(inode, index, 0, &folio, SGP_READ);
> 	return folio;
> }
> 
> mm/shmem.c:shmem_undo_range() {
> 	...
> 	folio = shmem_get_partial_folio(inode, lstart >> PAGE_SHIFT);
> 	if (folio) {
> 		same_folio = lend < folio_next_pos(folio);
> 		folio_mark_dirty(folio);
> 		truncate_inode_partial_folio(folio, lstart, lend, &start,
> 					     same_folio ? &end : NULL);
> 	...
> }
> 
> If the boundary falls inside a swapped-out entry and shmem_swapin_folio()
> fails with -ENOMEM under memory pressure, shmem_get_partial_folio() ignores
> the error from shmem_get_folio() and returns NULL.  shmem_undo_range() then
> skips truncate_inode_partial_folio() for that boundary while the subsequent
> whole_folios loop skips any swap entry crossing start or end, leaving stale
> non-zero data in the swap entry that becomes visible on later reads or file
> extensions.

This is unrelated to the current patch. David already raised this 
concern before [1], and I'll think about whether there's a reliable fix 
for such edge cases.

[1] 
https://lore.kernel.org/all/20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org/

