Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8035E606A333
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=KGECeb1j
Received: by kanga.kvack.org (Postfix)
	id 8EBA16B05B6; Wed, 28 Oct 2026 13:17:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89CB36B05B7; Wed, 28 Oct 2026 13:17:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C406B05B8; Wed, 28 Oct 2026 13:17:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 544D76B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:17:30 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD22C1A019B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:29 +0000 (UTC)
X-FDA: 85372691418.04.6D01963
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id C63351C000E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KGECeb1j;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FC7uHBzaVJ4BUk5uLlNk6IJEROP7WjcJ9ABFqisilS4=;
	b=MDRQqX76jqSl2tgAyY1Q+6hWBLAD+NZJJ1CI/bN5S6JIVq1RsdCOmwTOj9TZdqCnmH+k2t
	t9qKQaF3vANeIZXwoiu/6vOi3Ny82ofJ3JTprE2050sS9+wgYXfrYgfb6cXA8e4oYeSvkW
	9fKsM0BRZmSe9GC1FpwQ46cBycCxcnQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=KGECeb1j;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf21.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.224.48 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207848;
	b=NeMc6qfIe805eeb0brUIgiHzSiWpIRsDgSgV/72fV/ab5HktHvvB+9RJk5wfnIRIzHoxo9
	IbeFNNsXcmoSoNrI1qU9659pHkPq/SKLL1hUL9C5DNhr/4RVKkiim+zJeBsMo20Eb/ZNr+
	KoPcB+2maBs3ZzYGX38r841jC4uxXhk=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-679334baa1fso1582555d50.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793207847; x=1793812647; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FC7uHBzaVJ4BUk5uLlNk6IJEROP7WjcJ9ABFqisilS4=;
        b=KGECeb1jv9hHnLt63s3SojjMHCDot3cWl2rvPojY9M19E0zkDUiBouoFqx3ExEzbx4
         8V497zWzabXYvZvS3W3EMSrSmQ9+Btpw65aPGkmHWxJVojVoMS8k2YgxK3NSz8+/dKnX
         QdR+wZjVdkkoOqyWJlsMYcKYt+p2y5S76Vzk9nz52r66NIeeUylMwDtd9UhQTITfabCl
         /VvYNyOtqwIUUsTwhGwTpiR9jReCenfLs6j7F9forkl4RgAMngnVmqHV33OBVYagXWu8
         WDGkM0NltRCYf8oqdVgX6i+NxBrEpe0Ka70LX5/yFsD6lC02NBsg/9eLk+Jm/fMAZ/r7
         rlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793207847; x=1793812647;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FC7uHBzaVJ4BUk5uLlNk6IJEROP7WjcJ9ABFqisilS4=;
        b=gI0jMcSWXLKUV/YvCxVN6/JnYSTr+LnpSwHGg6F5soZlUTR3PRlR3suuQV4RCJWh04
         vA7yVjuYLHUNRaoqd/ijU4mi5rMlWK4Fo6+0c4h+e0vdUlH5uLpU/d+Kt2PJIZ9PMImT
         ZOc7w1NQlupqVpcm+Zzu3toqZSkynt5UT/n1v2TAol1pBzWaoWz0v0EsccDzZED0+H4R
         fjunTeLV2M02u/ohbzYp/pnnI5NvJG+6cpfexgE7kOfYXr1NcaIa2Geb7g3TLVPcOC51
         PsZEwpOjXeR7T8arGXCZrPilzxVVWzrnSiYpZA9eUnChmvhgPHRyi7sxpnf6QwrF2qlc
         J48A==
X-Forwarded-Encrypted: i=1; AKwUvByVlVC6wWfa57JFrdHWpXwnNiGRVgzW95rjBZYxag8Q4j36rl4vjyZKkcG8VtVlshjkA6zagIWFxw==@kvack.org
X-Gm-Message-State: AFq9FYKHW/fYU5hN+c/XtztlNkgE5PZZTEKtWwb4B3rh76P8/71Rv6M8
	sKPk/C95Mq9KJQD6J4JIMH+z6GTNMIUswwMxMJAkkwUJ9GoxL6YxhPlsd5X/oxgxLH4=
X-Gm-Gg: AYBFou3F8kaZhPWePLQ4RnRtFarErCs8R8+A0CCHl+bSLYrDdCZXfRb7MSxMpxmuoxQ
	HdRHsCD0Aap/7QXVFa8GPFhONTLLKPiP6yJ+qxhpcXsIb5DwOHlOvmu6SZPkTUoQCOxzqIBqmVW
	sle2DOvUdjWzG5ktpKYcJ4s0wH4lYtPMZcSqF7gqpZv0F852AhWo+0EvTfLVHajJc/RfAKzmAgS
	SRgJWLsnkB3nezBsiB63Xz23EPukngoXgmT/2RsByYpT/SvqBPEc8lWg6AlccQu2EEo3TyjM4cw
	5Wc2Rwkm2DStAM1L93U5G0T7phIiG8VDyaIq1Dv/bn5M4y44TZ2DEC/xc0a7cQjU8647z+fXfuL
	4j7nZGMn/oQD3PJdQvLSr9FB65Mu+F721AHx5TdHUW5RRVdI1W3pPCFLYBqQjrhyMYUKC+A1xzT
	O4GGSBdcn4eWyVq8oA0S22cWysLud6Gg/iC6ayZvsADkpSPYl36TuQ9uoZjuqOGKK2E9Ad+8OwA
	GYBznDYMTulU9ndmQ3pP0SBa+awonbg22/Psu171bOcrHHbqs2ehMVoWoXlLIQ8jOZj02owZlXF
	UFpVV3Qc5RbZt50ODhU/FydetY6v
X-Received: by 2002:a05:690e:1a5f:b0:672:ede8:d0a2 with SMTP id 956f58d0204a3-67a7bd62e6fmr1340912d50.93.1793207846761;
        Wed, 28 Oct 2026 10:17:26 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a10a7dcsm2116484d50.13.2026.10.28.10.17.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 10:17:26 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Salvatore Dipietro <dipiets@amazon.it>,
	Christoph Hellwig <hch@lst.de>,
	Dave Chinner <dgc@kernel.org>,
	Matt Fleming <matt@readmodwrite.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm: page_alloc: fix reserve access for non-blocking requests
Date: Wed, 28 Oct 2026 13:15:52 -0400
Message-ID: <20261028171719.2043421-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C63351C000E
X-Stat-Signature: 9x1moehrue9s8iysp5h5iq6dyen8uoww
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793207847-658301
X-HE-Meta: U2FsdGVkX18/ScDvnreqDe6JFj0Ntv6oZG5BXvENc3p3LxYh5VlqxHvlP/5Zw8DpdIOkGLFUCG8gf67J8WttxE9TSG/IfsLgQn0HUHBDfFx3lzkxsbJfXWyffrm19eu6VSmKJDDlU9Aet8irEtmNfmx1Ibt5yHrGwLTDIXam0jmq8q20cRfFbGkPcqQCsP/edTOBgAjjZMat7ihbpe3MhnfBi5FvRnmS0e8MTlOQTtDLagdjtpR4XbRHefyHBmttYwvgb6N+HTvZm7WvoeokG+Ds6myxfZ/CqXtPL5mNwucitrSSR+dkaEM4tjKJb9DTDBfhncUVVXBPNXQHoP8sI6N3U31tNWJ/7A/K2zpe1/pJVGfsihJ5PbP88xrMoxLS7yMuFSlj6UBqKvEm784SdqT6aX/FtK+9bVxY2Q1iXbDZlqxpxiEem0dINWUlYbWDyc6VKN7kXJ3rQ86F195Bh3nvNLAx6U2MRuwP6fPM/hZIr1tBgvjDYXjst4z2+ctkFd7Kbc0ccVJR1tNCBKMzG9/HiySmIJ8Mqq4W+INU/aUd07g/NBV4L1L6TmzXRT8Cw06aL2ct/yJ2bI9vD8/FRkua1ELCLjRt8zSbMDtSoOFfhFWX28eMyiU5AZqCFYmfqZp8t8A0amX9wh7b46VTUyYpMVgb18WRzf9Tum4qj/PB9l7BXvwpAsnHRSb7dBnblIaziFvZwaluw2kE+RwwghZtIljjwZZQ0lE7HYMg9jhxG/aSJv2L3qgIdk28jHp9L9vaDCHLUsejtZD6YZN+MKS3eRCdU8t2MzRRdTwr7Tl8LeAyR239/OZ6VVB3yGLJcxD4Px8vmrPVbXBT23THrq6MngumgYq2tprGP95C2/b4Xq//CspXEeCIZs0H6nittQUjt6G70MDiqMhJkY7qADkrcTqkbK2MAhdQ0vGk00mBwuKz9qLx03FqmCIsQ6mFclOBBmDRN8wJMQql94b
 uPcL3mn8
 //zTkLRlTtQ1QUMPqD+vHazgY4RAOzE821I/P1kcbwCIK0vakH5ZtK8LNnxVQtg23a8YosmzPq02HPKDKJ+nMkrrT+yZgKYjTnXfd3mYH3MyUPD1SlqoEf/JYJ8SVdatxeq8bPj/QNuF6ecDCoC4LB2CKdE/eJKwtiahTIEYgARIvqa/tzCbPqWQywMfR+gjIuZ6x+tVZ6XZ9C4SBncTPzvXMo46O0aa5BAM3QjSH3I2Ywle1B1Uld7Pal9ocamsSFDpk+HwtkJ7iObO9aIm3/iUA2buWcrhPrOniQ+m2Kd0MeiBmZr+qzm36B40v/9NHjZe1uflV25nphFjQa62pTmIIl10t/qQOMuw0QYVl7jTuY/LIq6xmbExRVHiqTBY5sVw/ZHZHyZcpevrNn29hbUiRLZszmaEDWALlqmWjjtrQdOMi/x3zaiQyCqzVVl3cgRGaZAQ168sZcLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Andrew,

Two fixes for how non-blocking allocations interact with the
highatomic reserve. v1 was posted inside Salvatore's thread on
skipping direct reclaim and compaction for costly __GFP_NORETRY
allocations [1]. This is the same code as a standalone series, rebased
to mm-hotfixes-unstable, with the changelog clarifications from
review. Salvatore's patch is parked in mm-new behind these [2]:
mm-page_alloc-avoid-direct-reclaim-and-compaction-for-costly-__gfp_noretry-allocations.patch

Patch 1 narrows which requests may physically take highatomic pages,
patch 2 narrows which requests may count them in their watermark check.

Both are prerequisites for Salvatore's patch: it clears
__GFP_DIRECT_RECLAIM for costly __GFP_NORETRY requests, which turns
every large page cache folio allocation that reaches the slowpath into
a non-blocking one. Without patch 1, those requests may fall back to
the highatomic freelists reserved for atomic requests. Without patch
2, they count the free highatomic pages in their watermark check while
being served from regular memory, so they can consume regular
high-order blocks below the min watermark by the size of the
reserve. GFP_NOWAIT requests hit both paths today, so these are
existing problems worthy of their own stable backports; but
Salvatore's patch would widen them significantly.

Patch 2 reproduction: a GFP_NOWAIT burst under memory pressure can
drain regular free memory to zero while the highatomic reserve sits
idle. Measured on a 32G box with an anonymous working set, swap, and a
full 290M reserve, three synthetic bursts drove the 28G Normal zone's
regular free memory to 28M, 0.8M and 0.6M against a 60M min
watermark. Swapout failed its swap table allocation inside reclaim,
reclaim scanned 13M pages to free 200k, and page faults stalled for
tens to hundreds of milliseconds. With the fix the burst stops at the
min watermark and nothing else happens. This was found in review and
reproduced synthetically; it has not been observed in production.

GFP_ATOMIC order-0 requests have a milder version of the same problem:
They are entitled to the reserve but are served regular memory first,
so the fix there has to change the watermark check and the freelist
order together. Salvatore's change doesn't interact with this, though;
fixing that is left for a separate patch.

Changes since v1:
- rebased to mm-hotfixes-unstable (2026-10-27)
- 2/2: changelog states the bug was found in review and reproduced
  with a synthetic burst rather than observed in production
  (Vlastimil); notes the remaining GFP_ATOMIC order-0 problem as
  follow-up work
- kept the ALLOC_MASK_ATOMIC check inline in rmqueue_buddy() rather
  than adding a helper, as discussed: it pairs with the
  ALLOC_HIGHATOMIC attempt above it, which is what makes it order-0
  by construction

[1] https://lore.kernel.org/linux-mm/arFBWvzXPYrKuIYi@cmpxchg.org/
[2] https://lore.kernel.org/linux-mm/20261001082152.2879289-1-dipiets@amazon.it/

 mm/page_alloc.c |  4 +++-
 mm/page_alloc.h | 14 ++++++++------
 2 files changed, 11 insertions(+), 7 deletions(-)


