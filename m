Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 096D6C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539906B0096; Mon, 20 Jul 2026 10:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3266B0098; Mon, 20 Jul 2026 10:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33C206B009B; Mon, 20 Jul 2026 10:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A32B6B0096
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A5B71A01B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:43 +0000 (UTC)
X-FDA: 85009355886.04.33F75AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D54C7A000C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br9XN6gJ;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hv2b9QbG8twJiZU//bTGb/DtRCdO7wG1c5Bfg2/CoNc=;
	b=ooXgDdJMg6umWvOu6AA5CC7C0x0ECTYGZM2DNZx/mzr+sGyjsZZEsb5LTy9E7MjJa5JMK/
	jzdNS21V33i+hxcQ1Pbqd6o200VvblYYm40xaMS7u7sDFO9GmbsUnsf1L3NJ5FSb9HP0Xs
	dbXCuRehwitIx4sNi2y+nYybKV8oyjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557001;
	b=yqKundr9IcFdXYlghuQpWTeNzQwp3XkgQZjyVIuHgMAjIMslKYcvYwjbdvseovpromhqSL
	L2zfuVfOFk2aP8laq9LQuKdF0lzaOKwRdGTOk7uPwPWKiPkv1YTpWNSVKgPocIog1B4YmY
	Q7au4G4SbxA+fHcPF0jCXApOwErrLIs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Br9XN6gJ;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E22A42DA6;
	Mon, 20 Jul 2026 14:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F65F1F00A3D;
	Mon, 20 Jul 2026 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557001;
	bh=hv2b9QbG8twJiZU//bTGb/DtRCdO7wG1c5Bfg2/CoNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Br9XN6gJBq/DAksxVIjEvSqV/kxRrhJt2BSaai2pXAV2SyQ7+cQXYzdab7C2/MCPJ
	 JKtpQdpnXaCdJCszSsNOW0vBJPwlcHu7/iWNjSKih5PMsSBIkpYTBA1NG9GZZnl3GI
	 blHRKJHQGHn+Mvd5XEVY/UOjfiH9pk86iC+dxMGqDwfkBOgumDn61cPSf5pcP0ST/4
	 dec2G+CiZ0/pzr+0gjXsDyA0evWXgEecu7thWpvgReWZ/CqiuQtGBaQ/6lCaym1GfC
	 ST2Ly5/crNwdUWH5LzWME1ybTIm6HUJ1/RSjLBMOo76MObVqqqvhbjQ+pvk3TatY4r
	 LXCtocsX3g0/g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:18 +0200
Subject: [PATCH v2 04/13] mm: move struct slabobj_ext to mm/slab.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-4-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D54C7A000C
X-Stat-Signature: i4c8mt8hzttz1dzccpynbkbyh8wjf84w
X-Rspam-User: 
X-HE-Tag: 1784557001-502476
X-HE-Meta: U2FsdGVkX19XGYfJ23irysl97zUaijrN5VZreNrVwzzbKigEaYEtqjb8isbgJ9NUA5aLXoAtEYQzt9lZxwxRV+Di8hGsKNLyvdmNvIAW38MoEnNyKDWvK9+irVNBACkj1uwdzpxgCpE9cxHS8pAkrM82A8/P56kbS9zzJBi4NFkxtzKm8qXrMhzlSMi6/hJqvgU8GtmUzJbGuXPF03+wDe6Al7Ia9EMrT6TSC+DZ2ygyTuxsBZ3b1NENVW11mvFPjGZinVBAO+1l6Q3O71ukE2laFyqmkohVzcHxFvUCtHwuorpO04HJnXWybpxxtJswuLGIKil6gQ7nspBH2aUXfA3eK0kdx4bay1iyrduNA6tCEBKnw5hVHjVSKv4Owxpq3ZPETzo0Z6Odoj8/jr6URHiArxyAB56EZrS7lDNxAWWpfyKMK0u5/O2yvDQY//1vmBUkJCURtZDOi8BJMbvSVL2ZbIROZjZJU90DmBSvSh3isq+FW01DkvASFmWFzFJh17tCv9xkosIMAZDY47UwIY1GPUyENq4WVjSvrTATdTqJOIABKH447Bddo+Q+DEO2fd3gU9o2G1baYu9e3Odl42KyY5BKSABIFRJc4zGe9kkQfez38Imy56K35NxB2CSdkjhGMOLyoLb5gZZ265opwqu/8SMM5XLZD3/JMcrz1KqrCdWow4S+m3OZPv7Y4UPV1r4DSTmjjBfTeleRvmvOO/Wk7a9G3TxDA14W/q/sVFsW53gN0OLJUHj/IDyoPHzIdPXABrWrZYF3opzvyNLD7edNdyMSiF3XwZL2gUkTl3o1H488sgc8LaiQuo6ZnoYtffPqHvei7zg3qHoKRKv8gbFycoOJxyW8G3drSB5tEEDZ27kqSEdysm/MzE/c1QK6NihLvobwqIaOkMRipzzqqzOSP1uOWT9bBbNQv6ORvx65QQg7Ib9XHxYZjUAS4Sbo32tQoFkwQ40JtdBQMSO
 ZjB63Sio
 C8DWySi36w1ZJjjtigMb5ke7V8p6KjszGh7d8lGy/qUH7/N15VG8vhl3qUlpzUnjyYFyPZ7RftkvzabT0iAkFfIECwbLL8HmaSOSPQyWLmFU4GeGq/H51/oPvcQTO8ny9MgFwslfX0693HWrzBauRp6YWKoxzFNgrk5YKiHRKQd+zrYz1CZbvX7VsQiqEh+zKKE1GnF+xKO6nnaxRJJ6PBxgyxWLf6el2rYH+ja5Yhp7tka3fTdXmKzZ82V7VxifM6bUnahRRzsDAj3g82w0gXs0iZjIV3LoiJSaS9JjoxYhhad7Nz7WkIk+NjptNQmsmf+9w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users of include/linux/memcontrol.h don't need to see this internal
structure. Further changes to the struct will reduce recompiling.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/memcontrol.h | 13 -------------
 mm/slab.h                  | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..93869cc35c25 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1440,19 +1440,6 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-/*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
- */
-struct slabobj_ext {
-#ifdef CONFIG_MEMCG
-	struct obj_cgroup *objcg;
-#endif
-#ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref ref;
-#endif
-} __aligned(8);
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/slab.h b/mm/slab.h
index 01535e1e2d3c..7bd361447c54 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -549,6 +549,19 @@ static inline bool need_kmalloc_no_objext(void)
 	return false;
 }
 
+/*
+ * Extended information for slab objects stored as an array in page->memcg_data
+ * if MEMCG_DATA_OBJEXTS is set.
+ */
+struct slabobj_ext {
+#ifdef CONFIG_MEMCG
+	struct obj_cgroup *objcg;
+#endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	union codetag_ref ref;
+#endif
+} __aligned(8);
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 /*

-- 
2.55.0


