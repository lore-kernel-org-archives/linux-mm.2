Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D35E8CAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 08:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96B58E0002; Fri, 26 Sep 2025 04:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C48168E0001; Fri, 26 Sep 2025 04:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B853D8E0002; Fri, 26 Sep 2025 04:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A9E0C8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 04:07:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 572261DFF84
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:07:53 +0000 (UTC)
X-FDA: 83930672826.24.4A79F0B
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf17.hostedemail.com (Postfix) with ESMTP id A243440006
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:07:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Fyw9lcFo;
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758874071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eG+YgXbmxmL1fdc1WNA6B97Ki+iNg7J8UnqGI9peY8o=;
	b=sUk4JeNb9pMwkBiWHdCIhFs67aFM6F0ojQcyVitv0SdIQswwd5OHsIHGa2XAH18/doilW4
	ohu8PQCtRl65wdCUVBbA1QISl+IwaEDdg7ulM59XgmrMIbqP6LuNHz1oGIkXlO//sGtxpX
	EXiECRMxoaArkQLBik1//2E9QZqsXsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758874071; a=rsa-sha256;
	cv=none;
	b=XHrrPYoyAcr98TjGBJgH2OtCdU5aWDcNMXQ9QrDGM9H20cjhKplKaTcvVJw1vOVFVUxfNI
	8Vw/m0abrMbE9RHcsRIkCJ4qc0BAIgPPrrRvwpm94le746RO+MyUyZbdnAOLCxlsITsGLu
	yfloIWIf8Hh9a6W6ktVxHmxTrupMynE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Fyw9lcFo;
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=eG
	+YgXbmxmL1fdc1WNA6B97Ki+iNg7J8UnqGI9peY8o=; b=Fyw9lcFoNn/oP5HWgt
	wZPn52GNOJeN2Zo9EYZ1zfO6jKHK+/YxWjfOo4XIwnKxzgsNkc5LSU9RYWalE+Nq
	BrgdT5zLXVWAMoAI1B5VMrtVPPITkuUIY/gWe8vNjpojDLrZBRrx4jZxntbwLKuL
	///UJ+PXoOzdEfa0Cbua/VSsY=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wDXrxOnSdZoMJvNAA--.138S2;
	Fri, 26 Sep 2025 16:07:05 +0800 (CST)
From: ranxiaokai627@163.com
To: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	usamaarif642@gmail.com,
	surenb@google.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH linux-next] alloc_tag: Fix boot failure due to NULL pointer dereference
Date: Fri, 26 Sep 2025 08:06:59 +0000
Message-ID: <20250926080659.741991-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXrxOnSdZoMJvNAA--.138S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7uw15Wr15XFW5urWruFyxGrg_yoW8KrW5pF
	WfGr4DCFZ5Jw17Cr4Dtr1kWr1rXayIvFyrGayIqr18ZF4rtwnrXF1Dt3WF9FWDAFW3G3Wq
	yFn5AanIvw4UZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pin2-UUUUUU=
X-Originating-IP: [117.176.243.111]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEgDUTGjWRrtgLQAAsE
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A243440006
X-Stat-Signature: ysnpkqpk7mshhso8otfjm9zs3g83re9g
X-Rspam-User: 
X-HE-Tag: 1758874070-71033
X-HE-Meta: U2FsdGVkX1/A2SC9iqpZ/c5U+xIl45qDPuhzziFrDsEM/zQcLXaI8ca9sdHI6NlBunVW4nGKtZLD0OXbnChGiUCtWpLyeHKeurE7bzepHWqk4les0lYGHt8DzZTUOgEAkeBBj3kLMWtqxh6Yn/IS4zJvY5rFYjF7ALlZdUIi0VeNGU3OSFnCkfKyaMgM6skKXkBaCh4DyZOx4CLsmoabKnon0P+ByvA/sdCCuLH1wB0gqk5R+YMR0NsBbbuN6OwaS0Sem8M8CZnfC0h/EezIlnrdDobk0WlgBltO+QZ7gWhwnK4pCs80GODH12SN9SPcrSNoMinzEGbe3OFFRKV2GB1RVhiDJ4SIKr+cnMmfrZd0qboVCkjTAijIZXZHjbfQFcQRWRWyW54hW7XbZ+2M7RboHIjkK27P9LvYP38GoWVOyqAOmIKhZw0VCTuonUWsL1y3Q40GpcqH+0ksxgXdN9R5Es77f2YUG9MUf9jL8s52eET/c3WvbfJbI9tpWzeA+jTZFjPwymwPcEcXBWcWk2YAXcM50hdlxB13JHce8v/AclV7ZV3FMAQu/sk0ciXiOWaNmOT2Khy5WJxSWI2iCmFOvYaGa8CcpSrQRqmhVT9B/5nx3+I9SlfP9oX/3maQ6DVkqhKYwRfzoak+75Dryw7gVxhr9FmdWJWKaOx3P2WGGsRQoIG7nXMpgqx1TZ3f1dRaGPjZZyyy/HfNQ+Ql9rvIBSgmzGJ9hc/z+shQ0YJ8biW76aLkbNG5InM26aHVTja2JF7Hj6sq1Yf4OJrOl0jHMXJXmkN6S5Ai9lskG8loMnCZiXGVwuWLQYBQeydVS8FeKtY4vOjMrM4e0AdSp5YlXovMO6GGaIpXoFNy2pmWpl5/zCYui6f7XiTHi6IBeFkjTsHLrKhlFNeN7dZ+pRGk18a/W4FUDlF+XeZZLumf2CIz/p2qiC43j4zQ8A6PP3PHwJmwIfhLGfPWm8H
 baqGdZW4
 /shbHCDqL8iNho9phIwQlGLONqU7UCqTAWN7XbS7W6pgldU6BpBCER9NZ21rtIDicCBrw2sPwLUIUVsihHg/QHGJmiWNnXpnIvJ71T2WBhe41g4VHAfgfuXj9BvH1rLf2uKGpOfoCJETVwP+tl/4Vl7jlIRW7gByGJEDW9bx6seHe5sneuEVq/5DyJnRLoOmFn/frQ7fyXrZQCyxT2aJutEzvsZX23M88ZgdfW4fmX+XOUcvP8CokCBNyjnAM4rBXm+H8EOKI8Qhyh2YrStKtlEcgT8hhZp+4AtufisUDbTuzauz4qU36/Y03i+nrzQT8DxoctyDoWxLqqk08a/56UbRq/wW8iiddUbKbmvhujP/0IhWQQOk0iecEBs8oBOiG1N5iLuqpPXvsc3r+i2w3xebMPf3Saue0T5JEGiDgY0mnEtDPO19MR52mugaE6agBeanx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

There is a boot failure when both CONFIG_DEBUG_KMEMLEAK and
CONFIG_MEM_ALLOC_PROFILING are enabled.

BUG: kernel NULL pointer dereference, address: 0000000000000000
RIP: 0010:__alloc_tagging_slab_alloc_hook+0x181/0x2f0
Call Trace:
 kmem_cache_alloc_noprof+0x1c8/0x5c0
 __alloc_object+0x2f/0x290
 __create_object+0x22/0x80
 kmemleak_init+0x122/0x190
 mm_core_init+0xb6/0x160
 start_kernel+0x39f/0x920
 x86_64_start_reservations+0x18/0x30
 x86_64_start_kernel+0x104/0x120
 common_startup_64+0x12c/0x138

In kmemleak, mem_pool_alloc() directly calls kmem_cache_alloc_noprof(),
as a result, the alloc_tag structure associated with object_cache is not
defined neither initialized. So current->alloc_tag is NULL,
leading to a null pointer dereference.

Move the checks for SLAB_NO_OBJ_EXT, SLAB_NOLEAKTRACE, and
__GFP_NO_OBJ_EXT to the parent function __alloc_tagging_slab_alloc_hook()
to fix this.

Also this distinguishes the SLAB_NOLEAKTRACE case between the actual memory
allocation failures case, make CODETAG_FLAG_INACCURATE more accurate.

Fixes: b9e2f58ffb84 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/slub.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 867a07260acf..09cbe580842c 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2197,15 +2197,6 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, gfp_t flags, void *p)
 {
 	struct slab *slab;
 
-	if (!p)
-		return NULL;
-
-	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
-		return NULL;
-
-	if (flags & __GFP_NO_OBJ_EXT)
-		return NULL;
-
 	slab = virt_to_slab(p);
 	if (!slab_obj_exts(slab) &&
 	    alloc_slab_obj_exts(slab, s, flags, false)) {
@@ -2223,6 +2214,15 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 {
 	struct slabobj_ext *obj_exts;
 
+	if (!object)
+		return;
+
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+		return;
+
+	if (flags & __GFP_NO_OBJ_EXT)
+		return;
+
 	obj_exts = prepare_slab_obj_exts_hook(s, flags, object);
 	/*
 	 * Currently obj_exts is used only for allocation profiling.
-- 
2.25.1


