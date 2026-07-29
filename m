Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA394C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC226B0096; Tue, 28 Jul 2026 23:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A6DF6B009D; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC6E76B0099; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA9406B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A3C41205BE
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
X-FDA: 85040405688.15.FEB04BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id B3B43180002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C5pDGgIN;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOFGYop7G5CT0IvbShe/iVSTs0keWEcjAd/ooP0VIE4=;
	b=qQOy2G5HsYCsF85Rw/B4LhWciLfHxU9lEaYvxH7YQe3uRP3PsMh2nRAS7WJpq4SJgwr0yA
	vQxpct09EQ4Q93uZGt2XXlYgPq8P+RfWNpK2T3LCHJSDfVnNQLhihwtKfuZnOV/OD4wOiA
	j8sZ3HGkMMvnpayrtNgZdaWaXd+3/Gs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296282;
	b=yJzXZ7ZhFRbL1LNzbtqcfT4qKQOn6QVq8sod033JO+BXkC0mDvGuH44I3x7/FwtKmbJ9IP
	/K2MYXU7jBlN6Qek+mYj5VGq4ovNhPo0ju6tVmMNEjxsKSQDD9iDhguVPeCLSpuac98aJo
	fYYNZZI3B20FpVvWhGtSEgwx0CPSEyo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C5pDGgIN;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F64060A9E;
	Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B530E1F000E9;
	Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296282;
	bh=SOFGYop7G5CT0IvbShe/iVSTs0keWEcjAd/ooP0VIE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C5pDGgIN1BNBNCCrOVAQdq3u/aP8trwRWE/SzIzIZ5pKpA40eYss4h0obNSblP7rL
	 ceXTtPz5LIMJwEZzsvFB7t0oVinV3pyHVEYcF7EelyWCwzqt9fIzAtZYp+LkCtPTg6
	 ePMoKBLO3qAHwznxKmBDAlOq5+E4alGg+ZU+aGGWDQfstk6cD6AKi3hyc78UbxTj/t
	 Vs95TksPCk67EK23TzkhQeHbCoi0FyRF3cJt2GASVAG2Nkljpfh9DeNrFDpzVEV3Qx
	 wGSRm+ixDkj4PLYtEr3+Fc7/7EBzOhmGU64W1fymptEsfLOoINXX6nwTFME7eyCEg9
	 o71crohI4CzfA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/10] mm/damon/tests/core-kunit: test <=0 size damon_set_regions() inputs
Date: Tue, 28 Jul 2026 20:37:45 -0700
Message-ID: <20260729033751.131213-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B3B43180002
X-Stat-Signature: ddhyti5ry4u68qai7k9hn5potzfrjdxt
X-HE-Tag: 1785296282-540696
X-HE-Meta: U2FsdGVkX199EFrVyFAI+LVlLbujhOYNj7Ku6++mx4IlLptiWjUSG6jByupULK0E5Wu2GgmCKGYEKWlsWDTCTBAglr+UG+hrGjKrbD3im79GNoTwFO4kx5n1if5r1eovP5Xtr3RkPXzbl4KLh0S8ROdvPhnCHu3RBp/jFegwGyK8EHZEaOsToPJRepSpf/vsZRPL4BlkbtcF1fbrkIe/ajXd3WdzqVo3jSd4hdeW0uqQXsRBwoH0i+TqsvgtlX9o05Afdjpg5sAfT32cdKsgWzwGPMo5d8JvbmBPx+ng6u7OG6f3man3cLS+gegLOxuDgVFhWbKbZ1/YO3zcNTE1f/DsejiEcaXyR569/8MuaXIFssDzv2sdUoHqv5GADUUNxiO407m75N2euPrsX8Cs3RlN6OFI9d0slKoo2oIga519F4WlW9d/oJUX783/0fmPI19oKZjb6YX/70tFWj9wk8UQMEQGk7EsFAZr+F7pjVTlm8+r3vSQ4xNf1hpSk5Dzz3c6YAyHYuxHJ4F9tKfHt+LdOt17S7UqdLIR5gZZ+q2e5y6Bkcs6S/7z+/AWkEtD66rL9ZtwujwwarViRD5mHUvAGXHBViVN/IZpX2XI69ykxAjk/kysz8YB+bOdFsqczxEoh1pODNkuh19IRsTyGX2KyJvw0JVD8jup91E16X0aycqUc0nClXY9VDyTvSklVorWAN1uqcqEL2BkKUC2SEWBR31DL+N9v84tr+Q0OT4O2TOVvu7jaq7BlgaPUXceM8aHViuhAw5vlqnVyHdGbxbEyLaFsdyKvRMqCGOtqF/b9Nlor4VF7yyy+MDbS1Mgnu7xocPcEFjWSwnp4M2GBRibk4R+tRDzj7PP/qCvJ9Ht7Nhgeb2XfljbDo9WA7lAKZd0vZoIKdet6q4hWimWnkZfFscXYxjp0CAhAFk6PZYFshYJ+Ia54ivjKu3X0DaWQmffRUPfoNCFeoB9fSh
 GW0wc2Fn
 k6AAMX3GQOBYrSswO86XJcmseDbIcns9lzeMfJZNwxQ2m5D64QbfBo08RDAB2oqMQyNiN6LaQSIyq2M3YSUCbgg5PQoebgB4IX4tZx0TdeIavGTNaQ5rOEkItjo93MitvU9FTFK4HTggh4bpDSROt5QHeaMuSzPewln5SUlV0KvKe2fNzNQ7QfRwA+TuuczKABURPiHWuSuxRYO4XoaVGlGyx8uLYhKRd09zUgEqu8lOWvKHlDvX6LJC2bSd6v7aNcer8XFkvkL9Bm1JXp1dP3ma0nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 1292c0ecb1ca ("mm/damon/core: validate ranges in
damon_set_regions()") disallowed passing zero or negative size input
ranges to damon_set_regions().  Add kunit test cases for those inputs.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index befc1196d6d60..ac15393a7935b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -592,6 +592,20 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
 			}, 3, 0);
+	/* Zero size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 42},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
+	/* Negative size regions should return -EINVAL. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 42, .end = 21},
+			}, 1, 1,
+			(struct damon_addr_range[]){}, 0, -EINVAL);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

