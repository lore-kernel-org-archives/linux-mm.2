Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2594606A33B
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MNez8Gvo
Received: by kanga.kvack.org (Postfix)
	id F1F826B05BF; Sun,  8 Nov 2026 14:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7386B05C1; Sun,  8 Nov 2026 14:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E33356B05C2; Sun,  8 Nov 2026 14:22:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBDB56B05BF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:22:37 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C661A404D6
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:32 +0000 (UTC)
X-FDA: 85412923344.18.282BC6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B2AA120008
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNez8Gvo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1FTxpkWekBlYDp/UoERMc8KBJg6cu9CB4RQQpW9Xqac=;
	b=m3hS90mLlbzqUIuHOlv5z60FfmsZ7qR7+N8cbXu8vy/43kaDO0tJ3Kymt24AUowLTcEgzk
	lgrgiRksfJ5zLe+ThK/Q5u9dzYwlBbBZyfDQ0yNhcMFM0uG9/Kwg/hlGFxkWCjBta4rNjJ
	p4wHq26BYWFoQtoGd5411n2GRCoUHMw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MNez8Gvo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165751;
	b=sg0T+qal6kbwhUgMimmVaFjwO4Y0rD/Ytdd4dRn/8gVKMUluzRTRNCfPYdwcGpJ51/BPuo
	fp4H7q8omAivuDI3Vh5l1V6HbgiFHFWQt7S24FzWd3oS8HD4O1tFQxA68HJ8e+836ZJHqI
	0bebg2e2ZWU+Mq7Gly7YcbBUbIcaufA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 973D043E54;
	Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314B51F0089F;
	Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165750;
	bh=1FTxpkWekBlYDp/UoERMc8KBJg6cu9CB4RQQpW9Xqac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MNez8Gvoa9710lsf3vMIGzAL/7zD0HV16k/FSX2nXE1SreDCo+GiB/+sIFyPldqpx
	 ynWPwdiwqVk9Em327TYzFcdBswx7bmGCsQnonb2FzKJmI1/XvsTAUfwmfXV+NQwzgD
	 40LINNcEADzBPC+Sn80241b41xnoOcf0kndU+6r3RcK3FQzP+MRvHFaNL61/rOrJXT
	 sd3K/9VcEuh4Sz09IEmvreNArzscQOY8elOD9yy8kMED/sL0KWnWEgU7n/c738eo6E
	 gbee9x+GNbUf1XuEJHj/OfLG4iV6epfLu6Pmawb5c5azkfyL0aUa2GKaqB5m1W0dyW
	 Tm7I+g/KYqGWg==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sun,  8 Nov 2026 11:22:18 -0800
Message-ID: <20261108192221.114362-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108192221.114362-1-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3B2AA120008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: isearywod9jsbxcj1ems8yrsee5xpc48
X-HE-Tag: 1794165751-687709
X-HE-Meta: U2FsdGVkX1/242y82nKGGh3Y0GBLHUFKx5LMiRD20/XMVDn7XXTNWtl1UZ4IlMImxoPJq+AZ630weWpQ55iSblMDAMrdDjxO04tDc/dhu7/mM02R/2m86R0tFnS9DE2ae3idjnBCZGMejSoq4h/6ZWfrqR6zc90i3pC/ut7ETywqoKdqgt+I/2IbBiL3CqhAUv//bsY8SguOw8Qokyji7WQqfzjfpu32Af8s/Oh3DIPYwrEMydeAORZRFQDYB/zf7yPXj85YHu1m6ubE/nq1PHIcXPhkhSbi2886obpurmxJUvslKaU6D/eWoCsTtoK0OckOlov8eS+ixI2LKDQ/1aYpjjBKkykXak+vCb/94sKyZvq+PVrmnrcOiepfm254nJa/ZQ+uueyUJLoHEC/MwmeABWZetdaiDXpgkyNnsHnt0LpZ1ejKcMH1eK/aGWyyti3dZSmIQ2s6lSWS/CS9EnkRbSZl80xMWJrAHI1U8Tm7jM+kui3psAmPX8UhCo8D+NWJpINfnq/unI8XKoKdRRwXckwQJtWZoKxNi8BGG7Q2fRbVBDGk5mziT7h/fXio7ChpqP4Je+c4kWjhcvehpzYc6zuDER6TriFm0RbJK+DkTP5WwEqhn6/DfJY+aNQtNPG8zgfjw0XpVpLtBxHCuCNhg0tuD67Z+gUsiLhFNooh+GoVQ4oTyu8cbD6UPU0DB0GWwZHLfoMR3Pem4HV5HVWKDBFTi8XwBYt1n7MawyV5RLKmaZxNpjmY33EuxuU+fP/SaxXT5v0pm/DlJhyN7hG7z4H8EqaQ4r4dpjFggeu+TBWHpxb8frvDqmF/gI9E4JZrXGU+FcRyDnw5iT4SGYJf1ENF/nh/XJ66iAquzfpcobXfjJeEpC1Zl6syDJt1tVMCIXeaTwQnWDUle+rCwHn6pvz7NPUaLm9hNJpc+PlZGxnvGMt1L6bfKNHe3mVlWvkUmNZCayo6rtZWae/
 NDdO/fSd
 T38KMuC1bRKMn06xVdYJGx+0JZW1kxF/HL3oEyk1n/JckBRz/syURWFpqlLpG5mUzFlZ5RxTj1bexU5x+TC1uUmTuCR3sPHFG8AFwftLbNiEnZO4z9nmPwtvLH5JbAS9GTRNh+eoXTCoYAadYqkZKIUaww5/1zSigdGhE//X2lILYPiI8eTRkHljMwkVNJ35fO0XekKmzoFwItgz9IVwD5ITxIW2SZLH/su3Ak3WvtXKSUH40FTavqdF36+kI1osqo2mQjZZF3n0+CNW0Wsyckb9qphP1BkDgxjdClzD8mS708xwavM6qiEpYx/bNR0nwtWfno+cMzoXj8+R1LV2MqUhnEhOsb9+5DhtPd+AcAbqpVSQMEqEMZ3IDlG1wlQcL405VOp6T0d/9Bh1SqTfysjbeJvzmXxNRkroSbhCdGUYUpTU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just works
as having a weird size range.  No critical issues such as a crash or a
leak could happen.  And sane users ain't do such parallel arguments update
anyway.  If they do, such racy behavior is arguably somewhat expected and
deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org
Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
(cherry picked from commit af19aff38d6faea35b10f26cca32d0e54f8aea5e)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 37e0a8bef4b1f..0f945ef043709 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2493,12 +2493,11 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			filter->sz_range = sysfs_filter->sz_range;
+			if (filter->sz_range.min > filter->sz_range.max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.47.3

