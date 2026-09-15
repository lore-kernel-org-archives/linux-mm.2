Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B445C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:09:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBC026B0088; Tue, 15 Sep 2026 02:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6D3E6B0092; Tue, 15 Sep 2026 02:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36DE6B0093; Tue, 15 Sep 2026 02:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACE0C6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D34F640337
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:09:48 +0000 (UTC)
X-FDA: 85214970456.20.66DB188
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf25.hostedemail.com (Postfix) with ESMTP id 25A71A0004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:09:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Erl3UKkP;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SI783VUJkGIZm3nVSym26fZ6VNUHxk9Ukf15drWnbdY=;
	b=xfbaVtjizc4hwzAPRBfwAzRPFGi3C4aekK1YNcrznpeQWIHxQoTW68budKSCWcoxxOmMZ0
	v+gojCAVmsPKHFSI5xCQMpmUM/D1F5cLdFgHDFW0Er6oEr2BClUTMRem6/ePVYlDwgkrwn
	/i2WtJWDfG1jdpD5kTjM2hJbjMcpn+o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Erl3UKkP;
	spf=pass (imf25.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452587;
	b=dM009IluCBEltzDy0R/5LB3Y9mPhyKwrL98r7X0RpFLWkngM4X+Ctlqhqd9OlSTio71k+T
	L3CU2ZVeMBECR5/J2cCoYc7JA/AtLVEWmDXLytlKIx4Bjj30H2J48RwBnxuES+m5ymRDnE
	hSb/ZBHNMx3eFI+Bfp61JAiMJZyOois=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso22450235e9.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789452586; x=1790057386; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SI783VUJkGIZm3nVSym26fZ6VNUHxk9Ukf15drWnbdY=;
        b=Erl3UKkPWvltJIVXe7t34FC//53XXhb6ednsbGzjfpIPJ+3cEeQSIKwP5quoZPkTB5
         IaoA0MeYcUE8KfeWL8FEjIUitI6IBLj24gius18QOPQvfsk3bGnAqm3oO28WSivzwrx+
         Xps+oovjoot4gEWDfnv/i0gBMuVmrtW11X943IM6EgSzshG0ufzYcc8EJrD6qX5HEI/5
         3vCzyrBmAOeFuJ7JUsIVujgl7yD9z/ESuZqQelOBvwv6gKRUkyMPC4aKAkQJZCdZf1bB
         aTpfg6S9BM7xixMxBmfANxh6POLOK5fLTIcPYxBWVRbu1agG0A+7+6vQYRh7kci3v+qL
         zxhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789452586; x=1790057386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SI783VUJkGIZm3nVSym26fZ6VNUHxk9Ukf15drWnbdY=;
        b=0RjC6dFWVCoHPsmTorrW2JuWXUmRyAKPejy2SubtnpFv3BTVc+A9/Y9PRIW53SJ/B9
         MJQZ+YX8iR0emRoIU1cGZMWqXhY/TM71URhZp1a0N/QstR7RCov99LNTylygUDa+MpdM
         GB6dz/SDlaAvNOkmoZLDEgr6d+YCMyqzgxTNKdpY/M27Quah7tmJ5Y92nUBNRERFKRxf
         joSiqcJLWgorEkOqlJTDNVSPzohxCkpFogjlsGlfLdE+qOVTEsoNWkVou6J13fsYTGNe
         /NRDFqq6pVaHIpYDcW/yhgO59NHE2pIQrbIPu4FJA2J99j/coK4Z2GZu0F2vBgdeFj43
         F8fA==
X-Forwarded-Encrypted: i=1; AKwUvBzx7G2/nrhdTv/41U5kElyRwrhdl2vyHZ+V3Qw5lE4AxJd8kBgR7YEtQQ62LpkXF0C3opwdBger0w==@kvack.org
X-Gm-Message-State: AFuF++mb5XPQdAvuglRn4s6pAb7ikXf94atHlfu6Qyb13EVJXll0gyGo
	wSZ4NHF5awz2xoC7gvH5VVeu/0zUAyq05fvKYqxutY+Co1qSpxEVSDZM
X-Gm-Gg: AYBFou3aqvAigEWmvhrUGD277OmE9TVXjtkccumGIMbit+NdYtDpGOa1E+UQKqnqOiP
	McIvinjaYP6q08SujlQvzrBlilG2MLyE8yNSd9/6IB68/qxcwS3i5J8gumkBLMbp8b9aqJsAe+S
	mWiKmOyVzpiHtIzSfretCEfaId8J7FtHw/ZSUz2pmC4x8lTExql/pA3laEPNgw3k16G0Edu6fru
	3VBLngw+rskUEQ/DsOsc1hv9vp+4DCZ8nZvEKR1GVb7Z0BfsH6t9hxxgLyZsV3kbdM+wm7LCKwK
	oqFsMX9qM7FE14AjXOosq1I6Pw/qCNUIc8AvaQ9Z6qSSnDISVa8A9Tr2B/k4tVLjsUDklgDhwRE
	0RwV2oXTbzkWsRKl/ltWcNIGgrFRcibplb5CcW8k9XK+sajNQpGQKIdxkVIHbNcRVqK7Dc0QS+o
	osn9uEdofDoCK/wwAhLzdRt9Hj2/s5fEGFCJV3kAhNbYUrtuqJ1H4zzpjLHkj5pzZ4pTlz0oOWm
	D3PH8vROO0h8Myhj3KvKCG8SVcB9Xu9wYve0UGrHdWUfaAUSLB6+ucbMoCZdQ31UuEITmEuxqmn
	X2D6cN1K2An5fxSfQ9kQGomHULEqafs7T7Z4PavUF0krX4TP5RNBq8VH45Wnpkhs2B1PLD9dbwO
	eSoxegzg3eaRLjwsQ
X-Received: by 2002:a05:600c:4e02:b0:49d:272d:74b4 with SMTP id 5b1f17b1804b1-49e7a6387bcmr171632925e9.2.1789452585275;
        Mon, 14 Sep 2026 23:09:45 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-afd5-c801-cc65-9ba1-765b-bff6.310.pool.telefonica.de. [2a02:3100:afd5:c801:cc65:9ba1:765b:bff6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7d27c88fsm44282905e9.2.2026.09.14.23.09.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 23:09:44 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] mm/damon: fix zero quota for PSI goals under the temporal tuner
Date: Tue, 15 Sep 2026 08:09:35 +0200
Message-Id: <20260915060937.3423-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25A71A0004
X-Stat-Signature: d5zmewdkzwgp95tamsdrwsq93ht8pdwf
X-Rspam-User: 
X-HE-Tag: 1789452587-276496
X-HE-Meta: U2FsdGVkX19x6BF+qYgyb2+ZdEXYXVZ1rrvcnO7z7gxVczxSHYHblsGf4o4NS6eTs8ipyFkWRTmu37mxbEVDYS1HBaKoXWiXc8vTe/xx3Dfh0SEUblZVCL0KjBADNdICPDJl9Iy+wMT0IfcJVs4+vw1AyTNdOCCdbLkd4PZiwVQNZRAhFKClvLeyPAmWLHX35NQzFQe4RRK9yxiQYTOX1Nl79FzhzVyFzVRox5ArifkuKLQwAG1iON+GsVbOR4OYk24KiVi5i3oY9XMyDW4UttU2tI7ZqegbMLAWTq7bnrK8wGvKT0/9a8ItqEnsNZLrUZ1cOi68gLCqhy4T3KPbqN59J5C+v90blePs9dT8Ng9fltAzLUNnbGTwFGaG4NJF5hp/B361hoNM6LKw+ri7qvNI+aKUOEtx171DIaFULu1bsmpHNQI0hxoXC/yngBRndvjclh3p4KK7CY1tWTD89XZsplL5FvVxnuX57IJMCqpMb8Hiyreld4o+FEaTbaKa43DVgJacOI1tlqEulf+D21zPLcefZrMl4cLcdy7iTqSRpaayF5HfuYMcURT6yM1us5d2ugvKcg5WeLeLfEJDV9dIibn38wEfFV2HEKpS2gE2mphYbmlK6boHvgHnGNqZC5pRkYhD5LG04NE2uU4nnZKZby7yiVi7XoH0M/ZVXOLd03u9q5k7WvWlI8qZvRBOB8NhpAqvF35vv0e+AHSgFYA+jdvCFf14qGoqCuJjL9ZzqNQjSduChv28VZF8myzSILXtNBpWlrpbl9KEp4B+H1idJTt59lwE6bWyjJ5jUHIUaTWiKq2CuocfIp1COSbC3Cr8QI3GYRzjT/E/YoTdfmQPt3HBKCTF/VYBkrGHbthL4YQ3y2AEGMypRe5yYeADb2hvQPvysv0ZaaYov6OcQ1z+MKvwVs1itA/7G4hpeZK35RRVp9Pjbi5Xgqxy4dmsWgUuS1qwLxrJYy4HEZu
 QEW/jqLf
 +3QrGp0KlAzYYbQEoLTYY8AvEezHPku6fxKwfE6I/sj8RYF1FMbugQktgFRczr4sDZYwmO3mrt0kjCfZQrKpirBK61Z3+ewn9x4P/vvxw+c/WKs7Ikm7ppoUodBAN+hCIsk7Cfjl+VB6Cj9EQGLwjLyggMzzDhal3f/FloDucokqXATlikbPyfMgMFUouhM6lJSnlR1l8kA+naXBrHK4JJjuOcOBIl7u8cFbcjdcQWU+WKglH/Eq94d9Lexh+ytiFLQB38F6bFNgkPKS+bsXNV6RMBwBqPAWr/ZhXH23QQL4Q0Q39/PaxJcQTnmf5LuAm9Ld9QHVZeW0Gd+jpfHnLGhfVTrMpO8z8ePx7dmB23TX1F1CALfm6NadbS1Z5miEGyovvKCoMr1qGMV4I3gA0yyvopiHtSncWqvnQk9G9t9Voh4Bbh85ADdFsIgHYai0hdCsmxQm92UbOnzx0XojV1tpj4TL2pcmllFNk4qB/4xS3MZb/lf4p7bM7xuFAIf97EUHj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A PSI quota goal without a previous sample is scored as achieved.
With the temporal tuner, this sets the quota to zero for the first
charge window and the window after each goal commit.

The series is based on next-20260911. It fixes commit a68878f83ae6
("mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total"),
which is in mm-new and tagged for stable. Please carry this fix with
it.

Patch 1 keeps the temporal quota active until a PSI delta is
available. Patch 2 adds a regression test for the first round, the
next measured round, the round after a goal commit, a measured round
that reaches the target, and the consist tuner's unmeasured round.

Reproduced with damo 3.4.0 (b41965a) in a QEMU guest running
next-20260911 (x86_64, CONFIG_DAMON_SYSFS=y, CONFIG_PSI=y):

  damo start --damos_action stat --damos_quota_interval 120000 \
      --damos_quota_space 1048576 \
      --damos_quota_goal some_mem_psi_us 100000000000 \
      --damos_quota_goal_tuner temporal

then reading quotas/effective_bytes after update_schemes_effective_quotas
every 18 seconds. Without patch 1 the effective quota is 0 for the whole
first 120 second window and again for the window after "damo tune" with
the same parameters. With patch 1 it is 1048576 throughout.

The KUnit test in patch 2 fails without patch 1 and passes with it on
x86_64 and i386 (CONFIG_DAMON_KUNIT_TEST=y, built-in KUnit run at boot).

Karl Mehltretter (2):
  mm/damon/core: score an unmeasured PSI goal as not achieved for the
    temporal tuner
  mm/damon/tests/core-kunit: test PSI goal rounds under the temporal
    tuner

 mm/damon/core.c             | 14 +++++---
 mm/damon/tests/core-kunit.h | 69 +++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+), 4 deletions(-)


base-commit: 68142f986ff04b2b70b31db00f719bf690f64a9a
-- 
2.53.0


