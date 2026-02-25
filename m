Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 044A9EFD209
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 505206B0093; Wed, 25 Feb 2026 03:49:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DCCE6B00D3; Wed, 25 Feb 2026 03:49:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF746B00DA; Wed, 25 Feb 2026 03:49:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D5076B0093
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:49:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBCE4B8DA5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:49:37 +0000 (UTC)
X-FDA: 84482355594.21.94475C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id F39E0140004
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:49:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqcPgtBX;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772009376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3AOHRkGJfGPdSXMaJLT/sVfZ4Dm1PXSGeX+0SmZhzyg=;
	b=g/6JdE3MeGDPi4KCjpWTqjXW6Xx/M4a64BFJ3QwyYcbkJJMV9Vs83RCpPvV5MbHajx5ylv
	yNXp+WTXOfDawlCGFVStt8OWrG3fNVtg7IuQfjqsWzUsb9Y/8gqi8m0hwLv+5xhhS0n8AC
	Y36mo3UTlOAd+67jnpEcxrn9QjZmV5I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SqcPgtBX;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772009376; a=rsa-sha256;
	cv=none;
	b=cIYVJzXZCaYc+74ZdrCWS+bbuCl09pWDQ52FA/X/5wX5tLJ3fRVaEfK5EV44k+97LUCiKW
	BGFJIW3CLLuMwZE4Zn3cvSq5gz8KZMq98752nE4j2yjtCSz+o9PkGME+RnpGKd62e0Vtjv
	OZA80Vun7HI7ex/39ElMuawe2lg3Gjg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A670343E44;
	Wed, 25 Feb 2026 08:49:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E351C116D0;
	Wed, 25 Feb 2026 08:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772009374;
	bh=iGFhhjWcf3fh9QEg/MjC3BBzlLN2UyZMh4sP5/wvP5E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SqcPgtBX//yxnuuwt/5NH7ngw6V/v3KrTHUgBKjE6cU8V7B5uzOEa5xidi+zNpD5z
	 nhv8EQEWsgWYCSmydRlN2I0Cb9buH9WZMz+uOW4bD4UYBjaNd2tUgJ+SJtpU/lrZyb
	 8Xh6N0YlNJp1FQiXqiQJxzeQbd2sIjyLcDNZH67QAzg9CaqkYYrfTMaPQjYFHbgT7f
	 bn6nK5+5ZtxX5lZYJzbLoTw2YAhoEOueKwAfwJ+83XLQV6cC0p62v6DQ8Lf00wsbL6
	 6vkSEqzbFybuqL0LzaDv7v+FYhsE3i9aIrrok5PtFSYwsZE43QmQo4MuJQcMCewEfE
	 Au+Pd6NoumD8A==
Message-ID: <f1979ad6-d5e1-4ef1-9c23-5c3d2b7e9019@kernel.org>
Date: Wed, 25 Feb 2026 09:49:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
 Ron Economos <re@w6rz.net>
References: <20260225031231.2352011-1-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: F39E0140004
X-Stat-Signature: ficn8oph9zfaf73oyef63b8kkuzqm94p
X-HE-Tag: 1772009375-33304
X-HE-Meta: U2FsdGVkX19rkymc7TMz/6TjuXAezeB3ZxBr0SFxxnNYey+bWqpeeYB/ZX3uZRRrEjhRwyt+EApDipTs0h/Xo4nFeBtF7v5+3/7jnODMuglyjT/ztRW8oIWxswtaZxV4bG6tXY/IULMwUljSXGzseLGf8hTVAQvr2F5z4tGO5+uoOLBIxYlCpNeBdIudlRdb6r+sHXuBvf2dZENG9oxFKF/egox2jWkvK16bJsX329oZ8UJRRhppc5eWQuywJZWqPMGDP93/b9EUOoN3W3kVcq3yM+3hjbCqKWkM/hY+a6N5l8UgOGCYTvcGkjeXsqLCQ4N97YCakjIFzbFopO0Z26nvckZ3Y+mz8jMkLQv0UjwJBJaJsXSxmGqVsC2XRV4obxe0foYgKuPJb5EHQuTc/TGjeWA7blNLoc5q1X4Z+nITM5cOUOgKeLspPITHvxsBr+i/tE83NtOrWQRGFs2kDMhVGWBwJdG6T4dihKm4B55EW3EuZU2Boe6ANGG5AmrtAMoOm4SC/eHTW4hBb/A9XiaqFgDv/cgKzpqtVCTnQk7VcCHr9xs4dHyfJYCToGXZUqHhfMDviS5MsWeJlhcAD3OynqKusvSJDNdd9OIixpdA8+9gW0cIHmnufSBgAPqCZP99w7J9yXD3IyE2Uee/9xj5upcYSddRs9ug+Af9QttGuK2NdmY7VcdUyzvyQ5rBBduGLOxkdusIccBOR18iY5EGkisInUG/Sc2LeraW33xCjKGPnk1d991R3q/WI+C9aJWzb9XNO42mn/EOwiG1UjbM9p7aQPlr9+CiVNz9P9hd5cZUiaCpDhnr7VLn65uaBoKJTZRJzCeWTeYVrvpauG4rf0Rh8uwOeuz7hCS9Mplg8xyuCzE4vcX72zGPrxZzmjFD9pdRkJ322RR47OaM6iax5q2ci52eu86LKoSEddhSaI29bmIWao2pQPF3BhOtcwibLPyyCzjikk1DI+X
 6Dx2s90N
 juflZ2LGaG2evgWVatckYmlmWzEMirjpQfRo3BttP4JK6dLEkI18lMGbIkW3Vg62pt8S2caqRi1Q6aRoNFAuwW26+hMBgNTZv0DcTNACQig+fKSeUBJQq03EhcxTkXZ+5s4B4GBoKdUxn1hv6phZ0VCLuP5cBrts89P/mTLWLobl6y7XwpyF1uJUqM3XtldDWV9hCUJ7AQAbFluq9Yt8jn4wriFEt3CRbrV5cTrh/zE1EX9MVvsjoyw+SIaeW2oiJJZ9fDUqCyN6csh2dMKyoyTONUPF2eF+uxkgOZVDKEce63zdEVtbEaCsNZEOv0iOvxZv1eAWYWVTZUJd/cvj0YowgAx1KlDoQ9bDL6N1LG/TYQjiEhKEonNTce+UasbKV1APRgaNIyTBR4PuS7EQhUyOx6CoK4owTOs2E76fEAeHGSw7IAIdR+/bRTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 04:12, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> From V2:
> - Collect !put_page_testzero() to get the right result.
> 
> From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>   loop.
> 
>  mm/cma.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..15cc0ae76c8e 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  		 unsigned long count)
>  {
>  	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>  	unsigned long i, pfn;
>  
>  	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>  
>  	pfn = page_to_pfn(pages);
>  	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += !put_page_testzero(pfn_to_page(pfn));
> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);
>  
>  	__cma_release_frozen(cma, cmr, pages, count);
>  

Thanks for taking care of the fix.

Debugged-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

