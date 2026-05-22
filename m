Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC07CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634656B00BA; Fri, 22 May 2026 11:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E5266B00B9; Fri, 22 May 2026 11:40:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3136B00BC; Fri, 22 May 2026 11:40:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3520F6B00B9
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02BA51A0AC8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:42 +0000 (UTC)
X-FDA: 84795468324.29.E6146A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 687E24000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChsT2Yfn;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q+fxjZuCnosHblIbwlECkpSubPFTTaxfUpkwZ9ZxQM=;
	b=DDq6ZWo6nTnmmA4xwrk1Ih7AQ4OFfFa4mIt4At5SN0dJOawm4lMKNC7Lf93cO+9AgW5Iio
	y4MDqUNKgKW8J7gi29aIpKzPsJ1d/erzmoeiOTLIQBVvc+ULNoPViR1e1VM1uwjuvYwbU3
	na192aBnnEphNUPFCjEv+Y+fBm4off0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ChsT2Yfn;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464440; a=rsa-sha256;
	cv=none;
	b=1BsN8z+ZkNd5WXBC1ik9J0KCMN6BwJmf5NTHji6jm6BgCmdS5t9pP1NZSAMUsrHYVDwskO
	X+FhLFb/jBjUwpWV9PR0BVBj058ZRaSER2wSXPdPTePuoF3fa6rK4Y/MBGSvnoAqSp7dPm
	ryQc7OIMJR7rCvDW+2rawz39rMJopCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CE6760213;
	Fri, 22 May 2026 15:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E08C1F00ADE;
	Fri, 22 May 2026 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464439;
	bh=9Q+fxjZuCnosHblIbwlECkpSubPFTTaxfUpkwZ9ZxQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ChsT2Yfn+ODS1uaG7sqj7mrAPStXFayQ79napPt+xO0tW+zLvsgSOBUwpIi9dSC4l
	 KdkNjot3hGrhxAtESWs35/ke5dM/Zw3b9SHzBaIiG7b94KPU1UXLs+v9iEUORIEKO9
	 7dJIZLQcxpcv7Dq2FM2gPN7uddIh+DwTOjBWD0Evly4/Jzixw7aZo31yVa9Pz1xlee
	 MP2c1H5qXU6f8SaoGA8JLF2QUVqIY5KUdSrvVxUnyQEoMw9qBd4ugJ2wT0PREtXHqj
	 hWb2IjDFgy+4JkXrUctEAN/nYP53mrdjK1aek9SaAAq7IPlaDdUKQcNZhT3OA7K1vj
	 Bu7oZNHwAKSvg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/14] selftests/damon/sysfs.sh: test pause file existence
Date: Fri, 22 May 2026 08:40:25 -0700
Message-ID: <20260522154026.80546-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 577axophj5h75rjy8jss551z5iai3mwa
X-Rspamd-Queue-Id: 687E24000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779464440-321686
X-HE-Meta: U2FsdGVkX1+bR9ZxwemDEijbRsvGhEAFTS56EDDO6fefqVJpEc4FNORkGr6PvgYdKHIy6pUmAvEOF2T42ArdIidjql4kQKip1vKwLFEqgyjh7bL/Ym6QU4DO7qy1Rx2A0RPw/1cEG5zLWUlOyIqNTzKIxqda6YlRX+vcNHddGkH14KqBR3ot/3PPJbF7qInBwV62IIcF2YRW/nWVG847fzpnAhnC3bJwVyK4VD9lWhIa+2uJwk4zZgpPmgy6UdDAmcTq3/6gX5syTIdUdx/WCBRR6OnNAdHAxJY+vycMhQur0f2buUyAtijL3J+dS4RYbCAsFTpz6sl6Mg/UhV96yH7fr/yFkWl92vOlXPvs7zI7bnhLz1eGhQVzzBOos8nyeWLYuomzjYDbksS3EGFDRpnmj4rkEfkLDw7jSURxwnOyLkdeWhwMgDVgFpaHL9swlgKGsqYEfJCixCoR8wgb0N5wD0+bScqyHmYAWqMt4cHwOEHl7+sk4ueNdxkjqgRQaA7nUn5abWGMFAyI+PtbgZeDylW2N3QzoEowCX6vWLsV/eZrPzhha0jHZN1jQlNK6VKkytZ2dnqAMfR8MlCl2D+EwChM46ijyg1dmMplw8ccnYX1kW2da+D3Nh0kKAAlEUDgs+uTZGx0RsmFJjQeD9L+csqSc1g22Esr8miBKCuwKIB+C33QR+Tsauhcd22OOBcnPiP7aWfw847fT8aheyAPMzNjP1hpHKlyzuiLUatnOiQy6GuC/nb8+FBE9guIU633T2r4WLph3DkwSCW4C4V56U8VSJRfcLoBfGBq1R++rVLx0Az36t5ItbYzknaQn30S5pbv7Bt089QjdWZVq6I4rf1oYFhrr4m6huQUSGQMhdrkrGKMcKOFQK0NeamxaGblxcaolxHxKsp/4cb4K84U1farHbd7GJ2e0iC6YXYFq8flSR9I5UaVVNixETK3g++ox6r+U6k5GCNXbfX
 HkT7D+fl
 rqDZqNPOArWER7Oa6h108ISSa9/BpD7C1t+9EkA53oeL7eGz/Ste6har6HReXk99WWGXQIb4lxcSV2QN/51HQYBLL6HWd+YEciSGr57EAuE6C0ZF9z8VDfl9YgyARd2fwclgAJ9q/b+sTQPhLYk8cN8T7WYpxGr4g+VWbIuIsoVVrTmO+4Q6CzER1bewHgEtk9pWMK5ArYtdt1J/rAgTS/LyLkRrjodUgYTFvoIavLBJJ9zc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing the existence of the 'pause'
sysfs file.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 92b44c86818af..78f4badb5bebb 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -366,6 +366,7 @@ test_context()
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exist" 600
+	ensure_file "$context_dir/pause" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

