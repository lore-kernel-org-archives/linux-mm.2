Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76905F483E7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E686B0005; Mon, 23 Mar 2026 15:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE61B6B0088; Mon, 23 Mar 2026 15:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFC006B008A; Mon, 23 Mar 2026 15:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A0ED16B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:41:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E96F5CBC5
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:41:32 +0000 (UTC)
X-FDA: 84578347224.17.5C7B732
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C6C814000A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:41:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZnjMTZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774294890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7nNJ3BAekowrS4XPWW+8eLq6NcaLKFfA8E1wRiQVavk=;
	b=MChidSDgmO6NPboebTrtZXtV0xU8m1bQtMSltqESykUKO0qucumma3erUOQ2k7eNpbu677
	YCcPY915VjTpWtGwt+xr6JbYnJi0I5MgsrMmpwsCOLpfEg/W9aDeuOd0lbv3BPh2auVYES
	JxnoK2Chk+nsby7/AM9qNPg0pdOJHNE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774294890; a=rsa-sha256;
	cv=none;
	b=VS3+YPWozceBiZtzmznEsXGh/GRZIiZEuCCrxiE/WVUA1vWElOvXFPTzwAdYHlFZv68KQR
	tEZQd/5XXhx0tV9OX3VHu6cTI2whiS0wTgZTdHGqJp5pmujTsK+y5rN80pzrdaD+U+qN9Z
	k5bYueCXtbnL7Dzi6k7P3eqaqxpx1O0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SZnjMTZ5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DF718600C4;
	Mon, 23 Mar 2026 19:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551B9C2BC9E;
	Mon, 23 Mar 2026 19:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774294889;
	bh=qRjQgEBmqWDfrJyVkQE055Gnm2yMES8kQzBysF5eEA8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SZnjMTZ5LxIrjc4nu60V7NpPS8Whjw2SHTzw237CS/kwg9MY1Euitn9FFSjcUxerM
	 vlF3zKjeFtSSORWCtwL/dEtgW+71lNE58c6RVvbGpgNeD1ME+Omk66giQ7kh58N0em
	 uofvH6X1dEHUJtuVaVKpMkl37BH3l9D4I978JOw2zSHob4BX6CzxFhmWkG4CP/zIf5
	 WQd6WlfBQOLlqs1AZPGWQx/Jsd6QpgYV9vN0Qy4WfBkSJawH2HZC/1ms1okG9/Ogl+
	 sxQqgaDsQ8n/u3TXtlz1xgIRkcAy1UfT2bJSPJ+TUa1PM+878yUFC2fl8K2mafpdM1
	 khvnlIyFIjIlQ==
Message-ID: <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
Date: Mon, 23 Mar 2026 20:41:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
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
In-Reply-To: <20260323190644.1714379-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8C6C814000A
X-Stat-Signature: tng643md5go4wqgd9qgxnh79odrojb71
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774294890-871925
X-HE-Meta: U2FsdGVkX18dUHYUdcYCLx4C/6Uc837ufJGDmneJqzAqgpdG7HHAy7TDtUblGIRzv+hds9PxvyFNbNuhEbyoJm+RimNZ9DWp5aqRHSVIL3M85b3GUnyVAI50p1Qxi+L3iMnH2O4S60vYfle5OEPEzY27UdH7nGtIoq7+MgX2ayfe9sERzskpRqUK6Qw4TSLt8XgCFsGQur6wRvkzJYS634HLNE7I8h3v4phKuMdr9v0M0TE0NlBu1UfXFykiGcAT86jyRE9VmxTQqb8NGiF8+UsrZ5ighS/wlo8e9dZm1CeDxxtk4gWV8BoBluc57nN6b+wDijzj6PUCM9FrXy0InGLUIeqssTXpMZ92lh8gxVDI8NjI0zqdmXEyURwKQpd/qjMJnQusJx9iqYReP0O1KJUMj91frjmy/sahsbbfxamKmgMfoV+QglJHyZOWDMC3bIo1AKnMppbXzwqymvuw+6t6DowfpYjrPjHwSZNkfpkZa3KN30fpbmgPACL/MfhUZ/Y654h9HZIZdnH5uLp4bEjyeQmXs374vtb9tFr4heqzM376IUlP/OWc3QiPJnQXapW2ImCktRWTH0PMUXw26PoEePH7zyQ1NzAlnJdtBW2jJByo6UVpG0tMpTJkeASGJJyBtDvMO6jCpmoDLYboStUZWhuGtCBHrJiLrW/5Dh00oRYnb9gHXmwz/XonhQzRcms+tmzCRivENcRsShMtRwYBTssGuVeDrpcG4qSZabQOQTdxZ8oKDWk699y2kN1mNdlXt1I05lRS3nsBF+blAl6jzWMYFn24FstVDm/DYnTJ0yez5Yc4a/1TnU14gu1wsUYDRoK06OZ6RNOzzPJqvJZgy9o0DsZVdAFdKBkSVwfNXgvmFVx3AfSh4jYjkwrNyGwMICPXG0FYQZgxF8B4qW8YtKlM/I5lZLBU4PE61yPxGUYK4bLbxPCyiImhciQb+NMMY9V8JfQ8J8xE9Qw
 99vsIw3U
 UQq54GCP3iBcP9a2j8PiKn1wTTYQ9v61WJogBhNnvhsFRKyc6nnpHDUrbM2RQHGHP4GhRMBZgoG5stxalLM6V0CwBTDPFVWsh+w2dOeVue1A/E7CrlfOY6Uahlm/NWJwP1esinul5mBS2zoNqAHxa8g8uNt8kNb/WPfTKXR/jHemilQ4j6fVvRZCV3deIeQeNdD5tsr6tIr5i24AGFNmm08TZ4cFEaLY/mUZL8YQWXtrbYV6UQ0eN9V3ETQo1/j+yAqM5blRRBRdPS/1XgtO+zBSZrquzRwKcFMscsoDhPQ8mBmRx1wN6fjehAQ3nzGK7lwl50Hr57zhnuMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 20:06, Zi Yan wrote:
> READ_ONLY_THP_FOR_FS is no longer present, remove corresponding code.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/khugepaged.c | 159 +++++++++++-------------------------------------
>  1 file changed, 34 insertions(+), 125 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b2ac28ddd480..39f0b8959535 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1899,7 +1899,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
>  
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> +	VM_WARN_ON_ONCE(!is_shmem);

Oh, but if that means that khugepaged cannot collapse large folios in
FSes anymore, then this is the wrong approach I suppose?

I would have assumed that we would now collapse for any files that
support large folios (in PMD size), not stopping to collapse entirely.

-- 
Cheers,

David

