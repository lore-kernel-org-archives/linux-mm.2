Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C33CCCFA753
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 09:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607056B0005; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEF76B0096; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C726B0093; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BED66B002C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 04:44:23 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 04BD31A04D8
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:21 +0000 (UTC)
X-FDA: 84134128764.02.E756E7A
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1E508A0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 09:44:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UzjNCLKR;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763718260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfFqxZ0ma99unHVudIGsan8XMOEofYpFEBSvwCDn8iQ=;
	b=aQO6iirJa1IGO/8Lktq5ADCDWbA3QQlZMtd2RC8BgFWXyQdQ30CxI0OoiVKSAY8ndo5Eg6
	DsDifznMOn7GnzsGUefztgL/iGEhIEdFCOIV+JH8RR704apyU1gJZlQ1a2abRJb0vM/Yqz
	LZaGr43XltdcycCU47GAxzQxZTPtbKw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763718260; a=rsa-sha256;
	cv=none;
	b=Cu5IEAXOG+DVSd9J4vIeAnyI/DY8orqyNGr6M7vZDD+Swugi5cHC9aNI6qYOeRmN3bLpCP
	pFbwmHTI/xZy1wgz76hB1Z4NKj0Q+Bm1k2CqWgO6jLoPY8nQmzcRpTmaHq0U2syNxni4Wv
	dLB+5qL2nT0X+xQbKGyZVT3jObFfUfg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UzjNCLKR;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b8eff36e3bso2766261b3a.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763718259; x=1764323059; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfFqxZ0ma99unHVudIGsan8XMOEofYpFEBSvwCDn8iQ=;
        b=UzjNCLKRXSNeXDd9Tifusgf/+iPXN8JPe4ojTdFYKJ5J5K+5reTMXnuLPG6HD8UGdk
         j7N0LxGEx1av3clOzu2TSjkKO+TfrOp4XwrqI/QQFluk/mNiQi0PB9kOaKOaPyQllpGQ
         jRtF/yBnTr67Q9fA4RZGQQlCG9DqJr9Vd5kYtRyW9LOPAC7tPtS2T4xm8+jFwgftEBLv
         YHT/YWB37T+mG7m40PFuwwdbm5GsFn6aWJMmh5Vwh4L+w54toORYKicFYg1ELiynp+6O
         TP4zP6fAYW23vUrmyOLtztBom53pikgvd7CBPUUlm3XIog0w6ntfK4KhwfCO6f0u1ZX5
         U6Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763718259; x=1764323059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FfFqxZ0ma99unHVudIGsan8XMOEofYpFEBSvwCDn8iQ=;
        b=UIJPcVo2rfbJf3MukVPF6SGvclp5c+wVEFgkk9t6xWuZBPX/roIpkUtI/tnvM/9oEz
         1VQeWc9YL3C8Rtq8vbjK/lfXHNDlnP5D0ee4O9g1IjocZ6hfwgOZE8IRmRHuZ8cukMMb
         5Q05FG4v49EoinJ90pxO7yBZ0BJvSDZqFneR20f9F+zQqbAO+Kpr3g70XVS5KR7Npc9e
         GkixhYcunMx7INFGT9h/Ewyhfp/JEzwCoLxFKp/6FJXLEG5rwgGqyn0prHmzgFi0ouBi
         JwCWIwgojNqTBoebJNkLiLDgCM/pcDCIKow52CLpfViYcLl8OFMACm0WlEm+WeAAQn6c
         0MnA==
X-Forwarded-Encrypted: i=1; AJvYcCVn4LuVYrsL/2dlfv6MbGHmp0po8A0cQGzCo8IDfayZBO0a0GIHCI94YpoYKFdY4YzbV+5OW2BrWw==@kvack.org
X-Gm-Message-State: AOJu0Yx6Bu4SapEeKnjBHxsjulVJ7uzaasNWgMZYnlhiLUtDu1NeoAeq
	L+TZ5rhhsAYVhWf9K5oUardFVwkLwGOFvg/Bgvntr90xFcrWj38h8nPbkLF90A==
X-Gm-Gg: ASbGnctwlFoiE05ndmFbv/ECp+/UfdhajKcFDzeZR3/e/SqkgqD+2kFuyq0ZbTcLk2w
	2/Cxr2lAMP0vUkELk8gQC+CY2oYaQCpXO/sTCnt0w4A5NzOcPKjBqE50WMnyRdxhT8DEDVk1KBT
	/F+2Zc+xiz6I95/t5w7XjEJLAr0oLwQT1jLMVM9bimTmfQJpxZAHHqg2vJFn262oUl5ljCQOmuz
	jOi+3LZQkQ2d8AYTNhNH6dPkoPcDG9ExiySJ9L7nmt8nWW1hfudcqCePmZ/SK6iHZsA//N3x15J
	Aturj0IyXMFcMC3HUvC5ofbFMEZvinUe5ou2NNk6QvBQ7BBbvjwMFHpnQZfD2fTaqNr4kSakptA
	AfAh79vHVAiVsaCVR/tLa7Jw3saC+gZ+4VDVPBQYd1bo2GeDAsC0FP/xbUQo4HEOk6ha8oGYOcn
	Je3gpDrgWhHhGaid1XWVJlLxrx+w7qzVnXPnLaEzjEFf8=
X-Google-Smtp-Source: AGHT+IGjVF9fWMWCcQq/APDW1mQtK0kC3EXIM+0T3Xkb3mEZBMlujfb1Q3LAdPOvG8FLGpxroX6q3Q==
X-Received: by 2002:a05:7022:6994:b0:11b:88a7:e1ac with SMTP id a92af1059eb24-11c9d711f13mr514030c88.19.1763718258809;
        Fri, 21 Nov 2025 01:44:18 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-11c93db4a23sm22430736c88.2.2025.11.21.01.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 01:44:17 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH v4 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
Date: Fri, 21 Nov 2025 01:44:04 -0800
Message-ID: <20251121094405.40628-4-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251121094405.40628-1-vishal.moola@gmail.com>
References: <20251121094405.40628-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E508A0010
X-Stat-Signature: x77dnksnnaanb5pz8exxg9h6twsor896
X-HE-Tag: 1763718259-621053
X-HE-Meta: U2FsdGVkX1/O8hTbUtoRyMaNe4oC4zcWFt3u1RD9b6pwFM/aI7dmcxsLOxV8giIotfCsUvJ6nXl5LFpMIERyvmJEBAj8o27fBNtrWqu+DFNp4kbXjLOkilm+Lg7stGv6otRm3WGzoH0TQkSoVuwEiqudpx6SHOgsY6Wt7IAO6mdMBSXf4x2BMsiyRbahTDWfFbugBebHo0MOJTtZSs1hrHzBTleFvofwfsqcgGiphdIKyOhyGRAcU3pZoQvejIrDeLwv7hrAU68CKQUMMZZmcLeq8Ul2WQF8CCYpLgedbkDpP7oQhfxysrN6y7WlqxNSn49moXzcqKL/kD16auW3HCTt0XHGKpgj1SnkMs8i3/tNxIMpnoGemOg5IVWLY0l4+uOlqDZ0O+MpuqD7M+HfnmF2V43ZI3DkqqDJbLdPBUnxxr8ECAi9GhiakZIbCenjwlvjO4iDGnOAOmVwmtIAhbEn6Z4KQ9mp2BR2XyzJHj0VdkTABYM4R91EryElNxYfDTQmSwrhqTpxiVcd9O//UBOXHi/mmhLEYMmSgnztEXrxI9JebsXtzJ78hx/DOW8SJXPZg+o1GHYdmiJwSF8UHHZ6VGwWl9uk6bRpZZ8G1MMQucrtj+4ic/w0yCQhs6FzyyJJkVkh85fB4HoAXYidTfiicx0PCDhScOI2xnKsCmAn9TddsgqTtQO6M9RS3lUSRDFJw6A7iqfR/fYW78uNBuDrDihDAMP8ZwCjiUXirb8JlCLVWjDFXGayfxcxolW17Jnv7J65TyfoKLPS98YcSDDOU4wB54Ia7nMYN27J5tn8LTM9xKZVdsls9Vwjoqk+pykfolaLNxjs0pcXH2tOaq9VupAs1z1FDOzbejdxiep3nY9dY2MNwYDWN4BiLgCahufSM1IREr994q7U3hSYlPzIlCmGCRam/7XLsagkMYMuCwVRvMBQMcPUiSP3kzTiBKhVJsFW64Jx8eKlOOl
 bpLSHGUo
 Iuug/irdMT+sB79FFq4vTlFfFqqsJ1+P1vs16L5w7v9LAK8OJq8mINUPKqrR1s6z7+WLtEF9LtHiYNd9yaDWKtd60MKZE+4AXRt7BCLgPry2/MA3x15EqoxnkdmT5UxWlrw5usL2F7dUTA4OIds1+evlx3zjqM5HSGoP+rElqFowCDVj7L3EG6y2RtVkspeA9jHD3YF4ErXIqpzV0B6vxCJv0c6SPpSHVg3GzACgZ3Oi50TfRVWJVY7ocZZx/XOis0NUkAAehA+YJTM8qO8zvrHAT0cLSVjbgBXiIXTX54KtZh8pKtZL3FEHiYznoNWUSQblHOUyX4EmcdyD4SVfbq1IyNIgHFQuvUONhhLbR6r88f8y6UMBJ+ohagRHjXVGT6adjhSWWJ59fBE6fD6dV5CLZZu2lMtEHwBfLRRRqVXp0+VkPoOwtqyEbWViSV2bQeq/mf82eNe70nD6sGhsNyqOI7C29ZxVfXaOJA/hAlYxfBtG46jCShvjNdm+OT49Urw7SEz66zc+h7u7pmBX7/WOuA8zuItu+9Zntvu8dNEMRza6OrEn1xx6GvERJt4i3qvJtFRnIzpNkOSZVfHkgaXL1OaLjpf5g+G0uHnAYSUGwlcfQwd27ObOqNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have already checked for unsupported flags, we can use the
helper function to set the necessary gfp flags for the large order
allocation optimization.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Acked-by: SeongJae Park <sj@kernel.org>
---
 mm/vmalloc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 185add3f5606..134f615fd3bd 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3634,10 +3634,8 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int max_attempt_order = MAX_PAGE_ORDER;
 	struct page *page;
 	int i;
-	gfp_t large_gfp = (gfp &
-		~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL | __GFP_COMP))
-		| __GFP_NOWARN;
 	unsigned int large_order = ilog2(nr_remaining);
+	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
 
 	large_order = min(max_attempt_order, large_order);
 
-- 
2.51.1


