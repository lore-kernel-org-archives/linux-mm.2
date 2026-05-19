Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B011CCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEACB6B0005; Tue, 19 May 2026 04:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9B686B0088; Tue, 19 May 2026 04:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1206B008C; Tue, 19 May 2026 04:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB27B6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:08:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DED61C0100
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:08:31 +0000 (UTC)
X-FDA: 84783442422.25.5EBC904
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C0E3B80003
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:08:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+ehzlIs;
	spf=pass (imf30.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779178109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SaESP9+gRALgZe3+AlpVGd2JjD79gLhwLZrXmvwvo2g=;
	b=ezhH7b0PWdmgfePG/dbZaeX5B7vOBU5c4Y4dD+Do2JDD8GZSpS65Jbo8Jem2uB6zfGPNS7
	t6ZbGqBE2tdjuIGx6sea1XpgyiD4sO9RcGlFaNiAQsn/0itLfAArfsWH21Anf3JGmIs2XE
	kzwdWwYkq9cLOzySiLIxTzDpawqUSfQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G+ehzlIs;
	spf=pass (imf30.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779178109; a=rsa-sha256;
	cv=none;
	b=7G9/LbuEEcWLBvvjkkHGPH04wH35Bz4kH931dDcokKzUqZHS8t48QpEiF1CId4MtLH90tH
	+6qo5yLUv7eCZ/cM2ctLg+cdmK/HjKU06SR36qKb9IsVeL76fmx4ywHgwzQi6QoFWfFFsf
	FB92ahkxJAzT9qRIKmvCQzSVROWqGGI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 469E1601FD;
	Tue, 19 May 2026 08:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B92C2BCB3;
	Tue, 19 May 2026 08:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779178109;
	bh=Z5sg7RccpoW46OV1kiETxIaKegge1kxxFQQvSMdVi8g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=G+ehzlIsd/HSuAHtNo8Lzf/o/Vh9CSDDoXqpEDIPSW2HUziNV2ZnQhJZ+YxJtUSYc
	 actaa0nq3fR5UO46F0zxLzF1bUryf0o45Lz2Y60qp9u7NH4cLSBXQc9FiPHJ9gpYj8
	 7M999OMwbj8h4ICt1HHt7G3pB2s90aQ+SeoMisqbp9FSJM32TM1AzDKfTSXwkhUg+t
	 q0vv7um5nOQa366TqTy5Xl+uw8/Wi7+M8iwkQg2as8OlaKOtNlGBkcssonRakQlO7r
	 ePDOYNM20q5t+vxJFUJGB/PJm17P3R22xg7LvV/TjesR+I5NJU2grNuMMqU3YHlt6E
	 TK4yOH6X8Igcg==
Date: Tue, 19 May 2026 10:08:15 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: ackerleytng@google.com
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, fvdl@google.com,
	jiaqiyan@google.com, joshua.hahnjy@gmail.com, jthoughton@google.com,
	mhocko@kernel.org, michael.roth@amd.com, pasha.tatashin@soleen.com,
	pbonzini@redhat.com, peterx@redhat.com, pratyush@kernel.org,
	rick.p.edgecombe@intel.com, rientjes@google.com,
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev,
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com,
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Dan Williams <djbw@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/6] mm: hugetlb: Refactor out hugetlb_alloc_folio()
Message-ID: <agwab8q-C2ZetFOJ@localhost.localdomain>
References: <20260518-hugetlb-open-up-v3-0-e14b302477f8@google.com>
 <20260518-hugetlb-open-up-v3-6-e14b302477f8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260518-hugetlb-open-up-v3-6-e14b302477f8@google.com>
X-Stat-Signature: 3u7uej9gxyuzt46iuusb3khnh85di5zi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C0E3B80003
X-Rspam-User: 
X-HE-Tag: 1779178109-249745
X-HE-Meta: U2FsdGVkX1/vXgp4tOoQjj/mV7m+cB+8P9tcwCGR0YHXqQedhJ8cmD04VHtZmuDE9CQippTJS0VsLUdJzbG/DLx+9wG+YgaSddqEtfsDqQvaRFYPPQFym8gDAJEhwqg/+HriGEQkCNs88oJr/3lNmEIKJ1MXGPOnIYXjWdM18Ko8eju1iFwQ6lysToHhww0ek/2y9zWhdivju0msNWR6JtTRw0uYQQHix4rqgSY83ZBDcd57qRQ0xMCTbAptIqDDJN7Z+R+cxJU4BhtdrAGkdi6B5/olUtfMeF32EJSXMx9zJ8fb3CyzR1yPuOuH+39ABRog44iIaOSqfqTY3Zz5UjIv/y5q5gpz8l1o1RrEMnGJ+a51e+RgrC+GUh66hdVnU7DwhZPNqgLyR4Gb1tsXunI6rghrKoOgI4SumY4MYR4vjZWWFerc+/+2z2TMDp+zZwsmAJxXcJ9Ea72+e07ve5iVmRvqmg6ZxI6h6XBuxZbnrAlF3gfcRnvK5UR84jEtHwYc8SXN+5CjTKJWRMYwnhdF3XejUtgEGbEuOqmxSZXOazMXZOV3VakZeeZ9V1mhOCODNMsXylc+O2TS2NfWGo+LWKA8j6bbrX+U5LSz7Qo81Nz1wRFvwylB/S0hWUWDpSItzU/llYsuHg2zPb5ML16LshGqFxFcN6wHihJWftqDXHvheWbPBezl+Mq7RAak9M/GyJ4x9/JNRku2ktDNuX3TYLP6UgMdFVnZDyf7UETB5751tRpqv9CBHom0l2WD1PFxHFwbnuvbR1tUs8qHIrVKW+CNijbeiIa5VGJ/beql/jyAvVLqjHtqw6eHb/9ikVy8vhf4JxCSWoBZxYuRMtAqA4dUdMQpD7ibCRBMMm1q7Xj9Dum3LdYX/tLsP61UkR09KifyGYgOqzoyf2r5gNW/5p7ErbBpvLMRBmhBK4IjFrHAo4b7Kzi8MU6RWNt89zuYlKeRIFvM2gwo3HK
 TOrtusHw
 M4M8qpGOuTyF1ieYQOvskXAK7L63g6qx138RYsk5M/sSNaxL+bGuAu4nrwPGZOOiDdXOaXePXYXkEXXFX8ajxUCpW6js+DgHuXZHALK2TRhq4mjhGDDY/U4szAKpgKkmK6owMQQ4IpfocOXqGwPiM2H1FWlXMJkHLyKaVESYSowx9DpP8spe6eowsYzTRISJNNpjZLzoedlGDr5nCdPEL6CWbgrPYCV5GEwVALTpUuWh/GDDFN8iNYQ+rQa/mNO/0weCsTvwC8T1Nlv7mk5uooU8gxZnSQ5zfbaAsL2rdXBn5bD1HypUA9jUwXCyYl68m4OIVTngpyQzwK3oNWdxfhhVfNLkfzm93807d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 05:19:45PM -0700, Ackerley Tng via B4 Relay wrote:
> From: Ackerley Tng <ackerleytng@google.com>
> 
> Refactor out hugetlb_alloc_folio() from alloc_hugetlb_folio(), which
> handles allocation of a folio and memory and HugeTLB charging to cgroups.
> 
> This refactoring decouples the HugeTLB page allocation from VMAs,
> specifically:
> 
> 1. Reservations (as in resv_map) are stored in the vma
> 2. mpol is stored at vma->vm_policy
> 3. A vma must be used for allocation even if the pages are not meant to be
>    used by host process.
> 
> Without this coupling, VMAs are no longer a requirement for
> allocation. This opens up the allocation routine for usage without VMAs,
> which will allow guest_memfd to use HugeTLB as a more generic allocator of
> huge pages, since guest_memfd memory may not have any associated VMAs by
> design. In addition, direct allocations from HugeTLB could possibly be
> refactored to avoid the use of a pseudo-VMA.
> 
> Also, this decouples HugeTLB page allocation from HugeTLBfs, where the
> subpool is stored at the fs mount. This is also a requirement for
> guest_memfd, where the plan is to have a subpool created per-fd and stored
> on the inode.
> 
> Provide and use alloc_flags to allow more allocation knobs in future
> without expanding the number of parameters in hugetlb_alloc_folio().
> 
> No functional change intended.
> 
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

I am traveling so I plan to do a more careful review in a few days but I
wanted to do some remark:

> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
...  
> +struct folio *hugetlb_alloc_folio(struct hstate *h, struct hugepage_subpool *spool,
> +		gfp_t gfp, struct mempolicy_interpreted *mpoli,
> +		u8 alloc_flags)
> +{
> +	bool charge_hugetlb_cgroup_rsvd = alloc_flags &
> +					  HUGETLB_ALLOC_CHARG_CGROUP_RSVD;
> +	bool use_global_reservation = alloc_flags &
> +				      HUGETLB_ALLOC_USE_GLOBAL_RESERVATIONS;
> +	size_t nr_pages = pages_per_huge_page(h);
> +	struct hugetlb_cgroup *h_cg = NULL;
> +	int idx = hstate_index(h);
> +	struct folio *folio;
> +	int ret;

IIUC, hugetlb_alloc_folio() will be the gateway function everyone will use from now
on to allocate hugetlb pages, that goes for hugetlb itself and external users like guest_memfd.

The gfp flag should really be defined here, because otherwise you are creating openings for
external users to start passing their own crafted gfp flags and that feels wrong.
Sure we can guard that down the road but we should not really need it.

 

-- 
Oscar Salvador
SUSE Labs

