Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E92F327A8
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B066B0093; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11976B0096; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B65526B0093; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8667D6B0092
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:16:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 94167140C98
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:57 +0000 (UTC)
X-FDA: 84681554874.26.0E516E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A824520004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgvFXYTH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752215;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbJUJM58LealXyumhOaaFkF87TSRDtnH9RRmJkUR+WE=;
	b=vbJQl/lAq+1HbhIrvcc344RxWntdWWlEYBhEhZiCxrrPAiSXkcp4UwFCPQHCm7qs8cjvRb
	fxvIUmbPIhbJS+NHWIV20RV02YKyrgHRFwPL+ddjJxwaxMIIWljC6zJD73XSLnda0c6oJ0
	L0jYII9lRn9EZE9GYX3r+TwQTqGSt94=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YgvFXYTH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752215; a=rsa-sha256;
	cv=none;
	b=vltMdcO55sQxwPsZQL7NYYLBkDGfdg/2j+M5HLGgIWerDMlsO94kHpnHtIfBVdSjH0wuP4
	aud+XkxtxTFyYSZ6MN/ESD6K48lLqUY+JwezSDUQ0pCzuQZqynq9rF7NyNYZZySx/QINBH
	/kXJc+ceIKeHAMzmVi0f0kRLYATIlB0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C7BBA60142;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42154C2BCB9;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=ZO7LAiTquAEn3PGOA6qwxWEsw7ehhO84HiuDyH/h6ws=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=YgvFXYTHR0DmaIn1RCcAqriG6JhCY8v93lg1qqf2fsD6b49nk/I+XxeYU6aWeQUJ9
	 j9T9ZSSEH5E82543hoBP4i6mjnOmAoXqOoGJlRyT69mgChJURTX3inTpDmg3yB7dyq
	 Bl6kiHRVPPDNnv6m7phAqFevYR3m1Gaa3bNfF+TanzDLbjxkwvOOPK2rYXy3BPZpLk
	 Ox7LcsUvdBT+s7AUQOLeH3RQE327LWQyaLpMXhvd01e8uaC7Vgk93TKUz9wpRUWfGj
	 oyTzu4zBGmF/8fjmebDnWrG6HigKVcvQoYM2a67hqyRyd1DXS5//VPt93oiRU5HZ3z
	 A9Ru4+Qk8LueQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C39F327AC;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 21 Apr 2026 14:16:47 +0800
Subject: [PATCH v3 03/12] mm/huge_memory: move THP gfp limit helper into
 header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=4275;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IPzlyWDmmaeqDTMXHOEyi5jkn4VAxM+lz6yxuKwuVaw=;
 b=GZODeebR8D2/w7Dpfs2u+q8o22LymrwzjCZfIIe3QGXCKa19ZCLUURjYJpT9gzSAORXEgXcbn
 dnQ5vrpwaBoCax1TgRPyFE8UqBydLM8bA+RWN8n8Pj7Q94reooD9YFT
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A824520004
X-Stat-Signature: qbohziqoz848hyex3xdkh6s3dw3gcdwf
X-Rspam-User: 
X-HE-Tag: 1776752215-304222
X-HE-Meta: U2FsdGVkX191vuJeLIYMslDRKg6das/yYAs7QTbsFTha+EiJ8zPSTsi68G0Q0ZVCX1Bo5ivjHf9kMELeBOBTko6/x8xXdJyk+/9rMmBltW3clYXUqDtQWjpBh4LGpRIMKgt1ITtbYicVDu7yV+aqAKjClc0aurU1kYRUkZdLySEIwgxewPwPy9HuZffaeAUQC1FXX9WZAsUCs8L63aMv0xDIjV7F9uAnmLQnxzWW4emB9i9aA6DXyvTDkA1bc2uZqvzetdKO+iaO2tdVghcwtYdMFPfBSvq4Hb++gQ8vJKbBt4JusIz0J7H9KgUv2iFWKODSq4VJSDJTYrHwZ9cu2lE85aTfYMSeBbdCkfI2sAxy9ODtFcPNKaWirVYkk7m8F/oyBDpexwU7BU0Hu3su/2xHisUMv5w/mDQkPoHO/3PF5k/n33L8nVEKWaPoJXrxKOSfJiEY4PtA0hENawLYdM8PooT3eGt/sef0Li9B7BCyNA5iPDzemei+V+3NVkBUzciZh4/7UMOEoQv34gBhu3wxLKOS0mUa/ZcRPPZrqhzOPEze0Cu4IThcJ9kV+62TbCalge2KzGyy5PSg0bkEgbsHyFqZsD1IBkXIkkW8mvcYWZFtO0Bh3oRNPiH3Vr83MZDKil34/3jJ5Ob//XsugHPpI76XPi4b4aZvbhwkaunVikS3wCooFXgbEZHaWfn04nlOHJuI5fkuoi0vfAZUVsrFzJwf0IZsEfS54ZsQpR+twMAxs4j+flcB3OLyfE1oT2GrrEx84saTQm9vkxyu7qdnx4XaljC2Gr06uBxVNmt093tzNsmMtmc2YjVbOzIaVnGzkZcCtt+1ZG3tm4TkzMc4cWTqql1JFmZGhlLPk4CgiWHKqXT4Ge/BI6bhE3SS8vqx3GD31wMmzlED5v8dy5J3AatR08/xuT2FA9RAW6LFHCDcInwS+dqXai81hCGO5C77JCfQsiFBvjtSb1B
 LFxYpJ38
 22S6/+EhANp1nBKF0OgkK57R4Ud6eetbmFI0sHaR2L7TgCnT0ttVBtxmWcCjlkifumBsN6ryL2uV6GwJ/Wzd+79BXLKrMFuCS4zcgjboLXTYAeytOpwDDq675YhEDuChk2YBvKlNf5VmsOOwV3LTgJKTSysxfOuOHO7NBnEG3vIQumiVMDK8hUXzyITTYpudq0UvK/2T1OZ+nqLTjEHJfr8kyjVpmaalBofINvEj3OWp4CxYxCTJ9YVGJ2GNX/DG8ksubeiURphY0e+0gZxofqY9WcB3tt+YWS4Kr/3mNc4y4DeKEvTm6WvfX3CgDnXNsJg4kBF7QN/37hNSezyJGFwWQnghhqpX7ZOn92mQvZeg5YBSicajEwR64qz7Go/Vsrnpl0ip8XKHLfl25F3vV+WEM3A3aCTS/9nnvyWOu08SwbOsokh8JmA9PZ5r9XrW7Ozdc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Shmem has some special requirements for THP GFP and has to limit it in
certain zones or provide a more lenient fallback.

We'll use this helper for generic swap THP allocation, which needs to
support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
is basically a no-op. But it's necessary for certain shmem users, mostly
drivers.

No feature change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/huge_mm.h | 30 ++++++++++++++++++++++++++++++
 mm/shmem.c              | 30 +++---------------------------
 2 files changed, 33 insertions(+), 27 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2949e5acff35..ffe5a120eee4 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -237,6 +237,31 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return true;
 }
 
+/*
+ * Make sure huge_gfp is always more limited than limit_gfp.
+ * Some shmem users want THP allocation to be done less aggressively
+ * and only in certain zone.
+ */
+static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
+	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
+	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
+	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
+
+	/* Allow allocations only from the originally specified zones. */
+	result |= zoneflags;
+
+	/*
+	 * Minimize the result gfp by taking the union with the deny flags,
+	 * and the intersection of the allow flags.
+	 */
+	result |= (limit_gfp & denyflags);
+	result |= (huge_gfp & limit_gfp) & allowflags;
+
+	return result;
+}
+
 /*
  * Filter the bitfield of input orders to the ones suitable for use in the vma.
  * See thp_vma_suitable_order().
@@ -581,6 +606,11 @@ static inline bool thp_vma_suitable_order(struct vm_area_struct *vma,
 	return false;
 }
 
+static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
+{
+	return huge_gfp;
+}
+
 static inline unsigned long thp_vma_suitable_orders(struct vm_area_struct *vma,
 		unsigned long addr, unsigned long orders)
 {
diff --git a/mm/shmem.c b/mm/shmem.c
index 3b5dc21b323c..5916acf594a8 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1791,30 +1791,6 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 	return folio;
 }
 
-/*
- * Make sure huge_gfp is always more limited than limit_gfp.
- * Some of the flags set permissions, while others set limitations.
- */
-static gfp_t limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp)
-{
-	gfp_t allowflags = __GFP_IO | __GFP_FS | __GFP_RECLAIM;
-	gfp_t denyflags = __GFP_NOWARN | __GFP_NORETRY;
-	gfp_t zoneflags = limit_gfp & GFP_ZONEMASK;
-	gfp_t result = huge_gfp & ~(allowflags | GFP_ZONEMASK);
-
-	/* Allow allocations only from the originally specified zones. */
-	result |= zoneflags;
-
-	/*
-	 * Minimize the result gfp by taking the union with the deny flags,
-	 * and the intersection of the allow flags.
-	 */
-	result |= (limit_gfp & denyflags);
-	result |= (huge_gfp & limit_gfp) & allowflags;
-
-	return result;
-}
-
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 bool shmem_hpage_pmd_enabled(void)
 {
@@ -2065,7 +2041,7 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
 		     non_swapcache_batch(entry, nr_pages) != nr_pages)
 			goto fallback;
 
-		alloc_gfp = limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
+		alloc_gfp = thp_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp);
 	}
 retry:
 	new = shmem_alloc_folio(alloc_gfp, order, info, index);
@@ -2141,7 +2117,7 @@ static int shmem_replace_folio(struct folio **foliop, gfp_t gfp,
 	if (nr_pages > 1) {
 		gfp_t huge_gfp = vma_thp_gfp_mask(vma);
 
-		gfp = limit_gfp_mask(huge_gfp, gfp);
+		gfp = thp_limit_gfp_mask(huge_gfp, gfp);
 	}
 #endif
 
@@ -2548,7 +2524,7 @@ static int shmem_get_folio_gfp(struct inode *inode, pgoff_t index,
 		gfp_t huge_gfp;
 
 		huge_gfp = vma_thp_gfp_mask(vma);
-		huge_gfp = limit_gfp_mask(huge_gfp, gfp);
+		huge_gfp = thp_limit_gfp_mask(huge_gfp, gfp);
 		folio = shmem_alloc_and_add_folio(vmf, huge_gfp,
 				inode, index, fault_mm, orders);
 		if (!IS_ERR(folio)) {

-- 
2.53.0



