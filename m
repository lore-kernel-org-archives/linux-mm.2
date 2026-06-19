Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A2A2CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 11:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF77D6B008C; Fri, 19 Jun 2026 07:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7F76B0092; Fri, 19 Jun 2026 07:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A98D06B0093; Fri, 19 Jun 2026 07:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0156B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 07:37:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0697B1203E3
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:37:03 +0000 (UTC)
X-FDA: 84896460726.29.937EA39
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3E89640004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:37:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q6hwa4Zi;
	spf=pass (imf01.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781869021;
	b=nQ7fvHeU0efHVwf0YxuOw5kUJ4Iagd6PwZYCAJl/23HvR48AchgT8ODEFKCvVAwH629cUe
	FbNTeEOSTrOGjtUVvRudwj/QlmyG8Xag0icwuwRGdxt3DaoQGMvhHHJs1PEgJLiDIMhfcM
	caVZ9317w8ANLAfbZBv1vtxtTYompN8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=q6hwa4Zi;
	spf=pass (imf01.hostedemail.com: domain of jakovnovak30@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jakovnovak30@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781869021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OOnLthBK1ZaLDe8IBLdmwVbR76i2jOQdkD1UWnvKsDI=;
	b=i3RO1lrFDbK+P6SDFl9OFrA62KJBUBVnXBnqgBe7ewvXoxzFeZowsv+vYsTtcKvyD/+Y3R
	tXSM/4zkmYrutNpiPwLZND7CN4FPIoOygYb+uuEL8adueSffB3yt5CNIQY9JWCBk6VLt37
	6MmkcA9FFuuKmCciEp9ZlozvC3AALO0=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so23567565e9.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781869020; x=1782473820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OOnLthBK1ZaLDe8IBLdmwVbR76i2jOQdkD1UWnvKsDI=;
        b=q6hwa4ZiRsbAEAjHueScBL1YXZ1bh5Gfig4a97jU+7kGe86vjFnEMbgMtcvKDckrCd
         ut1/4UcyRrFHhxx+EtDCSkn3314/lj5wNMrETUx5rsbqBNTDxtjmtb7tMWXV+eN0KNQk
         ogOtCdwjw0yn3MtdyA/F2M5n8RUHi1Zi2eafEXb+z+TpMyzmDAXP15sEDXA2Yo20hSSV
         STlqimBlZTQYSvt3b3vIPkqJl9FIbYt6ukwiqg906eyfhmNgbOV7hw9HEvdJVgMIXKt2
         c2MkBmywZ7hGmsA7l22Sk1yxL2tJ2fC8WGCQSmq4GWEJtOxRwbrsA158yAgSDBmPf+xv
         Gr9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781869020; x=1782473820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOnLthBK1ZaLDe8IBLdmwVbR76i2jOQdkD1UWnvKsDI=;
        b=LCB/6B0LndMi9Q1uOzi6rFZ3/XPihxlcGwF7QEkCXGCpWO7EABhDZ2pibh6hlzNMEe
         UBpXlggMkYG9n8g9RS8DqG4fURPaIyKgw111hsHhh7XTzN5ZLJqbdeV4YscfuRHQPdTv
         sSwyyF985tD9hakhk1Frua4ky4mBuG43h+qdCMaK2dna+jJMDH4aFzy+VWTM6op9aS4y
         wiB0+lPBy/FUjEF4TwyvSwFg1Rg4fnw5MYqnVc4HFcM7ycFtDtLlkWvv4JVsQDUSqqJF
         xlDWuOQ2lAjxv7o9rQvVr9waHJ4whp44nxnEKxHijGvvPz0iXqEKvmlula2zwL5iFkv2
         7daw==
X-Gm-Message-State: AOJu0YyYbei10WVItL9B+yxOShlYq0pPR9uUaZ8zIzgNLoN6AE/GrDd1
	mHXjVsJQF8xgfZ+ZNeWoCjylcVxWlvYnYjTnkw7zj9cU7bw7fpebTGzDZubWpiU=
X-Gm-Gg: AfdE7ckNra682Cr3engySSWjyHP0mLl7153OlXr1UF5naj5ceI2vxEZeudOnQjiwtq8
	ovTK0zeyzngPFI9emqJSiGVim1a1OM+vOSZJ+nYTtmIwGWyiltdkaBPcbrbpTKib06CwctQ+WDa
	z1GBMneRaOb4Es2QBXOjuqyGKeoM1/uovbL09/zqToNpCnOrbzthM4nD2grMPCC2Rx5bQ8uMhaS
	OxRT8yBDtH0nmwBHSbh2uhPz/QZzXlmF2RaLNC6mK6Q55fjxa0SIUjvizjz1dg5GLSp3HjS9M5F
	8Nd8btZ34MVxdOzNJfkJdEgQ6NjzhACXlzHlZ5WO32VcPdB9s7r2cnWu14YA076QNUwrMwUC/J+
	6dJO/kMPgJWbY+z0tMSmeq2JlVotuoXS+ETu2nhOzrw7CdrJQBnh6Vlxbo9mlSfvQ9K1XtKYx6F
	1WBNCyUNwGXrhipmpOgOBG7VtUz648b1zVJKWzKBDP7nILHiCTw4oxE12VBX4bw2mz831BglUrK
	tF92BvcWCWbn5q4VTH1jsotz/X2/igEuC3JAZMdUW0=
X-Received: by 2002:a05:600c:5010:b0:490:e19b:9632 with SMTP id 5b1f17b1804b1-49240a59ademr40537095e9.17.1781869019472;
        Fri, 19 Jun 2026 04:36:59 -0700 (PDT)
Received: from archtop.localdomain (92-242-249-25.broadband.mtnet.hr. [92.242.249.25])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49240efc160sm50419445e9.2.2026.06.19.04.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Jun 2026 04:36:59 -0700 (PDT)
From: Jakov Novak <jakovnovak30@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-kernel-mentees@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jakov Novak <jakovnovak30@gmail.com>
Subject: [PATCH] Docs/mm: fix documentation warning for GFP parameter in kmalloc_obj, kmalloc_objs and kmalloc_flex
Date: Fri, 19 Jun 2026 13:36:22 +0200
Message-ID: <20260619113622.11712-1-jakovnovak30@gmail.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mtihnqhmomcngxedf3rqpik8b56n99po
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E89640004
X-HE-Tag: 1781869021-79139
X-HE-Meta: U2FsdGVkX19CPeJOZ3fAsYjOUSLJYeXlOhCWEDqRv/otlJalv14AT3rOsLwaf3Tw42q/Yh7MwI9F2XNIFWbG1Qnrlz5+Mi36jNaPEfOg2B3DqE2KWkr3TKWgOiQhVhQ5X8OEysJPQ3kYwuOjOXb2oLU6uHHLEcSNKjt75wgTNiYGfzGKsdESM893ShcRdmuD2GgGeQykwtiQLyGtm0nVxbfmVypJ6uoCg8dXiIn72sZMQilMQMcAJ7xRRwTzxCqilkqvRKfY4NiLKJFL+2HgowLBXFgQJM22bhCfjryjxBT++rAqyG/3o1VVYKt3v+QF4Zbd4XMQoLDF8zkP+8X4cv5aqgho6xen2ToYXKTXgA0SVoeEGerD9rV6R0hvz+OgkRSzlQ867OdAff58ClOR/jC3buTM5Tfm/QVuGHmP7tDFzb23Pfu5P/FbrJ6/hwFFXlE7+Oo10tBFTxEd1ssiKsKwHa9poRnt27gy2HdU8yCF44PvTOkoupc8yYAX51xAaOGHENHoo3PrFBuqf6haPliPgcXbAk99GLEA6axjgRnBV5X3f/CbnMuf6XSx3kMU/KhxE4xKVOrbIeroQSNQ2TGpqQ6aI6FoqE4KNA464CvBEm0yAbIVJcKhAyG4rr9VkS1qusbA4ouOye31e+UeOglXB1F1mJ68ZP9A84ikcB2UEbEMJm2vKJGYZxLHibsTgrfcfYwUvxvz3rK8X1ctDIWtYZ0TXvxlYxCOHsjyeItI4ChrMAWBwyjUqvV8H/xuvAeFeS6n3DjvQmRpDwyiIP9Bp8bCK65yGsM/0w956eIAuTVmpb+ixyXuIDrLAtd5QXMNEIKM8Hw+0D8aCGk09wLOvHC8tmtmTbP35wW5uwMO408OTXc9m4Y7Fr7cTqJOl6WvY/HEonNFKN3uBxnmQddg54AlPlJbuW3f/VkZJ77j2PiNwbSAF42DC1ipbcOZY42pXoNJf3JrwRgIrfZ
 H1srSoqz
 3Q56svQKdFXdu4VBeATS6r658Rn4CINaGokuiYoQAnra3tiS8z4HutGzehqG3TlHXgN/AGFhZjLdvlkWW4DRY6BDrg/xEWx31EWJL/USN0TCapYBHYM9Mp5166+IH317UhosoARmCJ1nS7evuK7IugAyUTy+8NuEAKDMW04Sb9Fc8MUEBmy1SjVNpWu7OqGcbNjS26Ibz+xuS+PdDfe/toYrYAuVby0WUY5Blo+F89rrLH8Aseq3dVilICbXCf4I3+N3niBcvgOC/1bcaaeBPs/UfD63avoymMWn0DXxvFDKJF3kdlQo8rSsmwzh2t67eiC6WymxczfE+gYtn+6l3C8HoxLYmQAU00IKRuRldOYZrpQb6bCft84jA75NtVYPoHtZbtJXMGazhAdVxcspaH+AwoCgBwN/5xa24KcrdtHUXJ7U4alDCcBV7J18f0PuHhnycgKr030qJ91A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compiling the documentation currently gives the errors:

WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' description in 'kmalloc_obj'
WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' description in 'kmalloc_objs'
WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' description in 'kmalloc_flex'
WARNING: ./include/linux/slab.h:1100 Excess function parameter 'GFP' description in 'kmalloc_obj'
WARNING: ./include/linux/slab.h:1112 Excess function parameter 'GFP' description in 'kmalloc_objs'
WARNING: ./include/linux/slab.h:1127 Excess function parameter 'GFP' description in 'kmalloc_flex'

This effectively omits the GFP parameter from the current kernel
documentation. This patch marks the "..." parameter with the previous
description of the GFP parameter along with an "optional" tag in
parantheses.

Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
---
 include/linux/slab.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index d4a873a16289..ee952784a150 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1093,7 +1093,7 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
 /**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
- * @GFP: GFP flags for the allocation.
+ * @...: GFP flags for the allocation (optional).
  *
  * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
  * on failure.
@@ -1105,7 +1105,7 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
  * kmalloc_objs - Allocate an array of the given type
  * @VAR_OR_TYPE: Variable or type to allocate an array of.
  * @COUNT: How many elements in the array.
- * @GFP: GFP flags for the allocation.
+ * @...: GFP flags for the allocation (optional).
  *
  * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
  * or NULL on failure.
@@ -1118,7 +1118,7 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
  * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
  * @FAM: The name of the flexible array member of the structure.
  * @COUNT: How many flexible array member elements are desired.
- * @GFP: GFP flags for the allocation.
+ * @...: GFP flags for the allocation (optional).
  *
  * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
  * failure. If @FAM has been annotated with __counted_by(), the allocation
-- 
2.54.0


