Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45BB7D38FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2DC6B0005; Wed, 14 Jan 2026 11:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70B76B0089; Wed, 14 Jan 2026 11:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959466B009D; Wed, 14 Jan 2026 11:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 861286B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:59:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2E50C8C090
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:59:19 +0000 (UTC)
X-FDA: 84331180038.22.F9C8BFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F85AA0013
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:59:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r5rGUtxb;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4reHESkUnWbue68fQZhTbic5vkjEaLiEpDDiEBelZ90=;
	b=d6fTDw7pH5SlfLiqLqWK5MApfmOzqETByks6dJ+8UUwHgbD5KpC2g8YrlQfE9uxQcrwnC+
	PPGKIkRN2VIr5vpjboDvH1jBt8Vj3/4lDHNsEgLb5vVpgJWoOOep2BZPy9tivqHx61ut6Q
	1Fj5NSk9aiThyP0eOcyHgTEEY89OEnk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r5rGUtxb;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409957; a=rsa-sha256;
	cv=none;
	b=TstVykrQMBfX8JCqVBFuMbzDtO1pWavFJe854wXnqHyjrnKvXApxj393RvGXPWZpatclcF
	KyZ/ZHcDeEmMoIXmhRt+aV12ukHC+z2pBk67WTI5peVCbZ0PLYFVmKuHW96lS5WFSF+BX0
	Tn71KKvcI1cI6rwsY14PtOq026st/ZQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CCD843E6F;
	Wed, 14 Jan 2026 16:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DD4C4CEF7;
	Wed, 14 Jan 2026 16:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768409956;
	bh=B0iF/dvyn/kec3053bYjCb0vU7YgriPK61h7HY9oPK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r5rGUtxbTEFRVIwKmrHc2xHpl8euv4Jw61qaIMJHTpRKz2a4Wpu0xrGEmM+eetht/
	 4kyUSIxUQSya+dfCBPaIyUSuOepCAXBVpCLeUw9fXTaK0jHnNxz6JsxoBI0MeNnHe/
	 vId4RJ2fHC56O9ppqki5yeCg8P2YagaI8NbnorlgkUhxqq4FrrxrB8qQpQ47T0KUNW
	 eYsitdf330m4rKkulB74dq5rn6lk3DOk5FWv5qS9Wio7TIXz3v9cpvERGIp6LF6tfC
	 3Ws/w2epkFANtwCr7qac4IeIbQNoqU3eltzoWZlT5jAI12pCtBM4YHIACXBKdiJhyN
	 3eE40h0j90mxw==
Date: Wed, 14 Jan 2026 18:58:51 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Mason <clm@meta.com>, Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, jasonmiu@google.com,
	graf@amazon.com, dmatlack@google.com, rientjes@google.com,
	corbet@lwn.net, rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com,
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org,
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr,
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com,
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com,
	vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v8 14/18] mm: memfd_luo: allow preserving memfd
Message-ID: <aWfLS48tG7XInpNN@kernel.org>
References: <20251125165850.3389713-15-pasha.tatashin@soleen.com>
 <20260113140927.1074142-1-clm@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113140927.1074142-1-clm@meta.com>
X-Rspamd-Queue-Id: 6F85AA0013
X-Stat-Signature: 1bqbmo7xgr3we4bf617jqrpjomfbbo5p
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768409957-740953
X-HE-Meta: U2FsdGVkX1+2LqEOiMCPYyGlbfYZePI8cTMyIlzhG17ZIxHYZudJ1dpgVF+nyy2NsQc1DnYHpwhLqHBsyPy8z+gpyLf0+Izf80YwfcrOgG+oRQiJCmqE7kuiN8mn0rNhTS0gQWQ2itJDsC/32TblrWqm1U8reTUOHuBanwpStKY5P4gtDVM/KCgjei6fauFcfl0j/0ysrI+qzkVcRgwiDOer4wXchI6fr+Z1JxzoaBQPsz2NJh8qjuARBcYu0dMV0ixoize1E2wfuj/VK7ESgINSLxBOMkCnaZSvBJgtG3Ce5O8wZA1CpruEGwWz7MhN2br4KSjbAQkcgr1h24RUDQxQWZ0xCVnYfVcmEES2mBr0qQoIp6X87MJte0MkTYhE7l+JBr+h8Z5+6dn+6L020oc8sfgvXeSY9v6EwuXXzcHv4Q07UxBR3tJU3nTANOYMjCnvu8KO/iQU0PHqO1JWUQNTTL0GPy7B/QyBiR2u6w51Dv2q6dIVshAI5NGEHTRFeAJnaMeszV2VCtjLMTHej6EoGYqCQRAqW/wsGbp54CGUPjlWoWHsgy1KEzJ49X3pwCzd+oeOWt3QIdNmamR2GsonPTN6U1IcsO7B9tcUbT1VywAdpQFAN5Uwd97Z5PUhupS8iGVY4wen5Xp4uJ6fr1seZ29LagEz6pT8Ft8P45PLfsSpb0elgSAQYmnbJADhIPHSV9nEb8RGMOd4MUdK/j7nvIoKjrHj3NM/58wqat8Ye6dfks0mCES02mm0adxOyp1H4YzOZ5uqBB5m3P7ay6D2JJ7YBEm5siM2X/Guz2hNDIgR4ysYTgddidwagMM4+zuUBM9dJvvnuxVgIk7nkUOAIb9+nHs71O3IYv+T12OfFdoLtgln/MOUrBmD05o2z29FI/mWI32Wbxfoc3e2H9y1VAlEkF2fxwR8B3mUbH9lHwOrDF3aSkbgEbG/0Dqj0tqbFFPJXZn6ruYvx2L
 8OpUxViW
 AWwqJcWlBxHZpLswLl6ttvC3W3NEIlS5KJCmMriHsKOaTgiY7OcFppp7CkNL5LxNfwP+V/iY6JSxuzX6mvDe8Cke//pqqY7NJYR+kXXexXI2Kkub8LLp+CmVVKADqyOwNRN1cR0cCWyYZKXUzcX/fbyYzEWsQ0IFk6iifcqTqOcx6XbTAcqB8q5OZpEvT3jarRn0OFTYQOtQO8tR/DxzxbrF2b+TGbtGe+2i9LlOEQJb+TLX7fDjar8BkQ7Vhd/oxkmO2J1mhMWo6Y9OntMxICWdqJREAexaiNfwLzeGm1D2Zc9bWKQ0Cr5WIPvuJonO4noxTnTQ4Y1dpUx4xCj0zQGBBoQqcJlIEWSS3X9J3gmisDHTpJNyLEsOzT+y4K/I2v3T5FnWjOlCyvFLgAN0B/7Gp/edEyHE6Exb3drmpPIy4DZieP2g/UIAucg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 06:09:23AM -0800, Chris Mason wrote:
> On Tue, 25 Nov 2025 11:58:44 -0500 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:
> 
> Hi everyone,
> 
> I'm running the v6.19 mm commits through patch review automation, and this
> commit was flagged.  I don't know this code well, but it looks like it
> might be a real bug.
> 
> [AI review output below]
> 
> > diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> > new file mode 100644
> > index 0000000000000..4f6ba63b43105
> > --- /dev/null
> > +++ b/mm/memfd_luo.c
> 
> [ ... ]
> 
> > +static int memfd_luo_retrieve_folios(struct file *file,
> > +				     struct memfd_luo_folio_ser *folios_ser,
> > +				     u64 nr_folios)
> > +{
> > +	struct inode *inode = file_inode(file);
> > +	struct address_space *mapping = inode->i_mapping;
> > +	struct folio *folio;
> > +	int err = -EIO;
> > +	long i;
> > +
> > +	for (i = 0; i < nr_folios; i++) {
> 
> [ ... ]
> 
> > +		err = shmem_add_to_page_cache(folio, mapping, index, NULL,
> > +					      mapping_gfp_mask(mapping));
> > +		if (err) {
> > +			pr_err("shmem: failed to add to page cache folio index %ld: %d\n",
> > +			       i, err);
> > +			goto unlock_folio;
> > +		}
> > +
> > +		if (flags & MEMFD_LUO_FOLIO_UPTODATE)
> > +			folio_mark_uptodate(folio);
> > +		if (flags & MEMFD_LUO_FOLIO_DIRTY)
> > +			folio_mark_dirty(folio);
> > +
> > +		err = shmem_inode_acct_blocks(inode, 1);
> > +		if (err) {
> > +			pr_err("shmem: failed to account folio index %ld: %d\n",
> > +			       i, err);
> > +			goto unlock_folio;
> > +		}
> 
> When shmem_inode_acct_blocks() fails here, the folio has already been
> added to the page cache by shmem_add_to_page_cache(). Should the folio be
> removed from the page cache before going to unlock_folio?
> 
> Looking at shmem_alloc_and_add_folio() in mm/shmem.c, when
> shmem_inode_acct_blocks() fails after the folio has been added, it calls
> filemap_remove_folio() to remove it:
> 
>     error = shmem_inode_acct_blocks(inode, pages);
>     if (error) {
>         ...
>         if (error) {
>             filemap_remove_folio(folio);
>             goto unlock;
>         }
>     }
> 
> Without this, the folio remains in the page cache (counted in
> mapping->nrpages) but info->alloced is not incremented (since
> shmem_recalc_inode is not called). This could cause shmem accounting
> inconsistency.
 
My understanding that if anything fails in memfd_luo_retrieve_folios() the
file is destroyed anyway and the accounting wouldn't matter.

But to be on the safe side we should fix the error handling here.
@Pratyush, what do you say?

-- 
Sincerely yours,
Mike.

