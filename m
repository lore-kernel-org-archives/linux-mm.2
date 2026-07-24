Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDAEC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 13:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8279F6B0088; Fri, 24 Jul 2026 09:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8266B008A; Fri, 24 Jul 2026 09:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EF5F6B008C; Fri, 24 Jul 2026 09:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D216D6B0088
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 09:31:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A3DF12032D
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:31:56 +0000 (UTC)
X-FDA: 85023758232.06.34A460F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3FDF720005
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 13:31:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSYp83tW;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784899914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0L14fpsDjK7+KbfhNaWx2JjhNpl8Qbr0apeF37K42Uc=;
	b=UHU5thT9XwkcxxvbWbaCDt0V5mBem6gUOP7Z8bEkSDDlPibv5IOlWymzmiT10Nv6jlQtFj
	BK0MIRXeoyviwChWV7+s3FkWYK3Xrwkaki7IqlpVPkForM7D4lhenpZKPC8lyBZ3VrztTV
	o2HVsVTMcQ9bs6XvYUrpIvkfzMbD6eI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784899914;
	b=057bLUgYC9cR9MGdN+6X5cxtj+5vyV8+k+GDcI+WmXaNTSMD3hncxKGokPTg9hMy0V8OUO
	OyPYRdOG6mXMsFM8GdxfjkeMD6U30UJvAHGuLU5wqsmJshTfFl8vGYkqe5NeN8pkjUVE1v
	n/rEITK8TeZ/5sCAkiKagvPM6xkJ5ac=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jSYp83tW;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fb6b983e-843d-454c-bfa1-ec802228f981@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784899912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0L14fpsDjK7+KbfhNaWx2JjhNpl8Qbr0apeF37K42Uc=;
	b=jSYp83tWZQIV6kKKIgu/juSKjF6BY5bm7gikrfI/fIOwDQL6r8L4HWUN0Fade11N9zar4E
	l4mS+UfVZ/mb7Db9jfrbc5B5IirlKduEBGG2NLHImr9CD/20BXJ80YZPjPrDPuoPxgA3mi
	SBmFW/AO83AMMm8uTAXutSlMsPIZynw=
Date: Fri, 24 Jul 2026 14:31:12 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v4 0/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, chrisl@kernel.org,
 nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com,
 hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 rientjes@google.com, kernel-team@meta.com
References: <20260720164207.450685-1-usama.arif@linux.dev>
 <20260723133548.2e12b638bd629ef63b935113@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260723133548.2e12b638bd629ef63b935113@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3FDF720005
X-Stat-Signature: yfuyinejizxunbyh75eyf57qgh6zrx45
X-HE-Tag: 1784899914-636462
X-HE-Meta: U2FsdGVkX1+ouZDvtXM3E+AKovActC4xiRc1H9Ca15jZmHdVM9FctiD6DSnaOsG9g0AFP0pp6XIXRxNAJXaOV6/xnwSFKAYBQqRvlEqdexI8ZAfeGZQX5ETSLRnTqqCXXBImM4iKpAOjThOCfJcHzf1a87qyq9mwgtIsyt4P331Ba4sNstOHnZqrKtsnhju1qu+fs2HEV004pDgrdaKsDIiZCeQtB7QbIN1sTqY/7z63h3GmLCtzFZ1YxsbA6NyTaiFtsHQkAIHQuav8DDM2fvNTlequOLEJtGeWDfTDOM80RqeCQximfhEinRzXSbiUSzjlqe2L2cUhd8K5sHm8pEkfwuW1B2DW1Crfds5rJdGD3CyVbTA4YjPmjJ4x3GyK5/84+9MttcW4h2/pzsWtlVnnkiXeZ1qYGtnh7RveeOF+6Xy8QP9X6hFCQVizEob5Q8FKZVQd4VKvLZR2HrFD+MG/hnQM7ptpe7v9oUDYOopQprGpROmWApBUawpIoNDo5hSee6YToJXjPzfkbyI+YtXibOGlbeTLl3/SwXVeMSZ61GUuRpyjCog5ua4RvRkvy7Xd8k4VYTvMYFqw6AVru2X1/LmBK2TZs+LQ0bQfAIO0rRtdH3ySTaNGNQRT5UkNMeemhJ4bpLbE2zPDrDqNzr74Uh1WOBt+cWPtuzFElwACI2w6k18KmVJv7mNGPxaiQItdwi9t5kV6nhS4+nOaQ+vpi0qXmZjFlHnL4aIPuIgH8exOJV87y/yElIGfHfs47UdwC8CIoE+AR/XcIrrDAiIVP9AcbRXEYfFBEptavVL0YQ29hBYgAARxipd1OiotbepXwIbUJv7aLhLAdBmLU0l9Uc6Fs6TZt5GD3orn7ihi4/sfT7y1L1hGGOioh3cRUdlpstbACieL3aI1r+iQoQ9vjluQkBp44zA6ZJ97fbKo+deDWaY19E+b86/c+bHnMqKRnRKdEE98ZNl5E2d
 +moVSREP
 V9s9NUmpOoHG7eZRoA0L4UVLIVfEjgF9Qawsf5iy1eTmUsbRhIfIzXzwexpge+i2y/LrsGsxtR+lnmWSNMMAwoubn7ZDUunLQtHzjxV5Tf672DZI+IMd73dYt9O5sWT1PNgbcng1goqiJ2jxNSnPLHD2aYBdM2ZvbSE5AxUjFXudOxdgjCZyuI1vRtQWx6BZC5rrJN8DksYqkParwG3ORQ9M7+l+EmGXgcN4hiK4joFC0iAw68f4zuICkxdZnbucyUAKl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/2026 21:35, Andrew Morton wrote:
> On Mon, 20 Jul 2026 09:41:21 -0700 Usama Arif <usama.arif@linux.dev> wrote:
> 
>> The anon/file scan balance heuristic in get_scan_count() is fed by two
>> scalars in struct lruvec (anon_cost, file_cost) that every reclaim
>> producer updates under lruvec->lru_lock. The cost-recording work
>> itself is trivial, but it both contends for and contributes to
>> contention on lru_lock - which is often a contention point on
>> memory-pressured workloads. Specifically:
>>
>> - shrink_inactive_list() re-acquires lru_lock at function exit just
>>   to call lru_note_cost_unlock_irq().
>> - shrink_active_list() does the same after rotation accounting.
>> - workingset_refault() takes folio_lruvec_lock_irq() purely to
>>   record the refault cost.
>> - prepare_scan_control() snapshots anon_cost/file_cost under
>>   lru_lock.
>> - lru_note_cost_unlock_irq() itself walks parent_lruvec() and
>>   re-acquires lru_lock on every ancestor, multiplying the cost
>>   of every update by memcg-hierarchy depth.
>>
>> This series removes those producer-side acquisitions entirely.
> 
> Thanks.  We're still awaiting review of [2/2].  I'll get this under
> test in order to parallelize things.

Thanks Andrew! Yes I think we have the reviews, but just 1 outstanding
comment from Shakeel and need to shorten commit message as Johannes
mentioned. Hopefully we will have a final version next week.

> 
>> Measurement is a 30 s `perf lock record -a` window
>> over otherwise-idle hardware.
>>
>> Workload rates are identical on both kernels (the bench drives the
>> same memory pressure):
>>
>>                           baseline    patched      delta
>>   pgscan_direct  / s      172,662     171,817      ~0%
>>   pgsteal_direct / s       67,162      66,306      ~0%
>>   workingset_refault_anon / s
>>                            40,696      39,830      ~0%
>>
>> perf lock contention (total wait per 30 s window):
>>
>>   Lock Name                Before      After     % change
>>   shrink_lruvec+0x770     722.84 ms    0         -100% (eliminated)
>>         (= lru_note_cost_unlock_irq)
>>   workingset_refault+0x167 385.26 ms   0         -100% (eliminated)
>>         (= lru_note_cost_refault)
>>   shrink_node+0x4ad       689.43 ms    26.95 ms  -96%
>>   shrink_active_list      208.34 ms    15.97 ms  -92%
>>   lru_add_drain_cpu+0x34    1.96 s    917.71 ms  -53%
>>
>>   Total LRU lock wait      ~4.23 s     ~1.66 s   -61%
> 
> So it saves 2.5 seconds out of 30 seconds?

Yes 2.5 seconds total CPU time in the 30 second perf record.


