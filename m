Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2939BC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 862A36B00CE; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 812946B00D4; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7299A6B00D5; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 395846B00CE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8FD3D168B5A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
X-FDA: 84958527444.17.2A5759B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 020C8100017
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmS20j5y;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XifFyfJolobUF4kXii9SDmtvZzvIFxqywQe1D4fl4uA=;
	b=Gf/jnC2KeU4N2aNxDES51w0fpt/k6hcMHl5pEETA68OpOcMSogriiRx2vf9YsR5Ew0WErj
	WtfF/NJKCnLEbzc8QVv77RHLRblZMUn9uIExPYtiyJa0ZbkRdkHnyod5tM15mra9g2HE/m
	PDhTHOM8JYcSVuAENdHCc/taV25RcNk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HmS20j5y;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346801;
	b=1El7DUHZgHL+D43ld59L+ya5MwEyiQUOu5ECrvmErtFuruwaPMCpi3V2Vyp1o5sgH+p7bj
	oFFrrZZLsp+TvmNKY5gMiJiC1sik2nIcJ0AjFKTxs6GGjeGJZTLCQCNLyWjXdqdJr4nWCZ
	euRJlg3NpSokO7Xtad6hsaElOA1ML/w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48EA443B22;
	Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95831F00A3E;
	Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346800;
	bh=XifFyfJolobUF4kXii9SDmtvZzvIFxqywQe1D4fl4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HmS20j5yX7GzchH37nIJE6zHhT5G8cTgsMm2dkny6473IAR0QuA1rOCaUq1KW/Amt
	 Buur8jyYC5oTn/tk8kAa8pvdxqOFxPj6lKGiLMlxYIFaJvJs1wSghplfo2+ZBDk0dN
	 SFjmjtguJv+FgK1ZA1KM0ZYLaW84gkG222bVASSWxHX4bZx8kl9yj5pP0pL+11RwY4
	 dL33ogYemO9Zx63+AXcnUoYBFKx9SpNjjNHXYUgeM6hGb2dO51ns5/p1YcpwoAlhGB
	 RWaMZvo25oqrMzVqeedp8JKs0Q9gPxlzNrzaBTPmJzsgrxFDgz3c9sEUdYq1D1dGmG
	 Ctzl4fBCyMtwQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/11] mm/damon/lru_sort: ignore damon_stop() return value
Date: Mon,  6 Jul 2026 07:06:21 -0700
Message-ID: <20260706140628.87414-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6cam4g9553f1naeofki61nhtx8y4z4b4
X-Rspamd-Queue-Id: 020C8100017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783346800-286285
X-HE-Meta: U2FsdGVkX1/eUcCSVn11zfQPlOCLovngnTdr+fyUNJFZU0nnaK2a0W+ZGpIPGv8szKR1vFzKmfNUgw2483TXcPfmSuyMMzjLBrQXZt7l72YWal39Nd+hY24TQ3vtCJRii+lW8eDwx/EFC1mxefCsao+kFH+7yAIFd1mh7LBnhUMMg0tui4RuiSLXTvx7vivTv3ihI3P/ag5cP8NrOBiQqaa/oBCiP83s9u2Pp/d2DrToX9HIw9+FDHVFyhLDVGyYrX9blguqzcW893dIpJrrfnNI96DzGdMylFm+Rlr9XgF9XonAmXZ1zvgqJye3BR20RVwsqC5DOox5pe/zjknAVzuJgpTp+M5HNlepY2jwd79k6GOIkTB/na4KQa5StqipW/GSKR5rcgGyOIHigvCZmIWzPj3gLLaNuJ39czYd/KTxxeXQN8+e9jpLD/bbCTB7+/OPjp+Rrd4rKhfe3pUSe+H/PKXYgXKnqe/3ErygEYXlxLo+E7N/lyCcojBZNidawSvJmpcG0Lc+DSDtguflPh3kB85RQYcGC/AawAGO1NcsADkxkDS78VvcjCXuYb7WOljtbL5TaAu8Zx8ShRR1TQNJYcOUEHwpUJv/qxYJWiqTS5HDxO5zbKhZ3sFunx+96NacO8aFrYAEB6SDpwUFjtAO0LH1JFu8mmD6SnriQxd2zUYpHhmpFyh79TrIxjbvO+GU4EqLMyEJ8iM3iDCd5A9PqzV2RBkUlxbz9qkSPmUujYzar93BRYWs9vWHFMkdJAIzUfikbL96wAeQ4QeoiXhP9Qf3F2BzuQ5VSDibcJ3TLuWOscMOKeiFxLwCmVjNXRNKgoJ8oJaeWUykz2EW05+zcZLFmQv6fWY7JmSKTZJp5NkWsHVcgwxV8iuqu8wNbVAnORFN58HADBvWKkBoUtwIwcr6P1rxrc83i6mYkOEFm2UWezKTO5BtorpR5dpRIpunXDEC+WXskmQ7e0k
 Nk+S4fw7
 8I3C0qGRhqPFj/unAJE0bQBz5aIw/alOFEnQ6V6K/2e47YgAnJOI2xIbIyFQPrGAig8AoNUc4SPamWpdSmHSH5F9n9K4cjpk1Fq6ObOeWTA4BNL/EsIen0vafBlvdx1j6K+D8zWyaLKAs71BJMovBWDHzX70k6Et4Ea79VUqBbbn7gbrQ1IN3peae+Tn6rIlm7J8yxVuj8o5jzHMLTmuKjKZF/i506Yv3+ynApPjgxSK9WkndtGQigpwPnQcef0i5g7dAXODcTmnMDs6+LHNMF1USyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 2dd0cd0d26273..e8c389ad3226f 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -409,8 +409,10 @@ static int damon_lru_sort_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_lru_sort_apply_parameters();
 	if (err)
-- 
2.47.3

