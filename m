Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D67606DE2E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgD1mkcH
Received: by kanga.kvack.org (Postfix)
	id 62AF26B05C1; Fri, 20 Nov 2026 13:10:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC676B05C2; Fri, 20 Nov 2026 13:10:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457026B05C3; Fri, 20 Nov 2026 13:10:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAE16B05C1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92CD8A678B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:04 +0000 (UTC)
X-FDA: 85456286328.13.E65806E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8AD2C1C000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgD1mkcH;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198202;
	b=JiFNOT+NQV3pJw3buNNbqmsdAx7fYXSsXPcZ3KWfnvH4751JtZEYIC01iAmMwYciDEVD+n
	aI+fO3HuRs3X/3iEutjUTJv+D6s18vN8PUMFhKRyRxG0n3DWR08pJrXRt0fA4cWTYjv7RK
	xiVUXDNB13kH22QOv8Vgbk389nYy118=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198202;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4M2rXiYs2G6SjYidH711tRE1Q56dF/DSHWjxK6H/p44=;
	b=GnYIYoBLgL59mLhQ1gAOx1yI3qPZa29NyQXgPr4vikTq5lMq5vKaoDPUiZiJIef86kDn3e
	QC5FtPnzg1Kv0CCAI8eTUXDCNdQcSKZMKrlePwMEziLJRCkzl0LH7msgmvF/rg+ZInPknq
	H5V3gbhFKKv/tu6OZlZWGtyqFBkWW4I=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgD1mkcH;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21613633C8;
	Fri, 20 Nov 2026 18:10:02 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198201;
	b=kL+Sqlg639UZ7/KgJB9NEA90iNemctbaN8Ax+WPK1xWE6xg7ZKKcASh1mx3+Hrness96
	 FbD6PXhsI1psY2gWiAL6n94TAYFbfrGWMUh5tSojBaf/5FlITUSdoAoG3QXMoL0fbuW9n
	 4KH0dScYhkjhA/Eu88bj+Ia9IpTbWT8uzctXsw/3Jig6Jul5nDdvRl1XCdb5+9Hn/R+62
	 f+HBxzKqTI19muoU5lsIWPUnoQQ00pPEIwwQIYI/OryneyURZtpwhFlOV+7JNww9ANHO/
	 syh/BDgj2Gd2qaOXA06rUkRNvHLpLIfjtRN41UJWFGPWhVurAZZj5MurcKmHgChYtPw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198201;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=4M2rXiYs2G6SjYidH711tRE1Q56dF/DSHWjxK6H/p44=;
	b=KkF7pP1rKC2ZQY0lzGjIsEKfbpZHz27B/sUGmp96zckybvG2R8mjbPAlINcbqfLwC4LQ
	 3V82OkA+3qLHK9ijBVBbAFRUsNxIXGr4CXRlOubVUacFwuUzh/VFEbclaPaFR7nZ/9pqz
	 RHr+sj2kAqz8UlFjNymQ2RNHAJrKTHyLqXr57zuwaEknXtkHtT4GSRtjJpMqTN2m4XLEh
	 y53JLA+z5D1aMug1BmHsHNTRtE8NDsTDm+O31s35llteDXvZDQt4GmKCr246eKlCqi2rI
	 ti0x021IC8SiIC3b6EIXkAqCbj/s+SzVrKhF8tbToqSZh2wGQDDjjP7jsAloynS8bpw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3441D1F000D4;
	Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198201;
	bh=4M2rXiYs2G6SjYidH711tRE1Q56dF/DSHWjxK6H/p44=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=GgD1mkcHUUwEhYscIOWpck/fWJlEFGVBLRw1EURWx33s1IzgBPy493uVXkkRU5poK
	 SBddBi+Lx73j9uJVN/7nU+KJ8KvWNQ1EIK4foiwsfFoHXAXKJVxB8KrD7rYZArSyDA
	 1oLGfnf0IgOlSF8WBevL4nJ/cXgwwLskFIEfx00twK+VxrfRc2FbkEnDnq3YOkQOIt
	 aXmVG9nuh2jot+T+tViK7bHwVmgrqSLZoRt/c+Hilt8z2pftBdMtPqNqV59RuzD8xe
	 0ax2F8P7AZxF2bwQBB9eo/ZbIeVG3wD7LdJ+J8NYkABL8cZAztKXHQXDJknuRvzpFH
	 ldVW03yxwY6dA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 323304B8E9;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:01 -0500
Subject: [PATCH 10/60] sched/numa: restrict NUMA migration targets to
 common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-10-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1044;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=8xAnUIGjGSJir+fD8yB81C3j8AQ2SKbyFL5jvqemmlk=;
 b=ITwE6KTd6aOZpuyjJFOoe0STMIT7+0eaFIXOVs6I0ryUIxRHLbIno5UO04kFOxJT7OvBREvQE
 aMVtqVwDWbPApem/lyw9QN2C2QmxHB1p/MFJmF6ejxZlsuwRg6Ycrdi
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rx9rk5gy6kufsg7znz65pam5i47yukiq
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AD2C1C000A
X-HE-Tag: 1795198202-400566
X-HE-Meta: U2FsdGVkX1+OyS1nbbR8UPy5yDoU5KTqSHOhlgmnGNGdFauPs2tf0yYuyp8NLgtuBHGziWeS9HK08E+/gkwEaedxdXqmtmv2AY0fgMmJlhCwPZvGpoTLBZHnXMCtM98q9ZyQh8InkRWQIbqFCMhQV8njvk5FzKcNCUDj/W+zdriAHOto1bXChfVgL3rTTHcOzRm8gZBcyz8GlluAwLBFXSO7oVihkWChp/T7Vtm9J/w/FRjtCLUjntSEPyLP/ovgDJZUO/ZnJuynAdwqcXQscF9KM5kAC/WT4EWvfslisisLy0YDSw53bIvK5Rw+N8arJYJNqd810fYbGcuhclXFZWecTbpsdqgIU4l20dmqoZN0cuigoIt5j9jOx6TrUGjSnBeWbEfGIYAN73rcVH/iT/J3ee3OuZQ5px9LW73AfYDPg57sXRgH8qJZycPglcMTenFqqbqxpI/EPbcOdd/aqo6FD4FtQvmLgy6qywO+Nfucv5pJwzSwbIdSMSHKAtLbly2tq0pHf63dQPPBThBZDUvRbLnD9IHHg+X9EoK0wSwwNIGY4MkGr2OioNiT/PjDEelOd7zIdvFqF6aRxDc7rYZnn301wPlxKFko8UPNuFSVX+WSiG/YJ2Fvaz6+Xvl7jo4ScnTYGiWr4N9LuGxCyZG1wczF32CJMdPv7DHQqSfy/f4Ajkos99W/Ffts+IlwRC5Is4FeS0Q/Vu5N0I1EWlukqP5dk6LFqi3TiEsTrvUDVXGlXJc0gfxUF9sjeEBhnljk1QoiJWeWbgOz97do6JuCMdECRYWevCjjp83bN3Nr5hEBX59zYJ9/3wfl4v4YHDiGh1KIxPe26Fzne5kq41MsfwihtH5Kbt//5UCokvMrxJnAO4nhWir2Gv0UFCx8LfWQyhRM6zhp0c7/JICSOo3vzdbkJ1XCJuNsU5nMa6a+rYhel+miYKbJmhvQ2SCxj12vfjFjQoGXquyGM9I
 GsxzOkVI
 mOsK0oD6V3Az2gUq8PFnsPnwNY8iC+5Q+7yGCLorH0G4tJx0FOftMvR9QrXFBJsVK+Wg3iIKg7IQMj8G5WMRLmtU3nhi8ywyF1tCXBIPvijXHUkz39wsD6GbUBdmzDVW4fejK2uPMwB655kvkOZLd1nYn2cC6v3XQO7r7RGy4p5yjqNR61uYWBV271QKL5pfBlpKaqO0MVWo4LwcAqm96ZVRxH8Z9lREEtri5cLDO1w3D6qsEUiNOC3A8FByqGZMn2hgkLXYWEhG/XFP5mp1XyecbRMKCmFJAzZXFBCRayvlWcXSj1PuJ4RP63PUhYTvmoy3YDVviyyHbcBzkABAV08HdfMvFGRJqSXo/wLLqfOgvzMw7462BguRztT/u+rV/NGpK4zkepXgOUocDoqXN84J9GAdTwIVy8GE8T9pdIIl5fDuewIfEPMsymoJHJZ8vlufQ60BW42RQNxeCZo7rxHYCt0n/RGuslTZES3d5QXue3IQCBH7bwMHn7EDxn+u4VOXbJE8yYK3XbXV9/d+Czw7+T+EYfEHDN6P187W00uYDxKhxegnmkipnDjea8r1KJ4pJSENBvzRJC8XZ2LNYC6VjYnXFWRuNfBAMZlnKubszWOsROETT33W5cRQz9L1x2dLlHtvo32Wzqp5O0v2N1OJM7fjEIWV9ezvdQ6JAxC1yEQ8zp5i1pGDWQ3SADi4HpEuJgdbN+x28ybNprsKmquetv7blG7AjPjvLd4YlwA/4mKy/DFh+wfhY4Rq1yonr0kxJswsRxLqjC+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

should_numa_migrate_memory() refuses to migrate folios towards a
memoryless node, since the migration can only fail; see
commit 3fb43636876d ("sched/numa, mm: do not try to migrate memory to
memoryless nodes").

A node outside N_MEMORY_COMMON can have CPUs but has an empty
__GFP_THISNODE zonelist, so a NUMA hinting fault from one of its CPUs
would isolate the folio, fail to allocate the destination and put the
folio back.

Check N_MEMORY_COMMON instead.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 0c8af1cac2d5..18db9bd25db2 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2876,7 +2876,7 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
 	/*
 	 * Cannot migrate to memoryless nodes.
 	 */
-	if (!node_state(dst_nid, N_MEMORY))
+	if (!node_state(dst_nid, N_MEMORY_COMMON))
 		return false;
 
 	/*

-- 
2.56.1



