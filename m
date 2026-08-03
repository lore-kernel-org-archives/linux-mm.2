Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90AFEC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 14:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84476B007B; Mon,  3 Aug 2026 10:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5ABE6B0092; Mon,  3 Aug 2026 10:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999056B0093; Mon,  3 Aug 2026 10:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2A06B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:31:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 049491406D7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:31:18 +0000 (UTC)
X-FDA: 85060195878.23.77079AF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CD2480013
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:31:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=obVZjkzy;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785767477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xoBv2nwiA6fR0PFFvYiaUTbf96aV+HIT6crNJ9hQRXQ=;
	b=y/N5H1QpI75ptSfrjN/XFqEZSoU7FhLxsSD2R2CQYV1fRNT5kbXsNzZoyN7M/sdvXp/qh5
	7BQKLoefR/A/D20HHZEc6mz8XTOUs63LvxBz2qpGUScDM8XHho/CW8AdfJqwG+4oPEIhdd
	j9dWACSHTOJ3ciR9S0awNNC8aqU7zAc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785767477;
	b=io+VhlY7jQIrT/7xaxfXYHnoN63zVVkcqkUJt7JIT3PwP7SzwSlGe6rL+ioXiESXT9QV5E
	8+ILdNmNTC1N912xQKd5fDqbYjWoHGEFzY3AwMbhyTHgFDFebtxGCmOwhUfMTnOLMfMKKK
	0wnBf7SV/cecuG3OvN92nhXYbzgzXas=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=obVZjkzy;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E4B9160A79;
	Mon,  3 Aug 2026 14:31:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A356D1F000E9;
	Mon,  3 Aug 2026 14:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785767475;
	bh=xoBv2nwiA6fR0PFFvYiaUTbf96aV+HIT6crNJ9hQRXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=obVZjkzyBlC4ebjSPgpLrFzutHmHmx3WA28Hq8K+rLLNYCJLpmzrs7+w3PN7t6jyu
	 qBH8DH0ReVhGkw8hODhe7iwvMmL9cd9RC3HPOaCSjmjt3dyIhc3yIFIyr4V9olVidB
	 b50rmP3ozLWFwCPCgjznmA34bO0afGshTLnonO9t9IHuoEmZ3Og2+VfTPT6nHayGTN
	 HXWJmOdwRWXmL07ijHyFXpPOxvTdT56u+h11L7hDUHHPnxP1UxTGinauu6mSeGewXX
	 8o94HmtlWcruO23UIzv/hND55yLYwCVLvceS6tm7ZaUIRvGa/+bmLTgWF54vLiO2oY
	 3KOOt/YQ2aQqw==
Date: Mon, 3 Aug 2026 15:30:53 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 09/15] mm/rmap: use anon pgoff to track MAP_PRIVATE
 file-backed anon folios
Message-ID: <anCmEhfZPfWI8TGt@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-9-e8ecfefea812@kernel.org>
 <5dcf29d5-2fb4-4550-a3e9-a39645d736c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dcf29d5-2fb4-4550-a3e9-a39645d736c8@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CD2480013
X-Stat-Signature: m5mw56mjx8psxw9x5mrcn5m675iuf64w
X-Rspam-User: 
X-HE-Tag: 1785767477-10443
X-HE-Meta: U2FsdGVkX19xArQMl+cSiQscyrWyZ6EkdCWlQSqDFW5uduHs7m8Z7IrMqbFPUf71KuAjsHNurghShUClybiCU7c2IxLukhZ2oXR4aC7xzPiXMUl0eBG+S7j9cIU5gIiJHX71mLSZbTSL4gD8jmOEqgLUcEdlcZQol0GfjruSSOw44+0i8cnR/+g5o6sxNnTlYHDdpPna38Q/i51gyO5rckhMpRbe8xqhZ+h6/LQvI7OFAOin46wvHGbkMGr3/32TKTOhekur+FCBIo0wf1Kzg7CRoWxAFbEaa7LiHWBtkctY00PbvFIRritY900gYFWwem16mJB1ZdZS2mlJgwpf35MZAW23gUuHI+f2c+owRtE8Rq5clMtQFAkmd81Tcji6JnbhspTSSOtHfOvVAWNjB97EpcgUqh4nybEAdJWlER6RzmDPjQwCcir5cVfBCEZsjsPPqfU9yQ8rqav9PzXc1wFmxrn42/EFFUt8xljTKPeH7wgmBWk4oUqLZiDxzs3n1lIMqi6yE2/os0zPxNIH1ojOXqSqY3XlfqCjSLAIz2VEeLtA0GyIitMWti8QErmwXdvfJkMpF7O5nwa41zeS7SzCOYfQxJM4Otm3JCUrEEu5/sfwUrpG4Yqb5FqGJ7FrB3DKhBXJk2PiyPq98T5QrkyKMb+9mCuEEhePmcBGvAMtLO7/MKBbG6atHytKWSaHIbY+sB4N3+MxUIG5NVrIjnUfVOHf0stF4kKksdgX6GgxM1kNEVtb4CORCecL8CLN3VMWF3Di8z24fRSPEx1ZnZPCrqZ+fr5DYFNLXfh1Xe0c6F3UoaK+k55Y/NT0REL8u/OqpqsXIQiKkAjKwFH7/G5J9R8j14YFmrHAm+Nvm8v8js3CDyEdM+Di2Qt5RL6AA2vDmJbTOtJXfEG6RxAkZryNH3OSw+CUhqmhNMXr8+MsxdsRVqKZp9f4Dmhql7bEwspNDY1AvOv65aOPx1e
 9tMViV5C
 4W73O1vUp0D3E+862wAbieQ4ckZcrlzPvO1/nMzN55fdpQSdeARlIVGEspPyun7zz/e4Kg07dmnWF65ZPkH3hnxVc1T3UGwZeo/iR1mIxGz1eulJQI9mZMxgEQQOpu/Ub/XS3Vd/6t8LKKnK2npXUkOXO79SFbXcneh0LhLd7yClCnheI2nKU7S65hSpjto99I5YdGjDUWpNN3Gza3/3jwJ77pwCjX9AbCCmvd6lnkOdIn80AZHenE3l4X4nWYKSGLwN7g0QHqTAx7DiuAGCvSrRF1ZfgOaTf9atnCtMj8O6xyaz9YZJEaEX1oaHH4RrYEJITi7Mcxgk8gBeE9oiePyBrEoh0CcR+P6g9b2LrVG2KDRYjX6S+oBCQIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 01:32:50PM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> > Currently anonymous folios belonging to CoW'd MAP_PRIVATE file-backed
> > mappings are indexed by their page offset within the file in which they
> > were originally mapped.
> >
> > This differs from anonymous folios belonging to pure anon mappings which
> > are indexed by their anonymous page offset (the address at which they'd
> > belong in the VMA when first faulted).
> >
> > This change fixes this inconsistency, always indexing anonymous folios by
> > their anonymous page offset regardless of the VMA to which they belong.
> >
>
> Yes, this is great.
>
> > The foundations have been laid such that we need only switch this
> > functionality on such by:
> >
> > * Using linear_anon_page_index() in __folio_set_anon() to assign the
> >   folio's index to the anonymous linear index rather than the file-backed
> >   one.
> >
> > * Otherwise using linear_anon_page_index() in all instances where
> >   anonymous folios are being referenced or manipulated.
> >
> > * Replacing vma_address() with vma_filebacked_address() or
> >   vma_anon_address() as appropriate.
> >
> > * Updating the merging logic to check that anonymous page offsets are
> >   aligned as well as filebacked ones for MAP_PRIVATE file-backed VMAs,
> >   introducing needs_adjacent_anon_pgoff() to figure out when this is
> >   required.
> >
> > * Updating linear_folio_page_index() to invoke linear_anon_page_index()
> >   if the folio is anonymous.
> >
> > * Updating vma_address_end() to use the VMA's anonymous page offset when
> >   pvmw->pgoff is anonymous.
> >
> > * Correcting folio_within_range() to use anonymous page offset for
> >   anonymous folios.
> >
> > This will have no impact on merging of anonymous VMAs, whose page offset
> > and anonymous page offset are identical, nor will it impact shared
> > file-backed VMAs, which will continue to be merged based on the file-backed
> > page offset.
> >
> > However, MAP_PRIVATE file-backed mappings must now be aligned on anonymous
> > page offset as well.
> >
> > In most instances this should have no impact on merging of file-backed
> > mappings, which are usually not merged all that often, let alone
> > MAP_PRIVATE mapped ones, and rarely remapped and faulted before being moved
> > back in place (the case in which a merge may now fail).
>
> Agreed.
>
> [...]
>
> >
> >  /**
> > - * vma_address - Find the virtual address a page range is mapped at.
> > - * @vma: The vma which maps this object.
> > - * @pgoff: The page offset within its object.
> > - * @nr_pages: The number of pages to consider.
> > - *
> > - * If any page in this range is mapped by this VMA, return the first address
> > - * where any of these pages appear.  Otherwise, return -EFAULT.
> > - */
> > -static inline unsigned long vma_address(const struct vm_area_struct *vma,
> > -		pgoff_t pgoff, unsigned long nr_pages)
> > -{
> > -	return __vma_address(vma, pgoff, vma_start_pgoff(vma), nr_pages);
> > -}
>
> Good to see this go.
> [...]
>
> >  	rmap_item->anon_vma = vma->anon_vma;
> > -	rmap_item->linear_page_index = linear_page_index(vma, rmap_item->address);
> > +	/* The VMA is always anon/MAP_PRIVATE-file backed so use anon index. */
> > +	rmap_item->linear_page_index = linear_anon_page_index(vma, rmap_item->address);
>
> You can drop this comment: It's an anon_vma + linear_page_index pair, so the
> anon_page_index is implied.

Ack will do.

>
> [...]
>
> >  	WRITE_ONCE(folio->mapping, (struct address_space *) anon_vma);
> > -	folio->index = linear_page_index(vma, address);
> > +	folio->index = linear_anon_page_index(vma, address);
>
>
> Apart from the LGTM.

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

