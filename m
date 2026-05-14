Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F76CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87D7C6B00A8; Thu, 14 May 2026 10:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DFBF6B00AA; Thu, 14 May 2026 10:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67FFA6B00AB; Thu, 14 May 2026 10:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E5826B00AA
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 060138CD85
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:27 +0000 (UTC)
X-FDA: 84766207974.27.B574288
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6954B1C0016
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/Q18Z/2";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeX6x/Ktb3KmB6TDO4M5QdJKq9cy8SwqCGik7CGYn0=;
	b=ChjFHcGaL56t9p/87LMagQnDZrUiT2Yw5QuDNlb1bgTrUrPgekB/ny6ub+IBQP3+9EO493
	NbOHySQtNCCI4Ww6+18qobdLUgsA3993z2WrA3fG5ul9LQR7lvQwGV9ly/yPpkVTJy6k44
	Vq54xku1HzSvPh7nXCxkkzENWDstEyU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/Q18Z/2";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767765; a=rsa-sha256;
	cv=none;
	b=oofIaZtIcNzUG8QDekAjLo2PT+A55Y0O2mPUrZWNHpGx24GL1z6KFrtLgo7BrK+a5SOkLB
	6l3KFXPh/p5WItF6HnHv4G0ukIxRdBxQfTK73totm5TKIjmJYwy97e+tQlUItxQvNrKbhk
	1lRypCNL0WtmJGqiWu2jxeq4+z8wEpM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F182044725
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BBADC2BCFA;
	Thu, 14 May 2026 14:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767764;
	bh=EauBIBzKjl6rFCRlEGSo/s6NrgLL9HoVh8TIqUsq9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/Q18Z/2gp4e1C41DVo5DjiFVe/i3Y7T2vD9AOkCxNKGjNv2X3Qr1isGZxHuM1C8U
	 RDqzNyHcwVmHJXk1XdVE2RaJbqcco/yvBFrXCNL18tP2hwZZ03JKKecKDG5Rf7p7Z2
	 YTTct4tLB4Srl9oV+ovlapU0VhWx2Wy7+J+k0jWYUG9bSQfszNG/zQ+sgqQT6txga8
	 uBAVIYuw1CqpvjB4XojTQIql5evO2wPl/bt4AITeIWfFK3XYtwGWW6ynt8Xzd/hKJc
	 ocK8m6usBtKaYy2yfnQE5j4Kacrryj4r/50orkJuzVeQmGZeAEpykPASD8kL3oqBOO
	 JU2V/rPwVTg2Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 19/28] selftests/damon/sysfs.sh: test probes dir
Date: Thu, 14 May 2026 07:08:52 -0700
Message-ID: <20260514140904.119781-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zg6b9h5yfeqqaeacthk6u6yf9n1h43m9
X-Rspamd-Queue-Id: 6954B1C0016
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778767765-775346
X-HE-Meta: U2FsdGVkX18/9KFwo/AehGthQCXLI7pEuq4XA0IgmgqV362ZwQwgUEWjV7M+J0cGVxpkZQG09MvYm5fzvKI+wMHvUXj6114eRkwoHh+SGIVW/ML6KK4uGKPRSoiLHppsEvNo7kLrkjoYDBbsielGEY4kOutMpSlR21SqkV5gZDRlu8i+CKgohe29D5fIXjyNVmR0TpeJz3R3H1YII1ByH9QstJ8hESrgUy6Ns/NLWFDG5xynFJrnzxIYGMdWvEHKm9OYZdBHIUCyXbWD06uupumtW30ytHQtQ7vbS1PW9MWbelV9yzwJqyCloQGGbi82ehb/PiZSYpFbiKHAvxq9mc42byivtcDmM9ieeW1ELyw3wRCFCDzG2/3VVjM8TeSXGts+km3XlrDqqBUsHOCFbqdGB5RDZ9Tv+UJ2tHdn/RtW5sbHvM9m+Srn+e5k68rT0D0GUvrkvXZq9UJu+7zyE5KJULrwSL4E3r1S8RUXqywMkv3RxNY1705DjCNd2ZBTlQx0rx3b/nho9C9FaD1wOBEzTXHH+qQ1F56IUhnovFE8ObUWQC23u/LBPpQJZ0tF8+xD2bJ4vtx4m38RbZfPcf7ssyncgGUMjcSVLk2YZlYjkbvwmyfuVbZ96nJSS4x2P2sRYzYVG/mz3ZK6qhimAjvOHskydkMfw+/sx9CATZBYRFrmzmJiWH2pYzI0niay3BrRU6ZYnOKVz4pWVo0Xj8Om9qDI97wlnLuRLlEpZzRv9U4QBRLPxYZ2uWIxHUfmWBNHkswzfXzVsUhdnuH2E7gFa+4ISzWKk2rohCL7HQPta4XKz+eik1ANY6C/4J/L6AR47BbN5HVa2eLwfpFK0I4PjY2RmnDjyj5O7quWZyfJUxkqqUb57q8wdGnLFtZvQQaxyTGfrs2+xapzDBEY82iSPpinaD+8pkCKSYFLIJuSmWNM671PS28DOSBMkQkPvqxGG/rXVinfZOJVY9a
 VOKBYuBs
 iUFCJ/XX6Wf8qYFiFRZ8S1KWKCQVHqXzP9I2N3nEK+xmWzLtmRSO6T1Cip8m+R7GSiCSsYtGL++te9BBlTQ73EVbqtsFnIUinuZQIARpEn4YMI+QbAP8izAtPViMrbR6eskEBKngI/S1302HUzrbURKd20afJhWsRokiu8IXzSww/Xy7MYuJhdYYPEjPXZAqUcW0zVa+/5fn7seiMTD+GSArdOYFjC/h3RMV605Yjgs36x3V+pGp+F4W4sYTIJmbnfvANJ0HusVXYIXHrDKVsH2negby6fic3BYUVHmRgWXKJLLg=
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

