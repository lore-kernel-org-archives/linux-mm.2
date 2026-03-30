Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E136CFF493A
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 04:00:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3946B0092; Mon, 30 Mar 2026 00:00:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B74796B0095; Mon, 30 Mar 2026 00:00:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89D06B0096; Mon, 30 Mar 2026 00:00:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99FFD6B0092
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 00:00:30 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62C28C2052
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:00:30 +0000 (UTC)
X-FDA: 84601377420.15.760A5AB
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB0912000D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 04:00:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B63llvN7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774843229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=meMlkXTCwOF7sg5hwX0vNCdO6jmrrFvH63kgG+o11/M=;
	b=bobLCUjekx1Tn3ZsdU/ag+t+SMmnvH5QqU7qeQrVFuZ+aWthnmtENsHVR7IKdxQ/HG/K13
	BTvjnGAyp8jtr5E1FF/UyA5aOWI4CM87kAlAEfhKmMzZbaubXXPjNxWKV6j70TRrZZd3HE
	hkx0laxPxWHp8c/rjMqH+C2dAfKQYp4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774843229; a=rsa-sha256;
	cv=none;
	b=CgNu4gbeMpvgw166zOWLSzkIu+dywwcztpsLKC/VSC2qohKimzjra1OXBiooS+sDqKITnC
	fH0tBROsgxqNiCWNvhhiriZSrHHynQ57olCshK0xw/KFUV8By8RTjyofGhxKvQf2aD3ko2
	WNZwdfWsvRlWPQ/7u4hiNfAKWwI/5F8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B63llvN7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774843224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=meMlkXTCwOF7sg5hwX0vNCdO6jmrrFvH63kgG+o11/M=;
	b=B63llvN706k3rBYnyAKSe3OYrH8O7TGPBf+CvSu9FBC7THDjR4HBa7kyWm5JUuvDpCpWnX
	tKAcpSLJ/odSDFiJ7/KSXUF7U/t7G5noyy8HIkHTLy7fOID42a/YitNIG4T0HDMZtt59FS
	vDQohd3tcuC5+MVo/cZhAiWUbp8VWAE=
From: Hao Li <hao.li@linux.dev>
To: david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	joshua.hahnjy@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during hotplug
Date: Mon, 30 Mar 2026 11:57:49 +0800
Message-ID: <20260330035941.518186-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AB0912000D
X-Stat-Signature: 9gr981k7awiz55x7cgzdazy47hpixm8b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774843228-514398
X-HE-Meta: U2FsdGVkX1+4GROk0Xk+Ih8bFxuLFYCT4FQjKqoYSBrdwmKFJ9fmghiX/muAtGS2uZXZ/UMxxEwVtGMETzuAoYf71kviHoIpGsE6577fUOQ6iTN/x0Zmj7AmuPBw4lHs7ZycfjgOfkIpB+m+XMb1bm1ywEmQa5ul/ij8YCf+8+s735qaSoS4PEACxOna3hzQv32g3xm1U/6O6n/Txbj6XBlGE0Rry98lnRneSec/AERBuRDqqC/Dkkh5AwKZBCWIJru27YnKJhmfGDElI9BxvGT5zzg+UMggdpv6qTGig9PvZ6ahElhHsMyBMHcayrkTWrv9mVo15Ek065qAggWg/T1TL/drBIR/MASmcDYYa/LdC7tDvB0fZWbXtnaP1ZPLnPbWxomfIjRWHanSL6V2y9UQYcxTgkaQouNBMslcFRLLiF4dp1pRr1pBT0CtiRLI4dvzug1NS+P8WljmsoXVOfFsd1X4HuD0TAFWfTBGKzRFjWuK5+b1xQpk/dn4dvQV7v9+jPt4o2c1KBUnJXzihC3zXwmgcZ9hdlH8PvfSVbQDsaf1RgD9RTdsIHq3q+lo17XAt5Qk90oqoDjV27qh7TH8wtKYFTX5E6ZVflj9eAYBUZoLNPLyLO5BuYAQ8COOnxid8ovpz5KKQ48qm+Kd98KNHob9GPiWFIXHWkW400/PcP2d+pxm5OTZ4amJqzAwcuD5g+RGLafVh8sgqMSOwg03ETIMjCX2iC3Gpa4/yXPSB0iEdeueK+lBhwNRyJdgfPeitjh4rDm4URdp31zbpaxS4N+NlR1yJnAIdVaF4o+sw9z0iHiH0na4iW1sQ7bCZpvECH/ufcbXosIfIhtqnhkloUgb8o0PReu5mU7oWKx8/9pxXcj4dt+6wqD1jdft9Mei8gn+CKDL/RO6lwfBg6xKqYkp4p/75bU6HwDi8Ti3dmZgluzLYc4KdPhRBUcm6VrQYAdvtOnH1GTWRRk
 MD5ByCsQ
 M62K2g9dAgwjePZtEjbMr08D7IskIYprorlDLEvBNGYIY6rQux/Eq9d/Cda0j+8BRUnTZ3lnJh3PQtNolb5yNuMFBORAaI2MosLPgPf36FOYS9VVtUYDmbg18Pap92lThtXPGVXo7LMCu283OJBd9rKUd5cTuDw0Q9lGuCwQdsAlZx47SIaM9VOjGO1+JEirVYv9GpVPU/LyQPq9tXIvvVRBRj7nB3LHrhHrUiMxjNe0hZxEpzxrtUf1grOQvZj2mLhbgc+7TaPegdEtm6CfruCrvES7m1aPb+ZbzgogIBZyPmCOqXD5T/VdC8t1pBM3+mcYv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_NORMAL_MEMORY is initialized from zone population at boot, but memory
hotplug currently only updates N_MEMORY. As a result, a node that gains
normal memory via hotplug can remain invisible to users iterating over
N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
incorrectly marked as such.

Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
offline_pages(). Set the bit when a node that currently lacks normal
memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
offlining removes the last present pages from zones <= ZONE_NORMAL.

This restores the intended semantics without bringing back the old
status_change_nid_normal notifier plumbing which was removed in
8d2882a8edb8.

Current users that benefit include list_lru, zswap, nfsd filecache,
hugetlb_cgroup, and has_normal_memory sysfs reporting.

Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
Signed-off-by: Hao Li <hao.li@linux.dev>
---
Changes: simplify the code. (Thanks Joshua and David)
---
 mm/memory_hotplug.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index bc805029da51..05a47953ef21 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1209,6 +1209,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 
 	if (node_arg.nid >= 0)
 		node_set_state(nid, N_MEMORY);
+	/*
+	 * Check whether we are adding normal memory to the node for the first
+	 * time.
+	 */
+	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
+		node_set_state(nid, N_NORMAL_MEMORY);
+
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
 
@@ -1908,6 +1915,8 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	unsigned long flags;
 	char *reason;
 	int ret;
+	unsigned long normal_pages = 0;
+	enum zone_type zt;
 
 	/*
 	 * {on,off}lining is constrained to full memory sections (or more
@@ -2055,6 +2064,17 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
+	/*
+	 * Check whether this operation removes the last normal memory from
+	 * the node. We do this before clearing N_MEMORY to avoid the possible
+	 * transient "!N_MEMORY && N_NORMAL_MEMORY" state.
+	 */
+	if (zone_idx(zone) <= ZONE_NORMAL) {
+		for (zt = 0; zt <= ZONE_NORMAL; zt++)
+			normal_pages += pgdat->node_zones[zt].present_pages;
+		if (!normal_pages)
+			node_clear_state(node, N_NORMAL_MEMORY);
+	}
 	/*
 	 * Make sure to mark the node as memory-less before rebuilding the zone
 	 * list. Otherwise this node would still appear in the fallback lists.
-- 
2.50.1


