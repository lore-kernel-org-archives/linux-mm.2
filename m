Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB363C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C608F8E0007; Thu,  7 Aug 2025 03:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0FD28E0006; Thu,  7 Aug 2025 03:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF398E0007; Thu,  7 Aug 2025 03:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E8EB8E0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55C161608A7
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:19 +0000 (UTC)
X-FDA: 83749208718.03.9E99BC8
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BEF1100002
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/N7Uyor";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kkgUcN0etkmDxWZW74kDtO38nl/qqGRKhgYS9gb7Qoc=;
	b=VQ3Pf3H0asgOVvrHZ5X7J/gN3kbasi5lXV2t2YEz02T4xtGgyicR4aOHDT3c4uJhN9feO0
	hvlONBNBRm6za4bzegnWHd73WfvPqng+f1l5WF+p9XqqpdggJXJ3xaRpnC71W2whNPk+gO
	iHJinsfrn/LfaqwOKBhNbbkckEx3WEo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553497; a=rsa-sha256;
	cv=none;
	b=td3xk5e9b4eQ3EbRfaef1T4jdOfu9KkT0jMecghKSMxhqfeD9b4dQ1Ss8HAFBNlc+MIeQJ
	E5ZFxrRcWtIe/QSvmJQQ3jAjqDgyeeuLNwhAmtqYv/mdgsgsrzD/VK18BCG0QNe4/uGUwv
	Fi5iyUrjD1vRkoGRVI5foz3GKP6dpSM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="k/N7Uyor";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55b7e35a452so775496e87.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553496; x=1755158296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kkgUcN0etkmDxWZW74kDtO38nl/qqGRKhgYS9gb7Qoc=;
        b=k/N7Uyor5uKnEBqaksu5RabD2bO7QbnfW3ta+67WQhvsPH0Z7Ga2MX5516dbtsz5U3
         wT1NciLb2q4M3xqehyolhN7jUrKSwqoOdberCmuaZJp4JrG5AIdRswOst6cHFiIePUHC
         7Ad3Jk+bLmIQ+Xl3937Z1D0lb8P1Udct9JyHD41L9ucU9JIdNztuWqZpfB26wDMGhYoB
         Sk0Szm7Rc6VeXuQsASoBhkaY0usRcVKxDW6h2kjGKBIt3krtOzNRNk6MuFSYOpXbrE5d
         Iw969H1dJr++/ERcB6pMbN/6r0wLcm/yC+ABN1q4U3AV5ay0fnK/rS+Y0Gtbl17mIPEP
         nt+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553496; x=1755158296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkgUcN0etkmDxWZW74kDtO38nl/qqGRKhgYS9gb7Qoc=;
        b=qzt872dSJxX3+G3bU60eKU+3Kdqe9btamP6XLzUTfORhUoqPOwjptuHm5bFTO44vf2
         9dGF7snJh2ISHh+NabZ67sie1kh+WJtv8vi/zzZpGhXUa0WzWC0HKdSXyQ8AbtlEpGo9
         PHPZnGROHHFH7WoI1cEHk0PsA98zG8o+BgnTjeCrNyoPwLpQq5fHQ3NW+DKThHO+jSzw
         viXEkJILTWN4FPfUy1xQt8IQ47QEjQSWfWuDfgZ7HS80y1GeOYl8OqMOvN03/qNqRx31
         SajnMEMroK7JF/8F5cpi3gWzU2JnA11yR5+fEuJHBAjzFAbN6AKhVft8iOs/kzhTqqb+
         tcJw==
X-Gm-Message-State: AOJu0YyNtFv5hxJQTGGH3D65KR6RV3Avd+Rzr+d/D0AQ9X2OSRiKpZw/
	e4wzrUh27z7whsjstTblRQ33imlzHdof5MMHC97jcF8twh1EZy6hr+8jSlHvHg==
X-Gm-Gg: ASbGncs55Lwfmhsm0fHI/O0VgkSzJrBUDnOMuHUbGRSPJ5rUBr/HutF9MZxFuXGjAfd
	xJsEwLy7u0r/4nZbesweiDOTrj03xaT7HVTzFf4SJokYfvqh7EXyovc9mmAc1fcqKLogiZJIEfi
	rump+fjkJnUb8g/7V8yesvk0EApENbafMjk5d8CB3MorYfDnBVBaAXkscL3XKstHZrdEpIBFPqs
	fswHLf+NQ60jepyDlQBR+J/jjrCwir5rv4ksiIAnUvBmtYbCF4gH/dF9LWH7q7J5dv8oUSdZLWr
	a0lpsmBxWb38XuoCVH69Oekne2fJv6LBDNilbAyDMExg3Z8lR5gvbXzOTdjUd0r1UlC9ZaJOdrV
	oiVhb8oKIi4UcmbBTwBcd6xnddgWq
X-Google-Smtp-Source: AGHT+IGOcjP64D4GBMntjoVTHbHQlu7XVmla/+hekZ0Qvmh6kQrGAI+YoPjVAMyHSPY9JesHz+A3Jg==
X-Received: by 2002:a05:6512:1591:b0:55b:8afb:e638 with SMTP id 2adb3069b0e04-55cb688b657mr632064e87.28.1754553495200;
        Thu, 07 Aug 2025 00:58:15 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:14 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 3/8] mm/vmalloc: Support non-blocking GFP flags in alloc_vmap_area()
Date: Thu,  7 Aug 2025 09:58:05 +0200
Message-Id: <20250807075810.358714-4-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3BEF1100002
X-Stat-Signature: kocey1twwqyrb937xgjod8c4ngjamzbc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754553496-523310
X-HE-Meta: U2FsdGVkX18CoBMxDNEcJkGL42+KSEUDZpb7K0FYY75oWBRxQ3A3XzomJSUjKmtvdWKmInoCdYn2AaQNn23S8h3xdlq0avBGQMSAul3EqRdXnQhjJBWW4b5IeWwtuDA6lDOGuXpcbK/Uot1zm7+W9fZ5Pkc7r3+EHD1s2Qb7PTVkmRC/9Aqviw+HWMyPaWUHTzg/iljEkyFTDJeDACZdS4u4P35b37V55mWG8vqSEUgUYgGHSS1O4KSRt4mA7fz3wV4pLb64vuBcvAJtRt8uCPe/U6G9WvIg/8N5WFG3kbSyaHNH6XCmju4h1fGQZ1jykqx0tVjNsR6bXWUZW2rMKMKWl1Chz86LFbzoTn10OhfNAOCqE/1HgR2EZvNlx2FFgps4sf1yRQT2T7ZHkdqsudmzK6EcdFpv0M9XaWdq61rkR/gdjGrArCCDz5m/2R3V3NhOhTEB/Dug3TalR2ZMXNYKOegYm/lv+LRo9JSOve386uqqcuW+UUgUSz+18RviX10+O2yNsKFf4th0M5s3Z+eejap844Hrk+mm5yJOPh3BymB3HKH3vpobEbhQFqeV3dDkGxRXfNlaEW75dygFupw960WIk/DdieNNUCtLj2xd2Dso+OmLs/n9pdkppbjfFw4czvfRAif35c9Syxb7/OPZcC9FwWA30eIcPcndkvu4dcil8xKpDomN35dP55onqxpFJTGOYMqkKBTfot81AgzumeCXYnV1jMmYS7645qfv6JuJnZes/m0Q6BjBRXnIs6FGeuLC5lD58Gr/ODHPs8Np5QD76MPlDq8FYqUgY9hWt5CdP/047TJVEAFyzl9IB2wFN1WaMXZf9I6eHvF9TRujUbWQywQjH/tfdVfpLhm7UJGjgK7nLdek3CouzjoyQGmXJVa/PT9qhjm92ndz8zDpN4E0sFW2ynZd6yNgOZHEJzKHvoR+i9CaCtijG5Ie08PJdrRU0RpiM1r+AL6
 iRX8Lr/r
 xUiesqXSpdLKf9HiAnFLT1np0oYelW1My5cs5+c3uKB/009q4RscgFYkMFRcfgf/cbwfviSOacYxtEHb/YVsrpkhWKNIiv1Oh1hxOVS9mkkjsauKxghL2mcWBnPTByOU8e4VDhXkfZL2/g6AZ3zaAXTU18vW8UnACx7zv6xk0L+zUNM7mVRtItBPXpmYA4/kYEk1TIFwo79dZAd8zwFOFJzGMhXNRRftNOMfa7SZap6GpzI10zE2RQJnKAl1skPPWJ8N3CStOLB7VMstYWL1kqbhMoOfPZFbbHlz54r4ZhXoWn+r87N8m5IVpKwvs7HXhxQbESUoFUZkuqtqTuUlbqfUyOqHbVv+ZcjtwsFW9tSlKfsffJW1ycRWCF13H/TS30tuSI+qJ7PqobfgP2oL6jF24egoWqGILAn2lQ9tEPauxowBSe1dqj3TwjuU4x24FEF21tzsKj0kODEgo2ZzHWwP36QjDZY5SCjATjTRvLwZH1v3321B6aDku9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_vmap_area() currently assumes that sleeping is allowed during
allocation. This is not true for callers which pass non-blocking
GFP flags, such as GFP_ATOMIC or GFP_NOWAIT.

This patch adds logic to detect whether the given gfp_mask permits
blocking. It avoids invoking might_sleep() or falling back to reclaim
path if blocking is not allowed.

This makes alloc_vmap_area() safer for use in non-sleeping contexts,
where previously it could hit unexpected sleeps, trigger warnings.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6dbcdceecae1..81b6d3bde719 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2017,6 +2017,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	unsigned long freed;
 	unsigned long addr;
 	unsigned int vn_id;
+	bool allow_block;
 	int purged = 0;
 	int ret;
 
@@ -2026,7 +2027,8 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	if (unlikely(!vmap_initialized))
 		return ERR_PTR(-EBUSY);
 
-	might_sleep();
+	allow_block = gfpflags_allow_blocking(gfp_mask);
+	might_sleep_if(allow_block);
 
 	/*
 	 * If a VA is obtained from a global heap(if it fails here)
@@ -2065,8 +2067,16 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 	 * If an allocation fails, the error value is
 	 * returned. Therefore trigger the overflow path.
 	 */
-	if (IS_ERR_VALUE(addr))
-		goto overflow;
+	if (IS_ERR_VALUE(addr)) {
+		if (allow_block)
+			goto overflow;
+
+		/*
+		 * We can not trigger any reclaim logic because
+		 * sleeping is not allowed, thus fail an allocation.
+		 */
+		goto error;
+	}
 
 	va->va_start = addr;
 	va->va_end = addr + size;
@@ -2116,6 +2126,7 @@ static struct vmap_area *alloc_vmap_area(unsigned long size,
 		pr_warn("vmalloc_node_range for size %lu failed: Address range restricted to %#lx - %#lx\n",
 				size, vstart, vend);
 
+error:
 	kmem_cache_free(vmap_area_cachep, va);
 	return ERR_PTR(-EBUSY);
 }
-- 
2.39.5


