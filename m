Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A802C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CA3B6B0005; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1E16B0092; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFCE6B00AF; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4216B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:46:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 84A25C0241
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:56 +0000 (UTC)
X-FDA: 84933227232.05.73DEC7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED721A0003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAD50WWI;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744415;
	b=gVzw+7R99cnmdp3ohP/t5t294a7i8Y0n1vFGJJZOeild2GuXYDcRqlEeKDCaFFGcnvWBQy
	ITyggMYFkT7i//3/uJ5+NPYCzyZ9ElliC/vFPfCzzXvn3mpWa6TVip97us6xcxz/DbxUeg
	IbnoLyf1v1i4r3JdBcim2IaHMC/rCvo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=svLSRV5+v1TtKAkU6LuPybep7uMwQKca4/P6Ar1kw+k=;
	b=LLZrBbdtJlVD0t3aN/SYLjEuSQaWH9pAje3DiAxvEQ2BwP1oaXKIKLgy8ljcFY+Krl7nCQ
	2sAxVYI++8nzt5EKGB4CCbj67QIfg0VKrPad/UnHJoEgI+w64zxlsiyyHeoSEUdQieQJsa
	KuefQbjHA+E5s1ULRIi7OBMd9HE0wF0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IAD50WWI;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F6E3412AF;
	Mon, 29 Jun 2026 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC6F1F000E9;
	Mon, 29 Jun 2026 14:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744414;
	bh=svLSRV5+v1TtKAkU6LuPybep7uMwQKca4/P6Ar1kw+k=;
	h=From:To:Cc:Subject:Date;
	b=IAD50WWIyFXg021KYJrKVqnI+of89mmlTSbWh/RW4ZYIs/eOGjIFA9X0f0TZCqxWk
	 BBQ1VQ+Hu4rUoGaNxktmFdXXaymIrOfbhwYHyzIMdNh58sFKhqOEPfSinO26RqgGeI
	 AB0COGQyob1YpARJ/6QElQuT+Lm0R+QnM5AcZ8pGDKNn0WP5ArcNdceBXZnV6z6n7M
	 DkGD0x2ojQuTFwO41hRkNCCaYRVJmD9U2d24yCfgPSF6dn7i1p4wWM50FlL4y5ACyt
	 8oVvsQwgekQ5JNVkTHXxgYR2tkIJ9Pq3CId/LqNGi1a+tZ6cb3OtC5hNGGAu588eGK
	 +h1duhrIhcKAQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Kunwu Chan <chentao@kylinos.cn>,
	Shuah Khan <shuah@kernel.org>,
	Wang Lian <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] selftests/damon: misc fixes for test bugs
Date: Mon, 29 Jun 2026 07:46:43 -0700
Message-ID: <20260629144648.134092-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xetonroe4wzn4ram4ct6jk56ofntz8nx
X-Rspamd-Queue-Id: ED721A0003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782744414-756363
X-HE-Meta: U2FsdGVkX1/cYmkXmHcfoL7VQS0NrrL2XkTT317NVVhkq1/eRbV16Xd+QptA48OMKwT/Zmj9gzA4tbpV9kVrsBmqcAsk5LZr1ZlwAd+m8Wq9XEeDyg7LeyDpd4WivdS79GGqPCVKkj5QRwH9sILs33h/t4SERAzYVczawbvJEBb6nWGEeBvb5Gli8j6RqVnln9777mESSPQRkmPd/BxxQx4NLiemTXxK4lSGBkuOwgM9m3pRGTbcIJQPPkQfCQ72eSpiPN3eVQUTiSZlT7thpeYUhF9HhomIrfP4ciQRERS2VmDt2Mddu8fnjcP3Pgw8vwSvQoOmcr7SkGa/8Gxd80VgtOIvP68EmPM0C/J3ihLBSOdc6I2Ra/OLGKZiApwRUXT8NcIU/46MqJI+7/losNHRfzEmv0cIlGhZEuotC0SbGYXsxLgqHj6uD9C2gTI1aNZm+3rljNG+Jka4hqOg38i37QBYw3TfaWsQkLbcd0Mq2DpeXhkodk/NZnfKjhHKBsMtLZ6sdXU+B/HxqnGf0Z22y/3g8NvHlwpS29zP7k69CDMeqSMHUX4tWCij5MwMV0C30BsixWJLn2TZAVsedmcYM7HChkKTaY3Yn8zi/2EjnDW1aTG+EcCIciLQPfIwu4UImuOS6fC7vgb1CczyhQbi3vK+TsOEGy87tEUF/JSWLS7gMb5sdizzu3Wk9of+FZ3KhApVJlEFg/1Crv4NldhdW1CDTCGnW8aeAC/1Dq/l92uWxwnwZpTksWayjeL7k782cVMEA22XWB+yHGvRckVva/IwkGap6rg6zCYDpM7WuVZ86JTCqMzX+1Ud7Jubv7DG3bW+kRz/NOdarmFedTByFB4IlyEL6ArHnsuMa3n+mWOPtaerpyL/m1lOHgO7OdVcCmTxG34B7CNmHBlG5uReeAdTbYQf4KOGqkT6IdWDBLat8Egf8z0m/XdMTf2qRnNPqEZIUX97CjXNfKY
 VKR29Mwz
 tH555/q1qiw+Kuj+ZpDV8qlzv5D9j6Mz1VYa9mrMzGDSTJrWEaHeTenTTyyk2i3529rgsYbcvW3bFxzizHqnXgevQYqbM75YINTBqt0yGbbXgyJzFx7/CU6Khtw1/NyCqU4h4BnoL8JcnioJbW3wIpI5URzNSMK9CZyJEvsKk3YHjL0NaC6OXD/BQVcIWYi41jYz7pm7/gSM3MBZMvlqYq2UsGVqaHs7nHL/nbqUeyQtElkbMqHv6zr/FZLTCntlRz+KqM4Cwje7kUNqyJg9btAy95oJuvYPB7zGMP56T6fEAnOPWQfjBKklzcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes several bugs in the DAMON selftests.  Most are trivial
but makes test output wrong or even silently pass the one test case for
'avail_operation' file existence check.

Patch 1 fixes mutable default arguments in DamonCtx.__init__()
that cause state to leak between test instances.

Patch 2 fixes wrong operator precedence and join TypeError in
damos_tried_regions.py.

Patch 3 fixes several wrong strings that produce dead elif
branches, skipped file existence checks, and broken dict key
lookups.

Changes from v2:
- v2: https://lore.kernel.org/20260601032314.424013-1-kunwu.chan@linux.dev
- Rebase to latest mm-new.
Changes from v1:
- v1: https://lore.kernel.org/20260531085633.48626-1-kunwu.chan@linux.dev
- Fix From:/Signed-off-by mismatch.
- Add Reviewed-by tags from SJ Park.
- Drop the duplicate memcg_path fix.
- Drop the empty aggregation-cycle retry fix pending root-cause
  investigation.
- No code change

Kunwu Chan (3):
  selftests/damon: prevent cross-context state pollution in DamonCtx
  selftests/damon/damos_tried_regions: fix expectation output and join
    TypeError
  selftests/damon: fix dead code, skipped checks, and broken lookups

 tools/testing/selftests/damon/_damon_sysfs.py        | 12 +++++++++---
 .../testing/selftests/damon/damos_apply_interval.py  |  2 +-
 tools/testing/selftests/damon/damos_quota_goal.py    |  2 +-
 tools/testing/selftests/damon/damos_tried_regions.py |  4 ++--
 .../selftests/damon/drgn_dump_damon_status.py        |  2 +-
 tools/testing/selftests/damon/sysfs.py               |  4 ++--
 tools/testing/selftests/damon/sysfs.sh               |  6 +++---
 ...fs_update_schemes_tried_regions_wss_estimation.py |  2 +-
 8 files changed, 20 insertions(+), 14 deletions(-)


base-commit: 1f7264da0cec89427b167cc51930dd8c169dade4
-- 
2.47.3

