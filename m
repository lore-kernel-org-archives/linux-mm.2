Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D668CC83F25
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 01:50:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BAF58E0003; Mon, 21 Jul 2025 21:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B5B8E0001; Mon, 21 Jul 2025 21:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15B758E0003; Mon, 21 Jul 2025 21:50:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 020618E0001
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 21:50:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AE2061A020E
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:07 +0000 (UTC)
X-FDA: 83690220054.23.39D6347
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
	by imf07.hostedemail.com (Postfix) with ESMTP id D793D40004
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 01:50:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=softfail (imf07.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753149005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O0xQ4qqGxlyEt4ZVbDr+/oBYi+GiAX6jpwxOUdb6AX8=;
	b=rNTvbu4Jc+nlzurwVlJZUQj0/EsJU19QbTLUA9Uw1fDSRQg2xbUUGgDBqIJqh2eyC2Mpf+
	NZzTHGwwMez9luVKDrstx9t6zqil8rxHyHECQQkCsat+Pj/m2uezzTEerrIW2UoVp172pj
	ezRQfkhrL9xt2ZRDZuJ4utUZMGXJC5k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=softfail (imf07.hostedemail.com: 205.139.111.44 is neither permitted nor denied by domain of airlied@gmail.com) smtp.mailfrom=airlied@gmail.com;
	dmarc=fail reason="No valid SPF, No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753149005; a=rsa-sha256;
	cv=none;
	b=IlAfuI8rh0zlTFFC57YtkFcTRvCvZN+R9jyjxb/q8TP2xRpf1MB023az6ZzLfFLIplijns
	yRYboGFc1LR868CXA7GuO4eSrEUrBSAApNtHwdDe7asSBhPCbF0DpzHExQPFa7Blc9JNXR
	UawNBQvDtjI5Ibi6qOFME2SyVlcmGYc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-FEF-zE78Pvmhio3CW2Hezg-1; Mon,
 21 Jul 2025 21:50:01 -0400
X-MC-Unique: FEF-zE78Pvmhio3CW2Hezg-1
X-Mimecast-MFC-AGG-ID: FEF-zE78Pvmhio3CW2Hezg_1753149000
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76EC219560B6;
	Tue, 22 Jul 2025 01:49:59 +0000 (UTC)
Received: from dreadlord.redhat.com (unknown [10.67.32.7])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7F6B019560A3;
	Tue, 22 Jul 2025 01:49:52 +0000 (UTC)
From: Dave Airlie <airlied@gmail.com>
To: dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org,
	Johannes Weiner <hannes@cmpxchg.org>,
	Christian Koenig <christian.koenig@amd.com>
Cc: Dave Chinner <david@fromorbit.com>,
	Kairui Song <kasong@tencent.com>,
	Dave Airlie <airlied@redhat.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: [PATCH 01/15] mm: add gpu active/reclaim per-node stat counters (v2)
Date: Tue, 22 Jul 2025 11:43:14 +1000
Message-ID: <20250722014942.1878844-2-airlied@gmail.com>
In-Reply-To: <20250722014942.1878844-1-airlied@gmail.com>
References: <20250722014942.1878844-1-airlied@gmail.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QmtUSY2Tm3WPeknHdUBhVdHXOVyjNht4TXLrCw39vYw_1753149000
X-Mimecast-Originator: gmail.com
Content-Transfer-Encoding: quoted-printable
content-type: text/plain; charset=WINDOWS-1252; x-default=true
X-Stat-Signature: wzt1t1xyrw7rdggs89d4m1q6hgxkcenj
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D793D40004
X-Rspam-User: 
X-HE-Tag: 1753149005-735796
X-HE-Meta: U2FsdGVkX18gFaUoGerVDfUXQdM7myo/72YgEUKroCinla/BwMlfiJr7l0pGf7egnEEvgopu3pYFvSj+c3P3J2Cn2f9R66erdrMdJq1ri3n0ZPvayZuPH2VQ3Yfg8sBkGOgZKhu9WWGxKljpR5gKf1vLACDTHM2gYd7pqaZMr6w1W9rfFZdNcxd7yYyEmoGt76a/fe9PQsfGIDEhDwrIW0VcrCyzkS4F4H6gGzJlj6/xpDvLUg2TVH6KtZB2SpQe+lmfWX9rNg8Cu/uL0xBZh3tRyBs2vY4LNf/6YRIHxta9jMp4GFYHpY5+GOyxqYuJWeYkPNs1R/AAmOX2HwZxyZyydZ3tI0dPgqoi94e9ZHdtHSI54jAVnzUZsHbIkelvBYepS0w5lMmGY5PkWyvAqP1zTIH8+SDwOtPb2KF1HWxWLRM4FZUtN+MFFNThsjFr8FkWVUfj5u/+DvRoyMkSqYwWUeJP2IL+Cyl0aI4DhFDkVui/UlMRHGySMBvxh7KAhoNXPkG2RFsgPhbEOz7/d/3VOszD6nKzuM1GAJxK7xCWACEu1BY4Q/g3b+Kobci5TqY8J3MW8iY4NOagJzwR72wpW0iu4HJSv9wYvNW9BWMOCBQya7p+eqtzk/f+HJOe2d3OssPRF88gs0n9LtQFXeD0CIg2lSGu9kyIasbm5xQaxjME898/qaZ4FtHXnRYbYps5Rvm1outW+HDaI8LcvFW5akPW3ZI3d0y4hHmM581CG5lo8yUNskUs+8+B3iCgDZmU5ZOfwjQuurJ8epgAh4C+nbADCNEuhpeejB5vaG0bi6/Uspic5IBSXI+OceOSddRROnPhKGYeljyU3Bh6FeNeMtwmgkdb1A39NH8jDIl/5fScR3nJJ3xxLfENOi+M0zavywFSQnvERkxcioc2wm2+1fbo7un0jN203B1D0Y0ZzQLxgKeyfYpZsmzPkTHscgFTPgDxvttYxt4F0Cs
 5C4l3DMY
 XxkNQvafUToDg4kwpoY5s+FSMrRNKnMhZmA2nDiW8RWY20cRY+tH9hyOvsPBoz8sb9dCC2wPPpMKbgbXkXnxHhte9rwci5yDWB1/koOQc/YN77PXlm8n5l4Qbt0GiFx/Wul09V350eUFXbxQC5wBasSeENY9J70j1z9W2V3JKoIiYjgdZYAO6dnBXKRaOi9YAj0dUYhRDnZS1z8j8pEFCb4+hTloCQG1UuSa/wsfSuiP5m8hQ1Q4GvRw/Ex9eQ+sy1iF8Bt12nFyXyC/L8/Nb+KUBMhnH1TuMNSVe3l97XTBe7OwgzzI5vL5fnASYBzIY2OzAHhpPZ28x8Dj2kV6j0d6QR0r4FDj6+N70Llnu1dwMp/XpJ5XPH3jIyGbuwUgdax6vXewGFFJRFGkTabkJ7vGyDcsP8edatoqkQLs5FdlFgCiCw3QNkxRoGS3V7yUGUTzrh3H1a11Pq+UY2OV0b1IeVuQukpFjkSQSL9q7C5wOTkhxz1YshTZucIREnyhvaPTCzwABuzl9Tv6JhSfiykBWky78V55i/nJ+pjeSe+SPvlbsjik2WoudomFPEgJA+WR/6kU1JQOqpO/eAmEn1YSNM/gvQlHGySV3u/2SHnTw/OW/9/j5E2oYWW6vmCQIYuMoYwscaqLiVlxe/HUuIQfbaFvuPBXGKV3G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Airlie <airlied@redhat.com>

While discussing memcg intergration with gpu memory allocations,
it was pointed out that there was no numa/system counters for
GPU memory allocations.

With more integrated memory GPU server systems turning up, and
more requirements for memory tracking it seems we should start
closing the gap.

Add two counters to track GPU per-node system memory allocations.

The first is currently allocated to GPU objects, and the second
is for memory that is stored in GPU page pools that can be reclaimed,
by the shrinker.

Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>

---

v2: add more info to the documentation on this memory.

I'd like to get acks to merge this via the drm tree, if possible,

Dave.
---
 Documentation/filesystems/proc.rst | 8 ++++++++
 drivers/base/node.c                | 5 +++++
 fs/proc/meminfo.c                  | 6 ++++++
 include/linux/mmzone.h             | 2 ++
 mm/show_mem.c                      | 9 +++++++--
 mm/vmstat.c                        | 2 ++
 6 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems=
/proc.rst
index 5236cb52e357..7cc5a9185190 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1095,6 +1095,8 @@ Example output. You may not have all of these fields.
     CmaFree:               0 kB
     Unaccepted:            0 kB
     Balloon:               0 kB
+    GPUActive:             0 kB
+    GPUReclaim:            0 kB
     HugePages_Total:       0
     HugePages_Free:        0
     HugePages_Rsvd:        0
@@ -1273,6 +1275,12 @@ Unaccepted
               Memory that has not been accepted by the guest
 Balloon
               Memory returned to Host by VM Balloon Drivers
+GPUActive
+              System memory allocated to active GPU objects
+GPUReclaim
+              System memory stored in GPU pools for reuse. This memory is =
not
+              counted in GPUActive. It is shrinker reclaimable memory kept=
 in a reuse
+              pool because it has non-standard page table attributes, like=
 WC or UC.
 HugePages_Total, HugePages_Free, HugePages_Rsvd, HugePages_Surp, Hugepages=
ize, Hugetlb
               See Documentation/admin-guide/mm/hugetlbpage.rst.
 DirectMap4k, DirectMap2M, DirectMap1G
diff --git a/drivers/base/node.c b/drivers/base/node.c
index c19094481630..64406862314b 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -463,6 +463,8 @@ static ssize_t node_read_meminfo(struct device *dev,
 #ifdef CONFIG_UNACCEPTED_MEMORY
 =09=09=09     "Node %d Unaccepted:     %8lu kB\n"
 #endif
+=09=09=09     "Node %d GPUActive:      %8lu kB\n"
+=09=09=09     "Node %d GPUReclaim:     %8lu kB\n"
 =09=09=09     ,
 =09=09=09     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
 =09=09=09     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
@@ -496,6 +498,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 =09=09=09     ,
 =09=09=09     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
 #endif
+=09=09=09     ,
+=09=09=09     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
+=09=09=09     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
 =09=09=09    );
 =09len +=3D hugetlb_report_node_meminfo(buf, len, nid);
 =09return len;
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index bc2bc60c36cc..334948744e55 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -164,6 +164,12 @@ static int meminfo_proc_show(struct seq_file *m, void =
*v)
 =09show_val_kb(m, "Balloon:        ",
 =09=09    global_node_page_state(NR_BALLOON_PAGES));
=20
+=09show_val_kb(m, "GPUActive:      ",
+=09=09    global_node_page_state(NR_GPU_ACTIVE));
+
+=09show_val_kb(m, "GPUReclaim:     ",
+=09=09    global_node_page_state(NR_GPU_RECLAIM));
+
 =09hugetlb_report_meminfo(m);
=20
 =09arch_report_meminfo(m);
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 283913d42d7b..81f3e368fd91 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -241,6 +241,8 @@ enum node_stat_item {
 =09NR_HUGETLB,
 #endif
 =09NR_BALLOON_PAGES,
+=09NR_GPU_ACTIVE,          /* Pages assigned to GPU objects */
+=09NR_GPU_RECLAIM,         /* Pages in shrinkable GPU pools */
 =09NR_VM_NODE_STAT_ITEMS
 };
=20
diff --git a/mm/show_mem.c b/mm/show_mem.c
index 0cf8bf5d832d..072d33a50148 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -255,7 +255,9 @@ static void show_free_areas(unsigned int filter, nodema=
sk_t *nodemask, int max_z
 =09=09=09" sec_pagetables:%lukB"
 =09=09=09" all_unreclaimable? %s"
 =09=09=09" Balloon:%lukB"
-=09=09=09"\n",
+=09=09        " gpu_active:%lukB"
+=09=09        " gpu_reclaim:%lukB"
+=09=09        "\n",
 =09=09=09pgdat->node_id,
 =09=09=09K(node_page_state(pgdat, NR_ACTIVE_ANON)),
 =09=09=09K(node_page_state(pgdat, NR_INACTIVE_ANON)),
@@ -281,7 +283,10 @@ static void show_free_areas(unsigned int filter, nodem=
ask_t *nodemask, int max_z
 =09=09=09K(node_page_state(pgdat, NR_PAGETABLE)),
 =09=09=09K(node_page_state(pgdat, NR_SECONDARY_PAGETABLE)),
 =09=09=09str_yes_no(pgdat->kswapd_failures >=3D MAX_RECLAIM_RETRIES),
-=09=09=09K(node_page_state(pgdat, NR_BALLOON_PAGES)));
+=09=09        K(node_page_state(pgdat, NR_BALLOON_PAGES)),
+=09=09        K(node_page_state(pgdat, NR_GPU_ACTIVE)),
+=09=09=09K(node_page_state(pgdat, NR_GPU_RECLAIM)));
+
 =09}
=20
 =09for_each_populated_zone(zone) {
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 429ae5339bfe..25a74cf29473 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1281,6 +1281,8 @@ const char * const vmstat_text[] =3D {
 =09"nr_hugetlb",
 #endif
 =09"nr_balloon_pages",
+=09"nr_gpu_active",
+=09"nr_gpu_reclaim",
 =09/* system-wide enum vm_stat_item counters */
 =09"nr_dirty_threshold",
 =09"nr_dirty_background_threshold",
--=20
2.49.0


