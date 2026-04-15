Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0E8F41998
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 12:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB84D6B0092; Wed, 15 Apr 2026 08:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69936B0093; Wed, 15 Apr 2026 08:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EF86B0095; Wed, 15 Apr 2026 08:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A37166B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:31:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3FE0EC1C0F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:31:16 +0000 (UTC)
X-FDA: 84660725352.22.94EBE9E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3E6F28000E
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 12:31:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776256274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u4YxofDQ//EfYyt1OgVhS0xCBGGqyAgQ6K1TtBYqrdM=;
	b=uvg9/yN+9JSzct2CfJRssFIz3pXB/NpJcegDmoqCsuw6KCZKV3x0DNaNOvKj0VoL4A5Yp2
	+p+V71TOQkCmNb5ul+wUxd/JHweowlkoIZnz4MNBQyop18NMBijMtVHd0ids+VFZi9jIgO
	tDn3vHHRFP7hpAG7ehqpdA8He4xk0jo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776256274; a=rsa-sha256;
	cv=none;
	b=l94cBLdYXlg5QPZjN2oHmgCvYZ6CKwmEGnpa51ltLq0a6ZjS3jvwV+ESEehdmk/JGDHMCH
	ScV2HHDvO10lqoJkLlk3O+ZstSybQFymFzkQARLN4+TBH8HISsiztqnL57DS/nMDq6mX+q
	sevdZ5MlkwiOxxRp6QsJojzQYyTqWds=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fwgTX0QYXzJ46BK;
	Wed, 15 Apr 2026 20:30:24 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 2BB6E40569;
	Wed, 15 Apr 2026 20:31:07 +0800 (CST)
Received: from [10.123.123.226] (10.123.123.226) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Apr 2026 15:31:06 +0300
Message-ID: <e9033191-2f31-4d52-be17-a1e9fe0d40ab@huawei.com>
Date: Wed, 15 Apr 2026 15:31:05 +0300
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
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3E6F28000E
X-Stat-Signature: zy8nj969wie1tf63oqx94cqzgh8xfz73
X-Rspam-User: 
X-HE-Tag: 1776256272-996325
X-HE-Meta: U2FsdGVkX1+92oThm4b+qf17MRQjFLbHuwHCOgTCyh8IrP3G2BbCxlbjpjBlfUzdY7uCQlH7L/TDjJywWQuKmiLHXJKksYD3wMu6puBl7/g4r4HDGBsiWBy736cAFyBqvxcgb5zMvLHefg2o+PBE9UdBWOX38QVMs0kpUuADzZ3WU1l9HXV4wkhLpxiHRyzbieqRhqf5o9BONd6deTcJrTzurjkrpl1lI+jFs7PlSy+y5aPS7w8z+TpChkRtn5ODKb+b32YLoEd8AamzNF3S10GioaaZs11YRmRmth8KcKT3Q12mA/oy2Uq5Y1NNoEG73cTDwSkWX6CeDjIdWpvXsVtVyPXw9bm0q2CrzyKzCdF6bbC1k14Wz/kmg/WR/h57MG+yzGSms3LcBPG2wr9tyG1HoEsbzUs2tHp5ZKgZ9/TXn9lgVtOKrxlj38O51mJ095aZpwWR5dm427rKRZPgb+WO42cnLPsaNahL4b4mwmFBvogXZDyjKbPEOqnoF46CVCnC6KxpDGG6wPUBOdSw1bTeSzzZ0S+a+0Qq/3/fL8mb6zVAJuwjnRkj08qCI+fQK8N7VjI/mzqsT9GPYCoTF41T/S69DUiBewdoq51z95TKnYOXrsnEWdRCruEDwIGhvSrOW8EJgt1J3T1zf85lqMYuVMdjtWKt+YxDnzl2sT9LOwbwoI/OcntOWTc/XrF6l+WhSxjXfgDCZFHG7LgFm95yH0rcmSrpVKPpmo0xgs/+p/e3rTJU7z8x/jhamkTdyrtI/Y6cb8bxpYqzBPlbsoc7FveFgGvr21NVonMoBs0UvNxNltyx7r09Uubt2QUbTfnq/RDvJg+X00oUvPGdFhExru2ENDzf1fm0G5UinVDqJPaiyqDLbI4+dgCPcYZ6qBeQ8JzGokXjtHxp66u4Ry08Awqfwhww2e5TV7L4JtRT0XAVfi0zKDsycFIVqRWaw9syU7KuuhORvLwcyfo
 YHtX2A2v
 W3yLzwOWcDQ72XyeUrwNNKw/8YJ5+PFVepEg7XsEQkYSb5clu75NG6hyixR9HHhgtosQt5UIGTXs6gcMxkv0JZRMlCeF9I2h/hXc3TiQ1f68P6GM/7lI+wz4hAviTkGqxrj1weR68c4B//WjMGNBMt9RRCllR/9LA78Tw1mSWCe+q0jpuHKflE7Un72C1suXhYAVJaCZGrItaboH37/u2J6habQ==
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
fault_around_bytes > 4K means we need to iterate over folios in the page-cache
for high-orders it'll be faster, obviously, which is shown below in the benchmark.
So heuristic actually makes sense.

Regarding the value itself, i don't have perfect answer,
for instance for 16K,64K base pages or if the fault_around is disabled.
That's why i would like to gather feedback from community, regarding this.

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
This benchmark only intends to highlight possible case, when async_ra doesn't kick
and we can get more performance easily with increasing RA order.

> 
> Do you have an actual use case for this? Where have you observed these
> problems?
> 

If you're asking about real production scenario - i don't have such yet.


-- 
Anatoly Stepanov, Huawei

