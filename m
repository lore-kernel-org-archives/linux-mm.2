Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C88C56205
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 12:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDEC26B007B; Thu,  6 Aug 2026 08:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8FC76B0088; Thu,  6 Aug 2026 08:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7F0F6B008A; Thu,  6 Aug 2026 08:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78E3A6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:05:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05A911C0FCB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:05:55 +0000 (UTC)
X-FDA: 85070715870.01.A6D7A20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5172340011
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:05:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIqEvcqE;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786017953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h0zNNGX4qFrNMno4lrSMDfcW5CtDQL9/IxlFVAyJbyM=;
	b=CxldbElBqQZOJA60eVhaXWOe6dvtapGta+Vb9j//XFr92tYENzsbLCZEjNewPJgcJqD5gq
	Yym0tM2x92l6LYXvPNi+JkLV2JmJL0XLbveD8Dro0SwFNZ4TqVBUKit3d7SVlmnZuBl0a/
	DR4/SbZwHyrKTii1RrQlfos2APZOjnk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786017953;
	b=BCeqFbKJ4gRsahRB6S6zPHeYfTD8BnNOvqiDviV92ed7n8YGklE5gxB+8ujueE6jOvhlDJ
	VibsZPVD8PoFJo9BchR5nIIfoUsm5EPBcgLXoeve2ppBPdWLuILf2RjVOzGHkIgQo6b5hg
	xf1pyUb/IAk9ewiG4i6q0W/pMhYLWjE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mIqEvcqE;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D22A360A69;
	Thu,  6 Aug 2026 12:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC8F1F000E9;
	Thu,  6 Aug 2026 12:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786017952;
	bh=h0zNNGX4qFrNMno4lrSMDfcW5CtDQL9/IxlFVAyJbyM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mIqEvcqE2VKlk3on/q4NBpSGnc/1rfUvHrz51Q+HYSRCBxP+L5qRKNs3ypvzcoMdT
	 jLk9VloSqMWEi3a1+1tLm7ccVDag8Ym5qkAsjdQnxANCBS7WyT6IglQyXbYVXLplOy
	 ElO5zAsJ0fIG2xhSyDRfbH0Hk6MzCUN/Iy7/c0EodNWiudDqae5+ypr9MLUIiV3+Y6
	 iC7st80B2JxUjVz6VKbRV3enkoi5B4cYOFzVnyoW4+m4Zc0HGtxRt9pNtzvKRXIfQP
	 ps0lr1zxL9UuqXDICxY7eHyJSL7yCqVAmzAhuCSFyVjsB+zzhbZXdSl1OVa53GMQY1
	 RN9U7Qh/Aqu1Q==
Message-ID: <d8412d0f-feaa-406f-81f7-8e95efc9bcf0@kernel.org>
Date: Thu, 6 Aug 2026 14:05:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] mm/khugepaged: extract young page check into
 pte_is_referenced() helper
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260804-khugepaged_pte_refactor-v3-0-0364cad642a0@linux.dev>
 <20260804-khugepaged_pte_refactor-v3-2-0364cad642a0@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260804-khugepaged_pte_refactor-v3-2-0364cad642a0@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5172340011
X-Rspam-User: 
X-Stat-Signature: 68x1a5nhtxu4ccmdrqck693f4yj8yiax
X-HE-Tag: 1786017953-980549
X-HE-Meta: U2FsdGVkX19mqWDSWoj5kcyA4OqyO2Eu+PtsBGbLCyktOQw8oxXubbB7sYgaCujmrsgb/Y5peMRQjQMYJPIeRWJn45D6SGWWh/LiC+jkgNSlgDJ4yH/jMEByvoL92oLbOfSo/EKCGGQ3hOQ6/YUtxgnIpxZcRu09E9xG6oDF8EVjqVajP80VugLXYIZo0V7FG0ar2yUz4miA0mZ0VffrdffDOZlSBdVKRxo1BlXxbKotSdZN7c+j4um4yA3BwmYdRM3pzhkxOiB1UUztHFX1b/DI7ig0caMgwYxioSN6oWmd3hpckh2iOQng625ZPd3YqxrfJJxHi6jjp+8RtQ5vqiuZzpHM1KiAItWbBdEqBmznvV4/neRfRalV92RgC2lRvOxhGDyl9rrYd9q720B3ji75jyxlpI7v3gnZna8cbeUoBTrBo2LoIK2TAMiwknrkPsZnCL8Vz9no/k5fcxxbUfiQ00jjH/hneKuTegJUDyLlQy8ioxksp9kSzjRsoYZokNOZANF/b9qejtguRkt7kv1wjdwEq73a6p05Wn1kl3FCu3VszgwJ36p865+/wkMpD7AeHxMBr0K661UJw//SEQQNi01OOqDw/I+wI1qLf+l8TXzN+PWdAQAUzmaRMumH0kc298yY+I55UbM4YlBTA0FMhA3WKVXx0CyiRNAoy8PgOlMf3jt8dk7NJV0tvAvWA6hx+RNMMPKaP5JjJaS5YEy3lnuMyzfO+oQiEtQC0weMlsov5vUsQJEmBvPF3p7442y9l3TzEI6NVgREq58Rl8UJ8+8ZhkD48SMvdZRar08DOxIvcYYk5BI7z84Y8bCHmc4Vso7F1teTgP0LYEHI1roqFWkZ59/v7o8YZKcvnImn7jkR4ROFQ0jXE7Z3nOlPZit9GvuJTHhYzAJUQMaijSVDMxPJwLFAxYI+53ebCG4Iu/3IC9smRs451gkhyDmtZRfiWBDU4mnVY0wckvI
 Js0vZN5A
 94YiBG7qSOGRrSIhWwYs9bqACJ2YlN27qzcRxStpuGvRbrs0+P5kmRJ3hL+8RLyHE/WP/4O9/So63h6JDIdOfzWjD4/JQLwGq3JY67sYveMfqHjX4CrH8pdX+kAzRAWYBAMDn5PHA+gTK8CLBZIUDvRoGnGimmR9Z4rcFj+6dUVfhuzAJNH7uFyCyX3RjcJ9PY8gGuE0JjqHZObUh1pXIVBn3Wm5pGLq67ol6R2JXCyrVHJhkqpAqSe9U1Dwu58kJI1ys2XAUYpLdDftXz0/WTAzD2KT1RBEYKwFI0EHzo1AgmhfJ5HRLy9GZuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 21:25, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
> ---
>  mm/khugepaged.c | 35 +++++++++++++++++++----------------
>  1 file changed, 19 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1e26ea97381a..9b15c1740943 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -672,6 +672,23 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>  	}
>  }
>  
> +/*
> + * pte_is_referenced() - Check for enough referenced PTEs to justify collapsing
> + *
> + * If collapse was initiated by khugepaged, check that the page has been
> + * recently accessed (young pte) to justify collapsing the page.

That's rather imprecise.

> + *
> + * Return: true if the page has been recently accessed.
> + */

Ideally we'd find a helper that doesn't need any of this documentation :

(1) Just keep the cc->is_khugepaged out of this helper. It over-complicates the
    semantic.

(2) Find name that incorporates that we are dealing with a PTE mapping of a
    folio

> +static inline bool pte_is_referenced(struct collapse_control *cc, pte_t pteval,
> +	struct folio *folio, struct vm_area_struct *vma, unsigned long addr)
> +{
> +	return cc->is_khugepaged &&
> +	       (pte_young(pteval) || folio_test_young(folio) ||
> +		folio_test_referenced(folio) ||
> +		mmu_notifier_test_young(vma->vm_mm, addr));
> +}

static inline bool folio_pte_referenced(struct folio *folio,
		struct vm_area_struct *vma, unsigned long addr, pte_t pteval)
{
	/* The folio was referenced previously ... */
	if (folio_test_young(folio) ||  folio_test_referenced(folio))
		return true;
	/* ... or just now through the (given) PTE. */
	return pte_young(pteval) || mmu_notifier_test_young(vma->vm_mm, addr)
}

?

-- 
Cheers,

David

