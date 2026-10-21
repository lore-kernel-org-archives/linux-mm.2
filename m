Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A2B606A330
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AZ/l+3RH
Received: by kanga.kvack.org (Postfix)
	id 6B1756B01A5; Wed, 21 Oct 2026 02:18:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 662846B01A7; Wed, 21 Oct 2026 02:18:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577666B01A9; Wed, 21 Oct 2026 02:18:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A41C6B01A5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:18:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0B1840490
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:18:43 +0000 (UTC)
X-FDA: 85345629726.11.E82E719
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id EDE7280008
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:18:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AZ/l+3RH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Shyqse1OL+M2C4KCAQ1mJmEl8y6xAq/jS1H+63KIlcM=;
	b=UCT+4y6eEWJeGW5c793S73182QRaNnOAi0qqk7VYCiNWWnFv8muXOtOsy5aWBDnp9MCek1
	//Hid3wKT5Np8r1CecR5s8On4taDR46DsD9HQpbQLeaK4iugmkP3lrzxcR4ii25qwtOkCe
	6jXxp3Ws6ZC20QN4nCk1qCt7ozLaZDs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="AZ/l+3RH";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563521;
	b=S0QJDL3F6Yjhq4BAgOaMI+wDC1tfj11xZcJhu0w+29+r3uUZNPjsZ7epUDMhGEqST0h1gv
	QBGFZB0uIbdjLkcMkTiVzQEwu3VbEvbHiNKBddcQJrrfCP6Q3++1BN8fOYhqyamqeK+NFo
	25H3kN868KSjU8D1Gcgzi9OnZzfD4+Q=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6798af41644so218334d50.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792563521; x=1793168321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Shyqse1OL+M2C4KCAQ1mJmEl8y6xAq/jS1H+63KIlcM=;
        b=AZ/l+3RHb0CcAeq46EdQW/Ig4WWpb4sS7iLOXqwPSTIXFeINcS3ShQPxi8/LeHy7Ap
         /gcLRswqp55uCQnODOfzUFgY4MYDTxshWCB/s4gR+Kf4rG9/PE44e/0qPN0k+7q4ajRw
         +zQpx91MJ+onqCkIbajBXae+Mw/ueet4A2dk+UHosiskgkVi68ucbi7fBXvD8kfmL7Fe
         Wc+CMgd/sAFQ1RoKzOAjuMC8FeVd8R/uWwSD09hmzleDVErEu8x8bJZPmVW1KqqAgrnR
         PC7Ot8MB69ivAdwNE6ONBHvj3ENbZYK3EE4qxD5p1SaAsYLMRmTCGUid18ocxC2KIECL
         bInA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792563521; x=1793168321;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Shyqse1OL+M2C4KCAQ1mJmEl8y6xAq/jS1H+63KIlcM=;
        b=Ay3yykCI91eol5U/Mi+iZ0N0r8n9gTcESixE3/Em9tFzo2t/GxHt20GjyhCNn/3wiB
         qkf2SP5UlZG+zY7yYuZqMzLKgpzrErtilXryilYTwbYQ4PC4EU4ZqmnpmyDWrsDvX46O
         CuhwqDcgfW8mXo9nPmmjEq++nRieSDPCKaR4wbBz27+zKBIByGrNZqnpiDBXr2Tobg1h
         O45R6WDTyfCQBw1SeF7bKpLDe8tv1lx+is0ThN6C2ARCcovmCjVkShdVTqL3Hcaq/EcV
         gCDv0aX8eltlpdLjwor3yCAn/tRsWpihLCFIUnKzG5NZOWiWRvFLO9SLkTyDLtMLSTkW
         vr0A==
X-Forwarded-Encrypted: i=1; AKwUvBxFe+H+6N8kYh5g9dszlJgAix0M0nrKC6F693xnWDZgDEZ+xMmPM8A2RzeZ8aOM18ZYQqs+hIzY3w==@kvack.org
X-Gm-Message-State: AFq9FYLSovuBoXDx1SlQGsbvs2r9bk+F0QSfPdSUsXdVUSj0YGdi6gI2
	ffG/X6i2iFfhZ7IM6p2t+VUiIJ27s4hdXhX9bRfV4XTNjWP6lmf4njpe
X-Gm-Gg: AYBFou376eaXxW2Df8NH2Hm9x60ouK4ZiP8TKrmTiIZSfLqN1BQVnsMSLbVwNHSHPm5
	fCBEGIOHYfk4x5Mbopz7lg1OTfkyYWR0+PM6tLz6zhVbqNZYlFIGLpY+TOTizJdB/qG1VDYFENf
	W5Wqbbvp0iVrA6HQWnv/05GSujJpXt8oYxYsWXwMg/1FZqNjmV/hzMyJH/uN3xCjbnUNikvKO4j
	5vMK6Y2sUa6N2Y573tou0f3H16kbFFJSmudbnnbdnfneqcNFK+zWI0IGg5aOtX2FbqhN+k7RduU
	inDbwmhcTxLAFVC4NZaIQy5Iuhi7PnvNhP1LVI3NApiMGPW8JAx+YUIWDOeg26jB3qIabhI5tyF
	e0uAjs1nnRiQRXXqrhzSSkCTJwaHE9DUe/bzi13stqdcA2l/OQOzidvWgX59a2HN10DsavNbhmW
	c0WS3f5bAF43Kcbr93kBg/+n7wRgoptY0X9M9glTdojzNpe673bEFFLDwuvRSaGLZulMkN89iaE
	oI5oCZRxwbXscEQrhRunvs0HJKKeHJtfryYzHSb0CpIxvC/B8ujxYU600DppoFV9TyOz36rPEeW
	KExsoh/boW3v18mhuM9Y3G2SvTQ33fMi8YWym3yrZHAIQSxe4HXWVUCMC/uqBmm7MA==
X-Received: by 2002:a53:ac91:0:b0:67a:11c3:6fc8 with SMTP id 956f58d0204a3-67a11c3747bmr297975d50.68.1792563520819;
        Tue, 20 Oct 2026 23:18:40 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:57::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e4c0b56sm632247d50.9.2026.10.20.23.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:18:39 -0700 (PDT)
From: Nhat Pham <nphamcs@gmail.com>
To: akpm@linux-foundation.org
Cc: chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	yosry@kernel.org,
	david@kernel.org,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	qi.zheng@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	gourry@gourry.net,
	haowenchao22@gmail.com,
	corbet@lwn.net,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	mkoutny@suse.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v6 10/12] mm, swap: defer memcg_table allocation for physical swap clusters
Date: Tue, 20 Oct 2026 23:18:35 -0700
Message-ID: <20261021061837.1569125-1-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDE7280008
X-Stat-Signature: 8ao4ji9584ngg3wjabxxn83gzcc6g9nu
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792563521-574764
X-HE-Meta: U2FsdGVkX1/kWCKWoyOLXMDrtcHomdBP721qa11mCE+vu3mDpmNIPA15+SuP0DI19+amvZgHNCanfGxEGAujIcRiJLUEsh3mjUoYcIhnjkw6PwPmi8wjaBWYGpB/qTV7/RWjMH28OTt+v5Ots+D7L3m2X2r7/aU/Km/Zxp8HpfHRc1e69SG+JQ2Xpnc/GixjKTcttTGp+c/Rgjdd6g+rzxlWSpQsGl0F6JqzTtsC11lXiak1qD/06yTiltmzvURMRAF6L1kh2BmZCitljhpQubwPKwu7fqjcAbO+32Tya7oV4LmTO13rWQgz/QbwcWuHks+2FkXrolaEn/9A+SegdYrr3hEBH265FbxwjK/57jpT7f2s0FY6qj9iwW+5+Rbqq0ODCV3LxF/n9Wkb48MQt8Lgv0PKzu2EBRdkWtr4M6OH/l67CLsFRQ3Qk73N8Cf+RTlRk8WpPXnwr3e3pWCDkyIxx6vx8SoSvUDHlLXSYPD1NH1FsQflLqaf+NorBu4ezsvKN+IeqcK8+nfx3q/VyGtrOpNeRSFCsSskP81A745XJKl5uSu4VNP2TvEZTqdm5STUPpVUVI5V0ysGfim3OC3nUMmq6StDDXwmwTzDBqV+0FWxVuqu0ohEeSR7Cv9xqXLbk+Bt+4qiJxuhglTRbPsBI+SANXrvNJVuwIL4R7CWNSzGqiNKsgaVqGcEnUgon18QmzLbG5ioyNPSbuuuG+X7+V3TQS6yx4sLHZbUsizd1TafBuf32eZmdwZrwUDc4xPQ9L7iGOLz5zPlSuyaBZXP/SG6WIPuTryNSw5MG2R3ZJghZcSjcQFYeAIeBG4bpd5cZegl5/sQaILrfP6fIKiNKyJOBu6vqApxRZhH9it5kjYE1qEkCp+slX/8bRefR+dFNMHgr3D/TjLBDctfpSq3cOORoK5evHK1HSHd2r2PlD7yzDdln0jirh/29hnT2Zc0g/tVVhLka2KfGa4
 OLY8LSYS
 CsbX2yEZ3GpfYcXGwjfgDHhVjikVySeG9ArsKZQnuCAxXoXWAdF5JAWTV5O+wzHsPmsTNZ2OGkjxmThV57a1mgeyOeAzzwwPmrsuc+dDyQOsAVxknqtyVRkMQFexR5h+V0n301k5vzsT6hMetdnYfcFoSGzMLV1Jt7vWSDyoe/KvHfhId/R58lThgPu74AOovtq+Un3I6Wh5OUz29b1pKPBZwTUpdP1rQo8VsqWtM21CRjhIR4uNYWLY649Oo7JBWHU+QEOSLECI4y8TMKpnNf6clYssJH2f8a2cm2k3yP1nOox5TDuR5zbSbweFDDsRvgscPnZDwH4xTyWQF8g+MW+ZpKaPUO+t3bRnJpm3R8ZSFneXF2ETh5+X0egYx2IktOM8HcdW0tZN3nFSbgNAXJCN8RqTQRETECzI/+n2qBTjri37m3rxQjhBz5UgJZ8EjN77ayIJ1zPGCXBNC+Jo9bhUKQXVmTeNTlaaPamrrUXW+cWVy4ufiSUaFR92RLzXH/dbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Stop allocating a memcg table for every physical swap cluster that only
ever holds vswap backings. The table costs SWAPFILE_CLUSTER *
sizeof(unsigned short) per cluster, 1 KB per 2 MB of swap on a 64-bit
kernel with 4 KB pages. On a vswap-heavy workload, where zswap writeback
is the only consumer of physical swap, that is the common case.

Such clusters never have their memcg_table read or written: vswap-layer
charging records on the vswap cluster's table, not the physical one.

Allocate eagerly only where the table is known to be needed: every vswap
cluster, and, when vswap is off, every physical cluster, since none of its
slots is then a vswap backing. A physical cluster otherwise allocates on
its first direct-use slot, and skips entirely if it only holds vswap
backings.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 83 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 19 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 12cd5caeaaf2..e95f2441fdd7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -476,7 +476,8 @@ static void swap_cluster_free_table(struct swap_cluster_info *ci)
 	swap_cluster_free_count_table(table);
 }
 
-static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+static int swap_cluster_alloc_table(struct swap_info_struct *si,
+				    struct swap_cluster_info *ci, gfp_t gfp)
 {
 	struct swap_table *table = NULL;
 	struct folio *folio;
@@ -497,7 +498,14 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
 		return -ENOMEM;
 
 #ifdef CONFIG_MEMCG
-	if (!mem_cgroup_disabled()) {
+	/*
+	 * A physical cluster under vswap may hold only vswap backings, which
+	 * record their memcg on the vswap cluster's table, not this one. Such
+	 * clusters defer memcg_table allocation until they hand out a direct-use
+	 * slot, including one for hibernation.
+	 */
+	if ((!vswap_is_enabled() || swap_is_vswap(si)) &&
+	    !mem_cgroup_disabled()) {
 		VM_WARN_ON_ONCE(ci->memcg_table);
 		ci->memcg_table = kzalloc_obj(*ci->memcg_table, gfp);
 		if (!ci->memcg_table) {
@@ -575,8 +583,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					  __GFP_NOWARN))
+	if (!swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					      __GFP_NOWARN))
 		return ci;
 
 	/*
@@ -589,8 +597,8 @@ swap_cluster_populate(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
-					   GFP_KERNEL);
+	ret = swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					       GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -867,7 +875,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 
 	ci = cluster_info + idx;
 	/* Need to allocate swap table first for initial bad slot marking. */
-	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+	if (!ci->count && swap_cluster_alloc_table(si, ci, GFP_KERNEL))
 		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
@@ -1090,7 +1098,9 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
-					    struct folio *folio, unsigned long offset)
+					    struct folio *folio,
+					    unsigned long offset,
+					    bool *nomem)
 {
 	unsigned int next = SWAP_ENTRY_INVALID, found = SWAP_ENTRY_INVALID;
 	unsigned long start = ALIGN_DOWN(offset, SWAPFILE_CLUSTER);
@@ -1119,6 +1129,23 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 			if (!ret)
 				continue;
 		}
+#ifdef CONFIG_MEMCG
+		/*
+		 * Lazy-allocate memcg_table on the first direct-use slot of a
+		 * physical cluster.
+		 */
+		if (vswap_is_enabled() &&
+		    (!folio || !folio_test_swapcache(folio)) &&
+		    !mem_cgroup_disabled() && !ci->memcg_table) {
+			ci->memcg_table = kzalloc_obj(*ci->memcg_table,
+						      GFP_ATOMIC | __GFP_NOWARN);
+			if (!ci->memcg_table) {
+				if (nomem)
+					*nomem = true;
+				goto out;
+			}
+		}
+#endif
 		if (!__swap_cluster_alloc_entries(si, ci, folio, offset % SWAPFILE_CLUSTER))
 			break;
 		found = offset;
@@ -1128,7 +1155,15 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 		break;
 	}
 out:
-	relocate_cluster(si, ci);
+	/*
+	 * On a discard-capable device, relocating a cluster whose memcg_table
+	 * allocation failed queues a discard for slots that were never used,
+	 * which folio_alloc_phys_swap() reads as progress and retries on.
+	 */
+	if (nomem && *nomem && !ci->count)
+		__free_cluster(si, ci);
+	else
+		relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
 	if (swap_is_vswap(si)) {
 		this_cpu_write(percpu_vswap_cluster.offset[order], next);
@@ -1149,7 +1184,13 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 					 bool scan_all)
 {
 	unsigned int found = SWAP_ENTRY_INVALID;
+	bool nomem = false;
 
+	/*
+	 * In rare cases alloc_swap_scan_cluster() can fail due to
+	 * memcg_table allocation failure. Short-circuit to avoid looping
+	 * over the list indefinitely.
+	 */
 	do {
 		struct swap_cluster_info *ci = isolate_lock_cluster(si, list);
 		unsigned long offset;
@@ -1157,10 +1198,10 @@ static unsigned int alloc_swap_scan_list(struct swap_info_struct *si,
 		if (!ci)
 			break;
 		offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, &nomem);
 		if (found)
 			break;
-	} while (scan_all);
+	} while (scan_all && !nomem);
 
 	return found;
 }
@@ -1181,7 +1222,8 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 	spin_lock_init(&ci_dyn->ci.lock);
 	INIT_LIST_HEAD(&ci_dyn->ci.list);
 
-	if (swap_cluster_alloc_table(&ci_dyn->ci, GFP_ATOMIC | __GFP_NOWARN)) {
+	if (swap_cluster_alloc_table(si, &ci_dyn->ci,
+				     GFP_ATOMIC | __GFP_NOWARN)) {
 		kfree(ci_dyn);
 		return SWAP_ENTRY_INVALID;
 	}
@@ -1207,7 +1249,7 @@ static unsigned int vswap_alloc_cluster(struct swap_info_struct *si,
 	}
 
 	offset = cluster_offset(si, ci);
-	return alloc_swap_scan_cluster(si, ci, folio, offset);
+	return alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
 }
 
 static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
@@ -1314,7 +1356,8 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 		if (cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(si, ci);
-			found = alloc_swap_scan_cluster(si, ci, folio, offset);
+			found = alloc_swap_scan_cluster(si, ci, folio, offset,
+							NULL);
 		} else {
 			swap_cluster_unlock(ci);
 		}
@@ -1358,7 +1401,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	if (order < PMD_ORDER) {
 		/*
 		 * Scan only one fragment cluster is good enough. Order 0
-		 * allocation will surely success, and large allocation
+		 * allocation rarely fails, and large allocation
 		 * failure is not critical. Scanning one cluster still
 		 * keeps the list rotated and reclaimed (for clean swap cache).
 		 */
@@ -1373,7 +1416,7 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 	/* Order 0 stealing from higher order */
 	for (int o = 1; o < SWAP_NR_ORDERS; o++) {
 		/*
-		 * Clusters here have at least one usable slots and can't fail order 0
+		 * Clusters here have at least one usable slots and rarely fail order 0
 		 * allocation, but reclaim may drop si->lock and race with another user.
 		 */
 		found = alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
@@ -1594,7 +1637,7 @@ static swp_entry_t swap_alloc_fast(struct folio *folio)
 	if (ci && cluster_is_usable(ci, order)) {
 		if (cluster_is_empty(ci))
 			offset = cluster_offset(si, ci);
-		found = alloc_swap_scan_cluster(si, ci, folio, offset);
+		found = alloc_swap_scan_cluster(si, ci, folio, offset, NULL);
 	} else if (ci) {
 		swap_cluster_unlock(ci);
 	}
@@ -1982,7 +2025,8 @@ static bool vswap_alloc(struct folio *folio)
 		if (ci && cluster_is_usable(ci, order)) {
 			if (cluster_is_empty(ci))
 				offset = cluster_offset(vswap_si, ci);
-			alloc_swap_scan_cluster(vswap_si, ci, folio, offset);
+			alloc_swap_scan_cluster(vswap_si, ci, folio, offset,
+						NULL);
 		} else if (ci) {
 			swap_cluster_unlock(ci);
 		}
@@ -2843,7 +2887,8 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	if (pcp_si == si && pcp_offset) {
 		ci = swap_cluster_lock(si, pcp_offset);
 		if (cluster_is_usable(ci, 0))
-			offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
+			offset = alloc_swap_scan_cluster(si, ci, NULL,
+							 pcp_offset, NULL);
 		else
 			swap_cluster_unlock(ci);
 	}
-- 
2.53.0-Meta


