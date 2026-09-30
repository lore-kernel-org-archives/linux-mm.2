Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DC7ACA5FB1
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 11:22:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84B86B0099; Wed, 30 Sep 2026 07:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34FE6B009B; Wed, 30 Sep 2026 07:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B6A6B009D; Wed, 30 Sep 2026 07:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF6726B0099
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 07:22:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9A3816077B
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:26 +0000 (UTC)
X-FDA: 85270190292.02.3699511
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf28.hostedemail.com (Postfix) with ESMTP id E65DDC000A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 11:22:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="KOm81DK/";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.98 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790767344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3xLO9oHZX09j4z5ReQz7uxeTdbhZL5eq6oXo0UxzOY=;
	b=vcY9UpNF8ou+Apqc8wVOXFy7QkTMLOP5HfJ+p5Vhp4nrDr0tovBiHGFj63KxS7Vu73zY49
	ArseXUoquhwkkJU1xy9yYg8w3/xa5+yzDDAdPFfEY0vn9c23VWoJkWHKdzXx9ZQ18g4Q3Y
	T1FxkTSqrAmFWObXL5ZzaVK8Vb8x7HA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="KOm81DK/";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 74.125.225.98 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790767344;
	b=lR+n0aLPddNa1bvymbTCWzGwA3MmSwkiv9BLeNyH5gk1aKNSpImGPSU5b5MYazZdF0Q3vV
	Y9UQQsssRCzGJnFwTkGKRU4AjjYPgdHNHPNSq5QkSBteUi6jTijfc1DL02ehMeWYi5tsNy
	YewwaU5ofWylyL11ykNAmCcEqLwnJ8c=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48aef5d66c1so1174958f8f.3
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790767344; x=1791372144; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s3xLO9oHZX09j4z5ReQz7uxeTdbhZL5eq6oXo0UxzOY=;
        b=KOm81DK/KulU6iLYvHoayNRkMPA+UXPsYVNJNWCx1giL5A6RV7mLK/S7w1uLevOSER
         amzJFc5PdRYBY1G6y/k1vrS5jZJzEJF2544R5e2bdDK+5HJWw63K2Vlyd8x8qDiDznEY
         +5pffPkoqjQtnH6VYYnXcllhHuEtHHwL2KEbwxj55UwkPW5uG9sn2f0YPRU70sU+V+xz
         ukZ5XD28pV6axsgRx91FUO0JdsexkEQzRo4+2ySWdb1rTbhOMBqmTSM2qrTEn5FwQpKk
         8SAHaMvKYmLF5UyJZZKN4azP79eK9GbT9MdgsAaqtaGapvaQ23SPdNVaG9Uim6ysUga6
         Jweg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790767344; x=1791372144;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s3xLO9oHZX09j4z5ReQz7uxeTdbhZL5eq6oXo0UxzOY=;
        b=qoQbPhlzB6AGu/aC6qqcJTttGrBsU+DGIUNVxTIa/HoC1J6JU6xbW1TcMMbpJbzgkq
         99x2N6J5iZ2OygpZeRWOqVTxv6KobN3FycOOYpdDP2hUKPkEpkJf4bxvAdHHvSEwBLgD
         uFP5+wAZjTvdErKepMZE/Huz5Xnz6W+JM9SdM1W7j1TRbgamfMziL3JsZEOhwPid8Cxe
         sPrgX0Sx8M/T3JS99FJLEy+FIEHcCiQvJt/xAKNQc7zmty2e9upngwDeXfqjwInrd/qI
         YiKjQHMkVlhgg+pTRkrZrsciUY1fynNzeSfja5/KYu1GBw3uF93wecU8wKLWKVylqf84
         wtVQ==
X-Gm-Message-State: AFuF++npfCpAhXbvz4czGzaD5LfWE1lwN6jH3lZfYFQdNdWv3uGqNfCE
	z89VqFBaef4eJdM5BX8DGtfTtZ5RNQsUr2DZz/2t6O+90jcn7YaF1cO9Be8mWlaJL7tEeDutTqX
	zL3kA3k46MQ==
X-Gm-Gg: AYBFou391lnvHvbR4K7avePKXhInFCQzt73ULT4wBcN7Onqab6X/RVvBFx58yVF8X0O
	zG/Vjn5iX4iU1bNpqgwKSsBitHLVY8aK+w3HQgykt8l/4TfBRn9YB6QqPI3hfI3eSaDTwvIiUbk
	9pE6MM4Fadd9x02fh5wMaThU4OdCuAPC5Scb2PxG/2GYDb7GdVg9z725NeDsBnVVPKLGfSKmZyP
	jU/2SKtvPBjn6etJk9Xd+VXbf5JQ2nm63HxpegZnk5XwNZ4FC/Pc/HpRWNnd1bl4Jm8mtkSGy8v
	p7YpGVpdNU7P7GB7ROfsW//nSr1G2mCUafc6N0w3KTpKevhQb1oIdoHK9u+NByUXG9OSLAidcA9
	prOq1M3Z/EhQce+e8YN8dwZpGpLm3MqgzoxIptq38toncij+8qcmKullZxG+Du04aOIr0xoNfXx
	DlnR9WYrFQllJ5SZvKZDBZtUU8KtXOertG39EcgiZJOyflRl4rgdQQDYQdX2Og3g5V66Utjg3vb
	WS4sYG6Q6bCap6w
X-Received: by 2002:a05:600c:46cf:b0:49f:e4ca:e1d with SMTP id 5b1f17b1804b1-4a01b115536mr19041855e9.27.1790767343529;
        Wed, 30 Sep 2026 04:22:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.thefacebook.com ([2620:10d:c092:500::6:13b8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a019740c34sm34097095e9.9.2026.09.30.04.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 04:22:23 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	hannes@cmpxchg.org,
	shy828301@gmail.com,
	osalvador@suse.de,
	raghavendra.kt@amd.com
Subject: [PATCH v4 7/7] mm: use VMA flag helpers in NUMA balancing
Date: Wed, 30 Sep 2026 07:22:06 -0400
Message-ID: <20260930112206.205083-8-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930112206.205083-1-gourry@gourry.net>
References: <20260930112206.205083-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E65DDC000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gedgh6wpccd8dx776n5ofnz39o8j8xos
X-HE-Tag: 1790767344-705844
X-HE-Meta: U2FsdGVkX1+G8zEVhjcSX39cKtU+Kz13m2QSHeyVjyX36a6HYGQY7EX6+psQ40uXP0S17rsfn6RC5nb18Yzj98gMjOKi92S15MLCI41sdL4GNuY+kCyXSibKCG582FRhwtdRrkyCFBYdGtGCC8pMIHXl49R2sSqrUqrHt2wIlwogl/0SjYWFFB/ZpaHhjFMvoKXSIE5+U6/bgbi4xwuXQc/xxShmwZ4DF3L7skOO5/cQzjTJb8/BdEQH9/7kOuX2HKVamflku3lOmpuTU9OtauQBsGalpI9OfIoD6z6BbZRIaGHQzMgpLXyqRLsZ2jgwaEipThYoMaVGiAu9LzBaxPp/AxW60WcO+2rhb3hxbQwbzIZ63dV1PLLDa9e/JbBglNyE+1sB6bzcJrwFv72GrfF9z+4ngTns1Kwg6/h40OszU87D9lflAftlgPVpY43LwlFGMmcE7u/uULRW164iZWBqMRQxyoZMtyqBx0IOFS7hLp6GOj1tkQ/yF8FQcTOT6zDayFUE0UkXkZsbSPMxoFbPd2jfHW+tVKoLfQTFsdTIBT6eGNFp9QLkRxwEDOUrRfYSiWqW4Ylh00YArOrtmOoqTvylqStewe3j3LxqL5mH3QQ0cIIh2Nq26QUdX7tZbVQupwNMp7egrzf3Y29OYGMy6ZwInRwAm2jCYWrrhIeN4Jxt0GcvrseRmwWRwsHMxjT9alYMUWomtxJlVn/kFjRwiLixdrJbIo4h6gZn9T+HpIWMlu7TY2R7Wpa7Av8cBCux6lWKjAZjuUUkupZoZz1xEXbXrQlBFlnkWH6p9Gi2ef9PR1uQPkYlp1bLshS/yEFgp+9gyz4h8NRQ8ip01iDKNtaij2CeyWoIUhwXEelSJPSsq8S/LaZyiTMQrB3TX8pHkVn54AMUffy9eFZBVYkg+Th4cd2YQC0bl18in+p+ikLaqPQvZNwTRGaNNxg9we+pBbLdKsqFtiw0RNv
 XkPvgc/T
 S96UUS4gdZ+xkMgVOu8/zrKC3Sj1hFeFYpU04xGayl42rTarXDjgXoYOHE5v74WSjZQkNyK5wcGmu0kdjyNmoY68cxRoRd/YP7VH0ShZz8jSxTXAJ40cas8x4M0rTfSYfezeYk4GqkAf1AwVjlY9sfUGUsmOuHdbvmkpEp85Ok+p95+Tag6oMgmWamqdJ8OvmEt/lfzNJHm40qWMQZWRZEWKrQ9nhfuvIhtJ/zHivKxyEqOTsbzON7rmK14anake3FxUg3+4PyFCpQgCb65gVkDS8JBBybtWKrv+SK4MyUS77M2gHNqO7dLke0OkDaI7WOLZ6EACkWH8UVGLTnEN8js14hph3jd3m8W9hGW2peh/NqqTUzJkbPbrDxrTokZjQr6vY9jLK/v/rq+Zym7JVZl6u3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

Use vma_test() instead of accessing vm_flags directly in the NUMA
balancing code touched by the preceding fixes. Keep the existing flag
predicates unchanged.

No functional change intended.

Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Link: https://lore.kernel.org/r/aq1FDhy00epXXtgd@gremlin
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/sched/fair.c | 2 +-
 mm/internal.h       | 2 +-
 mm/migrate.c        | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6002882b9d30..448c36791d33 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4234,7 +4234,7 @@ static void task_numa_work(struct callback_head *work)
 		 */
 		placement_scan = balancing;
 		if (placement_scan && vma->vm_file) {
-			if ((vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ)
+			if (vma_test(vma, VMA_READ_BIT) && !vma_test(vma, VMA_WRITE_BIT))
 				placement_scan = false;
 		}
 
diff --git a/mm/internal.h b/mm/internal.h
index cbeaf1fc38cf..560406c36a75 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1240,7 +1240,7 @@ size_t splice_folio_into_pipe(struct pipe_inode_info *pipe,
 
 static inline bool vma_is_single_threaded_private(struct vm_area_struct *vma)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_test(vma, VMA_SHARED_BIT))
 		return false;
 
 	return atomic_read(&vma->vm_mm->mm_users) == 1;
diff --git a/mm/migrate.c b/mm/migrate.c
index c0f5f3ac71fc..fb4099f245a0 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2705,7 +2705,7 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio) &&
+		if (vma_test(vma, VMA_EXEC_BIT) && folio_maybe_mapped_shared(folio) &&
 		    (!folio_numab_promotable(folio) || !node_is_toptier(node)))
 			return -EACCES;
 
-- 
2.55.0


