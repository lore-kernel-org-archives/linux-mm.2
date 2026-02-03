Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A549AE83040
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 02:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11686B0089; Mon,  2 Feb 2026 21:46:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF2B26B008A; Mon,  2 Feb 2026 21:46:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8356B008C; Mon,  2 Feb 2026 21:46:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA0FD6B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 21:46:03 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91487B83C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:03 +0000 (UTC)
X-FDA: 84401605806.28.1F96A6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id C85D620007
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T8jtVxX+;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770086762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCjlnZFC0CZwZVEGycSDrZGwImk2g1xsKNwZUUAmE9g=;
	b=W5bRF4XQaFrEyiBtzECnhIBTtP2Z+JPAy2ki5LWfCf9FMlqWfsTfBguY3KAB/lQdc3EI6J
	NceZTHmWq4PLhaljDR00UKDfHUyuFnt4wGIC5rk+wc6eAASe0PA/67ARsro9zppQlrWNME
	OdkxrPOxe3yElKpLJs/MErR+sFulKrI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T8jtVxX+;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770086762; a=rsa-sha256;
	cv=none;
	b=JonwdZoKr/fdWgv4L1XysMGT/AI9lK1Qs7Vflz72ZxtTZRlKGBxXMw6iNl7AyF20CQKZAt
	2nr7dkMr4f5vY0F04ZmW9oKTc6pXBKwoMW52pK71D+S2dftEQ4tO6snK4v9h8rBAMer7Dr
	qGvs1W2Sfhx+ADaCnPljr7FUy4SxiYI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A31DC43BB4
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7862DC116C6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770086760;
	bh=H+/8Oq93CxA17bRqDiMSaqwFIqECToMWP/dZapyTpOw=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=T8jtVxX+bqep0y1MVhqM2SnweS8CrTb66xYySFU64rQYKkV92Pk6Y+9vDpCf6b5vN
	 E5xZiIXwB1O2UGvHKyarRTnnYDW/Z6emTM6y367VSSl3O3+Cez6Qii8v8r6/6vKxxk
	 Qc75fVdJRvIcqbFvh+dinuqmXzDW/51Ib072fys4=
Date: Mon, 2 Feb 2026 18:45:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-mm@kvack.org
Subject: mm.git review status (mm-unstable & mm-new)
Message-Id: <20260202184559.eedec2c51189bd8789d48793@linux-foundation.org>
In-Reply-To: <20260131150936.3b0a5b3f45f6ea5f9930099d@linux-foundation.org>
References: <20260131150936.3b0a5b3f45f6ea5f9930099d@linux-foundation.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u8b88w8jpxf1xeppukigui5q5c53opt1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C85D620007
X-HE-Tag: 1770086761-640711
X-HE-Meta: U2FsdGVkX1/7w2Dj/uLsib1BuIVfBIjQx2Ztw1j0Yn6Qm9MvRoX60UOjWTTJxoWSCthiQKr06m6m/7LRH3f3xZeNuXZ3heWj6I21bkjKC/CIdjriVYP9PNLFVIsPD659ADety6K8xXPECBPvrbpRqrCbQTrwV2rxH3dUTMIE7JbRGQ2CwVORvdfYYvEFyAh1RZwWKB0wIcj4e+O+ToHgHRdO2gdW0IYe58mYYBdZCs/UNZ+ymqcYgYF/AzOymr/KAAkhYM7JHGWPokyzbj37Cof1vjvzIXcU/Xei6Yo1mQ2kv2uizytS1HUcAkYcKJunqvytHy9MLfWhakKfkULhQO6SlVX6ASzprwMRFIfE5zzXfaTpOO2PFAyCQAqcplToAbnToTDkwudCkaXIt8Um/1IyZqGpQu68Ql0ruteDFpfCbx6NJ+3lPg8LaKgziHi57ARN+hE3vO2C2y5vLxJl6dqROxIwPzTRDhLg7rrUmlOgS6shitlYbFG9G3ZCWtX1bEyrmK4NS0PhALzx5lDU5lTUmCI8F1zRu9Y8b6Ywb1CqyP+tgrgR9PNo0aDA+HAJJvKjC0tkeKPw7sB0T1jEfkLZmfi+9TcI4amgom3RjKVmmtzYCcYxgoezPsd445ceRDPWur8+0SRZKc2zBhY5mhbNRSjyMq5JGtLmwzUarOnnPwXBib+Ii7U25Pj03eN2pVW49QW+deeKb+tD20x+YBJGjgd0iQifcj1yzILwnqKljPsHg9SwfRUxhfD2NSxq7qiFh3ZBWlpwIc9Gq24lwzhPlb1QMkECYbfsnCsu9d05ajB+47X6Fd4a2MfLC79uumG1go+JbR8Ii6M9CPtNKF7Gfq2kvDbW3WLvv0TWNx8i6AueV+WfB3a8JuuvkTVhanMHsUoa8AVIS3J5wrbF2bYcGBX9HRIcpuJPZKyt7Uu1ymEg+t5KkYax35FSjzZGT8u+3zCiH1KM0ORus0F
 MnlSbelt
 +SIAQ6VCQrjwXIFlKZEWbUsReWqpk6iYFL7yhg7l5IG6Z8xEVmIVeO4lkYW3lJCWDdq3UJrUQpydiBiXXWCMZ+KWBnVp1jSpu1eKXmZw90Lnsls4eo+H0GS1Unea1JYMzoM69iyUJsCO2STdgejpT1RpQrirz8uYuMTdRdK4Ud+dTUcoq7ye1kBa453SsU7Dmuz2asNUDL3YOLOEUAOvV4kf5MYVi5QUkw4kgf6eg/axuTZ1TEXOAZmEqNqdNcq+nYXb9OKgJX8lY2UKrQd0t9atwoz4uxpT7pYQC/cjIGH8rCJfBPDKDbdY+WF3Eh0WB4V2BuTxZfahmQHSjnjO6QR7gbHHNCYMSWXDN604qD/NIL8g/PIQqIUiTHH6I2TF4PgnyLr2uW2Upb90xudhvcs29QMAV/3oXRB4Fti5sLu8rETtqALtxhZm/lO7cljrxJ57zHoVAeHkl+ayZv1jyuJ6ioaxLK2hChaymf8sjrfPAxXkGkASyJpLoYj3Z6ulHxKICLI6rUIswAPVU+3KZw2vxGvcMIVkHa7NosUwdhJMi8vGRfICshVR+0DNnHVgqw/V+PhbAggIcwO7Hz53gv8gK/LFkaMBZmd5P73xXGduCtSsnyEru+gvDhGBIdm480WJTmXpKE5g7EuU+IVJu4MjNOSLpc2W5w+slj7OATyo5R5jLSMqfljVC79CSzkPCIE0/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



mm.git review status for mm-stable..mm-new

Everything:

Total patches:       105
Reviews/patch:       0.58
Reviewed rate:       29%

Excluding DAMON:

Total patches:       103
Reviews/patch:       0.57
Reviewed rate:       28%

Excluding DAMON and zram:

Total patches:       103
Reviews/patch:       0.57
Reviewed rate:       28%



Unreviewed patches by author:


Andrew Morton <akpm@linux-foundation.org>
    "procfs-avoid-fetching-build-id-while-holding-vma-lock-fix"
    "mm-update-shmem__file_-functions-to-use-vma_flags_t-fix"
    "maple_tree-start-using-maple-copy-node-for-destination-checkpatch-fixes"

Alexander Mikhalitsyn <alexander@mihalicyn.com>
    "mailmap: update Alexander Mikhalitsyn's emails"
        Link: https://lkml.kernel.org/r/20260128173915.162309-1-alexander@mihalicyn.com

Alice Ryhl <aliceryhl@google.com>
    "maple_tree: update mas_next[_range] docs"
        Link: https://lkml.kernel.org/r/20260118-mas-next-doc-v1-1-827d9f4924ce@google.com

Andrew Cooper <andrew.cooper3@citrix.com>
    "x86/kfence: fix booting on 32bit non-PAE systems"
        Link: https://lkml.kernel.org/r/20260126211046.2096622-1-andrew.cooper3@citrix.com

Ankur Arora <ankur.a.arora@oracle.com>
    "mm: folio_zero_user: open code range computation in folio_zero_user()"
        Link: https://lkml.kernel.org/r/20260128185943.2397128-1-ankur.a.arora@oracle.com

Baolin Wang <baolin.wang@linux.alibaba.com>
    "arm64-mm-implement-the-architecture-specific-clear_flush_young_ptes-fix"
        Link: https://lkml.kernel.org/r/de141225-a0c1-41fd-b3e1-bcab09827ddd@linux.alibaba.com
    "mm: rmap: skip batched unmapping for UFFD vmas"
        Link: https://lkml.kernel.org/r/20260116162652.176054-1-baolin.wang@linux.alibaba.com

Bing Jiao <bingjiao@google.com>
    "mm/vmscan: fix demotion targets checks in reclaim/demotion"
        Link: https://lkml.kernel.org/r/20260114205305.2869796-1-bingjiao@google.com
        Link: https://lkml.kernel.org/r/20260114205305.2869796-2-bingjiao@google.com
    "mm/vmscan: select the closest preferred node in demote_folio_list()"
        Link: https://lkml.kernel.org/r/20260114205305.2869796-3-bingjiao@google.com

Shengming Hu <hu.shengming@zte.com.cn>
    "mm/page_alloc: avoid overcounting bulk alloc in watermark check"
        Link: https://lkml.kernel.org/r/tencent_F36C5B5FB4DED98C79D9BDEE1210CD338C06@qq.com

Joshua Hahn <joshua.hahnjy@gmail.com>
    "mm/hugetlb: restore failed global reservations to subpool"
        Link: https://lkml.kernel.org/r/20260116204037.2270096-1-joshua.hahnjy@gmail.com

Kevin Lourenco <klourencodev@gmail.com>
    "mm/fadvise: validate offset in generic_fadvise"
        Link: https://lkml.kernel.org/r/20251222141817.13335-1-klourencodev@gmail.com

Liam R. Howlett <Liam.Howlett@oracle.com>
    "mm: relocate the page table ceiling and floor definitions"
        Link: https://lkml.kernel.org/r/20260121164946.2093480-1-Liam.Howlett@oracle.com
        Link: https://lkml.kernel.org/r/20260121164946.2093480-2-Liam.Howlett@oracle.com
    "mm/vma: use unmap_desc in exit_mmap() and vms_clear_ptes()"
        Link: https://lkml.kernel.org/r/20260121164946.2093480-10-Liam.Howlett@oracle.com
    "mm/vma: use unmap_region() in vms_clear_ptes()"
        Link: https://lkml.kernel.org/r/20260121164946.2093480-11-Liam.Howlett@oracle.com
    "maple_tree: fix mas_dup_alloc() sparse warning"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-1-Liam.Howlett@oracle.com
        Link: https://lkml.kernel.org/r/20260130205935.2559335-2-Liam.Howlett@oracle.com
    "maple_tree: move mas_spanning_rebalance loop to function"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-3-Liam.Howlett@oracle.com
    "maple_tree: extract use of big node from mas_wr_spanning_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-4-Liam.Howlett@oracle.com
    "maple_tree: remove unnecessary assignment of orig_l index"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-5-Liam.Howlett@oracle.com
    "maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-6-Liam.Howlett@oracle.com
    "maple_tree: make ma_wr_states reliable for reuse in spanning store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-7-Liam.Howlett@oracle.com
    "maple_tree: remove l_wr_mas from mas_wr_spanning_rebalance"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-8-Liam.Howlett@oracle.com
    "maple_tree: don't pass through height in mas_wr_spanning_store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-9-Liam.Howlett@oracle.com
    "maple_tree: move maple_subtree_state from mas_wr_spanning_store to mas_wr_spanning_rebalance"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-10-Liam.Howlett@oracle.com
    "maple_tree: correct right ma_wr_state end pivot in mas_wr_spanning_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-11-Liam.Howlett@oracle.com
    "maple_tree: introduce maple_copy node and use it in mas_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-12-Liam.Howlett@oracle.com
    "maple_tree: testing update for spanning store"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-13-Liam.Howlett@oracle.com
    "maple_tree: inline mas_spanning_rebalance_loop() into mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-14-Liam.Howlett@oracle.com
    "maple_tree: change initial big node setup in mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-15-Liam.Howlett@oracle.com
    "maple_tree: introduce ma_leaf_max_gap()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-16-Liam.Howlett@oracle.com
    "maple_tree: add gap support, slot and pivot sizes for maple copy"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-17-Liam.Howlett@oracle.com
    "maple_tree: start using maple copy node for destination"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-18-Liam.Howlett@oracle.com
    "maple_tree: inline mas_wr_spanning_rebalance()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-19-Liam.Howlett@oracle.com
    "maple_tree: remove unnecessary return statements"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-20-Liam.Howlett@oracle.com
    "maple_tree: separate wr_split_store and wr_rebalance store type code path"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-21-Liam.Howlett@oracle.com
    "maple_tree: add cp_is_new_root() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-22-Liam.Howlett@oracle.com
    "maple_tree: use maple copy node for mas_wr_rebalance() operation"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-23-Liam.Howlett@oracle.com
    "maple_tree: add test for rebalance calculation off-by-one"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-24-Liam.Howlett@oracle.com
    "maple_tree: add copy_tree_location() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-25-Liam.Howlett@oracle.com
    "maple_tree: add cp_converged() helper"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-26-Liam.Howlett@oracle.com
    "maple_tree: use maple copy node for mas_wr_split()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-27-Liam.Howlett@oracle.com
    "maple_tree: remove maple big node and subtree structs"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-28-Liam.Howlett@oracle.com
    "maple_tree: pass maple copy node to mas_wmb_replace()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-29-Liam.Howlett@oracle.com
    "maple_tree: don't pass end to mas_wr_append()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-30-Liam.Howlett@oracle.com
    "maple_tree: clean up mas_wr_node_store()"
        Link: https://lkml.kernel.org/r/20260130205935.2559335-31-Liam.Howlett@oracle.com

Miaohe Lin <linmiaohe@huawei.com>
    "selftests/mm: add memory failure anonymous page test"
        Link: https://lkml.kernel.org/r/20260120123239.909882-1-linmiaohe@huawei.com
        Link: https://lkml.kernel.org/r/20260120123239.909882-2-linmiaohe@huawei.com
    "selftests/mm: add memory failure clean pagecache test"
        Link: https://lkml.kernel.org/r/20260120123239.909882-3-linmiaohe@huawei.com
    "selftests/mm: add memory failure dirty pagecache test"
        Link: https://lkml.kernel.org/r/20260120123239.909882-4-linmiaohe@huawei.com

Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
    "mm/vma: remove __private sparse decoration from vma_flags_t"
        Link: https://lkml.kernel.org/r/cover.1769097829.git.lorenzo.stoakes@oracle.com
        Link: https://lkml.kernel.org/r/64fa89f416f22a60ae74cfff8fd565e7677be192.1769097829.git.lorenzo.stoakes@oracle.com
    "mm: rename vma_flag_test/set_atomic() to vma_test/set_atomic_flag()"
        Link: https://lkml.kernel.org/r/033dcf12e819dee5064582bced9b12ea346d1607.1769097829.git.lorenzo.stoakes@oracle.com
    "mm: add mk_vma_flags() bitmap flag macro helper"
        Link: https://lkml.kernel.org/r/fde00df6ff7fb8c4b42cc0defa5a4924c7a1943a.1769097829.git.lorenzo.stoakes@oracle.com
    "tools: bitmap: add missing bitmap_[subset(), andnot()]"
        Link: https://lkml.kernel.org/r/0fd0d4ec868297f522003cb4b5898b53b498805b.1769097829.git.lorenzo.stoakes@oracle.com
    "mm: add basic VMA flag operation helper functions"
        Link: https://lkml.kernel.org/r/885d4897d67a6a57c0b07fa182a7055ad752df11.1769097829.git.lorenzo.stoakes@oracle.com
    "mm: update hugetlbfs to use VMA flags on mmap_prepare"
        Link: https://lkml.kernel.org/r/9226bec80c9aa3447cc2b83354f733841dba8a50.1769097829.git.lorenzo.stoakes@oracle.com
    "mm: update secretmem to use VMA flags on mmap_prepare"
        Link: https://lkml.kernel.org/r/a243a09b0a5d0581e963d696de1735f61f5b2075.1769097829.git.lorenzo.stoakes@oracle.com
    "mm-update-secretmem-to-use-vma-flags-on-mmap_prepare-fix"
        Link: https://lkml.kernel.org/r/3aab9ab1-74b4-405e-9efb-08fc2500c06e@lucifer.local
    "mm: make vm_area_desc utilise vma_flags_t only"
        Link: https://lkml.kernel.org/r/fd2a2938b246b4505321954062b1caba7acfc77a.1769097829.git.lorenzo.stoakes@oracle.com
    "tools/testing/vma: separate VMA userland tests into separate files"
        Link: https://lkml.kernel.org/r/a0455ccfe4fdcd1c962c64f76304f612e5662a4e.1769097829.git.lorenzo.stoakes@oracle.com
    "tools/testing/vma: separate out vma_internal.h into logical headers"
        Link: https://lkml.kernel.org/r/dd57baf5b5986cb96a167150ac712cbe804b63ee.1769097829.git.lorenzo.stoakes@oracle.com
    "tools-testing-vma-separate-out-vma_internalh-into-logical-headers-fix"
        Link: https://lkml.kernel.org/r/1e032732-61c3-485c-9aa7-6a09016fefc1@lucifer.local
    "tools/testing/vma: add VMA userland tests for VMA flag functions"
        Link: https://lkml.kernel.org/r/7fe6afe9c8c61e4d3cfc9a2d50a5d24da8528e68.1769097829.git.lorenzo.stoakes@oracle.com

Li Chen <me@linux.beauty>
    "Documentation: document liveupdate cmdline parameter"
        Link: https://lkml.kernel.org/r/20260130112036.359806-1-me@linux.beauty

Pratyush Yadav (Google) <pratyush@kernel.org>
    "mm: memfd_luo: preserve file seals"
        Link: https://lkml.kernel.org/r/20260123095854.535058-3-pratyush@kernel.org

xu xin <xu.xin16@zte.com.cn>
    "ksm: initialize the addr only once in rmap_walk_ksm"
        Link: https://lkml.kernel.org/r/20260112215522600q2jPW2Un_1HGohr1lVXJ3@zte.com.cn
    "ksm: optimize rmap_walk_ksm by passing a suitable addressrange"
        Link: https://lkml.kernel.org/r/20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn

Yosry Ahmed <yosry.ahmed@linux.dev>
    "mm: zswap: use SG list decompression APIs from zsmalloc"
        Link: https://lkml.kernel.org/r/20260121013615.2906368-1-yosry.ahmed@linux.dev

Qi Zheng <zhengqi.arch@bytedance.com>
    "alpha: mm: enable MMU_GATHER_RCU_TABLE_FREE"
        Link: https://lkml.kernel.org/r/3380f40a89b73c488202c85f9a8abf99fb08543b.1769515122.git.zhengqi.arch@bytedance.com
    "LoongArch: mm: enable MMU_GATHER_RCU_TABLE_FREE"
        Link: https://lkml.kernel.org/r/bd1b11bc1a13686aeba81a40194f87b369d62661.1769515122.git.zhengqi.arch@bytedance.com
    "mips: mm: enable MMU_GATHER_RCU_TABLE_FREE"
        Link: https://lkml.kernel.org/r/0d17f00a724f77aaca2da7c847acd490c3a47571.1769515122.git.zhengqi.arch@bytedance.com
    "parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE"
        Link: https://lkml.kernel.org/r/b827939046dbc94bc7c585cdbed8522baab75b15.1769515122.git.zhengqi.arch@bytedance.com
    "um: mm: enable MMU_GATHER_RCU_TABLE_FREE"
        Link: https://lkml.kernel.org/r/e2217546504668b8a87a39eb0e378839339a1bb4.1769515122.git.zhengqi.arch@bytedance.com
    "mm: convert __HAVE_ARCH_TLB_REMOVE_TABLE to CONFIG_HAVE_ARCH_TLB_REMOVE_TABLE config"
        Link: https://lkml.kernel.org/r/5ebfa3d4b56e63c6906bda5eccaa9f7194d3a86b.1769515122.git.zhengqi.arch@bytedance.com



