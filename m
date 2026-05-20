Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF3BFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80EE6B009E; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F136B00A2; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F716B00A4; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 615256B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33B321A019A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:14 +0000 (UTC)
X-FDA: 84786821028.22.BB019C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A4255A0002
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgZ50JOe;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7A3rUBWM/Djhjjd8QeXCkcV9IZlc4S1Vf3PBEQN5+Y=;
	b=HNs0CzW8mjQbNTgEbRWKnE5oXqNEcMj5DPOtf4bOcEz2A3tI6TX7wgE1Rj7pbspIx8WPAK
	+aaFAKR0wJDJSSUtM7+pXFuCPopbmSJMJZFGMvsTu7xA4PBhTOGQTwjzx6NUJPWFR/vS5n
	WVOimF6OOdq1G6O3uxDO0kUwJLKQ+j4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258552; a=rsa-sha256;
	cv=none;
	b=BlJ4//6w6quuwZiSrztYwn8fYhG7IFoJcl2KtGWZEMo4cc7WFR/cRVrWgj+4YIx+mIlxFc
	Qx/7zESCnUsDSZo/7KewZujwfA74u/9Bu9SGhDCzzcD1qrVIw6r16c+zrOBLTMSIB7kUO0
	wCsmHtMdSP9qsEEFg9MUP9MRYk58h5A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PgZ50JOe;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78B12445C4
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 213B11F00899;
	Wed, 20 May 2026 06:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258552;
	bh=c7A3rUBWM/Djhjjd8QeXCkcV9IZlc4S1Vf3PBEQN5+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PgZ50JOeLiEuksmomVn2DwKHg94AZjDsM/IsCr3VtY03zr36FdeD4Q/LXTinb6HwO
	 2/UwulH0bEXThMrdWXxhdIEmGBkmM2BrBHTt0wtzro7wEi9WOLmcpSxwM3s2yEos3P
	 bK+QfuctqcaejPwfxNm1Q1HHisvTvFFPnB+Pu+PiJPcSLp0TTCOPhzm+9P0++/bRAQ
	 MjqesEPk9hsm7j5cP3Mnc+BDyznNJ/KtIdzfhuiFeFlju3zg+ZYw4WxdSlaQ2xgLjE
	 wjgRakEo8MdiRY9Fbb3oU+giBP6faVa6tBkluW8oO2rP+gcog2pP9lVpg9GrY7cR+u
	 oCj2LRGqgMb8g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 13/14] selftests/damon/sysfs.sh: test addr_unit file existence
Date: Tue, 19 May 2026 23:28:45 -0700
Message-ID: <20260520062858.167011-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A4255A0002
X-Rspam-User: 
X-Stat-Signature: g1acdsm7ciwmw4f8g3etqt57wzab4zgq
X-HE-Tag: 1779258552-207646
X-HE-Meta: U2FsdGVkX1/zOCSLHvse6QGEO+oZzBPJW39VXs8p4dpRmia4Boic52V0jw2O0UrGJGhReAkWRgPR2wPw+3T7hwzzguYkVsrD2Xr3VRs+kUsjrKDhl26o4dMPYRt6qkcMXlZRTH6zIPWVvSO/o5i0+t/02Fw9dWSKy2SxzDBqi54WwpQlxXybrlPQ0LnfW1LdM6UHK3PXMHlc4lM/hXn9ltLKJyA83wad0e/V1/zPvJJ5gS31UEzQQ5AnAaQ7uLzs+1AoFC0NLGW5E1tL7cIWKQmFRBMpIeBuxJGg/wgByATHkNw350g2aO6gHQZDZX/4gl7LVWmxSmIUppEYPb7SwkI+W9vIbHANBpefwZeGJ34vKKxerx8jbi77bhk8/1qD80N05e/r3kku0iqwG1Q7g4A8wEHZgaYyjF2hD5GfyZghUg5YLbGsVqQKOqctjkcDf5g6SmKYYaoWzQMeqnxj24W+WKIPy5+SEdaB6fsR9uGpqLcyEBGv/rVQXm8KBv1PTiSaQvzdGf/qtHYIjTZXTvHmj7h8Hr6E+EU+a48EECFmDoBoBoca/QET/cU8LYjIFY8yQxZjPvR8jFY9Y2CR2JhHt7IQ+OJrvGBKEoWiPH42h0mP9gnLwcCQ4GArED7TAXn9ENRQ1BID6JoWup0qZ3DFzRvbDJHG1kGe95/zGGqF2VqWx3Yiw0MKQjqkF56sqaNA5IV6qCDHhoRCoMtwaBIDZAKiRZGBQP6pVszGQa3tttujKnPTthDBh1w2gLtcjQptO1NT6Tg0ed3yXrgEFxVrDqHQcgolckDMBWHN4yOoDg5ii6a0b9LcIFfN/jYfwWgWi3v8Fpa1y+Mr4BVSbfTvOE+f6iZR8bgT/Zq0tx6qilWhMgcFYOTj77jH9thNZuoPJ/6okUXLU/J6is/7p5AtRqcRheTK2ulLqucw6hu3z1OeHp6eLmDejEFnR+M8xDqPLd4hFybIhwZTSNV
 4vmPWoLa
 BlM986Zp27mnO5ogjWbd48zt8f47v4C3rA6GkS2E90fe/jrgGKCdDVfW4hGrqTO1k0sZjnDPoeCN4psdNVKtDZ+3hSbh+oaRzEm4zRaDiWu32Q4eJYDzokmsyp38Zcj5E908NYUqq7HzJ6qwAu4tGRhDk7O+cNPiMTKX8P5pfJBeDDwBmFKOU/tb1ImZD2/lNhPFNuVeVAJvut2R84wp5nIgrZnFjrCuzduv2ahvlisJAF85fE3ZJSphYF1NmhbTnoRc0ytyd+3HLcjNi0ctDEyziXEVjYYWQ2YOONV2e22BDmzk/mcNY6Frmidd/tdWEg5Ej5GR9mcjdlZvxj8GeEABK9YJv7k9pMtmD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sysfs.sh DAMON selftest is not testing the existence of addr_unit sysfs
file.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index b3418214ed358..1e10881afabb6 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -365,6 +365,7 @@ test_context()
 	ensure_dir "$context_dir" "exist"
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
+	ensure_file "$context_dir/addr_unit" "exit" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

