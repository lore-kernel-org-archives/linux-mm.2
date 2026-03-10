Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEC54FCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:05:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB0A6B0092; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5BF6B008A; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B596B008A; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43C0B6B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D836D1403C7
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
X-FDA: 84528360882.13.48B09DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B5D7A0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iORzpayA;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JUdJ8/L0gInkmkQdbW6jbg/zt6aCjNuvJs26bE3KNeo=;
	b=v4dBv04NB/Iio+PjQKbj6jkD0ZAqE1jqtP1tVBMoYKWS6vQWjWWW7FEXtgX0aKXY/2WtBb
	aEt0wvkGa+GLhAouL1WHagfYiaDPXIhFUeZmnhAft7nnGun3iqPgA/9tIICqBAv7F+NPyH
	rXTQ+P1QkGwA6hAPKJLatr35inm/X+w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iORzpayA;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104740; a=rsa-sha256;
	cv=none;
	b=xL6Q/0+E3kTwnmf0MO9tmiaBfigbBTZEbr4cz92UZWzoWjdP2DH4qCOCtNsrkVsvL9w+60
	smOUFDz1qz/v1ne58yT0YH2EBjHek4hoqwCRoLqXGFHUBNjmaPgTGVmZ0bc8jyl9A0PvUy
	oHUkTuJh4GT3Oox1VZtdfATS3TGgDTg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C51443D26;
	Tue, 10 Mar 2026 01:05:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA37BC2BCB1;
	Tue, 10 Mar 2026 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104738;
	bh=W0GRV5F589US37sVLvkk1Bm1kqbNZSMw9lB8rWD8J94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iORzpayA5JVsAcGY6WLC+PT/svxnei6p5HhGfHcPGw2BhBI8aRven308Howf2gxTx
	 URE7TlvcPeHjA++/hfqHSWDDDW2YwvTVUoNbwa13buAr5ipqS/AIJ48DnoSHqN5fPI
	 5eGUn1zxw/Ujzi7ZmxLDf3NZiz/1WckzC/mfJDVxnJhnfzRWb1xdqFor/mpcYQh52+
	 Yi2w3oRRiijnlbtEcwvkxcMYIjNNdSbibjD5ET6bBpXsZpRlZ9zzVENzQm1kbZ+wiE
	 wvI4D0gZp8eZuqWs4Dq36qAfdEIoHS/4LCzxpXrsNMGghYLk5i4Cmpn24+GHk7Y/lB
	 +9zH0gkGjEX2g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/11] mm/damon/core: introduce damos_quota_goal_tuner
Date: Mon,  9 Mar 2026 18:05:17 -0700
Message-ID: <20260310010529.91162-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1B5D7A0005
X-Stat-Signature: r4hrsn6fua9q18pe71agtgiioef9d9os
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773104739-665153
X-HE-Meta: U2FsdGVkX19tusvjRkYOtiMYmBkm+ZR5d7+aUdv7xgiWVu19k6EnBgjjb8MUH2RKTQp+x6o22nu+cAdos4990wSU8Kei4j2JiIiBhMfXiU01Q28b7t5qlSlATwDV6x38blGftfv+kM0qNrt2qFu7GiWmjT1Y07PQrl+LlXkHLXSzbbruzIANo6gUHelj+B/zkH0HX1+a3rUmPBjqd5nlvPFRKYGWb/GcmRLkCyiKEwfy0c375a20oKbDFjD1O1kLlk3RZES72Bv6eJv3dhsbN+Gft/bIUwpHGqtJ0/wKAO7A5bpo8VMGAHnt75n5aO7TbP351VZ0EPAY3mFGtlZTj6UCTCXREvAnCrmxLEXVP3jWDn3k3rwsiE1xIBfOT/PJcEQb91psZKqmrzW2O7JT2jDBSQ3AuFxyTJJg6KGuN3UK/6GPk7TtuOTWPhySIExDslfQcvN2aHGqZj1bNVGU668GTvuhwF5GcCvojZgTI1ra/CqhXOGxuuypRiAa1R2R9jBwUpZNDkJC3gSg9/OnOw+BuAygq4qBSbxED3quOyG40mgeWbUdm9zIairILVlB5RYwqu3yyB+6uD38d+6cMpOytkgP7MFkVG0ADBklqti8d7VP7xyhW9yFqHyJzqMmk3PcU5Zie/r1nd8IupUwlcct1a3axS0yStBe8uCIYpVrjTZMSyXtvP1EOfu7yF48E/ywXh9tS/B19xAj5PGTxHiW4mEtkIV4v3uNNDvAvFcjCzbTOTfmVoWLaQ976JiPeX9HcMqSw6VIfGwloRfvzJNqOTHnPRH2oDWAAvN2Pt+1Oum7WPt8DlDPvxbpBh4BSKgmZP36VeZHp7bQPsv2i3JJCr5XbMRQyPSnz1/xWa/2E6OnJGy0BYxFbJjf3hFn3EL1hYjEPPOdbu8LxtvcXlA4bkACanhgjhlAc0oJEkXBu7DxJXs64QOhBg/xTKc/Gmzd0b5TJmmt1lROv9T
 dixq5wTm
 X26m6k4FYai8x1pqPeInyx3tqYn6rqNOCWP5fnOD3G0pCZ+3BocfZ/nrvXaIQaR/zyHYEkWbVaexrEsClSWNusg+FBC+f1syLzmKzR/rk/xp/JMuxPHnJBQC71TaHJxvdt2f6YOmPXdhrQcx8YqCbze/LEbwVV1FOIk72eOSKF3c3clW3pizRbF5ORBdQpr/tGXVeNtMBa7eE7AOA3EDz6Gwpv8GfEN25V5e86YQOtK226jKlU3LU5kL/L4+MxUpgJhFsPX5BYepuCTe12gDe2ccZJC5vlIJT3m4mlevA/Bgk4th1jgK3G7amYYJrFtPUXwoYC1t4xJXQvnqduXk9BBOX0sCyXVDf3TrW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS quota goal feature utilizes a single feedback loop based algorithm
for automatic tuning of the effective quota.  It is useful in dynamic
environments that operate systems with only kernels in the long term.
But, no one fits all.  It is not very easy to control in environments
having more controlled characteristics and user-space control towers.
We actually got multiple reports [1,2] of use cases that the algorithm
is not optimal.

Introduce a new field of 'struct damos_quotas', namely 'goal_tuner'.  It
specifies what tuning algorithm the given scheme should use, and allows
DAMON API callers to set it as they want.  Nonetheless, this commit
introduces no new tuning algorithm but only the interface.  This commit
hence makes no behavioral change.  A new algorithm will be added by the
following commit.

[1] https://lore.kernel.org/CALa+Y17__d=ZsM1yX+MXx0ozVdsXnFqF4p0g+kATEitrWyZFfg@mail.gmail.com
[2] https://lore.kernel.org/20260204022537.814-1-yunjeong.mun@sk.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ++++++++++
 mm/damon/core.c       |  1 +
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6bd71546f7b20..0824b953492e8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -215,12 +215,21 @@ struct damos_quota_goal {
 	struct list_head list;
 };
 
+/**
+ * enum damos_quota_goal_tuner - Goal-based quota tuning logic.
+ * @DAMOS_QUOTA_GOAL_TUNER_CONSIST:	Aim long term consistent quota.
+ */
+enum damos_quota_goal_tuner {
+	DAMOS_QUOTA_GOAL_TUNER_CONSIST,
+};
+
 /**
  * struct damos_quota - Controls the aggressiveness of the given scheme.
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
  * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
+ * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
  *
  * @weight_sz:		Weight of the region's size for prioritization.
@@ -262,6 +271,7 @@ struct damos_quota {
 	unsigned long ms;
 	unsigned long sz;
 	struct list_head goals;
+	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
 	unsigned int weight_sz;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7f74982535aca..c16a390152790 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -912,6 +912,7 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	err = damos_commit_quota_goals(dst, src);
 	if (err)
 		return err;
+	dst->goal_tuner = src->goal_tuner;
 	dst->weight_sz = src->weight_sz;
 	dst->weight_nr_accesses = src->weight_nr_accesses;
 	dst->weight_age = src->weight_age;
-- 
2.47.3

