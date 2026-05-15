Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E3ECD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 00:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB4316B00AA; Thu, 14 May 2026 20:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950DC6B00AE; Thu, 14 May 2026 20:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C0F6B00AA; Thu, 14 May 2026 20:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5346B00AC
	for <linux-mm@kvack.org>; Thu, 14 May 2026 20:45:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27ABA1402BC
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:45:00 +0000 (UTC)
X-FDA: 84767809560.19.D2E50CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 80DA2180007
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:44:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMLWx31t;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778805898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ev1k3U8/0ftH90UrbZPYXEQPRcDyl/y0oYfxIPg4n5s=;
	b=GAq2XkH+W9UabK5q57+RC3y8NU/F5pTGi7UwJo/YBZ8FOhS3XMA9ltU/5gJVGGcjiQhlTr
	WrnuuSUBf7R9ZGrDUwfH8TQlR3rnPXRXSoQRVQ/gkP2a4UwDVCLDDEQ/Q1BZ0uCcFRpbOv
	J0eJyjkr894kWHJgdON3qxxMZYGfCpY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NMLWx31t;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778805898; a=rsa-sha256;
	cv=none;
	b=iMeEOKZvxRiQr7LUSJ3pEstgGGw9177zDFQcQJiggkekAtp3TBuJn8JkX8IcP3zH/xZASn
	sLPH7TjGKoo7D4sZF5UA9Pl27u3Bc/8XrhJsghaGZYkssRy3rPrggOKAzxGOAzDRcZKkmV
	R1c8yoxQLB7lOANiKBwtuxZPJShHmoM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 451B643DA6;
	Fri, 15 May 2026 00:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68EEC2BCB3;
	Fri, 15 May 2026 00:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778805898;
	bh=PDuM782dGG2LDPjQZNWcCEwrn5/ZbTB5xohK557WpVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMLWx31teEvDCLkfORSTTqndUMh731Ek0cmeMEqgxqbJQ4Wv7Re8HHusjZCQ+T8xk
	 TCu22IR+UZt6zWmgSklrknPlbO/qXzK30V1FRRv/zvVWPcFf4aVUqIFroeINyZ1gPo
	 SHuFcfjhB0h5jy2YAEn3Bz2oSInkYU7DNgZQnOv+v+DuY4xvJENy1jlheJ10H5nj33
	 v+Tp3Pp0SbciKMr8iTelWTvPf55i5i/wEaJV9D3M/5Z3n+a8kjd7wPcWYpAiPkurio
	 zYzf277H1k9CSFJa/txKFLdNiNYtbTsz7nNebu/EPQys3sMG/GWvKu4lxGAX8A5mWg
	 7PbEIMGkndThw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 26/28] mm/damon/sysfs: setup damon_filter->memcg_id from path
Date: Thu, 14 May 2026 17:44:27 -0700
Message-ID: <20260515004433.128933-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260515004433.128933-1-sj@kernel.org>
References: <20260515004433.128933-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: te3frcbp7it339yg84rxgbmssiu6c9ng
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 80DA2180007
X-Rspam-User: 
X-HE-Tag: 1778805898-140166
X-HE-Meta: U2FsdGVkX1+naGj+EKUVWHE/f5L46Z/XGN7Nm4ltuG0KVvxpa6KVQKndem9wusprSXW8FBH9/6I5nP5rlIBqYSymYg5R1XnS3334JNjQVYbw5Tx1BxvUAJJCKGkJyUeMjKw5wFQQskXMhXgV/exgNYcWiRuj7HjGJU0rtad9OMy6YLIoUvd4mkiXR/P3cZ+Y8nMAkcPoai0q5OSiTBZTJmXMPBBRk6OY1S0AZ9R4CucBkIyfy3uB8HSB24s//GNtWTcGFlaZGLDGejKZMqvC6ZiJ37AjkHPBygRdfF6TP+rbOqz2WriUXVcP4qJ6I6cFfvE/6sJMy1D3yacbwNT3eIPh6fOa1hAu6dxliArB2fEKzOquOgP/EXje3fLjEJvwHLliKTZMIyRE4wFEu7550HdBgxJZNd6KD3p6b0QCoYavYCHDtB8/Q/CmuOJgmqJpj6t2JLWeSgcA5ZnDjksVzh2ZnSAX3xOP01XIb0ly4SveHspJsx0cmacJg8o2pt8KW6bvo3DBYHaXCohYf+fauYWutDYtA8a9Lkoo3plib/L7ejzsVzwcavzRgvARjvyY/a43GTPyVr3qdeYkS+pHJ0awhqJUpPPRyoxqeheQrcMx00FMF+iJpNKQln6k89aO168e189ZXZobzIYPs4ftjkBsumP8okGB5d9MW1Dvfl2lau8pC3CNuj+AoF30PCispzRSuBZoo6Z/PTGm4gxGNmCw+OLh/1UlMk1T7QFEdxySUbZyr8k6cVhMTfFAy+xDkVnOZ92yhukXMT/yrdzkNk3mG7KB5vSX9iFiFTJiLX7S3r/2HCcw+kRbcrNCvLfeWkGOSxR3QMxqjGoc7Z7t3STYs3jZtzgdNwhZlF1esEyfNVjCz2PrXp4rdVphU6bHENPEgOeLIjV7uSwtYWpNabyGWgPook6KFv+yHuMh8jtUxRZHFiE0AiQ/idAoqe7zojvm5yADY5heU3PVgED
 iYXgZ1av
 1u7c5/BFbEVFYS78DkIYfqrHlKXQvlPW8fx9YN+m3AUF/B3Pmi8g40bWKSsIOV5lPYOkAL2N4DTTUZehp+210ZIPYCNDZvzyVy/QhUCO9BC2IDx2k//KCfAdIxtgohdrZLPfvhAzMBUEbtQLXZ8wL9N+dktHWoEaKsu7TyKj7Fca+JEMevtKAUtaAkpNTAa9E4IJNM2PAwhD/Db0zxyn2C7ofvt6Je64XrFl3qgpe/+oLCietdu6EQTFUKHZySxXQqxn0WHs9AhGwhpeLQvXr4uyQ7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Find and set the memcg_id for damon_filter from the user-passed memory
cgroup path when updating the DAMON input parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/sysfs.c      | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index c3ecb35da6404..5ad46bed18119 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -974,6 +974,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2d4a63dcc47fe..a6f613c9e5c91 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -139,7 +139,7 @@ static void damon_free_filter(struct damon_filter *f)
 	kfree(f);
 }
 
-static void damon_destroy_filter(struct damon_filter *f)
+void damon_destroy_filter(struct damon_filter *f)
 {
 	damon_del_filter(f);
 	damon_free_filter(f);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 21f89f2976ca5..d0810540f8257 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1897,6 +1897,17 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 					sys_filter->allow);
 			if (!filter)
 				return -ENOMEM;
+			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+				int err;
+
+				err = damon_sysfs_memcg_path_to_id(
+						sys_filter->path,
+						&filter->memcg_id);
+				if (err) {
+					damon_destroy_filter(filter);
+					return err;
+				}
+			}
 			damon_add_filter(c, filter);
 		}
 	}
-- 
2.47.3

