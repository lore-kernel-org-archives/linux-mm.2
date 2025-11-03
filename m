Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDC5ACCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 416448E00C2; Mon,  3 Nov 2025 14:04:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3780B8E0060; Mon,  3 Nov 2025 14:04:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8618E00C2; Mon,  3 Nov 2025 14:04:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E20778E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:04:45 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9E4081A02E8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:45 +0000 (UTC)
X-FDA: 84070222530.26.43204C7
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id B601C180013
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:04:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X8ci5zhl;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762196683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2JErKPUbhdtqVigURIODPe07ACqA80/yWkDmYy0qIg=;
	b=MKTM5g3NIQwCovqWvvO2xH02lmTrnwmK/6MAXu4acEG+ssCiwxUL2o0AH4WoFEp3siJG9K
	TEOpbiOoBGbSUtPgA1utLp7yf6cis4egLmBsOzJPAPd3puuewOZDWXb0a3DLBpRPkAkvNh
	97TG/o887uxrxkYleSl10p2Bzk3vWD8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762196683; a=rsa-sha256;
	cv=none;
	b=kA9a8kLtE2HbfvXxb8XFWgsPvNbR8m8aYRFdDGH9O0QsNLMTgaxJ+c9ENIwJtcxLQpzhea
	pwOms5gbYDdc7X5QUW7iKQEK8KZDhGUmXmpxG6ufX/Yufr9GVROiJ7dGaBlqRZ3wvMPCvZ
	4Rvru8zgX17xKgTCvjgkpPduLdRjH0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X8ci5zhl;
	spf=pass (imf06.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-429b895458cso3166628f8f.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 11:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762196682; x=1762801482; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X2JErKPUbhdtqVigURIODPe07ACqA80/yWkDmYy0qIg=;
        b=X8ci5zhlIOgO92HXPQ9X/EymfrOGRC59i0+m55gh7d/aov0IXHhtxbrxLELbId9bOV
         /mL/Sl1IMikZi265ULaaufk4k8cCNsrJ2US67lkyFgKS4sC2a3cPE/PVBqNKficuKqTg
         xMtFb+IXStyGvNacwG9jBCkLwxmVL/ud25RYqou4527hzLun0mkP3spAaiJeLCjPtsvJ
         AJN6CHwa5EaCk1KZ192KAOZP+48pB8l93M77IONCqKjRfs2qHTCCZp1dPmHLC3Dkm3ut
         b/jHXjboUh6dhrd6AylNcym+w62aO3elQKfGp7UATH3VapfT5rLNOsYGZ75mb85xXOvr
         PbAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762196682; x=1762801482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X2JErKPUbhdtqVigURIODPe07ACqA80/yWkDmYy0qIg=;
        b=WwLLHKPPr4RP4nq4+bEO4k7wMU8dd6fQVvpuC4Tzapdl38U640ccsujl1mIM4O3pUt
         MmPsYI22b5GICfv6lHDHBOHpdqE+jMgERjRqyUQCTmWvuUJFEcrWWsL8vLIX9NvP9fFf
         6W08HuF4bGv+jHULFzKum4w2Zl4CSM5cyHv1N2OG4J2j+odK116mE81ScE9jkSyo3QWm
         2Rbmavp3br2G08SjaM5kkbtM0gksKYk0oNtdfw/qkr4WxAh7hIlpkWSaS6XNVxzQa0/T
         9jQ7Wd6vYaCYDinlaykL0sSOQvNzbCIG9S4MP1KyKE7VOhlaWKXhssTJi7DUo1g9hdUB
         AkEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXHvjvnC7Fbjj+tz2HCgVoGm1PcM6UzhbdEIzUt/4wqvHw7m6qyD2slKmy8FNSgxc95dOgxtSylgw==@kvack.org
X-Gm-Message-State: AOJu0YyDkWmWNgE0lXx+0JhfotWoQHNXS2Z1aGXhwc3f5c8ybE/JOQqB
	gBmdCCdMbBVjAYrKZg5Ip5r5IACwga/d3AWBrAIDUM8huWiixCwTkkT6zsSQWAoC
X-Gm-Gg: ASbGncvNge6N9MDAKlpE81NNOB2L3ikdGmcO4pMq2ei9rpKMsHY5oHhD9keSU1IwmcK
	wr59gUZTShJsgf9IEhIUkJ58MNB1Yj5RSKmFoSypng3IMUlGSutZnLqfqiCA9ZsO1DfHrgfeQdA
	vGAmIGe08AeeUqsngeqizw3IeF46bStQntrHyTSpcSw2+Tq1S0p7tzP1B44SeLeVLJFOL//xHiu
	Cqqg0rJtu2ZMDX7nUpCvyyTiclYKqYGxk3SJ2JPrI2UsuYcpFWj0/wdqff5e5HIwH0HWH/6c1SD
	APBDQPag5MSWQrWpVcQTmoGpmr2d9cs2qQGgt85mBfS2PQo0PqlQwzKH7w5OoxjpmF/Weke9xrO
	MYsuN9WJmCuOWBMAcspaFwqjxiUvpj4kU0/XKlkUd/UkIy3L8ZYMURA/lodDUaWKRvj4CtM86Ou
	5jrE7IvlMsVmM7WHtXzY7aow2a4GT3t1RPSG9atsTMVkyD+lpTXDIgnvsib24FTLThFlGRElnd
X-Google-Smtp-Source: AGHT+IGx2X1I7UandDMAz4ApQdJWh1VyEyHr6OEnpPMtBW19p5E0ww3g5wJgZQFaxc7zmXMMym582Q==
X-Received: by 2002:a05:6000:40ca:b0:427:854:770 with SMTP id ffacd0b85a97d-429bd6a5ec5mr10631734f8f.43.1762196682204;
        Mon, 03 Nov 2025 11:04:42 -0800 (PST)
Received: from fedora (cpc92878-cmbg18-2-0-cust539.5-4.cable.virginm.net. [86.16.54.28])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-429dc192ac4sm327407f8f.17.2025.11.03.11.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 11:04:41 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
Date: Mon,  3 Nov 2025 11:04:27 -0800
Message-ID: <20251103190429.104747-3-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251103190429.104747-1-vishal.moola@gmail.com>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B601C180013
X-Stat-Signature: xhxqnhhwdosz49ykpwees8fr4carqadn
X-Rspam-User: 
X-HE-Tag: 1762196683-320763
X-HE-Meta: U2FsdGVkX19MlSzGpNqgvodmRvu5bd5Dpbh3FSmjwz76g0mQJTVvOGoVgqhSKKoNBECVZ4inX4EpRd57Ni07nBaPJCJvAOe3aQHLa5gvRT8fRCLflc36wXZ5Tgutz3vppteqWpGRZGqGQ0p8gOxgLUFTA6tprzBg/YQC5cPamuehV3FydFw9mD4+xjFFulHKYXkv3nrBgT0O71yDsC9M0dHmwJJAqxfcVsj9nTqfLZ/ujNOZ5n42iwAOXN/EChGPKuksJZ7R/RNaNwa4dJQBhGXLvsZNKrae67oZ9dNz02wHBH7yHIYaaUFKrF66zaG0zCue3/cd9e4cVoidoi2EXssRUyu+BRFTAAvZNArdE1m82tjqZaGcQ/tuBhBBeiXyAnQrxUXeAQpDTKCYILOfVqhDpGrnU3z1r/mEZGHZOWB6ox0S7x0NZJhkh7Vkvsp/KuI+8nB947KYFBj24scaulX5oKQmrmaEMGWzOFvimsCmgb2aOEMcg2HOPfZDJk7FVtsoIokr+7ZKjkq0xpPEvtkWteMBc8acQKpa845l9wEqfF6zlU0I1UkA/CjxNWxEfFH9AXMDB1eCjF3qW2hdM0sQPpnpMmXwHqt/dNHicrcGARGkwpeheMIdNEYj2wnt5tqL85IDd5E7B2rkkOmVMFmnKZ5++RnOy3uqgID8dLIdPNK3EgyQLTtmeSwjZPRCRIKeeFhzDvk1pAKbFDsE6Q4UVnNfb6dk62Mv5xqYXCqb8M11mDqOVvbIvHryIm6GcMe7pSBTJqJGXgiKf4V281yqW+ud7L5zVTHJxVKFU3uTs/PSoatA9Wr+9jJxDqc5dS4YUO2W3GvqijEq3rGoMf3BR7xstyTUX8zef1Jr0kqoDk/u3E62d/fA3S8iqR1oaN3pm38gAptvymmU/aatG5+bP/5nIXYmc7AP9hr/WtMcoovtcqB/9jRzOcGPhCNx/EMCbO6YzYrv/WLQs7e
 pVS3DNGm
 kliwiTSuBFJStSaFkqmEk4ePWwYTOw5IG5vKdPlVKD8eVWUV66vuDlCR8tCer4Mj3w+Jioz1YBgIM5PKL88CDmqiMGvKRconD9suYkhzJsXLevvV3MqmukNxAVJs8ZTMAmsqg9MZCnQPdhN6DmIPXd0WsfoMBVZ/WLRa4n+kuiloQdHeXRpWrkPPZH4wuWHbqZ58blT0vXpGslohNcnrESXuaSAnIwVj8YUUCBodWO3qMQ76ki0maCtsy7pYIEFMFmw0GhDEV1UIh7a2Vf45EW9GFw2z9wpdYLWgj6EVkxNKAzWtSy1fM8yAb7pfPFyfhIzfkDzzbM4Sx3XuLh0xQoT2Zf4As6PaI8beO+Q9RgfBlbIjkZ47MElYlI+J4+BhAe/xkSvQpVpzHqPw6r8pq+rM620FAhVu0nABJPJIASBMNUnGZ5FTquoZoy4yk/1gT8e0iE+Cq49OaSn68xZC0UP/gQYDhVHpc0VLH9b1bWr/rTensW0JWai4K6azITrPJrKze
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vm_area_alloc_pages() attempts to use different gfp flags as a way
to optimize allocations. This has been done inline which makes things
harder to read.

Add a helper function to make the code more readable.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 290016c7fb58..38d94c0c8153 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3614,6 +3614,17 @@ void *vmap_pfn(unsigned long *pfns, unsigned int count, pgprot_t prot)
 EXPORT_SYMBOL_GPL(vmap_pfn);
 #endif /* CONFIG_VMAP_PFN */
 
+/*
+ * Helper for vmalloc to adjust the gfp flags for certain allocations.
+ */
+static inline gfp_t vmalloc_gfp_adjust(gfp_t flags, const bool large)
+{
+	flags |= __GFP_NOWARN;
+	if (large)
+		flags &= ~__GFP_NOFAIL;
+	return flags;
+}
+
 static inline unsigned int
 vm_area_alloc_pages(gfp_t gfp, int nid,
 		unsigned int order, unsigned int nr_pages, struct page **pages)
@@ -3852,9 +3863,9 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 	 * Please note, the __vmalloc_node_range_noprof() falls-back
 	 * to order-0 pages if high-order attempt is unsuccessful.
 	 */
-	area->nr_pages = vm_area_alloc_pages((page_order ?
-		gfp_mask & ~__GFP_NOFAIL : gfp_mask) | __GFP_NOWARN,
-		node, page_order, nr_small_pages, area->pages);
+	area->nr_pages = vm_area_alloc_pages(
+			vmalloc_gfp_adjust(gfp_mask, page_order), node,
+			page_order, nr_small_pages, area->pages);
 
 	atomic_long_add(area->nr_pages, &nr_vmalloc_pages);
 	/* All pages of vm should be charged to same memcg, so use first one. */
-- 
2.51.1


