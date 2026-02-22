Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B04C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446F46B00A5; Sun, 22 Feb 2026 03:49:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424E46B00A6; Sun, 22 Feb 2026 03:49:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306686B00A7; Sun, 22 Feb 2026 03:49:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1904E6B00A5
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:37 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A5778C020
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:36 +0000 (UTC)
X-FDA: 84471469152.02.C260EAC
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id C78521C0008
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b8FyXS+B;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CV1BMLJRDB150NHPYMpWTJDZSx7tUpTBtDPGS7yRISs=;
	b=sMcdW1lh+d/1a/K7rvK3mYBc/3yUiJAUYpTIrl37tK2hBiP/XR0QWB/wnJhFw6vJREA9O3
	rgaXxgHK3Pw3QPvadGf4jTm40NzFVmyAHKMKZopwcGv1h1kjh25fC0KqlATMd1QABTUw3Z
	3IC8CFf4cpzImKzYPOKOlPfWY61XhzQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=b8FyXS+B;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.172 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750174; a=rsa-sha256;
	cv=none;
	b=3UBMZ7G6ZMqfyVInp3d5wfFXa5SC+zKcXyS3ly+yxw5o0n+JitjhrIqXvjQnm5k7BNe3J+
	WoJPcJaosJRYXOnLP+F4F4vP3f5aiMRyOuKxOcQgT8o7Ez4UyywbnowOOvQYsedBTirSWZ
	I/vxvasn3cwRJwcjYXe4BvRROQg807k=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-506e287dd53so27494551cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750174; x=1772354974; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CV1BMLJRDB150NHPYMpWTJDZSx7tUpTBtDPGS7yRISs=;
        b=b8FyXS+BMjZZOTgR06CEo0IMGOKq+13eLTmgLIOpeERYyt4VGOJbw4lQLAL5X3+5ts
         3iwzZOGHvJ+0/GmHTlvv8iL/al4Y8lGZNYSOPiJTzGy4qOuRk/oFqXMsOP6GJAMfBflQ
         rHSvyaGCiKDZ3mBEwM8u8lDZ1vkUTJujHIpA7Wmu0K0kMOZTTEb3XjkMHnZjWzIR7h2N
         Ul3tIXbjgBQixyOQRVTFSMoJV5WpbbewfYcKF8om2ULvGfG8Hnkpi8h0CXqRdxZlVcSY
         rI60CrZa+SpePYuOAFdqWs7WmR7ss0bfgQaJAckTsBPu5vKFDAM6AQT/YIQ+5IaO5dIZ
         UjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750174; x=1772354974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CV1BMLJRDB150NHPYMpWTJDZSx7tUpTBtDPGS7yRISs=;
        b=Twny1mWBA9jso7Mw1sxFgYzGEb3TL3zEmPDPdPEQyVH8UfV66rg+9H0HTYst8QK+Rt
         sBC3lqEmYZgAKSVtGlvfTjhN4pLR5yLlMgbxiXjnmEDemXBeUL+CfeYubKYRPkmcAp0h
         HPtHAv9C/KJOxXPc+PETBd2lZW1Cgy3fPVIx3fGes58X5DkK1wlE0lbDhPw0A7SkE7R8
         7pT4YTyq89uvLFxY+wSU9qqsJl5GTJ+LZ6DwyzeiXcp0v8kRujtJYspnWOQR3BcmzUO0
         MJdd9cpKDdQb1Y/6syUZKTyLBJgsh1na5lhcwFf++QtPDjN1HHofLPWf0gzNB6mbTmrp
         p7zA==
X-Forwarded-Encrypted: i=1; AJvYcCVeR3aiXt6WXDPIjSNns/a3Ja+H+nWq3eZPtyisBjQP3NPVLJMEBPSoz+fqjsf5dIjm9/JUrOTjMA==@kvack.org
X-Gm-Message-State: AOJu0YzB8davNT+cwV5e8TLdcwJd4SwCzLkifJ9GEVsTXZaV1hrwv0OT
	t2SS22QtyyYtMXUSQm82PXMfEItXYid6tRW3/MPmet0cUmvb02i33FGeAjgq7mrgvtc=
X-Gm-Gg: AZuq6aJph8YJbYlD62mo9s+VcptGvufaVymKTasA1e72g92OCZ7xC0rx0/EqJLCi0B/
	yQazWmc0zldA/mBE7EKcZzqyrXZfE0YCzXoZiVJFqd+a7651EBONGBUUwLb6eRQetBBCC70mo00
	bWom1pjhUij/JmN52oTb5AyLv8eMyev2LxVNOPU9JoLZBpezbLgk4WjTOIY8aomhO+GsCwkivcK
	uzZq/pUH/ySwlKEb0qEnaPDOPda1DiNkqHAK5sxeHOVcBKCkGWprmzt17BaInhCy0XarfL6in8c
	VneqUkql5q+ZyEjU7lrSzyNi6Sp4QQMJ6kVQnQCM+hPaE//sHItqc2cIaWvLfhP1nG3GnQJUx2o
	OoeQ79qsQpLyutfi3JX0YAuklKrg3v4Co2yQcJqmAYbDENPnyOCwM+d7OXYOg5sD+fzbyfl+hIo
	U0YUzU3qPm/e2QJnuVQSkiMk7D+c369mKt0YvRchB9aro1n1H2VNd1gceegsDxwWxNdNgS9Aq7G
	DUKqMLQ35Lh3+s=
X-Received: by 2002:a05:622a:1903:b0:4ff:c884:31ad with SMTP id d75a77b69052e-5070bcb47ebmr73646721cf.53.1771750173883;
        Sun, 22 Feb 2026 00:49:33 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:33 -0800 (PST)
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
Subject: [RFC PATCH v4 10/27] mm/swap: add free_folio callback for folio release cleanup
Date: Sun, 22 Feb 2026 03:48:25 -0500
Message-ID: <20260222084842.1824063-11-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C78521C0008
X-Stat-Signature: niicex8tqu5k35g11k7nena9girg48hy
X-HE-Tag: 1771750174-529351
X-HE-Meta: U2FsdGVkX1/gkIL7cxlpkJD90NTECvc9ZoGtQ3ao3CsWueT1jLao3o1RgbVLsHZOrUsH+iL5uPrVwv9qk2GHQP37qOh8zzpghwcrxBLL0KG4XN6/Cgu+ckUpIsMT70ywl4iDn5WhCTLUIuzJu+onO4YBp1CKsVl58ao3OY5eL7mG6MfzyXuHHxtzvSc0EMrmHcBWy4d21CKFX4xgvIvlPar1mMJfT4ynW/6V2oUUZA3l5lorhq4SmNHh6XXcGdujLSt6IBD+LJlKNX1LwvONo6eGlCf2PphszOy4rQdBrU0jBseEpP25pL8n9EiBELyHkHq03mRV/VPRdsMCUH/NChD3lt852pVba9d1EtyMXE9QWE2HKug9ngCtitQg4+2s0mRgDTp9Oqz1pyZBzMgfTWWTmqVZQlE9T2QiatUqOWbXTbwSZjacVNaGjuweRp4lSpZWJpTYJm1UGLZbOjf6HUsWlELLx0sCyGeQ7iTQz9ddfrqGKaVSqi0l5FTQB2tY/f/F7PzoSgJVBs50hOLyAB8K8vuw1mU0t9EQu/PBs2e9TmTRV6di9WrbV45fYIUao3aTit7vOCjMvjncTrXSAxEt3zuJ7FFRJxubiNyM5vJ3RiA380023pq3vIPnX1Gfq4lQ0lC54o5AgOGfmrRGPj4D0ymTJXQDTMP/2fCVkopRthTEkMNxLm9eYUQqJDGkmfjG3T4QRfhyqDxslhk/wzWBKtIX9wCOByhEzDzDT2FcCJHvAvAUhm+yfB1B+NOpJh9JuXVY7dWXvVroA6F8utOMWeYOwCAYPE59tg3eida8ZXkkG7RwAHYdiyTfPZMZWbqxmZ3Wd7v7NQe+9uHFz/cJiofPt0Y1o3WbW7riOzObyHOx3k8UvPgocZmuHK91QAospcAD9+L/Ygleri2x0pu3GAp6v8svxMeSMW12kGvyNtnw8TbT4PDHQfjBcIPpUd0ARCxJiXg8nBfPJi8
 TWy5fEt6
 5PPCNORFBDdWLOCWCx7i4xBMr+jpl8OxprBLdoH94oMB6AuINszfJtiWQVjEgFWo1RAuDklNfGEsOWKR9md1bGRjrQsCuGkxpV3WwIHNbRHDBeQWOQtVSJF/mOBs9vPlja3gVPmSnt9gVGmm3eovA23eUsJr2Iu80r2J4RvdRrZqfWB3yYqns9TNaSbdiPBWqD4hh7iNLPkncCpPsfHQ7saO5cIt2yVp7BowLE6q+PUMLL86kme0ytnb04xoAhawHRLi+G9VSBah57u399GPRocszg1EXeksGSdO+XYnvuIOneXMJXHZ/uGW3NKq5U2yNMBBCRfI1vrJmhk7+/yuve2B+j/pE1auxUYAVXk/uvReCiXAsFS/Y1FkqhLy6TuhEwOE6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a folio's refcount drops to zero, the service may need to perform
cleanup before the page returns to the buddy allocator (e.g. zeroing
pages to scrub stale compressed data / release compression ratio).

Add folio_managed_on_free() to wrap both zone_device and private node
semantics for this operation since they are the same.

One difference between zone_device and private node folios:
  - private nodes may choose to either take a reference and return true
    ("handled"), or return false to return it back to the buddy.

  - zone_device returns the page to the buddy (always returns true)

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/node_private.h |  6 ++++++
 mm/internal.h                | 30 ++++++++++++++++++++++++++++++
 mm/swap.c                    | 21 ++++++++++-----------
 3 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 7687a4cf990c..09ea7c4cb13c 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -39,10 +39,16 @@ struct vm_fault;
  *   callback to prevent node_private from being freed.
  *   These callbacks MUST NOT sleep.
  *
+ * @free_folio: Called when a folio refcount drops to 0
+ *   [folio-referenced callback]
+ *   Returns: true if handled (skip return to buddy)
+ *            false if no op (return to buddy)
+ *
  * @flags: Operation exclusion flags (NP_OPS_* constants).
  *
  */
 struct node_private_ops {
+	bool (*free_folio)(struct folio *folio);
 	unsigned long flags;
 };
 
diff --git a/mm/internal.h b/mm/internal.h
index 97023748e6a9..658da41cdb8e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1412,6 +1412,36 @@ int numa_migrate_check(struct folio *folio, struct vm_fault *vmf,
 void free_zone_device_folio(struct folio *folio);
 int migrate_device_coherent_folio(struct folio *folio);
 
+/**
+ * folio_managed_on_free - Notify managed-memory service that folio
+ *                         refcount reached zero.
+ * @folio: the folio being freed
+ *
+ * Returns true if the folio is fully handled (zone_device -- caller
+ * must return immediately).  Returns false if the callback ran but
+ * the folio should continue through the normal free path
+ * (private_node -- pages go back to buddy).
+ *
+ * Returns false for normal folios (no-op).
+ */
+static inline bool folio_managed_on_free(struct folio *folio)
+{
+	if (folio_is_zone_device(folio)) {
+		free_zone_device_folio(folio);
+		return true;
+	}
+	if (folio_is_private_node(folio)) {
+		const struct node_private_ops *ops =
+			folio_node_private_ops(folio);
+
+		if (ops && ops->free_folio) {
+			if (ops->free_folio(folio))
+				return true;
+		}
+	}
+	return false;
+}
+
 struct vm_struct *__get_vm_area_node(unsigned long size,
 				     unsigned long align, unsigned long shift,
 				     unsigned long vm_flags, unsigned long start,
diff --git a/mm/swap.c b/mm/swap.c
index 2260dcd2775e..dca306e1ae6d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/node_private.h>
 
 #include "internal.h"
 
@@ -96,10 +97,9 @@ static void page_cache_release(struct folio *folio)
 
 void __folio_put(struct folio *folio)
 {
-	if (unlikely(folio_is_zone_device(folio))) {
-		free_zone_device_folio(folio);
-		return;
-	}
+	if (unlikely(folio_is_private_managed(folio)))
+		if (folio_managed_on_free(folio))
+			return;
 
 	if (folio_test_hugetlb(folio)) {
 		free_huge_folio(folio);
@@ -961,19 +961,18 @@ void folios_put_refs(struct folio_batch *folios, unsigned int *refs)
 		if (is_huge_zero_folio(folio))
 			continue;
 
-		if (folio_is_zone_device(folio)) {
+		if (!folio_ref_sub_and_test(folio, nr_refs))
+			continue;
+
+		if (unlikely(folio_is_private_managed(folio))) {
 			if (lruvec) {
 				unlock_page_lruvec_irqrestore(lruvec, flags);
 				lruvec = NULL;
 			}
-			if (folio_ref_sub_and_test(folio, nr_refs))
-				free_zone_device_folio(folio);
-			continue;
+			if (folio_managed_on_free(folio))
+				continue;
 		}
 
-		if (!folio_ref_sub_and_test(folio, nr_refs))
-			continue;
-
 		/* hugetlb has its own memcg */
 		if (folio_test_hugetlb(folio)) {
 			if (lruvec) {
-- 
2.53.0


