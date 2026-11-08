Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 665F3606D807
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoVQx5Kz
Received: by kanga.kvack.org (Postfix)
	id 00ADA6B05C4; Sun,  8 Nov 2026 04:04:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E66966B05C5; Sun,  8 Nov 2026 04:04:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D011C6B05C6; Sun,  8 Nov 2026 04:04:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A193E6B05C4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22EF616042D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:56 +0000 (UTC)
X-FDA: 85411366992.21.79D5077
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6D27720006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LoVQx5Kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pP3ktJZe7/4XiaZRjUU/IjnOlBafkxzysIooIWss1Wk=;
	b=nAYr97qZhLQCuok/3AfdpWonlPwiETHAS6N3NDbkvf0UCVFTvHi4Hrrr4vGMLCUhCKf28E
	0axLId7Ufpw3AYBH5zY+aPHIK9d3p6I/csgIm62GAXpYN1FDTMNoO0ryADazAMiJK2BcZN
	dDBObNRNwA/YkUVu6BBckHOFJ/qK7qk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128694;
	b=LXOwvazodMEizm3YHCSWFSzzAz+BxjutZq1kWMp1nwrxiSoQN2Ls0yNgXlOjE9xUbJuMk+
	iheB7g2fHcR29n4N72whuKzFSgjrBSNzNOeiKcPDtIXOhdUCLyf9LSgnWcdhZgYOychni9
	gsx1yeIPPvH+5coG/XzifMawsZ8RJvU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LoVQx5Kz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C20974496E;
	Sun,  8 Nov 2026 09:04:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D311F008A4;
	Sun,  8 Nov 2026 09:04:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128693;
	bh=pP3ktJZe7/4XiaZRjUU/IjnOlBafkxzysIooIWss1Wk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LoVQx5KzYgmXuTXBDQRa7GMLEFPRhxzVTl1tSIRpwrCTpWrus3265PEN6qUN2MGEb
	 qryy7pS5cdDXPuoLXjNc6Y4/bMrZJyLNWZG5K7cjE1vlvYL4e3OCbLqSLUR3hR90BN
	 75bW8dqrxim+6oD0L9sXZ4Voc/ivsAKR53bMwXv1eJbmqidpPu2sxqareVu7tgG1xL
	 Jr/NHeq5XhwP2tn2/ID/1TzJQhXXVeRTxuCNOI5/MRHbEEg5eJJJCsO1iJQ9wWRAk5
	 361OE40X1l0ztxjV3DG6F+8NMnYd2NAk/YtUUvNELe+/B1rXJRg/SZ39hLF/vIAnRI
	 u/faWXXf2K7sA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:41 +0200
Subject: [PATCH 10/14] s390/sclp_cmd: Replace page allocator calls with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-10-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: 9hjhfrq63qj8bws7j5yswa56dea3c78b
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D27720006
X-HE-Tag: 1794128694-887870
X-HE-Meta: U2FsdGVkX1+oaaYiruCr6cwML53qoP9lA1bosU2iyj2HUmm6HwX4xUBXGX5BDAaCtDYMOWHtcpXiZSPnmfl5mTvspwuHOfXixrLjAuwKzHG50pPb/lvQQd9pQeclro3Cbjh9FrBtye4jX/J76/as/6Y1LK0X6+hrDm0DyN7cUSqisp9C19KouR6EaVOyrMR0Fe6Zk/WxaLXXosScyzTDflYXyUzlR8SnCmGS4w34KIkr46ryIriwPP9I+9IHZyntSn/yrPjtDyKq3zPsMGp7CqjmHvxEgM++t/3/wZH4SqbSmpm2wDLhSqXUq2o/ZiBzXmGQD0pNQcGkpVhuu7Jhxs5IZJSmKNlytOfRyfqtz8ED9j9twxZX2Oc0H7NP5t/CdneQnFK8dATcBLIJdPoe4x8Hy6OJN+XF7JeNiBd0CuljKUz30Osqa5nhNAq8CyDGhvdbcRTZfXujcnZBYPjhZvXrQ3KxP+IwnmeVduirEdxHSZHuq45ZhpSkwBj9p1J5D2+lQ4GapK1WuIzXOCJFoH7btQnuHMK5CRpswk1zLZhlgBCxfGc0lEoPSpM92+fPOtSLKF1qrlRpq0hPxHdEDyOfjbey8Ku5yOymJLR7qrHlO5bD7/bHlssEdtp/yjEwXmizefXJt7pp/cwBkb163ximwgozt8jDZTpVYSbxb/I/3lqKw8QFZw1eCWOs7dmdNhMjak2/GKfPP+PzMpYaDsVkePPhcmCksP+C2uGp49cITHaQz/dKZ57DcY1ScBaG7aces7o9DRgempZMRbSHltC1vhoX9EkgZb4e4pwRRVGzyk6c5FErkL9y/R0b1dBD6HRBkUACPyQ6UPnYJ2HUnFrR4zrbYeYEF+vkn+cxJXB0A361KJSZ4nJu0KEf3KBKZNcBmGgXfZCUauZ2ok3t99IIlWTpIzUVAKaI/10pxVAal11tomG7u0gAA3L+hUeWdxgmEb6UgQJJSgjYVoN
 oKWd9DZQ
 Ebw74aDebyNSWsP4gelqoZBu2Usk757L2Se26Fdy1byQbtPOLA0Micam37pGeHlHKRz6xpegFHloRuKWyDLnYMKcI/3Usvo0bwebqW8OxqeoQZ7ePETekPGInIOzpUOFp+Sgxcd+D7DPnIiFCaU6KmuqCZLcM0/LN1KWkgrhyqrdvG6OJPLrFnjT9CREsQaLgoWDtQ6ei6np9KkdeHUYpaBHbuRCXMhtNRL1k1t+1dVSliTm+WvY8vSqEUCqFLMmv5xfJOPM4WXF7eakrGfeYd1XQARUuGE6+1bSKx7vgAp3T8yvRPCVoUNUuMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

_sclp_get_core_info(), do_chp_configure() and sclp_chp_read_info()
allocate the SCCBs used to read the CPU information, to configure a
channel path and to read the channel path information.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, allocate only the amount of memory the SCCB actually
requires in _sclp_get_core_info() rather than rounding it up to the next
power of two. An SCCB must be page aligned and kmalloc() guarantees that
the alignment of an allocation is at least its largest power of two
divisor, so the extended SCCB is still page aligned.

Replace use of __get_free_pages() and get_zeroed_page() with kzalloc()
and free_page[s]() with kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_cmd.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
index 1dc93d945be6f..6aaf1f6a3633f 100644
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -102,7 +102,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
 		return -EOPNOTSUPP;
 
 	length = test_facility(140) ? EXT_SCCB_READ_CPU : PAGE_SIZE;
-	sccb = (void *)__get_free_pages(GFP_KERNEL | GFP_DMA | __GFP_ZERO, get_order(length));
+	sccb = kzalloc(length, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = length;
@@ -119,7 +119,7 @@ int _sclp_get_core_info(struct sclp_core_info *info)
 	}
 	sclp_fill_core_info(info, sccb);
 out:
-	free_pages((unsigned long)sccb, get_order(length));
+	kfree(sccb);
 	return rc;
 }
 
@@ -173,7 +173,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
 
 	if (!SCLP_HAS_CHP_RECONFIG)
 		return -EOPNOTSUPP;
-	sccb = (struct chp_cfg_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = sizeof(*sccb);
@@ -193,7 +193,7 @@ static int do_chp_configure(sclp_cmdw_t cmd)
 		break;
 	}
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }
 
@@ -236,7 +236,7 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 
 	if (!SCLP_HAS_CHP_INFO)
 		return -EOPNOTSUPP;
-	sccb = (struct chp_info_sccb *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	sccb->header.length = sizeof(*sccb);
@@ -253,6 +253,6 @@ int sclp_chp_read_info(struct sclp_chp_info *info)
 	memcpy(info->standby, sccb->standby, SCLP_CHP_INFO_MASK_SIZE);
 	memcpy(info->configured, sccb->configured, SCLP_CHP_INFO_MASK_SIZE);
 out:
-	free_page((unsigned long)sccb);
+	kfree(sccb);
 	return rc;
 }

-- 
2.53.0


