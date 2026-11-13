Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0234F606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IPtuJoKO
Received: by kanga.kvack.org (Postfix)
	id CF6706B06A8; Fri, 13 Nov 2026 05:53:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCA256B06AA; Fri, 13 Nov 2026 05:53:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFDE6B06AC; Fri, 13 Nov 2026 05:53:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93F3B6B06A8
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:53:21 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 22E681C4155
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:53:21 +0000 (UTC)
X-FDA: 85429784202.22.47EA53A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6DC1640007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:53:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IPtuJoKO;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567199;
	b=cg4nZOMnNW2phcNEt6t63nuUXL0gvQb8AvIX9JrX9ZnqRAnXUAGBqcdEy0XRceEOwTUFTq
	Pr3Oo0lyXf6uRDJTXxp72RGFhiiZXbDi5q6zlrUWdW72uIDVjJ8Ik9TP+5zJGxeIQsBQgH
	LzRNERR25zbKR0XjNuYgSndN8VnX9po=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IPtuJoKO;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FXAR3k2XOmADxmocsX6uctWFtqeJu78i+LhIjLZQduk=;
	b=Fcy3rW+oyuHYEp6vPGjm3MXJhOu4hEDwASac9L1XBrB4XrCoAzvb+zhRtmYRUZqmpNVxUg
	tuBGjqDVEi7YQQGDl3wIEjvmNZqMCdspyC3IvYtAaVvuD6OJhcL/WyKA1xD5NSKd8IrPY+
	JHRSHWJ6MWigbYoRVljurCCRGYHLrlQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 049C661813;
	Fri, 13 Nov 2026 10:53:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B244E1F000C7;
	Fri, 13 Nov 2026 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794567198;
	bh=FXAR3k2XOmADxmocsX6uctWFtqeJu78i+LhIjLZQduk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IPtuJoKOgWndeSoW+Ft3DNggXS8gWEaDgnYeDpRAG/BlU2uN9HvsIaEXvK1oh4mgm
	 39cal93B7HS5m+6upMeYECPQ1Zyxj4IccScKEvkyMn/ULHL58tQ62QNgWDydbwEPyu
	 +nqDDxVxRKKW680xeSqy0Z02nhINaogVyU61pDYjSDRpfZgAA6tmITzkeVoOKUtKMh
	 DjWM8Na3+aAeVtBCznGkh8sY+5EA8owX5Qs/0RpY/uxHYPIrwY04cScd11itwqTscW
	 oXjeS2Gpc/3uepUzBJOBCspIJv1bF5djY+zFcYKECFQH8KUxdf6U7RK8YGjJCOlaV6
	 V5Di54SflxNNQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Song Liu <songliubraving@fb.com>,
	Rik van Riel <riel@surriel.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Steve Sistare <steven.sistare@oracle.com>,
	John Hubbard <jhubbard@nvidia.com>,
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Neal Cardwell <ncardwell@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	linux-arch@vger.kernel.org,
	iommu@lists.linux.dev,
	netdev@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	stable@vger.kernel.org,
	Pedro Falcato <pfalcato@suse.de>
Subject: Re: (subset) [PATCH v4 0/9] mm: limit pagecache folio refcount
Date: Fri, 13 Nov 2026 11:52:56 +0100
Message-ID: <179456713145.6906.7073956264359546741.b4-ty@b4>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
References: <20261112-refcount_overflow_stable-v4-0-ad3deef0bd23@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6DC1640007
X-Stat-Signature: wm4aj9xqnswnsib9q7y9bbtgtfxhhzrr
X-Rspam-User: 
X-HE-Tag: 1794567199-669500
X-HE-Meta: U2FsdGVkX18OkHrikTCZKxbZofGhjcncIrz0pGuC5PXHIr01ByIFqooWYC+fHSJIvOiaWz0KnGKA2TFA6xRTummog/p/Y5e+7q0z/oOG6PZjIPeCn25uFpHWQbu9qcQKMkMNLGIgrOzv0GawpMPusScIWthKvZvAyuO8VNiGuC6M3cx2DUZYWwAdKTc0px0qt6kBRyeDbCDREytxeGCY4zyr0pNKDe6XsYQxZRB2BUBm2w6DqP0U1QJb/5iirzSL4JaDHPezmZQQ0mgQ/DN4bZbgFojKkX+x/2Pga7zCpmqsnsam+EqbdDu6+QESqSjbvuWHcRd6A+d+cYPfh2FqrfyHlaWGNFzxGBInNjoJ1UGXP4ZlTPD6ee/b/I8Patybf2Epxk2gTl6EHeN0qiKgOGW2JSU5E+JIoHl4z3r16sJxXmIH78rr1K/hreVp+GOGpzXNIrxgCjm5WR/Tgdr3dQqArsLGUmetYvEm9WlJxpr5FNxVggINZlYnU/uNmCdC0ran6OHUVrpXVDTqkyt1L+q3ij6TQyqIVccnDwFQMvK1+MdU5sJnSKJvnZ9FSsIYfSja9kHd1wxX/b49yRIBuCWiXfYhZtLXZrEaywaLYHr0yT1vy9GPkUfA6HP8vvoQ8m3/PhSqCTsXtZfYWP4kIbZgYDmnlZJ3fhPbKOvJQJvzxqBeglFsLWWDQuPiUnjEexDVbWjJ/oBx4Kk6IqwQsEcr9g7bSj4soEC0+IURpEPItLsI9IqdkR8oVE9wKJ0Mo6YcntzO5sRhqnwyoSZ+ay/4GjlVukWRpt7SkP+vRz/fqa5EPFwHIqopVbFhufe/OKkMDdD5X9sS5wWyF/T7vFxYAZv6V7p3nMiUAv4MiF047FfDEP/kKfd4qqIoht+kDOXVQaYK/ROJHA7Eo8PSfokG758adXKMBMyqm++r1rABXONnd+GSVPnmLDiLY7aRzVpUnvMMyxEq9o7HhYg
 AJAe0EOq
 w57vCX9S/eoR39hTzZRXnq2qag5wJj6ai1Kc/JV5/6Iyz/wWd0kxa0zc+U5oz9LlrB0lZ0SRjonkB6o1/q8OpxOe1X5V96OqBWUzAxmfoQkNO18hAPReBXJIpKiO2CY6KClP2NWiUx5fFIGA/q2XmVhmJXlh+4XJJZsf4Q/KRxk2AfcU3A9a/hJyWKQEzHmmq7fQD9Fdvo6S3kvN8pVQFbYsSC6ZJ7dXVbxswrJBtxLS/rIZLJWQ6W7vx2Ev0S9o7+iXNwK0Qb0cLEnkXYB1BNmxutRfP1TjV5YGkXIpmmy2wnfZhibKZOWRkf9ZVqg9KRcFq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 23:53:19 +0100, David Hildenbrand (Arm) wrote:
> I'm resending this quite quickly, addressing Pedro's review (thanks!!!),
> so I can replace the version in -next tomorrow and move forward with
> this to get it fixed.
> 
> I un-RFC'ed the -net patches, but I will not pick them up. As mentioned
> below, they can go in independently.
> 
> [...]

Okay, updating the first 5 patches in -next.

--

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/9] mm: limit pagecache folio refcount when mapping pages
      https://git.kernel.org/mm/core/c/86c0d919
[2/9] mm: limit pagecache folio refcount when splicing into pipes
      https://git.kernel.org/mm/core/c/6ab934de
[3/9] mm/mmu_gather: flush pending references early before the folio limit
      https://git.kernel.org/mm/core/c/89b412c7
[4/9] iommufd: fix cleanup when adding memfd folio pins fails
      https://git.kernel.org/mm/core/c/35e8fbf9
[5/9] mm/gup: limit pagecache folio refcount when grabbing references
      https://git.kernel.org/mm/core/c/a6f95654

-- 
Cheers,

David

