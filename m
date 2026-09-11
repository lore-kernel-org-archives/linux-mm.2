Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB802C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65CF6B008A; Fri, 11 Sep 2026 04:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0DAA6B0092; Fri, 11 Sep 2026 04:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6B76B0093; Fri, 11 Sep 2026 04:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6ED806B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:25:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C52914013F
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:25:35 +0000 (UTC)
X-FDA: 85200797430.16.D887522
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 627B840008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:25:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789115132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CJ7M8u1YysS9HAOLVeB1e/R6vTT4QnUO2lXXhRbucu4=;
	b=HR1WWQ8d+KsA3fFZxQqqshvgzmHCFIkBSnoVpL4Xk96NJRFNbqWKScW6ArRQb/CxXfJlTc
	TI7I+WRTU8OCJbT8IYRvsN8XBGHytT4PXdH5i/Q4I88U8OAHFzJOVzi3prJHt0lhPK3Ksa
	Kk30JdWYm3gBT5BsD0Y6IHMMEl46+So=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789115132;
	b=FrQAhMOqL1gBYChhXUqWUffDc7CyNQooQWwh6l13o6SPJ90S+cAz2bYIgaxu9bhj0+ILkd
	9uouGvnMZwbb0dKg/65BNe1TT8vqZt1FJKK+USe35u0Jc7apda8BKiNY2umSOhepbPhDJm
	0qBs6UYQ2x5Z7L8TFtD9W6F8hwGzhU0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hh6zv0TwwzKHMPy
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:25:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 00C4C4056B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:25:20 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP1 (Coremail) with UTF8SMTPSA id cCh0CgDH_AfuuqNqJOk2Bg--.2181S3;
	Fri, 11 Sep 2026 16:25:20 +0800 (CST)
Message-ID: <aa0f94c8-b959-4aec-b8f5-69365d1a02fa@huaweicloud.com>
Date: Fri, 11 Sep 2026 16:25:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/truncate: fix data loss when truncating straddling
 large folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, hughd@google.com, baolin.wang@linux.alibaba.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com, bfoster@redhat.com,
 djwong@kernel.org, yi.zhang@huawei.com, yizhang089@gmail.com,
 yangerkun@huawei.com, chengzhihao1@huawei.com, wangkefeng.wang@huawei.com,
 yukuai@fnnas.com
References: <20260909062339.473816-1-yi.zhang@huaweicloud.com>
 <CAJnrk1b8fWpp-yBRxFaBbFzA8852N53SB6j3Zi9Qnp+JBFuNbA@mail.gmail.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <CAJnrk1b8fWpp-yBRxFaBbFzA8852N53SB6j3Zi9Qnp+JBFuNbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDH_AfuuqNqJOk2Bg--.2181S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFy8tF1DXF47KF18AFWUurg_yoWxKr4fpr
	W2ga9Iyrs7G392krn2va1DXw1rJ3yfXr4UAF93J3s2kan0vr12kF1Utw1rCFWUGr97G3W0
	v3WjvanrW3WDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7
	CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
	rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kK
	e7AKxVW8ZVWrXwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c
	02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_
	WrylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jxCztUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tst6b6omz9tqsiqarqz96mqdzmganqsd
X-Rspamd-Queue-Id: 627B840008
X-HE-Tag: 1789115130-267696
X-HE-Meta: U2FsdGVkX18VNr6FsWb4Xc1yVtkslRBN93m9rxXkLxM9UdWe3ba/xvxZ7GsChDrlSyFkuFGzidSOMspvyGyJMdfAJLai29acUvh382lvIc9ZH8OLGkRO0bNOq2docWsGI+zo+x6aoaUqr1b9rrcTb0HSVpz//KX2lR/Y993sIX2eiAQXVGtGERXkxwaJfBybP9Fate2hZsQ7m6NCQNniNuo6ECGaGjgivfiN7waxyTAK71lt3U1cV/G3AIuyIIS2IovKlDPIAzplRtIEEY4aHKdep77osIbaMKI7YExzyiI8vGrNXE+pGz6XIV5MkQrcq5gGKsPGgC8x+U24N1UOQ5pU0q7tt8KfZCH02UQxZzTOeYlui2ylitIpiTZyvHLER4HbJmPRR2A5iftUw19AXK3bVjfh+GeXkhuHj8jkbdaS7ZVQH274lZdTZfxGqmyofdbY+1jb6xgs/eaY+5j0QuBq8RwD8ZfsJAIAxlAWGzxKiOrhRxMOkdhbrOUb6TS7kkOX5ET0uc3c62HL7PuAcb3VHwGj6+Xoc98ivTN6WLzkk94en982adgZvlq1aRY9aWmG5JCSM4d2QLnEZPqb26vSlkt4rxtFhp58lVl8vzoZZ4jILLIhvb+xuIun12T+ByEC0Ga+iofuuLI3GEopY2TAbRdowL2QgzuHjzDCzJDq/CATmgtGBF59ZQcWsI0pBrC781S5rLgKObqZ0Q0tz2qmNhQBeHvQLV0L7zPvx+DJ7t1lBCzUqn4uxxFP7XMilYJv38+PfIQxcdS3QbmWNcvC0UPzuge4QkdkOiFHndMeENU6QAyPVVhkufw71nK4j//Xcxohj4/nMrBgf1tU6XkY6dDyZ9EO8NifH+Y0TS0xk775sOtW3V1S6fEVLJJV1R8RdUV9sEjkgnFHTdvgf6tG0SiqB79/WEPrp1sRGlJHSFJCI9uAvVpZ6CFMeuEYDse4Uzj4OOhngEmzHSb
 FehjpYNr
 RZ1FT/JcDHeyYiiNbz/+OS49fZ+Sfp/SWttv5+nTMO4h6QokjfL2pJoC6g6c4Fr5hZi8CHo1ZCH7JJvPQle0aYDbL7BElWQs5dX75dWNFfefBbFbZOla/t6+qrUBwBTsrjlQFqT+/Qt7J9lqI8mBtpWSXH+ihZ8/NMO9mq8C2+QCoggDOgOsgpGlM2zTDWdBoZ3Xb/UvdEZkq3j8i568owGTZw7GRatqSo9OB5+u2QPUB6Go3mKAGwPJOqkwBD2Kmbw+DoYiOuztPjec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/2026 2:29 AM, Joanne Koong wrote:
> On Tue, Sep 8, 2026 at 11:31 PM Zhang Yi <yi.zhang@huaweicloud.com> wrote:
>>
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
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()      # same_folio == true
>>       1st split at page0 -> [p0, p1, p2-3]   # non-uniform, success
>>       folio2 = p2-3 # straddles: p2 zeroed, p3 tail valid
>>       2nd split of folio2 fails / cannot lock
>>       return true                       # BUG: caller keeps default end
>>     end = 3
>>     loop truncates p0, p1, p2-3        # p3's valid tail is lost
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
>> In addition, even when both splits succeed, data can still be lost when
>> the mapping's minimum folio order (min_order) is non-zero. folio_split()
>> stops at min_order instead of order 0, so the sub-folio containing a
>> split point stays aligned to 1 << min_order rather than to a page. The
>> original success path left start at the page-aligned head of the range
>> and set end to the exact page index of the end edge, neither of which is
>> a folio boundary in general. Either one could land inside the large
>> folio at its edge, and the truncate loop would drop that straddling
>> folio together with its valid out-of-range tail.
>>
>> For example, a 64K (order-4) folio with min_order = 2 punched from
>> offset 0 to 36K:
>>
>>   truncate_inode_pages_range()
>>     truncate_inode_partial_folio()        # same_folio == true
>>       1st split at p0 -> [p0-p3, p4-p7, p8-p15]  # non-uniform, min_order
>>       folio2 = p8-p15 # straddles: p8 in range, p9-p15 tail valid
>>       2nd split of folio2 -> [p8-p11, p12-p15]   # success
>>       end = p9                           # BUG: p9 inside [p8-p11]
>>     loop truncates ... p8-p11           # p9-p11's valid tail is lost
>>
>> Rework the contract so the caller is told the page range to discard:
>>
>>   - Return true only when a split occurred, false otherwise. This
>>     clarifies the existing confusing return value semantics.
>>
>>   - Add pgoff_t *pstart and *pend out-parameters that receive the page
>>     range fully covered by [lstart, lend] after any split (or none),
>>     i.e. the pages wholly within the range and safe to discard. They are
>>     aligned up (pstart) and down (pend) to the mapping's minimum folio
>>     order so they always fall on a folio boundary.
>>
>>   - Rename the byte-range parameters start/end to lstart/lend to avoid
>>     clashing with the new outputs and to separate byte offsets from
>>     folio indices.
>>
>> Callers in truncate_inode_pages_range() and shmem_undo_range() pass
>> &pstart for the folio at the start edge and &pend for the folio at the
>> end edge, so the truncate loop drops exactly the fully covered pages and
>> never touches a straddling folio that still holds valid out-of-range
>> data.
>>
>> Suggested-by: Brian Foster <bfoster@redhat.com>
>> Link: https://lore.kernel.org/linux-fsdevel/anH-WKA1coW6wtfG@bfoster/
>> Fixes: 7460b470a131 ("mm/truncate: use folio_split() in truncate operation")
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
> 
>> ---
>> v1->v2:
>>  - Export pstart as a new parameter so that the generic and shmem
>>    truncate paths don't need to recompute the start value from the
>>    return value. (Brian)
>>  - When min_order is nonzero, align [pstart, pend] to the inner
>>    boundaries of the folio to ensure they do not point into the middle
>>    of a large folio, which could otherwise cause valid data within the
>>    folio to be incorrectly cleared. (Joanne)
>>
>> v1: https://lore.kernel.org/linux-mm/20260903115018.2034541-1-yi.zhang@huaweicloud.com/
>>
>>  mm/internal.h |  4 +--
>>  mm/shmem.c    | 13 +++-----
>>  mm/truncate.c | 88 +++++++++++++++++++++++++++++++++++----------------
>>  3 files changed, 67 insertions(+), 38 deletions(-)
>>

[...]

>> diff --git a/mm/truncate.c b/mm/truncate.c
>> index b58ba940be47..d88a1b159084 100644
>> --- a/mm/truncate.c
>> +++ b/mm/truncate.c
>> @@ -206,35 +206,41 @@ static int folio_split_or_unmap(struct folio *folio, struct page *split_at,
>>  /*
>>   * Handle partial folios.  The folio may be entirely within the
>>   * range if a split has raced with us.  If not, we zero the part of the
>> - * folio that's within the [start, end] range, and then split the folio if
>> + * folio that's within the [lstart, lend] range, and then split the folio if
>>   * it's large.  split_page_range() will discard pages which now lie beyond
>>   * i_size, and we rely on the caller to discard pages which lie within a
>>   * newly created hole.
>>   *
>> - * Returns false if splitting failed so the caller can avoid
>> - * discarding the entire folio which is stubbornly unsplit.
>> + * When @pstart and/or @pend are non-NULL they receive the indexes of the
>> + * page range fully covered by [lstart, lend] after any split (or none),
>> + * i.e. the range of pages that are wholly within [lstart, lend] and so safe
>> + * to discard.
> 
> I think with themin_order > 0 case, pages wholly within [lstart, lend]
> can still be excluded, so maybe worth editing this to reflect that.
> 
> Thanks,
> Joanne

Good point, I will fix this in next iteration.

Thanks,
Yi.

> 
>> + *
>> + * Return %true if the folio was split, %false otherwise.
>>   */
>> -bool truncate_inode_partial_folio(struct folio *folio, loff_t start, loff_t end)
>> +bool truncate_inode_partial_folio(struct folio *folio, loff_t lstart,
>> +                                 loff_t lend, pgoff_t *pstart, pgoff_t *pend)
>>  {
>>         loff_t pos = folio_pos(folio);
>>         size_t size = folio_size(folio);


