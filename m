Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3C8D44C63
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D866B00A6; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C396B009F; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA226B009F; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 57DBA6B00A4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:20:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 181E15889A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:56 +0000 (UTC)
X-FDA: 84334560912.26.4486FDF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5715A1C000D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:20:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qioR1czQ;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SP0Gla8/uZ4ZMGzsFBb7TuEms4WldjT1c5jk72fI29U=;
	b=UU4QZ+tNlUPQVpZLfwufn0XxRamGiBHEQRA0rMxSYo92DiUX7vyC7XBzMD6TvEDukHiyHV
	QvFUdIsqJIRPPk3fe2q8W5+pi07vA0oubRj8nUd5FVRbbLtDKTM5mXQHVgqoAajfSwW+/D
	PJnMRXhXpopeWOo0LOfcvgCVSJ+AuME=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qioR1czQ;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490454; a=rsa-sha256;
	cv=none;
	b=kaGvK6xkQ/3y7Kg5XizlCxHfmMRrC8V62XLiN9l6l9kPyP3I6ukN1mE88Q46iUm/ty9srT
	G47qAg0NQxs1d2zAtR9DYFy0ay735daXv7YnvTWs05CqIuQj+znydvnGPXEx5pKUXtVkR3
	HUGD1isWwyi9g3Vm4Jk3geolWVgqqXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90E5B43B51;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F168C19424;
	Thu, 15 Jan 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768490453;
	bh=liYSv1rqSeh/1ly0K+dN0fc398iVzhoj5D1pp/K03Sg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qioR1czQGcX9c+h+SaZCzzuecJqpv1iUe+Wy1oY/3VxML1KS5V64I7t1eBLplWkjS
	 u4BJU5jaHEnsSTAZEW8SnOxVc/e6opmGtxW1UHgLGVRc56yRbftnVNia8L/YWBY5nA
	 6HNrsUTAIXr6QamBRrt6lItmuXz5pwMUGPvNW7ZFnKGv+B2QZS/B5ZFJWMjPsPjvhw
	 LZkMecpkIRQSrQkpqztZo3CKInSFGkq0DqihmnRf4CtnNjwWewvlKQJxpNPPPNouGc
	 UyyA8w4JvdPwIeDO2H86MjVcP96JzKSLIKv+f3SzwPndD6pKItG0I0Y3dwwOpjaO1o
	 N9D2L714mndNg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] mm/damon/lru_sort: use damon_kdamond_pid()
Date: Thu, 15 Jan 2026 07:20:43 -0800
Message-ID: <20260115152047.68415-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115152047.68415-1-sj@kernel.org>
References: <20260115152047.68415-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9f1mr4sdzuyn9w6wk954k4m3p114gf4t
X-Rspam-User: 
X-Rspamd-Queue-Id: 5715A1C000D
X-Rspamd-Server: rspam08
X-HE-Tag: 1768490454-799237
X-HE-Meta: U2FsdGVkX1/F/z/+SH7knWnlB31WVbsixJn+GhGQ0saV/w5vBN0QK/HFpW9ZFMR64IAW+kvpJE2t8rNv4jMZqDgct6B0irai0C18kLDV7G//9MMwfv8W7LjtGKARYkaOZYDDfv3d/6VZNhRe1odvXsRiKN2WppTIISKmGIr7vtW7cIGMnUjDC77MoG/8reXhrfnqU8Sg0rZz1+GYkp65eBtpzSjmseh7ZSlZc1q9GMq2ikHM3j7Cn7kOjDRLmvuOAOH/O5E8yJ68vCyUscJt3zo9IXr7+tWEZ2QMwn3Tgz3Ha/DDfimXtN2gAjnG+VWu1dBzmWvwT6ani73XPOY4Oc5yKQf6n2s9QxGYk2ifIqfwzsO+D2LAuG12ozBRrUyuj1EYozIiejZu2zdzdkhA79dIx2n58IHWkL910EcyeIDMQI5nLIZfLq8LyC3j4VEYrxSM9lrdnK+3aaxxJjBDjDtLEdH8LkfyX01p3T31BgPhrfh54Ur+duO4kjrPwRsMBDy+wjlsWy/LuxH9nsXWUoBOTXCc1Ac9tDjK2jQcBljF0x4biA7fDGdCCJPA1h9tS2t8d0Tb2fg8wx7Mkx2sTOS433r1PW/pEYrUeO+Q1cNzUWyECCoivTT6HDkP5IMp/S2hq9SMIUKg9ZeOOQHaSayXMv2XhKssOIA3aawOE5mOcChHCVLVm+TPx+qrOdCnBHHSDDASp4/KNH+51/LKQkVU0XEMpB/ong52i15No5NBzpDkjNBhVLhfBCwlESp4dzyerIuxvAOzDYMSQLHsj3H3URBmmT08QE0v3Jz/EkElBZRjJ32S0J5XrFiTfnoGI8H7SMs49zQ1Gj88BWtS/6oEHQLCQhv5eXXZlf+YhAlKBUGhfzn/0PE7gl274iwX7dkc1ttLBfy901Y1tcx0i8WprBbBG1Sl0hstYdLdX1nPXhZaV33rHFXlEOOc+isnXt1TUhZcYKc/xt+OKIG
 r1tov05u
 LdTaweMg+Xkytb2bFmdd5NMYuo35Ics50wDkCI6QEIBWBtIg+x7Hmki43c0qpvChFdI+Nesg3oWFyft3Kp1zTNEmru7491eCP2BWmtVyNJEt81lX5GF0W3Kyr9rRrrCAMgU74qyWtJGRAVGM3tymfwE2cGwjZBfsFOinGLkIIB/YhYFGBhkS/sAnlQgvOPe7giSws6GBitQ7n4b+6EnAiUjaT+Xq48p67CNOy58++OTHEf+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT directly uses damon_ctx->kdamond field with manual
synchronization using damon_ctx->kdamond_lock, to get the pid of the
kdamond.  Use a new dedicated function for the purpose, namely
damon_kdamond_pid(), since that doesn't require manual and error-prone
synchronization.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 8296f984b428..bedb9134d286 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -405,7 +405,9 @@ static int damon_lru_sort_turn(bool on)
 	err = damon_start(&ctx, 1, true);
 	if (err)
 		return err;
-	kdamond_pid = ctx->kdamond->pid;
+	kdamond_pid = damon_kdamond_pid(ctx);
+	if (kdamond_pid < 0)
+		return kdamond_pid;
 	return damon_call(ctx, &call_control);
 }
 
-- 
2.47.3

