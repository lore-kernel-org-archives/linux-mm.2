Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9703C1099B3B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7886B00EC; Fri, 20 Mar 2026 18:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BFA56B00EE; Fri, 20 Mar 2026 18:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3EBC6B00EF; Fri, 20 Mar 2026 18:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E35C06B00EC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9D08413A9BD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:28 +0000 (UTC)
X-FDA: 84567846216.27.43FCACD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EAF171C0003
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I4f0P+4/";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOf6Z38ZxhFhLl7cVKzFfISVls0fmbTXGqCqn/1Aa2s=;
	b=n7fC0w+QvHRc+dxQgjwlOVch8iO3emRIL8wJjMlsD9SmZlZWIMKwo4d5RIfvPX/nHAXJ21
	M65ztcwoJ8Nofi5RDG3qrfUciq5//6bEsZ+gscDa4Br7vSUpTNhAs9npzQ/o60v9Ht6dqE
	Z/zamYULie5j2e5YzFN9wqyfeDH6JGA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="I4f0P+4/";
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044867; a=rsa-sha256;
	cv=none;
	b=2INW40BgcCShUS4EuCDbynCe/QiHBcnIBsEjBA1o1WdRSZ9qM19f9KuIbJ5vJzyyq05DLF
	064dGDCW31nSNtHhg3gm2qcA3D30/BpvhDV7A1mR7AWXBOYXiAf59pbY56sGuYgbaUFctQ
	8pPoaRlWUx+tEH7JSUy8lUVuamocEy8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 219DA41838;
	Fri, 20 Mar 2026 22:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E6EC2BC87;
	Fri, 20 Mar 2026 22:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044866;
	bh=EJFefe3k86LwmaxBPXrya5hP9X6x4nyWEoivmKnN/xA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I4f0P+4/Fr6KtbcDwJjO9w3QoIlF6KRTpZZJWZSbvooeYpf7n8wbwYC1XDUZKnHdS
	 xJOHJXSYItqCme2WWVfCRZflxAnLBFq0xUXkN/i0EoMg/pppX8wxvEhdW4so2zLAaW
	 8o22ncvQ+k+qmAqGFLocIUB3mwyn4EFgiCAmzExcQ2PJXvFrx0OGiIndik/aoCynLN
	 9JymF+UWIuaY29XIocf6s5fsDz9rF1s06hN8PoHaaGnJyhpqaOsm9NjsdMF+qSOTnQ
	 TtuOLyxXpYUlmButgynZGHhdY/u1nPzDI5uyj80JTcR+BPt0fmTl9WQ4HOYZ3YlHK1
	 lA5kQrtlVkd5Q==
Date: Fri, 20 Mar 2026 22:14:24 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Miquel Raynal <miquel.raynal@bootlin.com>, 
	Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Bodo Stroesser <bostroesser@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-afs@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 15/16] mm: add mmap_action_map_kernel_pages[_full]()
Message-ID: <d709465e-79ba-4a12-9bf7-803a3732aa85@lucifer.local>
References: <cover.1773944114.git.ljs@kernel.org>
 <54ff3670662e10a66ce0c1a13c0ae93b99a5f201.1773944114.git.ljs@kernel.org>
 <20260320210812.GA3988975@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320210812.GA3988975@ax162>
X-Stat-Signature: khmh6awwkiy9srgf95tdr3uxwhobu893
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: EAF171C0003
X-HE-Tag: 1774044866-16102
X-HE-Meta: U2FsdGVkX19U9Nul/t0hVNHSXvES73iGn8jaWhXoB0SerNqBEmnyWdZp2Tb3ejN4AM8RMbvo16JKJ7D8Uh4hsjy0zaC4eyUCR0aAKBO8tQo0B+dKaqH4wZmeMKP/O9qNA33i1DqSg0DtU3g308iAxIbi5A7NcgkGwk/BUTJU3bIKXHD14uP7wJ4tftJXrt9rqZWrqmg0Rb2Ep9hGaEw1ZTAPqYn7AdR2G3jamL5ibU+TaQQFdFN1XE28QjRVUXfJjObKJX0TKAHkXLc0cVEc8AEfQqMQu3Ae8LxFwTNZWLV8eSW3w+Qbi4Z33tjKvNexyxDmpvgFqw+8bPhwW9PnxbNKiIz5lJ/m/rmKp+6TbDqgJxwWL3iwBPKshBbf7uCPut3G0Owx1XiZkxC1Lm8GIf3l0vBBPhzCC4ovanjnqmGQrEO3MiErUGr7K2Um0ASbpOM4mWc7BFWNJCZhJPxw3niLtR9KTyDCHb1r08/EvoIISSTwsx5FTZql84EWSyTrCcULZ9WOfQPPiRSKO2bYhzKcddkJTYFGU9d7t5y4P6XhwD4hDWCYnWiRj5HtAPfJrVU0ISdPCPyMMQ53He5nCTXGHQDh8di6/DRGfGHS8zgTtfsH/+3foMlLeM8VCDLksyyc67sI2rSe4ElUUSQ8nyiPZbQ5T5p7UCPEdqYICHzoykjCTs+YX3eHpD1QW6xlIjYn2G8Ax3UKSNDJ2gdPckV8D5tM0yQJqA423oATHrzGM6Ll9UZG+duLo79nzQeuWoDTiQCPNku9oWao2Lc4ebNDglJUdVegQIvb92lTTwYRAFFR4w1VeCOP1lbpnge2tAlo+iIxcBcgX5uZmCtCM/t+WMmwkZwLZFNbDMVNDzG6XiYCJtJPTtORnOU+5F1uocTFchu1x8OuLlu3f8jbTV5ZoDIt7/zSHxnR+4sYMPGsDda8f27zuxZhcOW+m4p/KlEiWWUOko7odKAKbp4
 YRXCoqVh
 W9l4AwPASwS2v1RYxlcK4j0hNNdTHi1z9Di7sT6WyksbLvWoJ4zZhsdXRFRral5gWQs0uKbo2o+8sqYh2lo++GkyZ5Rf8XwXC0U1QXb0c76ma+E8qVWLrqp0TLpziMzFSvHpVCIyH1Zvfj9huppCY9VzAW0ywAY4aIwObEkRvyfIFBfKYW4ziYQT1hOLkXf97XW83xpP30Gr4doH/SDrj0GIcST5Whu3s2zwe9sC2FeLPBLdACUCEEkiBKFHQM6WeesCG5Y923SfCg2+5HDE1A5gElJDnARyQ11H1IyHlfpb4mfleXyECMP4m0e5UAI+1E+ZxK2b7mV2kfBgSKAG487Hi2jxrzB4xA/BtELx3EewmGFmU0uNfpJUQLYWFtligac9M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 02:08:12PM -0700, Nathan Chancellor wrote:
> Hi Lorenzo,
>
> On Thu, Mar 19, 2026 at 06:23:39PM +0000, Lorenzo Stoakes (Oracle) wrote:
> > A user can invoke mmap_action_map_kernel_pages() to specify that the
> > mapping should map kernel pages starting from desc->start of a specified
> > number of pages specified in an array.
> >
> > In order to implement this, adjust mmap_action_prepare() to be able to
> > return an error code, as it makes sense to assert that the specified
> > parameters are valid as quickly as possible as well as updating the VMA
> > flags to include VMA_MIXEDMAP_BIT as necessary.
> >
> > This provides an mmap_prepare equivalent of vm_insert_pages().  We
> > additionally update the existing vm_insert_pages() code to use
> > range_in_vma() and add a new range_in_vma_desc() helper function for the
> > mmap_prepare case, sharing the code between the two in range_is_subset().
> >
> > We add both mmap_action_map_kernel_pages() and
> > mmap_action_map_kernel_pages_full() to allow for both partial and full VMA
> > mappings.
> >
> > We update the documentation to reflect the new features.
> >
> > Finally, we update the VMA tests accordingly to reflect the changes.
> >
> > Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ...
> > diff --git a/mm/util.c b/mm/util.c
> > index 8cf59267a9ac..682d0d24e1c6 100644
> > --- a/mm/util.c
> > +++ b/mm/util.c
> > @@ -1446,6 +1446,8 @@ int mmap_action_prepare(struct vm_area_desc *desc)
> >  		return io_remap_pfn_range_prepare(desc);
> >  	case MMAP_SIMPLE_IO_REMAP:
> >  		return simple_ioremap_prepare(desc);
> > +	case MMAP_MAP_KERNEL_PAGES:
> > +		return map_kernel_pages_prepare(desc);
> >  	}
> >
> >  	WARN_ON_ONCE(1);
> > @@ -1476,6 +1478,9 @@ int mmap_action_complete(struct vm_area_struct *vma,
> >  	case MMAP_REMAP_PFN:
> >  		err = remap_pfn_range_complete(vma, action);
> >  		break;
> > +	case MMAP_MAP_KERNEL_PAGES:
> > +		err = map_kernel_pages_complete(vma, action);
> > +		break;
> >  	case MMAP_IO_REMAP_PFN:
> >  	case MMAP_SIMPLE_IO_REMAP:
> >  		/* Should have been delegated. */
> > @@ -1497,6 +1502,7 @@ int mmap_action_prepare(struct vm_area_desc *desc)
> >  	case MMAP_REMAP_PFN:
> >  	case MMAP_IO_REMAP_PFN:
> >  	case MMAP_SIMPLE_IO_REMAP:
> > +	case MMAP_MAP_KERNEL_PAGES:
> >  		WARN_ON_ONCE(1); /* nommu cannot handle these. */
> >  		break;
> >  	}
>
> Not sure if it has been reported/addressed yet but it looks like
> mmap_action_complete() was missed here, as pointed out by clang:
>
>   $ make -skj"$(nproc)" ARCH=arm LLVM=1 mrproper allnoconfig mm/util.o
>   mm/util.c:1520:10: warning: enumeration value 'MMAP_MAP_KERNEL_PAGES' not handled in switch [-Wswitch]
>    1520 |         switch (action->type) {
>         |                 ^~~~~~~~~~~~
>
> I assume
>
> diff --git a/mm/util.c b/mm/util.c
> index 682d0d24e1c6..c41c119a5a74 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1523,6 +1523,7 @@ int mmap_action_complete(struct vm_area_struct *vma,
>  	case MMAP_REMAP_PFN:
>  	case MMAP_IO_REMAP_PFN:
>  	case MMAP_SIMPLE_IO_REMAP:
> +	case MMAP_MAP_KERNEL_PAGES:
>  		WARN_ON_ONCE(1); /* nommu cannot handle this. */
>
>  		err = -EINVAL;
> --
>
> should be the fix?
>
> Cheers,
> Nathan

Thanks, will fix, working on a respin now anyway :)

Cheers, Lorenzo

