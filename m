Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADBDE606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gSZfw6Ng
Received: by kanga.kvack.org (Postfix)
	id D4F4B6B05CA; Wed, 28 Oct 2026 05:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA216B05CB; Wed, 28 Oct 2026 05:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17416B05CC; Wed, 28 Oct 2026 05:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7BB6B05CA
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:56:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1EF5B140BAB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:29 +0000 (UTC)
X-FDA: 85371580098.21.4001263
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67BE0180007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:56:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSZfw6Ng;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793181387;
	b=5FmM/aLGFyz3wMrINTEmMThaRkazlp6n6x2WHDZ6GASMhHGHs17guHeAjTaIgHRYjODOjR
	F8/FFm/Q+KxwyDBMkYDvM+DYaRLNYuGKm3+4ShmdqSCE5Lwj7tKSKyiyvv2XjSHHBhVb1P
	45RHaVSgy61cminbeTXbtz8MBJdR30w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gSZfw6Ng;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793181387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTFrfwyATFzlD7oFB0faIDoeDkfv/OEfzxq3WEUQcw4=;
	b=B60ySQKe3vM1cyjJ/YidOGw6wYOqZ2czb0P1O0GZbagLbTHRLWH1OwR+9GFrhsv03DUCdu
	pfGu1cTSzuvUFzkmuBZnJvKQFr6Kb1ysgJ8TJ/8Kk+XO1M8IwA3TzSXl+oAS2LaqzEJSWd
	1Pwy9w7hfCIyy1wx1sPrB2GH5Tk3ERw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F2C71600C8;
	Wed, 28 Oct 2026 09:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720F61F01825;
	Wed, 28 Oct 2026 09:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793181386;
	bh=DTFrfwyATFzlD7oFB0faIDoeDkfv/OEfzxq3WEUQcw4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gSZfw6Ng/724IXC3V4Uz1Dru+nw652GarxIa4RjukdE330gBrqtLmOtPKK0NnQqZH
	 Jjt7JL/+CNPrGBQLOO5tTcijNCPDPYmq32RTTe1wJh4F8C1uw6gl2jxsxyHOePlIq+
	 9ek8/6ojBBVTvBx9lN9V4nNaQp4b8r6aPNx9+9OQsyp3nKnU9/WMCAPblIwr0cmy96
	 sc55V00HaUVuSJJA2haxiCzMyhcg2GwrwOv8c8ypj7VQpJ5te5u8px2ch9mro0wtWU
	 LXW30ysiwpxErXuHQxgWchO53hxpRAEGMSd5ceSRYZpuJhSnaTXfrFhR7GiHK/b1a+
	 Yj62kCUuzjX2w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 10:55:06 +0100
Subject: [PATCH v3 08/15] mm/shmem: preserve data in clean folios when
 splitting fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261028-fixes_shmem-v3-8-4ce3baf2db4b@kernel.org>
References: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
In-Reply-To: <20261028-fixes_shmem-v3-0-4ce3baf2db4b@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3639; i=david@kernel.org;
 h=from:subject:message-id; bh=qRxbYmef81DsO+iuJnbFf2IXu09HY8IXlLHGqp7GkUQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeHmt6V9t86qfEv3k8NyOM8x9MjFjlsPzWvSvzp+iHO
 Pcqlsbf7yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi+r8ZGZ7U2726yqfuOI/z
 mIEMT5RNsH5CrHlJ7MWtXYcmbpwjsZqRYWJNlYuwmOpEhaVaJ6fNnvXtZjVTv/SK7n9VHguaGT/
 2cwAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: jir9bzzt44ipniufxj8wm93aeeoib5ee
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 67BE0180007
X-Rspam-User: 
X-HE-Tag: 1793181387-441508
X-HE-Meta: U2FsdGVkX1/EMIAMza79xSBcANgS/+2eQ3rx4IVUCe+l4HyEoXEscxHeIfEZ2Dq02qHlm0qdInSVTstWnHUDOUI0Qr/CU0P0g12fn8a1paME85a0WYtRNzoanhUFNWGE9eihMfbWN6IgMctQMYvzOlRH/PoPR+N08fyA1Ut0edmGL/Di11q+66nUuJI9+GFw3ylTbS5Q5ajzI5v3UCQeTqtPY5tbFC1UmkTXAr2oA1JB01rkVjBxQNpm2OySD7AdDTonunvvQC+EjvkNAsH07BxXrNFKJltGCViYFPRgZ+1inANuiwVr9fkLbdqnP5bzkmE6wNEbVF65yh5ZCUn4DkqGjcqjgyQ34pVkOx656QpA0PDNJH2da6gO9fb7o9b27tOH5gYHDTSs/f7RK3s3j8GzQ0DY+Eq2gTZB6NAc6NL8OMd0A7KvIotLOrwWm+XKafjpEQadzpcD6zi808K4JEg3OE2WwPn62viiCGQ/hTP/qID06k0VFHf2pfC32qSzwIvVr2XBXOyKLEnz8FmFCK5j6ynxNRmWONK4s2QaYTRMqLHcM24BMLCDQ5sZuYOg7yLSFlgnZSSPi0a8JpP/iaQJKpgWpEVT6Ice4FUDCpt51dweRzPeHqRerIV0i/4BG7HPCkjBFrAF71/vKQrgKg299Z5/l4hdizNwNeqMhwrQkBveCj4NytW+F/APIAG4YNnWbdxk+pdWx3rfxBg3R/F1nMc1+Vozyp0nF81DDAQp5eVTclueLeguzH0iyCJGFkN+0lyGwTtVk+jgFdmd58+18qNI9FEXon7T0+iaucwxUrOL7hH+BgqFsXKJreyzbD+MaowaC2frxAJji5kZOgAfVvq1gF/sFpYdLZrBOpbvVJJlAK5uzh1f7DXa5XSnmC+QBm6t+/xf5g8Sjc6akZTzufmsVuLEHOU86niwT13D9j4IqnUJc7cpz7Ei0BSmJRqL40Muk7tmX/XeXcI
 Znwvi8Pd
 AJ5C246a6CgWDLJC2IPad6ymMhsaUJyL6o6C4evThLoy0APjdS7DMdk2vhvuNaXMPcIIlWdB/I2x8YJDantakHWnrytBatFmoGEg3qiEcdzBGyjzWdwdL2CxsKwwUbDBM82HcdTY2nguWXqzL0mNa7xtP57B25DQzwWw7/DX1g+tQAtYC939iRczDrHf08XhvpVAg3dRx9cHrup/Lc6acB3UsuydFTA78laogHLaJtSVRjSTqLo1vKf78fS1Nn5RrPLZCoPoBXoP9b1fD3U3G5ySbbEpb+JHLv5QjRAB0sjJxMB8fKdH3uWGkWqtjx7tFH4eaxgGfhD54aM9gWwNRH2WQw5eI4GyV9CX0RLbzlAhmj2Ld4/KWsaIQS9xkeQ8ZVDtmzbGUxgMMWem4WIt6VwnQiQbTKx8sR5H5mFZjPZeHhXdBzJZhbL/2H8YlDHXG/RTm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A shared writable mapping can have dirty PTEs while its shmem folio is
still clean. A read fault can install a writable PTE, and a later store
sets the PTE's dirty bit without marking the folio dirty.

After shmem_undo_range() has handled the boundary folios, a concurrent
read fault into a hole below the new EOF can allocate a large folio.
For example, on a tmpfs mount with huge=always, the fault's offset must
be within the file, but the allocated folio can extend beyond i_size.
The final scan then finds this folio and calls
truncate_inode_partial_folio() without marking it dirty.

Splitting normally collects the PTE dirty bits when unmapping the
folio. An extra reference, for example from vmsplice(), can make it
fail before that step. The fallback unmapping on split failure excludes
shmem, so the helper still sees a clean folio and drops it, losing data
outside the range.

CPU0: ftruncate(fd, 3M)                CPU1: MAP_SHARED, tmpfs huge=always
─────────────────────────────────────  ──────────────────────────────────
i_size = 3M
shmem_undo_range(3M, -1)
  first pass: hole, nothing to do
  boundary folio at 3M: hole, none
                                       read fault at 2M+x (below EOF)
                                         PMD folio [2M,4M), crosses EOF
                                         writable PTE, folio clean
                                       store to 2M+x
                                         PTE dirty, folio still clean
                                       vmsplice(2M+x)
                                         extra folio reference
  whole_folios: finds [2M,4M) folio
  truncate_inode_partial_folio()
    zero [3M,4M)
    folio_split()
      unmap_folio(): extra ref
        → -EAGAIN, PTE dirty bit
          never reaches the folio
    folio clean
      → truncate_inode_folio(whole)
        [2M,3M) dropped
                                       read 2M+x → refault → zeroes

Mark large folios dirty before partial truncation in the final scan,
as the boundary handling already does. Exclude failed-fallocate
rollback, which must discard the folios it added.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: b9a8a4195c7d ("truncate,shmem: Handle truncates that split large folios")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: simplify descriptions, adjust comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 50d526edc2d4..f52bab8176d7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1464,6 +1464,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 				VM_BUG_ON_FOLIO(folio_test_writeback(folio),
 						folio);
 
+				/*
+				 * A shared mapping can have dirty PTEs while
+				 * the folio is still clean. Mark the folio
+				 * dirty so a failed split cannot discard data
+				 * outside the range.
+				 */
+				if (!unfalloc && folio_test_large(folio))
+					folio_mark_dirty(folio);
+
 				if (!folio_test_large(folio)) {
 					truncate_inode_folio(mapping, folio);
 				} else if (truncate_inode_partial_folio(folio,

-- 
2.43.0


