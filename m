Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA9DC2A073
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 02:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08C006B00CE; Sun,  4 Jan 2026 21:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 062A26B00CF; Sun,  4 Jan 2026 21:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA75F6B00D0; Sun,  4 Jan 2026 21:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D92786B00CE
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 21:51:27 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3D4F31412ED
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:51:27 +0000 (UTC)
X-FDA: 84296384214.17.F4F186D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3AF61140008
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 02:51:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i3pzTf5e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767581485; a=rsa-sha256;
	cv=none;
	b=LIrxX12Jyu5qMk69YKMq2NMlQeHlXP6DPYruf1ExbA/0rXXbZ59CsGeYLLdNP/YkfGQplO
	Ag8SZSAmGdxayZaAn+U3Nqlc4CZDH1BniB/t/xBusn32gmxnL+axLxr0qsfRH8fFJ5J4SX
	xVCqys91RSVmM2ka2oqFmK5+T031JUo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i3pzTf5e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767581485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eH363o8l7dNNtRLISLiXPZUzX0hpm1ZZb6O7fLroI1E=;
	b=V5Vx2fN8Lt1vn2YQJQLlYadPSf4vSRY4V+AXFQoEd5RX3KfmB5iW0UkBYAWymXq2hj1WKU
	V5BE4x9W0ta2b7+HRQ1UuhpqLZZjJWmrB+8UcBuVfCIQLWKdaxsgjAvcFAjkA5G9WQ/p7N
	a8oqB2be7doRl4aNWX6nCW0o0MjY4a4=
Message-ID: <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767581483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eH363o8l7dNNtRLISLiXPZUzX0hpm1ZZb6O7fLroI1E=;
	b=i3pzTf5edwAE3CTPa9VtqIBKVOIlYcyOpJPjezhcPUSu7xjSs6+BMw/g/BO0T/YxVkDHhD
	sFW4mvIrEl2oxn/kwyYeIH3lWhCslJisSAfFaOKzJfB+tqEL/nrHhMCJyqszlA3XuNPQzN
	ax4yT25TMFOxSTV++rMxnFxiNBuxCQE=
Date: Mon, 5 Jan 2026 10:51:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, richard.weiyang@gmail.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org, david@kernel.org
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn>
 <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
 <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AF61140008
X-Stat-Signature: 4fki4i8yko44uashxcx9azrtxzw7uimx
X-HE-Tag: 1767581484-332200
X-HE-Meta: U2FsdGVkX1+l6LjLhsh0Rmlnvcfk971kky1Nif5Qu4eNJootSBm44xsTyNBezrlX62cyXep2Ru6Ae74JdKO6S2h6uFzFbZ7BK22oJ0u0l/pYPqg8TImqxlDytk1JitxlaSzINYDUY6BV7SOVJlauzzrheoFm+Ttj9B73LH4kGxzm1RLGJCzPYMegZFzzSKfSvbzt38hnGf18nRNvUxowyWMoVletFhyBxibLqcGsijjkTE1S/Qp02FC8G2ke0fdNLflllLsnbTWNhB+j4hqRwMF2EyfmLGknNES22+eqOYTwZtG1Hb04w0Qq9HDPNSXitg4eZfVDyxNwSbMrz6jCeSseZ6Z5gc0QGLGePEMmTyIEZUAuIyOXj4Ow4qV/EpGDckb364RG+JcezuNwLrVY8SI3cOfPxGdAtWDWLCzHrNlkDRdR0uU+PpxkJ795XA1EHfrt9G/MKemFljtSFxvVVhUAxw6bylbOko+3XEa56OcJF7qRIGL5/d3m1TtvQUIeSJc6mcyVhyDzKZIng+l2FQrxE/PqhvOuz97OqBR3N2UEs/cvGX3NH1jnsxim6Wn3UgiVdRAqQNT4SbWzcK01sO/RWr4t/C4a8UkkbEjLdctbw7RwyueI+L6UD65ptWrP4+0RU7RasV1TzUIbuJKLmGYW83Naqkx2J9j2RKaiQzeQ/VRvt7VmQVkEKFXJmcfmQLLI/xRy3XZC1AnpcJBQZuJAdEtMr9RQGhfS0qWhsVIYuLmW0N1Gndv2PGwRV6MlFUrWTS8/p9PsPolP/BzMdrP5px+GT/3xg5UAOYd028n00kVhCroZwUmB0W750s2brkctRUCViUshJmNZ19tqUB8G0a+yrTarEr9jeNvoqjw0hKPTkQr0382SRrlTVvUUIp8QSwmENlTA2xjoybiw9AXqdQ21lhIiUj/xpMrbWKLiBG/DqZNNOzM5LOVNnoYyJ9P4GNUknAUWE998KWS
 MVjcH5nB
 c/6BdPL6Ia+ImE0obvF4/rN8LxtcWFH3B04XPwRLFKGvZUO3Sac8oq+y6AlGpioVgNbuSDlSeZLhSaeuQofCRHlsbiB6wCjHbDWuLkDKVsTAldKQo575Kzq8/MLc2LBBv/qrs835qkI1un7oyyhL351Udz5kbZPRYihuf0wOaW/aErvRTqz8EsJizeWsEJ1E3WVy/xBs72V/LJC4pr80hC7RxLjlfkwEg9SkSbI51hvw6vivonKX01ATGdUd1PKSdQ7f+5KrD1Mm7Zh4vPH/phG+j4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/5 09:48, Vernon Yang wrote:
> On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/1/4 13:41, Vernon Yang wrote:
>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>> continuously access 128 MB memory, while the cold task only accesses
>>> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
>>> still prioritizes scanning the cold task and only scans the hot2 task
>>> after completing the scan of the cold task.
>>>
>>> So if the user has explicitly informed us via MADV_FREE that this memory
>>> will be freed, it is appropriate for khugepaged to skip it only, thereby
>>> avoiding unnecessary scan and collapse operations to reducing CPU
>>> wastage.
>>>
>>> Here are the performance test results:
>>> (Throughput bigger is better, other smaller is better)
>>>
>>> Testing on x86_64 machine:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>>
>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>
>>> | task hot2           | without patch | with patch    |  delta  |
>>> |---------------------|---------------|---------------|---------|
>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>>
>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>> ---
>>>    include/trace/events/huge_memory.h | 1 +
>>>    mm/khugepaged.c                    | 6 ++++++
>>>    2 files changed, 7 insertions(+)
>>>
>>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
>>> index 01225dd27ad5..e99d5f71f2a4 100644
>>> --- a/include/trace/events/huge_memory.h
>>> +++ b/include/trace/events/huge_memory.h
>>> @@ -25,6 +25,7 @@
>>>    	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
>>>    	EM( SCAN_PAGE_LOCK,		"page_locked")			\
>>>    	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
>>> +	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
>>>    	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
>>>    	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
>>>    	EM( SCAN_VMA_NULL,		"vma_null")			\
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index 30786c706c4a..1ca034a5f653 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -45,6 +45,7 @@ enum scan_result {
>>>    	SCAN_PAGE_LRU,
>>>    	SCAN_PAGE_LOCK,
>>>    	SCAN_PAGE_ANON,
>>> +	SCAN_PAGE_LAZYFREE,
>>>    	SCAN_PAGE_COMPOUND,
>>>    	SCAN_ANY_PROCESS,
>>>    	SCAN_VMA_NULL,
>>> @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>    		}
>>>    		folio = page_folio(page);
>>> +		if (folio_is_lazyfree(folio)) {
>>> +			result = SCAN_PAGE_LAZYFREE;
>>> +			goto out_unmap;
>>> +		}
>>
>> That's a bit tricky ... I don't think we need to handle MADV_FREE pages
>> differently :)
>>
>> MADV_FREE pages are likely cold memory, but what if there are just
>> a few MADV_FREE pages in a hot memory region? Skipping the entire
>> region would be unfortunate ...
> 
> If there are hot in lazyfree folios, the folio will be set as non-lazyfree
> in the memory reclaim path, it is not skipped in the next scan in the
> khugepaged.
> 
> shrink_folio_list()
>    try_to_unmap()
>      folio_set_swapbacked()
> 
> If there are no hot in lazyfree folios, continuing the collapse would
> waste CPU and require a long wait (khugepaged_scan_sleep_millisecs).
> Additionally, due to collapse hugepage become non-lazyfree, preventing
> the rapid release of lazyfree folios in the memory reclaim path.
> 
> So skipping lazy-free folios make sense here for us.
> 
> If I missed something, please let me know, thank!

I'm not saying lazyfree pages become hot :)

If a PMD region has mostly hot pages but just a few lazyfree
pages, we would skip the entire region. Those hot pages won't
be collapsed.

> 
>> Also, even if we skip these pages now, after they are reclaimed, they
>> become pte_none. Then khugepaged will try to collapse them anyway
>> (based on khugepaged_max_ptes_none). So skipping them just delays
>> things, it does not really change the final result ;)
> 
> This patch just resolve scene for hot1 -> cold -> hot2.
> 
> --
> Thanks,
> Vernon


