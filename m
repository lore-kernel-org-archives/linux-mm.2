Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 769B3C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 01:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6B36B0088; Thu, 27 Aug 2026 21:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7396B008A; Thu, 27 Aug 2026 21:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96336B008C; Thu, 27 Aug 2026 21:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A3D1F6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 21:38:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38A25C021D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:38:34 +0000 (UTC)
X-FDA: 85148968548.30.9E189F5
Received: from mta1.migadu.com (out-119.mta1.migadu.com [95.215.58.119])
	by imf17.hostedemail.com (Postfix) with ESMTP id D456F40002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:38:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cl05IFeJ;
	spf=pass (imf17.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787881112;
	b=m8jf3o7AMlf6MHriG2NknHSR07TVlSaURjE+E8apKyRtWKnBZJlaGa7lfPnd45IUeDHlR7
	H1bWnuN4uhDxZOIy6OgzOBF6Ih7JnH3uqejS8tGrCVoC9J3Rl+w3slJoclZVVDUBO71Rkj
	Cyv7JXNaGa8QAw5BwFT4QZmHQkU0VYg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cl05IFeJ;
	spf=pass (imf17.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.119 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787881112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/II78MybNn0Q2bXep7+K+AAC6pLLViUdYwPp0UzN8qk=;
	b=bfSXfCbG3UeLJrySB644a1vbX4/UG9TegN5rz0X5umDJukKLZjsRTxbEyojqJd6mS8O7Vu
	UQPHCSKPjVvCh/QithNegNS67YE7WBA4J4ByR/bpdueGD597TVxaMfHvTE1rUbqGVpBiLm
	ka3kp04fm6s0CO22Tocp9cIHHivNtCM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9B9bzIQfMl/vcQvlvHw+4YRKHMkOiXpCte8Fe955u2M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787881110; v=1; x=1788485910;
 b=Cl05IFeJmDJfllfn92IfQfCz20g+3kjSIPYD+bZCDsfW9DZXly5vrqDHFgHFj5l9EyTQxUwh
 pmciQrPN6H5iE8QApCciABx2UAZU43rGr9DC0PirjcrwsWu6gtotR5nYqshXM94Vxgri/kwuLlH
 CDSkzo5rXqOPhh+3PLmQdUeo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7972bdfdbca739a7;
	Fri, 28 Aug 2026 01:38:30 +0000
X-Mizu-Trace-ID: 7972bdfdbca739a7
X-Migadu-Flow: FLOW_OUT
Message-ID: <ee79e463-b1fe-4b5e-9bac-bcbaae334829@linux.dev>
Date: Fri, 28 Aug 2026 09:38:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: hongfu.li@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, steven.sistare@oracle.com, vivek.kasireddy@intel.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/hugetlb: fix resv_huge_pages double decrement in memfd
 error path
To: Andrew Morton <akpm@linux-foundation.org>
References: <20260825021013.25672-1-hongfu.li@linux.dev>
 <20260826194759.88487180eebf728c1df08f14@linux-foundation.org>
From: Hongfu Li <hongfu.li@linux.dev>
In-Reply-To: <20260826194759.88487180eebf728c1df08f14@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D456F40002
X-Stat-Signature: 3yzfhrzjxnhzie4t3fbfe1koiobeok8a
X-HE-Tag: 1787881111-482858
X-HE-Meta: U2FsdGVkX1/AeKq4lPeZdZX6nsaJ6hium2QIbll4tA8kP9/HO3FHOygTgO3gNLzgBNVhdc7PJE+Iee2+Hpw/Al+VreYvCm6SI+2MmBs8A287HGeldHpkXIy36Ll0iqzDGOEOAN5DPw3QHiX7SUYs1yr8enYI6cX5I2Sf0nLAazrEVv80S4f8e9Sg0V3GF3oW3UHQWa5XzaOs/WAeFaGtdpjDKBiVl+/oXgDkNHEbyhkW6nUN6JKXOlDMv4yEVbsYkzlrUjErT/no6DXcTgGoyvXMm+9pIFYnElfW92y4KvKu4IBNqFhS0pbrbSbk6+i/Tp2DjxVBgIuDtL+YFfn7J2eM2l7V3TJUv5sX82JmNuXJjcmxq/4VhGUTb+mn4rMnjWR2nxUc/gSLHvw2lnGACRy+eJ/4WNvO8PxHjiI5m72Pi/PULhN9Hd5o9kz6AMtPqpEqxI8D5lO9sD/2crKr7wPuGf/0dIvf2+vOBDA/IZqjMcvS00FKsNdRqRRvlzQVfoFBpWAAkULBclXuLTw6Y1EaFUhI/jbKfUpnkIfswtM6yHl3UHyGT46ljSs4AinIMLtSYDndMZOcr9ZWpBMUfUrPbys6suADY2IypDCV3SSc2k9+qWu+CLaOjI8gHk6NvovHcaDPzJJtqWJ9tGyatMM6d1XMsEB627QVjRTSD6Ynw1bbByhABZTNI/fve2PulMXeY7MZ5PlJFdD/FhLr50SPSCssiZKAReAz0OA0/prbfxsFIaG76sa0Awv1H8w/mEsUQvny/G589933oaL6i0rCvBeXQ+fQRtGBjQjU5HgsLplqL337rbhKkSRTnFi6HHF/5FEtisYuglV2UjfJukTJf1VQAEjBJSO788cJF5ui5JVs4fJ328t+Hk0RgshGm75GeXhR3Et6JRJt3/zodr0xPX2dRZ4JzqSahQSTfvY7MrPVQ/GnYP7TC2sWXMzONlAGH4uyv28wWImNvNp
 DQNp2vUf
 DTamIdfKPFplBBPPtZ8I3e9g9IcHQrbEjKJTDx+pYov8yOmUFxfMzR4IMY3IzfwFNS97XhrW5cot9lOqPIzjt1+emZ0ZUCfpgWcWmYTiVipwzVQ8puUV65y2EgzXyvoMJGiVrPxdPtA0bYViWtQl0nd0gLBrhKVHxyYw/Wr11xbObU/uMZhZxWakYq+7ouNuGcSpEr4doqWHzzf1noy3+UyL6l9Ycyic987/7cS0yUWGLJn94m1e7ZpIDO8w3wvl+t159Ej+StoQokel9tX1VsAHrp01X7GRCDyYbGV5eOoJGTztJ9sglwsFTG705/BsMR6R3/SYbaLUlaqZOH4JapdsX02sAn37BfguhUoKE51JEknhcHiGAFphfruEUV6gs5P9qu434vwdfPaEV1xliY5/AVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/27/26 10:47 AM, Andrew Morton wrote:
> On Tue, 25 Aug 2026 10:10:13 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:
>
>> From: Hongfu Li <lihongfu@kylinos.cn>
>>
>> alloc_hugetlb_folio_reserve() decrements h->resv_huge_pages when
>> dequeuing a folio, but unlike the use_global_reservation handling in
>> hugetlb_alloc_folio(), it does not set HPageRestoreReserve on the folio.
>>
>> Its sole caller memfd_alloc_folio() pre-allocates a reservation via
>> hugetlb_reserve_pages() before allocating. When hugetlb_add_to_page_cache()
>> fails, folio_put() drops the folio without HPageRestoreReserve set, so
>> free_huge_folio() does not restore the reservation. The subsequent
>> hugetlb_unreserve_pages() on the err_unresv path decrements the counter
>> a second time, leaving resv_huge_pages off by one for every failed
>> allocation.
>>
>> Set HPageRestoreReserve when consuming the reservation in
>> alloc_hugetlb_folio_reserve(). On the error path, free_huge_folio() then
>> restores the reservation before hugetlb_unreserve_pages() releases it.
>> The success path is unaffected, as hugetlb_add_to_page_cache() clears
>> the flag once the folio is added to the page cache.
>>
>> ...
>>
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -2178,8 +2178,10 @@ struct folio *alloc_hugetlb_folio_reserve(struct hstate *h, int preferred_nid,
>>   
>>   	folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask, preferred_nid,
>>   					       nmask);
>> -	if (folio)
>> +	if (folio) {
>> +		folio_set_hugetlb_restore_reserve(folio);
>>   		h->resv_huge_pages--;
>> +	}
>>   
>>   	spin_unlock_irq(&hugetlb_lock);
>>   	return folio;
> Thanks.  I pasted an AI-generated test case which might demonstrate
> this bug.  Requires fault-injection so I won't add cc:stable.

Thanks for sharing the test case.

I have run your provided test program and successfully triggered
the double‑decrement bug of resv_hugepages with fault‑injection.
Testing confirms that my patch fixes this bug.

> Also, Sashiko might have found an accounting issue in the nearby code
> (Sashiko doesn't like hugetlb.c):
>
> 	https://sashiko.dev/#/patchset/20260825021013.25672-1-hongfu.li@linux.dev

I have taken a close look at the nearby accounting issue reported
by Sashiko in hugetlb.c. It appears to be a real issue, and I intend
to submit a separate patch for review to fix this.

> #define _GNU_SOURCE
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <fcntl.h>
> #include <sys/mman.h>
> #include <linux/memfd.h>
>
> /* Read resv_hugepages from sysfs */
> static long get_resv_hugepages(void) {
>      FILE *f = fopen("/sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages", "r");
>      if (!f) return -1;
>      long val = -1;
>      fscanf(f, "%ld", &val);
>      fclose(f);
>      return val;
> }
>
> int main(void) {
>      long orig_resv = get_resv_hugepages();
>      printf("[1] Initial resv_hugepages: %ld\n", orig_resv);
>
>      /* Enable fail_function for hugetlb_add_to_page_cache via debugfs */
>      system("echo hugetlb_add_to_page_cache > /sys/kernel/debug/fail_function/inject");
>      system("echo 100 > /sys/kernel/debug/fail_function/probability");
>
>      /* Create memfd and attempt write to allocate hugetlb folio */
>      int fd = memfd_create("test_memfd", MFD_HUGETLB);
>      if (fd >= 0) {
>          /* Force allocation path which triggers memfd_alloc_folio() */
>          ftruncate(fd, 2 * 1024 * 1024);
>          write(fd, "a", 1);
>          close(fd);
>      }
>
>      /* Disable error injection */
>      system("echo > /sys/kernel/debug/fail_function/inject");
>
>      long post_resv = get_resv_hugepages();
>      printf("[2] Post-failure resv_hugepages: %ld\n", post_resv);
>
>      if (post_resv < orig_resv) {
>          printf("[!] BUG DEMONSTRATED: resv_hugepages double-decremented by %ld!\n",
>                 orig_resv - post_resv);
>      }
>
>      return 0;
> }

-- 
Best regards,
Hongfu


