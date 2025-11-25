Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B54CFD36C
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 01:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4CD46B0027; Mon, 24 Nov 2025 20:31:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25836B0028; Mon, 24 Nov 2025 20:31:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D612A6B002F; Mon, 24 Nov 2025 20:31:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C47036B0027
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:31:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 710F61605F0
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:31:23 +0000 (UTC)
X-FDA: 84147401646.15.02BA33D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id BD9621C0007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 01:31:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OXgJojMQ;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764034281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E/7Q0+NNPU1ugUqXJ8My1rsvUBzyDEgTTxYG70tvPiM=;
	b=kraCwDu8ruH1eWTKZWsO2K39fY1xeMu8jxITG6V+s/uaaSPE0P+B48aYKTvErdyaVrvRFx
	7sWz2Au1MYWQTDKmTszyvsZqqEtdDn1tR9b9B2PKsLrN58L5rYCsx4hjsdn5/P/RD42+OH
	FZdRtSH0Bd4IO4C5srX6EFEMQceoE7I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OXgJojMQ;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764034281; a=rsa-sha256;
	cv=none;
	b=X25mrAUBgGeVAWsRBBh1kgEp8KP5EXaE9Luhw3ySzOrzYLxHqFVeskepdgeXHFWe04BP4V
	rc271odNgA1B/zgsKhlCi+pHGA0tcao9pXvZmqyi5xmSoAEDZs1vx76UmseE/s49Pvqooi
	usOHuPXteV5cPMvcfn7u3jCywaCgjtc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=E/7Q0+NNPU1ugUqXJ8My1rsvUBzyDEgTTxYG70tvPiM=; b=OXgJojMQJNDU0TprFLXGDym2iO
	6WG9AIzLRbHv0FuWoA7ilSC/hXp5OCP2zQTMAJA5E00EJZUcCV7dcy1kLV/dPHnc5eDZztPKWLcWz
	GtQbboadBg3nSefp9+3x3iPPnYRA+Px7MeuY0RHgS1KXGaP7brmvcng1hKvuQ3CMDwaAXprTbjTzV
	HlH5M2a2S7FnBZJ8uBZImyIqxcJrUpl+GZC16nNoqTDS1U9psmIbcMjPINuiA8bZL4ZaZCfG3pS37
	VbriFWzu/49aAlsnrevclTkEeONtdWxRateMHZcbzEUkmkRyYv6mrv1OaCpEevmigLfwLWig76aAp
	cmjalnMw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNhth-0000000CZ79-1tqo;
	Tue, 25 Nov 2025 01:31:14 +0000
Message-ID: <5d7a305e-d6b6-49dc-ab1d-bddd1339d4a7@infradead.org>
Date: Mon, 24 Nov 2025 17:31:12 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
From: Randy Dunlap <rdunlap@infradead.org>
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, xiaqinxin@huawei.com
References: <20251124200811.2942432-1-smostafa@google.com>
 <20251124200811.2942432-2-smostafa@google.com>
 <7854489b-bc9e-4bb9-a19d-cff96badc180@infradead.org>
Content-Language: en-US
In-Reply-To: <7854489b-bc9e-4bb9-a19d-cff96badc180@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BD9621C0007
X-Stat-Signature: 8q8bnjry9t1zniioha5zry3ii99d7k3u
X-Rspam-User: 
X-HE-Tag: 1764034281-783959
X-HE-Meta: U2FsdGVkX1+pY+l1YqrEqIiASQPtLxgBxlqVfGz3Tj7ONSjB03Hbgr/+ZM5xLNGkgd9MNjlXm3n+VSD7KWFFyUloy4RPDMW/xBEp3Ax/vw2IqMm9KRjV+XQWZI9bHAt8fBvMXjFA2zR37dohJ79AVi3mYKu1ZM5UXxEhUTWThHh5Cb4Q6YutzF0Oq9maHKzm62odpjv+RFjKPHhDp+cTXxUYDn2nkPkrm+n9rqAQC/XJqqEg1bZiZ5zS52CzhgrEF3Mjon2TkPwjVSeZjwJGj2el4Ty8ohNqoEJJmGiuH8wcCWqUIExleqmWs6pHdZQSUJZi1ppfXJnDBToYKEQ6bYkYc4hj1iprbSN9DGq337DaOPEpJ9ELiU+hJtefEXZmzH6Nz4KIDTHfC97x0Wg/dRoEfjCLd3wWmwNNfqXQ77U3t+PsX1zupLrz3EyhOtOB77GvT1NcQ562D+AFDYygRvttEG2yii2jtHPg3yaFaPK5BCW17jhmUC7BtIgT4GDIxJ9VOLoM1hD3hTFWF/nLhem/DMfRyGg82aSS1ea8YbCEhIgRlO+8CIG15TA9XBGt7WkpGb5OoNCo1V6nC/zquSt1RcM3E5SQKul/fBWcjDwlwZtuyot6SsyHxWpq/pQDJBXqHLOhk7TvqWnuKBQBdGJPsTbaDOAMsYuTFdR2b1D1A7/mjR17IPgpCIyd+AnrfKr+nwc1oDJOM/sS0aI6zcC7mXsSmbwfv5R859ob28YUSrSR99ggK50OOSVN/jerJYDmGeRMpEO1f/8aNlXyOVH4kCK3J1Lk5I4KR0dGJNZJchFCdpMsjHsQocU/v1G3Yi58GC5XxjI2HakXxPvMBPHH07xrSQ6Ex4fZ2RMYn5yZxShsosoxxI1CXI39O/oit/3MNlrkyhuo+TkgqKLMEkm/uCgdenB6AKQGVHTbFwk8KOiP7RdbKBV89O9bookOPCMNUdGbMl8RDbypQPY
 DiBDA4yj
 GSxIYbioO4I8uVFLmX+IUOXrDcfkVUlGEvxqrQvEnviS0LoZdHTudCCQFPLQLbY0ORwersfUI8LV6o9MRInbx0uVfI7NBvRRKicQIDPJseWlrF8Ot3UqNGc4zB6L8nRby/wyNBwf76QnzT4DqJqNYPa6WarH2OgSHId4bNqvu2kDpoWUFJ93mNL7bpVu+XPfemGy97Uq/m+4d8cyUnjDed3kWYj4ViZuxIHdTNC78faAcf946u6YMBKSyXeD4qGOsApNSmYfzqQ2npnubs+qGkANtu/dO+pi5EOkN7X3w+AhaK5yl9Sxmmb9Eer9Wwep0MDl9UgRZOu3nGddUbZHa6uFMnPGFrcvTu/NUyenpsK8OhS4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I missed one other thing:

On 11/24/25 3:13 PM, Randy Dunlap wrote:
> 
> 
> On 11/24/25 12:08 PM, Mostafa Saleh wrote:
>> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
>> page_ext.
>>
>> This config will be used by the IOMMU API to track pages mapped in
>> the IOMMU to catch drivers trying to free kernel memory that they
>> still map in their domains, causing all types of memory corruption.
>>
>> This behaviour is disabled by default and can be enabled using
>> kernel cmdline iommu.debug_pagealloc.
>>
>> Signed-off-by: Mostafa Saleh <smostafa@google.com>
>> ---
>>  .../admin-guide/kernel-parameters.txt         |  6 ++++
>>  drivers/iommu/Kconfig                         | 19 +++++++++++
>>  drivers/iommu/Makefile                        |  1 +
>>  drivers/iommu/iommu-debug-pagealloc.c         | 32 +++++++++++++++++++
>>  include/linux/iommu-debug-pagealloc.h         | 17 ++++++++++
>>  mm/page_ext.c                                 |  4 +++
>>  6 files changed, 79 insertions(+)
>>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>>  create mode 100644 include/linux/iommu-debug-pagealloc.h
>>
>> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
>> index 6c42061ca20e..dddf435a1c11 100644
>> --- a/Documentation/admin-guide/kernel-parameters.txt
>> +++ b/Documentation/admin-guide/kernel-parameters.txt
>> @@ -2557,6 +2557,12 @@
>>  			1 - Bypass the IOMMU for DMA.
>>  			unset - Use value of CONFIG_IOMMU_DEFAULT_PASSTHROUGH.
>>  
>> +	iommu.debug_pagealloc=

Please note what format the option parameter value takes and possible values,
like iommu.passthrough above here in the kernel-parameters.txt file.

>> +			[KNL,EARLY] When CONFIG_IOMMU_DEBUG_PAGEALLOC is set, this
>> +			parameter enables the feature at boot time. By default, it
>> +			is disabled and the system behave the same way as a kernel
> 
> 			                           behaves
> 
>> +			built without CONFIG_IOMMU_DEBUG_PAGEALLOC.
>> +
>>  	io7=		[HW] IO7 for Marvel-based Alpha systems
>>  			See comment before marvel_specify_io7 in
>>  			arch/alpha/kernel/core_marvel.c.
> 
> 

-- 
~Randy


