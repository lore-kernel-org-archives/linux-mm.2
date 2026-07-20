Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB7EAC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BF666B0095; Mon, 20 Jul 2026 05:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8703B6B0096; Mon, 20 Jul 2026 05:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A1C6B0098; Mon, 20 Jul 2026 05:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 406026B0095
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:26:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD8C6807D7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:26:03 +0000 (UTC)
X-FDA: 85008623406.11.C704EA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CDDF6A0007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:26:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hAqI6IVT;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784539561;
	b=yn+BWj3/Rch0A9Hd4+pakDHDJJnjloXSVkneslqJbYQcpT8I+tzm0URgcLvm+2T918Z+nr
	qqMlfPDNr4XQsMMZmcULgW+cpfm+TYtnHJGh6yF0nFIhGIMlwhDJj2xSemXemlj3f/x2fB
	J/9yC8hT7WjquYg332j7ekecIHVmTHQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hAqI6IVT;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784539561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxwSkCk/NnriA4A8tW9ob3/fT1s1G4BD/0LrELXEBwY=;
	b=yQE19tNwtQXhBZGr2OWYkNJylGnxIWlsnjPqbnBe94Kz8ZGMCA89Pjhpj5sbky8ScL04ms
	1ia3nqSz1zYiJEw/IpKGhT5PkEhKvLltl+fSl48QfTbPsrHXnMuUvlz6QKQD1pb5zCxM/k
	nt/q5GiyvO42oerKDO3o3IRmqwSBMiU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F285C40897;
	Mon, 20 Jul 2026 09:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1651F000E9;
	Mon, 20 Jul 2026 09:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784539560;
	bh=pxwSkCk/NnriA4A8tW9ob3/fT1s1G4BD/0LrELXEBwY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hAqI6IVT5rqOoth90nx/dm6qyA3QEwJSVXbD690fTVlV3EXYxyMq2V1xAPBKjF9So
	 6m1gEolrXPP19tyK8R41Xgh1AxEuHApw2acE9goffXNdOWL6lzkOqHD3GFsymxB/ug
	 hxSvOrD0l2SsoNxtgcsjHaCoQ1NoB8FcYAuQPYR1po2HUaq5oS0YXXNh/X2Z1E2P5C
	 fcO8q7jt8ED8D7Qcag0Fh3/WiESNGjLDgBlWixXXXgeC/0IPXTXPNtgjGNvw6hx6fR
	 Sp4nkhpABlKkHh02WFESw0m+yJhFuDnsvmrCwP04oKioN0sxmxCPSehNe0K3er8fYL
	 I96hMu5s4DGog==
Message-ID: <5b37358b-cd6b-47aa-8403-4a24fe105379@kernel.org>
Date: Mon, 20 Jul 2026 10:25:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] mm: mincore: remove special handling for VM_PFNMAP
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Liam R . Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Zi Yan <ziy@nvidia.com>
References: <20260717091347.1144789-1-wangkefeng.wang@huawei.com>
 <20260717091347.1144789-3-wangkefeng.wang@huawei.com>
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
In-Reply-To: <20260717091347.1144789-3-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CDDF6A0007
X-Stat-Signature: h7waeow85zqirhbgpqzfr69rcwbh856d
X-HE-Tag: 1784539561-417867
X-HE-Meta: U2FsdGVkX1/wEiiaxQw7BNztYoxyqp5cQa005MaAP9eVEsUpN4f3R3h//zja9hkaoONMeRgc1PrdTW/zNjXAQegWGA1WNa5QVHR+WMlcAuI2EiHrzfefAuBAvRsTW9v2/K723VU0/SMWlszaavFd3D0mTXTQD50WnLqzYTfplqWkPUhcY1cJZDbWmaHk2uLRkjvhrKwdpZJVbgbSGEf46GxhR7qIdiBBVotFlukHoiZKbk9YMtsW9NeYsjlD4T820IyIDukMt/iW4LTZ7XCXMI1P0enhgVKnEXWE5ZVhuc8ivjgbG88csyf2dMV1idz/NxHCsvUwivrj/MDpTckPyVJJXoFOT83aKexAw1gEUcZdjjPDqOBNw7CyYqNProuioaYkrbH8G8kfOidnqY+PL1sVBDaB1qRuv3PEDd5+5nI93JlCYjhZQ5dpi9sBXOjuBv75Xo9XiTGt8B3bJ1umRPg9nCpGaqJrp/4mZWhWfGdphwSKIolnUBSBNxp9esLzaf9jFkBE/SW27EzkObnMWB/AJmyGr2HQi1Z6A8ApZu4Jeil+aQ2uZDttJeaTTyrVsU53/lW9+77nY81at/+Tsu5Fdjl3mV1OJWyRUnKKWVbafJYe34iUp+/iFM8jWf2GSf12gyLw4C0u0cOUmNppYIE085Z6wrF0SsyVkizKXwFKpgsPESfZji0Jq56t4a7Ua8U/pCGVWmkxxAH6y1HYAlZvGVA09l5AmQNMYprRfmlohzVLQrynjmFQjvYDxKxxPY5lPoUssKD0S+xPWiW/fxyeH66zVer/Kyfbbpb83jxyGXniVUg81HAg+efzstqQBZPJj4xW9mA9AAb0xhFnLmekWmLDGUdsIkvN/S2wBE5LCKtQPjbk0gRYQviHAFP4P/qDR+7BKKhu1E7GogMSNUAksMwRh2Qo82Z5rO1ZYvrhNpUipdw9YR74xKDDvl6Jd0Yre2NXaMCXnfa9bGr
 bqjQLqgX
 8MqiTSnA6a0fdbRTafMS3c/Y98DgIat98OtmipzmnkrKcLL1o7KbaAzd8kRzkR5G23Aln2DPciyrIRQt8/Auqd7/QhqLHxkysSO/GePbEm6+GJUHcgq5YsNGTJWBe7zCBez6wpiratM5eouya1+Q5sl9+h0CkNOa24yDftuN4FC4PClfWmMU8ni+1K5i1iosbyzOjdwBQkJqBx6FOR7xH5swDWhrBPy5+X7kYzdJLsAXAX5Iyi5N9XEjM+N4ApM+JzW5d7jWmcd8xIx+kttw1AiGAFOh+XNi4fQzUJ+rQ/GLdEobv8h+brvK0lCFS7g72yydAbqU7d7G02aDTwi0zzXzaNho3HRxu8LvfUF/fOiYUHcOhvESLXsN/MezW8qV+56FM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/17/26 10:13, Kefeng Wang wrote:
> As David pointed out, "it’s hard to believe that someone depends
> on pages in VM_PFNMAP to *not* be present", so remove the historical
> behavior that always reports VM_PFNMAP pages as non-resident.
> 
> Adding mincore_pud_range() allows the page table walker to traverse
> the full page table hierarchy without splitting a huge PUD, enabling
> much more precise identification of resident pages in PFNMAP VMAs.
> 
> Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/mincore.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 53b982803771..3fccaa5c96f8 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -160,6 +160,21 @@ static int mincore_unmapped_range(unsigned long addr, unsigned long end,
>  	return 0;
>  }
>  
> +static int mincore_pud_range(pud_t *pudp, unsigned long addr, unsigned long end,

s/mincore_pud_range/mincore_pud_entry/

> +		struct mm_walk *walk)
> +{
> +	if (pud_is_huge(pudp_get(pudp))) {
> +		int nr = (end - addr) >> PAGE_SHIFT;

Could be const.

> +		unsigned char *vec = walk->private;

Might be able to just cast that as part of the memset.

> +
> +		memset(vec, 1, nr);
> +		walk->action = ACTION_CONTINUE;
> +		walk->private += nr;
> +	}
> +
> +	return 0;
> +}

With the rename

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

