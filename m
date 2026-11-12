Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A098460A2615
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VoMrAWhy
Received: by kanga.kvack.org (Postfix)
	id C3F986B05B6; Thu, 12 Nov 2026 04:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15D76B05B8; Thu, 12 Nov 2026 04:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52F16B05B9; Thu, 12 Nov 2026 04:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 940FF6B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:40:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 25993160487
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:40:07 +0000 (UTC)
X-FDA: 85425970854.03.9FBA8D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 70869120004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:40:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoMrAWhy;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IfhBgU9bzNjyzCbMLI08qHDpGZfOfIhIVxpnfJz9+gQ=;
	b=s0ipeygNWaUHxHlxaiJzRxaZfBW1a6mYITneAEh6zOG/lb32FfPOWyfSk7R7eMSmS/Thgd
	JySSajBWnciHApj/MU1ggvk6Ie0XULmEq7VJtn/k5HKXZQ/crJrmJHeeRYAZar0W44qBpX
	1ThgH/R8k6Ijvi2QlcI4daZIYieVcHA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoMrAWhy;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476405;
	b=4RUC66Aj85bxB5+djdIHmqqHa1XgY0LnyL9QH+6/prT6uWQYF8og6fotlqCWtxKFJwyL7j
	pWRaEGsyi0+HgK8vOl7Cr+x40/HeSZKIN/M0KmsYWI2NwlgRhZJQvhqDgnIOXU+xa7Dd4v
	/dQDpJxwCES20dchfaPEJjBY55a/NZY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B4B5C403E5;
	Thu, 12 Nov 2026 09:40:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C635B1F00A05;
	Thu, 12 Nov 2026 09:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476404;
	bh=IfhBgU9bzNjyzCbMLI08qHDpGZfOfIhIVxpnfJz9+gQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VoMrAWhyX9Mu8dmXuJL0tzpqovAGH67dTxFbjd4TxmhmE1/c0FPVOzA9Ic0I2dr8O
	 R1LEPqRDp5AZW1NtPA3Ct7Mk7SEKbgWIVeFl1BNL5iEUe1bTvUvtWIzoKx+CYUZmQy
	 GE8NIXtSJJ7ZrGaRM5fNNGKitBWEN5/Q6Tq+JK0378GDgv0YZwNQ5bsIqcTjglpUxq
	 +rRcWDYtIVXhXlC40Ldkc9s2FE3hdEDpugkRygfnLxQixI1iNmJpEI1jDUtJdy6Kj8
	 Vw/b/Oo7ZPcLQ5a4p4SUexF7KHm5VqcENXFZHkOCDlVpUBNHuwr/mELTYjRHRonOtj
	 9U2s9/qqKtsKQ==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Miklos Szeredi <miklos@szeredi.hu>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Kevin Tian <kevin.tian@intel.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Josef Bacik <josef@toxicpanda.com>, "David S. Miller" <davem@davemloft.net>, 
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, 
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, netdev@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
In-Reply-To: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
References: <20261110-refcount_overflow_stable-v3-0-318625d63a98@kernel.org>
Subject: Re: (subset) [PATCH v3 0/9] mm: limit pagecache folio refcount
Message-Id: <179447638951.7244.5228149003624496001.b4-ty@b4>
Date: Thu, 12 Nov 2026 10:39:49 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: e4ksjmq758jywkjqw718rqdp1wuun5w6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 70869120004
X-HE-Tag: 1794476405-786828
X-HE-Meta: U2FsdGVkX19Z3tYYrx6Opl8m5BUPOpbPkZeBwC6tWhWM/5dIgPrLIuuwXCbVpVDOsFWuK7DmWqqz6co0Daq64aQIJYbMeCYd0AAryU+eYR6OhRIc60ZMCNJrkRoyQ7D8TqSH21HSZcy1mUxgyBeZ4moZsl0kEueq57xCUuIOkeIrPaFIA3N3O5qDwxQhKyMvCOW4AjYDaumESSz+NpxGn4IsUZKxwzS2pHHiwYp8AyVxLSg4vXucCdUW9ehQ/kU6DnqggDUadw/ryW+92uEH/6YqdEQzjam/HTIhBnhSxsF6Y+RP6RIS2GLNiF6gq7JNGBiEWn+PiAun36cDsaMpC/eMW3TrMw0CbhAkKMV3H1tlAjbhB4td12CcuRa2Apqo3mp/SsbWpar6bm7VIJFOgXusQSFRHnxkbXRrpm17O+BthQx14XM0jUN97/SdrrthPrc+LKgGdNPl+EZ8jhvO1NQFksMpEzHKUFgsPzkGWiv4zsA4RLvEMkDCdWi5tDHBXl00p0XpZ6nidKIAvW8P9clR0xPHtZFMRuMALcfPS30SxK06jW3N7kMLFljJa1w0dWgq5oJikQxgS3HuZ+6gzZ+tWfBD7nZCXcNcnLJlPCyreWVuJEJhyZuKzPujKfKwWOjkZAJCGaeV+6rIbvyzU5DtTW178p4boqkM0B/0hx1uvEIUQxhz0KueiDaNLmWH+c1G0ZXPsPjnX6ybCAX/+5MftpkDJ11KuRKmW6l4Z9GJxHC3dnTaGiFp9B1p+XEBB4gu5Tm1vyebOqeK50HGM38plKccy4sdTzENdW+0aBC0hJRqouy7tte8ax5+OVhVCx6HsoNz0UnNcgi2xHL/YoY5VvkKHKP9aqvwZdIrPQwjW5zmhAEfW7AO9UIPvoBE78xSQPcRMWuIPIComTBY85GBcW93Pr8SlzI34CA4NBPB0VHhKH678wc0hs3xG1L0hCCsDIgMSq9R0sNk+Uo
 NulYI45Z
 qUpgv1ZKeKMNCYN4W04Sp+1Ezh2Q8FA90jCnjyrMbVzZX7lsowPccdS8Iri8quvT1tkBwnwjyD+E+waKbEsLT+xlzp3rRjop9WaUwGrnVOFPjX9zltgO3/m+J+fSgQjnZhbvj6tL8mmrNfV2jw03d1/Q8TF5NZt7LoWoY4XQDDa2JbLDPf0LZKHHLlB+n91nBa1EKxKV/uc5sm3ue6G+vYWCk0bLV1i9lIwCmPAjUnyjC9ylkljPEcESnAPQ6p8S+oCGhjaZuYpEcVfiu9wh4s9lEniuPdwRvlBfob3jCaaowZYu0SSNq6aAvDRrD/0ofTkRY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 21:35:40 +0100, David Hildenbrand (Arm) wrote:
> Note: I really would prefer doing something else right now, but this is
> rather urgent.
> 
> Users can create a lot of folio references to pagecache folios, making
> it possible to overflow the refcount of large folios.
> 
> While we knew that one could in theory overflow a folio's refcount, we
> mostly assumed that bad things would happen and it wouldn't go
> unnoticed.
> 
> [...]

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
      https://git.kernel.org/mm/core/c/61351dc9
[2/9] mm: limit pagecache folio refcount when splicing into pipes
      https://git.kernel.org/mm/core/c/0ff9a420
[3/9] mm/mmu_gather: flush pending references early before the folio limit
      https://git.kernel.org/mm/core/c/bfbf74ba
[4/9] iommufd: fix cleanup when adding memfd folio pins fails
      https://git.kernel.org/mm/core/c/6d0d782f
[5/9] mm/gup: limit pagecache folio refcount when grabbing references
      https://git.kernel.org/mm/core/c/6d3ff38d

-- 
Cheers,

David


