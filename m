Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB84C98325
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 08:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766286B008C; Fri, 25 Sep 2026 04:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717696B0092; Fri, 25 Sep 2026 04:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62C476B0093; Fri, 25 Sep 2026 04:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5046B008C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 04:38:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CB87B1C319C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:38:22 +0000 (UTC)
X-FDA: 85251632844.30.5851F21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2A73B160006
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:38:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iqff5ChK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790325501;
	b=19bOeJAfrXpIPe/Jl3jSQMGqxPXjeKB9iBYhxMhy1a/g+BvvN6dt76q5JqVf2ZPdi8HD5i
	Aa7ewl6ur3QdpxZUYwqXGZIcLx4feuHUL/FW93bbm0jBMDDTJKS8x9O2a9rEG71K8BDmlJ
	SMxqPyReVuOdzrDjmWwqA57KA+JbpkQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iqff5ChK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790325501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IB51gXtTDrNhNiCDiirEq139RmYgQaEQ6mwU888iF1Y=;
	b=0F1l0QpLfymkRWuB5k+ZlUtyJapjrGOIWaLmyQ/um5sGQvCu0LutZ9/mw5wnmLMxWgnkgW
	PVL0A9XDy7oWJCT4XJJepV5GUu39hY3FM8C2BlXHBjhiPGYbKZwjzlxa7w0WDZzJ9Uyar4
	Rnl6olnMMmAeVqFa2hq3ohxNe7gPI9g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BCAE434AF;
	Fri, 25 Sep 2026 08:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEBD51F000FF;
	Fri, 25 Sep 2026 08:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790325499;
	bh=IB51gXtTDrNhNiCDiirEq139RmYgQaEQ6mwU888iF1Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iqff5ChKCoK4N32x2WHuIvqlC7HkYdHN7CY++3i2g9vcheHBdS/+YAXTqEu5VhbjM
	 r1Wr00IXeihhHYFf0hZRcpPS8X73+jibzL97WBQMYYsLH+yJV2kDyy+iW962/Ep0/k
	 eDgJEl73dQQg+tW8x1DL5NS/ISDo795JI4MwOcErPy0kDRDt+bWKEOxGQEJPkINBp5
	 9w5uKoF90x3Xaxd93MCluxJKk96knryEtEU4vZK2Qww5CezMGxIMgH2mLvKv20rEez
	 trZ7rR50AwXsrlHVnyC8VGcNo0+pzzONAObRsFlPOMu/mxwLDt4K+HfYdSdwWXgIzO
	 VR1QNMJOpwGJQ==
Date: Fri, 25 Sep 2026 09:38:13 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Lance Yang <lance.yang@linux.dev>, syzbot+c181d3198e98f8aef8b9@syzkaller.appspotmail.com
Subject: Re: [PATCH] drivers/char/mem: mmap readonly MAP_SHARED-/dev/zero
 correctly
Message-ID: <arYnXJHW-Rh4eNzt@gremlin>
References: <20260924-fix-dev-zero-readonly-shared-v1-1-153c2111e323@kernel.org>
 <9efc7bc1-8d9d-49ac-b856-003e81558411@kernel.org>
 <20260924195826.70a87d6fb78d754bc73892cd@linux-foundation.org>
 <95e91b4a-ca16-49a3-9a1a-5b38afa6f08d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95e91b4a-ca16-49a3-9a1a-5b38afa6f08d@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: tci9qincgpigt1gbcnxteijt55gyhxf4
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A73B160006
X-HE-Tag: 1790325501-282150
X-HE-Meta: U2FsdGVkX1/CR6X3JhBbW15iCYM+LDm1HJ0X7gDllC3IGsmA5sX1LaTXYF1C2ofgMKgOoQe1EnX7rvPGsCb6cqe7lJMgVy3B24YMGbHh5jrfhM7qwdWpRc2zTN4QXhCDLHVosD5rK/7hNpEJL4tw87ebc8Cvq8uxhLYWlMaJquCwbDdm6k6rMjJgyzhKXRzoQP1jVBPrhjAnw8pLOlTl4UKE4syaLfe3vYGnXyrDfE7b26QFfUSBc/1JFS1vYG7It3xBXzXdUNMLMWMmxmIoFTAGpVffTy0XhrKsgeFDF/fG4xCIWcK5DUD/FMGdQ7fy95opn7OlSyqALwIyVIrxWvr22Rr53vjJj+UQvqNrg0pMmRrGZ2H5JUxvYJxLDofnamg9Rc726UxXrH3cT7zgH6JtnSR7RsYVUo4VinKB553SE+QX6U4cXVS2BwgoA2RI21F52wzfaBbAL/DuvuwRgmT/+AdX8L7FCUxwppJQOLKkXQ0BmMNTLg23CT62G90L6zj2ZCOgGDjaP23t6jhbyaLGMVBJOortbtw847BUmF+fIlribfjh+I2G/yXcBiiwERL615NgVaSs3OIXfv/1tSVijhUVTdHiVmYVT3nv5eD+mP/6X1ht31AdRxbjvGQlmyufjilNv0ZAic0Gh6itHbrbsv/TrwQcqzf+ynF38fY3JAuAn6h2YQQphtNdIDo0ymNBuqg7pW83CZMHK42fiilEV13PxfN2U3hTjtsIaRRWb8M6kn/ef+oOWwuWTY1T1jasKssXLkOzfsXQ2iwU7bnWTYKXaoE1P2VVhmCYe2GUBQDLGjUL9JVXlBwuGoCSOa1RxTQ9B3TgNscyasYOT1Z2fjAFv0QTmLscMhGmTFK5LdSRpdUUeImGNn5esUz2HAfxUxGpW4xHueVSjE4EBrIEv8HNfnTZjZ1AkMtmepiwUv/5U3YIjxSuMBerj68pFk94+WwqYvFtR4VpDKg
 1t+RoMv4
 UTGH9Nx4KOJv0ZznPrzGmZNVPjN+33LLkpUipQ1k8j8hAyUp+j4W8mcobXyWlPuSeQLivyo96NcRzzmqVMVQKcqsxIbcOfUins2W8M1j58EJBH1wdyp8nN/oLhRJ4g/D6Fk8a53VR74ZsKSNSrHhmaJIFm0Os/JfyPeb6iEU4UIfjULofYhNN6V36lel/9eGda43vGFCp2hOz0kD6YCxDxRHpga3rhx5a+Yflv95aro0lWFafwi1yQ34cR9d+w4dFOMxABdsr4lOeRHUu4I9SIcJcVBApr6OjsoGM/tqnUeQv8CofZCDa6mumf/xVqMVjt+dQAgm3J2h4Gfy9MuUm3JwAgnNFkGhUcDMvTmYjnn2IM7urpIKmgO2WvkF6gv5ZLuyRr0xJe0mRiAN9lEWomvpd1ISFnnjrZulUNQmhDU7CDA74+bwcopnyu5Wya+g2kHCoA0xximmoIh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 09:29:40AM +0200, David Hildenbrand (Arm) wrote:
> On 9/25/26 04:58, Andrew Morton wrote:
> > On Thu, 24 Sep 2026 17:37:29 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> >
> >> On 9/24/26 16:48, Lorenzo Stoakes (ARM) wrote:
> >>> Rather surprisingly, opening /dev/zero read-only then mmap()'ing it
> >>> MAP_SHARED gets you true anonymous memory (albeit in a VMA with
> >>> non-NULL vma->vm_file).
> >>>
> >>
> >> ...
> >>
> >>> --- a/drivers/char/mem.c
> >>> +++ b/drivers/char/mem.c
> >>> @@ -503,7 +503,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
> >>>  #ifndef CONFIG_MMU
> >>>  	return -ENOSYS;
> >>>  #endif
> >>> -	if (vma_desc_test(desc, VMA_SHARED_BIT))
> >>> +	if (vma_desc_test(desc, VMA_MAYSHARE_BIT))
> >>>  		return shmem_zero_setup_desc(desc);
> >>>
> >>
> >> So instead of shared zeropages we'd now get zero-filled shmem pages.
> >
> > "zeropage".  Singular.  Used to be!
>
> Hey, leave that German native speaker alone! :P
>
> Yes, you'd get the shared zeropage multiple times. (some architectures like
> s390x do have multiple ones .... likely you could even get the huge zero folio here)
>
> ... unless the MM has the shared zeropage disabled, and fallback to anonymous
> memory:
>
> -> mm_forbids_zeropage()
>
> ... we end up using THPs and the huge zero folio is disallowed, so we fallback
> to a anonymous THPs
>
> -> transparent_hugepage_use_zero_page()
>
> >
> > The accounting differences, possible changes in reclaim, memcg
> > charging, maybe swap behavior.  Switching to a different fault handler.
> > It's hard to foresee all the effects of this.
> >
> >> The alternative would be to just convert it to a proper read-only COW mapping in
> >> mmap code:
> >> * Not clearing VM_MAYWRITE, but keeping VM_WRITE clear
> >> * Clearing VMA_SHARED and VMA_MAYSHARE
> >>
> >> Sure, someone could then mprotect(PROT_WRITE that thing) or
> >> FOLL_FORCE|FOLL_WRITE to get anonymous memory. Just raising that as an alternative.
> >
> > I dunno, the whole thing feels imprudent.  To alter such longstanding
> > core(ish) behavior.  And why?  Because a shiny new assertion said "hey,
> > that isn't quite right".  Wouldn't it be better to squish the warning
> > somehow and to set about this change in a very careful way?
>
> We really shouldn't allow anonymous pages in non-cow mappings.

Yes agreed entirely.

It then becomes a question about how to get readonly memory.

>
> We can
>
> a) Disallow allocating an anon_vma and fail gracefully. So only a shared
>    zeropage could ever get mapped there. Might break the s390x
>    mm_forbids_zeropage(). But given that's only used in hypervisors like QEMU,
>    unlikely.

Something like:

	/* about to maybe prep anon_vma */

	if (!vma_cow_mapping(vma) && vma_test(vma, VMA_MAYSHARE_BIT)) {
		/* don't prep anon give zero page */
	}

?

I think though it's surely the only case (I hope!) where you can possibly be
both anon (as in missing vm_ops) and !CoW? I hope? :)

So it feels better to fix it at the source.

OTOH maybe it's worth special-casing so we don't allocate on read.

But that brings me to c)...


>
> b) Do what Lorenzo proposes. This will allocate real memory. Someone decided to
>    use MAP_SHARED, for unknown reasons, so I'd assume it's unlikely that
>    something breaks, but you have a point.

I would say this patch is the right fix for the moment to fix the assert, and we
can chase up with other approaches afterwards.

>
> c) Convert them to proper COW mappings. After all, having the file read-only is
>    absolutely irrelevant, because we will never ever use that file. It's
>    anonymous memory.
>

...My idea for the next step for /dev/zero is to remove the mmap handler and have
some specific code in the mmap logic for it solely.

Like we already have:

	if (map->vm_file)
		error = __mmap_new_file_vma(map, vma);
	else if (!is_anon)
		error = shmem_zero_setup(vma);

And there's already specific file_is_dev_zero() code, so there you could simply
decide:

            CoW /dev/zero -> R/W anon
shared readonly /dev/zero -> R/O CoW (i.e. with VMA_MAYWRITE_BIT set)

As a special case because somebody really probably does want that.

But for the purposes of a 7.3 fix I think let's go with b) [i.e. this patch] and
follow up if that makes sense to you?

> --
> Cheers,
>
> David

--
Cheers, Lorenzo

