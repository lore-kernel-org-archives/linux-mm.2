Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8CDCD6E51
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 08:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 414446B0114; Sun, 31 May 2026 04:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5356B0116; Sun, 31 May 2026 04:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DAB86B0117; Sun, 31 May 2026 04:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFE16B0114
	for <linux-mm@kvack.org>; Sun, 31 May 2026 04:57:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9374040462
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:57:30 +0000 (UTC)
X-FDA: 84827111460.27.75FF51E
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 09FBF40007
	for <linux-mm@kvack.org>; Sun, 31 May 2026 08:57:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1ib2Tdv;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780217849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iiJNrzdhmETedEmIXH5LzZ4qCUgffcIFtMWEWQCqUyg=;
	b=sUx6v/4mGPtuh1zjjMEFiLNx9AgUfWPJGn64D+cfEah519sy0sR0+55sz0Ykg+i4xsYyfY
	zA3YWj+vCPt+RG+TZzmDneRaDdJyzyTgPsim1qfJ6rCeOvWTHFEDlJqZt0qN/4cDik91GB
	LTVVUHlpvgN2WY3qttcrgI9i2unqPJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780217849; a=rsa-sha256;
	cv=none;
	b=YkfsHFlkMBeWd+Ke0dN110XbTw6QVX+SGsuVIQlw+debqq8oKCchEXPoat2Q1Qr9E0/1kw
	9Vpuiov/4DjNRX/V92vSnflNZCqxPTt6Zhq7MAem5YxKhlNwD2wPvOqrMwn/weeBtEv9oz
	imBaJ7yH9poyhkXTE+SZbFsnnfhud0I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1ib2Tdv;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780217847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iiJNrzdhmETedEmIXH5LzZ4qCUgffcIFtMWEWQCqUyg=;
	b=I1ib2TdvfLWD0ag/Tn7NwVs7KCqNVBsMX9C6ZwMs7x0kANWNk43SwvDWiUVk/klTEd0UEn
	d4a0rOForr1bHx2ntIF9xwXSab40PNCukXvrbaF4e9pKQaQ9/PKIBsEdyr/bIXcNHAA/o8
	ZQdDtqmwXY/IboWXT9k5dwfAvZAYEmg=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH 0/5] selftests/damon: misc fixes for test bugs
Date: Sun, 31 May 2026 16:56:28 +0800
Message-ID: <20260531085633.48626-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: isj3mmzecxhxuabotnmpdwh5m78dopbd
X-Rspamd-Queue-Id: 09FBF40007
X-Rspam-User: 
X-HE-Tag: 1780217848-52733
X-HE-Meta: U2FsdGVkX19bigJ3n8XG05cSeBuNGzEvNYYzUKaS2OpFWSSPozB+nWxV8b1F2BXRFKwUdY922esV2szHYQex8c9zPTJ4HINbVA9497fQ3sEVAqTLUwQumSyyB35sMkWNoOSNq+cV7r/Mtm94l5ROxZm9lF3uK98e18bAofM2ffwO+pnDgDREFMrQ4dref6dbl/m5Wv7SbXLaa4vtrJvVf2eAxdGHCfVEG2OiawXdj2uZ5moK/ELOGLxb5IEwZC6HZu4PYijxcvlswbt7smYbqnRszZNgMFPIjoMx+b6JSzEit7ygC46H5tHpAHzF2AS4pGP6/ziz5qd81d8KbcycRXZyiRUomsW4wTHqtbMWC+tXjFoYFyS5bVw43nNzGBa6M/VjGLCnmuoiYwIPQB7FJgVdjb82xR+bUNQmsR8H2DS46zXQ4w7RCFFhkt/wCi06jrapYY7UZHA4ehaIIvWmdr5s+DN1VHWcAx4ZuGbD85VgqSriI82JryXyPP1faA23fSAhJeUu4avXQH2ooexAf1vvmnMBMVtuS+3SA09g4ymhTYlGSofnBTlcPHURQ4PGfW4xzAqeiOeNTfoHTTLOTDgJ9QR9HQVkXbQSJxpbdmYcdeObB+hqVasfU9YouAlDh8Xk6q+v4FgfcJcq88gBP28qw66Ct5sJwGkPRgBGDxj5brcskZUsEZ7HjYyhEja8295QVB+hvhvGq1xhGoJFDAlLn+1u6Ax5mFM5T5pbL55KfDecRBGvYDk1EMgkwbfTF8dcrdyDnOhSIl+1il45CUz8dbGEJvUorGOJ10oJ8pFnF7k0pH4y1Z8bHFmNnx87byoZOknZPWmgdRP/njXOeeo/6pUPiVgMiLqAX0MdfEd0By+WuGbCBlrmrpkffCed6LkiO1srC6WOuk9bfFOVd3Wq7XEq4Svibj3/PRtgq+EI3RSfctrCmoLmRdrjv3F/EsvEvMlWOECHcafaDM9
 NpSCIIJW
 lrRA5+5E9d7a5655VldY8tkvOFtpnqmOl+QMNGQyiyvJRUtPPAELu1hoztDp1wRVtvNkcoRv7Btu+KbFpUx5FzZ83GFVYxS1vgfw8n1qWlTBnI8jdWAJxEpo/e4+/kuIExn620HE2n8hPqW0Op2gN5DDgAmDUY6chNDV1QfgJsFtur4/KUjV54ELvJnZnxGa40kR4ZktTos1vrYlYNOT5jSSxdfW1YAj0Abk4YKfm2xjoS2ssaU11m9XxVg3wXBuMtf9X+p8RATQBtJjSuoqScwRpVaiNwbby/Prk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

This series fixes several bugs in the DAMON selftests.  Most are
trivial but cause tests to silently pass when they shouldn't, or
fail prematurely on slow machines.

Patch 1 fixes mutable default arguments in DamonCtx.__init__()
that cause state to leak between test instances.

Patch 2 fixes a trailing comma in DamosFilter that turns
memcg_path from a string into a tuple, silently breaking memcg
filter setup.

Patch 3-4 fix bugs in damos_tried_regions.py: wrong operator
precedence drops the "not met" prefix from failure output, and
empty early aggregation cycles cause premature test failure.

Patch 5 fixes several wrong strings that produce dead elif
branches, skipped file existence checks, and broken dict key
lookups.

Based on next-20260529.
base-commit: 7da7f07112610a520567421dd2ffcb51beaefbcc

Kunwu Chan (5):
  selftests/damon: prevent cross-context state pollution in DamonCtx
  selftests/damon: fix memcg filter path handling
  selftests/damon/damos_tried_regions: fix expectation output and join
    TypeError
  selftests/damon/damos_tried_regions: handle empty tried regions in
    early cycles
  selftests/damon: fix dead code, skipped checks, and broken lookups

 tools/testing/selftests/damon/_damon_sysfs.py | 14 +++++++++----
 .../selftests/damon/damos_apply_interval.py   |  2 +-
 .../selftests/damon/damos_quota_goal.py       |  2 +-
 .../selftests/damon/damos_tried_regions.py    | 20 ++++++++++---------
 .../selftests/damon/drgn_dump_damon_status.py |  2 +-
 tools/testing/selftests/damon/sysfs.py        |  4 ++--
 tools/testing/selftests/damon/sysfs.sh        |  6 +++---
 ...te_schemes_tried_regions_wss_estimation.py |  2 +-
 8 files changed, 30 insertions(+), 22 deletions(-)

-- 
2.43.0


