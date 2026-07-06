Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAB0CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD0D06B00C6; Mon,  6 Jul 2026 10:06:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA72A6B00CE; Mon,  6 Jul 2026 10:06:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95C66B00CF; Mon,  6 Jul 2026 10:06:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDAE6B00C6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:06:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF747C2045
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:41 +0000 (UTC)
X-FDA: 84958527402.22.E077FC3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1386DA000C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiKOy0lM;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783346800;
	b=IBlyK4MKm2VIbvC1degxKGDv1nJe9ID7JCxawjab9HG2YgZGK0sM1Rn9+ASSoA4kS+P8RF
	XZ7egc5V/2beXRqCjRCzBsBBhuL7LSSxZ7Al83qqIcH3+7i49dhZtxYhcqIY63D8ZvG5XF
	hkFYmNDq8MmSMgK9JkKsfwc+NJPcWGo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZiKOy0lM;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783346800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iM2Eb2ExS7GI1ym8vhWA/m10zp74Amrd4zSKSC4zHiE=;
	b=OcK+llqxwimI2XNSHYPqaYM9Yt/gLkTtWlEaN1TufN3yNlpduJqdv3tIS3o67pGv5oWIFY
	dDtK8SS2SJKVA7HcSyu0jAI+qpyJEYAOtiW9ZBE0OZ1fqxrj/JsUpmuDuQQQ5hcSQPHRls
	gl5pgYY4hWCcH5pFsa6EB35JESVYXOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6176043742;
	Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2281C1F00AC4;
	Mon,  6 Jul 2026 14:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783346799;
	bh=iM2Eb2ExS7GI1ym8vhWA/m10zp74Amrd4zSKSC4zHiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiKOy0lMeLh2PW2FXa5ojap4sMpVp3GQYl3FcPgY+K1XqA7WpjRMtbaniCqztdewO
	 Bk6x0P+9IVjzg9OFTpL5TjeuF1UxbPKaT9M1Bw+LesYdBHrMjgPGMSku3usrIjhCdl
	 BN8YFY+YuVf6JoBriEgMhOK9gbXpE2HmMMEllCpsij1gRkH1fojd0zK9YKmWMZe9H6
	 xm/SX0FbvBwr43sfM3xchsEWAXKvwG/7Vu50DENgiKmYdcQx/CCSYsHj0Q7s7+pTK3
	 8ijT5mEhl9kc0H/JjdMiJTxBmVDaMeJEAaQYXeOjdIZ4lFE2TeXEHWaZbbudoBPuED
	 qeYA5DcV1ydLg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 04/11] mm/damon/sysfs: ignore damon_stop() return value
Date: Mon,  6 Jul 2026 07:06:19 -0700
Message-ID: <20260706140628.87414-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706140628.87414-1-sj@kernel.org>
References: <20260706140628.87414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1386DA000C
X-Stat-Signature: pzif9mft38dyqa3it78g3b65mk7owh93
X-HE-Tag: 1783346799-218225
X-HE-Meta: U2FsdGVkX1/hMxOgD4nFWDZgg0RtotYRtRLAMyJLrikwilqJgV8/SFPKFAIrScWH8XYk9/sIVzBDbL0fpaLiyzIXs3+cUBwMB9I5Tm2LcTDLEnj+7qLZEPRo4AZArIUWIdUmSA1q+qnGrszHkcqPaSIIXBV5I732gE+eu5M+Z4Awi20LGxi6WSQ2VfZ+lDhqyCrg03fVk7KHzp/mhTah1FomlpHRNdsOOLYxRrWu9ioMaRm9WwQ3BLPIACnGiXqMzbbrxArLxIot9s3QzOSQO6YPo28nAUggnSrm1+JxgOtou5mT6bC/LZAxKzMp5ymZ/HaaZ29r8FJxPH+fQqYDAe1TwS708PLbHe25ozIAnIVsTxki5RaFxZiFb8Mbtdd+lTO/m0zDkWItbsbyyytdRAsNAlLCIln7wMZzlTXswukBfoAKpSMEPkKsSAs8h4dlabtK6LGTxvXIYsF3aJQkmuDAVZFvLiHAV0Qm84fk4Tuw+EDiVfYJu0nCB0zblApRLiFGgZ29qwLnYW40g2Dy83NEMpfnv1fNeIGZiGPbW3FKjJIBn8aiUNtDvDDTP2uqKA9RejmiBaiVcFlCZWKfyxwHuuMRuRVNbgMt9/VPPcSby0tNzETAYfhEBNelsUEL1ojL50h6XuAFvHaSW1iyQ4cUm78/t+aoBz4UMYKYLELGMuaGvf1qOQByoBowGVpK9boCQvi7x0zIan975KMv2ZyLSLBppoMIhKCQ95dJNfJwPLO2Qwz36pmLdPYgdWm76+HlLLQAA+rg+8NObaONqw9yKLZDDoLuYXy5UQY5XY3yvJ+bogl/+jkVYtB7tooJ9OsbJkOdl4MvEuSF2X4ylwE11WE3p7QxhfLtAaHjkm+/n1yUjmxIYyvP125OuxWMiEcv1ShN+NabZAnY48DdIb2xkWmYV4NAUMyZI3FDi7xpViaj3OyDU0m92lSJvwIl/QeJCjM9kxb2lqnZxbr
 TZ8vtNVh
 hDTS/j0alui3bVlM3M38UWaQvAtSE2GoUCnA/ZqvG888KV4xE5dyiuTka6PyfwLNWYJoAN8R8n3td2NPomBtQRnIcZhZy1eJNS9Ptq9mkkVJLs4x5RfNGvYBOEx5uiT75jF4equbmGePK6DaAi3dUjggGkQnskt04ayUh36FOJLgJntN5Kx8gqtdPNXrIypvj+b6nWyhSdevGcZZJ5m9bVZsa7BE8UWuJ4n+R+Ecg94jCo3gj6EqINUEslMpRk2QfNlczQN6JkVyEP1NHhD1WDRci+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b65651498e0d1..6d7e36c9e509d 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2262,12 +2262,13 @@ static int damon_sysfs_turn_damon_off(struct damon_sysfs_kdamond *kdamond)
 {
 	if (!kdamond->damon_ctx)
 		return -EINVAL;
-	return damon_stop(&kdamond->damon_ctx, 1);
+	damon_stop(&kdamond->damon_ctx, 1);
 	/*
 	 * To allow users show final monitoring results of already turned-off
 	 * DAMON, we free kdamond->damon_ctx in next
 	 * damon_sysfs_turn_damon_on(), or kdamonds_nr_store()
 	 */
+	return 0;
 }
 
 static int damon_sysfs_damon_call(int (*fn)(void *data),
-- 
2.47.3

