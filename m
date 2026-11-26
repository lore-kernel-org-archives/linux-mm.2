Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC56606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 21:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YaaQyMD7
Received: by kanga.kvack.org (Postfix)
	id CD8DF6B05B4; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB0946B05B6; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED1E6B05B7; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0916B05B4
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 16:06:33 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BA174010C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:33 +0000 (UTC)
X-FDA: 85478503866.14.F21C75D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65DAE16000F
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 21:06:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YaaQyMD7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795727191;
	b=jF2/3JmKMrMrmFDCWZxw8Gn7am3+Zl6RJFCDXivJZVlVsUll4VR6K9dv9S6+QBizc1sOgg
	uRdLmtW0nP4wisfk4pDiDZG+dJawLqNhTDoZ03m3PDgM4XK6CQZDqhiCdSKf/zkQD9HpZR
	wlWl33t9Xg0ctFJ4NfI5KQ1kJ2A35C8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795727191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeTTtc4pH5Qdy0QRbAyn5ThNALUromTyBmx5tzYSbKo=;
	b=p2r2VKWF9cjLwSeBqjevgEFXTz3aekwKLoj6lBTWG35eq0fFfls2mX3NQ+hwANDUvnF+6B
	PGebEx4WXpgvBSQjMBx3xgV8X8vq7c5JUTfQhcMWACkByE8+HGcn68BTVC/ByK+ON+v9lU
	68MDAfphaIXQSMlT8j+9m2yd5xOUXvI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YaaQyMD7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FBB640766;
	Thu, 26 Nov 2026 21:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5642E1F00893;
	Thu, 26 Nov 2026 21:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795727190;
	bh=SeTTtc4pH5Qdy0QRbAyn5ThNALUromTyBmx5tzYSbKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YaaQyMD7sqi3aLwXqaivPPbuFvT811e3n/QKn26RVL7ixe4a5gMPo7IEnmylZJ/ND
	 h+KCkjFmUSbxyjV8GzBbad1y8PFrnGhy1xpnl7tKRhfxtqwVuxdaobiBmRveQxpC6G
	 b5UV9b5hUFOIxP8yaJRkwEdl73Fjy94VFWxYRVAF4zrLvH7+9yjZOmZuCBfQZn6vB4
	 z7a8wMKEsOk+MEiWLPH/lRnGUjCrexxl78G3QRdHIUU9rCbODup/y4ENRuNYJkc/2P
	 GJ9xnzoz+5CDwPcA7HKmjZY1aHP/hPbsXs4KVjEoL8ktWu7Uz1IvH4B4BgZT3hpxZz
	 RQ6Kh6ju7rVRw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/4] mm/damon/sysfs: define damon_sysfs_cmd_name type and array
Date: Thu, 26 Nov 2026 13:06:14 -0800
Message-ID: <20261126210619.97634-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126210619.97634-1-sj@kernel.org>
References: <20261126210619.97634-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65DAE16000F
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6sngcyru96n3i9bnm6hau3wbac3pgzes
X-HE-Tag: 1795727191-249771
X-HE-Meta: U2FsdGVkX18j09ABEXAV5BzroLN44yDuAI29GNF4BCaPszbBrdJJ1SUZELM4AasNBIzu+1AF6C1y+OTSEuBW2vGNuSIBLEH7qIh+Vsk/7O6Io+mY2uoVS6nBP9CA5gt8b3DY825Boupj+DY/t+FU0eBA4hKO1IT9mqOIBtQ9+L0oermj+UztswbspFTqmIH6clLiTGKLurbKQQ5FJyVf6Kr2/t9tkOELJIqrC30JDWjR5xlpVRJZ+tXEVZwHwT2zg8Y7UgBDdxh/aL48VYACj2wC/I54mB2AxRGW9xO+L26fvw9+iu/9J0SSuri9Mo5+Sji4f7H959bB5aNzQycoVQvi7+awkA8crQkOPktODaeSnUyIgaHyKabHkOywreiY1KPJHLDMiUwR9axldwxvEf/tWYSsbdsluBeNMzSE6RbiAN1dXOTy+W30qBrG0Vg/haW/6FWCyB5MpA4qBlw+RyCs9iQiyNowVs3DTEvIONtSanrhsXuSWKjAkRdMdA+XiNiU9f5hLEHYmX7PzZLzZPSgsKhk/k+Vpz0LB7gVY1u7p1seaeFDM2DJLTVxNAckGEs9X9WHsaz8DDPym10FwZBE7oItuOiFodeIWSg1QVYZNFJFY5Wm+L9Mr5ZqN6Gt/+NBMgmy8MO/TQx9W7KiSMDMPD9PAJUPlsHrHvuI0fswEZIUSoAOjzYTrQi1KYXsFaDIluW8fT+YqC36i3YSx3i/gj0SeJlDMhN6XgkYz0DckMPRzLKxJfCBv8vP1+bwyd9ElBwZdTUkEzzZVDWeEkjN1LhJpJxjtAa6P3IpuB/2mzVmVq4R0M4xJCPQh7FUZvGI6qaR/Y340k9E80VUsjoMxN0GIl13uj20Ml5B1O40pk2/Q/Q0AITrdX/nE+YVojstu6f9dZ+QvgYKicMK4j3yacMf8uYRNyneACUI9Krgs/qRcZhi3/Cv3fmYQNxHmeoKnWkE9sn0NKW7XJd
 JqLGYjBH
 Hh5hOSPYUU7oAS9v9xbFk8qHvpyWDpJhGCe3YHeWmx7tWVyBpe96Yam9pOGeIWC3Xb4perCLVixa5eyr+u4UmtD8UbeieKIsYbyEfX9wJ+JBBzWa4WzrMTuWrEHCRQwosqCQsYXTRrj58LsafOkIYMeRscX6C3ZfKM4xaaKSpXns8GziQn0DBIn2O21zjNZKRaM/dKZheC6jJQop8jdYBFambEA/0Z0U+wfeQodJQH74mS0g27A7OcXPgzWMOds7MHXD502uFKwOznRVvqqPHvVOtaWAxtaPLgaxQpi4t6/v6LDq04zVaugj2ZcruamN6Mox+ZywaVXP6tIb9ZSgQYY0s4cjElMddD2wL2bqbkwSc2B3M0bOki/8s4KKQVOdtW3fEEBgJy14wKgV2ueNdZnpaoDUXQqMp9lbziCWBREMfQWngGbWUEv7Ea0GXPCnBJGlocRhSXzxv7JuRiwf0YwuPlwScPT0EtsMLk2gdtZ+DHypcmGV7fgOV6t1pYUFgcz44
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Define a new struct for kdamond state file user input handling.  The
struct explains what user inputs are for what kdamond commands  Define
an array of the structs for all existing inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 0049aac6ab974..c76063b703a4a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2254,6 +2254,54 @@ static const char * const damon_sysfs_cmd_strs[] = {
 	"update_tuned_intervals",
 };
 
+struct damon_sysfs_cmd_name {
+	enum damon_sysfs_cmd cmd;
+	char *name;
+};
+
+static const struct damon_sysfs_cmd_name damon_sysfs_cmd_names[] = {
+	{
+		.cmd = DAMON_SYSFS_CMD_ON,
+		.name = "on",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_OFF,
+		.name = "off",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_COMMIT,
+		.name = "commit",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_COMMIT_SCHEMES_QUOTA_GOALS,
+		.name = "commit_schemes_quota_goals",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_UPDATE_SCHEMES_STATS,
+		.name = "update_schemes_stats",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_BYTES,
+		.name = "update_schemes_tried_bytes",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_UPDATE_SCHEMES_TRIED_REGIONS,
+		.name = "update_schemes_tried_regions",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_CLEAR_SCHEMES_TRIED_REGIONS,
+		.name = "clear_schemes_tried_regions",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_UPDATE_SCHEMES_EFFECTIVE_QUOTAS,
+		.name = "update_schemes_effective_quotas",
+	},
+	{
+		.cmd = DAMON_SYSFS_CMD_UPDATE_TUNED_INTERVALS,
+		.name = "update_tuned_intervals",
+	},
+};
+
 static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
 		char *buf)
 {
-- 
2.47.3

