Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C9ED66B81
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214046B0095; Wed, 17 Dec 2025 13:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1786B0096; Wed, 17 Dec 2025 13:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C6686B0098; Wed, 17 Dec 2025 13:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECC106B0095
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:12:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 99874C0D36
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:12:22 +0000 (UTC)
X-FDA: 84229757724.05.CFAD3E2
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id AA80B40004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:12:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/YhjUHe";
	spf=pass (imf04.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765995140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FvOb3G0IavXhMQrYejIyEPtpWHhDtuZvMgThphxwJZI=;
	b=ehYm9J5y0b3YWyGS5Z1f9qu4gL7lmbhqAEDKKiZ55sS6slGThYsqQD1O3OTkOmKDauxSWq
	5KUeZEeCUwjpAcmhM+m7t8UgRrohgg8EHY7TwhsIg+nPBc9qp80GbsamoBMEiG05klXUuO
	FqF41wkFqox3ll1quXvDG9aH/LHEMeM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z/YhjUHe";
	spf=pass (imf04.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=klourencodev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765995140; a=rsa-sha256;
	cv=none;
	b=xKiaoM475r18LEkXU9wJmjTwyAdjSVzLYrCGC9fsjdFDEWuhuUhB/0sRsVj6K84cgfy6LL
	laINtcNwDBwtUy5cQHvmPDEs9jV1R5s8+tT+piYylZidqnrvoKFqKw+py57h/dH5K+eJD7
	Suw3DXS01p2K8bfym7KQdtV0OCn9nuY=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4775ae5684fso27118285e9.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765995139; x=1766599939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FvOb3G0IavXhMQrYejIyEPtpWHhDtuZvMgThphxwJZI=;
        b=Z/YhjUHeRYn7pH7zTW9eWKEnjarGDLFkIBRE67qup4lrNE8FWHa3ICSapULiWCLnpV
         NYc0cAqr11nHimvq07a+Buj8CNsOyWQuEoG86SN9n22kiKAt0jlvLFN5gYBw1ycQ2qsN
         nuoYM4slEsh9LROhDtK1TWqY3BK2ophl3DtTb1EXw5FVNS4rgpZVQQqU1pqATnV36ZMo
         6GIR6RnUHxFKYWpWSAlybVd7gDDxmSgnXoLzredlqR67R8+tCnde/B/SSuy7YmjtECZt
         v7cCjvBtIsm01BQOMEN8D1xz3DKTq3QoE7hSEZMzC+oA9V4xkmVJ3cZ7HRiTkeRLg7ol
         u/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765995139; x=1766599939;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FvOb3G0IavXhMQrYejIyEPtpWHhDtuZvMgThphxwJZI=;
        b=nksT97IqspYkMcyA6dQ0x7fhw7Nb7rDas6YTIrXdpO/NFNEE/faZAru+MAKHfVOptM
         qJPaMBmJ6nkIrenNarqvL+JkFl0FjvNf4CnZt5ib+6LK6h+IlSspzUkcmXgKsgos8x/U
         I92c75yF8+/vksvxqX1UfkkzgWZO+Sl9e8VGTKnMCXYvEdZVyFssh5xhoOpdp5RXer9h
         mvhowFclWuRjkfK62ztiQOw1KzuoXvLOS/jFlPX9tICwim46URh0ibWU8G4BJ35vCaHQ
         eMTKytzdFXm936BBcW2ghcsIqIfArxxJ2j6r7ZpO/rlJ3MSIGEt3LAw2pFm5mDlv8wNh
         MFBQ==
X-Gm-Message-State: AOJu0YyeCT66KM5v9OGnY0j57e81U/SnR6GWfNXopjK0D6rZlY1sodVV
	iXN1FAoFTbA/WpkMKs9JXJHEUQU8LcRes7gC7suY52/uWpvLqtueVgo2
X-Gm-Gg: AY/fxX6PT/C6B+AQnaxeKiaqW3kYdw3531hqtdoWHD11uPn8RH+X4QbWWqDj1Vo8S8H
	AkXCpVXEJk3xOvT/ocSFKd2Mrztopaxl1b2BCqGjd8MXSEfFHtEMFCChM95s5YVSsxL+PwgcDSk
	qbKCFIEwfhu3PJQy3Ui8wrIwXeGTPeGJAkBPoOR4XdVHEiDcU/ZTOR2P/Dms27jibUKq74dx+iJ
	LEiJhQObFQAZD+54tNraZhVTbnZ7KzOVKvOLJHYeuIWDB2rA9YDUXzgBOA/aT/WqfXqBUG+Pn+J
	adQFQa+NBG2SXWvCjN5h6aCZZqiMYI2fuuNh3MJnnAdYAagJ+Xs2WuPh+hiQhOGkv2/3dLueVhy
	45XUlUNPVpxALjr4FcU4q8Hjwpa4aPWxDBfcdGOFTXp7wxjxU6MR2GbOo7zdhrOy+a6Fngp33vt
	GSFXEFF3rqr2hM6rdTZvY/tKjcZErxTvgXZQGFMQRGd1WhDIDTFF9D6WupJ11ABH4BN5hgzSluJ
	az4saxTTyeES3s46w==
X-Google-Smtp-Source: AGHT+IFrcnRLclB24WO5IWIbHNWptFccCH0kwz5N2SpmkPmKMF++VzNF1omLEkWV4OJ2X91cRMJpSQ==
X-Received: by 2002:a05:600c:4f86:b0:46e:4586:57e4 with SMTP id 5b1f17b1804b1-47a8f9057fdmr193235835e9.24.1765995138750;
        Wed, 17 Dec 2025 10:12:18 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43244934c29sm340909f8f.2.2025.12.17.10.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 10:12:18 -0800 (PST)
From: klourencodev@gmail.com
To: damon@lists.linux.dev
Cc: linux-mm@kvack.org,
	kevin <kevin@desktop-mu90jgd.home>,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH] mm/damon: fix typos in comments
Date: Wed, 17 Dec 2025 19:12:16 +0100
Message-ID: <20251217181216.47576-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA80B40004
X-Stat-Signature: 8i9jb8k9rdy5417ze34mc63quh7q636z
X-Rspam-User: 
X-HE-Tag: 1765995140-6148
X-HE-Meta: U2FsdGVkX18sqcSyh3pRJ2CpYuGfDBjTMSIzpVvNbW7abflqiJPnrGas4T1TUZlvjVZWNP7YtilhUDBvabFxtaLg9NmPYBLMWZNbRgAnYlh5p1vDNLlsmQ4cHJ2cPoLuMrv1qotezukl+ecAwVQEvZ5f5YPndjZSQDg4QpBghViwKFwHjd4e0OGOf8xsCm8INs/AuaxT1+pEZR9oKk8ZNrmgBTgemFBH8jMydI+HUCvqZokjv1FaDmXsljVK3cWmhdEUJeS1qZZRPLphJvR0KtgIYjWZ8utzn0vodS27VrAxW2IcLdUPxtAN88YejqCaztC7o3CFB1Y3iQk6lcmngMkzhXlGvToazscXQj3+XT77N3cmItTQ+e2d8UYqoNICuMB6Q2YT1LxpYCJMou8me+5JaedS7AFg7jyYF/adj6rmwsBpqSQ4EJaj3nZpu80USe2NydXtsn83qJ4dL5SrA2TyJbT6BKIT3xObkneBCkSmkGHvhZHTRTV3q0lg2tlKGlBnbYrnkgxDopNPLKnFDoOdfAz62tQ8x6jM5Eu0DKllgg/KFKO3OQkV+8QpZdpi6EBgJZPfFqN33++92b9Ukzd5IzUG29iz2ggBiJvhXqQq21Or1UDG3ez5aWGkUmBmuaBeMqEhzQwlrc1WU/VsR8eYNkYKtsnaCaSwsScSNoTYyAMkyEVJ+Kk2tcuhhqC3y0MBaniwarRJ8Rde2xHQfDgIXw5PyNrR6aa7lYBu5xvlSJAT4mVzx5jmF0z2ASdJTUbZeCTMnNhf//QOq1ml1RzOVs5cYo8FI8GuuyHkdf2GLh6JRFKnnYmJk23kEPcrSSye0LLm9lKl2bfTcP2y6WP1Zl130almSfpk5gXe2phfA9FtaY7/Kuj0YZBf93nHTSTZZM/BVK7U9gFN8VdMkrBQ3sinq8ptIz6X53hoMM9v5ed25rilmmVE8KiwkHiJmWBZ/eFcgewB6NeMD1O
 9KEArkuy
 KDhcKoYnOUE405Vxy+T4yslqlKhAYxmEbtzAplmmcdcnlkQ0QDKBuCbf+hiRAGS0dxn5peeuVe88uzl3nlFvZRVfP9tyeqFNqrbUclL+j2trh8Qrf3D+socfwRW3FwWPJq6T4QUjUUPuG3v4s3Z2Cg21RHk7FzzwxRmJ6mNN5ojw7l1lQrfD7+R0bWqPsqWZSG3nFzhV7imf61VgzDBpITD9qjv+SgFGlin1iqWJ30PIoKe0fif9qiBi+atmrXBNabe21MD4gNX+XoQBjrvtoQUK/s2Wje4F2OV+5x7zY3+lknEJEuwS5GkK+F3FTeOXCbThtWdo/rbRvNqE8f747hqnnbQwJcydINsgKcT1OF+b+EIO/J85Ob8OGpGGPTUOri+FzuLAuZIAGuJwQEp/h/lCcId+Q3YXANGkdJva6Z16ybgJYz2/K46D4aHLzaEzObQ5jdVTgyi5sd/I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: kevin <kevin@desktop-mu90jgd.home>

Correct minor spelling mistakes in several files under mm/damon.
No functional changes.

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/damon/core.c             | 6 +++---
 mm/damon/lru_sort.c         | 2 +-
 mm/damon/reclaim.c          | 2 +-
 mm/damon/stat.c             | 2 +-
 mm/damon/tests/core-kunit.h | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 68dd2f7acba2..da4820110e48 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -284,7 +284,7 @@ struct damos_filter *damos_new_filter(enum damos_filter_type type,
 }
 
 /**
- * damos_filter_for_ops() - Return if the filter is ops-hndled one.
+ * damos_filter_for_ops() - Return if the filter is ops-handled one.
  * @type:	type of the filter.
  *
  * Return: true if the filter of @type needs to be handled by ops layer, false
@@ -1586,7 +1586,7 @@ static unsigned long damon_get_intervals_adaptation_bp(struct damon_ctx *c)
 	adaptation_bp = damon_feed_loop_next_input(100000000, score_bp) /
 		10000;
 	/*
-	 * adaptaion_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
+	 * adaptation_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
 	 * the intervals by rescaling [1,10,000] to [5000, 10,000].
 	 */
 	if (adaptation_bp <= 10000)
@@ -2756,7 +2756,7 @@ static int kdamond_fn(void *data)
 				 *
 				 * Reset ->next_aggregation_sis to avoid that.
 				 * It will anyway correctly updated after this
-				 * if caluse.
+				 * if clause.
 				 */
 				ctx->next_aggregation_sis =
 					next_aggregation_sis;
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 49b4bc294f4e..9388b091deb7 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -34,7 +34,7 @@ static bool enabled __read_mostly;
  *
  * Input parameters that updated while DAMON_LRU_SORT is running are not
  * applied by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT
- * reads values of parametrs except ``enabled`` again.  Once the re-reading is
+ * reads values of parameters except ``enabled`` again.  Once the re-reading is
  * done, this parameter is set as ``N``.  If invalid parameters are found while
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 36a582e09eae..8463a5a5032f 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -34,7 +34,7 @@ static bool enabled __read_mostly;
  *
  * Input parameters that updated while DAMON_RECLAIM is running are not applied
  * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
- * of parametrs except ``enabled`` again.  Once the re-reading is done, this
+ * of parameters except ``enabled`` again.  Once the re-reading is done, this
  * parameter is set as ``N``.  If invalid parameters are found while the
  * re-reading, DAMON_RECLAIM will be disabled.
  */
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index ef0a1195a584..5e18b164f6d8 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Shows data access monitoring resutls in simple metrics.
+ * Shows data access monitoring results in simple metrics.
  */
 
 #define pr_fmt(fmt) "damon-stat: " fmt
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 8cb369b63e08..f59ae7ee19a0 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1159,7 +1159,7 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	damos_set_filters_default_reject(&scheme);
 	/*
 	 * A core-handled allow-filter is installed.
-	 * Rejct by default on core layer filtering stage due to the last
+	 * Reject by default on core layer filtering stage due to the last
 	 * core-layer-filter's behavior.
 	 * Allow by default on ops layer filtering stage due to the absence of
 	 * ops layer filters.
-- 
2.47.3


