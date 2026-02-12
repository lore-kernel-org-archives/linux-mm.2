Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE04EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:51:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0AF06B0088; Thu, 12 Feb 2026 14:51:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8FA6B0089; Thu, 12 Feb 2026 14:51:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6F9B6B008A; Thu, 12 Feb 2026 14:51:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A60206B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:51:44 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CB7F1A0298
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:51:44 +0000 (UTC)
X-FDA: 84436849728.13.4755242
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B37CC20005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:51:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fu2UCV+t;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770925902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aGcizoUcNSVgurx7DZzxQZiYfROHQoyVla337L4LHmU=;
	b=LFO0rRqkmcOHVpKvBVd8b49tZshwtmxrHbJxIu7hrlUDV4OHZ9EqKswPNEl3q5dsUMTKQt
	UU8WGprQY9cjrvCuThyeeabmV2NGM4A5QQ9JIJBC+MQUx8T/CQ9/boKyTiBE+2wqCte8I4
	YfIFMTnkdzMynopN8I3HFHIwSnk7bTE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Fu2UCV+t;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770925902; a=rsa-sha256;
	cv=none;
	b=bLqQUnrS0GhqTPJtq5xD+IHsBW2WuJSQzmsTZduoOF1zVaFgz5PclXvtdMLhqDOQizjJA1
	z+gaeCwpqBwSEd+HuuubaC3kbZWANqAXHwYOlwaVbNkxAgkk1/2KlsOcDcy5xfi3q4zvqS
	J5AI/swp2UXLgR68XsXDnDNnIXllgo4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 87EC06132E;
	Thu, 12 Feb 2026 19:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1138C19424;
	Thu, 12 Feb 2026 19:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770925901;
	bh=ZGlUyowuJ/4IhUY0sQZKkJjYbYXoo0csOOP4hmRvPAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Fu2UCV+tTzXaMHiosOBdTGAwWf2IhsIEijmp8dmTq06u07heLkC9cO9U4SLPg+L41
	 5kDBzKJRACdJrJk4emsWT5IeM6TShLLPOm/Srk3fcqFkxkitXoU1GffsUHFMDhiHZL
	 F/a7DN5FHcza8ctSzBqf+Ji9HhDrbl81F06giV0kJVvZ7S7M+KfrtbJqB4KIUpve4z
	 5jiGNy+QLZ7Sco/XLsM5Hp2NvrBjLF1BK1c9ZtDui7bTxRg3Mp11to3rJpGs6eB7U5
	 roiBruCj9Gqo916l8+Py+01JWQqwzafZ2CrHnE/QddfSoHuH+MogfRK0LtDfACY2k6
	 rAU3BhXv/6j9w==
Message-ID: <493d7898-c959-42ee-ad09-35ffc631ec21@kernel.org>
Date: Thu, 12 Feb 2026 20:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-4-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260212021835.17755-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B37CC20005
X-Rspamd-Server: rspam07
X-Stat-Signature: ycza6f9p8zonnf57te6an4zkqyfy5akd
X-HE-Tag: 1770925902-780971
X-HE-Meta: U2FsdGVkX19iGQ0GGIpP2s/R/N2WycT/Y1mczFBO64tKd8iXFnyRtNg8HdLfABZGILyn83ZzVBY4aKw2i8oMTlZdTaDFOovQn3n0rgq2/dhrMwgbUQgC/xukWgz8RX6uGUewGnZNq4V+98xjhdLtyPwt/1ELXV/ssppVHG34cAwGa6EKiEo9wtMfl5aXYy8Gxqc1PlnY7SdniBHD8/qJQHfIroQl6gk5H/CvW34AG8ol3aaJ3a4z8jwGXwJgwJIJwH2fzyC6h+cQPQZXVgr66d1t9gpPBAuadKDv6IxYkS5hqWIQrAz5+DvXEFfLnBayp/uIn5p8sLD8vQMa9Wu4uRtuBoJaEF4Pg5E82p2zd5CguBQYbcmbewM6IvXXfQy7v5/TDwIl4ANBYaqR7F1jhV4ODQ0FT+uTLNCskiKbBMM9FZ+KCTM2UV4qJURbhdu+z0HyONbDJSeHFCicUF78ew+ulDhnxeXA10Euq7LJYjTd5uUEq0jFReD1FH/W4rai1IZ1J2uUIMN9cPvW98zkgpYni90fqsQys5kVgBEbSL303Ac5de5lfC8HuTzPF81Ve/5w1klwlTHOYuRiSMHgBaz/jwx39WUcmD+m6cPmMNPYk7JJQPKpvlBH91XSQnica5oAQr/C9AnIEUqVidwhLRKonfFgbvRPcmGA9T7ZTz9caN8JT+e9JQDpBLotIGk+rvPfRsr+7r/0w05Zee7tiXjgueZ9G9lxgfTSeKt4Fp1NSU2yIQ/z11zVGkfn+7rtTPtpGNz+sjZIunyad+jmJZAtefkCm7x2EiYlQauJnwrV2G+aKXqRrEZ7/qZN7VSR8u2KYHECAn8phuQxAW6aLdruJhGN6zoMtybpVuOAsIooycrdyE2KK5huikbyfAIpLHHgbrLMahXWoeYQUCdl9udl7zB501J9Lw7egxOm5uq7jgiMYegV//8msG+AhygOr9BAYJWIrrRJgV8JQUW
 /4I7THot
 g1QYXZ5qkUOxsdCb/i1/v/nvan+EkgJutY8WsVNUYHHX9uXcHy7buqZCLlRnWLYw55mf4d/pNKqNz8meLXsY9QjJH4E9FWb9T4Blfp+SE3BRJzVoCFRe6cP23N66UF3kW1wHLQpEPpZRzz70kkGtDzHYZtOTVV5qtk5nVPyL+oJCBh7a/097BsTXvAouPM/QOG3aAhPrZQmak9lGeoaRD6Q5QxpBGpPS2RWp27NqCVg13H1Q582fcBGwOquG5lC2rGTGpslIfOOoElU5rTskxCvWotLl7FP8jvRUddU+t/m1pLMCZDLdJAW24FHLT4QcMvTz5VVFdatzNsgY1qoEGFvOKV7+T2Wz6f+5F0H2oPmH6OazdKe+rUAxg674Q9y+gS2Ue7X/rgFmzB2s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 03:18, Nico Pache wrote:
> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>   mm/khugepaged.c | 15 ++++++++-------
>   1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c362b3b2e08a..3dcce6018f20 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -85,6 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>    *
>    * Note that these are only respected if collapse was initiated by khugepaged.
>    */
> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>   unsigned int khugepaged_max_ptes_none __read_mostly;
>   static unsigned int khugepaged_max_ptes_swap __read_mostly;
>   static unsigned int khugepaged_max_ptes_shared __read_mostly;
> @@ -252,7 +253,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
>   	unsigned long max_ptes_none;
>   
>   	err = kstrtoul(buf, 10, &max_ptes_none);
> -	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
>   		return -EINVAL;
>   
>   	khugepaged_max_ptes_none = max_ptes_none;
> @@ -277,7 +278,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
>   	unsigned long max_ptes_swap;
>   
>   	err  = kstrtoul(buf, 10, &max_ptes_swap);
> -	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
>   		return -EINVAL;
>   
>   	khugepaged_max_ptes_swap = max_ptes_swap;
> @@ -303,7 +304,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
>   	unsigned long max_ptes_shared;
>   
>   	err  = kstrtoul(buf, 10, &max_ptes_shared);
> -	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
>   		return -EINVAL;
>   
>   	khugepaged_max_ptes_shared = max_ptes_shared;
> @@ -384,7 +385,7 @@ int __init khugepaged_init(void)
>   		return -ENOMEM;
>   
>   	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
> -	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
> +	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
>   	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
>   	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;


Changing these is ok. I don't like the name either.

It should be clear that they all belong to the "khugepaged_max_ptes" * 
values. (see below)

>   
> @@ -1869,7 +1870,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	bool is_shmem = shmem_file(file);
>   
>   	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	VM_BUG_ON(start & (COLLAPSE_MAX_PTES_LIMIT));
>   
>   	result = alloc_charge_folio(&new_folio, mm, cc);
>   	if (result != SCAN_SUCCEED)
> @@ -2209,7 +2210,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	 * unwritten page.
>   	 */
>   	folio_mark_uptodate(new_folio);
> -	folio_ref_add(new_folio, HPAGE_PMD_NR - 1);
> +	folio_ref_add(new_folio, COLLAPSE_MAX_PTES_LIMIT);
>   
>   	if (is_shmem)
>   		folio_mark_dirty(new_folio);
> @@ -2303,7 +2304,7 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
>   	rcu_read_lock();
> -	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
> +	xas_for_each(&xas, folio, start + COLLAPSE_MAX_PTES_LIMIT) {
>   		if (xas_retry(&xas, folio))
>   			continue;
>   

Changing these is not. They are semantically something different.

E.g., folio_ref_add() adds "HPAGE_PMD_NR - 1" because we already 
obtained a reference, and we need one per page -- HPAGE_PMD_NR.

So it's something different than when messing with the magical 
khugepaged_max_ptes_none values.

-- 
Cheers,

David

