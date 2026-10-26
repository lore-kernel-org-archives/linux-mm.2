Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14677606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WLVL6FXg
Received: by kanga.kvack.org (Postfix)
	id 2B43C6B05FE; Mon, 26 Oct 2026 19:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C8B6B05FF; Mon, 26 Oct 2026 19:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9A36B0600; Mon, 26 Oct 2026 19:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EDEFF6B05FE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:31:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8481E1408C1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:31:28 +0000 (UTC)
X-FDA: 85366376256.27.E552962
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BB6311A0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:31:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WLVL6FXg;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkeUnC+ke2SeHckxsNXGFCsvZLAe8AN/2/cLkPRumtM=;
	b=yanbAvxfkVr6CFDOA8go2IH72uzRvf5wFAzWoVnXcAYHr+GLSX7cUL576TjVccC8LXS5o5
	ozDzsrA5yepTBdxHDJRiTyKmN8aGaukt01lZpeRFbmr6eKH+6RwkBgUi4KgXBIOlFfd9UW
	RBWPCR5CffUfsCzOE1W3CGO6VZrINik=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WLVL6FXg;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057486;
	b=vwiUD8sfLH4U8UR6k7ikLlrJw50M3T1vJ70oKLfhXtzE/56gXbsp+Ni66w6fjZuou0I7AM
	W9gOa88i+23WxQakQlzLDVDSjbP+/3a2HEyuTCLR+mSbf+qUEnXVwaFxRiSSHvIc6udg9+
	wa1rRfHZM/yii9WcNkVlI08gwOgRKCQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0906240C43;
	Mon, 26 Oct 2026 23:31:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4037C1F031E4;
	Mon, 26 Oct 2026 23:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057485;
	bh=lkeUnC+ke2SeHckxsNXGFCsvZLAe8AN/2/cLkPRumtM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WLVL6FXg0vHz/gidKve/pjODS+0haZDG7Pz9wt1w6lIJRrIezoVOGFFxeQnFGWJUC
	 Oh1S/7Ts9XcXEHskvuXv4xWsR9U6n5+ghh5PrusNb19hSOJZLkpWQW7jm+f7LppoLp
	 nRdmsTY5ydvVfPPBYKfSFog8rg3u7fckoyrMVJcewFoW32wez6F1F681g1rez9jjlo
	 VpYGoehVJXN5aYjbNK/5aiFRgWQlMXHycy1oszm2PIaDU4bSRaezAblXErdFsv+nGK
	 WVM4CKwy9q9O57aOMot6Sxcl2q9ipgojiGwZK2yMXBqW8slqmRQD5V5djgEkP6/coW
	 4+3g/vQdhBtFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:18:03 +0100
Subject: [PATCH 43/46] mm/vma: don't leak the charge for stack growth
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-43-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1191; i=david@kernel.org;
 h=from:subject:message-id; bh=ALGNQwhpLft8D6XNQK7dKBbPofsh/OWRq1n/Y7LvvI4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/xmeH/Ej8mv/5em33yHRWMvuIu37qv79rNdMFa0
 H1pQcX+jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZSfZyRYfrPY5yHLG8pNPFE
 GU/wzQmSbHFNljx4/M/6qv9bn2izcjL8D1125f3Rlhh7VfZ6A4uzkXN7GiZLX9/2JpXJkNnP+P8
 xLgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB6311A0006
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: zgw991et9j7pnsupd5aqsbbi8jyj9tfj
X-HE-Tag: 1793057486-493105
X-HE-Meta: U2FsdGVkX1+kazeSf7hf5IFJpons4/qmi0X0d4/pAw9o1gaa83uTtBB+kPZpcT0GwrZAWSdeMVOWzJ3eA6JkoD7jR99qzudkRNuS5JtNs7W53Pj4epiTQgSVWytXQU1wmJZWadzF8hzYPxEk22+E6njBvUyy2L1i0NkeUZbdmhS/2AdVcO9keBM8qlGuqDjkJUiEPcXyxCZYUGnbzymlQvOdKuJtvfFm89McmSkJMc29VIVsA37tYsAxrbPynyVRVcw1aThQ62SmpYQb5ghH/dZenK+fJvhNGdCClFO7tDOqMkUMBLYKNEUmTqzI7sMFQtwLYdYn+26LknY847WbjXeJPcLvJXHuuedZFAb6k44O8oM8pEvAvcnn13fj5p6IlxRNOariT0O1bdUyxUmULWs7L4/LcL898gLJdoN4O7Eja1uqeFFrpRPtcxOUuPzSigIVYDLAQpfClLV72MtaoKOb8AZGEoABGkw/cKJI34VQZ7i8orOGvdkZ5TR9RmrGUfdV9ShBeNVGHBv+MN9OENBK07T33NUIHIBu2rqKz1nq5zeJd8KwUgHLGuLfiVy600S/MrxxeNTxmQ/aEtnpdH82a4wO9Ef4jnW5ANuC7MF0rOWQpecel+lztFu514QFvVXnTdAFAkT+GbrMQR9Yvx/4C3RIMUfmVIQh5gV+ecDRT8dT1EokyuYgiSxHq8qrPm1BMlrEpZ87J14LvHugT4NwLliaX01aVZOZtCdAy5SMDgHYXvx5fG90IIzTeELuU3JczrA1/BBd0KL/r+oMSldL1N9UBuzBaD2TypEw8n630LXH8iNv4iFXo9wcgCUq2w5vFqZ+9Iwjgb+/HH/8tVVfiNblbTgz1YQF7mjOpbVeAXpXgDtvi3YxhQYBC0PZ6qmR7NlN7dqUSvfdhZcBEgEWvmwluE1dWQcCNBnK2xj9hsvtZo6A/sY4IkVdeT0rr/boNiHlfFZxv9ZP5iL
 0ip9a9/e
 nqgI/7sno1i2x/hgzFQZ4WAZW6IkBIJIy2v5TPQ0aHAbVge5OxDIo7bKccRVn7dd7Ky+Qy0wk2vCOAqKKrMwW/fUNQugoTUzbVNq0pPKzJKEcEqEca+Dj6GoRPibduvymR2KPfFsI/X/5KvpP5SbXiZoDzzQu8UKZq7bI6ZYG6HU/9uQl2hwcoklYVcVCX0ZXB4UmI6OfwjXCEo4iaOW4usOPg7b+2uhSDk8OZIcEeltFw6s2nO2DfWxFFqxvBxD9cZ+MouDEmJ6CUKT05UGeopYdWBWy9zM0iy6+HysB9FOvK5aDfX5YkARudMNz46DMZC2E7BY0i7DfQfuxOiItnckAoB9WeDiXt51FxocBXuIUDYxyiySqk8lR9RKG4OcEUCsL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
This can happen for read-only or MAP_NORESERVE mappings created with
MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
Committed_AS.

Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
Unaccounted growth skips the overcommit check while remaining subject
to the other stack-growth limits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/vma.c b/mm/vma.c
index acdf00346cda5..695d0be85ac86 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3391,7 +3391,8 @@ static int acct_stack_growth(struct vm_area_struct *vma,
 	 * Overcommit..  This must be the final test, as it will
 	 * update security statistics.
 	 */
-	if (security_vm_enough_memory_mm(mm, grow))
+	if (vma_test(vma, VMA_ACCOUNT_BIT) &&
+	    security_vm_enough_memory_mm(mm, grow))
 		return -ENOMEM;
 
 	return 0;

-- 
2.43.0


