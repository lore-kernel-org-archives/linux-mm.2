Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A5D5CD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:54:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 525688E0007; Thu, 13 Nov 2025 13:54:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FC928E0002; Thu, 13 Nov 2025 13:54:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4125A8E0007; Thu, 13 Nov 2025 13:54:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 30B338E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:54:57 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB71F1A0AD6
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:54:56 +0000 (UTC)
X-FDA: 84106485792.22.E350865
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4CB751C0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:54:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x20oT7jx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RMNq5YXn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x20oT7jx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RMNq5YXn;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763060094; a=rsa-sha256;
	cv=none;
	b=Ip+GzyelyH+ib1EwGOSoLw4X0do0IybHJ6kugJX+k/VqmF4TyGiXSy3YYZZh2X8W6GVdL6
	+iTnEOnFsj7/EgezUxmj+xo65Jr7WfCNUADlocqD8iwC9y/fCDQ726slfqDWkWfelI4W5F
	8AEvP+Uza8xPr5+8LizOaLOpTOAu/co=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x20oT7jx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RMNq5YXn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x20oT7jx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RMNq5YXn;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763060094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JfARLRctgc1MHcXWbnkWDpLKf7T7MZGOzbfYRAmasic=;
	b=XeR5p5TcZ4GA6WtMi0XVW/4Y9pWO9BBrflK84aSuoBzIDVwHEQ6wcxa0SgAscUdgdtAqF7
	dtvvOwRmZOgndYv4dltsStQ7yEHljfckj4NPcH7O8t/u/+CDVvlHOKPWuQ2qRnaqJrL34z
	RLK9pFsdCOeaRaQq3IxXRXKT1ewOcdI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4C72221751;
	Thu, 13 Nov 2025 18:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763060092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JfARLRctgc1MHcXWbnkWDpLKf7T7MZGOzbfYRAmasic=;
	b=x20oT7jx8jlcFyIH4Kvvc/CmlE7n/AXxDp36MtmPn516Z1g7dXF2nywHCZQv/orfZ3cNv3
	VTA3O8O+ntRTeQ03k8VNsrBQk0vzkUh28BwjTIPdoXF5k2XXxwXNFRc78Oq2p4B6x8v3qg
	qjhBqVumvFvF1XVUU8MbME+dm1TEYnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763060092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JfARLRctgc1MHcXWbnkWDpLKf7T7MZGOzbfYRAmasic=;
	b=RMNq5YXn43niDu9a7sc9/UsnhVWqSSKbKzS57lemF8sudjuUvElUQvsMb/GVxnjho2uFdF
	qJPYlofq88KkN6AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763060092; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JfARLRctgc1MHcXWbnkWDpLKf7T7MZGOzbfYRAmasic=;
	b=x20oT7jx8jlcFyIH4Kvvc/CmlE7n/AXxDp36MtmPn516Z1g7dXF2nywHCZQv/orfZ3cNv3
	VTA3O8O+ntRTeQ03k8VNsrBQk0vzkUh28BwjTIPdoXF5k2XXxwXNFRc78Oq2p4B6x8v3qg
	qjhBqVumvFvF1XVUU8MbME+dm1TEYnw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763060092;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JfARLRctgc1MHcXWbnkWDpLKf7T7MZGOzbfYRAmasic=;
	b=RMNq5YXn43niDu9a7sc9/UsnhVWqSSKbKzS57lemF8sudjuUvElUQvsMb/GVxnjho2uFdF
	qJPYlofq88KkN6AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3427D3EA61;
	Thu, 13 Nov 2025 18:54:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id K7EKDHwpFml8JwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 18:54:52 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Thu, 13 Nov 2025 19:54:35 +0100
Subject: [PATCH] mm/mempool: fix poisoning order>0 pages with HIGHMEM
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251113-mempool-poison-v1-1-233b3ef984c3@suse.cz>
X-B4-Tracking: v=1; b=H4sIAGopFmkC/x3MQQqAIBBA0avErBMaK6iuEi0spxpIRxQiCO+et
 HyL/19IFJkSTNULkW5OLL4A6wq20/iDFNti0I3uEbFVjlwQuVQQTuLV1gxoBr2Otu+gRCHSzs8
 /nJecP93ZIEZgAAAA
X-Change-ID: 20251113-mempool-poison-c081a82b9d54
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kernel test robot <oliver.sang@intel.com>, Christoph Hellwig <hch@lst.de>, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4240; i=vbabka@suse.cz;
 h=from:subject:message-id; bh=BifFwtvlNQQkStSIF8vllGhQjq9oCr2r6Bw9zrRLrMQ=;
 b=owGbwMvMwMG4+8GG0kuuHbMYT6slMWSKaVbu0ZGJ0IjfGfYy9IamYl3gFz12feZf1q8//jHYG
 cIe3tnWyejPwsDIwWAppshSvfuEo+hMZY9pHr4fYQaxMoFMkRZpYAACFga+3MS8UiMdIz1TbUM9
 Q0MdIJOBi1MApvr0LPa/EhuvBjVsCd7FpvuqbK6Yc8jhpJXyhYeOH/t89Umw5+wzNYZtmf2XD02
 8d+X6dGXtv/M9OmduNTnldmnr84h/WQ8Fjm51OGEux3323MIJ2/e5zyq6HF7aH5W2XCig4qdy0a
 HGH69brubusemZNi00LNdT45bY19TACI7nbycf79eLeNSjcXWnmZXS2luXCiufTTtxwvKT+QTJH
 W+fcWyckrT1LPNrq/Z+q1lFpkpM8x4s3bB6zb+/6+1e1MUuyi1wUlT1PMp6e7rXzfq7/BHKck5u
 dxZ13pCuD9fguJGcMv9X1tSDHPOsdwdfLbkdOE267n4A/wudvtU6b2LtTDI157HFphrlxwdte3C
 4z2RbNAA=
X-Developer-Key: i=vbabka@suse.cz; a=openpgp;
 fpr=A940D434992C2E8E99103D50224FA7E7CC82A664
X-Rspamd-Action: no action
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4CB751C0003
X-Stat-Signature: kgtqx13k5m6uz61hu8nsusdmsns7wgzw
X-Rspam-User: 
X-HE-Tag: 1763060094-911734
X-HE-Meta: U2FsdGVkX1/4rwIZr1XGarXaPv0DMf5N/tIeKc6eCEVSmpy19LfdTBJJTByhdwMpJaCfgMlbHclZy92NRSPp9wJUvc3FkRgRrnFYDuDXAwiqXJvbflSsfjFpnfsMmPPH1kQYMmaYBZ9Ei/s3ep4yoKqvs6DPdPtkpC5HvSHRIJcLk23ypApEBdhpmKUHo6mFr7+++5lTkqoH2bzjShqSyrYFXU6A+z11ftGjWJYVfJD4g+3TVWLBVCO1odqxuti2yV/1ImLdkIi3fsc8rTvwQCI1Gr1P531QCDhAREKvHKbPUYHLLGAM9uo+p5kUezSszbM36IhYClu+hW06Xqkj+qBLQiKXc7vRi6uEnkqqbrVk/2n0ov2fbzaYgTR6Y5JzA/xQstWYj3yQ47UmAv46pgANRKZILB2QClzNh6q/muJeIDjrkQ2m/YlhjFkheWlwitsZIKBrlo21et1FMT2o0a23YY2+unG9v6cFtfrDvZicfZS9ouygkCV5ZV52+j/6DcSdg6BLYUqafWMXa3Zb9EIMmwKQRDI/f50PP41voJ6myfQlBOgqi11ijlu8wOIcKzrzwjV5EQjCh16x0iqeSMXiIjg+RBK1pfY+o+fsiDRaU9qkKS+qLEC60AG1IUZp3CwTbQF89NaNiWn+jT/LPOWU8Y7b2WlwIR/e/gHnSDFVRUYaavRffZCQN/WhSFrV8jiowOGTnxegoIzhaL2eJcjGcx6nzvn4dmFHPBWHFSSNQwOYVRfT++7HFRB+m2rSrkHRqUgdHSeeSyghnyAOpfYoreSFGrp8FHmcQBLAGJiw5U22p93b+/CT/8kr+gI0dXCZvHoqa4sfjEuAAMT5XKwE6WMy3tcQJNy/yDvBd32KTG3QCQvKvOlrXQUhNXpS+LoQh8Z6ugMEuzpAa0UPvSlnhl6wW2A3NCrYYuznJ77fc6mGaw4/ko1tOUBRKhziOSMCe09tuercIYl+TwG
 H8vXI4oe
 LhWQbUJLgQkKapXVFZXJEjPam2uvT/yZDASzldkvhgrzeGIQlJAV++RNPLOWFnfG0KnBFFJMfcQtjac2sYIlrbqqejsfA5vb39af2z6L0Ua6gLN97ar3vnmRXABBqwzqi1ItAKNGniE1FT1PLLP0L1aeqSTUqUbyjP8ptdIKYRfraU8Kva5iVigxPR1lvzAtZNeLJjKBFwN8Q5VkpUUO27gKb4QpUGff9txOIhP1wZLojBZTIHy+70WsrXWb68152/QY4Pw/WIRmt1bQCIAa2v16Rwgra2opOBctIGDPwe73aCmo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel test has reported:

  BUG: unable to handle page fault for address: fffba000
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  *pde = 03171067 *pte = 00000000
  Oops: Oops: 0002 [#1]
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   6.18.0-rc2-00031-gec7f31b2a2d3 #1 NONE  a1d066dfe789f54bc7645c7989957d2bdee593ca
  Tainted: [T]=RANDSTRUCT
  Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
  EIP: memset (arch/x86/include/asm/string_32.h:168 arch/x86/lib/memcpy_32.c:17)
  Code: a5 8b 4d f4 83 e1 03 74 02 f3 a4 83 c4 04 5e 5f 5d 2e e9 73 41 01 00 90 90 90 3e 8d 74 26 00 55 89 e5 57 56 89 c6 89 d0 89 f7 <f3> aa 89 f0 5e 5f 5d 2e e9 53 41 01 00 cc cc cc 55 89 e5 53 57 56
  EAX: 0000006b EBX: 00000015 ECX: 001fefff EDX: 0000006b
  ESI: fffb9000 EDI: fffba000 EBP: c611fbf0 ESP: c611fbe8
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068 EFLAGS: 00010287
  CR0: 80050033 CR2: fffba000 CR3: 0316e000 CR4: 00040690
  Call Trace:
   poison_element (mm/mempool.c:83 mm/mempool.c:102)
   mempool_init_node (mm/mempool.c:142 mm/mempool.c:226)
   mempool_init_noprof (mm/mempool.c:250 (discriminator 1))
   ? mempool_alloc_pages (mm/mempool.c:640)
   bio_integrity_initfn (block/bio-integrity.c:483 (discriminator 8))
   ? mempool_alloc_pages (mm/mempool.c:640)
   do_one_initcall (init/main.c:1283)

Christoph found out this is due to the poisoning code not dealing
properly with CONFIG_HIGHMEM because only the first page is mapped but
then the whole potentially high-order page is accessed.

This went unnoticed for years probably because nobody has yet used a
mempool for order>0 pages before the new block code in -next.

We could give up on HIGHMEM here, but it's straightforward to fix this
with a loop that's mapping, poisoning or checking and unmapping
individual pages.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202511111411.9ebfa1ba-lkp@intel.com
Analyzed-by: Christoph Hellwig <hch@lst.de>
Fixes: bdfedb76f4f5 ("mm, mempool: poison elements backed by slab allocator")
Tested-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Will push to slab/for-next-fixes 
---
 mm/mempool.c | 32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 1c38e873e546..d7bbf1189db9 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -68,10 +68,20 @@ static void check_element(mempool_t *pool, void *element)
 	} else if (pool->free == mempool_free_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_local_page((struct page *)element);
 
-		__check_element(pool, addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_local(addr);
+#ifdef CONFIG_HIGHMEM
+		for (int i = 0; i < (1 << order); i++) {
+			struct page *page = (struct page *)element;
+			void *addr = kmap_local_page(page + i);
+
+			__check_element(pool, addr, PAGE_SIZE);
+			kunmap_local(addr);
+		}
+#else
+		void *addr = page_address((struct page *)element);
+
+		__check_element(pool, addr, PAGE_SIZE << order);
+#endif
 	}
 }
 
@@ -97,10 +107,20 @@ static void poison_element(mempool_t *pool, void *element)
 	} else if (pool->alloc == mempool_alloc_pages) {
 		/* Mempools backed by page allocator */
 		int order = (int)(long)pool->pool_data;
-		void *addr = kmap_local_page((struct page *)element);
 
-		__poison_element(addr, 1UL << (PAGE_SHIFT + order));
-		kunmap_local(addr);
+#ifdef CONFIG_HIGHMEM
+		for (int i = 0; i < (1 << order); i++) {
+			struct page *page = (struct page *)element;
+			void *addr = kmap_local_page(page + i);
+
+			__poison_element(addr, PAGE_SIZE);
+			kunmap_local(addr);
+		}
+#else
+		void *addr = page_address((struct page *)element);
+
+		__poison_element(addr, PAGE_SIZE << order);
+#endif
 	}
 }
 #else /* CONFIG_SLUB_DEBUG_ON */

---
base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
change-id: 20251113-mempool-poison-c081a82b9d54

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


