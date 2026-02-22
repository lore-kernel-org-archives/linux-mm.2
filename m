Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD6EC5DF74
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 11:57:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06CCD6B0088; Sun, 22 Feb 2026 06:57:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32636B0089; Sun, 22 Feb 2026 06:57:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E310E6B008A; Sun, 22 Feb 2026 06:57:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB2746B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 06:57:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C77813B61A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 11:57:22 +0000 (UTC)
X-FDA: 84471942324.14.DA322CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 854D1180007
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 11:57:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Nc8mIeo/";
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771761440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uD8Q34JvjH8pMvt8PCVjIF4RUIZtweGW5/Eb5+0FOc4=;
	b=293neSMJEj4zrz58+/o3hZjBGW9MN6Qpe5l6nFi7YaVemaMwr7Sshgr7ymEegupCNIcnBE
	bW8jn64UoOd6SyMqyPtEy+ESdZUYRgI0CjQ/emZe16Hiqr+3glM4HOK9kLhadtaPe8dSA/
	eMuruzX0DyIHgLJxVFcDojB4/CAzLbo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Nc8mIeo/";
	spf=pass (imf24.hostedemail.com: domain of ming.lei@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=ming.lei@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771761440; a=rsa-sha256;
	cv=none;
	b=sxvejlkHLYC7Z7Ce+x7em/6A/URDtbntk7tmAv0W9GBCUgfYChEo67llkWHgb2oNnO9+in
	f2QJR1ksM2c4nK2LfrdsThxJ9VMccMAITqnTqpiMH1zI01b70MV7eHEvtQ+uSsD7O7aD5S
	d+JO1DFOdfb3hFUFjmL5csEXtO2FHCY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771761436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uD8Q34JvjH8pMvt8PCVjIF4RUIZtweGW5/Eb5+0FOc4=;
	b=Nc8mIeo/nGsH8eEfQ7/W/+PL2eZrJBy3eyRAATMB5YGvLMekyPy4o5Tri0nrJNRbCh16rU
	0683+6xqN+q/stwYCSx0eb2pFi89hRFcj3s5FF2kr7z+pu+aucqdonYcVGDQHix5uSJygn
	lZNRcBZoBmsLQXu+Bge76likjl2ezok=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-325-6iNyqwtzN66KrTi__tukeA-1; Sun,
 22 Feb 2026 06:57:11 -0500
X-MC-Unique: 6iNyqwtzN66KrTi__tukeA-1
X-Mimecast-MFC-AGG-ID: 6iNyqwtzN66KrTi__tukeA_1771761430
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD4121956095;
	Sun, 22 Feb 2026 11:57:09 +0000 (UTC)
Received: from localhost (unknown [10.72.116.32])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7D7B719560A7;
	Sun, 22 Feb 2026 11:57:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2] mm: fix NULL NODE_DATA dereference for memoryless nodes on boot
Date: Sun, 22 Feb 2026 19:57:02 +0800
Message-ID: <20260222115702.3659-1-ming.lei@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 1lo11O49tZaFZ2792JQ9GWryz79Z2GQ4a3W7Bg-LHcw_1771761430
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 854D1180007
X-Stat-Signature: tean848k14fnftgz89yt9mtjopykn5do
X-Rspam-User: 
X-HE-Tag: 1771761439-855231
X-HE-Meta: U2FsdGVkX1+oYxv8yvLD6QaAaNnstdas1Y2z/9mfk7prlIoqfo3Z2KpDHCU+/MnrqWPXDTFRPaAJjUkyFEV1BV8O+HkTrmmdSZaTDrf1tAN4pEegD57FMTtTC+B2eNuMip3mOhMfu5N8v1taMkOrQ8RNCCmDynTNus9rQWWfLL4EXVdhmDlO9EAYvsgXGZPfUYVAKuLUcnCrnmpsotbUgS9NRaaWuFGfmLjBhfu+JaBjm+nxAr6zaQFUM9f1KNYvJicoKNNNaUvw0wuBSGRAJ9cBNplIjnyAbmT23yohj1iS08l3QW9b7Zm0YzdIDDYUvcUwd+sTV7pDUwVOKjeeS0OqaFZQm79RWd07a7C0/T0XXT/LmiHFtCEvEBTisK9jEJptQUDP+ICw/TcOLMTKe6++KsGSLmcsGUJA3d5dmW3zFd8DP0EoSzbdzqNRKZJ17msdDJbtdBWph+kElleXXbZ78tjqGegQKpRQFsjG7h81/PeRColrSlOoSqFM3aWULxKxe5NdzA/1hhSr/CeqQLzDNglnBYbp7iyk1zXRsnmNb/jL2w5DE8KfKr9LyKALn4TcFtxJyLARQOZnz8FgaoAjN1XDnK4Dd8A3cKV7alOP4l632rUg6wJ+ePpDJu1mVLEpFZOtwpCEqDR493Qrbi7FveItqNpjjDAymTDzdP4Eg4Fn1a+6RYIoZt2CX3zM2YX3Zr70mTHYisc4ZQZyOtoxlPKazT2QGd1R1UIdNNB2zy/1Ol8VzY8edvY0y5xJ1WtxpC6tk2K/v8b21CwVKFW2v3BU58GqC/zQlaVqVjcRVWB6uYac6ChASjQr2iTqEddMP8IehOgdsNnPXc4TGTdn6wteFN8kOJgdhCEX182nNqBBYBvGYKG+OHU0LIb9kKpTbk6DZWYy2obH7BXWtz1BzwzvihX5OUPZG2w4YsNZamT5+CNN5eDME3g5V8ESrPc8vY6A7ENXapKnFYe
 +wqEMMSI
 TvBpASVxxNW06vk0XxWQS8WQR5alhgBDX/ffLAbAhKRj7QSYlhSAwLrmjmBqJyUVAzrLZ3fekuYLhgK2PAI6LRRqojj6PkbDOLLXHylVB5hsR2WyxytUzVcy6Da/CuAfmB0a4Fg00/yV5Gi6fcbf2t2BSIfUxMgh3WWSGHwER76eCH8st1Qf3RA64V2hlIpK+K74tCymciO8jK0MYlLWecs2zE1XQEerCdo8Z8VxMSONifsdzNgqHamUYXPwKclRwdl5QFnOduATRPCEVfpTF+KBngMbukDfe3i9hDYo2sBBpmbhy4QNXdqt+tM0LiK/76Atl0ggiZPEVsqKQUvfYkLVnyqpk5W8KMh1E6as6Drh4kcT10l77p/blenNs98qRtNKfoH99uDAgFKB4hmej2aLPK0/d+UZMEnDucAP3CSPKkDL1WcRB62KsZg==
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
This change is also safe for non-x86 architectures as they all allocate
NODE_DATA for every node including memoryless ones, so the check simply
evaluates to false with no change in behavior.

Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- add commit log for non-x86 arch
	- add comment for code change

 mm/mm_init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 61d983d23f55..df34797691bd 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1896,7 +1896,11 @@ static void __init free_area_init(void)
 	for_each_node(nid) {
 		pg_data_t *pgdat;
 
-		if (!node_online(nid))
+		/*
+		 * If an architecture has not allocated node data for
+		 * this node, presume the node is memoryless or offline.
+		 */
+		if (!NODE_DATA(nid))
 			alloc_offline_node_data(nid);
 
 		pgdat = NODE_DATA(nid);
-- 
2.53.0


