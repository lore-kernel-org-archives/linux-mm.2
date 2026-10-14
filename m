Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94DACCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:09:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78ECB6B0088; Wed, 14 Oct 2026 11:09:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717C56B008A; Wed, 14 Oct 2026 11:09:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF1F6B008C; Wed, 14 Oct 2026 11:09:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 316246B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:09:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9BCAE4059B
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:09:54 +0000 (UTC)
X-FDA: 85321566708.07.0A2801D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE5AA40002
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:09:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lROYBOm5;
	spf=pass (imf07.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791990593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nPHLR9bYg/QZflrtwH8ufJo1Nfz90UGK6o7IybcntJo=;
	b=d/LA+eCPDepUpr0znTEZEJLQ671UNiDHZJDHk1gp3135s9Y0sKD7k8KU0IDPhFQ2UeOwu7
	l5v9eR+rPV4GJtjhl13xfcIjmh1QlTNDjmXM5XNxRoUsiQt3z927MRh+0KAY1AXqe92dvq
	Tu+TmNKrL+Mm+Vm3Tf3MiR9pIM+B9As=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lROYBOm5;
	spf=pass (imf07.hostedemail.com: domain of kaloz@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791990593;
	b=DcjC10zIkZwrHg1q0RQcDI20sE4plchtDyTU4oKs2BhraogPUEEcCaX+rPODO/sE4bukvv
	0K3Y9ULQhnzXvWmIGs28ItnX1Q/JSBRmru1QhP1HorqkJrE94TAMLyetPbJejd2zspm+Nq
	gnF1aq/IN018yHXlGFSdJ9EZ6VEmthU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 52573600DA;
	Wed, 14 Oct 2026 15:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA111F000C4;
	Wed, 14 Oct 2026 15:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791990591;
	bh=nPHLR9bYg/QZflrtwH8ufJo1Nfz90UGK6o7IybcntJo=;
	h=From:To:Cc:Subject:Date;
	b=lROYBOm5BZAj+QLmXazpo/oVVQ0JUIoyqxflq4V00f1yZWLjcQtuRfOnug+NohuHe
	 kmK3BDbqB7VH4LOQiZXRZrt+s/5g6OlqD0ezNLDZrz2CSDonBPaW4t06tK375GvDC8
	 3X4Z+ajqmhREtHjDjyR6PwGbPUw7iFKxnGMeI58SYGFTMR72k4WBcuow3OnWDPFwjp
	 1rN7w0XzCmcpTxRMfODsIy7lqLFcG3muqNOBU2Tk/S+1v837KrgK/VBsLlo3eH0XKs
	 GIy8SjnQQMZIcQslNKqY53L7gmNtTkWrNMji9xoA42eKPmAUQqdzvJxYC3dPOp+1qe
	 WpX6Pnhq9dOVA==
From: Imre Kaloz <kaloz@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	"Jose A . Perez de Azpillaga" <azpijr@gmail.com>
Subject: [PATCH v2] mm/slab: sample slab_state once in kmem_cache_destroy()
Date: Wed, 14 Oct 2026 17:08:43 +0200
Message-ID: <20261014150844.8536-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE5AA40002
X-Stat-Signature: auc4zjofdwomp13efmi1n4smdgexoxts
X-HE-Tag: 1791990592-45981
X-HE-Meta: U2FsdGVkX1/4+PsNOoku1VX+ZlXy5uJURx8Kp9Hr8Rw+sA2o3uIZ3PTYM9J1o33APCvmSXC77mUrNTILP3qhHsTUqzp/g37WJTYbKjsxs/QaXwpu1GNYgg06rHDs3CdXJlL+jflJu9JZb9jvx7hv8HRTVvToo2WEela+AdOKBELtM7rr1l5RKT7GfZpqcAvgrCrdP6Nr4ZbQwLGsMGW435cwIC4TzDqV9TrbuZjY71e23sjsUZ8hh5cG4ZCq2rcZggDTczR7ZUKeaVfNm3N8aS1d+6uUcQhfuWZ5sl/nYKX6DRvk++pvdDT/JdC6y0zF63fYWfAraPwhJm+dkGQ+NexnngvtyWnSw28NxRznqSCw7khAeArNRfr8KL5yKAJcpcOz6GJ/pRVhdwznZIix7OGzR5A9QIM8Bo6dczFtHRk9Cekl6lhkVO7RW5knZ0/6Dvg06s0YuBjuElnxGGQSYQ5MribdPgiGy9ki6lsErJmIc/dhcRMlCpRtmPtcJ0M7vObvUQ86dg7fQFPOSIpXzWkDiHXEgGCMTNe4EuKzQmlMSWbgbSBJETL4XhNahMIRU9hPpMVgBb+YGz9t3WsgkhJnTmLuGkKioRixwuLXMSk0oY638VkhQBhKWfaBf4lWjVEwneyK5ILMiz01a1SDYR47YovoFE1rzT7JAftnTy174esxGoQ6umeoDsCp00CIh1TDXUYTjH614ca8qXpM+DbPf0gh56gHmCxeFZ58WZPgZLspfk8p1RaluS3m1YxMn7DJK3d1ze0HmVg1rRhdyHMjzlCyrDIeqwaYMYsEdNkKMw+rSI4ZsBWX6JH9mgc6YqmFRVZAdcxxVD3qMnjopSNOqnd3AkyZPkxMGnhjy3hpqQOMmAUnakfC1fmXRLaDM5/UvY6NzqwZFdtR0fU/YgtEmTqdtWbAj5hYEE5wUC+0R/+oVq2NkgxV07+x+z0Rh3W913OzO17jl3odtVs
 ckcS5vYr
 86gS9IHLBFW1/VQ55Vvc5iYUzdsSfzL0K46hEWPJGZM3gEv3cRUlp9mU7dBI0oTnHxk1czZRx1Au+pf4b2//zTU7n3RSQPoGBrgImjPYjh6VpfniFzEqZ/qYHdh+nzpidLdxezjhE3kDUpmYz8dKv0EDA10cZasxxU7bucLFzS+AuTVYawBxLxkEXjcQ4PTk35J3C2W1sr3SKv0HcHtgckBMUjXbKZxBvyqocfTedblRMFFZuFQEEV8+3v3L43+d2tTjt/xTSIAYMiK9p/bc8Ip9XleUiAkTIunkVJSaTxKlvujXItmeT64ipXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_cache_release() tests slab_state >= FULL after kmem_cache_destroy()
has dropped slab_mutex and unlinked the cache, and for a
SLAB_TYPESAFE_BY_RCU cache after rcu_barrier(). If slab_late_init() runs
before that test it sets slab_state to FULL but skips the unlinked cache,
which never got a sysfs entry, so sysfs_slab_release() calls kobject_put()
on a kobject that was never initialized:

  WARNING: lib/kobject.c:734 at kobject_put+0x64/0x2c0, CPU#1: kworker/u8:3/55
  kobject: '(null)' ((____ptrval____)): is not initialized, yet kobject_put() is being called.
  refcount_t: underflow; use-after-free.
  kobject_put+0x64/0x2c0
  sysfs_slab_release+0xc/0x20
  kmem_cache_destroy+0x104/0x1e0
  bioset_exit+0x13c/0x1e0
  disk_release+0x54/0x140
  put_disk+0x18/0x40
  floppy_async_init+0xbec/0xd10

The release-time test has run outside slab_mutex since at least v4.4 for
SLAB_TYPESAFE_BY_RCU caches, and since v6.0 for the others. Since v6.12
the unlink-time test in kmem_cache_destroy() is a separate read of its
own, also after mutex_unlock(), so the two can disagree. Both tests ask
whether the cache has a kobject, which cache creation skips while
slab_state <= UP. UP is the state just below FULL, so a false sample
cannot skip a kobject_put() that was owed.

Seen on sparc64 at boot, where the asynchronous floppy init tears down
its bio slab while the late initcalls are running.

Sample slab_state once, under slab_mutex which slab_late_init() holds
when it sets FULL, and use the result for both the unlink and the
release.

Fixes: d50d82faa0c9 ("slub: fix failure when we delete and create a slab cache")
Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
v2:
 - Changelog reworked around the release-time read outside slab_mutex,
   with the separate unlink-time test as the second read; Fixes:
   d50d82faa0c9 added, as discussed with Harry.
 - Correction to what I wrote in the v1 thread: the release-time read is
   older than d50d82faa0c9 (the RCU work function had it from v4.11
   until v6.12); d50d82faa0c9 added the unlink-time test under
   slab_mutex.
 - Added the explanation Jose asked for; his Reviewed-by from v1 is
   kept. The code is unchanged.

v1: https://lore.kernel.org/r/20260930195110.13296-1-kaloz@kernel.org

 mm/slab_common.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 7223a7596dab..de11edfd1a0b 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -515,10 +515,10 @@ EXPORT_SYMBOL(kmem_buckets_create);
  * and release of the kobject does not need slab_mutex or cpu_hotplug_lock
  * protection. So they are now done without holding those locks.
  */
-static void kmem_cache_release(struct kmem_cache *s)
+static void kmem_cache_release(struct kmem_cache *s, bool sysfs_ready)
 {
 	kfence_shutdown_cache(s);
-	if (__is_defined(SLAB_SUPPORTS_SYSFS) && slab_state >= FULL)
+	if (__is_defined(SLAB_SUPPORTS_SYSFS) && sysfs_ready)
 		sysfs_slab_release(s);
 	else
 		slab_kmem_cache_release(s);
@@ -533,6 +533,7 @@ void slab_kmem_cache_release(struct kmem_cache *s)
 
 void kmem_cache_destroy(struct kmem_cache *s)
 {
+	bool sysfs_ready;
 	int err;
 
 	if (unlikely(!s) || !kasan_check_byte(s))
@@ -580,10 +581,18 @@ void kmem_cache_destroy(struct kmem_cache *s)
 
 	list_del(&s->list);
 
+	/*
+	 * slab_late_init() sets slab_state to FULL under slab_mutex and adds
+	 * sysfs entries only for caches still on the list. Sample the state
+	 * here, so that a cache unlinked before that point is not handed to
+	 * sysfs_slab_release() with an uninitialized kobject.
+	 */
+	sysfs_ready = slab_state >= FULL;
+
 	mutex_unlock(&slab_mutex);
 	cpus_read_unlock();
 
-	if (slab_state >= FULL)
+	if (sysfs_ready)
 		sysfs_slab_unlink(s);
 	debugfs_slab_release(s);
 
@@ -593,7 +602,7 @@ void kmem_cache_destroy(struct kmem_cache *s)
 	if (s->flags & SLAB_TYPESAFE_BY_RCU)
 		rcu_barrier();
 
-	kmem_cache_release(s);
+	kmem_cache_release(s, sysfs_ready);
 }
 EXPORT_SYMBOL(kmem_cache_destroy);
 

base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.47.3


