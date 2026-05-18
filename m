Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB78CD4F56
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D07D6B00BF; Mon, 18 May 2026 19:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21B0D6B00C1; Mon, 18 May 2026 19:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01E666B00C5; Mon, 18 May 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D81B26B00C1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 821241A0A91
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:32 +0000 (UTC)
X-FDA: 84782164824.02.53CDF7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CBF6B160009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GAqdjbTt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeX6x/Ktb3KmB6TDO4M5QdJKq9cy8SwqCGik7CGYn0=;
	b=KSZwrxrSWp2FPMX1cqiQJkb9QIIj12bSJOhpBYh5lHf1Ct7vsRYMcRXs9nvGBmxqEU/gjx
	t8yB/AdZI5y/6QSXKY0do1iWE+NYEgBScTPkmFShGqGtyO/kPgrX2XCiIu20BZ+8CcFyWU
	Atyt5EqMz+ttzAh6lgM+dd63/Uo7lvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147690; a=rsa-sha256;
	cv=none;
	b=C68E/bpcOnajIqe276C/Tb4h3hh212ym+Pi1h4Q/3XdHWay4D95hyUh5ed2fSDIxPXQmaM
	u39arHpQUnFtaRDIydvQGQvoQHbCzb/TthIpBSc9OBD0GPhqg3wc/+HVyRO1XhJIHdadLU
	kVVnzLB5I1jh/4A84GGhAKPZpcWrnNY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GAqdjbTt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C5EF44592;
	Mon, 18 May 2026 23:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329DEC2BCB8;
	Mon, 18 May 2026 23:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147690;
	bh=EauBIBzKjl6rFCRlEGSo/s6NrgLL9HoVh8TIqUsq9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAqdjbTtt4J592f5rknZPYg4bEy3S6qGxaMY2eqzUkrPLo7adPWZoZWmoR8Pj1lLX
	 dombct2THm3bxFohjssz3OVixZpijTWCsHo0Dop1h6i1PZhUaA1TzQZ0ff5iRjIrhX
	 jfLBNj/j42cmRh9tpjYPhzcC22bMIGsvou0C3AVJHeTDnRxJt/TSLaHJ+FqA5+PsBb
	 s9oThTX8KBpju+wPm9Wah7BX/AbXifDKKPwmLocz+RbtIiSt7y6oC8wmHdP8Yy27Wn
	 eGXde//yUTUzrXqnj02/C4I4OFtdSwIrX4qP/o6Sg+5rtr2sbSKwU60sD09zYXgdUJ
	 PcOz4kGZCmYJA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 19/28] selftests/damon/sysfs.sh: test probes dir
Date: Mon, 18 May 2026 16:41:07 -0700
Message-ID: <20260518234119.97569-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CBF6B160009
X-Stat-Signature: 4ittopqfkcz51gyztmtn4ca8x8a7pz1d
X-Rspam-User: 
X-HE-Tag: 1779147690-5556
X-HE-Meta: U2FsdGVkX1+lIQZUMdS8Pwt9TOHf5eWykrsgCbe5cFBLrVIUAqdpTs8Q6mTRgDHUMjtD8QQMwHXfS3RZBFiz4VfnhrQIrLwXB2MgpoBp1Nqt8gfDWgLmISbaOigzz4nQ854iQ2QxCG4dEOR5Dwr9arEQzTZ3rCceV4f2VCXcEG6kDKjq7nuzfjfW2LgcJ/VHNghbIbzOdTpjJoeTasTwvu0IBbagb9gsNR3ji3Ry7L1tyndFl3w6M7bgAadnWd480eVMeY/Nl/ZUchh2dFJFZfV2GfIiCuglMdTLTYRSNRq1F7IRiUk2xK6C9yZ0raiDPlo/nvhZsniHqJ8GEKbQoxDSkxwTMFwebX3Hff5sJXMHAgIuLK0g1WM1/JpMtBQEPjzKuz4/FTyZuO0iuu1p/NcLMmUJTHWfMcmc8bXUe2MKJ7YZ/kS9ZjVA5UB4enjs47o4ghsWJanudRtJLBv75eGtqqEYZJoJnM2hAMiTom9v7ywXx4gJinrwqwb9IXIRGnBjbbuqzIlmiBpbZ1xtNDeslSHaS4O9ANI/uJbDv6/bq8OXyhvGXeu7o6+y0txQtf/3lCwp+BtRrM7akrsBNkDTnTAveFmQ6+34qalCKiiB5YiKbRbUFQdYoPOSZO6r9mknorIjUSkR0Z0M8DYhD8DPqWPacuNiPfmSqTzVN4dzZD3QFLLJS/u/EMTVikTRGhDw/28v7gK+F9/LosfDsqrWr/eZ5E0LugnuUNoWE74Uig6nzLnkDaP3y8bUvlooKEkDmOfQWwIGgqvogsSmYOtDo02w+Gj3Db6DprEe8acT2obJ2yjM/+MnMOheHQLP8ZIxLv3J94Ma0fi/9M/z126qVCiHZIg+bdz19zawVyxd8kIHqqo5j3a2+AzhyYtVrEmrEwBOPzRVqXofDiz1nAYPREXSHelXingRBJf1sSV4bshrnGE7Tf9RGCB7mPWr4v1ykD7guYxQUrlj7Wm
 bUKR4wNb
 3hwbLTefWWf/IRlmWd2Y3CSFu3wiUXycCuuQmrHroBQtCJOV2qmIhuUVBjvFdUJVhXJzvFlOJfENbqHQ7zRWLAheeudjI+qEUr35WarCXtWw3RBZnMb/Cmub5LsZgjxe5qM505/GpKOYz/9BEm+SSn5ab5IV2Y3sfQ9zTp7W0C38BdIqsIYVnotvj7Ul6iyNiE5GaG5btnFNGrX1B4orzjm+PvUBCYVXxunVithd4Kz2I67g=
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

