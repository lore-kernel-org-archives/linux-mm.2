Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1D83606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IF7UNpYa
Received: by kanga.kvack.org (Postfix)
	id D361D6B05D8; Mon, 26 Oct 2026 19:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DE76B05F0; Mon, 26 Oct 2026 19:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23BB6B05F1; Mon, 26 Oct 2026 19:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98AA36B05D8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:28:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3418FA8588
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:35 +0000 (UTC)
X-FDA: 85366368990.03.F0FA491
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6647DA0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IF7UNpYa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKlj3iVdxa80tI8axGYbOkgCnYK7fspTKHlXYvaR2aI=;
	b=NCqf8AFp/CosHO83YM25YXsADnj1VLqyHRiQwWxeDixhRcb7yU1SzRAKEl4tl35vlIDCMU
	1rNOga/eIJXT708Wt2lUAI1ZPc6It0Wdd+DOX8YA1Xw/BGRnx7SXa5K7DXAfXRcr1TqaLV
	rM3/yHHW7v9c6MJiOE5j48yHgTVF+ZI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IF7UNpYa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057313;
	b=XBsBHA+EqnVypdmEhNE7k907Ouk4ewyVelOlNDkSkozLzxWRWC7XgOVsBLs2MuZgQcK+rJ
	CcIXT/pDd9SkrfbbYlf8s9mdNkcYOCvEHnpwO9RMmsMgXfdAGygi1CAMQP6YadsET+x62Q
	A+PhB4CndRnwIcPCRQITp8yFPYMcKH4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B49E540DA6;
	Mon, 26 Oct 2026 23:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C3A1F01825;
	Mon, 26 Oct 2026 23:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057312;
	bh=bKlj3iVdxa80tI8axGYbOkgCnYK7fspTKHlXYvaR2aI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IF7UNpYafd4KinbAs1yEkkzghUj/D3H6lcfEypHVdc8O5mJ/le53JbzB8PXIGDBZ2
	 92eHkhrsCMv3xbBPQgIrrR6h04i9Hzcb7uymxczaT3Bairn2RgNRTJslpdCGrtvOt2
	 gGGMSduqcmRf6l6ZEjkKV8KGvZk3TzPQSFa5cfL4jZ4rTy7EpdN8tAmItoI0jZfBeq
	 mRsOTgGOGKevkd8l9Z5v6l2DRA7JHhLmeUEhDmQlcmfEOS6+6Xyh168s1+PpjNpW/Z
	 Y5VwHZ1A7nLhFNOJ0TJlewJtDw/sGFXYMfvNX3bI+oOBUubWGSeZf9xih60jKvsFJg
	 nWblBWTTYdPlw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:54 +0100
Subject: [PATCH 34/46] mm/memory: reject remote COW faults on PFN mappings
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-34-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2202; i=david@kernel.org;
 h=from:subject:message-id; bh=iQuj7gPdQ9im9u/p2aFC5RRjFYSkqwBMiK+uc5Slg5w=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35++9LPovWW5/yR/+Qn4LnnxaLHaroe2drv0FKZw2
 L611nxR1lHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBE/ikxMrS/ZVy+IDlP84+D
 2u2XR0odt3OwqHyeEbtwitOb9ZcCnYoY/nvc/cDSJvRmm8HhzxaPd9hO0F/morJkqktsWscH5jN
 zbRgA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 6647DA0003
X-Stat-Signature: rrj11aaso53in4xbjhr8dwwd8qwd7kgi
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057313-718982
X-HE-Meta: U2FsdGVkX19Ti7NNG8NAxYniy9bD/KndTSwhBRahjz507YXCk94PDe5IyiRF+6gLmvzxp4MXsJzDEzCoYa3Ugbt0BS448MpCmnhmLLOYA/JazoQ4puUVfQoaHi16JAxAVf0tbseEsBpSw/o4sQL8kjuvE/HAsCJJF4+YMomwjrisn37zHAIvTnCGHHomULkfkCdh37jJBTKOvjwoD4JMtPDo4YAuM8uS6nTKCcmzXNS4CWhMFOAAD78lyHE9xOwjBeOpbcCC+bX6zvDncBADu7gmPA8FfDGqliF1vMTq1gib/EFqpZRprPVZ+qZT4Bp+ONQEeOf1Z5f0e8zCsqmHTIHg8B64u/FrJdNSSdKxgNNjKAvv17e3fLWC8973sGGFivOkHg6nQsrP/uiANssRMQqPshT1xByJNBXqDLQ7lACdysTWmX7stpsBWdvKNIjO1PpOuGoxGkmtHDnY9LrJhvColuj25k/usX8dUaKjwikNwpFFj3i2kGa2xCvxh5rnXa+Pwiqr6Qe2ddA9l0d8Kv/f866pSAxq6fH30a6afMggU5lzy/JgxmY7TVUANGUYcAzwFPm6k0M0hkSFwQx00ZuSiIyGDxkaIaw9dx+mjXIYluRUBNym4WiYi6z1woZ0wMJm3MA37lN198JIN8Q5Pzdr1eMWrusaHNcunT75AgGXdzlSTzHbdYaByttix7DhBt6M3+qZymD2uxla+9L0/mgBfkaXq/XVqkY05HRxxNrJpdJZ2zbj+qQzi3U2tC13gcb5fC8MfIVsr/hzq1Rq+8hPjlTBqzwGREqsYBHD1umTbsWkqvP8SCLS+Rks+HFidVyu8A6lAvyiISvXbfd8Z33UmWK0rsl0JaaL3uSMcQZ/giNIluN1qAmRW9J5YgnNHbPYXX581ltLhLX46An7p1dxEJOmPukPvxO35GYD7HY52eyIeUTTXZIYEsvOk+gBAHWveS+32pI8ZJvSCLp
 thwZlwmg
 l2i0/duEhxxnh/FUx+ajb/w4eMyWwjajBZnhbBOuwXFE6myl/Y0p6CVoR1y+l56jQMx32Y5p6i7y24oNzsoLxCHxt+LnqzD4sm9NboubdkelUXfYGtY/DgUzq1QJjsXDOtGrty1PriDMW9o1QRv86uTnJ2NdZ9SCiGBAhYWW5uFWLYsc+WVz+pgUjlpQTlF8F/3QeZh5N90z+w+CViOEeCKrJLFlwZm6tVc4d7mRsGFfoVrLOjnIZ0zWM2hO/XMsKHExbJzO4vY6Gl6n/RO7LuIXIxf4LaLZvlFx0nFd3JB8UAGCBfHHT85Eb0UgCcsRwxraO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

When handling a COW fault without a normal source page (PFN mappings),
__wp_page_copy_user() copies from the faulting user address. For remote
faults, this accesses the wrong address space, resulting in wrong data
getting copied.

For example, user_events updates an enable bit in the registering
process's memory. If that memory needs to be faulted in,
user_event_enabler_fault_fixup() calls fixup_user_fault() from a work
item. Placing the enable bit in a private PFN mapping can trigger this
remote COW path.

Reject these faults with VM_FAULT_SIGBUS when the target mm differs from
current->mm: remote faults. Ordinary (non-PFN) mappings are not affected.

The user-address copy dates back to commit 6aab341e0a28 ("mm: re-architect
the VM_UNPAGED logic"); likely, actual ways to get remote faults in
there on COW PFN mappings appeared afterwards. But the fix is simple and
straight forward.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 6aab341e0a28 ("mm: re-architect the VM_UNPAGED logic")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: simplify comment and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 0f4db5080e371..ec7a1397ab833 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3761,6 +3761,13 @@ static inline int __wp_page_copy_user(struct page *dst, struct page *src,
 		return 0;
 	}
 
+	/*
+	 * __copy_from_user_inatomic() only works as expected for local faults.
+	 * Reject remote faults.
+	 */
+	if (unlikely(mm != current->mm))
+		return -EFAULT;
+
 	/*
 	 * If the source page was a PFN mapping, we don't have
 	 * a "struct page" for it. We do a best-effort copy by
@@ -4086,6 +4093,8 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 				folio_put(old_folio);
 
 			delayacct_wpcopy_end();
+			if (err == -EFAULT)
+				return VM_FAULT_SIGBUS;
 			return err == -EHWPOISON ? VM_FAULT_HWPOISON : 0;
 		}
 		kmsan_copy_page_meta(&new_folio->page, vmf->page);

-- 
2.43.0


