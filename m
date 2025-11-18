Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D2D2CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 03:47:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97CD68E0014; Mon, 17 Nov 2025 22:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954C58E0002; Mon, 17 Nov 2025 22:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891B18E0014; Mon, 17 Nov 2025 22:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7829F8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:47:26 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0FD3B12DFBD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:47:26 +0000 (UTC)
X-FDA: 84122342892.30.6D0A1BA
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E004C000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 03:47:24 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="I348p/NX";
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763437644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DEq4jkpDrS/8x8zOSTD+sdvZrjiLgYoxLssD/Mj00wQ=;
	b=WhzE/RALs73cOoO+iE79lz49VyjiFGp/aaXsMXWx/AStwiWTzwuB81rRNNecQ3a7XIPF1i
	v3hsug1XfQsnqBOcmV+E1ZZYlz8McFQLZP7HZRm2ryz684tBtUCa7QhOy8/XZsigskLU6w
	BGeP7kyc6Ii4r/4W+PrjcWKblyomVeE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="I348p/NX";
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.43 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763437644; a=rsa-sha256;
	cv=none;
	b=KD/++tN5NSmMEENR9vjKdnY6ao9Dm4UyG57CmVpWCgd/fKH8JrbKWxcqfnVBhyStgYq9l6
	7W7nAiaSMND8+PtkdPHZxXy2nBDYoeJ9WCYWjkucwwWLolFEa7sEtLvAMJ80WhbKO1qKnl
	jWaGapzPsIlrL0ozmA2m3OnsA2xQjjk=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3434700be69so6733847a91.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 19:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763437643; x=1764042443; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DEq4jkpDrS/8x8zOSTD+sdvZrjiLgYoxLssD/Mj00wQ=;
        b=I348p/NXwznJBUULiDhQZbWvcWqEvD7DmAvJBs+cT65t+3IU3jAzSVkaGw9xBt7ieS
         Y40cWeHTIxDJB8R+6kT8jHkMb8gk8t//3ccG4UOHeknGYY8LLJPMPZ1sWKlWpZ3vdOTU
         X7l37KK9JrJvrMxvC0xPspMIfPwJcgxXYzC40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763437643; x=1764042443;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DEq4jkpDrS/8x8zOSTD+sdvZrjiLgYoxLssD/Mj00wQ=;
        b=AnlJ0gSAPTuKh8+OnJZD9kmIuGAKY9mp3Y5XVfm2pkVmYY4+/tn8T2c933uztA7UX9
         Fms9sy2I+F3yduc4lBOs/zU2IdO+DtCbTTsMAMPqkMIlGSjAwWRL29tlybNmdCESIux+
         BVg40kXiHBl7x694UFU8GDtKrlar57uZ/gePudZlfkhHVsbftmwJi4PCq+hhJdwcJY6E
         TVrgXo9N1Avg7pXh03EYF4N1dN6QuwsA0M7RQcfTnt2W4YXHPgz5dOQg6aAykD69OtFh
         hiqWppU1EZJDr2tNDiZc+aJhm9Ax4ZfjMwkeGeFIvsOnjkJi6TNrflEU+fI5yVUvUxlr
         Dfcw==
X-Forwarded-Encrypted: i=1; AJvYcCVU/y9ZUAn+/YgcNBIOXTRYruQI6SX8ehhb6Kgz7+C5Bn/UR4lctrxjuuUkV9ebsONIOr0U6uQK5A==@kvack.org
X-Gm-Message-State: AOJu0YwpPvyF4dnn4I0e12Fl2d2JpH8yRPed2UKNqk4eKdvOpTsIccFz
	LsDkSHYWvluCv/GzfQnrW+trAqrGoLW0xIdZKMwLXg6klKbg4Yd3xX78uzjinVc7SA==
X-Gm-Gg: ASbGnctc5owami1nUZznZigIdqmyWFC5rsrM/FdCfsuux44ZHdbt0X8M5BKKu+/BDce
	WAwuS+HaGwvJ2t2Bn0DKb0Cm355cWLC3730nuELFo3RjIXgkLF7urgU5zd9PXlBSRhG0ob270IH
	JJEqAcOGKKQLxlGWmMIST2ushny6ZdaEBaMybB+JRFPLraMsIY5pV7uiMVWTOjVkb/zr6SnICXa
	G8PgSui4V/FlGmJaSEdxZdRibTuMRtOzBu1eetP/YCeVkNChN9ZfGIT8XXIMrH4YgfLXGUCi2nx
	Njul5OVMpYOaMuTPpl4LLoZzHnjjPUtjx1sWH+bjgflbENUi/kkxNOz5jQ053Vj3pLeRJ6XU8jC
	ntlxJRPeR0GrWIEZr0pZWqcUKQcVPmPgzojXTRZl1uWIQr0ej4SS+0CPl7W26GtpLprx+UoOyfF
	X5bdsS
X-Google-Smtp-Source: AGHT+IHnpK1ryIze/dfKJb+3lNvusJ/r2/c4HUclDB5JaPM+8XASmzJpE5qTgYhWf0sAgR2kSDaSyg==
X-Received: by 2002:a17:90b:554b:b0:338:3789:2e7b with SMTP id 98e67ed59e1d1-343f9ea58c7mr16461750a91.13.1763437642955;
        Mon, 17 Nov 2025 19:47:22 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343e07b6dacsm19932738a91.14.2025.11.17.19.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 19:47:22 -0800 (PST)
Date: Tue, 18 Nov 2025 12:47:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@google.com, minchan@kernel.org, 
	richardycc@google.com
Subject: Re: [PATCHv3 1/4] zram: introduce writeback bio batching support
Message-ID: <ysxyj7q5fuwfbvbh2o5ewsl4plzaaw2wcvn3qemjgzz43hvboq@d2k736awhhpi>
References: <3nqzi2v72dsef2dte7iqe7wahrbzam33druh7klsh45zvefdm3@ab6stznzdxmh>
 <tencent_900337D4388F6BEDF9525EFA974CD7669106@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_900337D4388F6BEDF9525EFA974CD7669106@qq.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E004C000E
X-Stat-Signature: i3moujmaf3o9mnxu6qk88fdyrqxixu43
X-Rspam-User: 
X-HE-Tag: 1763437644-356820
X-HE-Meta: U2FsdGVkX18hnVA8JKColb3LL7T8gOeXukqfTDn7qRIHi5oqn5UuhsZ7HUDV/JsWa9Pw5g24o55fFlQ8Qc8pYYZQhi9NyaY/xjRVsuuLpSxigAJ+OyoYAB3YVNZJiPjefAHr3fxc93N8CdWu5UA1UHfFlJcawcmJhcVENOhbHh3m6+zXvw+2D5cbYFfVAqy2Kvhmg/vAJJUJy2VCWMmdePjDNLfR5Nti0rBvjk0TW06cxh5kBeK2vuaro+p7YzrMWolqH9eGmVdeOE5dbHM85dgwkRfUQJZakz1O+YV0SUKyLKETg6gTzQGiZBrvcZVLX6ZNHrbc8lo93qCU1dj9eFuy4LpDHAMce8/aPlhjPBjTslQD9bCJCydV8kxgpzc9A1/M/Q2lCHtvD3by6u8TnUL3FTYOEbJe0quNAhrFcioKLSCHf8WG00MDm2jpiWQoBXfkXiLkOxWlIovmt5BeQ5RwzqzLyvJT0X73jOaKxuPDyPKvuzPiGgc15aMlpeFzTBANrwQt1hNgOOnepn76kuQeq+EcJ6VFiVP6UYW6tMRpHlEbVAEI0xWj4fTuNT2ish8EAj+gm6lrClSDcTkNOL9kOxD3aDXmxhlPYHVeAIEbWSKjEunIHU+046WJnSnz1FtI0cRTHgt/xbAIh7/ZmOaqwBakr5u1OV5kKobcBJLK1fhegIKgV7hw1+nnOknrJfu3QUJUEk2iZMDqqYZg2/ePL93M8S+Wf/Y9QoVDSMGz26n5iCbm1hwG0xN0kQb9disequQOatSETeGCglcMQFYxvMDoRsRoeYysqk5z719e6oFkOgL/4LDWTmLgu+ZAYnrIb2kFp6SbtjOdEtchNLBYdVyMSuLJy6giuCRGswH7uY3bwOaosCcqjDb3rAgheR7Y5/Q6XIwa0B8Uis7loHtxpA/LCNC1h6nYipD1cOtAKjBt5OxeQPUbGT3A1dnkgrzmyLM33wrNxrQmfoc
 VQHspqnf
 c9buSo03yfVPZzj+QoW+j6eWP1QykmX6TnxJk+kGv3100N9ycUIYe+bxFiubt05nnwB/GTT6dEsk3Mzs0MMPOWa4vR3MJtHBFTuz0FEbyJCabnGEJ/zgfpi/5JbGOHDP+Rb72DH2B5bbz3lDWKCrsesNjPS9RjEN4DtbXyTeQvspPefk3pzkPvkyQc0n81S9TTbiXdDE+C7uyFqJ/8ggfWNtLiPmctNQH8uulREsft4RGchFnMlNJ5fDqSnxXdmlwwoq3eddevRmG2FtVW9G6H9aEzCGgil5eadQ+ypJk/OpuG4Vdh6U+NnT+iGr4g16OWK7GMcPp3x7h8EUhwc53Caas01/dUziSTPbMiLti5/lmSh8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/18 11:36), Yuwen Chen wrote:
> On Tue, 18 Nov 2025 11:18:56 +0800, Yuwen Chen wrote:
> >> +	/*
> >> +	 * We release slot lock during writeback so slot can change under us:
> >> +	 * slot_free() or slot_free() and zram_write_page(). In both cases
> >> +	 * slot loses ZRAM_PP_SLOT flag. No concurrent post-processing can
> >> +	 * set ZRAM_PP_SLOT on such slots until current post-processing
> >> +	 * finishes.
> >> +	 */
> >> +	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> >> +		goto out;
> >In this place, the index may be leaked.
> 
> To be precise, blk_idx may be leaked.

Ah, I see what you mean. Agreed.

I guess I'll just send out v4 later today, given that we have two
fixups in the queue already.

---
 drivers/block/zram/zram_drv.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0a5f11e0c523..8e91dc071b65 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -886,6 +886,7 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 		 * (if enabled).
 		 */
 		zram_account_writeback_rollback(zram);
+		free_block_bdev(zram, req->blk_idx);
 		return err;
 	}
 
@@ -898,8 +899,10 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
 	 * set ZRAM_PP_SLOT on such slots until current post-processing
 	 * finishes.
 	 */
-	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
+	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT)) {
+		free_block_bdev(zram, req->blk_idx);
 		goto out;
+	}
 
 	zram_free_page(zram, index);
 	zram_set_flag(zram, index, ZRAM_WB);
-- 
2.52.0.rc1.455.g30608eb744-goog



