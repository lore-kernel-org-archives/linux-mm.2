Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F899CD98C6
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F9D76B0093; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C06A6B0095; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312CE6B0096; Wed, 10 Jun 2026 09:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F41D46B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADA67C0146
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:59 +0000 (UTC)
X-FDA: 84864151638.26.784E5A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0923F10000E
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPVLlWoM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDkQJtDgOrU4lvsYg1EkfO75V/KL21F3Sc45rqb1ccE=;
	b=OSXgSWc8TveC/BuwGiU/LR6y4JJsEW7nCVWZAV6ZshhA3vfb5+1ju5i3JYAkDDubZ0EUJj
	sDgjtKDpSr2GZ9s0E68PnbVPaMXzvG4l/HWSeE5UwZoOhFAMO1l9PSqAe+Sl9Afbn0J9TU
	BYJVUZkdqoWYkURtUse4INYpQw4Sewc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPVLlWoM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099758;
	b=JFhVi5ToyjxrZLfduMi9q8lDVqa2fwfkdEXQq7jxzsIdroENP77vQTnH37iyJJY9Nd1uuC
	6B+7/10G/9j9lP32O6S8d2xOesJZBTqfKBBuTff1idbrOgv90/4PvUYO0iQ5+kpzhzXulj
	zIf4LbF14Xfk0Ye7TPi9bp/IxIVSIkU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AC8A60141;
	Wed, 10 Jun 2026 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91571F0089B;
	Wed, 10 Jun 2026 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099757;
	bh=EDkQJtDgOrU4lvsYg1EkfO75V/KL21F3Sc45rqb1ccE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPVLlWoMdhohPnY2v2+M7X6aLOAAsBM9xFiem1FcE4JHi9F2tf53jfedOXUm0YzLc
	 bbY0ex9oDuo/TvD3AHsSh7BU6nDffsSNQaXxy6Y7bvY9tbBP6htsK2O5CYFpZfwLV1
	 LUf7FWxCoX0ooxbiSOVKBP1qO2EKpWYM8Ffek591OILu9TzjVG8m6R732T3pmzqkRW
	 v/IUDl2WubbkFnAlC9EzgEUwmZlD6bU/9NDb7B+EhLElma6Mg98pZLN22W4k1ulRuT
	 bA/10CXmBuw0m5AWt0J+Mh3nf879D5JWrQ+SbUtL6VocODO1gPTs3TqLydeZ3/UM5P
	 WlHPVSNU9/A7Q==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 3/6] samples/damon/mtier: handle damon_start() failure
Date: Wed, 10 Jun 2026 06:55:41 -0700
Message-ID: <20260610135546.64943-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: <20260610135546.64943-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9yq7o9skcpmk1zp38qze1y9txzcg5brd
X-Rspamd-Queue-Id: 0923F10000E
X-HE-Tag: 1781099757-994186
X-HE-Meta: U2FsdGVkX18Gbljq+x8RdOHJAWs5b+Z34muqEoxkv2QBxfIKel76A3G3kPHv5b+SiPNOoWFQYGAfEO6iggOi1oynlKOxb8/ffdZeCVfSL4+L3ENiyqHs13HjyUiX4s9An3MxI9yyPTWP3mUA9f6sHXrCZo5mxXB383nWL7OQRJVE8kuOYz21w8Nfc+5s5B8yP9bC+09nrybkqJiZVk1OcxnLRJhQQ3TGdjTvfkmuV/mdP1uvWLlyBTa9i6JKfYCb7/jRVXnsvOcGtQf2qpC8xxkn4+TRnRqkfumaconL6/05BooBj6VdVB8SnHHvoMM8o7XW4pqwigX+ip2up723NwPss2EEl9cQixsJBp2yz2mn/2Ky2TCmm6AqoE6lyLXeunPyregKzNQxrB/g1AnTjERrK7ebffE5zkW5HxMizSCFhz0Fo7hYW4gtdrk7SwKhNhPX6Q2qmEL3Q51Zq9d3dpaZteXbo0ksa86/+4ST50ENkzaEUY+Tj5arrefuMrR7KOftB6FdnBX+OMY5oEKGH+uuKujUWEw5fE1j8SI9E5aNoXSVunk8+yOEeqbkCt4EYgRDWHDDHgPqz5IimOOcG/vOPGgGxcFgn8h1asVR00x28+QlhQwhjue/wvfdLqt6SV4zbFxv3J13fIBpwUquqNZdAiFR2ecPmRr8GDTi+p6OxCzfYQiwsF2AIKE3K8LwRgowJhjzwSHKqxfutp94ul3EhgSOfLr+MCAhOND2jf0tHsr6H+w0YMu5kd1Ulrz7xkL/r3j0PkOx7InAaeKReTvY9Jhp7sH9F0oGsIiAyPZeNzZjHWreXKQGJkzkrHK27vFt//irEhFkOKtTJqazmPARpsz9QfIb/OjMq4/XVV4RmJmpBMPY5ULV6CFs9eS5yapzwNklGyieygZAsOFrJ1yDOLWIiShtMUL6vU3rXEomCLv7ZtXwEkNqIN90w4eAnTmWWqGa1UpnXOimqul
 e3IONNR8
 LjwkG27f+cfJRjh0KPKUb0rgi5mwDlO1Bc5GUsAVsA3ZqYYjbpjEgbRvDBhw2nUVsgsNxM/5ZlUJHiQBxIgCRzzoIQfjq0GtrBh8rZkLqLQ9nJAu5r0JQV7+3DqBA7BxaX+1fqyotD6/EPIWpjv6U61iON0HAOLC4fuG7EWTvfmWd16iLYK2MWA4IXmwslUIYWqWHR49kU6zoTbTIcfFt9XtAE9XM3i1+HVbCvgFKbdpkWS7UkaFLjtm7qc048AQH54IEignnCSLNnQreezwEVH7MsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_mtier_start() callers assume it will clean up resources
when it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.

As a result, when damon_start() fails, it could leak the memory for
DAMON context.  Also, if damon_start() fails for only the second
context, the first context will indefinitely run, and avoid starting
other DAMON contexts since it is running in the exclusive mode.  Stop
possibly started DAMON context and free the contexts in case of the
failure to fix the issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo Y | sudo tee /sys/module/damon_sample_mtier/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the second
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the second
and the third commands above, we can show the memory consumption is only
increasing due to the leaks.  It requires the sudo permission though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260608112455.274231F00893@smtp.kernel.org

Fixes: 82a08bde3cf7 ("samples/damon: implement a DAMON module for memory tiering")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index eb1143de8df17..66b591f2180fa 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -174,6 +174,7 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 static int damon_sample_mtier_start(void)
 {
 	struct damon_ctx *ctx;
+	int err;
 
 	ctx = damon_sample_mtier_build_ctx(true);
 	if (!ctx)
@@ -185,7 +186,15 @@ static int damon_sample_mtier_start(void)
 		return -ENOMEM;
 	}
 	ctxs[1] = ctx;
-	return damon_start(ctxs, 2, true);
+	err = damon_start(ctxs, 2, true);
+	if (!err)
+		return 0;
+
+	if (damon_is_running(ctxs[0]))
+		damon_stop(ctxs, 1);
+	damon_destroy_ctx(ctxs[0]);
+	damon_destroy_ctx(ctxs[1]);
+	return err;
 }
 
 static void damon_sample_mtier_stop(void)
-- 
2.47.3

