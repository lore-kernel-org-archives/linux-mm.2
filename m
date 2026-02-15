Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64617EF5871
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 11:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D41C6B0005; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A29D6B008A; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D4A46B008C; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59CAC6B0005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 06:15:12 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9A541A0ADB
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:15:11 +0000 (UTC)
X-FDA: 84446434422.18.36BEBA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id ECC3D1C000F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 11:15:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UsCTYJ6u;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771154110;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/M3dLU432KSJtmbJUDNPBKs2wXVXl4zfvnvXClrUIaU=;
	b=dQUXFqU1brehwYMwY3cdM+mwDrTksUEvYdwty7x/v7KxABPhGPGmTwkUiEBcJViGz1xwpa
	eRcok+ADdiUAkWfHHiut19+PCmvXxv2dx6AJ76dtu/3j7+hh/xohP69tI1nu6Z29ujGjoo
	YWtViwFDIXjFWAgwYcPbfx67PecSvjo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UsCTYJ6u;
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771154110; a=rsa-sha256;
	cv=none;
	b=v2czw6r2t1RHiY4vlDAG2N/I8Ubw02WPtBI5syT4gicfxGZ7B3tp0fPpa+kAJFbUtMH8Gu
	jJiU/e39eS7BareCAPkpECRxpQZk7Js655szw/6Gq8wTTeLxOhLXwbnsjumhXK0ZKt9v/1
	BoZFIL2bZW9RzlXgdgL/L9OhF8aXuwk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EC56540A4E;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C33BEC19424;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771154108;
	bh=rj046hNjbOH1lmWPWDKklrmTWcUTpwf0i1/a8aP/h7w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UsCTYJ6uiT1fnusVLr6iO9cPe+D5snPjE0r3u+CMbfB3SB5E2hJlFaINxDxR3g1WN
	 EqBM0CBysyUKaKVLx34jRqzLI6X6DwT2fOVDBKOLlHG6MtKEbOPonGUjpZ1Df5g0/x
	 36c5xBVTdpkebF74/qR7PfKM4ccO895jWdO9Zv+c9iTbLC6W35XYAlqcF8W5C6aykk
	 WBHpZdSOL8oYVQ9RT9WdhrI+VUNT+PNDiuKZ23CrUVyaTmB11xr3fnZv2RI3Z//0Ls
	 srnfD3ztBxmDMtRXUqpxChGaHQ9PgHZORZZYX+/tKNY4j4ymh6rP9LLyF/qShpN7h8
	 6HLyxutdqj9Eg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4867EF5871;
	Sun, 15 Feb 2026 11:15:08 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 15 Feb 2026 19:15:05 +0800
Subject: [PATCH v2 1/2] mm, swap: speed up hibernation allocation and
 writeout
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260215-hibernate-perf-v2-1-cf28c75b04b7@tencent.com>
References: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
In-Reply-To: <20260215-hibernate-perf-v2-0-cf28c75b04b7@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Carsten Grohmann <carstengrohmann@gmx.de>, linux-kernel@vger.kernel.org, 
 "open list:SUSPEND TO RAM" <linux-pm@vger.kernel.org>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1771154107; l=3113;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=Lqqj4GocBbtPo/Q6I8AjVH970KtvanM4t/1TnJHKDrM=;
 b=EpCLE5H04BAylOQNWpLPoxj5u9nPLrq+LbMZinNLU/K4CSdq71oYjaopYXop6gF6S5NpGJfgR
 SO8ww0w0vYPCYtlq+EW3xm4tdB3STO2C2Cq9S51M63A+gsKjL5fm8qY
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ECC3D1C000F
X-Stat-Signature: h8f8dxkssiyqgbw193szgwckfpr6sb3z
X-Rspam-User: 
X-HE-Tag: 1771154109-800248
X-HE-Meta: U2FsdGVkX18NJvt0bBELjVmRzzOsFVVLpF++wtR6+clRrO50FvqJV+DpcQV4EHPycX5R/mL9zz9ZCfWTg8nrGeASpEva24FzVAjvWc20bk+RDjBgQ4xQvOLd2qNKS+9MFEYfG6xSqY+f++jQdvmWUPXW0B5rfBXZ12+lq1xR+cqqE8UU8udClDpFyMXwt5/vVDKt2bczQRe+N//f1Yivt9emGhnqwZr3zvnVCZuS/caUafPKHYW8+3MzrS6UMgknP1qSe+EFpApDBK/GV4BZ6xYn6/xPP8rGG/YGPvjXk5uP9UMy0Tu4Mi3YySQmTg20R10J+ntRqdCIvvi3tOFVUXk1i/PYPny4EdBiwjqQvWn8ygoBlr0A48KNnYyl4WkowraEB6KH8VFqwgykj0QLosHXd4LAHT++5+nnC2oNlBarjhQlgWsk4DB7qo0X0LrrDXdz0QU0Ep+twz8Tdd+rnfPEV6fpwYwKBwE6fDvck/Yj+jjP2js25Tt1ZV+aTrkPHUY0WNCtm/D1c4hA+f9uBedvOoQeaT2TvcMcIgGa/fC/JciiTlDwSuUaMi8X7atPhGbyefmijS8hK/Dzeva/AF+MABTDanmWgRUDDtvv0/ZQMdozqdKVasGxmPkXarqkmCn6AYtT/mkK4HXXakGJTyE1wCqji0GNc1eUqZcyuPpdnflxLi0HONsUJ9K5oMZVboijGSyhhonm7s/Nl1SR+385kZR3JUnFffkI39txcmZ0rwA/rwkbeqHxR0DEeSvZaS2AowC9cCeicKFNasyveVHZDK5u9GBzpwL2XLNbY4s2GOCi4dA11AxA9tV+IZ+iPH9d8vjynD6NyMpNWCVFexldKyteeAw1J8HB3VbBg9wJmOZSiIH/owO5XSBIG4h8nypVJw9ZNiDEg2WHVbEk8yRJ+fHBEkxjsiosWpRtozSzYcFzT8efGNj0c8XOJmSlvFfY7GX2mM6lMna3oBw
 nh9bZVKH
 3QmqNGkK9EZNleorbsAhqJe2aJWvRvH1OB5/wLyI2rgSnMP7tOs6ch4LYNLIFi8VcG7DkCC12jyEWBZY5EVaEaD2/dJCoyLlLN7GbPCqKOWqvRN9GE24q1WYX85w8Fkqk0A5Jn+mLI9R+4MXqpG1vh+uGCUer6Js12YL4ozvSsiqQVfOOLUella0SSr7HBSV9MpRRnyb9002exoqTcesEny7KG8aiV7+eNVQhOW+kajJjf4kZD4MRYJ60WMCQnQAkw1EiF/29J7oywbW/IfugwozjkRwZdgBe1VJ+vcp0t9Qvy+Yo2tRgefQWbGbhfRIw4F1sDmW6/IUW6gWfVakZz7iM5eNQRI2dlfIXdvfrC/MnEc58UbdK4W8+dFxDLv0b+WlKYpHMGlvq99JLdWyTIOGrH6RvNOHfsQ2FSeFP78TcRArmu9sNSuBa3Pao6pYKtnhuj0ukWNDI8WU=
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

And reduce the indent of the code too, while at it. It doesn't have to
check the device flag, as the allocator will also check the device flag
and refuse to allocate if the device is not writable.

Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
performance is several times better [1]:
6.19:               324 seconds
After this series:  35 seconds

Fixes: 0ff67f990bd4 ("mm, swap: remove swap slot cache")
Reported-by: Carsten Grohmann <carstengrohmann@gmx.de>
Closes: https://lore.kernel.org/linux-mm/20260206121151.dea3633d1f0ded7bbf49c22e@linux-foundation.org/
Link: https://lore.kernel.org/linux-mm/8b4bdcfa-ce3f-4e23-839f-31367df7c18f@gmx.de/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c6863ff7152c..bcac10d96fb5 100644
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
@@ -1935,17 +1936,26 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 
 	/* This is called for allocating swap entry, not cache */
 	if (get_swap_device_info(si)) {
-		if (si->flags & SWP_WRITEOK) {
-			/*
-			 * Grab the local lock to be compliant
-			 * with swap table allocation.
-			 */
-			local_lock(&percpu_swap_cluster.lock);
-			offset = cluster_alloc_swap_entry(si, NULL);
-			local_unlock(&percpu_swap_cluster.lock);
-			if (offset)
-				entry = swp_entry(si->type, offset);
+		/*
+		 * Try the local cluster first if it matches the device. If
+		 * not, try grab a new cluster and override local cluster.
+		 */
+		local_lock(&percpu_swap_cluster.lock);
+		pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
+		pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
+		if (pcp_si == si && pcp_offset) {
+			ci = swap_cluster_lock(si, pcp_offset);
+			if (cluster_is_usable(ci, 0))
+				offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			else
+				swap_cluster_unlock(ci);
 		}
+		if (!offset)
+			offset = cluster_alloc_swap_entry(si, NULL);
+		if (offset)
+			entry = swp_entry(si->type, offset);
+		local_unlock(&percpu_swap_cluster.lock);
+
 		put_swap_device(si);
 	}
 fail:

-- 
2.52.0



