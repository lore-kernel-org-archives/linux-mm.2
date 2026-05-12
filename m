Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3CACD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54A8B6B0005; Tue, 12 May 2026 13:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB6D6B0088; Tue, 12 May 2026 13:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411906B008C; Tue, 12 May 2026 13:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 317616B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:01:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCA6D4056B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:01:13 +0000 (UTC)
X-FDA: 84759383226.17.D5C0517
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id E9E52C0020
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:01:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sReN+8sz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/ZaXAa4omzQrICrioX8p8nQwikDyBUajceOecSH9iM=;
	b=01EAqeweDmFHBRE7HIyebBy8dwbo7O6hfMOc4NBB61BlmOOes7wOHAcZg9c4okhW/FpHvM
	aGDubwE6CHMbNTvdj5Y/Xtu+PymiMpFRjpTWi0AYZb2KAtshSfszz7A/hUlHYrP2Soyvj9
	P3X27GxBrTLNQy1u4AJ5U5PofylYAuw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605272; a=rsa-sha256;
	cv=none;
	b=gSI8u1H8MO/WUXAH9rFF4H6Q2s+PCvDMxLCa8zGJWfX+l4Z4RRHPZLwWDHEecR5ndy1oQY
	VRLuZkfzQZo2BJmILpvli58mDnv4AOJr9FExc+eOoLiJUFxeznHpF/vXy/+5PXnRcBI50C
	WXlANcjTWMA12m+BckfDJL2aa+Quq6Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sReN+8sz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E48BF4060F;
	Tue, 12 May 2026 17:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D66C2BCB0;
	Tue, 12 May 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605270;
	bh=DtlyNiMrzWusjB1ZJ021vGTLZ2HqkR9/Z/A1b8oXmgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sReN+8szSUR0SdVUx+BPZZp6hbx/FJdb5E/n17whXNc8v21K2GEzYJYVCoMGNYXVM
	 Nf6C4YAOyhFhxHJaeem/Vja3XOhGyKm/p/U+iE6txnRmvOOcPtXVZhVeE2Z3RjJZAR
	 wDhqq5sqxAeVGNpdlYhGs9xR4iay1KE3bK8X2fKyT0zJZDLh3gcBiC8sEuN9xheKT1
	 zZaOU+Qo98ajxpv6pxDoXFtFQ/5vcUN/UDI1S7UpuB4jqx/+tFPzSBazqdAcLefJsG
	 lyvdB4elld7Y/3AQ+vlBxaFTNGGAaYEKzkTwvIpq18BQ401Sk4t0k/mWrSfVA4JGkv
	 4+He74wa4NfRg==
Date: Tue, 12 May 2026 20:00:59 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org,
	ljs@kernel.org, surenb@google.com, vbabka@kernel.org,
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net,
	skhan@linuxfoundation.org, seanjc@google.com, pbonzini@redhat.com,
	jthoughton@google.com, aarcange@redhat.com, sj@kernel.org,
	usama.arif@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, kvm@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 07/14] mm: handle VM_UFFD_RWP in khugepaged, rmap, and
 GUP
Message-ID: <agNcywWC3bnZiSHX@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
 <c88e78ffb2cc5ca81f5a6319b7e3c4ffd8baefe1.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c88e78ffb2cc5ca81f5a6319b7e3c4ffd8baefe1.1778254670.git.kas@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E9E52C0020
X-Stat-Signature: 8rqaxcyphc1f75zxggq1zefwa3dutr9n
X-Rspam-User: 
X-HE-Tag: 1778605271-638691
X-HE-Meta: U2FsdGVkX18UerNiLCvuj2v230GICdFyB2MsATq/EeFOVCCiYLBVK+BQO6hJNnqnULgC3sEYk3p3J/16sKMNWE+6yRCJXp+KGQBK/25JkO/olI5NtNgaKs5suHsAjRq1il15JWaTaBFjww5cgTr2BVjDnQMVhWSuvQaAOI3V7/NQO+t1k1uv4oasd8sO8rRtI5UAcBJe/gK/zuW0plQw2P136okqs743vH9WR6Rs8uKypy3BxZplPi1vF26eY33qTE2PvC+rVUhDn+SkVQRH/1t8crhqL4hdl50MpzliMR3chm37koPnWe7WQWnS3jvAp/hUxoI0fYk/ibfUJi0TIMNg+K+5sWHlE8hVjYKpZyjdPgh5jE8GMN7B++fAYa8YRNFbxeQ/5DZrH50LtdtKYzMvhUBfD/6GAhGqvKoAj+K+PJanifdAPuqN6BSEY5k6xNYZpS77Wl2oCZ0ANgPqX/DvIbXNuKo6jqKePjxSzN1745HZJBosVnlTcPyY83quXYixxBLkxGDRB3AkGNxQ4Qz5T1kJDV94EmDpj3j4enqmLfNce9j6dH9q8Gpz8h+ivPWbKvYYGQ92nMRqiJgwaBJ3EARXH0pONygslIW7MUnK/KabcUXGOxoDAEgLiMsVBYHdlbnO7gi88CAa7pEXY34SJPvySU2mAvfCHChonjs8xsz5lUcyOymmXRa8zMP7QCMjClpA+sv5hCC9JOF8ZR7l0qDDyCcPbd/cxG6Em3EL6nHQHPXnLyZhDyo57gLCIavuZ0kDL8qJYom9dPHXDCIHkDU7i6eHvCsxKCi85YnYk5ro/75dE8xwNELieSA0VEcHMFX9WFtet+e17o8PMpwOmkplizw/zIdw6bFMfPqZfMi8H92cJH/kMZ2ijTjbamooOWpuaos/QDz0h6mTl3vcmNiYAp7Y4So0w3GzEZzvAce43yE5Ij2Jm8dYBZkXxftRrINVZlGq81Lxck/
 cM/yUEYI
 Y0cpDxqzDdu9zWN6ImytH03U7RJ327BfP9QH+CRPMP6IbA1/kxkrSc2HrJ/ZiK+bpqcd3LqriRpzKHP56+zZ5EDGnvio30f7cLMgk0gt7PxpaEkn0oT61jkW/GlpBSjrZRvO8Fox8A3Dg0BR1reLv8qMNCATqpvuod3JfhgumEXcM/hk5Jy2FHxeCuNejLTOilMMtVflyZKO7PFFjGHyl36a66nHPr1duRr3b30dCpYxVr7/xEH7O8ySAD+ZZxU4U/0Qiu6noRYhpkPOGMkj1ABCLXxmn/FDrn9cuQtCidmGx/n4GFFeByWkcZG/UmbhcRdXsQ4wmv6Z5XuJ9EwYV+cIwBl05uDlX30HX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 08, 2026 at 04:55:19PM +0100, Kiryl Shutsemau (Meta) wrote:
> Three mm paths outside the fault handler gate on the uffd PTE bit
> today: khugepaged (skip collapse on ranges carrying markers), rmap
> (cap unmap batching), and GUP (force a fault through
> gup_can_follow_protnone). Extend each to treat VM_UFFD_RWP the same
> as VM_UFFD_WP; otherwise per-PTE RWP state is silently destroyed or
> bypassed.
> 
> khugepaged: try_collapse_pte_mapped_thp() and
> file_backed_vma_is_retractable() already refuse to collapse or
> retract page tables on ranges carrying the uffd PTE bit. Broaden the
> VMA predicate from userfaultfd_wp() to userfaultfd_protected() so
> VM_UFFD_RWP ranges get the same protection. hpage_collapse_scan_pmd()
> needs no change — its existing pte_uffd() check already catches an
> RWP PTE because it carries the uffd bit.
> 
> rmap: folio_unmap_pte_batch() caps batching at 1 for VM_UFFD_RWP so
> the restore path handles each PTE with its own marker.
> 
> GUP: gup_can_follow_protnone() forces a fault on VM_UFFD_RWP VMAs
> regardless of FOLL_HONOR_NUMA_FAULT. RWP uses protnone as an
> access-tracking marker, not for NUMA hinting, so any GUP — read or
> write — must go through the userfaultfd fault path.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Assisted-by: Claude:claude-opus-4-6

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h | 10 +++++++++-
>  mm/khugepaged.c    | 18 +++++++++++-------
>  mm/rmap.c          |  2 +-
>  3 files changed, 21 insertions(+), 9 deletions(-)

-- 
Sincerely yours,
Mike.

