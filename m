Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 694CECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D246D6B00A6; Wed, 17 Jun 2026 10:48:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4EB6B00A7; Wed, 17 Jun 2026 10:48:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12136B00A8; Wed, 17 Jun 2026 10:48:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEDF6B00A6
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:48:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4FB212047C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:49 +0000 (UTC)
X-FDA: 84889686378.21.C7F2A49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5164D2000D
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:48:48 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XB0KHA/K";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707728;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V69jCi4XbNmje4yP60Dxbb/L0C+xnieK6ht4H1cDOOM=;
	b=KvCaBmSum1jehD7PkAq7stKlyaIwQlUTC2OZPXs7MNAvh+ULcA0273RZQiZli8i0CC1VNQ
	rT13+9fhWwM9fUpdOh43D69Pd/g4VOUxVquQh705Q2rxhMcqztIekWpU7B6ThsveTH9Ko9
	exhBWusovQiHKYlo3Joxhf+QV8AtBkM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781707728;
	b=tANRP3BQe5L2UGAW4WgQ606vRwcL5Kk6Y7oFxg3T4/QIdJeQZinUte31eCRKnndkaqCDUA
	jvpgTrsDKocTVaJIQJlYSQArfBxaPwWFCqbNqSFjfgZ1qPJqsHkKbjf2oQ1yHEQNmQjNaU
	kX1ow3pY4lv98curi/cv90tD5mQ+s00=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="XB0KHA/K";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB4E660141;
	Wed, 17 Jun 2026 14:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BCF1F000E9;
	Wed, 17 Jun 2026 14:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781707727;
	bh=V69jCi4XbNmje4yP60Dxbb/L0C+xnieK6ht4H1cDOOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XB0KHA/K4VGjiEZRfZhsO6l5y4g+SMA4WmsJGyTLBkn1cfoI6eivorjwI/m8zHus6
	 cGsef1nja3A4l6IJA3J6q9AObiSQoCuOrBuU0JnllOCJG/aKfeRS6cuNCr/kBUWdPV
	 bqGkcr68AVdG3Dk3IPwnbVSb+1TxZ4tjishaXAraerjIvfDkDRvnPnyvOumUegH/yQ
	 8SR0b2Zjjeobv7PIY4qBGtHpai5uBUSLQwszxEJLBNVLK579LkN8ApIcYrJ4djeSRR
	 qHbbtE3nY83GIsgPA2sRwO8ILUNu4GtoISOkmDVwMbY4hvbtpUGK/j14r+/rrhu80H
	 dJkYheE+M/VVg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 10/11] mm/damon/sysfs: kobject_del() probe dirs in probes_addd_dir error path
Date: Wed, 17 Jun 2026 07:48:04 -0700
Message-ID: <20260617144807.91441-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617144807.91441-1-sj@kernel.org>
References: <20260617144807.91441-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5164D2000D
X-Rspam-User: 
X-Stat-Signature: 1647buwi4yee6e35mq5zp6iye56fz7aj
X-Rspamd-Server: rspam08
X-HE-Tag: 1781707728-719265
X-HE-Meta: U2FsdGVkX1+8nM78xqu3g1r6ZOkigs29MlFJoScJqwZxConEYs//RtQFhaeFetkdisQ2zDi3FB9D2pLLAUo3N0v6VSgjss2vn+f7yIwr/tKXonLv/o2RYSHzJgehZdjvOjmyholOtUZVI2azZxdYouDGjuvWghFdA+qZuxQG6MExynx11XU7wxEhZyzYlSR/C6sAN2c+UQCVJH8Ao/T7ZxDvf8/AaigBO4xbwnELtGflIdRVaNT7jhUhy2Khm26wODEMhJKMmfLfnz8lQCqNA3eAOrAsH678U4jWEgnbmoiZpA1AvCyI82kYRiVTXPp9EspIr4To4teBzBdgyaRRWQNvy9Uw23Q274HlB+ipf53eSvsni/VrgprlINLUM1s+5fBreDw6qtOT5My0dNkx+xv3m2k3ttL0dT7W8nVDBZEylhnf9XUK/MltI5WYdaW3xsF1QjcMmIO2h575pFUEajlBgX8K8J8uDrYclM7opE35AvpupWs+WVsIlNWbmluAvZS0HDGnUyNnFaT+HMWekBunDotBPtRppqM0KnI23DPJy5GgIBSsiXId9hpwKbuTv14sn4o+l/1rJHIgci56Dk+4Fiis6bnTowtGoPzcMfbjguuyOE4xWC8Tu1xz7s/Zh7a/B/CUHuuPAKhGq2BJG//MQwy2JW9dypqDMHfu6arlEpcV7Rn4OC4z/eAoJBUG+aZLlUSkYSD4vuszQZEhuL5KSlJQNrCY7lJ2qqWuAqhzlzBU0nLrsUeOILD/1bDyQh/rQZgkLBjx5ETGjcnqAKxkCSbJDPDiqK+IKz0AaDI0a1b6OOQc8QivzJbgTcWh2ECjFXXTR64jFJGWpDOhhaFR8grNoqgUTUCE5p0DqL6ov5k/ZdPQCF/YQWw7iBdo+ghzwENi1GQFFUXLlDuRE786Ds9ZzWrPvdIzVJXW7DZGUV/I1RL0rXyJ263I/KbWiiYlgWz7FHBoMYwN3qH
 bBwxJ5eb
 DhzW7O9skW4N8y8Wxl0bOO05xB4SRmUzbxyK2qGJC+VofjL/WgNYJcBOfDGyAUHwyHaPOPolA2jiDPrTlVdP/BJ8SNhR+oR2jG1uGAC23d50Vp8HcxvQp8vyypbrcNd/g9LgVbfSVVihG1D++9WgK4OiL2U/fnJB1MkR+NXfiUfZJNO6kkDtypWTez11vMO8l5AvLrxwEXa5cMX0plJb+ZLrQ95jD/GLQN9OwHYvxo76X6DFwDBWIGO9BsASyFKqgawdOGcyZbIko5s4e8Gcd8QzGEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts.
Fix the issue for data attribute probe filter directories in the error
handling path of damon_sysfs_probes_add_dirs() by adding a kobject_del()
call.

Fixes: af7cb41af9a9 ("mm/damon/sysfs: implement filters directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 36a0e82601697..ffbc99411f53b 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1183,6 +1183,7 @@ static int damon_sysfs_probes_add_dirs(
 
 		err = damon_sysfs_probe_add_dirs(probe);
 		if (err) {
+			kobject_del(&probe->kobj);
 			kobject_put(&probe->kobj);
 			damon_sysfs_probes_rm_dirs(probes);
 			return err;
-- 
2.47.3

