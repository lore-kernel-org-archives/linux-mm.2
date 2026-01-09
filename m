Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60CD6D26D7B
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:18:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C70736B0092; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C62D46B0093; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3D936B0095; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D2366B0092
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:18:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72DA713B1CC
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:18 +0000 (UTC)
X-FDA: 84313083876.30.80D5161
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0CECA0013
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UQrnVY+Z;
	spf=pass (imf15.hostedemail.com: domain of 3VzhhaQgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VzhhaQgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979096; a=rsa-sha256;
	cv=none;
	b=DYFPxfjxQvTcvbPWzmkFO6ZSUU61X3GvSmTqNnKIZJ7oxjO/C2E628fWDW5i3+PlPtpZll
	SRk8WAm27IC1XbvkdkXSsZWcDxnGlsSHdaOsDE8sizkeukF/2yR/3cEbudg7rsHSCOYsDA
	msepe9v36O3aB3En8RIKfEq3NWU7j38=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UQrnVY+Z;
	spf=pass (imf15.hostedemail.com: domain of 3VzhhaQgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VzhhaQgKCJ4QKMQR8D8EMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rXKfhlVn2c+6UG0/zcj6FymOVg8M3bXQ+ReLnrZOk7w=;
	b=JOIGdIdQpkSLTRfDhpJYSv4Ra2ffUWylujYkL8HRQYPuFRRtEgoYEj/J4bdxBsniVTIbfy
	dXsmGwkUXZlc1V05OTC4PoE1Fkfzg0x1Jm0kCh/SlAuI8cful7NEa/Z6vKB0ea7lS5QyBY
	O74Bp9zFMMGXDvdajLY02KJ5rtE2hR4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4775f51ce36so40061185e9.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:18:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767979095; x=1768583895; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rXKfhlVn2c+6UG0/zcj6FymOVg8M3bXQ+ReLnrZOk7w=;
        b=UQrnVY+ZfZvXLfrtoJvMZ+BMQKJRpkvA5LZEBTnc5Ws6HiNwPmspzMDVtOuB+cSQTP
         vFjSMFH3+0ck5dyv1To3DmI9ddnHCqfclx48LpXDud9QLnq4KJYiA4BF20qrC7E2Bvcq
         7a/JcuQWzJon2OFhWXj09eZP5eKi0I77D2q6Gw0iXNd8pdVMx0xPXuapbhAfnpJtjcUm
         GUkAN/ZhxTqT9147psGbdrsbXvkmLveZPsM0h6eMpJkcOo9DLNbU7tqQ6qzb97YXJUff
         n5kDUoUc6hs1qkbZTqdL3rwOn/3iydKgpg8L4/m6GyBcZFu6OcbPFTIWX5VKCYJXmFO0
         Hojg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979095; x=1768583895;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rXKfhlVn2c+6UG0/zcj6FymOVg8M3bXQ+ReLnrZOk7w=;
        b=jeLQgRAlDUVfE5EBhmHT4/N+r7F0uMgdbF4IWX2Bib8GNAt3lZHrofM9oQ4MOlCPlK
         Bt15y5qG+tfhzFPwDQAksRKv/PTMYGZwnJfWMu5CZaLGtCdjuYfCRM0fC+DD8/eEhpB5
         ZsK6dygx8igp8dxQSK30ViIpknCzS4VvAUxZRZxX7YT+XciU7Cwt+a908qx8LcPX4g09
         RiV4CyEURicWEjLWM4CiFz7mXffyR3JXbgWdi+4sRMDCzF4Ks4DFamkd1xvom/Abd+wE
         8fkMwX/mYmywJ60rSgpPvOIhkQLEMM/cvHMDUzmI/FSdWrCgxIudlINM03kPD8PIUqw7
         XQiQ==
X-Gm-Message-State: AOJu0YwM908wlYGT0iXgqZakzPny9AscYlGHvJxnnkjmiRiiu62sSsbE
	oYeAgR4hL1BwjL2VaWBUC4ZiJVNycthNGroVMLLF8ovB648R6w7/0ffAOYBvtg2dyCgqYtcUvfq
	ZH4zVfNgrPo8Th+8r/vSXJH0vASemCgWFmgcivWpomkF4YS2cLStLruGUylIBLPRsKlgD0u0HTm
	szDO4aKgDGuIg9vRuGcX52+NfMhvURVJ2tCiADvuvQuA==
X-Google-Smtp-Source: AGHT+IFk02O2PK0We+1RMI+gkP8sH7Gfm0sE0Pyah5F14OonFiV3bx+oHBAF9FOQ2GaQcAwCLdJfSABlkCnRwQ==
X-Received: from wmbdx10.prod.google.com ([2002:a05:600c:63ca:b0:477:3fdf:4c24])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:46c4:b0:47d:403e:4eaf with SMTP id 5b1f17b1804b1-47d84b18ef7mr134197875e9.10.1767979095241;
 Fri, 09 Jan 2026 09:18:15 -0800 (PST)
Date: Fri,  9 Jan 2026 17:18:04 +0000
In-Reply-To: <20260109171805.901995-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260109171805.901995-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109171805.901995-4-smostafa@google.com>
Subject: [PATCH v6 3/4] iommu: debug-pagealloc: Track IOMMU pages
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 4fxm8xjbkbqt7jbzyzykyoj5khjsymmi
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A0CECA0013
X-Rspam-User: 
X-HE-Tag: 1767979096-147616
X-HE-Meta: U2FsdGVkX1+JqyV2hDcyFy/TE5vdFGnhJmlBI453ZiQrSpNSxHRkA+KPSQey/IEU7eE66Bm/iHzfX6Mc0ZCyR584EuTK6VjmCgOtwyohMUOkwHD3zjVmSTvydAudUjBP7idqH+U8RVeq1V5oWObVneX7ZotRCgeHbozsD0u6E/5ywRo4I0iXN/Ul+s76p97qu/ii54YOCf34FT17Y8Z4mp3bR0iLcS2J+dYLIa8gqWRoMX0QjXx7qP4s4TklAz3BtSdRXBKB+8nHR5n/Ti49rR6iyoKP79OfVORcq4mQHbt+KZZNRm7l1HIqXZfWjb2uUitApAplzHTt7+vqdSCbiJeBdyFy7FgtXUB12MWiCvFpc1DMDqdkwvSKqLXcKC+JMeyCmBnI7KZvVWljbJm4lRz5eEC7Lv7c+Qb6sWOGjmes+Bqr99MJo7wrP/OCKNG0SNl9NW7aSVQWYcQZHFL6qxXB0IwptNywD8z+/I4uMkihxSUYCGpgGAw3Qt49sJBTkb43zkg9dGflv78yQZoxrakup6SkI4ijammsFuGQBNOKuSpSU0SF/w3LMI6HuH0bGKrAAMbd5KW4EjCZmEQvLfvfjfEj7Mu8O1Lw5ZAGxAittPr4idlQbnnZnKkhEolh74lwMW4+OkJqpzM1AGEYinQm1c2qhvPtSbTle/RCNpxoIqm1gBp3NPdh5Gz5LG188eh/lJ/pGPKqHzph2q25c9M5pH2KXjbQAFBddT2z1HYuWnCNCvSGHmBHDZ4c5Wg4DOZ7cXR3AYKoOvnvBY+2RFzmq0jp8LvmxMEsOZj6zzq7gyQXi7jok4u1jD5Qx7cGCXmtJfQfu9GimyePby8XkeAf6ugcOkeretNJvPH+DNBVBFCkOyR4caQCHLDWGyNI5jHIS/AAXaqNX7HompvvmwLtVhTYQO9igC1hNdMklNoIhEq6K/uWJjP5buX9tUeG8moNKZ84PZTRZnp7Ljd
 cRw2LyOJ
 cso/m0CfbxiD87IGDWuqayBpaHboXNoijJcHCJUO2nb1xm8A9DgkTcnxCtKUizi3WDH5ucPBHdgQPcklrDkNmal4z2+YmJBc7yVcbDBvCslBV8nj77L+0nSrJky4it3gPhTki9yn0d81JCPlFZL4RgEFtwNv22hwvIJcuTjnofVva+xxgLhaTHHWVc6b/qmCmHzIFfmAEQJ13orrRKWDj+VycCNS/u7pF+CmOfa881spiKyAQ0EYcGkQAmo3JOgnt16KnThI5lTS948lmkO9/Kf9ZCAFAQ8J8KReblFIa9HIMWsIqlCMQZkJxlnbSTGpQNKKkkzipuUsykim3buAxPXX3fSXJPafldE+ZP+SOJb04PKqmsp0XBD4EYqQbjPzcklcscl0IrSSWPnMpjPx5xzzdCVWZlWdMvbR5eJm0fgAvpxZx4CGw1dwUj+uKv3XnoO/cTZOxn7V0tazkEnHpFdGatFIOLcDgq6sQrpOa4lMiolGyzZF65ACcTHtqkV0CueXzQxrrxh0GzQI8Axp22BpmXFNB5hg2gzDuUpm3xuyOMwCL5sFN4TSkiCTPitQknP0CD+9FhI4AeaE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Using the new calls, use an atomic refcount to track how many times
a page is mapped in any of the IOMMUs.

For unmap we need to use iova_to_phys() to get the physical address
of the pages.

We use the smallest supported page size as the granularity of tracking
per domain.
This is important as it is possible to map pages and unmap them with
larger sizes (as in map_sg()) cases.

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/iommu-debug-pagealloc.c | 84 +++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/iommu/iommu-debug-pagealloc.c b/drivers/iommu/iommu-debug-pagealloc.c
index 1d343421da98..9eb49e1230ee 100644
--- a/drivers/iommu/iommu-debug-pagealloc.c
+++ b/drivers/iommu/iommu-debug-pagealloc.c
@@ -29,19 +29,103 @@ struct page_ext_operations page_iommu_debug_ops = {
 	.need = need_iommu_debug,
 };
 
+static struct page_ext *get_iommu_page_ext(phys_addr_t phys)
+{
+	struct page *page = phys_to_page(phys);
+	struct page_ext *page_ext = page_ext_get(page);
+
+	return page_ext;
+}
+
+static struct iommu_debug_metadata *get_iommu_data(struct page_ext *page_ext)
+{
+	return page_ext_data(page_ext, &page_iommu_debug_ops);
+}
+
+static void iommu_debug_inc_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_inc_return_relaxed(&d->ref) <= 0);
+	page_ext_put(page_ext);
+}
+
+static void iommu_debug_dec_page(phys_addr_t phys)
+{
+	struct page_ext *page_ext = get_iommu_page_ext(phys);
+	struct iommu_debug_metadata *d = get_iommu_data(page_ext);
+
+	WARN_ON(atomic_dec_return_relaxed(&d->ref) < 0);
+	page_ext_put(page_ext);
+}
+
+/*
+ * IOMMU page size doesn't have to match the CPU page size. So, we use
+ * the smallest IOMMU page size to refcount the pages in the vmemmap.
+ * That is important as both map and unmap has to use the same page size
+ * to update the refcount to avoid double counting the same page.
+ * And as we can't know from iommu_unmap() what was the original page size
+ * used for map, we just use the minimum supported one for both.
+ */
+static size_t iommu_debug_page_size(struct iommu_domain *domain)
+{
+	return 1UL << __ffs(domain->pgsize_bitmap);
+}
+
 void __iommu_debug_map(struct iommu_domain *domain, phys_addr_t phys, size_t size)
 {
+	size_t off, end;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (WARN_ON(!phys || check_add_overflow(phys, size, &end)))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		if (!pfn_valid(__phys_to_pfn(phys + off)))
+			continue;
+		iommu_debug_inc_page(phys + off);
+	}
+}
+
+static void __iommu_debug_update_iova(struct iommu_domain *domain,
+				      unsigned long iova, size_t size, bool inc)
+{
+	size_t off, end;
+	size_t page_size = iommu_debug_page_size(domain);
+
+	if (WARN_ON(check_add_overflow(iova, size, &end)))
+		return;
+
+	for (off = 0 ; off < size ; off += page_size) {
+		phys_addr_t phys = iommu_iova_to_phys(domain, iova + off);
+
+		if (!phys || !pfn_valid(__phys_to_pfn(phys)))
+			continue;
+
+		if (inc)
+			iommu_debug_inc_page(phys);
+		else
+			iommu_debug_dec_page(phys);
+	}
 }
 
 void __iommu_debug_unmap_begin(struct iommu_domain *domain,
 			       unsigned long iova, size_t size)
 {
+	__iommu_debug_update_iova(domain, iova, size, false);
 }
 
 void __iommu_debug_unmap_end(struct iommu_domain *domain,
 			     unsigned long iova, size_t size,
 			     size_t unmapped)
 {
+	if ((unmapped == size) || WARN_ON_ONCE(unmapped > size))
+		return;
+
+	/* If unmap failed, re-increment the refcount. */
+	__iommu_debug_update_iova(domain, iova + unmapped,
+				  size - unmapped, true);
 }
 
 void iommu_debug_init(void)
-- 
2.52.0.457.g6b5491de43-goog


