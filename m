Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7E6A606D819
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 09:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=karaolidis.com header.i=@karaolidis.com header.a=rsa-sha256 header.s=protonmail3 header.b=RTFB8Kme
Received: by kanga.kvack.org (Postfix)
	id 3A1CB6B05BA; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4166B05B9; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BA4E6B05B9; Tue,  3 Nov 2026 04:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3BEF6B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 04:51:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C5FE160391
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:51:02 +0000 (UTC)
X-FDA: 85393339164.04.484D1ED
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	by imf14.hostedemail.com (Postfix) with ESMTP id F1104100002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:50:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=RTFB8Kme;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com;
	spf=pass (imf14.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.107 as permitted sender) smtp.mailfrom=nick@karaolidis.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793699460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBdI6sTn5K4OgfmCVF/8zIHq3UrF3Zy+wUPm5MAIdzg=;
	b=mbEuUUj42cJJrIbnuQrfg3xdAWuyIShZjnQRAtVMtwHsgoQkvfbIaHUx4bt+5Xbt4q8l2Y
	96seUnc/jXpcP5QDKKzEF/ycjOBiQ7aYT4lQfU1/dNludxBf6PNtBCThplBrJBNj9xBKO6
	tkifEaWm8upqk2/Ktuhi2WTk0ntwbUI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=karaolidis.com header.s=protonmail3 header.b=RTFB8Kme;
	dmarc=pass (policy=quarantine) header.from=karaolidis.com;
	spf=pass (imf14.hostedemail.com: domain of nick@karaolidis.com designates 109.224.244.107 as permitted sender) smtp.mailfrom=nick@karaolidis.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793699460;
	b=hbIUUZD0dVJkpXbPHmToHNmpHTxV+pQIX2YKhnMLrAOSO9KD00TU/rI7/jvQ6RNmbYyjUx
	A2dBDZYOUH3SWBL0wD+Z3d/f0fLTTUR2ERMURuJH+opn+3ig0dFaWHQUfTTDO6Fiyhgn3m
	tyWOj2BurBuk+RgtyczAIfNxurY54y4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=karaolidis.com;
	s=protonmail3; t=1793699458; x=1793958658;
	bh=OBdI6sTn5K4OgfmCVF/8zIHq3UrF3Zy+wUPm5MAIdzg=;
	h=From:Date:Subject:Message-Id:References:In-Reply-To:To:Cc:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=RTFB8KmexjksUk20HrjmyS1e1SwZL4VvFQR020kdzu5KmKV6ahtxVkSu6cytKVo3x
	 wRpNDXXhsjvXTbd/nIBNQp2KB5cwMzGj5pTLY7I4BCvzXbr0v6MzcNQFxB0AOH7Q9b
	 +YFtelNTADrcMBdsyiVS4Xhu3EVuhBjIRxy3SgdB2jcemj8nDtMtH3wMvw+myjiW5Z
	 8aqIhC1E6on7pT0iKPKld7GIqpjJN29HtvfKtrrwZjF0MBHOT3hjZ66PCDNK/o9ADl
	 H8jwHr7GGELk238IfaWXQly2UROvFAi4GfzSVrfyN631PN2v37vvS73oiFI6thOwCO
	 4/b/lg+nNCynw==
X-Pm-Submission-Id: 4jJkNH0h9pz2ScjC
From: Nikolaos Karaolidis <nick@karaolidis.com>
Date: Tue, 03 Nov 2026 09:50:08 +0000
Subject: [PATCH RFC 2/6] virtio-mem: prepare memory notifier for a
 self-hosted memmap
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-virtio-mem-memmap-v1-2-308ae1da6240@karaolidis.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3542; i=nick@karaolidis.com;
 h=from:subject:message-id; bh=TO2CmbxVRk5IIxBT/zUC8sOXtYzHOqzh3B7e5x1oZ0Y=;
 b=owJ4nAFtApL9kA0DAAoB2mjImL9M9YgByyZiAGrprnfulwaXR03O2p0qJDHLazzry3QLpv4Ia
 U4y+Pitk66ahYkCMwQAAQoAHRYhBLMZG7EWqsMYjymWX9poyJi/TPWIBQJq6a53AAoJENpoyJi/
 TPWIRpEQALF1yuzhT+G9+r/UaOZj+ncGcwkxjmTohjHCy77NkVXvj4vAzd3+Y7HPpD2AaqYkchw
 g15fGpkaHJGslMRxczn5mCczJOj6EjzsmThGmSQNIk++5GLtopumrnPrtR3WHpP/cIQv35P3oGn
 Q0KOw8IVZ3XR7yZDMt3MXy9ONcuAkYT8HIpl490imwmZvW6zvJTNGLwU4ebtqqLE6PrXqHPnmas
 VRIi/bwtPAvPxOXNLum18q3ixX7KFlV0bJV5bHH6mB/+71kOhV6SKo06ocN1yeScE2suNdDYpwX
 SKvLtTNE3kWGQA/0ckSj7t5y5WyYE//WoBOs24j89Z9Pm2vWhDSPVOF3T7P8UTr8W6/sHigPrwc
 mk6nHWBcxitvRp1l8NTFG3EiTkjpnq4o8rpR6pg3OZ8U7IyWO7CW7l2/4XGGk9uFS4mmtC1wkc0
 vhrbjxLwJDC6bpZYXyNWj7skLCJmDiL/23MuL4kuE0dg98x66IqZc6UsF3D9CYA+koiBhn4zxmc
 +XPIJi/WBmAEJkYlVZLhV6cbiD8u1wrsPtJs6akIbjv1m9AI44vz5z8hGv/+fln34JqsolDmubH
 4IkZb6zcMvg/0h3gA5bLrj7B6G1kYyOO1+66BPyM4FNFIr7k9tKI6b4wvIbaI0Eyj5zrpfRVXOK
 L3rqdJjtcLV0CIEJzyBs8FA==
X-Developer-Key: i=nick@karaolidis.com; a=openpgp;
 fpr=B3191BB116AAC3188F29965FDA68C898BF4CF588
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F1104100002
X-Stat-Signature: 8m3daqhbbmkgsuyrs4f67zzzao9wcdf6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793699459-830764
X-HE-Meta: U2FsdGVkX1/brIkvETIEQmo4iCEGZ97MsgU5k9ggRPsh4dYeXT5XJiGamEb/w7nsgaxDtBXq96r9CPZMPCRwTBKa9VugoeGTyo5mD4Zsl9hwQ4Cxe9sPvV9eGCNEhJ+mme0MhrqL6u7IXGBsgOcaFmOx7wPkepbxtsOvL7qXVnmFwUvnybzRsYuj1zyr21vdVzj8DLBkSa/8apEqeT5fPk1SEvubmDXJc5SMNiSVHl526RKvSmmI9Lft5NenAaOMQgDMDSJWFsSfpn5iBq2c6SaT2kCapwTL6mNhgTXK84pEof3pLeMSCkqrNf3hgOE/nKib3F6jRhYKN1sJ2j/Ij0jxLLhn1yd/pmz2JvAF0OsMVr+tbRjp+HnAW2gPUz4aMNVmFl85JM1j/t1pe5DinHbAyjANoGZtYQzuyTwTv6wciwS8CkReXELGTgpf//kfprK/PFAjhtvomDPt4U21N64nsvReafWgBGOgd87VbFowJNEvL1PMK9xjmMohnLTq9HdfR6BNV55Ys2ErBxfFlz0Z762Rwi9/FyWlJTpR5frPgMa3hzYOz3/auQM+th2bb64cXd+6SubvioYZfRk37iLFst9CC7G7W3OCR6ZCSZ+33Ba8EevmH+ZYZylR87tx+1xlpl9qutEgS7ysAREqT5Y4h7N83AIQakuHPe0AEtsbOGUKUNvi/NvbVEzN4zXHGbYL5YbpMscccqp87fJBYMaQ7csjudcRi4R44NnaOjSlvZwZN2POKDuGMbtV9nI/puKv5qoz/HsT6yp239H5ocpmW84zf4JsdNAbizwurulASB1M5lx5MehiewPndCpsecz9sFg8CaBltVAWWmKu1S/dKdu6xYt6suusFBjaIVXzb4pUQcc2WcmKnE3IhWSW1KxkjtB2vg+PIkCuKiJtIVNomWCrYNAyL/HmWvIumg35WQrBYcS20178qmbdeYUMN3QaqJ0gf1qPiV3mJdl
 tHyGGlLw
 mJ5Pyf7n0/4Ih37XdJqnGMyubM3WGlaf+5fNmwlue1t50xdz9v/yXgW8qh+zMSygkZMGRlc7dle+YQwmi6VgHhd6KrAiaMWp6bt5rHRhEvbthYYheh7NFtC1QHvcXiSuICkmx0Qi439UlwuNcAGmdg6XG08dWfeGG+2Le7+7KyACNeULDE2Qn77lt+1lbpgBAltFmM6+ar98zmZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With MHP_MEMMAP_ON_MEMORY, the core excludes the memmap at the start of
each memory block from the range passed to memory notifiers. The
virtio-mem notifier does not expect that:

* In Sub Block Mode, it rejects any range that is not exactly one
  aligned memory block with a WARN and NOTIFY_BAD.

* It adjusts offline_size by the notified size, while adding and
  removing memory use the full size. Every onlined memory block would
  leave its memmap size behind in offline_size, until the offline
  threshold stops further hotplug.

Track the memmap pages per memory block in vm->memmap_pages, expect the
notified range to start after the memmap in Sub Block Mode, and include
the memmap when adjusting offline_size.

vm->memmap_pages is always 0 for now, so there is no functional change.

Assisted-by: LLM
Signed-off-by: Nikolaos Karaolidis <nick@karaolidis.com>
---
 drivers/virtio/virtio_mem.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index e18dd736f2ec..ab06adbc0342 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -158,6 +158,9 @@ struct virtio_mem {
 	/* If set, the driver is in SBM, otherwise in BBM. */
 	bool in_sbm;
 
+	/* Pages at the start of each Linux memory block hosting its memmap. */
+	unsigned long memmap_pages;
+
 	union {
 		struct {
 			/* Id of the first memory block of this device. */
@@ -995,21 +998,23 @@ static int virtio_mem_memory_notifier_cb(struct notifier_block *nb,
 	struct memory_notify *mhp = arg;
 	const unsigned long start = PFN_PHYS(mhp->start_pfn);
 	const unsigned long size = PFN_PHYS(mhp->nr_pages);
+	const unsigned long memmap_size = PFN_PHYS(vm->memmap_pages);
 	int rc = NOTIFY_OK;
-	unsigned long id;
+	unsigned long id, mb_start;
 
 	if (!virtio_mem_overlaps_range(vm, start, size))
 		return NOTIFY_DONE;
 
 	if (vm->in_sbm) {
 		id = virtio_mem_phys_to_mb_id(start);
+		mb_start = virtio_mem_mb_id_to_phys(id);
 		/*
 		 * In SBM, we add memory in separate memory blocks - we expect
-		 * it to be onlined/offlined in the same granularity. Bail out
-		 * if this ever changes.
+		 * it to be onlined/offlined in the same granularity, excluding
+		 * a self-hosted memmap. Bail out if this ever changes.
 		 */
-		if (WARN_ON_ONCE(size != memory_block_size_bytes() ||
-				 !IS_ALIGNED(start, memory_block_size_bytes())))
+		if (WARN_ON_ONCE(start != mb_start + memmap_size ||
+				 size != memory_block_size_bytes() - memmap_size))
 			return NOTIFY_BAD;
 	} else {
 		id = virtio_mem_phys_to_bb_id(vm, start);
@@ -1062,7 +1067,8 @@ static int virtio_mem_memory_notifier_cb(struct notifier_block *nb,
 		if (vm->in_sbm)
 			virtio_mem_sbm_notify_offline(vm, id);
 
-		atomic64_add(size, &vm->offline_size);
+		/* Adding/removing memory accounts the memmap as well. */
+		atomic64_add(size + memmap_size, &vm->offline_size);
 		/*
 		 * Trigger the workqueue. Now that we have some offline memory,
 		 * maybe we can handle pending unplug requests.
@@ -1077,7 +1083,7 @@ static int virtio_mem_memory_notifier_cb(struct notifier_block *nb,
 		if (vm->in_sbm)
 			virtio_mem_sbm_notify_online(vm, id, mhp->start_pfn);
 
-		atomic64_sub(size, &vm->offline_size);
+		atomic64_sub(size + memmap_size, &vm->offline_size);
 		/*
 		 * Start adding more memory once we onlined half of our
 		 * threshold. Don't trigger if it's possibly due to our action

-- 
2.55.0


