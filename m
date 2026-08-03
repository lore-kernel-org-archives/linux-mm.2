Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D3D0C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 724976B00E5; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5DF6B00E6; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EBE16B00E7; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 336BA6B00E6
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC63DC070A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:39 +0000 (UTC)
X-FDA: 85060068198.19.6F989B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 41FF24000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aclTRPdn;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjY62t0IWaBhzTuKFbAdxLlz/gg8XTsDxaNCLSSWaXE=;
	b=wiDEafL0L9MBPuc/hkMqrDkhIGGoJagrY0gyr3dq2JPIj903PTLbnFOi4DjCpW0FtWlKbH
	ds/oqHsxvmfg2IrqpFf608O5LkC7Wd8Frq6uJrvAun9QdtfkXA6rjWGWYnb7JBgrbvnBtZ
	MOilYP6Cb8ABCYmPVsFSru7apxbFPc4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aclTRPdn;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764438;
	b=2KnxfpRHIWXno1fjGwlXPidJVvxTxBmTh8jrlXk+lH9Il2mV0ieKospLKOEZCiYHX6/CIl
	B+k9o6y2hx+1SF6zVG2LPuhEHdlk+NaOuDuxpgjbkT1MiAC+elOxMWDPnoziQKSkRQsNBM
	vWcNrxueho5oTuiMQBXq84KZQnc16bE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3BC360A7D;
	Mon,  3 Aug 2026 13:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5351C1F00A3D;
	Mon,  3 Aug 2026 13:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764437;
	bh=jjY62t0IWaBhzTuKFbAdxLlz/gg8XTsDxaNCLSSWaXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aclTRPdnyUUFJAaDIyxB8DfZEf7Ky7QyAimNORLoUdnJ4Oi1/Nm99kcVp7xkdHlvP
	 SgsnW/KyBf463A1xcPkJPZpmB404twh+nsEsMgR9p6mrjbC6pKACgkVr9n3sFnHNSs
	 fHk/mna5e2cimHSzTI8hnpkCAQca0yU/LLkmDRyONCpsTXNRF8mK9WuurQiqnS/XdT
	 TCz+7qyf+PFB9oogPMCcZExR22SwB6X7KKZQhF2/kW70qn1eMgxLqjrJQre2A0leZi
	 DKfAVQfKIXZAooTmU3b8XJogKd22WzKlVqk17UrCDgMrIli/QSMSVJjAgmcZhVUP7K
	 31o1Kpd3qxFxA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] samples/damon/mtier: error out for zero quota goal target values
Date: Mon,  3 Aug 2026 06:40:32 -0700
Message-ID: <20260803134034.15217-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803134034.15217-1-sj@kernel.org>
References: <20260803134034.15217-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 41FF24000B
X-Stat-Signature: iej85m4xdbdnhyzashku3n9s5fxgrapt
X-HE-Tag: 1785764438-746759
X-HE-Meta: U2FsdGVkX19zKwhSED4bJ64JsI/WLnArx0IRDNFnmSWDva4K4nc64DGvaggQ2A0Yj3/3i12vDzXPWQY+MEwmdoo8aLxjW1w5DFfHtXF/Tdr2NzfLc/VVARLL+hIbrIHFZFsg+/knHshvLbAd5s5kFAgnHTespEkZqlUFOvHLm37vaWVswtg7nVrfj0Szg/19D4YMjIcxAr6Xe0ohoZuV+28mDZomd5bxHI6QjgbGHH3ZEsvDyQiDTTNRwvgcGtsUVCfn5JaoCJ2ShuKULeGUB7Ei3o8WoxO31dAfZlZFuq5bsgtTwNCraCpzNYeP3qOO9tCMJxbPov5+XbfLrK05Kb96EzzZy/3SCC39V/LBT8GLnrlP/d4BaKvbX/MI1tCiEFTtiSQWaCddJVu9Fgar6S67sk5aNTK7ST9li6w2W8jcnCZ+0TXdhcB7AVEXAlSUluiIxZ585EmDLAPDBOTc9Zob47zZ7T/lbPfDv1yRmv89ncm2Mjt2+vqUz2gtr6ujtCoIz+QnJpUAznjXfPqabbqNnuI39/41+Z61RCG4OHH75gPupbe5bsQRf15FN/FIGvQLV1VzIb92fImO3CkY9RLUiimXeQlLNBedMjTYfpza8cXHo9px3COyBfu9IAmHO7z8DOE4oTS9XxUEOZK0V7b+eTcG8zSsW1IQEuXnzWRuJUU8StqXhZy2d3/L1tk8arVEfqjeRpIsinLZeENFpXAx55HR5xbZiDJr99ukusO8btvVO3K9DofLysapLf5mNAru8gzQPicAsRc5wnd0SnI+Uw1m1ROD3pHWFH+d/C0mDaxrKltoKYejpXXQlfmuyvmcPDLgbZl3v2P8XbqthXVjWi3933iCcXZLzwKtb94UV7Hv1UaNczutFXp9oIwYzGkBkLveLjtCqMOXO4gl0NNqSDjFDgHn3UqZ5tTiuUSaqPfeo4v1+nSGV088C9lvOjLt3ocfGYh5UC121Cl
 Sa/qlhdS
 4cUKhiyIZ25OCdZF+tD+FQwo3zHNUyoVdDV6N+ntWRZbrH/G+n3+JcHUdDJR/BZ0ixKqWoH7rSdUiLY45U8jOESJYXkdvtY01KColnM06x0xM/lXVLZnS0hcKOu6iv0JIj0nbUpMrgmjt2HfQaeCH6rxmDHc8w6F2Yl2VqddfiZyhFDN/iY9lOgMHVlrz90AEUwvF3EODITm4bbxIMbZqCXfiIL8Ts3yFkJ67HOl3dpimJCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota_score() can trigger division by zero if the target_value is
zero.  DAMON_SAMPLE_MTIER lets users set the target_value via
node0_mem_{used,free}_bp parameters.  It doesn't guard zero value case,
though.  As a result, users can trigger division by zero.  Fix the issue
by returning an error when the user tries to start DAMON with zero
node0_mem_{used,free}_bp parameter values.

DAMON_SAMPLE_MTIER is just a sample module, but the consequence is quite
bad.  Also the zero node0_mem_free_bp parameter might look like a
reasonable setup to some users.  Hence, the issue might really happen in
the real world.

One reliable way to reproduce the issue is like below:

    # cd /sys/module/damon_sample_mtier/parameters
    # echo 4096 > node0_start_addr
    # echo 8192 > node0_end_addr
    # echo 8192 > node1_start_addr
    # echo 81920 > node1_end_addr
    # echo 0 > node0_mem_free_bp
    # echo Y > enabled
    # dmesg -w
    [...]
    [18792.235916] Oops: divide error: 0000 [#1] SMP NOPTI
    [...]
    [18792.242787] RIP: 0010:damos_quota_score+0x6f/0x480
    [...]

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260801202657.117135-1-sj@kernel.org

Fixes: c5e67d40a102 ("samples/damon/mtier: add parameters for node0 memory usage")
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index ac9c24b92ead8..d1123ebbfab90 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -156,6 +156,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	if (!scheme)
 		goto free_out;
 	damon_set_schemes(ctx, &scheme, 1);
+	/* zero target value causes division by zero in damos_quota_store() */
+	if (!node0_mem_used_bp || !node0_mem_free_bp)
+		goto free_out;
 	quota_goal = damos_new_quota_goal(
 			promote ? DAMOS_QUOTA_NODE_MEM_USED_BP :
 			DAMOS_QUOTA_NODE_MEM_FREE_BP,
-- 
2.47.3

