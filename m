Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0092EFEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:23:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64DE06B008A; Fri, 27 Feb 2026 08:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DDB6B008C; Fri, 27 Feb 2026 08:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9BC6B0092; Fri, 27 Feb 2026 08:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 40B596B008A
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:23:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D117F1A0626
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:28 +0000 (UTC)
X-FDA: 84490303296.08.D2807AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id F0A18160003
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:23:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUnyOF+u;
	spf=pass (imf08.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BOr/motDhn8Tz5ip+MII3xvk8iNeh+hbydHUh7eYPg=;
	b=71Z+5xfrzkRiPsnwI+XllqjrmqF8t748LkOh8MxXgjW9+sW5pQqvtIKjlABzKeLEjZ/j2n
	MAV2AfhfkNsVmXZQHevpmGtWYHC013AfpkQ5KC9eoK6gEn0JyoSWGQPFEQN9F2dFD07f76
	x6uPND4lW1FhkFSkGID//HEA5Am/xT8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aUnyOF+u;
	spf=pass (imf08.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198607; a=rsa-sha256;
	cv=none;
	b=1l5jlLMfw3GKNVwOw/NZ+nhj4VhDSohUHypYCZP3Ugx8E7xGDFaOIT2HT0zP9FkRnrXyIu
	qILOaNUFtD1W/nU0QKpRa+AEyDEHKD0f70tyvPXYzxg659OtmMPBw3el0fKQSKjYFQ/3kk
	IXQ8v7CsIa7h577U6xHeVRR3hqSTbdg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2C0B4167F;
	Fri, 27 Feb 2026 13:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C688C116C6;
	Fri, 27 Feb 2026 13:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772198605;
	bh=lElZts2cuQOlY9aUjaqr5WZYPDwOSZ2Mb3btADVyBc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aUnyOF+udYtL1ykv8pOFaVslgKP2zD/zeGmvscsz18MoxVEJTPyU/Eg0ACVRF9QE6
	 7medwVI9oZtGLizGJJid62cpzlYeWZeeHsB/EILoAfnKaXFpI2OdgymgIKmfcilJ2g
	 pPXs8E/8oU6A5oGe55yuN/LXPwGNvUdlnwCRmwKj7vnBivnaZAZfPGR/WAFiE8dDRV
	 k3DZiAdx18nlw4LXkryQ7TZ9jGEQFDl6jEva1KamPfBdn6FFEvcaJxr1LnnAwcS6S4
	 GCFmQZkAfrM9uS0ViCvC5AWBiIHkqFTQWHQUBE65WO7gi0HEV+QoQUXjkK/g9LShWx
	 E/Ov6rLv/RRuQ==
From: Maxime Ripard <mripard@kernel.org>
Date: Fri, 27 Feb 2026 14:15:42 +0100
Subject: [PATCH v2 3/9] dma: contiguous: Make dma_contiguous_default_area
 static
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-dma-buf-heaps-as-modules-v2-3-454aee7e06cc@kernel.org>
References: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
In-Reply-To: <20260227-dma-buf-heaps-as-modules-v2-0-454aee7e06cc@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 iommu@lists.linux.dev, linux-mm@kvack.org, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1675; i=mripard@kernel.org;
 h=from:subject:message-id; bh=lElZts2cuQOlY9aUjaqr5WZYPDwOSZ2Mb3btADVyBc4=;
 b=owGbwMvMwCmsHn9OcpHtvjLG02pJDJkLZ+28vP2r4bSIbPFKU9eDK6yerHZ0etl9+oq6YnHe1
 ezif3kKHVNZGIQ5GWTFFFmeyISdXt6+uMrBfuUPmDmsTCBDGLg4BWAiRicZ64P0mI/dVJ/oWqo/
 xejKnMefFux9VLtt8r0gz7ibTL5iLx8t+aNeI8ufstXB7k9C676JKYz1nocPnT6zULJSSWsax5c
 ilebF9fOD1omJbdd0PvfN50jErN+7Zt8ITNx7xMP66mL21JKnAA==
X-Developer-Key: i=mripard@kernel.org; a=openpgp;
 fpr=BE5675C37E818C8B5764241C254BCFC56BF6CE8D
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F0A18160003
X-Stat-Signature: 586c1ixeta49sthiihfrz1ngedebtrtu
X-HE-Tag: 1772198606-216575
X-HE-Meta: U2FsdGVkX18E3/WVnDWJkZnTzH0nIp8wGYgpfEVtEzwRH8v9iIBAY04IeyKfyEuXuCi5GVwkRH+XqFSd87HvjmQ5LYKxFFmmnvY75zD3BY1EhEN8qsSUK8mXKGQ44E3zhomIwHsywBw7J41FOPsVoUHy92ab7YXsaUZ0q3+2ktN7npEmyud7/AQCDQISYyy27ftw5PQgBCmbc0qhg56ZHY2qt8rKU6pM5zliUb+3uRmodUbkSw78tiB1P249cTNDQxYknKvdk9ughK84o7o0WP4EEJZtO2JyGVlfIDZ4Lh7cP0uxAutom10bg8izCVX5eQ7xWrXxA/feCUWWsbkhjfiuefiOJRtImMDtOFjV6vxYn7mhC3sc+E62mU06lNOw6CuaNqXiIyMpieexIiJhAnQx+cl/KE6GZp6H6OwHBbG7HcbWMuBzyGzFNyo/y4JUvulcRIPG9jGIKmzQgpXrbHgtuCEt2nhF2sNCqkhLyilc3nW+2MGqTScdtbHPLcNKN6NMrRee4JWGAyaY+H+sDatQ/4dgcYP2u3PKZ6JEiio75aAGR7x5YL3LnWddGO5Q18+PMQ0uqxod7noObLKDOa940a+1LTguH8OW3ZnlHkirATzs9mT/86QuqIh07fVHk/XTSjMDGZ5+wxxfO6d06kM9pawDLA7y2//krMd+lB0A5Bfp1UeQ8b1NzF4r+0LYjOQG/OVpSRpEW0HbmAVH7dpujg0r2lPHL2f+BgBqKe2l2I32s49e/eUeq+DgnoJ+hUnUbJtm3EdzvZlMdjy5f155a9xqmy1zQnS0PCKNQr0Qd5mOSg0tSxSKIyTA9WNyb6GBAf3NzAlBOPfd3xhhpldDGF72IJ2kcJbq+hf0+CdcVbW5gw99UHw4vGGxhHoR6zFb/aLFpalYyeym95Gv41NRcY4YbXd24nYEL3pUVJjUuX897Ro79CwtRGCnQNo7nDlt4P8TWNTqTw4HzF7
 Ejpj3wMF
 GC24+zDQAuMh0b+8giL9hl+3PNzxh2xhO1FHOiNLkaAuJojAzqCZxrUHUIw9/SKzIT5w/Cm70zga4rQiaaBTIGLRgV0E//Q4Eu03dDck5XYWYu+8ymLUnIAlfasthDJoDtcx4HLJcinVLb1owbuST978lrM7OwKF/65FGeDsUBnkc2DBylgyoYmyA5FVVawKfpMMJOhCD2F/46MvIuvGmyExY4yusnd3CCgorTrQueNBmpXRI+fF2FOappN7aFjQ1nX2+cvElK41Fs+uJluzcBS5drSAd7vGhXNN2ErrWZSoWRx35t4pQl/tSKJboUChoVC6m/iRO+QaIkvo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that dev_get_cma_area() is no longer inline, we don't have any user
of dma_contiguous_default_area() outside of contiguous.c so we can make
it static.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
---
 include/linux/dma-map-ops.h | 2 --
 kernel/dma/contiguous.c     | 2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index dc7d54ac5dd66bd22ef868d7894cc1cb2ee4c156..526c6978a306ffacd5e30387a2fd21af3333cf6c 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -89,12 +89,10 @@ static inline void set_dma_ops(struct device *dev,
 {
 }
 #endif /* CONFIG_ARCH_HAS_DMA_OPS */
 
 #ifdef CONFIG_DMA_CMA
-extern struct cma *dma_contiguous_default_area;
-
 struct cma *dev_get_cma_area(struct device *dev);
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
 int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 9a9ed7248fb823105609c5db5a51113e54a40192..a4279d800d4658bf1c33b9b1da100eee1367d42f 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -51,11 +51,11 @@
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
 #else
 #define CMA_SIZE_MBYTES 0
 #endif
 
-struct cma *dma_contiguous_default_area;
+static struct cma *dma_contiguous_default_area;
 
 /*
  * Default global CMA area size can be defined in kernel's .config.
  * This is useful mainly for distro maintainers to create a kernel
  * that works correctly for most supported systems.

-- 
2.53.0


