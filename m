Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF48C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1ACD6B00A9; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D92956B00AA; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCFA86B00AB; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 918046B00AA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1185E166167
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:59 +0000 (UTC)
X-FDA: 84955935078.26.4F2F740
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7ED0940004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bu0fXxKZ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QEatb2PqGWEsTMpIGK5NyiCA2DZolTzT+XVQuw4N5Ko=;
	b=4LG5fp11u6vL+YqnrF/Dn1xbwg7lR6hfAM9MPA7YGY7lENbyiQxU/MLMAQ5mULexQOksHm
	R5zaj3r5Dgp6nSQ4gBWdkxrlDs9zs0Dn4QPv7G3NoKmMOMDkiZv7I9kAl3LkYCc7WPDnz8
	UfZ58YAYjptbn1XRsG8YchsM0fDcKc8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bu0fXxKZ;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285077;
	b=qjqkuDSYK2XBkOLM6fPsfRBAH3jvX6zrdj2wsUiiVUiuj5ElLK9/OOuoCNDB7CpuYa279Y
	OiTtCoz68KhQt3Y+UQR5PfbU2syRunBTq0j/01C8oDdDJR6OiCFBRA3Nwx9LgxQ5+b8lxF
	JSzQ8JhrT/MShxpfajD3M7LNSe7unO4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D51C443C8F;
	Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 828DB1F00A3F;
	Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285076;
	bh=QEatb2PqGWEsTMpIGK5NyiCA2DZolTzT+XVQuw4N5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bu0fXxKZ/4PUkgVIVNYFTK1AgzosC+xrKeRGaMPfoN/IwJlC8BDBms0qPYI3rE+vf
	 RwYZiwBNFGgudwzd957RdTbLsyUXskvyf9Qp88PhsSf6R/6pxnOCJB608RiC6yFm7o
	 0Cg9ypV+elSHZ5MTY/huv46qcuuhsW6+pZwUhTE9gQMYQRdhweQeRcGuS6SA2YAITm
	 iHIXeIpIx6WfS1TuySJx6DlyJLFhjpGJwKl8fV7NVMbNJxNpLmveECn0NmtDOigj6j
	 lyqh7EpKicI1bkgUwS1ZSTlDuW4MN0cLAdWBRIJPwCUwUfLNxY0dps3FqrIlLLVsuh
	 c05hvto0qrD7w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 09/16] mm/damon/core: set samples in apply_probes() if probe weights are set
Date: Sun,  5 Jul 2026 13:57:31 -0700
Message-ID: <20260705205743.98656-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7ED0940004
X-Stat-Signature: xtmcmzog56ofeshsh9p1jfa3dxr64d7y
X-HE-Tag: 1783285077-586636
X-HE-Meta: U2FsdGVkX1/xJg5VrDRkv/YMkOG005EOSsxWc6q+LgB0TLne+YeHFoZ9dxY+lGjKpNDBaB7zQFo07+SxWPeEvO4GvDp2pSJBMmfbkYqb2yu4rG1UguBZeso/++NYkTN8m81OgrudRnbCq43v8+jOusxSA8WXXOEo4d2V9DvbKt0v9eQ0U5H+jPN+5RD1R1B0+UfzD/OvXzQIleD5N5KguzWVeHy8B3JycSCCrOsztVUv37rjpCNGo/PqjweLBrB30nhvWuwvEKqLufNpM6+7fAKN3m5FjYl8z7aG5IKHH05NlMoVngGiIIO0hQYYol3OUmz4sOzoCmXXwkhbhmpyzoB5Go0vHC6jImZiNzdlhcChL1S6u8X4JlNr5jGsBOznOq8e8BttWGQn8hFz8fmwaCEdDyGuSDe1qs7MmH1/xxPoKw3LFj5iq3oCk7J3ND9C8eSHFxNHp0nRIiXnePwx2rzXH021n8nDB/V1RoPPnHf5+PLrixvIOQsLT0FoMN60D16c6PPJGNCtGEntzseNwSJiOZgMe0Xdj2TA2BduZ9sLxv4R/sWSU7UQkpebbfFVhJ8JESb/0yAORwt2PlaUi3CjFyAV8e5NgMoVW4u5fiZTreG5SmVIUYfYxftIW/axgxOH1E86q1z/pV2rmMwss1MjKejX+LPkPpLv4P/1sdZLU9tVq3ejw157qi0CwbuZd1EagsXNqUXaj2s0eH1T3CM2AOtGnYDZAVyI+iVRP+BOM0cORg7uhv+03cnnZkrelEEktI+wfVSQ2v5kkfy85GY7Rwkb3Y7heK18TdaJJxn5PApJJOKJv36O1SnyV3r/7DhgQbrfJgEK6l3BsqHRdIkZb1M0CZ3TKKbCJrZE7iZEU6Ipj1jkSl94ZmHhlE8RTTVR2doRzISusTcSQjXe0qlFYrGGN1GJ/0k2sb0dy7uIXJcNPrXKtScX/X7xFyNFT1rIB9WhnOmLx4J7RX7
 KHSzL8NS
 TlmQGlfsCvrx3NLjUaN0fBsBRT73ejMxOx0zgieIA1qe9igPG1q0rcAMxupMk9cQKOA76CGoTa6pVdF/vxRycOcBtcIw3KmDUKYZvGRFc+qIILBn3XRXZoPAahoNlNqPJtw8kBcb9amDQYjB85QF7eR1G3dmNcPIJ8I4Rj4wUV4gx/6hvXC9yLfghkNI5PsHbhSSNNbgv7Ch9nNJKaZb0N0hUqb6gAXEXvAIRZyaF9F0fNbiBbQywBwsgklFl+9TYbd70u3JaRdxGmKbKf737axtakw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, the prepare_access_checks() ops callback is
not invoked, so sampling addresses of regions are unset.  Ask
apply_probes() to set those together in the case.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ad0f28469e633..71008ee6ca243 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3728,7 +3728,8 @@ static int kdamond_fn(void *data)
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, false, false);
+			ctx->ops.apply_probes(ctx, access_check_disabled,
+					false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

