Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71982CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF9816B0096; Thu, 25 Jun 2026 10:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35706B0099; Thu, 25 Jun 2026 10:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911806B0096; Thu, 25 Jun 2026 10:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6006E6B0096
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E0C39A0147
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:45 +0000 (UTC)
X-FDA: 84918656130.10.56C2B08
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4EA6780018
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGryyAf2;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397484;
	b=sKeC7uUBQ40V7vUuXumAlQyQFc6uXMK6Q8HheICOakI4sIpEybVj+e+084s3Rnt+BSkgKY
	Tad0Cu6Ganr/mOqrjW9M/En5QSl9yvzckynnvtWKccPm7UWsiCmyWlmV8MJWIb43Bdlp2g
	iH7UwHmmbGnqwng1Tc7MSFTA3G9/hjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61iW0clYSHE8gzHIMRcuF9jxdl/Em5VRtXAIIrwedXw=;
	b=dZbamVVGk5ml4qBS/f3bMpIfE5SiOHpY5rWtjiPt7N+hRR3E8S2ou5VdFR9eP4N4e2hilV
	eCyKH5cyB1OIlSunrkZjmGRsqI3qpQ1g6cH/zGOvLymrGrvYjBZCrJ8vD5LxrIqDFx0Bny
	7e3hKkf7NXuS3qx8lJis6oeTs6VdzP4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGryyAf2;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF77660219
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8866A1F00A3D;
	Thu, 25 Jun 2026 14:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397483;
	bh=61iW0clYSHE8gzHIMRcuF9jxdl/Em5VRtXAIIrwedXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jGryyAf2ng06bi5XpZ80YawRPfFqa6RSfs5aCl0p1tTC1aNHHjT8zNwb3nqSOho7a
	 Zy+b+lXEnshpdxuHY5suXORnqkPzhKUKbU/kndz4vK4ZgGfvoguDyewfN2zjJzm3oT
	 rdbEY72bFqGCenBAzhJEd5fNj4SzNIo+2c6kWm2joOgMYAURtIuzsvV2+FZwY4TR3T
	 07T7HZp3sQzNZyygWhcVbx1nQxE1b/W4+vgBuNNplWgUqjLrnBYR6tGK/vij7ANwbU
	 c1OJq9aQK3xuYAnPKE52+/5FP0psSe82lZ0XUI7OBqcHXvb63PFgPhRy5Mwo2FfNlG
	 BCOUpKX2KzMCQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 04/11] selftests/damon/sysfs.sh: test multiple probe dirs creation
Date: Thu, 25 Jun 2026 07:23:49 -0700
Message-ID: <20260625142357.103500-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: in3f53eted57uy1xfmhquzcqhrnow5z5
X-Rspamd-Queue-Id: 4EA6780018
X-Rspamd-Server: rspam06
X-HE-Tag: 1782397484-861074
X-HE-Meta: U2FsdGVkX1+RQE5IwI2Xybp/Q/jet+DGNQ8eNamATlrclMRuxzjE73QWEkl9tW6jnlhWZlpujpvcya3b4UpRSbdboVkuB5B57xxeBZs0i91N5+wFDbmhaiux/uPRtVQUyQDPsMoIe8j7IzUQKeS9VTWwAdmnq1KvnkNpUabtCjU9hN0iCm9fsNhEl3ef2K7Po4KnrKF7gII2D/+VG2zDr2U+8a8hTZJauVz7ZVfokvJ/R0kQH2PPugbBnEIIH1k/xC0aAhfbKTfFXrO0AIIaNNj2qQAdYj2ijRJ8nx2AEf/oPnlqQk8ReCLApdIOEt+MxYC92Lfw/l7ZFaqLMw6QIqyRWn/3slr6tAD4yszkZT39Uccxj7bDAw9tSs7fo1vqkB/KaAUzwatPVSOcHnNsi/2gx/f99Nw5aMyiEyDoXfdm3iI0sv/LqoUmamR1ERUyTHKi+gSpy6S8we+AsBPMuqS/g6NyIgZcwiqyf8sHE29qxLIqcCaCYr5ePL+XonlGpxFpctgqCNW25YPjik5ECcSCqET1jmv7+Fu4AF7DvEvcwjlLscIMArDD6TUbKi1HrV5Fs8XihKNBGaHlenXLhe4isXtj2PdD+kSySCq1oVA9j+Scjl25jnqDS3CCObxu9bBMIaQnswtF5rHzpgR5bo9mRtvyDlDGW1XnwCxSIeVlEmKOG843BQW/yEWSEbVe9J/zr1ws3v/WghXFGkUMHuFKPs+mJduN4K6jZ+GDg7f4zR5YunHUU51JjR0cFGYVdhu+fmF6YJQL2gBBDb6b6bDed1eHl/hWWGdhjRT97ngUq0Zas0O2AWL5mdob6EkQqLZKXGSJox+IMi3JxwewDRubnPcW5wXF7S+jP4syX0fKc7FxtxoecxYsoD6OrBH/DSH6EEu2+0f+pjpPgrl4lZw3KrwyIS/MI2tDOzY3GpA2TeTc5NrsXHYoYq94DKFaJ48SffnolWkwStl1N8J
 QO3fDAH4
 cbPR5Hzs72/jSyUxptiXo1RrYO6lVO6LHUJ37gdb3gbHRBsA6rvrg/wGG307pU63FAf3hLWGAYd3Rhg+kDWB1lDxqtO96QtR+2mieAajrAb57OBLtRyYOC9x123/GYVR6Cx84MCViW2f6HfxSEpeS2asZuHpPeEJQn1Mu6HeRZX4/bGWSKh6zYIq1c1R+8VfFN2PKsGiAlWorKbnoBEKp/ozlloJG6zuYRipigzPOH3CRsgpJhcpevIIl4Q6vHVB3EU3ljD7KggelsE39psrYJOrsXq4+SrK/S72P84AgLrwKSjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs essential file operations test (sysfs.sh) was extended to
test DAMON probes sysfs directory, by commit 14885da09b0f
("selftests/damon/sysfs.sh: test probes dir").  Unlike other DAMON sysfs
files, it is testing only a single directory case.  Extend it for
multiple directories.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78f4badb5bebb..0f2ef462a6b6a 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -346,8 +346,13 @@ test_probes()
 	ensure_write_succ "$probes_dir/nr_probes" "1" "valid input"
 	test_probe "$probes_dir/0"
 
+	ensure_write_succ "$probes_dir/nr_probes" "2" "valid input"
+	test_probe "$probes_dir/0"
+	test_probe "$probes_dir/1"
+
 	ensure_write_succ "$probes_dir/nr_probes" "0" "valid input"
 	ensure_dir "$probes_dir/0" "not_exist"
+	ensure_dir "$probes_dir/1" "not_exist"
 }
 
 test_monitoring_attrs()
-- 
2.47.3

