Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFC3C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 13:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94D756B017F; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D69B6B0182; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 813EF6B0183; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 467A96B017F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 09:13:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19C77A0451
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:39 +0000 (UTC)
X-FDA: 85165235358.27.DB969D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7EC9E14000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuII0p++;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788268417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YLJtgrH/eA5cfD1d64StUX4ou+TBBQRag4ZJY9MXlY0=;
	b=GMRo7MDfvy50lupRE2wMG7Wd4OkGGVzI2x8Ho16CmayMjYKG37Vtf5PppnI6JfyTy8k1p+
	jfgKD0jp1fQOYk3bGuLgd5DcZG+W5xK+NnVohRvC2MDOUMvAWZ4JpNMGcwUaZ7MyiqNTwq
	VeBWoXbw3SDODU3cqBwVQvMz0dIQZOY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788268417;
	b=cdRL/yBosDnBPu3CWWXWkj/ttvTUH53ZNe4AJvabxiA0CsKQ3s07gRql3y/F05gp33O2zF
	eLGhbLR/ygBcZfXK7DKoEBQ5qrOcIV2qNIf38vsjmKTuPjBPk3MNiVycRz2UPP6FCHvqis
	vDBfD0zj8TOY0x2jlLMP6Y+BUp+8/LE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BuII0p++;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 18FDE60213;
	Tue,  1 Sep 2026 13:13:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D331F000E9;
	Tue,  1 Sep 2026 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788268416;
	bh=YLJtgrH/eA5cfD1d64StUX4ou+TBBQRag4ZJY9MXlY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BuII0p++NSivesuV41kQLUZ8NvVu65lJ1q0Po85tU2T2wrCHHnSCAip4Mc7mNtJ8U
	 mSu+1g/nC+ZndK2iZqieVTsVDOIysZt3y48irQsnaeHM04LP35H5p3XbD17eecxuoJ
	 e8JzG78Btt/C6QsIAMOjflxrNSpcuYr8bgnGwcGFyM4XSprpMtQZN8Nvyylhak30nC
	 u/NtYZ2ALhqH9V89sXl72O1jaIehbk9AZHp8YPKR4Tq9vm0ZjhxpwOkmBLmYnV53q/
	 CgdNTDi6YbwVVNH2Ydqww6DAt3MVJX9BudXurVUvWcR2atT5G1mo0Lx/7/jMO9aMfK
	 QfOGNe97ZAlfw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/7] mm/damon/core: handle extreme memory state in damon_get_node_mem_bp()
Date: Tue,  1 Sep 2026 06:13:22 -0700
Message-ID: <20260901131326.97615-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901131326.97615-1-sj@kernel.org>
References: <20260901131326.97615-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7EC9E14000E
X-Stat-Signature: 1zxcf8baic8rxybjpktk44sgyzx7fkqg
X-Rspam-User: 
X-HE-Tag: 1788268417-768752
X-HE-Meta: U2FsdGVkX1+dP2SWBG8AttoXS+MrapGyfBsvt7lq5EBYVJRgsd4V7kO9Pj0OQ0nqgrDUYowg4vzy1vZS2E8okpilybmGHclbxiR0DXX5hsM3AYfp1k786ZUlf60oWLOIZJfjBCa3N2p1EKO0Nh5bzZjz+k/aJ5qlaiKI/SDBkRSEPkf+nqPyz1vjt7SEMw5OUP8+U8umVSPc4Pa1LtZGDjwY/THXarp+P2DzvHDa1oAW2hsoMSm3Aa9Jt5yT8hbzy1GG5cPsiiKTZ4gN6RkI8BPbd0pLX07aYxpnfKm76e7LTY2AR0iqsAt4AOPZhP6vbLlFm+iy7I/mPOhzn+zxmXuBivDW2d9Kwv6/Bb6UMbWwodGeFVYxb4qwBZZRHs+pzcQ2pgNYb2rWuhOXnVb+UIbPSpfCUjErC/Yd+avj41TQirWbY7zw8PhEAAgd7flTo55dB2GhmfJeU++vmBe1qLe5Mfab9BxPN3Upxbn/Yzv/iRVU5AFIwKDONGPX1q9Z9aAUP2QWoVeufYWJ1yTyD944mREetDT99ldFlAGeZvXlWzlJIoExaVBBKXFspJf/5aqldu7+n5COy/E7EeQPuyVVjXn+RXq+woPAUdy7A5ZoLAu2/b2FdHNrbuEOl5QdodYWrJSdwOw/jFS1znDzfsPfu7PgPptDv5ygQT4Ch45WcUWsW66RmOQ/Oqk80OoyJVTUd/zMu/ab5NvrsPz9UwOj283GLRxTELfbwAQMWyGUkjBGEPykdVmXA4Uu0AF8mxT7qgGOd2YV7zNlU6pBRRWa5UEIU5eWvxvQmNmDEeQox2BALYyp9ZMDfW+oJrKApkfVmF3s9EDlgPsugi3vZmmQqdcVceBKUmGfb5mk/6xh8K3J6LDTYny4Smy3e1ZBo39wfVEMMOfOYbsqfUw3oldbrizSnQxtK5T913dt+BjLGgUDi4kYydtoX/WaB6NbFnUoXrinFA74Y+tp5dM
 4kD1WKBU
 fqb+jae+sSOGUlgRHFvBpmd6iSYuDYgU+UYwTRWKuLpdp/iUjjEVBxxPp9qnxH5aT8ozK4cpQHjcjzjM6A5IuxLSspl3EKilV2wLT+hb8PTqE1kKD4cxjEFPGQFXG9BkFwAf0hQM9X3LE/l5wUP2UDh37x99yexpoqgNscs+Xbkmk1YeCyUCWwEyL6MsOQ9tiAYx8gkhhRqI6fqwMBs/i88125weibmB6MB01+/Npobs39oDwg55shlK7HAh3k6uyHXoG4OGmyBTEVy85Uwgr8NYOtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In an extreme and unlikely situation, si_meminfo_node() might let the
caller show zero total ram.  That could cause a divide by zero in
damon_get_node_mem_bp().  It could also show free memory larger than the
total memory.  This could cause underflow and make DAMOS temporarily
make unexpected behavior.  Thanks to safety guards in the auto-tuning
feedback loop, that should not be a real problem, though.  Fix the
problems by respectively returning 100% and 0% for used and free memory
queries in the corner cases.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260328133216.9697-1-sj@kernel.org

Fixes: 0e1c773b501f ("mm/damon/core: introduce damos quota goal metrics for memory node utilization")
Cc: <stable@vger.kernel.org> # 6.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index a6fdb3068262d..ad3657d356fbc 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2807,6 +2807,13 @@ static __kernel_ulong_t damos_get_node_mem_bp(
 	}
 
 	si_meminfo_node(&i, goal->nid);
+	if (!i.totalram || i.totalram < i.freeram) {
+		if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
+			return 10000;
+		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
+			return 0;
+	}
+
 	if (goal->metric == DAMOS_QUOTA_NODE_MEM_USED_BP)
 		numerator = i.totalram - i.freeram;
 	else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */
-- 
2.47.3

