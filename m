Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDDD3C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09C096B00B9; Mon, 27 Jul 2026 10:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F19706B00BC; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9F86B00BB; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A93C16B00B9
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:38:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4C9151A0184
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:39 +0000 (UTC)
X-FDA: 85034812758.06.E38C533
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id C386C20007
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KSnV8FmN;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785163117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	b=sgtNeNvEiT1a4aqQHnCmX853o713h/HzxJ4QwKMMASLn+n7VflTWZ9TjF8OPMi4SrZNDND
	LCLSq3LgkOEHYxnPY7Y0/EFjKkUHBkxMgU9HdwRNHdNmEJAg8Gn0i1o/Q9PNa04vliDa+F
	0P1Cq4+A6CkazpFvzqND0wNkTAkRyAY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KSnV8FmN;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785163117;
	b=Z8H6Sps7XasC4okdMymCZCnnYmjY0k0ejowYMkMAgV9UcxOBIlxsr+f8m7jreL9I7KZwoH
	PTVKWg2dYkWZCCavfXmCRkPRqnG2XLpaEPLa5UAsIHfYFmMecsxJCAOp+a+AKn19JwgdN7
	4EfkW50nLrw/FtTb/MSBmz3BTqhxiN8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9C96D600B0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246F41F00ADB;
	Mon, 27 Jul 2026 14:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785163117;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSnV8FmNeHv9kGffCEbQy/POwV1OWhguNWtd5yZlBmmRaHNRVS1W0/qHid4JN7Ys1
	 HLCv9JITbYTk4tBSGLppHW7jqGl+WGLBLkUmyvvs1ZXxm0HhiSqEOo6X+2iImmknUm
	 R+5kYVgDOnQzc5mUK6+29ULBD2R4783bTG8ED2NzCNOvtYHpqc9+ljLuajOfG/TuRH
	 LhhL0TmothsXGKLbC3/Zbg3rIdzgVIjEExYCyUWMIkTyQpaIWKSUaABJZJc7yInc6w
	 giMItXRE424VuMSyPp+6VdOt5hR+ZdDYL+8VRKZ6vKrkk0pierLMU/NjNOFUfSMd33
	 /SYFRWMsCAbpA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 14/17] selftests/damon/sysfs.sh: test probe prep sysfs files
Date: Mon, 27 Jul 2026 07:38:23 -0700
Message-ID: <20260727143829.86236-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727143829.86236-1-sj@kernel.org>
References: <20260727143829.86236-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C386C20007
X-Rspam-User: 
X-Stat-Signature: mo8p34abyjkdhcazbnrhmcydhkryk6bh
X-Rspamd-Server: rspam04
X-HE-Tag: 1785163117-9539
X-HE-Meta: U2FsdGVkX1/nnsyqbRV28Qd0yNbVBtjB9Ke9um5gUbXKBEBrlr/ZCSn5ccUqsdem+OtJwz3BV0lMG2zutozO93HYixnbxvcluu2JtfLOw7il5l2uMIa1b4BedI1sNlnjgK74/SQFl382OMr/8beaXS2IhB9vMOZz9l2bwTsXGkBy3XZ6AWKzsdWT/pq+6Alkf0a5UZHr/S98lPOzijXLpNOoVri3+3FgCjyg/VmT+TFUboPcv2xrVrby4pab+tmrq4J9D3696JUIg5wC/wZx+T+geLVI8WokwI8l3xxbBn1Qy1jb/YdZVHbxty21eSNA1Uz89/SU45UnIcR5b2p9PEy0qxrSBex0mobKFjMfO70xVENGljTd9mFUBAHl3xD87tbonXfbD2aGYi9GGNIXQTZlyhnjLaxPGIM+Wv60CZOMGsbn0INX+iEEK+pVk771DmKeTK+pHE9Id90SGM0nt2bi+eAFKI21mk8YVj/jzPAEXPZD8DD3SF0zWqMB05w/E81ZJ18pKmPLN0Z+ujtYA8GwUQbe4SdchM0NjCQlexOaToiIYiKsbM5BbU4S+Xwh2RMeUdm6hgbf2MA/0E9tEAapwwMLNdHgaYi+elrCW3/hhHtgrvoXLK4wodlqOI1nZqARoaazsWyV3WxWQpg8s+ikOp5cIakE6Jh+4RunJIpGgvty6FJW4A7lCMl+Epei/uH3th6ZwELizyV6Qxq1i7o2xdUiNXswNg39edKy8s9C98Nlr5KWwJBMmGzCn6EJ7/nWIh+UKaTU/W5vrndaaDpxsCmV6S9cnwsizraDDRH0ZY3o+8VfbsNkYDOc2vcMvcLcAgITumum6iRqJ8vC7DP0rVnmoMkoM9Uu8X1ZaHZjmIGvKbkv7OSVBPByuwjBpAED2uqCgcravLJ6iVkUMo+iK55k/OtLY/G4KBgNjpH5OVRqlBrPVRCjQFcwS9oEW/NrCY1sb6IAd8riA/j
 4EC12ASa
 bVQY6yXmoUialAniBTr5xlLjSmtZEZDrZuGMFYiheKVRFJDVrzIaaFY8xS07hbDPoEXz3x0yQzFLKgZwUw/V9wQyl36iBxe8KY0zRKRvX+Z6W6IG3C4xV6RtaVcCXhhwZelwhl7JT8SFxvGjp2e8YPqclD5PG+UIlJQBIp8JXmvPApqZnpz+dlW7Wyez5piKVTR+wV1LPZXgqPQAufNL7RM/43P16L+aIdgDLf5xdY+q3jtuOs1XYsgfegEcx+5yoLFz9ScJ2Uc5CrVZn2NX+kxuese2EY5+c+VoIQQ7WQC1+1Ig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic file operations test for newly introduced DAMON probe prep
sysfs directories and files.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index f7fb94b84e716..ddebde6edabe4 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -361,6 +361,32 @@ test_intervals()
 	test_intervals_goal "$intervals_dir/intervals_goal"
 }
 
+test_damon_prep()
+{
+	damon_prep_dir=$1
+	ensure_file "$damon_prep_dir/prep_action" "exist" "600"
+	ensure_write_succ "$damon_prep_dir/prep_action" "set_pgidle" \
+		"valid input"
+	ensure_write_fail "$damon_prep_dir/prep_action" "foo" "invalid input"
+}
+
+test_damon_preps()
+{
+	preps_dir=$1
+	ensure_dir "$preps_dir" "exist"
+	ensure_file "$preps_dir/nr_preps" "exist" "600"
+	ensure_write_succ "$preps_dir/nr_preps" "1" "valid input"
+	test_damon_prep "$preps_dir/0"
+
+	ensure_write_succ  "$preps_dir/nr_preps" "2" "valid input"
+	test_damon_prep "$preps_dir/0"
+	test_damon_prep "$preps_dir/1"
+
+	ensure_write_succ "$preps_dir/nr_preps" "0" "valid input"
+	ensure_dir "$preps_dir/0" "not_exist"
+	ensure_dir "$preps_dir/1" "not_exist"
+}
+
 test_damon_filter()
 {
 	damon_filter_dir=$1
@@ -392,6 +418,7 @@ test_probe()
 {
 	probe_dir=$1
 	ensure_dir "$probe_dir" "exist"
+	test_damon_preps "$probe_dir/preps"
 	test_damon_filters "$probe_dir/filters"
 }
 
-- 
2.47.3

