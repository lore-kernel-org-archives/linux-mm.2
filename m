Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1A7606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 10:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hKEZW/No
Received: by kanga.kvack.org (Postfix)
	id D384E6B05C0; Thu, 29 Oct 2026 06:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0EE96B05C1; Thu, 29 Oct 2026 06:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD9C6B05C2; Thu, 29 Oct 2026 06:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E28A6B05C0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 06:44:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AC131A0394
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:55 +0000 (UTC)
X-FDA: 85375330950.03.C134D24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D2421C0005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:44:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hKEZW/No";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793270693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/95lv6aVada0IifKxWvdrhbpIXNviWW3ADyrNE8l91c=;
	b=z5AkgJz7kKGjjWUEaAUtQQ0RCogXx8E+ZlPnp8m2SqxyH9x8+Ih0CX+bwYSv8lYAWM0R2+
	Bu9wedldbh2FE+TOdzZS8XdsxruO5BkhJ2c/KWyPEcOVHSBxvJbNyWO9BXBWK3dMYe4Gdn
	0TQNmyrgd2+JEq531U35vMKRH6z4M+I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hKEZW/No";
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793270693;
	b=AgCNg87HFnzzBN56tRVhWfhRMXLKmv7/5wtn63fdAFJhhBV5KjRoRHlZBaA+WchO8CJKec
	7hvrBz12tycc0aN1GSOIXmMUBc5bVH4C3VrUE5/2YrSd0ZCoGmw5VJbkRsp0xo7TCC969v
	TeQj9Z1ksCMAOItCnHkzoggTZLDT4fM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5B0742B44;
	Thu, 29 Oct 2026 10:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BDD1F031E0;
	Thu, 29 Oct 2026 10:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793270692;
	bh=/95lv6aVada0IifKxWvdrhbpIXNviWW3ADyrNE8l91c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hKEZW/NoFy3UQ8cF/iokzenKy88As7+rDs1tkqhAvtPrWIgSfKZVccTYUQaU/a153
	 pBIpsWHmOzrvlEuJWbRL3PpseIDHcugAc4c4CWrOYdV/8vVjD42IbzYJwIytB4pNnU
	 e3X7pksgyx/WdJbInFvU9HCYov3vPig6MLB9HhMps4nx7WpLUh+y9mCP8e4uVZL4vM
	 47oVA0JplPB1pJXZT68hCC3CCxjMYs2RJqKKEloTo7m9VsiErn5aELfYe1fkA/IH5F
	 Q4AazYf1xrTW2gsyWoCvhtJzYYDixMndIcI9UGfvghs39e7omE3Vo8aDagJKI6xumz
	 xJuxVACItU8pA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 11:43:28 +0100
Subject: [PATCH v4 07/15] mm/shmem: stop retrying folios that cannot be
 split
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_shmem-v4-7-392fc715d8f6@kernel.org>
References: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
In-Reply-To: <20261029-fixes_shmem-v4-0-392fc715d8f6@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1791; i=david@kernel.org;
 h=from:subject:message-id; bh=ZAjzOB+Z7IuIURTjUdGNPAA3MOXXkABgEGbnq/FphJc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIeK4dNYVP/5RhZam0gvNowdeFDg93ObdWJxk0+O2/5O
 5wyZ8rpKGVhEONgkBVTZAkKvm/w8uW62mo3PmaYOaxMIEMYuDgFYCJz+Rn+cC0rY4uLeLUl4R1/
 T7DsaZWJPM/8b3BKNrt0/2CYkm8YzcjwfeY22Sj56nWsXJIXbp01WeN68b1/3czCZotH9bu+8TY
 xAgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6D2421C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: iacxt89iaz4qykt5a89f383pfojcpshx
X-HE-Tag: 1793270693-738471
X-HE-Meta: U2FsdGVkX1/OQFFpYKVfX4Wt6JZnMU1ZJbxbsifJv/KBNpgg0YGc3KB6ehEkCeMtWX095hXXD76pRhk6Qn1mFoNMCGypjaz7qy7WX8sE3WI/cE3whZg7yTeFbFviPRbrJJeLEIDZUD3aUsTa+TvMbidoNZXbNqQky+nR/rJjzlmxZkymkobErLqqx7xIYYKZDemzAEuXZvElAlxmtU0G3lNPsCIe4uadZnA8UeP2SwDOAwkgFmggADNXJdoEBcmVcDEbPWo0qeMugXyxvB5pXB9mxwyEnsxidNOdkJlZFaW4zwS051EdLFncmPiaqcOGF+ztW2SXVXdqUPMps6B6w6hls1/tzMsrPF7WuDcr4PmWSHfrrO71lmCNC0g1Nwkr38+s6u/yEehm0tJDBlGnAkT5ZufkkjpNQ1ICOdtxYTY40yqaueVVQOQjGjssqcnedUIQOSYwPnjk/yQ71j/LNc5pLUr6lH04EcIb/trsUP+xsxeQHaopNYEVX23qZpuaGHnuNqrKcFC3JsXItSKegKUOlVhkUICZGRG7tj+kV2zakX3ziLRmhXmeiVrmdzZMtKrwpvf51dgAQArDJHkgYXixhq6tDXUlwZf4Nm6awqrl6hXLmcR9ZwAWA3nIY+FT6/OhQSiSMzgW67+Fyx15Sd0Je4w5XHx1VljAGnWfs7ijgC+h+i5AfzopgMREnRsikMTwMofll4+RRrNT2Jmpwt4bn4ycuUZhsR5D1H6RfCELg1f+cs1FP3ePJUjdN621nPbJg24Ce5tUbssSxxQRVKfSCy9PYjXolqF3mbtJ6IhqK2r/+PA3oBcu06K3+xzFk1Y6hR7dDy/uETr5Z7vmw5XudQF6RXzfuR5cBFQJOf1rcvGpGmJ6NTpMYJJlkkdAXhK80BoznS6ibLWm+t6IX7RdCNg6LbuogYFRnJWuGe8wMj2QBG28gDsg+v1iQK8xTsDC2V8Xi/Bs6ZcscNW
 HV2Otrw4
 U8ufzN9/ATT1mQICtjJYUJhCqZFwYwPhK0ChJX/iUTkf7CFJuwfPTXxoRYrgiqdK9zs7ExdZU8VXhtdJ7guEttfRlVvKT2DMd4Dtbl7kuTH1C+5qUhOuABgRhsB76VP/4jZXNTtb9DQ8ZKceA8oSFAeX/SUiu6eD6jWNVmF2DFHozCiiDcmmko32jVH9iEQbsyiSEtYZoWTX065EP5eOFOPvwqisYhE2malfx9ZpUjg4bwYuDVp+PrXVcuEeLNooJfvZdU7/fMOcnrdo6frxac7zRWz5T4EIIoDIWVsQlTrxAIUYt/fF2+cGNkGbmxLTy4hIn5TAHTN539C3kiZcZ0xokXWKIQnk3Phu9VbEZ29MMY0tN93dXuMnJC/XYwYm56KAQs6/WMeO2sl07b0ZEq+icTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

A fault or collapse can insert a large folio crossing EOF after
shmem_undo_range() has handled the boundary folios. If splitting that
folio fails, truncate_inode_partial_folio() retains it when it is dirty.
The final scan then repeatedly finds it because it restarts from an
unchanged start.

Truncation keeps the inode lock and ignores fatal signals while looping.
A concurrent unlink() can then block other directory operations while
holding the directory lock and waiting for the file's lock.

Advance start past the retained folio, whose truncated part has already
been zeroed. Do not move start backwards if the failed split has shrunk
the folio.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 55ac8bbe358b ("mm/shmem: fix race in shmem_undo_range w/THP")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
[ david: split fixes, simplify descriptions, adjust comments ]
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/shmem.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index c44d2dd71c89..af49d6bf6382 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1481,6 +1481,15 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, uoff_t lend,
 						index = start;
 						break;
 					}
+				} else if (folio->mapping) {
+					/*
+					 * Splitting failed, but the part in the
+					 * range is already zeroed. The folio
+					 * was not dropped, so skip it when
+					 * restarting the scan to avoid retrying
+					 * it forever.
+					 */
+					start = max(start, folio_next_index(folio));
 				}
 			}
 			folio_unlock(folio);

-- 
2.43.0


