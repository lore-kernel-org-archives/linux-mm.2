Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4331060721D7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KYnE6AUe
Received: by kanga.kvack.org (Postfix)
	id 0AD8C6B05C4; Fri, 20 Nov 2026 13:10:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 036DE6B05C5; Fri, 20 Nov 2026 13:10:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1E116B05C6; Fri, 20 Nov 2026 13:10:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB3DD6B05C4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50B001A0156
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:09 +0000 (UTC)
X-FDA: 85456286538.07.3A36CD0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2A13D80006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYnE6AUe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198207;
	b=ncDs+Q1KfWn/lq/gtcyWwZcVa0cjikTxj1ypz5mMCDDXVhzPwm7wWvZ2KGpEmE0KQsKMsZ
	UxUU55fezgUScqI2NOiAy2Sqp5GXH77SGHt0s/CahX1Ei8jOfzWNeI89bJ4Ved8lEVUTsN
	uCgQsYAuUkIcwtqIVfN8CjJpIabAah8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198207;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBVDrIkZhM4Nb0FLnM6t7I85jx1pyyYz9Vpq72X6eKI=;
	b=IH+w3aU6pnLxvxrCohEHDaLh3gWbLTUTD+5Tj1bRz/sKhalF7tnfJxBXT/aO2VnOVL8R+y
	D5hFTr22bAxFatJOIvAnMRdTN9XqbhntPw61MhD7BBuyGSWUUwp30fzREYwEL5yru1AyUf
	FsIEHDOg7tdWNtJEM9st4KJmX85BvLc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KYnE6AUe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F1B7246CD0;
	Fri, 20 Nov 2026 18:10:05 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198205;
	b=Ffa4EHwRkuLFJhWBCjpiLmW11iHcno0AfT8MLAoqBbGPsSlFdyLIhx9XrX99va6bybT6
	 GK7EsQu2YMNHuSjsmB7Bv+tWYsPSRKZx+K11osUF155eL5WqxA1aadkbOYqK3HPdayUel
	 j+AHDPoFmCjZx0n15PuHwGxwepqfEPloswAC4rKrLK0EWHr/ONlvQP4WXtJYtKQ+kv0/y
	 w79daY8T4CcG7Rb66iziVaX4kl+mvSUga11z777mB+L5Stz4tNpOnlpzOn8gY7cYSuPJi
	 xB98UN4UgKIx/mjMEkbEgLfVG7TPRt/bY/su6Yvki0M98iJwbxE9Vd2vjtnhZt1dB+g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198205;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=EBVDrIkZhM4Nb0FLnM6t7I85jx1pyyYz9Vpq72X6eKI=;
	b=wgDxk3ODRi52DRlOdso8JdMY6sw00Wvm9irwKCahsai5flfVMUIxd6sKfqzh0LmBh9Ad
	 tyt8lYkaC3hmGIYExsLTEG/gx+QAyR3uDGmjJrm/dJiz5Jw7/ymkGe/DgtN21SmkO+ZTE
	 60dsDsAmyU6KYElCgWpwgcMWA+w/SuEYCzM8o3h1geSjjBEUNNor8WDYnjbT1+i5jPyun
	 h561fHVgiW1uwmEE36AYFkMIC1Kad50ij621kdxh53NaVt/slZ7W4fRMAYHkv0SBDOjuT
	 eCQlcujsnFHK3QXWbkFB7mskaVJFmXwkywSps7NnTqabRLTQM5HUE2P3X6B6XLuEtJQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3D0A71F0093E;
	Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198205;
	bh=EBVDrIkZhM4Nb0FLnM6t7I85jx1pyyYz9Vpq72X6eKI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KYnE6AUeMDLuhG32iXhQk9bTXjKZgwS9tdSN5WPQyRFt71hklK2sKCCUIWQLFyECO
	 JWf/V861ORTG5Xf6XM38M8qHDMfQjJtWu2jViNCmE5GdojapJt2jhQ9CaD9hopXarp
	 WGg9o84blY33w1fdMo8NduUTDnw11yxVuMxyAXI4xVX9H0yoOkXaIMXGEW/m4TST87
	 FRvqF5PpQl87gWwMfCZMptEP0ttY7Y55MYkxYxYIDuS1LreDLyPgOijorrKmqfyeKt
	 Ia/9dztCMkSHF35ETvXRkaCOvrxF+H2nHYUnbGE9swTZ70u2fhmzVH4F8eIO9/Lm8w
	 FIU5Py44J4sTw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4D7494B8ED;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:02 -0500
Subject: [PATCH 11/60] fork: check cached stack locality only on common
 memory nodes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-11-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1024;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=FFFpqhBLc8gM/DlQGaqjHX/JHYwyjj4bi22co9/B61M=;
 b=rO3nC+tuGAUkZK+up/1r/p+QOF9uTflwwwI5VKLdkKL6Sn+VumAtsjX3b0agV4OanZqd598EQ
 09gpdfrfuhCCZcNNEYTDTQ0+HvWE+lv0vLlhX9nLj+fGFDMFKeEbBl2
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
X-Rspamd-Queue-Id: 2A13D80006
X-Stat-Signature: egjx1hiye6uzguqa1cedthijciqefzc3
X-HE-Tag: 1795198206-554740
X-HE-Meta: U2FsdGVkX19KOqbZfgipTldJMp+heKC2wwuj7b6rK0mS4j32QlbWxxYF/Zd77N1F1SbENrbec6fmCjfsW7lJkgtayq8CdRBSLksKMmS73+fz21fpKQimsgrKrBxGvD9Auc5q+c1VO8Eca8gbZX8FN3H6wj6otuwesSAp/x1OMBzvZJB+/jDFonYFIHEY2kemv6hzC4jqDSM6UN6irBV577J7fzvWarABLQlFkzLAtiAfYaauNljGmJ0pSRpGqqQTvdjrbMDRJwyP4qK9y12M079rnHEEiPHlK8Te2c6XYecw5hLqGtFwb9n8En4R5EY9BPP3MNsJBa5oMJWB/hjca6KtqTKQL6gE/Yolj0BcbpRKUhQAa7RI+fW9TiK5brvQK1/QsXwgQr3/jNHw4pb+0h5f0dhg7QjX6LZ2lGrtAbBYta7mVNZ0cqO+Jp/AOvw1HTHDP+4wXHU7rFQh+6/Q7EqXKKnmHBxE0Pk98LLtajerQEfa5kkdrnnh8sG40VyjEqftbtklsBQZn3ozXjE3TpFBjnMUaIgZ3MwscxqFU1n6h/6RP9PAK7KyEh33l+mm8g6dPP6qPXsp8fZONGuzXumv1lFV7Ji9xH+vhx2DvwcKUboiqyjoS6pHTutA7tRJoVYTHlwjPId2ZSRmivNMqsaajpzKTYl9TiSlWPt/p7opMDNM7vc/kZmgOT/UAvLQla1QNubcUUDLtEZltCn0OwnHq/fRHM2MxxnzMVr+mVCFXL8N9ivINyB7rc/oyqKZ8CTda99lix+JBbI5ACcvmKtGgUGCS4PUcjjVreqNIMI7iCVMtUoIev6NYNaDB0PpOvWnL/YsBjRKbmZh8oqQT2ge1Yrah0tLVQ9hxwMrMI+jkgVYCdj2X/QcXk2lXUS1f/iMnUJa8pSnSF3DDVRyhS9bu6noe5jbV3p1gj173X/z5rDTHFfONMsPXAT2G+2Uy5w0ocBqAVftCBV1lbp
 yvzyQjoF
 kuDxBgk0Kit/TlaiLGGesgMpeLeYZRB8579ix1g775sEj1D0VvgW4adZ1KKBcaPVajFz5DDI9UWF5mNBggyFgEoFmHDZ2vzjeeCy2+o9MoU02v4puvrcOfKoWwL+uuv2QegMzPkJXh3zDfbrfNvH/6EOayLGR/aHCzUVoIsQujMWny266e5vbX/qXAiWtlcxjZRt8gFNfkUkNq8rRCwQf93Cabn6ahdz3iEEpSuOxGeXNraututd9U+vMQOg11Bt2dtEsOTHmixUg/WZktBIamJnT7XQt/753IJIuFlPaWQQ3Ue8i0g/4j1vwPn4HeiJU2AXmbMjh1ryfoZOmkivw+dclYGSw8pCZDVn/fwiDeeNz3DUp+tXInk1RPZ4iNvQuhRyjj5Gs/8GtlwRHMPVTwczdDVaLhU+y5zc7plTVV2Jb9GKm+47OwBrNDfXqBJsFi/N6eQqtB7wicuqHvqCldr6rQ5aIvjTqVCVhYn0oqRMGEEXTH2Uosjjllv/0awv4PmMvf8a6V8h+GGfpk1PcdhIlcHUGIIhVlRs1/EKYcizg3d99+9P8G+wd+8Y5NIizUn+5N+08UdG70rjHPz2J4I1ovQ0T+xlwYUSkxYDcdb1iKZxWqQMgFyIvfg1w+Z3a2LeoK2/6pOr4yKTax+pugsgJJvdRuURsrDQmxPgkMQQ3BIGf2KcQSgovJacqYLwISsjF5J22GUggiUn6Kgaj10bqpLidG9BZdkijTihkmRwV+a/urckekR7eevipdHoUj9kyKPtpFA+fcBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

try_release_thread_stack_to_cache() caches a freed stack only if all of
its pages are on the local node, unless the local node has no memory.

A CPU on a node outside N_MEMORY_COMMON gets its stacks from other
nodes, as a CPU on a memoryless node does, so the locality check would
keep it from ever caching a stack.

Skip the check when the local node has no common memory.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/fork.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..28c58f2765f7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -254,7 +254,7 @@ static bool try_release_thread_stack_to_cache(struct vm_struct *vm_area)
 	 */
 	scoped_guard(preempt) {
 		nid = numa_node_id();
-		if (node_state(nid, N_MEMORY)) {
+		if (node_state(nid, N_MEMORY_COMMON)) {
 			for (i = 0; i < vm_area->nr_pages; i++) {
 				struct page *page = vm_area->pages[i];
 				if (page_to_nid(page) != nid)

-- 
2.56.1



