Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5F47CCF2C0
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 20:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBFA6B008A; Mon,  5 Jan 2026 15:36:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93966B0093; Mon,  5 Jan 2026 15:36:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE206B0095; Mon,  5 Jan 2026 15:36:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B95C46B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 15:36:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41E7CB6880
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:36:50 +0000 (UTC)
X-FDA: 84299068980.29.427629E
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3F2822000F
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 20:36:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P+xBi2Xt;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767645408; a=rsa-sha256;
	cv=none;
	b=rSbTnLUYtUTBDvH/0PfIbTqRIqufklbqLBC3nRuvu5Cq7AnH/z58n5uhLb1j93HsWc/8Dq
	d+/dChapvbFLtFS5584KYaQ4YZDSdp/fnBTHhK7kUvmsmseIlAGAiiv/2u+QzMO/vB0O1C
	omVrN7ucmjsP8SFSw/vyrFbdOv4RfHw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=P+xBi2Xt;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767645408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KZqDH83vRzD+061XVx0iqYmNRWn5jGpRz20URi6BfTw=;
	b=MPqS4naCX2eS8YgI9TQZ80lyhJZLDmgUQT1ayGVzZoowbBfnsB0aRe1y9ThLQIATa8LO2d
	QQFewb7Nr/5ymt4LPjJ1mwxOnzuVH+mOgm5lrghw9d3StxK75ZfYff+0PVXmDyVYy18ZkR
	yGX8AN7SgweOml9mj7vBMH1UeMsr3B0=
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b2f2c5ec36so32061485a.1
        for <linux-mm@kvack.org>; Mon, 05 Jan 2026 12:36:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767645407; x=1768250207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KZqDH83vRzD+061XVx0iqYmNRWn5jGpRz20URi6BfTw=;
        b=P+xBi2Xt9n3Josut4LIeWGIo8GMGSs+s0j4wgdFV2sMM+dD0iZ1DgUedahUrnmKDcv
         PvFMQAYspTQFhcFL/McfoZTZoVK09lvdCrBSmgEjUf9wnMqMKFkJeRIbGnDeP8rYUF9N
         9bcOTCHLlsmlRsFtu8ZA+ftz9LUghY4Amvi/nNaFa8VVeInDeRVayusy6r118tmK8wna
         Dh/a9MmbWY6lbU1Mf6SV7NgDXyMv17T6+dUP6W4kLAzXXKHe5N8iewasdqhZDA+YIns8
         7+T672o4vz0+8KUL+KOfXZplc80m9cfDki/vRtleAlWL6AHUon/QBU2jZKIh6ob5lBdV
         7oZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767645407; x=1768250207;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KZqDH83vRzD+061XVx0iqYmNRWn5jGpRz20URi6BfTw=;
        b=smueqc9K+fYq4wgcxtPoDbtK95kSWDMsQIQ+xF+8jZndxtGK0XI7CamNUs3gUYwA4R
         O10/YS7bjNUFwLdls7NNzQ9+YEf+R91XbicmFG73F1inR/ibm/VhmUIHb653IW0K3/7P
         hGjqLgSohrnu2TGeguCDBFTlk7Z3IwPv69A0Mt3vnNypacYWPDymEFoWqj8J385UAc/T
         HfSJpZQOQQTiZ1xsjbVN/kbg9YMXlVmdqmSrt8xDDZIwfmi/cZL5sXf/VQbYa/TNB46r
         tMwqBpue6TknpYInxfyaa1uaoll8VulG79LCMuqVzIvpstkH/lBSQ9yrVUamD5Iz5SVp
         CFmw==
X-Gm-Message-State: AOJu0YyCT1tBu3LCZwvnWhO67rgDmcddRMEVFzruy2MxogaNBMbwPmi8
	4Y1huE17DMxi1bhIstlHYrea7D85IjA7mcPidAMoo0wpIhXk2kOml9pcu0xrTAKrzvDHbtLHiIY
	RSAIK
X-Gm-Gg: AY/fxX7t9d3NnNBkGuk32D15V3w6gs73O8gRHdrBLYZqFMtspHm60t6G3c3O4IXZtJ7
	2ItJH5m55RBQC76gfzA8n54cFo7lNEnyq67ewBbYspq5LmjbYlkPAm+zvuf6o6R11WoVC9sMqqf
	Fj/XkXHQKo6Pchv9vO29SAm8rvglSoihAR5/GS5yRIleKD+yhzPQMAiXXMaqDVJiiwErl9dyHxF
	wL75MW42p0ZB2vTg0SjrgS19BgHw8mHdLRD0qnSRlhwQTSUekF816Lmjpk3rtBvIqvnrio6NzRR
	g5rPm+Myzpu+d8lcPLJWR3CdsV9z3HP2Kyr+IHOIw4rEykVvDskHKc2mhicL5vr6S4ZIilQzbzL
	96/wMdG2hZYF1h8I5A+I/HoXP51oEy2K0vsw+SOvIAkTIbdPAtm6YJwLq7RMyub8lH7gi9dgJ2t
	rstv8bKkR0qX8suVXqbvWKVeH1ZzqsCMekCkcNYGJLCS0H+Ae/okMz+02xgu0mRW9C715cn7odY
	h/PU1e+HZw9qw==
X-Google-Smtp-Source: AGHT+IHFQ2zKeDm6cfqKEElGn5vKL5ZyEPq7WfLjHcrIvWqOxVf6ThFNHOhhq0ReOlp5JXk4+y9X4w==
X-Received: by 2002:a05:620a:4449:b0:8c0:9618:8c75 with SMTP id af79cd13be357-8c37eba72cfmr122811185a.71.1767645406901;
        Mon, 05 Jan 2026 12:36:46 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f5312d3sm25685585a.43.2026.01.05.12.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 12:36:46 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	david@redhat.com,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hare@suse.de
Subject: [RFC PATCH] memory,memory_hotplug: allow restricting memory blocks to zone movable
Date: Mon,  5 Jan 2026 15:36:11 -0500
Message-ID: <20260105203611.4079743-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F2822000F
X-Rspamd-Server: rspam10
X-Stat-Signature: 9cbyogwia3tc75mzd4ubdkywiczbisxg
X-HE-Tag: 1767645408-19291
X-HE-Meta: U2FsdGVkX1+YseafiAwI3PQfnxcQXNfJ5Wga552dKMUv7+P7zmRi4hrRgw3z26afkBYhoYKeTmx8V0BWvF2YC+9IV6+i9Vx8O3WiGtpRbazu9c8r+x3WzadcPtKBTfgTC9NT+EoWVa7nk1ftRClWjCsyWAAAGkpJksWGsBBFcE1smKLEprB10xUKQgye4paOoUbj8SXdvPDByh0q/eZ++nMIhGdBRSMjd1dz59MjccUGr9La2+61xIoRGkJK6Pw/XLygV75Z0YAt0bmlgv5IQNYNvaR8eqMxMRu/xitVqGGzE4761NpDw1aW1bXh9+frbUG2R2cG9YqWVZRwjtTH+jnunDTenHTOvgmyF1kEWkIIUY0199v3AgTsjw1SsvvCFB6FfRcjisy+qoMN6yCP+p+wiKbXiqcfEDeK3OrhzPh0c7yDAhlYOlYIQwODSjQLQXDfrmXDLhezwoytuK0I3A06JhAaAfQxXnXijGQ+8NZOyiRObh0K0pYx58+pYPj6hb1uTOqHEdKnTBrzi+UOcBBN6yNSaSXHs8zdVE9s7T4RjFa9FN6MMC4GYlP+ey6eUOtFgseO2s/3dsTsUlLc/wcfW28OEYpbEuMbA8jUf7tm00IsRmP+qhovoVbQ5Ij5jlJejS3sOUDIMZjbt6CXkkWiWDOUDIHqQ6alhvni4+2Sp/q9VTW+HJyhxIB5p0pL/DvJ5XkczOfgR6+qkEj1/4tLnCGpWjdeRiWjbYoJ6nZmZB8NC3eRbc3ymzSepjTyXxzbjfatJpRwWSmeKgek114JO86MPShn5ZieI4L65S911QQgqX88RObpi7w4kI1TYhu/jLX19lHdO26ZV1vM0Ap/oanJnvQTh6jghQ4uYFM9GXlJyxYEsFaaBmQW728tR80UDKCEkWEblwPWqqfXfg3x+p0NG6bI6TTbENDwpxdCKJxYq89RfSdW3ZbDIAftaxrc/7OxKkSX+w/msxb
 k6FODKVR
 EtqjcD/fdsy4iyFXkF+662MP1SBPbjh5I4pY/arXSxA8npEuZw3KOSAAK+qll2yxfWxdfMbgNj8NTnKHww+ae/Q04PJiPVgd6h/Zi8dRMIHNX2RZmGVYv/6rppQdVPB7qswiH6+Hj42l45vKon+iDfVQbKfmuKAGzT6jQmOlYCnKNhXl+OPPxNOfdoKI5WBKzyJ/cM1SDYl6LfJkfeg2sy1BlfqLlC+RWwojW1heLkx7+thqFcWTutZemJ7CMnl/4O9OF+VeHeHukSyGRF2mrLkD1SA93r5QDAsl5bbtGww2eED5ILY4S2iqqa9bNyaoSBVXz1vUJ4B4pOreFpuXtetCHPwWPzLVXlsTx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It was reported (LPC 2025) that userland services which monitor memory
blocks can cause hot-unplug to fail permanently.

This can occur when drivers attempt to hot-remove memory in two phases
(offline, remove), while a userland service detects the memory offline
and re-onlines the memory into a zone which may prevent removal.

This patch allows a driver to specify that a given memory block is
intended as ZONE_MOVABLE memory only (i.e. the system should try to
protect its hot-unpluggability). This is done via an MHP flag and a new
"movable_only" bool in `struct memory_block`.

Attempts to online a memory block with movable_only=true with any value
other than MMOP_ONLINE_MOVABLE will fail with -EINVAL.

It is hard to catch all possible ways to implement offline/remove
process, so a race condition here can clearly still occur if the
userland service onlines the memory back into ZONE_MOVABLE, but it at
least will not prevent the removal of a block at a later time.

Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/base/memory.c          | 15 +++++++++++----
 include/linux/memory.h         |  4 +++-
 include/linux/memory_hotplug.h | 13 +++++++++++++
 mm/memory_hotplug.c            | 12 +++++++++---
 4 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 6d84a02cfa5d..59512e4b8d62 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -374,6 +374,8 @@ static int memory_block_change_state(struct memory_block *mem,
 
 	if (to_state == MEM_OFFLINE)
 		mem->state = MEM_GOING_OFFLINE;
+	else if (mem->movable_only && to_state != MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
 
 	ret = memory_block_action(mem, to_state);
 	mem->state = ret ? from_state_req : to_state;
@@ -811,7 +813,8 @@ void memory_block_add_nid_early(struct memory_block *mem, int nid)
 
 static int add_memory_block(unsigned long block_id, int nid, unsigned long state,
 			    struct vmem_altmap *altmap,
-			    struct memory_group *group)
+			    struct memory_group *group,
+			    bool movable_only)
 {
 	struct memory_block *mem;
 	int ret = 0;
@@ -829,6 +832,7 @@ static int add_memory_block(unsigned long block_id, int nid, unsigned long state
 	mem->state = state;
 	mem->nid = nid;
 	mem->altmap = altmap;
+	mem->movable_only = movable_only;
 	INIT_LIST_HEAD(&mem->group_next);
 
 #ifndef CONFIG_NUMA
@@ -880,7 +884,8 @@ static void remove_memory_block(struct memory_block *memory)
  */
 int create_memory_block_devices(unsigned long start, unsigned long size,
 				int nid, struct vmem_altmap *altmap,
-				struct memory_group *group)
+				struct memory_group *group,
+				bool movable_only)
 {
 	const unsigned long start_block_id = pfn_to_block_id(PFN_DOWN(start));
 	unsigned long end_block_id = pfn_to_block_id(PFN_DOWN(start + size));
@@ -893,7 +898,8 @@ int create_memory_block_devices(unsigned long start, unsigned long size,
 		return -EINVAL;
 
 	for (block_id = start_block_id; block_id != end_block_id; block_id++) {
-		ret = add_memory_block(block_id, nid, MEM_OFFLINE, altmap, group);
+		ret = add_memory_block(block_id, nid, MEM_OFFLINE, altmap, group,
+				       movable_only);
 		if (ret)
 			break;
 	}
@@ -998,7 +1004,8 @@ void __init memory_dev_init(void)
 			continue;
 
 		block_id = memory_block_id(nr);
-		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_ONLINE, NULL, NULL);
+		ret = add_memory_block(block_id, NUMA_NO_NODE, MEM_ONLINE, NULL, NULL,
+				       false);
 		if (ret) {
 			panic("%s() failed to add memory block: %d\n",
 			      __func__, ret);
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 43d378038ce2..bab24f796d3d 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -80,6 +80,7 @@ struct memory_block {
 	struct vmem_altmap *altmap;
 	struct memory_group *group;	/* group (if any) for this block */
 	struct list_head group_next;	/* next block inside memory group */
+	bool movable_only;		/* If set, only ZONE_MOVABLE is valid */
 #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_MEMORY_HOTPLUG)
 	atomic_long_t nr_hwpoison;
 #endif
@@ -160,7 +161,8 @@ extern int register_memory_notifier(struct notifier_block *nb);
 extern void unregister_memory_notifier(struct notifier_block *nb);
 int create_memory_block_devices(unsigned long start, unsigned long size,
 				int nid, struct vmem_altmap *altmap,
-				struct memory_group *group);
+				struct memory_group *group,
+				bool movable_only);
 void remove_memory_block_devices(unsigned long start, unsigned long size);
 extern void memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 23f038a16231..ca51ef2ad0cf 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -75,6 +75,19 @@ typedef int __bitwise mhp_t;
  */
 #define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
 
+/*
+ * Restrict hotplugged memory blocks to ZONE_MOVABLE only.
+ *
+ * During offlining of hotplugged memory which was originally onlined
+ * as ZONE_MOVABLE, userland services may detect blocks going offline
+ * and automatically re-online them into ZONE_NORMAL or lower.  When
+ * this happens it may become permanently incapable of being removed.
+ *
+ * Allow driver-managed memory sources to restrict memory blocks to
+ * ZONE_MOVABLE only, so that the truly degenerate case can be mitigated.
+ */
+#define MHP_MOVABLE_ONLY		((__force mhp_t)BIT(4))
+
 /*
  * Extended parameters for memory hotplug:
  * altmap: alternative allocator for memmap array (optional)
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 81ba5b019926..1a184bfd87f6 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1346,7 +1346,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	mem->online_type = mem->movable_only ?
+			   MMOP_ONLINE_MOVABLE :
+			   mhp_get_default_online_type();
 	return device_online(&mem->dev);
 }
 
@@ -1449,6 +1451,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 	unsigned long memblock_size = memory_block_size_bytes();
 	u64 cur_start;
 	int ret;
+	bool movable_only = mhp_flags & MHP_MOVABLE_ONLY;
 
 	for (cur_start = start; cur_start < start + size;
 	     cur_start += memblock_size) {
@@ -1478,7 +1481,8 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 
 		/* create memory block devices after memory was added */
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
-						  params.altmap, group);
+						  params.altmap, group,
+						  movable_only);
 		if (ret) {
 			arch_remove_memory(cur_start, memblock_size, NULL);
 			kfree(params.altmap);
@@ -1506,6 +1510,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
+	bool movable_only = mhp_flags & MHP_MOVABLE_ONLY;
 	int ret;
 
 	start = res->start;
@@ -1564,7 +1569,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 			goto error;
 
 		/* create memory block devices after memory was added */
-		ret = create_memory_block_devices(start, size, nid, NULL, group);
+		ret = create_memory_block_devices(start, size, nid, NULL, group,
+						  movable_only);
 		if (ret) {
 			arch_remove_memory(start, size, params.altmap);
 			goto error;
-- 
2.52.0


