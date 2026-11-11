Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C423D60A2610
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzfu4WAA
Received: by kanga.kvack.org (Postfix)
	id CBF346B05B0; Wed, 11 Nov 2026 14:12:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C712B6B05B1; Wed, 11 Nov 2026 14:12:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60586B05B2; Wed, 11 Nov 2026 14:12:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7EF6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:12:41 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2C4371A0404
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:12:41 +0000 (UTC)
X-FDA: 85423784922.21.65D1ABB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 41EB710000D
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:12:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzfu4WAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794424359;
	b=aMPIQOV36sjEzMgOzbP8+7sY0cA81dy3Ao9dqNMv8XW4jaJktnsLBk5IIxnymlIMohAoCc
	YHgqAO6BzelmOQS6TKl8hxSMCvPNZz4XcAJmOxt20WKYfiRt7NdYCphbCzpzyic9PFD5dq
	uTfFqoalBZOaIG8nUWZNcjkq/bAkykg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794424359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9rzvnRWJjWzbxf1CdqOdngD5YMGoOzjDwN76qmbiuFc=;
	b=dmyXFTL6jhQUBqsMbcf5zFmprzw4uPS+OFYUoI4Dn59MY0w2xtCmYYz9jC7v4YVk4YjLt5
	V29U6UtQ86HoHaHZpSQdx8U/eYRGMphlEX76l07uaZxpjen80hRzHjer2dVbG0hDz/FSjf
	eiagw2skxcH5yYgCsa5XHBcXswaRVuU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jzfu4WAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B904E61D2B;
	Wed, 11 Nov 2026 19:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3216D1F00A05;
	Wed, 11 Nov 2026 19:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794424358;
	bh=9rzvnRWJjWzbxf1CdqOdngD5YMGoOzjDwN76qmbiuFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jzfu4WAA6ElJ02kn/Kow/ZSu0s0IB0QJ2OsvUpsYACJnXnbWmm539erPelJDDOfOe
	 aw6+cCZQJJqvUwITWwqeUpUsZd/9qAmO8xWtxYPAh4ibTOCRkVHUc4/WC0mLkcI2zy
	 XDdtfmZEI/5RrpshDsKQsdXJ4xKRLav0prmxY1A0DU+X7K4hgSXVGXvSLisdoU20yu
	 kUvz9iHFP9GrF6KjqI16Hy8aT0y9fkL179uWyhqMnF/PP4hiKaoaqPM8NAE8Py/aP1
	 To5D9e2/M2EdcYoM0Gq597Ns7nEpZq8VXxsmHf8cebTfYQJEJrkSVRGXReYwJulZ4Y
	 62sajGVCqmEUg==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 287B8198004A;
	Wed, 11 Nov 2026 14:12:28 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 11 Nov 2026 14:12:34 -0500
X-ME-Sender: <xms:G770amrD8gScgbw-DSZ-GwPtQMbuwsm61xQ8YBBu2eoq0KGiheKFRw>
    <xme:G770ao09YRvTBtfn3GfjXfli5cV6QN9WCTmWj2TH4EcetMGd2iwrSYv49iuOxdHzR
    8YyB6uIfvK-gwomx5LpDQ3Dxkyp6FZbmjxG6Lht-0xHe6bUhBLoDBI>
X-ME-Received: <xmr:G770av1ZHzAJZuikg6gcG-sMShynkY8UC2ojXveCFDNWNZFpMlp6oSoC-8I>
X-ME-Proxy-Cause: dmFkZTES/6cX0KaFoJYJ4MHvoyZOb6MXDU0/tO2FG3RhJxxbVEfD8pjHEIxsQzk0Al2yPN
    SEhfIex5SKtz3lQPun/UByqNcs/KxTT5GXvxxYylZ4FlJU2QVRNetXmrPMM9RL9Vt+vqmI
    GbyZH9mdeKdScR+BW8cX/HcTaYp4E9mis5e5ATXCP8qD2KZAL6IPA3zSlQRZ2QhQQpw7o1
    2U27Sm7SGvcB8wymQGlny6KDRlL+gv07ozEKC+ckkFNc2fIPs5sPEN/TFM8t+MtO0rkq+H
    8pt3TP4ChsV/1DQckczcrs8gXCDvRLQDfJzvJxquUNHH9cvUj99Q01NMCnsHpJGK1Le+kZ
    4+pDo4bpQyKl62ZpWv7iXTTVuBsu5f+usqWAKQ3eRZbhK9VQt0rRvbUqMjcLfCd6iWOi67
    TZx6wJtmbqeDb5YKJQTg8mVMsB2ssGUxwc0+DrORZGZtNURNi5f84iuKnV5uP1YDAZd3V+
    /EL10zfWdPyT3ztdXn6fHlQ/cOeHFz3MuPej6yOli5FkSC6OHMJJsyQady8n+FGpjxh4tH
    BJZKq251ZhN9/vc588/+ysP2jaAh1lsok4VTfRVbn8wSDQoKxSs6p9H3m+/8e05fRJTfYx
    pcw0WN8tvBrhB49hWK5zJ5q2V3eDoF79C3BirccEq4Qbj72ChN/eTWjQZqrg
X-ME-Proxy: <xmx:G770asc5h1oAcOmCwwQDl1xkUUD7GcZFf0F8wGqNjgRK2NQTMbHu7A>
    <xmx:G770an9vADJNurzo60r-_MXTBWMPFVVEFoEyR-hHdg0kZoOPyWhgmA>
    <xmx:G770aqATUZEpHnmjI6bkXjYRWSkbJ1ffzCUVHhxT5oQ88s_huNJ6dw>
    <xmx:G770alwwSaqIvQ91pyca7EXxdzjnEq1Kz4NZNEpM_httAxmVu2BOpQ>
    <xmx:G770asRAUD0hqvGvbgHVi5Vi85oSX1cF5ovSk-myQbewSgmSaVjrKVd_>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 14:12:26 -0500 (EST)
Date: Wed, 11 Nov 2026 19:12:25 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>, Andrea Arcangeli <aarcange@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Balbir Singh <balbirs@nvidia.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	=?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>, Andrei Vagin <avagin@gmail.com>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Arnd Bergmann <arnd@arndb.de>, 
	Muhammad Usama Anjum <usama.anjum@arm.com>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Chris Down <chris@chrisdown.name>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, =?utf-8?Q?Miko=C5=82aj?= Lenczewski <miko.lenczewski@arm.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 06/12] mm/huge_memory: build the moved huge zero PMD from
 the destination VMA
Message-ID: <avS-BWznThxIQ1H0@thinkstation>
References: <20261111-uffd-state-fixes-v1-0-00713d368976@columbia.edu>
 <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-uffd-state-fixes-v1-6-00713d368976@columbia.edu>
X-Rspamd-Queue-Id: 41EB710000D
X-Rspamd-Server: rspam12
X-Stat-Signature: gmk8dtwnpiry18dsahyah366o48upjaq
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794424359-331999
X-HE-Meta: U2FsdGVkX18PCFEjWooar2icOM7Gv7qtMhvNWslzJaGCgkXl9VEsIq9Pq1ABptg4N58mUuwrNLDSZO6rBn2ZW0oirZNyuxbJ5sF80lzDLp4lBQWkSbgXNPA+7edLoaG0NJYJxwiESpf4ENR3/AXZ5PhQBQMrLZpyWPbemL9w8gE4yvXAmM7xzKK4cgZZVhGNUBhdF9+u0jiBLmlFbGk4JC4u+XPrHK9IuHYoaLesDSrNCN44F4W3DCtw6009ACll1pzT9UG/LekiDvc977uUQ0x3x69BvGQStr/kZEJytEOS/8za/6fpSTZJZ/24ILlFwu+aDi3ZKgMarjRAWIQD3LqwmOqtGaPieHmezFLQ7pSlW+Qlp6V2jin3KdpKIYiA11KxxsXPZrm/YvgXDUlnvyleflISMEF8UN6V3k7sMUSVKE5QkwUazKwdBnZlzfwXu/mRbz621uxb31MHGGF7jH/450x2ceISeqzTEVUuZhrD20p4hmLYzBLYsjmiL2ePYAkE2vHRSVxZweUaPnZWeiyK/N9uf/yXWnZEmkWAMd1vxF4BhXborOuNBdPrhNs9yZx2lO/+VSY3vHD7h/pGF79kpUkULSAMjKfWABLF5tCknCcpSMf5G5ih7BDdnfiY2DoJZA7P4rFRWzHyfgpIcxvzPuuRuRVgg/VCHKDg8F3GPCWWvJnIKiZiBIQJHs8be9JYTq4z+v7uYGNQs5VpZxnViDFE59X8eagbTgk54K1D1zetO9lY1pF6vWEZOOxcG747xCi8lyz1Gjg2o1z1qwJBAeqPlrGW3B5ZnJMd8oMsFB4Me1TmSAn/vAbp6oOXFS8DcK66gqdCxDE+ShNtQ+v3bcNzLv0r+ZZg69vQsy/lEbfuqp1S/ldnKrta5JNTsImjQYuFCLzu7UYDoWAMdl9XiXc6mkJ79CbF43DOZdoleZbUCTCtU5j61WSpFdLKeN/SwSK2KeBtCy1o03T
 DYR0wQZ4
 FtbYHVQen5XQp7O4f27hFUSzrVuMpDZ2I347ddfEDEo7PO5Z2RBtTjOJmDZFJjay0rPZrkaC1NqHkNd5Xr7yMN6lWY5+fJp5EF8arU89GSKRfFzW5Rdrqv6fnNAEZi+/ThUMwxseFcb0p7d7Zih1+1CKZnT5jgAV9Fe2f5HKXUMQQlP7IaKKnPZf9VpG30HIKzA6D+8/LGgl1s3vOPS5agC2FngcXp++ZPmR0ZQkdBGaJnhcddVqeBS+3orCDjUg3ndgYhAnazfm3dBJ/FTeLU07GTKFMp9zq3Y/yZqxcDvH33mGXHoy/+OvKQ4xXkBife2/nv1uSnA+G4bN1wqMDIz7r86+flgIe8kkCe1DzSZiAeCHSs33I/ljocv4PwroF/bRlf+zW78bBJJTaHOM7MkWpkqeX3dG/wm7XKjOOYOs978DmxL4368yU8gnpJ8TlBAzOg7enXYZaKHHWeOVH9RrvnZ8kcI232GuirkuEagFBSI3QZe1NTWSlENnU1FPn5MTIzubKiTQtO7lVywcrNs9ZcGepC4fE550pPhf9Bn5f08C26JJuJwdrEhPq0Xd1VwU1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 12:55:14PM -0500, Tal Zussman wrote:
> move_pages_huge_pmd() builds the destination PMD for the huge zero page
> by copying the source PMD and clearing its uffd bit, so the destination
> keeps the protection of the source.
> 
> A source VMA registered for RWP can map the huge zero page with a
> PAGE_NONE PMD, and UFFDIO_MOVE does not check how the source is
> registered. The destination then gets a PAGE_NONE PMD without the uffd
> bit, although nothing asked for that in the destination VMA.
> 
> The next access fixes it up through the NUMA hinting fault path. Until
> then, the first access to the destination takes a spurious fault and GUP
> has to take the fault path. The impact on userspace is small.
> 
> The moved entry must have the protection of the destination VMA. To fix
> it, build the entry from the vm_page_prot of the destination VMA, as
> move_zeropage_pte() does for the small zero page, and keep marking it
> soft-dirty. A destination VMA registered for RWP still gets its PMD
> re-armed afterwards.
> 
> Fixes: 763f43865fc4 ("mm: preserve RWP marker across PTE rewrites")
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

