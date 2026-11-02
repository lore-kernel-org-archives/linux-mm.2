Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13399606A32E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=XWboIGlC
Received: by kanga.kvack.org (Postfix)
	id 029216B05B1; Sun,  1 Nov 2026 22:26:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1C226B05B2; Sun,  1 Nov 2026 22:26:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0CEF6B05B3; Sun,  1 Nov 2026 22:26:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B72776B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 270E2120B47
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:26 +0000 (UTC)
X-FDA: 85388741172.04.2EDB711
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id A26DD80007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XWboIGlC;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589984;
	b=dTiioxKqRaTjxxPvUAZCKb3RNs/QpwedBcJi1VQMoJwidcE5nMIvx4t8RXysc8gLJxEbKX
	pFoI8nt7R+dw/mOsGU5h4RM4qp+nXshRHxFHxk95r+JfW0Nfw7V+Vvc4RbJ84xA/Wxj0Th
	eJIXbvp+poEcXsm8K6CaO/2Hc9Hptfo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XWboIGlC;
	spf=pass (imf30.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T+HEPLjU1FVAy8fQhRfX6vi4LDK4Jtre7wliDLSzmNs=;
	b=d7+ffII45gGFLrVNaIUBa99hFzGSPyiWkuaWK6JJwJYKJED4FymdQz5rN2++ehNzJLts38
	hBjIuD5f2hFYtw/4lbrMFbIyGx09FEPpBsZkN12XVdEwZPFDdxqax3YZkfzFy9YApWv5EV
	g2UZ1az6rgrPUlWqVMmINHGPiwuM7fQ=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ab60ff4273so2066935a91.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793589982; x=1794194782; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=T+HEPLjU1FVAy8fQhRfX6vi4LDK4Jtre7wliDLSzmNs=;
        b=XWboIGlC1UyYE6hgK7gYL/kbqdPbLmpOAXmHssjy9HJOoVYKmRXE7w43dpI7SK/xxB
         +HQJoqyywjmZD72H5fr5H/kTdY5RE6QEf/8J1q0Jb0c6akSYARJIoacmK3X7SQcQPb/b
         VO5ZoCG8rM9vII1106eTodyQK42stUWIvP79vOLCc+0+93lSryMieQRsI0Rnemm+Y4Hy
         16UxDupzXVLBYumF7YkIrcZCt1OXxIskhjFz8E/i5KQ7XxMU9WzsNW9tb5bKH3J83jer
         O/vAjGQ4GMo6ls0YxzFwkYGjJgAoHKOiMb98GjmhXEw3s6Eggk107g3qrEDFHn3gTPBp
         c5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793589982; x=1794194782;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=T+HEPLjU1FVAy8fQhRfX6vi4LDK4Jtre7wliDLSzmNs=;
        b=k9loixd0stlwk4dk1iDp180WB9YTwCIDtC8rBEP4MxbBZp1BbBibuucICPy0NTh8bF
         Z2qKETG2IRbfzVWt07g5jzDZZuVHV16mDSo2UqLqMz/pogF8sL25aEytZOELrqsOvPXF
         aU7HYFOMnfUf8Rv3pa1s5eY3JGritPNFqCJV5g1TFLhfQJZdAhyryoMuDdg7DE5m8BMN
         UpddxauW+He+sSG64ZZf0V9L5PbDAObZBrZzU8A1wpY47IMDQwFOMnzzlx4HRCuOVIiW
         8RFdOdIFTY1ukNXNL0L+zVwXhjfWtbhOpER4+oEoC3nkhc2ZtORhnaUCqdcNXHoOBMAm
         hOaA==
X-Forwarded-Encrypted: i=1; AKwUvByYO/9K3Wf5uxTmuV25MZSzkJerH5ngeT9sghXiKc0gNwz8Z3/qL3yB6MJsITWX6LBBTkpnewFeKg==@kvack.org
X-Gm-Message-State: APuU4Z/QVmYx8xFFrzX3WOXEI5odr8WADM177cNwX/XyMNdjhHzK1cBc
	j1XMlwwV+LKyBbrnbXkf95vdPnlW7pFYBoY9OywofhRpaABXugEGpHysc0sEyjKLMSg=
X-Gm-Gg: AYBFou04cll948a9sDgEDPx/wXTt9QgyIXkzrDpPbNcb2/A+XqfVpDDAdvbI3nWRASb
	RAdJ7RWebnAnk3et9wCJ9ygJNutQj5WCxGtRcl/IMWzp1j7BtA+zMwprnLV4cUpw/aabpShNfv0
	c5UdrVLr0vi6WOZGqTm3iOde++H0CjF82aU9U5n4Cd2/7pgNLxrjs/Q0RG3oEnBMbJuddFVVOEl
	jbR3RybT6yKmMSgDoGP7LAKyAO/M8xRIuPvnKaByh+ZClvOI+V+kg1LkwC7xePJZ1vsPPhhRrjK
	FWNPoK/TGPHFPS43StVKkqyALQwCywE1SfrE5J5v/H8VJgNSNRjHUfTGCqzCCCMpPmbHEuuIyzf
	NiYPEvKvOuzop3lbXD0avs/V+Mrwq2IjwAp3OQXTW04gRyZ3Wm6ZDJ+4T9Ff6SPNQam3USw5OQf
	h7EmMc9Li6/o0wO2w1vaHKoMqLdglvMhAPGMX2VD1QncyZXNWTv5WUvzroTTA43tT/wuwbHI2GT
	5X/55w7APWQVbQO6kUiW4ML2IfdTkLmTkjYiYRi7YT4EgE3gLTcwaa09gWlIXdIXglzP/8KakUa
	c8QArTPzbiA2SEmi2TTppFj8Z7QXik0q2DZCIG9gt80gwC0VUg==
X-Received: by 2002:a17:90b:2252:b0:3a7:8c68:6446 with SMTP id 98e67ed59e1d1-3ae8987d10amr7610345a91.63.1793589982011;
        Sun, 01 Nov 2026 19:26:22 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:21 -0800 (PST)
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
Subject: [PATCH v2 00/12] mm: Decouple folio-based vmemmap optimization from HugeTLB
Date: Mon,  2 Nov 2026 11:25:13 +0800
Message-ID: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A26DD80007
X-Stat-Signature: nxy1hn4p17yzr145zyhoqyjiyad6ymd3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793589983-126168
X-HE-Meta: U2FsdGVkX1/56DICbKEDZLo23FvBJQSb8yvrYVTra/aBESymywE8GkVELCWXY3oLV48CufvgqVHdTLgYrze8Reo3qjNX1RuNsPYyyPTMJf/0Y40itXS3dtdgM+O0P1AgN9OItVGsLHhB3m34tyTnJIDCQWeT84bm8SX01GIGJdVnqV57S72u6KekwgP48pXDR521biUstH1e0BBrE4Cu5cWobdZPRQj7bJMUTmaEYxFL7StlHs9FDXJzfl0Iag5z8CHLT+o4G4T9rmDlpwjAJKMQsMUNzl1xz+nvRcu4bxxpU08hW8vDQ7hP9e4o0Z3ynaUU1cXQJUTAEmPO+YSopsj6U0TW/03m7/PdFxAaJ9r7jkBoMxl1FeSJ3Eh8RdQhk1JYg+Leu1X1LiI7aFVSx51kNeul+HdqJD9GV2Uk6nJYZ0JlpIlknq45xYg24LB3CQ7Dyy6T1sAeSGZyFEAGUkeV5jnxKMkZ13EWcACHk5g+7xNQ0fiB4LHUXChJJYmSnZ7iyTArONCM2osp0XNxD8ln8VapcG0z8fd5F31fSWlaP0zl22IVFnT0RAcAezK/WTl+zE315QlBzTM0WSFOyJcdPfq+voL8JOQ8MUqMK298dEY9j9KsY7Agm75oErkR6C8+61pU+7clJ90A9bd3ji4FSt1/UxJiKmoEFL5kN87GnHC28o52sb3IYz1BOqnwdpBTNo5nLde7kvBWIajPqZBsAgpt3jt5lChd5bIgDwjL/4L36OH7MGjPCTiqtMS1MDoCBsHt8l5Z/ke+i4QCPXhB0jzE7e0vuNok2XYvG8KQCpbsSePb9dB6dhyCf5zPRvZmjrJXnVuwPMV4OxYFiZzkfD+B/oAT5RHRjGpqG8rk+sV8QxMV7yMQeFkKO5/YENuM9mWL/aQTGeJr5gKst7zkc3ViL5l4fRyfVLkqecefA8vpCqU89P2CmsNo39XVk1e30cDQrq3n5cTNAqh
 M0EAQ4i+
 EUE4qAs8uJlo6jI/ohvRah4nPdATOgUSzJuZTR2C77wmq9XojxPzELOOSmt+XIh3HFBhxijel6X7cMD0CvjVK+EVZ2Dg4MbnQJDRXqcDLrHANcVfnJynUFohjyQG6Qcamr7FZt/28yeeaGH7M45jGmz08jIu2chy2UJ2j8OJwUo2gSjAev3Icq0sfw4ah4nOYC1p3ZsZ4QNSqUqSu7ZWNtCteo0lYlJb7IkMtbxSATar6oEUWZhjkL7Ljv6i16THFQwfsYFKSNeZIELmo2ChVbTsUbF2ieqsY+OZSvAtiyNbiMJlY5oYGYWbBRKS8HcVb6jIb/BhjaFAD0+JnnYLr2xQYHp58QyCnK8eoBNhrW99J7uas11vHOvMbjLV+aF6bgesI0oGtnTfbqmR2yth808NYdzvAQ/gAsuTgtHdsANzPLGg=
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

v2:
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
 mm/hugetlb_vmemmap.c                 | 373 ++++++++++++---------------
 mm/hugetlb_vmemmap.h                 |  10 +-
 mm/mm_init.c                         |   6 +-
 mm/sparse-vmemmap.c                  |   7 +-
 6 files changed, 182 insertions(+), 228 deletions(-)


base-commit: d42dfde37af766d1c272467352c0a56d3169ee58
-- 
2.54.0


