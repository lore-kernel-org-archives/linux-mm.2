Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 400D1C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05F96B0098; Sun, 22 Feb 2026 03:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B9316B0099; Sun, 22 Feb 2026 03:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8261B6B009B; Sun, 22 Feb 2026 03:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C4456B0098
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28B0113B45B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:28 +0000 (UTC)
X-FDA: 84471468816.24.D92C753
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5A717180007
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:26 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d1v3S4eY;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750166; a=rsa-sha256;
	cv=none;
	b=6Wr2xcY+ait7raKKWTFXbmY+BBQ2cMUEc6w7wpKaXIKtOy2Xu5TH79Le7XbiB4kUPbITw3
	K0GshYT7dT4fUu66kY+/noRDCjqY6bP+jhTjoHj5s87ududZGexyB+sIPX4j5dTx4WpHAk
	uUaMltlBohlo04cxaSay2AM5WPp9nCU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=d1v3S4eY;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qbh2YPrN1iAkzOE6jhFX+vkJxP+0+A7nSYJL8bBT1Dg=;
	b=vmR/X4W35zKREW4pENH88Sku6CLtGvzniv4Dc+aC0foalyOfLwOOoIQqJhluxq55xzmY7K
	O7zjLCAHkMBNiSHEcVb/lR29eUXx9kSPdLVZKaThQ7E+ZYZd8Yv2G8mIjkUsiQMLB5Tn9I
	93wsLGdz9XpBumqfaHvWwZ6Rj+TaGnQ=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a321cc53so38880551cf.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750165; x=1772354965; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qbh2YPrN1iAkzOE6jhFX+vkJxP+0+A7nSYJL8bBT1Dg=;
        b=d1v3S4eY1KSOma1Jps9fI1W4ykQtpjTTx28uH6aVv1JS3cLg9qEyEbJ1JfytwaC4wR
         uyKb7PWJiPO0ZHNbFCJqSmPEWCOEYY4/dF262MTBhkAm/p/Y6w//fF3o6QSJjjacsKP8
         g+8QfKHIyUC6yBx/NzyJf6KbmZLUcWl3B+DvzpO8HNsBK/PGyW7AeWLXiNaE2162lKkE
         SiMpSkG3ffjWKezz0f/XJHaSbhcFewDdXymTcwiOfEETjy6J0sZ9lkvbKjyVgm6XSmG3
         G3gVhDqRhPe+PVg2C/0je2K3cKJJcrdwNMrE929Ec3pPMdX2pbrvb+Adi2JjxJFY5unO
         c96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750165; x=1772354965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Qbh2YPrN1iAkzOE6jhFX+vkJxP+0+A7nSYJL8bBT1Dg=;
        b=Bt7FlXZ+mr1pOIk2k/TUdhEmqmP0xMqtflYB8dhJ5YF4jM/shSYL+UQwZ/O6dqYmmD
         EbOiruEqAgN7HZCmE1w+g+qHsiTrb4MClKdmfTEo+Mtgxk4Czn+SIm2e3PUDmzxxKFhU
         3s62NEIDWvX4uHRjnR9m94SUCOTkRKrjspxnr8kIeVvXzP147V+cTgBaURR+G94v8kb8
         q5kqYWIpmhujejgLXj4wizvqVEdyNCvgHcJAC8meDtmc2OO9N572uoteWwGwA+tItnqJ
         40xSshN+2aAmFnqWjpSJDWpyzZrHzqmLmu91dhEgxOD8Jfg7VM0rc8hcHuqtiJ3/xA7j
         AXiA==
X-Forwarded-Encrypted: i=1; AJvYcCV6J1oWiwvJ/2JfSpoPaKHZPiIhqdTB11myYxm3GcI/IlOZ8jE09t/iyoJNg9WfP8mVI2LFONUcKA==@kvack.org
X-Gm-Message-State: AOJu0Yzab5hVy2AvpFT4Kc8LTBomuPuA9icZP9R4bWs46OeD3tct95TP
	PBz9g5jr1xKJ1gc2wZYvkTDcXQmudpGwtsqzHQeWuv0lui/7cQGFitPVto0uMPe7K7w=
X-Gm-Gg: AZuq6aIHO0p2rNT2Sx+YDkcvt86B/2Wrm+NMVZ4cckBkFigpYtfukB8lLeMinp1hd7q
	jIbFtcKmz3h9uxgvTb8xds3nObwkJ6ThheZFPHjQzV9R9fiEWuH1y3Pz3tCkGOnoHZVumLFRsYg
	Ww+yU/aYXbfR1HsSBHnhUjCxvBtJ9QRWdBdanitAerZynFp5XXRpOnHnzG03m2Hj+bT+ofypJXl
	YN7saQWewimraiLUmFNQlM6hwHonaF1Zs2naH0drpiEzlAuKkNfckfBsbLsLhxTX4dhpyiPGeJp
	pTuIghK432zyMCRYCXWWNPowQmeZVALwSSZD0D3JQMaIRdThAn5h1q4D02OiUjk6K8j2dWgK6Gn
	09k/CSqfts0Fvj2YSIkg9BtYHrcPHJYKTyFSCI2QpWV5cwAyyh/U1Od2CPBqFZX1EsFMBrl5/7b
	y6K2koc7M4BF+EgCJG6MbSAVpCkH6N7TlALRhUUu5iZ1qz1m6mBjiBMPUr5NiUhwNLsaPzIAyfe
	kE4nfQ8vaZiUgQ=
X-Received: by 2002:ac8:5816:0:b0:506:9b96:6280 with SMTP id d75a77b69052e-5070bbe5967mr70651841cf.21.1771750165415;
        Sun, 22 Feb 2026 00:49:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:25 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 08/27] mm/ksm: skip KSM for managed-memory folios
Date: Sun, 22 Feb 2026 03:48:23 -0500
Message-ID: <20260222084842.1824063-9-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5A717180007
X-Stat-Signature: r9zidsdesyfuq6uwk8mbzbdt4i4r1qmo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771750166-493342
X-HE-Meta: U2FsdGVkX18yArxCt1AXga5yqVtghwMqV3cPj2WmTKcCIrbZLu2iZwGtcG/2UpVpN0tPAJIE7av0sku7GHkI5Z/jKKS+0wHjE0OuT9dizwr2huIu58Tzvoiq7eQE/XHMaYX7zRrfiYFru4SCByJClgqRwKjnbyFd/WfgjZnQHyyyIf+MvsoGGJcnNvc45ydNfXO24ZE+Dl49vwDRuJvXX1Nrlg0WYZtgN0XYQ3vJjZFH94VsIWoKPOE9LoIKVkEzujo4nRL69BSwjfzIdfyGJC5ge11CdIqnGwZuMjv9bDdn6dFvdV88FUneReaiEKM0BJpH8IF/qqSDglm2HWkT1WpHpmzbFaZhUbWHFW6krBVGq5FxolY9gNQMCQWejDwLTyNcv9KEoE76O5V9qqmmVSOdY444qa0WqUGGIWXJpgMFdOcknC0CgLQfegul0OlUATrs1qqWnNNlvDdysRuQ9TcE2fliBCKyo2kuezIOcYrDAd7auUmPz6H5mtNb3H/Pd1I7DgN5LzuUIZD7gwzt9LmoLbAejsYSh5Vht6NvNtAy3M+Q29eyL7m0wG/+wJbEmZ/8aYHrqfwlzsthmFqRD7RsHvFAGnxlDtz2hhM76fzcEhtiuTfUHl0C7OlNBsIe0bR33k/W99unJHPVwichKEUgjmykpCnSyWjcViKKvdXrS+MQCoCw0U8jXrd6VJbwrQjEmQoslTAsXaXr9htk9eIoZi+sbBZS8Exm76m5axxyRbc4Nz/yb8vP2X54LS3cIL+EzAdtFOFp2F5OUTu6EM/+KbdrX6gIcp8hYfGmfCMKz/gDx5TPSgko2lP4JDaoqz3MrbkyIJCmaYTeNA/ZQw9PT6MEGcLd9My6dDuwxldEKqtmK1xz+IyAxpmKCifPircktorcc6bMKQMdOQUUNaT1vApTvRO38ANZ5dho/XvLVODN78tzZrFhDrFuHeCwQpz/2jn7+SoOI3gbIUs
 OI+er42j
 7NyNRk17EPehG+q1eZAbgiOma1lsXv3J9osKmJA2FA+g41BBf9IafS/E9xK15I5BGH0FKO28iaGkhVpSFhLtd7VNOn0aVC8QzS/Q6SAXkf+eLOrwcaFP3Oe7WTfKj+0MrV5E2FoMsywL/3QTt6kO+UGfRfbmXcqE8Eg2/ijUAKwenvgNlcxN9EorOxKn0/0LVUBG6uMwFc4aKHJ3utfY5mKttwf3xTM+U2oWbBkqLuTsnmNX8WQaXDxn0ErktphBMukuH+TpjCVahfk/ZlVrkB3nhKn+e+EYBT/k2CIga4rYIU7s9fScUDumrxBNlQFHbfS9+/TgoRNaM0sJfLjaA2fRv2CW7NSxDgOe6HqtNBKi1xM+WtjdYkX5N/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private node folios should not participate in KSM merging by default.
The driver manages the memory lifecycle and KSM's page sharing can
interfere with driver operations.

Extend the existing zone_device checks in get_mergeable_page and
ksm_next_page_pmd_entry to cover private node folios as well.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/ksm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 2d89a7c8b4eb..c48e95a6fff9 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -40,6 +40,7 @@
 #include <linux/oom.h>
 #include <linux/numa.h>
 #include <linux/pagewalk.h>
+#include <linux/node_private.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -808,7 +809,7 @@ static struct page *get_mergeable_page(struct ksm_rmap_item *rmap_item)
 
 	folio = folio_walk_start(&fw, vma, addr, 0);
 	if (folio) {
-		if (!folio_is_zone_device(folio) &&
+		if (!folio_is_private_managed(folio) &&
 		    folio_test_anon(folio)) {
 			folio_get(folio);
 			page = fw.page;
@@ -2521,7 +2522,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 				goto not_found_unlock;
 			folio = page_folio(page);
 
-			if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+			if (unlikely(folio_is_private_managed(folio)) ||
+			    !folio_test_anon(folio))
 				goto not_found_unlock;
 
 			page += ((addr & (PMD_SIZE - 1)) >> PAGE_SHIFT);
@@ -2545,7 +2547,8 @@ static int ksm_next_page_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned lon
 			continue;
 		folio = page_folio(page);
 
-		if (folio_is_zone_device(folio) || !folio_test_anon(folio))
+		if (unlikely(folio_is_private_managed(folio)) ||
+		    !folio_test_anon(folio))
 			continue;
 		goto found_unlock;
 	}
-- 
2.53.0


