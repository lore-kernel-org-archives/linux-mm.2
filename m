Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6518EC55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 15:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DB516B00A1; Thu, 30 Jul 2026 11:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7649B6B00A3; Thu, 30 Jul 2026 11:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DE406B00A4; Thu, 30 Jul 2026 11:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8F46B00A1
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:03:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFE291C0167
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:29 +0000 (UTC)
X-FDA: 85045761738.26.C650968
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf20.hostedemail.com (Postfix) with ESMTP id B25F41C000F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:03:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o629Riuq;
	spf=pass (imf20.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785423807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4YrtHMEYPI1tjDQiF/FNeUbCwB0JCeO1sQzq3zX3f00=;
	b=7yTxSPw9NLjEOzky79uvezGF3jP5kHNSZzkVZYGzTLwotBbHoz2R0wvV6PFBV/IUx9Thvp
	X9kRKmmcX1jxpmIR/MIS/DvbPzd3Xpf3idoYuBpFgPTBleWrK1AchcSjkKaNkAN7NHesQV
	xPqK4E60NDiE2U8I6cztCfMe5jn8Bb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785423807;
	b=Q61CMGVWNrYiu1AmeYu5Ml3z+OcRxu89BVGSsBxHwbwxv0n0qbjdoKm8AfMrRqAbyZULCc
	fvGZPd85Suhj6iFIyjJri/YUTYByW1z/Yc/kS0uDIR4gXzUG/GaV06LvRK8RIUYbvEgIgt
	8LXWSOY/VFkXVBCu03FnWPKnq0oRq6I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o629Riuq;
	spf=pass (imf20.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1fbe461f59so22659366b.2
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785423806; x=1786028606; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4YrtHMEYPI1tjDQiF/FNeUbCwB0JCeO1sQzq3zX3f00=;
        b=o629RiuqI1ntF6DVt8yQfoEOdSwu5PWOVfNjBelTtnfNJ1sTPuDOGCKvCSu0wACMON
         MSY/580hhSbXP+B00fQwj/ACymwugb/CUUIJVQhDTPFx0fWWKbrqsMk5JwRxAe0DZF2h
         dfSFDc2dOKWcBRKvXVFnHfbsdbxkxaqSyZrS6zPS/GeXWl7NGyi57j6FfiBtZAPya6/g
         EFxWgPAbURF0t8CDnh2zTt6R6gntABG5P3wv0vCfAqglN3h6vSK4DudKjHVcPidbDTnI
         t0fTiaBNCUYwYM498VJ3csnHjuBybCoRIwFJb9XP3m/Up2GQ6T7FRQNx6nWrFY6U/52D
         FR6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785423806; x=1786028606;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4YrtHMEYPI1tjDQiF/FNeUbCwB0JCeO1sQzq3zX3f00=;
        b=PnhAXZqp0USQ5iLrIdcEWR75emuom3PNsXB++qbKVEC9wWFo08nbkqxo6Qp9M6UcXJ
         KBLNoDFPF4wcO1lzT1Zh43MI2REW9uoiuDYDRv/ugYofZNUDG8aCqjWgS8EASYtbfn0C
         YVT8FghqumlVkAY0WAW+RqqgOX5P08tZ8Qeup54KIjU/gulp4EvDbpxy4ovbkFCcOuQ2
         GsPEgdwvRtM+uIuPWXfGXVXX8cXY3RMqVperMiYnYj4qZikHQpNeOfGSoPD8jdM6qwvH
         UU9AEGyYWWGi5PY75Xl1MWZFwt7pGMpbZMBESQ0KxoR/TcBxzuKz2jcwbIbgLDahage3
         1iPg==
X-Forwarded-Encrypted: i=1; AHgh+RqKLoUEVtqLU8wrbSwqs414+n2j95sAWF+bsSeb1ELywg/FQ3Gc2jSNg+ivvq1V0nawig+irj5FDg==@kvack.org
X-Gm-Message-State: AOJu0YxvOv/RST3bJ4jvjl1EO0cxObyYMjtP1yO2tvCLmlk2fWtHG5jV
	09wvuFAG7fD3ifz5m2WEssLsvXLaA/I6qHKlhuJQOL9RXSEGjfVw52DV
X-Gm-Gg: AR+sD12StMhoSE3zaWrrVS6CHTtAdIFUhEpwBS7E0LhL/uxBL04AU8cv3EU3XDFfOFb
	sGljeEytozMsF15ar2iHRN3ZkHSGdU/D5OdRQ6sjlpqp60ZiqfM1IwbkUrANu1PY8exf5n4nmrY
	x2CWCXWGzDMesECuns4XTwb/w5teNmn5uqDxhNhjg5ArNXEqmnhhovgXWZLMLSX06rrA2eAlBi8
	VyRRJqFekB1yKuiCCEXSMy8ASpODIWnsDzrkvEWiajg1WcztUb1WSOtDyydDuG1aUnX0iFzqW2a
	ysexIxDsP+kbgaRb/1wUocoQdgk+vL3YVRIf7BM9nWwQE9QqyE3ndjsDvYXI1RwRGVHER2w9YoA
	oocggBhQXgQCgvQMGcLqeGk5nhMutKHHcV9R6tYLYLSncaoAa6TxDHRPVmA0DzH9NO86KbEykN/
	EX9KUwoEQPH77ocaJWrGp0kjHpAiRzsrijPPrCgjhZPRMxdPvNNR2rDWpUv88g5+LCgt0PQewSk
	T47GZ5aYrJEYVppRIBdrVUZjmor+gKQnw==
X-Received: by 2002:a17:907:3c83:b0:c17:cf99:6154 with SMTP id a640c23a62f3a-c1fa55db339mr152575066b.16.1785423805407;
        Thu, 30 Jul 2026 08:03:25 -0700 (PDT)
Received: from [127.0.1.1] (h-62-63-197-109.NA.cust.bahnhof.se. [62.63.197.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a07bf18ff8sm729116a12.0.2026.07.30.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 08:03:24 -0700 (PDT)
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 30 Jul 2026 17:02:58 +0200
Subject: [PATCH RFC v2 2/3] mm: new migrate_mode flag for async using
 non-temporal stores
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-rfc-nt-demote-v2-2-452dbe3b5073@zptcorp.com>
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
In-Reply-To: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
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
 Ryan Roberts <ryan.roberts@arm.com>, Huan Nguyen <nhuhuan@google.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, 
 Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>, 
 Alirad Malek <alirad.malek@zptcorp.com>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B25F41C000F
X-Stat-Signature: rzfgq74a16i4di9cjk1gu8j63qtdtzb5
X-Rspam-User: 
X-HE-Tag: 1785423807-843628
X-HE-Meta: U2FsdGVkX19z1I5hfjdpDA1Ohf4m4LCqz9lnymBgE6sxWImiwnCtgcNEkxO1pPIat7gJtrBdzz3D99iroMHo8iJIDJwszfo60r0QP0g6KCokJXYh5DgS9esVucdVBUSuuXiXfsnfwvYo5tNvE9Zfd9fc5iMiwUtZU4H3t4jSLF/q7FPgLVy0vzBffOVogIKw7VuTF46aKntyYKHRqpTcHDBhwHiyA7uZ7NKwOVrgqAN+3CQw6N7zFc2USUWaX7CO01PyLY0PCWsHiwmTHbrM9/ytGbVbir0FVFfmWK7y65xUszPJgl46XSzkhlNhXeUfU3dXR25mxvxl7fx312drezryQRUW6FX9Sq9jWjOtxOmdd4tjgku5Fpg9wOtZZTQ04suCEiTScnAVixt6FTE1uSRMqlc1JwQw0yfBWjNIEVT0epAqRcYsVseP1Qtt4i2f0DDSYZoViWanC+P3IWr2YwA0v+2UHNCDuI4O8CI7RAsT96xR5B+wq2qjG43qqtZo7i+XVguyDoy59NUbSLHC0MMtbGv1bats0GDYj68Gz1sN1vuYSnSmyL7t4VVoNtCKxn/X+963zMXisXG0q8ECTz0aU9Ujh9Wogu1gZljUQaZO1Sns8VXAkq4Mwu/aGRFUNFQJMx510/+d+nThXcKA4LslqcvSFkYjslWDeQ29pJ6NfcnF1Attt6lS12q7/T6oqr944y3VG/TfExCBIPxagVkzNdKdyg9m0NpV3EbujYVXJQy75xXX6KlWOh8/ayGau6uabZB3InJJ1Bv+Wi9lMC8TxGC6DTopxf2BeswjxHCV6GCCJE3FatYR9LYSD+AKL+9VXpVejw9z2Gh8EwNKjNnVcu4vIVDv4R+2b8HQ0U0YUxIi2g18VNJk/4CxjbSB7cOngCMtWBFkHGr6WmyPMmz1dDX4Gvz9plHutUwsclejd8NyxQnsKabVbPmNVLbMwnNURRgZ0QSWRh/9Eo/
 VKJA1Nwf
 ACDFXQ2ZbkAz8M3TvG9cyzIBFIMghufkTcG3eoAGllmRrwXNauxAbNEioxOoo1L2SOZd9ajXXuEAZVXOFygSn11/5/dNCelv3b7FO+jRMKUT6VBzhP26sep1HwuC1MxPk7F3hcbIMKIAKtnIaCwmZUdag6o1IgHD0+8M2GeeM5og98pCWzRaFNdVw/LIWVJvyUY1xTeKHTK21yCfbx6YK0txzljk4kwxCbKF5UQDlq8TX05HvSDCuL8sJrnVOmGlhWHQ8rKrEb7MIKBZ0wJh5OC2/e/b6gGcWiC1mTc5RDgwUX0CDBTD0jqOkYqXTPD7PUtYVlcOKru3mmA1Mwc0mE7RPJ8JPdSdUT2CRo7BaKcd9kAFi19mlla+k6p3fexyMsHk99maruSCK0vbQUN8PHWjA0sgtnGEUacp7o6S93k7ZlMu8u5D2nnaTlv+odXEvO5X1s5G0Wkr2LltqgF8ZkG1MneAerA649+GUAs7Mwi5BkoRND9Vi0YrhM8tYx91jicrN21xxWCMgSG/3FSoC/ep+Xuh6K+ywGIlYDHPB0dleBiHlaA5ekbmTymxtgsB+IFQm
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


