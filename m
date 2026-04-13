Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D0AEBFD26
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 10:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E5296B0089; Mon, 13 Apr 2026 06:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD3F6B008A; Mon, 13 Apr 2026 06:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FA176B0092; Mon, 13 Apr 2026 06:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D21F6B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 06:16:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C213D16012B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:16:02 +0000 (UTC)
X-FDA: 84653126964.13.1AC4477
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3540140011
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:16:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sG2pVL/U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776075361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuFQIgG1KseDJR5PWlXBCj1emgHhygz7evidSm+1UWk=;
	b=oRQuFkUUG/jPF6P9IWMnztwF0Y4zjfoRUZT00Xw6J7F81N3mnFnAJUatEkeX5D+KuX5T9d
	YvUrUnWv1ZgUsLbkXkSP5x/uVRxIFr7kyIJ7pafLM3ry9qBQr9a/cn9K6U+bOXhbEGHnyv
	ZHV7MtZi5iSR1F+jzDkA90OZrE6vdQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776075361; a=rsa-sha256;
	cv=none;
	b=fhdHZwbt6+MNzwSnXz7888AGqIKb/G/E1HOkNG6cOaNP4PtTsfTYGplNv6yeZidgkNp65L
	QChgfQM5+xmEOiQwLhFfV67iBELSqlmndfBu+SYr36ZYMsGIDJ9SiR2rQh3r65J8oHQED3
	n5BeVMv3A+NKDPpPRG/vPFGMFctsvZ8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="sG2pVL/U";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E9876133C;
	Mon, 13 Apr 2026 10:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2B5C116C6;
	Mon, 13 Apr 2026 10:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776075360;
	bh=WuSoh5LS4xEsI7eAfjQ1JQLSBktdnQPu5LABtmynld8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sG2pVL/Uz5VVlNmWIjXT0VVHqNFEJ0amY1aaP6qDrMaoR4TyJSLJ7glczjeoJnOow
	 W89+4RsdWz3Ue/Lq3azXF/53srogqmzVxm9FJ9ZD3+d0JE2EjPVY1argx9UxXzT+uG
	 2SN8794oRdeBLLVozj2w6t9sQGr3B9EyHrrvpZyFManGVrxaFFqRy82vOHb+VssNOo
	 aEqHsRClM6mVrlYsoQUbdEgcfiWcA5IYb2J9j2cBeKQvEYHXCHKEoeO+Lmixe5PAch
	 a0vLaWLkLvYzCVvZBio2CDGohQaFp98NkJD09RlFcvua1D1OdF0m0+w3Keaw2oASEi
	 jDxG0Kcqc/0FQ==
Date: Mon, 13 Apr 2026 13:15:49 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Nico Pache <npache@redhat.com>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 06/53] selftests/mm: rename hugepage-* tests to hugetlb-*
Message-ID: <adzCVS3M7eJJU-T5@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-7-rppt@kernel.org>
 <13213d74-da49-45e0-bfb2-c2257a20991a@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13213d74-da49-45e0-bfb2-c2257a20991a@linux.ibm.com>
X-Rspamd-Queue-Id: 3540140011
X-Stat-Signature: ywbqufq9m86aoxbkqkpghiist1eas7s5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776075361-233241
X-HE-Meta: U2FsdGVkX19pvAPz1VgszbpIgW8ERheET+yFA3e0cG8X4YA3sEcgFSgqM8omfT2OZlV4hdPK3n/uSVJas/myzefgD4Mv9Z3Zg+r8K/CxKkEaauKXfKG41r5x1tkqw4bv8RL6rvMb0KQ9YNyvZi7T6s7UinylBytLKHgCoI8HVgbZbqHqfH6M+cPkqI7dfDgaLKVG3dyAwRReV3DiZdeRa5GhvYqSmgBQDX6O9n95s/bBpB2+Q+X/m9i9dE7tmzILJpvh0DcY3uRHxoXkr90f6+oAtB8PzmAFiDIkxMMV5uOqClLROmDFiKlthVFEud8ZqWZhNEULX/4xPg+6exSOHtNPUHqZq6Zy5COQJ2RT06RahpHaH7rjbdKABXXvLg/NjdUnUyRdBzqgqYejuY3tAGlAm5aEeg9DFnj0d+StBla1VC0Il8ZlHrO+izoxa2qOb3Khw95J9yPik4ucMEJuag82S3xa/X2IMbOjjihSW1mKO/G1IzR252bSgWKHEBFOUwVCqeikcarW69P9MO5D0wUoUfScfbPiBEalqY7L5cIwwWsia/eUwLYrNWBHZJw+YVb2VjbWISiTZVIZ0quIaMDZ8Tnop3yXm0OOCuppeoPn6Pd7RTwQngyErRVPDDkQWtsgJ0UD2/qzUF+1acBcPalTR0m6qzyjVIkLgS5z6SOH1PNkjMuN5hlvYhHLOa5RDRNwwmqbKDlPnpsGeZunVxhI5FHR8FE7qhxSxC8bpj1nuSfkAkfVYtYcnTKjoTKnXuA2m9F1P7MG3Uv2HaQDn53bzL+ngPmofQ4N1KHVkIGhJ3qzXFFrZ49ILZ0pCtt55xr2I8gZ3YFzFtkv8ZX0hBVXG2v7Is7bJYvnOsp48GavM6eMY5W7tHxuYOJdrCqyHp/YymTZSOQpaBYNP39rdfv1OF+l5k1oLqFvQ8wSDq9GigfLrPNEcr6Y4AFOB/W4ZJcVjdAZCJaAx0UXkfa
 0Mah5lQX
 mpWiSpHOZMEXBUoNYszGNY9B5RsZgYR/TOa0VFOVanH6gd9ITkjfnP/p08LKApKTS3cri5GtTakJtPIUca0Q7TnravvwTBNT38oCX5XA+L/BOfs0xxxv4BEM8sMptnRf2N9RglBtZX8AQonT2PRMKo1TR0ylY3iWAX/ymski14Rjb3hU7ADs7DksRi74ZoF2DnbOHhalJIMLmA1LMiLiYkLeeK0i0yTOirKEuEmm+esJsx5BoEmV1M7VgKJE3wGp6XZMasmm2ItkWX5abkm+C0MBViXRJTO9dTm1oZPHHQD3yi1o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Thu, Apr 09, 2026 at 03:03:51PM +0530, Donet Tom wrote:
> Hi Mike
> 
> On 4/6/26 7:46 PM, Mike Rapoport wrote:
> 
>     From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
>     hugepage could mean both THP and HugeTLB these days.
> 
>     Rename hugepage-* tests for HugeTLB to hugetlb-* to avoid confusion.
> 
>     Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>     ---
>      tools/testing/selftests/mm/.gitignore                     | 4 ++++
>      tools/testing/selftests/mm/Makefile                       | 8 ++++----
>      tools/testing/selftests/mm/hugetlb-madvise.c              | 2 +-
>      .../selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c}      | 2 +-
>      .../selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c}  | 2 +-
>      .../selftests/mm/{hugepage-shm.c => hugetlb-shm.c}        | 2 +-
>      .../mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c}          | 0
>      tools/testing/selftests/mm/run_vmtests.sh                 | 8 ++++----
>      8 files changed, 16 insertions(+), 12 deletions(-)
>      rename tools/testing/selftests/mm/{hugepage-mmap.c => hugetlb-mmap.c} (99%)
>      rename tools/testing/selftests/mm/{hugepage-mremap.c => hugetlb-mremap.c} (99%)
>      rename tools/testing/selftests/mm/{hugepage-shm.c => hugetlb-shm.c} (99%)
>      rename tools/testing/selftests/mm/{hugepage-vmemmap.c => hugetlb-vmemmap.c} (100%)
> 
>     diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selftests/mm/.gitignore
>     index b0c30c5ee9e3..9ccd9e1447e6 100644
>     --- a/tools/testing/selftests/mm/.gitignore
>     +++ b/tools/testing/selftests/mm/.gitignore
>     @@ -4,6 +4,10 @@ hugepage-mmap
>      hugepage-mremap
>      hugepage-shm
>      hugepage-vmemmap
> 
> Should we consider removing this from .gitignore? Otherwise, this looks good to
> me.

A while ago Linus objected to removing selftest binaries from .gitignore,
can't find lore link right now.
 
> Reviewed by: Donet Tom <donettom@linux.ibm.com>

Thanks!
 
> -Donet

-- 
Sincerely yours,
Mike.

