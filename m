Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23CF7C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0D6C6B00AC; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B97386B00AD; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACED6B00AF; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70CC56B00AC
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C043E401A6
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:58:00 +0000 (UTC)
X-FDA: 84955935120.24.F45210D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3000E1C0003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQAu1j7A;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QnL6i0mbNzGqk7F6gIjbd/KMt9GZkHBDgTWFw34qqes=;
	b=W1HSHt6xLD3hh59UEVv+H89aFIBpj69wCb5GmRXc2dWoeBPuLyitCcYqpgvdc8K0smsnzw
	4S5SgpxwDBl+9L63Ul1sEDOxPHgUMKWXVkSW8fw5H7Ygy0k3UJL1tiLlZeka8rPqkHgM+A
	uoBD8QGtOEl29JieAmqwvf/RmDObRY8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285079;
	b=8dtPdqXE8PYxItYxx9/aw6gy8qmihvZZhZul42j67OTYmtVIwQIW5/kCxJNRZZ6uFaumpz
	SScgJl0Y5E8aRNLAvoo5Yv5hTA9WmWcK6qiLjGcUlos8bhM97z8YqTmQDIIwBLaG0Gjota
	qzUZnXWkalVTPEi0ULy9bRZ2exAGVQg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQAu1j7A;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E28843B1A;
	Sun,  5 Jul 2026 20:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297A91F00A3E;
	Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285078;
	bh=QnL6i0mbNzGqk7F6gIjbd/KMt9GZkHBDgTWFw34qqes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQAu1j7AwAYYBd6YoXtthiwGqh3oGnAKpiDpkG+9z2+IHVfzEjXyUVELfRbSdMnjv
	 VNdYhYMk9UuaruqLiOJlGQp0VaC529Cu801wyalAP2zIC8jh6eTdVlCJSzVen63ux5
	 Gg9b0wUNXB2qnfHZwYfI7bPZXEE74kY2LW+exNDbiS8UtdUqk4cRj3iCdyM4Ix4Eiz
	 xD43KxUceR9Zghv9jm12uIq0QdB39YMj1DWQQUn96IP5KrhaWMTY/1/uFGoQ4yABBd
	 0ozNQh/G+VehL5cQ5ruJ6GzIDvfLwGcMHYIEOIjjRjiSryX4klbTvfQ1BmX69alHbk
	 r7EGfoRUtgbvw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 12/16] mm/damon/core: implement damon_has_probe_weight()
Date: Sun,  5 Jul 2026 13:57:34 -0700
Message-ID: <20260705205743.98656-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3000E1C0003
X-Stat-Signature: cexf9xnbcks5ebj8j6wbx9b17yoqnxka
X-HE-Tag: 1783285079-811747
X-HE-Meta: U2FsdGVkX1/H/Joammz/0pHhtn1wHkr2Oom1NmyaCkWlwUx+QsxkfMJ4G+nm6QnONELejHLcS8Q/4K+jn4xfoZvbLMpKnvy4zMJvF4JEziLb5m26yvStGI9es2s5Jqk2lnCs9IKrwxdV61/KSkPdx+cKkdW3um2U+LiPm7DPmM0TM2eqxbNFazf7C3siCZi1jREPH2WW8BfCn3x2ob3hDBn2WY1H3yuHrdd9LeSXMBCubhPOQGKX2y7Cei7JNKq69eFfgRyyKI6NK1tvmrvg1gBYzqp4/S0Ox+WhiUISnKBrzS9iU102mcBavpi2kDAEIrv+eJYVC7l1/y7QUV+4h5HzIts7Tns3zkTIVkwzPBdhHI1zAsIfpa0gN2M/ms7MNQSQvTutGZjVAWTY3STt7fw8ti4mUP4/o1DmrnFJKiNv5ht4gC0FWIKAppAxSO8BR/4sj4Gy8pm9ueYO38Ui76HlfyTjgNGnxfOAqHLxwFWu0azba75dFppvuT+3pfHP5hei6y4V2lG0Koo1CBq9cUCnQRHmSY9+e2rbdDMRxSjOuMbabEz2mBJEdatWtjjBblSQtMximJIW32hIF6xc51WpZcOiUp9h9o8+J5QXnvA5IfVzuIk0HSDyB/sfZvdHnOTBI9P7Fcaq3pW+R1u+bVrJ4oeRFGuczXXDs9ocZWDsbDeP/1MzqJufvXPgCU/aEZMFBeI0Z64dj/98k1fT6XSjIYuYHex2zUkT7T4C7SDqmgtuf1ECBeZNwQf+g9+SgnFhvNjSiGg2lSbOOy6ZicoiOFACsaxH6MJRKI9BWo8YERNK3awK7RG2PVZrp8+7i+KV3wl/XR6UJIACJaa9WHoKr0TVlof7DhR+whGrCDHNbPL+7Ij1StF8tjgGa6WD35jzeiOUQX76CYoMzhoEYeVgIh0X3/NnNWf5ZuYqpQmmSwKJsQH8N2LmV/lOyTpDEcGvshpb61ZLz85vL9/
 aE79zYy6
 NGB1oPJGujzDbxF9/T2JvVZkGIdpOLkK6Gg78Cln3bjie7x04/wDTOlXoNKmH6hhMUgHkbelCZRvKHKqoDBDDDG9PC4vUyoANetETSg/DDQxhcmW2MpOrtTwsyV7NG7L8wpKOctANe3H90UayoyIL3tZRq1i3iN3G182Fpw/ohv2CF8od/hf+kc1cqUym7+83RorhJWo+wLtgHo+AwTOFpYSldb+sq+sDgAXYMCGhZ/xZpMOsEUoy0nPO9xj73EM6Bk4i6nRcbgNU5Sibt9/iUSK7lA==
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
index 83db073c74e2b..b44393ccaf6b1 100644
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

