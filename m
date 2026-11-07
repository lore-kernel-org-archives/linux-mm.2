Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D49B606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 02:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Bk1gJL/Q
Received: by kanga.kvack.org (Postfix)
	id 5F8576B05B0; Fri,  6 Nov 2026 21:29:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7B86B05B1; Fri,  6 Nov 2026 21:29:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F946B05B2; Fri,  6 Nov 2026 21:29:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC676B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:29:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9403C16027A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:15 +0000 (UTC)
X-FDA: 85406741070.07.A796517
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2FA0A1A0002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:29:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Bk1gJL/Q";
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794018554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7sMnTr3y994wfcbimt+l9yBgD/ZKDtjQNzqbWZRRBzE=;
	b=S998AQuxAir+4qa1/BTBr56V6OM+GSxmApoVEo0WrLZkZNAm49Ehb7of4eGMs+9FbRQG3A
	qgEDZeRZjrp2x/FZMd0yWCnBIr7oCyb5h8GCLzpWbEOF8FT4GEydMGgDnvcZDOkShuHfat
	9QiLCisZNolbo3T80FU3SJg/HLhRsJ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="Bk1gJL/Q";
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794018554;
	b=2mPcrRpjWiCfYO8FrUeaYKEYySyToPMoI3qVZWdjtPxXtXr7J6xxtX6B+6+ZDY84RCBaLU
	eJJgYY8S8A63WhBVVpI4Hk5FblWXDL0E16eQrS/eUOsP1c98nDT6rU2hAhXDekqd5kCa/O
	M1y8V/k4J7HWztXKfBX2I0aRdKTRPy0=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-3712b6d9843so36621eec.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 18:29:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794018551; x=1794623351; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7sMnTr3y994wfcbimt+l9yBgD/ZKDtjQNzqbWZRRBzE=;
        b=Bk1gJL/QqTA/LQL58dCwhW5HN2P7wSD5yBKM+t5uwtA4xL/rnfsY9EaPd+CBMDVp55
         LTfd5pq2rIZoPCYs6xBPSOQBpEvlGMX0LDIDHbhcwijtpDa+uNJ0tPcCu//M3LFEYBEs
         ZCP1pGLEwt5EqcG5x6FlIdi07qujsY1JewjHXl42IEB+DmHQS+a0mj/2TiiJ8Vnud4nz
         luU41s83BLY1zUxsFvUf0Cmr6bY8dt3WLruH6AZjd+J81RY3sBZ8bBarB/cearg49PlV
         9f+ZN31Z4fCzyYhLz2kgP5wEZQ0tngruZ2XWLnBciq8tWSTpDVmZhn0Z2IrZmqNMdsOv
         rxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794018551; x=1794623351;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7sMnTr3y994wfcbimt+l9yBgD/ZKDtjQNzqbWZRRBzE=;
        b=ZCSoZMY1SSxzF811qUr1ByCFsUWWxOxz/rMKbDN+uJ4vIfNWz6w4qhSvRuel2rojLN
         E6xQiyyViIaaImCtbxVgIETc7UIPDVAXO4qcrJFYLjBGjs3eWCVVcoGGxHzIMWlKCTkC
         EpfN0/9XteKofxt1D4KBysoH6U0QOOvIaXWhj49ns2Suq17pakZokKl3zXCcVE3Q6lN5
         YOg7s7JwLBNIByP7L35GzPGEoD2NeNyRXEavd1CBNXXhsIpZxSTlHEHDVxbYeLBV9McZ
         gtLcJI0iTIIIXFv0b9SwNqtWg5d4Y03oA37wB9OUlma9aBWE4zryupiw5VC/Z3iExn36
         NBhg==
X-Forwarded-Encrypted: i=1; AL+hErHFBmqAN6vSbBa1v+twR7OwtiRzh9WrW1P44POuD2tGfQ720y/oiScERX+tisPX3t2+2fsKKnI2tw==@kvack.org
X-Gm-Message-State: APuU4Z+FujMeVQEf0OHwlYymuB946WTFVudGyJjt7EwrXcGs9CcqUrzB
	UDWDpAQob8R4reqRK8wgz6iJtrLv+ZmK4IBZDgT0wWRBh6inY9rpmwF3GTawE80jTV0=
X-Gm-Gg: AYBFou0Y63ptBsUV4MBIZxkVwxdPnhFVd7nMfPSblCcxcWbdusF8Jn3sSsdx4p5nIPI
	hhvn4Z1ECbxtGHuVXvutJvdezFv1g/1srMz1kO5IJdXrFJkDcHITrlQAa9Uz9EtQPmdlTm5Qlzs
	ItXJQJmBhcZvZUL3NJBtNc5UrtLagN+Wsr0JeOGUQUg6gJNuhJLkChdk+BLoYtETQ5gAYX+AlYs
	6vO3ygmMXt37d34Cp/Mx1Nwgx09uVIrzM1vwS4L02bNPxE8dWZw5i6cpOAzUpKYLQPSTox819T3
	17jZBRevPAbX5PIRF6UVZyfjzXwXzemXM3SIWCGRoVQ2nEWQ/X0r+f9hxlkD3EiTlR/yba8Kg7/
	c7pVeJTKKvWukv4HaHYyqoGlKlFgwj3Xhnr/kK7Skleh4684B5e0c2RgiJGKf/ACuZX2GM5AlK7
	kOl3UhDVF6OjCAFILs8hxK4KCFvqfd8Zkhb4HRIsD8gpN0WH6IhCKzTvokAq7t2Okv3nwTJzKHn
	kepstEuu+2zysI/aDWU21m+ua8KRGKlPqm61DDOdyBR3WljntRowe/KRKsohbiu0TwJNT0XKCqJ
	NoLxNI8AA7ulf8Om5iCKhQ6ra92RwLHfTFoB5+btbS3MAQiXbhdti9GUz5vR
X-Received: by 2002:a05:693c:88cd:20b0:370:1333:5e84 with SMTP id 5a478bee46e88-37013335ee3mr3852383eec.11.1794018550307;
        Fri, 06 Nov 2026 18:29:10 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36faa4b8aacsm10457077eec.23.2026.11.06.18.29.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 18:29:09 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Yili Zhang <zhangyili01@baidu.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 00/13] mm: Decouple folio-based vmemmap optimization from HugeTLB
Date: Sat,  7 Nov 2026 10:27:43 +0800
Message-ID: <20261107022756.77731-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qhegbknjtuj4gmjueymxfi4bfp9qurra
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2FA0A1A0002
X-HE-Tag: 1794018552-379766
X-HE-Meta: U2FsdGVkX18exhUlVBlI/7uB9HGn/H/SRaQJTjFpWYnBeMEPnhPEdmdNpTpOjN3VLm2iMivOswcND2YCQYXPgZFikEzQ5XJSLSVj/deycypwNqQNh28lcqeJXF3hJBV6vvxj1WKVhjj/Z8OEs+jhOghknu64KKsE8eLRZQYnD2xUjMV2YGFtcwpwRMrz9UvF3afzCzxX0BlUNWJnY+8YudZGs6uCXFWin6F/o332xCZmZrAMJ+ljqxf4SfC1u3PcFkiC/lFc8bm0VrpRdlWCjWo1q0H5XNcytBYFosXkkLXPRR3y9MrxUbQzMc9qzVmhmsC2UhkkTcq8be4dcOXU6tmyO8W+UXRwXAPWfNe23BVg7nuWOLCbcHN10um+uvkxoPc/izAx6gxj1i/rnyXlSfrWL3N8O09ZlGi5+Re3L+UqQ1BcYu/OcgYkW0eoy7WWr1HT46swDqeK+5EGQNtwj69z6gZXP+kn8ZHqN0ZtWvXSqEXJd7K3+CHC9UD/HxmMmdMAhCBsPOe4hsmrhg4MWn+PduWIxInjNqcDwKxJeGNioAC93Ljx0enbcCxCobx3VPZmFkq4AHKSgSoRPTimd2JkkefPMGE7C3dZJLPAyktayG5Z0Sn1D6t62K+fFl0x+xhUdlzLt9KKJgY7Ato8dWX6JuMX1jXNrKimhSczZhelMUIKhBzOZOHfCvCF4bnNV7ty8TxyIAiJCwP3GOnA+YyfCq4q4VbObpBpO7d7SkUrkXySi/NJpU8cpS/GqA1Uog2AIWcMU5lRNRA5SVGMpWhfokgNXSgA9ugTPC3XFSeTKmKe4nF1i4DEfKC+HcSSgYnORGuRMhP6bmskYpXQzuo5DuPFuf6TjkdgXnMZNvbujsG/hwLJ1lW1ggt/F0I0V4sUVnzbzwpBXCIIU1hniw4i3j7kCj1oqegBfPjrmy+FHrQTLalsUZPKRGEf3JOam/zH+eViL7D+ZJj1J5u
 Bfa0/g2M
 ndAXYhTXILC8GlNEeB0YSQO8U6ZVw0wA9N7A0atILeTDVey91Nk2KzymOVRg/t2WstIiFguqnrdTN3ulvg4BHZ+AncFl2CLjg0YsQBWcRdgCnDntUJnXypqwcOEFvXJvGMVT+Kb+OMJG3SifRYc2lQKF7WSITwIU5U4uyRS5NobwNqBefdKNfwBLBqleN1bTGceDDEiRrukjoPnMfCKF1GECx8I1+8cdxRY+mEwUR4pV0ET6yhwF3+G0SNo0GS4gwU030/GoYS9h+F76zfEEcB+CZfWls/sRRWH02Ov/t6pIOV5n0iVcOvf5gi2LWWFtLNraNf+6Qh48TiuvolXVLhIKHBw==
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

Patch 1 is a standalone prerequisite fix for best-effort HVO head-page
allocation. Patches 2-9 generalize the underlying vmemmap remapping
infrastructure by removing HugeTLB-specific assumptions and simplifying
remap control and resource handling. Patches 10-13 then establish
folio-oriented operations for optimization, restoration and PTE
conversion.

The implementation remains in hugetlb_vmemmap.c for now. A follow-up can
move the folio-based operations into the common vmemmap optimization layer
once the interface boundary is in place.

v4:
- Rebase onto mm/mm-new at f735a2c21aa9
- Split the HVO head-page allocation fix into a standalone prerequisite
  and retain Yili Zhang as its author
- Add __GFP_NOWARN and pass caller-selected GFP masks through the
  generalized allocator and folio-oriented helpers
- Propagate alloc_vmemmap_page_list() errors directly (suggested by Oscar
  Salvador)
- Remove the redundant order check from vmemmap_pteify_folio() (suggested
  by Oscar Salvador)
- Collect Reviewed-by tags from Oscar Salvador and Mike Rapoport
- Collect Tested-by from Andrew Morton

v3: https://lore.kernel.org/20261104023510.260766-1-songmuchun@bytedance.com/
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

Yili Zhang (1):
  mm: hugetlb_vmemmap: fix OOM during head page allocation

 include/linux/vmemmap-optimization.h |  10 +-
 mm/hugetlb.c                         |   4 +-
 mm/hugetlb_vmemmap.c                 | 379 ++++++++++++---------------
 mm/hugetlb_vmemmap.h                 |  10 +-
 mm/mm_init.c                         |   6 +-
 mm/sparse-vmemmap.c                  |   7 +-
 6 files changed, 186 insertions(+), 230 deletions(-)


base-commit: f735a2c21aa94b7b86a93d36f3b17eecc6d49aba
-- 
2.54.0


