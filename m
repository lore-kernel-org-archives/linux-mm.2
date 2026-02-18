Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FA20E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4055D6B0088; Wed, 18 Feb 2026 08:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2E36B0089; Wed, 18 Feb 2026 08:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF236B008A; Wed, 18 Feb 2026 08:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15AEA6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B08D01BF3F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:03 +0000 (UTC)
X-FDA: 84457600206.14.7DEDCAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A2271A000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZRQj+0Z+;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKcP9AezkYw4kw3AK8H8w2C/M1HfkGLDhA7lSmm4qFo=;
	b=q+37V5qmcE3mYpT00DWTVV5nKpuBZNrXkfsl+QsAokFNCRlr1UI5q14AsC6a06gi3HQGyd
	0fIg3h9GTbAJFimTFqG2W3Q181csRxPiHHEe/Pbkbs+X9O3YahyHwo2eV2kdzHA5/iJaJd
	6QVJeCjOOoUdU9bh19Q/hc9AqLu9/7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419962; a=rsa-sha256;
	cv=none;
	b=pZCysKIFkhr6XVV+BCp3umGI+dqCh4nGVzf1fOwxpvtVz4gFgQ1s0WzNha3jiws3YC+mx7
	v/e7R9LPoZ5RFvm4kbO0PpCbqHNOPuGCdxzgiQP4CTy9ADZ6bY0v56yAuPtpGGMntIl3Qg
	uOAC/rpG9HT4WnVAv2xvoGrgl4XyRY0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZRQj+0Z+;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 19004405A9;
	Wed, 18 Feb 2026 13:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F54C19421;
	Wed, 18 Feb 2026 13:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419960;
	bh=wdJZZIzpHkDq9CqfLAQjA1xz1Y1X7C30wWjsc3kJBLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZRQj+0Z+xmjQDy7Gh1FpYKpwRI5gTMmaLTgEUNpjiE4drKJA1sUVKEgZiIheDcNfY
	 rlZ8Rjn32bl+hR2oRNX2+FdmMJKBDFVjTBBzYnX5wO91q3cHZPvWvEAweJ8SWQtJlr
	 Bs3krNJd/1KYRXoyDY5/bBCmBdOwBYLk7B310IBpcK06yAnFAHI8mTsjCYCZ3x/+eD
	 HR0JgBwOpINJkPwRHftweSKDvpiqEPntdZEyGL5cQceQMCIGs3MYbqdRBL/AbK62bM
	 s2MTUySTsZbAKNuTJh7GQ9OrtWkjaQnsEkkQH+sMO5PrKr3dWoE2HcyoE4Zv5BSlYr
	 5IORZp81aGVCA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>
Subject: [PATCH 5.10.y 0/7] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Wed, 18 Feb 2026 14:05:45 +0100
Message-ID: <20260218130552.55727-1-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2026012610-absolve-ducktail-3c64@gregkh>
References: <2026012610-absolve-ducktail-3c64@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cc3jgs9w7guo41ncrsjpdzyp58cfraax
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0A2271A000D
X-HE-Tag: 1771419961-668789
X-HE-Meta: U2FsdGVkX1/fTsedt3W8uXOpLsKjMM1KVQm0YLx4Z8YS7c5Xawkchncq1ovKKtYlZibgi69h3EHSQvqgml/ng7ZEG19DrH6QKK0L8maf3G7PzyIxuS/UDFAVwGRrzJMw66XJ/0o1GqqOtHFIZgTsuk1W/COyUmmP4aWT7E33CEIec2lMRg/kGDT7M06OA9jh9V6/S1ny2fHPqXHgzP9QunHdZCxnazhvTvxxts9VNc8OxmCFM9ZOU7FiHjBynRCFmTsFTKmC7657pghg9nka4SxzZ7Ob4b1P7tyDah9gCmrdDMH9kHv5/heHxeujIMg3sg/PH4WK9N5oVnctBwHO8YQJYdScnJMmW0fq1xPy17uDx+sv6DZUygyA7rc8WnB/wGXqdLHEyOpzCA5RegiFiHqX9KGAbsaBhKyOX2j7uFmvBME4l+/Wk9GlSIBs8E7IqynWBtGzalqE6UAVhembYEpeU5BnmWeJt60KDmrhPTLgynVO9MWzEOfoI8nuxSqXfvLV1zcJim0N2gtl5Zscu6u2qKum7ovdH9ThEVE2P3pKqUGiQTUSn8BmkO/YSHG3Yehm+Om1aa6PLskuK5lFBAA4q6NCtEu+VZ9qhnW/yIPZj7fhK6aOxYFZ53hS1oZEf0u0f/75VtcFoxDvQ1mmEmF2/js9TowFMhfiitak1N/iwcb++ZjqZiVFd6pTdsqcKFJhRZ0qvxzr2gvotu4jTGBU32iIzQYgRJNACYlH0msb9c8Q6IEHuGDdP1xt9tkIi0+khODScLVOFzoBdSRrdEcnhgHB2ElTl+EUxWtU/PXFgxc/PK2Q+iCxCf8VKphqBRrkQGSeIYf5FbPGf8RTDXXKN+Cs+LFemiM/pylaApVOfeCUjq2zzFRY3DnOX2+x1gEFHd7db2VE9A21RDRpUEqRvqZZquhiHOC1HOLIda7jjbGWCUP1U8AoZ57iFJpWgR81kjLhNiYL8UqlmNo
 RdmSMhDJ
 NEn+FLd9COTKb3REiDMpLDQc4PPzkFYnnByQqsAjWYEyCUUqmrilL+GLj8JAH4tOn1hVYTLQ8oBJY34qyxPxqsdHCVWBx81V3OSE45yqJb8low2XY7fkGeEdFIlBJgQldufyXpFEpm+tvLFH9jhI3GJ55Gg/Bij9umOZU2Nv9Hc5Lq4bg5QwjXGtNHcMggWUGlpd7E+68+p1BHIfGh+ThqzysnM69XSyMx++K08Pf8qMmLIVsyVsZeNUJSyfp4AKC4PmYnDqne7bVCC+mFDDKbDd/t+cgUVOYDrnEcD8aedU37oqDgoRU11+Qw3ziCqNK3dBsommyJHc6G0xr/jbLOgvsvu2PnjC03EPLhGH//lkk9pgR4F3L7y9sd3BMlsxnPppVjR7xQf3/BiPZSdleK7iE8JRx5vHbJ+6zIKAsRm9kzslj4GriU44Auy5qVw5MSUVEJNRrZ+cGDAXVyzbtS7bNm7nIuO54absGGyOQN6qpbng=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Backport of [1] for 5.10. Backport notes are in the individual patches.

I found one bug in a previous backport, fix in patch #1.

I'm also including a cleanup/fix from Miaohe that makes backporting at
least a bit easier, followed by the fix from Jane.

Tested on x86-64 with the original reproducer.

[1] https://lore.kernel.org/linux-mm/20251223214037.580860-1-david@kernel.org/

Cc: Jane Chu <jane.chu@oracle.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Jann Horn <jannh@google.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: James Houghton <jthoughton@google.com>

David Hildenbrand (Arm) (1):
  mm/hugetlb: fix skipping of unsharing of pmd page tables

David Hildenbrand (Red Hat) (4):
  mm/hugetlb: fix hugetlb_pmd_shared()
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/rmap: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

Jane Chu (1):
  mm/hugetlb: fix copy_hugetlb_page_range() to use ->pt_share_count

Miaohe Lin (1):
  mm/hugetlb: make detecting shared pte more reliable

 include/asm-generic/tlb.h |  77 +++++++++++++++++++-
 include/linux/hugetlb.h   |  17 +++--
 include/linux/mm_types.h  |   2 +
 mm/hugetlb.c              | 143 ++++++++++++++++++++------------------
 mm/mmu_gather.c           |  36 ++++++++++
 mm/rmap.c                 |  20 +++---
 6 files changed, 208 insertions(+), 87 deletions(-)

-- 
2.43.0


