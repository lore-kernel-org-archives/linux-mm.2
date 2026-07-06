Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1AE0C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 09:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DA46B0118; Mon,  6 Jul 2026 05:01:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D650E6B011F; Mon,  6 Jul 2026 05:01:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55B66B0122; Mon,  6 Jul 2026 05:01:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D3B26B0118
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 05:01:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0611BA0329
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:01:03 +0000 (UTC)
X-FDA: 84957757206.05.31D45FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2BFEC4000D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:01:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwoRmujM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783328461;
	b=O9oLN+WxW3fOPvnnJzOIQfZh+WWPr6tpAmygVemYSCwxdSEhoMw9QC8gn2ZVszeMhmjeaz
	woOj0G8YnbFJoYuWhPmeZ0qsKCucWwagj+bNmSSj66hGnj1b8AbDs6xL2pPqSt5ReNRT0B
	w3tiBrIO6kWKZo9kFWWs4Sx5+LGFLPA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwoRmujM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783328461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2p8nkhKN8t9mp7pTmf6Ynt4ux072QpIkTobc4ZCA18=;
	b=qQf4nty9xC4z4NYmopQEESA+Dhc/vwpFig0OwU9gM/SZu5cTJP6WeIJxesAzXl5XNaTW36
	L4f7dZMDzYgV59NKOF5rkDbMkaV/n4dmLaWowyXXeMdCTDB4QNYgtt6/D/NeDYiqdyB3dA
	Qo8MthFEzhjuAcPHFnSqiL6L20VT6Sg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FCBC409DD;
	Mon,  6 Jul 2026 09:01:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112BF1F000E9;
	Mon,  6 Jul 2026 09:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783328460;
	bh=Y2p8nkhKN8t9mp7pTmf6Ynt4ux072QpIkTobc4ZCA18=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FwoRmujMe0ome16BLJ1D9b/TMcpeiIFUYp2tOrucgFjRkQnsLoRRy+gVwGwz0lqpE
	 gnCbDR7KeGd33Vybq/kdL73A3Q5YE1YPSt4y9nWmf+4yKY23cUeEZ0jK5hugA/V2BM
	 n/lmz0Q5WUiQB3FsIrl3vM9vgx7QjaWWpk0HraESZhimqgPh2iOgYBn5vdZcFLJPKL
	 /jGe1RqTf+uR0vORchLLNzz3YnK7obP+U8RcMgNM+KkPwcK0BAio3yL9eZqvRHo4/X
	 qBPLI2aODq/zvKv7qCwZEhrrFmfOmpFA+l/e8EMw5X9hKunnZ6YKVC/VDWaG8R++ry
	 HMFNkLNe6SONg==
Message-ID: <461b067f-6fa4-4539-882f-1ee6fbca5583@kernel.org>
Date: Mon, 6 Jul 2026 11:00:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] userfaultfd: wait on source PMD during UFFDIO_MOVE
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
 aarcange@redhat.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
 riel@surriel.com, kernel-team@meta.com
Cc: sashiko-bot <sashiko-bot@kernel.org>
References: <20260705131231.1499198-1-usama.arif@linux.dev>
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
In-Reply-To: <20260705131231.1499198-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2BFEC4000D
X-Rspam-User: 
X-Stat-Signature: tkupgkb16i3goqjdthizp3kwgtnetsxa
X-Rspamd-Server: rspam03
X-HE-Tag: 1783328460-230822
X-HE-Meta: U2FsdGVkX19TUwTh5Gea19/F8NNpfTSnRKMHPBdfaXCjnsrUIXr7grJQwcC38QlaXds9LIABVhcjGut61EoMbOZaG/dGcdIwJN5TpOsPhZKhw6NENAj8GI6MPAoSTN+iwub6qwmnZsYhX6PKG/XxFDpigHHMWkiY8yAc6vjlcMRlUCb+GffI+yamxMMUQhfyc6dDK8XKq7J2pWb/31mXjgYLuzFuyi+jK+zGy+0uXmN42BC5nm+tlXSP56RPmZ1N3eGCys36uzxDHOgI4oc3N/gLEniwLmMDAuRDMVJnVf1g5ANnUcZCSNNZLgAg35+BH5Y4XPBHhGQZa/+duWey6Zbvo2NgsRo+jsPf/6x5f6Nb/sXJhMgW7rAk3lHMoxRJnzBDTdKu2m/XZYGjaWAE4dhB+tg9g4y8Lrc8OVRiXcnA12bR0RBJrTYCqCHjK3n97+ZpvFN7Y0ZfsogpGbMkmfH4db/jspjNqaiWEewPUYcVsS12n8GUw2hp/ntW157vPiklahi325gTJyENIm7vKLZ7G4Vnc4HPD2PMPFXSS0dQJJgqqR9eH7VDcb+jXJxc3GUWfmnqDqQWOu68cOm41MvftG9BRn8pq4Hf2OiHgj+8oToWN7DasMCdmWIXUOFwa5LbSsS6ExymQ52IDErPHhvJFfKezFo54baGvupItE0Rzvv2GV7BZujNo0Gn/H+7MWq5Z1lRtfNsTEpWR8s1E+UWspmkMCBwX9pOGdNpZZk0CaqbvbfPoaX3ZxD7lPv51z0UA9MlYAQgmp9HrV4GYv3tQF8alJ1WpfG2sKRy35pVCUC//19NktLoqcIpCrIGBH7VI0sUFSiL0pCtz9icaIsy0Ba9LhfKONC5fMgm5oC/LoPGh9/RQxxSIXK10RIGvUW76U6oYcMou7M+tRK94p1DpVP11XZwOz24FlQhkOlQ8JYuKwqwLO/TFuR8nZxRdDLXUzYYERmHsgUidTC
 YHWdnBbH
 xGTwQT+Kh/YupYpyfBkHfSZtbhQpvu+h6aAsd+spnCwrZLb3HHm8YFRIgu2ydGz9uvOE+QBZyhuN+lDP1dKHPFpl/+FpB7hkGNMbH/0jChywnqgtFbVrC0YKAkx52CTsxqDwDWOnxWhh0buYV6k0wV2U63zhs8weWVYc4Cz0nQ0aYAS1zdqeMrazFc6hpCb3qygbxFU5M5fEeAf+Ak4k1pCTGzv5MR5v/ZfPbBA3SDmimd31WnP9Ylffjrc1+GNARZ63vf5XBJ3XzgA/Gj7h9ULFrSR+xwx2oAeuES02KRqE7Bf771DOzLzSZ5FzSk/m5JYYdYexFZcT1Ytx7C1lquKvrtDVbF9MpUOvKY/ZCej48Y6lUAR9u92QmnrhPFqSuYznu0uwqmNO22CA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 15:12, Usama Arif wrote:
> move_pages_huge_pmd() snapshots src_pmdval under src_ptl, drops the lock,
> and, for migration entries, waits with pmd_migration_entry_wait().
> 
> Passing &src_pmdval is wrong. pmd_migration_entry_wait() must lock and
> re-read the real page-table PMD; on split-PMD-lock kernels, a stack
> address also resolves to the wrong lock. softleaf_entry_wait_on_locked()
> then waits without a folio reference, which is safe only while serialized
> against migration-entry removal by the real PT lock.
> 
> Pass src_pmd, matching __handle_mm_fault() and hmm_vma_walk_pmd().
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=8
> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index bdd8635922f9..c0892cc533a9 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2775,7 +2775,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  	if (!pmd_trans_huge(src_pmdval)) {
>  		spin_unlock(src_ptl);
>  		if (pmd_is_migration_entry(src_pmdval)) {
> -			pmd_migration_entry_wait(mm, &src_pmdval);
> +			pmd_migration_entry_wait(mm, src_pmd);
>  			return -EAGAIN;
>  		}
>  		return -ENOENT;

Looks good and follows roughly what we do in __handle_mm_fault().

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

