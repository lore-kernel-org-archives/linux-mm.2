Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DED3CD6E45
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1476B008C; Thu, 28 May 2026 05:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAB36B0092; Thu, 28 May 2026 05:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16FE6B0096; Thu, 28 May 2026 05:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C00B96B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 78BE912078A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:15 +0000 (UTC)
X-FDA: 84816365550.16.20F0F75
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9005120002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WB61z4ru;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779961993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGdbcQNrXQCL8Ddddea0/7LpE/hNNIjnFgj+CnQ/xTk=;
	b=knibyYlEZ8VHthMtrRV1KzuInAb6wNtJtVIMmDWjt32/O+HlnsxqPWVIpm8unXzSQFuhiO
	ei0MoCfdcoXHEP2kkYqtG/KsmPVpcf8YemwtQjQZoGkKgO0Z8sE/1Hqtd0UVsPjzD2vvNI
	LP04Lpi5SRModiYjz/LG9fj0FzLjMMk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WB61z4ru;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779961993; a=rsa-sha256;
	cv=none;
	b=kBuft8UUHedUxP6myXqUUgmM4eLqugIRD+gqasgVBPy9NEEbFJ69fG2uXzZSFRsAt9wljV
	idz92UbVXRRR9g0xK8GmVOHbccAKBE+sMjP5d4lzK9RHxVsHuoQ+ClMWbDVvr+Z+M6haog
	hTX6OgR/GcSXvMkYuga3lzLx5qVmiyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66B8B60103;
	Thu, 28 May 2026 09:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACE01F00A3A;
	Thu, 28 May 2026 09:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779961993;
	bh=OGdbcQNrXQCL8Ddddea0/7LpE/hNNIjnFgj+CnQ/xTk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WB61z4ruKXd3kXi1juwOnQTES0jP99vbhpjVKBseJzQqU1WvQmmXuMsPpFfXt7Q4+
	 P3kRes5EuGy9jA7anxILQUeKc5/PfdDeoQx2dq6AImVn/4x/shEwx1HK3kHFR2vhjr
	 Vdef5wZzavi7Sa+MPNkPU/J3WHaL98aNiC6ztibn92IHxqb9RTrjkeJyICbIX4oqOf
	 R19dn9KX2Ts4jN9QTCA2rAwnZsLEa8fh++SpO4zDDPdEjJF0kx3SVVRYD7GRy0Wpx6
	 oYnqJNf/i9/8cQWqr2JbcixE/o1a5vnALBxJMzgisHS+mOtLpK57/VvEkU9NkJiaxE
	 LLRCCsjs8RFFQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 28 May 2026 12:53:00 +0300
Subject: [PATCH v4 1/2] xor: use kmalloc() in calibrate_xor_blocks()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260528-lib-v4-1-4e3ad1277279@kernel.org>
References: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
In-Reply-To: <20260528-lib-v4-0-4e3ad1277279@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, 
 David Laight <david.laight.linux@gmail.com>, Li Nan <linan122@huawei.com>, 
 Mike Rapoport <rppt@kernel.org>, Song Liu <song@kernel.org>, 
 Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-raid@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9005120002
X-Stat-Signature: x1mw9kpfyb7rm97t7ptn7uamnxahwjoc
X-HE-Tag: 1779961993-139215
X-HE-Meta: U2FsdGVkX18Mwfk7ropBKNQrv8uZ2xdXGmd3Dm+0T5vyfti7TNX4M0l/3icK+DChm963SMAdSaIb6LXS4B6RlBujfTM6xvfRfpx0BsVCfpapq/eGcOPFOyIExJ/wUpV5fd0J8/dd6CwtKSC/x9zKtcUC8ZNWdkJyJWf1TKl/jwf9LkW0PnLIrF0KtHWflFklL+ME5ARN8yBGGZVyyywLKrxX8F2j60dHygHCC5PMeRrlukFuB4eLTW4+EFg77czUijIQz3eInY9IVZB4i3y1AzOikfbLGa6xgIU1dgH4Osxw8ukiorefy1ZCPfs0wPxuGad+gwo0263IDLm/77+rD7eFcfSBE1WJR/YAnHbn7t66NngsOfgZf4zUwijqG05DgR0VwJyrMx31a3A4DI1Tf/Ikgxn7hMLU/6c2iFEk5eU75Gj/xp/HGPbgaUAjwCleh1JHWTIZlibZA8H7QDVkoT8BYvh9vl+AzPw6EERl7AoxxCmkTgekajX/e57QTl8Y3q6GgxKdkTah8T43IRwANXmCDFS5smzdwuvS/R3bj42ZuwCyaobavW9Fi+C3em1evBQUbvQQ3LMrDAgscRvQJO+lkXmRafxVlwTXSx+ziawFTDeC2uFZmMM0wj5AZcSXrcr59+s/sFY6kz63c2V6K5xFCDY85IEPFFio1FKA+jvPZdcMUW6AEbc88n/EKCZlhksM3elS5+ZI0w/Q90WVpoHSoeeImsDFyz66oAdUKw2h1CC2UpGBpCgDv/iPuvcqg8MSd7tC01XD9u/akJ89uSLQl20281dDPcdL/X4lX/U2vNawsdH6v0dgnEbKY4cH2/McDC4T2Yqb8UrjV52yVnGhftrjFJLBOVOf/BcU5t+PKE6NPJpuSpcbBCca9OF5oQjYcXddxFssjM83Tw4BM0CWZ7tgHdf4Fyra7JzF2I83e0ZMWRVDSZlmKDn/Bus5LM9EjPr05maOGPu5o86
 5Pr8uGZH
 JR5H4UeQ3j7Bb4S9SIYd+HAS5dERfrLDe0gdQoHS9yGLacWe+D72aUNEZv8n6BOoBGfUK7atSSE+WoyPANqUyGw1FelGFQhtRhSINhc/RmgnzQNM9voqmOnkcFJ4s2PRrXck7rKbZKSfI7acbkHSwCwzr9SfxxExqzasuwPVIF2CJfRbtvAkaUm4/cTMnh7X2QOARkGZMigkOWiLu3U9Pz0Xke0O3VPJc2j0nmXKE+ER4triXgmPKsa3sK8pPZsKN3WMUklhaRio6kBKdOK3K7+3TfjGDgyDFHnLZ3q74O6sl5CKmjxcEx+/rrb3FZOacXqu/CIzr6HtvRu/65fyvdzXEXJIQwVHv4RvjjyRTxGKz4Q6tziIBn2nUhfvn32S6f+W1AZJY/7tIPSd4bvyBVG8sNUnYohxP6p0QWyF8RUXD5qX5kaw1wIR8OiQOHU7AzbEk3UWKVa+t7EtBDRng6d38Mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The xor benchmark allocates 4 pages for a scratch buffer that is used
purely as a CPU-only XOR working area.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API than ancient __get_free_pages().
kmalloc() does not require ugly casts and kfree() does not need to know the
size of the freed object.

There is no performance difference because kmalloc() redirects allocations
of such size to the page allocator.

Replace __get_free_pages() call with kmalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 lib/raid/xor/xor-core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/raid/xor/xor-core.c b/lib/raid/xor/xor-core.c
index bd4e6e434418..50931fbf0324 100644
--- a/lib/raid/xor/xor-core.c
+++ b/lib/raid/xor/xor-core.c
@@ -8,6 +8,7 @@
 
 #include <linux/module.h>
 #include <linux/gfp.h>
+#include <linux/slab.h>
 #include <linux/raid/xor.h>
 #include <linux/jiffies.h>
 #include <linux/preempt.h>
@@ -114,7 +115,7 @@ static int __init calibrate_xor_blocks(void)
 	if (forced_template)
 		return 0;
 
-	b1 = (void *) __get_free_pages(GFP_KERNEL, 2);
+	b1 = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!b1) {
 		pr_warn("xor: Yikes!  No memory available.\n");
 		return -ENOMEM;
@@ -132,7 +133,7 @@ static int __init calibrate_xor_blocks(void)
 	pr_info("xor: using function: %s (%d MB/sec)\n",
 	       fastest->name, fastest->speed);
 
-	free_pages((unsigned long)b1, 2);
+	kfree(b1);
 	return 0;
 }
 

-- 
2.53.0


