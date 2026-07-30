Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477E9C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 04:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3896B0098; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79AA06B0099; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0BD6B009B; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CF916B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 00:40:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BB0031408B9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:59 +0000 (UTC)
X-FDA: 85044190518.29.BC881E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2FAA2100006
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjyJPEFd;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785386398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGhv1+JUPjQ740yCFrpuYKel7DV1kBFhSIfzEnBWQIg=;
	b=dcPUdG+qGVEKQbToCON/Ucei/Ovc9yTh9oaHEJpLaHzxv98Df4UDZ9VCrjecC25S3mDlJ7
	AjRF0QLb7rqTqqq9nqZ+33me56JstjarYh44jI3+RlVRBQuW8PZCKCydIhEikxiTi0KFt2
	d/HE/llAxES482wziV12cqETEKA0IsU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785386398;
	b=gVirMMtvQA1cc+7XMaC3+thYmAZwJGxbQkqjy+I1gTOMgb8IvWi36D5ftH9A+whmkSPpMU
	R2WrJDDWgVANZX+qH6OjLkqOVmwSZD5h/OMDetOhkKmeOJFj2/Khm21ToJ8Ia9pcjpOBEj
	pG+p6m3PYfUpzJ4xQosQx+RzLiJeB88=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WjyJPEFd;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BF0EB600AB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1541F00A3D;
	Thu, 30 Jul 2026 04:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785386397;
	bh=nGhv1+JUPjQ740yCFrpuYKel7DV1kBFhSIfzEnBWQIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjyJPEFd/o9hBdMuLnGy15VcNiR8AzeUgr+UnNXvRmFjT0rw2Xc5e/AJkzD0LVbVa
	 1t2s/YRQi+2njnmQNXnp4VzdQm5pNVZIyVUtLwg76y3uK9qLOg0fze5IFTzX8YB5B4
	 YjpokReYdY6kZk/wWNZnv3RfTsbor4MpOSw7/w2rN30f8qxpSurH/lKdNTV8AcwwdG
	 1L9kmE8HdHYAFDAt1uw/XICPDgghst03R0likIzJuoiRzMaNT6UAIc3OElIphlDSyT
	 If39ZmbEtNvW0ShVFBVSq17TYgTMG09A29EJojepJB54HVCvV5+MJAx8q2ifeCRLiG
	 UHrdM/G2SFlBQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 5/6] selftests/damon/sysfs.py: extend commit assertion function for probes
Date: Wed, 29 Jul 2026 21:39:42 -0700
Message-ID: <20260730043944.146030-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260730043944.146030-1-sj@kernel.org>
References: <20260730043944.146030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eikww5rc35np8688aw78ds9wpa43ys8f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2FAA2100006
X-HE-Tag: 1785386398-571272
X-HE-Meta: U2FsdGVkX18lN6tpWZwU9qeAG2cxN1ZoCjaGdXoI8079PphGV5m+vPRFlZTdWoLZK+vl5doldunrlEY/wcF/PSV7/DptbbFgeIfcNdWn1EocZZOPWuhoD+NLOlSB7VBUkwVEbum/ggiGfGpdIUBv57/7+tHkq9U6ftwelZS7aMF1ztzQWnGl6CGTxhpkVBVd+vkfXRfEVECDen+E/QK0ZtHHLFxLk0R+3vSqsJe/2q69cz1+GjpeHQbMLmxGKneYaLSTY8nWgTUrc4SZNsWy2skbwCrOkS1rsZQBrFTUVsgVQt89BLNuVHOEbQqnpgKH1xles5mWSzIJNKv8BeYbQJs6etPGXjCe+nwU20kHeZUvMjno2ilJK3Ri5Rrx3tAafbfXU/IWaL9SnUBi9HLvHdAN4vfKLwF2zLYhsD5tJ7+G7GNSJQmuoOh9WueRc7487N2X8lu10vOCZoUS/O300z6Op35KAIcKsIO4HwNlASdijgrfOLdp0HkJbi7/hRa8YkpaOmu1yTBQ5URFaVQkN9xgJZXz705m/6W+Es81E5IbT+dm1Dbhfuhc7JAyVqjxzSEmeprN9aBNT5J3C8e9mJy4l3QwirGoUdkqBZHQzLGHboEyC2T7j5b87ygA7oUuuXN/oTG2ZQNWw30MlvXELWf+xF0aGtGws0WqpEAnG7mlyhgoQYIjxSUJ5OVe+1jZVWR+YIismlooYWcY3sOek7FUxUi8vEKNZ5U3Fj9O7f+AF/NCJZoXuBNQ+dhCQv/R+Mea0CxX+ALESQ66TNTuCEd5dlOhj6q2j7u+fmhidrY8D9sAnA724JjraJkP5X1WUG+W3CVebvU4QB584E1j2DMnyJKKPCQvBbq0MRiAblZzz+u7Lodw+3/sollsw9d4qtVWRs76iRr7mkkBky3eR8LxvGQyF1WBWuhOcWijU/eUs6jAM2qEnfEmjLvHuiw64kbJyB1cYu3S1qqfyWa
 l0/yEfLs
 MlVFFgedFG0NDjdo07YGonCDDTjzk+QXxcWoSbV8F+RpZhp80WHvZs2YfGHjItd5jWNbO957gQIOj8Ne4cQ+jFW+mfFQRtsErTB1jtmcDAWjR4mutXw7u0rxmxKLy7/z42ZreTcUqitmJrt+8VXr5uSoDk+Ovhk4Ha7WCzmFWDsqEJ5nTOgpglaJV/G9kaeFz8ZmyN3cxkXZlia2DqdnT7f+OlLkr5D5oIIV4R4bQa9qmoYmPmaz1Kp3ICImQpkiJDLaL5HdSgHqVBbn3bBWCUHG297XuQhyx8JcNG7lRilVJpTo=
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

