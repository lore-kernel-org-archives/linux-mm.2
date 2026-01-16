Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C339D4A5F6
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 05:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518666B0088; Fri, 16 Jan 2026 00:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49BFE6B0089; Fri, 16 Jan 2026 00:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A8076B008A; Fri, 16 Jan 2026 00:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29ACB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 00:08:01 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6B77160572
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:08:00 +0000 (UTC)
X-FDA: 84336645120.01.BCAA8F6
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com [209.85.215.193])
	by imf14.hostedemail.com (Postfix) with ESMTP id F14F8100003
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:07:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kxGpD9gy;
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768540079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LE6O+8bJNWV1Ml1X2gUOFjzkYDBsJiSiNmPWn00M8ME=;
	b=YECDvDdmsdSPy/4Q5cbaAZ6Vek8N2arLcGfX17AUJAq80KSIscf0gL6m7wbEqWD5vu7EZt
	OSjpcqX/5oW4QmaceACPGtNdj6FEUqb+HwgVK+3ggBHhQtxcuYBlHXGncpzVsOW9gWVHaM
	GtWIgtQsc/pGbJePPdzw58qL+kvRxtM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kxGpD9gy;
	spf=pass (imf14.hostedemail.com: domain of rgbi3307@gmail.com designates 209.85.215.193 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768540079; a=rsa-sha256;
	cv=none;
	b=mD6HgGdQK61mAKPVXmhE/9PuTFd+0xez0U9nU+P3/mQZx9YiNMCMhAu9wyHpZKEtkBEenk
	m+oAQRL2RXUxbimeZsWlin+y7xkun4nyADBjobA7pzbWmBF65JOZq+5lqp40sTqQ1VnJ/h
	YC48njQEylCcbnv3ng2k3fWjYO6Jm1Q=
Received: by mail-pg1-f193.google.com with SMTP id 41be03b00d2f7-c03e8ac1da3so626969a12.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 21:07:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768540078; x=1769144878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LE6O+8bJNWV1Ml1X2gUOFjzkYDBsJiSiNmPWn00M8ME=;
        b=kxGpD9gy25/DKGyUyXUqVdWgxDUt6F36F5aBtJ9HuRJffTSp8XQeERpGvd05hNGUA2
         ANXoYPUWl3QinbNVNJsARdWWYEr5/51qVbjIy+UC3W/tvCjzxZNbueHETP3CQyiPnahW
         tF+APElIiEDfBDGl83gR2kHcygxhw4RdF0yVbK9K49QpZXWBXEIwshVaQyaZNli6Y50n
         WBMZEsBYMx2cmquX+h/M4O/qeHTdBJHcTZ7kG4wRO5OUzpr8k5ukxYWqHKWOc91UHuDv
         pRQN17Hh5pSAwdwjLWtf+9H+xokTjVHh5fe1EsWI8RoAONIEmUyO+duEGTFWtCn/tNMN
         4dyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768540078; x=1769144878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LE6O+8bJNWV1Ml1X2gUOFjzkYDBsJiSiNmPWn00M8ME=;
        b=iUrgtFKpZ/kEngYA3lGKzOJBF6asHJDk6GNzvPfPquEHHiyYgCYRZQj54gefh/A0ut
         F1PX03d36nfcnDCG2U5dj4Ws7w9u+c36HKJb92uCN8nHrU7hy0//m2CSFGYzEuJO7oQt
         SE5Cr6FTjXWZrnOkoDVXYYA2p+RnZXhpNXy5LOSrgKmoFsZR4Y4fMQYWSVVX6PBx0NwN
         PzuV2/4q3WL8lainaxGnZhbBbgWLIT+GHEwwVsH6ogdy7l20DbAwdO1Wh/6LDvA2TZE5
         9NTyTVcEUurSSyIGYSU1hOmGV+XkatehHYo3nuh02dIKY/eZTuG7+7p7ner31b7MwkDY
         s4rw==
X-Forwarded-Encrypted: i=1; AJvYcCVRqL/qjwOSgpfbPJsXvMfj0JDLVOIKUT2b+hqQDAG/eLWW69wXEsDguhjkmgasTn7PhBXUi+llRA==@kvack.org
X-Gm-Message-State: AOJu0YxraFHayy37txyuWVxNnJD5xlT8QiaMEQkOwINgpjs8+weOy/PC
	5aMHSACiYp5/G3zZwGAtI/2iBn6S50w76fqN0RibvvqgIXumJVCwAiLI
X-Gm-Gg: AY/fxX762gfDnIyO0imZ5lgkSJREnnLVuFHhqLbrephN5bNmibk1VMZTrMdQVfl1amP
	qeDIt8KU/5RUXKB97R6gZpqyzQ3EaMKa8tvayv4X478yrUZ6PBjRlRxNd6xZebs5PYgn4DntHkm
	rRBE5TwbLg99VMcZBntU7ElhRmoknK10mLQvRGcUhYx7aV8BRDUUSF80jCooDq2Dni2qx1KyqvF
	zMCCoAA339jYvqyZo+6x/4Kv16DaO3Kl7Ih6iA1ZDVHgGnWu4SSzJvYYJzmcQALYNt+HLzbRIBh
	to6LTdviuauHCsidYO8xCtLYNkRcP2kwQ9rZVJKQ6EDnKM/dwhABtVCsRmSOuw0BDT5d+NwKiBH
	95onHUHgY3T68SOyoCK26ouR2VAub9RgFOkHvnMfdIugUF5mmYxe09U5i6MdTX9wYszv+Ip5WMI
	JpAGUlUn4z/J6g
X-Received: by 2002:a17:902:d488:b0:295:7b89:cb8f with SMTP id d9443c01a7336-2a717413b94mr15503975ad.0.1768540077749;
        Thu, 15 Jan 2026 21:07:57 -0800 (PST)
Received: from HP-Note-Host.. ([222.234.91.137])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm8544085ad.62.2026.01.15.21.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 21:07:57 -0800 (PST)
From: JaeJoon Jung <rgbi3307@gmail.com>
To: sj@kernel.org
Cc: JaeJoon Jung <rgbi3307@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rgbi3307@nate.com
Subject: [PATCH] mm/damon/core: reinitialize when passed_sample_intervals occurred overflow
Date: Fri, 16 Jan 2026 14:07:35 +0900
Message-ID: <20260116050737.21407-1-rgbi3307@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tjk4rgkscyx85dafrhbnhq5wrnd6417y
X-Rspam-User: 
X-Rspamd-Queue-Id: F14F8100003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768540078-853444
X-HE-Meta: U2FsdGVkX1/Hi0OLbh2sRUMK8V7YfthiGF3dOxs55GjWN+AvBEW+nL07ODEsl1MDoLiTdxseUB0CFmAyvF96JipoWqIZzIxIpyJFBRgB6KxgYcXVxQCA0aa7Fd5fDjLN/wcM/CRSumeQVOwmmk8YYrbSDC/r5dkXalgZFiiXK/121fmXnMRcvzm/V35psw8vMCew3wmBkT2oWZEbNie1ZeSnWFL473X3xLyrhogtvddovPasDxgmX6j6PwsQJb16AEFDSGrEb5E1i7V/A8bxt1rg3+1xju0foD1vhrB9tsyQJ1rRxuFpOc6haqFUF1+iAvip6c6XIoIOcFeicdvvevVgId5p8qfzvpoJriondc6WcRfS6oasD2zvq6G/ppTdvSRE99nw0iiuGLFthP0U4DwtMsslyCNXdNFQebtfFwlRz47zusnZe3dYANHOMS+RsQgDiPej/7UwXo5w6IAOg+PDBzsLrPdK+jpyjsgoGVCedHUKoPHL2Wyb1z9I66dQKBVrw9hzavrI3hZQauyNP6hUGk3TVOpaa7fwEaFej9pSOo+JJvK4YjLjN21EHyzXZF6wAceAzDDeigEeSfeSZw7OO0AQKbDratCLi8JF6y1zCcyq4Da1gvewZKnl7xm3Rl898LdLeBx+vIVSqLhawfKwu2yXkHHDs7SLBXLDjEoyFn+L6suUyLJjKYPr4JxfzAK2yFyAqGVIH7RL2VygEWhn8D8fM+MJolT5+tTX26cjzPa9xw9TPq07x7rH1meiHpve4VTXYgn/nyAGogc4JNNFWZkI3LwhMotLUnF9ock7WQl6Tpsh81l8FcMFnPikNYoY2HTLrp6u/h4JPMBcBkqHpSdFybF5Yp/p1bQ7cdd6pg5wOaHk1Vq/vzqWVb3WkNPxshIF0Fbn6Fk60g0Dtu2YRkXOz0CdRwGHo/+af4TAfZYDjlp3/y6SEKbFcBMcr27B23qOERaW4yFmAuv
 eMlIlRvn
 UQfm2zfpfsIXrerNknFDNtDPBj8IJYQanh5oypSrXGbOWRhi2VU+5bfPwQ2QlFHOxg7QmhooQGvysF9aL+Ul6ZYLp4w8ZyGR5IvtQd6uLPSp4642dmKKFkTgjxROnU95UXxinuadG6rbwpNDC9yuNgAfpA2knAbpWrY9XprlFfIixc+1b48aYJOG72lMqLjLTX65BuFCoZhUyUioh5TggoFbx4OD/V6gsRbH7lMVUPwFlacUnr0JcaEBpNKJRduyRnUIS05QA2PzsZKSkfQ+dw5LmkYak7K4co4GEYcTPkY/XE00b7ESjzmsdL+yRl6r+EVneXD1QdLJ9ejvYzhjV3sWg/uM7e/dt6GYTjvNHZ5zNxGo1SI7S1EwrTzCapoWHFJr13w44gnUnmSUw502u0I8x2G35RwM+yrFMZGF8lN+QQol6fpWjqDeKcNTBk1JIV9NaoiDuPkieD5AqLPFzfDfGzHNrTtQL5LWFnNzt01NNdqfMmtHBTWLdeKRNcCrEbMmai2Rj0BOOyxl3x99M6Is+0zWSv+FIaCCW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.421421, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To concisely explain the variables that calculate the time flow in
kdamond_fn(), we write them as follows:

unsigned long ctx->passed_sample_intervals: c.psi
unsigned long ctx->next_ops_update_sis: c.nui

Normal:
[-----------------+---------------+-------------------+----------]
                c.psi           c.nui
                  --------------->              next c.nui
                        if (c.psi >= c.nui) ---------->

Overflow(OF):
[-----------------+---------------+-------------------+----------]
                                c.psi               c.nui
                                  -------------------->
                                            if (c.psi >= c.nui) ---> OF
[-----+-----------
    next c.nui

Overflow(OF) occurred if (c.psi >= next c.nui):
Overflow may occur as shown above. In this case, re-run kdamond_init_ctx()
to reinitialize the relevant variables.

Signed-off-by: JaeJoon Jung <rgbi3307@gmail.com>
---
 mm/damon/core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..c4b2831cff89 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2740,6 +2740,11 @@ static int kdamond_fn(void *data)
 			if (ctx->ops.update)
 				ctx->ops.update(ctx);
 			sz_limit = damon_region_sz_limit(ctx);
+
+			/* reinitialize when overflow occurs */
+			if (ctx->passed_sample_intervals >=
+					ctx->next_ops_update_sis)
+				kdamond_init_ctx(ctx);
 		}
 	}
 done:
--
2.43.0


