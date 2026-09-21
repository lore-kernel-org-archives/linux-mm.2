Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C071C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 15:16:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5926B0099; Mon, 21 Sep 2026 11:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88D396B00D9; Mon, 21 Sep 2026 11:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A31A6B00DB; Mon, 21 Sep 2026 11:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58FCE6B0099
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:16:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 506691A01E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:16:05 +0000 (UTC)
X-FDA: 85238119890.26.FA3F4CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 915EFC0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 15:16:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lNF9xyVL;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790003763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOvG/uo1bcbPermo8brtuzKlqeWj0xatwdIh6bjgz5k=;
	b=1t4AwKs4lQjl3tx648F4on5hEvawjBjwWuIWLdx62TKt3gew2oG4/g8BJaDsXBTl3kfOKh
	p6HboULicvx9HUzLjY6bWn3ttFEwjlYzpMu1rR35fFRUjP0YJmK07LYI/2X16bzoYuxfXt
	y/18aF+99nSMaf3KorB5NLga9GVeKo0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790003763;
	b=gotZCP75JiNzMntyf4eqmgF/o2XAN4L/QgJ82wTiN/kTuiS7ZRfogeTTYncnd+xyD49gmT
	eS7JZB3ZvsJsMaiEu6Lvi/1QLYInx8c5xSc/uE37i4hlhakbq00XZ4ZdWZgDG/gnZpK7lZ
	+Ih0EhU2eQWAODD2wILB/Eo2BOjocQI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lNF9xyVL;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7F8842A30;
	Mon, 21 Sep 2026 15:16:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C537A1F00893;
	Mon, 21 Sep 2026 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790003762;
	bh=hOvG/uo1bcbPermo8brtuzKlqeWj0xatwdIh6bjgz5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNF9xyVLj41JefydyGx3JzxqT5j0YaN32U2Of7wQEspNIopu0YEFYUyAkCkfCw8cr
	 FCtVPu3/wHKKG2DsljiMyt/yZuL+/Fa9aui+A+uBZg+Vc0ti+qEroNjZSkvpNgGKJU
	 pNsGpvuSAVaY6jQI3hobjXB9oLvLsEGHwMZ6jiRwnfRGbvr5e6UFh59vJP+irwm4ql
	 5pEk4jcRocgT27DGtPS0DzBuT4nx/PKL6n0cuBn/SgbBl5RdKteVS5VasCmucA3UpD
	 B3YJoRf5mzIC/TkyG4Hv9YEJP8wXB8hq0DYs2IninuqjATB0FNKhXm9VimeZ42JP0u
	 xCn1LrwjvY1tA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Karthikeyan KS <karthiproffesional@gmail.com>,
	Adrian Huang <adrianhuang0701@gmail.com>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	SJ Park <sj@kernel.org>,
	Xuewen Wang <wangxuewen@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] mm/damon: document that a zero sample_interval is accepted
Date: Mon, 21 Sep 2026 08:15:46 -0700
Message-ID: <20260921151547.78472-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260921151547.78472-1-sj@kernel.org>
References: <20260921151547.78472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 915EFC0003
X-Stat-Signature: aum1x458jt5m5xu615djgoutazp7i3nu
X-Rspam-User: 
X-HE-Tag: 1790003763-409286
X-HE-Meta: U2FsdGVkX18o1FQaTXGJ0jd2+PDZbEJMonvru3CcCAqgvqw+9bnhH7aYgd8z8m5ziF3z8m380qG5LzmZC/SsVRUOzzLhvVI+/fZfYpVaJJX/YUyy3cfIIeT7xANhtwtHKssMOY+tX/wwBNUJ5UoZwl15ba6uCrmossadNnCZuCEt89/WfB+81igaPyYp5q45m/Yc7n9pWgvBI7dgGLqfVZIt2lXyo903wX5dx+ZuwzPE0m+JjFXdJv2BniyCTRa2akpghpRs5FRkieFAB/LrhsAibz5Owr9RRPMcYxHTBmc6By7nJCJ8r/8ToLEt+CJqVeZWPE5kMWIGoFq/yuQEgiU6DdWRzQKPDg2tdP5iuoMmTegy/NpeM4pfuTiu5j5Ydj/nYozeE+rXpRCXqWlv1HvAaTBwYe0thMsUwHk9qyWyJGiHolpy1V0sA4lamldlRKQ5y08NnlCDMM0CfMghXue6beY4fBDZgFEDErZBBZWVIC40kmgHwX1r2mEuQD63ClkMx6OgV0Ifdkg195zSjw4a7zU2kz98colkHnswK1e/amRMPGK4VsgwFOTY67opeaa8EM8zGsqLOv8aPMIIffymP8YeEdscJYlGOg29zMJewjaMutiU4cFc1Ku8z3WYdWVmlsvQr3hlj08ZQJL2/IYyzyL5PHerjClOKiul/rr45AMPXZcPXA8yqCnrO5u3nruCfftEpDxXwLvbr/vO1imJvE5+URQW6gJHoDY0PMVj4D8ZSADCQXXsPn1JbVy4jJV6SWJ7vbNH0uhqywh7CVJcaGZHJQqEBnttxNQUQ9WGyuVadVHg4wAjUF2cAiqA3apu6yNNy2taOiiIII/DKojClSUGDoFJXdIdePLDcXex3PSyzFM3+PyWRM3JzK0735LTAPytFlGpCd1kMa1F+dnCDTTZY2aiYAB3WfWJcO5wAL+ogufk4c2agkH/3KhlLMOpUMrbRs5HFrbvOPC
 Ob/YUC2j
 DG4E4DjzFepdVEIpYD/jravhH6yNeCEfzY+x4ChWSqFAnaj8e0z3t7YIK4I8vkd8agfj3BmwrICvd3bshj2bAg+MAfNTllGgxaFHYnArhsmEhAYobpyoEClMpS1Mzu69rbQbJcsOM3Tp+hKng+BltSr/HYh/0Xol+nCZ1VHHQg58n7r2pydMa3ElUckYcvd9hiC7cC7xTnW9M+CI7oU6qYlw7vWelTw3+J8dzqZM82I2yISpKHhmsAQGsggN4nBZLuluBDrxITZkMjsw64QQG483g22l0DKcTZFY/GdOXY7DJU+LAc5IScuLFWKnvA9E71LiBRp8NpT2BVhQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Karthikeyan KS <karthiproffesional@gmail.com>

damon_set_attrs() accepts sample_interval == 0.  This was reported as a
bug in v1 of this patch (rejecting it in damon_set_attrs()).  A similar
patch was already declined for the same reason: a zero interval is
intentionally supported [1].

Document the behavior instead of changing it.

[1] https://lore.kernel.org/all/20260722094304.3132750-1-dayou5941@163.com/

Signed-off-by: Karthikeyan KS <karthiproffesional@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v2
- v2: https://lore.kernel.org/20260918131301.75879-1-karthiproffesional@gmail.com
- Collect R-b: from SJ.
- Rebas to the latest mm-new.
Changes from v1:
- Dropped the damon_set_attrs() rejection and the KUnit cases that
  tested it.
- Added a kernel-doc note on struct damon_attrs's @sample_interval
  instead.

 include/linux/damon.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 836353c4ab9a..844b175120f0 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -836,7 +836,8 @@ struct damon_probe {
 /**
  * struct damon_attrs - Monitoring attributes for accuracy/overhead control.
  *
- * @sample_interval:		The time between access samplings.
+ * @sample_interval:		The time between access samplings.  Zero is
+ *				accepted.
  * @aggr_interval:		The time between monitor results aggregations.
  * @ops_update_interval:	The time between monitoring operations updates.
  * @intervals_goal:		Intervals auto-tuning goal.
-- 
2.47.3

