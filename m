Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9EF606A335
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ct/oQlW8
Received: by kanga.kvack.org (Postfix)
	id F2A0F6B05C4; Mon, 23 Nov 2026 09:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F02336B05C5; Mon, 23 Nov 2026 09:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E176D6B05C6; Mon, 23 Nov 2026 09:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B95D46B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:17:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AF261808B7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:17:23 +0000 (UTC)
X-FDA: 85466586366.09.F0FB43C
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf27.hostedemail.com (Postfix) with ESMTP id D028240012
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:17:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ct/oQlW8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443441;
	b=z3chmKGEqTd38+c1VzaVjjQWVLK2yuIkNEVmnC7Gf1GFW2cK5yBngtwzQWbGFk1AaBipRa
	MklQBZDHVdaZyLB/yAwVYjBO+SbAXt/FO+0UDhOIaB49VwCQRNXOvEhAomyz2LEZwSYLDO
	2h6TNLFLv9c6dnNHpOgaBHL7dW12dls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=przsGoNeXdp32y5+6ZBoctPoG5cTnWhcKcU3VSR8K0w=;
	b=Jh4xfc2c7men9J1iXAslw7WYLKBaek1KFRkJZ5ZJBmR7eXhUD8hhDk9T9GOFplIg1WxkF5
	Q+xsuEsQN7IGANTHzhIzX52avzG5qyuIQUWw8+u4SF3vf51iHaaGRHp/xY5xqLzLbVCghr
	59L7st+awq2pioGWdvu3IkkeaaaJOgE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="ct/oQlW8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-38190551625so6945605eec.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443441; x=1796048241; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=przsGoNeXdp32y5+6ZBoctPoG5cTnWhcKcU3VSR8K0w=;
        b=ct/oQlW835f1lKz4l59jydQWPsK3Ftjic6L2zWfOhvQJuISSQJPdgkNgGjoTWpc2H6
         E3h3X1B2gsAOoUR3WMgVbqDRrEUw7Qumq0HAQHihD8hOhbAl1Sspxmh/D3MMYzHFHFwr
         veIWIrM3mLjfEIX/IZfa2jbKYHuHR5R2teWmb4JCon/Usrkl2RMixKVEGqs6RnLTsiDL
         qJ4dwnAwCpVSvpi+qDA+rghL1MQouZuiUXh5RVmW5Div6sGcsY1mAChvM/flPZQi4DsV
         vTs8vj6xqfe0WpanCs7xSFefZAFKn9tp96CqQHjzhmVGOI/B4Rey3/d2lPFl9sfeM4ZV
         GkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443441; x=1796048241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=przsGoNeXdp32y5+6ZBoctPoG5cTnWhcKcU3VSR8K0w=;
        b=KmehfqBvnXcsSNEsEaot6M+iD3v4KkU/VnTVmmt8fMBnfVBcaCA48zaGTzJ2GI3JJS
         8Lia55YJiClJDi5jLx2XNJvKXKlKRrZJyUAkPDDQvCLBDczrFH/PHDeO9Np8upTtDJPe
         3aFkgj31Q7aXWlDB8biYcuDQMdrufqjW6FJkoy5SVaMJiK03TnrFoMGkNuP+FplGy7jZ
         dTN/hM5qkJre8jtM8arNGXun1bSo12kRAgvdfkXb6hoH/BMVuRkBAJzymgOO/3s/B+w+
         P0QLaBxZ/KzTmxNvJXeJ4EFyvGicfbYOim8w8vH/5M08KiqgP6WsszqeolMR42ryMkDA
         s8bw==
X-Gm-Message-State: APuU4Z/RsVwnzdA5R5Xgr0c+qLIaUP5GjYDbQ7IVT6704/ji6VNh1TQY
	Ro1XByMryDB+HPDI/3HvTdd/gYetbiiRLAw2bvPGLe5T0I1rPMxNiTvRqfc2SAHf
X-Gm-Gg: AZFdTZcp1O82xQN8GMwYKyuZSN2KWxZY5JC+M9nJkCAGhyTcsoteDZS0e0Fr/qJTbdP
	nKMgnrwwZds1iSxbPXAAku+LPMB2CjpVgTfk6F60f4rewaWy6Dir9hJPfVBnplAm/0ncVHRLRrk
	4qe75EK3uMPFfj/6qXxMaoTsN4FBjNlJMC43avSVvXn0hCERr2P/FKo5eFSv7vesYYczDiB+8k5
	CN39zRxf56DLnBId77PZ/CP6I6GR43FnIeOvx1zdsUXiKr9zJoVlNyJ6SeWsBP6OrEnxb0Dgyoi
	gAEa64sFkIqlfutZ4LJv6RC8RKG1vnRWrSNxn4BWhftjfU5PBHysYQHTUITqa4wIFC+bY78JOK4
	HyDs3muD465PFI02SMTrklRA9ua8TRCuYTgvir/iIfFQlVjiYQzaPZ2JxUtYXqMHMCKXCA3PWvt
	80d3ZJySSA1L+Gjp+NeHx8evM4Fvum6BFFTapS5WH6fU/gVZ+Ak6y0itggIBEkNbs+9z1fYyJuN
	/PekreH6xrwC4eQSSf2On0d5BZIWtLkUNwEU9eXx1Cmipiq4rAVZI9fO3YosD5Unvi1XhtWMzPe
	/C8v0hLQZAnHLfa/CU8LrR0dEnYMOv+tdIFf2M+qDrA4bjP+JvLy7WY0dYZRlFhVM9x6
X-Received: by 2002:a05:693c:880e:20b0:386:b54a:7f6e with SMTP id 5a478bee46e88-386b54a8032mr2033437eec.6.1795443440605;
        Mon, 23 Nov 2026 06:17:20 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38566cd40c5sm42979741eec.10.2026.11.23.06.17.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:17:20 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 07/19] mm/swap: consolidate swap inuse accounting helpers
Date: Mon, 23 Nov 2026 22:17:06 +0800
Message-ID: <21e7cb1a16aed56568fa400f5385acd36513aa46.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: trrqyks3itmth888g4yp89qtbjsb8998
X-Rspam-User:
X-Rspamd-Queue-Id: D028240012
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795443441-752856
X-HE-Meta: U2FsdGVkX18gjpTGQHw5iwJi47ZiAhfnpJoC8uZBfQKtvDc4ER0tTquIT5/4nlENnVRCMwVOgEq+rAZe3kJMky0wWhhB5WRr5DqDDeThKqbsNRfGG4L7dGwFSA8hDwkRPhRnvgYRS94XWsFzActwZyrx+baMVr4lX1guZ2KpIxUukF3tYqIHzlrbpD9Kj6VPYFLMMdSEInNcfsrx8SYXp6XKx1rwWABmee44nTzUBCxoAmGQh9SkPocSxpuSbH0rjB+EyeCnREF7MjiNTj1QgFyJa4XXgCyH83hLdDEf4ZY36GOtN+0YQGibWVq92ujFh8dZoXRGmsn4+bNsSYKbeaHrXZsu88/5G7hgwecgtL3K6An0r06vaN/gBMdzwV4PU6GxWD4C9QchLYxtmUMbLJ346sMpG0iIqMsCccn5mV7RCZ0RBJWDpav7XHs7yxCFPfX7/cL1nhplHTPAgeUqTuVn/6GJVXeL7+4LkRHC26daJip/e4Da241dra9WTvfgB7fN0H79YZe84uu17zDdA4k63+TLFa51SY3bs3YaVEDiyqI/u7U8U0/OktSe867PPv1xoUjzu/PjkVLpeSCf9rHWsapO9Ho9lQgqOS9pHgnsvwrbWREMJ/amqwK0qpJX8CGRs5Mvw72rWB7orL4Hpdld8s2NovwrE7Troa7y+fZG5ZnKcbNWmc/WSXFCeSX3KWWlJ6nsBd+ntfpA1VImHEvnPmkFO/4SZSix29FXqde+hWzQ2evuVKS9zcyFXBqSgeT28rA70Fbdxn58Yhb8zPK+V8PDvoeUV79M00LIbQUkOR4MRS7+6vEQLIZVL30bG1xSsAdO5F25qQXJNEOcJuvUkVIITV/uQ1D+etu2kZYyKTVhfhE5u0t2wCizAZmiiIcpO3hG4JxRoIVJWDsOTkFrjleECNNT6I7wmJj+GUbIkj2S2pcX3wmrplqWZfByTgOko3m3N4Gg8KNrg1G
 oiQ5M+ms
 JZ6K2ziiI37dNfg3G+0LnamafW2CJNafJzJdWBAC1CoukdfH+/jpMaNoHym22IvMwqHfXv2acuwMKS6kjBgRTNY28V9tzgyI2GTBcP59ke0wiH9xyTU7klbkMksSIE9Mvmp1SJg0wa5hoOaTq7+lRVknPiuZZldgX7olcfrLgzMIwC6i3wWVtjbs5jG72nys8MuTmDKF28pGYIQCQ23oQ4gloEB4//AmZnsbHmXoec0zr0hdwKCAK1TXWOybTzsda/xuU5AiiPODSnVxWKMFDZF6GV7YmqPjVKuPc8zsVMZqq/SYiNjdAqPYaKMlQsf72jgkB/8RXHOQOc/f+vpLy7WSSnKL0uUhRLXoVf1709tMjm0UpjWWIRnawcxTMXNAA+e9MT3volIx4G3i+G1yhLvKc+7OtMBzF1hXfmICSz6caiBazUUTiOwFlvQarIlCQtGuWbLmOTLELKkm3fXWEeqzEVThRB/J8JFa/3AqTK1xsHaoaCF5fINqQm8HRV3F01a1dCC+uGq2YjLdvwRARGqoVCNAjNs8Qk7ofSqcUPVSAhSHQH9xbzeMMkL37+mWoN1W0VuKKOsYOdP4JA4KSmtmALNo58Ro/bv41thCHrbR40oIlX3C7zNBlgXYMgJl3zc+tgM+MEbmgMZ1GCGizQc1SgFq4zaoHL6bbtEx3HZ6wZZnc6JnBJKkk02XPukFA4iW1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Inline the swap_usage_add/sub helpers into their only callers and
rename the callers to better reflect what they actually do: track
per-device inuse page counts.

Keep the existing accounting and allocation policy. In the inlined
full-device path, reclaim work is scheduled before availability removal
rather than afterwards. Slot-free notifications and zswap invalidation
retain their existing order.

Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 64 ++++++++++++++++++++++-----------------------------
 1 file changed, 27 insertions(+), 37 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 24f301ef4e3a..4fac894f8c2a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -49,8 +49,8 @@
 #include "internal.h"
 #include "swap.h"
 
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries);
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries);
 static bool folio_swapcache_freeable(struct folio *folio);
 static void move_cluster(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci, struct list_head *list,
@@ -1045,7 +1045,7 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
-	swap_range_alloc(si, nr_pages);
+	swap_device_inuse_add(si, nr_pages);
 
 	return true;
 }
@@ -1363,53 +1363,36 @@ static void add_to_avail_list(struct swap_info_struct *si)
 }
 
 /*
- * swap_usage_add / swap_usage_sub of each slot are serialized by ci->lock
- * within each cluster, so the total contribution to the global counter should
- * always be positive and cannot exceed the total number of usable slots.
+ * swap_device_inuse_add / swap_device_inuse_sub are called within cluster
+ * update critical sections and serialized by ci->lock within each cluster,
+ * so the total contribution to the global counter should always be positive
+ * and cannot exceed the total number of usable slots.
  */
-static bool swap_usage_add(struct swap_info_struct *si, unsigned int nr_entries)
+static void swap_device_inuse_add(struct swap_info_struct *si,
+				  unsigned int nr_entries)
 {
-	long val = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	long inuse_pages;
 
 	/*
 	 * If device is full, and SWAP_USAGE_OFFLIST_BIT is not set,
 	 * remove it from the plist.
 	 */
-	if (unlikely(val == si->pages)) {
-		del_from_avail_list(si, false);
-		return true;
-	}
-
-	return false;
-}
-
-static void swap_usage_sub(struct swap_info_struct *si, unsigned int nr_entries)
-{
-	long val = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
-
-	/*
-	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
-	 * add it to the plist.
-	 */
-	if (unlikely(val & SWAP_USAGE_OFFLIST_BIT))
-		add_to_avail_list(si);
-}
-
-static void swap_range_alloc(struct swap_info_struct *si,
-			     unsigned int nr_entries)
-{
-	if (swap_usage_add(si, nr_entries)) {
+	inuse_pages = atomic_long_add_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages == si->pages)) {
 		if (vm_swap_full())
 			schedule_work(&si->reclaim_work);
+		del_from_avail_list(si, false);
 	}
+
 	atomic_long_sub(nr_entries, &nr_swap_pages);
 }
 
-static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
-			    unsigned int nr_entries)
+static void swap_device_inuse_sub(struct swap_info_struct *si, unsigned long offset,
+				  unsigned int nr_entries)
 {
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
+	long inuse_pages;
 
 	zswap_invalidate(si->type, offset, nr_entries);
 
@@ -1431,7 +1414,14 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 	 */
 	smp_wmb();
 	atomic_long_add(nr_entries, &nr_swap_pages);
-	swap_usage_sub(si, nr_entries);
+
+	/*
+	 * If device is not full, and SWAP_USAGE_OFFLIST_BIT is set,
+	 * add it back to the plist.
+	 */
+	inuse_pages = atomic_long_sub_return_relaxed(nr_entries, &si->inuse_pages);
+	if (unlikely(inuse_pages & SWAP_USAGE_OFFLIST_BIT))
+		add_to_avail_list(si);
 }
 
 static bool get_swap_device_info(struct swap_info_struct *si)
@@ -2059,7 +2049,7 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 	if (batch_id)
 		mem_cgroup_uncharge_swap(batch_id, ci_off - batch_off);
 
-	swap_range_free(si, ci_head + ci_start, nr_pages);
+	swap_device_inuse_sub(si, ci_head + ci_start, nr_pages);
 	swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
 
 	if (!ci->count)
@@ -2999,7 +2989,7 @@ static int try_to_unuse(unsigned int type)
 success:
 	/*
 	 * Make sure that further cleanups after try_to_unuse() returns happen
-	 * after swap_range_free() reduces si->inuse_pages to 0.
+	 * after swap_device_inuse_sub() reduces si->inuse_pages to 0.
 	 */
 	smp_mb();
 	return 0;

