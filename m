Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 410D6CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 18:33:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F446B0099; Tue,  6 Oct 2026 14:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 100636B009B; Tue,  6 Oct 2026 14:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0C006B009D; Tue,  6 Oct 2026 14:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C07736B0099
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 14:32:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5013EC028F
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:48 +0000 (UTC)
X-FDA: 85293047616.09.E736F9B
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A61C8000D
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 18:32:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBTM6hYQ;
	spf=pass (imf02.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791311566;
	b=JCOMqhXqz3M3AX33at2fRKLkMltO7WowpCByMjQ4uVyoN8+jcCR3DdYhUdQp2blM2CHdfb
	pUJN5ndJf+ZNHZU9faizguYS5AdfBrVVhZK7SMs6qFySnOaLdJFrUxRW/P5iGMt5onZopz
	4Jc1xHIWSJAE9RoTyEiDP3X+j+cfeho=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fBTM6hYQ;
	spf=pass (imf02.hostedemail.com: domain of griffoul@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=griffoul@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791311566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jr8aQIYF00Y8a8zgy2YM5LEShPLQDizEanjD5iCKtG0=;
	b=e6Mbim28x7BTXKr5yK3F5JEUcv2K5pmF06rz7AQSVaoB7oPApU3kjei4+Cp8yFtW0f7zMG
	atpMVmUu3ifZCuOIYCHl+6vZc3uBepHGuUF7dFda3bsQSCxQMTuDrcdkuh9edadvoFuo/m
	edMnhIsFgzJ2WWpsOXpNM6FdP0MZVmk=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c2e2007dd8bso149723866b.2
        for <linux-mm@kvack.org>; Tue, 06 Oct 2026 11:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791311565; x=1791916365; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Jr8aQIYF00Y8a8zgy2YM5LEShPLQDizEanjD5iCKtG0=;
        b=fBTM6hYQT3xJoe5cI9+teeocB8W2oAboZBKubf9RlAryGs+5ilFx/r2dSLOkB/1do1
         gq9Msb7faT8O0VE25dP8mZtZ8GaE23bhG+53LjHeIGjAr4Y5c3ms6XSyI47l9o2zuGWt
         K8y7/8Dq1aOOhyWJ/I08HbQKfPFLN50o15zEbWdWmUMbLPZIyTIjntxJdDWwQxd0SQpW
         Ht58EtRCH6P2jIg47CjZQbykQtI/Bwy3mEP+SjliUKRQMtgKBO+PQ1xkBQgHAvWduHZ9
         nHv/lYXp0jQo/eNANuTkrUMXwKS0ZTCkb4JglLxXF72AiNk58MJvXdRJIagzswlrbzS4
         35fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791311565; x=1791916365;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Jr8aQIYF00Y8a8zgy2YM5LEShPLQDizEanjD5iCKtG0=;
        b=hGjFosTfnnVojqUsZJRt+nUGRmLIs4FGXQPWdi66c0rNtSxlk4lYhFzAHucU7xnOj4
         vzZOY/aLYfmLJiFgUY2WjryLqo1zH/uMUNolXlNDnNuAICUc+K3emi/z7H9pTyjFB8B5
         KZw6vIwMIYgIcXi8voI0Rqvk21jkXdHRlB7ZUzatZQWPCPKry/Py3vhN9CRnizEkPZmb
         FXLoHY58l7YZTShBFekZYmaDcNoRgPWOwd3Smv9HKXwjiYTjAbdpvhL0nFszt/7obQhA
         6Zr7m/DSu0fql5tzo1s/NyKTuCiT6c6px/LHq4KWdG3YU0bZinhxdpK8E68kzn5b7fY+
         QCQw==
X-Forwarded-Encrypted: i=1; AKwUvBxUBv++gTYlD6VhuXcI7FHl103ss0k1Pb+LLSQhluxDHJaKW5bmOV4c0IKxEZXYKWzyAjyM9seMtg==@kvack.org
X-Gm-Message-State: AFuF++lsbbfeVE0NY3PhCbmpDMtzGDqwNlisQtZZHG0UhZozvT8ESkdd
	xcLZnk8EzSM/z2C4Kx9wS2XegoJxUEYmPYc1ySmYJ251/rLYCSe1ZvJq
X-Gm-Gg: AYBFou18esFtrDxQDxjRLlZassnNQwQCt7+tGvG3bI5F1aEfq3zer7zPzugAd9TCe7g
	lgRg070CDJ4TeIeIOsf2sy+E6q+cjzCbig8OM4EBZ1ux3KUERpSl7ZU/ImgmI+kIivk3KcHwdMb
	5HyGySx6+AJ5OlpVOXLd6G5PF0dubrzx/67z3FStjROOTm+IU4W9tPjUuqXY+n9R99l9SosbIty
	u1946YMHK6cv1j3Dxe7/kJojtS6x4YJrBeBFkjhTKY1yFzTjQsw5MxT4wS5juAlm29nE+zonXjy
	yCuGOTYfqKi3+IKXuM2SSTnLziKrRbo5LUx5EvjS+pWe8szHRUvEN/bDUeDK0rzFbRZgl5dz9U7
	USX4zXZNIBiphrn6WuzxCDAH/eV2VnpVTKuUR+1vRXQFFN7BssV7xTNfssmJ1nZotiD2cPqk4Zs
	iqO2gSx5vRH7/kggNUJr8eo7+7srEyBGgnODXwqeeTd2dax1VEyuKoLmOKZleXQYBtZUtF8dUdz
	54UxHzst9dEbgYE3JEMBUTC+vCf0m+Nd1ErNUZTQZFTlwYyMmEHwSVuq9fqoYGxmdvYKvhL1YjK
	u0zF+vrBu9EO1bYIfCNDE9UZsxBAtDCqyfodU4vMSu3Xug==
X-Received: by 2002:a17:907:5c3:b0:c2e:3124:2394 with SMTP id a640c23a62f3a-c316a0a5d98mr227739466b.41.1791311564942;
        Tue, 06 Oct 2026 11:32:44 -0700 (PDT)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c3158260f7bsm221934866b.6.2026.10.06.11.32.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Oct 2026 11:32:44 -0700 (PDT)
From: Fred Griffoul <griffoul@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Ackerley Tng <ackerleytng@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 5/9] iommufd: Map memory provider files
Date: Tue,  6 Oct 2026 18:32:31 +0000
Message-ID: <20261006183235.16576-6-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261006183235.16576-1-griffoul@gmail.com>
References: <20260720111259.122911-1-dwmw2@infradead.org>
 <20261006183235.16576-1-griffoul@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: do3c4igkwx6ppmmxnyz7yn3x7p5t5zoz
X-Rspamd-Queue-Id: 8A61C8000D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791311566-161673
X-HE-Meta: U2FsdGVkX18gV+hPDiP6hDrXhtDObEyCaVn4xTF0kbmlOflOQeqgYWsMg13QvAv6Gn8umI0pz3f6OKpMi3JY9YopgjoKXdjD5YjKSPnKjZMLhyzGIGyl/L/CoeTSM1qbE4A+pw9K0E0IPrHH5cBn/ibnAxDGmWqF0qsR0IN3pgrDKJrLrD8EIFwonazR8BBCfznGeBhJWuegvlHO86CER3EUD2ulp0y2g3h7KukCMQJLdkyr+MsLAeKPm8mf47Fm9ZCKBHwye5kcXpgDnnB48s7ix1GJy0AnV2rfWMaJja/pHkqXHm29fhmb6XPTC8560iTZzyESKiCrM4Zos4X6NxloxMxTC5I00DjCHF64yW3iDoKiTvL83Gzb9NE5+UjdYpw89wwVJ+p4Dp1qftWj7yE5EGDvgQX+sRXjIhfU/LE6gtvD10OYNgk0Umki1HzJDSU0BfM8MIfRWEkqp5MWXKWwNgQLtRgxNtPeu16b51x3AJeFW79jk0QNnmRaro9SJZrhNjsOTJdqpX0K22UvdZ9dhm/burY/5cdwuzlAm1mx5U5A52c2TSn0geUDvrR5Kg2NCBnGwspFzZdVVNDzTndGgmHtvIbIIL5zYQ5/9/hULzp157B6FPzX4XuOOa9RwRg+eqJxjeP1bTcHkw1hUHN2jKpV0LL9fQUV2J/fDK66OeDdR5LALY52iqhNF9lYnqcGbYUdKQj+/KEtqr2cjOEIJZBRm9vzrhq7EL95/h2C7OlXGaP6JCs07PzRjrjL/QkXZxAgCjFHhYVy3b+Q2Q+PC9W3W1izOtpv6ibRrSexy03MIFLAamWCfrj0+uvQaLrpM0FYEFRGxpg1coffvAWGGESicQ3I3W61S1chiuwqzw5EkhcYkRbyczRXI0SYPSDoCpXipCMpfCmULHCJXiHM8FFg/DaSe9vH0MjHlVxxoYTLo06xNpBKILmmsqVQBsKc+glveSRwkeN1J4N
 GVLwn6hw
 65Egl5GHGZj6DeNa0qdmK8KHc6m74vhhU9sUXxEgOSJWG1GiM5ZjnBFOLOMNVutQPf+eEEhWryjMQhzR50vsgik63o0LN7WXc35YTFtBjsy8T3TVF2kQOKNqujcj7uXHbsgzlOUXXhkfnya2fhY5/EDT+U6rJSzHXbyBZue9BjTsIPVVoXMKVMcTkXxUEE8DExvmCa4e4OQqCOrEjZFvZA3C0lqn/S71GWYnYq94v06relUUUsVzkr5RzJ1J1sbm91nVGUQPeYEvdDqiETfXlD77v6g19/BnfRvoKIfuuJOcmd+pkd0sXoEON7glKGpWbvBUnK24FInIjZQ4uFJhJcAAY/6c2eoX6B7wBQWCkFtrfhh72DOAgvNDbtcIBkedTsfs8E1LnDKbvC5xjS8cuQaFuAUxgc89wZu2eaF+2CNeyer3MCpZVIkOAx3q5a7XYqrzsADNK8BNpKvFX/Z0LfbheSns/U48TSqj+6WmX96We8q0ZzLHEj7xDryS6JTolFYX8rm1PCMyt9kfTeeUEbc2h6XPJww80R5ZY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Fred Griffoul <fgriffo@amazon.co.uk>

IOMMU_IOAS_MAP_FILE pins the pages it maps, which cannot work for a
memory provider file: the frames may have no struct page, and the
provider can take any of them back at any time.

Accept a provider file. iommufd neither pins nor accounts its pages.
It asks the provider for each frame when it fills a domain, and on a
revoke it unmaps the range in every domain and maps what the provider
backs now. A device that accesses the range in between faults.

Each frame gets a PAGE_SIZE entry, so a partial revoke never splits a
large IOMMU page. Holes stay unmapped, read-only pages are mapped
without IOMMU_WRITE, and MMIO pages with IOMMU_MMIO. A provider that
returns frame 0 makes the map fail with -EINVAL.

A revoke would race a dirty bitmap read and lose the dirty bits of the
range, so provider pages and a dirty tracking domain cannot share an
IOAS: whichever comes second fails with -EOPNOTSUPP. A provider
mapping cannot be split by a partial unmap, and in-kernel accesses to
it are refused.

Signed-off-by: Fred Griffoul <fgriffo@amazon.co.uk>
---
 drivers/iommu/iommufd/Kconfig        |   1 +
 drivers/iommu/iommufd/io_pagetable.c |  13 +-
 drivers/iommu/iommufd/io_pagetable.h |  23 ++-
 drivers/iommu/iommufd/pages.c        | 273 ++++++++++++++++++++++++++-
 include/uapi/linux/iommufd.h         |  11 +-
 5 files changed, 315 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
index 455bac0351f2..65d71e28c12b 100644
--- a/drivers/iommu/iommufd/Kconfig
+++ b/drivers/iommu/iommufd/Kconfig
@@ -8,6 +8,7 @@ config IOMMUFD
 	select INTERVAL_TREE
 	select INTERVAL_TREE_SPAN_ITER
 	select IOMMU_API
+	select MEM_PROVIDER
 	default n
 	help
 	  Provides /dev/iommu, the user API to control the IOMMU subsystem as
diff --git a/drivers/iommu/iommufd/io_pagetable.c b/drivers/iommu/iommufd/io_pagetable.c
index bcd531acc9dd..3eca7f4f83d3 100644
--- a/drivers/iommu/iommufd/io_pagetable.c
+++ b/drivers/iommu/iommufd/io_pagetable.c
@@ -217,6 +217,7 @@ static int iopt_insert_area(struct io_pagetable *iopt, struct iopt_area *area,
 		return -EPERM;
 
 	area->iommu_prot = iommu_prot;
+	area->provider = iopt_is_provider(pages);
 	area->page_offset = start_byte % PAGE_SIZE;
 	if (area->page_offset & (iopt->iova_alignment - 1))
 		return -EINVAL;
@@ -289,6 +290,9 @@ static int iopt_alloc_area_pages(struct io_pagetable *iopt,
 		case IOPT_ADDRESS_DMABUF:
 			start = elm->start_byte + elm->pages->dmabuf.start;
 			break;
+		case IOPT_ADDRESS_PROVIDER:
+			start = elm->start_byte + elm->pages->provider.start;
+			break;
 		}
 		rc = iopt_alloc_iova(iopt, dst_iova, start, length);
 		if (rc)
@@ -515,8 +519,13 @@ int iopt_map_file_pages(struct iommufd_ctx *ictx, struct io_pagetable *iopt,
 		if (!file)
 			return -EBADF;
 
-		pages = iopt_alloc_file_pages(file, start_byte, start, length,
-					      iommu_prot & IOMMU_WRITE);
+		/* A memory provider file, or else a memfd. */
+		pages = iopt_alloc_provider_pages(file, start, length,
+						  iommu_prot & IOMMU_WRITE);
+		if (PTR_ERR(pages) == -ENODEV)
+			pages = iopt_alloc_file_pages(file, start_byte, start,
+						      length,
+						      iommu_prot & IOMMU_WRITE);
 		fput(file);
 		if (IS_ERR(pages))
 			return PTR_ERR(pages);
diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
index 5389227eb6ff..3f65380e91d2 100644
--- a/drivers/iommu/iommufd/io_pagetable.h
+++ b/drivers/iommu/iommufd/io_pagetable.h
@@ -8,6 +8,7 @@
 #include <linux/dma-buf.h>
 #include <linux/interval_tree.h>
 #include <linux/kref.h>
+#include <linux/mem_provider.h>
 #include <linux/mutex.h>
 #include <linux/xarray.h>
 
@@ -48,6 +49,8 @@ struct iopt_area {
 	/* IOMMU_READ, IOMMU_WRITE, etc */
 	int iommu_prot;
 	bool prevent_access : 1;
+	/* The pages come from a memory provider and may have holes */
+	bool provider : 1;
 	unsigned int num_accesses;
 	unsigned int num_locks;
 };
@@ -191,6 +194,7 @@ enum iopt_address_type {
 	IOPT_ADDRESS_USER = 0,
 	IOPT_ADDRESS_FILE,
 	IOPT_ADDRESS_DMABUF,
+	IOPT_ADDRESS_PROVIDER,
 };
 
 /* An area of the pages mapped into a domain, for pages that are not pinned. */
@@ -214,6 +218,12 @@ struct iopt_pages_dmabuf {
 	bool is_cpu_ram;
 };
 
+struct iopt_pages_provider {
+	struct mem_provider_attachment att;
+	/* Byte offset in the provider file, always PAGE_SIZE aligned */
+	unsigned long start;
+};
+
 /*
  * This holds a pinned page list for multiple areas of IO address space. The
  * pages always originate from a linear chunk of userspace VA. Multiple
@@ -243,6 +253,8 @@ struct iopt_pages {
 		};
 		/* IOPT_ADDRESS_DMABUF */
 		struct iopt_pages_dmabuf dmabuf;
+		/* IOPT_ADDRESS_PROVIDER */
+		struct iopt_pages_provider provider;
 	};
 	bool writable:1;
 	u8 account_mode;
@@ -267,10 +279,15 @@ static inline bool iopt_is_dmabuf(struct iopt_pages *pages)
 	return pages->type == IOPT_ADDRESS_DMABUF;
 }
 
+static inline bool iopt_is_provider(struct iopt_pages *pages)
+{
+	return pages->type == IOPT_ADDRESS_PROVIDER;
+}
+
 /* The pages are not pinned, so their domains are tracked in pages->tracker. */
 static inline bool iopt_pages_tracked(struct iopt_pages *pages)
 {
-	return iopt_is_dmabuf(pages);
+	return iopt_is_dmabuf(pages) || iopt_is_provider(pages);
 }
 
 static inline bool iopt_dmabuf_revoked(struct iopt_pages *pages)
@@ -292,6 +309,10 @@ struct iopt_pages *iopt_alloc_dmabuf_pages(struct iommufd_ctx *ictx,
 					   unsigned long start_byte,
 					   unsigned long start,
 					   unsigned long length, bool writable);
+struct iopt_pages *iopt_alloc_provider_pages(struct file *file,
+					     unsigned long start,
+					     unsigned long length,
+					     bool writable);
 void iopt_release_pages(struct kref *kref);
 static inline void iopt_put_pages(struct iopt_pages *pages)
 {
diff --git a/drivers/iommu/iommufd/pages.c b/drivers/iommu/iommufd/pages.c
index d68f6eea836d..99c95602ac4e 100644
--- a/drivers/iommu/iommufd/pages.c
+++ b/drivers/iommu/iommufd/pages.c
@@ -52,6 +52,7 @@
 #include <linux/iommu.h>
 #include <linux/iommufd.h>
 #include <linux/kthread.h>
+#include <linux/mem_provider.h>
 #include <linux/overflow.h>
 #include <linux/slab.h>
 #include <linux/sched/mm.h>
@@ -238,6 +239,35 @@ static void iommu_unmap_nofail(struct iommu_domain *domain, unsigned long iova,
 	WARN_ON(ret != size);
 }
 
+/*
+ * Provider pages are mapped with PAGE_SIZE entries, and may have holes.  Some
+ * IOMMU drivers warn when asked to unmap an IOVA that is not mapped, so find
+ * the runs that are mapped and unmap each one, without touching the holes.
+ * iopt_provider_map() refuses frame 0, which iova_to_phys() reports for
+ * an IOVA that is not mapped.
+ */
+static void iopt_provider_unmap(struct iopt_area *area,
+				struct iommu_domain *domain,
+				unsigned long start_index,
+				unsigned long last_index)
+{
+	unsigned long iova = iopt_area_index_to_iova(area, start_index);
+	size_t left = (last_index - start_index + 1) * PAGE_SIZE;
+
+	while (left) {
+		size_t len = 0;
+
+		while (len < left && iommu_iova_to_phys(domain, iova + len))
+			len += PAGE_SIZE;
+		if (len)
+			iommu_unmap_nofail(domain, iova, len);
+		/* Step over the run and the hole page that ended it. */
+		len = min(len + PAGE_SIZE, left);
+		iova += len;
+		left -= len;
+	}
+}
+
 static void iopt_area_unmap_domain_range(struct iopt_area *area,
 					 struct iommu_domain *domain,
 					 unsigned long start_index,
@@ -245,6 +275,11 @@ static void iopt_area_unmap_domain_range(struct iopt_area *area,
 {
 	unsigned long start_iova = iopt_area_index_to_iova(area, start_index);
 
+	if (area->provider) {
+		iopt_provider_unmap(area, domain, start_index, last_index);
+		return;
+	}
+
 	iommu_unmap_nofail(domain, start_iova,
 			   iopt_area_index_to_iova_last(area, last_index) -
 				   start_iova + 1);
@@ -1357,6 +1392,10 @@ static int pfn_reader_first(struct pfn_reader *pfns, struct iopt_pages *pages,
 	    WARN_ON(last_index < start_index))
 		return -EINVAL;
 
+	/* Provider pages are read from the provider, see iopt_provider_map() */
+	if (WARN_ON(iopt_is_provider(pages)))
+		return -EINVAL;
+
 	rc = pfn_reader_init(pfns, pages, start_index, last_index);
 	if (rc)
 		return rc;
@@ -1688,6 +1727,215 @@ void iopt_pages_untrack_all_domains(struct iopt_area *area,
 	}
 }
 
+static int iopt_provider_prot(struct iopt_area *area, u32 attrs)
+{
+	int prot = area->iommu_prot;
+
+	if (attrs & MEM_PROVIDER_ATTR_READONLY)
+		prot &= ~IOMMU_WRITE;
+	if (mem_provider_type(attrs) != MEM_PROVIDER_TYPE_RAM) {
+		prot &= ~IOMMU_CACHE;
+		prot |= IOMMU_MMIO;
+	}
+	return prot;
+}
+
+/*
+ * Map what the provider backs in [start_index, last_index] of the area into
+ * @domain, and leave the holes unmapped.  Each frame is mapped with a
+ * PAGE_SIZE entry, so that a revoke of part of a large block never has to
+ * split a larger IOMMU page.  On failure nothing in the range is mapped.
+ */
+static int iopt_provider_map(struct iopt_area *area, struct iopt_pages *pages,
+			     struct iommu_domain *domain,
+			     unsigned long start_index,
+			     unsigned long last_index)
+{
+	unsigned long base = pages->provider.start >> PAGE_SHIFT;
+	unsigned long index = start_index;
+	int rc;
+
+	lockdep_assert_held(&pages->mutex);
+
+	if ((1UL << __ffs(domain->pgsize_bitmap)) > PAGE_SIZE)
+		return -EOPNOTSUPP;
+
+	/*
+	 * A revoke unmaps under pages->mutex only, so it would race with a
+	 * dirty bitmap read, and lose the dirty bits of what it unmaps.
+	 * Provider pages are not mapped in a domain with dirty tracking.
+	 */
+	if (domain->dirty_ops)
+		return -EOPNOTSUPP;
+
+	while (index <= last_index) {
+		unsigned long pfn, iova, block_end, nr, i;
+		int order = PUD_ORDER;
+		u32 attrs;
+		int prot;
+
+		rc = mem_provider_get_page(&pages->provider.att, base + index,
+					   &pfn, &order, &attrs);
+		if (rc == -EFAULT) {
+			index++;
+			continue;
+		}
+		/* Frame 0 would look unmapped to iopt_provider_unmap(). */
+		if (!rc && !pfn)
+			rc = -EINVAL;
+		if (rc)
+			goto err_unmap;
+
+		block_end = ALIGN_DOWN(base + index, 1UL << order) +
+			    (1UL << order) - base;
+		nr = min(block_end, last_index + 1) - index;
+		iova = iopt_area_index_to_iova(area, index);
+		prot = iopt_provider_prot(area, attrs);
+
+		for (i = 0; i < nr; i++) {
+			rc = iommu_map_nosync(domain, iova + i * PAGE_SIZE,
+					      PFN_PHYS(pfn + i), PAGE_SIZE, prot,
+					      GFP_KERNEL_ACCOUNT);
+			if (rc)
+				break;
+		}
+		if (i) {
+			int sync_rc = iommu_sync_map(domain, iova, i * PAGE_SIZE);
+
+			if (!rc)
+				rc = sync_rc;
+		}
+		index += i;
+		if (rc)
+			goto err_unmap;
+	}
+	return 0;
+
+err_unmap:
+	if (index > start_index)
+		iopt_provider_unmap(area, domain, start_index, index - 1);
+	return rc;
+}
+
+/* Map the whole area into every domain of its io_pagetable. */
+static int iopt_provider_fill_domains(struct iopt_area *area,
+				      struct iopt_pages *pages)
+{
+	struct iommu_domain *domain, *undo;
+	unsigned long index, undo_index;
+	int rc;
+
+	xa_for_each(&area->iopt->domains, index, domain) {
+		rc = iopt_provider_map(area, pages, domain,
+				       iopt_area_index(area),
+				       iopt_area_last_index(area));
+		if (rc)
+			goto err_unmap;
+	}
+	return 0;
+
+err_unmap:
+	xa_for_each(&area->iopt->domains, undo_index, undo) {
+		if (undo_index >= index)
+			break;
+		iopt_provider_unmap(area, undo, iopt_area_index(area),
+				    iopt_area_last_index(area));
+	}
+	return rc;
+}
+
+/*
+ * The provider changed the frames behind [offset, offset + len).  In every
+ * domain, unmap the range and map what the provider backs now.  A device that
+ * accesses the range in between faults.
+ */
+static void iopt_provider_revoke(struct mem_provider_attachment *att,
+				 loff_t offset, loff_t len)
+{
+	struct iopt_pages *pages =
+		container_of(att, struct iopt_pages, provider.att);
+	u64 start = pages->provider.start;
+	u64 end = start + (u64)pages->npages * PAGE_SIZE;
+	struct iopt_pages_track *track;
+	unsigned long first, last;
+
+	if (offset < 0 || len <= 0 || offset >= end || offset + len <= start)
+		return;
+	first = (max_t(u64, offset, start) - start) >> PAGE_SHIFT;
+	last = (min_t(u64, offset + len, end) - start - 1) >> PAGE_SHIFT;
+
+	guard(mutex)(&pages->mutex);
+	list_for_each_entry(track, &pages->tracker, elm) {
+		struct iopt_area *area = track->area;
+		unsigned long s = max(first, iopt_area_index(area));
+		unsigned long l = min(last, iopt_area_last_index(area));
+
+		if (s > l)
+			continue;
+		iopt_provider_unmap(area, track->domain, s, l);
+		if (iopt_provider_map(area, pages, track->domain, s, l))
+			pr_warn_ratelimited("iommufd: cannot map provider pages after a revoke\n");
+	}
+}
+
+/**
+ * iopt_alloc_provider_pages() - Pages backed by a memory provider file
+ * @file: The provider file
+ * @start: Byte offset in the file, PAGE_SIZE aligned
+ * @length: Number of bytes
+ * @writable: The pages may be mapped writable
+ *
+ * The pages are not pinned.  The provider can change the frames behind them
+ * at any time, and every domain that maps them follows.
+ *
+ * Return: the pages, ERR_PTR(-ENODEV) if @file is not a provider file,
+ * ERR_PTR(-EINVAL) if @start is not page aligned, or another ERR_PTR().
+ */
+struct iopt_pages *iopt_alloc_provider_pages(struct file *file,
+					     unsigned long start,
+					     unsigned long length,
+					     bool writable)
+{
+	static struct lock_class_key pages_provider_mutex_key;
+	struct iopt_pages *pages;
+	int rc;
+
+	if (length / PAGE_SIZE >= MAX_NPFNS)
+		return ERR_PTR(-EINVAL);
+
+	pages = iopt_alloc_pages(0, length, writable);
+	if (IS_ERR(pages))
+		return pages;
+
+	/*
+	 * The pages mutex of provider pages is never held while taking the
+	 * mmap_lock, but is taken from the provider's revoke.  Split the lock
+	 * class from the pinned pages.
+	 */
+	lockdep_set_class(&pages->mutex, &pages_provider_mutex_key);
+
+	/* Provider pages are not pinned, so they are not accounted. */
+	pages->account_mode = IOPT_PAGES_ACCOUNT_NONE;
+	pages->type = IOPT_ADDRESS_PROVIDER;
+	pages->provider.start = start;
+
+	/*
+	 * The provider must cover the whole mapping, so the size is its end.
+	 * Check the alignment only once the file is known to be a provider
+	 * file: on -ENODEV the caller maps it as a memfd, which may start
+	 * anywhere.
+	 */
+	rc = mem_provider_attach(&pages->provider.att, file, start + length,
+				 iopt_provider_revoke);
+	if (!rc && !PAGE_ALIGNED(start))
+		rc = -EINVAL;
+	if (rc) {
+		iopt_put_pages(pages);
+		return ERR_PTR(rc);
+	}
+	return pages;
+}
+
 void iopt_release_pages(struct kref *kref)
 {
 	struct iopt_pages *pages = container_of(kref, struct iopt_pages, kref);
@@ -1705,6 +1953,8 @@ void iopt_release_pages(struct kref *kref)
 		dma_resv_unlock(dmabuf->resv);
 		dma_buf_detach(dmabuf, pages->dmabuf.attach);
 		dma_buf_put(dmabuf);
+	} else if (iopt_is_provider(pages)) {
+		mem_provider_detach(&pages->provider.att);
 	} else if (pages->type == IOPT_ADDRESS_FILE) {
 		fput(pages->file);
 	}
@@ -1855,6 +2105,12 @@ static void iopt_area_unfill_partial_domain(struct iopt_area *area,
  */
 void iopt_area_unmap_domain(struct iopt_area *area, struct iommu_domain *domain)
 {
+	if (area->provider) {
+		iopt_provider_unmap(area, domain, iopt_area_index(area),
+				    iopt_area_last_index(area));
+		return;
+	}
+
 	iommu_unmap_nofail(domain, iopt_area_iova(area),
 			   iopt_area_length(area));
 }
@@ -1898,6 +2154,11 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
 	if (iopt_dmabuf_revoked(area->pages))
 		return 0;
 
+	if (iopt_is_provider(area->pages))
+		return iopt_provider_map(area, area->pages, domain,
+					 iopt_area_index(area),
+					 iopt_area_last_index(area));
+
 	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
 			      iopt_area_last_index(area));
 	if (rc)
@@ -1963,7 +2224,11 @@ int iopt_area_fill_domains(struct iopt_area *area, struct iopt_pages *pages)
 			goto out_unlock;
 	}
 
-	if (!iopt_dmabuf_revoked(pages)) {
+	if (iopt_is_provider(pages)) {
+		rc = iopt_provider_fill_domains(area, pages);
+		if (rc)
+			goto out_untrack;
+	} else if (!iopt_dmabuf_revoked(pages)) {
 		rc = pfn_reader_first(&pfns, pages, iopt_area_index(area),
 				      iopt_area_last_index(area));
 		if (rc)
@@ -2402,7 +2667,7 @@ int iopt_pages_rw_access(struct iopt_pages *pages, unsigned long start_byte,
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
-	if (iopt_is_dmabuf(pages))
+	if (iopt_is_dmabuf(pages) || iopt_is_provider(pages))
 		return -EINVAL;
 
 	if (pages->type != IOPT_ADDRESS_USER)
@@ -2491,6 +2756,10 @@ int iopt_area_add_access(struct iopt_area *area, unsigned long start_index,
 	if ((flags & IOMMUFD_ACCESS_RW_WRITE) && !pages->writable)
 		return -EPERM;
 
+	/* Provider frames may have no struct page, and are not pinned. */
+	if (iopt_is_provider(pages))
+		return -EOPNOTSUPP;
+
 	mutex_lock(&pages->mutex);
 	access = iopt_pages_get_exact_access(pages, start_index, last_index);
 	if (access) {
diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
index 0425d452d41e..b4500fc21368 100644
--- a/include/uapi/linux/iommufd.h
+++ b/include/uapi/linux/iommufd.h
@@ -224,7 +224,7 @@ struct iommu_ioas_map {
  * @size: sizeof(struct iommu_ioas_map_file)
  * @flags: same as for iommu_ioas_map
  * @ioas_id: same as for iommu_ioas_map
- * @fd: the memfd or supported dma-buf file to map
+ * @fd: the memfd, memory provider file or supported dma-buf file to map
  * @start: byte offset from start of the file to map from
  * @length: same as for iommu_ioas_map
  * @iova: same as for iommu_ioas_map
@@ -235,6 +235,15 @@ struct iommu_ioas_map {
  * VFIO PCI dma-bufs exported through VFIO_DEVICE_FEATURE_DMA_BUF, and
  * other dma-bufs may be rejected. All other arguments and semantics match
  * those of IOMMU_IOAS_MAP.
+ *
+ * A file from a memory provider is also accepted; @start must then be
+ * page aligned. Its pages are not pinned. The provider may change the memory
+ * behind any range at any time, and the mapping follows: pages that the
+ * provider does not back are left unmapped, read-only pages are mapped
+ * without write permission, and device memory is mapped as MMIO. A device
+ * access to a page that is being changed, or that is not backed, faults. Such
+ * a mapping cannot be split by a partial unmap, and in-kernel accesses to it
+ * are refused. It is not supported in an IOAS with a dirty tracking domain.
  */
 struct iommu_ioas_map_file {
 	__u32 size;

