Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924A7E8B383
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3DAE6B0005; Tue,  3 Feb 2026 19:42:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB4D6B0088; Tue,  3 Feb 2026 19:42:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BFEB6B0089; Tue,  3 Feb 2026 19:42:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 878746B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:42:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 26F29D505D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:42:25 +0000 (UTC)
X-FDA: 84404923050.28.57250E6
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75F9EC000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:42:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7sPk7Ey;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770165743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9K+Ad73ToZAC0tkIKIowUNqNkC41RThWypaaBO1pALw=;
	b=BTZ9PHga6LEcckumCoHH26Uu/us9yRq1xUhG6SLR7gSHCDvbSLcHGDW9SQrJEc40KPdm/+
	t2oDJEWxMaGmeXaUf4HMO2RyYiZwbIhNlfwzoW9iZdK/R7D4S/AWr0v/A+Z9QEUJ97pEIr
	dpuHUl9ZnkLStyp6izH9m/ehIiQ88iw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7sPk7Ey;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770165743; a=rsa-sha256;
	cv=none;
	b=cwtVLKC9Af/6vNWRxrCec8us0RZ6LqhGf6seOkccYmAAdsere04pe1DgB6ylEiB/oCnLFy
	/tuaOBMgiAgiGD/DPLbMTbJ0q0FCcILIHxI/7VytV77ya/6yqKXLj86xjpV9e8OAghl8+L
	uUYcx1nX1ETkfoAMsOx/6803lx3XmQM=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-658ad86082dso10777056a12.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 16:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770165742; x=1770770542; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9K+Ad73ToZAC0tkIKIowUNqNkC41RThWypaaBO1pALw=;
        b=I7sPk7EypJKzcVsIhuVd3KwQyR+lZVdvnW30YlPhJq+bAG5OufLf/4ggJ+TBa/3EZa
         m2E28VX52xwQcJxXJhPZoRDNi7AFLco5WfZJyTJlYGOlJ+Td4nk4TANoTkM3spt8Jv1r
         iJ4sA0pLl+6jj0/Mp7/sufuCFbgYD7AG97UrNv/Lpy/290tt84CUxyBj4Xa2dx6eI7EG
         iIdGFR3Hm5Np/kLnx2i4td4e2o/WygaYZRuXeafts+QlLBQ1Eq2a6EDgyP9UYgwOQc/3
         IRO6VQcBmEsOCYuEAq8hrtiVW30LUMnqNfp3wUvWFeatRYH2DScn1NudYf1tRO/UxyBm
         E18g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770165742; x=1770770542;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9K+Ad73ToZAC0tkIKIowUNqNkC41RThWypaaBO1pALw=;
        b=wWW/xyeviXj9/NwzpvwTy/uY2JZhabyOCyAqhgQUhbN/Mr9ZzkzFw/hUkEzJUYQc1j
         kibCmvtAh0de7dwhVBbA7MRSbTI1mvsLPASwQl5ry7/KVGv9gx3vakWdLbfW2vypmDGJ
         4UzWynwFXNNtyTRG0HVIxvKuIz+fb7Fwl8ziO2kWAF3h+8DdTHUjmG5u7/pKT69rG/J6
         XOUcjWr1LXJU1/atJhZAs91rqYEy6tXT+hvGPz504KYm6DqwSZEsbWcvnRv6xRae4lLB
         vGspZUzs04kFMPjgrGrg1DZMbeeN0NkY3urbsqmZDueSeApyznVEHSeHzvqv/FYkos9M
         1WZg==
X-Gm-Message-State: AOJu0YwA7G2b6mDsJl79LqFHBCQl9BInmHTkQMZ4F15HxJCC+CBPiqv7
	3K6QSELQBukL4oBVlUep7RPHMBaBe4VIDuJFhePTHR+6MB40I8xUux39
X-Gm-Gg: AZuq6aLy37n/JVoeqHbIeBZOWHqRH8H9LfZs5S38MvS7PjaTwVrTXCU/dQvmDuD/vFC
	hQgL2ECDFUXD8TFU3ohUVhResQknesGvYxbW7Uh18Iuwy+zbhwaXWCj5Xict6h4NByixoC8DOWO
	ESjOInn2BFYp2JlxonycHIY+68hx27y9G3EgJ230zh3gxwjEV4UIiuIOx+NMgCcmpTfiMp6rwtW
	aBxep5D7jipIpXE/mOM8omv/0hgIsP9WwMG9ZKaJ186pzeXkqhB4LLxBKisa0gH/EXxAVC/ykzc
	tUdaaeFdj7nvP5mnE8e6kR8gl+GERdHjc/l4EJfCgW26n0ujUAVM8rpl3Yf7CMFCNtspTEb/QKW
	gmSYwKdMb0dJEdjpviPWlAaapCtFjgbkbHyQ4N60pTOdpHIo1Fao83UNx6WfEkD7cZexR+wNuYb
	toAL6srcM4UQ==
X-Received: by 2002:a17:907:7fa8:b0:b8a:f29e:307a with SMTP id a640c23a62f3a-b8e9f396397mr90493166b.57.1770165741562;
        Tue, 03 Feb 2026 16:42:21 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8ea0057dd1sm57062766b.65.2026.02.03.16.42.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Feb 2026 16:42:20 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	harry.yoo@oracle.com,
	jannh@google.com,
	ziy@nvidia.com,
	gavinguo@igalia.com,
	baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: [Patch v2] mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for shared thp
Date: Wed,  4 Feb 2026 00:42:19 +0000
Message-Id: <20260204004219.6524-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: r84amza3kycofj3b7ax8onzokx7o1b1q
X-Rspamd-Queue-Id: 75F9EC000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770165743-170592
X-HE-Meta: U2FsdGVkX1/Mzjte5XYlwe7NTvCNjA/pxfJWeERG+6b3/HNqd4C2XWI0xc56nU/9brfL99gr5Sd4K01Ib8FYxcHnOJm6Sbw54SDMp75o0+FAoCpY8viNvXmN1LenWLWNZmOlPmcR7WkHcsDoNqoU6evin0e/RkqVmI00Dj40GfMOsIcM8Rd0qsjZKAvwU13yCAUgeZVMo5wN+U8F3XTkm/SFRy49Z776wAlFGw56gCJyh6lKPp++KT2FMhnWi/4azi8VvB1XhbdS6tPyqxtnrMIe8DO3qD2okk12fgLlzfqXjT6DNDAIl2eI2V4SXyUw+JbXvgx6KnfuZBGd46dmTlsv60/S23MOjXJ8bSulUW3xOzOBWPn1ooz1yfoxedASk8/wUjWAsefOcnkxnaTp0r0jTyQjfWXBvvcWN09MzIjFszeoXQLucdaJzMUNzjrssSTuMjR6pVnEYZ6rIEoYMmjup6vZKRISXigV9Us47/v4w8htKvgugefG7mzncZbilWUhdS62zeOa0tWiSOGCTd4+XeTwCB5C+Gn+lEf2C4IHPlMGweG5KDaPNxMbM1xwGayvG05YvP/AYDfRRq4IeedINUx9gHoaLXDR+TR01F96uvtgVDkwBQpw4bDwNlKgsrUeGhxQKzkE5ayrQs8X0YHxyAY8KIqZbc6xiLlSMTccWGC6XXjPPLlUZ2VgWA3WTVapQ7MtzHi0mQiytitjj/ZDEHjYO2+j/6F/EiqwAcE9K6MQF87aJ6f/ezSFVQ2vtv/hIfGN1SBXl730skj5SDSEWv/BhicH8kEkMyEmOFuxbStns8dzEhhcDPFw1j/DWxknF/AtutLOipvLpeh2Op+6XXYwI8RKfPhHQZ6w7YfVQorlso1OMXRpF/5/NxfPOT6ZncslhAqZlO53flkA91d7jCI+fUx36pByzcoZzHHmCI0kDybqTaO7kZjPGg4ADxTaL2BBt50Ac/6JvcI
 XwPePfdS
 YJVcauUs36avkPla3r0P+WEcGGqJ9/Hx048SLfIBWbeTJIrdUWtZ4ZBcHf7qiaAWGEt5GzOOe87Uz907Vh6T75JnmxxGTHga+EfqVejVp1OcpUortUb0P24PmUuBr5KeK/04z0GhviTn5B6HxNdnnZSLh3A0O2xN73I3zruI34/c5c0kHz4z8ISv/agOfQvpORO6mGZ9PGun666a2MTzqKyzqADjMeAMIR/ywO2OZazv0/YC+GMJaeNXTaGX8zuDoexkLoFijwTTT7SBEHdnhki+ddAuAOfrTjxAovNzxm6Wl+yGp/WmmcWIPg/eQmqsqH+Fo49cG8bGRDUYPf6ZlmbAlFsfkqYKpIaw0LN79XPZ/XCDi7mzQ0uNzJjjY7W8+S+wFkA5nhM4LWMzQv6Nthcl+jxcrgfUIpenkrxKlfJd1eKebv62BJRL4kfQArX6S6SQxdK6Ar0BnwIvCTb9eR0jCdsrXWslnU2fLcUgfhQU+zP6F65rW2c5AigyVIbB34OHLBMb41EU5VXYadzNmJ1ipxVtNyol+6cbWLW0EFS2R/HpR0pecasJIZHje+vNyO0wWMJXTLBdjBCofoQxIRuR0W9Wse4jObIE1Uss5YwrbwN7cqcXfw90RhX773s6XqUdII+mXJS5c9WEavfrk1hrC//f7YXxMiOD1HgMrWds5yz4vo1SM9wYH6Bhp/g8I9m6pQi938H3+s1ZE3d78GlCiAK/1uy9Vmbjaf4u7Inp0XCRxOc8jwR3i1TjRKLY7GjCy90/r1yMgngcbTgByNDbBXZc6W/JZV6Ln
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
split_huge_pmd_locked()") return false unconditionally after
split_huge_pmd_locked() which may fail early during try_to_migrate() for
shared thp. This will lead to unexpected folio split failure.

One way to reproduce:

    Create an anonymous thp range and fork 512 children, so we have a
    thp shared mapped in 513 processes. Then trigger folio split with
    /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
    order 0.

Without the above commit, we can successfully split to order 0.
With the above commit, the folio is still a large folio.

The reason is the above commit return false after split pmd
unconditionally in the first process and break try_to_migrate().

The tricky thing in above reproduce method is current debugfs interface
leverage function split_huge_pages_pid(), which will iterate the whole
pmd range and do folio split on each base page address. This means it
will try 512 times, and each time split one pmd from pmd mapped to pte
mapped thp. If there are less than 512 shared mapped process,
the folio is still split successfully at last. But in real world, we
usually try it for once.

This patch fixes this by restart page_vma_mapped_walk() after
split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
(freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
just split instead of split to migration entry. Restart
page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
again and fail try_to_migrate() early if it fails.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: <stable@vger.kernel.org>

---
v2:
  * restart page_vma_mapped_walk() after split_huge_pmd_locked()
---
 mm/rmap.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 618df3385c8b..5b853ec8901d 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
 			__maybe_unused pmd_t pmdval;
 
 			if (flags & TTU_SPLIT_HUGE_PMD) {
+				/*
+				 * After split_huge_pmd_locked(), restart the
+				 * walk to detect PageAnonExclusive handling
+				 * failure in __split_huge_pmd_locked().
+				 */
 				split_huge_pmd_locked(vma, pvmw.address,
 						      pvmw.pmd, true);
-				ret = false;
-				page_vma_mapped_walk_done(&pvmw);
-				break;
+				flags &= ~TTU_SPLIT_HUGE_PMD;
+				page_vma_mapped_walk_restart(&pvmw);
+				continue;
 			}
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 			pmdval = pmdp_get(pvmw.pmd);
-- 
2.34.1


