Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74259CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611056B0096; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 577306B0098; Wed, 20 May 2026 02:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F276B0099; Wed, 20 May 2026 02:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9F96B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA6DBC0727
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
X-FDA: 84786820902.30.9B44E2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3FF03A0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZHxq3jQ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lFIspApNE5pg+37NC/h+0JPjyuQa8BCwW93puC6WNUA=;
	b=J+FhsTs/k4KH+rqVghHW04+3CbFEdJf4eLGhmD5r5MXAaQL32t8UUVxKGO/WqUHkL39xBo
	DQfy2yhbRjTwUOAq9JCovXBiuatKzPYuLyXyruzfUXz20Q1OW9rC44cQeqfAc1U4K7ORqo
	gIvNxokVuXKaJlG0ZZmpfS332OKGCP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258550; a=rsa-sha256;
	cv=none;
	b=OkZuUbgLxIrtYi2+f4gWb9zeyEzQEd8XlNeWKGbbbgLPQKygHfJRzrmJ4qLDfFhbvnaZ6s
	7wf9OaUQ9Qjjsh20EeZb7E960yucB/V0iQpah3V1PrtrfpA/7mslbujGJNzn+yWqTfq5sY
	cf4ina2nmrUxHtgDBdhDmTPMfWKDERw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lZHxq3jQ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FADD4433F;
	Wed, 20 May 2026 06:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8481F00893;
	Wed, 20 May 2026 06:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258549;
	bh=lFIspApNE5pg+37NC/h+0JPjyuQa8BCwW93puC6WNUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZHxq3jQWCrHS++tn92TnVdD6zBgrV6BBPNn8Ha50C5DypTJaqZKG1NuySYTb2i74
	 o9o430sNdQkvVKwvb7izM6f+bWMMZjzbV4Hx1p4mbsCXi5VMCGCzvu18HaqezGgpEm
	 k6Wbal/09nScQxMs+W0gGn4xtI+NW4Na+xjyU2cIusnzIKmJaZ6L09raKbekpkBjdK
	 J2RSXQSZv4HcFSjjiY6/E7vTPGWtkiItWcn1NosDTw0Fcyht0yi4k0bunPoD0bhJ/z
	 +9HiwplnJ4GDp4zHvF1MsZz4yGKdbjWr2FynWifqdydze9TJKmKz4NHpMBmChTvA3Q
	 DYSWbT6OKQyRQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/14] mm/damon/core: hide damon_add_region()
Date: Tue, 19 May 2026 23:28:37 -0700
Message-ID: <20260520062858.167011-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3FF03A0002
X-Rspam-User: 
X-Stat-Signature: jzz5ydi9wdxhq4ur78811uawsj78gftg
X-HE-Tag: 1779258550-232584
X-HE-Meta: U2FsdGVkX19SevmwoBJ9E1IZ3MOChjDpsM7CmZP9mBcNeoKy30buIttncARN+/oBPfTI8ahLfqEOw0HTJEh1XpRUifH4qKRHgCOarJ5bsNPBa5dAyTmyTPR2nxRaaN6tgbbt0y5EoPiOYVFJDey4FiEMox10zLFWgo4Apti9Mr9zcpaOOuPDtBtDo4OXiatCtOD60I12JOJOVKi8vivz5JE5TmBYAmh43I+sajGhaWAFsVEGH+AwB0Eg7sct/zC9vMfO8q8MrfuvfG/GcFtDmKBN2/xVnLENLQZ2vukS4fP7cJJsTgeeMvdcVSyFXdsO4DFUqZipE3iew0LbXbrKBFOYFrcTpQTboJ3t7BvBqRmxhG8ItKffDWRqHpVC0ke0eu3K3xNAgG3bHiC3cxS0nqfyvA+oZ585Hmlkwemcbztv2NKTe/SaGKxfg6hdKpmwz82fP9+j1oB4Iu0Wx5InVw3xFKdIw84WUHmt/pIXPDpGd1rOFbTShlzWtcKYr9o+dKXFDFeFSG/YI0gAAHcxyYDRQtW7CSPJWl4cBPvEPY0y0C7XNC1B3hldl3dZvjiNimub6an5gc9tpDTSb0xQR6UBSGyMRYq4WTy+SFR18nFYrUIqd90//sia170BqCKjBgZEGsVHEW7Y6G8LB42GXQ6rltdn7MHZVWBhumI8Wj0TNcCttL5OupIFOt3UhKgfiTOAz7Au8tdKAmqbQDrSG0HCWyieb/cyxfj8u8JJH2AGuboI2VaxXm2Wys7Vwdp2IBQZOViQG3PbCE9JPAs6KfDC6+Q/mIphjSnhpQzHA46qqjNINErCD26oZcmMRqlhgU1lUYin9+E40gySMcmGhx15E0tWxJABOR3Ds0zqB6Kp80JXW/hXZNIxlM6AatezSi+bRVsVTYvgae9QkmAaYulSVXCkT+XwXFLAo90a+DfX4z15Bip8XxTzKOEo+G+BIEQbdFU7lb+nB6FclgZ
 4+/ee5eX
 8jrB0dICPcj/3RUTpsstK17FgWYglRckHPlqYNL1hglUAp3sba3RqKKuo1N9IlOSmZyLD8RrTdTYw+VhzlsG8mIE4ynDqrNVt4HN2AJseZbvAhBvKNRax9+bprb6ta3Hz8Hw0EEPumRcvzzOtLZTN2higbqAGD1Y4Qy5cM4TVjOORw19zlqPCqbq6D9gvAst4gQzaIf57DrUMawLTGoo59Rt9oL/tgwj3kDGiFRhHwXFEARO+ewtLhx3M30v/eoO4fHFNFHzaVz9liB1Jx9iQBj2ooHgCepK+vVcwL8s7GBaXAhzWmn0IR51OZg==
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
index 4014fd0d463cb..b9370c1779cba 100644
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

