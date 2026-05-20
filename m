Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6035CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:02:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6054A6B00C3; Wed, 20 May 2026 11:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2EF6B00C7; Wed, 20 May 2026 11:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392CF6B00C3; Wed, 20 May 2026 11:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 189A46B00C3
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:01:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D444440357
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:07 +0000 (UTC)
X-FDA: 84788110974.14.E578150
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2E3E580007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:01:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kHajg5X9;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779289266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZOK6h58T4z/LIHuXmRraHuYbG6z8gXR7nqP+GNo268=;
	b=UfFzfog+w1rbBrNi8g/KnvB/vlvmHYmhtggVbmc7GolScLVe25F//bSd5Fdi6CwgPbcAbO
	5hr/W9x0xl6ir3ahh9TBIJI+5cHlffIwP6DM2tHlwWbgSH01mYwqUxyS4l6XWacbx1ZZfW
	8Fz3WgyEnDwCOfQ2Dm3EZhwdm+ehN6c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=kHajg5X9;
	spf=pass (imf02.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779289266; a=rsa-sha256;
	cv=none;
	b=TyB+3KPNz1pO1uOStolLmEa/5hmXvBEGVzfy0iG6+w4o60XSaMJLpV5JMkxBnMPPO3TY62
	CI6pdXZEB2jxbrI2eZoWWCzRcVRdHt7O4ciEyPE5qj/dLw6XVlxwHKjKxe5Ca3HQXN8o8r
	x8ijhXFcl/k6KCB5luO39Ri9E/WKzWI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=FZOK6h58T4z/LIHuXmRraHuYbG6z8gXR7nqP+GNo268=; b=kHajg5X985RLx3rxaGTf2XVaPD
	76I6dDk8PrQizDgUV5HI5hcX6tMKj+GUooPY4X9BlzFgqWoOBVH9wQkwOE+GEURlEpuAKcMZuNQT0
	3ol0VVNAQ5mE6mrRBtMZIZf3OSC5s3XkC1G71FZ3UJtA3ddgaUZoDPpprIhgEQ2hQrqsgCymNkgm1
	Rb2h2uUV/2Z+9HRitqLvbZenecb/l882JfBGvJAMUpm0w3KHmHecmAfbzEa0FJaLG+a0PDY+2P2KX
	EZugxcfEcj4TsLMovFNVl3yMfvgp00aPGfJG82UXJi7kegZkuopGtUujezDGg4p6hHcFbJp2w7dtR
	nGA7mB4w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wPiPM-0000000024Q-3h1w;
	Wed, 20 May 2026 11:00:28 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-team@meta.com,
	linux-mm@kvack.org,
	david@kernel.org,
	willy@infradead.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	usama.arif@linux.dev,
	fvdl@google.com,
	Rik van Riel <riel@surriel.com>
Subject: [RFC PATCH 30/40] mm: show_mem: collect migratetype letters from per-superpageblock lists
Date: Wed, 20 May 2026 10:59:36 -0400
Message-ID: <20260520150018.2491267-31-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520150018.2491267-1-riel@surriel.com>
References: <20260520150018.2491267-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zbaggbkf7crwbncqiyhujoqtsaem4tq3
X-Rspamd-Queue-Id: 2E3E580007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779289265-917344
X-HE-Meta: U2FsdGVkX1/yBlY1mTiOGWuyzV5EhR3VNPFD7v0iZvJcAbzId0L4xp3Xr7KNYbRKwNO0W3WQqBgRno9iztfcrlbajvV2ignqKiKlKuCU03NdvA0L+KT5aAoCPlNPSVhh1WZvKEydXjr5kf3LLSeRqUW6Tawm+5pQgm5TwVJqLiXKg9dih6FR5rIrA5zOSLWOLBpNiXRFtBssCl8dgYfvblGjZdHoe7i0Bpg5si5/n3+2A5r+JsJqCvx5NZDd4s6gfLpfvTxngPSD5bMokFZDUB7gYHIEzYwZPwvZms8g3cOPtM80B4Qf5SwNU7aSgai29L1waJjhLtfR+hiF0dZeNQJl/6bcgQmVSs8C9RAcBx4aLQONFvIHRgpWwRTiU8munmRTIKLCI3eixtXW5wrI0b7lUNKo8rCNGmAfaRWtBat5JLnaenMRiSIN97MWTmF7BVHgnGXmYbCtzXmvho5CxdtAPpYHF9o8ofPMehEe9N7W0IPe4ndMqynSIpN5fK8HfvKB/WkSTWlRDKbVeQe7Gz62Rcc/8qPrborrzUZZD5EMc6NPrb8nqX2jy6q98meHHZvzMGPBZ/fwkhJ4eE6eitNoYSEd39LDFqj9e4WWVI14YXGtYb3Jk/Z7dxk80FPmwtokAMQxcu+DQrTR4xPjYUugYw+dp9JUskLG5DvzrdMUwYrUir73xfuF9MtGJ5sTZ8LF9CnWECgupd0/tgC9/hEsceR7TfUJP3RFlPoOiskTS45BkS36dgOWq/F96ncNpnN5M5AX7irA+fXGOu246VMIW8IDAbk8YlPq2bkZ9mu62PyL0C1sRE5ypwN2AvgOEeQcwNFNt+3Bl5/qBkK6P4UaZpPOmfFnAMgkja0BsdnvoODm4osVgV/pIxnDndPd/DSEjTqBe4ixtfWUVSmWiUns2oVfF70IVg7w77H0nNRdgo5ppdcH3eGl0GFB5xdIAu/Pc7v/xwq9Ai68Vk/
 G1ZlIPNP
 mNqaJWa8NFb5ibH/lZ/k89vQM8cgQJ7aWJE68kR8UKYQ8F6yohXYQR5inmMlhOx6xxWF8q53qtfGpHrxk8lXHwj6NiL28vG1lBIVhkRL4WBkp30Uinw8Rehlg3gsG3CnPWsZg575g4snY5DFWMUahIDz8ypPtIF+XhbwJ9U0PWQdGVfjpX3lpuJ1VE4ri5WAAeqAfs1LqeJsLFfpmFqsuiB+GWDO37iOav1hDp7wRHhlRK3IMiaio3j41KR8LtNba8BLESPQMFV1iAeOPzEB49u50fGlvHc+Ks6dxbMWCjgaaGghcpv/iwTlWevQKtLCMdivcgh3dSt3v74Zw4L6cjTn2w9Z16bW5F6qJ3mFuZzfjcMc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

show_mem()'s per-order line includes a parenthesized set of letters
(UME, etc.) indicating which migratetypes have free pages at that
order. This was computed by checking free_area_empty() on
zone->free_area[order].free_list[type]. After the SPB rework, those
zone-level list heads are always empty -- free pages live on per-
superpageblock lists -- so the migratetype letters never appeared.

Iterate every SPB in the zone for each order, OR'ing in any non-empty
migratetype lists, with an early exit once all migratetypes have been
seen. The shadow nr_free count remains correct (zone->free_area[].
nr_free is updated by __add_to_free_list / __del_page_from_free_list
to sum across all SPBs).

Falls back to the zone-level free_area for zones whose SPB array has
not yet been allocated.

The whole loop runs under spin_lock_irqsave(&zone->lock) without
drops, so no hotplug race. Worst case work is bounded
(NR_PAGE_ORDERS * MIGRATE_TYPES * nr_superpageblocks list_empty
pointer compares per zone) and acceptable for a diagnostic path.

Signed-off-by: Rik van Riel <riel@surriel.com>
Assisted-by: Claude:claude-opus-4.7 syzkaller
---
 mm/show_mem.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index d08f1263480a..ce7f43416199 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -367,16 +367,31 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 
 		spin_lock_irqsave(&zone->lock, flags);
 		for (order = 0; order < NR_PAGE_ORDERS; order++) {
-			struct free_area *area = &zone->free_area[order];
+			unsigned long sb_idx;
+			unsigned long nr_lists = zone->nr_superpageblocks ? : 1;
 			int type;
 
-			nr[order] = area->nr_free;
+			nr[order] = zone->free_area[order].nr_free;
 			total += nr[order] << order;
 
+			/*
+			 * Collect the migratetypes present at this order. After
+			 * the SPB rework, free pages live on per-superpageblock
+			 * free lists, so check each SPB. Stop early once all
+			 * migratetypes have been observed.
+			 */
 			types[order] = 0;
-			for (type = 0; type < MIGRATE_TYPES; type++) {
-				if (!free_area_empty(area, type))
-					types[order] |= 1 << type;
+			for (sb_idx = 0; sb_idx < nr_lists; sb_idx++) {
+				struct free_area *area = zone->nr_superpageblocks ?
+					&zone->superpageblocks[sb_idx].free_area[order] :
+					&zone->free_area[order];
+
+				for (type = 0; type < MIGRATE_TYPES; type++) {
+					if (!free_area_empty(area, type))
+						types[order] |= 1 << type;
+				}
+				if (types[order] == (1 << MIGRATE_TYPES) - 1)
+					break;
 			}
 		}
 		spin_unlock_irqrestore(&zone->lock, flags);
-- 
2.54.0


