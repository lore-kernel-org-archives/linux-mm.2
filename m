Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EA1C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87136B00A0; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38366B00A3; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B26766B00A6; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FBB6B00A0
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4305FBBC32
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:22 +0000 (UTC)
X-FDA: 83749208844.06.FBFC8A4
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5EE5580009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zy8wYHPh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PB2hdcyBc78jv+lWchIG70ZsML6HrtP/MWqUFpv15TI=;
	b=GmX7vyJjssyt8kRQoA+v/ebSYx+g3Ixi7hfgo5VZk1oNzn3sxZWyOQBUU8OHUGw58Ti3JG
	ucmRdkzGguZ7rANyV3mVeEue273cXW63HOSHIaTgrXXHnk+aIJpm9dVWy+uzGzximzB68p
	Qw7ol15/9zmrZaDyHNIG9Pl6cIGz/HM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553500; a=rsa-sha256;
	cv=none;
	b=TCRn1HXObWo4BZEh7lcJubFEpbT+U4TN0kTBHXvxSunCuYQ+dwBIFTjJBtaiMf2DL+iEjE
	UCmSU1M1NQTFfZPu9vjOOxeUJLNFoZXWZAcYYogzer4tD5GSA5Cq+zXhz9c8YvEOafpS+C
	nFeWXL0ouD1X4T9635hyhrxlthLE3EE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zy8wYHPh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.45 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-55b797ad392so799377e87.3
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553499; x=1755158299; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PB2hdcyBc78jv+lWchIG70ZsML6HrtP/MWqUFpv15TI=;
        b=Zy8wYHPhAd7f6Rd5LWXLV7NCJ/HaqSDOOEtJEni4sC2Rn37WQShT/plSnnMfYKlgLf
         SOSyy7IOJFM7vq+QZaHxI64VaeU85xvyyR0Rw34i6E77zuCvMVsc7+G6N843soDZdg94
         ey3nnjjp9nIX2LUfPwtY3Rohx49rPOilsbEhxJdaDDJZ82F0zBwP9aAZL0FWEAbP6y/6
         FoVhn9FywxMMkbkqZZCpfinbir8NFmKErQyNGkA8wL0ZrpK3sAgUbYgRP98QmdHtv2Mf
         Z1V62TMRVm0Hl9My2wiEG98JTav4fTTyTD/Sa791lDPurVBRsOVfh7HZzxnjKFkfWS8d
         YY0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553499; x=1755158299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PB2hdcyBc78jv+lWchIG70ZsML6HrtP/MWqUFpv15TI=;
        b=AOWe0kmoptm8Bw5tNxsIECj7h5aviLCJwEBcrjVZG/4hI5RVMPBZ2x22WAehMb/Qxs
         sTy9W9lZ8mr7cSE90BigYRQEFdfexD5FBVBo/3ffnzeoCoVDuY2eG+UB5ghgYhcXwhBo
         zXeTq0rTQS54rrmNoKxc4lrG8BAQEPCNyZwHGdGeDoIZm5sXNaXgDdYRp0XQyLQrgaY+
         x/FKtdzVTKHR+czrwraHtgW9qjbGHbIv7VLzu9PyvJ7TnVroFFQ6bbrbPoE4pYEzo9IJ
         8HFXLu3fPmlq+xFehzRIi/USiAPFHYKwV/GCrNTXH17d4m/QUJLtnHeBOZJ1I0oieFSI
         u/0Q==
X-Gm-Message-State: AOJu0YwwNNYsR4SOEysY+OczPNVqAu99RzJwNkgF2+iu8k95vY57azlB
	2LgPShZfem3n4C0X7HFPWbq1IlnXXqCQa7029aQaisLTko51eFswyUBp3R5MAQ==
X-Gm-Gg: ASbGnctnScEhtjxYmKyB4gkXhiU1t31+l+jR3oPuI7qg/yc18X0J8YiLKO+7H/0YuAr
	8/KcOL0kN4lpRqxCOXsHDOhpq9mTjegmTEmzjj56Ph9O5ondI6WlaK3aTJLSthRPAJ/k7tA8L6a
	DqCFzQzIlEFrBeiDdhY/0B04M2I8C0VdhkpqdVJZnx4Vpu1u0xHHdN+DmmKZ7OWBRY92fD9k3AA
	YkZjVnY8f7i3B9GHv524NBE3D4v5abMbPzmXocehJRcb1xiooMRrjni/EvtMe1uArxsoS7Q8gwR
	ZG6aATBz5Gwj2X9dhaFnWBgA1zFzguUiGmwG5MLVYEv4N4nd9Fes1caz1ozzf6mIPjG2xoBE8NQ
	54ug5GSwn8MmulfE9pA==
X-Google-Smtp-Source: AGHT+IH7eNza3QdzdJI0nkjydHqHWK39WdUxuso+aZG54nOcbhurwJGo0pLdj+Omq2eD29gZqs9iEQ==
X-Received: by 2002:a05:6512:3b07:b0:55b:872f:d732 with SMTP id 2adb3069b0e04-55caf5f3bc2mr1863131e87.26.1754553498550;
        Thu, 07 Aug 2025 00:58:18 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:18 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 7/8] mm/vmalloc: Support non-blocking GFP flags in __vmalloc_area_node()
Date: Thu,  7 Aug 2025 09:58:09 +0200
Message-Id: <20250807075810.358714-8-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5EE5580009
X-Stat-Signature: iwbqrmm5foen9minorsw9efmyhy1u7ed
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754553500-795415
X-HE-Meta: U2FsdGVkX1/eJKkh7EVJVRY/he0SaX9jYnERNzPjTZGepXtAada8fig0dQCx5ve9gNfhhK8v+kFLCmtRFVKcJ+QKTOTJx8WuRv0PJ6d1tm9rbIazOxZrvYwtKQdJ8UbTkiEF3BGL0EZgBN23M/uvczUey5bO0JXAmPZ0tonG5t3Y0zuw/pl0to2l0zcaUj7+p05ZavK47C6PQ952S80NOTggw8fusECiwjFsL5mJnvacSlfNiFj6w/uR7FcM7I5hHDELQr4g4RelymNh/iS4c0e4pH4L6CWXYO0vRwws0/tra1fQ8MXc+z/mAOc/8ZnjjNFMaN1RMNHK6YDtluHlGXqrGOJ8nOvioJNFXvgFV2OmBXUvj/NgeHWOs9+B4rkAZ4UVhNvSY8/8ZMIDkCh99MJjCwsE+kg5M0OoNFzF4xl2Lv5yRfzpXLkSscUeNRVgIpQd+shxOa1lv61p+0EFhds4NIfu5q4OyymYslH4VwDwicLvX6nNayDts/gmL+QFfh5KXLtfZF849RkleKeZUkLdPK5zslFNlkRXPmXrTl5ZdAVzCtRfortJkohl42eJmhJ9pUriI+GmoOpTpM8/r8Pde63AQcPreq9YVIp98tp9PgHfctFIAV/nCmCp6/GLsJCaTOZ/6tgXosq5FxbT+aVhXhPvc+lyTHgWGP3JPQ/OMQh2vuqFOtEGytNBc+Q3EKdI8SB8yUbJxRy3tVjsZ3bLC/5KDuiiOyT3CUPHgnE2EgcRk6sqy2PlhhH9CZS9fORGGjaAEHsky58pDIAbjzWu6ZgYczy2yjXHq0RC2im+b2UwYbXXvxKwllesKVENCfJpE6NwTVB7j4Bvg9nOKA2bIERqsmVYfJKlJrzQ86hoGS1Xv17T9BAw3LdnawAqS7aLK8La4jQGZAYP32ZiUXlZD4VTFvXr4j3GippK2yO/1eEyE/CFoZ51n9QgI0+X1OxhWdi0JwBLTi7iyfy
 iaQkBXFx
 1mkLLN+yDX6geWYwBmXWRKXP1ZjJdsAs+RcuVoRpL8Nboh0TFWDkQADFmQtZOhdg5d+2gYSeO0tfPEry+FWJ2ViWL24AIXK6sJjXsgJSx3h6HQX29iUWYv+GKg1tKM7z33WTLNYWXxFI0lzH3PyWUGYbUgDWnapVAsTiVIyN17XHQWQzYkkT8RM00eDf56DEZBqGiVWHSeMuRy1O7BuxqVQNvUSTufflP5xpoJGAaicYuRvJ3HQEvoTuvA2zz8uZdnCFejcCSbCxDrzhmjxj+4RudiGh1VFXippNttT6QuohyqRi8l+xBnf2NHgLUP64SLIw24l3fPgrs7UfZOrVrC3Xf4/lQEWp7zMkPWesLGGe2sJNcqPLCVenSike0M/vgePJLDbMCJbobd3+2RQuIMVK10NycfOpGKVgJJzYkpWmjD6vg4s2CHKk2GVvgVSeZSlLMZbY0c5uoyb8w3TL76K9DWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch makes __vmalloc_area_node() to correctly handle non-blocking
allocation requests, such as GFP_ATOMIC and GFP_NOWAIT. Main changes:

- Add a __GFP_HIGHMEM to gfp_mask only for blocking requests
  if there are no DMA constraints.

- vmap_page_range() is wrapped by memalloc_noreclaim_save/restore()
  to avoid memory reclaim related operations that could sleep during
  page table setup or mapping pages.

This is particularly important for page table allocations that
internally use GFP_PGTABLE_KERNEL, which may sleep unless such
scope restrictions are applied. For example:

<snip>
__pte_alloc_kernel()
    pte_alloc_one_kernel(&init_mm);
        pagetable_alloc_noprof(GFP_PGTABLE_KERNEL & ~__GFP_HIGHMEM, 0);
<snip>

Note: in most cases, PTE entries are established only up to the level
required by current vmap space usage, meaning the page tables are typically
fully populated during the mapping process.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 2424f80d524a..8a7eab810561 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3721,12 +3721,20 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	unsigned int nr_small_pages = size >> PAGE_SHIFT;
 	unsigned int page_order;
 	unsigned int flags;
+	bool noblock;
 	int ret;
 
 	array_size = (unsigned long)nr_small_pages * sizeof(struct page *);
+	noblock = !gfpflags_allow_blocking(gfp_mask);
 
-	if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
-		gfp_mask |= __GFP_HIGHMEM;
+	if (noblock) {
+		/* __GFP_NOFAIL and "noblock" flags are mutually exclusive. */
+		nofail = false;
+	} else {
+		/* Allow highmem allocations if there are no DMA constraints. */
+		if (!(gfp_mask & (GFP_DMA | GFP_DMA32)))
+			gfp_mask |= __GFP_HIGHMEM;
+	}
 
 	/* Please note that the recursion is strictly bounded. */
 	if (array_size > PAGE_SIZE) {
@@ -3790,7 +3798,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * page tables allocations ignore external gfp mask, enforce it
 	 * by the scope API
 	 */
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+	if (noblock)
+		flags = memalloc_noreclaim_save();
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		flags = memalloc_nofs_save();
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
 		flags = memalloc_noio_save();
@@ -3802,7 +3812,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 			schedule_timeout_uninterruptible(1);
 	} while (nofail && (ret < 0));
 
-	if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
+	if (noblock)
+		memalloc_noreclaim_restore(flags);
+	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == __GFP_IO)
 		memalloc_nofs_restore(flags);
 	else if ((gfp_mask & (__GFP_FS | __GFP_IO)) == 0)
 		memalloc_noio_restore(flags);
-- 
2.39.5


