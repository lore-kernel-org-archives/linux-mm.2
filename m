Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F007C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 16:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A67B6B00B3; Tue,  8 Sep 2026 12:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77DDF6B00B4; Tue,  8 Sep 2026 12:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 693636B00B5; Tue,  8 Sep 2026 12:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 40AA46B00B3
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:05:17 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD03716069E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:05:15 +0000 (UTC)
X-FDA: 85191069390.17.27D0882
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9CF751C0018
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 16:05:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fN/nuOR6";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788883513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=52DvIl2of7dUjq8RgKJMVXe+11DIg6SDkc/sKpreXrU=;
	b=Hpa3wYd8vBE2gQiswNtg04ZsD3Yl1VAMZ/HyTVjgkGNCfgBYoS6p9m+2sNun1k/GfL4Oal
	BE/jmOUpl5u0l5l25VHhqC9eXvQRCZC1/c6tefGpz37Mv8ypL+kxs2Dt0c9WZkfqmiCY8z
	aW8Dg6fqMzNtzZ4ZA3NNX9OlAgA48N8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788883513;
	b=5Wb5BnmLsNbn3Sf/tMfMJXHqFg4H+/aDX1F8gJiU5+kMpDtMV/1ZhEpO7SxKUpmLkjTwdI
	p1fSs6AbcxO+hFLqS8ITHBZv5OEciOLmvBRNCmwNIcIn4oM4Mpod+fpor4Goo5zw3zxZwf
	D0KViCr8hreg0f6tIi9M7TfJWY35nsE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fN/nuOR6";
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B071E42D6A;
	Tue,  8 Sep 2026 16:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC82A1F00A3A;
	Tue,  8 Sep 2026 16:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788883512;
	bh=52DvIl2of7dUjq8RgKJMVXe+11DIg6SDkc/sKpreXrU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fN/nuOR6B2tJjVtren7fsjMrU4FFs7pugNQOxdQjZ1vubCKzB+NHQfxaosCEOrn4e
	 350jvM32cKifPJw5w9kgsYBaIoyqpsXrx1DPRvTMd0ZEn1P7n6kYQSNwOqliy3v6AD
	 ucHf7W/RnXMjWGmyJcbaTs6ByEGnULj+CbAZYGc+LjmSxoCPZRYIwBT+gwCLYw+Q0L
	 vvQCBgZdJY0Ly1Ly2T8rE9IGtstaXzuA+2zuV3x/xAlGByc6Z+a7yvZIBgEcK5WE0A
	 Q3LA7xQ6JoJXOA6P5vGhbNaYXrbK6lrVpBM62Vf74KJDLC1cEb4j8/lZNgM33bult8
	 Xm9c0+WfPXM5g==
Message-ID: <eefbff2b-d619-496e-a977-52062da90f05@kernel.org>
Date: Tue, 8 Sep 2026 18:04:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/14] erofs: mm/pagemap: add readahead_folio_last() to
 avoid folio->private
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Jan Kara <jack@suse.cz>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale
 <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>,
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org,
 linux-fsdevel@vger.kernel.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-7-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-7-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7oqam3r6et1gbsojgcr7q9795es1hdcf
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CF751C0018
X-Rspamd-Server: rspam03
X-HE-Tag: 1788883513-802672
X-HE-Meta: U2FsdGVkX1+hHiqK+ADztIxFSLL69JdBifoEWGNgoWdKdecq3weIgTwEP31zjIzCfIplG/SLh7kem2hyiI7LIbdoo7KEm1lVYTiyCl+rkW9DNAkD5DJhm9jBugQX9Ca7BLJHmp2YrONPQ4LsFIci8koSFLbQ62pM5g9z0bgP4D8g3lng6sy2PtWZHs4tU+OkyhgnaN2geoSdLhHIjsnNXxRuXKdwqviTHOHvOY41Sv1hHPzTUx3Icr3guWhi3GwcoMhUwpiDzhocEnOJigBlCWWbBy0zz4Kz7N7VevsBpZ41dNxG5adbgoTbZkQCrNYLhkJBLPWf1kVcgcgWdLsv7yisYqAmV3NsVy5schf+pJpqz8mzUUOOBNO5ZGZJ90QBON4fX66cRE44liiSJGTYbR7UCXFMQQtH26tG7XypCg2vnv6JtU/k3OqKH3yzASKZkMVWmAV0c2dNNrlPZesKw4l6t5QcLoVHF9Oh9s0Skhe68gGduNxfXl83MKH0rajwX5GPEQMw9+Y4bzEN+Lwi7b2r2NrYRn7MnECJNCHOI/5W8zqowAfvCmUz1QAK32HnQ3OwCsE5gn+6rDLBrIzVh+OgNDEKOGn460DvUvKtFbVIqQiA2m33d0hWp1YTMTqoyzY8jl71T4s4e6mwj5w0SJJLoyyQcOfau3DS1nhntWBwjS6c6jrk0JzXyTKTmwgzG/nIq+NVTNVOpdZb+V7+Df2rVt6/25DBbG4qe0UFUQhGCSY8GsRV9wOreOVyxiCqmjxs0U1VZOUcj+u8D+NEyEveGHE4k+0IIu7jlXGCIpG5eNrcZq6kOyNfdQEN+7Av8eJgJ2uBzb92WSL00qUyvUedAmrOdjzmQS1vR255/uWx9Xy4kEcAkqy8Js3fTZxTDIFSGpXZr/vjvmkl+ZG+Auqs6EZReZr3a+onXNVH7YWPcbFvl23RYslGMpEz+1UkGUv5fHS4YGHxfpcFHxV
 TogObZuE
 z1uBmbn0Ifm8Sp9KL9iTJy/EK5rsFRSEu9Xv0CEzjzTo3UWtPGTAz5TDG9XDjHkvaOwLwrchcs8Y4DtNitgGCtWoQOARJIy12hhXocX0XAK1i+YqfLFYMGYJ49wrKhU5w7LMf/OQr4X5h8ls3LUzGKDgd/gDKkmurX4cTFVl4uhVhCy+jGz450F7sgwgRMusTrVYNs4iG38lKOwyr93Sm4+lo43tc1AzfRB4IzNQceAv88yPcVK8Do+bKzciGOu28/WADs/ODk2dSyLupNU3zzEk078saZz66zv8yxh0W4irFYG+tHXZTv5zV1pPpO+rsjziNcJAILMbrwUWk82vzRcxw9oJ4zdYT0XNsy8Zp6sjBHOkA3QpGOT2hRrBAli3sF50q4kbDRlv5iitJOB4QUO/HpXp4tTZLfyou5OOuDgDN08lfO6iGIEXubdkXaEdYZCM/NTTCZZZMWuBhSJPhkBMkKPQ1sDdj+vDRHTjBlul38LCkI/7kOXO1Q5MNoR6me3v4w+Gtnyu4wPFwMM9s8S2xJO/s4LBws5YxNxy1pwqjS2dtYuQ4ZbGJiq9sRhZSj9z2VlWTttnTrjPyIkKRfE4bZXPdtrwmlfKLmOjyNi+QU5yRIhlH8aLWeBVCVjBIoErPLoSzGm1WFUCHw0AUU7S6+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> erofs needs to traverse readahead folios in reverse order to achieve
> maximum performance by
> 1. reading all folios from readahead_folio();
> 2. storing the prior folio pointer in folio->private;
> 3. traverse from the last folio to the first one.
> 
> Add readahead_folio_last() to achieve the same function without using
> folio->private. __readahead_advance() helper shares readahead_control
> adjustment code among __readahead_folio(), readahead_folio_last(), and
> __readahead_batch() by checking new private member, _forward, of
> readahead_control.
> 
> It prepares for a future commit that replaces PG_private checks with
> !folio->private checks. After switching the checks, erofs's use of
> folio->private without bumping folio refcount can cause unexpected
> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> reachable.

Ah, I was just about to ask. So it's really about folios never using
folio->private manually (without the attach/detach).

> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> ---
>  fs/erofs/zdata.c        | 13 +++---------
>  include/linux/pagemap.h | 56 ++++++++++++++++++++++++++++++++++++++++++-------
>  2 files changed, 51 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
> index e1e25ca0d1904..78fd7d980e957 100644
> --- a/fs/erofs/zdata.c
> +++ b/fs/erofs/zdata.c
> @@ -1898,21 +1898,14 @@ static void z_erofs_readahead(struct readahead_control *rac)
>  	struct inode *realinode = erofs_real_inode(sharedinode, &need_iput);
>  	Z_EROFS_DEFINE_FRONTEND(f, realinode, sharedinode, readahead_pos(rac));
>  	unsigned int nrpages = readahead_count(rac);
> -	struct folio *head = NULL, *folio;
> +	struct folio *folio;
>  	int err;
>  
>  	trace_erofs_readahead(realinode, readahead_index(rac), nrpages, false);
>  	z_erofs_pcluster_readmore(&f, rac, true);
> -	while ((folio = readahead_folio(rac))) {
> -		folio->private = head;
> -		head = folio;
> -	}
> -
> -	/* traverse in reverse order for best metadata I/O performance */
> -	while (head) {
> -		folio = head;
> -		head = folio_get_private(folio);
>  
> +	/* traverse from last to first for best metadata I/O performance */
> +	while ((folio = readahead_folio_last(rac))) {

Intuitively, this should be called readahead_folio_reverse /
readahead_folio_reversed, thinking of list_for_each_entry_reverse()?

	list_for_each_entry_reverse - iterate backwards over list of given type.

or maybe readahead_folio_backwards (which matches the forward below)

But I'm not a readahead expert :)

>  		err = z_erofs_scan_folio(&f, folio, true);
>  		if (err && err != -EINTR)
>  			erofs_err(realinode->i_sb, "readahead error at folio %lu @ nid %llu",
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 939f3a5e973f6..2257df004305e 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1415,6 +1415,7 @@ struct readahead_control {
>  	bool dropbehind;
>  	bool _workingset;
>  	unsigned long _pflags;
> +	bool _forward;
>  };
>  
>  #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
> @@ -1479,18 +1480,25 @@ void page_cache_async_readahead(struct address_space *mapping,
>  	page_cache_async_ra(&ractl, folio, req_count);
>  }
>  
> +static inline void __readahead_advance(struct readahead_control *rac)
> +{
> +	if (rac->_forward)
> +		rac->_index += rac->_batch_count;

No expert, but shouldn't we decrement the _index somewhere in the other case? Or
where is that done? A comment might help :)


-- 
Cheers,

David

