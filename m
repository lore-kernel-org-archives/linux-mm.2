Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3DD1C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626226B009D; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FD846B009F; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4778A6B00A0; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD2D6B009D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9877F1C0A34
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:05 +0000 (UTC)
X-FDA: 85040405730.08.0FF393F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 191B4100008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ig9CTfU9;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	b=uiiSkQglKoC54Vldb8s0LR95654GwdJa243slo8p99yOxFjbQyeIa8oTGJHoOY4iQAzx52
	UKaq+D8XG6kLT4bZkx62TR62IKPgp3m5XShzZ1t9kHm1zGVJdhm66m7iTbQj523SVJm3kV
	Rdp+fcnjsggbZbMCzHsySBE5XPSGvD8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296284;
	b=FqL8F3IFDdFAEnoVv/8g5HCJVwHdLARDAjqpv5tR4stmp7g0jVaezsYxeaZasNriJ+CGDN
	3xa7jXSdDec4lfnxPn02Z3Bsjv1WwNbvRpbEMmiQznH5JsRf5BgvI8LgfVBSG0r8SoNQoC
	M0MTcKqSuEPb0NR54QNW4kdGBhF/42s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ig9CTfU9;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C4864514E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFDD1F00A3F;
	Wed, 29 Jul 2026 03:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296283;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ig9CTfU97OBq4zVNbM6XqpVgx0xnThrpvyyRFnjKW4og7xcTPWcxaJZk7pRXE+SEQ
	 hPWqXnTHKx3W7Dd71f/xpBxcslhA/gycb7BzebBkvxdgYTsMZF9FB/MswcBP6Mtoss
	 Ka1X13QsmgPJe1W0pfqnMWG99gJ4xz6bRgzqFCgUE5G8Wh6rR/+a/QdHD8qdR2NICP
	 wbNrBrfRN5quTX4i0eKQOgtkjGYOdtSq7ZFfweP6eJk9bakyiO2m4bzvY6pB57oM4q
	 3kNb21M9InOa7XR54r+alNwe8Hp6QFM+9UuIIwg/wn9vz0znPLPnmt676qXIjHJ6bT
	 BsskY7+4ZCygg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 08/10] selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
Date: Tue, 28 Jul 2026 20:37:48 -0700
Message-ID: <20260729033751.131213-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 191B4100008
X-Stat-Signature: 5ab9f49ak4wrn75b39p943t7uncxs3sf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785296283-999386
X-HE-Meta: U2FsdGVkX19g7AoY8OJxi+7r3sK7ye26qpOPXfwFoTWY7xXR5HixFheEWRzGmR46bWUXM8L8JqWdla5BM5Boal5S7rGYDCj84Nu4/RKOtxw0UUxehtzWrqUhTnEbO1dag7lR/cMpYzoEnGDtA83VDJgC7h5mELmAW1FL8ZspllWcz6pXLoGjlYZDt2ypBvMliInm+B5rDGymmj2qxg2QARdNZrKCelI8WAf4FHLt32ygOvF8m/TS48OLtOLfymmahzLn/1ibsdKxcHNl121A5Pd1jfw0ub2ZsjXsVpzK3UKRvB9VCJWtsvloPTWNMXDRY/A6FibzOyV6wjrOtpxagcA4SkRyNfO7Wg56xgpwJO0nh+ql3DT9Txd9OmZ/cxJohhanLiSFeyEXxsRCp9ohD4fqw1jWqUdUCL8OBb9COu7hb8J2nn+XKuBjwqdUVYACAm1H3Wyo4/KiZsUACNp2OHVFgE2fNtZ5FXBy0UmAq9dPeDpo+e3l5aF45BgwKZma5RiQr6Z8xAMbljgxy3D/J2LHMg4HioJBFuMJHoI71ekOq/M6xAyKtSVFcplI1sc+lrsugVvq9dbM2B4TwNbRWkejKWjjAjUZEpm3i5aqTWcjgO/UrAAI9FImKB5rGRXTN1ADp5nI7aVhoma8zRi2e2JYmasqHKQZWXl1AN6vPD4rDKvdCFrZeFDjo1mJKlUwwjXoPHNtKoTdDA5Ot1+OEyqv7aod1nIFBqpWKADRmR4/UCYehN4PImBeAtjv7In++c2KMicWeEQCPNGKtDB0Z3dCMKHpE6nzNjbkP372QsZ2OJ5M/vaFdbyJ1/d0J7uldIRsd8hWKHs4FH8TMU8nOmz8u0wIQaj2jWFQTL3U04Fcx1C2T+B9dVoACK8vhuZEmx6WcF/XYynnpXqT2rZLFIGb4VCCX8qnkoGzvRMFXPIlJBSsnEezlgLbhzskNrceOL7IfNp5H1ikDZrpToP
 mz6xI6z3
 fbGT/05qDTK+6jxwOoc7MVtqzJkFmDuJKd8YgOy6kYnchdiUyVaxCBiwUxU45SFvc9qetsxhS4XK1P/RlM9uk+l3TU9jlBX/ZgUwuGpms1NrJ2rf7Ld3qZ9uhN6euzMnN411m48/enTFo0rm9eUKvxlalSwsVpbse/iRdu2FKTNWfcn7pxToRzn2f8KGhKY7Ft5gwMDaYrAckzTBEJnpJqHYVOtFKgh8mV8SYrbWdmvafqsC17VBy/RGGChL/4eQE1Wk6dxO6UkJsN+XzW0cKuTJnvI+Bpb2YBGPtiUIjdkf4ZvubQ25bfAbXVBEvA7gUXUsGL6T2F/ZQUUHVapc3nFspoOCeBbjGuKNl
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

