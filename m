Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A03CD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 12:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17F1D6B0096; Fri, 29 May 2026 08:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12F8E6B0098; Fri, 29 May 2026 08:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 045256B0099; Fri, 29 May 2026 08:19:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E47446B0096
	for <linux-mm@kvack.org>; Fri, 29 May 2026 08:19:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFAFF12010B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:37 +0000 (UTC)
X-FDA: 84820363194.30.F82410E
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2A80B2000B
	for <linux-mm@kvack.org>; Fri, 29 May 2026 12:19:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=mCkTiPo2;
	spf=pass (imf31.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780057175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVdSFaRs3+EuMAnxIy5DMxxMx3cOnErIMJI6trzSpzw=;
	b=EbyubturAJav8DmOrPjCNBPQc9SgynSyufA032NfuJ2mVgl5NdHq4+WnBwoEM/HUw5KRS1
	Oqrii0x7bvwmIG0WnR6Ch+Kf5qYeOMNK+vJqeWOH865ZZVPzs1nAzO6lMs2yoLrBfxpOVp
	o+JT0rDr9WuH3IJIf9cH1dCCmLAlEmM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=mCkTiPo2;
	spf=pass (imf31.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780057176; a=rsa-sha256;
	cv=none;
	b=6KNuAmSOvYX9fztmS7JOq0nI1qnUQ3NplAK4d4Sbw59aErAAW4m/Xwg4O8c/OkMg+ljVAh
	GH5XSXIJYRRYNq1u8ZomQY/lG17CDMa5lQpLC8pSuRWaZSmzJlcWf6JwOM//IK2tfnxBss
	Fm3DDO3KMpV49agB3SjVGt69QVKERAw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1780057172; bh=bVdSFaRs3+EuMAnxIy5DMxxMx3cOnErIMJI6trzSpzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mCkTiPo2IHFozwt8DpBgCjFjySFOUCuCqTBoaeJIrfHDNtKRvPSy8ga8RIIhXoGD1
	 +Vp+23K9Y/9cO0wv9B05pN4RsbWvBjmiFM6f2UqnZxxpT5BPdEDwYq0/0pvLDMdxkT
	 ZT7UMm7mvMFjuQvpNyL+8DmLq55Qmg1UFp/uDPHI=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 4DC10017; Fri, 29 May 2026 20:19:28 +0800
X-QQ-mid: xmsmtpt1780057168tzjwrsgd1
Message-ID: <tencent_C78A02F3C41E15233C371816825C7DCF8708@qq.com>
X-QQ-XMAILINFO: Mi3PnGw1zbXUjsp55hP//2TzDYS0KqexQwEQGN+M9bSC/Uz/t0z4g0+EhjTtIp
	 aeC+9AOG4QF1yU3MizVH6jsjooanTR/YImuIOHMLZtLBWkfeahthNaouMCgnkq+4hSzD3tgQh2XG
	 cqRup5WSheqyiCFxk21Z3mbwtSfMbOQMHLRbr+E/+chvZheENv8ppzUeBEI8UCEzfG1/jxZiFxyF
	 JE7xjP8ub2ACuhw+tODKS062CDu4/T9QD8F4NdlKhcTl3Jc8EeTjr2kYsRQ5UK5Hk0KLHSrKMFhu
	 mZLyoxhqmL1jKhtZL3fx+CpZe3qVa7BYYlggv4aTQdCjfE+gPcyezlNIe/RqbynSqgetnZZgsqdf
	 tQ8sNXkXnO3Pz3ypFtgl71X/b7TsQgVV6YKTEJiTObQezFUY9yhVU03QB06s1/56FkU5WR5nm+6k
	 3TV8h2C14/FRkpGI5zAxZguRacsR3epJaRo/i1fKKeTOOPLil7pQc6nrJsPOiHluEG5RqdTLXO4K
	 cgqOd1uaAA1UEPNoiFIryuDsv+ioAjdNf0nRomgnDn/v2ha5Wcum3JEmj3UAPnSUaFL2CuEuSlGP
	 XxQyizk8zeTOLyKJkYZbh1FIGsZ91Az/F18jOPCi5v1DxHim6oBqViPSqpO7QmKOeE1j2abubHlh
	 Y0UD9hZObBOFfAZXXADZ7j85B5bFiXwYoJHkkTLrlRokRx1srF81L9m1TLVDMmlmsyIGNkAICdLj
	 qlyDS0lRnH9L7NG1iBiExGC8Ys3vKHoeQjs5L9X+64zilXWEn2oOeXYVxAO44Edo9KYIjEU4G/BR
	 l3jySsFO94cRwP9qfuxfnK1oYgBx7kzjFWri8MeLRAwaFANb0AcvRqLz5lw4qtItsg613ZSgXNIK
	 IreARaqnQ0WTnkMJIBgyoZtL9itkNwxPi4V0HTRNt3cp4cMpSceA6PZyfd/wLkKN4HugFzokiodR
	 yP0IMUMzY+oT7YKZlNRnMy7NsctfIbfvyV93nAb6jwA1Un3gbA9m8YXxYjEZLOj7Ox9RtHkiWbd9
	 6tpV34wAsTreBbqm/Hw9CMLzwYvmtSTm/70HLX2IrRJayVsRbBlEiEnUB8qygbYNw9XXJA8d9Vpt
	 DNjywgVE4gVz9JYNTNHYobOfd5IKqB8kxs12z+UbOK0fU3j6uV6lOBmLn2hw==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
From: fujunjie <fujunjie1@qq.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Alexandre Ghiti <alexghiti@meta.com>,
	Kairui Song <kasong@tencent.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: Chris Li <chrisl@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 1/9] mm/zswap: expose range state for swapin policy
Date: Fri, 29 May 2026 12:19:20 +0000
X-OQ-MSGID: <20260529121928.4115683-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
References: <tencent_98CD9F78E48D08DC005A6471A13CFF28B60A@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: nm4da8jswwk1ri64ergsceg6of1yyr4n
X-Rspam-User: 
X-Rspamd-Queue-Id: 2A80B2000B
X-HE-Tag: 1780057174-415729
X-HE-Meta: U2FsdGVkX1+wAGJLPpR2ugsB5HwcOvLwAcLg59j8WSWHb4lQV4XSnzdCy486LCUHjRjCQb6iqVVDMZV6So7ywCVkRiDANRmYorC7JIbNtg7JFxhAGEN2/XnBZx3lVgq445+BHkwWDfYNgN2Zg4XhCPNkLnbzkRb/e7axbZfgeIHPnsApo6U7gmMDsyD5YMGqhtR4d8UUaXiIGm/38UnCkDSFUZvI1xvb/yV9aDOfeZ0q0+qj6AXtnaN5XE9UNT/rlJj4SQuM6YoaGUqpeucjSK2CKNHPfGVtJ1tanxnf5hurHqg3/iaGkmBh7qGWIym8iqR7/wUkad1ShlujIQ3TsT8FTgwz5qd2MDMt3oaqqJbrwANxLAlS4e5ZSHjYqypHm49TxCTOYJTwuUJJb8W/HoMWNpoNZsmSKcHP6M1CiTrsi7/whE881WltLk6D+OeF7na88O7KFSJ+NmCtSUxV2cSmfBNTcJY2Z8x9ip+ZBxviNFxXqH8/XXCmpPILI6EX2l0XDsKrZE8gRQiAJc9G6azw+HGZBNPXF4cs0GKGx1UigyXchDLHdPV4AvxNpekg7nuOftT317ObMWyFO8Rcz8q2ljryR9XoWVbjLDoxpMEHIFsCQOroPHYe6/X2zRSDgVYsZIYev3ZHimXm1t/1tfqxM2y+4P+aExVtbuwDqrLGKomiArZn+cPQLX3/GOfWNkZJ2ER4Q3C8UDqL8ApBsak8NsD3IxmRlKzgZQMlotWSTwRPgi91UVSjmymv40L2xJ0fJVDaH3velW6Jvfw3/wnINLk2QHVlpCL0EEBsUUIEUFvxMPktVwcKR57xoeEfVhAmU7cgufFuvN0iD66eepYNsHYYVsl/d4WpaOodWNZOS5jJCU1zHWTr9umbzI9kBcupDNIPr1ukYK6lWjUYOzLLvjDAB9FRmOejth/eVXF8aodDcT6gh/PprQE2Qgrn/D41N0fqXbWxj2S3TqP
 6ltk9ac4
 kZXHVNt8wwEEhCpLoOyR2T5p2EjfuYBCDozrh5vf3FvZVqK7jpHYFfkagwEyr59Ip2mhv/xV2qh9L2ZoEa7Q+oOGP0AsBAEIRvU4xRi337i7WzzcUCI42wCtqCqIFJ/DbHkITpdGYRgbYdhCbd/Ahb7bD6W03xBa/1bX/aTnbdOaVpgVNWNrGdvUGJxQnDPr7CJnLqWkn0rcfmyK/pOGk4KwwFNeFnZn29Z0GRqSy809QJLU9o7+FT0OgCKh6Pw2DrpwBT7Qybsr7L7ZLzM65g6ZaS4BzyfFOF71tHcn9xFWUT6I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Large folio swapin needs to know whether a candidate swap range is fully
backed by zswap before it can choose an order. That decision should stay
in common swapin code, not inside zswap.

Export two zswap facts for that caller: a lockless range occupancy snapshot
and the current zswap reclaim-pressure state. The range state is
advisory only. Writeback or invalidation can change the backend after the
snapshot, so users must recheck before issuing large-folio IO.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 include/linux/zswap.h | 26 +++++++++++++++++++++++++
 mm/zswap.c            | 44 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..8f9aee97517c 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -9,6 +9,18 @@ struct lruvec;
 
 extern atomic_long_t zswap_stored_pages;
 
+/*
+ * Advisory zswap occupancy snapshot for a swap range. This is not a complete
+ * backend classifier; callers must recheck before depending on ALL_ZSWAP for
+ * large-folio IO.
+ */
+enum zswap_range_state {
+	ZSWAP_RANGE_NEVER_ENABLED,
+	ZSWAP_RANGE_NO_ZSWAP,
+	ZSWAP_RANGE_ALL_ZSWAP,
+	ZSWAP_RANGE_MIXED,
+};
+
 #ifdef CONFIG_ZSWAP
 
 struct zswap_lruvec_state {
@@ -27,6 +39,9 @@ struct zswap_lruvec_state {
 unsigned long zswap_total_pages(void);
 bool zswap_store(struct folio *folio);
 int zswap_load(struct folio *folio);
+enum zswap_range_state zswap_probe_range(swp_entry_t swp,
+					 unsigned int nr_pages);
+bool zswap_pool_reclaim_pressure(void);
 void zswap_invalidate(swp_entry_t swp);
 int zswap_swapon(int type, unsigned long nr_pages);
 void zswap_swapoff(int type);
@@ -49,6 +64,17 @@ static inline int zswap_load(struct folio *folio)
 	return -ENOENT;
 }
 
+static inline enum zswap_range_state zswap_probe_range(swp_entry_t swp,
+						       unsigned int nr_pages)
+{
+	return ZSWAP_RANGE_NEVER_ENABLED;
+}
+
+static inline bool zswap_pool_reclaim_pressure(void)
+{
+	return false;
+}
+
 static inline void zswap_invalidate(swp_entry_t swp) {}
 static inline int zswap_swapon(int type, unsigned long nr_pages)
 {
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..da5297f7bd69 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -506,6 +506,19 @@ unsigned long zswap_total_pages(void)
 	return total;
 }
 
+/*
+ * Expose whether zswap reclaim pressure is active. This is a backend fact:
+ * zswap_check_limits() sets the state once the pool reaches the hard limit and
+ * keeps it set until the pool falls below the accept threshold.
+ */
+bool zswap_pool_reclaim_pressure(void)
+{
+	if (zswap_never_enabled())
+		return false;
+
+	return READ_ONCE(zswap_pool_reached_full);
+}
+
 static bool zswap_check_limits(void)
 {
 	unsigned long cur_pages = zswap_total_pages();
@@ -1559,6 +1572,37 @@ bool zswap_store(struct folio *folio)
 	return ret;
 }
 
+enum zswap_range_state zswap_probe_range(swp_entry_t swp,
+					 unsigned int nr_pages)
+{
+	unsigned int type = swp_type(swp);
+	pgoff_t offset = swp_offset(swp);
+	bool present = false, missing = false;
+	unsigned int i;
+
+	/*
+	 * This is an advisory, lockless snapshot for common swapin admission.
+	 * Callers must recheck before depending on an all-zswap range for IO:
+	 * concurrent writeback or invalidation can change the backend state.
+	 */
+	if (zswap_never_enabled())
+		return ZSWAP_RANGE_NEVER_ENABLED;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct xarray *tree = swap_zswap_tree(swp_entry(type, offset + i));
+
+		if (xa_load(tree, offset + i))
+			present = true;
+		else
+			missing = true;
+
+		if (present && missing)
+			return ZSWAP_RANGE_MIXED;
+	}
+
+	return present ? ZSWAP_RANGE_ALL_ZSWAP : ZSWAP_RANGE_NO_ZSWAP;
+}
+
 /**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
-- 
2.34.1


