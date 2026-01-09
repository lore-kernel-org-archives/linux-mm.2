Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D93DD232D5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 03:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB37E6B0088; Thu,  8 Jan 2026 22:47:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B456B0089; Thu,  8 Jan 2026 22:47:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997B26B008A; Thu,  8 Jan 2026 22:47:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 861566B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:47:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 135FB14032D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:47:32 +0000 (UTC)
X-FDA: 84311040744.28.78ADCEA
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39096100002
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 03:47:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VgAO0vVY;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767930450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Uuf9znc2JXT64dK1OAwjInh6+QxOWgZX8hjVTojr7X4=;
	b=1VKLmPLyqV9EFNqKiSPPlc2iKtk5vbUeNgsLCXYiTWLD/wOWo0+4eCcB95zfHhY6/crvEB
	Lu2NqUk2LZY823l+xXszN13SNm6UmPD7k7CoCbB7PJ0n1SfqdG2AnROiBVNhLIUNFmv3I3
	V6zH0yv/BzNZ1FAdykTPBN/7662FtNU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VgAO0vVY;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767930450; a=rsa-sha256;
	cv=none;
	b=ToejFvh9W4WPtCnoDyXgwraDfXcbUiMsPh51uTHZfgVT4LmD2fRMKEDRlrJa5P5Hecz4+H
	gvCusopUbKlO2h2wsrcIwYAKBe/5UT9r/ku+9aCryrE1wMqv0W7jRzKLO2qoGtlrk93Wt7
	Ssn1fVpc7UL6yGaJnuP7SXXXyLSixC8=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7bc248dc16aso2335917b3a.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 19:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767930449; x=1768535249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Uuf9znc2JXT64dK1OAwjInh6+QxOWgZX8hjVTojr7X4=;
        b=VgAO0vVYNaJv7rRUPFLbvaySIM6Aau+amUHQU6mkzWDJbnALCjpim84B4kFjfqgdrP
         bubqA2lGtOAt2kX+xMk7hpWmiSA30m2ppimK2C+sO3SZVKY/v1pCQoe8FZceFvOuz+1W
         v0vnydSntufmYN3KU3SkIsXgU9Kd4eLK4JlF5E2tZaZq3XmVOf8uxZW6t1gOzpibAmyd
         DEylLBrpHMMRkSVhjp+theaIHTeEUYjTYFfqpUYvLLBpi9UYu69QLMrzZqaShwKpzT2f
         30SYGR4df9PB6vd1ZBpqghVKbJrUG7bPxt2qNG7fyGXH5w3fyemYAoDs2VdiuimAeGRg
         3hkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767930449; x=1768535249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uuf9znc2JXT64dK1OAwjInh6+QxOWgZX8hjVTojr7X4=;
        b=lMEkm1OwghZ/I8cwefYhGQCCE1nvYK7MNJ8Spguftf9Iqdy3tgGPfVDNv5MAybYF4W
         vraSpneO/G6DxsN5Yv67wOPufIF54NgHTlIjx1MfxDAnZ3qXQYQlJBxcI3IrdiEq2XKR
         tjIgb05CHAJD0pXLqzFbx8jsKVyLGTsK00jeeQ44bwK5z6Mm8lJZDwYOTD4PGLEPk/T4
         ZJbxDEMcPtled0bSjfJuSvkCReNk01NxfzAPiZ97rcUijKy6GKBPIzjuWxVr0Zof5/zk
         bpDpd8ODOLjtArU2DYVJIR5M20WG/GPreGw4vvktc0nysRMfWBkNe29v4LBEAGYkRAw1
         kkpw==
X-Forwarded-Encrypted: i=1; AJvYcCUohyyE/Ct5IDZ9GwYcgwaLhTyG/OfPjC0wsoqb7EQLwYEMzVtos0LOSCfxSNyj9nEcNniVqMnOkQ==@kvack.org
X-Gm-Message-State: AOJu0YzCttCv3gpSP139fHL2B3CMC99fA5BXG0L+HrdGuNjSD9D5+gBn
	6/7wkVk1uzwQaC+6vXPEwtwi9Bzbmj5pTZ7M4eg5cChg8EZCaABlWziB
X-Gm-Gg: AY/fxX6eUnTeXHApgIrdOjCXyZRYfkLBOs7DFJjroYV5BsFo6JqpK4qp6zbZaAVMH1o
	pNmXNspcfja9TD19ZsgTuPnsRxxE/7F2cEwunFhybo+VvnuylP3m9kzY24dakGuTrr6Xz/fk5R9
	OUadEgpOqeU0Cxq5ZFPbe0g0prSgbaCf7TgjUZMnkE1Xm4YgFPLZflqYiWJdEkTvSrwB/Q4GXLf
	cKOQ1tnJMFAN6djbMQ2vnw4DiXOth4Ib0+pNp73rxiCVw0g6+mw+Hbr3BlXygQk3GV+q8Opcf2x
	ffBbzc2GiuQ0V3t0BrIbluUphBCSuOFoz0sh+1dJc9f3AtgSCxfGTyYTd27aZv+3tfeAus8xAZo
	1QbebYQWaIfj2vYIb6k1fyFcY5o368EJC6Z8E97p7ny+O0YAcY/hU/ulsTjqRQviRFs5iTHbN3m
	uHbV8=
X-Google-Smtp-Source: AGHT+IE8gWRX3DrNuMIGM8r39xNhzYOGAPewp+igde1G05i6UeVcSmYtk7n600bzgjyxna2PYCCSGQ==
X-Received: by 2002:a05:6a00:ad89:b0:7b7:631a:2444 with SMTP id d2e1a72fcca58-81b7f101bb8mr8011069b3a.22.1767930448890;
        Thu, 08 Jan 2026 19:47:28 -0800 (PST)
Received: from localhost ([2a12:a304:100::205b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c5de6405sm8958856b3a.61.2026.01.08.19.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 19:47:28 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock ordering
Date: Fri,  9 Jan 2026 11:47:16 +0800
Message-ID: <20260109034723.1342798-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: c89craepc7raag3zkdi7si75pc7moxg1
X-Rspamd-Queue-Id: 39096100002
X-Rspamd-Server: rspam04
X-HE-Tag: 1767930450-487020
X-HE-Meta: U2FsdGVkX1+M1CbXz57ymitL63sUEyES4TNSrFq2OF9+Z34vyIVsEQcPDzW93pwsTCzvAPPP0whYDwsj6UP/SVaTaXdKYe0UIZIIugew40TvVmAYHjqe9LPOMy45pHxxCuKZIqjpZYmAhO8JRZjQ3d9R7jboILzoGldN1vvzItaOW7LfXzcNnHksK2JJIuHMJfNAf2SlJ7H7oq2JbEl1tfPZZMUMHf4jd4zCMfBxWwCScIOYF4bwarXlRg5sTvNlA5FgEQYQCu3xYuloKqh7yeDnn4Lvq/J/EB2nA87WeADpLkZpg8XuVM1baShElZiYbvEB6RqscwR1EJFxT4xNX//kVbEDvW4Y3Vlcj0r6EAdYbrP8bXoff3rdkJA3hZ8H1CWaN8UeYiDJnb4PGKmaQyPjEY+eoolhrcFJBpwsgmFQ7Y16aB6wTH68GOey/Vrt2pcQdGXbOvGGKc/ZBCPDcivtcd3CjXilWYipfRCMwOxvg4q3A0rvY5QOM6D04MHW8POBHCLpVvtqv38SHgE1ZWkALyMOsoLkaP8B83XxjDVNTwGerU0T7QNk23LO7KXWkPHu6+yZHqN97HcmpCMgOi2WPcq56NhqV9XqtLh5zKpEWSC0MDkHpw0n74V97cWLjwBI3zSvW7qCXqTfaSL9xHN7qvUIabqydj7l89+PpVVsMT7mRynF0ovk5cBX3V07YdJmRA2YwnmqhXmG00sLY5zeowsP1gBty8Af05bsMoV3lig31slYj4EPkVyBVZqJCaa57cSXykRf0CVPEPlMUKoeFaMdYA/uxfZNRis4FhWV0VQ+EriWK/Ie6aeNAukWX5tVJAM5shB0Kg15Np3hRKK2moTLkTCgj6/XIYCSXvsBt2X3hGdtRfmViyhIx2fYCkdoISGTwl8avoNC9893kKbpzs/fukB67pL5H4/y2PUc1EkIbkXWsZZJvOUy+UwKOMrCHvG5gY+cSgmJtbk
 zPEceXzb
 EnLlp+hDc/gPotL1k+YN7KUyL+BIBGqDSq5uHcMeofOtDw8bmk3Bm6znjXj7Q1dwCykUsNk4ChFCuxQ9lAqrjzJe/0lR3ALZINMFo32Pptc1D+qJ889O7W4H3cPPZcPp9Xv0AMnZBzzzjaOuxNH7P9Fn2BjwEZtN9HIBhYT9nmrYL1ZoLbplamPQyScB5s6KMPqs3N7xo+pT6BinYqhUvNOfCneqILlhpc1OhXmXnynmkvoyctI/6/c1DBiT6L4bgl8qtkUFCdEmR6bi/ItTN9t9ytK/dgWzWuCn5dQVpMZ24/Geda/zHe0b3VRI3viJGTo0GBUarr4NM4oxNUQhhbxG1Mgnw7oGoi7nQOs2cRz0FKMqRXZhaZrTJQbBV4WefWP2RFKzTfCY29F3a7Z0r/DudSk0HZ+D36f/scGCpf4s3wR0eLSa1DRdUUChRZeiBFJXPHXTwBFhRorUekKrdUFCn18bdaiXX4LvCQLhdmVVIjcrO8KWx4LnG02BITrlHrL4D7ojVfUX9FiDQzbTzX4u7OR1gAutLdjguACgidUPsblIIP6kbLhpElQqwm/sLSfyVSBRn6JxQaqy+1ahf2HW0W6hGt134xoIyBKxmlfd/QfUhmcDuDSweYHL6eteOooO79Bu0UUR0gXTSbqjaYPMlTnBTl0/1Tq4YZhOj5rAlqcqtgT9dfNI1aT9GrwbvnnaQ/8UTKEDxTHJ5vEfbAfHVfRfdDjeTDq+ugdBgJRZLwrLHfL21msGFqCHtGlVgc6jy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix an AB-BA deadlock between hugetlbfs_punch_hole() and page migration.

The deadlock occurs because migration violates the lock ordering defined
in mm/rmap.c for hugetlbfs:

  * hugetlbfs PageHuge() take locks in this order:
  * hugetlb_fault_mutex
  * vma_lock
  * mapping->i_mmap_rwsem
  * folio_lock

The following trace illustrates the inversion:

Task A (punch_hole):             Task B (migration):
--------------------             -------------------
1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
   (blocks waiting for B)           (blocks waiting for A)

Task A is blocked in the punch-hole path:
  hugetlbfs_fallocate
    hugetlbfs_punch_hole
      hugetlbfs_zero_partial_page
        folio_lock

Task B is blocked in the migration path:
  migrate_pages
    unmap_and_move_huge_page
      remove_migration_ptes
        __rmap_walk_file
          i_mmap_lock_read

To fix this, adjust unmap_and_move_huge_page() to respect the established
hierarchy. If i_mmap_rwsem is acquired during try_to_migrate(), hold it
until remove_migration_ptes() completes.

This utilizes the existing retry logic, which unlocks the folio and
returns -EAGAIN if hugetlb_folio_mapping_lock_write() fails.

Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com/
Link: https://lore.kernel.org/all/20260108123957.1123502-2-wangjinchao600@gmail.com
Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/migrate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..bcaa13541acc 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		goto put_anon;
 
 	if (folio_mapped(src)) {
-		enum ttu_flags ttu = 0;
-
 		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
-
-		if (ttu & TTU_RMAP_LOCKED)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src,
+				      ttu ? RMP_LOCKED : 0);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);
-- 
2.43.0


