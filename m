Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A501099B52
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 00:26:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 045106B008A; Fri, 20 Mar 2026 20:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D386B0093; Fri, 20 Mar 2026 20:26:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4DC76B00CB; Fri, 20 Mar 2026 20:26:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D40946B008A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 20:26:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6332A1DE49
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:26:52 +0000 (UTC)
X-FDA: 84568179864.02.71227E3
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8FDBC18000D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 00:26:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ht9U14k3;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774052810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JKlHM69nSPICw8Bck17U5ux4/b96tqy8A5ZALWfO5aI=;
	b=TuWB2h2rdtO4L1rRRnrEQ1HwamYq1V8TJAsFq6fm9bN7gi2kr0MzDc9KDhkWwVRkijyIjy
	XIHZmwZGc7B8W8jRGixujcyQ1isyOMk/Pu2jmP+eOiDpePUbVyCnQffEUdpG+a03doxb/4
	Hlf9UyRuOCPiBPW+je6s5D5zSQH+R+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774052810; a=rsa-sha256;
	cv=none;
	b=Gwm5vXuRxQ1Umcd5gb/tx6xYD9MsXNX5a1kPRcX9r4cmds8G+fV/y2EtDZsf3oUHVBFGJp
	ReZB5RVfRPXpYg2t3AGKdZSi0KMWQkPnI4o1JnbongMVWoRbl0zVlcE9DdoENUv4ps3TN+
	/BjfYJC/kNrailoIIRtizevGrD6hwJE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ht9U14k3;
	spf=pass (imf06.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-354bc7c2c46so1185887a91.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774052809; x=1774657609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JKlHM69nSPICw8Bck17U5ux4/b96tqy8A5ZALWfO5aI=;
        b=ht9U14k36U1729Y97FcN5N0Q0VdVINCmC+F11I0jx3Kb+rP2tiTJvIJ2xDGlsEYyEX
         ++jiGg1pQ5nrfji6rAVrzukOoNmcFczld7+iJhIfJUH1iwZyVmxGzlOtjpg20bpspOaY
         /e4P6mDVtotlscHMehL1TSZfIthhSp/+4whtObgxBvcESWgHIHoPwwDCHW03IU/pdVof
         FRlHIsOVAdXeT4UHW+5YVfUayzsgcqTy5mVqDjfYto869uz4Kpdh3K1YXfUaB3UcDxLu
         us42yLakz0b3tZHbUWIP0EuB2axHUN+/tchLiBq5b3MAlRkE+lg7Ytsjev1ivy2Z9lbx
         N8cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774052809; x=1774657609;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JKlHM69nSPICw8Bck17U5ux4/b96tqy8A5ZALWfO5aI=;
        b=a440Roa5P5pnbA/HYT2eLie8DR2UQ+0LD56jHvKT8/2gx1GvD/Br+pWdafVbMGXEBF
         peR2yeLSdbCmTAVy3Q5apMqnU7W0PA0xIQ6+JNoQbveH7Pl4DAmeo1FLIruHeI4Q+eyc
         BB+xvisTN4qE9lqPkxL6wI+SCsNL9BlxW16S32qEvdvtpMhje5ocPSvVBzLtmrMnI+V3
         SDETHzRSsqqJ2hyMBgMPvFICFvV7SmY9BrPvMDwdpa25jl0Ev40Zgt/eH6DqEB3xGVZp
         riwv4nddr7d4rZD8sl5Cq12M3NptYiC35iovb/GRHWWWoAVYUJ2X9stvY6Zxv6ihldR8
         MfZw==
X-Forwarded-Encrypted: i=1; AJvYcCXYolLJhgRv2jLRwK/C0jwV5OiFcdR4RasczpCJN2SOTc5xR71QEYuyau46NJJBu9QnE95ZEJK1Gg==@kvack.org
X-Gm-Message-State: AOJu0YxOwd+WxwP6TBbJO8R6eiZvf243mfPwGmkc1hty7YENNYvgMqsq
	vdLy8BYNgSwTbQPcMyrGzrUZ/LkDGQY0zIyQ4jSNZ320Nb9tOGpPdG3P
X-Gm-Gg: ATEYQzwj3oTX2gzBmKlQnfgmTPO4EzyNovplyYJQ4jw6ehNM0QJ1cOiUZYHhNKRBN13
	4EpS3dmY4XHrb0FRHiH1EZIior4agtic6RYedv0n8QyVNcfkSZIFcQOmYCWNKT5Q0CiuiY+Besh
	iZyR40an+YAfyTpIjKcRcuj28lj5ACJwlh6+b6GZcSxZD8B6ULxsHJkH557PhnEHUvEdYNxySML
	FFW7RFujyZVBFzfLDpQzc/sCjlPWMNKpRb2qeTmoKJEl9cDH3c7DI1seuOn9B5DKKBq+2cCLX2P
	HTvjx1znkg4FuA6p9AJ0KleYiOVE7POaHwafPed3W6v873yTkB1JkM3K6ILrn8crHHjVCscjfL9
	1FdmU4uw5qtiWmk05rz7T9dUH/4yOXMECO1EvRJdHQee/MvQjl+LthfZcBa21GpawWL4kkVOm1D
	x7CLK/ER5aSrvLFWijkg2Di5+6+YANNigUznUlev8qk0Z21RHPpds=
X-Received: by 2002:a17:90b:4cc9:b0:35a:329:73c6 with SMTP id 98e67ed59e1d1-35bd2b97774mr3776534a91.3.1774052809268;
        Fri, 20 Mar 2026 17:26:49 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35bd358b299sm1463708a91.5.2026.03.20.17.26.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 17:26:48 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [RFC PATCH] mm/damon/lru_sort: add synchronous validation for commit_inputs
Date: Sat, 21 Mar 2026 08:26:42 +0800
Message-ID: <20260321002642.22712-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 15c3hge5jsqtu9ctyu3u9xtiingfojii
X-Rspam-User: 
X-Rspamd-Queue-Id: 8FDBC18000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1774052810-207736
X-HE-Meta: U2FsdGVkX1/EtEyPRhcTD0csPWflxRhmuN0+v4nBHrqnBJ8tfhNkaoH7oYIcKoCxvbT3uPK4G5+oR8zzM3Up5QsyBX8GxrJCDF0aJ+mt8VA+jNIOH1gyMLIcAOJERFTknODOOVEYJv1yVPxFkZNEgbC3dFzznNc2C48URoEny6/pqjZc9W8zHNp2NGbW5CRp0egJtyl1konIPWQ7WkwaWL42CL8beEClFb5oiEpBlbZHH/TlGwLWLrvih42Sdh1IxCtRTiNGjpFIsn4G9hATmm2DvHZ2zaGqeunKKCafL0xqiWTKZpKZvdrRo0YbWOmY8zbOXyP2uekQwOmkLhBAduSNDeABWRBuF9IJuOy2lA9HYGYCqfAqpnr6HlAsFMkGXs3z9wi3yLe/ZvXdyp6D4ou+gQasUSNmCGKz1/Tx9KV2SNuZk4lSVEjpTa2+SPz8mAivj0KehVSU+IEoDRwpd9In7UTImTauvZitxGmz6v7Kg7hoAFA5KArNVWgKyZl5BG395b/uVe1G6Rv1hZRS4Bxb05JDTgvQVNX18Zh9KJ4iSfARS0UPP3bqpUf3wK4FeQSfAPWGl+umR1rCrsgOfn1H83gFmnYL1kpSGoehZ4y4KY5qU9OxW/zl2N4HdQygKPZD52AeaeCmnj44JaLREdCYbqFwMsIhFPhBNpqIjdXhVjzpysc4ytxVe6LHUauUHBTfspvC6PWZMvHZEJH4LB4L8RGhdRWbnZq/0TiXPK4cqpNmYa1Dpfb2d+wlusFn5dz35sK6vsuUQY2WR4pIC2L+fdEZJTI06fE2NS8vaMrldDck9fFKwwQH1AkVVbGhV++Oiwg9ck0DO2XMDNvF+oYBK61oBuMwb89QUB3PLkXkGSffiCH5fe62mrjiGQrjI2t78pdHkvToosx2EG+JqwtzF/oLlNyTX0GV2HVly33yXMC+DzS+r/u4KDmfdGNEAPwJ2t+VzJjokoIjCyv
 Fno5fpq6
 nSfjRDh/tgP6ITHvPmFJyPWIp/1EnJIPkimP86suXnOpjRoHT8rmOBwqBE56W/vYp//QyO2TLXudxgtQhbb2S7xeTKFrHLUn4prsTvN4WD/r+ANRnthTSqtbEkNeRNVCx1VX5zcI+ICbhRyjN9/0vZ3d//e83E0yLO7HF5eIbgjhJ1bzoG0OGej+p65DGsB3acgxPzfGR6Sq48ZFjdpLq2Q2FxANe7r87rHByYGKt8HL4gPpw+FCnEgi9WbG1qZpVS6SePR1ta3LTOf+F+K4MhXiyqhzeT0nlE8Es2p1vITm7QMthCaaNK0ALZ/zZo1V8cc76iDhY88ttMmbBdWPWfMqRQPjpK56VCjtiUJOkdff3RVTA7eS7CbCC6zUCF5ZWxU/CkXOmGSx7w8af1jEaj1mx1JLtRFAkZb1aKT1WQcen1y2wnd4ev5Sn+qLBoMVyKS78aKHPJlbQ8/1D1IkvqLhHYeqrSD6sqTdGfuZt2ZD5A2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

I would like to ask some question about the fourth task in discussion [1].

Please let me state first that the following changes will also apply to
the DAMON_RECLAIM module.

Problem
=======
Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
silently (no error returned to shell), because the validation happens
aynchronously in the kdamond.

Solution
========
To fix this, I proposed adding synchronous validation in
damon_lru_sort_commit_inputs_store() before setting the 'commit_inputs'
flag. This allow users to receive immediate feedback (e.g., -EINVAL) if
the parameters are invalid.

Changes
=======
1. Added damon_lru_sort_commit_inputs_store() to handle parameter
   validation before setting 'commit_inputs'.
2. Added damon_valid_attrs() to centralize validation logic.
3. Extracted validation checks from damon_lru_sort_apply_parameters()
   (currently copied from core.c).

Questions
=========
- Design:
  Is this synchronous validation approach acceptable? Or do you prefer
  keeping it purely asynchronous?

- Code Structure:
  I noticed damon_valid_intervals_goal() and similar validation logic
  exist in core.c but are static. To avoid duplication, should I:
  a) Export a generic validation function in damon.h or internal.h?
  b) Keep the copy in lru_sort.c?

- Concurrency:
  Are there any race conditions I should be aware of when reading
  'damon_lru_sort_mon_attrs' in the store function? Should I use
  READ_ONCE() or add explicit locking?

Thanks for your time reviewing this! :>

Best regards,
Rui Yan

[1] https://lore.kernel.org/20260319151528.86490-1-sj@kernel.org

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
---
 mm/damon/lru_sort.c | 64 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 63 insertions(+), 1 deletion(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..0e5f9d29e294 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -361,6 +360,69 @@ static int damon_lru_sort_handle_commit_inputs(void)
 	return err;
 }
 
+/* Source: mm/damon/core.c */
+static bool damon_valid_intervals_goal(struct damon_attrs *attrs)
+{
+	struct damon_intervals_goal *goal = &attrs->intervals_goal;
+
+	/* tuning is disabled */
+	if (!goal->aggrs)
+		return true;
+	if (goal->min_sample_us > goal->max_sample_us)
+		return false;
+	if (attrs->sample_interval < goal->min_sample_us ||
+			goal->max_sample_us < attrs->sample_interval)
+		return false;
+	return true;
+}
+
+static int damon_valid_attrs(struct damon_attrs *attrs)
+{
+	if (!damon_valid_intervals_goal(attrs))
+		return -EINVAL;
+	if (attrs->min_nr_regions < 3)
+		return -EINVAL;
+	if (attrs->min_nr_regions > attrs->max_nr_regions)
+		return -EINVAL;
+	if (attrs->sample_interval > attrs->aggr_interval)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+		const struct kernel_param *kp)
+{
+	struct damon_attrs attrs;
+	bool yes;
+	int err;
+
+	err = kstrtobool(val, &yes);
+	if (err)
+		return err;
+
+	if (commit_inputs == yes)
+		return 0;
+
+	if (!yes)
+		return 0;
+
+	attrs = damon_lru_sort_mon_attrs;
+	err = damon_valid_attrs(&attrs);
+	if (err)
+		return err;
+
+	commit_inputs = yes;
+	return err;
+}
+
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
-- 
2.53.0


