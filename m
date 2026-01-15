Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01949D3CCA8
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 519FA6B0088; Wed, 14 Jan 2026 22:30:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C7166B0089; Wed, 14 Jan 2026 22:30:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3856B008A; Wed, 14 Jan 2026 22:30:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 294EB6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:30:43 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D55151A01B3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:30:42 +0000 (UTC)
X-FDA: 84332771124.01.7D0D2D9
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05ADA1C000E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:30:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XXgWgTfo;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768447841; a=rsa-sha256;
	cv=none;
	b=7mt3pwVIz/hI6n6FbeNOnUQbxTzy2701oYe2hrc4FznEdVisvMmAHFo3HYEC0gVvwDfu6y
	/aIG1ogoVsA3XxDAgITX3qlWpgiufoiJUZ5hHB8nzwPIsJ9KIGe0ODUBYoIEs5brg9xwk4
	ehMdTZVeBZ8n8xIiYNl8+Udcz/6Xv14=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=XXgWgTfo;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.176 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768447841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Br/WVldnYvp/Xqxk58ta0hPmlF4BkmjTzaDCdRvzNk=;
	b=ALc/LO16fkuLPxD3B4yJWvamqZ4BBQuE+g7cQBcWGLULQyEGg594OAmfwXQyICsWXkadtS
	dj6Opx4azb6LN5irUrdjBP693Bhq9InDe5csDQUl6MKpPf+Up37/1rcrwSRg6LNhoBh3SY
	HvYAHQuJKm8BYEb1MADPalkVs9LKucE=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81f4e136481so204166b3a.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 19:30:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768447840; x=1769052640; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Br/WVldnYvp/Xqxk58ta0hPmlF4BkmjTzaDCdRvzNk=;
        b=XXgWgTfoNJ1ZGbaBa4yAxUIZVl+r6Iq/R5Hk4kE4W4mU5CtHm2+/435PPa0C6DlEiU
         6+jVO4/UcalxZYe4dSTeCjmvSzf2ggGCfWmmbAZI8K8Yvho4vhSRBR6SkIudAw8GMf2u
         0wK7Py3uwCXlT9uIz0NPVvyKu78St0gyKPDN4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768447840; x=1769052640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Br/WVldnYvp/Xqxk58ta0hPmlF4BkmjTzaDCdRvzNk=;
        b=Ago4FhO86SARZInEYifP9l1dukdNbJDdEXZNud6eGOchVS+xuGlN4PaSebiHxCogjm
         Ax7JckYekJoLxVsHC1ndX/KtGdfgFQI9lEYeO+L/6DF9hcaMWXTh1GMcqQh1wB73ZAfg
         oddkB4HASEZuIM2DtMizkUQCql01eZoIlsItYVrFQ3ocWoZeM0iriTqYtSNzayDgCsJj
         xVyAMJmQx487489dv81Id6VlIuIDspFveVvOHZHmtjCcwP+HYdY0dzHIeCmK+zpeyUzt
         LN5C2aQBJyn+vw8IW8nAGS6mgS0Rv1oYA5+4iM8g9r9n462ohhYJWCA2JDHl+M5sPImt
         oefA==
X-Forwarded-Encrypted: i=1; AJvYcCUlOJkhP7sQoUnWCENpGSuXrOqOkCeElos7JUC3Np4bituQ1bRy3dJYJIT2QAFfuW7Ls6CrZVrAEQ==@kvack.org
X-Gm-Message-State: AOJu0YxIH5gGgY11LdUgSvvBOd8Mzhmi9bRlxkxMk2j4A0Wqxin3UolN
	HrAe7yqJ9lo/ZRZlG5zxaDjULEc438OhJ1J/vxADpdSlIFuASbfpzcMTIZdlZGdeBw==
X-Gm-Gg: AY/fxX49oevLrNmYNwbO6Ynfd+3npDUwUlH+YD8sq82T9Ko9NHawk/zpI4w1fQzGrmL
	rB0UyqulossgDVGBlcrKYxIyTnkS9kTDVB53JrC1KkB95MOBZW34/OWkGQcbrmsU/4ZSmMzOHAv
	Ez8pnFJYH3ww5SW+ivOiZHQ8Ipva3zUih5dWa60/SA4+vx0HAnKnVtzD4ploNoUfEGTKvf5UvgK
	E0MQWnLwyhUIc1ZziI68mQZGJfp0IxUkSPZ14QpV4GLofr8/t33wk+lNlwktwCoLxnFNATe17+r
	A1gGFo2aCunv5JZqMj2xpniw21hcFTz4rUYFIciraP/bVMHGZXj9CrhpgtdNWWuPWjmZyM8CQIT
	9ZYEobBnzCFUzP3ASr7yN0Q2qNulHfuYIPcINwrBVaeeiOcHkQ9rLphlrPQiTArRAMt4XVpxiw7
	C7OXTR5/W47CHsPnJw3M0/wrxtsLFzaRa4k7bHZhUXpphwmV6PjkVn7VV5Hg1EV6y2zHnnqQ8bc
	Q==
X-Received: by 2002:a05:6a00:8d06:b0:81f:852b:a91e with SMTP id d2e1a72fcca58-81f852baa95mr2718846b3a.59.1768447839957;
        Wed, 14 Jan 2026 19:30:39 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:36c2:991a:5236:1fe5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f8e6a728asm930852b3a.62.2026.01.14.19.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 19:30:39 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Chris Mason <clm@meta.com>
Subject: [PATCH 2/2] zram: fixup read_block_state()
Date: Thu, 15 Jan 2026 12:30:06 +0900
Message-ID: <20260115033031.3818977-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
In-Reply-To: <20251216022727.578BFC4CEF5@smtp.kernel.org>
References: <20251216022727.578BFC4CEF5@smtp.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 05ADA1C000E
X-Stat-Signature: 8gge88j3xybjm4h96pqbb4f4197uxrm3
X-Rspam-User: 
X-HE-Tag: 1768447840-551665
X-HE-Meta: U2FsdGVkX1/vHZslpPuN5jMflgTvVhm6YhCampu0/32PhvBBE2dWlBPtHLYN4demnozx6FUYYvHIsK1Lc55bs0tdhuV+GJOMDDmBVhiY3ASRcpBRa8JZ0QGFswlEMu5Wsclq7OjdMrm3WWsi1XBy9KTDBSGs9S28/SLA5ehMQxsqizMWaRGP5LXWUoVcI+ANXIiPA0aW/cOp4igc6HXrnwQluynbIDSZ540D9L0eqCJOoZSeoo93w58QoIBJsYha5kfhEFF4hIiKAFYG6a+6Y2+bEFhA5E2TrqiQ0L/O41RHM8G4Rv9B4b81Wc/4lEHx53PIfxGTfFBJVeTbcUX8yaGRy0O6zUxhjgKyiPdyvtXXNlL5wl+U5DaCPzvS1vaL+3dO6Jss2XVbBt+ADnecrSH6lYoHp3gehLblVyaBdILNMiXJssQ5I80qn+7BEt6JVw8gAdcecBzATU1xvGZ3kgcD0zVp/hmA1yRECsUkzyeMtRGfHLMdV1gC9eayY1F6LPgP9IUO5NKigrTVL5F0MCjfsImXrAsxQoSKGyGEg+50S+ERQnR4Pl0dCPpX2GEoSPrlu9Xf9lwU0KaBjdTZ1SE3giqxZgDUFWg+s+XElti+e7X+vq3JlmWr82O77pJgGqiUx6k/q1cJCx0nZCIurpjF5LZ2YBseYK8zuvjKt4Lv2Jsqk7gOuLUGZ6U6LSYpt9ipGS+DNMj+rBoRZclK5LnkIyOqHTgsXSyJfLIR1nGbjr48cYkIRgHWV5jL/r+bS+MIMw2bEL4QiDp1upI8KAwT+dXgrXQT/HrGjBD6wO5v7AqpV/+oEhnuaLpKO9VOM8uQPV2axYKG5cB2OwJXmoXNFPlURACB1PSB0f0m+PoY8KnNcDKBImiLf30mPSZdftdzfL6/WnLOHh3+7W8rcwlxgkI5Qd1RdcC99pxZiVnzXetAewBHRp9sSCOSb9T3rSpKt9G4eTEKyPgh5Cu
 jI/cLa40
 8x3zihw+edcqe2obTm11vAlYdnnn/BfUyFNgI+i5pYBqFWU4Bx5RLr+OpxF/dNfJG7qRyxI9NuQS211YIfVSYTE2e2IedgNsr2izeGu5lBxFO/yQ31GEEQFWOrHENvTao2GB0Gqmv4nT1z9Q7eWmRjAbVQRIQXfq4ZyexKp4jw2/Nd3NfjIgdUBuZck/CKQNCztRqKGgazyecYxRCAGeof4GPF/WOEvxnuEACq3ox+eFhU/umkOvAfkqTkvcN679iHU/2uzxH5nhONsf0T0yUhmyJJ5IAEKf5djymV1uotsphzrD58xbuHVMCM9qvVnn9gr0O0u6g1jQBC9v2YGXOj5KcWBXA2YrzfOj3tgG6mDPLxt6z++doZoGX6dkrMmhyIm8OK/4zcQxjlFDjxJPAPOjfaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ac_time is now in seconds, do not use ktime_to_timespec64()

Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index cc51aa8b6181..912711faa4e4 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1579,11 +1579,9 @@ static ssize_t read_block_state(struct file *file, char __user *buf,
 		if (!slot_allocated(zram, index))
 			goto next;
 
-		ts = ktime_to_timespec64(zram->table[index].attr.ac_time);
 		copied = snprintf(kbuf + written, count,
-			"%12zd %12lld.%06lu %c%c%c%c%c%c\n",
-			index, (s64)ts.tv_sec,
-			ts.tv_nsec / NSEC_PER_USEC,
+			"%12zd %12u.%06lu %c%c%c%c%c%c\n",
+			index, zram->table[index].attr.ac_time, 0,
 			test_slot_flag(zram, index, ZRAM_SAME) ? 's' : '.',
 			test_slot_flag(zram, index, ZRAM_WB) ? 'w' : '.',
 			test_slot_flag(zram, index, ZRAM_HUGE) ? 'h' : '.',
-- 
2.52.0.457.g6b5491de43-goog


