Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1854FC5925
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 10:25:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BDE76B0088; Thu, 26 Feb 2026 05:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23DFD6B0089; Thu, 26 Feb 2026 05:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123246B008A; Thu, 26 Feb 2026 05:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F09D16B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 05:25:34 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BD328CAB0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:25:34 +0000 (UTC)
X-FDA: 84486226188.18.23D357D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id B1541100003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:25:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ljer1qeH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772101532; a=rsa-sha256;
	cv=none;
	b=VWW1nFLxI4+TrNdPQkYoRvA9KX+n/l2RaklJSd3NRSP6KlnU+WJMYHl6OWY5gtmuOe46/5
	q80WL7GoSBDr8NhAVp6f95HyBxiiLWP+Lp5294K6f/vmFNrLiaL+J0u+xltNG5KdA0zpq7
	WBnyigWB79h/ktKS6RZG8XNhOj2B6EM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ljer1qeH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772101532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kEvfYFKzDVjZMfaOPoodGpE4vzCEF4L5qYVYpRqZ7Q=;
	b=5rP6jgfii+JIHFwUC0ljbGb0GmC03eIwH0MnuhzDALWT6+gJMk2zC56U46pzDajiwZtJui
	1gUElTvkKt6T6N7v35iURXK3vywhu4F5a2nSZQSQ3ucauGL5Z+Iy3Kk1EpSKQC3RsJwnVB
	chN/R6Tth8mNQoekZ81X7BmffkHEb8E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C340143698;
	Thu, 26 Feb 2026 10:25:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C424C19422;
	Thu, 26 Feb 2026 10:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772101531;
	bh=TscTll6shwFCsEbTmyYHSLu1Gx7N8flsnoMTzejeBvg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ljer1qeH1314umbp8UuGC6ihlDBtyXGYDypbyQaDR4SB3A9yHQZL48P8nv7FpmpCU
	 nDVPLRdgbsRYRJvRyuHcXz66wnT7xOIcR1s0eVTozTi+yCvtwJmAy/8HyOLvjMf95l
	 f49gmbzsXn4qrRdA4OO53cJy0iYfzuZUQq4L6x3w9rcnqXl9769k2rqYJfHHIg0fci
	 gmFKFPKBwS7kIOfy3sBNrXIWdwzIbFC24UBRGNK2TLW8QZBzpcHWdcH7AkvpOGtSJU
	 9bwANzkMlNKf1IIAgFk4asaRVW8AYpXhx0dGcmRpkWAMqgl/Dy3vxyKjEklJupCLuq
	 ScHzLqc3YdoTw==
Message-ID: <60ecebf2-a708-4797-bedd-588c3e9931ff@kernel.org>
Date: Thu, 26 Feb 2026 11:25:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
To: Maxime Ripard <mripard@kernel.org>, Sumit Semwal
 <sumit.semwal@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 "T.J. Mercier" <tjmercier@google.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
 iommu@lists.linux.dev, linux-mm@kvack.org
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B1541100003
X-Stat-Signature: swyhw7nxzz5g9dec7nhpsroq46jzgqcc
X-HE-Tag: 1772101532-850554
X-HE-Meta: U2FsdGVkX1/ytjNnYrFLTDFBL0yyFLz1B1pZINvsWM9AZ2TmXQV+TJeW+SCegpkRTiIddrlE3c1UdJGiVoBzIVWYchosLUNZg5WbgPAQkyvO1iYVv1KJa/kAeOFoSoFaXaf6y3qs0W0BHNE9TZZWYj9RiEcA1T2agW1gihLBNCdiY4/64xjirGw4dwk7sOMcX5nlOPxLvuQ4sAhrnTMzHRrlyFWjT9oC+FLWuELc0C+emes/c2SWYmsGeJYCRnq2haMAHrycXdfAy5wHHfZ/ZQSsX4wLOyngiQ8MT1QaBSbn/90O8FcbL+fOvXS8GcmxCqloZ5Gz6WLa4mUt6CyZH1IhqH8E8nWjvIZxq097dH9Fg1ZjHp/oESZdoFWKsgP8dE1pBbJBoQ9BSrjw0VA8x/yEI3/N1sHD6tJZAKEurocFhZMdgY7G5+Gu+ZFdXOBFYSovngPOQTa9MabBHpNoU4CEhUnVVFfE/jPW0co+OyIElIugAm9cplp2FSyHfx+xh7j34poOPuGmJndU5R1RCRqdEIrJ1nKT7aZ2AfOPFi4kRFY3vzGCcFy2CHkXU3ypnYlfdeXUmYwacMW0pAHJZMc1cHkirbNTlsLYnYQKuPET7oehTS6YttcOREG3adf0AODk+QLzjVOoMeUqYbwjOqNiPhQpiTio+jbDiTQSSrzRYRKG41syyaWwDgrrsQt3iyiUxqbjuFKVEGn+aTSUPJbrEz5fY1btET4vNHEPl1OzFGnb0hdFKsHCTOhM4WWWq0XoZ7KOb+IyvaPIJ8J+XBvgpu+BtQEiJJNRLKElNfJ2xjrjMogbe3ziRPbw6OAtu+OxSvz28nd56WhjsM6RbLSgeFVhFq6kmUTs+wUeXQxUCuqPbm35V/ZAp8dGOm4vZhSlcgUOlKceoDdCokjR3DKdAlcYvHhDwK1smFOsb9Db23FGs3mqqnT6k4y6U2F6xNqjOAZm/jQKHY6B7sJ
 xVcknMmQ
 Hb9ALEWbhBB7e5W8MkW1RKsOlx6wMmJzmiAwCe8JDTJ9b/qHDa8Zp6Y8UeD9nNCn4Tqkmsy/ajJUf4B3L1mJmOvBJ7FhWcjYzyhg4zNkdMzpeUSx3zsF3M0SovE0655PUvofsQn29FBOs5JO4I5wgDYfqc4w2aiTjcNx6KxF6QmZVCJYhZ+aHzC/qTlnmkWYsYsReglEZCRcPkkbudSoCT1EiunvhNUG/AdUVjwlg7E5T2tJWF7iUgBY5LP8xJOVCAc4usvuzRzn8eXmCZt8rb31ApqbawboxvAAKJTwcxSuCUlq78LTFmXL3goV2nfkNrlmNXjKVhpnSIH8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 17:41, Maxime Ripard wrote:
> The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate and
> free, respectively, its CMA buffers.
> 
> However, these functions are not exported. Since we want to turn the CMA
> heap into a module, let's export them both.
> 
> Signed-off-by: Maxime Ripard <mripard@kernel.org>
> ---
>  mm/cma.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8ba4397f018f6993d962 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigned long count,
>  	if (page)
>  		set_pages_refcounted(page, count);
>  
>  	return page;
>  }
> +EXPORT_SYMBOL_GPL(cma_alloc);
>  
>  static struct cma_memrange *find_cma_memrange(struct cma *cma,
>  		const struct page *pages, unsigned long count)
>  {
>  	struct cma_memrange *cmr = NULL;
> @@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  
>  	__cma_release_frozen(cma, cmr, pages, count);
>  
>  	return true;
>  }
> +EXPORT_SYMBOL_GPL(cma_release);
>  
>  bool cma_release_frozen(struct cma *cma, const struct page *pages,
>  		unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> 

I'm wondering whether we want to restrict all these exports to the
dma-buf module only using EXPORT_SYMBOL_FOR_MODULES().

Especially dma_contiguous_default_area() (patch #4), I am not sure
whether we want arbitrary modules to mess with that.

-- 
Cheers,

David

