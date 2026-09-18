Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5CCEC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 18:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638286B009E; Fri, 18 Sep 2026 14:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611106B009F; Fri, 18 Sep 2026 14:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE496B00A1; Fri, 18 Sep 2026 14:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15A576B009E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:03:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 760EE1C3013
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:03:01 +0000 (UTC)
X-FDA: 85227654162.09.8C28AA3
Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	by imf09.hostedemail.com (Postfix) with ESMTP id 86D7D140015
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 18:02:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/GdOBJu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/GdOBJu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.231.204 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789754579;
	b=ycaW0p/lzPas3U8BYhISM9CpKDqkJC32NS7rUehsVm40wxCT+twaUDBwdsZ2OuZAvMyiAB
	1OSuk6nZGA1MUZwAJslaNmICKbeQQa2/1xNL+Yu75WgkKtHsCyymkgQ1wmTyMDrV9qijhZ
	cjqoEI5Ttl66KeC74cxJgVv8qRfflUw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789754579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkWDXoev3ue4855J8KR8M6HtT2XHzciSRhLql9R/iaw=;
	b=Qf65wmkjZTOoaTA4NppXtNm0QNxcn1Q07TLPdsoDopXLl0fW3ebNeMNZ/O9tGM12xdI2cB
	lMxOLA74+QEPAaGO8nkdXkqW1nn7PAq4DsNSDMHumQAq12/3pMzo20l41LdHRZ7oFefKoB
	t2m4d98W+V6Ic9mvQn74zJvGlqH7EiI=
Received: by mail-oi2-f12.google.com with SMTP id 46e09a7af769-7fcb425fb68so575804a34.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789754578; x=1790359378; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WkWDXoev3ue4855J8KR8M6HtT2XHzciSRhLql9R/iaw=;
        b=Z/GdOBJu7NtkxNqGg5oKePJYzLzIyb+gVQ4LKzyH1b+YkZmAyfyIUqk7KecMSVU7rC
         5PgfjjkYIormXNGbN0dB6gklyczqIX8MGsOr4IQFWCG+bR3ty/H195jdr8BvvdKWXBsS
         w6Hzbu2tbnP8+0gPmzdOjj4LYOpYpnmdxI0yVGcvDR3+tH+0lCASs36UvXml3yfI0rm9
         ewLTI3GjTSW9BeFIYniXEd0Rebm1zrYX+NgUT+8pTaiH/eLENBBNm9AOHRZXnV7ZUsLy
         y8rbjPFACeFB3XLCukq85e5lFIfzMAlVXaeQ4aC8kvnnWccETuIEGXc35/vtHDc2cTel
         5ZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789754578; x=1790359378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WkWDXoev3ue4855J8KR8M6HtT2XHzciSRhLql9R/iaw=;
        b=OZuPg3LdRDUqkQDSHNUixBMxA2OEKE8s8/8ZDNTBVeEd+aBIa5R/pUIM2wHQZJ0G5J
         TlFTYRR6NejTTjTB8d3yIH1FXRnBxp8mmmFaOT3JxpcZSImbPaj+z2fvy7ocMApXpv1A
         ahFCQupNajbibbWBZLxfxstVaJF1Y9cHrz2SKRGYB3GGHAx9UMjNnWKTI0Tvpp5RP8Xq
         FgiqPrc86pvsQBEufBW/mGUOTclUAO+oDRPiwaJPptDl22KjjD1a+0Yiz4/bM6kXOXjh
         hQFKwgOni86B8LaPid/nkvNgSVjUlj5cRC8XQEO+eV0tSawQrneIpaE/m9prtFhuOoFa
         1o5A==
X-Forwarded-Encrypted: i=1; AKwUvBzobZKoLLC5kkn6JeYtt0/dOSg32IMHedpEn1QmOkrFf4Uye2WaEog1kj3T5u6TwRWd/HOekTg+tg==@kvack.org
X-Gm-Message-State: AFuF++m2+KZMD1gJB6MwRyIzFDr2KHXciiLWIdOigCV/MxZx7SKCc/9q
	Coinv2K7/m3ZKqji9LV/jahIESOA3O0zvQnHjWPE7jA6Q5nUSsUJD4hw
X-Gm-Gg: AYBFou34BJRDt61LOeEWfypCbInYwtzhArD1+l0ilCpZkSfyc8qBoZghVEjAp4ha75A
	pkasyPpmjkFdDSQC+fZD+mplkWiZ3Zi1tEFJhgbvX5yAlrAKyA02827WHsQ+qsgJSJ2mQB1sdOj
	/UfQXGg/0c+L4+YccZjZ/A9XPjmZrf2XvTztTD6LpC8pBWizyTkzsvzetnCu5PrGLlMU6377Xb/
	BY20CFUGzNZ1UWgG9YKDGg1bQiC2gPhSS3ZnDUDOoeBHLJr2G5BTn12iThVmI8a5FzaiYOTx+zo
	LP73jdxYjQHRWIOqseVPqgznInTTMo6dU2Msn9hBgIle6kTS4UMFnLL7d9IrvsVihcQnpSR9paI
	Wed8GJT/3YpiaHlkTc1koYt7kbUyLSWEb1jy2Gb+nLIb5hJnHKX5ocqKF9pl+lhJO4RnSzTB1q/
	Ce4J5y65aY5uFpUTqeyLUaHgYml13p2WY1utAinqcMoIID+QGnzDTRKtJ3vmzd8AiWGb0Rp/IJB
	sgpKBaIb7PLKuZFtqC/EQ==
X-Received: by 2002:a05:6820:81c2:b0:6c3:38ca:c9c0 with SMTP id 006d021491bc7-6ca9ca59232mr3229844eaf.53.1789754578532;
        Fri, 18 Sep 2026 11:02:58 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6cd3591d0b6sm565715eaf.12.2026.09.18.11.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 11:02:57 -0700 (PDT)
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
	kunwu.chan@linux.dev,
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
Date: Fri, 18 Sep 2026 11:02:39 -0700
Message-ID: <20260918180241.3424851-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918180241.3424851-1-nphamcs@gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 86D7D140015
X-Stat-Signature: ez9tkkzkcxwec7tn5ebkc9eznhjqzijy
X-Rspamd-Server: rspam01
X-HE-Tag: 1789754579-861447
X-HE-Meta: U2FsdGVkX18ujYziiUAJRHbT/RAGNANLuomp02+hkyhp1ht5VCHIu0ReGpnrllG7GfvwAqyqzQuF8uVEgwaKtVPprSikD0drHf7LtLaEMg4KRnFVk6b6j/ZzRnC/msahyuXhGQ1wK1QFvBkqvzb4ZR0ojtnZ0kQ3AzNjxRBTLl/NnTdMZcTSLhB3GbaBsOCl1DlcicNNGJPvlUg1j3TbJn2ORzKCDlZj3Co7LXBK9BMYggfpqmgEY0hAZcfiGPybDTLN8mRptCV4s9eVWpqSo5r0OYdzND4hFFGzmOqj0tpiqO/poEN0EiUMkyVm2BmuFN1GiYCyq4RQOgnlX8/r1nGwkNhjiQtrY0A79M6C9TH+Dn054UjQn+dlNxyTyWYc5p1/AjzmKnRvvbgHrf4itNbyVYQdVJWO2rAb5Ch9lIGr032c7uzm9GtnTL+q6j+yw0+iKd4IFREO6q6semIOJ6ciDV1d3agSTt0XwNY16aKNctbar6xyKliJ9uZ9z8KOB1zsRz3Rx1sjabvRhqsTFse8An9Z4hh0tWLlSrFzancEJQXs9ojb3bPVSnxFvQZ76RiDFfuU9x3vQ4r8KKQENiCYRHarqSvb9gQdnlPZzRXeQgHs4acAbLNx9y8Q+WLHT6k7kxxD4FRAQa1087ZPsbl3PGrlgR0HokkCnxCCBTsSCnN6+dwKDrYxtGtnY6/TrWnknu3xOJcLa33izGKrwUWrROwqmbMQPiG4e/wtJ4VLBJBvcrgMxtlhGQtXUXP0AhA8WgUrJ3vJYddgKugKQjRXLHGJuTPpUkx+lYTAiuqHvI4CxN25Y4ealS2mJFdFT5Ds0W6nk0dMDAbgHRt67WqKd6gZeReGtNk7Z28Jucl46xvCGUONnAGrG9KLYCn4gkKFFRZLWftKH869nCu2oat2cy4LwDh8M6jrQ+TKWjhy1hh4AcFubWGbBwjWKciWaBhH8k5/I7Dsk1F3bLS
 TqqJw3aP
 Z2/ZYTeVe+1TxBS6oMm6piRZHkOfJ70Jf5Of2s80jID9THvy1DWukP6ZznuFiaqt1iAAh+K19dd+d3yDX3beblYdhEa8ZBhzNPHmTxY3jeWyuSrLUyGRIkqFhKGs2Hi/NWIVDzX36eI7euZVHQI6JAqK7QrNDiAyICydQdb866rkEnngJEYGhWecR8HK1zmh3Qyc6oLduOuzAjwlx2eyNPgzVU4bHQK/DMTbyq9crgFLszmEcEb5C9hqdhh8J/yY/Urc0SCTeLi7AgJq6CHWubTrHwaM8p1l1H31Ce16j9Mceg3WiCo4mDBCmEzlpnZWbkqesHbeNVwoUi4AbNwLTbO5H5XpL/ApomeMv7sCSYBOg8nx780YgnU2e3DVgP14PruVsehmchGwIlAwNlQ5FTCw39VhUusLYOid1GvOXJeey64UGmd+E3mvXNr7z64vgfCxVw1Q7Drabfpnw+3EiYkT4tcYUSaSH4QBprJwWbHrw0ePiUrnpf2K1Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add /sys/kernel/debug/vswap/ with two counters:

* used: virtual swap slots (pages) currently allocated
* alloc_reject: cumulative pages that failed to get a vswap slot

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3c3fc3b87b9b..cf07d87d2301 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -142,6 +143,7 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
 static void vswap_clear_cache_only(struct swap_cluster_info *ci,
@@ -1996,6 +1998,7 @@ static bool vswap_alloc(struct folio *folio)
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_long_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 
@@ -4827,9 +4830,25 @@ early_param("vswap", early_vswap);
 /* vswap does no IO on its own. */
 static const struct swap_ops vswap_ops = { };
 
+static int vswap_used_get(void *data, u64 *val)
+{
+	*val = swap_usage_in_pages(vswap_si);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(vswap_used_fops, vswap_used_get, NULL, "%llu\n");
+
+static int vswap_alloc_reject_get(void *data, u64 *val)
+{
+	*val = atomic_long_read(&vswap_alloc_reject);
+	return 0;
+}
+DEFINE_DEBUGFS_ATTRIBUTE(vswap_alloc_reject_fops, vswap_alloc_reject_get, NULL,
+			 "%llu\n");
+
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4881,6 +4900,12 @@ static int __init vswap_init(void)
 	mutex_unlock(&swapon_mutex);
 
 	vswap_si = si;
+
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_file("used", 0444, root, NULL, &vswap_used_fops);
+	debugfs_create_file("alloc_reject", 0444, root, NULL,
+			    &vswap_alloc_reject_fops);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 
 	/* Last: everything above must be visible before routing starts. */
-- 
2.53.0-Meta


