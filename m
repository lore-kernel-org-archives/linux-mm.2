Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E678C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4FA6B009B; Mon,  7 Sep 2026 13:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364986B009E; Mon,  7 Sep 2026 13:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 254AA6B009F; Mon,  7 Sep 2026 13:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E28E46B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:12:29 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78DD012024C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:29 +0000 (UTC)
X-FDA: 85187610018.04.F78F3CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E5C5A40002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CA9dADgt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788801147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LMfK+vJvFqvjmpgUK8C/JqVd+cTrrKRqz+a3Phr1zw=;
	b=G+piAbXxljiDcUTStdxhI4Hm5Zk+eAd+GQEQScKpZOJ2oEjEiQ/OjIxFGdJ2Imtg7QxmuZ
	dokAAZddFzjIuIYafQXaPPVTGu/ILFOKorSkCRWzLIi4CDdiOSDt7unG2xDs37i565tyq6
	+T4Kpr0lcYwGKnD5nzHfBcyakzHhDK0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CA9dADgt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788801147;
	b=7iZw8BrR0s4cwOX3IN2dyFfRNraxOb7ra98eG21U5OAw5HOccPqpnf8OZ2hgyYeObqz0xI
	DOBDukkXXJ+W4jul3VxU3wh7cKjsD+Sv5dhod7DZOoklGuW40sP+KnKKK23OURY3O3juS8
	RLVTS6BR5GgRdpFoDmyLzDDXN23x26s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 73E58601FB;
	Mon,  7 Sep 2026 17:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063A91F00ACA;
	Mon,  7 Sep 2026 17:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788801147;
	bh=0LMfK+vJvFqvjmpgUK8C/JqVd+cTrrKRqz+a3Phr1zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CA9dADgtK6IS30SWaNAkNxa55qZYJ4+mHnCLcym4xvMm/SrQ0hSfu5yvB0XQPcayH
	 yqMERbE98Vd5iJ0RRCudq+w2WC0al1HUlFrZ26A4YZHPFqN3A8qFRYyIeE3Die/SFV
	 K1RMICJPB+GHJKu22h8NhLdABZRVuaOwOuHEoYTe6w6Rsha/rFxXj/7P9uhyKhHaCS
	 fuGb/jxvgE+A1vO8R0jJ2VEUppklpJ01IgrrBjfkSw79R+FyKU/1WBItixY9EYH4ML
	 9VCtfgudJWNc2tydeFhQFjSyLC1mfFr+F8dzBa+/A665w1x19eUOJwMTAAsnsWTnVa
	 sxI89uKyqAVEw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 5/7] mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
Date: Mon,  7 Sep 2026 10:12:14 -0700
Message-ID: <20260907171218.101430-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907171218.101430-1-sj@kernel.org>
References: <20260907171218.101430-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: xhqgbc1s5g5ikb1si5qjtg3t81txzq1z
X-Rspamd-Queue-Id: E5C5A40002
X-HE-Tag: 1788801147-850098
X-HE-Meta: U2FsdGVkX1+rhyxtt/cokMrskeEp6cLqP9fjEDzUclbrZtLww7aCX90q1hg8YgiTvc9E3El8L/nbE1y2z2H2EuFn5nAney7U9/xTAj+mbX6HEsTCjBZ1JawV/nJy8+3XrquHdIFL73dObPC0EHpAK2Hg4UlijStuuNHS9WDOHnRRcec3Yul3o6Ti+UnUfI53qubFq6BGjPSnflCk3M73BaDPwwW2xScHY3HfYaIXaCmatyWCkwF1OEScjECfztRAGZwlOvzbpefelkXl7oH56AXrU/Wl5QMprs2+/beMPBdsjK0YKJYl3/jyicUx49KLXCHDGhOVFKy76S0yU29LktZMNpV9UP/zl6ah3DIP+GZXGWXN/5TpsiHiOyFsHpD9VCmJRK4toC5Efcqwlr3Bex5a2h1oPaHPnlu1AjXMhgs0np2Gsn2eakaBEGmruyUZGScfvWBEvMHBXxbQslsrN51YVinIhrYDtk7n1jMP2vHNfVCjCIQSAMG7KW7ZOJY3WuQTe0tLrlFrRgtNaZdwaqWjIHUgFO8eteICrC3+1QhbsEoHU8v02h5Zyd/2y37x5HxETF7yw0sqQqPFAVY5C0KjoWBcqgnRzAg49zkRhyc4n45qbx4DO1MAyJNZnJElN+lELfysMupvHG04ObKQWTnPKF43SmuO3ubbfA7B9qkvHgM8orNum6DvL8IMvChc6XoCWA/rNkZf7b3ZkIkSjNSqY/RkxnEAzuoDeVxlk8bI49aBoTUHphbArehS/wUZW+Bn/NcRvP1TwVJiBHipMXQRxKvgtkaOOxcaCC1Y8Di04+eOGnOUmZd6QOf4fYr0jzGyIjrcxjfVKlPwkuvQRl3Hfg+4yIkSe+JrSiaJYS8M91Gti5DhMdBmm5EpnlbhMJbxVqK00/Ujx4jrKONEv8PJuAq/9pTuCo6nSpoXFp2n9qcbHUv9AM5CxQ2yi4saMq0SGBmIK/QSyQRMyFK
 z1mbtFR/
 lhR8KKrjWPblnzzCVx78ZJBc6jzhhmZaTTstALUfMMq0O2Ze81HneXtzmlEWA6HdynKr+Bz5M+kxcAyLVi97IKMMYTR+F3Nuim9t8/jOcziOQsdyJS2R2R23IUOkX2dOQvgvP8Q6o5Z3n9+k16GXYbwkoBWHKQ4hNPQ4A1Ee8XVKQDyOzKp0OWoz7O9oLI4PGiijOHGGhAJ5MZuvO72KHffaThbm6iP0sJx0zqgI3z0Y4WUAciUjsYcfD2IUXkZW+KA2R4eJm3S3Sogu68mHAGFFOdw==
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
index 4d9147d2a269e..d9dd4ee0442c7 100644
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
+			filter->range_min = sysfs_filter->range_min;
+			filter->range_max = sysfs_filter->range_max;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

