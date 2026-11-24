Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8346A606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCc96uiP
Received: by kanga.kvack.org (Postfix)
	id A56796B074B; Tue, 24 Nov 2026 10:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B8F96B074D; Tue, 24 Nov 2026 10:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8819C6B074E; Tue, 24 Nov 2026 10:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CE626B074B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:30:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DB29B80BE1
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:33 +0000 (UTC)
X-FDA: 85470399546.28.23D2017
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3AEB218000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LCc96uiP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534232;
	b=3VNpiHVhhA8APzQ0QQWq7TXvowBOJie0teJ1Q57aUAZ+xYH29Gp+NfjkaVAVkW01obq0Ia
	1XRNySrwURW/5NSm4Njg6t/OIQ+aTWs8a0Lw9r7kxpR5xyeJa9uEkY0t/fLU8OdtPj7iYQ
	NgJ7iTy2V6cIeziL0L0YX4eTyIXTUKQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YNJQNexJ9sGmKCM+KVg0pSCkZeSfpKeIkM9/59mzZMA=;
	b=8CQp4aJZPpXZn5sg8L0W1kPuNwpqYpz8hUNqCAMjgGijtK4dsB4njUw5eifFdQlEuTpRo2
	YEhDTuJ3wjilvGwwEkUgbx3/3gyZoUmQ3+gNJqspN9BLy7rkHo+DOEs12stzJ2/1eyE4jE
	mSVBZbCfv1wpNbm0TR1YRe7+WwWFMJE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LCc96uiP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B7B8447D1;
	Tue, 24 Nov 2026 15:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F0D1F000EB;
	Tue, 24 Nov 2026 15:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534231;
	bh=YNJQNexJ9sGmKCM+KVg0pSCkZeSfpKeIkM9/59mzZMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCc96uiP/jxFA64O7qCvVAkU7x7Re4xeHrysmsYh4xgoQDNIDzJApLsX6QP9kF2RE
	 BDX7Ez2Q0ML5sUmFU6S+D6ZbFYrOo3CSeS5ta6iPQuNtxpG1THQqCuoEZHTv+vcaDz
	 QuqioM1JN30LBDx+zJdbnIxfzaY+wKtOOWUjeB5TpHJc8GGNDXGGHz27FDevHTDo9W
	 MGIB/mSgV6qXy/gE4JTHsHnu8ds3haHqZxSUr73SqepQT2cIkYByVjJiun9xOMMU0X
	 iIOPAAffsViFf4VIdpTXcWWX8/C0DoJLSNDYO6cUoobZZ53TuSW1RKIqeN6wR3UfQY
	 4wlqJWxC9o51w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH 2/4] mm/damon/core: skip apply_probes() when no probes are installed
Date: Tue, 24 Nov 2026 07:30:18 -0800
Message-ID: <20261124153021.90142-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153021.90142-1-sj@kernel.org>
References: <20261124153021.90142-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 3AEB218000E
X-Stat-Signature: ad6ntewphkw8wxbg1jqr999cwwqdpnzr
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795534232-168
X-HE-Meta: U2FsdGVkX192zsOlm98ClfKFDP+OZti7yNPkggssphbiDBZaGVUwAgBq36lvp7kgQDizSQFLaR0ZJ4p6a8Wj4iMBpw1M1waXkwUmQKSawENYWUDTo1PuDzDHIcM3lcsNtpW2HPoqxNhjHbKoRyc/8quBt74aWoXHdGz4iIFlBpId/f/tOFeESieJlSHQ8KlFKcFm2AVeEwX3eXvTXnoCZ83Y0m3SwskBx9d7pfivk5nv4BFmIyJTOx5UL04erhPS+6npp9AzusTuTaoHUiSKxuTmLKoGUGdMN6nv+IxxCRdn1/gQxYRGfdQANMCDHgZ9dxKjHd9o6U+9CsbkxA19/+8ftrqNvLep0UQbIko1mvBHBgJzwlVholdB3Nn/RJ//gaagyrA+xTbcJa2Je9vWPlXfvBHnodandcxBBcRs4bbNxVxwJEyQ44a87gkMt1V2CiPlyIGW7g1VDhZoFoDPQeDLsWVcQqk/KJLHfwxGnp3WUTo4T+OBgb5oT5vaA0+KyQ5fWCJj21U5/BANCpttlW8F05NLndMXFtq4EmVU8H3AJattH+bE7xNtIIEPD4G4AOYBf0DrFaaWj+W2tfFChT1l+zEwQ4oEh9lbPaBRPH/xuvnk9GZBOMJLSnmA7uut2DgMAKIHR1TGS+IXJXglr7iNUCzIbUzbILN/5/zZlE/oYkQF3hHMWCvfdflBjwCrlA3JGuYbxxZpiIhoZjhL0AXDlJQKr6lv3vAOrOG+s5/s2vM66ASjKcgXQdrN8pMjL8/kmk08p2/UoBQNilGK0j8Ynr2htIxqHFUf2qX0DnxltqxX39UGiA4JIpnzvauMlZvS7gW4Eg6NnUVVMexZnqDz50qiWYizdRbwg/MeMT5W7wLSwTYlQGBbEj2OqEOh1G+EFPig+L64UY4ES+xeT0XnRZI756OnMCKnZ5JwxWL/3Njzns2CrJsa47+HunI/Zc2lR+taKGr5mAETco3
 e8ZDEZU2
 RJz2ifqRPWR6YNf/rWxkdBIKKyiuet7KCZjtJ4bY7lNyObvuNa+ojjmzkhJ+d0Zss8f1U7IiayTp02u9rw9extLRlYXEy7FxRSP8KEBwYKmrSkZBcJlXNOVDVG+NGgDmG8HJT+bK0ErOQeWLtNpPWa9IwGubN/Ad2HYPMqTKjvLJ/mBYcZJxW6Fftv/kg+PSv/DcfPppMk2Fggsa3RiP87l8k86FFzGe10VPB6VtriGaUIehaK5hq15Wyg/D5BQ+EXVPKX/9M17hpJbwnfSEnHog/ryyMoVkrGIWrREN8bLW77fwyG0qvupCXO1sLi0SjeF6Nxc7IatHV6VnSZ+Xf3oobcaRwRpKbGnzCAV92ivzUjn2qXTJy3e5Jy8tXz78sEBHnVqi8F5W+aQfcHWCA/JEI5ax3oz8rEukrd8jJjDTiCm8XkZHXelFgy4DX/QDAs/VT/hKkaJBMlOHTUb2jmqHU6IEuCN/35zUv8a/SG9yHbM5jSdEbUGt2fDuy64cW10bLXbdeW/xEd2l9/9xWvjprrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

While measuring vaddr monitoring overhead, I noticed that kdamond calls
apply_probes() every sampling interval even if no probes are installed.
The vaddr callback walks the page tables for each region's sample, and
paddr looks up a folio and takes a reference if it can. There are no
probe hits to count in either case.

Skip the callback when the probe list is empty. Ordinary access checks
still run, and installed probes with zero weight are still applied.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20261119-damon-skip-empty-probes-20261119-v1-1-ec3e81c1f26b@gmail.com
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 649a4ac968abf..74058af5567fe 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -4105,7 +4105,7 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes) {
+		if (ctx->ops.apply_probes && !list_empty(&ctx->probes)) {
 			if (time_after_eq(ctx->passed_sample_intervals,
 						next_aggregation_sis) &&
 					access_check_disabled)
-- 
2.47.3

