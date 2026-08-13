Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF3B8C5AC67
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 03:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F496B019F; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FCD6B01A0; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15CDC6B01A1; Wed, 12 Aug 2026 23:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E60266B01A0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:50:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6A4A9C050F
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:12 +0000 (UTC)
X-FDA: 85094868264.17.50F1FED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D0F8740004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:50:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H3FcusnP;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786593010;
	b=UmRxNiM1UAM1fnNTJESeMrtUbXacT3ff3HDcjDFxDx8nfNA/CEKK9uYBTth29F7hJ1JoGf
	dWxOT+umXDSjaD5I2bbqU1CDEpZEFbBnYzasnn+Q2bydWllHOr3lHdKrQnhFUK8grX5qpa
	WSlTYFQm7R6g03dmNkEg+VdjvVW1MxA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H3FcusnP;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786593010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AIpHwpSSS3esAV2BDnJ9BAffq+YFA4gOCk++VRGi3uY=;
	b=eeth/bltOzI2uGAnR+Da8bW3jZQNzITMnvYyu3II9hx8GyVw5QEiXAksd5I0c+DeZJztel
	quAa37o4jLGYmIaU8OLVLkMNrs1LSl6B8QRHhfkVUlJWlsyt/YIbd6l7LpLBY7OVpxdHc4
	GbwKph7on2oTWJ8v/pn//qgBeQ4luTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8B959600BB;
	Thu, 13 Aug 2026 03:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19D4A1F00A3A;
	Thu, 13 Aug 2026 03:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786593009;
	bh=AIpHwpSSS3esAV2BDnJ9BAffq+YFA4gOCk++VRGi3uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H3FcusnPSKD7eR3+hfvXu3GeDcUbm4gEBBey02p7UEbMUK8JxSmPyxQ3dGc+w2QaZ
	 cte+MAnkoXvhiDbEXJjXUnEk9/Fy1NjaOzEqwHbCB3kouVGJIJrfdLBxnWtKVG9dks
	 rsblvXbYZkHeHuqoZQ8sgz43sSUPnuJipKzBiRFEkPFfs9IBMXxMH1VHeDWJ/NwR1C
	 bRUF6UHU4GNXneoDX+kDjGI5le4gJu+lTfNUmLYFSKHWoCweehU2zj/AK0yF67uV1J
	 FDQ/mbmNjXRSR6wz2F41lTL02PLhwFguE9mPamMVlXP1+VJ2mxxPn2IXUKE1e9iv/A
	 l6eIobiGU0wDA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/4] mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()
Date: Wed, 12 Aug 2026 20:49:57 -0700
Message-ID: <20260813035001.97364-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260813035001.97364-1-sj@kernel.org>
References: <20260813035001.97364-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D0F8740004
X-Rspam-User: 
X-Stat-Signature: e6177m1bppo95uz8dzsbmkfrbty3u3ia
X-Rspamd-Server: rspam06
X-HE-Tag: 1786593010-391696
X-HE-Meta: U2FsdGVkX1/uvvRCkhVR8WhrktU0mR5nD68Fdkz7ikj2ATUPvw56Fvt/40SUA7RX5Gzb/JCToSznLsU1jdFq9KTnyxWLmAfdn5aPifsw6+jaJcAlqQNtOSGtw7ZVYnuypHMIwS8Fw/6iwtIcVpFeV9fLY+PKGnwXalwTGI4CGkt9vxbejJu9U5UeoX950vmsuNW1ZX43hlFy/GdcjuRiCpU9QkOWu60iPWqwynjjlpL5nQwtxLny0Vrr6Szbp2ggNFh/XM71EBgAgq4ltfO7N9ELJ7vz7pKHbGlJ/fEDaZH5rhYonxVAgykmqoim+OyTnkJuhdU5RwthU68DIoIg0bqlVMLw4CH1J8I95buV6/O9nl6gfOEvUROrJk4t9ggMhuzLmbbATXCObS+7CmVMUg7yVMlQAMBOi5UHs1Gx91L4Nl2o/H3bw+Hur39+2ewzxEEm87rhh1YJTEiDvPht3wVjaR/IImsbsmK1VORj67xd8gNkxpklq2lKsg9G1viMcEnPz9FdDkO42Jklnwds7N6SudHmO4uaqaA7pYOeXvqcKlDFNXvCsZ+5gOd22LOhRqXTS+lGD9noIpY6xzqyH/alPXADe0hTt/Jrk7cRpURYul+Ba932JP/r3Dwvy8g25iZpCUlOtV49vBIxJdqBSK8mtOAIdYd/qUEWzE6bRPEB2EJUVCYvsjY/kOUklFx1hS+Ah24k5+egm81UcrUw18rEFYLUCYmXIszLuYZkTpTECSYUlqDgguyUVSMvbXDS0K0gaXoM4Nocxqx/DybNf47yoLjiJHAFNCGfBmU4pKsE3wKIzYpUEicRWePG7MR6SIqWrYh2cQoZQA5rZ/3XqTvDDdD1V5sLxwJUUwCpx19tPnGhJ5W1pBuJsHYQmy5LmIb7wYEINldGLQSOhN3tE8Qe+0TmoworZIsixIKo5RtdR2A8IVNqe1yrlqytvqmgwHLuWOygdzCMxvV3NPi
 SWaWfPO6
 AMpdmeBjMU8+2Ut0p8+amB1T2WFz+42tM6UgozIXQbxRna9KHe38UBdit72QX3PBX2+0yzypXgSldqHsITOGFMCqQZwRjKz+Is0w5BebsfnuHDTbr54QoZs97NgiPgT3eO1AmZLPPpjMaoBpQT8M2y+8mjPMRcyc7fVVrNQGSKxrG5OYnKNzCcfr1NEbSp70XB+kkJ7G1KSPj+gnr/NN3yyKtv1N3Pxzt2jpNm7AaFwj4h5A06kq7L2YG1hnPDqnIraQ4SHCgeXfY4U/NXFRg9LCa3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_ctx->call_controls_obsolete is used to disallow damon_call()
requests when the request cannot be served.  The field is unset and set
when the context execution is started and terminated, respectively.  The
intention is to allow damon_call() requests only while the context is
actively being executed.

damon_ctx constructor, damon_new_ctx() unsets the field, though.  As a
result, passing the damon_ctx parameter that never successfully
damon_start()-ed to damon_call() can indefinitely hang.  The callers
should ensure to avoid the case.  Such parameter validation is not
always simple.  Actually such bugs in DAMON_RECLAIM and DAMON_LRU_SORT
have been found and fixed [1].

Set the field in damon_new_ctx(), so that DAMON API callers can pass the
context parameter to damon_call() without the additional check.

[1] https://lore.kernel.org/20260803134646.16640-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5882f9c94c47f..5a92e4fac6d92 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -920,6 +920,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->adaptive_targets);
 	INIT_LIST_HEAD(&ctx->schemes);
 
+	ctx->call_controls_obsolete = true;
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
@@ -2178,10 +2179,6 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
  * synchronization.  The return value of the function will be saved in
  * &damon_call_control->return_code.
  *
- * Note that this function should be called only after damon_start() with the
- * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
- * wait.
- *
  * When this function is failed, the @ctx is guaranteed to be stopped.
  *
  * Return: 0 on success, negative error code otherwise.
-- 
2.47.3

