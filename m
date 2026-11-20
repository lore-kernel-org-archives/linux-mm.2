Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C39B606C9AD
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gxx+6zL6
Received: by kanga.kvack.org (Postfix)
	id B0E9B6B05DC; Fri, 20 Nov 2026 13:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFB36B05DD; Fri, 20 Nov 2026 13:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95FD96B05DE; Fri, 20 Nov 2026 13:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 610A26B05DC
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DE25A16013A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:43 +0000 (UTC)
X-FDA: 85456287966.12.F465C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3FEF8000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gxx+6zL6;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198241;
	b=AhLGB1tPE9+bUCDHbMYsmMg0J2vJ0mtyJPOYT3uzLXeAHp8RfJzQsSIxsP4+u6nVwMb/8v
	Hw+aSVUwGsqmXH9G10TmiUTQAWKRVJ4jUal7cM+0WC1R+qTZD1FDaHEhKEDNyqG7+B2QO8
	g2VQWQKkuglMXuT53uziv546veX1k68=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198241;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3FUmtjIsJ3ZmK7E+kLLMrGlNYlg2V4C2I56CXtFzz5U=;
	b=pISAkoa0gRvWJTyo/FXbI48c7FIN0Vem7MEpMFe3izAcBK2090fOZBLBAvUxZli4gKy2by
	KB4MEpPZ9ILRGEa/2Q+NQZGLZMEMNjZ3q7NLpIOTbp/KQVB/0rfD6P1Vr5jpFT2maQAcjk
	DAl95a83WcjdRz7n1O1eOUo+Hv3XRzA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gxx+6zL6;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55BC6633FB;
	Fri, 20 Nov 2026 18:10:41 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198240;
	b=G4tca0A8FQ2szsjtojlN4RHsNuniMtEVznQsRKGnnnjHl/Ldjin40v0cYQwcTJmopGDI
	 PRKKSVRDAdZ3HRyjW1wOx1XfNXs4PudHsZMuXtIlp46ewznlJuDugYU1aV45v6ZJEEcJL
	 pMxJasrFAajW7OLzConhB4zxoP8uJkhy0DG49wm8I6Qgozghpo4RQtAne7K/1BwIZ9nKR
	 J35vW5yAqRoi2mGHjicvEA+mBpjTdDygfQ8hg3t3IB02KybmxisCSaDOTgY6WTx4tMJY7
	 sBDiX8S58Pku5/ZS1HpgTV4Hm5WYPEAi1LCKGKOdTFHAxMXyYctFr9R7/kz+w9M8JoQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198240;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=3FUmtjIsJ3ZmK7E+kLLMrGlNYlg2V4C2I56CXtFzz5U=;
	b=KfHXC9uHW5vX4JODjk+nPnI57o+fPcSdr5Vf7waez+Xr9jH6s4BWKX9WKzuKRhS9wfaQ
	 mQmjSJ8AGYDxA3HFk9ztXROeK4dMl6eqbDseaz93xtr5oaLrC1APQSC8OfBE2IYJjL++T
	 5XNbDDe5+4C27g4+WujJTpORusE4ESilO5V3K7IwF4evNSu9u7pBV60Ss0veiMm8qiMhd
	 29CPTRaygFaoZm4azf38GgR05YSG9YUmPJ3sZYFkNqI7+UzHG0W0mZHV/gkOkUTG1Ymc3
	 4+kKhryWh3017a64nYJ1Roonxn3D5sYS1r0IFMhnqZBpW7i42ac+cgTOEQWF48P41Xg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1DFBE1F0156D;
	Fri, 20 Nov 2026 18:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198240;
	bh=3FUmtjIsJ3ZmK7E+kLLMrGlNYlg2V4C2I56CXtFzz5U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Gxx+6zL6QAze5iH2iZgTwlEtC7RlM45Mi0b3EnueATpnLqp0XIvHKHQOMeW9lRNSY
	 M8S0OqET9yDrkw9vxtcLnwFIwZpbn62W/e4Tph669XxHKM4s98YkmVOVH0EsLSUv/w
	 P3tUnXG98i8l8fAm3EPnABiLeqfFt2RolBMw6/fR8qtngnpF0LmVbj8ETkmYY6zKcK
	 AbYrg9XVGxY0XKzRrbUYFo22Tx8OfWqCSUNvONTo/ooKEfDI/qYB5IV4yQ/rGUqy39
	 7DetPXTsrpa80pNum4OxW78Kyk+JSrzKM8dLSNAkjmboCBZuXKxjvbXD129z1SMpz7
	 rupLYVANtiE7A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 791224B955;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:28 -0500
Subject: [PATCH 37/60] mm/page_alloc: keep private memory out of reclaim
 reserves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-37-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=2669;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=NqkTU0G15QptyPCK0Ojs5H9K0W+kcHSZdbygJtTYqZc=;
 b=U+TYg4SE0rKVwmvMy4PubxHF4IY7Amo8OOW2W53v3w1Myl2X+1UCWjZFn9mv5qjoPrZIpJw9A
 33bh8SQUd1oCsIAGWHNALhdB5JCENBTwjecSgE4RLHDlwbK3KW4BS/N
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3FEF8000D
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: paof5f18e5wkccu9i6wj4jbptekmthgt
X-Rspam-User:
X-HE-Tag: 1795198241-796353
X-HE-Meta: U2FsdGVkX1+BmeqcRD1BR4/uymap9Iu5UCrHqzXT+bq9zRbhzbfjHjAM4XDLQw2I2qaw1XRt2TTYZssTu0T09scKSCWZUgHnPvVVAWke4frhgd/h36+XUM1TPIC0BPWtCARdt55UKIy5Aud4XUrACQOgL0vXz4kggz0yWBN0uDSHUPiPwUZf7wvYCBMwav9hN74fa7mM0TsLPUXPmkt/YKX+aIPmXsqoxQNAaYBEHnh4uIrwQrX2J/xPuVVBPdXxCXJi7INoDHYLRH0ptYwxu/VHEz0M6waDYsQFKORnIkBSrlC3rTmdeLjZDvVHVXsn1biQBC+xNQ0cSSH4dUiW0unTea2gxqgExVOVPfcHOTh35bFT4/g+XUcGH1ZQ/fZu61bKFV7h8Ivp4CE88wKxQNcb36dTXx1jU9+C9GgILAUIT4A+qeJkoOXGuj2bW+7kKYaKm1jWkMKcM3AOxKwpmemY3dUWtf0mtfjW7YsPTFxNuVIK5UqdglPTYHqYkGC82wXovsvZdm3N18jh3LQEk+xC/AgT2zqjdT+92cSENUikhJc0os4bZueIUHMU9myUIWXgNkPwtAdcH1DN9GD9EFWbZra2eaw1uNSXM6LWlIpSaw66op/nGLcUvPe2AqLPadkutcEIK4Pwfd6dqgLwnbtijLJGNQyro7KNZvhRHB/NyIBwVF3uzph1ciuA1h9jVTGjpYWJjOe/C0Dtelw1L0s0RaPJ1KW8Ja+vokvgpM/rb11iTLENOORBNXuyiYsyjR+bn3EMtK9goa7Y2J9HHXovnEzi3d2lwWk+ts+7/il4bvp2O5KiIP8XeZamgtBfQd4Xf1gTFSMePKldxsLfzwO35EcQuRs+tHrgRRSttJbg2IF7hkRBzqYCfx/6kci/oc/+kKN0JKOAksXkXJcmOrflyfLUu3kHU2D2HdRdzdA0RTwwi12/VF6Wnkw71PWaH76eIqs6RWeWFWL073T
 qpJuOhU5
 kvAcjnMJrmxiZMJXX6oQ+e3rNpzMoBi2FxlPrMR6imYDW9fglpmobI8df+FlJyv0w2D4IqGFg4zNleJCv5bMZ9R+HmCjNnU7gpWpm+YitQsRpQabwkL2JEKQtJ8IWY+xQ4OzZ1yNLuV4aFd+OAJPqOtVU4Nyun52yCZBRUveJs76nlQPsCoZoYoeMcVVRvP+1Y2sRmsMc9dM7/rTIxjNRYfz2/DIX38nV0BuIRL9eunNwovVE2vhBcaC0xFI5Ac5nOtmJfToJ6SDFvUHA6bn7Yyty9IoOyMpyEIqRu1wn6Lh61Mjf15ExLL2cwqHyq5zsPOiKwIr0mpk8+ku3L0Pz7tRbKglQajHn3N5g6EGMe2ratdWyTOevd6MFK05N1yVkcVQlvcxHXbYJmTbiAV+7/jyHjmHxdPgZuEg16HxlEqqKIWCCYsV3dtyeDlj6EUo3F19wkvu4faWzo767EkgOxpgd6QDdrEgHIzWL/4HGaXaqd+dA4XlX3s5wtZj3Ef3oxxi7oYo8g/4l8AO68kU+T/MpP8/olI1JSoHNnpG+i6o3EObZamf2azDYyPKILb3bsZNhmmQhVDhfqmDU9+Qa2eIjS1p0dtG/ef561an5s4rmjXDz2aJQIzR6MjJIXNynquiVMw3MAAM6lBBlmlLGqztGfJoZcwCM536wJF+awEnIBHLGMK2x3kqX7eSylgAd/AplisBj2NwGFc0/ZW47Y5ETouREX2tbTMhOkoOXZeAw9UhA8AbzG2he6YQSCGLD+5sqhxDDv+SnK8Fq+T/O592EA4j4LIEBPaWyxF6WAHbAdcieKvkS4YJeVuEym/wrMTfI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Private memory cannot serve general system allocations, so it should not
contribute to reserves.

Exclude private capacity from the lowmem denominator and the global
reserve total, so the pages_min budget and the system reserve stay on
common memory. A private node still records its own reserve, which
its per-node dirty limit subtracts.

Zero private zones' watermarks. No kswapd runs for a private node to
restore them, and the pages below the minimum would be unreachable.
With no high watermark, a migratetype fallback never boosts them
either.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0a5176a6e9db..de1a13a91ef4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6610,6 +6610,8 @@ static void calculate_totalreserve_pages(void)
 	enum zone_type i, j;
 
 	for_each_online_pgdat(pgdat) {
+		/* Only common memory holds the system reserve. */
+		bool common = node_state(pgdat->node_id, N_MEMORY_COMMON);
 
 		pgdat->totalreserve_pages = 0;
 
@@ -6640,7 +6642,8 @@ static void calculate_totalreserve_pages(void)
 
 			pgdat->totalreserve_pages += max;
 
-			reserve_pages += max;
+			if (common)
+				reserve_pages += max;
 		}
 	}
 	totalreserve_pages = reserve_pages;
@@ -6705,9 +6708,13 @@ static void __setup_per_zone_wmarks(void)
 	struct zone *zone;
 	unsigned long flags;
 
-	/* Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages */
+	/*
+	 * Calculate total number of !ZONE_HIGHMEM and !ZONE_MOVABLE pages.
+	 * Distribute the global pages_min budget only over common memory.
+	 */
 	for_each_zone(zone) {
-		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE)
+		if (!is_highmem(zone) && zone_idx(zone) != ZONE_MOVABLE &&
+		    !node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
 			lowmem_pages += zone_managed_pages(zone);
 	}
 
@@ -6715,6 +6722,16 @@ static void __setup_per_zone_wmarks(void)
 		u64 tmp;
 
 		spin_lock_irqsave(&zone->lock, flags);
+		/* No kswapd runs for a private node to restore watermarks. */
+		if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE)) {
+			zone->_watermark[WMARK_MIN] = 0;
+			zone->_watermark[WMARK_LOW] = 0;
+			zone->_watermark[WMARK_HIGH] = 0;
+			zone->_watermark[WMARK_PROMO] = 0;
+			zone->watermark_boost = 0;
+			spin_unlock_irqrestore(&zone->lock, flags);
+			continue;
+		}
 		tmp = (u64)pages_min * zone_managed_pages(zone);
 		tmp = div64_ul(tmp, lowmem_pages);
 		if (is_highmem(zone) || zone_idx(zone) == ZONE_MOVABLE) {

-- 
2.56.1



