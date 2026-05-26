Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 725B4CD5BD2
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D761A6B00C4; Tue, 26 May 2026 07:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DFF6B00C5; Tue, 26 May 2026 07:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DB26B00C6; Tue, 26 May 2026 07:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFB9B6B00C4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:37:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FDD61A03CC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:43 +0000 (UTC)
X-FDA: 84809371206.18.4B53675
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5C86380005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:37:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KATUYryC;
	spf=pass (imf02.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YrtHMEYPI1tjDQiF/FNeUbCwB0JCeO1sQzq3zX3f00=;
	b=PXP6zvhjW35kgaGktLmh7W8Y45x4voQoybFdeJLJcl/ZfhiBpGP7pCndeK5IWvibW25xkb
	618D89GEn9vTqG7EYqmTyLj6tDsX/ezU8FKuyPTmkxuJ17f5DyVaT10KhJRgshTAEjye/C
	n1RiW0v9c7Mvh2DQUZ81yoVX/W0x1Go=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795461; a=rsa-sha256;
	cv=none;
	b=f/slPZOBRBkLZ6S/kTaavlrgAFLiG4yfuLrAWHtexrBk9w99vfoRlH0Vz/PvGt0GD3Enf8
	ujhWkke6R27GmilUgnrEOFL6XZnoO0j9OKCSVJu3C/FqPNmlCzTxiIc2N7IN39SbfBql3u
	NDzIRdCJJFKggTr9a63WZpD+QR9yNcU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KATUYryC;
	spf=pass (imf02.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a8fbe18b1dso16702457e87.2
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:37:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795460; x=1780400260; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4YrtHMEYPI1tjDQiF/FNeUbCwB0JCeO1sQzq3zX3f00=;
        b=KATUYryCgItMb+CLQd37un8cSTIHUzuYbovaMeRdP/Z1abUxGJr/Osa8kOL4KCHbrX
         9eIIc08cgySnAznMXmAmHC1hnK98rrEJcpjYFLlD3BjLVG+Y1h+PIQ/1pAb6HI5auIlI
         8kUqcT5anf+vMsx2ifGAQvZ4/+tjX30qXpVL73oxD0tOt/ponvA8Z+SAPqOGs0ve8DGP
         2KWqdCttz3qL8bJbNBx9LATWev5qUjMqL9dAyvIXimT7UYtMD5uUTiNclvo6B46rw0NC
         XpP8VN6KC0iAScPJIkaaNSUp8egwq2Dba3lfR+11DHFlPD+Z+8rFisvwt7g/McLzVHhn
         T9oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795460; x=1780400260;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4YrtHMEYPI1tjDQiF/FNeUbCwB0JCeO1sQzq3zX3f00=;
        b=azUJhTk1x5Ucr6zHhDkt4UgCx8rPGfnJ7EAWO0WKwEDQVe3Ybdy+rB2tTvY5belpPR
         x/+KtpvQtacL3RT9fSaxvI1dCHrsXS7U7xcga6fosRCtc+gKtT4jb4SpU4zdOY3PyFpA
         z9U/Peusq/hCQ5nCBPDjoNvtSmyJtzXGwy80l2tl04hMtl6GujHBCqq9ntyxBW+ViZjI
         9XGxHTGCSIxFhdDtOtfg+8WEtw05ZEsdqz5vDP02oBo/AkUCOiHv4ftgZkitK5rYy9lT
         JrKPOTn2tC6ZtrkrScW4x55wV0OHRRhmCE/rH+0IbMEqp2/YmfIF923tiVeciyCVE1ns
         NWMA==
X-Forwarded-Encrypted: i=1; AFNElJ8fWE1wZUR/E5HV+2ReeZiNxp1odCamlCDFP7MPAqMabpIAkmc7YZJNplk3/2Px/4T92zrcUwAQLA==@kvack.org
X-Gm-Message-State: AOJu0YwAzzWitSc1YaSLst+AsT3vV6OiEw6xQf1wgDaTsu9j0W5wIMRe
	A+wrEHsBaVeBsLjFuNno79e1we41LTszf77XhKstlaBdV0HzbR0xqr23
X-Gm-Gg: Acq92OF99YdSLO26rtlvIwsbUjH05vaUpHO1FOjGa48P3wEHOCwJByuJgqbBqoknZki
	WU3WtvtfX+iWGbwcK/edvkQB1rMS7rwzHhK3VcndfFpAm7uWbAAc0yWmSSQiXeLxzU5zdnD1Rzc
	AvSiFnGmdn5nucGu2SXBqTKv5q/nrmtT5vIKHUoSbUyBB4RmkNE1KOQY87AkgKlHDNIsc9pfZ9M
	gb09bkVIzAoPpnmMVDVePg67jTu+hiBNBJpQoPJoC/URnalRAUWF+UZf+mVdzwigvdJ6Sbjtdao
	k2LhBqSOymBs7VtBjZo01Pis6bsYi7f9mtXng1Auma6VZd/UJMP69tsM4WVrDfquugb2nQ4H5Lb
	9pSKF9WMQ/LyyxhyS9JAzEKsaS/b34Js+nN8MAO2f+4+jUBJGnkuz/HHV42zcT1xTqGN9tZp585
	W6vplfWItQSELZzHEar21cz4Dd19u+gjoRQE4eL/ysoEfXCFuKCwISCcELrqnsS23Z9pQ0
X-Received: by 2002:a19:f010:0:b0:5a8:8f72:de76 with SMTP id 2adb3069b0e04-5aa3233bde4mr4472023e87.19.1779795459278;
        Tue, 26 May 2026 04:37:39 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5aa46330d9asm376332e87.59.2026.05.26.04.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 04:37:38 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Tue, 26 May 2026 13:37:03 +0200
Subject: [PATCH RFC 2/3] mm: new migrate_mode flag for async using
 non-temporal stores
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260526-rfc-nt-demote-v1-2-eb9c9422daef@zptcorp.com>
References: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
In-Reply-To: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
 Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, 
 Raghavendra K T <rkodsara@amd.com>, 
 "Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, 
 Wei Xu <weixugc@google.com>, Xuezheng Chu <xuezhengchu@huawei.com>, 
 Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: rmssmc4a5xkgah7q48jabsix53i9qmy6
X-Rspamd-Queue-Id: 5C86380005
X-Rspam-User: 
X-HE-Tag: 1779795461-249063
X-HE-Meta: U2FsdGVkX181NS3LIU9k4KrVREUXjrP5Ae0ZGquKMnvUGHynzprlt2kPrcaMn+xnCnhSPEMBtsuv2LQ87FWIDw/b46D8NkCj+7N2Lp/9sEawyqUdlne0WX3oocdAd5dnvdTni073x5YbpYcdwOrbn6y7KjW3OPr3A6Ru8hh8fTniJ6/Pu56d5Cxg7uQJrJ4ZjSIUit4+7d97hER0cdjl9HufssmSmXMjTbGuZ5L3fvntY7q/BqE404Nz2GiegCt6jAU0XdYFNERO4uI7ps/b5YEeKxLUdM3py/5kS4cY4jGEuALm7K9wC+3hzfOMHaiHnzZP0pHV0cWHnd4eu2xpHP63hhVahkQum8pZsQChgOe8NZ8ybHRLIb8PFjXDlK0yn9uHi8cfEEog4laT19xc5VIfRL1J0bd18SYMhC+3wLuSsZTFp4ILH10BfPjdbhqbfN3ZvCV3myxkYjj3MT/B+RypnAw5Ul48Vcf7rLnOyLr0qdBIQIlxd/SgUWv4C9ol/D8VYLvDxPSsuzGt6qCrTjcHQN/S/We5bC8/mLbHeBOyt0X1RAKW4ytOAf502qoDklMT58q//R0sj9EGkOjHxernESvcdA7MI9FX+QNG7YHi8j/NkCbkjxiVBKLP5wuO1dtf+7o+XVk4v1lvtDM8pNMv1T1VYrZudG9qWmvaMy/NrUsNxwHuktch3S+y5E8eNE5Ppa/vSKOnB6L4Hc8emcyos+HYxC7ZXS/FoRMajCnWLfBgWNo7kWfDZ9gCirOUlEapE2Co7wiut7L8oQAhhoWUipEveJL3b/0aHS4+1/4ydZ+GuTf4DNoFAOCQz/tMAlTaSW5YBlB5NeDWEjuzJC6+bYrOGq55ZRmXOxU1nWsbpKQeXfBjHu1JtDTXlvr6ZA5Z/eqEwR+qFdZ9XP7/dJpz0i9npT+nqPGw878R0ln/Ml+ANBzNUG+4dbaF523v2Qml8TzFpzLmFVquB2M
 RlnZYnn4
 IOuGvKheJgj2mgvmMcg4pv7Di46/vXXm9LRMI99BNOUyD+u4HUCEpWlPi5XlpVvhmNqLlVhnM+sSkVoJz855PuWv2jzOCGqEkOG54T2NPFOomGadibO0wTvqAU6oth/agmIlFWFLvmSO70YUl1fcb0Eh9dvUICZDl/QgqvhLNqEYBK7rEIz5gxGnX/ssGFijHJIdUmfGfx05k/j0d7aVLRTyWC5qz/fkoNq0MlqcsWzTVX+AcuNLMqv5ARFZINQKRVTo4RhHsds4YKnAQXNGDLbP4s56bvJkGdOy2WCyJiRSQ+9uqYtPEwyvQfbbxumK+SjghJRO1we3O/Ug2Axv5lme5BHxLs5eOHRa8/3bU2K9W/4dW/axVfKo+gUBlprX0njn4r/0VUxptBS+AYKz8IQ4zGiwtRo1wWUJ+7rGNXaVLzlO4p85EYSdgxINqagnHUNfBUKZArNd7/8SboLvvDLkqSHaUoV8biUyG+j7LB9Qhc2TUNhpGdzNM2ecZEIlde6mQTdUXWrZCsPcSxXvQTKhjTEFlWmsCk1xjvXxgYvsXlPzq/4sJIGiB+R8PN/YJU36zwQL4WLAeW0xJaRnkqL5NLBP8i+vyfqAlrE1UVG+4K9kWEei0hBgaG+ORUgvI6649lPK9sLW6n5mTaRRLfF4zgn9yyjq7EbnCVPWozdZ/SZOl3rZiWEMVCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alirad Malek <alirad.malek@zptcorp.com>

In preparation for the following patch, add a new migrate_mode which is
still async but will use non-temporal stores. Add a helper function
that checks for both async modes and replace all plain checks of
MIGRATE_ASYNC.

Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
---
 fs/nfs/write.c                 |  2 +-
 include/linux/migrate_mode.h   |  9 +++++++++
 include/trace/events/migrate.h |  1 +
 mm/compaction.c                | 18 +++++++++---------
 mm/migrate.c                   | 12 ++++++------
 5 files changed, 26 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 1ed4b3590b1a..beae4441e080 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2119,7 +2119,7 @@ int nfs_migrate_folio(struct address_space *mapping, struct folio *dst,
 	}
 
 	if (folio_test_private_2(src)) { /* [DEPRECATED] */
-		if (mode == MIGRATE_ASYNC)
+		if (migrate_mode_is_async(mode))
 			return -EBUSY;
 		folio_wait_private_2(src);
 	}
diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
index 265c4328b36a..f7186e705b48 100644
--- a/include/linux/migrate_mode.h
+++ b/include/linux/migrate_mode.h
@@ -3,6 +3,8 @@
 #define MIGRATE_MODE_H_INCLUDED
 /*
  * MIGRATE_ASYNC means never block
+ * MIGRATE_ASYNC_NON_TEMPORAL_STORES means never block and use non-temporal
+ * stores if supported by the architecture
  * MIGRATE_SYNC_LIGHT in the current implementation means to allow blocking
  *	on most operations but not ->writepage as the potential stall time
  *	is too significant
@@ -10,10 +12,17 @@
  */
 enum migrate_mode {
 	MIGRATE_ASYNC,
+	MIGRATE_ASYNC_NON_TEMPORAL_STORES,
 	MIGRATE_SYNC_LIGHT,
 	MIGRATE_SYNC,
 };
 
+static inline bool migrate_mode_is_async(enum migrate_mode mode)
+{
+	return mode == MIGRATE_ASYNC ||
+		mode == MIGRATE_ASYNC_NON_TEMPORAL_STORES;
+}
+
 enum migrate_reason {
 	MR_COMPACTION,
 	MR_MEMORY_FAILURE,
diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
index cd01dd7b3640..e493207a3f46 100644
--- a/include/trace/events/migrate.h
+++ b/include/trace/events/migrate.h
@@ -9,6 +9,7 @@
 
 #define MIGRATE_MODE						\
 	EM( MIGRATE_ASYNC,	"MIGRATE_ASYNC")		\
+	EM(MIGRATE_ASYNC_NON_TEMPORAL_STORES,		"MIGRATE_ASYNC_NON_TEMPORAL_STORES")	\
 	EM( MIGRATE_SYNC_LIGHT,	"MIGRATE_SYNC_LIGHT")		\
 	EMe(MIGRATE_SYNC,	"MIGRATE_SYNC")
 
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..cd26781b7376 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -444,7 +444,7 @@ static void update_cached_migrate(struct compact_control *cc, unsigned long pfn)
 	/* Update where async and sync compaction should restart */
 	if (pfn > zone->compact_cached_migrate_pfn[0])
 		zone->compact_cached_migrate_pfn[0] = pfn;
-	if (cc->mode != MIGRATE_ASYNC &&
+	if (!migrate_mode_is_async(cc->mode) &&
 	    pfn > zone->compact_cached_migrate_pfn[1])
 		zone->compact_cached_migrate_pfn[1] = pfn;
 }
@@ -507,7 +507,7 @@ static bool compact_lock_irqsave(spinlock_t *lock, unsigned long *flags,
 	__acquires(lock)
 {
 	/* Track if the lock is contended in async mode */
-	if (cc->mode == MIGRATE_ASYNC && !cc->contended) {
+	if (migrate_mode_is_async(cc->mode) && !cc->contended) {
 		if (spin_trylock_irqsave(lock, *flags))
 			return true;
 
@@ -864,7 +864,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 			return -EAGAIN;
 
 		/* async migration should just abort */
-		if (cc->mode == MIGRATE_ASYNC)
+		if (migrate_mode_is_async(cc->mode))
 			return -EAGAIN;
 
 		reclaim_throttle(pgdat, VMSCAN_THROTTLE_ISOLATED);
@@ -875,7 +875,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 
 	cond_resched();
 
-	if (cc->direct_compaction && (cc->mode == MIGRATE_ASYNC)) {
+	if (cc->direct_compaction && migrate_mode_is_async(cc->mode)) {
 		skip_on_failure = true;
 		next_skip_pfn = block_end_pfn(low_pfn, cc->order);
 	}
@@ -1364,7 +1364,7 @@ static bool suitable_migration_source(struct compact_control *cc,
 	if (pageblock_skip_persistent(page))
 		return false;
 
-	if ((cc->mode != MIGRATE_ASYNC) || !cc->direct_compaction)
+	if (!migrate_mode_is_async(cc->mode) || !cc->direct_compaction)
 		return true;
 
 	block_mt = get_pageblock_migratetype(page);
@@ -1465,7 +1465,7 @@ fast_isolate_around(struct compact_control *cc, unsigned long pfn)
 		return;
 
 	/* Minimise scanning during async compaction */
-	if (cc->direct_compaction && cc->mode == MIGRATE_ASYNC)
+	if (cc->direct_compaction && migrate_mode_is_async(cc->mode))
 		return;
 
 	/* Pageblock boundaries */
@@ -1705,7 +1705,7 @@ static void isolate_freepages(struct compact_control *cc)
 	block_end_pfn = min(block_start_pfn + pageblock_nr_pages,
 						zone_end_pfn(zone));
 	low_pfn = pageblock_end_pfn(cc->migrate_pfn);
-	stride = cc->mode == MIGRATE_ASYNC ? COMPACT_CLUSTER_MAX : 1;
+	stride = migrate_mode_is_async(cc->mode) ? COMPACT_CLUSTER_MAX : 1;
 
 	/*
 	 * Isolate free pages until enough are available to migrate the
@@ -2514,7 +2514,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 	unsigned long start_pfn = cc->zone->zone_start_pfn;
 	unsigned long end_pfn = zone_end_pfn(cc->zone);
 	unsigned long last_migrated_pfn;
-	const bool sync = cc->mode != MIGRATE_ASYNC;
+	const bool sync = !migrate_mode_is_async(cc->mode);
 	bool update_cached;
 	unsigned int nr_succeeded = 0, nr_migratepages;
 	int order;
@@ -2537,7 +2537,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 		ret = compaction_suit_allocation_order(cc->zone, cc->order,
 						       cc->highest_zoneidx,
 						       cc->alloc_flags,
-						       cc->mode == MIGRATE_ASYNC,
+						       migrate_mode_is_async(cc->mode),
 						       !cc->direct_compaction);
 		if (ret != COMPACT_CONTINUE)
 			return ret;
diff --git a/mm/migrate.c b/mm/migrate.c
index 2c3d489ecf51..ff6cf50e7b0b 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -907,7 +907,7 @@ static bool buffer_migrate_lock_buffers(struct buffer_head *head,
 
 	do {
 		if (!trylock_buffer(bh)) {
-			if (mode == MIGRATE_ASYNC)
+			if (migrate_mode_is_async(mode))
 				goto unlock;
 			if (mode == MIGRATE_SYNC_LIGHT && !buffer_uptodate(bh))
 				goto unlock;
@@ -1220,7 +1220,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 	dst->private = NULL;
 
 	if (!folio_trylock(src)) {
-		if (mode == MIGRATE_ASYNC)
+		if (migrate_mode_is_async(mode))
 			goto out;
 
 		/*
@@ -1325,7 +1325,7 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
 		/* Establish migration ptes */
 		VM_BUG_ON_FOLIO(folio_test_anon(src) &&
 			       !folio_test_ksm(src) && !anon_vma, src);
-		try_to_migrate(src, mode == MIGRATE_ASYNC ? TTU_BATCH_FLUSH : 0);
+		try_to_migrate(src, migrate_mode_is_async(mode) ? TTU_BATCH_FLUSH : 0);
 		old_page_state |= PAGE_WAS_MAPPED;
 	}
 
@@ -1565,7 +1565,7 @@ static inline int try_split_folio(struct folio *folio, struct list_head *split_f
 {
 	int rc;
 
-	if (mode == MIGRATE_ASYNC) {
+	if (migrate_mode_is_async(mode)) {
 		if (!folio_trylock(folio))
 			return -EAGAIN;
 	} else {
@@ -1799,7 +1799,7 @@ static int migrate_pages_batch(struct list_head *from,
 	LIST_HEAD(dst_folios);
 	bool nosplit = (reason == MR_NUMA_MISPLACED);
 
-	VM_WARN_ON_ONCE(mode != MIGRATE_ASYNC &&
+	VM_WARN_ON_ONCE(!migrate_mode_is_async(mode) &&
 			!list_empty(from) && !list_is_singular(from));
 
 	for (pass = 0; pass < nr_pass && retry; pass++) {
@@ -2107,7 +2107,7 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
 		list_cut_before(&folios, from, &folio2->lru);
 	else
 		list_splice_init(from, &folios);
-	if (mode == MIGRATE_ASYNC)
+	if (migrate_mode_is_async(mode))
 		rc = migrate_pages_batch(&folios, get_new_folio, put_new_folio,
 				private, mode, reason, &ret_folios,
 				&split_folios, &stats,

-- 
2.43.0


