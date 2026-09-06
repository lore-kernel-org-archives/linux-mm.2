Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB78AC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A90C6B008C; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EA26B0095; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3460F6B0098; Sun,  6 Sep 2026 17:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 015AD6B008C
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7BA3C120604
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:25 +0000 (UTC)
X-FDA: 85184568210.30.AA6D82D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DDC3F80005
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=azX6Hu6+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfRQdDvn8Y4M2LTyexgG1B+ohuNKkP22FbeL73FEnAc=;
	b=iXAv9+nNt8iUCa4mKkeY3h3m10rIu7IVhMkCns5OvNVCptpBzQoFY4biCtCJ4CToh8+0LV
	iXa5UHK588gFoyQA1PlutSPsx/anRsu+mtagmkIJ2tOnsuBf1bqSvuPxvNgRwX/EpAz8Ed
	b984Y3889eKNADhoT1cNh1CwQKUeWyc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=azX6Hu6+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728723;
	b=GFldjNegmjqCOwd/IRPZ8NPrjIo//ohWH9sIGS5blSLPC8HLA16eTA9kKmW9nt7SfLQLOR
	Dc8FBOkhY26g5P+dGLxKfr8WF/+2CQwr/mz70w8SlL1bI1LEGz4eg5YhuvoHRflpQKNtk7
	8QdPc2T4dUf3kfrN1XZvqRoHlK3BNdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3B1E54451D;
	Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFDF1F00A3F;
	Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728723;
	bh=KfRQdDvn8Y4M2LTyexgG1B+ohuNKkP22FbeL73FEnAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azX6Hu6+AM7WikMiNEgis2NfbDfVi+nNwMk8uq1WQ5j59Gx41P6zAzVDFJmKB2R9b
	 VITdlxluRE7NjpziLnevoqTrfM9aglvtrXBemBnJoRsAh6zTDoANecthhYuhoHx07t
	 TJDMYtAU/02VVKhbbAQrd0kv2q1Y7rT32uUVKIhFBKJQbKF3y7vSB9W71ppE3osmCQ
	 ZyWuQq+EzTBOtwlc/9Vt0w+vKarkgxwDGHo/tSV1OnOGpm9tGDXZkgK6K7u58qPVuc
	 6OIG1Nr2x/tfZMCDgG5Dc8PZCc58D2dnF4EFMMVPjXzVVe20AGnkRlb+b6CGnWkTux
	 4hpkr2JL3e64A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/6] mm/damon/sysfs-schemes: setup range_{min,max} for probe_hits_wsum filter
Date: Sun,  6 Sep 2026 14:05:10 -0700
Message-ID: <20260906210513.106895-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906210513.106895-1-sj@kernel.org>
References: <20260906210513.106895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tseanaabocjstgwfzi3ps7c1zxpo8i4g
X-Rspamd-Queue-Id: DDC3F80005
X-HE-Tag: 1788728723-326892
X-HE-Meta: U2FsdGVkX1/UVkrzp2voJ49RMBFh55E+V2MMAFEvFJy91dnIDaNt6avw0pyF44B9T755llbPCyWr9l538h3fC18lQ8nNBuL/0wFGHHMSyvJ+HUwRoUikfbuNYD8WQKFS+5QmMYA6fGDyZuodhM2Ofmlat+A5oJpqP246KilXyi8x90tPakAh4KcEGD2L/ozvXAGSc7+eqzKgQGZemVA7GTSnoWAh9fuyyQ4LcujQ6OfFcInAvYMmGKMForqfHDFYkUkUEmN79smPRsfXeVA/2WYN3bAzZhNMqKdbE0SOSITE937xB6XdZw6x5XZ/q+RWApL0RC/zaSa284qonu2SIfUyf8tUHM90H6+N88SyddlPc1SZ9KZ/9Ag4Ikrhuy82ljZXkO+OEZI0Rdntk76hZzYAAq0+XiD7TNPJGx1HUHxyCHEtv12WGIEKpv3RIryvfR+Gwkxqfy4ZxjVa2sqF2ngYabZwvza3KjaTD7uSsgkirecffrmLsZJoGL8I9FJaY8r88cVWYrE8dMFXdgq/EyFwddlMexIuvg5Dyzds76/bZ+eCjoVwzVjHJL380vh5/6E9nSVuIXxJp7v0Fp+wehjW702EZm5rNmI6sKQSos/DbCQcITB07LyfQlNArPypftfHrb7QLXfu2/13sHQG/MPjdDsUEO6/DK+H+SOyd5INoYhaUlukxe1Tl9vQWNphZ8SP9EWDloBK3QTEpejAJ0IHNhsfk/WqqP8k85S23w4KHKYlBNalUTTbanLBR5e89yNlciBZ1Xoriq5Lj4wiRrbI65c1dFmEnUhrYj60CD26yWGJG6xjIK5mMfw/g1gZzb5XFhbJLu4BJ+B/JvQfiQbEvedioXcHuqMT/n+LnPLeLlKPtKYr1GYNv+VJ08J4JkOhHlXVQAhbgcEuBNPLwj43beM4cOJB5k6lUeRaSrJkR0/FDSfbpnVOI1kr8onzoAOD1kA8B6MfSxR2Jzs
 mLJOtfE+
 hZ7VluEdi2LRwaWtts5sVSJGwRNZuVRNKFXz7SyDGtagfM3HHn1g5TkgMJU86GFHn2blfm5Gsk6eCuRNb47u1Qfq3ZwxmUf1Lm3X9chfd2L6ppkptKd3ucf32Qr0rJ+ZATNyZ+KRV0ADZ8v9PJK8U6SW4SC4czSZRpbSBfLCihLA+aMPFFZ/1IgXduaC6DbQHZF9a0aGYfx5wd3qsJ9y2Md5/shwyBuOEmKNvNIZA0sEwTBG3cv2UApPSdwBu8piR/vkmfdL6sjDwVyYP8+0PbdOwhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to support probe_hits_wsum input.  Also
update sysfs input based scheme build logic to setup the min/max probe
hits weighted sum range as user provided.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 4d9147d2a269e..e297a20c0af03 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -589,7 +589,10 @@ damos_sysfs_filter_type_names[] = {
 		.type = DAMOS_FILTER_TYPE_TARGET,
 		.name = "target",
 	},
-
+	{
+		.type = DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
+		.name = "probe_hits_wsum",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
@@ -2844,6 +2847,14 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 			}
 			filter->sz_range.min = sysfs_filter->range_min;
 			filter->sz_range.max = sysfs_filter->range_max;
+		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
+			if (sysfs_filter->range_min >
+					sysfs_filter->range_max) {
+				damos_destroy_filter(filter);
+				return -EINVAL;
+			}
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

