Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E1ACCD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05E446B008A; Thu, 28 May 2026 02:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F023E6B008C; Thu, 28 May 2026 02:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F946B0092; Thu, 28 May 2026 02:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D578F6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:11:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 944B5161E06
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:11:18 +0000 (UTC)
X-FDA: 84815806236.28.F1C370D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B2BB100008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:11:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gs27dfN2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779948677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uMRK9tYWaXpNpaEqAhpqFf64f/zJybxf3IUBnmYDVU=;
	b=r3G/y3TSA6oH/YUoKDprBBiY+PbgUwC3OcCyXpRTV1nK3KnUZ8b694327B04Q0dvdJl8vB
	gvXm+LirMpUq2cmF2HV4gxy1vPjvI2ZXRkKMjOMe0K3HtKJWDcNnHJA1Z3Ckc2FTbElZ6w
	pi7CcUKFon93I6pZxMZnuQI5TJY8cCc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gs27dfN2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779948677; a=rsa-sha256;
	cv=none;
	b=bZ/AvQvEICh/WkPIFYEXkMWkExOL6wSh3mIWT4J58f5xh0l8OIitsQG/5rligiG238Yw1t
	6+SDruWoH5QWy1BWzaPN54byh0Bzc2jiJNyyLzrvXygrREH6ZS49M3rwCFSzGfpMNd3peH
	yyRY6rGELT03vdPzZMog52yP0+OQxsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A24DE60126;
	Thu, 28 May 2026 06:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F243F1F00A3D;
	Thu, 28 May 2026 06:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779948676;
	bh=8uMRK9tYWaXpNpaEqAhpqFf64f/zJybxf3IUBnmYDVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gs27dfN21CiTt+PgfYYZx9Ka1+VQ/7yaR6M6MNvCNPmtci4NRpxu14XTw3/d6dYs8
	 HFT34C/cmGeM5zLSGKmCyKoNDf9qUp9MA5JfQzDpzty6SXc6Pdu34ueDpxBAk0eT4f
	 46AfpjGYpBbuTw+AH3bu+iq8U/gX+MTdrqaBZymNyp4B8elHWRedu65GC3IkBxXUD4
	 x4Jhfs24++lnYUzLNNgscL5bquYsiFBNDyzl4gtgVLtgwLgWxRHgM9ZTYQsTPgJwNZ
	 C2GBpnYGRRkGc+3at035kkfF0rrq+nW+RJ3AluHwrcnMA2OB1QNompcuPBFMyCH6De
	 dh9XD/40Jvrng==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/2] mm/damonn/lru_sort: handle ctx allocation failure
Date: Wed, 27 May 2026 23:11:09 -0700
Message-ID: <20260528061110.2172-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260528061110.2172-1-sj@kernel.org>
References: <20260528061110.2172-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B2BB100008
X-Stat-Signature: omjzt9qy1gwmwd4c67q9391jy7pq4m3y
X-Rspam-User: 
X-HE-Tag: 1779948676-959013
X-HE-Meta: U2FsdGVkX1+ERG6ouIqG+DT1DZrVMsq2FjmpLQD+TViHlZ4+t3B7K9xdeMRY/JLAACWbwuCSbRLkjcSKKoy2c7VB/04o/iqyeABCN0FJGaguzl7aL7eW1QZHpUvyb87I63hUT5gIbGyeFMCL7wl390L5PDbwPK9bzXnC+bkKlzncL0RuX1ZeF3f3zrm6r9am+PMUzMkr9xAkgaQF0DsV65JgZ8y6oInEaLyUmVjTPDffH/lgkA/2GP+SIhKvEz/f0xVg+MAZV2cUFGZ/6MRdsSlKSfigVmdBdst/nozc60bz/sVJcDK87o/C4SYFDSN/EXQ8clvs4Z7rFA+IUkRmcznNJYqL1nvwS17/b9kLOrhn0THx/iup3/uRCdi/T8TAYIQw2gbSCP/A0v7tx0jTxzQk6VjXVqCJQBtHeCz2Ki9vnkH3rlWFnA2PXfNSMXDnamoJGu7fmDxD0tIhX3qCo+bJci6vE8QqkiK2kzvCjYhYrfSRK5Ahj9ZsVcTbajVeLBJ/LOAhE7k2wTDKhnX0/dyqeP8ByA0/IqlZKFWX/eqfknFVxU6/AaayjZuzuAYKr2ZbvMRBcvpvPOyZ2DcOh3ta/OeWXEgGvHKYREtIWqoMNjz/yvYAXSxpk1okhvryQU3vOTPWR2XwSjXpCXfO0sKUMO97OyYbN6RI69RjUWKsm3mei2ayUAI+sPxb0fir9BPSMTzLTcKy+Pu4h61kL3bqt5qH5D+fXK+rprtycdHDKBNWAVNdS1GP5hLJ/PoW6Xr6rn4U6bqDnkZtS0NFtMKsyxeSchSNjN/BNLT2l9RXdmLm6mov/oOwFeuBw/ZTiUUdVMeZlBXfdCPFNQqEx7Hbjqgm9xFwczXLqJr2F+lEsJ+GTCDPlxXnWatcUpq+/rTSwbbLrE00eqA1KML9qd1ATVIUCwwRAISZXpN0HdIcie8+cvqbn8frk3aR2dim9ah4F6YZkPrFiSrpZDS
 udXGHsxU
 THA5r7XSHY2j3Z7vy1XS48nb13IJiXX/RkM/2TsSGSHUy/3HwBvOO4QelQhWI5j4rguaeUJH7S7aqe6N6rGvM8OWJI4z9k63QICUq9QA0givxPCpmCBKF91b0U+NOxzClDn4EBWbmdblTReL27VwyN25sLily6y9TQCqxHIPNPSbB10p++Y7SedTq6CS1bH9ECfpzJIEV02DgPTAEQox//2owHPCmS/94Pdsa2os4hazo4wqnQFWYQnLXb7fIUWThPpCn8HD+X4P35abL9BEoAWkO3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_LRU_SORT allocates the damon_ctx object for its kdamond in its
init function.  damon_lru_sort_enabled_store() wrongly assumes the
allocation will always succeed once tried.  If the damon_ctx allocation
was failed, therefore, code execution reaches to damon_commit_ctx()
while 'ctx' is NULL.  As a result, it dereferences the NULL 'ctx'
pointer.  Avoid the NULL dereference  by returning -ENOMEM if 'ctx' is
NULL.

Fixes: c4a8e662c839 ("mm/damon/lru_sort: use damon_initialized()")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index eca88ed941b32..8298c6001fd09 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -476,6 +476,10 @@ static int damon_lru_sort_enabled_store(const char *val,
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_lru_sort_turn(enabled);
 }
 
-- 
2.47.3

