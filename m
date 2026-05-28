Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1721CD5BD0
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 02:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65BF26B008A; Wed, 27 May 2026 22:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BEBD6B008C; Wed, 27 May 2026 22:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ADB66B0092; Wed, 27 May 2026 22:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD4B6B008A
	for <linux-mm@kvack.org>; Wed, 27 May 2026 22:49:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E47F01A076E
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:49:01 +0000 (UTC)
X-FDA: 84815296482.01.BE7C519
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id E52EF140003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:48:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RxZLBbfv;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779936540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRCtt7LbB+SSV6LJlNZfwK4a+gaxuGAqxV4IOSE6198=;
	b=bV7mKgv4LR0ohNavOiAibpHiNtZvIsLHq1S55aE184V5HOdiJtAYA4lsrxuXxo2Z55B0cp
	MSgwMXfbnLeYOw90VhxLwMQ2h49f+pqoY3Ju4KjpcG9uLPLBpif7nbVrx/cDMGdRLbqHn7
	yhwy6X8F0ow89BrZsQBeBf6GdqP2ssI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RxZLBbfv;
	spf=pass (imf26.hostedemail.com: domain of shenxiaogll@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=shenxiaogll@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779936540; a=rsa-sha256;
	cv=none;
	b=2f2E0Lgdxj1xw3kwc/StkDZNJ/6lPRQojAfbIJutJnJaiGhK7FCfZbe8vYZvuJZPW85A4r
	XGZEhPh2h42IYobzqedgOZGsTNfGc08n2Ol2L8vUG/9rAKN/BbWv0IKD2Hd7PMk/xmsITd
	hKHtSpyJpr989ZHr34OYLYXrDULWwEU=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8379e010b01so5334868b3a.1
        for <linux-mm@kvack.org>; Wed, 27 May 2026 19:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779936539; x=1780541339; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRCtt7LbB+SSV6LJlNZfwK4a+gaxuGAqxV4IOSE6198=;
        b=RxZLBbfv4SSqZ3jXGeJ9UxQ5PZoEWDObmJ0uFvAFLxcvN1y0i4bvDI5RkPUSZID6Pd
         VQF3j9UdjN43CjOke13TvQweFbDte21hbwD2doVYn90K6y7eetoadI/RXQpOMqMabOzU
         pieoKRkW4cpIF2xMPQlr33zVOB9SjtZu7nPS802j1dhwV4iwG2Tf7TvIENsTqYqZ4YX1
         DAAeBV0mIzaWzWr6obODg+7OhT8ZCtYt5/yvds6griivqEpRFiR4RQnpTp+Rr5i0GeTD
         e0/vu+p/7VJ4k2NIV7qkcexelWoxx/qE2yjnMZSjkcYzX2GmcZ8lTTnN9iuN5/Iq/PXZ
         EeVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779936539; x=1780541339;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eRCtt7LbB+SSV6LJlNZfwK4a+gaxuGAqxV4IOSE6198=;
        b=LwSEXX1EGshSPkdpFHCCLPHbq2sDG5dj/bcS8GCLE+fZbVXoiLtF98lITfAg0XZ13f
         0ITOIheGPoFRovVW+CTk9s6I5rkte1XmKWpoo4T8dTZvGm7qHuVRqemULA35w3MQ1qZm
         4yx+sBTB+3GM+i8/xCUbOZvAXOaY1nx6klbklNWudMMupYWZ8ipcYaoisTTr9/SKLHQ9
         A2D+ZkFL+g9xnYc8bLpja5fUINrafGGHjooduNJr7GT1lF5kWTsdKXNWdXcSQrGUe9zn
         poyXxBHE6epPD6DOyj3nXsnMQLf5QnJ9wvkrv02n1QOWo6gsVRzhSGddlvNvcoRSY+8P
         oqCw==
X-Forwarded-Encrypted: i=1; AFNElJ8UqA7GYI85i8RdnD/cUQGCn4ABP2BykTFjjyId0+ed8pUFzNT3kqSlY/ftkfvJhClf3PpOnRjn/g==@kvack.org
X-Gm-Message-State: AOJu0YyueXEi8epM1lUaKAAZz0Hd5WuL8Ttcqi3HBjrTceGSmZNXXSTb
	/3KjNND/Y6n7NnpjI2bdy/i/xQQVYPYzcs8Up3/UqduoND00bOoRzycm
X-Gm-Gg: Acq92OGOpq8WPKIenhISU4DnccxvWztaURx6RlFjZfJWoylEXFbxtVuRJLRjD0Aeoh8
	ux47oc01CRjMpj2eCsAc4lIZZNlfK46hII0uLlRQ2IufuOCtEFiZsBAJ+/nMxJgRzKpCDI/IkMC
	rIwW36rKjKKFtfFgF1MsIh8qLRKo3BeY3MiWw+KRKLRFfe3iQamLcJsAsNKfIS5fqt7tBSA5AF8
	gxOsLOeNfGW+Dv6cxDGn1gk4KZoZ5ZEzB5/V/gcDMwEqNykD+WTAFUR/GvEtyNT3U2cjqUuIcnd
	WnrsVyfQlWtYO2dh/6yHEf5FMslZZjmWM548bLci7WNfurcAKjzzGx97I+MTXXB2t3lF0SoB70O
	kfz0GyiE5GgRsuDKhhuChDtNDldGufmeHYKytFP6ZTG/8GB8BG9yUOSygnBiZtBP9EYnFL2VJCb
	6OBKQ7kWFY+9U6x5EEfZC+tZYGcaZXmuHRnh5Zh8kpYqEZ
X-Received: by 2002:a05:6a00:cc3:b0:82f:8696:5a75 with SMTP id d2e1a72fcca58-8415f66d98bmr25732951b3a.28.1779936538776;
        Wed, 27 May 2026 19:48:58 -0700 (PDT)
Received: from [127.0.0.1] ([116.80.91.208])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841f3cbcddbsm366877b3a.4.2026.05.27.19.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2026 19:48:58 -0700 (PDT)
From: Cunlong Li <shenxiaogll@gmail.com>
Date: Thu, 28 May 2026 10:48:45 +0800
Subject: [PATCH v3 2/2] zram: drop unused bio parameter from write helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-zram-v3-2-cab86eef8764@gmail.com>
References: <20260528-zram-v3-0-cab86eef8764@gmail.com>
In-Reply-To: <20260528-zram-v3-0-cab86eef8764@gmail.com>
To: Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Yisheng Xie <xieyisheng1@huawei.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Cunlong Li <shenxiaogll@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779936530; l=2072;
 i=shenxiaogll@gmail.com; s=20260517; h=from:subject:message-id;
 bh=tYP7A1cG5Idkt7RgPNKfx9ASoxRRbHTZbBSShzPi2BY=;
 b=WvOxxhTWOQZ0Yi6BKmdrNNVLoeyNrSBLlOQFAQZmliPst4oSeJu5PmPvbZkCbV22dwIAslJsy
 19Hz8Yf/4tjCiI+KF2iqOv5oC/O2lF3YZmkbnllf0Fq2fhIawrNP7PU
X-Developer-Key: i=shenxiaogll@gmail.com; a=ed25519;
 pk=SKFifnqPdsvsjuhUiq+Y9vtCdhyZ/LrRcfYn8eRq6AE=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E52EF140003
X-Stat-Signature: 1ih663yebzx11soifr8n6uewnw7fkipo
X-HE-Tag: 1779936539-993445
X-HE-Meta: U2FsdGVkX18Y/QRJYgNKbqelnlrztTy+YyJt2dt7Xb/bvfy0yRghGhlTt0O+ngox4X1MFrPAMombSytWWKUJATbY2Qmxw9xbiyec411ickVe+GkfOnS6FoOfqQ+MET/i+iJAQeKozjOlDAnLVRfc+vC6QJAb7NBM10wCPAHuVCjxlbtnN6Q7HIkhCt03lR3dliWbFOIVTn7OPmgevtiWLhq29Qjo7h0+WCL1aYrZDtXPwbCTTbWHpuCD76VNOL7DBJBPd0fo1cT5GBP+5G4scQqb7fBe+EkhqJOuM1gIZlBuqluB64btkWaVUUKZuIgEUIzievjxEsO3j4hSYLeVCRqeHq4gNlKt8z0Ad/bFLQKnjI/bmiDgJOu74Tx7PHLR3TrDOuh7ss47SAivU1gTIXmpdPxvxw1KWuw+GsryuaVcX471evRKBdzMl6bmN5O43p7+pdZpqx6B/Xi/3er6GQUXIB15GJWSdMdLqs/SD46j+OBe4GhWZWLGRt64njMq4xgnCIxAUceIqAZ3QjWX4uimenkzJIbUytNVrh2EO1yxUG7l/r3AZQtzOkIijR5zueZonBZij/p8ovypHUx+zFXxYantkg4p0czE+OzY90sD7nUQxpjxlrOKnPK43BZHwxvGjVXiM74FemWGM1Af4XeQoW8jwHVxvBMCi76Qp84KJU9uu79hcpLYq2Wq7YhSMJNxIJSeHNbEr085BTKM/560itrj4UiDLuY1IQmiEP9otHRa00mmJmfKkJ2TgMVJJWH+4PIr0k+9mtet1/fBnE6fiVz41A2wRLLZMr6zkivJBt4kI9bay+5SL2FXBO0N7Va+DoSyRUx52JgAOGMwZdRXQP+2MmsG7XF5yFSvh2l3uZm9PJtL7G0KBWQPhN0eXu2KtnPCZeIn8NDwIrMiLkH0c64rKXbNLywZ+kOldeqauMoeeDOPt7iTmIeUJAajse82IIl1KXd8WWUtXFC
 2BOjseed
 syr/COPH4YJLhmEIgKCJ/Tf3G8CjRfANA0SJ5fuzvES1lVxXi62QLC3uQZcP36Q1NjCH1nXn94nQNh7/3KMe/nMzYqbvcV0TtRfU/wmVRpiB3plu8VtZ1iBN5zUC9Z0sptaMiRIqCXMtGykdmSRTPiw5pqGutE4FlAqBJNeYOn/tSz7dhId2Zluxn5QlYRkILzYyy+jEivwh1pJ3tSfoXBk4YabeKc5Z2XB74frIv6ARQABv1z0gdbOB84Du0DzFvGdqZZcb65wxF+MHUSNXnGCNYcEF6lcyIQigs330KWxkFOQ5FvPWiO+hhM0hAi3S1JJT151QWacFrfp24NnluP2TsCWPLwxoEijCSqXrHtkQ4SQu7+uB0n8pyHrFeLOZfDjc6J0n8a3CBFiIyqK1IiK7gMfxtGOIQMM6AdN9aRuhS4uPUDqxZGK5fPFtnH1VG16BdUhhVCf9NwPVneJKR5x44rdgEnSdUE6h1co55R7Pf7PoSEXKU3Z6i8JtRVyEzrNsjUU5J7/ynCOrzb4jG5gAo9gCqjw1ZcYkE
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

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
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


