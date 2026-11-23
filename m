Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B676D606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=PXtcjhM+
Received: by kanga.kvack.org (Postfix)
	id 128176B05BF; Mon, 23 Nov 2026 00:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B2C86B05C0; Mon, 23 Nov 2026 00:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94D16B05C1; Mon, 23 Nov 2026 00:36:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B91B06B05BF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 562411A0198
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:45 +0000 (UTC)
X-FDA: 85465274370.23.B977A05
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E15520002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:43 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PXtcjhM+;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412203;
	b=Bkd+wYlzE8KKXq+qxttCwyMtafsWpGZsz7AkEkOfO5DhPF3PfEh4tZcKrkgRHGqoHmCDtE
	jKvMJS0TEdqJ5xECmLbeeI+TLLpy0pNaqQne2bsU3pL+Py+cIyP8NCWYfXp8VqDpozEgct
	OR8m7ZmMyMbys3oQr2lr6VWl014Fq2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KnMxzhHOEHpbsDB95jN4ZokxNKIXrj2a5/W65iB8kpI=;
	b=3stktOeBE/RkcYEKdMVrL5hyPNZHBH6hpuPIFDYTcnqn0Jax4n2QrJ9BQYbog94IwPzkT7
	K5l5h12ClJnDr2mdHzcV3+XDLeOdZOW3HV2gKe3getKawkOmKHbdySHSr6WZrnqntWodRo
	uML4LZquub/9C8U4tzasLo73mx9NNUg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PXtcjhM+;
	spf=pass (imf03.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2f04bea9a93so23818915ad.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795412202; x=1796017002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KnMxzhHOEHpbsDB95jN4ZokxNKIXrj2a5/W65iB8kpI=;
        b=PXtcjhM+V8WcZgSe0cak+ei4PQHa72rbbH1+1I5+VVmZeqvuAL8MyWnZzwlgVMQr01
         jbNiw1wRZEcsSGURlfyooLYER44070Oa7flbZ9UArkQ1ANygQNjEOjc9HXZL66NmLLsf
         hLudTFWTCdleM/6F/ExcCVr8jTbQqEBBG/J0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412202; x=1796017002;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KnMxzhHOEHpbsDB95jN4ZokxNKIXrj2a5/W65iB8kpI=;
        b=FxzfEEJtFz6nuO2l/MUs7LxRSwUu9QeZ8kLb7N2qBPC/bQN2NdjusULU3DfS/W3yMz
         lfBqnlFU8d1OFuZ/C2lUpPkKlGqXKyP0jDmnwy8Ns1wP0bu2ZLhNdkm0yzWlYBl3s+8X
         lk9zjuOKXmYUjzL+NRyVmBjxYtHAv6IXRMuyToTSZOYkx2Bo1rjfUUEDwL/uVkcmvNk5
         4qUjplV51yCAwYZg4cy1uSVVto7BdGDKvDaTg6S7VDDOEF7CY9NgoXuayC6K90PigSnC
         E9a1svBo9OuBjqlBQEZI18OlM2WNYZYC8/ci766NrqJR6aZXftA/7/+7x8EaQA8fvYQf
         chuA==
X-Forwarded-Encrypted: i=1; AL+hErELQjETq85DXkSmYwnlJ0RVqT6NZ/S8Br1rS4XJfvYg902bgHrx82oWfQr9dz4EfPMJfTLPV0DXFw==@kvack.org
X-Gm-Message-State: APuU4Z+nnehmrXGg1pou5D9sbQfBkJBQe4glrIKXH9sV5cyPZF1ihSY0
	Wwe4pzM3ycW0uqZxrihpcq9xLFHOCig9wPnJTrHjBpFw/Fm3VM38Q4GlkF6SbmZ8hQ==
X-Gm-Gg: AZFdTZefLuFM42MGMufRXsKFkvrmVA1Q9vIHzoaZGYR6qTVWtGTBarHvO48ISdWvkTh
	pRCLTHIex2q5Wnn3Y/hpGNmrdJNNBnzipGtFWuIJvCYKVHrTybkveBrKfeXIGH9lguIKnKTjGb2
	THYd7jqTx0bcEgIjawGZKFu+iVj4q2vBEQRPIpd1mVVTm/B0Wo2XwgNUjohlQrgWA8+4hFjTCeU
	ndN6AKDuikI7xV0YdTcMPTYdUK5jiVjxkv75p9A1mA8q1cKvvFycyyJ96ZbBIpaNvM8rHWmfS/H
	NlWansxPv6pXRkKNiluiH7YmLfB3eqXxY4qGq/3wWq6iwu6RBgVIBMLLlrLg803rjILm1tywubD
	4D6wy/GaV0iH5BCPdZQu6EkYv/KOH7bwT/VnIjnODkKqZUo/SxnH7vsYOe8mwfnKwQTGtvZkSiw
	pcs4Z5h6rsfs41m+9fz9l7BvTpJzTn9srlXHQ+T6qHuShVTyNt45wOoMoj5dUY9uaN/DxIlFMxV
	AfnWC4/soyKXInxEByyAKIQw4I/gKxRtIPPM5pCqAd1jqPFsXwwRzVDJxErZK2DPixYqUrUPdyy
	4M4TqKe9WkAslTa9b2RMXvZZ9FkApX6D9RKxAF/DPLqejB0ckwrcDk7QbYDWVSUzPIFCOYMINqQ
	3Kj41afF6d6e+ZJmJjg==
X-Received: by 2002:a17:90b:442c:b0:3b4:12a9:2e9 with SMTP id 98e67ed59e1d1-3b41c7d17e4mr9833343a91.6.1795412202399;
        Sun, 22 Nov 2026 21:36:42 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cea7c38sm4636531a12.2.2026.11.22.21.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:36:41 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry@kernel.org>,
	Hongfeng Chen <hongfengchen@xiaomi.com>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 1/2] zsmalloc: free a zspage's pages in one batch
Date: Mon, 23 Nov 2026 14:36:24 +0900
Message-ID: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8E15520002
X-Stat-Signature: p4ujsc5fsf5kpzurr8j4jt48pam75k7n
X-Rspam-User:
X-HE-Tag: 1795412203-138569
X-HE-Meta: U2FsdGVkX19rpo2X2dLV1M6R3c76zNIdq1lX1FyZynxDUhUx3B6J4AlK/WEBqtICPuElhq14OOjNrhDMGn65yI+Ss0T0RdCENPSDzBKOKk7Ye7NeZ7QNZAn1Z9m/mVZz8FEVZAcygW5PyaFvph7N/m0JxlXvPi2p4mjM83U8VOZ/HDZb7sT8juo8Uhyhs97DT5tHE+RGW0w4/F7GqxOdZmERyVvy201bDSr3dAFI/GtiUwDWTn8JEc0BGZNTwPuElXbuCh5oIvH4EzABUGGQXaNTlQNlEhrFupZ60rKc9UdZtkohfrTJoX/A5Q8A6gZDT650l1SZY/Doqk+PBLaNJcp5hAnEgqOKAjEcjteZQOFhxIDNNndP3SvD4ao1/bj5wtWhMCINXXFnGvRQxd9YWGCXDOEIk/8/WX4oA/yIaXF/0hUQgXSjmxtKhDrxaM69vtT4KttkAkphS7juThP9qqiRIK7ovuQu+f2Olumo/bKHynumwFS2ZzTAnyMEYEb5OE0BtbVgrqcbiDuABey8sGOKeH3nYUXamGg3VMtQv9Fi+7GlS7uuwNd6x46C/AqyFwY8lKpdE87ZsitRvM3aYTE4jcLX+qlHSeYRbViqRwr0IL+V0Ux7ije8IEHmnKTPQqbRsbOczgJm/MO8D1llMGBUhS1QGHcq0N6m4bEDOcoDFX7GVaCRVCSQn2IIlF78tJHwFOjKuTOuxvW86A5kz/fYE/ynB9ahFQJOV64e5xOL6pS1OFe0OzIItqdRy68i7XfIRxEPlg/z5yenZXGDiT1WIsrWNNdj4rYUfc/WvjqEQrEriJUxqvnTIy5JNEQysis3mx9vAZT4hmlE4TTvf0oXqZFam3ocRUDmgGGU5jbcHqPCEjVanT0X+IUs+cYTGiYRalS3Qvt0FFT1pxG+GfTUbeIkJ6+yFdShZ/2HQF5Rn6rHtD7L/nQ396WPOOMMWweap9U93Q5eESEplDx
 2TEvuLMC
 duBn8BlgWzeMND9R7esATPSxqxs7iUACWCjpug0fa3/mZwpbok5Epxf56BF3PLRft0g0OZ2iJURAb0S35V8VoUoP1w9BwDVjv1XrBAS73E/Hsesye8EJlKGRT54PntYvefrqpCmzhDFC7eBkcdd+M0JiOOuF+2DlMNrAAwNS5RWgbIpvyDxzrKK/K78Itg3XO7lV8B0IMmtd1IFJewwi2RsVGknSZpyaFRrxC4uhBiv4WnWdXJW0kKdyCEsP7QsaeKnPT7N5RZ+WPFJFDMD24XjS65WwjTRNQXXaPXhbT5vhoAFw72pPcK7o9eWpe06yC0+qL1K9bF2654xx9YYIehwKUANBHtzQ4PVAOHNdwH7goUgNKz+wcxG4iAHVL8Q5aVbgPGHmhALS6iMuOqHtim4Q/Rl5uWO+1bECxfz0dSilZhJPzt+4kKOsUU7M2FddkjJXtqvVXwVBhnhvFAC6k+4+kyrcPwr08xo5XHEVkIbFLpSe/c86n/p1wfUYPRVK9fQ8AaGkJ8d6PdeHz6Nv/GAz8iU8i18icIQER0fDo7pk7WFv1DgF76cyNAE/72RkVNVdfQqSSPYssXbf2oV94ahFjK0hahTaC1eFE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__free_frozen_pages() and dec_zone_page_state() take about 22% of the
profile [1].

Collect the pages of a multi-page zspage in a folio_batch and free
them with folios_put(), which takes the pcp lock once per run of
same-zone pages, and update NR_ZSPAGES once per such run as well
A zspage never has more pages than a folio_batch holds.

Single-page zspages, incompressible or power of 2 size classes, use
the current inline path.  There is nothing to batch there, and
folio_batch is not free, hence the batch path lives in its own
noinline function.

munmap() test:
                    next-20261119      v7.4-rc3
  256 MiB           -2.0% .. -4.1%     -4.4%
  1 GiB             -2.8% .. -4.4%     -3.8%

[1] https://lore.kernel.org/20261109105957.2577351-1-chenhongfeng0212@gmail.com

Reported-by: Hongfeng Chen <hongfengchen@xiaomi.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 52 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 46 insertions(+), 6 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index d5f313754934..a1b6161fd237 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -37,6 +37,7 @@
 #include <linux/debugfs.h>
 #include <linux/zsmalloc.h>
 #include <linux/fs.h>
+#include <linux/folio_batch.h>
 #include <linux/workqueue.h>
 #include "zpdesc.h"
 
@@ -837,6 +838,44 @@ static int trylock_zspage(struct zspage *zspage)
 	return 0;
 }
 
+/*
+ * Free the pages of a multi-page zspage in one go, see folios_put().
+ * Not inlined, so that the folio_batch is only set up (and, with
+ * CONFIG_INIT_STACK_ALL_ZERO, zero-filled) when there is something
+ * to batch.
+ */
+static noinline void free_page_chain(struct zpdesc *zpdesc)
+{
+	struct zone *zone = zpdesc_zone(zpdesc);
+	struct folio_batch fbatch;
+	int nr = 0;
+
+	static_assert(ZS_MAX_PAGES_PER_ZSPAGE <= FOLIO_BATCH_SIZE);
+
+	folio_batch_init(&fbatch);
+	do {
+		struct zpdesc *next = get_next_zpdesc(zpdesc);
+
+		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
+		reset_zpdesc(zpdesc);
+		zpdesc_unlock(zpdesc);
+
+		/* NR_ZSPAGES is per zone: one update per same-zone run */
+		if (unlikely(zpdesc_zone(zpdesc) != zone)) {
+			mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+			zone = zpdesc_zone(zpdesc);
+			nr = 0;
+		}
+		nr++;
+
+		folio_batch_add(&fbatch, zpdesc_folio(zpdesc));
+		zpdesc = next;
+	} while (zpdesc);
+
+	mod_zone_page_state(zone, NR_ZSPAGES, -nr);
+	folios_put(&fbatch);
+}
+
 /*
  * Three free helpers, kept apart here:
  *
@@ -855,21 +894,22 @@ static int trylock_zspage(struct zspage *zspage)
  */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
-	struct zpdesc *zpdesc, *next;
+	struct zpdesc *zpdesc;
 
 	VM_BUG_ON(get_zspage_inuse(zspage));
 	VM_BUG_ON(zspage->fullness != ZS_INUSE_RATIO_0);
 
-	next = zpdesc = get_first_zpdesc(zspage);
-	do {
+	zpdesc = get_first_zpdesc(zspage);
+	if (get_next_zpdesc(zpdesc)) {
+		free_page_chain(zpdesc);
+	} else {
+		/* Single-page zspage, e.g. a huge object: nothing to batch */
 		VM_BUG_ON_PAGE(!zpdesc_is_locked(zpdesc), zpdesc_page(zpdesc));
-		next = get_next_zpdesc(zpdesc);
 		reset_zpdesc(zpdesc);
 		zpdesc_unlock(zpdesc);
 		zpdesc_dec_zone_page_state(zpdesc);
 		zpdesc_put(zpdesc);
-		zpdesc = next;
-	} while (zpdesc != NULL);
+	}
 
 	cache_free_zspage(zspage);
 }
-- 
2.56.1.750.gf70dc682cf-goog


