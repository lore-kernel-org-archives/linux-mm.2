Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B1C10BA45E
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 07:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2BAE6B0096; Sat, 28 Mar 2026 03:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DC4E6B0098; Sat, 28 Mar 2026 03:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F2756B0099; Sat, 28 Mar 2026 03:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB986B0096
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 03:58:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2814459A70
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:38 +0000 (UTC)
X-FDA: 84594719916.13.5A7306F
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3DCE5A0007
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 07:58:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=scTITBLY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774684716; a=rsa-sha256;
	cv=none;
	b=2RI8BxC9PpcF43Lad7EXcmWBXEYLF3vtDuE5Ih2rnwCANvjq1myEPdQtyoQ4wo70gmXrCm
	R9mhsYEGUa++LWpSyIrxSwEz68DQxvtF1PHVXTFyFEdC72U7DF9EKQzL6boZPchugRWQc1
	ki4w8HDQJ7kiUdW6Isw3exJ+nSY2Wcg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=scTITBLY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774684716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tv2uVA1Otfe2EI/MF1jtBSFIcG71WSWINz1C06meVug=;
	b=GVvmeY/AjSxAZJW8Zbvs3wjuvg+pQSqJUbxU4Vjizg7x1rMG1ciTe+aFsiH/eLJbYBCd7H
	+9LY/2KWlxJyqT1x8AUnveC02c4KHr3I9iGz5dbim9pYB3UgIqhiQtRX6Wg9PVC/VCu0Yc
	AKYZGs0HeKBqaNkwAjilFlIc1qjCqfA=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so1142195a12.0
        for <linux-mm@kvack.org>; Sat, 28 Mar 2026 00:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774684715; x=1775289515; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tv2uVA1Otfe2EI/MF1jtBSFIcG71WSWINz1C06meVug=;
        b=scTITBLYUrD8+AGYf+v8pVs7b9TjdII17dvfeMh8pixxxcLlIVBcGubtVwS3cTfNpf
         9bZucAkbOZwF2H6qJ5mr7S4iHGQ2j72vQz/2+IFF+2lRA329VYpXLgRLv/vrWcAiGAqo
         ojCyRubyz040pysDmEk0F3xDfWGWCX6sRtJJXtAK5C/aCuMSfbGbYuVJbK2mXJKK7hGW
         SIw+Ro1alD1IiNONr5r13d65to6Zi5KwsTyI26jE+dEfXszXfORwVQWmIimgQcEhYjBG
         tLrXYIdx1QGuIyvKBfhOl35SAXFni8JgLXjCfEgPtlzhxuadgUncEHKbb3+dFGUZTZFz
         lNeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774684715; x=1775289515;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Tv2uVA1Otfe2EI/MF1jtBSFIcG71WSWINz1C06meVug=;
        b=lcgGVDZrmN+nedqj3369mgsQMJpWg8V+OTHtXXHJJ+LyppBbpPljQKt2jozFaogGlL
         UzJ7M6qca81L5VRS43Q+FWIlpF1iSoK6Gswa8BYeyda3erd6qg0oW/xDaNIfrnoFFxX5
         zcRJeuTMJs2JNt97unHh/wBtDH2Xw84vRqgP0NKB0mgelop9nH24ksGycEiKLu4yUb9P
         wzzncT6n5bnBVPDFBQKAHiw+WJ9g7Ylw1ldVN2X4C4g8S+0Ri2RuibbRKCnG0cPsOCVs
         2S7ltqhqtY4OQlDNQ/sBFnFjQtWp+zgnRsLcsem0FIiXm93coEUms7ZtKB6F2rAl+fSa
         qaMw==
X-Forwarded-Encrypted: i=1; AJvYcCUtPiy2HU2C8Ck1CdcRZTS6siljAPxnG0wC2CIMfzcFwW02amKwHk5Nm8gEXWelCr6TjLGp9W8N2Q==@kvack.org
X-Gm-Message-State: AOJu0YzZ4oX86yTukX4837ICnDpHGNHBIZ5zWFgJeX+WcugYPjRwMXhZ
	Xpo5hVXmaC6X7NktiCATG3uv0T+9uTaSYrJadLLv0VcyjHBALqYqUAaH
X-Gm-Gg: ATEYQzwoGm+EjM7IC9ftUmRJTvynr5DDet4HpAGTDELSkT1KzSR2LtOW4FYy/j2S1UW
	IQAXde1q1Y+T/gSICbGGEo+B34lO7FinzjmKJcfEeCUBwhTolC50+elOTnaFmZXkHwtiWTPGlTf
	0+sQJv7PJRlWU0MC8HhkDwzNvzVetLj1fAqMp5MN9RkcF7nAXTbjFLv0vHvkg/3AbcYAXswYbG2
	OTcOc8cJEGrXezqpfqEuAOOrYBiIIQuesnJFdoXSb5AvC8tAW2tq1+mHMZdYlvhtMbSPuLrO0K0
	ZBaUAXWuaUybDAWhl2Vde3Y8iOHXcvcNoXFzuNSURa+YOXmMh61NC5vixz4O3IwKBuxN5MHj+gb
	VLfo8WLsH58zLSCy7GTJW+lhrC7HcNuOfHDLybNh4eKRAofc7NcraXvTERnbNRXE86GLxaYIdgh
	d4DoWSqHJDl1F4w+GeVPWI+H6DJCtw6boXbyJKpvMwI8Fi2oFlnysffBna3+LAj8qHDMnsNdc2F
	q/M2XSW7Y27dJ1s
X-Received: by 2002:a05:6a20:72ab:b0:387:a311:3825 with SMTP id adf61e73a8af0-39c87b7c686mr5583794637.61.1774684714881;
        Sat, 28 Mar 2026 00:58:34 -0700 (PDT)
Received: from Barrys-MBP.bbrouter ([2409:8a1e:2e90:6fa0:903d:bf86:180e:c711])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82ca84644d9sm1448312b3a.13.2026.03.28.00.58.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 28 Mar 2026 00:58:34 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Sat, 28 Mar 2026 15:58:11 +0800
Message-Id: <20260328075812.11060-3-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260328075812.11060-1-21cnbao@gmail.com>
References: <20260328075812.11060-1-21cnbao@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3DCE5A0007
X-Stat-Signature: 6qgpjw1niw6okgukcb47zsndwamn4a79
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774684716-486097
X-HE-Meta: U2FsdGVkX194AQQAY03M/4Q9oYEK+VD6Ew+dfZ+eG5FdonKrJHokdM4qDWTF45W+e37X4Dnv/MzzVhg0NxnGg+hBuGWaqrw+jxwHyUG8gDla2FbkfWxuo2PI8SM3E9DXM5QZMOrIKJgrp851Ppvfyq4z6Plu6T3+n8EjR26Tg72Ni4b51SRqUko42qYY0C7UA0/mdgxdDwkssc+BpDN9aPfucl1YN5Qawt+Uf3ND1XLCFggWfz6A1QblU/qqHvw3rR0EFZLCGllKjhxzaUWHdqfiNKHvZDBQGuUPCrpVicsx0LFV84ViZmqcUItnsgfwyu4ewFoillGMKuRQz7+RwIFM7p2Ay1FGr/yjcOz7Jg5frbGAgvqNq4kq62Vpu178pb0uS3Pp+ZDuHbcNOkvr0RwNjBVxApxTod2ENi1H/Lfgj6JD6RUBSiMuVti8JNHP3yGPEbiJSUUoAsWSe2L1uC6kWznif4O0pUwToxWjWFs1z2OI8ZuUoEpGOTdZptiRDTytn//B4l5fNRQAbX5vO7XZpe5mn+VLgSwA78zdkhBerKuwaMYRVIfZsLZk69oMLszwiWOTq9NtR0SGPtacbBry6cG+d8Q7DNnHpOids9zUIsIhPfJXS781Yi7I1iA/w98mrfAm8aBMCJ/JQzPLaMPs9BwZGd+C55TJhfC0exQ07OY4pLBp/hd+A6difT3Qk+TfmwAKps+JUqQOYvo2sccT2JkgiL+KskrItw4qqgx5IPhdbbsF8AqltyvJL79FSxqbr+0/aUOxDSI2efLNv+CH3Wx6S/IvcN5u2jtWOZ/pq5lnVyi/IT6aHBzdUdCr/udc0NC3pnUNzOqUPJxbmdOdyxK55zjTb1DtKfTf5Cu5G4JbR9RxHKryX1lSkf0fY4w9s+zSctUYOW3DMDMtKQDwV7OOB0HpQ1unFPROpUb4lciIMVayGFalerNWiESfBw6TOucfUtsl8S4qObs
 bXHhNwuh
 Bn/K5SeKSDDn7adjDPB+O40H1N7viZnGkbwf3GVpPcYxkAT8XL/JKiTE8bdrBFOs3EbLTSiQp41gdbAEBbsih51sC9Qf1k03jBkLzKzJfuOxlE1KmkkTuoCO93O1aYTTOE+iqjuaGlnE2N8PbqbEQQ4cfgN5N5cqevscfd0HvzlPOA/Ta0eYxoBquTY1tUpvVifYNtm8Pma7Jev7cnxUUXktjm/J9HJn/RL9PimFQaBMGJL2ptn0yceRoMTN+Ik0I4JgJR055vBy6VgKGUIV3JYD4B4ydhMlufQLLtw7JQx3yp/fz4C5zzHf7QjY2IENKio26hxV+Oe2Xosl9tB5L9/vT6zJjevr3xKuaY44FD1+vagQEGYrmdAm/1YPMx/bXh3jWZ27aJNgV4GAQJAt0vSiGtVsch0vXg78JeOHAuvxJ7vroauHhSRuQ4CrFeqr9vrFtwk8VjoYn637Zz60cf9d6mS6d5zp20gFbiNVmIDp8V1QyNXcO0hkEe+To9lC6RRWurSubyQgmSAmfEhNFxBnlAGzJglv8I0DTwGU08ev59TCefgSIWKSFOL9+tYrR88FspDZ70rKzdrP4tIhd4sfh6e6XEblArOPWgwNTfMlp4eA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baoquan He <bhe@redhat.com>

This simplifies codes and makes logic clearer. And also makes later any
new swap device type being added easier to handle.

Currently there are three types of swap devices: bdev_fs, bdev_sync
and bdev_async, and only operations read_folio and write_folio are
included. In the future, there could be more swap device types added
and more appropriate opeations adapted into swap_ops.

Suggested-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Baoquan He <bhe@redhat.com>
Co-developed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Barry Song <baohua@kernel.org>
---
 include/linux/swap.h |  2 +
 mm/swap.h            | 10 ++++-
 mm/swap_io.c         | 99 +++++++++++++++++++++++++-------------------
 mm/swapfile.c        |  1 +
 mm/zswap.c           |  3 +-
 5 files changed, 70 insertions(+), 45 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1930f81e6be4..b52f30dad72b 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -243,6 +243,7 @@ struct swap_sequential_cluster {
 	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
 };
 
+struct swap_ops;
 /*
  * The in-memory structure used to track swap areas.
  */
@@ -283,6 +284,7 @@ struct swap_info_struct {
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
 	struct plist_node avail_list;   /* entry in swap_avail_head */
+	const struct swap_ops *ops;
 };
 
 static inline swp_entry_t page_swap_entry(struct page *page)
diff --git a/mm/swap.h b/mm/swap.h
index 161185057993..219dbcb3ffb1 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -217,6 +217,15 @@ extern void __swap_cluster_free_entries(struct swap_info_struct *si,
 /* linux/mm/swap_io.c */
 int sio_pool_init(void);
 struct swap_iocb;
+struct swap_ops {
+	void (*read_folio)(struct swap_info_struct *sis,
+			struct folio *folio,
+			struct swap_iocb **plug);
+	void (*write_folio)(struct swap_info_struct *sis,
+			struct folio *folio,
+			struct swap_iocb **plug);
+};
+void setup_swap_ops(struct swap_info_struct *sis);
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
 void __swap_read_unplug(struct swap_iocb *plug);
 static inline void swap_read_unplug(struct swap_iocb *plug)
@@ -226,7 +235,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
 }
 void swap_write_unplug(struct swap_iocb *sio);
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
 
 /* linux/mm/swap_state.c */
 extern struct address_space swap_space __read_mostly;
diff --git a/mm/swap_io.c b/mm/swap_io.c
index 91b33d955e63..ad0895af6ed8 100644
--- a/mm/swap_io.c
+++ b/mm/swap_io.c
@@ -238,6 +238,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
 	int ret = 0;
+	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 
 	if (folio_free_swap(folio))
 		goto out_unlock;
@@ -283,7 +284,8 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 	}
 	rcu_read_unlock();
 
-	__swap_writepage(folio, swap_plug);
+	VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
+	sis->ops->write_folio(sis, folio, swap_plug);
 	return 0;
 out_unlock:
 	folio_unlock(folio);
@@ -373,10 +375,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
 	mempool_free(sio, sio_pool);
 }
 
-static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
+static void swap_writepage_fs(struct swap_info_struct *sis,
+			      struct folio *folio,
+			      struct swap_iocb **swap_plug)
 {
 	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -409,8 +412,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
 		*swap_plug = sio;
 }
 
-static void swap_writepage_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
+				     struct folio *folio,
+				     struct swap_iocb **plug)
 {
 	struct bio_vec bv;
 	struct bio bio;
@@ -429,8 +433,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
 	__end_swap_bio_write(&bio);
 }
 
-static void swap_writepage_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_writepage_bdev_async(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -446,29 +451,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
-void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
-{
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
-
-	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_FS_OPS, so the data_race
-	 * is safe.
-	 */
-	if (data_race(sis->flags & SWP_FS_OPS))
-		swap_writepage_fs(folio, swap_plug);
-	/*
-	 * ->flags can be updated non-atomically,
-	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
-	 * is safe.
-	 */
-	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
-		swap_writepage_bdev_sync(folio, sis);
-	else
-		swap_writepage_bdev_async(folio, sis);
-}
-
 void swap_write_unplug(struct swap_iocb *sio)
 {
 	struct iov_iter from;
@@ -537,9 +519,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
 	return true;
 }
 
-static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
+static void swap_read_folio_fs(struct swap_info_struct *sis,
+			       struct folio *folio,
+			       struct swap_iocb **plug)
 {
-	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
 	struct swap_iocb *sio = NULL;
 	loff_t pos = swap_dev_pos(folio->swap);
 
@@ -571,8 +554,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
 		*plug = sio;
 }
 
-static void swap_read_folio_bdev_sync(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
+				      struct folio *folio,
+				      struct swap_iocb **plug)
 {
 	struct bio_vec bv;
 	struct bio bio;
@@ -593,8 +577,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
 	put_task_struct(current);
 }
 
-static void swap_read_folio_bdev_async(struct folio *folio,
-		struct swap_info_struct *sis)
+static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
+				       struct folio *folio,
+				       struct swap_iocb **plug)
 {
 	struct bio *bio;
 
@@ -608,6 +593,39 @@ static void swap_read_folio_bdev_async(struct folio *folio,
 	submit_bio(bio);
 }
 
+static const struct swap_ops bdev_fs_swap_ops = {
+	.read_folio = swap_read_folio_fs,
+	.write_folio = swap_writepage_fs,
+};
+
+static const struct swap_ops bdev_sync_swap_ops = {
+	.read_folio = swap_read_folio_bdev_sync,
+	.write_folio = swap_writepage_bdev_sync,
+};
+
+static const struct swap_ops bdev_async_swap_ops = {
+	.read_folio = swap_read_folio_bdev_async,
+	.write_folio = swap_writepage_bdev_async,
+};
+
+void setup_swap_ops(struct swap_info_struct *sis)
+{
+	/*
+	 * ->flags can be updated non-atomically, but that will
+	 * never affect SWP_FS_OPS, so the data_race is safe.
+	 */
+	if (data_race(sis->flags & SWP_FS_OPS))
+		sis->ops = &bdev_fs_swap_ops;
+	/*
+	 * ->flags can be updated non-atomically, but that will
+	 * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
+	 */
+	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
+		sis->ops = &bdev_sync_swap_ops;
+	else
+		sis->ops = &bdev_async_swap_ops;
+}
+
 void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 {
 	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
@@ -642,13 +660,8 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
 	/* We have to read from slower devices. Increase zswap protection. */
 	zswap_folio_swapin(folio);
 
-	if (data_race(sis->flags & SWP_FS_OPS)) {
-		swap_read_folio_fs(folio, plug);
-	} else if (synchronous) {
-		swap_read_folio_bdev_sync(folio, sis);
-	} else {
-		swap_read_folio_bdev_async(folio, sis);
-	}
+	VM_WARN_ON_ONCE(!sis->ops || !sis->ops->read_folio);
+	sis->ops->read_folio(sis, folio, plug);
 
 finish:
 	if (workingset) {
diff --git a/mm/swapfile.c b/mm/swapfile.c
index ff315b752afd..c9eb95141c8f 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3732,6 +3732,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
 	si->swap_file = swap_file;
+	setup_swap_ops(si);
 
 	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
 	enable_swap_info(si);
diff --git a/mm/zswap.c b/mm/zswap.c
index 4b5149173b0e..9bacb1733e1c 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1054,7 +1054,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
 	folio_set_reclaim(folio);
 
 	/* start writeback */
-	__swap_writepage(folio, NULL);
+	VM_WARN_ON_ONCE(!sis->ops || !sis->ops->write_folio);
+	si->ops->write_folio(si, folio, NULL);
 
 out:
 	if (ret && ret != -EEXIST) {
-- 
2.39.3 (Apple Git-146)


