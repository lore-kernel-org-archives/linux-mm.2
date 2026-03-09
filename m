Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25B6EF3C25E
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EB06B00A6; Mon,  9 Mar 2026 09:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F0106B00A7; Mon,  9 Mar 2026 09:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB5C6B00A8; Mon,  9 Mar 2026 09:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68C7C6B00A6
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:46:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3085C51D53
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:46:48 +0000 (UTC)
X-FDA: 84526650096.01.CBA4C58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 74DB410000E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:46:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BVr69GD8;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773064006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zso1UHrl7gDNYxkrQKsLxt0cUGSVikyYTIXnkhMmBCE=;
	b=uyTi2R2y8kZ54Zibcwwv5HGw12wQW3bgKm5+u5bKW2zcNPWT8U47Fi8aF0VvvE+hvJeJcF
	cxvoSky7AqD1c1QGmNlVHCvE4nvLcEPV+DYJJwmYTv8g5L/lx6C0dXzypyXOfyonHMzIkf
	WHdJHjY4HuOsLbkVS2ses93UUB8UYPg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773064006; a=rsa-sha256;
	cv=none;
	b=GxBKI3O2i8IBsSoHjgnPgnmo6yYOBtA057bzhV/K4kVycZzn09r0jbYm/3GoLxF9d1pGOw
	QGxGgA8dr9vmeju9dJ6Y6hhrK3CKzk/5Y2r9lAQHiYuW8L3np6xnflCh6fQKbbRdLGRogc
	OAN754COpfI2lQKBYVXMhVcJSUO/9EI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BVr69GD8;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77C214423B;
	Mon,  9 Mar 2026 13:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF8FC4CEF7;
	Mon,  9 Mar 2026 13:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773064005;
	bh=w0QUYZum+m+R/ZMJD9ICvWbnwxxvrz4NQJRGvdgYc+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BVr69GD85TMcTAfG+a8utDGbnLRZpnfsgk6oAEieKIf3SbpafBvF3+irOxH5364Mf
	 5pQjiP3OB9FC6sxDF6sRahqD3JxDLeM/LKZhytQKKexcd9nKBgdJPKEyw8sk8hmBqZ
	 6Umeng6LJPjNhP9ijAtZ1GLP3fQirKriMZIBcjz1MV/Ly4Ym8+L+fbakf0sGYzf2HZ
	 3zIBqoZorFxzO8i8L6kszr5AnLvTpWYNSPn5PmXLkOowtVs0WINaH4TFDGQhbj2jWW
	 Xu+fRiMPtxXfm3CsyrGqKEUJHR4HPp+HrebcbqvJ0J7zXXW7tbIaDGtBQ28EmTK0dV
	 febooG99fQKig==
Date: Mon, 9 Mar 2026 13:46:27 +0000
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
Message-ID: <737a88b8-8221-44e6-aa90-3be326bc8612@lucifer.local>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-12-david@kernel.org>
 <a5765cac-69d6-4314-82d5-80ee363906de@lucifer.local>
 <bc5cfcc4-5e51-4da1-9ce9-ea0831bec400@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc5cfcc4-5e51-4da1-9ce9-ea0831bec400@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74DB410000E
X-Stat-Signature: ti7dnufudzocd6zg3wxufjk6pwhzmzuc
X-HE-Tag: 1773064006-663515
X-HE-Meta: U2FsdGVkX1/ZYkv5cCswVPS4mtqgnx0/XgmNDlWXtNUMDeWqOHOo0ARISDmFzoxCGfBNCUqiBDxnYyHwoURwYrrFTuVfKOgB3IpvcAjSrVbbNxWVSyxDplcnNgiLXMznidqKzIF6cOrGUW7qgiocGIIL71Uy0E/xVSGY4yrnzarmCu9Sl+ai2fdHJEGOQaVd+ENu90XIeKTFqE7Yt3wIyJjHW1dY/jKxSVziiScuBS50/FRRgsMMhOQjHyioKQGyaYOfcYt36dHiAXIG8fU0hYhxQBzXijpIi2MXJjBvcbHgqFNDFFUF0s+qnVLgSNKNEPIoBAWcmnYAsbgtU6zhRichQp//GQ0GOf5H1oColgBFrB5dCaMa/1MfjWu//hqn4UPbSm+RBXWoIV7ypExLkAXcEaTrOeh0nPAfs8uWdL5r2WRreFj9YIn05UstepaPNJuUHqgCw/IJiCSACtdvUicWeU4w5//dIaHdD7vfEtuUy8Qi5Z9vGQzXRZZqU1OiQIgP7CHBUYTc3JMLOUxqUT7cU36Z27ru6JTHK8wQ3Luwu0vrzBImTJO+IKTdf//j0GA6a0BLNgz9z9Yp3n7+PhNQ7aGH1HRxjVWXavJBamQFJjY7Ss8/S2Tnp62/YzT/7wfnxTu/Ov4zvrgVmQu4K9KF8JerI1IDXIKJb2W4zTOSvuMiR0APfAMc4jHgbiPpC6wFZsUxRnqKZeu3y9WChH1qfqFXxZuj1YwDGqKgOiAtVdqEmTAxZG9pDqIPu4uCx/pF+YZ8N/bNNVY8jzuN36u6zlb7w7nJMQIdw8fi3YzZR0JjQc2RNckor5vPgNLnpOPZ4TN2lAzcMFHZOxpuFU86pGV1RMLqH94ieKk6uXoICcdEeZd56NItE6mNb4nAnr6y2Bg4i6BCLlGOX4wMpqhPCzFTnyCNL9hoj5iwCqpwYxxqMoOjQIWCry5xr8XTpccsXmtv8Gv7bbzELUT
 bjskwNna
 WWb2Kt2bHi3DB2s/H/pwHEMlU0dilsKAB6b55XXBuLtP/kxloxTmDY9f7nfbP5/oSvs9iis0JIggtVeVpjTsWKCdUM/e9SfeUjBYvhbA9nWkpeiNh006Y3qhV5cAyuh0ddgQLp2SRdgPbwCJ3mz1ysqFsdxu66QPZtASm77SdGYGb933RPTavDOi7raPTZT8IuGXM9yhH/5Ih6selWhMdyXp27nyjC4kBlebjbXl+zJKqPFDSWQRAxJYIoOFks6AJ/KvP3cLwwqitYVdOJUmvhyvh5iCGlYYjZPmX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 02:16:26PM +0100, David Hildenbrand (Arm) wrote:
> On 3/6/26 13:29, Lorenzo Stoakes (Oracle) wrote:
> > On Fri, Feb 27, 2026 at 09:08:42PM +0100, David Hildenbrand (Arm) wrote:
> >> Let's inline it into the single caller to reduce the number of confusing
> >> unmap/zap helpers.
> >>
> >> Get rid of the unnecessary BUG_ON().
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >
> > Small nits below, but overall LGTM so:
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> >
> >> ---
> >>  mm/memory.c | 32 ++++++++++++--------------------
> >>  1 file changed, 12 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/mm/memory.c b/mm/memory.c
> >> index 394b2e931974..1c0bcdfc73b7 100644
> >> --- a/mm/memory.c
> >> +++ b/mm/memory.c
> >> @@ -2056,25 +2056,6 @@ static inline unsigned long zap_p4d_range(struct mmu_gather *tlb,
> >>  	return addr;
> >>  }
> >>
> >> -static void unmap_page_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >> -		unsigned long addr, unsigned long end,
> >> -		struct zap_details *details)
> >> -{
> >> -	pgd_t *pgd;
> >> -	unsigned long next;
> >> -
> >> -	BUG_ON(addr >= end);
> >> -	tlb_start_vma(tlb, vma);
> >> -	pgd = pgd_offset(vma->vm_mm, addr);
> >> -	do {
> >> -		next = pgd_addr_end(addr, end);
> >> -		if (pgd_none_or_clear_bad(pgd))
> >> -			continue;
> >> -		next = zap_p4d_range(tlb, vma, pgd, addr, next, details);
> >> -	} while (pgd++, addr = next, addr != end);
> >> -	tlb_end_vma(tlb, vma);
> >> -}
> >> -
> >>  static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >>  		unsigned long start, unsigned long end,
> >>  		struct zap_details *details)
> >> @@ -2100,7 +2081,18 @@ static void __zap_vma_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >>  			return;
> >>  		__unmap_hugepage_range(tlb, vma, start, end, NULL, zap_flags);
> >>  	} else {
> >> -		unmap_page_range(tlb, vma, start, end, details);
> >> +		unsigned long next, cur = start;
> >
> > VERY nitty, but generally current is abbreviated to curr not cur.
> >
>
> The following might not be fully expressive (but simple to grep):
>
> $ git grep "cur_" | wc -l
> 24261
> $ git grep "curr_" | wc -l
> 9288

Lol hmm...

>
> Tells me that "cur" is rather common.
>
> > It's not a big deal, but why not addr?
>
> Good question, I can just do that. :)

Thanks!

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

