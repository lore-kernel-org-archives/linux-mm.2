Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C375C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 08:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380DE6B008C; Wed, 23 Sep 2026 04:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30A856B0092; Wed, 23 Sep 2026 04:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 223726B0093; Wed, 23 Sep 2026 04:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EAB916B008C
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 04:26:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 206A5120725
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:26:59 +0000 (UTC)
X-FDA: 85244346558.28.E764DC3
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1130C40005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:26:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790152017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gk3dWSjh3bMZwynRB1J6oHqsHzXkZaGvpuatS9+W8D4=;
	b=EEEW1a3biSz3ApgoJiUla6mBVQQNldRoHkCp7mkLSyc73U0u5cShq8wckOujIDGsPZE3U3
	1Jf+041wwEPbMCJLTtTA6Xj0U0RjvTZ8fJdV4Y3hBIKsITBg3x9a3jFQbAEq6V3S/ODavw
	NTOu+gEVns1cJgiwASLkOnJQs+D84n8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790152017;
	b=k+47INQ0pxhJxk+84HfAQAXzE430597LzmOQXEnhIr4CMr/t6t0A633Uiy73iKyyRQ1sc6
	lxv4MoEb6TvPG9DFkGU8YtohADufJ3nqpFLX2wS580Tzjm3BEWGSP1vRtlJvf3IhLFyK8d
	GYhn6PQSu06LoOpINcADYgchFLv94yM=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hqVRt1QZHzYQtyg
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:26:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CFE4840561
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 16:26:50 +0800 (CST)
Received: from [10.174.178.176] (unknown [10.174.178.176])
	by APP4 (Coremail) with UTF8SMTPSA id gCh0CgD3xik9jbNqnU90BQ--.63352S3;
	Wed, 23 Sep 2026 16:26:50 +0800 (CST)
Message-ID: <96190266-10ac-41be-8d6c-972cb00d3c44@huaweicloud.com>
Date: Wed, 23 Sep 2026 16:26:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/4] mm/truncate: align truncation boundaries to
 mapping minimum folio order
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, bfoster@redhat.com,
 joannelkoong@gmail.com, djwong@kernel.org, yi.zhang@huawei.com,
 yizhang089@gmail.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com
References: <20260922110703.468389-1-yi.zhang@huaweicloud.com>
 <20260922110703.468389-2-yi.zhang@huaweicloud.com>
 <DLLYA97QG5ES.P4FF23PGA3MQ@nvidia.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <DLLYA97QG5ES.P4FF23PGA3MQ@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgD3xik9jbNqnU90BQ--.63352S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF1DAFWkZFW3AF4UJrWUJwb_yoWrJw4fpF
	ZrGa13AFWkGFWxCr4kuan8ZryFqaykXa17CFyxtasakFnaqF1UKry2g3W09a1DGr1xJw1F
	qF4jya1kW3WqyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_JFI_Gr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIF
	4iUUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Stat-Signature: rco3646aqbu6q1hn8qrdi4qq3ckoanjy
X-Rspamd-Queue-Id: 1130C40005
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790152014-114056
X-HE-Meta: U2FsdGVkX19qi3MEPYHMsF5lJnM6kHMcNgFLwWab7H1OGiAKo54lTAwItK3sIzjVuddwQ/LhnTDMaES/U5b5q2+LNyejAwZ59UBjtOY1+YZ9wEv8Zhh1YyyuzP3K1Ghu7mQpCRdjmC/yDbRmYC/UXSVrTjzlyD47qQASI2JvzZMJ5u+UXXBKrMRakCTaTqdjcDUHma3RNnkMtszDOcNLoTXoNz41qny1vZbPyTfZnjp4w3953OFiMF/smWQL1X2zRxIIwTpQW1e51ynbC2ONfx/WVxTWXlRaROX9pqL2pMPcVQPyvIHWbzNQENgK1AXZdGtgUp93ZohnpFEsywmiqCrWR8SZYKbYf1PLNv+CuLAwlSGYMdUd4Ocs8OK3vCTW1yZFhNou5JZlaHWT590sugeTKWaCgx3bYalZrvvarznJcNn6vQubBkZdX3aj/zHzBl+ha2mJ/2p0efdQtKHglLldFpGn7OxM2wPOi7viN1ThccWXP6c/9LqcnaB2u0YRPMoH7OpZ9OXZ2D2qnCbr1wipG5gome7SbuGOJCrVLuK6SnoKWzbSARf5wIaeDNNpipQ6MpF15XbkYqsVQpYdTf3eWu6szX5DL+UYpQlkBLDULgrLOL5Ve6D/2OZ/YrNQmxYpnWJPAtYjXdUFJoHAz0L2zdfgz+ZCXRLcsBWWzPWtkJWVkKXVdBz/PW/IyfqxxQtUVLSyrWTkJs60X/bG3xJIv1uDvFtodZURiUd4ZEp4eISK/qoVRN8DfF5xUWoYOensqJQweElE4DqtHOGF3tXjx+xCqBqKpZ/TT1q8rkRYb/CnZvPgeN87RTjfkHO4JB67Y7TnFFdxcWOwZ5kO9Hl0JQpT3/jKN97mGwAAcZIQe/Z+WaYKkRmCKBAOVc5bxYX4Gmwy3c71dr3H5ddJhvfB2XH9QN5sRhTyrAzgaNmBPgnpgmFDIwMjIK6SpFfbOm/8ckQAcxnCOJxJGBN
 Xj19tOVn
 b1qRw9xciFdAelbam8NNpNxPY9bNjNhfJBUDKekNs5odHlfOmBXHJdh0XVMx675z/SBEBGD+FU697lI8weZTbf8bjRh4TaCJYyjMvV4qc02xYkJJh9GbBlVgEbuHrTFyKeT0nsg3k5spBo2D67cF1T00E6tnHZJfdyArudhQRmicc8rndzorwCkw4g29XEIYB0GV3k5dykin+nHMQGsHj2xmMtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/22/2026 11:29 PM, Zi Yan wrote:
> On Tue Sep 22, 2026 at 7:07 AM EDT, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> When the mapping has a non-zero minimum folio order (min_order),
>> folio_split() in truncate_inode_partial_folio() stops at min_order
>> instead of order 0, so the sub-folio containing a split point stays
>> aligned to 1 << min_order rather than to a single page. The original
>> boundaries in truncate_inode_pages_range() were based on page
>> granularity, so either boundary could land inside the min_order chunk at
>> its edge, and the truncation loop would drop that whole chunk, valid
>> out-of-range tail included.
>>
>> For example, a 64K (order-4) folio with min_order = 2 (16K) punched from
>> offset 0 to 36K:
>>
>>   split @p0 -> [p0-p3, p4-p7, p8-p15]         # non-uniform, min_order
>>   folio2 = p8-p15           # straddles: p8 in range, p9-p15 tail valid
>>   2nd split of folio2 -> [p8-p11, p12-p15]    # success
>>   end(old) = p9                               # BUG: p9 inside [p8-p11]
>>   loop truncates ... p8-p11               # p9-p11's valid tail is lost
>>
>> It has gone unnoticed so far for two reasons. A non-zero min_order is
>> only used by filesystems with a block or sector size larger than the
>> page size, and those either always write back the affected range before
>> punching a hole or truncating, or they carry filesystem private data on
>> dirty folios (e.g. buffer_head), which makes filemap_release_folio()
>> fail and folio_split() abort with -EBUSY, so the folio is never split
>> and the old start/end boundaries remain valid. The bug only becomes
>> reachable on paths that truncate dirty large folios without prior
>> writeback and without filesystem private data, such as the upcoming ext4
>> iomap buffered I/O path.
>>
>> Align both start (rounded up) and end (rounded down) to the mapping
>> minimum folio order so they always fall on a folio boundary.
>>
>> Reported-by: Joanne Koong <joannelkoong@gmail.com>
>> Link: https://lore.kernel.org/linux-mm/CAJnrk1bQYUe6+1ryyJur5EEnZYrC+_5AYsy=OWzVRgD4202y1g@mail.gmail.com/
>> Fixes: e220917fa5077 ("mm: split a folio in minimum folio order chunks")
>> Suggested-by: Zi Yan <ziy@nvidia.com>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
>>  mm/truncate.c | 18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
> 
> LGTM. Just a nit below.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..f9625bb4916f 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -345,9 +345,11 @@ long mapping_evict_folio(struct address_space *mapping, struct folio *folio)
>>   * @lstart: offset from which to truncate
>>   * @lend: offset to which to truncate (inclusive)
>>   *
>> - * Truncate the page cache, removing the pages that are between
>> - * specified offsets (and zeroing out partial pages
>> - * if lstart or lend + 1 is not page aligned).
>> + * Truncate the page cache, removing the folios that are between specified
>> + * offsets (and zeroing out partial folios if lstart or lend + 1 is not
>> + * folio aligned).  For mappings with a non-zero minimum folio order, the
>> + * boundaries are aligned inwards to 1 << min_order so the edge sub-folio
>> + * straddling the range is kept.
>>   *
>>   * Truncate takes two passes - the first pass is nonblocking.  It will not
>>   * block on page locks and it will not block on writeback.  The second pass
>> @@ -374,14 +376,14 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>  	int		i;
>>  	struct folio	*folio;
>>  	bool		same_folio;
>> +	pgoff_t		min_nrpages = mapping_min_folio_nrpages(mapping);
>>  
> 
> It is better to put it at the top (reverse christmas tree).
> 
> 

Sure, will move it, thanks for the review.

Yi.





