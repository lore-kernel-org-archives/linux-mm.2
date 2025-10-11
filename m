Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 773C0CCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 09:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D13E08E003E; Sat, 11 Oct 2025 05:09:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBE48E0005; Sat, 11 Oct 2025 05:09:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C293F8E003E; Sat, 11 Oct 2025 05:09:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B12838E0005
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 05:09:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 61851879B3
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:09:26 +0000 (UTC)
X-FDA: 83985259932.03.3950504
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8899E140003
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 09:09:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MEAzV81d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760173765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ro+Dc7WyqU/UiRkMuFCkVqn4KXP2e3oEFRnHobzOqKU=;
	b=IqyLQkJZHKPYhD7ne36DTaCLX0+OnTrCmG624mGyw325AeSGuu15+vU7pupsWxzigafKn1
	6XJioEcRaUc5LjIlnHI4H/YkdqpmOrPKDhkNynLfKfIJ7GRJs516llnW1MDTxPafQ3O+5E
	WOYY4SweZ9G9erTdVip7JrjVSdMq7gE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760173765; a=rsa-sha256;
	cv=none;
	b=xa5YG/IZOV3taOzINB/iBdbZ3FN0kYIFEQ0RVPEU+7RYBT74SXWuLnjKKEjowZNTbSvfc3
	EAR82tV4x9wqlfETXnNYVhYeDFnEMu77RQm/DPdCzJmwYGfOm9OACC4+PSJjjaGb2hdgiR
	7zO12/mHfXUTa3ag5xahv0LC1DC2sXE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MEAzV81d;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <ba6767a4-8211-45b0-bf37-5a0bb303866d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760173761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ro+Dc7WyqU/UiRkMuFCkVqn4KXP2e3oEFRnHobzOqKU=;
	b=MEAzV81d3jpuc6iCH8cytejEyMFYxaPwwDFwfc2hBhOzNd9NCQLsx+wNdMr97gGTkIaHDo
	2Z2F/EGxSIKPdnUhoT9y0SO/Q6doTwmS22+PRezhNBdYudJ+3CwOJypgjG5bxFYole85Vi
	ym9kGF0qUmfBaNGw8rssozyq866zFU8=
Date: Sat, 11 Oct 2025 17:09:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm: prevent poison consumption when splitting THP
Content-Language: en-US
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lorenzo.stoakes@oracle.com,
 nao.horiguchi@gmail.com, farrah.chen@intel.com, jiaqiyan@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, tony.luck@intel.com,
 linmiaohe@huawei.com, david@redhat.com
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <20251011075520.320862-1-qiuxu.zhuo@intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251011075520.320862-1-qiuxu.zhuo@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: qg5o7grhq91ek73nci7gpmmxj1j7bg4r
X-Rspam-User: 
X-Rspamd-Queue-Id: 8899E140003
X-HE-Tag: 1760173764-881930
X-HE-Meta: U2FsdGVkX1/ulPSsSkkGp/YvhGV1rq/nk7DLFDSArLTNLYSYjQZHk08eoSJqCDo+XZLSU7l7XM2hPKvZkW1NDXZJsPXiIKtEUurqby1ofTdFv2GvBw9Urmr2JhgdqEKTt7p0LiSPZbvYmveZiXMp1vj1gY43kEdEMOLUAHy8HDND2jfJeYlgPSmIuE2MfDjYXduCqlWNVc0SEpFMf2npLx0iRcFa9R/5U/uaiMVt4BqBxNf/eCi56szByX8MqxTdD/LXOU1FyTalo+YcWqvL8KUx9xgzUzH/byhRbza3H3bvn/0SioGTqsrSulEM9xRu02Se+4gi+QgRi5vQoi9ZIcukmybxzW8+xn6BnDmnAEo/EkVcqZyT8fbjzSX9WK04ANeCd9tQuJNOqhgjy1AdGVpr0lRZ3MUFB704nG9xtMQwjQvMLAOZPteuuAEBKle99FVSL935AbJtDCbrjBYI30iJxIs3P5704YYFwa5kxawSC2b43SBofvgCGEIxU3BK3fuazMhw1yoK9ZNismZseH4HnhSxoHnxoZBekF7GRT2xKlCKt+LE+3IMzW0C6v+QVD2m9ubMLAQ3GGl3Zdg8iBHbQwApExaT3WEXO7XqBKJ5fZqQOY7cxz/hyWKpTJiva0gMRuun+gADWytqli8VAnbV0U0kpJizSrVihf90td+LRZZvNr2W9hurqDbyoOZt1LUWT0xX9XH7SIveOF4E+gGyHYL9W23J+ywcyP5Nu1XtihIj3f/z5ZqpmhwzssPnAJjqEM9bZ6rjWxzYlupZXKvt3BkRyWFMp0DYhak+IHE900vZrhRrVP6CFDsk1aB7qfwYjGwTKHLYOPRsTgzWY7R9GdomMJ7C1ozudWPguDHYpVxtCRrlC9UzB8pr3g3JVJuyRmMX6dgM4mYjmuhd0wmQxXT2SJEevfHLCuudGRWOkyuNQYkzK4LpjoRXM1xY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/11 15:55, Qiuxu Zhuo wrote:
> When performing memory error injection on a THP (Transparent Huge Page)
> mapped to userspace on an x86 server, the kernel panics with the following
> trace. The expected behavior is to terminate the affected process instead
> of panicking the kernel, as the x86 Machine Check code can recover from an
> in-userspace #MC.
> 
>    mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
>    mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>    mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
>    mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
>    mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>    mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>    Kernel panic - not syncing: Fatal local machine check
> 
> The root cause of this panic is that handling a memory failure triggered by
> an in-userspace #MC necessitates splitting the THP. The splitting process
> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
> reads the sub-pages of the THP to identify zero-filled pages. However,
> reading the sub-pages results in a second in-kernel #MC, occurring before
> the initial memory_failure() completes, ultimately leading to a kernel
> panic. See the kernel panic call trace on the two #MCs.
> 
>    First Machine Check occurs // [1]
>      memory_failure()         // [2]
>        try_to_split_thp_page()
>          split_huge_page()
>            split_huge_page_to_list_to_order()
>              __folio_split()  // [3]
>                remap_page()
>                  remove_migration_ptes()
>                    remove_migration_pte()
>                      try_to_map_unused_to_zeropage()  // [4]
>                        memchr_inv()                   // [5]
>                          Second Machine Check occurs  // [6]
>                            Kernel panic
> 
> [1] Triggered by accessing a hardware-poisoned THP in userspace, which is
>      typically recoverable by terminating the affected process.
> 
> [2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().
> 
> [3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().
> 
> [4] Try to map the unused THP to zeropage.
> 
> [5] Re-access sub-pages of the hw-poisoned THP in the kernel.
> 
> [6] Triggered in-kernel, leading to a panic kernel.
> 
> In Step[2], memory_failure() sets the poisoned flag on the sub-page of the
> THP by TestSetPageHWPoison() before calling try_to_split_thp_page().
> 
> As suggested by David Hildenbrand, fix this panic by not accessing to the
> poisoned sub-page of the THP during zeropage identification, while
> continuing to scan unaffected sub-pages of the THP for possible zeropage
> mapping. This prevents a second in-kernel #MC that would cause kernel
> panic in Step[4].
> 
> [ Credits to Andrew Zaborowski <andrew.zaborowski@intel.com> for his
>    original fix that prevents passing the RMP_USE_SHARED_ZEROPAGE flag
>    to remap_page() in Step[3] if the THP has the has_hwpoisoned flag set,
>    avoiding access to the entire THP for zero-page identification. ]
> 

Thanks for the fix!

But one thing is missing: a "Fixes:" tag here. And also add:

Cc: <stable@vger.kernel.org>

> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> ---

Well, I think this fix should work ;)

Acked-by: Lance Yang <lance.yang@linux.dev>

