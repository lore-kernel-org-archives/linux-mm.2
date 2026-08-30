Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2F4FC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECF546B0099; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30616B009B; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E7B6B009D; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B45096B0099
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:14:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45E611A0258
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:18 +0000 (UTC)
X-FDA: 85156769796.13.DEC0157
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 738DB140003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=GoCq0oU7;
	spf=pass (imf09.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.177 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4psP7AFDz+Kluf5IGgOzZSSfstXE1tXapxgbnPUwWEA=;
	b=Wt4MqtaTBGPblGU0780SQLpmM2c+D1YNv9tXmVYnyGTbJ/G7r6g3+tWHWwqoSgsGMjOQnq
	4EGM5FqR1USLqVCb/D544AqK8DuUQOGZ+OJQixDUH2vTPH7M1moTJsjaArJ0916GFbTrVi
	609vq0A8Bubt+xS4CQDDNB3Xof7m3xw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066856;
	b=2Avhe8Z0d43GVah/4Elwg1ReDlft1Ksv6Ljl/puF9l1NbtLajqd9alkBIY7/unYm+VFKxv
	N6vFGZda3WwZ0pNn/d0PHMqgMEotdNwO4Xfs222wBpFtk+WvPIhhHZML/MeizQcvJ1dSTZ
	vm1VMo9HSaqDvp23ww710fiMRriLPBw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=GoCq0oU7;
	spf=pass (imf09.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.177 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ceab75934dso26990985ad.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788066855; x=1788671655; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4psP7AFDz+Kluf5IGgOzZSSfstXE1tXapxgbnPUwWEA=;
        b=GoCq0oU7YHUgsU0i1Wh/9NZQU6AfbzZ/QzSS5skfCOUoZ2mEXRqQXkHT+DP4C+qIYE
         Kk/hoVJt2TivKma/p6ConTt4hAn8WwiXJmoZH6sPvJK9HKH+Ig7kxl8dtGfYI2mkb1mA
         nPmdgtohE9kVwoK0f5rXVjdI9eUdfZKLU/gMHn002aOM590WOsiZLtJ5NKjslVQPfEw/
         NPC1wLnUDIBYvJJejwAKjRk8znQ0bUyKCuVqNOJPa3W24IVfiK4J8daty/0jhNF7jsO6
         2Bdn1nqYRhl13S77QB06U8j+jBMzqnfegVHHgRB1qLH80/EcBRDEY7I/heVvYbzJ3C9Q
         cW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788066855; x=1788671655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4psP7AFDz+Kluf5IGgOzZSSfstXE1tXapxgbnPUwWEA=;
        b=Z7zbkWeCfqvLcNbTC/61g/Yf2lbTzVZGNPJ0iXitXrHU6441Kg9/FTE3yiBDDrbeX3
         0zJDF6sb4nV66E0ADnxVc2fLIyo+so9LiDSHQ2nYOPxL+LHa1ib0UBCfG8ey2tN6BO3M
         DL24dFeyVfagIkdBgYoxjPNCtkjljF3eN4LM4CPd17kFikWg+Bt/LvOBgoZLRYPxWPrU
         +lrKy9eupqhSvRnBhfBkmAvaaoCu2ho11nM8ZXn7X+4rrUlmRHrWoC6rzsOlrnTGjdkR
         2LU3JrJtBfbuYjVdyYEre4XWhMBdn1d7Ajnk7lx2Wbi3FD7GXKpbrRgBnF3FKVIwQFky
         pOyQ==
X-Forwarded-Encrypted: i=1; AKwUvBz0zHi/ltpBZg6DB1FMUzVLO7Ve/JnKI+bOP1ibKEsiM4IFFZt8COjaWNBuycEbk9jBnaBCezIxjg==@kvack.org
X-Gm-Message-State: AFuF++kwzmYoV+jjAJp/yhtOZhtIcq2km5zpGwTxWcn8Orl1U980jpLB
	VOUUFzs7XfWCCwm7mmXYs/Qd0XmvQWMIjH4WeMAnJbO0QpgR3+1eQzeU7MY7uVZ3KtU=
X-Gm-Gg: AYBFou3+efXTqDjRl2g++f3aFHsPQHDIam5yccL9UcAd3j8sq/zZxw8XtMHDAZq7zkm
	b/M7WkYCp+U/JQsWZeEiy/9VC6U8nAfD5xPdsstlFb1bzq4DcAPmiXmRsHoy43xHt1GOlhYQdez
	lMT2ZjxqZQL69nPFvpEqyM3k8n/cwgh9+IAUvMEkFUzcJiIj5hjgMAhWj0aoEqcKRiyZROLOGvH
	be91WBenbLSm4Lp2tvUI2F3v3QeOCBAIvJNAN87HOXLESfTuGTNGErKOiYJBfLdyKZxzKNemWPM
	zMqKJ4DiU6sb9WWYtFIXTEBxsAd+6X7XeRck5gWHsQgs4ciWFxZRfpy3iALYGNWnoxXHJcYPx93
	Is2oxKp+cVkhCK5YaJE1o2oBpOTzJH1vu30D7qO2xWO82XWishw+87nsR7/7a0h32Pjbja1ChD/
	bQVthOvew3g/ENPU1fNoCs/StBw+0Bn0XXl//3kdnemgl5DmzUK/yERUf0UZLG2ZOXksqHe7FOk
	GLynKJcN8B2o4sgv3dNHivQE/Z+hYLipeDu
X-Received: by 2002:a17:90b:2e4f:b0:398:9bd5:490e with SMTP id 98e67ed59e1d1-3989bd54c43mr16185087a91.21.1788066855436;
        Sat, 29 Aug 2026 22:14:15 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:d101:1d:112c:715e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm22595810eec.29.2026.08.29.22.14.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 22:14:15 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krishna Iyer <kiyer@crusoe.ai>
Subject: [PATCH 6/6] mm/damon/stat: support aging_flush
Date: Sat, 29 Aug 2026 22:14:07 -0700
Message-ID: <20260830051407.50008-7-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830051407.50008-1-kiyer@crusoe.ai>
References: <20260830051407.50008-1-kiyer@crusoe.ai>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 738DB140003
X-Stat-Signature: gb4np54s3auuedz5q4ea4bxswb87zg8b
X-HE-Tag: 1788066856-175474
X-HE-Meta: U2FsdGVkX1/R1RJO7LRe18IuocceN53YeEPhL4hpSX/sNDPqucqWXqX2xSSgZlNUwEOOln+SEbYscMD70gnKuoK0Sr6qFSoLWxAR0CRrav46zYXLV48x0KAj3JZB4zHunfhxaoD+FPPGAG/a4V4nct4TAIJsER1VZ6db8nMs3rR97Oy4vQYlogsDMnm/768dd1hNtnjpF15/s/+6ODsamAf+V4dFMynC2IiAzqb40rHIDPAB7sA9OSDSY/xwqcpY1/q2Ksk+h+nMv0GH//n5MnnO3UQQ8XWvfODuzhq3pCwXf0Q72vP7G9b5SBgf8pEZZGsdeLBz7lSnblO4Sc0aD4Max7THQbF1EqYs9h7GG1PNg3jOnblNkUOFK31BnHzXp+DoVAgqsguzji3u3I6qRuX1E4Ml+LwXujlvvAhO0S5k+rLvbZ40enGcLG9TO68M/zDH4s6ewzqCi0OZcp/6i6ywnm0fKc+N3h0bdOBdj2CVSL/klM5Cj7ufqkczwtdTuEh2VtvDlizhksclIHn4NHeAXXibv59gYAbdgdDnoNEY9eyymuv7TtC+5anRypaTTQ2fvs9K3dKK/Q+kgTjDwkNfFlTDSbIMA6qLSALv7R2YsRd9cOZ8HntRHQ585b6/fhTVWqYBbKDHg71LQUtFXAwNVoZbT8oavK0I35PcnjcKeu/++skq9G2DBuYTmCJK0YoIOEPoSLoxB885AVRG9RcMx9Cm0g/NALfN2iqKG5XXvvTn+y8af45A0wcYVrtW3uXSZKUUNmWPAVwkLIuEo3Ovj2rRZsyz7zBGCtXAOHa8HPcqmOmlM4yMo6sWIAe3OFxrH5e2iDKPpmlssk1lUGyc3iQGRf2Ll0Nv57WiXd1N5BaDOIHcfpzqNuo9B9O2LQYEZdrwzHwUcBPxpK+v6i5PtpKlWdi/Lv5ZE5qIxbRT3ZAw+cuKJ9Sd7jJNBQzq98Qm5GhCWkQSlviFQ99
 3NX8up+A
 M6V2rRDVmBMw4OScDB3xlGT589se3/xlEb/YwFCBHge3MpN5YmHlr/bjYRhxQPFEb9MGkQzpErb4tRl0aYZJrbE3cZ7F2tkrMFeDoxNBpWc7ftJ/+1JaPFjY4Vj+4s6tfB/iBkV0OfVpKG0IEKSlQ8QwAhhbCLWvm9OJdFUJATdOWkHXl8rPvE70BkjG9fAT3NyshX4CBliMrtUvwpDj8RNKHPLnqLXzfJRHyOSIGRgrF+N9KnkvNmWWdd1aH2v1dFW0YP68K/X5SzEeU0uvbxz3n0aKDya0zD/0Ng2n5povSJZ3dVJJnoNa4EtzPjOvDiwJ3TsqORzPk0p+z9mG/H2yDprYAjuZhmav/MyYCeLTGcOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let DAMON_STAT users opt in to flush-assisted access bit clearing via a
module parameter of the same name as the monitoring context option.
The parameter is applied when the monitoring context is built, i.e., at
enable time.  Defaults to off (current behavior).

Intended for virtualization hosts backing guest memory with hugetlb
pages, where non-flushing aging pins the observed access rate to the
TLB-refill rate (see the aging_flush core patch for details).  Such
deployments can set damon_stat.aging_flush=1 on the kernel command
line.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Krishna Iyer <kiyer@crusoe.ai>
---
 mm/damon/stat.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index b05b68f73e10..e093383ba406 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -47,6 +47,11 @@ module_param(aggr_interval_us, ulong, 0400);
 MODULE_PARM_DESC(aggr_interval_us,
 		"Current tuned aggregation interval in microseconds");
 
+static bool aging_flush __read_mostly;
+module_param(aging_flush, bool, 0600);
+MODULE_PARM_DESC(aging_flush,
+		"Flush TLBs when clearing access bits (applied at enable time)");
+
 static struct damon_ctx *damon_stat_context;
 
 static unsigned long damon_stat_last_refresh_jiffies;
@@ -178,6 +183,7 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 
 	if (damon_select_ops(ctx, DAMON_OPS_PADDR))
 		goto free_out;
+	ctx->aging_flush = aging_flush;
 
 	target = damon_new_target();
 	if (!target)
-- 
2.54.0


