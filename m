Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA2DCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F7356B00AA; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416346B00B1; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BED6B00B0; Fri, 22 May 2026 11:40:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6F76B00A5
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C90C192D97
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:38 +0000 (UTC)
X-FDA: 84795468156.21.23811CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4D77840003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdslDMQI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IeG1YpmdwoxV7AhFJBWoBRuaRnNiqLlSgdb3KPs/hX0=;
	b=UW+qE/Srp0Q82dII+uHav+fgR6ZbyniBYboM8eCOddbg2nhFblVPcVbzaJGuNaIo+7NJLs
	Z4JNII3YTtedJgXi4jnLbwoHHOlCmbQPEoqeyqp2r+X4yd2cBi4dtBGSVkQVildhPuxB8b
	VnPy6b3QbD5FLGLA4pXXWaoTK2Cqahk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QdslDMQI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464437; a=rsa-sha256;
	cv=none;
	b=3EcuACeFKXCKfwgStjBWm37lTItev6NHmdYBGsM6KXewpYDLnNIHM6smsaHa1ICOqjmV0F
	JRjPyi9bCttna5Poixxu4pDkAImeHunFu9uRxrud/k/caYHM8cBUH7fL/PKnbf1H6sPTbw
	Pee6g1Lq//qVAXQZbH1bqxXXOGY/n2o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B674760219;
	Fri, 22 May 2026 15:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DD51F000E9;
	Fri, 22 May 2026 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464436;
	bh=IeG1YpmdwoxV7AhFJBWoBRuaRnNiqLlSgdb3KPs/hX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QdslDMQImV+uHeiZSojuQBuFR8IkIcTGjyombaOwDJVaukQK6eNdRLjYZy+ctmHk2
	 xVe5F/IxXjNCKJwZzYylmQRBNo5LXWcfRr3LlLtwN7DiOeaFbL1/I23GOQsMsiCwBo
	 kNb1dxpo+BsXmkrAdpCHUMuEK62z57VKTGDjO2m+A1Ruj/qfv/y8gCdMje9VlgVQfg
	 fEpagFaFdNILiWMhfx3Qwa5njDXdnxz/pwpcYPqgaPa/wnrpaZmEqkwTUNtwLZe1Lk
	 Ie++/QpqVXZIbpgcGmZwmLqnMKFNLRCvZDY/oISmJxYMNNfEHaMWDMKB6rlmXpjyoo
	 +t7Tqy9VWZ5MA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/14] mm/damon/core: hide damon_add_region()
Date: Fri, 22 May 2026 08:40:16 -0700
Message-ID: <20260522154026.80546-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3i7i4aghzp8k1h5tahsxism95b799r3t
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D77840003
X-Rspam-User: 
X-HE-Tag: 1779464437-306265
X-HE-Meta: U2FsdGVkX1/joXnIw2H18UoAPsBemmbq06dbno9Cre9AEEmnR8T/gKDA7Bv/HN4F0yTkhSO8ZFmcHbsAdtqt5jAtrcY783JygTK2ge2k3CuFFYEzl/2TdP/lWX45wUZbINsnQxg404xO3nrzmHBUE9z0vIfx/GEgtonwhPxpUXENq4i65RPmv5ll0DaWiecR0GMvuzObETYjBOEP4lqV1+WO/L3wmWD5C25lA127I29TkwCKp7bROFvjEhNojve3gkuhO8tMt3Ds96YgPSHrXpXI90RNBE2fg5gKUtSkIXferf5G4yJtNn/R5509gXC7292za0Tncn7m9V1T700yErSDvyFp3ipH+biYqndDuuE10kE0gsAPyER9bw33/14V59ABSbWxXJI3uXvqLP+EPmpTtHAjFd+9gT7NojGT89FpbBbriHrKu+LGH2XmDIn8/Z9GnKqfMFNJk1gf3sZzTwU9hhUij6H/Ul1lwnCSUZ50GdHoNXS5jKq/teCciBc6cVMd8WaKbpL789lYG8Ly+jU8ZV8C4hwBxNXLQ2XxDGcksup18bp9JrG4j2FOdfc0dh6mwYsZrz1XVxg5L7hLHZBqwwvK2Dk//1Brd84yHZCrVLZMI2mZ4pb31NX5F2TjVMIsQlTZPM9KLDF2W59eg6W7CY71BDbasv02HI5jpmviDR1C9XuYXsG6cIj9fXBHnRDRiXgkbuAVCpbJj5pZdxeRMDMC7pfuZM3ryvXRqf4KDSYTXkFyyLMYj3GYScwBeTc6YQzuKLucJkE3btoWAs34bsNypawkW+Vo1JjEga/2Df7V2qkMo0EnJpZSE+Xhpbe6QDP0EgEAzmNvwqbrWhpIadWxPlzPBI4PyOKo2xjZomzcELB3ndv3rAr3eJ/recD2jRxMYM6a7Y0RXNVKuaN4VR2E8rvF1+eiQDpm/rcN9FchBpdyoUYdq07iF7ZKfHkda/zhC414a1M0LNh
 c+BEUmI+
 dOcLnBoz9sZM8/Nn6KS133zNYRWwttCYoF6jhkGTl7tobX+REbXROYI9uJpaBcsxKpb2zSWBD7RY5FOQYONmBSSXfEykphezlanykOaIlm3Bdj5BEyZkJ4/4hLIuyxfQvHJB4Ivr9Lv1FZpSw3GOcEpYIRsFdu07HF/sQ7CDfUmM0DBnSVrjHWEXFctvHZATfXwTkTYT+8x2osruvL1hcIDw7xl6qU0ylgmDg3mL0cHCq/Q33g/Y4NUuaat9IqaNLcQZ0kQCTqO3L77lGwbGbbyvDBa8uiEalhiPKGvdq5ymHMDJ0+gVORGPkHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_add_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 -
 mm/damon/core.c       | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 08c4aaa690fa8..6ba80dff56946 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1024,7 +1024,6 @@ static inline void damon_insert_region(struct damon_region *r,
 	t->nr_regions++;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t);
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e8cf3632115e5..7d1de6ff54eba 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -250,7 +250,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	return region;
 }
 
-void damon_add_region(struct damon_region *r, struct damon_target *t)
+static void damon_add_region(struct damon_region *r, struct damon_target *t)
 {
 	list_add_tail(&r->list, &t->regions_list);
 	t->nr_regions++;
-- 
2.47.3

