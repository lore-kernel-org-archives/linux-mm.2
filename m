Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAEAFCD98D2
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 15:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314706B008A; Sun, 14 Jun 2026 11:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBE06B008C; Sun, 14 Jun 2026 11:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DADA6B0092; Sun, 14 Jun 2026 11:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2706B008A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 11:35:48 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4FC3140732
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:35:47 +0000 (UTC)
X-FDA: 84878918334.19.98BCDFA
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf31.hostedemail.com (Postfix) with ESMTP id B23732000B
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 15:35:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FMmLae0y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of wujianyue000@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781451345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dL4jh6CljPK2pUBwM3XMHGdtCtJ8jAZGJrHlUx58ijU=;
	b=G8kftbzuojksIWMJ8I+DyYcvTTPW9/CBZQ3XCr9CVB/HZi6zrF1yllXlIkz9FyXxyiP4S8
	/2m16fRB15hduYujlke1sd14sLmyAF7slm09OIO1EnoxhqtcttF0/8mEoR1VqvTqNE6kDN
	QrHXLwhCB4+GhzU+IuxSKPKkll1bRbc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FMmLae0y;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of wujianyue000@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781451345;
	b=4xKLZB6RaQhc/EROVtN/ppBK5f6JcvmTHV/BCsBpwuZdoW4G3VHchcMtRuF3eDEbfY2R9k
	mP8ziiSUKcljt5VamWWtkMKv0x1auNm4tgTOvjltaE6m24nWNvaTz9jWJ3Xg2k1JKsOwU0
	V1eAgoZawS/5QMWgAB6wH0tEVvxQ3zE=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-13721dfd471so2712627c88.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 08:35:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781451344; x=1782056144; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dL4jh6CljPK2pUBwM3XMHGdtCtJ8jAZGJrHlUx58ijU=;
        b=FMmLae0yGfRmiERqcd9NfvpnCRwGPIt3KTD68ADAXGtcSOifEydZ9M/sb3ql+cvGTx
         wZRbdZ69vBNruu1oboVMi6ax/WHcbtPaPLfjZDHUmBw+psxAIRfLtJy+r+EKSI1CFtEb
         +e1ZtSkYuNu39XZCZEq2NlUx1QUZzOdgT5YRMlhR1len1gzpwlXLgqTe+FiWTO6Ag9Hq
         Dnu995bfxUnHVqbTZBRXjeFLlCHrHWzU/RXkMLKfOcSe9CR9mXn+ZlsF+ltfObg8M/YY
         Z/Ibtw5wKI8g0sYAhfQV5CwOv6oFWp5L+gTAF7AO+dUatGpkO3Zmw7dZ2fC2V5jNyoVA
         H5tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781451344; x=1782056144;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dL4jh6CljPK2pUBwM3XMHGdtCtJ8jAZGJrHlUx58ijU=;
        b=FzJFDIkI4dZ7qwZHiJoWsb+PHQQidaCFY9c3j0MPzV/ir6xt91hd+0PQuvL9zXRUo8
         /4wz7RcS+ocxsJntLiQHj5o19o7mQeBAke4vCbGduFDRWjQrioqnm95gibg6aj83gBEf
         CjUWISmw9RFU7treF4k6WdNlZ902oGIFr6Blm/Ns2w15R4dairAMoho7ccfFkanvoqxS
         OL+fD7UufBrivhWIQ41AOOpzDpnhbjNMMe+/2HdUrPqRqA0gNhTsmxLi6b9ecSIi80+u
         37qZB/42PdIul9jnBmVvoq5pbL0dj7M0YqIpcSj7zH+ZSQQsIi6NLq01v8dVBJoDtrTC
         Sgdg==
X-Forwarded-Encrypted: i=1; AFNElJ/hrCPXF0wVjTkb96XVbtd/oZ2fN95JQw/PGQcZTSqf6UeaNK0tkevNmmttxBf6SQ+Z/RVZKn8+/g==@kvack.org
X-Gm-Message-State: AOJu0YzX5NUjVUkSA//Puj/ZmGYNYI2LuHN3klEqSTaDsp2xoF0SrG1E
	4cBCTsszjPUvLrvF+zGx09P+HRq5W4YPPfHi2O6+b+XcZ5CP11hKZJuU
X-Gm-Gg: Acq92OGlq1+tGmvKV6Y9kucLYfB6Fvc1415Pc0djCE59Y1/PJMgfnzpD6E1ALqKA0Uz
	KPJtBIm31JRMc4xyucdOn6DVWsucOjS7m0sBBn6zkAztERN1pVMSAl/nDn4QXSd4gl6ABXLNd9u
	8yuCbEANHz8kATIq0Oh6CDeLRQ+8KkGmsxq+rySy4bcYA+etVnk6TwUG3dJoZWwQxKds26VTkPu
	uIeZZUXjRDaObXdXS2DSCNB+UsgZSIQs5YbHa71GRmmg/KYDeZZTr0BfQ+FS1nnKn5P4pnUOk9k
	1yhB3BbRCAxbCMwDvI2+2Zcl94e+GdPro8gXZQjHJ9iN7XtRiG/ylOigyrw1j0Slsqsmen7fCx9
	RGMYg8KZmokAz9+f2HZhq2eOxh0NTBrXw162GoovKNEMyrv2kR+BxBwkwodOfvSnk0HuysnffjH
	3WdoSyrk6Ve4insXAb0ophLCHYUaj9pof6ipAWeFkY2LkapoIc23vKsrd1bxOo8hNpW6HE8b56V
	g==
X-Received: by 2002:a05:7022:20c:b0:137:ea00:3f3a with SMTP id a92af1059eb24-1386f3500e0mr3183171c88.9.1781451343974;
        Sun, 14 Jun 2026 08:35:43 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3081e5d0849sm12580632eec.7.2026.06.14.08.35.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 08:35:43 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 14 Jun 2026 23:35:29 +0800
Subject: [PATCH 1/3] mm/page_io: let block drivers register custom swap I/O
 ops
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260614-zram-swap-ops-block-register-v1-1-6c1a6639c222@gmail.com>
References: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
In-Reply-To: <20260614-zram-swap-ops-block-register-v1-0-6c1a6639c222@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, Chris Li <chrisl@kernel.org>, 
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
 Barry Song <baohua@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Youngjun Park <youngjun.park@lge.com>, Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-doc@vger.kernel.org, 
 Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1781451334; l=9506;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=SEmcnaThJirfirtCrJB7w7V1XHZ+ozbyyyxT7/QXp/0=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QBq6IcYS32kGX7vwT5waqxnXTy5OSvQnIuQ76gdPnMhD+5AVEVR6uGOd9LKRdUK0aJApP4rAfNS
 kiFgFHpwNLQ0=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Rspamd-Queue-Id: B23732000B
X-Rspam-User: 
X-Stat-Signature: xss4h736w9qsjyby8b15jyag95x3bjb6
X-Rspamd-Server: rspam09
X-HE-Tag: 1781451345-824298
X-HE-Meta: U2FsdGVkX19Rmg/B+9+2osOkc+i79lXS4lN7MPnR9fkUDZ+UuvYz2NCQkAfOWGHREheg5l3eggCHheiM0RifLUujNI+RofUcIxUGoZ91tJbsIWTQYph/swwR1q8UcAjcfs4v7ijIoIAkJnZL7ThN9dOs23pc1mTiUKBGwyUckm/Fhm6tJ+TShkjO+lf9GrVMunH4+5+74dVwwGe21ugzUULmjHa5c3hpfp/H5Qtb4CSbHW2YHMysxWYKk6HyoqnpnYB6G6yiQVfy+KFuAdgfr9EEHnMB2uh6cus9fOI5q28WnafRE9mmxxfZ/pp1u7x9jMl2dUNnffedg0o2nQMjygcnutEcJK2UfiR0D23LtdAa96SfldfeUwe+IJpvFsgrtdItnqN2dpWxUiwRrrZTVdPVf8HlGloey1/9dWNpe3wrUVBjPl3pjv6WtXebLLogbRvCt5dQxuwyMki4NKPhwYmQ/AqHzMu8Hpqy7G+PzkyVqELavKsO4XoYRczUi2yF/QLjAGLbdWyjtfmuuZfJQmhj7fgb3o4142kOhdneObWrkCTnPVjsjbfkBKWVd9uv14YoGDjs8kjndwhMSVrvZDjpDZVXMT7mvs9yHTwFnN1YAoaSXRXiWRjy9BllFHpCfqriZoZD1iHxcecKpufTZEnP119EV+9mLDtECGXvbRoeK3UDaNJiFCXwMPQhBjpX2/MarkEwC0E9slEF4NoYnFOT5s2T/J6ZOwkiM9SCtrkY1viyAivdSkqZbxpVRbP04ONlL9PTLYZRQ0j1ZSM7xlpaykYV6Xka+l0fPoAaOAlxE/qBPRYys55fgr1vIM/4iOI3E6WlU5RP5xe9B6R/JZlQgtGYwFhDA3nuFQa+Iq4Hdr60PhrAL9PsC2YIzBa6SManhIw/Rg6OHAT5sKDcxRNqUL4IREOjlYmQdRCGqMq6xIqfdnUUI6s0J21ik19k49fbBxB60HB30qSqpxD
 MOeeyM1X
 VrIVhPic3amNGvkOnGs/Z5vMZWFtPfiANTPyq8D9SI8lJbNwo1RFNE0KeqCdhqsmYKEy/7PyyPqN5Gm29ULUhhaUUXU5+564xy5Z8JEgZ8RwK/xQzaMhoaTALZo/99f5btNENePP7/Ishhw2M+lh5/FQaCJBoe/kFDm1/f16K6HQAlHteaKsRgHiO8koEBOkElHXS6ojKCntlGSpKbG6f8KT3ie+1u7ccOc0FPOOsyZEKXkDMF6oNdi6cNFe7aGWHI1VPukdTTYAdiQQX3K2XVuKz4YPSTbSe6GLUnkEsNNFQeloBrSG4mgnReu8196IJFgpoEOYf5KUZf6OmbMgxXI/Z/yzRyFrziVS+y9q//SzprTgekLiKNEVYV15/5+zMJUrKlkcsHsLK3irNU5TQgLeqgD1LeE7mqnZ4fSc01YMGGAFQ3rYkR8XQ7vg5lQokzH4bmhgdcQgCM/wdZs/rE3nu9OwgMzyC4rrtzZGEgl0kjGfWjSaGYTefxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add swap_register_block_ops() so a block driver can install custom
swap read/write handlers instead of always building bios.

When swapon targets a block device (S_ISBLK), setup_swap_extents()
checks whether that driver's block_device_operations were registered.
If yes, sis->ops points at the driver table. Otherwise sis->ops
stays on swap_bdev_ops.

Swap files are unchanged. They still use the filesystem path and
extent tree, because their page index is not a raw disk sector.

Register swap_ops in a single global slot keyed by the driver's
block_device_operations. lookup_swap_block_ops() matches sis->bdev
fops at swapon. -EBUSY if the slot is already taken. That is enough
while only zram needs custom swap I/O. Several block drivers would
need a per-fops lookup table instead.

swap_unregister_block_ops() must pass the same fops that
registered. Swap areas created before unregister keep the old ops
until swapoff. The driver module must remain loaded while they are
in use.

Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
---
 include/linux/swap.h |  35 +++++++++++++++++
 mm/page_io.c         | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/swap.h            |  18 +--------
 mm/swapfile.c        |   4 ++
 4 files changed, 147 insertions(+), 16 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 636d94108166..1d51df4179c1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -19,6 +19,41 @@
 struct notifier_block;
 
 struct bio;
+struct block_device_operations;
+struct folio;
+struct swap_iocb;
+struct swap_info_struct;
+
+struct swap_io_ctx {
+	struct swap_iocb	*sio;
+	struct swap_info_struct	*sis;
+};
+
+/* Set when the swap backend requires GFP_NOFS allocations. */
+#define SWAP_OPS_F_NOFS		(1U << 0)
+
+/**
+ * struct swap_ops - per-swap-area I/O batching callbacks
+ * @can_merge: optional. Return true iff @folio can be appended to a ctx
+ *             that already holds @prev_folio of @prev_folio_size bytes.
+ *             When NULL, folios on the same swap area are batched until
+ *             the iocb is full or the plug is flushed.
+ * @submit_write: flush the accumulated write ctx to the backend.
+ * @submit_read: flush the accumulated read ctx to the backend.
+ */
+struct swap_ops {
+	unsigned int		flags;
+
+	bool			(*can_merge)(struct folio *folio,
+					     struct folio *prev_folio,
+					     size_t prev_folio_size, int rw);
+	void			(*submit_write)(struct swap_io_ctx *ctx);
+	void			(*submit_read)(struct swap_io_ctx *ctx);
+};
+
+int swap_register_block_ops(const struct block_device_operations *fops,
+			    const struct swap_ops *ops);
+void swap_unregister_block_ops(const struct block_device_operations *fops);
 
 #define SWAP_FLAG_PREFER	0x8000	/* set if swap priority specified */
 #define SWAP_FLAG_PRIO_MASK	0x7fff
diff --git a/mm/page_io.c b/mm/page_io.c
index c020e8ebf966..3ab620860379 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -24,6 +24,8 @@
 #include <linux/uio.h>
 #include <linux/sched/task.h>
 #include <linux/delayacct.h>
+#include <linux/export.h>
+#include <linux/mutex.h>
 #include <linux/zswap.h>
 #include "swap.h"
 #include "swap_table.h"
@@ -325,6 +327,8 @@ static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
 
 	if (ctx->sis != sis)
 		return false;
+	if (!sis->ops->can_merge)
+		return true;
 	return sis->ops->can_merge(folio, prev_folio, prev_folio_size, rw);
 }
 
@@ -577,6 +581,18 @@ static void swap_bio_read_end_io(struct bio *bio)
 	swap_read_end(sio, failed);
 }
 
+/**
+ * swap_bdev_submit_write - default block-device write path for swap
+ * @ctx: in-progress submit_write context.
+ *
+ * Builds a bio for the accumulated ctx and submits it through the normal
+ * block layer. This is the submit_write implementation used by swap_bdev_ops
+ * for ordinary block swap areas. swap_ops providers that override submit_write
+ * (e.g. zram) but still fall back to the block layer for some I/Os should use
+ * their own bio construction, this function is not exported.
+ *
+ * Context: process context (may sleep if SWP_SYNCHRONOUS_IO is set).
+ */
 static void swap_bdev_submit_write(struct swap_io_ctx *ctx)
 {
 	struct swap_iocb *sio = ctx->sio;
@@ -640,6 +656,96 @@ const struct swap_ops swap_bdev_ops = {
 	.can_merge		= swap_bdev_can_merge,
 };
 
+static DEFINE_MUTEX(swap_block_ops_lock);
+static const struct block_device_operations *swap_block_fops;
+static const struct swap_ops *swap_block_ops;
+
+/**
+ * swap_register_block_ops - install swap callbacks for a block driver
+ * @fops: block_device_operations identifying the driver. Used as a
+ *        match key in setup_swap_extents(): a S_ISBLK swap area is
+ *        routed to @ops when its bdev's gendisk fops equals @fops.
+ * @ops:  swap_ops vtable selected for matching swap areas. Must populate
+ *        ->submit_read and ->submit_write. ->can_merge is optional.
+ *
+ * Lets a block driver (zram and similar) replace the default
+ * swap_bdev_ops with its own submit_read / submit_write implementation.
+ *
+ * Returns 0 on success, -EINVAL when @fops or @ops are bad (a required
+ * callback is missing), or -EBUSY when the single registration slot is
+ * already taken. That slot is enough while only zram needs custom swap I/O.
+ * Several block drivers would need a per-fops lookup table instead.
+ *
+ * Context: process context, may sleep.
+ */
+int swap_register_block_ops(const struct block_device_operations *fops,
+			    const struct swap_ops *ops)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!fops || !ops || !ops->submit_read ||
+			 !ops->submit_write))
+		return -EINVAL;
+
+	mutex_lock(&swap_block_ops_lock);
+	if (swap_block_fops || swap_block_ops) {
+		ret = -EBUSY;
+		goto out;
+	}
+	swap_block_fops = fops;
+	swap_block_ops = ops;
+	ret = 0;
+out:
+	mutex_unlock(&swap_block_ops_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(swap_register_block_ops);
+
+/**
+ * swap_unregister_block_ops - undo swap_register_block_ops()
+ * @fops: same block_device_operations passed to swap_register_block_ops().
+ *
+ * Clears the registered fops/ops slot so future swapon calls fall back
+ * to swap_bdev_ops. The @fops match acts as a soft owner check so a
+ * driver cannot accidentally tear down another driver's registration.
+ * A mismatch is treated as a bug and triggers WARN_ON_ONCE. Swap areas
+ * that already captured the registered ops keep their sis->ops pointer.
+ * The caller must ensure the module owning the ops outlives any such
+ * swap area. For block drivers this is guaranteed by the bdev open
+ * reference held across swapon.
+ * Calling unregister before a successful register is a no-op.
+ *
+ * Context: process context, may sleep.
+ */
+void swap_unregister_block_ops(const struct block_device_operations *fops)
+{
+	mutex_lock(&swap_block_ops_lock);
+	/* never registered or already unregistered. */
+	if (!swap_block_fops)
+		goto out;
+	if (WARN_ON_ONCE(swap_block_fops != fops))
+		goto out;
+	swap_block_fops = NULL;
+	swap_block_ops = NULL;
+out:
+	mutex_unlock(&swap_block_ops_lock);
+}
+EXPORT_SYMBOL_GPL(swap_unregister_block_ops);
+
+const struct swap_ops *lookup_swap_block_ops(struct swap_info_struct *sis)
+{
+	const struct swap_ops *ops = NULL;
+
+	if (!sis->bdev)
+		return NULL;
+
+	mutex_lock(&swap_block_ops_lock);
+	if (swap_block_fops && sis->bdev->bd_disk->fops == swap_block_fops)
+		ops = swap_block_ops;
+	mutex_unlock(&swap_block_ops_lock);
+	return ops;
+}
+
 static void swap_fs_submit(struct swap_io_ctx *ctx, int rw)
 {
 	struct swap_iocb *sio = ctx->sio;
diff --git a/mm/swap.h b/mm/swap.h
index edb512e619ee..4bdd38f7a5e8 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -4,6 +4,7 @@
 
 #include <linux/atomic.h> /* for atomic_long_t */
 #include <linux/mm.h> /* for PAGE_SHIFT */
+#include <linux/swap.h>
 
 struct mempolicy;
 struct swap_iocb;
@@ -79,22 +80,6 @@ enum swap_cluster_flags {
 	CLUSTER_FLAG_MAX,
 };
 
-struct swap_io_ctx {
-	struct swap_iocb	*sio;
-	struct swap_info_struct	*sis;
-};
-
-#define SWAP_OPS_F_NOFS		(1U << 0)
-
-struct swap_ops {
-	unsigned int		flags;
-
-	bool (*can_merge)(struct folio *folio, struct folio *prev_folio,
-			size_t prev_folio_size, int rw);
-	void (*submit_write)(struct swap_io_ctx *ctx);
-	void (*submit_read)(struct swap_io_ctx *ctx);
-};
-
 #ifdef CONFIG_SWAP
 #include <linux/swapops.h> /* for swp_offset */
 #include <linux/blk_types.h> /* for bio_end_io_t */
@@ -472,6 +457,7 @@ static inline void __swap_cache_replace_folio(struct swap_cluster_info *ci,
 #endif /* CONFIG_SWAP */
 
 extern const struct swap_ops swap_bdev_ops;
+const struct swap_ops *lookup_swap_block_ops(struct swap_info_struct *sis);
 
 int shmem_writeout(struct swap_io_ctx *ctx, struct folio *folio,
 		struct list_head *folio_list);
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 284eebc40a70..ebdc96092961 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2849,6 +2849,10 @@ static int setup_swap_extents(struct swap_info_struct *sis,
 	sis->ops = &swap_bdev_ops;
 
 	if (S_ISBLK(inode->i_mode)) {
+		const struct swap_ops *block_ops = lookup_swap_block_ops(sis);
+
+		if (block_ops)
+			sis->ops = block_ops;
 		ret = add_swap_extent(sis, 0, sis->max, 0);
 		*span = sis->pages;
 		return ret;

-- 
2.43.0


