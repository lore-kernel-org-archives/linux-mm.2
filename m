Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74764C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F2436B008C; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C38A6B0095; Tue,  7 Jul 2026 21:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF3BE6B0096; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE7216B008C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14B1BC3B8C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:02 +0000 (UTC)
X-FDA: 84963885804.01.295F2F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7204C40007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAHhW4Om;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	b=YS+3q6rwYuXHowMBX/Jic6VnsEAxgy6+O1I6a4FvM/8HybA5CobEfI1BZLot2VuvdyeTRe
	ulzrNXtZfqiaXKf/Wf6Dr3D4qT9YeP3vag2uCNFha2mq3L7qGcKtSvBQLNOiqcYPBUdD6d
	rmTu/PXc+XtzNCDzZ91TfJMvE2cx0Fg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474380;
	b=MuKxkNH6zvovJiljK2bzWjXXOY4rL82eUB6bbqalldiAOWqvYvgURDq2pm2SSvFfDMF0bu
	cJ/ZrYsQb8bCYqgwnGbrSR8ZgiOh0gU9iuiMR6W+cIqfHfF1u+Ban9yxVsEy103a0qAbf1
	NR78pkuW9PmKC2/DmOaiUrbX3Zqrj8U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAHhW4Om;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C85CB43E95;
	Wed,  8 Jul 2026 01:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8090A1F000E9;
	Wed,  8 Jul 2026 01:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474379;
	bh=CNpIO+SPQXji8X+//JGLIeVACOioKXNsL/4ynMEtvQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YAHhW4Om8ZDCV+f6v4iF7XDkEWAjWBX4CCdPoFvA5JJcINE/q4gHVWDN460FZHs8f
	 ARzCIh4WLbzUnTjb9QeFe/hGgqf3WmTKNow34Trz8nO9uHw1ZxVKVOlH/tPoVI0Ut8
	 paKyl0QxJlpxvCeSozyV1pF5Z+2fX1VphFWzKIvTBIeTQ8lVueAMtorslKE87G5D5S
	 fTkTYrKtMjsgIMJ+dPZasZ3BxVBWX//MefVcn24SdVpogCzDvCfvegUvnC/KTfTAH1
	 2jh7/RzQiWSLGJije9OkwDihRF6/V6AAXAxDxJiPMw79XFvVom1gGrS5NLXmLyOgZr
	 TGrQNrCT9hqOQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 3/7] mm/damon/core: s/accesses_bp_to_nr_accesses/sample_bp_to_count/
Date: Tue,  7 Jul 2026 18:32:46 -0700
Message-ID: <20260708013252.95888-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7204C40007
X-Stat-Signature: cdm967xg8dgicud8byzou97h5qktj7fx
X-HE-Tag: 1783474380-583498
X-HE-Meta: U2FsdGVkX18VzaMSB186m8B1ZGbp5jzo8LK29aIDOEmOXRlR+9d7nLmYgj4rMHbZvegbTf4ReJctNBnicTzU8GbJiHs6mx20k/j9AYBmKgvIBjXbuwUDtbkbtXpcOI1IcpgW60AQDv0RM8rl/uLiOna+rP1ZjBXTchv7sMYUU+3oQThONWBFY0G+Bom+aQPVIalvg2X15JSR5LUikpgV/H5fFmY/V6oqkszqY00YktO2bT1lu/CPBwdxbw5AX4hXnOZ1tS3NccQhRByFf+2ZEVOPSy9ZsOCn9pSG+GfW9Yk3I00iPb8nazdavRHkJINI2mw7tUix+Gk9p/TjjnwkiE9AEGDQ5lu6jc+scTYmQSKq5IWFQB3AVH4K2F/+SL9arHoEQs7JHMxKkvdUHOitpPkKCiBWop+lh1OXgq0jxUUEZwPK/SKG34+U9qiEP4iDxUWYO3rmuKx2jJpylH7k+RZ3g/zuMSlGaF0G+9k80N88/Lo5KZbEfde5tKwr7uOULQN27Rn7hc5vLYAYnCAMT922zLjNDNGjv4QPICt5ty4AJ+4OQQAftyvCDpUja5UqxQLnRNo1+hqoWFwrNoewvjOqTHTIibVh/6T3pAiM/Xr40MZu+LZqYPlZLbpkgVxTiGJfmWXoQQD7Dmfa5440zKdo4zeAidmTkHT8LdiHILky1qo0j3cGvvrFirisNAFPooi5w9Xgrb551qV3K8+ov3AoeHIrv51+VUtelGuIv4GCwwfa/MEFrBNcm75RJeaklCsKpg8Hy1Idaux+8bn65nK54NZmRVsue7UctRGp4mm27dYnv63KZmHfv5IogeIPAt/cZ4wOiUPaaJpKEmMYxadhDg3mRxyVsouoT2eRyXD0H71OKJFqMbGQgQj743Po3csA9Bwf38k2MQgMX6kzYCB3skmHGv76RqLw7MIquwWUkrwg0L98XNSjLrD5p1Nnxor0v8c0pkUZ4FXFZiD
 QB+DLob4
 7Q/+LcaNXRyQqxo4g7OeKAIE1VIfx1OGIFH5PdTyWJahmk6MuCS3YGOF7xzBVbBIfOgBdDw/Yk1bTdFVBl4nQH/FFXzH0uml/r2YhDdEetYLmYPbrXbaS+f+WJr/EjHqow0+4Yywej0oPyBX7iZot59fPpawbJ1kfcWuW4qHMuYk/Zd69LJGMo2eHLh/wFvZ1ICYR/whalOKeh0XfvQYXc3HzfDFt1Lfo9fSwcKykIXgfujwIDm4oz1Xxm59QiF8JYQlPzLzTxchFXsz+GtjQ6xPqjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

accesses_bp_to_nr_accesses() actually converts a positive samples ratio
to the count.  Rename it to better describe what it really does and not
confusing for more general uses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 177e5abc981ef..dea63083917b0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -876,11 +876,11 @@ static unsigned int damon_age_for_new_attrs(unsigned int age,
 	return age * old_attrs->aggr_interval / new_attrs->aggr_interval;
 }
 
-/* convert access ratio in bp (per 10,000) to nr_accesses */
-static unsigned int damon_accesses_bp_to_nr_accesses(
-		unsigned int accesses_bp, struct damon_attrs *attrs)
+/* convert sample ratio in bp (per 10,000) to count */
+static unsigned int damon_sample_bp_to_count(
+		unsigned int bp, struct damon_attrs *attrs)
 {
-	return accesses_bp * damon_nr_samples_per_aggr(attrs) / 10000;
+	return bp * damon_nr_samples_per_aggr(attrs) / 10000;
 }
 
 /* Convert nr_accesses to access ratio in bp (per 10,000) */
@@ -893,7 +893,7 @@ static unsigned int damon_nr_accesses_to_accesses_bp(
 static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
-	return damon_accesses_bp_to_nr_accesses(
+	return damon_sample_bp_to_count(
 			damon_nr_accesses_to_accesses_bp(
 				nr_accesses, old_attrs),
 			new_attrs);
-- 
2.47.3

