Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6036C61CE2
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 10:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 095F36B00B2; Tue, 25 Aug 2026 06:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DA06B00B3; Tue, 25 Aug 2026 06:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7536B00B5; Tue, 25 Aug 2026 06:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6AC36B00B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 06:40:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54B2E8037D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:40:45 +0000 (UTC)
X-FDA: 85139448450.21.C9F5ABE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 841F440006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:40:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRDkgqvR;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787654443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7a0vBDAZCAZbORacmTwi1iUSuIX0elcEO78pOODZsdQ=;
	b=gOZ/grUB24ulPrti2359TZvqEQQj0fV3qhdv9iPnShN7TjKVDdqm8sRcMSLt9K2njw4qPq
	EEFTqK9djIwhzmZrT+lG8+2UGQ5arsG4zV7p7SND3iHUMxXvor1H8Nj6zBQIoqAVYuGAnj
	F64d0GdUtvS9tgcB/cMnN/fxZy/8bT4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RRDkgqvR;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787654443;
	b=xsDNDJuQYhL6jkla2LT9CZpHbD7a0YLxM+Ok0VaiYaHbDFJTSQ3boVZ+cl8uBh6kVTj91J
	XEsPo8al+tg/5DJYhveR0OMMnTSq0NoWpMrzw/GV9VthLTTe6oBTTzoMUcxh6KDcl3YcQu
	wnCVqQ86SscdVKIJOQStAoEdan/3WN4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C202840A5D;
	Tue, 25 Aug 2026 10:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E5A1F000E9;
	Tue, 25 Aug 2026 10:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787654442;
	bh=7a0vBDAZCAZbORacmTwi1iUSuIX0elcEO78pOODZsdQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=RRDkgqvRApxEUth7tevBcyX2AqvBqsRPcn9yAX57BaOU80PQP6iAdgSgOVW+05K/a
	 XRmqGz0BvZ9t1k6I4545I4wVKydWszGWDsfA/SiWkvIjrUVe+3T0NB1U6pk/jxbecA
	 kBOEL2n9kZkbZVhidbWlgVp1QTxE38MtA+ou+A8d0a2q0qDUbNLLAb1GOYGMGsNL7Q
	 +bVxZiBae1xLJKlbL/zklqpmmVIa4C79FdXydCKGPBbMcnUokXXg1miZFiabMK8QeV
	 KLG4o9SO2VT+xMLp6ApfkF9nx1Mpe2ovaP3ZWrvEURO0SjMrSUUp5iYn60Vfg6n2aI
	 RqWAuYDDQ3kOw==
Message-ID: <e4a7bffe-7d23-4d7b-8ec6-5b966419c615@kernel.org>
Date: Tue, 25 Aug 2026 12:40:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: return -ENOMEM for page-table allocation
 failure in insert_pages()
To: Avi Weiss <thnkslprpt@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Soheil Hassas Yeganeh <soheil@google.com>, Arjun Roy <arjunroy@google.com>,
 Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1785847364.git.thnkslprpt@gmail.com>
 <a486e90cca91f443552b70ab2a18510bcc5dd8b6.1785847364.git.thnkslprpt@gmail.com>
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
In-Reply-To: <a486e90cca91f443552b70ab2a18510bcc5dd8b6.1785847364.git.thnkslprpt@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 841F440006
X-Stat-Signature: ftr3mk9no36we5qkf59hf9optexayjdq
X-Rspam-User: 
X-HE-Tag: 1787654443-627852
X-HE-Meta: U2FsdGVkX18otdSynJJhdP+04DivTQqqwulQEihxuYogIeqvtbMabbZZwLUhytnAxj7ThnugkvuS9Ww4O55wk+KPNSXj+a0IHDlhTqnG0jc/HZgblglzVlfqHEZ6GbT2yH4veRWCz0juOTajh1Tiura0Ek9TrxiddMaL9evjtn6/bzmZ4111u3BbKqJTzLT9lHXBeKMwMiJj9w0c1pzAuPUeo0nvig8sMhrxzasI5eTNaoxiozkDgK9E00YJAenJvnB2vFUXrhzOmwqTTmPippXHyVWdy45YSM7rgnvgdJ0BeSekGDqclQv0pJvLHqQ0E8zjyhSm685pbsSnHdN24KSpsTJT8mYA2stPyat8CMsMZzhRBLyQYRlNvlu6Ocv+IHWH9WHsAnBOXpMra2m5che23brKBvME/wh+Ao5PwKv6Aoe6sfQyttZaDAEwEFT+J8kkWHJ9+URRUfxdvL+R+Btb0mgjuk9+Z091yfRa2AVGywAYcwPsZPk2nJuy0knkRHW5ooOt5KUEQjxLo70TCx3MjdUWlqj71LmtQU7se9zUyTb75I2eebR9erBMY4UWkvcHy/aUw1+Ihe1RMz7X/TMCrVAQPWQk6BLwFtASML8YPpmAlhGjQUbAQJNTQwF5a1SyKo1xfRFhYtxcCn3h8B6GcdAR1GbmELzPDpCdc6Iepx3Hqbcy4CkzH9vCoAZKuq3YQUZ0zePQ2+tvtyq8/ls5pgoxacQa4YEH3WwwYPqdI6yA+NZi2vHkt0FXT6KXZEyTa5nm1QYTmnERiFi5wDLTdE48cwFgxs9487qoaQ7hB1H1ijNqQY0uAgnFdyw4MSh/gKRezJpkc5+fizwgrKH1j3fnPYVTvBufZemC5BWbvXnNsHpXeDyLeOrL72SIsPFfXMJuDFe4efGMOnHtNRBlbmeE45rSTCbaQgOB4DqWAfnXgw0relW64yA0FewZUWKbrZGdFMX3cEh3Fwj
 iL4NbnGI
 LzDEbGr0Hy1wMsDqQxdSHS/wuBh1WaTMD3eLlq3RBFT/Qiz3HK3qZKe7g6PrL8FWN2m26o7j20O5EcjJD46JefRajRGOxacTGWS2ib93/IKDVKckGsobK/ZEQNLF6tWLBHY3O71M42EI9m9SccpgsrqbvCLsO9RY6iZJ7xd+NvNt1qgOYFTtSiVLmirHxrkNXiLUZ61+ZBu3hUlRATy1Ot+kWzRMzBthew9BLg7JFOlKiYShPggCTTY+DUppublUkSNh0DxRhtTZbvXnXL4QV5WBeOIIzO3DpattLYOqFRI/5MTJRMi4HXnDNvjNgcEki5apIqDw4aPaGMGvWO/yIX8EfrHkKbtxpA7se
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 16:42, Avi Weiss wrote:
> populate_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
> pmd_alloc() fails. These are page-table allocation failures, but
> insert_pages() currently reports them as -EFAULT.
> 
> Return -ENOMEM instead, consistent with the subsequent pte_alloc()
> failure and with the single-page insert_page() path, which reports
> failure of the same page-table allocation chain as -ENOMEM.
> 
> Address and range validation failures in vm_insert_pages() continue to
> return -EFAULT. Keep the later -EFAULT return for
> pte_offset_map_lock(), which is not an allocation failure.
> 
> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 11bb4fb98761..16093479d341 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2438,7 +2438,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
>  more:
>  	pmd = populate_to_pmd(mm, addr);
>  	if (!pmd) {
> -		err = -EFAULT;
> +		err = -ENOMEM;
>  		goto out;
>  	}
>  

For this patch:

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

