Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA74C44501
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 20:46:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8486B00A5; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03086B00AB; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0AE36B00A6; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86DC66B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 16:46:20 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F03C68EAD8
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:19 +0000 (UTC)
X-FDA: 84963163278.05.6B8674A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0A0EF10000B
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hXge1C4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783457178;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCUuGsPnUS3qeypANpNvqTHymyt8TU56TI16CjSpX58=;
	b=hW6PjAvRihMOuVVP6fmNP9XErXG1jM4ughYVJil98SWktPNdw4qJ6oHAxpOej8yJwbEzh+
	E+oKhXamovL4lTebOJfdeqMUzRFC2nrGbAcqonvDkKep8LCP1k3d5RPRys+DRZ5H46SC3S
	TIJJMIZua8VFcp9fOT7qG8w8HTGOyVI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hXge1C4n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783457178;
	b=Q5r0DBGrsgieBCGZOrhQ3XBaOSZr/AzjDfselTd5yN9ZCJrtE913Ubz+UB/4MQ1j5K+Ek+
	EtFcrkLOmGJ3iSn7o8q2CqyT88Kw89zrGSnWDDra40mZGDbBMBbuw73/Vrqt+6yCq82GgL
	IvRFcckx4ZCGoZub0vxLLXnO9SfTfRM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 634C4601D9;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F0E5C2BCF6;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783457177;
	bh=3qSbeshutJQrqanyiBV5+kKek6b+adOK4DrRJA11o8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=hXge1C4nzY7dlpABVxo8H1hHfpEOcioGCds0whqNw7XUAqLLC+OyKLiiE89xBmpkr
	 eyvtt+Zfo8RXrxaADTvR8cswT8R09rMTJ5AfZoff2Z/eR3JFLy/HaXi4Onjxl6+Lmq
	 Fyyq7QJnIZz+5F/IDNzivbSYP6++jmCF+A+eReEVOcGusuZtbya/JgJ6NLVSzZZzey
	 ap3jSinQCDmgOBUHS8kAX77CG+GobdNhTzzn0ltGrUbqYHzXTgvb3/HUPYNeahQnHj
	 BZNQ48L5Om12You5Xji34f+kfTNukI3EQi1t7p0J4yYtLw5Ou3yemRPMe69F+Pp5iO
	 oRc7rMtwmUvAw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09746C44501;
	Tue,  7 Jul 2026 20:46:17 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 07 Jul 2026 13:46:08 -0700
Subject: [PATCH 1/4] mm: hugetlb: Fix subpool usage leak on allocation
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260707-hugetlb-alloc-failure-fixes-v1-1-5bbd3a4b836d@google.com>
References: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
In-Reply-To: <20260707-hugetlb-alloc-failure-fixes-v1-0-5bbd3a4b836d@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1783457176; l=2054;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=cA05z4q3cmpRjd2OhLZkp4otFIh88A72+UVO+VC1THA=;
 b=SPjMgY+qFAw75FTtWJ8Y+fwGaYQBAgZo0MU0E6d8mHmDzPWGEkAKa+/7oTZ0ZFgY6e1EP7FLK
 W4tZXsQrZSdBwM4aM0O+kIAwzsobl1+hO80X/KRmZ4v33M0ebtmoEIR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 0A0EF10000B
X-Stat-Signature: wjhxr3x8kb7ky55oxtagdmjadzsns7ct
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783457177-209484
X-HE-Meta: U2FsdGVkX1+G8CK2NIeg6pGxhsj+pSIHVx6xvyoZIMMjuDC+BBBQIN7yUgN/ZAYgZwfq3hgpa+8WhuSxrVEiCyJY1oJjr7/F784uynNGV1J067/i2noTnVMpLGlgwevsotWZRDhxzmDpzF8dWSE+Wv4w4MhDPMgr2NIgNEdClRFDvXUbphZd3PU3c2RF0pumUTNp+3io2iZI2WnjzZxUUYfeO8pyvzKx4DXhGXmMbJg5QouYGnThYobKyP14/CCztUbvMTqorSbmANnN06WiYtw+ia9DW5c76Lcu8tozfWtQ+AQ8U4+3Ub8PnFn8gcZ6/glYcYbd2gr3z5nvLZmvNLgRmuyWl87T82ppp004z5Wa9K355Ss+2lBinTBuYwesd/T1wOCEG5JKQdYp1Gjj406DYAgGc286+rs0THdl17hvVjW9oR8jpV9Fsr7M5JHS6emzA7sqpJLEJaWA6AKaErEzTQql8mVmOw/2JyFErdqo8A1rpDk+QpCa7Ep6WV4sf/K5dcHg9mfhc2fFOewg7E2FPcNHUhjBaf0frv7NzWpb/YZQWrBXxALELhouCMkO9/DwlvysSFSRmieaWUFg7jPjnrfkt7nvoD8uABOLhW8rcY1QfqvO/dpZutW3wMtrm4Tqit/Lb8RkmzxyDcwDPKWN6c+N3QYH7CLjoTQgRDr63sDrbipF9gwxIMAoF+RPwVehJfc3cI2kE2ge97bYXY3WpTz6ACZgrgRgpgRHL7yYuZ1bwEHr/civr5eEEcO/FhdI1jWfn2BTLjOy88/7QIyTIMp9twIKoVFsPIcNLesYK7X50GNBjBFfPDmyC+q8gv/ZJsrYogclfTK/yh39JLBcJvFXh2vlBtDPMOTy1HYTn9ftr6O1Swx6VKQrB9YS5K83mvrwGBzm3EogpnotDi3Yz8nURjr5r7wUUaiH9jb4ujCKms1L1Cz4/5tMHmcFocqNwi4ZmeajjyMkULA
 hKe0RdZ8
 tnLI50eSWV1Moy/PinnN6pFpHW5Gw6I5nUP9L1In0LRK9q/C46at0JhJfkhhyfM1GLljmzOyTnz+lCXdmIH8QnpGomnO9cApdtGflyW4gtdd+V1qdpuNm0NuZFW6UDoUZ+TVyKGTSE2zyUzi2wvaUDBBQN3xYlhyr1FkZXrSzapoojLy55qpnYc8MCSBA/AFoHnISsRoJwUU5FKeqmexQWdVPfgaZNj9ImA4LBAfWDiv3o8y9apBwC/MbcF0+Ne1XK2T+HaQAcUIw0s7DmXWFp7t3wEXwI2OGEdtOdzrRO2bBIvGts5Qk+q3LL/13MHr1WbQ5RDJsOkGv8kwZUOqcYvp8bN9+hab3rEaHUK7Ir7UWlqW3ADsppNCe6vcE80B1V30v5ajIcdS4NTXmmYxxcENOQKmZD/Ifedzi+7BfBFAhNA0+thR0aVPgHDyfaEmqf49YvX1th00H4vGS0YLmXIocKVdqtC0AmKMa46tB0ssqwAY=
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

Fix this by calling hugepage_subpool_put_pages() unconditionally if
map_chg is true. Only call hugetlb_acct_memory() to adjust global
reservations if !gbl_chg is true, to prevent underflowing the global
resv_huge_pages counter.

Fixes: a833a693a490e ("mm: hugetlb: fix incorrect fallback for subpool")
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 571212b80835e..e607dcbb2fc3e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2858,7 +2858,7 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
 	struct folio *folio;
-	long retval, gbl_chg, gbl_reserve;
+	long retval, gbl_chg;
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
@@ -3009,13 +3009,11 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
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



