Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46408CD4851
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0676B00A7; Sat, 16 May 2026 14:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210506B00A8; Sat, 16 May 2026 14:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8B66B00A9; Sat, 16 May 2026 14:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB9C66B00A7
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD9088CD9D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:33 +0000 (UTC)
X-FDA: 84774141186.24.39C644D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2779C4000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V35TTJje;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfeX6x/Ktb3KmB6TDO4M5QdJKq9cy8SwqCGik7CGYn0=;
	b=4jKYxUgkaWrKYYf60Zi1UZBfRjlCTPvz7x5JhlIlz+j2IXMBqDg2sw3azV0QDrwdPMS7CX
	4VerXv01o0j74gvqqyoFZK1jmUZDFpfNmAbw5Xg68frZhKfOggkzGRi8SJ+rwldkkeWfdq
	sMiP1ypHIeA3VxIgI3E+BUE0ie979Ts=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V35TTJje;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956652; a=rsa-sha256;
	cv=none;
	b=uIVOs3Pv2LunA+Bxq0R8ue9+y2i4vgkRt/1gevqfIs/WDVzUaV+jBJp6kslGIF0zvZQpUf
	aK7ZWflB27m2LRJ78BLa7xLkFOD7DSJTfpZlCiOf1IzQKbwTh+FSCp3tpCecVkT7qX0j7t
	gYmUJkcrxKQxvgyR9srSFd+2RuSjem4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A6B336020B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29AFFC2BCF5;
	Sat, 16 May 2026 18:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956651;
	bh=EauBIBzKjl6rFCRlEGSo/s6NrgLL9HoVh8TIqUsq9vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V35TTJjeKEuxB/5xFHbsDemOsd5TqDRUYuMpUiMrVGFTQfEVJdTmeDWfxHNsb/oFD
	 CMkiI1ssvT9v4RJ/d1yHCJMLq3cvuUlsb5Taohr+2N87YKF3yB962mDEL1CgkAnLGN
	 JEFYR/lDbmT90Ew9vZAsYoGYdaCohdB/QGDT/5n8WQYkQPsHJSP6z0cZcs8x2II25U
	 XAKhpB0BTCIAXYlks5s/d5ySuV/hi0+Z+R6nZe5VIWpudeiCu2Gs4xPbSAmGEk+pX0
	 a352cNlapycp4SDOfTVfUkdAco90/YUNuaBJ5on1XewmOJidH6iALziBIt2qSoWoZv
	 j061YnOE5WQxw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 19/28] selftests/damon/sysfs.sh: test probes dir
Date: Sat, 16 May 2026 11:37:00 -0700
Message-ID: <20260516183712.81393-20-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2779C4000B
X-Stat-Signature: tur5d57rmkemjo9wcwn4afxnwygxk7c1
X-HE-Tag: 1778956651-811535
X-HE-Meta: U2FsdGVkX19ANAoJQSKxrjmTePtqUAH7p2n73rfEfgfDss8TMYx2+rWPRKEjkWEelkJ1R5KOhncWQGEEtrA+8TEu9ki00bom/+ukFCWEoqhvrIJMLZv8g/iGliT0txf4m0pIx3wo1TKihSayTAnfG7QNzon0ZCVn/XqmJiAe4uMJ5i6X38O1aDUfIyPXq20w9xURuMPSQNLHPF/Q4oXuGWf0W+kj196lwQ4YtyUMqbdvRwyaUDdBr2k61uIHNe1MSLF8f/w7dkv2XVeH03Mt8Zv2TsZ5ZBdpky2YgJsao4SUiyl5gxSCqg01d1573sLd9AaxHkIKJYMLLTSvH5LiEojBgGd3bRMfZ16W7dFRlbEWFoMuhCW9Rna/YHJgxACHzubO1eYUwOANtYLXl5hqlMlHm225dXdlE5iMRu/6Tu6MVh6QTP5sAN7etVoMhqUFAQ3A4AYlNm9MLSm0vaG7idf/5J8I9zcQXSbgHyKJYBkfL1sw4BokBG1F+X4Arz/b3CdFQeZR4xFXxJxiXI3hUEYUEGQ3bkhgt62NH7cyp/xuoihS78Pado9gVMutKxlmyDvEyZbB6tNJqxHrZwN6S7fJbcN72PFPJa0LBmHhPuGkpFX5xuPHyDRT6s3eFz+BnDPoAU2Ofnqfz+BA6u4QVe1nqaeglhYPru8HU/PNie2M1zQWN8k6v7rVhbWVlWKyHHu3HxiFOzC1NyE5aziHQgkam8TvW8dFp/Db0uO31jlIkOanGExur3ZkC7jBjFDACXVZLV/l+f7HDc37INzCUJsIeKTbIwvxSb/zWva1uleSz+b98vNgioAHHP41L83tUHmM+sJAT3OdhBkrfl3AZsC8u6A6oHfhleWx4aiJdaqGrOnvtXlOTFBhXf9IpolAgTXlPbqjmrM1rEMKrJYm/e9cwS/N2fUm+H+jQIlFMpHOM+yNuiD9tNkltCFbnnq6vGDnlh0dZ5rAGF5mN/B
 7i+YLIwy
 v361wQ2DMHSKpsCd6QifxzZOVpCnyBiHHCXMzF/+18OtbpfKpsbKZ5rAKeKnfr1xd1u+/SwDwSoNEbcBti0m4Hj4jGaAuepPSKE0JErFm74fo4OvPjrXwRD8d4z3IcW7vOxBsuFeuktS8ZosLmAyLXy39sqbfB/4vKyYFSoiYBbI03gs+9NrGYfaV0YXOdxIOgVtMOveVtEb9rMWQtfn/D1Wkrr2cDdS6s820XSemi7pdo6gBdOnd7tuKdY7gagRXOnWix7CTQ+3vMrm/K9tvfJ3aZj5M5+YfixBNaPufKPTI6yM=
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

