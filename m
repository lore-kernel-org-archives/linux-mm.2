Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BE9EC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 498EB8E0008; Thu,  7 Aug 2025 03:58:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 447CB8E0006; Thu,  7 Aug 2025 03:58:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337E88E0008; Thu,  7 Aug 2025 03:58:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21DD08E0006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF9C4136B8D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:19 +0000 (UTC)
X-FDA: 83749208718.02.55CBED0
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id CCDCA140007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NwUwiPHI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553497; a=rsa-sha256;
	cv=none;
	b=LOyW9NeLEdgIMuDTOKpiO/qMGgAdTKq6J9j3sBvhZ1ORoj1zuP4+zFpRlAWRuuXApQ0FdO
	NELb3xCTXdzU5yLguquVwHoBltJXs4epEZl45wBAjTVH9AXlU6egDzjDAD3S4mfEktyd7Z
	flU5MAPuMqxETcUgBbLBOvTeaQHULoo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NwUwiPHI;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.48 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KydXFGAE7W4DpoPvcZ+Z0Di5zFlR75RWumBb0izMzE4=;
	b=PgMi/UmljRfIV7nqukdKTTaNCz2za9sLjrhpv03RV8lPY9im/VKNmIk/0wK+yLHD5HChVj
	TQoLxo63gn7aBiQC+8J0buM8Br8Fo9jFjVEiovl3gSZUppvatYgslmek6p5aN8l3perL9f
	hsLnbxZVHjMynwXnJh1bjFNCX6V47Ms=
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-55cb8ab1010so394274e87.1
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553496; x=1755158296; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KydXFGAE7W4DpoPvcZ+Z0Di5zFlR75RWumBb0izMzE4=;
        b=NwUwiPHIbaL6wzaqreHyHOxc9DFL7HTG4wc1fRXQZIh1Bp1GKI33FNN03/D6Emozwl
         9p3UNovTzcQijF30rvl9y/cX/ja3OfyDyZ+RAEH0jfVY9DtxMfyNxZh+RFGLvUmVfNlC
         0vVmA7FN+NNH0pfOD6HjZCU7A6RH5Ix81x6jEBIcGQPrQXl1eOCst3iyzh6utTgA0sxA
         sFtHOpMreBRW1/wGz6MuPKKdK+yBUBjhfIi49m6nkogp9Jvuxk/F1bBuLvzXewNloZ/1
         3jJbw3q39q089wvWDb//mU+WgWLG/L91Oc6Zy78YuBnycPbGYwtLLVDF60/oX62PkkTF
         +u6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553496; x=1755158296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KydXFGAE7W4DpoPvcZ+Z0Di5zFlR75RWumBb0izMzE4=;
        b=XQOqQj1oU3JjfLaI05gIAmugfIfK8bnoSeU5wRhZoiiliK/+SNw/olzU+BJishr22z
         vMspfcFcfPqk85X4zU/T4oIHjyi/QssqJ5Mg8ybAoZ5KQb4hmIviP1G+E39afVtR/Y0K
         EI507hftfsEYEVQD5G2qhlvI7qsdcmWISUXgnbFgASDsoLJaeA8yqaTxstTH7YzfPHUg
         kAguQgm4kogdOuJUWsSgEBEu8SGE6I4q70BZLAIX71N+2fSGNfwOjZ/wDZZO3vNxqA3a
         hViPOl3fnZ3VFp/+TW9lHZvph/c4dEAhj0Iokh9PqJ4H681XymBQY9MHX+pqd4iq6K+3
         E34g==
X-Gm-Message-State: AOJu0YygPpjLj2zZ5uxTE3Q3rNgQb981OJi6oKPdmI/KeptH6hiGDeaZ
	qEhR9dBr01UBJ993t46usqipBIsKHkYtaOlgUi6I0xYUQwJlmvvgdHA9AgGLCw==
X-Gm-Gg: ASbGnctMt+8xsgY4LSagQGhhXZ2BkEXDdPWSAXI3FhBRDa/zQHcrANyvSP41xWQbtOp
	X7RijitR/XJF9RHO7d35c5e+9PIq5cDa8qNV185zJiooDSwwrVz6sjWPyuU0RccIj1fx4DkPAf3
	MOQusD1nYQq5rodU5nDwkWuNb9IWKZ54yCFCG4KgoC65WvDemBFAs+JblTKf/kSP28lcTzku4fK
	fV7WdgbwfKmNmdj7PzY/uJCQXodgxWc/DcUBmqZzilLgA3a61ciSlK3xX94lNx6NbUt8cx0osIz
	vhVBVPcudX5tk5mDDCBOwDzrENnCbq+x4VlSWMsj42yURGAn/T/r3gbkCsvf628Wf+wbVwt2cdb
	KPCKF05L9GEfmDg30ZrkEAwTEGfp3
X-Google-Smtp-Source: AGHT+IF0q6rKChZ6oen9fNvbhVWsws8Z8fn91x3v64lQHUln2uy58X56NwoWxrXywEBePWrOTHfQTQ==
X-Received: by 2002:a05:6512:3da8:b0:55b:81cb:9e5d with SMTP id 2adb3069b0e04-55caf3f37fcmr1726894e87.52.1754553496035;
        Thu, 07 Aug 2025 00:58:16 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:15 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 4/8] mm/vmalloc: Remove cond_resched() in vm_area_alloc_pages()
Date: Thu,  7 Aug 2025 09:58:06 +0200
Message-Id: <20250807075810.358714-5-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CCDCA140007
X-Stat-Signature: bz1koh1q6gordi39jkkoyjxfzbogx3wc
X-HE-Tag: 1754553497-286377
X-HE-Meta: U2FsdGVkX1/a7zE9RtNv4fuA5wBRg2Ng7lwr++ZC89Tn8E5GM4Sdy0bgmOIkjFUrLcoeQFztVBCGliGvyu+x1KT4t1S2Stb/P2cZGr4CrS9wL0Y2dyGY5/fAPUOU9FD3TzCe4bO4SH/eBaHg5uP5L3g+sdkKJFL3EZ+029yp9wkPoZzD24nlBxIsO328bOp7cTKIbt8KNAZ95LZ/ihsWQagxtV/pfjIjP9Frhq1n/GdYIVsnptyFxP+rK/mhnZLqdACWRUwRYGJbA0T9ysSmGEP6sL0HM33WD6rZ3W64ZOr347t+EEC1M3duWwtsszFvcOIKByY/jkafM83/eC7UZ4m8mkR2CuZwWkcZepKdHlc7UphUXUjnKU+cOXUaK2/2Bi2T+JjcOkNpvrC+CoWDPQMVvGHH1K6BbYfh/RWiap6e25FoUQKLOPP1y1W/V+zwnEBPfoXZRAd/le1BodmjWkGPhMg4jARsOnHnEKh+f6Dn4KNJxBVDoYn0CEp8vUIWVjXdE1LqkJdYXsimOsN6yC2H/d0Y6S3txJJN4lZQ/lICQ+wk7YsJ0E05Esf4j9Sev2SfO4heMJYnOwYso3fTPT3uLLRVIdasMiyKnS+hnkCl6oXrZyVXWnBIfyavX4UZDymrIr8fwn51k+bCzW0b3oLPiN7UYuWZdlxztpC47pf5luxsgL6nnVYMfSnI86gFarGspq4IUGT4Z6ZxYZZBJgAYYzS1ngnUcRcL1hat29vPiERXenzRNmYNDIbOue413Fe1eLt4rEz34mi04NzKtNrIwg/DrlhQrgYpX/Pp1wTLP1own/q+lg0NFL07evUEGdtB16j1UxvwLUT2u8XHwCnIGDitMxjWJtEVlcuwDy/xyF91b8fmnBByQaJH21BvWzBfOyWPoa8uvLh2G/FomiFceZm4iUSXbnXr7MX0mHNd6OrNmKpsKe3Di9+MzVvK/NglnLdGenBSaFQDNUc
 AUN8Kak8
 LO4t2Rn232f6KmA0p8WBNSnRCku+9rx0Yw+IavNiqm4AuiMRRCSYb08NuGGcW2xF12tDTmFiLYpOYNC7uIp4VpkzQnmydYBxDCKIyPYEY9ffbgu9WPorcVRf7FP18NzoPC5D0h5BZKzdIHnX6miia1HjseMe1YI4xOjSrwQBFgMSHCFGRKUVXE+aeGk4SYhhY9mThcOCayGElzUSrcdAyoift1OTg9ciNeuLhWcL27dz1m325MhDO1KBd6xaTe+grkpy0hjuiAYW+XfZ35C9aWFaVbLrB7eo7c/scG3dqStG9dAj4LgJFbRUiunVqeSnOG8i5mx1qUwl2OhNEfOi4eRnpbhTPiifesVMF7Te/CAVKn7ciihDKhxyzjdLA3Ateo7h6NW9jKc0pkCLpG2Tlt41lheRanVHsrJ8sP84H8XGTW3twAFFeYHDQPNOEzTILW1cemHX2UYPBldsJJOQuc0T9qLxZ9ABBL7VuDIM8RplMm1I/X34FmRHEGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vm_area_alloc_pages() function uses cond_resched() to yield the
CPU during potentially long-running loops. However, these loops are
not considered long-running under normal conditions. In non-blocking
contexts, calling cond_resched() is inappropriate also.

Remove these calls to ensure correctness for blocking/non-blocking
contexts. This also simplifies the code path. In fact, a slow path
of page allocator already includes reschedule points to mitigate
latency.

This patch was tested for !CONFIG_PREEMPT kernel and with large
allocation chunks(~1GB), without triggering any "BUG: soft lockup"
warnings.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 81b6d3bde719..b0255e0c74b3 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3633,7 +3633,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 							pages + nr_allocated);
 
 			nr_allocated += nr;
-			cond_resched();
 
 			/*
 			 * If zero or pages were obtained partly,
@@ -3675,7 +3674,6 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		for (i = 0; i < (1U << order); i++)
 			pages[nr_allocated + i] = page + i;
 
-		cond_resched();
 		nr_allocated += 1U << order;
 	}
 
-- 
2.39.5


