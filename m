Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD26C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 02:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6E76B00AB; Mon, 24 Aug 2026 22:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE3D6B00AC; Mon, 24 Aug 2026 22:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4506B00AD; Mon, 24 Aug 2026 22:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4AD9C6B00AB
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 22:28:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1739A029F
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:28:12 +0000 (UTC)
X-FDA: 85138207224.10.BD80392
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id AFF7B80003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 02:28:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GwB7NaZZ;
	spf=pass (imf02.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787624890;
	b=LqjhsFR/pMCXi1jK0kTzTJONiBwK6MeStTenaDikT3NV/eaJNtjsc9G8t421C0b8YVIr7f
	DaXkxr+KfhHTrmQQP0VJ6LW9FUx3bl+fMYyWJ2WRVL3qyhqk2oitMTxVLHTNKtK0vxAOAW
	S0N7LJekv2nPDEG+hpeOEBh3Rg9S0j8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GwB7NaZZ;
	spf=pass (imf02.hostedemail.com: domain of fabio.m.de.francesco@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=fabio.m.de.francesco@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787624890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxwt5S9a8aHbU9JG+LPHXLs7p3zY9QoQR657xNSuzIk=;
	b=rI26eE41UQIAhpyBrLkWNISpj5PagbP4r3T/l2Aaus2GpjZp5r0+hSP1A4X93qOhpznQJ5
	kSIF0wzZNFQfpS+nssFJUFsZfO0YLNuBxYOaMiJF8p5yb05As9Hj21utEdUmw+3uu7x49m
	wlLU8evB/zlEhJU9JjszlSCslEpRAZc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787624890; x=1819160890;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FUdOrKAllFyNGlbt+7H02DeS9Es+Uvq5pCkFtZCzCVY=;
  b=GwB7NaZZRylVPK8y08q6A7VpGV3ap13v/f/Y+rQkeUcIkhE3gSos6KNg
   pbNEwympOlH/i5cOUBv3YWD7eRSH7QcafZmzoItX2dEcAqm15oQgMUAIw
   PiVRSYpi/1tWO74xmKiFvp6E0WWAgGGV76vKpZ6TODWDxyejaeCqYxqss
   gKW6guIkCsehvN0ztif0nb5S4IXrYV7FeWt5Y9zpj8QHp9kE/M1/AdR52
   j4oq4dwJ+OXVN6rWiky215Eg8atNmpxHnlMGLFaZfRb8mA/t6K1z75oKk
   LGsNGvvfZNl2Xx3Iw3hDE94Bj5YwRj8O6nY3EnnR3dg/6sz0ufKt+qpR1
   Q==;
X-CSE-ConnectionGUID: RI3S+nEWRW+6BegRqvnOvg==
X-CSE-MsgGUID: HvHnRkmdSQ6umGYenaBfWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11885"; a="98761223"
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="98761223"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:28:09 -0700
X-CSE-ConnectionGUID: FDcQU3FlQ1CYUmjpJn2HKA==
X-CSE-MsgGUID: jZ8XDkaASU+FbuakNuw/nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,241,1779174000"; 
   d="scan'208";a="265390142"
Received: from fdefranc-mobl3.igk.intel.com ([172.28.182.157])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 19:28:01 -0700
From: "Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
To: linux-cxl@vger.kernel.org
Cc: David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mahesh J Salgaonkar <mahesh@linux.ibm.com>,
	Oliver O'Halloran <oohall@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	driver-core@lists.linux.dev,
	linux-pci@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	"Fabio M. De Francesco" <fabio.m.de.francesco@linux.intel.com>
Subject: [PATCH v2 12/13] PCI/CXL: Add a sysfs entry to unmask SBR
Date: Tue, 25 Aug 2026 04:26:27 +0200
Message-ID: <20260825022628.3651434-13-fabio.m.de.francesco@linux.intel.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
References: <20260825022628.3651434-1-fabio.m.de.francesco@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFF7B80003
X-Stat-Signature: 3mmthkau67xi5rhhs34qs85pzz6npu9z
X-HE-Tag: 1787624890-913836
X-HE-Meta: U2FsdGVkX18jfDQEWIMoZ8eOVjc1ae6C1SomSS2D3ZPUB2AwDxHzGLsbkIMrrytgkgh1zosxXIQ80fjz4g7MIOrl4QEG/mo4q/201MKt5HBr5epS+yejAk2VVPb9qBW8qbeLkaiDBxMoUw85DjjBKW6pQeOyX6V7zenfejvXn+bI54/8VwJtIahesclkLGDmI14p46a7fguJEJ9NCxGqVq4TOHGaiC3Kmw2lVwlBdDZ3km2ZaQ4syepfd7ZLZ1bOkfcHwNdZPiA9pjO9cu/y+A3yJ6lGLGYAPFIK07Y1D2X9MnUR9BVfVF8+Oy36x00vh1fp2ZH6qRyXzgccILQmLn/LwAcYxn8TEPtTQnq0zNH8ZWDKQIeCjs7RBjd7PeFH//M1dFT4jbsQJCcugNQcEV8J59pSTyfFK89WwnzHhoavx+085lRl+PB4WGCfRfrngyW0agb0ZvZvr+UoELXnvH6WxO7F3JmmmDgTvSepGX6ZlCwiPow+EcZiY/hZQmKi6bMADvITwvapOFSpw18uM1bSmsAgGrggo02FGXmJRiJQ297aQAezbxWcizSIV3ercxdDQZpyJ583NGZejhTjuoFzURT+KRYoHyhDDtuPnBc7TydsB7VjLL/X90J1ENYrShf2TRTNn0sgrirpALgIDmKB5tagG2BOAsmebFel8A7LILUHwzrkAAolYLpmdAt0boyTn4L+ggQPpVa+ydQiKZDgAZhpi1AYndpYMg+vA27crmYMNu7yzHh/rr7+ou1f3GgD2f70l/8IfMyUTNkHiXaEcB+smyOLSTYy0LhbYHM6V0yBezmeKunM08Yp/1rfy0LXT7hKDSLO5FD7Dmj/akIwfltCqk4tx4W+Ee1bsnNwFiWkQXH99DFumAKrkvAjMOUaFIKYZS4j1sJEpCzb2hjvXcpuf8cWyLslfyNymClwsas9heeuvuUHbaJmLyeYDR33ngm74zive6zcNWk
 kJoWviLf
 Kf+zbQtwxIfGcNvb6hbKixL9CcXLxCGgqXjrQDHE9g8lXc5poby8RwZbAg+eQ7RIfhk5HpQu5K+tyTjbNbyKjMRar4NVLDWhJ1B4Jram8zq5tNX7y4ld0B+PQePSCr1xkYA09fxFS/XlwWSLQjRR9/6POwRg7XokZge6s852xk3pdFOLtuvITS6Cr0I+hQBZd4GJF08DCobYoK7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A Secondary Bus Reset of a CXL Downstream Port only reaches the component
below it when the Port's Unmask SBR bit is set. CXL r4.0 sec 8.1.5.2
Table 8-32: "When cleared to 0 (default), the SBR bit in this Port's
Bridge Control register has no effect." A kernel that unmasks it on its own initiative overrules
that for every path reaching pci_bridge_secondary_bus_reset() SBR.

Add a cxl_unmask_sbr attribute beside reset_subordinate in the Port's
sysfs directory to allow kernel triggered SBR of CXL DPorts.

Signed-off-by: Fabio M. De Francesco <fabio.m.de.francesco@linux.intel.com>
---
 Documentation/ABI/testing/sysfs-bus-pci | 16 +++++++++++++
 drivers/pci/pci-sysfs.c                 | 31 +++++++++++++++++++++++++
 include/linux/pci.h                     |  1 +
 3 files changed, 48 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/testing/sysfs-bus-pci
index b767db2c52cb..7b0314da6f4d 100644
--- a/Documentation/ABI/testing/sysfs-bus-pci
+++ b/Documentation/ABI/testing/sysfs-bus-pci
@@ -174,6 +174,22 @@ Description:
 		similiar to writing 1 to their individual "reset" file, so use
 		with caution.
 
+What:		/sys/bus/pci/devices/.../cxl_unmask_sbr
+Date:		August 2026
+Contact:	linux-pci@vger.kernel.org
+Description:
+		This is visible only for a CXL Downstream Port, that is a Root
+		Port or a Downstream Switch Port that publishes the CXL
+		Extensions DVSEC for Ports.  Such a Port ignores the Secondary
+		Bus Reset bit in its Bridge Control register unless its
+		"Unmask SBR" bit is set, and system firmware leaves that bit
+		clear by default.
+
+		Writing 1 allows the kernel to set "Unmask SBR" while it
+		resets the Port's secondary bus, so that the reset reaches the
+		component below the Port.  While this reads 0, a bus reset of
+		the Port fails instead.
+
 What:		/sys/bus/pci/devices/.../vpd
 Date:		February 2008
 Contact:	Ben Hutchings <bwh@kernel.org>
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5ec0b245a69b..ba1cae6ab4fa 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -573,6 +573,33 @@ static ssize_t reset_subordinate_store(struct device *dev,
 }
 static DEVICE_ATTR_WO(reset_subordinate);
 
+static ssize_t cxl_unmask_sbr_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+
+	return sysfs_emit(buf, "%u\n", pdev->cxl_unmask_sbr);
+}
+
+static ssize_t cxl_unmask_sbr_store(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	unsigned long val;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (kstrtoul(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	pdev->cxl_unmask_sbr = !!val;
+
+	return count;
+}
+static DEVICE_ATTR_RW(cxl_unmask_sbr);
+
 #if defined(CONFIG_PM) && defined(CONFIG_ACPI)
 static ssize_t d3cold_allowed_store(struct device *dev,
 				    struct device_attribute *attr,
@@ -650,6 +677,7 @@ static struct attribute *pci_bridge_attrs[] = {
 	&dev_attr_subordinate_bus_number.attr,
 	&dev_attr_secondary_bus_number.attr,
 	&dev_attr_reset_subordinate.attr,
+	&dev_attr_cxl_unmask_sbr.attr,
 	NULL,
 };
 
@@ -1824,6 +1852,9 @@ static umode_t pci_bridge_attrs_are_visible(struct kobject *kobj,
 	struct device *dev = kobj_to_dev(kobj);
 	struct pci_dev *pdev = to_pci_dev(dev);
 
+	if (a == &dev_attr_cxl_unmask_sbr.attr && !is_cxl_dport(pdev))
+		return 0;
+
 	if (pci_is_bridge(pdev))
 		return a->mode;
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 0d9832ce6f3d..bc0f652eff80 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -485,6 +485,7 @@ struct pci_dev {
 	unsigned int	shpc_managed:1;		/* SHPC owned by shpchp */
 	unsigned int	is_thunderbolt:1;	/* Thunderbolt controller */
 	unsigned int	is_cxl:1;               /* Compute Express Link (CXL) */
+	unsigned int	cxl_unmask_sbr:1;	/* SBR unmask allowed by user */
 	/*
 	 * Devices marked being untrusted are the ones that can potentially
 	 * execute DMA attacks and similar. They are typically connected
-- 
2.55.0


