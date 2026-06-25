Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8A74CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 520206B0099; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABFD6B009B; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3A46B009E; Thu, 25 Jun 2026 01:08:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 06F406B0099
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6D640C2291
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:21 +0000 (UTC)
X-FDA: 84917254002.26.6C968A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id EAA0E20009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmFjRnSe;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364099;
	b=Dq2qQWEKAif6du66dEfKcip/s1L65L6HjoKIFbxG3uTFOkimla2wIg/aBQDN6RIFsFdZd1
	RbFsoeIrLRrrJ/J8ejIRowBu/D6eOtrlHcWjcbXwgr58QVcZotfGBARKCFXLBvzYlyMn49
	2CLA9fuRj2T11UGMED91FSLf1gvEKFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e/lP4pJsEcdBFV2cPdsUW/Ogh7Izs8xLb+p1m+SLBac=;
	b=pLUaag96J7JeHP7Npxd7fuyhAt6lSigAFkfXPjY1DaSO/zkssf8kSOQ5/AL7MrJuHzaHoh
	/EE49fFblTriQkmj5gEq1g3+m9I8vxiDM33dI5BeWQsm1GKq4M4EiDpod3Sjdx7IWw6UQQ
	Ej9eJBK51sSOL8SbxRSo3A2yyy/U5xw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YmFjRnSe;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9471C600C3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BB01F000E9;
	Thu, 25 Jun 2026 05:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364099;
	bh=e/lP4pJsEcdBFV2cPdsUW/Ogh7Izs8xLb+p1m+SLBac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmFjRnSe+PXIIKUGaKMql6Wmtw+qOREVgGsXpixF6JzHStIbuxKFBphSso72ZDzFt
	 +Ou5J8Ia3M0puUsvMqpNk+iX5+rjwqfG1jvSbHs31/69I71gi3mUEXUiQmm+TgKiHK
	 3UZFoNGZmnT7THa+iV2oj/68fgv82FNthRHnuzm+W0RzLwQ1YzQTJaXoXi71XdJqg9
	 WvLaZoOJjKdMhk280D2G81NYlDD5Cv+9XkjtCwzW47ls2lyA4I08OAtdwVuA+HzzDH
	 kM1V7kPlcNTgZto0kPgJTHVopZ7YkY/LQoapipdWBYHs5wxPYouiQkZ0sRViS9jbFq
	 rcE2FVdCk8pmg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 05/11] selftests/damon/sysfs.sh: test {core,ops}_filters/ directories
Date: Wed, 24 Jun 2026 22:07:48 -0700
Message-ID: <20260625050756.91115-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: dcaxgysi1yweu7myhfufqrfw49tydgyx
X-Rspamd-Queue-Id: EAA0E20009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782364099-216275
X-HE-Meta: U2FsdGVkX19PANZpc3FsP5OvjNASQi0eNP6eMiAgzrSvJS3JbiknSn23E8Fy4VFjt80RZImrXFJm0LoR5/zGQQzPaXgc1Avwivtk11UxMZsijQrgLSxKVbSc4OcFROq+WClw86W1j+Pii+70d1X5gAGeHYXf8GtVhB5bqSbb1f91tuC44oNWdQ6J4rPzaeNZ2O61Suvgnxf+UJvmT5+wx3dTAWQz5iW5k23XAHlOWRlK+L6Grwy0gSTkDZ4xbRGGsZOfggJmqy8KvCoEYOUe8qMEGk0Toc3yOHnOnwOu7DyHAivCCUW4hti3s2Vhx7GCd/an/xqTbqMVMoZHpsi0PoxgLXA5F6p417f8GYVlznRHFoN9mYmv2FJn4Ne0eY9Bv/bPU0sgezLzeDIAvSBvuRYzFoADwmdYD0bcXunTmQUsbMgy6UvjkqI434TbWBCEvmx7NVKI+r/aae09DN1/r78cOfTRMln6TW2eBkfV3C3UBGMA42xJco2zCAXJJqwek/IPkMlxt0dkLMaZn7QzfSBrtiu+PG+sTswOZDr97e86aP+34W1JOo09QeB4nZT44EuD9zQd38SPnBno//2Tq3ZJx3RH2tdqHlD3Y9cfIy5GUtsYLAi53T3kuLKko0x2MZmMhJTbtLrIoCbnXRa5BZ8jQbL4FchezXnN9QX2s+jBejGWmrF0JihTdl8HJwKHcvJKjkWm/gkqhmVUMpksdZxciSqFlQ/rn9XBnreRjMNQWsJ7RQuOjZUg1vzgnEaVFJmELazNSkWw+lRknnZI2Q/V7oZjQTFFiunoainmUszGa3IJI6W2vQn7x7hB2QZAsMsOijJoNVsNkeT8R72QnC5cLR15iEMKJwPQPfUWiCzan6IB0p3VZKn5MJRmIGn5VBXpolBUxREYj7rQ8KPF8ipPLI4KnyEwtBs4EFid6E87QGj2H82vQ2g3mcj8SS6BUaf0GSJlq/FIWCRGCfX
 IOop7/oa
 QFFFw+HYkt/BR56OJ9G9/SP7aFVBI02EZnIG975CsBhKclIDbrBGCmjKae9tMke1i6lMHiu9xs8Mb0aKwpvkEa2ssFKjr+LN/CvGJeAnUONuZWr1E1IBxs0LsX6Ip4bcY5V8GChO1rHZQoDde+vxE/l7NgUzrMREXC4jdoxaA4mmM69zfhjg4nUv8sVJ404E+1uiSTzaPR1MVRAHq/HuX/R/ZybfITTPBV1z3UuZE+H6Ce5JYAZF6/AOEvsNHCcoQ1ElnrTDPk5q0CCGnPA2CQDJGazcgtQM2aTfaigBTvMSAl7pPF4wEZb/YiyB+x9c+ARxpyRz35ZEj8zrYkCF5XVn9c6wvrywW6U3C
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

