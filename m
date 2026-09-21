Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B441EC982DA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD6B6B0095; Sun, 20 Sep 2026 22:00:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD3B6B00CB; Sun, 20 Sep 2026 22:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA8B6B00D9; Sun, 20 Sep 2026 22:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB1E6B0095
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:00:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A60F712055D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:00:23 +0000 (UTC)
X-FDA: 85236114726.21.45C0A4F
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id EB83440005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:00:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ntcW08AW;
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789956021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Dl3X5lIuCDCuxRfR4V0ReBm9Zl+q43AQqD3mJ2yz/dQ=;
	b=opN2fh3aEU9mh9HpMJ59K1V/ojwcWHZ/3nyQFIdDdVCRIKWny8wFV1n+CDsJoqoUvcl9su
	uOYyR4ZANgeX1LdXLncotswDbIYEDCCetvlAnA3Cyo5whDKgg7LOBI2kGMGEP7jGCcQT44
	+mjzJjLFvvBbhUljzVWDb5//uhAG2Zg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789956021;
	b=xW+tK6tw0ktwtdvkJxRFen0Tj0qat2Q41Kx920dIG4V96FnXB1Kmg9eCrZu62WV6FlgBwE
	M5Cdw0ggCEwKV2jrRizJiV+RJIH41I84mr3QHcjw4SVCaq0RIlxel+PWoNbu1TOgw3nwM1
	CIbXlMFIPVt9m2nJkNhH3EeaEsPtdRg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ntcW08AW;
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so11925655e9.1
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789956020; x=1790560820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Dl3X5lIuCDCuxRfR4V0ReBm9Zl+q43AQqD3mJ2yz/dQ=;
        b=ntcW08AWH1stCsolHUlQ9sIAefly3/OX6JeuqZIMZwRQJAf4ORqQuxfJ/TZHJkPfLK
         QUg5Ts/C517qFKWu/SWEvDLYr3aSByDcwzOkIQvfCbDYDPGsyNEOI1OnBo/QoRA/FS7W
         t+uklcvaZ9uk5r+1sdNJ2rGLNqmQGT0KHph6ImwkEOqlwh7qaOwqepUVAxYZF0j8uZLZ
         GN0Na8CUP9D28cAHvsd7+ftbIPWcD5tVzYtczGdNVHXduDXbOkIpd19b+8Fg7pyMSAmL
         g0uN91PLDgeHQM8vdRL4xCpSIjW+3A7IoK+cf8fD1hSbNwiDQW3VW5kY+KGMJtNCVLqu
         T8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789956020; x=1790560820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dl3X5lIuCDCuxRfR4V0ReBm9Zl+q43AQqD3mJ2yz/dQ=;
        b=RXFkb1oTdkes7p0siNJ6CUWcQCnrNoF4Fek7JxamrdTwxTIu9/gvOZSparowWNwdxY
         7V9zI3i8XHO1iaTVARKOUP3eWMFy7nG+ZXbqy4HhxDVPpU4G2q9BptCOIkq9khaYyOkW
         GKhRBLYIMPG732iGizaYDdR53mGjI0CluvDHonQa1bPqElxIVumyLYDEUoxLVtQKnMPd
         gggLmI3RKF18Yz3cg/muYdG73wVxtSrZ46yE7HTrpd+evkGekz/fOULX0QlGQhU7R7qu
         lQkJJMEOmZAzwyrFxLOi7dl7SmNFhTAu3dVYR56rcJWwqvUdDxKGn1mA7OTkdR9C0IjE
         UntQ==
X-Forwarded-Encrypted: i=1; AKwUvBwnscDQyxrCO9AtbtACiAXTLKP6xNNOYDIvSe8mraEs/xkTvIlZi+whYSMhtMrgA4X2ibg4DD/5vA==@kvack.org
X-Gm-Message-State: AFuF++mT74UggKobHy/FJi+Y8CdNiczbhALmDMJF0O/J66574/sl7Arv
	rHZoaMZmTaWEa6i6YED1Bx2oJz0TCVlgVZwz9oHvFMEgZkihAdJSM5lQ
X-Gm-Gg: AYBFou3En6nRs4yzKC2fM8uiktMieWkjP/mdkKGZT3/XT6kt30+E2O7AFI5XgrrG2xo
	z4sLxrYvfes1ptHDqJVxU73d6SBwBbfSKoxwuqOEFqHXV66pQQQl+9NIOFniy5uHUCvAitnSm72
	dMkjmNwObFrsTx5o39MZj57/DzGfmVLDbQ6QaJDJTx3pAf6xcbggXYSl8r0WmBocvx296KVwL4P
	mbnTyrmHWxuvisUE9Un2QME0rMmJ6Lg/S9X1c4XpvRG7oC3PtJsLvMFLrCQA3OIpoBR/unIfI9D
	81byqaQGakhv0yXMPsfwoM2mRFUvHQ7aaTEbPWlh5e2+/Yg2fqekBmkgfxi/KXP9mCgITO6G78S
	TQrFdpwm3Q0I9KtFlpLzxG7gbqMLhCA7wEQL3EB2nt9SzbQj8Rrky+yR9iVEPGv6KozkmGI5KQ9
	b+h/HKj2naRIsUWVGVemuqH3kaHnliZwkZJJSp344AcejfJ+a4AOM2GEs0zXVu3lxsblTv5ErmJ
	20xQAcp0KTEX3sS5zuddrol/8pVRotjfrYdCuhQF+AvNurGu1OhwoG3D/Vv/Bs6B6xamiH6NCL5
	N0w06U4dclhra1GqGh7Ugo1JliJJr/5eRNVLgguZ7eBXCs5+qaO7sek7Y/dh9unFNYrJFMwT7Lo
	1Bg==
X-Received: by 2002:a05:600c:4e50:b0:49c:ffde:45ff with SMTP id 5b1f17b1804b1-49fc5728f5amr118239615e9.17.1789956020203;
        Sun, 20 Sep 2026 19:00:20 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a8e9-c501-2c36-515f-49b6-c492.310.pool.telefonica.de. [2a02:3100:a8e9:c501:2c36:515f:49b6:c492])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fcd10273fsm193284995e9.7.2026.09.20.19.00.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 20 Sep 2026 19:00:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/damon: preserve temporal quota state for unmeasured PSI goals
Date: Mon, 21 Sep 2026 04:00:11 +0200
Message-Id: <20260921020013.33105-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: awhgdyz4368hdbsfjk8h4rcaoy8kic57
X-Rspamd-Queue-Id: EB83440005
X-HE-Tag: 1789956021-385241
X-HE-Meta: U2FsdGVkX1/FtesE1BfiasIoUMMOo5rrzA4bHtplRdoSuAbqA7gCYDhPSPburca47jq7FKvagzVQFugGOy+E0KSF46YrUJLCAmWK9ERRthqQYG83GW2ONsWnsRBmVp7+BW7ASBgjTxC7mQYYlwXQZ5lYVWkR9eWkZ5YE38ZRQNp0zDjpQF1P3t82iFzgKsnTWFuq9vxiprgFcdzdPzj80/lap+yWleyzfIjK8aeCfiu1ItFQYwDwo2wuY22Rgecptfbq3Pf8LneW5UedlkzkpGapDJSjWWA53SzHY26bp7WJA37SGv9IJAH0Ondg44dr6RCZXOKFI4dvBe6xRMJVyNBhhR8IoBDFTnpvGEmt28yNTHc13kL/WP2fDB2VB+30pIB32+ZYB2cB0Bb6OOpGbmw8epZoQ20fkjj/CmOoQQmbedtE6ZR/TJQe0yElrrxAuiRBkEQPpGy2McqvNrzj0jScC+XQcTULcI85NdaK059UoCsh9/8/QcMwbB5Tf53J8IJUE5g99Z2heWGplQiQgHKZDBuUE1Qmn4pFgv8qj4KT8I6IKwXpNUDwjZBKd/z9hQgvFPIn03+8YBgsVYMMgE58Z5C4fseCXhK3Dq+n5uUag0Hx0mofV6GhVcEg4EjLl0cK2xfbZypeodRwF7LmXoWvxbFk7ADdsKopoVp8Lj4BaPJZBx2SMjX1vDyD3oOpj1+PE7LpfNadlP38fHHAyGMIB6lPnqmCjqnkgHqCyj4tj3TJAr85BEr2bLI1yfttsQ98lFzKfbBpfvv6kpkSyGmng5M4tL1F0j1Lf9/DdAt9DgZHnhoj7NQcjFf1toW7k6qc7UpC0hw/ylkmZTEAMHZiOETtUS7HDjzZ7noNr3he6V25j48e42f20kS/z0KBBz5y8XjfDyBeLaIz6o+sTGSS5DaObnFilxQYXWao6s/TLdAe2OtoSxhkyVWzhJ32GLabpqKl3gp+ikroOdC
 r7yevQ+X
 Ep32sBM4Vch0XS4yicsuZq0P3mrhnkYF1vGK8ezmxVn6ZEgx2eDIV8oS5RvnEHWExchcGGCJRSGYCUXu0hWU7oxjse3u/CuXtPXtOdrzkG/usp5iivUVBBIpFtC71U2r4YVJsHQlOxrMl8TfSwlQgUZ1lK+1dn5f+yGNIn5AfjUKZxKh3M8gSejnaJoFI/BzMNsBpxTQMVmGnl3kCoFISjAyCVEO8bqt+zsrT01XwKttAGbdKe9culee0fZQ0yclmOTdf5XyGZPIDFi+mL9fi/aRNNA56DFLokbp4BxNudHMy/OKEN1j97k37wHbFPjadoXWlThM1d0KacsJ6dhbAkn2SB2UoVwxvr3MPH4/1dHOnao5CFrelil91jwLga9ffVRWCXVPrzwpxRSOCfzfNwFJkoiyESXU+cox63noo8V3p9uDpDDxi0mak//P01Z8gsnDzr8MZOTiFqzhTrxft31aomjHibKj4J0Kz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PSI quota goal without a previous sample is scored as achieved. This
leaves the consist tuner's input unchanged but sets the temporal quota
to zero. Preserve the temporal tuner's previous goal-achievement state
using its effective quota, as SJ suggested [1], and test the helper with
explicit PSI totals.

All 42 DAMON KUnit tests pass on x86-64 and i386. With the original
scoring retained in the extracted helper, the new test fails on both.
In a live damo test, a goals-only update changes a running 64 KiB quota
to zero for an unmeasured round without the fix. With the fix, the
effective quota stays at 64 KiB. A full damo tune also needs the separate
quota-reset fix [3], so the context update preserves the running quota
used for this decision.

DAMON selftests show no new failures (QEMU TCG guest; the wss_estimation
test misses its accuracy bounds with and without the fix).

Changes since v1 [2]:
 - Use the previous effective quota for the temporal decision, including
   when it is zero. Keep resetting last_psi_total for new and updated
   goals.
 - Move the current-value calculation and last_psi_total update into a
   helper. Test both tuners with explicit samples and check
   last_psi_total after each call.

The series is based on mm-new as of September 20.

[1] https://lore.kernel.org/damon/20260916001311.101024-1-sj@kernel.org/
[2] https://lore.kernel.org/20260915060937.3423-1-kmehltretter@gmail.com/
[3] https://lore.kernel.org/20260921003047.12041-1-kmehltretter@gmail.com/

Karl Mehltretter (2):
  mm/damon/core: keep the temporal tuner quota over an unmeasured PSI
    round
  mm/damon/tests/core-kunit: test PSI goal values with explicit samples

 mm/damon/core.c             | 30 ++++++++++++++++++++------
 mm/damon/tests/core-kunit.h | 43 +++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 7 deletions(-)


base-commit: 185111f116aabf202d12ce440c0f6e9bae073514
-- 
2.53.0


