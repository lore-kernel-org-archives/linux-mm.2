Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF828F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228936B008A; Fri,  6 Mar 2026 07:29:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2B16B008C; Fri,  6 Mar 2026 07:29:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AADF6B0092; Fri,  6 Mar 2026 07:29:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDB336B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:29:33 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B790A5812E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:29:33 +0000 (UTC)
X-FDA: 84515569026.19.9FB2BDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27F4118000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:29:32 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ2C8YdL;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+N+fmqbvm7Zv37fwU28NwjTpZFVQVbgvTQtiOFltLE=;
	b=hLy959RaCzR7VaRFM9cLdx2d3WGIq4ZsgLMuA3w/R/oJuoQVAhktxAmbTbtFUHyxPZuj0t
	MXlh5jefg07/hRfSFlS47Jt6CO/ZsVU8bbZCdE0UrIH2TwXsx6rSKSyhvjjK22Sv7DmglY
	fGIWGJB+o1eRSokEkPap8o5zgMCloXA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LZ2C8YdL;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800172; a=rsa-sha256;
	cv=none;
	b=rVO5hZE7U3225pX8+4MbjUN5nJZT8H7T6KD/6bYDNDeQalKUcqW057T72PQv05ypOoFbH2
	oGqUBKJoWLS3Z5F4mr4A3QYC/Q/M4uAnOsvghtqFe1VD6mlOWAGbc83pJZQwHLmQ9ITXsz
	cT8brhisDFmMxbp0CTYHrk6oBgctd78=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 519B160018;
	Fri,  6 Mar 2026 12:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBA6C4CEF7;
	Fri,  6 Mar 2026 12:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772800171;
	bh=e/BhLuvVPXdAbTMBHCsfqneVZFKZ17hQIzvo4yPKeoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LZ2C8YdL87D8RpW/YcqxQXdubcwJYV1mXiNi+UoS9iMH/GZ6tewKR5nE3DeuewPAj
	 FjUGDPllrcWVkaTdK+hHETp1VMwk8al+fULHWHc5ArhEgn636iBiIKwo+030oucnyt
	 R5ip2+oEghEmWWtqUJEOEDUPUzE1JM264O2JI8HG3B2KdY6tnlp6cUREjXfuUUhJqK
	 laEw0eVrwgbM9iqQmt/O5Pd7Dpk3bYJMdu8+pPEen9SGbx9GDjtpxN/Vm1R2vXpdx+
	 TesD22LJCGx7pZOPjxKfoMlDF8xXvihsNP+Y8Jno2n0Svqw7inQAdc/rgB4H5jjlqp
	 MaOZu6sgtomNA==
Date: Fri, 6 Mar 2026 12:29:28 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Alice Ryhl <aliceryhl@google.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Dimitri Sivanich <dimitri.sivanich@hpe.com>, 
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, 
	Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
	bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v1 11/16] mm/memory: inline unmap_page_range() into
 __zap_vma_range()
Message-ID: <a5765cac-69d6-4314-82d5-80ee363906de@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-12-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-12-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 27F4118000D
X-Rspamd-Server: rspam08
X-Stat-Signature: es33g4ccpcafdqqj48hgb4y37on4ihnz
X-HE-Tag: 1772800171-377350
X-HE-Meta: U2FsdGVkX18c2tc7IbZK8o25+SJj/1oZ1A26EUfsj0x8OFHRUbBszigFQNAH0JaE8AJKJ1Ym+SwvqPi2Zm1Wfi7fYO9bipP3HGS+d3uou1zHn2zy1QkWC6Qzt/LJQ1e/snWc1iaviRui0j9Qnxh2cs6CITqLX11EXYy1w7Qjgo7EpRbg5wV/yk16XCyOiyZDmmYQWIAMsCaiAtA//SduuUYn2lYXQczIzSYWsH1LpMgO0byOcJetTMAi0Z7Hcqv4JjyTpu3WJPCxzj2/KHgejbtEu0ITSZhOhcfWZI0kJBH3f+JrndIPGubkyGE9W4hrSFiXScbM2AtQCoODAHfd3Ogb9oFNPD/DAIv/cWa3HQwmw4G8oKPmHfS9ycNQnOnIEHbFcQYZLI+j94SHn2fZy31BLfx8f2NvnFbSBNJWR7FCLC7KuTqh2Jv8M2OC/qiN4tABG+fDk7vEyfbhueVAgq4xNEjd22jWb728GEJdaEeVzDavQM7F9jvOHxf5Sw9Pxugw52ASm25G4ve+o46hAPJ0G8sdoagRrUjKE5LT+wBRXcw0rFFR7DxDb2BdMDkacne8DRqxAJN7ahCm5PnioDyyKS5Ls7YYfQOytt/EjRJYe2XityZoq5hCgQ/aF/xFvJ1M8FsBYodEWAOFUnPjCO5L73kIoxSAR8hZhEU63Qs+7V09HQaTBaIl0d9DrSobbECQZrwLuhtbfeSJAhYsnkWRMIItRkLCFLfwkp0WFMBcdM8RVdN6Z7123f4EgqfnW49nyrYKUiWZR7+sERpT3Ba1ZSwI+HA2/fOBCM33K0u3LgKffyJUktZ72SrKuIICO8y0JrEml+ugao9EUBjfy1S8kVkr1qfSoNOvZ4NwEtM2tw7SxsXecyb8m3lUWA7edfPlg3eLrB3vstcuNL1P0uGLdJPW9c4JqaTw73bR78vQItB5X6WZ/d+Bbq1z8Th75eL+n79k8flnI2o7Xst
 u6hbllTc
 oRvnHbSRkE0AqAt0/+dNlSi6DxLwOsMm2ZlaTz/UyNEqQnmpKbu8PMSgxkQ8mcuxHRuAX8hjGpn/v8RGYq+m8/Ie1H5yd3ovamU/ROE9WNOpsmNI9fpZA1RatGItQ3j84y0hH9REPeHpXPDUNBwivG5MF8koAynsruT3I+PtsN68f0Bb9pBxSaBQyRqLoJx+0yfGgccjmfIeg41b4H6veKSlRbfPXjzCVfSoh3g4Fi/vnG3jbenJExZsGY5ZXsu3gRw2WOxTdPP47lweoadQoESfq1LDq06g2Pd7fncwDkHNZO8SLUDxZJElg9C+gi5FfFUtg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:42PM +0100, David Hildenbrand (Arm) wrote:
> Let's inline it into the single caller to reduce the number of confusing
> unmap/zap helpers.
>
> Get rid of the unnecessary BUG_ON().
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Small nits below, but overall LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/memory.c | 32 ++++++++++++--------------------
>  1 file changed, 12 insertions(+), 20 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 394b2e931974..1c0bcdfc73b7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2056,25 +2056,6 @@ static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
>  	return addr;
>  }
>
> -static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> -		unsigned long addr, unsigned long end,
> -		struct zap_details *details)
> -{
> -	pgd_t *pgd;
> -	unsigned long next;
> -
> -	BUG_ON(addr >= end);
> -	tlb_start_vma(tlb, vma);
> -	pgd = pgd_offset(vma->vm_mm, addr);
> -	do {
> -		next = pgd_addr_end(addr, end);
> -		if (pgd_none_or_clear_bad(pgd))
> -			continue;
> -		next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
> -	} while (pgd++, addr = next, addr != end);
> -	tlb_end_vma(tlb, vma);
> -}
> -
>  static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  		unsigned long start, unsigned long end,
>  		struct zap_details *details)
> @@ -2100,7 +2081,18 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>  			return;
>  		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
>  	} else {
> -		unmap_page_range(tlb, vma, start, end, details);
> +		unsigned long next, cur = start;

VERY nitty, but generally current is abbreviated to curr not cur.

It's not a big deal, but why not addr?

> +		pgd_t *pgd;
> +
> +		tlb_start_vma(tlb, vma);
> +		pgd = pgd_offset(vma->vm_mm, cur);
> +		do {
> +			next = pgd_addr_end(cur, end);
> +			if (pgd_none_or_clear_bad(pgd))
> +				continue;
> +			next = zap_p4d_range(tlb, vma, pgd, cur, next, details);
> +		} while (pgd++, cur = next, cur != end);
> +		tlb_end_vma(tlb, vma);
>  	}
>  }
>
> --
> 2.43.0
>

