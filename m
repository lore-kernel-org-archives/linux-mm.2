Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A0CC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352886B0099; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F716B00A1; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E3C6B00A1; Sun, 28 Jun 2026 18:01:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9B106B0099
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:01:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4A0171A04E7
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:28 +0000 (UTC)
X-FDA: 84930693456.22.E696C2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A01F220003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:01:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JXALbY/b";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684086;
	b=Of1tQkXYcgxLQn6hjt8HDbtqF565Usq/z0+/MxXL+0S9gMpRbPzSJczVuUmFynUH+9VsXL
	luVYUUXNl9/cGXlR1BQSPKRGWAVl9rPWl7Ia1R2isDQMgVFAsDONqmwJDAxPeiZJMcTj5s
	mwpwLg+ly1w5Ol04+njAyp7MD1yfKB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kWsoAsTU2RLrwCg9yIH11L07Sw1ho6y486HJ6RBWC/I=;
	b=UdfgEie7b/l/4eWP7NpJrWU+koJYYHdjCiW/CkE65oZjVuwI3vK6k6fiRlEfPnWKOHFgnk
	qovqVsTuGNvhRE1rFgwccHWFif8dDcQMV/Du5ibB2SJWY9KQAmrrXrLv4XI2cZj1FPbBG0
	6wl++kIeqyDJMYBwZgFf4unnWccRimA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JXALbY/b";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E328D43847;
	Sun, 28 Jun 2026 22:01:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3DC1F00A3D;
	Sun, 28 Jun 2026 22:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782684085;
	bh=kWsoAsTU2RLrwCg9yIH11L07Sw1ho6y486HJ6RBWC/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXALbY/bP7agD+NSNT/wgc3+09pPckbDI6uMcxzEJJp0aSErNwKoOXuGUuQ/V1+Vy
	 U1wzqONNSi8fzYLB8K74lWuWsqW639h1mV0b7BI7kDq5gdHwPNdp6aqwUJGbL7O4QZ
	 AXLr2uOOV78AWdEaZ6MdwT/AepXjH2Y1v8K9RuaNDi6CXgdLeENvD1s3HJTMQhi8et
	 TiGM2D4DeW1xSbfD/OvLYw+o2BGC4IY+dpAi+nNUesTid3oCMhTPxSmn2Ih7inRh+3
	 x/sAUs68rILMRHGHQG68nltgKY2RY+ebq04XD8S8VR5PHjUnWfooR6MBBtKYzX7TY8
	 U0QxGPPsPiWlA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/11] mm/damon/sysfs: kobject_del() region and target (error) dirs
Date: Sun, 28 Jun 2026 15:01:11 -0700
Message-ID: <20260628220121.97360-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220121.97360-1-sj@kernel.org>
References: <20260628220121.97360-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9xe3uaezpenxjcwitktb1zz97qfpid7e
X-Rspamd-Queue-Id: A01F220003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782684086-646938
X-HE-Meta: U2FsdGVkX1/GqP14lVRF9EndoXyAji00z+GvORgoaOLf0ejg5netwkJqie538jdG3WGadeh0t/GaAW1GjNDuDMjZAkJepMs3LYqLghVvRYd7E4r6s/JVPM8ACOq9vm247My730dSNtQ7Xg9xDpKfRVdUgxOlpzGorMk5VHJiNdh7y9xci3SRjW7a975a+z56xKpvzcznjDUA9BW4hZJci+wMtrH34mSCGIN7V0EA9sVcUDi4zNziZVouB8F/svVu33hUGwPlJi8VMKN/b8aZ/X+RPPKx6B2vzvJJxrDzWNTCKhCYtpjrpdBOlVIDnGVmT+RC/O2trC50jYH/ZpCXvT+1fyiUQfvKLIrsfqvVFEe5sV5Gi92GYq4C9uTLpfiWv6xrNQXdJxSwgk2W4StYbPo99uwzAJnK2QzjKz5CWk1wGP0ymSgvfF/l2fskoU6n4mBsDheeWdJyCFjS4O5HmTNJxCVLx09aVmKT2b5UDAjAYprupRg+D+Sy5ivyC5cek0yna6Ep+yMqXm4xdL+a7JF8lqQva9Mg44B9XbS3CbBcwG3mpKn9gFRlels+JbdBFemC3RCDpF3lxXXH/mYzuPvqZ41LavWuupHnZeTPC0XRbWRueJ8NIZahYMl95TrcVfBcQh3ikuOentGnL4Soq64OZnAxPZoNX+Z18cVCezeBKReWd/0pmUwyew7fgjqcYMLIMJTMRWfYbFxvyl8sEo+/zRR33nBbWFx8E1jsRWOh98LseGzodWLRxPcfjP7MDNU7XcNTidBnGL8Bsn6JNke2TdsgCcrSCFUjBPHV+xnlFqzP3KEzyfbDu1ADFC7KSgMAgX16PggPGM3qXDS2zEZpdtvNgrl5usrvXODWehE9AMvf0iCdqbGtaeB/mlxAEFEvEffdufAcKfKYBp/H4zl5gAFmWPmCFafb+XR0Nfgv5WmZ79xfMo8TFaYr801ZeuIaljzxM7W+iwp74l3
 m3/HbquI
 iJ5r9NSOZWyiDSWgEJnVPc8SpCfq+oaDSwnkW4gQN+eW1zQwg8GyGW1K6t1ACgUdaZ20xmlXNTnYgStYYrIXmciV1t6isDSwGmcNSE7+hMJZziQJVR/Qe9IOHN6ItN1QXcQRhDteuKwuAgaNhFyOyLkAXL1DKF6zGAHRpkcQbhxoG0jLpSy0zZ7fJ8/Cc7LaVR7eN8hRaDUHj9O9sqgNvnw3Bu8QP5bdqkyizeml5qAkZk4c3gwu+NSjvF3JjSYJiSX1vyio6JniVdZtUVeDr8r/TbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for the normal creation path of region directories and the
error path of target directories, by adding kobject_del() calls.

Fixes: 2031b14ea757 ("mm/damon/sysfs: support the physical address space monitoring")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 38f3b02481f0a..204aed6a3e5da 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -105,8 +105,10 @@ static void damon_sysfs_regions_rm_dirs(struct damon_sysfs_regions *regions)
 	struct damon_sysfs_region **regions_arr = regions->regions_arr;
 	int i;
 
-	for (i = 0; i < regions->nr; i++)
+	for (i = 0; i < regions->nr; i++) {
+		kobject_del(&regions_arr[i]->kobj);
 		kobject_put(&regions_arr[i]->kobj);
+	}
 	regions->nr = 0;
 	kfree(regions_arr);
 	regions->regions_arr = NULL;
@@ -370,13 +372,15 @@ static int damon_sysfs_targets_add_dirs(struct damon_sysfs_targets *targets,
 
 		err = damon_sysfs_target_add_dirs(target);
 		if (err)
-			goto out;
+			goto del_out;
 
 		targets_arr[i] = target;
 		targets->nr++;
 	}
 	return 0;
 
+del_out:
+	kobject_del(&target->kobj);
 out:
 	damon_sysfs_targets_rm_dirs(targets);
 	kobject_put(&target->kobj);
-- 
2.47.3

