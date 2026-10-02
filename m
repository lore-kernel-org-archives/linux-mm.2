Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9989CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:13:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37086B008A; Fri,  2 Oct 2026 15:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE81E6B008C; Fri,  2 Oct 2026 15:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD7886B0092; Fri,  2 Oct 2026 15:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9453E6B008A
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:13:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 247EA1407DA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:13:46 +0000 (UTC)
X-FDA: 85278635652.08.EF32418
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40EEB18000E
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:13:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9RGZLcR;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N56IVrkHgW95DKN/ml8uLc48V5Z4iV1gTSdArvZ350Q=;
	b=YhQn+7w2xblPUx+Ztd20/6Jz5AtWKX7H8W0q6hVljPQlLKIFwAb6TB8mZg+fakNbK+gMAg
	xnJHgt5jqEi8gvm6K1CvXSzXrr4SL9uAY2ETMwmv2dJvpWPj/iZ2L8LfMbDiOu6eF1sM6X
	Y17R13ZJUO+7gxR6qn2IbPi4gGlmXDM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K9RGZLcR;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968424;
	b=d8XyRbwl3o8/vJ8CLRLY5Cvr8Y/hRO0+MaSJmHNhjiJD+wW8KmJNB5LwHbYNHauLLKbxtV
	li3JnW94pSQXRemzNNzJJR3IWIdr/5nov9ruyPRsI4KTYj4sj0UXh7gl+Ei8o1Dj7ifKAw
	iWagHxDvOP5NKsQZJssTEIdMj6HeEdk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3299040BB4;
	Fri,  2 Oct 2026 19:13:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB291F000FF;
	Fri,  2 Oct 2026 19:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968423;
	bh=N56IVrkHgW95DKN/ml8uLc48V5Z4iV1gTSdArvZ350Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=K9RGZLcRaXo+mqMqoQm19xpxnkGstJ/aZ5hXngDTeNDvN6RovymJE4t2itC8nPsQJ
	 a3bfVEBCUE4emwvTPlhMe3KP5iRBVZxu0QlL9XC0JUQDen/72NX5+I3YXPvrNbx5xs
	 haBASBqJWmjtu13BwaK0vLrug7ai0w5HFxa+bYKVx4S6CufGr3xJwjPyxrJTG8prml
	 YQe4mT0M6EY+4vPh4iNe2kCmHkOWf1xKA7cl4IfonUaIv1VrFS6Whm5RLUFruxN5fr
	 o/ELjG5GpCRkvalZpf+/n695zoMolhY/CEblsAjRzxXiNaNHHuVgfe2WRq/rHK9tyX
	 nHhDQHSVeQCaQ==
Message-ID: <62d8b799-7e06-4060-ada8-62fb4633b124@kernel.org>
Date: Fri, 2 Oct 2026 21:13:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 03/14] mm: introduce pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <f0b6d8a8036ee6c2aef2a63e9a03d94292a2c599.1789695931.git.luizcap@redhat.com>
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
In-Reply-To: <f0b6d8a8036ee6c2aef2a63e9a03d94292a2c599.1789695931.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 40EEB18000E
X-Rspam-User: 
X-Stat-Signature: 6wskktm8b9a1spfmndsofdwd98x6fq4q
X-HE-Tag: 1790968424-26472
X-HE-Meta: U2FsdGVkX19LWiUeN4YK2VQVdjqrpfsvmpPBMf9flkbwe+RlpEfHQETSEQMhqOMAYMf/V2NYrZ0UUxyxvPd1Q69v/hDhS7Gv58Gx8/VihE+a/a9bSyr+syLDn0IvUSYWwVw6eS3hp58BdsBq4WbpgNC9NTNamH7r68qPeJlB+nRGo/DmFXuf9YScAFSJzqRivP6OQziDese3530mKEYAdNM3BheC5BpFIHQbmB9/14BGKZghdjQvrsY/qxzgBG9VDwXLw16r0voM+Inro1+c06YQVExz6CaOYcTaesHeLePnBa4Aik1MoXFHafFgf8Zyjt1WsGs5iHBeuB41+d7cHUaxhE0ckJJC33cqWQr2aiGhRy/DDdhaHfvQYia/Sq/jKhtvYaHBEWvRb+Wc95UOW5o05EFQ1kBuPXICZstw2dhKKWCGoUdL8Lrx9ihIqhPlWAg7AtAfBCVCGjd+imZt6Q8kq/efJC0UwSYCZ2pycjsEwQSeyGJ3ZCNQsogmcSHQuPYWaKbqNqSx4fYucgFDBzHbZct7oJzXznnIp1B7B7cyZ/dp0rnPriC8ZJXgP8ihma+NkmduqT7fxGIh9hWeWb/3XagSBkBpjGGiDasrUJXppMLIIqrY22O2X/1m6CdYpvxMTD7bCW/uZm8LWLOwqRn6dFW9VF9LnXqV6x+AwljCOvB139K2x5fyQRESLxALWOOzgquHv53NHiqmyQOW56/8QJ23s4JaJhPwDwpAUaTzJGo35QMdxHzNl3l4OghjQqCnLVsxZcDKOc7O6TI6ZSO2xlQnynmYYDXx8h/gAbsWxT8nn2SrItdlPbsmLS5+Bz8qB7oArXtmOI6RvQJGbiVGP52NjboOukALchqd6G3TEKWMA3t25qjOT5Rq1TCmuMAOk2xh+iMXQ5Y5k2gj1rHEawNT0zymIuGdw1mPQ+a2vazaauDYYRDwx3QMxOqNpeaJy89VWLD+GWeYykY
 L9KCaDZ0
 ZQQRQHuwNrEbTTI+loLhmdc9Qw0kTDm16lpF6Go1u2QJpa7erKDsrsxmkRje/YQ6OrBx/1D1udl2aS3m7P9S5OP3huELZnlqxV6ZMt8fYCRqqfbI70jyy0lIt/2PDxdk0z+OtMAiEWKUfD3c9g3nmopYgkkg5SJYNFBDoMsz+S0tmC1yIRuGr+LR3A3iFKZBXMT6MKgSshnOIeqHR9BnjlqFbKdvOIohNkBM23EUopphb4I6Mq8m3dc/Myh1xmnIAAiAkO/JDg5rLAkSzjrAlmjEcrywZnXN3CTV1hC+mkjtS8fRB1dtfgBQXfHYCxeDehs4gLjQJ8BPMvjxp9iqiWnpMmj45oAnKsKIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 03:45, Luiz Capitulino wrote:
> Currently, we have two helpers that check for PMD-sized pages but have
> different names and slightly different semantics:
> 
> - has_transparent_hugepage(): the name suggests it checks if THP is
>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>   implements this helper, it actually checks if the CPU supports
>   PMD-sized pages
> 
> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>   by the hardware, but it just returns a cached value acquired with
>   has_transparent_hugepage() during boot. This helper is used in fast
>   paths
> 
> A better design would be to separate CONFIG_TRANSPARENT_HUGEPAGE
> checking, which can be done with the IS_ENABLED() macro, from checking
> if a CPU supports PMD-sized pages.
> 
> To this end, this commit introduces a new helper called
> pgtable_has_pmd_leaves() which offers the following advantages:
> 
>  1. Well defined and clear semantics: it returns true if the CPU
>     supports PMD-sized pages and false otherwise
>  2. It always returns a cached value, so it can be used in fast paths
>  3. It's implemented with a static key: it's a no-op for archs not
>     implemeting it and for archs implementing it the static key is
>     changed only during boot
> 
> The new helper requires an initialization step which is performed by
> pgtable_leaf_support_init(). We call pgtable_leaf_support_init() early
> during boot from mm_core_init().
> 
> The next commits will convert users of both has_transparent_hugepage()
> and thp_disabled_by_hw() to pgtable_has_pmd_leaves() and/or
> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE).
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---

Clean, thanks

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

