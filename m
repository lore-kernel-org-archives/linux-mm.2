Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFE2C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E306B0092; Tue,  8 Sep 2026 06:24:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41EAD6B0096; Tue,  8 Sep 2026 06:24:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 335296B009D; Tue,  8 Sep 2026 06:24:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12F706B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:24:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1B0C1604A8
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:24:09 +0000 (UTC)
X-FDA: 85190209818.23.03F2303
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id CA432120009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:24:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788863046;
	b=aXbRocfv94uzP4yDFA6V4+o4dzNkR6/gtPatV5ReUY7KFp2BEnSNOqw67E52YNoM2gUVdH
	YAPhpjtYPhP1ovzbvXjtJoQDx3I9eO4d/085UMy3ZumTNdv6FHk+ixKeLTel58lpcZ/J5k
	odleu5vvWyXqF6b5fR1T70v04pEDrX8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788863046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=77cylPXzBEqGNd8sCNOrfJjdMK+jPvwH593jRiIGNxE=;
	b=tO/3yLfFdCwz7GwLwiDPV9MXLAaEiVRL3uOJR+G7UpxEIGWUovXDKTmcNHnFK6P3ABMK3d
	i9ILfFwuUB9O/lYXgEps2G76yhj8zEjEEJmPbYpXMezin07ft/+g7KSb9Q8GNiw+ZOVKef
	hgwx5G/lvD5ldLUeMQDF6Sbc8SaBcZc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
X-UUID: 68d60562ab6f11f19a56ed5b684f684d-20260908
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:092cf187-ca51-4ca9-98e4-ea0066458ffb,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:8fb3236ba92cc8e487a5ccb68986fc5e,BulkI
	D:nil,BulkQuantity:0,SF:81|82|102|850|865|898,TC:nil,Content:0|15|50|99,ED
	M:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:
	0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 68d60562ab6f11f19a56ed5b684f684d-20260908
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1347047867; Tue, 08 Sep 2026 18:24:01 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	gourry@gourry.net,
	Qiqi Liu <liuqiqi@kylinos.cn>
Subject: [PATCH v4] mm: page_alloc: add missing hooks to bulk allocation path
Date: Tue,  8 Sep 2026 18:23:56 +0800
Message-Id: <20260908102356.344075-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907120949.418450-1-liuqiqi@kylinos.cn>
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA432120009
X-Stat-Signature: fk6motscgq3a956i3i5xsxequ8k1cqyr
X-HE-Tag: 1788863045-559382
X-HE-Meta: U2FsdGVkX18b3Vuc8Tk1lbX6RPoeT+bQ5FNAKaEgv1dPxAyMVYcV6rhkCKmO1o5lPr+VaYtWsvNXBzMOVVmRA6T2o0wrjREla7ryFZeFr5PjX79Y08mHb6WbV2801blPjXhCJgLXNXYC17Gq5EmK/vD2aEe/IxFenveaQ89sQ0Nw4nuDTbWT3L8NMWGSJRAvKCsHtMui3dpnX8YZyRvvSh0GuJisQBLmmrZiL9grIi411TJJdT0C52n2y0dJPm8/VDgZReN4PcSESYRC0pB8mGZXPKgPeDMCV6mZIf/N9h17Q45+egkxHQjW3qdduvjvjB63i9XI+d84MstmbHSDymugZ20M33U/w93SX2eDwPfCLIch931kZtzG/G0uBX7jOq/XzWcuiBB3JS+0X29JMBmJMp3xbgKx7FArnjxdCSYmEU6I4RayRAcPaUJiGn0NJmWPmW+uNg4jJN/n7mz0aDD8Qb/yJanLIYqn+YwAlpeAYFaUQzvenqHNrk3SWgFtMc2i2SWYklhNw2sJQu1TtkjWtPBjSj5UEPfxzyFDzWr5MEzOM6P5TCNizgtemAL0d8+8qub18i1M5u5YH/A/5XGGswmk6VQGWDTVC6GuifsUuJEBOvPqf1yW8ku96V6jCejasGXqnXJD9rmrG8iSd33Ytpasqk4qU3oq/UV0u0Xlz9BN3dQT7mFyX464x1hvBIE/FArW+e08X+tA67TY2+UOwSVdyGZRQ2DVVpemKnXNJTHFLuVl2e95Mqom5V6x6Zi6+2TcU8Em9m8wtZEw4lVz40ui6kUeiS5QBNL1+0xINyHMgtivqMY8XJAicXzna6fG090+T+NZBZVffqZxj1+cddHNWz4cSdLimQQ+BfP0Gm2KyA3ozzQNap+yI9j/kuoQM8XAgpNS84tSsZxPkvXklEPuMJNCji3qWv3AooYyd3VohswCpixwPDdFl8EzjRbVPdworEDfMqx9cRd
 tFfOjrug
 wVQ92eLyTeaH6xKq//Nbs88t2cosvdu9xmDYT6OYjK25O89eEOw2o2NM5aRyYhTH8pQqGQV0642pRVijF+1YmzApAvMJw6kzMFcnud0rsVVOWqmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The bulk allocation path in alloc_pages_bulk_noprof() currently misses
trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.

Add both calls in the bulk loop to match the standard allocation path,
placing them before set_page_refcounted() for consistency. The gfp mask
passed to kmsan_alloc_page() is stripped of __GFP_RECLAIM because the
bulk loop runs under the PCP spinlock, and KMSAN's stack depot allocation
must not sleep.

Both are no-ops when their respective features are disabled, so there
is no overhead in production kernels.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..eac419eef697 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5279,6 +5279,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		nr_account++;
 
 		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
+		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
+		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);
 		set_page_refcounted(page);
 		page_array[nr_populated++] = page;
 	}
-- 
2.25.1


