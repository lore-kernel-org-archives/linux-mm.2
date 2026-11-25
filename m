Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3BD0606A33C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=NK6wMFG2
Received: by kanga.kvack.org (Postfix)
	id E89AF6B09D1; Wed, 25 Nov 2026 06:52:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBD86B09D3; Wed, 25 Nov 2026 06:52:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB43E6B09D4; Wed, 25 Nov 2026 06:52:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99BC56B09D1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:52:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A155C0E6B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:33 +0000 (UTC)
X-FDA: 85473478986.12.645AB84
Received: from mta0.migadu.com (out-84.mta0.migadu.com [91.218.175.84])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D71040009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NK6wMFG2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607551;
	b=XWmj5fFsVgr6VpTnh/gO79AKDVhGv/Q7uz49pPWJAn92g5i8wpcpEg0oTyTbTbmvuE/lQp
	azoHBvgvT/0vFzALGogw/NKqxd+XZqCz/q8mcp4JsL/sZqgDZEeYHziC3W4E2ApXtMt1vU
	DA+HJ9MecbJqjyBowh5AT5DpZSCZWQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrUqEMm9z5J4jaNe8INgEE9sMz1REWYf5p9yYZc/oOM=;
	b=fH6znzbgrcFpDbCeoiSwaAVLvCVjFhSMQ460VBGKiSW5l4Wr/HiuEtQGpN2jhY4pee5euQ
	eRz+Mpnxj8R3bVbZgahjVlnZY3gomxpE8uGjhmLMEURZQ+drBBF9b1oLhkHvTLvDo2lEXt
	MycrzDc20z0JqBfZCAXZIZ1PTNQPq88=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NK6wMFG2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.84 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5O5gPTvKN1uioPmvTeSAALfxSrjKERJLwEwvEZL/R/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795607549; v=1; x=1796212349;
 b=NK6wMFG2CnowpCQWyha/PYUOCGpTb9mBxbTOdErQJ5+gnbIwAW+gX7KgP+CudrRkxCH07DxJ
 j2AIyLjusTqpEK8L0TW8MtQ5FYCdBi7A+AAXZyatznj0Bkr2SYva30drueldBwo5opy5kEvPjfM
 Cc4RvsR83++wdnmvKsCx+ZBQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id dab8a477befd0327;
	Wed, 25 Nov 2026 11:52:29 +0000
X-Mizu-Trace-ID: dab8a477befd0327
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v4 3/3] fs/proc/task_mmu: account device-private PMDs as present in smaps
Date: Wed, 25 Nov 2026 03:49:59 -0800
Message-ID: <20261125115014.4014507-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261125115014.4014507-1-usama.arif@linux.dev>
References: <20261125115014.4014507-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2D71040009
X-Stat-Signature: 7c1x91yr9me1t3pg5hme97nbsw9h6ddo
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795607550-127777
X-HE-Meta: U2FsdGVkX19uKt7Vf2TJAJg34yZccQYEWQYvJaBTXlJ0DD1Z/UcWVLEmuo/xfbM4I+3Cx/5QDtGXSyFZKDZenWkhD22PWgHqpQnn7VMwxo7IMUofRlTtRNPigt3Bx3VketInHIa6kpsdJoRZuUb4Uyk76Nu6y6Q2C25uxTgWjkt2I1lo2F01wGHkMBxrgZO+p4Wx8xaLzKwRqvSVrlBRR+YBjhMYkXY0KNuLcMjH8wt9IzLDmbF+SrtnHE3tUEQmVERlP5VOQtNfbsaf29HM+z9+4qy/LFrZxbIlO3boamT8uHx0zIqcgaWL91Z83j94XfvLQl/hYe2GDlZiy3LAU3IgmpAJRcQb6totaseHJoOvoFnJnBQoUz9C3jC4cZPUa8l5641QYQcQAlwWGHTAnMz5NnDJ0kHvu2CgI4VsPdNZzPI5jeV9QCjaAJwnmVMDTVxtnR/a/YGNBquqzVmM3lrrbGsiM/GD6zftmXvmqYIVkmdEf29DpBbzWKD+8hqZaNkSFjIvhWDafY0t8hL55xMtunggcwzP9FYLxfULpdNeCeSiWQDoX/jbvSAQeg/gmIZ0HfvAfwJ3rfm+jPDMaqMa2lzmYJC9sZxaldgaYxDNuVsSQiLHdvyywDpMLErSW046WxSE6FcoxhKaopxxSvywqvyQ1U1VBNkjNMI8pC0SnEwFMifiX8UiR8UB72mSoE9GJHFw1Zk44VEDuRAs656wkuf4fWeCd3ojlDQ6mob00aI2/aaoeTg4lVNfbKHefOxmxs4cD+dTYdhLA5TaRHjeNohsPkHb60up7WeC7tUiWZI4XlNsWaX3YQOe6QCuDCyXOgDoxEs2Xx8lSRAytUjYtQj8RvUy1RdIyuQi7fsHUU9V2sEpoZDkHis0RWBG9PwHxHvzO8yIRtMG9aI/YGsPdnEJnYTo/rcgsunHKCt7Xb1wYq4yliNq5AOLbhB4NGpmM/YOX2/Ho8EEmY3
 EWh0MJcn
 EgdWWeKEIpko95KzNhgcDUJojlg+khehHfequsdG3/8yyDrtBuhLGhxrnlD86dR5G5zF7RLkwlhZf0+tlHKYYmf7luAo2y9UGme7hwPcSP9VK87TePhEJAG14NPtlQps0Wg2Xj8ldnsLOAzitQWqPbeimBFxgcbH9t8isu3XIZQw3JfY7JMzKp31kVWxHPoa8QxKcBY4w7l2oH8WsmtiOycthY35DRa7moSerCtQjQhO5GCkffCM7wzizGe+ChzDHLrUkC9rVhRc8F+0JHrfP4M4eFnR065zr8JtzD9TZwf633xrcjjE/eJ+cJKoWKT7Hp7R63811rVPH4j+u7dPYT+Ez9uWp9s7YzUd7/XhQB8cL8hoHGZJ7ctqS8TF6aakZ678IvH8m3VZcUjGZs+3guH+LaRwrdX7rs0Er5/lmM9it3Lgr3O0ClSzh7rBQDwN/I/6+BoAyvcvk91VtV3gW8hxr4KUqVeiznExvTe3BpEJoibmePr9NIMBI/lcOl2u4VkAcUBLeSoydT2ndjpVLM1BpfKKjZvtVe04lLno9LMuOJSovsf5C3AZ+AJlPqIWOHg+SLkwgGlbTFRUcK9G7qkmg/TDrEHL0QP7t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Device-private PMDs represent mapped pages, but smaps_pmd_entry()
passes present=false to smaps_account(). That treats them like migration
entries: mapcounts are ignored, PSS is charged in full, and exclusive
mappings are accounted as shared.

Match smaps_pte_entry() and mark device-private PMDs as present so
smaps_account() uses mapcounts for PSS and private/shared accounting.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 fs/proc/task_mmu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index cf1732935c73df..9017b312f404ef 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1034,8 +1034,11 @@ static void smaps_pmd_entry(pmd_t *pmd, unsigned long addr,
 	} else if (unlikely(thp_migration_supported())) {
 		const softleaf_t entry = softleaf_from_pmd(pmdval);
 
-		if (softleaf_has_pfn(entry))
+		if (softleaf_has_pfn(entry)) {
+			if (softleaf_is_device_private(entry))
+				present = true;
 			page = softleaf_to_page(entry);
+		}
 	}
 	if (IS_ERR_OR_NULL(page))
 		return;
-- 
2.53.1-Meta


