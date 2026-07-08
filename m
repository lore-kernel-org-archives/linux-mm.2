Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A97C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 23:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE216B0099; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5A56B009B; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC4166B009D; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ABF6D6B0099
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 19:49:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B136C13B2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:04 +0000 (UTC)
X-FDA: 84967252608.20.13A3CDD
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A3C0C0007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 23:49:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="a/zUf/JP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783554542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mg8HPDVADkikyFkQazKzK0at34W1Wn3VUkaO82xr5dA=;
	b=LI7USrOKbtiKaVrn5+yBln50G19X7+8lfCPxnT4Y7IucV7YdG7y+EtthfO0vIUbIQqf0Hy
	1Y9kitHwxNZurcIkSOs8L1jSbkpEzOew3gotRLPtng11XrJQ8YhOO6opZFqUMr+orF9jds
	Ac+32aHuknApSFBwoFln/ZmSxb4htc8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="a/zUf/JP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=37eFOaggKCEY0spi4iriowwotm.kwutqv25-uus3iks.wzo@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783554542;
	b=3gKYshQwDeYAfDCtz00pvZq6ykdtqMUhQS9dUvNHeDLWAJD1MDJwLKbX1kHLnI1vSVP2wa
	Gd+lBTlYygFqldRLmpzPSjXPwvmPd73WipF1qjWpeK6ld1WaXqZykhQwiYTcUq/tTSs5eC
	P0bAydTZTykL6JIvFCIm6gJPbR4JA1s=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-848551b54f5so570778b3a.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 16:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783554541; x=1784159341; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mg8HPDVADkikyFkQazKzK0at34W1Wn3VUkaO82xr5dA=;
        b=a/zUf/JPbD2TnDNPQ7FGT833SXY0hxMW9cWaMIcN+1W9mMNmuVv0v7zVKyCsPq2mQf
         6jgeS6wEUaIZ8a5cLpkasa9wMaVfHSKjv6ZdOB8PBGgyb58PNnNiimivX13pp8E7Ge3u
         jnG2RzgDA1dzJIKQkuDtJt812drE7NN8jZ5uTKhyW3yaaqIvl7vXL+tktocrj6O/jmLZ
         +OXlpQZHVf+O7gM9ohxzZVGbnai8MhhkaR4JK00gSyY3l2YyhrJqq/yryZZ2xSNvdr+4
         R/QOieHBa2vYHl46Q3tVR3/WFq1pZs3JPT3m81LRaAqFydYSKBhLQSEvt+XHGkkA3cHf
         bUzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783554541; x=1784159341;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mg8HPDVADkikyFkQazKzK0at34W1Wn3VUkaO82xr5dA=;
        b=VBoRKEpwlCWL9jqPdDxvVINkTKM3aVXxWwrxOeppCmr3vvnJk7+Pe0MmFGknJ3+uzk
         C+1JsHHtpdp8/J0+3Ln+iDLzN14bbd/kQPnOlW09C+nIU24En5yar9buT/cszoCuLS6j
         2xSKbXlZa0iWdS4vtVtO2Tq+2tM6XF9Wr0rDJ9SiMjJV8tp8LKRyeeOt+pmspSp5cpQc
         jkbErzJQagJbnzs7VbmNk162HozrLyI4GzVylNlug38N7OqSgWi8meInFCFMQUpLEPNP
         XUm2PzlTl0woXQfjJ1lVjKV2ag7jRfF/jSyIfiTRqIOt7ImSCI5gWkcfX2dKt0sql8k7
         xqTg==
X-Forwarded-Encrypted: i=1; AHgh+Rr4OITnd+gkRNHm6hHI9L9k9BMRRgqSX6DnOutKpE3yAxaWR1IrW0xEfFaga3vtuOMW7ccR9vS31A==@kvack.org
X-Gm-Message-State: AOJu0YzedUsXaQKbO89olHnrZh6UobKrajaSqdjaxTt8QBAWoFNTSbK9
	gmzQg8cMyGUxBzdZHzLnnqb2JGVMiAYBpXwgZidfgswubrlvRimuHrb0795FArq3rcueFzxqIV3
	5bGjA0HTex0IHfg==
X-Received: from pfoc15.prod.google.com ([2002:aa7:880f:0:b0:847:ada8:bf86])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1826:b0:842:706e:ad43 with SMTP id d2e1a72fcca58-8484324665bmr4017531b3a.33.1783554541070;
 Wed, 08 Jul 2026 16:49:01 -0700 (PDT)
Date: Wed,  8 Jul 2026 23:48:51 +0000
In-Reply-To: <20260708234854.4044652-1-skhawaja@google.com>
Mime-Version: 1.0
References: <20260708234854.4044652-1-skhawaja@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260708234854.4044652-8-skhawaja@google.com>
Subject: [RFC PATCH v2 07/10] dma-mapping: Add support of preserving dmam allocations
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
X-Stat-Signature: 4fhcc8q5mjnp1hm41scre87mgdn94866
X-Rspamd-Queue-Id: 7A3C0C0007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783554542-191573
X-HE-Meta: U2FsdGVkX19t6x/JGGSi+MZ1tWeZlFztCgXRNyNzzss+7iHMnNQncZzg3PI/Ue1AgTMREZO6Xk5B9MVybX6jCLfxo/0omx+wrUW4NGyLTfaGpnEzNvMDYdDo5PGWdjZlqeSYoMtkO0RVEh5RhQNUxdDrSXBCOI/L3z0Y1QoAthzedQPTHA9KJ2vr4CgdkLR1cjqeospheMlqKujdzcDXbabdhKftLbU/hECFo7YGwN9jUvtVeh13bGlSIBZx3r6wciRpKmFCPBrUFzO4hed+FDUtjM+pgEfeTk613twuSTJKM8OalD0FrskHpix+reJHpS0ywVqpUTP+RStmi1ATe55Z6XqkYnAGfhuLXr3sBNxq4C1b768Wg43+8+YIZNxkwO+XY0Kq5gye++Qq+K5vJnQghDyMyuoB38UXXr0lWJmxLelNBOmjwgQ2GeHO5k8UO/IPAafl+P+8zVEUjhdynNZakj6NkNWDjf4TW4dctKx8q3VkzpdlL9OJ9cOVIffREFsv/nZbFxEvHWLmxyp/abMcF8DZolAdF3GGg8QbdUBynCNbrMIK3LJ9Gh40uCyij9q4DMb/+dnOQqLb9kRnY2VEKWjDfVh+Q60C9M/A3K+2cjLowu20bf5t6gYDs28YSTnPwW9bgUy2b/EwY21mT1zIBoPTMpsXunCwsfWp1aI0nUkZT9Qes6++hZ8xDbzjywui5HeSWY0oxhouZo3QVnUkej/dQouibha56ZP7VSK3WoCOFrgx+uRWL+pRX2HbfxL90VWgTAypErt/S8WxA9hX/LwZHQjxNeVTv/KiSuPN18b1KcrFEPn1SRO2523yuSvwFlEXvhnmaJXReWG4YMlMcD+x4cY9UQuJG0o+k4P2NhQmWh7piKCyw4sHsJPJiwLTpepbyjFfnfYmrhgMstsqXk5RywIUx92/A6vZfHtOdHjcSEEuglZ9v2WMCUr6zMwruNNc2rJ9Uv03lo7
 db509N4U
 WJsExxTuWrXEElKZSUH6IyRavkv9Rw/Hpv5LdcHV7/q5Vsj5Ssckk/HTg2kZFNJJqtd7JdLfEWngJCojn9JoxED7Cfs1y/JFYe6v/2oUCgH1tBDLi2nn4c+16T2LeS6stormUy7x9UZw4kdOyh+nVjhxoe4zEmllISySwPV2CculMqoBI2DRT7oDvLzKpfKWaC3vcC9366iBJWR9DiNZfOBltGzEDaU2R0U8C3gVbF4SfFhcB31YTkONe57IO/RemFE2X+lYWmdZuJWwtWmge0SyBFeBbcg0uqaF/m17KCmwkrZv7sWOb6YpZ9KnLvuenCteQPN+Q5KcjE9giEbhAIx1Ks7D6nIjwpmjGoG8DxANlJgKg1L49CdhYEFmzLtYtzrmcxT1xIVT+bJBCbRgt7BHLZPkM443sn0eZ4S0NIM72cu60eX/rDLfkIzxTOAQHyfu/Ba6hdg8DuK6xyrpbXSPHxVBQp07V8JOxx4jjpR7Ei5+E8ViNWcoGm0cylcuXJ7Rv6ekUTw3dGNEqzByOgMuC6KkjgbUjQbAoYem7WTr+EAUPQNBJNCD+t7V/L93zJYTO25hpusDuriRm/z9mUIbYxBmKzmenI2tS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Device drivers use dmam_* allocation APIs for managed lifecycle of DMA
allocations. Add support of preserving managed DMA allocations so these
can be preserved and on restore these are managed again.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 include/linux/dma-mapping.h | 50 ++++++++++++++++++++++
 kernel/dma/mapping.c        | 83 +++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 3756fc15467b..4c0c428b6b1c 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -218,6 +218,14 @@ void dma_unpreserve_allocation(struct device *dev, u64 state);
 void *dma_restore_allocation_attrs(struct device *dev, size_t size,
 				   dma_addr_t *dma_handle, gfp_t gfp,
 				   unsigned long attrs, u64 state);
+int dmam_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+				   size_t size, dma_addr_t dma_handle,
+				   unsigned long attrs, u64 *state);
+void dmam_unpreserve_allocation(struct device *dev, void *cpu_addr,
+				size_t size, dma_addr_t dma_handle, u64 state);
+void *dmam_restore_allocation_attrs(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    unsigned long attrs, u64 state);
 #endif
 #else /* CONFIG_HAS_DMA */
 static inline dma_addr_t dma_map_page_attrs(struct device *dev,
@@ -523,6 +531,25 @@ static inline void *dma_restore_allocation_attrs(struct device *dev, size_t size
 {
 	return NULL;
 }
+
+static inline int dmam_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+						 size_t size, dma_addr_t dma_handle,
+						 unsigned long attrs, u64 *state)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void dmam_unpreserve_allocation(struct device *dev, void *cpu_addr,
+					      size_t size, dma_addr_t dma_handle, u64 state)
+{
+}
+
+static inline void *dmam_restore_allocation_attrs(struct device *dev, size_t size,
+						  dma_addr_t *dma_handle, gfp_t gfp,
+						  unsigned long attrs, u64 state)
+{
+	return NULL;
+}
 #endif
 
 struct page *dma_alloc_pages(struct device *dev, size_t size,
@@ -797,6 +824,29 @@ static inline void *dmam_alloc_coherent(struct device *dev, size_t size,
 			(gfp & __GFP_NOWARN) ? DMA_ATTR_NO_WARN : 0);
 }
 
+static inline int dmam_preserve_coherent_allocation(struct device *dev, void *cpu_addr,
+						    size_t size, dma_addr_t dma_handle, u64 *state)
+{
+	return dmam_preserve_allocation_attrs(dev, cpu_addr, size,
+					      dma_handle, 0, state);
+}
+
+static inline void dmam_unpreserve_coherent_allocation(struct device *dev, void *cpu_addr,
+						       size_t size, dma_addr_t dma_handle,
+						       u64 state)
+{
+	dmam_unpreserve_allocation(dev, cpu_addr, size, dma_handle, state);
+}
+
+static inline void *dmam_restore_coherent_allocation(struct device *dev, size_t size,
+						     dma_addr_t *dma_handle,
+						     gfp_t gfp, u64 state)
+{
+	return dmam_restore_allocation_attrs(dev, size, dma_handle, gfp,
+					     (gfp & __GFP_NOWARN) ? DMA_ATTR_NO_WARN : 0,
+					     state);
+}
+
 static inline void *dma_alloc_wc(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t gfp)
 {
diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 3b07bf30722c..aec1222ab5ae 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -37,12 +37,25 @@ struct dma_devres {
 	void		*vaddr;
 	dma_addr_t	dma_handle;
 	unsigned long	attrs;
+#ifdef CONFIG_DMA_LIVEUPDATE
+	bool is_preserved;
+#endif
 };
 
 static void dmam_release(struct device *dev, void *res)
 {
 	struct dma_devres *this = res;
 
+#ifdef CONFIG_DMA_LIVEUPDATE
+	/*
+	 * Freeing the preserved memory is dangerous as it can cause UAF in the
+	 * current or next kernel if the memory is still being used by the
+	 * device.
+	 */
+	if (WARN_ON(this->is_preserved))
+		return;
+#endif
+
 	dma_free_attrs(dev, this->size, this->vaddr, this->dma_handle,
 			this->attrs);
 }
@@ -675,6 +688,76 @@ void *dma_restore_allocation_attrs(struct device *dev, size_t size,
 	return cpu_addr;
 }
 EXPORT_SYMBOL(dma_restore_allocation_attrs);
+
+int dmam_preserve_allocation_attrs(struct device *dev, void *cpu_addr,
+				   size_t size, dma_addr_t dma_handle,
+				   unsigned long attrs, u64 *state)
+{
+	struct dma_devres match_data = { size, cpu_addr, dma_handle };
+	struct dma_devres *dr;
+	int ret;
+
+	dr = devres_find(dev, dmam_release, dmam_match, &match_data);
+	if (!dr)
+		return -EINVAL;
+
+	if (dr->is_preserved)
+		return -EINVAL;
+
+	ret = dma_preserve_allocation_attrs(dev, cpu_addr, size, dma_handle, attrs, state);
+	if (ret)
+		return ret;
+
+	dr->is_preserved = true;
+	return 0;
+}
+EXPORT_SYMBOL(dmam_preserve_allocation_attrs);
+
+void dmam_unpreserve_allocation(struct device *dev, void *cpu_addr,
+				size_t size, dma_addr_t dma_handle, u64 state)
+{
+	struct dma_devres match_data = { size, cpu_addr, dma_handle };
+	struct dma_devres *dr;
+
+	dr = devres_find(dev, dmam_release, dmam_match, &match_data);
+	if (!dr)
+		return;
+
+	if (!dr->is_preserved)
+		return;
+
+	dma_unpreserve_allocation(dev, state);
+	dr->is_preserved = false;
+}
+EXPORT_SYMBOL(dmam_unpreserve_allocation);
+
+void *dmam_restore_allocation_attrs(struct device *dev, size_t size,
+				    dma_addr_t *dma_handle, gfp_t gfp,
+				    unsigned long attrs, u64 state)
+{
+	struct dma_devres *dr;
+	void *vaddr;
+
+	dr = devres_alloc(dmam_release, sizeof(*dr), gfp);
+	if (!dr)
+		return NULL;
+
+	vaddr = dma_restore_allocation_attrs(dev, size, dma_handle, gfp, attrs, state);
+	if (!vaddr) {
+		devres_free(dr);
+		return NULL;
+	}
+
+	dr->vaddr = vaddr;
+	dr->dma_handle = *dma_handle;
+	dr->size = size;
+	dr->attrs = attrs;
+
+	devres_add(dev, dr);
+
+	return vaddr;
+}
+EXPORT_SYMBOL(dmam_restore_allocation_attrs);
 #endif
 
 void *dma_alloc_attrs(struct device *dev, size_t size, dma_addr_t *dma_handle,
-- 
2.55.0.795.g602f6c329a-goog


