Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C4BFD064E
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 133E56B0089; Wed, 11 Mar 2026 04:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FEBF6B008A; Wed, 11 Mar 2026 04:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 034D16B008C; Wed, 11 Mar 2026 04:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D521E6B0089
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:11:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B9EBC2244
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:11:48 +0000 (UTC)
X-FDA: 84533063496.10.3C55D2D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id C9F1510000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:11:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773216706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JAtuy9Tg4GtbuHvuyqKT6iCZycvzMtXiMyS7f9pUOoU=;
	b=GagV4x2fpibV/cyQWj/gb+TcHRCmlaYfWjWvH7nhMH6Byuf6c6ue+RZgOeTb2LIf4P28uj
	XGCt9SV7ELG1mmaMx/xmRat9MyZBUlQ8Iy2tJGQmho6t7QqG9sJHTPFDcEDeAO1wzvmEEz
	v2laPh4LLxAx/rK7trfZmqHgJW2NlUQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773216706; a=rsa-sha256;
	cv=none;
	b=JQo9cnqOWS5Ef2KfR+iQdS3eGCkKjvsNq+MWUXVdecQIrymtvys2y6YrAdxH34aPWDDRHJ
	MTrylLWz5BYpe/7nbcmLnanXbdAPc4fUIhyMlJS+uIEis95Fnx8rBQ9HteRId/riM9D1Nw
	rtOAkEyONTMPRJ4CjPpk+tGcjL67wW8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80C5E165C;
	Wed, 11 Mar 2026 01:11:39 -0700 (PDT)
Received: from [10.164.19.59] (unknown [10.164.19.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C08313F73B;
	Wed, 11 Mar 2026 01:11:37 -0700 (PDT)
Message-ID: <3fb1c538-e666-4bb3-b3f4-6f631f4db325@arm.com>
Date: Wed, 11 Mar 2026 13:41:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/9] mm/rmap: Optimize anonymous large folio unmapping
To: Lance Yang <lance.yang@linux.dev>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, axelrasmussen@google.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, bhe@redhat.com, chrisl@kernel.org,
 david@kernel.org, harry.yoo@oracle.com, hughd@google.com, jannh@google.com,
 kas@kernel.org, kasong@tencent.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, mhocko@suse.com, nphamcs@gmail.com,
 pfalcato@suse.de, riel@surriel.com, rppt@kernel.org, ryan.roberts@arm.com,
 shikemeng@huaweicloud.com, surenb@google.com, vbabka@kernel.org,
 weixugc@google.com, willy@infradead.org, youngjun.park@lge.com,
 yuanchu@google.com, yuzhao@google.com, ziy@nvidia.com
References: <20260310073013.4069309-1-dev.jain@arm.com>
 <20260310125940.39707-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260310125940.39707-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: uq3ciryr8hs1royzeejyrcfg6sefwinx
X-Rspamd-Queue-Id: C9F1510000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773216706-897469
X-HE-Meta: U2FsdGVkX1+fbmpsYhJkHRVmguUu1s4DwN/PaB6allKhryRDppoTeuUpXyLlrwgFikzWhcOuuBW/tgUuFhGr0DUL8xTymXhDSOIztfahqJ5VwpqTFzXluC8FhxAQ9n57MGcTUnCfKKUCWmeRz1lCnMNUketCy9QOs1zxyA9ZBlYICgMin+yM0gdDlNsj3f7nUUF1Gq2FClfZgPV7MN5TN9FL9MxUaqeUt805tFe0h1HrFxEpdaIPrJCSvzkL78CIVvpp2dyJcnNIsjK1HZ/Jqmb5tCtYZa18EI7LCYUwNbP0MuZlV9QpFM2gtii4cTuDjDJeliRtjmLtisVHup5fgLUNuWow6w1gJkhEHpxsGm7YPAcikvwzDdgBwlIIy3vHtqVIwdGY79P2l9iBNh3osALqwsFtGVYKCkS3kLpMuVzxKraqU3d+LrOXFaXWbZo7x24m54fNGUaSSO43fR67FHmggi0GuyADEAosRDe1BWsPyTj3BclFaB6uGcAFamuVWrfdcjV2EVpyxBCdj55GG5/ohzrkLVLafMn6mND5N73H4DqdyRgCnVHixkXTrR7pFi7Yaa/Ye2z40P+sHodmXOiXLAkpcwdh6ffNScmUSc6U3WCv8ap9NsT86P8/dLEI+I9iThJS4qzIJu5kuHQvAUqpoqk5Y9ODOLX1pY9ASNtFBKztClyZVCBFRJsg0i42tNJCO87G0M5ylJPmWMURc9n3hyvU8tkm/ojQGn7QbKorN1nWz0/7d6XsdQ/3gXmwgp5hDJ2z/V+CJbZNa7xMGZGFDlgdVy2dhqrSTLBtayQG2DGvZsgtbCCroG5tYCvYrCchR9CGRiA2Gn+WA/yXN9BZo+WOron90vLCCY5KR+Qm3hZlX3PAaBmAOiEzCZqXb6ohl9I6Fy3FsZtwyrrHcwiuWA4gaMuP69RNdP5Pd8vPPGQEPoIlN27No1kTQLMlSxsGsMc8bPfMWzEIM8f
 qxyCF4FW
 fUPfchrCm2j6TaJnmKmAGMbMDd//OqoHsSsv9bismgVpr11cAwtP5NfTflhxrHiyQ+tbKoIdsVqhmd/5iwJpb1gfACDKBMEoWw8BwmKz7zJbfl/eRnIGae8YDUa8B8nSnROH1SNeDj4P2vj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/03/26 6:29 pm, Lance Yang wrote:
> 
> On Tue, Mar 10, 2026 at 01:00:04PM +0530, Dev Jain wrote:
>> Speed up unmapping of anonymous large folios by clearing the ptes, and
>> setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry at [1]) is used to measure the
>> time taken to swapout 256M worth of memory backed by 64K large folios:
>>
>> #define _GNU_SOURCE
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <sys/mman.h>
>> #include <string.h>
>> #include <time.h>
>> #include <unistd.h>
>> #include <errno.h>
>>
>> #define SIZE_MB 256
>> #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
>>
>> int main() {
>>     void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>>                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>     if (addr == MAP_FAILED) {
>>         perror("mmap failed");
>>         return 1;
>>     }
>>
>>     memset(addr, 0, SIZE_BYTES);
>>
>>     struct timespec start, end;
>>     clock_gettime(CLOCK_MONOTONIC, &start);
>>
>>     if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>>         perror("madvise(MADV_PAGEOUT) failed");
>>         munmap(addr, SIZE_BYTES);
>>         return 1;
>>     }
>>
>>     clock_gettime(CLOCK_MONOTONIC, &end);
>>
>>     long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>>                        (end.tv_nsec - start.tv_nsec);
>>     printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>>            duration_ns, duration_ns / 1e6);
>>
>>     munmap(addr, SIZE_BYTES);
>>     return 0;
>> }
>>
>> On arm64, only showing one of the middle values in the distribution:
>>
>> without patch:
>> madvise(MADV_PAGEOUT) took 52192959 ns (52.193 ms)
>>
>> with patch:
>> madvise(MADV_PAGEOUT) took 26676625 ns (26.677 ms)
> 
> Good numbers! Just tested on x86 KVM with THP=never, no performance
> regression observed.

Thanks Lance!

Although still I'll try to get no-regression numbers and perf-boost
numbers on x86 myself and post it in next version.

> 
> Cheers,
> Lance
> 


