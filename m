Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E51F5CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDC46B0092; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920226B0095; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74C026B0098; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 58C846B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06AD812017D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
X-FDA: 84786820902.17.712928E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6420E20007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwoCbvpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	b=s8wSU86Y0W66gXQ0lFdUK5euYzJ6byxCxeZEETzj8y6i3cH2dsc1PKT3uOMpOF3z9Kuyx8
	5nxnN0jjK8BCOs5BbO/ECx9JCJrrxBjgQGnzCIn2LIhMZQQ9EUH8CL6uwS0xWrVsjdQ1fY
	NQMAlfbD1yWEtJmy0LfFv3TKSJR1YCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258549; a=rsa-sha256;
	cv=none;
	b=s4rP3thPYpnTHv4bqB1ep08vVXfIQiO+Z+x3if0sSDhs/ad9/yWg7wc2evO0h1zY/1Y1Es
	OFsGwwPgYikjfWkJK4LyMAp9txu0nBvbCjmwF3K7RKwh2VrRVhxfcLPGRGFm6NmamyC4lg
	nSr4CtLqfL68YvehVp8ax966AZarkys=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RwoCbvpT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0B29601F4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845ED1F00897;
	Wed, 20 May 2026 06:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258548;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RwoCbvpTJSm+3gjcI+kXHqIadRx6WgRIL0CbfBz1U7AqVWHK3cxvJZmFyrN6ndDxM
	 KE2SNvJOIGqFGn7eQnkZblRsP16GQ4VkZ3dC94e+jWm9iWesUFSvyzBaLG2z87g+xo
	 CUB/7hxEIZg/guhyDPMNR6YKgm+cGukYESa71JCAZgws87Bf7d9X2t6P5G6sH4vPiF
	 LpGIo2sIKVoWwA4wvwULsy7rOzD9Ees0JgvFaYoLRt/KFEHTJK+4rqY21/rIjXQfxX
	 AgXRsPqU9R2B8Mj7NI1jup1/3se0G6/Cw8yR6j3H+ouuw/UtHtDn0aa8pouCGPR2m4
	 N3IP4pR3GNMUA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 03/14] samples/damon/mtier: replace damon_add_region() with damon_set_regions()
Date: Tue, 19 May 2026 23:28:35 -0700
Message-ID: <20260520062858.167011-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6420E20007
X-Stat-Signature: xkuc1rcjouq7nztrcyayab6wi3e7uh8q
X-Rspam-User: 
X-HE-Tag: 1779258549-326738
X-HE-Meta: U2FsdGVkX18LhjMAfL8DDr3OnBtbs7iNvrPmIoFghNZ8bnFoD+t+1hZIpe5bjZ7mZXPbPRbkxNLn4tJVs7gF3l6s2y4I6OiV6MHhgB4I5NX39GhVQis49SFR33Xux6nthSwMvXK+56svIJ6LP1fm/25RmPFhZwzqaZvPYPoiKp7Iwa0mgXRCNEJU53on/QHIfcaxULOCmytitRw4xhYcFUMtYkqQhlGuyNqz2H1YQkEE86KDtDGVq5d/iWR/Pi/4wwA53SkVGGJxS8ZHsVs3Iv1+H/OjTA12FA/o+jRW/MiEGLSgOWXGaSKzBUEL8mLpjlHOZH4DuspA70YRHqRNei/bHIMJU3Q6zCSWkI6EnBUtQi9V4xayMUp5XjovQ+fTHKqTh2Nbp7XgP8mZQDzjNpUJN2PrMVCumJKyXgFTXx5Wn/GNTaAkbtr1bHrwYp93gXuQyMUtdHmt5sHGd9gTsX6LOkcYm66y2kVcb0KhYKlCjVQl5V4/Q9v531wMwwVjEwaDDPGIkxBMbKUzpQFV8JUOmnCDIuAG34LpxBdhN2CBXnX755eN2cfIYN6/zB5TLEX1r8LLwU9+wUY0jmCsnVumpHKHY0jIRSJ9uzlaYlSfjdXIIxcOgAygA7MeI0/dF+UTzBThRmpw0B6XNgge2kfDjVrFrWmps66ggduU9eAdUZ678hsL8/Yzsgj5KOzP5zL+lRzvXwKXgioT5Kyq/8TIHv7iEwn//CbUH7OCQYWRS0bBC+iRwRDlFLbxZEf/sgxWE6ruAJTBU35GAPcRU/4//xjmC4UlKST6rlmqxDpJYq/2pMXHKm9ambS2HRN+l4yseJXkQjx2FYKIso/nCqXXzqGwbtMLcWth0/cHod5Maq7kn8aikE/9nEYDPTKrdeA7fm5SHhTJUla9gCPm20t/3td+hapAfu+0WMGY076yBx94YqkY3LGMBRNapYoxlI2779odms4OMGAt/N3
 JkDiGCFb
 1qSqg1lP1ngxejH4N7jTFXjJrz7DEIZm2RBBMqCEwEMZOpmthAeDxEuoACW+5r6SMb9H/rDAhEKCBklIlqAGNX6LEAylfdOPtVkcGvGoSGFzzOracyflTRjx8ffHtOvUse0XSXJRu9CZC6OYa9WDw4Hsqc4ZOdKaC5y2So91DQyNEde8z6LczAY+YJdCRuU+AgvoU27GDe0vKXyOSZ1ZAtpeZU+r3tsIW+zZmxJ+NvKyCBi+/sr4ipB2qpcuQJxr7bN9aG32wiVZSSGL7dQKFZ0WoTDWNKPyCXIq3ydUptghzmG1ODqdAvsaK2jBm6Ua9vrj5vcIreoD2zBKi8TCEbcaQYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mtier DAMON sample module and DAMON virtual address operation set
(vaddr) unit tests are using damon_add_region() for setup of DAMON
monitoring target region boundaries setup.  But, damon_set_regions() is
designed for exactly the purpose.  All other DAMON API callers use the
function for the purpose.  Replace damon_add_region() usage in mtier
sample module with damon_set_regions(), for unifying the use case and
reducing the maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d935..eb1143de8df17 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -75,11 +75,11 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	struct damon_region *region;
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
 	struct region_range addr;
+	struct damon_addr_range range;
 	int ret;
 
 	ctx = damon_new_ctx();
@@ -120,10 +120,12 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
-	region = damon_new_region(addr.start, addr.end);
-	if (!region)
+	range.start = addr.start;
+	range.end = addr.end;
+
+	ret = damon_set_regions(target, &range, 1, DAMON_MIN_REGION_SZ);
+	if (ret)
 		goto free_out;
-	damon_add_region(region, target);
 
 	scheme = damon_new_scheme(
 			/* access pattern */
-- 
2.47.3

