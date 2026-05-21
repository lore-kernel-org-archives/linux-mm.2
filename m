Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A49CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCE76B009E; Wed, 20 May 2026 23:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD756B009F; Wed, 20 May 2026 23:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EA8A6B00A0; Wed, 20 May 2026 23:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D0A86B009E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4C12D1404E9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:06 +0000 (UTC)
X-FDA: 84790058892.07.65F4CA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id B74222000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwHwqvHu;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	b=RYBfs7lqLLr9jNk0bUp3a34nNZdNKMggdNA6zWVr7kLCcscvUESsGGaGSvxXvyujfDatN6
	P0MdHMOXRW3F5R4/7d1vHyz+0p5t8aRAE/ypkBJXL1WQyrWR3B87/L2Bb/LGqUWwvjQC+4
	GyNd1Y5SeLAXNK6jE1fUy/mJthu1E6c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HwHwqvHu;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335644; a=rsa-sha256;
	cv=none;
	b=Jx+KWFRDIVnBY/x9wmAzpXdmkQvHeetQSkwtU988eEr3isS2raDFzmsUrR+xioj/FHtDzz
	eixjZmbVD5kc8Uro9tZXo7QgQ0/K7SBEsKmTyYdXs8pfh2yjlY0lCC483qmhdJkHBK15qv
	B7D5Pnqg3rJL73UtJbfq6Cx743NhD4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 589A260213
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE2781F00A3D;
	Thu, 21 May 2026 03:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335644;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HwHwqvHuE4iTfUsnnGzJKOLH2zxQ1Q5yirNcCod+GrrmVHGO2v64bu3g1g238SavM
	 OQq0i4Ws4Vd/Lyy0ObdczzVDaJnhfyqDd6H+q5arx4JqcbYBV6Im4Dz3OnJvU0++3t
	 lfSe1wD+jGIdQRiIGaGIVFdDj76DLqQfkoOj6qqAGwHDHvYKSq0q3kEeU9fD9fzc6U
	 fklMske90bAOKzi4wg/EGRuPLFPe8o/hn8CN8u6KgSxEIAUkuqh8m3RuQwWmSxIjGA
	 taGG63gGd6YHO3DDxQfhorsKo5AtqG+PEfX8pBKW9nmSyfcjTtHiTZXVOBHT2FjQOu
	 g76bvhaXeoikw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 11/14] selftests/damon/sysfs.py: stop kdamonds before failing
Date: Wed, 20 May 2026 20:53:45 -0700
Message-ID: <20260521035349.87565-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B74222000A
X-Rspam-User: 
X-Stat-Signature: 7p4eicg7ddhycqzeoi4tqsjhka7uifbc
X-HE-Tag: 1779335644-125355
X-HE-Meta: U2FsdGVkX1+fbbBLmgejeHyIyk4EvoKDaUaAYK8a5ptoucm89dI/2SFL0Cg7PsEAjCzu08qfsPZadp2QiqCmQIZl01NazEuU/BJ5VovCOPSxalGp2+vgUJkLpD05/SpQfqcmmuk0B6KQsFG1OBFL4mdg9K3wkkMDjhxPtBaGRsDNyuUu1x7f8rgK8XZc7ca9wAai4gWbtgBbdgalXLM653GibvfPyBiK+BuWWc/b+Z8xBg3QpaGfivCQC/wGDiH0laOSv7ZedVVVhQ41Y33qsafohDg0y2quWcOKSergR80YEWcKIw/SNb/FBxGZ2Ifx4fwemOm+nNCBsxICpefgB9dvKPZ5F7idvLSjoL9mhjbAdO7fFVakPBH2lEwZf4OJZ5kTVvnH2BfrYilAzz2DN33xUC78fg3LYJDAuwdUJxunSZWahX9fzIuPQmRluIu5/CEmN89cppjpH0d8Yb6APev+qi8Z9G1WZoZzR9Xg+Ha9CQIe5mUq579QomDfg5hck4FsffE7Q1GyVMMv5IJMGSev8eJgkmSTlMvCm58Brmc0vBBbievdaK07zsGGcU5+Fbsh0f1hl1svI3DsaVvbUpQIi3+SJ2JlGeacxKDn7TEteZgYtHfFoUXYOA08F+fdIl4VEQJhJy4T1q58X26qb1T/dn9BwxLnJ+YCa+D0epMWmNGjhZvqUH/9ypWBxIHZ8+0xVRTrLy58QlJyDW9ckYRvayE9ucg4SBQK6je13A8SshBu/M57XGU0cWVA2Gc+P9o3Tnib9CoD0WC2azOuYbO5Evi0efgvOz57K1OhU5kIk3iw0ETDAH023Qyd3fe3IFTTMeZoie7Bb7TPiOftZUcxe869HCiqu4pkom9jIL8k4aq/1jlKs04JLB/KBw8uGOlhDlM/wUMI5WnfBzAo1vKifv2XavdTdR1iyaqI4v+Vy6ZOU3gJt7hWq6Y/2ilbkiFARG7+MZ5L8ARQsGp
 zjA4VMwS
 EFO0pzOYxJ2Y3YrWu3kbWYatELK0d5IAQ4aWmgpUOpq1UVKAdM5nxeNvDNMKZAWfY90sBrxKFpyypQIbNnYRSSygmtRGEltG8m3ulPNgRxLnWEOe0NJ+vto+VjE3Tujew9v/rFlup0V+LE+UjkRqHMoH3VTa8fBwYvPcH1aTkGG2XjNLXNtatAjZEgDtUEcTUPkc1AqUeD2rhKzFun4A1dR2LB0rrYeDgmGduW4v5t6EbiKDpuvXBfLaY5SBzUNjGvykxR4KfI42OpN37CfjvVRnReO3oT7xk9Af6VUW9d1yAHZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an assertion is failed, sysfs.py DAMON selftest immediately exits
the test program leaving the DAMON running behind.  Many of the
following tests need to start DAMON on their own.  But because DAMON
that was started by sysfs.py is still running, those start attempts
fail, and the tests are failed or skipped.  Update sysfs.py to stop
DAMON before exiting the test program due to the assertion failure.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index cd4d82c852113..aa03a1187489f 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -24,9 +24,12 @@ def dump_damon_status_dict(pid):
     except Exception as e:
         return None, 'json.load fail (%s)' % e
 
+kdamonds = None
 def fail(expectation, status):
     print('unexpected %s' % expectation)
     print(json.dumps(status, indent=4))
+    if kdamonds is not None:
+        kdamonds.stop()
     exit(1)
 
 def assert_true(condition, expectation, status):
@@ -248,6 +251,7 @@ def assert_ctxs_committed(kdamonds):
                 ctx.pause = False
 
 def main():
+    global kdamonds
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
                 contexts=[_damon_sysfs.DamonCtx(
-- 
2.47.3

