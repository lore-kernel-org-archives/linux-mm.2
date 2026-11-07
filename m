Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6B68606D801
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 10:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Wc8PkROU
Received: by kanga.kvack.org (Postfix)
	id DE9156B05B0; Sat,  7 Nov 2026 05:31:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71026B05B1; Sat,  7 Nov 2026 05:31:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C38DC6B05B2; Sat,  7 Nov 2026 05:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A68C36B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 05:31:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43AE04032A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:03 +0000 (UTC)
X-FDA: 85407955206.02.9A4D7CC
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E8471C0008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:31:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wc8PkROU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794047461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qnfaXKSjzVJK7X+JqrAUXuAfLa2GhSU1USswboGhOL0=;
	b=VVZtBjDlU8spDehM4jABb4AhXQ1JiUFtkRpPmBSzlVJo+w6jscQ9HfwqqKV9BTdZhz8QdV
	ZylaAZoAkkwR6W3SyywL/iXip+4eT/+BMlSQ8Coq93ptoDyxq6BIhDbtPwo492bYgoksvB
	Tr7+6n4Kuz9Zhc0NKRHPBA/8R4VamcY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wc8PkROU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794047461;
	b=CsDlsXUK/wZbHStEhT/Fa/jqnWDXYS9mtLtwwLke0ILz1xthUz2hAelSUcf/PRMdLbu9BF
	TfiTakmUvIhsSHq9esYbX+wKWrpLLqtPVJ37k5MNixC4LiP6Mte8K89KzesVVrs6vlOYYE
	DODojWa0HYbebHYKz1vEl5InxiL8GNk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=RsCoCmOPMyHJd+R/ztk5rMnp9buDWmn47/QOCHLh9IA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794047459; v=1; x=1794652259;
 b=Wc8PkROUmnrUppOP/U+Uvpe3LJkTskW4WEVIWTvNN2+/MB5KAGCiimASsH9xdK1ghbb7zQ7G
 SuEFF2OWaADsJdilE51qbcrNA6tbY2g/Pp/tLv3fOaKgXv6VwZUZdgYB/uB7MX0Pxtwgu18I6eV
 8MXR1+pjoU6RWhhulg8RnHiE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5feb844c2993f120;
	Sat, 07 Nov 2026 10:30:59 +0000
X-Mizu-Trace-ID: 5feb844c2993f120
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 0/3] mm: hugetlb: fix CMA-related issues
Date: Sat,  7 Nov 2026 18:30:44 +0800
Message-ID: <cover.1794046188.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E8471C0008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: bxbd3ainzz3i73osb3au1yoxj6de3fph
X-HE-Tag: 1794047460-670306
X-HE-Meta: U2FsdGVkX1+6F13nAr/iDOP7OwxtMYzwoMbqQ2x4gu1RbxrwqauvBsKMrXvcuUnPuC46k/UYvO6/ancoKPB28NuqK7loe7BjZPehx+sRbeH9HK3v3+jF6rjWOzfTxqiCFwLdWRm8+xnwtcrzQWgRyVeQOAQ8ABQSdsrz+HBCi9dzmh88rWhhUtgw/1KR7uiOBM/U/ITUiHUnUAgpt7LqLwJ4/xEgir/Gi3SucIi5HX5ZaNlMJ842CKHnfGKqNQHwT4uybVzkbMWGYn/oIiFjFV3K/nNWr8WHBuZ2v10B5cTQtTwtW0fxOyp1ICZRDnBmm7oxMCOTXLdogHvd63bcc/U3st0tGCXNwDSpPdz3476PCLqLhc2N+dv0rXcX9ARCaLFUHvvuGrJZ0fRsfcV9L2Br0v+/ZB8BpsaVLedelinOLmSqOgu9TSzZfqutvvSwl3YbIF6uCvudR0PDNodAVj9oSDWbaGqiYC3pvWviF7la54KZpwtqPW9lMejccTWVTCMcW8A7CoN4pw55D5rX2pn9RN36JmdWZ1vNFoj5OEafGhkgDUtLsNelfRoi8hBdwLAgBATTl5GJt/SwwSLfQiH/ogXeSvxzYQ1wDGF7gkxiLfvZQisUvQS/Yiju3xVTGii8iLCSRx1AyJZtbwaknxzHOB+1q0EN1hH02SYgJ6pOdKnlqU/904aJa5K3EVpR6LMCZ5h8DsF9m3z64c8ULmbOxd4EwsGaIZBc5i0egPQ9l6G13dAIOHAAujzKuy12EkV23G+SdVwfdrlgw6g6MkV/uIiCJ3qOd0iovz0BXCvG9HhcqTWoYj2ECcDe38a3hcWpv9UoYfpvZBzPhA7v/NEKRD5EHDUJNOsM1kgE8zk/wKeS5JkLH9MKkSv+iEIQ6wpxsWPds7NFyjQZVciWVrQv+EvW2GzG3bUrPnmgM4BRTEXRHVZkwh0BFGWjoe0NaxSztbt5hGVKyf/xJbJ
 y8+4dK2h
 vXexca6atqRBF5rknQOWbScPSMNdtS80kEVs4p8SN8chiND3INNP4hqzKisQzUwaC6thbEkgfX8Ap4Dpg7drUIo5vnufZEDfj965cAWkIGWT/V7FBMtOZfwN0ES2DsXjWmTpd81lP2FXC4oMFiZHQ4sJONJJR8DTHtE3DhGn2gjA7LwbixH7VfxhaK4LHf7XKw5HWCT4wLlisJHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This series fixes three CMA-related issues in HugeTLB reservation,
long-term pinning and allocation:

 - Avoid ineffective CMA reservations on 32-bit x86 kernels running on
   CPUs that advertise 1 GiB page support.
 - Allow long-term pins of explicitly CMA-allocated HugeTLB folios,
   which already own the CMA memory.
 - Preserve the caller's GFP mask when allocating from CMA.

Changes in v3:
 - Drop the cpuset fix. A more comprehensive fix across the HugeTLB
   allocation paths will follow in a separate patchset.
 - Check for __GFP_COMP instead of adding it in
   cma_alloc_frozen_compound(), and leave __GFP_NOWARN to callers.
   (suggested by Oscar Salvador)
 - Clarify the CMA ownership comment in folio_is_longterm_pinnable().
   (suggested by Muchun Song)
 - Collect Reviewed-by and Acked-by tags.

Changes in v2:
 - Replace the PF_MEMALLOC_PIN allocation restriction with a GUP exception
   for HugeTLB folios marked HPG_cma. (suggested by Muchun Song)
 - Pass the caller's GFP mask through cma_alloc_frozen_compound() instead
   of skipping CMA when direct reclaim is disallowed.
   (suggested by sashiko)
 - Remove unnecessary revalidation of successfully allocated folios after
   cpuset changes. Retry only failed allocations.
   (pointed by Jose A. Perez de Azpillaga)
 - collect Reviewed-by and Acked-by.
 - Rebase onto next-20261104.

Thanks,
Qi

Qi Zheng (3):
  x86: hugetlb: disable default CMA reservations on 32-bit kernel
  mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
  mm: hugetlb: fix GFP mask propagation to CMA

 arch/x86/mm/hugetlbpage.c |  2 +-
 include/linux/cma.h       |  2 +-
 include/linux/mm.h        | 29 +----------------------------
 mm/cma.c                  |  5 +++--
 mm/gup.c                  | 31 +++++++++++++++++++++++++++++++
 mm/hugetlb_cma.c          |  4 ++--
 6 files changed, 39 insertions(+), 34 deletions(-)


base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
-- 
2.54.0


