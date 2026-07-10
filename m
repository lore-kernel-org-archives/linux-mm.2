Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D040C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0C856B00A2; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBCAE6B00A4; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B851E6B00A5; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 902106B00A2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1F83F4047C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:07 +0000 (UTC)
X-FDA: 84972993294.05.389C5DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 809AF140002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dI4w4lHm;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjxwjzI1jDT7bs2h2B+hgVQdgy3iqBX4IuJ/qCYlBQc=;
	b=l51/I0WLAkqcqEhOX7yl0j/ebpRmmuiAnEryEKdSVHTv7XKy9J4a5E0EB6B/pIS9SmaarO
	sAb1+C/g5238wSP4agq76todxuNSYhhIY4iGx6A3K2QAeDIiVlxqXrIHjpw2PNJwXVvs0S
	ZW8nwuTJM+XuMg7rAbTjJVjwxgnetBw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dI4w4lHm;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691225;
	b=vTk1Vj/j9AiIjnovpJfqJg4iShuzp/GtaMSp7OBbCrSgS8BVY7TNuDqSGXmmpObmGc1fVv
	TPuSE8zV1nopGF8whe0VwPqn3me0o0apxEXR8y7ZZnoTCAV+AkSGPFy4O+WiKHzZV0U7Xw
	ORDKpAQNZu5OkMn+ZT31HDo9zeBcews=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53FAF418E3;
	Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 133F31F00ADE;
	Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691225;
	bh=tjxwjzI1jDT7bs2h2B+hgVQdgy3iqBX4IuJ/qCYlBQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dI4w4lHmgMu6VOLTCkMjGUQXS8crc8cdSQLEeJwGqCUy3hS2Q3il4+Qy4WxAStp5J
	 qnpZzchpGDIN9XtcDI1eEMG4OcWw7AOU1h7AmMPwK0fb9Fq8XkpZeyGRszQW7x1xgM
	 XBP557HVSRfofWsxTSxk8gRkbiddJo0PBLgJ94VfvppqrACRYcQc5nil39dP/XFoNM
	 Cd19EkDaPDiU/u9udVHWsHLjcuNj6zo6de3HEq2nNxzGB+RAUKMIZH+Jm0bDrRvxeg
	 c9Lq57lLzO1ti0FSLiPagtgiRAenPhC5iF47c48RdqzDdAnfT9IBI8wgOPSV4CZL4O
	 vAtWC/T25Oh9w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 15/19] mm/damon/core: implement damon_has_probe_weight()
Date: Fri, 10 Jul 2026 06:46:44 -0700
Message-ID: <20260710134651.18084-16-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ppbzp139b4bx5rw4emrp3m7oxwqf97dg
X-Rspamd-Queue-Id: 809AF140002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783691225-942587
X-HE-Meta: U2FsdGVkX19jhZRPrSQ0I2bJG1p59wvSBvRkwyPiW03GVZCA4jB9H1FLDzh8Polf5YHsM/wwDB0Z8jiOHekxnOt8ZGU09icJUjQHAnlGxR0cpyPt1KSGUzjbBCuau7U7DhiqdMEEy2Dd86HBsFgczL66jgNyg06mWThrxdvzwA5o04qpuJOPgDNXEgaJwJQ08BObpCXolEM68XDjU8tSnplZyxqK0WhQDygxZhKs6PZK867kbElpYNirNZXvPHmDKAFB/65eg4VACZfpim55yP0WvxEmf+InKPiesE6rojSWnrB1E4cbkJLTkVRrDTBCfSjxWXfEDF/6EM7Q+FHbtmHWUYAKMNnBZbvnrrdbPE50qAtelDPsiTVs11rUdoI/rr33QBctRvxQdW7G2ZpoSREmMhacUj/Rfr6WWFwqMwv+R1g5ogVhHm56zdvp/Fp3EXBt53m3F6PYbHBAgbNjyPtUWSYzJY5lsbqSNWQlUDJfILdE3tXGDE49JpEgGn+zaU43lpkTT0n8Vre4WJdgmubGXzboOUld9ULNgAsn2FDb6wwt9PKNtew123dq++3Y4LaUla3gB9E+92xxhiUs+mmmhFi5ZGJjSjNJuLLxbRHLjur+4sRnj4kisIy9f5PoqDDwc6pEN5xVVydz6OA8rbZ1bEU+674+22kSUR4eTF4gMaLIxHlHXaR+uVF9+7wGZjrexyOLfoSuXW1W6VFPwnqXn0xX+sJ+GQePUE459BKyf83N4/yyxNx+kCpETZ/VJ08cpGOy0Q4JEDqPHSOIsh5lhmuwyAYPs2EnSJ+8pUs4Lf2CLof0xQ+WVXIeVPT03lzCnxv+Lw1eXESOI2RNXDQf3j5mtdEp9L1M9L6VaY6clkkf7td7TgtIYrogx5UMKbcBW1ksDmpP66e1V40BvAuqGOkezOT3vBgVNWdvMnAerhZdBjVuFNmUwLIggiFRzkyEh42q3gY3rn1iJtb
 Acvb51VL
 QebVJxSnrMiLu0b3rrvFRkVIGFsKnInbG2AZs2KOnZw56BfiGCb8mOipUNfBAx2gWW8/LLbiYOBBjEDvDPGpoBhZjhM6fOhQXS0CUrIPt1FTdRf6S4EeuwkYUgymrDgTBL1VSqBj/fYz4FUmeNFYXPL8GRYNxT8oQcuSLME+RPnZXeURPt9aYCACBSGopcuXq/ZJcxDQhusLhvjEcLTJ1QjhxYSehPpzgjXKcgQxCuiyCBYwmy7eSmLXQyaJftuPIyozxjE/PBJTheDBd7YlUHVJUCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON monitors only data attributes when probe weights are set.
However, the function for detecting it is intentionally returning false
always.  The intention was to make changes for complete support of the
mode in a safe and incremental way.  Now all the building blocks are
made.  Complete the mode detection function so that the mode can really
start working.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 91964336ce31e..806a67d02a6e9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -211,6 +211,12 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 
 static bool damon_has_probe_weights(struct damon_ctx *c)
 {
+	struct damon_probe *p;
+
+	damon_for_each_probe(p, c) {
+		if (p->weight)
+			return true;
+	}
 	return false;
 }
 
-- 
2.47.3

