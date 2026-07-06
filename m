Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 878C1C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 12:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A15E6B00C8; Mon,  6 Jul 2026 08:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678686B00C9; Mon,  6 Jul 2026 08:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58EF16B00CA; Mon,  6 Jul 2026 08:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29E516B00C8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:08:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3A878DBF1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:08:45 +0000 (UTC)
X-FDA: 84958230210.24.E74905A
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4B43E140009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 12:08:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Gdoe5j5t;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783339724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZddxHRGgxDKnCx0072/zTHmK6GyWnLW8ka8kUBFC/I=;
	b=QQ6LLE765ulMD5lNTfKoF+do9tGAKwF5eb7u6IB/60jbPdjawz/eh+AMCvLcG0QITr/l3/
	3rf1wmvQt4az4MEgxzFHEEDuvmMS81UYSP8g98ZUlubYBa29iOIZ7bqpxuvUqLCVwUXtmP
	r6HbhVQzEw0NJO5kTXWrVHuNFdlp6cE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Gdoe5j5t;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783339724;
	b=dftpBslsgj1E4gARQ9udZ/5RJXkixriIRYwxwO303VmSFzSyhgBLAZ7F1ulrGes547jeve
	zrlchWmHdkHXn8fWVX8Ye4EF0J39Xnx7qCPTadOfkwg6IWFmXKxmA3phmB6KVZFPjJNsOv
	4i0plWpaghxd0KsnimHJC/2xWQf18Ng=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783339717; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xZddxHRGgxDKnCx0072/zTHmK6GyWnLW8ka8kUBFC/I=;
	b=Gdoe5j5t+m8cSozIbugHPlSUQi2UagikqKdGSwcLCd/agJVE+EICm6dEUeSc4hGb1otRm4lupNNVE2UF0R5gQwhUODlGebA9G5D7pF0LDxdsf5B7lGWUDWUp2UbqSazJi2QoB2p9J4RiKaeooyydkIQ73UbIrAv1ivKaJnYNmSw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0X6VYQxf_1783339715;
Received: from 30.246.179.165(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6VYQxf_1783339715 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 20:08:36 +0800
Message-ID: <8ef0b72e-a0e8-4913-8d30-519335305260@linux.alibaba.com>
Date: Mon, 6 Jul 2026 20:08:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem
 direct swapin
To: Kairui Song <ryncsn@gmail.com>
Cc: akpm@linux-foundation.org, hughd@google.com, stable@vger.kernel.org,
 baohua@kernel.org, machao26@xiaomi.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kknobx3xjhyaszkfj7jak79a4nxtdp86
X-Rspamd-Queue-Id: 4B43E140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783339719-544115
X-HE-Meta: U2FsdGVkX1/Ue/A4KwbG+OVbFpRFRRB8SSYFkVt8Mz2o1DQKeKhrcNU7/nHYs71D9t8LNCAPVOk1lBX6dKV0C3UFLUIN7adfcraGOMu2g5K5B9G8p9aRN89Mu3SCtuF6wvGmAShuciAAV2cst3Dsxb0Sd/is8tY+pUm93FhNgqTNbRkgPQNDP15X0B9Tvqk/CdOiFGm7DszIlmUvB7qF1dE2I7lEiAWn6wVvBxWvQx0yGNEGQj4tCZdXSej2dzuhWBTUBUxQpOgAVCYSr4M5l8DDOqOrDAlltw71VgbVaWkBheocITgUPB7+wHv5YrN/Z8McJiQ9uMgMdicSXls23w3vNmcfzsvTV47w5wyTkQ61lH4FgSxMlwtL04gzvyvJyS9oEYeHq2qIIyRJvj9YUomEv4eBJUIZynugm1RXI7LTCI/5sZ5RrCQAvO/3Ia1w6LrK9VqDwHPil9i465cDAVUZq22RsuthZJVb2cBdSSRl+8WlReQpHXadIFV6I2kUWcTl2ngXd29aRC40NU0nPHSeWrhtbh0NmLQdatzOvPR6boIsBDe6XWb7s3WquiiAPiATdT1TZ29SA36bNZ7wia0U1hkwHGDDlknduYQNghYvBr1iyMBuBX+4bNz0Url4xcRlGxwIXGCGod6qyy+cyFJ7BV74c3Itr1o468p92UNCkkeJVYhHSTq8dDKlqSAkuFFDM+RjghAwan4av+CDps5qmMtMmiyOYXjX+3UOxPCe8ExAOXnGx/G/QLBGh4Xcl1qh73711SAHGbMv2c5rc1Rga83nx51cokAhLISRHISgEJewvowwD4Aa68fwaEuuiUARwOVRT4DsmR6MA0XCdH/0FiI1gGwHNu+eBfp+61ai1wXh/8el0JFuOOLdYKzt1vRTgGWwX2EgRhOFyaDZejWpvJGVQjyq6srx1k1nQSN8N2TOro+HaOJSQ9yKcyCu0/F66tzIGuIiM7Q6QgQ
 xxMGFKSu
 Zijx7kuLwOB7H+4rnZYfzXevfhi14D+BrkSuOAXZf30CMoct+/o8KVuq1+qI9Zu2AYMYeofIouC+vAlY97/Yc2ZXcEKi97KnURMasXAYXxxYNT/W6L4mSJ2opkUVdJBiPKSOyoLnK5mRJ5o11hU4Or5b9lrF9bEidNY8FEPVAHz5mu9EGS7u5JynSs9/3M1H2/W5iapEx6vJoutqxqHyIO2R19EP6s7eafCoN9wVnZw1nfCFc18QqdTeQuec1ZX4oPA44gCvQ6jy8GdrTC2B3zYDF0zmoY4xK/NiI6vwItiicYH2cLmr6KQF3hrvUPnKRpfOCozPmw9OcLIW/Khk4QMx71XY1CoaqHaG6UhoZouR9NxkIohQwjN5BzW33akiTAmUSRierqUId7Ek=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/6/26 1:59 PM, Kairui Song wrote:
> On Mon, Jul 6, 2026 at 11:25 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>> When skipping swapcache for synchronous IO swap devices, swapcache_prepare()
>> is used to prevent parallel swapin from proceeding with the swap cache flag.
>> However, on PREEMPT kernels this can lead to a livelock, as reported by Chao[1]:
>>
>> Thread A starts direct swapin of a shmem folio and calls swapcache_prepare()
>> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refault().
>> Meanwhile, a higher priority thread B also attempts direct swapin of the same
>> shmem swap entry. Since swapcache_prepare() already marks the entry, thread B
>> repeatedly gets -EEXIST and busy-loops waiting for thread A to finish. But as
>> thread B runs at higher priority, thread A cannot preempt it, resulting in
>> starvation and a livelock.
>>
>> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) when
>> swapcache_prepare() fails, following the same approach used in commits
>> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
>> 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
>>
>> Note that mainline does not have this potential issue, which has already been
>> resolved by Kairui's swap refactoring work[2].
>>
>> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com/
>> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchronous swap device")
>> Reported-by: Ma Chao <machao26@xiaomi.com>
>> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaomi.com/
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>> Hi Chao, could you try this patch to check if it fixes your issue? Thanks.
>> ---
>>   mm/shmem.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index 94c5b0d78ac3..d4cb57b3b0ef 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>>          if (swapcache_prepare(entry, nr_pages)) {
>>                  folio_put(new);
>>                  new = ERR_PTR(-EEXIST);
>> +               /* Relax a bit to prevent rapid repeated page faults */
>> +               schedule_timeout_uninterruptible(1);
>>                  /* Try smaller folio to avoid cache conflict */
>>                  goto fallback;
>>          }
>> --
>> 2.47.3
>>
> 
> Thanks! That's much more simpler than I expected. Do we need a wakeup
> queue like the one in commit 01626a1823024? Perhaps the reporter can
> help confirm and test? I personally prefer to keep it simple if shmem
> users aren't as sensitive as anon users.

I agree. I'd like to keep the bugfix as simple as possible, if the 
reporter's scenario isn't latency-sensitive.

