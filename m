Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D970F3D5E5
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 04:39:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA256B008C; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979C36B008A; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F37F6B0099; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69DFB6B008A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 00:39:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1672AC1A53
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:39:08 +0000 (UTC)
X-FDA: 84597845976.04.3454DF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 852A88000A
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 04:39:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aWioIKs2;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aWioIKs2;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774759146; a=rsa-sha256;
	cv=none;
	b=PoB9/LzPxwmRLpEYk9D0xjG2MxSJoRTN4/J1lS2vG9HypIhHOLzSn+/hHW6QAv+dki/aYr
	C5FE8HPiCbgup7eH1Cv7WEfpgys8wG9i+oGTKUf2IiKWqewpliLkcGgiyuOU3x0gsWGUTE
	A6OcGRIM73MhovR61goU3nP/RJ/PQTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774759146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2gfAlNG5U04l/q/YgcKWhVkzdECVNPEn8D95W9kAsAc=;
	b=lp3Erel+TVRGmT4vtZzFPdGnUFlvQHmuggoMHb0Q4Ozxa6zx2VF1SIse4ObIAOmSvWaAwo
	AkVSp0xuvTCy6Hw7qiv8y5fRhS2zEhnu2wokWiENvnyjqtS5oOOOJxn0Q0le+Ltp2uakJU
	YPEj2NwrLtT5ctqe7Y4KQIyV5RVn/5Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 50FE8401B1;
	Sun, 29 Mar 2026 04:39:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A376C116C6;
	Sun, 29 Mar 2026 04:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774759145;
	bh=kObMod5TMzaMvBn9+D3aTOIeg1hrGWniApE2U38771M=;
	h=From:To:Cc:Subject:Date:From;
	b=aWioIKs22y5/mjG5KKkFStFFpJNa9vjoB0awkplXzZnZQ+qMnq+DHQ2einzBTGE64
	 TlNDNmpEM7xhLmGqU50eaNVZXljG6odEw4tshT/VuVjAQ46+2gr1xU93LJVkJEgPts
	 b/8y+p3vLNKAeEhWqFqEOrxCWcDcVwspHzbDEq+/NBFLT2PrBgmmvQnyC4OfJk1AC6
	 lcgppInOTlztPpc0EQVdEZYTePCAqS17O04KvKACukJnvgUFksEnFqGxoI5iwtY7CN
	 RUBRcD0nCqcwiD4QJUKzemmJ9+ck8qNMbGg4H6HxOGmGJsWniSaotfiM3bv3lTJNgk
	 zLCYk4dkNU37w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/core: validate damos_quota_goal->nid
Date: Sat, 28 Mar 2026 21:38:58 -0700
Message-ID: <20260329043902.46163-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 852A88000A
X-Stat-Signature: sj1wirq7hfq7qrdzw1zbad4ebdpbm8a9
X-Rspam-User: 
X-HE-Tag: 1774759146-381804
X-HE-Meta: U2FsdGVkX1+y/r2029jzyKJ8s787+Mtv8Zweydc2vSEKddJlDkHbTEWaFxik8mc9TdkCP8zVxJgj053q8yzeBvekfffkoPZ6Po/aOikZQQKBosQRVJGNc8yz79tPrYaNT1iDeqh8H95pChjRBxhF+vHZkQxTXzBUeZsd6HPjGqm8vSCW6ZN8VFCTSu2Phr66JbKfYc63qadhJ3HLzzuwBQQ4s6DFqPIhpTwtXe6isJGHy8U/rL09nAgCkSFdA8Qh2AAmc1dtucSk5wVpHT2eyCVsgJIeRPV8TtpN1NsdejWlhgLLKm1pLm/gI92RhrVX+ZG2S/evk11XkaZvrpvKw2w09B3DwgPeQKsR7+AhYTxLn9f5dw5ENkfLpv4myX44Yg9YESQjFfJYrv4F7N/H0aJkcjTe3HFmlgYAbYsFEDlY3Uh8lqkLzymDjDsm5ODwm3ERWO1TAjMs7Ydf4HXAMtJDoTLhIBckzG6a0dAmVzwAmP2AGoTxI7NODAgHUTWW5DD92lQ/eSexLmy/HcbCOT9idL/9dmhL8uPBcbkxJlz3VV+JuOnm/Hm/YT1sDM6yeQ81D2Mwg/t5Gd6k7DN5IC+hcz0aOvZvyIxE4jj/tUT3rk0UO58/n73XHFKN8ZyQGH04KhCw/e3GiQveYvG0L8YwiTjU8K+R/x0CKbzeykJsbIclFiUJqccz4kznRwRnA3FRN6BgM4LhD/mYStYBb2uDHisAgR5R47mrCnLm7MgoZmsPaWQZejRynI6BHrxVFpGRqtmX9mNhJVohg8y77BTFItztZHe8gP8UU26xbHxedlBzpxxmOcB6/qgOEOd1n0pErLj2mKujHxwYhC5YFBDSXQLg4ekd3HULNN3an25ctWdNqfcRYMtKiNTfUgWEc5YpRSSK9O2Tc0mIR9FZktlYcsdZkheQOx8p5C73gdqwjT+UxlFM732JZgCQpyb2dSGN/auKr0GPBhpmTVm
 Hktk1L6h
 0myQR+AtOto2NFk1QQOSxcgC3wmsHjqZvpHok+xL1TQmehAniccaPfYq6VF4aDEK9/3iVsxNEP09TGOYt8ca4Pxqw+592rX4x+pJ6nPszkgIJqvi/Bfq1O9FG63A2WVb2/fr69W6ebis9na7yo4tI5jj+PgdqH4c2+Tn0FrRe2KopNLcqFTMC0MFStI2ATQDfkGoumF1G0sO9UoLZKtwE5X2pk7Pgd45pFvJLtCWfFKoqyA1YZM2ieKdr0ilh5DZEU9DJZZuSMw4D1qoSQIBykFwgsU4z49SRWFnJKpTp0l8Lk5HpzDF+3ijRT3u2WIlJri8uscGv0OsLymw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

node_mem[cg]_{used,free}_bp DAMOS quota goals receive the node id.  The
node id is used for si_meminfo_node() and NODE_DATA() without proper
validation.  As a result, privileged users can trigger an out of bounds
memory access using DAMON_SYSFS.  Fix the issues.

The issue was originally reported [1] with a fix by another author.  The
original author announced [2] that they will stop working including the
fix that was still in the review stage.  Hence I'm restarting this.

[1] https://lore.kernel.org/20260325073034.140353-1-objecting@objecting.org
[2] https://lore.kernel.org/20260327040924.68553-1-sj@kernel.org

Changes from RFC
(https://lore.kernel.org/20260328005412.7606-1-sj@kernel.org)
- fix typo in patch 2: s/MEM/MEMCG/.
- rebase to latest mm-new.

SeongJae Park (2):
  mm/damon/core: validate damos_quota_goal->nid for
    node_mem_{used,free}_bp
  mm/damon/core: validate damos_quota_goal->nid for
    node_memcg_{used,free}_bp

 mm/damon/core.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


base-commit: 2f8cc7995d75c89079c55a85fc1d3092ffb7bd59
-- 
2.47.3

