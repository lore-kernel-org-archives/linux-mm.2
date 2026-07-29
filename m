Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 042FBC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 687896B0113; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB996B0115; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D8A46B0116; Wed, 29 Jul 2026 10:47:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDEAE6B0113
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:47:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 32BD212042E
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:47 +0000 (UTC)
X-FDA: 85042093374.05.CBD9B59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 96D6380005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQ8w9a9u;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785336465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGhv1+JUPjQ740yCFrpuYKel7DV1kBFhSIfzEnBWQIg=;
	b=nI4E8g3VwMfXZetDJfqLYzkv67OPLyvBC7yKFqi7oMtssFeHXFuDBT5fYZCKleuWNQWlEl
	8l7BVDEc16ShMu3ywW7VtCh/YUQL9V4jx7JGSFhI5A24bFqzrbTZdLlcv0F1W/K9Ruw/k3
	9b/oPf+9fSatYM00M+qeALSwrLqSvUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785336465;
	b=k1TRT32sKiM5XVPyOdRrozCL2jFwpMPci6UXT/qRHrho6cLcCMh/0vAaDbqtYqK0N2U+74
	B4dmhq6/9WhtJ+HeHotVyFYIo2qwuuK82Mk/eHaW7XDt7gfWTwm4sUmyGcr4vy3vx6BUKG
	/Myv38sTriiUv0wB7xTJOI92WL32FBo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQ8w9a9u;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9F4943AEA
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A01921F00ACF;
	Wed, 29 Jul 2026 14:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785336464;
	bh=nGhv1+JUPjQ740yCFrpuYKel7DV1kBFhSIfzEnBWQIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQ8w9a9uL9k5p+2Fz4RBhN39xb/SCWnRAsXRv5HVDEqNbWMdY2U4/45l7S8UJjpzO
	 FNtUpFF8dJubZ/R05ntpUUYAfngVS5em3lqWgJCVvM3CtKPonNzIzN1IjJNM+U0zjd
	 bfdDXHjVyRfvXX8CwgvEYKa1QTrqRwiBy5LEacXqzXqJAY19bH8vObH2ulJezqpbFD
	 6TcduBT5JG4tZrDHzE6TeEc0gIwZ0g5vNnZ4REgtBddG0diK6tugk48YopeRbZasvG
	 /iKtL14okm5aowGEhqd+q9BtWVpxBWrEjueZLQskadZT+yQLLPjHpfb9zEjFSrs4x4
	 +1i3F4FqL289g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/6] selftests/damon/sysfs.py: extend commit assertion function for probes
Date: Wed, 29 Jul 2026 07:47:36 -0700
Message-ID: <20260729144738.90895-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729144738.90895-1-sj@kernel.org>
References: <20260729144738.90895-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 96D6380005
X-Stat-Signature: xozkqw3jesc9gpofpyggzusc3bwu3rzi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785336465-976589
X-HE-Meta: U2FsdGVkX19dHYKaoUUPvYF8q+Si02F12w6+DokYswULwyVtMRb2PmO6kniPcoaTyqJWHdv9HjaFIfVTZ4dcxp8Dd1DQECHhGNxjg9/5A1bo68Im1EPsWXGUpJBlZ087Rba0riiZhL8a61zw9iQVu/CvWwmhjbGfibQSBND0w43E92WOp42ixV2TP2kaWWtMprl03ZyyeuEcGNDS+N4NpHoadr59cK62uUve0RW+0fKXoTiWj9Fxu7I+LsBEGqFN/CeOLZ2hL1NJcW7OZna1TDRo1HjEIhTp5I7RBolihIvcYJymAwyasiKQmAMlG/aRnGBsKHAngpjw2WP+pY9J9rG8n0jZupjgeVQqOnKPF3DpFC/ybcSpnngcTZiC6njmGpSItbojwIy5oEebbrKcO0QKVBMwmCIO28UkmKOecgOv9p7d7fYMVVJC6y33Q8oHrlNaFVX4tkqVoxOWJ3RpVGu7c1ACcfN/qZOqURFSWyAna451WpDrtOsTp6miWbkqDFtgkpGgGpq4UQB6TOMH6Z6OYrPPAS1+jEDFZFIX9xy8jqjzBmF9KgkMyysPhxYyJiWgN4Yp34rn68a5JHtB93RESBp6inuCvYGY8YpgV3JC2NtgCGa+1EnjxpPMw3rv1btZuKdIl/JNO9fzIt6P59H2Lv97QsqAgAVw71kehEypY4GCB650/tV/2BIAq4bRzdwKMonVkRSqz8nyzXhpZzox4KETqYALYqsI7g00u/okrGqB5WB2CoNI9678eU1P8qQCHHqoJKGfH6WUmAbNpqlkRuSHuZ3nxU9vGLKMJoAro4ThCGYvUvzcnaHquL/+xgOW/VoVaCOcn7FIUACmha7UjClrDbQTgbe+cy1UWHziLMVj30jqXITowK/JNy0krbFDIB4fYKC3VS0Iod12q+wkDar6+Ukxt/BLlqAh6muQs9vPHNiVYtvO3gu5zjbmQo6Zp+74NgOk2p+P8H9
 7i0hq4Pl
 Dr/KqAygDcc9/HTVdp/TPY5Kt2miKCDPSbJjlBEulvmkCOhRTJy08DiYzDEQY3ctVxlY1fO+eSWW8OUo98eRozV4Np+0Cs1C8SxPfB3al1VCNfMtDpBa1cUhe3PkWt/Ffy805kBhyEERpcmP0BPOk52EEb+CbICHZ65qzULOrh+vDdr2HI/QWgtx19Yv3Y4CSZ0m7tA5TtDA1JH3Xont6RNP+MoXfvCQK3OIJBrcTFcu6jyV35UELnbbWs2RW2h6OJ/A7MKQovDNA4ePeCioTYuxmIw62yx9Rb8UZmv/izh+rSqs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs testing commit assertion helper function to check
probes too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 88a26422ff44c..159cbeac067f8 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -178,6 +178,24 @@ def assert_monitoring_attrs_committed(attrs, dump):
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_damon_filters_committed(filters, dump):
+    assert_true(len(dump) == len(filters.filters), 'probe filters', dump)
+    for idx, damon_filter in enumerate(filters.filters):
+        filter_dump = dump[idx]
+        assert_true(filter_dump['type'] == damon_filter.type_, 'type',
+                    filter_dump)
+        assert_true(filter_dump['matching'] == damon_filter.matching,
+                    'matching', filter_dump)
+        assert_true(filter_dump['allow'] == damon_filter.allow, 'allow',
+                    filter_dump)
+
+def assert_probes_committed(probes, dump):
+    assert_true(len(dump) == len(probes.probes), 'probes length', dump)
+    for idx, probe in enumerate(probes.probes):
+        probe_dump = dump[idx]
+        assert_true(probe.weight == probe_dump['weight'], 'weight', probe_dump)
+        assert_damon_filters_committed(probe.filters, probe_dump['filters'])
+
 def assert_monitoring_target_committed(target, dump):
     # target.pid is the pid "number", while dump['pid'] is 'struct pid'
     # pointer, and hence cannot be compared.
@@ -196,6 +214,7 @@ def assert_ctx_committed(ctx, dump):
             }
     assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_probes_committed(ctx.monitoring_attrs.probes, dump['probes'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
-- 
2.47.3

