Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE61CA0EE3
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 06:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68BDF9000F9; Thu, 14 Aug 2025 02:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E0A900088; Thu, 14 Aug 2025 02:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B2C9000F9; Thu, 14 Aug 2025 02:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3DED2900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:48:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 028C7138301
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:48:12 +0000 (UTC)
X-FDA: 83774433666.24.05F0E35
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B350180005
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:48:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S0doueTe;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755154091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dgSEQM6TLLcMsFdat9WzEVNebtvzRsoxOWl4t4MuHzE=;
	b=INrH3DRNWygQ/czSnXIn6L+16Ev70A19C3nGohZ0KKphDghNFZx1EQ/MSr2ru6BTKvUEqF
	t+wcUssHNaCavBIBnppdMiJOqtNGmJTIw6vWwf+vDfzL9GARCtWnBUnFdOpg3WLTm0DtOw
	kyiYuCJGk9SgK410LRbNbob4HYs9LSc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S0doueTe;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755154091; a=rsa-sha256;
	cv=none;
	b=FFfGquyiEXy838PWbd/nN/Sb2v4Ub8K1q5I84jzsJI64UcrSrj93DVz/oAgYAdY9HbYT8C
	ZhgK+ORs51oT04S+XeuF5eK2JIdGBi5q5Tqimul9eKt4ALxJ7G4qub9cfExQe3NpdsFPpp
	CII8Cs1x+bx+DYVNhwIdQ2eG1zJs9e8=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-32326df0e75so521243a91.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 23:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755154090; x=1755758890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dgSEQM6TLLcMsFdat9WzEVNebtvzRsoxOWl4t4MuHzE=;
        b=S0doueTeddGBzUWaXIQ01rC80a1W5agOzF335QHeiGE9Tk93/IHocs9d4nlIwWQ7VV
         EggUkLpCbGkoeMdypC+aukHp3BR2NrG9/c87CSOgtNu1bMdWKRo19gquyP49EVocrbQm
         gnZQCAqZvV40iJBk6t6Fh2ilgoMwZaPzzGxP2lVZaZXfQiCyc9DidFjxRYI+VmvrEhf+
         gxmzHZHynKTk3NZ2WXIKhrnR/TgL+EJmT2bvZPCOjUYF0QcfyoQcGi1HQQP1g+PhrXXw
         lAoGs5vhrP/wksgHy+khbuLiHE7Dq6V57KktWZUeSM82TgGIRpQWGyqDq/U8nKclBCoE
         6eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755154090; x=1755758890;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dgSEQM6TLLcMsFdat9WzEVNebtvzRsoxOWl4t4MuHzE=;
        b=tSEnYLlHj3AYVQGS+V6ZOmwd9xdgcf9dXDhJfgPPwopEe4MnXQ9oUXIKu1kBMiw1R/
         m1B8s3kMJ6E6pBr8Ak6fmPZ+0n6SQaIu+q9PygCQhtpZFurcO9RrsA3Jii7m57DpNuBZ
         AQ/jjcLfQU6kn18OZy5gmp+F6HpJ0CfbIPviyVdSUlD5+V8QPYRnBE3LkjJANb6CXXCc
         nybjeDUPKDzZwRCmD828+98MebTmXeQ3pTltYIXJVK2QfE8x7b6WAWnEdjv7gLX9WzEM
         0Td5ec0uNqf3HztwAEK9AgjmL8x3OBQfu9ynONGaTkbrkAIKN1pzsj0EYlL4syJ5jIvv
         MF0g==
X-Forwarded-Encrypted: i=1; AJvYcCWNmbRAoBCBlPjCyZ2s8W1VSXX7VyzW8jnHUwq8+ez+DXuQd2jRyV1yVc+VBQA7YmnRpY7UaFu0Hg==@kvack.org
X-Gm-Message-State: AOJu0Yz5P1jtMSs5N9vFA/QW47RnuGSyhFF3tt/vbCF+WyuUi3NAx+34
	GhWW915JBWitBaoD5MxrOKYVoozlmP5EaG33qGbIzp38xpmoU1CkYdvtcJhKvjmqOwg=
X-Gm-Gg: ASbGnctSsCKbOaavipGRlI9YxrHOkeBVFUwh4c0EaUy6KpfdBW85uItSqfZRSf0Mmcy
	xDzcZ2Mik2ffFyPpn2U0nk3tB6B60LALUj3F42Ll6DxfYds9rADxK4ODtV7cSNBjgc6g+vKxo1D
	LrU+Ty92b9Swp02oJ4GoGMYWRRgoEt5eBcfJok6EvaadqN5GTRFlXwzqBBCJqu3l6e+SabiyWtX
	L1piOAf488Dbw2mlPua6JxXZFlr27LUoMSPKNzI3r9NlZ0jQLpbza6C+ZQmdF5S/qxMSeFSoGbj
	fGsEXKjCMXdn340jWih+lq+3MInh9W05ef1XpiPcgPtMjL+g6aAuHYBaMm6kpknmSTPdys23uRx
	oBCXfPqqS8QxG2p8b21pp1Qe13L8IxXOMiZxMSC9eBNa3YZzxerP3vksDkvEb
X-Google-Smtp-Source: AGHT+IEtImpTkJKFIJSVx3t14qt/Mp3kImtU354IarnQKNBYqxeUtpf1mqOF0jI/d26u52bUnF0w8Q==
X-Received: by 2002:a17:902:ef46:b0:240:4d5b:29b4 with SMTP id d9443c01a7336-244582c38cdmr31031305ad.0.1755154089931;
        Wed, 13 Aug 2025 23:48:09 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef6a8fsm340923605ad.23.2025.08.13.23.48.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Aug 2025 23:48:09 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	david@redhat.com,
	jgg@nvidia.com
Cc: torvalds@linux-foundation.org,
	kvm@vger.kernel.org,
	lizhe.67@bytedance.com,
	linux-mm@kvack.org,
	farman@linux.ibm.com,
	Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH v5 5/5] vfio/type1: optimize vfio_unpin_pages_remote()
Date: Thu, 14 Aug 2025 14:47:14 +0800
Message-ID: <20250814064714.56485-6-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814064714.56485-1-lizhe.67@bytedance.com>
References: <20250814064714.56485-1-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1B350180005
X-Stat-Signature: nwkjumyymdea4jxfrp1kycqdw9jucy85
X-Rspam-User: 
X-HE-Tag: 1755154090-404537
X-HE-Meta: U2FsdGVkX1+Z3/aBhoeFNYPmKwrzKKO2NVaM6wXNHXjWxK1fPpkX2EmKRj/DxhksNYACg7pei5iMQItF9ee2iPPe88jStamNf6UYD801nTY32xIv3p4GDXHcXi6cXmLKNwwJQwAXl2UFMeABMT0qowxKvwp9m22xbhXG086gM+2akr1WW8e6uTRRnOL1Fe1Qh6Lc5f9aGstucKO+8QTmz9A0EUl90Tf6s246jwO2/felL0PwGbeXdi2s2LLPYSqzKONt9/FpCNYc9155MDvFlmeM2yE+/50Hf2FnzBfLg6or2icJxhoEOFFyqvaVeIyjaWRFoMYByYbrHed241TEjyzYnIPM6YYwXKxApPa3VYTNvOjQSpOzc1d5IR8IE0xtBzO0QGJbIzcNRRQ9qR+jQdmSzQy51/hal/MfRy+5EH8+tvHOIY2kNuuNyH65tLAyUEQr0XNEsY2mBlJb1mUJiDuzUYZd2DhzC99fYNiHZ4yIwz8V4xrknXBfWWEji63H/7uowJfh8+l2eL2xNB2iIQKxjOpF8KAS/8+ZDN7TsVKs0moBDGGA1HLSCEgnB1h6L1Ca/bJdJxILBXVvMnQefMEfd/hTbAXEbwtxPiR/Lx+rJnox0PB/b/lcrx71zHpHWt9ZcdVUHoLDyMufrU3Ru18a8q2lkHmKFT+CGK7vrssLRshIlQq9pe6Re+OxRk/grdsDUmDl6nbYhuVPJCf0fDddUptty38FCtTUOvOTxbJEnwCCqsFV3AHRRhq7vtz4H/94sQ9RwXDTO7flb/wB07mPZSTcYsr6ShY3B9RqyPufYmUheehN5Ore8W2VE18hmkr3pWJWXp6qExe+M5smXxlTd0vXYZ2U8cmxIcmBzZQDGIiEXoJWDKqOX2I4RdVFvNz1jN0NrQCPDf+ECJeaK2agNPumRdTkT7Pcguunm75pFZEabMcIuuA7K1UoK5HqZKq7MBXHy9BYtTZk+K5
 Oi5S5eVW
 t18N2434IzdjocRO3e299RqELv+/bmtPIcn9NdIn7j5DTvUPiPgARRlXYWg2KKreOHrnr+S//JNLrmw5HPxDNS2LkrydYc8EFRobnmBKnCMzxEWOlbz0TpENFOiVeCLie6VMeZzXAqz9fq+dz60Lt0JwpszheEe5wtc8poC+gqAc9FdJV8HF4X1W6IMQf3RLAm5Ikle3xMr2MxAS0YvSXkEMFQ7Lx11CAyrfBBXOuFxXTJNd3naq8hk2lMKUw4YbF3yqgQNC2onlldIReiI0BMHuj4dWxS2Cyhg9H/CptXDA695X5TNQFYFrIdwtK1eUdtxi2/lvuZig5RPZNPTS5VZDn1zrk8P8WcBQ9a7dy3Q8rEbWdipivuvO23e8EQHKExVw8V9X/fxLJS5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Zhe <lizhe.67@bytedance.com>

When vfio_unpin_pages_remote() is called with a range of addresses that
includes large folios, the function currently performs individual
put_pfn() operations for each page. This can lead to significant
performance overheads, especially when dealing with large ranges of pages.

It would be very rare for reserved PFNs and non reserved will to be mixed
within the same range. So this patch utilizes the has_rsvd variable
introduced in the previous patch to determine whether batch put_pfn()
operations can be performed. Moreover, compared to put_pfn(),
unpin_user_page_range_dirty_lock() is capable of handling large folio
scenarios more efficiently.

The performance test results for completing the 16G VFIO IOMMU DMA
unmapping are as follows.

Base(v6.16):
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO UNMAP DMA in 0.141 s (113.7 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO UNMAP DMA in 0.307 s (52.2 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO UNMAP DMA in 0.135 s (118.6 GB/s)

With this patchset:
------- AVERAGE (MADV_HUGEPAGE) --------
VFIO UNMAP DMA in 0.044 s (363.2 GB/s)
------- AVERAGE (MAP_POPULATE) --------
VFIO UNMAP DMA in 0.289 s (55.3 GB/s)
------- AVERAGE (HUGETLBFS) --------
VFIO UNMAP DMA in 0.044 s (361.3 GB/s)

For large folio, we achieve an over 67% performance improvement in
the VFIO UNMAP DMA item. For small folios, the performance test
results appear to show a slight improvement.

Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 drivers/vfio/vfio_iommu_type1.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 30e1b54f6c25..916cad80941c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -800,17 +800,29 @@ static long vfio_pin_pages_remote(struct vfio_dma *dma, unsigned long vaddr,
 	return pinned;
 }
 
+static inline void put_valid_unreserved_pfns(unsigned long start_pfn,
+		unsigned long npage, int prot)
+{
+	unpin_user_page_range_dirty_lock(pfn_to_page(start_pfn), npage,
+					 prot & IOMMU_WRITE);
+}
+
 static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 				    unsigned long pfn, unsigned long npage,
 				    bool do_accounting)
 {
 	long unlocked = 0, locked = vpfn_pages(dma, iova, npage);
-	long i;
 
-	for (i = 0; i < npage; i++)
-		if (put_pfn(pfn++, dma->prot))
-			unlocked++;
+	if (dma->has_rsvd) {
+		unsigned long i;
 
+		for (i = 0; i < npage; i++)
+			if (put_pfn(pfn++, dma->prot))
+				unlocked++;
+	} else {
+		put_valid_unreserved_pfns(pfn, npage, dma->prot);
+		unlocked = npage;
+	}
 	if (do_accounting)
 		vfio_lock_acct(dma, locked - unlocked, true);
 
-- 
2.20.1


