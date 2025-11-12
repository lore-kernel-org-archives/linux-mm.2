Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBC0CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 09:33:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A4DD8E0003; Wed, 12 Nov 2025 04:33:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C7F8E0002; Wed, 12 Nov 2025 04:33:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66AE08E0003; Wed, 12 Nov 2025 04:33:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E6228E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:33:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C7EA716043C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:33:39 +0000 (UTC)
X-FDA: 84101442558.02.76E8B0A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id D4A4B18000F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 09:33:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="b/UYt6Dj";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aoAP8JQO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q352pHDV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G4eBS/53";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762940016; a=rsa-sha256;
	cv=none;
	b=Jx8FI4FpLNXHw4l/ZxHnKTO11HTZMVthm7iPxgrwZ096y0Yo6VJiD6/bpIxf3T8eC5zuS9
	REXfQbxkLpiXbxQCUWLIhs1d1WZQq/cNnN8IZx+JtPBHvhDxTFneSSMk8BLJV4HqiDt+mY
	pZlYo89pfemhFdX14JWrbUlyQ7cOdsY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="b/UYt6Dj";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=aoAP8JQO;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q352pHDV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="G4eBS/53";
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762940016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7xhwIJIKNChEmHzgpJc+xaTvyWpzzX1wyegjJYFT8s=;
	b=8o5cnihGUHk0nVt7mY3H0DBvBAwRduPfZoMdFb76LclZoPxZlzDkJUlBEXd0aujPh9GJud
	69jm4yvYTtfEgYkKXNGWlnSN6Z5QDTGohypZY1K00sn2iiM4+cHMmZKLuQal9AN9oeFO0t
	BqJrirUw7soFUvA1KzSBuTGMgfUEmvQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C65B61F45E;
	Wed, 12 Nov 2025 09:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762940013; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z7xhwIJIKNChEmHzgpJc+xaTvyWpzzX1wyegjJYFT8s=;
	b=b/UYt6Dj305pVtxjmOzd7bgFCLxxub1rCIgX70FxdUxFR9h11sEFsbUE2XgvPSB+qNsHVK
	+mXkRCgVF91ugifDXPhYVsvLpFzdzPQWWSsXs0+VH8gYp8svSIZ/WSDXc8Ua3PTYRD3P7G
	ue6i/GlxUblbYVQb6J8Dn4MPOFYOry4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762940013;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z7xhwIJIKNChEmHzgpJc+xaTvyWpzzX1wyegjJYFT8s=;
	b=aoAP8JQOcJRXC95bEDzi6WNPGSAZZQivBDuZ/28Db756BojWER7Uwm7lcN5qjS2bos1s7T
	iIBYSZkXDDVEYNBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762940012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z7xhwIJIKNChEmHzgpJc+xaTvyWpzzX1wyegjJYFT8s=;
	b=Q352pHDVmxQ7tTq3Ga27iseQNZhrkT60Sysj7z9dXgXDqQJ0CGW7GuuAkEgY9T2OnTdnE/
	u3JUgFGwuhb5Eh+J6S2uRdKJTbgPmJqgoDwB0Gt/dCDlZh40xBFVB7jOiOA7vlSrker5TG
	J/b7w/yB8ij7YlZFgv2L1UkdRgaCmaM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762940012;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=z7xhwIJIKNChEmHzgpJc+xaTvyWpzzX1wyegjJYFT8s=;
	b=G4eBS/536eeVjQS3boyERCL0o2r1L1/3z7N2c00m4qCRRnKHOgU4MkCb+u/S4pi0xSylsU
	DEoBQqnMD1Y7tODg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 74E1B3EA61;
	Wed, 12 Nov 2025 09:33:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bFXbG2xUFGk7BQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 12 Nov 2025 09:33:32 +0000
Message-ID: <a90b1707-b97a-454c-bced-a25068b28325@suse.cz>
Date: Wed, 12 Nov 2025 10:33:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: poison_element vs highmem, was Re: [linux-next:master] [block]
 ec7f31b2a2: BUG:unable_to_handle_page_fault_for_address
To: Christoph Hellwig <hch@lst.de>, kernel test robot <oliver.sang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, oe-lkp@lists.linux.dev, lkp@intel.com,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Johannes Thumshirn
 <johannes.thumshirn@wdc.com>, Anuj Gupta <anuj20.g@samsung.com>,
 Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <202511111411.9ebfa1ba-lkp@intel.com>
 <20251111074828.GA6596@lst.de>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251111074828.GA6596@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4A4B18000F
X-Stat-Signature: wnz34p3o7aqrwtw649qx61o1jzpoc7u8
X-HE-Tag: 1762940014-932537
X-HE-Meta: U2FsdGVkX18U18yL47OdLyoDE9BQAN35mj/6La9DOJo2AHPHsvItj31yO9NBoO+fkUxJMZccuHroVZJy/t79SzpeJnQg8zCiIgfJhz3enoSbnzslmIW8+D4ar6NyQgf6toKY8kzazwRqioZQ5oFdLfcAIt/bKgpf7VZc40m20RZgr8RpWLRhC1ctGBJSvp1hbyrExrLAPKZ9v+DI95aOnKBVSwAvj4Of6LJLl5FbkaHfU/DMicpPrcIjr0Ba9ZXmG0sjdMCGumwSMhA3DpC5apT+NtQp2COOgTTDAPtnsjRD7knsCqeg79/ZvBJfTixOTVaHcKk+gXxW1I877kgB8WfQLBA20Hos4SCnl0x90bU6yjU9keg95W7Hx4LNJS6dCLetrgvLNxiKtC/Mj8e1qpPQKTS7oGYD9qmXVE9DB1xwE4BC/JlqmbJvJ2dV6ybALJNgB2nRByJkmyNOZIZLfi51GNUOew+luKnkRviuyH3RaKbcEOgO7qhOQmNEy/Exlnf8JFeP+Fjogc7aXQyZqsDKXTamEBKbw/iLEbB0j7rgMM+jfWf4dYk7P6Q9q3E1WktCbh5iKn4E0ehOSecQTvtEO/KFepzuykrPnIXW0hDIvQhxzQ/qijNKuop65GCqckgiV8TI3He3cI9XDy8x4dOsaMRgyDrVpX1x/JSxGBVeQuO563q7JQIxqa1va6lGL/WxpQzr/vk81J93byNoyujCCKR20noR6OyLrL5UqPTjFMoavwGmJjBWkAu5CariRo2G8kLi3yRU0ElIQexCBCaKe3F1MYhwecaXlNXCb6uwg7jjEIpRURyK9zh9a+VbJXcuJTaCv3t042vNT0Nfoy01xmWefVzYsO+cxzWawfHNrLoznLeB4l+GOhPCRrjHJPLYfMnz7VHZ8bLxFqiT7flc7d1cn9LHaMkb5SgonHY6Jkns3BqUuk05XExnXpuFtS47EthTnia1AeSDd++
 aNXel9Kc
 mF7h/3DupylRZOPsWjL2CzT9+su+xWv4N7zbtX/EIIHMp1BrTjq7bDyggxXhB+aU7BwK7aIAiJxkxYNtoIzUuAzr1rCS8r/JQnaQC+ZmCKMktaiCKG33Xl6QLrPXHIWd5F/kzr6Gybn1O+n/2O01OXgnjadS/hRwUVcRxCTXF0XZGJYU0hf7PpoRgoEHknD0mBC4wwUL0pNQYHSdGAgOBsuW+0+J0KqZXOmPUz3r5ZBFKZz86Bdi0ngDJtr8GJeFHo/1oO5uIH5TrM59gYABI9Tlif2CmVmKxRghMoB786H9f4H1eVMe9PO5btuaPNkECTlfRoBMGdcvE8+vioXrGGbAP0zbKkZc/745LYiiWxtMl3l0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/25 08:48, Christoph Hellwig wrote:
> Looks like this is due to the code in poison_element, which tries
> to memset more than PAGE_SIZE for a single page.  This probably
> implies we are the first users of the mempool page helpers for order > 0,
> or at least the first one tested by anyone on 32-bit with highmem :)
> 
> That code seems to come from
> 
> commit bdfedb76f4f5aa5e37380e3b71adee4a39f30fc6
> Author: David Rientjes <rientjes@google.com>
> Date:   Wed Apr 15 16:14:17 2015 -0700
> 
>     mm, mempool: poison elements backed by slab allocator
> 
> originally.  The easiest fix would be to just skip poisoning for this
> case, although that would reduce the usefulness of the poisoning.

#syz test

----8<----
From 4d97b55c208c611cb01062e0fbf9dbda9f5617d5 Mon Sep 17 00:00:00 2001
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 12 Nov 2025 10:29:52 +0100
Subject: [PATCH] mm/mempool: fix poisoning order>0 pages with HIGHMEM

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/mempool.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546..75fea9441b93 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -68,10 +68,18 @@ static void check_element(mempool_t *pool, void *element)
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_local_page((struct page *)element);
+#ifdef CONFIG_HIGHMEM
+		for (int i = 0; i < (1 << order); i++) {
+			struct page *page = (struct page *)element;
+			void *addr = kmap_local_page(page + i);

-		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_local(addr);
+			__check_element(pool, addr, PAGE_SIZE);
+			kunmap_local(addr);
+		}
+#else
+		void *addr = page_address((struct page *)element);
+		__check_element(pool, addr, PAGE_SIZE << order);
+#endif
 	}
 }

@@ -97,10 +105,18 @@ static void poison_element(mempool_t *pool, void *element)
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_local_page((struct page *)element);
+#ifdef CONFIG_HIGHMEM
+		for (int i = 0; i < (1 << order); i++) {
+			struct page *page = (struct page *)element;
+			void *addr = kmap_local_page(page + i);

-		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_local(addr);
+			__poison_element(addr, PAGE_SIZE);
+			kunmap_local(addr);
+		}
+#else
+		void *addr = page_address((struct page *)element);
+		__poison_element(addr, PAGE_SIZE << order);
+#endif
 	}
 }
 #else /* CONFIG_SLUB_DEBUG_ON */
-- 
2.51.1



