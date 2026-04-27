Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A4DAFF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 12:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BA6C6B00A0; Mon, 27 Apr 2026 08:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992396B00A1; Mon, 27 Apr 2026 08:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7856B00A2; Mon, 27 Apr 2026 08:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 796AA6B00A0
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:04:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 237571B6FCC
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:03 +0000 (UTC)
X-FDA: 84704202366.29.72DEB9D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD42D100017
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:04:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pv2iyaWL;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777291441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=S18IWDdCFBzuI8NowwnU28bSpSBRFbUFQV3pp3AHHVI=;
	b=FzxXFxSmYwQnjt0v3vatBgpgjwKNur1iNEENk5ohf9FGfw5Wh9AndlyK/1a5ewJOsQJ+mX
	GStgHj+XFAho+Z3/GKiJGreX+nD1Ji/l9IQKjunPNyLFpuqWLGAjscH3lgXCZm8leJUTwM
	7bLVf0Y2Cnb3jI2qDN39aHfExc9OmLw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pv2iyaWL;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777291441; a=rsa-sha256;
	cv=none;
	b=jzEOY8qm/LZNldsCyhtBhJaDgboXwcwjwGObCaSutLOWjiSTnJic6hUvVuF1xxVDkrzD4E
	rucwx+FK5sFZOAuhzfCk4d+jxoxIjbDq33RLQ4Ou30HPHRyLLvPjZftTV1l1+LxHlfcBu8
	OPPwkj1vvuEvEeKEiyz+zvpNDrCBBFY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44A8D1684;
	Mon, 27 Apr 2026 05:03:54 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 272613F62B;
	Mon, 27 Apr 2026 05:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777291439; bh=OFh1b/dqzoKdOtO2WACkfb8cmDS6G37Dk4q1SpTij4w=;
	h=From:Subject:Date:To:Cc:From;
	b=pv2iyaWLd7PVCESn/x1/Gc/jSokxnSvZQ/jbyRNJKFDeP43QPOBkehnSQMyyGsTM5
	 5XJ7ZUB4OfSghB68hntCCiZfigwjA8kT9QdaLW6PYXuarV9M3+Uc2C6tWi82mvjKpE
	 gYeEmRM2XAwnwxOb/o7HhL8nfL7qcdFMwvbIZozc=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Subject: [PATCH v2 0/5] POE sigreturn fix and extra tests
Date: Mon, 27 Apr 2026 13:03:32 +0100
Message-Id: <20260427-poe_signal-v2-0-2bd9d6f16ab4@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJRQ72kC/02OwQ6CMBBEf8Xs2ZJ2oUQ8+R/GmFIWqEhLtmg0h
 H+36MXT5CUzL7NAJHYU4bhbgOnpogs+Ae53YHvjOxKuSQwosZQF5mIKdI2u8+YuDrJSVW41om4
 gDSam1r2+svPlx/FR38jOm2FrtBxGMfdM5l+qVFGgxiyFzEstlBjSE5/VHJo4vE+Gx8yGEdb1A
 /JsNxKvAAAA
X-Change-ID: 20260423-poe_signal-809193c5225d
To: linux-arm-kernel@lists.infradead.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Mark Brown <broonie@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777291437; l=2985;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=OFh1b/dqzoKdOtO2WACkfb8cmDS6G37Dk4q1SpTij4w=;
 b=LJz4yEtlHPyFFFqBnyWhEUZ9R8mWnmQnZdkz/Z3vRs98YJf/tdewM7QGuDnqMQbX48bZaP/C2
 /yEx169pfFtCeCDsd3uGYZdDyI3UkI0PzXafacvz4gsDCBntLTMtLG0
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DD42D100017
X-Stat-Signature: j98thqgm31jomzcqfi6x3kh3ijm3b7bj
X-HE-Tag: 1777291440-433743
X-HE-Meta: U2FsdGVkX19In0ZrRF321WSlPflzXhu2FlgUCSegDBw2PgDMY6Qa9zXvyxhAMwa23+7nxqXlbJyYdX+ZH2eKfwJXeGd8SvoQxkLLt58ptAu/22UGm5cLA3wpb1sBq9f3DkuR6wJ/86h7jwu8WlT/KkKq7oNk9X1kWY0ZP3LobmCGPlIf73X7ZbDAfzI4s8ZcDC+4NjbhsyS9tkjF74yCQCRrCLzuutxSyBUzvJJ+aLM4JK8hqI1ZQBNflTSEw3NIcSjPoSvjumwNFlCGp29Fof0DOD1GbwOMan/BL01zF0/KcTk92ktmUEboZH9t+6UT892AmtWKMFF5eDOe4vdRHRCruXsuRMyOLKlRR7IrNC29KP9FnHCHcbRAvrLC+zs4orfGfMAkdDYSen7qdlwWUIwS19hkTSwicUmFQw7SfMAXJbKFJzn/ckcj/Lx62BgWUJVPJdUe5a+ki0l6+rlvYQmWoq5sHJ0DEyTx37RHQbo7PmfJUVQO2EGpwn2n3/fMyRAdBAGRJ0Q/TrNh/KgclGrn4XAuQn8M4XJ4Wz54l38kPo+VneDibnM8Dnorw7npVP9UUGqwiOles3pZtegx/jaQSdmaE9kuuhWoaIeNZpkZw4iLfi+Sm3YC7qrB2EzlJYbaKLWuRiNcbtMlW2QOStz+IjfoJxJVvcpAaBWBvWN96dn6RAorHGAzJYb8uvWYCwGigODuZV0w/X0+Aezp6BdTuQexEQgJboFsi25svXW3o5UZ6jdsWS95V9kIF6qtqXFhplRxFD3RKvOffloil9GXsEVLGrOlEs0IrHn/C0uD3gaMxdF6UHjvcLQjGwF86VUfNhjzIiACkGx+aT5uq7bAxK2RTDl5Pwck0GuWOBVI3JpYYgSlwMmc5ohPAnQuiYvanPJeb4jDm9i/9CDQEwK+Ny1cOnO/VqV/1SWcFfb/YQq7Aod4F20SetNxt6AMVoxAvtSklFW5pw22SDg
 621//nHy
 PYSF6N1Fm9xwh04gJxXWtnSfxlaVqba2IBSF/Fu4nMkOnbTmv0u+TKGlFP6zIUs6EoB0bql+eXbHw0iROh53Sr99LCcfsKSlx3CO/KSwzgRW+D3mP74RFn7AyyR2raCdpo1ZG6/VbKkFjsSZRBZaJ5/zZ2jiC6tZQbmcmBT6uncNiv/mdpkhWL/o85XLUvga9AWuxmMSFmRTnvqSrn42pEH4zl/rSqSlfE51wzd9+0XkKfAM4CJTqZO7VXzjh4StLL3clk0+pewyx7VIHDodrhrn5cp+qZdmSXmeSdGmBS/VqVfUekjH11IGZWUkhRNbhj9Lirh7gIHK97eGehnv8ntj0Z2DYp/C/OVGtoU8tqxS1HQKstfyJ8TSL2zDXvBoRcg/od1t+a3pmD+CvleKBcEW214M9+ZzxofvaNvTFPHQLCkJE75Imd9n6cgvQGhpq7Qom7Vx3CkJ9eFs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2e8a1acea859 ("arm64: signal: Improve POR_EL0 handling to
avoid uaccess failures") introduced special handling for EL0 registers
that impact uaccess. This did not however handle the case where a signal
handler removes the relevant record (poe_context for POE) from the
signal frame; this is clearly not typical behaviour but it is legal.
That commit resulted in arbitrary data from the kernel stack being
written to POR_EL0 in that case.

Patch 1 fixes this by tracking which fields in struct user_access_state
are actually valid. This restores the original behaviour, where POR_EL0
is left untouched if poe_context is removed.

The remaining patches add new tests to the arm64 signal kselftests to
check that POR_EL0 is reset and restored (or preserved) as expected.
Patch 2 fixes an issue found by Sashiko while reusing some code for
the new tests.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
v1..v2:
- Patch 1: introduced accessors and moved to using {} for zero-init
  [Will]
- Patch 1: removed change in setup_sigframe() - using the new flag
  isn't actually more consistent than checking system_supports_poe()
  and doesn't play well with the new accessors
- Patch 5: fixed the size passed to get_header(), as reported by
  Sashiko. Added patch 2 to fix the issue where I had originally
  found it.
- Patch 4: improved commit title [Mark]
- Collected R-b

v1: https://lore.kernel.org/all/20260421144252.1440365-1-kevin.brodsky@arm.com/

---
To: linux-arm-kernel@lists.infradead.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org

---
Kevin Brodsky (5):
      arm64: signal: Preserve POR_EL0 if poe_context is missing
      selftests/mm: Fix resv_sz when parsing arm64 signal frame
      kselftest/arm64: Add POE as a feature in the signal tests
      kselftest/arm64: Move/add POE helpers to test_signals_utils.h
      kselftest/arm64: Add tests for POR_EL0 save/reset/restore

 arch/arm64/kernel/signal.c                         | 54 ++++++++++++----
 .../testing/selftests/arm64/signal/test_signals.h  |  2 +
 .../selftests/arm64/signal/test_signals_utils.c    |  3 +
 .../selftests/arm64/signal/test_signals_utils.h    | 16 +++++
 .../signal/testcases/poe_missing_poe_context.c     | 73 ++++++++++++++++++++++
 .../selftests/arm64/signal/testcases/poe_restore.c | 64 +++++++++++++++++++
 .../selftests/arm64/signal/testcases/poe_siginfo.c | 15 -----
 tools/testing/selftests/mm/pkey-arm64.h            |  3 +-
 8 files changed, 203 insertions(+), 27 deletions(-)
---
base-commit: 028ef9c96e96197026887c0f092424679298aae8
change-id: 20260423-poe_signal-809193c5225d


