Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C769C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0836B009B; Thu,  3 Sep 2026 08:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87C06B009D; Thu,  3 Sep 2026 08:21:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9ECE6B009E; Thu,  3 Sep 2026 08:21:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6883F6B009B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:21:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFEA8804C1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:21:56 +0000 (UTC)
X-FDA: 85172362632.07.4BD5642
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 335FF1C0002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:21:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iPg3NOmV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788438114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wCVi0RPQ/1w5scAtdtuQVBMayOKGUht0GU0fLrik4o=;
	b=ofk0EPpFhbq93AlsRmQLgtz2BM6u/NUdtI3wgNuJR17b/IIiPkv2LQa3xj2V2zvrydlJ1S
	YaygFJi7ZRTHbx3HNyTt8RPB7ogNtIyz0VkgoJcCaxvQTgP7fAgDHp+mtZbBK2PkoE5vur
	8HyY0lbfoJ4QXbGPyDXpp6Ugx+1fmHc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=iPg3NOmV;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf20.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788438114;
	b=ypouAkvPxljNbE04wg/KiBt/lm2TlUYHWrQeec+0nJu/K2fmzafHAObM7ixUWuQjJmmmH3
	NRi3Y/q5/JOAIzHE/od1u7hV26mnulqToaE1J3Vuhig9udOHJY9MTEgKuAbiLww0TNJpVI
	KnN6bi4ZdcoxShRpqdC7txDl2aO4e7A=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-853c07a76adso2679775b3a.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788438113; x=1789042913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8wCVi0RPQ/1w5scAtdtuQVBMayOKGUht0GU0fLrik4o=;
        b=iPg3NOmVX/+tMiimK9cYEejCGHVuD8Wk56IKyEUxcFxKG3kM7V+3VnxMHzYnphQi3F
         mtBu5gC+8CdsuSSW0FbsF8LCc/sOPLQx5R6quPytxNy6JAdMmalAtVcY0jRMj+lW8V2J
         QNJaLQj+S5dpCdW2A1huzoymkXxuu1IoYl2UmMFOQ38hYxQUY5fq1UlcNeUwxMChUpOl
         rgDhHHSIuKe7MHuf6jVwwMyYhb0p41R6RMaFUPJEDjjOMfMZPcSQgcwiSHcVF3fit6pN
         d82879vM/V7HFNKff5zYvbO44boTcALPzPjpZY8j3arsBDgd+ou50E3ezdPw0kDoIsKx
         U+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788438113; x=1789042913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8wCVi0RPQ/1w5scAtdtuQVBMayOKGUht0GU0fLrik4o=;
        b=Zy6KEcRMk2Saze9+ObzbtuYZAzEPT+y1PgN90BSkdq1eiIlouXxqbx0ZU1EwVHJVwp
         L2xLgHSykmXdvtyeJcgZLpQVZ7xLvDzq/mLNyuV+wjfTFVpvZPOEDelILMl115MNWFSs
         GdWn2oaoAwyG2MAEWjvjsnxHDxgVMRPmhLYaTkymcbyCTFJhEa784W74UqqvovBiL+yc
         LQjap/qeghVzADv+Vq4aVXRxCgTZnLr/n3wbKvKaPiX2aq2UmnEJQ64UeVc2S+hP872D
         WKFtGbVZ+2MPueeUY72WwuWLxlzqP5rmlG3jmZp7LIWMQ3vj7ZmpNJ3oQWxn+IwcJHt5
         3uDw==
X-Gm-Message-State: AFuF++llc9uG62K071whPnVyXE3Vk6S9a1+m3p2DsWuH7C9/st7nlIwm
	o4YocVunavsg/1iXIo1dxGZ8/MnP4HG0wQd7Lhx0QDPP45lneI+xTH6nLzm0Zea7SWc=
X-Gm-Gg: AYBFou2VZ+1a6BtAYJ2ThyeDw7yv0SKvgumUss6ClFehlJtzbM/YGCOs9/8d+8mZ5Qg
	y0VHTxC+mj7jp5e11bwRWkhE0PYRzejFB16axI4qDzg497yvalulOECuz2+dkMpCy0m9OduJUFh
	vMdWs0XT3ao364Vg2dvcuReW5d16IRKFfMaLeaFqhaDvRNia/3p6JgIysmA1+h61/sHCUFQ4qJz
	VRMzW+v4uD4EHI7KPDJzpVn9MBsS4OKABFl7B10ND0IQMRpAElrS2NriBJoKE+KvfS5lVp26raA
	qI4/+Pt1uBM4RimrXPfOt78S+qQuBJwyxd1QzRH9M7e6FtvYOkFe8KvN8JO2tZSW4iIvJhE/Qf6
	GhDjKOb2Hiod5Hmj8in3qaee4B6I4+fdqD2TrjkvcEP0sZLknUI7WCIB72SY5m8hD9vGYdcUxHM
	6dTc2An8v84HEIDf7eDUkjBe1iOdQBKpYQ4mnFDO+BiMugwTsN8vTYBiwPbP5PWoPO61KtqKhoO
	gVwK7kDcouzHo1yVrbuBlADNA==
X-Received: by 2002:a05:6a00:e8f:b0:857:72f8:dc91 with SMTP id d2e1a72fcca58-85ed850a6d7mr17640794b3a.18.1788438112769;
        Thu, 03 Sep 2026 05:21:52 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.13])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-85db24f2076sm2868126b3a.4.2026.09.03.05.21.48
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Sep 2026 05:21:52 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean pages
Date: Thu,  3 Sep 2026 20:21:25 +0800
Message-ID: <20260903122128.12264-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260903122128.12264-1-songmuchun@bytedance.com>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jzy9nkf8ksxgpcpfmxa4zpsbjfsr7iqo
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 335FF1C0002
X-Rspam-User: 
X-HE-Tag: 1788438114-638253
X-HE-Meta: U2FsdGVkX1/CSuIBEV0clY9F1+AaFxPnSuqD0z2kDIPEw6A5e4LSBv4tE+Xn1bKHoxT/o1vwfty+UWNsaTtNm0iC06vU1NR/AXBaA/Bk/SVNLRkxZgquCUakOP8rGVrcm6BTP9z9virithHmunI2Wcs2TzhTr0ZHIINBubkJfw5bSx0pFYb11WGs53hxuiIUBFIwU42QiTY6kZWWCEFqu8kzBElfJkKCiaite7j6htakrlt504HBsNc6Yh7uMb7r4WToK0fpp7ZUAE9HUIqD2b2w5D3g7HgkLUlioARYInfpZLe4x9Y5AmwlvEEv4oNQW14D+c4a0Tw0FQp3abkOYS/N4h6a8cOCKht1MxVVRzQPtv/A/f50/I4+5cvktJRRpKDSK/FyaVnVZfoCeCD6EXekz9ecN1WTLUvL88pZIojNfXvsCG4iGDZkgXY7l9XM7wjtikHzHUCfr5tqUtZE52kRxo0mN2UyIPlGD5hNb4cfFGOevCE797XXH+zYbrUpPGzph+naNewFBL/Rom08Af5GZqT4USYjdkYQ5N3yHIG6G9JNiOCPoa4BOAlcBx2kZeeOJFcogNUBR5kDXcbz5q9tADUojhPTw2D3+E4rgBofQ3yzrIIR4o6pTBRNErpu6hi2GZigiqbSetKsRfnv/IzbwJTB6EDJgvCRi6lfuoIrCq4XXhTkaMQJk0MQC+jJGvwVYFubvXoMztH/z1fpiUYVcZ6pMcSQOlvITyVQ/DEJZhtkALbVDaV6ocgWsGKT0wh50aNkP46IYY4DXlgFyYjIy2GKKtuyHmfyZC0UXqx12Vyh9F6CvyN+lUE7HIjve/E44OepHedhzy6tSWCCugrl9ztcUROMlEWV2+mMPMJsCyS8LX/PqLAhoGgE2SoHFB09HMmGCa+t4QvWe0bagVvyDqkqe+h+X7aDvB8BZmlETtY7FPtai/hxeepLO/eD1fFcnDRi6DF8Lnx66wS
 c8NO4FxF
 RmAS9fYBZ+lxKHvlp/HiFKQi/iKDxZ2g7FcAcQytZ7VXbKwTdxpd7xKgtq2m5HDt9KjuYOkEnwO96+6M2A5xhnsOr1VCI08OekGRIoaOR4EkbQ9tsdUIHgkzKEhLv9HqQZ8jdUSOQh79G44uAmOUuMkqpbvfzp/co2zGpn9GVaXG+B8kUSKDms3nAcYsGOKBjrM/dkuD5W6ddddEmMkdGY6CBQzhYARHTuzpwHkjFovveAv+DZcjW8mo06dIkXyAHvPmoIln5H+ovXmYzzNPqUXt2AgGRo++ev4R7NgF8e8i+05ukwQOqNi+tpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pmem_mkpage_present() is called after persistent-memory poison has been
cleared. It only needs to clear PG_hwpoison and undo the MCE nospec state
for PFNs that are still marked poisoned.

For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, but it
still performs an atomic clear operation against struct page flags. That is
unnecessary today and conflicts with the FS-DAX vmemmap optimization added
later in the series, where clean PFNs may be backed by shared read-only
metadata.

Check PageHWPoison() first so only poisoned PFNs update the page state.
Poison recovery keeps the same behavior, while clean PFNs no longer require
writable per-PFN metadata.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/nvdimm/pmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 30a51c365ce8..b14f75daeda7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -80,7 +80,7 @@ static void pmem_mkpage_present(struct pmem_device *pmem, phys_addr_t offset,
 		 * here since we're in the driver I/O path and
 		 * outstanding I/O requests pin the dev_pagemap.
 		 */
-		if (test_and_clear_pmem_poison(page))
+		if (PageHWPoison(page) && test_and_clear_pmem_poison(page))
 			clear_mce_nospec(pfn);
 	}
 }
-- 
2.54.0


