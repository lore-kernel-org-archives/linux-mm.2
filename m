Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83516109E52B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 01:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5B696B0005; Wed, 25 Mar 2026 21:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C376B0088; Wed, 25 Mar 2026 21:57:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22BA6B0089; Wed, 25 Mar 2026 21:57:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C07626B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:57:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 423FAE0F17
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:57:26 +0000 (UTC)
X-FDA: 84586552092.05.EE1119D
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf27.hostedemail.com (Postfix) with ESMTP id BC0934000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:57:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hfhQA9kP;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774490244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4P3HZeFpAYcP9fuDTLYiiV3smE1BlqrAdg4KKIFqogo=;
	b=WyZkQtQ1p1aH6KZxQVO//sX01FgulyDzWzy0NHhvncRQvnnDNDhTPsUDee/U8POe6zGfNl
	80iA34MuDjDUjwFpjIvsnhkVQ7t12ahmWSIJFRVOu6JyUMaeUqsTPDrOPCDGQWvjFwxf5j
	IIiMErdK9RrIYhsVi+iTazIZJRGfzLM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hfhQA9kP;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774490244; a=rsa-sha256;
	cv=none;
	b=zeTHYx8DYgvC9eBj1PBATCQ3TJuwD1q4rWKDEBAw4wjDYY5Teq3vnwTa44fZbh7MOWY1i3
	d/2N8MBRwC+7LGgEoZsL83MUOS6i8NBd9PhJvEzZCegvblwbAeMPk1Ypq4xgGbWtnynvXp
	joaSMPg1WhvcupLGlaMi4tA4WeYIim0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774490241; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=4P3HZeFpAYcP9fuDTLYiiV3smE1BlqrAdg4KKIFqogo=;
	b=hfhQA9kPs5g/qY9GwftzRrTVa3H2UEHKjG3MG2+KKdu8d0qFQ9j+Y7GEep+JHD7hiv98KpO89pfNjlYOXsXmr+yksMtoCssS07gYwVk2VdDlfF/jKUFdFp9M2QYQawo2ckyQgR8lReLyS4y9ezl9RVlYfwuaznu7LI/0el3K2k4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X.jkM2T_1774490239;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.jkM2T_1774490239 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 09:57:19 +0800
Message-ID: <035e7e83-1811-4f8d-b8ed-0f5025e66399@linux.alibaba.com>
Date: Thu, 26 Mar 2026 09:57:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm: vmscan: fix dirty folios throttling on cgroup v1
 for MGLRU
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 baohua@kernel.org, kasong@tencent.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <bf40a20cd93b6c21f10db95657928fdae185e843.1774438978.git.baolin.wang@linux.alibaba.com>
 <acPOn07xah2eh0WU@KASONG-MC4>
 <f3d680da-7480-4d05-ac44-e669e0914a32@linux.alibaba.com>
 <acPkASQIcn4VHHjs@KASONG-MC4>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <acPkASQIcn4VHHjs@KASONG-MC4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: qgjjktysfne3acs5mw9kjik3tor6dyuh
X-Rspamd-Queue-Id: BC0934000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1774490243-810237
X-HE-Meta: U2FsdGVkX1+ttlo6Ecpyt4fJU6Im7LVPDozr1kFU6XUo+2Na9MYYabTcCzEcMmLrf9LhFB2VwNYTlSPJvZFSacNYOtWoFpKmrqBKttz/sO4NA49jj3zIN/viBe+J7TLlZ2mqghL33ChVxNAfdLbNiyYM3KFYGugudmvfuBjS5lDAa75KseKElpvmIhSH51jFWjz1r8Kmbyg1gADLyWpnRK5mYxIuy0VW0g6Q0QVueICU607Dpf8R4jw2gzh04QOYUAyFWDXRSsPaTSPGZK9ORl3ii/b1oYA+tU8UhBF2wJ8IBu7cw1CfgUExe6s19gOx1i/Gvkz+ZPeQIj38T9I/sjlr6+9V192EZhnCrH8EDAV7EuvTvvX+4+0O19RTAAlCSbWUJORUVx8VziYT/+WZbr2BSDtw0RLY/T/C1eDTZFSU/RfuKre82Vp93wm7N5QctpmzSo5iQzWzMkVRFEgccLn+2RaCvtaUJVklXbsbgCyaR8GhZLuODXgXKMFbtJJG8cf6R+nZ7NGeo6WHWTT8kMcOdFSiLTI6uav4/d+RYvMwqqKJX83P3Kb8j9ERq+PGOFd91TTr6+ECPLq0ukzGUhSSLo+AE/ku0f9V4bRpMa37k/6zfkwUlaCFRTwU85ojEIC2nhNRo2PVQUwdcPqBjA7oY1y5EQigi/tIbm8OCQjdykQ0QwThYxL5OLezPQf6pN0m0VyWTic/H2buuWBZOX5SyGsQZkQ7xLUvp7mLt4s22bLlJswn9kNQXxU32fFdmKmNoefvp6UMcRPXxm221j5XtZ3iJWGiHo9Ji6HhaJWym0AIWVYILIKRfnMsIOymHWOlydWGwNJTbhJw+G9A/2hhvIfpxBp+ZLqJz2UGq9X5tYxoNsLpGb28Aw0Q3GA9oTPnYAGtQdlrWI5vgi9tf+rh5EWhn6Rm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 9:35 PM, Kairui Song wrote:
> On Wed, Mar 25, 2026 at 09:20:55PM +0800, Baolin Wang wrote:
>> Hi Kairui,
>>
>> On 3/25/26 8:07 PM, Kairui Song wrote:
>>> On Wed, Mar 25, 2026 at 07:50:40PM +0800, Baolin Wang wrote:
>>>> The balance_dirty_pages() won't do the dirty folios throttling on cgroupv1.
>>>> See commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback
>>>> on traditional hierarchies").
>>>>
>>>> Moreover, after commit 6b0dfabb3555 ("fs: Remove aops->writepage"), we no
>>>> longer attempt to write back filesystem folios through reclaim.
>>>>
>>>> On large memory systems, the flusher may not be able to write back quickly
>>>> enough. Consequently, MGLRU will encounter many folios that are already
>>>> under writeback. Since we cannot reclaim these dirty folios, the system
>>>> may run out of memory and trigger the OOM killer.
>>>>
>>>> Hence, for cgroup v1, let's throttle reclaim after waking up the flusher,
>>>> which is similar to commit 81a70c21d917 ("mm/cgroup/reclaim: fix dirty
>>>> pages throttling on cgroup v1"), to avoid unnecessary OOM.
>>>>
>>>> The following test program can easily reproduce the OOM issue. With this patch
>>>> applied, the test passes successfully.
>>>>
>>>> $mkdir /sys/fs/cgroup/memory/test
>>>> $echo 256M > /sys/fs/cgroup/memory/test/memory.limit_in_bytes
>>>> $echo $$ > /sys/fs/cgroup/memory/test/cgroup.procs
>>>> $dd if=/dev/zero of=/mnt/data.bin bs=1M count=800
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    mm/vmscan.c | 13 ++++++++++++-
>>>>    1 file changed, 12 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index 33287ba4a500..a9648269fae8 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -5036,9 +5036,20 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>>>>    	 * If too many file cache in the coldest generation can't be evicted
>>>>    	 * due to being dirty, wake up the flusher.
>>>>    	 */
>>>> -	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken)
>>>> +	if (sc->nr.unqueued_dirty && sc->nr.unqueued_dirty == sc->nr.file_taken) {
>>>> +		struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>>>> +
>>>>    		wakeup_flusher_threads(WB_REASON_VMSCAN);
>>>> +		/*
>>>> +		 * For cgroupv1 dirty throttling is achieved by waking up
>>>> +		 * the kernel flusher here and later waiting on folios
>>>> +		 * which are in writeback to finish (see shrink_folio_list()).
>>>> +		 */
>>>> +		if (!writeback_throttling_sane(sc))
>>>> +			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
>>>> +	}
>>>> +
>>>>    	/* whether this lruvec should be rotated */
>>>>    	return nr_to_scan < 0;
>>>>    }
>>>
>>> Hi Baolin
>>>
>>> Interesting I want to fix this too, after or with:
>>> https://lore.kernel.org/linux-mm/20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com/
>>
>> Thanks for taking a look.
>>
>>>
>>> With current fix you posted, MGLRU's dirty throttling is still
>>> a bit different from active / inactive LRU. In fact MGLRU
>>> treat dirty folios quite differently causing many other issues too,
>>> e.g. it's much more likely for dirty folios to stuck at the tail
>>> for MGLRU so simply apply the throttling could cause too
>>> aggressive throttling. Or batch is too large to trigger the
>>> throttling.
>>
>> Thanks for sharing this.
> 
> Hi Baolin,
> 
>>
>>> So I'm planning to add below patch to V2 of that series (also this
>>> is suggested by Ridong), how do you think? There are several
>>> other throttling things to be fixed too, more than just the
>>> V1 support. I can have your suggested-by too.
>>
>> But I still think this fix deserves its own commit, because this is indeed
>> fixing a real issue that I ran into. Even if the throttling isn't perfect
>> for cgroup v1, it aligns with the legacy-LRU behavior and is essential to
>> avoid premature OOMs firstly. MGLRU dirty folio handling improvement can be
>> done as a separate optimization in your series.
>>
>> Anyway, let's also wait for more feedback from others.
>>
> 
> Sure, fixing this first is fine to me, just saying that you may
> still see unexpected throttling or ineffective throttling with this.
> 
> This is no conflict between these two approach. I can rebase that
> series on top of yours, and that series would help to solve the
> rest of issues.

OK. Thanks.

