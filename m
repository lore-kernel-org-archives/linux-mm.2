Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2C5E64017
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 13:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8AAD6B00C5; Sun,  5 Apr 2026 09:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3B026B00C6; Sun,  5 Apr 2026 09:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A295D6B00C8; Sun,  5 Apr 2026 09:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90E9C6B00C5
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 09:35:05 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EE441A0900
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 13:35:05 +0000 (UTC)
X-FDA: 84624598170.21.F9D7EAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id ABF321C0006
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 13:35:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JsuR22bB;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775396103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZnLqiy0PDzfsPBn4zElMS+mzPT4ewPLQH6Ie9yANQk=;
	b=6gB66XJyMYu7LLRUuwPW5qE3yk1xrGMB5YDgb0EdbsQqRKR0ALb0eZeX/Z7TZ3YZItUJiD
	FZx+g5btjIwEYGwWPeEWE2qLxObmYXui4v08W7WaQrxdYPkKZ7sD3jZuroubSehucUYGn4
	eWSrWUKOq2zULMtofvcztauttK+3+c0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JsuR22bB;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775396103; a=rsa-sha256;
	cv=none;
	b=hLmSUrzImekGMe3kedE9R5QPVgoY0yeGLZNAU6mJyf///WEPTCIYtLupy5L0wiGOgrDBt9
	M7xgIJAMImBq6tw9sEptE6rwIHxWyac5lsDq+y1hUlKyVgUkbYY9UdVq6Ls2Sipr50HSjW
	ozfb+cTYT6pT3yNdRIWSfLZCvj7/mVE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B24FF6001A;
	Sun,  5 Apr 2026 13:35:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01887C116C6;
	Sun,  5 Apr 2026 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775396102;
	bh=WWuKH7V5NGGgAcGyGGVsYW3h6302QQpGr0/S5xsirPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JsuR22bBOjH3ft1M/WUeMEYQAF6hTu5hn2tzOUD3fMIgLiO98o1NHa9qvmyC0jTqW
	 sbe+mCcRvf+TA5onjzDvEDuf50nLBngm414f0zKX+a8LOQt0ODkU1gsw3Ocz0QRZ7h
	 7w3BsUG3WcylXg33DrqbyD0s94LPdvyCHXIsNddWSFPDM8WQqOKwwZBqpd6yI/1pVo
	 d4Trlon650nrHqNIoA+M9we70iiCUab6u+0TayT8VqdgXNAs33scs5kHK5as06c2CL
	 eJPPYetGQNp+OsrDK9Q3fQj5DZ7OK2esPexzi1MFaTcenmV438ealYjg5I5AWH9h5M
	 7cOqG8pKzar4Q==
Date: Sun, 5 Apr 2026 16:34:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/49] mm: Generalize vmemmap optimization for DAX and
 HugeTLB
Message-ID: <adJk_W5dA5YRcxOA@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ABF321C0006
X-Stat-Signature: hgsg8q5minpgdkaqdsf3r7wdrb3yifn7
X-Rspam-User: 
X-HE-Tag: 1775396103-642435
X-HE-Meta: U2FsdGVkX18bpMF6KCV8Gp0Ak7wCWjea9bQ5RWglOJKnjkiPOdwIjo/FJjC6jvO1uLeR/fQa/R7CRQ5eHC60Y4+Nk4oy9SvNBV528mx859xicnZZSspAYM2gPgFFxty/Ygpqj63WmgrPzJy+vo4Z9CCYWiVji5X1r6diuKBjxuKAM9gIkrgrliL8/izCXVSt8Q4BT3VvJ+/+lTUKp0pxvnIkq9d0dU18M2oy81piLu/zCEskYT2P56lYp6BB/tjNPgO9t0PdmNZ70Qd3CpSCfS2nDU/+5+SzLOcpVFWNIv5YmvnEOIZrJ2xpDpal08xPA7Uu+wbkZaRmXvM55xF6qvFvsVYBXNFjhA1H6l2okZ289+9kctVzxUCyvmVjNSeS6SvWNxvX9XL0KmVvNFvQxDpq28gdmM0gaIACUamWDIyXM2cELjSNTIHRO4hCLTouFIvbxf/nG3QPUCIRwqs0R1c2M9NhvnGvBuF9CMZP4PIBwYoEMuYyenyZqx9Rx9UhSkFsz4QiF+BgfaAckEmscmxIafo4m6R2mnQXkIYrU0s2M/eKoI8oYpbHDQBpSqVDkYwfdVXaH9cmJL0lE1EpFyfYDnRpyR9yYRliY14HWhOXF2hZPbPOecSX6JItu8YXI5WRqxxeDoqodwy8o77FtBUB3Q5ITIj32kzaRRU8GdENs9aK71x6lgrWbhDeq/v3Z4nvx2FFXXvxbM2l3XWtXeTiswj9Vi9pLfiRY3/2gJDQdqZ+7u2zj8vl1PqTuUEMa1Irj+HKgl7QLxDrw7zHRacKPvM9YATGZYZGXJbBoAFTOrWDVkneCYPPM+wxUDd4Nrnelrf9NGMJ6vhnGBwcOPYzN4CP7ryCtl+Z9ZisLBO3iRTDtoSNEQJNe6SxixBJ4mG4e+inj+iqJ/fPb7Cd2+mHJmL7lklmL10YlKkbV4VdRUIFiAPdKe5+jmnTl8CbREXgsbV+N9r8rq1ZczV
 rFR0RXFq
 C1KkRy2NlVueX7mSJVfg35vUhEBZafL3iziNfvY0sv2j9+P+8195AFd0Lg3Cu/KiG8YZTRHv/ArLLq8/QK5OGOUW0bsgh/EGZjLVGJZAFX2QQAGVkfHWv63w4pO1TsYH1ESBUOzSpmsZOGZAESZ4KhzwkUnI/QVqZaPrMClp5AtDTIGH9ozJ/HCgyNxqKbGsy9wG6pC7mQFnMmSmWKVbum8SXRKLOMnPDhD0GmJjTEZHojNf7rsWyDxVpkRt8EI/IZGoq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On Sun, Apr 05, 2026 at 08:51:51PM +0800, Muchun Song wrote:
> Overview:
> This patch series generalizes the HugeTLB Vmemmap Optimization (HVO)
> into a generic vmemmap optimization framework that can be used by both
> HugeTLB and DAX.
> 
> Background:
> Currently, the vmemmap optimization feature is highly coupled with
> HugeTLB. However, DAX also has similar requirements for optimizing vmemmap
> pages to save memory. The current implementation has separate vmemmap
> optimization paths for HugeTLB and DAX, leading to duplicated logic,
> complex initialization sequences, and architecture-specific flags.
> 
> Implementation:
> This series breaks down the optimization into a generic framework:
> - Patch 1-6: Fix bugs related to sparse vmemmap initialization and DAX.
> - Patch 7-13: Refactor the existing sparse vmemmap initialization.
> - Patch 14-26: Decouple the vmemmap optimization from HugeTLB and
>   introduce generic optimization macros and functions.
> - Patch 27-39: Switch HugeTLB and DAX to use the generic framework.
> - Patch 40-49: Clean up the old HVO-specific code and simplify it.
> 
> Benifit:
> - When CONFIG_DEFERRED_STRUCT_PAGE_INIT is disabled, all struct pages
>   utilizing HVO (HugeTLB Vmemmap Optimization) skip initialization in
>   memmap_init, significantly accelerating boot times.
> - All architectures supporting HVO benefit from the optimizations 
>   provided by SPARSEMEM_VMEMMAP_PREINIT without requiring 
>   architecture-specific adaptations.
> - Device DAX struct page savings are further improved, saving an 
>   additional 4KB of struct page memory for every 2MB huge page.
> - Vmemmap tail pages used for Device DAX shared mappings are changed 
>   from read-write to read-only, enhancing system security.
> - HugeTLB and Device DAX now share a unified vmemmap optimization 
>   framework, reducing long-term maintenance overhead.

This looks very interesting ...
 
>  32 files changed, 513 insertions(+), 1197 deletions(-)

... and nicely cleaning up things.

This series is high on my TODO list, but most likely I won't have time for
proper review until after -rc1.

-- 
Sincerely yours,
Mike.

