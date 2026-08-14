Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0539C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 03:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7F2D6B0609; Thu, 13 Aug 2026 23:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4E1B6B060B; Thu, 13 Aug 2026 23:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EE46B060C; Thu, 13 Aug 2026 23:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 775466B0609
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 23:26:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E70340292
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:26:06 +0000 (UTC)
X-FDA: 85098436332.11.AC847FC
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf14.hostedemail.com (Postfix) with ESMTP id 61472100005
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:26:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eMj3o8k6;
	spf=pass (imf14.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786677964;
	b=jgrprfDm7e0ctQ/RnWjGucd+rU29CmHxdJBXcBOkUpA6i3oDmsICm62TsEJYkY+6m627rj
	lsX6rFxbdqsW5Fn7lcp+9GrxW19BENQuLesznBBlWP9fjxxmEhhx49+9tSvDvA9hDY9yAZ
	X5OI0Z9s2xsw9SOBFPCunyGGB9EUsaA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eMj3o8k6;
	spf=pass (imf14.hostedemail.com: domain of binbin.wu@linux.intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=binbin.wu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786677964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xEzzDZ8RSQ4GEvpOieKsYgMrbUPq9hvMZZpCwDZd+As=;
	b=48vun/w8Oh3Vxo6eMY/Uc8Nok49+d8YRhnn1d1oIKQjfRxH/vwrLYOyrEJLB+tme+zgb0T
	7BJrqdSFI6Xx+OHAboLuz8nyDnX3S3WFUBPojJ/rqcKEqZ3IvutyQcW3RWQpWJzapyvJ0d
	Z/RLd6T706PW7SpPxOB00Ci5cWEWqHE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1786677963; x=1818213963;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PMW+3tSZuBZ77kt9zO5BRfNKhdxheMBPxWzy74mRfwk=;
  b=eMj3o8k6PmGHc0TNTSfWPSGFK8UL8nbFtIPJ3sZO8iZxAltJnIwrEbc0
   UGDs25+h/DCuX8SQyGgcnD0q1yPZIb843y6Bk2iOBRY8KFG9ykaqmRq+g
   QyM4w8xikZTFcdAGLf5oikgXDqZfLb9TSc4QiK5Fj5Q4VUpUR/+bK5K7O
   JTOo8dud66wZ7rfZM48abXXwa+bizjR4VEF2TimNtVg8yIT0L0ZvlMe8J
   AdVil0nW4t2+l1qo215WTa0r0RPnQbLnrwWIpJ6/eaTT/LIsA/DEOa6xQ
   H2VtpEd/AuF000JwEngAwBTmxe/RrJt05F06pgvAox9jXphkKDc29j2UK
   w==;
X-CSE-ConnectionGUID: Q8fIHLxaR5ab1Nx7Xz44qw==
X-CSE-MsgGUID: so/DSd8VR66tStiGHaeDIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11874"; a="112801644"
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="112801644"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 20:26:01 -0700
X-CSE-ConnectionGUID: OK2WNfvaROqJl2omPhlcUA==
X-CSE-MsgGUID: cGwfy+bMRAqA7Rf+rV3Kow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,222,1779174000"; 
   d="scan'208";a="267971704"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.245.162]) ([10.124.245.162])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2026 20:25:48 -0700
Message-ID: <beecf36b-b0eb-4691-918f-fd39f46d5d8f@linux.intel.com>
Date: Fri, 14 Aug 2026 11:25:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 15/41] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
To: ackerleytng@google.com
Cc: aik@amd.com, andrew.jones@linux.dev, brauner@kernel.org,
 chao.p.peng@linux.intel.com, david@kernel.org, jmattson@google.com,
 jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org,
 pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com,
 rientjes@google.com, shivankg@amd.com, steven.price@arm.com,
 tabba@google.com, willy@infradead.org, wyihan@google.com,
 yan.y.zhao@intel.com, forkloop@google.com, pratyush@kernel.org,
 suzuki.poulose@arm.com, aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, tarunsahu@google.com,
 Vlastimil Babka <vbabka@kernel.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org, linux-coco@lists.linux.dev
References: <20260807-gmem-inplace-conversion-v10-0-2fc18ee6d3ba@google.com>
 <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20260807-gmem-inplace-conversion-v10-15-2fc18ee6d3ba@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 61472100005
X-Rspam-User: 
X-Stat-Signature: k9guxgqtm5hohb8xdrm49yyx1jrhae71
X-Rspamd-Server: rspam06
X-HE-Tag: 1786677963-589637
X-HE-Meta: U2FsdGVkX1+ZBxLWe63VMrlPXM80EtS5QdSsbRihXUHY611GUDEaYaNJyag9eJMrbhFkwEqQgnli3UnxISaMWykcfx12EoB7mOGPaiIAwmmCZLfcGd4KlpNPi/PhOosmqzGkGinICTCqmgfC5/m8HuzP5myK0L+JqoxOdwLZqoEHx4foJSy2uxtO8DpyZYITtkyoSJPyU3zHLh7tbxlXReomZF9we8S6dX35Jaj5BRWfWxuY38WqmVrTIt4dV4scQ6DIpl2pr2DN/Xdo1YgdECd2Pmu1/+Amp0CmxNz5SSS2tg+P6fLH27oD/FCa7isqxFYV2VMPpBmooj4EnVkxnOImwJhOqd6ixx/bFnDjw7TblWUX6v0Vx4V76myHNyMAzRDv4dNPlHtBh2NW+92DnpBs0gM3sKfqyvfnMwPQ7XYvEApNa7GgaB1rfWNzUp2OVWuIPa5/+rDerdC8I52P4W/xWNLSlWQfkzD1j6STFmzL/r2jqojP3VO01grABAvqovVGPQB9e7dLUO13q7kcgLmK0+vV9tGoyncUt2l9AizuTHjK+1YVEO62iC87SYt2cpBx5JYLpISK6BNzRpjytswKQDDIwA1G2szS+9B3Euzqz6Di0ZJycYKdMw6E6CS80GCfnSyBQnqzG8fgpNlJY6lvIIANF1dV4cLQR/7zEFzI9KCUTu3lNY7jXjnHjuMTm7F9yl+Qr+DOgTOaHLYgiliaCfNIn6yEWyliJbFDn87LKEMscYBQScVW/kqpbMsDYN3ghf/FNocWZe3seJo0az/lopupTPntchvcQitms6+qLfNpUHrpONKR6X/P8fT7ji0MyIwvzezI3pGe41EFk+Ebng+ujQng1Km0/CNRZIDxMga2Rjd22dpt9fFbw54+/dmgxQol9J8qiFC68C62QqZ+jU5zO2Z6Z7twa/lrMGNuYE6E7rxYA6DeRo8LMQ98mz95sid6Y3TsyyGEG7f
 c+040+q0
 g60MLMWj5WkuTP8wf5Xv6n5CYPcA321wMq0PWT9YUD1nQ/IDyU5Ci3o1AgnbePL6BVnYDxjh3BwjmBTbXQGV44TGB2/gewmurczWEQvTke9NkXFWr+gyH6zCnmcsm9qPG7LcV9802hvJGZ/clp/pLBg3p44FcicvVL4NoQRo2d5BL/vcv3hxxAUgNxcKlg+RR1zQYctosFPS0tjXWksTJ7M4o6Yaj3ylEVa4ZRtHS/7H6g9wN4sHnvCuWGWMmNUdf9L/19B4s1g1th41zQEFDUlFj4MhT+YczLPSpn0fkYUyu8LEyobIlsLX51x9ljXXxREZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/8/2026 5:52 AM, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> A guest_memfd folio is safe for conversion if guest_memfd holds the last
> references on it. Any other references on the folio may indicate another
> user, and guest_memfd cannot convert it to private if there may be an
> existing host user.
> 
> A folio will have extra refcounts if it is present in a per-CPU lru_add
> fbatch. guest_memfd does not actually participate in LRU, but
> freshly-allocated folios are still added to the lru_add fbatch for batch
> LRU statistics processing.
> 
> This one known "usage" of the folio is handled by draining the lru_add
> fbatch. After draining, if the refcount is still elevated, then there's
> truly some other user of this page, and the page is not safe for
> conversion.
> 
> If the page may be dma pinned, DMA is obviously using it and hence not safe
> for conversions. If the page is still mapped after guest_memfd tried to
> unmap it earlier in the conversion process, it is also obviously not safe
> for conversion. Exit early to avoid unnecessary draining in these 2 cases.
> 
> Provide a drain status to only drain once ever while processing a batch of
> folios.
> 
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

With the updated version of change log,

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

One nit below.

[...]

> +static bool __folio_safe_for_conversion(struct folio *folio,
> +					enum lru_cache_drained *drained)
> +{
> +	const int filemap_get_folios_refcount = 1;
> +

Nit:
After adding the helper, the use of filemap_get_folios_refcount seems
less obvious. It introduces unnecessary tight coupling with the caller,
though it has only one caller currently.

Is it better to pass the value as extra_refs, similar to what
lru_cache_drain_for_folio() does? 


> +	if (folio_maybe_dma_pinned(folio) || folio_mapped(folio))
> +		return false;
> +
> +	lru_cache_drain_for_folio(folio, filemap_get_folios_refcount,
> +				  drained);
> +
> +	return folio_ref_count(folio) ==
> +	       folio_nr_pages(folio) + filemap_get_folios_refcount;
> +}
> +
>  static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>  					    size_t nr_pages, pgoff_t *err_index)
>  {
> +	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
>  	struct address_space *mapping = inode->i_mapping;
> -	const int filemap_get_folios_refcount = 1;
>  	pgoff_t last = start + nr_pages - 1;
>  	struct folio_batch fbatch;
>  	bool safe = true;
> @@ -560,9 +576,8 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
>  		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
>  			struct folio *folio = fbatch.folios[i];
>  
> -			if (folio_ref_count(folio) !=
> -			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
> -				safe = false;
> +			safe = __folio_safe_for_conversion(folio, &drained);
> +			if (!safe) {
>  				*err_index = max(start, folio->index);
>  				break;
>  			}
> 


