Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EA47CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B4F8E00DB; Fri, 24 Oct 2025 13:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C723C8E00C9; Fri, 24 Oct 2025 13:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B130E8E00DB; Fri, 24 Oct 2025 13:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5668E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:07:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 544DD1407E5
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:07 +0000 (UTC)
X-FDA: 84033638094.11.BBB53EC
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 731D7C0004
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:07:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=U5v7Y2Nq;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ptesarik@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761325625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkvZhdbwE0zHe1scRt6PXV1u04HKt3doe8wAYGFveK0=;
	b=HZnVi5bK0rziPJkLIDouJ3YEC94T0aNeHNVn2dObLcynATmKVQ2O0YU/oUtr/WLXEjJWa8
	XlKada4mPh3qZ/A8se3BkEBwkVSA39c2JqO3coETibpqONnblyMsOyMvZ2gWBamHr5Cb/V
	SL1VfBwO7SUmJLwH73Dst+UiCa+zlW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761325625; a=rsa-sha256;
	cv=none;
	b=ty+MILMPlb2NY8xNsQpyBvN+W50VFWYRsX0GPvtIb3tvdn9rceb3bekhk+GH30Fn1JRhEt
	zpC788QXLZFniq2kbyzTzm4hpKeDHLmw3YqAoMyOKsvidO7sebuwwp3OhjMTW36H3TggNm
	GBT3Db0Ogq0LrqZUrXWq2b25PnPRrzQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=U5v7Y2Nq;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of ptesarik@suse.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ptesarik@suse.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42708097bbdso204774f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1761325624; x=1761930424; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QkvZhdbwE0zHe1scRt6PXV1u04HKt3doe8wAYGFveK0=;
        b=U5v7Y2NqSHlzCgV2QRFR3HbP+npv8qZsvuAid2L++B52ooUWfqwzvffcHNXvGWf7aY
         HB5epnu+svA9OrZ0PDOsjwBWtgdiYt5j4FD53q9JVOupfyusCvBIDQ8ujMCdBHFex8lc
         8eBF1nHXEWiwu7MaejXyl9VGucC/IRwH+lJCcjbx2MBidX7dER+gndCQaymYmUSjMV1a
         ACwJ4Zac2sUfPkGSKUEn+6I3vlu4xw4hYhrQXTEvReDyrqK5nObjCY+ZHEQkxja7IcXs
         EliviGpXFOeTPnyWtZJxvBo1/AN/INqj1TjD5Fpgy4o0xrI0Sdu25gvanmbw0aM2UFgV
         Ye/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761325624; x=1761930424;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QkvZhdbwE0zHe1scRt6PXV1u04HKt3doe8wAYGFveK0=;
        b=ffscbewMSBPczOukfhqOlB3Qi0QGMe6ZrVUGnghzgn7vyDzpjdP2NThanRTBQKz/So
         axqmGLoXw2GiN09djxMb7rcPKaxIFtGd5jADQhtaTJTB9nalkiWCq4Le1k1PuF6xj6t4
         xl83Q48rCKsB988LddH8AV5h085pM4xYxfhSsrZFuOkMrrR4jK3wTMl+0TlRg380O2T2
         728FZOBhhLHneGSiPMJ65SHqsneny0PuaNnQlCsKvh++t29XgI+FVlOsFGelWnZ5xpkm
         aEGH2bykG9nTbyYWtZ9+SQp8yEW1Y3rRfcXQf75/qsm0zqtkWj47wl2uZKVRBZ59I5Oh
         yPwA==
X-Gm-Message-State: AOJu0YylIe+MR1UX1eeAZ9aDgId3TSmLmHwL7npGg/LCG9GCVloCP+Qd
	rkYLuM4SI7/y+xKVIHJPBUMcQrVV4jOrc6VOh9DbKins5TdllPmuLzYlC/dPC3b++y0=
X-Gm-Gg: ASbGncs7d8D7Ek5LyvzF6kZ/tajttwe3BhXz9CVNH2+OD2BS78vnGTV5TL8JqBziXUT
	CusEE9cwSsqrWxaQbBxnTMKVt44Qa/fynGiJOc9pnHE1UGSVS2CzGOnYUYpPqLawDaH/K9NB8Ls
	rUAc2mJDSUIcUm4zPF8g2g2jjLA2Iq7aUWNMSQr4DilqOUpc/tfTduuPPFTKOWyz+Y/MYy4G89J
	4raNtsU67SE1ctHsSJaTeHPg1uxrEkOOVBkgVier4WtOAbUTHIcqbC90HVTRRzU7YduE05SWUEg
	wgeqcGMBL9Z6GB9izDienVRkgI4v/wowOwHumPpfMnGtlLlx+utqsR7mMHppE4mU/fjLbGdGq1/
	zKPUfCBEOA8wGXW9fjK7TRtpX9At+EhK7vcI/4VFxt/HABLe5ytbT105z6E7ACUDEFo+fYsDF+s
	MCztJmDLDW++aFBW59TNxT5DufedpYKh7lScQITUyRfea19bb0zd8ci+bl1L+gbnv27vXGnlU9Z
	/3RnA==
X-Google-Smtp-Source: AGHT+IFOdIsSVVzn/A38btcKv1b4yLc5cSpEdQBdQ3LC20PhUez9LVJyrDwpHJch1FqbP+zb9YQfjw==
X-Received: by 2002:a5d:5d0a:0:b0:426:f590:3cab with SMTP id ffacd0b85a97d-42704ca9e0amr10525949f8f.0.1761325623887;
        Fri, 24 Oct 2025 10:07:03 -0700 (PDT)
Received: from localhost (dynamic-2a00-1028-83b8-1e7a-3010-3bd6-8521-caf1.ipv6.o2.cz. [2a00:1028:83b8:1e7a:3010:3bd6:8521:caf1])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-429898ec1dfsm10336995f8f.43.2025.10.24.10.07.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 10:07:03 -0700 (PDT)
From: Petr Tesarik <ptesarik@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Petr Tesarik <ptesarik@suse.com>
Subject: [PATCH 1/3] slab: constify slab debug strings
Date: Fri, 24 Oct 2025 19:06:52 +0200
Message-ID: <819095b921f6ae03bb54fd69ee4020e2a3aef675.1761324765.git.ptesarik@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1761324765.git.ptesarik@suse.com>
References: <cover.1761324765.git.ptesarik@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 731D7C0004
X-Rspamd-Server: rspam02
X-Stat-Signature: pioja1hmemi4ghuda3m1ckzq75xsiwhx
X-HE-Tag: 1761325625-3152
X-HE-Meta: U2FsdGVkX1/S2tYLv3ETM5XpVVYcqzHcVz28LKknZIUFOrNhU1sEwKmoun2Ki0x2wPxbBZqrvKk0TuRR2ykv4dahYU89afvI/Mo9DjVuR9D45k7Ukp3FBZMzhbE4az0Px/7g50HnQWihZ1OHHbV51GHX5DIqd6ov3v92pcD7RKqJ8XkdxBaR4noKRVBvUB53m46NxbYIiV3WmFLDpMgHdVXl2i12xTCHu+QifsI3xsXsDyn++VkAYHPQu7BzyHu5bStAZEXWt548N84pgf+qNdGgJESSBb0B3LAZocIZI8Kci1N2aBV+tIERKmeGAjpsqwjq8XENrhcKpLx1Z1lNIQeZ0rs4vwihObf1EtkVu74djYuIYZwKGYaqk4tTkehRg91GsUyYz9A6s5WrksRhKJ/MZpmQBEwKoRjFNDXpsl4A7JbVQ36T6d34WqmCIC8eW89yZNpI9xpWckXVWTkLDVm5rVycSzVDSV4PIEIhRgZTvbXaSxu4KCexx7aVY8cqwjJImhFjR6JpYHuP3vEvakFgpLUe7y8PcOnSTh1Njvj4UXO2c1qcwnCjTFr0aUMlix3yreW/iq9VUPAEzutVi0NKFYtzegMoX6shVSAeTDA5Zfk5aFCjM6WyIODOoKHfT0iWeEr8kqFJxhgBgcT08po7VC5JwfqjE6i2ux25VU8PoYTIHoiXX1KXg6pkOgyag05hWWpaM0GQy2tQBdGlUlc7UDiwSIdrWhk2i+2PpMdR6SZkyTUUQmBfNqwH2e8s6VYK6HkzgmUFBgDFdjx77aaM/lwhEjtdUq3CceOOe1f/oWV3ZXIMyXC15BZkWtT+eJdBBzedswiWlTem1CzStqoash2pbdBKyKtJgRejNGsHUSm6s443hfJcVU/jzqcuYjfXcr9ic4EHa0FLIE1szwZP7TJI7NXhxQ7RzfD2az6Fn75/XooiKZf1XILreXpqZlky1PHIwNYUzLuUOUB
 z2ZK+pkQ
 RVW5+G/A0pMeb5H0Au3yX1yBa5DVCCbk8pFuss6zQ+DFKG76USLRfjeE+zVk2o+nuM6MWnZ+S9VRiz108TWgnMK6l37pJ4o8k0o5XxUp7c+0WtWwL+K6DtmHvfoML5jjMg/AIukTSZ4W09JTdrbXVD3ZyAC93Jd+PL74QZ7WzKUDMxJfHfoXSfGzycrbNOMDr/RY7VqJPf4/j+WIgJdM0hwQLrp0Vk6MGqxuWZCJWe3uWsTjjWDIsiYmUrV5jwHoB31AN6DbmHP+5JTBkOONwSGRVMPNg+w1D/NWCrdqXDLgtu96RuA3DzV8aenEImNlh2k9+5JobI0btUmNb+tf79XKSJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the string passed to slab_debug is never modified, use pointers to
const char in all places where it is processed.

No functional changes intended.

Signed-off-by: Petr Tesarik <ptesarik@suse.com>
---
 mm/slub.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 708848d3512c5..26faebcf27a2b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -978,7 +978,7 @@ static slab_flags_t slub_debug = DEBUG_DEFAULT_FLAGS;
 static slab_flags_t slub_debug;
 #endif
 
-static char *slub_debug_string;
+static const char *slub_debug_string __ro_after_init;
 static int disable_higher_order_debug;
 
 /*
@@ -1785,8 +1785,8 @@ static inline int free_consistency_checks(struct kmem_cache *s,
  *
  * returns the start of next block if there's any, or NULL
  */
-static char *
-parse_slub_debug_flags(char *str, slab_flags_t *flags, char **slabs, bool init)
+static const char *
+parse_slub_debug_flags(const char *str, slab_flags_t *flags, const char **slabs, bool init)
 {
 	bool higher_order_disable = false;
 
@@ -1863,14 +1863,15 @@ parse_slub_debug_flags(char *str, slab_flags_t *flags, char **slabs, bool init)
 		return NULL;
 }
 
-static int __init setup_slub_debug(char *str)
+static int __init setup_slub_debug(char *val)
 {
 	slab_flags_t flags;
 	slab_flags_t global_flags;
-	char *saved_str;
-	char *slab_list;
+	const char *saved_str;
+	const char *slab_list;
 	bool global_slub_debug_changed = false;
 	bool slab_list_specified = false;
+	const char *str = val;
 
 	global_flags = DEBUG_DEFAULT_FLAGS;
 	if (*str++ != '=' || !*str)
@@ -1935,9 +1936,9 @@ __setup_param("slub_debug", slub_debug, setup_slub_debug, 0);
  */
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 {
-	char *iter;
+	const char *iter;
 	size_t len;
-	char *next_block;
+	const char *next_block;
 	slab_flags_t block_flags;
 	slab_flags_t slub_debug_local = slub_debug;
 
@@ -1961,7 +1962,7 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 			continue;
 		/* Found a block that has a slab list, search it */
 		while (*iter) {
-			char *end, *glob;
+			const char *end, *glob;
 			size_t cmplen;
 
 			end = strchrnul(iter, ',');
-- 
2.51.0


