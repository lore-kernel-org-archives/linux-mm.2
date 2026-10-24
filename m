Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3F9606A33A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LACHCK6O
Received: by kanga.kvack.org (Postfix)
	id 1EF6A6B05B3; Sat, 24 Oct 2026 15:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158356B05B5; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D8C6B05B5; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B44726B05B3
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:34:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33C80C041F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:02 +0000 (UTC)
X-FDA: 85358520324.03.DCA5F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97108C0003
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:34:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LACHCK6O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792870440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aV53s/thMev0qSzH+ayYeyKX09O6kEW4ly1bV0/xJfs=;
	b=LuoWfy6Xoyze8w75hL3nGLhB39jyVpuJaTd18RuUtOQn7vs5No60ueGK3qko93k74wMUfI
	Q9Rw/Kyl+93a0C6IBAxsvI7DbbArkNRrEmxcM0XD8rIvZTF6vzgqs5pN/WxhbE30MOgBVH
	MZ5mLmyqvYeoc7PMncjdj7e/J7mY+pY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LACHCK6O;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792870440;
	b=jdffCdQbbiB1fcqTeAuLpqnAj6luckayPbqrCD+2quOt47mdlQLMwzN2xv5hPc6tSUTJhK
	wQgEvF15pQ26b/3zq1pFUMSwcWo9o8XndIOPKa8ZIMbPxDSLM7gD9FsNVbt8ejuIJuUB+v
	lAclyCza4ndgymxoq/zEkb0daNXt4+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8633443F12;
	Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A38F1F01829;
	Sat, 24 Oct 2026 19:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792870439;
	bh=aV53s/thMev0qSzH+ayYeyKX09O6kEW4ly1bV0/xJfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LACHCK6OV3GbL6mZehTtgLpGXlnvq6Vujkxhv60FGXqZ44vgROHr+18efgaVrhvXz
	 ikQIh9QIdEGsXohV5PxI8O8jBZtfla/Covtfq35X4XIGQh10dsU1F34v02eqQCqTLH
	 X3xIN+uX5nio0NBrq1B+/ku+3PGU8of3crlz90OuqzPJYkjf90H6bYnAC5ASKWwV6a
	 kX45GCY+jj5Gy3huVbQRWe1CUxK4Ca/ShnSvPYiqQZp27/5kJkh92IJdPlosM8RSec
	 R8uz0NwGH+C5AZo0cdk2fkYD9zSdWDCK8X426JiGwUlu2CAUyNfsB5Pv0nLt1ZDGF3
	 o2yECMtxEYyLQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/3] mm/damon/sysfs-schemes: hold damon_sysfs_lock in target_metric_store()
Date: Sat, 24 Oct 2026 12:33:47 -0700
Message-ID: <20261024193351.87130-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024193351.87130-1-sj@kernel.org>
References: <20261024193351.87130-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 97108C0003
X-Stat-Signature: 36ouwyckuc8yr6yp1icdpeqbe3ano1ja
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792870440-371698
X-HE-Meta: U2FsdGVkX1+xXWv/MTJlJumhxd0GSoXaEkhYwIdogxuquqIxKizclXCdpAaa0YzxoWq6+qIP5aPlWTebAyhxT/rcplBM/0OKtehyJfQIa0NJpvGeolJ2rprby9T+/z9i9jiqrOvM6+mTKl7sRgkvzQT5KO0tdlbMS7vuqC/HWxGXDdBAyOEVHdXm1mnfGVqx038ELtLnZ3km0wNJ69YYXJBmP6xqqySzyptWfIDFWFUD9U+eBlHkEAuZRTDWnBULFrOfUhVqx0X2mjnHm0LokwGCM/TLZ6wLflnmBxbp3eWuLK7HWpLk4x+W22MQCgbIMSE0WkOly61rcTJE563JaQEjFEskBUEGlTNMlx7780X8iuWDh4YKqmDPicnsqaJjwZo0ZIaYkJaVmRPOSdApltNCNo+aEWvnLm8+KcTuE0rv4Zro8T78nlaz3XtgMiFttZe8BDpgD38yvEyRw58Eit1pcaHPKmaBZv2O7Td7nlCfzSPMuupnPxVacl5ef/0zK2XqK7i9AH8Mujfrbb6yAnWvdNrCuW0A+LSDxbo3GTXYzPf/RIF1NTeMOfqAavCnhnig/x2vyHIsYxJAC0zxrVlgxMBO/tMblZWOohYG5LYMmynT/8XAcKcLDzkbbsOsTJ+81CD5xCP9bEZNWVXzP4Ev9Ds6gWjJU7pQekFxUmG/2rCbQhduJB0ib1pkwwfFA1Jx9SllGQ29cn3ZmhWt8dT6qVec3K1NQ4Pja2c8n4ci7FLJkVQCS0E4xCxfw95sOb0wJpLmsHnw6IXYajlIop9lYE464VErvOnhfBZ067XROztkD715RbMlXVIUjXQLMXcuqs8ayc7faKH4WrAyOhAWpHuN/wMpGCq0PrygppWDOxQr4T455OOzX+pzLvo6pgZjslCixaA3EOOs36go3j2NLZsBJTmMrkPA3UPA9A29cC3d8jctFVsaRqhcaZY80ldbB+/IrNqMjZGG2co
 H3kTy+V9
 dLJvN+he/Kg/Uo0H52nsm5juYTwM++Sp23OoVAuwcwoeoegHwxQUSYX1vFPti0zaZGa01lmAOFQfVUBryPMM2ONi8gjA7DG05DkofDTQVf+XR17rdgRin3Vuk5OM4/xL6enoRvhDx62dzU+cbHt95rNBZVIZQHz3dmCaPG6fmXCGMIbPaNmPZwmifEmv2uskpPfngwCgIoXexmpkQ+SyqWJMNNgu73k5Orn77wvWqQ0YodtR9kW/OLRvPpRMS/1kQkLs/fymObOszTQWgYAAcLBvXkMdQ4LXCk9U8HeTR5umuZbwOIzTzZghV61dYoncU/Ic9QXd+Pmn9KyiRhYxmDsG3vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_add_quota_score() reads damos_sysfs_quota_goal->metric
twice, once to set damos_quota_goal->metric to the value, and once again
to set the metric-dependent damos_quota_goal unions based on the value.

target_metrics_score() can update damos_sysfs_quota_goal->metric between
the two reads.  This time-of-check to time-of-use (toctou) race can make
the union fields incorrectly set.  The incorrect damos_quota_goal will
be passed to the core layer and make DAMOS incorrectly behave.

Users could reproduce the race by writing a new value to the
target_metric sysfs file while DAMON is starting, or online parameters
update is ongoing.  The issue will only rarely happen in the real use
cases.  It requires sysfs write permission.  The race window is short.
Sane users wouldn't do such writes while DAMON enablement and/or online
parameters update is ongoing.

The user impact is not very critical.  The race is not easy to
unintentionally trigger.  No leak or crash happens.  Nonetheless, DAMOS
could be unexpectedly more or less aggressive and does not achieve the
auto-tune goal.  Because of the nature of races, investigating will be
difficult.  Users can control the impact from unexpected aggressiveness
using additional quotas and resolve the issue in runtime by
re-installing the quota goal, though.

Avoid the race by protecting damos_sysfs_quota_goal->metric write in
target_metric_store() with damon_sysfs_lock.  Because
damon_sysfs_add_quota_score() is called while holding the same lock, the
race is removed.

The issue was discovered as a part of a bug report [1] from Sashiko,
which is partially outdated.  In more detail, the Sashiko report [1] was
mainly for an outdated bug [2].  But it was also mentioning the issue of
this patch as a similar class bug.

[1] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
[2] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Fixes: 85fcf0ffc460 ("mm/damon/sysfs-schemes: connect damos_quota_goal nid with core layer")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 8f083611741fd..637f1bd0c950b 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1310,7 +1310,10 @@ static ssize_t target_metric_store(struct kobject *kobj,
 
 		metric_name = &damos_sysfs_qgoal_metric_names[i];
 		if (sysfs_streq(buf, metric_name->name)) {
+			if (!mutex_trylock(&damon_sysfs_lock))
+				return -EBUSY;
 			goal->metric = metric_name->metric;
+			mutex_unlock(&damon_sysfs_lock);
 			return count;
 		}
 	}
-- 
2.47.3

