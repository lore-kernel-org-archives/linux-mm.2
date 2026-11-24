Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930F6606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TXU3lRrz
Received: by kanga.kvack.org (Postfix)
	id 730FD6B0783; Tue, 24 Nov 2026 10:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E1D36B0785; Tue, 24 Nov 2026 10:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8B46B0786; Tue, 24 Nov 2026 10:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5B76B0783
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:37:07 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D77E120BC7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:06 +0000 (UTC)
X-FDA: 85470416052.03.683BED7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7ABF518000D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXU3lRrz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795534624;
	b=7F6L50b4kpDeRCxdQCWlvrffavv3Nj4tBgFywcXxxWfGHQEwaWuKV4PNYMbNZ0Puyg8Zxe
	x/2d/IcT+1qxboKX1Y0yV8vLZ7mmMaF2xwKg4Nzr6vOXKwPKt4ucxXQn9k+ONInnU7+Ahd
	+xuA1yg2Z70eEcKqg9f7pRP1tDeU5Ew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795534624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VFtYD/uH6yXovXFjGtew5hKjn5SsMtqJwYXOh4QWcz4=;
	b=65LR0i4plJO4jJ5ERCmNe0OPboAkt0beNxGMmOUGqwsiYTrtylb1zYS/IGSfECCluMWNDF
	E3VyUyMlJKzt7NkoBclGwbBqIDbHELTyz7UXDg/Ui+b04lVYn62xfEmyC32Vb6Y3nQ05Wp
	Ngdn49ZvUovvU1hOnU7cVd//CFr2ZJY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TXU3lRrz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CEC161D1C;
	Tue, 24 Nov 2026 15:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBF01F000CA;
	Tue, 24 Nov 2026 15:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795534623;
	bh=VFtYD/uH6yXovXFjGtew5hKjn5SsMtqJwYXOh4QWcz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXU3lRrzDxiSDS9sWMGfkCgkHJxJL2czX+jTtzCzUU9gtPOLkTF2ZjXsT8YvE4OU6
	 bXgW+pHfPasEqWDfPRlFy0oKiP8h9dlE/Nvv9nilRA/vAthUsHvMZ2T8cpXHB5pwda
	 rDf1YI+4X595k2yLzeTPY9QARkPhPyFNZt7wsmQ56uBVeyNAnEp4isCnGETkOh7cUk
	 s+VbTPa+YAjelZ3+TTde+kGlHTXnI4zoM3xsTjBIwMuGeFq4/X8yNKgLBBENigd2V+
	 Z5cHzcyeNbWp6DqgA0kaOipr3vVaIqCp6vz/cuFUKiNu8FdwXGaVGdRWKAeaHsU0ow
	 3561PY9LvASMA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Aveline Noir <jm5905938@gmail.com>,
	Lian Wang <lianux.mm@gmail.com>
Subject: [PATCH v2 24/27] selftests/damon/sysfs.sh: add basic tests for admin/reports/
Date: Tue, 24 Nov 2026 07:36:30 -0800
Message-ID: <20261124153636.91854-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261124153636.91854-1-sj@kernel.org>
References: <20261124153636.91854-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7ABF518000D
X-Stat-Signature: 557d1e4bhdx5aikqjt1utwo5kocix3ni
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795534624-385220
X-HE-Meta: U2FsdGVkX18dvgb0m//pEZ+M+fU9MZL7QS5ylKquZasbcfxNiFvNBA355UZ6v5GRD3AIpg68WVDRDE76SM23yUJ8W4doBiDt2t/iy/uBa85H/TWsNtwDOU2ht9fojNU5s60U2D8XVOlKqge7zdw+tPU561WVFtiNPcxhJ4dtW3W9kJbARrAdghpYGx8mh6sNCoYzqolrYGhueQv/5MbkZZTsKwO3GsNi7cFixFGQoW/wEgiL1FNhDa6D0A5ppayVDfKDcKzDPk9LZMpby9BDwyoNUzuzQ5zJNpx+RDMMZ+NA2oFl0PU2yeRSQVCpy5KkvGXDIYp9OGNgNi4vE7WyjBPI9mudlATksGNz7z+I9X/eSAS0Y6tZNR14UP+lnRUdWDTIMorQXyTvKvVNk+AZmVLJVIi6ICy217Lq0/Xjg5x9tM/2y/b+Ix4K4DAMMzjNSOmzGGouTbkTqzMrgUwxze4MfFL3R1o5bX9YuRAA89c8F3lDMgrFBDgR7SEnqwhiq9wMNJMw2zp/IJP3jYOmTOT4YJUZZHS62FSa37YnJPc/b7uEoEExCzvwpr8m+sdXW1UQMKroxnBOv9QqVDhK5Cm0hdIv9sqe84bHDQj9Usw3DznxegzFH5IhtcfvcxBADMHJ4al8ZoSyoFG/6YBUbeevIf9XvPTpzpWi5x6x2FjIfWn9UcSxaDPtNHTNZItvhK15bPR7OJFVSlv0KnAYRxu+hz7XFUVWV4hsn+wKQvyiHltb8ssgJs6bAt8+nihziJkntasnVU4Hw0Rx2+2xsNxKvMA9+Y+xZPCW2rlV4ouRrYhWoc119/AbbrqRFn9WsQ/DDkrxy1LyCYjOJHetgjJgAFrBy5pVe3h79mjDtJ0HQzLaY6tSK/QHQuHg/UkYODZeMlNRkUl/CX57yXjJ4dkIZ/glUKa7vYd4bLApM5vhK+GNXo6j2v+9pJHEv5/mlI2WbyCVPtfhgUkWLYm
 tuqFGfT8
 qwMhLOra4g9SkAVC6Zndl5PpEkS/aza6MU2VdnFR7PFQB8T2dIIn7ShBNPqw5xl3BbxHjBIaTekNt8wew37DhCaTOO4/SBrY7/8VpyI8+AjkUFSJU27ZS2ljaSsv1WQMg7AtPNiwaFN0NpRcpw2KYbKnVWu8Qj/Rh72/CP8JYueAFYK1liOf3S9wS5Uc2BTpXGMx8vUQ26mU4KH+nHtBZy8ez2FXf5p9NXrWNxvmVFPX5JjvnjwqAUHhRSVSUiCCqaAnfm4Cz/tem8f3peLHFB4aHlt1m0yhPPfxLsH7XtOimoiQ8JU5bCn1b0l2oyPDhkhfUGOucyx+eEMIv2L0lVcI30SOXLnXGNjComaj2tMmBo65cCbYJblQ/ShWJZx6o7uzzFQfKmsLdbuQ3YNGvI5faT58b0pATlRR0xaoJUXyUc6v1CFyh4sRrCQN4KK5/jt8c0e0k+mc+cUdoZrCWHPd9l2eTAPwPcZwEhrAlaaVlvgj9WzuK1yQM278+fsqWipnurzp7oBmtTi3Vy/0qoiXJN8ZEmLWbLSj4Ub3OtMrHSHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update sysfs.sh DAMON selftest to cover basic file operations for the
sysfs files under the admin/reports/ directory.

Reviewed-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 52 ++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1cc7ab2d7e22f..577953ee4e631 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -510,6 +510,57 @@ test_kdamonds()
 	ensure_dir "$kdamonds_dir/1" "not_exist"
 }
 
+test_producer()
+{
+	producer_dir=$1
+	ensure_file "$producer_dir/report_type" "exist" "600"
+	ensure_write_succ "$producer_dir/report_type" "user_report" \
+		"valid input"
+	ensure_write_fail "$producer_dir/report_type" "foo" "invlid input"
+
+	ensure_file "$producer_dir/producer_state" "exist" "600"
+	ensure_write_succ "$producer_dir/producer_state" "on" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "submit" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "off" "valid input"
+	ensure_write_fail "$producer_dir/producer_state" "foo" "invalid input"
+
+	ensure_file "$producer_dir/addr_start" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_start" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_start" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_start" "1.23" "uinvalid input"
+
+	ensure_file "$producer_dir/addr_end" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_end" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_end" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_end" "1.23" "uinvalid input"
+}
+
+test_producers()
+{
+	producers_dir=$1
+	ensure_dir "$producers_dir" "exist"
+
+	ensure_file "$producers_dir/nr_producers" "exist" "600"
+
+	ensure_write_succ "$producers_dir/nr_producers" "1" "valid input"
+	test_producer "$producers_dir/0"
+
+	ensure_write_succ "$producers_dir/nr_producers" "2" "valid input"
+	test_producer "$producers_dir/0"
+	test_producer "$producers_dir/1"
+
+	ensure_write_succ "$producers_dir/nr_producers" "0" "valid input"
+	ensure_dir "$producers_dir/0" "not_exist"
+	ensure_dir "$producers_dir/1" "not_exist"
+}
+
+test_reports()
+{
+	reports_dir=$1
+	ensure_dir "$reports_dir" "exist"
+	test_producers "$reports_dir/producers"
+}
+
 test_damon_sysfs()
 {
 	damon_sysfs=$1
@@ -520,6 +571,7 @@ test_damon_sysfs()
 	fi
 
 	test_kdamonds "$damon_sysfs/kdamonds"
+	test_reports "$damon_sysfs/reports"
 }
 
 check_dependencies
-- 
2.47.3

