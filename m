Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08286CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 05:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6416B008A; Wed, 17 Jun 2026 01:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D666D6B008C; Wed, 17 Jun 2026 01:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C996B0092; Wed, 17 Jun 2026 01:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A4E056B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:33:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 259BEC1892
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:33:32 +0000 (UTC)
X-FDA: 84888287064.22.DC9F58E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9D2222000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:33:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sm58GnAf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781674410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=q7KbxmNe1Mx2RhlgRxTjCgEeTsCY0crj1GVLCPmkWn4=;
	b=c9DOZlNlfyExQ5trJNseN+KCIKKgqHg3guSQ5tV7z2tVxrx2qsOMDqFsKe8xlPa4HVrCds
	FpEBUR8hW05UgbqzyKh3ed8BLTS31JwxTeiAiyIOrqjI6Dk9j4ExfqzxEB6saNOIzjLpF/
	3ecC29PGIV7Zssal3x/xJVkWYhxljVk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sm58GnAf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781674410;
	b=t6VZHZBS1jAFAEMKYI/6SlMy4tEOrzXN9vhDGs1kHjBuN3J4X/RF7Fe4sHzt0Y2D9O2xTL
	8zLLTW/Ejtw0etJ8ghAUs8N6qqTDJj50RxxHgH/tQvnj475wm/66vN9KheyU0ScwsOjeoX
	BaKkcuv9cqC3zRd9zuiTefsMfHS7zog=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3444600AB;
	Wed, 17 Jun 2026 05:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5D51F000E9;
	Wed, 17 Jun 2026 05:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781674409;
	bh=q7KbxmNe1Mx2RhlgRxTjCgEeTsCY0crj1GVLCPmkWn4=;
	h=From:To:Cc:Subject:Date;
	b=Sm58GnAfoIV6Zm4aRiV1K7AAc/U3olxpPxNC9Rm1WbZz2LKeL0yPrG4TKtJf7fVw8
	 TdZSlsKwdd9KUabaMKmsFUNkeZCPuSKc+w31Xi6Xrxq/eNDQMijglchjhuTskrQOeN
	 50/jyK5fQRRlJJ6XOGwRjrUOmwUm0UOastwjALISZPJXTCxX9yqYMfW158Sw+xBrbE
	 xQO3mA7VRQ06j8KpAHJ4/7iPmu2umaTA0l8+dZMMyrCFxBsbtR/FJF2Ff0PYNDj342
	 trTcn7jWXZQFYZqoqU3dRXHzVVq/TYloCSfBFZ5npoPxxIFE6BuVDIRBzVhdHcGsk2
	 vi4vNXJe13ZSg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
Date: Tue, 16 Jun 2026 22:33:07 -0700
Message-ID: <20260617053308.83200-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: tctsxiutxhbai6w9biqiqup11m66cy7d
X-Rspamd-Queue-Id: 9D2222000D
X-HE-Tag: 1781674410-428919
X-HE-Meta: U2FsdGVkX189E9AND7lX6fcw7ihfesCxUIZBlVJ9TkdZMuL8X6KUe1uGrQ5coUeDF1CgnAA+1KnI3PKDbHFCV1/D6Ec/HHgxWVFFwSDtB1BeqIeWGWSwaluB5UpM3e+beoAmN8+4ftMA0eTkU8Acxou+lolRQmXPPkEifaDm/MHGBppwrOmOSobbH3ATQb4NnTATpeQPHs/ck79EhE/RTet0twwBaOzDd982j7f6q7uvGzB3zt3gckG+2Oxkt5jk6VOz0AzJbj/D+TXHmCE0WibgtdYIDSGqdXtPk9kIoJVXnr+V/m7cxpU+i/R+JP6olv9WZVZf3pnquN78aaKiLdgJGOTSxTzVzd+v/aIa1gQTboROmV3KExvZ4hg1yWlSSohOWYknh3H1foEHpft9bjGV6F8XNl6p/3FvI6U1pVaQUsOwy02UPYu6ulW9aWNu9ddmd/6dRwDSczt3fX7a2GfO3EQmRCrgzSuBj+3NSNARf1AB/gTQOD5IINQ1YaDZKyRVCrRgMVEZw0FioWqzD9C4X7HMjdpxS8QHlAPum+SG3WwwxZPPRACeor52VzKpfUrBgR+Kx3GYcLtX8VymDvfO4wjBkNG5O/avQOdcZEadkKdiLTTeyBwk3OCzdUgv9x6/DrK+kLMES/3SEERyq4KAR3TGUfmKYtVyb7CkZzeZok9y4DKj7+lEDzkEk+QXCa8w9BZDB2y1KjNOCbhHZ+iYbsA33aIyABbTaCX7w80IwRoLxj2s2/g2Csz1e7XH4516QKJN8FUyn+ntkLAEv9jEQgzJW+zc/0dpESBxkj1avtR4E8ncfSP48MAPZ9XrQ03alj4G5LRVmwRUsNnIjz1Er5dIjvKjyXAXXzjoOI6q39F0RUty3zGO5BXXKHMKReJSHYL2S0I9x4RkbETiNNV+rnfN2CCGBvQE6H1rwXa7itUD/y4CZEswX3AqiY4nut70WulOQVS38eKIE+g
 KG+RXnl7
 4dwbkMqed3IxGYLPTPXeETa2yOLSh2gdAz3OAMCqIHieiRQ7TmmYmlQygk4tWvRbBtyvk1+VTBLP1HQ0ixoHcgK6KwII+DSdkk5yU9u3ji884AiuFPURbyo1rJasqQLlp6ySwhKmBgjBl+pF0V6YT8xBV2Xd00d/n6WPd4sgA9Ss2TWaE1Zs2KNdp+JJl8WzdGVG957wvxMVQIKEnZpMkBoKolnVwUMKPF6UE/ohV9OKm1xYztgB82SKlxPgkxnJOjn452SEdHYqmfCu4oZEgvAqXmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_scheme_add_dirs() setup the tried_regions directory after
the stats directory setup is completed.  When the tried_regions
directory setup is failed, the setup function ensures the reference for
the tried regions directory is released.  Hence the error path should
put references on setup succeeded directory objects, starting from the
stats directory.  However, the error path is putting the tried_regions
directory instead of the stats directory.

As a direct result, the stats directory object is leaked.  Worse yet, if
the tried_regions directory setup failed from the initial allocation,
the scheme->tried_regions field remains uninitialized.  The following
kobject_put(&scheme->tried_regions->kobj) call in the error path will
dereference the uninitialized memory.  The setup failures should not be
common.  But once it happens, the consequence is quite bad.

Fix this issue by correctly putting the stats directory instead of the
tried_regions directory.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260617005223.96813-1-sj@kernel.org

Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f3..0668a0e539713 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2516,12 +2516,12 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->ops_filters->kobj);
 	scheme->ops_filters = NULL;

base-commit: 2d57ad161a03e7a68b2c036bc4895ef56b4c76a6
-- 
2.47.3

