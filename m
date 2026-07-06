Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77375C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 17:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DECD56B00BD; Mon,  6 Jul 2026 13:08:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9DEF6B00BE; Mon,  6 Jul 2026 13:08:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3EBD6B00BF; Mon,  6 Jul 2026 13:08:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2156B00BD
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:08:15 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1950F1A01B7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:08:15 +0000 (UTC)
X-FDA: 84958984950.06.76218C4
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf03.hostedemail.com (Postfix) with ESMTP id 94B3C20009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 17:08:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YWhV4O5/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783357693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjJeDZhpR70EaRE9MTzxl+iC6NvcG5zg6LLdCRsvLWI=;
	b=UjrJNcvklA/aLKEvqJcGHsz7in8ueHMwCX4RDvWxl4XHLKqeYOdhI2M7t8v9OKt6/EuAdw
	f6dXYC3xaGYr+PmPbhW3tk6WBe/4s1lqCoeMvMEyFKiQ1MAEH8pi6CdhX9h4bsOstQW6HY
	wfOKCNT2UqaDTUYxpr+g1X+HT1lBMAg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YWhV4O5/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783357693;
	b=EbC0WYMyUvUvZdnfUSRBaqF32qrErUCGhSnuXDJeO60BVJw8YaMZimAsAude5OLFK5/pOi
	VYZdMwGVx5GxTJegLTk+JWvSuj48mN8BU8EmMxgedrlxeGow9+fRmkrflZY+z8SrtwOpkC
	1T9d9V5FHb0D5znY+BGuCx0RMVv7pQE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783357687;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cjJeDZhpR70EaRE9MTzxl+iC6NvcG5zg6LLdCRsvLWI=;
	b=YWhV4O5/JSqoyxxc8P4VH9cUltAOYZa6czk/FoV7SIrN7O7giEOBrioKyDDyyv43d1WKW0
	xbMUY650Kh+kwmjGvvhfaN9HHZuN+Pci0jAgdxz9+gcnjnNDfYMN2dbdS4bgZrEfytUOEo
	fGsO8hsGH+anXKjoAnt2x3PAKOGf/1M=
From: Usama Arif <usama.arif@linux.dev>
To: Nico Pache <npache@redhat.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 1/8] mm/khugepaged: refactor per-scan state clearing into collapse_control_init_scan()
Date: Mon,  6 Jul 2026 10:07:52 -0700
Message-ID: <20260706170755.3387204-1-usama.arif@linux.dev>
In-Reply-To: <20260706154500.39178-2-npache@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 94B3C20009
X-Stat-Signature: no9yfpko58s81q8nkdzueg1483q7d1hc
X-Rspam-User: 
X-HE-Tag: 1783357691-680451
X-HE-Meta: U2FsdGVkX1+4BDQT/dBIvdeufNb0pp9MjSru2GgRXmwO97EMIGNBgfpwNwBJVo8dis4yc83Y5gQxuUlHYAzPYVQfb8VmxiZwhH87Ue0osetfC4R0TEAMWrgz+S7L4I5m9jDj4ESTsVfHRXYt/wn1TPUd2q52SCy9Gxikya/6ad3Kf6ZiLtUIXhqMCxDzjcys5ltUR8aiTtanEbNYbIhWlD65LdMhbj8VvmfoEATADiNTxa50SnUc6fIH75TixwRsaVBLc4BinBZLV7Ia5WZ3vszIt4nY8DxfXBGO7xpITHZN/0ylNa8XUkVZWVTa9xlMMUUgmeZHa3M2ETHahuAHZz+4OiNUgl7fnO43V0btv+bJRJtcJ4G8l/JuUVAyf5DgkVREw956l4V7v+zpfRHrRDVtOEs48+wWch9MxuctU+aXzSKa0+LdFYTqOjvKdLhnSRcDK3FAtBAEEs7frWlW5JErzlf0pr6ITx/q6DkR0A1iQQke5w3A3ohpCvvX2zlELKfxEpEX4Cn5wT6DUrsN6owwn4k9/33+SX/wYiyHt0nmH8poTdmNhi9mQemL6bQE/cbkfZs7pQ3FL9BvTwALOLcPzFi+pIWVn05s7HmSHgMrQoXNJaNb/mIzv8HQ5phYrmLNI8qWhPaGOrAje9NUOfg0HVpGPxyPjs/EnaH5Dn060PbaX5LHwuyikCtYrD4T4VH6pkMf6VzT2iogdt4Ik6gWeDeIajXmBDNnKWeDtl8NtBsqDSuF9wtQo7BaxoODFvz8tAfyTajgGxEci2MdOzSXiqIILsk7I+ilQ5+JGcLNySfdZhRcYuzVeEcXSx8bmwlZqTI5RU58tXUcvUmWdyVDHrP6IJPhrJ2Hk/7I80oszbrM7NzrUDybR7U2Neh+iqnw6Yv/97riRmFjGp6sRvAZQgNCLztL/nqygaP3omWNQ+81irJl7cBagADsGP85pC3BdF2hX53jf/qiLWG
 8SHaE5++
 CipeUOqSuNL2nlfBGOqmnH0eyKReN2tHKb4uZCcrCY+ZlNZKnQddbZJsE4yEmxfd77gJWmlfP7zKKHGnmQjEadobVJmnBSoH87tM3051HKLukpRwryio+0ZiqgPJKsngsJghuVBfJxYInNu6/BjWpb9paaPuDcYu7MOSbfymp/qduaK97IZYnjugqETv0P5iM7V/Y6zPk7SNKK8RrSne4KiP/O5ulzZdRrLo8K9pl52jWzIbTfLl/McRaeHbu+I8WV/mgzyr758fspmHuZEbCeAJprw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  6 Jul 2026 09:44:48 -0600 Nico Pache <npache@redhat.com> wrote:

> Extract the repeated clearing of node_load, alloc_nmask, and
> mthp_present_ptes into a helper to reduce duplication in
> collapse_scan_pmd() and collapse_scan_file(). Althought file scans do not
> current use the bitmap, they will in the future, and clearing it now is
> harmless.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..b3985b854e77 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -628,6 +628,17 @@ void __khugepaged_exit(struct mm_struct *mm)
>  	}
>  }
>  
> +/*
> + * collapse_control_init_scan() - initialize/reset collapse_control variables
> + * that require being cleared once per-scan.
> + */

Probably don't need the above comment, but apart from that

Acked-by: Usama Arif <usama.arif@linux.dev>

> +static void collapse_control_init_scan(struct collapse_control *cc)
> +{
> +	memset(cc->node_load, 0, sizeof(cc->node_load));
> +	nodes_clear(cc->alloc_nmask);
> +	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> +}
> +
>  static void release_pte_folio(struct folio *folio)
>  {
>  	node_stat_mod_folio(folio,
> @@ -1616,9 +1627,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  		goto out;
>  	}
>  
> -	bitmap_zero(cc->mthp_present_ptes, MAX_PTRS_PER_PTE);
> -	memset(cc->node_load, 0, sizeof(cc->node_load));
> -	nodes_clear(cc->alloc_nmask);
> +	collapse_control_init_scan(cc);
>  
>  	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
>  
> @@ -2686,8 +2695,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
>  
>  	present = 0;
>  	swap = 0;
> -	memset(cc->node_load, 0, sizeof(cc->node_load));
> -	nodes_clear(cc->alloc_nmask);
> +	collapse_control_init_scan(cc);
>  	rcu_read_lock();
>  	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
>  		if (xas_retry(&xas, folio))
> -- 
> 2.54.0
> 
> 

