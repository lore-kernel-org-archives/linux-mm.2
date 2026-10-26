Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5BA606A33E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 09:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c1sAZwdO
Received: by kanga.kvack.org (Postfix)
	id BA9406B05D0; Mon, 26 Oct 2026 05:42:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B805C6B05D1; Mon, 26 Oct 2026 05:42:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A96906B05D2; Mon, 26 Oct 2026 05:42:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD616B05D0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 05:42:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 28DF11A06B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:33 +0000 (UTC)
X-FDA: 85364287386.26.181B932
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 66F76160009
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:42:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1sAZwdO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793007751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/RI90jFt6s6Eh4bW/WHVCDQLbPUvPZ+hXvBqT9xgdc=;
	b=AhiZyFB+zyXIeqCepctSDfdpIHMh0kqhTc02CilSijLpKS3kB7y7o6jyNhn7dOKSSuzHBB
	AfZ5jDw3tsVU5H7UDQHjWCz3nfLkG/wEiWPsUr6dEIREPQ5dReY6OOw3qZYVxo4KxNGqih
	UEjhg+XQ13gk/kOOfwZX0rT9T6sdm6c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c1sAZwdO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793007751;
	b=44zBRJoOw7N0bOimfj76Kwoes+X70SkuqZkHlJp3XkpQE1Z55A60ubtATRQ0Xf4APdC9z1
	LusnGIw6xrHkmaHUjH1PKBRha7OAXEf6OO+zLr0aKvH9wKgIqBa5d5RFL3d3FZbjMlFrXl
	AkqIH3GKVzujqhnTBAcIiiONIkfZ+FM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 06CC46022B;
	Mon, 26 Oct 2026 09:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31FD51F01480;
	Mon, 26 Oct 2026 09:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793007750;
	bh=8/RI90jFt6s6Eh4bW/WHVCDQLbPUvPZ+hXvBqT9xgdc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=c1sAZwdOn//j+WRgSDK5lwhSRFxcmAQvjcKg1cQmn7luqsIzWO/lAyU/wqEyxg9by
	 fG3cEJlyEJmYeU+9z4qy530KQ6Y+bMuffQrzcWYxruV1/zHuN/nXIu23zS6S47cPM8
	 fNQIxIq5GTGU0SQmniWmmZpZGMNNKAhl9uTl8GNGwu603lmAnVDUfed4tb0nmK+U+k
	 XGbFMpwoeNJS2cbxdxYQsoCXLJWL/JQ8TOeeg/glU2jeqKvUidLbY7La0Zeosbf6/b
	 OU6cvL9uZra9lcmrFPFUMGynsmbInhE5iM1tfGHRdk2VPhqce5gcqLAPVwKRi/ADZg
	 ufYXRBBbpdt8A==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 26 Oct 2026 10:40:47 +0100
Subject: [PATCH 14/16] mm/shmem: fix truncate loop after boundary swapin
 failure
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261026-fixes_shmem-v1-14-703206d5fa0c@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
In-Reply-To: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1753; i=david@kernel.org;
 h=from:subject:message-id; bh=mrHTKT/tCNoSyP8HqQO+TaKIADR2BSuhhZ5/eY5uERw=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLuK4gv7wkK5NXW3Pfy9NKp3FyT1wveOLLpjvuOmOy+0
 ifbVFUsO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjI7LsMf/g990x6UynsbbHy
 wEOBBRGZ3GuzHwn5KDAe6pzgOPvT2k8M/9N+rNwZc19+EXPuzKa1U5+fsin3n3CYZWL2mvVdRvv
 nSrABAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 66F76160009
X-Stat-Signature: 46u9u4w577pp39yrp4zf9iuxmsqdstpk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793007751-320577
X-HE-Meta: U2FsdGVkX19vrgAn4qD4afVXObWiLkFvNSj7MFaf6uh2T7n7MWluaSPIDqMFS2sjue/awpUprJ5ihT2p0pULMDqtF6ToFpT1NifN1LwOqHEttvHXZQXEiyNngqmONWqvzgz3L5nBmggldTzPqrmnLTjY6RMnm54VpEHLg7pG5zGjsS4+dc6/JnaP4Djt1TFpZNjhLTT+RdkS1hSNwMQN5e3wyRnN1FtL6AKHXWNsa+xhW0Tpgof15ZPvhK1SlggFELW6UEi6y3UqOQi4/M7OKtxb27UsrVMym0BaEio32B2qdjYR+6NG/mWByX/r9ExooikAu2BDYAtSVgEAA6EQeHAvwpl1VY81cNT1/f54VIn3SCSJJHEMbxK+8YoYKj/OlzV9zvUvg7geCCkC0l8iJLfFhn8jOgZu0zRvPMQJS90V/0XkTOTXFw4StJ/5n0VRyU9pu4G1FNmekr0Pung6mCa5bjBo/pIwqeBTq71Nuji+cnL0WhBvPaSfIUJzsyyBvVR06q79C3xKfjQ70ogSPjowXqHCR6GiU/WnKu/GP21CNYYsyq5uOFAXX6O45MwV9uzQsnXfdy1OPwkRtJvMjvZ4c8y4VnvYraF7pMvb8I/S1MgW0B5l3sbmoUNZYKcX9YFXnXMAAyBiwTYxewIkcnBcdFfGs+e6acbVy6fJECzN+qgefOGpPIW7MAR+tdzyQdCCbOSYiZsDg71I77icTceVeZFOwFrcfBpDbhSP8KP4G+IgtjMCHsii687TXEWp0AuzFIOlpol0zBVMJ3Wt0xM2p27d6EUWKCtJcWeOvBlkeW/XZkOOM6EkLADodBn8maNRTBnxFckJPQBuHBjMNivmmgjiMIx+Wqrw9UnACfXS914Yw+gui0tl1+2+kQ/o0+S3Eq3NJAcDIHsJYEccDZ/Xu0ylGhBzNxLQg5/FCckxjsNmnjusvUsMHeiHoeAOfQFk/XHraM69llcK8/i
 K0KVq//U
 TlNokcIF8KTJp0uHSnX+K48sXVWGfM9JT1xGwS6pWDHXNI1ND3OiF/13yGvGIlRm0t0MzJlCCcfy1X77U39rn8saKwdSyjQpV4CIIclEzAvZNd+4Pp9FTu0+mb8soKjsQpPrmTE0PYwCusjja2fSxPzEHCPCmr95cxi+8PWLwaZoHdhx0zBk3JGN0csPmqAD+vGsTcrvzfZH+8Jcff7xjT0Ngms4Daq0rsIeQwJjBvqo6IPj5g0At1uKaBjBVH8cKgi40NRy4RGALsNgOyLGprZkr5nXWpOWVFriP2YMbDnOW9IfjyKMRMtFQgIkkdJAhED7S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If swapping in a large entry at the new EOF fails, shmem_undo_range()
leaves the entry in place. Its final scan skips the entry, then restarts
from the same start index and finds it again. Truncation can loop forever
while holding i_rwsem.

Advance start past the skipped entry so that a restarted scan can finish,
as we already do for folios that cannot be split.

Note that this does not fix the missing zeroing when boundary swapin fails,
it merely prevents the endless loop.

Fixes: 8a1968bd997f ("mm/shmem, swap: fix race of truncate and swap entry split")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d1716a8da9075..6b24b9d6db26e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1444,14 +1444,16 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 					order = shmem_confirm_swap(mapping, indices[i],
 								   radix_to_swp_entry(folio));
 					/*
-					 * If found a large swap entry cross the end or start
-					 * border, skip it as the truncate_inode_partial_folio
-					 * above should have at least zerod its content once.
+					 * Skip boundary entries when restarting
+					 * the scan to avoid endless loops after
+					 * swapin failure.
 					 */
 					if (order > 0) {
 						base = round_down(base, 1 << order);
-						if (base < start || base + (1 << order) > end)
+						if (base < start || base + (1 << order) > end) {
+							start = max(start, base + (1 << order));
 							continue;
+						}
 					}
 					/* Swap was replaced by page or extended, retry */
 					index = base;

-- 
2.43.0


