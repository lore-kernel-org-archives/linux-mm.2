Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D43BC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7AA6B0093; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACEEB6B0095; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BCDE6B009B; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD826B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:44:26 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 89E3D1A0171
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:25 +0000 (UTC)
X-FDA: 85193738490.11.D77E503
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8B393120008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:44:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IXM1iDLR;
	spf=pass (imf29.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947063;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=izVd6XJRfw3UA7mX4BURDVhisUCbvaXK6ceaRlY27ps=;
	b=VOXYCg0u5Q9Cq/PKMSoVj1WYqO0fSgEhgyDfYXKH6C+X21udB0EgwDr1Squqbe0pB5AFCn
	Mz+h5it8Bdl7AkuJ3H/zubUDCgSotfC41PlxTF57CYZ7uwY1Zmel94CVY1HyJDv93xS39s
	jytVV+C0mKY5tHtTsMLLXT4yo79BfbA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IXM1iDLR;
	spf=pass (imf29.hostedemail.com: domain of devnull+linuszeng.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+linuszeng.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947063;
	b=bBDzQt/eqH9t0Gayd4tI1lE6MCo/ScZhCARBqUxziVF5Fh23V89YD65jrDvDoV7ESUDulH
	ADehApA1A6sbhbXlGLGHRyd0GpH0WRiHw9v12bcXbBrknjYJsjz2ZVUdOYVllQ5wNrXfQO
	aQrFn1YgtSExViRCb6lQdVOandga9Pc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D6E1A43CF8;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B63EBC2BD04;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788947062;
	bh=Ad5PxfNFH0KjUpTuLE+nETx4q7cGEdziN7xPAPqWwOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IXM1iDLR+2q7Qj4UZE1d1OdKRnk1SWc6Th/SW9s7EtMl9ukUkzwFJuXlchIh0ZG7V
	 kXMbB4b1c6/O/PP2klrteeuRTIuJqi2PoU0vgOhuvXMAyCemST3VLF0BvP5z9c6fVZ
	 y+4TMX5lsYxOPQiaNVERUL+X5SPpA0gat5nSgRwKCHry0y9mZ8ujjEc6eHMpkVHgfs
	 zACqQPA6A4gpxAlCKvKDS9dB/TaADmeL+QK6k9Y6aZYyHi7S1FqPaO9yGFT/phq03M
	 LW3lmhU0IHCcxGH6bpffE+uzcLe0vH9Ypl9fvpONY/EC+o6Ol3W1/sKLT9X0l1669x
	 pvSSIYNs+XIjA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF87C79FB9;
	Wed,  9 Sep 2026 09:44:22 +0000 (UTC)
From: linuszeng via B4 Relay <devnull+linuszeng.tencent.com@kernel.org>
Date: Wed, 09 Sep 2026 17:44:21 +0800
Subject: [PATCH v2 3/3] mm: page_counter: drop protection fields from
 struct page_counter
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-descriptive-name-v2-3-d7dd7c099049@tencent.com>
References: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
In-Reply-To: <20260909-descriptive-name-v2-0-d7dd7c099049@tencent.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
 Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Jingxiang Zeng <jingxiangzeng.cas@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linuszeng <linuszeng@tencent.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788947061; l=1664;
 i=linuszeng@tencent.com; s=20260909; h=from:subject:message-id;
 bh=Ty2hOT3RbwUGz3En7B5H9g1JCCLU1A+cfCkKn52iXOE=;
 b=DabIe6gyrzCaIlUMZ+sK5yF+k8V1AXEAlJEyfeNhNSOm4taa8h7olgRc3rZRs1NDNlh3wZvec
 6uuVi36nj8mDzWloXIy3VsJaBD8D3LXRVtrsGSlLIRQ9LQUXjqdvkPm
X-Developer-Key: i=linuszeng@tencent.com; a=ed25519;
 pk=6K54xRzYIRWqatrAPy86M4E0MsI92BVJBhXwz5NdC74=
X-Endpoint-Received: by B4 Relay for linuszeng@tencent.com/20260909 with
 auth_id=1017
X-Original-From: linuszeng <linuszeng@tencent.com>
Reply-To: linuszeng@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B393120008
X-Stat-Signature: 7fuft3peyiafc4w5nd9g6izxe6n96wka
X-Rspam-User: 
X-HE-Tag: 1788947063-899277
X-HE-Meta: U2FsdGVkX19pEbPyZY5AsWtInM2ukCs0m9qcCEss7eNWdAmQmRXosnRQWEHo79DLGzoDdXfyBI2QH/Wd8ZGlI0cJCq8VRyL0b0dGA1u/OpT1nTR/5PHpfLMjwmjEWv/gfnW+5L1L/pApR7dPo4loPC5foJG9k9MPIfY5IWGPNeNpwHNlOeC4cgK7fbi7YP/jwS7ixHUXndATk4TYLZQNS3+Q8seZr3M3ayfEwjlQC3mG9u9GEb0+nCpGYoKcA8kZ1rSuNwptti3CoeDF82SIQxKFwnBQwOwynOhIjIPqJ3i9PyedQZuwMnxtjQ//lod1RfzW0KmRvdW0ZKINcpHdEf+O7BtQjdqHgm7LQQ80PukvI33Pb66/4w3OnTFwpCeMCs3Ut+2Up55gj5mo4QZXcPgzTTAP8ZRl2IjbR1dsMjzt6PyTomabrZhEZ4cfj/h8X39/s2ILKMhsC8XvY9kfdGC4zD+LN0BuhnQxC/9ZguWBXrDVBMW+M8n6C7+wVy/yp5m2n2ZmiXrUzRoZjTWIZu5rYGyzUOU/82e6o+H0a2dk3ezQJwS9tPeg6tZtCfg3ja2y723nB4EP7bb24j0aeCp/UQ6z1Gt0pwdEJoowTvUE9lIhSPmndvLvEnj6Yrrq4uepsKgj1xMrZLMkO+20dl3sQzMGsk9JQ64A299WBeOsWxMrRAzdBlqglaH5WMgruQjPGzkjrkv+rvNAmT7cEM+X7u0FXa37FtJCHxveg5QGZwv44oRlIaDhPI+cllw/krAPOsEAblnRuIIiHEAc+kduSAe/j9QcGEYoxONHhJ//u/fw5jXhAiAJavptCraFPrur+JW3FNAeG+CsO0/ff4XyXoZmEqNYgg+MQglMFYJq3iunAupdJg2rkXTUDmTJsKDjho1R5V1IFrbzj2xFknoIwSZOiFRtZMR+eqVI28dgn9oyqdXE1zZC73cB1A1HqnGhTCBGkhMa+HrC/0/
 EeQXsYTC
 mnt/Cl/ULP+PVlEOF26GYuPN6k/3anmqRgiQqQTytW3ylBUh7Zt+04X3JMoKNv+E0YufDuEjdoJG5z7+6jvw335xc06NkukTkRZ6vJeol/vQHVPwg2I9jZ5W/V3dV/1btNuAn2CC9ym8M9iFsOc6N6a6Ih76lYliWxrm9A2Nbgm1IRgFpgsfHUZObbjjI3O8YRV4APSYYxxEjCZHRicFTVuBY+S78vSsqnsdzYPxNGLeoQOrRI3UId1FXMbMO+I6wowi51dZq3/Q4arV4ug8Wc3CLPfqDFIEiP2VD+eqJrcfszpz11Z0NtNDO53iFcfH78nFd1Ey325YBYo7WPXYxFR9GwadVS72eeO8/OijG4PBzPdJ6Y3+aGvjfS4I+DRhgvfCzZW2VUT4Cf6hMZBlXQw9dEMwY/LyZygkCFK6kPtpLiRwNC593VkuEPmITAi+BbS2xeiFoE4r8GQZ94YE4mj9XL6VRnhSV4OFIv0sp1CY1Omcxw8pKNDjMjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: linuszeng <linuszeng@tencent.com>

The protection state now lives in struct page_counter_protection, so
remove the emin/min_usage/children_min_usage, elow/low_usage/
children_low_usage, min, low and protection_support fields from struct
page_counter.

Also drop the now-orphaned _pad2_ padding and its comment: with the
protection fields gone it no longer separates the read-mostly fields
from anything, and the structure's cacheline alignment already pads the
tail out.

swap/memsw, kmem, tcpmem and hugetlb counters no longer carry this
unused state: on 64-bit the structure shrinks from three cache lines to
two, saving one cache line.
---
 include/linux/page_counter.h | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index b81f16702764..0007960ba5a4 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -43,27 +43,11 @@ struct page_counter {
 
 	CACHELINE_PADDING(_pad1_);
 
-	/* effective memory.min and memory.min usage tracking */
-	unsigned long emin;
-	atomic_long_t min_usage;
-	atomic_long_t children_min_usage;
-
-	/* effective memory.low and memory.low usage tracking */
-	unsigned long elow;
-	atomic_long_t low_usage;
-	atomic_long_t children_low_usage;
-
 	unsigned long watermark;
 	/* Latest cg2 reset watermark */
 	unsigned long local_watermark;
 
-	/* Keep all the read most fields in a separete cacheline. */
-	CACHELINE_PADDING(_pad2_);
-
-	bool protection_support;
 	bool track_failcnt;
-	unsigned long min;
-	unsigned long low;
 	unsigned long high;
 	unsigned long max;
 	struct page_counter *parent;

-- 
2.43.7



