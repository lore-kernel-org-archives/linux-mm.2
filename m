Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F701CD4F5E
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3EBF6B0005; Wed, 20 May 2026 02:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EFFA6B0088; Wed, 20 May 2026 02:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE836B008A; Wed, 20 May 2026 02:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79FFE6B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:10:44 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 204478B3F9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:10:44 +0000 (UTC)
X-FDA: 84786774408.09.5E116E4
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8F801C0006
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:10:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XZ2Yp9y4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779257442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LW0VfZXiprYSkuoGkQTwqFtv8G4oHaP68qS1kw1Altg=;
	b=Y8R72Uev7GnIXKiPpzOLVSAuSz/vDKJHpksil5a6bB/NzBbUw0BoPv2m5rQU2r8CkYAB7C
	CiWQc00oSkPK+Dqpi0kMKgjaWiEulgO07hc3X6Nw2FRt1YnZ5B4Jzq4qLO/2ltMdkPUQXD
	bDqVv9s8h5J6YsZB0AAVn7IorHWtEto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779257442; a=rsa-sha256;
	cv=none;
	b=hs2lL7HlTvb08ai8DJCKuGbvaz7gSz3T4MlPOhwIdrdWK38g3YZkEwCisPo2sdafcnMqlq
	eh6Ntbg5GpxyEoa1jPX3eo0sR77mZ7a55GMxGYTbSJXAll5CZn/EQktr/CJ5syensdAffW
	gaejEvpyrIriNKf2rKX1mGxFIhfs2vA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XZ2Yp9y4;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-83ef1d17904so4384964b3a.1
        for <linux-mm@kvack.org>; Tue, 19 May 2026 23:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1779257440; x=1779862240; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LW0VfZXiprYSkuoGkQTwqFtv8G4oHaP68qS1kw1Altg=;
        b=XZ2Yp9y4qSN/D+oKfn30RED0Mu5HBB8jP5VokBMbsXNmWvI019g0DGZwe+BX/bTaBG
         fwyy3e2wCX6AfNjdJzZBb08IBwMD3uwqsfa92yVC8mNxYu7ooSazeO+TJx/fLt3zgoUS
         E/7Aw2IU2TKVZ+oXHALBqGwHLVy4aev4JLaFpgAr0OSufvChaNSPUl3IHfYw4zG9Jxtf
         KGjWHUNzmkK6iIQyHngbtNAyNNH5aZpIoxL76NVwz7c+lTB7zF/EorrNmygrMkYe6dN3
         QfKDM0PzYRpgJy69S+2kksAqhGmkvsijb/8+fPHrwkNfF/zgQ9U5ZPhFMBoXA/pt8Mq+
         366Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779257440; x=1779862240;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LW0VfZXiprYSkuoGkQTwqFtv8G4oHaP68qS1kw1Altg=;
        b=Yn44iBEF7D1JW2Xm02kEysZJYeMfwh+VGKq5ZwpFGK0W7yr5Va6BKcjrLzyME4E1KR
         kD8jZ5ANYM7vYcxDHjR+UGBY9zYbQjoOY0U5f6bDDjQ6bmEzvDHHvCGmBNiAwCjYb2iK
         c+XIvKm9sLF6PdQ6xVbRl+zJ7wsSeSaZp7HOwxeghEDwrTXV7/z8tnf38HLAOy8ADbrf
         3eOVhp7odt2TN35HNYSWk7vyb4hW96Th/O1ayZnYelq9wtkX/OBYmcvm0nWxmGzQ0SLi
         /4tawCoK9WvqRmzHp5CS0x0BkIzeZBM1JtU0awzV0UDVW9mRIPaJAyzzHQKyStuU1WPB
         UV/w==
X-Forwarded-Encrypted: i=1; AFNElJ+KalLqXQDpGsHcNrtnfsvkrXQ0j3X+LM8a4PH1qYyjW1kYk7ZfCxDyEleuBhK1/Ps/PSaXHBoTEQ==@kvack.org
X-Gm-Message-State: AOJu0YxyAjBr4njNrrarLk7oOsnpDp2KEUVFksFY6SpV0Dmhdw/imzBy
	gvaWg3yGWT5qaMTudZqXwla8brMhqPAHxxfCaRjPjIf2C+nqV+i3tCXwlvqUI3J3G7M=
X-Gm-Gg: Acq92OECp8l/ZMQZHsMrVTbxJFMk9Jnr4HtaJIW8TlqSWwBZFxFWugZJ4ApA8l00aNP
	E7GoNxdLWXQrlw1XU73OLyBwmcbfyZuKsKdPRR793nWGT0XjzA1OQjG8Ot3ZmRx/2Mi4+133Xyp
	GAp4TrZNnmHDJ9M5+BHsmF4eFbx6Sc+C3PMHL/1NPNOLfdPQmhOwGKB9qg4/eVvY0kPPgUbk00u
	COSfHCISA3Gi5KdWvGc9//GgKdrLPywHQThq7xk+a/mPZz/yeyupEeeE8j6dVg4ADY6hjYq24Mk
	YWlwpPKeZM9JH50kfhN5qbsrsW8alSwANjMQ/+10NZ/v3TrPA/YyB/4noSr1mV77GQmzZ6e7xer
	efmqDjVxD2mj8xH3lgq23uTQnG0YaG63JQEaL96tmLIGRzoTnWRbL+zt3J1DxC0nOBgcdhLJNGE
	gS9bJlZDN3bYy9fUmtdStlWxMn4pZwHI9qLjcdkcsxetGEfdVsKglCPLU=
X-Received: by 2002:a05:6a00:2908:b0:82a:6461:6d15 with SMTP id d2e1a72fcca58-83f33f166f9mr23571904b3a.46.1779257440250;
        Tue, 19 May 2026 23:10:40 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.103])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19c78844sm19049950b3a.47.2026.05.19.23.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2026 23:10:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Frank van der Linden <fvdl@google.com>,
	Stefan Strogin <stefan.strogin@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Michal Nazarewicz <mina86@mina86.com>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH] mm/cma_debug: fix invalid accesses for inactive CMA areas
Date: Wed, 20 May 2026 14:10:25 +0800
Message-ID: <20260520061025.3971821-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8F801C0006
X-Stat-Signature: rms7shu87gb1u8b71h7ugjzsbbpuijd5
X-Rspam-User: 
X-HE-Tag: 1779257441-116118
X-HE-Meta: U2FsdGVkX1/0icl5y6YhZ47sTkskNldLyg2/Mi1WJKt1Mg/hcBx/qfGLSdkdSWKTfxPqEux7F35mZXtX97qiIBjIWIRr4RHZIjG6tcAt1GgSM8naX+n3a4JiMSb/70t4z0tou41dOhCyNWxWIwxJj6enrBrcCSe3zaRBTtTBv5BwoJxKan3kM3/woUW88rp7S3a5im3Cadc9za/W6CtVHfP+Rb51avZU6WeDLyYVHLKAOpzi6vMfd8UCbJEHFtJltWcBatDqeIB5pf0NtMqsIBayuKWNlfweF5aNplrd0ebmD1x34LB+0rGt7MVo02EEdp3X5sK1eN/seaHyOJQ40okOf1YIFrlGq7C5a0WZ7YSqqGqe3ygdJ7ac5LzRCB5pH17GNu2SwYpCAviDENZvF1m2lZCgsagJdxAiWJev6sTcZ/HY1EQc4V+teQdiy+72W/iJU02SsAHnSuhJ1c1NV9pHgi5Z1rE2Y2WBNBljH09e2vRXoKLcpzSuCve6lVfvLEmolry5R56GVBibMVMd3XabOCN6ebHJIVkY6uCiC3AzWsmPwFa0EWBNU4RgxRQi2rhJyHIGd2Qkr5TzwHitYYxJnefcFBPO704EGx0oY1MBCicb3kiga1wHAGB5N3CJyVVAuB+Z7ZFQGQBJj0/KJ4BvLBGVKB5uUMStmaiULENcmvsPnhU1vCqTmVyGGtE+ij68Kdjmsu7kNCBkL5axD5Gv+LPBsgoxRSToKO0ZQx8SWwWrS3+/7jLivHtbFqrX3NxlU3S+DTFs0J7nQKaqMoKIwDp5ZixUg78dKqdwYj5wcKyXmZj85ZOC2xlXEXP0ii9NplM1uYAyRaYtcE6+rZY3M0vYmx6EMBFh0lc/KZaL67ucKuK3MybEgNP7zZOxbrpnEHb6COUOxQcSFd3k8vNRtnVfFd34vZFuWhPvc85CuzceMIwfr9j8qoIVz2LqmManACOJhDPFtGfyUKS
 g+sZYchY
 cmNWjM9u5d0Z1hMML9KjSa4k6Jd3bvDpovn9Ee3IUBJLXGLG/yUiEzf8DYk0p2A2higZovY0cT2IOEDV5DBTpSL3H14M1XPMyVvjLzqUZo2h0s52NnoCoXhKAfxq01TSxH2mbMrA4flHjs4ftwEtLy5lSZpKf/82Wd36TZ3d5biWopVQxRzlpYDiFXR4UxnjyAxjPa4ieOc5/8d8JfaQ1bIc1MlDdcGFgylMC5VFEyi4zdNzGI9931BgfK+1HFTFhu3/n8AX8Kf21cMg92c5I/EHXEkZ3ekppVj7mSZPLRPd4nj8eXNsOxuKq4PShNPXxfapVYWHAMf6JUMGAfYzyH1j5OcW+KCx9HhCR1BMZdfk1GIsakl/dz9MS0r7QrJL4BWm41SyRomySWncWTbmEvwQm7Miu6or9Yhb52b+jxL5aWQY6V/RpTH1IKAbK74UIRj342SJcUA+WVcc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cma_activate_area() can fail after allocating range bitmaps. Its cleanup
path frees those bitmaps, but only clears cma->count and
cma->available_count. It leaves cma->nranges and each range's count in
place, so cma_debugfs_init() can still register debugfs files for an area
that never activated successfully.

That exposes two problems. Reading the bitmap file can make debugfs walk a
freed range bitmap and trigger an invalid memory access. Reading maxchunk
can also take cma->lock even though that lock is initialized only on the
successful activation path.

Fix this by creating debugfs entries only for CMA areas that reached
CMA_ACTIVATED.

Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
Fixes: 2e32b947606d ("mm: cma: add functions to get region pages counters")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/cma_debug.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/cma_debug.c b/mm/cma_debug.c
index 5ae38f5abbcc..523ba4a0f9f7 100644
--- a/mm/cma_debug.c
+++ b/mm/cma_debug.c
@@ -205,7 +205,8 @@ static int __init cma_debugfs_init(void)
 	cma_debugfs_root = debugfs_create_dir("cma", NULL);
 
 	for (i = 0; i < cma_area_count; i++)
-		cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
+		if (test_bit(CMA_ACTIVATED, &cma_areas[i].flags))
+			cma_debugfs_add_one(&cma_areas[i], cma_debugfs_root);
 
 	return 0;
 }

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.54.0


