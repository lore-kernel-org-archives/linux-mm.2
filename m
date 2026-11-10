Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6909B606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aOeOHpYh
Received: by kanga.kvack.org (Postfix)
	id 62B7D6B05B7; Tue, 10 Nov 2026 02:43:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DD436B05B8; Tue, 10 Nov 2026 02:43:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F1FE6B05B9; Tue, 10 Nov 2026 02:43:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 331B06B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:43:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E4E912085E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:43:35 +0000 (UTC)
X-FDA: 85418419590.01.B225A96
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D08A20005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:43:32 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aOeOHpYh;
	spf=pass (imf31.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794296613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=yIKrqUa698jtkq4S+tNE275rUsH+jw4iBZHp6nea714=;
	b=MFROWpxRLhmACEgtuvEMDW+n/Fbu2Dxsz8Vpam4Q0EcOSR6dsSlTqrLNgn2F5TM+u0t+82
	DykqCJv0gUSFgNUI3KLQ2+G+cHt/x5nB55NXDidaBLfsS82DylulFObchnm7umAAH9d01/
	GmkL6Ad8xrRZ1MP5jErbyjjOAho4pQY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794296613;
	b=nrGpq8lln+VU/V7BJ5JZEbnG4cSrdtHSDKyBZR2F9rNp7l55Elxg6I8AuSIlKCXpgHckjR
	M29ZkGm+nRcFhFbtzzc88FKhTfkh/GBjvkDanf6ap7ZnGEVLxpTwpn5Hnfz8xs7ujblhuj
	oA15Asij3j9NTeeb20KEQUv/I8sjOyU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aOeOHpYh;
	spf=pass (imf31.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PqgEJ1qFzNTxxzLoVkBM63dh+frDqe4TYsbrUm3uZw4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794296611; v=1; x=1794901411;
 b=aOeOHpYhP4JC5moGBDMfC0Xadr1TZnY18hEpwkIH/tKibJ4X9IS1g3lIjbFEI6l/2Lvafrt4
 VBLSoGU5m2Dx5iOUydtuPRQ/N/OnSNUqE9DIJ11/bfgAIwrRKSR0pE8QOcA9VkI3g+C5XhR2ee6
 qsmiud3Q4h7Kx7WPVxjN7fLQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 9b3c4fed74b348b8;
	Tue, 10 Nov 2026 07:43:31 +0000
X-Mizu-Trace-ID: 9b3c4fed74b348b8
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Qiliang Yuan <odys.yuan@gmail.com>
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Huan Yang <link@vivo.com>,
	Wang Xiao <xiao.wang@vivo.com>
Subject: [PATCH v2 0/4] KSM: introduce only_merge_zero_pages
Date: Tue, 10 Nov 2026 15:43:12 +0800
Message-Id: <20261110074312.219847-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: iegbm3rmqr11x1ymorhihw9rru3yczyh
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1D08A20005
X-Rspam-User: 
X-HE-Tag: 1794296612-62279
X-HE-Meta: U2FsdGVkX1+kNw/rzN7c3x9cAXYBRon9wPy6NxfMlYzW21PN5m1R0lAtkt4H2jSbIsMwHjbNSGwzLocbk0QhRCDeBLf4w2lOyzfjvGAo3qMqb5bIHx2kEBQX7ga03/8iJaYiy2qGDafcRe4H1/te5IBAWtvVmryMZQRkrswwuKEXcuYyxaPE3JdVMibBFwUwD0gu0KX6Qb44HTQANGM2I/vOUphNLP5hJhBEauRvpuJwt5AGGjK7gMrKrYG5RH69JgQEEFrZvay3kWuJlYxTo0qWWAwejLo+G5mtl6dgdIkCJCj0W8BPF8zGWCS+9PzDbYcA/QIuoLR9Kt/9UsrMaJNt3U3YyGB+PWal5z5WTE1mHtkA6Y3fTlQkx0jD5RFSzMRNHq4Gyz7K8BvVHRoqenNeEyM18a75FvSXRKv1JF9pQ6uGU3Jf5jPDQDghmEmIoiqtzyVsNOp6AUxLJTsj/0w1aIcE+r4xTTP7o7WLpJm6H5A606nTGwDfgEpvVG6iCNS7izoTHnIPuDaalNf5h495PwtjKR02RioPiL1PbhI1pq9j2bMcyJK3gji05XDnzEiw03u8rY+JUjar5tJe6o09dFpUIEqSbZR5yXNMP5sO0QX378u86YrpWYM2sfc5yRQNF36b3XamQGYcfTJevVPB4GBF3ibDg35mRFAt5ZaWKPju7+cyLGc0pg9h0I3Iwo1aMBP6CdRShMXPa0AZhTX9zKfRNHAgpucO4XbRumFQquuFSKaFkO/oWxfvouQ0DkMrHIXxrh6RnCExa4AQBxpMHxj+6XhZrPfed1Y/B1dMfJu+1VmPo2oFnHra5D5xjZCD/WnVPFT808V/EKlc5J93/GQGTcG2XqDNNQlwHEDKbIkJbZV1BquEiTh8EjKr60B6UXFI7jd4XvEzsW+b8n/lA7eoLXL/9PEfqdl1NK42HHrvpULMtMPrB4a8CKI3/6iB/S0Upt0ch8HEKBX
 bIf58hcv
 NU0/qvq1+OXcoYDRzaTqazftjWtEI8gxAYf344ZDbOAVBHQ1IHVjmvexZSfREjzPC+KcIVuYg0PKEZnkhiKNXXafI3/Ux9AjWogsgE3XWfYQXOgBQedqzxrKO5XFbcYUon1pVzuWGnIVm47RPMUabuod4dOYmXLTRpAbvFcE8ykCVmJMe4/xoQndgkx2pzMDIVEyy4EVOrlBntYK9jy2SPK0Eax1hEiyCVdN/hoiRBnmJgyyH0UTZ04ZQJQmmibfQgVECQbrtGlxWQJmIsTG7a/exNUqS/XcNRQ5PqkZvzTGxDhIx4RFQQa2vO/UCBYIZQq9C3Oj0ADhI8GxTd356oQTNzdMZw2AZKrk+O+5Va4jAEGdULCLZJVfu0ctWXtY8EcjiAx7FzML4kl6PiyrDfVuWKZ8qD9rthcgoBHhIRfblw5pMVREfn9iFUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi all,

This series adds a new KSM sysfs attribute, only_merge_zero_pages, which
makes ksmd merge only empty (zeroed) anonymous pages with the kernel
zero page and skip the stable/unstable trees for pages that  carry data.

Patch 1 adds the attribute and the early return in cmp_and_merge_page().

Patch 2 (co-developed with Jinjiang Tu) goes one step further and skips
non-zero pages already in the scan path, before an rmap_item is
allocated for them, which is what makes the mode practical on
large-memory workloads with mostly non-mergeable anonymous memory.

Patch 3 consolidates the ksm_stat readers in vm_util.c into a single
ksm_get_self_stat() helper (pure refactor). Patch 4 adds a functional
selftest.

Changelog
=========
v1 -> v2

- Patch 1: Take ksm_thread_mutex around the check-and-set in both
           use_zero_pages_store() and only_merge_zero_pages_store(), so
           that a concurrent write to the two attributes cannot leave
           use_zero_pages=0 and only_merge_zero_pages=1, a state in which
           ksmd would scan and checksum pages but never merge any.

- New patch 2, 3 and 4 are added.

Motivation
==========

On an Android device, I measured the KSM savings potential on 15.7 GiB
RAM, ~1100 processes, a typical usage session with several video apps
running) using a userspace survey tool that walks /proc/<pid>/maps +
/proc/<pid>/pagemap, deduplicates anonymous pages by their physical
frame number (PFN), and hashes page contents to find identical pages.
Key results (two samples taken 10 minutes apart):

  Category              Resident    Savings (upper bound)
  -------------------   ---------   ---------------------
  anon, non-zero pages  2.9G        67-74 MiB (2.3-2.4%)
  anon, zero pages      -           281-424 MiB (9.5-13.9%)

In other scenario with a MySQL instance from huawei, there are around
15 GB consumed by hashtables, which contain many zero-filled pages that
are eligible for merging to reduce memory footprint [1].

[1] https://lore.kernel.org/all/2a642af6-b97a-4f24-9889-1844812de4cc@huawei.com/


Xu Xin (vivo) (4):
  ksm: add only_merge_zero_pages to merge only empty anonymous pages
  ksm: skip rmap_item allocation for non-zero pages under
    only_merge_zero_pages
  selftests/ksm: consolidate ksm_stat readers into ksm_get_self_stat()
  selftests/ksm: add test for only_merge_zero_pages

 Documentation/admin-guide/mm/ksm.rst          |  40 ++++-
 mm/ksm.c                                      | 149 ++++++++++++++++++
 .../selftests/mm/ksm_functional_tests.c       | 135 ++++++++++++++--
 tools/testing/selftests/mm/vm_util.c          |  40 ++---
 tools/testing/selftests/mm/vm_util.h          |   3 +-
 5 files changed, 327 insertions(+), 40 deletions(-)

-- 
2.34.1


