Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B0CFC43602
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 22:08:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1680A6B00A1; Sun, 28 Jun 2026 18:08:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F2F86B0098; Sun, 28 Jun 2026 18:08:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFBF56B00A0; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B85D36B0092
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:08:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 244EE1204A2
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:08:21 +0000 (UTC)
X-FDA: 84930710802.13.B6451E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D531C0004
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 22:08:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782684499;
	b=A2H5+RM6/qbcizAXEZsayJ+W47byzJPVLdkBDh0rvuWs5YZLmKRjZpjWepsUkFa7uEpZW9
	LxZJ2UDaHh4zeK3SmH5wUDj1wBEgxY9ahxPvblIfWh0eBzEx3oUTGXkkx6Z6p9HETKPjmN
	Xm/KcHqn+ifk4dNdiUsvXX6gEjw0FpU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782684499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DXt89oZz8sWsnv26ri4gHwMkEXscXvRN5HE91XKdqdA=;
	b=rWW7aax0Fd4nRQMfqsNjMARHxUOpjDXus6HSs0EVyUPlk5u2aM3AlxWuqek4UtOFtzsj0Y
	7MuKMnNjVsx2HiwBH0y8pxg4u6W7NbrTmMN1XOnlZsCa0oe42VuMjNRBNXoMfzOU5izuiW
	X6yafhS5+V0mLC3ZYcdcnmhJqQaKEsY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED34043901;
	Sun, 28 Jun 2026 22:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4A0C1F00A3E;
	Sun, 28 Jun 2026 22:08:18 +0000 (UTC)
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH 2/2] mm/damon: add a kernel-doc comment for damon_ctx->rnd_state
Date: Sun, 28 Jun 2026 15:08:04 -0700
Message-ID: <20260628220808.98931-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260628220808.98931-1-sj@kernel.org>
References: <20260628220808.98931-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1kho8hu1w9qgwnanoiqyiuepznrq1ksp
X-Rspamd-Queue-Id: 9D531C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1782684499-285618
X-HE-Meta: U2FsdGVkX1/FI+gp3dTmBKAB4N1BmJEtwrNstTW0gb+IInZPEQqzL3EdaJNnF2kN2PQeD63zDyZVelIfWrBtxB/PXdrw6sZGrKCFvJG/wpPT2oC/PoAudqVs46BzKCDnVageGh35LycdLm2t4xlCWJhzlDO/ik/cAv66GRyZMiF6r7golGetNEj803DhllfKGm72EYNAmkI5L/oUORtZ3CNifRQVcqPA7zYKek/Up2g+7H2OxiYq3xd9cuF5uLA93M8XmkAX2UAcNc7iFUFYhmFnfaK6ask56b3L7a1GWwMDTMgA1yDi/xmhQ776jPK3suyQOyBYgz8OPtaouDjuL0KwX3C5ohDEy/WrRyzaAyFezj6IUks3TGh3F90cjxW26lMUG0cBxpYjc3z8FClXeIR4ikLAwaTgvWtO9EuW6O5i6tU8EtBSYmnRx3FBQQbRoZB99KjQKwU7GLYbXmoStpjuo0/4Ryg04MCOvO5Tevr2ne11b9CX07yelh6X8f1gW+TULZ4SLD8nQXudwuVZEKoZanYWrPxsQyyLiUUnqXQOypyDN/sAvxzEr5VaOqrAvrkYMXT+m89qmVDlrIwv8BgxszbhATCX8jbd3yY2nyLo3kVgGBqy2MyRvXoPYEx8t7VlB0ffcpSHpcwYm28HegeNevuprfAZ63yYQk6JmlFjuL60Or/cf6MJ+YqjaQRRZ02rXttKagWF+q1MFGbROjOScfRq2yAXSof3QmcA5q+y/afs0hXzaFxUzEMySPfCz2O/f66lp/u0s6zf1b6atSlq1ZQqpAk78JuwR4ZPwZxtJ4dUTvzX+CAQo6LQT2CuZwcDjoz9arWJs0JwdRHjVip4hMfGIPVpxmsU1Drv4pkzDrxYc/6cHlbcibI12qpaBJDJiCREWYHkR8F8BZcJst4lxDwsqwkOcL1wRCZOqLSHNCTmVbLFk76sEWbrLFV1VnFyAxWdtcm7nV7Lvjl
 a6Gtizno
 c7qLmwnIcjqbAExKBiHstlnFDorX5flkOBGkpYPQTqqMHcYyLAvcukNH6dO6gtGpBO25l/cASqFIJX6x2gTASB5ZsJf+IxtrtUZdK7TjpckXrd58XTOtwK+q5hvhBftpjyGpzuPE0AafGixeGwBFce9skEbDGQpo/2ujtW1hpqYve7STkZz/0sj2x5dcQ5JNvD0ba2UcgtPjCTSvUFXolfVfr/1YGZrMMwfzY7UCQQachUMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix below kernel document build warning:

    WARNING: ../include/linux/damon.h:909 struct member 'rnd_state' not described in 'damon_ctx'

Fixes: 9012c4e647df ("mm/damon: replace damon_rand() with a per-ctx lockless PRNG")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/4df95955-b255-4e5a-90c4-35db02f3111f@infradead.org
Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 535f675625724..cfbbf8ba28f63 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -847,6 +847,7 @@ struct damon_attrs {
  * @pause:	Pause kdamond main loop.
  * @adaptive_targets:	Head of monitoring targets (&damon_target) list.
  * @schemes:		Head of schemes (&damos) list.
+ * @rnd_state:	Per-ctx PRNG state for damon_rand().
  */
 struct damon_ctx {
 	struct damon_attrs attrs;
@@ -904,7 +905,6 @@ struct damon_ctx {
 	struct list_head adaptive_targets;
 	struct list_head schemes;
 
-	/* Per-ctx PRNG state for damon_rand(); kdamond is the sole consumer. */
 	struct rnd_state rnd_state;
 };
 
-- 
2.47.3

