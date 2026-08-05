Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFDEC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6C06B0095; Wed,  5 Aug 2026 07:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BE526B0096; Wed,  5 Aug 2026 07:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4046B0098; Wed,  5 Aug 2026 07:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFB906B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:05:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8516C40434
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:05:12 +0000 (UTC)
X-FDA: 85066934064.16.0ABC412
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C9F9840007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:05:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IyFW5Nf0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GZl7SSQPVN/Fwjmd+7QLkBqeP/PoXu+55xyefpGesco=;
	b=mwEEYg1Aum/uAEonxqsYc3g2UhA8ChlCFMxBcQqcm0vss1vtMVjsj0T/hsX2OlVEkbIoa1
	GOYrws5bers38SY+cEYb7ruL9apGNzEmsxo+HsQ1Kok8TwfIAf5nHrABudQkU+1czVfN8z
	XuBAzuJfViaXxTJh2kU6/cG0ogg9tRY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IyFW5Nf0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927910;
	b=GUjYWG+8OKVR4agk7KqEydAgUVpFSdhClnsvu1gGd7KJ7x++CMPrlbt07db9CAxy61/L8U
	J10VRUutKCuILby08qwN01spBnKL2aDHXJBxtIDJN+2MsYMe1RmO4bY3UiCp1Bii0rCOPZ
	+/7jujPcozLZc6TZjdMXJfBGFl4JNaM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 592FE600B1;
	Wed,  5 Aug 2026 11:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EDB41F000E9;
	Wed,  5 Aug 2026 11:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785927910;
	bh=GZl7SSQPVN/Fwjmd+7QLkBqeP/PoXu+55xyefpGesco=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IyFW5Nf0gXQiRi/fU02tCPI8mP/+qkJFU8We4YixfDRk7cR9P4ZVFCSsmXUvgodHU
	 oy6rE7R2XZ9YWjNy+VLFr+DWsQJ0iSvgZLErqi950JGHMner9Vr/v8XfuGFTdArnWD
	 B8uVTOsDFUYJkSoY+UshUV2ged02YroWkvAK2psHITJ+ST60v5O4HnzttMlSvXdW5f
	 B08KpzJrEP4qay7omAMy/V1pNP8OBFPgN4sfBMusNuBgDiKwxvu6xFArbj5hrMXdty
	 QE615pJnHwdgk6sRdeR4cIWEmnPC2vsJGSySPIet9XykJ7/T8OkKUnNymFUga2avsT
	 Isgj1KJeVGt5Q==
Message-ID: <720f8b30-73fb-4983-9bfd-96fc22ebee3b@kernel.org>
Date: Wed, 5 Aug 2026 13:05:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksm: update comments and docs to reference folio->mapping
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
 alexs@kernel.org, si.yanteng@linux.dev, dzm91@hust.edu.cn
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Hongfu Li <lihongfu@kylinos.cn>
References: <20260805105927.41987-1-hongfu.li@linux.dev>
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
In-Reply-To: <20260805105927.41987-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C9F9840007
X-Stat-Signature: 17o41aqwyzkwrzmq6tmmketbke9pypbh
X-Rspam-User: 
X-HE-Tag: 1785927910-648319
X-HE-Meta: U2FsdGVkX19gFQg8MWUJ8juqfyPmbKXGaZVqV2PrMj1q9AytWSQECyRonZLOqa0Kq/bcVev+XPhTCirMxeOKVOKzhLxQi/UHDru8USXDNvP3QDPqWBd5V7ZOEg+asxGjayV8CTGDMJKffiRpEHh0i7LvUMBOpIzGeE4K2049yh79GOBqAuseAtDFSqOLB1H1QPUu7dyRSK/0dQqv9ll6oqILYMbUE+JHy07YiqDzHymJqu8jMNapKfNsdFlkaeQo8F9niJUl9ohuwM0KMlkUjwZEe0CbJrKUoWBeJqhruzyY9GanzUTJuScnvUDJFMBXkvao6l4sfX6Uhs1MLeoJLFEbREg8d8w3lNsR9gB/eQiH6dfGDhx0vUhbfrrO/xGsReVaHqDb45Zd7q1JW1SiMd68J176YerrsiQ7K59Cc/dk3AuGkO53kjnYlBTn0X7h2d/VXL0PLXY6d84wlxA2MZklaQtX7rsEFf3ssvuGd5pJGJhOsR9yAjKLdTiEThOPAHEs/saSEapKidwP+Jdqq0DqIU6T/RymCtOzS5gylAsXdihgz/ELrlxcUZ9+fdBbiEQzK16pk8e0kluOUx7nUAk5eSpSc3sGIcFhA2yWLt/lvJuQUv72AHT4gSczIJKGLJNBCKNSzQ0HGgr1iM+cGf4Q1RTZs4g+LtaIrdP19FvJZ2hMUJKCJkoLBIthZ26wUAZI3eWQ4WXP9xTwz79g1DSs22afl4tySDPVVzfPq+F4q+Ci9c7vgl5kZ8VYCPWgOjMWtoX5+EGcfBJSBu2vAB5FnwTAAELFBMfCiQrXVttZGl+/Q+uRUa8aukoDMUQBBzhuP7q35/Tj2oHe/NGOAN8x2joAM0AfZDM7EyjkEAkrVWK6EDbrdFpo70+vWcWCDuT7U1EHx4OjlgFkWro0Pj4/Hlsh8UV/D0spP69jqDtplj0nw7R2x/Oz3xtDJa/WH1wQmt+GLXkzq0wCly7
 WBiWI2/V
 hEyL+P74MSQ/JgozWDLPf2fhMiUTL0CDQWmf6Y5P2fgCCCbuoWzW63BAT5zPfhSjrApk7IRQMy8wSakjDKyrkMc8K69EkiUhgmwYlVGtqpvKyfYmfjMazrMyHP6heiKFR79oA6wmlI8yHWwOy2rQBesfgkIBoBdX1RH6HBVZ4vuf8nQWlp6owLWDsUVHYDw6vpDudw9amcPZs4hIgzgVG4uBVcrl+6XRXsrmQth1NP41P2K2+A0lPt2tt11/2Fuod0Ca9yjY0Tw2YQEbc4jNXDXANMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/5/26 12:59, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> The KSM code already stores and checks the stable node key via
> folio->mapping, but the comment in ksm_get_folio() and the reverse
> mapping documentation in ksm.rst still refer to page->mapping.
> 
> This is a pure wording update to match the folio-based implementation.
> No functional change is intended.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---

No idea about the Chinese stuff, but looks correct.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

