Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F831C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD47C6B00E1; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B856E6B00E2; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC2136B00E3; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 697506B00E1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:36:01 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C348080395
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:36:00 +0000 (UTC)
X-FDA: 84987631680.28.9FA7978
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2068814000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2Rciwt8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nx5e31jEsyo+C5Jzh5WXWtwiWc9v5lBvS+tYDZCZe5U=;
	b=jYAmAAjKLif0AbfxPx6LLyWI74/+/t3pJc7/lpCnNczENnCUpQgpF3jDFw2d5WtTA98T5a
	MIKogS62Tfnr9jvKa2/2dr3kOFqqbUrIFSHDQ/7kknzPcpZRFHv8PF/YyXdpdRPG7WLDpn
	rZIGLQgWZQxOFN21TmyG+ItA4s5VmFI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X2Rciwt8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039759;
	b=YdOfH/Z48Y0HIQrSKX+RU/fo0CdPYH3JZuGdzuBMIf1pvI8CP4Z7uqmwPQoIUrr+pyXrdg
	6haxvYrkZYGNregfATpVbZ3/CUV3mS5Tp78zPGw9v1eFP2KQpWloghWDcJp/zW2kNmOG+n
	bEcYv7BQ233vN7qzcOBBLKMAXxC6OJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 74E7A43552;
	Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314151F000E9;
	Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039758;
	bh=Nx5e31jEsyo+C5Jzh5WXWtwiWc9v5lBvS+tYDZCZe5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X2Rciwt8/MTshxbMH0LSsW0OR5pxu4vbJGl88cl2PRUro+DUfPRKEYh7Vts9El31w
	 X8TbZ54j1otU/V0hjiojVpRFfLpBdszW/YtCED1ora5wJIx0lxLqL6Ow4CxGQO20ii
	 Mg6CyV3lXbGzoHAtXfHrB7lfOF5QnBFUR2EzQdWm8ibl7qgdvMRcayZiM42ol8lb62
	 7WGvox44qnx8rpsLk0YKFfM9TlYfXSd5ZJrZA/D3cgcMwkpTfLBYx3eR1FOKXxOmWr
	 Uv5+KueXbDIJ7Hlf4Fc5vreeym9sZajj3btVddDyt3mBHllF50x6qphpx/fDSexBOf
	 Lui7jPMAJhntg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/10] mm/damon/core: hide core-private damon_ctx fields
Date: Tue, 14 Jul 2026 07:35:43 -0700
Message-ID: <20260714143544.101305-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2068814000B
X-Stat-Signature: g5q7t8skff1obwjsj9trxd7h7hh4tnbi
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784039758-843327
X-HE-Meta: U2FsdGVkX1854LmW38tTDfC320ph/XnEOpvfTJIGc21ipDyo4YVb71YrUrpSWEHYs64HY8wBDVpvHE6zNwtP0QmtQcPEmmncl31sSUYJf/aVKCLi0W3cYre3QyBwRN/2+CUiRfaMCXvPMT0n6Nd5Fcr7KzUIRqAJoUU1OYbciKGuGWKDgy1ockfSdPlaOO+7I2T0rdDs3ahSnjbamne4nAn4TLF9yKappqJIooyvZHX2ejEypLpx4oGiAugkn7Q4VkbN5KOCVeFs6fi8q39Ly19ni2IAT0JGBN0j+Qnm3yy9VOACaeGLBSQzbBDWHCrmyxOtqzspmXl2Qy7g81t/NptC/yWZHdT+s35suRBs7qdKjS8DeZ6qmwTjmwgz4Di/yFbH1GXiZQFsKGEKHrYuFMvnYe/70Rut0292l0hhzwTCw3OZrHYFXFYnOLIu1/dzsHkq6JXntq21/Dw7gx52Qa72o96/hkF630ANLS2MGsCaJU7RLySHSUI8SRkjDRlGvPaVGyjLL//m4QBlb20vYsEwPAk8N2QDbjiqQhnzUX0M74CmVt4lK97UfukvN+oWanncjfazTyHsYPQAmVJwYkVA0HPjzexHJO2tXTaqKNiEu1+YdS/kSlpluns8ZOvJ8POsrNJfWQNwEZnQZngwQ3uQ2XhEZzQVUJUdnM3ruYHVqlY8R/0cyvyzbged4eF8mp4Ye2KdSrOQF9PB5GUK3Ehs9gc57cFhnLgcumeO94MTRH05HKKWIzHSClvr6c97Ekl8NYyxNgIkw7TNS/VIBMVihbtfJec53Jw6vqIfmcRcgfMg9UifEMLfgAX0vsbRIi0dcyW3qlZeallfO+JwV62IYUykatI0XhhkmVLl88DTo4ia8f9xkJsMfi9X3NHjZBqFJ4yspT4b5t097uPWdzRlJkOY0rlY3gathVBXmmi92YFmICgHzhgnJA4mrfYTy+9PyNDAzK7vSCUorKb
 HZJSAB/q
 lPIf8PvMejQftN2zJcCmWxSrWBlhplv+6sPNK5DR2X9AvDn9xsvhgN1JXh/CjK0yUpThXvCYCtHKYN24BlyqSqmOrI2JyreT4ZDC7PAHJlK+aLvAFt8kG2uNSXz7u1/ccZyIOFCqwHLqTFZEY3se74vVdBC65usLElNUbpSvlWS8fVfxX5EeYFOZtnyImE2HIqvV5UeUdozNPtIzJER9mGvWvaW/I7Gx8A9xDn04PhM0TnIYWFVNeWnXiwRIgvusFPIlOgEZT4QP+pSbZW9Fs3u7oig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'ops', 'probes', 'adaptive_targets', 'schemes', and 'rnd_state' fields
of damon_ctx are intended to be used by only the DAMON core layer.
However, those are mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 537e59bfd7072..327f534696aa8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -848,14 +848,9 @@ struct damon_attrs {
  * thread other than the kdamond should be made using safe DAMON APIs,
  * including damon_call() and damos_walk().
  *
- * @ops:	Set of monitoring operations for given use cases.
- * @probes:	Head of probes (&damon_probe) list.
  * @addr_unit:	Scale factor for core to ops address conversion.
  * @min_region_sz:	Minimum region size.
  * @pause:	Pause kdamond main loop.
- * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
- * @schemes:		Head of schemes (&damos) list.
- * @rnd_state:	Per-ctx PRNG state for damon_rand().
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -904,15 +899,21 @@ struct damon_ctx {
 	struct mutex kdamond_lock;
 
 /* public: */
-	struct damon_operations ops;
-	struct list_head probes;
 	unsigned long addr_unit;
 	unsigned long min_region_sz;
 	bool pause;
 
+/* private: */
+	/* Set of monitoring operations for given use cases. */
+	struct damon_operations ops;
+	/* Head of monitoring targets (&damon_target) list. */
 	struct list_head adaptive_targets;
+	/* Head of probes (&damon_probe) list. */
+	struct list_head probes;
+	/* Head of schemes (&damos) list. */
 	struct list_head schemes;
 
+	/* @rnd_state:	Per-ctx PRNG state for damon_rand(). */
 	struct rnd_state rnd_state;
 };
 
-- 
2.47.3

