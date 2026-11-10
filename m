Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F68E60A2622
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=ci7ZFvmt
Received: by kanga.kvack.org (Postfix)
	id 41E156B05B5; Tue, 10 Nov 2026 00:48:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CE046B05B7; Tue, 10 Nov 2026 00:48:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAA76B05B5; Tue, 10 Nov 2026 00:48:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AEA06B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:48:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1A84120892
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:51 +0000 (UTC)
X-FDA: 85418130462.09.19DBF66
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id D89FE80005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:48:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ci7ZFvmt;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794289730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95H+FB1wx8Ke6Q9IRtMFfh2ammpGvU9RDrZEDD8q16o=;
	b=yFgI6xaKtZiS2FPXNOi/Io5Uh8O5nZfx6VcNP2RtUuhgZIRpFFRdboiy6Bdz0FsrYOxrUQ
	v5KTG5WIy0Vzs8b6dR6ulxFvhURumInsv5fgA9uujfFJMmrMTD0cM50o9ulia4vBjOvatG
	aCzr9nMpPwjqt/rOYhA+/JsvQBIBeJA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794289730;
	b=dCCgrZ+mp1hbatOTl6pPMYi0I7hSX4Ych3GuoMAe/Rm6RDyCWutPByTZ0GFgjZgNTBepgv
	74WHpnx5Ht26yrt/KkFOWBNO1iSjlUqZvyoNp4konDBc1l7swEBABMdwtUBg9m//w6OIUD
	49LNvRMUWz2G+Dkvr5UU2pRbiA1LRI0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ci7ZFvmt;
	spf=pass (imf02.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-8a4c72951b8so1001552b3a.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794289729; x=1794894529; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=95H+FB1wx8Ke6Q9IRtMFfh2ammpGvU9RDrZEDD8q16o=;
        b=ci7ZFvmt0/xhduOe7tapQXbA7L76chz6G0kbU2Blw1d411CXg9SztRhszxfJn+gIAD
         relMb9UBh3UtX6Otkfm37uLKcjATdC90z76MIn6aFW4RySkzowQKHs1SdE9VgicCnvRW
         S4Bzmxb3nA9nnK/ELxESNGvfmvj6UPQN+5fxM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794289729; x=1794894529;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=95H+FB1wx8Ke6Q9IRtMFfh2ammpGvU9RDrZEDD8q16o=;
        b=ENz+WU0zfhbZyScpTepno6tHwPKIEYz0y1a9n+hwHc+Uiblxcrg0c8COQe/4LFVKfX
         PR79QwR1pkHujgAUB5U4+MytERfD+nacJJq6bGNoCg+czU9NrgY9+w7Fi4Wvz3h1hrGt
         +ODejbnF+k/ApgqU+CULXxf7k7zCd2oe+c/VbkGM0lgChJieeaXl9DxXMxX+z6UwIUdj
         wnlw+j16z0pIrqGLvo+LTcIwLxZ60REzzoE+FVwdMpT4jhgoEKz1ykUcpRUj7zVC9gNd
         p2QU4eGI7Y/yUWoraWaTSi+47L6yB0xJPSpVMCc8wK9aj1tpixxQOcqFyku8utp5zg7g
         ZtIg==
X-Forwarded-Encrypted: i=1; AL+hErGg9fGAl9YJ8LqF95r2HQ8JAI5qmdUCUSvfFeO35Ar0k1Onv84CQ1iR4F7JWMTrhTczWhUTvz9g/Q==@kvack.org
X-Gm-Message-State: APuU4Z9iqP6C6zoMCarfrDVW9kkkzw2OiCqbFADcxykryuBQLcsmU8fr
	Agks3qhuQXs6lEp7JXzCVBKePlXEc9hoXis0dsRlREzw/qALkH1M3O/FSdQt/JRa/w==
X-Gm-Gg: AYBFou10bmqcnsHoC5LzHth/Nnw4ckeAZjGnk0zPuUiDTIee4x5+KvfRjPoLspAagdN
	JWWx9cfBLHM5Uk71BRrtmbBwhbW7K1W1Tegy6BqsAr8grt0O4VJtvDRcPGjt9btv042no11LHlh
	/+RKvBZ1GT+6JTukYMqCcWWkFLZrLqieWTWis4K3bWdx6TjyYzFw6qZlsJj8efCxMgbi90p/R4K
	b82AA5ihS6b28GqrmKPpEHfRIZBrT9/0zbfe1hKw9/1V9vgg4Sd6fDnRCmoEYOmqkJCrrJvT1tp
	ZD3lPeMUtRir7DzFPRxXFi4ZB5Qg6AqEyEUbpI5DoTQSLy1f6tm8HezfatIrpnvhgGDC/QAHYnv
	GAgDMY9vL1yOWvZROh4dxY9oRV0t5zAhSvNCOaIi2jh3v6QoVdeV7Nj8f+VpK/GJzfcaZoKaDk+
	hp4sdh2Vqli19m8r7Jd+Ncv52EAoa6cTLH1RsLp+TqTct0F634Pn+jCeGc5ERxqjz+qICUFnmDd
	DHk7SEuMVgcJLIF91wf3nxVTduGua+rAJDGIokga+PKXSfstLv8E8e1PYExJv853X3a8a8UO+SL
	Wihk0U8vmjeARlqzvqf2jEHGVLGE6FLQ+5vSuZmg736WVCg7fWXtgLpyXBpakeGaTv/Y6LjUSs4
	2v28fWP6rz4oFeXR9K2k=
X-Received: by 2002:a05:6a21:68b:b0:3e2:21c0:3dfa with SMTP id adf61e73a8af0-3f19058a5d9mr1355701637.66.1794289728711;
        Mon, 09 Nov 2026 21:48:48 -0800 (PST)
Received: from tigeriii.tok.corp.google.com ([2a00:79e0:2031:6:e137:9384:7cd8:6e40])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdd8d67e53asm444634a12.5.2026.11.09.21.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 21:48:48 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@kernel.org>,
	Richard Chang <richardycc@google.com>,
	linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH v2 01/11] zram: drop stale comment in write_incompressible_page()
Date: Tue, 10 Nov 2026 14:48:06 +0900
Message-ID: <20261110054836.1515030-2-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
In-Reply-To: <20261110054836.1515030-1-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: qsi67tndxzqwewbo5zt87rbb8t8tm7oz
X-Rspamd-Queue-Id: D89FE80005
X-Rspam-User: 
X-HE-Tag: 1794289729-213268
X-HE-Meta: U2FsdGVkX1/b8pzI3Hsel+5KSXKgEynTJX8hYRu5qj0EiPaxdwn1x1HVAOuBBjNmaAK4/a53m5WwKnd7ZbNdvFk8wUvdE3OuVR1uaKn+Nfbr9DH/boMEdM0AiXx1TpNnqEKETNNNdRDBeCEiW1P/jTD+MmJ8i/SqFMw+87ltlJCf3Qh5mAd9BIOuVFAJikwdDjutx4Zz6jYC4c/+TTHtsI8epb6965M2wFCOwMVs2LHoR24O4KqUbxMbIzx2SSk+AIuYrA3gsgTSuIpMw3/hO4VaVB4lkUMs/K+AGU5RhzB4ooKdbrCL+mjtmYyWsE4t0OF0v5FCJxfPAJvT1VLnEK2lpZTbe/4zz3V88rIwFvLFEmPgx5yYsdOAjb3t+9TI3vQzJYjywJdD6K9/S/rmZ7sO2d3thsGI/FQZBqfnv5s50ejTFWjJR6Vz/6WxYgz1adv8lRb5HnNSYWM5AZhJ0pYbUWqedmPsO/FyCzI1BZ8PjShgRdthLO2qYuKs90DPhvG/2zpSkSdH9+2TtaVYizTE6JvePBU6lLH7yVher1L4SJQlitnf19WeuP6UPOeeMgDp4oGvFJkCK/MAS/y4WWqD9MbUVbphkpinF/K1+6CoyL+hMUC8TwJgI8otFJgi2mxNmvDYSSyTXfCIZpMC31j6+pDAa+0wyUgp1aSW0mD5PkyByC6mxKOcADawCVuDtgMLqZoQ4jBS2gCuTbh8dGDaSf8IyAAV++ubgD3/BEeMHv8H+gh8HDfifG7s7u1T8HoYSfU//MeQVHP1SjeK9FW3hiSlVq5SIb+CNG4UjGEkWdCcqRpeeGYFIolCwoxFPh6Jky14tspcCpera0tVr5ZIcxjWYQhC5SUC1I2RTjapUWKvJ236gz61EVwzwcEXzND+O+3SAYD7bG6pC0VKoAsGu1BIGyPgZqk5NN5Kz5gcMvOsmAhtbbFuIv31imdyKuY1QSaYr1vOTdYaJBg
 +6ltPmgw
 7xKBcY9OCIkWlTC1YlJc/X/hi+0dItGPVvVY6nXInbqN51rhIOzAtbjOet9+3c/ktCwUNEYuqDhXD5RaupP1SLYtM65kFsnteQKuc2sUupoE9nl2U3ohQeWHQnEYZB33fRiWs1CshDM9ALbchKKs47Ki3c2EMbrAsvhoOk4TiHRp72KLzByC7mhkb2r9RixUeeL9QecAHtKddSv2D4OZ6slb75jaKZc0CJkwPuFWec6G32jQylQn65KJu0NIrBPOgfUJOR1qmBosLqM2PBw00PEd78JO1L5M17hFEvSaYmLBZPKnDjftJeS/T5fn7IcdihEyfs9jAUt6CMjG1Ibn5aqKJ1pjkvT0CIcYs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zram doesn't do fast/slow-path handle allocation anymore, so
the comment in write_incompressible_page() is stale.  Drop it.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 drivers/block/zram/zram_drv.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 632045b65bdb..380615b73446 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -2271,11 +2271,6 @@ static int write_incompressible_page(struct zram *zram, struct page *page,
 	unsigned long handle;
 	void *src;
 
-	/*
-	 * This function is called from preemptible context so we don't need
-	 * to do optimistic and fallback to pessimistic handle allocation,
-	 * like we do for compressible pages.
-	 */
 	handle = zs_malloc(zram->mem_pool, PAGE_SIZE,
 			   GFP_NOIO | __GFP_NOWARN |
 			   __GFP_HIGHMEM | __GFP_MOVABLE, page_to_nid(page));
-- 
2.56.0.506.g506a7eabc5-goog


