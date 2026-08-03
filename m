Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E3E7C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49B1B6B0088; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AEF6B009B; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201BA6B0088; Mon,  3 Aug 2026 09:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D32C76B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:46:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5011916070E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:57 +0000 (UTC)
X-FDA: 85060084074.12.1E7F2F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4CCD100012
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:46:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TeG3cNcH;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764815;
	b=idTLn3SkNmzbR+aoGRfkO68G8uh7h9jHGTBLDiFw6YzcuNhKc7qUc8XNGlBZhNoebMXRw3
	9WCncm8thQWBuGkbSFiGzFNcsLEluT40OSKrM8h0Z4FgQeZ8eJvjiZN4jVYHGS0iYso87/
	SyBgESWjReVK1+wrM/3gupQ5foKDu6g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TeG3cNcH;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ew/a4uW6pk7X4wPVJ5ylrhLZPDJztc2+7Q2+2wvo0Vc=;
	b=n4D8SDQErMftwYL0BsRn+wuOqCMX1s3hOAW1nxhdZwoML5fFGRWNFthBLt3s0oPU9Furxb
	ZQYyZfkPZYHbel4lJ3R567O87pMiZmjsOPN9WaLDetoNLhytJLRmFjj4XFds/pkWHrr5tf
	XzP2QPQ1Et4iwyXKj5YH3CVewGMHMuc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D3DF3434B4;
	Mon,  3 Aug 2026 13:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DC11F000E9;
	Mon,  3 Aug 2026 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764814;
	bh=ew/a4uW6pk7X4wPVJ5ylrhLZPDJztc2+7Q2+2wvo0Vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TeG3cNcHOjyt6NbpX4mE3HPN+FD+an3SSYMhvuOsNiMqZPW4KK7yoPI0W4OQ+eC7N
	 5XCwzOi/7y+ajoEAImKnYlIpWADWhvifrq5NDBrrgI+jandWKDWDc3AOI1A3yY4a65
	 quZkudi1QMxxttmiJ1uUyJQEGkvLBxv2jJXmwX2iZdJTSSGIrklPsS2ZqYw+uFiadQ
	 u/oPjDZjlA47hYKBlwrjf5bzV6buhhWTmYdztde3pW6QG8Gm3Pg/ctuF1oEBQ79p99
	 dVAzP556DHp8BxRubKsEjRXgjRjgQZU2pWbgOwaW4xD+L67udYgXne7MeaWPR3aFRN
	 oNAa82ZsQLang==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/reclaim: skip damon_call() if ctx has not started
Date: Mon,  3 Aug 2026 06:46:44 -0700
Message-ID: <20260803134646.16640-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260803134646.16640-1-sj@kernel.org>
References: <20260803134646.16640-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7w7k8bb8eobm7ap71kt7hzbdz6t7mgpn
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A4CCD100012
X-Rspam-User: 
X-HE-Tag: 1785764815-562420
X-HE-Meta: U2FsdGVkX1+Yr5gw6chQfLMUFZv/e0qT1JZB2CFp8INwwCkJiXHPRqxwz01Zid7gZVn5erml9MIkKG11E7iXiDe9pHORa5MWi0XrxNp/zU0k8RNzzOowPIhem2Gf+zGX/6qGijCeswGViHCOp1KBsNRBET3pb+7IjOfkBuDUTF1WoW7FGYCPJDxaah/8/0uEP12F8aHnUtEKNRwEu25V9seZe4drQfkoDOIGUUXrllqYBaaazLU+HKu1rdYjOfZ9q11up8ayoTaFHRWqt4A3+78bacx0vGwzFsNTgbuze3chNLQFfPhQQz1Xhc1MbwW+GteD2amAXI5ltlsbU9swK2hN5ocgKpTUQVFjIzZT0XVYxayXQBlZnRVNHN3NMANtiJ48RNQDTeafVEeqDMeXVr4ZqkUxubDKEIOaSj4rts9LRZvJUpL3PKAo9hP9lJjYhRYU1GbifXBx33WnudVQm9XPziUozZqfi8EGmZv1pREE7IKTgyXwmwpOKg+NRXdX/craXJ2jz7OfAMGPxzDugO5ioABpghOjH5XuSOtYbuTpT0mVjoYdixEO2PcPsqAZztNaMqfIudPM6YKl0xuxMuRDn64rEwpm9P7KS6AWaJnwyie4DM+1wVnVSNF9d55PBthPcKt/CFbjlMBcrNh/daLX5xgJc2xfXahRsibYK+/y1p0dOVm/0mCm7mksBSyKdTnwvwIJ3iToVdYJGZThVbV0DI1hjSA1Q2tIkHVmD7xygNmQBnEOQbBoqQzbQ97S79B41kHi9Tj0dxHAfHILnbwSvo+uGQtuhDtJ7651HEgh2LO1Cb0t1YwcH1D2TNhLQLZBmnsAYEHqryzy1z10aYrt6fCRuNj9SPq0UWwp3bNnFJOWsINZIIKSH2+bCt6WPrR+YZge2u4UrUp5eXXqB74dLXZVhjed8K6djyMdMqHC2gMToFnxM5eKraB2665t2fLHy6DBpzI80dCms9s
 kS/X4yJ2
 JMuz8luTIm6uv9R9y/lo/hrrez5wSwj2b9at88r7ZJKMH3ah034jklTiAQSGjZiZwU/ctpHyZ2AtsL7JGq/3dHN73/5s4pkSRzeFyx2ZZktKhiRCirpDoPGXsHTb1gYlHMsyy7jiiw5SEE3u88leAm8TS333/Bve4WAdns3C9HwL1ahw45M55HuG73Na1pWwLorseoULgREuyUF+6YgL/OohfkVogqcF/b/auiOEZXEEssmCrG/g4f1mUGZKJzeStu0P9aWk1AT2iXxLqXtFCNvLS0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM calls damon_call() for commit_inputs parameter user input
if the DAMON context is initialized.  The context could be initialized,
but not yet successfully started.  In the case, damon_call() could
indefinitely hang.  Read the comment on damon_call() for more detail.
Fix the problem by memorizing if the DAMON context has ever successfully
started, and skip damon_call() if it has not.

This issue can easily be reproduced by writing Y to commit_inputs on a
system that DAMON_RECLAIM was not turned on before.

Fixes: de3c60e1c831 ("mm/damon: add synchronous commit for commit_inputs")
Cc: <stable@vger.kernel.org> # 7.2.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 09e941d75f67d..45d5557cc575a 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -271,6 +271,8 @@ static int damon_reclaim_commit_inputs_fn(void *arg)
 	return damon_reclaim_apply_parameters();
 }
 
+static bool damon_reclaim_damon_has_started;
+
 static int damon_reclaim_commit_inputs_store(const char *val,
 					     const struct kernel_param *kp)
 {
@@ -291,11 +293,8 @@ static int damon_reclaim_commit_inputs_store(const char *val,
 	if (!commit_inputs_request)
 		return 0;
 
-	/*
-	 * Skip damon_call() if ctx is not initialized to avoid
-	 * NULL pointer dereference.
-	 */
-	if (!ctx)
+	/* Skip damon_call() if ctx has not successfully started. */
+	if (!damon_reclaim_damon_has_started)
 		return -EINVAL;
 
 	err = damon_call(ctx, &control);
@@ -344,6 +343,8 @@ static int damon_reclaim_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
+	if (!damon_reclaim_damon_has_started)
+		damon_reclaim_damon_has_started = true;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

