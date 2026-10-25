Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D85AC606A331
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 02:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Puypft3Q
Received: by kanga.kvack.org (Postfix)
	id 929846B05B9; Sat, 24 Oct 2026 22:19:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3D76B05BA; Sat, 24 Oct 2026 22:19:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3F46B05BB; Sat, 24 Oct 2026 22:19:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8A86B05B9
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 22:19:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2ABEC04D6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:59 +0000 (UTC)
X-FDA: 85359540798.12.6E21AC7
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id EAD7A180003
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 02:18:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Puypft3Q;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792894737;
	b=GfnlLv8o/dBYvevd1IWqXclnJU1L+U9tHDumq2XZVakZCf6lNqkbv94BJ0rSG9mmUwbbCI
	OZd+0VGCQsCUcm9+lrzrlZf6HJxxtjc8k9oHYQ8ytKWT5zviPzAWV2u6cqbHsmU2ZC4Z8z
	jf/rjovxm+tcKtH892A4rs9rj8chwoY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Puypft3Q;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792894737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l+1W8fCH2YVVqsp80PGoTHVKE1lHVqXbpp8Ot3nWXz4=;
	b=AZAjNM04hNNnXD+hn+L3CvsD790kYUZ1JuyW5vATsUFlhpYHb6quEZZ04f65KbAezcOqDO
	paf/EgX7KIklL+4iszdaljiUapYYkn0fgWJ5Po1c9TPbcK8yNRryml7WlywcAxBepRHy34
	IbDFWd/BJBSO5vs8hmpFI9cLP2BLbAU=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-353804b591eso3569634eec.0
        for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792894737; x=1793499537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+1W8fCH2YVVqsp80PGoTHVKE1lHVqXbpp8Ot3nWXz4=;
        b=Puypft3Q2nZOqdUrxE6QV5vQzdaWD3/M31q2KiBNHxA2xJV1Ws1jtTUnDNTsDI6JiP
         MQTx9QQJ+qZJeTgn0+/xocvGazvcYGzgnarJk2Yx4nd2XGECROuiedmB+wkKYkGFmzyB
         mI2IiM71mfkJ7f2mg6/Ml+fcdEBeUP1Rq15fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792894737; x=1793499537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+1W8fCH2YVVqsp80PGoTHVKE1lHVqXbpp8Ot3nWXz4=;
        b=sHWvMdrRnJz8ZpMEpoGcd3D5ARYpBFlfU6DucpOwvCp6V6H/mv8HivXbKQkuOH3Fu4
         GX43XbpSONhwnMx5P9TEUg034LgyXgYBojnNFMKyJfPqYgjzGsbL+oNgShbyacMFzqoG
         3VzPQtGn1jSv+LKVPDNjJSShbsvVZtMe+gZn8HYIhcYYMg2aP42MKX80z0kj5F2yHURB
         0de7noJxkxmLXN4UclA260JP58sM4+GKJM21/rf4+/WNKOMhBWi1dxL48z7Js7L2viEj
         bclU23v4a6Q1H06gTgDBEerFpnB3BWvSigmEPkgbkk2dSzs/3LAOo3IsXF9u792+yGAR
         3/pw==
X-Forwarded-Encrypted: i=1; AKwUvBzEzBZfKVFAg/h2gqk7ONhKy2+UFWo93DtyVP5u/FoHKb4dU6I909hKenCLiDT2vQxUMpxnDqf4Wg==@kvack.org
X-Gm-Message-State: AFq9FYLG02Q4ATYBVGx2jKRwt1AFhDrHJ1Cqo+FqKRhkJh+/hlOnO2Zq
	qo9afMpgUDpZWIfXM+Az/yxiSP6jefE6Ni99v3yiLDB/xwxmWAmUq07cERULN5VTKA==
X-Gm-Gg: AYBFou11fVB6boqs4Z1jGU+KMuAv6+E8pUoRvt/9IjHnZTcNNZ7yJ22Xk01sMP+4wpq
	pcJGAEiZx1I0eCQbJYZy64u88QAegusk735QvbpJq1nuJgMCA4BMiKtDtqA9PuLPEqktviaWZh0
	ECRJ1DP1cjILBC65+Fu3bJ+YBl43KiKPIjkvV9yMoCOhvy2ltjnSKITs01slfgnlAvbVZ9zL+mM
	DX+IzbQ/7X+o2iZ0ZUyItvEkr8oEZSwiV6qkDhcEmAVrnZauePjnQm+83SXF5OtClsvATa8CYk/
	NkM4j2tZgeujpIMMn2AZhJ9Dr/viQ/mROea6dbTtxh+1Jjg9U1Tm8UP7GumPZodCCnwqw1yxp0d
	NuoirpHtj5ggsCXJZlaPFYz18ht9g1m0YwTltiq88ydci1FfRJ1bqlnwVX53qYi9fXr817qpu7K
	5Ro3vOdix7wWrGU0NpN05oe5RxJa1jLXuXBbmqloz37xAxURJ0qJrafF1hA50dDFrFhVxGVGTti
	mogrJ6RC3LuHmHlo4MtLBGuRkGMsZ7r0flA23VnEqc0lsqyxROHHV3+Gt4oOrigGxzFxmEWq/xF
	GUt+f4ZsNTo68m1yKueRuUGGiVuY0WT9CJJ/MXJLEZdE+g==
X-Received: by 2002:a05:701b:204a:20b0:14d:c7ae:85df with SMTP id a92af1059eb24-1993505df63mr4347970c88.12.1792894736742;
        Sat, 24 Oct 2026 19:18:56 -0700 (PDT)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:9f87:66fc:8c85:11bb])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1989ff2ee5asm10387242c88.8.2026.10.24.19.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 19:18:56 -0700 (PDT)
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
Subject: [PATCH v7 05/15] zram: remove stale WARN_ON() from zram_read_page()
Date: Sun, 25 Oct 2026 11:18:21 +0900
Message-ID: <20261025021839.1542805-6-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
In-Reply-To: <20261025021839.1542805-1-senozhatsky@chromium.org>
References: <20261025021839.1542805-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1edxxe6qjfi9kobuaezeq5yo8epbkgeh
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EAD7A180003
X-Rspam-User: 
X-HE-Tag: 1792894737-673803
X-HE-Meta: U2FsdGVkX1+Nme8BU+Lh96D3LTCRmbOn9gPx+4+Zs5pn4oJ295WwHv8FsNtQG0QKsRpyWozQxvhN3McDtxzD0Bf7FoVoiGgHhfFE2Tv9S+z0Pu1Sa2s4zVAAAUfUgwkMt2pRwQicrGenf8vPPD+F8DP4O5zjClS8sJHQAr4Q3ZpvjZ5pS3fUudvncRIQSJfEJ7AqFbUZNTGPXpW3nvXQ1KfMjYZTeN2hkSwLHIhzUhJYWy5DkyECAEREBNmz14xwZe/6/LS71+CexO3Pu/cAyFow4aG7TEBMPssXYqWFYs9O261Qw5dFkqlkaujYAfL0NTzqC9ekaU8yXb31D89Td0v+GbSM43yy+iM+s9e4nVAfvB+XQfN7AVFx/eRRyRrqe+Bn9dozlCLJydF1GhBEi4fL1rAcpQQo5AysMjBzbM351rEDE6Og8dqNCzEjyoRX9mVvrVAuWpGyhfCW3d7oO+BtAjv101JmdYs5Y7RTWcsHkC6vtB+RtfpY1InPsIlgjwxO1/ijcHeM1EffjwKQ1bNhclzj3nZIUuSUjJx8J4usu1r/q4Y+WapEO9sAjNvAPJe1ZTdKLcVN3vCBhiaOmx1WVhhvMJJjc8/OhAqQjyws1ixL0owXsl22lY/45HGI3eHy2c9geAtNXx/SuPs7dN6CmZIUuX3GDdmcGkdllV1JcJ7kTVCBrB6tcgmEnpUiryN7ziF9HVZR/McXIIsX0od5H6p0tf23ocEalINfRJWvsqs/hKSiCJI+p0Jz+Zp40pAMmfx668/WaWde1+xiTPZU/1T3V4K1CUwKY5CDD4B24vERjUdTYfQwjE3bwieY1Q+r9X0+3DrfmCASYWCBKMY3dE6td7XnXR+bzPfye7y06MxlL+dQsbzhcMT97564Jfb8DC1joSramLaJGKccyuoI/dMaQA+XveXjVNHG6lY8bLFxwKoVdubnouQwVujt5tYnNuDUdF7uJaKTQNF
 SWQ5uXRp
 uLoiTqEiA/RScA7rzKFVY14nvxArgaj9gRDy8k4lMBWA9EHOr2NNa9aAbch9+twYCMN7V9TNfxflDK+BfI8J0OQGEimlSKlU7Jtrez8M17y46LnSP/j35HxrdxGqBzwbS5f9dVdzJKd3a4eRfLMeAM5kubmDO+jOiBLraJq0J9Q0WrHlROcLMXuha5Y8YF5wUONAhr/d7PzByxIaFt6VUnmZ4Wh+KdF3NGzwvpupuMFc4KwaKVDRKy2wR9HHvSmIfN3HrYR/y7tm4tkg4Qx6rq1KxpU1nzW/5R6fQFTdpVksJaiFgHO0FvzQ7j5e5o8qXmZHuf96DBB1q/Nge//j8JxRUBXk6r0I3Ighz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zram_read_page() WARN_ON() is not accurate anymore, because, in
theory, async read from bdev can return -EIO or -ENOMEM.  We report
errors to upper layers via bi_status, so upper layers printk errors.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 2affac25db5d..beae16f22777 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2204,10 +2204,6 @@ static int zram_read_page(struct zram *zram, struct page *page,
 		ret = read_from_bdev(zram, page, index, blk_idx, parent);
 	}
 
-	/* Should NEVER happen. Return bio error if it does. */
-	if (WARN_ON(ret < 0))
-		pr_err("Decompression failed! err=%d, page=%lu\n", ret, index);
-
 	return ret;
 }
 
-- 
2.56.0.257.gf7497c7d27-goog


