Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6712C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9C626B0098; Tue,  1 Sep 2026 23:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45C46B0099; Tue,  1 Sep 2026 23:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E246B009B; Tue,  1 Sep 2026 23:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A30606B0098
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:28:50 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 33DCB1C2513
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:28:50 +0000 (UTC)
X-FDA: 85167390420.01.5C3D336
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id A55A01A0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:28:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jciDB06X;
	spf=pass (imf19.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788319727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pMvIKLAGFtBlf8v0ZL0jUkwTBxIKdH+TsX1qwT3x62w=;
	b=7Ta8s8I2zYxJB/TRO4NdiFu6KpORxdVBG/uXfr5SHz3zZ/m+NGCpThsZHmCXyDD/NpxtDe
	p+9Hf4crjNYeoXAKxo1am2/CoXnpD9XvhMDopMQ0mNIzxHRu7+xRCVbIjIzcbaCKvE6JsN
	dnrb7TMun/Aftp6dYs2889vAgO80784=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788319727;
	b=dUXOzPk7+CVCq7uq7u3wnlCYCpdBD2d+GX0Se0oyq6PW2dSzycNLNXu4FRf5JY1hTTS+Dn
	1qBqNbGG4dql7JvSMG1M2q4SdR3Kv7WuEZwibbNBbfARb96u0kOgLW2+JAzXVtgM1GRn8M
	0GZG7HA0UVmdb5uUTr/aeJFkLOQhJN4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=jciDB06X;
	spf=pass (imf19.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788319723; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=pMvIKLAGFtBlf8v0ZL0jUkwTBxIKdH+TsX1qwT3x62w=;
	b=jciDB06XBViAdt9cHnHT1o69SfhYujgcGby7qdl/8JlTaVvEuuk1YhQf35ZjyTlMqZojz1evNCc/XnW55yjhHL79pL7lWw4qyCTna4mAihKxtDFW6c5oKtgzfKN3DL4v/Wmgf2JDy+ytzwyK01irsBQtTab0LpYdpCP7ZliaWY4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0XAB4RlG_1788319721;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAB4RlG_1788319721 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 11:28:42 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH] mm/list_lru: disable memcg awareness under cgroup_disable=memory
Date: Wed,  2 Sep 2026 11:28:40 +0800
Message-ID: <20260902032840.30250-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A55A01A0003
X-Stat-Signature: m4pwqmbqmj1ysx14cxw9kw7y5t4xxunx
X-HE-Tag: 1788319726-586888
X-HE-Meta: U2FsdGVkX1+5cxtWQjSeMkHsztI4a7kV4F4p96xmgigsPG5dN66MgU+R/ll2lMfY2RF+w0GHPjXUz+quYnKsmDCwZwOLe7XcRYeGznU7v/Q6WTnr6AknV7xFoQlsw5JokxDVLanNIhvZHYeLoQY4jF6W98QRp228V3mPD/QtIWeAb/g36sRfGeCIFYK6dhxFygyE/irtZafS+sUZ6FMG4W1CthXd3mwtdoSE0ue/8jmplWZ3nus/UmjsXhf6L3+03OlFp2ldjZX/ee5P80XJ/mGgIz4gCmIhKTM9c7cmfo8KXlOLzHtPsdy56PedJJk/LLnq2iSD6UEmsBLBUtw0UIe61WfW3VxJ6Ts682i0WArE792WkAUzFbnQU8+3ZUkxuoJEmKc/0jsySAOCYvedOol42qfgXXj3tiMrlOf/7wb7gDaVe/xHSnX7tBDMAPX/pNNLJbrGb9yJGW2PCYqFZn0t9jhRVNygAnDRwItv0fqE/gJHsCiiJ4UwNwtpASe7iNJ5YdjYtzPEvef0ZxKC+S11AESGQfFcez828HQjk/vlgWxWubU1Vno6LwSyV0Qj1kezZgPtdoZSdVaW8/WGhUKg2EGRMOTxChJLfE4QCBP1uMsXZ+bvJD/hghSkopoEuddD7w80v31//CV3kOO/kYbYciLGUgBLQ89TXt0VKCSTfB236wt0HAWos4xaG8M8kR8tGIJa4dGZIArsUWZ2LKTV7ibNu/59V38tXkCxUf5Eeo7tgp9fCV6251yf8myS2vqEl7EnkH67qNihpo+TgBgytDJDwLhqOTzz9fOEAcPphPYvRJI3em1aa/qc7YRvAfEuk0/FG7ERGsIwVS8cm1QSP2T6zgWp3ou9A7Y/6LtkcG94dgR2Sl8owv34eQTNGX9MS0YjsxfNElibES4alLR8uBC3tKz8k6o79yNRKSXiUVgu95OM97r0ilAFaoKuQMKCbbpbBRUAgLjaZ3u
 n9UkAFv/
 YN4KZHBCpXewb3zUmjBJvAFm2VgDptzeQ0Fv09Y9KnrcHtCQuxBnvBgH7qIDXaZk2+5+RMblNgS1uXI9fl6ET1q/7YrDrEl300g35cB0MpTxykJ4Xww+SrngUvI+0TW8im9pZAPPPyTQVux7OYn4XiTt1PsrkPIuWMAIptYvX35x6l9U46cFVEsr8AO3FV/APs09PO6ijgu9kDhctRhzP8bpozWpGUx+Rd5iqVg//MCk04nOrUPj7w+9erWsNB0ea9FfcuxSs83PF2BpeHCapM/E6M6e5kWRGF8v2Q9r9D87C9hFsBdhKWD65z8OkI5prEwx5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__list_lru_init() only collapses a memcg-aware list_lru into plain
per-node lists when kmem accounting is disabled
(cgroup.memory=nokmem).  When the memory controller is disabled
entirely (cgroup_disable=memory), mem_cgroup_kmem_disabled() is
false, so the lru stays memcg aware even though no object will ever
be charged to a memcg.

This is more than a semantic inconsistency.
folio_memcg_list_lru_alloc() trusts list_lru_memcg_aware() and
dereferences the folio's memcg, which is always NULL with the
controller disabled.  The only mainline caller,
folio_memcg_alloc_deferred(), papers over this with an explicit
mem_cgroup_disabled() check.  The shmem unused-huge shrinker
conversion ("mm: shmem: make unused huge shrinker memcg aware") adds
a second caller without such a guard, so booting with
cgroup_disable=memory and writing to a huge=always tmpfs oopses:

  BUG: unable to handle page fault for address: 0000000000000488
  RIP: 0010:folio_memcg_list_lru_alloc+0x41/0xf0
  Call Trace:
   <TASK>
   shmem_get_folio_gfp+0x1cd/0x7c0
   shmem_write_begin+0x5d/0x100
   generic_perform_write+0x89/0x2a0
   shmem_file_write_iter+0x82/0x90
   vfs_write+0x256/0x410
   ksys_write+0x61/0xe0
   do_syscall_64+0x8d/0x460
   entry_SYSCALL_64_after_hwframe+0x76/0x7e

The faulting address is the offset of mem_cgroup->kmemcg_id,
dereferenced on a NULL memcg in memcg_list_lru_allocated():

  folio_memcg_list_lru_alloc()
    list_lru_memcg_aware()               <- true, only nokmem checked
    memcg = folio_memcg(folio)           <- NULL
    memcg_list_lru_allocated(memcg, lru)
      memcg->kmemcg_id                   <- NULL pointer dereference

Check mem_cgroup_disabled() in __list_lru_init() so that all
list_lrus fall back to plain per-node lists when the controller is
disabled, matching what the shrinker side already does
(shrinker_memcg_alloc() bails out on mem_cgroup_disabled()).  This
makes the mem_cgroup_disabled() check in callers unnecessary rather
than mandatory.

Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
---
Applies on top of mm-new.  No Fixes: tag since the commit that makes
the crash reachable ("mm: shmem: make unused huge shrinker memcg
aware") is only in mm-new; no stable backport is needed either.

Reproducer, on mm-new booted with cgroup_disable=memory
(CONFIG_MEMCG=y, CONFIG_TRANSPARENT_HUGEPAGE=y):

  # mount -t tmpfs -o huge=always tmpfs /mnt
  # echo x > /mnt/f

Without this patch the write oopses immediately as shown above: the
freshly allocated huge folio extends beyond i_size, so
shmem_get_folio_gfp() queues the inode via shmem_unused_huge_add()
-> folio_memcg_list_lru_alloc(), which dereferences the NULL
folio_memcg().

With this patch the same steps run cleanly: the lru falls back to
plain per-node lists and folio_memcg_list_lru_alloc() returns early.
From code inspection the rest of the shmem path handles the NULL
objcg fine (obj_cgroup_memcg() and obj_cgroup_put() are NULL-safe,
and list_lru_add() with a NULL memcg lands on the per-node list),
but I have not exercised the shrinker reclaim itself under
cgroup_disable=memory.

Discussion: https://lore.kernel.org/linux-mm/20260901115104.2944996-1-qinyuntan@linux.alibaba.com/

 mm/list_lru.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 36662d02ff963..f8be119351cca 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -671,7 +671,12 @@ int __list_lru_init(struct list_lru *lru, bool memcg_aware, struct shrinker *shr
 	else
 		lru->shrinker_id = -1;
 
-	if (mem_cgroup_kmem_disabled())
+	/*
+	 * With the memory controller disabled entirely, no object is ever
+	 * charged to a memcg, so collapse to plain per-node lists just
+	 * like under nokmem.
+	 */
+	if (mem_cgroup_disabled() || mem_cgroup_kmem_disabled())
 		memcg_aware = false;
 #endif
 
-- 
2.43.7


