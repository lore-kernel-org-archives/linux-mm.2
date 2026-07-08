Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A8BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 22:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF54F6B008C; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3D46B0099; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1AC6B0095; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A03D36B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:12:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 19B941C30C5
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:57 +0000 (UTC)
X-FDA: 84967010394.21.8E02D2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1BF0D40002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRFMA1DN;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783548775;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxsjENCBUxJkF7OcN2z6ysOPGHn8VKpudlNhMh9QYqU=;
	b=pXrKDG0fpfEgCLjjNReOXGmD99SxvvhFe94BzI9216Z538ckSNE1VjJuCC3K3j8hY28yc4
	7XPkzZgoKlbWjDflFT4lTWvQpojbKlL/yFfVlNYPFzmiPIRb16rOHemQNBYDMfjO2KNw0T
	P9HcbiJ5cNCfktflZD8xco6TnUfEo9k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QRFMA1DN;
	spf=pass (imf07.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783548775;
	b=PB6/4zjm/yZ65dMgBFemjdfF7CB5eROLxKhVDLq5N1fFkkJkjwUmSCA/dQ5fbttTBbcnwp
	k2DK22e2Rf2WYZqsZH6O10cWSYfX3aBxYjo313APUcYjfTmC1qtOg0iSrb78hiIp7C8hvM
	GYNVlLOCluebDwzeGWm/hsmyufD0oGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D7B043D02;
	Wed,  8 Jul 2026 22:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4FC0C2BCC9;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783548773;
	bh=nj+rgJC/HXTPwcNbSn5Q7M0LTgytd4Dk2hug7ZsqSBA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QRFMA1DNLbWwQuGfVPuCW6A9wUCNbUBUoFvK5oGQXBSytV7p6oT5evv18q+SbQjp1
	 tE7tg3Q6v0fTw7PxbklRx29qRMuXm58VVHbHi5ktkmUY0Qs9uNLIaJq1DNWOcGpV4n
	 J+lESTmLkWQh/n+z68eNJ8Ktxwb8vxcjjblI/4uKs5cEzo45eYiFGoQWzmioZY4vVq
	 4ZDEMY4Y0bme5UmQDfEG6v8iOFWE3zvoBYzGJqRneaMJ20JVkuxW3WKbTJMjqxlbxR
	 94gotWCbDbGA2MwveqPFAlshgtfkLH6+xYaT3tkHlSnqETT/8fCcT8Wu8qBe01sYpj
	 dQ0xgsHjUPPJg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6152C44506;
	Wed,  8 Jul 2026 22:12:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 08 Jul 2026 15:12:50 -0700
Subject: [PATCH v2 2/5] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-hugetlb-alloc-failure-fixes-v2-2-c7f27cbb462b@google.com>
References: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
In-Reply-To: <20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783548773; l=2183;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=8pgD6+H5WXDhqxeVR1T9DEMEA9n+rne9MvjgkpNJ/6Y=;
 b=tmNC77AlJSVebS5RY5iI4MPVusjxMx2IC/1THhUAM6VizHc2+2UAt3vcvxbqcvzVnISeBK1ur
 Nnldn6syc2gBrP7TLZEdPYvfD1LeleDU15RVNgSoiQOUF80MZtxysjz
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1BF0D40002
X-Stat-Signature: n8sx6mif1iriwsnqkx8n5koi1d5ot6w4
X-HE-Tag: 1783548774-654439
X-HE-Meta: U2FsdGVkX18WQ0Y7PAemRVJknhyB4EMfUtvX9d6M7aRVgjhXM+UPj3E1ZBmFLEHF3QXiQ8R4Pm78IgYt93mylI0s3aLXNhjamXW0qNLyRZeC7J5Z0uazOALr/LHv3rLcdPAr1KyC/yMVmKZpTIjs5J0UULhpOKhTiU/9uUSYa5wtHdWqdqOo9SEOt5sytU4e0cwIKWHLZ9fCdOSHwEBQcOKkjO2+IRVOk/Z6zn2Xy5uWEXB2SVK5UflQOTltEnJyMqGUhMf6Zkw8lvQWc4Rce5T4hgRpXA3J0c9xdlKvzaWX/lHJ2LCWM586sRuyVJV+zJz6ATqzSIRd416wfEstzHsN2yzZmDlbcw8QunmqYQYKOAkNcR8VPsyrXV1EyfRy3LxYxHpvuaFWwJ+Ny4G/CgxLVcIjyeWKkVm7MVDNgWYjQF389/K5KBHG47B2nP89SFNL9bmTFnkOohuubFYbPUS12WC5VBDjYXR48xdMeU1RRcGF21RpE319kcm8YXlIQf5lLMRsv6Q18GR0X8ND1V6mWIDbIZ4NwNTe9KW73AfDF1qkMey2vOnimzpYHqtUJQI5I3BnFRBrQD/fjuaEglA9Y1QDzrmDTy3sYkj77+aeZO0iiUghWcuCznTwOuUNRk59PfrKqShSu8nb09zHJ84Fj+LgjIgDQAymzPTFqPjKbaHPsaq7T5GMOTu4fyFl288qncTH33FVXGE6khaKucA8h7ebHE1uZdM3V4e/JL3XyUKEyJAUy11fvFQ7wdzaUxBH97K6bNj5zAInaKjycWtlTxcVk4PZdzqUD56h6tjuDXmMPiQoOp8WfFsbrinV9WjhH+qsMQhBpsGtO+bwX1cJ3HatPI5AcHsrKCCtZPGCf740l83o9idg1Gitbvd9/xWvXhgWAmsTUqzhzM2UYN4jx6N7/qoMbn8W6LPhWn2ZcaGIrMhIa0RoqkhpHG2pgGjh06sCcG28f32iKW9
 R+B2r6IR
 Q3qPajtO0iT8LbgKoXfLjYtzsFdQZUlHDxTFXAHd5IrpDjC/uRrboKnO/w8peQjgK+rzOk6Bz6ZMelQuvJ00hCgO2LYUxY+q5MZ9YLx/+4Nbw3PyrZBviBk/pxHY5y9q3Rv7F72DbwKCwFJP3tiR523HLQ1kDCq9B1hFlYQtbv6YXYeypC8ujFQmtduULqNpjB7YQwbQOKcUfHjBHCn4YS46o9FmLEf59pF3OjUMzbZOsNvHkkqCxAy6syEBV9u9BGPilat52fZNF3kL5UAbyw/RQk5/UjCwPWcCVwQHs27OWZxIv1uL3WhwY+kYG6A/zYGLSCKQcdf4qOOS5OGDHkBb2ZotQ17/dKOuvmE8rvZaQZNNUG1tYvsZ2bvk+5+krnp4B44uqXjiw5ZxT+NZBPM4oobfgfIsDsr6Ah9vqzj96S9OiT6v+HHufHi+hH038eWbrJCps/KS3xYIzlU8XdrdZxUOePzO05Ugr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When alloc_hugetlb_folio() fails early (e.g. buddy allocation failure or
hugetlb cgroup charging failure) and gbl_chg == 1 (meaning a reservation
was not used, but a global page was allocated instead), the subpool page
acquired via hugepage_subpool_get_pages() must still be returned.

Currently, the error path out_subpool_put: only calls
hugepage_subpool_put_pages() if !gbl_chg is true. If gbl_chg is 1, it
skips it, permanently leaking the subpool's used_hpages counter.

With the earlier patch to always track used_hpages in the subpool, always
call hugepage_subpool_put_pages() if map_chg is true to consistently
restore the page to the subpool. Only call hugetlb_acct_memory() to adjust
global reservations if gbl_chg == 0 since gbl_chg == 0 indicates a
subpool (and global) reservation was used.

Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ee5e99c1894b9..4093c1c0a4a1d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2852,7 +2852,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_chg;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -3003,13 +3003,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 		hugetlb_cgroup_uncharge_cgroup_rsvd(idx, pages_per_huge_page(h),
 						    h_cg_rsvd);
 out_subpool_put:
-	/*
-	 * put page to subpool iff the quota of subpool's rsv_hpages is used
-	 * during hugepage_subpool_get_pages.
-	 */
-	if (map_chg && !gbl_chg) {
-		gbl_reserve = hugepage_subpool_put_pages(spool, 1);
-		hugetlb_acct_memory(h, -gbl_reserve);
+	if (map_chg) {
+		long gbl_reserve = hugepage_subpool_put_pages(spool, 1);
+
+		if (!gbl_chg)
+			hugetlb_acct_memory(h, -gbl_reserve);
 	}
 
 

-- 
2.55.0.795.g602f6c329a-goog



