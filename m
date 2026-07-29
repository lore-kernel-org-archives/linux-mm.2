Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1433AC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:03:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A73A76B00C4; Wed, 29 Jul 2026 10:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AEAE6B00C5; Wed, 29 Jul 2026 10:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 801936B00C6; Wed, 29 Jul 2026 10:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9506B00C4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:03:10 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D050A160711
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:09 +0000 (UTC)
X-FDA: 85041980898.12.C9FDC6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CFBEF4000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yw+/E4gr";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785333787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	b=HPnwdXIfHuqQavGeq1AHhy6f8Vy6CQiQ/DqwHBEkl4TX9sF/Ngm9C87HgofGNtFiFILNjQ
	s9+MrJLiTLs1B/6j9/maToA9DDWZRFjP/gC6ehPN9YfPGJNgcQr7B+7XwG3ao37WPZQ2Px
	vIK/N0muihUsTlgPo1l5dfnAUyMFRrk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785333787;
	b=q4OInBjLCaJV1MqEsaap1/v2bE/krab6fsya9Y2N3ZAtrPADwN4T4ewkfOm0oYMWdzLlsu
	qkkGC9asSLDD+PZdGYtVuKN/8gV/alOZG/MLPh2HbTFD6NHGJdki0FCO/bmw5x6b0dHczP
	3ZWNm84MiUTRioK7lnXESrNRO/Ckqo8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Yw+/E4gr";
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 292DC44F18
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22741F00A3D;
	Wed, 29 Jul 2026 14:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785333787;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yw+/E4grNeCMXyJBO2KQzsD4f+VuF6eaeMYWnb7rmvO8pq4dW6QsusVWRKFPyQZGf
	 Zji+b2huez+ljWXt79eKvWasM8SkDim8lM2ejpcTv+HL1HBBDdgOnwIi7nFN3Lepn7
	 s6Aa8DQ9y8H5mAvxv8iK8zyHqJ//w63y3JuqZhST9cxSIAuAs3qfhgx4htht4r2IJG
	 HP2+uaiUPEz1cloqzLEjRaLrU28qlSTy3U4R/A6Lm8FV6l/J7ZPJcY1gaffJGf4oKo
	 VqM8oW05WJTqe/zc7kHIeV5sMkeq1BirACendrtV+zNebv5vvZH/XwDJSyh7XrMBHl
	 x5zpIZCmD3j3A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 10/12] selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
Date: Wed, 29 Jul 2026 07:02:50 -0700
Message-ID: <20260729140253.87753-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729140253.87753-1-sj@kernel.org>
References: <20260729140253.87753-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CFBEF4000B
X-Stat-Signature: 4yju8bkea6sf538pazkmxih9mxxsnq9o
X-Rspam-User: 
X-HE-Tag: 1785333787-445264
X-HE-Meta: U2FsdGVkX18n0ld/oSoh1X1+AAGvrt1TKbaadrIj1aQIS4xuTawdJlAhCEQhzeWvrZfUdk02vR47neOc9uI+fv8pJrBpfYxU7r3rUHOhDEZ6uyUZQDA4WXTBKXuEVjRWUjzu+m+JxOuw34iGq1oPHtSqtLWD23veoSsJUlm3U/8NRUk1nTVSDzYqov7bvmTYFzX5MiD/xUHnMgBmv3qM4lkNrnJxZNkmduZByrqEdbsXlg90Ir+VU6iIUmx49mPgI3dZGrgzy+yrCsQsfhOAVgowbrSCQqfUujWqbXHMwwOw75JyJnnraTZ2dRfxyU/6VtmNoAmdL7RBCd90sn2CGJcIYhA+dFLe4+ILcnaV+6Uam7/Yo55Fyxf+GQ490ZlwzZaVIEzi0qybUHPu3KTdcJoI5b4jMWNqgYDteSEDNaPq2SkVX6w19v5Ly4S+CKAOuEaLOU8pbFq8+VIQUBt+olRBLrNGOXfoxNQrkiW/aJYhFAs6Czx8qlEGd7lpLIHxpc/d36jGFp2ALWtI4kgIoIGGwWd8egDTQwBA03nu4cIZpAipaROk88QxnYLFzW9Y081s1k6YkSDl30EO6YmtqdT+zkzwCt9XJ5RTL53UVz42IKgZsjlDnTNWifW1vq8/q7j78v8b9O+iP97fmibqANB5iAtjoHirlHp/AMNmzPWAu6XIHxW5by0gBtDCSoVbWfqpaEv4L5rSikmJ36TeErEcPRomyBmYMlkR/cIbQTKllDynWbzgC13G5HM1F4BS5eJn0Z4Q19PJNLIFLe0Xb+zqdJdxLqQl3PgKB9Q9ZJiIht47l89uEuf9aw0JPGSvTodWwdAeb4EQbkjb0XJmljtiXJoqjqngP/9l9ehYkdsaqz4E/9tbPEYb9B3iG4J0ZJCyT33clQr1BA72gFgCkiliweU5jYL6ba4m0aToRwPEcfDrsaXW096ngZWCfasjuQgYWmO+VB74H+/FHAW
 RjTHcEu4
 x8I0+X7siHqC47a8qU2Bm2BBbuN3iDwyaBFaBxN0B5LpT1mLdaU4jZVAaRsCnTyvwJNRf+he3684sGXLv1orbYwl+pG/JbNH2W5lvVCFgShDeATts6uTm/S1mg83k1/AbmU+1RWYZmn0C8dRoN7xYv44GAFpDmOMZUvTfKb+6XgE3hO6YWOnAK5zT3tnmQRE0HjGH4W0NWjuwEQeY8Wblg6r1Nmj4aljeed2ZkaPECppQ6kDqKW3r362STZHSBKpp5wfj54gK+HOGQflRhzSEWU2zakCfJEM6Mkv9w6pb66A9JV5OyOSJB3YizKFZj91MFaLAW3coCs+oVjQ+1Gk0wPewo7pXngtE0Luc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs quota goal target_metric file now accepts 'hugepage_mem_bp'
input.  Test it is accepted in fundamental DAMON sysfs file operation
selftest.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index ddebde6edabe4..b66593c9ac471 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -210,6 +210,7 @@ test_goal()
 	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
 	ensure_write_fail "$fpath" "foo" "invalid input"
 	ensure_file "$goal_dir/nid" "exist" "600"
 	ensure_file "$goal_dir/path" "exist" "600"
-- 
2.47.3

