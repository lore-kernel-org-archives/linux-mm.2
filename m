Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E0BCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E0F6B009B; Mon, 12 Oct 2026 08:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF1F6B009D; Mon, 12 Oct 2026 08:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE53F6B009E; Mon, 12 Oct 2026 08:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF3BC6B009B
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:06:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 517AAA89E3
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:06:45 +0000 (UTC)
X-FDA: 85313847570.06.8699E28
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 99CEBA0011
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:06:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rQ8bvQ+O;
	spf=pass (imf15.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791806803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DGD6iaaJXJ3iIdLAE1x/VkAzNUZDtkUZz0KaCdzwHZw=;
	b=P1rEOxJdU/ggon8J+ktNcptAVtBFtsmFxE8BX5XjIN12op/W6yITnV+KqmGKNorbKpJClv
	a3VVroLOUTuL69CFaAv3bQ+wH/TcaWXLorVzrCfM7DI0PG01KN2bi5LgtRjYagwyHjrQQL
	x2f82fT58Vfs/tN4do/lpAhOqoxMj3o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791806803;
	b=GCwEz6slsCKPd5XQ5d528eF0vE33eVwumpYU25fimpq5fLZeKoU7MbvVTTSkBXcu6UqVjn
	atKdIiYxd9mM5Lk1swbaPsf2cITjjeMeqgyEg2W7OdLFWZAVfCzlhOSf+rsNsh4gpk9kn7
	oiG8TNlWObxxww86f71uKx70ICaYNiI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rQ8bvQ+O;
	spf=pass (imf15.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-38759bcd877so1050409a91.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 05:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791806802; x=1792411602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DGD6iaaJXJ3iIdLAE1x/VkAzNUZDtkUZz0KaCdzwHZw=;
        b=rQ8bvQ+OddQcGC/+on0mnPhxmWTEqvMacLJfDDt2UvJ2xApD29PigfCh8Q4j0vch+Y
         g6/maLA3bw1rQ/oruk4KojtHps7LnWC2+2t1ZuIDTu50cJI9XtySyAQLaCXRxUdI+HUz
         DR42Kb8eojR82lwzjs4ygX1tYsoJ1t9zzwyOQIliI9n2ml4lWS0p9NyBnVgvZVHVqwfd
         ZFoa4G7WWoKQXg/8eYQQldD3708LcuRo8bYGDsqw7rkpdOkuZQ1q4mMDYkTI8Fj2W2Pn
         D5hNsR/dflQrepNUPXwJKYVL0dF8CyINy+k6OaY3/7M6NaH1txSnefGj016onSGpW1gX
         Lpmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791806802; x=1792411602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DGD6iaaJXJ3iIdLAE1x/VkAzNUZDtkUZz0KaCdzwHZw=;
        b=qs2qjEE0ja64WhnnHIxom6cb8jd3T2+OZ1NjV47SK/C5K9ElaPz6i0oX2hPEWZjOXx
         NbXn4narT1k9Hhsm9MMalyM/oYXAzuOmomTMwjgY3zehi7CqfQO4jfse5c27TihdtBdk
         gcrqyJw7M+D3EHZOonV+9VtNXd0My92OOBGOuGYxHkzC7VvTyzZLGosWIOQ0itGMhnBv
         6ZyzAcwUz/hwwacIYzQm5P8MCEK32JyXjjUQAzPt/q0WHkzEeVOtqJrYGUQXBmaaX51h
         3/4VMS3AFTaf+hljRWS+cvm06LZYsJuiWmUy6SLoSvVSg0OikNZkSP/GVkXbXgS2Vt0h
         YtVQ==
X-Forwarded-Encrypted: i=1; AKwUvBzqZtuvRvpP+ZbiCnDduGhd7tAA5jINKyd9D2AXr/7Swsextwl9HNURbiSFAi9lNDCSnBdoQew3Qg==@kvack.org
X-Gm-Message-State: AFq9FYIpkQMp8IxXRy0uGRswz6jJ1+PZR/WrVLw8uQmWpRZhVHgdw1gR
	pvEeGcjn4m32cRmc93rgHRoGhu1yWtI7k7NbcLRy+08pGRo5mFY00oHz
X-Gm-Gg: AYBFou0i7b9pR+cGukhz3jJVZQgw869hgsHajiXdy24khdXkMv//yIXs4HIHMbgYQLS
	VunXu8/rcives+Kk7pgkCYVYehH7wcb9YCEpFn9x2h9PmeJOQe9FoLSDFXycbGJYqo+HcxhDw/X
	fVQjUVOOsuStXDFw4b53KNRUnwCuau5Nr5xhWaCxXdR4q13Ftu2eqY6BOxjIQoxuJt1ziph/3rN
	aPUl5YDwGleq+e/XdG164+7FFmLA4ZQc3eaPETiSTkICa0GF32hSlnfGAxQHw+4FQ7CsE1pF2CF
	hXqW+cJxItvFqQWF4cC3GR3t0OA1FY9b0M2EpDcnk+FDbvDvA+5XwehGlTu0q12Qah1TtmX3Hn8
	2S7/bfOIpQxDcX1ARHk1XCzi98rH2ROrFKJnLXXwft5wml8j7kGkFTNzF7qyl5xudRMghasDJSg
	2+Zyi0j07/BykxyLSu/Jkdi5xd9v5KmwKLwcye1aBWuAcIo/V/XnqbViEDXekrmaIsZi1oaw==
X-Received: by 2002:a17:90b:1dd1:b0:3a6:fec5:c179 with SMTP id 98e67ed59e1d1-3ab3ad2b1b8mr7980498a91.41.1791806802412;
        Mon, 12 Oct 2026 05:06:42 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac1:7aa0:50::3cf:23])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3abdd5d09aesm6160087a91.7.2026.10.12.05.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:06:41 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: axboe@kernel.dk,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org
Cc: linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Subject: [PATCH v2] mm/filemap: annotate lockless reads of mapping->nrpages
Date: Mon, 12 Oct 2026 19:06:36 +0700
Message-ID: <20261012120636.16106-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 99CEBA0011
X-Stat-Signature: n1dymbad9t9tuxy7xfpndqwg8oeht9gd
X-HE-Tag: 1791806803-542276
X-HE-Meta: U2FsdGVkX1992o1xJZXqIeFucUJHIeZdShmXRD705vE3+Cc89QK013213nO02t/G37tg5oe8AiA37w4epJRCtsycFZPcyOcMNvHzVJrb+JnEbgAtCK4BfHJ0z2AzdZrsD4/jGg1HtBoCjXc2bPr7PDx/WLfgDZ7xsuzavsCttPzj4UOrmqEpeRK2kIejv9GORLEkYLm/5lzpsW1m6u3z2vvlsCKGgc/xhIsBRCZzAcATfHgFpTF9SdYiW3yCRSgkYIGU0cQx1goBoSvuMNspsFaUcs0L/9eE+t6O2a9O8u9whhpp9zrYqshhBUq/kTFN9HQ338BwxJ1ldh81NVl8HyQRoK40PETiJP87+rkmWQ3GhJeQFHubNm+ZffElLqhLd/vnm1EXxppQ0y4fWcpfJTxucjEsucQ4v5XzgD6fGvn9WAZnDdNDI50CkidR5qlAr8sIqoRf7AhsHLw10CIX6iaggP6LQ6EkjMp2g/YIdf4tMfe/bA9Ld+7bCeqE2yQ5h1+vQjQPlY5WcZGRPcIWqmEN3NVuP4NqZjwkA1n4hSTE/MXgA3tXFDDDYOcnOzzcqd1QAf/EQJ4Ceg0ib/lUjG3st+XLUuY6QsuPc9yyPCXs075eHebzyk7UR4yVnQZUngYY7MP5/hDjdQQHZhfVzU5AwCVqf+LbbyDKyrgvgY6+4AxcC8U5SvveTdp5YE/osrEQB/bRPY4ZcbcPSC8teH2pqVz5BsgMpXzomi+gpTWGoPV3q49h/12YDQmnAUJOQbuMjUz1/TCtEigfF7/cLbFnUj1aQQXInIgDbD5g/jarjFujeAR2cBERhTgrOCUS/fZbiPI1JU4ILdx9wMJjK7OZj0kmxew/f+nu+JrTL+s/pfDL+N5OJlXOiA3aMqDHkw6Q7LiOUspTuOJ0ufUJ3iSjcEyNBFX5IUn761tHJ0hB+WY4VnGZ0klHy5OVHOYULD1b8aJhxw+WoVBIC96
 XKXwBi4p
 8oKBSi5iSbjq0Oggb9HrzB6ZPLzkatN7gDlP1wrfLbkHDyh1r3dkzFeil8YSJ8xLFVZvIXRvprBVErBE/ad+qqTNWxxBPmMskzjEVXIiqx4iFAMGdOVrs7QN4tCU0vAKzXRG1C8FHKH0fv8JlC5UHkvugwJW+IRqVw+V6k9woWXURFjMyq8S3km377CIR9A3K0HNJiSYBub40Zf9MRTp5Q3+0EvtIYl4tf18EifGc6jTMvCgq1G+9jjasedpRDYad+e92/QdSTE2LrovYZohZpqzpTG0y2rXnCpfgCa3RKQEpJuWOMlLZVBNvTbk0L21Fwci3gw7pBtHnTqR8+QFbi1kk9BV1DyFE5hDiDNrr7MMK+nNDjA/YnxGrnyJZ1vJ/0+VcVt9p9dSN1TY5/keuUGBbuI2/7KyFgOjYWGjESzZ7bULAoPE0aVF+MHXzuuK4f0EjZgsfUFeXlsPE4Xh96j+hTAwLdsZNBukuL5yW1fmy+ZosuAOiW3TgoqkhT1xwsJQkC97a4BiuFQXG4g8/2xmKnt1FxzSMftSPaqlVy5jvBJutZFcDxIy6wpCV4WMJ8b9piqnJknABM/GMtrbAVII4ez9Y4ybxkKmNw0swMQs1rm1NjsnUfMHrCwhPvcac3/701r+g5idktlAzCzILA7eTJaTyFczXghkT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mapping->nrpages is updated under the i_pages lock but is read locklessly
as a cheap "anything cached?" hint, e.g. in invalidate_bdev() and
mapping_needs_writeback(). KCSAN reports the race:

  BUG: KCSAN: data-race in __filemap_add_folio / invalidate_bdev

  read-write to 0xffff8881004c4178 of 8 bytes by task 3600 on cpu 0:
   __filemap_add_folio+0x6b7/0x910 mm/filemap.c:919
   filemap_add_folio+0x1cd/0x380
   page_cache_ra_unbounded+0x1a4/0x3a0
   ...
   blkdev_read_iter+0x21e/0x2d0
  read to 0xffff8881004c4178 of 8 bytes by task 3601 on cpu 1:
   invalidate_bdev+0x25/0x70 block/bdev.c:98
   ext4_fill_super+0x2ccb/0x37b0

The same counter also races with filemap_write_and_wait_range() through
mapping_needs_writeback().

The race is benign: a stale value only makes the caller do or skip a
harmless invalidate/flush pass. Mark the two lockless readers with
data_race().

Reported-by: syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
v2: Use data_race() on the two readers instead of READ_ONCE()/WRITE_ONCE()
    pairs, as suggested by Jan Kara. v1: https://lore.kernel.org/all/20261011112940.455497-1-ngocthang2710.1999@gmail.com/

 block/bdev.c | 3 ++-
 mm/filemap.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/bdev.c b/block/bdev.c
index cd8323083740..233750f87e6d 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -95,7 +95,8 @@ void invalidate_bdev(struct block_device *bdev)
 {
 	struct address_space *mapping = bdev->bd_mapping;
 
-	if (mapping->nrpages) {
+	/* Lockless hint; a stale value only costs or skips a harmless pass */
+	if (data_race(mapping->nrpages)) {
 		invalidate_bh_lrus();
 		lru_add_drain_all();	/* make sure all lru add caches are flushed */
 		invalidate_mapping_pages(mapping, 0, -1);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..4c9d98efb7fb 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -631,7 +631,8 @@ EXPORT_SYMBOL(filemap_fdatawait_keep_errors);
 /* Returns true if writeback might be needed or already in progress. */
 static bool mapping_needs_writeback(struct address_space *mapping)
 {
-	return mapping->nrpages;
+	/* Lockless hint; a stale value is harmless */
+	return data_race(mapping->nrpages);
 }
 
 bool filemap_range_has_writeback(struct address_space *mapping,
-- 
2.43.0


