Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0B85CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E1348E002E; Mon,  3 Nov 2025 02:53:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092348E002A; Mon,  3 Nov 2025 02:53:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB2A8E002E; Mon,  3 Nov 2025 02:53:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D82568E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB1FC1A0ACB
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:09 +0000 (UTC)
X-FDA: 84068530098.10.3ED481A
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE83B1C000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=I9ss6mEH;
	spf=pass (imf18.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ky+X/IaBSB0OFL72v+WlIKaOZyGxRoEyNHwdneD4KGU=;
	b=oY/b0jZ8uEsH6JzLBfDzwKuQD9o24Ozmx8q2p8gBEIwqUkQzNYtHg7J2M0SXRdNWmMcEd9
	W+gKgGm4Mr0qUu+pntSfdF7rySlVEbxqh1ZoSue2mBMGgUIGtMNhziwN4c1WyUzuvntNK5
	H1UgUOoFx2vjHUIPOJy87YAq+uSpQoI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=I9ss6mEH;
	spf=pass (imf18.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156387; a=rsa-sha256;
	cv=none;
	b=z7SnJ82KJMxUifVHM+0GIWASnxyGXUn9/Z6+0pmxuEgF6I1yic/E5pVEoKkbjbCZjyoTjs
	tsdIOm/6hnbqpU9mcpzTPmbFxDbuM2X2KVq5JtKilPTWCzY5KBOB1ebt3j2+l1RSXaBwAg
	Otl8nHpGDnvWuQFJmyjyVSq47p1pqrE=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-33b5a3e8ae2so4217418a91.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156387; x=1762761187; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky+X/IaBSB0OFL72v+WlIKaOZyGxRoEyNHwdneD4KGU=;
        b=I9ss6mEHuaQwIbpXIQSHdl6wt8yXbirJDuFhUw51XV3EUSugtWmZaUXBI9xmSxAjzU
         cbrgFACCORyA2qvSEE+/LakJ0BPD2sSjDvRmYkTaD4XgmJSNYYh1NkZZQkWRdrNYVIT6
         YFZjW1ykRdqjkAvi7BCoExLGYgW74p06UruW3M5+5FayEFIO8CDv0XuIdmjRjIdOWVTs
         iUp+waarproY28xIoSciH6Zouy/Leyfd9aShbPz5desY5Vaq9MeFM8vxM3w+iNNXR0u0
         XmlVTkbZJLI/z9G2yDdKC5e8VRFNbiLKNqQzGmaL/+4ykCUOnribVyBI4LED/OdfU28j
         efAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156387; x=1762761187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ky+X/IaBSB0OFL72v+WlIKaOZyGxRoEyNHwdneD4KGU=;
        b=rOct9ezyYZH/fgVvj/xP4DhB5VaxryWyvMV/L+GWDgMZ3G0ejBEPtu4a4NpP/43qFu
         oYJw2EX3ORv4YyURcjNnELngaB191E98Y1g1EWYGC/EF9FCbMHWgKwYRpjj5suAGyJnk
         i6eSsSSs7cOST+87QkoNga51lui7Vqm8zxjGGq4iVB4mgSwzxh5/YMUYew606hVvMurB
         wWATq+gD1xV9wDmBSqrJYgOpGPS0MnsHVaoe15uD6o6uvpNSK/d7rCuG0DQVuKGYz+kl
         voUt6Xrr4Mnm7Rfj09iuFd8Frp7Ndw55ohnEEuOEU+I1XNlRAoSctiQB5jmVBMKBuwYm
         E1mw==
X-Forwarded-Encrypted: i=1; AJvYcCWzDmPOvQvonFLBY7VHxHJkAOl7gc93bdm/S+lWg23YPXz43XH0/7HApc6ScZzrrF/7rQXAdU5X1w==@kvack.org
X-Gm-Message-State: AOJu0YzyFM5nUXv++8578VAKUEyj5mSKlDbrqoM5lOR6F7AeBo2vIMyM
	8BAUy24ph+TONSfx236vH1xIZhtxc2Y74LaOuuFeacdGkMtarebBnlwtd8rpB50ys7Q=
X-Gm-Gg: ASbGnctjfT8FoUrqa6fkrLh5u8EvabQ1ruO4+2zLDpiIUNa+HAHnxT9LLSd7p6vLelh
	z/6lk467xVRQoZLM29IakvtP32fCR233CX8WJjaOlIY++bWXMFhrDRdQXmzvKmaqgUyC4u4kQXW
	KQZcaZamZIDwd7zfkLicpTPu7uohMM2gAFNl5oA1cV+uDRfNeBoQ5WNMleDCi2bsOhYa6tyTo7c
	ubAMPIP6atdpA5Pk75kS5v300iDq9SANb7t1xk/HrxL+cwfzvGowhzhAXN5nreH20aY3FcGBfsY
	8bl8+TYQlQugrx/ghjVfQKvVdCVv8mXUhj68z1JMgipiMkP9/DO6g11xNNW75+yURaD4iQ8OMqA
	bU4l2drKEhVMXIEg9LwtvYIN6ogkJU/yG/HVPP17yG8mYW6r6JEvDnV+78+A8mQdEWDwL7/BIB8
	5l61dNjwk8K+HlMbaWnwo4N6qrmP11hRncab4=
X-Google-Smtp-Source: AGHT+IEyO5cEySxDDsa5P6gc4+o8FeVcq4k+ABlDqETwxZQ5qkG9gowGljWIIRKONKOHt2sI5vETgQ==
X-Received: by 2002:a17:90a:d410:b0:340:b572:3b81 with SMTP id 98e67ed59e1d1-340b5723cf2mr10885892a91.11.1762156386624;
        Sun, 02 Nov 2025 23:53:06 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:53:06 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH 6.6.y 2/7] mm: memcg: add per-memcg zswap writeback stat
Date: Mon,  3 Nov 2025 15:51:30 +0800
Message-ID: <20251103075135.20254-3-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BE83B1C000C
X-Stat-Signature: z9ghjdu7bi9qhndw7b8ta4ga6asgqcht
X-Rspam-User: 
X-HE-Tag: 1762156387-935140
X-HE-Meta: U2FsdGVkX1/IrJJWQT+N2/Cw95YLmUIoIE+5vt9tJvat1wCJGPR8FTQsrD/iCdUutcnxYci3R7ne6bLkWaDpBCIiudEhkk0h6Ccc4WR1fR5KW42jcNg6SwoUgWrs/H7NVdMqh1rqAz9C3i39prfus9OVcYw1y9PIFk5MtP0ia/lpgC5FZI5a01fP+2VQ4En4sQGWFY8FLEqLpX+7p1py+V0Jpo8mz9vjnYdWhY7yRsaU0N1aHDmrSCdZDdw+RHfNNtNmyZWbXlKiiOl+Fp0oQr3odPqi7eV2isOmb9Ti/zgdlXUDeEZrYvS8qqR2kAdljg1XPQA3qoNbStEpRwV28XgoYGfmRevE3XwICMR5HHx6RUtD5JinyaSMugKwjmnNQxL92M6r39wt63Oh8kl1+mobQqDPoW4Q1Qb/ItDhht16JnuEb1OmnUWeuifrJDXkqPycglKzromwaj72V3f/Ld2w9d+8Iy9gayz7/mgcr1+9h+dq2onhae2OJPAYxc9HOY/q0xud/kfT1xdsLGrFyYUl63heM626VVag6J+m4bb7pFr9rzWkN3BhS2X4TXp7qLfpQBHVtqRbhAyMWrNao3lJHNIyOwrn7MqOvs7sP9t/ogewGqyHSMbcpcR2s0Bmo5AXRMxR9RaEQ9pqWOJFOq5/vmheBwqrvvSEMfVzzOAjH5dg1gTRuqdPHp9c6LiY33EEXGCxp2UI+yMkepba0fya0fN0qP3/g8/TX1mqFZe21GQZUXee5jngS4DJGwJbWS8ADIsAIa8bYbaN6kbYTpPAhDRn55RBfbs1LO7mh3Y5zD2F2dqwc55yZX/bKibQWN7xrTdLG3BJZhaKs5qVMUNxTxe9d4LtG4E7/KCWi2nWl3Sw3LHl96yp7hdz4qK9/9LRKIQnV/XOrH/mnxVlxexGHN4xN3KP5dV+fbiMXEhJBKUDZ1pwmFfsLH7bJJRAQQFy5fNCc59NoRbnxol
 RdeHlUJI
 YbAknWiDIO0XrLkos4mb7IlUDXHWfLZum6zFPvhAzTW/UYtflmzSUMhZVdkKR4OlGNKSBJSLErCHnag+89XT31CapVA8qrKKTyCjI2GFSrL787EOP7ne/o0C4q4qiA9/pSdnEAzWMZcB1NlwSXWce9vdf8JJF1/JeGva1gW+ORxEn1WAdg54XOYiA8KgTXrirNme9VZdLmVmGEizojivra0YbhJeBclE+ixe+Xv/QW0jPPBdzurvKjThn5FHkJ+6VZHJN3LOQ7cHDLt42GL8OUYMwbZpxaRkPTUXVM5GpgtYJ+PgD/exsTmhnXf8RPRsnTjbq7N4YTmrdO3//xiIhrXD8HzTQH0Pl7zHq1fVXOMoWqaqgGM32ixAf5L4atEI/3ibyCaoVMDJ3eWEx7v0CpS24bnyh34craF162zHZh1Qg73HJGVIq3JxAYdaWNX58zDA6Ato5YtwlxXga05l+sO+6m+iug6ITOSEPkzvothpu/XKO95bZbuP6Zy2ZzpYB0LlzpBwiyWIPOhmvWcbKzu7+CQUrW6oOP4QZk4fpoTUxwiqQ4EzXDdSDfY3dzpchtHwO/G0DLYvunIlAx7U1xUDXaP4YAmdPSB385wAL55ZikKgP1P6SVlc2RPkM9YGQ1VUIRLdKgzHoysKjsV7Db2WI8JdfseKxYfiffheDFZJzEGLNsk8vjCh3L0x3ToAnbUx3pXWyzTuJBXwY47vP6NfS7ekVBXWVEFkH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>

[ Upstream commit 7108cc3f765cafd48a6a35f8add140beaecfa75b ]

Since zswap now writes back pages from memcg-specific LRUs, we now need a
new stat to show writebacks count for each memcg.

[nphamcs@gmail.com: rename ZSWP_WB to ZSWPWB]
  Link: https://lkml.kernel.org/r/20231205193307.2432803-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20231130194023.4102148-5-nphamcs@gmail.com
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 include/linux/vm_event_item.h | 1 +
 mm/memcontrol.c               | 1 +
 mm/vmstat.c                   | 1 +
 mm/zswap.c                    | 4 ++++
 4 files changed, 7 insertions(+)

diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 8abfa1240040..b61796a35d2b 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -145,6 +145,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 #ifdef CONFIG_ZSWAP
 		ZSWPIN,
 		ZSWPOUT,
+		ZSWPWB,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c61c90ea72a4..03a984287e5b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -700,6 +700,7 @@ static const unsigned int memcg_vm_event_stat[] = {
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	ZSWPIN,
 	ZSWPOUT,
+	ZSWPWB,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 57891697846b..3630c6e2bb41 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1397,6 +1397,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_ZSWAP
 	"zswpin",
 	"zswpout",
+	"zswpwb",
 #endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
diff --git a/mm/zswap.c b/mm/zswap.c
index 69681b9173fd..a3459440fc31 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -674,6 +674,10 @@ static int zswap_reclaim_entry(struct zswap_pool *pool)
 		goto put_unlock;
 	}

+	if (entry->objcg)
+		count_objcg_event(entry->objcg, ZSWPWB);
+
+	count_vm_event(ZSWPWB);
 	/*
 	 * Writeback started successfully, the page now belongs to the
 	 * swapcache. Drop the entry from zswap - unless invalidate already
--
2.50.1

