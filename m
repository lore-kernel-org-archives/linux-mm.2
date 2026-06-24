Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCFAACDB481
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 784406B009E; Wed, 24 Jun 2026 10:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 735376B009F; Wed, 24 Jun 2026 10:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6DF6B00A0; Wed, 24 Jun 2026 10:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 314E86B009E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:31 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0104C187B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:30 +0000 (UTC)
X-FDA: 84915016620.25.92FF265
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1C35140003
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gV7kwimj;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310829;
	b=N5vbRZ3+FC/mxpG4q6H2IKEXDYxnWZYyIV7fRkP2WrdDAWyUBalQVzUGqJhAbLq3g5RzbA
	i386Gjk4LUlbqfR+uWofOKcrRhvahCzg5OZ3s3N/nBFbk1HombRY/SzcbehNUpRU1Ll34F
	jvZPZ+bcSke0iP7o1aZ9xruwJFaA2ck=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5Ko9Sc3WGq6lwgzFKNv7VvLXkmRDvSBGDfYu8mlh0s=;
	b=VT0oqvfkrlEXVyCse/o9SDF3g36IK30lQLVI8J7ZLhC6D+eeerxjaL7G4KU5G8BmTPCJxO
	MB+sAwT6TnSrb/wCjTQmuyDPRIUnEzQ1muH+qM9NXQ1nZCcfTc56ByVt1jEnE/Oyozq3Ex
	TV7tB8LI372fOFG7MumCPSX9ZRQwArE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gV7kwimj;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A6F2F60217
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90691F00A3A;
	Wed, 24 Jun 2026 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310828;
	bh=P5Ko9Sc3WGq6lwgzFKNv7VvLXkmRDvSBGDfYu8mlh0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gV7kwimj1WKYV7qMH66p+t25aGoxfZs35uM+els+I0AdC/TvGRQ/EpfJqqQ1JxbzW
	 TQtaAjoRDuaVPKAoCfw4+6uFB6+yLGCxpS4kEXxntV15cyIazkm1AfCAnhpFI9Gc0d
	 ubyKApDR1stgfuouIYECZCIAR3O2peTYkpMYq2Dt8ynhJh8KdhhBJw7kwMX25QkepS
	 yzhgL8RMg9vxdVIFn5eJZ2LXov9vJ4DwgTeka9rBq2+D3uUccUfo1o+O3uhehGJKQB
	 +OnvRtjl90Wtg9thhc5VrO1S8yH8e3xmu/bK0Bp6Q5oVEWGStBzW26pRYDVky7z8ta
	 Z/WEiqh48XjVA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/11] selftests/damon/sysfs.sh: test multiple probe dirs creation
Date: Wed, 24 Jun 2026 07:20:00 -0700
Message-ID: <20260624142008.87180-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1dwo7xe5xyk569n45fosn8gp7gn3uujp
X-Rspamd-Queue-Id: 1C35140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782310828-81604
X-HE-Meta: U2FsdGVkX18Ih+632bGJFyAtd33EKxjMohhHrbjP0Y77nE4Vpb1Oo9uSpNJSrs+mB+j1sJOyeG1qOKkub8RPmQacP3N0+4JiD4hOx8oRmWFB8mnPlIGTX3npLRacm1wK5gtBvCwEBMrrB9bNuMCiwi+4xDm8uz2Ew0p+mIZawi9cc5aEw11paIbIne83GJr5+qntyL7DT1xzfiGTIN4vKv6if0ojZMYvXIU6lm9O0EEDoZeGK3SzadDbb2FYfQ4IDZYjTXzHURqLygyvQSYnYFY5EQHzSdzJraIsrnewEA4D0MNT+aANgVX+o4pXCshf3QBKW9qDuMjNJrW/C/1duD0TbB2XHatD/iKeLR6NsL0lBdol9bhJ5QmbocNq/8LW2RXbA1Cx8hPNleeJ9mkHPKQU3aVTAKJ50fsV8I7+VVJeCiqXfHElIy6fKM2Aio+SHbZJlUN8dR5JCkgM7OhQ+7zJHNBvQN+mpYc8oLszQCkEKSL0tWkroyzf0EtosN8OJ7nGMJkqdVZorQUWy7eAiCJxV3PNLlnJ9YEttotEO4yhfDrivj9h1G5REuvOxEhPRwi7G4rqy3IKJ17UL2RNl7P/REK+tQxQRuB+BpihWciD1gnxF94uWMKGhrvvKb+h4L0lkonUt8zhzAf5yE50C2jOXgG1nVc5NWs4IFqrL7WPW36ZNHNNLQ1KhLZABg4mHFenBIo+B8OHs/NQ1/ah/81sShtH6RGcw+xkqKtREJQ4ATSSuXrHO6HXQZD0XiIm5FGWBAoUM+Ld31DwxwOzKFIQR9LOOsgpDl+h5UgGKzmsSyn65UK0GtrextfgSChZauPnhTlZnas7/1F38tYA6f1Bgy0aDIBsfe0hqzdszcmG0aNWOnmUHBAn6f8yDg0PJG5KLF/Dw0J85p4r6WOl0/fO2SK46ptQh+QjUfjE6BMvzJFFOaCMBypNjomEYqBvME4oH7/7Ijuk1nit0RR
 B4LGEtKO
 u8iMIDgF0FXgJdM3oevwqmRQ8DylHuMRPD6vYFNrlfrHHUPCWwqp12qH5jiHJpSwbhtrLDBzk22NGKNr8VbEB3rBLvgRoJpNCfyXV5+Pm5NHb5GU9beB0uwu9ccciQXbyUtUSHkydNm2nNpIdyJj1yr2/cZH6ujNZRxFLnfLKpt5AxSComeavfkFIDiVJP1zNt6L0wERiiu7oRO9/5Fv+YMHT8gBtF6fk6q6RJ/ZDzw1dIEkUmRVZ20vYF8I+TtuRhcXr92+8knZlPveArDScpNmXdxLsUbGAQG+jM1YJ5NHUmcI=
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
index 2eaaa5ae3c5ed..d528dfea44c3b 100755
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

