Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3EC606A328
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kKjb+uZv
Received: by kanga.kvack.org (Postfix)
	id 9D3236B05B3; Tue,  3 Nov 2026 11:48:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA7B6B05B4; Tue,  3 Nov 2026 11:48:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C0DC6B05B6; Tue,  3 Nov 2026 11:48:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A95F6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:48:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0EB931C3B3F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:48:35 +0000 (UTC)
X-FDA: 85394391390.10.7F5A4FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B89614000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:48:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKjb+uZv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793724513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzxroPSjg7djG2/E7Jnxw7+FksX3byDhaT1k3G3X82E=;
	b=q+YG/oC7unEAG7uOd63dKzgLK3OaruOmdITDi9JxQK0Je3pQvW6FKTYfrhwudK4ZnxLwqK
	24Vunr67IZXkidVebwuOigu6FKki9DgxGRBNVvKVmuwz4hdLq6XiJbD3OuZvAEQ30amF8z
	PV/jmj2PnWAS+9OXCyQl3S1rzKZgNPI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793724513;
	b=boOiqt2CN3VSPVPLfeTtswFRH+HcOkoJPFAPkHuFPjE30VdlzY4fwhBoLGRYgOde8b9jXR
	lSQMoL7zkcq+YnzBDux3jbsDTtYDLQwF1AiF9qruKLPrcGxCYiWanY9fCeMv2vuRoPmi2n
	4ZDeBUIRQoW1+oNRl68Ibfe51kQWSbU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kKjb+uZv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 974FD60254;
	Tue,  3 Nov 2026 16:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5847A1F00919;
	Tue,  3 Nov 2026 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793724512;
	bh=fzxroPSjg7djG2/E7Jnxw7+FksX3byDhaT1k3G3X82E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kKjb+uZvI/3jfX+ELwR4splMxe7pwzFhYBfrEt9iyYiE1DL9agVZLgu3AJaB0Y0IB
	 cApJ7w8OpkUG+ML/D8IwVmrjfyjr86K+f/UdCFMk8NKuQLpd+e8GPXslyhq/B/x+dl
	 pj9IrnJGZQU1YkYGOwdnOwzZVlVulhz+D1rowr93yTki3O8fxTsbcjYqdVujZ2t14B
	 dsgoqZNxFV1Ss/jx4YEbSLc2rtu03+rnhS4BrlRc1TmE9E24lj/+ALEd6WUpmcMCib
	 MhO5IXpTxw9Z75N/06GFpCORtyDW5cF76LRcFDz193BlrU98AKGkx4OiQoSRoahLgO
	 gpAK6EE+MzGKQ==
Message-ID: <85bbc54e-4c77-4385-9119-590f6c97aa2e@kernel.org>
Date: Tue, 3 Nov 2026 17:48:24 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: more checks for
 alloc_contig_frozen_range() with __GFP_COMP
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Zhenghui Hao <zhenghui.hao@qq.com>,
 Brendan Jackman <brendan.jackman@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261102-free-pfn-on-alloc-contig-range-error-path-v2-1-a9fe939a85c3@nvidia.com>
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
In-Reply-To: <20261102-free-pfn-on-alloc-contig-range-error-path-v2-1-a9fe939a85c3@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mz3yrx1rrqpgdm8zith6gmyhc1ap476q
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B89614000B
X-HE-Tag: 1793724513-754767
X-HE-Meta: U2FsdGVkX18ha2yzQazC0lIubC658lD2LsfAZT5PlglBk9PtKrFej0Zv75j8kFkBIFEN5ruYs2qed9B2AIeijesWLKSYmAeFCBiY6ES6XeawpP9FjglST8QE741JR0Tw4qRyHAEEKBpH21kudM/8FSLFrOqy5arr8gvgfH0MrgS+gmsUXKDpZsUdqLl+IeevLDPghrAMGGg1MjJUlRxFTFFM36DBJw1mAtZHUWN8iqhfcqZWIe3DWwOK4mf4dg60YjZfm67ADXqLRiNk2QENwVulltgrghiNyLfp4OvEFr95Lod2MUxp+52I/uMFTapG8BSLTOZ4b3y36P1H3Fj45kNms/JA8eiAslrhfxFfot961NC6RBM2gf5JirCGz07Y+swbDgZ7FW+IgrE5RMQJWWKKjD9SNDL4C1d5pLTixSew1KciCyBHtVI6Bx8FduiR2ueNoaI/tVfvtCoPWKpvxQ97wJ9P95Hh9V8f7XABQL5JJ9jbLIBaldQzhs37hzhtsNuCwLcuo8vIhPCfVdmw3DMnDkCTpMHGJy/EMYCbjS1jhdZfh4CsI34Zc2aaRXXiXjo+8B96M21I4o+x9siiaM32PiAtWBBHVOy0gcygw6t/z/K8UBCKESJWznKLlQ4L1eQ2cLp3Nqs+MWJO8yHbNQ2Qy3Tk6JfKF6w0QHl/KPR64yW1fgLCc1Cy8yeEqKVawSu3KnzivQa0PwRmbBJkIxcyIXmhpNFpEhgPig4WXoibegF8zEdE1jeW8Dc0wj3VVcHBO/j9+ceXofrNrBK1QS8rwfhywZQ2dFDYjjW7he2a0Kyofm1wlhKGWyzrZQzxZfR+upIut/zOenhCx8vEjnJGYJG+nUC7TGntIH4oCoMI+xT4pFhAwibNEZ9mTTcTJADwYyF56bzJWiS0DCxA4nE8a10o0bnBG8ESHAeRQJlampyNmK4z8HISIXiJPQFeWLGFxcAh98IZMwxWqGJ
 ae1dhFwl
 CJb8cghMMpz8euJfOBvmAjiJrM5TX7GA4VrP30oM9Sd+Of/xf+0ttlQR+BXUS5hI5hAX0ywnjnLWPeGOriQ4d1yZjkkWJB0wsAjyH6yEWIHaYrfsig9HqUBahRE65LPjmdbAeE7vqL2dw7e7jHVCGJxZA15HfxebuiaxgY4viA4mzAH5e9crb9oauZZl75V+LfYUZoQvpvyMZVRN2MItAn/QEsfnPj4e2qpY9GJxoCRColZhPPqnLtfFRhWF+xGpBGe1kWHKUXGwb0fEcNrHVFvYUtGEZFumBc3MXUFMkRN5Hhi5EbOdelG2mZwSdPFT7my4kWDiPmPiy9Rte5gcygChEh/9aBr06Z56nyXgXez8mZWGphjyGTqIqRGmbDN6kRFW2g3yDhWrLxzkMNHrpFDCzZ5SHHmArXFXY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 17:24, Zi Yan wrote:
> When alloc_contig_frozen_range() is called with __GFP_COMP, certain inputs
> can cause a mismatch between a requested range and its allocated range,
> leading to the WARN at the end of the function and page leaks. No in-tree
> user passes such inputs. Add checks to prevent it:
> 
> 1. the order is at least MAX_PAGE_ORDER: free pages during isolation can
>    merge up to MAX_PAGE_ORDER, extending the allocated range beyond the
>    requested range;
> 2. the number of pages in the range is a power of 2: ilog2() can round
>    down, so that the compound page will not cover the requested range;
> 3. start and end are naturally aligned to nr_pages: a compound page must be
>    naturally aligned, and the unaligned range can also lead to a mismatched
>    allocated range.
> 
> Because of check 2, the same power of 2 at the end is redundant and
> removed.
> 
> Add a comment on the WARN path to clarify it should not be reachable, so no
> one in the future will try to fix the impossible page leak.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f%40nvidia.com?part=1
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> Sashiko reports that if alloc_contig_frozen_range() with __GFP_COMP can
> allocate a free page range different from the requested range, the function
> triggers a WARN and returns EINVAL without freeing the allocated PFNs and
> causes free memory leaks. Add checks to prevent it.
> 
> The is_power_of_2() check and start PFN alignment check are added with the
> help of LLM.
> ---
> Changes in v2:
> 1. added 3 checks for __GFP_COMP to prevent the allocated range from
>    mismatching the requested range, which can trigger the warning.
> 2. removed the redundant power of 2 check at the end of the function.
> 3. added a comment on the WARN path to clarify it becomes unreachable.
> 4. dropped Fixes tag.
> - Link to v1: https://lore.kernel.org/r/20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com
> ---
>  mm/page_alloc.c | 25 +++++++++++++++++++------
>  1 file changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 15ff5c1feef4f..003911ef393be 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7326,12 +7326,24 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  					    PB_ISOLATE_MODE_OTHER;
>  
>  	/*
> -	 * In contrast to the buddy, we allow for orders here that exceed
> -	 * MAX_PAGE_ORDER, so we must manually make sure that we are not
> -	 * exceeding the maximum folio order.
> +	 * The use of __GFP_COMP has the following requirements:
> +	 * 1. the order cannot exceed MAX_FOLIO_ORDER (>MAX_PAGE_ORDER is OK);
> +	 * 2. the order is at least MAX_PAGE_ORDER to ensure at the end
> +	 *    outer_start and outer_end match start and end respectively;
> +	 * 3. the number of pages in the range is a power of 2;
> +	 * 4. start and end are naturally aligned to nr_pages.
> +	 *
> +	 * 3 and 4 are also the requirements for __GFP_COMP pages in general.
>  	 */
> -	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
> -		return -EINVAL;
> +	if (gfp_mask & __GFP_COMP) {
> +		const unsigned long nr_pages = end - start;
> +
> +		if (WARN_ON_ONCE(order > MAX_FOLIO_ORDER ||
> +				 order < MAX_PAGE_ORDER ||
> +				 !is_power_of_2(nr_pages) ||
> +				 !IS_ALIGNED(start, nr_pages)))
> +			return -EINVAL;
> +	}
>  
>  	gfp_mask = current_gfp_context(gfp_mask);
>  	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
> @@ -7428,12 +7440,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
>  			__free_contig_frozen_range(outer_start, start - outer_start);
>  		if (end != outer_end)
>  			__free_contig_frozen_range(end, outer_end - end);
> -	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
> +	} else if (start == outer_start && end == outer_end) {
>  		struct page *head = pfn_to_page(start);
>  
>  		check_new_pages(head, order);
>  		prep_new_page(head, order, gfp_mask, ALLOC_DEFAULT);
>  	} else {
> +		/* Unreachable with the __GFP_COMP checks above */
>  		ret = -EINVAL;
>  		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
>  		     start, end, outer_start, outer_end);
> 
> ---
> base-commit: afb4eea28037fa55c4560313ecbd8a1e1da8369a
> change-id: 20260629-free-pfn-on-alloc-contig-range-error-path-acc001232468
> 
> Best regards,
> --  
> Yan, Zi
> 

Thanks!

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

