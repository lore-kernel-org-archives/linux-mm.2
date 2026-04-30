Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 739ECFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2ABA6B008C; Thu, 30 Apr 2026 04:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C024B6B0092; Thu, 30 Apr 2026 04:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3EFD6B0093; Thu, 30 Apr 2026 04:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2CBF6B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:35:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79F94A0538
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:35:25 +0000 (UTC)
X-FDA: 84714563010.07.6B20168
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id EAEDB1C0008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:35:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777538123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=IHiclRZm1ZfGz3Gr9t7VNkAT/aM3fuiYhk3yiOQMfAM=;
	b=69kZWSY+0UF3DaukHYmo8gLuINDX7eUb2TPUbc/KQOg8Hp99QXlrVidX6wHLAi00a61XHz
	lyNK0bXca6Ghfjt2NnG7qEFGUs0iNN4vaLVXTCMCZNJ8i6nSACwZBWC3b5/c5XE93qUqx2
	lr1tYdpW1cI/ips6B2sC/AQhEe/P9bU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777538123; a=rsa-sha256;
	cv=none;
	b=QafCGb4MolzdK2je5S18wL77LT78C367ZIebtg7jFOAb+HgLBhmk+xHB65ItXdcaSIxfuW
	nrsG65WiGlSippTawTEsRmvYlogWiKTH6HKp0Dqm9ROK7lC9GG6dlmfVsAzPQtBG4EG7T2
	2aFDM71c6oSa+99rKgRKLBBuDtdAUtI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g5nYM2m0Fz4yjjF;
	Thu, 30 Apr 2026 16:35:19 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 63U8Z2cF025062;
	Thu, 30 Apr 2026 16:35:02 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 30 Apr 2026 16:35:04 +0800 (CST)
X-Zmail-TransId: 2afc69f314389d2-eac03
X-Mailer: Zmail v1.0
Message-ID: <20260430163504368ZueB-81tYNin-vhramBnm@zte.com.cn>
Date: Thu, 30 Apr 2026 16:35:04 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <yang.tao172@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIXSBtbS9zbHViOiBpbml0aWFsaXplIGFsbG9jYXRlZCBvYmplY3QncyBmcmVlcG9pbnRlciBiZWZvcmUgZGVidWcgY2hlY2s=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 63U8Z2cF025062
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Thu, 30 Apr 2026 16:35:19 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F31447.000/4g5nYM2m0Fz4yjjF
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EAEDB1C0008
X-Stat-Signature: acnxx9rhrsxpztc8efiobhumfeb7pefc
X-Rspam-User: 
X-HE-Tag: 1777538122-873974
X-HE-Meta: U2FsdGVkX19B8Jp1TN/YOscConfY5yNANmuIyw3gt8t7j2Gk7rujppQPIMongorIhXkYxPQ3SeIBdYJ/1Eie19XqwXXV0PIbfrkqe82XdjUWB0PSIeRMebKedZlhQCju6vb2aE/Khl9tsFGH+FBQ+2sJTZNgZKH9YozRupGDZU/HhT4xoHwTmSw13DRmt0T0Y3VW8MoOCARvKTlyahWuaD2NiwZ5yXdi8h9dvzQpalydXZRBaEthipYG+xB2bc7XwWnLgFf/gJAVig2zmLBZrXz3rSTYnpQiiv5VwmUuMciQgccH4buXFNJqbK63VLQQpfVx4mWkcwzZqh1oR+gGw5BvbsUJ7nfm2IVmQuf56BZBGndQsdYFXIHSXWBnyaTB5nXzrN0dZuBOBjNklpnKJarkWZB7rA21mcu4LgMH4WnDXDemZZnXwPFXeU8y5zJAu5NieKrSPQ1GXhJ7XyQrZ8oeivTndFpD0ZB4mULDsHW0g1yqHeZEmPsOg+ceRcwBzFGt7zTW0BDeV1LVvYYGpxUfgdjv8SklaXAm2bntg+iJbjba2BjxwWejZNVy0p0XZ0IVptDa/q3J2UEmpau6LdeYGhGgUFS8eQiJdXk14MJikLH/0Qsv30LV+wZfT+/Z4xmz2Hv4d3LoofmXrnHsJzrQ4MmbkRkVu7jlgHLWXgLnGCCAxDOeeKNoZXP3libm9CH1o7IcBFJ1DWC1UWeen08rZ+79Mm9DHDuG6RIZIuEL+N883wJBsllDcs0wGy8LA+naXxcBSc7Z4x+3m7PX1DXn88YtaxJGbdU89QwDWeGayMKtfsKQeQl/TS1T9FQtyzHU9puOS5DBazo2AdD9iqbn5BtZK8jUtciggEJlrld+scsVwir0CXteePf90WqOYAUZJRZ5aP/K/0U3jzBdlf2Ok7GzQw0jbNMMe84MzLbfw0xH4P8kNbm/slqU1N85pCBVJW05TuSk6W8Cwlu
 nH3zPPXV
 8kZoUaJOgO6DWlDvhNo6HDyZF5OxVqMVqdmmuoyj15KbIIH2uvlLpiEKttlAEtIDDUgIivInoh1qQgy/oaVPaWOEyjcbmJis9WLzlGqJY+gRGMBNukqUDNxe+/tSAepY94W1bH5R19n4tT6QFGly726kevO914wKReMDdqhGwQxynS7h5qoh/J84cjcd1jv+G3Qi2qh/CHJL27XriyVkqVHak/wHxxvodmmcenR/ZDtberXRvK0QvaAPWqSHhUgGmH+dGCFR97jPMDwU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

The deferred-freelist path allocates the first object from a fresh slab
before building the freelist for the remaining objects.  Unlike the old
path, the selected object is no longer the head of a pre-built freelist,
so its freepointer remains uninitialized.

alloc_debug_processing() still checks its freepointer. As a result,
boot can report:

  BUG kmem_cache (Tainted: G    B   W       T  ): Freepointer corrupt

Restore the old invariant by storing a valid freepointer in the selected
object before alloc_debug_processing() runs.  The pointer is the head of
the leftover freelist, matching what the old pre-built freelist path
would have left in the allocated object.

Fixes: 895272864130 ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202604301428.e2b8d3dd-lkp@intel.com
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
 mm/slub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index f96bac36229c..af942753d495 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3690,6 +3690,15 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	needs_add_partial = (slab->objects > 1);
 	build_slab_freelist(s, slab, &iter);

+	/*
+	 * alloc_debug_processing() still checks @object as a free object
+	 * before returning it to the caller. Since @object was emitted
+	 * directly from a fresh slab and skipped by build_slab_freelist(), give
+	 * it the same next pointer it would have had in the old prebuilt
+	 * freelist path.
+	 */
+	set_freepointer(s, object, slab->freelist);
+
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
 		/*
 		 * It's not really expected that this would fail on a
-- 
2.25.1

