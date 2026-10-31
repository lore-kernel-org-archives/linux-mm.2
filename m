Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3940C606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OcVH/BeE
Received: by kanga.kvack.org (Postfix)
	id 30CEC6B05D6; Sat, 31 Oct 2026 05:46:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC4E6B05D7; Sat, 31 Oct 2026 05:46:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184856B05D8; Sat, 31 Oct 2026 05:46:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E5E406B05D6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:46:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7389B40517
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:46:00 +0000 (UTC)
X-FDA: 85382440080.11.6C5AAE8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id A817040003
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OcVH/BeE";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439958;
	b=SKnvRlcbLAXN0pcmFSTVELyB/tmdPAw4mnL6OH4oveQAg5DpOmNajxcuivGDxezZ64ZDjP
	1ppjgYAH1YxgS9oz+NHFSL3g20VDhvJSFpfgZNmJzVx844wrdVlaw1zef35FQKAsXJxlbl
	pMchKGvbZZvOLDjNZKC/oVwppJJWhyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wISwi351T9RVVV1oXeQonBfVyTKFfK4XoWM4mZGU1z8=;
	b=lNfV9NhrjIT0ViZZO4iPJaX1qMbwZISGJDKg+BgCgBmEXCv7Rs5GY3DlCjOFb1msVzXCOP
	tjfPvvCjz0Hcr8gmhbzsq/xo8/LiPg4093L0Okyva3OY7eweIHrwKqjONml60rAJJKyx03
	QFSmufEtVOa9vWglOvK8x5NwWfRjXYA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OcVH/BeE";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E85FC41A94;
	Sat, 31 Oct 2026 09:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278111F0093A;
	Sat, 31 Oct 2026 09:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439957;
	bh=wISwi351T9RVVV1oXeQonBfVyTKFfK4XoWM4mZGU1z8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OcVH/BeEc2hYfL2FYGWe1OvmH8o+k5edNc4FHDUjc8QmLWMD9qEaA3739kvUYuIIv
	 NdEhiB4tuErpPCysmctpgOwiA1RyjWRiKmEBs4q/oO0aFyWb6QW2imFkeevKJ6/u6/
	 A5D7ccuqBCziN4Gk+eR3salFGBi6bsDi9+pKQkmS4CuDSUFnOvvuZSPJhGkhtRUJuz
	 hyaWctchXf7KHnMJMYfXCPdeKm59BqQ5oSysl9esxUiYfV5qJnQm09ojPLZu36HExp
	 qeaPCo7g8Ah2K2QCxL85rqYn6+orFN7B2pkZTZuUAVM5jv2YS9eLZFOLhcs/7mIU3w
	 4zHQWM0WMBKFA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:51 +0100
Subject: [PATCH v3 22/47] mm/gup: check for overflow when converting
 nr_pages to bytes in GUP-fast
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-22-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1366; i=david@kernel.org;
 h=from:subject:message-id; bh=kuHYCo8jZXAQ9XN8vjw93pI/nGqY4DS2NH2YO8khoeQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs94vWxtqPbuuB9vUk9tOlh+p4nLJ3bzr5mJJZUfV
 U4vWNkT0VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEtM8zMqzlOOtfm5t343jZ
 1o5lDTYVTDu850yesrHneqye5kuf74sZ/leL5UluV9b4zxeU2FBTZ/1S7rP6zpebP1huXfhOy1z
 gLQcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: dgia73s7ebt11ipq5jsixmtyy1qi4fea
X-Rspamd-Queue-Id: A817040003
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439958-852125
X-HE-Meta: U2FsdGVkX1/ordAIZysVrmp7bdXqzsA/TwenliU6ce5GDUzWIqUz/dqyYkleM3VhrfWp+nhbdtFRf3/h95t5Kt4czrc8DmCTED67saaLmCPxfTA/5OHaIETyHtlDVdybXoYe/1H5HnwLPWxdOe80Bj81KGZtloZoSaAql2g6tDPYky3rdrMp13bO4sPc9VHEjVqQR/RdrPbO6CREgU+CCA2dajbmOUs0mtLrJFXSvTVrnY1Zf/kUQvpnlObnq+H1TsVVnyrRYAoLlnBHP6PeINdSgozSjrlvw0TUlwm8gddxZkalmE+6e6jJfjdQuMydJrOls+TcOjKKysbWYDDeWj4YnJ4hPq05ic46EtoSFvPe5Tcy7iMzI/oPZz7lhuRXeOtGYjpiy/ryaabBFHHvZBOc/XudqFtSgOUam7aDBAL6oSaJ4YygyKDdf0orc3Gv51ERF8hytRiceFJ4HzAZetyUoSvJ5ahWQNCOvXdmWUp7nyOf3YoLIy90fJPCOkJLfMMf4E2JsoAfk8pZwSnpBLPCLuGZXXUH0/c+bTdh1lO8V9oDM71sPgAoBhhd+cRy0fCxTYwmFsZHIwQAdTr/YCcWZuO8fFcWBgnveearkMRvleBX7gZs09pzuolahZ/dq/7RGNLj/dcYb8N4yWey5STfpnpujelcTgZc90VXv9ErYl+AN+AGblxBYeJjNRO/S9Un4B4zswNbbS7lY9KcoXab0QI6zPBk8nGgzPAQjcGXda506z1bWvnsPqutiazHpo9AEKnbnlTm32Cnj+FwJow4FnWsvqcNGNYGtpxOJzEFKJ6Cat0zHTDOG1yOYXbHXinO5E5+nsIGJGPK351eYWtxcA9OwPlBywwYWoB6OLclWMCbgWahWNlp1XDm1vKOgRbKUpPvaSgtU8oXfzSBxoqMKYx6KJ47YP22OMt/OIAkSAipoAvXZCjPjWxKB2/2LNZdBzDId8O+WkuNFdE
 OrVTe02+
 Vq+vGn7ddMHS//jx8zbfeqi9UCm+CoRt/z5LZlvIOyFdNqo10hwjsL4hZ4HToyIC0jxhhOgYzFne0sLHae5XeQfo0Otc2Ubj1yTTN+C5X2pmki7/g7M5c3C23rAksjpqJJ6pyacHzxgPJV1gJAaf3HOE1XEcLN+pfv+VlnygOhTLDFz3kJjT6NZbkVAvXnl9kSBOz2bv9INOICIPd2/aUtd3BZBk7kam9SsVDTDQdGRcMdQvbuLmBmleoaDRt5ZxSX8X8RupesfYZBfyHYRlLe7Z/fa1u8nXOAp8JrvcS7KSXKQwhCwt1MnegHxHYN+ch3AgcjBPSlUJ2nak7C8X2k8qZfW++wLyBdJL4kmkIdKjS+cKWcYSuSF3uMEpzE68qpLMcl0yIwxiaCm8V5WOxlA6fUp9hKmEhRj/zYCT6vlCiII7OEaPACycFeoXoBZjOUprKbnxgE8sq511qucXaDJyyMYIB7SyyBf8w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The overflow check in gup_fast_fallback() only covers the addition to
start. The preceding nr_pages << PAGE_SHIFT can already have truncated
the length on 32bit.

Users such as RapidIO's rio_dma_transfer() can derive such page counts
from a 64-bit userspace length.

Let's just check_shl_overflow() to reject any such overflow with
-EOVERFLOW early.

Fixes: c28b1fc70390 ("mm/gup: reorganize internal_get_user_pages_fast()")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 1c2ac7c66c309..ba4907b352323 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3225,8 +3225,8 @@ static int gup_fast_fallback(unsigned long start, unsigned long nr_pages,
 		might_lock_read(&current->mm->mmap_lock);
 
 	start = untagged_addr(start) & PAGE_MASK;
-	len = nr_pages << PAGE_SHIFT;
-	if (check_add_overflow(start, len, &end))
+	if (check_shl_overflow(nr_pages, PAGE_SHIFT, &len) ||
+	    check_add_overflow(start, len, &end))
 		return -EOVERFLOW;
 	if (end > TASK_SIZE_MAX)
 		return -EFAULT;

-- 
2.43.0


