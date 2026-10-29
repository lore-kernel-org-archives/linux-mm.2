Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D2A606A329
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 12:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RiohXsBn
Received: by kanga.kvack.org (Postfix)
	id BC6516B05B6; Thu, 29 Oct 2026 08:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77126B05B7; Thu, 29 Oct 2026 08:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4346B05B8; Thu, 29 Oct 2026 08:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9047E6B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 08:20:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A60716039A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:20:03 +0000 (UTC)
X-FDA: 85375570686.15.0DE2868
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63EAE40011
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:20:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RiohXsBn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793276401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gESRXwpoweyr0cm+satiqXh4JmHP5qxA2OIhTI1lmM=;
	b=y7eCl2KXP8YRfGaXfCPJUoX+Zcqdb2yFhGCvjnUNfkxX9vctJxEgPpda2LhG1P8IjJvmi9
	eRgRgFaW3tbhPFZVgqTWaZnN2QeW33k0MCWoyP+gw1y0E4l8A7RRwDY7+JHb80TTYNgih9
	UwNcj5a1YrsQE1aMdnmDQhHldBKfdw0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RiohXsBn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793276401;
	b=Ok4pkDxO6dKdYiahE/bGesFAbX4nGRjoxmSytxx9qPvPrwz96nlY3WU8XhgjoG0zyMGshT
	oQ+6vum0NFU72H64DMgc1EB8MnpI3ODz/pk+SFFWqmjgg1P0oBb3Bui92mCrRwyedgpOUb
	LWRZyBgIm8oF+pM51t3x6fLhaT4kOXc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED6B1601FA;
	Thu, 29 Oct 2026 12:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868951F01825;
	Thu, 29 Oct 2026 12:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793276400;
	bh=3gESRXwpoweyr0cm+satiqXh4JmHP5qxA2OIhTI1lmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RiohXsBnJlLT7tXhp1+CPkAKj9f9s2yejzY0UNAw7u2R9VLKbB3S0S0gsWNgOc8Ct
	 dyqsZ/gwKDcgSH1IqYh5nh4xdu8wJtONfpBiFjFSD0jvyFbBnlhsq6JHnvRf6RZV+Q
	 0pepzCfT/HEy38cjcE0+f9+8DwFVSuOe/5eWC/PdJj9KE2HCTT0YHagX6+r64QNMVO
	 mAKjgVCDFQ9Fwq2mzC9NsocLkNSzzgs1svNuAdoPLTaNhoYDZOaL+Uk6bBeF3/aUXO
	 jkiDvSyt5/a3UUUZeiSD/YDtIJAymxtQOwWP0jPE3fKXa1rIwx9HM7OfkXFbsQ4/U9
	 WPTunT/VQvhTg==
Date: Thu, 29 Oct 2026 14:19:53 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/cma: accept memory of multi-range CMA areas
Message-ID: <auM56dTOXCb70vzz@kernel.org>
References: <20261029-cma-multi-v1-0-2cbced8b5cb7@kernel.org>
 <20261029-cma-multi-v1-1-2cbced8b5cb7@kernel.org>
 <a25827d8-83ee-4e05-8c55-4e6ca8a498ad@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a25827d8-83ee-4e05-8c55-4e6ca8a498ad@amd.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 63EAE40011
X-Stat-Signature: e6eua8h4o8acziuq53bd8o7g45nika6e
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793276401-269631
X-HE-Meta: U2FsdGVkX1/QR2U+DJUBj26qaroyrRvljjAlFWey6Xebfq1e3mUg8VJAQa1rtLdMG+5GJlyEDv5eYOr3sa64ML4pFLBiKarc+Y/fpBEG53jnLs3GuTadOa/nrWPsjKU8vY4TkKD5b2TW1sSFR8NXE/Jx6RTpfw9B86S5YceUKdhP9kNd4/M4DwyfjwIanYFl8O2NNjnMNJXMgGE8+UGMxo5CU3q8jUL/Fanm17RsU1ZSflzFkN7ixH4tsIosd+jSdXMN0l9nsv7uWdtmf2SO1kN+wlZggfnWDKhmQfEdbBLMgasn6lXtZFekpoL6U3u219kEyDqQf/lV2o45eptIgM0e8YA72drLhbRoDhAc3r01/0vuSUN1JX8vADjfvU475IJ9B87v1B6iCBySW+5M99hYpnuBYOHEYTkYQ8qN3zsJXSbIg2zwOlxLF421RL0EDtaPnBUhNzy42XUG1COF4LM7M2+WkzSATdSeiFok2M72mX/fwIGhseShMRszFsUqEXXmcSVQGLeZfY1bVDjDK/TkXALIrVZB+Ye+IduwDULsMfo7Fuh5L4+qK0VJWoFUwCE0uUnkCL80Qn6R5qbJb0vib6wBamUDsdUJulYeHI9ATQPViNUjrm67Bb1EOGh26QbRUNqWeqHKgTIIfDVOyixaht2rAJJAo2psLDrUKKOnjuyqRisy618+ZQ/4hshTiysUgVihasVnVg+7KgvcPY2mF3SYNZ4G6HIuEvEGHfbhK9mfSwD7BQsVqU9NHknk+Zn0q5y/sMnx2gsujIHFBykXs/nJOuv5r2vS1aqg8imOtpRZyfsWL5chpvsJE2Uun03Gf5XL+lTbVSmO9M5ciH534Zf3KBk7Xb9GBmmpPL9bCtusICn0q8D4eRBeWSWpaXY1EO9IEFIQx0TSk6NkhjSqXnWuE3S/2veNK2kURbHKc6EiWynxcNa47s7JGdC4jXDqdMCXO0GxvfugIH2
 j4xVi2vO
 lX6/7uvczgpQKY99GUYKCKIoRnS9nF4OiZgqJYd+8hCVNaezWuSOKPrAoEGxL05iSo7znG9fG3vW/zBu7co+H4B58YNBKBlbYBbUL30Xl8Upy6kdQQIZvw7LEgFX35BKEmKTKpjic8WY54oauOGqFjo8drddoLIs8NpM1WQ53quY7sj/cDvJnE+vOBZzrQHlBmycvdZRkmejM38zFojTQdwYw6oPIPXrSuygJlMYXlD2Vjha7W8xnxDb7vipYF+bVoOZ46ouoDYpsiavc0LFSs6L/cQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 11:52:53AM +0100, Gupta, Pankaj wrote:
> 
> > On systems with unaccepted memory, memblock allocations accept the
> > allocated range, but when cma_declare_contiguous_multi() uses open coded
> > allocation of multiple ranges, it reserves them with memblock_reserve()
> > and they are never accepted.
> > 
> > These pages are released to the buddy allocator by cma_activate_area()
> > with __free_pages() that does not check for unaccepted memory, so the
> > first access to such a page in a TDX or SEV-SNP guest is fatal.
> > 
> > Accept the memory of each range when it is reserved.
> 
> Fix looks correct to me.
> 
> Any easy way to reproduce and test on SEV SNP?

I think running a VM with 16G or ram on a single node and with

hugetlb_cma=8G memmap=2M\$0x2ffe00000 init_on_free=1
 
in the kernel command line will do the trick.

> Thanks,
> 
> Pankaj
> 
> > 
> > Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >   mm/cma.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/cma.c b/mm/cma.c
> > index a10ea37a261da..0035efb1130a5 100644
> > --- a/mm/cma.c
> > +++ b/mm/cma.c
> > @@ -678,6 +678,8 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
> >   			break;
> >   		}
> > +		accept_memory(mlp->base, size);
> > +
> >   		pr_debug("created region %d: %016llx - %016llx\n",
> >   		    nr, (u64)mlp->base, (u64)mlp->base + size);
> >   		cmrp = &cma->ranges[nr++];
> > 

-- 
Sincerely yours,
Mike.

