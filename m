Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08736C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202DA6B009F; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13CAE6B00A1; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B366B00A2; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D42A66B009F
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B6C540508
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:45 +0000 (UTC)
X-FDA: 85056857970.12.71D427F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C5AA6100006
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PdOII6RH;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688003;
	b=SHfOZkHD1ahc4Jgda9QnKfM7z8mn9WcMyZxfKCl7aOGFimI7m05K6uyymd5NcT+EFrPTBa
	TTeZ8bBFfkPMOkk6SFzNwMAzVxEbITBWzYxbYDb76yh/BmW/F567qnUl0xL2nkebr6xL7s
	9FkzUQy4kKjZRhJO42sD4BMSp9ra+NA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PdOII6RH;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiXFs5/zG+q5AEfCdPBDZKoOPM3GsSFg0ysudbMhxYI=;
	b=J1vsCQBPAnteU5Kj/VHnmQ+8UAexIubxFp7VniBPkFJm1A+g1+Izwc1Vwo0+DNEMq3DSXs
	i2bdOfdGTL0YtjSxjnFwJVRPRAZfDoQOWB9oNdAEdFZonoG1oyxEFk7DWdseCncZHBfYWX
	L/xn6E2J43rcCCCmiq7TLetIkvvkPog=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F227743E30;
	Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99A21F000E9;
	Sun,  2 Aug 2026 16:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688002;
	bh=WiXFs5/zG+q5AEfCdPBDZKoOPM3GsSFg0ysudbMhxYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PdOII6RH9kC1nW2NlNxCkQzAaSrbwyfJm9hOsB7grL0tx9y+EU0jaKwlvWNa+mWAX
	 dk9Kf/QASWSmsRah/mGqksuXYUah1O2NAwhqWihGdMzlqRwwXOrE4to+DYCVROjI+j
	 YIo7I02SZJSR7pIGX152i4Zg7eF9tXwbyVR526HSZ5wmERG6lgz4hjB4vziS+2yo8i
	 KRBRNNGdeiqYN+IMWfWzqFE/ltGTztAM6BdWa+yqWdmkCp/vIvrrsUrd/8Y3nTWaWj
	 aMroU9gExuLwYBuneUKbcTAWg3s2L0EuIeSZhznFaGjctp8wrcTN6QeFwzBkykoDd4
	 HXu5Ytki+3VAg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 7/9] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Sun,  2 Aug 2026 09:26:28 -0700
Message-ID: <20260802162631.90304-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: aubgi33eakro5tkjaup6jrkw9botxxkp
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5AA6100006
X-Rspam-User: 
X-HE-Tag: 1785688003-346582
X-HE-Meta: U2FsdGVkX1/bmJiZXHSEa3o5Tr/1Sa8jzXcUzxP3V2teRCqYt3YsaecA/JZGOr4JkeN9DJKkI0/7YeL2qt7V8ze8/jFGv9r5pJYAzZJYMtwhCjx4Lfn4BAjfdQsV8gEKFljn9fHVI/j+bqo3RjSjFpkwdjl6haFTMBGnRuE+/mEpQcQZYN5cXaHeWYBO9aL+4CKqmLMoxOP4eOiFQOaF0WGrNKWHPPj9ZFOEi3nfk8TWWejDzYZreYwnlsxc7ReoN7gRLLDibZ0CGIgEQ8SPKTavjK/OEfoKeDIKtiWHT6JudQHMQGBC4Fg2KoeSwWGrhZm4aNau+mqX5n6dTZ9DRGXjjjQfh31Ir9XDBqylPz90D5h12rtXTDSL++CHP/nONw91FWc2w4bBLR8rKiAb9vRJs9W8D+2yc8wJqy6i1iLKFvlGd/F38cF0ca1ILos8qluoAKjTVypT2ld4hUwaybFZMLzlM15HaBBhqAAGCbZwC11kKWOZRPWvJAHaUBOsLjYCxOgw1NdVy/DJ5oCClofjekxzcfVE/gKL1vYlFppILweUo1cNDvU/KuD6QGoP1VfRu7EYAKgJUIXommx6zfSQq7DKTHfp17447rzJYSs/xlBPMmYUh61u1rqL7ZmAMJR9Z+EVOESh96zX49//o2ut8rKOa5GSrnVxbOydeko73IoxadVSRnXpIBj5/8FuORaSlv08esvI/gwB5COR0/Z/TRipYAb1g8gt6Qd0cfY0z/MwnwY+DibrHUXMb0y620Ek9G6aEeBjfBEOFWcetR9ZYCoMrNS3uywp7/EVjqFB2R9ims03nhh/c7vSJMz37H+DRQHkxm5koh7U1irN5xHq+epVD96GYK3tVcbzOkwqb4er8744oOrgSRycjKn61K+wkJ4O8xtdhqM/ed0cw4Shp5nThzaZ9QKJGpvZ4ObuBk74JpcBPthgF6SXCUM3klhhajb/tK4CsxJX+12
 Em1CswKq
 +ki1ZoeJ9kKNtBLOfca20OZasF75jNvxQ/16lFJoos3tBFbmN2ogAY4N9zs2R8eHJ7rmIyzyTitAM3b/8VtZD0lZqDRjP+3iBIdOqsLsxnAyRh9IYfX5eFbzQ3STkY7lVKqjCpiDbcrNI/NWhqqiXZZX8zWMCRncw3YqHlWj69HGmn3IWJj2bqdYVUT39SGb53qFVJtGA4Cb4okOijusePmblQqxUUWL0CzruP8f4CGsKwGyDA1oIsg1Twc8TvxdL7pF6cDNri1otnR4FMS5ahCOghQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  Fix it by setting the totalram one byte in the
case.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3bdbf4fbf7147..e3f3ee75a3d33 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2816,10 +2816,16 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
-	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+	if (!i.totalram)
+		return 10000;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP) {
 		numerator = i.totalram - i.freeram;
-	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+	} else {
+		/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+		if (i.totalram < i.freeram)
+			return 0;
 		numerator = i.freeram;
+	}
 	return mult_frac(numerator, 10000, i.totalram);
 }
 
-- 
2.47.3

