Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B496FFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9505E6B00A2; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9017D6B00A5; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2206B00A3; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6976A6B00A1
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:52:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D04CC22A4
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:43 +0000 (UTC)
X-FDA: 84701905806.07.858F269
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9F2FA0004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gRx7UFjK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeX6x/Ktb3KmB6TDO4M5QdJKq9cy8SwqCGik7CGYn0=;
	b=BB9zsEL0F5lBSjAAk1hDc9EUc/J0rst2yXEEsi4azs/IknrRS5G6Q+KJa0toOCJzpF4Heg
	dcOB3IsxIVn9q9pmqjqlUOYOP0dRbQVbbgoRBAECuOAK5c/BBqbKsddqU6S97n+oBIGbJK
	SXu9DGfRo1YUsS1FtbdV1D8ioM+Yoyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236761; a=rsa-sha256;
	cv=none;
	b=RoSl+F7oCaislk2E2sh3aY7F9OISng0KUpzM+opjWhghCsl/ypBr5naX2yK20IG1UXFnTo
	HK8E33YzywRXtuQhDg25Cil/HC4SxpIy7Rm99sxm0kqYeY2zwg+C2V/WtLUVwemMHk6uIx
	QNdYB63hi3ugGrC7/2OSN3ITL2ieSHw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gRx7UFjK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C77424471B
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76993C2BCC6;
	Sun, 26 Apr 2026 20:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777236760;
	bh=EauBIBzKjl6rFCRlEGSo/s6NrgLL9HoVh8TIqUsq9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRx7UFjKG7iVz+GBgkB2NmPpNVPR17CgtwZ/i2OJDocLdRNO/cyy/JAcgUfnzrADA
	 T3VkslyLFV+bjCWVyIyyCc1gHTvMiha4EuOIpjqYzHU7lPZNkWX3lQkTfbZXE0+mDg
	 kFeTjAO9roxZMD3wrgRcG1+scESM5dczc1DR6QNGQiERnv+TxkDGYXQ19h0LWH29S2
	 oZNiJIJRW8DIa1mZl9MefTbCVtwvBD5u7tKvkcjgmKFRArMx18X9M3+dILfcX+Vyw/
	 cDlmsVCBULjjjwokPNCFDUFKtytHBttrMIcFAUEXme6capLt1uprvgpHISbnZNpj+v
	 GQ8E1rc9gtC0A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 17/19] selftests/damon/sysfs.sh: test probes dir
Date: Sun, 26 Apr 2026 13:52:18 -0700
Message-ID: <20260426205222.93895-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260426205222.93895-1-sj@kernel.org>
References: <20260426205222.93895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A9F2FA0004
X-Stat-Signature: 7q63cm7m3p3temmy5ogpqknpetp3ftnf
X-Rspam-User: 
X-HE-Tag: 1777236761-28780
X-HE-Meta: U2FsdGVkX1+NGQadBazYAFINnmqgbSNgmarxI8rvaehN98DzYb0D3hgP7MCSk4Byax3D4VDlRvAFuZcxBtdjIjMXhOMXd0XHjbDF+Q56rJ4TBnU3T62tmhDxWZTq3pMQsHjFoUQLr736g4yXrTORwBADpbcGFVeOqk5LC+eyk+4cwoOCFCZqZUM6Ywtp6EVkWNYN+04HkcgzJFTG91mnjLhSdLmwHL6SFgs25dlqAg9YvKRUWE5Ti/LdsQzeew/KN1s4YpXrraadRq+eg9eUNFmlOduFXPfPGS62YRRENX+6m7jtDnTHs9m8MKe8y0TqPIx25H/E9RuxL1+HVUcSsKTJliTWPAVHNr3rLzz2oayRa4ZzIcOG4aM1CJG8Ycs2TlddOlSK6wRs0fNrcjDTZHZktFUFE9C5OattoSeztDHd3RNJ3UHcQW0HMIInAh/Eke+xyc4HCddqWpl88xVwFR6dHFd+cJ9e4qEYz5B8QgNQNRo4zu3O2af4Wx+sChnaKDN3K59PT3wf3FOwfG8/dK/bY2IBaslYk232qSZV+bv6pyShIuFzHu/SnA354jEKtXcJYl4V2yy1DRU2l9Pl24AA2q/zs1uk4B2Hx68GxJlaia9C4XLfesfijvSgDrj2/fC0LpdmVFegSaORP7Z3Bc9K4C450N9bZSlz7/f9aW9udP1nWd7rQ6YTK37T355ysW3rD8LgZcrXElSr1C+4YdBCNOGS+kFpWYHQLz+rgRRKwdmqKSK+nSR/rRMEFvN4bwns91b6DZYNXbMAgO5omjfsY9BQK+lNSsK1P/h/Kud7ymP0LuqXHH8Be/fG+vRj89ivE7+pxii0wNt79WVruzJ/cBLNSzQxHywkkY0Em9l+G9rCSBaOWRdQVvk0Ldd6xKJ77p3Ynxlv8MN4z8N3mAAZ8JVwnjqiyjhJmW05lCTe13Z6ce4Zr9r0lvr//7C+kNGceRTJZJJRJaTC9dU
 RWftc+rA
 VYiQgWjXpNq11jBOU29/h+kr8iWCI1n+Y4LtQfByNenKJwzc1FuyZJbbjaDpo1E8k4qApu8xQYon0rqgeoBmnR1A8l+kraKJztFc1DB2IaxK1AtQO+F3fK43Vwkk/lNP4qHedWyZYA9jwO3OJqCyUOSTzSmQABpetPy43m30sJDcsVzgwfF6cK9d8gjWMT/xPm40yQVU15RaWmvIobiCOH9VumFhNXMgsk7C599rLCG+YkBbU0py8Bu7F3Iqa6nwAI67MlIvhQdpk+7GhEXR5E8GJdtfON4CWsf4X68aGjH+PUMQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add simple existence tests for data probes sysfs directories and files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 48 ++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 83e3b7f63d81c..1ac3e2ce8e448 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -291,11 +291,59 @@ test_intervals()
 	ensure_file "$intervals_dir/update_us" "exist" "600"
 }
 
+test_damon_filter()
+{
+	damon_filter_dir=$1
+	ensure_file "$damon_filter_dir/type" "exist" "600"
+	ensure_write_succ "$damon_filter_dir/type" "anon" "valid input"
+	ensure_write_fail "$damon_filter_dir/type" "foo" "invalid input"
+	ensure_file "$damon_filter_dir/matching" "exist" "600"
+	ensure_file "$damon_filter_dir/allow" "exist" "600"
+}
+
+test_damon_filters()
+{
+	filters_dir=$1
+	ensure_dir "$filters_dir" "exist"
+	ensure_file "$filters_dir/nr_filters" "exist" "600"
+	ensure_write_succ  "$filters_dir/nr_filters" "1" "valid input"
+	test_damon_filter "$filters_dir/0"
+
+	ensure_write_succ  "$filters_dir/nr_filters" "2" "valid input"
+	test_damon_filter "$filters_dir/0"
+	test_damon_filter "$filters_dir/1"
+
+	ensure_write_succ "$filters_dir/nr_filters" "0" "valid input"
+	ensure_dir "$filters_dir/0" "not_exist"
+	ensure_dir "$filters_dir/1" "not_exist"
+}
+
+test_probe()
+{
+	probe_dir=$1
+	ensure_dir "$probe_dir" "exist"
+	test_damon_filters "$probe_dir/filters"
+}
+
+test_probes()
+{
+	probes_dir=$1
+	ensure_dir "$probes_dir" "exist"
+	ensure_file "$probes_dir/nr_probes" "exist" "600"
+
+	ensure_write_succ "$probes_dir/nr_probes" "1" "valid input"
+	test_probe "$probes_dir/0"
+
+	ensure_write_succ "$probes_dir/nr_probes" "0" "valid input"
+	ensure_dir "$probes_dir/0" "not_exist"
+}
+
 test_monitoring_attrs()
 {
 	monitoring_attrs_dir=$1
 	ensure_dir "$monitoring_attrs_dir" "exist"
 	test_intervals "$monitoring_attrs_dir/intervals"
+	test_probes "$monitoring_attrs_dir/probes"
 	test_range "$monitoring_attrs_dir/nr_regions"
 }
 
-- 
2.47.3

