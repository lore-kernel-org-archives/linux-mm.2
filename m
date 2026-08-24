Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBAD6C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33CE6B0092; Mon, 24 Aug 2026 12:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0AA26B0095; Mon, 24 Aug 2026 12:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47DC6B0096; Mon, 24 Aug 2026 12:28:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A88D6B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:28:41 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0FCCA1601CD
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:28:41 +0000 (UTC)
X-FDA: 85136696442.21.56A49FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5407340007
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:28:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VN6kOFOW;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787588919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NFP/Doxvz0uneI4uAtaTJ5pHHBSrUSDmA71fSNKFKE=;
	b=dHJL9/JGgd1FahoAQCwmX70DPQCJhmLNI+Q7HaLKZUbz8tjcr1x24edhk3kkZM1V8DThQS
	1YpPyZB3LrkMqpU0FrOQjyafMtGaSvdVtlMC5l2lGtjXTyaHhSw8dM6iqQOgqHl/q0+lnU
	HViHdw3llyypo3b5Q+CScBJrpRlWZ+c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VN6kOFOW;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787588919;
	b=cwWy9Dn1rav7V+6nmMmg2/ddXKy9XtmSTmZH3z/jugjgEluCu/hxthyO39aEcS8DBZ3GKL
	6eM309UCAcMwa6ywteBsUZapSJrSuleFIjdQUuUFhBiAKxkjRB6Yz5XbONZJWMWjFudndd
	GTHx9yoObh1Xyld98B79b9ibFn2Xb9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39A33413CF;
	Mon, 24 Aug 2026 16:28:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5172D1F000E9;
	Mon, 24 Aug 2026 16:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787588918;
	bh=1NFP/Doxvz0uneI4uAtaTJ5pHHBSrUSDmA71fSNKFKE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VN6kOFOWDWXh74bAR41giJ73uh7u1PhiKRT3X7rhEnXEcOOrjBMSR29erjx3RABgH
	 O68jKorVrcixv2cmjnJFLee4cQdlZuYXiFCHnS3tF7wr5dLfq/vCtsER9ImBa5MlmY
	 tlfPiVGQTS3rDJypq1ISb3WBQloh1AQehd6wAFPWTNhFicKca5S0SpSs70ILl41pAa
	 ueftTnhdVv2CPAksVkXwkKN5a1kMRoDfz/lo9diDGftAwgM3w0I4JvW7/r42PNRBzy
	 ItllSYIekZRRjGWZscL6tHKDpcGB9MkVbKKpYeXubk5uonq6m65pAzDB+4GZGtaSAT
	 lkwtnXV/IPt5A==
Date: Mon, 24 Aug 2026 17:28:29 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] userfaultfd: decouple fault reason from VMA flags
Message-ID: <aoxm4jUrmL1eQlCJ@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-5-3086981b33cf@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5407340007
X-Stat-Signature: ahymrrx6eycm9qarh7bkhhhyjokrwrpo
X-Rspam-User: 
X-HE-Tag: 1787588919-333891
X-HE-Meta: U2FsdGVkX18ofA2h+RDMK2hE0zfk6BofussThALeM4keP9M5cte4u1tvqoDbZMQ1odFYVutLoRuP30Qa9uZV7gomEOE3rqrpdboy16wiVtdO7HJrPxddMcdyx5y4jkWRYYGvr5NNzgbS8/UQPfqedNJcrxA3O4+hURFMQO283qr77CZfaZOM48yazuf9xZ2Crt49kRV2RzK5elKLxYvixq3hOTZodjE5g9oaRGg+86+sncMHhpmh1g1ZW/kbdyyviCovZJKtQ6XzPWf8EYyYgUNbJfsfiCQ1ojuMZ4srNC8+jSSgZ/p1gqHm78Wn8s3KGt+0QOrvcPwcgk1kE3AdW5/1rn/kuhWb85nwv+RPqaEHRybYj50dUHS3fDNzke6lszxWQD+2Np2ipOahJvbnBBP6UFE1qxB+D0jf+vsFtsdaREPM8ZNBtDBfh03noRNk+5eFGOZabQrjuKj7LPH67TyuJiodhiguWFzZRFbKGFRqehl08seEzvYxt1WZL98esABLh/+TcMk1rufE0qCQzHxEk+dWbk6IB1xbuj9i9C4LRL4UFjAchbNm4xeUSQ+GPIUyN0R+5CspTt7VA1oTzW3yEjuSD9DdPQsQr0JzhuWTBp3tlrbO5wPtuvCQ5fcgrJW63djKj1b66bLGv4+WFw5sBJgluqh2CydQ45FpOxKqw/oIwVy5kT1SJXaYl3TX/i/wG7Mj3XJbaOFDrhDaU1ABAPsqVY6ZHComJQFe0l+GknBRyWS7z1rJ+gizU/lJcWaxbIkc37vaJHeYk2NbYroPTTDx9ti2qHdKbWZ45Fi4D0tjCSUUY2KvFZ1V//K0rdwJ6jHu+uJ1v/4GwCPCcKuHysWL3b0Ilak739ywS5wi7PpLsznoahGVc21ZK7/6e8MccLP7fCW398dwXoLycmIHwM4t9YHtRMxmc9yedNMSBMmyqpoTGae/+mKnjuOMdUgstfdnJxpx/yE/23t
 oCTN14Ya
 GLs76RUz0MGRZl+kKiBA1P+Yr66DJutipRtTg54TfChfnXwc0KCc4xgzWiEow5KWgPRhx17djkPypefhQLYxoxpkqRKNIR8iQYeGefw3Im5WWcEPgN2TTg9kxCQwI+MQGP/jHkxvmJv5NiprZeFTHK3B5BP0e8Y1YA5Upb8T0TMm97uCio3OtOClw+y+mtO8GGo16mgD7QWX/pdWjcyS6GE98oZL6t2NdXkLJYq8cLmVfGpAfKrA/D7Fjv23qNavi3QFXpLzCiBnputAi1C2ATtT3qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 03:17:42PM +0300, Mike Rapoport (Microsoft) wrote:
> Introduce enum uffd_reason to define reasons for user faults rather than
> overload VM_UFFD_* VMA flags for that.
>
> Using a dedicated enum makes the code clearer and decoupling the fault
> reason from VMA flags clears the way for moving the uffd mode bits out
> of VMA namespace.
>
> No functional change.
>
> Assisted-by: copilot:claude-opus-4.6
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  include/linux/userfaultfd_k.h    | 16 ++++++++++++++--
>  include/uapi/linux/userfaultfd.h |  6 +++---
>  mm/huge_memory.c                 |  6 +++---
>  mm/hugetlb.c                     | 10 +++++-----
>  mm/memory.c                      | 10 +++++-----
>  mm/shmem.c                       |  4 ++--
>  mm/userfaultfd.c                 | 30 +++++++++++++++---------------
>  7 files changed, 47 insertions(+), 35 deletions(-)
>
> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index 45355bdb4ec7..f401623f315d 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -9,6 +9,18 @@
>  #ifndef _LINUX_USERFAULTFD_K_H
>  #define _LINUX_USERFAULTFD_K_H
>
> +#include <linux/bits.h>
> +
> +/* Fault reason #PF handler passes to handle_userfault() */
> +enum uf_reason {
> +	USERFAULT_MISSING	= BIT(0),
> +	USERFAULT_MINOR		= BIT(1),
> +	USERFAULT_RWP		= BIT(2),
> +	USERFAULT_WP		= BIT(3),
> +};

Hmm your commit message says uffd_reason, uf_reason makes me think of the
character Ulf from House of the Dragon. But not uffd. So as per David let's
rename it :)

I'm also not sure if an enum is the right thing for flag values?

Anything that is parameterised by enum uffd_reason that combines flags will
break any switch statement in there and yada yada.

I wonder if better just as #define's + unsigned long or something?

Or you could do (and this leads to nicer stuff later):

	enum uffd_reason {
	     USERFAULT_MISSING_BIT = 0,
	     USERFAULT_MINOR_BIT = 1,
	     USERFAULT_RWP_BIT = 2,
	     USERFAULT_WP_BIT = 3,
	};

	#define USERFAULT_MISSING BIT(USERFAULT_MISSING_BIT)

etc.


> +#define USERFAULT_ANY	(USERFAULT_MISSING | USERFAULT_MINOR | \
> +			 USERFAULT_RWP | USERFAULT_WP)
> +
>  #ifdef CONFIG_USERFAULTFD
>
>  #include <linux/userfaultfd.h> /* linux/include/uapi/linux/userfaultfd.h */
> @@ -82,7 +94,7 @@ struct userfaultfd_ctx {
>  	struct mm_struct *mm;
>  };
>
> -extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
> +vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason);
>
>  /* VMA userfaultfd operations */
>  struct vm_uffd_ops {
> @@ -333,7 +345,7 @@ static inline bool pte_swp_uffd_any(pte_t pte)
>
>  /* mm helpers */
>  static inline vm_fault_t handle_userfault(struct vm_fault *vmf,
> -				unsigned long reason)
> +				enum uf_reason reason)

See above re: enum parameterisation.

>  {
>  	return VM_FAULT_SIGBUS;
>  }
> diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
> index cea11aad6b54..ed2c42d427b9 100644
> --- a/include/uapi/linux/userfaultfd.h
> +++ b/include/uapi/linux/userfaultfd.h
> @@ -168,9 +168,9 @@ struct uffd_msg {
>
>  /* flags for UFFD_EVENT_PAGEFAULT */
>  #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
> -#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
> -#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
> -#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is VM_UFFD_RWP */
> +#define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is uffd-wp */
> +#define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is uffd-minor */
> +#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is uffd-rwp */

Is it worth retaining the same bit indexes as the reasons?

Reasons:

	Bit number
MINOR	0
RWP	1
WP	2

Page fault flags:

	Bit number
MINOR	2
RWP	3
WP	1

See below for some actual practical justification...

>
>  struct uffdio_api {
>  	/* userland asks for an API number and the features to enable */
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..46d8497ce90e 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1410,7 +1410,7 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  			spin_unlock(vmf->ptl);
>  			folio_put(folio);
>  			pte_free(vma->vm_mm, pgtable);
> -			ret = handle_userfault(vmf, VM_UFFD_MISSING);
> +			ret = handle_userfault(vmf, USERFAULT_MISSING);
>  			VM_BUG_ON(ret & VM_FAULT_FALLBACK);
>  			return ret;
>  		}
> @@ -1556,7 +1556,7 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  			} else if (userfaultfd_missing(vma)) {
>  				spin_unlock(vmf->ptl);
>  				pte_free(vma->vm_mm, pgtable);
> -				ret = handle_userfault(vmf, VM_UFFD_MISSING);
> +				ret = handle_userfault(vmf, USERFAULT_MISSING);
>  				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
>  			} else {
>  				set_huge_zero_folio(pgtable, vma->vm_mm, vma,
> @@ -2252,7 +2252,7 @@ vm_fault_t do_huge_pmd_uffd_rwp(struct vm_fault *vmf)
>  	pmd_t pmd;
>
>  	if (!userfaultfd_rwp_async(vma))
> -		return handle_userfault(vmf, VM_UFFD_RWP);
> +		return handle_userfault(vmf, USERFAULT_RWP);
>
>  	vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
>  	if (unlikely(!pmd_same(pmdp_get(vmf->pmd), vmf->orig_pmd))) {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 73d65644be13..5e2ed80c1938 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5728,7 +5728,7 @@ int hugetlb_add_to_page_cache(struct folio *folio, struct address_space *mapping
>
>  static inline vm_fault_t hugetlb_handle_userfault(struct vm_fault *vmf,
>  						  struct address_space *mapping,
> -						  unsigned long reason)
> +						  enum uf_reason reason)
>  {
>  	u32 hash;
>
> @@ -5821,7 +5821,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  			}
>
>  			return hugetlb_handle_userfault(vmf, mapping,
> -							VM_UFFD_MISSING);
> +							USERFAULT_MISSING);
>  		}
>
>  		if (!(vma->vm_flags & VM_MAYSHARE)) {
> @@ -5897,7 +5897,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  				goto out;
>  			}
>  			return hugetlb_handle_userfault(vmf, mapping,
> -							VM_UFFD_MINOR);
> +							USERFAULT_MINOR);
>  		}
>  	}
>
> @@ -6120,7 +6120,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>
>  		/* Sync: drop hugetlb locks before blocking in handle_userfault() */
>  		if (!userfaultfd_rwp_async(vma))
> -			return hugetlb_handle_userfault(&vmf, mapping, VM_UFFD_RWP);
> +			return hugetlb_handle_userfault(&vmf, mapping, USERFAULT_RWP);
>
>  		ptl = huge_pte_lock(h, mm, vmf.pte);
>  		pte = huge_ptep_get(mm, vmf.address, vmf.pte);
> @@ -6177,7 +6177,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  			spin_unlock(vmf.ptl);
>  			hugetlb_vma_unlock_read(vma);
>  			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
> -			return handle_userfault(&vmf, VM_UFFD_WP);
> +			return handle_userfault(&vmf, USERFAULT_WP);
>  		}
>
>  		vmf.orig_pte = huge_pte_clear_uffd(vmf.orig_pte);
> diff --git a/mm/memory.c b/mm/memory.c
> index c54943302553..1a9b41704b0c 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4389,7 +4389,7 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
>  		if (userfaultfd_pte_wp(vma, ptep_get(vmf->pte))) {
>  			if (!userfaultfd_wp_async(vma)) {
>  				pte_unmap_unlock(vmf->pte, vmf->ptl);
> -				return handle_userfault(vmf, VM_UFFD_WP);
> +				return handle_userfault(vmf, USERFAULT_WP);
>  			}
>
>  			/*
> @@ -5463,7 +5463,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  		/* Deliver the page fault to userland, check inside PT lock */
>  		if (userfaultfd_missing(vma)) {
>  			pte_unmap_unlock(vmf->pte, vmf->ptl);
> -			return handle_userfault(vmf, VM_UFFD_MISSING);
> +			return handle_userfault(vmf, USERFAULT_MISSING);
>  		}
>  		if (vmf_orig_pte_uffd_wp(vmf))
>  			entry = pte_mkuffd(entry);
> @@ -5514,7 +5514,7 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	if (userfaultfd_missing(vma)) {
>  		pte_unmap_unlock(vmf->pte, vmf->ptl);
>  		folio_put(folio);
> -		return handle_userfault(vmf, VM_UFFD_MISSING);
> +		return handle_userfault(vmf, USERFAULT_MISSING);
>  	}
>  	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
>  			      vmf_orig_pte_uffd_wp(vmf));
> @@ -6263,7 +6263,7 @@ static vm_fault_t do_uffd_rwp(struct vm_fault *vmf)
>  	if (!userfaultfd_rwp_async(vmf->vma)) {
>  		/* Sync mode: unmap PTE and deliver to userfaultfd handler */
>  		pte_unmap(vmf->pte);
> -		return handle_userfault(vmf, VM_UFFD_RWP);
> +		return handle_userfault(vmf, USERFAULT_RWP);
>  	}
>
>  	spin_lock(vmf->ptl);
> @@ -6398,7 +6398,7 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
>  		    userfaultfd_huge_pmd_wp(vma, vmf->orig_pmd)) {
>  			if (userfaultfd_wp_async(vmf->vma))
>  				goto split;
> -			return handle_userfault(vmf, VM_UFFD_WP);
> +			return handle_userfault(vmf, USERFAULT_WP);
>  		}
>  		return do_huge_pmd_wp_page(vmf);
>  	}
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 599665a3d6e7..2138a4e6b549 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2453,7 +2453,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	if (folio && vma && userfaultfd_minor(vma)) {
>  		if (!xa_is_value(folio))
>  			folio_put(folio);
> -		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
> +		*fault_type = handle_userfault(vmf, USERFAULT_MINOR);
>  		return 0;
>  	}
>
> @@ -2502,7 +2502,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
>  	 */
>
>  	if (vma && userfaultfd_missing(vma)) {
> -		*fault_type = handle_userfault(vmf, VM_UFFD_MISSING);
> +		*fault_type = handle_userfault(vmf, USERFAULT_MISSING);
>  		return 0;
>  	}
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 119304547230..83587d34b189 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -2607,7 +2607,7 @@ static inline void msg_init(struct uffd_msg *msg)
>  static inline struct uffd_msg userfault_msg(unsigned long address,
>  					    unsigned long real_address,
>  					    unsigned int flags,
> -					    unsigned long reason,
> +					    enum uf_reason reason,
>  					    unsigned int features)
>  {
>  	struct uffd_msg msg;
> @@ -2629,11 +2629,11 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
>  	 */
>  	if (flags & FAULT_FLAG_WRITE)
>  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
> -	if (reason & VM_UFFD_WP)
> +	if (reason & USERFAULT_WP)
>  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
> -	if (reason & VM_UFFD_RWP)
> +	if (reason & USERFAULT_RWP)
>  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
> -	if (reason & VM_UFFD_MINOR)
> +	if (reason & USERFAULT_MINOR)
>  		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;

With matching flags and unsigned long you could do

	msg.arg.pagefault.flags |= reason;

I think?

>  	if (features & UFFD_FEATURE_THREAD_ID)
>  		msg.arg.pagefault.feat.ptid = task_pid_vnr(current);
> @@ -2647,7 +2647,7 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
>   */
>  static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>  					      struct vm_fault *vmf,
> -					      unsigned long reason)
> +					      enum uf_reason reason)
>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	pte_t *ptep, pte;
> @@ -2684,13 +2684,13 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
>  	 * resolve the fault.
>  	 */
> -	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
> +	if (!huge_pte_write(pte) && (reason & USERFAULT_WP))
>  		return true;
>  	/*
>  	 * PTE is still RW-protected (protnone with uffd bit), wait for
>  	 * resolution. Plain PROT_NONE without the marker is not an RWP fault.
>  	 */
> -	if (pte_protnone(pte) && huge_pte_uffd(pte) && (reason & VM_UFFD_RWP))
> +	if (pte_protnone(pte) && huge_pte_uffd(pte) && (reason & USERFAULT_RWP))
>  		return true;
>
>  	return false;
> @@ -2698,7 +2698,7 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>  #else
>  static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>  					      struct vm_fault *vmf,
> -					      unsigned long reason)
> +					      enum uf_reason reason)
>  {
>  	/* Should never get here. */
>  	VM_WARN_ON_ONCE(1);
> @@ -2715,7 +2715,7 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
>   */
>  static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>  					 struct vm_fault *vmf,
> -					 unsigned long reason)
> +					 enum uf_reason reason)
>  {
>  	struct mm_struct *mm = ctx->mm;
>  	unsigned long address = vmf->address;
> @@ -2753,10 +2753,10 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>  		return false;
>
>  	if (pmd_trans_huge(_pmd)) {
> -		if (!pmd_write(_pmd) && (reason & VM_UFFD_WP))
> +		if (!pmd_write(_pmd) && (reason & USERFAULT_WP))
>  			return true;
>  		if (pmd_protnone(_pmd) && pmd_uffd(_pmd) &&
> -		    (reason & VM_UFFD_RWP))
> +		    (reason & USERFAULT_RWP))
>  			return true;
>  		return false;
>  	}
> @@ -2793,14 +2793,14 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>  	 * If VMA has UFFD WP faults enabled and WP fault, wait for userspace to
>  	 * resolve the fault.
>  	 */
> -	if (!pte_write(ptent) && (reason & VM_UFFD_WP))
> +	if (!pte_write(ptent) && (reason & USERFAULT_WP))

I wonder if you could actually

You do this quite a lot and they read a bit horribly with the && and & on the
same sight-line. With the changes to the enum proposed above you could do:

	if (!pte_write(ptent) && test_bit(reason, USERFAULT_WP_BIT))


>  		goto out;
>  	/*
>  	 * PTE is still RW-protected (protnone with uffd bit), wait for
>  	 * userspace to resolve. Plain PROT_NONE without the marker is not
>  	 * an RWP fault.
>  	 */
> -	if (pte_protnone(ptent) && pte_uffd(ptent) && (reason & VM_UFFD_RWP))
> +	if (pte_protnone(ptent) && pte_uffd(ptent) && (reason & USERFAULT_RWP))
>  		goto out;
>
>  	ret = false;
> @@ -2835,7 +2835,7 @@ static inline unsigned int userfaultfd_get_blocking_state(unsigned int flags)
>   * fatal_signal_pending()s, and the mmap_lock must be released before
>   * returning it.
>   */
> -vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
> +vm_fault_t handle_userfault(struct vm_fault *vmf, enum uf_reason reason)

Hmm what was the 'reason' here before? The flags? Maybe more reason (no pun
intended) to keep the values the same?

>  {
>  	struct vm_area_struct *vma = vmf->vma;
>  	struct mm_struct *mm = vma->vm_mm;
> @@ -2861,7 +2861,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
>  	VM_WARN_ON_ONCE(ctx->mm != mm);
>
>  	/* Any unrecognized flag is a bug. */
> -	VM_WARN_ON_ONCE(reason & ~__VM_UFFD_FLAGS);
> +	VM_WARN_ON_ONCE(reason & ~USERFAULT_ANY);
>  	/* 0 or > 1 flags set is a bug; we expect exactly 1. */
>  	VM_WARN_ON_ONCE(!reason || (reason & (reason - 1)));
>
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

