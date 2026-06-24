Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4146CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE186B009F; Wed, 24 Jun 2026 10:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF026B00A0; Wed, 24 Jun 2026 10:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C54B6B00A1; Wed, 24 Jun 2026 10:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5296B009F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:20:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B88F40354
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:31 +0000 (UTC)
X-FDA: 84915016662.04.9D5EE29
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EB5B980008
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWwXA4zL;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782310829;
	b=LmxaNM6IEZyVv3OKL74LHsD5VsZgz/JctA2c94/mIJmBS2azgSWomp1mmi/RMNHIcJmJXo
	1mKA9nimWkcprfo2LU/GaJgLATITGf1bTHicFqE7xEJ8q/fS05+jlbn5Z54BKBfXd5s/o8
	7r8RuG8EzymvURxzwS5+24dmtYSagY4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782310829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qjAnF1KQcOIfPmAqh531HVJRlkTMMbScffo5lddr31c=;
	b=BDnZGzOBZYPaz0Upe6P4lxjuaKlUfqQGxpAEETNP4G5FzeiqCr4rvfPqYOqZTtJ/kyG6va
	H+MomqZ4wAaEJFbhngzA1wTSNDi496kugSouymehHW6VOWLH/KwJJ2D8FmNQEqvw8Wmx0z
	sk27cMxYhjY//3uxgeD2dENkRSq7JrE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZWwXA4zL;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 83CEE60218
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A32881F00A3D;
	Wed, 24 Jun 2026 14:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782310829;
	bh=qjAnF1KQcOIfPmAqh531HVJRlkTMMbScffo5lddr31c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZWwXA4zLFzKojAlnqJafqe+F/TszR0YMwBv9FiNi6fXiwtLizgrg60MB86NfYFO2Q
	 aO1b6Qe6MWRiX5nWkN7t+I6h7ycWDNbNLI+WoLCQdEb8uYiyjMEmKGfuuvxW16Ullw
	 hn0gsICdv8d8j6toAVRNVtgP3nVeWmkHCsLcNBhLKDylVET8kdrwsycoPtJbZKz011
	 /54gR/SdBC39qjE5Zr4gO8RqxT+hcudnaVYt95LaxTXs+oeUGRxbidMPE4KjCx3FAv
	 i7D9WX9H/7KEDAIrNRUx+MzS3X4zVUcZpu8YLVRtLN7apI81s/QjCqyf+yGU/DMJvk
	 Ua9VC95Yho2zg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/11] selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
Date: Wed, 24 Jun 2026 07:20:01 -0700
Message-ID: <20260624142008.87180-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260624142008.87180-1-sj@kernel.org>
References: <20260624142008.87180-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB5B980008
X-Stat-Signature: ixz16te4jtz9kogqbb3j7wo7ne8g8xz9
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782310829-320415
X-HE-Meta: U2FsdGVkX1+LebIrYdZO47z3IoB5skvX8e7+WD5TaiOWj4YvrHTNI+IXBpHQKmnXX2AHYaDvuE4cLOHbXNWIWAS/LflfITHDlLTrBYgaVnZpPGyvQw8WU1ev4MPPPc5rB5pqtRW3EYRpohdwA9xtkgzcEdI8FydwrXVZ0Zuknmu9cOd8hIXRG/RR1RoDZUN+hQz0iLlUjZx+I/YW+RmauvwF8d+btma7aMY1B9PDCuRjtYyQACtLYs3NHTd/nTLdPm+iRGdvDbyLEnifUHTR+tCnNRZn1xwuVVofdFR0cqu5s1CJb5Zq8okY7znyTv5l6aZI9B6WzfGAVTRxfyFwvJFAzWmFQLT/buMj5PyMkF9otFmQCZN8T6Q3b8gPxLZQf4quEtTpZbuZNsOgrc1TOoeAp0KTZgmy2Kc5c6oGBVgSbN+o5/KDm1L39CXbGR2eH62ypnmi3qbVhobsVmVyO+6NUY3+2ZuL7HhB6/BpN+/buhS022XSJFwv4QhVfnkfKixykVuIcugzc8sQq2rEyD8t+fnnRgGKY/zpnxnhLhWFpreHsvwliHt8Nllf1qYIM9O4QNslDaDBH5IKGXgkdKbflij1HmctXq4Q6oXRCedY5zgiuTsj+z4ejYxYWNx50TnT26oMcD464DrfpCrHzFwvJ+vW1oaxhoJmtdiQGG7jC8lgImiyH2u4CS1SaQ/PMWHc24N9N8YXtBXadwF2ktBbxjgEaFEVce0m+Rm3QM0luKQCDhZi+GUL0NgIWhI6R+RhWRJmEm5/xnakBag7FsFUOvsPTPc1Iu9RGrnDr7DfkLGG8iESbLnwIADppAMd0arqfZHEPzhaIz7wQDP0Zz3UmpM0BB/q7OkgqkxjOS+DUfL9PfRyaqsNJ3BaCJxOnFXgMsXdvpO4CkSMf/LZF25k6O5G3T+r7vZGvxh8+0MBGW1qY84x/j2/zVg2zTiOuPBtYdTPT2COSP18H57
 HuCzoMbI
 xz9RAm9gi0HIubu4ZYxTpVtd3YYdxwdQUUCA5OZJvPKz8L5Hvbp1ZmtULXhyXkjjEafvOxGpMJUIk9P3XpyooMdnMeO9sgaiJdUI/z5H9lpb+r1a/8b5jVNZ9tnEnnT0lu+6aoySUZCjW638mVUEo9UF2OfNMwB3JnUjTivfbU/7D4o8WgthR03xV1cvQfGveRnRV85Qq1YlpDbdAP0J2z44GZsLRHhy8VZjqWnFZqovG2LXj4u+AyrGKy/XW4gJj8ArZFxX3hb+PMkny5PfIX5KheN3xysFL+JGl/neHEEPzVXtat+V/1wwgYvLzXJ0vu6Oj/qZNkpoSCa/zOuG+r/D/6peVzz/VjcaC
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
index d528dfea44c3b..78eea0d13c271 100755
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

