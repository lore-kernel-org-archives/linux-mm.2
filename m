Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F30C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:06:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973876B00C2; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FCFA6B00BB; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 815A76B00C2; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53E986B00BB
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:41 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3411120437
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:40 +0000 (UTC)
X-FDA: 84958527360.11.878449F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 39C14140011
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SsXq/PQF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QDJgGdtoA/IbgG+7ciI0YVsTZBt0XSBAZ9d0cV22mDE=;
	b=WfjtoJlA+3DmSG9qcuGftKTFchCwWRdKiiOypqz8LKSIjmG4hsnc1zrE+CpiKKtFDqfmTH
	0o+OO89a3/htjE1VZYmha0kRchYjeszQTzIxaz3BHj6PB2Rir30xV2n7hB3HWwyIu45MDV
	6tAhagI5NTdB+fZoHj35AvCMI/BhXjA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SsXq/PQF";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346799;
	b=0thjDGgt1mJ3L9aRyfXTyN+CET40nkIziwRnEvMo1w0eCkqG4ox5rBEruu1D6H+lijiv4P
	HIohpTKwJCZZCGXzLZrpSGvrzdJgbWJWJan7QMAsA4h39KE2jdrjIhE/uSBhgtx9bFvf9Q
	OmQ+87GYsxZMEV1erwXDzV9vDGEYjB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A30BA600AE;
	Mon,  6 Jul 2026 14:06:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3186E1F00A3A;
	Mon,  6 Jul 2026 14:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346798;
	bh=QDJgGdtoA/IbgG+7ciI0YVsTZBt0XSBAZ9d0cV22mDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsXq/PQFHYzE1DpvXxcxdkCUTnJDzpsO84dWR3pJFjJI5VtU6cdmosmqVOpM2ZCh9
	 CTuTKNr+fU36gl2g2GRSZyg6nSer93UVSh12GheMUObqeru57q3nLk4KHyrkBYvGNR
	 dECkW73gKovoIc169Mx9j2zV1n+dIuWNu13ZKFtuRQAn74hnjcxU2OSs6Z2japzSqc
	 vcw/XuE/E8tJIEwurtofj0aD2sCXpWP0fbEBRhgxY41LEiXMndQkYjpKRXKNqAIbFo
	 yL4QDtPmlYkXUB2cOXSeqF3+L2faKVxaR/RaNHgy8YPbXN98ZDp8RjdHevMunbso8O
	 VPXqD6bgM3J/A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/11] mm/damon/core: stop ctxs in damon_start() before returning an error
Date: Mon,  6 Jul 2026 07:06:16 -0700
Message-ID: <20260706140628.87414-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3k95wzimsugorswqy6iwn696x1nbiwt4
X-Rspamd-Queue-Id: 39C14140011
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783346799-461055
X-HE-Meta: U2FsdGVkX1+jmc3CwB/oznCvOnPiSZkqkpXePc2SrdVbLwnEA88lkPqbs+FwmNxIPJPIDJBApm3P79QaGuFc5xhW/L2sSFtugMAmFfV+tRblt/2enGMiriBSvnvE86bEPIW1GiKXEITYVExHbYO5m12kjdHtThz4cJf0j2LC4wnM4E5qFO7C4a0bHQyFCNre8CCxj3yM/EM36QO/n7ncIbn+0hcnDN6Y/sLwPxZE7tmkNgGLaiIG5tYVtXzUG6EvyR5RLBWP6ZLODsBetmLq4ZVJRkcF7BbQ17GK5WrA16vunOt0d3fR3uv/NeDnWEM9uiiYUY89fTL+RfIbehNSJTt6sSxUzsvJouzhmOoW7I8DpsvnnK7piMM/F7faBb6/SubkCM9ARlEU8s1/Hc/kIFS1ATFNosEhe/ER2ifZgR7bfd/wVF+qA6VAeZnZAwU0R5rIAhHkPbWyi9DovS2VetFtyODDGB9icfIES77tPVo7tx30q+nEvTBc1r0jDhi8bl45s1Q6aXN1HyZZLCnUBGohhEyU+887v4wLPaIEmEl/5XN7X30Q6xzNDOR5T7je1/Kx9LVOxaiIqbCa+dXTgFDbKMsSrOUSvWfdGP5908dOGfwxyr55ohJfNrz2M03mQToP7PbuFsjTN1c5s6uYN3hGYfakGEk0NpEyFrhnAj2a4C+8zJkZKy9VATDA0QCP17qYhSU/92DaTWgGv53NYjOEDKS/VAMoYU5PvFewb2qvHj/Ck0unr1ifUlF6/SbXsQJt2ZkNE1kgFIfoj4fRuecg+uXHGvFjLAh6AMX7AGs8Dgvbe8oJ1l3Mt6+pi/mxGquPBzY7bQoJ4HrWtyzlsyuX7nsol6p3KV5KvKzQ/T6wenDc+ulahPkfLPQ34WFTJ4ZFZiwQ8C8d96qQJzgOZ2U2G60+iv6Ruppn44J/YJAz/YwFcnIbYObmcWIovI2FTpkVYwsz05IRK/i9EqZ
 cZ8Vn2fF
 s1xNXITO1JMqe9bLEJneFPmzDohpDSbizAnhLg9fVNXJFbpRXONRQJSrPoUZiwrsdRYLDbLABIIoRWQdSJ+U3F3ZGWiBj4EmnvUWh8/aUgCpsNXI3qpts3rac2Gs8bdEDb2Old2F7yDaYxg69YsJStrGGBkfVq68RRGdMPUIMuUwxNQdh1mSEUHeBdQSU6no2tzS6/gVRsXC9oEqQi8+lu2dA8Yd2lWI95sTR9PyIL3dgfw/wwWVUIHvXMQIOnkNZ6F+HxS/D/vZiG2dmbQwPIP2NAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When multiple contexts are passed to damon_start(), the function starts
the contexts one by one.  If any of the operations fails, it immediately
returns an error.  Contexts that successfully started before the failure
keep running.  The caller should catch this and stop the contexts.  It
is complicated and easy to make mistakes.  Stop all contexts in
damon_start() under the failures.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 3c5a46e1c079a..d89a7f2faf350 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1917,6 +1917,9 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 		running_exclusive_ctxs = true;
 	mutex_unlock(&damon_lock);
 
+	if (i != nr_ctxs)
+		damon_stop(ctxs, i);
+
 	return err;
 }
 
-- 
2.47.3

