Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3ACCD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAA766B008A; Wed, 20 May 2026 23:54:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0C306B0093; Wed, 20 May 2026 23:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAD026B008C; Wed, 20 May 2026 23:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FCCA6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:02 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1CC55160FEC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:02 +0000 (UTC)
X-FDA: 84790058724.21.180548B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F31A20008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFAapP3f;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TJFCxCKfH+m1BDgsjzbYuCTSOiloEwDvbWbleyxza+U=;
	b=qfpr+A9PBaGmGabzI4asHAD0MrEVdCivPmkbNZRp5z5EdrguYfRfjqBpGMkBCk2lmbaNkY
	VhvSCzjSgI1zQ1eJf+CyMwpMoU/kh5oz7A8RYrxFLpqRaljWXrmT/w7JOD6WYiOAkKh73b
	+GZBrYrzfJ40HQ5p5vFwy87N2TF9Ykg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CFAapP3f;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335640; a=rsa-sha256;
	cv=none;
	b=f2t+Rb4uGKKotSwYM/mgmsAR7ZKwyiFKttBLY48dra8Jo76XWorhQp2VYS47f/jN0RNPAI
	APBv2Yc47uj4o9NoaTiuvjw0fX6cTcw1zCNmTTzDO8Geeusa5BkP/9JJM8rK7RwmCa9tXX
	da7sGppDf+nGYHAXrBWGyY9rKzbj2gI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 08ED960098;
	Thu, 21 May 2026 03:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565901F000E9;
	Thu, 21 May 2026 03:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335639;
	bh=TJFCxCKfH+m1BDgsjzbYuCTSOiloEwDvbWbleyxza+U=;
	h=From:To:Cc:Subject:Date;
	b=CFAapP3fUeJAbxRvEvaaOmN682WJ2DCPSQoiSxwaQYkDxpDry/DYJbPUoN6MuTfbE
	 c8boByrg6YxziGv9D/2xwZn3rErvayYnUFlg9Xu9Yp9xFIqPOx8YPcxbAHZgfIItDc
	 1LhU6G/KbvarCMT65JtCWz/bOHTxDk/gz16E7iSEyUJvZsCBTEDDJU7oPVRM7MDjD5
	 +Fm5+VqVpWeKjYphzq01LqzuM8n8wO54GFUfLFkpAODu9onAUBUHo7pLKfm83aLOrK
	 Mi0hHRPN/AVdSsPn5N0tC1ZSdmJqdZCZJOmJ/xSaxRKjopw3VKuvfUCJLXWdIC15RW
	 dHOesJBYlp/EA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 00/14] mm/damon: minor improvements for code readability and tests
Date: Wed, 20 May 2026 20:53:34 -0700
Message-ID: <20260521035349.87565-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9F31A20008
X-Stat-Signature: iwaf3jzggh8wanu88abj49mpcf7r37g7
X-HE-Tag: 1779335640-563987
X-HE-Meta: U2FsdGVkX1+pkuqXNPQ8O07OlWa3F22MTHFTkV8Xq7pC0Z65OipkjQ6ixAi5MpANaUxiFKTbzUW54MN87UxZQsksxThcSGmZ8OdskDZ+jYPBwmR6waRvCvk/p5BcJRfINqK/pRsbb1zZ2fy+C4QRj4KrxBadKhIAb3bqMVYB9tsEEsPDNHbAx/zFt6auHWMAfoQXFrzm0AxXvaDMSTUDn9WCws7dwU3lb1nKQg+R2xKBeUZl0Ioshwd00XBSTxhcSEgw5nbUgeC+4TshsGXDby7PGzAkxpcMPa25u/OoPGL9qCprnnhoV1KZjF602lODhaArhfGVkJeX3lFUNYVimP2Rs/r/OE7wrRNpO/CsniDr6dNhZTpi6CJW5wQadEL6wW8kmVE3Ja5a5VfAo6jjcWBNWtnMX1cBSqNKHZKXBS1zG7RfQcIzVhcDPKHIKh7tDnQpydszMGZWV/8ekK58jB631WPhLWAbb7UwHuD4QjCvEw00vH110edT35Bi9Y2jlZR+0zcyqRVjL3TaB5Zm5ro2/42Herg5iHBY/pyQKiXISiXitEcqDAaRSBYkXf4AxBGt/USZSwev3sTR5nl8BejtKHpukaW/E3oTqDl05YWRVdYz24D64xQ/wv1ZEKjHQD/fpi2LmzaRt4bK8xg+HfJqk7s+kr6PA/U3BAEdFo8RpPESvgvk+uLiqPMECzZlUR6AkB0/RZ89HlAx33aPUdKbT/lsHD3PcmHNXlQ/YfmktAqmi4hbN4VJOfbM945KimapWUgv+bg8tPk6tdavwk4nXlm+IzcG1Nf6P+qzcXyuZ50pGGoaDHtU1nFMxG0k7ouo+OBuBDt/nuVysYZGa1ofIdZ2HGPVkGHPJRpUUxuqMtv01ZFN+uu18Jf2F4SWlSu68ky2H47iEvzSjRwIccmT1zTfAOicJ/URk+olU7Z1+skYwIm/SGYJqBRqA4Qlt/PizFsaG9rHYEHVhZg
 OzsijDUa
 FFwyIVv7VqwuTyPuS6/iXq1/VAHTULZSAtqdV8PcxaHPSPTwxruaF6SYw642Q4xFpdh9hvM1ikl8u3g0JGNl6nVYYh7+VJLXl67gx2nSHwn9Uii+P2k8x8CgqnqVelforRrUEXg3E3TQBUMORZqaIyoyMPv4GeoxfHD9swTKsvAXSYUNNVjeLriTURvc/8OxfGjqnBMGFHyxXGYsUNveRSu5zo073L2ywuh/7XmH3oKGmy10=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement minor improvements on code readability and tests for DAMON.

First seven patches are for DAMON code readability and resulting
maintenance.  Patches 1 and 2 make damon_set_regions() safer and easier
to read.  Patches 3 and 4 remove fragmented DAMON API use cases. Patches
5-7 hides unused core functions that are unnecessarily exposed to API
callers.

The following seven patches are for DAMON tests improvement.  Patches 8
and 9 adds and removes DAMON_DEBUG_SANITY verifications to ensure
reasonable test coverage without too high overhead.  Patch 10 adds a new
kunit test for damon_set_regions().  Patch 11 makes sysfs.py selftest
more gracefully finishes under test failures.  Patches 12-13 adds simple
sysfs.sh test cases for the monitoring intervals goal directory, the
addr_unit file and the pause file.

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260520062858.167011-1-sj@kernel.org
- Handle damon_set_regions() failure in vaddr unit test.
- Free ranges array in vaddr unit test.
- Fix wrong region address verification.
- Fix typos in selftest: s/exit/exist/

SeongJae Park (14):
  mm/damon/core: safely handle no region case in damon_set_regions()
  mm/damon/core: do not use region out of a loop in damon_set_regions()
  samples/damon/mtier: replace damon_add_region() with
    damon_set_regions()
  mm/damon/tests/vaddr-kunit: replace damon_add_region() with
    damon_set_regions()
  mm/damon/core: hide damon_add_region()
  mm/damon/core: hide damon_insert_region()
  mm/damon/core: hide damon_destroy_region()
  mm/damon/core: add kdamond_call() debug_sanity check
  mm/damon/core: remove damon_verify_nr_regions()
  mm/damon/tests/core-kunit: add damon_set_regions() test cases
  selftests/damon/sysfs.py: stop kdamonds before failing
  selftests/damon/sysfs.sh: test monitoring intervals goal dir
  selftests/damon/sysfs.sh: test addr_unit file existence
  selftests/damon/sysfs.sh: test pause file existence

 include/linux/damon.h                  |  13 ---
 mm/damon/core.c                        |  92 ++++++++++++----
 mm/damon/tests/core-kunit.h            | 142 +++++++++++++++++++++----
 mm/damon/tests/vaddr-kunit.h           |  24 +++--
 samples/damon/mtier.c                  |  10 +-
 tools/testing/selftests/damon/sysfs.py |   4 +
 tools/testing/selftests/damon/sysfs.sh |  14 +++
 7 files changed, 230 insertions(+), 69 deletions(-)


base-commit: ae90ad6788e582af07da1b2ce81277d5a65f4f89
-- 
2.47.3

