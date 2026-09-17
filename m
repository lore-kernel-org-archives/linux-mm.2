Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABA3C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BDFA6B009D; Thu, 17 Sep 2026 09:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36F296B009E; Thu, 17 Sep 2026 09:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285836B009F; Thu, 17 Sep 2026 09:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED5246B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:48:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C74F1C1D73
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:48:10 +0000 (UTC)
X-FDA: 85223383140.11.4504C4D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7D6E0120008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:48:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AS80hN1X;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789652888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPjOXpzA/XnC1Tb4O4aCY53qynGLKUHPRgytpT1S63A=;
	b=IpgiVrf6CZiD/t1AEn0qJmLKNz3YK0o9n+rMFPbD2olllfqTAGJP+eBOUzMZvVkVeWin6G
	im8ujHIHbtsESDLBIS3Rof9uJtrKq4NeQUtWV+mh+QcGuzebHrgq5+cntc0F6Fw5W/xpzU
	fOGnJoZ2y3gdzuWc+Wyy4fCU0StFIZ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789652888;
	b=OCFUbqDa7DJ82QPfnCSTrUR5VbGwukaZiHSBr/XvYBCUeAfnEJ1o2m3QMZac9NvD/SyBjO
	SKfxlawKau5K4uq0t6mdwNJ1ncuCJTsXwSgaNAJfL0PrvRe7Uqw1vtWzEu/MQ8SbG5iNNn
	1/bpqBiqbbRPNMTv7FrmPnZ7QKHVpKs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AS80hN1X;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=nPjOXpzA/XnC1Tb4O4aCY53qynGLKUHPRgytpT1S63A=; b=AS80hN1X/D0p5tmjULL2+XTpFU
	SwHLhpq05pRXs+GrgUJcXEKZ8WX30VStxQ9nFXOHZAZMLiwwgL+ns512tTOFPklYXp1NXsVT7b+Sd
	QOqjx21GroC0F9lTIHv1sf6AJjaK+c8Xv+LA1haXEeCjH6IN2LmAXL/UJmLkafBkUAWuS82aLTDHx
	I2YC+YNVLjU0GYqmwcsvqs70aT5N+7D+qTruLNZ7KLgwboc6DUIHNkHZ/gJiyY79CzohoS/Ar6ffZ
	x1t74FqQmLLKCR62SXe8hxw9ig3Ua/y9fmAbd8zjS2M8vRZCq4Gk8FgFfeM26m1kUPqGxDSR7X3Fu
	f/6c5BZQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7CSy-005zBf-15;
	Thu, 17 Sep 2026 13:47:57 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 17 Sep 2026 06:47:36 -0700
Subject: [PATCH 2/3] Documentation: kmemleak: fix stale statements about
 scanning
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-kmemleak-doc-v1-2-84fde6d1f749@debian.org>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
In-Reply-To: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2852; i=leitao@debian.org;
 h=from:subject:message-id; bh=p24D+Y5mMAxUcwtK7qfgEk0iOjQX9ouDJmkvpzS+HXs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqq+970Fp97dAda87X6OngoqU3eRhC2dhmhroPo
 xigP+AGHgmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqvvewAKCRA1o5Of/Hh3
 bWKqD/4w8CiiSkOwxv7iO2uPBGQ/tekba9aTlo2+PySjYKXcHo100mEBxl09ukUdpjObFFkB4xG
 hBS5f9+G44gxRvry7D/ciz9QoBylUviDYkkRahoxdyKSUNAVIXd31JDGP9zd5ukQREQa7872TH1
 iMJFUYYgo1185Y5A4EwxtT5CRwa51CJoVaGIhtWkR600C11v7uzjo69LKi3TW2u7/XvWYp1LHxB
 zaMv+ga46OOmvnLQi962t+5jsEgYVIxm0PpdaztffKfMPheFQKE6COYPY1Ju3+CEZPaL2d7uut+
 q51fic9sjP+lHbqIH3CsiijWSLM9W0c7HJhsbKReqThxxcmRy6AJ94vgIHarlyEQymomocrmBMe
 QuULRu0r6L4fezH92SXyHyK3CnAKboPsmHYfmZsUnFvtKSzS7j8doRjlPLo7ScwAA+J/relfETo
 O3Im8ZO8vlrUsqy8IjXGN8fX9y2gwekfSA23tkQG4M85dXsMZuWHR7nOp2+Xg8IcxpoByt4SZtq
 d5r48CTCptw97wuJ9HV0QqLMvIvOTEFRHphZ9CksLhJ68rZgBHQ3F+zpDnPqquWkWfgU66C5O05
 PxI3Lcy/9IPWwQq09nU0Q5V4rJl7SumCAjphf5WZdRaZ+eEYYREH8n2SuLVP37BeRrHH6kyLxSu
 S6HMBQ/GBjUI5bg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: 7dpt8knoh418z8jkrd1htxjoya1wzxdg
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D6E0120008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789652888-813025
X-HE-Meta: U2FsdGVkX18A2dzh9gYWm0GUBMzU9IURhGUJE7yaJhoXoI84lE7YcVxJYV0r9qwx7kVyerJHLfCMUG0DWR05XTXJFDe3PsbDkYREfHYFMTXNsg+TlhHvXyYlWTqoPaxJV3UW71yKHbf09+AxS5DI6d3HPH5K+vRJ8aVDfvIkmKxc6poiI9oZpkVN5mUJzX/+UM5fTh95UEccVLmPXiW+BsGR+Xl3WHo7rPmDrQm2eTEYcgXa0ZVChNxfhFCySEYUvX3o7vqAW+t4s5OYk0RhFtK8QXTGRICtb2CVO7BJPEiLRWGzI4PrXCJpCHOqprpcL6rMJsPUm6UBAg9MshXWNlT2MP3lhI3aTbdnGKgnJgB7v+c4Vg7E5EAtCwbgJpTPOoRss6v1AKwMtviK2eBBwH8jeEHb8tlA0jE+ITd1oIRvqfOEs7sgKKbdqbfJDr42/MpDRx7kTdDNJexdqMdztW0TCWnGH08Ar8f5A3GXmMb0tHkPJTp0cpWA0Bed3Cv4KqFJtOAMx2MzsxGKjtCN4m3IxDwNhu1mqAtNQ/tzA4aEEcYwAFRm3+nD7Ywq77IP64WfELtaAkpvQXce0pad+cSKxh7dklSNbW7uevazwIJGNH2F1u8Q1Vxao4SBR0q+BNTbfayk4c5RX2KUiqCeiaG+Q7kq8ol8lZG32a0Kv9CpWU7zVlyv220OXPo58VSK/Q2PgiT4SiwpQhjpIzBWW8qlB/yDFEyN3wQE1aLhfZgyZwl0KkRsF+/LjoU90x+SsOi6VwBgOcIMLtOeLOZKuuq4pawkfUHO0iBtb8lKeG1dhzChOIDGIXLKVd+aN2QV9AdGBykgJoM7QbYa/xNiJeF8GQkoQQJhqtRV4Jtofo2UJ09648uYN32w/aoI6CSUcxSJAIjqSylssvzoChbUYdFWMl/fpmWPOKIJeQnr+Hib3N59ULouzTnJ2EdM1x/fBUov2sZ9feSpoIpnzfR
 S10Bp1tI
 sq4JNa+Z5FLn05zHBRr11JF8k0XLCcCeuSgIR6x6oy66cPbogvpJpscro/+9L2i7j7jk2qXQkeXeIwwi+mO04yBKud6KZMse7KD9M9b4JpSdZRUiQNwNtnHTC9AmtdzHTeV8rtPLsdBvBUx2r7Us1C5Lt/oS5GpzF/iJAPwxutY7YHu35LIvrLS0mLCH/Z/U3F9nJBUQtMmNdyEMAyQPttwIAXfWEENrgKq67rE7pGvYgKQmd2OUnLwmxFL5izqMQWRUo47WhNMNO2hBhwMX+eSr5wCKLEUA4KiUW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three statements in the "false positives/negatives" and "Limitations"
sections have never matched the code:

 - task stack scanning is on by default (kmemleak_stack_scan = 1), as
   the parameter list earlier in the same document already states;

 - MSECS_MIN_AGE has been 5000, not 1000, since the initial commit;

 - scanning is done by a periodic kthread. Reading the debugfs file
   only lists what the last scan found; kmemleak_open() calls
   seq_open() and never scans.

Fixes: 04f70336c80c ("kmemleak: Add documentation on the memory leak detector")
Fixes: e0a2a1601bec ("kmemleak: Enable task stacks scanning by default")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/dev-tools/kmemleak.rst | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index 8dad7647742d3..b5fe7e671d0f8 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -190,7 +190,8 @@ reported by kmemleak because values found during the memory scanning
 point to such objects. To reduce the number of false negatives, kmemleak
 provides the kmemleak_ignore, kmemleak_scan_area, kmemleak_no_scan and
 kmemleak_erase functions (see above). The task stacks also increase the
-amount of false negatives and their scanning is not enabled by default.
+amount of false negatives and their scanning is enabled by default; it
+can be turned off with ``stack=off``.
 
 The false positives are objects wrongly reported as being memory leaks
 (orphan). For objects known not to be leaks, kmemleak provides the
@@ -200,7 +201,7 @@ longer be scanned.
 
 Some of the reported leaks are only transient, especially on SMP
 systems, because of pointers temporarily stored in CPU registers or
-stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 1000) representing
+stacks. Kmemleak defines MSECS_MIN_AGE (defaulting to 5000) representing
 the minimum age of an object to be reported as a memory leak.
 
 The ``min_unref_scans`` module parameter requires an object to be seen
@@ -217,8 +218,10 @@ Limitations and Drawbacks
 -------------------------
 
 The main drawback is the reduced performance of memory allocation and
-freeing. To avoid other penalties, the memory scanning is only performed
-when the /sys/kernel/debug/kmemleak file is read. Anyway, this tool is
+freeing. To avoid other penalties, the memory scanning is performed by a
+periodic thread rather than on every allocation. Reading the
+/sys/kernel/debug/kmemleak file only lists the objects found by the last
+scan; writing ``scan`` to it triggers a new one. Anyway, this tool is
 intended for debugging purposes where the performance might not be the
 most important requirement.
 

-- 
2.53.0-Meta


