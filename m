Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C815606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dQ4HpzP5
Received: by kanga.kvack.org (Postfix)
	id 9C18B6B0633; Tue, 24 Nov 2026 03:19:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 972536B0635; Tue, 24 Nov 2026 03:19:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8889B6B0636; Tue, 24 Nov 2026 03:19:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 591F46B0633
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:19:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D38F2140B18
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:19:28 +0000 (UTC)
X-FDA: 85469313216.08.8DE3381
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1686540009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:19:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dQ4HpzP5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795508367;
	b=zzSr//qeEPRfy/6mYqH1JiFUuHMgtL/YhqEtLUoxgEvObhn/M+7ngKAOrmSOzJESLlSGai
	R0IxBazWFJkGgEIRbwrHw7AiDcm6g0ro1WPvuXuZ/TWwLBE+6isMMohUVsyO8eh8hwCUoZ
	qoPZxdzXdQoQj/MJP3bxGsxi7cgVjEg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795508367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7t46GtfKYZs2wgNzk1b5xHB67t1z4sEYiK0JuNv6pys=;
	b=QY1AMjHkFfy7qcM4FJBQ3d4jkTmMuwu6Bnjyslqc5wvzaOl4EG4zmtpjQ38lr++J0oKSo0
	s7I8Zhg8cUnuqShgxglPaZ5p2+a+sFD5NciXC/SW92mjX6STT2ajLCD04ye19dqg4T0TSl
	Ub24xPaY/rFr4xXgbdEk6s2Cy4tz4YM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dQ4HpzP5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 384324169D;
	Tue, 24 Nov 2026 08:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67431F000E0;
	Tue, 24 Nov 2026 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508365;
	bh=7t46GtfKYZs2wgNzk1b5xHB67t1z4sEYiK0JuNv6pys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dQ4HpzP5ss/BkmY1lgajd6O3tC4evTSFEHoMJeRIfTep1a6UGDkcE4cXVSypPbqM8
	 uFB+NFcTZzy4uFbRwizrG/3PVyHmCAWaPInmYgg+env3LCr7A8MCo4zvRXHqjuTw6U
	 wwAb4HIT8GXewLyiRDAdULX9puLybQqkt3snnvg1CwRncf4lcwSpSpvEcJzOc/+/+j
	 85FKwE3UFDw8fNvhfjtzoOM+l1oQOw/CzMYz8a/wzJm+D8TdklcE2kg6TucqwRP13o
	 JBi+Tfl4f2WzjP1aGneHbxukSMjX9x7pjoNEIWF2JD1C+HK98alOiF165GbBz16A7/
	 HO3lqBHcPLKSg==
Message-ID: <a85333a6-761c-47bd-9d79-e1309acd8c00@kernel.org>
Date: Tue, 24 Nov 2026 09:19:18 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Docs/mm: fix stale split page table lock references
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Qi Zheng <qi.zheng@linux.dev>,
 "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
References: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
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
In-Reply-To: <6E11B4A6A6E0DCF9+20261123030904.57369-1-zhaozhengzhuo@uniontech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1686540009
X-Stat-Signature: c74t4icfpozppcdtmfsfjqrreng7t6bh
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795508366-721062
X-HE-Meta: U2FsdGVkX1930BGz81pmmoEuidd79BPUKYl2V/YYLNIs8raE5eI5VZFqm1uNsrPgiI1eM9njMshHimBxlqrNfYNyfNjbNK6N5jrrqAqeLULAzpD1yvM2yY/gb0uBS82d2igmg7ve5B8v4XEf8qfC8H53/nUetL3gu0+TBcw0mApeP3LY1VYkaX/Ql6y4PeWlduSMAF4vIEPRieg2etDfZNipGR+oQLa08HIpMQsahZhUK35jY8/KlDV90e9srSPzN2rXAHgo46K6dsCeLXlrQa6A+q7+O8ORt66RXdjppumr0kfLu1UXQuwVKJeK3QDDLQJNXlBh2U8UmCoEeq+wdX8oIsbcC6iGJzk5dYoAa8SjjZhG/eyA1/MSqQijwB7/ac4oI1amrZDc5FFW/Bfie30bgqejIiGeUvceVGDQ6XsV69lIuv7RFC0RYRnkqI8EDNm8TVt+jwWUrNY03l2+9mJBPCXQWNfWKxPCbbnloQJbaLQemleAkeMTnRb3o4tvEEvjAvhVNIHGN8sf1NXyqZ+YywTWHDLV+CbQXLR1viBInfbQpfoUTsUMCNiM92KgWlfPwjy9zd8BVOVJC1tD3YhafWrMt7SR6+iEbxAprd6BiHSmrRseWeii511voYGxIgeMTmw05qsDgRpw/jb3EKOo6C4VKqsp/XZ0E3QjJz9f88LGpPgrpdNwnpUVwWt/3p6ujOglhttzVQnx/Ep7baC7g90TAGzz5m/7WYDnK6cBnavUnmGY20OvCgUzijp1MHQF48EaIe9wvA5CuHcyLDGVelRemZYCEzmlRa0zIChXF4TzSO8tOZdj55PZ2kx/BvUdj5h/3ag9Ni1xmJX3Kkx9OS5Zxy/iRUTPZunJauXDs0vvhaj8OYZr9zWtZrglkmH92EHveFkqhtElBKh5cF6Dba6smOoLGP88/nAGDLxxwWJbKIbW9ZRgAjY0QxNUVVyejQHSQv+n59p0An+
 XSnJ9Kk3
 wF3z2THKsZpdmAzwjWvMf/AX1Zf9huUtCcHeusY/lv49dNAutpieRVGN/3zF+IiBBBBoVz7YhuBP2fA1t/l4WjpOqNG473NaF7jQWf1WKYkssdyII8tux6o5+pP32Ujzs6VfPgq5aCWjWWopKyYtPTD+Hgtk/W4cLKWEYOtfkLmW4TmIdwEHOvkOz1ZEzt5dR+gI8GYPwzRnyqOU/LSlulLM2uAhtZjfP4Xrud4dF12MnLMASNfzNhYE31FQebi0nmLvw780g73mrPJhhsbV4HNQmij1WgQZFgQbXsI8/ddvCEcgrjEQ635C4e6ILU+bJ8csYxExb92Mr5vHCRAUuBE6O2IaAIwYsZb23D2QiKOBveY5M05yuUxMkstqiwtZ4hl954+gjbayYDPBLDetuWpphDon5DuRmlCrJ1OaKh+5XevEkO0X/+A1BBG+2a0z/boMeurYNC6OSHdklSX0mTr8JLUmwdtvyc0Cvn3lqhCvKuE2LBlssS8XfqeR+IjtBnRW7WDEIkmLXRDjK+pAUOp2qvLXdWRQ298WfDUV2s7ObCtBL9jDwDCOPFDPG01lccdE9LfoaqEWrjJ/tOP8II3kJqg+/ryvWth7fOuyKJLtVQNWziXsDv2s6pFchsEncpvc3yb2mnKY51B29nGOr8Z27yL9gGl1qBnj1CLBjuoUBfrQ3gYXqvur/bg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 04:09, zhaozhengzhuo wrote:
> The USE_SPLIT_PTE_PTLOCKS and USE_SPLIT_PMD_PTLOCKS macros were turned
> into Kconfig options, and CONFIG_SPLIT_PTLOCK_CPUS was replaced, but two
> Documentation/mm files still refer to the old names.
> 
> Update both references.  Point readers to mm/Kconfig for the dependencies
> instead of restating information that can become stale.
> 
> Fixes: 394290cba966 ("mm: turn USE_SPLIT_PTE_PTLOCKS / USE_SPLIT_PTE_PTLOCKS into Kconfig options")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

