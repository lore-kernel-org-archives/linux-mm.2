Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48218CD4F24
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 12:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85BB26B008A; Wed, 13 May 2026 08:10:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BEDC6B008C; Wed, 13 May 2026 08:10:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4C76B0092; Wed, 13 May 2026 08:10:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D12E6B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:10:36 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 016BD1C1919
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:10:35 +0000 (UTC)
X-FDA: 84762279672.10.FBB062B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3FAA5180014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 12:10:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rlL1pN2t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778674234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TflhmoBcNpe/zgnoV4vuyFy27c9u7x5i12gAjxSAZI=;
	b=xt3dZZNpaN5ZP2rIwhFsN1iZ+0ley5Co+HfL26ttT9mue3JJ1OGQKuME6PkAwm1nMPbCwK
	Apt3PI+zfb3sgnuLh/bjPYSoHXTGFvErEG/1I8ZPyOWCADBaVgJZrxu0qQDsgNhGFFj+kW
	PpR6Vlz0Hf/x30Xq2gt5HVQaWmjNp2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778674234; a=rsa-sha256;
	cv=none;
	b=1ZiNELTQiA7zCDt2ufGAA2b/A1fGMhv8g1werhq4JLESNCuV0ngXILyTa7Iji8r2dJLG9q
	b/SWoV9CmdwMp5BQv6HWJkLegHqVU0O37+Gem0FIpZ5uHCO7yc8d27QSiBBINqPXf5Hf6J
	3QXxmEy37F9Ul9eD/q0f0q66m7YODC0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rlL1pN2t;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C542F60132;
	Wed, 13 May 2026 12:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47439C2BCF5;
	Wed, 13 May 2026 12:10:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778674233;
	bh=6rfhGFFoVU1ZOiQR3m9G/ek9hBpseQZfJiZqEPfqQDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rlL1pN2te9N+SZDlvSLoyrjpJUj/4WIyYFoZaS1GHIsyY3fYqgvL0Wtfm09/dTw2Z
	 w9agvTGfatnpseOfVSnk3Ta3yMn3me34w5z9dD8YqV/Nwyz7fMKXetIJkLMiLj+Yoa
	 M2WY8yKkgmqUDO/HPt4KSvkyK7P6g6FZAorikP0HDV84xWHQ0dzb+k+xc/rv6sZJt4
	 uuOQ897ZV50aaDMa3I9QyyugM5EG+40IBoHadmGuE7PvLu5gNPLRBTHluep4wSHslD
	 A3ZNIgn7wRgyvRJ3MvWrqsz3XCE83zBWg80d1aYAXSQgUzPHc6iyeVz2hYDt4J0Gp+
	 5S0SBCCRxqXsA==
Message-ID: <0432f2d7-3151-49d1-911c-0e227223df10@kernel.org>
Date: Wed, 13 May 2026 14:10:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] ksm: Optimize rmap_walk_ksm by passing a suitable
 address range
To: xu.xin16@zte.com.cn, akpm@linux-foundation.org, ljs@kernel.org
Cc: hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 michel@lespinasse.org
References: <20260503205013850sym7UO0jvKJzyRiTYmO8V@zte.com.cn>
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
In-Reply-To: <20260503205013850sym7UO0jvKJzyRiTYmO8V@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3FAA5180014
X-Stat-Signature: 571ns5yfkkub9pifycyao1uhgazia3w6
X-Rspam-User: 
X-HE-Tag: 1778674234-927698
X-HE-Meta: U2FsdGVkX19kZe2GJZy1Fdb1S95JpJtqNY3dFVeIOs9QOORACfRC32M47N33dmwnr7WOxfh/0bEGhWMWZChGxuQYJoAi4kyWNtF1m2GwrPBl1IhfcO0LI3/d/4JUluA+onp4GVQBGYBia3Gu0NolrNmrJHf4wSnsyJk3BoXuzN4J7uz872r9QLAG5ZUOueT7FH+v3IWrqw/IpkuappB3ca/TgdnkGr52NQrsNIDUIbPnjnOYVUznaB2imt8f0qdxFMhY3tyzEXdYWAkgXivsak50alRbBlo8CcelKzTR4YxXxhFFILcmD2UxOun4m8Cmjt53+lEm3KpP33XpYD6MgJ70lw4Moi0Id0JHaoPrLgc072ruG3MTekKFVqR4Jqxw6v2bm8I28Hn/sXaCpBMlujQEXvGdIUjBRUAMcr57QcK/dMYFI2ZkGBwKTvWBc2m6TF18e8vGhiIzXUqlt6fVp66yigf1ndzaAyL5IoiGNmABM6UGcoBB2SfU4l0YLXJbfrg3tlwDRU0rCPWbYDzS0exxChfENZK/sT9ABLis91A6+E5SL5dM2RyFZIakwkzcIzciVRM996fYst/OrotNBVrNjgVcTmobgDwHfrXFV5fSDSGmluHjlZQbJhHsabp0A8RlQK+mPReT1eASvpomNVVJBVVjhoIBlE36JQ0M1MzJMQFgkP8MKkq0uWBoLqkDbk0bEjh00qIqmPTLE+SdurrX0u/vI0kuCSFjbzPsiDzNSJRxiTwbWJR/s4x5ceHDqa0oTP8LZ3DIcOA3jSwiPOxh3Y9OHJEAXzQuZ/k4DRsWsfYMljEQ984p8eRKoUWiPVfpF/A45bl8/Y56BKk31eReqwx9lbiwrGaY/V4H8ICXyRkMWulIWqOFtbiNFHexJ3JppynxiwAkJeTQx46kup/0HVdF9bdeFTVq0KTu7wcCmxZH1BReHaejvpqy93Lzep17uPST027l/RRatSH
 f08y5UCa
 CrXhuHBCylylv0V6kgPy4wB2DywA1M6M98gNtQP6GMqcuD4P4Rc281KgB7n3/nmBz8V2mOn967uvt7clZZj5otVBEAHJoSD5wlclYY4bfFhVS2l2vl1R+K1CnUaSUjHmyskgAOfKgGVu8w86R98OQ3D62q2cZrgCWIVXazJEsVquJa4G6KFjZ6l//cpX3LZ9akZGHpI/z5Kwmzan/lB5t+l8/VGo0+4stuS/n6erkcPL2PaJ+zCz7fhSf9qu0b8qEVvStd/oEvFG8zIpcsgGkCN7gJKcdF77UYCB6sTU/77d29B1W8gdsRs51RVQdJnpalbN1AAekK1RU3NIuJF9xjjEtTZL/950O53k0XVUQ1OWJlTl3trMjFXX+4CdXUpaFVZ8mGL30epan4bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/3/26 14:50, xu.xin16@zte.com.cn wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> Problem
> =======
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Root Cause
> ==========
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> We cannot rely solely on anon_vma to locate all PTEs mapping this page but
> also need to have the original page's pgoff. In fact, I believe only the
> original vma->vm_pgoff is just enough. The implementation of
> anon_vma_interval_tree_foreach — it essentially iterates to find a suitable
> VMA such that the provided pgoff falls within the candidate's vm_pgoff range.
> 
> 	vm_pgoff <= pgoff_parameter <= (vm_pgoff + vma_pages(v) - 1)
> 
> Fortunately, we have already vm_pgoff in ksm_rmap_item in the previos patch
> of series, so that we use it to get the pgoff to accelerate the searching.
> 
> Performance
> ===========
> In our real embedded Linux environment, the measured metrcis were as
> follows:
> 
> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>             and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>             in a loop of anon_vma_interval_tree_foreach.
> 
> The result is shown as follows:
> 
>          Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before:  228.65       22169                 22168                    0
> After :   0.396        3                     0                       2
> 
> We also provide a rmap testbench: tools/testing/rmap/rmap_benchmark.c
> The testing result in QEMU is shown as follows:
> 
> 	Maximum duration		Average duration
> Before:	705.12 ms (705119858 ns)	532.04 ms (532041586 ns)
> After:	1.67 ms (1665917 ns)		1.44 ms (1443784 ns)
> 
> Co-developed-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: Wang Yaxin <wang.yaxin@zte.com.cn>
> Signed-off-by: xu xin <xu.xin16@zte.com.cn>
> ---
>  mm/ksm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 0299a53ba7c9..a13184d00759 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3200,6 +3200,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  	hlist_for_each_entry(rmap_item, &stable_node->hlist, hlist) {
>  		/* Ignore the stable/unstable/sqnr flags */
>  		const unsigned long addr = rmap_item->address & PAGE_MASK;
> +		const unsigned long vm_pgoff = rmap_item->vm_pgoff;
>  		struct anon_vma *anon_vma = rmap_item->anon_vma;
>  		struct anon_vma_chain *vmac;
>  		struct vm_area_struct *vma;
> @@ -3213,8 +3214,12 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  			anon_vma_lock_read(anon_vma);
>  		}
> 
> +		/*
> +		 * Currently KSM folios are order-0 normal pages, so pgoff_end
> +		 * should be the same as pgoff_start.
> +		 */
>  		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> -					       0, ULONG_MAX) {
> +					       vm_pgoff, vm_pgoff) {

But vm_pgoff would just correspond to the start of the VMA, not where the page
is actually mapped?

I'd assume you really want the linear page index of the original page?

-- 
Cheers,

David

