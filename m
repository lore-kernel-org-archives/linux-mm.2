Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 198E3CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 18:14:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315968E0130; Thu, 18 Sep 2025 14:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED348E00F6; Thu, 18 Sep 2025 14:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203228E0130; Thu, 18 Sep 2025 14:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D72E8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:14:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC06CC0308
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:14:17 +0000 (UTC)
X-FDA: 83903170554.25.CFE6EF1
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE911140013
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:14:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h/m9FklX";
	spf=pass (imf23.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758219255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wakvOmINFFDIzFIPuPMgLSywd6bmR/VxBmcCPjKbWe0=;
	b=0FPzCyNELSTkSQLWKzunlWx6+WK0OjEZ8h8bMhJQskMZG/8QR+gAKAfNEaQdCXRhwYr7zv
	doPY/y5IFqPJaW8WNLjSlYccnuFWZ4sILmIw1W94mkFvrMjQ8Eb9oh8QHw35uSXpnHiA2p
	2xmhvzdPvasOOEr4P9B3SPdFK4Gfvic=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="h/m9FklX";
	spf=pass (imf23.hostedemail.com: domain of manish1588@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=manish1588@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758219255; a=rsa-sha256;
	cv=none;
	b=BPOccxTSTdEi6HWQSyLAz+h5MDs1QDnN46NPGEkAcQPIhjlDVjQ8f2meD2MZ4IRu5QcRVA
	2yQ7SBVn1Pnq71WdGEih/cWV/HKQrJftAm9y3naN2PE/rDQF9c0xmY9tt/ptEeLkTdK4W5
	T8w/eA6niguO0CceRU/OkdvaLJmC0DQ=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77716518125so744849b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758219255; x=1758824055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wakvOmINFFDIzFIPuPMgLSywd6bmR/VxBmcCPjKbWe0=;
        b=h/m9FklXuYWaYV3GfVk+qEbr6eBJLgFSVSUFo1A/1CyPK+z1ziFK1McDAnWILhUxYQ
         g6YC1TyOCrFDRXEnXVtXcu2AIXhCsvK95nQ2KinKWdP57tZIcjcbyABZuIyP3MkT7J67
         Qmm6qMqEM/5k6FUJ32gqLPo0YVH9IcVnMqnkgYzIXzaGfEcVP5F+0iC7QXjVKCzVNFnD
         bhVaqyHa6n4xyFj3BoSWj5lVrl6B5ditTBhw5AAgSr1w8JUUuSbRyHqyrX7++8/eJBhu
         fF4VkNQ1Z5rxOx3gkKjs5OFKIsil2W8+7UWegAyNc2Ka9O8qDST6Gse1XKi2I8eH8zSe
         VsBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758219255; x=1758824055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wakvOmINFFDIzFIPuPMgLSywd6bmR/VxBmcCPjKbWe0=;
        b=Lk7DXJbDAl1ykula8erG8hfHu2wLln6Wfi5heF83cIVB1XaKZbHR0NxK1vpNrPiMDH
         Q0vAVW+6SwRHafSntptYmPqSI8RgzXP0FvI5VTT/fzqR5ZAzXBoy6K9nzdB31EI3RQuz
         L4C30vqTI+QVUL0iJEZvygv/UIhy0uU6tv/4Yhoja1Ct4GjmdTw/+kJFK78bmCv8Q9x4
         41FXTKSB/tFYoiVgoawuSD7ZSK8IGU3zt8kE7a10tO2j8q013/PiTO07oEmU/sL12sGh
         oWGRjUzr74lqZQu/7QA+l+r3Tom6S8FV/5aJxMwGW9N4TGnWG5wB4BP48WqCjIfmThdS
         s3BA==
X-Forwarded-Encrypted: i=1; AJvYcCWkeUr9acUb3Y6lcdX34OcDAXa3VDoR/J7eTS25sjI/zsLzzrycLgQXSLaFxWUcMCCvI5j4qRGhcQ==@kvack.org
X-Gm-Message-State: AOJu0Yzu5kPu34P3lhsD+XAQeOpc2YEqIDs3SEIT4vFdRUrMsnZYbrWV
	HqgccbG31T9vkvar0MTKgOpJWOc0/ZCuVj37HLAbxe8rYtxNO6JM+iIe
X-Gm-Gg: ASbGnctYvSmrbiiQyjAVxYAPSGsl6dPqmu1yW6/Z1lB280HAPcDUy/fQF6s4wmRLb7U
	96g03NdE4BcM352IJBikxkWoEJ2+rEWKLl5N/NDu1pEGylJVQxoH216zb1eAdpXCT9QJPQTc5kh
	bOI+9poeGvglchogCsgAKzFmhEqp/S+AsqKiuq8InKFdZ7cCsII+51LXUWwPGYXg/ipKkfbmwma
	Ub7SyXBc5E513LYUrDDYGtHQ5Whb4j/5xnQaHqdfpytLRjiGLjkwIfF/QN+1++VNZjAzmojWC+H
	t2785AFyMW1kwk+cNGYHh+jCNNfAEo7vqvxfEbV3gvRm00f/RyKRJIOJexQNM7a7vw7yl1jwqel
	n2GCta0cZDI6dGDRqWHofxD6btLPxXcM4VlU4bUej5w==
X-Google-Smtp-Source: AGHT+IEPsHiDu6beO/Hsry9V80GWYk2DYorDZkppoEyn/lpQz4QbXXFYMRyUp805AG1h5+9l+6cpWg==
X-Received: by 2002:a05:6a21:6d89:b0:263:4717:564 with SMTP id adf61e73a8af0-2925b41e299mr857221637.6.1758219254627;
        Thu, 18 Sep 2025 11:14:14 -0700 (PDT)
Received: from muxbit.. ([2401:4900:1cb8:2c41:4cd2:6b0b:66a7:bdd9])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cff22af5asm2927767b3a.100.2025.09.18.11.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 11:14:14 -0700 (PDT)
From: Manish Kumar <manish1588@gmail.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Manish Kumar <manish1588@gmail.com>
Subject: [PATCH] mm/show_mem: update printk/pr_info messages and replace legacy printk(KERN_CONT ...) with pr_cont()
Date: Thu, 18 Sep 2025 23:44:03 +0530
Message-ID: <20250918181403.93812-1-manish1588@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DE911140013
X-Rspamd-Server: rspam05
X-Stat-Signature: 87iqcrmq3jhqo7w9g9ohxthoyg5dqwip
X-Rspam-User: 
X-HE-Tag: 1758219255-430276
X-HE-Meta: U2FsdGVkX1+YvzqDi4JVUaKswY12NM5MLp/uWMD9vslpxv6tXyVyXzvqy07SvkzA27FWKcJb5FguAL4fc7fZjkAbBYXSUs5TX+B7kcF/t91TVYXULjv0SNkIRNnCN6JwHvRz4P7e1/KyMdRR5YCS42z7FXGz/2Wm2xewsnUmTny8zTzRkcG73a5e2k4lQiNpn7BjA3bwlbtbePmQyTYQuZfYCGhWa8iuxEpFRUB8NS2IE4/AO/JFXAzlMCjlxIBq4rkoAh+p+UpavvuPvwqcBz3W6CHvFSGfzR7nwhdHKFnLOcIvziGamkb0T8Q05hbG0MbYZTaIRsqGmegeBJ5umXwbjFBp5NGjIXf4fNIRK6RkuD1KPWZUnhLp+z1ut3VNEyYkXuCmp999CaqL9saa6jzSUQqLnZwvePthmoGsuLDViux2J1HfENnZ0QRzuM2EWcDSuXE681hixvPKp3wlYT+0dWNgQwIgo9jFq6t2kEdiqECjPUSR0AToVielXWyUA4uEto27feWi27TOUkC6FwyjVbG+yPvaDkFVAOxfG8/lphMi3nqyBx5/t0roV8yczT2FSxt0yPXo1fgF/nAP+J0dHU210+D1Ot5akaEFVlltFNDsxT5+t1EEQHT5UfguQiKY12eRJIkdwTUZiF0XL+Z6gYKFh6MlHsbPDkDEEgEcIXccaI3b5el2aSQa6mqIBoxElNzdoFC/+F9rzsB0yvpJ60NYTtphwRRRz2EUtSqZxJHlILoTgU4e4fRlgdShBl6T4TKJqlEHDVjme0hIUyp4xU+W4GQxGQLmFwOSO8Hp0U6Ltv4UMWI64/qu7SdBKkqzXnTfUKgk0NFUU2UFh0bTjGM/Dtj2YTK6HUsYdBtnzs3/vNBU1kiy0LSgoz+LdnzIfXYgFBKlkvyFav7W+MduPpw+TsMoB0RkcEHZuQkZiuAOzQDOqSYJR3/jFE1QK8KJRMEyfHY8Vf6RILC
 oDUNxL4Y
 FkrE8mLGv9OpauLecQBvbNtTwwhJfujQMLQsKZouY76d5P/Gp2MzuW55S4kCyezxkJc67xrBJkXimuZIeWtu17PdfFHoSS+xJwUDneGiOdtpuwenZRSqkXgj3Zot5sOBswd56bS+OdajPTaY+jswmmXcmmUjzxC8IggHA/IYg/dU3nrbUixCohms0R1CVrrHeUbYjkd8GVmC8WfClRCEMNkZ8hNL0rID12GwAWdfDoyorgy494BsNI30+os+SAkVKIVh0BOZ6GKgocOQoRbzXGeTXhd92wzXGMhnsh4/DWODIKLHyLsufPJ4jdr6MrNKXCfCay2LYGXax5fptbi0xOgMPDKBEQH5gDy/T4bVane3tBIACS7B9FdAY3VfpjIorg/zMS9pTA4ExILv32YF8BQVNprFCb2ZDxs2/XDkzdWzvSrytvN02HhKh8ZhhzyoWsqu6JzlFEHgFfGz+gbSscCI7Gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Manish Kumar <manish1588@gmail.com>
---
 mm/show_mem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 0cf8bf5d832d..798949d10ce1 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -26,7 +26,7 @@ unsigned long totalcma_pages __read_mostly;
 static inline void show_node(struct zone *zone)
 {
 	if (IS_ENABLED(CONFIG_NUMA))
-		printk("Node %d ", zone_to_nid(zone));
+		pr_info("Node %d ", zone_to_nid(zone));
 }
 
 long si_mem_available(void)
@@ -156,7 +156,7 @@ static void show_migration_types(unsigned char type)
 	}
 
 	*p = '\0';
-	printk(KERN_CONT "(%s) ", tmp);
+	pr_cont("(%s) ", tmp);
 }
 
 static bool node_has_managed_zones(pg_data_t *pgdat, int max_zone_idx)
-- 
2.43.0


