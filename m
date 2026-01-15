Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198ADD44C63
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DEB6B00A3; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A4E6B00A6; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FD7F6B00A5; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 499F56B00A3
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08E14C1ABE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:56 +0000 (UTC)
X-FDA: 84334560912.01.549DC37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6963EC0004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Tl7/Br9r";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i304hdkVO538Z1Lph1VdG6OeHCzyChMPuMy1ohXF3C4=;
	b=mrYK15vp3KXlzqSVJPnOyo9s9c1b9mypoVSTyf3caMYVrAQZYFOIYemHieEpQrXsTqX9Xg
	hsD5lbMcW61irS++ngM7q7fE1cawPXopw6SVEY5DqQ3B1cEK3Pjj679KH7LNR0yrb5rhLe
	Luylo1FZbozSJ25PBHar5Bz5agz5Rx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490454; a=rsa-sha256;
	cv=none;
	b=t0BtlnnJp0+zyvHYbLBK1K/WL/WElKQ0LgpY3ikIUQSzahXK+IhnCJcx/y9Ofy8/+hBnuu
	JfHHcN7CoY9ctAsHDx0558UDXIv9naBLrDVFBMAWpGm5d3gOwIKtfvalWt0qbCGiEdsp/S
	0Lqf0lBRMUJb0K5hmvNN9cx+PEfLX7o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Tl7/Br9r";
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F5BF4003B;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B109C19422;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768490453;
	bh=DxQCMUOdwfVtYBKudfkzYSOHXwwjcEpLd/GD9gGY3VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tl7/Br9r01iHEBaBIVHmGqZfuDwsnmz2afTYicmtxxNa6k0nRAINIxKRTLmbWaM5y
	 9EqRpg1QaEuJ3LknjWRWIDGuBnb9s25158SuDmf0xp9UMsYXVnkdVTnilrFX04FrcE
	 sUQYP0cjKX/eKWotlEEoUN+waZuyjJAVdVW/h6OWPtrA3VCGtisK57ioKaSj46kDvF
	 Y8hxeR4ciM6fHhCQhU3TpBPiiSY0cbPoo7fP5OauL48vG2q/hv8ydG4gemfK526eSA
	 BhgV7kKdlnonPzxIVsYFu2kNWfnIjZcq4SHPDLzP5YLJs9daMS5eVmbpez6QkYgj7p
	 xZankSgOwoVmQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/5] mm/damon/sysfs: use damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:42 -0800
Message-ID: <20260115152047.68415-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115152047.68415-1-sj@kernel.org>
References: <20260115152047.68415-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6963EC0004
X-Rspam-User: 
X-Stat-Signature: 4dtqqcitsf3mb58pgkh5jadbp1i3ojqj
X-HE-Tag: 1768490454-189732
X-HE-Meta: U2FsdGVkX18ntAj+n5Wxpb+8Wi3SEnLNRjMQsXGMhKXjiAfQL8Q/pgNCm/L62sjt7rCMQmCGm69kvcgqRluWVu4I30gddQ6z8H6FJxU8gnroFUhCrOWF3Lz4cSZw6DqpHS635bNbQgH6aEvHJdoPGQGfXzasIWeCn442eK7srOR2QNxvV4bTIa5PFaZmDbE0aYfvmoyNpMNhE9ZLYT1ZEA3zQTWoL2dIASs5NqD2y9piGP6/1Kx+qRuJbSSpDCZ7qwqDl2W+7VPH1VeskrZG+HmP3svxYBjxZVmZzS427cyQHXy2I0PJoKo9BbcJSid6n6ImtxHYVQtRZdOi2wg7YKDyJeA1MfkCJZfIoRGLwjyd/lRnFLZLru1CBDW5BSP6ljxf+JZ2H16w/A8ZbeS+6m1Qt2ThvRmdpG5bhTV0OsqQWCquXbKDWVTky+xnL0FSsuYNhGNcHm9vA8Uh4K/+AXzjcM5sjRIcudx4SRAlj8mmOM3gjnWcnfPAaG8/YbbzvnGuUBLRU7bKiibIvWQoMxvGY3IwDkEIdd7Gf31BKfew1cP40XLwPO5LJ8pvQgWdUSlPS4lDISaJbLeaMaCdZY4mvO1aZgmOSmsOI4jFjSgx79dSpdnkiCZKqwCndsbSAYshR8aig13KNBcR3nb/V4XawCwJ0QtrZgB/VEQRp783P0o4JtdYLgJAMfPCsJhjjQuXiZ/KEc7U09Hecxc5Gjzn+HtaOkb/JJUc37vqXhE/JqDsWCA4jmxusT44UqmpSFb8Xd7etj1LxI4aI5IeQ0DcK0c7HsQCJmeKwxclomG8dpafIrOCGi72RWCf1wT7J3iiY+sbZ5q4XGCy8o2V+d341zG4DpieALqwOEPwhCpueaUO9+Bqn9l/eAO1lE6sDNodvAQQWKQ9NcIpzkjGK1M6BgtqSoC00u0TmQvnbI2qsr9rt6SI80j7RF7AQTykjfocDzN2uotdJGp8as9
 OKbHwOux
 Y8DPmnw1M6mnf/0UN8PM8dX2//iEm50fniDRkIovcGFkzBQKxfDKFkjS3pDvDlc7tKLQTSudzuut5nQS4FlIVd14l3Uv7z67lC04wMGSdwfLZ7IbDFNQ453CkI2tlOBPkbYfPeEd/692O0L0yC76wMVVqmJhq5Znrxwxkot8q13So2z6z07DezV5UxktP345vt2rvZL8ySC515UZswsadNtRlbJ4XtG82MP1a3ayQS1IIGy02lTIxBz7ySqDjys/xi33OjHcf76YCsjF6RdkHclYfFmvgP/6ymiNAXueQ4w6IvZ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface directly uses damon_ctx->kdamond field with manual
synchronization using damon_ctx->kdamond_lock, to get the pid of the
kdamond.  Use a new dedicated function for the purpose, namely
damon_kdamond_pid(), since that doesn't require manual and error-prone
synchronization.

Avoid use of kdamond_lock outside of the core.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 95fd9375a7d8..4de25708b05a 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1819,10 +1819,9 @@ static ssize_t pid_show(struct kobject *kobj,
 	if (!ctx)
 		goto out;
 
-	mutex_lock(&ctx->kdamond_lock);
-	if (ctx->kdamond)
-		pid = ctx->kdamond->pid;
-	mutex_unlock(&ctx->kdamond_lock);
+	pid = damon_kdamond_pid(ctx);
+	if (pid < 0)
+		pid = -1;
 out:
 	mutex_unlock(&damon_sysfs_lock);
 	return sysfs_emit(buf, "%d\n", pid);
-- 
2.47.3

