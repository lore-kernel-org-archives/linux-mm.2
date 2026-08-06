Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0477CC5AC7C
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 18:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619DB6B009B; Thu,  6 Aug 2026 14:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A2F66B009E; Thu,  6 Aug 2026 14:43:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5566B00A0; Thu,  6 Aug 2026 14:43:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10B7A6B009B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:43:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97C691401B3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:12 +0000 (UTC)
X-FDA: 85071717024.27.95DE33A
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id D111BA000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:43:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=el0dsQuo;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786041790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/z0Ae7xOJ//F3kxqKAMic+EYDc2ZHsdvQ58o+7Z+X/w=;
	b=HeYTpgLQP2bCaBcHcj0qW6ttTaL9ddvWFIg2EoBqVTECHHajpf3JG07ZXvPvumOWheiOtD
	eqpd1Foh4U9OU4GrB4qsWaupHd+9cAZj0OP8GA2ai4nWCYh2yeM6FTX3EFnH4eC9rMP4lH
	lbMW7FnWPLBPp5ryOYPy7lSj8CCWuhc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=el0dsQuo;
	spf=pass (imf15.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.210.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786041790;
	b=vHS9dgpPVRq4KbcDrWUOV3XZiVmggeyhrWs6/HOjRN8bjLB5/ieP3QwW3vkpBDu6fpgiAf
	RA4RdD8KoBj5U8y65kypyu//ogXcC6MrD0UZmjIwjHSTmIWU4YyBIOMPMjD/INvoWp1Q5p
	UmCZPieytztgkD5AEpMRKk+oFxDwYyg=
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7eb42a2f5feso1179482a34.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 11:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786041790; x=1786646590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/z0Ae7xOJ//F3kxqKAMic+EYDc2ZHsdvQ58o+7Z+X/w=;
        b=el0dsQuojb8IRSR9kz9ZqEFZ+G9FmgkTCPvBsg6xLAgEuMezEKzblRdf1Fvbr2wODm
         K6QIeKj+vW2aGiZdNWrCMdBIxiXsqvo2IWuuVPXUNn17cI/Bn2+jhmlQgmC0bqSK9PI3
         F2AaRCLhAk7PCWSFzWWlOaX4ZLTDVpPFSWEJNf3VfmhXL2MDu1qdBHaIDPVqhRz4F40W
         vMQqPQ5LkQxaBO08J9olFxbZyeefAGrKnSV+/zlxFHSo4+uJOuLJgtZluBm6Aj5khpv5
         uImGNdJCzIDFYqD9Dy7ixdI5BUeoSfAcM2a71QEJRtXIcGqH/de5ek9fHRzv3drV2rOK
         BS7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786041790; x=1786646590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/z0Ae7xOJ//F3kxqKAMic+EYDc2ZHsdvQ58o+7Z+X/w=;
        b=YBIsg7IXUZ8DLXSj8Hk/ga4GIG9ZUA0ljIiFNePuJ8oXDwmmAmZdSdpc+WMTE4NECF
         Wrkr0S5m/t/fH19dW/g+UEK0aHRFfSnaX5QTYraIRX1RnWfUzlgVg5RMOH36Z0iCWkvt
         mTSdYijAlCEY/mlNJu0id7TY1bCO45FQPZA2KM1V5mxdhwPxX5IW0Q6GyI6DiRZZZ9Xj
         my6ePjpE9f9S1PfOchZyNF3BiMkxVTd8lvlxfX/67t9ydH06flrjOnPyFdzMweO5zne8
         guRW0AiBQhSm7AfSm1IiHdjxPzoptR42CyYXVzCNSecD6U6rUUW+4JHbiwiyeCpiT6F6
         1OsA==
X-Forwarded-Encrypted: i=1; AHgh+RrmQJFzh6jl4pJN1s1APuQ+QM8c8C34QgD2LnmvdmfQRT+kWbOa0E8JHCEl79XpgkeEhUEKraw8FQ==@kvack.org
X-Gm-Message-State: AOJu0YxoOcDhN6X2tZWWTYBRTcFXFUH4gcep58ysXyi5NXnuW4FdoOKH
	9uJSRhfnYI2Y0VBfVkpqW58aAXuKSDsLb/JmKdAwm1/9+ISMl0xIj4pq
X-Gm-Gg: AR+sD10qcerdRPzmnt5JdShx7mHukNzn2uHUnPuhe8FQFjALHPxBd4to2sjcNWkhL10
	XCDE4s8byfjQF/0H3aT/E7xWp3ZcfXiAakmpHB7F9aB0yqbca5ajYgmJE/tGVuV709O5bFRFqzg
	wtmHPjDr8A6PlR4q+Qm0RYlzanlxuHGIlEyJK4XZ7m11N6/6lwzoOhswlYDlNs7BsNwjUglc4+P
	x2iiUn5ZD1iithqyzUgGET1SfQrG9e6G7q8ErLLDKFvND3Ae11xIJl2d6ViT4AEkxlgGkGZgtv+
	5HV1Wc3cTeU47Wic4+nV3nhR3dcCiwMG9UIpj0UeVUxqsAbm+6kNuzEFEveoOiragrYNLOHNeiq
	bvrQWdHJU/0oOVvv9LLy1PSfEHo64t4kFAsdjc+JZbXXZXTPI3rjYY7uYcuPyPHrkLpatZlUltg
	Vjz1fx9TYnjBKyOFQIHYuvi63QrxYAu0xGlySOQgxHOeYgVZ3u3du8LMZ9bkzt6Kn3QmJk+pTs5
	6FGFS4PBXI=
X-Received: by 2002:a05:6830:828e:b0:7dc:c4ae:a689 with SMTP id 46e09a7af769-7f1e5c13d47mr11440177a34.2.1786041785156;
        Thu, 06 Aug 2026 11:43:05 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:59::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df5deeeasm5000722a34.26.2026.08.06.11.43.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 11:43:04 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical swap
Date: Thu,  6 Aug 2026 11:42:49 -0700
Message-ID: <20260806184254.3790858-7-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
References: <20260806184254.3790858-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D111BA000E
X-Stat-Signature: 6ozkemsqjd8zst3zj94ejrm5mj4sxsa7
X-HE-Tag: 1786041790-991763
X-HE-Meta: U2FsdGVkX1/zrsB9s1R3Zf5Df+GwRNjRtuMQ6Igp1zMx3yHNHN/yETlV3r3rZ5dKIwKWike2wUsVDggCUKCT1G0oG1GVCnKhp3TuVGw4dYr5mYsd5NWVDcJF+PnalZAY02Xn8FeMOPYvI74v9fBF/xbKN4lcUxoVi7U4kCYOSSft+mOBKzxgWvn6uoMXoVjDeQ7ZzDUumnltHjxJk8DCibQLuU2kTl8iy/ibEQyH752t7PrzNFiTyUolYjHcHG+qu/WPQTdjGM3hrkktN6GMEwn+uOIktjfFmt7lUH8EpCiJH51jjdX2ANGbw3aV50FXWVykqgH+EYjmkrxi/LPA775hy8nzk35YbSwld815tN0tCnRQJxRljIxA1sEes47JJyd68FJjKw33cQT3dWW1BcSOTfy3LWcJyLtX10FGa2MNSVcBRiQ9LqHPurQRaFGBew6tUPLM9zgrGEQQsMzpzudJi5zUL9+MMkVenxoXpl6DH5useTSZNox+ucSqnvZBA3VnW18yi/GfBMXky3o37KOJ8Zp8ivphBc5PYwnpvVUhWNkLFZSDPV8NWopmOMXLtFOO8GrEwWqCBZUrR0VNHj/KtJ7x0xqkdyqAKML4PXPQjdkW3Mvq17BinnxxSMERpytp75M/ugdA9xkoIEtUfd5doZeNWuvU5wAvR1Wnnj+qNpwwCdHn93LDo0y/Cg/+07kG7VEqbrfsD42g8pZmllSx8szaG0NYfhy/rxSLM4qwAW6kCJRSz6xIacUqv2ogG9p5ur/cW+7wCqDBVSbQ/oABjLjS8xe0v4k3o9veoVS3nTEU8qOv4cW3Fb3Xugr8gNux2UQqiyCTI1XApmXl/b+jb0vFtkYIUhNnsP14CzzaEJ4jLJjy7Vt5lgXfm6B65ho3MvhneQP4Q7lLpoSmqJo/6js2VILBkWuB6HdQRJ7iq+e/rCvyqylwaacw1md20Yc41Vie+HngtBIxvIz
 Wh/QAyjz
 m6HDHTi81dpTPuNtRS5IQNRvSuB6SJfYJFOICXuWYeSmc0UUg6rookiU/KuetUj2G6dhdPxUlCZLNEcdnCJ5o8mieLhytOepd2UaqYwYPLbfxNJUAXlACJCrA6tfCull0EnpklpZ0Q4pIMfzxMrlKLFLBZ4JehchkftVPFwiWcY2F6DMMMPhjLDFi28L7NdXc+vZD62W0J42UyKmUkXnfbZvolRZ2cjjBSWAL9LXKgW9XJEhHnZ9ZTum2LMWxdJobVYwZlD9IuPEyH5OZyov3UGE85C85nlpJtQcQTXc6+PsJLHaPKqUR+2O6pvzbdgqBLKS7EDfs/AICtuqkqC1j4btYqfd6rWFd/0TgoMNbk/Rd4O4Dg1tMClEWwVh38f77L1jwjHYPTb09MGsEmdOfhZSVGEZvLjHEiwDPXBEl09mdTPUypXLFgO+u05p4RY0qAw/F87WRtFq1cz7teSW8X9A/Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for writing back zswap-backed vswap entries to physical
swap. The mechanism mirrors the existing zswap writeback path, except
the backing physical slot is allocated on demand at writeback time
rather than already being pinned by the PTE.

Now that vswap entries can be written back, relax the zswap shrinker
gate: replace the blanket "skip while vswap is enabled" check with
can_zswap_writeback(), which only skips when no physical slot is free to
allocate on demand. This keeps the shrinker off futile writeback when no
physical swap is available while letting it drain vswap entries
otherwise.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 76 +++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 55 insertions(+), 21 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 5dc338188a29..128309d5063b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1007,12 +1007,12 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
 static int zswap_writeback_entry(struct zswap_entry *entry,
 				 swp_entry_t swpentry)
 {
-	struct xarray *tree;
 	pgoff_t offset = swp_offset(swpentry);
 	struct folio *folio;
 	struct mempolicy *mpol;
 	struct swap_info_struct *si;
 	struct swap_io_ctx ctx = {};
+	swp_entry_t phys = {};
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1020,12 +1020,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (!si)
 		return -EEXIST;
 
-	/* Vswap entries have no physical backing to write to. */
-	if (swap_is_vswap(si)) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
 	mpol = get_task_policy(current);
 	folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 				       NO_INTERLEAVE_INDEX);
@@ -1044,41 +1038,71 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/*
 	 * folio is locked, and the swapcache is now secured against
 	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
-	 * Verify that the swap entry hasn't been invalidated and recycled
-	 * behind our backs, to avoid overwriting a new swap folio with
-	 * old compressed data. Only when this is successful can the entry
-	 * be dereferenced.
+	 * swapoff so we can safely dereference the zswap tree (or vswap
+	 * vtable) here. Verify that the swap entry hasn't been
+	 * invalidated and recycled behind our backs, to avoid overwriting
+	 * a new swap folio with old compressed data. Only when this is
+	 * successful can the entry be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	if (swap_is_vswap(si)) {
+		/*
+		 * Allocate physical backing before decompress so a failure
+		 * wastes no work. folio_realloc_swap retags the vtable to
+		 * PHYS, leaving the entry pointer held only by the caller.
+		 */
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
+		/*
+		 * For vswap: folio_realloc_swap already moved the entry
+		 * out of the vtable. Restore it via vswap_zswap_store so
+		 * the entry stays tracked (and the just-allocated PHYS
+		 * slot is freed). For non-vswap: entry is still in the
+		 * zswap tree.
+		 */
+		if (swap_is_vswap(si) && phys.val)
+			vswap_zswap_store(swpentry, entry);
 		goto out;
 	}
 
-	xa_erase(tree, offset);
+	if (!swap_is_vswap(si))
+		xa_erase(swap_zswap_tree(swpentry), offset);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
 		count_objcg_events(entry->objcg, ZSWPWB, 1);
 
-	zswap_entry_free(entry);
-
 	/* folio is up to date */
 	folio_mark_uptodate(folio);
 
 	/* move it to the tail of the inactive list after end_writeback */
 	folio_set_reclaim(folio);
 
-	/* start writeback */
-	__swap_writepage(&ctx, folio, folio->swap);
+	/*
+	 * Start writeback. The entry has been moved out of its prior location
+	 * (vtable PHYS for vswap, removed from the tree otherwise), so we own
+	 * the free. vswap writes to the on-demand physical slot; others write
+	 * to the folio's own entry.
+	 */
+	if (swap_is_vswap(si))
+		__swap_writepage(&ctx, folio, phys);
+	else
+		__swap_writepage(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
+	zswap_entry_free(entry);
+
 out:
 	if (ret) {
 		swap_cache_del_folio(folio);
@@ -1091,6 +1115,16 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * vswap zswap entries need a physical slot allocated on demand (via
+ * folio_realloc_swap) for writeback; if none is free, writeback fails, so
+ * skip the shrinker to avoid spinning on entries we cannot drain.
+ */
+static bool can_zswap_writeback(void)
+{
+	return !vswap_is_enabled() || get_nr_swap_pages();
+}
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1228,7 +1262,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (vswap_is_enabled())
+	if (!can_zswap_writeback())
 		return 0;
 
 	/*
@@ -1313,7 +1347,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (vswap_is_enabled())
+	if (!can_zswap_writeback())
 		return -ENOENT;
 
 	/*
-- 
2.53.0-Meta


