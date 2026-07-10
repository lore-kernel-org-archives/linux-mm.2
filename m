Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39964C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28DBB6B00A5; Fri, 10 Jul 2026 06:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2659A6B00A9; Fri, 10 Jul 2026 06:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A26F6B00AA; Fri, 10 Jul 2026 06:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E95216B00A5
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:56:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7B667C1BDC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:45 +0000 (UTC)
X-FDA: 84972563970.07.2E19B81
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id E4A66C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OCQ9off4;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783681004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+cZtzCSgj0oqYkJlHKXjgXLag2Yp/++TMmV/k7LrHM=;
	b=IheBN9qv39NUoAcrDF1ximWYhp/VcDdHXhDce1q/+raBTL520X5iLkITiFTCm9d31nvRxo
	kyJG3iqKHQ0gSnZ6/aFRoCnMGZ9xfH1s1PTZYhya8RpEGZ94AmTk4fgp29thsCLCKNeNeZ
	5jgfTSccr3uvnKRat6XWz3JHcDCSNgk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783681004;
	b=TsWiilwidJTft+7vrYpp39sFGADwyVB6rUFzrWDJ+hXa8a1qQQLxWjB2iX1ee6kG5FM1Jj
	OZ1qQ07yNaQzQFSTImzBSkcRg9jxVtG/QZutmX5bcvR/2GLfY6DuQyXX9idV6Yhw1/TEax
	Cw3kpJCBafuyrNRzo0p1w0+wcJU37HQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OCQ9off4;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783681001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9+cZtzCSgj0oqYkJlHKXjgXLag2Yp/++TMmV/k7LrHM=;
	b=OCQ9off4uSBieuNMdiqSXYI9BbZC99ylbynli+MY5iwLPMJwgNX7zyVGsQPB+4Cg7Uh7zA
	wgNSWCW1NuX4+wBtWiAo3RNAOESXyPjb0+0Usvz5cwtmG4/FEfFp76IcZOk3k8miSJ/Ipd
	Ns+LNpp7tGEcaKdjiQuRubHhH2yK2bM=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Cc: stable@vger.kernel.org
Subject: [PATCH v3 3/3] mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
Date: Fri, 10 Jul 2026 03:55:23 -0700
Message-ID: <20260710105557.1987433-4-usama.arif@linux.dev>
In-Reply-To: <20260710105557.1987433-1-usama.arif@linux.dev>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4A66C0003
X-Stat-Signature: seiw3m1tuqrx9ccgkc8fxbkyo74chk8y
X-HE-Tag: 1783681003-322400
X-HE-Meta: U2FsdGVkX1+H35xZ0L0+NCtugBoGy+c3qNopmwTh/lcgnLWjSDnHbGLFOSt2oDMuci8/YHGR6HmTGM6LoQLM6kwEk2C0I7JC5mIBDv1GUx8Os5m/m993hLBSAb5t0UaFyA8OP1mjZyueRCgA4WUCEUr3tiF+wBqKU+4o6h8KYwSdCU9ynOjmwppYswGTY5Iigm2jj0AvLUb/tazWa85T0iTbVWpoa4hW8256XEfxB4jFhjYq4iSdOmxTv5B5PGLRPVPixnU3xeGcmnJSosPnsjdjqZyPt+/1R+QjtUr4tWHzDxVoJ8zKpjYFHNr5WB+FxoBj9cCyI0U6Gca8G4oPdTU0nmcLXB0LxznFHtLINXIvnkhjE1ZOid6olbf+S8/T3ruksh8JNCEUj85qp8iJt6LabfzoMXrYtAwvA9y6u/jDrYJ5ty6fzAsDwqme3RCZdW4ZQgEJqqcpfRkrK2LvH0tHj5TOxXcYOWKhe6VVDCaZFeYTtVJC8pzVBSVMgU2/xLwJ0wYSy1wyPTg83p7LDx6P3y2QWoFHKLcVFyNHsrysGMfY3jEAYPDnRMqtDw7GgPizhal+MB38sRpkf1qLeVpljWFW9k6vsA0zMJc6NK8jMnAmOQl/awn1lt4NAQ9IQR+jQPLUgDjxomO7SwxtDRLb6qm6xtNSNrY5mC0hBJe2I6tc2vkbB5jA3zfxPPWOFEhBr2H3h75bWvX8GzrbxAgSZ5HXcNGqEg/n81iQd0dtc/xRTlsJl2kaiDwS0zBGMEINa828c8MCZiYWnNybSXPXp+C6DvIui0iLNetOU8Z5t4cjktM34KBzYaIulkJzZ8FXOs7CxsDMFP2QbCOBYrIfiwAB4yj9/+52+fi9CsqjqINGyeiVKJo7SGvlc7JtA7OKvdkd7GDBcVmYsvHlJtdlVcyJNIqywYmQY+ad6I1Dc/mZF/s9QjbVIX5MmXZPO9uQnYltxCtRohfbPA0
 vUE97qoq
 09mhuD7W3bcukcuoxT+Nre0k3cl7hmHrJI6haBzDQzgSm4+RGVUkXajHHkLiOYVELo1du1PC/uK2+nkBNw9TmimXsN04oyS/w5MNja23VSJFECa1aSLrCmO0aprgDeYMcaTlSxkoEli935zc+3eFU84zuHPc5L5Fc7k1fXT89ohHKN3TQzJhEAPLO8BIi/Su6UvxuL1ZnVWNALvVYduMGZS2xDIS7sNyT8zZQGaIUvYDHmjNXVPBk0V6Ov332ivLM1+sGRwq3eYPSikavWPQez72gm60GF1F8h2NuFpcq+O3eMffHCDy+UF7n4oR8biDvAcdeghgAGLe9CKGUp4ba3acoA+wfP92mq3u1v+1ypYfuc4Hl50gUvIc2Q9ofo7xL/9yLc+I9ZhuryS1wUKoJC2hfRcJ6SatFi/+ATl96DuKOelNX35yiq4GoXIp/5rPeTpm9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
madvise_free_huge_pmd() takes pmd_trans_huge_lock(). pmd_is_huge()
returns true for a device-private PMD, so orig_pmd can be device-private
and enter the !pmd_present() branch.

Skip device-private PMDs in that non-present branch and continue to out
before calling pmd_folio(). Downgrade the check to VM_WARN_ON_ONCE() so
an unexpected PMD softleaf logs a warning rather than panicking. Drop
the thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already
return false when that config is not selected, so the guard suppresses
only the case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
migrate_vma_pages() flips the PMD to a device-private entry between the
caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().

Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c0892cc533a9..7ae21b006b68 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2297,8 +2297,8 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
-		VM_BUG_ON(thp_migration_supported() &&
-				  !pmd_is_migration_entry(orig_pmd));
+		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
 	}
 
-- 
2.53.0-Meta


