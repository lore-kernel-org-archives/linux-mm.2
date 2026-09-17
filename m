Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42258C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142B16B0095; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC786B0099; Thu, 17 Sep 2026 00:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F229C6B0098; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D36A16B009B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42A73A0223
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:49 +0000 (UTC)
X-FDA: 85221915618.06.BE7A339
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A5663A0004
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDrMbsUu;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617947;
	b=cKS7FTlgy9Yy1kHoBlRSU6iX6CuLqopktcGgbIXlpB7koxTGBy2HivjC9b5ZFm5+3gaIBv
	9z5cvz8t4M8OzMiEGywkhKUra5jyVOWd+4g6ydpbYOK23FfeKcXL7Ez+RcOtYREW+LtJVS
	j/NKQJfBr1jtdryeW7zQzScYAzfFLTU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BDrMbsUu;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/c0lu/EMv2gJrvNjrzhKVo1VbWsy1nBw4kXQJeK/aY=;
	b=SBCdrcLGGmuoRU/nq52vKjiIaPjcTkoN1vsWrObCkEsD8xhobSYwn3KGQWUjV4VkURt286
	XsK89Jin8EFxyAgnnrpwR1BP4KwYtAskpxF1gR9AXsADIs6ulZbSzuaXAHAJHGd61+wF8M
	dFRl/powWU1jKxa7/8SbNFRN1l12mJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 419F460A57;
	Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85021F0089C;
	Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617947;
	bh=l/c0lu/EMv2gJrvNjrzhKVo1VbWsy1nBw4kXQJeK/aY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDrMbsUuGSlCcvJd9rnxO7G4W6iOoXII7+66r3nRFIkXd/bRucgQslBSCC1PW3Dxl
	 wKA7zhuIIx40uXKulHo5dV6Qx/2BETdZg6+aQi12rTbhw9z3a0xgRAp07jfbntSLsv
	 6JBZXBXEtnAmai9lEDrv9/Xn0jXBVn2DGEQ0qXdtSkimoiTpZEUr/2ZwdLkphSOLlb
	 EHKUaD+noVqV5mtcHwvNgg4dR3aBXMc3+dtqLjSQ91pNVmnoxeK7PbV+p0SpKGgPT8
	 CXRTYhgxh6eiLET0ux6wZtKNYhvId0107jWKDBUdP5iZk9Z5nmgAW4tBifsZ3RuVFG
	 T6vUi45ghfNHQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 05/10] mm/damon/core: document damon_call()/damon_start() race hang issue
Date: Wed, 16 Sep 2026 21:05:31 -0700
Message-ID: <20260917040537.107341-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A5663A0004
X-Rspam-User: 
X-Stat-Signature: pgiso1gzrkqk5zw6b191w4w7aik7k75g
X-HE-Tag: 1789617947-608260
X-HE-Meta: U2FsdGVkX18dSkikPaAw7m5AdZVALRvlf9DZ+gAU2Hv1bsJmFPZiISCzw13m3SnCxe4ELRSDB0sB2kGl7kWV7dgjxfsOX4mDw/T2j+Ym+Lz+vueQdEiKpyem9+eFcfXpe2OrJKhWAEFe0s6k5++pnJk7U4LYFi/6+1+5JSOmnKuSWrxCQffH0BlBMd6bPhubS6LOWUB0bIhZomLAsxTteQEgeR+AWKQeZ+EbAukh+kfCOUhOVDyQFlc6d9VXXZlh8SkI7utUTYx6haIO9ZhmRpVpo17BTkB+oncliOMcSWqPG7XIBwE7ECFcIpJtSxS2aa4YE/fby18htc4M5COvnU9TSp7BUmwjWTE1IF+pR4BvrWjYzoL7C6xnkKmviFctFIznv/AreawmZ71cnI5O1FLnot2FP6UUsyxss2Iy5Mz1K097LnwZWkmOlayRJYUHPhnoDyEpMK+dnPvLAfr3vxDyVWVGE1mewFMsD9bBcD6M6sbvgKnJv/QU4p9QQO7D8fn+/vtsi6W0R+0bcENl/dCuhPcZmbU2ucrHjnd30IQCLDyMc/znQGIblHnMzL5opJxZbf1+z38DWZD+bJReOE2A4wycLd56wVtUwrG8V1rY5NSEQmXfbjzCfcLVfQ6oYpyTUUWEiwbuL2Gy26VDFYdIAfycoxiSJ+Kq01tD93WkeEDaUEyUwvBXtZv2MmOIJIVsFoD3GkJhtoVSKWsVI4g8Q9hQ1cf9Wr7S0NWmt60MK9VgWWZXIu83GQfKxki+NTzQ63dm1Fp2CBjxlcnv+n+xZIdRwFEHFBNedzDgyZygZa/PaDgdSVSY10LwnKR1I1UP04zSOhq7xfPpuJ7Vmblowalt9ga069cy1ZHrDFKxFNRiimE8t9SzRWBsLKFeTq3/nlU6dSdTF9l7Noci6/wJUaUdwVFanvn8lA4T/4SeevKSPYx1oxSARexMNhPMlMz8nnlnVuh4netLYS+
 5ZGLcKLI
 UfjQgEB/H4wZJbkoGoEe+LJMn2r8zu2ToE9Yhf9Qh5SMUtBVcP8qH7x5L6c5Ajh2bpMGAL0ubSSp4QGeuvxGLX59kJpKEJO4UsW/fAsa8kpqelvNq73n/JDLRV7uOvNaIpVesmQVjQn4x4G1CZI8LXJPNvhfCYLCRlk0JAdV8sm+GGStN1Hd77OuXA+qspqlI6Vs6gZbXzmuC8KnRHDpgCYhcQuu7QEMmb/rXsGyjB/BaRqH1kYcN0TaWANDDRHDHPjkaQWU2wy7sq1jrIdbYz8fOsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's suppose damon_start() and damon_call() are executed in parallel
for the same DAMON context.  Then, damon_call() could show
ctx->damon_calls_obsolete set while ctx->kdamond is unset.  If
damon_start() sets ctx->kdamond before damon_call() starts the
cancelling, damon_call() can indefinitely hang.  No DAMON API caller
does such parallel execution of damon_start() and damon_call(), so the
issue doesn't exist.  But who knows what will happen in future.  Add a
clarification comment for caution.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9120a1b707b24..4687b909d42c9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2258,6 +2258,9 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
+ * This function should not be called in parallel to damon_start() for the
+ * @ctx.  In the case, this function could indefinitely hang.
+ *
  * Return: 0 on success, negative error code otherwise.
  */
 int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
-- 
2.47.3

