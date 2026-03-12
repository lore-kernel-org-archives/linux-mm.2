Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 843BF105A596
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 13:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C836E6B0099; Thu, 12 Mar 2026 09:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F016B009B; Thu, 12 Mar 2026 09:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4AC6B009D; Thu, 12 Mar 2026 09:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9AD636B0099
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 09:15:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E4138A592
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:15:04 +0000 (UTC)
X-FDA: 84537456528.19.88CA2FB
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id AC873C000A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 13:15:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GEUlsQap;
	spf=pass (imf10.hostedemail.com: domain of 3VbyyaQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3VbyyaQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773321302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IsWJwxKJY/UUzozHqxJ3RR8tHHBCBI46iF/uMypPY4E=;
	b=nLFktErhJ30HZ87L+a6XGQ0Qy+kaM0j1b20GvgHe/32GjqYgBeHaqGCodrJwfSc80AcPWS
	MajYZmtun1/8N0gblqJnO4xxHDIpjK4TKu179knLSi+jbAd9babVPXmrgBwHOXY/ypkhTA
	JYHz+qEAwMVhNcDfpuTEkucdtUp+SHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773321302; a=rsa-sha256;
	cv=none;
	b=adNce/qfszNUGJ0iNMHphLQ8b8zbuMChs/vl7D2xvZq1B2XO81e0ziP0N1LBMfNsQhU/5c
	5dj4wFx47/zwlg+5VjchTjNPnHmBmi7cMS7Zb131AsgGIz5DBfXSVCQTFQOqeFyEhIBIFB
	Hh8YU8dVOKiffHJ1NYcTG0l0cJjPBds=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GEUlsQap;
	spf=pass (imf10.hostedemail.com: domain of 3VbyyaQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3VbyyaQYKCOwVaOnifUccUZS.QcaZWbil-aaYjOQY.cfU@flex--hmazur.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48542d5aa9eso7245405e9.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 06:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773321301; x=1773926101; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IsWJwxKJY/UUzozHqxJ3RR8tHHBCBI46iF/uMypPY4E=;
        b=GEUlsQapKKRkXlvjNjAqOU7Q9urcR4YLb3DLN21C16Y5oyAsZ242eCNTwN8aadGtM9
         XHNiwFDaat2tqGVMlLWB2Wlgfzsz2Xho95PwPsG1xr7B58lqLRcSR1YoGaIK+HiYuP+V
         klQ+9B+owdN7XFxxQ5uWcVBmOJxKHmUQYJHRqv2449EL1EDn3BgcFzXtBdiH6A28YuYZ
         /gbMwblh/XAqf3sc0p16Rv6GKW26PtHut4tY94CH5tjkYSWUWg6ybdpdIYiRxbJDj6v4
         Ph/tWyuZTQaAvB2vQR2uTLNVG74DzsQ058rcY7N2c09L2daa1QaD3/Zq3/dMRv5jKbpk
         vEMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773321301; x=1773926101;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IsWJwxKJY/UUzozHqxJ3RR8tHHBCBI46iF/uMypPY4E=;
        b=Q44PjSVhUGhiFjCo8u0VOT37u8ytY4s5oBAhnSyxqlZX3OnL5PqWtvL4fNNt22CqWQ
         nojI/XVDyxzWUXc3NM70A2E5L0STHcD2fQCoJj46to8jL5wyO9ZLc9COFqQW5V70MtaI
         LZqPVCqozD3+VXb81VpuQha0SKw55VJmKip8BKgWcqdJYKRyRgzXtoH4DkjUE2qp1gLk
         4Rx1SxVkcpQxCBeuJ/OfxiXRD6zO453+0vRB7Xjrz51zYv0YFBGxEePrXTv1JsuJUnBt
         6TnjeIbXORnbb6AV3ZXo8vK3r/rm23Y4A81Uv6vwH0/mf84pmEBcRTPTw3Ile7f4tSGy
         sdUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUx2i2mIWB8W+HXMOguwEVOSH+YLbqJhf7R2j8H8DJG3HK3mxPuw6LAr0PqIbhukZ7ejOpKn6vTEQ==@kvack.org
X-Gm-Message-State: AOJu0YyBVkeK4Gbs+yfEZWK/jLt+U3+RG04hIS6X2hTpMA+3NWEVml0G
	09+tlZ3115RzMYoiiknsayx2XJQdVwgO3Ed85OkiUrYfSZmgCwVEqCx8ulOUtp1vKB0/p6pdbWb
	uqFwPtA==
X-Received: from wmbjp16.prod.google.com ([2002:a05:600c:5590:b0:485:3f41:e111])
 (user=hmazur job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:458e:b0:485:3ae8:2231
 with SMTP id 5b1f17b1804b1-4854b11a321mr95492355e9.30.1773321301146; Thu, 12
 Mar 2026 06:15:01 -0700 (PDT)
Date: Thu, 12 Mar 2026 13:14:38 +0000
In-Reply-To: <20260312131438.361746-1-hmazur@google.com>
Mime-Version: 1.0
References: <20260312131438.361746-1-hmazur@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260312131438.361746-2-hmazur@google.com>
Subject: [PATCH v1 1/1] mm: fix race condition in the memory management
From: Hubert Mazur <hmazur@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Stanislaw Kardach <skardach@google.com>, 
	Michal Krawczyk <mikrawczyk@google.com>, Slawomir Rosek <srosek@google.com>, 
	Ryan Neph <ryanneph@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hubert Mazur <hmazur@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC873C000A
X-Stat-Signature: bwfz6bx8ehahptqstmj8gjfdc4tej755
X-Rspam-User: 
X-HE-Tag: 1773321302-575382
X-HE-Meta: U2FsdGVkX1+fQB5mSFan6OFzbgb9uC7OYdOtYS2GGffe78/qWY/MmHBJcBhqxTeqjD3BszYa2TU3XvnPBhHEcUO5sgfezGBWTeFZDyiFdkAhkzhw20b9wVGH8HDfHSbTmASw72L5HhZSYBWFjV4P2i3Azeh7QLqG/7YVLBoaqEmz+c7mmah6EpMpdYMPHWWya8k5Y8avqpDGqAcpUWhiqKR3qyALZa0aD7mljsQEVMXW29RayLpieLcDMkex95ElUAMV1gvI6TwqcdQ0aGNsrLXUuoB6VeAG7/US9cNBZ+V8cAOduc/oMBryPQiMt+28vj4OtVE9pY2VkZmy1VlZ9jW13Z+DHoiOHjWi6vmup6baH4iwhVM8Pn3c5KaMZu6mXipwFREvMCnhQwKO46ehxFLLq2V+b2lAoy7WsrEaSbpYe0b59JfKBvUtOf6dx3aHmGmBAwBjqCwEEWubU0TILOaVqEW5DKmnGgA++Cel4aCbrNfAwnNhjrT2pA4cFYl5im5I/Kl9L7K6cQidGMZ6qRe2GJlWIXZH2UA359NM9W0nDki9dge9RhCyvmPpo9C1pZrOnLsGy/mDSoNJs5asv7mz1xVrCrMX8SGJVZWjNGz7eYqUf3gSRcdQSFOs2sSoKUdGMZirNgSlEWLL+bi6/sbI+rOLN8jCAMbSBKh+a+b1Jj1ZsaG5qahLE1V97QoJ5K+UFtH0VJ1h+qPCax1nRkig2WmXMH3LfefTFqyDdztDax6Hmeo+oFTd/5hYJZFcmHCxYxcPFYW1O9T/ZBqWgA184Sqq2puD0HbgyZd5/hvXEdKYYfPWFRYDQBDv4023x5PTYfjAGN24dGL5CxSXh7NB4kZ6oiJ440Izk+/GEIcamspUs987BddRkjjWEnRIO+mthhqeoloXLHex3B/e4UcYDhEpEyJniHQtKDhlyudASTYPe/j19i4oN9IGXOwasn/22hBZkBDv+x5q3+w
 lN1/kCNO
 wKAd6HGfH0yWCSaRvzecQcPESNGanXZOLTtu42Lp5EDVYxtY2m7NDUkBPj9fzW5/SU6upABFxLfTf78D9cR8IAEz1xK5RAx2mhs2G3EJhwXXza+U9F+ythmkbuHmrEsNfGo8/wdH1RXHEfOgljVSms9vEGSbzCcmSWWqgeDqVPuZSvMHRSRGWNDEATndry4c7/Byb2GddqzonWhiC6xqmrrDZn5RBw1knS/bFBk2Om+1m/t6RwZIkhXRgvrd6Pon+NhYd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When 'ARCH_HAS_EXECMEM_ROX' is being enabled the memory management
system will use caching techniques to optimize the allocations. The
logic tries to find the appropriate memory block based on requested
size. This can fail if current allocations is not sufficient hence
kernel allocates a new block large enough in regards to the request.
After the allocation is done, the new block is being added to the
free_areas tree and then - traverses the tree with hope to find the
matching piecie of memory. The operations of allocating new memory and
traversing the tree are not protected by mutex and thus there is a
chance that some other process will "steal" this shiny new block. It's a
classic race condition for resources. Fix this accordingly by moving a
new block of memory to busy fragments instead of free and return the
pointer to memory. This simplifies the allocation logic since we don't
firstly extend the free areas just to take it a bit later. In case the
new memory allocation is required - do it and return to the caller.

Signed-off-by: Hubert Mazur <hmazur@google.com>
---
 mm/execmem.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/mm/execmem.c b/mm/execmem.c
index 810a4ba9c924..8aa44d19ec73 100644
--- a/mm/execmem.c
+++ b/mm/execmem.c
@@ -203,13 +203,6 @@ static int execmem_cache_add_locked(void *ptr, size_t size, gfp_t gfp_mask)
 	return mas_store_gfp(&mas, (void *)lower, gfp_mask);
 }
 
-static int execmem_cache_add(void *ptr, size_t size, gfp_t gfp_mask)
-{
-	guard(mutex)(&execmem_cache.mutex);
-
-	return execmem_cache_add_locked(ptr, size, gfp_mask);
-}
-
 static bool within_range(struct execmem_range *range, struct ma_state *mas,
 			 size_t size)
 {
@@ -225,7 +218,7 @@ static bool within_range(struct execmem_range *range, struct ma_state *mas,
 	return false;
 }
 
-static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
+static void *__execmem_cache_lookup(struct execmem_range *range, size_t size)
 {
 	struct maple_tree *free_areas = &execmem_cache.free_areas;
 	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
@@ -278,10 +271,12 @@ static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 	return ptr;
 }
 
-static int execmem_cache_populate(struct execmem_range *range, size_t size)
+static void *__execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
+	struct maple_tree *busy_areas = &execmem_cache.busy_areas;
 	unsigned long vm_flags = VM_ALLOW_HUGE_VMAP;
 	struct vm_struct *vm;
+	unsigned long addr;
 	size_t alloc_size;
 	int err = -ENOMEM;
 	void *p;
@@ -294,7 +289,7 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	}
 
 	if (!p)
-		return err;
+		return NULL;
 
 	vm = find_vm_area(p);
 	if (!vm)
@@ -307,32 +302,35 @@ static int execmem_cache_populate(struct execmem_range *range, size_t size)
 	if (err)
 		goto err_free_mem;
 
-	err = execmem_cache_add(p, alloc_size, GFP_KERNEL);
+	/* Set new allocation as an already busy fragment */
+	addr = (unsigned long)p;
+	MA_STATE(mas, busy_areas, addr - 1, addr + 1);
+	mas_set_range(&mas, addr, addr+size - 1);
+
+	mutex_lock(&execmem_cache.mutex);
+	err = mas_store_gfp(&mas, (void *)addr, GFP_KERNEL);
+	mutex_unlock(&execmem_cache.mutex);
+
 	if (err)
 		goto err_reset_direct_map;
 
-	return 0;
+	return p;
 
 err_reset_direct_map:
 	execmem_set_direct_map_valid(vm, true);
 err_free_mem:
 	vfree(p);
-	return err;
+	return NULL;
 }
 
 static void *execmem_cache_alloc(struct execmem_range *range, size_t size)
 {
 	void *p;
-	int err;
 
-	p = __execmem_cache_alloc(range, size);
+	p = __execmem_cache_lookup(range, size);
 	if (p)
 		return p;
 
-	err = execmem_cache_populate(range, size);
-	if (err)
-		return NULL;
-
 	return __execmem_cache_alloc(range, size);
 }
 
-- 
2.53.0.851.ga537e3e6e9-goog


