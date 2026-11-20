Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6FF606C6E7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A3Z1csWP
Received: by kanga.kvack.org (Postfix)
	id B37366B05F2; Fri, 20 Nov 2026 13:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE76F6B05F3; Fri, 20 Nov 2026 13:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 939746B05F4; Fri, 20 Nov 2026 13:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 567256B05F2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3E63A657D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:22 +0000 (UTC)
X-FDA: 85456289604.06.2615B0A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id A557F12000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:11:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A3Z1csWP;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198280;
	b=D231DBFaKelBPchtkw8h9ZmzT0SznCbWVT47IFbB/Ok8ApSIv5AUh/XrtgmxP9eDsDEst5
	Ptj3310FHuemUjn9Wmsgl9UKrmtmGLmVQHJCKz90izXkFFmygNKEpHdDCh1bKxCwQbvZ+Q
	kHWNZELsevqVf98zoYVZ3VglA/B0P8o=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198280;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbXqo0otTzp6KrXr3a6CWvy6rduI8+vwsObH5S7PopY=;
	b=RupxW32aytEKS+Pxms1YlHCBU40IvhcKCQiH8G5QmBgy0Nf3lGvXGVp8xdFdKbNH4Dao27
	/ZAQjw8VpZssiB+BAu+Ub/g6Aw26cZdyP5PHDa61wq5n2b+SoHqAPBxYdj83WtSc84+wZZ
	RmKHRBxenRnM+HLYQq+07lxTqCJK/ZA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A3Z1csWP;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 424E16344B;
	Fri, 20 Nov 2026 18:11:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198280;
	b=I2pcV+l0y9I0PCrpxChpDU+XajTq9RKw/lYBtbfD5+KymHs+lb5FvdztS7yk/c1aiOoT
	 Lrzgt7uIv6TbvYzxpV081zHwVI+XKjc3fjX0YXFsPHLcIFyily82XijCmlEF15ZMJ8XZV
	 9Igz0BWu5DYimhyFH1DV4CV+4rWZekbyHtdUjer8TBOV4JuyQeQ131O9CQFRYJ7ETtBq5
	 E+8VF7nDsyg8IxL+oKXscruMd87ScfeY6uTypKJsNJ3kd7uakTfYHuXJIHYEbUBFDWbxY
	 /hVYosbJZ1YZLrJS0e6Jevmk94jVPu3T4Q6MNNipmCuQ/snOeNDiOqScw4t8E2FXKAQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198280;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=KbXqo0otTzp6KrXr3a6CWvy6rduI8+vwsObH5S7PopY=;
	b=kM+IyIOef4yAJn+abFDPJemjfOfdUGhT5hEe53w2g/W2bo5BVrG5t6bzzxuEYJmFMwzS
	 vieLRC/rgQrR4OGvMr4/xICWNUbMkzqS8WbRxj/ygKHRPK/0/iwvxQ+PE2IEyQTnE3PsY
	 Zh4TsXWkQbXCmOy6Ahzeia4SHqpyG+dSuMJRQap+2nIH41RHnsyDN9CoIUPllNFzfM1Lq
	 VfrjPaB0TrYRWp8+kIM7xErGx6GMYw/d568yK90a9GraIVDxExhAOHANG1YK5rYivqRT2
	 u56af8twwFWvLM4n8NJqE0rPaXrJN2A83vwhGinhDP4ukxtHDz/EeTTzXTu9UZt04XA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id DF3131F00AE3;
	Fri, 20 Nov 2026 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198279;
	bh=KbXqo0otTzp6KrXr3a6CWvy6rduI8+vwsObH5S7PopY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=A3Z1csWP936CIOfU3hrgPS1/dDFH74BAkYHQLn96TIFBCx+MIPv3RU3TKNSqXxVW/
	 lEQNkZbxgNTaXFUAHyANZnbhyFP5VE4qmhRWD9wyn6uS/9SCur0TAS1SKgfWlhQ2tc
	 7DBZmexhDTkRcdaZWfneXSFOHA8nNQmAAhFpI5RayEMVeg470piLIAX7Bb72G6xz1n
	 Jnd2gWT/FR5UPHNLL/Nx9UYfMd59e7nh3yqy1c1A8j6PkYP8H5B8BpWzHYkcBhz3ds
	 Q+ZTFq8d7UxE/9l/7Nb4Zoze5VyGNwQeUvLXZIjGK7YeZ4e4RwhcwcM56su2Jvo41M
	 iPxco+yXZVbZg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F107B4B984;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:40 -0500
Subject: [PATCH 49/60] mm/vmscan: reclaim private nodes for memcg
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-49-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=4186;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=gf0+A4YMX7aNzEjLzoppxY9C0nz/hDCzkhh7ctvqKwQ=;
 b=PXI/X13XAoa7r+jmzPre0N2z+VrJATpuAV7CpwhBQAVTEngszA2E6bmutkAMGbnv2eUsyGVrn
 +kF2GDAg++lDYHrIPmvec6YTNf5pZ5MjEHc8/slSYzQiq7FbbeI35Jq
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1mjydbjfhj1xj39bnfpjqhigxke8cpr5
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A557F12000D
X-HE-Tag: 1795198280-29655
X-HE-Meta: U2FsdGVkX18529/0B8OhTxqih3k3QWLeizqNmhRJTCu9dkeTrNkODg4kukv71r4eqi/o+yoH8vdsKZO/cJHef1WqoHKImYeoEdml18nzt6Z4lugI+8Nxp58PCcpYXPm3qx6TVpkI0p1TlbQ6iMSMibEvZZ3eViYyNV4zAkb/YnWCNdaOArdFRFAn4wMHy4HubCX+GZrU5fY3Fx489WTWOmK4FIR79hcYRuc422RBOCVXzKI97oks7bfaA/PciPpfup/7cKqNAeuo+XHxMu8li4vxO8zKv3GuE/PG7gEMNdw9EXntVcaaVErfaCSJ3UsjO/aD4bc842pn62H+xQwhdRNhesU7yBRWMnckgroSVr+SLcdPYZvXVnZ634lz1UBm8FZcT/CRM2J6MarAr3hBzMQnIFYRGxf+W7hXirncsTfXfS7QBnWMeHXyUVHzG4fMJRN9EOKqIfCBIHGC0SvyNCNfXGS7ZzyFM7TY5jnFK2NYREZeQCUH2FrMa5lLaqcqP/5bji68m9Nyxl7An9m9jaWkeaxDCfQvzyAsCs3K5NVWUmLDxiXUnXpjwdInuMlYGvN1N1bM3tySvXLyqbWmvYVAOFCJ9O13SGpdl527wAMB2n9P3SGOJL2tczHqCQbmyU8Nw5VqNlldUKVpaaZPLUfozqH+jAfnBlrl6Lepn4oBLJzxvH4uy1ic0Frlr8D6wHbDgQXKODAjPPfndF6jnNU1gqSi3EceNBUydlgdHUathC/UNa+jNHsKQiMdhob12Ny0HHPorkpUVioWOKNa0wglp4QcbKqWFL+ujeX4aGftd1LrZB46ybSr2dK9lUL8+01xwXOV7aq7WkJMilBYUaV/KNi+QhIuXeYKEHrRBm+xzv6gtz5FZQcN0aXHwcfPbiKOJYdOFzn3UAD8SiCzmgpYmMx3Zaqd3ftvWu4X1u9otZvnsk1CW0n8IILbtSMhJ6Q9LoPoPiWyeTIgKEy
 lwsywH4r
 svbuYu9koykro/6UAiYoYL+u/I1mfY4jWMofnZD1ZFke0JJgCW1pHrIh4j6BnHjvuDQxRd6B9P5VFHNu/BWNBsCpXK+ntfsaHYDvaLg9R6mjxkEHCT8d/47FMT1ne2lFO1wlVKvyNDLeS923clJQMvGJoupViVoYe/UKWS2r2Gj9TQKPBt6PfTpDjw6qFjkYJsVG7pxuJHco0N8XgHd4WbQVdJITR25X1ziQiI28PYxc1/FVYqyDDZe1HvNaDE1Z628+MYFvhhzTdtH2E7cuqaM1m4+POWrDBhKqXJH4WBAc36XzgMCJQsynkDD2zG2SMyTYnXt7gvKFElXtoWNVXecFcd0b/AMwqtmRfFlgdXmJDN5xABRqgP6lGlbmTawKAOODrpkOvc2AyjrKW5PRXO3TB7+giZC5l1+fo7sGAvvx4nYqKgH3niOTXGcSTbogHlG4vTCUX1OOJtmRMUfpMjC+2ATF6da/l4ljXzZ9vhWBRzZW55eRh23afFrskjYSxexsyXBpMKmEIejoAauEFhlh9WJyUxjywsLPGeVB3sw0BqUoP4jxtURPH8yCgasNnbxWv8S2fK82Cdic1tbd78Dpy2ts6B2XnLUnU/BGlW9LakdFbFKii4qBPOW79/HeRhgzBDpMiQiqzkLWNk3KjJWzkpT2CSLBIr4ecip9wZIY5779FjABtnuiXyaGFfH1r7KJdtGsiiquR7e9yaF8z8klGWlxGwiQ98swWyNsx73c8+JL2IZTXtYSmNX5OayWTYnxoGjRhM+DAA+A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

Memcg reclaim does not serve one allocation, so it should cover every
node that permits reclaim. It walks the current node's fallback
zonelist, which holds no private node, so a private node that permits
reclaim is never scanned for a cgroup over its limit.

After the zonelist, visit the nodes that permit reclaim and that the
zonelist did not cover, and give them the same refault snapshot and
congestion reset. The zonelist keeps setting the order, which matters
because memcg reclaim stops once it has freed enough.

Direct reclaim for an allocation still walks only that allocation's
zonelist. A private allocation's zonelist covers its own node, and
reclaiming private memory cannot satisfy a common allocation.

Without private nodes the zonelist covers every node that permits
reclaim, so behavior is unchanged.

Another way to do this would be to implement a reclaim zonelist that
only reclaim uses, but this implementation does not carry the static
per-node size overhead that adding another zonelist does.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/vmscan.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 03d0919d11be..49ec85ed00e0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -6636,6 +6636,21 @@ static void consider_reclaim_throttle(pg_data_t *pgdat, struct scan_control *sc)
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_NOPROGRESS);
 }
 
+/* Whether shrink_zones() reaches @nid through @zonelist. */
+static bool zonelist_reaches_node(struct zonelist *zonelist, int nid,
+				  struct scan_control *sc)
+{
+	struct zoneref *z;
+	struct zone *zone;
+
+	for_each_zone_zonelist_nodemask(zone, z, zonelist, sc->reclaim_idx,
+					sc->nodemask) {
+		if (zone_to_nid(zone) == nid)
+			return true;
+	}
+	return false;
+}
+
 /*
  * This is the direct reclaim path, for page-allocating processes.  We only
  * try to reclaim pages from zones which will satisfy the caller's allocation
@@ -6651,6 +6666,7 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 	gfp_t orig_mask;
 	pg_data_t *last_pgdat = NULL;
 	pg_data_t *first_pgdat = NULL;
+	int nid;
 
 	/*
 	 * If the number of buffer_heads in the machine exceeds the maximum
@@ -6706,6 +6722,14 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
 		shrink_node(zone->zone_pgdat, sc);
 	}
 
+	/* A cgroup's memory may be on nodes that are not on the zonelist. */
+	if (cgroup_reclaim(sc)) {
+		for_each_node_state(nid, N_MEMORY_RECLAIM) {
+			if (!zonelist_reaches_node(zonelist, nid, sc))
+				shrink_node(NODE_DATA(nid), sc);
+		}
+	}
+
 	if (first_pgdat)
 		consider_reclaim_throttle(first_pgdat, sc);
 
@@ -6754,6 +6778,7 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 	pg_data_t *last_pgdat;
 	struct zoneref *z;
 	struct zone *zone;
+	int nid;
 retry:
 	delayacct_freepages_start();
 
@@ -6792,6 +6817,21 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		}
 	}
 
+	/*
+	 * Also cover the nodes shrink_zones() reclaimed beyond the zonelist.
+	 * Finishing a zonelist node again is harmless.
+	 */
+	if (cgroup_reclaim(sc)) {
+		for_each_node_state(nid, N_MEMORY_RECLAIM) {
+			struct lruvec *lruvec;
+
+			snapshot_refaults(sc->target_mem_cgroup, NODE_DATA(nid));
+			lruvec = mem_cgroup_lruvec(sc->target_mem_cgroup,
+						   NODE_DATA(nid));
+			clear_bit(LRUVEC_CGROUP_CONGESTED, &lruvec->flags);
+		}
+	}
+
 	delayacct_freepages_end();
 
 	if (sc->nr_reclaimed)
@@ -7038,7 +7078,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
 	/*
 	 * Traverse the ZONELIST_FALLBACK zonelist of the current node to put
 	 * equal pressure on all the nodes. This is based on the assumption that
-	 * the reclaim does not bail out early.
+	 * the reclaim does not bail out early. shrink_zones() also visits the
+	 * nodes that permit reclaim and are not on the zonelist.
 	 */
 	struct zonelist *zonelist = node_zonelist(numa_node_id(), sc.gfp_mask);
 

-- 
2.56.1



