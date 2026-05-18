Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1152ACD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 03:47:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F9B86B0005; Sun, 17 May 2026 23:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AA426B0088; Sun, 17 May 2026 23:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C07F6B008C; Sun, 17 May 2026 23:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F06D56B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 23:47:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 77FF71C0663
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:47:31 +0000 (UTC)
X-FDA: 84779155902.21.2921B49
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3206D40002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:47:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ADPEeTfz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779076049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LArLuNT+BWoNrJD5E+Yb48PCjOyDuacxiq6rje5254I=;
	b=QH8gem23jzKKZ1x1Pz0zPLhugP3ExrepkUt9RNFN14hfvf3Qf4wR0FMp0mdEJ0tFV3Ar51
	RzdEK6OICKHeJSEXGfOECEWSUCS6XbDRLcUT2VDWApDfdjNCu3MipBP8PtXT2yDHTyclMS
	RatfzRRWmhTj2QDT5fKfs3OuVLVy2l8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779076049; a=rsa-sha256;
	cv=none;
	b=Rs1kDVvGH8CT4ihO0nlo8GK/AUqnExC1+a+OeVdEFIntBT/x2cQcDLU2Ys5dTYG7OOqsr8
	Er0PHwI0Of9IfAReohjlGCT4ylN66v008m8P4i6KKBezpnbMKcvCOGKVUjrlg2SGlPmeJc
	HiPd2qvfWuVfB0MHtyLWJ0E/9T4jH2M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ADPEeTfz;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779076044; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=LArLuNT+BWoNrJD5E+Yb48PCjOyDuacxiq6rje5254I=;
	b=ADPEeTfzCnLDmGmlzAWeoY8uekqMjiT65xgRhR9YUfjwArIbZEDQrc8w2B24pE4xPnG0knFB1Nb1ox068cVwYQm+WDojpXxKjNFQWK/zRO5DPwSvLbg4wqyEjOW2nD/45oMRoPNcNr4loVDbddlGhU6fOu2FqCTZRSrpmGZxVt8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X334e2b_1779076041;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X334e2b_1779076041 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 18 May 2026 11:47:22 +0800
Message-ID: <6591a74c-7ef9-4614-9ae9-cb2fbed86ebf@linux.alibaba.com>
Date: Mon, 18 May 2026 11:47:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (sashiko review) Re: [PATCH v4 6/9] mm: shmem: drop
 has_transparent_hugepage() usage
To: Lance Yang <lance.yang@linux.dev>, luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 ziy@nvidia.com, corbet@lwn.net, tsbogend@alpha.franken.de,
 maddy@linux.ibm.com, mpe@ellerman.id.au, agordeev@linux.ibm.com,
 gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
 x86@kernel.org, dave.hansen@linux.intel.com, djbw@kernel.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <ed33dc0f-fcde-42b3-90aa-c20290b06f49@redhat.com>
 <20260517133239.26416-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260517133239.26416-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3206D40002
X-Stat-Signature: x64h5cq7desgi4jot7ujjwndn199n19c
X-Rspam-User: 
X-HE-Tag: 1779076047-358903
X-HE-Meta: U2FsdGVkX19//rhHmXI0SuXzF6VedhsWcus+pwsxn5KFeH+BgEs9BNckzMhdJTDBnqBAoa8jbNhRu3dpKxnqDS/aTnee47nqm74oB+OqboUaUdJHcKzZJ4qGJQ1L6K9g2lUtD4deYVyffDQtPSjKgGsDkUOHFMi6xN6UWVSR6Yy1+r/cWVVgeJRMiwa0uW41W9bRIsqjMfNzEjqFXOU7YppBCEb13GPYpTTWOHpedryZ5/LP6yBZRZN7AsU1/EtSoizwE25ztfAX0rMMyqcwg6/aiZH+UfXx8UcI9KvprLWeWyFbpE45Vw58zQRnlFTgF869l2f4HTROH6AvJAOoML9q/bX6Rasxa9HYVX9zeaZDkB0UI3ePC1EA+4tqJs9n0xoOWcalAg4kdJZkWR7TgnIMVBVAVyxCHZ9ypnBHbZ79Qp6k0xuypSAXRJAQvo4pYZfdNN59EtAG7twZJk7vQgLcN8Q55CNbun/ASW6Jnh53KtE5b8quWkyLoCqfNpY9J9MVV3Hg5JTl7yUFU0gINgKR4VHFRX6t9NT3QB5Oz0Tl5N5t1dV3+VQqOCWATuXXfetpyqQxnL2A4kqXI3t5ZpEIOhxnYMLFyIebZARvykMBKwuhEF3jQZLTQX+51vcvbjGw55fK3POs2fORcD6wHr9dbG5QGIFD02Fgx+1M8lM3f3Dl0l+l5E2tyYk+IZhhygb0WMpP5oTrDG4RUo5lv8PtCMePwTX9aX/nOCN48ls4mhh1YLatw3MifzJdNmyYXFkOYTB8kBMMfpRuXA5C1eYbG9ULUudrjP+D94rRT5lkxoQr0gmsAlvSQuDmubWtYhdBxvXei1wVKHxcdH1gaEwn1aQuTymdSWogH1PvYaHl8IyfVV23jGA9CjaTuDrPqCprUHln9hmeswiEwwQJOKrwQg1B3Cpoi38yDkGY7S+HXk/3h/A2YZnp2M655Jaiu9x1k7NcbBXfwO1xsL1
 TKHvL4+D
 lJeCV6RDWymOj6n0taT8XDiYuolcyObExuPuvUxAPyZdlB2aAeWFp1AOlfJ20oDKdZXWiDn0ZL6ys1NNeQSKaScCCK1fEm6n+HvPm4t7XBYRxHgFCYVb2EQjquEwzbfuVsGRsR6Xvmd1rBWzp+iItzKuMeBPH2NFjm4IJe2KOLbawV4LYDT/mYB5+kTlP1Eilu76yaLyJ1+SKdEypAJSPWH7t3TltTWOy2ddxWwtDzvDWAA3nYiLdBKIUIGOAPhgBPWN2xxHFkJ6cb5+9AJbCZs71QOvuzOfaeQT5GFcsZeptyHZrHO7sOpUlFzZRLNGRS6ekB9bkZLKjZCCg608azWc0FQqYJBYoxDq+LNrmg2RxEuhT9Gyv1Mmf1ew5MoFwmPdxgab8ZYOioAglj3oC+doQ+HoU7tHddtn6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/17/26 9:32 PM, Lance Yang wrote:
> 
> On Wed, May 06, 2026 at 02:12:41PM -0400, Luiz Capitulino wrote:
>> On 2026-05-01 15:18, Luiz Capitulino wrote:
>>> Shmem uses has_transparent_hugepage() in the following ways:
>>>
>>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>>     if the CPU supports PMD-sized pages
>>>
>>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>>     the code block calling has_transparent_hugepage(), the
>>>     has_transparent_hugepage() call is exclusively checking if the CPU
>>>     supports PMD-sized pages
>>>
>>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>>> in all cases, shmem can determine mTHP size support at folio allocation
>>> time. Therefore, drop has_transparent_hugepage() usage while keeping the
>>> CONFIG_TRANSPARENT_HUGEPAGE checks.
>>>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> Acked-by: Zi Yan <ziy@nvidia.com>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>    mm/shmem.c | 7 +++----
>>>    1 file changed, 3 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index 3b5dc21b323c..1948d73fb1e3 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>>>    	else
>>>    		return -EINVAL;
>>>    
>>> -	if (!has_transparent_hugepage() &&
>>> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>    	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>    		return -EINVAL;
>>>    
>>> @@ -4656,8 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>>>    	case Opt_huge:
>>>    		ctx->huge = result.uint_32;
>>>    		if (ctx->huge != SHMEM_HUGE_NEVER &&
>>> -		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>> -		      has_transparent_hugepage()))
>>> +		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>>>    			goto unsupported_parameter;
>>>    		ctx->seen |= SHMEM_SEEN_HUGE;
>>>    		break;
>>
>> """
>> By dropping the has_transparent_hugepage() check, will mount -t tmpfs
>> -o huge=always now succeed on hardware lacking PMD support?
>>
>> If so, since hugepage_init() still sets the TRANSPARENT_HUGEPAGE_UNSUPPORTED
>> flag, thp_disabled_by_hw() will unconditionally block all large folio
>> allocations in shmem_allowable_huge_orders().
>>
>> Does this create an intermediate state where the mount silently succeeds
>> but no huge pages of any size can actually be allocated?
>>
>> I see this is resolved later in the series by commit cd27430097e8
>> ("mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()") and
>> commit 641a20ae032f ("mm: thp: always enable mTHP support").
>> """
>>
>> The mount -t tmpfs -o huge=always succeeding on hardware without PMD
>> support can happen in this patch, yes. But this seems very minor, the
>> impact seems to be someone doing bisection, landing on this patch and
>> their reproducer is depedent on mounting tmpfs with -o huge=always on
>> hardware without PMD size support? I can fix it if others feel strong
>> about this.
>>
>>> @@ -5449,7 +5448,7 @@ void __init shmem_init(void)
>>>    #endif
>>>    
>>>    #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>> -	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>>> +	if (shmem_huge > SHMEM_HUGE_DENY)
>>>    		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>>>    	else
>>>    		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>>
>> """
>> Also, by allowing shmem_huge to be set to SHMEM_HUGE_ALWAYS on systems
>> without PMD support, does this incorrectly affect shmem_getattr()?
>>
>> shmem_getattr() relies on shmem_huge_global_enabled(), which only checks
>> the software configuration and not hardware PMD support. Consequently,
>> shmem_getattr() will erroneously report stat->blksize = HPAGE_PMD_SIZE
>> to userspace.
>>
>> Since subsequent patches in the series do not appear to update
>> shmem_getattr(), could this misleading block size cause userspace tools
>> to over-allocate IO buffers on hardware where PMD-sized pages are
>> structurally impossible?
>> """
>>
>> This a real issue (albeit small one), the problem is this check in
>> shmem_getattr():
>>
>> 	if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
>> 		stat->blksize = HPAGE_PMD_SIZE;
>>
>> So, we may report HPAGE_PMD_SIZE even when PMD size is not supported.
>> Looks like we may over-report today as well for the
>> SHMEM_HUGE_WITHIN_SIZE case? In any case, I'll fix this.
> 
> Well spotted.
> 
> @Baolin looks like shmem_getattr() might already be buggy?
> 
> shmem_huge_global_enabled() returns an order mask. For huge=always and
> huge=within_size it can return THP_ORDERS_ALL_FILE_DEFAULT, which is not
> PMD-only and can include smaller file mTHP orders as well ...
> 
> So shmem_getattr() treating any non-zero mask as HPAGE_PMD_SIZE looks
> like an over-report?

Normally, it looks fine because we always start trying from PMD-sized 
large order if tmpfs supports large order (see commit 69e0a3b49003 ("mm: 
shmem: fix the strategy for the tmpfs 'huge=' options")).

And the code here works for 'force' or 'always', but not so much for 
'within_size' or 'advise', as Hugh mentioned before[1].

Especially in 'within_size' mode, after we allow fallback to smaller 
large orders, the logic becomes unreasonable. Although I'm not sure if 
there's any benefit after the modification, it would make the logic 
clearer, for example:

diff --git a/mm/shmem.c b/mm/shmem.c
index 106e4de943fb..e9f43aefdc7d 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1297,8 +1297,14 @@ static int shmem_getattr(struct mnt_idmap *idmap,
                         STATX_ATTR_NODUMP);
         generic_fillattr(idmap, request_mask, inode, stat);

-       if (shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0))
-               stat->blksize = HPAGE_PMD_SIZE;
+       orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
+       if (!pgtable_has_pmd_leaves())
+               orders &= ~BIT(PMD_ORDER);
+       if (orders) {
+               unsigned int hi_order = highest_order(orders);
+
+               stat->blksize = PAGE_SIZE << hi_order;
+       }

         if (request_mask & STATX_BTIME) {
                 stat->result_mask |= STATX_BTIME;

[1] 
https://lore.kernel.org/all/1524665633-83806-1-git-send-email-yang.shi@linux.alibaba.com/T/#m21037b23be70fb9f7ab1965bb8b39242752594d1

