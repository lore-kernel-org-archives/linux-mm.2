Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DAA0CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 17:47:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440598E000F; Thu, 23 Oct 2025 13:47:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418078E0007; Thu, 23 Oct 2025 13:47:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354918E000F; Thu, 23 Oct 2025 13:47:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228AF8E0007
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:47:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA3AC140BC7
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:47:23 +0000 (UTC)
X-FDA: 84030110766.30.90228DF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 358E58000E
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 17:47:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eHWuff3v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761241642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xM6RGfcDiFvT86UdJZVlr1tbnvIU3ne7C0xgfO2MNBk=;
	b=ZtjE0i4I5VWp7ITcrqrGhFQgeayWMENAb6n6DRj36kCtrJa0VlW5mQZrenjWH+scZrPbj6
	emFQbWOE056mGqcJogitwqA7RlvbHWcyJL4t0ddTMgkMWcfzvKcPQqVPMV0Z6ji0QtXZXM
	bLhRb4r72DV0xfXHibjDDoQhjoaqTTA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eHWuff3v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761241642; a=rsa-sha256;
	cv=none;
	b=vb0nw2f8otACgpyEJ6kuoMtaNRePiHER5QLG+ve4ZpQTBzB2d4BkVTJe5IOx9zglvDSG7+
	FEcT0YvL1qO2ccHgKfA5PHv7FLsOdyh+2LOhixTYhdu1Nqg2Fah2SW3rw3x2iAo5CDxcrX
	fDKphbWxSJ93VYeaAD/0zLiLap1Ndw0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8121861159;
	Thu, 23 Oct 2025 17:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 260DBC4CEE7;
	Thu, 23 Oct 2025 17:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761241641;
	bh=0UjbUuHWI+/B9+mpMQaomI/3XkufAKikbowYNANqJzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eHWuff3vgCcM4s6HPc99FPHy/+VJy1z4r2xR9Bz/6yK7LYtewBpfK0r1kmkUrEPpQ
	 kLNX0iPYF1s7aoir8pqg+Ux9hDMrQQXTKiyKQ945TJt8LTqiLQGaK/TteqSLHEeaSp
	 z9nSJbdes+XLFleJbsQCLNZOf++fsbdCSQHP4aUQc0BWH/R/B8nb37Q8hA/3h9Y6Hr
	 Vky829rcJ/zd6/sDXcrr+bEIT/MFpbYVvE7AfQ7kSioZD4jUgjMXcLfS7/aLXfo1lY
	 TTZkOfm1HEahMlEAlRFYn6ozp2xsNS+nZvr9nnOY/EvMFPAodYVryDCs/reS3B0IUy
	 YVCyXAFalfYBg==
Date: Thu, 23 Oct 2025 10:47:20 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCHv2 0/2] Fix SIGBUS semantics with large folios
Message-ID: <20251023174720.GI6174@frogsfrogsfrogs>
References: <20251023093251.54146-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251023093251.54146-1-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 358E58000E
X-Rspamd-Server: rspam03
X-Stat-Signature: jxpj1j1bsgn3rhj6ai88inrrebq4isnc
X-HE-Tag: 1761241642-174300
X-HE-Meta: U2FsdGVkX181+7yyQ3XMtPC+yWwD9VD0+G7eoXTpDTUx88u6cn6Hr5wqYeN+ytSv/20ifZelmBSb8mEyVjX5siA7SmXedyKXzzb9X+v3tR5uyN+d5oj5XVPj0ELZfdCPSrvs5xerivpvLuQFuVAKKwlW94kYgfUFqptN7tNbAXg2rfF0S3m1PfcMHsnhyDJpkbSbtDEkIGfNyNzLGIQvkVwFXGrzqyyMF51fAUvNgfF2jj8wSGF/WwycmPR77G5T9YI8L8vpNzmrC5yh6pRQ9wkYPghNtH4Y/5OmF3K83Mwnm5GdrDWUspqJOGOjZpF/0tRHwYIgoDKnokKnc8rwL6CIdcO4JLRCLPrrljVtTGcy+RbFBHN2wQ7ZcHkN4zdRfMxM/hvI3RiPqJHAzZ2SGV9/RzqEG/IIIpHt1YdwDj5KD98uX8ODPPBtejaLHklqiXOYYbHuUz2Xl6qyYoSyVpPBzIN4LClySZOXOXS5Uc/fE/JmgOHz5SWDqnk8T3+mU8SKiTHvHVxeM7v1pjVkxzosF3woCRk62xXaj6RnbdWQcucP0/SZDiSWPi5Vopk5K+4m8EXINQ9KYiSQX7cqmKu1Lewju7NgaF0cO4vFUey959iBSYuo0LpNGpIE7Wgh/Pkpby2geM0B/f41Yoew+v8yg6QbX2xoBpf06TeiBnf8pNmNbifxE01H6NaJzwj0Enc16zWYul2LdyJxhGKQSzz1ktK7wUCh4DwuVvB45YIKox8Sryyn5Eaaiy94qnmGZj5FS9q0O949nzgPxbNIKqBhBbQK/vRCBOf3fxT+iQn2pR5VUUg7M84RHQahRSQB9izxV9FkLgN1aPXhWAqa1S5CjaK1nHmLqLDms0NW7gvbEBk/DOF4eIVZhIByxBkRpXxqhdvpcqNt+Pcq5EPajU/MYs8TG5JAb1bifi6lo3hDaFzAI/fqu7tAGptP4ZorIhjvq4oYVu35izT760W
 GcXBnKEX
 R9zlllvoCttD+Zs0raru/TDGF3jz+/ZGyH01EqG9cZEYg1xcHNTRTqxA0Miaa+K3rfO+C0WFh+fFxoes47VOC7t1t3Kzy61H0KZSjGou2aTsey+TOFaZQNaEWLWTQih93soz/vfaaVrXLs7bVwbGsT9AkvVjBfBhjN1rhRRxh2AUcUISFgbl53sriu/13ETMP2H8pWJ5hHkdDg5MJGvZ3QsO2W9m1JWDB0Qycr2QARxxIjiSX8MTcERTxZv9sdfgaD9+nBV/hIk/2H2GKG6KfhSKtksFGL33XOp5as6PNiTNFVdL7GfDlblCwYSwodg5qUsySdnbaw2rycMBBmrhqH41Wvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 10:32:49AM +0100, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Accessing memory within a VMA, but beyond i_size rounded up to the next
> page size, is supposed to generate SIGBUS.
> 
> Darrick reported[1] an xfstests regression in v6.18-rc1. generic/749
> failed due to missing SIGBUS. This was caused by my recent changes that
> try to fault in the whole folio where possible:
> 
>         19773df031bc ("mm/fault: try to map the entire file folio in finish_fault()")
>         357b92761d94 ("mm/filemap: map entire large folio faultaround")
> 
> These changes did not consider i_size when setting up PTEs, leading to
> xfstest breakage.
> 
> However, the problem has been present in the kernel for a long time -
> since huge tmpfs was introduced in 2016. The kernel happily maps
> PMD-sized folios as PMD without checking i_size. And huge=always tmpfs
> allocates PMD-size folios on any writes.
> 
> I considered this corner case when I implemented a large tmpfs, and my
> conclusion was that no one in their right mind should rely on receiving
> a SIGBUS signal when accessing beyond i_size. I cannot imagine how it
> could be useful for the workload.
> 
> But apparently filesystem folks care a lot about preserving strict
> SIGBUS semantics.
> 
> Generic/749 was introduced last year with reference to POSIX, but no
> real workloads were mentioned. It also acknowledged the tmpfs deviation
> from the test case.
> 
> POSIX indeed says[3]:
> 
>         References within the address range starting at pa and
>         continuing for len bytes to whole pages following the end of an
>         object shall result in delivery of a SIGBUS signal.
> 
> The patchset fixes the regression introduced by recent changes as well
> as more subtle SIGBUS breakage due to split failure on truncation.
> 

This fixes generic/749 for me, thanks!
Tested-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> v2:
>  - Fix try_to_unmap() flags;
>  - Add warning if try_to_unmap() fails to unmap the folio;
>  - Adjust comments and commit messages;
>  - Whitespace fixes;
> v1:
>  - Drop RFC;
>  - Add Signed-off-bys;
> 
> [1] https://lore.kernel.org/all/20251014175214.GW6188@frogsfrogsfrogs
> [2]
> https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/commit/tests/generic/749?h=for-next&id=e4a6b119e5
> 229599eac96235fb7e683b8a8bdc53
> [3] https://pubs.opengroup.org/onlinepubs/9799919799/
> Kiryl Shutsemau (2):
>   mm/memory: Do not populate page table entries beyond i_size
>   mm/truncate: Unmap large folio on split failure
> 
>  mm/filemap.c  | 18 ++++++++++--------
>  mm/memory.c   | 13 +++++++++++--
>  mm/truncate.c | 31 +++++++++++++++++++++++++------
>  3 files changed, 46 insertions(+), 16 deletions(-)
> 
> -- 
> 2.50.1
> 
> 

