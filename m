Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29AD91093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879A56B041E; Thu, 19 Mar 2026 22:31:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 803C96B041F; Thu, 19 Mar 2026 22:31:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAFD6B0420; Thu, 19 Mar 2026 22:31:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 57B416B041E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:31:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C597C285A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:31:55 +0000 (UTC)
X-FDA: 84564866190.29.2FD379E
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id 483B7A000D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:31:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Xy0RQwdB;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773973913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1b3I8g3+9/WU3GqIQO3em4o8Xa6BctjWUjYBwk/WMMs=;
	b=2G9IZG0xgsIuCoHjBIsMwA9mefoF9BZ8m18+LAJCWbvf3Y7065TyipgYqdCcIRXdyUVQxS
	wl6DSANBpYjLXX+/U3n6l+ZJJ/2PWp1qt+HLEGYMI8HRBhP1OnTMYMzC6CcLseGhop0RfG
	lsV8+vHVKA4/VjtrT28U6S772Rk3HgM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Xy0RQwdB;
	spf=pass (imf15.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773973913; a=rsa-sha256;
	cv=none;
	b=URa2Wyf80zU/LanlHXDhNq9/2UQjW1XX8JtGX7032hq9X50g6GkaBMoF6bh4+OHIyRaWFL
	ZmNJiXaVIsZDWIvl5Jy/LrR2tiQP9fCnIAkZDIu5OKOA59AAkLpKZJs661Hasddkeoub2y
	K7G1oHqEOSm2lrhJ8zGEUfewtvKFg0Q=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-829b2018c94so80813b3a.0
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773973912; x=1774578712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1b3I8g3+9/WU3GqIQO3em4o8Xa6BctjWUjYBwk/WMMs=;
        b=Xy0RQwdB8YwviZDATolRpGI6/mnlq1JkgoZuaaAWWxRoXYHDV3lEHEjgBXlQpkb53K
         +4lLnbITzB6jvbabOWJzuPNEqYvkL8vXVc+vHMRT7n2YGYD6D0Z9n+5KPCx65N3F3bPP
         8tML9pEiaes8Cp2+2qGduQtT4XDSOQtlv2Gy8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773973912; x=1774578712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1b3I8g3+9/WU3GqIQO3em4o8Xa6BctjWUjYBwk/WMMs=;
        b=cebFwwhypkR35eoyYF1uO4XgJQU2lTQ2VzYsk6ExeJZVy3URRIxh+PADgEkMLEjLu6
         1G2s69F2isuviA+WS1exVdCA9LCGAO1fpjY2W3sy2Jo+sCcarzQg950r+sKnbxnhcCQw
         NS/a9zGzzwXb2xFkinGM8DrdxjzJfjKRCOtlE16BOcc/V7KgrnMisEbGXdDlm/r3axKJ
         HH2HyjfYZ8b93vDl6dSC6o9KgGmaeMkpS5yDWUHKGcEAX5Z7JaRFkAN8qhoVa1RkkRDn
         a07TSYGYirf4TqOXxMa3lYJb272UGbvu3ph+zFI1hkGSAqcF4c42jKpKjhmMcR1k+GOE
         Yiog==
X-Forwarded-Encrypted: i=1; AJvYcCX+fOClR/IWm7CvY6I3ysd8XNv6UCLKn52NrfD7UqLz5chttyacnPMb/p9Fz9+tRHIgs/LzywXCfg==@kvack.org
X-Gm-Message-State: AOJu0YyAV1yRV4S++NP0W3Lvz+QsUshoLUdwhLOTzYDGSPb8NFVlk0rW
	VnIr6+z7Oj9mbSDWlSe69lAHEQIc1agE0hjaq/Hw+xTAJU8Piv3V1ImsKI18ZVIaqg==
X-Gm-Gg: ATEYQzwm1OURPEOuKR505kTtyofxJt1RMSWcdZ8Hy6WsRwX2Zv5ewHEhTLPZxP0NWp6
	RTsuhNTluTnZQ3cJAj9Qf8ve0MsdVt27luy+i6QnePfEw5CdkF1g7rBBzGNjK1+UxTAhKcBKNpE
	JN/FDh+S/STtfZg41wkVZhnv51rlp4HGZLNaoJFFjEcwHayJKN5XpkAxamQIOdOhLGkvSJ7BkSv
	lTbd03z1qDagLJyvPNc3kigFUxCEjA7qf2QybXB8oXf9ayhOEH3woWsH5bCF5CUwjMq3iVP1yoZ
	CDXw+H/MOBu56NjhmF+lI5r1ervuk3ppFLATC788e2akiCNBQ9EFxqRvs6IVNanku90S7s6Zf6i
	k+pPxBTLkp79Ou+rCMbgf8j7HJyRxzsmIhxpbL58u3dQjwpDaARBQP4jRPP85FXf4/IVlq61K66
	cuBpfCOytBNlpwhBh9tTeMaSzzM40Kxcj0lNCBb+wAzbpaDbgWZTZcz1nnF28SCHiaaIe342RA/
	CbsgU17PDcW
X-Received: by 2002:a05:6a00:9089:b0:829:8969:b8b4 with SMTP id d2e1a72fcca58-82a8c237aa1mr1066056b3a.11.1773973911764;
        Thu, 19 Mar 2026 19:31:51 -0700 (PDT)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:65ca:c086:eef:123e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82b03bc6881sm562042b3a.22.2026.03.19.19.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2026 19:31:51 -0700 (PDT)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Brian Geffon <bgeffon@google.com>,
	Richard Chang <richardycc@google.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2] zram: do not slot_free() written-back slots
Date: Fri, 20 Mar 2026 11:31:31 +0900
Message-ID: <20260320023143.2372879-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 483B7A000D
X-Rspamd-Server: rspam07
X-Stat-Signature: dn7d6ana8ksd9dqjbjwp6fi9k1oenrc4
X-Rspam-User: 
X-HE-Tag: 1773973913-27902
X-HE-Meta: U2FsdGVkX19BMNEy2HYfpmnu7RVxOESI52wv6JtvPiRIGnbAx3qB2apwrh8v5/a0t54hFJqKfxHHG37HHKsb2Kgyskktzz8AOMdkc1zv1Rk9y2Z4LjIagp74pmSKBUGzlc04JXNQpJGF67vLWyr0rfrs7tl+RvmpPIDa9fsyapDp28jCCDXFHCGkSzaO/WM2YFod07FFGi2RMLqbUJDi1k08xnGOT9WUgSp//OwFYjXWBNkDlqnRvMLCyrjdxe3uzttxWz9fR4ve4O0K+vwb/k4UWLGCl5g+cKVTlR3J5H01dXJ3GfisyQSrl97steHIg0ZgKq/dG9GaNS5zl9RZx5pD49tx4TeWAjP6kIEDr9Kd9hdc+N9R+zu11Aaf2gAUowgwiXGgVCDixzLcddRwUL+jaH0uYbn8QlPOCQB3AiXzpLnjl5k5yg5IL7B6sAbbAKFX9n6Lw2P96p8wo3bpWjmzSXAHiU9ZwUQcMCVOupMY1PCYLm6wHQLKr5ez213+iY9kH5QSTA6rMJUcd/CvQoOPV5pknUPasdUz5zvbHsLfb6LjirdgHGEtbe4EcZo/eYuMiL5AGekUTXSnghXXDNwvMIVDrIsvZcPB2jX1DLj7XHrr+HN7BB8U6TKYp3D91t9mXsoOc0juZ5cRFMZJ6M89jWuKDpapOFxGxqXFwrZ0HvyoGdKspFXwD7vpWLCRIYeBIL2pDSkO9NX7h8haXaWJ5UfA2WmrUtD5DhbsrdY3owBDgn3pzV+KsrW1hTCvB8jD2+H2AfEe4QoPUQG8uqLD/yIV6dmlxndHg5pQyEzdPPPt+79dYV+YPFyAsCnZkA5WbPsnWpMFGWvbdDa/CGrR9wPE/R5d58F3gp4so85/mOqnO2vg/Q2nETv0qbFhyF8ykdQq/J6qPO0Ax5Z4KcT4HcDiJRsVLLMk/7c6N9OYRYonx7NyVlCAgVQ0iUtAty3X0F+JPl3++aMgXtB
 T3dl6QTM
 TlpVSnnqcKYNeb8hlwrwwv4bGITSSijBjQIBo6x0ZGhDukW0qwt4KxC/tool/bpZLdYAX1Tta2oVtyBMePPQhn57bgcLdFo2YggJe91pTdfI4p3N8G3/aOBHsRrFDGzSqdYsfyzyiXq/9x/NIoyl3/4pVFNQyTXAp4AR5u9vi3cUGMFe0ODLaTN2sN92f2U6Wov32oR2yi/TsMX3ULBiy62KiAQa4fbhDn5HJ5om1W5RFqnqZUItPIf9nphU2PSFH12VEBMQAep9kPKAJiTXca0M9TFrRjgSN9MYPkXe4mxNQDAqhdhwB9QnOW89ORsxcu3n+pKKILvuo+ol6JGxJxPEp0gZf/w5PhXHZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slot_free() basically completely resets the slots by clearing
all of its flags and attributes.  While zram_writeback_complete()
restores some of flags back (those that are necessary for async
read decompression) we still lose a lot of slot's metadata.  For
example, slot's ac-time, or ZRAM_INCOMPRESSIBLE.

More importantly, restoring flags/attrs requires extra attention
as some of the flags are directly affecting zram device stats.
And the original code did not pay that attention.  Namely ZRAM_HUGE
slots handling in zram_writeback_complete().  The call to slot_free()
would decrement ->huge_pages, however when zram_writeback_complete()
restored the slot's ZRAM_HUGE flag, it would not get reflected in
an incremented ->huge_pages.  So when the slot would finally get freed,
slot_free() would decrement ->huge_pages again, leading to underflow.

Fix this by open-coding the required memory free and stats updates
in zram_writeback_complete(), rather than calling the destructive
slot_free().  Since we now preserve the ZRAM_HUGE flag on written-back
slots (for the deferred decompression path), we also update
slot_free() to skip decrementing ->huge_pages if ZRAM_WB is set.

Fixes: d38fab605c667 ("zram: introduce compressed data writeback")
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---

v1 - >v2:
- Updated commit message.

 drivers/block/zram/zram_drv.c | 39 +++++++++++++----------------------
 1 file changed, 14 insertions(+), 25 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 1b0e1c02ece7..5ecc4ba40e9d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -917,9 +917,8 @@ static void zram_account_writeback_submit(struct zram *zram)
 
 static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 {
-	u32 size, index = req->pps->index;
-	int err, prio;
-	bool huge;
+	u32 index = req->pps->index;
+	int err;
 
 	err = blk_status_to_errno(req->bio.bi_status);
 	if (err) {
@@ -946,28 +945,13 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		goto out;
 	}
 
-	if (zram->compressed_wb) {
-		/*
-		 * ZRAM_WB slots get freed, we need to preserve data required
-		 * for read decompression.
-		 */
-		size = get_slot_size(zram, index);
-		prio = get_slot_comp_priority(zram, index);
-		huge = test_slot_flag(zram, index, ZRAM_HUGE);
-	}
-
-	slot_free(zram, index);
-	set_slot_flag(zram, index, ZRAM_WB);
+	clear_slot_flag(zram, index, ZRAM_IDLE);
+	if (test_slot_flag(zram, index, ZRAM_HUGE))
+		atomic64_dec(&zram->stats.huge_pages);
+	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
+	zs_free(zram->mem_pool, get_slot_handle(zram, index));
 	set_slot_handle(zram, index, req->blk_idx);
-
-	if (zram->compressed_wb) {
-		if (huge)
-			set_slot_flag(zram, index, ZRAM_HUGE);
-		set_slot_size(zram, index, size);
-		set_slot_comp_priority(zram, index, prio);
-	}
-
-	atomic64_inc(&zram->stats.pages_stored);
+	set_slot_flag(zram, index, ZRAM_WB);
 
 out:
 	slot_unlock(zram, index);
@@ -2030,8 +2014,13 @@ static void slot_free(struct zram *zram, u32 index)
 	set_slot_comp_priority(zram, index, 0);
 
 	if (test_slot_flag(zram, index, ZRAM_HUGE)) {
+		/*
+		 * Writeback completion decrements ->huge_pages but keeps
+		 * ZRAM_HUGE flag for deferred decompression path.
+		 */
+		if (!test_slot_flag(zram, index, ZRAM_WB))
+			atomic64_dec(&zram->stats.huge_pages);
 		clear_slot_flag(zram, index, ZRAM_HUGE);
-		atomic64_dec(&zram->stats.huge_pages);
 	}
 
 	if (test_slot_flag(zram, index, ZRAM_WB)) {
-- 
2.53.0.959.g497ff81fa9-goog


