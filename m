Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E5B0C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5F836B00D9; Tue, 30 Jun 2026 10:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE8496B00DC; Tue, 30 Jun 2026 10:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89C16B00DB; Tue, 30 Jun 2026 10:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77E9F6B00D9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:46 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA53B1404E4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:45 +0000 (UTC)
X-FDA: 84936782490.26.3102DA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3B52D4000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:44 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nyl6xEDQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829064;
	b=IUbHprhLGT0bd6mE0NHphGZoyYf5S+Bp6dqRgKjgCSBFHshnTho8q5kwNqmp8hsO1uXmOl
	6m0nDZGBR8M7rZ8Rlw0j5HlT0yHs02Tbiog4uvTDEpyC1LiVqJ/6h4Ck/m5P/2FfHvF81H
	TBdRC5yp7YV+uxmxPiZ+He6z3yofLDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nmlNQ5aYOF5tQr1EQbZrbSTFwUpJ5xLRATEsQ8uEpw=;
	b=kWZiXpi6UzEEY/ln3K3qFf+95AKBDJzWK2aoAoGVZTx7phIhfuf1mHEJNNLIWm9iNVU2E8
	pI+BMmk7E/R0gZDtOogi5PbakXTV07PN5Iwxv53hio4lZakppDS47Dwc4Dku+bYxOXgkcE
	RNm8pm5nuv25GIc1FpSRREIr/i3VDU0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nyl6xEDQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3F59601FD;
	Tue, 30 Jun 2026 14:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AF51F00A3A;
	Tue, 30 Jun 2026 14:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829063;
	bh=0nmlNQ5aYOF5tQr1EQbZrbSTFwUpJ5xLRATEsQ8uEpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nyl6xEDQo8YATDg6v02JGOcISed2NZCmwgojeIx6cpWSVk+dnPNDrPSUXXRyHeAX5
	 +ARuhdKwEoAi9pfgVkZKTmEsbwXitOAESA314jU34PuSumpgPlaS3qxXsv6LgqOODH
	 55IUtOqf6UVqu85nwRKEpRS9WYLLqFG1ipDLYOo+bbhab6ZVcC+SkpyFURcOuvO+Qg
	 E73JR1DH4hOeQ+/Gnpyv20cvyKA+W6QO/V1CT+lTInEWH8/zo8UjCo0bk62yriDXY5
	 GLlPYOMa9L/Aw9Rg2yAAaKDGG2SZtF/lIbSmZonjHZgVZMKWBmBXV2F9/Oo4324lmP
	 OaOBZ0hkXDHrg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/11] selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
Date: Tue, 30 Jun 2026 07:17:19 -0700
Message-ID: <20260630141726.92246-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B52D4000D
X-Rspam-User: 
X-Stat-Signature: a4rctdorjbpzm6upgixkfksb37rgy519
X-HE-Tag: 1782829064-285524
X-HE-Meta: U2FsdGVkX19vm9hQcmRxXcVhcD/O8Wg07k7M1bKYt3FZnc6fwiAYkPZp2e4GWvIusv3u0qc6QV0aKyEJ3tKx0CbhWukyWQ4f59mlMTyupvMkl5ETHd1NZQIAh47IBFCWoiIp2yD7jxC/LetuenbtUgNAvn3J98wBa9wX+IThikdsKqO/wU4IjiAPwMQ3zT6CSZxDYhKFgWzwGnu2WS9cphuICt2Zh0wLI5mu90e47ER/4zeBl2qLD43YDKjQT+N/RSTkx+IrrJWtLb6xaQZBQEHdc8QB8ZmNQZwsaN9spggFuEC2gR26FD+U1XpD9Gb16tt9xhnHTTrK4cqEbb23/0eNOg++urCaZG5G0jdRT1lSy3WPRinBtWlpjUxmr8qkTx8WL94eMalFHVwWZGUqklesVxChVNuW969gtOWGz2yHrKtWxrydYc9BYkWBVHuZnz8/SjbP5wktpK14Uy3ipmqg443oenMeZV6uHy1Ky+uvl/anb/oioBdmNT3EJD8rQgwFkOn20U6PGibKJxjOsbkAi4v4FHiSzyh7HdX5g4b7/Xz5F0iXa7KcMSVX96sgMss7lKgKO5WjQxihEeLTNYyhwuAr+2qNL/msjZZeIoy8wOCimKucAH0D0y7Rl7vhwMJuitjpfDOmiC7wHgEV3ZH5SSCqpq4BBmMtkoVIIacza3w9Avm2OWiUcoaPsHiZ5YjEUs85XjAVR5hV4nbW+3p+S5lSNO+JRk73XurY8GB7pIyrRnXJdAw+Ga3b8BqMv4fd89z0iI/fqfoQ4PAI1GgXJfbTT6yvo6gNeYZqG+LaLkbHT4uxfLD5d+wnPjKKBF699n/FVO36J2rG+d+DqLQkfe4/AuSrtOScvYjG5qA7cEaV4NNKv+e7FYgO5qwL9WIUQmltMqwWkAS5BCG+VF/K0N41X9c3rxEhxQtxpuZR1f5A4EuC5D3zgtw3Qdaann82kXYjyDFfsIXG4Dj
 ZTJ03KoS
 7GSGUOo+H9DpW3ZQaNnB4ufT9kafZcG2hLJBdvyqWNMnY8cFxlkWDq25dAtkAsgxOkfPuavtrx9Zzs3eUIFN5E9Q5aiQfkPZ6v+YIhqfrYDcNnlDqmBcfIGsN0W7WzNCY5s70Qx9qkNULh7YcgLF+YprdFRjekDEtXkU6lZD6nog9zZijGRRPklYR0aqO7Oz5okTZ9N871dhFrmu14oiKbp237+OCI6r7sQOwwtQq0AxIYC4+cyVgRYwDsXCmws+xJn1Ar4fkcqjbJK4BbNBxMMxL6w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface essential file operations test (sysf.sh) is not
testing DAMOS {core,ops}_filters directories.  Add the tests.

Signed-off-by: SJ Park <sj@kernel.org>
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

