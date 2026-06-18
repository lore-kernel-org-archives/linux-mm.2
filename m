Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9851CD98E4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 00:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D66096B008C; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0C66B0092; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B91756B0093; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AEB66B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 20:57:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 03872A05CE
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:57:06 +0000 (UTC)
X-FDA: 84891219294.24.7F01139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 66029140006
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:57:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzvG7YBd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781744225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vj1ysZXTzQEftM04gbB5WCu/uXQrIziK86sFp/rbmQE=;
	b=ngz+D1TdM1TCI3crOLIDJW21nNnngj9bxAf2fYfKEflAjMut2V7LaMskmL4c0u1cwTytao
	MQBng55xn7Jyd0DDRjHkeOfSkxQqOk/kVjmbLECyy7uPqdcWK6h+sesleSYvD/BJiBtnaG
	2uNyMiT8GQryRXqnt0ec3b/fuTZB+Kw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BzvG7YBd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781744225;
	b=mt0PtiQFGgPYlYQomr1+CjgtbCLGRbnYiui2exQQ4SoLYX2xkAE8sYBd24maQuflXiRU0l
	oLMWa4m3R34vox2sXLq171k5r2uaSkeHXJg7Wc/TaiOXgoTwPFdKGqDrioja8rvcCv0YpK
	9RvuYu5OwD14zz8B29zMnaI/c9jVL/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 960194046E;
	Thu, 18 Jun 2026 00:57:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B301F000E9;
	Thu, 18 Jun 2026 00:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781744224;
	bh=vj1ysZXTzQEftM04gbB5WCu/uXQrIziK86sFp/rbmQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzvG7YBdMMtJ2AqIrAKsD7LQV9XdMyH5w+jvu/0hi1pAnks/GEAGun40xtq8a+j0n
	 ZKjopGiUxwhtnsAdY9WjnLujhgVVr+vuNJlN7jZQjqVQQC3hnisf52E+cOOW47zHSO
	 mIkNjYcIPF8MMgnpCNVW/vgU4ARygL0kMQu4huZBWdEWJ54MDXRck2NofGTbLieEcP
	 6QDKfv9dAEQaRJACGJwjWFcNXbLV5EsgsrBhx0mhfLpoMoz0vwdezEAxNz8HduN2Wt
	 Yivavv1q7OtrtjkOp4vgAQtPqmobPg1CUINZF18h5i3qb6lVThJWOtUFYiaH7qI78o
	 3+TEy+4uwE48w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 2 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/2] mm/damon/sysfs-schemes: put stats for scheme_add_dirs() internal error
Date: Wed, 17 Jun 2026 17:56:48 -0700
Message-ID: <20260618005650.83868-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618005650.83868-1-sj@kernel.org>
References: <20260618005650.83868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66029140006
X-Stat-Signature: 6yaxuexyqjzr6jud1nbfkenrr6zxsqog
X-HE-Tag: 1781744225-663948
X-HE-Meta: U2FsdGVkX19aDr/FNBR3PgU0cCa9viHyZLGmkqO7cQUcTcsSOh7M5ijE7V8RkqkiaZF6b1eY0fYVpR6J9pj+9lkGEKiMqRuayzua5PFcZfy9OdkhaHn84u+r6aLB+qjz/ikz4c0TIZf3+Y6/VCywCw6/1zGQoQrURRh36/NKGRmvMe6J+98cTuDEP3ctOiSAkMXOTOyseHRGFwEG4lGS/QD2uZADABKxVnr9+vDwk5ehUK+b6M/EjzodphSEPAzY79FSHEb9ChPjDcEV9/uwUQy3t1ciMIx0FxqE+5Pp2qulxex+yS8NlZhw04/4wNUqfJx7nMR5u3heSRpjL0y65XmiF6dq7AYDu/Af0KdmmYtK3JAAIma+7LqI3E0i7E2APwJG8QLi2Of5zz014m7029UvSXB8FWgjZIB3zAKclrhA2VTZvUIJ19AnTNLwBTzoNGOZjLp1TxFngVCKa6/uHtui9pFS48Fa+3w7YGmYK2CWTASnZ2P+vDZt0qxcg4ED1uuc6HxQJsxlNWa5lANGPhp7PstEC4r6dEozUUkRuPZo/ju/Y/mOFDbwn1l47qu9EzUZs9nK5SflZWR9tbc/WggVXda0cCv9tMaNxhfLV2MCxzpylhhHWS3gUxOltS48mb4S5eOGAbfKO3HZL6sA6Cp0PnDizaiGa/rmymimWmNA5mpD/gMkJ7KMkkbtaXUAia1yQR1iaSOXQubAmtlFGSRZo+Ef6In6n5g+vW9mYKP4VydzLwTb5JJdAx4uuixvfAcvppms+nAZt0M5LVi2aqkSNmtvf6pryp4mQR2eHMs+poTSPSmqlfX3yK5bUpBboOA/HsAiI6RDy9D/37/QjH6MS6MPyqHpBHFlaVuVAvMF5QySQAP1I55iQSzhyGQ471aDarcsp07sT1R7PVu5AVN69Ac2OOFydyJ92B1+nRCYuShfucKy2H667+qUvFYQzn6g2gIj/FdONegnBqn
 /e6eIKN3
 5hocky8Z4lMhRb8x8/9RXSc6Qf0Go9uUlYt6z7DjK74p3UsbwkINiPlxKq2CNBIGW/aeVPgZDGfgaDOVUMdmZ/WoxA22kokh340mUvVPeaJ17QgRJAJteJKQ6wwszb8cTpJv7IHyWS8cKB/3nf+zdSwPRjG81jI1OfCkRl0NA2jMHQ2WluGspf0F37oRcwmBk0g45h+rlV/255eaBPEAlQ8g0czXCnWO6m9Ig2WwsZ5b2X19ygx/CSAeuBWQjntgScoHVNTsGe/E6oan2M1K2fYX1CA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_scheme_add_dirs() setup the tried_regions directory after
the stats directory setup is completed.  When the tried_regions
directory setup is failed, the setup function ensures the reference for
the tried regions directory is released.  Hence the error path should
put references on setup succeeded directory objects, starting from the
stats directory.  However, the error path is putting the tried_regions
directory instead of the stats directory.

As a direct result, the stats directory object is leaked.  Worse yet, if
the tried_regions directory setup failed from the initial allocation,
the scheme->tried_regions field remains uninitialized.  The following
kobject_put(&scheme->tried_regions->kobj) call in the error path will
dereference the uninitialized memory.  The setup failures should not be
common.  But once it happens, the consequence is quite bad.

Fix this issue by correctly putting the stats directory instead of the
tried_regions directory.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260617005223.96813-1-sj@kernel.org

Fixes: 5181b75f438d ("mm/damon/sysfs-schemes: implement schemes/tried_regions directory")
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 7c00aa78b2f50..0134111c3c1ff 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2513,12 +2513,12 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 		goto put_filters_watermarks_quotas_access_pattern_out;
 	err = damon_sysfs_scheme_set_tried_regions(scheme);
 	if (err)
-		goto put_tried_regions_out;
+		goto put_stats_out;
 	return 0;
 
-put_tried_regions_out:
-	kobject_put(&scheme->tried_regions->kobj);
-	scheme->tried_regions = NULL;
+put_stats_out:
+	kobject_put(&scheme->stats->kobj);
+	scheme->stats = NULL;
 put_filters_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->ops_filters->kobj);
 	scheme->ops_filters = NULL;
-- 
2.47.3

