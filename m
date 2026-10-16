Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15AB9CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 04:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A04956B00A1; Fri, 16 Oct 2026 00:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBB36B00A2; Fri, 16 Oct 2026 00:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919296B00A3; Fri, 16 Oct 2026 00:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EADA6B00A1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:44:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B71ECC02C0
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:58 +0000 (UTC)
X-FDA: 85327249476.11.3CBFA26
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA7BDC0003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 04:44:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="XgDfaa/7";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792125896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJFVSgny9QpsatjBhIUNhY0HvYxuqclO1o6tI9EiK6E=;
	b=ZVAok+Ga90cyUpTVkz5H6h7BMDsugA+aWiGom2EvNrMv4mzlcGWfiHeMBeR2ic4Hcb3MPr
	Rr6YPrSEtIPBPrKoDj5Y9FLmsU7mnKZQ7sebAhcVEHxx2RaMK2r3mbpLpY9mUe7R6rsmXz
	DxoFFDLfjaWi/w7ZJuHOGoj1X7093XY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="XgDfaa/7";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792125896;
	b=f+zCae0OH+hX2Z8C5tt94R+36Iq6DWn0637zgWkgewt771TTaW3iaA+LiaVD7WB2+aUaSh
	Rcx2pr6wuC+rfDaquTNzy38t2PcZMbodlyewiBQofyC0VSg9J6v+EvR9cMg7xvzhawpQam
	cUtYfwxTVakQdj06SclPOivHk4/tb+U=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cd61cef87f1so1525703a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 21:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792125896; x=1792730696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GJFVSgny9QpsatjBhIUNhY0HvYxuqclO1o6tI9EiK6E=;
        b=XgDfaa/7gozN479apKCbiEdXFRzu0G62hQZA/U8nyLqEw374lnf4gm1JsQKr+Rgid2
         TqEN9T10oP1eyFAZLqqVx7NQ7f+/5V8/4k8yeY7eXIbEds5Kj9WZf+kh6LDxVUtjDLbK
         4G5eNHNiBIj06lXPRuUFtFiLqPWob3HuZ6oJs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792125896; x=1792730696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GJFVSgny9QpsatjBhIUNhY0HvYxuqclO1o6tI9EiK6E=;
        b=bi1HgENVO1gBWATd88UqAjMqnCHDdSHQiFl/azOfQnz8EB0xh4RfqEK4aRMUuTha9E
         aLE/SJ6eG3G/IyU9NZRkxJ80olGBfc/id/85/LU/JwxMq3Kj3YryK7rnM00Q7FkGGbWY
         2i1Mmge/2V+7aDG1yVi07pYTqdcPW6zTyZ33XVF8EorqCGorlKHLKcEonw2brIhBCeEB
         sIotSZ3UyHQIoBRJxh7EAUS0qsQzr+yFH1eajNY/f6wJX+Pq/8szQ2HkMbuBgp3imgyC
         UOaL/fYuBSlCFs0UZRKTQ6BfS5XhGPZ/mY90x4MEgQnRREI2QUvmc73p2+BkCblBOziU
         tL+g==
X-Forwarded-Encrypted: i=1; AKwUvBzPf8DXMOxKq379xe9hI22duoJXT91OrSqfWl64GrKxd1fL0rdA1cw+trCZMxTxiYXaSQrIChtL/g==@kvack.org
X-Gm-Message-State: AFq9FYL0/c6c9QvX++O0n71L1njWJKR4qS4zMBykbRHb3RkOkvfYZv8O
	8vmIn2wguEmT/VkYWVe9hpsIbLWd+yNAYLTAG9WOH+Obec7cRlzRaZCcOCK+hovAzQ==
X-Gm-Gg: AYBFou0PPtKdu795DI0g91p4YpGzvQ3uTlaIDidDyRG/Ys66bb4OjS8oAFMhrRohY3s
	MyDsZCFEKzDPX+BVcp4AXaFtVBFalaIct7QXjvH071Kh7LoYRG1SDEM2HZoSlFHVX6qGZvpz1lM
	vZPXbpZ1Wf2AKeQvKG2PUp4xjhbl+OgAnaGGathSa1huJeIxNm0+5OyyyL3I25Ant5ZTWegmph5
	g19RMFJpSV2bgSZj49bfMbBRW79SJJVDtYI3NPoJ0DanBigwpcldyS1AZaBYWAfpFC+70ZeO8eJ
	t8mLTTHYsniTDXIUUyhPBiyy/GN/oMLnptIP9usJjkR7JdG1OwWnAAEfjBdCX0oMCGbWiWlWilw
	L1hcjxstgQ0aKhVwS4vha84qm8Es0cYxM01k1HKqH9NclURn3TIklJjFQ3CCEFUU8YbRnpvdsaC
	0PmpJV9EYp3DW2oYbiUK9oWmf3ukOJA3Q+QHorpL0Fiy6njTz55C6wslYz6co/pC90IYXSxTxqp
	3XDsA8Li0NyQaQ0pjXW1cFLno1z8aUcye2v26eQeHw85Y/9Ic4DpFglF7QX/eY=
X-Received: by 2002:a17:903:1545:b0:2e9:52dc:4c10 with SMTP id d9443c01a7336-2e952dc4ccamr48301585ad.18.1792125895819;
        Thu, 15 Oct 2026 21:44:55 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e8b1b5esm4137235ad.67.2026.10.15.21.44.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 21:44:55 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Geffon <bgeffon@google.com>,
	Barry Song <baohua@kernel.org>,
	Bo Zhang <zhangbo0325@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v4 07/12] zram: zstd: do not use kvzalloc() for zstd allocations
Date: Fri, 16 Oct 2026 13:44:12 +0900
Message-ID: <20261016044429.1304561-8-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261016044429.1304561-1-senozhatsky@chromium.org>
References: <20261016044429.1304561-1-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e6kc7aqa8uj5py7o19kow1583e8jgin9
X-Rspam-User: 
X-Rspamd-Queue-Id: EA7BDC0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1792125896-438513
X-HE-Meta: U2FsdGVkX194GZXqDnMws/NGlDQ3pP0DP8WaeTK7igxjM9/0rEU1yMSd1AVy7g4Ygx9WiILX5y8XwZcgBKdYRIiin4S5w58f1WmFIX2tnCxisYzXW4C6asKQhhjKOD7UKNTNZzSA+cxAaLp3ejft18NEVOwbJyWyDjU3826ybsL/I5Ty06S0d6PU5d02+fHjhJCgjACgiC08riqWsVoBOBryHmjpqOBc67Qmq4teWGvby3ShK9ngwNa4xXuwn+mFNCPN80Fy1He7XgGPZIqubWCEKWMMp3UpgvJZ2TF9wirCvIJtEwQMLnVZ8WA73z0/jkfn/vbtgiu2Mv9TLr3w81e1mhvEB/roqJtNCqgGOoIuk8Jb/GsaES0pqWsOesACZ5DABzU8XtaQDCynzQWjydfdrYLAfgDdx/ZBR/Kn0lijFjJkDeWla2b4F+wyXn6sWlUKeGwzGIlaPOmPbs54BfDVa/FB/IDTdPK/OcWAtZ5l80sktqNUoei9N7xwRnZCbLvV31UvJBhd3OQ6xPyfie96xWxaKZl+U9TW/teCCwwFRDXxJpo6OcmFOBd2CQtwxTdItZKMrqUPLCU1udjoN1PG3/UNiY4UhYw1khqaiM+vk0sl/5+j9rbjwaQRWgygHb3UERZw86rW9sEmywIUwhvL3gp5dSU1F+jgrp1JLPNRvUonggA3HS8yBGhghrOp5IkvjtmVINRU4BwSxhhAkYucJ6KFyTo22NAloYf0V4e5Y2wH+Zgypdmn/8AS7oq1T/uzirm5CONESuYdHUzi04YdFdSCr23ut1EPN6uEWp3ULHSQERIIJZbTlhjO61M6mCGjGTNmAUpJ6n91/UoO36A9fBIsHCkTdmPRmIrjFfC+l03F/3jl319LuhmWWlnYowxDPYaO4CLAnkbw0mRQ3xvgUUqyBmFhSTDXSNYu/nl9cArA3ZorPZc4A7CgPtrrQWIr1alz57TjFQsh5P6
 f//uWIRf
 zXOeWkoSPAr06D3SUP572W5itc/sGTHt3J6dptmlmkAyyBVqkaZGsdK5j3J4oU0YbZ0F0u3Oh1M89dA3I1LLIe6wRahig78AjaZke9O0+KYsTooKFXq3QBlhlsoEQNBgW108tXA+L6pa5w7yFyRwclb4X5r5wGtIpIO492/G5NdFomuGkjGA1/uvGcpyPbhmJZ0fOeOFqbrcUKqJi2dZze/pxSQROPChLCWVAhiEfQBL9Dav7V6zm2dJcMnlPeugxTMmqIi50wibcXPI3mmhdQXkSCM+ls+Q70EE3tgUCLJYGe2kA1LywWJqm1GeT/hBAfdVA/mD6adCERtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a dictionary is configured, zstd allocates all of its memory (C/D
dictionaries, compression and decompression contexts and compression
workspaces) via zstd_custom_alloc().  zstd_custom_alloc() uses
kvzalloc(), which falls back to vmalloc() only when kmalloc() fails,
and kmalloc() rounds such sizes up to a power-of-two number of pages.

For example, on x86_64 with a 110K dictionary, switching from
kvzalloc() to __vmalloc() reduces allocations from:
- CDict (level 3):            512 KB -> 400 KB
- CDict (levels 12+):        2048 KB -> 1552 KB
- DCtx (per-CPU):             128 KB -> 96 KB
- CCtx workspace (level 3):   128 KB -> 84 KB (per-CPU)
- CCtx workspace (level 14+): 1024 KB -> 764 KB (per-CPU)

Use __vmalloc() for allocations larger than PAGE_SIZE (and kzalloc()
for smaller ones), which is also how zram allocates zstd workspaces
when no dictionary is configured.  zstd_custom_free() already uses
kvfree(), which handles both.

Acked-by: Brian Geffon <bgeffon@google.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/backend_zstd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/backend_zstd.c b/drivers/block/zram/backend_zstd.c
index b367049f131d..7a8b5ff186f2 100644
--- a/drivers/block/zram/backend_zstd.c
+++ b/drivers/block/zram/backend_zstd.c
@@ -26,10 +26,17 @@ struct zstd_params {
 /*
  * For C/D dictionaries we need to provide zstd with zstd_custom_mem,
  * which zstd uses internally to allocate/free memory when needed.
+ *
+ * zstd allocations (C/D dictionaries and contexts) are large and
+ * long-lived.  Don't use kvzalloc() for them: when enough physically
+ * contiguous memory is available it serves them from kmalloc(), which
+ * rounds them up to a power-of-two number of pages.
  */
 static void *zstd_custom_alloc(void *opaque, size_t size)
 {
-	return kvzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	if (size <= PAGE_SIZE)
+		return kzalloc(size, GFP_NOIO | __GFP_NOWARN);
+	return __vmalloc(size, GFP_NOIO | __GFP_NOWARN | __GFP_ZERO);
 }
 
 static void zstd_custom_free(void *opaque, void *address)
-- 
2.56.0.176.g3575e65682-goog


