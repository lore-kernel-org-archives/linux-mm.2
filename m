Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84DFCC44501
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6046B0005; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29CF26B0088; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB8C6B008A; Sat, 11 Jul 2026 14:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F09EE6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:04:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 710D091731
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:22 +0000 (UTC)
X-FDA: 84977270364.26.EBE8B0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id ECC9A18000A
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WbgTNZgM;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783793061;
	b=Z6nrdHIVvO78+ipwsAJNvST4cDwQkqQlbmXTEwECs2fP+lrRT3GFTRuDtpipw2C8uOxGDT
	6A3D+pxLL+NP8UdFgIoiSMmt95Pd4ruda9pd4SasuZXiNODR8dEfA+S1s3bgRLlmwB3S49
	iyvlOXDaEsHCVgSRoLL/lJor91R2T1M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WbgTNZgM;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783793061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t5U9bYvWpBGUn/8z8oM/COrKkhK//jr8XxK8Ubt31Fk=;
	b=y+/UGhYyWm2fk3nt9wrIojGbL4zcTEeAhNS1NBvWofSXYKgyqLrozjHvOnrE/Y1671nj5+
	mmalzNbFnRrxyABQMKNqgzwgjSpBWV8CrM5vFTTCIBCQzeK9t2qRAY7kwzKHiffaiB9uDb
	YsPxIdH9oiQldhMWf3dQjNmRw7RpgkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8F4B43743;
	Sat, 11 Jul 2026 18:04:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABBE1F00A3A;
	Sat, 11 Jul 2026 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783793059;
	bh=t5U9bYvWpBGUn/8z8oM/COrKkhK//jr8XxK8Ubt31Fk=;
	h=From:To:Cc:Subject:Date;
	b=WbgTNZgMZLscSz4b9bOglPLjoxPxYzqBAN5UdFSBXU8hAZhkAz3/o5OJO6wAmedZy
	 xexJs8Se7ZJZCjcQh/17dpRbaD9q2++1LnXAcKhFmaLg0gGsxu9ZfcGVKVdL9JB3X7
	 oNdyMW6T2niYH6mcj7+cdpKnFa1aBaSzQXCJKlTHAY9L3OjdQclE1HTgGPNB94Z8/1
	 3NtWdoTL4qWvA+t5wfqwddo5oHlBz7dsYmuLEyGQc9J+EkTZPuniaT7dHNiwJ2S8cr
	 NTyIf2WyTNjV4mRPLTX9skSSqA2jVbzqUp+x7hG/i8ThBDNOjQCFD600RifBHmMbpN
	 4hsHqPnYKAsew==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/5] mm/damon: unurgent fixes for infinite loop, NULL de-ref and races
Date: Sat, 11 Jul 2026 11:04:03 -0700
Message-ID: <20260711180409.82093-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECC9A18000A
X-Stat-Signature: auosik8fiya378jjtohu1sk6i6k1kdqc
X-HE-Tag: 1783793060-919931
X-HE-Meta: U2FsdGVkX1+2UWNEzw1MPjm1jIuTJuASC2eKrWzycXWRLepGS1gRjGaEgF6egcFfh6Co9mE0d6lhDlWd2zhl1b31MlHfmsjJ/H/mbjohyOO2tYHIJgqldwx10ih8ot+5DMooh8vyCqIggZ5mV6OYKiXLHz/xxYSwFfBYAdeiomh7WnLXhngtMaO2Ul0Su9+Kf/NkdVM4cYwTR4J12U0IbRg/qUd3oxXZfgg8J2TQZP5YxLFhJG/8vN/glY1SdciKvLL/ST6hf/ESSKlrMHgFK1jodxGNz03Log5Nn31IKXnv8YeCyIz+1z0AqClW0Kqkrk40mvxr+fEQCrU1ceBPaF+OeyB5f7GXT+h/P57mYEagyXVtwguYXQYqFFCc1909lUQhfytM9oFyR+caCWdYyqESqZAHp9VmXGCvylnnNO4LLVG+958HPlqQLG6aHjInSf01OQD0xCFrPaUYx5WZ+d8BaHKJl6kVl1JWAG9Npr233rdqTA5jsD49cPhJ1sCcu4PI5DbFtfBiQsbiujHMc87eksJ69Do514hZcxG1s2w0hK7FgPEzZnnlXTbY55OQ04x/z1miAuc+CieSeR3SBZwsJH0DxphSVvOjG+fuNgA9a8je3Z57jf1L2d0FTQtejAOrx1NdaF00gjUXO9tyqVb5eKH1zLx4KGCzZrjhRDytLe8BkudBPM0S1GYzrB5EFquGOuzIzkJepqcvZ5LErzYOT1RAM9A5JPj05euuDt0sMgQhwH76DunVPlnkiTbQRnuaJiBPZ7L+qcyYaC96OUqFoCQuSJM8Xne+N7EFUPZTnWoq0sQuLLwICag9Y0hdZcryGvDvmTrvWKc4ZusPHfkgVZlaPsTawSWeJ+9ehqXSUQ3LlMzkvVpLAgWFftC8T5rg/c9n6Rq943HafhT2bMN1XelwfJb2HoHnes1WqbJfU9LVecq4vB91jZAkNO6R0L5NP0Yt3lL6mNhV7EW
 bdJ4liUW
 jIGthA+8Lyn81Jto1l+5RWvAq76ndpXqB/W3+KbgPZWo07Nn0iUHQni+Pj3UZymwSLpAXDc82pOZR6KbSWXiGFsCiKVpaxyrbgnYXngMFRRVS3LRyABlRbX0y7aLOz33SxHI5BNUlzEpnitQaVd0IIiKjXldY8FBtKCNB2lg7FZ8HecVRwsOVg/FbXklcFxUGCK/SZPhrytJPNkpsJ2yqjhdSzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko found a few issues in DAMON that could cause infinite loop, NULL
dereference and monitoring results degradation.  The first two sounds
scary but the infinite loop happens only under unreasonable user setup.
The NULL dereference is only in a unit test.  Monitoring results
degradation is trivial since it is only best-effort, and those happens
from only unlikely races.  Still those are bugs that better to fix if
possible. Fix those.

SJ Park (5):
  mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
  mm/damon/tests/core-kunit: catch test failure in
    test_merge_regions_of()
  mm/damon/vaddr: drop last same folio access check optimization
  mm/damon/paddr: drop last same folio access check reuse optimization
  mm/damon/sysfs: read ops_id only once

 mm/damon/core.c             | 13 +++++++++----
 mm/damon/paddr.c            | 20 ++++----------------
 mm/damon/sysfs.c            |  6 ++++--
 mm/damon/tests/core-kunit.h |  3 +++
 mm/damon/vaddr.c            | 26 ++++----------------------
 5 files changed, 24 insertions(+), 44 deletions(-)


base-commit: 65b3b6001701d46d5360097bdc90dfa1c06a1239
-- 
2.47.3

