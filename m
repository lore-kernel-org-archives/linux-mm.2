Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D0CC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:25:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA9586B017A; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59D66B0185; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20396B0181; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8940A6B017B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:25:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 265E880413
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:18 +0000 (UTC)
X-FDA: 85165264716.25.2E24274
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8520220005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dsoMRHtJ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788269116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRLux0o/6DOEf/DKOzdhtuDNwLGjkWNCPtBCJqp5Lu8=;
	b=ylPzxggJR38+CeY+M4j5L2zAlaT0eYfAASJVpRkVHwYlkNm0DM6Jdde/rPcDUsVdQd5het
	QBXAZMl+fejpeerWFOGozzeZWoavFmwwVJeNTrZZpdLDy+//iyaQhrhkpcE1sDwe8ygVFZ
	wi6KkRHZPpeVfdMOkftLZGKbbjhFrPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788269116;
	b=h0WysS4RIP9tWSnvGiBlx3rLltnWE8FMienLJPmd+niVTcOn5uP0/gnR2N1o0WYSMWLwpR
	BrOVbF4znxr1mu+5ZVSl7aJ7gwCxWt0lFhDQ8Cw19csAzhu4nFc003P9FG5aiujZr5Khjr
	6zZD9T7mAaW4RHvVhXc1LHbB/AGMPVY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dsoMRHtJ;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 170B060A56;
	Tue,  1 Sep 2026 13:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 955561F00A3F;
	Tue,  1 Sep 2026 13:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788269115;
	bh=fRLux0o/6DOEf/DKOzdhtuDNwLGjkWNCPtBCJqp5Lu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsoMRHtJ6t9A5IK7X8n7y8bRicYtUpaAfju2k5dDHWny+UuVVanreQ0++btTvla6C
	 cqu2gjNNZBYacDd9K6P1LbQ3k1skJ1EOgwcEW80L4xfpe1rJ9TjH0opCWY1n45eXiR
	 or6vXKSD3i4E7FTOs3nj0etWCPE6gzvC2rqhB+PhiSDdjTEw1laiThI4onSByspKku
	 95iapPoIQWsGxy2BlmnhO/MVBAhjyoUhYQznvtEnRjDbHqVXpTRCYXU+qprvO8UWUm
	 Kwb172VudYGgGcuLHHkdgLoufMhTgtvjO/SsK0HRew3a/RHVcJRLGKa11DrKOXztUm
	 G8zqtJ664NqZQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 03/17] mm/damon/sysfs: support pgidle_unset probe filter type
Date: Tue,  1 Sep 2026 06:24:50 -0700
Message-ID: <20260901132506.99243-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901132506.99243-1-sj@kernel.org>
References: <20260901132506.99243-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i61mbm71kup979k5716pedbequtefegw
X-Rspamd-Queue-Id: 8520220005
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788269116-997759
X-HE-Meta: U2FsdGVkX1/v/RGatPAH0jg6YargNzyCMt7bTiGDX5k8c0avkkB/Md8qQ7CQLLybDo8xJS+1uLHjA/J742B9qXXn/ZMxZy3Lxtdde7CThLE8wqNyQEHPhDj2JsD0+SAR/IEfLagW0SsUChAkzLdzC96Fm8/wPKup17fgDIWcr60+NGDwmsVzWYAlQWWrDrSytQKvzGAbFCQTH3m0VDbLOt4yMx2KSjoh0/im/+xAyJAHO0mEW6/oBtDygQiuWHVKLxhNB1SPPtaHqoL8IBGU4OqNy1ZS4nl6ZIZw6q4ldvctvFMIhLNR4g1c7d88+hxN2iUlDMk4wSad5ZFHJms0hNUOE0TE9z6VPTHNrUIRGdbDxhQM8xF870286L7YOvvfAv4v1L+AdCghejmP/RuAlqHfE5ZMDW+P+ZzxXrPTkrDhjfOZjZbH1eQBbZiJr7kL/FrlIggtFk+T8kyoYxvACLybklmdxBupI3SkAufZ5ASqidRDVHpv0T8dWZbTOERH7BVjM/ChjKAvIcRwYZDItzbSsPqO6E8aWjiVaiZBhqW0r1jAdrjkLRmwu7Hqrx9zDNgs0ao66Mg2bKTU/wCIIrbCQBZek8DWqyXbAnUCP9IXvT8DflXkLWBuie0R8Z8sicmROsNmitt9me6zhOWtHNC+FUJu9RnC8+3CbOwxyzUAorKKl1ARRXcemq41bm6jXqP8OW6D16tohBgFtr8KXKQQr4thVfY0H1+iYnbksuu7FDLC79hLDe9/iIReMfp+PrJprMEiK/b/M8YE7ynTqOb1LK1Khi1DXV0n/JjSyHKrBQ/Wl/SWmJlPWJhGpHKYfmUcJSXJOolfCu4RD84dm1v8UNCpLgkxV0osadBlDy9BE8VUUeP6AnsZM9LaoweCd+OfyW1q88U7hrAwJyTSU9R42/q7ggWfSm3LmYgb6RWne9a6s9uojRqbwx/V1n/A0FkmPA9pqfs7+/4Vl0L
 S5KW2ka5
 GYC91k/ubE/wlfhZBEySEB9CQ/73l+nI8E3oDr/w+4hna2gjp4PjBUk8Bu3/Zosa/LaolChcQaIKLr2gONMZYYylDg1w9iNgGsZ4abXP95jLRAh+PxCXl88TL3R5kbGfeiPszmqkH8En41Mo0px0lkScz0gimlQRIKTjfLw7y3XRq//5V3mvMuUcsZ0HigcuHuzd+hoJfinEeYaLiudkKjZ9vfBTs3jhqiqIcO60qnIKMITEafANcLjqa0NTePKl/B5g8hR2LhdOPxHPGigoLl0Ijnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to allow users to set
DAMON_FILTER_TYPE_PGIDLE_UNSET by writing 'pgidle_unset' to the probe
filter type file.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index dcb739ce0a729..3593bf9c7b7aa 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -781,6 +781,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_MEMCG,
 		.name = "memcg",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
+		.name = "pgidle_unset",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

