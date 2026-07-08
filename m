Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 523BCC44507
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:12:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC0FC6B008A; Wed,  8 Jul 2026 09:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A8A6B008C; Wed,  8 Jul 2026 09:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEDB76B0092; Wed,  8 Jul 2026 09:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7E63D6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:12:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 120D2A0149
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:12:08 +0000 (UTC)
X-FDA: 84965647536.10.863B3C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EBA980011
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:12:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ncv/lTIr";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783516326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2xoTJUVCMoAA0S9QwdA/2rHDyx2S8Uo8HqqZplJCTfU=;
	b=Al5CN01SJD7J7gSMyX6GZvquZNKR3BKO65U/0j8ruXdqLfHVy6aKcjqmokoLIVjCjjDg5r
	qq1uDObRx+kZ1giAFcWGVct24Nd5e+486FkBWmqExygl0LgER/qPVTCsSLoLItXmpILNnP
	5G/2o7VUD+cyw7VRJwn1lo43cNISwGE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ncv/lTIr";
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783516326;
	b=KneAad7qPLIQGVER6M2Qw5FnHvUAecD+zGvyhYj8iJsjXAhrsYXcSiPazr+SEc7Iis5jzo
	RuQElOuemQ0OOjait65z+Y1BCgmpxlzIygsfk6WJic5+NXwYFsdTtCONmaSy0RlkHHSjlt
	W1BO50+qGvuDr00gjyDo/XwfEg2RLFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8766C43AA5;
	Wed,  8 Jul 2026 13:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE1851F000E9;
	Wed,  8 Jul 2026 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783516325;
	bh=2xoTJUVCMoAA0S9QwdA/2rHDyx2S8Uo8HqqZplJCTfU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ncv/lTIrZk4Eu47jjFa/0pc7PWzz9gHW0qPdQR1xTsVinQsfV+Mugp3a+N1Ojy74s
	 9wJNnFKACFz8xG3pH/rfJZgPXLJwuNZ3ID4sBDXjDcGUAe9r+ZG5/sJkqwP3lC8Pom
	 ZkHwS4+W7mewk8oT/lyAvGr3B8tiAYH+9K8lRVGhRZfVsgBF7Cap1maGcEGAdQBpDC
	 NdqkG0EC5hSnvTEw9m9RgxHm1sBxE8GLaAeGYpJeHWrB4tWMGumSe6YMliFRIIsluC
	 Cd6RueppI/F9zAFEFDHXOQ4pOcOWpGjuibK2PMBnCDlv5alOXU1XJExf2dOQhwMcnM
	 fBDxYxKevuGCg==
Message-ID: <9450b10b-3340-4261-9a9c-3f95cea3fb65@kernel.org>
Date: Wed, 8 Jul 2026 15:11:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm/huge_memory: skip device-private PMDs in
 madvise_free_huge_pmd
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
 ryan.roberts@arm.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Cc: stable@vger.kernel.org
References: <20260708122040.861335-1-usama.arif@linux.dev>
 <20260708122040.861335-4-usama.arif@linux.dev>
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
In-Reply-To: <20260708122040.861335-4-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d6rzb3qkg3kggj5ndbqj94yjb6y14nfx
X-Rspamd-Queue-Id: 3EBA980011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783516326-45300
X-HE-Meta: U2FsdGVkX1/73MGKDbcfTPLEU0LNoi8FZgrWNaEuFbzxAgXkKJc6bixntPtoEkudgHB3miqAnpaeNM8z5Fh5wqhgUQ0Lty1Q801G99WdlLfRfVSb03ldfcq1NDlZLg6MyIf2rXKS4CaLHgZKLVLTNBsLbtd2QCMvLpK1yEJVbotVF5r/ko0X7XesP9kebSOJHsHxlXD60tvjXGgGvqmUnFaObCSR8exMRxVuR5WT/CVhYD7NFGKA4bpqCSlb3MiRpJOY/nhQ4ZPqUckz/5BR+lfm/js+9U9Z2CDWiWlQpkEDhAAC0zJy+0iU730X64cZx7tMJQ02zmxnrYz71+k0oNudB7FEwBYZrs1TOAFlv3ri6FRI/Mp9fmiwpMCYj5KkEYzrMJtBPHAS+XuRhcCTXMUDCwu1egj7O03MugqJawvKB0PhhpknVPVYUTwvsVTLAsKDePVNxtQbRc3xXzKFwnLeCvbSJOHigrqg0uJ8yIInP4Sk0b1vPAYM6/dwJsUVN21pGETDLFED/rMFVVG3g/kaBhsY5QsI9P8WNot/5IVFXuA2ii8FvJIPMP8Ssd/tQmp/k7aJzF4+Is4ATmTbATJlrpWFUn1kIRvturkeMvuq/QiijHOKFhAngedd3Qw2h4SPu9JU9W+lobmZP490+bTSyBejEyjJ1AHCJJ/LmFy4JUREuRPWsqgnUXQN8EZ3qoYcmjcrMIR0m3o71LJhpZ4DrxL2teNthhBh6ZEOJVyB2Ve3CNObuhNYa5Fv/2CHkTBOnJ04sWszhWg2IAplCtnmLpgcUbDbAmSaC1pMMLlewJg+bEs17eHLLDFZxMbpyX3eQ96XNLZT11WOrz/QTU6yX1IGFsyBoc0xy4KW7kDvlGa47+04dmJrl/nckFg0kcqE1PEaST2a5TzDpTciN5c+IIbgtBSHCNatdseqxWsWHH74o0l3pmsPMSXzYiU3DhVDv/i6gXgjwCZRJvI
 Jqr1fPGc
 Mc0QZKAYao9jhUuMVHa5qaGEKNK2ldBWYM2/dMegiO2OwI4W/431eRsUaHXyoZvnq47OKTfzOC6Lr7VOOqJjhH8gIbEJ+z5+bx6KLz3VDTBqFwdIQ4QV4gHu8LUaF5tWKRYfXWLj0Pe+St6gbbBpQClkQKOkyOZTqZCN3CKeCksolyPQiKaj5KTFr42c2rImEab6rR9Hn63yJvrOUB7B6PlsT1FhPLvFLJSEBzEl5elkQj00MEkf8+JOzTHAgPUcNIB+bQRrAOMbGRR7D3F/7aAF1JUXslTt7Fdkyi++MS23FcSmEGicowbgpu60NqFnvmGMd5CrsO68cfvKc2FieHVw91FxFFKjOi56UYXUovln6VxWe9ceS1QlMh8q4ARdiXfGpIv//jBFbA5teSLqbKPi3usVKd6Ikj52T75zHYk/03Hr9Gs/bFP+u9LA6yeNlUPzNEuIlHeFb66AWBc5ZVNnJIIxclJPmUF6Mb3umXAOt8VTjJcHvtGacMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 14:20, Usama Arif wrote:
> madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
> madvise_free_huge_pmd() takes pmd_trans_huge_lock(). pmd_is_huge()
> returns true for a device-private PMD, so orig_pmd can be device-private
> and enter the !pmd_present() branch.
> 
> Allow device-private PMDs in that non-present assertion and continue to
> out before calling pmd_folio(). This keeps the assertion for unexpected
> PMD softleafs while skipping device-private PMDs like other non-present
> PMDs in this path.
> 
> Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
> migrate_vma_pages() flips the PMD to a device-private entry between the
> caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().
> 
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c0892cc533a9..ddbdc83b4cae 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2298,7 +2298,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  
>  	if (unlikely(!pmd_present(orig_pmd))) {
>  		VM_BUG_ON(thp_migration_supported() &&
> -				  !pmd_is_migration_entry(orig_pmd));
> +				  !pmd_is_migration_entry(orig_pmd) &&
> +				  !pmd_is_device_private_entry(orig_pmd));

Same comment as to #2.

-- 
Cheers,

David

