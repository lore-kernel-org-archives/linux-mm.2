Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F83EB7ED0
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 12:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A885A6B0088; Wed,  4 Mar 2026 07:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36476B0089; Wed,  4 Mar 2026 07:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 942E96B008A; Wed,  4 Mar 2026 07:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEDF6B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 07:02:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29B0F1B8407
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:02:02 +0000 (UTC)
X-FDA: 84508242084.19.550B1D8
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id 93783C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:02:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772625720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ZmpKyck8JszzaIri3QH95hHFbefaHHPMS6y8aBuMvvw=;
	b=0v+gfkbTC191Hf9WcrjS/YHM5e22vKY+laZur3Z1yeHs/VIiWB4Ose+rcSV/c4vq9waDtZ
	dD1kPpGoyl4n02yG3E1lsYHSEFfyAaQetHtxkBUnVi2ZPjgsF44aMetv0G6zzRiLACvZ5M
	kje7WsILl7XEWkTvynWjhEeJpwQFbVA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772625720; a=rsa-sha256;
	cv=none;
	b=AXa3UIo0RIL27QxHlYoUrtwcvt1puh0Gxm8GTDzc8fPUgLYqNYAEf5DjKT5T7EaFR2F9dP
	xmDzwVCPiHDXMP6dt24lrR/IOFdiB1akXeqI0rx5qM7j+27BiF8gNZakWXVU2a2m+qgHjj
	nZ4odfX+AFsieKI9hm6en4Q32GDAJOY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	npache@redhat.com,
	david@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	hannes@cmpxchg.org,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH] mm/migrate_device: fix folio refcount leak on folio_split_unmapped failure
Date: Wed,  4 Mar 2026 04:01:32 -0800
Message-ID: <20260304120132.3973445-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 93783C0002
X-Rspamd-Server: rspam08
X-Stat-Signature: wzng9yzoznt86moxh6fs6urf1r4nzycj
X-HE-Tag: 1772625720-301315
X-HE-Meta: U2FsdGVkX19OKVWtWzLqKgl4ULIhu6Uq0OECEyMjyqIvHQRc7r9xOBglu9MOy9eF7GFHyooz+uhnhUmLqdv77wxk4hEP2bdsEiFUqfee/lVR/FBzhsF934Pk8hiWUyEDQNS/vXomo/5PqhmEA4W/QbUcz2z/mz7lxsrb/lJdIRfIVqRnPtxdl6SPfKGg+FLeXCbxdBtMmX7HxcO27vPNq88qP2FWGGpV1fmvOIuXehiNZXqs7A3Zc6GakSY6adKe3Zbn/ex2ksxB4Q4Gm+fZEipom3aN+iVSo4Z+vqMM/ewXV6idnsY3NmQlHMnQTz9MO2OaG3fCr4+dn6jONa70TOP9Pgx7U17HFjlwGcbzudArE5zJfNeNUYhwBY9Fx8ZTD69+sEtxmauK3GOpjZ1yGnbxPcff+pweX2hltklnu2VNz58TI+91xHfLAKTzqQ/YZXYcqUOtYXeXI7a8w7Qw9JxTVKekkyyumElBPT1Y3Fn9EYYGzYYl5xMLDFCVJi4uJAB3KEQE2ui4CNBaHXELOhk/z0lPXJ9mBKO5+MxPOTdR2r5VASFkh3cGkre2q20mWVP7YGKc/JpronVS8Kq0S6rjlVCEUZ1W9B7D6zk9BHqhYUGyATSIN132wBcTEJnPNbVnKefJDXi4cxAlkgUMumKioh71eZDLxWAs4/QejsUoDeHO0gRwLPUs4wcOSCouTOuWvck1Irb3YcFXBBYSqMyFNfSOgqno16GooFGEjecGAskwhfG7fp86gP70O0JdIydT6/aodORjuCSwvo829q7WpiIJqsEaYDBSjHxhYhTnB36MW7cL9NjMOuORUnpxKYeW2H4MSmxyYWzWmmc8xsFrsHbh+LFq5ZpOpF4hYjuNIXK5/lgYw+HREdb+tHcbS9GQnh1sVP3guZS9ThUogUb9Ad0/owW0hKEo0o0HijvU4CvLdjp269PuVppr7ehaUJ+AJnjWe3nOlFY7HFv
 sSyACo8h
 xJ/XyYeA4x69FL7C1R3zck+RkVgfJ7uZFWo8NyFDUbZSu/niGyK2dhhdEIK9oITdD8za/Zwyo/smqEjaT9zhmjb5EzJSmG54xRZmpzakjuyOLLSLfKXkrudhuw5q7pSyL9qtGISCTWZFNVWcnm5n3nv5V1U9HoMfUrkHrtZBrqJGWtx34ydm2mzevqwEsqKB7pvS2g+9GVFf6anew4reARCwkObABUXB5yhUXvwkgxI4Rimp/VuGjRFLBMY1sAUaLlt4CKRsxErifcbrHXzgT1ZussyOs4foPOb/JOicNu6l+YH+YzNEguV+aldufxmUUCKbs6xOtQ83YfAWXtAGjW9ypE9CefuEzKRR002dHvccCSABWmjk2rZHkYgu+uwFoG3I/D4gakIKyQ4O6lF0/hVwTQYNslYDEvMWZ0DhacebYnEJEBdB8yK7lkXzctZhBodX9fjrqMcjuTy65RkfOvy/ky8vd97PpjidguIUWkRkDQ93Uye5O7smiLh5ekug0wuCF5dfJWleUicwMzJlbw60sO3kwnZg2rwA6BjMGoC0/TvOIr8tAxQ7lS6Tn3Z9yFNJYoZJBFSieiyGQvHsu7PGTLbPoRsxuJpiD4BeceMs/6UY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Usama Arif <usama.arif@linux.dev>

migrate_vma_split_unmapped_folio() takes an extra reference via
folio_get() before calling folio_split_unmapped().  On success, the
split consumes this reference: __folio_freeze_and_split_unmapped()
expects the +1 in its folio_ref_freeze() check, and distributes it
across the resulting sub-folios via folio_ref_unfreeze(...+1), which
are later balanced by folio_put() calls in __migrate_device_finalize().

If folio_split_unmapped() fails (e.g., unexpected pinning returns
-EAGAIN), the function returns without calling folio_put().  The extra
reference is never released.

Add the missing folio_put() on the error path.

Fixes: 4265d67e405a4 ("mm/migrate_device: add THP splitting during migration")
Closes: https://lore.kernel.org/all/CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com/
Reported-by: Nico Pache <npache@redhat.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/migrate_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 0a8b31939640f..351ecd9065d13 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -917,8 +917,10 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
 	folio_get(folio);
 	split_huge_pmd_address(migrate->vma, addr, true);
 	ret = folio_split_unmapped(folio, 0);
-	if (ret)
+	if (ret) {
+		folio_put(folio);
 		return ret;
+	}
 	migrate->src[idx] &= ~MIGRATE_PFN_COMPOUND;
 	flags = migrate->src[idx] & ((1UL << MIGRATE_PFN_SHIFT) - 1);
 	pfn = migrate->src[idx] >> MIGRATE_PFN_SHIFT;
-- 
2.47.3


