Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 015B0C982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:42:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036076B0095; Fri, 18 Sep 2026 16:42:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F290B6B0096; Fri, 18 Sep 2026 16:42:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17816B0098; Fri, 18 Sep 2026 16:42:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEB0E6B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:42:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 31B251207E0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:42:22 +0000 (UTC)
X-FDA: 85228055724.30.14CC1CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 788E940009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:42:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1OMWLjk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789764140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7DJZ+YMyz4y6+e3tw5qlknVYqBVKK0aejFZ6SnY5DE=;
	b=mhc98zweRJZPv9jv3n0o+6flg945LOMmlc+XfqEx7xFYaxYrhvZCX5nz9p2oZFdvL+z8Lb
	hZH3rT5YDTxXR+XFRLRJo+C5Z9ncguL9/RgZmIhO01hdHC1omSJNq7vSQPoGhNG7+ePPDR
	+gk+LoTq0GWH6P7t8BeIlf1kXg1orWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789764140;
	b=jQJ/7qWFDl+waDfEIvFeSOPfkd2Rethj0aMBFUrTVr8LxzivIny3hB2Kpn+y8PWy+rwCoe
	2GRedLRRpk3N7/DgwUMjT+4gXU68yRZ5badvjPgFuzhv98SE1Glmzlor5R53wuM1vIrNv/
	ctCIDvOKePptl4uAcpzZd6ioSSThZms=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W1OMWLjk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C184B6053D;
	Fri, 18 Sep 2026 20:42:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBE71F000FF;
	Fri, 18 Sep 2026 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789764139;
	bh=q7DJZ+YMyz4y6+e3tw5qlknVYqBVKK0aejFZ6SnY5DE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W1OMWLjke5dVKM1Z49TWdMIy8J23eUDrg4ySHj3komwwgMoJi1COcHqkTEd0eXHyO
	 4PS7oLK2G5Wpkhh9R1F8wyMZnZFXeGg05rJQNCQgMHGvxzn+zeW3PQGcwC/bYs6tpt
	 d71InlR2HNN1fKC6ZbIPL0qcATvcCPSY809rh14gH8i/Y0Uo8Xdrav3NazUcxj2Jxv
	 htqcPOzNmHeYgJZnAU2zwyVOGS4rVO7bjR21ezaaOQ7E4MkBLCaq0AU9u3WuMic9vZ
	 wOYZMdvzW0ImoZRlIIwx6vwN+4Nx7J/ltTtcD7cXblwh2XyHjnEal+GG+cMd39BTdM
	 NDg6ec4sdgzBA==
Message-ID: <a817fe59-8549-4e5d-9ac8-ab5cc9e214f7@kernel.org>
Date: Fri, 18 Sep 2026 22:42:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: refactor find_next_best_node to
 find_next_best_node_in
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 Balbir Singh <balbirs@nvidia.com>
References: <20260912030424.2889731-1-gourry@gourry.net>
 <20260912030424.2889731-2-gourry@gourry.net>
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
In-Reply-To: <20260912030424.2889731-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 788E940009
X-Stat-Signature: mfkh58h4xkoh6nij5nqqzcni6sccr6j9
X-HE-Tag: 1789764140-625899
X-HE-Meta: U2FsdGVkX1/gQAV2ftGcTPeE+xg5iXsSM8eyn2Dfx2bKM19oaQanNyuRwMFts0Rj2ur7AmrbDpkZ4ct0e2phOD1ITYWwTAjvEWrYUMOM9naVCHB137ScJxgzR7p3Ryo4P4v5/9TRK2aMRS/FX4xgO9tG3owTQMRLdHi6o9aktiJ3XVCpiwfghfdgrOK/7PBaFs/Rm45bMrN/awNzz+zbrhsa1fyTvu6YtZkz51XCdSu98PIHBV8iSL63SdOscpOpTc9UkvzDGXOr+zqzrXb97/YqQaNnAYE2nWYnAbf2l65q3m9Xcb9KAQvzkAlb7BYgJkBKDQipVTe0yxxoRSTlQJIBH/0HPA92XM8o77plBKmfeOaH85zLsyQ1lAtWO/7LOu2esPtqtRh1uIfFwGnS7EvVozNw8+QP//0MGnfRE23TKOcJwBwUcwOtNzryNWTM+grmbDlEZUEnA+381W6mwQoyCVv2cQlcn/yDJIladilA1DK+qhL6s4s+1rxcnkn0/fPHz2gRmAtk8EYXgV9AVdd063ThTQDIyXmi1vC8y6HxfLAyLi0VumvsvMHO0oWLkZZzbFfOb2++mOoHhVudE6jJ3vd3+K0NHhRPUUeKmdl9o+jZ3MtFan6Si+Ijh6SeAhgb8SRfD9usS3zp4TCt8p5wIQhjFuuhCjxghjweT3enM3dI0HbKA4nIITuEdNUhxAzP7IouEGZApO/SYhrkHmlB7Eczfu39PvxmZ/Ba1GQeLIApClwQ5DL/5xvJBIZvBKUskjxzpT+ahViyx4gAlEwKVc7nOSdLezFpireBoyXuwd3fZrOsk90XNQXtyfP8s2eNXzD4SjyfVy+laSG8UrZqx6YHhP74g8Bnu5KpV+JBpR47jzdHDvKD/53Dnj8lbLY+PYHuCpvwxN9gfCBnE73jQv4FhHbAl35n4tMSG49CEPDq1oZUKE2Nq1rV5D2gSOZ2pv5BI0fQA01M9x7
 w+Ah735k
 an12E210FWyd4y0xvuk6mc9BmpVQ3Hd457Q0a86KG0LroKHaJ12kiXTE3VJ2e/TKuvGBrsl9NBqsaNX5f+MAZpH/wdzh0wGq/Y5KDiZWaFSph2SPlkIOF7EsaiNlfcKbXLSXeRUZnBThUrLzXWajimyB32zuHlDqv98xMjKsEBlQaflu6a+Y+364DD176hsODCfIRoSnRbi+3QmsS22oKaGdONY2XgOcX3rdZHS6l6NZwbYNBCdLPUbboG/uugw8D+iyy91cae+G/Ezud2/peexEkMXpCn9Iyn/G/bYlmOD2qqJ/8aIBmDp3fnaMemK8YeVtwKYgZyXrLSJYFX7WpBqyWq/EVoMoaYxR8ljZ9QGEZxXWvUBSa0AdLRIwqBHPaxV9jbQzxZwKsu7CxrjccvZyCgaJHtLKJl7yb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/12/26 05:04, Gregory Price wrote:
> find_next_best_node() picks the next-closest node for a fallback list
> from the full N_MEMORY set. Refactor it into find_next_best_node_in(),
> which takes an explicit candidates nodemask.
> 
> This enables building fallback lists with non-N_MEMORY candidates.
> 
> No functional change: every caller still selects from N_MEMORY.
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---
>  mm/internal.h     |  6 ++++--
>  mm/memory-tiers.c |  7 ++++---
>  mm/page_alloc.c   | 13 ++++++++-----
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index da14c56fb24e..1519dd21a900 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1133,7 +1133,8 @@ extern int node_reclaim_mode;
>  
>  extern unsigned long node_reclaim(struct pglist_data *pgdat,
>  				  gfp_t gfp_mask, unsigned int order);
> -extern int find_next_best_node(int node, nodemask_t *used_node_mask);
> +int find_next_best_node_in(int node, nodemask_t *used_node_mask,
> +		const nodemask_t *candidates);

Just curious, for your use case, wouldn't it be enough to pass N_MEMORY?

Or do we expect to pass other actual node masks that are not derived from
node_states?


-- 
Cheers,

David

