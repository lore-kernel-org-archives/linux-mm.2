Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E58B2CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B32538E001A; Tue, 21 Oct 2025 11:00:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2A78E0002; Tue, 21 Oct 2025 11:00:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936338E001A; Tue, 21 Oct 2025 11:00:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 833F58E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:00:54 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 29DF41605A1
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:54 +0000 (UTC)
X-FDA: 84022433628.11.82EB7BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 957258001D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:00:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WZQkBItp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058851; a=rsa-sha256;
	cv=none;
	b=pjwTPplBT3SbzBafuvfR36FqUQfvySO/1oqHuvpLcIuCDg1GPcuVmJdToTDvHUi4vEwlMW
	vZi4dnfW5fDSl/neASVmhXvPUJuKYs9QGUqwHO6z0ybhjrfvQb3EGbxlnWMKZ6oEp8yRkH
	keD2PS9w4oJEFA8SHgKBAduq95GnH+I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WZQkBItp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WXJD5DBTOSdH4OFa5cGG6Bl5vxCoyITjfVMpwdlj+A=;
	b=Vfb2NIYNH5/22GDwP0TbDR2mIbjQcLKmlJ82omF852hknO5vu4mUQbDUBavrrrUkkMEMan
	P9jfAGIZcxQ79d5q7piwV8IG9H2kbks/Krr9m+v5dNdh5EhBpWID8Uxq+Tt4bE2Gcchz+l
	tqSxqeI3nZ3X6KDnhndOJnbFSA7G8ug=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761058851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0WXJD5DBTOSdH4OFa5cGG6Bl5vxCoyITjfVMpwdlj+A=;
	b=WZQkBItp/tYM0eTzKePzZALwW10sAf9xw0wHnhVaULE+WiUuWgL+jhm9aaLUrZGoVpZUM3
	ZQ0p3m9hA++lYj7LlLArhQ4vxskz+B0hiLKKHt6W161S0XQOuQ+8x2246nV5ndlFDnTiFt
	Ebgt2Do/6H8DHFZOgE8HQIXniIUuAeo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-npDfKMsaNzKaMu2wm6vIiw-1; Tue, 21 Oct 2025 11:00:49 -0400
X-MC-Unique: npDfKMsaNzKaMu2wm6vIiw-1
X-Mimecast-MFC-AGG-ID: npDfKMsaNzKaMu2wm6vIiw_1761058848
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-427a125c925so2565597f8f.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:00:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058848; x=1761663648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WXJD5DBTOSdH4OFa5cGG6Bl5vxCoyITjfVMpwdlj+A=;
        b=qAFfo8tv93bAxiejCYAeaETQ08HALlU1Ucdq/3hmxAcnfqQN4cV2fp4GTGCytbOglE
         B2oR+Rxa7airQyoM5lYgQ3Sb5T88svraLAQkWpvnCI+OtljrHC2N8yrIwP1t9x0bpNEE
         d/uRk0ivBYQTSoo1wv61fO3STQ58mrjv8eGtKiB46MMBizapXohj1ezDoSZYOU04iUQ8
         rpeEsEJIIJmUG1u6an+QOSyEKi1/DL3MlBwjpok198JJqZLErDldksajVyq0zdEJ0bpc
         2aljAJ8MMziVrK3oE8OhX3SqBQzuqhctDYRrSGspCz4O5PEpDZX5eYtLJv9WoeaK/gw5
         wKUw==
X-Gm-Message-State: AOJu0Yx0bcqIsoFfeCwqy5VAGzUJVEw7cxpYaaQRXrIg96kLzfCYp+mO
	/fsJkXKS0yjJwKZ/o2hImpLpxDoeuURMthjPByCFx+4CVQ8t3peBu0TFXSB8bhAeB45CNwPAYta
	1a/eMVGzdCXIxX+9N9CPSvbm8tj6A54IAZTWhdZSZA8crl8qe1ERB
X-Gm-Gg: ASbGncu+zd+/n5qM/DlqWfecvs1+Nf2HN+MnJpSb4h6On4jU4AuiUbaSJB07evd3hHB
	9QipwiYT5wmYPnlzj66+kGAdALRubetLar1JtkFqFLbUROM0nL450aFkNaECdZBb+PfOywZf+xy
	Rep4ly9Sxl5BuFFe1uTkT7i6//dC+UfDGVCFrUxGXBFcKHxclBH/EABXZUHCZ/lS67CWIdpbN5+
	BMzXkwRt/Y2rkMn4h9m37FylSzFGE5imSkZiIwL6UBqh2K+X5j1Y13SVkNZFFanWZIJ/nEt85VG
	0z/m4yk3L5k9N5o8t0oB2nOpax6nWM5si3prBDiTOfDqEfLybrZurC8Z2XqPCy4jQv1sqrxZhbE
	Gm8VKgLhd8fGXi3+Kss/NL+zsie01DJoNO/PxuZ8/n9Q4biantfpMtZ1YaQs3
X-Received: by 2002:a05:600c:4e89:b0:46f:b42e:e392 with SMTP id 5b1f17b1804b1-47117931c1dmr117960435e9.39.1761058848042;
        Tue, 21 Oct 2025 08:00:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGDebz8te/SdK4RMl9FXThAzS3UlvHbYsiUZ1AXYYoG1U9LkInArDMPFE9fh7553nINZVhlvg==
X-Received: by 2002:a05:600c:4e89:b0:46f:b42e:e392 with SMTP id 5b1f17b1804b1-47117931c1dmr117959965e9.39.1761058847485;
        Tue, 21 Oct 2025 08:00:47 -0700 (PDT)
Received: from localhost (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-471144b5c91sm283508025e9.11.2025.10.21.08.00.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:00:47 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 19/23] mm: rename balloon_compaction.(c|h) to balloon.(c|h)
Date: Tue, 21 Oct 2025 17:00:36 +0200
Message-ID: <20251021150040.498160-3-david@redhat.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021150040.498160-1-david@redhat.com>
References: <20251021125929.377194-1-david@redhat.com>
 <20251021150040.498160-1-david@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1BgcY0i5gIzqA9-5SqrbCSVWBmeU4fyn_3p2gWUSOxQ_1761058848
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: d6dyfkbysfxzyps713btzdy8pxpqijju
X-Rspamd-Queue-Id: 957258001D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761058851-931612
X-HE-Meta: U2FsdGVkX1/+KMZTL3F+IEK5G7Fj+7HhioAoFOGYfz+kIG4ynf1XhDvj74oPgHMMdRFnVWjfxsbR0IXtGSvI8sKtVOTq5piUB45FbL8/8c0/MsVCDJGpEf2K7zhXMhDpiyPwgBDlqPIizh9KKTtqkD1EO+0sTMWYrKLc6COSgNLDCo3edcYfv/9UGBrsT98UGfMAXR1y1x7pJjb2WGb5bhNPNpcukwBM4pwR4aVZLRO/YPGxEoxPOqFIt2eZONqxqJrqlmoCx5LnsnCD7jllFgPDfY4AlPFJUFP4XAx3ROuXB82f5Y1MvDcnAcaRV7Uy6uJCWLZf8WuzghL4mu+0Ao6nwe1lLzc6VSOdt9D9v2OJDz+y5mNS73pirQSh2mNliLwjnY5GdLWLZVDsnGweUmyPfMpud2Y6aVoRSLJ8Y3ZVxXhnY0U5pO+9mZaz6MCkkXrkVqPmI7Metk87XmaPrBI3SIFpcWz2bhnmi6JZyPOAEhNMGay3GfzdcXpDEX5vTRqsFrVCiXMOmdfr5FWN1dxWIMVRuzrqsZmGyeqOKUcWkU/vXiuGHn8omnze7qTnL7R8RrcYIjfKzP/6r4OWUry5uzJ8tnSaYmG3YFZ1XrlmE1W6XBvdwEJCscNI3Ueu6wfvFmHCC5QAHWUzhgMDxn2aPP/NXuC977MRPd+D2FqsiYnDilNVDLNbF72J5VeAW7+ioRqx3FYKYnUXClV/lxU/F1t3Q7m2yTygVeMViQKm4wfEbLIkxXV7UlDNcYSoB+5iUIdgkrtIWVV6HuAdyHq/Qa3aT/h9rwxmSCGg2kybHbpQDDeYJORgBFPb6Ddkv/DQBoYhJF+9608glgeD/i/4s3QP2sqnzub4Z0RWyEwzvJwbQRL4wfZVubjPUtZlqL3GlPKIjp9Fx+aE6h+ED97brUvMIuZGd6cJuSxywPYlxPctiCzyN4jM/5IdZQyrkhXfyDU7V7YCVNtwbfC
 k34Jlv/G
 iYKCuOjFKwy+6FGmIjbWTGSCwlZBm2fLQzrmuLXd9PIJmUCvhNQLsEU8WEvg9va06iWSy8r0YV8aqp+2k7mWEnt5QCXNw289hRjmK3gbO+JKuwzZBTMdiNbqENhgM7YOI0+lDXPBZiMqBrBRYIuUpHFuJB4hp4hCv5nBdJSggM5TYPfbiR1YnY86Ri3HEyjEe2+I5wCEEzVaWcgOoVpKI+bhSTFXXzwO+GZyVLFjZRPB92DZBSvgJYu17Ksx2Xo00o36yU2jCgXHWOS27U+qWTbna9WThJy2erwjSpcgTGjLYJA6Ej+HKcuKGRHXqiWnOcG7xyYcoE4WcibUAzJbAEML2RjZtPBGR+OhTKTf+W5UQE18b5HCTBHm+xGBXUZae4ctSMeTXUJeLBEud8n8WGaFFP+cE4npOd9NZoNwUXwTCR8yeV55jycTeY90fx9XhscOV2Mrjt2RbE93hwNry7SBqkCWDPafpQENP8fZwjb2wdvDEPZAGBRtvYrchvKdJMb3ow+P2sNFIFvzWybrqoR7OLbWLArZ7p/yDT/P91YG7BNR4lbdiGQDxq6db9/qUTvfj9jeruojUI7JXPO7vry/lzW1gkwSsy0ugVcMtveeCu9ee5j5ab8PIooQ1ElXrlkqHPHu1RPls7ZZsdPBYL0bEmo7wWGmMQzMjzY93j28fL0dq8gglCAOetg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Even without CONFIG_BALLOON_COMPACTION this infrastructure implements
basic list and page management for a memory balloon.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 Documentation/core-api/mm-api.rst                 |  2 +-
 MAINTAINERS                                       |  4 ++--
 arch/powerpc/platforms/pseries/cmm.c              |  2 +-
 drivers/misc/vmw_balloon.c                        |  2 +-
 drivers/virtio/virtio_balloon.c                   |  2 +-
 include/linux/{balloon_compaction.h => balloon.h} | 11 +++++------
 mm/Makefile                                       |  2 +-
 mm/{balloon_compaction.c => balloon.c}            |  7 +++----
 8 files changed, 15 insertions(+), 17 deletions(-)
 rename include/linux/{balloon_compaction.h => balloon.h} (92%)
 rename mm/{balloon_compaction.c => balloon.c} (98%)

diff --git a/Documentation/core-api/mm-api.rst b/Documentation/core-api/mm-api.rst
index 68193a4cfcf52..aabdd3cba58e8 100644
--- a/Documentation/core-api/mm-api.rst
+++ b/Documentation/core-api/mm-api.rst
@@ -130,5 +130,5 @@ More Memory Management Functions
 .. kernel-doc:: mm/vmscan.c
 .. kernel-doc:: mm/memory_hotplug.c
 .. kernel-doc:: mm/mmu_notifier.c
-.. kernel-doc:: mm/balloon_compaction.c
+.. kernel-doc:: mm/balloon.c
 .. kernel-doc:: mm/huge_memory.c
diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968e..878e53d0f65ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -27062,9 +27062,9 @@ M:	David Hildenbrand <david@redhat.com>
 L:	virtualization@lists.linux.dev
 S:	Maintained
 F:	drivers/virtio/virtio_balloon.c
-F:	include/linux/balloon_compaction.h
+F:	include/linux/balloon.h
 F:	include/uapi/linux/virtio_balloon.h
-F:	mm/balloon_compaction.c
+F:	mm/balloon.c
 
 VIRTIO BLOCK AND SCSI DRIVERS
 M:	"Michael S. Tsirkin" <mst@redhat.com>
diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
index 9ed71683ae402..c5aee15e192ea 100644
--- a/arch/powerpc/platforms/pseries/cmm.c
+++ b/arch/powerpc/platforms/pseries/cmm.c
@@ -19,7 +19,7 @@
 #include <linux/stringify.h>
 #include <linux/swap.h>
 #include <linux/device.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 #include <asm/firmware.h>
 #include <asm/hvcall.h>
 #include <asm/mmu.h>
diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 53e9335b6718c..7fd3f709108c2 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -29,7 +29,7 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 #include <linux/vmw_vmci_defs.h>
 #include <linux/vmw_vmci_api.h>
 #include <asm/hypervisor.h>
diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 4b22de6a5f845..5434a7739d588 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -13,7 +13,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 #include <linux/oom.h>
 #include <linux/wait.h>
 #include <linux/mm.h>
diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon.h
similarity index 92%
rename from include/linux/balloon_compaction.h
rename to include/linux/balloon.h
index 7757e0e314fdb..82585542300d6 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon.h
@@ -1,8 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 /*
- * include/linux/balloon_compaction.h
- *
- * Common interface definitions for making balloon pages movable by compaction.
+ * Common interface for implementing a memory balloon, including support
+ * for migration of pages inflated in a memory balloon.
  *
  * Balloon page migration makes use of the general "movable_ops page migration"
  * feature.
@@ -35,8 +34,8 @@
  *
  * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
  */
-#ifndef _LINUX_BALLOON_COMPACTION_H
-#define _LINUX_BALLOON_COMPACTION_H
+#ifndef _LINUX_BALLOON_H
+#define _LINUX_BALLOON_H
 #include <linux/pagemap.h>
 #include <linux/page-flags.h>
 #include <linux/migrate.h>
@@ -75,4 +74,4 @@ static inline void balloon_devinfo_init(struct balloon_dev_info *balloon)
 	balloon->migratepage = NULL;
 	balloon->adjust_managed_page_count = false;
 }
-#endif /* _LINUX_BALLOON_COMPACTION_H */
+#endif /* _LINUX_BALLOON_H */
diff --git a/mm/Makefile b/mm/Makefile
index 21abb33535501..ab012157b5109 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -121,7 +121,7 @@ obj-$(CONFIG_CMA)	+= cma.o
 obj-$(CONFIG_NUMA) += numa.o
 obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
 obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
-obj-$(CONFIG_MEMORY_BALLOON) += balloon_compaction.o
+obj-$(CONFIG_MEMORY_BALLOON) += balloon.o
 obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
 obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
 obj-$(CONFIG_CMA_DEBUGFS) += cma_debug.o
diff --git a/mm/balloon_compaction.c b/mm/balloon.c
similarity index 98%
rename from mm/balloon_compaction.c
rename to mm/balloon.c
index f41e4a179a431..5734dae81e318 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon.c
@@ -1,15 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/balloon_compaction.c
- *
- * Common interface for making balloon pages movable by compaction.
+ * Common interface for implementing a memory balloon, including support
+ * for migration of pages inflated in a memory balloon.
  *
  * Copyright (C) 2012, Red Hat, Inc.  Rafael Aquini <aquini@redhat.com>
  */
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/export.h>
-#include <linux/balloon_compaction.h>
+#include <linux/balloon.h>
 
 /*
  * Lock protecting the balloon_dev_info of all devices. We don't really
-- 
2.51.0


