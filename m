Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF09C60A2613
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 14:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIYIin49
Received: by kanga.kvack.org (Postfix)
	id 13E136B05B5; Wed, 18 Nov 2026 09:55:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117B86B05B6; Wed, 18 Nov 2026 09:55:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02C7B6B05B9; Wed, 18 Nov 2026 09:55:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D30C56B05B5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:55:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54434A07B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:55:42 +0000 (UTC)
X-FDA: 85448538924.07.921E5C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id A687920002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:55:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIYIin49;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795013740;
	b=HdaIvifzx9jXopqY3lwEFw+rAYNV6K8lpaYYy0G3CHdeMuvbWpHWb0QY2MrF3Fgunk5CNt
	SYSP48PNjx6Xif0YylWcT1f+mfx7HgIzN0gY7qD7vWDDwis4uUS+CIsnVuaHYL0Q3+4x74
	Cbg681tTjkISE7RB7e1xxbIIKHSyRPY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795013740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ijqcgAe+pRUXlQUJgaP68UktE3jKkOIl7f6QeVzcqa8=;
	b=rwfnf9w/rQBYxf/QInZCyhoqYEblDGZ8zBcscqWKGFJtI79+g8vVzW5Tqr9Er3OWPELoc2
	FIU27cmq57aeGfICcS6JY2+t7w6+ftTJVrtwiEGiL6sr4CqNl3pPArIzGhJYZEqkT6DmXR
	5cjqMRr91uA/NhxHfLaYJkEU39+xL2s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIYIin49;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 25D10622A2;
	Wed, 18 Nov 2026 14:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A5A1F000C6;
	Wed, 18 Nov 2026 14:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795013739;
	bh=ijqcgAe+pRUXlQUJgaP68UktE3jKkOIl7f6QeVzcqa8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIYIin49xSrhz3fYpj0Knm3dUy7DYct2MAxbHOUDkYisck7LJSB+Gndhs5lT4zRp0
	 G9yKhwIrSoMLZuvK+kh+eKEGAUD5ZD5PkCSvIc7Yh8N097/MFMZwCvJ44VkcLS1txT
	 gmfuU5dgh9eN0rM5Eivb+hfREhloBoUPSaqyZaceB3ZLGueQNPnbEVpsPbv5gJisMA
	 g0KDwnrs710Grb1t1KlpS4DNooZKDpOAtKxApW4TMkzSV6oxWEG4uAbHNhlEV8ZzX3
	 F4c1H9BtHpNWWlF1dw5YbJdjG1p6nzWGMBKtwO0fiXjBq7YU1Mm5Mo1ITGy75NkD7R
	 OyXlJ/cC3fvyA==
Date: Wed, 18 Nov 2026 16:55:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	James Houghton <jthoughton@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Balbir Singh <balbirs@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
	Andrei Vagin <avagin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	=?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3 9/9] mm/userfaultfd: check the hugetlb alignment of
 every VMA in the pre-scan
Message-ID: <av28XEFwGGuNhrSE@kernel.org>
References: <20261117-uffd-state-fixes-v3-0-b617009d1a4a@columbia.edu>
 <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261117-uffd-state-fixes-v3-9-b617009d1a4a@columbia.edu>
X-Rspamd-Queue-Id: A687920002
X-Rspam-User:
X-Stat-Signature: sa5c846763hhoxp7yjysdfj5aru7xzi5
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795013740-126362
X-HE-Meta: U2FsdGVkX19A3JV6B3cNmP/FdsEQwdL6swHCgZ3zHvQ5gcjBOWMjvXtqKwIw99leGejK+6xj6TMnsjLfrfw6AYTCR7tHehyt8saSVRcb49BcVcuzcIK+Iy1Icqwz/FKybK4+ZfytvvavIho/iaWWh7rZwe7+JPUU5a5voGRa/ywDja7J7qJoqgJimFTYzsJKxszRIgzyXugS5U1cmsGbGp3CsUx/mPG83rRGncJle35vyZBusiASUeg+3wv9ocA8PTVAFA5Gl/EzoteAmqCq8ljT0IqfE6doQAgmB8ZgIPY3rMxrSXTDZNevE+SbopnEWI/VqoGEDwjkNGeImKrCrdyBEOZUbci9bsNyMXW1AXIGCRNsus7ePt9J85V46IJPNGeX1lsK8Oa/DEK7aer95HcrddICyTTBQ4Hyfm8Io32GqsouQR4E6BuQzJeJPa0tTDPVkLquwL/d3HBmv+mUxJQjEWskngMxemD9cXivss1yo8Td4NB56O68K9o/yqcsfzeDSaOw1a4HnTBeBfZyzH8OJoL6cPiEEZA6Mf8wSfU0nmrvO8jzhQv/eX3GzuZHrVrR4HPU5CfQK6AqrCsI72k+9Gl1hQrOcAPtqi5e+Gjq6pd2P3Nu+lc0gcGANNq3Oyo4b1QGrY/iWHpZYAc75EppJ53qiOJBr5ElqycoyWoWLSXmnAxFgc/X0n64UVa7mGpkI86giuMa+J8Y0M1himlo8pR1LY52EyuK8AF5X7XEI3S5I+OTDmPGkYWi4iYi+xkpPQgaoufbU4EkCaMmTVXh/hxODJwHLPmuoLEq1xLztHkKShUv3/4eh0JHVI8IYn2pn29U0pCJ5d1KJm7TjBCgORkzGtoOtYCtqyt8Nx5AJ5hG8JY3hylIb0xIwUITQx/8W2UVxVrDWjWq8hgGfo9EFwz9XtZb97maVEZlonouOS7XX3UgNH5no1HAhQC03vvy59ZuSAMelcc+pzB
 WHxJFWNF
 72x4N+HAfbBwCM1l/qpBbtBKubSja9yBkZeps+/FypopeXrAFPlV5QA35t7C8Zss+M2lIZmQX3a71KEIoTWc5Ogv7rziCO4m+RyzLj384KawIubBt6gh+JvdhIOquqP80ms/cpmnj50nCjyGtINQrpQbR5CbGui/BQn+Pomgzl4ASlkd9w12w/FPLp3DeVkI0WBA8jkB+tTQAw8W/H08VJpRJ7vWdJiuINoz2VxsYfRfYIstKIWIN08clig0o+tM0wHKYhhIEutyqMCSt6Svlnd7dyWJfEUJomoM2RttGCf2Eu6T+U/egqeL32DPTIzphzqjqmFVfVbYYs8m4gfKnXleCi2KwkwvQdIYboLrBXnzqvtERACNBdSKFaEXpisnvsEg61a8pUTpt4WgQQJP786Wja8hjD+acx9MdWkmuUHbthsisiYBM+5xkQs1GoQPrZR2XzG7vxB1O1M5vHUYD3gllZHBTRInAhG+zqdpkSmYCG/dODpFddnI+3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 11:28:49PM -0500, Tal Zussman wrote:
> UFFDIO_REGISTER and UFFDIO_UNREGISTER both scan the VMAs of the range
> before changing anything. For a hugetlb VMA, userfaultfd_register()
> rejects a range whose start or end is not huge page aligned there.
> However, userfaultfd_unregister() only checks the start.
> 
> An unaligned end only fails later, when vma_modify_flags_uffd() cannot
> split the VMA there. At that point, userfaultfd_clear_vma() already
> cleared the WP or RWP protection. The ioctl returns -EINVAL and the VMA
> stays registered, but accesses to its pages are no longer reported. This
> requires a caller passing a misaligned range.
> 
> To fix it, move the alignment checks into vma_uffd_range_aligned() and
> call it for every VMA in the pre-scan of both ioctls. UFFDIO_UNREGISTER
> still returns -EINVAL for such a range, but no longer unregisters the
> VMAs before the misaligned one first.
> 
> Checking every VMA the same way also changes the following:
> 
> - UFFDIO_UNREGISTER now returns -EINVAL if the end is not huge page
>   aligned in a hugetlb VMA that is not registered. It used to skip that
>   VMA and succeed.
> 
> - Both ioctls now accept a start that is not huge page aligned if it is
>   not inside any VMA and the first VMA of the range is a hugetlb one.
>   They used to return -EINVAL, although such a range covers that VMA
>   from its start, which is always huge page aligned.
> 
> - UFFDIO_REGISTER now returns -EINVAL rather than -EPERM if the end is
>   not huge page aligned in a hugetlb VMA without VM_MAYWRITE.
> 
> Fixes: cab350afcbc9 ("userfaultfd: hugetlbfs: allow registration of ranges containing huge pages")
> Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/userfaultfd.c | 54 ++++++++++++++++++------------------------------------
>  1 file changed, 18 insertions(+), 36 deletions(-)

-- 
Sincerely yours,
Mike.

