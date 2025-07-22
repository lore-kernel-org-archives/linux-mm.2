Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D734BC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 20:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BBBD6B0093; Tue, 22 Jul 2025 16:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 593456B0096; Tue, 22 Jul 2025 16:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CFC66B0098; Tue, 22 Jul 2025 16:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC846B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:07:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD9BA5932D
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:07:25 +0000 (UTC)
X-FDA: 83692985250.16.A50A80C
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf18.hostedemail.com (Postfix) with ESMTP id 261D21C000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:07:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OZ95R17l;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753214844; a=rsa-sha256;
	cv=none;
	b=SjAy5nLe//o0jeWKQ5ljhewBS6EUAlUDiRS1zMMxrOX//CcWFIMQo7PmWGLJzk9AC5gFTT
	bn9qtQeDvyM8+TeJ68zQnrLLC0K4RztlxmVgGT5rL8gqrLLonMPM7ANqpfiPL2vc9S2cRG
	Dn0A2XsfyuBnTf5XRDtWEpdm8+3ONbI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OZ95R17l;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753214844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Erlzn8t+joNvTF8iKzi+gIAbF5whSV5OaTPfr6f/hnE=;
	b=aHleKg0e3tLrxLcOotDgzip14e9YMJkrDUpqvHifyMvp3/h9OcQXl8nm7jI9OvyqYWIObH
	Jhmfa2feucIn5++NMgjeJOa0jl7NSXxv+VDp7JWV/VHeLld6W8fn0XZwFtEpXx+Ejt1i6e
	B/2ha7L0ELaZthhr7j9EdSv7RXsVYL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 52999A563D5;
	Tue, 22 Jul 2025 20:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4B1C4CEEB;
	Tue, 22 Jul 2025 20:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753214842;
	bh=A9U10LdyLRNTz78nkxw/9fL65JMOLX7O4NaZFljiv6s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OZ95R17ljE7FLT7YxbnUbAL7zPf2GHea6OsnFTItLRRuwg8bfXeNCg+KkVV9PSB6+
	 Ln6BhMG6sYRxWR0tTHq+NkHiVGCQPDy5X9NX9HwmcVAf4DVjGHt0pUK96NXlTpGtQP
	 oP5DcJl4eR1LKWv4rd+hL02r3116GUoKCW5eRqnY=
Date: Tue, 22 Jul 2025 13:07:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: balbirs@nvidia.com, airlied@gmail.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, dakr@kernel.org,
 david@redhat.com, donettom@linux.ibm.com, jane.chu@oracle.com,
 jglisse@redhat.com, kherbst@redhat.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lyude@redhat.com, matthew.brost@intel.com,
 peterx@redhat.com, ryan.roberts@arm.com, shuah@kernel.org, simona@ffwll.ch,
 wangkefeng.wang@huawei.com, willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-Id: <20250722130721.9169d564eeeb28807e18635a@linux-foundation.org>
In-Reply-To: <20250722193445.1588348-1-francois.dugast@intel.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
	<20250722193445.1588348-1-francois.dugast@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 261D21C000F
X-Stat-Signature: 58dbqy5iytgs3u3ag65niigr9stwztup
X-HE-Tag: 1753214844-555866
X-HE-Meta: U2FsdGVkX1/lggfs70UK23mYezYRFW1u1sfCOHB7KjAYqWW3LI54Gy0vx2nP0CfKWBssFwqCZk+7yzF/4xD4eFOiDZTI42iBkuhKC2IqqHbzn1dUK07Jk/OUekryJW+vJMDJB50jxWyeSGTYt1HRqT+5p5xLNQ0pbv+bBGirmnQMwxlnBj9pWhy3hLPrZIIn9dlwOtuCgU9GjbAy1Oxl3riNZQX/RTQ/lMO9sCJFWq3WUF7DDN9jT75ExyDL0uHxrcx6e65fvkfo2QX04aq8RnGh221h7Ko6zRxVQYIQZw8kstugcMwolqqKPH/s1W6dNXXcIh7D7cpp8tb73poP849tD2pkqcrWUnZeS6I2oPrCisVvtbrmxg2jVx9ALqzJwLk/2sjbIYuGSpkgh0jYF6k64AK0/d5ONt7epB9SKDnURymnQrGH6V2sobjUUH0Y6oPZOtETKyjBtBEwqBq3RWQe9X7u7/FFgjKYejHD/XEdSGNwSsPkARbre7rEWkBYb1E3id5vyyKycN7jagAnNtOCwuI+1cFZkuQfI2ZOLZrlSIRl+5Gp/NbrC8/Mh/XT2pu41CptSwfG2JA7vqW1ql9jI/5Ix+47rO1VvFGHCYLFBGE9YGLQZxSYBhNJ+sdEKRMi+Lj5r4IW6bhEyOKzzNMqf6ZGKJAjnxBCbcU/QyvJNDYhG3Fj7vBqUq0PaWsPjW8VEl32Q87qaFWYYfELq//dSQBaJaH4FCfxoLg1M/z4MbdU/54pjNZQf6PU0rUx4oo6Tgj7qlC200WOrCWFCfRSug12boQA9OGbhIjsQuepX6kgIh6QNz07CCA6kTryljfj3FQYKD8LPFI3bMsX1j4i89W6QwM1+3S0vK7Q4jzEKlY9db/l0ctw3qnTCbYHbbXRC3q23C3b1YSSKlhdwoHEClz+owQlDjAgrOd1daS+L2YzrP+eoibA8ADn8mrFRyT7ggbIWMi13NfaDgA
 BXG3FPU0
 jw4il4COEbyz4EQplwpDMU0WRJ69QXDTYYt8sm9G5rhT6Fi4deLEt+VXCM2XAmDhNIgC5C0B4zo2Z8yIt5ZUV+oNCDbEtfNXI9S95dH3vtRynTI/VDxBBZojntIgH5x/61Q8cd8+oeGd5kFSPwmR9eu7hVY1k4TMRgssTh6FuhS/UTYWFU2F99sVAgD2EXnO5atb8YiR9RisZ/VL7+/mLbEMJvSPbly//ihOTW1j71jGWjz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Jul 2025 21:34:45 +0200 Francois Dugast <francois.dugast@intel.com> wrote:

> When the PMD swap entry is device private and owned by the caller,
> skip the range faulting and instead just set the correct HMM PFNs.
> This is similar to the logic for PTEs in hmm_vma_handle_pte().

Please always tell us why a patch does something, not only what it does.

> For now, each hmm_pfns[i] entry is populated as it is currently done
> in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> optimization could be to make use of the order and skip populating
> subsequent PFNs.

I infer from this paragraph that this patch is a performance
optimization?  Have its effects been measured?

> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  	}
>  
>  	if (!pmd_present(pmd)) {
> +		swp_entry_t entry = pmd_to_swp_entry(pmd);
> +
> +		/*
> +		 * Don't fault in device private pages owned by the caller,
> +		 * just report the PFNs.
> +		 */

Similarly, this tells us "what" it does, which is fairly obvious from
the code itself.  What is not obvious from the code is the "why".

> +		if (is_device_private_entry(entry) &&
> +		    pfn_swap_entry_folio(entry)->pgmap->owner ==
> +		    range->dev_private_owner) {
> +			unsigned long cpu_flags = HMM_PFN_VALID |
> +				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
> +			unsigned long pfn = swp_offset_pfn(entry);
> +			unsigned long i;
> +
> +			if (is_writable_device_private_entry(entry))
> +				cpu_flags |= HMM_PFN_WRITE;
> +
> +			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
> +				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> +				hmm_pfns[i] |= pfn | cpu_flags;
> +			}
> +
> +			return 0;
> +		}
> +
>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
>  			return -EFAULT;
>  		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);


