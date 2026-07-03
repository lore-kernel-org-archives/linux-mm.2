Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4648C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F4E96B00B9; Fri,  3 Jul 2026 07:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A4FF6B00BA; Fri,  3 Jul 2026 07:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC5A6B00BB; Fri,  3 Jul 2026 07:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC036B00B9
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:43:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB7691204F4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:06 +0000 (UTC)
X-FDA: 84947279172.29.FC827C8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E6ABB4000B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:43:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uKpG9QTS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783078985;
	b=Rexy0nkNmPub3NuY/xYWy1/rMq2SsQRw3lCzQZt1JKlVE76EiguWvKOMrOBjKzqma7rjgo
	Qr+weXKIVPzLf7fuqJWRc2MvijOvwfBZwsAeT4LO9Rm1xCvWu6xkxlCeTbv5WgOmSFEnBU
	Qabikln3ZavvyIWkMANRvdcmMjamnwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783078985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhmPAyPji4IiYnAgpKt2XVKFZNBHGXgCXYcf2whmneI=;
	b=Su7liswqew7K247ocWjEZhfSdy+eKeFXiZ2l/DmGn9kHr5xKt6xbpNZbQNAm5nD81KTl7R
	jxDj0zNreMudpHOH3ejSTUVWVG8AS+R8wzSFLhzEftDbUj9Hz2HTRKiwFNQPVzK4FUkQIJ
	Jhi6kfQ/KEf+u2z8jOqq12H+n2LdbEM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=uKpG9QTS;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3E4535C8;
	Fri,  3 Jul 2026 04:42:59 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A11603F673;
	Fri,  3 Jul 2026 04:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783078984; bh=QibAWbZw4adH0rQMvhQv9lcIr1WFPi662truFhm4Ubw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uKpG9QTSOi87p1LOsj3dnWli+GqrppjCjNWMmEgZLXCJtd57TsRx7GWJ98w1ZVOAZ
	 20yIQYe4WsOHi148Hhyqepvl/DlVJN4MyKKvI5WdispsFnQlQaD+7fhvc0UOsbtErU
	 ReX/Pnc7lJHNnbHM3HH3YQyfDO/tChOi9OHrBpu4=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH v3 4/6] mm/migrate: use huge_ptep_get() in remove_migration_pte()
Date: Fri,  3 Jul 2026 11:41:57 +0000
Message-ID: <20260703114202.365553-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703114202.365553-1-dev.jain@arm.com>
References: <20260703114202.365553-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1h9xwx8t4ftywxj5zbdxiwp8nqpusxpo
X-Rspamd-Queue-Id: E6ABB4000B
X-HE-Tag: 1783078984-681740
X-HE-Meta: U2FsdGVkX18rg79vKMC+Bn336FLASwlBSdPiOeqXPPCkSsRNGEtD+Av2BarZb5CUrWtmtrI+I8pJ+OSwsWzcz1M1waygEQWV1rShQkjBOM3JXTOshJlsltk4qsD8x3O3ueTT9JndNvH8j+r5zTSSUvCoIIcVQ2XmUn+a12VJ3uKMzYb3LPFFoeWkNpQpxp5OOY7MgpKgOgxE4vZVBOYjt4zyexZr+GSPS4G+A/8xFXuv4oaPWw8yoaw0U00RcGqK3035ujHteH5xZzSC7zzragqq+EbMVkHafzohLpT+rUwUrBOrTZ09lSoxfiYvMRd8rg1pjaY2j1fbFghwSm9u+mPoRCG44QnW/2ALOh/ZaRPyAstbCU2EaCdN4gaVCI+Z31tbTUWVA8j1l17TUHevz/N/e3/YWkxMEX/iKgzjuAhFYnxiXBmX0osdu9e0929t4nPE2zuT+o0KX7lVOD5/DpnChDyDQfqk0n+vwKycr1gPPJFep+hiic5GqLVD6Oy7FGq0NWm54T6kG20Gc6mOsafqLlI0xrd4faQnPYJmSMXUC6qDnhXrO1HuuuIuUrUBuCRScMb6tkJFpqNOvoG+UG0Fnfm5AW64vJnFCpW209eBYbzucFsrDN/Yi+un1VaqbzX4A4MnDAZOowlQLmbI2IY7PLk6igg8Ia44eCuFtcRNySceSwpcHyQu6hvnF72pM9XzvIQ5s58kb7cXlbhNiZD6yWiQD3vgBj4zxKYEVQXPK8T+GB7eY1l3EFp/X9rC/xq4cor1+1yHzdMM5gyth+L0MhmY77iaG54/D/v4ULDRF28VN+bK2tB2731eNe9SLxKaL4Je+Ho824mhvQ/hi3ep7To5u3RVs9PuWfpdXr7/1dIaOILcLYq7G3emfXt+3/9TAu2zNnpkZF00kEscwIJcTMVuTeiXkZy510OavhSGq9zzO7QVjrFwqz0rlSYOZG9UmpnO3EZAIpuQz7X
 kaD4qI+n
 OUGLB4WPh/AcDLIGldFCOUE7N+ErWN7jThwaCxGMsAs3Ann8aEIpW0COY1hUUCXY7eHeA+sn9erqm+CjXmioOGaJ2QjcAZGUHNMGJ0ixyJzQk55vyQVecU3No2nknAZ9RmOKSzEBwUPlYrX7GoP3mL/DSfj52fS43094cUVHERpqJHk0VtGEmKpfBriFwCdEzVhwGYxDs7Wsnuq80A16DlxisxDG+RSEI7tDtRMTEuKS41C3ySA5a+9l39IpA7DvkkRhH5CE3alphbTDWtzM48JRAWl1eU7CpsGIPp0Rz9kWB7wgV9z11C4bt015MhJC6VwOjuJsNBN7FusYuKcY6HFQAuD0+jZBY0fc77iApB+3qIQEWJwckZwbAJvQT6MYeA2F5nAEEMe5JVeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

remove_migration_pte() converts migration entries back to present PTEs
after folio migration completes. For hugetlb folios,
page_vma_mapped_walk() returns the pte pointer to the hugetlb folio in
pvmw.pte, but the code reads it with ptep_get().

On arches which provide their own huge_ptep_get() to dereference a huge
pte pointer, accessing via ptep_get() would cause pte_pfn(),
pte_present() etc to misbehave.

It is not clear whether this has a trivially visible effect to userspace.

Use huge_ptep_get() to dereference a huge pte pointer.

Fixes: 290408d4a250 ("hugetlb: hugepage migration core")
Cc: stable@vger.kernel.org
Acked-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/migrate.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index d9b23909d716c..c65f0f43df7eb 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -371,7 +371,11 @@ static bool remove_migration_pte(struct folio *folio,
 			continue;
 		}
 #endif
-		old_pte = ptep_get(pvmw.pte);
+		if (folio_test_hugetlb(folio))
+			old_pte = huge_ptep_get(vma->vm_mm, pvmw.address,
+						pvmw.pte);
+		else
+			old_pte = ptep_get(pvmw.pte);
 		if (rmap_walk_arg->map_unused_to_zeropage &&
 		    try_to_map_unused_to_zeropage(&pvmw, folio, old_pte, idx))
 			continue;
-- 
2.43.0


