Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C92ECDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26D066B0098; Thu, 25 Jun 2026 10:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246966B0099; Thu, 25 Jun 2026 10:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C866B009B; Thu, 25 Jun 2026 10:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E2E686B0098
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76A1C1C4545
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:48 +0000 (UTC)
X-FDA: 84918656256.22.2A91DC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D1AF0A0010
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LewuaLNQ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397486;
	b=MGYyvRW5mUvVf5D9HNv+ctRN1x9PXyAAC3gwNn+kgeqHpm13Qw577hpKa3kkZMIU6ZDz/z
	0SlqH528by5zZx+1NziMJTqptzD5si+NgmjjzDyxPhJMM/UWk3mcGVhdmn2WjHlp+TJoLL
	D/XPZKTlOa4pp1LiST4dvKSss10kJOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/lP4pJsEcdBFV2cPdsUW/Ogh7Izs8xLb+p1m+SLBac=;
	b=kvJN2F1beUDPfi9zkyzLWLPNeH8pLM5MtL9ZQlWgKmi//F5GVJcDEkiXKtEuGZH89JH1Oj
	hT9OnpDruKXuy6DBbXQopc6ysYyWLqJ+dlauoPPq9Pxq2Th/ZyiVWycmIM5TTS2cg3A3kB
	Vk/un/5biu9kheC7cVVBkSFOKea3btI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LewuaLNQ;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21F9444505
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FEC1F00A3A;
	Thu, 25 Jun 2026 14:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397486;
	bh=e/lP4pJsEcdBFV2cPdsUW/Ogh7Izs8xLb+p1m+SLBac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LewuaLNQdLx4mxnpb3wxbiB5Yg1cgL4tjz3cLi7e+5mxSWkR7o/PDknamL7xjM7te
	 cDFxX2C6YbvqvGYF+kQnut6+DV7FqY/bFA2+E/tGCopgJARkTiq53IvXECdx3mfeJm
	 d94lty4BQ/1p1092TM4bIeL7SNosaLIN3Q7BSg7thjb1+hbaTWyI3/MBjq4egmqBhH
	 gkzGFLeXmY+4cJpdYmbJQ1VPufkm/reDRmOUxqo0EfESb0GsdDrFldWBR/Xa9OY9Nb
	 yn/9ZNWVl7YyfrSmFWS5+QyXwy1J2E0FwL1MgJwVLkgbOLFtB2GG1i2QrQlsTdxt2p
	 rtX2FzTZc2WVQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 05/11] selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
Date: Thu, 25 Jun 2026 07:23:50 -0700
Message-ID: <20260625142357.103500-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1AF0A0010
X-Stat-Signature: 7jbu1ajc7sammdnqdpwjtxj34j5b87ro
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782397486-504056
X-HE-Meta: U2FsdGVkX18WBiq0cU3a8/cHKjWju9GzjpU1h7YNYztO3O1rh8rh5mC22wzC9zutx4Z6OTV8Z94fi/j1cLY//Bioj04hreRz7+JOQNj+5Jwdfbp5nnFWqiV7R+JTLXrKchBeyVvvyqZ83kEN699p7uR2fY404MO30bRloJfUcYTYep7wT7c8D9KXerfTbhtJNmEVQZDn0xSNVywtZgOI4a6LMSGtiA6kR+O3EMmy3heq4M+PWb+wjKLMAuET07Ifn/aRR4org/959aYMzTwX+ZUCXlO6YPkLOUdXfzsvrSJQCB6kAlp42ndCwcOW7lBG9NL4gR/cZK2VcXmVa0bj3K9Lc0BbbNrA7H+dejuOOBTOLD9sgPiqV5uptbu9b8r0p+6AlDXtay1ssQczFD4yQvuMcQAo5pYImX+/tXL0ici+gDmo1WIZXrCUQOq8IbYLqx9AnUsTMTPnFl3wg5AnBS5V1QYuf1/Vs4CHz8Ef0s6JEZUVPaMd+mk8+3l5IxRq6zZROiQlzXbY749Kan5KWZvr5zCAaNR6JCxNfEeUNsVYkVFDTEZJ+gRo9kHBdNSnEFRPnXXP0BhJ+y5wNLZ/Pcpkfct5AOOCUqKKbi9wtZnqK9Qm137lJVJX+QxMKBl6UEzvmAKBEnnrwUVgQYbuUV00xblXotpfMNWtVIDLVpQaPzHabqY0WJrOGq3ZnbI5ogNmR/sSnFSq1kz/vRZG84myhqel0d3t/CSpU/6WAhb4rkse3ILt4ZHS4eIEONDZ4U2RqVKHrxnETyxdqcRFT6a42i6sTHrUv9YaEdjYYj35vl3k6+XzhJSX/6IUqCyqZIjK9Blv6KafOIhQzHSbvoOn8bHC57fWilyVO1s2qkqLymrIdR0cni0X+sB2iXB8g3//8iUJMo1NL3hDth6h6xyszMjxJyMLP40cHjgT41WGPxZvKOaRnGx8BEDjZRQFIRs3xSIqioYmFK527I+
 KSYMKmIw
 7efwjM6267IkeM5Z6hnldNudq78yO4qeThtNX+NwQk2WEMheOcQ8oYgiK5yaYXCO5ULAAiL21fZNHUO9lX5NNYLGr9+Xi0UMmcX28HiSfpQOa2j0lB5DfiLkj3GK9jbDVCQbGygwA6up9Ljx6JQGOdJ8s33SpWRYO69+DFYun3QPhAcVzd9AhoBlyND3HtQnT5Mq5VdA2LJY7BJ99qb4XrZwL6CFBBL2qUAMz+q8buPtTxdSH05yjAwsF8qAaPZ8mnZ6cFptGlP+E3Kj+vv4IVap1AiugduVoixzs3AJDpraKRN3EOJ1uPy4+yOYWV8B3J6yUVkwlnhpSnUhanl8POg9jI2G9R/Xc0WqS
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

