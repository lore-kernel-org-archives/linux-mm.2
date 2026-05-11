Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E0FCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:43:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB1A6B0088; Mon, 11 May 2026 04:43:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC006B008A; Mon, 11 May 2026 04:43:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69ABB6B008C; Mon, 11 May 2026 04:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5681B6B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:43:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F232312067C
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:43:28 +0000 (UTC)
X-FDA: 84754500096.13.EAA19A6
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 030658000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:43:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bx+CYuKW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NSVJMcCRDCZ65VHh5kS3ZBwZuxCk7Ny7ZgL99/YO4W8=;
	b=XGLkdmZH836KV/rc0FPXcW45jGGULeghum7w7CLUXYl3XpU29lr+vIVhmfrst/eznGSvM0
	vhaABPBa/noK38I7KPbFgCv3ksDCvKkTJP1kZial2mih1bVMnftyVDfyhr5BJq4JmETzbc
	lLPJ+dObDfK0rtit30DiwZmxjbTADm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489007; a=rsa-sha256;
	cv=none;
	b=hNwWnNQNdnrTT/AM3WxNNJ4kcUqzucF0oi1KgaqOmk2pQTobJ0JE4ct9AkEiBuufGWnQe0
	uygfVjoDM7awRsQ4a1ZEwTUOc/kvZ/k+6dnMTn/ty9HflgOVULTbLEB1weWK3Q5YxE7RZx
	z8gT2HGFyr1uvu47lqtdd9jzbdsFwr0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Bx+CYuKW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ba4a1a0325so28718365ad.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1778489004; x=1779093804; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NSVJMcCRDCZ65VHh5kS3ZBwZuxCk7Ny7ZgL99/YO4W8=;
        b=Bx+CYuKWmqlYmTDomVXOcOUcXPapPbPxYKGTEry369fgmB5Qm466lAo6/FB+COEEjC
         /3a/1DGMDJ9j2vhxKHYMyE4u5o3K5QHS9SceLZqLkyzJM4aPolTsHeMM4hsuZtYKv36q
         6vB3QlRTId4icdRvH1CxKyddeOONMERhL5jjpCj01LVMVBqs8YZtkFqhqSPvf7wLq3yq
         5GdHrpE94wNnLhWFiDMfT3XtP+OENpXfWYPq/XDtagQwIx/SEOCoix15m0Nv7TdVnE9d
         d40FVM5vcsJHFGDb6MWSlqCp62HBqJ568y0GdkzqdPfNrOgPqILpVRInZQYlnYJOJE2O
         IztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489004; x=1779093804;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSVJMcCRDCZ65VHh5kS3ZBwZuxCk7Ny7ZgL99/YO4W8=;
        b=PfGP3n29+5/gYRecygIYfSr0zOHe/nzrh+DFIBI7f2a9rdAi1ru1n0FMXsXBIcmZnS
         2bJmHt9WhwZNajp6P0yHngoT/lFalbK2nSaimrK+F+Wc4l7PrH0ens6PyI1fU0HUyZ8Q
         9Zu08fYoBHMKaCafdOT+IJIu4LdVqI3xL1jR+UXsQo+NRbzfyVloa3bYcMSGeLAgbIPO
         iSvKPE+71aBj8kPIeVC75LsI2NqZ6oOSfiwlWylfcEGjD/SfhKDUA3bl0y07Pra/CgXv
         JvLTnVl57WvAWHM6Vz1LXgj/vMIfDpwKa2KvTuoOonlqkjUTWdxL1TRrmieYhTEw6inK
         1Bjg==
X-Forwarded-Encrypted: i=1; AFNElJ+VDSRiBAclrjgMuAp3qtmqu8ao7nzf1XDFXn2T7oVVqq9gc3MLlQ3y/sko25ggaYBgREF6pxDC0Q==@kvack.org
X-Gm-Message-State: AOJu0YzKLrYLwAD+GBeXT6UXib2EAi1r/UGaE2bKosmZNwf4o6Qlq12u
	Wl8DNQwlVMsRg4gC4/MDf2mgZwmsxG6AagGLQEH/a2HbayOybO2lHVOEzfZz8E16iXk=
X-Gm-Gg: Acq92OFTBzdXPhzBH0UWPl+AS+AXS1NOgUeETtT8nBA3H0nZzhrOTO3AIGaPXZ7BE0y
	WRg3a+pYg+Hy6BkV4H0UiPmYU4G7H1zlgi1H4C5r5yjaKnqk5rZ82P7i0m/+fu10v3o6xbO6n4H
	R6UBe4OjqcdmNMpCYTjZwRqajTzLZEFHCRgjlFuEnZ0onwxnjpXj8AZyz0t8jxPH38tR2sUPdbB
	gs+Ld6P2fWlCim1WQ/NAFp6ue88FF76qwmJpwVOCrnEBFzt4aLX/Da3iV4pEHa7dB6Q+WMlcq6x
	6xjBX8C0Bx8QZ8+w/joT71DKzNJUeELY0HyzIQSSIc86jixjrfpx9+MjAV4pMXojAEjKIc/G+3b
	YuecoFavDRV0OunkawPrQAMDv18MxILOZzIVJzutdcc3T4YAgJqJRugKvRGz7Z3sDpLvOpwFwLS
	wyafYrErItSHtQh8dtirOa7btSpTC+NopRkHfoump7B1sAgO3VeyYkUw==
X-Received: by 2002:a17:903:1aae:b0:2b7:88f9:9c3d with SMTP id d9443c01a7336-2bc7a9a0d0emr95547205ad.12.1778489004370;
        Mon, 11 May 2026 01:43:24 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2baf1e35bcfsm94125535ad.38.2026.05.11.01.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:43:23 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: muchun.song@linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm/memory_hotplug: Factor out altmap freeing checks
Date: Mon, 11 May 2026 16:43:07 +0800
Message-Id: <20260511084307.1827127-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 030658000A
X-Stat-Signature: 5ckyry9o96bfh9fetqqreaqtm1ydhkqg
X-Rspam-User: 
X-HE-Tag: 1778489005-411696
X-HE-Meta: U2FsdGVkX1+Fnbb38u2J/jVm8rjGqOfrUQctD5jve5dJS6X5K/RuYKdDQqwgWMungDKoQl8iYYpzItz5cPzZqceKNiZaCThsE0ZN/dYDN0tlV1Jir4lpZvVBxVCjkS6s0s9GtK9u2ZxHBOs3MwfuwlKtTmzuZ1uqZ7REq1TsUfyyNcaAoHfmE4rV/NHHc4FHE87Wew+/QDpnrUUNkJWGo/4EwNZf6YTV9VSIUkO4MXB/OQ0tNNGaa7+gUCll5F4EbpFGm2EjO2QEL1C/74xSrEvhRO4ukmSQywqJdOn6kJ6LDdtsQZw/2MARwpH1cRSMk1e22273wPYET8RyTXIsLqeoUoOdBU0g7cKuMDqLC7CvU9msKFJKGwQU7O46VYpFMNtUikCC49+31ED3y4Es++06BGgW4PS/TvrC0E2HDUgw+WSr+Ea8VcH1Gr8n9Qf791P9FOQYJjMjZSuyOIiytFMavq4HMPAPXDFeqO1TSSRkvmDXeEQ+3OSY3S7ZpNSHzP2fWV4Shlp7XEntxLL+VPKw8YafN5RIY7wjIx0VdmoAIikoRDP5be01AMtfE47wiw22V/GdLMNCllUQvFQudKgf3sJO3wkMF7neHK3MQhK0gT+esgM8Jpe1FW7LO+wxF20wZt2vM+JLvQPQKcAqDK18SbHR/sJQFr91LroWqT+s9oPqHPG2Tw/DS1FGtmFO2d4Aa2gr6aGCWLow8pneS7AbQJoaGkGNVMFvGOp2MO92yuI4SvVxSwte0evcluhZPGMsQPyEWiARGEAFOh/Rh8+eY+jBi3DCcrJgwoMo8u+fW4k+Z/7i13xC7OJbjmTk+faPixQ7KNyZnfhu5NuqwRvBGd6nXCuYISoFKLVLmoQeN7rWCmEH1kvOyJgDVS9teV07SvMmRSrWoLU94OyF6OizJSXDPwIzGdEUBv3xjA7CKFN7cm8gQJjDWIQgICT7m1jzL4HKTBjnmsTsN4l
 KMrbI3WD
 L2B2klSoxROdxhDovoKwMEc1TiLrZf/RNn2vpCfzuV7oWLhZSVqIB3FUzeSJZLKwG5ZUQR+92974JlTpi1kXkNeF9m0itYmu9HKUpRX09+Lr97CVkpCvfozY+t9PS00j5MgiSZOk9Xh4RERaeGf7wP2tNyfRItOK3QT8ZtBzUhVD3numcJzxp2mczQImUu+s6aZgfE4JZGfvhojzOv6Vi1ppr1CfOya76ehMpJJXNM9YfSFIxPoTwuLyKLXrFJPVhBQnNnBtzJc/r5WKfIyHv6Vgv/xvXI8ypJxz20Tf/C/P5EOP2s5S9DvXlikwLZcyUzWfvYPtMaTOhe7prV7ttTJAv6r0vaH+0iQhSZGT1MzxZMdpS0PMSmL8Xm+6YrCD3ugQl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use a small helper to centralize altmap freeing after verifying that all
vmemmap pages were released. This keeps the check consistent between the
normal teardown path and the memory hotplug error paths.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memory_hotplug.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 462d8dcd636d..af5489f03771 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1403,6 +1403,12 @@ bool mhp_supports_memmap_on_memory(void)
 }
 EXPORT_SYMBOL_GPL(mhp_supports_memmap_on_memory);
 
+static void altmap_free(struct vmem_altmap *altmap)
+{
+	WARN_ONCE(altmap->alloc, "Altmap not fully unmapped");
+	kfree(altmap);
+}
+
 static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 {
 	unsigned long memblock_size = memory_block_size_bytes();
@@ -1427,12 +1433,8 @@ static void remove_memory_blocks_and_altmaps(u64 start, u64 size)
 		put_device(&mem->dev);
 
 		remove_memory_block_devices(cur_start, memblock_size);
-
 		arch_remove_memory(cur_start, memblock_size, altmap, NULL);
-
-		/* Verify that all vmemmap pages have actually been freed. */
-		WARN(altmap->alloc, "Altmap not fully unmapped");
-		kfree(altmap);
+		altmap_free(altmap);
 	}
 }
 
@@ -1463,7 +1465,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		/* call arch's memory hotadd */
 		ret = arch_add_memory(nid, cur_start, memblock_size, &params);
 		if (ret < 0) {
-			kfree(params.altmap);
+			altmap_free(params.altmap);
 			goto out;
 		}
 
@@ -1472,7 +1474,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 						  params.altmap, group);
 		if (ret) {
 			arch_remove_memory(cur_start, memblock_size, params.altmap, NULL);
-			kfree(params.altmap);
+			altmap_free(params.altmap);
 			goto out;
 		}
 	}

base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
-- 
2.20.1


