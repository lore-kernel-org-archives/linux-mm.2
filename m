Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8664FC53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F40C6B0114; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 182F16B010F; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04BF46B010F; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C30126B010F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39A2BC0677
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:46 +0000 (UTC)
X-FDA: 85042093332.16.842C4EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8EAAF4000F
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiqIDOQw;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DKnDu4X+rd4KrlY4SCfiPQqPTppxa4AM+AMSVEZhOAo=;
	b=KFXkXPbxiJ7Byfqv7d+wa3vb2IZXcEKxlNYBHqwztsRoJwFAS4I7W+P87m5W2OwjrDndom
	vMmnhMhyfdNBnTqQPpuUC2zFVbAXgGk1RsvZpnzbSYIJzqfr6r9D/JoqPRlf61DNfrtJP+
	VZx6BuqGn2lP8zMFBxZ9vlOJBeLStdA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336464;
	b=1W6NEM6H9osuYFWdiljOspVaeyi83VsHp2cXnZB/qY+EvAePtRO+sElQe2oAu3qpdraEDR
	+glxYM4psvJ0WJQEnOjswS9j2fRwnSJFGByoj0rIC0qEiZ0MgQA0WW4xpvx+A4bePGk24e
	0Vhh3vKim83Ziu3EQmDF5Lu/VoN5Nv8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TiqIDOQw;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B14440DB7;
	Wed, 29 Jul 2026 14:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C561F00A3E;
	Wed, 29 Jul 2026 14:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336462;
	bh=DKnDu4X+rd4KrlY4SCfiPQqPTppxa4AM+AMSVEZhOAo=;
	h=From:To:Cc:Subject:Date;
	b=TiqIDOQwPGDBSVnMJbEvoEPzZcNn+F3m5XzA85F62BYB1ZlzLADlSx0vjAchcq/tj
	 mXRKiKsJcnrgGuhrL6l9WdmnBs8MqDA+RS272sbGKsCHhmaEaUCu/xxc5ncW3+ighg
	 hcbHAAjkvNt2/ElFUCantFwaoxwv/TUkQ8i2Dot19CmoVnQymCCc0YR8Bj9l8KjsYu
	 FsL8VX2sEPx2S2fgv3GtoxmoKO1cMBisiLnukS7KV1uQzMcI97ou9tnlWkJSAszFyF
	 +OSmGzMj5PFeO1COnq4f5W6Mzuqlvfb1jUyu/5P7RmDkC7XY5a89olL+n/woqNgAI5
	 Q1I53lU/pJ2FA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/6] mm/damon: add kunit and selftests for probes and probe weights
Date: Wed, 29 Jul 2026 07:47:31 -0700
Message-ID: <20260729144738.90895-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i7mckynwh3hj1k69hibz3we7h5aeiota
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EAAF4000F
X-HE-Tag: 1785336464-518582
X-HE-Meta: U2FsdGVkX19Y981B0g81KEozyAXSf5fbusj7e3XUCM3yKZ2ktJPY9yVu8vvd+7QcAUc2bG6+s3CP77tW7m0Gth+OACD7dU8Lh0LWiQ+8tUGSXoh4IB1U/sEfcIMA6JMCorbN4fs0s5M+/ax1YLDpAFlB715CSkq67ZJ01jj/qEfPQsctAvLB6wTqxvwewSacP19e8xSLo28EFA/8YxYsNnrBNtwBUVc52NOn4xqsPl/M4qpS1+evs7Tsz2M+TWBpZyS62tA6Kp9QBep/MrosQ3LO8jjF0C0gQIGoCJeaPYLJnDUMbyve3RSd5hdybzghuph05dT84rE6uMGyDnPnQWi72nDphI5a1u7oMXNRa6LrrgNQCbvCL5CcoLtcHu+xBoPj938470PJJbKo8tiTubyFe0LPS+bCVZFQvAeZMUggvwkAbK4ZiuzFTLzRqrngUfHmyOldrN1SIFp9U7yNTz/7w74n0+DWs/NiQ5qFbDpR+3P5gcMLHaVYWqEQ7nLWLafzvC1z4iegeJSxFiF51b+QEo7KXbPtanexboQt+GIB6vZ0iJmDIom22XQUUcvIX55Nr/b6hM20Idu6VXMF4dH2rp98NzTgPzM15SdtRYRGPoHCOAnR7ZbFLjr+G9yFoAatN2cgZGP5OcDDTKBXEwxIxBfbg4RTG7RmWrfvH+Ojsdm3nOC8gXN2ZEBgsZDozII7c9hg0OvAETBTrV58BgSO2OfQ4EpbGphDCqdVGHRD/zLLBWivEtPAiCveYY85GaI/TZR9o2HUg945krYs92bP9ncuHf/tvKy78+nMpGqxtB3JvzcpeMcTm91HrhaEc8Le5XKLSre6IUgME5ltUK0y7JmJRrpXUBq9WiTHgeLJvsuJMS73FVE/RtG9/UkCQLxrvgptLxfapzXiIyAOSDe7xRgm/1FMH+QvcCewAhLC8SmykN82y26ptNoHeT7pvNxbvI7Wbajg0SU2Bfk
 EA1s1FnT
 j52PYPb98rGlo9sw8JPReZCmDMuChYN2bAOAxA+EdCA3T/YVJoWq4WgB2xum8pGrL0YnK4rpKO32g5cOr5tjaHZLMlxhEvlE0zeBdCFQpW5kDD4DPHbUNIb+dkX5eObLQGgKUTd41WKJwbE/Q0gmD1i7pqI2kPgKFeaLDCcHiwOzD7GxsEDAiYXevwouAQoaR70ZA0vzRMJLhFkA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON recently introduced probes and probe weights.  Add kunit and
selftests for ensuring the parameters for features can be set using the
core API and the sysfs ABI, respectively.

SJ Park (6):
  mm/damon/tests/core-kunit: test damon_commit_filter()
  mm/damon/tests/core-kunit: add damon_commit_probes() test
  selftests/damon/_damon_sysfs: implement DamonProbes
  selftests/damon/drgn_dump_damon_status: dump probes
  selftests/damon/sysfs.py: extend commit assertion function for probes
  selftests/damon/sysfs.py: test damon probes

 mm/damon/tests/core-kunit.h                   | 121 +++++++++++++++++
 tools/testing/selftests/damon/_damon_sysfs.py | 123 +++++++++++++++++-
 .../selftests/damon/drgn_dump_damon_status.py |  32 +++++
 tools/testing/selftests/damon/sysfs.py        |  35 ++++-
 4 files changed, 309 insertions(+), 2 deletions(-)


base-commit: 2f558ff382eed84b9ffde4dbd630a1fc4c57fab4
-- 
2.47.3

