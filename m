Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E469DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868336B00E1; Tue, 30 Jun 2026 10:17:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F16C6B00E2; Tue, 30 Jun 2026 10:17:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E15F6B00E3; Tue, 30 Jun 2026 10:17:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C73E6B00E1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:56 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99BA48EB4C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:55 +0000 (UTC)
X-FDA: 84936782910.28.8A3A76F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id F173C100016
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fz/LToBM";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829074;
	b=vzhj7hXFxhiQ7yRbJb9oIYww5FXi8w3rckafx9oH3E8pDVRvz+V3FKOsrZDfoEjeUU/r40
	gbfx/vyMg3/s3rfZQETiKIMe80YcoJzEdxbw7lYTJPUta3bvbz4y3mzl5gVhmeVlaRCYIt
	V6oDlHwjABppB5mKMyWbW9oZaHvI2Lc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1jHOfEbKPidZLAY+bFapF4i2vITVSQIXVAPEhh+0hhg=;
	b=U8fN3bLMj3LTB8XjgIZ1WU8yQQtWaLFmU6OV3YKmgi7mT/w3xcvCBATvTiRW2qgHKXDf5l
	2R1QdC1tSkvJ2WQLWJJkxLFDryajaJjOGUA1L7294rSjIdqr9mmmyzJLqyb9snrJUy2j6c
	l8yRt5Y1BkE2Gw1mkgfa+J/jEdJxWwU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fz/LToBM";
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 94D86601ED;
	Tue, 30 Jun 2026 14:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536D31F00A3A;
	Tue, 30 Jun 2026 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829073;
	bh=1jHOfEbKPidZLAY+bFapF4i2vITVSQIXVAPEhh+0hhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fz/LToBMBiIU0dTtYMuOu1omoRZUmMba6sk3xwiWQ+2FlTbc4NT/i6KAp+qJezenZ
	 KzCA11SA1VTDR8nwaETWW88mX9V86UuvFnbIXHY6vt+FPrNntkTRkPU7xbG5caEFNI
	 mgrdtFJf96a0cWhPaZrhVUtCUEKpiFMh0VMX7Fv8EgoVZmb0fVY1s12b72lDc7SNFF
	 7jsrxtiunnjIscevZfDMmqrhom7j1ceHahl8gf4aYGrKAsCaIDbAvbejzza7P/ESBI
	 N2iCEPXfoVbplhTSfbUHX8L65L1w5CgCleHGC20NE+NWC3GaF0ZMdqQr9R6oJgTZg4
	 FE9dt4tMtLgKg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 11/11] mm/damon/sysfs: fix typos in probe_{add,rm}_dirs: s/attr/probe/
Date: Tue, 30 Jun 2026 07:17:25 -0700
Message-ID: <20260630141726.92246-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F173C100016
X-Stat-Signature: pogjjdy8yjtt9fswxqwhq496whccthmj
X-HE-Tag: 1782829073-796871
X-HE-Meta: U2FsdGVkX1/jLwdjb2pJ76txC0JTnajeA4qGgIV4YIek7jmdkceLQXvm8VsgTv+QPqD6DWaOtKfQWnCdOweSuNeOuclHOA4ZeyIxZl9A04WC45X3Oobfw4l9jlLfrSh5zZSvBSaztceRgsmb+2J+dhb5eBCuS2YElV/gy+wRE8RYlmGctPn6aoYTWW1Ttqc+bJoBGOTLZ32bPwfOQuCi8VDPengF08bxqm65snm1tFwhIlcGJIfyih+TjdDrHoFLZyHMC/pyY+T1NERM9ROYYjCk00HeFE2S9q/pYesMNMfsD6uhaySADN0UgwaGnBTk/5XcB1o8XKLawWgyXQIWXZsT86tXhUP6XSorE+v9+kVX9Fjs5VWujaOQmg82ziOUzU1LoTouWgCJDxPW1K19kdn+vzkqsK2Qo2RCb/T3ZGGvBK37VjLffoLtqdnUnwwlVZCY8VAlvLeuZ4j832xBDtOI4JAc0jTHLVZiYbNZa5NxWCy6nGu7qKXa7KQ7xTJxcD2rlmhRtL4kqNNBU3XVkliP2TiAnLItC/JTmJ5bvUp/b5f9pql2H0gGlc26QR+O4xqrcwk8law87UFQCptXM6ehNMubTvbqHk2xZzP5TyHMVLB1PCszZ/1LFWVjDPtEkPa1vxl1slQ1GOe1cX4LYMnOw22OiU51+SNpZ67SHv5svuxizY/aGEi8xXuMpFij4x4vZi35FAEqkwg2mrKrf1gDaeq1qDpdoPMvWFIMZp1/ACpxNR2gI6fz/4oY8LoW748IFxQl2OXtuy28XaUAUvgr0Ni0AupY1/diVkQtmJLIKGVTpksy6ikrRY10I/xnW6jAsGUZHPSUlk4Ty6RZGZ5Wmdt658FvfoF1OiLzu3AokslwKNx/zhXjYPL1uKvmv+1n67jb7pU52ZLxUc7SO62fOoWha0vzhnJ0AXqM96CavJfMd4C7P14bGK6JYPrvBrp32ykYXmi6CoJmg1k
 5aiSj//h
 vud5cLzjA/62ihzAosrMvNb3UtqWW0za/rJrVt4ZB+Wa8Xr4TawBbjxP8CEKa8a/ruWIYnVKs/vr6PvKPKPiXRew2QV2txIwfQjTzceiuBAlcixWkP99VqmZb1QY/e92PEV+2LccAkwrLv81UcBZh9HhOgBFr0fRzr5zzko5j1QRxHPAyUTbnu0CW/TXv1kPeHaanu+tyhWGccVW3BUfSLIH0CqQVX7TMbmEv7t66P1MAx/RK5Qk7P7sX6AjcskDkcA1nyzGPWrtapagwDXx/a/4HwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_probe_{add,rm}_dirs names a variable for damon_sysf_probe
as 'attr'.  Probably a trivial copy-pasta error, but it makes the code
not pleasant to read.  Fix those.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5b2ae2fe948fa..6710b6d019bf5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1073,7 +1073,7 @@ static struct damon_sysfs_probe *damon_sysfs_probe_alloc(void)
 	return kzalloc_obj(struct damon_sysfs_probe);
 }
 
-static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
+static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *probe)
 {
 	struct damon_sysfs_filters *filters;
 	int err;
@@ -1081,22 +1081,22 @@ static int damon_sysfs_probe_add_dirs(struct damon_sysfs_probe *attr)
 	filters = damon_sysfs_filters_alloc();
 	if (!filters)
 		return -ENOMEM;
-	attr->filters = filters;
+	probe->filters = filters;
 
 	err = kobject_init_and_add(&filters->kobj, &damon_sysfs_filters_ktype,
-			&attr->kobj, "filters");
+			&probe->kobj, "filters");
 	if (err) {
 		kobject_put(&filters->kobj);
-		attr->filters = NULL;
+		probe->filters = NULL;
 	}
 	return err;
 }
 
-static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *attr)
+static void damon_sysfs_probe_rm_dirs(struct damon_sysfs_probe *probe)
 {
-	if (attr->filters) {
-		damon_sysfs_filters_rm_dirs(attr->filters);
-		kobject_put(&attr->filters->kobj);
+	if (probe->filters) {
+		damon_sysfs_filters_rm_dirs(probe->filters);
+		kobject_put(&probe->filters->kobj);
 	}
 }
 
-- 
2.47.3

