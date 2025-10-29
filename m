Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29371CCF9EE
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19D48E0040; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC7D58E0046; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56738E0002; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CE2F8E0041
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FEB91605C7
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:07 +0000 (UTC)
X-FDA: 84050547294.14.07EA1B7
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D227160008
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fB+Un1qzL34wiHa5sudIwO6CAt1kZCmFhOrHBaXhq7w=;
	b=stL9QEv/uJTKPFUoRLAVoceJBRgX0lO1xYrv2doBBKaPJo01nGlK1QtvRSDuvdcOcOcVmm
	sdeLVZae+TxTtRJWZxkFTLw2joS/obyiwzpxyRxkyiTJMd3+ahjJar+uLjhj2j7Bb7pRuH
	eSGe8ahAU9lwnN4eLX5IhaTnPWZosjA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf08.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728225; a=rsa-sha256;
	cv=none;
	b=bX4UfYx4WJREHT4rj2ct2n0klvIQSbR9nJSZqhjuEIQ6746T2DDBxlX+2EOUXowZN+4qBj
	0zJtyU01ZCoNhsyFKAfb7VeBzBSQutc9m6bh9I3SGGMJoxEYeUSWNVEA5xSYwhRqOo0SI9
	2ffvyyBow2V77Fr71PxMmDZp31vhO58=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Oct 2025 17:57:02 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com
Subject: [PATCH 2/5] mm, swap: Use SWP_SOLIDSTATE to determine if swap is rotational
Date: Wed, 29 Oct 2025 17:56:56 +0900
Message-Id: <20251029085659.2005942-3-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029085659.2005942-1-youngjun.park@lge.com>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: amsnp9a1313wynqrbcgnqpta3tynu1h1
X-Rspamd-Queue-Id: 2D227160008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761728224-747064
X-HE-Meta: U2FsdGVkX1+9/+JslF+c06a2Upw9cJ/Tb1XRdFfNsgWJiCRoiq5lmsd4Kv/AatsfF5fJWJwcf3/cP/ojQ5AZenEvAOwGiExVu9tTubhOZzDxI4ENTJOfXGKrQWOV6yE/uhLAS3yWQJyVv1zVbSd6Ip5/6xoU08+wCSSHjVSGO3v0wJJ5eq8/15afvJUna3vZsDeC1m9B97kpQ1u2wifNLJhOSQhd0gm50V/7lX+AzHw5UCEpDChKak4YHQFomhnzPgByPrMqVRory7bWGP5BzEbPhwUJKKWzisrZftBVtIqsNHVjYy8T6o35HxaUTyIswI5zfMGdM3WiIEzVwEc2XosytsaZ2vy9MuGXLvjHki43QfHRzer/TEfzM3hd28n8EKYst2/JmSXoDSHwRRwHjurSR7Qxa5AcxqR49oSp8dKjfO5ZzrXCUt0GFfvUPAYCtY2dieSgPrFt4XvzGpXhZRGNOEPS0qXQSMB0FBPQ3JXfzcL7WP0euGWA0Xzlu2WYA6TbTIFLFnA9DQybkgHbQakfV0NZDO4A0qwNWp46lzaHjH/jtdEmuFu3aNs51/Qys/I3/H+xkpsD+bLT7snPw3XitzOiHG8y2aUFlYfYKse9fP5DcqJv7ST+TW79Wi/Os3rHH0Tl0fDMUZOeyjnhF45782MRZ1bJxvvsHBhUwUMC/3NHsr3aLPpeMVvCk81vj5ImOTnVuIZrM2azaGdtAq96ha2D2kNvGxU+FqVevUH2YhDO/bmMmckWaGziX5uB/0Q8XYTL63XvJSBlN0t5YoxT2HE4q89ksJT36p7ViTimgQpzoyCfIUdQ6sPYWQqOjAM6lwXvb9o2JgZpVoLl7QHc1FKLdXEPEASZmBtLdjqp/9IsF2/x5shpmhahn4xbFWgSsoVZ3cSonY1exc+18MDY5CpObOgg69ufNGSE5OiFh62ZH826ViY/BohyA85VfWz3bjFsd+qb/wo2rRX
 KoF+SREW
 WZUQTkwpTiMz6gDu5AX2yiHszQl97Hw1sqVW61W3rOQMsEfxpLu0BAKxeIMgtXAAk7Ug2GdkyrUK1CEjC7LlQHKqJ18xF12C46d6knCI8rAfiLjV6xbx6/A1bmKMtA5p6owpg13IOarKZfJthUTvpo1A0Z/OT0TMtqyCBBBY438IjQrXx/nksOhoc3aTWRGvL8CFotm/XaXUouH3b4Te+s2dZpvNDii3XMSA84rwKy9lKajWQG/WZ5j+E+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current non rotational check is unreliable
as the device's rotational status can be changed by a user via sysfs.

Use the more reliable SWP_SOLIDSTATE flag which is set at swapon time,
to ensure the nr_rotate_swap count remains consistent.
Plus, it is easy to read and simple.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6dc0e7a738bc..b5d42918c01b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2913,7 +2913,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (p->flags & SWP_CONTINUED)
 		free_swap_count_continuations(p);
 
-	if (!p->bdev || !bdev_nonrot(p->bdev))
+	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
 	mutex_lock(&swapon_mutex);
-- 
2.34.1


