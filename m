Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC5C606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LF3W7wWI
Received: by kanga.kvack.org (Postfix)
	id E671C6B0989; Wed, 28 Oct 2026 00:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3ED96B098B; Wed, 28 Oct 2026 00:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05EF6B098C; Wed, 28 Oct 2026 00:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A63E96B0989
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:26:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CAFF1C461A
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:29 +0000 (UTC)
X-FDA: 85370748498.25.567053A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0FC73140003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:26:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LF3W7wWI;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793161588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BHxSttUyt/DDMdmQXBY+0M0nVJfrKzZZx/1K6D8VwE8=;
	b=e+bnLHj/Ah+7OIUanOfMUjM8iTUbsHtAygYQntQqK6f2WqXJg+CwiarULnsLckdp2MxrHI
	21Cco2kJZLrCLTbhv7M7jzxXiguHY+KMLzj3UM3EOu1CMipBQ0A2E9n57hN/Zcg7aq4Jaw
	FS+QTXSkCcSRH/Y+5vSHhL3wJsNNbb4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793161588;
	b=yKSEXxTu/vTIsaj71G+u0wJqq9RdU1bxxmHqH6r6gTLIpV9XczSIWnKK3JW3cgEeEutZPO
	G6LVlBenHqVhlfIJwd3vJ9/0tdeo0UAUjdbaguTbXSxVXIb+usxI83dAYuoaQOLXPSNetN
	I7Iet+5OiM9Ndpy5bcrH4WvjU7o+IJs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LF3W7wWI;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5AED9601F8;
	Wed, 28 Oct 2026 04:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FF11F01829;
	Wed, 28 Oct 2026 04:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793161587;
	bh=BHxSttUyt/DDMdmQXBY+0M0nVJfrKzZZx/1K6D8VwE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LF3W7wWId59jcmTNAK6MHACa7HHFiCTxZWoKuFxMKJ57qczc2VX4NaCDXWjgF93q5
	 cmAhviR3zb6BgwfA4V4H9AQ6zOh0ffWAWXXFGJTtpPndmKaa6zbIcoqiLMbDoEDIeU
	 n8XJ2FcfuvZrbx0etfiBK1Ozvzgqbtjz2HDdcEMAr6qTWHkdxWtsuw+lsJ8D9fffvl
	 dWKfSXGtJiNiuGgMWyujnFtS7aLDDghC6PIhksE+wol6GmLPToCmwxFGk8F8rQ8xRQ
	 NFGqnava9OpDWqAdTllsAG5ctMPC1QZDzc84ZGgcS35Z3My6AzGLvyR/ip1tZgnYSw
	 AT8bL+V4OKdqQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 2/2] mm/damon/sysfs: put target pids for apply_inputs() failure
Date: Tue, 27 Oct 2026 21:26:15 -0700
Message-ID: <20261028042617.165657-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028042617.165657-1-sj@kernel.org>
References: <20261028042617.165657-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FC73140003
X-Stat-Signature: grf8wcwr6j1mzsjcep9tcfmqpj9wn3rp
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793161587-307312
X-HE-Meta: U2FsdGVkX1/Cq5Qls8ziAHLr+rMFA2lP+HW9bu2+CwjT0qWKygyOOhTGwco+QWwSsp1blPgh14cjCYAwHMnrxMB0hnJlsiGPMh7+zowiMGuryveGEdWmRtHohqB3Jv/wa6VdZ5W0ITLesSlsfuEt8e0Djabp7VGbqKQObkjk6x4nLWVi4RZiYja+fPceX8OuKSBnc/GDFtrzliuC6YEQiFu+l0P+y0tAaSOZcakei938wCu0hHSfQZBbxusTiq0UHI3p29P6OZug9dtYqN8lXMeRjotK8LmKwuyM1VC2McgRAhGo8S6XdetJuO1hLAeC5NRjzJYDiQRuOKcep/6gpcD/rRcn7F8oqZ1nY8k3yKVgj6Dd8KljsxnMYwuRr7rG29cejU30gafFUpbwp+CUNeAolqYuZB4gSj3/BlrMGZM8ORfolOd/vMxKRH12Lm1VwG+Erq2fkIFxYjF2OwQh00NmDRj6sdq070OiwqzX9chkmu6CxtO2CWmC76eQiJPdaZzkWnFZy1BH1fzqMU0SXyUH1/H+m03Dxq7mHN7cV+zLlN2eFUPPzR9iamVTpmFpq0K/LJ7a1eyO9/hnI+04wGf7PjJRHIfehiXSZo6y/TJNwcBRMaSB1ErpU+xMYMo2ts4I61xuxLhbElQeu1hzasiCKnpVK6GS0lIJemuLucO5Ay4Duu0JIlAhRvjgKM7hgpHmKqzYYRCZfSygs+U+aNMyxyeWq/LTtMHORcKHQpQFH0F9QauWb+XjDpOIf34cl/Cm5jowpv3HBH2zIlNJoibAEGpJDDw34YcIrl0dsbt2UCpcoWyfMta6oecwrovIqZffnaGXDcm949hq/Q+HdnFNEtdCn0Ac787+JI0jtWu7OXPgeB0B04zmUAMpy2WMOQ3JjyoZ5YA2HL1C6jCy0T11ON9Y5d3ZcKAu13m3LdQt1BjkgXHEzVdVtS6WroWwdz4WojmgxIOMsiJ4+J9
 EoAuAW9y
 tnExHH4JFFJl7hYMm85vf0hFi5HyK8fKpm/T/qvoj+uwBi6rPPD7ORIFqRQl6/QnFUTw9emm7Q72khzO6/UzEn4zorz+RcJj91mKF6lNlb42ZLYSgSwhB3dJZZ9mUOKueuDsPQ6j23IzhuJ6ia0hUKAZaNQd3xo9tCjJNfEyhZymDn3nreVrnDxXpIux9tSk2yOr4fYvsBwLyfDepHVTCVN+5ZZP6+eO8dIdEg7kHoIEXCH1CocqQB3WtN9D/uK2mUaIZixCTNq7cGWXDUpu4TRgQdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_sysfs_build_ctx() invokes damon_sysfs_apply_inputs() for setting
damon_ctx object with user inputs.  If it is configured for virtual
address spaces monitoring, the setup also increases reference counts of
monitoring target pids.  If the setup is failed, damon_sysfs_build_ctx()
deallocates the damon_ctx object without decreasing the reference counts
of the pids.  If the failure happened after increasing reference counts
of pids, the pids can be leaked.

Fix the leaks by decreasing the pid reference counts before deallocating
the damon_ctx object.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260730040740.140836-1-sj@kernel.org

Fixes: 74bd8b7d2f8e ("mm/damon/sysfs: move targets setup code to a separated function")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 107a28557afe2..6ae35f55764d5 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1486,6 +1486,7 @@ static struct damon_ctx *damon_sysfs_build_ctx(
 
 	err = damon_sysfs_apply_inputs(ctx, sys_ctx);
 	if (err) {
+		damon_sysfs_destroy_targets(ctx);
 		damon_destroy_ctx(ctx);
 		return ERR_PTR(err);
 	}
-- 
2.47.3

