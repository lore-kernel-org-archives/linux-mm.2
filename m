Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03577C2A062
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 03:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E266B00D4; Sun,  4 Jan 2026 22:36:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B9B6B00D5; Sun,  4 Jan 2026 22:36:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DA36B00D6; Sun,  4 Jan 2026 22:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E47016B00D4
	for <linux-mm@kvack.org>; Sun,  4 Jan 2026 22:36:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83E14D04DD
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:36:10 +0000 (UTC)
X-FDA: 84296496900.11.E5D5236
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 790ECC000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 03:36:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qYedAKQ6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767584168; a=rsa-sha256;
	cv=none;
	b=gywuSev8fIMoHFJ2s9QH7o9tezYOb6UBQGTVYPYC7aqu/G0nQutlsBZQIKgbMJeimItf7M
	sWpeSqT02uV18DHUMr6rdyUbG54xS8u+meHgck3zozmDYrarWx/mHUN7ktBJXblL1PTMiY
	jnazpYvVxhc+furR0DEcJPJj+jUZMt0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qYedAKQ6;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767584168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YlCcjoq+l3rFwtJec/nP8H1oFR5IX71pefYD83vbjnE=;
	b=UMXR8DKaR8ZxWGhZpc172StO2IpsDxiv8mE6LkiqFmaWUs9LQagdS0E8PY+mKdVAGrhncq
	sXCXZn9T2LZKLBk0dcojxm+dBGR17Cggq2K04LvevoeHahmE5vBaDlRtsCBcb3V31zSSTY
	zyun3MTZHxAs4wegLaKELEKm+Q0qfkE=
Message-ID: <cf094519-82e1-4f11-b670-dacf89da22ef@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767584166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YlCcjoq+l3rFwtJec/nP8H1oFR5IX71pefYD83vbjnE=;
	b=qYedAKQ65tFmyTfpB3G85TRc81oYXWEkUz1/zrsUf/Xz0ark+Ha4sOGRd+3uDO/lD76rMt
	UxJuLmX/JUuHucnLTQ0QNIUe+kUsJX9al//G8FhUqsinT+/NbSchXzzuxPeQ1a9StNjH3G
	ktKmMu63f2v4yqZOgvQejR3lhrMpgz4=
Date: Mon, 5 Jan 2026 11:35:58 +0800
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
 <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev>
 <CACZaFFNJO+-yZdDPdN-5rQLuJvT5cp2pbtqV13FHo9PeqtxARg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <CACZaFFNJO+-yZdDPdN-5rQLuJvT5cp2pbtqV13FHo9PeqtxARg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 790ECC000F
X-Rspamd-Server: rspam10
X-Stat-Signature: 9kzzdk3715wudi1nyctr7qyb6w1sgjnd
X-HE-Tag: 1767584168-574930
X-HE-Meta: U2FsdGVkX18iEvgxjnuLRZIzcaK0fGKSHRHj88d3LAil7gZcAfSANwIpRf2uhZ/oy0qXpDCQ891lAWh0yElSJ9j6Oo8PrfG+vSDTbpBJPXI6F96NVmX3E4DHsjEm6kVZ37+ib6R9I8eQ6wkh92M6oPW/FPao5ASw68cKzLsjF+0s1VJlKS4wf+NC9iSfkNCihKbIMHPAvvIguuMr07qC6LNPEwXN99E4HDovJ2RYra1ou9msUxh9q/J5uUh0PIqhXu+Wc29lj/cRE9HAw73zZos8v1iVVZOn2dVPNALT+IgqpH6AFr9oBgNn5JK+2ugLMWEM6N4sVcVmn5oMhSsYlhye2uLsTsOAtR+2/ryQkT1913oP5agypyQ4WRA6lCYrRg2+5U0r8b3YUrFrle6vscra5/qFsAYzw7KhrzEUbZvYm5Bl3ceIDyQj9zbRuXCAGlkvRvkh9pRzioWZ/KuiZD99u+WKCe2ekZ3mQqlKGxmck8USTsdyrqSkPTB/iTmrx3e7/Q7DmKPUxoJvuITlQuIE5pa43u4i/MGsb5csv8vfytJcj+F+Jm1TBNZ58Ekh/T4+fC1//bgnvqtNavJ4mBfxCM06728B4NLcfyfJAmsTOGncvCh0zMQjrcHCCMstTG2UKDmlW0pbSiYrhHGO0Fz6T78gAmEYpnCjlvUmlIaiEXfaPhz5UHKTyHkC8UOh4LjRSDMNmcCEWOjpm1PLvdC1IEtHSjk4j2fHgItzDezBtGkxqte1SnOqlWqUUmtgYG1H5gaNnDE11iuJVEFW8uQ/VT1rb+f4Ak6qcIYjDQT3UGrKEWjtDG0u7608ffhXFC8tErwUed4j6YZCMzvm+EJo4m5df1YgSSpr2hva7VVX+VRqB3t7/463rJC7S/Q+7awP4ubofCvtXiBjy0bbuwXkBBetnNRD2MIx9R+7vCnVnH1Mk9V/06nt9YBkQrU/UR7GLKxtRy2vmIjB+ZW
 7aKobrCr
 DXQ4kZtSMxal9T6IsBMdIPzaJJ7nCwOEDTH40Ys8msRIt4ZrJLhDd/COy/AIrZcIcNXbDpresvsLx5FzL0Avda4UOPHn9XePah8gbYbKKO9y+xXD9z2Crdo1Ixbz7qALeQ9q0ftbQXC/+5MZzuLQV/MzBEpEVk2VD9YoOmXD1aXH09CbQUBw2W2C0APFdO3lU52qwmnXd1Rx9Mf/OEJi5DJ5iWeQApsAH1Oa5PmmjMa1MP1iAg6S9Gf3lGlRj7nHuTG5r13AznfYybR0Z3Sv0HTcK2yzzOAuIxgpLkp1VmHwGSSYrL8IVv29qtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/5 11:12, Vernon Yang wrote:
> On Mon, Jan 5, 2026 at 10:51 AM Lance Yang <lance.yang@linux.dev> wrote:
>>
>> On 2026/1/5 09:48, Vernon Yang wrote:
>>> On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
>>>>
>>>>
>>>> On 2026/1/4 13:41, Vernon Yang wrote:
>>>>> For example, create three task: hot1 -> cold -> hot2. After all three
>>>>> task are created, each allocate memory 128MB. the hot1/hot2 task
>>>>> continuously access 128 MB memory, while the cold task only accesses
>>>>> its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
>>>>> still prioritizes scanning the cold task and only scans the hot2 task
>>>>> after completing the scan of the cold task.
>>>>>
>>>>> So if the user has explicitly informed us via MADV_FREE that this memory
>>>>> will be freed, it is appropriate for khugepaged to skip it only, thereby
>>>>> avoiding unnecessary scan and collapse operations to reducing CPU
>>>>> wastage.
>>>>>
>>>>> Here are the performance test results:
>>>>> (Throughput bigger is better, other smaller is better)
>>>>>
>>>>> Testing on x86_64 machine:
>>>>>
>>>>> | task hot2           | without patch | with patch    |  delta  |
>>>>> |---------------------|---------------|---------------|---------|
>>>>> | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
>>>>> | cycles per access   |  4.96         |  2.21         | -55.44% |
>>>>> | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
>>>>> | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
>>>>>
>>>>> Testing on qemu-system-x86_64 -enable-kvm:
>>>>>
>>>>> | task hot2           | without patch | with patch    |  delta  |
>>>>> |---------------------|---------------|---------------|---------|
>>>>> | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
>>>>> | cycles per access   |  7.29         |  2.07         | -71.60% |
>>>>> | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
>>>>> | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
>>>>>
>>>>> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>>>>> ---
>>>>>     include/trace/events/huge_memory.h | 1 +
>>>>>     mm/khugepaged.c                    | 6 ++++++
>>>>>     2 files changed, 7 insertions(+)
>>>>>
>>>>> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
>>>>> index 01225dd27ad5..e99d5f71f2a4 100644
>>>>> --- a/include/trace/events/huge_memory.h
>>>>> +++ b/include/trace/events/huge_memory.h
>>>>> @@ -25,6 +25,7 @@
>>>>>      EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
>>>>>      EM( SCAN_PAGE_LOCK,             "page_locked")                  \
>>>>>      EM( SCAN_PAGE_ANON,             "page_not_anon")                \
>>>>> +   EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
>>>>>      EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
>>>>>      EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
>>>>>      EM( SCAN_VMA_NULL,              "vma_null")                     \
>>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>>> index 30786c706c4a..1ca034a5f653 100644
>>>>> --- a/mm/khugepaged.c
>>>>> +++ b/mm/khugepaged.c
>>>>> @@ -45,6 +45,7 @@ enum scan_result {
>>>>>      SCAN_PAGE_LRU,
>>>>>      SCAN_PAGE_LOCK,
>>>>>      SCAN_PAGE_ANON,
>>>>> +   SCAN_PAGE_LAZYFREE,
>>>>>      SCAN_PAGE_COMPOUND,
>>>>>      SCAN_ANY_PROCESS,
>>>>>      SCAN_VMA_NULL,
>>>>> @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>>>>>              }
>>>>>              folio = page_folio(page);
>>>>> +           if (folio_is_lazyfree(folio)) {
>>>>> +                   result = SCAN_PAGE_LAZYFREE;
>>>>> +                   goto out_unmap;
>>>>> +           }
>>>>
>>>> That's a bit tricky ... I don't think we need to handle MADV_FREE pages
>>>> differently :)
>>>>
>>>> MADV_FREE pages are likely cold memory, but what if there are just
>>>> a few MADV_FREE pages in a hot memory region? Skipping the entire
>>>> region would be unfortunate ...
>>>
>>> If there are hot in lazyfree folios, the folio will be set as non-lazyfree
>>> in the memory reclaim path, it is not skipped in the next scan in the
>>> khugepaged.
>>>
>>> shrink_folio_list()
>>>     try_to_unmap()
>>>       folio_set_swapbacked()
>>>
>>> If there are no hot in lazyfree folios, continuing the collapse would
>>> waste CPU and require a long wait (khugepaged_scan_sleep_millisecs).
>>> Additionally, due to collapse hugepage become non-lazyfree, preventing
>>> the rapid release of lazyfree folios in the memory reclaim path.
>>>
>>> So skipping lazy-free folios make sense here for us.
>>>
>>> If I missed something, please let me know, thank!
>>
>> I'm not saying lazyfree pages become hot :)
>>
>> If a PMD region has mostly hot pages but just a few lazyfree
>> pages, we would skip the entire region. Those hot pages won't
>> be collapsed.
> 
> Same above, the lazyfree folios will be set as non-lazyfree

Nop ...

> in the memory reclaim path, it is not skipped in the next scan,
> the PMD region will collapse :)

Let me be more specific:

Assume we have a PMD region (512 pages):
- Pages 0-499: hot pages (frequently accessed, NOT lazyfree)
- Pages 500-511: lazyfree pages (MADV_FREE'd and clean)

This patch skips the entire region when it hits page 500. So pages
0-499 can't be collapsed, even though they are hot.

I'm NOT saying lazyfree pages themselves become hot ;)

As I mentioned earlier, even if we skip these pages now, after they
are reclaimed they become pte_none. Then khugepaged will try to
collapse them anyway (based on khugepaged_max_ptes_none). So
skipping them just delays things, it does not really change the
final result ...

> 
>>>
>>>> Also, even if we skip these pages now, after they are reclaimed, they
>>>> become pte_none. Then khugepaged will try to collapse them anyway
>>>> (based on khugepaged_max_ptes_none). So skipping them just delays
>>>> things, it does not really change the final result ;)
>>>
>>> This patch just resolve scene for hot1 -> cold -> hot2.
>>>
>>> --
>>> Thanks,
>>> Vernon
>>


