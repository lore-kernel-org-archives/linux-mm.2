Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3951CC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 260076B00B8; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149F76B00B7; Sat, 12 Sep 2026 16:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41A66B00BC; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 93DB66B00B7
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:08:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 153CB1C2636
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:27 +0000 (UTC)
X-FDA: 85206197454.23.1A9B2C3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 841631C0002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNzo2xmm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789243705;
	b=eCC24xtctfbHuj20N8Feqz2pqAn1sAP5vUUKT/k9ttwMEjkwNZ1KFNnWR3Ik+zFel34hDj
	HvE+RWugIUN0QC9+x00heKOi8fpLfNCkcwwMedmBFqhqUPydo5v7b/AZC3A81gq/HhvOIR
	QehpdQoSIKt6Il4mbqIEct25tJgPTpI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aNzo2xmm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789243705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qx5d1rQtT/tGb8Wbxvj4YF32pPVa2cNIDlP4wDI5PfI=;
	b=kL0npfcxxS5bIxsqFu/bmv5ROQxSt7U432OuHKaLVPeLB25/VOH+TXT1FvlH7+r1I5ENI8
	eGbP7uX5atVCnOLFDNJ+ecqPAYJo5iEwQ5xvEDSSzJfLugk3MN8mECQCrrTP6PLEyMbEOi
	HAmm6vLU8dDYMwxNKjFIFSzBRFOB7N0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 21DE760258
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:08:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6771F0089A;
	Sat, 12 Sep 2026 20:08:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789243704;
	bh=Qx5d1rQtT/tGb8Wbxvj4YF32pPVa2cNIDlP4wDI5PfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aNzo2xmmmXhHI+aFi0zDeDdLhUEQY8SIQ5ntFJ6nRAuZWwOC23SrPD1b7tdXwa9yZ
	 uQ9CUgTl8DEOTd8z3/KpxiB7UT/GqvZ91uHLPSlYUxDy1l6v9LFw3yNhKDAIv1MGLA
	 rQTJtLt7XEmBS8tOPWC3AhYOlmcXJkERVBVreTvUENYdGM7PJvYQPmVVCU8YoEi8uc
	 KVfjAwhwyhPSGOoqr6EXrYkt9Vmivbz5ZX5IMdgBGKwYoqlfchVLS/niaA0kh62+6K
	 p1tMojc1wmbqkBr/iA2+NI9IfJKJvqdB229+3cNt9rY0tzrpuatCMORHO1vkyoMwld
	 W1MtxCAvFjvpQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 7/9] selftests/damon/sysfs_memcg_path_leak: fail only for real DAMON leak
Date: Sat, 12 Sep 2026 13:08:08 -0700
Message-ID: <20260912200814.145612-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260912200814.145612-1-sj@kernel.org>
References: <20260912200814.145612-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 841631C0002
X-Stat-Signature: f9ij1cokmyxiy1hdryk1a5kbutok66er
X-HE-Tag: 1789243705-866219
X-HE-Meta: U2FsdGVkX19edo7RRALu+txScslI/IFdzVt2RG4wwrtoU4QCYNNUgOl/dnI8F+ACjkmTLMynRFN9ApPHE64R+E4OOeZGicSgyYHLSbvzOZL7MSBVV9n+7NlELDY1Y1hKUMSJ2wPdW0SGy5YXCX/qovRKBQW9WiMpM3pDY+OPSIdCboagnzoIZeO0C2Pf/GLaW9xYhGe5ewER0rMqebrK/tIWLkNFtqJD+nHtGThj8PhvkJicpyA1EgHYfX74M6bx1AMl0wcdKcdlrDRwgy4C3u59Kb+BAtrIwqiBUVvgMjX4gORQ1CGgcmkZTXIE5hfNYKw3kBH1bfIPHWzSL8WCYc8mwf5ZISASwj/crLtxjGjb49x8IKaSt678PIMvKOg+0LGocq0wdaOSL/yIa7eE2Ut2jznqItXO2FoV8x7MizbPfVhiACd46Cvp0KKEigggSEEssC+H+NG030Y0ySBlQNMS2kRDp8DTX8k3gojRu0K20KWxyIPYGPT9pQzxdkULqr0kaLlye+CXGm7VCkGr8JANCKbmb7AL1h/woxNNGrit2n7JOcEkYi5Lck/xA3e7Psf8v/9fZaNCMCS06fzKOUpUuZRhStoyCP4UjR0CHbijQeaM/Id71uPNXUeyuvdH56uJZT6xy0NeMZzxVKPgIPikoAwUKoDLIPmEDfGM8J0EX9oJGXyBG1RqlRbRejBLqrnnwwenT6lxhi0b5LWFjfutGmHrChrv+UW+L6FG7AotUoneP3yLe1nLRwu1FTb+XYtFp9udmvJ34eqVa+PFkUKMD2gNI3nv5o/JzUJX0vW2EpHsNkuJYCn2ujzfv2bYTm6aeeWm7pmklGtN+Rj81PtOwZ3jliylcHNxtUhMbZVTHlPF1VPlHEV4jqSeD2YE12fM1jaIruPYoE9f7jQoJKkS5Lunrm1XRLo00vN2NQS4F0b05dB0gzfGRBhSWZ6gokSgY49pNpco7M+/jLL
 Yw4R3Yvk
 kg4aYwheeVdD0M/GU1Kq0eSgDivspZwjdpB0pNVOywxYiTX3xfLyVbX0pnqoDWEuIg52AbcSDVGoagtBinyp+rmXzGWcUxemMn2nn+V9CcrKcU9LxRIuttR3o9uylNrdBAd6JUFlFJYqaAYxC6WRVpK+Yepn4JBqvx8iXBPxFGbOWf7c0RHn3uh1q7xEbeMNdkaiEqpTmnJA9IcX299mGIhG+cp0lrT2Wp8ooXkVm6qMafcvLj7XN0b7v9ZinzUaeJgcUb88hXqKqqYfQWxWJkOJEqvAgWh/mLvnhVnTMIcn06loA1csoMDFmsd7ufuOYfcFnlZ/SCDfJwPbawV7RQ1ebtY2935TiXf+12xuiapi3V+cQNt2CPrX5bQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The selftest can fail for any leak if it happens while the test is
running.  Remove the false positive test failures by further checking if
the expected leaking function is called out on the report.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs_memcg_path_leak.sh | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
index 33a7ff43ed6cc..6c2d8bb3fe570 100755
--- a/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
+++ b/tools/testing/selftests/damon/sysfs_memcg_path_leak.sh
@@ -41,5 +41,12 @@ if [ "$kmemleak_report" = "" ]
 then
 	exit 0
 fi
+if ! echo "$kmemleak_report" | grep "memcg_path_store" --quiet
+then
+	echo "[WARN] memleak found; apparenty not from DAMON, though"
+	echo "$kmemleak_report"
+	exit 0
+fi
+
 echo "$kmemleak_report"
 exit 1
-- 
2.47.3

