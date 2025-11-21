Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02D6ACFA753
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 450AB6B0031; Fri, 21 Nov 2025 04:12:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4286A6B0088; Fri, 21 Nov 2025 04:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33E5B6B008A; Fri, 21 Nov 2025 04:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CF676B0031
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:12:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D7ABC04F9
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:12:37 +0000 (UTC)
X-FDA: 84134048754.29.9C324D2
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5239F180006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:12:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XACgg1cd;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763716355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4zf6ptP2u/y60bczc9eahlu7kJvy9Vu9mf0rKKvyiU=;
	b=b6V1wyyINQzVMeTGZHpPlPOiV1ONfNvh9Ix9O/0FWkZyIZtky95VQJ2lMcNh3uewfHoTvp
	Jz7GqQhzPWMYM65g1cdySIJohRzxRTH3rpurEXnW7TOwveDMrU4I/AjsEolsCi531KFfpG
	ZGzNPtRHG/kdPOs/duDedhJ9TdMu6wg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XACgg1cd;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763716355; a=rsa-sha256;
	cv=none;
	b=VCG2Z4USqkuxLofoJtzG9qFy6EBhhripiouDGBOakSNTsJXJhzj6vst/ICznz8sAD/Whhv
	21wglMcVOvneHUp8+3Zs0P7iawM3/kH/AlL5/GaD0weutJ5JStFVsumxRQ9CL5xWyswLe9
	zEFSl5bmiBIl9yrRHA7Pqcqd6oYqdKw=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-29555415c5fso19695995ad.1
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763716354; x=1764321154; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=z4zf6ptP2u/y60bczc9eahlu7kJvy9Vu9mf0rKKvyiU=;
        b=XACgg1cdIsdfhRR13lKZE60DS1BPQsQlOymxwCsNOJY7yw2NqfyT8A1sQENG1uPueW
         KwT+PlkPw8ywwBRmAQn0bJXHFjbm+ZbgMmXUmdavc5T0uGXGdmIJEqP9hk8sz/Y8bnsU
         0Tjsxh/jCuHW/ARF7dGV2NVy8gKugK2pEeug8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763716354; x=1764321154;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z4zf6ptP2u/y60bczc9eahlu7kJvy9Vu9mf0rKKvyiU=;
        b=smDPRKrclYz2avQZ7ZzB9mItFM+b7c1Ge28JHpQ14rWmT0km4j8FDHtbEIJrZjNX2D
         9XtcQstZpEX/AHanJJDbIf/62bY5M8nKf5S1Tdd9AGmu4Pir8uY6EydSp75pwK42O0AH
         LLjaE1K240wUOYpuSIAJUjYONOdWtZHBqlyVriYn9PETib02CakmugPx1gwVplrfFgYh
         lyDpgvuTqECaSRI+xQQUzFl8pfjWOyXeEH1D+Z3n2GmEmw8S8SR63ojpzUFYAlLFxiER
         xnTMHWPrCXgNdYfe+u6pXjiDm/+vNUNMTrF1fcGvb3mU09bgaR6fI7jXzwNxXHdEbUZl
         YL/A==
X-Forwarded-Encrypted: i=1; AJvYcCUMq1IS9xrR9Sdsn/sEmnTRljiQW2zs/9NnU7yxUh9j7QxNu2hqN2BSL+lAGimuu6cZUSQpZLu+OQ==@kvack.org
X-Gm-Message-State: AOJu0YzuMvIfRXrmZKRuR/vVhxPBQXfWtSlgkTQmYZkF3UpzP3t57MZQ
	DwMHeOogLMShHEdaCzOWchEeC/ctGBg2aXnQhSUOYy3A1Moxn913YIx1I+VjNNnmlg==
X-Gm-Gg: ASbGnctTMo7CNFyVG9BJVWd0uuQI/MoSWN3Rvot35hm26QjoA0Cb/oSFyt+30ROmrFJ
	85u3qVX7D3ET7kVY61PBGFIZGfnxQ91fsEZVY4N+PkYQ9kITnOfs2468WXHI3/U1bQv9JkI6jzB
	ZWROwc7L5vvy/VxAlhYAx+jfRtH5eS6Xb6WP9jMCspqYc0JL7+M8+D8M5wS2jWCBcDotyStV64O
	vs++MCRYsNaW1YPew9MB3XOm/Kg3iDDmhNGn/we0YDZAGT+3MZeUvOV/cOiXcyGl8zQgb4rezyQ
	q6hSRr0JzvJDWaa2gdAc9RRPkepflfSvuE57GgwidWIExz5ezh9lyU8YnuMFA1vIrwJl9lcUkUW
	eY6/R48KhwdgYPaLeI6SS5337JnQ+TlK6qxLAl9FHUiPFD67c208UTpIQZ9k548LhQ8reo6N/7q
	NuWKCWSxtY5KYfIA==
X-Google-Smtp-Source: AGHT+IFs3GjIKTMQOEoJ9Sy3yvpDbt7PH4w4q+KYrUz89IL7wlZXpaEcscd2uXhqfdnu4g//o6iAIQ==
X-Received: by 2002:a17:902:ccd2:b0:296:3f23:b939 with SMTP id d9443c01a7336-29b6c6a7bfdmr23438605ad.42.1763716354046;
        Fri, 21 Nov 2025 01:12:34 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b1077e9sm51510095ad.15.2025.11.21.01.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:12:33 -0800 (PST)
Date: Fri, 21 Nov 2025 18:12:29 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [RFC PATCHv5 0/6] zram: introduce writeback bio batching
Message-ID: <buckmtxvdfnpgo56owip3fjqbzraws2wvtomzfkywhczckoqlt@fifgyl5fjpbt>
References: <ts32xzxrpxmwf3okxo4bu2ynbgnfe6mehf5h6eibp7dp3r6jp7@4f7oz6tzqwxn>
 <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_865DD78A73BC3C9CAFCBAEBE222B6EA5F107@qq.com>
X-Rspamd-Queue-Id: 5239F180006
X-Stat-Signature: mqch7dn3eibiznnws7zsawbmh57h1bq9
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763716355-771964
X-HE-Meta: U2FsdGVkX1+4Rim/hePuUv064dccuxYDtKky8csn9684eOvzEYuOt5VZyhstHEjS2rMhw8dymQQfz14j0sJ2Y3aTcaPLpkZJX7AVCQfNqZ2uBFPM95ZovJWSxZk5E4XTdvYGMc+3rwEDKtJsgqrGDdDc9imBlrKiGHFpKGKxzdxx/1CZ88b/LS1aD8smgAboA46I1fBlzlmgi/k8SDqYvx1DPUBhw7Yx8DQfUX0BxMbXCAwoi3ycBzZgmJAO8FNzY2Id1b0ZtSaIpkQjDuWUqvGaDCnlf/YBhNttxZLRQoIapXemR93LR/ouC1+yk9qalQOSG9ta3/5Vd+o8OKI2JqyvyJMnlzDbtSwqopGpPinZGj4jYUHx9g/S8p6iduo54LVu4CjF+/bAa7iT+hPUIfUIKy5ka97Guo6u3OkEtm+kLvgxbECRiS5DA3TDUGFcaC8Fcz2AaJ4J8Srfck8IvN80T+C9KVu31IqIgTSs1iMC8rAACkVB9DAfhg0VHIDkI3a2fMhaPcISmijiMIGKPFeX3rSbaVooc7Z1obw9BKvK91AJzWoDjGdrk4BDNZTk8DpvkCVnZK7lmB3zUg3f8t2gX5Sz2K/wBkL94QlZ/xp6+jgM1SG7nXHkpGBeSmiv2689LIwShNvh4UAbV3+HGg9krm8SKrsh6u4G8HyKHIV9uRI8qPKzqgXI9vGXppkTBEd/AMMhfOj20VTGq1O5tv52yCgWV1v17rACGNpwpqC5Bps2zMcxz4X2x8xrsX/4fbCKBrYE79wTFncrc+a9fxtvco7BIUY/mo2TX2Zrklo6hKv0gAU80FQIS/TJPeSbUFo1K1GuufL/dVuUeupvv04ZBugV4jpBmDQ4AbjaP4AppHnoVsgafw9S14Q63XHNrfgUQzF1mxglXvRXzqfwfhbhDnh9tzNCywhMd9ceAPTEMxXSX/5wrs2AEvFWHa2nojQ3FR+efTbFe6If2Ox
 dvA4wki2
 63TUxJXTAmLo8nSdTDbf+7rF2KWX/+a4iO7eUyg7VW42omS1ffwwmY7wNreaXvpCC3cYsrzuOavO1/4Mpm4RKBsS/9DjesP+SVWO4TpVtH8GgL4zZa1UMfVASSTnCl/t+2irqb+wlVP8h08toRd+kPmjZ8Cw3gemuRrQHd/9cvpNi+0etLG7yR68R0Vd7RH9ILNyutPR0TTqtN+KwDaiVmpixys7Zc3eidS8exWG5PF0c9d0WRwQBvHBBRF0bFevPqXnk1jXe2wEWyh4mPOAILK/W5MB3YzpRirKblEpM/l+om9Hh1tAMNtnIJaxyjnEWzX9cw0fTtf0pBrKvZPOElpKymrx9nITfKAmrVxi8neFgghk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 16:23), Yuwen Chen wrote:
> I used the following code for testing here, and the result was 32.
> 
> code:
> @@ -983,6 +983,7 @@ static int zram_writeback_slots(struct zram *zram,
>         struct zram_pp_slot *pps;
>         int ret = 0, err = 0;
>         u32 index = 0;
> +       int inflight = 0;
>  
>         while ((pps = select_pp_slot(ctl))) {
>                 spin_lock(&zram->wb_limit_lock);
> @@ -993,6 +994,9 @@ static int zram_writeback_slots(struct zram *zram,
>                 }
>                 spin_unlock(&zram->wb_limit_lock);
>  
> +               if (inflight < atomic_read(&wb_ctl->num_inflight))
> +                       inflight = atomic_read(&wb_ctl->num_inflight);
> +
>                 while (!req) {
>                         req = zram_select_idle_req(wb_ctl);
>                         if (req)
> @@ -1074,6 +1078,7 @@ next:
>                         ret = err;
>         }
>  
> +       pr_err("%s: inflight max: %d\n", __func__, inflight);
>         return ret;
>  }

I think this will always give you 32 (or you current batch size limit),
just because the way it works - we first deplete all ->idle (reaching
max ->inflight) and only then complete finished requests (dropping
->inflight).

I had a version of the patch that had different main loop. It would
always first complete finished requests.  I think this one will give
accurate ->inflight number.

---
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ab0785878069..398609e9d061 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -999,13 +999,6 @@ static int zram_writeback_slots(struct zram *zram,
 		}
 
 		while (!req) {
-			req = zram_select_idle_req(wb_ctl);
-			if (req)
-				break;
-
-			wait_event(wb_ctl->done_wait,
-				   !list_empty(&wb_ctl->done_reqs));
-
 			err = zram_complete_done_reqs(zram, wb_ctl);
 			/*
 			 * BIO errors are not fatal, we continue and simply
@@ -1017,6 +1010,13 @@ static int zram_writeback_slots(struct zram *zram,
 			 */
 			if (err)
 				ret = err;
+
+			req = zram_select_idle_req(wb_ctl);
+			if (req)
+				break;
+
+			wait_event(wb_ctl->done_wait,
+				   !list_empty(&wb_ctl->done_reqs));
 		}
 
 		if (blk_idx == INVALID_BDEV_BLOCK) {

---

> > I think page-fault latency of a written-back page is expected to be
> > higher, that's a trade-off that we agree on.  Off the top of my head,
> > I don't think we can do anything about it.
> >
> > Is loop device always used as for writeback targets?
> 
> On the Android platform, currently only the loop device is supported as
> the backend for writeback, possibly for security reasons. I noticed that
> EROFS has implemented a CONFIG_EROFS_FS_BACKED_BY_FILE to reduce this
> latency. I think ZRAM might also be able to do this.

I see.  Do you use S/W or H/W compression?

