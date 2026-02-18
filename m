Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A7DE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C77A16B0092; Wed, 18 Feb 2026 08:06:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C223A6B0093; Wed, 18 Feb 2026 08:06:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BB66B0095; Wed, 18 Feb 2026 08:06:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A30426B0092
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40869140178
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:20 +0000 (UTC)
X-FDA: 84457600920.07.1FED557
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id AC54F160007
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m97p7nOa;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vPo+Be+veFC5KPTLspdZTZ5tCKA/X8GRwXN+qCObjJQ=;
	b=a/b3VVO0jZDJCHwv0CzxjfV6wjGdg+vxGDctiuG9ee2W2R1xbE0xMrT5fQmRump/jXjj4I
	TVwl0Yg9bHnBpdJC9x+P+D3U67gh9S9RoheU+zOSjKRem7dxjxsw4sKf0lZcBBKx5tj3Wp
	OvOGdP8X3e47u7QQHg/YagoFkcfaCQg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m97p7nOa;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419978; a=rsa-sha256;
	cv=none;
	b=aGE8M18cwwubGjsDYgD+rP0ck8qqKbSeUHnBENS02e4EJlrq91HkhonpiJ/YXhu2hJYeZO
	7mxstfKBfI9ldEg0Xy2TLFHBPToWCy53SEbxhP/ySzXmaa3tU8KJj/c7BItg2XMy0Sysjs
	+LF26nox3euH8Yp6bb2bz6mHmd56IX0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BCBD6132F;
	Wed, 18 Feb 2026 13:06:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3730FC19425;
	Wed, 18 Feb 2026 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419977;
	bh=3UR3t12nE06/3+BICKDW7qlGeal7dZwuKx3i2LXcI6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m97p7nOa4g/xsSww4ztleeUUfP0xoVMiDxpuIpsRdIxsZQVXeH6SafI4ggN8Ut3UE
	 V9qxQkYxadQx7jLe/bvKCMJaEYspRP43szn4B9MD/ODIgEeplm35Jjb4q9wccVHsb/
	 1Dd0bjp8bwRXPYEII+Ulcydb/fJQ+NzMYlF40KgFvz24cwJidnXfmvLJ48Ml4qoAom
	 lST7uoqOqwYvhSyOUhz6G1v2sb7teLO1dCVyFnPXqOPRWlGQYbFiw2VY30DBNH9G+c
	 PhfeLwn5xmSwbutRwhLTfCfrH2ZOhifLUiax08h68KCSU7lFmMnXudfkArIAUcagY8
	 NggmtlIkQzX9g==
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
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: [PATCH 5.10.y 4/7] mm/hugetlb: fix hugetlb_pmd_shared()
Date: Wed, 18 Feb 2026 14:05:49 +0100
Message-ID: <20260218130552.55727-5-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sqeex5ns9hsywniru4s43iqj1siefi8a
X-Rspam-User: 
X-Rspamd-Queue-Id: AC54F160007
X-Rspamd-Server: rspam01
X-HE-Tag: 1771419978-388373
X-HE-Meta: U2FsdGVkX1/VEQuDxi2Uzq0MSXmaZAs9PzqtnGPUvtZytLZwQCnABq3bDKS2J4ii5UYtMNs1ajsnpjcejCKTXhihXUIoazu0vmioHfGmz01kaIb5OSl3VsdQ6TfFpzDOhHPVYSzIHXh8/bgNpqGp4Nd8dnwgw4NoOnc8ZIwnVb0DKUCzLvdsUrZcgEZ2z/jb2NF2hTiWHDoLYHMcsZm52eeY1UU+TDu5dxnyFoBWnfQjcJ5sIvYsikqF+hwI5rMUdco8tMzQxpeHgrLwBAlYIcbw39F0wIxHQb1WhL+7exeBR3IE5MA0Gx/DO6jEEQAoYrWfLUzzsC6Krrj8MrXKMo8kLRzJdMJNrvwnuiFaR9w0lgVY3JnxHvHihxbzDOxB/wfm0b00/68yYAeUCCUJuRnDJ3h4RSa5EibKwT/IRcabTu6n/xub/+LQ5XIml0U3QX9FTLqd5wGrz3IDj8Dk9eY/srVav4WbjQQzO3VnhErM8My1sgUgQUlfvS5i+L3OPTzQ0OAotwqHnwvM+i6UnlAqB6dlKMLlR9OVv2sLVRAwV8Ju47poD0/O05As53ax2yNQ38ocCNYiyebIVXyy40uHOEP4G34h5Fp76MnFn4zL+XP5KC3oY23HEQNYUVPVTeqTWAZqF4OlEtgJXsfGD8XxVJiKMXXcTbRfK/DSWLOalpGB6I7WOaDmkAdy/Pmh0QM7F7O+tWpd57ZGgoIsQdtJEoPoFKXNTqkqFfCtUBpQw8LhF3GTM1saJZrH2Fy+/2UvooZNwhHl3BdnFJYVXY/PxJ4Nmq8iguKapkbYv4AOWkguqDZ5E7HWQTV2mtJHNkDJK32DkuDa6fE8hZSBn+YsLiKFPeubycVckteilbNFG6/qBAfXq1VOhfPC0jsJzw/1zOzKcmXWLltLDxVnVDUGQ04tZNUn/jYA+AjXv/0DPMAxSua+NxvrkTHgh384pR85Vw4sTEh0rNh+05u
 9aB2ePCc
 YOaH48OM34inMW0aqQEiSncG432DZ9ev/Awy+O/ny1sogw5chdxUS9Aq9NUinckrDPZ3RDmHtBDCag3uX6nSAFFte90CFR4JLaqbnrYGw35dNMYbvLqr4YSF2YagBwQbfH5Yv3HpCAJe6sgv8iTUanE9KkmlMQAAF+CsLQ2aD8B8orRMSoNqZzqzpPUL5fBcA7bnaOj0e6xQeTcw3emke9p8bNonLH8dmHRPkdh4VtYWdzPLbSD4PfYhwRuGMWIB9m396C9Pdf/Qej5UgH0KCa+KomJ2qouBA6Do4FG1ZIQaLtRpdUKwCRGbS/pWrB2TcNPVqfTd83kOH5fabJMokEeIiFhangSQpldbM8VZAhnmFvvAfKKheBI2LqNbkB+Enjm5ve32VPFRlRW3oPFx7ZbD108tkYwpwid4izIIOMNjdDoConmuTOrpKUTbN2jRq1XDIQIdFBZ9QzQWgWwWv8X+d0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

Patch series "mm/hugetlb: fixes for PMD table sharing (incl.  using
mmu_gather)", v3.

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

This patch (of 4):

We switched from (wrongly) using the page count to an independent shared
count.  Now, shared page tables have a refcount of 1 (excluding
speculative references) and instead use ptdesc->pt_share_count to identify
sharing.

We didn't convert hugetlb_pmd_shared(), so right now, we would never
detect a shared PMD table as such, because sharing/unsharing no longer
touches the refcount of a PMD table.

Page migration, like mbind() or migrate_pages() would allow for migrating
folios mapped into such shared PMD tables, even though the folios are not
exclusive.  In smaps we would account them as "private" although they are
"shared", and we would be wrongly setting the PM_MMAP_EXCLUSIVE in the
pagemap interface.

Fix it by properly using ptdesc_pmd_is_shared() in hugetlb_pmd_shared().

Link: https://lkml.kernel.org/r/20251223214037.580860-1-david@kernel.org
Link: https://lkml.kernel.org/r/20251223214037.580860-2-david@kernel.org
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [1]
Link: https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/ [2]
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit ca1a47cd3f5f4c46ca188b1c9a27af87d1ab2216)
[ David: We don't have ptdesc and the wrappers, so work directly on
  page->pt_share_count. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 1c03935aa3d1..0d3fece27031 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -955,7 +955,7 @@ static inline __init void hugetlb_cma_check(void)
 #ifdef CONFIG_ARCH_WANT_HUGE_PMD_SHARE
 static inline bool hugetlb_pmd_shared(pte_t *pte)
 {
-	return page_count(virt_to_page(pte)) > 1;
+	return atomic_read(&virt_to_page(pte)->pt_share_count);
 }
 #else
 static inline bool hugetlb_pmd_shared(pte_t *pte)
-- 
2.43.0


