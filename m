Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1485606A33A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTdaO141
Received: by kanga.kvack.org (Postfix)
	id CEF336B05B1; Wed, 18 Nov 2026 09:27:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9FF16B05B4; Wed, 18 Nov 2026 09:27:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69386B05BD; Wed, 18 Nov 2026 09:27:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 981796B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:27:51 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 845391C41B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:27:50 +0000 (UTC)
X-FDA: 85448468700.25.7114E4D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E12C31C0009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:27:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTdaO141;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795012069;
	b=mvcpCTPsQSTzws9wAP2UvScbdFj1rtCH1DfsvU0q44Xv6531AylS6EdtLhTenEIvUsJHi7
	qULblv1NQmUz3VjdTOTx5bdufN8BQ37A6bsydtjZNmezignlf6JfZFNOFsWISNApfgCgmu
	iP4U4LPsGAvHJ/RPWJS1/faA8pV6Bgg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795012069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IrpiBrM7liH8MKiWPu8fuzT5T22D0j2HTUUXtUQY1FQ=;
	b=Ifms47MJky7/OSClbVAB1ElMQmN544YhmnDT2o96ClWXYmkG0vJtjTcdp1B5bpfyDOlBjj
	5BC+lY/wJUOOPaSt6k+rr6DW/PfIwIhuEnUsJaX5X+T2V4xXnw7IkRg3z1CiHJ0lVfi9c8
	X0ZsDotu1MEeM5xmw1lPEcQ6bMELWJA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fTdaO141;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D2876228F;
	Wed, 18 Nov 2026 14:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BDB1F000C5;
	Wed, 18 Nov 2026 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795012068;
	bh=IrpiBrM7liH8MKiWPu8fuzT5T22D0j2HTUUXtUQY1FQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fTdaO141iKava4U02bGsRcWshGkeb9ovgA4WkCWpAKecLl5TZxk0dnh8ZaYWicMfZ
	 tpbO0jgTXFuMb9gqtXs1H3JL505BuGEObSktbtHlRonX1W+CnBnXBsQQKdpF5NjgxT
	 4BLOudDQw+d5Ihmvy3SgJD22ccc1D3xe910LaQOMSsqSvecT0uhV/Tkh3KO0Mrpigx
	 Cq2MLRMR4vv3b0hfX8qa4KKZ1bLLx8uheVq4Jih0emKGKUSl+e1/MTBWVuvnv5z7zL
	 VbyQG7yDGok9QASvRPGIMJzdLQXa6NbzFfnflirjCDTg4o/9IjvADxQgGNfz8dNXlE
	 QdB9MSGP5/qNg==
Date: Wed, 18 Nov 2026 14:27:41 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Jingyi Sun <1045704958@qq.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Michal Hocko <mhocko@suse.com>, Muhammad Usama Anjum <usama.anjum@arm.com>, 
	Peter Xu <peterx@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nvdimm@lists.linux.dev
Subject: Re: [PATCH 3/3] mm/memory: don't upgrade non-present PTEs in
 insert_page_into_pte_locked()
Message-ID: <av21s_WAXAzEtLyX@gremlin>
References: <20261117-uffd-dax-async-wp-fix-v1-0-c9a30f27f452@kernel.org>
 <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-dax-async-wp-fix-v1-3-c9a30f27f452@kernel.org>
X-Rspamd-Queue-Id: E12C31C0009
X-Rspam-User:
X-Stat-Signature: kd7y6k6zdemjkujzd615dd9cgg4kegf6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795012068-144183
X-HE-Meta: U2FsdGVkX1/rR8tVKP9KrIlFNLAjt9bX+4pE8XNoPD55UrZH60t4McqYIunXJYnmZ3t0hckGtuNWvuqiyBin31iCquqTzqlvgm5aIBEkK09AGxBrUy8gUt3eiwpCZFx1E5xk+zHunMQelAErmZSnrJijG9DaMuAKhVly5QSqyECHHo3QgRIyU7CgvkTXGyNMkwg4x0BtKADInOO5gsNFnVgex/EPno/dB0y08WzdLn6c1VdkvkuDViuN8L+om1uUYDsZGO7MeqvNyjkaC4/vffd+0XtC65VA0/DQyPUY6kfiLzs9hh4gUnozdu2IAuZwwKBSCR8m1UOweCpWryE/RfIcXIg0R3HqE8UMzOarH9GTXCFt+spB84lAlokcYpl8i3URvEePV36/g96TegKHTcEjEGSJJ8TvX7DFnbY5g+HXnbiSghZvPnOyiTaGn0SpPlcbTa03jY0DdsZ64FSvD3oHWxm47eU8DTBzEQf/AkqFGJ0N5d8pyK3kShDf0Nu4SLfvjUrtQ1WfnNG0cSpnC6rdMGlxbCKt5BU6C//BjQwnS+CKKMkB6Be9uHO39+nEySH5RnYyukzFu3Ttel6di0xob7BVJvl1Iwt2wG8VDCYdy32LFGCqbA8DLLH04N3dJcd+xTQg+4Cmd4NIjVCkLcRKzqbZVWNpSaXkCWGYgWucREMOAPjblapc7o/5NSSwSLv1QLQObqU6NmeVd0LCdHdA53lFm5ikhojY2wb/ssKqAyWM8mYstoAK+tsh79l6k7WIE6fi2zHfU3wdCi3TXCTqr/BPf6IHbBUpPUtMCl6mo6iAXOQR7VA/9uqjkD6C9q/1yLVd9czwb9iDFlnUqXGbCeHIU4HKRk4W8+6Fqa0bbzNBu+b4xakD1AhEZPDwkrSMB8cgMipEIKJYP1wnWdSqPoWMBDbgJn428Ar/zQY/mygYfaL21BXDrIQkHSMV2VNOh0dab94W1rBxoAs
 szaV7l8c
 wBx/ZpZagGF0ja+UW5EPqbdIykD0GQivmAkStZfNV3LpTAAFWezv/INFLLWy3eXoj5i5/qpiY99XULvbGbzh+aSotH1ItvKRnQXOhs8vR+SgoGll68VRFaX4114CbsMKH+JRuVEPl1b3LAwGkG5DGD9qvgaDNDu/Te15VpZF/dwIjWT7cutv4l9y5FXENNfT50YX7cG5VltB5uvbf813OtdASiDK9pEakPEddxVQE8rFfEGAnPfR/MubuwCXt6D5gIIWMezdXCAvRTtnFqsvr/uWNZ6S2OPjjK2RrxNqJYvCwvxtG6iVFNFqu6T2U3PhtKEe+4nGRh7nqVZvdAG4YbwzTMKqTkAvDIxMqaMbKH58KfmkIiK2Lq1z7ydNVW9qbtmgiRUhMIpvIaOBBxrx8VD+M/HJ9h7j9UpQzhvvpqw3ZfSzyEhlbwBRT+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 05:58:34PM +0200, Mike Rapoport (Microsoft) wrote:
> On a write fault insert_page_into_pte_locked() assumes that a non-empty PTE
> maps a page, compares its PFN with the page being inserted and upgrades
> the PTE to writable.
>
> Since guard regions are allowed in file-backed mappings,
> MADV_GUARD_INSTALL can put a guard marker into a PTE of a DAX mapping
> after the DAX fault handler found that PTE empty and before it inserts
> the page.
>
> vmf_insert_page_mkwrite() then extracts a PFN from the marker, hits the
> WARN_ON_ONCE() and fails the fault with SIGBUS instead of the SIGSEGV
> expected on access to a guard region:
>
>   WARNING: mm/memory.c:2489 at insert_page_into_pte_locked+0x47e/0x490, CPU#3: guard-race/157
>   RIP: 0010:insert_page_into_pte_locked+0x47e/0x490
>   Call Trace:
>    <TASK>
>    insert_page+0x6f/0xc0
>    vmf_insert_page_mkwrite+0x31/0x60
>    dax_fault_iter+0x3be/0x5f0
>    dax_iomap_pte_fault+0x1b8/0x390
>    ext4_dax_huge_fault+0x1a4/0x2f0
>    __do_fault+0x34/0xc0
>    do_fault+0x179/0x610
>    __handle_mm_fault+0x8ca/0x1250
>    handle_mm_fault+0xb4/0x290
>    do_user_addr_fault+0x15f/0x730
>    exc_page_fault+0x83/0x190
>    asm_exc_page_fault+0x26/0x30
>
> Return -EBUSY for non-present PTEs on write faults like it's done for read
> faults, so that the fault is retried and handle_pte_marker() deals with
> the marker.
>
> Fixes: f807123d578d ("mm: allow guard regions in file-backed and read-only mappings")
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Seems similar to some of my recent work :) what a hive of alien facehuggers
insert_page() and friends are...

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 66ad58429967..a80925c61706 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2474,7 +2474,7 @@ static int insert_page_into_pte_locked(struct vm_area_struct *vma, pte_t *pte,
>  		return 0;
>  	}
>
> -	if (!mkwrite)
> +	if (!mkwrite || !pte_present(pteval))
>  		return -EBUSY;
>
>  	/*
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

