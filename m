Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B4DCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048676B008A; Tue, 12 May 2026 03:30:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BDC6B008C; Tue, 12 May 2026 03:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E046B6B0095; Tue, 12 May 2026 03:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CF3B06B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:30:08 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A05C1203F0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:30:08 +0000 (UTC)
X-FDA: 84757944096.03.BCCE685
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id B83482000D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:30:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwXYtNzv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7DTRKBGRQ1JY8MxykIwfYS4eRu/EZOpAxSlT6j2cXAo=;
	b=ijdfHIGRU2LLSud+uu/Pszda8QXIn8LOWUdvJQ4FeF4I/oQhNWNHMJJ+BAAKOOenBtZ4fl
	W+OjLs/aiuJr2kwhvRXssy1RXXlGzg3TTyOHz6bZwUqhw0MWIyLfQke8vIIb3OFd3yKbwy
	pQIibOuUikIkrXNwZ0Qd49AEV5OlGf4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IwXYtNzv;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571006; a=rsa-sha256;
	cv=none;
	b=zcQbr0rBirndXhkPFdwNPlZvdriYUfWAEDd0AkcWQWcEoWY7VBrcnwMe0x7uv2k3T9HI2L
	p3oqKhWRjOdw0kcK6UJCXJqAX+EgA3CmqLX22dy+WKJPyMN9sW9le0fl/F5EfSl/uKNgA5
	f/6r733JhXkFXjHdRQNMO2Or+mL1zvs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF98B60120;
	Tue, 12 May 2026 07:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C1CC2BCB8;
	Tue, 12 May 2026 07:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571005;
	bh=jT3UFNwnko997LiCICyDWawsTW8JiqcQq8u0ORL/NYw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IwXYtNzvpHXt942+2ou0EzI8WRfn+qpcV60EsXotQywCfTd05HTXefMKHQRQYI6yC
	 84IkUw0axbfJnrdD7w1mOEc/5T4Ls/wRlpOGGWIlo0jAnWLXRND1fg0ZmkjrvKgH7m
	 YNnL1caBBHsMwSzhMYe4+1QGyVjw672IUfmVVkSrCwWKrfYSOJxE5MdpxSIae5Vu6q
	 lMfrmlOmaeFoym7lkbgxsq622WOp028XJii6goIGHlIrKAqERRJsupgASIrYiq3jhJ
	 2ecDHjN/qodgU49oegYDhBRVwJEmxNzXYSuTWbgG6VEUnlB7nZpc2AGVcWUFoP5tH+
	 2ixYzPQ8UrgAg==
Message-ID: <4566170a-7e3d-49e4-baab-ba2790c198db@kernel.org>
Date: Tue, 12 May 2026 09:29:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v17 03/14] mm/khugepaged: rework max_ptes_*
 handling with helper functions
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260511185817.686831-1-npache@redhat.com>
 <20260511185817.686831-4-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260511185817.686831-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B83482000D
X-Rspamd-Server: rspam06
X-Stat-Signature: dx9cakyyzcppzr65y3eae3bm5u7qbcpr
X-HE-Tag: 1778571006-686546
X-HE-Meta: U2FsdGVkX1+dmGGo/7DdS/fidppJurBTL81YY/bFGQCKyRbS4cjAdIK1Muhc09KPQHYKZGeiFToN6JqgANZapH/dcMNJAj6qw/brES7esVpD8laKRPuhL/knv4z7sAyenxxvVxRLyva/I9of31HJCU7jTv/4wdmSvm3B+IYJTEWM1MYOjQkQ91uzOYNVS3gkSQEoA8nAsYoqMWuJLEG9s+O+e8KfhBH9Ijb85kW65pxJMCQTIb35LZa5uOd0nPw860woKteGSMxQ3fiTMvYYLENKqfQObaQ5HFDpfFzBrCeMKU9jJgAEIwV17g8VaNNgv/W6JQPQOMWcuZEjvUgMbc+9Bwn6Ds3fTTh7LzNWS9NPVPo4H5GuMcccJADv8ErbkUoggmpbfYlZW0EWZ2CHRlHjP5+ZLkHdF7HT2CqLSmtp24Kkjy1gJxG1SIS2EWSezcS51VYLeuvrTd7Wf66nS7YXA+g7wt6P4DOku4yclMkQz+Al768P4zf+dCLBXfxyfgTb3bt6KRUUe4RhG8YLXcoGyTdfCmuw1lNu2SAaxjScqmjJV2bijPLBaLUcO4cpWu5Cv+jdUNJWVeV58fh0VAQJitNrXmUk7yNlO/DTf7+zjcfXCKmKJnu6UfHj/18CjQYXB076tmQCk6me4miI+YMHWeD44QAqU4TjU0PhSVloSqleqIabqVAxaq+jIrxvy4V2NCm9/iPv/rC396QiacLY1BkydAxUAWMayyW7sIvMEAi5gzHt6ad0TqjQlFtRFlDnkN/pL0foGCg644DYCxSWCJGKVTDYoGvT1Ie0lbTkoRRgmRTkOGiP7SOtZUOICPrMhPclaD1XhJ3OjbcQq06QfEJAQImKdkMyrK5oAoqPd5mv22CeJITCfgNfHTaPItqn2xpDJ/W1D/H6D/ZQxUlr2JMH3/UKs3QINzjxuZa82eBeKnZIHgkin2WZg3PzLrCsmtFZvD+HKSv5iiH
 nh7GIuJL
 Mg1VrfSCZzHGtixf4hDT3NYbtvSqBncvtWptjE5Q/sIHcEwG2N9XCBJJiJncgrw2WZfkjeejATq3puQrXX0TJMqhiry9WlRi2ryFWLaykMZrsL5/vMW6XioFjBN+sM1XPEYPhOTFyo2izpEevmxfH2x9wtsxjbQFy52K76PvYHwhCKpGDUO42NMSxRTde+eOA0+6vn8U8FwL63NjIOm/M8iYuaCvbnRDYQKrw561q7rPPZQ6rAuVOsP0M2yiJvWUxPzmc5iDbQtixvdVevpHLPiTItaIpZpTEpvD968fc0BE0HAtAS9xQtadQsIQlKT3vJssg4xioXIQJmMFqi+AK1K0li6HO/8llMaSmD2WxzLa6WW48JlSoA24hm2fi8mE9fR74DLVhDKK0lYq0aLlmhApPckPfJLHZH7Wp9ay/MM+8YQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 20:58, Nico Pache wrote:
> The following cleanup reworks all the max_ptes_* handling into helper
> functions. This increases the code readability and will later be used to
> implement the mTHP handling of these variables.
> 
> With these changes we abstract all the madvise_collapse() special casing
> (dont respect the sysctls) away from the functions that utilize them. And
> will be used later in this series to cleanly restrict the mTHP collapse
> behavior.
> 
> No functional change is intended; however, we are now only reading the
> sysfs variables once per scan, whereas before these variables were being
> read on each loop iteration.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Some nits when re-reading:

> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 118 +++++++++++++++++++++++++++++++++---------------
>  1 file changed, 82 insertions(+), 36 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f0e29d5c7b1f..f68853b3caa7 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -348,6 +348,62 @@ static bool pte_none_or_zero(pte_t pte)
>  	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
>  }
>  
> +/**
> + * collapse_max_ptes_none - Calculate maximum allowed none-page or zero-page

I know, it's painful, but ...

There is no "none-page".

Calculate maximum allowed empty PTEs or PTEs mapping the shared zeropage ... ?

> + * PTEs for the given collapse operation.

We usually indent here (second line of subject), I think. Same applies to the
other doc below.

> + * @cc: The collapse control struct
> + * @vma: The vma to check for userfaultfd
> + *
> + * Return: Maximum number of none-page or zero-page PTEs allowed for the
> + * collapse operation.

Same here.

> + */
> +static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
> +		struct vm_area_struct *vma)
> +{
> +	// If the vma is userfaultfd-armed, allow no none-page or zero-page PTEs.

Lance commented on the comment style.

Is this comment really required? It's pretty self-documenting already.

> +	if (vma && userfaultfd_armed(vma))
> +		return 0;
> +	// for MADV_COLLAPSE, allow any none-page or zero-page PTEs.
> +	if (!cc->is_khugepaged)
> +		return HPAGE_PMD_NR;
> +	// For all other cases repect the user defined maximum.
> +	return khugepaged_max_ptes_none;
> +}
> +
-- 
Cheers,

David

