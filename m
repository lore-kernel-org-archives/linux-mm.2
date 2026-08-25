Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAB03C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 15:33:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE606B00A0; Tue, 25 Aug 2026 11:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76EB46B00A1; Tue, 25 Aug 2026 11:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D636B00A2; Tue, 25 Aug 2026 11:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C63A6B00A0
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:32:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8063F140468
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:58 +0000 (UTC)
X-FDA: 85140184836.04.C063083
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id AAD1840013
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 15:32:56 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=opdSae17;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787671976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRVrRpujJcoHdsF0W6IfC5VyfQfzFj4+BdlWYD2xQfM=;
	b=2fO8S8tjqP6MqJ3JfHSDmgqgM3oLxPsfbzdLKeMlJpkyIDwRw3anmtqdTB6/e+ZYwzweXQ
	kgcWpTVX0r89SfbrphrD3GdKPEYztCAMC9TvMhJKbPEgY3uCl0O9dsUS6TM7XdkLORF3Ps
	gW1cRoyZ32Tq4fk8XYq2H3tYOJqHyUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787671976;
	b=vj06MzP2IvYEvP96qfu9vMyllpp9Lco7GnnJIGAKd3IG5yxIU8zHuXPNBnWyTqQX6V9mOx
	hPPROjEbaq1BNUXD+/f7ZrZrt4yomAeDCqnOWl0yCBmxu2qNy2zxaZzPDCkyze+xVfoB8g
	n/off3bt5EMl4XDF361bZnJqTIg9wTw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=opdSae17;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-448b0ff4a57so6741819fac.2
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787671976; x=1788276776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rRVrRpujJcoHdsF0W6IfC5VyfQfzFj4+BdlWYD2xQfM=;
        b=opdSae17d+yrh4euHnJ3CssTuzkK7wNZpX+CBlc386hQ6L5ff6v7DZCe4EAXYdPNxK
         T7q/w9dbDsEpprnb+q38rMzGAcSSTTiY5BW+NQnLN6aSd2dQ6zJEEOO1WSMeW3ex6tIy
         225/9QW1jokutL/x3Zboycd864+cA9A8JX38AvpHrsMiqrJFfAM9wpWU7j1bN2AJ2u/7
         ha5cEl86DT2KxPcAxYh9U9ii75rTdlKiaGnmAZZALu0jr0TIcXtKGzGu62hqHHLoIwKF
         kBCJDzed9KLxUMBGen7Dni63lD6reoMaW9ZfRjAZNKMfZW89/XUOE2vSjMNqmNBXOVFK
         2evw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787671976; x=1788276776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rRVrRpujJcoHdsF0W6IfC5VyfQfzFj4+BdlWYD2xQfM=;
        b=lmIrpi7O8mghwrVU1CBk9XFw1Pzgw3WDYIhf+8iMnGM3txX2ovTzes2hGdPDDFEqnh
         uEeUBO37ZYn51H276T0Xyn6HpK/RnBpXwLToJNHwNO3leHUcOmqyaOWHAfe+WqQ3q6A+
         8zzaBwytWAFdb5bp6Bw2LnHtMTE4zxt6pCzPAMux8mz/QP7RdKUMX8jg1mDsjQI6Vix/
         0ReaxUPF1ZnOj0NRbf4q0o0rlFrvIsDty6FtH5QJJX0RLfiZfkXImDX8IQ1PxM8PPSf0
         4z5TUT4+tsCanTkjI4l/h36uQAJ4MyKnuq9/ubfSGXJIFS9MSZq/pf7QTL1PIBeuJNoG
         L3vg==
X-Forwarded-Encrypted: i=1; AHgh+RrfS5iZt3xR1uEhUPdN/ZAtEkkuCcCcDfCkwa388s7M4SsGsgGgqN1YQvlPZxilUu0D1O+DSmeCOQ==@kvack.org
X-Gm-Message-State: AFuF++kE8JfJJBFJW0vfW8VFDFTi8psy66PR+I1EwXZ8iW92+cQ3uklU
	EaCyNKeRE8P5e6jhVfaLV0NdGzb2MVE1CDE7jPav66xuT1SWTUJnfO94
X-Gm-Gg: AR+sD129uOxXzl5aOMjtqBLWnsrgCGpuamuOfSdKO2d8xrjNQ9VXndc/wSpILqK2JDr
	KanEl6JyobNXd4n1NAvv5aE7m4oZinjPHZzxBp49rorGWdnY1FHIo+FqcfSuM5pBRrjidVrjpef
	s4Kukw1dO82NxgpvsEoBZD9ltvchWvG1U1Gzuo/teGn4cWgdKL8fYP9rUxihx7VUqzIoeGCZRA1
	71nPgong788Mh1DyDBxSCF3n1Uj+lqRT7hKLZrsSYIzaJHfsMBUC1K47PlB5E3heoApXkK/jjjs
	a37PfpBr6JMYJhrA0eaU+0hWllmco+QFL0bNpAn5HWphXmHD/5WYasiu3+v5CICV93VJsId8bm6
	Ko4zDUAsXwxXMtsYjmRrKbjKHzrlzdXPNzklR5A0pJ/mGma59b+5irSrLVsA3htMYrFOHfbCrGN
	GBX3ByRvSNfeb0vZ8sdJD+YlTf05jqMi9Nc6bFQE0lETpqNRhcp7zz/0BWz8+EKF/nQslx49sQG
	naYUaKapmWopf+Pzrq2Ww==
X-Received: by 2002:a05:6820:8106:b0:6ae:5250:dd1c with SMTP id 006d021491bc7-6b1904fd029mr6471337eaf.29.1787671975541;
        Tue, 25 Aug 2026 08:32:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4638353a37asm7759186fac.15.2026.08.25.08.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 08:32:54 -0700 (PDT)
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
Subject: [PATCH v4 09/11] mm, swap: add debugfs counters for vswap
Date: Tue, 25 Aug 2026 08:32:35 -0700
Message-ID: <20260825153238.2695446-10-nphamcs@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AAD1840013
X-Stat-Signature: dohhic5p3w5t39858mgqr4cwphippfye
X-HE-Tag: 1787671976-25872
X-HE-Meta: U2FsdGVkX1/iC4WujOxNPR7dW1/TGN/SDZUIxbG/4OX7N8iOk59HV5MVJjoyf/UMYK4T5FR5VSIWXO7P8uhkvZZMPWgOox3Q982qr96++Z3rxrUzxxNvssYgKNSFTycLdAEiV2Hsu5JSB+bsoOvrA1A/qfPrdS7JCkGltb84xTk+eRZonRZn8k2q0feHNIjoM/Cuo7gBpFADkPvWhdps5OOpNaOJFRETwfmGeO1otyRFUiHYz0y7oF08J0lJSdsFcwB1jw4er2zPBclxgMLsQJPyyeRs72UDItRoE1CxgFiLGTcoPSHlwVcxL+TtuJ1jcsuR+ckXvkqe8RLuaJbb+cj2jGrT8xIZu7hA9QbmRyrb6V81AzJaWcVfI0BspdJE7qwrd5pmYad7o0Xjg9u30kZER+A8WTKGEcAdYwjYz1xtTUK64sv4leqMLVU1ngoCMCyWDfxlV9+EdwQJkwZ86hxpEPY00YO5kvc21iWwnlwS4Zshi2QRL6l3L2A8SF/NV5ySRGxf7i1A2JF2YGR5BAZTqo8UZhG7tvznHZ34gk1kwceR6r51J2CgAiUgkTFfChah7Kdprx8ZHUU5qLt98KSf4SQHiyYb0k7Dohaea2Dveg2QsSJkJAvP5C02FxKMQ2STN6f1nvGNyFnjQaUf8uF2yWiE1Ymw9v1K5dJ7umKmcv3Vb/J2SUeRKpOTewOrM9YLcA1ufqEmX8VT4P3rzqIsYueH2YrpbGMJfshU9MsKhdnoDmwUr8atNPrY2fxxqIbF1CvJ6dEL32ymwxIFWmAA+NScK7r/6J9AszletVTZXCjy5fDylmYbKT4oxzrhWK4U/gnmVjUtsv67DRkV9MDVQYfcotdjR8xpLg365xuKv3sI12/fd8tWNp6nU5eTjHoK9KZN2IhChWDupHhJTN1PtLm82ibgGctmDnrVru6K59OIz4MbU4XTWHW3QBBRd3PW7BW+91DlkZtuabB
 xxBAu6fz
 GVXs7N929790RnoVnSf/NgobwgdaKfAFBZDDWxDlhPwE4rtKSUQBaJx0W4fbAIVHgsTszSwcW8lDwGDHZG9ajumcuFr5HJO268cZvgAUsnIVPctWqwoLguCIkORGjAjBcr47ZtfU1KzmTyEFzxmiPaxQYgL89Ef67AM8NgbGw8keIEhn7iXWtrK2PPAdMCWjtWMiZhPn24RuORBAQqoMaS5g6zARS2Jc8Py1p4RMe5a8KZIZMKjeRJ9VUq8b+SWcC/Hg3nUvdmlPI3gQJT/V/XqdQ4CN7b93S7KIru1N0Ox3A/K92pRwnchE9i4mPyWsoakAIb2Jx1/Hip+xDfGwGeUScF+ItZ35tnrGuAwsLJSkf5N7/8nTJ0Bavi0F82ZAX9mM6eeKjOqo8ljFPgaMUjUPawdyuttxHsK/3q86bZiqo38UIhMSShdNmHqNkR+VE+d072oyQhskpOv3X2W6HjuqWXCUPgTgf/Ggetq7F38WDT95iE4ieGfHlkVar3z4GeqUB
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
 mm/swapfile.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 517fa58f8022..3b10173cddc3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/blkdev.h>
+#include <linux/debugfs.h>
 #include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/sched/task.h>
@@ -142,6 +143,8 @@ static DEFINE_PER_CPU(struct percpu_vswap_cluster, percpu_vswap_cluster) = {
 	.lock = INIT_LOCAL_LOCK(),
 };
 
+static atomic_long_t vswap_alloc_reject = ATOMIC_LONG_INIT(0);
+
 static bool vswap_alloc(struct folio *folio);
 static void vswap_mark_cache_only(struct swap_cluster_info *ci,
 				  unsigned int ci_off);
@@ -1983,6 +1986,7 @@ static bool vswap_alloc(struct folio *folio)
 
 	this_cpu_write(percpu_vswap_cluster.offset[order], SWAP_ENTRY_INVALID);
 	local_unlock(&percpu_vswap_cluster.lock);
+	atomic_long_add(folio_nr_pages(folio), &vswap_alloc_reject);
 	return false;
 }
 
@@ -4795,9 +4799,25 @@ early_param("vswap", early_vswap);
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
 
@@ -4841,6 +4861,12 @@ static int __init vswap_init(void)
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


