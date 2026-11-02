Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E54160A2627
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U4HZd+4W
Received: by kanga.kvack.org (Postfix)
	id 8A0406B05B3; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8768E6B05B4; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 765DC6B05B5; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59B516B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:46:38 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDD2C4012B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:37 +0000 (UTC)
X-FDA: 85390455234.07.C0107E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 32FA34000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:46:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4HZd+4W;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793630796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCtrAnJviulqez0+JTPRdagoIh7IeZsTjrVmURq9iV0=;
	b=q51kzuu9MhWAWT7Gv6IrVIbAkCp37klxR76ggEiMdYors8xNRg4w01w1382qvo8Ulb81W5
	BLa9daSPo6O67uMK5EbJ3HV9MmM74g/X9bhQENhkM1ERt2a+8pGTDQCRdjzzZ2+CatxSCi
	MZgvUY/RXcwfWwENhisGf4w5iR4NG28=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U4HZd+4W;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793630796;
	b=jVdPOw6NkIiHRxP6/vXXQHGvy3um2j7xlRl/dpkF7VKj3ESilQSQJ3kKGk2+DqkJ5Wb0oz
	BOWQNlZfNRrzGd7nfxcw+o8dG3/Tk4ZgZ7ZrK9dSuhv7m+ee9FlldVAXhwEG7TjG1x5l+M
	XAP4gsFu9FjCxsHm+oNYr+bAQEELr94=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C88B444E9;
	Mon,  2 Nov 2026 14:46:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ED81F00A2D;
	Mon,  2 Nov 2026 14:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793630795;
	bh=rCtrAnJviulqez0+JTPRdagoIh7IeZsTjrVmURq9iV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4HZd+4W6Pf3UVe/MGTpV9jp2TFzuGLQQAhPFC68075Wo8dHMtqMo5Y4Fh8nxp5Qh
	 3EApXUcedvjXzWfbAhUPrGms3NRdpkfiHqxym5bMR87QRmB5iWx6OipKELl6UJN1XZ
	 r3u45gEBFq1RGa/V13bozPYdrkPTARCASrS+ph7S4w+dDE2cvq5cfY49TLM8QYL8nN
	 8xACTcgMaF9BWeG1IrJHLFJ9NqLTj8XZsXexq1SU3vXXAC/ZQ9rtBL/InawXTqBhHM
	 Y1eugorTDD4/gXU+p8bpwbgGZ3e5DwEXeNxMfIYb6k4zeN3ZEu4gJPKMgjKqaWA5zu
	 6C1AzMtEt4zdA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aveline Noir <jm5905938@gmail.com>,
	stable@vger.kernel.org,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable 1/3] mm/damon/core: reset watermark wait state on each iteration
Date: Mon,  2 Nov 2026 06:46:24 -0800
Message-ID: <20261102144627.88843-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102144627.88843-1-sj@kernel.org>
References: <20261102144627.88843-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 32FA34000D
X-Stat-Signature: 8m6q6w7e143zqeik61yyx4eawqmqb69r
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793630796-902548
X-HE-Meta: U2FsdGVkX1+zY4WUqiHca2VwuIpgqagM1/VXfvve3durBvvhGyN0rwa2q9XOYcG0QJfwfrkoeSh3pFUJKtaWACzCU0pIvp9DIeDjoNvVREMNrgWT0eha6EU1KcrHnaCLK9qyGAFsVVy2/4abfx48sY5IY+p8/7sCfRYJnEJmbGIkia9sYOonRs7vgLMjuK99wYjuhLeGKGdltvoAB2ADCaeFQTY5OxyYGFExIj/+J9I89D5cdx9bVQGrmnTmd5UZzffY6nGTsI7BjVCcF1PjI2UAcH7RA/5djiNlczCGl8q3r7cUKKO3W1ti0xkZfXQjB+j8fEaMHEqJ/X/cUpI+m+Ce717bG72YbX3g6Y/Bv20QMSFLryoeZvE8oTAZabRa7XjdwdqYCSxR7x9v4za/Tv2Lnyxos75DBRWIfuMF4fVUSuem8gmUvpBT6kdpyNiNBCIDgb6JVLRgZNPljITEnfHOK2uN7UDqXyb5ULElEQiHTRX4HaB4P7ZspYGvfp7qaU2meS7yi6CMHjUNUnw+X3f6HIcurO8HbTjJcdEmir8vE9LOHe4QTBgazebaiSVgyLvSEnw/qJwu3noLSHBpTFoF4XL4upfqjxdKD33S0Kc9Gjekfdji5P7NcA/k0FDhSzpAJ/E51cMNJndH5iH57AgZvOim6co6kLIriAMosRsYIna34sNzDj/tVtQ9AFlnzxOp6brmw3pG5Bzcdxt/q5jUnEo1VEFDNW/dRXAUqt12OjwpYE/IP4GSulqwBiGP+1mJ2q3GNd0Rhj1fTgOM4I2hHEToPVjfOf0eEa3NO78PI+0Sh3mxvtyIm1K12XWT/V6z80KYSbffxlZCkybFGyoW1a8tJneIq9acBOy/SW6dgA+pnPynCxnfpSiXEzhX+PBB4SIYU+xKyRbfaWomRDoc5buC8ZTC7PL+jCCOmJPZdumO/+Nmk+P3ceDhQdTwa2YOsrvrCF5pgRnB58/
 9FjYxfLl
 uTt8YjHH1ou9JtTurgyHdHJo7Rg8o5tORQwqAAjf4M5gSBrWDY+hYKe44ORLhydFBBEwAG9shj44+1i7CQDnYnhxAA75ktLX5urba1EkQjsDk6pSfhDLXK7jDzzMdaPQrpjkmn7DwYymTmU983FAWj32ldyGkcPxVRpE0nR7J9ztxht+bpd9ZI/YkaE4d5YdNWCrQy6sjEXpLbU90mFgZQhk3NEvAHZPuWKBBs3hyeYeIQIkDEa5a3bGJDfCfSSXpMyk3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Aveline Noir <jm5905938@gmail.com>

Found while reviewing the DAMON source code that if an online commit
removes all schemes while kdamond is waiting for watermark activation,
the scheme loop becomes empty but min_wait_time keeps the previous
positive value.  kdamond then keeps sleeping instead of resuming
monitoring without schemes.

The way to wake up the kdamond again without DAMON is bit complicated.
Install a scheme having watermarks that can activate the kdamond again,
and remove the scheme again.  Doable but cumbersome and complicated.

Initialize min_wait_time and init_wait_time on each loop iteration so
the wait is calculated from the current schemes and an empty scheme
list resumes monitoring.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.x
Assisted-by: LLM
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/179277129124.2.16132047926074873101.damon-empty-schemes@gmail.com
- Collect R-b: from SJ.
- Add how to work around the problem.
- Update Fixes: and add Cc: stable@.
- Rebase to latest mm-new.

 mm/damon/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 73b571b429cb3..7441cdea57dc5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3976,10 +3976,11 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 {
 	struct damos *s;
 	unsigned long wait_time;
-	unsigned long min_wait_time = 0;
-	bool init_wait_time = false;
 
 	while (!kdamond_need_stop(ctx)) {
+		unsigned long min_wait_time = 0;
+		bool init_wait_time = false;
+
 		damon_for_each_scheme(s, ctx) {
 			wait_time = damos_wmark_wait_us(s);
 			if (!init_wait_time || wait_time < min_wait_time) {
-- 
2.47.3

