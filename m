Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0DC1C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A856B00B4; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC716B00B5; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08DF6B00B6; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACA416B00B4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:03:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 334BA140236
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:42 +0000 (UTC)
X-FDA: 85168990284.11.0E47C09
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 85E9B40008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:03:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7vlAqWY;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGhv1+JUPjQ740yCFrpuYKel7DV1kBFhSIfzEnBWQIg=;
	b=ZXXmq1zD5gq6NJ8C1iwACMzcT6zpyR1LFmuQMQjcd/188tRwD7QqgqbJe/23K/kGs0qG+K
	Lx4NLjh5/9AYcEhUOeTikMSGh7bRLrxBpeTlyTzJvQ9gQcjCFhwboKdZS0fshvOb3BlbTf
	+8Zadl6934kVJhS7cVRB1jQhnddaj+8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357820;
	b=3eH5BwYnn48+IUHPogLKXoN7ArFNjVCAjpKE8Ko0cVaH7aPiPKGyZ5/WCVgVps2nAnrNO2
	mGgFIaTlUVzTxf7aJ+mlxxOlvEQ+xCAayJqoHIBRztH1sef6uXbR2uC/Xpgjsmf6TuYhVl
	PP6FmwkJoaYjZakYhtrTErIT4EQY4sI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7vlAqWY;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14D5B600D9;
	Wed,  2 Sep 2026 14:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89EFB1F00ACA;
	Wed,  2 Sep 2026 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788357819;
	bh=nGhv1+JUPjQ740yCFrpuYKel7DV1kBFhSIfzEnBWQIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7vlAqWYeD503881Q18uBCW59tnF7IrujoycZ/1loFYqEAJTk79ZCTJqDm7motQk8
	 l9YtXYH/yv9cTfI9I2QBWj/MHnjMZqAffIOdz+4hOjw7fXL5s84Guz5eBAuWmN8o8Q
	 m6qaGqpY5jEV2RXrtJLSU6qkJuyBXIF9ZEGP7FumNkmaO+bP1CFmtXzAx4/cR34VA8
	 YavY8bZnGq7crfAHb4toZD74S0JMnTdTR8mB0WyWGDiCLAE4KK7ql/q0LZqLvVEX3i
	 1Ch5upfuGoOFsqHScLk3Lwe4rKHp/PU98SPXQYwxx1LF3bPMJBm6dOMsH0uD9R2YaY
	 z9pbkv6Ifyh3g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/6] selftests/damon/sysfs.py: extend commit assertion function for probes
Date: Wed,  2 Sep 2026 07:03:11 -0700
Message-ID: <20260902140313.85983-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902140313.85983-1-sj@kernel.org>
References: <20260902140313.85983-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 85E9B40008
X-Stat-Signature: o4weeeisuygx75rk3t8cjeeoig3apxa4
X-HE-Tag: 1788357820-633011
X-HE-Meta: U2FsdGVkX1/kOSjHEDIiwn+wpHfFpJh76qcf9xoeYa0Q56Z5Qsv1AP/TAHooW9gjdrq5WUZubhkbt2w7/8OeIPgTlLebVk4Lkrg74sfswT3bLYbrFzs+f6snBkidlkqYi7VpNQtzpfupQUbgnuOGhfz+h0DTKSvbdogZus/yjBQE9aCCsN5Z3bVexXs8hD7rodutb2s5OESwJ93/9DEDFDZy6c0KuCGb+ja16eXHvtqcglOIXFOWJjSCzapGlZAPhNiEyyF/87hVNWxKGXg+0KvJ6Sz7lxhVkob0aVVAaxOo3zphEK9PyojJHR8u4+PIJXTHXOv26iAfAkucxseXfaGLh+13AChMJOL/4eaDcfxH74rst/Hr7yeQ5+IEdFHa8/jxSFRTSZsv6k1/Au3gO9Se9LJtL1mzc+xnlvLuZAU5J1/5Kj8xVaolvicofQuD5KX1zJdFGMBJK8+jUqjkasVD89oY8tMbnGSZVo7mzBWUpQvGjMFudsUCGg4bh4cGKDzAT8v7nirJt0syL94MmMKvrdBVggtPdpRet82PKoH0L4bqFbl+BsMiae1CdOEpsNlvg6mO+JmL35NU1g0edbXBxPDDUx/16PWP98C8rJINR4tzA9zT2pUQDaBGtAKpgBSA5KlxpMeWt1j5LdRRmjbFvZFvUhx2aHL8PeiRcv7EOrOebTZIFvCAL7FIc7rYjF/15x1LqZ6bSWzvaaD5s8lS7tGR7JQJzjdglzDrxMeJiWD/AE22jYAYGjLnSeIKtivzlL4g5bYbZKQY/CuZEnRcwJl2DDI7sm2ANyTnBGLvUazAwZLgZstsZCbpuwTelMIuILPkzo3QCzvpS39nLC6slDo0WcP/4Zxi872IoPmmHuHNuKqZELIGCXHRH5TFPhDCX3fJtjBHfKHWn74Lsmpu1apnuCHgg/Ut8LvItrJDVHQgy0fSwRbJenpp5O654VZTpXJZU6xoMWUiq6/
 DmMXmxT/
 R0uCncwUmbxUaP4UrvoSnn0RjImgLUAvfTXrCbdSS6uhC8IaBlDQXgU3dMHeEp9+2Pl+3uQjT3UYDHC6wBQ8/qCyhjB8ci0kHlTHzuId8E17wz8WgpZHBpR4EGro2U3hE0VEgUMkA42Hxm30N8kBgL/l2byRhfHqiJmPuGWnMrXKKv0zJ8Xh/ZWCht/NY5EaqZpy9Fe5HU3SFV58sI9nxHnv9bX1KDgEEHviZ4UV7I68qWng=
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

