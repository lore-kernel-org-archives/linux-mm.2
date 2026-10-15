Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23B86CC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 08:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 336626B0095; Thu, 15 Oct 2026 04:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7686B00A0; Thu, 15 Oct 2026 04:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D68D6B00A1; Thu, 15 Oct 2026 04:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00A196B0095
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 04:37:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 783D3A0922
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:37:57 +0000 (UTC)
X-FDA: 85324207794.17.9129E62
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6840FC0002
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:37:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cprc7Jne;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792053475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8/WPUKZgvpFon73tY8pEvuDWGuU6a6DVXGoFvHaRSA=;
	b=5TQQRcXT2cV0m0b7xsanIfQMR8vXi0lbTTScqZ2Gu3VQBlISbIhAC6z+Cw+2cWIaxtbwP7
	3spdgcuWnJKUS2uAzLtEzyZqLDmythvpZgS5dnk1Y+c9fRsv1Tj9FcgCCu5WhErs+7WAaL
	g3WAjA6omIFGbviR+2/IYchE9f/736g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cprc7Jne;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792053475;
	b=071iNdNb1bWA1VrTf5U3DV5dMstXmROnYUhs31XVZCNljtWaQjZFYIfDgSeV0IM3Pht8B3
	ozQ3fppPiTuckxGkctWoW0ZtljvpSBl31kRao7YP4+I7BSTOow8SIrryPfu9rGCq11wkWB
	UesGUnKAfFLAc8Wga80Pui79noF1XcU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=J8/WPUKZgvpFon73tY8pEvuDWGuU6a6DVXGoFvHaRSA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792053474; v=1; x=1792658274;
 b=Cprc7JneowWM/4GOXkbzF+0Sbbc7i0Zu8iF5EdKQs6uRWI6H6Qac89fH4ZMifndex0qaMIqh
 1dtvl3G/1cjl3HEoYiMHtbl5PCsfLgSAC81tr3r7E4ST43qLiZZDSTd2fcgJXhEYEbcnCEgFrkP
 ndB/vfnT7av2kthqfpClU0rA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9f4aca14d8d7e350;
	Thu, 15 Oct 2026 08:37:54 +0000
X-Mizu-Trace-ID: 9f4aca14d8d7e350
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH] mm/userfaultfd: only allocate anon_vma in CoW mappings
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
Date: Thu, 15 Oct 2026 16:37:39 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Peter Xu <peterx@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Lokesh Gidra <lokeshgidra@google.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Kyle Zeng <kylebot@openai.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <89E8831F-8877-48ED-A2DF-5128DEEF8C43@linux.dev>
References: <20261014-copy_hugetlb_page_range-v1-1-5b68e03fe7fe@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 6840FC0002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 5c6in7bni6rcoz5txdyutys7wugbqxnw
X-HE-Tag: 1792053475-33851
X-HE-Meta: U2FsdGVkX192ikQrQZCdMZkJySWIu8riNV5SFVlq03DH2oJgRKBCU4xFA5GkCE0FIq8ANwh9DnpttPKiZcY2VJeD3lf2lqyCBwFlB3oD5e5fPCCaKg3klF4xWc262zHAA7ULCn4Fu1yb9x1d9+4n4Fv/xOScCYdegQ/OLlk832JpI55W28+jhXhJom5kLUb4mWVjj80082Sss6XcpKmtV/61qW31fuvLpeCBYB5FqjZUPFYwhXFm8d6vBK7JNmLGH7T7Kg6bYf2sFdmZr13ONRkFs95nQ47Logv5EIatto3AHLity5oL3h8gT8CsrbptQ4K0/i2wHrvEsTvVIdVQzkNUn3vxSQHXcSo0ketJZkqyyfOcdefjfvngdGrGw4vac5Ubt+L3WQ9RplVzsgrAdIsDk50HiYviWahA1nZRdJ+EUFQa/TEbS1QIQ8vva+lDcjq1G2ds40Szd26X4E6ztYQbuP9tBjNMlpmRd2lOmDhk4FWTy5mvP8xXrp5rtlDUM5FmvIPyMlAf4aIxdWWJkbB8MhGjEarX9k0yk2UBMUHrwrKZk1fqasAO5vqmeJ3bYPSSNfepe9RxCRD0XznNtQRtPfacspxSmU168ISRgBb1h0PPOgJnKTLpqHdRpuz8a5m6DlIZ6kVKpdGQWa+XShMn9xUglCwXTu7lAk4uTezoVNIC7SqLFa3kHgWLuuYH8Eikn2BfW4bh20THOnCCKXHvypHTRX9nbEzNqV937+Ra0w/q35m/s10KsaXtThS3WCG6d9/3KqzN/8Oh7ThblfxDnaakP0Ot5X5nv4kwuVctdFrnVIJCwLEamupqzZUsuOGeKf36wR3I8+1KmyvoRHjFmOejfoDrLNkdR9PeTiRu2/IIR+bam0ob15vuwe3KugEEL9uobUhbH0emVBhIEOd3A7p2UBKgCaJpRAS4vKpj/lKNphvauZ/TviezmY5BsU2w+GvBrlhxPKnuc+q
 KVnwQuy1
 B661MHfq7MfYqkM6bMZ0pllwgzjFniMS1JRMMxsNGOfdZOWYGp0xmUywCnJyCuLR5iy7owg0iV2Di8nZDKHLSgulHTmB1O4jX4gxnAGpK297XU575u0foJluNeyhuH0ZSchWZY7+pw4B+8/MJLAsfndf8Nn5EpOqJZb93STSIcuBRVXFSjmfk04MEUHLw2MzvVvi46bNUOO6g4ios65DvjGYNnG1dRL+QJIPBqm4xBA/A5K55kOlxvX8EcRB276VcdZy0VqzYgBueYwLG/pxra+pij7OnkJY0QNt9ilibl8RdtZZTInB+qDpROgrGgAvTXPqOkJcf4/7NGlKf3q4apNpaew/knh7dzsKmvExXa5Yljdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 14, 2026, at 19:53, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> find_vma_and_prepare_anon() can end up allocating an anon_vma in VMAs =
that
> are not CoW mappings, which is wrong.
>=20
> If we have a MAP_SHARED R/O file mapped, we lack VM_SHARED (but do =
have
> VM_MAYSHARE) and lack VM_MAYWRITE.
>=20
> While uffd later rejects such mappings (uffd registration requires
> VM_MAYWRITE, see comment in validate_dst_vma) =
find_vma_and_prepare_anon()
> still wrongly allocates an anon vma before it validates the vma.
>=20
> This in turn later confuses copy_page_range()->vma_needs_copy() such
> that we end up calling copy_hugetlb_page_range() with ranges that
> actually do not contain *any* per-pagetable information that would
> require copying, which is the basis for PMD-table sharing in the first
> place.
>=20
> copy_hugetlb_page_range() should not have to worry about shared
> PMD tables at all: it doesn't make any sense to copy page tables that =
are
> shared, as they can be fully recreated later. Ending up in the =
function
> with shareable page tables is the real issue.
>=20
> If a destination PMD table is shared in copy_hugetlb_page_range(), it
> might get concurrently unshared as we are not holding relevant
> locks, resulting in us using a page table that is no longer mapped and
> possibly freed after calling:
>=20
> dst_pte =3D huge_pte_alloc(dst, dst_vma, addr, sz);
>=20
> To fix it, do not allocate an anon_vma in non-CoW mappings and add a
> safety guard to copy_hugetlb_page_range(), making sure that we never
> end up messing with shared PMD tables in there.
>=20
> Before commit 867a43a34ff8a ("userfaultfd: use per-vma locks in =
userfaultfd
> operations") we would always validate the VMA before allocating an
> anon_vma, and consequently never wrongly allocate an anon_vma.
>=20
> As uffd_lock_vma() is part of the same lookup machinery and
> also contains a misleading VM_SHARED check, change that one as well
> directly for consistency.
>=20
> A follow-up cleanup will stop taking the =
hugetlb_vma_lock_read(src_vma)
> lock in copy_hugetlb_page_range() entirely. Further, the usage of
> VM_SHARED in userfaultfd code should be cleaned up later to focus on
> CoW vs. non-CoW mappings.
>=20
> Reported-by: Kyle Zeng <kylebot@openai.com>
> Fixes: 867a43a34ff8a ("userfaultfd: use per-vma locks in userfaultfd =
operations")
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


