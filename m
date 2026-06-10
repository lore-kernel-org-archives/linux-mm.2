Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F253CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 13:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 843B06B008C; Wed, 10 Jun 2026 09:55:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81BD16B0095; Wed, 10 Jun 2026 09:55:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA976B008C; Wed, 10 Jun 2026 09:55:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35E436B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 02E9A1A0109
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:58 +0000 (UTC)
X-FDA: 84864151638.16.E5B198F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6C5EC40004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 13:55:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+zDJeAX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781099757;
	b=qisfO+gBaSowZWLq85vXK4VNp0aonihBwLJ9wrA5UvOXhqQ2ft0ArHh+R3NeFwfdL1ojh4
	fkivV1/OUzuHXzfKSFe8TaOXJ/54wgVrAA+PYgYnLYnR3gXS/m/dx8MriIzSWgT7/Lr5py
	iLrmy6zgWDsbLJhNks+ph+SjRh3x5pQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+zDJeAX;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781099757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4hjcTwQxd/8erExTfvC7SkLcmq65ZXVC4ot5zMsJvgk=;
	b=QusayMBanUvLzpPTFQHWd8w+bOsJx/ZZ8vwb2WNNe9FWhFN9Xc9YlJkT0zDhE9qdGfdEN3
	fU5dRUpIgSq7+o27iCBDxHAWZGPe/zoeRYHqSrkDnTlkW/IElRJnUrEiXfiBHAW+KswYl7
	Eh4PB6VB9p9qM6xfHMyd5Sr1843vVxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 03F6960139;
	Wed, 10 Jun 2026 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7182D1F00898;
	Wed, 10 Jun 2026 13:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781099756;
	bh=4hjcTwQxd/8erExTfvC7SkLcmq65ZXVC4ot5zMsJvgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y+zDJeAX16PIJTzegEmKXOzPV+ZU+53OT9UdbEUPBfJ/BEL9l9BGSEzKUTIYKqhI4
	 Z+QoOF8JepWNqz14VvgNcYqD6dFBFP7WZ4ytnVw27KVou5HvGVrav+KDqJ5XpX5PbG
	 jWLOZlFrf84pQ28rza4TgcxHWDsEGIdBW6HM3aqpYiocn4L8oAFqzGyYV9AUx06eWh
	 9zXfZ2TIZGiQjMB78wLIrPtrFMjyLHt1+p1wtabKoeneEN2F2Kz3zAMiQ2P28bKjuK
	 Flmf3ub2XiNKPhZZHeGzEEK8r81oI6WICJa7qw21OREgOYttMRsLDoip+zsYjKWHvE
	 PZ2+eX8ZHXrRQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 2/6] samples/damon/prcl: handle damon_start() failure
Date: Wed, 10 Jun 2026 06:55:40 -0700
Message-ID: <20260610135546.64943-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: <20260610135546.64943-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6C5EC40004
X-Rspam-User: 
X-Stat-Signature: n45huecc3wnrwz789b66asc4mk9gtsjc
X-HE-Tag: 1781099757-111422
X-HE-Meta: U2FsdGVkX1/zALe1t5qF2nx9E15vARLSfp6ap0Gt8L3redZZKsRnu7Xl1J370DGTlMKTwjW16luJxemtiZDbeugPQpNaOh6PyDSaBYKCZBkbu/HQ/QuRgYNlpzqC4rg8PUcFixzPWm77Np0VMG8H2Zq1OqLIum1Dy2SPzj9gPETKKj//SyaNJyhREadicxEyIUVm3DjCrB8sLet7fN/gDM//3emU5tDjtanNZzEAZd1hh4g6ygsl0McL2BP4AtsGWltGHh8oIPBzrq6L7iq590tNrRGoENODFnQLOr1ZvnJC6fQrxStsINFvmG+43v6ZnvyATgS+rhHv6f5Mmr5K7Z5IyhEmxIvPAgmkfwxaBBHDR7DYTuXUn//s1GMOQp0BBUmt154lh7AJVCTYvqMKorC08ZF61pJULonT+t7YpnuTprPKlAOaLRkyYUsp44IDS/+yoY4y+ZDtoINTydQty3Qt+EJbKmPbOVyzxC5DRhele6aviJ4wbqhjCVPfY/FM0FG3IRA3FRPljyezRjCwBINGpCVLvodmOGhEH22KTH2pHuCK+PqXzL0x3VtK8kDDS2K6+lyTyL1ZQQnXRJuSvK7Qx6OOwYrwSF/J6Br1EUlpFJBKj0Md/FTkXM+M8SIbORUNiE2zS42+iJUyCGZCFzRt5UZFaX2zSpHV3EGHOzsVgRCJY6b8a0AnoY7pW1z1hcaZaEVrjYBQRypBfi9KB6+PCwhEme7rqqvArGuEiOWGeD7Td8VAm4UnNd6vpbwlR8e9n6LSLV7paVjufAj6ZjVgUoqK6mz1+r4iewkQRZwlHcivq3mLYMlaldbIIfArSlffuUugG8KkwFeQz1HuHeBbGEVBJodeTeSSC35l7NadRDz7y3eCl3gHPdTl9n7+lfrghuxmNnck3SvqmldTzOZbihc4ezkWZFlJQMntzKC/0SZm/VbaxnFd5NEc26XqL82yv3Z2gNG/Ar/6HSF
 0oZYhRsh
 B9BEk9D4ui/9WH30tWMXdZjR+LVGW1DUnhNBmghJMYPkAI5ku3FVlH6gShqCLkwyoJPeewX6klHR+UfVftd503wrsDmZrLknt9gQ8mnz5Nu2Mr2Qdnd+8z0CzxHGOrYJIFRFjjgX3GSKHpwr9awg9thA4Xlb/dv4A13SOWTEmvAsqX7drNch5BL7eeBytlV7rOtmGo++5hNDYXFofdZw2J7SNkzsjRlkmArdVrgzKHsNpHRIWk+ISl4e0Q2ipK5JeKgaMAb9bhlJjLlNbLmL6s6AIsg==
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
Signed-off-by: SeongJae Park <sj@kernel.org>
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

