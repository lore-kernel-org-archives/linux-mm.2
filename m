Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0133FCD5BAB
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9086B00A1; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0EC6B009F; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CED86B00A1; Wed, 20 May 2026 02:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 077AF6B009F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA84312017B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:13 +0000 (UTC)
X-FDA: 84786820986.09.953C4ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3DBBF1C000E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1WFFQ1p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	b=OpkEXX8yZepVWPMl4ChcvlzJ5CUij2r76XfsY2oRy0tfjf2FOsdb6vG+AhVz3w02twMWRp
	Chjw7BfXu2AiyFUXBqvdzSQiAmvbfM97XA5xIjBs/NuoYZpc3AYb21B8OnWZtqrifEJHWW
	YSavOcQ9mBU+F2Ln74Q6jryGxhNJ3eo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258552; a=rsa-sha256;
	cv=none;
	b=JBGE0OlvEvEKsnhUWBoBbBVpJ8NoGrln6QWIdJj1HW0Ti03KZAPBji5xpauTmAPrQ44Sns
	N5XCF9ua/0DHIXN5hv/+VGeXB9oV5R3P53J+EkqtmrXtKmCmOdU0bT+SuDM0daq7Pbl51M
	bTxZpErnuIaYXkLRL4/pQhTAcJ2CgfA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y1WFFQ1p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA63C60145
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61DBF1F00893;
	Wed, 20 May 2026 06:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258551;
	bh=iEjjWBHpUcq7nMlrb1+WzxDoNOgxUnUZ3YjegNS7FQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y1WFFQ1peG1tdIc3tQ50EmCXo96cI7B6rJPGaL/vd+YGsCEzAZMkk+XZs+tMCNzJ0
	 jdn2kyc7ycDQbESb2J8FhToujJgW7PNwRH7q45GZv6tRgBm8ycyrHjw8e80lIBg6vm
	 3qw4LIszIavLo3NzkMvWQ1i59RwE85f40znoRhs+3BMeRNAaa8gPYbuSvOHpUWS1H3
	 c3szwCnoAJ+5H9HRKLUeqnOGPFmZFspsIq71KKwLjgrfOeDgnDMLt1mSN2J27GP70E
	 p0icxGS+ftxRo5hzBHwUFg/TOwTdrQ18LdHMm8yMgRGzuQo52JiflzR5b3QJQZ155N
	 Q+Cc0p28kyE2A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 11/14] selftests/damon/sysfs.py: stop kdamonds before failing
Date: Tue, 19 May 2026 23:28:43 -0700
Message-ID: <20260520062858.167011-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3DBBF1C000E
X-Stat-Signature: 89mott7dxkrm4bcnoiw8mcgrct47qbib
X-Rspam-User: 
X-HE-Tag: 1779258552-908470
X-HE-Meta: U2FsdGVkX195RbXnT2z3p/ajXudpjuIYVvj9ki3eYmHizEdk26gjj7lmdmk79jj3JcNQHG5/4j0c039WpfhkZQJD3DOut+0m8MxUpYolJLSnRzZrv4tf6lTYw6FPYfwsrQVqmYIL5YCIgkCLNpqEdbKh9m7Vwrj2md+OsaBQLNck0uJRjlySbaprBbBM3NS0S7yDNt3MdL91jIByAjNlcANSYVbAT7NEFG06Wxn6nE+U7H3f47NkypfiJ/0vB5enzXb+dncePqG4W1QVAtIUAOS2bYcQyId7YGRQ5HOVTIzkFX91e98MIf7fkEfoRslEyxiZsMp1CVNXjGhDrnehdUX1TPGWvPt7SBe/ItOZOxcKJ0gSAmPKs9gn8hPLZQo77FH7Xaoxyc+dXNp5IBUEGTjjc3xnJg6gWrBL1Le10eWOX/EUNpZoxgEjliyxgf53USOCz6bGcNCxI43205rOKPvGQDRVofxHGCMhYixS+Ks4UCr5m5OFRUg7r4FgZV/YzfYEcmqsQHQrufzhmmsJHE55LYgC47rpODhVAZDGHfLjbUXCMqgTJV8KyjqUnmaQRwl9Y6B5bdqId0SqYTj2COqeS5wQV3OtP0ckVAJ/HgNbYSzbIeLNEMK9e0UwiWvjYNVIAW1fgyHBcyLgHP7ARxL2eSGysF4DGtVdcU7KZCe8pYo/DdDcEBOq3Ynsig4tsYBsUU683DNOyrD0eTUBfnXwAsIPM/HWUwRm5F6QmhaYfU2MwhX7io10JiXD7V+ZW1rZBBb3PbfCLkL1R5JAY+IUHKZE8hxfaQhJwtKQsTlLF9u819iaT2sSI45/isK5Rqvg4BEPMViaLIB7leobuK8J45LG0GQyz04vzaKV6hCnEPyWMZUMCxH4ia/1XxXZ4kjVDsjKES+b9/AXlmxGu9f8ENjisC8yJKHa6NnPtPfVsSPUcroqBDnIKLLN1dxrA++PA49XNlQsGLZ5hEM
 dHv527sN
 9Li4cQY80wWDk6/Ep7XucH9xkykmyKQgMyoa0gEU4CmitNMYF9/RFlgE729z4h/itZtTzqKI8tLi20DV1sc1+tprOUCsKGFdz+zjzRvhvAMoJY9fxIP7D5SO9+21T9eGAhR2KQFwWU3tXu5u1nGysqLSCqvo34vzFyoo8dBrdn4OF+21XS4xlivMKwKtLffgU+GEX6fwH32c4yMa/ESpH2U4jKdcPSWdJqkWQEXa81QWXJ0QVleE5CT1GhIRBYk+lfnhvvAj/E/SiDLmZJ/MflibtuR/3sNULwf9ZJJCiQb4Pa0k=
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

