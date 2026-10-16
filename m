Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EBE9CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 09:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526376B008C; Fri, 16 Oct 2026 05:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF826B0092; Fri, 16 Oct 2026 05:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397156B0095; Fri, 16 Oct 2026 05:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 13EC76B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 05:50:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 827EC140263
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:49:58 +0000 (UTC)
X-FDA: 85328018076.01.CC6EA48
Received: from mta1.migadu.com (out-252.mta1.migadu.com [95.215.58.252])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6261DC0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 09:49:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cP8evNw9;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792144196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSApHwyzEVdqPFNQhIuV3PUIPgNeW9IbBah/kIyzaWE=;
	b=mOShgegAKSmluGz/wvkhkpWSLwHsE7akwpbU+jf2xcDYdHsfrfafrtbZGUuJz0TGnTBlv3
	fonszUTttF6sWYs3PvICeWFyS0FtOncE3CyXM7lmCbC9flH5S6BtAtzBt4OWw3aLZmoQqG
	XbvXYd6zGvQZ8s4w02yL+gS6Ut+LtQE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792144196;
	b=QqUVq1s4xOaFPcB1PlCsa+zuLDAnVpe4TtJwO89FDauyc86B4quzHz+NuhrYDDvVWB4fGa
	UawkV4h6pfx9EjVmsNeLoKUUfG55C+/o145mIn3ej4FcwOZh9P38VtUrWqzjqwumwMe8FJ
	apl++fDNp8H1AT6CPDbHzy+askeyQSE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cP8evNw9;
	spf=pass (imf28.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.252 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=W4HZiu6j/Fq+Mee4Nsti7eqNIF7myNqYt9HBvlfMVI8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792144194; v=1; x=1792748994;
 b=cP8evNw9fEiqcVbs73gA+44NHIPMRHIyeMGW3C38L4FSGSudrXAt4RJMvXp0EQXO90oYRiSI
 xbHnooH2CtTT8XAF37T3cUkx5AbS0lDfrUvo4/MAa/eV5j4YnD4gKrlFHexDf/0U66HyWTvBiqc
 iRt17m0WsF6OQhU5k1CeAxgg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c8ab28ede6a5f938;
	Fri, 16 Oct 2026 09:49:54 +0000
X-Mizu-Trace-ID: c8ab28ede6a5f938
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 04/10] mm/hugetlb: unmap the page where the other VMA maps
 it
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261015-urgent_fixes-v1-4-42796911043b@kernel.org>
Date: Fri, 16 Oct 2026 17:49:37 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Adam Litke <agl@us.ibm.com>,
 Mel Gorman <mel@csn.ul.ie>,
 Rik van Riel <riel@surriel.com>,
 Peter Xu <peterx@redhat.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Josef Bacik <josef@toxicpanda.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <BAB2117B-1197-4D6C-953B-31F9C33BDD42@linux.dev>
References: <20261015-urgent_fixes-v1-0-42796911043b@kernel.org>
 <20261015-urgent_fixes-v1-4-42796911043b@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6261DC0004
X-Stat-Signature: 3r9qjrzhnwycemzs859mze5tt66hgg85
X-HE-Tag: 1792144196-37293
X-HE-Meta: U2FsdGVkX1+9MVeJbf/IOzEsf1O3337tA5XI7ROvJmEI3sutczz5Dhdlw3PnhRkJnuqvRXJTXbvtLQIh9wiOvbu5q7MZ8AYbakw+J7xL/pmmJuaT9BvWuDV0IbLutx2/JyOzB240OWXJljUGApou6TRoAbZvYQ11BtS8zoJlB3sLG9vwajTRfzo3LCMURBaOTiouIE8qvT+FVomBr9TDairmAZmg29pnD+5QXm9dEB2t4wvZ+RKQC4/OHRmmbnM0lIGyl/jmDPjVckEeIqZMWaDbih7I9CveOy9+LQr9WLFLqzBpACcOMiK4VQyWE5Wi10NEUaDGtJAG3Fa4UpIMdAS731EXRTHI5rSlsPF3U8XcISH1b459cJx05z2guUuvohnIskqbexXY9ZHzPq6upr+nVwENJYlPCYPnhdKkWGjrOTXvFceDlS78EBOBVs4njd4QQaKdPJ5ujFiuJJ/lECc9syZNemJtf2LXBQi6nHXulsDd9mB8EbGGl9mow3e3LoWE80w/wuODrNxCUEDhW5hYhNX9lXhxg5EwN44fIXk+0t0bNdM0ztHHwRAs6ptwChagnBrrSiUoeuyRHk6aMK89HduNnc1onLRRCvOPWLCCqnki6H52v1u8ra9pRRePOzeVFA//C+u4Yg0lDNzqIYBMYwiapoA0v1uKWvmQtJbab9l0hfk9BssGZ/pTgAV98l+kf2MLErUF5kwFYt7kxDCWN0Mpw8tvjY0v7RWJUPiS2YCOyfR4bz6eHdIKdAhf9Szxbl4lHnXFK1JbACCBpnM1kryJt5UQ1utFevaLk60jGdZyN9m7OWVOF2Gaa8j3I2+gGviDnZxbU8dg2duP+eftRyteYztSTWzqt37L5OULA7RbGMJTsaTP7OtlJr1BCCjPBGwbQ3whzj8CKA5v57EnJ64SO/T/rNSU/KMqCPrgLWG7e1QpOER0+FAIrhvG9ra5S8KmKbOTaqxPIE9
 JNPhR7ZV
 xbApJaPXRMjtUt9bDeQ/ty0Xm9VCG2fcq8BZI+dvE3TCWqjfiLwoMgO4ebZHjl33D2KcW1/lVH4xfVuMBevL0qljpF+Bf1vhE8vkADJhr7DM+M75QAqC71mlFwtcU2uHdIk9aS+FcHT8QBD6QUiBTP3CSj+MWnZwsxZPVx4r9nzqBcpcLjgvZHDED+sicdvueP0+MGzX58WFf7ypmNBvGa4TDW7KQ2ecpJF/BRR2B+fUOjMhJEmAyKIh/QDgHmTxTHAOBYEPdpuwFhjrWPoJYnSN25v2k2cx1cEfJQsbrk5B4+x1UWBgd1e2tiY0yR4od0DXzdpGSS8LmeTZ4hO5Fm5NOva54xqCGgrIk5IoRGO++ZvM5Qb8t34dL1xTQhNcKFrzRnTHUgi0BpWPHDvbIpv7e7Sp3NleenvkoaXEIpuptqFl5XxCE1elZt6JsqYRKV0ntwze0nu5JDfZtYlxjqO03Wc7w1rTkEtQdacGUAyT8b1IJx4Psk/qV7PRd2wYM+Y54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 16, 2026, at 00:07, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> From: Josef Bacik <josef@toxicpanda.com>
>=20
> If the owner of a MAP_PRIVATE hugetlb mapping fails to allocate a page
> for CoW, unmap_ref_private() unmaps the old page from all other =
private
> VMAs that have no reservation of their own.  It finds them by the =
offset
> in the file, but then zaps each of them at the address of the faulting
> VMA.  Nothing says that another VMA maps the offset at that address: a
> child can have moved its copy of the VMA with mremap(), and a second
> mapping of the file is wherever mmap() has put it.
>=20
> So __unmap_hugepage_range() walks the page tables of the other mm at =
an
> address outside of iter_vma, where i_mmap_rwsem of this file protects
> nothing and where anything can be mapped, and the page stays mapped =
where
> it really is.
>=20
> All of the following was seen on v7.3-rc6+ (g6c377d19d4a5) in KVM =
guests,
> as a user without any privilege.  It takes a pool of 2 MiB pages with =
no
> free page that is not reserved, so that the allocation fails: the user
> can take or reserve what is free itself.
>=20
> - The child moves its VMA away.  The page is never unmapped, the
>   mapcount stays 2, and the owner goes round retry_avoidcopy in
>   hugetlb_wp() until the child is gone or a page becomes free.  =
SIGKILL
>   to the owner does not end it.  5 of 5 runs.
>=20
> - The owner's mm has a second private mapping of the offset, made with
>   MAP_NORESERVE.  The owner zaps its own entry and reads zeroes where
>   its data was.  5 of 5 runs.
>=20
> - The child moves its VMA away and maps a 1 GiB hugetlb page at the =
old
>   address, so this one takes a pool with a 1 GiB page as well.
>   huge_pte_offset() for the 2 MiB size steps through the PUD
>   leaf, so the "PMD table" is the 1 GiB page itself and its "page =
table
>   lock" is folio->private of that page, which holds 2.  Kernels with
>   lock debugging oops in __unmap_hugepage_range(), 7 of 7 runs.  =
Others
>   spin on that word for ever with preemption disabled, 5 of 5 runs:
>=20
>     watchdog: BUG: soft lockup - CPU#0 stuck for 26s! [u_det3:130]
>     RIP: 0010:queued_spin_lock_slowpath+0x8a/0x290
>     RAX: 0000000000000002 RBX: ffffea0001000028
>     Call Trace:
>      __unmap_hugepage_range+0x154/0x6d0
>      unmap_hugepage_range+0xc1/0x140
>      hugetlb_wp+0x55c/0x700
>      hugetlb_fault+0x5f3/0x8f0
>=20
>   RCU stalls follow, and killing all tasks of the user changes =
nothing.
>   Four such owners, whose children share a single 1 GiB page, took =
down
>   the whole guest with its four CPUs, 2 of 2 runs: one reported soft
>   lockups on all four, the other gave no sign of life any more.
>=20
>   i_mmap_rwsem stays write locked.  With a MAP_PRIVATE mapping of a
>   hugetlbfs file that belongs to another user, and that the attacker
>   can only read, the next mmap() of that file by its owner sleeps
>   uninterruptibly in __mmap_region(), 4 of 4 runs.
>=20
> Compute the address from the offset for each VMA.  The tree walk =
returns
> only VMAs that cover pgoff, and vm_start, vm_end and vm_pgoff of a =
hugetlb
> VMA are aligned to the huge page size, as pgoff is, so the whole range
> lies inside iter_vma.  Its page tables can not go away there, since =
the
> VMA is unlinked from the file under i_mmap_rwsem first.
>=20
> With the right address the page is unmapped from all VMAs but the
> owner's, so the retry in hugetlb_wp() finds a mapcount of 1 and reuses =
the
> page.
>=20
> A child that has moved its copy of the VMA now loses the page, and =
gets
> SIGBUS when it faults on a missing page of that VMA.  That is what the
> comment above the function has always promised to those who do not own
> the reservation, and what already happens to a child that has left the
> VMA in place.
>=20
> The address has been wrong from the start, and the second case needs
> only mmap() and fork().  mremap() of hugetlb VMAs, which the other =
cases
> use, came with commit 550a7d60bd5e ("mm, hugepages: add mremap() =
support
> for hugepage backed vma") in v5.16.
>=20
> Original fix generated by an LLM and sent in private by Josef.
>=20
> Fixes: 04f2cbe35699 ("hugetlb: guarantee that COW faults for a process =
that called mmap(MAP_PRIVATE) on hugetlbfs will succeed")
> Reported-by: Chris Mason <mason@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: switch to vma_filebacked_address, add VM_WARN_ON_ONCE, refine =
comments]
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


