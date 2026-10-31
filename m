Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00AB6606A32F
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CxsFcgDy
Received: by kanga.kvack.org (Postfix)
	id 180FF6B05C8; Sat, 31 Oct 2026 05:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1588E6B05C9; Sat, 31 Oct 2026 05:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E286B05CA; Sat, 31 Oct 2026 05:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8AEE6B05C8
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:43:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7660F4026C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:24 +0000 (UTC)
X-FDA: 85382433528.23.E22E0BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A5EF61C0009
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:43:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxsFcgDy;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439802;
	b=oqcOFOblqyEwNgB0Q5rnqojfQnQpueI6jBot+OiCz5wiBppJ89o7HC8ypPs4CBJKntnVbp
	iuV2N8jdjG4zfRGX11a0aZ2DQus7OhTBNtbLPJ09XsYiFS1xEAf07nP2/XCI88WhHSc583
	jUI5DwfZhEXEFwd2VtwL/msDJAledCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgO1WtfTPr95CMg999FmZUV6ZtgV/+NdH4f6NGhd5j0=;
	b=jLIDwiKmEVSY7UMM9mlUhePv3wrTJcUGYpTkzOgf3FeqxO8kw2gtS3ta3GI0Jluf15K+u0
	Frcjdyqjw1YcPeUv5TjT55LcqWAMEVeb06DrePZd6Rb3tILYHvbFLvi9V0erRllhT6fkl4
	Q9ccxJayAGDEEoYFluxEOYnhuNWPcos=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxsFcgDy;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 442D2600D4;
	Sat, 31 Oct 2026 09:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 160C51F00919;
	Sat, 31 Oct 2026 09:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439802;
	bh=GgO1WtfTPr95CMg999FmZUV6ZtgV/+NdH4f6NGhd5j0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CxsFcgDyR62puXwpfrdBVjYlxXqi56LRd0wVMMbXZa5WFwuvsy+6B5cy3b5Iwa7MG
	 8sBreHtjQSLv2LeLQKpzyJ9OA/zafCF1rZfSEe71N8/KoTuH72Iv5RrwCIu6BR776N
	 rit21O2a2/iegjkgJJmtCXLN/B5tjBc0jHK5yfrE3y3//41Tqx3IWR5oe4TS+os+n6
	 ptEh7dACU7b2BPKFq38dpUCDEsrJ22Xstg+i7L5YBJ9fCPw4qlIKnuDlvaG8jeKsdk
	 BkK2l2ir4IGtFTyrtwd8Hn8khr+C9Zv5YUX+w0Yu3RfTm9WrN67lUNWU9CeYw8a5vf
	 ObyYSDr/u9RcA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:41 +0100
Subject: [PATCH v3 12/47] mm/huge_memory: fix livelock on device private
 folio
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-12-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2310; i=david@kernel.org;
 h=from:subject:message-id; bh=rOFEKHXFU3ik6VWKIWSfoeHTdwlufJwdJhailtQlKpY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/za/NTTZLZMb9d0VIwTeN1JKe3lyNXr2ZuQ2vQL
 Sd5S7uOUhYGMQ4GWTFFlqDg+wYvX66rrXbjY4aZw8oEMoSBi1MAJjK1geF/tMmjs8UW6zzCmsKP
 8PM9FLOuXFwt+GBBhUqxj81F95jVjAxT18xRsTObx+3OeGvHkv7eWddSHXf02q6afunNbalWsQ+
 8AA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: xabdxsmsutruixr3efqgbjnw4dxsx3fe
X-Rspamd-Queue-Id: A5EF61C0009
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439802-845991
X-HE-Meta: U2FsdGVkX1/7dfUc4YwWkkqHy8ptJM0tg8FNE9u1FrwqUSEKYc1ZOS/Ic/UULyHrSicW+xeDabHMIfuwJ6619QLvRib1XP2jXB7Jl7IX+69CKtJ4ChpGCQcuQsr5J12v7dIhX6bczlLhsYwnuDVUZnmKF+VDXGbMrJr3JFxri1NNJWcljvS6+VUjIwzGeBd0eRqlrtVLIPa2CDq0SqL/K1j9ekaBOtOwhRov0kO69+wCm3VelLLaImTl4vudoXKA1NMVjDxxy6LjtyIu1/5XXnstORwxmP57xfh4vUqx5fswRZ0mQL6IC4DDYryUTxU3rbmurtXTwAs5HNQxDXVH1lq+Ua3Yp72YwufDo6nq6q22lGijJmlpsuCbv2bMctLVaVTAMa8tkBFHY+/0BGvMHO/9CMCDqhDwsuSYQEGVTSGkplPAHQyTYB55VpNyDErpQIgusK9h20AQhuc1p4VIOelCKZqKAOPXocg9d1Y1kMd5hHkrM6r7bE9KmUSDL3fqtOBwB/8KQn0YZo7Vxzu34PFBe1x5XRHu37kvL4dTI1Lxoh4QyWriC5b+zqZrrAv+88U/ddJkIRTaKiNXzCAaxTQI7UWd3MZS6ijbrGTllVzs97MFlhS3T4imhUjXBxvgcEerhpvivt/9SrfvTFek1KIoNTbFhC5Yx0Mh/Qt2jTJpVUrS4yiNE9P2DJPrlg5f4iZ8e7BPmXkLUq6mNB/LkLhdiGhebksINxZ5ULsn8oEa7K7KBakz/fjK2gFC7owBHDFKoNTENN030in9d8aFJF9M6cOwgO0v4xUjQyXS/XY1DOkCHyLofpNOP29f5rIcoeGGUeWEQt2c7KMkmvxeqFHTshOMUfev9Zj50YKDEX6unUxo0MPnDKY+wLHGH3uALJcwxZs7Pybp0O843ZYhoD05tbrDmdbVDcZfBG+bC2NmvyB4tSgaNmgjtzTL3a5ZrI7tHV2G9+T7b/9j+AC
 Shl43eDO
 GZS9ivgnhvPmclu2cljH68erhoVQWXzBCKp9mSPWY1I2MYg0rLWFFNPEGFT3FIyZ8F2BarI4ifosW3vDdRsEofwVjY487qA/wZm0jL8GIk3fi4EB6Qogqh6kO7T1JNcaWrr+pAj7iB5pZ077u6UPc893UnYaKdxqr86UVqrB8e5YRXiEfB1jYIBhV1txCE//K5+x40JLaM0/K+18QNIbl1QfsuAHx0fFocVm0yyGGdaRFLftqkpaHwNCkQvmO9FY6qs43cZ18QWtWPeiSrIVupBN0C+CugqBLJnftga65KmXoPjHBimeHumVKgUDXFKM6NM1D73FU/lw4XpsZeeEgAAHTArX2j0wrABBZbIdcWMMF26HK46nxhZI8gwAQ+xESICmdMBTCHslveLiZ8wyl+3a947JMQCN+J0TTlBYj5Z1In2bIG6YhGgvDA7NyQtwcsn52yLh1Ny/I5xqRSxwRPqQfB57q4FXvOudsBIMtcEGEgRYKXZiM3Cg135sGO59gUI0JLyiAdGrm2T9Zzdx8vEHOIJgIAlEMM72GAST6pVNPVak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

If do_huge_pmd_device_private() cannot lock the folio, it simply returns
to try again on the next fault.

Just like we did in commit b570f37a2ce4 ("mm: Fix a hmm_range_fault()
livelock / starvation problem"), let's wait for the softleaf entry,
which will drop the PTL and wait until the folio was unlocked. This is
precisely what we do in do_swap_page() with device-private folios. This
avoids possibly livelocking.

Update softleaf_entry_wait_on_locked() documentation to clarify that
device-private entries wait until the folio is unlocked.

There seems to be no compelling reason to backport this to stable
kernels unless we actually see problems there.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 4964099163d0 ("mm/memory/fault: add THP fault handling for zone device private pages")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: simplify patch description, fixup softleaf_entry_wait_on_locked description]
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/filemap.c     | 4 ++--
 mm/huge_memory.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b04be64a5069f..e85a4114d2ecc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1395,8 +1395,8 @@ static inline int folio_wait_bit_common(struct folio *folio, int bit_nr,
 
 #ifdef CONFIG_MIGRATION
 /**
- * softleaf_entry_wait_on_locked - Wait for a migration entry or
- * device_private entry to be removed.
+ * softleaf_entry_wait_on_locked - Wait for a migration entry to be removed
+ * or a device-private folio in a device-private entry to get unlocked.
  * @entry: migration or device_private swap entry.
  * @ptl: already locked ptl. This function will drop the lock.
  *
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 283c4bc8b927c..2b31a425c7a32 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1500,7 +1500,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
 		folio_unlock(folio);
 		folio_put(folio);
 	} else {
-		spin_unlock(ptl);
+		softleaf_entry_wait_on_locked(entry, ptl);
 	}
 
 	return ret;

-- 
2.43.0


