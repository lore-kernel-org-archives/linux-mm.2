Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBB8606AFE9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=FKm72l0t
Received: by kanga.kvack.org (Postfix)
	id 5F20D6B05C0; Mon,  9 Nov 2026 13:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DC06B05C1; Mon,  9 Nov 2026 13:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380C16B05C3; Mon,  9 Nov 2026 13:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034D26B05C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:25:54 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 74D0F1C40CE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:54 +0000 (UTC)
X-FDA: 85416409428.06.1817B05
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	by imf28.hostedemail.com (Postfix) with ESMTP id AD3A8C000E
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:25:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FKm72l0t;
	spf=pass (imf28.hostedemail.com: domain of 3LxDyagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3LxDyagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794248752;
	b=jU4KLgFaiQn0B6L40mgMFfAfyoRK/aiAnZcEWJb2DZ6Herqg7fjvO/rgtwS5GB20z7Qw02
	inCDFshL+AgSLyJrccoujVa5QCmK2npXP5zxwPDlKauy3a8Xy8Avmqq70NjXqc9BTVvRyg
	LNBLydQzgjLvAJkYUMIljt0xzDUcsiU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=FKm72l0t;
	spf=pass (imf28.hostedemail.com: domain of 3LxDyagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com designates 209.85.208.69 as permitted sender) smtp.mailfrom=3LxDyagYKCHYflcttiaiiafY.Wigfchor-ggepUWe.ila@flex--lrizzo.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794248752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4FRRH2f1mpofi8Bw52dIaCfMnIwpoAnS12GtkdilC4=;
	b=Tnb8XIC7/KHK12s1G1eR8KVMFI8DCp8apyyxUIuK5uGJ3+SZXcVRo8qARY2SKf+ZamKvq7
	FQ8C40C8BKarj01aeOQAbqgwC0C1SiXHgtbsuoRL5gBI2fyErTxs5JAwSiifuWMTfyZWMz
	us8fqNoOoe01kzXYlWI25Uh5YC114yc=
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b706aec65bso1054751a12.3
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 10:25:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794248751; x=1794853551; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G4FRRH2f1mpofi8Bw52dIaCfMnIwpoAnS12GtkdilC4=;
        b=FKm72l0tkFq8ISl478rRYIXB1D726yB8ccjJxSFm6jovo4jLzl4EuomLGDC4opJJGq
         RU9VyalLYVbWYTKHGbStdZqFPczJFohltXp1okJGoaWtC/pZGjK6ACr5KwBLUUpjIWga
         y9U/x8y8T+mwyfeCYvNHQnm/dwj2axLxynqZotJ2eP6hY81ZERH8vXAgwWBi3OuFUnAN
         Diw3niqOFvkqMw8hvuyjQ9WoGKeCRxi4/2l/NvHjjrZ0MOzPPGGMyvb0k+GX5Xy8dYnN
         BghzUxzzqD41N6okLpnLDik4vEH6Lt+yI333QMMoxdmw2SB2FZeGdsQPFLdKoErQeS+r
         /oOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794248751; x=1794853551;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G4FRRH2f1mpofi8Bw52dIaCfMnIwpoAnS12GtkdilC4=;
        b=wgHWpaGSF4tE3aciipzmXKKokSND/nEZZeiIvUcn7vqfojX+cKLbtJsKnTPswVwhZx
         OAYYZ2gmVvVhLDtDT6enLZOoWej68Rfl9KyHZ1eOx5ZSuX0E8qAR7HC3CTpHAv4arJMe
         cInZSyBMGzf2/hJvBV7NqTV8FcNl2yXGnl8F4RESRaUpnmu0j+Ot/2HM6+0TzILfMdVD
         yW0hixi1fRosw6uBPmlT4yB+tA7CDTi3ONkF52lYML7SdKmRjrjPNZ58Om8gbhdiPH/D
         8NjUWQUEM0PkjeAwgl4tTb6HEgIJfW/pTEpMPjH2sajbaMIxCwJYRbDbAtACITxDDAnU
         I1kw==
X-Forwarded-Encrypted: i=1; AL+hErHivLubUrnMrVU14U7ux+D6BtRzLknQdGNinFVoQi+HSoZ0VEymqeBOaD9K648uGTBOmwP62spsog==@kvack.org
X-Gm-Message-State: APuU4Z8x9tNrQN2MjRRhuanmtjbAah4PrvDkMNKfeoO1cay/l68nl4rZ
	9UYUXDW6veyK+7NBbUeeDLAtjGs+S3hOZWeK3B3gNe59eAmuZhYtW+SaD3Z8MepcY/yRI46iJX2
	IITxojQ==
X-Received: from edgi4-n1.prod.google.com ([2002:a05:6402:a584:10b0:6b5:643f:859])
 (user=lrizzo job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:2346:b0:6b5:962e:e017
 with SMTP id 4fb4d7f45d1cf-6b756ae5b64mr360068a12.23.1794248751041; Mon, 09
 Nov 2026 10:25:51 -0800 (PST)
Date: Mon,  9 Nov 2026 18:25:22 +0000
In-Reply-To: <20261003212241.3432303-1-lrizzo@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261003212241.3432303-1-lrizzo@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261109182533.3594984-15-lrizzo@google.com>
Subject: [RFC PATCH v2 14/25] iommu/dma: Support decrypted PISA pages
From: Luigi Rizzo <lrizzo@google.com>
To: Luigi Rizzo <rizzo.unipi@gmail.com>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Christoph Hellwig <hch@lst.de>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: akwjemnbznjjjk3p67tq7ztfef9r8z5o
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD3A8C000E
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794248752-479822
X-HE-Meta: U2FsdGVkX1/BBVy3Vcr6AVyEBuCYa0J2gIwSviKJWjyY+rtbkwvz0lFccfIOLeXZQbKbmB7GPDedJoL0MjX+8MHabLRmebUlfvqG5+iKMUDN+EvChcXeykhMauP9IzEYmvkF0O65ixpunzMd26MFovOzNv65SAtqz47flbX9XWiZez7Eur27iBjFg6ufanuyq630si426k3BKuxEf2nmdrl0IV6SVWzlHj1p19rCuQwxX/n/c49BRf6WsgeesVdcCtAafuagAzwCxZ7iW0eRvlSKLHtXWA6PZfiUHjo3SGnfXZt7r8l5fIqY2i6dXQ9v5f20Q2kEDGTftEU9pn6Irw5EX/YNLAJcHrpsRxTHeHeo1ZQ8fbJkVU0SYAyHK9lDZuiaGqvMlWgkMM0gQR4lfFDgWMctqIhHCYS94kdnIRcqkfuh7A3VfLMffqHWOLUr3Qms5fTmgUaANC8URTajJrqL/qc3g19BTBPPcUzREH70z9wy+7+R1nWDnZ/Q0idjjEzDipjN8pZFjiFgi/qrWikaADqYoiEp6vQnXodTO+kylQSwmsa750kOmdUN4nafvi5goAvYSquKnSL9JatX8b0KGcfYOmHaowuByGbfXJKiM3pIwkdrQt5Je5ylQFzBR4RgTXQeiJAWEgAe7FljZOAYPjmFNZZy95TCY3mOqr1acK1+w8MrOZ0GzBr43m8LE2olfczDEUVGJNo/QTtUWmI9H817ooXG8l488wdGx0qoQIAjR3BTJTSDvPxVfNJAdgpFHTd9YNHfFqlQkg+QKSWeVmblqVqtIlneAGGfN7JlqxUH0si9va8+LS32G1DAvXn4dDYpgKLbv1EklnlLXUH1KfZ2qe2MCAlm82ArqhuoIB5mXVPlxvTXIinEtSedQo05CZdMvSU4npDRqaGzaZcwVwrxUb1VfdDEOBpkMyGVDRijGulAajmUlhO7Y2VOEaxZPuILQQ+Zk5URmzW
 gojP5xVL
 ruokAiNP+tzYhz66+9AxAPkkIh0a2tsuUjXQhekRSONa4AChd5TEIrcf30hzXgpFDCiZVbhaed8aiA1xeeqgGx8SBtjZFHAyrLA6kt3yp2/WeNstOeXhRV6MOmGS2nx47VKty/r+Pn9ZP2DA2+KZE//zcPYq5uH6RNnJQWM5mV/enHLggGXhidAm80Xueu8wNkxtk5E9dyp6fKzgXcQ1HkEbopF4zbsDC0+weKrmqAA/hRlUArvBbvDAJ9Xbd4+vd8RXSHvJafJYb75QRUme96stAznUxFYgebi5Bkr7Y8+tVVZRy3edupZ5dXBkSQhLhvXDqF+LiW+r4eWITvmjhJ+rBx2K6+3hoDGqFaLN+bzLG7QBbK4T1EK5kvpcH7EM9s6JQnpmX9RIJ613ycJc86IHo+k/hdLZXx823u66WYJt2Y+cZShvXL9W9SpqlPxMhqdrhjHz/U1qM/4H7So0TT8/9R2YgxMCKiiSyziR8OZ5+fwJqfpJRp6dzrQF5Wm6jItTWqcFDJBKdr+njCVVSZNfGKuOCpLjyQM8SBu5byulw7WWf/kjxdv2C0lx+UuDn3j2/OPGw4m0soMY5RumZ/rZCg3kBZ2AAQbTurUBzs+j1mmpvLxmvVeB9Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In Confidential Computing (CoCo) guests (AMD SEV-SNP, Intel TDX, ARM CCA),
guest memory is private/encrypted by default, and DMA buffers must be
converted to shared/decrypted in the host page tables before a device
can access them.

Doing that hypercall per-packet on 4KB pages is prohibitively expensive,
so guests normally bounce DMA through swiotlb. With PISA, 2MB pages are
decrypted once upfront when allocated and re-encrypted only when retired
back to the buddy allocator, avoiding both per-packet hypercalls and
bounce-buffer copies.

Add pisa.decrypt (auto-enabled when CC_ATTR_GUEST_MEM_ENCRYPT is active)
and the PISA_DECRYPTED flag to manage 2MB page decryption/re-encryption
and bypass swiotlb bouncing for decrypted PISA pages.

Signed-off-by: Luigi Rizzo <lrizzo@google.com>
---
 drivers/iommu/pisa-alloc.c | 117 ++++++++++++++++++++++++++++++++-----
 drivers/iommu/pisa-kunit.c |  11 ++++
 drivers/iommu/pisa-map.c   |   2 +-
 drivers/iommu/pisa-meta.c  |  13 +++++
 drivers/iommu/pisa-node.c  |  86 ++++++++++++++++-----------
 drivers/iommu/pisa-priv.h  |  16 ++++-
 include/linux/pisa.h       |  16 +++++
 kernel/dma/direct.c        |   5 +-
 8 files changed, 212 insertions(+), 54 deletions(-)

diff --git a/drivers/iommu/pisa-alloc.c b/drivers/iommu/pisa-alloc.c
index 7b9d0a7acc101..b4a25c65bf97e 100644
--- a/drivers/iommu/pisa-alloc.c
+++ b/drivers/iommu/pisa-alloc.c
@@ -9,6 +9,7 @@
 #include <linux/bitmap.h>
 #include <linux/bitops.h>
 #include <linux/cache.h>
+#include <linux/cc_platform.h>
 #include <linux/cpuhotplug.h>
 #include <linux/device.h>
 #include <linux/dma-direct.h>
@@ -29,6 +30,7 @@
 #include <linux/pgalloc_tag.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/mm.h>
+#include <linux/set_memory.h>
 #include <linux/shrinker.h>
 #include <linux/skbuff.h>
 #include <linux/slab.h>
@@ -49,6 +51,10 @@ static LLIST_HEAD(pisa_free_list);
 /* Dedicated WQ_MEM_RECLAIM workqueue, can run without allocations. */
 static struct workqueue_struct *pisa_wq __ro_after_init;
 
+/* Mark active PISA pages decrypted for DMA (auto-enabled on CoCo guests). */
+static bool pisa_decrypt __read_mostly;
+module_param_named(decrypt, pisa_decrypt, bool, 0444);
+
 /* Global count and ceiling on PISA pages across all allocators and reservoirs (0 = 1/8 RAM). */
 atomic_long_t pisa_nr_pages __cacheline_aligned_in_smp;
 unsigned long pisa_max_pages __read_mostly;
@@ -80,6 +86,51 @@ struct pisa_node pisa_nodes[MAX_NUMNODES] = {
 
 static void pisa_schedule_reclaim(void);
 
+/* Return true if a new PISA page should be decrypted. */
+bool pisa_want_decrypt(void)
+{
+	if (!pisa_decrypt)
+		return false;
+
+	/* Explicit page decryption is for CoCo guests, not bare-metal SME hosts. */
+	return !WARN_ON_ONCE(cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT));
+}
+
+/* Decrypt and zero a new PISA page. Must be called from sleepable context. */
+int pisa_page_prepare(struct page *page, struct pisa_meta *meta)
+{
+	void *vaddr = page_address(page);
+	int ret;
+
+	ret = set_memory_decrypted((unsigned long)vaddr, 1 << PISA_ORDER);
+	if (ret) {
+		/* Leak partially shared page rather than returning it to the buddy allocator. */
+		pr_warn_ratelimited("pisa: leaking PISA page that could not be decrypted\n");
+		return ret;
+	}
+	/* Initialize cleartext cachelines after flipping encryption state. */
+	memset(vaddr, 0, PISA_SIZE);
+	meta->flags |= PISA_DECRYPTED;
+	return 0;
+}
+
+/* Undo pisa_page_prepare(). */
+int pisa_page_unprepare(struct pisa_meta *meta)
+{
+	struct page *page;
+
+	if (!(meta->flags & PISA_DECRYPTED))
+		return 0;
+	page = pfn_to_page(pisa_meta_to_pfn(meta));
+	if (set_memory_encrypted((unsigned long)page_address(page), 1 << PISA_ORDER)) {
+		pr_warn_ratelimited("pisa: leaking PISA page that could not be re-encrypted\n");
+		return -EIO;
+	}
+	WRITE_ONCE(meta->flags, meta->flags & ~PISA_DECRYPTED);
+	return 0;
+}
+
+
 /*
  * Idle PISA page release proceeds in three stages:
  * 1. Detach onto lockless pisa_free_list and schedule pisa_reclaim_work.
@@ -103,12 +154,13 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 	spin_unlock_irqrestore(&meta->pa->lock, flags);
 	WRITE_ONCE(meta->pa, NULL);
 
-	/* Possibly still mapped by a device: leak it, still charged. */
-	if (meta->flags & PISA_QUARANTINED)
-		return;
-
 	/* The page has been unmapped from every domain by pisa_release_page() */
-	pisa_slot_free(slot);
+	if (!(meta->flags & PISA_QUARANTINED))
+		pisa_slot_free(slot);
+
+	/* Still shared with the host, or possibly still mapped by a device. */
+	if (meta->flags & (PISA_DECRYPTED | PISA_QUARANTINED))
+		return;
 	atomic_long_dec(&pisa_nr_pages);
 	for (i = 0; i < PISA_BLOCKS(order); i++) {
 		block = page + (i << order);
@@ -120,7 +172,12 @@ static void pisa_release_page_rcu(struct rcu_head *head)
 /* Unmap a retired PISA page, clear PISA_ACTIVE, and queue RCU release. */
 void pisa_release_page(struct pisa_meta *meta)
 {
+	u8 flags;
+
 	if (!meta->pa) {
+		/* Unbound (reservoir) page: leaked if re-encryption fails. */
+		if (pisa_page_unprepare(meta))
+			return;
 		__free_pages(pfn_to_page(pisa_meta_to_pfn(meta)), PISA_ORDER);
 		atomic_long_dec(&pisa_nr_pages);
 		return;
@@ -128,9 +185,15 @@ void pisa_release_page(struct pisa_meta *meta)
 
 	/* Quarantined on unmap failure and leaked in pisa_release_page_rcu(). */
 	pisa_unmap_all(meta);
+	flags = meta->flags & ~PISA_ACTIVE;
 
 	/* Clear PISA_ACTIVE before the RCU grace period so new readers stop entering. */
-	WRITE_ONCE(meta->flags, meta->flags & ~PISA_ACTIVE);
+	WRITE_ONCE(meta->flags, flags);
+	if ((flags & (PISA_DECRYPTED | PISA_QUARANTINED)) == PISA_DECRYPTED) {
+		synchronize_rcu();
+		pisa_page_unprepare(meta);
+	}
+
 	call_rcu(&meta->rcu, pisa_release_page_rcu);
 }
 
@@ -741,15 +804,16 @@ static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t gfp, in
 	unsigned int bpp = PISA_BLOCKS(order);
 	struct pisa_meta *meta;
 	struct page *page;
+	int ret;
 
 	/* __GFP_DMA/__GFP_DMA32 were already declined by pisa_alloc_bulk(). */
-	meta = pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, &clean);
+	meta = pisa_reservoir_pop(nid, gfp & ~__GFP_ZERO, pisa_want_decrypt(), &clean);
 	if (IS_ERR(meta))
 		return meta;
 
 	if (unlikely(pisa_slot_alloc(meta))) {
-		pisa_release_page(meta);
-		return ERR_PTR(-ENOSPC);
+		ret = -ENOSPC;
+		goto err_free;
 	}
 
 	page = pfn_to_page(pisa_meta_to_pfn(meta));
@@ -757,9 +821,9 @@ static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t gfp, in
 	/* Fails with -EBUSY if a concurrent PFN walker holds a speculative ref. */
 	if (split_page_compound(page, PISA_ORDER, order)) {
 		pisa_slot_free(meta->slot);
-		pisa_release_page(meta);
 		pisa_alloc_backoff(nid, can_block);
-		return ERR_PTR(-EBUSY);
+		ret = -EBUSY;
+		goto err_free;
 	}
 
 	INIT_LIST_HEAD(&meta->list);
@@ -773,6 +837,16 @@ static struct pisa_meta *pisa_alloc_split_page(unsigned int order, gfp_t gfp, in
 	}
 
 	return meta;
+
+err_free:
+	if (!can_block && (meta->flags & PISA_DECRYPTED)) {
+		/* set_memory_encrypted() may sleep; defer to reclaim worker. */
+		llist_add(&meta->llnode, &pisa_free_list);
+		pisa_schedule_reclaim();
+	} else {
+		pisa_release_page(meta);
+	}
+	return ERR_PTR(ret);
 }
 
 /* Reset fields normally cleared by prep_new_page()/post_alloc_hook(). */
@@ -1135,7 +1209,7 @@ void *pisa_alloc_coherent(struct page **pagep, struct device *dev,
 		if (!win || pisa_window_declined(win) || !(domain->pgsize_bitmap & PISA_SIZE))
 			return NULL;
 	} else if (is_swiotlb_for_alloc(dev) ||
-		   force_dma_unencrypted(dev) ||
+		   (force_dma_unencrypted(dev) && !pisa_want_decrypt()) ||
 		   !dma_coherent_ok(dev, PFN_PHYS(max_pfn) - 1, 1)) {
 		return NULL;
 	}
@@ -1294,10 +1368,15 @@ VISIBLE_IF_KUNIT unsigned long pisa_shrink_scan(struct shrinker *shrink, struct
 		read_unlock(&pisa_allocs_lock);
 	}
 
-	/* Retiring must not run under @pa->lock. */
+	/* Unmap outside locks; defer decrypted pages to workqueue outside fs_reclaim. */
 	list_for_each_entry_safe(meta, tmp, &release_list, list) {
 		list_del_init(&meta->list);
-		pisa_release_page(meta);
+		if (meta->flags & PISA_DECRYPTED) {
+			llist_add(&meta->llnode, &pisa_free_list);
+			pisa_schedule_reclaim();
+		} else {
+			pisa_release_page(meta);
+		}
 	}
 
 	/* Charge do_shrink_slab() for the full PISA pages reclaimed. */
@@ -1342,6 +1421,16 @@ static int __init pisa_init(void)
 
 	pisa_slots_init();
 
+	/*
+	 * CoCo guests require decrypted pages and cannot decrypt in atomic
+	 * context, so ensure the per-node reservoir is enabled to serve them.
+	 */
+	if (cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT)) {
+		pisa_decrypt = true;
+		if (!pisa_reservoir_max)
+			pisa_reservoir_max = 16;
+	}
+
 	/* Preallocate the supported per-node allocators. */
 	for_each_node_state(nid, N_MEMORY) {
 		for (i = 0; i < ARRAY_SIZE(cfg); i++) {
diff --git a/drivers/iommu/pisa-kunit.c b/drivers/iommu/pisa-kunit.c
index 5f6b2ebcab1d9..b63cd6585b673 100644
--- a/drivers/iommu/pisa-kunit.c
+++ b/drivers/iommu/pisa-kunit.c
@@ -63,6 +63,7 @@ static void test_meta_active_toggle(struct kunit *test)
 	unsigned long pfn, base_pfn;
 	struct pisa_meta *meta;
 	struct page *page;
+	phys_addr_t pa;
 
 	KUNIT_ASSERT_EQ(test, pisa_meta_init(), 0);
 
@@ -80,16 +81,26 @@ static void test_meta_active_toggle(struct kunit *test)
 	}
 	KUNIT_EXPECT_EQ(test, pisa_meta_ensure_pfn(pfn, false), 0);
 	meta = pisa_meta_of_pfn(pfn);
+	pa = page_to_phys(page);
 
 	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PAGE_SIZE));
 
 	pisa_meta_set_active(meta, true);
 	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn));
 	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(pfn));
 	KUNIT_EXPECT_TRUE(test, is_pisa_pfn(base_pfn + (1UL << PISA_ORDER) - 1));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PAGE_SIZE));
+	KUNIT_EXPECT_EQ(test, pisa_pte_phys(meta, pa), pa);
+
+	WRITE_ONCE(meta->flags, PISA_ACTIVE | PISA_DECRYPTED);
+	KUNIT_EXPECT_TRUE(test, is_pisa_direct(pa, PAGE_SIZE));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PISA_SIZE + PAGE_SIZE));
+	KUNIT_EXPECT_EQ(test, pisa_pte_phys(meta, pa), dma_addr_unencrypted(pa));
 
 	pisa_meta_set_active(meta, false);
 	KUNIT_EXPECT_FALSE(test, is_pisa_pfn(pfn));
+	KUNIT_EXPECT_FALSE(test, is_pisa_direct(pa, PAGE_SIZE));
 
 	__free_pages(page, PISA_ORDER);
 }
diff --git a/drivers/iommu/pisa-map.c b/drivers/iommu/pisa-map.c
index 2c481e514575c..fc58c639f3288 100644
--- a/drivers/iommu/pisa-map.c
+++ b/drivers/iommu/pisa-map.c
@@ -470,7 +470,7 @@ int __pisa_map_phys(dma_addr_t *iova, struct device *dev,
 		phys_addr_t pisa_phys = phys & PISA_MASK;
 
 		ret = iommu_map(domain, pisa_phys_to_iova(win, meta, pisa_phys),
-				pisa_phys, PISA_SIZE, block_prot, GFP_ATOMIC);
+				pisa_pte_phys(meta, pisa_phys), PISA_SIZE, block_prot, GFP_ATOMIC);
 		if (likely(!ret)) {
 			/* Ensure leaf PTE is visible before setting the domain bit. */
 			smp_mb__before_atomic();
diff --git a/drivers/iommu/pisa-meta.c b/drivers/iommu/pisa-meta.c
index 00939c366ba6d..3acdec815935f 100644
--- a/drivers/iommu/pisa-meta.c
+++ b/drivers/iommu/pisa-meta.c
@@ -78,6 +78,19 @@ struct pisa_meta *pisa_meta_of_pfn(unsigned long pfn)
 	return &pisa_meta_array[frame];
 }
 
+bool __is_pisa_direct(phys_addr_t phys, size_t size)
+{
+	u8 flags = READ_ONCE(pisa_meta_of_pfn(PHYS_PFN(phys))->flags);
+
+	/*
+	 * Only decrypted active pages can bypass swiotlb bouncing, and the
+	 * transfer must not straddle the end of the PISA frame.
+	 */
+	return (flags & (PISA_ACTIVE | PISA_DECRYPTED)) ==
+	       (PISA_ACTIVE | PISA_DECRYPTED) &&
+	       (phys & (PISA_SIZE - 1)) + size <= PISA_SIZE;
+}
+
 /* Base PFN of @meta's PISA frame, or ULONG_MAX if out-of-range/sink. */
 unsigned long pisa_meta_to_pfn(const struct pisa_meta *meta)
 {
diff --git a/drivers/iommu/pisa-node.c b/drivers/iommu/pisa-node.c
index 0f23b94a7a6f8..dfde9c021fe05 100644
--- a/drivers/iommu/pisa-node.c
+++ b/drivers/iommu/pisa-node.c
@@ -62,7 +62,7 @@ static unsigned int pisa_memalloc_save(gfp_t gfp)
 
 /* Allocate a PISA page from the buddy allocator and initialize its metadata. */
 static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
-					   bool *clean)
+					   bool decrypt, bool *clean)
 {
 	struct pisa_meta *meta;
 	unsigned int memflags;
@@ -83,6 +83,8 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 	 * must not dip into emergency reserves or trigger OOM/warnings.
 	 */
 	gfp &= ~(__GFP_COMP | __GFP_HIGHMEM | __GFP_MOVABLE);
+	if (decrypt)
+		gfp &= ~__GFP_ZERO;
 	gfp |= __GFP_NOWARN | __GFP_NOMEMALLOC | (can_block ? __GFP_RETRY_MAYFAIL : __GFP_NORETRY);
 
 	if (can_block)
@@ -101,14 +103,21 @@ static struct pisa_meta *__pisa_page_alloc(gfp_t gfp, int nid, bool can_block,
 		__free_pages(page, PISA_ORDER);
 		return ERR_PTR(-ERANGE);
 	}
-	if (can_block)
-		memalloc_flags_restore(memflags);
 
 	meta = pisa_meta_of_pfn(page_to_pfn(page));
 	memset(meta, 0, sizeof(*meta));
 
 	atomic_long_inc(&pisa_nr_pages);
-	*clean = (gfp & __GFP_ZERO) || want_init_on_alloc(0) || want_init_on_free();
+	/* On decrypt failure the page is leaked and stays charged to budget. */
+	if (decrypt && pisa_page_prepare(page, meta)) {
+		if (can_block)
+			memalloc_flags_restore(memflags);
+		return ERR_PTR(-EIO);
+	}
+	if (can_block)
+		memalloc_flags_restore(memflags);
+	*clean = (gfp & __GFP_ZERO) || (meta->flags & PISA_DECRYPTED) ||
+		 want_init_on_alloc(0) || want_init_on_free();
 
 	return meta;
 }
@@ -124,11 +133,12 @@ static void pisa_reservoir_refill_node(int nid)
 		unsigned long flags;
 		bool clean;
 
-		meta = __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true, &clean);
+		meta = __pisa_page_alloc(GFP_KERNEL | __GFP_THISNODE, nid, true,
+					 pisa_want_decrypt(), &clean);
 		if (IS_ERR(meta))
 			break;
 
-		/* init_on_alloc/init_on_free pages are already zeroed. */
+		/* Decrypted and init_on_alloc/init_on_free pages are already zeroed. */
 		if (!clean)
 			memset(page_address(pfn_to_page(pisa_meta_to_pfn(meta))), 0, PISA_SIZE);
 
@@ -145,47 +155,48 @@ static void pisa_reservoir_refill_node(int nid)
 static void pisa_reservoir_trim_node(int nid, unsigned int max)
 {
 	struct pisa_node *res = &pisa_nodes[nid];
-	struct pisa_meta *meta, *tmp;
-	LIST_HEAD(free_list);
-	unsigned long flags;
 
-	spin_lock_irqsave(&res->lock, flags);
-	while (res->nr_pages > max && !list_empty(&res->pages)) {
-		list_move(res->pages.prev, &free_list);
-		res->nr_pages--;
-	}
-	spin_unlock_irqrestore(&res->lock, flags);
+	while (res->nr_pages > max && res->nr_pages > READ_ONCE(pisa_reservoir_max)) {
+		struct pisa_meta *meta;
+		unsigned long flags;
+
+		spin_lock_irqsave(&res->lock, flags);
+		meta = list_first_entry_or_null(&res->pages, struct pisa_meta, list);
+		if (meta) {
+			list_del_init(&meta->list);
+			res->nr_pages--;
+		}
+		spin_unlock_irqrestore(&res->lock, flags);
+		if (!meta)
+			break;
 
-	list_for_each_entry_safe(meta, tmp, &free_list, list) {
-		list_del_init(&meta->list);
 		pisa_release_page(meta);
 		cond_resched();
 	}
 }
 
+/* Per-node worker: trim/refill the reservoir, then scrub allocators homed on @nid. */
 static void pisa_node_work_fn(struct work_struct *work)
 {
-	struct pisa_node *res = container_of(work, struct pisa_node, work);
-	int nid = res - pisa_nodes;
-	unsigned int max = READ_ONCE(pisa_reservoir_max);
-
-	if (unlikely(pisa_meta_init()))
-		return;
+	struct pisa_node *node = container_of(work, struct pisa_node, work);
+	int nid = node - pisa_nodes;
 
-	if (READ_ONCE(res->nr_pages) < max)
+	pisa_reservoir_trim_node(nid, READ_ONCE(pisa_reservoir_max));
+	if (READ_ONCE(pisa_reservoir_max) && static_branch_unlikely(&pisa_key))
 		pisa_reservoir_refill_node(nid);
-	else if (READ_ONCE(res->nr_pages) > max)
-		pisa_reservoir_trim_node(nid, max);
 }
 
-/* Queue @nid's reservoir worker on a CPU belonging to @nid. */
+/* Queue node @nid's work if its reservoir is below or above the target. */
 static void pisa_schedule_reservoir_node(int nid)
 {
-	if (nid >= 0 && nid < MAX_NUMNODES && node_state(nid, N_MEMORY))
-		queue_work_node(nid, system_dfl_wq, &pisa_nodes[nid].work);
+	struct pisa_node *res = &pisa_nodes[nid];
+
+	if (node_state(nid, N_MEMORY) &&
+	    READ_ONCE(res->nr_pages) != READ_ONCE(pisa_reservoir_max) &&
+	    !work_pending(&res->work))
+		queue_work_node(nid, system_dfl_wq, &res->work);
 }
 
-/* Queue reservoir refill/trim workers on all memory nodes. */
 void pisa_schedule_reservoir(void)
 {
 	int nid;
@@ -195,7 +206,7 @@ void pisa_schedule_reservoir(void)
 }
 
 /* Pop one pre-prepared PISA page from node @nid's reservoir under @res->lock. */
-static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
+static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max, bool decrypt)
 {
 	struct pisa_node *res = &pisa_nodes[nid];
 	struct pisa_meta *meta;
@@ -207,10 +218,12 @@ static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
 
 	spin_lock_irqsave(&res->lock, flags);
 	meta = list_first_entry_or_null(&res->pages, struct pisa_meta, list);
-	if (meta) {
+	if (meta && !!(meta->flags & PISA_DECRYPTED) == decrypt) {
 		list_del_init(&meta->list);
 		res->nr_pages--;
 		refill = res->nr_pages <= max / 2;
+	} else {
+		meta = NULL;
 	}
 	spin_unlock_irqrestore(&res->lock, flags);
 
@@ -224,7 +237,7 @@ static struct pisa_meta *pisa_reservoir_pop_node(int nid, unsigned int max)
  * Pop a pre-prepared PISA page from @nid's reservoir (scheduling an async
  * refill when <= half full or empty), or allocate one inline on miss.
  */
-struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
+struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *clean)
 {
 	bool can_block = gfpflags_allow_blocking(gfp);
 	unsigned int max = READ_ONCE(pisa_reservoir_max);
@@ -232,7 +245,7 @@ struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
 
 	nid = pisa_sanitize_nid(nid);
 	if (max) {
-		meta = pisa_reservoir_pop_node(nid, max);
+		meta = pisa_reservoir_pop_node(nid, max, decrypt);
 		if (meta) {
 			*clean = true;
 			return meta;
@@ -244,8 +257,11 @@ struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean)
 	/* Back off briefly on GFP_ATOMIC if previous allocation on @nid failed. */
 	if (!can_block && time_before(jiffies, READ_ONCE(pisa_nodes[nid].next_alloc)))
 		return ERR_PTR(-EAGAIN);
+	/* Page decryption may sleep; atomic callers must rely on the reservoir. */
+	if (decrypt && !can_block)
+		return ERR_PTR(-EAGAIN);
 
-	meta = __pisa_page_alloc(gfp, nid, can_block, clean);
+	meta = __pisa_page_alloc(gfp, nid, can_block, decrypt, clean);
 	if (IS_ERR(meta))
 		pisa_alloc_backoff(nid, can_block);
 	return meta;
diff --git a/drivers/iommu/pisa-priv.h b/drivers/iommu/pisa-priv.h
index 8f87bdf7d4ee2..f08388f003fad 100644
--- a/drivers/iommu/pisa-priv.h
+++ b/drivers/iommu/pisa-priv.h
@@ -7,6 +7,7 @@
 #include <linux/jiffies.h>
 #include <linux/list.h>
 #include <linux/llist.h>
+#include <linux/mem_encrypt.h>
 #include <linux/nodemask.h>
 #include <linux/spinlock.h>
 #include <linux/topology.h>
@@ -62,7 +63,7 @@ enum {
 
 /**
  * struct pisa_meta - Metadata for a single PISA page in @pisa_meta_array
- * @flags:	PISA_ACTIVE / PISA_QUARANTINED
+ * @flags:	PISA_ACTIVE / PISA_QUARANTINED / PISA_DECRYPTED
  * @prot:	Owning allocator's IOMMU_READ/WRITE protection bits
  * @nr_clean:	Zeroed available blocks in @clean_bitmap
  * @nr_dirty:	Dirty available blocks in @dirty_bitmap
@@ -101,6 +102,14 @@ struct pisa_meta {
 static_assert(offsetof(struct pisa_meta, flags) == 0);
 static_assert(sizeof(struct pisa_meta) == PISA_META_SIZE);
 
+/* Physical address for IOMMU PTE of @meta at @phys (shared alias if decrypted). */
+static inline phys_addr_t pisa_pte_phys(const struct pisa_meta *meta, phys_addr_t phys)
+{
+	if (meta->flags & PISA_DECRYPTED)
+		return dma_addr_unencrypted(phys);
+	return phys;
+}
+
 static inline unsigned int pisa_meta_avail(const struct pisa_meta *meta)
 {
 	return meta->nr_clean + meta->nr_dirty;
@@ -227,6 +236,9 @@ static inline void pisa_alloc_backoff(int nid, bool can_block)
 	if (!can_block)
 		WRITE_ONCE(pisa_nodes[nid].next_alloc, jiffies + DIV_ROUND_UP(HZ, 100));
 }
+bool pisa_want_decrypt(void);
+int pisa_page_prepare(struct page *page, struct pisa_meta *meta);
+int pisa_page_unprepare(struct pisa_meta *meta);
 
 /* pisa-alloc.c, also used by the per-node code in pisa-node.c */
 struct pisa_alloc *pisa_create(int nid, unsigned int order, enum dma_data_direction dir);
@@ -256,7 +268,7 @@ unsigned long pisa_shrink_list(spinlock_t *lock, struct list_head *list,
 extern unsigned int pisa_reservoir_max;
 void pisa_node_init(void);
 void pisa_schedule_reservoir(void);
-struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool *clean);
+struct pisa_meta *pisa_reservoir_pop(int nid, gfp_t gfp, bool decrypt, bool *clean);
 unsigned long pisa_reservoir_count(void);
 unsigned long pisa_reservoir_shrink(struct list_head *release_list, unsigned long nr_to_scan);
 
diff --git a/include/linux/pisa.h b/include/linux/pisa.h
index 822e1556d78ef..89eb0722d90bc 100644
--- a/include/linux/pisa.h
+++ b/include/linux/pisa.h
@@ -33,6 +33,7 @@ struct iommu_domain;
 enum {
 	PISA_ACTIVE		= BIT(0), /* page is owned by a pisa_alloc */
 	PISA_QUARANTINED	= BIT(1), /* IOMMU unmap failed: never reuse */
+	PISA_DECRYPTED		= BIT(2), /* page was set_memory_decrypted() */
 };
 
 /* Enabled on first pisa_meta_init() to activate fast-path hooks. */
@@ -45,6 +46,8 @@ extern unsigned long *pisa_chunk_bitmap;
 
 int pisa_meta_init(void);
 
+bool __is_pisa_direct(phys_addr_t phys, size_t size);
+
 /* fast membership check for pisa pfn/pages */
 static inline bool is_pisa_pfn(unsigned long pfn)
 {
@@ -61,6 +64,14 @@ static inline bool is_pisa_pfn(unsigned long pfn)
 	return READ_ONCE(*flags) & PISA_ACTIVE;
 }
 
+static inline bool is_pisa_direct(phys_addr_t phys, size_t size)
+{
+	if (!static_branch_unlikely(&pisa_key))
+		return false;
+
+	return __is_pisa_direct(phys, size);
+}
+
 static inline bool is_pisa_page(const struct page *page);
 
 bool __pisa_free_page(struct page *page);
@@ -133,6 +144,11 @@ static inline bool is_pisa_pfn(unsigned long pfn)
 	return false;
 }
 
+static inline bool is_pisa_direct(phys_addr_t phys, size_t size)
+{
+	return false;
+}
+
 static inline bool pisa_free_page(struct page *page)
 {
 	return false;
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 11052b65e573b..a7fa1efc0ba09 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -707,8 +707,9 @@ dma_addr_t dma_direct_map_phys(struct device *dev, phys_addr_t phys,
 	if (is_swiotlb_force_bounce(dev)) {
 		if (attrs & (DMA_ATTR_MMIO | DMA_ATTR_REQUIRE_COHERENT))
 			return DMA_MAPPING_ERROR;
-
-		return swiotlb_map(dev, phys, size, dir, attrs);
+		if (!is_pisa_direct(phys, size))
+			return swiotlb_map(dev, phys, size, dir, attrs);
+		attrs |= DMA_ATTR_CC_SHARED;
 	}
 
 	if (attrs & DMA_ATTR_CC_SHARED)
-- 
2.56.0.542.g3ef89b7020-goog


