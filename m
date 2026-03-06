Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9B9FF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6466B0005; Fri,  6 Mar 2026 07:03:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A74A6B0089; Fri,  6 Mar 2026 07:03:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B73B6B008A; Fri,  6 Mar 2026 07:03:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D1966B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:03:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A12C61A05A3
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:03:29 +0000 (UTC)
X-FDA: 84515503338.09.4ADA48D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 09FA6A0011
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:03:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1hNNt/g";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772798608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaeKwxlFADDb0SCG7LFbZRQ+3aRrnHNNxNfktnf9Iog=;
	b=PQLvljdGMO1/g/ZcLP03zogJU5XzyfqvnTBfzwBlar4nHCFLNAFbjJ9f5cUN/2f6f3z355
	eZ6LoX83oMcKJnZmgynC11P/Emh+x2N9Rj6hXoH/xr2xMfForJB9m7wBeFU0ilOkrAUfdF
	ueStQHrqzw6lrPsnYO/PT1+sknj06T8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h1hNNt/g";
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772798608; a=rsa-sha256;
	cv=none;
	b=Z/Lh+q7rNT6PoP/1PJ8ZMDn/y188mHeRQwjvEOC9jWRapvn9ykkTz2lPEMXemoShD5VyR7
	o1HTQmZnAWAjexyWbLNvggf2ptUz6eaDnZF4Rc0rtPAU3vHsEzFdZV5D1I90A13IAEgwnR
	ALabtrvo2qXL/PklW+55EPvhX6WY5pI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C88E6013E;
	Fri,  6 Mar 2026 12:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6488CC4CEF7;
	Fri,  6 Mar 2026 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772798607;
	bh=8tIEjkmwTnv14wqiBx5utAVT1y4BywX848doWLEUMyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h1hNNt/ggkmOIg6nOIs6YVKXxpvjxXfuNC1/E243FERUMlrdAP/1JGuS8WftUsd7f
	 sEmFfcrfCzizYh1WflGJxM+Mh8s8/NGzCybtmxDbPIa+RYlLhAC8M2mVomjBVzk4GJ
	 ovvi/YoGsX9AnKFqWBjW+IpIUt/t0ThtH++DKgi9JosbOXhePSuaAgqwo9ysipyiZZ
	 tJR6V8PVm0Q3rJsUQBZpi2/tPfiYYA+aTsakBMmVszHI4rXW/zZE1/jrzMC/3s/CgY
	 3bcJ8hm+9ce3MEINimXRaNGIqZXC4Xd93/yIA5/AX590NC8dE2fbRiLTj205GiFNUz
	 8UXcS4I1Opdeg==
Date: Fri, 6 Mar 2026 12:03:24 +0000
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
Subject: Re: [PATCH v1 01/16] mm/madvise: drop range checks in
 madvise_free_single_vma()
Message-ID: <c5a89c14-0c6b-4c1e-a68c-0680c7d64f4c@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-2-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-2-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 09FA6A0011
X-Rspamd-Server: rspam08
X-Stat-Signature: 8rgwww66efqpsypuapboy8bhbtfrn5aq
X-HE-Tag: 1772798607-946814
X-HE-Meta: U2FsdGVkX19LTyTp1UrS+IJw/YynFCbH7jrp4Uout2VAjDDZ606bDpfHhfv5Leg13li9Jd0gKlSLSxdT+UhK64OEdeCf0Qgqjcs0PsHZI7/9FJdLD0r6ij5MmQMxT5N5b83Zay+W8Xk/Ol0vfpac1OkBhx7skHcToqF58h3zwWhXzwlR7tPF+w69ZpVaM6qzUm0V0lUIGnPQMtvMSUMHduqv/+mldPU2W2bhHgHMWKCM3CAijbLfxY1j6AxTZeVaSFANJtEf5J/EU2yRyEogh9F6CMPURs8H+ft+8VZwqIyXmBUW9ABa21x9cMhhbjqQP935brMGQiSaZYaFu1t6ZIHF83o0vIG0gtcY2n8lOPqbHXesK/MVFmgJF027dVoOBIiBtLL7cV+eD3dX2Cbd3TH+3Idn/arwlLup+zB/svEIXAHZXPvzxsUFILiNdu/3hZIQplmTsc8VCbEODLOg7w5qDmmvEaIQ7u/z+MHeVEO8A34UuHY+JxHGYwoBhlNU8OT7c3zDiWO90yfv0Gqh7JfIwqAKegNxyxMT6dx8K9dUggD1180pEWVgX2RZyvrwXPXOvin91sYfSgA300Z+C1zaydLg0rg8JFV7WFerXhzKGvB6BSjXeBDwxiQgq4ZpaMnQbS48Zihd9GQCgzVddLFIBGWibf0D/lciq2skc71CFp1wBKHqCg3XPtlOEUTP5JneiF9bMYbjYj4HjPPK0RR67sXdOfceuhaTzK1ThXNs9LtDtRchu0P79zemvf6wHzf2xGJzR9F6kLwTdpqfRq6WEl4b729TRk/463ZZ2KNSXgJmZve9Nxz2g3MYzTMZrMc8TzZHZ+inJXFdnpkmvy2RAQBRPfooX3Y/FaMKShJ2GrZHUf3fT4s5rhEM4hdQXSWk0sfHUI6UedBqqLJXoLwva6xNNptIJNf9paIehc4cR7Us7WadCkekP4/7+qQiDXelbfwoIqrPDWHXS+e
 +cIsTCd6
 4Bng0D8a05z71WXjpo+BvN47csRplQ0xAB1M3hOq9IqGw2Q8/XbfCmIQxkEvRNN8XPa60PjQ2fwoIH4ReZZ5croV6qqz6OD2BRE4O+SZ1GoxdF1Z5v8Dpw4zCf1kWbT38eEKEw7x5S7w4N5j0FMfIU21GMKJKOug8QNs+OzoJ7RS0O1feq6ccLWzamczyKWrMvQE0YRfWJptRZb1ZGQRiawT9jVmnI1C25uKlKdvkR0SThkkxixrTQJqEzSSWP+8mBZjQw0ebeCx2kv9FoMz2NyeDcLiSivS3+D+o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 09:08:32PM +0100, David Hildenbrand (Arm) wrote:
> madvise_vma_behavior()-> madvise_dontneed_free()->madvise_free_single_vma()
> is only called from madvise_walk_vmas()
>
> (a) After try_vma_read_lock() confirmed that the whole range falls into
>     a single VMA (see is_vma_lock_sufficient()).
>
> (b) After adjusting the range to the VMA in the loop afterwards.
>
> madvise_dontneed_free() might drop the MM lock when handling
> userfaultfd, but it properly looks up the VMA again to adjust the range.
>
> So in madvise_free_single_vma(), the given range should always fall into
> a single VMA and should also span at least one page.
>
> Let's drop the error checks.
>
> The code now matches what we do in madvise_dontneed_single_vma(), where
> we call zap_vma_range_batched() that documents: "The range must fit into
> one VMA.". Although that function still adjusts that range, we'll change
> that soon.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Yeah I did wonder about some of these checks, thanks for going through and
confirming these are useless.

Checked the madvise_dontneed_free() case to be sure and LGTM so overall:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/madvise.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index c0370d9b4e23..efc04334a000 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -799,9 +799,10 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>  {
>  	struct mm_struct *mm = madv_behavior->mm;
>  	struct vm_area_struct *vma = madv_behavior->vma;
> -	unsigned long start_addr = madv_behavior->range.start;
> -	unsigned long end_addr = madv_behavior->range.end;
> -	struct mmu_notifier_range range;
> +	struct mmu_notifier_range range = {
> +		.start = madv_behavior->range.start,
> +		.end = madv_behavior->range.end,
> +	};
>  	struct mmu_gather *tlb = madv_behavior->tlb;
>  	struct mm_walk_ops walk_ops = {
>  		.pmd_entry		= madvise_free_pte_range,
> @@ -811,12 +812,6 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
>  	if (!vma_is_anonymous(vma))
>  		return -EINVAL;
>
> -	range.start = max(vma->vm_start, start_addr);
> -	if (range.start >= vma->vm_end)
> -		return -EINVAL;
> -	range.end = min(vma->vm_end, end_addr);
> -	if (range.end <= vma->vm_start)
> -		return -EINVAL;
>  	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
>  				range.start, range.end);
>
> --
> 2.43.0
>

