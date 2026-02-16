Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C353FE81A32
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 14:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EF06B0089; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327426B008A; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1151D6B0088; Mon, 16 Feb 2026 09:58:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E8AED6B0089
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 09:58:10 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4CBD5D4A6
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:58:10 +0000 (UTC)
X-FDA: 84450625140.10.E69EDAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E77A1C000E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 14:58:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bscfflmo;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771253888;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYIC/qIlONGZYtOPMXl3t7HkwCD9MiX2OTNWNoz8qm8=;
	b=06MWIVjtlQFpUVJxDwAMfDIkuCVBb5I0BGItGCKATbxoQhuDdMOgWX1jZGOgWsoGQnHbN8
	yZNbEfaChEl6ae9GFfUhUfNor9mubSUUSqL3r02CGx+oXNt7e4Fp4uOm4m/Q+toRp7bgMR
	TIay/G9MRM5GlinuhBCgJG6vanglYZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771253888; a=rsa-sha256;
	cv=none;
	b=xXAA3CyjgUl0wYZJToT2td67o84tR8ZvUn0yi5wCMaa9Vcd3sXMSjAdedbbCbBGUq2q16D
	XxVzBoOaSZJasp+LLoofcJ3E/XVCBgQPYQLLEZPibc/YlETjlG9ny+h/aZejjcszeS0/Zg
	qGgMrgpGWL+TgNwf/ruONxmGs230KVg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bscfflmo;
	spf=pass (imf21.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE9DE44495;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94F5AC19423;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771253887;
	bh=ijCT+Mg7d3790XUMIRWeaMLVEKai5+A/PxJRt61VFl4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=bscfflmoBukdJNZyPNYP0zJ95O8NpJxdXS5KVMOFS1tSazf4yN9d8BgInRxT1k7vj
	 0GU0hgjestKOZ7Xyx2RDNObFGJRZ3ZoUYhrdu9w1qZnkSLjGSYP2twTYsmWnDpmVtS
	 /+l9UrhxdXye2SNCyGrfJSmNDjyNzDUYZpMTMjwRADlr5+QkrmSN8J5ABJHvW3mmfD
	 d7d3kd/FHIadjDIITNDvIGmwnk17ZQ/jTQyLH4+jFvzsQbKCQMX46CkdechMzwS4nw
	 EWUwIpqBcfpWIHdDYLNll9Orj7AkyD+EqQfpQzT4tMOXmDs1klktA+ykYQKBZYex2y
	 00UGdyR9cLu6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 832D6E81A2F;
	Mon, 16 Feb 2026 14:58:07 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Mon, 16 Feb 2026 22:58:02 +0800
Subject: [PATCH v4 1/3] mm, swap: speed up hibernation allocation and
 writeout
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com>
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
In-Reply-To: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Carsten Grohmann <mail@carstengrohmann.de>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, Kairui Song <kasong@tencent.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771253885; l=2673;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=AP2Agry4RlYj89KzjPUleAMF+xnfApgEpjtkm4VqQJg=;
 b=bYE9CeOOUGzRx+yNxVfIU5aCtzWSmeScGretFXZJqot6KApMpREnHU1VqdZoQCKDTf2OtmG22
 hfw1sagCcsYBeIpg3RySdPKCrxkRVZmWNBmjGE/dx7rS7MzapMvhc7C
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 9E77A1C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: msfjyawnzfgbrhapjkomyqf7etdfkzti
X-HE-Tag: 1771253888-552964
X-HE-Meta: U2FsdGVkX19gStLyseRgUtzFDwNSlBiUL8UxUoGZBQIoUPD2UIAbWgjdR7VFXKiTD78VSbW1d9rP2gTK4HqMYlZCSGQw75aYpEN/l9YGTh+huwS/aUgAd35GP44Q/wahpaBkuYnzXRE+1bcfV6muAw/LaVoLYBFGtPsrFuTkArGrJKFQUgvii7zPFxZitnzk3M1QwD3lo2dfYgyxOcMVO1baepjxV8F56ZL2dwg6yP/gFsWHZIi9YU4DuCAXflAC9pnG87UFCgw9i57n3eMgOymCaW8eUC6cL0CJ4QGJwHajIEXjz0IzBpOEvgGcIp5Qnz/fLqSd6ptYA8xJ6NmMr30t4EyXrDV73PmPpdSAMlNVfi0mXeb+ZBb83fQHLKNq8nkPJRd3byRokhZaX/7U05ldEOeRaLS2+llXi3L3xkBCYDs2CBf5AOGAgdKbh6PXbnC2vrchQ9o4SAZBkXK7x0pcGJVKTT8Un+m9RJngefGZWUNfmdobe2wxG3eZnhrnogMeBtJLL4peAbt05CzQHkNYuOM1Dw3cMakDfJ31lfKOnF3Ng1UvXCKRuFTz+qS77ID2UWIEECEw+wG0D40UW6itbLrMolW4URPeerpD1qahkLro1MsRM0qXxuDmSAaErllmZVsiYWYla4FWkSpPOXghg8oclK5kRUnzNW7Uu5oOd+0EfVmXI21GnE/zkMfQNC852G5Nsh++2jZbe6MNSvm4gAACbcdtUZt2kfgAMz1Sgs/FGTdRRl8/q0QLMRn0z1jqz+ugdkVkUqUagIXANuwf/bZYdz/IVqKalOVrjNP/iFo8vtXbwEfCfQAXs9nIiZ2zyJDjLpIxnJFhO0Cl3NkGIsh7Kufw0kYldPR6FVeH3OsQfXPrjMjLyl5MxNDk7Y5rk99v9YCU8eYdGFd9t0cQAUSVJ66Yef9vOMXfGAH/W/F5NjxwtA9mAWJyZ84k4UUE2B/xtLO4ouHMEQY
 4B+Y/FAa
 XmYbq2k1PIJgXQEzX9GZtDVitG05BxHA4o5fxsQRu/ACIGIDMAn1zwKwa9I5kDMsKZFaQPtj8W+cnE9ohauMtfNkSqXtqVNYA/71NymS0HWgJ3gDudgkiAAz68xcRIya8lxBQBoUX5alDvaje6p/U+DeXW0NhuJEzx9usgRDmKvZt8dL0kAWVClax49LOM1E9upUNNzSbAPt/SQNl49zsTEtmZ4q9aNBUPCqMtSmRQlSLRxrCudCR3UOc129AMwoSLDOqSYxtOWdxbxHOSHh0Ju7hXHVaZfOMqsJwe48O+TBim1Ff6cCXyPXRV0VjMsSmIk/QfE4o4yyUKT9PQ0zIrBoK7eq117uD/7one4RXxYgJb1XBiIiWHIkV4wLmGRd0SbGEEC/eE2TIBWNX7J69GdVV09Uym6rLlb1lDYvWEtIkpRkZ6UEcm14HYBQDqCw2Djjb6WZWZj+pwy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
hibernation has been using the swap slot slow allocation path for
simplification, which turns out might cause regression for some
devices because the allocator now rotates clusters too often, leading to
slower allocation and more random distribution of data.

Fast allocation is not complex, so implement hibernation support as
well.

Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
performance is several times better [1]:
6.19:               324 seconds
After this series:  35 seconds

Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Reported-by: Carsten Grohmann <mail@carstengrohmann.de>
Closes: https://lore.kernel.org/linux-mm/20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org/
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
Cc: stable@vger.kernel.org
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c6863ff7152c..32e0e7545ab8 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
 /* Allocate a slot for hibernation */
 swp_entry_t swap_alloc_hibernation_slot(int type)
 {
-	struct swap_info_struct *si = swap_type_to_info(type);
-	unsigned long offset;
+	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
+	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
+	struct swap_cluster_info *ci;
 	swp_entry_t entry = {0};
 
 	if (!si)
@@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (get_swap_device_info(si)) {
 		if (si->flags & SWP_WRITEOK) {
 			/*
-			 * Grab the local lock to be compliant
-			 * with swap table allocation.
+			 * Try the local cluster first if it matches the device. If
+			 * not, try grab a new cluster and override local cluster.
 			 */
 			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, NULL);
+			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+			if (pcp_si == si && pcp_offset) {
+				ci = swap_cluster_lock(si, pcp_offset);
+				if (cluster_is_usable(ci, 0))
+					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+				else
+					swap_cluster_unlock(ci);
+			}
+			if (!offset)
+				offset = cluster_alloc_swap_entry(si, NULL);
 			local_unlock(&percpu_swap_cluster.lock);
 			if (offset)
 				entry = swp_entry(si->type, offset);

-- 
2.52.0



