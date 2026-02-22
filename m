Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5EBC624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117666B00BB; Sun, 22 Feb 2026 03:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0ADF66B00BD; Sun, 22 Feb 2026 03:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E90656B00BE; Sun, 22 Feb 2026 03:50:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D17566B00BB
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:20 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 96E7513B45B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:20 +0000 (UTC)
X-FDA: 84471471000.20.7A30B35
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC6692000C
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="u2KHMW/3";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qurhf8VxnZAam+8t9KEHmJsyHZdR8IkiLqv08LH4QHY=;
	b=XJKWcRYX6S72K11+4u4c3IOzsVlUowL6CaaKuiwNee1Zh8QMIMVRmXQxrSl3lwu4sMJDEo
	AMiAB5yBU2G/KRx5cbKoS/azsse699AW1EE8BSEHPet+mLipxv4aFImJo6anUe/mz+gyk0
	p6UuogdSLmivZH2wC/O+353enNPBdcw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="u2KHMW/3";
	spf=pass (imf03.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750218; a=rsa-sha256;
	cv=none;
	b=McuIAKpNt7WOE4dxjnDZ5W+o5OK/zNP9iZNMoOvEO1fYWgV+Wjzj08wLVMik/svCvsaeLN
	LOEk4cxRt3OkrE5bLQPiK8NcluOpR7tTxLANYgj3wCIQMAi0O+bGvxDKDfU+kH2+MFXYTz
	Kf2foDL4Na/xRAqvcGQV7IyE6+FTPmw=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-505e2e4c35fso29757381cf.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:50:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750218; x=1772355018; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qurhf8VxnZAam+8t9KEHmJsyHZdR8IkiLqv08LH4QHY=;
        b=u2KHMW/3OU1YmdvnHL2mUpAmiVwFdH9mZndPdFZK8kpn5Elo7fapjxinnPzQODv12J
         XszY2KoYz8OoacRfjvhqJKOPltdNufs64OK4q37PcbNY1IZ74eC9Wi6OZ+bU4q9myUT4
         6Ix+6T9U7CafXPkAFqUb+rEObUC+kxiC8mc5jJ6/3eY/5Ve1AGnlLCOJl4NJTA0MssJ4
         LfnG1DK1AZwTPduELrJqK2CnL6w+7X4Mrk5VB3q+1/FQ06fjz8emNFk+IThh3k7y/4iG
         EvFztFCkdxWzgd5t7swqb/9BolaLYNMDn2GPstLbb5Xp2WfLrooX3IKvAfPgUbV5dLjd
         21iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750218; x=1772355018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qurhf8VxnZAam+8t9KEHmJsyHZdR8IkiLqv08LH4QHY=;
        b=KP2+VnqFbQlbRxy3zCIq2C/KnsuK7P7fdwan25WsLnPC4JIITck4j4l1uyxQYqBRNx
         0aQVK41kSQSMyorzqln4iWPEOd7SkmydUyR/8ngq738gvJepAgRW/3VWHRsMOyazMd3y
         q7vsQ5hfZHDmmJBQY3TWQ+WzPnNzorh8F/CB9US92vqUdiYJ9/MyA/yYMmUBR5SnNgyN
         4KfRxRMeXecMWbJ4bf0OAEVPOidc+HjXbC5lRxpzTuUPW8kUG08iVd9WYD5370qHDuKb
         /TytC80NxvyulLfd1o7gEQkfooN/egJ8QJQ6afBNomgckflnHuaAIkaLQfqoUTZx2g6/
         jWog==
X-Forwarded-Encrypted: i=1; AJvYcCUuofyzhpJHhL1bsp95sBS7S1n9cd5VzzXIIvU9XlWA4WILwDJ9mFehu+k4J8FgqfqS2/VvLnbDQA==@kvack.org
X-Gm-Message-State: AOJu0YyXfmmrVvtAbbXdvfHOxZEJI/LC1hCSKECyZaA0qkBjk5JmSq1E
	ySDl/vD9IKhBbFBCBWwhj7FkGBGa/9ThVOTumFGPPMF5dnlHPdJrPQvV/Wp+M9zCwXQ=
X-Gm-Gg: AZuq6aL/wfJVcZ8ovZG27o/KTSIuZ6BCtz6E60qevnrZHgL0nDEEGgwk5JJ9DDG62F0
	HZkps7CxdoKVOhC/EzUbl7YNuR4uzESEByfMIPaSYhIS9T5fMKWf3KAGsnSKdv3DcgsjTsKzxVm
	ly4sGuzGjd5TrxImNch4n2LDWINWJ1F8SxPY+2PuF2foiZoytFzXjcsCVqIF02eEeNsUj/OMM9I
	4ftN0SVJLialcfc34zrp/sqh+PwRdn3isfynTqV1Nw0NXW36H1coaGnzOgsREwbmcSHXycB4csV
	97yiberXHzsSYZMa0NMzNlic2TBjR4Z/a+xnKqKrLcifkCj1zLAp5s682CygJtQ0cB8Fe9Fr8l3
	iNBre5d+oDL0YoF8bB4VWpYlGE7Cd46Uc1EeAocmAAUpYCaRLl0F4zM81aHXr7vezxWHTFHWYuE
	vqhvnnFy9ANo73BiIU2t/DvkijRg8y4yFb/qi/fr8ds9vkmlYNS4zE0VLjwRFMGvQec94Q0EhAU
	bkHSWD1Q6fYJpY=
X-Received: by 2002:a05:622a:15c9:b0:501:4e87:70b2 with SMTP id d75a77b69052e-5070bd20e4amr73625991cf.69.1771750217875;
        Sun, 22 Feb 2026 00:50:17 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:50:17 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 22/27] mm/memory_hotplug: add add_private_memory_driver_managed()
Date: Sun, 22 Feb 2026 03:48:37 -0500
Message-ID: <20260222084842.1824063-23-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CC6692000C
X-Stat-Signature: 6gdtqmzweetos61hhmpd4fnfnojmkq4p
X-Rspam-User: 
X-HE-Tag: 1771750218-74001
X-HE-Meta: U2FsdGVkX1/Dba91x2A1DxwwK7MUsekH7R9q7mAHRs+OQC+ZLM5E7K32ir4T+uPoHslZEVwGMOi+SY9hiBmkZWmQyJvcvgiO10hsi0JZk76iuS+XY++F9eFBx1q1T6GuZaKrF/iybF8amlR7tN79c/oPXFMQhLa6ZWTMC7Ruxiz+uWAaWeIs+q8/KaBzVrZIDTG+62+idvkflbXmX9HsUeLTVw0aT4kaKs3YzcVs1Ll2BYi3lWybloTu/5JZEcfEZ1j4iaELiHAZwVnYiQvTeNgzl4HjVHgR+27S/2MpMCitxBsJ7f7Z2igmnwakJAGL81j09z58XdlV/Y+mpwXoNAHEgGRlRWHzAfDfNqX/1uWaApOzXXaNq44Ffcwj7mFZirmZ7ikUagTS7T9JA6zKrcesVfSkEkrLA1zV/FqDaEOGADl4J6JNEXjvm+deNe4fP6HXbv7MnbjLbrrp6ZcQ11w15l5mcuRy8s7ZX6wPxRsPzDvz7qFnXPbAymST1MXXMxx+9VzYUMKo9rkRWPJP4KwTMlZts+LjSdjbQidFpCG9zhzXp1a2XHhgWAZDRG7Omo8CAO9K3TIqRzIEFYs39HjRjD8KQ0wFWnJNOBgH73+mmxo7CMHaFgKt03FI18XXQtCcG3rNfwoXvEekRCUjftDOFZopsM5Q+gNcZ1xb4yGYab7DxFUcc9h7rLGB47WdzaOwqqTwx4deSpvI7svLCB6PM6vzuQYBt8y4I3q7xTiMnyATr6uXdKU+kw2HMIopL2ghdV+DOqWUYs+etwWpULrB8kqX5xJEtm/n06l0ZvUFJmbj1YOIlSB+hgRz2gMsVTrjqSpr0mtXESeYMiNSTcTUqeRQplXKhx4u+nloyzluDvDK2NbTXB+POd+vfsCcjBJSa+0mIYaa+AQFI8AV/2VH2e4x9bNY07BkaDUIblw8l/uf8HgvWJPVwNK/lRtyv13GxN9hJlLTlngp4OO
 MVo3dDt2
 a9GG/LicNLrzIZNb17tyZ4EPI7zG5mndxlRZw9DTeMjeGcuOSGCELeMSgDMFtNnNYj4KSjLKe+LcldNNgeTPiDT7SmFOp8Az9cBgIbk7olTcfSiaxKZQ1Dx8T8Acw1LZ2/QvzJsrS4lKmxFfCsUyrrOITge3n7Hfo9zaaIgYCSpQCugfyFMtPPbw8QiCS70Hkd0mfHo7JjGWtRBUB5BjfsRnqzl6TpJBT7rI5K6+85qTAvOgEHeGyp6viGmyy/EFH3yubHWxYq9FZVJPkPVlcotWd0ClMMuWcVvhYg+XpGTCRbFq+6J8W18R3vtHu5g0GjOuQH0sLAJMQ9c40TdGW6m6YwZzKS0oVB5h48I1gruoiNIr0PcywaFGF0KwzZZTo1Tfpz92SAYBwf3u+78nyO/0eSKqNoa3EDOY+AivjQYcu6xc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new function for drivers to hotplug memory as N_MEMORY_PRIVATE.

This function combines node_private_region_register() with
__add_memory_driver_managed() to ensure proper ordering:

1. Register the private region first (sets private node context)
2. Then hotplug the memory (sets N_MEMORY_PRIVATE)
3. On failure, unregister the private region to avoid leaving the
   node in an inconsistent state.

When the last of memory is removed, hotplug also removes the private
node context. If migration is not supported and the node is still
online, fire a warning (likely bug in the driver).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h |  11 +++
 include/linux/mmzone.h         |  12 ++++
 mm/memory_hotplug.c            | 122 ++++++++++++++++++++++++++++++---
 3 files changed, 135 insertions(+), 10 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 1f19f08552ea..e5abade9450a 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -293,6 +293,7 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 extern int remove_memory(u64 start, u64 size);
 extern void __remove_memory(u64 start, u64 size);
 extern int offline_and_remove_memory(u64 start, u64 size);
+extern int offline_and_remove_private_memory(int nid, u64 start, u64 size);
 
 #else
 static inline void try_offline_node(int nid) {}
@@ -309,6 +310,12 @@ static inline int remove_memory(u64 start, u64 size)
 }
 
 static inline void __remove_memory(u64 start, u64 size) {}
+
+static inline int offline_and_remove_private_memory(int nid, u64 start,
+						    u64 size)
+{
+	return -EOPNOTSUPP;
+}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 #ifdef CONFIG_MEMORY_HOTPLUG
@@ -326,6 +333,10 @@ int __add_memory_driver_managed(int nid, u64 start, u64 size,
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
+int add_private_memory_driver_managed(int nid, u64 start, u64 size,
+				      const char *resource_name,
+				      mhp_t mhp_flags, enum mmop online_type,
+				      struct node_private *np);
 extern void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 				   unsigned long nr_pages,
 				   struct vmem_altmap *altmap, int migratetype,
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 992eb1c5a2c6..cc532b67ad3f 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1524,6 +1524,18 @@ typedef struct pglist_data {
 #endif
 } pg_data_t;
 
+#ifdef CONFIG_NUMA
+static inline bool pgdat_is_private(pg_data_t *pgdat)
+{
+	return pgdat->private;
+}
+#else
+static inline bool pgdat_is_private(pg_data_t *pgdat)
+{
+	return false;
+}
+#endif
+
 #define node_present_pages(nid)	(NODE_DATA(nid)->node_present_pages)
 #define node_spanned_pages(nid)	(NODE_DATA(nid)->node_spanned_pages)
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index d2dc527bd5b0..9d72f44a30dc 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -36,6 +36,7 @@
 #include <linux/rmap.h>
 #include <linux/module.h>
 #include <linux/node.h>
+#include <linux/node_private.h>
 
 #include <asm/tlbflush.h>
 
@@ -1173,8 +1174,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
 			       true);
 
-	if (!node_state(nid, N_MEMORY)) {
-		/* Adding memory to the node for the first time */
+	if (!node_state(nid, N_MEMORY) && !node_state(nid, N_MEMORY_PRIVATE)) {
 		node_arg.nid = nid;
 		ret = node_notify(NODE_ADDING_FIRST_MEMORY, &node_arg);
 		ret = notifier_to_errno(ret);
@@ -1208,8 +1208,12 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	online_pages_range(pfn, nr_pages);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
-	if (node_arg.nid >= 0)
-		node_set_state(nid, N_MEMORY);
+	if (node_arg.nid >= 0) {
+		if (pgdat_is_private(NODE_DATA(nid)))
+			node_set_state(nid, N_MEMORY_PRIVATE);
+		else
+			node_set_state(nid, N_MEMORY);
+	}
 	if (need_zonelists_rebuild)
 		build_all_zonelists(NULL);
 
@@ -1227,8 +1231,14 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	kswapd_run(nid);
-	kcompactd_run(nid);
+	/*
+	 * Don't start reclaim/compaction daemons for private nodes.
+	 * Private node services will decide whether to start these services.
+	 */
+	if (!pgdat_is_private(NODE_DATA(nid))) {
+		kswapd_run(nid);
+		kcompactd_run(nid);
+	}
 
 	if (node_arg.nid >= 0)
 		/* First memory added successfully. Notify consumers. */
@@ -1722,6 +1732,54 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 }
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
+/**
+ * add_private_memory_driver_managed - add driver-managed N_MEMORY_PRIVATE memory
+ * @nid: NUMA node ID (or memory group ID when MHP_NID_IS_MGID is set)
+ * @start: Start physical address
+ * @size: Size in bytes
+ * @resource_name: "System RAM ($DRIVER)" format
+ * @mhp_flags: Memory hotplug flags
+ * @online_type: MMOP_* online type
+ * @np: Driver-owned node_private structure (owner, refcount)
+ *
+ * Registers node_private first, then hotplugs the memory.
+ *
+ * On failure, unregisters the node_private.
+ */
+int add_private_memory_driver_managed(int nid, u64 start, u64 size,
+				      const char *resource_name,
+				      mhp_t mhp_flags, enum mmop online_type,
+				      struct node_private *np)
+{
+	struct memory_group *group;
+	int real_nid = nid;
+	int rc;
+
+	if (!np)
+		return -EINVAL;
+
+	if (mhp_flags & MHP_NID_IS_MGID) {
+		group = memory_group_find_by_id(nid);
+		if (!group)
+			return -EINVAL;
+		real_nid = group->nid;
+	}
+
+	rc = node_private_register(real_nid, np);
+	if (rc)
+		return rc;
+
+	rc = __add_memory_driver_managed(nid, start, size, resource_name,
+					 mhp_flags, online_type);
+	if (rc) {
+		node_private_unregister(real_nid);
+		return rc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(add_private_memory_driver_managed);
+
 /*
  * Platforms should define arch_get_mappable_range() that provides
  * maximum possible addressable physical memory range for which the
@@ -1872,6 +1930,15 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 			goto put_folio;
 		}
 
+		/* Private nodes w/o migration must ensure folios are offline */
+		if (folio_is_private_node(folio) &&
+		    !folio_private_flags(folio, NP_OPS_MIGRATION)) {
+			WARN_ONCE(1, "hot-unplug on non-migratable node %d pfn %lx\n",
+				  folio_nid(folio), pfn);
+			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
+			goto put_folio;
+		}
+
 		if (!isolate_folio_to_list(folio, &source)) {
 			if (__ratelimit(&migrate_rs)) {
 				pr_warn("failed to isolate pfn %lx\n",
@@ -2014,8 +2081,8 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 
 	/*
 	 * Check whether the node will have no present pages after we offline
-	 * 'nr_pages' more. If so, we know that the node will become empty, and
-	 * so we will clear N_MEMORY for it.
+	 * 'nr_pages' more. If so, send pre-notification for last memory removal.
+	 * We will clear N_MEMORY(_PRIVATE) if this is the case.
 	 */
 	if (nr_pages >= pgdat->node_present_pages) {
 		node_arg.nid = node;
@@ -2108,8 +2175,12 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	 * Make sure to mark the node as memory-less before rebuilding the zone
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */
-	if (node_arg.nid >= 0)
-		node_clear_state(node, N_MEMORY);
+	if (node_arg.nid >= 0) {
+		if (node_state(node, N_MEMORY))
+			node_clear_state(node, N_MEMORY);
+		else if (node_state(node, N_MEMORY_PRIVATE))
+			node_clear_state(node, N_MEMORY_PRIVATE);
+	}
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
@@ -2461,4 +2532,35 @@ int offline_and_remove_memory(u64 start, u64 size)
 	return rc;
 }
 EXPORT_SYMBOL_GPL(offline_and_remove_memory);
+
+/**
+ * offline_and_remove_private_memory - offline, remove, and unregister private memory
+ * @nid: NUMA node ID of the private memory
+ * @start: Start physical address
+ * @size: Size in bytes
+ *
+ * Counterpart to add_private_memory_driver_managed().  Offlines and removes
+ * the memory range, then attempts to unregister the node_private.
+ *
+ * offline_and_remove_memory() clears N_MEMORY_PRIVATE when the last block
+ * is offlined, which allows node_private_unregister() to clear the
+ * pgdat->node_private pointer.  If other private memory ranges remain on
+ * the node, node_private_unregister() returns -EBUSY (N_MEMORY_PRIVATE
+ * is still set) and the node_private remains registered.
+ *
+ * Return: 0 on full success (memory removed and node_private unregistered),
+ *         -EBUSY if memory was removed but node still has other private memory,
+ *         other negative error code if offline/remove failed.
+ */
+int offline_and_remove_private_memory(int nid, u64 start, u64 size)
+{
+	int rc;
+
+	rc = offline_and_remove_memory(start, size);
+	if (rc)
+		return rc;
+
+	return node_private_unregister(nid);
+}
+EXPORT_SYMBOL_GPL(offline_and_remove_private_memory);
 #endif /* CONFIG_MEMORY_HOTREMOVE */
-- 
2.53.0


