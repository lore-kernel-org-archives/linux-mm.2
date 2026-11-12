Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FA73606A897
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ijVUa1/3
Received: by kanga.kvack.org (Postfix)
	id 7B92D6B05B5; Thu, 12 Nov 2026 13:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742D06B05B6; Thu, 12 Nov 2026 13:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6321F6B05B7; Thu, 12 Nov 2026 13:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0526B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:34:22 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BC7814075A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:34:20 +0000 (UTC)
X-FDA: 85427317080.19.7CF9886
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9C6C3C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:34:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ijVUa1/3";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794508458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S83ufdCuikPlcGyicMt7mpw+fBC8MVplA5DoPA/0lZw=;
	b=qYIsi1sPxTMpcKYvp8KbTS9Qt+O1HEslSUte6hTC4Xder+4cgpnL3xsnNGr6QDGh8mP8Sg
	b34dXBwIWozfs+y8uCcpvBcvKXWiOqO9cEvyuJu3ID9fM1V7SlNJj6A5Y9oWjA/vzfH7cZ
	UDHjgKQvhCKCP1b5cz7b/0FzxhnCnGk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794508458;
	b=o1MEHTkJj9rILsoli6+g4uwsO3Hpu2Fz2OPzIH5s+CJF7s5dbUQ1zOnpZta/BOBromYqwf
	IeusCOwSDIAwBo4FVcwIMNoSWY1Mr9ospVo8EuNmlEnbDKxB9np7iKgIbqJIBi+aF5rzxP
	u30yduw8FLbtRf6VNhX4GQx8yhuYoSQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ijVUa1/3";
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D2D9B409C6;
	Thu, 12 Nov 2026 18:34:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877AC1F000C4;
	Thu, 12 Nov 2026 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794508457;
	bh=S83ufdCuikPlcGyicMt7mpw+fBC8MVplA5DoPA/0lZw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ijVUa1/34L3eHye3zw1zN/jAyO3526dLl8D+nYyREiy4hhDzOFJpJrb4r8+nEaUUx
	 JBE0foYCokhvT3BCWxqXX2EMxkzVL6UklJzacnsibjmkOF7aAe6VjVcfSaixmhDat5
	 xSEAZ92rm5t0S9ncbxiexT0z/XgwndpFr92CPMNhSCW5HIlziX+SNQjKmgdSWHicyt
	 brSJvjlB+BP0Lgm8J16kaGtiezulqMucdc69bfguxXhXtWHsfXqv5K7UBRRbGM6JCy
	 ADXCLZ3sWbMHVZuXxhQOivf3FZj+tl7zhkdQ8DHsio+K27kcFvUG64TnK0YU8zKulU
	 y753u/meLtukA==
Date: Thu, 12 Nov 2026 18:34:05 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Chris Down <chris@chrisdown.name>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/12] fs/proc/task_mmu: downgrade writable migration
 entries in PAGEMAP_SCAN write-protect
Message-ID: <avYApSoRMz7IZSox@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-3-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-3-00713d368976@columbia.edu>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: p8cwneyena6hmothpuscdqqx5om888k1
X-Rspamd-Queue-Id: 9C6C3C0003
X-Rspam-User: 
X-HE-Tag: 1794508458-632586
X-HE-Meta: U2FsdGVkX1/gt528WtbkUQIpxRQURDEVfit0sRlTLJfzSYOQdyVlT8AqeZpFjzZhe8Wg7lMmZv6P8d0RUAsZwYhFBR7246xTQdocXdLihkIZ5EtgFJVJ4Bdg5hl5nxAtzEisJvdpxtkCRiaeTuHgKjlz53cvS5gBEYy/iegOdY+2z6kLNVzRIFwg5fIoI4ckrl56xhwGxSkKdDohKvyBkDMT5uCQgEInjF58twL373lDO+XqT1a1WXMOM8elZEaitbeXhk+OXQ+rmU6Uf2NyYyeb4YDZhaUZQpGYqAZL0SavEoTAH43PyCjbhpZi1D14pVdzqadFaWmSrmBqu27WR4t4nvqb+29FzIR9HRQDJ2zaqCB89PbV/s1XSMI9gQ5zfo/n9rQ4+KHp3FeB4Qxijjib7fuTpWtMQq8sKhS25jYbKGG9pgMdFm8Jq0LpXaELZcZ4omJVkrehUR5BsFUhj4E47zdRdpDquQMQm0ddXTIwMGL5V3CZLvWtu5AtlSoLCNm7A6LMmIblcc1U1xwRv7b2gdbXDRf3u7Uvl1xhyp7oyZCaFzaVlmuoPUzBOY9ZYHxpELG7O6WqYOubNejVqZs8Ffd1B0uJsv1Hr9qfo0OLYLxCphxLcCRvriP7HVe7OuiOull0x0I9tafDqJLnU/He3mJ7ENz1/QeBfjlyhq2j1DWtfQUKqPtDjP4suXEusQ2BdlhrHlScH5C7gdnLIXfoCf8r+tRB6pz5nxbQV4KKiqJDFyTqZwC2h5InqPATovSxFe9KsK611RRXvnYhdyV0yw9cFs/FIbAZu8e6IaJeuOCGu/VeI7ycoHuYEDVjUpEQD5cJ4IE9arv+nl2FD4Gn4R61DcvVj4zv/Hsx3axH+COv30SIDbcr+JHGtIHantvtmCV1cW8XWsBL403iW6g2YDila3ZRidzm+LaONG4div1J4q+SZNGzM0X4fCHHOrZZoHKZjfbhRl7T2GK
 0HNGEhZt
 ukd3yo30DAhX+3/LFhh6J2AqGXscuyXtjKEuIqa3dUnIGM9TYI0YhwmyjKkZvvBgVi1Ge8tAa3+pIR29zbiDvWox3bpYmPSvMhKbxZKRU8kEFt0VV1aOcukEm6OxrkfEnq6zLr07QhuE768H6Y0tXZcL+KGuxuZCVcNPFOwk8Kc17uwJX+BawqoYMArvElxBvWxAy9H6AEN45NQfWJmzhdWnDaj9lGPclXGb5adj9Fzrdb3U0UM0ptPurd7fIkX1r/bOFXTKeXLK8ZCeNpaVl7UH4GLlZLprZ4lIhAbAngB+fqDPirWUPP16VZMvXvKj7Eqpl/w13PXfSiCe/HeFGpbiljASLPnl4I8FQra54AoqTmuKOdFgvnN30ShfF1LAasmEb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:11PM -0500, Tal Zussman wrote:
> PAGEMAP_SCAN with PM_SCAN_WP_MATCHING write-protects pages in a VMA
> registered for async uffd-wp, and sets the uffd bit on non-present
> entries as they are. An entry with the uffd bit set must not be
> writable, so that the page is write-protected once it is mapped again.
> change_protection() therefore downgrades writable migration and
> device-private entries to readable ones first, but PAGEMAP_SCAN does
> not.
>
> For a writable migration entry at the PTE level,
> remove_migration_pte() restores a writable PTE without the uffd bit. So
> if a page is under migration while PAGEMAP_SCAN write-protects it, the
> write protection is lost. A user tracking writes with async uffd-wp
> sees the page reported as written on the next scan although nothing
> wrote to it.
>
> With CONFIG_PAGE_TABLE_CHECK, setting the uffd bit on a writable
> non-present PTE or PMD also triggers a warning.
>
> To fix it, downgrade writable migration and device-private entries
> before setting the uffd bit, as change_protection() does, at the PTE,
> PMD, and hugetlb levels.
>
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/proc/task_mmu.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 51 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 22361607020d..53780a454432 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2395,6 +2395,38 @@ static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
>  	return categories;
>  }
>
> +/* Downgrade a writable migration or device-private entry to a readable one. */
> +static softleaf_t make_readable_softleaf(softleaf_t entry)
> +{
> +	if (softleaf_is_device_private_write(entry))
> +		return make_readable_device_private_entry(swp_offset(entry));
> +	if (!softleaf_is_migration_write(entry))
> +		return entry;
> +	if (folio_test_anon(softleaf_to_folio(entry)))

Hmm _seems_ a bit dubious. You identify a readable exclusive migration entry by
checking whether its folio is anon?

But I guess because a writable migration entry can only come from a writable
PTE, that implies anonexclusive. But you do need to explicitly say that.

Also we really do have to break this out as a helper. I see it's open coded in
change_softleaf_pte(), change_non_present_huge_pmd() and
hugetlb_change_protection().

But maybe that can be a follow up...



> +		return make_readable_exclusive_migration_entry(swp_offset(entry));
> +	return make_readable_migration_entry(swp_offset(entry));

This is all super compressed.

I'd say add to leafops.h but break it up:

	static inline softleaf_t softleaf_migration_mkreadable(softleaf_t entry)
	{
		const pgoff_t offset = swp_offset(entry);

		VM_WARN_ON_ONCE(!softleaf_is_migration_write(entry));

		/* A writable anon migration entry implies AnonExclusive. */
		if (folio_test_anon(softleaf_to_folio(entry)))
			return make_readable_exclusive_migration_entry(offset);
		return make_readable_migration_entry(offset);
	}

	static inline softleaf_t softleaf_mkreadable(softleaf_t entry)
	{
		switch (softleaf_type(entry)) {
		case SOFTLEAF_DEVICE_PRIVATE_WRITE:
			return make_readable_device_private_entry(swp_offset(entry));
		case SOFTLEAF_MIGRATION_WRITE:
			return softleaf_migration_mkreadable(entry);
		default:
			return entry;
		}
	}

> +}
> +
> +/*
> + * An armed entry must not come back writable, so downgrade a writable
> + * migration or device-private entry before giving it the bit, as
> + * change_softleaf_pte() does.
> + */
> +static pte_t set_uffd_wp_swp_pte(pte_t pte)

This is a contradictory name, you're interacting with softleaves, there's no such
thing as a uffd swap entry :)

I/we obviously have to go and fixup the naming (I didn't _quite_ finish the
softleaf conversions I guess) but let's not propagate it.

> +{
> +	softleaf_t entry = softleaf_from_pte(pte);
> +	pte_t newpte;
> +
> +	if (!softleaf_is_migration_write(entry) &&
> +	    !softleaf_is_device_private_write(entry))
> +		return pte_swp_mkuffd(pte);
> +
> +	newpte = softleaf_to_pte(make_readable_softleaf(entry));
> +	if (pte_swp_soft_dirty(pte))
> +		newpte = pte_swp_mksoft_dirty(newpte);
> +	return pte_swp_mkuffd(newpte);
> +}
> +
>  static void make_uffd_wp_pte(struct vm_area_struct *vma,
>  			     unsigned long addr, pte_t *pte, pte_t ptent)
>  {
> @@ -2408,7 +2440,7 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
>  		set_pte_at(vma->vm_mm, addr, pte,
>  			   make_pte_marker(PTE_MARKER_UFFD_WP));
>  	} else {
> -		ptent = pte_swp_mkuffd(ptent);
> +		ptent = set_uffd_wp_swp_pte(ptent);
>  		set_pte_at(vma->vm_mm, addr, pte, ptent);
>  	}
>  }
> @@ -2467,6 +2499,22 @@ static unsigned long pagemap_thp_category(struct pagemap_scan_private *p,
>  	return categories;
>  }
>
> +/* Same as set_uffd_wp_swp_pte(), for a non-present PMD. */

No need to say non-present. Naming it with 'softleaf' somewhere in there implies
that. E.g. set_u

> +static pmd_t set_uffd_wp_swp_pmd(pmd_t pmd)

Same comment here, this is just hugely confusing.

> +{
> +	softleaf_t entry = softleaf_from_pmd(pmd);
> +	pmd_t newpmd;
> +
> +	if (!softleaf_is_migration_write(entry) &&
> +	    !softleaf_is_device_private_write(entry))
> +		return pmd_swp_mkuffd(pmd);
> +
> +	newpmd = softleaf_to_pmd(make_readable_softleaf(entry));
> +	if (pmd_swp_soft_dirty(pmd))
> +		newpmd = pmd_swp_mksoft_dirty(newpmd);
> +	return pmd_swp_mkuffd(newpmd);
> +}
> +
>  static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>  			     unsigned long addr, pmd_t *pmdp)
>  {
> @@ -2477,7 +2525,7 @@ static void make_uffd_wp_pmd(struct vm_area_struct *vma,
>  		pmd = pmd_mkuffd(old);
>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>  	} else if (pmd_is_migration_entry(pmd)) {
> -		pmd = pmd_swp_mkuffd(pmd);
> +		pmd = set_uffd_wp_swp_pmd(pmd);
>  		set_pmd_at(vma->vm_mm, addr, pmdp, pmd);
>  	}
>  }
> @@ -2547,7 +2595,7 @@ static void make_uffd_wp_huge_pte(struct vm_area_struct *vma,
>
>  	if (softleaf_is_migration(entry)) {
>  		set_huge_pte_at(vma->vm_mm, addr, ptep,
> -				pte_swp_mkuffd(ptent), psize);
> +				set_uffd_wp_swp_pte(ptent), psize);
>  	} else {
>  		pte_t old_pte, new_pte;
>
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

