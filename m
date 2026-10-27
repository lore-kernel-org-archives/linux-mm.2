Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9BE7606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 09:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86B356B0665; Tue, 27 Oct 2026 05:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8424E6B0667; Tue, 27 Oct 2026 05:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7316F6B0668; Tue, 27 Oct 2026 05:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DA646B0665
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 05:40:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6FA6C0963
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:40:49 +0000 (UTC)
X-FDA: 85367911818.13.9598C8F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id F32F11C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:40:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793094047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4KnuBOFznA/VDWJ5if53/N0G1tiho15zBcRHO3JDxRY=;
	b=S2lr+QzghY01IGiHlPh4OwGIgq36dCQd+Ooiu6YOPtMO0QeUKp7IZ8sf5f4u8HTsziS3j5
	YcLDVf4A4KzPY9e0DXnT2kFXrUsLkt0Qu0+siYg82pEm3vkpuW6s2TrQMxVG30kQsX53L0
	iR4hudk04A8+K83bWUalSEotLOARTG0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of wangxuewen@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=wangxuewen@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793094047;
	b=LMi9xfBayRyfqve7NaBvBgKB5u6G7d9BprP/Rm6vvlKos1n3Sdl7zhFppJgMutBYv/jR19
	KAVgn5bjhqfMF7kDaW4Edj5N0Rv8+gVlwQyDY4nWX8/05+7ioIPM3ioPfbBaC9AUs4WjCp
	ymuCW/nUuo+atB02QjI2WkVCCu2K9y0=
X-UUID: 7622c894d1ea11f19a56ed5b684f684d-20261027
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_UNFAMILIAR, SRC_UNFAMILIAR
	SA_TRUSTED, SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS
	DKIM_NOPASS, DMARC_NOPASS, CIE_BAD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_RG_INFO, GTI_C_BU, AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:b8b19f8b-e63f-405e-8854-954816a2d84b,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.19,REQID:b8b19f8b-e63f-405e-8854-954816a2d84b,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:7db8b62,CLOUDID:d63e7cb1ef2d14fbaf4f4c2e2408e69d,BulkI
	D:261027174039JO0S0EI1,BulkQuantity:0,SF:17|19|38|66|78|81|82|102|127|136|
	850|865|898,TC:nil,Content:0|15|50|99|100|102|155,EDM:-3|-100,IP:-2,URL:0,
	File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:N
	O,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7622c894d1ea11f19a56ed5b684f684d-20261027
X-User: wangxuewen@kylinos.cn
Received: from localhost.localdomain [(223.104.42.231)] by mailgw.kylinos.cn
	(envelope-from <wangxuewen@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 265772172; Tue, 27 Oct 2026 17:40:35 +0800
From: Xuewen Wang <wangxuewen@kylinos.cn>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Xuewen Wang <wangxuewen@kylinos.cn>
Subject: [PATCH 2/2] mm/shmem: trace folio allocation failures and fallbacks
Date: Tue, 27 Oct 2026 17:40:14 +0800
Message-Id: <20261027094014.2432692-3-wangxuewen@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
References: <20261027094014.2432692-1-wangxuewen@kylinos.cn>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F32F11C0004
X-Rspam-User: 
X-Stat-Signature: 1jtfpk6ns74whs79qs6zwj3cm5ior3ss
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793094045-376654
X-HE-Meta: U2FsdGVkX19b70mYoG2YmTfscQRChPbmVb21mvjKEyb0lyuXNoWRLqxcGJnTdwEfZ1EBjLmNOBj41Fpq8wjcLyKqMt7u3mqop/YEbaQwq8W+9utj5w9OJX6OZYalOST3VKkl72Gtz53r/o3A7l1ApVcDBMWRxbiOnPqDTEM47TMyq+9PjaMDwoBTey3SJfbzRcp2o8IuP6k33aSpX4WEPNFwgRu3CDnns1RwpltQ7zchWM12V5tYe3zQfvPZutIoOH2RrvQQD0+e/xLC2UiIRgONxwY4gOCU7PEnOu4tdbu2Ov/H1+lIXE4Q2gNWnP0rynfZXFkcLuqvsvY5p16N4Wescyax1glLdAZ0mVg0CAmsaXzSjiHmcOP5IQRQYnW+z5yEyarCrZOaHM9qcwGJ8qRvEuNwqwvrO5lwqjdtBVvux2kLe6LaSZPwdWLJLLmfrugWeccXaU4PExMSkHXiPg00suXFzC80/KctQ8HfaX6CrkgVMSOgFQEw+/6/CYyV2fslv5LHj8VP2BKPAw6xw0Z8XTZV3gRZHLcqIgnRkXNYIb/0ici/lQAgfuJgUyL3/ANsOQWy1LMv2ASGsGX8i9CCjSQW0q+AYDi8YnoL/ZN/XmlpiXGlFvrTextoj2J9p8RjqamI0maQi5pnP9ExdzoWqOoEAYMbD3A9F0ajkeovMcHfYc5nnMmK9qZP9AMyTQH9nIm+SsMQU99pbF3q4bJuiHLRWslqwxyY8x3DNmL9+5kb9a2Ajn7OK7Bwz+q658ZXcIyfE7hEt5pYPG5afEmsaYTVLTvy81e/CKWp73XBFYxkz470DnovkZFt26oLSrBN+3+FG/ywQvk+amJtooz+XaXbli4nPC4T1dwFIIB5+v1gDAqazKyGN7VppxhMJti42y+y+ZbyrDNih8fhMj7DGhWTwYrANuDlakdUzYSVP//YfVPt39P/KzWyyVCqYNr2SguoIfReedLhgsL
 tXLPgXva
 KOjqm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The shmem allocation counters cannot identify which tmpfs file is
affected by allocation fallback. They also do not describe order
filtering caused by VMA constraints or existing page-cache entries.

Trace failed calls to shmem_alloc_and_add_folio() and successful calls
that allocate below the highest order permitted by the supplied mask.
Record the original index and the highest permitted, highest suitable
and allocated orders to distinguish filtering from allocator fallback.
A suitable order of -1 identifies an empty filtered mask, where no folio
allocation is attempted; such records use a separate filter stage and keep
the stage error at zero while preserving the helper return value. Omit
successes at the requested order, including ordinary base-page allocations.

Identify failures by stage: allocation, memcg charging, cache insertion
or filesystem accounting. Preserve both the stage's errno and the
returned errno. In particular, a charge failure remains visible even
when a page-cache conflict makes the function return -EEXIST instead.
Stage and errno distinguish this case from a direct insertion race.

Document that each event describes one call to the helper, which may try
multiple candidate orders. The caller may subsequently retry at order 0
or restart a lookup, so an error in this event is not necessarily a failed
user operation. A successful order-0 retry is omitted as a success at that
call's requested order.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
---
 Documentation/trace/events-shmem.rst | 45 +++++++++++++++++++++++
 include/trace/events/shmem.h         | 55 ++++++++++++++++++++++++++++
 mm/shmem.c                           | 34 ++++++++++++++++-
 3 files changed, 133 insertions(+), 1 deletion(-)

diff --git a/Documentation/trace/events-shmem.rst b/Documentation/trace/events-shmem.rst
index 45da82761360..4a0e50bdbdf3 100644
--- a/Documentation/trace/events-shmem.rst
+++ b/Documentation/trace/events-shmem.rst
@@ -71,3 +71,48 @@ Filter or aggregate by both ``dev`` and ``ino``; inode numbers alone are
 not unique across mounts. Trace filters use the numeric values shown by
 the event's ``format`` file. Check ``per_cpu/cpu*/stats`` for dropped events
 before interpreting counts.
+
+Allocation attempts
+-------------------
+
+``shmem_alloc_folio_finish`` records failed calls to
+``shmem_alloc_and_add_folio()`` and successful calls that allocate below
+their requested order. Successes at the requested order are omitted,
+including ordinary order-0 allocations.
+
+This is an attempt result, not the final result of a read, write or fault.
+After a higher-order failure the caller may retry at order 0, or restart
+its lookup on ``-EEXIST``. A successful order-0 retry is not recorded.
+Do not count all nonzero returns as failed user operations.
+
+``requested_order`` is the highest order allowed by this call's order mask,
+or 0 for a base-page request. ``suitable_order`` is the highest remaining
+order after VMA and page-cache filtering, or -1 if none remains.
+``actual_order`` is the allocated folio's order, or -1 if allocation did
+not produce a folio. Orders refer to base pages, not bytes.
+
+``stage`` identifies where the attempt ended:
+
+* ``filter``: filtering removed every candidate order, so no folio
+  allocation was attempted. ``suitable_order=-1`` identifies this case.
+* ``alloc``: a suitable order existed, but every allocation failed.
+* ``charge``: memcg charging failed.
+* ``cache``: page-cache insertion failed.
+* ``account``: filesystem block accounting failed after its retry.
+* ``done``: allocation succeeded at a smaller order.
+
+``error`` is the error at that stage; ``ret`` is the error returned to the
+caller. ``stage=filter`` has ``error=0`` because no allocator call occurred,
+while ``ret=-ENOMEM`` preserves the helper's return value. Both are zero for
+``done``. For a charge failure followed by a page-cache conflict, ``error``
+retains the charge error (such as ``-ENOMEM``), while ``ret=-EEXIST``
+requests a lookup retry. A direct insertion race instead has
+``stage=cache error=-EEXIST ret=-EEXIST``. Accounting errors retain
+``-ENOSPC`` or ``-EDQUOT`` as appropriate.
+
+Enable ``events/shmem/shmem_alloc_folio_finish/enable`` in the trace
+instance to collect these records. On successful fallbacks,
+``suitable_order < requested_order`` shows filtering, and
+``actual_order < suitable_order`` shows allocator fallback. Both may
+occur in one attempt. The existing shmem allocation and fallback
+counters remain useful for aggregate statistics.
diff --git a/include/trace/events/shmem.h b/include/trace/events/shmem.h
index 7a0050a1686f..72b20d6b3caf 100644
--- a/include/trace/events/shmem.h
+++ b/include/trace/events/shmem.h
@@ -80,6 +80,61 @@ TRACE_EVENT(shmem_swapin_folio,
 		  __entry->fallback_error, __entry->error)
 );
 
+#define SHMEM_ALLOC_ALLOC	0
+#define SHMEM_ALLOC_CHARGE	1
+#define SHMEM_ALLOC_CACHE		2
+#define SHMEM_ALLOC_ACCOUNT	3
+#define SHMEM_ALLOC_DONE		4
+#define SHMEM_ALLOC_FILTER	5
+
+TRACE_EVENT(shmem_alloc_folio_finish,
+
+	TP_PROTO(struct inode *inode, pgoff_t index,
+		 int requested_order, int suitable_order, int actual_order,
+		 unsigned int stage, int error, int ret),
+
+	TP_ARGS(inode, index, requested_order, suitable_order, actual_order,
+		stage, error, ret),
+
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long, ino)
+		__field(unsigned long, index)
+		__field(int, requested_order)
+		__field(int, suitable_order)
+		__field(int, actual_order)
+		__field(unsigned int, stage)
+		__field(int, error)
+		__field(int, ret)
+	),
+
+	TP_fast_assign(
+		__entry->dev = inode->i_sb->s_dev;
+		__entry->ino = inode->i_ino;
+		__entry->index = index;
+		__entry->requested_order = requested_order;
+		__entry->suitable_order = suitable_order;
+		__entry->actual_order = actual_order;
+		__entry->stage = stage;
+		__entry->error = error;
+		__entry->ret = ret;
+	),
+
+	TP_printk("dev=%d:%d ino=%lu index=%lu requested_order=%d suitable_order=%d actual_order=%d stage=%s error=%d ret=%d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino, __entry->index,
+		  __entry->requested_order, __entry->suitable_order,
+		  __entry->actual_order,
+		  __print_symbolic(__entry->stage,
+				   { SHMEM_ALLOC_ALLOC, "alloc" },
+				   { SHMEM_ALLOC_CHARGE, "charge" },
+				   { SHMEM_ALLOC_CACHE, "cache" },
+				   { SHMEM_ALLOC_ACCOUNT, "account" },
+				   { SHMEM_ALLOC_DONE, "done" },
+				   { SHMEM_ALLOC_FILTER, "filter" }),
+		  __entry->error, __entry->ret)
+);
+
 #endif /* _TRACE_SHMEM_H */
 
 /* This part must be outside protection */
diff --git a/mm/shmem.c b/mm/shmem.c
index 3b910aec5bcf..68321d61dfdb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2155,17 +2155,23 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
 	pgoff_t aligned_index;
+	pgoff_t orig_index = index;
 	long pages;
 	int error, order;
+	int requested_order, suitable_order;
+	int charge_error = 0;
+	unsigned int stage;
 
 	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
 		orders = 0;
 
+	requested_order = orders ? highest_order(orders) : 0;
 	if (orders > 0) {
 		suitable_orders = shmem_suitable_orders(inode, vmf,
 							mapping, index, orders);
 
 		order = highest_order(suitable_orders);
+		suitable_order = order;
 		while (suitable_orders) {
 			pages = 1UL << order;
 			aligned_index = round_down(index, pages);
@@ -2181,19 +2187,35 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 			order = next_order(&suitable_orders, order);
 		}
 	} else {
+		suitable_order = 0;
 		pages = 1;
 		folio = shmem_alloc_folio(gfp, 0, info, index);
 	}
-	if (!folio)
+	if (!folio) {
+		if (suitable_order < 0)
+			trace_shmem_alloc_folio_finish(inode, orig_index,
+						       requested_order,
+						       suitable_order, -1,
+						       SHMEM_ALLOC_FILTER, 0,
+						       -ENOMEM);
+		else
+			trace_shmem_alloc_folio_finish(inode, orig_index,
+						       requested_order,
+						       suitable_order, -1,
+						       SHMEM_ALLOC_ALLOC, -ENOMEM,
+						       -ENOMEM);
 		return ERR_PTR(-ENOMEM);
+	}
 
 allocated:
 	__folio_set_locked(folio);
 	__folio_set_swapbacked(folio);
 
 	gfp &= GFP_RECLAIM_MASK;
+	stage = SHMEM_ALLOC_CHARGE;
 	error = mem_cgroup_charge(folio, fault_mm, gfp);
 	if (error) {
+		charge_error = error;
 		if (xa_find(&mapping->i_pages, &index,
 				index + pages - 1, XA_PRESENT)) {
 			error = -EEXIST;
@@ -2208,10 +2230,12 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 		goto unlock;
 	}
 
+	stage = SHMEM_ALLOC_CACHE;
 	error = shmem_add_to_page_cache(folio, mapping, index, NULL, gfp);
 	if (error)
 		goto unlock;
 
+	stage = SHMEM_ALLOC_ACCOUNT;
 	error = shmem_inode_acct_blocks(inode, pages);
 	if (error) {
 		struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
@@ -2242,9 +2266,17 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 
 	shmem_recalc_inode(inode, pages, 0);
 	folio_add_lru(folio);
+	if (folio_order(folio) < requested_order)
+		trace_shmem_alloc_folio_finish(inode, orig_index,
+					       requested_order, suitable_order,
+					       folio_order(folio),
+					       SHMEM_ALLOC_DONE, 0, 0);
 	return folio;
 
 unlock:
+	trace_shmem_alloc_folio_finish(inode, orig_index, requested_order,
+				       suitable_order, folio_order(folio), stage,
+				       charge_error ?: error, error);
 	folio_unlock(folio);
 	folio_put(folio);
 	return ERR_PTR(error);
-- 
2.25.1


