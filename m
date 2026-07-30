Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B189C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097006B0099; Thu, 30 Jul 2026 00:40:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B406B009B; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDC3B6B009D; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC8056B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 49C7340435
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:40:00 +0000 (UTC)
X-FDA: 85044190560.10.ED712E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A3BE6A0006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MX7CteAl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRRcJRQPR3buBmMaDcVwulWeVM6qSbo735r2+CfQnW4=;
	b=A4GLNA92hZWfhCTnNaJkAxHIO+GZAbPmfVH4ixARV5DVKpouMmx4EVziIGRhB78cbPMBjs
	6oPiVIDIUgN5/5QzmbBl2XQpeyhpJuFsThbFbsr3509TBbZJtoiwoN2A92m1LHqu0e/qDq
	4I8+jsCIIe1TtXR+ims0R05c8GKybYg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MX7CteAl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386398;
	b=ABfaSrAnxVufMbhu/oZ2l4OW1h7fwOdHM011aFmMmIt+vweazyyUQxjsg1VjOjY/d+YBAg
	eNgfPan6Zq3sEJfwv9j1giplNoBfC1FNhM+EXUlR9HpFRV1uUatO5+Zr23/leCb00S9fDK
	gHUFpdcFGzJNrMRSRgd4L2xshrEzbZw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F14084362F
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5891F00AC4;
	Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386397;
	bh=PRRcJRQPR3buBmMaDcVwulWeVM6qSbo735r2+CfQnW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MX7CteAlQAT5vgl3TbIhGQK+ASQYMO9ml8Sfx4iTLr+6fRM4u22WYD5qTDS7ctPam
	 libpPlwZnJmgtYgP/rPAd7EPf2B6LC0LvxEh1eeZkRr+RFSgr04XGqrY0GxZTDd74u
	 UMNnKri81St0IyLHiplr5f/Wt0YqHwh6J21BigfSGtOKVDGtkLzdoYSsF3UBzfOwOX
	 RYile5ciWowCFc82keiNlQ799IURoZieEh12fOlAES5vaU+Rl1AcG2lxZq1xF2We7D
	 417nz5OrPTwUgiVwL6LP5OR/euG6cMCRM6sE+d44SO8xee3XZBstuAaajakV+w0eLU
	 COTHHkoM7Youg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 6/6] selftests/damon/sysfs.py: test damon probes
Date: Wed, 29 Jul 2026 21:39:43 -0700
Message-ID: <20260730043944.146030-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730043944.146030-1-sj@kernel.org>
References: <20260730043944.146030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3BE6A0006
X-Rspam-User: 
X-Stat-Signature: 1fb7auwfa8zcuehzo6atupd3uh74r7ax
X-HE-Tag: 1785386398-87824
X-HE-Meta: U2FsdGVkX19YQhxC3eroZfUCIhFeUAn/c/BgRdpOE0pC8/2KqbO7KSGCpCR0c07U3VkubGo6HMR+QX++XU1vNuW9vUYodbQY4DeAbfR5l6nH8cUk8AbtekxKOsbsDnnut5Hce1PFvOM/WU5e/ZilLH9Gwd7sxayGeGUeYByItmVA8nkwOiH3xXrTpABBGBIOOU8TfBnnOJWrT5z9FQvqmM1cq70p8mwhTPZztSWDL7XQbeFQyz3N7mYFQlrKX4zWih5BN2FNDlfhENJVGYhFnQiq+a/86PjkeeMaUCYU5Gd5qpXlfqBJCBOsdeB2a4loG8ceEwTftrx2aOn7lJlDEE913c7SoPxQe2P8NtRjlpqjj7nUBTsjjvze5Y5gBZXihzC9Y88hzBrw4oWqYf98qsRNGoGgxKtCs7n7FMPZ/yILZhcGCF5yJKFT/iubuhkB+ZuBsMQZKkwcaH+EvxBZaaoaldu87y8Qr6jpEd8e2K5HRy4xEzx5viKweGcO3uhtJ4CniY2ev2Fu5HEx5S/TVwzJY6m48PXS+TxcQKyGZBlO/VhPXl6/7AjruEHDb4+SjMEbf/uMdnc007TVGGuD/zA0bgFCbmECvgakj+pdOC+hWHsdILdnqSNCnO5GHaiGcPRuz0SBpOzhBKXvQlbJXyFIrWxMmIkJGlzlTH/NvFmHCLZ2eaLVfGoww0gPfCgkEZlIpYZRJTJYVgbWnkQC6pnTy1KfSHglb2uIIy6P2Z13bKbwDEJCjIaAFWjaQNB6GfGY+2BTKUUaeM/SvmWDJh3kNRv5Zln8EzONr+KVY6M3OiJj6BdkfFhmq6jzVKQNuriVc9WGcm+Ub9ESoIS26xWcAnXg0QTP7cFyGoNc/b/dOVHa/aKl4vMxk7StosJiCSKzqmRxD3YDz7YwIzXTwtMoM4ejrGHdrw520YXDmwi6eSBUxcmmzY9vaE69fANj3AgyjPpfcHIH9nliMFI
 OD8W1D4D
 zSs29fBHJWX8jeZjL9qdp1DcpY6tBtUAmLsUz+GHag/Zam3+FFQxj7ktg73G+9yL1mvkX3JTancR8T42oy06l9ZggehKjSEvufkE1WHqW62ju13myFjDdBFca2UJvfCKPJRYpK1B46z8R/z4JLF7vY9xJu1s943NqjMU+ai6lMwLK71UoJ0aNr80M0kOb4om1gfuCoNIDgxU09t1PnV8CzwGARER2pMHbm34lBo1Aiq0x40TcR3RY9UPLMITY8BLFfwuLSbtCvBjd2+1ppNJX03+XWu4y5fJxqBdTmJHGjV3ddF8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py to commit DAMON probes via sysfs, and see if it changed
in-kernel DAMON status as expected using drgn.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 159cbeac067f8..66c826189320d 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -319,7 +319,21 @@ def main():
                 intervals_goal=_damon_sysfs.IntervalsGoal(
                     access_bp=400, aggrs=3, min_sample_us=5000,
                     max_sample_us=10000000),
-                update_us=2000000),
+                update_us=2000000,
+                probes=_damon_sysfs.DamonProbes(
+                    probes=[_damon_sysfs.DamonProbe(
+                        weight=42,
+                        filters=_damon_sysfs.DamonFilters(
+                            filters=[
+                                _damon_sysfs.DamonFilter(
+                                    type_='anon',
+                                    matching=True,
+                                    allow=True,
+                                    ),
+                                ]),
+                            ),
+                            ]),
+                    ),
             schemes=[_damon_sysfs.Damos(
                 action='pageout',
                 access_pattern=_damon_sysfs.DamosAccessPattern(
-- 
2.47.3

