Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076D3C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 19:31:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E44776B0092; Fri, 28 Aug 2026 15:31:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4DE6B0095; Fri, 28 Aug 2026 15:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBBF26B0096; Fri, 28 Aug 2026 15:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4EF06B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 15:31:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38A66A0557
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:31:22 +0000 (UTC)
X-FDA: 85151672004.01.37A3CF1
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6EF0A1C0004
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:31:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=opQ3xhgi;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787945480;
	b=8ZT/FjzdRj4dsjMTxwiKjU6trBiriODa9DxGEFQk079vm0KIPtGYuZ34arxoWBfWoKukXF
	q6Q2B2z/kDvdJ3uXpzame/FNxhbqZFai9SJ6+R+WVS0ZGXi9P2djp1SdVT0JIecpQtX/Nc
	QZoiY0cxVv9xe5jcvcbe/k+NpMBMGso=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=opQ3xhgi;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787945480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nMnYqxHda9Omu8fyzZqn9y6ZJM5HBD/zXzNZf075neA=;
	b=49GnWcHs51p9MuGmNrf4zXLeaLrQk22+qVPVFZ8HI6j6VJBV7XQvRK/luQMBVa4FfDxxq3
	iaitWesFOSU23mYG8v51f3vqTFNx3+/zgOjQS9JsIoeDiDhpFLE699DQvi9Niy+OMinvqo
	N8D0iva0BQj9NpHNm0RSdZcDq1938f0=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-52e1f9da948so10023331cf.2
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 12:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787945479; x=1788550279; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nMnYqxHda9Omu8fyzZqn9y6ZJM5HBD/zXzNZf075neA=;
        b=opQ3xhgioRDqdHpXGSG457j2Xsrihbmm9gsJxjyB+HVR147MTslMbcXiNm72rNlhd4
         qnJcT4YsX8J8iOzyNMnXTmoH13R0ePABv1UPj8ZbDJ/+ekvMc7HPeNkx1hL3CUgMTnWL
         hBcd4pM0rEBpn/ZvLLkhcwTRzh/BxXcnpDv0mS4AKzxLSBC+Yw7vfe7KNhRa1d+qV+1a
         9iNjqSy7Ys46U0EkwbESojA0bInANen8QWeditpdL4OVPPIDR2t41kHdMXWbD2Awy1zs
         q0puTw6rgz7sQIrhNA40op/C1+8etDqtaexyH31jNABzrTIK5jhX3Rz9lO3BZ2ow6NFM
         Wl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787945479; x=1788550279;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nMnYqxHda9Omu8fyzZqn9y6ZJM5HBD/zXzNZf075neA=;
        b=W+8Nl5yzPqIFLrLmOYUpkhVHHU8zRp/9datJVSj6tIjjTTnfAaSxaEDqtol+0OAUCr
         9sxNgYR8yxF8mBfylzl/uNm1ufDVKd3P7oYTyzCwp3uWdRgpi/dhkTXO0n8YSq/Mm8IK
         Tql/a4CshQRpRp3vaJ4tOEpkdxBikiFTi/nEkLAZ8w09cJvlDyTKUjm3pPn2eU+HraBo
         9wmWYeVPR/S4DmOUPn5P0dhy4R017zWvf8RUIFWcVXFo1vWJJLvAtkPjCKUa+NsdIsb6
         CglVCdawwmqXK7R6LTcf4BUxgQCt+78DeGass28a5nH3bF+k7ce0gqCPd2xcpcDfUKzB
         omMA==
X-Gm-Message-State: AFuF++mxw91to2g+ubud26R0zBGsU44gCke6j9KS/cFe166ULWoRb64d
	nou1k+z6P0rPR/VjlP9v6SYTklVJMlkVDKfczxj01LhNm2Ky2M5mKbmGQ6IC3LIRUjr8qM+oWGg
	yJyW1+CE=
X-Gm-Gg: AR+sD11ugNzq/iGZNUmT3XQdVLA7AFZLLskksMZEN4miNXhKRmaP1H73rQMwzgqSSiT
	U/zDI7bdK6fGiAVZfO8Jp5qWuf6we6pPazbXJqTaVzGcoP+ydUn9XUnm62Q7NMpHuIj0xTU76YD
	G4qbQtexAHQw12HXoSv0mWKC0/oCHxu90adj2UEuGplRD8zImXl4K5OGEagKAB0NV4JEFT9Qa4i
	1MFYbV0Uu3n+bgCY9pqHzcHk8XClfEVapkRMdu3FcF60x7i41dvKaCBuvDWEfYhQ36S5bDEAEB7
	5spJp9yR9Ce92XwdJ9Jx5BzrUq8+DXTvXgFKa2HoOnfB0ENPclmD2Tshh35BrimREvuL0HfFIM4
	gjM+jeVWUzNtjpNVasj/hxm+NNBMA14LCPGUx3UsZOYQ59pfJUampC9KJSkmmzJSAqUnyyge0zj
	ifaEnM+GdWKm4U/KLov7nmnocLbD25CpQEkEDyx+bQUvCtDrmE9G/O8p0U04lGMunvIix5Qwnc+
	EpIQVD6sWvk900sbInxFudInkpj7NHy2rTEvPLcmaUhq6rS3A==
X-Received: by 2002:a05:622a:394:b0:52d:8854:3e61 with SMTP id d75a77b69052e-52fb94b8f4fmr119108521cf.22.1787945479239;
        Fri, 28 Aug 2026 12:31:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52fbe5824f3sm19048831cf.10.2026.08.28.12.31.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 12:31:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	urezki@gmail.com,
	chenwandun@huawei.com,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/mempolicy: take a cpuset cookie for the interleave node count
Date: Fri, 28 Aug 2026 15:31:11 -0400
Message-ID: <20260828193111.1023497-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6EF0A1C0004
X-Stat-Signature: jiy991m3fetq3ogcw5xwsi68b41mqn5w
X-Rspam-User: 
X-HE-Tag: 1787945480-886045
X-HE-Meta: U2FsdGVkX192KZcYljEOkmvCXfqCGm21n9SmDyWdcWxbPvqszhwtEynD3YR45IzojRufxLj+yXwKT8sUhUPB3RjFrFgMm5ZA2skIQ4bLDVNhyLa4ehe2igco5VelBA0ITLNRTxNrNmjF4oIcl98YukhNntEAYGqPqZxaDPfqK2+BgabPn/wyGPpoOWCr/+rGt8fv2HinbqjCun4u3PULkDB16DWhWmBXG/huw+JaQpC/IYDa9wpxEvcOVTN+D0tRvo5/YJCj11r14ozd99AoN2NJXp0sCieVTxd6ZMraf4f0HYDLVBNWzemP2R/0gqcQssAECb258FtyrJ2kR1c0YSz9CUtMGR5tblsmpS8330OHkcdAJ1E3YGHwDlgKsCmdMDXXdgXsSqnUqrozLwaumpLP5PpJc6CTBjSsLiqIU2g2OgkExzFbkcS7cuVKgmJ4v97E3gcb2jHjuKlshT4N8ZN2+2VE+/caA8Cg3sIS6KT6juA213ObDemcxqYxp6QmKeRkS4CdLYUe+9WihRPRhl34tOmiWEs/rsOCfEbfE1wY0t+WQutez9bIHLBRH8lzAnspoemzKABK9gp4ypeiOgmBEGIN8ERyX8o1RgCtgJE94Bl4g1+NiflAz1ks/6gKstDJvNbTgHMJ1yMZnit4dpiHwpUtlYF+XwzSiBw+vtDk6T2EhjTWYtzlcNhKIGOMrZfPyQhI1z57ZvkteLRUsRSfU8zSK9JD9x1zioIoCu39rkYmXHiqSHWta3LbLghn7Bfz+0DQBq9xvB9a60VVeaHUpwNx4ugNQvEOP2HHSJNeARF9NKSajoHK8CjWlD/z+T8A7sCB1Ekne//NWS/fEmTAc03pSqrcJug6m3l9TrZ3i1x6nsvGTuRs7OdOGjHwdXDYjl+OYJdOKPcCdPui0m+bnjbcuMmqJRL8ZZaLRiK63xk2uo50INhdvFKKOt5/fy8X1n7qjrm3beUxz1N
 9gr3L48i
 wrz1H5bh66fVdtOp3SrbWgs61y+D0iQ0ljZUCJBK5Hf41zbmhAWeHtV2A9T1k8go6GsVW7IM/t3cLqwSANFTYWQ9jAqL9eDG5zqbM3MShfexV17RHTJuNJDMEdO1g93LcRe1tIh1SuPAwDO8roS1/L3RvCyXTU8ylA2UIqnrdTGWZ9iJIbWiBfnwgW3k7MrSUmEi2CSi8iphzuzknJ4cBYiDWmeb7ND4Nf9GWdqsgpS/qpODqEVoDdNzAF/BYiqVxA1LddgPMlqr+mKo6yTmk7Qm3qUt6eS2YMA9QkALNxfLXkuV51M5ws7oxw94cR6iBQRE9FKJEgis+WXDX27ccO86J+yCdWj3LSRUv1/pwNKS8nMwLw7a+ts8CKLJxYtnpLAopHqdvE30BBq9ztXypKbERFZ6chYmkdGJ5oMKTa66fnCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_interleave() counts pol->nodes without a cpuset cookie:

	nodes = nodes_weight(pol->nodes);
	nr_pages_per_node = nr_pages / nodes;

nodemask_t spans several words once MAX_NUMNODES exceeds BITS_PER_LONG, so
a concurrent cpuset rebind can tear that read and yield an empty mask even
though neither version of it was empty.  The call then allocates nothing
and returns 0.

Some compilers will hoist the loop entry test above the division,
because nr_pages_per_node is dead when the loop does not run.

	682e:	call	...		<- nodes_weight()
	6838:	test	%eax,%eax
	683a:	jle	692d		<- nodes <= 0 skips the loop
	684a:	div	%rcx

So in most deployments, this div/0 is unreachable - but nothing in the
source guarantees that, it's just not easily exercised.

Take the cookie around the count and bail if the mask really is empty.
Only the count needs it, interleave_nodes() takes the cookie itself so
so a torn read there is already retried.

A rebind landing mid-loop can still leave the count disagreeing with the
mask, so the loop may revisit a node or skip one - but a rebind where
nodes change causes migration, so a handful of misplaced pages isn't
catastrophic in any sense.

Measured on a 72 node VM (NODES_SHIFT=10) with a cgroup v2 cpuset flipping
cpuset.mems between a word 0 and a word 1 node set, and the two word read
artificially widened: 330 zero counts in 130414 calls without the cookie,
and 401 retries with it.

Reported-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Link: https://lore.kernel.org/all/20250907160829.91628-1-chelsyratnawat2001@gmail.com/
Fixes: c00b6b961099 ("mm/vmalloc: introduce alloc_pages_bulk_array_mempolicy to accelerate memory allocation")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 79053ece02cd..060a0eb26917 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2592,6 +2592,7 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
 		struct mempolicy *pol, unsigned long nr_pages,
 		struct page **page_array)
 {
+	unsigned int cpuset_mems_cookie;
 	int nodes;
 	unsigned long nr_pages_per_node;
 	int delta;
@@ -2599,7 +2600,16 @@ static unsigned long alloc_pages_bulk_interleave(gfp_t gfp,
 	unsigned long nr_allocated;
 	unsigned long total_allocated = 0;
 
-	nodes = nodes_weight(pol->nodes);
+	/* count the nodes, retry if a rebind happened during the read */
+	do {
+		cpuset_mems_cookie = read_mems_allowed_begin();
+		nodes = nodes_weight(pol->nodes);
+	} while (read_mems_allowed_retry(cpuset_mems_cookie));
+
+	/* if the nodemask has become invalid, we cannot do anything */
+	if (!nodes)
+		return 0;
+
 	nr_pages_per_node = nr_pages / nodes;
 	delta = nr_pages - nodes * nr_pages_per_node;
 
-- 
2.55.0


