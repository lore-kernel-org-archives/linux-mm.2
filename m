Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83CACC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 09:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA736B0088; Sat,  5 Sep 2026 05:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B676B008A; Sat,  5 Sep 2026 05:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C976B008C; Sat,  5 Sep 2026 05:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D5E1C6B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 05:58:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C0821A02DB
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:58:54 +0000 (UTC)
X-FDA: 85179259788.21.48037CC
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5E38740002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 09:58:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bC9gd2yZ;
	spf=pass (imf17.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788602332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qj4vV0CvvLoLzXN5EOEjZWiqSXRAO1ek/tVDgbN2tuk=;
	b=QjGHsZHczZJf+C3LzFYvQzpqNnaKcbA7yDm7I6TypZusEOXLP55JvmGvFQZ1uUj0awogSR
	QMP1aGrH/4bZqmR/9ZldbG8BVh6/w9u26/ky8Lm/KI62tSDLDdIVvDo6BFUtxZiGrUwyU3
	egRQ6oFzPTjQrU+I5NXBt1CYGWQxHkk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788602332;
	b=z5HQwMk3VdMXgQ5EtuAUAtq9xO6FVBS1FRe2eVIcLNVEQOMIEXO0EEYU+uSOMwrC9sKzWz
	h3NzZG4JdiQg/bZ9U0V28aUpxx7uWCgQEc+WSx4aGfzMROGdjx/QwZGt1noUWrr2ZwQxri
	szqgZAkIpFd3r14nTR5uOtYZutQZbEs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bC9gd2yZ;
	spf=pass (imf17.hostedemail.com: domain of yizhang089@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=yizhang089@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3964e480f76so2163274a91.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 02:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788602331; x=1789207131; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qj4vV0CvvLoLzXN5EOEjZWiqSXRAO1ek/tVDgbN2tuk=;
        b=bC9gd2yZ1eThecC5LJwsLbLGi9qqbTT+IJzK296eqD8AQalxLrj7sp1xwaKQ4LB+ow
         Eq6LJfvPRiRWs4DpEPMyT9HWrgTiqQqUt9C7p3WpDZqwOH8tmcB9MYoEN8/dlI1zFGU8
         +CBT784usilp7tpf+2cAktEQyZExdh8Mai18+atFiVtmK/KFvVwIKqzGvMtnfrnRU9pL
         YH7oe9qK+v0LHaT2ptJLo33Wzb6QfDJK5FCjlWUc9dn/VzcHPwspSkxDYqbGX7Py3fgP
         6QtwYFizNTAdgZ2Vdc3gsmih976ZfCscYKyh1FmncCc4jlQz18ueIvbSjgeFTWKBWUsC
         2ryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788602331; x=1789207131;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qj4vV0CvvLoLzXN5EOEjZWiqSXRAO1ek/tVDgbN2tuk=;
        b=ajPx3Q+6vxiXNXVEzEGi5+z4StChp2RfpVvHNmhvmrpgucQJ5dcdnPORf7i9Y66gQz
         9pjdV+f/PHUNNOyEesj7I+8JAX1umh+NVAeKzD3QsOFrE82XqvhPwmXChQRy8LynwM1o
         bvwcXVHZb3GH/qS+Vz0Bt57iMPo0Iat4J4neCyImolImxgpBsHHN8hGI9Hwr7rUVuz4x
         8ZFK4SXxykipNK5q8nYVy9iqQYLL4c/HWRHtWalp9vnlzS9KLvB7+vJiRabTJY2QwI1w
         HmUijia/Bx0NR6vU/VDNM69QjMW3i8ybnwemCIk0QJIRUT8rQLEZY8kdOSTiqFk7GMe+
         kayw==
X-Gm-Message-State: AFuF++kMNOcmX0Y87cb16Uy/4b/SXPtKk8Fr7KLVPN3m4TXCKpTqSFab
	TIg4zMGCkuoKY10kJ7zSd6zmL9LF+5qzzeZVDkwuz21nPYT+CbCGL3sUkvzxeA==
X-Gm-Gg: AYBFou0fs/zBebdABvwEofyFAwaQCBPe8py8+9RERBN7fIELDP2ZPiRAexL6ozz99KU
	wDpeOIEeObKiy0btoxnn3Z4loPTElVXboppYcmDjs3CDckW6VvAGhj+0cPYwJwGEoPNFlfmTL9y
	y3aMivvsxE8u1nVXIQ/vTjtYvASfiXHKf6kb/R++y6YUjofV4DYZVDd5DfojkwUl12YjyW4YMih
	j+R44bkfXpmT2Cq8k/PKmREbCqCGklMKxNnfHPxMezBlPG00ZnNTEf47QVP60Ck6IY5Rr9z8Tmu
	HI0ShWM0ITRtLhMYxwpde40yb2tvUMDYS+37Q8gMnOypG52H0mr5tKyFLsJR/e5TXxQSwvjJb+8
	pdFS5OHIObGz5EizugtfF1K5bHIlOJTOgREZmPAvT/GW9PaNPHeflEPyP93NTm+q24QFl/sEdcQ
	0lKF4Yeifu0wUDVeFaXZCbSGIE6sA+A+AfXwcVwq/vxrFq6N36U2MUP6nxRDbtjNexEP6fUQaCI
	wwCTjzB
X-Received: by 2002:a17:90b:43:b0:395:5eec:b932 with SMTP id 98e67ed59e1d1-39b26141c79mr18617204a91.11.1788602331167;
        Sat, 05 Sep 2026 02:58:51 -0700 (PDT)
Received: from [192.168.0.104] ([115.192.217.46])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b07b197a9sm15276472a91.0.2026.09.05.02.58.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 02:58:50 -0700 (PDT)
Message-ID: <06252b2e-532f-4359-ad8b-f8bc1f48e73f@gmail.com>
Date: Sat, 5 Sep 2026 17:58:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/truncate: fix data loss when splitting fails in
 truncate_inode_partial_folio()
To: Brian Foster <bfoster@redhat.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, djwong@kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com,
 wangkefeng.wang@huawei.com, yukuai@fnnas.com,
 Zhang Yi <yi.zhang@huaweicloud.com>
References: <20260903115018.2034541-1-yi.zhang@huaweicloud.com>
 <apsH60jXMc5Y6Imh@bfoster>
Content-Language: en-US
From: Zhang Yi <yizhang089@gmail.com>
In-Reply-To: <apsH60jXMc5Y6Imh@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5E38740002
X-Stat-Signature: p9e618e8qjoxsi5y7z7s8rfw5g1xx8bs
X-HE-Tag: 1788602332-459837
X-HE-Meta: U2FsdGVkX196XX104m4vBf/BzG5H4dHyYDNVg8oGs0PnTfw7i9ojQlyllvBMjj7f9p5ImflKPL9uWKjg/VXkq96r9Fi28lYam4LIPtqJTHgnL8rAEsH5fYle4FIg5fJ7ijMGif/+QGhtUGK1Mytfmx8XE97jft47cT6KaL4aDqucTWH+0osxH/wbglz5ObqYI/L19rBAKxw+ga+WRPoeUf1uie0rh+eKehCv7A3qkr36P8a6u8ejDoalbJNRrITMkuKb1FW2JsJtg9sUPDiTC//9SZW13PUbPFQ1UfhZx+mpriBqLABDvNkUsRwgWxJXi3UyTRc/WpNY2OvvXBS9jNiF7JlpmDSDKFzWzJWcsXasVU8XdpTM+kuRw7QGzw3c1OvwypUKGPB0U53f22tIiLTGeGeZoZYgFpebmMBOxzArRCnMZSg2uKIB92ERvuokc5dx6ZDMphDhwHYMv+NfIk1rIZJw2UOCsVf8RVcLNTuLr84zL5AJ1NM/LrebineheYK5bM4O+4SceIThayv82D0+QhzArcfU0u5G+CYuqhOTBbkv7Es9ye6ZvWx3NkCYmFmOX/AXM3ROETeZNV8rFzNeBPExXDJUpTxKFdmKzJsmsVIVZJdNUvHsFnxE5EYbSRLMoYyoSWGudme73StZQOWJbF/txbB+IUiSOxHJ4SyHCLqp8mleY9zmH5/dSl0UM0hg8V+qmL1UdRypBIeHyqieNc8RdgIiuy+Q8RntJ9CKbUb4BwL066On4MVH3+WkQyDh84QTcv+ljmIwf5DHbckmIjQNNiRs1/AkVy5q+56NVISl/CVBZc4ksw+BHFwuv+tR63/oWHn23IYIB9AGtbuQlBUX04123mgAWu2US/oQ/vKrFZLv7pMm2WhVx9sSYvDiPP+gmc82eOO+CJFUHz+YxgU719Rpnbxm7gxy182BfBdHPVSoHM8UMrU2T5+FnkC9nwmhU6NdHESiPPK
 xsrLLOxx
 nItPyA1caoZqFjfBkB5gRyPvc3Zsfv/Xi4WsofDi1Dt/i2/GP3KdMhArzwI/L0DF2DIjoTI7oOmWFQqbdTuG2LitLjsd8SYzrIJTbHnjo7QWRkwBld76aGxrRuoEpBU35zqQ9BaOD/NSO17sQk1CRy5xkrDnJWroOjI8/dmFzSvGnWEzZnfTmzkIS0fnpNWG/RKV6E+ltZFTT+p57qxSI0X19pIU892VnXv2fGXREkKb5l9y7gaMzI1Xpsw3PPgakvW6hG196rFc9+alu5Rxjz5h/N7srCqWY/OUn8tiFW4CX+948aAqtiPkSrMn9kZRlmnGKzlZ28axi95pqrtfpbhZwBZGqBQpod8/rHRP8YsovrsrfYAEG28vqrNRI2lbjGpU/FFESLk7jLInmbNsaaTviULJmsSDRiilsE5QKQ7lR1mR4BENY9BcRYfD7KYIbbwK3aMAJ0HOWkIvvksMK8c5fznk1S3xgcr0laaWy4JjIKGMCO7QH5xo/vJzH0WjMqaPRX8tZoO+JR2moS5YKOKUzZUYiR6s37XwTcv0oL3mJy/ycDMq/IGVjJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/5/2026 2:03 AM, Brian Foster wrote:
> On Thu, Sep 03, 2026 at 07:50:18PM +0800, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> truncate_inode_partial_folio() splits a large folio so that the caller's
>> truncate loop can drop the in-range sub-folios while keeping the
>> out-of-range tail. The first split at the punch start edge is
>> non-uniform, which leaves the sub-folio at the truncation end edge as
>> large as possible, this means it may still straddle the range, holding
>> both zeroed in-range and valid out-of-range data. The function then
>> attempts a second split at offset + length to isolate that tail.
>>
>> If the second split fails the straddling sub-folio stays merged. The
>> function returned true unconditionally on all exit paths of the success
>> block, telling the caller it was fully handled. The caller kept its
>> default end and the truncate loop truncated every sub-folio below it,
>> including the merged straddler, discarding the valid out-of-range tail.
>>
>> For example, a 4-page order-2 folio punched from offset 0 to the middle
>> of the last page:
>>
>>    truncate_inode_pages_range()
>>      truncate_inode_partial_folio()      # same_folio == true
>>        1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>        folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>        2nd split of folio2 fails / cannot lock
>>        return true                       # BUG: caller keeps default end
>>      end = 3
>>      loop truncates p0, p1, p2-3        # p3's valid tail is lost
>>
>> This became reachable after commit 7460b470a131 ("mm/truncate: use
>> folio_split() in truncate operation") replaced the atomic split_folio()
>> with folio_split(), whose non-uniform split can partially split a folio
>> and leave the end edge merged.
>>
>> It has gone unnoticed because a dirty large folio normally carries the
>> filesystem's private data, for example buffer_head, so
>> filemap_release_folio() -> iomap_release_folio() returns false on a
>> dirty folio and folio_split() aborts with -EBUSY before any split,
>> leaving the straddler safely unsplit. The bug is only reachable on paths
>> that produce dirty large folios without filesystem private data, and it
>> was caught on the upcoming ext4 iomap buffered I/O path when no ifs is
>> attached.
>>
>> Rework the contract so the caller is told where to stop instead of
>> silently truncating the straddler:
>>
>>    - Return true only when a split occurred, false otherwise. This
>>      clarifies the existing confusing return value semantics.
>>
>>    - Add an optional out-parameter pgoff_t *end, set to the index of the
>>      folio that contains @lend and must be kept by the caller's loop. It
>>      is only written when the folio actually straddles @lend. On the
>>      success path it defaults to the page index of the end edge and is
>>      refined to folio2->index when the second split fails to isolate the
>>      tail.
>>
>>    - Rename the byte-range parameters start/end to lstart/lend to avoid
>>      clashing with the new @end output and to separate byte offsets from
>>      folio indices.
>>
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass &end
>> only when the folio straddles lend. After all, no caller discards a
>> straddling folio anymore, the in-range cleanly-split sub-folios below it
>> are still dropped.
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
>> ---
> 
> Thanks for the patch and description. AFAICT this looks good in terms of
> I think it fixes the issue and generally otherwise preserves existing
> behavior (modulo the thing Joanne is poking at that I haven't grok'd).
> That said...
> 
>>   mm/internal.h |  4 ++--
>>   mm/shmem.c    | 12 +++++------
>>   mm/truncate.c | 57 ++++++++++++++++++++++++++++++---------------------
>>   3 files changed, 41 insertions(+), 32 deletions(-)
>>
> ...
>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..2ebb00f6c379 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -206,15 +206,18 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>>   /*
>>    * Handle partial folios.  The folio may be entirely within the
>>    * range if a split has raced with us.  If not, we zero the part of the
>> - * folio that's within the [start, end] range, and then split the folio if
>> + * folio that's within the [lstart, lend] range, and then split the folio if
>>    * it's large.  split_page_range() will discard pages which now lie beyond
>>    * i_size, and we rely on the caller to discard pages which lie within a
>>    * newly created hole.
>>    *
>> - * Returns false if splitting failed so the caller can avoid
>> - * discarding the entire folio which is stubbornly unsplit.
>> + * When @end non-NULL, set to the index of the folio that contains @lend
>> + * and must be kept by the caller's truncate loop.  Return %true if the
>> + * folio was split, %false otherwise, in which case the folio is dropped or
>> + * may still straddle the range, so the caller must not discard it.
>>    */
>> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>> +				  loff_t lend, pgoff_t *end)
> 
> ... I find the interface kind of confusing and I wonder if we can come
> up with something cleaner. After some time rubber ducking with $LLM,
> what do you think about something where we'd have this function take
> lstart/lend and always return something like pstart/pend page offsets
> (instead of just end)? Those page offsets would essentially refer to the
> indexes for the page range fully covered by lstart/lend, after whatever
> splitting occurred (or didn't).
> 
> So in this particular example of a 4-page folio where we truncate from 0
> to the middle of the last page, pstart would refer to p0 and pend to p3
> in the successful case. This tells the caller that pages p0 thru p2 can
> be punched out.
> 
> If the second split fails as in the commit log example, then you have
> pstart == p0 and pend == p2-3. The caller (truncate_inode_pages_range())
> would reflect this into start/end such that we only punch out p0 thru p1
> in that case.
> 
> I think that means for the case where same_folio == false, the range to
> walk in the caller would be defined by pstart of the first
> partial_folio() call and pend of the second, so that code would have to
> change a little bit. That said, I wonder if that means we could also
> just get rid of the return value and let the pstart/pend values infer
> whether splits occurred or not. I see you've already removed the need
> for the return check in the second partial_folio() call. I haven't run
> through the other users of this function though. Thoughts on something
> like that?
> 
> Brian

Thank you for your suggestion. I think I've roughly understood your
idea, and it does sound promising at first glance.

Yes, I've already removed the tail-side check by using the return
value from pend. Similarly, it seems that we should be able to
eliminate the head-side checks in both truncate_inode_pages_range()
and shmem_undo_range() by leveraging pstart.

But I'm still not entirely sure whether we can completely drop the
return value, as I need to take a closer look at the third call site
of shmem_undo_range(). I haven't fully figured that part out yet, so
I'd like to analyze it more carefully.

Thanks,
Yi.

> 
>>   {
>>   	loff_t pos = folio_pos(folio);
>>   	size_t size = folio_size(folio);
>> @@ -222,19 +225,22 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>   	struct page *split_at, *split_at2;
>>   	unsigned int min_order;
>>   
>> -	if (pos < start)
>> -		offset = start - pos;
>> +	if (end && pos + size > (u64)lend)
>> +		*end = folio->index;
>> +
>> +	if (pos < lstart)
>> +		offset = lstart - pos;
>>   	else
>>   		offset = 0;
>> -	if (pos + size <= (u64)end)
>> +	if (pos + size <= (u64)lend)
>>   		length = size - offset;
>>   	else
>> -		length = end + 1 - pos - offset;
>> +		length = lend + 1 - pos - offset;
>>   
>>   	folio_wait_writeback(folio);
>>   	if (length == size) {
>>   		truncate_inode_folio(folio->mapping, folio);
>> -		return true;
>> +		return false;
>>   	}
>>   
>>   	/*
>> @@ -248,7 +254,7 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>   	if (folio_needs_release(folio))
>>   		folio_invalidate(folio, offset, length);
>>   	if (!folio_test_large(folio))
>> -		return true;
>> +		return false;
>>   
>>   	min_order = mapping_min_folio_order(folio->mapping);
>>   	split_at = folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZE);
>> @@ -259,6 +265,10 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>   		 * for shmem truncate
>>   		 */
>>   		struct folio *folio2;
>> +		bool tail_isolated = true;
>> +
>> +		if (end)
>> +			*end = (pos + offset + length) >> PAGE_SHIFT;
>>   
>>   		if (offset + length == size)
>>   			goto no_split;
>> @@ -273,24 +283,28 @@ bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>>   		if (!folio_test_large(folio2))
>>   			goto out;
>>   
>> -		if (!folio_trylock(folio2))
>> +		if (!folio_trylock(folio2)) {
>> +			tail_isolated = false;
>>   			goto out;
>> +		}
>>   
>>   		/* make sure folio2 is large and does not change its mapping */
>>   		if (folio_test_large(folio2) &&
>> -		    folio2->mapping == folio->mapping)
>> -			folio_split_or_unmap(folio2, split_at2, min_order);
>> +		    folio2->mapping == folio->mapping &&
>> +		    folio_split_or_unmap(folio2, split_at2, min_order))
>> +			tail_isolated = false;
>>   
>>   		folio_unlock(folio2);
>>   out:
>> +		if (!tail_isolated && end)
>> +			*end = folio2->index;
>>   		folio_put(folio2);
>>   no_split:
>>   		return true;
>>   	}
>> -	if (folio_test_dirty(folio))
>> -		return false;
>> -	truncate_inode_folio(folio->mapping, folio);
>> -	return true;
>> +	if (!folio_test_dirty(folio))
>> +		truncate_inode_folio(folio->mapping, folio);
>> +	return false;
>>   }
>>   
>>   /*
>> @@ -413,11 +427,9 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>   	folio = __filemap_get_folio(mapping, lstart >> PAGE_SHIFT, FGP_LOCK, 0);
>>   	if (!IS_ERR(folio)) {
>>   		same_folio = lend < folio_next_pos(folio);
>> -		if (!truncate_inode_partial_folio(folio, lstart, lend)) {
>> +		if (!truncate_inode_partial_folio(folio, lstart, lend,
>> +						  same_folio ? &end : NULL))
>>   			start = folio_next_index(folio);
>> -			if (same_folio)
>> -				end = folio->index;
>> -		}
>>   		folio_unlock(folio);
>>   		folio_put(folio);
>>   		folio = NULL;
>> @@ -427,8 +439,7 @@ void truncate_inode_pages_range(struct address_space *mapping,
>>   		folio = __filemap_get_folio(mapping, lend >> PAGE_SHIFT,
>>   						FGP_LOCK, 0);
>>   		if (!IS_ERR(folio)) {
>> -			if (!truncate_inode_partial_folio(folio, lstart, lend))
>> -				end = folio->index;
>> +			truncate_inode_partial_folio(folio, lstart, lend, &end);
>>   			folio_unlock(folio);
>>   			folio_put(folio);
>>   		}
>> -- 
>> 2.52.0
>>
> 


