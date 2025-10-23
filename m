Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10CB7CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA64A8E0015; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B081F8E0012; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F6908E0015; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9858E0012
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 604CD48EFB
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:43 +0000 (UTC)
X-FDA: 84027636966.25.B61967D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id A74981C000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egoIfw7I;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182741; a=rsa-sha256;
	cv=none;
	b=zO0HVpGln94983mtrw72e/fHNHSnhstB4brgC4NPcXkUH7z0ThY9jis6+o2Yk3S+2aoZ5T
	18FeofCkeeX2xf6IcNCd2GaN1ZA6H0LNJFMRSHDbsIsdrolet30642gEco/DzIHsNtNcp5
	sEmXnO9dGl07AL9NH0wSJ50mrYgQjd8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egoIfw7I;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EAMYY2NIKVreySkrIfAWRuDQQA5KdMgTe1hGu0pPYpo=;
	b=7kjAHJhSFRj9WZm1IoUUWNl5kG9mQihR0bYq8ommkljWlJ2SEu0sBl7QHjNFeFM9yDpmmD
	kj5XMKsNIgSuK47bOBR7lKgvakBajSqHmWiBx/pmHVTs51VpSUjZcw3AokXtK6LRBw2yZZ
	feMY3LuYt/CiXJMdOkQynnCp8weRPiU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B965444229;
	Thu, 23 Oct 2025 01:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A71FC4CEFF;
	Thu, 23 Oct 2025 01:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182740;
	bh=v9vH7Jep/EeX2FXur/wyq53jucsgYHdF++0q2V0OArg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egoIfw7IZ8X9uk3E6nENP2Hxh1zKENq+lziGRTOzPFZbi3sbe9zR5TsESdtjvfcrM
	 d/8w8phWaEcF5VWGB3gEYPbpOKK0lf63OCfUL0fDToEzHF/t22Zy+fwyBCjd+XQsvI
	 ZFV2Y3SmLXer1AcW1/wCaeb+2YqnO73ULSCr2ot4Iw96ESygPYDrRcU3TzQUL2gDlw
	 uPH6h9AcWtUyyOAkN+RUa/bOU1aPkQN0R8WCuoxkpB4P9+lS2aKDMrr1YmG0Buf3Sy
	 AgnKgHP6xWOpLet86JU8wtwqUQytwHNZZ6e3A6HZvKIx53rq7GtIbLRPSaB+yv+VXM
	 sAUNpIPwVIi2A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/9] mm/damon/core: add damon_target->obsolete for pin-point removal
Date: Wed, 22 Oct 2025 18:25:25 -0700
Message-ID: <20251023012535.69625-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ow8wpu9rfm3ayp3o3eg7sh4xzh7oz8a4
X-Rspamd-Queue-Id: A74981C000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1761182741-419250
X-HE-Meta: U2FsdGVkX1/SrF0vzhhsDH0U3IEHe35lPcHogDd1v5b1rtu1ZmUJ20qbOd4GQ/yXwrMjD0Eo9KABBwtt4SWEybIOPPotXrnYv+qQP1ioyOJup/pxg7NgOkdEEguyNks7fqFCYhOXR3RRdbz58ZSK5poYe7Y//V8bpbiq+1IR/oY7B5k6HbO2cwEC03z22H6r6VUeEh18JZkNPInMZ03KoetNAMT5ICOs7vo86PZed66xZR+8gPOygsOq5G6d1nCc4bD+yAEs3M5K1LbVOw2Kqp2banLz8HiDi+aeerKmDgnPN7IRHD7+tWgw2kNuYtTo31DRfza5gUCcu5WaZ554QzC9ssNPw7wWpa+najIXXNb4cKmrR86xZxeijPlG0sqPbmPje4yhc0/vMNryZ/6QYycUpDhXDpt6kxnauVJwaMNpx4Ad6Vt/Sljx4JMNrppomgnd5YOaCqusiseoGxdiXJ/pK0tXlo/W3YFx7qeQPdIug7/A2Pj5ssheB85Chtpz6N+VX6d4JD9ELg4il8Wn1aIynXf1YD3lrGXt0j8RLakREgMTBjTwB+wuEJlGBSoEBsM239GjnCuJeZgpYcHw+amirZj90vlU7j562HNGaex5gEMRlU6Z9jn8B3kJ6CHGj8Mb5wk4ttqKnBvaCC68yqQq9G36CN4n3ifsNhl0YS/202HQoRApQzsgTs0/C+Jk7vsXv5CcdGujlbAxchndbdIxn85gN617hbP2luXIGbHSDTtYZfYvuWijm1Y5xfHYht5nR8XYFV8ViwZHWL5pg+QeGuP1uktszSj0QSB1480wlNCOsY0nCK8jNcTvA1oTC9xy3tn/X5R1AwbXBdfK7F19bWe29525aDOSdmJryqJsSsbb9fnykFhlQYK4mVCNJsm40fPLm+8Bzw0NvC5WCN5ktm+P+zf8Ghdi8Qk3T+Klx6fTDC9XWXLeJC7clzvLqv16kTkogsaoA8mHAu4
 6I+IJErG
 NWWTyxNz60/fbs+o3+U7nThM4/WTRzQci1Q2/SWTptE6WFqkeYPNJejW8vx5DukTtck/jD7czPXuXkJ0EHZX72kn6y+k9vrhMF37zJDs/RsPYSm95Fq4hE+rI4VdkGc673gdrALxCw+ENLaEVQEvE+MrJ4iL9294HYtwGKgZ7tBs5PmrlPq3KUgeUuSUWViivBfrbRu+0lc6jtAFI3fKSkNlIAu/vaZ7p4qCcgnToTeeQL84meSajzd0Gr6NDfGTiVzhCZUk8vHdOZmaQNUM7M+Nv9D/ip0e+9Tj4WUi0MCHNDLo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's monitoring targets parameters update function,
damon_commit_targets(), is not providing a way to remove a target in the
middle of the existing targets list.  Extend the API by adding a field
to struct damon_target.  If the field of a damon_commit_targets() source
target is set, it indicates the matching target on the existing targets
list is obsolete.  damon_commit_targets() understands that and removes
those from the list, while respecting the index based matching for other
non-obsolete targets.

Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Bijan Tabatabai <bijan311@gmail.com>
---
 include/linux/damon.h |  6 ++++++
 mm/damon/core.c       | 10 +++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9ee026c2db53..f3566b978cdf 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -91,17 +91,23 @@ struct damon_region {
  * @nr_regions:		Number of monitoring target regions of this target.
  * @regions_list:	Head of the monitoring target regions of this target.
  * @list:		List head for siblings.
+ * @obsolete:		Whether the commit destination target is obsolete.
  *
  * Each monitoring context could have multiple targets.  For example, a context
  * for virtual memory address spaces could have multiple target processes.  The
  * @pid should be set for appropriate &struct damon_operations including the
  * virtual address spaces monitoring operations.
+ *
+ * @obsolete is used only for damon_commit_targets() source targets, to specify
+ * the matching destination targets are obsolete.  Read damon_commit_targets()
+ * to see how it is handled.
  */
 struct damon_target {
 	struct pid *pid;
 	unsigned int nr_regions;
 	struct list_head regions_list;
 	struct list_head list;
+	bool obsolete;
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 82546d138a5a..d78f4452e536 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -479,6 +479,7 @@ struct damon_target *damon_new_target(void)
 	t->nr_regions = 0;
 	INIT_LIST_HEAD(&t->regions_list);
 	INIT_LIST_HEAD(&t->list);
+	t->obsolete = false;
 
 	return t;
 }
@@ -1187,7 +1188,11 @@ static int damon_commit_targets(
 
 	damon_for_each_target_safe(dst_target, next, dst) {
 		src_target = damon_nth_target(i++, src);
-		if (src_target) {
+		/*
+		 * If src target is obsolete, do not commit the parameters to
+		 * the dst target, and further remove the dst target.
+		 */
+		if (src_target && !src_target->obsolete) {
 			err = damon_commit_target(
 					dst_target, damon_target_has_pid(dst),
 					src_target, damon_target_has_pid(src),
@@ -1210,6 +1215,9 @@ static int damon_commit_targets(
 	damon_for_each_target_safe(src_target, next, src) {
 		if (j++ < i)
 			continue;
+		/* target to remove has no matching dst */
+		if (src_target->obsolete)
+			return -EINVAL;
 		new_target = damon_new_target();
 		if (!new_target)
 			return -ENOMEM;
-- 
2.47.3

