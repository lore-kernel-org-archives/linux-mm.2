Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA55DC61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875166B00F6; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EFD06B00FD; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692C26B00FE; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A25D6B00F6
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AE9831C1CF9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:32 +0000 (UTC)
X-FDA: 85163927184.04.1A377DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 20FCE20005
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fLCE2Ixd;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237271;
	b=nQZZQjNAPDcuGVQqsfxEsYc4kvkQqRanqM+i49Er/qFrqZZVin7qjJ968eOXch4aSvupgA
	2yR42r/jQHFqfHAf7FwpgdWkte71KewLVBD5Xa/Wg9UZyLcAxIJFbgwFc6NgMFvvXOW/MN
	tFUrH4QhnlhIbSTh/4Sqbo1Kw6mdFks=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fLCE2Ixd;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	b=5cv0zzey8mYtIXaBlm/goH5aL73KXPkWCnTc+uqYc2GTd1VJeDmeCyR6Y/JYdr16fwZGFl
	NXzSAQdvnoxZ9apQ7lOq9bBXZKMOk7WtPxpneLM8XrNsw395wvDmBuNJbSxcpJnTcarmHi
	0JGBVnfmlivuNiGuKHeDa9nimKBYTRg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E3D640161;
	Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA701F000E9;
	Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237270;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLCE2Ixdi6gF8dbq+fA6A0ezfDrlAohge5ca00te/Onhm3sslbns7GdQg0TbY55av
	 6g/Sg/aQ9rZgJhwTlOG0kCbibygq8/VuaycDskgeVhb3bKr3bhbJi5pD9OPD3h8v2J
	 8WzC5IroH2uWwiwNcVQUj9aV2c37FrLJqh2Gii25Gc4oyggSFj5sxOFm7BcMXPjN6N
	 P+apq0UF/ojAbu9lpaleI7SCVUBkvda5hSQcM+59xHCh9u0pbDTn8OfVheyk4es96W
	 dYGH4fSUE2kS5ZA2gQQLt6R6DA6Zq8jTNjIEYk9gAK/hHBa3n1MBoHYenavl53jUtm
	 zhphVB9A9l8Zw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/17] selftests/damon/sysfs.sh: test probe prep sysfs files
Date: Mon, 31 Aug 2026 21:34:10 -0700
Message-ID: <20260901043417.2165-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 20FCE20005
X-Stat-Signature: d3mtx64fbh7n4bhxcfgi7bi7i7o1poxn
X-HE-Tag: 1788237271-356639
X-HE-Meta: U2FsdGVkX1+L3kij0mswnrqEpHxNsgXoE5pcrCpi5ZOMJlvu4e0sG2ucwoFIZ86md6xWNUsQNj9EPtRzsnE9JlwIO0NWVoOfi8gjp1D4OyIWrN3ghYpMnFpXiholnOyZsqTIV07PluPmZXY4dwwY/c4wPgY7bfZDXi3t951gj+vnJg+5hfJhg47YTiIN2+4SIg9zK8e2RR6aNw9XQHti2kuLrHBAIw0hb+YS8KE8xwiEGEip4rCJbiRU6lm1SjuUSA9/DzNnHsFCOICwZMP9PRmhcDUJ0WiLkEmxC6JUubs6GxnYAs0t1B8pRi863P9LDdnCW8W3svUgwYcURzx0kPVqOVsDgaPIXQtmPWOnT1klFz+V24fVPpTJf1culTHwueDr0LLFilLngTPe7OkFTV0UfSi+nIrIn4lprbVzDDfMTNXyKflnyMJTXMEd6sGVE3mmyJcAZ6eV2M/wghpsWf0eR3KqBijSmvwngMQ3MGm25ccONMqTo2qmMgDVYLf+XuOVhWVxbh+TNjqwHkNe53BTkiwugN5n200oNWl33fs75YzeNPN2EgXjMmHred8hJIMSgcDzOG4LJu9LTxhfZKvDPljJjNOG9+kp1ObguBb/vtgHl1y9iFGio27p3JIoGDodSOX8Grnv401OEZvRDTe3xhtSnxtx6GqztKttHQc9le9p6AE9oL0W670fB55SjBjYo7vvY+lho6FIhXczgBO0+4kicN8RctK0VLZ3TLVSA13pGSETvqM6GYzPffPJEwIb7t0UFCyxSmC6Usay/6iuzv0AbSuao6oq9KxbsXXl8EPj12eYyyWV3+FUCLBxtulXelZ9PWAmTJslWFd/oZQ5Kp5pHUH7pem2nILVTawSHDi8WkJYd7XoGkOpgAQCXX5rM2oKChNwSfDffl1RuR76YTCmc+4EojobD+lMEg67rUA9lQHJdAbsLBgxRek0jZF6SlGAwpo7Z2Bp3TB
 fX74Icuw
 /HqIghvJ6yJMpJUvvhs54+hP3erJYMUN4cZmhrxEQLP0j7NWLkrgGUyG4RZF2jCiVLtQmoWHPITLrLR0VE1NkEjwuJVLJxc43/gYpirXKNcoSGv8gOLFdu6KZlVzyotzQ8+WGG+9ncEw4O/ysrQYlXyUvntw/4tyziT8pvhw7MPXpczW0q71wS7uNTxoxXhA7+b5Y+qiBInVpd5Vyx++IRpX6TEzf6X9j0kK6DOPtLYAjOPs=
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

