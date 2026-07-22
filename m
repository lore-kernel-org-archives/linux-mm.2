Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3651C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 11:33:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7DC6B008C; Wed, 22 Jul 2026 07:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651AE6B0092; Wed, 22 Jul 2026 07:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5400C6B0093; Wed, 22 Jul 2026 07:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CD566B008C
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:33:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD9F0A0161
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:33:57 +0000 (UTC)
X-FDA: 85016203314.07.42A5C14
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id EC3AFA0003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:33:55 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RN+HSI6O;
	spf=pass (imf15.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=hank20010209@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784720035;
	b=qtYJ+XFV/bXyxzdN7bMq1DdeEhQzKvZ80lu6rJeohETtoJml8ZbPmv7qeq2bpN2P610KtO
	wIXAEXiYriZYVIGGI6UmLHVJCfgly1NBPh/NQQJq247ggj8Sg2R5h2vG0+hMauSk9iQdB5
	PPQLnkdK1DKjI3JW0UxvtCFSDY0xUTE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RN+HSI6O;
	spf=pass (imf15.hostedemail.com: domain of hank20010209@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=hank20010209@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784720035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUhTDedR70ZXXTiOjTiOLU7QAjd8TnaNf50qKPQfc+o=;
	b=4p7fLJ+fVjhzlbfSvloUTdpVbWUYj1BoZrWVw1rOa6z5cHsarRwrc1r0l8HTgcGfwqEnpf
	fa5Yxw/c9dIPsD1Jhi8bfaTS2DEqcRhOgJv03fNH/Tq73osRrTS6/zZoRe6j9E5uOy7L5s
	l8FabOCsQtGBK7PzwjUZPM4w9rEump0=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8423f236418so6937802b3a.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784720035; x=1785324835; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LUhTDedR70ZXXTiOjTiOLU7QAjd8TnaNf50qKPQfc+o=;
        b=RN+HSI6OLrVs4bWmqVcWUnIaRi3CpwCC0+n/LAZK2Q+GHL1MyWuuY+u13samr7WUXy
         3g71DVGruoJC8VPNGlajYPwjh7ONn7ehY3Wu+5V9XZs7LMH1qh7TH4xahGnKoeCQMHLY
         gMnfDIFYpqsXV5nDntl6JlFGLrP0uGUk7ztQjkYLMba0UmxtVdAg6n6ESIXGlGDaq+yY
         woKPL/1h9M5vckgKml2qYDusN/yMl+PyISlCxjMy6DHvngc8rAcXja6E8b/L7IB01jrU
         FJow4EoQ+L1Wcolh3yZRgeALJFSia8j9a58s90tnEDKUzdJONVRNh026Xx+isqcQ6ycd
         8Mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784720035; x=1785324835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LUhTDedR70ZXXTiOjTiOLU7QAjd8TnaNf50qKPQfc+o=;
        b=bSWEN7qzy6DNrinH4jZ4aA4o//k+hvq1HmDak+y0Dysz7qMDwmeVIXa8iBPDUv3OOo
         VYCOreph3wsQrdlhgCPqFQzINBdcLGUX3VGGN+S6NHWbJ4OGwjMfvJGqplqcDCE6fHIx
         8Vcde+ngCw/cOD2JHN2ByPYBzQTRmr5s+Kz/iA7B7UwOhhuORndCzNeY41fp2H+9XzR6
         qHtOacx1inK6xAW9oRvvDApDdJrE6GfgmUFx6QnEySXiWxf1Uh/mjFG3W0yub4P78c7R
         8JGt4zgc5lcVW6xaNUHh01lVxtXr2yqyOJ7+w+YsB2binY/jDj1WkF63gNc6dBYYgSAO
         rPyg==
X-Forwarded-Encrypted: i=1; AHgh+RqCqb/+C5l7ojQ7YoLOaLFFn/0pa93t+bzX9jS9Nktpmjm0sgU3w82cKOXnSvG/t+M7vkGDIzUnEQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4+WciLy8/YSYdVPvtPksqv4ZGmtj+U6yAAzZn3wQOS5wJvKlC
	kE2WhRNf/snF+Z2+0MqoJresjI5tEG5q7FLJhToN/h0vgLAhNd/pWP+M/lKdhm9N
X-Gm-Gg: AR+sD13L7s/q/YptO9ICtdFzckRM3yy0fxjr9VYlNp0LVFlynBe4y+jkOctNfpjP05w
	kYGR5v8hesQEWsbvOYT4qv0itAPThKztz6KdAEIly6KX0pF5TtVRcY00ZZiborqyQHA2xZmC/pf
	UawZhVMzWVi6+ZjwuL7uAg0Kr+mjLSNLHmLkFvxNSruYSFVOb+F6lE4o4pl9QjXcqDqDcOAZ92W
	11UICnoXBRWqttHJpr1DWQKd30gwfk1z8NOeMFWb8mzofWzTpViXTXJ1vfXkv64I7tulzOaVvQ9
	yTM1Pylbcemyov3yyIrSnkB7j12TRbyetpcPPm+sLBtl08tFdzvF5CdNNX0BjVr1p2Fzq6Sj5Eb
	skZJImsncG6+mscz8bk1XJtIHEDTj7bfDBnhxz3EGQWtcxGL8khuSFY5kD/wPr8wtfNZlO6Nnon
	iEE/AzlODJijVkeFEMGw==
X-Received: by 2002:a05:6a00:986:b0:848:7071:9863 with SMTP id d2e1a72fcca58-84c29532099mr22204146b3a.53.1784720034864;
        Wed, 22 Jul 2026 04:33:54 -0700 (PDT)
Received: from apt.tailc82bd0.ts.net ([140.123.97.23])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbb8f1c376esm980979a12.29.2026.07.22.04.33.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 04:33:54 -0700 (PDT)
From: Cheng-Han Wu <hank20010209@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-kernel-mentees@lists.linux.dev,
	Cheng-Han Wu <hank20010209@gmail.com>
Subject: [PATCH 1/2] mm/damon/core: remove unused damon_targets_empty()
Date: Wed, 22 Jul 2026 19:33:37 +0800
Message-ID: <20260722113338.302603-2-hank20010209@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722113338.302603-1-hank20010209@gmail.com>
References: <20260722113338.302603-1-hank20010209@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iik5mii1hzfghi16xxq9fk5h9xxijozy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC3AFA0003
X-Rspam-User: 
X-HE-Tag: 1784720035-910808
X-HE-Meta: U2FsdGVkX18umcaFc/as8ldImn8ssETtAtODAS4XYucpMUznxJEFYmAZNseeJ0W+3jjywl3rUId+JSBz8/In4AgqI1dRW1rcpB7I9FBG8wbmJhAYnuseKVaVtzPbg3pC7Cuu50rNRRdCTVEB5o3O8zPIZjHnifpCMgUHI9D02xVj8qRA9MeOJYwkR8xUBJBFq48X9Di1x1aUahTAJtA7co9CzqdGPkVf/ziW/3Q8jdopxZJZuYtmrmMqvtC33tM3qGy/IKlqd5HNmNo3DeCUG+heCu/EqGuxzTb0o0Hwekd5oM2f9vclFNqpCER1rNBML++eXwhbBFtHxJk7rZ9Iwzy45hqrg3szZQL1gjdoWMaGfqFnDRA4Q2IeY8J7h43oxtwZP3UBL0Nixc8VmSdc7yW/cB4Tc3TaCbBcenIU+BLx625YPrshYaenAQoLdofWI+/4AoosGUIzFbEnP6vi/n74tRIL2H1DfRmtuxDcc3hoaj7opXhnJ6DqQJBz08c+SbCI7JGBF05Yj6G6rm3XzxGoZvVFOTWCvAt1+nZFmeSthkWQAK7eB+T9U8gBZKoZr2zi3w3AMDAT3jBYrgFnKmR4YqEIGir7rq8PJoc2bkBIN2MQ9KL1wfilDOY8GzWLFAqF4yw+580ANhQFw6E2YAZzzr29y9t2yAvmuV108xkEVssOPsWa6oNzMUTXBiBsVWnATaYm5Ifke0jqm/S2kDWIvXUYDZpUjrPg+VBjOSM+CMVh0vh9AzXyDSbF+c2mE4pyPbJG9VTz2zq7yZbFGAsP3PPRWWIzercucNxQLsifmxZQJx1nIEaP6qCH2PrzqmNvmtQeEcfxqOLTg5O7DLc3+UXksAjg5qClOcGr/+iqomIg/OLLT8edwZ7wnv9T1tuGix/ip7sxqb7WNLEt+tOa6jzkNGbB8Af0KWXK95d1DvjrGkXna9mMkSpXJkX2Xit3dtaHcC3vvFQ7HU+
 27ZBpq0I
 ETnk7O3p1Y8CfXKsNDy6fNsUyW/JQtIGSZ37US6dDdhyFTaPwUsh3eTTFSuo+B/HdP70TPauA9qXfmbFx5eSsqo0h5s85mzxL6ji6YUwXzK5kxDVWyDHtpLdL072wAa5jdH9/B8PD7nQ4+Z0Ysf1B3J8J8tMZObo/g6rl1cDR9/FbH6eh1JieSFuO46eILlPmY0cWnOgVoGDKcHHtVouKaBMDkDzx9QNwhdrxRkzTKq2Lo5R8E0zEqdQM+M1gCMnpZa+AVDdvIFfcDb5xNyrq37S+XUqLaKLpDEvsb00wSSRFbBAbIsF3oVvQAYHQOYNqaNtcvbtTCz7Px2DJ1DUNwjhZgxTTRcsRjHBShq5HumWvlxezBSR/bEuwWbxJi86KTt3cdCWWKewqY2BaEwnZnvb7HPke6ou323iTbpseVm7917HZqT22EXhBDT3D9taXDQ2vsw9tuY9TXMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_targets_empty() has had no in-tree users since commit
5ec4333b1967 ("mm/damon: remove DAMON debugfs interface") removed
its last caller.

Remove the unused declaration and definition.

Signed-off-by: Cheng-Han Wu <hank20010209@gmail.com>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 0c8b7ddef9ab..8e5589ccf50f 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1054,7 +1054,6 @@ int damos_commit_quota_goals(struct damos_quota *dst, struct damos_quota *src);
 
 struct damon_target *damon_new_target(void);
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t);
-bool damon_targets_empty(struct damon_ctx *ctx);
 void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a1656..da97b2dc39d1 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -795,11 +795,6 @@ void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
 
-bool damon_targets_empty(struct damon_ctx *ctx)
-{
-	return list_empty(&ctx->adaptive_targets);
-}
-
 static void damon_del_target(struct damon_target *t)
 {
 	list_del(&t->list);
-- 
2.52.0


