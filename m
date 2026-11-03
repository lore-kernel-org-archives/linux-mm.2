Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7639C606D82F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=bGzRCBgO
Received: by kanga.kvack.org (Postfix)
	id CF2376B05BD; Tue,  3 Nov 2026 04:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB6E86B05BE; Tue,  3 Nov 2026 04:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A31626B05BF; Tue,  3 Nov 2026 04:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4876B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F07B24037D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:11 +0000 (UTC)
X-FDA: 85393339542.10.7B60C77
Received: from mail-106113.protonmail.ch (mail-106113.protonmail.ch [79.135.106.113])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8DEB5C0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=bGzRCBgO;
	spf=pass (imf28.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.113 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699470;
	b=Zg1cw0aaV3rbc9kBAyVv4EHX/0qC6sy/X678A69DWUjx4+3Mje2cM3eQLa9DT11C31uzW1
	kCiTpDRyp4pQSR6PKoAYryyWNEIe/cheDuPy8R+6U9xHSWCx5w5VxCKwo9rl/pz8kgyaLq
	89ngdPwxq1IfyOkL6rUYZDpCQMDroRM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n0izxb44Tb6ZcYT/2j2uerBqWsRV3gsMQEbz08hfe1U=;
	b=Y98jj+ta1rwSjvP9F553MC08E3HHR5pwL7CZQg1vBvOW1Da5G/NR8JsjNGiiHBZRKvWMeN
	H4OLCrYx2OTWpUWjSfuwVxPnJ1dZliG4TROCUbyjIZDbkhnUjfjzNv5H9t+jPEu5rsCf7G
	gEhGh0ZLbcix3zoByGJ6p9F4MmLLwY8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=bGzRCBgO;
	spf=pass (imf28.hostedemail.com: domain of nick@karaolidis.com designates 79.135.106.113 as permitted sender) smtp.mailfrom=nick@karaolidis.com;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793699467; x=1793958667;
	bh=n0izxb44Tb6ZcYT/2j2uerBqWsRV3gsMQEbz08hfe1U=;
	h=From:Date:Subject:Message-Id:References:In-Reply-To:To:Cc:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=bGzRCBgOlGl5IkST58KNWO+zPtfNt+7yge+PMnNmyp58ZbihcR7YHE6zzpx0SlCWq
	 J7Fa0nBUotb8bCFPpXUUmiNxFGuTjQ/LHTRznfPkRv+afoKVWACHGu22DMF6j8nOj1
	 U2IsemJvbIjDJOuy692hNoF7RdBjfdf83ua4pwjtaRXEXMMbo6SbRcJ8anOgtXqCIg
	 Wn2CTB3yp4rYKNICepkdZGT17tSFDoaGbhduEVijzmNCBGyS7/dlfZxBhcF8+v8NCl
	 mVj7xZOSzl5Qhep4W60Rk46CYZacE+QWeTPpxJqJPLUqftQlKeJLV21rj9vb5KYekK
	 3fxJxgJ2fzblw==
X-Pm-Submission-Id: 4jJkNR5Ckxz2ScjL
From: Nikolaos Karaolidis <nick@karaolidis.com>
Date: Tue, 03 Nov 2026 09:50:11 +0000
Subject: [PATCH RFC 5/6] virtio-mem: support memmap_on_memory in Sub Block
 Mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-virtio-mem-memmap-v1-5-308ae1da6240@karaolidis.com>
References: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
In-Reply-To: <20261103-virtio-mem-memmap-v1-0-308ae1da6240@karaolidis.com>
To: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>, 
 "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
 Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
 =?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, 
 Hui Zhu <teawater@gmail.com>, 
 Georgi Djakov <georgi.djakov@oss.qualcomm.com>, 
 virtualization@lists.linux.dev, linux-mm@kvack.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-cxl@vger.kernel.org, Nikolaos Karaolidis <nick@karaolidis.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=15005; i=nick@karaolidis.com;
 h=from:subject:message-id; bh=ejrHoLip2+a2DhjDlP0E189C2WOueH28ndxahaQkQS4=;
 b=owJ4nAFtApL9kA0DAAoB2mjImL9M9YgByyZiAGrprncgYfC2UCVe2FE4WXCcdYs683Ums3Q3S
 cYuR4R2gqJLd4kCMwQAAQoAHRYhBLMZG7EWqsMYjymWX9poyJi/TPWIBQJq6a53AAoJENpoyJi/
 TPWISN4QAJzesyJhDnDc6VDGOH9jOc5bVhaRWDYchodEYnO8XTEbwEwCQesF1pbZPdLhiKU2qpw
 Vp01AbwCZA62v8Gq09c8SBS3sIngOUtCTmm3BeRVIIA9AMS44O2OniRuditWsI3Ey+Qi7FIuaUw
 O0MRjqNMyz0dy6jRb7+9hhreC4ydlRV4O7rfgtRyD6WAaI5ExnN0QPIgwrKfigLE2ggEp5o5hP3
 tfkPnrnl90XTaWQm1JacQWRmS9NcACBzrsWQTcjvFLtBsBJOjrkZNW7ftTQZ9Ex5VGxAFLPKHb6
 SBEmTOmYn2aXJKqKLy6Cxcwqqn6PrjH0U4jr9F4K4nJuoCIH8uZye68DnWwqFlZHYj+X1dr6MNu
 GdpsRHB5yf8hAsKAQvL4eJWSe1jpUEIwxfj/0uIe0KaZ9RSvGqWh/NH539X/WFtZ+B97m0MzTgc
 05fDwQPgMoR4LXeC+vHLfaGcTuD1MyDyZzKZRQNzYrbqP4gLMBzKYB3dV9wSGekfXDDD1w+UdPC
 I5rdrZGUXOY1J0s27r0zZZMLQP9AL9unUj2zCCq4Rlwrm+7NSUJYeTdU/eibjvama1gW7bkZ1YU
 cxAfCzZawq2e9N5yFXzIhoSdlW8vvt/NuSP8HWYzH5T2ciPqhDCfEHITvaNDsUQXfnmpCU67Id8
 j8dcp85oj3qdApYYO/T8fyQ==
X-Developer-Key: i=nick@karaolidis.com; a=openpgp;
 fpr=B3191BB116AAC3188F29965FDA68C898BF4CF588
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: f9nqr1fpkog5au8tw9crry8ogrq36wwa
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8DEB5C0008
X-HE-Tag: 1793699469-845948
X-HE-Meta: U2FsdGVkX18Vw14UuK9gDGBoElUyyCKrG5Ps2XNxCTXiwSBccxi1fb+rY8SmQycJCUwCkM+ifT6yBZex/rIBBWRZR3q1mW94MqBRunh4DRiW/4HDWyP++jbX3/9QKrmBBKtRbqx8fngP+9rlrAIrZLdGI2N+3Ueupm1Sg/aTYX2EsuYyDaK0nYwH/qugPp0IFRuexBj7bBtq2I2NptQTM37hpeB5y7q4Uchh7lDlZNQq1sPexqNk63+CKupBsHmp8NZL5i9EhRAH3vkuUvB3yD676UqSJN2bLCn9o6aLpvgI4jYn9DbJI6Z2XUOqqNhYpo3YSErntsUyi1GRE5oIAEVTuDs33MojGWc7zNumUj40hQQ76+cvJBb9FugRrn+XsRbCa8d9iuXIU10/1M4Bo/uOFgsLuM72FayVfFnnRzdCo2hDHInAGsQV/2jqZJMmMggEAOuf/VdU1KxRRDNMh6kLtgTAMfsFrfDk/vUE6jow4R0Uksgpz+knaFcC17Rl9MphJrem3Pk/pmz77FDT0FICna7ubmcgRnbPK0L518wEDUpkJ6AIrxpRjrfoJ8HkA4cgv+QMC8Ylaa1QDlImPw31znjDZpxDjhQtveauH72Lm+ZmU7dLqx4p7uyYBlP5psC9Z+oIYaCJJqc1SMyigNfmQaajIH2Kc82peslneouxwTTAWM/dKIHcKDhqNy9+DrxQo6YNaIZU8vxabfinQxQtgzwKRu787/F/oUooePaZZBCEiYp3fmC06YbtlBFnUNTG7rrZGRMnY9ln4frcVaBD6T6kZvAsEnDBxxpHCovpMiWFo2OH2VI7uV5vgIDksNyNxHIzsaqer0ygPGq25bzmmbJGqA7XKhtQ+4GtbuthLHlmhp89gTsEo+gT5/qsiVFHuh2/4w+ZBry9Roek3z4v4q/Osm7dE1PcKrYOpl74lbAfXE68G6k9BG/0SwzsG9vqtLomLOHnKQteJeO
 zxUtKVJ2
 l25DQU2KHcEgBcdsU1gVfw6+m9kyoalJ8n59AaV+1JVy9vAUBzg8NtOtq+oD/hHp4KFEbh9eqFulmZySeS4YEmQxS/sv2kPq24SKpj8697dYmsPTcKRkj8EBfkgN+iQ+kqbiaQDB8a6hcjBymcGNrBBFZ8yf0MmFJdHVL/7t4pxNV6Y6Y2BsXtYnJe6bKrxfiLB7MOrr4iHeYxEVuKJNtazfdVI8sRb7BuseKzaKGJLT1DfivVSA5C/okO0HyFx2cZWhmvtp2N9cdwFZqNk7ezVmhaX3WseWCYdqo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Forcing Big Block Mode to get a self-hosted memmap would raise the
plug/unplug granularity from 2 MiB to 128 MiB on x86-64.

A self-hosted memmap is written when the memory block is added and
never reaches the buddy, so the subblocks containing it ("memmap
subblocks") cannot be fake-offlined and must stay plugged while the
memory block is added.

Only support a memmap that spans complete subblocks, so that the memmap
subblocks never provide memory to Linux. That is the case if the
subblock size is not larger than the memmap, as with the 2 MiB default
device block size of QEMU on x86-64. Otherwise, for example with 4 MiB
device blocks, or with 32 MiB device blocks for a 4 KiB arm64 guest on
a 16 KiB host, warn and continue without memmap_on_memory; force_bbm
can be used instead.

Handle the memmap subblocks as part of every added memory block:

* Plug them together with the first other subblocks before adding the
  memory block. If no more than the memmap subblocks remain to be
  plugged, stop short of the requested size.

* Skip them when unplugging from an added memory block.

* Once all other subblocks are unplugged, remove the memory block and
  unplug its memmap subblocks, even if that unplugs more than requested.
  If that fails, keep the memory block in VIRTIO_MEM_SBM_MB_PLUGGED and
  let virtio_mem_cleanup_pending_mb() retry.

The plugged size therefore never stays above the requested size because
of the memmap, but can stay below it by up to the memmap subblocks of
one memory block. Adding or keeping a memory block only for its memmap
subblocks would provide no memory.

The memmap subblocks count towards the plugged size of the device, so a
fully plugged 128 MiB memory block adds 126 MiB to MemTotal.

In a 2 GiB x86-64 guest onlining to ZONE_MOVABLE, plugging 4 GiB took
about 64 MiB from the kernel zones without virtio_mem.memmap_on_memory
and less than 1 MiB with it.

Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---
 drivers/virtio/virtio_mem.c | 152 ++++++++++++++++++++++++++++++++------------
 1 file changed, 112 insertions(+), 40 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 688c178c760f..d6623f67b76b 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -54,6 +54,11 @@ MODULE_PARM_DESC(memmap_on_memory,
  *   Subblocks within a Linux memory block might either be plugged or unplugged.
  *   Memory is added/removed to Linux MM in Linux memory block granularity.
  *
+ *   With memmap_on_memory, the first subblock(s) of a Linux memory block
+ *   host its memmap ("memmap subblocks"). They stay plugged while the Linux
+ *   memory block is added to Linux, which requires at least one other plugged
+ *   subblock. "Fully plugged" and "partially plugged" below include them.
+ *
  * * Big Block Mode (BBM): A Big Block (BB) spans 1..X Linux memory blocks.
  *   Memory is added/removed to Linux MM in Big Block granularity.
  *
@@ -72,7 +77,10 @@ MODULE_PARM_DESC(memmap_on_memory,
 enum virtio_mem_sbm_mb_state {
 	/* Unplugged, not added to Linux. Can be reused later. */
 	VIRTIO_MEM_SBM_MB_UNUSED = 0,
-	/* (Partially) plugged, not added to Linux. Error on add_memory(). */
+	/*
+	 * (Partially) plugged, not added to Linux. Error on add_memory() or on
+	 * unplugging the memmap subblocks after removing it.
+	 */
 	VIRTIO_MEM_SBM_MB_PLUGGED,
 	/* Fully plugged, fully added to Linux, offline. */
 	VIRTIO_MEM_SBM_MB_OFFLINE,
@@ -179,6 +187,8 @@ struct virtio_mem {
 			uint64_t sb_size;
 			/* The number of subblocks per Linux memory block. */
 			uint32_t sbs_per_mb;
+			/* The number of memmap subblocks per memory block. */
+			u32 memmap_sbs;
 
 			/*
 			 * Some of the Linux memory blocks tracked as "partially
@@ -1567,15 +1577,16 @@ static int virtio_mem_bbm_plug_bb(struct virtio_mem *vm, unsigned long bb_id)
 
 /*
  * Unplug the desired number of plugged subblocks of a offline or not-added
- * memory block. Will fail if any subblock cannot get unplugged (instead of
- * skipping it).
+ * memory block, ignoring the subblocks below @first_sb. Will fail if any
+ * subblock cannot get unplugged (instead of skipping it).
  *
  * Will not modify the state of the memory block.
  *
  * Note: can fail after some subblocks were unplugged.
  */
 static int virtio_mem_sbm_unplug_any_sb_raw(struct virtio_mem *vm,
-					    unsigned long mb_id, uint64_t *nb_sb)
+					    unsigned long mb_id, int first_sb,
+					    uint64_t *nb_sb)
 {
 	int sb_id, count;
 	int rc;
@@ -1583,14 +1594,14 @@ static int virtio_mem_sbm_unplug_any_sb_raw(struct virtio_mem *vm,
 	sb_id = vm->sbm.sbs_per_mb - 1;
 	while (*nb_sb) {
 		/* Find the next candidate subblock */
-		while (sb_id >= 0 &&
+		while (sb_id >= first_sb &&
 		       virtio_mem_sbm_test_sb_unplugged(vm, mb_id, sb_id, 1))
 			sb_id--;
-		if (sb_id < 0)
+		if (sb_id < first_sb)
 			break;
 		/* Try to unplug multiple subblocks at a time */
 		count = 1;
-		while (count < *nb_sb && sb_id > 0 &&
+		while (count < *nb_sb && sb_id > first_sb &&
 		       virtio_mem_sbm_test_sb_plugged(vm, mb_id, sb_id - 1, 1)) {
 			count++;
 			sb_id--;
@@ -1607,7 +1618,7 @@ static int virtio_mem_sbm_unplug_any_sb_raw(struct virtio_mem *vm,
 }
 
 /*
- * Unplug all plugged subblocks of an offline or not-added memory block.
+ * Unplug all plugged subblocks of a not-added memory block.
  *
  * Will not modify the state of the memory block.
  *
@@ -1617,35 +1628,65 @@ static int virtio_mem_sbm_unplug_mb(struct virtio_mem *vm, unsigned long mb_id)
 {
 	uint64_t nb_sb = vm->sbm.sbs_per_mb;
 
-	return virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, &nb_sb);
+	return virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, 0, &nb_sb);
+}
+
+/*
+ * Unplug the memmap subblocks of a memory block removed from Linux and mark it
+ * unused. The memmap subblocks are deducted from @nb_sb (clamped), even if
+ * unplugging them fails. On error, the memory block stays
+ * VIRTIO_MEM_SBM_MB_PLUGGED and virtio_mem_cleanup_pending_mb() retries.
+ *
+ * Will modify the state of the memory block.
+ */
+static int virtio_mem_sbm_finish_remove_mb(struct virtio_mem *vm,
+					   unsigned long mb_id, uint64_t *nb_sb)
+{
+	const int count = vm->sbm.memmap_sbs;
+	int rc;
+
+	if (count) {
+		if (nb_sb)
+			*nb_sb -= min_t(uint64_t, *nb_sb, count);
+		virtio_mem_sbm_set_mb_state(vm, mb_id,
+					    VIRTIO_MEM_SBM_MB_PLUGGED);
+		rc = virtio_mem_sbm_unplug_sb(vm, mb_id, 0, count);
+		if (rc)
+			return rc;
+	}
+	virtio_mem_sbm_set_mb_state(vm, mb_id, VIRTIO_MEM_SBM_MB_UNUSED);
+	return 0;
 }
 
 /*
- * Try (offlining and) removing memory from Linux in case all subblocks are
- * unplugged. Can be called on online and offline memory blocks.
+ * Try (offlining and) removing memory from Linux in case all subblocks except
+ * the memmap subblocks are unplugged. Can be called on online and offline
+ * memory blocks.
  *
  * May modify the state of memory blocks in virtio-mem.
  */
 static int virtio_mem_sbm_try_remove_unplugged_mb(struct virtio_mem *vm,
-						  unsigned long mb_id)
+						  unsigned long mb_id,
+						  uint64_t *nb_sb)
 {
+	const int first_sb = vm->sbm.memmap_sbs;
 	int rc;
 
 	/*
 	 * Once all subblocks of a memory block were unplugged, offline and
-	 * remove it.
+	 * remove it. The memmap subblocks alone provide no memory to Linux.
 	 */
-	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb))
+	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, first_sb,
+					      vm->sbm.sbs_per_mb - first_sb))
 		return 0;
 
 	/* offline_and_remove_memory() works for online and offline memory. */
 	mutex_unlock(&vm->hotplug_mutex);
 	rc = virtio_mem_sbm_offline_and_remove_mb(vm, mb_id);
 	mutex_lock(&vm->hotplug_mutex);
-	if (!rc)
-		virtio_mem_sbm_set_mb_state(vm, mb_id,
-					    VIRTIO_MEM_SBM_MB_UNUSED);
-	return rc;
+	if (rc)
+		return rc;
+	return virtio_mem_sbm_finish_remove_mb(vm, mb_id, nb_sb);
 }
 
 /*
@@ -1686,7 +1727,7 @@ static int virtio_mem_sbm_plug_and_add_mb(struct virtio_mem *vm,
 	const int count = min_t(int, *nb_sb, vm->sbm.sbs_per_mb);
 	int rc;
 
-	if (WARN_ON_ONCE(!count))
+	if (WARN_ON_ONCE(count <= vm->sbm.memmap_sbs))
 		return -EINVAL;
 
 	/*
@@ -1806,6 +1847,9 @@ static int virtio_mem_sbm_plug_request(struct virtio_mem *vm, uint64_t diff)
 
 	/* Try to plug and add unused blocks */
 	virtio_mem_sbm_for_each_mb(vm, mb_id, VIRTIO_MEM_SBM_MB_UNUSED) {
+		/* Don't add a memory block just for its memmap subblocks. */
+		if (nb_sb <= vm->sbm.memmap_sbs)
+			return 0;
 		if (!virtio_mem_could_add_memory(vm, memory_block_size_bytes()))
 			return -ENOSPC;
 
@@ -1817,6 +1861,8 @@ static int virtio_mem_sbm_plug_request(struct virtio_mem *vm, uint64_t diff)
 
 	/* Try to prepare, plug and add new blocks */
 	while (nb_sb) {
+		if (nb_sb <= vm->sbm.memmap_sbs)
+			return 0;
 		if (!virtio_mem_could_add_memory(vm, memory_block_size_bytes()))
 			return -ENOSPC;
 
@@ -1954,9 +2000,10 @@ static int virtio_mem_sbm_unplug_any_sb_offline(struct virtio_mem *vm,
 						unsigned long mb_id,
 						uint64_t *nb_sb)
 {
+	const int first_sb = vm->sbm.memmap_sbs;
 	int rc;
 
-	rc = virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, nb_sb);
+	rc = virtio_mem_sbm_unplug_any_sb_raw(vm, mb_id, first_sb, nb_sb);
 
 	/* some subblocks might have been unplugged even on failure */
 	if (!virtio_mem_sbm_test_sb_plugged(vm, mb_id, 0, vm->sbm.sbs_per_mb))
@@ -1965,20 +2012,25 @@ static int virtio_mem_sbm_unplug_any_sb_offline(struct virtio_mem *vm,
 	if (rc)
 		return rc;
 
-	if (virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb)) {
+	if (virtio_mem_sbm_test_sb_unplugged(vm, mb_id, first_sb,
+					     vm->sbm.sbs_per_mb - first_sb)) {
 		/*
 		 * Remove the block from Linux - this should never fail.
 		 * Hinder the block from getting onlined by marking it
-		 * unplugged. Temporarily drop the mutex, so
-		 * any pending GOING_ONLINE requests can be serviced/rejected.
+		 * unplugged (or plugged, if memmap subblocks remain).
+		 * Temporarily drop the mutex, so any pending GOING_ONLINE
+		 * requests can be serviced/rejected.
 		 */
-		virtio_mem_sbm_set_mb_state(vm, mb_id,
+		virtio_mem_sbm_set_mb_state(vm, mb_id, first_sb ?
+					    VIRTIO_MEM_SBM_MB_PLUGGED :
 					    VIRTIO_MEM_SBM_MB_UNUSED);
 
 		mutex_unlock(&vm->hotplug_mutex);
 		rc = virtio_mem_sbm_remove_mb(vm, mb_id);
 		BUG_ON(rc);
 		mutex_lock(&vm->hotplug_mutex);
+
+		return virtio_mem_sbm_finish_remove_mb(vm, mb_id, nb_sb);
 	}
 	return 0;
 }
@@ -2040,27 +2092,33 @@ static int virtio_mem_sbm_unplug_any_sb_online(struct virtio_mem *vm,
 					       unsigned long mb_id,
 					       uint64_t *nb_sb)
 {
+	const int first_sb = vm->sbm.memmap_sbs;
+	const int count = vm->sbm.sbs_per_mb - first_sb;
 	int rc, sb_id;
 
-	/* If possible, try to unplug the complete block in one shot. */
-	if (*nb_sb >= vm->sbm.sbs_per_mb &&
-	    virtio_mem_sbm_test_sb_plugged(vm, mb_id, 0, vm->sbm.sbs_per_mb)) {
-		rc = virtio_mem_sbm_unplug_sb_online(vm, mb_id, 0,
-						     vm->sbm.sbs_per_mb);
+	/*
+	 * If possible, try to unplug the complete block (except the memmap
+	 * subblocks) in one shot.
+	 */
+	if (*nb_sb >= count &&
+	    virtio_mem_sbm_test_sb_plugged(vm, mb_id, first_sb, count)) {
+		rc = virtio_mem_sbm_unplug_sb_online(vm, mb_id, first_sb,
+						     count);
 		if (!rc) {
-			*nb_sb -= vm->sbm.sbs_per_mb;
+			*nb_sb -= count;
 			goto unplugged;
 		} else if (rc != -EBUSY)
 			return rc;
 	}
 
 	/* Fallback to single subblocks. */
-	for (sb_id = vm->sbm.sbs_per_mb - 1; sb_id >= 0 && *nb_sb; sb_id--) {
+	for (sb_id = vm->sbm.sbs_per_mb - 1; sb_id >= first_sb && *nb_sb;
+	     sb_id--) {
 		/* Find the next candidate subblock */
-		while (sb_id >= 0 &&
+		while (sb_id >= first_sb &&
 		       !virtio_mem_sbm_test_sb_plugged(vm, mb_id, sb_id, 1))
 			sb_id--;
-		if (sb_id < 0)
+		if (sb_id < first_sb)
 			break;
 
 		rc = virtio_mem_sbm_unplug_sb_online(vm, mb_id, sb_id, 1);
@@ -2072,7 +2130,7 @@ static int virtio_mem_sbm_unplug_any_sb_online(struct virtio_mem *vm,
 	}
 
 unplugged:
-	rc = virtio_mem_sbm_try_remove_unplugged_mb(vm, mb_id);
+	rc = virtio_mem_sbm_try_remove_unplugged_mb(vm, mb_id, nb_sb);
 	if (rc)
 		vm->sbm.have_unplugged_mb = 1;
 	/* Ignore errors, this is not critical. We'll retry later. */
@@ -2389,11 +2447,11 @@ static int virtio_mem_cleanup_pending_mb(struct virtio_mem *vm)
 
 	mutex_lock(&vm->hotplug_mutex);
 	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_MOVABLE_PARTIAL)
-		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
+		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id, NULL);
 	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_KERNEL_PARTIAL)
-		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
+		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id, NULL);
 	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_OFFLINE_PARTIAL)
-		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
+		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id, NULL);
 	mutex_unlock(&vm->hotplug_mutex);
 
 	if (rc)
@@ -2642,12 +2700,23 @@ static int virtio_mem_init_hotplug(struct virtio_mem *vm)
 	/* All memory blocks of a device must agree, decide once. */
 	if (memmap_on_memory) {
 		vm->memmap_pages = mhp_memmap_on_memory_nr_pages();
-		if (!vm->memmap_pages) {
+		if (!vm->memmap_pages)
 			dev_warn(&vm->vdev->dev,
 				 "memmap_on_memory is disabled or not supported by the core, ignoring\n");
-		} else if (vm->in_sbm) {
+	}
+	/*
+	 * In SBM, only support a memmap that spans complete subblocks: the
+	 * memmap subblocks then never provide memory to Linux. As the core
+	 * keeps at least one pageblock of each memory block for the buddy,
+	 * at least one other subblock remains.
+	 */
+	if (vm->memmap_pages && vm->in_sbm) {
+		if (IS_ALIGNED(PFN_PHYS(vm->memmap_pages), vm->sbm.sb_size)) {
+			vm->sbm.memmap_sbs = PFN_PHYS(vm->memmap_pages) /
+					     vm->sbm.sb_size;
+		} else {
 			dev_warn(&vm->vdev->dev,
-				 "memmap_on_memory is only supported in BBM, ignoring\n");
+				 "memmap_on_memory requires the memmap to span complete subblocks, ignoring; consider force_bbm\n");
 			vm->memmap_pages = 0;
 		}
 	}
@@ -2663,6 +2732,9 @@ static int virtio_mem_init_hotplug(struct virtio_mem *vm)
 	if (vm->memmap_pages)
 		dev_info(&vm->vdev->dev, "memmap on memory: 0x%llx bytes per memory block",
 			 (unsigned long long)PFN_PHYS(vm->memmap_pages));
+	if (vm->in_sbm && vm->sbm.memmap_sbs)
+		dev_info(&vm->vdev->dev, "memmap subblocks per memory block: %u",
+			 vm->sbm.memmap_sbs);
 
 	/* create the parent resource for all memory */
 	rc = virtio_mem_create_resource(vm);

-- 
2.55.0


