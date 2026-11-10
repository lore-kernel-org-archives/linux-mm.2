Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B801606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=K1iCAEE0
Received: by kanga.kvack.org (Postfix)
	id 382EE6B05C4; Tue, 10 Nov 2026 00:49:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333D36B05C5; Tue, 10 Nov 2026 00:49:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FB206B05C6; Tue, 10 Nov 2026 00:49:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB4D36B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:49:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 73EB81A08BD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:20 +0000 (UTC)
X-FDA: 85418131680.30.5445C20
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id A6B2A80002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:49:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K1iCAEE0;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289758;
	b=D+hAEqd+h8BtRFVs8E+ZkSM1R01jf9K8KVG+iZmSSAYhsbI6lCi1CnPCzIhfpSLQuAjo91
	hsogSZSTcCH8Qyq+DUQ7DVNFsdsmn84wEU041XU3XXwA/q8Dv5hwKDvvn6Gw5SSvk+xObj
	ezPbsFSA+QU30mMCWcI6UfsN/PFX9CA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=K1iCAEE0;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lrmi2+lOFJxXdkix+UX3wdRa3hyeMQKr15+9Sj7OH3M=;
	b=1qQwBWUcYa3dlQm3pKDiP2xyBRHzmO3AdsVRf17C3fkf7wXlyUcWCj7DtpP3C85kP3YKTP
	Y9XCkwJphOhDRKB4xVvTH/vPzIsvDfqd/1GCLqL9O0R6+bhcbTw7dE6aKAaXbq8M4LfijB
	M0tdq+7UImoMytBRg2FxC8/xy+DoaPc=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ea7190aea1so7133025ad.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289757; x=1794894557; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lrmi2+lOFJxXdkix+UX3wdRa3hyeMQKr15+9Sj7OH3M=;
        b=K1iCAEE0KMVzyeASfLCuWiR2nO8yeRw2DEU7e9EfwPvXZdB9lHJ0Q+6CqCsZ91fS1b
         QWSBof9m4/unpdMUj5RxUTb/++9u7yphaAv10IBtLQb2WKjxGq90kWtJQJqQWGwx/Bjc
         QRQJDxL82w+9KfqRqzfXaJuJmRnIz05HWsC1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289757; x=1794894557;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lrmi2+lOFJxXdkix+UX3wdRa3hyeMQKr15+9Sj7OH3M=;
        b=P/6U9wd8NmFcYzgSHVmzJiJgtQ6UllZxDaKtBjNuGDikIyTtqtUjfyy40+J7dkCzFU
         a57A2umvIar10Mm9ZwwEzZRMvy6wxr1fiFUxFnqgrhVwZ/xqVXNpp87ZgZAc4Vgsnd2z
         RR76fXK8WNPyVLyA9BqAdvEg84BZi0wTehddezN/QdTT2AQ5AbPbC7FTjMZuLa2DFT25
         ClB9OBCmkF1cET6rVcS3Exn+4BuHv6+sBN5dhaFtw+6tPna7HnlbMbrx88R9idla2rja
         sakwDO45BUmPUTXpbc1hX4DH0zKoVrYZmqu1vVz311BfqABRKiLpjvjeDOooQUj9yaBh
         34dg==
X-Forwarded-Encrypted: i=1; AL+hErHRvKjjPuvRJyh+ze5/+ipL9NczheXwxw2Be8SjQBS6tmAadhErkk886LV0m/qenhfwFlZMRZfc/w==@kvack.org
X-Gm-Message-State: APuU4Z9MA3dr+EN6qpb4W3P5UosSe90ps08beaHJS4p1GtAJsz9UQc8R
	wLhG/w8QeO6nQ+hJ/RqU9CogttEZOVFxAYIy4K741Fmc2JssVg+Fm3J2jJYiBvMYiQ==
X-Gm-Gg: AYBFou1hHK5LzuXY4QLU6l4RH7b9bhYFyqbVltVK4YzM2akDPOPMRE47W3Yvh/NmWFK
	NbeRYk6WOqKrkDF+yRoVXqOr+AMcaUh8R2TseserEMXD6Vss4KGcaY6+BIAL4kSnZQGG6FeMwFU
	0b2cFhb+qH8TufTviuL3YM1iUDgWC+cPeR7YqlJi/YipZ5klGBAq1jz7JxulrUD73o6bkOn1eaw
	ixGDRsHS0UV8s/c+V30o73NURil7KQr2VoVYbVOqiKS5sI5eP3e3eOzOh6aUB9AW/Ga0W2ohuvw
	Vzt3bjIQbu2bra5A0vXRAxsIqgclckL8MH6eRi2j/voQ3xRIHqs9w5F3IptLL9QIM77np63BG4/
	kmHOMoJe0pmxEwC4AI64xI7n/lFhXoZr/4QtSwNBVv4XGJmE92BKea27n0Kz8bh2GDkx341aY0s
	EaVfsw1mfrS3/USRRQ8H1+gq9RkQgvNun6GsNJW7c1TMDiPfDpHY6DYRpv7R3mNDzHW37xBCucm
	nqdNinu6/KQN5oF1yLx2tAImqfMXgubO2NLN0PnoLYu0db9UurrAY16L3qHOpVHXYAPheXT5zKO
	BYXZDDVlj1NnerUlzF4vwbERzmu1HZyYeaouHjaUXnF4aqRnF6VkZ+Yelxi3LK8p1QtmMS/9Pja
	y2KlzteibgIuWhseBTg==
X-Received: by 2002:a17:902:ccc4:b0:2dd:c0ff:e72c with SMTP id d9443c01a7336-2edb93179ffmr13147715ad.62.1794289757474;
        Mon, 09 Nov 2026 21:49:17 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:49:16 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry@kernel.org>
Subject: [PATCH v2 11/11] zsmalloc: populate new zspage outside class->lock in zs_store()
Date: Tue, 10 Nov 2026 14:48:16 +0900
Message-ID: <20261110054836.1515030-12-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A6B2A80002
X-Stat-Signature: ki8ibk3jbbj4p7t8h1o5iywmfeektmpj
X-Rspam-User: 
X-HE-Tag: 1794289758-313250
X-HE-Meta: U2FsdGVkX18VoamOo5v9SmKdS9vmyhcJgePastgmhgZDJj4RVbsw4YqynKi4ElsgazACCdLxvbuN50QKxlGXOCLOMQ19EkSZC4WHdDNAXuLJI92zEZlPr9H5R6JzlDvM80tpIHPkgI/+s30aJN8rb6RclojxuT7m6lCGmT3FCvKjakoZIB2vaelsZDgPBH1JB+e/iuSV7z3sKG0CPPqUqILD1UPZCT87qVWRWv9FgyT6OdB9VF8TyE2ToPWLH7OZcFZr6aNyzYsolY1RkaswHx07czDpZvtf1w7sljEwbN6KrUeybO+O1ceD8X07UPGeGp8XfjZxQEHDO6MxcRHPaeBmfTLbGjJYDeJms1fpgLNu8qaln5kuu5ogyN3UUoctI+/fsx012O7PIGpUr96hRPDjNxuPbzBESdnU+OFYZlj9PihIP1+GRL241X2IbZyThGoL+jgxzZjFF83uC1RTjJOhbravTiMdRqIz4qkNKgUQoh/BBXbhTd7B1IanynWCJYCQNM7t/CXcwgJJDz0QMDAwdTHTekqIVrkh/eIV+p4vwVrmNvLQm0Uq11+7/BDVJSlZYDz1hlciDy8+Bt1N3Qs9sLJC2zZs33tU0n6Q6qp7Eh5iPhBNOggkkHVw5NIL3lpEZUwtadpaEwUu5KNgqnJIO4L3TuIC4PtUK541AGg2Ruwy7Ss/5zW/IAckmLvFEhN9dA0LPvXngtx0k6N0bvEe1jUXn0FyVM2Z8ssMGA/z6reD57vsxiWkMiozljCGsFcycaKtfVAodD8/4Tl4eMxh+c5XSWFJkDRs6dwwsue0h6hoqHwOxcmsWoSraU49yt9dOg3VRwr4trj3QKi/nwLdt1epPk+ifnQ7EW8racX2fk1EDdU9a+bNdhHd4zse2C2HCCfwjpQ03pvsJFnOuIql8hBiD5/3dKAxBM3z5GU1j1emHgmZ4MyxNOtiSn3l1b+Mplzwvornv0lJbVJ
 20fEmo7E
 QG22+4yp9fFJRgb0U/QL9082DAD66dqlfHDhjUkxj3KuxOQW2EoHQp5Wy89p7hOUOcyb77dXYfUvaOrny701xM5p+0ZjSEFX/r8rGL7pLs2iSPGnkw/ykxaPJhdkN8zRojU13wejH7ciYP3lhLyMd2ye/qe6t5us+K5YZQwPBjTzsTX7IWZFApyolOnDW+rqk8wN+wsHyT1UrQPTSR+ua8zAoK2xnSiA/sZulSx4B+Yx6lPbt9dCPNdddaA0r6iLkNTgXK+FLSamI1J5F9dfIAiunzjbeBJE2GmVbjkuXPhBIf5pGnBM1K2lOIEaVMwIMmZq+zWPxlj8AdoAPlJnoHjiODxFvBwgO4hnM3h/o32Qr1k6oD+ksTRp+HkX6qP1S8xt6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A new zspage is not on class fullness lists and is not movable until
zs_store() calls insert_zspage() and SetZsPageMovable(), so neither
other zs_store() callers nor compaction and page migration can see it.
Nobody else has the handle yet either.

So for a new zspage allocate the object and copy the data before we
take class->lock, and don't take zspage read lock.  This makes
class->lock critical section shorter and saves a zspage lock/unlock.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 mm/zsmalloc.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 09ce8c294c5e..2f4adbae82a5 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1319,8 +1319,12 @@ int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
 		/* Now move the zspage to another fullness group, if required */
 		fix_fullness_group(class, zspage);
 		class_stat_add(class, ZS_OBJS_INUSE, 1);
+		zspage_read_lock(zspage);
+		spin_unlock(&class->lock);
 
-		goto out;
+		obj_write(class, zspage, obj, src, size);
+		zspage_read_unlock(zspage);
+		return 0;
 	}
 
 	spin_unlock(&class->lock);
@@ -1329,8 +1333,15 @@ int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
 	if (!zspage)
 		return -ENOMEM;
 
-	spin_lock(&class->lock);
+	/*
+	 * New zspage is not in class->fullness_list or movable yet, so we
+	 * can allocate the object and copy data before taking class->lock
+	 * and without zspage_read_lock().
+	 */
 	obj = obj_malloc(pool, zspage, handle);
+	obj_write(class, zspage, obj, src, size);
+
+	spin_lock(&class->lock);
 	newfg = get_fullness_group(class, zspage);
 	insert_zspage(class, zspage, newfg);
 	atomic_long_add(class->pages_per_zspage, &pool->pages_allocated);
@@ -1339,13 +1350,8 @@ int zs_store(struct zs_pool *pool, struct zs_handle *handle, const void *src,
 
 	/* We completely set up zspage so mark them as movable */
 	SetZsPageMovable(pool, zspage);
-out:
-	zspage_read_lock(zspage);
 	spin_unlock(&class->lock);
 
-	obj_write(class, zspage, obj, src, size);
-	zspage_read_unlock(zspage);
-
 	return 0;
 }
 EXPORT_SYMBOL_GPL(zs_store);
-- 
2.56.0.506.g506a7eabc5-goog


