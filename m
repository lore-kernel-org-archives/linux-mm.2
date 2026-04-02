Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BB66111227B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 03:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA6AC6B008A; Wed,  1 Apr 2026 23:31:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58256B008C; Wed,  1 Apr 2026 23:31:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D776B0092; Wed,  1 Apr 2026 23:31:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8439B6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:31:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 239EF1403C7
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:31:17 +0000 (UTC)
X-FDA: 84612190194.24.E67AF89
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id 831C51C000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:31:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TgaUM6C5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775100675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DNIAkzRrtcgVKLAuk70sqGmrTfww7dBSw/i9YQSrGtk=;
	b=ktpG+7N4mW7IrwB/nYW5ekIsnrBKwIDdK1QYPm2HJSGl70qqjUNr1rhuikjDB8cvTileWq
	h1IjoZT3FUwtIuCbHCkdBZZDbraiG2RfNfnAAgc7FtNpt94mHFZPc2P6lwA0E60tUhncHM
	t+X8HTvpQP30h0FUgq5QfCBulFvmJd8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775100675; a=rsa-sha256;
	cv=none;
	b=aaqIyMFGwPEnKf4OWrYtd/bQBvgobOaZntwlk54w9l5NxruRcHTrrR5bae4BFlxXCYQsms
	BJJLYfJyaB7azyeFDR+Yz4235iC1lYpdwMgeUeXLvqVsxA86Fis7vRg2Uasvdrx5Q+Ko6m
	+54xdu9AyA920BHCEAnC42M9q3FSoaQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TgaUM6C5;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775100670; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=DNIAkzRrtcgVKLAuk70sqGmrTfww7dBSw/i9YQSrGtk=;
	b=TgaUM6C5F5SBoe5R8L/xfLA2I5NUjC5kmJZI29cN8J6LBM26GO4+c+R92VPLiLrtcYLZtPwbvTUlMHfuNK1OECe6CxFObOzrPkHhWaM2oyWMuR5O7RgoErufK8vEqbSH+pTdjh9lQbM0snLbt+zGtzR4vYXX7CUCHOYsI1LI5IQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X0Fk26l_1775100667;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0Fk26l_1775100667 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 11:31:08 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Donet Tom <donettom@linux.ibm.com>,  David Hildenbrand
 <david@kernel.org>,  Ingo Molnar <mingo@redhat.com>,  Peter Zijlstra
 <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>,  Rik van Riel <riel@redhat.com>,
  ying.huang@intel.com
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <20260401172220.fff999a33e3ffcd0d1fa8929@linux-foundation.org>
	(Andrew Morton's message of "Wed, 1 Apr 2026 17:22:20 -0700")
References: <20260323094849.3903-1-donettom@linux.ibm.com>
	<20260401172220.fff999a33e3ffcd0d1fa8929@linux-foundation.org>
Date: Thu, 02 Apr 2026 11:31:07 +0800
Message-ID: <87se9et4w4.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 831C51C000D
X-Stat-Signature: 1jismd1o5jc5hgptruqfkm8yzdgywoku
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775100674-77352
X-HE-Meta: U2FsdGVkX18QzB4nEpRhd9NYwmIhrQXsVk3XbgbJ9os9Tp6SzcUfuETTgBOtiY7JxC75Pz/3LGs1ERjm8f84AYBWaG6piWcOeVjwJ+YfpmM3VwV+ECFD4v+NjbLy+5UOlGyIN881ZS7ai7pNACPEPi2k5dAFhER7oZ/G2kIBr996jtuURdrFsFeK6gVr6kRRnbW0aFtwkV0nsiZS4d+tMyhM+YPu0pSBF+vYIGAoJomv5tQDnr9whkKoXOTBckM/wtBG7XMF41PYeN+vpQici++53HmpSrFmLWlWJS/BvSz6akefTmRidEd2ftaXTNvnym5rJPtR04lFCWH1NbGBs4Z2pQHWc6V1yB1IYdG6YbyZN+4J9EExvotRvaFrG3Mf/HpuprNkrLimyq978O0sqi40k9s7O6j+WQ+bciyFwUyYbOAoHwLzB6O7snXwuAaTovuWZUPnVqxdK+1AGYwEy4r9WTB81UE/n1KUUCgof3HOUsqftFm1qhC+87fo+5/h6C9yM/qlwFvctF+XgJC/kruZnams2FyR07Or0kv7vrtW43sqb6tdvf4ww3mRq6a8jgu07UkBGPsSIc52DIt4j0SY4KFU9T1xJj3l9Au2ZGdhTJdQTTL+9EHNOWyWAKC8dfD6OalFN0LVXX6Ly3FMEvZVrL4hWeuCT0tCx3mAC063kbx7Tl7W0Dnmv04AMjQUehSwh7DKsw90QWJHv/VQJVq4qUO2PD+rJzIRsSAIInA6GJiX7fHDp/7KH2wdOanrqthzh9nGbbeOp3aUzIhf5EebACsQ5/sCmR+4mXoaElKr1OHrBCXkNitlyJmL3z+z6/xQJ9iDsv8jVz/XbWR0jeDh7lJqY1NJO/H479DoZwK+Y6tKLlsrYQsLtBaKLAfxrJlvsTVSed8piCaAqvvUQNkoFhtXSMYjR7rMMjHXsUi6vF+R/q2rJEiyLVZlqZ1TBJw1bCo8+Grfw6xPKgT
 BNaXLjVb
 i3YPe07HhosoAoviHbjLCQbrc4wQJEM+J1uVWAA1HAuRUxct5vNzFNfjHyWIT7PAJvD5eeNEKVN/FmVEIEiwxMCIFp6sGlg4bB9SXyS4NMX8TdHOiKuukzHSLxC/6EFEvzplszvGEfavh9a1hWFJMHjq2RrjmctmAc47dUvswecWeVx5d0hXcxnn2hDAsZaLSvjy2jCguUR3douXv7Ds9AFjYiOGp641D3ehvbSGrzEbw+1+TxnpEYlhfvWB+lIqTvUwk+525+9TP2j7CgSTGkjLCTT1ldL2qITHEepIW6meS+YhDSWxeth37bHnRaV4XFqwMxTcK3ST6b7R3/gy8ggf5OGG++o37OwgO2cYOxb/AYq/39SbrEj+7D6KiqtYnSKvVf7SioGbF5ehBS/b3dvnPQZU7xRKGhSPPapti2yowGt78kmokTObqGGvvttQX1YMYZMBxwxXN4wKXgJpxQVNf234XUG28qHrA08h9xryuYimyqG4dmQimgavhEEJiy/F1pXYRn+atCLqWBd6FsBe/a//M0dFF+B78nId4WUMpISYcwzQejwAyV+edIh/xUTDbqaCuxd4SAII8OeB4t9shdBVzfRX1f6X+2APQS6O5ocYQKe8lNUgZTV2/+l87TgpW/l0kJp8KxBj4AWaJQLFkwHN8g8uLKwlLH8YhW/4qVnn8S/+ZgbDpFcerh/NuqiKKoIaP+EULsMXDQRXJdvtaRsgzuEXm62gZF0Go+VLl+SAU/1LCR4nuVYM5KzwfqxAYycY0B6nK7Pr06+2R0x9dj3t04AVyic5zx8p+G1ZyCXTpBDJORZCH/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Andrew,

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon, 23 Mar 2026 04:48:49 -0500 Donet Tom <donettom@linux.ibm.com> wrote:
>
>> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
>> disabled and the pages are on the lower tier, the pages may still be
>> promoted.
>> 
>> This happens because task_numa_work() updates the last_cpupid field to
>> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
>> enabled and the folio is on the lower tier. If
>> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
>> can retains a valid last CPU id.
>> 
>> In should_numa_migrate_memory(), the decision checks whether
>> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
>> tier, and last_cpupid is invalid. However, the last_cpupid can be
>> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
>> evaluates to false and migration is allowed.
>> 
>> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
>> disabled and the folio is on the lower tier.
>> 
>> Behavior before this change:
>> ============================
>>   - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>>     nodes within the same memory tier, and promotion from lower
>>     tier to higher tier may also happen.
>> 
>>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>>     lower tier to higher tier nodes is allowed.
>> 
>> Behavior after this change:
>> ===========================
>>   - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>>     between nodes within the same memory tier.
>> 
>>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>>     tier to higher tier nodes will be allowed.
>> 
>>   - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>>     enabled, both migration (same tier) and promotion (cross tier) are
>>     allowed.
>
> There was no feedback on this, nor on your v1.
>
>> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
>
> Ying Huang seems to have moved around a bit - let me add a couple more
> email addresses.  Apologies if we have multiple Ying Huangs!

Thanks!  I don't find other Ying Huang in mm community yet.

Now I use the following email address:

"Huang, Ying" <ying.huang@linux.alibaba.com>
Ying Huang <huang.ying.caritas@gmail.com>

and stop using the following email address:

ying.huang@intel.com

> Rik, Mel?  It's a bugfix.
>
> Thanks.
>
>
>
> From: Donet Tom <donettom@linux.ibm.com>
> Subject: memory tiering: do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
> Date: Mon, 23 Mar 2026 04:48:49 -0500
>
> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
> disabled and the pages are on the lower tier, the pages may still be
> promoted.
>
> This happens because task_numa_work() updates the last_cpupid field to
> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
> enabled and the folio is on the lower tier.  If
> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field can
> retains a valid last CPU id.
>
> In should_numa_migrate_memory(), the decision checks whether
> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower tier,
> and last_cpupid is invalid.  However, the last_cpupid can be valid when
> NUMA_BALANCING_MEMORY_TIERING is disabled, the condition evaluates to
> false and migration is allowed.
>
> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
> disabled and the folio is on the lower tier.
>
> Behavior before this change:
> ============================
>   - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>     nodes within the same memory tier, and promotion from lower
>     tier to higher tier may also happen.
>
>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>     lower tier to higher tier nodes is allowed.
>
> Behavior after this change:
> ===========================
>   - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>     between nodes within the same memory tier.
>
>   - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>     tier to higher tier nodes will be allowed.
>
>   - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>     enabled, both migration (same tier) and promotion (cross tier) are
>     allowed.
>
> Link: https://lkml.kernel.org/r/20260323094849.3903-1-donettom@linux.ibm.com
> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Ben Segall <bsegall@google.com>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: "Huang, Ying" <huang.ying.caritas@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  kernel/sched/fair.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> --- a/kernel/sched/fair.c~memory-tiering-do-not-allow-promotion-if-numa_balancing_memory_tiering-is-disabled
> +++ a/kernel/sched/fair.c
> @@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct t
>  	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>  	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>  
> +	/*
> +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
> +	 * and the pages are on the lower tier.
> +	 */
>  	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
> +	    !node_is_toptier(src_nid))
>  		return false;
>  
>  	/*
> _

---
Best Regards,
Huang, Ying

