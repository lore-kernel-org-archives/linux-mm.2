Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83173EDF02F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 04:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A206B0089; Wed, 11 Feb 2026 23:51:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1396B008A; Wed, 11 Feb 2026 23:51:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88FEA6B008C; Wed, 11 Feb 2026 23:51:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 79BD76B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 23:51:34 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24DF1160640
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:51:34 +0000 (UTC)
X-FDA: 84434581308.10.BE3C9FF
Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 500C640006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 04:51:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e70t6D6Q;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770871892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3624LeowZDDBkH5ZBXE4RT1ghzAQISXfFg8F+edSqSU=;
	b=Gj2klxE1XdXWrYRKDugGyNzPO8e0khP8jfGHRHL+2j4Jf1EtgO7Q0p3rT3VwK6Ixts2HoW
	Ghm+xrJEUOl57qqdxb0OrrBWTu7TEIqX6xfOGvGOZVPuaW0RrSDw6Pj6iG81gEjd8fZy+i
	kw/5SO6NPAAmXmZ9otvclIO37f5xQKE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e70t6D6Q;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.195 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770871892; a=rsa-sha256;
	cv=none;
	b=wGfaeAoAimBxZjww7mqmdL1+2m/kswv5LRnRyIxverGfc3Frgfl5lBd1HieHKmtTxXmbi6
	UmtXysMDYrHWevl1Ml48cLz2bFGlsMQL6aJQh9gGaYdsQ2Ams6EKMu3fJtgyAr65breoid
	98fSp+nXzUeR+4XmkQzp6cSSEt7xtXM=
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2ba64b5a53aso4209967eec.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770871891; x=1771476691; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3624LeowZDDBkH5ZBXE4RT1ghzAQISXfFg8F+edSqSU=;
        b=e70t6D6Q2zCndUiyU7Q4MHz8NK+7jvcsyNLGPzlED9pV3LBhUAuIXxiQ3o69OCJ73/
         oIcAg/vRP1+j5Li8SrssDtvVKgKZchhrC6LkogJgmhjJcxcBMQQArwBxn4jBa2fzJdAT
         zLHWtO+ZRh77pmW8dU0mMFXL0wgmjj/Bm9+ACXKADbkNV6X81AvYD+kmgRcNQmMTvEe7
         ra1L1tijpCMAM2s5kAGyqRyxNpgNRt2euRFLml8yNoueUh+bwejImziBWtkp2ottq2CD
         jzEU+Rx7fLQ0ktp9tvPT+g8dFndF9kEXxkhi+YbH4HqZ5/Wpd/f7G9HNohUREofVv0wz
         594A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770871891; x=1771476691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3624LeowZDDBkH5ZBXE4RT1ghzAQISXfFg8F+edSqSU=;
        b=EazIkhBLj2s9xnvqHApmc7agDOgXe1P12l5m6URdyIQXn2IovXWgbwtRhZCrHjzRX9
         k7ZY1b28PdAI8sxJ95yR2HKS1FFrbM8pxqfNLtV1zFVmjilhHtAMCPAMjN27YGHn6jLN
         sIdkejW4LuV0y95VFT1MszRXEoXTrG6h1qEZGfCAL23Qsh8M5jBXzFRLw87bbfbtogVf
         xjeWf0GiqvolLkt+ntbgQ4u4BTJF+hLHGOSYKNFEB05I9RYEcmOQArTNzPGzTOGQ1ulq
         HszoSKq4aiEsz72+VAoiGoyTb6n/W1pUytMwXTWjTpttnHULHnLgNgykxrLFxLmo1aY0
         9vvA==
X-Gm-Message-State: AOJu0YwhxNkTSlFg10rueKXs0iXYtjVa60ClFZgFiI0Y9maOB6E7VHUL
	t96+pX5DBrTXUU8jWhHdjwPiT6m9h38PClrzwgGZXfTYTy1Y+MHZYgs9Rupym3FQ
X-Gm-Gg: AZuq6aIbDgt5WSSj7G4mVJGhmytMEYG9ZTvIKqza5+Nt1Y13DDfaXD6oR0xdU+9Ozrc
	l+7QL7p2Tbel6EBvKkeLMko/JVkdGQADaLpi06pWP8taBB48NZAZ9IKXUvsfgyVuNs4NwBKPRhF
	Lj6IARD+i4aCsPVHLcSdlhRHl+rRfLiDxhAZznDFoWckHWu7hT+4hR7/wnQ/322SWv6CcdA/cBt
	W3Ft5J79pDCte+0gfn150+vCxVeFG5KB/5oU1MXS2rZR8ZRL7qKQc32+fsQ1ZfsUf3DfbXvulOm
	Ex/wo1uIs+Ritg1OYrA/aNIDrONojekC1yScqcKNQH6lsGbUil7OiWF+o26ZsvXpJ/FZsIzMX+9
	5GAlkDInt/A/NE0AsYxpvEKna0pi+X48W8hO8vVnVE+eqGaRJtC4UcaT1YZZ64nwZo9H6Yv/zUx
	AVSPMNol3AXpdUME84wjtpni1e+VBahb1hFiyA/8zCvBR1Ax5vYQ==
X-Received: by 2002:a05:7301:2f91:b0:2ba:871f:796d with SMTP id 5a478bee46e88-2baa8091399mr577872eec.30.1770871891051;
        Wed, 11 Feb 2026 20:51:31 -0800 (PST)
Received: from jpkobryn-fedora-PF5CFKNC.lan ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ba9daa6151sm2878699eec.0.2026.02.11.20.51.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 20:51:30 -0800 (PST)
From: JP Kobryn <inwardvessel@gmail.com>
To: linux-mm@kvack.org
Cc: apopple@nvidia.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	mst@redhat.com,
	mhocko@suse.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	vbabka@suse.cz,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
Date: Wed, 11 Feb 2026 20:51:08 -0800
Message-ID: <20260212045109.255391-2-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260212045109.255391-1-inwardvessel@gmail.com>
References: <20260212045109.255391-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4g7s9uxip3bd1y7txqdshmxsfngj1wi8
X-Rspamd-Queue-Id: 500C640006
X-Rspam-User: 
X-HE-Tag: 1770871892-860577
X-HE-Meta: U2FsdGVkX1/OiSb145DvT+IytZlGXiAOLSNkGks5wI14SL3QKXb9X+Pt85icHQMoRoAtWOSNgj14N6x5fhTm5eIP+g5cIstGIC0hzrDw1VV8h0ZAnbSlIVpe0j6PbEZx15LhIW8K0jxYhjOk4i0woYKy2Zip6LJIPp+ZXbYydK/6f7fE4kz7RG+0hRPgGfIinRndkdfDH4B43HDgZkzN0069XS45sbgiJQNMv0D0GwpwBs8rnCi6FeEMr+su/yYYuoJTvPce97hSyW3ULNJS1Hz6BPCHUBGZTbaRAhNf/fr98/NJ5kAPsCse4mFSkvfpFbtb1QfXMBqDTA02vvqs04YEjOFIPyJmXaCFMfkFOM4K5Fb5pvSsx8lrqlQ1Wsz1g3hi1FEEbDt159Wx7XnjY2WPoWwOdps0MkEx+SZWfPkwMjVjeWmpWJyEU2qnL8Ugh4fNgGw7IIrygvV/qkRVKVRvm4jt/DH5jdMkNgJNMI6gOVTJZ54KmIqPCwjwZqQPd4QmS1yMredOipADa+sE7vCYhwRoQJWI0eTP/oerMpBkKMCe/Rf1bRzyh/aAMf4zUS5uNq5WHNddit3YtZ2RnOrHEZUKAi5+cJ26ihqKLWB7WeiXrw37BYN32a5GvzIxwL17H/mgLhdfuEFJXV2Jrp00/cwUtllT4fLhIh8O1yQJ/xR6FNp3hSLiHrl/MCscjONJvd4pMGHQr+P8LTesjAHU85VZQTrvDK4OvSDeVm69S4yPBPMzKerdqGmwWTiPhB8Rq/ojR7LeewSVSMnxyVe6ftbNnC8/PYUp+fl/ewYqfyB2PzH9smarNdazwadTO/IRFPirqLJXPoifz2+MFQrwz4M0O73W4Cgkg7BIg6gr+JuFOlDBha2zdOyrQc4lUxE8vuRT4KESztnHNtxxDptGRm18voNigLwR8IRxtuKqR3J0pRFwUgJ85OunIumZRhqu5kDzQipozjtMpN4
 sW5PtJIM
 yTAnewhypgT7ZhLy3ChH93TSz1bf55ZnkUXuN+6bubmJPDk1H12JeT/j/+w2Du40FlvEQLU4sG7VGk0I94UAi36V8xIGq4uZxxE3cwOfAFrmg9T8sKT0amT6MxpUAiIqW6Ve6sVWHzVDi4eMce72z5Jso8HXnWIe4vWALRs1a8f2MRliqCoXVJCkSh8cQpG7LrclOQXhpjL487jM6bRIrYW8awY8NII2EgqbY2yEm3kwx1g3PRTdf6Iqle0NiHERwRQeDNGWs+x9FljcrkIPNr47RYYUuzbu1GFaTM8VCJ9/TPJLQW4rlF1CmIK0gOsXLy/K/a2mzng2WxgeExPTVu77H9HJAjsoyf/fP2ifId19Wlbh8Y1fkzNegLAIpcS5T4isq/ObnLv5rOB7kdcD9jPVWDq3yhsWCcj90EeoMNckSPshhO8ODfnx50SuvQ2nzrbXUVBM8ZL5T2TWxnpW24Lr2S9MbNvNb3In5lWoG3bozkaS0qGSXoNQHe/g1APDP/3ZJufG97eb8K33OygAS65efL7ZFQPyXTnXFvQo7UFtajIDnskMaac61wL2EByi0X8uJKNyq9oOk4rF4HkvqegAGWwSFIgAirgH5Zvbf0+5l1aJ6L+gb4sbWLA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It would be useful to see a breakdown of allocations to understand which
NUMA policies are driving them. For example, when investigating memory
pressure, having policy-specific counts could show that allocations were
bound to the affected node (via MPOL_BIND).

Add per-policy page allocation counters as new node stat items. These
counters can provide correlation between a mempolicy and pressure on a
given node.

Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/mmzone.h |  9 +++++++++
 mm/mempolicy.c         | 30 ++++++++++++++++++++++++++++--
 mm/vmstat.c            |  9 +++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fc5d6c88d2f0..762609d5f0af 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -255,6 +255,15 @@ enum node_stat_item {
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+#ifdef CONFIG_NUMA
+	PGALLOC_MPOL_DEFAULT,
+	PGALLOC_MPOL_PREFERRED,
+	PGALLOC_MPOL_BIND,
+	PGALLOC_MPOL_INTERLEAVE,
+	PGALLOC_MPOL_LOCAL,
+	PGALLOC_MPOL_PREFERRED_MANY,
+	PGALLOC_MPOL_WEIGHTED_INTERLEAVE,
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 68a98ba57882..3c64784af761 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -217,6 +217,21 @@ static void reduce_interleave_weights(unsigned int *bw, u8 *new_iw)
 		new_iw[nid] /= iw_gcd;
 }
 
+#define CHECK_MPOL_NODE_STAT_OFFSET(mpol) \
+	BUILD_BUG_ON(PGALLOC_##mpol - mpol != PGALLOC_MPOL_DEFAULT)
+
+static enum node_stat_item mpol_node_stat(unsigned short mode)
+{
+	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_PREFERRED);
+	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_BIND);
+	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_INTERLEAVE);
+	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_LOCAL);
+	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_PREFERRED_MANY);
+	CHECK_MPOL_NODE_STAT_OFFSET(MPOL_WEIGHTED_INTERLEAVE);
+
+	return PGALLOC_MPOL_DEFAULT + mode;
+}
+
 int mempolicy_set_node_perf(unsigned int node, struct access_coordinate *coords)
 {
 	struct weighted_interleave_state *new_wi_state, *old_wi_state = NULL;
@@ -2446,8 +2461,14 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 
 	nodemask = policy_nodemask(gfp, pol, ilx, &nid);
 
-	if (pol->mode == MPOL_PREFERRED_MANY)
-		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
+	if (pol->mode == MPOL_PREFERRED_MANY) {
+		page = alloc_pages_preferred_many(gfp, order, nid, nodemask);
+		if (page)
+			__mod_node_page_state(page_pgdat(page),
+					mpol_node_stat(MPOL_PREFERRED_MANY), 1 << order);
+
+		return page;
+	}
 
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    /* filter "hugepage" allocation, unless from alloc_pages() */
@@ -2472,6 +2493,9 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 			page = __alloc_frozen_pages_noprof(
 				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
 				nid, NULL);
+			if (page)
+				__mod_node_page_state(page_pgdat(page),
+						mpol_node_stat(pol->mode), 1 << order);
 			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
 				return page;
 			/*
@@ -2484,6 +2508,8 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
 	}
 
 	page = __alloc_frozen_pages_noprof(gfp, order, nid, nodemask);
+	if (page)
+		__mod_node_page_state(page_pgdat(page), mpol_node_stat(pol->mode), 1 << order);
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE ||
 		     pol->mode == MPOL_WEIGHTED_INTERLEAVE) && page) {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..74e0ddde1e93 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1291,6 +1291,15 @@ const char * const vmstat_text[] = {
 	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
 	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
 	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
+#ifdef CONFIG_NUMA
+	[I(PGALLOC_MPOL_DEFAULT)]		= "pgalloc_mpol_default",
+	[I(PGALLOC_MPOL_PREFERRED)]		= "pgalloc_mpol_preferred",
+	[I(PGALLOC_MPOL_BIND)]			= "pgalloc_mpol_bind",
+	[I(PGALLOC_MPOL_INTERLEAVE)]		= "pgalloc_mpol_interleave",
+	[I(PGALLOC_MPOL_LOCAL)]			= "pgalloc_mpol_local",
+	[I(PGALLOC_MPOL_PREFERRED_MANY)]	= "pgalloc_mpol_preferred_many",
+	[I(PGALLOC_MPOL_WEIGHTED_INTERLEAVE)]	= "pgalloc_mpol_weighted_interleave",
+#endif
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
-- 
2.47.3


