Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F89606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a6r7XW7Z
Received: by kanga.kvack.org (Postfix)
	id B3F446B09D7; Wed, 25 Nov 2026 06:59:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B161F6B09D9; Wed, 25 Nov 2026 06:59:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05696B09DA; Wed, 25 Nov 2026 06:59:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8526C6B09D7
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:59:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1772F40EBB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:59:57 +0000 (UTC)
X-FDA: 85473497634.22.D9205A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43C34120003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:59:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6r7XW7Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607995;
	b=Da8mXD1M7g5RdcirxmrMUsE/d3rN/jCkGwmkmcP19uSvU33rfGJOusDjel5b4PjkkIW8r2
	ID+3iqUS3HNbBPPc1rgqCF5pTFKX8HfeFpHdlhgkmMH8GBdlq4UcEYeYcOTuKGpSYJdvPN
	jrAvF4tzF95Gjdf0DdLLbMTPx7ISif0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e2BmeS4KhEEO8j7uMzrYvr+Q/f9Vk8XnoewXXH34OM8=;
	b=UAlGmajB+ChqxBzwY6Ov1R2I5GmzGgVrjTXAJh/Lgc5K7U9aVaRkhBOgfoLOya90N+RQ2O
	IiQPZ9NM18z9GDF7hcpc+jDgY0zKikiOtbrC9Ea956TaJRJH2cDVJOt0P/j0PfCXAxQDxo
	txoBJY4f7vhI9YOyAgf3wHjT2wK2lfw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6r7XW7Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 174F7414E0;
	Wed, 25 Nov 2026 11:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BF211F000D3;
	Wed, 25 Nov 2026 11:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795607993;
	bh=e2BmeS4KhEEO8j7uMzrYvr+Q/f9Vk8XnoewXXH34OM8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=a6r7XW7Zg/xT790o8tnznyoC2aZ0ZOKVUE4lD9lxyNSztg62L4l/YSC3ZlnoC56j6
	 6ciWRAFE6L2afWaOEN4lmn+Cg9PtLM0WfHQH5nMKtokzX7A4uKVBzdUdGgmBBlaRN5
	 W2OCYympSTgLWJOi4v2j87q14DCyvZa3vpiCs9urqP+iacQ13cd48S9PA/PCl7LTCS
	 avhZy9sSb2PjJ64KtGWIDNRh9/LxOnobtWFBTjVo/czeIlPYbt3sAsSjXvJm6givIP
	 JGWszG0hq9mpKGs4LIp8CRaR419KdDKgkEnUz2iMii31c73uHMyDqUsLG0V0MJqnjB
	 cef4XNTAVf+nA==
Message-ID: <8633c17b-5f15-41d6-98a2-cb11f7f850da@kernel.org>
Date: Wed, 25 Nov 2026 12:59:44 +0100
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
 <8c60bed8-6857-4361-91b5-c8fed8a083c3@kernel.org>
 <66fd4450-6e17-4a1c-be76-38758a62073a@gmail.com>
 <413a7751-a368-42fd-8983-c3b44a86fd0c@kernel.org>
 <286006b1-9f9e-4661-bd38-e5f5fce9646b@gmail.com>
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
In-Reply-To: <286006b1-9f9e-4661-bd38-e5f5fce9646b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 9s3cuwnyw5cgo5unqxnfx5j5ywdgw5a3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43C34120003
X-Rspam-User:
X-HE-Tag: 1795607995-180717
X-HE-Meta: U2FsdGVkX1+82hQb0n9wwA0XwpA0BRCQc5P92yrtJI2FaaXOmtTsXjH6eJ+6ojncRrwaFAqKwht6f+IPbWYK0Lityuy5rhjq+xIUuvcGRZvFFPm167YjnJ6HJ3lkMg2QUGmrmxXbHTwrLiN9Cj57TNb900yqYA0Tv7V8n3L1xzMa35qgTfSq7RYHoDes1D9fvZ05B9djgh+qsKwUG/NoWf5iSI43cpjSTZjj9RMbINbXJTsCr/M6mgiior+wdLe1fGwd2yhH8yfzooRgEhWskjU1+OK1Llra7Sn56JQC+cI9y9+8ovfN7XfK/e6NUhfg19bVjwJFeKU6/sSaTtg2ar+GTqPjWoZINfL/GawUVHOK5y5b3P6O673tQ78TE+8gYSvoIelpi/pBysXmkZMhfRZuq1ve+pY0Dt1HC2gGpZ1mrdp5O4+k4IsrauFYkougzfa4UHUuHnD//lbSB284TFvf7hbfOZq4lZhweYWGByJpvQFShn5i6FSsfELmYpLJe4CZ7gXXuPJl3oYotizXY84kW9pINE5Br8+zLgs+h9E1NLJhT1NN/XVgwdvpsifsmCJJbYLTGf/pzD63Qoj167hDxTYAjq/pSqGS6YPXMZgwmpfk33Lij65hDSABbmtmEjWdp3l8PtF5j6h6EJxk21I+DuV3E2R5Xwfg1uC2uX59zZ7MrzuKsYx+JpsGUQHZqI1eO1NLkaznTMtk9fxQCjP+NW8AUv/lDxb/FGwJOPr/JSPuMKLMttNSIhcPE8vyYKQGYNHfa0fXiSN6tvoWtFBBGg5Kc/ko5NJ0agXq+aCm5JrL727Xj310Qzl83aa/TrtwahUms7e7QtyFCzV8fUwKCLUv9oMqtV4paPhfH5PklIWGhHeqk2Qe04h2zi0V/eTFzrU1X2oYIsmMIrKChFGq4mqqDFhcUgFIQQccoQHX5Tm8PXqXwReR/SZ+jiqCAr3wQExTWPjM+IwLnqR
 Y4YuGzEw
 YqKnpyUC0u10m0DETJtA2mvabn9HGS2xNLzUAAuoyh8xNKrXSNLbmwdLxhI7usjP9qwnkmYim5F87BMtWjC32UDu9cpCAA/f/5VKw4iBUrAD3IN1eNvX3YujmKxqRpcoDeQtnztV5PlwetRg1iRwtkJU4MRyCgbOc2RWkqvHiZ2NPjCMNkyQP3jjR1DTDhXOqrd9K7kucIm5w4tYvzY+Db3oq77iwoXCkrk7jl/lZW6ZCKSN9OF8HFjYV507PUPlQyxYuzdta+qjgAX6Kcbr2hqq7+CmcCEK1hF3T5C70dbuWY8QTrFPQltP65XSqOv39pg2IzEnhwq5iKp2nEIUhXtlmqb93swbf2oRNOZzDAT7VJxrWdVzE/lsgMyMLB0jP8LdQVNSIh104n2CVaHUjl8QpZBOxv3O3xOBEkIT/N3UmE7JCiLGZ7d4HDZS3vlmcsIQo6miu8K/GL4dm8BCTHyOyN8CPhA2IkZNw+UN8yIesilaKAvziRQ4fFHVmSYK1Dy+SAXmHcaAlqm2Zpy2uu9ekKTdizu+l3RT9BjX5AWqMO+LLyVwWi/AMcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 12:34, Jose A. Perez de Azpillaga wrote:
> On 11/25/26 12:15 PM, David Hildenbrand (Arm) wrote:
>> On 11/25/26 12:12, Jose A. Perez de Azpillaga wrote:
>>> it isn't, sorry. I'll drop 4/4.
>> So there are no other allocations in there besides the one done by splitting?
> 
> there are, the shmem swapin, but they can't deadlock.

Okay, good.

-- 
Cheers,

David

