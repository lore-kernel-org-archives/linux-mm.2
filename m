Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422F5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A167F6B00B7; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954926B00BB; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CAD16B00B7; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 348AA6B00B9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 952AE1C1B11
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:33 +0000 (UTC)
X-FDA: 84935247306.18.CC44C53
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05DD718000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWPp9yXB;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792512;
	b=EWaa9yl0c7lTtFX6uaWBh01i0RucPXgmJs/CMDyMx+33B99zjJ8I+I6XDfYr7/0iUbLCzn
	uKd2PDbC5Wxpu0aULd70HPrSvwerHktz/LViHdXa+MR7Q6N/5jBMe34V2G8FGojAZ6lP/J
	ZZ765BEZWeVayI9aP6azYy+bm42UVGg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iItvK+ZWl2wg0NN27wk4KDGoWSXX0z4a95wgJsqCs/I=;
	b=6wqBMhefYQJMNVfFiDEdRNLukzYgm1CALlFaVOcTJsORcqJLpz9Y7cmimnn3zTnOZKpDT8
	yR9PInodSkSP29arSVVlRuGkRaU+TUQor0g+WfAjTmR2Vq6j2VYnnHe8CXUxPZaKmnWdKX
	miEWf9hhmkxRiyzvV4jcblh/yN2lZzY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BWPp9yXB;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 515FF43CD7;
	Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098C31F00A3A;
	Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792511;
	bh=iItvK+ZWl2wg0NN27wk4KDGoWSXX0z4a95wgJsqCs/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BWPp9yXBudFU2EZEIPJpz1sI0Asw2XFu4/fmrEYXAsfJQP/9h5bz01LB1v7/n2ung
	 TVlkFIqRA94z7+ehBXfxmLDlUppeXavi5YvdeAwcJlIQV5FyMI2VLzn9vBfvtnga4B
	 SErK8FYkzgdkyNY2nj4KKdFIkifqxXNket44MMZcuekeyOwtXqE3ZCNHJfBm23cIE1
	 BuKVs6JXQbDlgXymWaZaJ8HluiOfzOBAzDUdYmUsiCLdNLXg63PXAbrXT5sqroLRpH
	 t5putgGmprHsyHmZ2f3JoRP5oEzBZjtblAZEjAEjdE8K7eq2eMbTDKmxozMJxizml5
	 3aplPa+b9bTqw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 16/18] mm/damon/vaddr: remove attrs param from __damon_va_check_access()
Date: Mon, 29 Jun 2026 21:08:09 -0700
Message-ID: <20260630040812.149729-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 05DD718000A
X-Stat-Signature: zkeyi94sqmd3khr8jxi5utci797jeu1d
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782792511-375726
X-HE-Meta: U2FsdGVkX18k1P/r4oZfq+4uyMsI7uIoJ023klx0EWW0kShQfRKgqTZQHozD3FohP8GHYsHXUT/wNPFXlBtmVg0czoEABUMcrhLTdHKHKCMjUXJqDqYtr426GKLuuQpFOlctZzFa4+EMxuZWMtlNzQxLNI2VUsg3dmLIlSZEYSIirl3NTjcm67YeasbHw9rfeGVVQpexp/Gfpid1CaYksFTD4H3Dm88PbGRm6qqaoeYoBear2QLR0FOgGiqgzFfyuOy6bD6Hg3ceEUPTTDIudghtdYY6Wru9miXqz02Sh4JWHqPnAgojnElfGF+9Li1J8+BxXQvTYVzdIyHyX33+/SuuRJY1uAu0A7ddq4kk5DyvNrDulFPfVSI2G51Z6RLoYoE3QYDH1IhW3Y0GJOMgYGgdWdaOufsjTam62YzL7yRjEHN0WaldQKUpAl+21AzSiUo8zwB2/btZ54P/cS2GZP342iCPkvsAXAu1viD+liNLUzWh7buWgT7ZtpDlKBfCEObeofDCYcUky9ToTtYa7v3W6NY1qzWCzBiWzoxej0qrcFISoXwoXGFUAa8pusUL/Dr1OQeaqvFh2W0K717+1C4LPi3d92YsXih/HTqjXLIFPuc+HpCEbtNJ2cT0t7EOwbsa8rE+GYZtfUGAkNISfltCIixIG8M9dm8u3biu+rtgzrrN3XGX3xOSDX4MdquxhrEy42b4Bl+Zp0d6EA2yncnTwAE/WwqhEzd5qfVfbmPnE6EZDZ5TKPXo4jXV3pgITsrQxswBGEIztcXJ3u38g/IHAIlTNXlr1K5ygifh6s+rBe/m+ZLabndz7Z3zKmEa/0VpPgUIstEhoRP3StmJIHnUpHFPQGuam5viqf5gTXF2oL9NrGtT1+300gg6gJuUzzkenrk4TKlR0eBoEELbF9nCaIU3wJX1kBMSVarw/tOnI91RmGbDwu0h8ZKNVCXaJDlqH+wXt1VJX/BVJFv
 fz2/EDHF
 GeYaJNupXdTsgMDb7UCS2B5GbIl4oECoTUspz6/dCOygW65n4DTRZUcHDgo4BvicIW1sqABJW+sBH2tOHkiE/ghHNRi6xF+YXqULZNDOiHODuUlQnIpCR53+xlhURFY66fBumqKztUPHbF+aX9vwUg/i2rt4/DqvIn+suNFL91k0lZN7HOIwxl6p3RA1KVLYxz3ItS40m4wVXkXSg7GuSHE6YyBGVKqHmrjl1EbejOHFMZG7oAq4yylx0pLTMqfGMz7Si018urw/CbGQFCNE4yLDO0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function is not using attrs parameter.  Remove it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2eaced0765e26..2058db9c01d52 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -493,8 +493,7 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target,
-				struct damon_attrs *attrs)
+				struct damon_region *r, bool same_target)
 {
 	static unsigned long last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
@@ -530,8 +529,7 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 		mm = damon_get_mm(t);
 		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target,
-					&ctx->attrs);
+			__damon_va_check_access(mm, r, same_target);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 			same_target = true;
 		}
-- 
2.47.3

