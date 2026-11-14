Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D3BA606A8BB
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wgEhbFBz
Received: by kanga.kvack.org (Postfix)
	id 741E46B05C9; Sat, 14 Nov 2026 09:52:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2916B05CA; Sat, 14 Nov 2026 09:52:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1576B05CB; Sat, 14 Nov 2026 09:52:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD566B05C9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:52:40 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2931160402
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:39 +0000 (UTC)
X-FDA: 85434016038.24.CC09E31
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf08.hostedemail.com (Postfix) with ESMTP id 00CE6160007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wgEhbFBz;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3QqAYG/uE4i1SkonwP/uDxgDXolAyrEYNmgqxrP7PU=;
	b=AwrvVJyT0BMqbXDeayQXJF2AG9dbf52mpKa1KqISX5aFj2LHHoCypLIYDdCiZtu61Hd1TN
	6ZUEEa1At3XOglsF/jXULm3pwH5DYryRHDH6ruHkQKlIBeicqAP95ssRi+MqBIngfzn0fq
	zSQLpFD9ud22BjZSyF9qRC1Kn8W8pII=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wgEhbFBz;
	spf=pass (imf08.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667958;
	b=OnCSbbaSpwBWohZ57HiGuiumsgVvblDEz93L3qlzaE/msxsLVfW9eoNeln2qvI2oaMJFgO
	bofgc6KI3b/h9JiVzj0M7wmkY4AnNATOISrIv9BYow1LXpUo8YETyrb0CS3BaQfDqtj/ay
	N8ZBK4NP2x+GP03WKx6JPrcjeio91ps=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e9ae391a05so11144775ad.1
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:52:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667957; x=1795272757; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A3QqAYG/uE4i1SkonwP/uDxgDXolAyrEYNmgqxrP7PU=;
        b=wgEhbFBz7eKI43UTG2cjW7dRHuYq2H13pRW2EPXfsQqUQ8nr0wSe2v8bSkGsQdmMRQ
         Jsto6x9Nqe/NEPxwIZ0JMxYOkCnurc6VVvpurB+ovHzdq+xMC/JQWNnai01f8u1xm9PK
         0hu8MB5oMHvrx94hv8sNaL5qUMj/0TPG01li7WvD/11Mhdt37VSwrC1WzgzSy7SfmQgY
         /UJ3xqiNpR4G/XGZ5P+EmmVh8VbPQFI5dHNmzL8a7XuMoqwDEQwim9b2ImkuPKvd9BKG
         Apv6NWegzrL1M9yJ559Mtynt+MAowpLXok4kbL7YPfV8b1zIPJgS/SVAGds2ti1HVMSo
         PFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667957; x=1795272757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A3QqAYG/uE4i1SkonwP/uDxgDXolAyrEYNmgqxrP7PU=;
        b=hZKSLHlI/yt8ACs4B/NGRY8IYW1qs+ZmyH/t05VkX6c9eBB6pU/lFAx+FYJkH4J39f
         5Vp423nO9+eDu+QPDFPzk7ZoDk2Lm4TsrI7wMkwjjmN/lnK2SEkEem8ZtKM8DgtKyltL
         AmyMt/YizHJhL4BvISkwfx06TnAZgR5U2MsYPvHsed93sIps+S5BYSgtVSD1EH8OzW5E
         rAA/HcaDqn7RFuM8JsNjImyTflzNEfJBRLnPSMGobyBK9x0w7ep/MphQvLTROQgMCgfV
         +QhmAFlekIsuWrdMmPNHoqrYuVn86gBJv3aGUe9Ub95rKsfZ9yy5KDpaS9sidWV0V81Q
         Lt+Q==
X-Gm-Message-State: APuU4Z8S1jYnmGonLYiHHN/3VhrFJ4soZNVE5d75UPcCFSjMrySFfFl1
	rSn8M0k8Cn1YcaEYcIzaKEMFBeX8PmX4QT80ev7AEdTe9RVoxLxzScpXryo4Hg==
X-Gm-Gg: AYBFou1XC8dzPjQRNl+Gew1ThUmuFDgZ50K06+7KlDU8tg6s4V9u45gz1+T+uAMP3zT
	MnBRJqGu59WNsfSLXvq5au9867Ti8sfSSjUWMRgLKDiqBD5YGOlOvqhMt7VtP9Vu7DHcBhdihBg
	IoUcXq33D9DH95f2OuZo5W3Gm9SNKSrbAio8ai33J452EiQRZawU8ulZMUTEx0d8UBpopmJFWC0
	J+POa8OH1ZQ+qaPMQO98HNY6ir8wUlelKAT5H0hu1lbQQPz5espoqv/qCOLUFBpy0eCOGv9U+36
	OuQBQpKeyq7XbV1ygI+hlQZ2sd87Mn/iVwr7IPwEyxqeBbJ2FerkXpXwE8k/rKydvoTVTwlhzD1
	ALKEA6ODVa5gZSipCxg7P2JvXC1YNnXo41lPFUOTZa/6wHT9bKDBr7WKEE4fWdte4Eam0uzBwSS
	uMa7fbaTA8Sr771hl3Qch19+GoKqvvs7gqvIaXYo+EPN0lmUe0+rewK4uJ5v2D7mdtAV0sBn0o3
	tdSibQGIz02/fTyPQM8aVyCMdTc3SGxbLhDgZsXHkrbBl9kpTC+bwBJBysXkM3Q1tJHGMECdVEw
	Nxu+qERtXbAW61cOA9ckcNTZAZUw2uZHy46MUw95VlVfjPE8ZJzp5j3j8jKzbkK5zV3q
X-Received: by 2002:a17:903:11c6:b0:2e6:f3ed:a551 with SMTP id d9443c01a7336-2ee0dd2a28cmr41758785ad.8.1794667956678;
        Sat, 14 Nov 2026 06:52:36 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f862426sm22028765ad.46.2026.11.14.06.52.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:52:36 -0800 (PST)
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
Subject: [RFC PATCH v4 16/18] mm/swap: advance the global queue cursor directly between priority rings
Date: Sat, 14 Nov 2026 22:52:27 +0800
Message-ID: <e72074ac198130494037e80655685cf25ff4bb5b.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sen4tihbhoshwx87yzdd5dxgt4mngub6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 00CE6160007
X-HE-Tag: 1794667957-170457
X-HE-Meta: U2FsdGVkX1/rrUfG7K2o86bibLdNzVoVbADrtmfeoBedi/9eaQqE0oULxUedUnjodVNIFvnqKl16uXVOoVv2bhQnbFvibW23hPBl+C0UlrlP54LMswNENPYknIbMSo6aNn0qc+jI6eIjZ8ksdTrEdvV9JDn9U//nLtN7g1P2xfPbeUOqiWzRyqSlpymPMR9q2lCWU6UOrWxIhhbM5ZsokVSW2guQ5b6nX5U/KXVQuU7dfKnSRIOYNj5U421o222ZEHVQ4zzK3t6E44BsBQqexdqfHrtpmIxrarOI7I+0mqm+7k9+JIa9uJc7cn9Y1hb5WPQqNBTlqKbzisCOPzm2pLG8rxMtiyUE8Sx3kiSQBNniNtWo599FyQZnsGBR3yCCDIDPU25Smy2J6baoTaUiggtyTbpz/nU1WGr8OBrYI3YU3gCfHq5wcFPrTk0QOeYMXLW1FyAzk5TJiFPgccXkuXEsIsHsldBQQYiL5nMtDomnUIGuXz50exg9/Ny9pTYtBXqudN9VR9VnLiWYWSaSUYg1jDDzaFzuRtLPEVhF3pfw70tvF2Ym2VXHohCwduOdg7BJUGzBauCgH9LR5teGyFWoYwko+7NQUkM0x2DUTnILdEyV4HcRKwsQNbG7Aowm0BZFY/lVE5nTUAxUDxQIQ64vYgw/H9iZurt3CUrHjyzcQDBq3OIA9j+LV0woeBnGkHjTcagL19TCutQR8Bw6KRShylPFuCXwOkimBcrP1/iw9YTE5MUqa2K8xx0YSaq8cV9j/8Hcj1cSvucbGS6ilPF7n5vq3+vM1T7dPrRTWeUs7MPcaCg8PTbV2+QBxhscpdV7rjLBl8kOvGK6uGqJUs3LmSiyZI006kZA9fT6RKIIIPCF2RJA9RNE3lFKr/NXqKTrA5g1ZaWThq8EFzVrhmWvC+5wEwnAkBsOg5JsCK1YqEYy/44oOVmTCjMqJ3TVS8IYq3a0ej5KTTMWsyV
 3y3hu3nH
 Ohg12SXVzkl0oTUVMm2bGMUfpCbhNfgHFK27MoWy9IdRAjYevvj690rwZgiAxJ7UL+8x63XGYp4OK6IVoQaZHGHVFHSq8ZwXeCriOrLUmkPMgSGeDtqPx0nK9qGeJ0Ba6F4SRMlTZV/L9JXunrc5A5OEW+Je3z/DA1o6EtHUmgOGOmksWs62sLB02tFcMVXO3LcjNZp44Rqzz87EyPhjOLQx8VfhB2uC1fQaAvJ5ApRM5TSSY/2vOmWmqW8+SCO/fSxPy2WWxPvwpDcbSBDnpN6oSnDjrvMk2DlTMwtUsW+/+tsMrMH684c1hnYBEHVxJnEp80hCkHlufR3lmCvHYW2wPtiDGAJ0+LOdNQY2CXXuSIsdQoNwWI8A0u9vMq1bi4JJAn4e0kuipSh+kHo8JuQ8Sx7SrAnGa1hrMgAOMrCTHY8ZyuFPO4NlJkaTI4OZxv31oRmHY8I4vf1g=
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
 mm/swapfile.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 5e5c1aef010f..616339c5ae5b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -195,10 +195,10 @@ struct swap_queue_reader {
 };
 
 struct swap_queue_cursor {
-	bool valid;
 	bool ring_only;
 	unsigned int ring_idx;
 	unsigned int offset;
+	unsigned int nr_iter;
 };
 
 static __percpu struct swap_queue_reader *swap_queue_readers;
@@ -308,28 +308,32 @@ static void swap_queue_install_readers(struct swap_queue_reader __percpu *reader
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
-	}
-	if (cursor->ring_only && cursor->ring_idx != queue_idx)
-		return ERR_PTR(-E2BIG);
-
 	ring = swap_queue[queue_idx];
+	if (cursor->nr_iter >= ring->size) {
+		if (cursor->ring_only)
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
 	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
 	/*
@@ -337,9 +341,7 @@ static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter
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
@@ -1847,29 +1849,25 @@ static bool get_swap_device_info(struct swap_info_struct *si)
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
@@ -1884,7 +1882,6 @@ static int swap_alloc_entry(struct folio *folio)
 
 	migrate_enable();
 	percpu_up_read(&swapon_rwsem);
-	return ret;
 }
 
 /*

