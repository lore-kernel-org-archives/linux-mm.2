Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49D0C79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 00:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EA66B008A; Wed,  9 Sep 2026 20:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340146B008C; Wed,  9 Sep 2026 20:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22F496B0092; Wed,  9 Sep 2026 20:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EFA8F6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 20:48:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A55CAC03AA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:48:06 +0000 (UTC)
X-FDA: 85196015772.29.A32E739
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 72F36C0009
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 00:48:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=U3F6o9ue;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789001284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nq8vLjHk5vP6E4/mvbpyGkWBdIX3aI/IOS8rGp1uTP4=;
	b=XZCa5p1nV2mvG5ZsWsONuDs/KA4v/e6McXbg8ho5yAh/cQe2Eg/tzi8le/eVC8ZzgD1Y5H
	MdRRbzK2Bl2VLort3u7sFqU6TaJo+H2EjEPGIMeHfVzfy26nqBkWejvyyGfFQMsnxWLzQX
	lEWZf48uUa9xBpWp3unVwMcPTIskJv8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=U3F6o9ue;
	spf=pass (imf22.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789001284;
	b=ViEeXZgxXCmx8XddzMwHUgigpcsT2PuRCq6jXoZfAIYS2J6J6Pn1T3fouvm1Zqb5NvYXVP
	FYPlo3okx9XOyeE5vJ1Qq9y8cTQ9IXGsElwd0DfAeQ7pB5osaVI6NlgALqC1QfX9f+6KO+
	GBymUXTHK6/X4SnHf2eru5D4roZnMJ0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=nq8vLjHk5vP6E4/mvbpyGkWBdIX3aI/IOS8rGp1uTP4=;
	b=U3F6o9ueRtzWPUHauNFS00Qv0nhsUsuvxkyAegc8UGRmpFCPBoGd89gMk+53QS
	k9rQQJu5VmVPRQl2LVfRujXDTfGmEXLY84bm6VnD+8Z3Kg3SO7CLkha2kyHTB7xl
	kuyBOVZ1cZnqQbU2fMcZcSMdHX86P598n6YAtfJzH9iRE=
Message-ID: <5cd47bc3-bc3d-473c-80d0-8be8b7b79881@163.com>
Date: Thu, 10 Sep 2026 08:47:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/ksm: trylock the mmap lock in the unstable tree
 walk
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org, david@kernel.org, linux-mm@kvack.org,
 chengming.zhou@linux.dev, linux-kernel@vger.kernel.org,
 xialonglong@kylinos.cn
References: <20260909110228828hKTCgUeuZkOujOBaVtUcL@zte.com.cn>
From: Longlong Xia <xialonglong2025@163.com>
In-Reply-To: <20260909110228828hKTCgUeuZkOujOBaVtUcL@zte.com.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAnr08q_qFqdB8LBg--.771S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxury3Ww1ftF18JrWrZFy7Jrb_yoWrAr1kpF
	W2ga4jkF4kJr13u34Iv3WkuFyF93s7KrZ8G34rta43Ar98JwnrGFW3tFy0gFyUur1Skws0
	vr4jvFyq9FZ8XFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07Uh18QUUUUU=
X-Originating-IP: [2600:3c15:e002:6267:9ce2:e233:64a4:205f]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2xbPyGqh-ja3AAAA3+
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 72F36C0009
X-Stat-Signature: x5cd9z8h3kurhf7dudwgk4y9mqbcek6k
X-Rspam-User: 
X-HE-Tag: 1789001283-228843
X-HE-Meta: U2FsdGVkX19kLcVzXap93/TDeGgCsUjgdaq2p7tl9qXTw11VWGC2ThLO/bzyVymLsYWdf/4M0GbuMEzIio5zHxCQvlFCr0XmxuY2nI1rokKlx7LLMT/4rZ6vYvtn8Me+/+xFf6RKz89WZbIwM0oD7b57myBWg23i7RVpAWgL9FTOhCs1L11JanOScbP7B4mXTJcp/mlo7drTER0gH3QnReGuE4U+N1p8cxM7gSk5/+UP+6iDv7aaHlD8prEVsConXQRkxMnWco6cjISsuJSMOZbMrv2pC2L4+JgL5vsh3zKI80F1lM3tgjFqQW8YMiN0dT9c0he2lxnttmPS9WmEaoqu8RDnfqzwwvWUi/5rkbTfKQjiB+UTHDMMfiqQTvCiIxHmOarewwC80q4cP4OCdKoYKl/zsGDSwjiGyLc0z6w+OxuISyZGyJjCTgI+/XPr1TSnvuGDyC+6hAiarjitrk1L3Q66cG0jzSfrsw4fEcSd/Pk8/MY5lVXiVk11ZF73nFt7bGnmOarwhdZ/EvVnaL5jZ74NcPsUEIOoPeORXwcVIVbzfILA0iVfUIB7basDWtQ26Kk6Dvgo5kKJSxxwuEPZ+PHvHiVBDg9wLNAkkbGG6k48WLL3f1+p2H05sECDdyGhq0zEW7AWaPx3R+gosUdqake4/IPI6JZVOyqdFLUryGZNrHCbd2TdWDIgUtG8JJ6yrk5Qt8EuEbxZBTFxbYH1sdnSzn5VRmd36bK0r54j7Vf6lRcDoy23KYcmS1zmKMAKlpnWnWGXPbY82k4sD17VAowLuuA6FLVD6ejza2z/P0GXJ0Mi50Fgig24mxE9oOFTbAyu9q41FZPZvzAhWbE6lmlnoT05ZNf1BOgCsUNQXgh/L3j/sF3Lp0HZ5xorTVxDgU3ppmGs7hCClMFE5tehEdH7F6Xt9eCbRJg/HojtzKcbiyilPp0pPezTnuFCbAst5ar23k60+zBxcJJ
 zVTvYlsk
 UPLs7ilQ2Sfm+HwxsSt9ywNGl6facm7s77J+58bkeJ3ZCfk62urhfvBAC2/U61xRn0okzdMyLb+MJhiTZDVMrS9bbapQuitm8gADkfo/mFYhylSN0IPB7h56tathpag52v5X53JW0TmJm2tKPGDVTGYemOTonW2qzYjBaheQti4LvJpfD3QtsrCwsWpJh6BM/KIRqk+SjuSlBfzSxgxDjiCsC9FCezo3YPGSWvAXhCL4weGwC9yYFAX+ppQeu/fV90UD3CoXJOsAI+X7ms08xi7YJn3eHaUldKrnUVSmyH6buv8MooGK7UXpSapfFsOPoLToBGHhJxVE61wy+Kn2y5lLPcucoF6ymMUCtYX7A0AzEGU68jGKAyVb7ywqU5s7LzQwTKdTNTSSIKP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thanks for the review.

在 2026/9/9 11:02, xu.xin16@zte.com.cn 写道:
>> From: Longlong Xia <xialonglong@kylinos.cn>
>>
>> Every node that unstable_tree_search_insert() descends through is
>> revalidated by get_mergeable_page(), which takes the mmap_read_lock
>> of the mm the node's rmap_item belongs to. These are taken while
>> ksmd holds ksm_thread_mutex, so a single mm whose mmap lock is
>> being written to - a process busily mmap'ing or munmap'ing -
>> stalls the whole scanner, for every KSM user on the system.
>>
>> Use mmap_read_trylock() instead. The trade-off is that pages of a
>> contended mm may need more full scans to merge; in return, ksmd
>> latency no longer depends on unrelated mmap activity of the
>> scanned processes.
>>
>> Testing, on a 4 vCPU QEMU x86_64 guest with ksmd at
>> pages_to_scan=100000 and sleep_millisecs=0, 5 runs per kernel
>> (median reported; baseline is the parent commit):
>>
>> 1. A contender process registers a 64 MiB MADV_MERGEABLE area of
>>     unique pages and runs two threads looping mmap/munmap of
>>     256 MiB, so its mmap lock is held for writing much of the
>>     time.
>> 2. Once that churn is running, a quiet victim process registers
>>     32 MiB of 2048 unique pages duplicated 4 times.
>> 3. Sample /sys/kernel/mm/ksm counters and ksmd's /proc stats
>>     every 0.5 s for ~2 min of churn, then stop the churn and
>>     sample until the victim finishes merging.  The same phases
>>     run without the churn as an uncontended control.
>>
>> Results (median of 5 runs):
>>
>> - contended ksmd scan rate: 11,473 -> 58,397 pages/s (5.1x)
>> - contended victim merge time: 10.4 s -> 1.7 s; the contended
>> - contended ksmd CPU per scanned page: 13.4 us -> 3.5 us
>> - ksmd time in uninterruptible sleep under churn: 78% -> 57%;
>> - uncontended (control): merge time 0.65s vs 0.62s, scan rate
>>    259K vs 247K pages/s and ksmd CPU 3.9 vs 4.0 us per page,
>>    unchanged within ~5%.
> Sorry, I'm not fully convinced by this approach. The performance numbers
> indeed show improvements with trylock, but I'm not sure they translate
> into real user benefit. Users typically care about how many pages KSM
> actually merges and how much memory is saved, not just how fast ksmd scans.
>
>> Assisted-by: Zcode:GLM-5.3
>> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
>> ---
>>   mm/ksm.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 49d48d1e0998..3cfb09a926ff 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -820,7 +820,14 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
>>   	struct folio_walk fw;
>>   	struct folio *folio;
>>   
>> -	mmap_read_lock(mm);
>> +	/*
>> +	 * We trylock because we don't want ksmd to wait for an mm that is
>> +	 * busy changing its memory layout: we prefer to skip this page and
>> +	 * let the next full scan retry it, like the folio trylock in
>> +	 * try_to_merge_one_page().
>> +	 */
>> +	if (!mmap_read_trylock(mm))
>> +		return NULL;
>>   	vma = find_mergeable_vma(mm, addr);
>>   	if (!vma)
>>   		goto out;
>> -- 
>> 2.43.0
> Sorry, NACK
>
> Also, this change feels a bit too blunt to me. In scenarios with even mild
> contention (far less than the heavy churn in your test), ksmd could end up repeatedly
> failing to acquire the mmap lock and thus fail to merge any pages for a long time.
> That could hurt KSM's effectiveness for ordinary workloads, not just the contended ones.

Indeed —— further testing confirms that repeatedly taking and releasing 
the mmap lock slows down the victim process's merging.

> Besides, there are lots of mmap_read_lock in one page's searcing and merging of ksmd, such
> as try_to_merge_with_zero_page, try_to_merge_with_ksm_page and so on...
Right — in my other tests using trylock, the difference was far less 
pronounced.
> I'd prefer a less aggressive solution that avoids stalling ksmd without starving page
> merging entirely. Maybe considering it together with smart scan? Need to see other
> suggestions from other maintainers like David.

Thanks for the suggestions — I'll explore this further.

>
> Thanks,
> Xu Xin


Thanks,

Longlong



