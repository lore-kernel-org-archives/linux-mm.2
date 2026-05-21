Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE58DCD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB9B6B00A3; Wed, 20 May 2026 23:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46CA66B00A2; Wed, 20 May 2026 23:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3834F6B00A1; Wed, 20 May 2026 23:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 23FE86B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E59AA1C01DD
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:06 +0000 (UTC)
X-FDA: 84790058892.15.5442AD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5084F180008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPAyD8Nx;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	b=CKofBiCUGCvdAS9448GW4M7etd2YLyENCAt3TTs08iQAvUIqHSw/+DL2b9Z29g/LGxxLZM
	/2o1uf6Q7AsgNlxJ7cUuLZP0bgLwVKoL7PBNAjq1zix4rqLza1+KoY1unw2rmokwVhxkWE
	RfY6pnoBc4FKC7yQPwocXffsoFCeQhw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPAyD8Nx;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335645; a=rsa-sha256;
	cv=none;
	b=xrXozPzHE52sHc/K0hQlRVt4ohVsrC6Z9curJC28PrHjBBQlXs0Cb5wdUAsj69/BL87bNU
	Ue8WaxbKstjtfZQmqTJ9w2dmtAdV3ZBqXdvOllpvMu8ZLg7eI2sQ8RxORUlKcSmad8gO0n
	FYWvQIk5FjogIsFb5TQ5PWKwXl2Zpgk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AAC0445CB
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38EFA1F00A3B;
	Thu, 21 May 2026 03:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335644;
	bh=9HFBKYb5cdZ3muhhdyyxDCFvE0VgsBfb1xW7NVeIcwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPAyD8NxpIzSJ4uA7JAYIYRePUtprXVTVZDcK+8kwdINVjv/zm3kv7kL+j4hV6pW0
	 EEjXTeFMj6pCLkL0CdJ+W2BsD8L5P692WGuKufJwUErGLYfDFhrFz4CY9pa9/vkOSg
	 6tXmKTpGESqk6H0ac4lnrMkx2jh0PvmNarMTpnxw+Y6PxER8UCfYgKAHwO1k4JACKo
	 GyyfYc3ampwEYLbwNRYNnrCpaxkJOPe6OnlkpZOzpIT4L1iHd299a801S9nw3eyEWL
	 tx+kajdpdVyvIc3f2hzg0dqbDCEmmZjAvu+Kf0jrTiN2hHco0MSBFX65kEp5eGdfcA
	 684I7KLlsKvyQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 12/14] selftests/damon/sysfs.sh: test monitoring intervals goal dir
Date: Wed, 20 May 2026 20:53:46 -0700
Message-ID: <20260521035349.87565-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: akhgdgspkah5w91rht4yuth9cwuacwd5
X-Rspamd-Queue-Id: 5084F180008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779335645-104627
X-HE-Meta: U2FsdGVkX19XEgyhCVXsvdiSxgpCb3RakFlTs1RRZ2SrEXHYDunBwieqsWZfvPTzxRqmZTQ743xgO1tIZW2LBDt3aHj4Fqn1skTiUdDH/WbruDDDsLbSwbJ0WwaQqoUYE46ql4i+/D4A19ZxtSmzDZiFn4J4JtPfyMAdml0lMYXgHNsfj98HHcCnDr9NSiZ6r/CjJl4JJuPEU+fDrBiDULnLD8cZB7vOmv8eRCuoDcHWjCLoW3AI+HVxDYvu3maYU3aGFQb89UJPi8UYuKGtDFeC4ApNDccaiCX+JXcAu9ATjElZqxdLCPybYqN33NWm4GSS4dfYWfvHJ0e+pknjXgbMy3WEwqQi2OAKncDegXpQZLZnrRoSIVOxNNjPTlszJz8J7q/AIzU0ajGXcFdxL6VerOH0SL2m+FWVZv1oUyhf+sL8TVqih2bQmkabGI+Rx0xA04qCMbmgqt/X1k+jdOAR8rXU6MucdQDRmONcRRCc9Fa1evl+dWDpO5vcaAeuj7jBfQwG8G5zCNDVabYx1ga3XXTNpYvnGyl+AQzLmO/QDKAC83XrLLSmx5vHSOZp7g8Tt5MRciSsP38h/qc1kEK4SnL8unm4ugt6M6AyRSRJFeHZz3bxh2ByMT1NE9ig+T1pupkuFBDXh32ONnouuHb8eDLv18F1dYyDZCvrxLsO+GeY+mP97ipu7cm5HpZpzSwFFTpU60e/lDQNI2rmjaFchwSkLMfuPC0fnbbiIKgBFOYvc9xDLvbIvV6A8ynM7/zfhqq6xxZCvgdZf0ON/uaEzZotYY0NRtUwN+T5sUXglBFceI6/x1WwZVW77giLeAinVGeZiJIYKBDckiLXxsuxn2UH/PmoVPPlWESWwBnVmS0INfQr4aaeHNRUJIbTRVpmXeUqUg6VeU+xAVtUPGTYjmrdSrH1yKnhnITDkfZr71h3PUiK3fBD2Ia3JjqIu0f4ddWYJEOtgvQBcZt
 8RBF9Q7T
 psJ969gnhuCQxSbv/rYTKRUiHE8bFQawIextbgFr2dE/UvGGXQkVsGAkd/K+uG+/k06KzlpN5Q17OE//Kz3aCcxBvpZvNEL6aQbzQcpB6rnuuNb48hfhMrxjPVBHsRWVvCzuU7XILNEcrRKsxzwrzEGprf0dC6ECwvnFsyj4zGXlmQhQqwcp8kAXAv7Xb0s+bla/3P3v5j+Hz+qy8zY2PX+17NjWFHBE8G0gohePjo7JnwhtmLBDDksfQ8PSO4i0OgxrdzEG2e8dO+vSMuMY32KYGmpruCqjnwZOUgw2uoN7z1YI=
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

