Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94EDE606A330
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fpCYP8x/
Received: by kanga.kvack.org (Postfix)
	id 7FA046B0823; Tue, 27 Oct 2026 12:13:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D1776B0825; Tue, 27 Oct 2026 12:13:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E9DC6B0826; Tue, 27 Oct 2026 12:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 43A426B0823
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4E1D120ACA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:13:26 +0000 (UTC)
X-FDA: 85368901212.15.D08D0C8
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 09233180009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:13:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="fpCYP8x/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSfoXLj/ogs4a9m4nRtbyh1f84TZ6iRvaVldSIlGJOM=;
	b=v4ct6e8BU03QwVcVO8XdFow4SsGaHxcSH5qe1KScSL2AgWmYJcZVbFOyJdbiselwTbXrMm
	GNj8XRkSFboEOC8hnvP6vufoyOAm1YgFsnOB5AkX23njb4F6qMd5laETWZT5juN+3pjEpl
	3QpWhBqClHdfvPJZZxkI+rImWF+je1I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="fpCYP8x/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117605;
	b=4l903snRmSNoQGtM6tiP4VXAbwppQH/v8snIj8crBtondWnirqtTn1aYaNmup7Uiest2yG
	ZsJv6YKsQcA08qnynA6YLVkt6uHSC4jx6d4CAEQ6CiOKhMlaq0yNlflgF3faXZkGe0sbiE
	TOCnNMo+kekk2jDw4JjUB76WsiEiYr8=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-ccce6d9abfeso98657a12.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117604; x=1793722404; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gSfoXLj/ogs4a9m4nRtbyh1f84TZ6iRvaVldSIlGJOM=;
        b=fpCYP8x/XIhG1r51knbGqDKrLYlgW1+haNYkrpVoDAq6aMOdAFETnNsC4+kh9JjKQc
         +q6VyuGf45l0Pauhz59v3IX7ClcT/ziL64fII33niLIfCWW6DSQDvpmjFHSgbZTccdaO
         nX3P+7Lw+GMsZTUoNtskSWSJXm3Wgw/hbkkROfSwalLTam+URB4rag7790YiF+t+nC6H
         Knu63rS77UDBJrpgZqIur+JNFcOOZVdUl1lm24NSGBeM/BbX6R6G9UMkzvlxYe4HWXdD
         CnTVisPn4vjYsW2MZUsSxV4iKrjuh3gGjNP6lLEDyLOys3bovUX0duQmuuqIMRdH3Asf
         XLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117604; x=1793722404;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gSfoXLj/ogs4a9m4nRtbyh1f84TZ6iRvaVldSIlGJOM=;
        b=ZOesrRtnEsbYZ8XXa22+bgU6fUbKB43jpAP9hE2VNBHp7uYdEHLRs1tQJzNEpb5RgF
         mNTPZQqlOs+/MMNiG0AcCIgxGnRKPtQ2n2YHsXnXoytbQfcyqsFHUXcCQ3jnpvGmkgSO
         BenCuR5/kS99Y9FNfReKyeSlu7WGtiyPlltoTet4uxPXyhwv99Kp2w13HXsYEs0/E/jL
         zo31nCqSrHsdBZ3nKWNiNuNKsh/kLnaWhnbXX28E8D4mLNSgMjizG2BfhwGldZapuH57
         H1Skv/jMyhLNS4SP6SEejzRRpuZllqUNkxhqeEqwABhEXItmiEEPl+YiOLXOPD/ZSftO
         Ww3w==
X-Gm-Message-State: AFq9FYLJWE91rMVoRoHv1SIKq02/gINxFaZiftaGkXfWt3zNX8bgTSQP
	CXm5El49UStbHj51myUTRYd3SZupkveJwMbsoOU/GHa4pK0hIO3zYLJykC7I7Q==
X-Gm-Gg: AYBFou1LEE2X0/8dfY63StY/odeoZIVAOmf0t+Wi8yyt9GG3x34OnQ9bTAJmOTYYY49
	FoynRXclAR2vVGo/g3nXEpKar6NmPssOr03vjHuiKHVruugJBaY7Hb7EPB6qAfvgG0xoIgHb9Yo
	Rk2fc1NPZViOfYdHqeP51g29EzitqrCtjRLKqRqdQQKUPHHr/54ehOvZrNqIBJsbc9EW0/O1vXn
	KKAhgdm5Yp7Cpoaj1uS7WLtdANhwnhDlzb+gEC4DiLE2Jyd77X9vZyRFSVsVjpfZqVaXL81OC7h
	8Dbc3dCs8gzp6DdqNB/XR4GTRxso3RSrI994P++6t1fU0cBCkh2auL/XK6EcAfDrGObTibPqzQW
	Z/1OVEOyjxU+h4gs3JSrlD65rPJUwUXAqugtI1L3IiypEWFMp6M7JezRYiUzR+BbpnYZBMj6Zcw
	WR+1QPUeFNhoC9UKZO56WJAPbFlf+VSEAerrPwjgHbh8vTkJOA5TX91t1Cy1NK84Xy8CvrtI+Sv
	mCdge7a6PStkZZ+He240drEW5t2DktMV2fzt879zoZ5IU4SkAKHdw5rFBD/P+U9ukz4I07vVINF
	UQ9B9hsVg8NvFkW5EeY=
X-Received: by 2002:a05:6a21:1bc7:b0:3e2:3bc5:bb6e with SMTP id adf61e73a8af0-3e7bfc13b47mr7649508637.51.1793117603789;
        Tue, 27 Oct 2026 09:13:23 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd8cccd4cfbsm3233902a12.28.2026.10.27.09.13.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:13:23 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 16/18] mm/swap: advance the global queue cursor directly between priority rings
Date: Wed, 28 Oct 2026 00:12:56 +0800
Message-ID: <03c9f51439f1b457d7f9af40d6bbdf846f2776ed.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 09233180009
X-Stat-Signature: qo8ogtbmxs5qykjdhs6xaso8oki7ywie
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117604-498939
X-HE-Meta: U2FsdGVkX1/MSVUn/acj9LkKyINEwS26q3LKXInAkoT5IjHodbyrIShe7Ca83FpSDxgUFEtGJlkbfrwpBO34yA2TqIZjQhUE+YCDNUD2y94uOYsYvL4os/5VPc8jFg6jE5Z4554/X+6UgsvXhGnTprbYkVPgl/F40zWcb00byySHLfr6m/rGJqPonTw7IiBeSS0qYEsNHRSBCN/rcPEGOGn8KxXyuQ0IOwv9uzRTZFuhNFIVQrTXY280uXP/nEs5T0CKrS3QSbD8ztjkIylv2LrwAmIHJRLgXaQtx1ggZqrC++cKA89wIc4TegE9wlbfm2Sxlt5Nk/klrYZXRu5iZgPo5YlSdGnBDVjcov1PPsq3419dtE2Y4MlObw/U9Ub/VQAAGujMMeJUbRYWa0bPCrkHBZmNWPpYfsGyLPMaaftf8tEs3G6ilgN5oW41h4Z8KsR8s70Rg5rDWIqvORX0RKhj4GqYmIPqZVR89dkLSf8PYGdfLRHOlZVscoywRvnu5+ymA/fZD6dldrnVWbgTwXvD78s+xHHjMqrv3R++E6UGX3ST3CbW4QxyZcGdKO6OqNO6BShUWcaljmrfo9PgdDh7pmwLek/ban2EuR9uwvBD151SdSRG7kKm1MQvdL2nAb0X6C2VyCifBDu19B9QmmI/cv+wkHk19W9y7BvUXnz2BTgJNJPU/uYKITattybJ0Y7gv8qJ98qjlhGGGQF8fxDKnH2JYN9Eap/OTyXZ1A1LyJLGQiRPwY0tdrTSSIdtn0KhtPdf3l6iXA/WZNgU3EVhlG47bFhlwodQt21p58MrjKcn73t1xi9zimhUdCdfsENztjgxU8U0U69/aD7l6nC/0Rw8ORsTILUa62eauxi3CXYFCaQOMl3qwL3k/JhqCwl6Oe/3s9QWVOHau0nF7pAzezuPaXnO6FppAKqtPYjB/Oww049YLsLwATghQeoR7IdKa6bycwhhyMqYSQI
 edU4EIp3
 nQgf3TnBRAR1ybZeSIy8cuGUc8B2BmZ5Ej/rBmmuzwTK0jkHWIyjEoavgVQxObFNg3y73PiQEp2iDDA5zrPR8nK86aQHYXvmOtCzpRqviC6aohdhFeICuTEbIQWI68zd/yAbKVMLCsIs/T+exrs+G5rX2BPFEs36f0Z8Vc+52NOPO6Mf2q9fcgk/SE7LZ0tEPSz9RIQ6RM90irvcFgiQg5NfknBTBw4M2iMzyhBpNov7xnzAayEUEs8AyNipO+UrUKkNtOU9jGPs10TXrURxUzAZIRoRR8faFO2egdJZucJmDzyRwuuCuTByjxT2Hf6EPlIpgB+oRVjuR+CAzpjiENN25h8wqU6zOlFtDuv4JbLBejHXPC6za21Ir8g41VX+XlmOE42IqGrFUPEYsiTfnOmmbqJd7rkB51qHixZiYPp4m6j35+LFMB9dV+DxcU8YrBt63e0AdWtNPC0zV+hgSvULqkjj9VwjKzmNVpAiZWH4W5GY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The allocation walk previously passed a total retry index to the selector.
Each retry translated it back to a priority ring by scanning from the
beginning of swap_queue. Keep the ring index and the number of attempted
peers in the task-local cursor instead.

Snapshot the starting device only on the first visit to each ring and
advance each peer exactly once, including masked entries. Preserve the
large-folio same-ring boundary and the stale reader-offset correction.
The selector's complete walk is linear in the devices and priority groups;
device cluster scanning and availability updates have their own costs.

Keep the topology read lock and CPU migration protection across the walk.
The global selector uses only existing priorities and adds no per-memcg
device-selection state or ABI. Existing swap charging and limits remain
in folio_alloc_swap(), whose failure path classifies allocation errors.

The walk no longer returns an ignored internal error to that caller.

Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 49 +++++++++++++++++++++++--------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5b6492b1bdc6..bbd114f043ab 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -194,10 +194,10 @@ struct swap_queue_reader {
 };
 
 struct swap_queue_cursor {
-	bool valid;
 	bool ring_only;
 	unsigned int ring_idx;
 	unsigned int offset;
+	unsigned int nr_iter;
 };
 
 static __percpu struct swap_queue_reader *swap_queue_readers;
@@ -307,28 +307,32 @@ static void swap_queue_install_readers(struct swap_queue_reader __percpu *reader
 	swap_queue_reset_readers();
 }
 
-static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter,
-						      struct swap_queue_cursor *cursor)
+static struct swap_info_struct *
+swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 {
 	bool rotate = false;
 	struct swap_info_struct *si;
 	struct swap_ring_iterator *ri;
 	struct swap_prio_ring *ring;
-	unsigned int dev_idx, queue_idx;
+	unsigned int dev_idx, queue_idx, nr_iter;
 
-	if (!swap_queue_len)
+	queue_idx = cursor->ring_idx;
+	if (queue_idx >= swap_queue_len)
 		return ERR_PTR(-ENOENT);
 
-	queue_idx = 0;
-	while (nr_iter >= swap_queue[queue_idx]->size) {
-		nr_iter -= swap_queue[queue_idx]->size;
-		if (++queue_idx >= swap_queue_len)
-			return ERR_PTR(cursor->ring_only ? -E2BIG : -ENOENT);
+	ring = swap_queue[queue_idx];
+	if (cursor->nr_iter >= ring->size) {
+		if (cursor->ring_only)
+			return ERR_PTR(-E2BIG);
+		queue_idx = ++cursor->ring_idx;
+		if (queue_idx >= swap_queue_len)
+			return ERR_PTR(-ENOENT);
+		cursor->nr_iter = 0;
+		ring = swap_queue[queue_idx];
 	}
-	if (cursor->ring_only && cursor->ring_idx != queue_idx)
-		return ERR_PTR(-E2BIG);
 
-	ring = swap_queue[queue_idx];
+	/* Consume masked peers too, so every walk remains bounded. */
+	nr_iter = cursor->nr_iter++;
 	local_lock(&swap_queue_readers->lock);
 	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
 	/*
@@ -336,9 +340,7 @@ static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter
 	 * iterator can move between retries, but the cursor must visit every
 	 * device in the ring exactly once before falling through.
 	 */
-	if (!cursor->valid || cursor->ring_idx != queue_idx) {
-		cursor->valid = true;
-		cursor->ring_idx = queue_idx;
+	if (!nr_iter) {
 		if (ri->rr_counter < nr_alloc)
 			rotate = true;
 		else if (ri->offset >= ring->size)
@@ -1794,29 +1796,25 @@ static bool get_swap_device_info(struct swap_info_struct *si)
 	return true;
 }
 
-static int swap_alloc_entry(struct folio *folio)
+static void swap_alloc_entry(struct folio *folio)
 {
 	struct swap_queue_cursor cursor = {};
 	long nr_pages = folio_nr_pages(folio);
 	struct swap_info_struct *si;
-	int nr_iter, ret;
 
 	percpu_down_read(&swapon_rwsem);
 	migrate_disable();
-	for (nr_iter = 0;; nr_iter++) {
-		si = swap_queue_get_device(nr_pages, nr_iter, &cursor);
+	for (;;) {
+		si = swap_queue_get_device(nr_pages, &cursor);
 		if (IS_ERR(si)) {
-			ret = PTR_ERR(si);
-			if (ret == -EBUSY)
+			if (PTR_ERR(si) == -EBUSY)
 				continue;
 			break;
 		}
 		cluster_alloc_swap_entry(si, folio);
 
-		if (folio_test_swapcache(folio)) {
-			ret = 0;
+		if (folio_test_swapcache(folio))
 			break;
-		}
 
 		/*
 		 * For large allocations, try every device at the same priority,
@@ -1831,7 +1829,6 @@ static int swap_alloc_entry(struct folio *folio)
 
 	migrate_enable();
 	percpu_up_read(&swapon_rwsem);
-	return ret;
 }
 
 static int swap_extend_table_alloc(struct swap_info_struct *si,

