Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D34ED68BEE
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:32:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC586B0088; Thu, 18 Dec 2025 03:32:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A646B0089; Thu, 18 Dec 2025 03:32:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7456B008A; Thu, 18 Dec 2025 03:32:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 688B16B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:32:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 343A4160DEF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:32:05 +0000 (UTC)
X-FDA: 84231924210.04.69D0DF0
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6ED69100008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:32:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T+htpOEP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766046723; a=rsa-sha256;
	cv=none;
	b=HNbf/JsEdgnpM+Reu3+Z5zEYTjO0CY/gIglh5aKKhV9am723wV7CuN3gy0ypBG6HD1mLND
	hoFV8Oo8WWiI4G39Eo5M52LAOZk44/k+hXOjo/9DTbby4hN7otPziH++PCFkSiWkYfnMje
	7GMkvingYFOAyEFOW0uLMCODWRmuz8M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T+htpOEP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766046723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BD9Vhiz0c2yEOsE49k+C0PVRmnQZoN1zMYvcjJNrras=;
	b=6zUdd53V0mfFc4Z8Fzx9xqq3QrIQD7P/etyUd7Ujh0qJSA4E2lBRSTuQdK9JIgfxu81Ltr
	6l7Fl2+WXSiM6/A8cSX9GzcKdWi0nC9GUDPOBlJ1PXJDFVulbrkWR0eUJgRXAWu6kuNWEM
	00gHnolgV8AVevsyPUyXAJPMeb7tPYk=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-78c2e5745bdso2960817b3.0
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046722; x=1766651522; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BD9Vhiz0c2yEOsE49k+C0PVRmnQZoN1zMYvcjJNrras=;
        b=T+htpOEPwDr+6mMrrorF6zIPfKShxnugiAkYj2fJEBO3nB274Y7PHafVxMlz5e67Fr
         BFJoxCXvBatjm3MHPYa5cmWMqhQpIJs6MXKOByC9pQkrAy6Y/VUenHOlcmbtQAlOUH/V
         iqKPGZWNFnus9aN/WfdKBgud5CsH7WQ/Jkxep5yv8irOJ5E2eIzMuL4PkrDnGm+ic0sE
         F946O9vVTjM7yFThdGUEaBUvceKydOMjyLgQx/PrAE2Jcl1P8zTmKJZ7s/D/AI7AVzxT
         KGZGDlJvcEn7RN4CCrg9Jdzpbdymkrhuo9poi14VKJBL/1wSLooF+EOrKvqkkYAhvQBH
         +Cyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046722; x=1766651522;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BD9Vhiz0c2yEOsE49k+C0PVRmnQZoN1zMYvcjJNrras=;
        b=rLC4wOOcYHkUM+zla4UV9icjeaFK5sSrNvc7Q2sKKxW99yArKgovEy6GuR6JiZMRCT
         DRM8D1XIGLyU1JJctlz/rs9xIDSb5e3ODM5bvUYJ3c5PIVx+8whJjDe/q0EU+ZGPFJKn
         fdAR2z+Nq5L0XEHB0i42Fi90Lv0M1N0K15eOXtGT2UuBAdLmItIIWbSJUr+QVbW1R9iY
         scx2ybzh1F8wAbjO5KlA3BgeIoTV7MBZesShsJ3tTVMFC1Ck+S/VpY1OEiw0rXXgtXAT
         m8XOOCGpbxE+twMcYMwmh/mezQVoHcPJTBGi+MZceSs7HzE3pqr5Jci5QSxgyodKXQZL
         p25g==
X-Forwarded-Encrypted: i=1; AJvYcCXDtlC1tasdVl2tTG07ptABlUdhTf/O5ktldeJH7EEg9FrirTiSxzUTKMF2lxU0dA7C/ZTkwQPjSQ==@kvack.org
X-Gm-Message-State: AOJu0YxVhsajBNdckMjTZrxr/6Doa4DG71oxlhQSVtG8+Op3qOWkJUOo
	WplylmuL3cKkb44ORTf64YftRyxugvmeVS4y/UtwuhLRAUMda5d4EJU3
X-Gm-Gg: AY/fxX5Xsc/j69wKXk200ejR5zgceTUhy4clEZ3PTvCGXmDQyf68tVgXIN/LbWtOsqQ
	eHPth89/VxybnC+eWPzzmtx3EJkKm1yDs3J4L410DzlscHozEz79KusScWPOzwR/UEWwaEZUbg4
	FUJ6YukfDZOa4kXPJN3MlNkjrx4j1e+zwSHvt1WuW50uClJO+AwqCkqlBwy+jPHiYu0YotztBRh
	TKtMblkaP+MHLOcYv0LI8TaNVWTOXyh6EImcFn5wNgRwZlIr4hbErdOUPt7WRdfoxA8SWRvB5Ge
	1+m+j8kuV7RtGw9BmHF46oYZEn8hThQZoFqKRjnuzv378vN727oNPBCx4sNWq+Zv+vfqe+DKr/p
	k3bhW0EP+P4VO+laYjF3npkrINtrC5aurMDWLLENWvEubuWN8gvNrm6myFo9+ie3WmY4hEnkZwO
	txlDw8EygmYiw+s8NOnHW40g==
X-Google-Smtp-Source: AGHT+IGzrwYlmJqo5DfyQ+cUmhBCqgSSMbdNMu2jt9PuzmpP+TQ7xxkRZxozhfM/43jSjbqC1bzRoQ==
X-Received: by 2002:a05:690c:4442:b0:786:62bb:f6f5 with SMTP id 00721157ae682-78e66cd74cbmr316793337b3.17.1766046722375;
        Thu, 18 Dec 2025 00:32:02 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:71::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fa6f51fa9sm5851527b3.17.2025.12.18.00.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:32:01 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for !CONFIG_MMU
Date: Thu, 18 Dec 2025 00:31:59 -0800
Message-ID: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6ED69100008
X-Stat-Signature: pixrsyssa41aka19rtmi6kjgteepm7ro
X-Rspam-User: 
X-HE-Tag: 1766046723-622987
X-HE-Meta: U2FsdGVkX19LH5Wv4MWXzy0O/DnCCnr4cwu0ju4KYhsoUilv1kg+C2G7yxhPbo5DdFhIgUK3+Xjc0a7s5PDUMOb85jK653ZxE4rofC5jtblYKbOxjp7qUX74I20cHDKWmuTNJbM1x1eXpGNVG0Ekm7C6XZK+ifzqVrYOPQ+b7ZAsfFbkhWMSZVqdM1VpcSwNooIeLJnhDyKpaqOiXW0YBlHXZTRIixU7RZopKxzFPCycV53uvvCRhXM4W5sZqIGlFiM3DfQZ/qoU1qN78UHCyxAG7BGrxiltW7IF2Kkrjw1349H+14zIQ1EpO4sqoiNxQ7lWfvCmDu0/4ZmqkYenCKI+91OvfVjHxOnkcyUv0gT1PTcpydX0APKDcPpg26kzETm6NjnVFl9veDeVROZbFhELpyfUJ4NK947++F9lphe6Wvmb14UGvk10/HczFLcayuX6KjOhgeP9ADI/24xXK1e4LRvq+NfVKIScFBevLJpTgmzV4w/im3/83d0ztQPrW1j6meNIzjfUmuL7Zjig3qyJQTyhENPsRFLmIqQKAdbwjwMdDtRPJ9Apn4yO9PuBKpSKysyhlnEIXbbQa4FEsBL7vWhdL8mWRpSxWzt4bviVQwAcML+qVl596HsSynN9V5VHtBOqXpyDYypKcY20HD/yyKZIhBRhF7sb31S07Au53uzXndFfVcJ8hm3hNW/vPRbkhTsSWoM5a6nGs2dpRQuqvh3PgKlOQPFK9FWMRRwJmzL6nUmx3ixa8YnKp+cBjo93HbOltqOIv+Lc4l0oqxzOZmxPLPPJ/6j3vZ+z3mcmazhyXO9VVXaXDjDIErQXD2Vglh0kp0oaZ1Sm/88xaNUQhtlrSxXi5mDfYAKfhvFjVNEvfzFcWTx/by95qLNKCDH2+0eA3xLPDc6wlK7do8FI8ffi1xuto3IGisx35yp7moLzDhhuJQrteGjurZmw5pxDpWLAju0vRy679l4
 TyuXqtpd
 ug5lkMgwdx931cPhTk1c9eICdT6pb4NOb1E7qXnjpP6o4ga0dLq3ouLr4esg3nkj6kAgsCjJNV2j2BIX4lAwUbFowTUbh6Xq9t5LaFlgLlxxNLyhyiLuj9usYKDlTvKaSndjLqOMqcd0LTccy81XfEuM1vqeMSihqqANXdQNCVyQy2TtnywuFYM374S37hhBQxIA0m3/7dE6mOE7DovWkQw3Twh1sZOPdQlGVlT/54WSZq49/mPA11aCJEHt/nCbw22IV2VRrTmUy5Mx9+57/iHmjMs18RVcv4VGnNkeaHPKkFJbsaPezFD9sV+iNAMyD9Moz2tQlfXT+r1yhRoPUZJnZpfNOQQyTOe3XbCqmLqTFHm/3c49v9hrGLkYux0HsxfJv5r2P5dfhAtshiowBRbTOs5V8jrs0sJQuOeSyK+6ppMNHkCAccRbj064fA43fcEk0vrx8WJYo9ik9uO8FgUQfltwfgRmZYJjN0dmUnOAiLNeiHKvPTa6eOP/KkDlgXvzyLMOClO8nyzYlfokE1SjJbvVlfIS4S9Rax/31IXLyXuDskgY7gPRucXYlq7uHzHmQr8uR3Sdf0KNAkIZRhdKe3MaCKEijJzW40b9T3Q7H170Zia6KRgh0GxWpBWIKEiuJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
moved the error handling (0-handling) of zone_batchsize from its
callers to inside the function. However, the commit left out the error
handling for the NOMMU case, leading to deadlocks on NOMMU systems.

For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
the previous deadlock-free behavior.

There is no functional difference expected with this patch before commit
2783088ef24e, other than the pr_debug in zone_pcp_init now printing out
1 instead of 0 for zones in NOMMU systems. Not only is this a pr_debug,
the difference is purely semantic anyways.

Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
Reported-by: Daniel Palmer <daniel@thingy.jp>
Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2:
- Instead of restoring  max(1, zone_batchsize(zone)), just return 1 for NOMMU
  systems since this is simpler and only affects a single pr_debug.
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 822e05f1a964..977cbf20777d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5924,7 +5924,7 @@ static int zone_batchsize(struct zone *zone)
 	 * recycled, this leads to the once large chunks of space being
 	 * fragmented and becoming unavailable for high-order allocations.
 	 */
-	return 0;
+	return 1;
 #endif
 }
 

base-commit: 40fbbd64bba6c6e7a72885d2f59b6a3be9991eeb
-- 
2.47.3

