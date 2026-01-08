Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B31DCD185EC
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 12:41:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAFA6B0088; Thu,  8 Jan 2026 07:41:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99486B0089; Thu,  8 Jan 2026 07:41:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70AA6B0092; Thu,  8 Jan 2026 07:41:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A86586B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 07:41:40 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A821140750
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:41:40 +0000 (UTC)
X-FDA: 84308757960.30.BE36300
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80C7CC0012
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 12:41:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nR4Ac5VK;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767876098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxCHi6k3BTAzPt+DiJG3qCrr7/A1NponVT67aJszG2c=;
	b=lpYVstSlVbUPM2LCLrqpAwcuskh2R5sEZBXrxeXgx1srFd6J1+XnhTWzLQTxO+LbmWPNX+
	uh0GcV+Zl7tsFbJ60ZPsGcqr733J4cUdhu2z+QdC1KAOn8fxBC3eUhhb9xisSM0iahI87f
	iCAZY/42ikDrEjaKBzdKKXuO8g6WPk0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nR4Ac5VK;
	spf=pass (imf28.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767876098; a=rsa-sha256;
	cv=none;
	b=l2WbEl6I+pSlHIwIJ3prC+JzfAVuHKEUzLfq1MRmjiO6qDxuImhJ6H66skQWTG1dq7Npzj
	lJamRIAPBGU/24508eQeaFV/hZ8+XkYdnbgycmjWjAJiU2ZhXS0K2Z1mS9AGBFBv54vZWV
	gXFnZYCkjbSNLQnjTIt9tw/5lAipuuU=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-81dbc0a99d2so5241b3a.1
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 04:41:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767876097; x=1768480897; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KxCHi6k3BTAzPt+DiJG3qCrr7/A1NponVT67aJszG2c=;
        b=nR4Ac5VKkY5hEC7fnVTWCYg42tFCmCPQHh33w7mYfJfGL3KqsxfB+njLghQBVWZr2A
         fAMgGro5EpIoK2YkW5NcZMQ5wYybKXuBPT4Ahfz1CSgccgaUyneXVoLZkgby/2WN4Ppr
         4BQufMgqbJmg4Ok18+PDh4PP/3DgTIsMp4tVuGLlSlB1fCBt7NhE3FLeFCwvaAv50TxP
         6bLOPQJ0awghozWuPmGE5/jYLFuRHFe87WEa1cCtSFLvzpTzrAlTrgAPnAKALiNS1XTz
         mqL9xRLKENGsvtU31/YeDjGgIiORHOhgofCWrVmiwv8dicORidYqE6uhluDBvMZ2aCdg
         +qZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767876097; x=1768480897;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KxCHi6k3BTAzPt+DiJG3qCrr7/A1NponVT67aJszG2c=;
        b=SUvvRqFLj65ZhFlboNn/YyAFRFVLW6f/w/fSmwR95i1TvF39sKW7VrVvMbzHLZI7KM
         epPmcrshoqZZve8bRVSPLxAStNb6p6/tj6suocBtK+GAs0ocGs7Lq9IPxZ07SK64XAXI
         ui5eCYBxljJMSMcVzlXAuGLA4U0XFRhwdasUXRLJqp8efIVaT5sqFafvL64OJG+mkJfs
         tlbgx1PEatrBQV2ypmNYF2lhsmmoSH/MsG7bdyMvTZ8ggki/2VYEq4EUT3u2SZ+jfs6v
         CmixB5OBUDgr1ujHdNGgtb05+AbFzSodMynpMQ9Rj4Y0psccV9oSEyOwdEvw9icVeH4o
         mh/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXEFQL3hhGCLFnqc/LBhRpZpENS8ZA9bbJhV1xMMKvduaCWjoeN6ZIL0gpSoMsNh4ENx2C/NGuTIQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4ZXrcT40+ikIjtlVtHwzEcO+A/kFLe+BrpXSRAedhouJfHIhP
	yEUBuAwl5ROlQvpweu0YUdY5BvkN/WcceZRo/wIR/T4DV3N4KYg7/YU7
X-Gm-Gg: AY/fxX40710v9qCoVJ98g+RfRLJtf8FWqW3g2WDT8lwajouBBBn6uORuHHqGNM+6XcQ
	kT6GS7zmk/BpsRRH/RQIPvMMp9kbKAxGmKPIknDHyvIPgxFkcFygx9ITefnq+WfmBgR0RUBjrMY
	jSI+0Y9UacM8pyGkJfLMHta+fPPIHuLTCapLIKlnLzFo8xCKz3V/WULOwg+fSvAQtieaMqh5vWu
	UJe/l0YzK2tSoFTVGWTntByA1CJ+V6BpZAhrhkhno0l68BWkupgQ4y5+e7Ev9BgfkxkSwxybP1G
	45aynHTLM34chQGytVlQIW1eFw51INW8Uh4uR3FYsUBXXEkt3PrxUBkxaUXiX2hBwuwDjRQtRa8
	9l4uoGJAFfhL362faxLr3yoZ8RC+NqXMUFkH5G1kUvpEc6EZjiwiiWG/bklga6GvouWGe2zDJcV
	oRK7M=
X-Google-Smtp-Source: AGHT+IGFPwjr7ZXnjyyaZYR82RM8pvdbLcnYiqzU0HmuuaMkGXIPbglQBcvVQCJYW+fo7AOVgmW9fg==
X-Received: by 2002:a05:6a00:440a:b0:819:4284:365b with SMTP id d2e1a72fcca58-81b7d95f67emr5867252b3a.7.1767876097266;
        Thu, 08 Jan 2026 04:41:37 -0800 (PST)
Received: from localhost ([2a12:a304:100::205b])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81c96d762f8sm2423491b3a.64.2026.01.08.04.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 04:41:36 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: [PATCH 2/2] Fix an AB-BA deadlock in hugetlbfs_punch_hole() involving page migration.
Date: Thu,  8 Jan 2026 20:39:25 +0800
Message-ID: <20260108123957.1123502-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260108123957.1123502-1-wangjinchao600@gmail.com>
References: <20260108123957.1123502-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ezk57b7xxbuzajcgii3zqbhtk7o1tknp
X-Rspam-User: 
X-Rspamd-Queue-Id: 80C7CC0012
X-HE-Tag: 1767876098-274047
X-HE-Meta: U2FsdGVkX19pppTTKFnPi5arTFoC5VrJLyg3y7k6gHdIi4e5Y8HkaZKQRk47APe8858ON+QV9grbggJwIpzeSHkuknC1n5ys4scTycfmPzaelDwCjKNe0xwbkqNMLBr/roM382nBRvD3u91PK3SI5YDSFVMFpaGDBOlgTYEYh/Qo1fbQYSB+ULmN9phjokd9DsmVugIoEt939ZIDeQWDfzXt+TOsdG/Ng0G5lIatbxiss/nv9ChqXuquKFDW+7euENr54xNNvxy82WiyrD7amt5+zBkfIxDRzzyo5IR7MqfajeOWDOHo2x2yw1c05gAgA7lvzCB2Cfj9MyxR/P48TIV+J1u5Hluxy4RszToe/lLUntIo2edMhk99cPXmU/TIw/WiEGMyWZpjnjXlmmVboEcqrWzHKrjmsAU6RVxUbaN4r0i7sVlJXmLZm8+UvbOhwOyvYAj4hVjw8OUEehGMFfb414ygx5A23KZWl4+XGu0YvWNIRVmMIKiAhu6aIX+3N/lZlCWc+Z/+RVQp6JD+3sDXFD1p6p8T4guqqPgW/v8gIRWz5Vv6bKNKzAX6jnvO6sAAoNWBx6hQDW8UI/G3V/+bCH38vF7IGdx/JmbPODCZSW/Q/dY6gTBs3hKY4Ghyp3SnUDFzLfVK+aAFCnjRgdBj19X3AAHfWp+K3H7xNg+JJeaj7oLc8KSmCErJ+a8OALHObUldU1G1aVB9KoQVjdqZLBf+0lIXhJadizzyKtzLyjFX0YlfJqBKZEVxgrw94l00ishn3Na5WfcE04Iz2N0okpmj8EltxZFhSd92R9S5Ge9PkJu8W0+nwnLqP0N1l1PuHr+iGsUUcGHETL0zOtZFO/4QHfQ7FL1Qyoxi7RkaLBbOh4+g1EyUmocUjkgUipXKaOo0SnUYhNJtr6/dprYFxr+Zc9GbWoPsyQYDE0h5rl9KhROY+JYIVWv/RwghMqWKFaB27oq9Xi4liMz
 H+1mkiXj
 C3myU7inrI5WwJMxlhB9y5F/25ZmyZtdCKQwDou7mgxKM4N8xmpDCL16HsdH6VPwWvLaKgbZtnY+6tMhzkT7ssLJZRBA0XYgWoIcIYAIF0bq4CnRBsKIfRvQ49hVoCKF27mjj1lOWl4RlnYMqb4jeHZM69zzwYgWFK28sxqfNxVI+GgO/GEtOno3gPCFZoRH3SEdxFMf7uea6f+EWGmAfOPUGKXJ8mXhGiEvGAZe9ZL7Yy2M6levp5zAKntYX9wOj/UQw+oY1zm9hVoc5XhTUnSUaUZRSC5CnZIlQXnmQF2Ltu/dQCtSbpzxl1jR2YXgFBAS+K33RaMgUa/OCgFzDlPm07hwA4Zlhd1TFNv4KdXXPT3lik6kfzjzpZSPQRuxR/jMuKtJOutpyee3T5O6IkFjYsfTdTdn/mURZF8PHrnWpDhR80CPlxXnlLjXTCi+AxE2OBDw8VmE6sA94h8oRyKc4OLBLHYSuFo0IcN5nj0cdTW7hRzj++Xnmp3mTYGcmR4UF5i2/AZf9wG/7I8x47WCQ+7kWUjDEU7HgX2gUBq22drVGNQA1UM0dkbWJMvSccg2hnTeW8lNOB5BTjHTjx12pV+1WfpVBeqrNS4D9z2NQzbUIwZRVHGHu+h/zZyIz+PkCTKPFByiZXTohalScTVugH5htUYMnGtDwYkvnDYTELWCiZE5wDX9VKfhHUGMzMh+Js6m9RCGCvNE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The deadlock occurs due to the following lock ordering:

Task A (punch_hole):             Task B (migration):
--------------------             -------------------
1. i_mmap_lock_write(mapping)    1. folio_lock(folio)
2. folio_lock(folio)             2. i_mmap_lock_read(mapping)
   (blocks waiting for B)           (blocks waiting for A)

Task A is blocked in the punch-hole path:
  hugetlbfs_fallocate
    hugetlbfs_punch_hole
      hugetlbfs_zero_partial_page
        filemap_lock_hugetlb_folio
          filemap_lock_folio
            __filemap_get_folio
              folio_lock

Task B is blocked in the migration path:
  migrate_pages
    migrate_hugetlbs
      unmap_and_move_huge_page
        remove_migration_ptes
          __rmap_walk_file
            i_mmap_lock_read

To break this circular dependency, use filemap_lock_folio_nowait() in
the punch-hole path. If the folio is already locked, Task A drops the
i_mmap_rwsem and retries. This allows Task B to finish its rmap walk
and release the folio lock.

Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com

Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 fs/hugetlbfs/inode.c    | 34 +++++++++++++++++++++++-----------
 include/linux/hugetlb.h |  2 +-
 2 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3b4c152c5c73..e903344aa0ec 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -653,17 +653,16 @@ static void hugetlb_vmtruncate(struct inode *inode, loff_t offset)
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
 }
 
-static void hugetlbfs_zero_partial_page(struct hstate *h,
-					struct address_space *mapping,
-					loff_t start,
-					loff_t end)
+static int hugetlbfs_zero_partial_page(struct hstate *h,
+				       struct address_space *mapping,
+				       loff_t start, loff_t end)
 {
 	pgoff_t idx = start >> huge_page_shift(h);
 	struct folio *folio;
 
 	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
 	if (IS_ERR(folio))
-		return;
+		return PTR_ERR(folio);
 
 	start = start & ~huge_page_mask(h);
 	end = end & ~huge_page_mask(h);
@@ -674,6 +673,7 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
 
 	folio_unlock(folio);
 	folio_put(folio);
+	return 0;
 }
 
 static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
@@ -683,6 +683,7 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	struct hstate *h = hstate_inode(inode);
 	loff_t hpage_size = huge_page_size(h);
 	loff_t hole_start, hole_end;
+	int rc;
 
 	/*
 	 * hole_start and hole_end indicate the full pages within the hole.
@@ -698,12 +699,18 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 		return -EPERM;
 	}
 
+repeat:
 	i_mmap_lock_write(mapping);
 
 	/* If range starts before first full page, zero partial page. */
-	if (offset < hole_start)
-		hugetlbfs_zero_partial_page(h, mapping,
-				offset, min(offset + len, hole_start));
+	if (offset < hole_start) {
+		rc = hugetlbfs_zero_partial_page(h, mapping, offset,
+						 min(offset + len, hole_start));
+		if (rc == -EAGAIN) {
+			i_mmap_unlock_write(mapping);
+			goto repeat;
+		}
+	}
 
 	/* Unmap users of full pages in the hole. */
 	if (hole_end > hole_start) {
@@ -714,9 +721,14 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	}
 
 	/* If range extends beyond last full page, zero partial page. */
-	if ((offset + len) > hole_end && (offset + len) > hole_start)
-		hugetlbfs_zero_partial_page(h, mapping,
-				hole_end, offset + len);
+	if ((offset + len) > hole_end && (offset + len) > hole_start) {
+		rc = hugetlbfs_zero_partial_page(h, mapping, hole_end,
+						 offset + len);
+		if (rc == -EAGAIN) {
+			i_mmap_unlock_write(mapping);
+			goto repeat;
+		}
+	}
 
 	i_mmap_unlock_write(mapping);
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4..ad55b9dada0a 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -814,7 +814,7 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
 static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
 				struct address_space *mapping, pgoff_t idx)
 {
-	return filemap_lock_folio(mapping, idx << huge_page_order(h));
+	return filemap_lock_folio_nowait(mapping, idx << huge_page_order(h));
 }
 
 #include <asm/hugetlb.h>
-- 
2.43.0


