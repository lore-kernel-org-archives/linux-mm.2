Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93958E7AD73
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 23:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 088BB6B008C; Thu, 25 Dec 2025 18:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BA96B0092; Thu, 25 Dec 2025 18:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98C76B0093; Thu, 25 Dec 2025 18:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAFD76B008C
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 18:21:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A16E01A018C
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:41 +0000 (UTC)
X-FDA: 84259567602.13.10ABC40
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id F1302A0002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:21:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vbIrljY9;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766704900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNWA2wy5x9qmESizAoWxNjF5HTjl76WyG9bV89v6wkc=;
	b=2txhpSI2FWFH69b5moXNS/JVx2Gw7r+pkVhhJ3A0qlXzY8EXp30sZ9JoHXTh83V/dmvyCN
	cgoU5W8Yt8XvoKirdnSrQPHi3IZx5j+bsrAlUeHbbEwA9USt355RU1Z56v+LcVVdomQPrE
	q+zDm0SwB0rynBJqiG6FpE8+0vD0Zo0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vbIrljY9;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766704900; a=rsa-sha256;
	cv=none;
	b=zyPfsi8vwLg+lmYcbVYjcguli64HXUc7rIkemY90JFEz9rrSqk7HWThH4cXq8pRlBdHR6h
	asVsqLmSmRWEd5XMVmSytispmEBE5xYBGoSLy8R6QxgAYCLH+YYyUv/oIb1i9xoFG2ivja
	BwJUhGhxtZJMRhzFHAdL6V44B2BHRL8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766704898;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HNWA2wy5x9qmESizAoWxNjF5HTjl76WyG9bV89v6wkc=;
	b=vbIrljY9Mm8NiHjnoyWxvDlzPBU2XDS3DgZXbUz8CnkO/r1IXynRdZ8/R1sxe1r4/n2nhn
	grLSA4DBmRv8k2SMke7G7nnY2fKRze3XDs+LQhTS4HCHZYnjRzuCWi6jsah7qfHMH6W3nv
	sqCjwirvPFv+S3Obsz/ngB7fVRGsvVw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] memcg: mem_cgroup_get_from_ino() returns NULL on error
Date: Thu, 25 Dec 2025 15:21:11 -0800
Message-ID: <20251225232116.294540-4-shakeel.butt@linux.dev>
In-Reply-To: <20251225232116.294540-1-shakeel.butt@linux.dev>
References: <20251225232116.294540-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: no8w3on67f941n6eskgqegqi8o4i6x9a
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F1302A0002
X-HE-Tag: 1766704899-761391
X-HE-Meta: U2FsdGVkX1+acLTMDFkOm3ORwp3Ma+D9mpiUggXiXJiqCNxJwsbB0TKX2hdoAstBpwwgRiBzwYsWTKK7IFBv0/FoGVIelKtwUxjPvwfHXjEhidHa0wL3e5D7GKtHkRZMFOk5EzilsxREoqLx/WhAtWk+uZiGRmjxyof8v8fFSUJg5c2rTsQVByrRzvCSpnyb4WtyvkIbTNLB2If9DlQMRN/jx2TLAoWUz2itOmlHYsIRLevXQ08Ga27VAj87gVTD33tD93zedNumtfr94I2d6IDbGhS6rIWd+yp5VqRfHxEyxaxNZf4CruxrGKvngxkUBNAfxSWHZUSi/q03x47LyQ4Z6oVuov7qSSAFgGuY1bsR4ANRVXcnomfXs91Xc2tf1MqR+yqni0lm/IX9nS3+ulgVFoL3mNCHzpF4fosW7s+U8WiSPMMCeODLRIdBwCADWnqQsmZsqIh/bzRizkJk8qrAaCfb2ptIjGKT30TZkoqhM8j/9THpqLuF1HwS4+0+iwDzTMG5sHtydzsOMv3OXU7kXlCE5mL2QEQJK221TrS+MlqBGK3Y1df9Oq6gnt4a9JD5JFcfYCWQKzcvxI9WvKYIN1mdVloiiwBJ+qzfzyQRj2CkjCqtxl/goth2T2qo5yVA7xPRsCKrJb3KJiSYvoBNJ0MBg9zd3DzHeDcixAva9cJ1M8odfRt9ynguOIPQKmyH1/BPmuU7mqm4uAb58kTDl2KNMMawewCmYgXS5lLgJoSRTsnL3OkZT3iaxfuhtyydcLbf3Sy4EUIiMXmhwRa2n2ReGIzwqvuBX1XRVzy4i8PVk/CvKlXajsS4+1OR+FiN2DS1McKztPn1SAZOpLu448qONUDobKKPlmuemTNeXIN70uofS3fs1pICdsqIpaYSLCot+G5TIK28bBRav6nCva0ErduQycuavo8GNoqWaKHetuefqAJTDwcAvc/xtZhRJ3RofpHUtbmCSZM
 aZGvJSJw
 gvwSuhbvLm396RPXM519LUeLy3RPDDU30GtteAgQlMP3fQBJ5sV9HfKR4TGNBW8/vhnKFZ0BFPZRowl9lCibqreWXBnfT558vHfBo+0zEQIQPcm+b7NHpUT+cgcgXt8vPH1JyUWVcHLiCfjifOU3RAbfsMQdcEtbsOk+fN7jPwtMb7K/0/6r0ESFIXQQVwb0qqMgTnO2XOu/mN3sIVgYcg81odiIqrRDPYdpYtkvIi1SHikclU2vswSY+OQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Change mem_cgroup_get_from_ino() to return NULL on error instead of
ERR_PTR values. This simplifies the API: NULL indicates failure, and a
valid pointer indicates success with a CSS reference held that the
caller must release via mem_cgroup_put().

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/memcontrol.c     | 6 ++----
 mm/shrinker_debug.c | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e85816960e38..92beb74482fa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3624,17 +3624,15 @@ struct mem_cgroup *mem_cgroup_get_from_ino(unsigned long ino)
 {
 	struct cgroup *cgrp;
 	struct cgroup_subsys_state *css;
-	struct mem_cgroup *memcg;
+	struct mem_cgroup *memcg = NULL;
 
 	cgrp = cgroup_get_from_id(ino);
 	if (IS_ERR(cgrp))
-		return ERR_CAST(cgrp);
+		return NULL;
 
 	css = cgroup_get_e_css(cgrp, &memory_cgrp_subsys);
 	if (css)
 		memcg = container_of(css, struct mem_cgroup, css);
-	else
-		memcg = ERR_PTR(-ENOENT);
 
 	cgroup_put(cgrp);
 
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index 20eaee3e97f7..8aaeb8f5c3af 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -130,7 +130,7 @@ static ssize_t shrinker_debugfs_scan_write(struct file *file,
 
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
 		memcg = mem_cgroup_get_from_ino(ino);
-		if (!memcg || IS_ERR(memcg))
+		if (!memcg)
 			return -ENOENT;
 
 		if (!mem_cgroup_online(memcg)) {
-- 
2.47.3


