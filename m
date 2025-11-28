Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46BEED116E2
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 17:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE9C6B0088; Fri, 28 Nov 2025 12:33:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95BA6B0089; Fri, 28 Nov 2025 12:33:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5F7B6B008A; Fri, 28 Nov 2025 12:33:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95D956B0088
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 12:33:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 37F501A06B6
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:33:20 +0000 (UTC)
X-FDA: 84160712160.29.32DD21A
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5945440014
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 17:33:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GkXzD7d3;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764351198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6cWC0EzQIcNS89FvnWsoSYVSUcViyL1eUCgfCzryJw=;
	b=znIAotJbffE71e4vWTx35fCcUB3xyAPX0sQ6qJl7wFEI/9lI1vrljOl4yc8tG50BtyHux5
	Uc6copTwahZYEHtz2abfMViygkBp8wY9mXW3DYpjSaZQl4MNCOVQ1CN6bficCpMNVD5Jm/
	VJ57cDrJJl2DFfrZjZXuKpwsBQ6NXIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764351198; a=rsa-sha256;
	cv=none;
	b=SLKMsqZmhi3lH18X+FXQpL8K0crMussEe2M4E5tzgCgEDY3cD+IJL5ei3CW4K3FgW4sW28
	NFJcktUbo7RQZTWJrGZM9uUQnJNLsK1zHzd6kd2GHnu/XxdBtXqxlMgyXRqbD/C6mG7Adz
	UC26RqdIjH3wQCAZScreNuwzABZ4W4w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GkXzD7d3;
	spf=pass (imf04.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-3e3dac349easo940993fac.2
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764351197; x=1764955997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6cWC0EzQIcNS89FvnWsoSYVSUcViyL1eUCgfCzryJw=;
        b=GkXzD7d31uFyLquiEnU+EYQd2D7G/qmaz2x46nEfrx+WwnL4lHouDoxrB5rE4Y4goq
         wfMsZAKCZ0ab6QzBD/XDZaJxNVpZrN1TRbLZkNn/mnQ5OVLrk03FwV1tmwrYAvn4ChCE
         9pK1WSIo8FYZztobW3Cgqt2QJOo0ip1ROnD+AXr1+V9KsHYC3U7fx7P0TMduStodYzGr
         VKXqXV0r2s9pIoo+oShqErvnGRV+13lLVJu3DfECugJOZnH9+NEe/5LOEKw6M6y347gK
         uBsp174OSeqgcfBqLIcKcVnI7hWU25G0rnjsfkQjs+Nhz5QiZodaMz6cfXPQ5368yVgl
         gCGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764351197; x=1764955997;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z6cWC0EzQIcNS89FvnWsoSYVSUcViyL1eUCgfCzryJw=;
        b=IT7sc3UOUhAxNFjHNFSSkKZy1IxCckKIdupWLvucrJlk0sNTw2ZaF4ZY8ABqfy4f7c
         jUWzeQqSEL0lIygihL21U8Pd6CcM/ZOR64luTY2pnQbLofqyYYgACDc+6ggutKc7Uz2O
         bi9J/B5VEbPOy7lVoiJSa0hNENBTS5SEMF/+3AdpqXI+R0E7pX9easCU0KwpWdhoFdbC
         9/3rX2XWOyRemXLy/B7QoAS9jS8GQtrNsIvR/3/CXNIkGfUM7V8PxnT55L7po4VBRSVh
         y6+j57JMhqM0Y0k+lHpmBloNzwQxNpNRzcD70BpQpZOWqvEdas5xdosaMLQS9OT1yTbN
         wOTQ==
X-Forwarded-Encrypted: i=1; AJvYcCUH43Wo9LSTrv5gAwN1+UXmFhZVtW7+6BnivG1bgrjZF48k84mRQ3sriQhneav7345zWjTJqSHkyA==@kvack.org
X-Gm-Message-State: AOJu0YxrrmWXyBmyci/2FYMtjJsyE6aC63A17irE6c1t/GMwjpUyKVyW
	wRwtnkLJMzTjKTHRljBAq3k0DAKmNnjMatr6Nnlot/WiS+rQL19WrYYX
X-Gm-Gg: ASbGncsijEF3dBpTzipLeWMsAFubShmD76jLtHxWttJntJY27dJcKG7tb+ZOpumKPvr
	H2fjWaL+AMY5DRMGG6yiHyVQQVvtVBcEq1d722LXuV5gzSvR0feqZIXCHysGsCLZYJy/wEsBX7H
	WThxxnpdC6U0dBOM0zJVroi2/qtm/lmgJUpt+qkHaguT7x3xkLlmsL5KRLU7mOd6lJt9kzbZv3h
	oEB0XbJdjwUVKRxwRkD0a8hv7ko7E4+R33B0ZCZ1f/yHUuXBc68JQy1bA839ZdGefpvrxLXvUa+
	SR+rG1FEQijPoue2xk8oJ8mgQBM7i0KFZVVj3ZmxNy2cmDpiXErwnLLk6x4Q87e9kqS2BvgNXD1
	qPJreqsCusm3Vov29Gum567pU186A6GyAd7W6gAmC+4C1AZOm3NHdTb53QKBbLxkyEGtwwJcC3Y
	JytnTVyh+oPREevBco
X-Google-Smtp-Source: AGHT+IH3+iFe21TV8dIM/ejwqJ5VQ6dMyACTVp3M7T5iA/v+AYOdAjBfSfbkau8+AjRXAJN4oViXAw==
X-Received: by 2002:a05:6808:80a9:b0:44d:afca:523d with SMTP id 5614622812f47-45115acab75mr11162059b6e.32.1764351197197;
        Fri, 28 Nov 2025 09:33:17 -0800 (PST)
Received: from localhost ([2a03:2880:10ff::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-453170cd4a4sm1425814b6e.17.2025.11.28.09.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Nov 2025 09:33:16 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kas@kernel.org,
	changyuanl@google.com,
	graf@amazon.com,
	leitao@debian.org,
	thevlad@meta.com,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 2/2] mm/memblock: only mark/clear KHO scratch memory when needed
Date: Fri, 28 Nov 2025 17:29:34 +0000
Message-ID: <20251128173257.969322-3-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128173257.969322-1-usamaarif642@gmail.com>
References: <20251128173257.969322-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: xux84gy79ubyoyjgy36haf8wtmoj8yob
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5945440014
X-HE-Tag: 1764351198-913529
X-HE-Meta: U2FsdGVkX19NDvWJa31rAkWs/JF2fEeEjivm+seOH2oFWAXKL3mxIpW+vE4tI7lHglPE67L8ncrkba7SkjsEWM2cK1Q6actQyVeMlhPOYA49Pzqb5fg6ExHdMdVuITkbeW0RPCQGLFQQHoV9yrwDBxUvLdLzSPqcbOdl+jd/kXQGdODkNXS+1YWq6QiWVPQ4j7ohrcyPt1auPVbTxOLH93y/HQnoHkkC7gC72G5oEauOk8HfxwNVP13fKuuIIYthxC0yX8n0FBXuNaZbLRPgV3B0dC7Pstzx/MZOF0fCcl6vrWvXaMqSqN1QcH6zD2yVL9Y8P9ORTHjKvO/mAu8nUP+JRaRaDh1+DHdB5baBGekW8oMUf1qbQdXK6RPVSQiCsx19/bDCuZsSWbTsbpxclWqbNWFNCvEPs7Q/kfW7PPQtWfbF/Y9tpkGqoA/lEIDe7KctdyEzhSsA9SOMmMz3y2QdMwzr71D4CNnQWTfmrSoeP41eADyFg+Ywo/dgwuokkJMBYh0pck1aRBxaRt4N3Yn1N25cPhM/lIvIJuyIPCOPdA9oFF50fnc9yXr6c1tZp8jnb1rT/wUEAihpbqLlOT3cGP2tDN4U2TMaVf9D4W9YD6GFsPMMKg0KQzTVnLz5RLbyrjkpaB+NzG0fHFhFNoMgXKJkvJ49B2WgNZ3UsUR+YGMFlxOzNz94kTbcLMokSqztfo58q6I101uwFyw2yeomA5TIPby2bid7fPe7V9O6NDMbVoO7mJcLriOJzUBsj0vzehAShGaZ1bEqZXvVoTWZ8GyBSMnShHK5zKPj/1j+CknzWw0JjYDQsI6St/3jNOxBxQFHLKrX6lblkOG7p+g/Q22IGQA6gd7CC0Fg/PWaQGcxfiCyoLtBLoT3Tz24RSUkO1n2FrrnjjvURFq1eRD90Tnx+mX1Y/yDvGS8go1IooZvJjN/hYKV+/EuRTerjIQ1slfQJLJPtzteExC
 zHwiehL9
 8cqqIEtwL7uIwC1nrGusPAaGetCp+fAnrHTNbwJy8QFnnf6m3krsoJGS1bTirUws19OuCTv3VC2siuCtGFdy4fLYIIlolnubED0bhJEA4SQw0JjYQwhiRtlrqtbYBa4j3rKYixhtkr/NNr/ohg3ccg9zQNDsiPslJar/GbjDuJvVBM1ydgsOCPc/TZARnQlK92btDomw46ieMGbpxnaG1qCspZzOPvZtqzCzyzpiEA4nN1vhvCUZ9x5tLt3mqXwRspEu0WxQPiHMcQ33niJOLVCAi7VkWtR1HuJU1JX1yo9FcGZV1Hm/pBY1QBLiedXTASh4WpK8sMwYp8gPC/yLaWGJ4ptsYMMrI1j0mL8ZYyXiDkrmfRaZC/dSKb13Dh93mhoQ34/YLsNgI+REcpUI0pBUmDD+34pUESNSXRjuuEj7nsXk3j+zazVyZKQ/S1wKo5qtiGdB59AtL/rsP5rl99SxkidQ++Ja0HcPQRC6HHWBza60x0UDrAh1Y/+npl+TisghECHHKjY7Ek4I7A97qH3TteJ/rladMCj1TpXLJc8lqNMn/7APbvdgh3skEqxmG54f6O8kWZizZR2o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The scratch memory for kexec handover is used to bootstrap the
kexec'ed kernel. Only the 1st 1MB is used as scratch, and its a
hack to get around limitations with KHO. It is only needed when
CONFIG_KEXEC_HANDOVER is enabled and only if it is a KHO boot
(both checked by is_kho_boot). Add check to prevent marking a KHO
scratch region unless needed.

Fixes: a2daf83e10378 ("x86/e820: temporarily enable KHO scratch for memory below 1M")
Reported-by: Vlad Poenaru <thevlad@meta.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 mm/memblock.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 8b13d5c28922a..913cf322eb89a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -20,8 +20,8 @@
 
 #ifdef CONFIG_KEXEC_HANDOVER
 #include <linux/libfdt.h>
-#include <linux/kexec_handover.h>
 #endif /* CONFIG_KEXEC_HANDOVER */
+#include <linux/kexec_handover.h>
 
 #include <asm/sections.h>
 #include <linux/io.h>
@@ -1126,8 +1126,10 @@ int __init_memblock memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t
  */
 __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(&memblock.memory, base, size, 1,
-				    MEMBLOCK_KHO_SCRATCH);
+	if (is_kho_boot())
+		return memblock_setclr_flag(&memblock.memory, base, size, 1,
+					    MEMBLOCK_KHO_SCRATCH);
+	return 0;
 }
 
 /**
@@ -1140,8 +1142,10 @@ __init int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size)
  */
 __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_setclr_flag(&memblock.memory, base, size, 0,
-				    MEMBLOCK_KHO_SCRATCH);
+	if (is_kho_boot())
+		return memblock_setclr_flag(&memblock.memory, base, size, 0,
+					    MEMBLOCK_KHO_SCRATCH);
+	return 0;
 }
 
 static bool should_skip_region(struct memblock_type *type,
-- 
2.47.3


