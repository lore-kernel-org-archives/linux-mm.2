Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A5F606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CHfYdTPU
Received: by kanga.kvack.org (Postfix)
	id 7C1AC6B00EF; Mon,  9 Nov 2026 08:51:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74B836B05B0; Mon,  9 Nov 2026 08:51:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613326B05B1; Mon,  9 Nov 2026 08:51:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 296F06B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:51:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ADA54806A7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:51:15 +0000 (UTC)
X-FDA: 85415717310.26.4FD505F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D46B540004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:51:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CHfYdTPU;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794232274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AX/+bR9hzMr0c07DUMyN6/NPbIMi7uOBDTIaA+XxtRs=;
	b=5uZ7KJWiZ9A21IH46PFtDXZJNQcy6bNFYlqLOdMQXTgF0O4lA3CB4U6bslcQMO4QwDLU3z
	OLhCUyTQFNNyLj/6P62YDPo46i7MxZQGAmVWCkfGqIugY7ehpYo9ayoVHDAMZ+UIDJaB2G
	cgYYOtiFXsSReddaw1GTEUrvy59DTAk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794232274;
	b=kirE+2O0RHCWXcQTNau9EwXbc8f4SKPHSHOq25ZLnC2vc1KgP2FMywyBxwye/zQsdyzvd2
	0dSDC/5cy+mwFGmvKXVVbwX3OmPIz60rSGirffazhEp1Ygb7TAbq3gQeO+tyZCITvHsFC1
	lwssoYi34H5qwy3aRymFPvcJxa8nCQs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CHfYdTPU;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1540B40DD1;
	Mon,  9 Nov 2026 13:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D081F0089F;
	Mon,  9 Nov 2026 13:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794232273;
	bh=AX/+bR9hzMr0c07DUMyN6/NPbIMi7uOBDTIaA+XxtRs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CHfYdTPUz7yEX2kajRcPzZYbNfLvBf7JuKe6HfbZFEeY+6BC0bFeFHBIFhOpUanqa
	 dnfepj2WuBLRol3na/MSWVmhqA/gtRA37iw+p0l2V0qzLz0SWbJCvq7Po1d0z6oMOh
	 mhQ6couONZxjfLyaKSakqea+keb8tY6POfPE3YN86cnp7LE7prMOaPsWP214qxd2gN
	 vJAH9fjiKsBgywW/rC4XDdE0sDUbZelCAmhB7VPYJI9UuTDULwxNpyJzIdufqQ3NRB
	 eRJUtdTJuz/PVpL/DJpvSY4LbdYB2rPSqTz8PAkS8NZZz/8Z5XAWWLaEBkPTmAgxvX
	 y7++oGi0NVr7Q==
Message-ID: <fc3c1e68-9321-46bd-9f1f-4209bf5c6a7d@kernel.org>
Date: Mon, 9 Nov 2026 14:51:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix mlock state loss when migrating
 PTE-mapped large folios
To: Wandun Chen <chenwandun1@gmail.com>, hughd@google.com,
 akpm@linux-foundation.org, fengwei.yin@intel.com
Cc: ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109090846.1068409-1-chenwandun1@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261109090846.1068409-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ooya97m7156fmuto3r6wnaykbr7qc4q9
X-Rspamd-Queue-Id: D46B540004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794232273-266415
X-HE-Meta: U2FsdGVkX18Diww463pTfxuJcDgr3J32ZnwMTMZy7znS44UIv2tpf2GDCg9wTcBkpRBne4sR1w2HI1t7BgbJPUs1OQoykwSLLxDLeegOl37BiKmhUZitWacL0BfV4V420C0hZmUcxhqmB9SJm562xEAqi8boS9iwYRvq+EYtVphNyTzSRaSATuPsSE0g48TIVwEnsQuJgk7ATEGEcpJuulAiFACKZZA4SOso02WU7f5lXWyMb8bSeDEgTQlpJsyYkrlrR7KMCpwxf6usvM5qA5GLI0UNapuNUhCiTsKOXImTCBgZ2SJ1BUogltVEcg4jTSBr+Y70t6l3kRFIbsYCIYIrf9OsTJo9kHEjPVmxqp0KgXq1h2higI8I+tYazTFQjeW11U1gTbdiiEQmE2q58Gc4unmdWeFhglo06QHAtE0KTkjlmisDoSJv+AK2TC5I/Nvapl0CLGeR/YwZ9G1DdATc5xhmbciOhJFZqyUGcMFdxdTGdOspP4LahsUm9I+ev01cVPgyaPIUBt5U4TRpCARyYRzDqEavyDEGoq8A+sK3AxalqHgIC+AKPjTi8R5mcfFgv/JB1PUcDjcQxqwbXBpSqnFtk/G6RDwXPVpfTQ+tbRm1TswOvb6tLJSzBO57RdoDSUSUK42OiZno1vzZNQQsI4+E4Z7wpNxnyftyaZQfhPfMxnTi8AveHi6KWf/6jfieXEHvupnC2fpD7KjFiP8/Ryo7PqLP0BPkh5VZd6NopK3fVAy6jyw0MJSLKrVSHFNCVgycLQEV1PUQuR6cbS5YfOJcVblKJOiEyYUvPF55yYNOJCpnKHXyAcfufosiK8mUwvKywf1rx8uKc7ms53ietstqpWEP3AFVARqoeyrZMpb4cZ2MS0b0WNtdSBRouJk5nvo0kRdKnTIpPAf+EtYilo/LJvN41SJ1mCr8rUGiBZ/UvYHBzYWDJVvxlR3tPyJkx77huZI+UhT2+zq
 zUrjuyuE
 lmeT3hKGROC36TaRg7OVKwObCoNSEPpamgZQAXANE0msYjrDrEqsGMA1MKcDzUV8N0VloAR2Jtdp51rKCkYiQR7FBfhLXbQRk57MyAfMPGNcpiHMdEEp8eTMni5lDQX2DCQ6hdRL9iRm08yBWy+B1LU8JDjnRzwEkCbL5dTIyPVcpWX68Qm+xaGMACkOhBiVquldP29V0iWkC57eTuJKWp3b1QPmMDc5/OHQzpLDdJzYcDdgG2oEJd1yIZhOiJNLcM+i295Hl1A2HAKyE2ONFg4AKYL0ziOULaRTSiMp8OZj2dMTY8J6pHZ9/9utFaFZ4Yxr+gvuW+ycxFUXfsXWHTq0pJdIlTsjuVNLAJsEzJuJWKmdyGI8n6wPErInGe/TrHEVnXX2KCbWJu2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 10:08, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> try_to_migrate() clears PG_mlocked when unmapping the source folio.
> For PTE-mapped large folios, remove_migration_pte() restores one PTE at
> a time, but the rmap helpers only restore mlock for full-folio mappings.
> This leaves the destination PTE-mapped large folio without PG_mlocked.
> 
> Restore mlock once all PTEs of the destination folio are restored under
> a single page table lock.
> 
> Fixes: dc68badcede4 ("mm: mlock: update mlock_pte_range to handle large folio")
> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
> ---
>  mm/migrate.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 94033c222e04..140e291d4587 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -353,6 +353,7 @@ static bool remove_migration_pte(struct folio *folio,
>  {
>  	struct rmap_walk_arg *rmap_walk_arg = arg;
>  	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
> +	unsigned long nr_ptes = 0;
>  
>  	while (page_vma_mapped_walk(&pvmw)) {
>  		rmap_t rmap_flags = RMAP_NONE;
> @@ -446,9 +447,16 @@ static bool remove_migration_pte(struct folio *folio,
>  			else
>  				folio_add_file_rmap_pte(folio, new, vma);
>  			set_pte_at(vma->vm_mm, pvmw.address, pvmw.pte, pte);
> +
> +			nr_ptes++;
>  		}
> -		if (READ_ONCE(vma->vm_flags) & VM_LOCKED)
> +		if (READ_ONCE(vma->vm_flags) & VM_LOCKED) {
> +			if (folio_test_large(folio) &&
> +			    nr_ptes == folio_nr_pages(folio) &&
> +			    !(pvmw.flags & PVMW_PGTABLE_CROSSED))
> +				mlock_vma_folio(folio, vma);
>  			mlock_drain_local();
> +		}

I have the recollection that the next try_to_unmap() would fix that up? Or is
that not the case?

The "nr_ptes == folio_nr_pages(folio)" case is shaky either way for folios that
are mapped into multiple VMAs, or what's the logic behind that, such that is is
fine to only focus on large folios that getting fully pte-mapped?

-- 
Cheers,

David

