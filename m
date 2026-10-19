Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BDE1CCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09F96B00A6; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB9C76B00A7; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFA46B00AA; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8186F6B00A6
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:11:30 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F411D805ED
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:29 +0000 (UTC)
X-FDA: 85337749098.12.3EDA029
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 40F2780005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:11:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R9FYuu1D;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375888;
	b=EEZk8+C95OCE1RjQTbMCJZtFVs/7ZrLF+WvQIcldPClOtEwFM9i/rTwDw6FiMZqlgSBK5E
	mJh9SNgVFuAttjAARoXkO4Y3WnOrrNxxTVqZNZdll7kZ712dcvjOCXG5ZZO2qpRWT/CJ6K
	P//SusDD2uZQyPuMzRHhoS5Zdc4oUFg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=R9FYuu1D;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+N9EQwOcSjySxMS4O9eOeYmAxXFE2sVJ9Vy3mk5tWu4=;
	b=fo5ERY4IU7GbI3YvanOs6pnIIVP2eY42VSMM1wx6Pg6QAIlEHiCWq0lfz7KV+6pryBmRpP
	GOxEnvrDQmj8/cbbHdx/BOxpfWt2g3Dr/dSuRFSY+9XYUn+DBM/bGjAaDAaz0M6Qedul7H
	GvRa0xxbWe33GTBUC0uwSRE/T1Zu1Zs=
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5e94a057d9eso1276019e0c.3
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 19:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792375887; x=1792980687; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+N9EQwOcSjySxMS4O9eOeYmAxXFE2sVJ9Vy3mk5tWu4=;
        b=R9FYuu1DXXaSwW9fVy9vvxRTbfhBi3y0c0CZ57k8/EpCtk3UmhoIt6XT+oOk0oUsh3
         7cEXKxC5SUE6sWUM9GVQ9DTatzZaMjaRznxIzLqXHyCECY/uPWVlBTSDrrMzpWc17gmL
         mx/B5zFRQ6vpjh2uYswOvsUHifyT4B5waFcRMD1KN6cKl1lP0VqR/tCYXVqkNnO4tWJO
         SdM+DmTqymyPIaRFs4m2vq/F6WbH3rIZLtNHYoeBijuXGmsUcwG4FBun++/nNosWZ1Tk
         Pe82roUv9snsrCAhxPCS70ubpTc4t+z0c7OhKchQDCody3ZlIaG/UQRQi313GjzA+L+g
         jDPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375887; x=1792980687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=+N9EQwOcSjySxMS4O9eOeYmAxXFE2sVJ9Vy3mk5tWu4=;
        b=xtPfNYEkMLzm2PBAguJZERi3h5moIai7heDaIAQlJ+CFNV7i9UFNmQleC5V1Ws1ZQa
         If352grZ95TYblciD+7WL15yDXSVRox2Mot5DlXp+AFqMaBCZqtdeMdNipfU21w401qB
         Q8u38yTQOCu50tRrTHAZ0LZhMOgdJk8TcEHXQm3knmGCYa2AvAy13aG/Xz/FUKS3529P
         HY9bdI2ak7Rn93ReAT29I/kloaykgtyt2GOqGWfqxkTcqTb0z+PRQpnlkd24L9FDOjmj
         wDo0UcGWP3Z1MplJsGlYhrFzP706q4Als5X1seEmyY+gVmKRhw+SPiY2Pyua8tJOR47S
         5DrQ==
X-Forwarded-Encrypted: i=1; AKwUvBwK2kFdHm3e7lxeWH79BTlxjEpV/L9EZlBeLIiF/0q9ZmUUO3ISCADGYVcktQoVFNyZtK5nj176Rg==@kvack.org
X-Gm-Message-State: AFq9FYKPk26GGZb8n0eZK+czLLP+QZ826OXFW98fjwOQY/wF6O4X8qYE
	ZuUwfJNUdYLt5j5QmhRyGJS8+Ye9HJB3w3OLUfMGwzx810osJ9kRa5VfZLPiptdQuCw=
X-Gm-Gg: AYBFou0/EbJIFHzYVcI9yl3ha2w2wRM40SxTrhzvkw40kMH+nO5vnciba9NC2NILuFE
	k6wopX3jJJCEim0RIqWOVBputkPhIVd8czkioydbwKaX5zNsaohFu2wQkhFOECMvRvFav9n4uGh
	oekpddx1OnOgfifHN+9L6U7oxWcLweSjLtBvRhf/HiAkxMjd50SZSN5jeBN31T+lGJfoY7iMKx2
	Y7VUHIk2MZRziADIATTqaL4DQVXIgzX1L6LWyhuLUqMPIsfkOvogexLxH7dJxkj+3cZI/yF3+b7
	UCZueVJ8Z5QLlDHUMlh/4ykeDW8heUYsoDecIx2ZtQ8G7xpiVDkloN4v9rR9h5VFNA/PrMhtUS+
	L5yvFUqgLVIxd1AU5W9da2Syk0omyuCLiAhU1rTosXuQW/CpYj9LH0jLS7dEc+j06Gh/xTmFMpe
	oQZoybs+ZQDwIbZSEBBcFAgIbKAmj+B4e9uN9dd0Bto9oYyONLVee3o4/7KoDrmVPag8qlijb5Y
	iae6N2hyBE6YKyA3GTz0pfD335M2uu7p6JwOzTgTtnD3FgYbTcVo2Argyyeg+Zv2IiP5I0iMD+U
	D7SrUVTT3cBsxT6cplg=
X-Received: by 2002:a05:6122:3115:b0:5ea:a749:d33c with SMTP id 71dfb90a1353d-5eaaa66d4eamr2218681e0c.9.1792375887405;
        Sun, 18 Oct 2026 19:11:27 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eabbd9ea2bsm4271383e0c.2.2026.10.18.19.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 19:11:26 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	kuba@kernel.org,
	enelsonmoore@gmail.com,
	bp@alien8.de,
	shuah@kernel.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vbabka@kernel.org,
	dapeng1.mi@linux.intel.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	surenb@google.com,
	pasha.tatashin@soleen.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	elver@google.com,
	graf@amazon.com,
	lirongqing@baidu.com,
	liam@infradead.org,
	jlayton@kernel.org
Subject: [PATCH v1 6/8] kho: support read-only KHO mode in kho_block
Date: Sun, 18 Oct 2026 22:11:09 -0400
Message-ID: <20261019021111.990394-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019021111.990394-1-pasha.tatashin@soleen.com>
References: <20261019021111.990394-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 40F2780005
X-Stat-Signature: gu8g4pigi467zrcdi3gjfggjaw7j7r3o
X-HE-Tag: 1792375888-922534
X-HE-Meta: U2FsdGVkX1/ccAuDgfx7jOI8wbTlP7KH10+hQs5RA888EIj6a4ZXyq7pyAjAFtZtwrGk4UEtP5S++E+vxzi7lSE8P1XYNNXcyhr9NESciao4QICZNx6tHEe8uWoF2TGM0rtwOk2+XxES8jTQcxSs7FV2Ec6aX6lM3UTNMtZxaArXXrLE+FqTWaI2zTqmaCNCyeewCTXhMYJxOFMBKWkqVq1ZaHLA/OZhoDNZd/m9ZBzWkYloyMjcEzRCgANCDR7N/uR9yRkz3HMizC9q+YLauXoRvs0dpdq/z9OuWKoLb6CNWqoErQSbIva5xyKDM6aV0CaHiYbXoIffNVK0hPf/npUYbe+JwxIzQu9bJcPVsPxZbVU2JCM3U4WbQ2lnEl+4NvJpNDVYbQ6vetFSZVk9wy1DjXQXEvhErxLNMNi3aL3VeW60e8Km9KpSNuOXLCEYySfDqmzHNBiZ6fLJzuS3RXIeJIzQ+H+tBlhxpuZ0KfJx2APpfrmQ4JQ+xzSKLLADNBt8VgUmMsCuiWuXFeFn/rkBof4+9WHQ6RXDcWG8jFxCjzS5itEGIm1xpdArDPzHFjIPYiecUjzZiU+HMyD4yTIVZfEP5SDYt8xgE4npgta6MaGPfub9hkeUgyBvULBruxaeytQyv6gHAuZW2zCKDsRwDWCvkD4KPcnF/ouPJkKu9OUYuno3ckgh13qWpfuc6y6jT5xT2w1l4MUUvPBs0oko35aCqn2Ifomkvfc9iEr94/MZwNXEII0NivCw9CBeBI4fB5MyYBYRK9xnLMoOg8WShfcBz69oHDkgvROqwBW3bNhUm42plNabjM2zjpFjM1sA1OgHcFs2Zi0DS7PWlN02OGmADcUDeMjorgDRfwHYTepNKwIvuyA4w6s7ef0xNYP/leKWIxyeuVgNEfQJhunbkIXDVEuIAAsrdwQYe3BIkmkAjqAeuxYSzGNM/knUC/1vhFoTKDPN7/V/S2/
 BXjtFx4p
 RV1uqtqlWZ+PKd8GtzbQDSWQadUWBtpLeKo9+rMBJferAkk9jY/CkvV/vCAE94JquJGVzVeCC4zwLG/mccdytKkcVikWS/HzxmeaqEpPuvMrufNh5LV0NFdeFmmwiCuwsKTxsmI2uSjGkU+DqhLoXvDBclASVl0ObrHPn/k1XpHJh4jY8CHV5Byna1wD3lY0XWjL11jVKvdsWJlalGrlS5UJ+9j2vbA0HUBR3v7GKHQTp8qaZFLLltAgSXbp8adqd11iXyDgJTRIP1IGckZ92VIGKrQZxIQNTjmV+ypwcRiPMENUVjYyR4G47WQCNVmnCGW4kebhOLtPE9fG7h95Chb93UVPTm1ps8eyTqBeb3gwx5p6edSONBp3KLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In read-only KHO mode, incoming serialized kho_block chains lie outside
the kernel's direct map and must not be modified or freed back into the
page allocator.

Map incoming serialized blocks read-only via kho_ro_map_folio(...,
PAGE_KERNEL_RO) during cycle detection and restoration, and unmap them
via kho_ro_unmap() instead of calling kho_restore_free() when destroying
or shrinking a block set in read-only mode.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/Makefile    |  5 +--
 kernel/liveupdate/kho_block.c | 76 ++++++++++++++++++++++++++---------
 2 files changed, 60 insertions(+), 21 deletions(-)

diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
index f8b09e04bea2..d3587048e619 100644
--- a/kernel/liveupdate/Makefile
+++ b/kernel/liveupdate/Makefile
@@ -1,14 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 
 luo-y :=								\
-		kho_block.o						\
 		luo_core.o						\
 		luo_file.o						\
 		luo_flb.o						\
 		luo_session.o
 
-obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
-obj-$(CONFIG_KEXEC_HANDOVER_READONLY)	+= kexec_handover_ro.o
+obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o kho_block.o
+obj-$(CONFIG_KEXEC_HANDOVER_READONLY)	+= kexec_handover_ro.o kho_block.o
 obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
 
 obj-$(CONFIG_LIVEUPDATE)		+= luo.o
diff --git a/kernel/liveupdate/kho_block.c b/kernel/liveupdate/kho_block.c
index a4e945f28fad..a3cf5b964b26 100644
--- a/kernel/liveupdate/kho_block.c
+++ b/kernel/liveupdate/kho_block.c
@@ -60,10 +60,32 @@ static void *kho_block_entry(struct kho_block_set_it *it, u64 index)
 	return kho_block_entries(it->block) + (index * it->bs->entry_size);
 }
 
+static struct kho_block_header_ser *kho_block_map_ser(phys_addr_t pa)
+{
+	if (!pa)
+		return NULL;
+
+	if (kho_is_ro())
+		return kho_ro_map_folio(pa, PAGE_KERNEL_RO);
+
+	return phys_to_virt(pa);
+}
+
+static void kho_block_unmap_ser(struct kho_block_header_ser *ser)
+{
+	if (kho_is_ro())
+		kho_ro_unmap(ser);
+}
+
 /* Free serialized data */
 static void kho_block_free_ser(struct kho_block_set *bs,
 			       struct kho_block_header_ser *ser)
 {
+	if (kho_is_ro()) {
+		kho_block_unmap_ser(ser);
+		return;
+	}
+
 	if (bs->incoming)
 		kho_restore_free(ser);
 	else
@@ -197,6 +219,20 @@ void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
 		kho_block_set_shrink_one(bs);
 }
 
+static bool kho_block_step_pa(phys_addr_t pa, phys_addr_t *next_pa)
+{
+	struct kho_block_header_ser *ser;
+
+	ser = kho_block_map_ser(pa);
+	if (!ser)
+		return false;
+
+	*next_pa = ser->next;
+	kho_block_unmap_ser(ser);
+
+	return true;
+}
+
 /*
  * kho_block_set_is_cyclic - Check for cycles in a linked list of blocks.
  * Uses Floyd's cycle-finding algorithm to ensure sanity of the incoming list.
@@ -205,30 +241,26 @@ void kho_block_set_shrink(struct kho_block_set *bs, u64 count)
  */
 static bool kho_block_set_is_cyclic(struct kho_block_set *bs)
 {
-	struct kho_block_header_ser *fast;
-	struct kho_block_header_ser *slow;
+	phys_addr_t fast_pa = bs->head_pa;
+	phys_addr_t slow_pa = bs->head_pa;
 	int count = 0;
 
-	fast = phys_to_virt(bs->head_pa);
-	slow = fast;
-
-	while (fast) {
+	while (fast_pa) {
 		if (count++ >= KHO_MAX_BLOCKS) {
 			pr_err("Block set is corrupted\n");
 			return true;
 		}
 
-		if (!fast->next)
-			break;
-
-		fast = phys_to_virt(fast->next);
-		if (!fast->next)
+		if (!kho_block_step_pa(fast_pa, &fast_pa))
+			return true;
+		if (!fast_pa)
 			break;
 
-		fast = phys_to_virt(fast->next);
-		slow = phys_to_virt(slow->next);
+		if (!kho_block_step_pa(fast_pa, &fast_pa) ||
+		    !kho_block_step_pa(slow_pa, &slow_pa))
+			return true;
 
-		if (slow == fast) {
+		if (slow_pa == fast_pa) {
 			pr_err("Block set is corrupted\n");
 			return true;
 		}
@@ -266,16 +298,23 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 	}
 
 	while (next_pa) {
-		ser = phys_to_virt(next_pa);
+		ser = kho_block_map_ser(next_pa);
+		if (!ser) {
+			err = -ENOMEM;
+			goto err_destroy;
+		}
 		if (!ser->count || ser->count > bs->count_per_block) {
 			pr_warn("Block contains invalid entry count: %llu\n",
 				ser->count);
+			kho_block_unmap_ser(ser);
 			err = -EINVAL;
 			goto err_destroy;
 		}
 		err = kho_block_add(bs, ser);
-		if (err)
+		if (err) {
+			kho_block_unmap_ser(ser);
 			goto err_destroy;
+		}
 		next_pa = ser->next;
 	}
 
@@ -285,9 +324,10 @@ int kho_block_set_restore(struct kho_block_set *bs, u64 head_pa)
 	kho_block_set_destroy(bs);
 
 	/* Free the remaining un-restored blocks in the physical chain */
-	while (next_pa) {
-		struct kho_block_header_ser *next_ser = phys_to_virt(next_pa);
+	while (!kho_is_ro() && next_pa) {
+		struct kho_block_header_ser *next_ser;
 
+		next_ser = phys_to_virt(next_pa);
 		next_pa = next_ser->next;
 		kho_block_free_ser(bs, next_ser);
 	}
-- 
2.56.0.176.g3575e65682-goog


