Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02856D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56ABE6B0005; Mon,  8 Dec 2025 04:26:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B1B6B0007; Mon,  8 Dec 2025 04:26:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4313D6B0008; Mon,  8 Dec 2025 04:26:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29D536B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:26:53 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C444DC0A49
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:26:52 +0000 (UTC)
X-FDA: 84195774264.18.370B725
Received: from chinatelecom.cn (smtph3-07.21cn.com [150.223.194.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id C97F7160015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:26:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of niuwl1@chinatelecom.cn designates 150.223.194.132 as permitted sender) smtp.mailfrom=niuwl1@chinatelecom.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765186010; a=rsa-sha256;
	cv=none;
	b=EAFJKvh1ANXulnGDyZNFPtwHC8TVzFb9kGsjb626x8Efc+q9i6m5iKic502/IPdnbDihVE
	dH1qHRSdSpqsywG9/eXkX/Pcvwj+6Nfd1+Yok9xfusPmHimYugzFLUeEzm3BqpN08l//Kx
	25/gPr2s3kv4cXTPFnikipSQDNDD7rg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765186010;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=22ntr+OdjuxsCcSt2jkreI+uZfeTpqsrVduKLUrYOHM=;
	b=QLgzmvlbc0mDp+GpZunlw7uT9TA+TUR0JdIs8mpdHebIED8uX5ai9hIg1WFm5n7JVkOCzJ
	gSHR8XaYh5x8enCV/nZaxOuZthA6SVayUhxIG9owhShQfIXYI30t42XKQx6wGJH14YKYwb
	edQxQaK204BiCULymV/la8WKg6Cp+iM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of niuwl1@chinatelecom.cn designates 150.223.194.132 as permitted sender) smtp.mailfrom=niuwl1@chinatelecom.cn;
	dmarc=none
HMM_SOURCE_IP:172.27.0.98:0.584789079
HMM_ATTACHE_NUM:0000
HMM_SOURCE_TYPE:SMTP
Received: from clientip-101.227.46.167 (unknown [172.27.0.98])
	by chinatelecom.cn (HERMES) with SMTP id 611A9155000;
	Mon,  8 Dec 2025 17:26:35 +0800 (CST)
X-189-SAVE-TO-SEND: +niuwl1@chinatelecom.cn
Received: from  ([101.227.46.167])
	by gateway-ssl-dep-55bdcd6d8-9n4lz with ESMTP id dfdb5f6b9a3f412a93f2afe8bc1bb503 for dennis@kernel.org;
	Mon, 08 Dec 2025 17:26:46 CST
X-Transaction-ID: dfdb5f6b9a3f412a93f2afe8bc1bb503
X-Real-From: niuwl1@chinatelecom.cn
X-Receive-IP: 101.227.46.167
X-MEDUSA-Status: 0
From: WanLi Niu <niuwl1@chinatelecom.cn>
To: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	WanLi Niu <niuwl1@chinatelecom.cn>,
	hlleng <a909204013@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/percpu: drop unused max_upa in pcpu_build_alloc_info()
Date: Mon,  8 Dec 2025 17:26:27 +0800
Message-Id: <20251208092627.5603-1-niuwl1@chinatelecom.cn>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C97F7160015
X-Stat-Signature: fajoi341zsfwcsk6qhx4prphjg1w1bde
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765186009-371148
X-HE-Meta: U2FsdGVkX1+Lg6QJQ2MJ5Rkrfrkz8xUOBqRp2mLnZ5GxZYMafUFeOHS4XuszcQMVo8IbiCwDaWUH/Mr1yqTja2eB9lzqEF2Ic02K7oTxnN+7gjryRHaHX/Igin9SN3g+g2UXU8Y9Af0Ys7oYhbuAbPbPYuPC5NT9w6RoS/NbTIG5QEqboiUEOa2GzRr76mj+K7s0h4fZFWAcHst7KbPLeOzRkPFJeIr7qSjGcau7TZwWq1mQAZAwhHPu6SJWLhkguSqJhV1I8U8u5Fj3KfABVrFhvtNQLXRpTHUrG/jZJr3tJ/rDT8cHbG8xCNDODNSy3Xjpxa1xfen0i+PDDM2L87va3kYgZW2BKE2Nks+SsWSiz1MLroyShhoLOsjBcnjd/E7t6GpMuKGRRCsG9p+uosJP1skKVpQWtLEdQb+6DIHbv7JalfwYnsUmoNv/TqZkOl4qhd0fK2pwtQ5/+K3WX90U+8ak80hLrfwMdPTluSZmfzM/FAx9BzOJchqhmmbRMqk5/2cixdDbvbkAoNjCE6jEKtzLP5zkaC2Wlx5N5VsUi6jFCAQbpJaARe9XQMqSuwxIj4BUZvH4gAofmQgrtnDJhjbyERCBgH82uRaJfB9BnaMIuJJRn/PH4iwdkanca6qRUyFPXsQ6YDmFziKdy9POxqEeVXKW7hqU5MQ6lXpelBWJTOOmvpi9djYTo2pHFANHrZH/XMmL0eIUnCoO1uv4Dv3/MLkbLKvVnuJHMgfXtYzSSfBTFK5YMLarmQBrwV/YpycP/YVl1+sj6eDZqg5gNiOMp4UWkbvo1u7rJAQwnmsQukGi2iV2XnCrSwnRZJKAo9ugei/qPhOLLzE409x9xiG9pzfJKjt/QhFAgz+0aBPWhdioMoR/p8XeAGeW84+NignEC6Ypw4xiJ2cQSxbHje6bWrB+1pqiZzOG4TX3dle94lN9qLq8s8odPm3eHenOQ8SH3q2NwUvAiB3
 3dLYlqLg
 jLn1zDuDWmdoJsQboSNFA1Cr5Z2RP6O0GC//iMpm7E/AlXohyeaXgbObSoi/VJz4EpSBSML6DJVSrCHwyfTTivISZD7KrO0TNj75sZaKHDSdqtCZ1QTMsC0qK/jQqTqM87TiQqlGLjf/LHu+RAPtGwrzTDSvuPG5A7/w7H5dncWzjs3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pcpu_build_alloc_info() only needs the initial upa as the starting point
for the downward search. Storing it in max_upa and reusing it adds
no value. Iterate from upa directly to remove the redundant local variable
without changing behavior, improving readability.

Signed-off-by: WanLi Niu <niuwl1@chinatelecom.cn>
Co-developed-by: hlleng <a909204013@gmail.com>
Signed-off-by: hlleng <a909204013@gmail.com>
---
 mm/percpu.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce58..966f4405f 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -2800,7 +2800,7 @@ static struct pcpu_alloc_info * __init __flatten pcpu_build_alloc_info(
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	int nr_groups = 1, nr_units = 0;
 	size_t size_sum, min_unit_size, alloc_size;
-	int upa, max_upa, best_upa;	/* units_per_alloc */
+	int upa, best_upa;	/* units_per_alloc */
 	int last_allocs, group, unit;
 	unsigned int cpu, tcpu;
 	struct pcpu_alloc_info *ai;
@@ -2817,7 +2817,7 @@ static struct pcpu_alloc_info * __init __flatten pcpu_build_alloc_info(
 	dyn_size = size_sum - static_size - reserved_size;
 
 	/*
-	 * Determine min_unit_size, alloc_size and max_upa such that
+	 * Determine min_unit_size, alloc_size such that
 	 * alloc_size is multiple of atom_size and is the smallest
 	 * which can accommodate 4k aligned segments which are equal to
 	 * or larger than min_unit_size.
@@ -2829,7 +2829,6 @@ static struct pcpu_alloc_info * __init __flatten pcpu_build_alloc_info(
 	upa = alloc_size / min_unit_size;
 	while (alloc_size % upa || (offset_in_page(alloc_size / upa)))
 		upa--;
-	max_upa = upa;
 
 	cpumask_copy(&mask, cpu_possible_mask);
 
@@ -2860,7 +2859,7 @@ static struct pcpu_alloc_info * __init __flatten pcpu_build_alloc_info(
 	 */
 	last_allocs = INT_MAX;
 	best_upa = 0;
-	for (upa = max_upa; upa; upa--) {
+	for (; upa; upa--) {
 		int allocs = 0, wasted = 0;
 
 		if (alloc_size % upa || (offset_in_page(alloc_size / upa)))
-- 
2.39.1


