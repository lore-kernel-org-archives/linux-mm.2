Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A41A4C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 21:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0C26B009F; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8F06B00A1; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F996B00A3; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 590F26B009F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:02:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98B0A16037C
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:41 +0000 (UTC)
X-FDA: 85028522922.10.ABF0287
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1C46320008
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EBdr/xZs";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785013360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	b=P7wXJf//pBbUC3NMmOdBf3ENVabUeRQ0kyYI6HnsQx63QWwQHNg9I8KNwlwkZYxaXm9006
	alVnzHzJBLDASCgYXj7l5iN40TELqEIvjLz7Nro6eHOpJDJkV13t/7ccI9cQ9ibNWSHD5z
	2m/4neCzQHg6k0lOy9sesWnXOuWobpk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EBdr/xZs";
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785013360;
	b=14hj/NCZjMvrHAkfFNfHQUVtPVjGhQEoEPtFbSLk4UbiU285YtVJwwObeNM1OMjgkdOLhI
	kRJiUp8i8XlD0RXlWl/I0B/eM/oKa/Cs3UrDXSj6CBsGwyoMpv/9PyXzDLzmPMq4iqbYDn
	u124S6KvMBlRbrCUw97UjBKzGoz3ppw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 70F76437F4
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278531F00A3A;
	Sat, 25 Jul 2026 21:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785013359;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBdr/xZs5B5W+S7MzLoFwMPRyfEjsW+k6HCcE9NiTiL8uTaryCHfZvNF712h5qJ/o
	 iARWc2nY4mMENH4fOsXpdHiaU+DlNvJx7fHhrMXt9a6ZRknOT6bm7ucvDv/VjNB4ob
	 W0tVoelB0pu+4QSxSECqrCOI/ccK69mA8rB9yH7pT2hksFRUQQ9N5IKwWyVsfOdhuJ
	 cDXfSkdf3X8SbtdVKYOcYOWJrWRfMvfqOBi7u0xK4AgJkeadIiLV4jMLx919Hm9z21
	 7Kmgv3fgdqSf+lu/oPpnUAxY0euGzCmsmH+z7dr6Tn9JgZYBG+D1tDG4gNRUfqSjxV
	 bydtnKdRZhmDg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 14/17] selftests/damon/sysfs.sh: test probe prep sysfs files
Date: Sat, 25 Jul 2026 14:02:18 -0700
Message-ID: <20260725210225.129944-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260725210225.129944-1-sj@kernel.org>
References: <20260725210225.129944-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1C46320008
X-Rspamd-Server: rspam01
X-Stat-Signature: ouj41wauicw8y6dpadn9iizpae3r4zco
X-HE-Tag: 1785013359-416909
X-HE-Meta: U2FsdGVkX18rxXoNdy43QaxC0pzBSW6DjMe6GKsQhpEVkG4gQKhtdCExc5r7R4/dmKHe2OdqgTRUwEgWA9Sq40+1UdIs1gEoRKN5TMm+f+Sztzi3TPTu/+FqJB1Fhp8OnsLWsV+TwNO6zGUblJaFfC/ZPKWG9Jf3DP/z8IfLRm83nYEwxUlq0JcSu/E6bpe4RftUsEly+yTZPHDtc10uhRrOnN3xxthlxGq+1HdVAGL8kY2JWI4uCOkv8SurLMUNuMisTxRvenMYlo5/m57pxRcWlpZLEQ5wDp3+fUS87wzbNjlAPTvID9CAGu9e30apI5cksYyCwXObH5/101oLs8uOMpy62g2BJKRSmfttKhwnDorCNR5QbIZN9MjyuKHL1+2P/ukTzVwu6Yphcnjz04UspVzUZgzQcVZSeItxRkSpyhvmQaW7dHtOk6GDpbvdChwmbYU0pII+9gUUnE+0jtNLKxNQYWSvHUNHkJ67Dofuqr7RkvlusQXE+tdMIBKfqHhsF4Z8NgkWROAapV37ToIWsDyH3uHzGdo/6RYxIXiEUumIQWGWBHFsucGDve5lyYTSQ3aB5wtqVzl33x+oItwSo8nZQtjmpbGev0uyboGXpqcvfG6u1DzF83eQ+gnCjn4BIZJmwZe6BXLoV3f2Yia9jD++UPQhAxt9yk5JUZV+HWmUKiNC+I+/OcPij76oHF1G2doISBFfLD250+Fh48YuRJ2CBQJwQx9Yq+cdz9DAtfBSQK3Ui4A8VPNz+ggYFtPkpIv/LytSbKE3djYDP5RP5MR/NFKbWhMTxOLTubmf3WibMkzVtAm0Eqh++Ryw3HEyjPVVVXePWkXjNAJXho/6FaoIsW9mZhDBnYI3+9ONUB0Tkv2LpDslYTQ1vHs6j3dIrBS6X9dU6JwwzVQIFR5RHxTZdYK5j5E2bVF1YayJWA9Q6UV/cOTCk4z4k4pCj3e+uzt+cpQGl2motjl
 0wn6hqRT
 RoDtF/N+t4wm4oafeGEB9pLmkRTshVj0JUMSEIyhXweDEiITPpXso2/cn+2lZTkoTCpAnBPZc4csqUOQNKWxWbZcCpcmj2Ws/VG984c5V0z5LM3AyPrU5JXUpkXUbWpxQMLDBZqkEgK+QOKFPWG58V1qZaNOWZ1kYwXLM4nAEPcYSaaedqF3btpRVn7+kPjwMKi/CUtvzyITTne2PUxQ8K9Jg5P0qJ56SznRr8sXpPJQV1ZtXkIqZmLd9cYHLRkx/0/2dYHsStosaQgnqA3oROOPd6ZYxD23GE3/vXd0j3W23YN0=
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

