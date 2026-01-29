Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E885D73E89
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:05:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7476B0096; Thu, 29 Jan 2026 16:05:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327EC6B0099; Thu, 29 Jan 2026 16:05:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1836B009B; Thu, 29 Jan 2026 16:05:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 093406B0096
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:05:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A4AA613A70C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:08 +0000 (UTC)
X-FDA: 84386231496.09.70E1968
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id E7CC84001D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:05:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kgMjQ8UA;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769720707; a=rsa-sha256;
	cv=none;
	b=lBh7MejUPJLKICP/jOUeHHBtjKBJhBac1McpySqYOZdpiYFSrKROZqcvH5lmDKWlrYb/7L
	J5Pxri8qMkO2sgqgK85CCXxmrYJa2x3OcDaN/tWmQNLGCOpqNI4OThg476W9UK/I4GNMBZ
	tSeg7RJyTFlwHxcQaQQ+Wh0foFgMSuU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kgMjQ8UA;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769720707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=291o5/6KJmg6RjVBO7LQXStrTekTD0wgyo4wONMNnas=;
	b=kYPxY0fecnPOac6AAIUWNHIE+vyL7nkrT12JUKt+9+oSG/bCaa12r0UYjbNkrFvXu+N3qP
	S661zUK6HaFLgUo7g2cVl6F40LJ1rY3D0fHhl2t+lKHE52Cfs6F9/HDdEQlJKeBHfkaN2B
	D6DQl1swbd5m68h07XHwj5SBkZHKOUM=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-502b0aa36feso21436721cf.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720706; x=1770325506; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=291o5/6KJmg6RjVBO7LQXStrTekTD0wgyo4wONMNnas=;
        b=kgMjQ8UAaJCIZQNq5g2qPQ8zcYcyIDxtsoi0E1KZicDApPr5pVV/ToSEnEeRDrop+p
         pUUlYSntJ6ik33MWFaeEHjMM/2pni23kyNeM1UojsIxt9Crp08DO8lry85p9jQDIlwje
         SBIGJG0ZPp4ZG/DUAYhrmEzTpEpLT+nw+Jo4vNqJ4h30Nwp2aJkm9K2ox+CL6nKULJ4w
         i9cqyMRco+twcuc3bckA/RwdZ5cvWj3pBOgHLvno6R6YuYYf+q/P46OcMz1sif9rbWWm
         d5ILX+hKKn7vQxvL26Jm3cXn9rUHJQkVxNfJsizDDD6TJHdCjezKb+WKtT8DG7iIdjmy
         l9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720706; x=1770325506;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=291o5/6KJmg6RjVBO7LQXStrTekTD0wgyo4wONMNnas=;
        b=qfcIasHx1kI1c+NFEdz8FqIZ1lMbBNn1WvUmVAmjfu/c0J5loa0hQCnrcVqQyguCbP
         jNfUpNEmHY/3tg31wEi8z5tCjKk+2Zhz9QkfIqI6jEAfUWPeqbVvwenrrdRiyVA8bQTs
         /PnjyAxRBKbBpxz5AhwzKznaeVLUQxrpgy20XFLtCBjtlpvrv2GcqwDZUTFuUbphYpqO
         3lPP1XVn/D3G9fRHaez9y7PayCQypISY6nXt5OqdXSkPJ9EajRaVV4+ujAotk2pgoM7c
         yKrzSw2/VmC5N/Z+QJPSpQNjqIEgRAenynPLIIcTQc9pEwcaITNTrA4Z3CqY74r7ucY0
         4pxg==
X-Gm-Message-State: AOJu0YzU3elS7g96rDSLIiNrPCuYG9cYUdh8iykmVeLgltY8xb5W1n8N
	+pHMNSW9aknr9qMekbcpIt+rYn2ico/HYCPkZ9X90QJPM25FsjL5vsxijrUtSPH1z2JiEzV8nN9
	j3KGdGpY=
X-Gm-Gg: AZuq6aLCH1lvCHxY6Di6VPaFknEfNiJjPatb3wGlKSDn/lxDO7/oXGuKtuR0uPR/5+1
	yBjmHuwgVvgc3RLT0qsiovJ4+zSQzYlWkD2J/0OgUIL2S7huLg3YDK9WPKjq9odQ+5n6GwlmK6c
	iEY4iFoVdvjZyLndu7L5mrrcffNqKlP1M0NU3S+Whcci4LF9er2cDSPfnvjWQW5ntmE/dUzldkL
	Nxe0/FKkksD4s0TLQCWwFBzJZbnYJgslf2I11Xv3NH1MyLkW0Q177pMWGRkxxDD7ioaM63FkCtC
	4Y4JNMpwE/n3aBIqw/e4HNAAq/qGit3tRl/Yo4A8484ZfGRhpKuaYwUodLLlfUNMjqpzr8TRnoY
	/jaEIzwkR5Kvr9ay2Dx66qhnMtLvUFGAyByCME+Vr5Z2tir5W6Yj+Bdy1QKnMPpZik4OSO7nz2u
	JzITZYrt75r1vVnkNLBnda6/Lb9W5lCdAPDsTYD9e2ZmcP+s7J1Yz8G9WRvAn8spgPkDHEHYRaI
	eo=
X-Received: by 2002:ac8:7f84:0:b0:4f1:8bfd:bdc2 with SMTP id d75a77b69052e-5036a94de88mr60405161cf.41.1769720705646;
        Thu, 29 Jan 2026 13:05:05 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:05 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 8/9] cxl/core: Add dax_kmem_region and sysram_region drivers
Date: Thu, 29 Jan 2026 16:04:41 -0500
Message-ID: <20260129210442.3951412-9-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E7CC84001D
X-Stat-Signature: ajsho55mq76shsdunduqfkgppjoqcmus
X-HE-Tag: 1769720706-441294
X-HE-Meta: U2FsdGVkX18VmGszQjuys0GA/XdtXaJkg98QWw/+rMfdlzxyLVl3J5ol5+jXWMH4Mr9VDqEQXRWbEhWQQsVFGkfhinKvGschfLHsVAwzvr6Ww7eSnvkFlunkIzIL2JcItNunsDY4YdC7V8BIBx6Z1pCZydrcBTo9AkcFbZYhsZhuNdhlVZyKGds48U4EBhuSBYJS5sKsJFzXsWxwJJi6CW0A7h0440RjC8cp9LMTLs6TJR8qp/Tq7lzJOj0eKspXKWkPMVUZWpYhQgcwy+yPXk1H5zSuCDRisf0k2OuSv8BowUtLms41lj/4rAtOg9iRxrYql3Ky4rd6ObxmiQ/fVFUsf2ToZgKM6IuI7OwAcz1jb00XsRdlaOvgaMbz+/Qx7KS0WaEptshRnzCp8sUDCz049AW+HUKPDnxfTSJmxGs6yZawgxWrDT5LXifWN+6PAnSGg3JnI2nCnd2+IcUQjt5H6G4b6ts+kcZw5cXFPnQ4CyCbn/ofAxPV7BMLyj93tu3gnnvXEXUXhbIvsd/RP3N2SSOBjBqSDzUTzFO7W2usTFPIZFWbOvx5BWfmaq8Gc1JKZ01fva4evDHZC6YkFyttWK5gFoTyxGAZM7lkHIE6s1KLDt3kxzBH23PwsuSbkDbCWeYgSkVW2oaEN2vEp8lZEt26ZuEiu01uY09Mano5ZD0PNtDFa/JhnaA88l/2NDnzMBV8kxInOVI9bNKffln6UtkbA5MaMvh5iVLgoHzbmB7HhQlUk5HK7yY3zyebk/WT0oXl8Y7m3pJ6Vs9JBppqxdxfgjFxpMTO+qL1dF6yXoZjVzMy/BO7PMa4myYeDAmIcjwia7DV5SSpoBOWZK312Woknb+fJH3fEeJzM/brBIW2QELi8Jf5c2oDAMvbGm8N6QnJK8UEWwGgie0Bk1n4N3iB1XuXnTym7m2VW+p+VBHnVmMdu6IZS2wyXUT8VMxA6veT98nUuz0egfR
 Zwqh1xu2
 Ax1+0BInhDTuc+8MDOGYV/tBW6Rqsx7VjpffglHYkvlc6WxpYFhMLjLUZlLc+ZeqQS2YLYKTO3DDYRPRSzxLq97ajmvsDwX0H5GyUx24VRTspukJfN26ofDLUb06I3nn6NSknRysE4hAhPQb+fKt/MnCsz8X12L3qf9a4sQB0a7YCejeaQ1/oWAEBSxp2hP1QeTZ4QZPq9k/t1Ss0bD6eUZrLwP55v1axobtqr2C7vm6gBN9+/AlLeDb36PzXlyX8Wq/4REujmtQO19vwxm9y9kCzmzDaGzmbXGpejMzSzvDYwmWKu4VPcZ5s12rEFoDtdCbO2kKESYYHQ+hkT05FmkuGi/3UaPwBDGqvhIjCPq+S6CyE4PAJMNToQ/2a3RrZFokHSASLeanAUsrZNjZd7psAXw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the current kmem driver binding process, the only way for users
to define hotplug policy is via a build-time option, or by not
onlining memory by default and setting each individual memory block
online after hotplug occurs.  We can solve this with a configuration
step between region-probe and dax-probe.

Add the infrastructure for a two-stage driver binding for kmem-mode
dax regions. The cxl_dax_kmem_region driver probes cxl_sysram_region
devices and creates cxl_dax_region with dax_driver=kmem.

This creates an interposition step where users can configure policy.

Device hierarchy:
  region0 -> sysram_region0 -> dax_region0 -> dax0.0

The sysram_region device exposes a sysfs 'online_type' attribute
that allows users to configure the memory online type before the
underlying dax_region is created and memory is hotplugged.

  sysram_region0/online_type:
      invalid:        not configured, blocks probe
      offline:        memory will not be onlined automatically
      online:         memory will be onlined in ZONE_NORMAL
      online_movable: memory will be onlined in ZONE_MMOVABLE

The device initializes with online_type=invalid which prevents the
cxl_dax_kmem_region driver from binding until the user explicitly
configures a valid online_type.

This enables a two-step binding process:
  echo region0 > cxl_sysram_region/bind
  echo online_movable > sysram_region0/online_type
  echo sysram_region0 > cxl_dax_kmem_region/bind

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-cxl |  21 +++
 drivers/cxl/core/Makefile               |   1 +
 drivers/cxl/core/core.h                 |   6 +
 drivers/cxl/core/dax_region.c           |  50 +++++++
 drivers/cxl/core/port.c                 |   2 +
 drivers/cxl/core/region.c               |  14 ++
 drivers/cxl/core/sysram_region.c        | 180 ++++++++++++++++++++++++
 drivers/cxl/cxl.h                       |  25 ++++
 8 files changed, 299 insertions(+)
 create mode 100644 drivers/cxl/core/sysram_region.c

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index c80a1b5a03db..a051cb86bdfc 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -624,3 +624,24 @@ Description:
 		The count is persistent across power loss and wraps back to 0
 		upon overflow. If this file is not present, the device does not
 		have the necessary support for dirty tracking.
+
+
+What:		/sys/bus/cxl/devices/sysram_regionZ/online_type
+Date:		January, 2026
+KernelVersion:	v7.1
+Contact:	linux-cxl@vger.kernel.org
+Description:
+		(RW) This attribute allows users to configure the memory online
+		type before the underlying dax_region engages in hotplug.
+
+		Valid values:
+		  'invalid': Not configured (default). Blocks probe.
+		  'offline': Memory will not be onlined automatically.
+		  'online' : Memory will be onlined in ZONE_NORMAL.
+		  'online_movable': Memory will be onlined in ZONE_MOVABLE.
+
+		The device initializes with online_type='invalid' which prevents
+		the cxl_dax_kmem_region driver from binding until the user
+		explicitly configures a valid online_type. This enables a
+		two-step binding process that gives users control over memory
+		hotplug policy before memory is added to the system.
diff --git a/drivers/cxl/core/Makefile b/drivers/cxl/core/Makefile
index 36f284d7c500..faf662c7d88b 100644
--- a/drivers/cxl/core/Makefile
+++ b/drivers/cxl/core/Makefile
@@ -18,6 +18,7 @@ cxl_core-y += ras.o
 cxl_core-$(CONFIG_TRACING) += trace.o
 cxl_core-$(CONFIG_CXL_REGION) += region.o
 cxl_core-$(CONFIG_CXL_REGION) += dax_region.o
+cxl_core-$(CONFIG_CXL_REGION) += sysram_region.o
 cxl_core-$(CONFIG_CXL_REGION) += pmem_region.o
 cxl_core-$(CONFIG_CXL_MCE) += mce.o
 cxl_core-$(CONFIG_CXL_FEATURES) += features.o
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index ea4df8abc2ad..04b32015e9b1 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -26,6 +26,7 @@ extern struct device_attribute dev_attr_delete_region;
 extern struct device_attribute dev_attr_region;
 extern const struct device_type cxl_pmem_region_type;
 extern const struct device_type cxl_dax_region_type;
+extern const struct device_type cxl_sysram_region_type;
 extern const struct device_type cxl_region_type;
 
 int cxl_decoder_detach(struct cxl_region *cxlr,
@@ -37,6 +38,7 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 #define SET_CXL_REGION_ATTR(x) (&dev_attr_##x.attr),
 #define CXL_PMEM_REGION_TYPE(x) (&cxl_pmem_region_type)
 #define CXL_DAX_REGION_TYPE(x) (&cxl_dax_region_type)
+#define CXL_SYSRAM_REGION_TYPE(x) (&cxl_sysram_region_type)
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
@@ -44,9 +46,12 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
+int devm_cxl_add_sysram_region(struct cxl_region *cxlr);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
 extern struct cxl_driver cxl_devdax_region_driver;
+extern struct cxl_driver cxl_dax_kmem_region_driver;
+extern struct cxl_driver cxl_sysram_region_driver;
 
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
@@ -81,6 +86,7 @@ static inline void cxl_region_exit(void)
 #define SET_CXL_REGION_ATTR(x)
 #define CXL_PMEM_REGION_TYPE(x) NULL
 #define CXL_DAX_REGION_TYPE(x) NULL
+#define CXL_SYSRAM_REGION_TYPE(x) NULL
 #endif
 
 struct cxl_send_command;
diff --git a/drivers/cxl/core/dax_region.c b/drivers/cxl/core/dax_region.c
index 391d51e5ec37..a379f5b85e3d 100644
--- a/drivers/cxl/core/dax_region.c
+++ b/drivers/cxl/core/dax_region.c
@@ -127,3 +127,53 @@ struct cxl_driver cxl_devdax_region_driver = {
 	.probe = cxl_devdax_region_driver_probe,
 	.id = CXL_DEVICE_REGION,
 };
+
+static int cxl_dax_kmem_region_driver_probe(struct device *dev)
+{
+	struct cxl_sysram_region *cxlr_sysram = to_cxl_sysram_region(dev);
+	struct cxl_dax_region *cxlr_dax;
+	struct cxl_region *cxlr;
+	int rc;
+
+	if (!cxlr_sysram)
+		return -ENODEV;
+
+	/* Require explicit online_type configuration before binding */
+	if (cxlr_sysram->online_type == -1)
+		return -ENODEV;
+
+	cxlr = cxlr_sysram->cxlr;
+
+	cxlr_dax = cxl_dax_region_alloc(cxlr);
+	if (IS_ERR(cxlr_dax))
+		return PTR_ERR(cxlr_dax);
+
+	/* Inherit online_type from parent sysram_region */
+	cxlr_dax->online_type = cxlr_sysram->online_type;
+	cxlr_dax->dax_driver = DAXDRV_KMEM_TYPE;
+
+	/* Parent is the sysram_region device */
+	cxlr_dax->dev.parent = dev;
+
+	rc = dev_set_name(&cxlr_dax->dev, "dax_region%d", cxlr->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(&cxlr_dax->dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(dev, "%s: register %s\n", dev_name(dev),
+		dev_name(&cxlr_dax->dev));
+
+	return devm_add_action_or_reset(dev, cxlr_dax_unregister, cxlr_dax);
+err:
+	put_device(&cxlr_dax->dev);
+	return rc;
+}
+
+struct cxl_driver cxl_dax_kmem_region_driver = {
+	.name = "cxl_dax_kmem_region",
+	.probe = cxl_dax_kmem_region_driver_probe,
+	.id = CXL_DEVICE_SYSRAM_REGION,
+};
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 3310dbfae9d6..dc7262a5efd6 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -66,6 +66,8 @@ static int cxl_device_id(const struct device *dev)
 		return CXL_DEVICE_PMEM_REGION;
 	if (dev->type == CXL_DAX_REGION_TYPE())
 		return CXL_DEVICE_DAX_REGION;
+	if (dev->type == CXL_SYSRAM_REGION_TYPE())
+		return CXL_DEVICE_SYSRAM_REGION;
 	if (is_cxl_port(dev)) {
 		if (is_cxl_root(to_cxl_port(dev)))
 			return CXL_DEVICE_ROOT;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 6200ca1cc2dd..8bef91dc726c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3734,8 +3734,20 @@ int cxl_region_init(void)
 	if (rc)
 		goto err_dax;
 
+	rc = cxl_driver_register(&cxl_sysram_region_driver);
+	if (rc)
+		goto err_sysram;
+
+	rc = cxl_driver_register(&cxl_dax_kmem_region_driver);
+	if (rc)
+		goto err_dax_kmem;
+
 	return 0;
 
+err_dax_kmem:
+	cxl_driver_unregister(&cxl_sysram_region_driver);
+err_sysram:
+	cxl_driver_unregister(&cxl_devdax_region_driver);
 err_dax:
 	cxl_driver_unregister(&cxl_region_driver);
 	return rc;
@@ -3743,6 +3755,8 @@ int cxl_region_init(void)
 
 void cxl_region_exit(void)
 {
+	cxl_driver_unregister(&cxl_dax_kmem_region_driver);
+	cxl_driver_unregister(&cxl_sysram_region_driver);
 	cxl_driver_unregister(&cxl_devdax_region_driver);
 	cxl_driver_unregister(&cxl_region_driver);
 }
diff --git a/drivers/cxl/core/sysram_region.c b/drivers/cxl/core/sysram_region.c
new file mode 100644
index 000000000000..5665db238d0f
--- /dev/null
+++ b/drivers/cxl/core/sysram_region.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2026 Meta Platforms, Inc. All rights reserved. */
+/*
+ * CXL Sysram Region - Intermediate device for kmem hotplug configuration
+ *
+ * This provides an intermediate device between cxl_region and cxl_dax_region
+ * that allows users to configure memory hotplug parameters (like online_type)
+ * before the underlying dax_region is created and memory is hotplugged.
+ */
+
+#include <linux/memory_hotplug.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <cxlmem.h>
+#include <cxl.h>
+#include "core.h"
+
+static void cxl_sysram_region_release(struct device *dev)
+{
+	struct cxl_sysram_region *cxlr_sysram = to_cxl_sysram_region(dev);
+
+	kfree(cxlr_sysram);
+}
+
+static ssize_t online_type_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct cxl_sysram_region *cxlr_sysram = to_cxl_sysram_region(dev);
+
+	switch (cxlr_sysram->online_type) {
+	case MMOP_OFFLINE:
+		return sysfs_emit(buf, "offline\n");
+	case MMOP_ONLINE:
+		return sysfs_emit(buf, "online\n");
+	case MMOP_ONLINE_MOVABLE:
+		return sysfs_emit(buf, "online_movable\n");
+	default:
+		return sysfs_emit(buf, "invalid\n");
+	}
+}
+
+static ssize_t online_type_store(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t len)
+{
+	struct cxl_sysram_region *cxlr_sysram = to_cxl_sysram_region(dev);
+
+	if (sysfs_streq(buf, "offline"))
+		cxlr_sysram->online_type = MMOP_OFFLINE;
+	else if (sysfs_streq(buf, "online"))
+		cxlr_sysram->online_type = MMOP_ONLINE;
+	else if (sysfs_streq(buf, "online_movable"))
+		cxlr_sysram->online_type = MMOP_ONLINE_MOVABLE;
+	else
+		return -EINVAL;
+
+	return len;
+}
+
+static DEVICE_ATTR_RW(online_type);
+
+static struct attribute *cxl_sysram_region_attrs[] = {
+	&dev_attr_online_type.attr,
+	NULL,
+};
+
+static const struct attribute_group cxl_sysram_region_attribute_group = {
+	.attrs = cxl_sysram_region_attrs,
+};
+
+static const struct attribute_group *cxl_sysram_region_attribute_groups[] = {
+	&cxl_base_attribute_group,
+	&cxl_sysram_region_attribute_group,
+	NULL,
+};
+
+const struct device_type cxl_sysram_region_type = {
+	.name = "cxl_sysram_region",
+	.release = cxl_sysram_region_release,
+	.groups = cxl_sysram_region_attribute_groups,
+};
+
+static bool is_cxl_sysram_region(struct device *dev)
+{
+	return dev->type == &cxl_sysram_region_type;
+}
+
+struct cxl_sysram_region *to_cxl_sysram_region(struct device *dev)
+{
+	if (dev_WARN_ONCE(dev, !is_cxl_sysram_region(dev),
+			  "not a cxl_sysram_region device\n"))
+		return NULL;
+	return container_of(dev, struct cxl_sysram_region, dev);
+}
+EXPORT_SYMBOL_NS_GPL(to_cxl_sysram_region, "CXL");
+
+static struct lock_class_key cxl_sysram_region_key;
+
+static struct cxl_sysram_region *cxl_sysram_region_alloc(struct cxl_region *cxlr)
+{
+	struct cxl_region_params *p = &cxlr->params;
+	struct cxl_sysram_region *cxlr_sysram;
+	struct device *dev;
+
+	guard(rwsem_read)(&cxl_rwsem.region);
+	if (p->state != CXL_CONFIG_COMMIT)
+		return ERR_PTR(-ENXIO);
+
+	cxlr_sysram = kzalloc(sizeof(*cxlr_sysram), GFP_KERNEL);
+	if (!cxlr_sysram)
+		return ERR_PTR(-ENOMEM);
+
+	cxlr_sysram->hpa_range.start = p->res->start;
+	cxlr_sysram->hpa_range.end = p->res->end;
+	cxlr_sysram->online_type = -1;  /* Require explicit configuration */
+
+	dev = &cxlr_sysram->dev;
+	cxlr_sysram->cxlr = cxlr;
+	device_initialize(dev);
+	lockdep_set_class(&dev->mutex, &cxl_sysram_region_key);
+	device_set_pm_not_required(dev);
+	dev->parent = &cxlr->dev;
+	dev->bus = &cxl_bus_type;
+	dev->type = &cxl_sysram_region_type;
+
+	return cxlr_sysram;
+}
+
+static void cxlr_sysram_unregister(void *_cxlr_sysram)
+{
+	struct cxl_sysram_region *cxlr_sysram = _cxlr_sysram;
+
+	device_unregister(&cxlr_sysram->dev);
+}
+
+int devm_cxl_add_sysram_region(struct cxl_region *cxlr)
+{
+	struct cxl_sysram_region *cxlr_sysram;
+	struct device *dev;
+	int rc;
+
+	cxlr_sysram = cxl_sysram_region_alloc(cxlr);
+	if (IS_ERR(cxlr_sysram))
+		return PTR_ERR(cxlr_sysram);
+
+	dev = &cxlr_sysram->dev;
+	rc = dev_set_name(dev, "sysram_region%d", cxlr->id);
+	if (rc)
+		goto err;
+
+	rc = device_add(dev);
+	if (rc)
+		goto err;
+
+	dev_dbg(&cxlr->dev, "%s: register %s\n", dev_name(dev->parent),
+		dev_name(dev));
+
+	return devm_add_action_or_reset(&cxlr->dev, cxlr_sysram_unregister,
+					cxlr_sysram);
+err:
+	put_device(dev);
+	return rc;
+}
+
+static int cxl_sysram_region_driver_probe(struct device *dev)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	/* Only handle RAM regions */
+	if (cxlr->mode != CXL_PARTMODE_RAM)
+		return -ENODEV;
+
+	return devm_cxl_add_sysram_region(cxlr);
+}
+
+struct cxl_driver cxl_sysram_region_driver = {
+	.name = "cxl_sysram_region",
+	.probe = cxl_sysram_region_driver_probe,
+	.id = CXL_DEVICE_REGION,
+};
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 674d5f870c70..1544c27e9c89 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -596,6 +596,25 @@ struct cxl_dax_region {
 	enum dax_driver_type dax_driver;
 };
 
+/**
+ * struct cxl_sysram_region - CXL RAM region for system memory hotplug
+ * @dev: device for this sysram_region
+ * @cxlr: parent cxl_region
+ * @hpa_range: Host physical address range for the region
+ * @online_type: Memory online type (MMOP_* 0-3, or -1 if not configured)
+ *
+ * Intermediate device that allows configuration of memory hotplug
+ * parameters before the underlying dax_region is created. The device
+ * starts with online_type=-1 which prevents the cxl_dax_kmem_region
+ * driver from binding until the user explicitly sets online_type.
+ */
+struct cxl_sysram_region {
+	struct device dev;
+	struct cxl_region *cxlr;
+	struct range hpa_range;
+	int online_type;
+};
+
 /**
  * struct cxl_port - logical collection of upstream port devices and
  *		     downstream port devices to construct a CXL memory
@@ -890,6 +909,7 @@ void cxl_driver_unregister(struct cxl_driver *cxl_drv);
 #define CXL_DEVICE_PMEM_REGION		7
 #define CXL_DEVICE_DAX_REGION		8
 #define CXL_DEVICE_PMU			9
+#define CXL_DEVICE_SYSRAM_REGION	10
 
 #define MODULE_ALIAS_CXL(type) MODULE_ALIAS("cxl:t" __stringify(type) "*")
 #define CXL_MODALIAS_FMT "cxl:t%d"
@@ -907,6 +927,7 @@ bool is_cxl_pmem_region(struct device *dev);
 struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
 int cxl_add_to_region(struct cxl_endpoint_decoder *cxled);
 struct cxl_dax_region *to_cxl_dax_region(struct device *dev);
+struct cxl_sysram_region *to_cxl_sysram_region(struct device *dev);
 u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint, u64 spa);
 #else
 static inline bool is_cxl_pmem_region(struct device *dev)
@@ -925,6 +946,10 @@ static inline struct cxl_dax_region *to_cxl_dax_region(struct device *dev)
 {
 	return NULL;
 }
+static inline struct cxl_sysram_region *to_cxl_sysram_region(struct device *dev)
+{
+	return NULL;
+}
 static inline u64 cxl_port_get_spa_cache_alias(struct cxl_port *endpoint,
 					       u64 spa)
 {
-- 
2.52.0


