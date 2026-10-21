Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA38160A4AE2
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=tMxWkwOy
Received: by kanga.kvack.org (Postfix)
	id 3A8D06B0608; Wed, 21 Oct 2026 02:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312EF6B060A; Wed, 21 Oct 2026 02:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 228DB6B060B; Wed, 21 Oct 2026 02:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E856C6B0608
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:03:48 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 796361A041D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:48 +0000 (UTC)
X-FDA: 85345592136.28.9037231
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf16.hostedemail.com (Postfix) with ESMTP id A08FE180003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:03:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tMxWkwOy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792562626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXV3pXzpnzs8U7BbqpWsaUJNBuB8eNBkejRWaj9fiJ0=;
	b=Y25mcl+T8I2vJTy816j9lOghIhiKyWOMdPGLqdZ8SwBUiKsCOGrxaz6QZNNjJRgJ6hBvaW
	mqMGwGN/0BfAG29s2RNqudn1gotML96XZV9PMc/TLty9TbXAPH8FX5ds8KG9KGTqkfZyfm
	2LfyU+yMw5xopfSoBOK03CJqf/OhrrE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tMxWkwOy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792562626;
	b=jJHEek1vUj0UYD69IzUD5nEDfBNOWbMcOweoq2cemlGRSrvsXxX56wKqNQT4SMOTCbOXTq
	PdFuVvWcRrv5kgKBf10OxESOt2H4Md21Y/TlFuu2f6/WeUfO7s8dl3Cy0qUILOqpoVFM2i
	PRThUC+in9RohCiSJAyCEQpc/5d1j7E=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-8ab38a051aaso2816487b3.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 23:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792562626; x=1793167426; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hXV3pXzpnzs8U7BbqpWsaUJNBuB8eNBkejRWaj9fiJ0=;
        b=tMxWkwOya1NB9XeUpBCy6hjRBnWfuSgNWTTGMAgafpKRph+IPiax+zotiCpzzLvJdd
         Q5cgo/NNQU2rgSvpKxkfkfal6GR2HccLoubSXCN7F/ptCvOMiHKiwPdd/ABuRIzsITGR
         sfOLiwEnaYECkJbteHpquMuEe6K+TnawdlpMgGYI+uwFGOEy2IkksD5YWhRiDs44ZQxx
         xoGm4wd95dV5MGKW3x9u1Vzwj9SJVSHhdtarUa64l4/addT8UTvM5c02nJplcVsCTXiR
         KloN3wpshcgHudOv9sPs5alY7huHwz15jO02poUv2eKJ6dELpcRehlKO0cIoZDsa2qKn
         qo7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792562626; x=1793167426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hXV3pXzpnzs8U7BbqpWsaUJNBuB8eNBkejRWaj9fiJ0=;
        b=mxsvesNWE9EgAOC1ta/2MTgnx6Ddqx+X87OUIX+1nGaYSyUgpl0nQ7Yq2PXXlz4liH
         IQrRrl5UDLpo806+9VPCXcOClsFx7VIh8CEtIvyghxz8RW6D4eJHnunHBtIQMT9s6EGm
         wh63Cx8FSNuAMvRoVH668WkXJMPHcCwWSPa9ioNKjzSKpER+v+tNgZAAS3X4gELNOKxp
         PXpTDhAOCKRFKri/JoUclRopHyu098LYZ1132HDaoAVmwiK2rDnG8mwTcFDBScns7iLh
         m9BbdJU51S33zSycwn1fKSAQXi/VxYyGkZMCqVqnJFblKvy2b/V+bVrWgPHXJBs5LNfV
         jq/Q==
X-Forwarded-Encrypted: i=1; AKwUvBxQySciQ+ZcwqAyNAckhQo4gq9+fkSbFQb0V8O6ZtS8CKUVVw40XlmhymVh5dN8izYU9BjJImoTqQ==@kvack.org
X-Gm-Message-State: AFq9FYL5SJHxC0WcsQtycbAGILm3LQdC99AOqGmQTqvFP7A9oPhezZ/s
	QW/ixGaGK/qoWAL5LWF2HR+zOcM4VucCYOJToy/cpE3JBcJfmFM/gOsP
X-Gm-Gg: AYBFou2BpplBJCSjG2cEh1H4cyuwWbmokBVIt+qxCNFnQuA1OqfRwvp0N7VihHM7Uql
	kNjmBdJo34RN4p5LpklmaZPsqq06jBcVSTA/pzmgJKARI8VqtzL5OM4Q+RKnVdYohKibUDWafsM
	6aXWbWP3W5V8qR+0cCDCYj4EXIk9U89uTzjlmlkam2Al+sUg/yKxmeZ2lf2jChFeO6RxMQLkzdr
	FGOVwFMt6dehhdd3ew/LjdwlUvXfjlncjrcOZi1TKjcJ7IiYW9PSj4e/1QFZRwoASPPsVmd/ZYF
	Vht/m7ZSj1KhEBWzxSiic/Kf+Gj5pMdMcHJcbSifO9Wc68IolAiPAMBAp7MNabewWLx7gBtNpP1
	cvWTwbzjYLyNVU0gHspprmrpjJTgLUCv6PrpzI72dny5onaPIhwX7MHUV8FW2Npf2J7bC8yNTqk
	dLPJGqxfYOFUUHPbjJAlMrm3tlWmIoNKNNV7sFQP8skoJynq+lluXsEQF/lkQrNx9sDCCX33Tzh
	pXCor7Y06o7oAHu4A2tENft68DTdS47wq4ES5MV2f66RsukkklAaeN21tJfsQE21UZkWXJmeKSE
	9DyVV8nTt67UyVWNZheHkeRwIuDmf7Dipbsmv5uDmNAsOxETMuXs9ylW8FCh4Pam
X-Received: by 2002:a05:690c:e3eb:b0:8b0:89ea:6aca with SMTP id 00721157ae682-8b133cdd929mr5826817b3.6.1792562625774;
        Tue, 20 Oct 2026 23:03:45 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:50::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1300ae0c2sm7348597b3.18.2026.10.20.23.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:03:44 -0700 (PDT)
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
Subject: [PATCH v6 06/12] mm, swap: write back vswap zswap entries to physical swap
Date: Tue, 20 Oct 2026 23:03:17 -0700
Message-ID: <20261021060323.553433-7-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A08FE180003
X-Stat-Signature: tty4qby7a7mabkz7ft3cc1jh3wdcac5w
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792562626-397179
X-HE-Meta: U2FsdGVkX19LInGCzocN5PWbIfu8ViE2sUR7KBzUiDVi8JdJAREITdCguaK1EK6HRzHbF639v58BNi5QC5yFQrzJf/H9wagDXMCdgVO7CIljiQZ0kpbHSamh2t7i5/twZS/LoZ4h6bVCCYvksH6aiJ0DnxH6bm8rXUmqdHzyhcEtSYC3Ggpg+FIdgWaE8IliCeMZa6sbI9Wpl8c26uP4bAs1lzKPkgN04vvG2mnTNfoRxZYd3+KBz0Rm+rK6+6uTbAE+vZqIPy86v1FYfR3GYuH9svBMH887s/gOtjYMqoASKkqqDVQGSfT2IWvkYUh5u3MB5dE7Rdno/E700mfFaZN1Q1OQObCXwOFSs+0npITwHD+VNij/pwYi+lOR0lUYIUj/Xv9e62CB/mVNbmH05R1j/Olqm/Wnj8mdGLXIpNMcWhN45CwC1LOoWZz4D38gdXpQbi99Zc08i8zeDNSXZP7r9qgmG+wSRJhgDrRmoILl9uLgFgZoy7Ju/RMJ9hBB8BhDpWr5AeZ49YXUpzVv+uw/ycw/ew+Q88mFb0vfJHaIcWxJwSKUoDZbjTBKJCeraeuStlmCxIoWnC3sTWeFtkgUHedbXCHcwjkT0Ypka4S/Vn+ewjsdCx/5Td93jMK48lmjwsbubKwBNCJk6VCCHqpFP3FHR3fxkr9XC9nOFdEMgEoyDf1gTzU+GQTw30N5wJFAJtNGsh7wqyP7odGRGcnAxb0TtOy+m/aj0iTrkdVG8EkOtnFv0xy6ZUsKkAG9AhJYl/R0mOv2sc/LJx+DAgfHLMmgcOy3ZU8hBnHZRlLDMi3lZn9mkSaLMc80QGTrJUfLNk+Elu9UCZ3UlYreyKdQ2qPKvlBD16H9zq2zB24DBiuX3BEualswG3VRTr6KiLQyiB1PW8Cw4S0T4uKgko38Xkxp/Rc70Lu60mb/TXK6z5aMfnPCwevXrNSD6JQwN4Bg1Q+ERbj2vl6RHr6
 2VNa8HkL
 0PXakFxg+I83BcgSfM/bbOf4qkCv48a8QpOdvU+ORxJjbouMt9F5EsrX3wnbOeEAE5vVTrr/wPatX66yJ3U5aih2ch+1BTfO4JgXvaFIms/rv2RBx8I7RLoykqMYMsf6YFrEnFW9DigbvAFDB6T3zk+pmf01tgH/NRjLuh0BiPOYYVhrY/fMjzfxYpd1eOrye6+l17+L2pfcgwoQ41fRE1xq/L2RxWIiSOo5E+/HWPWhq/owLnucja7l1oH75tVP7CJsnplseSTr4D8JXmkvpOh8oLWu6j1emDVi0l8odw2tAemAjCKkpPGR2wyqUbT05CS3RGJcUXpgCCz3u8hYkh+9v8GSBsIsShQdWM+N7YJTfo+sYQ5BwsYolNT6wgfkua5Cm9ywaufQm213nyACsjpqr9qEFuavzIiSq4wdLiMCYqmUx6LcjfFuDWFuSnWz4cc3gQZNLvuxwUbvj2s+tEzPpYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add support for writing back zswap-backed vswap entries to physical
swap. The mechanism mirrors the existing zswap writeback path, except
the backing physical slot is allocated on demand at writeback time
rather than already being pinned by the PTE.

Zswap shrinker only skips vswap entries when we're out of physical swap
space.

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/zswap.c | 69 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 21 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 1b91dba992ab..fd0c2f126b57 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1076,12 +1076,13 @@ static bool zswap_decompress(struct zswap_entry *entry, struct folio *folio)
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
+	bool is_vswap;
 	int ret = 0;
 
 	/* try to allocate swap cache folio */
@@ -1089,12 +1090,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	if (IS_ERR_OR_NULL(si))
 		return -ENOENT;
 
-	/* Vswap entries have no physical backing to write to. */
-	if (swap_is_vswap(si)) {
-		put_swap_device(si);
-		return -EINVAL;
-	}
-
+	is_vswap = swap_is_vswap(si);
 	mpol = get_task_policy(current);
 	folio = __swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
 					 NO_INTERLEAVE_INDEX);
@@ -1115,24 +1111,44 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	/*
 	 * folio is locked, and the swapcache is now secured against
 	 * concurrent swapping to and from the slot, and concurrent
-	 * swapoff so we can safely dereference the zswap tree here.
+	 * swapoff so we can safely dereference the zswap tree (or vswap
+	 * vtable) here.
 	 * Verify that the swap entry hasn't been invalidated and recycled
 	 * behind our backs, to avoid overwriting a new swap folio with
 	 * old compressed data. Only when this is successful can the entry
 	 * be dereferenced.
 	 */
-	tree = swap_zswap_tree(swpentry);
-	if (entry != xa_load(tree, offset)) {
+	if (entry != zswap_entry_load(swpentry)) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
+	if (is_vswap) {
+		/*
+		 * Allocate physical backing before decompress so a failure
+		 * wastes no work.
+		 */
+		phys = folio_realloc_swap(folio);
+		if (!phys.val) {
+			ret = -ENOMEM;
+			goto err;
+		}
+	}
+
 	if (!zswap_decompress(entry, folio)) {
 		ret = -EIO;
+		/*
+		 * The phys allocation above took the entry out of the vtable.
+		 * Restore the zswap entry to the vtable, which also frees the
+		 * allocated physical swap space.
+		 */
+		if (is_vswap)
+			vswap_zswap_store(swpentry, entry);
 		goto err;
 	}
 
-	xa_erase(tree, offset);
+	if (!is_vswap)
+		xa_erase(swap_zswap_tree(swpentry), offset);
 
 	count_vm_event(ZSWPWB);
 	if (entry->objcg)
@@ -1159,7 +1175,10 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_put(folio);
 
 	/* start writeback */
-	__swap_writeout(&ctx, folio, folio->swap);
+	if (is_vswap)
+		__swap_writeout(&ctx, folio, phys);
+	else
+		__swap_writeout(&ctx, folio, folio->swap);
 	swap_write_submit(&ctx);
 
 	return 0;
@@ -1174,6 +1193,17 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 /*********************************
 * shrinker functions
 **********************************/
+/*
+ * With vswap disabled, all zswap entries use directly mapped physical swap
+ * entries. With vswap enabled, such entries are rare.
+ *
+ * A zswap-backed vswap entry needs physical swap capacity for writeback.
+ */
+static bool zswap_writeback_possible(void)
+{
+	return !vswap_is_enabled() || get_nr_swap_pages() > 0;
+}
+
 /*
  * The dynamic shrinker is modulated by the following factors:
  *
@@ -1311,7 +1341,7 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
 	if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
 		return 0;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return 0;
 
 	/*
@@ -1397,7 +1427,8 @@ static struct shrinker *zswap_alloc_shrinker(void)
  * were scanned but none could be written back, or -ENOENT if @memcg has
  * writeback disabled, is a zombie cgroup, or has empty zswap LRUs.
  *
- * Also returns -ENOENT when vswap is enabled.
+ * Also returns -ENOENT when vswap is enabled and there is no physical
+ * swap to write back to.
  */
 static int shrink_memcg(struct mem_cgroup *memcg)
 {
@@ -1406,7 +1437,7 @@ static int shrink_memcg(struct mem_cgroup *memcg)
 	if (!mem_cgroup_zswap_writeback_enabled(memcg))
 		return -ENOENT;
 
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return -ENOENT;
 
 	/*
@@ -1437,11 +1468,7 @@ static void shrink_worker(struct work_struct *w)
 	int ret, failures = 0, attempts = 0;
 	unsigned long thr;
 
-	/*
-	 * When vswap is enabled, zswap entries are almost all vswap backed,
-	 * with no slot to write back to.
-	 */
-	if (vswap_is_enabled())
+	if (!zswap_writeback_possible())
 		return;
 
 	/* Reclaim down to the accept threshold */
@@ -1522,7 +1549,7 @@ static void shrink_worker(struct work_struct *w)
 			break;
 resched:
 		cond_resched();
-	} while (zswap_total_pages() > thr);
+	} while (zswap_total_pages() > thr && zswap_writeback_possible());
 }
 
 /*********************************
-- 
2.53.0-Meta


