Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9F2DC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5576B0093; Thu,  6 Aug 2026 09:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5FF6B0095; Thu,  6 Aug 2026 09:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96E6E6B0096; Thu,  6 Aug 2026 09:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9F56B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:23:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 714D0140754
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:23:37 +0000 (UTC)
X-FDA: 85070911674.26.F46BB9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 95A658000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:23:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2eEx2ma;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786022615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L4LcJVaFqlDOl7/6fb8sSfmGw82F1oBvobaOAS4s1uk=;
	b=4/3rKkk95Nb3oT30ECccJlngN58TQ/sXW52iEU0V79fjluSVYyCx/al8vA/CTRHL31oi9j
	d612y96NG9Bo1bMfFB3GoXoQH/ArtQktVI3ctf64Hdj+lQQPvJzfeohto+wk8kzRE7sNwj
	ASt3BRG0FY+e+7sB0IWIx+VLTVS+Syo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2eEx2ma;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786022615;
	b=IksNlP5NzcPArEIYNF5/hn0iPITauGa/B7ni5abURDHzCgD0NGaJJquBpdADq/whulyIpX
	4cvl6JxHCWz1bB3L5ylhSLms7gyOKqZlKgL9TosiMd+tqNTpOX5CDyfn7d4AMaOPyUE95b
	Tb0GGsuwbkO7WrSyCM/k0keO19/Kqdc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B8F09407C3;
	Thu,  6 Aug 2026 13:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E9A1F000E9;
	Thu,  6 Aug 2026 13:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786022614;
	bh=L4LcJVaFqlDOl7/6fb8sSfmGw82F1oBvobaOAS4s1uk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=E2eEx2maGcGkEKpDYhiHIrHt+9ZL+nhKRdvN9H0sql/6/6o6gPH5wg6p0VdCkn9QD
	 WgD5SOSqCpdSvM9pGGTN3rm2sAUJxPF6Zra8tOKzAsnkR+a9FC/6gYrqfsIJqbepd2
	 DcStQUuFZJopgkMta8O63YWvEbylzOyj3qZGjPsMzCc42AXrYNlrh1SozlgRfZm03G
	 aFMlYzGKLhcRFi0a6rvVaOh6eQ/u3aD7ntZBDqzi6qjBotDJVH688MuYsczaGyn5Rc
	 xTgkYcXnWtAjrRp9re1J1YOf62sZcZJQ0BcN2rwdEhddDH4I5kM5Ns0RiCBgB4+G7q
	 Cn3pyXJF6Juuw==
Message-ID: <0b22acb2-5684-4ed7-a916-d531bd5dc410@kernel.org>
Date: Thu, 6 Aug 2026 15:23:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/madvise: skip zone device folios in cold/pageout
 PMD range
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-4-gourry@gourry.net>
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
In-Reply-To: <20260728194714.3713735-4-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 95A658000C
X-Stat-Signature: wtdeypc136fr55jo3rmok3c66ch8m1wt
X-HE-Tag: 1786022615-700009
X-HE-Meta: U2FsdGVkX1/DxplkFo29VHCEFq742qKVs6+Z0Cvs0UjbHCH+iTCksuzRIdN5F4p9no5RuQymRwTs11STgJbXDwtnVoxs45VBanYZYE21LYgGuFyeeB9iobCDIcDzV3OnewswG0ozEVDb5iEBWz/u+zBsTonD9ArI6O/y03WOSoUQ7Ylo4UW12w46mOcM7TcKf6mtDLBeumuUl0MZQ9voxsNnqLgCamnsRmiD/LQaEn4Oniw6pvAjfwrfSaQNtt/28C522uAN7xE165HRSQRSqbXrilSS3LMCgBBQ8WDrtxTU6pX48bP/7U8ZcGwpJI3F/lnhL2kBFGWlU8JodFt7M0MyH4WtNyp/T1XKqb+XuKb5FKpL5dLAL7lkiOHwlRBNpXqBtC47hFzjdAigFVqSWzp3ScjWr+JvLoZYDqV3oopB/wwPhtfTc8MezKzeSoxfknn4dv5m/IEdhXsqV3CZ8AxjoQ6Cch7uzv8x0Uq2baqcgGnEwgVNC1SsSFGpCAAEo53dd8tTrdPiQoaMZ2wffa+upTBeYueD0ys6unx+5Km8bAelgQ945SnCPp5XeT6nJSc2mHmqkSRDGav37neWL0K0cuLiVIDIcVJGX1FU2RTpLavfHSHCrBdyYbBMsLI/Uz0ygTMpxyc89G2Aml47lY04ABXrtxyL7yXJdtwhTg+8kkSBZiLpsQrQ6pDePXMO0+kcR24s4jbhPCbUi+WbD+jYhgQC/b3ucFC4YHPnM4iQy6i7oAyvRukcNhxz4w1diNU2kqdjrVQwPLbORfnEf4HGk+QVanleL+ZoT6YmNXygWUV/kzR8XI6iRjvwI339FxpQXoAWJBc1eninDndNqMuMIz+Uzy0pIgDfQP/k4nT5Bx6WyQsqkkVqEfLJLUJMOvb3Lw3vcUfaejOZhFQmjDe4KvNxR82LnJKS9b7SvL2pOO3yYdrmHqcpvZFijZ5SWg7jjNSlbv/vv0pEdAp
 fSC58Zk0
 qpcwnGQFwQ+55MBdlm94WysMwK/vH/1lSN/BnhHraleCY+297xnOflSX5ARTIh/jD6OBNL4KZ4xgiBP6EfaLZlg16CS8ulPn0rt0u3Hr+VIXzW3josIWxmPggQkV8nJKOgvG96KeqQ7i9MbZsPGslwYy7bcEAgGnPlZLsSOSty0EeAsDz11nvPzGMR0+4df4Z645rk0cZ3PUeNs1+hv2PcCtOZ9fmGLwGI1DV79dVQMlVz/T3t7wZTAbOOa6xgklpwM1N5kcZonTYBc2fsfwFXtwoH18kbNJQvoriDDoq/C1Ywgob8n2xeczpoEk1ufYMGM3CZ7XxnSbFhhWL0DunkC/Pbf1NfVplzCTie3WafgUDWRqH9Mq8I6N+j8dY47TNYYC9ueoZjWewUfMz5sM6XgIk7MT7GqMSXkHn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 21:47, Gregory Price wrote:
> madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD
> via pmd_folio() and ages or reclaims it without checking for zone
> device memory.
> 
> The surrounding guards do not cover every zone device case:
> 
>   - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
>     (so device DAX is filtered)
> 
>   - !pmd_present() branch above rejects device-private and
>     migration entries, which are non-present.
> 
>   - A present zone device PMD - e.g. a device-coherent THP - is
>     not filtered by any of these, nor by pmd_folio() (unlike
>     vm_normal_page_pmd(), it performs no special/pfnmap check),
>     and would be aged or paged out here.
> 
> Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.
> 

No fixes tag for this one required?

> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/madvise.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 07a21ca31bad..ffd6a68320a8 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -395,6 +395,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>  
>  		folio = pmd_folio(orig_pmd);
>  
> +		if (folio_is_zone_device(folio))
> +			goto huge_unlock;
> +
>  		/* Do not interfere with other mappings of this folio */
>  		if (folio_maybe_mapped_shared(folio))
>  			goto huge_unlock;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

