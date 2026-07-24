Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1FE1C53209
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 08:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3586B007B; Fri, 24 Jul 2026 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 674566B0088; Fri, 24 Jul 2026 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53EAF6B008A; Fri, 24 Jul 2026 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 218C16B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:57:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A70C41201F3
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:57:06 +0000 (UTC)
X-FDA: 85023065652.02.1E33992
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf05.hostedemail.com (Postfix) with ESMTP id 992DB100004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:57:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qlQJL/gn";
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784883425;
	b=m14XaP5MMHsL2OuWXeC3fDb3BsbtQsw6nhyY4Q20PsMNdWTa4kMon2GRUBMEGThGEHCF8B
	m3VvBBEDSmy+KUQRIFK1il8gFZVeW47+AwF6qaX5PPo7JjslTOJLIIhawBQb/x4DC7abC2
	/hrBtLr5f1aEzdLUMS1tL527/zyNcu8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="qlQJL/gn";
	spf=pass (imf05.hostedemail.com: domain of cui.tao@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=cui.tao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784883425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNHjK+/JGmMsSbCYCMJWygTh1XzjGhubS/Qib62Lnjk=;
	b=rn+BeMpVm7guEtnYn53UzCIzDLFiZb7+CAdqb9sdgNeXNsJsySBrPhlCMkNp4XHRFTjQAP
	oafvZrjSKDmZ0gdxcOzuApNv5YD0sIReaR+oxsbM5St2epMsLqCvj51jIudiII0yzvgUfA
	LxXFwGDmoooxvbLqOOtDYpj+6IjaCK8=
Message-ID: <c12338c1-b39d-4cc5-80e2-03ced05168bb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784883422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PNHjK+/JGmMsSbCYCMJWygTh1XzjGhubS/Qib62Lnjk=;
	b=qlQJL/gn5rJBc/IMw2KZPnUQAINlqiE87xelpStFVuECZ4i9cTMPSWq5APX4caYZFxON9+
	xJf3i5YRIWOVE8jwGLezx9B2+SJ/3s84S/UGV42e9Qayz2bz0jA6FmahgZfZiz6KZ/ED2y
	rjhOWzsUZOk9VwEDJz51ATTx1vc9YZY=
Date: Fri, 24 Jul 2026 16:56:41 +0800
MIME-Version: 1.0
Cc: cui.tao@linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
 Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm/vmpressure: scale the vmpressure window with machine
 size
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
References: <20260724054305.516126-1-cui.tao@linux.dev>
 <amMPWbcKoXQ1Mxjw@lucifer>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Tao Cui <cui.tao@linux.dev>
In-Reply-To: <amMPWbcKoXQ1Mxjw@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 992DB100004
X-Stat-Signature: y8scnyyuf1x7mgdnk6iusxizgebd4iep
X-Rspam-User: 
X-HE-Tag: 1784883424-182188
X-HE-Meta: U2FsdGVkX1+3TLIvrk+yAgENjdfEZagnJpAiN2F9uZ0POZxNVAkdflq3sopOahAfaxdhTzBmUC5jadbk+SoQzdJb4nw9LLroLcGuDP7CUXMpyK47cu5I880YYHJJjuL6xHk/jQrRa6P/dJnsSWzPzmxtHP4wq7e5xwmBqOFb5gGv9EzPpjieXmsd0k6eEa58MoZzS0q3cj6Tkwsd+5K9Oxc0FPrLxEFD9kZIOV6iSUj9Yv/wTAJXoUeasIW8PvBdZzAIta4tBnoQyDtuL4fCLVgjERMOUBS3BDvMst6HKliUsuxgni/x34eOlah3fC8pa3Vs6cAcHjMFJhzmSwogOsxsgB/ji68qb16w5N5W/fO1Noc+jEiHSwbibp/uaHl5g/jrGQZvVk5Cf3zPTh5MjZTomcd9QoOwIpcgBBhJFv4MTB0B0Pxqjh7QeRM5vtcV7aOyS8Ma3wOaa+h8MqJn36e5b+34FqdXqQk2kvWS+7MqCJqhlSos08T3k2Lvjs0SYtFaiPLEoDb+xplGkkT5zyeo4y76Tg/MaCcKOdqwpUUvrWJFl0ihMmaBca0xuV578AW0aXBa5SRPK7Xo/J/w3PUozgBt/lnqEB36ElMQW0pS0Hn5A/KzqudcPHNW0cxyvPzTWw6WLyTOnzyw53BCle7rw2hNDT2cQQiH2Zts0QZW0sU875HrVdZ/NBdHhdGDAkFXv6+sQltGJDjlCpkJtHQz6yg85r3kIo6aRzn0R96PCw8PA7YzmubVxPsjXzHIv1SdJQXo2pcif79p9etxwaiPoWkyUM/Okgev5emA305JD6absjG8XTQDBw0IIz/GIvfTnNLXDoOj8ZvyA04MLUOcxLB+mh2QOQtrC0KT4MIy+2ljATSsJWDmnmrLRk/bUy15fsbhnkwEYrA9ulz65kZiWUw9w1MaZeJIvHn286nyTwMR2NyUG0KG1qjW5vGZSEOtxYM6ZjLfVJgODuV
 knZXB6Yu
 VYMqAtbw44HzFOYglDdib6hP+iwuyDPwsMIIc3upBLIi5rULMuoBQeeMDUOVJd+L41RwXG3oQXDZIl1lneYmjh55GoewfznldU+YI26ZIYC0zua4zvt13nbn3i5XPaTS6ekq8uA/KpotD+HivSbJBKEWJLKMdq8CMzkMT6xznEP+wZj+tWyZtXWkpxVtZ3E8G9JhKGV0x95icXaLK3g1HqfKhAxuU0/Sn4PF3H6ZQwQzF7euI4DL0b7U3O1EYgyMcQIqWaTVfcIytTwwL0Q8Gz5A7M/CllM4AyOvX36dusKfBmQeMLlSAhVw/1JrqzsWD0TF/xOOqMfFIKF9gLdd7zOs2WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

	

在 2026/7/24 15:30, Lorenzo Stoakes (ARM) 写道:
> No thanks.
> 
> Firstly, a change like this should be RFC, especially from somebody who has not
> established trust in the community yet.
> 
> Secondly, this is more or less identical to a previously rejected patch ([0]) so
> seems to be plagiarism since you don't reference that at all.
> 
> Thirdly, this is the 2nd time I've seen a submission copying that patch
> unacknowledged (see my response to the last one at [1]).
> 
> I suspect actually that you're not plagiarising here but rather sending
> unacknowledged LLM-generated code in violation of kernel guidelines ([2]) -
> since the TODO must be a pretty obvious trigger for agents generating this
> patch.
> 
> But regardless of which it is, this patch is not welcome.
> 
> Thanks, Lorenzo
> 
> [0]:https://lore.kernel.org/all/20260227221555.29969-1-mcq@disroot.org/
> [1]:https://lore.kernel.org/linux-mm/aljYxLusTzZkTfnH@lucifer/
> [2]:https://docs.kernel.org/process/coding-assistants.html
> 
> Sorry but no - this is a subtle problem that requires expertise and a strong
> argument in favour with data to back it not... this.
> 
Understood. Thanks for the review, and for the pointer to the earlier
patch [0]. I should have searched for prior attempts and referenced it
rather than sending this; my apologies. Withdrawing it.

I've read the coding-assistants guidelines [2] and will follow them going
forward.

Thanks,
Tao Cui
> On Fri, Jul 24, 2026 at 01:43:05PM +0800, Tao Cui wrote:
>> From: Tao Cui <cuitao@kylinos.cn>
>>
>> vmpressure_win -- the number of pages the reclaimer must scan before
>> socket pressure is re-evaluated -- has been a fixed 512 pages (2 MB) since
>> vmpressure was introduced.  The reclaimer scans more pages on a larger
>> machine, so the window is reached far more often there and socket pressure
>> is re-armed every handful of scanned pages.  The comment at the definition
>> has asked for the window to scale with machine size "as we do for vmstat
>> thresholds" for over a decade.
>>
>> Scale it the same way calculate_normal_threshold() does: logarithmically
>> with memory (fls of memory in 128 MB units), computed once in a
>> subsys_initcall once totalram_pages() is known.  A machine under 128 MB
>> keeps the historical 512 pages; the window then grows by SWAP_CLUSTER_MAX
>> * 16 per doubling of memory.
>>
>> Why this matters: the scanned/reclaimed ratio that drives socket pressure
> 
> "Why this matters"... oh I wonder where I've heard that kind of phrasing
> before...
> 
>> is averaged over the window, and the window rate-limits the evaluation.
>> With a fixed 2 MB window the evaluation runs the same number of times
>> regardless of machine size, which is disproportionately many on a large
>> machine.  Measured by cold-booting one VM at each size and running the
>> same cgroup-bound reclaim workload (so the page count is identical across
>> sizes):
>>
>>     config   scaled_win   pages scanned   512-win evals   scaled evals
>>     4 GB     3072         11.9 M          23267           3877
>>     8 GB     3584         11.9 M          23306           3329
>>     16 GB    4096         11.9 M          23281           2910
>>     32 GB    4608         11.9 M          23268           2585
>>     64 GB    5120         11.9 M          23281           2328
>>
>> For the same reclaim work the fixed window evaluates ~23k times at every
>> machine size; the scaled window evaluates fewer times the larger the
>> machine -- a 6x reduction at 4 GB growing to 10x at 64 GB (and the
>> logarithmic growth continues: ~11x projected at 128 GB).  Each evaluation
>> takes the per-memcg sr_lock and may write the socket_pressure seqlock, so
>> on larger machines with more memcgs under pressure this is real overhead
>> the fixed window pays needlessly.
>>
>> The default stays 512 until the initcall runs, so early-boot reclaim is
>> unchanged.
>>
>> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
>> ---
>>  include/linux/vmpressure.h |  2 +-
>>  mm/vmpressure.c            | 20 +++++++++++++++++---
>>  2 files changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
>> index b4d13457bc2a..09111f5bdc88 100644
>> --- a/include/linux/vmpressure.h
>> +++ b/include/linux/vmpressure.h
>> @@ -51,7 +51,7 @@ extern struct vmpressure *memcg_to_vmpressure(struct mem_cgroup *memcg);
>>  extern struct mem_cgroup *vmpressure_to_memcg(struct vmpressure *vmpr);
>>
>>  /* Shared with the v1 vmpressure block in mm/memcontrol-v1.c. */
>> -extern const unsigned long vmpressure_win;
>> +extern unsigned long vmpressure_win;
>>  extern enum vmpressure_levels vmpressure_calc_level(unsigned long scanned,
>>  						    unsigned long reclaimed);
>>
>> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
>> index 9629240d77ad..4c8671273c79 100644
>> --- a/mm/vmpressure.c
>> +++ b/mm/vmpressure.c
>> @@ -31,10 +31,24 @@
>>   * As the vmscan reclaimer logic works with chunks which are multiple of
>>   * SWAP_CLUSTER_MAX, it makes sense to use it for the window size as well.
>>   *
>> - * TODO: Make the window size depend on machine size, as we do for vmstat
>> - * thresholds. Currently we set it to 512 pages (2MB for 4KB pages).
>> + * Scale the window with machine size, the way vmstat thresholds do: on a
>> + * larger machine the reclaimer scans more pages, so a fixed window would
>> + * re-evaluate pressure every handful of pages. The scaling is logarithmic
>> + * (fls, like calculate_normal_threshold()), keeping the growth moderate.
>> + * The default is the historical 512 pages; an early initcall applies the
>> + * scaling once totalram_pages() is known.
>>   */
>> -const unsigned long vmpressure_win = SWAP_CLUSTER_MAX * 16;
>> +unsigned long vmpressure_win __read_mostly = SWAP_CLUSTER_MAX * 16;
>> +
>> +static int __init vmpressure_init_window(void)
>> +{
>> +	unsigned long mem128m;	/* machine memory in 128MB units */
>> +
>> +	mem128m = totalram_pages() >> (27 - PAGE_SHIFT);
>> +	vmpressure_win = SWAP_CLUSTER_MAX * 16 * (1 + fls(mem128m));
>> +	return 0;
>> +}
>> +subsys_initcall(vmpressure_init_window);
>>
>>  /*
>>   * These thresholds are used when we account memory pressure through
>> --
>> 2.43.0
>>
> 
> Cheers, Lorenzo


