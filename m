Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 457B6C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 04:13:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27B96B00A4; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF6D6B00A5; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15736B00A6; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 621126B00A4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 00:12:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE6E7140202
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:58 +0000 (UTC)
X-FDA: 85036864836.24.8F47221
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3AA80C0004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0Yk+E8c;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785211977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	b=KEBwBqsVX014KJB3y4FHjezWxk4fFJtcOwJZA0FwLcAxMGNjs1/TaZroSKaBWQUV1m3QPl
	POPUigxarZX3BXVBMGktFl4hXXT6m6atzNLu9nWywUCAKT/riAxlE1wkGTBsjHJRHS2nxj
	qmavCwxKEqV3AN1qav8CM2uLiMlQUWk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785211977;
	b=YKbs71Dfnhjeac2skKhLlbgVULb+70cJwq5t9YZU+F0Omu/U2z7Kxl4IIjYNXFrJb7BOsj
	ibWlcqotwn76vOivB3kRX6RFwREvPFd7tL3bhENbm6IaHDzBe7vNdNUobkCnV5iYv11KuS
	kfaRYhPnu/nhz98AoEEelGqPH0wI8ow=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o0Yk+E8c;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F19443214
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 04:12:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAD31F01558;
	Tue, 28 Jul 2026 04:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785211976;
	bh=m+OX/QoubOtPs5CYX5dE9pYfjfAmb4FTinvx7UvjP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o0Yk+E8cMC8Pge85QoIORj3dRWhVCFkvO4BmM61deMcSxvvkrTH2XOqCaeskS5VPL
	 VaYCZMOsciebOOHkqJ1s3k8C1AxIExYCFBcZwBMZ4pQO8fCEI3W4cZ6lXnt58Q4qEy
	 MPE7DcS8TF2LC05pO+fm2jXT3hjw8zwzNdsDST7yYTiPgthNqNe7p8wD3I/ROAucpf
	 bxUNC0/uEEkEF77hjhN51POIvqV/Xnu/CbK++6yADl5jJ+95XJQ2MiAH0ZlXgPsYJN
	 fQkx6hLrjldrJEdH5n8X5jvRm8oYW4S8mOe40wx5v/J3aDn6X4aSouHk7wBNiAy+Q7
	 RxLATF8zAghTw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.2 14/17] selftests/damon/sysfs.sh: test probe prep sysfs files
Date: Mon, 27 Jul 2026 21:12:35 -0700
Message-ID: <20260728041242.187380-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728041242.187380-1-sj@kernel.org>
References: <20260728041242.187380-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s53nme4hasmix1ufbirg83jfptbpbohr
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3AA80C0004
X-HE-Tag: 1785211977-471000
X-HE-Meta: U2FsdGVkX18Qtw0jgwSNWtMDtLmkgLHLuacyYFl8MBX5UQyg11rUCa9Afi2NNOlN/OIFt4+pqb68Ms7b+c2dG9SbP/0+fIA8KO99Xzrzy7U9Dzi2t5kIy71eUehFM9FLepPncl9v1tHLLRonDsnsRP1dzWrchqeIWHs1qGbinYQ4t0w9bqEiUag6S8Va02fIqQ24M1WhmbMjWtm7i50WCeaHbKE2Uozd0WUrZsVd5oeJI9EABemph2yX2m0kZ5I9ot/8e/elcDNePcuXq2eWES9FDQaEqSTWJcC1k0eMngf7p9DtEaRQSoHNO/FllmPQDj5BzFtx/4DBFxIDen4ix5WvJmNr6O9j2kiPZfjEtFW5Qt+Dhhv0G3uWh/B9iwX86nZC7zTjOyaGSxGCfvF4RIQNUmbmU3HaOl37q/OmD6lOtwvSJW2rrgqmIu7ESB1+Eg088Efbly4bp4izBhaWb30rjKN2U+K06unLr+rkSg7B3bQnytq1YXgmwFdGrpMr9VEvE2UvnKpI8io6Z05rl9KO2ZqyhAovuu5b9uIl4gb4yhWMxexzAk9BVe7noJUHSXZ+EH9qKBM/aB4uAwIHZnT7/IbPAjGA1ILh4/L1+BtykD9jLxklNQ4bHgzGLwMbQYjYMez3iBebEW+JPfPn32aPtzaWEd5dKt4Xbc3RHTe54EYOL3A+BUCvh+XjJcfLQmVKsKyYr6pLvLykW0cHChl9ssb0AYMfI+Ah2qEhPF945WEFOn+Hm9LPs7Wh97rny1SU1ibQRg4UI+KOs2dgYHLSPB8fFs5BdA1XjGMPSNFuGomOPurs7gLk602/zBFTMIU6cDHUfszbh4M86IeViwvKIrTxIIeQegwR5+AL8rwF5+zF2EE7Kz0LRv/T8HitsDYLCcEhGW0hSeF3dhzonzQVu9sFlE5NvtSuTwiYHlArRwj+4EVOoQGcQ9nmPDbsTwMa/T8IUOeeuPWkofB
 xlYeYfg4
 ju/J3b2PTYD5tPVZ46CT1Jc4qKpYZGbVA8wxIxSwPXawrQjnXWUmz2FzB052pQ9hMWt+/EKqWzP+e7jX8IqUMiu5M0d2SM+82HcPqmnY6Mbge06VAklMttaj0oj4cnnKql8qhG0xvEvE5ilAI5rVITONAkyuPYQ6Dhqzw8HgB22czdZSadlUkgzY6bUvaLX6UWectHbeJPMaS/vgZZvp9H/CT8hS/dXGFvVhMiHt0fBaFW8HiTuAGWLkpL5m9wjYf2EPja2/JQ8y1RzN8qc7y8KmYlWoXOG9NuBVPJ/jU6Z7JzeNU5GH/9ZD/lbyxtOPJvVk7LIUpoRVt9K4uW01MIxaPKCUudEk/mw0tjFM3KfaMECw2DI0H3A+iRJYiVSwNk7ji
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

