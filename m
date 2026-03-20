Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FE110987AF
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 755426B0124; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C3E6B0125; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6692E6B0126; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5F06B0124
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:36:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CC381A0154
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:36:16 +0000 (UTC)
X-FDA: 84566993952.24.AA35EAA
Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3EF0D40013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:36:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=O317TOCR;
	spf=pass (imf27.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HdwGly0+BqBUHkF/IVpHh4nGFQLNRDEsFnAVEweW3Yw=;
	b=uJCWpPesZrRe5gaMPvh2I8bQ8qlisStqH7/j+kJtwe457BFxSTKg2QEmQ9LtSMqVIdQmVy
	WZQKg9b463p9dfbP1BlRSeWzQ2PF5xjWoPqSBS67J3A/qlPIda6ElgRk/KyL2mLuPQCfc9
	ccdMfYQ1vwozivai3pcNkvawt+LG1zk=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=O317TOCR;
	spf=pass (imf27.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.57 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774024574; a=rsa-sha256;
	cv=pass;
	b=n/3cowcWddjvEO3jyGygdCKJE/ebGkFAHxwhgG12bCu7Cy5VSzQpYJfDqWAEtIIGZdsapk
	muL+UloDlaERYlg5S7rzug3Nnf0fWNchLMApP9DP07pgz9yPyiwgGMVctMYyZ0t+6PhndQ
	6iIkHE3OkhK5XaAMxW8y/185kTmUwoE=
ARC-Seal: i=1; a=rsa-sha256; t=1774024564; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=HzAb7DtkmPMMaHFoOtSy1ByOBce8Z2VsonMAgK3g7nAu1gS9o7GrQ9Y/z0xdTbtxrXsr18PpDiLO/NFezHOBw2DZQKExMfZjQztVz5W6d+/JkWrwA20CmYBBjAxhTXYfmFdSbYJ5Rt7Dumh8ozSmc497CFyfTmJJx5QfRj4h184=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774024564; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HdwGly0+BqBUHkF/IVpHh4nGFQLNRDEsFnAVEweW3Yw=; 
	b=RQTJMzmaKNcGEZIM0a0wqaVr0Rt73Z1x7zQ4w6S1YIPk649spcPUtC6azCFKp2LbBuUohC/4ua830oFdYWQ0mmyNrpWUElkd9COVdyrLGvKDq4sUUHqKUhMQwiEezbc3D2PWdxhMGXtaZ19sX373vL2jrldHQGd29jVc52dZWOg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774024564;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=HdwGly0+BqBUHkF/IVpHh4nGFQLNRDEsFnAVEweW3Yw=;
	b=O317TOCR0B+3T99gsNHIJKWes3cGthXqIYy6ZdbnlKhlZlbWf1aaYEk3lgRRV8Jy
	seuTTJJG68epxgzugQRpXwl/8EB56ZmjQRI/xWlVCR+pWjmNviU0yzLCY7EHlpY3CdP
	gxwIScXISBAC46AXC0oC0MoYa1NeI0VuWPnC1T7o=
Received: by mx.zoho.eu with SMTPS id 1774024561416667.7402047367142;
	Fri, 20 Mar 2026 17:36:01 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Fri, 20 Mar 2026 16:35:57 +0000
Message-Id: <20260320163559.178101-1-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 3EF0D40013
X-Rspamd-Server: rspam07
X-Stat-Signature: 6knext1y84xaczgp8es9kzbpwozoiy3q
X-Rspam-User: 
X-HE-Tag: 1774024573-483188
X-HE-Meta: U2FsdGVkX19Uu4wmVkiELzJ2ct7LMUhnzmVw9X3w2CFrY0JVnIEz60f3H5ag5tsCgB41mtT9IjujnhzpbwSMjcb8YAsSOs4WcTvrzAM4c+Gz+bfABPYJFw2PLOodeGjKpb4NgQjOvKJ336hQnjb5sGakXuwLmv+RcW/prnPnlrh9EoVnkwBw0eHI3IQVB+vukW4GvyTEU3Itv+EMYSwCFmO+t4Rfp1I0x+pojHuftNwiB9FpmTVOzTnSKohXQ7DIoUDMslWdAosObIl7X/uWqXZqgPrB2/t1l+7hYEA9kIcyYhwIzJdIIm5OrPuwR3F4n9B2vYRibltiyIcyi7tuDwsn3tw2v4QNPKqLZnJ4pGBE9Ww8xwElHNI161Be5ds5TyQ+uUSG7y+RBQpgr3gO96DlrB9qXbxXqh6oK8O6xIy1Nn3c3oaASzoR6m7D/1/K4udXbewjnU+2n2Y7Lh+VDKfa683KhWEGk/kUJ4UMq56BDM2IwiF/UnyUQ+B/5QThiZjLkKDn7qsU7nlf5WdtYsDwTsr8mMeBX7C5esA9ZO+Ml32x8Ym15F/e4UQ3SRajpp4YRGlXTFHwEpXe3jNCYi8oSmkQw2AhDyZvCjdzwMhpi7VgqifOmg0IzkDKiZ2/gcxE0DP0X4RdUE2aPe4vb9WgrtZGD8fYTgCoS79l+JWjEeuemQxNcZiVXIUWvAk5SJHbx4sjSCUZup8bFEKY7x+WIIO/V0TrUtGcW8QSdxJp2aceVSDebnAb3GbmaEGa8EA/G3OibphmjsazGTwYZha4hKAZ33scrMrwQ1NXk27DtXlT/Ai+MrizGPpVflqOUjS8knIeqWPkeEW0EB37UHlHgzUOjgrL6h41Ygg9VM65VJ6FDGS/8Os1f8COBWYVinKwgr2atZgiBv2fsXPCoKzI5hxnkDbLBnQUO4WhWLyHTBWJtb8VH/EIcfGamMNCDpwo7loeSKBU2B6SiVO
 VdB//G25
 cdtWSRq/10FJyJ4b4Xq9948qQZ4zag92yKTVeT5pv9cglnb76k/xmF3qlaG27Dj833NMkTZATECQwAY8YEHnP74bOJAM6i0snvMbP1Id8kDDRKFAYFy0gMyEQb3JbSmOVxtdWHG1WBdlRpzWAN/wYT3IRydAtv9KO7SowOZI5+zXyUFRmF9A9SmDozJYQmcpvnsRJ59q3cAO9DK0X5X0JnXzC/2DcbN1fyQnKktjeQ21UTwP0oNhKQc8BnTz91qCWNpuf9VSuDYi/misQU4nRRY4N2o8H38WDEQQaqedvWUOz3JXvgSZILUkQPkvXyv+DIWhM2FGBhtDJJcXQP6K0fXIwogTDmMTvZAI9O7D/oWpCthXB8epu4QHcwlx+EK6aluy8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_sysfs_new_test_ctx() fails in damon_sysfs_commit_input(),
param_ctx is leaked because the early return skips the cleanup at the
out label. Destroy param_ctx before returning.

Fixes: f0c5118ebb0e ("mm/damon/sysfs: catch commit test ctx alloc failure")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Josh Law <objecting@objecting.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 576d1ddd736b..b573b9d60784 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1524,8 +1524,10 @@ static int damon_sysfs_commit_input(void *data)
 	if (IS_ERR(param_ctx))
 		return PTR_ERR(param_ctx);
 	test_ctx = damon_sysfs_new_test_ctx(kdamond->damon_ctx);
-	if (!test_ctx)
+	if (!test_ctx) {
+		damon_destroy_ctx(param_ctx);
 		return -ENOMEM;
+	}
 	err = damon_commit_ctx(test_ctx, param_ctx);
 	if (err)
 		goto out;
-- 
2.34.1


