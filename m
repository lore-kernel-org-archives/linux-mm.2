Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D91C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 13:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A416B0088; Wed, 16 Sep 2026 09:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570B16B008C; Wed, 16 Sep 2026 09:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4888F6B00A1; Wed, 16 Sep 2026 09:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 197CE6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 09:38:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CA3F120728
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:38:21 +0000 (UTC)
X-FDA: 85219729602.30.452F1E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9DEFE40008
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 13:38:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fx3YHqgg;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789565899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8O/kTujFJZONtx3CvzXCpeeJEvu3qXIvPhXpAUcAqVQ=;
	b=OBB7bqoq7VqvCPn+WBtmm2eJlrUaANxFr/lCjOX29YD86Uri3AkxQshUVt4dbI0STkMze3
	WSQTW6Rr/dD8d1gwAQNiCAZJodosVQsKqQucYRCf8tOVTsAG/AVjLbP6A1qjv/x+L0V9pk
	OQRLaxHMTygc3wsgoIBzWCzKMfqJQmI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789565899;
	b=uXgPxkkKBXfCBXP7auUeXX65GieZX1WdQXKHdEz0lDrxoLFF9igS464MKdSOGsFMM680kI
	ts52304f1kekI3HDWN53p6vokxfmmzbC1pDu8TqOGoyb7Txxc8JPNW5qx76TorTfzB6phF
	Q2prTsVo/3SfKZ/ykXUzqc0TNKV13c8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Fx3YHqgg;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C4E64602CC;
	Wed, 16 Sep 2026 13:38:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333591F000FF;
	Wed, 16 Sep 2026 13:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789565898;
	bh=8O/kTujFJZONtx3CvzXCpeeJEvu3qXIvPhXpAUcAqVQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Fx3YHqggFxvjzHFans8rkrcDlx1fMvYHzrGvqOo+1s026Bzc8WI9z/avq4l9D57Zt
	 dllGsX9dg3RqDjBmvjZVJZiTSraEpfgGcoGm6BywAYxpmHfOwB//Wt29SD5euw6se4
	 +aFDWdLsxUm+bjMjEgqVSRcH5tkRmlji2cP+Zn+mrmZCSi3aN7WujfWTRarDIjw/fA
	 CmDX9ZWcv7rCHbtX1KIXxfmPMjudO06rG6W5dwOYiGBoS6GtIW/oqvwmb800imD9ri
	 405fUEYGBFv/DiduUnVedCTInxho8qbJ9C1xE1DV/H5gm/saOZznPOOqscQngcrGOU
	 4uowKDeQAAssg==
Message-ID: <05a7ac7a-b7bb-4f75-a395-6854874fb8c7@kernel.org>
Date: Wed, 16 Sep 2026 15:38:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/14] arm64/mm: Route all pgtable reads via
 ptval_get()
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260907035030.2839978-1-anshuman.khandual@arm.com>
 <20260907035030.2839978-3-anshuman.khandual@arm.com>
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
In-Reply-To: <20260907035030.2839978-3-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 7butfwaut3qztogggj55388nb9167u6u
X-Rspamd-Queue-Id: 9DEFE40008
X-HE-Tag: 1789565899-871843
X-HE-Meta: U2FsdGVkX1+tqy7K2Z/wXebf96AmsTrfjsmoV5yL6S7J38c+5FsRcnrb6AqRFcbl4cbYiFJ/5eIslq2xvfT9TgX72mBF5PO/U/HIUX4RV/7r59qZ/2R+CNTSMi0SMpBLpj1P38lgS3MkGOvK+hcSv0cdtuix0/kemFKLxcYRspN3OFW7iImiMVUSf1Lljessvkb4hGF0/TwZ433WrD8aKqHLYfULS4gFPyV5AUt4L8coK0Zh/Z2mzohCid8HxqC/PfcAWMqYejPlx0gDRzpZKcdCMvAV7oy4doLtj1NNylcaKz9X+v3iL1H8XQfWkwa9meFeQwBsWudIGZ0X2l0ijwIhdRFdfA5I73uy6not8g4EY4TWt7idBnZkaAehNYWdB9V4A+ar2xGrgYFhGvMftVkrB3X+jfwOkYuA6IBwg03hqWurAa7+sEn8Rixm5Knzlr9zXX7kI8QFP5oR205mm3KnfOgOOXjqs3ZF6GXY3l2/X+x/glMeyWznrNRXYPXiZSf/XPIm3eYbHd3MmL9twxuhR5E8tvP1zocMFugaRiKQ1qVyOawdKdbutRGwhnl59IEdd4GOe3Orl2+TbtOkXsNkmCgtVooUPcMDD2dI3lQ3RGbTDiPPCenEukBqxyqUN/VYNF/A1tGOh0YwVSEat+bHqRL/UGYa6eV5ZpTWjrZpOnb9vH/CfN9tQe+YHaVj9pul3gejzCgC3MnvMYT05NvVtom9+AfVHRKqDcFldLLxqaW1mKZD/drGOTuP3fJF0Lmi+ng527rpJ43nXvOKgBU4Z/0Bnw2OgE4slilQfa4HoSjWDeVnEsQnOHYqVvTDa9ZJIPm6wS9A0BsWPDZdlBURnoBZAEfw/mBiKQeWagU8S9GC43RJeqrQ6hqicHjmNldAJPN9a+fpiqVQxoaoOnnzPrdsXdsMJpPOn2TZ8LL/t7g14Ks4D7Ykl7gi1QYUBQ2esfTqn5nr8teiHQ/
 L8/WHgQC
 zp4Axvjy4wB10ymiyn1eM137veBHimlt4Tosk8Nw1qVVRvdeQIi6kBc4QuF+mGtPzaDK+xf/dMNSqN6amlfJW1Cr5OBu0UM6TXEny3W6Qky7CqHTiL40qraGIufdbXrEtwFfhi5/5BQwr0MmzAjYLjVaMSBAGT0zboGWZwD8fXAxQrdIaKp+TrRLY+21YGT2EBAjjzvj+Dc0GTS25FXxJLyfMHcYyUfgRmNHjsXm8nBw2I+rEhugVbYyy3RKn5xlYdmtHxbuMjhlPlDImOBpE7eQCBOaO3roP+0ckphAsOH3AI9pt/kigZceP7F48qxvV3pBrFOS0+f2U70s4y7BO3wmY58F5UOLbpdvlW1nVXb+bOWBt4M60QqOWWHH9yGdSFGXZ+h693nSu8MxmQWZZZTQA7xqD5124BKlN8OtmEFa2GjRdadvymvY8uZ3j4jpXLvUp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/7/26 05:50, Anshuman Khandual wrote:
> Define arm64 platform specific implementations for new pxdp_get() helpers.
> These resolve into READ_ONCE(), thus ensuring required single copy atomic
> semantics for the page table entry reads.
> 
> In future this infrastructure can be used for D128 to maintain single copy
> atomicity semantics with inline asm blocks.
> 
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 38 +++++++++++++++++++++++++++-----
>  1 file changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 83087b70f192..f764132ca34e 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -84,6 +84,32 @@ static inline void arch_leave_lazy_mmu_mode(void)
>  	arch_flush_lazy_mmu_mode();
>  }
>  
> +#define ptval_get(x)		READ_ONCE(x)
> +
> +#define pmdp_get pmdp_get
> +static inline pmd_t pmdp_get(pmd_t *pmdp)
> +{
> +	return ptval_get(*pmdp);
> +}
Ah, one thing: you could pass a const pointer to all these read helpers.

-- 
Cheers,

David

