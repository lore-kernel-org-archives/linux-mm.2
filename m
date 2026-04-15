Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C80F419A0
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1A626B0005; Wed, 15 Apr 2026 08:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3EF6B0088; Wed, 15 Apr 2026 08:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6B9F6B0089; Wed, 15 Apr 2026 08:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C13876B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:46:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655911A0459
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:46:59 +0000 (UTC)
X-FDA: 84660764958.08.F9DA617
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8327F140012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:46:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776257217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m8Qfzje9Ys38BxnEedRsQaKiiSGjBGmbk7x9cFRpK7c=;
	b=jtcnwHI04zL4wIlYFtCjvNk4YpaDC63NfxAv7WH1HpkXBJGAaRRQpUwRDir6iFqlXg+tUy
	5QAVh4xakni/rwyjVqGkMG+qy8bOTlhX3kUfUXfroxYDO/acwcVg7IJSquwrpdQxOh9ZPE
	zbVsu6hW8awYjabiMRW5a/LC/DSSlLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776257217; a=rsa-sha256;
	cv=none;
	b=VdHw7zB0hmw/DJn/GoPzffJBhFRtpD/nWdzvKyNreueCWCbKUkxR0b/pQx0qkqjPjkfK0H
	DrStFi+1pKjU7UFqvQkTQ2Qc57cYCaKOq+RQsH9dMbZhu4heeqHa7GZZBzyrg9cw+Ku9Os
	QH2tx2NSQB1FbgxhbzvvLl2decRNn98=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwgqh674lzJ46ZW;
	Wed, 15 Apr 2026 20:46:08 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id F008440569;
	Wed, 15 Apr 2026 20:46:51 +0800 (CST)
Received: from [10.123.123.226] (10.123.123.226) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 15:46:51 +0300
Message-ID: <54b4144e-57fb-446a-b28e-aac4390cb503@huawei.com>
Date: Wed, 15 Apr 2026 15:46:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] filemap: use high-order folios in filemap sync RA
To: Pedro Falcato <pfalcato@suse.de>
CC: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <Liam.Howlett@oracle.com>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<artem.kuzin@huawei.com>, <gutierrez.asier@huawei-partners.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260415192853.3470423-1-stepanov.anatoly@huawei.com>
 <20260415192853.3470423-3-stepanov.anatoly@huawei.com>
 <3cr6ppe6bic47tan2iapuh67s67hiroangvdiap4jbn7ypru2o@rbvqv3sxifwp>
Content-Language: en-US
From: Stepanov Anatoly <stepanov.anatoly@huawei.com>
In-Reply-To: <3cr6ppe6bic47tan2iapuh67s67hiroangvdiap4jbn7ypru2o@rbvqv3sxifwp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.226]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam12
X-Stat-Signature: pyh9pj7yr3b495tzexaftxhhhru9ucfc
X-Rspamd-Queue-Id: 8327F140012
X-Rspam-User: 
X-HE-Tag: 1776257216-211757
X-HE-Meta: U2FsdGVkX18yZj+vFoKH4JGp28Jg65JV2CpywhLSk/mjDNobKpBi4gtEeF67RVgmHC8+L6FS6K0+hM5yBGnC07q1Kz++zQ5gbawCxtHi/6TsjqvydNqpJugM1K0+MGgUra5nRlIFwHifGfhoRbaxZmuVolgDlbM4VjqlAlgKbr8wESxmIthfU8grWJgzDB9wGvp+aY9kN9K6rI+vqcUuUcfwUb1A5pXomxh8t+KCo5wnItkF8K3BB4rKJDXBAVl2sBBT/tUf+VChkF1jQGtnn91ERf6mksctDFXgYzXhnlBpZk6gDgOBiGpkMRJvJxPIYJjbx1U7HVneJawmYTsgaGH4XyLDw540O9YAqRg/Xmu/H2EX4spojRkVuM7SsD51PIqMM9n3FucFxKv2LY5vKD0UHvx2l81KpI21mKrivQFuhgkN/ubz71nZFY5xE9oQi7UQqHskFZJ5tEibwVkpcJSTGe2zMue2vhbv4XecRnUquWrBfyFy5TshvU4vHnTKVKUls7TwQoTzRKWXRcnLlr3RY8i54KcPnDI+6WOfsf8sKXgNWvzSKcBr+TaAAHgMbqwLZRYDVxShps9WgvYLHDQskyQSFpew2Cfcxuz0wnIauk9j26YUlAYu1C8k3OK5z9bGeMkOut8on7dPc4w2I1wEIim/16gvZG06zTi7hNFaiwhtZV3rMMoZIggrg+rHbHuWOJ5JrdimV5jCjuUUR2qi4RN+YN2wxvIZrYQHcnjnrUIFd7jQFUGz4iDEJDpIDpQo6RcQNS80GzdNOR0351/lPJ7U+giOAlPVA1slpLgVl6n2jma9XmF8ywd7QZF5M4D0eNL2uV7NeDdf4JqRiHv7xsVj4rBpmchI64wdvOdzN2MrsPIsv0Eo5NB/dR6kHmhX9WVRZG8hGna06Nhg55X93371am4QWVgxks8oODB4MTzhTheFl4yTsHXYIs4JV2Owc1IEpTgWryG5I8k
 jeYDxzeT
 yUYLOprOyvgMiYx0EZsCZ+FAKBdRZskPlZplkEZmehyQb941omA0IGHrqjjgd6zKJZnKtIY9cDy85zsJNg8Bsty/78Q1JTY5hWoIkyY6YcC6tCDH0rfvm/RnqGVZhIh9KR/EZuMFpfG+jMCcFEexZ0Yn8aOr3Hmyvn2i+pLfGsETjqI7+49+r5yv2UQYcB5qd0gEStGlwKA305gopBbSJbVC+Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/2026 3:06 PM, Pedro Falcato wrote:
> On Thu, Apr 16, 2026 at 03:28:53AM +0800, Anatoly Stepanov wrote:
>> [Idea]
>>
>> If a mmap'ed file being accessed such that async RA never
>> kicks in, we might end up with only 0-order folios in the page cache.
>>
>> if fault_around_bytes is larger than 1 single page, then
>> it's beneficial to use high-order folios, which brings significant
>> filemap_map_pages() speedup.
>> So, let's just use fault_around_bytes as a starting point here.
> 
> Well, this heuristic looks arbitrary. I don't like to mix different concepts.
> 
> With this, in practice most file folios will be 64K. Why? Why is it related
> to faultaround when faultaround is a separate mechanism that isn't particularly
> relevant here?
> 
>>
>> if an arch supports PTE-coalescing we can get more of those for free.
>> (see arm64 example below)
>>
>> We don't save the new order to "ra->order", so if async RA will happen
>> it would normally start from order-0.
>>
>> [Things to be discussed]
>>
>> But at the same time, i can see drawback for 16K, 64K pages, in this case fault_around will still be 64K by default.
>> In this case, it seems makes sense to make the fault_around_bytes be like order-N of PAGE_SIZE, not fixed bytes number.
>>
>> Another issue is - when fault_around=0, but we'd like to use high-order folios for sync_RA, for cont-PTE for example,
>> For this we can use kind of "max(fault_around_order, cont_pte_order)".
>>
>> Or introduce some dedicated tunable like "sync_mmap_order".
>>
>> [Benchmark]
>>
>> Simple benchmark below reading 100M file in 4M (RA size) chunks
>> such that async RA doesn't kick in and the page cache ends up being
>> filled up with 0-order folios.

> 
> Well, the problem is that you are _never_ getting RA to kick in. Folio
> size is the least of your concern, you are effectively not doing much
> readahead since the kernel thinks you're doing random accesses.
No, that's not true, "sync mmap readahead" actually works in the case
the problem  is that "async RA" doesn't kick in. 

>>
>> The patched kernel gives ~3 times increase in throughput,
>> considering the page cache is filled up at the moment.
>>
>> The main speedup comes from filemap_map_pages() due to high-order
>> folios usage.
>>
>> As a bonus, we get better cont_pte bit coverage for Arm64.
>>
>> Example:
>> // Open 100M file and read every 4M chunk, given max_ra=4M
>> // Perform 10 runs, measure the throughput.
>> ...
>>  char *map = mmap(NULL, filesize, PROT_READ, MAP_PRIVATE, fd, 0);
>>     if (map == MAP_FAILED) {
>>         perror("Error mapping file");
>>         close(fd);
>>         return 1;
>>     }
>>
>>     struct timespec start, end;
>>     clock_gettime(CLOCK_MONOTONIC, &start);
>>
>>     unsigned int size_4M = 4*1024*1024;
>>     unsigned int num_reads = filesize / size_4M;
>>     volatile char val;
>>     for (int i = 0; i < num_reads; i++) {
>>         off_t offset = (off_t)i * size_4M;
>>         val = map[offset];
>>     }
> 
> This doesn't seem like a real issue. And if it is, you can always issue
> readahead manually. But the whole pattern of "every perfectly-sized RA
> window, access 4 bytes and advance" is completely bizarre. And _if_ this
> is your workload, then having order-0 folios at the read site is much better
> than filling your page cache with data you are not accessing.
> 
> Do you have an actual use case for this? Where have you observed these
> problems?
> 


-- 
Anatoly Stepanov, Huawei

