Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA5DCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23E8E6B00CC; Thu, 21 May 2026 10:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C7A86B00C9; Thu, 21 May 2026 10:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A466B00CD; Thu, 21 May 2026 10:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C99476B00C9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94E2416040A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:44 +0000 (UTC)
X-FDA: 84791673288.07.CD09931
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id D3B84120015
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IK9JnRGc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOZYn/0HiUYme65VRURmz3VNOCuqOPU+0+8yZhbpho8=;
	b=WdS90Vol9PfBHhMr6RN0s32r7QzMPyTq20vj61hGBJoYoqLcbx1+jKn2d0P32KMNE61e/q
	FwD0R5Feib1o4bVUwEYuYaCwwtR0kovoUeSZwTw/2FwdKIlTHlwKXhJLsrBJ1jCKNfQ/6x
	uksmG1DeSKOASEnD8Ah/WPwlwj35Vpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374082; a=rsa-sha256;
	cv=none;
	b=WUE+frQTPPCJMGEMvfg8l11V+Jhy4YmmLHT1gNRcxv95pQja6bL6EIdH3eIhjPaB19yN+0
	lWMApMxEfhOXXs5Int+y38eaHrSz9reV15vKzkmR2m1gr2QzmOW/gxN2gd2OT3sgiCYTIj
	Z3hpU9wxCPxI7VefB85NkVwkP88q9tg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IK9JnRGc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 338CA409AC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5671F0155A;
	Thu, 21 May 2026 14:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374082;
	bh=jOZYn/0HiUYme65VRURmz3VNOCuqOPU+0+8yZhbpho8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IK9JnRGcTK2zdvVbFZfaf1hH0Y/rwP6hR3UsV11SYLL8Eeadueby+++WOFS9Rmdrp
	 hFdSwop/qaVXAN1wzBy3PURsmJOa7AUArEWVzUSvhgFo4vs6rPqLZFIsGoIutpv10h
	 o7krfODDUU4idkN14D72zcDVIC/aKKad59jVFDDMrl+qa6euJ8Qc3kmHkU3lUB0FwX
	 H/NP1OhsMBe0CjzFnaVeUqQyrYAV0QTCDLGb1OppaLVA1Ic5PLLoQfTVSc0yRWDJno
	 iceoP2mrfha1O87pe48OZmwlDA/tLfqs0DANQOVUUKrCy4Gu4YgLPVrQdYuxe5C1v7
	 xR+jIMpf7pmwg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 13/14] selftests/damon/sysfs.sh: test addr_unit file existence
Date: Thu, 21 May 2026 07:34:23 -0700
Message-ID: <20260521143428.83157-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3B84120015
X-Rspam-User: 
X-Stat-Signature: 4oxn9eoiawzjkzc7bhm9p9h4s17iqpqs
X-HE-Tag: 1779374082-75612
X-HE-Meta: U2FsdGVkX18a5TjKy9otmx4d+CyrQDSvVT1WrgoBUOrRUbnrALi/vYNqJVXdfqyD3bMVl1tPwWFrgzQov+/YDQc6QuPZUcH/N1TqU0BYxhyjv7efsoA8tep2SZfmW1aKe3E8gNURX+9LSYZnNWpg+Tsubt75atUZvVKOWZZ/TU+F1ItsY7ppNk3rW5OPqRyue8YUCprQW8NJ+r5/+ThJoQTu0+73mgfc+sRKutPtrdyKaUbp/ih031IJEZyvIBcCNLLgHs1UYW+ugaKGVLlil7kQb7gYzQk183vL2vyerdMaAS/GpgOkqrZVUCnNg3AKK4oRcJxXhZ8utHoxVh98/RirzfqquYwx4TwfYZdqcKgnRVJwGX1Dymj8V+RjPzdNTvn0pUxA5k9uDpVQ1Gp/pU4EyirrgyeNKRxJnY6ye6ZR1XWdVI8n0WlRdINZbtq+sAMPsere3FCtf1xF0IZsAcaqRWvzXKiB4Vq2sgyEO3xlhaYNr20JbLnH5dJQ6rBSPze0H9TAZ1JFdrwf26QNSdAOHrFmlqC972s48VuMggDi0HBERlpqIDRja8SQn5vnxPNdia1QjX5ej1M5kvW+iVQINXVDsJI1c339ZGT+NEpm7OmvlTlvXk2d3RQzTpbUbp4O709hVbQ70TN8C1NtJbyUHI+NlA3q2uYWQKtye8jPmxkHvpPz6d1mq9svnPb1/hI8AWIEiGGm63YoHS6pnXCHkzx5fY0TupnqTRWLy5lbnqlf/9EySnECKbdzY87J/84RLIcoKbc84ZRUZIF/h/7m2wd9jiJwE4QSlJoRp3+W99UZoswvMtBUyZImXmdLjeFYWKbBiMiQR42k3Lo3S3sfSC6B18Gi5eNE37/Ye4TLOhoMSt4yY4bHfs3SZZUKvprdXU9g202TYTeExLaC4AMwJ1iBrp41H2avEkR+jsDYNalac3kapAItD/hIgRUhcc19/7nJG+4Hw189DHo
 6+H3PiP1
 m9kqIqAvv+lybRuCvd/22kuBoELcqMGnb+n+WPzsdZRss/7GjKEAH790+WowEyMPUn2aYC8QzGXSX/dE7AYZV0S6W9/OSA9olkQvSmO3SU99Wiwti5cdgyHidnMTlq/zaevmsrvLwRVtoVqEeZgCwbKiWb38HxMbxZwY+3UVWdkwAYuJjZ+IawfKr5+PrrWKvVEqKbCWZsG9we8pmloSBcAvf1yQwe7AO8YYHFq5O6NYUuA8s654tiofM4BBT/T+4T5u7+KSg5OcLoiNa+pPk0Bq9bT7ygnPvlMtfYJ1CJmjv2q3csTRlpbFGqmnFPpxfW4q5vcBDk9PONJ5iCv1jZ/TuH7lLnPXehnAf
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
index b3418214ed358..92b44c86818af 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -365,6 +365,7 @@ test_context()
 	ensure_dir "$context_dir" "exist"
 	ensure_file "$context_dir/avail_operations" "exit" 400
 	ensure_file "$context_dir/operations" "exist" 600
+	ensure_file "$context_dir/addr_unit" "exist" 600
 	test_monitoring_attrs "$context_dir/monitoring_attrs"
 	test_targets "$context_dir/targets"
 	test_schemes "$context_dir/schemes"
-- 
2.47.3

