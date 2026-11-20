Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1412606BDDF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o2VqE9HQ
Received: by kanga.kvack.org (Postfix)
	id 05FFD6B05D5; Fri, 20 Nov 2026 13:10:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010436B05D6; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2B36B05D7; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A54F46B05D5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38B38160139
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:31 +0000 (UTC)
X-FDA: 85456287462.01.C72F7EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1DD85180006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2VqE9HQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf24.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198229;
	b=pdz5COG04tz3Hf9iGxyK6je2ih7Y0EoOscBCFzPLDCFWt9FKUkIKez3XDMAOOg8M1LDOX8
	2kkXrGL10EgyfikTSycBqir7i1Vpr6jFQube30I3TyO+L+1HxiX76wvmyL66N7zqHecWSR
	nt9nKVsNJO8/HgZ+2+3p4vmiQecHD1w=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198229;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MYei4KuJf+QfbxwWuL97G2Caql6yWhkkwRbrkOuMiXs=;
	b=pOagBoLRUGc98EL/DV42QCiEJ1XxchvNYC4rXavTrjbY1tbAvgp77MQol/bBcFwuVfiN/9
	tZbHPOrAJamhhnp6oIJd5bsir7EdDaQKvhUQYj4ZQAOJlFsQZD/xysacviTccs2iEBgid0
	1hpwzeDlYDKUg6X84rg5VZC8IQ1emZ0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o2VqE9HQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf24.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C0C3414F7;
	Fri, 20 Nov 2026 18:10:28 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198228;
	b=vEStu+6XPuVUSEgha/bPJPPhZaQjviuKs96+dCX/6okpXf4EtLZJiM1vslyGHue223Ws
	 PpZIicYNPAF+9WRDrIpHQBVvzT2pm0TvasQVVU8FU00ETWReqUZcxmTmseqGx78axnNU4
	 qUNrX+73aqzv7ULR0XwRAWYYOpSwpvCaYeVDa/Bk/bAonzlF2STVDEydTjdaLHFdl7SRC
	 lQe+6TtYtCVoGDSzf3AXO38oUKxEuUvDykMRusTlrfVs2nH0MKv5BdoXv9DjjoLlpV018
	 eXQXn6VIlcVnpVGDxm1+7TO80HCwsU+8CITb3+PnzFgG/SsaJZlpGK2WJK3Dq/us2Dw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198228;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=MYei4KuJf+QfbxwWuL97G2Caql6yWhkkwRbrkOuMiXs=;
	b=tlPRcLEkNO/vMCwHkaRkZJxWo/JMXbocux82NJN9dzkghGe1POzsjAKEkB/jTnCTbdw1
	 A5/cgh6v0wRJzLLCZQ6dONpO/2E9VPSkE1fZdTS80vU7IoMt6kKQ/KWqbucv65/Kp1lv0
	 2tU8YVTgG4sd1/iSN+U5sHPTJWR+xtZmWQDZMCH0umUQcPTGR22gXiKuKB9t0muGF+3vz
	 NEoasY+EHcCIKTZDIF0XsyEbcKgCRit/xfgU0dtOKLi+c5LLZRU6haV8rkX3rCFRcv3yP
	 ipDCVpqcoq0P6ngaxMeLziGpja0Bv7LLg1Ug03zfdZuZWjMd8jyvbmYGB2Y4+p5Uh8g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BE0CF1F01809;
	Fri, 20 Nov 2026 18:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198228;
	bh=MYei4KuJf+QfbxwWuL97G2Caql6yWhkkwRbrkOuMiXs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=o2VqE9HQTCwoFkUgN8u5WYrKRmAIVMTjRgZZUpSnTAXPHHgK84iZNDAnBbOBL8Cyi
	 c701hXCiecVCF08Th5I5KwGplHOXxf6IIJnDERrTiGj1qezLMuLE58vNjtr9Jpc9Xq
	 0P3dVFj2AAJGSv4mopGj44HT09TjJkIsXW6C98+vmF4wELWyGzZhelgJ36iLSPx16/
	 l7nYcpNnynBtqr+h/EpQ0iLZ7DjIPsp9YEkLYH5P4UxfQ2t6Fvy73F6awuWo13LHnR
	 edXZbKnO2MgYqgIWPkeD4RzpukPaMTd3eh7epFm6hoZaSZrdGDi0VYid3KktHzNCiQ
	 UG+/n9ilDPm/g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 82FDE4B915;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:12 -0500
Subject: [PATCH 21/60] mm/khugepaged: restrict collapse to common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-21-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=2345;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=ZHvwrgi2a6sCoho/O0VKGbyW17jDoPTBbXNa5AUwPa0=;
 b=TQS2bHGS+OuUEC48m/xNSWijxkvjbzhLZJ7z4ADh21pF7ZIpFCDog9ykVjustle3i7kJOVUnm
 Ml0Xe8rxuVDB0u52WP6/DVBClG54gRk4+r9fp5F4BpeiiOAJlZfj2pv
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1DD85180006
X-Stat-Signature: i57fhy4qrskqrekg9on4mbbjqo4w8u5n
X-HE-Tag: 1795198228-209145
X-HE-Meta: U2FsdGVkX1+s3zSZl5+cPXGDQjW359V3XF8mtsVwUGK6WEFzX7cdAMclkBUrAwUNEydPi8d73eVTiTUOdnVEOnpH34Nil/Q17F7SF992EdwSmxLR2lygw6yNBQaCXIHdBNqof/TdooU9r/HVwmis/G3yopwbOf9i5eiHWBNKHrA8y9GBNvdOG4M2XNXRNHQRwvIVSLg1zrwYAyWpheXNDc/fur3UQ3glWVQaTtlUXx78oktm7fNFkjgxcp2kIuL6eCDewoLPLN75KiBeUeEaITeJtwO5bKIuf+LnqlOiI4Ip6X3l3kQy6+Hdy4lejF3HxxmGxzn0c8DDSI8rc7IanjNLvzsDWfmDk6x7npVx7+n/otmGfBbU0KtgGHi42nYzkCyw5Bwbg+aqPXRArbuQ74koOM9hYE0PyAT7bredoBL8jTj9UHCksRqYggvmQw3zR8dG7ur6ddVU3o6v7eCsmQNq88BbxXk4fo9A+/joGd5ecpIgHChzrB4FTLn5NvezLeeAu/xLBGWhXy6qCv2kaejTwC+4S3X826f4lqjHFTXmGvQfhvz5iulnQipiU+evfMSx++cEBGL+pbVTgoF4t6ZSoPwe/vzvptCZjhUwnsOWXr+ZxlRor0KBYAgXBQxPDmgoD18KPTkU6WngxoRqlufclom30JZdjKaCxbMRHBK/tqg62App244flV8bk1qN3pPIeskG2jcuXGeveuM0lPkk/3IhuNMSjcWTnIiRTR79nsqFrECT6df/b1uOZ5sGLhOZq9zwC4AVCWSWOJvlIZY3zkf24u8zze4+f1CUuTBp47wK989foZbD1jjFXHDjgnoohYlkGXf9qJb25hQ6r6TawEMzlsLisXdXtp/di1Ef6XRavZQwofDDK2XxB1GZ9N5rnvUIK4eLbKkypmBRjN/0z3fthTsvKtLmUMmVS3gME50Qo0zhJOEmqbFuT9duNTl0bfj5fYPJEXN5f+6
 P+yHpR0F
 X8bLeqZN9sz50DuMH4aWs1pHJ7fev/PabuHaCLElVS6i1j+fhGaCGTnQcwhzUYQ9BQtojZEYDXxYSFA49OB7K+J6YzAaeH3pN/rwLuA7zne6YiD2kYeLg0wGnXraZsnFmZ2XrpKndCWsQ3JnP0IBYri7R6/zALjyy1VrSzcPwiqmx4e8JJnxxlLLKKsNU7eUj7hRT9NP3Afpk4kAU/tFLMG0h3sx4UO+6gYnD8OUKOp0JkPLLVjsuuWG7sBtwLkpoGdVCYOnAwJZ9/PqlS2mAgR8mzreIGbHAt7CdgGZkr8TJPCwdloaPxhp+sSKK0CNo9qlsSoXWnxgxHbS4El0mh/3buw0ave3/cHw16p8jlX8RBR97YGOmUcyj1oOEbWWT6WA9mww+MlzNUTLzDmpv5uw35OH7BFx6FNmN8rZMxlAN5NtCL4kzXfpKK/Ite3xgQntlIa3OFa9VHoZBfQD7wjlUDA0WYHqmDEik5wZeNRLKxB4AylRSwlaazA5CHRN6fw9Syy/Wmq8KkHgbA4A2QgBwnUrED4lI0ZiYo8060IISmI1eiVxvkB9TFGMd6aUARg/ro03iY/w67mJfMm7GWbHX5ZxJjPncoLSAbWDUp1exj/TCfM0MejYFiSeeCm6urbe3jytXEUdg/+XN4mdjbU1oQByVXtQGKjVJZm9A1kKi4hhnpwPCqQuVbvdZ9751Jo4XlXnfN3NndXimohjCYNHC2itth+d7O1m1sqaTKnL8V142iNkSXsD9rmC11xdTmRuYo2rXKaxI8YY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Collapse is an opportunistic MM service and should operate only on
common memory. The anonymous scan and isolation paths already filter
zone device for the same reason.

Replace the zone_device check with page_is_common_memory().

collapse_scan_file() gains a folio_is_common_memory() check. Page-cache
folios are never ZONE_DEVICE, so there it only filters memory outside
N_MEMORY_COMMON.

collapse_file() rechecks once each folio is locked, since a folio can be
added or migrated after collapse_scan_file() looked at it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/khugepaged.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a930d99f89da..b1c6bb95a936 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -628,7 +628,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(!page_is_common_memory(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1673,7 +1673,7 @@ static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(!page_is_common_memory(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -2397,6 +2397,12 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			goto out_unlock;
 		}
 
+		/* A folio may have been added or migrated since the scan. */
+		if (unlikely(!folio_is_common_memory(folio))) {
+			result = SCAN_PAGE_NULL;
+			goto out_unlock;
+		}
+
 		if (!is_shmem && (folio_test_dirty(folio) ||
 				  folio_test_writeback(folio))) {
 			/*
@@ -2737,6 +2743,13 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			continue;
 		}
 
+		if (unlikely(!folio_is_common_memory(folio))) {
+			result = SCAN_PAGE_NULL;
+			failed_pfn = folio_pfn(folio);
+			folio_put(folio);
+			break;
+		}
+
 		if (is_pmd_order(folio_order(folio))) {
 			result = SCAN_PTE_MAPPED_HUGEPAGE;
 			failed_pfn = folio_pfn(folio);

-- 
2.56.1



