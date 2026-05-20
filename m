Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 331DACD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A796B00A0; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501C96B00A4; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3064F6B00A0; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0448C6B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D04181A019B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:13 +0000 (UTC)
X-FDA: 84786820986.10.A3106F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 47C0340004
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIx5CwT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	b=wHqmQTAFY8WWltyKll1UoLcSrqPzbrbEl8ShnlOR7JzdUJNV1wmBetLovIHclwMUfLrxGU
	qNSYXYGmpNmlVe1qyJ2auYh5VDRAoAozSDD3rin0rwBSAIgQxNUh0/Q1faXuQIS6TMbWw9
	FGrf4AAz9V58sZXaeEb8OxLhb8k/ssk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258552; a=rsa-sha256;
	cv=none;
	b=d0B7itIDZAR5PEkgCsUsc+4XY+A2NNcO6fMDjGZ9RABwd1bDwzMSvKua3j/HqCQn0yS5Yg
	ONlck/gfP67IApIDqnPPNmZ3HWcH3/ZQiqYvV4D7A7Rm5mRou/shbd2BNi/Xrhl/77g1uz
	O1zG9MmCIG+bzYevbMdODc6OnpB9HfU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIx5CwT5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1415D41B36
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDEAC1F00896;
	Wed, 20 May 2026 06:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258552;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIx5CwT5nbcZRLOm8k2VDrxQfa8PQpvbQfcOhB7cOOIIXPOpGHttLzr5ixoqI/jgF
	 X9ylB9chrO5IPmhcmMm4VHYaZFKlGKXc1//9zibxwUFmEMz3v/q8hmQ3bzjaNfOlc9
	 G66FwJDGBQj3vIyzeVAvFBETr/IDuwyngnLFtY5hX2T4SE7vhNk8QusReC3bXyjNi1
	 SNdSTxzQNCO5dDEQ/CAuQSLqdWQerxVsPvkatiNE7mAa9snjVJ4LLJYx63fZe3M6OO
	 sLF11WqiKT03aXObWm+ComvFI+QFNsbWeIDQUQ9qERfnKkjFAr7Do1X/K4mYX5btgq
	 Q1i24obrBR58w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 12/14] selftests/damon/sysfs.sh: test monitoring intervals goal dir
Date: Tue, 19 May 2026 23:28:44 -0700
Message-ID: <20260520062858.167011-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47C0340004
X-Stat-Signature: up3fodtx84dnct3ad5nn7dqt1j8s7ta5
X-Rspam-User: 
X-HE-Tag: 1779258552-77702
X-HE-Meta: U2FsdGVkX1953I7BmeAHWxBNTpWAJHZxLguJgh63tPtGyF+pzVuvJQQGuTpGygyjUYcn4ywySW39ZAX/9T6acZndbR4FPdnGxMM2HUuEK2rxt233DitVpRj7rzioSPZwgDiVNpmX+HQTu+M0Lc2G9nvV6f5A1aZJAa/9whNxht651BRk7rhWpmbY/cBUHEckglzb1bUbcBUhh08MpwLX5Lf7IdavvJ8DusEqt5awz9i2CScy5/auyVs2xs+CiXYnWXnsZ66g3BAhtNOGuXZr7cEcy5Pu94W9KrBar/0eOqIV5lExn8AdXPYiIAneVNFbI7AAuOkSyDlU7VbiZ/Fi4IpysuecCpey5RBY32mycR1Jfs6gYkvrDQWjf3RRPK5j+sn3uqqRSXXRa23SIzQaMLyYYjF/xxwrNAo+ly/zFpuRgifkjUsnVVSvRwWQFFtV2XyOHYVzW18jBHfFhTvGGhIFcRArAwOaW5WmYcT1CXyCrZ6EhFpCDV7YCiPuZmll+oY26/1Zh5pIsXo5J844ExGS+WYHvbLJfO0MFJ3EDtwyXOsiEkXpHyCgPblxV3SYAN0WjlW8vZ5lM7qA3x14JLXc0QSClVYN8XA+BK+Tg2bUhtdr0qTtzQK/E4+jMMBUnBw6QT+kmVACpVBAYKP6JuoKiNAxoqhVxjs2oLx1O445Gs5baQxD6b5qQ9PAnhUTnF2xBF3xEIzun0pEw+KJVgz/TKJhLJjMVT8St6PI2KggEj9rFVMuOgKNq8UZ9x1k2GpbcIHZ/iunxrngHGCzLbAST8pccdC4sKcQ+Ah/afKf1ap7mfrUIqL3DUWa8HJEsKGq8TW32gboB3+5qie3C3rsFl0gnim60LbEeqlQIhpQB/YNFSsiwK0ab5XiCBHjWLSBICt5DZs9NMCmKGdE9h7dZJm0b7gV/vT78UaRyaVrfoE4H/K06Lh8p3+6Aq/6XKEfZRxPuvHNLI7WviB
 nJQ2ELbV
 nQgL8CUr5giiMECCCCc0GLwBuSdDdI2sWxfV0M4ss77QrfRDhUmxV5Ss09abSdin/lAuee+ZpH7TaK8V5Avw8ZD4Vzhxelo+l4TRyjSf/gl/G5bTryChGj0hbE1fFCcewnUM2fA8GotvdMyFZO7Ep0D2moO03iiWbjzmUqLEWI4vUW1wuMdlVh/jMrhehooAihY59i7FNAkdvy5Dxwtep29AVfyuE0elyXkvFakEP7oshyqozoVXgcCUc/yzRpvGrZZmiUvD4FoD14EAsfFjQaFzwRRJ/VeWGH3xEhiCa7hSSxoo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing monitoring intervals goal
directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1ac3e2ce8e448..b3418214ed358 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -282,6 +282,17 @@ test_targets()
 	ensure_dir "$targets_dir/1" "not_exist"
 }
 
+
+test_intervals_goal()
+{
+	goal_dir=$1
+	ensure_dir "$goal_dir" "exist"
+	ensure_file "$goal_dir/access_bp" "exist" "600"
+	ensure_file "$goal_dir/aggrs" "exist" "600"
+	ensure_file "$goal_dir/min_sample_us" "exist" "600"
+	ensure_file "$goal_dir/max_sample_us" "exist" "600"
+}
+
 test_intervals()
 {
 	intervals_dir=$1
@@ -289,6 +300,7 @@ test_intervals()
 	ensure_file "$intervals_dir/aggr_us" "exist" "600"
 	ensure_file "$intervals_dir/sample_us" "exist" "600"
 	ensure_file "$intervals_dir/update_us" "exist" "600"
+	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
 test_damon_filter()
-- 
2.47.3

