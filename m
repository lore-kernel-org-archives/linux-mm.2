Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02DF8CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 18:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE466B0006; Fri, 29 Aug 2025 14:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5206B0007; Fri, 29 Aug 2025 14:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202136B0008; Fri, 29 Aug 2025 14:10:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F1566B0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:10:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF82D1A089D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:10:30 +0000 (UTC)
X-FDA: 83830585020.04.9137E14
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id C64A9160014
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:10:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=e9MDX5sn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756491029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EWaZ3DyYHPuS48z6GwkP4SDLRM4XKv1e5Euvli3FZHE=;
	b=JzHzLvPi9yT7Y+uPVDy52tX9SMqq24pxsGv1rbbHkxztuDJAxgDpzYBM22/MOUizjSQjB8
	XHMT37U5eY1NFzcRXGe5qTsaHbfVDoYwuKZJzLdIEK5VXINYXG0zPQ/yJudt9CVs2fwdJG
	IKU7eBKA3iCTO0kUi3GLo/YaxTDNFjc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=e9MDX5sn;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756491029; a=rsa-sha256;
	cv=none;
	b=h+HqM/BvJSKezSRRF5K2vBRguxEs2IB0WpYvZwWmQwSChA3U0NkMF8JRP7uQwDS3Rg8kxv
	blqLm9rnPmQXEFCMPp+xvy2ztu7DoA165bALlNHc4GXvBu47psy+6mrDYvHKC4oriiTS+v
	RpEtcE2OWoycWl4aGeUw3d5PMs7+y6I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=EWaZ3DyYHPuS48z6GwkP4SDLRM4XKv1e5Euvli3FZHE=; b=e9MDX5snNj3TZB3Eo9CBY9t71c
	5WYiL4KE72lsTS5tpyfc1Zku+iXRRTe9YOoqxDiOcUsOMrLlzPBNuGYaMx2Q7SjvsHEKPyfBNnAXG
	tPc6uRkOVz/UF068VQHSuhESR/KdD5Ut37bHnQIFMhz+CM53Kfqi4KhU9Xmx0CQRmkIgSsHuwgiFb
	DizQM4E55aJGlc0lin6Ji7qUaqhYWoahNfKBH1vb3EYRVIlhcxeWSGE4a9wd9EgdG39hbMykHE1v7
	nrd0ztiY2dDnSe9HPuD9RP6TBWoB5dTK2XZUBGM/2h4eEGrtfUzMyfQ3z8TBgaGcjsLJHyHjOlmRJ
	l5C1Gb2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1us1K8-0000000EFxm-1O4n;
	Fri, 29 Aug 2025 15:47:32 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH 16/22] slab: Remove dead code from free_large_kmalloc()
Date: Fri, 29 Aug 2025 16:47:20 +0100
Message-ID: <20250829154728.3397606-17-willy@infradead.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829154728.3397606-1-willy@infradead.org>
References: <20250829154728.3397606-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 69hg1hbiaj8nsryzrwrcznxgmhpuc7eg
X-Rspam-User: 
X-Rspamd-Queue-Id: C64A9160014
X-Rspamd-Server: rspam01
X-HE-Tag: 1756491028-243901
X-HE-Meta: U2FsdGVkX18QuQBRfgwOzRqwji62cHWb3gv29tHKSxOqkZO0l/Yo2gUJFAMd3RQmqKj0regelfsGJgvAtHxwN+obmhZeVJGktFkGzpOAPifvfSXlmn776XJf7ESQOlQw7zqRgLvlHZnDXXGiD0FDiyFuYYGgXC5aHduKncf+XvflIVdMiwa1+lx7QpDGiHJExw67hsLdN5F1MYJFULAQWgoMI6MQLi7XdCwueWquPpoTQ7GczpldG4pAYOt9IPRaIC7e8xHa1KySQVLKcWe2DKG/l6H1IUrnB2Aq8CcGH2mkW2i840UPIwxnKv/wCDroaEEohf5nQKXBVISRpX3pSm9F+eXa29p3+6auQVCunbTih2diPC/1WDP4ADoArvc8GTqFpFRxxhsJ2SzA8NJnGo79jGobPXYOplt/T6RR0g7a0fghsVWdcOp+rvaAk35MHhrUYyQaeaRJ7W+fG4cuIJGrq0KzIO5DSc2aFV5YymUW4V6uc2Ouh0Dy7p/PtuxRrBrQVS6If4kygz3cqBKEQDRk2lfhZDh9rdwvxKUFAm+2d6wOoAs0k4MeF6W7/LHrwppCk9mN6TxH98Sk4Leb754I/svfqBLeoW0+/elirPCx69xMQrg93iyfFiHCRarzHR6JYAdBWVmrrIg4ZqxUJ8UmoOBu0Yn6H+xCPSHwkV7ChxLTvupiCHq8+WX9Sqc3a85QN9eG6b5XjkCSXxye6axMNM1mNughyePli5HDLQlcHFsKIo81dBit92LOOTCWuoM/V9ZhI4TMucpC9OYLSmneEAikQ0MBxY5jmzh1VEu4MOlNdKxIJV3xg1F5q+g53URwZIO1BRTb+d50k1+hoTlQDM7wV4s6V7aNGL98Y/7GYhZJ1nVg5iBGFK7af99LYRyIP6pxGnkwsrVHml7yH3wKmxCG8y8NntcXZXwRDkSyafC5AzkVfIo4N9eHeIbM3y6oMyfKPzwylhT7CPC
 gorsWfwi
 hZkwbhfyZQKuK1DhN4jBNKxZaDrrDxBfadFnopR1WZg7RJ5UcxbsgqxOf3cGNzWM5G0XLDYwQJIu7y05UTLt4QhrT4CQ/DDl46EWI//f3k6nKEWa//rPGGFh2kZ1JsfXx6y2qx/l2lHsoqAeEhdXIhnz3RoRKZZM1JS1QKPLhTmF7sL4v/mQ6W+liA/akV5YLcEbiPUzIvHicGq3i1vXSiMO1LAa8aZ/ZdT4tmfy80QAHLK0bTIJK49qTevHlG3IKuEJuBUvdlJzb8Wo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All three callers of free_large_kmalloc() check PageLargeKmalloc
first so this warning is now unnecessary.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index af3e7ef30b5d..8ab2d329664b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6199,11 +6199,6 @@ static void free_large_kmalloc(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
-		dump_page(page, "Not a kmalloc allocation");
-		return;
-	}
-
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
 
-- 
2.47.2


