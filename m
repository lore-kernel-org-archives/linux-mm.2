Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D771BC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2F946B00C5; Mon, 20 Jul 2026 15:35:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07936B00C6; Mon, 20 Jul 2026 15:35:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82516B00C7; Mon, 20 Jul 2026 15:35:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A73436B00C5
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 373B11202B4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:46 +0000 (UTC)
X-FDA: 85010159892.18.B69A798
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 84C8214000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NYtXsoe8;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sYpFeVf27+jOruO49PHN55cKYyhatP0JJwzbq2uG7o=;
	b=f3qHcYBak9ktAUMDPkX1VH/ABwUBuIl/RWF/yZKqNqNOUEP3CcdM0zY3tM2DTLZadlkfXp
	aZP5tjD3kD3oFJLA29C5SU2rflFfmsK5hsyHNyvAODwWqt8xJMKe6W5K8bkaeRuLVzh0Yr
	iBSpO9RqIb2HNR5Umu0QPJcQXU965sg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=NYtXsoe8;
	spf=pass (imf23.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576144;
	b=e1bxj3IlpBsiolDXxTqpjNengrnLok7ddE1EbWgy9sK2M4KOMQv1cNR80lJQDkf2ORg/tE
	CgGRFp6HcS54WMa5uGZJrhRsJPGoM8FEpBd9iYK6Cd6LkpklDNbs9St3tJowSYkQykQTvn
	QRu2czAUBfz5MpR7dzrQXAz0+I0EGzI=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e5d50b0dbso540145485a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576144; x=1785180944; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0sYpFeVf27+jOruO49PHN55cKYyhatP0JJwzbq2uG7o=;
        b=NYtXsoe8H6ZE9dy1Ane8XZUyold/6YhUQMYKichTwDeYvUtvt6m48ttuLYmwVxToI0
         RFMccEDo0Lv8FIGyPLZI+jS6d/PfP9ErsYFMeSb8FRSrj2XmQf+6oa7q8F4Ag2tlV/HV
         gnNDvXDE4NXS9dDbmdkNUy9l16G/sjBbkIV5oG5RAyFm0KY1YWUjeI2kB8NcIXl42ugs
         YTvj64bnZGOn3oDLPfJyKaCROoxK2bhR9MJBdR1dW2CndY3tcVuE3Lbh3NzeEgWLawuV
         /+gkXF2Zb7Df6tFknxAujuMgDd+3A69gJXUk1vgjscBw9tkPlb+9iluS6XrA55gJS85c
         FjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576144; x=1785180944;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0sYpFeVf27+jOruO49PHN55cKYyhatP0JJwzbq2uG7o=;
        b=JEkHSf4gt50/hdMKRvWNp6oZaex80ow4yofVyLpEQ0Q/4Ak6xYvbn9xPkApeGQAxep
         E1n2z+TGYub7Ycst4i/X6MII3ZPMhBkqEN3Bj8sBsze+/mDtUNnWK0Ib+0Qg1/qqAcOw
         Sc3LJEscSJjS4mIIoTpMmexiCIqUDBBO/CyK9OgHqOBbQBowX3xh5mnPJm7gyWmjsooz
         l0Q6aSjnOpbDUB5awTdkUrO1GZrgxKF2daKvEmC5gG0qeDDFNcuNof2Xy+664OMJYpxv
         aGtJwEMRb1a2+ow0ty4819yeWywtmnwEfF8ycZVGClN71kZCWnkMS/bvV4+5ZH0jXg+5
         wEYg==
X-Gm-Message-State: AOJu0Yy0ZfIw+74p+RWolkrVqYv9Luhzmi68o0jVKMTDzUXFj9tkqnY5
	K+++2xhlTpOImEB7rzIJFJG2pSZOX6m134gkmBmmSQH4pahTug195sZnA4bnPsn2P3RYQ5T+FlM
	FlKYR
X-Gm-Gg: AfdE7cloi0m+MWQDc7PoaX2edOd3IBu9N3iaglzhRpxRK4okI4YjMhRnSVPutd/GLpo
	5RrQQRjzoRU1GZJFvfB+x/Tvs1SycTAjiBuKknRKgGNs5pTZ+9ugjd1RKyBnyCkixrJwl2fjaJg
	Vnjr498zCT5bl+RGM0cJzYrHd6SHxdNWaoXRAz4MR6s1tjC5FPeWIz1cMrE+K/WJlGW69eZn1uF
	9mlvbICwGVqy9J3ECa6MggeOFXHOsxktNG+SLHZ8PZ6VfvWjyfdAfJxTBvoWqmp1PhNPHun7A2E
	moizD1oSQWObpu/xrgD0bN9w2nxG8cwJPN+BYGr32bxxmAanU9HPqBXMpB1V7MCZoKqRiGjQP93
	JLLNC/q6MaQFOWdezPeDDaI2Bf4X7R8TqBftgWF1zdNdTJzNNP9NgkOissLYOSvlg4QJXqIG/vv
	OfKzkkMthNlkv67indiJwSXnXmKU3nNroZIosIK9XVe2XlCx8VMMvnjxap4a4IN5U=
X-Received: by 2002:a05:620a:471f:b0:916:10f6:780f with SMTP id af79cd13be357-930b3ec94cbmr1617831585a.27.1784576143523;
        Mon, 20 Jul 2026 12:35:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:43 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE node hotplug
Date: Mon, 20 Jul 2026 15:34:19 -0400
Message-ID: <20260720193431.3841992-26-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84C8214000F
X-Stat-Signature: q14pgf18rxugepfs8cpk4x9h35j6yepy
X-HE-Tag: 1784576144-608815
X-HE-Meta: U2FsdGVkX18XSK4B6Nn8lkBVtkOJvkcN44Ip3svRz6o94TuwLIKGqTyvYuIfdeGZtk+dXYh3Ea7FzEHVhMkKt/pLIhNzBg6NF3PIlUMXQbg9ZcaqR+H2MkYMcCsPZ7gcDQ32gHJHRXwxvFDUs+edNT0RMb/zyvCDtXOkjPEFFzp0Vh4gWa77SHCSSSyElXJl2fndgfT+qu22qZNmW4j1nNpWq2xtM+75/pX27oDbhnmg8mtWU1P8PPBM80B+ZHagknx7+k1F1YCmhyQte9yEOfUn0tEU6rfzqOQyM1nDuWOVsgOxYEaQ8I+BlLq0NylDz5yGvFOoSFR0hFOT+g/KgtHX4xVG7cVJj1eBkNosQw/JGC8oJu0VUdEfyA79iiEiABMf0Wt5qO4fgrouEoLyzw250VGSaspvS3j4cBFqfh00x4uivj3en2rBpTfH7uIppgaXA/Vk3ndt4puec6kT2O3oswv2ZsL1vCmwL8cSls6yii06jI6xuVV9vwF2hGq8jvpm4sWodro4lpZnLGflglBhnw0uEzD7G85T5Xw0BbZdsnqv8n6S1e9ezd+E13FTM24cCCYD80rXyGrMQlF4F9tLsWRyTRvzdasUPWDQEgVKhuPYoHg6JF76h2wjR5O3qM996qX10NyE5rdokMAxxqOwY44bVd7EXd/zv2ulE7Dz8MI8ltjGDcb3fTjM7KrI9BIEHOTu+gf5p8RWCfBdhc9XPhLwEt3/bf1rpd69iGx7jmaqTswTfQHcbLNaMtQHv63ExdVz2JSVCizMTcEU8dNUA8wVTeI7smE1y6p/hPzQhGZ1qvnN3a3VwZbw/QhKvpJm8aM6ffiByiE4EDrO09IWy+4EMKr/xhsVuEqC9/jVwraf/MS1gVPotQ5bdcAKNSa/WrN9GI/iU+VoGGfnTN91VrHVmm0PqKZtIDTRNp3xlImJa42Pq0/uxgUKI1FiJRYNOKMkOVc39XIb3gv
 i0ExqZb9
 iTmIlUP0bdDqicn3dLOZo2VEVtzmv3IV3u7RFqzG22CiX4OTWOzxaqbdegVz0tV9Ec6So0eId4p+jUNNZtXq02UYu00wbBuMGwu28mgB3UEhBSwTi8p76M1/NrBUAXBAtqcVepMqih3RTbSecwTFniH0m0DHYvzzVSr/Rbsx2izgvakeSTWwQiAtZwaI53vJR6dOC1RpaajPDAmlRBvvq+rewsAzvJlHR1l/pE0W++acMU86ZhRJEFZ26XG08nB3dpjQ6kpdTk9M827ESJv7n4q0ZG5IkltStGWy5IOf3UzwA6m0thbfuNN7zSTvoLwzVYYyxab9XoB9mLrH6+WxAjykAaMSasfDUNSvTiH/vjxE0qAISzIRM5uDm3vy33CQduVdpMx4nHPpVjGOteBeiAFnJ98OBJxge7ykzSyikFmhb84E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add add_private_memory_driver_managed() to let modules hotplug
memory onto an N_MEMORY_PRIVATE node they control.

Ownership is denoted via `struct node_private` and a private node
can only have a single owner.

The common __add_memory_driver_managed function is only exported to
in-tree modules that allow hotplug of N_MEMORY nodes. The new private
wrapper does not allow N_MEMORY hotplug, only N_MEMORY_PRIVATE.

When node_private is NULL hotplug behaviour is unchanged.

When node_private is non-NULL the node owner is registered before any
memory is added.  Later during hotplug, when memory is actually onlined,
hotplug marks the node N_MEMORY_PRIVATE instead of N_MEMORY.

If the add fails the registration is undone.

offline_pages() clears N_MEMORY_PRIVATE the same as N_MEMORY, and
offline_and_remove_memory_ranges() drops private node registration
once the last node's memory is removed.

Private nodes are opted out of starting kswapd/kcompactd by default.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c             |  2 +-
 include/linux/memory_hotplug.h |  5 +-
 mm/memory_hotplug.c            | 99 ++++++++++++++++++++++++++++++----
 3 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a48d699cf344c..c3faf18e7f85d 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -126,7 +126,7 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 		 */
 		rc = __add_memory_driver_managed(data->mgid, range.start,
 				range_len(&range), kmem_name, mhp_flags,
-				online_type);
+				online_type, NULL);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index b39605d308963..fcceb0a423579 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -305,7 +305,10 @@ extern int add_memory_resource(int nid, struct resource *resource,
 			       mhp_t mhp_flags);
 int __add_memory_driver_managed(int nid, u64 start, u64 size,
 				const char *resource_name, mhp_t mhp_flags,
-				enum mmop online_type);
+				enum mmop online_type, struct node_private *np);
+int add_private_memory_driver_managed(int nid, u64 start, u64 size,
+				      const char *resource_name, mhp_t mhp_flags,
+				      enum mmop online_type, struct node_private *np);
 extern int add_memory_driver_managed(int nid, u64 start, u64 size,
 				     const char *resource_name,
 				     mhp_t mhp_flags);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2b9c0830821e6..be230ac9efe5a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1169,7 +1169,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
 			       true);
 
-	if (!node_state(nid, N_MEMORY)) {
+	if (!node_state(nid, N_MEMORY) && !node_is_private(nid)) {
 		/* Adding memory to the node for the first time */
 		node_arg.nid = nid;
 		ret = node_notify(NODE_ADDING_FIRST_MEMORY, &node_arg);
@@ -1204,13 +1204,20 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	online_pages_range(pfn, nr_pages);
 	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
 
+	/*
+	 * N_MEMORY and N_MEMORY_PRIVATE are mutually exclusive, determine
+	 * which is correct based on whether the pgdat->private is set.
+	 */
 	if (node_arg.nid >= 0)
-		node_set_state(nid, N_MEMORY);
+		node_set_state(nid, pgdat_is_private(NODE_DATA(nid)) ?
+				    N_MEMORY_PRIVATE : N_MEMORY);
 	/*
 	 * Check whether we are adding normal memory to the node for the first
 	 * time.
 	 */
-	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
+	if (!node_is_private(nid) &&
+	    !node_state(nid, N_NORMAL_MEMORY) &&
+	    zone_idx(zone) <= ZONE_NORMAL)
 		node_set_state(nid, N_NORMAL_MEMORY);
 
 	if (need_zonelists_rebuild)
@@ -1230,8 +1237,11 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
 	/* reinitialise watermarks and update pcp limits */
 	init_per_zone_wmark_min();
 
-	kswapd_run(nid);
-	kcompactd_run(nid);
+	/* Private nodes opt-out of reclaim/compaction by default */
+	if (!node_is_private(nid)) {
+		kswapd_run(nid);
+		kcompactd_run(nid);
+	}
 
 	if (node_arg.nid >= 0)
 		/* First memory added successfully. Notify consumers. */
@@ -1649,6 +1659,8 @@ EXPORT_SYMBOL_GPL(add_memory);
  * @resource_name: Resource name in format "System RAM ($DRIVER)"
  * @mhp_flags: Memory hotplug flags
  * @online_type: Auto-Online behavior (offline, online, kernel, movable)
+ * @np: driver-owned node_private to online the node as N_MEMORY_PRIVATE, or
+ *	NULL for ordinary system RAM
  *
  * Add special, driver-managed memory to the system as system RAM. Such
  * memory is not exposed via the raw firmware-provided memmap as system
@@ -1675,9 +1687,11 @@ EXPORT_SYMBOL_GPL(add_memory);
  */
 int __add_memory_driver_managed(int nid, u64 start, u64 size,
 		const char *resource_name, mhp_t mhp_flags,
-		enum mmop online_type)
+		enum mmop online_type, struct node_private *np)
 {
+	int real_nid = nid;
 	struct resource *res;
+	struct memory_group *group;
 	int rc;
 
 	if (!resource_name ||
@@ -1688,6 +1702,19 @@ int __add_memory_driver_managed(int nid, u64 start, u64 size,
 	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
 		return -EINVAL;
 
+	/* Register a private-node owner before adding memory. */
+	if (np) {
+		if (mhp_flags & MHP_NID_IS_MGID) {
+			group = memory_group_find_by_id(nid);
+			if (!group)
+				return -EINVAL;
+			real_nid = group->nid;
+		}
+		rc = node_private_register(real_nid, np);
+		if (rc)
+			return rc;
+	}
+
 	lock_device_hotplug();
 
 	res = register_memory_resource(start, size, resource_name);
@@ -1702,10 +1729,41 @@ int __add_memory_driver_managed(int nid, u64 start, u64 size,
 
 out_unlock:
 	unlock_device_hotplug();
+	if (rc < 0 && np)
+		node_private_unregister(real_nid);
 	return rc;
 }
 EXPORT_SYMBOL_FOR_MODULES(__add_memory_driver_managed, "kmem");
 
+/**
+ * add_private_memory_driver_managed - add private driver-managed memory
+ * @nid: NUMA node ID where the memory will be added
+ * @start: Start physical address of the memory range
+ * @size: Size of the memory range in bytes
+ * @resource_name: Resource name in format "System RAM ($DRIVER)"
+ * @mhp_flags: Memory hotplug flags
+ * @online_type: Auto-Online behavior (offline, online, kernel, movable)
+ * @np: private node context for the owner - mandatory.
+ *
+ * Add private driver-managed memory.  Private node context is required to
+ * avoid the memory being added as a normal N_MEMORY node.
+ *
+ * See __add_memory_driver_managed for more details.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int add_private_memory_driver_managed(int nid, u64 start, u64 size,
+				      const char *resource_name, mhp_t mhp_flags,
+				      enum mmop online_type, struct node_private *np)
+{
+	if (!np)
+		return -EINVAL;
+
+	return __add_memory_driver_managed(nid, start, size, resource_name,
+					   mhp_flags, online_type, np);
+}
+EXPORT_SYMBOL_GPL(add_private_memory_driver_managed);
+
 /**
  * add_memory_driver_managed - add driver-managed memory
  * @nid: NUMA node ID where the memory will be added
@@ -1726,7 +1784,7 @@ int add_memory_driver_managed(int nid, u64 start, u64 size,
 {
 	return __add_memory_driver_managed(nid, start, size, resource_name,
 			mhp_flags,
-			mhp_get_default_online_type());
+			mhp_get_default_online_type(), NULL);
 }
 EXPORT_SYMBOL_GPL(add_memory_driver_managed);
 
@@ -2041,7 +2099,7 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	/*
 	 * Check whether the node will have no present pages after we offline
 	 * 'nr_pages' more. If so, we know that the node will become empty, and
-	 * so we will clear N_MEMORY for it.
+	 * so we will clear N_MEMORY(_PRIVATE) for it.
 	 */
 	if (nr_pages >= pgdat->node_present_pages) {
 		node_arg.nid = node;
@@ -2146,8 +2204,10 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
 	 * Make sure to mark the node as memory-less before rebuilding the zone
 	 * list. Otherwise this node would still appear in the fallback lists.
 	 */
-	if (node_arg.nid >= 0)
+	if (node_arg.nid >= 0) {
 		node_clear_state(node, N_MEMORY);
+		node_clear_state(node, N_MEMORY_PRIVATE);
+	}
 	if (!populated_zone(zone)) {
 		zone_pcp_reset(zone);
 		build_all_zonelists(NULL);
@@ -2211,6 +2271,15 @@ static int count_memory_range_altmaps_cb(struct memory_block *mem, void *arg)
 	return 0;
 }
 
+static int collect_memblock_nodes_cb(struct memory_block *mem, void *arg)
+{
+	nodemask_t *nodes = arg;
+
+	if (mem->nid != NUMA_NO_NODE)
+		node_set(mem->nid, *nodes);
+	return 0;
+}
+
 static int check_cpu_on_node(int nid)
 {
 	int cpu;
@@ -2474,10 +2543,11 @@ EXPORT_SYMBOL_GPL(offline_and_remove_memory);
 int offline_and_remove_memory_ranges(const struct range *ranges,
 		unsigned int nr_ranges)
 {
+	nodemask_t nodes = NODE_MASK_NONE;
 	unsigned long mb_count = 0;
 	uint8_t *online_types, *tmp;
 	unsigned int i;
-	int rc = 0;
+	int nid, rc = 0;
 
 	if (!ranges || !nr_ranges)
 		return -EINVAL;
@@ -2505,6 +2575,11 @@ int offline_and_remove_memory_ranges(const struct range *ranges,
 
 	lock_device_hotplug();
 
+	/* Record the nodes for the blocks to drop private-node data after */
+	for (i = 0; i < nr_ranges; i++)
+		walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
+				   &nodes, collect_memblock_nodes_cb);
+
 	/*
 	 * Phase 1: offline every block in every range.  An already-offline
 	 * block folds to success, so out-of-band offlining never blocks unplug.
@@ -2535,6 +2610,10 @@ int offline_and_remove_memory_ranges(const struct range *ranges,
 out_unlock:
 	unlock_device_hotplug();
 
+	/* Drop private node registration if they are now memoryless */
+	for_each_node_mask(nid, nodes)
+		node_private_unregister(nid);
+
 	kfree(online_types);
 	return rc;
 }
-- 
2.53.0-Meta


