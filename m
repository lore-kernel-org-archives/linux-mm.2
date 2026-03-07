Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD98F55102
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 19:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0252B6B008A; Sat,  7 Mar 2026 14:49:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B576B008C; Sat,  7 Mar 2026 14:49:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE92C6B0093; Sat,  7 Mar 2026 14:49:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C9B976B008A
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 14:49:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 502E3140896
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:25 +0000 (UTC)
X-FDA: 84520306290.15.F39F176
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id D23EB140006
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJLaaKcq;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772912963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bDdJFCZt2qTSObJAWFEhJIzCM/QWDjRTUUuunzbv0FE=;
	b=Jc7o9YGBM3jOl7De8kIVfjfNk6KDwwTgulL2W6dxSgyr9EYRL2ybVqcMFUNCACc6wtSb92
	JzN6+xjEr2sN/RTLtxRsGy34FypaXOuoZEd4VLJDSjtwQn/eu5xbh0Qc0v9rIoDczCkQK1
	vC47I5YJklNNzzi1B+WBUCEAw1ADkLU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mJLaaKcq;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772912963; a=rsa-sha256;
	cv=none;
	b=MlZ56tcPDPxeCLORSItEkDNYA02i0lhaJSX4gH3Bk6+kdqdPo9l7JYHAXBsUVYjHfq564T
	lHE/lMYFU8lDOFHxTJm2CypWlISdEhyEOkBw7lGxW8H49UPy++2R8rouKHxgYtYrVEZ9rB
	uaj/sXqApAzB+jQi620Qr7aPO5NaRWI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5416F60051;
	Sat,  7 Mar 2026 19:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDB6FC19422;
	Sat,  7 Mar 2026 19:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772912962;
	bh=9pXTMLXjPeeFkiBWY7aejojzZtQ8QdVsGRxu/ihcY/A=;
	h=From:To:Cc:Subject:Date:From;
	b=mJLaaKcqz3I+ylDK18HnDKnTzi8E8VRfiEqPevc//dx16NYIyrYSuLrpEknUCR97q
	 /l1qu964FXZyddPds7Hio28N7Hrz2xf74z8hA6sQt9kpiQMuwz0cKPbpkZwgqf0r1k
	 88Emmeal2z2CL+rosZ0+pn2kDbiee8xvmw9FBZWmTrv/1dASoTYz5MSmIpgpursKSN
	 sX+/OZ67VXMh26RerPVQ6tlsCzRbAVr4BLAtMTAWNSZTGOyCC+owue+7VlCtTS2SIU
	 G1SCP1FTBTwkCp2/7wjEGquAFT1aYRBZTt0I5z12TE3/BLj1vAGkqO0SFRMnzXnd4R
	 543Ua6chf5stA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] mm/damon/core: make passed_sample_intervals comparisons overflow-safe
Date: Sat,  7 Mar 2026 11:49:11 -0800
Message-ID: <20260307194915.203169-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h8kbbn7uhq9nqfnn8tjzuzdsm39cw5ob
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D23EB140006
X-HE-Tag: 1772912963-536248
X-HE-Meta: U2FsdGVkX19WWmBSqHWjOy31Eh8WwluhTj4M0UXGP6ICt9BvUG+xCGJmjuQENL0VnJCwIev49UUHoKcplWQnuDoBZYlIJ7wcVxBes0LvO2wz6bB2DxOM+j3LvWupLYyPhAKNURw/Y18yehub1EucPPhBuGwfRysdvgR8b1S0p7MHvjhwttyaitfTxoyYrPQnLCji+7v+wyOaFvFP4vd3hbdrOdCYryU9ke0Lme+NTJjkHr0p0QSRdDl7ETIGnLdoaWi5eSpADxLV6PQsAw894fMLCcF6pgEtiOF+Xlw26EJjMaN3fjXi/IubAJxxyt+rvhieO8iL+OnXZmqmsiN1OWy9tl5OUBBZbKbz/R9d8l2CGqvezc7OpPfBTzQlA4dUSPqIl2kXQ07z78D7kLSsEojH6Mi/CmAqXWEFg1964Kv1ymZhX8qfEBMVaFexu2nUlShcbqYTSKHlMv7GvohZFOyASAZGzcIUCEfN0H0IdpqRZthK8ti6wWlwvFwWVLa+3e2TzZ1CHvYvZ69MiTwWg6oGW+wAlIloMAj5GoZ8tIs1QY98OMpPq0jjmtkxdZ/wS3pQ/g5PNY1ANVYJcvCko+xVTuSax0jkU6v5J6pXLaqWkFZtEeC/FjZTnfsym80fZlha1NiwwxmQqJVQFyX32suUOcAscnpLVz0OiXitZaVGiIczen6Eo5ga3+lVq02oQbojEBoePg/RvOZptLhOkf8ItwijguV0xrRYezFnm84+OytAtjwylupmuL4tdu/2PXImMiAPk8unrcLV70hXrhPqilprkgZJkN+rvPIPfq7S4DGokdUb4SRyXHv3Fl/YMqJP/hjpNwex2UjlCGN83J44usScsmf2YncK8FcjbTVH43f3pDJLYKrwCbtyseMMTPU0kvOU8/ZRQEkJBGMgFVFJx1HKVvH+EfhlcFYGdwWNHnWu8HSJYJwn1XkZ0rRE9nDDa/GT7n3g8CIbwRy
 suV0WImO
 J+/+P0/lCAJ1nrrGTAAOUsPHtuMUkh6BsDlL9m7nmlv1vECrLDpPa9EnvOkTEwAFnJCn6p73eHdYq3RvIsgnI6hx0SFzr1MHFjPMY2N2tMCMWoumJ+C8qptvzJ5GxlnafmhDhmy3olNVco6guBe/5Ic18RJhmTNLB6kIXxWI5G14rOxkR93JLvGICFYaYKURDAUPjza+D5FgJ+zzme54wuBtTAkiBNxGeqSwrHTE0JJR7p5IMcVNu56YP9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON accounts time using its own jiffies-like time counter, namely
damon_ctx->passed_sample_intervals.  The counter is incremented on each
iteration of kdamond_fn() main loop, which sleeps at least one sample
interval.  Hence the name is like that.

DAMON has time-periodic operations including monitoring results
aggregation and DAMOS action application.  DAMON sets the next time to
do each of such operations in the passed_sample_intervals unit.  And it
does the operation when the counter becomes the same to or larger than
the pre-set values, and update the next time for the operation.  Note
that the operation is done not only when the values exactly match but
also when the time is passed, because the values can be updated for
online-committed DAMON parameters.

The counter is 'unsigned long' type, and the comparison is done using
normal comparison operators.  It is not safe from overflows.  This can
cause rare and limited but odd situations.

Let's suppose there is an operation that should be executed every 20
sampling intervals, and the passed_sample_intervals value for next
execution of the operation is ULONG_MAX - 3.  Once the
passed_sample_intervals reaches ULONG_MAX - 3, the operation will be
executed, and the next time value for doing the operation becomes 17
(ULONG_MAX - 3 + 20), since overflow happens.  In the next iteration of
the kdamond_fn() main loop, passed_sample_intervals is larger than the
next operation time value, so the operation will be executed again.  It
will continue executing the operation for each iteration, until the
passed_sample_intervals also overflows.

Note that this will not be common and problematic in the real world.
The sampling interval, which takes for each passed_sample_intervals
increment, is 5 ms by default.  And it is usually [auto-]tuned for
hundreds of milliseconds.  That means it takes about 248 days or 4,971
days to have the overflow on 32 bit machines when the sampling interval
is 5 ms and 100 ms, respectively (1<<32 * sampling_interval_in_seconds /
3600 / 24).  On 64 bit machines, the numbers become 2924712086.77536 and
58494241735.5072 years.  So the real user impact is negligible.  But
still this is better to be fixed as long as the fix is simple and
efficient.

Fix this by simply replacing the overflow-unsafe native comparison
operators with the existing overflow-safe time comparison helpers.

The first patch only cleans up the next DAMOS action application time
setup for consistency and reduced code.  The second and the third
patches update DAMOS action application time setup and rest,
respectively.

SeongJae Park (3):
  mm/damon/core: remove damos_set_next_apply_sis() duplicates
  mm/damon/core: use time_before() for next_apply_sis
  mm/damon/core: use time_after_eq() in kdamond_fn()

 mm/damon/core.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)


base-commit: 4ef41fd88e37fcdc1751edd9bc57403dba2742a3
-- 
2.47.3

