Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8273FCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 04:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBDB96B0092; Wed, 27 May 2026 00:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D945E6B0093; Wed, 27 May 2026 00:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA8D6B0095; Wed, 27 May 2026 00:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B38226B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 00:49:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52D9BC1D96
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:49:38 +0000 (UTC)
X-FDA: 84811971636.13.2F54782
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4D20E140009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 04:49:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kFBcEkzV;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779857376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ksx7IvMYJ9ZmDJ5vSxSBhghEVgteTDF7e1+UXliPhXE=;
	b=0NeqY6Twlo/1KBMGdWp3eDcXLkM153RGky0qWkbqcqa9PSqSlsvDt7esiAj+4soaEiBV1f
	S9YBHjnsvTyh7RTInxbK+s6xopyujMFBsgVqnloDkC6MRNqaNTk0l/HjiW1v+Gc/07WnUF
	8PhpEc6Q0nP6BHI9wDfNwCfvH46o68A=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kFBcEkzV;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779857376; a=rsa-sha256;
	cv=none;
	b=X1IIl2qwq2jPDjp5LjYemv4/xU+CVyiCHouN6oWiO0lmTnG4jUtvgKQS2Ns4/df5ld1La1
	F5yJzKnJ9u9tv2jRhrSMu/0Vfl1U6bXEr8y7NUHO14y11pekGhdtjpN2U86e9iFFDkYPEu
	3cOulR98IZil7BmjLaIvoNU09ZA5EZI=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c8016d642b2so5063086a12.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 21:49:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779857375; x=1780462175; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ksx7IvMYJ9ZmDJ5vSxSBhghEVgteTDF7e1+UXliPhXE=;
        b=kFBcEkzVLdWTG2eBYfcKmCqVQe8wfWBgVmJtBH15B5AkxsMQpx4jWPZi/E3Q2XWEfm
         bEjPFROQottCWtaIiOO7nPgcA3xQAIRy9CSShjotksO88BU/4nZS73nAoIPT8elgpgZS
         oQ/q88b+ZWIaAp+aaHcvXENZ1UU8si2gLZM7DP4WYTJ+GNT3ljv2CkV+9S3E5RkxpeBY
         zPptmyROzRnSSwToLjkdN2JX1KqMa3LX9X9O2xETubhrlHWYyTofO2WzO0by6gmhVAXH
         summ/EGA9y1irl5YOxPPKCVklxVXQb7BHWhj9q5CACVNcbdQHANzL8MXE0r6p/NVhixi
         jBbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779857375; x=1780462175;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ksx7IvMYJ9ZmDJ5vSxSBhghEVgteTDF7e1+UXliPhXE=;
        b=lKqs3gFD3AsJ9dZZcSfW5EEtAdxPHI6DvDjVxNhUumepdRDzfDVG6ELWpNtOr48qf9
         /tDdiqUU92nARYFDlzvm8WOd8FaFXPwV07rPk+ogf78yNUGpLifs84/bg910E2V5XeXf
         D9IL9AeZZ221FIW4t/nLtHluaANc2McUG+H8eJeOZ6K4bpqQDv0MeeaOw17KG6eNw2hx
         dA+wVOdtjFYgSWbj/QA19Nx/vPMJqES9EuPFF2MefnunzHTDjj8nilBHoBeuUsEVVSfA
         XiJuCHj6/jT03gj50bb2eJyvIsKYARdhpgTx2JhpdJtjVdD7d4dGaMJ6fapHFc3i11qG
         inJw==
X-Forwarded-Encrypted: i=1; AFNElJ8+OrFlskEf1hn17OGPMwGAPjx0A6eEFN72yEfVg+eaXgI5gtOH4q3W67jcVjc7Z0wv31KyaU4xwQ==@kvack.org
X-Gm-Message-State: AOJu0YziD/nuFfni2QNRimlBU974gGQQLkudifNaDXhB26THVesbj/ij
	zjmGK+63m8waIzfjq+TQ2DtW0fQjc4DAEqbgddFtns+wsj9WbAjOYiXX
X-Gm-Gg: Acq92OGgusFdwcyWT3Vj6DhweShw9c3LiWE8L34X7TJF+ULc8F3hZL4IXPQ+qBcJ7zt
	8i+SW0J6aNijlF0sVo8ffoXYxAYONLjW8CvqittTeqHNBeL697/T5W8lvDHptu/VFU7suXtmU5I
	emCwTpepdMFY72xAGsnvnpDjzv5gfbmLVe1F1p4xVAU23CP7hnZl8Ht2Fw3ShSboxqb9AH6zoUK
	0ypD9F3KJaJSPKaKFqoTHbvTDFGohz6XQNyRW1+3r4kpOZC4lRG0fSCnxAX4zhhK9GjHz4Jexdx
	uqqUwHHA94PquOMn3qtX6qXL1R/tTn73vSFXNcjAbeI9uziuUSRMqtfibOhi7xDoOWOKHBXbZOP
	vKNOKK8DhPDD+hqs/pSEEgdwBBzZ6pvsQQjQq3VAWxWWn7KsopJcp87iQVh19JsmIj8qhcy9bpW
	T+NNvBl/BN8uCHfgkrABrXnA+bBTH0R/Jkow==
X-Received: by 2002:a17:902:e88b:b0:2bc:dc1c:438e with SMTP id d9443c01a7336-2bea22202cdmr238827805ad.11.1779857375174;
        Tue, 26 May 2026 21:49:35 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb58dba7bsm135704105ad.66.2026.05.26.21.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 21:49:34 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Date: Wed, 27 May 2026 12:49:25 +0800
Subject: [PATCH v2 2/2] zram: drop unused bio parameter from write helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-zram-v2-2-2fb84b054b5c@gmail.com>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
In-Reply-To: <20260527-zram-v2-0-2fb84b054b5c@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779857366; l=1967;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=wWeEghQAe5NXkXvNqKfo8YuljpN08ui3FSM1U5zjH2s=;
 b=p1wzwgJ3gwvvVn04ePPF6uh4LDB/aFn6+9vSP6I90FUu4ui1uDqy8TlmNZy2nWAdU2iw4W1Ky
 Jfp1gcsQY9vA3sSfO0yTYLUEuIiWUpg0W6toLaFhTRFvUW+rMPu1R3x
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspamd-Server: rspam12
X-Stat-Signature: 356e7q6kxabi79t4uwewiog74j6usp91
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D20E140009
X-HE-Tag: 1779857376-774206
X-HE-Meta: U2FsdGVkX18rYBncWwirA0G8i5jysr5vDTAEH3Fz8ebpyhhav49Hhi377KY0jo4E4DFUPGHLY96PUReHWC/HK6DXHvoARljP6xw4+/bFU3QqfhgwHm4PH4gL6OKXP24WrwugukgxiHrN8oafDmVoY3wp0lIHbpaO0foneXk/9wkmQ1rcQiKH9/l1Uury0ZQqNBJ0c+3HCA57f7sxOBvg7U8tEut8/ouCX4tPbjJgtUgxfSLd2nXzH/YR1T5Afzmr4/Zl+tIZ1qC2bus9gRCQpLSVwPa17f1iZ0rfG6VZeMRZE4V4XQwh0xTDuQ307znz+ZAtK7Fjlfx3OrZPJH/GLpiY84DnDYW5VFjoApyhK0VUa4medmHtdARyP9C42l5k9k5Zd8T7rYYNVItNEesogF5skKGBb6aicU35mnfaP/SyyNyZfeARfK9cCZW/EAMQE/uxD8+7Thv1dc6jT7YM98G97gQyRqNOQ0pBvlNxnIXuWf9YDxzKTzWDnR3phfS4nC0WuaZ4zfnd80mZkdz86ksOR0sBK8StPpvzmLZmQHHEXL5SRt2fR+mQLlr2EzSOaLgsgwywH5lFY6omSYpip1Sf/Cm3xe7Xwnp4I47r4ssDkrAagUwG4i4FK2pIMRIP5ei5qpcDrF6MFkwH5+sivw00eLwwXlG1Kv30aSx+hlr19ONb/nM6oH+3BNgp/WslDe7aVVC+1bVYcW7PSkN5Yo2sjhnenxbsaAbJ0h6q2xCOfr5Vb4A5nLLJ94IeejXadVWm2MoUk4M4DE4nZ3Rqf1v8uesAonEJDrpIvsE11uU6PAFZMLoxZvOTIWL2+CVwUcBQq9Yw8HriL3+5fsYewty+azr8RqQC3p/rNgNBRRgyFEIp3n4D2d1d6rBm72Ktc/QIoZxD3wcch6FBs39lLRl2EXC/KejUvFgKSwyWaJWcYx5CRVghooPu29EaALdfQsgP6ZcXv/wnANLRyot
 xc9yoBn9
 fAFUvvHNx4J3uTpBowWb0PygRHp0j5D041dRUtoGZ10LJ+VW+O5X0stso5/w/O0WgjZVYcGqBWX+Q8aEP6YdnDHwZUfDE4UrZxvXOe2QNr3xfvuVhFIdnuhP3yIcFjPseBuG+IltUONtL0HA2wVTvuXkG89l1D2YsQ4MX51mblDzGLC7HB9jzn0AYbBhHZRzFWn24wsQpQ3kAFzU346P9cJuPPoIdy4EL1owNKU9Ph39RXQg6gu0L8y4DjEExNoY6zyB6oH9d1QRvIeBKY6IWBGke1O5Bmq0uif7UFaofoNonRPmo2E8WkvPuu9yTUbLoFRFxX+qax+vArioyQwLDHIRcgOjvzsDTvmys7/4MmsEilnswh8iMqwHE6SkBvsA02KeCv40KY5A+3UI7JOflKs8fHE9snWMmyRS9oITyXxQaINAjVVu1+K4Q9RpHJ5SeAbpVIkPK2Pk/zTrubFIJpjuORohr6ipNZReUVdqFpUTerkFQOUPBx1F0OKe8TNoObEh2KrQLNzFKDM86ST1OXm9FCC4hEZa0dJxv12bcc2JIMI/hBBnhFCK89Kx8jtNTdS6Q4wn+k448DUV5Qky3MyxqAh5/3kAujld6ZkIkkVAc7SzOly0S5JdIvVxSc5U3xxEQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After the previous fix, zram_bvec_write_partial() always passes NULL
to zram_read_page() and no longer needs the parent bio.  Mirror the
read side (zram_bvec_read_partial() has not taken a bio since commit
4e3c87b9421d ("zram: fix synchronous reads")) and drop the parameter
from zram_bvec_write_partial() and zram_bvec_write().

No functional change.

Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
---
 drivers/block/zram/zram_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b23a8bbb687c..66347915a2cc 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2325,7 +2325,7 @@ static int zram_write_page(struct zram *zram, struct page *page, u32 index)
  * This is a partial IO. Read the full page before writing the changes.
  */
 static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
-				   u32 index, int offset, struct bio *bio)
+				   u32 index, int offset)
 {
 	struct page *page = alloc_page(GFP_NOIO);
 	int ret;
@@ -2343,10 +2343,10 @@ static int zram_bvec_write_partial(struct zram *zram, struct bio_vec *bvec,
 }
 
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec,
-			   u32 index, int offset, struct bio *bio)
+			   u32 index, int offset)
 {
 	if (is_partial_io(bvec))
-		return zram_bvec_write_partial(zram, bvec, index, offset, bio);
+		return zram_bvec_write_partial(zram, bvec, index, offset);
 	return zram_write_page(zram, bvec->bv_page, index);
 }
 
@@ -2743,7 +2743,7 @@ static void zram_bio_write(struct zram *zram, struct bio *bio)
 
 		bv.bv_len = min_t(u32, bv.bv_len, PAGE_SIZE - offset);
 
-		if (zram_bvec_write(zram, &bv, index, offset, bio) < 0) {
+		if (zram_bvec_write(zram, &bv, index, offset) < 0) {
 			atomic64_inc(&zram->stats.failed_writes);
 			bio->bi_status = BLK_STS_IOERR;
 			break;

-- 
2.30.2


