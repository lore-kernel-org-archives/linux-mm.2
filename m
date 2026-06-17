Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB8ECD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 646296B0099; Wed, 17 Jun 2026 10:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F42D6B009B; Wed, 17 Jun 2026 10:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498766B009E; Wed, 17 Jun 2026 10:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 12E9B6B0099
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61E8F1C25A9
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:35 +0000 (UTC)
X-FDA: 84889685790.15.4659009
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA2E940007
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVxXd2YX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f+ZFI7Qgbe7xnOZyetZ4L3vI22eJ2l2ckq5hmR8a2XY=;
	b=bkln7MSCmpakt5xwUcPEiPtcgsx4i1cUYuijCZtMFcMiBGdk96ZrwYrIlStC2SNJOUVt9L
	MyCwKSmCPjVKAH2I1kUcTEI0Raa+M7AQR2ShkSRA6qIXcMgn7FmeOSOi4vIj69HWLiEAIr
	kQ/WcH1ydwd6nMh9DF99XDFzojyIS6k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UVxXd2YX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707713;
	b=jqHs0z651PHmp0kEsQkXYoydU4mQajUQ1oSGbpKBhet9fCHQUm7g3JMkQ+gN2JaUtrfE7W
	/UftAT9S8Mtuy+OBnSa+41YByNLNr/PrdzJ3Ouke3+W11E7gvvCaLTsEdwDwUGtXzyMDDa
	PNE+tYi9usqTH8OkCET+eK3hzvL8TS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 092374433A;
	Wed, 17 Jun 2026 14:48:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF3A1F000E9;
	Wed, 17 Jun 2026 14:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707712;
	bh=f+ZFI7Qgbe7xnOZyetZ4L3vI22eJ2l2ckq5hmR8a2XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVxXd2YXwpYsPaBtMxM9HElDwEg9rP0hxcsnpXi1/rBg5I54lAOndY2s1LZcLjtJS
	 a4528TTqCrHARYcSxWzsGnb7j7l7qv68OOZZ5OjgHdSuGw809Zbrn5M+Rhp3nhr2SG
	 H7D9jNT/owCWRE2mxBKG9AikIEbr5Upnf0ULRT8lxTTiNXHE1BZCo5AdpKvN+Q4VhO
	 IooLKTCvvSUzXfYZOTE26gZ6YwLBtDUijfjBwhpOwjMuT3C6F2k/eXXZDzQ9oAmesE
	 KBe74AwM91+YT5ksiBxqUIDm2m1JyIRXCRoOCUKjOBuZnO+qKI1uoz+ecKXQ4m7RsE
	 3P+dlmPi7BVCQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 02/11] mm/damon/sysfs: kobject_del() region and target (error) dirs
Date: Wed, 17 Jun 2026 07:47:56 -0700
Message-ID: <20260617144807.91441-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BA2E940007
X-Rspam-User: 
X-Stat-Signature: z9ujhgud3j5auu4wskhrwn4nw4bqfshg
X-Rspamd-Server: rspam09
X-HE-Tag: 1781707713-395751
X-HE-Meta: U2FsdGVkX1/7aYdrSsculP4ST4k1Of85p91/YkQeQIuAQKyGvyreH2XUYflNCGel61ApcvlvwsQ/v7pTUl5Hu+SVcOOEh7IE6tE9pX4crDK/ui1kqIwDy0rt1h8OfFcqZA5a3Whue0DUPkSabtmrzfTjTQ38hoJB3WzS8vapEvwGtkPqlebpd7R+V+SGV7mxlTST63UJ42HZyvelzIY97HX3x9qCmx1mj76KmkaA6c3OdaAJYFCckNd6wOkN/Br6ilHGxo2CW/saQZhOTqfFj4RltQF7Qaua6BSDMpprEVO6ne27Ar8a5xB66j+qF+L3erbBHPeEaSCVZMxa/+1jPedXmbJkOVMTe1uGPt6qhrM+NpNyHpWgdf4BUpxY+k9lI/y5yyGVvQMTKV1KLvwc2QIfyJg50xZxoacLJZapufHN8AZPSgiuY9UsGDyBZ9fVBz0DfFtWZaNdMXb3HJtS/BbFittH/iSx2ITikhot4KFBOthbzRF7OELsu/kw/pA1COm2JMZMur1V6iPHvO1r6Hny/MvKfBQZ4FKCIG5T/ZFJuGmUYCK72rvFGA5GRRbtXxm/GaLf5wpgpcBnUVX0TkUhjLsSBEufBknF43xclcVDozzZulDOodVWPd4tWhjgSiJC9G9spd6hXGomiPx79E5voQJ490KCAsjR2Frl60DovYfKm72sHHsZCxZDhCl34Nbp7GvcQjvWHCZ4Cr6LGzl8gyNa+c3JDrKQJUUznuQjqLa7efsL5uPEfkm65w9YA/EPIXrQ+OEG6V5CVjsKu6uWE0UppjBxTHBa9DuZrKTM8CZZPqbJYowRtAdjxwzalGrDpKwkvNaQVhWloV+F64iVy1Hls2n3E3/BzTV93uTZgmdT3jsWMPfmBJ7FgE3m0h4UvkFlRvS+LztsGzpbGJEFq5MDv27Jn0gR0tkjcVfdTIqCgrfLZEiVSU1zxD+wglAnNo6zHGCt3MXktnl
 JSB+tDVE
 C9y3qM7OOgg8+y9KUPibC9ZLVqN8ho/PIVZ0PCTHioyOOk72EnGIKSnva+LJ0tUvHr+KdHSo9qptOu+ERVAFt9GjzNFQVhSskHDIBx9YP0Xj6Yflf3d/GorKcUXcMtqpB9FSvKQOywdYebHjM9/1sgaYSx8k0CfJeHiffZ7gG19dhES1T3K4h766iAZ4/kxjCXyA3Hpwom1632z7FXj7xutz8Ra9Pv4mS4V/U/UDKO+GVGRXclml8++nK7BOwGg2UlEoaoPic7cgi9gJI2pYDcU+F1g==
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
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index dba1c67fc188f..3c349f0fe80f0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -107,8 +107,10 @@ static void damon_sysfs_regions_rm_dirs(struct damon_sysfs_regions *regions)
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
@@ -372,13 +374,15 @@ static int damon_sysfs_targets_add_dirs(struct damon_sysfs_targets *targets,
 
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

