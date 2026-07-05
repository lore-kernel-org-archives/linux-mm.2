Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94111C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 16:02:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69336B00AA; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FCA6B00B2; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D552A6B00B4; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A75C86B00AA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 12:01:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18F60C047F
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:55 +0000 (UTC)
X-FDA: 84955188990.14.57457C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 77880A000B
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h74txumM;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783267313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D62Tcr+yrJC0pq2paze4YieMWP4BsC6k5oHO7N7uukw=;
	b=TwYIA6hJ9ZhnftA5EgvcuRaSDRMGJFURmQ/jgEyinCKvm5xPaFupRURLiTg3BlsNo5v78s
	2fsidwfu4Qi0UC7VwrGR3y8ZDPjIjTBgSF3So2+hyiy02mqlcMEZlyxAgp9ivCB+2FaFNI
	fnvTgDT3aFy52EIXvy/8sFQD5XcpTs8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h74txumM;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783267313;
	b=Z8825m05eJQmjo09oa8FRcVX2fZZumFUGMkBbjIT9ljfr21i7q1bvhDC1Rf/chNOrT5dzC
	smDL/oADCEXzXoPfeKTbeAhLO97Qq0DVE4FpAA+qpdRmqJSt68zQrB8KNAR3Ow3lx8PRCJ
	YIXvzsj5wlS4D7ROaF0bzvKx/RViE7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1637F61389
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5ED1F00A3A;
	Sun,  5 Jul 2026 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783267312;
	bh=D62Tcr+yrJC0pq2paze4YieMWP4BsC6k5oHO7N7uukw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h74txumMZpI38qJ+8ds0UgfG76kuq4dBZvZsG8oRgWixjR2ioLpnk9v+4nwkRD6/u
	 Xz/1eZvdTrwXEp4IMCyTg+Ggi1TtktKm8ks1QKoC9z991+u0bmNKeUBV4H9899SevI
	 AvbqFRnI03L6MGvKzOOwd+oGm8Wl8BzFMqwDcAsJsGL1EmfNaZAlib9Jb6ss9RQc9Z
	 4jgwI3zptmWQHxcDStl4E6VnC8qxhFVemG0rk/VVMHifvZPrtr/7NMoWTn8LmwJZD2
	 fNC4kU9jX8zspaQJ5CiwwClmIXnyRx2e/jwfzE7t2PZNPW9Bfsh/hug1pgWx/QR4ue
	 BJOlbYx5UQPLg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 02/11] samples/damon/mtier: do not stop first context for damon_start() failure
Date: Sun,  5 Jul 2026 09:01:29 -0700
Message-ID: <20260705160142.97308-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705160142.97308-1-sj@kernel.org>
References: <20260705160142.97308-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 77880A000B
X-Stat-Signature: u6iqkdtppyzxxsn74ws8mmmjnf9ec1fi
X-HE-Tag: 1783267313-235718
X-HE-Meta: U2FsdGVkX19uqS3MrrcPLDDc60N/fduyjgumFPaAM9F8/ou49wrfOj9XlxQLCwBL5nSVUctAW3RupxEivWh+R/2NfrwEYXmZpK5s+Bi66V2tVmCPoqOIeHZaA0GhxE0uPUDgX7BrFhECeXFhzFqTMXh88vVevqnw3+uXamVyzvo4+6VJ2BK4ewhmsErIYK49RbwUbhmnP9g7wjAXMg+nhJ+kvZzaBbSUu6kFg+h2lfyLOZMbWfrK1LP40pAZLN1fLT+VnM3cxZxGUQjohDLwf+HiC/kM3u9QcQRuuOKoKdm5fU6BMx+/xCALPTX3o+0sMyU+Gsn5Q47liqRxAEYKREgigKWoyqq9mguh39vtSTyy8glTJpSqWV+5fhz1oFMmHHzcnQFQ4jHpsWZ0EMNvQpzfR0ajAwJ3T1qdWDAK/vpqCLSsGcDkxL7Pb1mvrf1A5PII1EsmyhQdoj2OycQDbcxlB2HkDbebHX/D3P7n1hsp4flGsDbxtnipW1k4HLbusrYQgiGMEYSxf3T+tqQqyFb9wFj/mEAz8VpZFXRw3Iu1kbbjYPTxhtZeJ2rcMiEknMZqzdlR7FLctoPLm0awuQt7y/vR62wKtw645aHITMzy9yzK204Rno03/F8W/prtPnyr3bOT5ibQNnprjUN60YjASQve2P0X7Ykrwg1y+ebI0J7r8ygqc3ihpKJh2iZqZeyODdvZkNWT4vNaO/f/gGiGcZL3hVb8TBkwjM8GUy5KCot+IZJYPgmKVNTi3/6n4qfH5spS56SxhULd3JLsLV5cKN6tQutKx3aVaA7llkF3zxAV2Qd0E0wc3xxOVnFHHdXtwafmoEtVqKYFtgb+e3m3tIKLPoNVfOJg6/IepfQMyr09bbW0BqK7+qca0Dfh4p045KZ3F3amBO/yc1ioeZKKLYYo2sxj+GvHwx92yHGgS10he21NYKNEy+unif6m+MTRPkUf4xMTkutzmC9
 Md4VcRPs
 79ONYg1qrcXUBadiX9/sT5NHhc7axVVdgvNXJ5Xqd3zHKGpjaI/hijF/J8giBXk7usLCASklHO8o7qcK4jlDJPQ0V19sUr8D5ChtzcoM70OIxdG9tTDfTC9aHUOoOUdSpeiC/ygNcNgMePvJiQ9zwf3UruFEx1NUTpkfpIKDpqPWzumkcSSW6HR78YhjkdDJ6Sa+4iZTXVv35n617vnErae+OTzClL2g5P2cziK2oriCiQ/HuPqYdNCxtzr9F73K91mLdO8f7bEMV1U11jEkKIHorqr57Ln9/z9CSht5grAaFErEolLIDbbJI3JCa0K5uP//imPK6nI2wSiYYDHWguDcw131TGnYEPYf/3SemyEJWzkvJ8ECn8QsaqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_start() was able to fail while keeping the first context running.
mtier hence stops the first context in the case.  damon_start() is
refactored to avoid that.  The error handling is no longer necessary.
Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 samples/damon/mtier.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index e567f4edd80ea..90881e8bd441f 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -193,8 +193,6 @@ static int damon_sample_mtier_start(void)
 	if (!err)
 		return 0;
 
-	if (damon_is_running(ctxs[0]))
-		damon_stop(ctxs, 1);
 	damon_destroy_ctx(ctxs[0]);
 	damon_destroy_ctx(ctxs[1]);
 	return err;
-- 
2.47.3

