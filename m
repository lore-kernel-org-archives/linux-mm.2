Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA997CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02D6C6B0099; Thu, 25 Jun 2026 10:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17306B009B; Thu, 25 Jun 2026 10:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD9D6B009D; Thu, 25 Jun 2026 10:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B5F6C6B0099
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 423DD120135
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:49 +0000 (UTC)
X-FDA: 84918656298.20.32BC87B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8D4A1C0009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9ctPnAg;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397487;
	b=ceCLHeCxz5G3cHB7wmRZgnUWpzZQQvF3gfIAVO59IYG1p5Q/4+3z22KrZid0xK1BC9ix7F
	JnyAcN5iTvWhNuXd3Vxg1F/wR3jh9yANRmEJ0uLiw+HI2XBMT7zcIHWrWcYebbM2CcvKdy
	VgcJ5nkXGAoe3RXen94qZzzaMOVbslQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/qRUF8cwtcmB/nbdsXtxrh3TaDK04SACL0YdAxUm/I8=;
	b=Sz+lqyobr+7FKRaQFO/QniN6rbOPUST9/ni/kdiqY5IDY00cYFnk6kqvLkdA8MQRQcOXIF
	Aff/FHxVRRLWTPiYy9Gonq+TCpcjr1pNaSVITLG4v+z8Bwm6ztpckI7FHB/in6638Xo2cv
	N4bvFIJhuL17jTI9Nb7Y6Q0m+TlnamQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9ctPnAg;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58A266014C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433FD1F00A3E;
	Thu, 25 Jun 2026 14:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397487;
	bh=/qRUF8cwtcmB/nbdsXtxrh3TaDK04SACL0YdAxUm/I8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9ctPnAgNruQsg1P3OCp65K1hjfuYOg8XROs6iQaZxmqH6lbJueikIkaIvaRMW9xc
	 KO7w4pF4xxofoOVrRfCArPziWcDBjTwA7zPK47qOt1HzMxzeIxsSURB4DXdPzlf67g
	 N0SVKp7M/7gSE+r21yHNJDLmw4YVOMCHbJBM+NfDYiGe7+rHaLgIbYpj3TjiAQ7vwe
	 Rei3qEfOhQ50CIFonOPziG+Jdmmm2uyZOJe7LiAls+6g2Snt3FVQ8RazIy3gch775I
	 6z6prJYjCc/6g+TGAiXQJLx1fNK2a1h6zJOdJ0HcipJC60HGpnNbj2Q0ytGAlaiXEy
	 iWdFxUevtADLw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 06/11] selftests/damon/sysfs.sh: test dests dir
Date: Thu, 25 Jun 2026 07:23:51 -0700
Message-ID: <20260625142357.103500-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: h3zxdt11urz8zorwcsuuf88qrddcnqzq
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A8D4A1C0009
X-HE-Tag: 1782397487-150308
X-HE-Meta: U2FsdGVkX1+ZN/P18tqaRbl6gvhedTXMc/b3NCS8R0PtkwIP79LKf3QIo5XVyOsx0waLcqdl8RYxf5KBGghPIZMdvGtjH29a4F57zo7LEjqIhHQ7T475Nq9q8f+msoW5j5Ms952BOMjVrtnyX1rth3tO41FDLc/kyHC3oc8OJ49l6vHAQN+tM0/+d315O5x6vJ9ayrI4tbH+2/yoVVc4lp4BZtoMrSKlusdkTSmAut+A1GZKw9ODzTpxJuEPIy2oXakzugU1X6nIZMYp245Q9MlhA/fE9mEYCwVCtBVkvMsvtkDyo9WLrMDW3GRF5pPbGgirbg5EkiGewWkWkwvkeC4lnmStyorFy/TaMz9+JU4fOf0dOLmWzEf23ihZkwfY9MR8VzTvmub5soM05Gubmf3LX18d6C1xHfSi0twcdbDiFGQeckGcdfeCn/BBNWMxjGFTAJxdq8Mev5FJMIdgmVT1+LcCkB0kUU2qOmcSqpMQv1VuUp26kRejGL5NKVAKd60ta1ZoHrFsXu2B4dDgTJJ/ZP9D8nE4ru3qDlLi4g+dJDgNzlx9VGOqAZUw7mR70/R1m2LVK/qibGA0KjTElzA6uyZXnQ4hipURMN501LMKSvHNkemRM+jBBWbHuUd1m7wTssCVNpZG/vunJxg5nFXHwMCagKroZszfA1wa7UBS25F+/rY0zrd39yqoSddqGUp3LvoaFtEMd9xV2jjFcpqa4j6LKJM+af26FFXQiIxQKA0gfUG2ydH7o/2z3QI2Kloz/FEBWRdV4grVS8qNdhDmnLew1AYr8dOqbOes7DN0UtjwoRrD67JCcFGUZLi3arn0AhGPWJmTiebaGwdzRnKr+LqDvj+LxaptXHMs+JEy/NFmWCAOd96G9l9LTDbPB/IQUkaxlbfq85VEvxbZdtzwqAN+4h/QgLJaFF/nYTfJWIkPw/nJO8xFWkh4TfmeTaX1W0pgfH0fQG/iYXM
 EoVguxdF
 uxUxyRSOskltfblf42YpaYFAPJZZx9r19NaKkS1Cg6AWfN1Xiv1UCzZv0T6kY2TtHpsk5OOHGkLTZrRX9B+Q8ZPbVBnvVRJP5uposlDSwme6m08WH/VfW4Z61v4Jxdz4vjrNnhDrI/NnLlBQEc6PPryzqdNGrCqMlZ/ODM6dcF8hgJJiYvWNprclpuPfy3Ig5L9oFI2ZG3nNV32Th+liojn+Q1Jj1cLCDLBvB5iiqEcwm6xBfGsge+pCZKGFozSWj9r9/WIpvTndlEwqjYmEm6gA4LnJTll/fMyrFcmRJgi0jCko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON selftest interface essential file operations test (sysfs.sh) is
not testing DAMOS dests/ directory.  Add the test.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 07a33995be852..b88bf7b98d7f7 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -99,6 +99,29 @@ test_stats()
 	done
 }
 
+test_dest()
+{
+	dest_dir=$1
+	ensure_file "$dest_dir/id" "exist" "600"
+	ensure_file "$dest_dir/weight" "exist" "600"
+}
+
+test_dests()
+{
+	dests_dir=$1
+	ensure_file "$dests_dir/nr_dests" "exist" "600"
+	ensure_write_succ "$dests_dir/nr_dests" "1" "valid input"
+	test_dest "$dests_dir/0"
+
+	ensure_write_succ "$dests_dir/nr_dests" "2" "valid input"
+	test_dest "$dests_dir/0"
+	test_dest "$dests_dir/1"
+
+	ensure_write_succ "$dests_dir/nr_dests" "0" "valid input"
+	ensure_dir "$dests_dir/0" "not_exist"
+	ensure_dir "$dests_dir/1" "not_exist"
+}
+
 test_filter()
 {
 	filter_dir=$1
@@ -225,6 +248,7 @@ test_scheme()
 	ensure_file "$scheme_dir/apply_interval_us" "exist" "600"
 	test_quotas "$scheme_dir/quotas"
 	test_watermarks "$scheme_dir/watermarks"
+	test_dests "$scheme_dir/dests"
 	test_filters "$scheme_dir/filters"
 	test_filters "$scheme_dir/core_filters"
 	test_filters "$scheme_dir/ops_filters"
-- 
2.47.3

