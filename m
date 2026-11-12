Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 885CE606A8AC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=arkrZnM/
Received: by kanga.kvack.org (Postfix)
	id A3F076B05C0; Thu, 12 Nov 2026 06:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16D96B05C1; Thu, 12 Nov 2026 06:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954BD6B05C2; Thu, 12 Nov 2026 06:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66B9B6B05C0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:43:18 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0236BA8149
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:43:17 +0000 (UTC)
X-FDA: 85426281276.10.F572F85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54F46A0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:43:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="arkrZnM/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794483796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xC7ztYSbGZgergptZvU86w+F0TCn5s5YYDHUR4p4fC8=;
	b=XLXOtiIL/QmHWKLLZbFq8w1HjZyoDPCPpQzUtMDXQGtU8A9TvojW3asqfsWGfYj3b6Gokp
	g2t59txNG+kdXdoSNIm0P5uyE4EKX/AsacWezGESsX5P8oE+9YbHhhKD43Kq7KG1wrMHfo
	qaLnpokfwSgdh2IhX2rvCIeRx/chgCw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="arkrZnM/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794483796;
	b=43xOxWyAireVFoxi8aX9ls2Ya4BQfKq1f4pFTzMQzo+ZW4mJQj+DEhsvsLXiS5iiFB+C/4
	/QJgWMnmDODHOJ01O9QutpO5akqz78l3xH686ZL2zuv+RZYaVap3a4kF7olFH7E0PhWXca
	mJm9C51Fgi1wsOVnhRD08KlSKgUTRvM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BB4242E26;
	Thu, 12 Nov 2026 11:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE561F00A05;
	Thu, 12 Nov 2026 11:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794483795;
	bh=xC7ztYSbGZgergptZvU86w+F0TCn5s5YYDHUR4p4fC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=arkrZnM/6xv5O9v/rTOhm0EDuiK6x5Nn7O0xAxMc2JgnHsP3UHe3z/Y+skcxP+bHt
	 4q5HxTo9yhupQI7fSEkR4tKMI6KdvxIu7ugqhLhMKSnEulPRovVt2XmfD0R0guyNL2
	 T2a6ZQxEsIitrbxl+cRGEAuonXHlUxgErvzMtvEj+XEUWLlKhtI1p4dl1ywZoZpON4
	 pwfUTeXEWy+Ym6ctCSIvbhG+9O7LJjG2R9l62z08bwlny6HFV1wB8J9fNKps3JalYg
	 cxN6sUz7UkdQ/nhVB2rJjTVFYIVJrEx/xxo5f2cb+mS2UpmdpCXPrLsrkEcsVMGFtr
	 oyADUJeDkJ/2Q==
Date: Thu, 12 Nov 2026 11:43:03 +0000
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
Subject: Re: [PATCH 10/12] mm: set the uffd-wp bit on a guard marker when
 write-protecting
Message-ID: <avWhaJzGbuIM-Bh-@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-10-00713d368976@columbia.edu>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 54F46A0005
X-Stat-Signature: icnwax6f5r9rzjw7kmczdbb4ejpnpn7x
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794483796-429887
X-HE-Meta: U2FsdGVkX1+m2EhhQkyTAd9ruH608WEKDhnsPFZ4e5EZ02txPoNAjRWgDNv7qcY6bFznb7OVvjRLHb7qN3SO24PevjQvnqjeMQhA3OjVn++B32z1YTGPLB4luqr25QUijk+COvW4Y5/jFIVmGUIl8HgFHdM+h1URGhr3S93UrdIID9fs7N6HK/6dx34Zyyb22YaFw11HzVa+DFQi1wE2/V3HA9SOq2D00KvfXYIH8yeoPAJTDfMN0ZDy6xyH42Ca5is7qOvDPHJkLgp0Arqa1/55O8uwoYdoCufXUjXdS28AIQ1chISpcHdw95FbjYEcRgm+rBjfels1D645HGeVbXvIqzREhs/HMIb8TY3HjTfK13fBeVyOvnux/3HkKsCCxkAWqF7tPc+dj9vZx0bPExDgQGtSvdNZKlQC1q2CEm0QRVIDNe3C6TjVo01KTvtqALnb0wjeIY2H98uHZUZ7Y5zDlSCGj4F6rPzFXZi4m0rIG0XrXx0hSxafyNgKxTIzjoAMsxJ8pQYC3ogR9ExZ9OdNWQ8lbcB2+n8OunfDLsdEBZqu/Cgd+nJpHPX0YfsFLjUfirr3eudIp8VOOhW6KU4rx7WWCOlZ7H2TW49lIRXzsnQnnIk4qJ5OxWInyyU94d1c2Os0OLE95ymEgBsM1FHAb9Oq7i+cdU2xYfFqSVABPulhRtNg4403rbnMRstD/h2AAAPG/8gzI5wsz74g6jd3uXheRb8YY74hRSp3pmmdV49IjQRDlyyANbtDyxco7T2mC2t49sVmJESK1ZG+oOcMCG8aN0ptnTMsATWo8Nj1evXw3vgZKkEDmkrk57PH5S91F6YgPBT3+eAov9pyKCDI1kaOo0wAoEblreWp5w/x+KUHW4Rhs3oi3mr3kYyTCh0nj3cHxU6zA4a7JAkHuOpDzgAIicQfQMIAh8QbMZkT+MgPFeALB+vygfxZJmznV6/2lKICsnz5JSeYpEI
 qXUnIeeN
 7tXJEJcApWHsaQKnBtQnUNTCkKttk5ocB2xC4uesRz3p3awg6eRPwfb5aIBIiAVi/uo+z1GCPbLsyL4hpBCQOehJZVMIBTU33v5aIrU1OhPEzAyGgGQvOYpi/cPAEeAyowYfnZ8o1qyEwpqzygy89Hc1a76VVeInaQApVg49Q7zvF6qP5P57VtXRZwlbZHDSz7WCGq6OyO49q3nB0RDdoPjDIhcTLyj7LB2bRVPz/q9VcT7gjqwcDQ2CHpwn7EAHsTC3vVLEQoPR/MnkP3FXRNH4GFpPvktJZjSYtLssMUx+DtubF/1xJBUTWOlPLCCzHtzRAqJy+f6NlqvU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:18PM -0500, Tal Zussman wrote:
> UFFDIO_WRITEPROTECT and PAGEMAP_SCAN with PM_SCAN_WP_MATCHING do not
> write-protect an entry that holds a guard marker. change_softleaf_pte()
> ignores guard markers, and make_uffd_wp_pte() only sets the swap uffd
> bit on the marker PTE, which guard removal clears along with the marker.

There's no 'swap uffd' bit, softleaf uffd bit :) (I need to rename some stuff
still...)

>
> On a file-backed VMA, the page is still in the page cache once the guard
> is removed. It faults back in writable, and writes to it are not
> reported.
>
> To fix it, set the uffd-wp bit on a guard marker of a file-backed VMA in
> both paths. A guard marker can carry that bit, and guard removal then
> keeps the write protection by leaving a uffd-wp marker in its place.
>
> Move is_guard_pte_marker() to leafops.h as pte_is_guard_marker(), next
> to pte_is_uffd_wp_marker(), so that make_uffd_wp_pte() can use it.
>
> A page that is write-protected while a guard is in place is now still
> write-protected after the guard is removed.
>
> Anonymous memory is left as it is. With UFFD_FEATURE_WP_UNPOPULATED, an
> entry that is write-protected while a guard is in place is still
> unprotected after the guard is removed.
>
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Similarly, please drop this patch.

This does leave the opposite order (guard region _then_ uffd register etc.)
unaddressed, but guard regions behave as if the range were unmapped, and
uffd-wp state does not survive an unmap/remap either, so I think it's
reasonable for WP not to propagate there.

> ---
>  fs/proc/task_mmu.c      |  7 +++++++
>  include/linux/leafops.h | 14 ++++++++++++++
>  mm/madvise.c            | 11 ++---------
>  mm/mprotect.c           |  5 ++++-
>  4 files changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 752f1b13d47a..7b1c843a4fd0 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2439,6 +2439,13 @@ static void make_uffd_wp_pte(struct vm_area_struct *vma,
>  	} else if (pte_none(ptent)) {
>  		set_pte_at(vma->vm_mm, addr, pte,
>  			   make_pte_marker(PTE_MARKER_UFFD_WP));
> +	} else if (!vma_is_anonymous(vma) && pte_is_guard_marker(ptent)) {
> +		/* Keep the protection in the marker, as mprotect does. */
> +		const softleaf_t entry = softleaf_from_pte(ptent);
> +
> +		set_pte_at(vma->vm_mm, addr, pte,
> +			   make_pte_marker(softleaf_to_marker(entry) |
> +					   PTE_MARKER_UFFD_WP));
>  	} else {
>  		ptent = set_uffd_wp_swp_pte(ptent);
>  		set_pte_at(vma->vm_mm, addr, pte, ptent);
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index add4968ded44..831b85a184c4 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -547,6 +547,20 @@ static inline bool pte_is_marker(pte_t pte)
>  	return softleaf_is_marker(softleaf_from_pte(pte));
>  }
>
> +/**
> + * pte_is_guard_marker() - Does this PTE entry encode a guard region marker
> + * leaf entry?
> + * @pte: PTE entry.
> + *
> + * Returns: true if this PTE is a guard marker leaf entry, otherwise false.
> + */
> +static inline bool pte_is_guard_marker(pte_t pte)
> +{
> +	const softleaf_t entry = softleaf_from_pte(pte);
> +
> +	return softleaf_is_guard_marker(entry);
> +}
> +
>  /**
>   * pte_is_uffd_wp_marker() - Does this PTE entry encode a userfaultfd write
>   * protect marker leaf entry?
> diff --git a/mm/madvise.c b/mm/madvise.c
> index e2c6b0f26672..e8b05dc899f1 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1085,13 +1085,6 @@ static bool is_valid_guard_vma(const struct vm_area_struct *vma,
>  	return true;
>  }
>
> -static bool is_guard_pte_marker(pte_t ptent)
> -{
> -	const softleaf_t entry = softleaf_from_pte(ptent);
> -
> -	return softleaf_is_guard_marker(entry);
> -}
> -
>  static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
>  				   unsigned long next, struct mm_walk *walk)
>  {
> @@ -1117,7 +1110,7 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
>  	unsigned long *nr_pages = (unsigned long *)walk->private;
>
>  	/* If there is already a guard page marker, we have nothing to do. */
> -	if (is_guard_pte_marker(pteval)) {
> +	if (pte_is_guard_marker(pteval)) {
>  		(*nr_pages)++;
>
>  		return 0;
> @@ -1275,7 +1268,7 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
>  {
>  	pte_t ptent = ptep_get(pte);
>
> -	if (is_guard_pte_marker(ptent)) {
> +	if (pte_is_guard_marker(ptent)) {
>  		const softleaf_t entry = softleaf_from_pte(ptent);
>  		const pte_marker marker = softleaf_to_marker(entry) &
>  					  ~PTE_MARKER_GUARD;
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 6cc5b99b4185..3f2d6e3aca93 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -261,7 +261,10 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
>  			const pte_marker old = softleaf_to_marker(entry);
>  			pte_marker marker = old;
>
> -			if (uffd_prot_resolve)
> +			if ((cp_flags & MM_CP_UFFD_WP) &&
> +			    !vma_is_anonymous(vma))
> +				marker |= PTE_MARKER_UFFD_WP;
> +			else if (uffd_prot_resolve)
>  				marker &= ~PTE_MARKER_UFFD_WP;
>
>  			if (marker == old)
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

