Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9702D606B588
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=ivtlcE18
Received: by kanga.kvack.org (Postfix)
	id AC39A6B05C4; Thu, 12 Nov 2026 06:28:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71966B05DC; Thu, 12 Nov 2026 06:28:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9152E6B05DD; Thu, 12 Nov 2026 06:28:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB216B05C4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:28:49 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00E381C091F
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:28:48 +0000 (UTC)
X-FDA: 85426244778.20.5594A9F
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id A610220002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:28:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ivtlcE18;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=UAn57X8Noov8dIFs+auheT8K0Vbw2KyihjU2R8Ks96U=;
	b=OHGfsHnsuxeRtlKJcKy/dO8UrGi35eoVV9XKR72oWvIGgQ+Ps514QUBwKFxTcgGsSAiVob
	HSVhtWV7pkjYaUcRdaKpugz4Tk+0FgNiW6w32NQ47MKiLI8Vlgqiu8nvPjsMBxk0rsDzr0
	BQ+uEcvsAYDX3BIO8pfzGKAqXSg5JBI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ivtlcE18;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482927;
	b=CPuzhxR6Nj9cHzpiUcoY5HNDJTjefdLiS3+QOC5Cst9pU2u8ee1UQfap/FKYs6Lz5Z5bhb
	ovpyvXofWxq0cppTbfyBs9zhvrjY3pgu4LAhLoKkr8w2fFJfZCD0vTsGDF5+V7onvwbY2y
	IxX0YNRjtIDgtQLtGdD7TvmO0nUK8NM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794482920; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=UAn57X8Noov8dIFs+auheT8K0Vbw2KyihjU2R8Ks96U=;
 b=ivtlcE18Fyc/nNk4cxwLWTtHXseGvVBWbIQp6WMjMdXP6ss5Zut8HYwY9Pku6VRiUk+Zae
 sCTwc5z1PXLFMVSviRr2LXHz9oqqnrn/ogYepzKUK6sEye7WYg3MujuTLVrZZLNDGPVC/j
 suPsyuy68eq+2RaPYmOXfdYR8sumxU7Z+X9RV49bXVA4DFOHgMXWzrRMee63WwViAmfro4
 NtNgP0Sq3nj88dQxNFayde9JbICa7jtZlocL7X26RpzbcR95A0d3YbDcs0K1mDTjwhAeF1
 n9xD8UddJ8WiU0UOikCYvWjTLR4yqt0yvuYt2L+MQnOjen42O7NUyxfIBDeadg==
Message-Id: <20261112112816.55095-1-lizhe.67@bytedance.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <muchun.song@linux.dev>, <osalvador@suse.de>, 
	<rppt@kernel.org>
X-Lms-Return-Path: <lba+26af5a2e6+4d1df2+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Subject: [PATCH v3 0/2] mm: optimize HugeTLB bootmem hugepage init
Date: Thu, 12 Nov 2026 19:28:14 +0800
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A610220002
X-Stat-Signature: ensesmj8fio1e6izrmwzpuh3b9o9k9re
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794482925-132512
X-HE-Meta: U2FsdGVkX1/PqyhMTfSwn69YFf8NZpQiqxBXWtzclyI9bHSZ2X0aGnSwyL0VPx7vGpLvyV1ejSTs3UygaJCOpl4MaYOAw2u+BS9lTfpmint5l1leBUDrDS3qct8fbaxRDHIABL92Lyg3N7A/vhMX5AbuAd1HF6yFwbglOehgh6V0EJsnagKO81xrRqqsr9C9tZbl2Xdtu0TDm31NxhEUi7NHzEoHbXfUqOjARXySGxcvBaliP0liDQ83KEGWLr1cbdw9e/LCq44g4n+YfkdJQLK3gFixaUZExBzKqS840JaXJF4iIiMI9HAEewwWCsTbUSnl0FPqryv/7O3ApLTiZBD06VJKmB7Ur0+LkCa0/3uHjBI4QVsCGrmp321XA3Fp1lbTl/Ra3LVkQVR+QEa+73rMEcarv0ZampQWN7kiSlHJNKDhlFY48AqIsCyQjvilwtAK/wUl5ksT9gXYCO1IXi0lcgT1SD6XGCxpx8Qah/Ac8JMAsLseXdbjGroB4fJRWdFBXl9Jvd16W+Lgac+yiEy+QcGtsI1NLKrPEHXAyOLEWwZok0b6c0DT+u22gqq7oHDDgxBaUIWodELYppxW32DZ6rhQ7Bzi1BfnCJPBcGqrLQYF/0SajX4acepqB1E9pNUAI76A3Y7qrKJIWfpDDipcTzV1+SWVkHmnBXicwNMnrMFoldfckcLkKG/jlvE9/hfLnFZqFpZ7OuaBDsuj3fhTivRvTgQ0nbhs3eFH+u7gaRlafkIM+hI/jPGaRh0UwWk2hUGqn+D9/Fk0fHzv9+CeezrfSgK+1AyNm72L3gRZyxkA8xO2epv1MoQ5+Jf/T0o6z7a+V9cUIN7vZgn36z6wHvlDczxM6xmYCdxDmKrzf6XJbSCvin2BsZXtEF8qpkF+sWrHqNepjgbdNuWpIea8X1l3jSR20i17NaWS/gHAWMo9ml8k+lCKElWPHazuUfANGhGZjMoZyn8Is0S
 ZqKSMPeF
 9XPhoxVscDC4s3pxodEd5DpRfvwau6Ncc48b3t6bPaquP+AKlRf0JhFS6P1QIEEcgnSgo0br1FTcXoajrl24rYxmXoF43RSfYtWKn7oMMX8lXBwB/dTM/ehzAQmILmbWjQY/48op0spkOvTH+FjEGmXfTqU7AsNeeXn1YTzu7XorCKZUIX5EJxnA24naRlEEunlkOSYhDcdfJjTeoJajKaumNlKmRXxviVVZlyBHvKO7Wly/1hF/oqgXyqLtykgV53yypwlWIxOTdbfMmF/6WZTu2mw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series speeds up the fallback initialization path for HugeTLB tail
struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
optimization (HVO) is unavailable or fails.

Patch 1 factors the PFN-dependent template refresh from the ZONE_DEVICE
template-copy path into memmap_init_refresh_pfn_fields().  The
ZONE_DEVICE path keeps its memcpy_nontemporal() copy primitive.

Patch 2 adds a HugeTLB-specific copy helper in
hugetlb_folio_init_tail_vmemmap(): initialize the first tail page
normally, then initialize the remaining tail pages by copying that page
with memcpy() and refreshing only PFN-dependent fields in the destination
page.

In the earlier discussion, Mike asked whether the same kind of
template-based initialization also helps the ordinary struct page
initialization path:

https://lore.kernel.org/all/akfB6Qe-jKDEMUxz@kernel.org/

I tested that direction as well, but did not see a measurable benefit
for ordinary struct page initialization. The measurable improvement I
could find is in the HugeTLB bootmem hugepage tail path, where gigantic
pages can require initializing a large number of tail struct pages when
HVO does not cover the allocation.

Tested on a v7.4-rc2 base with 4K base pages and 64 boot-time 1G
hugepages, measured with a temporary jiffies-based printk.  HVO is
unavailable on arm64; on x86-64, hugetlb_free_vmemmap=off was used to
exercise the fallback path.

  arch    base      with this patch  reduction
  arm64   360.8 ms  256.0 ms         29.05%
  x86-64  171.0 ms  165.0 ms          3.51%

I also checked memcpy_nontemporal() for the HugeTLB helper, but it did
not show a similar optimization to the PMEM/ZONE_DEVICE template-copy
path.  One likely reason is that HugeTLB initializes tail struct pages in
per-hugepage chunks, while the ZONE_DEVICE path is closer to a long
streaming initialization over a device range.  In this HugeTLB fallback
path, the measured x86-64 result was better with memcpy(), so this series
keeps memcpy_nontemporal() in the ZONE_DEVICE helper and uses memcpy() in
the HugeTLB helper.

The temporary measurement instrumentation is not part of this series.

Li Zhe (2):
  mm/mm_init: factor out memmap_init_refresh_pfn_fields()
  mm/hugetlb: optimize bootmem hugepage tail vmemmap init

 mm/hugetlb.c | 23 ++++++++++++++++++-----
 mm/mm_init.c | 11 ++++++-----
 mm/mm_init.h | 11 +++++++++++
 3 files changed, 35 insertions(+), 10 deletions(-)

---
v2: https://lore.kernel.org/all/20261110114859.76343-1-lizhe.67@bytedance.com/
v1: https://lore.kernel.org/all/20261105120615.16817-1-lizhe.67@bytedance.com/#t

Changes in v3:
- Share only the PFN-dependent template refresh.  Keep
  memcpy_nontemporal() in the ZONE_DEVICE helper and use memcpy() in
  the HugeTLB helper.
- Copy HugeTLB tail pages from the first initialized tail page and
  refresh PFN-dependent fields in the destination, avoiding a local
  template in the HugeTLB helper.
- Restore the empty-range guard in hugetlb_folio_init_tail_vmemmap()
  after Sashiko reported a valid powerpc 8xx case.

Changes in v2:
- Add a comment for the template-before-copy ordering, as suggested by
  Muchun Song.
- Drop the empty-range guard in hugetlb_folio_init_tail_vmemmap()
  as suggested by Balbir Singh and Mike Rapoport.
-- 
2.20.1

