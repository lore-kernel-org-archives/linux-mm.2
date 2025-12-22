Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F37DD68BD5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 00:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83C6F6B0092; Sun, 21 Dec 2025 19:49:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6596B0095; Sun, 21 Dec 2025 19:49:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE3C6B0092; Sun, 21 Dec 2025 19:49:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B5846B0092
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 19:49:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26569C062E
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:32 +0000 (UTC)
X-FDA: 84245273784.09.E1231E7
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4D41E40004
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:49:30 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U2PXIjTU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766364570; a=rsa-sha256;
	cv=none;
	b=wtlEejyxPthXwHxvdc7wFs/Mfr9M27aVFj1StXlG4P6Hha+GRPqVjJ/lE4Fk+soaG2ixGV
	x6jdUaB7Krg8WY9VZcB4rii4T8YneeSyyl9hoP3sZdW39F5xMDTqcBU5nuoAUNurk8vhYQ
	eNVTx0Uv7YpGJKCiXxgbNEo6A+U68Hg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=U2PXIjTU;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766364570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O11NpgEudbETTqMQr23yY3JLGVYTvh4uSvV3m2jKMg8=;
	b=bBvjBw5/BXr8l2j/64yGTc0+uTiq3u+D8IDhJX/ctK1pj02SctuT0o6R4FPn2j87QhxT1C
	DymgP3K1Zy6o5MQ1yKPcv7oG3A1CRTVaa1Dq8JggPw0ujaqqD7bWToMUiMwJ4vA5cVT7xd
	7xpmJCRjkmpzZZC+mpsTBQRt6QwX/2Y=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7ade456b6abso2792050b3a.3
        for <linux-mm@kvack.org>; Sun, 21 Dec 2025 16:49:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766364569; x=1766969369; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O11NpgEudbETTqMQr23yY3JLGVYTvh4uSvV3m2jKMg8=;
        b=U2PXIjTU6nTiYP4tGE54rWbJzuSuVNnnedGIF9rmBkTVsc0zU/fFHQzd+UWwI9bSx+
         bYPRLWk5iWsLpSWdU6jpPaibL5VpzgRYbh7EEyWV6bQs9XlZia+uLZ7Zo9Fw4cjHNhPV
         r/6IXmNutHokAXgtXCKB8dpdHgvf1PZOBYwmfGecnw++oghxdN2eE0TjLhk8De1OTVyG
         ppM0hntDwvW+KWQpT5RcVWwbq/DLdVVzNF0F9+uoiTwv65tEW+2yLCLYLmUQ5ISw+oit
         ntaCEdcvprgO1HoSiZwlbsBmwKvZ0Wwi0ZzVOJJpRHJQ0KyM031hxFDkc27BFnBt1O11
         Am7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766364569; x=1766969369;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O11NpgEudbETTqMQr23yY3JLGVYTvh4uSvV3m2jKMg8=;
        b=WlWZYkQ3G/McqdJls4+a4bdCc4JA7ZDpfSgF0MmYXZ2yiFu46UuOYVpPrWiC7TaPMg
         e0Nemo2vNObHupIpQI1BS4O0/OIuCa2ZaI09UyLRXPphubbh31aMX9K0PpXjFpeKbYoi
         p7frde56ruwYcpPHx7rbbBHf+MRlY1PWPgMoAL3TFWd3Cqvk8Mkov3gxPxQrguwZdcYL
         jlHRSBBGSgcPTmX0WARZAUZo3sSnEytzfgQggyOXhmLCy468kVTFIEGPj3zQIJqGkPNl
         0To7G4s9vHCwS0qXw6PPX36J9ZhGs0PcRkxQ4wFqJK7rTpU2eXm6rbzS/nVjo0Fho8Nz
         Px2Q==
X-Forwarded-Encrypted: i=1; AJvYcCW61ICGJ6OOMIRBf7wQD76B2rFONcuWnEHPdA+rVSJJU04nMMAwhDy4aC/tXpxOrodka82qwo+DYQ==@kvack.org
X-Gm-Message-State: AOJu0YxPSS3BHUwshqzCMAa37S2yFMjv/2LhrTBAexlJKeiy0/UiPLCJ
	BjZC5Sjz7u8nCy43I0UIzx7K6cNLe6C6joCTQUS1s0rPjx6qLxwJrymR
X-Gm-Gg: AY/fxX7RDIyn3bEeE+UCJ2RDELvx/opqCrB0cBS/HKwq10bpwltIGwre1awAIMmTQEe
	U9fE4QH/UJnkVIiuVS6qwuxTF12nOHeJB9jb6PbVIZ9IE9XKe90cz4tO7/RmvJSY3+qGJUBKI4h
	DIPDNNpmmYFDWVJcClMoKZpCbmhrixXtl2872gYJa6cMX4+XfkJsaPo+HS/05CuRVU2X7dLyJWb
	F35hz6MBcC5XshCnswvPwAoF/yQCp775dkTSMNNEikBHMSLkT6A8QHB0tFVF/ln4mXn21ZHm4QQ
	b6r7+kv5QxMIwbTVeZnwDFxWkWbU83e9e484qqMM/cVWB2HOR5oqkvg7l2uEI6IdC5CKtZKAuKe
	sEvrLdr2oaMmoQ57Y6UbU0Cl5Pb/Lpv6zBH0coaolFQLS1D48yKBxFn+yiJZHLLuNJjdVtEmUwL
	SHGvcBf0JRyT/EUBQW3KWHrhKQ4g==
X-Google-Smtp-Source: AGHT+IG8HmbbKxbFNUbBIyvPC/wqo5S8q0fmYrBfBYMPa9s7jMVxNEhlbTkPAWQV0fM658EICPtxTA==
X-Received: by 2002:a05:6a20:7d9e:b0:364:be7:6fe9 with SMTP id adf61e73a8af0-376a83d884cmr7849186637.32.1766364569009;
        Sun, 21 Dec 2025 16:49:29 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:df7d:b611:ffaf:6d45])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e79620bd3sm7461832a12.4.2025.12.21.16.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Dec 2025 16:49:28 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Subject: [PATCH v2 3/3] mm/vmscan: don't demote if there is not enough free memory in the lower memory tier
Date: Mon, 22 Dec 2025 09:48:34 +0900
Message-ID: <20251222004834.10539-4-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251222004834.10539-1-akinobu.mita@gmail.com>
References: <20251222004834.10539-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D41E40004
X-Stat-Signature: 3tzi15f4njxti16fief14grppcgwa8kc
X-HE-Tag: 1766364570-828983
X-HE-Meta: U2FsdGVkX18cGvtvHPilWH8SVKpk2+yrwoV2FlIA/nWTVOc/LojDeEfRF7mQF55nPQh4Gonw/fU2AVg9I43KU61BEL/Su3jb5isXbFJfm4IeEO9g9Vb6+Qk9w44yWpNfcDQW8MeVX0zLo6JYm4BVEiGhYo/jGgTSwjoV9yHY3PiOMTXSPG+fyMF8Gh/REGTUPzpcPthtbOVg9gwpDLpEDGhSj0O7VpFul26RXnJC1kRA0gLTF9IsLM3duKgLepnasK3G36Nat+bpjakx6v9nYaUxVQGv5NtuQ7S2ojDYLWnZff1qGLgyoq0rtVFBJdnWBu21pdPMWvdY11FTsEcg0OHAUVUWA+lFjcmPqExn5LSDnSX5AIXpL57BX62SVvsGOjo6C4MUtLKIBtVQmKMy2DqdODsjkObeObex6DYr8cgibE0mMVX2GwiokC7I4oXdLsCKWgCrIRBJVmpbQjUoibP0vYs8nEQ6UQ+ebYPTkj5TQ6OzfkefhLW3Z+rHEbP9AUdf396+8IUDkXHnxX7j3t5QHdIwVwhmWI0t9MLni4AwNi/eoRiAAl+5GoCWPLgTWAhMpC14jPSxBCdOBfJ1WwGJgNACAZb3Y3eZXBBwqG+Sd+a65E1JQo+o3PyLom4byLg4PYWu1hNydlFdu5MjtkZUXFyueQC3JTimXUh/mcVeCcLKjjK4x1o+4xuc2QDdAXInlSCbK7EJXQMqbGubO9YoBztrmNE2i2uQmNp90uSlFOIrRVs/1mLaZsPiBdFtMzRKGDHLF4P9s0gASPcuLugnyxacnvAOfv8tgR5czVAvn2QigG3azLeFFVXDDdnDEzb0WHgv0OXLMVaaRSToYRVVOTonraMXOP2OPmP1F4+ngrKxgkO0Gool4S/Hmr0O115qaJTeyuGlzJ/sauTBss/dw+yKcdzriIJbXZkK2vkN2HpliO7wZ3L/nVHa3V+kWFNYK5CgHEVCJSMhPWJ
 hTnfww0s
 XTYTdi7XriInkx4QCUSOfdWU8pXXn12YsCFPK+TVg83zpi56roIhs/0pg8SvPq6FHIzdUnSf/xCdR1jvTMfXHJuN6rqZ653KkY5Lt/z2wEfaIJhpGC3CkZ2odN8fxYZP3sDybDlUUBnk5vzSsmtN51bj3RR6fgXzz30PgOSm0peGPVBk5FYPMicGwjjQDNaAbXEsu/ptpLUk1tW8OWoDbFJHRg/0drnTdeAkvGK+B8N3E0yUl1QybRS8AP+ntm5bYXYXL/r0PCpeQqlQcUrvYjJNVCndJyjhJh4Qr8Qp/LINL3fTDqXF9mYzAvWiHtAwkK8yUHQhKQXXioq/UcFLCgqIyw73dBQAh37Qqnt8sa47LJysp0joNReQaHNeBPqG49G83016tWCEk4WfXDCRTCiccroQ+YvTi3QI2s/EZVzav22d/CL/EGcFZm2EqWtQYGSqjsvyKY3Hl4SV57bg6BrwXJBxExCTaXyRl+2Ombpv9jOGhv6WnBiYvBn3efun1mpCivF9KqFXtUfji5/JJR9aFZVomBmhWeYwwFObUW+1qtPDlYHDzI9cxXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On systems with multiple memory-tiers consisting of DRAM and CXL memory,
the OOM killer is not invoked properly.

Here's the command to reproduce:

$ sudo swapoff -a
$ stress-ng --oomable -v --memrate 20 --memrate-bytes 10G \
    --memrate-rd-mbs 1 --memrate-wr-mbs 1

The memory usage is the number of workers specified with the --memrate
option multiplied by the buffer size specified with the --memrate-bytes
option, so please adjust it so that it exceeds the total size of the
installed DRAM and CXL memory.

If swap is disabled, you can usually expect the OOM killer to terminate
the stress-ng process when memory usage approaches the installed memory
size.

However, if multiple memory-tiers exist (multiple
/sys/devices/virtual/memory_tiering/memory_tier<N> directories exist)
and /sys/kernel/mm/numa/demotion_enabled is true, the OOM killer will
not be invoked and the system will become inoperable, regardless of
whether MGLRU is enabled or not.

This issue can be reproduced using NUMA emulation even on systems with
only DRAM.  You can create two-fake memory-tiers by booting a single-node
system with "numa=fake=2 numa_emulation.adistance=576,704" kernel
parameters.

The reason for this issue is that memory allocations do not directly
trigger the oom-killer, assuming that if the target node has an underlying
memory tier, it can always be reclaimed by demotion.

So this change avoids this issue by not attempting to demote if the
underlying node has less free memory than the minimum watermark, and
the oom-killer will be triggered directly from memory allocations.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
v2:
- describe reproducibility with !mglru in the commit log
- removed unnecessary consideration for scan control when checking demotion_nid watermarks

 mm/vmscan.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 76e9864447cc..0362026e66a5 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -356,7 +356,18 @@ static bool can_demote(int nid, struct scan_control *sc,
 		return false;
 
 	/* If demotion node isn't in the cgroup's mems_allowed, fall back */
-	return mem_cgroup_node_allowed(memcg, demotion_nid);
+	if (mem_cgroup_node_allowed(memcg, demotion_nid)) {
+		int z;
+		struct zone *zone;
+		struct pglist_data *pgdat = NODE_DATA(demotion_nid);
+
+		for_each_managed_zone_pgdat(zone, pgdat, z, MAX_NR_ZONES - 1) {
+			if (zone_watermark_ok(zone, 0, min_wmark_pages(zone),
+						ZONE_MOVABLE, 0))
+				return true;
+		}
+	}
+	return false;
 }
 
 static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
-- 
2.43.0


