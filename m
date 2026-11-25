Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04482606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rli3cwd1
Received: by kanga.kvack.org (Postfix)
	id 09BE86B09AE; Wed, 25 Nov 2026 05:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04D016B09AF; Wed, 25 Nov 2026 05:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7DEA6B09B0; Wed, 25 Nov 2026 05:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B27616B09AE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:56:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FE4E120DC5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:56:03 +0000 (UTC)
X-FDA: 85473336606.20.AA8BC29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5A79740004
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:56:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rli3cwd1;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795604161;
	b=Xpp+2pzrBWes3UfIWlwAGqbGS98DI56/VASVyWOVzA3Jis616Y/oE/lXo790+4alSi9t4K
	1fQlh9sOKhsdtAVkJQ9SUEJGzoXhwPycm30qvQYhtPlp4IvRU2NN6Tq5TxwGjGG3RCyRr1
	9/FDAVx7DPOvcYttOJoaFkGYQKU2tNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795604161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcKwm+PC2oDss/qALgoRn0YywMnPEGuXahvnTyKgtEI=;
	b=ql8m6QeD8u/+VRg7W940LNEDabyjAdt9ka0FMOUulQU6Cvjqjc6xE9D8OeL3vRi3qjFlXI
	GWoeVyRiy9L/adsXuK5ApiYezH+GFO24zEphtN1HY0BYYlQZTv2ije54Vi5U6kf+Suyfl5
	HB4JG5Ui2Wmt43Wt4q/gVF9gigjN9pM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rli3cwd1;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 806D341229;
	Wed, 25 Nov 2026 10:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8802A1F000C6;
	Wed, 25 Nov 2026 10:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795604159;
	bh=YcKwm+PC2oDss/qALgoRn0YywMnPEGuXahvnTyKgtEI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Rli3cwd1VTW9HGGNpZwbB7fHK11fmjZ3LjpEGs4COCE31jXJYMyVMgloArINIvzn5
	 7bKvU19albV4pMBk4CG/3Ya3XsJnDRisjhvgHfxgbiFWDe5asy7BcAoGs83rHeFctL
	 5tOCPemLWtiUvr6HkIAFTFWO3krrfC1WKO67Xsg+WvGu6uHadJdYZWbxDCqJUp0j1p
	 1YUVSXVHkq3UoTFUAeWdbjtzEvZAFo5vt0QiB1R+Tl5W2U+Kwbk2XsJQmpTZthpJR0
	 DxBBaOZCH/XKOnCWze0BxWM+S3lp32HN9CuJtFCw+JihzamUQKZDoZLYag5ktrtvQ8
	 HJDKsXObjlbCw==
Message-ID: <8c60bed8-6857-4361-91b5-c8fed8a083c3@kernel.org>
Date: Wed, 25 Nov 2026 11:55:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/khugepaged: use NOFS while collapse_file() holds
 folio locks
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Zach O'Keefe <zokeefe@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Dev Jain <dev.jain@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Hugh Dickins <hughd@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@surriel.com>,
 Song Liu <songliubraving@fb.com>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20261125100058.15200-1-azpijr@gmail.com>
 <20261125100058.15200-5-azpijr@gmail.com>
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
In-Reply-To: <20261125100058.15200-5-azpijr@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A79740004
X-Stat-Signature: j8zcouitzzzu5frgy6oc8uej8zc9y1hi
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795604161-738456
X-HE-Meta: U2FsdGVkX197t+CFzeq/ajWPrfjb8Tn6PfMPXPAC5Z0BJnQg6l1onvdxylfXWFLwfs+6IAIQV6nzxZLCKJHhlGw1Lmx38DFBs6jzggMT5LYzfQTO4/ahnFpRvuRza7K4b47l+MFX4aK+gx+iGblzX16XvKbnYhmkyGqRyg8i73Y5WCTWfRUnfO7gKasz9cjvQ3RsbUFO+/RxWSzf2qbO3NWwn010JMnhThtU9FXW/i1Btl//o4hO5/7lvBhMLCx1MAF3IJBwiRqo/l7CGbAwh+efek6lYqQKUoyCwl25nLMjhJZFNcYfv+RfEV1IdQ1nM8PqRu6si15W+xsoISKyO1V7ymNVmRrbqV4rcKQqF3QGoD43HMTEHo9CIaoylziCkgMGdoS7Sbro8Cynm8rMWspNwZ9N9dzzzZ9VDWL5hNyPuPn1biKmndclgObXlrFAeCjlfZphklx9v+huIpEDDg6rSqWToBCLv6DSJ5qC5sfZCrzF6//+6MLgaveVW/COPZ4rQdZWCdG5vHjRNE8Nwgqd5QFXZxprcxqGEOk76lJXj7kBOTnA/c54/lqIZTKeKECpe7W7OjoVnl1Tz9RyCWycnPN5huEnGNB4KFs+q4Hrpz96UjxfvLB5TD3EAKujmpFRyyf+XoaYA2NxNVe1y4qF/PQXtFLSsCv07RhFNg80O+6+XC21BynsXlET9Y7wM/loPDgTmFYm5UYi0W0Zq/GoA60XDjw8Qwp6HWuwz4Rp/IFOpdDalsjPpYp1+qSA4eo84tGGk98OPQdiy8aBXMQuelKaPu8mD/bpWhyGwbhsbK2aVdkqvYtfmTBVv5HNLZtPURcjd341jEVSCzkVY+QSAmCag+UMYs8k6v35ldapvXtJ76tD/2CytDQ3ZQ/XmITs3iJG0aHkyshIYPuQdsa+zh7jAq/nOz0ni1+Ggdl69cOexCM809rO17zsxCwpttnBU8ZJoCwmzvJLaMy
 JCKNrKHC
 t8wCgpAEGJn/s2MaIbWnERYxIs1Yo8Q3vUhyRZkmyBeBLSIvS+Mvy3esVxc+y6QQEsWbnc4tT3zFRJl9k7IbrLaQDZVLKj37yCdc/BYdTbL8g5OaWhPgcJWhbPxWD6P054lZ6BRzolzukWy2oS0zdrRoPjOqTLse9N6X3sPf0rgKSglDJ/l1x7JfnrqoMdIGeieGEjzYIlxJ6WWfAu9/ImWoPiH4Ey0pMq/dt9QSHuGT9y4V63eFXfDwJPb4G8wO5aR9uvZUaVZC1haYTntE1wJzlXSoUhvDOtTB2aPeW/H60BcQBKhbXxDi6+W3OQ2Q2i1TLnaMGKn0d85voVpUYybJTum/nWlsenYi+zR9YPzQMiExw4hXOJLB7OaZef9gBxO5mzscMSfpHH/by3ynpaZEyVU/3b6NpicKy15w1758jveEt7VohtaWfj5CpIYwWqJZtS8Tv2NKXAmLt8qT7uBYxitOr9sKrsddceYRvLevv7WZ9Gscq8YR13ySEX3HvrX6EsAvE5BlHm2dDRgwA9bFEZmcYSL4Fg4FVvQYqRWuCMAZzogBhdQNZhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 10:59, Jose A. Perez de Azpillaga wrote:
> collapse_file() keeps the folios it collapses locked until it is done.
> With those locks held, it calls filemap_release_folio() with GFP_KERNEL,
> and for shmem it swaps folios in with the mapping gfp, which includes
> __GFP_FS.
> 
> As when splitting folios, allocating with __GFP_FS while holding folio
> locks can deadlock in direct reclaim or compaction, and __GFP_FS also
> lets filemap_release_folio() wait on the filesystem.

How is that possible with my fixes?

-- 
Cheers,

David

