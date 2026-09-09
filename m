Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29EA0C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:14:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 415496B0093; Wed,  9 Sep 2026 11:14:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EDEE6B0095; Wed,  9 Sep 2026 11:14:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306CF6B0096; Wed,  9 Sep 2026 11:14:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE196B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:14:34 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68309C022C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:14:33 +0000 (UTC)
X-FDA: 85194570426.28.6CE8446
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9483C100009
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:14:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/gq2E7S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788966871;
	b=RXyi2llAyEFxQLNkH+9J3svg+IvLRvyMaivPRe2P5Wbzcla5ZSFN6ckV1s0l2kYYNkQc+B
	z3Be51bb6ZkOskapNpRzPdvNnDJjOOteKQblpbbm2Fq5bmUSonLVAPfbqJnYIjvWH42rtr
	3myuM0vDGczGOwDPnAKR4kJvZIe1kv8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/gq2E7S";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788966871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv/OdspUGtQWo1tas4EUrtKin7DPE1EY1vQkzcPdvtI=;
	b=YShDJH/0XSTLlRoHUBGfZo9/BlPPZPovk6AOwSMX6sIZi9y1mBu6nqC4ycoDyszkMet+xF
	AiJkgbtxU0Jx+qW+8fFuQrK0f5O63+xQK+xLufTf1pQRxIl0P+ze+q+Pm3pyYyq18qztaw
	j1aiFLqQu/20ryzjvg2MITvDL56DqpI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6FCE54019B;
	Wed,  9 Sep 2026 15:14:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA221F00A3A;
	Wed,  9 Sep 2026 15:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788966870;
	bh=Kv/OdspUGtQWo1tas4EUrtKin7DPE1EY1vQkzcPdvtI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L/gq2E7S2ygrCzOjjfrwr2/GUgw2QA8h6flKLJ2Ed6zKRBUvibImsO4f0zm1Cv/o5
	 wu2fstLod+x2eQRi5BkACBCFuZs1LTAab9jQ0fKAt6VKNbbEUAYlKsGmQTOAMnXSxr
	 ZLlaQAFpiI9zSRjDaKXFo2voDCSapC8Fqe8da4P18MLlxscCWsq70cr4kjKj/q2Ck+
	 qfHDyRvdDds/u94zuJxLZ5Un9zDx/Nv7YJsD+tzjRCwiM1QQGUiA+Om23dMuH6FU1h
	 pQk/9ir8ZD/jbALU9VH2F//0i8UO9PECjhQVwsMEQA+scrPmKkVNB/OOe2GUVZTbOg
	 3WfXfTIqzMo2w==
Message-ID: <b058dbec-060b-4f19-8048-3951a32965a1@kernel.org>
Date: Wed, 9 Sep 2026 17:14:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] arm64/mm: Standardize printing for pgtable entries
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260909040005.4148136-1-anshuman.khandual@arm.com>
 <20260909040005.4148136-3-anshuman.khandual@arm.com>
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
In-Reply-To: <20260909040005.4148136-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9483C100009
X-Stat-Signature: 4jh5p8nfixc36juawmw13ycbiwpf6nx4
X-HE-Tag: 1788966871-715169
X-HE-Meta: U2FsdGVkX1+fIrNSdjaTrgFushpnlNTkEjeUxzWPPigcR3FIiR+uxR/xwEPxE57YXEdVztrcV5KjLj8srnIvoEcJGF6Cjr8t27pVav5oIb4EhYWzMZ1PgvfvqksYfN+yIZFfPWhFOTWzbETwAxhCV9FuDc2wwsWFlB5FZcxNfXLatz7qtRT0RS/si54+Dsy/I43yrGamtVlDfqqJ4wzQSw1Ucl9uCZYiAr5p/7UPETQ0JiqYcBJwyfna6GDBl25PEtaCQFvux7FW9x4bhBs3OKZ/MJoU9GPQk8cZbjVvOmAvtLgPr4DAwT45alCGydTLNfXLLtZhYi1I3PT38vFi39wqKb4/F2AROPFA9ph57/BJYSpx4luBmnc4JA5YZxpLJWa9rrsNqrPFRMJEu80alvs4QcjjT/uJHIASoWsywh8G86pwi0tHlAvmuLfFUJiQy5BopISh5RiZQgngjpGulvqZ2c0K1CEANmUyK4JlqU9gmCm36E4QPlkDyQzZIBeMuOqudeiaUDecW9UwkadHmm4dyuECLUu5migK3sHAkhP+EUlkhAUTPsfhnWuFiqVC7bsL7fmwhxW2IpldeYxWYnqYsA5Rg6bP+ury1cynK3i1EB2KOZctKPVzLdmpQ2XxE+twU5s9rnjlpnTdto4zSPWM8ECLq+bYfzcJKiiMJIF0r4I301sg1V1qxeWxsUsFzBdNVnzcds7mZqR9Hg+3q5VLLDqmEhT3sovwXXdoyZTpKeKc/9ONKF15ls4iLDTPCi6qyhX8RUOhtp4gOiCtRB+IsFmeoSsr7XJiCc0+2ZZJswiHpAtAi62hB/7v6+IhsHIkQ9ickhRq2TV9RXFbIH+mykaVQ0DMAluX0BvF/wFQCvC9K22CC9hoRyhNyQ/bBpHtmPAWQdpB/K46bPRyBxYFv5/9+dRc5ERfE+T4Q6Llzo08HS59aUIEmB6YvzedsH6DcdeXmxIBPXmZkS8
 +JEqcuJB
 RkUo8p29Vsivv0r1kg8luJjz3mEacitI3Sefd2u6vBCPpTiQAToCVHNwQ27KZmj+uQqUea0cRV8DKKwcIF8CDJwjU8Dqla7U8k4Ve1tcyF74wEgaqvgu0+vvkJi0AONvpTPhEfsoHwPKua9q+YjmCUzywnMrKEo5UfRwGcoh3QE6Oe1ck1vIk5GElAuRBD1zE2fv+bQHbpu4Gq1FpxHbZZJkpYN1j6BoBOHwDuq6uvyoxIEAqsmC97ZGctx9SUlE7ULT1fOzveM3w9fXeUPZy6LW1AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 0b2d190d62c3..26f4cf7b753e 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -2411,6 +2411,8 @@ int arch_set_user_pkey_access(int pkey, unsigned long init_val)
>  #ifdef CONFIG_DEBUG_VM
>  void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep, pte_t pte)
>  {
> +	char pte_str_old[PTVAL_STR_MAX];
> +	char pte_str[PTVAL_STR_MAX];

Nothing jumped at me; once the stack usage does become a problem (I strongly
assume we don't care for now) we can revisit the approach of moving printing
into printk.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

