Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A57A606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EvG7UJAA
Received: by kanga.kvack.org (Postfix)
	id 5DE476B05B3; Thu,  5 Nov 2026 08:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 588F76B05B4; Thu,  5 Nov 2026 08:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4766D6B05B5; Thu,  5 Nov 2026 08:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19DB26B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:10:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A07AEA0A1B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:30 +0000 (UTC)
X-FDA: 85401099420.26.8C5FC09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id DFF7240007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:10:28 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvG7UJAA;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793884228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=4JVtXgjnsEuq37SFb/p1jbhOS50fULU4Fu7t4ksVFwk=;
	b=IOTq+J54heBdAe2Ec021knNtsrPVxntK3HBUFqkphiAu9H2Tv3yD0dgBD4MyB2vjzpCV2B
	7kfH8e0XlI0OJrRdvpJVTh/c2MrHQ3Sk8me5yr5Gc9pjqY7X+M8Zhhl4yRrhJqEzZLZ5hR
	2RGcHCxt0yzsN8edJrCfHgseqfNuRgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793884228;
	b=J6llha8p6dfLvjLU9dIv22gV81NAElrdwGCBewN/8lG7cZc/wR+Q3AN9tUIXhNT5dKtoU5
	CtxVVcvRxkfrpXXsvRC4/uPwnWutNyJg52tUo/K7Q0awB8AG+6UZeJLSGvmH5pZe1hnxa7
	18zRwysjhoP0r9Lu2HpnR4Ous7tryxc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EvG7UJAA;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B3D860F3B;
	Thu,  5 Nov 2026 13:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78851F00919;
	Thu,  5 Nov 2026 13:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793884228;
	bh=4JVtXgjnsEuq37SFb/p1jbhOS50fULU4Fu7t4ksVFwk=;
	h=From:Subject:Date:To:Cc;
	b=EvG7UJAAFso5sazSELc3T7U8SeTiF0WumSDWQqvbbeJubVZRt5xkyIpRNtFRBK8Yz
	 eadccCdYVey0fBS06FLj6OAeQRxr8N2wXCMfAzd9keVqEFbgjY7DUOBS8W4ENcSYi2
	 0Y+5yUw8I1QnXBbHWgkAM9Xk7/7hnNuT9Zb3rQSgSUWxjadNHQR14gBNyjM1cwQL+G
	 Z8bAyW4QcOtEG6qWMxXHGfLuGWiteReZchluVqwS/4hrej0HAbuiFrh+Rbdlus1lKY
	 kk5kbbueWuE2AZqDy7zFrg0BvH0K9c0pNobYApBIM8xvVJV+jOZ+Q6xOBL9S9BEJSF
	 iF4g5KJ6Pub4w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/5] mm: limit pagecache folio refcount
Date: Thu, 05 Nov 2026 14:10:09 +0100
Message-Id: <20261105-refcount_overflow_stable-v1-0-70b9c655da3e@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADKA7GoC/yXMUQqDMBCE4avIPjeQpOqDVylFNJ3UFUlKNmpBv
 HvT9vGDmf8gQWIIddVBCRsLx1BgLhW5aQhPKH4Uk9W2NUY3KsG7uIbcxw3JL3HvJQ/jAtXUFtr
 W5qo9qNxfZcnvX/p2/1vWcYbL3x6d5weSn9hzfAAAAA==
X-Change-ID: 20261105-refcount_overflow_stable-542e024130fe
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Song Liu <songliubraving@fb.com>, 
 Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>, 
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Kevin Tian <kevin.tian@intel.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, 
 Steve Sistare <steven.sistare@oracle.com>, 
 John Hubbard <jhubbard@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org, 
 iommu@lists.linux.dev, "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3177; i=david@kernel.org;
 h=from:subject:message-id; bh=UI8M/ZLKqbJS5E9r1E06UCCyrA6rtpgRnEQYsXCV2PI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeNJhllz4v91n1qrjxV/3edtn8r9+VtnAxXUxNW5M1/
 cSiaSK/OkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiI7FlGhgf3grimRlw4XiR8
 eDOz36xl11/uWWy50rxs7b/UsDbz57cZGd592lpVPGWGJWc1o7uCpGA452cfxlfH932RefyQn0t
 iFQMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DFF7240007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xzmk5s378ezdpumucagyxj4kzgc3jj8c
X-Rspam-User: 
X-HE-Tag: 1793884228-56414
X-HE-Meta: U2FsdGVkX18D8/FcqSiHhEBlX38DCrWLZAbiJkg2go7QgEYE7IbNow6mPm+6LRFXwHtMVtDMh+8dQTpOAmQbKV6tdaaeGK+WzzV1LvNUU5SBISdnLJfn5cGIXsZLHQzWL8kQg/f4u05kpQmTKyUvP4CrhK+OPc6FLwrS6xXDpCB1QFabUleqqONlIiqgE2036nZFgd2+Nyxfc3taf17YX8W87WLWEVvl/b+GsVmPtm45Fd3VMghp+llrDQ+bkyILMugfhx20X+Okm692g3RT0WHWCBm8LtYgwNmE8Y09yjkQDAAFHxHK7rQ3lVCc+dpEiIYYU0GaxR48sq0qhHPEMvvMD3869M3ZXdlSsb+w3uXuaESUOFnJcxoERqMofljOtIEUd+Ktm9sPczRgdlYxy3ha2aiExqGTv+QkkNXnm3dIh22srsrGiixmBiJcoDWroLpkQvXMzLym9b9riVkRPBoY12agoRlQ6bEnFuJgGppC0X6jHuzZCb53EyEh1qKLQwz5GXPR6xxP1LXa2kzuQumTk89WbzWsU0UEY0JFNGuRsivGjJ516pbYsqnQwqjL0plW/94zAhQiBB24fPTCgSzjc+dK5a6RiiQ7ZcHp2wF8e4IBmY37sdWYhpmXviaWmtQgBqkJvZHKSzCoXpA+mD8hREbUY79vQbgfbf+4x6IgXYkQV6NbIehOZf37kDzyKCnQs7sfoXpTbnWWbBY59206/4Ijbu2deEkAjcEQnwDvRzyEIz0Tv+J0uBlvI8hcHGyvzjXgjTcC593DtPRzaPy9V/7Z6dknRnMEBMAKG5RgVz6+FENKbi5ynhNhxjrIwguJ9SYBZ0/imBCwcsgjwypzWQvJSBTOC+WJYNjOjy3m+sYldSxiax5qwMORW/6L3KnP3MKPa9hwN/yq1STi9yoerHOC80Wt8d8NuLDKlXrDkCXj7pmBEoZMyTg6o88Yjs9Q2iBCBfS5LKzWnoM
 mQ1sg3kU
 BoEdO0wtgOPYQQ1brsThLnhssfG6g09aIhmatS2NgtQ40jMj8LkSsHHsLFtcE2Vcv1y/nz7xn28kgD5+vyHorNsR28oVRWezPjTHqkkDm7HJMT4WxIU6esftCHHGuXecHIbAXukBecTo+GV6AI3cU9RellfHLE17PxR75/HUJcqygVbUQute33SUqAReOxuVymzAsvkVScx7HOxPox1e6nXJ9AE0Ud3YO7DE7NW445GEELGGagozdLAITN7NBMFSXM5Y6/XL1Yr9c2rEg8XuCc6DksFfi2eK3nzVLQyywDsMIUUzRwO5jL3eS0winJIRUQlah
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Users can create a lot of folio references to pagecache folios, making
it possible to overflow the refcount of large folios.

While we knew that one could in theory overflow a folio's refcount, we
mostly assumed that bad things would happen and it wouldn't go
unnoticed.

Not so sure if that is really always the case, and leaving that problem
unsolved is irresponsible, so let's limit pagecache folio refcounts.

This is really only relevant for large folios / thps in the page cache.
With anon folios (including THPs), we should not be
able to trigger folio refcount overflows (until we get PUD-sized ones ;) ).

It was likely a problem for anon folios as well before we had a
dedicated pincount.

Let's limit the refcount before it turns negative, giving admin processes
some extra reserves (to reover a problematic system). We still leave some
headroom to allow for some slight limit overshooting, to make the
implementation easier.

Then, we also check when splicing pagecache folios to a pipe, and
improve our existing checks in gup. We also have to take care of
mmu_gather, to not hold too many references when zapping (whereby new
page faults could remap pages concurrently).

This is only a temporary solution for upstream+stable, until we have
something better. These fixes will be a bit challenging to backport to
stable, but it will be much easier compared to the RFC series I have here
were we do things properly by (what we discussed a couple of times
earlier):

 - Letting the mapcount of large folios be a long
 - Holding a single refcount if the folio is mapped, across all mappings
 - Reverting the limits introduced in this series

I'll polish that up and send it once we merged something that can be
backported to stable.

Tested on x86-64 by lowering the folio refcount limits such that limits
can easily be exceeded, to then test fault (SIGBUS), fork(), splice and GUp
behavior briefly when we run into refcount limits on a shmem THP.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (5):
      mm: limit pagecache folio refcount when mapping pages
      mm: limit pagecache folio refcount when splicing into pipes
      mm/mmu_gather: flush pending references early before the folio limit
      iommufd: fix cleanup when adding memfd folio pins fails
      mm/gup: limit pagecache folio refcount when grabbing references

 drivers/iommu/iommufd/pages.c | 15 +++++++++++----
 include/linux/mm.h            | 43 ++++++++++++++++++++++++++++++++++++++++---
 mm/filemap.c                  | 10 ++++++++++
 mm/gup.c                      | 12 ++++++++----
 mm/huge_memory.c              | 24 ++++++++++++++++++++++--
 mm/memory.c                   | 27 ++++++++++++++++++++++-----
 mm/migrate.c                  | 11 +++++++++++
 mm/mmu_gather.c               |  5 +++++
 mm/shmem.c                    |  4 ++++
 mm/userfaultfd.c              |  4 ++++
 10 files changed, 137 insertions(+), 18 deletions(-)

---

base-commit: 02f72aa35c5e7dff443c62cd9964686396c8b201

change-id: 20261105-refcount_overflow_stable-542e024130fe

--

Cheers,

David


