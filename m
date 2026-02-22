Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB636E9A02C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 05:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4C26B0088; Sun, 22 Feb 2026 00:45:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2316B0089; Sun, 22 Feb 2026 00:45:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE896B008A; Sun, 22 Feb 2026 00:45:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 448866B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:45:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D240B59BD5
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 05:45:40 +0000 (UTC)
X-FDA: 84471005640.30.FBAD25F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 07ABAA000A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 05:45:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KrWxGRAc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771739139; a=rsa-sha256;
	cv=none;
	b=qOBD0TrGQUDBRDsw/55i2hxchj0Tw9vHscWVI9/7e9aBWT8Hciys0mEcQ4WB0k8wMYFGRb
	/bYjrjZ+vREXaTH+UnyBfdOEli5yA67xn3G7bHoWlzOfXmN6+xOa2lVQrOOPQ4QLS+6z+C
	/H5w3av8TCt6ikqTyYpp1WRR5scvUxQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KrWxGRAc;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771739139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=2YqpAD0U8T4fQHE/+t7PELDOy2lVte7kXSbCsAFkn3w=;
	b=Uh4LYu94FT5O20kyy4vQkwNf5lqCwuCvChCHHOydWSu+uQd9K4CH2Ldub6hK66BJ0z/g9K
	eduSb34p1fEt9tPz8bDor+h+Oh3JZIlzT7y/4J9twJCjlJVe4b0vO1+aXLRa1Mxk8E4xN5
	oVi37nwlboGBch1CBaEJFjKiRcWF/FU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771739138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=2YqpAD0U8T4fQHE/+t7PELDOy2lVte7kXSbCsAFkn3w=;
	b=KrWxGRAca+EcPUPT4PM/BiSe2976Nin1gZOFZA5jqRwhx1Ih9DJ+1iDAdVjxC734SyT7TN
	Hap7ZEs4WR+04HudERRg4Aue9jBTLTMjLxtrJDvvKzavUYtlYjZnvcFvgKdArpdejgUHxZ
	YnK2H41eBr//V/f/dgLvChXNTNw0yrc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-0Ngkhli9NAq41G0r0JAkQQ-1; Sun,
 22 Feb 2026 00:45:34 -0500
X-MC-Unique: 0Ngkhli9NAq41G0r0JAkQQ-1
X-Mimecast-MFC-AGG-ID: 0Ngkhli9NAq41G0r0JAkQQ_1771739133
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3662D195608F;
	Sun, 22 Feb 2026 05:45:33 +0000 (UTC)
Received: from localhost (unknown [10.72.116.6])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0E92A30001BE;
	Sun, 22 Feb 2026 05:45:31 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: [PATCH] mm: fix NULL NODE_DATA dereference for memoryless nodes on boot
Date: Sun, 22 Feb 2026 13:44:51 +0800
Message-ID: <20260222054451.3261-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: QmP384Ui4X1dpMdP6xY5YEUgpVginITOJQs7EhmMAzY_1771739133
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 07ABAA000A
X-Stat-Signature: g397zcsp7e1r3i17scpyfgxrc5sw4r3a
X-HE-Tag: 1771739138-238094
X-HE-Meta: U2FsdGVkX19hRWxueif4KPc3jj1vjNXfqFOdnDRTKLsdmOSntABgkO1OCVGjkt0XTC7lA4+CBBbboDTXyKRIcz1UdY6/NU3U3NcMitgIepKksZurI4m7umIShzN1IkJWg91Fbjlu3Lhc2aA4/WN31hlTxYCW+olFLJkQTPq7Tqrhj1R7NHRq6XYVpn9hBGdHNhQS7fw9TkRXOZmlFcEOAAaQtWDbG6vISNWwH7qDyuzMm5uNTDmuBHH+zCwigjJ4BsRA9WbGGNTUm3FduC8AlGUP1EvidbnrGSi0htl6hWAhqg4Oks7f2HFjZ29a7wGtT6pqawheqmM6rcyWelfFSMycfYt5yxMYEyAdHfKDz+QS/ZkJKsbReN3XqQd1AC3J58ZKneJ4dXYyHdyA+Q5JTaT32KHTVdBilaYfBYuFvzGiCv9RQfTfDaDCUKgItw22/bZT0eXbBcVOGHWfY9yw2v9Wmmz0nUSrk0l6wyUBBHDTsyq6iJ11iNps9Z4l9PZbhByL4O+NdUIjobwLL/FwDQZ6hNY+EAGiX8OA7A687AG/AvP7/DcMrfWMYiL/2wmbIjIxokiqYG0ZzaMWvn9j7r47maoNnM+lXelRTv8TYyAL2IKrKl+GXwTPRSC5qnvXhlQSQ0C/CM/rSXjzC6XD3xGGyDcYK73G9JQEPE3gO6ExipiIUv7KY2zrRe/rU4iwmrQYleHEkW8eL8A0OzadYrv5qXligsr14e7hpLSqDHlSvTEDHI+9VfB3Btofp1fFAp+gmB8hV7U6NUk3dqmvm0ijp44JHdsAzFMJkQ947dBpF4vmSKJZ9vLgqsj8/cnans8/+sHOZWMNc34vt2DCyJV7NVFKRZrfjscerN2ZK/wILU5CSKvyvUEwAhmLz4M5dndwvq+CMbLGX7hjLQZtihwZ5wtUI+evBzFHZuxTYjUKcbFWt0/JBNScpqzX5AVGQbtZHQpFNfei43Ay6lb
 +TOMUbyc
 qZkqgHYCOimMx02B1toYO7BWbSTw9Azq9L1JvtifNq+FAhMFfMXpybDu+30A/sHdpjE9JTpqZN0cLNtXaxO68ENtMlrrrT1k0mo9ogFORO4nDbeIwii7YXbYOW1t996YJhrPQNNBnINUb1VqRG/rZA2D1IACKyWC77j5nObdcWbyX9OWU6YWpvDq4lxyrK3p5vf2Kryv7QDTxFUPZd8ybOjP47o7zAXijP0DYLbtGEKTVic+PNzpGmOIuSO2L5xJF8wb/C7EziRR4LQbiAPNq5LFiEU29yYAMm0WFz8XVpff2ny2oz9+nws6f60oPPA4K/bxQ/mbXcRDqnBLO4RD1zQy1Wy8Z4LPB2/hDs0xTlS3Wf2jAMScIndBsp4qc9jHWMCa8K6C4r4MLy7pCGpBmxBh3OhGFNa0/PnQxQM/HcclufPGaXxZGfAHC6bflK7XNMT7RKQj9LgcZF9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
zones and memory map") moved free_area_init() from setup_arch() to
mm_core_init_early(), which runs after setup_arch() returns.

This changed the ordering relative to init_cpu_to_node() on x86. Before
the commit, free_area_init() ran during paging_init() (called from
setup_arch()) *before* init_cpu_to_node(). After the commit, it runs
*after* init_cpu_to_node().

On machines with memoryless NUMA nodes (e.g., node 0 has CPUs but no
memory), this causes a NULL pointer dereference:

 1. numa_register_nodes() skips memoryless nodes: no alloc_node_data()
    and no node_set_online() for them.
 2. init_cpu_to_node() sets memoryless nodes online (they have CPUs)
    but does not allocate NODE_DATA.
 3. free_area_init() checks "if (!node_online(nid))" to decide whether
    to call alloc_offline_node_data(). Since the memoryless node is now
    online, the allocation is skipped, leaving NODE_DATA(nid) == NULL.
 4. The immediate "pgdat = NODE_DATA(nid)" dereferences NULL.

The crash happens before console_init(), so no output is visible without
earlyprintk. With earlyprintk enabled, the following panic is observed:

 BUG: unable to handle page fault for address: 000000000002a1e0
 Oops: Oops: 0000 [#1] SMP NOPTI
 RIP: 0010:free_area_init_node+0x3a/0x540
 Call Trace:
  <TASK>
  free_area_init+0x331/0x4e0
  start_kernel+0x69/0x4a0
  x86_64_start_reservations+0x24/0x30
  x86_64_start_kernel+0x125/0x130
  common_startup_64+0x13e/0x148
  </TASK>
 Kernel panic - not syncing: Attempted to kill the idle task!

Fix this by checking "if (!NODE_DATA(nid))" instead of
"if (!node_online(nid))". This directly tests whether the per-node data
structure needs to be allocated, regardless of the node's online status.

Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 mm/mm_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 61d983d23f55..9d63cab36204 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1896,7 +1896,7 @@ static void __init free_area_init(void)
 	for_each_node(nid) {
 		pg_data_t *pgdat;
 
-		if (!node_online(nid))
+		if (!NODE_DATA(nid))
 			alloc_offline_node_data(nid);
 
 		pgdat = NODE_DATA(nid);
-- 
2.52.0


