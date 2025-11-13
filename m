Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E48E8CD4F50
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 08:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DB98E0019; Thu, 13 Nov 2025 03:41:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E438E0016; Thu, 13 Nov 2025 03:41:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C018E0019; Thu, 13 Nov 2025 03:41:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 28F808E0016
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 03:41:37 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CBE12C08F1
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:36 +0000 (UTC)
X-FDA: 84104940192.29.84C1D35
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf14.hostedemail.com (Postfix) with ESMTP id 396E410000F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:41:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SId8SQyq;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf14.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763023295; a=rsa-sha256;
	cv=none;
	b=INkfQOObm0q59HviXh7aZtp+/R8pULHW5SE4ETWZww5Ijw1M6dBo//8iDAiaGE4XAWC8vR
	cTIevxVQukpT3neyu8ZxgAFrAjR20uWstLq8CJ9mwgEoMENb+KRENEF8RQTxHpgsIbxhSn
	WYUd5mmkQTrj3IV5R5/mwgRq/MgvqPY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=SId8SQyq;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	spf=none (imf14.hostedemail.com: domain of BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+fa6b10aa88fb4b0ddc30+8117+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763023295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9F5bDBG8GDPp+kf7AD7KCVOQnYGwaf8pnBFM8bXFoD0=;
	b=G2M+Pbz6jgghWwcuUtuBzdJ+Q+u4M8zJuo2uMdVmn7QB0a57XSpao+KoUeSEqON5V4ESQs
	ini7Fs+OuETXgJKvlxoj5BymjI7u9jjKeRoX+mBO1Be5OTAIs27/SKylhfdymgwV6aW5dR
	2l0iJA/rexTFSzfd8M/wstO8YURLtK8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9F5bDBG8GDPp+kf7AD7KCVOQnYGwaf8pnBFM8bXFoD0=; b=SId8SQyqkI6btSG1h/pGLfZpTm
	aht/Jr/q0ErAlO+P1ntGFZLZ1Jee5WOS8mzWUKjmMXtqx0PhGwGwV71l1o1lzOChagTV0YD0m9wV0
	wnnqKiksskWnT/hwmRDbxwNy+ODGMoIG3IamINoBcD7EvqCETxXX9m57dCdM2PhdkDlLlODSyqEgN
	Ggq+h8wKJPU9bDEcWTh5lS8S0D8EzduSi3ZAb8aFCcXdW9DzwMCrxC0F/1ga35Ijd6nhrRHkTp+8r
	rwZdKSuEh/k9qx2eeIr5EdWODSYsylK93w1pV7dRugfdZk+r8mgKH67UaIboLgHpOg6RYUBD1D8hm
	XZkkPt/A==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vJStX-0000000A7Ub-2ZTs;
	Thu, 13 Nov 2025 08:41:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/11] mempool: remove mempool_{init,create}_kvmalloc_pool
Date: Thu, 13 Nov 2025 09:39:50 +0100
Message-ID: <20251113084022.1255121-10-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251113084022.1255121-1-hch@lst.de>
References: <20251113084022.1255121-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 396E410000F
X-Stat-Signature: cspwq3ppxox9k74cqdardmy9kwgchxcf
X-HE-Tag: 1763023294-928675
X-HE-Meta: U2FsdGVkX1/iR87id7MJ9tRa/bAlXRcFZfC7nfSdrAX7W1GqG6Kki5sVEH2RkMQWHwE/teYECQaRcPY60wWnVwthdTiITmPfGL1AaYyQ2dPI9F6E/nYZJyxUc1yPIUAu80CAeeWr6Ss/zN/VIHpf7XYRxgAUVZi44+S7YHR+A6ld5nhbl7yUJ/gG9GtDyTOGDRLQSqJc2TE5qp3ESjrrLOCiSQ1VEH0yGxqH4/L9CjpuymMJ1NaC+z1vKpQwAHf3Fk3/yPmxaQRRSKsJcfJCgZOQ2gFwuNoUduARztKGcXea/Vq3t2EcU8s2OTlyVvEK5Y59VU13r5LNS8/fD3NDs8+i3ZMv5Z/PqAOtvmD2oGx8Sd7wWbfNJ7dmPoz1E9TfadL4axZ9irwOwKcEw4oT4Ji1QFr2zgfJQvXaEv7spx5Gwi7mrPQ8lDisyVXHnXPfZ4nn1HFQme8l1gKr8ERjJVuEeV4+TeyfRoIBaFwte8K4co1kissN77DAOcevHUz4/6cLUAifB3VhifQQJFrWm4G0nZDM/nmmzk6vsJ+iIuW7GY9KZOrSI0AhLFqXHZgNW0xQ2HmkJGoHSma3t+xjcNL1mFIqRpy+B48SAp5he2CSk7Df/lWo4sWkobLEqm+yPa2C9aYXfThQvuNBoXaOhrNKJU1lsfT7V5PyBxmdDW0LWsN8gQZTm5DpyBjpFQHSKyd/0gcuZLSdUA5diS5w90voOelUA6BVfvMOZFLt1FB/58VqSnZ48TiO0pb9XMPuufWF2l9NetF11+de0PZHjOyT8YVNfdTOCBY4J6+b8vZ1SlG6oUosU/lQEFqlBb75yq8LN+K2RwgyUHG0HlsFEetlvmZXpbRB4iEoPsuRAtSlaqXFhjbDH3r7yI/NF+ecjfgSFR3EQ8XhxURSqkggf1Ib+R3xtL/IPNfZe0Kva5aCA6wi6UtB1zwelBU9CdQTqftSxw7/NRbu89Nrdn7
 KQKH0ZgT
 BTA8dAkWBqCNB/zuFV4I85wsgUgRuh4e8/fL+7ZBTb4TQsM1eHC0tsv0IKiLZwf00S8iqQJE588mq6aC1XjflnexIwhuCmf3BjYcPY3GDvYO3cikRjXS/HUoAMBGVm7E5Wb5kHLtlIlBjxYdm3ajOql3U7UwkMTqwCDX2KvbahMme1FXN0XF2gFuUFAF6mgVH00tapNsBgcRANhxYZc8x4mrEsGkToK1Ddsdpo4nlYLJZ4W0YhSNcCzCykbk6Q5vMVnyaYT8qX7bETBTMhz3ERil9qms4jaoCcL2nM5PYAVDzv+aWwYZkwqkbvpewsLbhW4utd8Y9ZDSfYe+J+TYttDfZLLxRGbVRzgNCz9CLy0mJs0BEKS//ojx1Ab0jdnUvZ3xYD3KbC2fS+ZikMfoxKeO1SJeIpP2ttVfFcdnXDRi9TApTHxXNoSVV1vwCk8wfwSEFdwNv+ZXvfSW3KZ4uwUn4OQKwRdpsVxpQCj56VPUqobNk2N+jIRMNUIwQ1j85VECIyNaTneH6yGmY9NBK2d/KuICq8KTdIpRVx7fzPPCxgasiSyoQrlImXuoU74E7MTkfvmjQpR+hCIsqg+udJuVDUR7idPJmzBxdnsIsGxlbMZJowWui8bxt+y7TS9h3ikuArazXnyi2YcY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This was added for bcachefs and is unused now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mempool.h | 13 -------------
 mm/mempool.c            | 13 -------------
 2 files changed, 26 deletions(-)

diff --git a/include/linux/mempool.h b/include/linux/mempool.h
index e914fec0e119..d9332485e8ca 100644
--- a/include/linux/mempool.h
+++ b/include/linux/mempool.h
@@ -103,19 +103,6 @@ void mempool_kfree(void *element, void *pool_data);
 	mempool_create((_min_nr), mempool_kmalloc, mempool_kfree,	\
 		       (void *)(unsigned long)(_size))
 
-void *mempool_kvmalloc(gfp_t gfp_mask, void *pool_data);
-void mempool_kvfree(void *element, void *pool_data);
-
-static inline int mempool_init_kvmalloc_pool(mempool_t *pool, int min_nr, size_t size)
-{
-	return mempool_init(pool, min_nr, mempool_kvmalloc, mempool_kvfree, (void *) size);
-}
-
-static inline mempool_t *mempool_create_kvmalloc_pool(int min_nr, size_t size)
-{
-	return mempool_create(min_nr, mempool_kvmalloc, mempool_kvfree, (void *) size);
-}
-
 /*
  * A mempool_alloc_t and mempool_free_t for a simple page allocator that
  * allocates pages of the order specified by pool_data
diff --git a/mm/mempool.c b/mm/mempool.c
index ea2f4f9bcfa1..72c788888ed7 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -724,19 +724,6 @@ void mempool_kfree(void *element, void *pool_data)
 }
 EXPORT_SYMBOL(mempool_kfree);
 
-void *mempool_kvmalloc(gfp_t gfp_mask, void *pool_data)
-{
-	size_t size = (size_t)pool_data;
-	return kvmalloc(size, gfp_mask);
-}
-EXPORT_SYMBOL(mempool_kvmalloc);
-
-void mempool_kvfree(void *element, void *pool_data)
-{
-	kvfree(element);
-}
-EXPORT_SYMBOL(mempool_kvfree);
-
 /*
  * A simple mempool-backed page allocator that allocates pages
  * of the order specified by pool_data.
-- 
2.47.3


