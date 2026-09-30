Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B655ECA5FC4
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 19:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4BC6B008A; Wed, 30 Sep 2026 15:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C046B0092; Wed, 30 Sep 2026 15:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8A66B0093; Wed, 30 Sep 2026 15:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AAE56B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 15:52:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A626A1A0101
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:52:18 +0000 (UTC)
X-FDA: 85271475156.18.64A0EFB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 08A2E80010
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 19:52:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxHcC5Wt;
	spf=pass (imf02.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790797937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YWrKUyDQfGPBFB++iIVHEuhs9Rh+LXrjwZ4LQ5+swnM=;
	b=LEewgkYjAoB0foA39dajSIqZ1qsCzcG6ScR/B80wdYo12L8nPXzbQkSYd2o+Flle/SVb3M
	bOcSJUm04/J4ofFMmjq0X2dsFJ/n13Kd334VcK5Ox7yZ/9x4UA7TIu1n2p5BENktHTuJFb
	L40EyHwpvA8q3Flt4lJG5W5aRJ245vk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxHcC5Wt;
	spf=pass (imf02.hostedemail.com: domain of kaloz@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kaloz@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790797937;
	b=pD1ReWtXor96Zmdqtp0iRDe5R5qciMWAuXsgchsjKwDgyP83H0o0YD0TLFjIvYyiyh7cyz
	x5BVNsdiyhErBbvJxuuBnlmqBNNXm1y0/2wv3xxo7kYA879v0Knue4U45dHNS5oUInDK5r
	zXCBrZ32XZPfVrIQ1ehVrYEocE2IS7A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EA29843356;
	Wed, 30 Sep 2026 19:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E7A1F00898;
	Wed, 30 Sep 2026 19:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790797935;
	bh=YWrKUyDQfGPBFB++iIVHEuhs9Rh+LXrjwZ4LQ5+swnM=;
	h=From:To:Cc:Subject:Date;
	b=CxHcC5WtExILPkw1rNFX+85Dp0tqI5hLryNGXGobIt651WEBvh++61jlHJacRjW4z
	 OzwWXinJxpRZLc9sTLIvQyhk/jcfGmpaduajvRhmtKWTPd4kKY/e66JjwL4cC95ckA
	 r8gNP2z8EMJT0yIcCRofVEcdbJSOLjpxK30s1Yju7OBenQoIvRnI4lE5gESFI5XXxh
	 /aClYn4/8X49KyTAPqDiCOBbMmT3kNEqVLJDSuWr0kfSup/SzZ3qDAwKf1Mv16BiOn
	 xD8y/aATxfsFyGTgyT/q0VVBvunyytRDx4e/NHET6PT3+O5gnjn7uvWgZvXzeiQga+
	 V7hYcqoV6fAUA==
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
	stable@vger.kernel.org
Subject: [PATCH] mm/slab: sample slab_state once in kmem_cache_destroy()
Date: Wed, 30 Sep 2026 21:51:09 +0200
Message-ID: <20260930195110.13296-1-kaloz@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08A2E80010
X-Stat-Signature: sjajni94e97ay5obg6aekow3y3wjp4mk
X-HE-Tag: 1790797936-206106
X-HE-Meta: U2FsdGVkX1+6uqlrFuIsIRLuDPergLzc1BphguVd3Np9y3LU/aSbRDTuoHBx3RzRgisaNPLvmxBJS9hefzaHKcVRehlUyfm3XOT1iMeqfaEqlS3QzgN6iKE44VrNfvmb8TdZgV+ti2kaeo8IGk3LRe10N+HWa0jqq3F9fKjQqUxl3IGLbM92t/7WcDXpAfM9ylUVNHqYRQEcpAIf2l26IgbqpivI02V77cR7p+m/axzKhxW3XcH+sESRU8KiadiNb7I30mPYeByciWWKl8e+7p/EKlxpD9U33D5UcM7SrXZfYzxBgDTCaK8Af+ucBGcUp6WkcLY9klLNkC0ZyxCCaB4ornSc/WYAqEiJWyDug/CYoczqp/Q4eTuKEuzjU0qJkCea3PiWwrHn+H3+dCk1wks6MVpAfQpeJvL+2O8t2RqbZC12zr6OGDmcqh1DLF97n83h/53NAMhO26CVou3+dbL+ORvB/kAp+Ai8LiyxRSvyUODnkXrBm9Aq8ccpNNKoJgZTFu84QA8Sa5idHBAWPoMTBXb8pjT7cSp0846xJxeJmbJOldIVram4y5qRvL46W+avude/FNx4RYiFk5jPWxAximxDXacu5iGXi7bx1D//Ve3jdj3gCJrI6rjoSy70WhGQmyXi3lM6dc5TOXHcvNCr14+N4zAXElBJ7rqbEQDq9o7G52B3v0m+4T01dAwNZ4eGzwBy1LL2Nfi4e+3RzBuY1LxHjzgYuoykeUkSJ+aIBFgI/WxLgREISRRXCR6aMW9oasnFNetRSfaFVyp0KEC7Y001j6FXcQ8CyxZPERCZoMQ+LbIVaKB/8BlKyXRmMyAIkHQAhU5ABm80RIU++KnsUznmFnxhI1hgiyRl35F+CpPoBhG8V7L1yIHwCdiBM31rrRJ0nnaJy7PGbInlcx6r/o+jo9SFFGH1ozFkvLMXkXqqxv3A25ZdW6Qoqr3VfBx/cjXmBeukj969uFs
 gokdGFDM
 86AaaiazihJkO7F4XcAwkANdMxC6bCfF1Y9bkwLpNinvWuvwD7RksMTFFHrJXwu220EMMdBXAW5SLtqC4Z68zELF1XsIOUnrQYON8F75NLx94MxEjQIxB8Fi549sjjQupU88tdKoeIAqxHWfXZwgey+bH0xoEjXj9QUPJWPr5V/tpOgPmPRewI0WY0PzKq+OA0Q9Cpiv9lHuJ6IsVKJ4FFVh1Q9vH5JTdrCn2RVNjG+WocxdgxnLR/65GEQjfeOiJowvnqSo0OQitIiuUSfultLhB6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_cache_destroy() tests slab_state >= FULL for sysfs_slab_unlink()
and again in kmem_cache_release() for sysfs_slab_release(), with the
cache already off slab_caches in between. If slab_late_init() runs in
that gap it sets slab_state to FULL but never calls sysfs_slab_add() for
the unlinked cache, so kmem_cache_release() ends up in kobject_put() on
a kobject that was never initialized:

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

Seen on sparc64 at boot, where the asynchronous floppy init tears down
its bio slab while the late initcalls are running.

Read slab_state once, under slab_mutex which slab_late_init() holds when
it sets FULL, and use the result for both the unlink and the release.
The kobject flags (state_initialized, state_in_sysfs) were considered as
the key instead, but slab_state is what cache creation and
slab_late_init() decide on.

debugfs_slab_release() is not part of the race: it only looks the cache
up by name in the debugfs root and does nothing before that root exists.

Fixes: 4ec10268ed98 ("mm, slab: unlink slabinfo, sysfs and debugfs immediately")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
---
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
 

base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e
-- 
2.47.3


