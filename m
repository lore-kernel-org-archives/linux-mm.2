Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB2AD35159
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:32:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72EF56B0088; Wed,  1 Apr 2026 04:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706DD6B0089; Wed,  1 Apr 2026 04:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61CBF6B008A; Wed,  1 Apr 2026 04:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9576B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:32:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05A7513A989
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:32:39 +0000 (UTC)
X-FDA: 84609320838.17.AD865E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 52962180005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:32:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQHM9uVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775032357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxKZnzzeuiIgV08dROFGS/rsGKma9WByQcI93Z/y3T0=;
	b=Mxcx35/SmgXgBE4v+MqIR3+pORIZHP+pDsMx/4f3lS6TNW6cFBDiFhsiOXTCyWkEJU9naZ
	2rG9crMQ7j4l3wKVZbRBovzDn7syjubu/oU9tQ/iatw+MVvtMkToo3zhFG7CkuuugtQdq5
	w8mzaClCHZFTJAcdS6StFXsxwSjH+s0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775032357; a=rsa-sha256;
	cv=none;
	b=a909ha6B4BUbo3C5HeynC9O3jPcD+dIvDYqvohZNjP4+EHMDQk3hcKtrfZmi1JQnLOzHeJ
	v5qIUt+EdmHwS4KmkLrWrdnmAPekzEZSrm1zzPG1kYm7xaYyPLIp+4HcAbSRdB6NnEL/1C
	VHUUeUImvakPn7eyGmCgXfSGQgir+1Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XQHM9uVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71CE3405EE;
	Wed,  1 Apr 2026 08:32:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55654C2BCB0;
	Wed,  1 Apr 2026 08:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775032356;
	bh=FWpKlCRjE0MaEpEALV0M0e/bqdmtSE+E/9VxxS4+JM0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XQHM9uVa9hZuc4Tlb9fIE7zYIL7/BBftidq4d5NM0JDfiuXyKd0sBUwKbumSINvUV
	 Du3szP9dLJnRM5X5H1nhy/ffQ1397bX/UNP4AxExFTRnHQar5pnKtTOxXfJ2aKd4eL
	 cCt663qZgIGl+GqWnDtlvtnGk8TMXSU1koVpcGv/4mIVoRSPHZRhFQzq9//XZGeh7G
	 IxFgK6dDO6o1nlHacMhiLZ//X8VFX7412Sb4Va/+JSkcuZzEMbiYrBP6r+uBkcBgQY
	 qHlY/A7lHBOdQnKq6FpcLqM9oRWfyF21LTR5ZBuVCw7rvW6uCqM2YHUq5scQqCxNM/
	 IOnwezv/zfW5w==
Message-ID: <a8a8533c-992a-4ac5-a387-3cde8b6e40b5@kernel.org>
Date: Wed, 1 Apr 2026 10:32:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_io: use sio->len for PSWPIN accounting in
 sio_read_complete()
To: David Carlier <devnexen@gmail.com>, Barry Song <21cnbao@gmail.com>,
 Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>,
 NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260330071229.14614-1-devnexen@gmail.com>
 <20260401074753.238053-1-devnexen@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260401074753.238053-1-devnexen@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 52962180005
X-Stat-Signature: iy9xbe3hc5beik8sy5cj8urho7q9eaqu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775032357-780567
X-HE-Meta: U2FsdGVkX1+0jZ9fylrRxpqWsvlxJG9UCj8gCyus9waIcbDkLzP36Vov1irdwEkbQNiH/Rjhvvr69ns8lpKiYvg6/GTj2YvYRrIKb/F41M7wC2tLRmlN+7UUHQVGh8H/sArXpvj304EdrVCvhkArGRpol17PQzNrdkRaFxu+jfTL9vttV5wZCNTKtjpYgxTytPwjvCJKpQtebWqZhd4DV49zBWy1+2lP1ACxHRuWsoRGriZqLyzoBxeAeuHDaEvCdxhsCyCauOjPShJcmEunSTq3P7XHfOqppmdQuVhGWVc8VTA4p3yZKV2hIwAaP+vqrywj3uGf7WXJo5vePyApWo2jgP8EaiM3GiDW5gV608grKxBlJVlbSNHiymm3SCO43FZ+lUMN3vx9KsRoFbZDix7Ym05csKOT9tWoDhyMNBYVf33/AzH2cqoGCOpbjtT17l1oTreq/UnNlKPFh9PaRh8aCZWaKfB5/0wI8Atl4BICmwRgQCc66QgeqoVGkut++4Wawtn2lUnr4Flbc3NL/kqFPJjtGu0iu64ZFFK9dGwJZmGGpSyosNSneJONT1nJqZBKBvp/1P+bTvW5xI5BamzhCGjghu9QHRJQCBJbse6WlfSubSwnjIgDgZ6YtFcIX9xQBh6q+HaBZy3qxxZFhFlNsN6Rp5cuKKcEEg21GLZOqv323J/ir7jYe2L7bD90o8K7pWkWT5JQZQopdK3a7mArRhu6nYhbnNckxebCbzhpcMbmKlNkJe31v8xG1Az55BxwQy3wVnE850U/GKs/tURziHTtvZUWXhAxGsPZuYMnDMySHO7tb6eZcGAWr35/lpdrOqT0ZiSxHT7ZRkzjd1yBfoHRTn83iDQauAqF3Sw/9Pn8Xx/Kp9we3kjSBhZlG4t4YuOdqfzExpNaI0/SR3LAi0fd08aYC1v2o8SyxTb4qvHcxtizmsh6Rx8l2TwSmhrsUuL7z6zmRw/jvu2
 htK8XK5X
 0HSn+mrJNRc29YHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 09:47, David Carlier wrote:
> sio_read_complete() uses sio->pages to account global PSWPIN vm events,
> but sio->pages tracks the number of bvec entries (folios), not base
> pages.
> 
> While large folios cannot currently reach this path (SWP_FS_OPS and
> SWP_SYNCHRONOUS_IO are mutually exclusive, and mTHP swap-in allocation
> is gated on SWP_SYNCHRONOUS_IO), the accounting is semantically
> inconsistent with the per-memcg path which correctly uses
> folio_nr_pages().
> 
> Use sio->len >> PAGE_SHIFT instead, which gives the correct base page
> count since sio->len is accumulated via folio_size(folio).
> 
> Signed-off-by: David Carlier <devnexen@gmail.com>

For the next time: Please don't send new revisions as reply to other
revisions :)

> ---
>  mm/page_io.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 63b262f4c5a9..1389cd57ca88 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -497,7 +497,7 @@ static void sio_read_complete(struct kiocb *iocb, long ret)
>  			folio_mark_uptodate(folio);
>  			folio_unlock(folio);
>  		}
> -		count_vm_events(PSWPIN, sio->pages);
> +		count_vm_events(PSWPIN, sio->len >> PAGE_SHIFT);
>  	} else {
>  		for (p = 0; p < sio->pages; p++) {
>  			struct folio *folio = page_folio(sio->bvec[p].bv_page);

sio->len always covers full pages as processed in swap_read_folio_fs(),
so there should not be any difference.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

