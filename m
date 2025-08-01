Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01987C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98BD48E0002; Fri,  1 Aug 2025 19:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961F08E0001; Fri,  1 Aug 2025 19:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 878118E0002; Fri,  1 Aug 2025 19:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 76DE88E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:00:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0062016031A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:00:33 +0000 (UTC)
X-FDA: 83729709546.26.F8DA5D0
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0F639C0012
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:00:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VhZqdn+8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754089232; a=rsa-sha256;
	cv=none;
	b=qFHSeRY/0a/0Oji/2QA4raJnChcXHbcLwqxD4OCOx1+pU+GRYLWYHLUYgvN1GqijLe7y0M
	nedouyyI4TscTdtt39s8YDr/VyvtSk9E7gO5R9MnxrXfObvwRnF4DmZwmwukQpfpEJWYFH
	shDSFdse2zt20IliRWICSr0BvpqoZOk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VhZqdn+8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=pyyjason@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754089232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=abqEG4k6EI+O4I+vteJ6XJztfIuJJUkYy/PS43p6Afw=;
	b=Tk7DvLp+IPjwe+4yHIxskob86dCg94BwiXgwp8KWKfmFJ/+/Eh+32pLTAHMmVHRXC5TNQv
	RM1WpOP42ZBD+tavZDvnXuobwM2L2Mbr0YmDqtWmnoXrqdPP0n/MopPW5C472Ua6WWkiQ3
	shvNvri9tFfsw1nvAhMGmc7251OoUvE=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-61571192c3aso1778299a12.2
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 16:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754089230; x=1754694030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=abqEG4k6EI+O4I+vteJ6XJztfIuJJUkYy/PS43p6Afw=;
        b=VhZqdn+8vtArfO6b79iXwzD0mzGjSJnEoPOoB5KL/hebBpHAVaEf1WhV+SlFe0wVm4
         BoRvOktW+LtSvAOwDsc/n5jc4aeahxFgB43L6wqt9BWZN3hnbLIlVK4VLEa77iy/qO59
         Q1rr3FknRKLpzISXYb7jL0Lj5ZD929kZT7QZiRiHICfUnEpJlsxJPUjrYsmf3XTGlpSn
         xKx7jawVVLAVQ9za3k4bAvxim2yvWfMbHB1wOntAAjVzyjlho5iGLa3QUNg7a8QNNSu3
         HAZzNymyYhk9WNyzhASms7SZHDOJ3uoOxAgp5kwJZcetImNiVzjJcTQT46yABBFYxtUO
         /s8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754089230; x=1754694030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=abqEG4k6EI+O4I+vteJ6XJztfIuJJUkYy/PS43p6Afw=;
        b=U96FKv+1ibetCOywbhj8EBWvmMN/ksIur/J0WcHuecnRFIMTkA8M+s4D3+qBHcc1q2
         p00Gc0mlhfRvQX1iSgPXX+sMompnMtkT+3Gwe85t4oVa1rq9Xk1NyYWQ1LgIHfZwpC3B
         aIAoaOiOt2ZQrsh4Ib3IQPbpw829bpuAVd5aX1xOMVpptDstEK9WFxi0oO87nzOG/W+1
         7+xpjEal+OZoB41zCB135rs+aa7Mq7t8YsZDJ8Jxnzx7ArzPB+V5NdtjsUDiJ4eLwqgo
         gkUBI2dWMilYCONYCe+AOq2Gmzf0cff+ZOUQ7pBAUGMImQtKcfVkacsSEo4dhgUM0lr4
         8Glw==
X-Forwarded-Encrypted: i=1; AJvYcCVPJrjG/JHskuUf7NcXyyjx8fPc/yzJddo7hklURizExtKhsN88esf3bDVwvvJtNrls6Thdb6lVIw==@kvack.org
X-Gm-Message-State: AOJu0YxUxE39gC9Ccrq5bREYYcorowvg3CJgaOH3RSPbiDs83h9wul88
	t1PZnwNovHBkGhz6F2xEq6x5M+2XaQjHd5x3fpzrKorq05F51EGtTJXSCMNE1kIqa4mOfg==
X-Gm-Gg: ASbGncvkKqMFwYYdSUVNkuupkAWHVljmoGfzOLVvlczmxSSaHEt5LV4VEkTdNt1DVbk
	nmXPFMnbohbjHYm9RX5+lEvdpXhoD3X4HkU1o6CvSQcVhBF3jf+mpx1GQEzC4lIdIomjlTQ/kzV
	N1iaOmbkeqNrLwNAlOWHD7xsbbnhmpYR/lvoj6ZEaBGDogfGDnYAtz/c3Tlu8g4BwWSMNWhdDoZ
	aTbKwhn57DWCyVSIhumg4UDWnYC6DjwsdrP2XQ2eMTKWRtdFpCsIP0lbIgzLavvTT/b72aeLrw9
	+2bjMIo5nj62YPulOCIl56jJxYZEJtNZtEawUB3Yku7Gr9ukwCzPsnc5iGNydFl3HkAQMx71MnI
	PhmPeD1D9C0dsvd/EyRHR5arn6NSYAouP86yV/CbwZXL0HU+lietsI3xmkIoWddogdEZOMF4=
X-Google-Smtp-Source: AGHT+IGJBab9bvw4VnN4YTk8kzAMWhGzABK21zAIbErqjtzD57IzqR8o7kVbKYxaiRnwlzZ5i9LCkw==
X-Received: by 2002:a50:cc03:0:b0:615:b6b9:d873 with SMTP id 4fb4d7f45d1cf-615e715d669mr677090a12.24.1754089230336;
        Fri, 01 Aug 2025 16:00:30 -0700 (PDT)
Received: from rs3labsrv8.iccluster.epfl.ch (nat-icclus-192-26-29-9.epfl.ch. [192.26.29.9])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8ffa17csm3279290a12.49.2025.08.01.16.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Aug 2025 16:00:29 -0700 (PDT)
From: pyyjason@gmail.com
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Yueyang Pan <pyyjason@gmail.com>
Subject: [PATCH v3 1/2] mm/damon: Move has filter to ops-common
Date: Fri,  1 Aug 2025 22:59:50 +0000
Message-ID: <a290e7913a1c39f605b8cceafd86d41c2dbebf82.1754088635.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754088635.git.pyyjason@gmail.com>
References: <cover.1754088635.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0F639C0012
X-Stat-Signature: 5yrzg18bejuoxz8s3i7mphdt5z4tbxhb
X-HE-Tag: 1754089231-748249
X-HE-Meta: U2FsdGVkX19+Gtf6+gMVKmN0bqFpPv84GYxa5vAgxCVyCIsvxny/bvLPv+7G/fboIc/NdfJqawHDxvSgNRN468tCQu65Qpg2rHaMb7lh9/EdMiiGFrOw2iOZCDl7nh3Ng3lhedcciUjd54isVq6PfmpUh9dFIRzbQM5cOkeqBjF7i4iLjmfqcEhY/INwoFwBDROq5iG7vMdYuXD4LUb+zgjftplMndyf/1lAXdYbrJdaQosL0p8mV8SfITuTD0nVNjoYOCkdWJXbYJ2pdoao6sBNHSwjQgd0VJD6rx0ipWdSf93YzYJNTwxTG5Rrz+vC4kWAzk3+rfLR6kLuY7fmI4Rr1fLxo1Tj0iEBqlWLnaHjzDavfdAmMBZ9wVq9puJ2zfMbca4Cpi1jR7Sl5Ag8Vn69slnsfJoW5IRJpwJwEibe8TdLxOxsLzdMLh9+m5q4Z2z2ezMU9z7p0VKl4cuj0KB7jXcbxq52NhWBhVGiL/SP+kJV60PAY7Jv3IE8IxS1tCTaFtjCNsz0TlLzd0uJyGLs3KYY8/lb8aS1PoRUg0p9o5A1nxO+gdMJ6Y1Dl70YC6rHc7us/fNbYrLlK2SsSnXw9WtLa/tw03Jpt2DJdOIYkJlC5Uqo53xJgimDHsmcet2PfPFKWNcms2b6dSYr2jESd7cGeUlYSpBoGMJSYdJwnIrDJXu0Q4IxasGhCIo6VYADFReLaFOc2YQy0GTiONbT+EaLKchszLebh12xBl9heDBPZ/aMudwh2z5wWoJR3v29caBx7KuAQUAK0VY1tiXsmWHMQ51PZKPN/Rpepau6setHmYWwB7NnrKc94SlK6S3trHtdY1Myj9BonE8pOhI6QQ1xD7R2D2eFUTkH31Sh/vB8G/VoaqJZYFhT3x4IJuPE5fYuIY/cPfC7VhwebOi7px7GF6hZCiAWQDebO/A8eV4sMUvHW7ABTAZ9zJmJ0QuyI1j8vSM5+teFIl1
 XPP0VoRM
 7dajrKMXev5omYe95Ja4Ma2dw3sdAcg144NJ2w5V5FqoKd7O/zLo03iidRBXzs/32YZha6wS+yhgYp62EjpINiJKbopWt4BrY6mLP8Mam2BjRzgwaLApAh/iwviaTHpMvLM5jz1iblH56+G4tIz8Mvj257NMlKrpg9SmuGJ2QRcWOYUmN7iGT6UO9/PmIvmvqfRTnwOHp85/wx4JTFjQxGgg6UhQGkLuDhCVMsFAbjHT1TZCiHL+JZXrgM6NvsM6ebvUNVx0kQNi3z20820bE9rO8uh65Ta4UKbjM0Wa4wGGmUIIp1WPYgDNkHHXAbVt4OKsea7eXPcknUnTFFcS/djm6jdFG0xedLKnsBVOdNI/vcsaRZWu2PZ8V4m4Mo+RzHrgTJ9ucchbCB37vPq+oa/mUMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yueyang Pan <pyyjason@gmail.com>

This patch moves damon_pa_scheme_has_filter to ops-common. renaming
to damon_ops_has_filter.
Doing so allows us to reuse its logic in the vaddr version
of DAMOS_STAT

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/damon/ops-common.c |  9 +++++++++
 mm/damon/ops-common.h |  2 ++
 mm/damon/paddr.c      | 11 +----------
 3 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 99321ff5cb92..de5404477242 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -412,3 +412,12 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 
 	return nr_migrated;
 }
+
+bool damon_ops_has_filter(struct damos *s)
+{
+	struct damos_filter *f;
+
+	damos_for_each_ops_filter(f, s)
+		return true;
+	return false;
+}
diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
index 61ad54aaf256..d3d36bca90b9 100644
--- a/mm/damon/ops-common.h
+++ b/mm/damon/ops-common.h
@@ -21,3 +21,5 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
 
 bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
 unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
+
+bool damon_ops_has_filter(struct damos *s);
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 53a55c5114fb..9d9cdcc10b8e 100644
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
+	if (!damon_ops_has_filter(s))
 		return 0;
 
 	addr = r->ar.start;
-- 
2.43.0


