Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB9DFC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBC786B00B8; Fri, 17 Jul 2026 13:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C356B00CA; Fri, 17 Jul 2026 13:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9B26B00CE; Fri, 17 Jul 2026 13:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A38BC6B00B8
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:04:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDE8E80180
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:56 +0000 (UTC)
X-FDA: 84998515392.01.B1D2740
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 588E140003
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 14:34:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1VkfEE7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784298895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqlH4wneWbMAf8JjBiLX1bTl/sVQqX7skPWoj8yoesY=;
	b=cvgf0UbfGEa+IOQTU9CptoNMmTvaR9j1JfV1h6qqeBNsXunpKUmpeHUU8Rh1h6FqvaInfL
	jxOc6VHaASyZeAx4EHzOfwuQfLHf2vkQMpWIcJy3acLeJizV3f7zeEodx72YuzXegVVyv9
	BkSly346lYjOCCSL709u6yMmDdKFS4Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E1VkfEE7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784298895;
	b=pcuc7AHuR/ou8aIctd3r2u34HlHOGDqNxQ92+3V7Kf2AmJdMGU/yvsWVeo+f0g+o0ZbzmC
	UKJQwXNrsvdEa5V+hzQaqN3AhkCSg2mQbrYtqT1ABwHxzLl/rhTlD8H7B7mfZuSquHtJ+5
	AZBqMG7iU2f5ahhmB7P0MePUGzvJpAI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7738160A59;
	Fri, 17 Jul 2026 14:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50911F00A3D;
	Fri, 17 Jul 2026 14:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784298893;
	bh=jqlH4wneWbMAf8JjBiLX1bTl/sVQqX7skPWoj8yoesY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1VkfEE73Ld52yTp8XyAQnrJXqTiZfuPBrpHJg+wQgO+3sNQ0Iyu8PFiSyJKuDbfW
	 3LWPnW+dMyu7SVgLfgHiFoaZGVFY8xNd8VJu2HvUcIds2AT64Af4X2wpvGjjAIlYWr
	 CLrl4T0i7m2CYniO15KQb6ZXzke4uxN7QXT/oY2PnJYdnfys+nwsgv85juPh4Gh1Dl
	 ZGuVYrxhMsoNjjfaeFcQpFodyLIDvCoIsJDoyIgBeDLnLsDS68WGxSyzPhsTDCixx5
	 BFb0yKZ04XxR4H3Ii52aoGoEW7pZF983iz5p3Rmu7pdCgZ9Fi8s6OdJ93u6AalQbzP
	 r6ZQ95HO5A2CA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/7] mm/damon/core: initialize damos->last_applied
Date: Fri, 17 Jul 2026 07:34:38 -0700
Message-ID: <20260717143445.91207-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717143445.91207-1-sj@kernel.org>
References: <20260717143445.91207-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1i938bkysi4hao647t6uhn1kguub57ws
X-Rspamd-Queue-Id: 588E140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784298895-122314
X-HE-Meta: U2FsdGVkX1+O53V7TF9qY3rUDDvVjwN1sHPMfYcMFWHs/7V8Rl93xfQTJ4si+uRxvQZ2cXc4Fqri2ZqJxcEaXY8NdwqN9ZEYRdI8kTBf9oZeaNtPbOzQP440QCDw1kR/tGU1Wvj3+TEQs4YGExwvfHalbuXL0Bvfkn4VYXuWS2vW3b7H7L/ChbnWz33vIqma3eoZFCxyZukd2qdZkwKQVBezEQR7vvP9SAGkWAVp7oriKroa/tC93XnmNFh3syPJYaFaSLwp/NIupcqu9W5Ch2udbjmI4UQzp2nKYUgRrK4V8XCOxcmkuIk0L4v0FU87yKow5GIeWN4CH6J0eYoWr+gzCAy53WNBaM2kwnZF24jif9FptWRXE3H576ub3f9KRcNTtTl1kpGTjsVSiDRqoI3+JySfscetfLdhlaxszg+iIcx2lTeT6TRY+c7HXykSFYBfq8p8FRaeaMr/EanHk16qoHSZ1LM6QqJp7UyemTPD9VqACgpn9xI/OmB4610jV4KnfqGAGbxH//sirLnLuLegdi+Ot2gfbwGPo2ZHLFPnGpT3zDWCv6z0hIcz7uzeSmWOc//uFssm0ViHIspzPgqoB1EjZBaJy3gC2mMjdei2tpDvlzJD1Nht4IHdg7OhUdccQ23KB3w9MjnloG0wOwn7bjw2/Cqi2A1n5XSckzJT8lTRlGaj7p0GV6CEfuKvwMbb3m6pXqd7joN3flpiwhkQqBf3JpjGtO3178vrNm0hHlNIXI8UOkcokAC/k8Ywj40Y75U7YIUuD4upB5tbQX7OCKUJSdVgFt9zotlj2+YrdFKluWT+aXVIrRfap7wW2UzNzRrTTvtoyRMkvcBZ4RHx3tNVlnEiyjrjyJEAD3tEVa3/MTq15Se3gHqLgpz9cWi0rOYblgrqeobpTCrq0/tMD2Kx4XdvGeg29uYhNAFza+ZHlXZ5gn6rS2NJCla7OfnHyRjPe1N7N7KXowt
 Jo3I/oXH
 6vXbABVIcCS3Jk4JjguWyePsN8hVJBRCoDXEk50iTEprgo66op3N5mHov4PON1+XxKvp6Fko1Dp6f+cK1tyvOBlxDcCCoh80fP0tHIAGtLXTzz0iynmNFYRodYukmxHoWapUBA4JQRMovz896yN8mYyNQBA+JJWLr8d8w4iu6mlOBt1dRdvU2cHE768XAZcUvQuR3rriz1eLh72WBFQlqFIfsIlGwoXw+c5snOO2vbyUrfTnR3jW4cEDyI/0vP38Jll6GrFwHO+KGkG1U9e6VRPhstZIDryD/Wlkv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple DAMON regions could exist across a folio.  If they fulfill the
condition to apply a DAMOS scheme, the scheme could be applied multiple
times to the folio.  To avoid this, each DAMOS scheme stores the folio
that the scheme was applied to last time in the damos->last_applied
field and skips repeatedly applying the same scheme to the same folio.

The field is being used without initialization, though.  Hence, the
mechanism could wrongly skip applying a scheme to a folio at the very
first time of DAMOS run.

The user impact is trivial.  DAMON might unexpectedly skip applying
DAMOS action for one folio for the first time per scheme.  In the
DAMON's best-effort world, this is never a real problem.  No critical
consequences such as kernel panic or memory corruption happen.

It is a clear bug, though, and the fix is straightforward.  Fix the
issue by initializing the field in DAMOS scheme creation function,
damon_new_scheme().

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260714055436.120034-1-sj@kernel.org

Fixes: 94ba17adaba0 ("mm/damon: avoid applying DAMOS action to same entity multiple times")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f464b4f0976c3..60255f5cd715e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -705,6 +705,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	scheme->max_nr_snapshots = 0;
+	scheme->last_applied = NULL;
 	INIT_LIST_HEAD(&scheme->list);
 
 	scheme->quota = *(damos_quota_init(quota));
-- 
2.47.3

