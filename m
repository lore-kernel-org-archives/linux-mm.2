Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAA8C43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 21:55:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 082746B008A; Sun, 28 Jun 2026 17:54:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033296B0092; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB23B6B0093; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDC266B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 17:54:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 25083404C8
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:56 +0000 (UTC)
X-FDA: 84930676992.10.1AC0251
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9CAC140003
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kbd6cSN8;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782683694;
	b=bhTg1gKh2y9ENCSzSryJ9t9T1/7VSjPfaw+kUWUMo4XAN/W0TO0RVw8MaHxDXldyXF80/W
	oVTURHYQ4Ln7wXigTdWvEpPeGd3b3AdPZoucKj0fkd3Ry2mXFjT8jH3SVaXMPWufU2/XKi
	0p1bhEpeorFVe/5VNurcgTGWt9nnbwg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782683694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Byrg2i188f412iRZE4Bba2jB83L3ezRqbLbUNLGyb8o=;
	b=YDteedAwR8TZxJ7NidWdPLDAjicywWpYgWiY+DhQiFgdATwYKTASiKg4kvisUku6/o3Jx5
	k64fEraKIQhPwVhLYqL/xDYjg2UP03ELDYGZy6WVX1SD7c1bkEOSA4ocffm7VYQCv9yCbf
	jANYEKIdCkCccq7HEsR4fJzK2L9i3Uo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kbd6cSN8;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36E206001D;
	Sun, 28 Jun 2026 21:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A711F00A3E;
	Sun, 28 Jun 2026 21:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782683693;
	bh=Byrg2i188f412iRZE4Bba2jB83L3ezRqbLbUNLGyb8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kbd6cSN8YdZjPzpL51S+hGL4yt/obQJp5BgKsrEj4CdnuShWpJZ5bWg/SFyRLmevt
	 o1TfDpPMqXJ0YbcHOnn4oBLAkQzrtH+pOnGXlKQNEzNhc+na/5bRNrB14fm9zaJcFR
	 AcsqJlogqySFwXN05PTfKLmn9FlpxfUIG5roVkAAxE9qjn3NR1AR6vbtwAcloHjtwf
	 Re0qsnnwAOwTkKo7SjN/AdRZz06DbUkMD30r7VotIA1zedEO2JA5oRkPHb6vbquUOd
	 4Yv0p8qFpYxG4U/YhLb3ITTbh2RGkfWelyKco8PAEbCisokq5xfWum2u1M2JjhAFmN
	 pKxLt/+T8X41A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH 2/6] samples/damon/prcl: handle damon_start() failure
Date: Sun, 28 Jun 2026 14:54:41 -0700
Message-ID: <20260628215447.96166-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628215447.96166-1-sj@kernel.org>
References: <20260628215447.96166-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1fkbyqg67e53emgzuh3p46fgjx4e7i6i
X-Rspamd-Queue-Id: 9CAC140003
X-Rspamd-Server: rspam06
X-HE-Tag: 1782683694-493986
X-HE-Meta: U2FsdGVkX18zi6qHFIpmONE8hXw1z3zI5HGi24D5YdWYuoIhwJbNe2IozPBQYeNT7x5++dT7/3ohSizn5afLs17e9p29d2JdtAy+H0Hk8yMXIr9mWHZWa8S1VdZPnlL79+k3GvUOKBf+2905s/lb3y1pZUQ0cgU01niF//iztqHsx9D5wlanK4Al3GSp2mnt5d3jVsznxSQoZSDzW2JSRYVACLWlVQc6VaPKeiz7PbbZSSybKHWZd3kO+8K6GBjRNW5IcWft1NvLX4XSU4bXvaq1lFajCjBgHprXUuy0Hh74N2tKlbsHwANyQUtj47daNpc/1qkwV5dJs+Vxe63K7aO8kVSww/5tw8SW0NMdtq6ARRagpnlSvBtdMMS813gJHub314in7oVXdKDxUnr7I66R2WeYR1DsFs4XkDj4CIWe3Gkk3uKZGPeoPUcQqf4Go7v0nXW14lYl5hQUS+bzyrhFg4mqq3vzVtg15Whlm8S93HqyTgShuyWzPGqp15zFkA0UdUSlb4gd7KWprp9iIKekwyab8TrqpF9j3Dqgl6596PrS8xgC6vLKz8w07Ypx21dgvRYAwdYOnyW/PfrMjo6KUDrgHcaM9GoTJfcrxEreq2P5ak5/cmDYDVLcKpPt2VAl3mkat31ilC5pVwD2N+FHIFmEAHdvjgOwg1Dg4Yn7MpqDXX+GTVBLZgCXXuMxJ/iGG1nadxDwWXlBGH8kmryMgyM0KFHa4Ss15n7nTxRnMR1bmU69Lb4L8NKZ2fob+rx31f5Kz2VSXXddbJCSnnWQmZQPudCvvNQgEwIYujqcLkY3iNKffQGvW8zIBJ74e0P0moAAyImD9uCXbbXDp+e6YUrkYsUgY7msL1r3MT9M2/2FPS3vTYrN9298lj8ZJXbSnyrzgOUFJ/0PxP0GQ5fXws0ZpabUtwEE+bevW5boYuLKuzt1K0JqqqLt6BDGwz41N4CXXhg0osAwCIm
 hJHrjaaw
 nTO4pW94/R2z7yjxHKnRiT7yc0OS07dWyjxS6zLnrDS+hCybZI8faRsp9ghN2fSqDefEC4EbkSwW3fvKgtATyAXtuLXLLRugGmYqvYg+m4Xv1hx3gk63fQVGG3yKqKCHjiho6HEuE/aUHmtBEwxTYPDBi5Gl5NbPoCjEgzI1Po2WH5FWwZXSDDPUsmYJ/WahunQuHCx3W7tUABgPS8WkfTTZDvNVXQIK/1s+XjdvZGXUURtjQkNdRTPOa74tgMqW7bLz/CB+UhI8hkS854eKzDzpcJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_prcl_start() callers assume it will clean up resources when
it fails.  And the function does the cleanup for context buildup
failures.  However, it is not doing the cleanup for damon_start()
failure.  As a result, when damon_start() fails, it leaks the memory for
DAMON context.  Free the context in case of the failure to fix the
issues.

Note that the issue can reliably be reproduced because the module calls
damon_start() in the exclusive mode.  For example,

    $ sudo damo start
    $ echo $$ | sudo tee /sys/module/damon_sample_prcl/parameters/target_pid
    $ echo Y | sudo tee /sys/module/damon_sample_prcl/parameters/enabled
    $ sudo cat /proc/allocinfo | grep damon_new_ctx

Because the first command is running another DAMON instance, the third
command fails the damon_start() call because the new DAMON instance
cannot exclusively run.  And without this fix, by repeating the third
and the fourth commands above, we can show the memory consumption is
only increasing due to the leaks.  It requires the sudo permission
though.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260609145814.70163-1-sj@kernel.org

Fixes: 2aca254620a8 ("samples/damon: introduce a skeleton of a smaple DAMON module for proactive reclamation")
Cc: <stable@vger.kernel.org> # 6.14.x
Reviewed-by: Zenghui Yu <zenghui.yu@linux.dev>
Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/prcl.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index b7c50f2656ce7..0db2598946911 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -106,8 +106,10 @@ static int damon_sample_prcl_start(void)
 	damon_set_schemes(ctx, &scheme, 1);
 
 	err = damon_start(&ctx, 1, true);
-	if (err)
+	if (err) {
+		damon_destroy_ctx(ctx);
 		return err;
+	}
 
 	repeat_call_control.data = ctx;
 	return damon_call(ctx, &repeat_call_control);
-- 
2.47.3

