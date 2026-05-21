Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED366CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1BCE6B00A1; Wed, 20 May 2026 23:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3E06B00A2; Wed, 20 May 2026 23:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9DB6B00A4; Wed, 20 May 2026 23:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C37366B00A1
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91921A04E4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:07 +0000 (UTC)
X-FDA: 84790058934.02.F3B4C13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 05E7340004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PkR1vu+3;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q+fxjZuCnosHblIbwlECkpSubPFTTaxfUpkwZ9ZxQM=;
	b=oUZKRWD4FK8sEOa2Pj7miD646cR6roj/FRXgAr4FbKtoyJ5GVb8YYlXoqspqkTpQ58vg/Y
	Q27rvOj+HbsJu4Z4oM4Cw/X8I4tRAK69WOpmBtUKy9p5c8ah39z2SJLBNZVgNGo/WZGda9
	XcxJYkIQ8ARGi4j3tr+w09WWi3X4eWw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PkR1vu+3;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335646; a=rsa-sha256;
	cv=none;
	b=ikhPuaUdvnMw8rRf9DB4NhmRNFaHhTIrmWR59Bz24GFRtXUNX6KJtqS5/r6wKR/5tE4EUE
	k7Uxf7sJTUPbaF9rcLte3RADXtpnrPJ8hm08Ll0jm3c2w5eFCX37ujkg6g486y1mGcq1jp
	KcPLfhWw+V0XXC/KLyL5beCurqgQ+EQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 587EE445F3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05F741F00ADE;
	Thu, 21 May 2026 03:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335645;
	bh=9Q+fxjZuCnosHblIbwlECkpSubPFTTaxfUpkwZ9ZxQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PkR1vu+3aRcBKH3ROFFcXnfnFaEUHaQnqfOb79thz1yVdKKJZS970IEJnfnJnS0Om
	 dsbNih39v3N4Ejs76zJpSpmO3bsoNfNXWVqJu11et0DoJBZL9UoN2+RysPyEMIAGfB
	 HUMAIDaI8MobvdhIPLZPJqzliNLl2TT6T2i+qdkp2ol2+w7mc/rkY5U1l98Qs/vi+I
	 VYxx9xG8FT+0ppyYjWJ/j8o5ZmYEGd4Vy6lgRinjXLJ5WxYOXxJM4znpC4JiBkVjB5
	 Xe8jEizUZ3C4EqQGepZmFNsUHV8xrvKOLA3btRC15DMfPR9j2YSMC2Nd3hOXcgIk2L
	 fAK8oO8Rd76HA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 14/14] selftests/damon/sysfs.sh: test pause file existence
Date: Wed, 20 May 2026 20:53:48 -0700
Message-ID: <20260521035349.87565-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9iy4a7u69akb996qqy7hy4qz34y9udp8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 05E7340004
X-HE-Tag: 1779335645-33758
X-HE-Meta: U2FsdGVkX18YDRcd/xnoFlikuHTHPMMcQl2QU2dJ13GLfVaXDo+DXTAVJR95QhUgUJTHdPPzpnQVeEVx+TMojsDSmDWooqBBKR6u5goIXti8V1oDQ5IwqWKfatGoVzAQ4Ib82Hqyfy8xlHOukTN1JSi4nngoFiAHTUukVhfeNnFG7/d9oMJIkJ9/KA3MfxL6EhQozOCwmM83aBgu6cmY7ceDDNCtsLyH1pdqZIgSU7MCHx8Cc3Uc/dH7r0kwe3t/RGCsXEzpTshTB/GSOOfjwTWR0LICe0Wpjw/qClVJhP/PoKkfjEU2tbLujlW5YbgP5PwXlyu39oZ1cwZSiO3RP9LSUvDbYDOByRP+GcMECZl08UIbL9eMNe0BNkN6P9zE0xItA+ytA5lUbjJf5s28ZJOjRBmLiwcTBovsdfiO+G+Vaov7QWicSGB5Ak68pSzinkLwK915jxduTZVlCjW3lJxCuGM/swVu8xez+LxW59rbt3Qojrb1o4wtXKh2B3VaZvBbfFqxB72/Hn+HMVit1w9maUh1adZvroa5LxyUc9htih40lUNioWYy4JUYkd9kczZoMXp1xy7P3uZTuXdkTTQY+1OyL3NmE7romFw3yVzZ+5o2Mb/lSEwy5w/FJG3+HHKgewO2Gliz/nTE+X5bug8L80SqsLccbtkZPtZsBthmlGua8je401oaC3EnMYiD3BcbM5KT22rXLrPKADXlipcHHBLE8PkeweA0x3EIyCGXHLB7WR9ERiKFLZGeSkTSEQ/W94i2YK41VMPvpvNbj2pZnMSgD+/DUs4EuE5X05x/fwzStEn8mUzgH3GwhT0Bl4cjnWjOMkQR42+pbXVoBQoBKsVsZQdj7bsT1rlbIO+ZZ+0eK/hAiXc1jvEs7LD8+s8Os8/VAF0JYHW9MRVMjAvlSYYFj4Wno3fVUpBrPE1YwOI/sWi4YW2Bm7GW3ZHgPxsl7Qy/f4OFfZtJaAU
 oz2u1U4S
 giTrH9yA+GpO8OiBtbEIYVUX3lhfV1K26UqO2uKkxc5kL3r85MktefgjurTatVWuphUdv1xbE6rtqkZBpSZ47MdCfu63048zeatt9wgaIGyyQWJNJ0tF8Bxz3DdlojKT1Nd13hSQ9tqk97s1Yif/zFiJiLSWGGvDNN6AuAR6UNwmuuNHWUSNM6B0LG0fkABJnzOhV6zhyGH8qBQJslCzEXYRrpncduoJQPwoGvpLDofh/j4c3uycWpsnOHUJGVhP8N+cA0gNg9AMxmYbdObGXzo6X8Pqm7Qhb8a44OjoeofE5RrI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing the existence of the 'pause'
sysfs file.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 92b44c86818af..78f4badb5bebb 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -366,6 +366,7 @@ test_context()
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exist" 600
+	ensure_file "$context_dir/pause" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

