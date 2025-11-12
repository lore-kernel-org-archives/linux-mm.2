Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD1CCD3438
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 18:58:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2172B8E000D; Wed, 12 Nov 2025 13:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0008E0002; Wed, 12 Nov 2025 13:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105A28E000D; Wed, 12 Nov 2025 13:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F0CBB8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 13:58:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B946313B79E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:50 +0000 (UTC)
X-FDA: 84102866820.24.E18CFCD
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id DDC8E1C0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:58:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ReDaJJ9i;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762973928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1I7Klz6oAgGe3SSsI7DSFPvLctg25agoEpI/CIFVteM=;
	b=m5FbUk335ANWAjl++4bw8PakOMZXU0BnBE05gmdlMOGL4/tYB273zagi8FUpQTbEa1Lr10
	3EMd8Dp2RJtiq/45XliHezhWrW3n7OIiQfy3CB9AUY9Hg8VDXraFv/XbPdelRaaFJ6iet7
	2OPOfO852BWxmrKFbTXJIFx3ajxEO2o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ReDaJJ9i;
	spf=pass (imf18.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762973928; a=rsa-sha256;
	cv=none;
	b=zWTtk3mDduhVjKSS3fcvPOVGpXVkLq8f2Rvq6kPnY0dG2eSzXU/Z5Qpx7bjv+gel6bTFaf
	vyU4oiYDmPpS0QTctS8kWOw5BF6V8hCwjJiXfcK70DkFb5VqN34apiYC+oeOQ79Cb6CSE+
	2eEg23JKqHqPqpNwNKAdZc8QDI0OvoM=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-343dd5aa6e7so1313473a91.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762973927; x=1763578727; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1I7Klz6oAgGe3SSsI7DSFPvLctg25agoEpI/CIFVteM=;
        b=ReDaJJ9it5P1GrY9hXYE7VQ/RfIIDVXzk+x46B7P4oYPXSgGGzSWFU2EstGMGczuYV
         2YjEXv0lwzMcU1VXlu+4RhUWVLSxGyH0QQ385ba3j9o4DWYWlc1mKuMam7R6sEzibIdV
         EMQ5xPA2M4mBAGn1YmY6vXZJTWPplEssS9W188D4z7chZNOvY4RtN2OrVG5ow74oCjZU
         ycG1C1/y+sxal27C09RJqmp2GkkEiNUEXawSrqXtFBrin6XW3vSVfmm7ggGTLuG7Csz6
         sQ+Fdg1O1SK2x0k3M9DVay+x6eoXAnLNayrAJnbcIxR3iHIrkzoL7Cx6ESDDBs3snDZ4
         rhAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762973927; x=1763578727;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1I7Klz6oAgGe3SSsI7DSFPvLctg25agoEpI/CIFVteM=;
        b=IF+vHdijNlZBC94l04o46XlqiZ4M4anTP0RcZqOzGbzNkisVFpBf4T9FRKd/Y/kUy/
         OxUPSkH/fFFRInXMGHL3DIOd6VL/5htGCtdx531pPD51RD1RoXkVRuYHjET+bkru33+X
         yNET0SDLDuRRdnV9ZknIHCZon6C4xLhHlaH2dEtZgL+ivyrgl7fIgsXl2ICEm5jGhvY/
         nDmloGtOMxW1Wb/4j1pC86/WsDB9/JqNl8SDywboZcD1fgj1KfOCztpspW1U6/n+yKeJ
         ngxqAQtMNt7P+ZajWW6wHYVhwP1oeRPkl8nfgDU9dLygmbIcwK/LFvzos5U+D3AVlE/J
         MbFQ==
X-Gm-Message-State: AOJu0Yx4Bv3hoTG5/82mXCB0GCSg0w56Sai3CDX5bw1S8odLvCITFcsx
	Yk/XjORgzsL6JokOWCFpE/YC7ZAW1WLpJYj369w/ijTfHVxA0UYfdVLrUsP/xQpn
X-Gm-Gg: ASbGncszrjtg2hmorMgzZSNM8rYgWf0vWOy1PSwzv8d//zC0FVXID0kjMlmWFnma8Qk
	9aCYtekmu/3ehOF357np+xql6lBr0cwKCho2kyv7/NIN0gOXWyQ1yb86tF5iFh093FTos9jvHXc
	Ontme6rwrdotDc744EZXaWDmi4G7dXVpCOZZgB9o18KQCY7Ew+PqSoUqNiuKbtuJflqYL8KwW+m
	0jyuq9lQk+BZLX9Uzr9ktHodUKIuUz75uJuRwXmos8MgqgE75oHFgL/1bo6XhdKU3J/h7dvYGyz
	88u4pnolpcLnJ3iYlIwm95Vb5DnJdGrAw3lIgcJEJjqEeKgF1JQK/MiZGItxL4fF64Geujq6KJX
	tsYhKb7qqco8DYpiFyNnYgJr3Q5Bnv4vad4ZhGjoSEck4pwA3tdeBJPfpwelxjF7BpSFKblaUIC
	Htjrm5xJbX8el5W6y2ZnP74RfSDnRPUJ+X
X-Google-Smtp-Source: AGHT+IEXSRKPlnUmANkCKnv2Ry+gqRz/FWfvHlbIj2RgqDD993fXyqdwaPS9bBtM9eHGXaWe2sWATQ==
X-Received: by 2002:a17:90b:590b:b0:343:7714:4cad with SMTP id 98e67ed59e1d1-343dddeefbfmr4942912a91.5.1762973927256;
        Wed, 12 Nov 2025 10:58:47 -0800 (PST)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-343e06fe521sm3491565a91.1.2025.11.12.10.58.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 10:58:46 -0800 (PST)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
Date: Wed, 12 Nov 2025 10:58:33 -0800
Message-ID: <20251112185834.32487-5-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112185834.32487-1-vishal.moola@gmail.com>
References: <20251112185834.32487-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DDC8E1C0003
X-Stat-Signature: 3gp4n6dprqokq11113mc5jnsf456s5nb
X-Rspam-User: 
X-HE-Tag: 1762973928-686141
X-HE-Meta: U2FsdGVkX18yqBkj4k/qa67qj1CtKwgOxk+su1tprPttyM0c15+xiH9Z//PAuC8PF1qwJh97XdYFuFSm1u8Gxx5o1ciFjHi37e2nqYFUh/rLwL7Wi7U/9WJdBxogMyYJsiFm+JZ/i5w8eTdqm1q3NTZzAyFwCkH2hMLGCNUrS5Y6wUh1qYkQIWFMrVqWQxnfGh5BHAkhIQH31VNjy+vCaDGZ/7ov7ERpuTbCxZnLcBYIGyEISJPiHRtX2uWl55M+oCc+UbQDMoauRLQA5lQlXgpA7NBSn6iVxYL5pcYnUTSnzNqGi1Bm76rTO/ARhbxPtFQUWRX+gbj2h6LKFq//RsSTz/IiP2gaFKXV8DmINlsF3YFMDFESI2CuMe2YaVk+w/yzmafS5rpRBshTf1N44xhKseL/wwqUkTYR2djOFUNUSAsqdAKyyXSWmJXqx2OPfpcMlyqhUF5hoiIuiVKmKOWNHaJ/XUaV6r6mj3BqwFM2GTNYrcM01qx4wJyspc7UIP3l7IMfXDf8PKN6EFcTY/gwfl57GSkEP0ECmrqS4y27n28ZUWY24/oJz49eek4BJEtceVfwXTUfUMA+dLhdxwoNkLp9T0thbKHtqp8X+Slon5XCJ2h3aJ+Y1cMhlMHyRM0bB/HNNubfb6/bzho2X4+RE0EoTW6wb6/ay/74mtnAzUzJyE+iUhPfmzVEdXo+sxk5I6Puh2psYYCuG1Cok+V3Rdg2M7cgRZeG97IPi8POj6Ff9EWXXCCPMxRoXcekoXhPh+rFtsDfWu8oaiVPKQ+mSxQjFHY31/l+qLig/wC4TutavdAJHrW5C4skMVVgFKgLyJJrf/TOoDwCuvmL92Dp6Sc6GlMsvzH6u/CKXettRT4RK1IjfBW5steHX4FkruQUYQUcAHj13cc9aDzMBVoq+wUiLaz6Z+QTzISdYkXtHmcNjZIVcO+GbB5g/UBz3/kIZYRiJySXNSyC9CL
 eZ5unoUm
 mW45nmj7yncOduhZS3CG91mjCoIbEHUDLWSfpPHeW4bC1090joA5qSlR+r8txSlq85LpGzANbSfJ6m1yefdTXOEPcS/IRxJXdK9qblGVWyEoCi3kFz0T1d1qmW+Ks5lLHgRobfIyHEU33vORl02OSkjN416K24g5nvP2wV+nw+X9fLNuE8Em+jGPcQReylIFyDBLZY58T9BneeTdQiuI8rB7YFuO9f14DI+B1Nw83csbdutEMIKw81rvEIPUA9EcNdkXDUkVbAWNimD18hv5wyeR85UwhrlFICL54E/e96UuJRNuRmU/rWH4YHbWY9MK2U4Jl92l8Fq7JnLRb+8gd6qaBVtovEKrw4RZ2IzJrosXsSW0jUT47vlYiwpqU7B5A2HPmrvwRy4Iy2XPedgdgp0ac0/In9lxfTGpdohCgBfuc9KG4A/NUXOIivV0uc82gDXw8M9d5vLP747qQ0s4/I1k1b9oSxFg5ie3GZwzUkjVlyMXoceskoDsF58vHxZbk0k98y92i1pxb2t7+Zp2hfiz4YGLnvjoZ9otPe1V9Old+UJ/0rta/+YqXeEAMkCn7tijgcGSzwPdaPqdDF1Cg2cx+FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
this mask here, remove it.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6a3ee36d77c5..49e0b68768d7 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
 
 	node = numa_node_id();
 
-	vb = kmalloc_node(sizeof(struct vmap_block),
-			gfp_mask & GFP_RECLAIM_MASK, node);
+	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
 	if (unlikely(!vb))
 		return ERR_PTR(-ENOMEM);
 
-- 
2.51.1


