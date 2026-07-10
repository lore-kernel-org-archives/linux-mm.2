Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 862DFC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C776B00A3; Fri, 10 Jul 2026 06:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F4986B00A5; Fri, 10 Jul 2026 06:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 831F76B00A7; Fri, 10 Jul 2026 06:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65C4E6B00A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:56:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE38D40430
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:39 +0000 (UTC)
X-FDA: 84972563718.22.37A5993
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3FEDA120002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ON5e/gYP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680998;
	b=7kMq7BqJ9PjajLgOzmYQSNQZXB/d5o+b8iH9ASLfrXUoC+NzRinnE5nkl4HE4bG/mBFsAh
	u5oHlyynQeejCt6bioE+t2gvcyesYB7nmKWPu1NWI9SICd8kNqDRRm+SWhaCnlRXOPYw0y
	h28X6C/rDGzIGIzDqKsJ76PZGRrRlzc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ON5e/gYP";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/976mRd2cZjP/VBKknODLU4xXVA+kkf4lFHLX7WcpM=;
	b=i1/fba0lL5AdtuMcmPvVzP6DHJgnbH4PHKh9oAU8+O8aIH0QKVDTC/XnASARUw70AJgeC6
	hOUe1pWCEJ2Jrbib26BIdnmMqHqwHPtYalBSBSCV/f6WW/+mnKhhrZmNm1sgWaqt6wEbpL
	+KhRkVIzPTzSsiU8xaHewsFrUV+6h1E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783680996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t/976mRd2cZjP/VBKknODLU4xXVA+kkf4lFHLX7WcpM=;
	b=ON5e/gYPsrMuRZSzRp8rV82PX86lwCFqokmnB0Fb/eRWDcDOdHDA7Byw3uDGk8Qdb7SQeu
	GdbJtqhtHLnndIcI9s/sPXUo81ZvaKgj5rPpt4Apj4mDdRDXl182WUzkxklAZ4ewoNgWyX
	37P62V9h9hG+gdAkOCdsEDWluabss4I=
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
Cc: sashiko-bot <sashiko-bot@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/3] mm/madvise: skip device-private PMDs in cold and pageout walks
Date: Fri, 10 Jul 2026 03:55:22 -0700
Message-ID: <20260710105557.1987433-3-usama.arif@linux.dev>
In-Reply-To: <20260710105557.1987433-1-usama.arif@linux.dev>
References: <20260710105557.1987433-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3FEDA120002
X-Rspam-User: 
X-Stat-Signature: 6yy6m7cebxmbookc1mo9tdmdehx3zb4c
X-Rspamd-Server: rspam03
X-HE-Tag: 1783680998-401013
X-HE-Meta: U2FsdGVkX198xWrjw3ROxAJCvTZoJWXJq1CqKOquMPRWTznD3eEowKkndHKkoKaXkdqriu57P5UFC+bxjpqbd3zQdZ3z1FCcVmwdMeTeFiytRv0Z/CFHiTQremRtX4g595bH57jqGaGc49dxaGYHOuDA5CaeDg0pW7+Sv8vVPQmxNGVLcX/k/xpt6oNkpLDrE2cHhlFJ9n6yiDpPzYcji9xmiOfgfmR7WnDGXhbh0pTMoi+xsdRZykNI4tvmDX6TVI/zkWuGYjF2926Gapno9uJIfFCqZzeObiusqbJ2wpSr6DS2RtNuu0AZBZyeEAfHxPXRI2Ep38aB5DgTgYyu0thtcXN9gS4Gz9BNY5q4nQamwoXIbnslJjF6uGC9Ifl2D825defDh0w6Z6IfGQZC6JyUodxTlWrnSZFpzYUMwVdP5xKVAHpckcqW3xs2PVyPc7J3QNePVzNHOsT5dInlGEN2+slpkPI1BuqelkGk8tPeGeSEGUMn6yAy5MQ+FUm+sac2agccv1uHo0E5kxBC2YPasUGNlCGRaoHLecarcOeloZc9ztouqNDrXC5OV0zEKqdQzEQpKtHbrY9T1U+89YTpp6P2FEXHcTa0Z9POr00qNh2ybgg/CQNw7Vsm7tNIxLOftwyzuKIfSq8hi5gpt4gg+jLtRh2nfN8r5O/mvct3VRcVR37Ve7zfEAPTu3U14XmL+6SzKLOy9YJUrzXDw7UX2A1bZIUMKeiKhpVFuNtql5TF7iOfYqhTrlDTs9Y6dnpbPB5YlJk+lMSpZUwRqa8qgEecMuyb6Kx1YY5buSZ7j35D4k6LrAadtdBll4eEW7U2o02xVWMQxWxHK0ZZIISQjLpwapD5am8mB6KbZaxXUZJ3d/rUT36tPul19xFj2dKOYXwNwNn9E1hks7NQJ+7PSbDDElJTTkk09E1bGRnbuttGJFQW/xbfLXDegRuo9G5QZKi9oohdwRFesC0
 gjc9ZU/8
 pi4W3krUXXfSCriuJkc8k0oDil/iD6s+pFXFl/CKN8e2Sc2LrGXSMARuKJ0PySJqMqCWwEOPTkvX8c1x/OBsSB7/Uarok/RtPWM+9u7fRMHsq9g+BSRVhgZkm9D7jpgFM7lRcXl0WTj3Dq7bnP+xL1ZNEdP4xs0t+9shekECFY8aKE1bdHMueJiZfdPNZsW7oBbLYkLEgTr9sVui+HeEjA5i/FCsqDNKGM16JE1Ddwu0xCq91Gmecvwg1aryzS9WGemtZWPbTbpqm5FsXzQtaw8BwHFf6jOi8VV0PRN+JfYYmqc26NenYEJ1Pp3wCDFaaf62tjDLo8DdooPXq7EHhKPIas9zLEXo4yMcy3iIpvfGdtW6VvzJeXJtY2nkRh5FW6ycbt3LsaXHHHT+tUMjcTjZ/Kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for a device-private PMD. The subsequent
!pmd_present() branch has a VM_BUG_ON() asserting migration is the only
allowed non-present case; a device-private PMD trips it.

Skip device-private PMDs in that non-present branch and continue to
huge_unlock before calling pmd_folio(). Downgrade the check to
VM_WARN_ON_ONCE() so an unexpected PMD softleaf logs a warning rather
than panicking. Drop the thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already
return false when that config is not selected, so the guard suppresses
only the case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with
madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
migrate_vma_pages() flips the PMD to a device-private entry before the
PMD lock is acquired.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Cc: <stable@vger.kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 9292f60b19aa..c557023c3fad 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -388,8 +388,8 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			goto huge_unlock;
 
 		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					!pmd_is_migration_entry(orig_pmd));
+			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
 		}
 
-- 
2.53.0-Meta


