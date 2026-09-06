Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434EDC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 21:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C508A6B0088; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEEFA6B008A; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0006B008C; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2B46B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:05:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2FC0A05CC
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:24 +0000 (UTC)
X-FDA: 85184568168.03.17B47A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 53EFF20007
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 21:05:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QayqpzHD;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788728723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yd4lCB6dTAYrU/arXR8SQcBFL5XuW/pHu+vMb4NXhus=;
	b=fRdeenziDUtrskB7KJOyS6T2roU3l1yVwWiBpBX2ak7DC0f+gi5AC7a2MJHMZGDH5g08yS
	8UFEvl3GlnWijlquYoqfiltuC5Qaso3jrDTuM/0+wpShVo3YRU6jOuAxQl5dCLvzObS7VZ
	PWIGN6wubIladWoW8KnkwtlkZU0ApRU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788728723;
	b=MGJ6MPRCj1c24+va4aczabaLguW8vNLINkxp80ZX3/nfMyrNEH2rE63DDIDDEdMRkhnOiz
	f+IC3vhUD7Wa3jwMU4yNMy0GK+49VZv0feEIubyhx5dkTow1n2FJyVVLmSxxMNxc52uNJm
	VcPkDlyqO5uPpAgWeV5FX+H/MZBNUm4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QayqpzHD;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC331601F9;
	Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B89F1F00A3D;
	Sun,  6 Sep 2026 21:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788728722;
	bh=yd4lCB6dTAYrU/arXR8SQcBFL5XuW/pHu+vMb4NXhus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QayqpzHD16IlfVZM5Gglq53PCSNrzfSPPbd/9zNKg991mdo3gVo3+lqZew3+JL80o
	 xbm9np+WP9bKdLQCN4yjd2pOHPKfPNHaCmhT/i9OKDcrIEGEzgvIV2bz/cc0GjvU2E
	 lHFShHzmCm5FHEyyb1sHIvTJ3IbHwbodsdaIpQvnzUPhks+Kku7GIw2u1g5Nf+zCte
	 tvChj9oKGJbHJJyXliQdWHeY47mdBYIGLUS0g2gd7QUZvpcWchfCddEwr9ulFabG7Q
	 w5tT2Mukz6ZjIo2YGFrWbAUdfoAhXB1JRUirQuu8H2Al7WDMKYDCUjtBOZ9lnpPpeY
	 Z/p14P9/KCUvQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/6] mm/damon/core: support probe_hits_wsum damos core filter
Date: Sun,  6 Sep 2026 14:05:08 -0700
Message-ID: <20260906210513.106895-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906210513.106895-1-sj@kernel.org>
References: <20260906210513.106895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 53EFF20007
X-Stat-Signature: oxs4nyd96nf3ybm13qiu9ooaeudxctaf
X-HE-Tag: 1788728723-339136
X-HE-Meta: U2FsdGVkX19avDIR4rPDY3cEYp2UwK2dhqbNSdHRzbUYN5DA2Q3cbNvshuRCSLNNI9xY+Wmxmb7XeYGmJKwXxa39Vd2zBO/DDDihNBdreq6wplUmvinkGxC7Y3NeESVKvugy+hElhIJAXeJmFVRZ4CTLSIr5wuMVqqpnS/6PAVj3pT+/lg8Dv2igYLEuFTqftdcVwRX/xaLxj9g1A2Ymr4uwIu4PKjRmwUeUJtUav/BhYia4/53wkjxo+ZaDuOSuScb2Qj7TqjqB9C7zQDOZzOHrFyEbyo5y2jCwhZ1KIiO/1HPepRCBxfOtVy4QeQ63xUEFs0U/1ZcuWHNDRSuB0a31nIJB25AVpYyFPYH3FoCMrD5LxCnZxj/zVielnb9OXS5/EQNWn5D7Y48/0dmbd2I363740HgcbAMyeWA7jLqkcHmJyG3lN7soillnWHsmunWq2sqxUQUtKHRyIb402dr6XgB4xBM7c8A1vKHhWBuiIqfHZX8B5JTXDM+Ooqkapdm4RBhGW7vzGd2yJtnRYaVueo753j7uR6jIZiJdd3wGZScQk7j2WKAVClqSH3fUagydYzZygBRaPjUkBJcl4PDgLUrvHoLDn/hKWjn9OxGLHUMGALrm3HYgKB5Ib6sdj2PC/Fgj4nQXaoQX6A56UdMOCEGjB7h5igjJUFND+UOBwztgzrbEjnpGLifttvDYDEWs2xe1QtNgg4m80S0yAHg3c7PJTNtolq66PDzvlxg9Vi0M61K1DPxoiGukflqoQRtuWLghACOfgdz3iiQgwp3If8OcmGs8YW+5KTY2xeI9R1+f6YwErU+K3KBRb1sUsO1GZOvj6xfw0jFuv2KtwN9iX0LQoPvHlEzGzxVq5iUBpwH9L8pjywR3WLnyRW6VlVLMcJo1KbV0Z2/gH8h4lcyj3BghYt30wP/DCdMs3f9NpBDEPdlPhfWpjpHKKfinhdq1w1FkDRRG/ePBFSv
 HWab3Gpx
 pqQRnzspuLzc4lDOj44/FFikVmVRaJ0hLhwYqyJD3y9ty6VJ4fmxKVHRmE79J0P+Ov2uzeb9GNKiFyE+pjLigminPDQEA6ZcDrvMq1YQX00WqY7cHiPj1Q8CsE7vTNktmc6AvSJUz+VZAVMg4/GkR2yMWAL+CuRoFkTlJYlCixAs38qSmAWDc+eiBAQ6YBItfSibyYUWG6yMGZUaE1PFI0GnFhv/ZjlmyF2TTF5LNdvd/76WTYTiKoTYcr74E21FVOZ8hnwn6S1ZEmxI8wcST5PniYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement probe_hits_wsum DAMOS core filter support in the core layer.
Make three small changes for the support.  First, update
damos_filter_for_ops() to treat probe_hits_wsum filter as core filter.
Second, Update destination damos_filter->range_{min,max} for
probe_hits_wsum type damos filter commits.  Third, extend
damos_filter_match() to handle probe_hits_wsum type filter. Calculate
the weighted sum of the given region and compare it with the given
filter's target weighted sum range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 1752afede01e2..5b976162c5eed 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -654,6 +654,7 @@ bool damos_filter_for_ops(enum damos_filter_type type)
 	switch (type) {
 	case DAMOS_FILTER_TYPE_ADDR:
 	case DAMOS_FILTER_TYPE_TARGET:
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
 		return false;
 	default:
 		break;
@@ -1328,6 +1329,10 @@ static void damos_commit_filter_arg(
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
 		dst->sz_range = src->sz_range;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		dst->range_min = src->range_min;
+		dst->range_max = src->range_max;
+		break;
 	default:
 		break;
 	}
@@ -2506,7 +2511,7 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
-	unsigned long start, end;
+	unsigned long start, end, wsum;
 
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
@@ -2541,6 +2546,11 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
+	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		wsum = damon_probe_hits_wsum(r, false, ctx);
+		matched = filter->range_min <= wsum &&
+			wsum <= filter->range_max;
+		break;
 	default:
 		return false;
 	}
-- 
2.47.3

