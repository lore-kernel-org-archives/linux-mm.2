Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22059606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=p73C2CNC
Received: by kanga.kvack.org (Postfix)
	id 3201D6B05D5; Mon, 23 Nov 2026 09:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0BE6B05D6; Mon, 23 Nov 2026 09:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6156B05D7; Mon, 23 Nov 2026 09:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6A596B05D5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:20:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F47EC08E8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:20:01 +0000 (UTC)
X-FDA: 85466593002.08.9E1AF04
Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id B1106160007
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p73C2CNC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443599;
	b=lcKJXHWELQjo63Rryzz0ZCA1B7mhEVIpjcwqGg8gI5xnLkA2ZdNxownH+CRK9RYLLNYLNb
	gSd0BlYwuh1Tlf/6cD32il+qIuvJMlmVWGPVyTHvk1qKFBhzXxBcsZ0aJhgNdZgWUxyc1w
	haiurYU5xmsJEuIiovSlVrpPuGR1R54=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y226DZkwLHV/0wLned+bdA2tSEyU1JvBKnaVWIVUoR8=;
	b=uluDrE8Mdo9xtXL6icllqYaH6Bdauc9W9HmsGJ1ghPdw35PAGGh2/iAdDCucsYCB/5uBeV
	GFxO3PiqheQPQIAzxYF35fcZjPN7MjYMk4pxaYgot5qbK5SAge9tFAsQ3IHQ3DGg6VOZLw
	XjdlfvkEq//grSJrgFBh4+vTUXS4iBU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=p73C2CNC;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.52 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-1b3acec6677so4683403c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443598; x=1796048398; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=y226DZkwLHV/0wLned+bdA2tSEyU1JvBKnaVWIVUoR8=;
        b=p73C2CNC5B04YeDmaQf0D4Tefihk71cNzJNzXMQKElfweMeSAgOo5jzKVIjvVto20n
         Q0pGf/ogCoD6582u4I+uUVINrOvHrdWfydQ1GS548ObIdoSKGAgpAtWKvQfclaKrvxns
         +BLrKPU1DFKFs5GEYLV+ubgv1hpd79Jcons6KA3gzRnxOnwAMXgipbLRwdD4aFUaW6QG
         VG4pjywwQiXS5M397WqGaeBkkIvWPdvCsettkwjqOoSlpK/0r1XO5o4DpUmjjRs89X1H
         sOp5jyNgLp0VJ/nondi2etCPkpuh0PPItSi82cFDulNTSjhCbgSDSR72J92d8fNlcAso
         klBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443598; x=1796048398;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=y226DZkwLHV/0wLned+bdA2tSEyU1JvBKnaVWIVUoR8=;
        b=q8SCku/umJKxGUh+wqwpZ4kMMbu7C5UMV2IadP+7swSbIovR0/l+NQUe3FW9lOq5KD
         qR4sdRlcSz0+hdnaYBU/Tip1um9v2LhAtKiNFDWakiuzrdAi7IW5Pr9R77tRo4fyVWdx
         fCkSwswTuC6aZRvU3PeRGCbgONFXdUrOvcVMmj1qcuVnRgpaCCYVQJQ0+LtCiFjkjWSV
         Snr/lO/cqlOVuV/uiT2bw1OfIxbcijVktOySKDUm4QGYn6LKDIH03ell+7sDOA+/vIXg
         MjzYAk8lbprCkaX/5Ry/3lN3HvS1hDJ4qxmIvi0h7dry0WAz2wZKzUQkZN56kit24TnK
         jqBQ==
X-Gm-Message-State: APuU4Z8ufIUYCy2YjFpbszDaLBjbM7zTooh55I1Lhkps94vEK/aGKUBy
	RyMj5pElifadWIaW9IRRVJI/nB1hJXrEeQ6JJsk0kBAb97R8GLGzBdeZ91tpo5a5
X-Gm-Gg: AZFdTZc8JW58QOc7+Z5W15lOdGn+ud8Vfl4t82U5lR8pDB+PRmoabjNp4KRsZb8ZfDg
	AWEapKrmYaDNqUE0RKUqYuQXPzWq2aIWpaYFXg22JiJIyFptTnXquR5GlYRXUfOzNFelyWDwuK2
	Kkn5XBstIkU8bxr3McgX359ryErKDQluYCuClurBeE0CHh3KAzzNPUUzBebOzSwdUBuDwPf4MB0
	mAvVF5u5G7CFHKiFoSr5Bq0OGa9Y5/1tRm/Jp/xbxDNPsGUi6c+57rETIcbwDoIP/iaULQpgrER
	7q2PielMMWNjauWAmwzYIcPrbra0v8nhuIyRO7txrQPR4qNultA10QSrY1BH43Y629u6BwbiU62
	dw1x7+SwaJTLRCIouAdeQGCDHvoHTtmYwFApmIKjThXDYCZl9uZJH3FkWh+qvj7ZimyTFtGQWXt
	0gJHFiCfWbqfjWU/KvFV8GcS4S1qnzsWwJ9FlhUv3Wn4V8n/2tawRZXVreGfeO31hsG/uyN3sUa
	//yvAPFxpqPDbcOrhnXkjCV+ylD56inqkUANeSLFODGjLiu6YhkynK2zO1cdDwWdKJtwUqlc7b2
	jPaDZlCjIt/JpIizSkFUIpmMuna9o15inZGT/HjI2aW2vs7QqcuKMNOir+i9YUuh4O6uFX8aNel
	kqpENrRuYhX0v02Q=
X-Received: by 2002:a05:7022:1586:b0:199:e38c:29a0 with SMTP id a92af1059eb24-1b55690e6e8mr13031567c88.31.1795443598397;
        Mon, 23 Nov 2026 06:19:58 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556840494sm29427377c88.12.2026.11.23.06.19.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:19:58 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH v5 17/19] mm/swap: advance the global queue cursor directly between priority rings
Date: Mon, 23 Nov 2026 22:19:47 +0800
Message-ID: <7d2e42d489849716d6a4a3b906673959e6d9a28d.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B1106160007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: 3b1gutzqipkwgp449y8dzg7sib1cf7c5
X-HE-Tag: 1795443599-822751
X-HE-Meta: U2FsdGVkX1+JbDt5aKN83HorBK3XsYUQcNrgg8bHixGLJg1xvsUOJL0LYYJjHxXnbD5wzRW+tKBf5roTi69b0/Y+G/t7elkEmBGYZ98G7qtQTF+WjwAReyKXQpEnXa0gluv3LNBZn9f7M01wUBx3CYlGA5bdnVh22KFtLpTY/BtfLR/oWIK2bO30Hfdv46XLqF1tygTns6xDo6pTc1WBifMGTricwCup+9EYrIZrzRFeagzAZksc6lUVKXb1mnH7hqgqM25wWetJJIrMuvSxA7go+M1kuCmUbjHiPyve3AhDntvob6yb3hRFMjCfRlUd+aYRh38hUrJTPbrk7MlDGTtMIBSxkUoXPtPBUFNH5HQWQG3FTDPx19O0z6Btu1oLDDaNxrGhCpgW14TS8mYEw5nLAuW/VoHIbJTiO3QyjZC7zWUqkmOmA5m//bXQk54P6CxPORoCG2sDvCHFJnm91+afbskcP54YHfZT++cWS+VbkH+/Dl6/jTfdIZtSbw+0QQ/Oxv1a/0YIFCfyZRUf3K1ythdiB1oEXm/SweGx62Fik96pY4MdXFqw4c8p5i5k1e0aEDHu3uazglny9tcsTHVOw4l4RyIwQ2ry7YaKXagSci7/LfsGWKNfrFp+HnRctV3fFm1L655ZHtdZzQm01oVtWC3gY5dTWQdkUtTFfpvghL8nS0dK8yGGjRn/mggQJK+GvYfxtr6Jj7cHKspbdRdjy8ytwg8i7lTxc7p0S4z8kSlbWRT4Kn2VAZhDAJ0baZ+XVpGHXLJvPGgWX4jFsFbHT6Akl7rvt5I4XwspQrvkgj3KZy9idFNfcQsLw82Tvb79jivvnzL77OIAzaSualSYJozftGnWvz2wI9msEgTI7I3hSZug0WqS8nYvA5HJlnDnZyliB2Ug4DFNYqFxKvSkifhE3vvLqS6jmOVdseqthoWWqzTNsGA0RWNzN9cZEgQaoqXqnk90/qBTjig
 qrP5sAkK
 Sr1DENVajly4/CRMkjwFy4s3Ig60mrYK3WxPjVyHyOwvBmBQRhvObD2OzSxef85VGhJVIuxpP0ZosefETSrvkSf23q6YPLDtILgFZ6jPtA5dOAcdI/Tjnj/Zn4lIK4GJ+rnT+/TEe9PbXpmNmGIrTchdfpM/uCD6tztM4AMdpdv1j66pbl10nc7STJQxDprSkPgc8nmEGbK49xj89Lf63vdKK2LMABhZBhuK/VjaS0Z/UFsUFRKvE6HOT+dyBE9zFQbuZBie+wlHlJYkxSuXsQTJK8GD7g7JoJFyOi1Mf7PUXCjt5EzRClGmFyb/8UNI+e3AU1NuLjMZEy/qCvEnt3y/pTx4I68M8L6e8LmRQHZFZDvyTE5OBNiD2FbWbtar1oFHJ/zEVYSYSOT3LTO/o5ABng2S2g4suFR1L89TNnh1uNopJktTv8SFgrhcMbCmPKBp9MjeAnfpDeYXCRS6WQS6yfegXt8VDD8DXGHsDjPLiwRih1dCXERiOtGzRbGTYvXOgbqr6X6EdzS2vw58SE5JQGXvxyRrfVx34PuO69tjob3G6jfAf4yY41zG+Tamsos4WjPLqqFR925LErLuqSuadze/tRPiozEWolE1wHW6zsEZFZdEJXSouaVYcDdNUR7OPkMN9TcRAQbBakzsKAIszY2L+lnAORrHWaAC+Mfv0UfM8PVjNAjQZJbbnbc/ngXW7VArYwd+ZuOM=
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

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 0c4452fa53ae..5a8663e9f954 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -194,10 +194,10 @@ struct swap_queue_reader {
 };
 
 struct swap_queue_cursor {
-	bool valid;
 	bool no_fallback; /* Do not descend to a lower priority ring. */
 	unsigned int ring_idx;
 	unsigned int offset;
+	unsigned int nr_iter;
 };
 
 static __percpu struct swap_queue_reader *swap_queue_readers;
@@ -307,37 +307,39 @@ static void swap_queue_install_readers(struct swap_queue_reader __percpu *reader
 	swap_queue_reset_readers();
 }
 
-static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter,
-						      struct swap_queue_cursor *cursor)
+static struct swap_info_struct *
+swap_queue_get_device(long nr_alloc, struct swap_queue_cursor *cursor)
 {
 	bool rotate = false;
 	struct swap_info_struct *si;
 	struct swap_queue_reader_head *head;
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
-			return ERR_PTR(cursor->no_fallback ? -E2BIG : -ENOENT);
-	}
-	if (cursor->no_fallback && cursor->ring_idx != queue_idx)
-		return ERR_PTR(-E2BIG);
-
 	ring = swap_queue[queue_idx];
+	if (cursor->nr_iter >= ring->size) {
+		if (cursor->no_fallback)
+			return ERR_PTR(-E2BIG);
+		queue_idx = ++cursor->ring_idx;
+		if (queue_idx >= swap_queue_len)
+			return ERR_PTR(-ENOENT);
+		cursor->nr_iter = 0;
+		ring = swap_queue[queue_idx];
+	}
+
+	/* Consume masked peers too, so every walk remains bounded. */
+	nr_iter = cursor->nr_iter++;
 	local_lock(&swap_queue_readers->lock);
 	head = this_cpu_ptr(&swap_queue_readers->heads[queue_idx]);
 	/*
 	 * Snapshot the starting offset for this walk. Other allocations on
 	 * this CPU can move the shared head between retries.
 	 */
-	if (!cursor->valid || cursor->ring_idx != queue_idx) {
-		cursor->valid = true;
-		cursor->ring_idx = queue_idx;
+	if (!nr_iter) {
 		if (head->rr_counter < nr_alloc)
 			rotate = true;
 		else if (head->offset >= ring->size)
@@ -1845,29 +1847,25 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1882,7 +1880,6 @@ static int swap_alloc_entry(struct folio *folio)
 
 	migrate_enable();
 	percpu_up_read(&swapon_rwsem);
-	return ret;
 }
 
 /*

