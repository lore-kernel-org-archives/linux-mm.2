Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A602FC87FD3
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 11:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386106B008A; Sat,  2 Aug 2025 07:53:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311EE6B008C; Sat,  2 Aug 2025 07:53:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162626B0092; Sat,  2 Aug 2025 07:53:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082AD6B008A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:53:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A50D11DADED
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 11:53:06 +0000 (UTC)
X-FDA: 83731656372.21.A23297E
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id C2D2012000A
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 11:53:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VUiSF4WA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754135584; a=rsa-sha256;
	cv=none;
	b=QNjHfbHGlmXPe74PSKUb415bAZizIru6Iz8i1L2dGoChTawqdqoR3F6LyYwJkr8U+bD/8U
	syq7xShQKQwB+G9KkxaAsmNx58O+I6Cn99ZXlVxAPL2Mz9fOyzpiN5kLnS0aYba6Bi9qIn
	skTIgvFHSD0/YxUxRGU0v7+M5mmI6eM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VUiSF4WA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754135584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1uRbOaPx516qagC6F0FtjjMT3s1w0dSsaUvr5gAnQo=;
	b=HqB7ncB+D+EckZEgEdaEk+b/DzsY2HPh/MT6fn9VGA6SUcMjERwaaMjWwm+7ndcBxioYrc
	Jist4TcvsIsXCkjwlA5iSekUiGMDuKjWWICiPbxK5erXByv7NJAmLMeK4qGJEsYl6EhY1S
	Bcb5k09okd/toS0uBastp9WFhO8cWRg=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ae35f36da9dso532302866b.0
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 04:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754135583; x=1754740383; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P1uRbOaPx516qagC6F0FtjjMT3s1w0dSsaUvr5gAnQo=;
        b=VUiSF4WADT7JgbwUR9vp6NsbexwquHm0lE5K9UYbtRSnGv0iLwBIipjQfSQL3QH3vj
         sgBHobzT7Bj01tdwgL1bmb8UhRRYzGK6DsDxgn5KBxvoK+gpon9xMx3tS9EWgykKIXVO
         bJzo+Ulg1IUV+zvWwdi0WgoJGQs77f5oXN0bfH1uT1ygx2rphNdQs25r1k5yD1VDOKn7
         navbaN7jrQ/NL5w90RnSwL+qaj9yKNrGQL0yculo5gsqoLHi0ERVL54l5b75+n+56aUW
         yAVge6RwrRbSn+hKvcLb3lHrlOp0QtSoSNSHgOS5T+4hXXaudbv/0NyvjCrsJuaUCdMI
         enMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754135583; x=1754740383;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P1uRbOaPx516qagC6F0FtjjMT3s1w0dSsaUvr5gAnQo=;
        b=cLorBC3BAiJzYuK7n07whiOtQmvH3tHt8H0jKC9A1gdjburDSu07BtY28mZ52Lr5Db
         7TiddwXk4Na7Asr4Mf+uNIHTZqvxgIbAykEqE28YxcOjshdtOMiNtr66sKSXSrBK9eqI
         P+uZNyGlSMwfA6wALGI/X7rKMeH3lrwVy0HK0/S+0C8g8gApy+0UXeky3bSfkAHD36nb
         j2N6JwnVFtfXyhz/aYE9e9sVrZpH6Nh6dgn37aO2n+VPIcQSqb5RvmjVojgR18fgGQhv
         Kbu7JRlE34JaIJq/tNhcd6CeSIAmuth3OlJ9bpIcOZ/hqByds2Q4/aXtIL1P0lUtpxQ3
         jtzA==
X-Forwarded-Encrypted: i=1; AJvYcCVy25NW9ykF3KrZZfKdu3Tpq6IqD/3NP9q5g9YnWoojSAu/feTZ9chF5XBZZjM8sUx2psFbnwzPBw==@kvack.org
X-Gm-Message-State: AOJu0Yz0oTKY4tl0sAnUCTZMESSe0yEiP+zZ2b5eXFclqF7E6etdA7cp
	6GGpamPIMf3X8Xw1ReGlH5B6X41jGzpMNapIsIIreEVlIkWBrsIZtt1t
X-Gm-Gg: ASbGnctnHpT3TYWYnM9uCtqg8TFv7VJn6Kavqc7+1BB7DCMLLIULCgwHkuyK+0kxfNv
	0jOV0hCDmqv+vokIrf6PjHttJHurkNzq7yjqiiX1a48I/v754UzJX5yHuX5HZpEmmp0JMiVLgUX
	bHJ5TgGCjf7btytu3PdiUuyNz30ebWyhGqYA0NzrSXWcgrpSbI0WDfn13R/8zKTpIOu8+IF0MPq
	jFXTQGBLgMD+z+763P/BGZYXcsS5KMPcVJgDU+OZdEDj6QVk51q5ePUXVPi6fN8RR8XurxgMBOv
	nKeLa8aEMTCS+mumvy4rDA+jejNneqToikRmJ8AbdqnHWpXAmqv2gwbf3mjL4GhZBkuqDDVK02D
	Sbi3Fv+rjh+ceh9YvvJgYETkULOeoFNHMvHDg8FJ5xcKL3uhRVJdUfKzIoX+T5tB+k5vsYCA6Zk
	Mekkkv+g==
X-Google-Smtp-Source: AGHT+IEeolrbK8Ju/4UkPkf+Jnhr2B2vqnQWZUQZZTD5vJyKAaB8n/76N2YQeS6F2uTGQIcJUUPDEg==
X-Received: by 2002:a17:907:86ac:b0:ae0:ac28:ec21 with SMTP id a640c23a62f3a-af94001468bmr267338866b.13.1754135582908;
        Sat, 02 Aug 2025 04:53:02 -0700 (PDT)
Received: from rs3labsrv8.iccluster.epfl.ch (nat-icclus-192-26-29-9.epfl.ch. [192.26.29.9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0753f9sm425028166b.20.2025.08.02.04.53.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 04:53:02 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Yueyang Pan <pyyjason@gmail.com>
Subject: [PATCH v4 1/2] mm/damon/paddr: move filters existence check function to ops-common
Date: Sat,  2 Aug 2025 11:52:45 +0000
Message-ID: <cbe01740f7ac5ac7c9fd1ca367d297c3d7f2a69d.1754135312.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754135312.git.pyyjason@gmail.com>
References: <cover.1754135312.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C2D2012000A
X-Stat-Signature: 94xtsjrh3cfst91cyckhooodof3nf54c
X-Rspam-User: 
X-HE-Tag: 1754135584-29651
X-HE-Meta: U2FsdGVkX1/I83n1w9QQ5B0yrwaNpPDlnBK/1Cmx9cVOdoDiYh/7xhwB6GkQ7rzYEEWd9HMX5Ldg35qK65WL873bwQYIC5c4o0mftYRtWpOmEt6PGH0+4ubk2CJYt2hGBAIVrNkQlj86Saei1aydzQsLk1m+YtYg1OYJeWNn+6LbMhlQYlLAtmqpanZlTvWfwLt8/P0IY4jCClHu1F4F841en3L6Ae0G9uPdl1sXiVIGhYrRA2odrQYHdiNOf+qoAz1PUF5Hhwkys67A15nx7lq1eF4amBqb7z3/myo4AaVrRhJrU1IJBOfcRZb2+RDKOcJEW4EIm7dCP+C4YO//Bscad8VtZQ0XtGio2ErCYV9Fq4kk1Mg6IRDlSWWvfevESUfuGuMsYU0A+szAEAMzswhg44tlgqgDp6MZsgbEHht/9Nfm2Gosfnbc887fEfqDV7EBd6Rnq9XJaXctdUE+LkwroHhQn9VbCNc0hNHfpugC8BukTpvHrZYNx5b3IwKXrTmEyalSMad5TXB/tck+/QCE6JNaPWs06tQv2lhKq1IUMb3uOlZIPPhvepEA9kVk+qiG9Ad/vuZn9xjTB8cLF4lks8DgLG/z5cDWNHr4looH5BJSlGJjlz17JFImywnBo/NanDjBjuQJ808wm+p8GII14QEe7T8kQ/JLi1sT+rUP3dG5Bz8Poit5frEPc8Fw2xX96E0LgyS/gX7SN/PFpEOhrwhzMagFL6T0U1sgyER2pscEk6wkrXPgLiZIL9kJro2Soxz+2LRkngSMyUBM9N5npepF2yPPdsd2PwN0bSoH/hap5GYBplfOjOWoU6XbdngS4c4FWU3Q3qWqfkj3ghAEiTJVIpjBaI6M9UxGaA16ZegUAgBOEzpBZ75OU1RnuZ4N+lhjeBUBsr2nIcVuFIRu2XoQ4vX/bNCXyJl9hu5Ci4ddIogmfuftTp/o16FjieLQ+DnA371ZYKwskF8
 0y74DA6k
 dbMQVRHaUYOcb16f8WGFwLdwVSMSOX7ymsDlZkl30Kf2RLs6V9Ev37H7JApezpQbt+THJQBl2SsD0AJ8y46wYoe3+IhaUbz6TggJ6gmhG5r+38ChGBZSC6z/dL+XYBWXYG9gvmYNUxKsDGh5fjzJJWhuebuc3ao9NCStEAMoXs5Hb27PZT04G4dxjp9Gy4KMtKcHRi134UiKZuiBlsniZ24bdpDwjtKji02kfkB8dVNoiVgOF2EnVggrMsC6HhZCXKXseevVRTljkXRaDwP8Ap72sCgpHolkFxAB9K7YxkZ0UQfFQfQt4/2JIpqAliWBKN0dY9wAZsjPw1q5z9+IXSDL8P04kTK5ahhG/vnprvdUDy62tH0yqdOXdlg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch moves damon_pa_scheme_has_filter to ops-common. renaming
to damos_ops_has_filter.
Doing so allows us to reuse its logic in the vaddr version
of DAMOS_STAT

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/damon/ops-common.c |  9 +++++++++
 mm/damon/ops-common.h |  2 ++
 mm/damon/paddr.c      | 11 +----------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 99321ff5cb92..2e3409a6c8a4 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -412,3 +412,12 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 
 	return nr_migrated;
 }
+
+bool damos_ops_has_filter(struct damos *s)
+{
+	struct damos_filter *f;
+
+	damos_for_each_ops_filter(f, s)
+		return true;
+	return false;
+}
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 61ad54aaf256..5efa5b5970de 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -21,3 +21,5 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 
 bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
+
+bool damos_ops_has_filter(struct damos *s);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 53a55c5114fb..0b67d9321460 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -262,22 +262,13 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
 	return applied * PAGE_SIZE;
 }
 
-static bool damon_pa_scheme_has_filter(struct damos *s)
-{
-	struct damos_filter *f;
-
-	damos_for_each_ops_filter(f, s)
-		return true;
-	return false;
-}
-
 static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
 	unsigned long addr;
 	struct folio *folio;
 
-	if (!damon_pa_scheme_has_filter(s))
+	if (!damos_ops_has_filter(s))
 		return 0;
 
 	addr = r->ar.start;
-- 
2.43.0


