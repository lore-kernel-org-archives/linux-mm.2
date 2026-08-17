Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1093AC5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF1DC6B00AD; Mon, 17 Aug 2026 06:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA0E6B00B1; Mon, 17 Aug 2026 06:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05666B00B2; Mon, 17 Aug 2026 06:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE50D6B00AD
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:38:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52E05C0721
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:38:46 +0000 (UTC)
X-FDA: 85110413052.03.589DFEC
Received: from mta1.migadu.com (out-159.mta1.migadu.com [95.215.58.159])
	by imf09.hostedemail.com (Postfix) with ESMTP id 62CAA140008
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:38:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lpd/3j+C";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786963124;
	b=ENJ6zWlTROCuE+cGCyIwmjYWfKE0OM+P8+sXjPxXrh+6UzX/wyoTyvbtJK516fqrlr41WE
	rb9dYDzSDdf7q9gBnxPA/4xwkoeoxOSaZSbVTlRfZrH9sC3VbYIQX3/aIRuY1Flg2COOHt
	fdlFvfiIIVMFyM04eBuyJIH2gcc0Hqw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lpd/3j+C";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.159 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786963124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qjeecpp28APz10g9vEqjjPWbvZxb2K6RQx8ovK2LLeU=;
	b=VPC5THhiggx2x1eHXUL6v53tEIcrxgA1PM8879y27GuOKMsUyyhJPPOuxXu/WzxXg3I+j/
	CqnhWEegOvmn8a/JT9Dt7f98HZQ4zpyCw0a9Y4R5C1cpBv8nw2quOyzK/2J5SDKmQZtmv8
	x5ij+B9J5V1GnYb/V9/Z7XV+eur2J0Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=16wS0vaFpZB02cSosiEXtjgYZz176GFSDjHs0guh5kA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786963122; v=1; x=1787567922;
 b=lpd/3j+CKFZSIrHQ2wXf/5tK9INfQC8afXAXzF7N/PZkcVwDykX0RxZp43l3VnXcuRO/1rTS
 yUHA6KvUy+rqWgCRN4cu6QzffYP7MD0t42fXiZ1EgzJJ3syV1QFRPl7KbbLECdHBJRCR1U/Hjwf
 CShAzZpZCvZjz2koM3+v7ilk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:6::)
	by mta11.migadu.com with ESMTPS id ef52f60d09db3a3c;
	Mon, 17 Aug 2026 10:38:42 +0000
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: shakeel.butt@linux.dev,
	cgroups@vger.kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	mhocko@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org
Cc: kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	kernel test robot <yi1.lai@intel.com>
Subject: [PATCH] mm/memcontrol: avoid false sharing between vmstats and events
Date: Mon, 17 Aug 2026 03:38:35 -0700
Message-ID: <20260817103835.2937733-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62CAA140008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: inxedxsd7qorrwqpqy36mkmg5p6r1gyy
X-HE-Tag: 1786963124-436454
X-HE-Meta: U2FsdGVkX18cGpPzKMgg8i/9bN8zozuAjBVkckMAiVdFdk/F20iQZmVZeq867+Dx1o8gkXTvcLpopVq/XPBgzbOyZLzVJXa1Wgi8ZMmz0tyfgFs13pEoeKinSKeEVL+XsI9kg0tfJ8sVlCPAECRKP/MsP9wAMiOL+TFnn1/hahvuAvEc8GiLSPXSkWTy/UoWr6EhY97m2equ/F5U3NlRddz/JPe1sINMayG+A1z9N5NXUZgy/kHIGh3+JjxokgpJRfspEKwOZI4zKPEagNbiGuhW/7GzTQT3jg+5ialUbJMQYYlcxeP4UMNt0LpQy1i0dSQP3zCXJno6sbVNCUzhn7oKeNNV9+QKHGkIg94xYunVjPO0bkXDA8NvQuaI7lkFUlnsiK3eNDAvTB6YWMkzYEjx4WlrO5r4irNh3mjjWY3ZoCyKAR6inVjtmrJEI0OcqV3JiHScm6xjXeWxD4pYhH9G3eMattWHr9sGoYE+2u+kHHHD93/Sop1VUZLXcJW8WTiVEb/BA+/+f2hC84RaoWwe0I9NKgOdnbjY1aSWm8vyfJ83PPa5b5DCF8Mo3CHYXwJYsktb+Gzw56rW/+UpPMWDNyOk0O/gEBgvUhbcI1jGwhni8tUFjVkCFJI2yfTLxrYIk5BZyHOmOgjFqruzIW5m+HIAUEam8RvkmJ/N+u0C7ZLXtGZ9oEXuP3/t4dUG7/VJ3pBpDxPbBybay0b/XPf34zplRYoSt+ithHVTMfCoxTWSflnKzkJ93EOJAX3gqD9Y5oTCZ7GX/e0vSq1T10LUwoXsO4RLDuvvinfmcoiQHDvICxuuRjdpghAqCpFYxeYyxblpme5LBzU9718IiE9WL09wq2zq2AXM+ZmlKGlJ5xiOJkAd6PQzIaz+Ww/Ax8039Wy/r/qQZTF0BWj7ESZtE4PTGUus0oYs08cTWRs8EAhYBvoI14+xKaGl4sHMcHP2TZLlyDMtsdzqgGs
 RRsVDh2G
 UgqBy6ny1T6iP8e7wCIsbfbI8B/qaaHjl7YjBWqMt2ysenVedaBFCU4ZlR4bVrhFN//WMSs/ETTLAR6F+wQPVFxLJCT1/6WD7RNLfXsEWgb5jq+R5uPnBv5+AjZ2lTUvmHXBUpjeSQmqaGWBUe4iBUQBd/v6uPVUNQvsVWnEAkTi6NgVV1qnRK8T4d3HU7HpvMENTUnWFfZPee599di5H0hYj/4FJ0hxFcg2qokhyBpamV5TYpiPPdMehQSciPyTLrvxvXHbXuttyJ2fIPrju9KuZ9XMuWhoKLV8OTbx9b7Kxexhknl5pSIoA3SCc+lL1aM+K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Moving v1 userspace eventfd handling into memcontrol-v1.c shrank
struct vmpressure from 112 to 24 bytes when CONFIG_MEMCG_V1 is disabled.
This moved memory_events_local[MEMCG_SWAP_FAIL] and the hot
vmstats_percpu pointer onto the same cacheline.

The stress-ng mremap stressor exercises MADV_PAGEOUT with swap
disabled, generating about 20 million MEMCG_SWAP_FAIL updates per
60-second run on a 176-CPU test system.  Those writes bounce the line
while memcg statistics paths load vmstats_percpu.

Move cgwb_list into the existing alignment gap and cacheline-align
vmstats_percpu.  This separates the pointer from the event counters
without increasing the size of struct mem_cgroup in the tested
configuration.

The blamed commit reduced median mremap throughput by 4.38% on the
test system with one socket. The patched kernel brings the performance
to within 0.5% of the parent which is within the observed boot-to-boot
spread (up to 1.2%).

Fixes: ea928e9e18da ("mm/vmpressure: move v1 userspace eventfd code into memcontrol-v1.c")
Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202608131743.c6a7dda4-lkp@intel.com
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/memcontrol.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e78bc98ab229b..215e2e87f42b2 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -268,10 +268,15 @@ struct mem_cgroup {
 #endif
 	int kmemcg_id;
 
-	struct memcg_vmstats_percpu __percpu *vmstats_percpu;
-
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct list_head cgwb_list;
+#endif
+
+	/* Keep the hot per-CPU stats pointer away from memory event counters. */
+	struct memcg_vmstats_percpu __percpu *vmstats_percpu
+		____cacheline_aligned_in_smp;
+
+#ifdef CONFIG_CGROUP_WRITEBACK
 	struct wb_domain cgwb_domain;
 	struct memcg_cgwb_frn cgwb_frn[MEMCG_CGWB_FRN_CNT];
 #endif
-- 
2.53.0-Meta


