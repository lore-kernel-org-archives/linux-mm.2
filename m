Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4627CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 18:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5658E000B; Wed, 27 Aug 2025 14:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D0E8E0001; Wed, 27 Aug 2025 14:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F118E000B; Wed, 27 Aug 2025 14:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 59F0F8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:34:30 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D69AC119329
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:29 +0000 (UTC)
X-FDA: 83823387858.24.BD819B9
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08BE3A000F
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 18:34:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RZYHto9T;
	spf=pass (imf25.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756319668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IntdueGNmbqsonxIGWPXQZZdSCFC9k/C0Gxs2L8OAMA=;
	b=i5LA1urKENFTdLR4E85nfBihMFlfTTwLm53RL3kuhz/hNBlsdKgwQp9S1Q00ts6B+Tx0GZ
	PD0835UodX41ATOekiWkonBhq9AXuD23RngfaWYUduEz6/H7R6INrb3rOzlTrfVsqFATN+
	RsovTnXdd3oPgCiwpdZ5YzM8aoGoqS4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RZYHto9T;
	spf=pass (imf25.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756319668; a=rsa-sha256;
	cv=none;
	b=GGAMtHlu6rS5mBFlc+LLHsPLEZRRiMgsfeaSwOiUzbtUWeciDTD1rOL6S+0TFhS+I6qerk
	sKWq6oqAnr3fmO7/aZE0hbdD8+It05MrTZ0+5fHw0YCJuJdHuwWqsH9mfJqWqo0QZ5pS4f
	r2km6CelXXW4rCkTYfwyU9WR3OtTXTM=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b4a25ccceso548215e9.3
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 11:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756319666; x=1756924466; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IntdueGNmbqsonxIGWPXQZZdSCFC9k/C0Gxs2L8OAMA=;
        b=RZYHto9TiSiLfypwhpa19qRYVh+4lebyOFBLmhY9wIyevLyLU0zQZr5TVWYh9dVrUo
         KMJOpjLc7FlaR3zZOGMqSKnMTLu1ewlGUQzscI/VRTUelKPggrjyuCHRfaxMd2xLfip/
         K9/L/umtM1HTFzqfp1pn+UBBtpaS0p0W16of63LeqZjVRp4nRlVIYhJU1VXP+2cO6Eg+
         5nidlJDjPyVxBwxy0p/qR1JYwLWWym8ZgBuU9Z4YgVPIYm7pbfwiD7orXjInnaxmnY6j
         XjEiMBQykbs3ieFK+4DA0TWC8OMh0PJw3xB3IoqtJhK0B1/mm69hPMDQpVgPqrzTdZUZ
         +P0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756319666; x=1756924466;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IntdueGNmbqsonxIGWPXQZZdSCFC9k/C0Gxs2L8OAMA=;
        b=pu+Rf0DQGK/FBBLM2xuQgP5CYZFeOjyQ/oSM1Q4n1PhiR09+o8ROYnoZpd9Cesb5lM
         RPH5/SetWAqVLE+oeUJhOFNKYeybtJSPaCGEIj4p7zNaMtQrxrSDLlQF0OASh5I4Smqg
         PWQs0Mqk7sml1xKcuOm9uyboXL3OmdISJx32r/rvHS/RMxZyUVgqDuU1WXkuN/oxeEqv
         OwHqmHoWIEC7wEjdCjMenKClKNVkMgrpdfNfJ9os027lAH3CBGzDfxC5IToqhSofFqu3
         HNWYBpI6bHRZXHv7HmahHEQ78cO4hfR/7ZqbsmLHxD341e4wLZs2Uu43ORuCwNLDPIca
         urWg==
X-Gm-Message-State: AOJu0YwYkol0Acrge9Kes9EaeCJo9bCikDdN/qZ0xFu8BbW6oQQh7zLO
	kRY4F347BOrxRPawLpYjxd8iZOP7m2OK/2WuVhs30mjvfm0eimxuv6pB
X-Gm-Gg: ASbGncsysPunA81eoMLFcQmfwb3RvK2+nvAFk7Ip2QlZmK7QCcdJBx4xuJVzuvkWuku
	kC82w+HKWAalH3uTuFw4K+m/dESejO8HH0RdQ1l2q5sQrfqJizWEyJ3/jABy/b5cXcSB0cSLnyo
	19PpnzOKGRTmN7AySyvJjRsR+EO5sndaA+bQhDKUSj7mWoZcMMlZM1aqjEA+gl6WrSUL6ENYJ4i
	lrY7O0LCUIOBrtygHgPfPC+2EupaXuhRQ3ykf7NzgJQoDiuRfLajQh2FglxYxQoJFjNrHhJC0SO
	gaIl+CjQlmvr1Iq641FOQr6sh8OWXTB783Wd7+6KDxs9h7xejnbU7YbI5NrxbjF9Int/T2hsGPl
	dAMtE90Pd0oDIz5wS3w2WBuSx
X-Google-Smtp-Source: AGHT+IFpUR8b9fvTNq2Qug4jd4Uwz8rry9LmQ0JBLOieWly9E/eJQluuoWaNnPRcfSqVFiET0281Eg==
X-Received: by 2002:a05:600c:1906:b0:459:d9a2:e920 with SMTP id 5b1f17b1804b1-45b5179ccc3mr180127615e9.4.1756319666289;
        Wed, 27 Aug 2025 11:34:26 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:1::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0f3362sm40614335e9.17.2025.08.27.11.34.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 11:34:25 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/2] mm/show_mem: No print when not mem_alloc_profiling_enabled()
Date: Wed, 27 Aug 2025 11:34:22 -0700
Message-ID: <308e0293e68dfadb2ca3ee5b4c650fc3d09d7a35.1756318426.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1756318426.git.pyyjason@gmail.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08BE3A000F
X-Rspam-User: 
X-Stat-Signature: 3wrfqw9ob7irqqjcoufywqpp6ufyzkm8
X-Rspamd-Server: rspam09
X-HE-Tag: 1756319667-511737
X-HE-Meta: U2FsdGVkX1/zxHtmzVA/qYrs/5I5oOjDemqtDdHNP9dniboHn1qX5WPc1UUhwqby5p1F+383UFnbaWTi1szj6hyIAzxl7n2xzOeOzM9cWgFaYDhdxpQV63R3XI1SMQw7bOZ9HKL3FmetJUsBrH1GhC92ZUceKSkNjnps7AbXRoTDaw+zRdCj/48cVlPEpBE4yzlc53aZwzs+ctckPqOBfBWhUx7iLi/dBiTrd58N2ckB0dUp9OQTXPcCFdT38C/HvCbiID1LYW/6Ckm5pDUpYSRIO11fBGjWJs/DDF6IZFE+0cX7VziHh4WA7dntAABOFX3KtfYdiWcSnkAaGscFTHSpsCd57zJ5AQz8bLT+X6PoI6wL67HQSAe+15vuPhngKQFDALmGtoa0Ta98f2Yp3c42NSejvoA9spRjd3u3FQ5AL4L6Sl1WUJ9DEputTMqpOPZrzCdjmqcz07CdTvz3cllLCnalwFXtESRYX6h/1zF0QTL54fE9FQEOgty1vE2pIb664XuT8C7VYvZyuM7/EchkYqyoOz2inwTq2Cbk6PziidPt0xHK+pY+Wmh5F2vx2ybKshtD3nHNruPp68DjvYC4KGrYFT2puybgKbxsVoCNhExUxVR9v+ay1OZwMIv/kaJUNrdMezSslYF2/2vUlfMrr4Jd+fo6kvEUGc3u8e8UETumJCqnWLYzsXlfW30ZEiG5vP6g3rtc1AZ2J8tYIjifQR4Au6NLGAvVaJShN/e6UnKO+kZHPZhh6Blh0Ibj2hcN9FtAR5N0xrq8ndInPOy/gSeibU/P1vGNqRYzw91NraeyQr4E4y1C02+UeU13S8vCuhop5vqHYwsIZwC98NG4hLaPBxjV12pcgYLe8nengO3Wxe+XxpfrQ84a+SbwWMGNL5szPxsrnTXLV/nAGfyTyNd1bHtlgzGYADB9F8SRcVPtqg0+CaAUgTTJDqyBqatujH8JVnV1IjDkTkb
 eOjpGCeu
 rnUSkGUYULd+sHHQZETaAvj0CCBv4d/IHxxEYHE6Of3IW5eUoJEmzsHtZyvJRlHmqaBkgQ2aNFKGuo4RT4j6psmhffiEwNGn88Og6zvuIqux8GYhBa5gt63IIFY7IeUSyEcolAQzcLaiWKSNygQ4UNvlDB2Kh6r9zWvHR99lTRaenk16n6Dn1wTUlHk/XjMWJWIgdURXreyGgG3WUsSm1krGHanZB/Fc5wtg/9edidE7r4wcaWogF2fhjsubKEZ/r6ZKwQCIjHEmTLgkGd00iMzhsldl1DetFxDIGVW5s12LW/N5RwUCKK4q72vZumxx6eqeqmcBcy7qdGkhsSorKWbteP5KT43DX58DmSgSkkGM/ole4X8jyo8PoYKtahW7N90yOIckr1UtKbmjGqAoXA/tSqhDtQr1p3nv7azOkuYY2XDf1H0o5/IV2qGBKxlS0q5K59ZNtYVXW+OxvDaoKcbz7+Jv3e1RwB/UHtiTsesIHiJj7L/Di3KmvHwDm3+9+/TrwCUt74WAQYJmn8b6K55j6NFY4t6zgRhBBuov7XiljVMU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch makes print kernel memory allocation information
controlled by mem_alloc_profiling_enabled() so that we won't
see all zero numbers in production.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/show_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 41999e94a56d..b71e222fde86 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -419,7 +419,7 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
 	printk("%lu pages hwpoisoned\n", atomic_long_read(&num_poisoned_pages));
 #endif
 #ifdef CONFIG_MEM_ALLOC_PROFILING
-	{
+	if (mem_alloc_profiling_enabled()) {
 		struct codetag_bytes tags[10];
 		size_t i, nr;
 
-- 
2.47.3


