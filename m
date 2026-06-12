Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28CF1CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 19:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1F466B0098; Fri, 12 Jun 2026 15:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACF496B0099; Fri, 12 Jun 2026 15:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9495C6B009B; Fri, 12 Jun 2026 15:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E24B6B0098
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 15:37:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41ECC8C802
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:53 +0000 (UTC)
X-FDA: 84872270826.16.48A5A4B
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 60D9FC0008
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 19:37:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KkXt+4NS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781293071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84IL4yIxjt9mfiZQCACEvBG+RvMClGpDo6n1a8FJs1k=;
	b=RLxqbZfU2LxF9IQdhQYHHdneLW96v5HIkVbWgImi6NmO2F6PfwUxFzMQNHi2Dr1FMveO7C
	8TUB0sSeDPAid7zYtUFPRUU08SeFTDD6ObJnDjCBFWiBFqukPQwNOydlP1q6i6zgbSc95r
	wE6Hyfx/Lz8O+oXzBlhWW2PG36h24SI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KkXt+4NS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781293071;
	b=HqN+iCay+VAyc+b3TYHzRYZ6b9rYVOgb01oCVp/J7Peo5ZxBa6qMsrj0cP4zdL+KKBcDlk
	gWBGTS3ZdZTcvM5VYfECi3jSBSKJC5BxEJhWwd6Tbw4cOHAqnX1SFZKnpxylMgrldB6eo1
	suicc+ZfQ36A6QDWb8/6m9RAUunoX8s=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-69e1f777bcaso1047453eaf.1
        for <linux-mm@kvack.org>; Fri, 12 Jun 2026 12:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293070; x=1781897870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84IL4yIxjt9mfiZQCACEvBG+RvMClGpDo6n1a8FJs1k=;
        b=KkXt+4NSj2TNp0+CvG9ONVnh3Xb/hpVvmei8MmnRLiQCNLwwrPmXzaWm8DgmGkS/KW
         xT8qcOK06EtyLTaTkrjMT5Szs1KtAW6cVYclWerh612gBLJxKPbRX6u+Iz1zLfdarBhi
         u0UyEehhZl4SMl3S0Yb3fcPYzZ7qZ/m7S97vLPZ0YlwtnwhM5cjLezllZ9DtMa+LX5nH
         4bSBOFA1/jJaoSh+aUAOCC3IKNS86KfqmJwufLIW7+IIQW+9X+dzVVG8rYfHCHr2PjH8
         ch8MbakaeKnEPG+SAv4swnaIOXJoHqyWWwGC9FVx8YSWRseUKqdaH0IO/4APzejzXZ71
         vNZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293070; x=1781897870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=84IL4yIxjt9mfiZQCACEvBG+RvMClGpDo6n1a8FJs1k=;
        b=gzCyg3Pg0sue7LPOB0qMxQ3KsBKhk/tW6IGs+vaMrR877rfFmy9zyq5Ee3k37ctrt5
         vF0H4PhongCWQEZvL5lN8tfK1XHT0ezudtc2dD2LmcBDbWNZCIbDTngmYt/NTkWadVsm
         iXh8iZWjy34nddQWnp16ChBaxWJnCABowvU4n8VwBxXH3apIrdwP7Ah304G9NuTHAQl/
         vACbg0YboFO8ewYyPaBp27i22296DergXuNbuLvl5FzxadqhuVIHS8k67ZuVp95GcyyJ
         SskYL8ABpgoDWQ8qQb1wzLuycYJIfVnHk0eXCNuW2taEVT5BwfMII+zDByU/ofdI02qY
         TSug==
X-Forwarded-Encrypted: i=1; AFNElJ+mkpjLzkdHNkF9OQ/SDgmM1D48JbGMLvWXsCE4gPlV+3+k9cfzfJBwLf0T49VU5VfuIF+Himofrw==@kvack.org
X-Gm-Message-State: AOJu0YyX3NEjqpUMavZ7OCrvocbGPQNQm9BgKu58cDaIMoAqNbpULAO2
	sSOhBVI1fscCL4nhhpbG67bMKd5TH5ntQzXcmkPTo3I9MpWL2v54O3sx
X-Gm-Gg: Acq92OFolv84MtXptkpztgRa4cAVPNjVmDM/436+iKgoffD5zdSFwhfEE1IXGpMUj9P
	OBuJnaz1QQ0o2/AgNpjotPf7/1KRFtqJnN+bj2pivlNj4v9TVDi4D4YB3zHiJKFMZ8aUT3jduqC
	WWOMZUdo+Yq7zdDOXlGCZ+C/pboH1A5ZeUKLsfAXjFuOKZAbj8jx92DI2F76P8tJSTQ1sPk3V7K
	iGXYVisiYbwBp1EXcjmZIbvFdLYyCtrNQ5HeQr5G4jW4tFc5RLlDqmS0ICPI0wDWhORlhsdUb6z
	argJE7mlwEsZre8zEd2deihLs7Z8s5X4NGA7F8VMwFjyS3i/bu6l8xkuKOGjJPWVca31w36SrCl
	CLQGi5Jbq5n4Jj+bXGkEUOIrvvGS6RP2xZssoAmprvMucH9vxG81Se0ZudRd44w8ySetq33MZsU
	3BiFWJATQD3i2oOvGxsIrMN6P8uRRiQJN7W5iuljHRfKaV
X-Received: by 2002:a05:6820:4b96:b0:69e:88f3:14ac with SMTP id 006d021491bc7-69eda882e3cmr2414315eaf.18.1781293070450;
        Fri, 12 Jun 2026 12:37:50 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4426b278b13sm2579659fac.12.2026.06.12.12.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 12:37:49 -0700 (PDT)
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
	kernel-team@meta.com,
	nphamcs@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org
Subject: [RFC PATCH v2 5/7] mm, swap: add debugfs counters for vswap
Date: Fri, 12 Jun 2026 12:37:36 -0700
Message-ID: <20260612193738.2183968-6-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612193738.2183968-1-nphamcs@gmail.com>
References: <20260612193738.2183968-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 60D9FC0008
X-Stat-Signature: rarat93d45x4trj755r7dh9cqob7mstd
X-HE-Tag: 1781293071-92853
X-HE-Meta: U2FsdGVkX1+V97vVIoi6KVtghsSt73tGHx4SCOh/Z6/Ab5vwWr6pmtu3VQVNYLNRizMHkGS8E7yozy1gdmILav4Fecwf0XzGlaKtP2OcvVBw5AjFc7fIOXF5MYbQagSTGbgLnQNH1Jcf3AzuGvrXSGhS1iIgCBTun6WMmE2HCXre9Zkbac4+m0JHrrT8wCtbqc2T28VN4QawNqfmoXCKqKV4DI5nsEai2sS/T/buUde4AuJzX8Ts0aJaLkgnzR9XqFjPnz1+X6C5m0wjQe0LzZdlE1QpOtCO0pMX99xYeBJhvsKTVBzp1TuSow4EX4GoonFRJ8gaKDWjrrnTBKGSZhBGLxtKFhEEZIIcdSS4QkTpBU/LwCIMs1r60XlgJjCxqI0JpEOjebkxo4ehOzqFi5a6TSNd9pXq2tJB8sY2jzXUzTHIKZFyauqb3Hf5LaNQaoj4o4qFpr29LENcfphRt7bXzsojnbuUdAA59WuT5tMyQjaHoElO04pQJ7WnkaEi1c3TiIKqVVUXodWKs7hEYc/QIqIdkSdPRun7MaoEdmmhHEFI0eGCZU5IeuLQBe3gN68szvZxXNnQNuJakaClA6sB2/zKh5BJ99TxgWCSCKbH7kmizxfGCkIzQ6Pxr7UGgshql/tejJ4xbFvmMxsvhN3SA4eASysv7d7RuEPsjbRNFwkEbddNIXug1sl+WCGTvUQC4z/s/UsYWb5sh8rbTM821wWsuPTc4Xw/H81DSBz7GmBZ6soWqtA5fMN7p2LcQjgq45AADUOn49kOyWxCr3enC/it2mYtd8PR4el/Ngx6JwgK2vHYmycqOD/0jj4q25ymb2s33vwZjzWVdpSWxq4RG9brvtH973T/ZrTaPFtbOBkrd8svSE8EEp46Yg03djWja8vyVAFf0bEEkmq1kRvE8dQLtfYqCm8cp1YG+J11I9IYYP0uN6NULTIN8q0AdW1nOcYtdH+eU95BKLN
 PPE9Iz9M
 px2nYACgzNa2Hzh1fkRYxp7cOToFopVOmmc8SxERwcYEdgTyAW9nOm3CFkyerhvm+zUTXDAXaqIT19vPM2e9wWiqcIMIiTEs2zQQS8kKuzrddc7EWqTktjEjkSqLXvFIrJqDxesMXHjGlksJaB8ueJLQoQA8IOGy1IZ8Ly+1q2LgX9QBg3cFMfQoO1zr6PfI6w4HqVAX2V7Mr65s25sYTOMjP5hU7LBfsYlp72Vn1oEdAnDBYX2Nrb41yqAz5fpJU0RMT29l5Z3GcTuT1sRdNdh+XIvk4GluVlVkrM95aEpzXkyv7cbPjyD9cKBygCxosnnSpQQgyREItF019Ns8d1WixbTZ+45MKgIKscCh500DwIayI8CZfrkcHg61Cvz8xcy5qjN7uuj79Yj6YzJFspkMsxOG6L7uWSQGkEcP3XU2rqAtwB2c7WX58Cs166xKthZ7T48P4kbAGl1Qmnpx6LDH0iItvqjkmumBBs+4YUHCosyS7CtoCPjUcTVxZTVO0MLF3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add /sys/kernel/debug/vswap/ with two counters:

* used: number of virtual swap slots currently allocated
* alloc_reject: cumulative count of failed vswap allocations

Signed-off-by: Nhat Pham <nphamcs@gmail.com>
---
 mm/swapfile.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index abf6414c01c9..afb118ab8179 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -132,6 +133,9 @@ static DEFINE_PER_CPU(struct percpu_swap_cluster, percpu_swap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_t __maybe_unused vswap_used = ATOMIC_INIT(0);
+static atomic_t __maybe_unused vswap_alloc_reject = ATOMIC_INIT(0);
+
 #ifdef CONFIG_VSWAP
 struct percpu_vswap_cluster {
 	unsigned long offset[SWAP_NR_ORDERS];
@@ -2038,11 +2042,13 @@ static bool vswap_alloc(struct folio *folio)
 	if (folio_test_swapcache(folio)) {
 		/* alloc_swap_scan_cluster updated percpu offset already */
 		local_unlock(&percpu_vswap_cluster.lock);
+		atomic_add(folio_nr_pages(folio), &vswap_used);
 		return true;
 	}
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 #endif
@@ -2666,8 +2672,10 @@ void __swap_cluster_free_entries(struct swap_info_struct *si,
 
 	VM_WARN_ON(ci->count < nr_pages);
 
-	if (is_vswap)
+	if (is_vswap) {
 		__vswap_release_backing(ci, ci_start, nr_pages);
+		atomic_sub(nr_pages, &vswap_used);
+	}
 
 	ci->count -= nr_pages;
 	do {
@@ -4849,6 +4857,7 @@ struct swap_info_struct *vswap_si;
 static int __init vswap_init(void)
 {
 	struct swap_info_struct *si;
+	struct dentry *root;
 	unsigned long maxpages;
 	int err;
 
@@ -4878,6 +4887,11 @@ static int __init vswap_init(void)
 	mutex_unlock(&swapon_mutex);
 
 	vswap_si = si;
+
+	root = debugfs_create_dir("vswap", NULL);
+	debugfs_create_atomic_t("used", 0444, root, &vswap_used);
+	debugfs_create_atomic_t("alloc_reject", 0444, root, &vswap_alloc_reject);
+
 	pr_info("vswap: created virtual swap device (%lu pages)\n", maxpages);
 	return 0;
 
-- 
2.53.0-Meta


