Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5325DE63CAC
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 17:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC7AD6B00A7; Sun, 25 Jan 2026 12:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B6B6B00A9; Sun, 25 Jan 2026 12:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A880B6B00AA; Sun, 25 Jan 2026 12:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93DBA6B00A7
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:59:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 354321A0196
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:59:01 +0000 (UTC)
X-FDA: 84371247282.25.2DDF8BD
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B1972000E
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:58:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7wEWz8m;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769363939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WshGWNJYF++wijTnl4L4ygl5/AaRqG4ZVzkhCy8zUn0=;
	b=Gcz1nQrIRPIVHtFqu45U+yIZTg2yZmOdqucZkpFv7r697IYDe9Joa/hIRKxK3Y6lIppHlW
	58TvItzQ8Z9rgFybd/fQJ4qRbUbzeZLqy14X5DbRszWCHa9nkhZ5blgHJr70UCBs3dtZBj
	q2T5SHKUQKr6t2D2wx20Sp1hC6USQb4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I7wEWz8m;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769363939; a=rsa-sha256;
	cv=none;
	b=Cfqk3U/Jqj2uQHuNCEZQwZ4Zdf4IMaUP97jiOs2hp0VHFBhhU+9jaKNowi4/aBDspbWA/B
	R+dP10492COhrqMJS85AKH9QK+noC+HyjlKrPly0MD8SpLMJjCgSJknTHgzeYRwLyLYgwd
	IUIRs8ypFdGFvb7PEuBU0FOr/Nbjbcs=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c622ce9a33bso1163305a12.2
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 09:58:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769363938; x=1769968738; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WshGWNJYF++wijTnl4L4ygl5/AaRqG4ZVzkhCy8zUn0=;
        b=I7wEWz8m21eQQmXK/uOpqW1yWF4KhjupF5T4yWWa2RcZdUqK8oyyS1p7CfRqLukvaJ
         wIYJqh82DpO5U2DMF/yA7IukwCU/1gghrjX25MqBDfbYTFSJCaePJCCc48ZeRwUCmMeC
         PPVqJHTEBO87bSWnfzFeHXxBgDrldVWdKd2XVvmCK7YSNZhMcMzbmDQN3DJBGUxh7SlU
         /Gv1fTkfHv98ptRD9arQ2mtIXqcfG1Qy0/lVegNEYEtlJeRAx/s/U2qUok0k4aexFZUe
         jzB1DDD/HMOTTQ/86ypuBar4H5asIJz/XshWZH5mpRv37M9h93HhCg16JE99dGALeqlV
         uHiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769363938; x=1769968738;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WshGWNJYF++wijTnl4L4ygl5/AaRqG4ZVzkhCy8zUn0=;
        b=NmW703pX5aHfO2LUEPpF0qZrfsAgoPmAq/+K4jDuhwRajSJta6STMmJUkLJf/a49is
         9FMKoWpuyaKFmeh20OstX8TTWFsZR2PX4psmhTNMLHz2UrWnzZ6AiG8mEYqJk775Vnrg
         GgYMHIVZhkW4a0eV/XLYbEcxoFA/jalj1flvdJu5WeWv9mcsS9JsjyzF7clU6Y8SiFp6
         Ifd9qaOsp/Vq4yEenb9DOsQgdFmtAyHb5/kQEYinvQFmierDE/f2y/lu0jVdPiHLKzHt
         uedY/RvBehSV6Z9Fwio67phXVf8O4WqKPpvp6TSJsq700ZE5bHkZKmCzye+yB6sFQMVt
         Rmzg==
X-Gm-Message-State: AOJu0YyCl2Ai1WgILaZscs7XCjJguqxU8gG/0dqWVgdK/5okK40g6aYk
	jp11LpyEusfTXquUtUZ5Fg3vtEMT0pmPFE3eN0VC4I20W42wsGCeEePx
X-Gm-Gg: AZuq6aJd1iagJKHRGMpvp/+Immj6EMNY85gXHphioinBx3JD92JULzzkldXrQUSS2pM
	QEKLYBuoN6qa0Li5I2tysm18VGxgBDsJLjOsBMys4YeMJz//+ZC06jai7NLkXeevDeNU4Gaa4dO
	5+Fow5gYsOspnwfuJ2QNHqy1ehGKKIVymCen8G3BvJb/ZpWwbvpDmB7XrSDbVyxmBX/kLafgiBh
	K/AffYe/VDK1eQQh40DsxC2KV8TZJsxgIZbM1YHeDLYjKpJ4LbmqsSkO0WQ/4NEX2+AFESNjAIQ
	/ERNMA6AXpM+PChcKLcdfRYL++7z2C/P5crJ5Pmz4HDjkia3hIPYSoMtLOjh9ySOmCAKbd9HOsi
	iHIUYQbejIDFfioKIM/KrQm4bXs3BN8/qP9X3b/DjjoNgBzKRMEO4QeCMAvCJVVk1GxeoKVGtrf
	QFd6IQacUPXTMwKErFAvZRf7YWctblL8oYSFiWzT3i7htfv7HwEugHp+vhiBM=
X-Received: by 2002:a17:90b:3c05:b0:33b:cfac:d5c6 with SMTP id 98e67ed59e1d1-353c4182f32mr1864176a91.29.1769363938190;
        Sun, 25 Jan 2026 09:58:58 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8231876e718sm7405963b3a.62.2026.01.25.09.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jan 2026 09:58:57 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 26 Jan 2026 01:57:35 +0800
Subject: [PATCH 12/12] mm, swap: no need to clear the shadow explicitly
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-swap-table-p3-v1-12-a74155fab9b0@tencent.com>
References: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
In-Reply-To: <20260126-swap-table-p3-v1-0-a74155fab9b0@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-kernel@vger.kernel.org, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1769363877; l=3144;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=N+Tk0tXxMjVdLEG5ORllLHnt9dnHiUYojx+HV4QDfJ0=;
 b=i9jf9SH6BTPb7v7w5NstkVhNdATjfP9CoAhJRvX0yoJ/dpS/eDKY6k9RsGncAQq/k3RI9llO+
 Cfh0llN/mwoC/CbIZ2iNwEuCWHabMS4vr/ZkvGUe3MNPYcq3SCECwKN
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4B1972000E
X-Stat-Signature: szh59oec5uoxo9qa1tfwoowtdsxzyu6q
X-Rspam-User: 
X-HE-Tag: 1769363939-485376
X-HE-Meta: U2FsdGVkX19h5VSgZCbsukK2UMIKRoH+Aj/BnTpuUoxN7Wgq+FwV4fEAyk1gY0UQd4qvJJ5q+ec7jA0GTnKgHLQjXv8bkduVd0WjKf7X/W6jfnYJPhML90SFwlvWog7s/SkolEiNsN/aUopWDPPYwNOPdpCCS4qPrtxTqxhqDilyWkYWOkx0TexZlCcKHnfuXWdCrrsHQY6biSjYsl50KrS91vzQQHuW+Lyo06TMtIEudLUXpjO+xTxpoqpo1njzju/SwXH5aJELhL8lW593VZASIel809bsxNxVH0SVAfoc+G1MFkJjDi+TAIgvZ9fX5eKNFILGo5b1i7jLHQYgqHgIyjSEFGj7SedjcnqOd5062w/xUSQHUPmHuap7nEkoWDCPPvRcy/ARdoCywBVqdViOzNGcJCZW8N3YOj3LhaCVj3VsqEYLguNqIrT/P5/xSEETSLch4GI2uWpeNPHjF+t4c/Fw0qGpfBziE0T8Es7gkWIkZgNERasZ0sY0zRSqdowSzhaGeUi/qVan4SsbOJXAA84/RBittgNZkAlcTE09w5yFAZ56oTMTSIZ7scrkeOdv8Q0jY+Intc10otNs3JHDaNyN6WxjUaUxFl4LDvcR2IiMOf0pGXFp46ey0LfPtxFpten9Y1N0inszhFPKR4Xt3tNIe699j0aKWXHLIPARmcmKQBaaTane5+R8h9UIL7TLE+EJs9zW9okKlVbFUuCO8nrj6eQJThYgTH/5n89hyNwYoifRB2bLqH9wsaIhSpTzM0mCXWFo4obwXT6kFugFvws2DTdcT4dufn0AQ3T+1fxXfpiacldEEWoRlq5tBgrFj9TzCMpz4iMnZ0WXyN15VpWGW+oGIRsgwPJ+WZ+dGAupOyOxGR9RIFCY0dym3bM2m+4dzjl2hDoxU+nxqw4HJRT3S1hwg9r/iQNW5muR+MNGoaXVwnBm20Zp6wT25IY0WgDiCidNbIDLlyv
 Z3yfk0em
 gsxkwKSxKLPEm+dr9QHKC/Pw4Kh8QTmIo+K43uitD8ZwZTem69ORIYda6hgtejqkCQtgBXOj9oK3N20Ij8DJyYBAG+1xbAllcJR4TS12BV5snPTGmfilA5vDw18zPgdn/CRNc6+5zEdCGOPgvwBbXRn4v3YaNyctFf4nrnRlz7o8cg0/Sh8qkTfPPP740e0loH+ZUYw+W2FKtSI59B3yPVYGrAXXTDBOtiN2SrfMCSfEEcKzexzv6hGHdKjAsvR0Zrsnm2EKfRvLmyUml/Y9r9Ql6AI2CR0oD6RVyVR/pSk3epmhmG5LgN5HzLCSmANxXnPZIff/T43T7I223B+wxkPDGgC/16KbS6Gm5E2uXkXP+Gs+AMocJ6VbwP8GzlAzqL/QUA7bUrc4zXJ1TP3pPwaL5p5evTpCeLl0jrwy/fvEkSBQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since we no longer bypass the swap cache, every swap-in will clear the
swap shadow by inserting the folio into the swap table. The only place
we may seem to need to free the swap shadow is when the swap slots are
freed directly without a folio (swap_put_entries_direct). But with the
swap table, that is not needed either. Freeing a slot in the swap table
will set the table entry to NULL, which erases the shadow just fine.

So just delete all explicit shadow clearing, it's no longer needed.
Also, rearrange the freeing.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swap.h       |  1 -
 mm/swap_state.c | 21 ---------------------
 mm/swapfile.c   |  2 --
 3 files changed, 24 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 3395c2aa1956..087cef49cf69 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -290,7 +290,6 @@ void __swap_cache_del_folio(struct swap_cluster_info *ci,
 			    struct folio *folio, swp_entry_t entry, void *shadow);
 void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 				struct folio *old, struct folio *new);
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents);
 
 void show_swap_cache_info(void);
 void swapcache_clear(struct swap_info_struct *si, swp_entry_t entry, int nr);
diff --git a/mm/swap_state.c b/mm/swap_state.c
index c808f0948b10..20c4c2414db3 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -350,27 +350,6 @@ void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 	}
 }
 
-/**
- * __swap_cache_clear_shadow - Clears a set of shadows in the swap cache.
- * @entry: The starting index entry.
- * @nr_ents: How many slots need to be cleared.
- *
- * Context: Caller must ensure the range is valid, all in one single cluster,
- * not occupied by any folio, and lock the cluster.
- */
-void __swap_cache_clear_shadow(swp_entry_t entry, int nr_ents)
-{
-	struct swap_cluster_info *ci = __swap_entry_to_cluster(entry);
-	unsigned int ci_off = swp_cluster_offset(entry), ci_end;
-	unsigned long old;
-
-	ci_end = ci_off + nr_ents;
-	do {
-		old = __swap_table_xchg(ci, ci_off, null_to_swp_tb());
-		WARN_ON_ONCE(swp_tb_is_folio(old) || swp_tb_get_count(old));
-	} while (++ci_off < ci_end);
-}
-
 /*
  * If we are the only user, then try to free up the swap cache.
  *
diff --git a/mm/swapfile.c b/mm/swapfile.c
index f2b5013c7692..82b152d7c4c5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1287,7 +1287,6 @@ static void swap_range_alloc(struct swap_info_struct *si,
 static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			    unsigned int nr_entries)
 {
-	unsigned long begin = offset;
 	unsigned long end = offset + nr_entries - 1;
 	void (*swap_slot_free_notify)(struct block_device *, unsigned long);
 	unsigned int i;
@@ -1312,7 +1311,6 @@ static void swap_range_free(struct swap_info_struct *si, unsigned long offset,
 			swap_slot_free_notify(si->bdev, offset);
 		offset++;
 	}
-	__swap_cache_clear_shadow(swp_entry(si->type, begin), nr_entries);
 
 	/*
 	 * Make sure that try_to_unuse() observes si->inuse_pages reaching 0

-- 
2.52.0


