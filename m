Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56726C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2013F6B00A7; Sun, 30 Aug 2026 03:49:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA0F6B00A9; Sun, 30 Aug 2026 03:49:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFDD6B00AA; Sun, 30 Aug 2026 03:49:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DC1A06B00A7
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:49:54 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2621A0226
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:53 +0000 (UTC)
X-FDA: 85157161866.01.A9DDB85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 20CBDC0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:49:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5zBjU2S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788076192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0aOUz6JVmh3kXeQM+NnLc75cSb7tkVgfwn6MO33S8s=;
	b=WMKdYBJZv21MzzmwfjVK8Gbgie23DOW9aK2LJFfASR8REXUUFxFypoqGLIE34VlCE4mY0c
	9HYtdb5ZwExrn5I+TLxuLNpT3ia0FHZ4ZmMB980gUn6iSOQvfHUL5JwHO0Ei9rNyjbBns/
	t/nqyPPvJQL9SRODcpuBUnYdCv6N4iE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b5zBjU2S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788076192;
	b=izpwEDNL5US9AFvPsKe0PnhjG1dtC0pIWwyRXD+SvJhlPRSeDKhe32PGGyRQteYX2e4A4V
	aulVHqq9gdvBXfo8skHra981mivmbcBDRE09Lvc2mX1JI95qCHVcD/5yfe1IN22es3oTo5
	LrDHkNZtUmzjX3G2gISqzXVThaq7JuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A256418A9;
	Sun, 30 Aug 2026 07:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C19B91F00A3D;
	Sun, 30 Aug 2026 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788076191;
	bh=N0aOUz6JVmh3kXeQM+NnLc75cSb7tkVgfwn6MO33S8s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=b5zBjU2SCdjNynbg16pje0gRmCFrD2lpThEIZpjQImPRVDgN5PG8PUs5Y+pWBNxWo
	 SkR/m95kAtKUgDcA7pG+mgK6GKoLUoKWkPLr9kQROsoJTVUBgu2Ndc1cdzAboL4mx+
	 zovU54HVU9Zx1PHAUtsimOlAdSLGtQjmx0gLUBAH7i/2KABKvH9Xj09UPoBpjvMOCk
	 4+bayv5WuWfiXFs03oJYXx59pFZ4H5N0YFuOjm06Cuoeabrrdcz5M1TV2MLy6uiajp
	 OA6KrwNHb1d6V9E+q2YZ/ONsT+E9yJ/CABRqr4QlKx4EgyThytkTlGLuzIBV25AijX
	 nRDHvVS1DfNIA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 30 Aug 2026 10:49:39 +0300
Subject: [PATCH 3/3] tty: hvcs: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260830-tty-v1-3-0cbe6170649b@kernel.org>
References: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
In-Reply-To: <20260830-tty-v1-0-0cbe6170649b@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.17-dev
X-Stat-Signature: zrk6aweeifg8737ij7z36uahazswopbp
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 20CBDC0004
X-Rspam-User: 
X-HE-Tag: 1788076191-760146
X-HE-Meta: U2FsdGVkX189/pyE4wHbQU03hgMrjyJQew/UnLuaPFVObfJEf/TC67NCgkzh/u+m03qZELdyioMn7UCT6UFmx+oek03eLWX7Mxwkr8dMD5BVNHHiRDTVnxaiH54XYvT2yeUK13BadTuAD4YS+BzuEKvXI+d8nI/8uqIDN11L0hcsjt9u9B5WMUG1CLlk4MT5MqpMaLqn/gOFhdYHiKBGNT6jQ9wBqGsIOrt1hNnYQlq4JgZNjkJl59fliAY2sWTMYxy2hn8YZ7hC+G1Np58vDNMQzGWCOPEYnXyZKPlchooerhgGnNOj5FKSQwrmk6y/3kW0RgdGRImQ/2iG0ec6fSNTA2PxiCCCF4tMI3d2LBqvZwE6H7R6E4jjC+kck+p4LnUyvWCq/vDhq66hu9sP87FftZgrOuR7VIpfjXPfTEKMnat3G2CjBNzAnf3bqB6AoT0oXf/sPUKSKQ9VzoT94nnobkuv7kggo+0+4IpXI/e1Wem40fgExo1zg0WXfCPGKzk4UcEBSPUOzGP+/CqEtSQrNOqMxj9fjM7CNQOJbwl4HHiS0Put23iyNOTkkG2oFYkNZsr1KG5xt7RL36rbJDETKvQCDnQj8VbEdFCsA0CuL61AZrBBnbsT4+eK4csbzMtO7pESfA1gWJeE82Z+mPZR6Y7+V+kvogotBv0c0ax7uAsVxAABvgfMiIesd8uzxbeQGL6DI/p8ovwsW9Lnr2KEYXssedddMuk/1WF0JaC7Ldv32pFVz3BkeH5pqReGet0ndmY6PjVtERkmeUTtT30f8QuBSyDQdnmgyvhfKM4ub12FzeGoyLiNFF2vPPg0wS/oCXPGeARlYZII9HFTKZFUrp1ffQ/C9PhLLFhm6QIeYmRdVByixJlxT2v/puJ6hoIZVnXdey0g9CGIGRjG1h5P9++HXwbV4bNIfm8bwuaGxcI88Cc3UfV8LgWFKQ9fVqBkDFgJtOgXGV68/ek
 grJh5Z48
 fP2H5b623wVHEaI42slPrYmMgEeY/EL8V3CsNHfgGuI7zGSxD3WqjlwdP59FP0FxxVoJ+hh/E1wsvKR01ew5Cck7MMqhYw7JCDaXBRPxETIXdUH6MIl4EtOvsJTdV3Twdq2bC6BnY9Za+22P34cG5NpWVG1hi1Cq7rwvKFZVcmuuzB8X5WpJku6Vg85//NAdZZdfp7bMWVRKkRb3KYKB/XIJy5Pm6TDNrDxLYM/uqJA2vMMEQsy4lyuwVPMf6NoLfzRc6AviLKy9/aokdR3jkHR+f6de6BptUf8DR1kpiGZkDkyxjnKKkfZ2Rlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hvcs_initialize() allocates the buffer that receives the partner info
returned by the H_VTERM_PARTNER_INFO hypercall. The buffer is passed to
the hypervisor as a physical address and it must not cross a page
boundary.

kmalloc() guarantees that a power of two sized allocation is aligned to
its size, so a PAGE_SIZE allocation is page aligned as well.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/hvc/hvcs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/hvc/hvcs.c b/drivers/tty/hvc/hvcs.c
index d32b1e3c50bf..b94d59fa3627 100644
--- a/drivers/tty/hvc/hvcs.c
+++ b/drivers/tty/hvc/hvcs.c
@@ -1470,7 +1470,7 @@ static int hvcs_initialize(void)
 		goto register_fail;
 	}
 
-	hvcs_pi_buff = (unsigned long *) __get_free_page(GFP_KERNEL);
+	hvcs_pi_buff = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!hvcs_pi_buff) {
 		rc = -ENOMEM;
 		goto buff_alloc_fail;
@@ -1486,7 +1486,7 @@ static int hvcs_initialize(void)
 	return 0;
 
 kthread_fail:
-	free_page((unsigned long)hvcs_pi_buff);
+	kfree(hvcs_pi_buff);
 buff_alloc_fail:
 	tty_unregister_driver(hvcs_tty_driver);
 register_fail:
@@ -1528,7 +1528,7 @@ static void __exit hvcs_module_exit(void)
 	kthread_stop(hvcs_task);
 
 	spin_lock(&hvcs_pi_lock);
-	free_page((unsigned long)hvcs_pi_buff);
+	kfree(hvcs_pi_buff);
 	hvcs_pi_buff = NULL;
 	spin_unlock(&hvcs_pi_lock);
 

-- 
2.53.0


