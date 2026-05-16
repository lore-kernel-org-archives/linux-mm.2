Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03DE5CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 21:04:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55D126B008C; Sat, 16 May 2026 17:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7996B0092; Sat, 16 May 2026 17:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424936B0093; Sat, 16 May 2026 17:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 356D06B008C
	for <linux-mm@kvack.org>; Sat, 16 May 2026 17:04:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3DE2140315
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:08 +0000 (UTC)
X-FDA: 84774510576.24.6D27D3A
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0A20A40003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 21:04:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cSV9qw4K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778965447; a=rsa-sha256;
	cv=none;
	b=yqNZ0iRtNEozJy4nTIFvHxk6burYGvM3i3/htEKuy/HubR9VDkabGsIRypnAqUgHBjUeYw
	r6CK0OHaV7j98jK8B9Fcpabguemc1jC0QW1QRa3Gl4yZrXICDSpV4vMkGU+ZuATNvciwYE
	VbCubiJiUpxxDoaYHSsDMfRygkU0Eq4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cSV9qw4K;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778965447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+8d6F/ecIm4OU9cM2uGG4hmEo0TfbVFCv/yoQTzhTg=;
	b=WatUKcXSqCfidFrNNuMjN6nftxhUJ1ERSWbVJZlXWqPJU75xPXkW0/W0v5VVyVQ8Q2+mQR
	J8ZXRCka7kacua2O2lHQEy2b2jFgGhyYKbUTVcGAaTXRYcWYbelfEVAkJVWXP/f+F5mGJz
	DViF5Heb34pz+T1jJTjW6Nt4Oilgwto=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7bde9d73678so5303707b3.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 14:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778965446; x=1779570246; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N+8d6F/ecIm4OU9cM2uGG4hmEo0TfbVFCv/yoQTzhTg=;
        b=cSV9qw4KxHmaj9NTD5cTXuXNlO8vDPH6PjxPKG9XV6qFyKugEOyizb4AmFwbgXJPbr
         jXyxC8z28gvZcdEnRKfXAKllLpVEumWJsTxg1SM0Q22tlfpsTod+KElOTvOGiNkBeeMa
         9sKooIZp8k32o77hyso4U1oT+QjcBLDn/DzJ7Y5/t3dL4aSUMaWlR/EHP3WCY609gh1S
         ZtsSDyT8LG0XpKWlcLPqpzFgPZUPqacy206ucTGeRwPOZaEHV2g5bs7t3o5SC+n/cCYx
         Nvm3ni1s+r3aNMhC0bwiDhKSs7SOqyoirR7XAz4wLfdLLpS+th+25SKfn4nBXB4MvnP1
         dggg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778965446; x=1779570246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N+8d6F/ecIm4OU9cM2uGG4hmEo0TfbVFCv/yoQTzhTg=;
        b=hv0DgBa6DBlA9buE1wvRv5306rBaEqTqZ1WIZp4lRoloba6yAUrp2PPbS1lOCXSW+3
         5R+f4tMhtE3Wtt+mzcvQ1YaJMNmeuTgBUxuxJQVnQxjQ1QzkbJYc+bNPXdrSpRNkAl6q
         Fom2/DbjoylpxC90oI/TltZB7Hz/72vmo6Fv8N6bS7minBHscf/2PI+PzIzkngq9CF+b
         gLkB0abB56iuzGyOKw2f0BgYwmgCjTaL+HdR/RcO+c9E+S41+kqapMVUpWI2spHLKLp3
         g8PJY0gWy2nJtSFTBPVCwdaxTwxLlPKMulDR/705eZ+UuK7mLGgRx4FwNI6G73cvNd3W
         9mMg==
X-Forwarded-Encrypted: i=1; AFNElJ/yMFtYrnIN2I2LJ0nPcPtOW08ON2bMyxj8qflTYvTJtwSpcYtnwh1aeW4Q6xvyb0Q9fLmb+F2GXA==@kvack.org
X-Gm-Message-State: AOJu0Yw6YDE+70YfQ1iEWp08/Bm4YQXMGNVMFB/inaNWrID50Dz4Bm96
	wVadLB9NuwF1+CJ0VuDqbtq4o5/T/tdWj1KnxPr8rk+cx+Nc2vJuO+Y=
X-Gm-Gg: Acq92OEaPvk/hMWxCFaL5zUjbpMW+8K43oqnfe/x5WYFs9BYO3OF4H0/tNyDJ9rihfZ
	QTR587cu1Jdx12H0/bbBAiDgDIoMwZgpdw6nUpbjp90CJ1NJqR2yDWEc6k3XteUxpkkItBrpnx8
	6lq7+CN8UKji2PJX3jQDuGPg4jPB3SjMZWB3q1kpJpe6RoXceHm9h9PpsP3NBAhx/8k907lLxDH
	sy94+r469wm3uFrLWz9E71b5jcBFfQ83sk+JFoV+jvbvWiWY5eNAlBmqrmaSBDUKqyUxu+782UO
	5dyMI75WEU1xmlhuRThZYdbtjY0+vHP3RG8V+1xrySODuZgdeFCvhzaMYH4uMEMoNdQvWfEEZ5i
	zIrbfkcglC8cAqKvHv5VUkA0vlGbKv133L9C6yEIbyQRHUfOQnz2YB05AJoati0UIyq/VCGDiwB
	z7LJL4I3n85SHO7KmPUx5F1eAvPVyS1qf7N+aelwzuuP+u9W1lIBYeH/mCmXCL+IAy2pOzQFlyM
	AbH8/vS2Byo
X-Received: by 2002:a05:690c:e28d:10b0:7bd:9a25:f39f with SMTP id 00721157ae682-7c7e5d8e253mr91991277b3.4.1778965446076;
        Sat, 16 May 2026 14:04:06 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7c7f4ee8726sm48887337b3.27.2026.05.16.14.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 14:04:05 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com
Subject: [RFC PATCH 2/5] mm/damon/core: cap effective quota size to total monitored memory
Date: Sat, 16 May 2026 14:03:54 -0700
Message-ID: <20260516210357.2247-3-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516210357.2247-1-ravis.opensrc@gmail.com>
References: <20260516210357.2247-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j4r9apo1hckmcspbumrxqr3aatia75hz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A20A40003
X-Rspamd-Server: rspam07
X-HE-Tag: 1778965446-601510
X-HE-Meta: U2FsdGVkX19WZmJNJ+F5jdTmRDGqeKyBYfrQZddmOrOujB2eH2ZM2J2wSpfZ94hAPdjH9RLUNcLyMNiz9ozho+6DXMhton5BcFFyHF71vNdWkCdc0h3cXAJlAmp2Aym7oaWNXAjhnAl5xGTEfEahqt1A+TwCbKktUM68pwPpZ8yrV+/VJSaO4tzsDN5tVKdLA2SqLgTSOLbZeChfFwRxsNGPH7Us1S4Qgs+iPG46+zpEGnndOKQy5td+0Z9QaHN9OqEx2kI94waNCZoPSjcYYOFTzr6BpB/SU7hhj+VtMeoxsoQqaNUBU10f6kQrWSuYPWbUHEdChXuo/RxHuH6THMnGyEU4jJ1rNDW60VWGc73kjZePnDJZbiDVo2PF2tWHWFPmAzawwQD5PidQgQ91GoZY1pOKFHwmcAjqnl1aRk8oqKF6wXlXKM3fb4RswHxgHpQlZSyWVZuyyB3z5EB8n23a2dzfbHHN+pUEB6ly38oFmjzSHQ6KF8tWtoUc6FTKS8j9s+J4lOuESEgr0GD3RFQMo0twOJF3f23vVkj7UaIIPrgOaWfK9kFx7B6xmd5zFZyaIhRXeGKMSr5EHt9ULaeoMoxnx0bU7NUHgSqPVBOpDIJxDKTi2P0yzulEOUi2N7qPnXJ4/HP1vmcmq1K64TYwZ36Hao/8QNuezpW52P08/U3b1wkB1ojfdoqj19CYMA678T5/WQNjEXAGk/LB290svM6UOOj/mE8IC/pFfxZJau62a9UfMaVrqmdSFeJE+yAF9kAQr/vbonDvVoNJxzQo6hVjDo2jLb8hxkQv0aTCmSlzB2X8OXGCZ5jSmeOp0UoIm5JM/i0eZyj1H3LvGplhfcdhM0Iy/X1DL2MUul3b9g5baXN6N4Yu8JUdlU25I9DxqzhIxOEnvsmPFHJurFMpBuKfUZKVQF83l4y2KHTtWSQlRJHWs814WeyslsudTzWY8TDaBIPe7uvmciw
 k14h+Si1
 UFbtWyJXckdjrhn+WVH5VfOfxmsAGJ8AjiQjJ29vUtXBeZ8E4Kw1Zfj2P44p9/Nk/HalvUcHxe+BIrfB4/jIAG3/x9z1ClwaiyTZAfqa/A3elG/+q8F5jmG4n2p3V/B5p0ET8aBgpm10HeqvocGEGAfNaBSc1eSqGyyeFH4hKwkQ7ti+pK17FlJZidjlOZ+DKKfe1Yd1++jkhcsn4Id+F2BGn1MwxQ2zbVqnLnEJaBf/vJ2xxFKucjso4HdmEzgyjBOela+8ik1MXWX1Y2KUoKTYF3RIisrK6MNc2jDCCNvV1S/s36z3Jd0AURyX/Vk8jtVBClqpvZU1YE6JiOVEHD03bMuyQ9RPeTgAItNtNFv6fUzgC33eSVXZCHC++P0Amw0Px5dSmwlkktFKSyJUke6hECZv0irosyLwyqFdrJ3ovljUfk/tHthrZvTAqM7PVsPjPIIiIolU4lkPOa8EqJCED4xXizMLUgCxbKjDo7s+PrflmA4pvTNSv/9wVI0wiLvJkx892z56ivzeU10dtq/UQ8haF1VdS8TgbZkpF2uYCGTLumK+ageh2BajEwQ7rLEy4Xyo+pyd6mkEvGdDQQVqgpUX9eWVEneuwCV1FRAI4lWoQtap0JcOL0/6gFFPoyRWaweEIV++UNbfvOWALmhf0Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMOS quota goal tuner can compute an effective size (esz) larger
than the total monitored memory because it integrates over cumulative
deltas without bounding by the actual workload size.  Once esz exceeds
total monitored memory, the per-tick "remaining quota" arithmetic
stops being meaningful: any scheme can apply to the entire monitored
space and "remaining" stays positive indefinitely.

Cap esz to the total size of all currently monitored regions as a
final bound after all other quota calculations.  Add
damon_ctx_total_monitored_sz() helper that sums region sizes across
all targets.

The helper runs only inside damos_set_effective_quota(), which is
called at most once per quota reset_interval (default 1s) per scheme,
not per kdamond tick.  Walk cost is O(nr_regions) at that frequency
and is dominated by the enclosing tuner work.

This bound is tuner-shape and goal-metric agnostic: it constrains the
quota controller to physically realisable values regardless of which
tuner or goal metric drives it.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9975f3d9ebfe9..fd1db234ca304 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2614,6 +2614,19 @@ static void damos_goal_tune_esz_bp_temporal(struct damon_ctx *c,
 		quota->esz_bp = ULONG_MAX;
 }
 
+/* Sum of all monitored region sizes across all targets in @ctx. */
+static unsigned long damon_ctx_total_monitored_sz(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long total = 0;
+
+	damon_for_each_target(t, ctx)
+		damon_for_each_region(r, t)
+			total += damon_sz_region(r);
+	return total;
+}
+
 /*
  * Called only if quota->ms, or quota->sz are set, or quota->goals is not empty
  */
@@ -2621,6 +2634,7 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
+	unsigned long total_sz;
 	unsigned long esz = ULONG_MAX;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
@@ -2649,6 +2663,11 @@ static void damos_set_effective_quota(struct damon_ctx *ctx, struct damos *s)
 	if (quota->sz && quota->sz < esz)
 		esz = quota->sz;
 
+	/* Safety cap: never migrate more than total monitored memory */
+	total_sz = damon_ctx_total_monitored_sz(ctx);
+	if (total_sz && esz > total_sz)
+		esz = total_sz;
+
 	quota->esz = esz;
 }
 
-- 
2.43.0


