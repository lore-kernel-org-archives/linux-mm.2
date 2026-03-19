Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF7C109023F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:16:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD726B053E; Thu, 19 Mar 2026 12:16:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD356B0540; Thu, 19 Mar 2026 12:16:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075776B0542; Thu, 19 Mar 2026 12:16:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0DB56B0540
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:16:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8EC088C109
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:16:39 +0000 (UTC)
X-FDA: 84563315718.16.6DB7137
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8802F180019
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:16:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="TE3K/LFo";
	spf=pass (imf06.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936997;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0jtuyetNK/baxruuDK5kI/GjeQFrtkqpHG/Vh82qoY=;
	b=6qxcfM/CtFBS2TxsxwKwNwh0LlJOgSfBxExuvFoHkx0YGkQR3ufZg24H4XCR3JkM0vl9ev
	VWj2Rq5g1TZ/6e5elJTKcv8s69ToVAqm50LBqg6w9ny545ReF3sxTef3CS2fkm6ISpqi7y
	kbQ5xTa2/f0CVSpaqHoK1hpYLZOW5zE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b="TE3K/LFo";
	spf=pass (imf06.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773936997; a=rsa-sha256;
	cv=pass;
	b=DUqswmhot3doEe9xVSS7Q8qAxm/+Fb1qHeuMelkB8LwqwmwUfm9t8CL5EDZVYZoP6CzkHu
	PPORpKc1Pha8cGCv26yI1jyG6073SJY0JMIkJCwNV4SXystfSheh5or9UqwL2FNvKxMQdG
	IVkG1lYtAAUQgmQ9JBYWiTg+0uWB9DM=
ARC-Seal: i=1; a=rsa-sha256; t=1773936985; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=E7g3oCSFjixydjiK7IdOAi8wuNnmgbl27IcyR3fZJdawkRR48AJtpscaPFp5citgx3tG3CAXwKoLQEpEWhp7HAQ0CnvopcIL5iVPI4SB3KsLuKIRrPwpzpn5SNASMfZ79gPZa3o9Hh9C85AD/AxXhBwEkId4vUnxgRW/A2Xc7Vg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1773936985; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=d0jtuyetNK/baxruuDK5kI/GjeQFrtkqpHG/Vh82qoY=; 
	b=bAg+iOT+f5bsdX8pmCKmn5rTvTgSiOhYTkzYzfyac36NqAoUyqDS5xgWV+bSLPAXccAjJGMpitL70hmEbFy2u8+8nK2Ld+tcYvCj9C/UyAcmKka9MO1Qr46zhyFUq2hnixzf8/FHlbo932CYYRscFMxqvWofGBAGEqwtAIAtrvA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1773936985;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=d0jtuyetNK/baxruuDK5kI/GjeQFrtkqpHG/Vh82qoY=;
	b=TE3K/LFo03tMXXAYjw3auNwMi7W6mnVYIQA5rHIU/blAiNEh4DMnz1Vn7zv+TS2i
	7p542x41uXAT4bIE2HMDLkv2G8qriU6ckvXqv2v9p3cpw8cuQuqB54LbwJ0q5L6YjOv
	FDg6xF9hEcvASJBxSi/h7MD8Th2NN1jwGZslD59c=
Received: by mx.zoho.eu with SMTPS id 1773936982644744.0596713495183;
	Thu, 19 Mar 2026 17:16:22 +0100 (CET)
From: Josh Law <objecting@objecting.org>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Josh Law <objecting@objecting.org>
Subject: [PATCH 1/2] mm/damon/reclaim: reject non-power-of-2 addr_unit
Date: Thu, 19 Mar 2026 16:16:19 +0000
Message-Id: <20260319161620.189392-2-objecting@objecting.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260319161620.189392-1-objecting@objecting.org>
References: <20260319161620.189392-1-objecting@objecting.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: 7re8c6bkixfqh3ftyf93ew969ztc6iuc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 8802F180019
X-HE-Tag: 1773936997-874621
X-HE-Meta: U2FsdGVkX19dYk07oxHnXAIok/1NAZFZI1ehJ3umxQd7GbaHp9W4TR6KVF/1xxjvAZ50KTDa/+pQQ34R+KgRTk2j0i9Z4MjHtBZyX8m0ed1SssntUnqcflm+VsVPfbNODNIJyoV8uVFDn4I7VQ4MvcHMaIgkm6AUzXSELXarcQpdDp8rP1psUogC1ECP5tmGus2pbFD7koHKuEdPBfIv8UTU08p+AfRDsnx6iLyodrCsjOzvDTda9uPUFZq2ShseXim7XJkQPwwxaSIaFAAQg7lpsYyPRrxv0H4M5NL46eLh02ANcI0ccX3SS5/8ogDqlvZGbNIGlgNkjQBx2SAVU8WHgJKrBv9Fz/Tv3Srp1ZUSnoZGgZJwhIdGucwCbkfU/VYlNEMw1xaytU8V/w6896jCMa0T/SFVd7atdBs6zi9hfdUnzC46cfqoAqa+ZGeTi1zKKD1Bnzt0kGJNDQ1uCTLBt3oL9f5ZPSZHNh5s36dbtWDCnMD39MqntMPDgSNWBjN2VfwqlZUaffsC7b2PhZFwjGCjSjMMmyaukMU9C6Vsfe+VURXf6dZ8Cxfx+F8lGLrX0hT6czjDSyt7X1D3Vd6OyYBU5etr48e69xcRiu9vgQL6T5aMSrd+uGTHrrMJGw1NYCF4mIu+eUkCMaPHwV+KG6HUF2Th/i8bWHyM3CmxXS0qyGZRpi/YlNHT4a0jcyQ1SKIpfWuKYrbhKYJuwGlbORVqLocZJ9b3AanB864Tt9klTpuIEeOp0zrsjRPwDXCuuPhv6ghf8Hc21v2V3fdNqtdU5q1XqzRYmV79bRhgKd50+VmruJx6kcm+cHklIcULM3dnBLJpXe8rWeQUV4xk5ssbT2khJ24K4yme0B9rhiXN9lzHFRUnVyLO3L7ccC9VEpOkf54cMpUDapZvzIdW5HbBWvj093ivfeWSdFn0qnUGqwQy2HXysc2z04yvbi9oSQ5ZHxuZEOfDxpR
 cvepNhwn
 eE6GD6xvKf/s2c69Jcgt0wc7kYDMGHC+UPdGyhrcmkEE0RdfWcMrzwj6rJyFGdKxrSuPO+mhssLDE8WVlCK+fRAxw4i+SHoclse7uUDj4FlPp0paNNQgAiag2PPIROwNv+0R21GN9jkpVH3WJCxXoHgGoS2JjVksANZnwRkkZukMeGDi1vpsrS0f4Jy4C8jPJIuhza1l+TTqnxpr8uWWcMsHOdQ0zLZisk8YoTgWXx0pHL02USvHDgrgg7eCxCzGc7D4UGeFDbS+jFT4JTzn357pko4a6tGqk6Z/OyaTYP4HjU/DVnv250bNXdYI+4paZ9Sd+uprzx2AMcYeoGZecw+2jAvRW0gT0smiPYF+PNpEGP+ByYzTRLx1BLYsYiR8DUuCXNIscgGHlv8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_MIN_REGION_SZ / addr_unit is used as min_region_sz, which is
passed to ALIGN() and ALIGN_DOWN() in core.c. These macros require
power-of-2 alignment. When addr_unit is not a power of 2 (e.g., 3),
the division produces a non-power-of-2 min_region_sz, causing silent
undefined behavior in ALIGN before damon_commit_ctx() gets a chance
to reject it.

Validate that addr_unit is a power of 2 in the store function so the
user gets immediate -EINVAL feedback instead of a silent failure.

Signed-off-by: Josh Law <objecting@objecting.org>
---
 mm/damon/reclaim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 43d76f5bed44..9b55df304e51 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -321,7 +321,7 @@ static int damon_reclaim_addr_unit_store(const char *val,
 
 	if (err)
 		return err;
-	if (!input_addr_unit)
+	if (!input_addr_unit || !is_power_of_2(input_addr_unit))
 		return -EINVAL;
 
 	addr_unit = input_addr_unit;
-- 
2.34.1


