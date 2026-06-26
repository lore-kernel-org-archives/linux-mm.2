Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D17DCCDE00B
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 00:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4112F6B00E4; Thu, 25 Jun 2026 20:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2276B00E6; Thu, 25 Jun 2026 20:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AC06B00E7; Thu, 25 Jun 2026 20:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DD71D6B00E4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 20:17:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 540E41C431D
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:09 +0000 (UTC)
X-FDA: 84920148978.21.CB507EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AE68F4000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCV7A5Cs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782433027;
	b=fA2hVphG3QcrcYLHOwzo3b9HB/HhvA5dsO0gJQuymT8dO89y4FrR1LUFpWh64NVsU/kk0y
	Td7nT//e34VG+G04M2N7dVSNtQdykTpfO+7xPIOWGygaTioy1hK8BkQnDsh9amCa7Stag9
	pvgIiyrWf+ppMSye7ssNkprJyS62CmU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782433027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/lP4pJsEcdBFV2cPdsUW/Ogh7Izs8xLb+p1m+SLBac=;
	b=l6KWYGl9ZZ3vNRyLlqVLfL2OMzr2tplvfa3DGgPGFo9gSw+zPxt/8AQVKKd7+TwvGORZSq
	484m7pCtwXpdXIC2xO0bHiCom9YdnmcB9AI3QLDZkKkGB3XSwGHAhPWNfqq8IbmG7Xnwtf
	beLSoyGbxbLDpDBRc65w4vyqFYLQVnI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BCV7A5Cs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04E49443B3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 00:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632731F00A3D;
	Fri, 26 Jun 2026 00:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782433026;
	bh=e/lP4pJsEcdBFV2cPdsUW/Ogh7Izs8xLb+p1m+SLBac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCV7A5CspRBkoI1irBocJ7mdNgvlBhwrJ9DWsY4fn1m3Ndd5+id81IRAgwiFDeIlX
	 Pys5kbIEecLTxSZi84s99izDCql4AQQqQinQx02EKFOynAHy2qzlThG7Comct0ZibI
	 /tQjM1tLBBKm51qR77wZcsO6IhcSLxpk087UMJDrl3diSAm39CLZw8RkVRuOdYOT/L
	 HG8OJm/LsRY+7N1K8dAbcBFt2oMfhmb8XFw7Ndta3ueWbdU2nKKuc/1pszXZ8xemEI
	 kao8u0WyYD0JV+bVJIKfTKNkl5aRx4/WU7TIzqi/AabM+QQZjmX87lhUhGdmOspr8G
	 cdmH/xW7L5rPQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 05/11] selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
Date: Thu, 25 Jun 2026 17:16:36 -0700
Message-ID: <20260626001644.85825-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626001644.85825-1-sj@kernel.org>
References: <20260626001644.85825-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE68F4000B
X-Rspam-User: 
X-Stat-Signature: 1n83haumxka64zmwc18e3dyxzrbzmstx
X-HE-Tag: 1782433027-427294
X-HE-Meta: U2FsdGVkX19x3D/LwZiuaOokrEr9lJ/Zzwjto8e4BpOFKRMEGGx4Cf3XFHCWNc+e6XbP2IepN6x0jouxAteecek7ur8vQl1ayebkgoAMzlX9GgdEh4ac7q7qWrQHJr87EICJo4rJ85260i4oxCEm256e97SEmnRJNL2snQ0wApo9lXhpHfU8MeonSx/4wVtfCxkVEzI8d95DcYkjbbIFu1JMkRnGNaDOYmm0Y+vmCXiP3xUOvFeQb2plNhy146bAvOrbp01g+XQ0eBja8dJkjJGn8L0qCfk46/dVYvr0FtPyTQokWpW6qVXRgly87bOJZr31781vxg3hC2RK39v52IkieEpYaaR34yzCsuIj/+6kc0e10QQkiIQOkHE2+1z5fvwefTnrSrhQya0+JrV5jAVGIY6L8hgznnRMh2JAqBUt/S37S2iXH1zL1vEsjAKsZTj2W2qKOMfWPfjJly6BkjDgGrCP7vHLDNv7/6BFyOL+t3vB+n+z0dawbLb7bw6s+WuyRmM0FzY3zWCtg2zh6x3NPXhaQ9SXhWKHvEJX5fYZ2H03LVvU4TqGJ/+bIJyFJbxCydQ3Gg391Vvj2lFnogWI5/3n56WfNyjcUDC3DTyUiQbRZA0xN6POpqzM/pXvn/aljEaVaw+1FwBDGQE8zkanz9I6DG/GpKj/Uf0FpZmu663CMDvrcII5/0Vh5AmqNxEf1Zu4XYSmTFdeIPoi7rYHDT2EbflqdmwYblI0DudJRt3WcH+U3gIzBCBpCrF1MXW5zjMzeMM6ZNGqGx2tmwS10V6mOxZHuCEZ+kBdTji26Oi+G1bKYXdZkz1gFgyKJhde9jKolOtBvd+CeVhqn6BJ/a2xdHpksslmmfh5QGFOD/YHLNhrH9sll9nlfvrG9vhp8XFXMZ90hx8fPvfRX8X+nAeCzIDI47IA2ThrZ+g1fTLkdV+Zp9AsHEmL+AaB5yAd3IUrFV/aaRiZxrq
 Q1NjX//v
 PNWrzaDIF1Mr/fSEO2n31qGo8Y2GeouDIh8cP0BluARzru97Xn0WTx1lpIdKkUFZrwjkl2gDb6xljDyPhC2OM6DUmrqxycjI0mGGq2UKZ/uewUZPzzk0siMn6uUyUf3+kERH8PFfU3tF5686whPUe3oU6l1ryYCbfvR6/ICKo+xz6YYvyhuSEioa2vVipfAjxc+grVXoubE2Wi9ZzCLZkMY94Pdenxp4Yud68MmGx7ogN1XglbCgIZEa2hS/rJrnhjQlJthHIsfHfIfkGVtJ/zeTBc59iAajiPd+J+o+EOCpM1VsTbKoYIRjxUuHjrk0SbwTWCtrvHALnzsvTYwiTG46y2NCsnfpTFxMO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface essential file operations test (sysf.sh) is not
testing DAMOS {core,ops}_filters directories.  Add the tests.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 28 ++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 0f2ef462a6b6a..07a33995be852 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -103,10 +103,28 @@ test_filter()
 {
 	filter_dir=$1
 	ensure_file "$filter_dir/type" "exist" "600"
-	ensure_write_succ "$filter_dir/type" "anon" "valid input"
-	ensure_write_succ "$filter_dir/type" "memcg" "valid input"
-	ensure_write_succ "$filter_dir/type" "addr" "valid input"
-	ensure_write_succ "$filter_dir/type" "target" "valid input"
+
+	local dir_name=$(basename "$(dirname "$filter_dir")")
+	if  [ "$dir_name" = "filters" ] || [ "$dir_name" = "ops_filters" ]
+	then
+		ensure_write_succ "$filter_dir/type" "anon" "valid input"
+		ensure_write_succ "$filter_dir/type" "memcg" "valid input"
+	fi
+	if  [ "$dir_name" = "filters" ] || [ "$dir_name" = "core_filters" ]
+	then
+		ensure_write_succ "$filter_dir/type" "addr" "valid input"
+		ensure_write_succ "$filter_dir/type" "target" "valid input"
+	fi
+	if [ "$dir_name" = "core_filters" ]
+	then
+		ensure_write_fail "$filter_dir/type" "anon" "ops type"
+		ensure_write_fail "$filter_dir/type" "memcg" "ops type"
+	fi
+	if [ "$dir_name"  = "ops_filters" ]
+	then
+		ensure_write_fail "$filter_dir/type" "addr" "core type"
+		ensure_write_fail "$filter_dir/type" "target" "core type"
+	fi
 	ensure_write_fail "$filter_dir/type" "foo" "invalid input"
 	ensure_file "$filter_dir/matching" "exist" "600"
 	ensure_file "$filter_dir/memcg_path" "exist" "600"
@@ -208,6 +226,8 @@ test_scheme()
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
 	test_filters "$scheme_dir/filters"
+	test_filters "$scheme_dir/core_filters"
+	test_filters "$scheme_dir/ops_filters"
 	test_stats "$scheme_dir/stats"
 	test_tried_regions "$scheme_dir/tried_regions"
 }
-- 
2.47.3

