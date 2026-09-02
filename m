Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD86C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 09:30:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC056B00D5; Wed,  2 Sep 2026 05:30:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B821A6B00D6; Wed,  2 Sep 2026 05:30:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A97BF6B00D7; Wed,  2 Sep 2026 05:30:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8577F6B00D5
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 05:30:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDE3C140139
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:30:37 +0000 (UTC)
X-FDA: 85168302114.29.52CB575
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf06.hostedemail.com (Postfix) with ESMTP id 70F3218000C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:30:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QHaCky8j;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788341435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IdGkbmMSz5JoiHdwdzHjmW+Wa0JMP2J2z+g9mX4Y2Gg=;
	b=jIbo6/xMoEOAEpIlgnr4wgq+lrpXUK89NTahcY83CyX4IXG6CtMC1ddUCliR8mS09QMG0n
	ZYAwgdN5CY1UVSuqn4o6W79Z0yzWUqKyOMgD9BRFA9kWA8EXnhIP2aNHCSzFeqYU76mcvb
	HQjsqgJib7IZpp7abgEt5RPhh7tZNkQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=QHaCky8j;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788341435;
	b=OAOVm2iOwFh7X/+pSfRe76cppLTyfbwMTq/4Mj/0vSjUMXkaeql9h+F942UcmNJ+rZLOkF
	/vzAXbjy7QlQtm/Wv02qOryNdRjeXujw9JqmNrDpBRA8VZ97XLVCp9JV9cxhFGTY3onApt
	znkbXvA9wpthPbeCWkEFmTDmGG0cjp4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788341431; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IdGkbmMSz5JoiHdwdzHjmW+Wa0JMP2J2z+g9mX4Y2Gg=;
	b=QHaCky8jeDeFTCq1mkIScHeUedVZAg1IUgp6FMjW5TIKJsbbVQacGFIdXfKBOwGG/u48KzsoC7AIibhmj3vUDNpsOGVz3kKR0mnHyz5N1EV4QZkyspPX0MMf4TaXikF1bCI+iDcvzcYINa9elierAXgamG7rF3/DF6djbNJyf1M=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XACEO3k_1788341425;
Received: from 30.178.84.37(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XACEO3k_1788341425 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 17:30:29 +0800
Message-ID: <1adc7e15-c878-46a7-89e5-79469d796024@linux.alibaba.com>
Date: Wed, 2 Sep 2026 17:30:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/list_lru: disable memcg awareness under
 cgroup_disable=memory
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Xunlei Pang <xlpang@linux.alibaba.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260902032840.30250-1-qinyuntan@linux.alibaba.com>
 <ef76e85b-dc8e-40b7-9a7f-a071d54ca7fe@linux.alibaba.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <ef76e85b-dc8e-40b7-9a7f-a071d54ca7fe@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 70F3218000C
X-Stat-Signature: o881oqni1kuggmmpdhoor13oj459y56g
X-Rspam-User: 
X-HE-Tag: 1788341434-846540
X-HE-Meta: U2FsdGVkX18zmpzKIDJ/u9ro6+H72gaX5KlZLoyv1aREq3npEvkqXHDFQickPX8iuwVSbU4a+QI22UtVFVNCp4QaWnWkXnvgKohgWOJzD9rBI2qCNIeSlLJ7We3N8qlEoI3+SoYCcMrwz9o212b9Xotdmb4T7uiXzgKKEFLQDM7AGmBbFsobenHJyNXpAi8qBh+BhI1wQmQU/zusjTQSBw00kJegT6RdhhWGc34rdaIcwCrhNZ+94+fJgw2NxSAsKwFOiVSgdTzhXenallDgsLAmHF9TQnS9gv4vgDtYlK22GJ0vJSTgjczDf1BiyXhv/KUgW7HUGMEA1ouu9cJ/EXbQIj3Yg1ZkJbTJC4xVU+3LNxunTIvZ1dBGmc37sjfz32XuWwTGN0eXbXF7xOywaqn8AyOgclDCXI1O7Kz5Two4XHG5mvhzF6Z7Z6rp6jGm67m7aCPEGoUxKokW5D40JUSOtgZ0WTWJFvEvyDpi0NBNwbrCVNoyctul8jTaBIuNo5j8g9hYCT/NZvyQC8OCG71YOV5XrOO7Hpjqe6uw2g07TFGHcnNH5MpxGiYjj2981y1bn5/imJXk7MjvsCnItx47WNps9pc7yM3zKw4GYxANUUTEvvMSOMWeKHY/KlBDaIzDDxihHr/71j7oWmjYzt9RsQwYZ1/5Raf51JDCjLaY2XSMT8hfBJPx4oYl6txYYqAkmnTKgjDZzyxSVRFkYGjsPdzvA06D59fJEqu78pPHrD/pp8YEPYklX/OIci/C/n37fN2LyH9ixvSLMLcphdy2m5Cwr8TIR1lVn+e10jyaKZwohRVDw7DYlMU0w1eMBapE3kxFoFdh3dvWzdAwUNQVDnQPKTOygYo2+3GkoKqkxhU9D5voUx7JAoqOKk0WMEbBR9l6RpaLFvi6mXB/7Voq03fSTxv1nPbLpjuZI/VYfrAbXFrwWEAD/vLLHVID0bSXz2aSoYHc6LtVkYY
 7XQdE0Lx
 J1Wk1y3duKM1Y3jGuQn9ip3SHyIf1yBH5Y8CfGIMIn3KQy29j9u3etDRwIzhly2HrWEPo5j39tfiEkXLZI65jD66gAjocdLBV5t5DzhNrPl1epyK9c+9YGMp1LJ1/cinPJAscW+i4/rV0uld+FBVLhazce2ENGGKPswSvLvJv1dsItbhNwbABCYivoJR2TYilbSdw4bGXvPzCOoaucg9G0GgaOqEuZGKoP01kKaiarn4vWX7CvWQcBJxzw2loL8MPGFIJhSM1Ksaxu5YrZ7tOFzdDpopf/0cMjuQLUQ6xwJ5/vSBXW276OSPYptCISSG0umhlaiI9Gvr7SBKjXRhXyu1LOdEHLGpFL8vmUOPX9eeux3FzeFL1qa0pzmweDHG9bNgXQAavyci7dt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 9/2/26 5:16 PM, Baolin Wang wrote:
> 
> 
> On 9/2/26 11:28 AM, Qinyun Tan wrote:
>> __list_lru_init() only collapses a memcg-aware list_lru into plain
>> per-node lists when kmem accounting is disabled
>> (cgroup.memory=nokmem).  When the memory controller is disabled
>> entirely (cgroup_disable=memory), mem_cgroup_kmem_disabled() is
>> false, so the lru stays memcg aware even though no object will ever
>> be charged to a memcg.
>>
>> This is more than a semantic inconsistency.
>> folio_memcg_list_lru_alloc() trusts list_lru_memcg_aware() and
>> dereferences the folio's memcg, which is always NULL with the
>> controller disabled.  The only mainline caller,
>> folio_memcg_alloc_deferred(), papers over this with an explicit
>> mem_cgroup_disabled() check.  The shmem unused-huge shrinker
>> conversion ("mm: shmem: make unused huge shrinker memcg aware") adds
>> a second caller without such a guard, so booting with
>> cgroup_disable=memory and writing to a huge=always tmpfs oopses:
>>
>>    BUG: unable to handle page fault for address: 0000000000000488
>>    RIP: 0010:folio_memcg_list_lru_alloc+0x41/0xf0
>>    Call Trace:
>>     <TASK>
>>     shmem_get_folio_gfp+0x1cd/0x7c0
>>     shmem_write_begin+0x5d/0x100
>>     generic_perform_write+0x89/0x2a0
>>     shmem_file_write_iter+0x82/0x90
>>     vfs_write+0x256/0x410
>>     ksys_write+0x61/0xe0
>>     do_syscall_64+0x8d/0x460
>>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>>
>> The faulting address is the offset of mem_cgroup->kmemcg_id,
>> dereferenced on a NULL memcg in memcg_list_lru_allocated():
>>
>>    folio_memcg_list_lru_alloc()
>>      list_lru_memcg_aware()               <- true, only nokmem checked
>>      memcg = folio_memcg(folio)           <- NULL
>>      memcg_list_lru_allocated(memcg, lru)
>>        memcg->kmemcg_id                   <- NULL pointer dereference
>>
>> Check mem_cgroup_disabled() in __list_lru_init() so that all
>> list_lrus fall back to plain per-node lists when the controller is
>> disabled, matching what the shrinker side already does
>> (shrinker_memcg_alloc() bails out on mem_cgroup_disabled()).  This
>> makes the mem_cgroup_disabled() check in callers unnecessary rather
>> than mandatory.
>>
>> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
>> ---
>> Applies on top of mm-new.  No Fixes: tag since the commit that makes
>> the crash reachable ("mm: shmem: make unused huge shrinker memcg
>> aware") is only in mm-new; no stable backport is needed either.
>>
>> Reproducer, on mm-new booted with cgroup_disable=memory
>> (CONFIG_MEMCG=y, CONFIG_TRANSPARENT_HUGEPAGE=y):
>>
>>    # mount -t tmpfs -o huge=always tmpfs /mnt
>>    # echo x > /mnt/f
>>
>> Without this patch the write oopses immediately as shown above: the
>> freshly allocated huge folio extends beyond i_size, so
>> shmem_get_folio_gfp() queues the inode via shmem_unused_huge_add()
>> -> folio_memcg_list_lru_alloc(), which dereferences the NULL
>> folio_memcg().
>>
>> With this patch the same steps run cleanly: the lru falls back to
>> plain per-node lists and folio_memcg_list_lru_alloc() returns early.
>>  From code inspection the rest of the shmem path handles the NULL
>> objcg fine (obj_cgroup_memcg() and obj_cgroup_put() are NULL-safe,
>> and list_lru_add() with a NULL memcg lands on the per-node list),
>> but I have not exercised the shrinker reclaim itself under
>> cgroup_disable=memory.
>>
>> Discussion: https://lore.kernel.org/linux-mm/20260901115104.2944996-1-qinyuntan@linux.alibaba.com/
>>
>>   mm/list_lru.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/list_lru.c b/mm/list_lru.c
>> index 36662d02ff963..f8be119351cca 100644
>> --- a/mm/list_lru.c
>> +++ b/mm/list_lru.c
>> @@ -671,7 +671,12 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
>>       else
>>           lru->shrinker_id = -1;
>>   -    if (mem_cgroup_kmem_disabled())
>> +    /*
>> +     * With the memory controller disabled entirely, no object is ever
>> +     * charged to a memcg, so collapse to plain per-node lists just
>> +     * like under nokmem.
>> +     */
> 
> These comments seem useless, as the code already explains itself.
> 

Agreed, the condition is self-explanatory. Will drop the comment.

>> +    if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
>>           memcg_aware = false;
>>   #endif
>>   
> 
> Since __list_lru_init() is also exported, I think this looks reasonable to me. With comments removed,
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks for the review. I will send v2 shortly with the comment
removed and your Reviewed-by collected.

Thanks,
Qinyun Tan

