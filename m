Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1BF606B36E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=b5UKayYn
Received: by kanga.kvack.org (Postfix)
	id 02C8F6B05C3; Thu, 12 Nov 2026 06:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0040D6B05C4; Thu, 12 Nov 2026 06:21:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E89C56B05C5; Thu, 12 Nov 2026 06:21:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA7B96B05C3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:21:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 46796120576
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:21:38 +0000 (UTC)
X-FDA: 85426226676.20.F355D36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9BBB320003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:21:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5UKayYn;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482496;
	b=zyhIa8AU5gsLFhPJ72poprA9BGAPjRmwOBZCvbtLQiyVJ6eM2IF/ziLdwt8TDawM9W71kW
	9CoTpxrsAM2gx6dvDbB74lNhLbx1xhHhKxfWXjZhnmtVMYYSXlr1c8X9yxSkU+26Op6+Eg
	bdIz2sQA0TPTM+TO3NI7dH8fmHjvaCQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5UKayYn;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k0NaPbrNMApl+0OhCvZtbmHgHjDNgBdnGMkilCDmB9c=;
	b=rb1v52n2P9O6WaSWZtuhwwXLM8DXCw12h0GdJiPGBb8onutDkIjrjEEv+1lEvRney1V3w4
	Z+nwQFFKLYa8eWQ72K/MnV7p27DGqafLiNksgQkDrB9KrQcFNMwoJTtubhlctj32aJGJrd
	JLx2xZHWKCjE+HDZc7lCEQxrl5gOm9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DED5C611C0;
	Thu, 12 Nov 2026 11:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AFD1F00A07;
	Thu, 12 Nov 2026 11:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794482495;
	bh=k0NaPbrNMApl+0OhCvZtbmHgHjDNgBdnGMkilCDmB9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b5UKayYnIwJr4nFQ84cbShH/GDU3AKLrS6KouggcNT0KChdHpzhV/o+TxoMI45ALS
	 YFk6VMmmVC3BCLFpncQHyYnM15y+f19drcHGndjbZRIWDdVVqKJDFnr28dECNIw/Rl
	 g6ktlL+g6s8RYyKnh6Kafl1bkBU2Mj9B3Y/n4vWwFuxlLe29iadqVZpUIL4OdIdpgA
	 3/pW4ekBW50oNHtowAkFSQtejR7MTKXESA7FsIUcNimG/Tg1gqdxblZfi0K00VyWSZ
	 4anAwm7q8+0j9VGxNcvRzWJfmU+HsSSDBmnS0XMQ+HReN4K12o3UJOJ1h53djv+Fqk
	 oX7ts/LkjE64w==
Date: Thu, 12 Nov 2026 11:21:24 +0000
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
Subject: Re: [PATCH 09/12] mm/madvise: let a guard marker carry the uffd-wp
 bit
Message-ID: <avWeNRMIU2QPGZ4w@gremlin>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-9-00713d368976@columbia.edu>
X-Stat-Signature: oq6f7otyxa7im45xfbfi9ku4cw5gp54q
X-Rspamd-Queue-Id: 9BBB320003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794482496-641655
X-HE-Meta: U2FsdGVkX1/VhVqM+Ee2rjsV8u/hgRsh6P6PW1m121r4GD7BBJFrVYQ2i7ubV/HKzNgBHgHGAm+ivtAog0slSemVAIJO09klpDUqZQ9oDkUkz/Vx+pxztjxu7zJWz/n2vX9s32zXgcm06TeY2V/2hVCZbc0dYe6N8xGV4vEFLbfwilrKuQt6CcYOTEowwSOySOWdFkHKZ6I9povIy6GU6f6CKfYUdhvBl2YLofXRe4hFXufjmTknWDzpXrpsJpTHtw5VBmNSeRLkm6dec4Z0rOpJiQnXz5kXwC7UIRMxfD4CM85Ff8tJ/FwJf15XG1q3mPSdLH8rHgtxXUeZPAobuYMq0MOl5RSlPiHOqL5c0zkvUJWA39QA21M0jBtcRPImQqnnMHK20Q2V/BDWZKhGBlYcgvhifjLxJhzj1E28V6j6ZOhnO4l+CHgcnJ5Doz9fhfGHcoJmtQ4rIiW1KdMi+YDDnOoqkSCFlG6lLVi+f8Ws4WFxVHgjfQbUk6AO8WRi8EVV8muUP8P9XtK1zhgIQtQUwEG5WZDgaQF9Xs4ziTqlkm+8r460fOVblkl+lNWm00CFDoxlSyFwcOykkQDArkRRCQiSozF4U+WurS9/fhMqhGXnJohpHPFJO6/I3zf+o4C4S/a06qH0aFh2EA5+zda2ng4q8Tc9VfJruqElc/V1+YqAyoUyeKR7Xems6KYPlsld7iNUwAMdiFMYOIbF8xmUuoyU1dac6wRCX1wLb2+ceCtOv6kr1fFSrA6Bf56Xh1yVawIGgNYa+tixp3tOSK9ayBAbfmOu1zfKBeuvOewfaO2O1XZ3d4EVjv329WVgt6nWAvtzQKmxqqQ45CDoAbIozJcUl6sYXbYB4iL+6a8dWpehdT1eQRvYiPVPkyZaqm+2DLCprYrL9lNTIzw3qWRUm/r03jPK70FKhsA2C/swSA30imVfX037Kh7p8UFJeg7aXTKQ28O2Rux8hO8
 AylUMQnN
 KeZhhonjoedIJUzO1yNHJfVH9pjN8OecPo4jD6D0nBiw11rOIzj1xnv3YD+C03V7yr0/j0W56mA+0vQUA0yiUySnP9PhAV2oyz7SYczYLibt2K6I+fYP3VQkDG8b58/vRrpa8DTEytCBrIgiy0aJxy6dB0du2eoqy5jaXRVL6346mGKr5tTVXDgBA4uKv9tEFCt0Q8JlHOUdF4m/ULFoxj/zRS4+3ML+FSrJE7/h41TRBrarSMWR2KJmGcY56esIcDpKsEloIOzdic3Y8qjIm6y/UlJRbsMDlxVwCWBOl5dPzy+/k3hesTm25GBBRVfO2QkXihu9/GuVlPws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:17PM -0500, Tal Zussman wrote:
> MADV_GUARD_INSTALL can only install guard markers in a range without
> populated entries. It zaps the range and retries, restarting the syscall
> if the range still isn't clear. On a file-backed VMA registered for
> uffd-wp, the zap keeps uffd-wp markers and converts write-protected PTEs
> into new markers, as the pages are still in the page cache and must stay
> write-protected. The range never becomes clear, and installing a guard
> region in write-protected shmem keeps restarting the madvise() call.
> Signal handlers still run, but the call does not return until the task
> is killed.
>
> An entry that is write-protected must stay write-protected while a guard
> is installed on it and after the guard is removed. PTE markers are a bit
> mask, so a marker can be a guard marker and a uffd-wp marker at the same
> time. To fix it, let a guard marker carry the uffd-wp bit:
>
>  - guard install adds the guard bit to an existing uffd-wp marker
>  - guard removal clears only the guard bit
>  - unprotecting or unregistering clears the uffd-wp bit of a guard
>    marker
>
> The fault path, zap, fork, and pagemap already handle a marker with both
> bits set. However, pte_is_uffd_marker() would let UFFDIO_COPY overwrite
> the guard, so make it ignore guard markers. Anonymous VMAs drop uffd-wp
> markers on zap and never get the combined marker.
>
> MADV_GUARD_INSTALL on a uffd-wp shmem range now succeeds instead of
> hanging. When the guard region is removed again, its pages are still
> write-protected. While the guard is in place, pagemap reports both
> PM_GUARD_REGION and PM_UFFD_WP for them.
>
> There are two simpler alternatives, but neither works. Zapping with
> ZAP_FLAG_DROP_MARKER fixes the hang but drops the write protection: the
> page is still in the page cache once the guard is removed, and writes to
> it are not reported. Refusing guard install on uffd-wp file VMAs in
> is_valid_guard_vma() would break a combination that works on anonymous
> memory, by adding a new -EINVAL for it.
>
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Please drop this patch too.

With my patch disallowing guard marker install on uffd-armed VMAs this goes
away (and doesn't make sense anyway.)

I really feel these guard region ones should have been sent separately, btw.

You're establishing a bunch of interlocking dependencies of different changes in
this series that makes life hard for reviewers, especially given backports etc.

And now I'm having to essentially inverse cherry pick stuff :)

> ---
>  include/linux/leafops.h |  4 ++++
>  mm/madvise.c            | 28 ++++++++++++++++++++++++++--
>  mm/mprotect.c           | 23 +++++++++++++++++++++--
>  3 files changed, 51 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 4c1476ae3234..add4968ded44 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -578,6 +578,10 @@ static inline bool pte_is_uffd_marker(pte_t pte)
>  	if (!softleaf_is_marker(entry))
>  		return false;
>
> +	/* A guard marker stays a guard, even with the uffd-wp bit set. */
> +	if (softleaf_is_guard_marker(entry))
> +		return false;
> +
>  	/* UFFD WP, poisoned swap entries are UFFD-handled. */
>  	if (softleaf_is_uffd_wp_marker(entry))
>  		return true;
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 0214efd2a014..e2c6b0f26672 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1123,6 +1123,23 @@ static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
>  		return 0;
>  	}
>
> +	/*
> +	 * Zapping keeps uffd-wp markers on file-backed VMAs, so add the guard
> +	 * to the marker instead. The slot stays write-protected once the guard
> +	 * is removed.
> +	 */
> +	if (!vma_is_anonymous(walk->vma) && pte_is_uffd_wp_marker(pteval)) {
> +		const softleaf_t entry = softleaf_from_pte(pteval);
> +
> +		set_pte_at(walk->mm, addr, pte,
> +			   make_pte_marker(softleaf_to_marker(entry) |
> +					   PTE_MARKER_GUARD));
> +		update_mmu_cache(walk->vma, addr, pte);
> +		(*nr_pages)++;
> +
> +		return 0;
> +	}
> +
>  	/* If populated return >0 so we abort the operation + zap. */
>  	return 1;
>  }
> @@ -1259,8 +1276,15 @@ static int guard_remove_pte_entry(pte_t *pte, unsigned long addr,
>  	pte_t ptent = ptep_get(pte);
>
>  	if (is_guard_pte_marker(ptent)) {
> -		/* Simply clear the PTE marker. */
> -		pte_clear(walk->mm, addr, pte);
> +		const softleaf_t entry = softleaf_from_pte(ptent);
> +		const pte_marker marker = softleaf_to_marker(entry) &
> +					  ~PTE_MARKER_GUARD;
> +
> +		/* Clear the guard bit and keep the uffd-wp bit, if set. */
> +		if (marker)
> +			set_pte_at(walk->mm, addr, pte, make_pte_marker(marker));
> +		else
> +			pte_clear(walk->mm, addr, pte);
>  		update_mmu_cache(walk->vma, addr, pte);
>  	}
>
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index ef4e7188e24d..6cc5b99b4185 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -249,9 +249,28 @@ static long change_softleaf_pte(struct vm_area_struct *vma,
>  		 * because any access should sigbus/sigsegv
>  		 * anyway.
>  		 */
> -		if (softleaf_is_poison_marker(entry) ||
> -		    softleaf_is_guard_marker(entry))
> +		if (softleaf_is_poison_marker(entry))
>  			return 0;
> +
> +		/*
> +		 * A guard marker on a file-backed VMA carries the
> +		 * uffd-wp state of the slot for when the guard is
> +		 * removed.
> +		 */
> +		if (softleaf_is_guard_marker(entry)) {
> +			const pte_marker old = softleaf_to_marker(entry);
> +			pte_marker marker = old;
> +
> +			if (uffd_prot_resolve)
> +				marker &= ~PTE_MARKER_UFFD_WP;
> +
> +			if (marker == old)
> +				return 0;
> +			set_pte_at(vma->vm_mm, addr, pte,
> +				   make_pte_marker(marker));
> +			return 1;
> +		}
> +
>  		/*
>  		 * If this is uffd-wp pte marker and we'd like
>  		 * to unprotect it, drop it; the next page
>
> --
> 2.39.5
>

--
Cheers, Lorenzo

