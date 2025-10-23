Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24508CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788F88E0012; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EA7B8E001D; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58AD08E0012; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 406A78E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12DF01A094F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:48 +0000 (UTC)
X-FDA: 84027637176.12.EF3EFF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 87A12180003
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9w7oAey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182746; a=rsa-sha256;
	cv=none;
	b=YY0KpGurEq9GCGhppabRyczWex2BvlaA+8l9OdEyGaTDCW5TYqz1Oy7d8x0YN2sNBTAAbK
	6LJYKqVyJYK87G8GsKDclrN8R1PPqCoWjI+h7Fcekq1OIf4b2loWXqCjfH4DexNvfoFEaW
	7IkD2nVEAosk/aOQy4cejsZSpswkbPE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9w7oAey;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sYXhWmooJF0TFXJ49nwhDqvKNAi67Rjpwk+zlrT9McI=;
	b=1OSnCpUvJBhBkCC6pYh7VWjpFI/7dRnuMbt5OOZRMHPS6m0tl615/vV8rrUH4HwdBYzO3B
	GBv6WhWJVGL71ooyF47vG6viUx3HOcw1pSqJvSvKN3u0xy/GSdFRtWOcUGBmdwY8FGpAJ2
	hY6eo0AGjgTcs9txmNGkrU+YR4s57wQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1804860577;
	Thu, 23 Oct 2025 01:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC3FC19423;
	Thu, 23 Oct 2025 01:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182745;
	bh=/16NLG9ELNo7TPBr96lQkGZnNgiuxdJz+m68NvFaNcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9w7oAeykIWaG2b8dcXHBbWDStlzXq/7msaN2BG0ZoTNk7bKVgmTlNnXZQ90CV8k8
	 7+GsyqdsSIllGEvFwu70cYKwoYfNHtLJR/qy9lgrU14MfprVr+3k2c2f+eJwdRKIIR
	 gHKpkNAISrjsytHVyrHbpxKZc6vA8NpNYhEKHjQzkGTUINgV4oqjiukQxz40jlh71s
	 Lc0Fvw3UOoKn+IOT2GNcApT86fGUo9yw50N1NRsrG5YBVpbAvP0ZaKAAcW9s1XHrhy
	 f8r8gElXIgE4GaDALfZ+5CvIn7vZZ7tM9RwwbLmeKdJ/CulqW5I4eMcd0bU0DRzZns
	 j/TZzqWjTXPwA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 8/9] sysfs.py: extend assert_ctx_committed() for monitoring targets
Date: Wed, 22 Oct 2025 18:25:32 -0700
Message-ID: <20251023012535.69625-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87A12180003
X-Stat-Signature: uxzm4wos5b19pt8cnsh3ny34h5tpbfqk
X-HE-Tag: 1761182746-51709
X-HE-Meta: U2FsdGVkX1+5fWz4f7ouJKntagK6k4ScYik/cRdCn5oUnbgS6bVEhiDMNyQFWh5X2IzbdHqJCbbB7QXmkL/gtRjf7fjq3iacOxMhBvCvSJHWhblYHG0pF/oWt0BXLZr5BBDB8892PWQvHoYEv4V3xKd4uxGj/puTqrPk3iWAsARyDuo1Vjwona9zx9NYawYlW6I8wYCYZG0N2TMhYN54KeY1X+5qnASSsfJyD3S5Q6iBi4AHuaxYNa4QS5YKwCzVrnhE1Em8oNnVm3JP4lqB0pDw/yxDu9Szw7BxPTXXa9HztkDLelq8YYnd9HSxw8wkDyLHsssrCCsa7aVkFRgKQWmbso8mNXaYWvUcVIMPlj5OV+SGKushqNQZ+zpBQrC3GN0OUqwGn8/bG6e3CnABcTsmVNoeqEjRwxTewOiaeKtOlXcFJxxaexTPDzgu2zW4aRg8QLoIY1HcRff6ARSxe7oZ3PtfGZfft58vEGwKHRGaLFRroO6X0n1nBptUuYxRdPJ0+uvRhvuyxhsW/kKwsvfcnIKTxCD6fKmHv5619qqILyifvEKQ4+KckQ2nAdapD6VMnn7+Y1iw9nvNmb0avHfuc2Dl1rs0S0kl1F8I/HRhc/Lob1ruUOJRw8MbDqn+mXSdHhavCOceALTFy+HZZaOuBcu6SA46ozmrg5BbU9JYPmemEzzrQmCfAirqYF12TRSeHetJHdm3kghn1p7s5yeICsU77fzl3blyE/YxpkEG5kChOECk1p7jffWJ0yuNUsjaHsqJBnFbV6l2Rwn40n/TzpTuGtjwm6p83067WnLVyXQW2UH8FqN7tP+Vpns6wqXFj8u21w+bb5dGTHAy+ek62UHnzjRvgYdDHHgS/bnaf+KFvwV3Z9o8oXg6DTviSY8/X34R/wQKmjHWHuCCVTgLneuCsOYEZncSyJH6QuOFqdX5jqhH8LaXc6Vz9kRJMiK7EuProGWgycNdXo4
 TlFeo0KX
 eok8gMYX9XVHENPwuv+DrcH+dH+5s3nKxd7n8+u6fyTLvs02Xbu8zfhb+gms2uK0ezuVMHPdUU57PTVzIUWGXhFpJWtUsVI7mB4RaHguucqvldcrSgfSOwMQRSxXaj7IQkQkyV29aLDGzlcCH2TUBuQTw6PL8UDYKP+9e+sdaG/zjzBnEk789T25kYCjFm585nPS09VxET5RumyWe8pyRrQyZmISlEjRF7Hh1MRpFX1wn8OWDihv+vbBoKofrkF6nbYtM/Od8kCVGcXd+611jYNwWsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

assert_ctx_committed() is not asserting monitoring targets commitment,
since all existing callers of the function assume no target changes.
Extend it for future usage.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index 2666c6f0f1a5..fd8d3698326e 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -164,6 +164,16 @@ def assert_monitoring_attrs_committed(attrs, dump):
     assert_true(dump['max_nr_regions'] == attrs.max_nr_regions,
                 'max_nr_regions', dump)
 
+def assert_monitoring_target_committed(target, dump):
+    # target.pid is the pid "number", while dump['pid'] is 'struct pid'
+    # pointer, and hence cannot be compared.
+    assert_true(dump['obsolete'] == target.obsolete, 'target obsolete', dump)
+
+def assert_monitoring_targets_committed(targets, dump):
+    assert_true(len(targets) == len(dump), 'len_targets', dump)
+    for idx, target in enumerate(targets):
+        assert_monitoring_target_committed(target, dump[idx])
+
 def assert_ctx_committed(ctx, dump):
     ops_val = {
             'vaddr': 0,
@@ -172,6 +182,7 @@ def assert_ctx_committed(ctx, dump):
             }
     assert_true(dump['ops']['id'] == ops_val[ctx.ops], 'ops_id', dump)
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
+    assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
 def assert_ctxs_committed(ctxs, dump):
-- 
2.47.3

