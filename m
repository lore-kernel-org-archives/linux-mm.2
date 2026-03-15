Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60515F30288
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3696B00DA; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A11D6B00DD; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204906B00D9; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B14F36B00DA
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F5D513C22A
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:28 +0000 (UTC)
X-FDA: 84549515736.02.0A57626
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B2007180014
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XYTN4IFR;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB4UoVanGjJ0b6Z/rtgw22+7a2ViKkbvDoer3Kj9isQ=;
	b=ImAbX6M46VsQ3cyxBVXoxIRetWvZVeUspukK0ZKF2LafLljflLAXwjJO3CjCXEtaonh4l5
	dfjTgR+XHO3xru6riO2vXAENFqQrFV2UWGdQWG1jChhzWgoUYTM+UOjvgEoVcZslT51q53
	TQ9GNitRHMNUkNaLI6n4r9OGL+07GR4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XYTN4IFR;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608426; a=rsa-sha256;
	cv=none;
	b=ejWJAQsPJ2w+8IfJbxi1bE0iEEZGS0Tdz3bpbwXd78xEUj3+BPSpY1DKjvoYSrJHD9WoBH
	/heOCmO+bGVI1f7YmpVP3EOlkuO7gLJW9FzRyurNZ302zoZ/cwibuuin4u7tIvX3NQvTXW
	LaEWoohKkX8aWOiXHqjBDB9YTAWG/Uk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 21BA443ECD
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0699C4AF09;
	Sun, 15 Mar 2026 21:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608425;
	bh=TJXeffpmshBn5e3s77gk9ewA/YmV5afqYkZ0L4RsmNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYTN4IFRaRp+sesyBx8wFBO0MD+H2iyBHeaY5dDSP6FDhKvuHXHrcIDjBS4EDdrzV
	 Ft+7xIeOrtAAg0/ch/Qv/rZIr91vvxCynNYUsZp5K1iBP9MJi0PG681M9kKl3Bs/Kd
	 nJnEaSlgkmaxMyQ+lwGsMJ1hqFtOi/KCml7i6xRkyZvt2iTqbk9NhEMXhD83oeYIt8
	 2gZCsC0bXBZs3KHDfvBcTSAhsvM5Ac/TQ+WNMyqiEvXn4RwG26DoE/4sKWqF8OHxUu
	 3xjeOznxucWkfXN2/FzB8we6ipAiJ9YK8DxiHoOuHmZXfyOC8vWQ1vgnSWp+K7I6UX
	 Nm+pnZnWyq1FA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Sun, 15 Mar 2026 14:00:06 -0700
Message-ID: <20260315210012.94846-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B2007180014
X-Rspamd-Server: rspam08
X-Stat-Signature: wm5w7ccffzzr9faaf8qjiyumhx8msuzz
X-HE-Tag: 1773608426-423115
X-HE-Meta: U2FsdGVkX1+lDxkdeo0D0DtDFlFWHH5lXVQddn0uWotb16W2cM/UHTgx5MOIK6e4acsMbIeWfyvB6qjtdeDQuPWNRPpuqw0jdL9/hCvlL9wbUksXaB+4Kn/lMgjFUg+oIivN1ag4NPdWEQswcH3EERku1jaa1ESdLdKgCFxD8iw3CIzp2KbV9aHsDrfU6Hjp1rfCxeFuPPNv26vS7gmUySLYE3fBOUMklrXsUsQsUvUbjCHVM+OOENgyJfdQLg7GZiLsxy5hGi2vt0ooyfoYY4mVJ6EBqLznoEMzHUwgkalfhCZetDMBA8kuqLUmD+bHA5Ibdk6mzzMQBtSuhBasWbNGr8fNtT7k3FNABaRwRySogiZN0m5luHbcRNuwhEyGumCLl+l9MMVs9BiR772d1IcQqkI3oW0VLo1C6FN06m0UOCXvC93ozJuKTeQp1Vj8++iSlaQebm2RCVTkLrxLxwp5NOXIGtso9O+PM4Lx/78IUYXt4ERx3E0/F4cHwwmC9BOTk6OUGuDGAPJDcKGpo7cihoEMu4gV1VHEuJTPnp2quX2r8o3vQPX7Rnvwml4MTMnmNf3De42Z/XkGWsToR5FFxtvSKCucO8+hEJhblGNTQ2gHW9d1KAC91JINerCOp1zGPPqOT2GWo4uu2K49nkFO1YxlccqFiDC9NUiQvbF/Sr0em7EXe2RpDLbaiYuldluZ3Xf4Vt4pxB7iQUzhrAfnDEmDdUKUIxwM9MSsTDGJMSuj2I8Lzc2luOhqN+fDOUzNgtucnikY5uwXnxsc0QILYNBTVOty1UsgvKCyypMSYkdJBcDj5z/slaT25+xBBSGSg3NNYGlduDiIEFIkVoOZP1kewu6eeHl6uo+RfJ1tbeG0p5X+GrxlMJEpW5lf/0EqYABFqBEJkHBQY2g1WYpLnOgvxOTTudbHPbvtlZ85ye0Ilhg3w5rDnviaiXSOPsy+9plcjwo83I/KqfR
 xUA4WCVj
 cpYsNsWwgsDU0VvtosSBVE1re05soNGd5PkEabyOjoNGvMZEKwCjv8n0AhhzF4Msjim6d/qSRoTuiAmZLxr3Wa+KE8OZVrYyxMhwA+mWLBu/zOT64H1mNrd1IGuYVw1OTAR3qZPKa5ymgJFjpKQ+ezQGAhTd+XcusZ8aKpIgo8h8CkaSwuc9yJtbML+RJefvNL/xzGckfWmP1QIHLo3Av4q1AZ8RkS+FthH8zOzUqs2iuZCShHsyOg89V6iLDljWlnOsdRW4BkIBxQZdFOJqrQ+Amvghnb2qYhi3xekCtC4UU21gXyVLCvwpfWe691uV4SbHpsGxhJva5pUnGJkZ7Ae8LB8VcesG+61S8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON test-purpose sysfs interface control Python module, _damon_sysfs,
is not supporting the newly added pause file.  Add the support of the
file, for future test and use of the feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd0..120b96ecbd741 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -604,10 +604,11 @@ class DamonCtx:
     targets = None
     schemes = None
     kdamond = None
+    pause = None
     idx = None
 
     def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[]):
+            schemes=[], pause=False):
         self.ops = ops
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
@@ -622,6 +623,8 @@ class DamonCtx:
             scheme.idx = idx
             scheme.context = self
 
+        self.pause=pause
+
     def sysfs_dir(self):
         return os.path.join(self.kdamond.sysfs_dir(), 'contexts',
                 '%d' % self.idx)
@@ -662,6 +665,11 @@ class DamonCtx:
             err = scheme.stage()
             if err is not None:
                 return err
+
+        err = write_file(os.path.join(self.sysfs_dir(), 'pause'), self.pause)
+        if err is not None:
+            return err
+
         return None
 
 class Kdamond:
-- 
2.47.3

