Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468D5606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=NENYZQbi
Received: by kanga.kvack.org (Postfix)
	id 9DAFE6B00EF; Tue,  3 Nov 2026 21:35:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98BD16B05B1; Tue,  3 Nov 2026 21:35:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 855206B05B2; Tue,  3 Nov 2026 21:35:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 450ED6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:35:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A13D01C3EB4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:41 +0000 (UTC)
X-FDA: 85395870882.21.8FF6A4A
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4AC0F80007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NENYZQbi;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aG6IwJCLq4n8f0cBfAUpqV0o25rDt/v0bsv7rm2VUy4=;
	b=YrhWxoGmMwieWmPO8qGNSk9PgJbI8tpWFlzA9nGwBx6ooU+kmo5mIr9CVswzCb9eVFW7hw
	C3w8xbJ6PtaA9rlPvhSzU64ZkjHElJsGzAk0jDmdAsRlybr7Agn2+g4UKuagH4ZCDTNaqo
	ZjElRZyYzn0eTknGCUVtAxM8gh5GEfo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NENYZQbi;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759740;
	b=7N1t62S8VENiGR0R8JMRg38BWrFhpVLrVapLLtvdZGUrFG66gboHztqBDaNDbYkV7Mq/Ui
	v5m61W7VHquApMC6liw8a0Rop4rh/Mu4gaJTWj+iIpOkorTp+bxybB5jb4eiZRqtJdbG4Z
	EtO5972gwsJDWNYNRLCVBlYRSHQVV6k=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a058f74a54so72964b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:35:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759738; x=1794364538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aG6IwJCLq4n8f0cBfAUpqV0o25rDt/v0bsv7rm2VUy4=;
        b=NENYZQbi0CzGyBtBeIr7tuXlNmK/LbJBfPyEyNsLA+vAue7ZWcl/EklcizXmfOeKgY
         kIieLYWQWgIL4FzF+mgadZR96R19VykGbz/PKLSzS2nvytv7YteLoIz3TacXy27UbZ+o
         820vfXXHplI85o/r3xWu0AZhvrFLu5Xaxep5N7Hp+2RPb96Vk9kNxn15mm0WFWTgBjtu
         gdWTGo8RBB4yXQAH6ewmj1V20F5E4/52QODr/nAeavs5WSsyAGWDqkL6b6r57WI37eMB
         osVWsq/mlbjY5yxiu3hK2ZLC0PK/AF3x+zP4ze7wtv6LLl+PySfPQKXnTcRXMn8CObnj
         k75g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759738; x=1794364538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aG6IwJCLq4n8f0cBfAUpqV0o25rDt/v0bsv7rm2VUy4=;
        b=RhvYTREPhWR8oA0ZMd9ujeLUFxZMoVEW0N+ZOEe0/E3Apuy3hw8gypZKMRSrUiIn2o
         cTSVV2IZx56DTiQlw9jyBQ3OkhawoLLPyz0rt1CkX5wxT6mrWwY4ptYbNfqWRRuolTQr
         s+qA/3w+FQoYxRodSjds080R8K1ZYf5lkJnI5fnoQ4DLCjMhVnU6/94PJg/xGx5J8ILT
         kigPYga09FQYYvoG1b0uTKu7ZGmY111nVXKSbc2kxHP4k2GLVNgwAdxBQGC9B2rbGmxf
         vustqT5uQrvh+35eJ/ZMjFwoIHr7/Fb+DisFMiWvozvQwR82puVLyVILY4b4bBjF8ll8
         lutA==
X-Forwarded-Encrypted: i=1; AKwUvBzFfiTQLI6JC4kAeo9TiCyx0JkSZfjDGkj7ly5Ar58qeX+i5ePF2Px1wUVxJ8rB37pbQLe9fLF/vg==@kvack.org
X-Gm-Message-State: APuU4Z96h+94VspeXcJQLwm/hc0DDs23Plz96ltPWG9/WI2Isi2kqL9Q
	/5QEER9WUHBZ/KZyAlw0lx+2i88nCYSACZ2H3z88RRLSIfkqj6at/0R5yZZtB9EPr+w=
X-Gm-Gg: AYBFou1UDMKeiSwfWC21HqR20X6BmZAVl4stx1JJk1waBhYMXi8rqbb1325exu4564S
	Bf4kyjXDDKqb++aFTM8EiA6Lq2tMMju2BPrjqSZD/676G9MBja+sRCiYZHN9hSFk3SCSDFUX7Y4
	FmlpU6bEK8EmlSnECjdDbLqojrGfcAj9XNbknc7009Ce0QyZo7hdjeCuxxaZvkBxUhFcxspzzCh
	y+/1Irx8p9etqKLT6IJ5NSc7zQ0fJ2qddAgFQcKd7MCe1xzm3y0tI8c68OYvq5tB1qHz8eTa5/c
	/t9bWBWjutjRqdBc0akySbB+zTS0sHxaLTgcSe8i5AWDiVtGDC1wfHGRtLlwBppF1Zr0f4AovQx
	RCuvt/V31XCNjtrg09zg9U/pWRn58BkGexBzJznk0InDKfSTnhirB14vbZcwH4+6zZrfzW07/rf
	DcRAzI9R8rUTKAlxOLf5PBqjmky/E+NFW4F9RAYDRs2di2qt8enDWj/a0fXlz2yep53GFgap82I
	javWfxOqLAB6fwwd2ahz4R1Ho4RFfTHq+5/LwoF3PwZd0WXJtWHHiFoWyne7jIRbiJdlNz9Bq/r
	XgPyRnOfA+yHwLJLBR4b1eK/tOVI3sclpHGD+S7bPP06A1bxJn0CdfN+ziLNQ4cJQh5PkUk=
X-Received: by 2002:a05:6a00:4fd2:b0:89a:5:92b9 with SMTP id d2e1a72fcca58-8a9bfbf10e2mr11631096b3a.44.1793759737759;
        Tue, 03 Nov 2026 18:35:37 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:35:35 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 00/12] mm: Decouple folio-based vmemmap optimization from HugeTLB
Date: Wed,  4 Nov 2026 10:34:58 +0800
Message-ID: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mmf4zpywgbnteshgx51zoogf7xh43qh9
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4AC0F80007
X-HE-Tag: 1793759739-527553
X-HE-Meta: U2FsdGVkX1+vxGBiURHdFWSVUNYnamToh74UW+p2QVJILPNGhp1rkrJcF1LKuQponh/kLwQZF2mx+x11cBYmhtJelw3rgjpBtpbaVhcQBGDhyzvXfi29ufYgKHtDCIDCNUuOYmtygRy3bHarLzRE8KPciU3iw/R0cv3IgXBv2+5JW9Rpk6sEaLaDwKy0UGr1u3D3ccylrkRC8k4z/vZsWlQm8ZeAki/NAAXc/xVsARbjMXhGwt+QrRw1YMXbmCdYB+f//6Rbcsz9cdfpwIgwQM3MJbQf1NNOWBuahXD8SVBZK0uqEoQbS0haiPbvm/ziFeaONHK+OFDPeUvUZtNAxhq0SuZG5KldPbz8N27mejdDyCOT/jDyXvjMUEiAo+YyYrQWVIPWSdKFlcEFcmPxsELGrnp98vkhugK6bziszzDgaLWHQdKJe037lGsX1eppf56XCQcqacc423jaXLAcKuS7Wt6/MoJ7IExgej2Jyf0FHeplPDXsYbIN+5nf9fkTNgmYCM96kV+HMY8BDr7VRdD4SG9CIr9s0ShnIJExnGsH0C3T8PxdA08hLrqemNyo5x53XY0vmsPvXZaTLSSZMXp+d9pun+f5yuAWJvnEPpOgiU2hMy1tm0lRby2bwaUXuQwxCXQ3uPoVX7/hA7CQjEqL4faRxvGUiFa5N0GqSTDJdXn3oAz9Jak/90h1xi79ZMnYLY5MutLt+7GXPdxF6FGSv1BeVyVSqpM34FcP0YZfIC3a7xmKTcXxPlhnG2E5DOVSatXx+z3h4IwkJjOQidyJunAkQNp1FCiI2JaWXDY2WP+l3LJBxibAQkYU7Bzsg+zrHw3pMARv8/pBDNJu4mx/ajt27QQizLtKRAyl4H2ez6WYeJlMD8SPmlNjvBFolC+lF65YUq46ZeSg879dXTtJYP6ZA2ap9aG5DLVElq7R/Vkeb8UlQAFZp8UK66viw0M036QUODGz/Z07kTm
 Numkcp/k
 Ijg31wdMMB55n4615S357sL3kZ3Xg9mEyvXlOeRcEIuRGQPQcbMhFa1z0hr7U/IwPZmz0uPRMDlsafekmosDS6SBSC5NtuzlKVSn28Bw1x2YEAc+WU6xwZyr5Up9CPS8WJekd95UXKHQruqQGq078mBLfOpdENrGnbbDgJjwmh0DKPdqbsSus2803dQyYOuy9lupDGIuuaf5fGPxlF9KTEuTOKlVkFnbpoVL2OtefDaTI/mCKcVelQXPRiDJGneJm6YEAUTJAGl9iSoQDAXR+AhJNnQPfT55r/5ofUaJ8zohSlvTXwxIOwXhnGFaOKFIVn47FRKkXIIZxigM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Section-based vmemmap optimization is implemented in sparse-vmemmap.c,
while folio-based optimization currently lives in hugetlb_vmemmap.c.
The latter is tightly coupled to HugeTLB-specific state even though the
underlying page-table remapping operates on one folio at a time.

To make these interfaces easier to maintain, the folio-based remapping
mechanics first need a boundary that is independent of HugeTLB-specific
state and raw address ranges. This will allow the mechanics to be moved
into a common vmemmap optimization layer alongside the section-based
interface.

This series establishes that boundary through three folio-oriented
operations, each with a distinct role:

  - vmemmap_optimize_folio() optimizes the vmemmap backing of a folio;
  - vmemmap_restore_folio() restores the vmemmap backing of a folio; and
  - vmemmap_pteify_folio() converts the vmemmap backing of a folio to
    PTE mappings.

Together, these operations encapsulate the address-range calculation and
remapping mechanics for a folio. HugeTLB wrappers retain policy decisions
such as eligibility, optimized state, batching and TLB flush handling.

Patches 1-8 generalize the underlying vmemmap remapping infrastructure by
removing HugeTLB-specific assumptions and simplifying remap control and
resource handling. Patches 9-12 then establish folio-oriented operations
for optimization, restoration and PTE conversion.

The implementation remains in hugetlb_vmemmap.c for now. A follow-up can
move the folio-based operations into the common vmemmap optimization layer
once the interface boundary is in place.

v3:
- Rebase onto mm/mm-new at 74d73ffcffe0
- Use two tabs for continued function parameters in modified declarations
  (suggested by Mike Rapoport)
- Rework vmemmap page allocation failure cleanup to free temporary pages
  directly while keeping accounting batched (suggested by Mike Rapoport)
- Collect Reviewed-by tags from Mike Rapoport

v2: https://lore.kernel.org/20261102032525.3597743-1-songmuchun@bytedance.com/
- Rebase onto mm/mm-new at d42dfde37af7
- Rename the unified TLB flag to VMEMMAP_DEFER_TLB_FLUSH and clarify that
  it defers only safely batchable flushes (suggested by Qi Zheng)
- Update the vmemmap page-list documentation to describe its input/output
  contract (suggested by Lance Yang and Qi Zheng)
- Use page_address() instead of page_to_virt() when copying a vmemmap
  replacement page
- Collect Reviewed-by tags from Lance Yang and Qi Zheng

v1: https://lore.kernel.org/20261020115306.813483-1-songmuchun@bytedance.com/

Muchun Song (12):
  mm: hugetlb_vmemmap: remove HugeTLB-specific vmemmap optimization
    macros
  mm: hugetlb_vmemmap: unify VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
  mm: hugetlb_vmemmap: simplify vmemmap head page handling
  mm: hugetlb_vmemmap: generalize vmemmap page allocation
  mm: hugetlb_vmemmap: unify writable vmemmap page preparation
  mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to
    vmemmap_optimize_pte()
  mm: hugetlb_vmemmap: simplify shared tail page handling
  mm: hugetlb_vmemmap: move alloc_vmemmap_page_list() next to its free
    helper
  mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
  mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
  mm: hugetlb_vmemmap: unify vmemmap range restoration
  mm: hugetlb_vmemmap: make vmemmap PTE conversion folio-oriented

 include/linux/vmemmap-optimization.h |  10 +-
 mm/hugetlb.c                         |   4 +-
 mm/hugetlb_vmemmap.c                 | 375 ++++++++++++---------------
 mm/hugetlb_vmemmap.h                 |  10 +-
 mm/mm_init.c                         |   6 +-
 mm/sparse-vmemmap.c                  |   7 +-
 6 files changed, 183 insertions(+), 229 deletions(-)


base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282
-- 
2.54.0


