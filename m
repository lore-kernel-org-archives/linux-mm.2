Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071D6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402796B0093; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D8976B0095; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DDF26B0096; Wed,  8 Jul 2026 19:49:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D802A6B0093
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56FC21C81EE
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:01 +0000 (UTC)
X-FDA: 84967252482.08.52F7B93
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9B7E840008
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:48:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VqbAnfnX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 36uFOaggKCEMxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36uFOaggKCEMxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554539;
	b=mkuu2e3EamDlRvBA750a7ejDBuf7J0w+DtXszCqhlHs93AXmShqBpsmorXP/fxOYVMrx9w
	aVpOs7V+2uLmadi+TJK9cpMq6xNWBkAk0MqQ5pp2xsBOIoOyAeD2pP8nD6eDbpafBzw+f5
	juLpr/46wEFvFn2VnAgxDPcfj7RcRSU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VqbAnfnX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 36uFOaggKCEMxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=36uFOaggKCEMxpmf1foflttlqj.htrqnsz2-rrp0fhp.twl@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZBzRoXH7VF0ByV3qQDpFWW6MWj2hI4S3QQKMPJnM4U=;
	b=SyOdGY+r6nqXCQo3FTC5p9UNYR4fXrtdQuszL17bsWvQm5wNjJHXW8YBAQzdtpPUk9e18c
	Vu0pLCs/YLJk7PYipWFoAYU6X2w1iEG62Xgtz0jVN/rPu9nLYHcGhxIphflOJ3sGNlaoA7
	m9R8QjOlQmdeVaMD1O6q6h8xDeB2jpE=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-8484f26852dso745203b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554538; x=1784159338; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RZBzRoXH7VF0ByV3qQDpFWW6MWj2hI4S3QQKMPJnM4U=;
        b=VqbAnfnXaInHXBRw0e2aMXnkGMUuMbnqHU55TkvGIr53Trtc1f7MBntaNIrz+cmZkd
         JC0vddt1zfrKIPVDrJNCNIQzo3Uot2wMgw9hdwsAin6hi+Ej23S0msbk+ryI589YQ7EQ
         Da55iV6KC+hSwrcGsOIP1vVwOveTYoY/shKn/Ss8q3dda3IV64tb1yfk28di7UFxZBTW
         ek5o0goHcXzGLDOAXGE+8hJH5FTthCUQ65xzT65vQIi4Y3UVEZT30ugJN0IGNjIo9P/S
         eKSFSuazQfRCoN4qv0sJxZb5MGVB2xAhb1DN6KhVdM03kIUaBgi47WarOfCPwwpz0n/K
         +tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554538; x=1784159338;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RZBzRoXH7VF0ByV3qQDpFWW6MWj2hI4S3QQKMPJnM4U=;
        b=P2XfouBAe4PMaJl/MFK4jrU6Pmpnq38h4dkEvAKjbkx1vuFQiIHDYS8JwcjIrER44v
         3d725s467TBm6xHTB4XUfGeDF89X9zJrjezlI2I2zCeXD/qDnPra71IptBP91ffVaztd
         r1J4k76sTAo9/VVgyNKSz5JjmUCexMycqr2q9C3QlWazC8WXNby97jnYuzExRuswv/Ng
         6BdWihlR0ivBy9Grm8k2l8cCQkTmHhK5SJ0iZGO4INJ44/W5hUj08D5botE6qvT57VS3
         XPgx0pf0/Mr+b7MpPvlDFUUJO4/eQwFCc4cJiFGP8q6gvKXG8gyyf5+SafDYgeS3FmWQ
         KLcw==
X-Forwarded-Encrypted: i=1; AHgh+RpajYOcM7Q//yazTIVrSRpJgPCj/XCl50S9Y+DmfdFgJ3b+y776hlutt6UjgVkNhe50vTxf+AeXOw==@kvack.org
X-Gm-Message-State: AOJu0YziWYt21XEzbt3hWyePycLm2tUSE1xlSWGz0/ziQQGcH+cbC0gf
	wstPdRW9Af6XB9F5E20EUuzOA/Z03P+v0zBIlVmQ/rAb5ZTIi6J3jKskuZd2ZglIxnIMy9Z8AAm
	hDJDDInbFobdBKA==
X-Received: from pfbhh2.prod.google.com ([2002:a05:6a00:8682:b0:845:4da8:56a5])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:805:b0:848:3f83:de9b with SMTP id d2e1a72fcca58-84842fe47bcmr4585485b3a.9.1783554538155;
 Wed, 08 Jul 2026 16:48:58 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:48 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-5-skhawaja@google.com>
Subject: [RFC PATCH v2 04/10] dma-coherent: Allow checking if allocation is
 from dev coherent region
From: Samiullah Khawaja <skhawaja@google.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>, Will Deacon <will@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>
Cc: Samiullah Khawaja <skhawaja@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Robin Murphy <robin.murphy@arm.com>, Kevin Tian <kevin.tian@intel.com>, iommu@lists.linux.dev, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Pranjal Shrivastava <praan@google.com>, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9B7E840008
X-Rspam-User: 
X-Stat-Signature: c9swqzghoxf97uop67ienqu5ihkzds9x
X-Rspamd-Server: rspam03
X-HE-Tag: 1783554539-278574
X-HE-Meta: U2FsdGVkX1+uwm/eKFK3fQZhT2t5NfgPE1Wh+A6Bed95NX0EFnyb0VDT7oxdYxaeClsS5HGIh9CGzwF0rwXi3A7anJBufrfjxQM/+fW5JRmVvVrjZcwjekKGDMUQh8Z7RvHeO3eR4tK4vvhp4k1iyvYAt7kl7tNpuLR6eS8kLAKnVVufgMgQ+Du+OrlYcKztnYCTfvMNx/eJS+V3bDn9VzMds0DVwCfS7kCbrBl79kUgl+863Kv3PansgUdjzI4YpEREuB+WAqzKyU3781zPtM08kW0PEiwjmIwqTUCXOEV1J1HLUWcD15H9H8fUKYWYq0QlQJZtIx4SGueUFioPs0Q/oklgYnw4bgtoA7T4TcH+CCiiOfZaeYZHtpFjLXdi7dMaORNtK5aceVoIZE/+OHdoJtPUlJbCUtSCBux6HExBQkOhBE4PuCKd8OXlSqIySbgxjdvDeZL3Au95gtwoRBmdIH8M4yT08YRRFs2F/Tc7lyxp/klL0NlO6O6S9mbtwR4WZuuPK1uWPhi3oDtyBLIDxeFNjNci2KMptj4jQk87L7jJZWgf6UZI4OAzCKTnvFNBN7HQe4y8kJ/YzNeUMP/q2FM8oaWp+vwAl4RFGPvd9xlXu6bqnLQyeTFWOR4SourWJh6fDj5DfwBPMJu/fkECJnzlDznw54Y5KogqyWiDpxC2ul2qioI/ZCUbGyPpm0G8Xls9FSVXMvQiZVrgfdZNBtF8E9khgeqGa1XpD04GyKTJIDtJaDnjRDCCviIU8Wvlefdinkmugg9sYd5ShRelTyf9atCb/CT/mlVRkQCba8nWL5Q5lACyuzoS2iEq+r2qXqdP7FrvCurBpmtKplvsZuVVllTCtHn70/Q5CGlj5uxNd57sJEPL4Qotw9dHoZ2lsMyOHK+z+62XI9lyGLw4Fi4ftHVZrCF0VbfcD7LxoEnQtMhohGLEIj16Ln5juNSdQUtQS6/YS0p5e+s
 BawpcfzC
 ucAIkVFD3/RyX5mybLK9fGmJD9thSe0ILt1fQt8/ydJeW3BcIlvr3H9sFIla59YC+GDQswmpmN8fJ8KjxJ8y21FHs1zd/XsITfoRS8syjs+TvXS3udmWLahD5yUTHsJGDmgImwwz6imr5q58+fzdO+hesBh5OSvMnjr/nkixEShaRRPEP4E/VnShUIrvjeRGZGa98oopKi2E6yqW9DS156+1DP6SkwrD0F2agESumFMqRlbPhhT82qwbw13+iX6NRC37ipZQglut/4BkSlwabicABCquY7zV3Rms8/kRXG0PZZb9BJvU+yKvzThJLnP8wrHI+Wz3f86j3f1vSf0/RQEj26nQxL7iJSfOe5YodGEdpaOd6VlGFJAaY0V4RVwtGlz8ONFBLc+XnHzrtokAIrkPDiFnMJnajPE3KR5AvfJYCbHPMxLyjGxjgUhXE64CB6b0sqWrm/Xa1QLHgBStDUVNgIXGM1LelY/Z3f/0I3+OjoSIwFt8LO9Uhum9SRYaxRE8/bmmzvBwVIVmMENAUr8lSRgKOLJg8E/d5lQOpnEPkMZPvnBYnp5dSYC0BAhLUdc4XnXnDP6Af/qSwEv/gNMA0xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an API that allows if a DMA allocation is from device coherent
region.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-map-ops.h |  3 +++
 kernel/dma/coherent.c       | 11 +++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 9b91c839ceb5..b13e5eebe6d3 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -162,6 +162,7 @@ int dma_alloc_from_dev_coherent(struct device *dev, ssize_t size,
 int dma_release_from_dev_coherent(struct device *dev, int order, void *vaddr);
 int dma_mmap_from_dev_coherent(struct device *dev, struct vm_area_struct *vma,
 		void *cpu_addr, size_t size, int *ret);
+bool dma_is_from_dev_coherent(struct device *dev, void *vaddr);
 #else
 static inline int dma_declare_coherent_memory(struct device *dev,
 		phys_addr_t phys_addr, dma_addr_t device_addr, size_t size)
@@ -172,6 +173,8 @@ static inline int dma_declare_coherent_memory(struct device *dev,
 #define dma_alloc_from_dev_coherent(dev, size, handle, ret) (0)
 #define dma_release_from_dev_coherent(dev, order, vaddr) (0)
 #define dma_mmap_from_dev_coherent(dev, vma, vaddr, order, ret) (0)
+#define dma_is_from_dev_coherent(dev, vaddr) (false)
+
 static inline void dma_release_coherent_memory(struct device *dev) { }
 #endif /* CONFIG_DMA_DECLARE_COHERENT */
 
diff --git a/kernel/dma/coherent.c b/kernel/dma/coherent.c
index bcdc0f76d2e8..76cbe11e1f90 100644
--- a/kernel/dma/coherent.c
+++ b/kernel/dma/coherent.c
@@ -231,6 +231,17 @@ int dma_release_from_dev_coherent(struct device *dev, int order, void *vaddr)
 	return __dma_release_from_coherent(mem, order, vaddr);
 }
 
+bool dma_is_from_dev_coherent(struct device *dev, void *vaddr)
+{
+	struct dma_coherent_mem *mem = dev_get_coherent_memory(dev);
+
+	if (mem && vaddr >= mem->virt_base && vaddr <
+		   (mem->virt_base + ((dma_addr_t)mem->size << PAGE_SHIFT)))
+		return true;
+
+	return false;
+}
+
 static int __dma_mmap_from_coherent(struct dma_coherent_mem *mem,
 		struct vm_area_struct *vma, void *vaddr, size_t size, int *ret)
 {
-- 
2.55.0.795.g602f6c329a-goog


