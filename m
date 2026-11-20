Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22377607634B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E90KtYI3
Received: by kanga.kvack.org (Postfix)
	id 42FD66B05CD; Fri, 20 Nov 2026 13:10:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7166B05CE; Fri, 20 Nov 2026 13:10:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C406B05CF; Fri, 20 Nov 2026 13:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9F9C6B05CD
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C43D1A0153
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:25 +0000 (UTC)
X-FDA: 85456287210.08.E570E2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4A41512000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E90KtYI3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198223;
	b=ylbBAkDa0uBldF3gMFJdBTtbHE7tjWZQowABdw+iFc5HnsV8+wmIbYrSC3v5aMY5iX1UQn
	5PRuvSY1Yd5WZ7XpAvzV6NX0BDoxIUPrT6VABZupSD7L0IWLnGEStnYP9rAVFr9WBxVQeo
	CZMJ7rEQkRIdEE/imvJs9q0kcsuyTHw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198223;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rPWblFMOlUoCwhrsGsfTvXS//TfIn5L5I+BHDpUhjpg=;
	b=36MxIWc9trrRQU/gr0qYVV9ODdwBN2VqF5SK920xaRxNsz8SC19ahqLJmPHdMmwLUJ962R
	fAwKMkYoU6KxBFExg8RIqdP0oGPJQiMHEQLUVDFXQvbB8iDQG24wqYkkLYMIp+XpSaRDWA
	rDj2vhAcQXoyH8p4CQBzlEl8DQF+xe8=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E90KtYI3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DB022633EB;
	Fri, 20 Nov 2026 18:10:22 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198222;
	b=pIadPWhCwDWAADEOfbIb8cgue4Y8KAbtmvUuXt8mnLmdASLxBv59vc2HcZN1wUlez99v
	 C2VyN/DvotU0MLPQK/+ne8FIHCy6rMzUEXJCuMr9pMxBefdRnGlrG+chB+Q6mx+oW7cHb
	 uIVctyFRgar/2z4MTXDzIpaLGbf3xJgQtMuexcOlGQjnqbyhlWRJwDNbasd1wo2ad9RLE
	 NEfOUgo5IgIM/s4sA2o3L142FBj7ZKQevwMurqS9Bfd5llOocoRsYJPXdjAUTDLOL9pBO
	 0VMTHQ30BFJ/opwfnToZUU7W8GRnj0BMgT8p1K24dAkMKZ3NdAQlzeVyjiPAdeUGf7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198222;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=rPWblFMOlUoCwhrsGsfTvXS//TfIn5L5I+BHDpUhjpg=;
	b=QBCGwJLD76+FmvFrdqTAuILVtv+PzqTAvuYTdcjpTPIBZr2RMLjS/PRhT9zRwBahPJhw
	 qpyEvWejbTn7e2u/E07kTfmvLnQeYRciHik4rBGUIxEl5bVVKl1hzmmG+K/Pnvac8ifhL
	 X6rNHE+1N3Q3ME/EUVkVF3xow1ch/2wxw88nSLUd+Pq2NN6mTaApWAPm6b4JO4PXL9ReC
	 cTuITPtudpFmQVEVfX8KZPoOD+PTwNyWcaaOWFf/S0I8NrsVfpvZ1A9zd4+ZQ+0luzz/g
	 px1+2ulLTCFf3yymXdkhxUTWcxAgmzjOgiAwZW0IKYhc4zIaIStm9DYJikQqMXdVOWw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 38A681F01811;
	Fri, 20 Nov 2026 18:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198222;
	bh=rPWblFMOlUoCwhrsGsfTvXS//TfIn5L5I+BHDpUhjpg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=E90KtYI3yZ+38Z/QQLB8KQDYqdzsWQvqN9meUToDcVclmzcJD3nIJCdOyrXSmQyxG
	 yfkGIl3EZiW7LgGkcEh1PpiX/9zHfytgmMt+OHFh9v3nCusCfVOS24fwL888WuuaX+
	 iZvRTJpik7gigQa8xuUk/Gu7rGSPqHNEj24+j4k1bjuc2osq++rKrZaYWn0yKxRu1D
	 TAqLSBofjSI+kMwvD0B9jmOLrbb7M6fh9o4eTxLzrLKySenwgB93T65ZeHfHDKFmxu
	 7jz5h5hC1OQboJmHlT5r7mad+5M4BlevTUXHL/zhZXWlG37zfFFhPLtgE5VndfzKUJ
	 rTr8yb1y0tvyQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 659764B911;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:11 -0500
Subject: [PATCH 20/60] mm/ksm: restrict merging to common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-20-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1590;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=1HskuxEf+1Zhw3YBFVrlQVKDFRcqnw9jX4hWONKblFA=;
 b=KX1ctcadjm/RHab3rq+KPJ8U93Fk/aZfsz1s26MHn6QysyfvDO0bjL2QQSMq3Q+U4X6ZzNMXd
 mEI5+NqYbr6CfPqa/Ro1yHh+HAbQ9NETS1e/yCFhGps0epW+mqx8JOq
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A41512000A
X-Stat-Signature: 1hkbfsfaj7na9ueps6cuyt36n4exnct4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795198223-799375
X-HE-Meta: U2FsdGVkX1/i47Jl2gpfdRCINuUa+8ky8FxVX5L/ZpDpP5/j/u+1dqk/dq9ATd9qJZblpTQROahwlgPl+1wm8NJ859gAfiStFjZEXGANTz4IJOqeYmnjNLRnvNzkVpE98QizxOAT35Mj0dfMK+e+FZrSKcYFdYCIOj/wzn5uPxa3Gj1rdZ/8kuVKP0oH8Hg0TJiYtnvg+nWEE9s5nHlnT1GnWN+tWg4YplqMrSNG1hZ4RCpzWc1mTFS2x2xXzuG5laudlak9N1f55pe17FsHxt80nCn/WL1cmnzDCCFpMDmr7+h82F7NpyWqoZaxQYI1sym8EraRHDQETbrnkVVrAy0kHdejP/ReBbsuEsXVKJExdlRRmQEduhPoL5UaoBmdSTYQjplGs0Hc8fXM6DbWq5g4ju7Ywp+WMQ+U5ZeJ+Slh3lormmj9JqkSH6zH1Z/yC4yhHFOcjTaPw3XB5Vq3Dz/8A/pFLtmCZkNL2ADRdMx2sslcKW5v4SAoacaFIaWJQYdS3rJJSFsChk5yu5ANLU1ozXdkqSE31yTZ4ArOcGHWEfBgKVHXu3HLq5YhD2+BtSqlBw+bP+bIfpwyVTj5dLli0WAe93z66Gx/4WirOVYFmjpgFdnPrtr6Dr9BFUwbgfAyNhd4C8zgCoBWadDBPeevkRbpFzVJJyFvvUESK/WLdcnXLQeMy7NsxXk0Bc2NDy0/HxX6I/bN+r7kq+MicdAv1HfB/wYF5TE4SqFW1xkF2UZEoF7Nzs55SFvThp5ci8E7N79bak6b/ufMFR5K97aCg21jhOaucjwHKR5f6GU099XJzlftfuNwOaPi2TPS8G9FL7aq0a1t6aK5KcyC2qLMRXonxDIB4Twpr20rszUBZ2qEscaZW7Y/oam4QQDu6xS3IpFT4Lcdlwg5stMPoSTHRwUC39QyFMZ2gBcOQHviGgGzoQ/dwSFimlbhMWMeGZzYfv/lJlpwxoqSa0P
 k5lnCqW6
 2CkklYJ9ewM5Fm7YuGDPpylzQtjOz9urLkEeWsmlUrPqO0VdKugjdOpvxBDbErATo/ToLxHUYGUpFBEUy2KMN4kcFM5AiDCkTctPME4D6j88/xpAmutYj3jKCtNnqzD9Lk5WLKcorh2UjRAeSM5DAIr4oJHlj1vwoePEU2AT+wLs5CxONLuQ3gS5e1BzB82B85T46ZcvGyYiSDWO0Od0B4X6/HlQkCuozbBue3stR5fP9CiD/XOZZ6nSJwoC/c4o1OkZ8M9WoqHsdrH8xKjZ33G7OkSyesS/FlOEkLgYR9wQZJ+EBZPZ4kzEb1VI9fdhmV7RZdbt9ZJPzhv25BbHjGjUrJfFe+tr3a6wjUcimeizuYA4egdBgI2VzSH53df8p4BaFfLj22iIU00xnchqtCxaUQwgHrJNIbdPTcOADwL0JLZZGZh0zaypbdDlEoVUx3ductERGrk3Lu7SJfbECBcR6UxTxh0UCkFheG2up49OuyOTutHkVQ79YHZi/WTaVxyIfIh+7D8qjWJ8YX9kblx8X4HqEUknfXvahrib5yQQOwSFbT0uKIRkKohtL6UQOoC4aLYQlxry1QxsHy5E8xYmuCtqdMHRorXUA1d9CWRSXYFoUfShmfYS9eGj0TY5X7K+IEVysXxf8XfTVvzgI5tFr7zWIHf/3E+e96o2Vkcn0LpXahFI6ocyISBCCtnwVVPuTli18PSwE9ZBgxtduBgBX89Jl2Vk/yvEtgBCnLjGc+Lecc13ga0o1gTS80ZdhhH0Oorh75rLIAGA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

KSM is an opportunistic MM service and should leave memory outside
the ordinary memory pool alone - as it already does for ZONE_DEVICE
folios where its scan picks up candidate pages.

Use folio_is_common_memory() at those same sites, which still rejects
ZONE_DEVICE folios.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/ksm.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 623a2cdb3924..25b2c2f94486 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -831,7 +831,7 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 
 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
-		if (!folio_is_zone_device(folio) &&
+		if (folio_is_common_memory(folio) &&
 		    folio_test_anon(folio)) {
 			folio_get(folio);
 			page = fw.page;
@@ -2571,7 +2571,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 				goto not_found_unlock;
 			folio = page_folio(page);
 
-			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			if (!folio_is_common_memory(folio) ||
+			    !folio_test_anon(folio))
 				goto not_found_unlock;
 
 			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
@@ -2595,7 +2596,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 			continue;
 		folio = page_folio(page);
 
-		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		if (!folio_is_common_memory(folio) ||
+		    !folio_test_anon(folio))
 			continue;
 		goto found_unlock;
 	}

-- 
2.56.1



