Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93F71CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AE8B6B0092; Wed, 14 Oct 2026 23:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F626B0095; Wed, 14 Oct 2026 23:23:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 775166B0096; Wed, 14 Oct 2026 23:23:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CB836B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:23:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE9FA1A08DB
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:23:00 +0000 (UTC)
X-FDA: 85323414120.06.9525103
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf22.hostedemail.com (Postfix) with ESMTP id C48BFC0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:22:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BZDCNpRT;
	spf=pass (imf22.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792034579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHopKk64DY7EWCE10DKZKNY9Imw5pP763BGTSRVYZmA=;
	b=KlbHZlBSUCWX1xGZ/jfi5ff4hDTsWxWNo3EyD+ggYfHu0K8gfdPhABLXUWB/jXBjgI5OYf
	z4XQzSmDAHyFemeSeI4bX9kdRdwT+q8Po2fs/mm/Sa5oyQZqirhJWADSTA4jmuzG7P7/Ys
	4UhqB7pnPOWEYcNuCYbygSNUWce/1Uo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BZDCNpRT;
	spf=pass (imf22.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792034579;
	b=iiWex50uZorhEeXmByRjD9t1W5OBTN+j55IUF5yAIeOO5Cyj1LpdxKIqX6kWfVOeuj5FK+
	ODAWKLw3wr+bP1uEzukzMTSN3NXZ5M6c+SymVkUBuZWRMRG6NO5jh70ovP2hfLoTELAFBV
	GibVyPf0ReuCtfWvEfossm3CgTZJTGw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VGKrExJNYUUNySmqOW+kH+JnNYhJHPQ4iY4gAWKFLeM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792034577; v=1; x=1792639377;
 b=BZDCNpRTSJjS5/BcTJRe6SW2OKJ7Dp93m+naChrsAjHQfNxvpVZtrJHwtkrs9jMKW9qNdJGF
 QBaHKkhEhdkhvT/AsFmaV4SruuyI9vaISCk5PFucGbbOdt/F48htTtOoJ2SLzCT5N8EfjKtVyyF
 NxpBPJrQtfon4lI7amwnp0QY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5105a6205c935dd6;
	Thu, 15 Oct 2026 03:22:56 +0000
X-Mizu-Trace-ID: 5105a6205c935dd6
X-Migadu-Flow: FLOW_OUT
Message-ID: <53329003-de19-4a9e-b337-0b1e15190c91@linux.dev>
Date: Thu, 15 Oct 2026 11:22:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <20261014160235.29a39f19ccd19aec47b63008@linux-foundation.org>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20261014160235.29a39f19ccd19aec47b63008@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C48BFC0003
X-Stat-Signature: p5i1gyg9rkuhptn6thff99egw61offib
X-HE-Tag: 1792034578-872949
X-HE-Meta: U2FsdGVkX19VhdCrhiQA/qmB2u+2v/bjOFZdF4gBXtITElDrAkP2jO5S6NzzX4i9pymmCPNbCZSpN5QZJsa+DVb0TfXgGHoiGKBcnLKMh/la4+oH/tu7jYiXC9mWyhCsqUXvIwmP1PFm7C0emVBjpbg/EpxCal8cl/hO2mxkP5HCap4SHwh/zNAeLFTmY6BEZ7rgbJvJrWY7s+Z/3Z8JC/QM2eg+tpOI0+Ovn5MoOkhqlzijHQgULM/ifncP69Q5wke6rxJCpHvJDH/TbX3xsvKFGZ0ebhEsSMJ3j6O/NbDw9EZcoGHUf6IMEbOY1pKtfDtejolGhc5r+++lINe9IrVp8QBgbK42VeCtvGHVRE0mz00iJAbg64auZ1Gpl+uc3/7lT/M3sOTqxDGIDqH+8QJOYLV5snxWlaBnqy9XreHmYXwWq4Bx+uxQgHUPhl85HbFCfS5Y4+hUIob9S3gYl9OVz4US1TEDxNsW2xVkgSDnzDdvvTw6SAOpkBu/DaeizczMHgrQ9i9q4Ux5EHUgPs9/p2oxOykp5I6OQvupl1l+w/UX4tuCrHcnuelH0oKJCbFCt2q7XfDr73imTpf5vPnLT6qsNtyvnogv7A+OyRrDB2iX1NZ3sxoo0eBbLC+Dgx3xI6E7H7V2+j7HpiiailchVhJcYM4Z9y4dq6Gje/X2tDxwDpHW5hVoJyhRZJdwkb4DsLwqqFKpfd5dNcz1+HdXWNvwLfnH1iOWUPmijMZEsCiMqh8s8QeDZUljsp+QPb/JkOSacvL5pqGTE8h7V5Pn74ya4MdaRT6jiPReGRZ8emDHItjOb0rP2DAxmet+c6UZDgbvJ/UGKpRiRagHtx9plj50YBz+lxXzA1isGGZ8MQ8Duo/8OVHxFC9mi+VDnkw1jAF+Nry8e4UoeJ95QOuHvYynkHeMpsfOprHVGLtCW/5UtMqu0X+2014U+arMiGMcPmm/hs/fQ8p1cV2
 3Bcmav/0
 Y7mCQ+z1g8LQbtMd0vOf8ksaenVPVyG1zPfdbpxSf7kkwWmLMxJSs347c7FkSQDJnCcD0gYc+T+jZgeasP5V8Z5m/HZ8GcM/qPY6shdQxZ9Y+HValPn4+Gqxr0H+CGXUC/XYtwtw3s5/JI0ryrpd0/3c1BZrsgZo7Kq9jieKiXzTAHSXPI4zUlUFcBAcMBYr9cox9pOfaaindGH7ypxe9LYYQkjAfmCvE/Cs7zSq9/Gvwa56Jlk4NWGxPx/hP0TFvEk9381mupDCW/KVHckxvj5BK6WD71ArLzLVYaquv7eatQz7PRI7s8c3pLRYfVOmCrVqpgGRTM/y/lljngamj8hx8xdo8BCnBp3ZZg0SaS/I1CNPYP5/hbrcj2LNgxnPUhaSWPjNxeHexPO96URdc9vTr5VoOGpAvBnR580X6d2Z2Ki8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/15/26 7:02 AM, Andrew Morton wrote:
> On Wed, 14 Oct 2026 17:08:19 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>>
>> On our production hosts we saw swap cache only pages keep growing for days:
>> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
>> swap slots were held by folios that no process mapped any more, charged
>> to cgroups whose workloads had long exited. The only way to get them
>> back was swapoff, and with other services actively swapping on the
>> same host that is not an option.
>>
>> Such a slot has swap count 0 and an unmapped folio pinned in the swap
>> cache, left there after a process exited or did MADV_DONTNEED. No page
>> table holds its swap entry any more, so nothing comes back for the
>> slot; LRU reclaim drops it eventually, and the allocator only reclaims
>> such slots once swap is half full. The growth stopped exactly there:
>> at 50% of the device, where vm_swap_full() becomes true.
> That's a pretty nasty problem - thanks for working on it.
>
>> Options considered:
>>
>> 1. Fix it on the readahead side: after the read, check the swap count
>>     and free the slot. Covers the lock, not writeback, and the
>>     asynchronous read path unlocks in the bio completion where the slot
>>     cannot be freed. Two places to patch, neither clean.
>> 2. swapoff/swapon clears it, as does memory.reclaim on the right cgroup.
>>     That is a workaround, not a fix.
>> 3. Have the side that gives up come back later. This patch.
>>
>> The zap runs under the PTL and the fault path takes the folio lock
>> before the PTL, so waiting there is out; a worker has to do it. On a
>> lost trylock or a writeback refusal under TTRS_UNMAPPED,
>> __try_to_reclaim_swap() schedules si->sweep_work. The worker walks the
>> in-use clusters and, for every slot with swap count 0 whose folio is
>> unmapped, calls __try_to_reclaim_swap() with TTRS_WAIT, which takes the
>> folio lock and waits for writeback instead of giving up.
>> free_swap_cache() now calls __try_to_reclaim_swap() as well, so both
>> paths give up, and wake the worker, in the same place.
>>
>> For now the worker scans every in-use cluster of the device; marking
>> the clusters that need it can reduce that later.
> It's a substantial patch.  There's no quick-n-dirty fixup we can
> prepare for backporting into older kernels?


I couldn't find a small one. I tried the other options listed in the
changelog, and each was either incomplete or spread over many places.


The zap can only trylock, and the folio can be held by many things at
that moment: readahead (sync and async reads), writeback, zswap
writeback, reclaim, migration, folio split and so on. Fixing it on that
side means patching each of them, and missing one leaves the leak. This
patch fixes it in the one place they all have in common, the zap that
gives up.

As for older kernels, I found this on 6.6 and I'm happy to do the
backports.

>>   include/linux/swap.h |   1 +
>>   mm/swap.h            |   1 +
>>   mm/swap_state.c      |   9 ++--
>>   mm/swapfile.c        | 101 ++++++++++++++++++++++++++++++++++++++++++-
>>   4 files changed, 104 insertions(+), 8 deletions(-)
> Sashiko had a few things to say:
> 	https://sashiko.dev/#/patchset/20261014090821.227366-1-jiayuan.chen@linux.dev
> 	


Thanks. The large folio split and the offset step are real and come

from TTRS_WAIT.


The swap_cache_get_folio() race is pre-existing, I could reproduce it 
and will send a separate fix.


