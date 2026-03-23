Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3BD0F532C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57156B00B9; Mon, 23 Mar 2026 19:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08996B00BB; Mon, 23 Mar 2026 19:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7066B00BC; Mon, 23 Mar 2026 19:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 98EF66B00B9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:14 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6B254140DB1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:14 +0000 (UTC)
X-FDA: 84578996628.11.6B0E48F
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC95780005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:12 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nDEkF3Fb;
	spf=pass (imf30.hostedemail.com: domain of 3z9PBaQgKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3z9PBaQgKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoPb6rPvbQAZiMMCvtGaLSKACFZ3kOlM4xYp0I2xeaE=;
	b=fO2khvwNy9invrfv/dKjZJeTH3Ub8mOGQz2zGrumJW8ObG0+bvdxwxSnOJ1SWTokFTBiQa
	HyjmcCJNXWxvAFVb27gDyBFfEIdrqfRZmEu5/Zckutuc95+oB5tp0JDv5WDAI7JwNNcqh4
	VRNlMhArpNSHyf87ULPedXwNfU20Gpo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=nDEkF3Fb;
	spf=pass (imf30.hostedemail.com: domain of 3z9PBaQgKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3z9PBaQgKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310352; a=rsa-sha256;
	cv=none;
	b=Ww2tpw2WKe7jtjXebaRx/gmTUwVW35xbdIpmOwypizIarIIFJ05osVEAjsbTBtdiDsW0SD
	5ww0tk9TdMXVU75xCFG7fYUxXpTQep6q1UA9fyMvsZxSIX+nFaeb80VVr4mNF37/sVsrBH
	Bq03pgZa02eLMeylD5CKGN4m3hzrRN4=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b064f043adso67505945ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310351; x=1774915151; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uoPb6rPvbQAZiMMCvtGaLSKACFZ3kOlM4xYp0I2xeaE=;
        b=nDEkF3FbOwaMyATDQG2/ioA3sAm65Ilt9NmD3SL/doq/0/1wtD9nYzOsfEuo3QW/sQ
         ZUMyolWb/jCKxVEvz4nv6YVrzsaOtxIQu1hjcQ8QSwDM+n4mBC9D9ZfsiOG+aZZcm0lK
         7i/I6Zzk6wed2CFkbulw7FRVZryBhkt098pPIDawmZwHahUzqqJ6tQAjsGEQmgeO/Hj/
         e6XqCswfZ9R+Z4pWDfODsAvkTj6cMFqsBjmsqdG3+UQDR161qUnwYhdl4BYDJwpYWIF/
         7uCZsm/1eLl4dymipSV2SRiVhWqetJwGmQroktaoeg6Z+YNkO02ue5RKBbVjEAothEWp
         +vXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310351; x=1774915151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uoPb6rPvbQAZiMMCvtGaLSKACFZ3kOlM4xYp0I2xeaE=;
        b=Gmlm9TL9Wxtwz59SYqGuFO2MnHY99aDI8QJc8tryYPbR30hsMeTh1mRZDzHfTstkiz
         Ro/JC6F+FMlbv+ACyW7d4mKhPenWgd2qA4+Yk9HHpbbAz2MUshJVgt+eapGEH62EXqKg
         wcX1jWbEBW+QQMubKS5L3U3eIsUv456CZKhvfCYErxCrnNfgEZI3oQuIigDwn087GkIN
         biwGp/OAaUb8uXzkcHrbSEA4kEIsIhZYJuc5xVjmMXmurHBM0LlCGOMxagaeeRIl0dHj
         HFF7cwpVhkc10w52lRK19JiCOE9CvJ6OfbrRH6W7dyyuAFSz8nVI19b2UWhDcu9ii2Ac
         lA/g==
X-Forwarded-Encrypted: i=1; AJvYcCV2KvITCEsVUvRXxCSAI38LRg0Ldt0GkkHnLJTzn/3ZTf3mAG9lMpBxbd5dlpeayqY+c3yRvubWcw==@kvack.org
X-Gm-Message-State: AOJu0YzFktXr6lVd3YA0mclFVDg2RRiALw7AdBXu6JkM5LD9FpX3+ChG
	kkD45URBS/4LEl6KCz/qJGWg+u+dTllkLze7dEt4A/uIuL0qx804WMaYsia3OfNMw6tynk44TQB
	KAa7iIwk1fN1ETQ==
X-Received: from pga26.prod.google.com ([2002:a05:6a02:4f9a:b0:c6e:28c3:dd5c])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:218a:b0:39b:81bf:15e3 with SMTP id adf61e73a8af0-39bcec29166mr12126845637.66.1774310351170;
 Mon, 23 Mar 2026 16:59:11 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:11 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-20-dmatlack@google.com>
Subject: [PATCH v3 19/24] vfio: selftests: Initialize vfio_pci_device using a
 VFIO cdev FD
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: AC95780005
X-Stat-Signature: rfne3ndyh1wutarwiegs9mt5wmwnr9k7
X-Rspamd-Server: rspam06
X-HE-Tag: 1774310352-800084
X-HE-Meta: U2FsdGVkX1+o3yJQzwevHFIWQ2kO0BfcFkQjmNrb/eTHfhBgw6EoZSoW5VMLob2fTIWQshhRh0M//ABavPQrKleFUtnxK9q0i0jCGgMCq/4pyW9kHr/hobH/qCVoB8MP8r1ayWRD+6CtXHshTJMIojE023lSBOxoiF9VnLA+4SyUCch5lRegVUr9UcVyxtwsi32De6K8MiBRTlm1K97JeHAs9Kdbtt/twe9lVchClhTh0r846z06Ezb7ONmWsebaJPQ7HtpXXlfXZU9XmomqZ81oVnIaQp52Rgp0sd2JdajTRlv9WXIdwO/2igJIbbBkALk7cmi9Y9C62PhstCRS+nuz8BGEfBDW3+ikAmJeO8vBBeUHwSKgGbdAchG2ZG28faVCVPXK2RjN0oJht46DfZ7dqayHWg5YOZTG04pWf/8X8EiSDMiF0X6a6t9ENg+8jar3rR/50oie7EE4cDzkTROZq2Wc+UZNcvRsFMLgyJkbdO3LBJywRcc515DT0M26PArJjl3jXP8D5ZkpT/RBWqa2AE2HjIaR9v7lz2zCWBnzXnT3hLXI/r5qedfVha/TZ0T+fE1OuzNp44TW3GTG8YqN5z2Pca9E6TmPLgbMv9t1rNC0/ft8AX26nhOd1P0KiBgt5d8mW5AtJxznslwotEHa+9o7viQHO3nsFohAljWsa4U7LLjzkhSnd8nSTj5dPW76SEieRiNshgzC0mNE3ZQ20G5c5a1BQhBwA7mH3AKmz+GCncd5+Jb9gHirpPilpWD4CoBJGxTCdJ78xFwo3cVL6/9MWM1EwNIESK8aTu1wpBolqtb19fJVjprGqIq+a1QKd9N4ZpKEMg07wfxBt4jDP3hFzQN+d/UZEWsUknB2ecxegaZIeCFc5DqUOVJnNWZ5BSHZ2QcTjaFYa+MT7HUWfJuN9W9tMZn12x/AAwoYsr655/vRh56i/oxj/yxCDU+R1e5DWmJJamQqzoV
 BqFiVjgL
 Z9AiEKYqjnR3VStNVeE4P52CJD1TZBD4uw19U9GHu0IcEC5AWIvzNSlVDg5N5i5D1S+mbYNdANrHdi9GwS8QTBBYlmBPpmwESAVmm6FZ66G8z5fhsIBvv7Vq8cEKVAlDEQH2YPPrLVlyAv2C3tyZisp+l5H/EcH2xoa+6fLo93QuaWy3AGMhqZX+bu334z7tbWg2jdfayJC5sMp+6JMZNQCm62bC0VwBqAdtEAAD32BZHl4AwrT0JBQDbtO1sYoA6Y5H9jDBTmZ65bFr2plPZd6fXxGJ7Y/rXiVhv5anNkziCaUS6q4BGfT0bCrgQFgyqKQnD/n06uAopT9+Ed5h947/Ciy+EoFLsvX0n/DSUh+2H1mVfRfXFKfD0qX79njp0EYLZDfz/OxHr7GrXLYkrGG+zuRDmzN+u1P/ZAypBl/gvWcOB+nDZYHf/qXtEv8u664oFjVOObp84dPubkUFyhA6oY0MQf5vE56UBgiOiScPvTeYYv70KLXBayNEgbfZwqlAYAOCLhT+EtEoUmkM2A3CwC19lvLiFTAV6tcnkpzHTxfuGAZ2sYVj0AgvlmLPWnJTDgm2fel7k8LCsKVds8SQbBHeFNE1KdLUaGHbV1PVErsQfohCldxdZkDkisQJRJDxtdWVYCVMXPJWyrHyZeFlTiS4bFIEEcys5J+NMy3J8H2ufpdRO6kFWGVGBTJly9UsH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Use the given VFIO cdev FD to initialize vfio_pci_device in VFIO
selftests. Add the assertion to make sure that passed cdev FD is not
used with legacy VFIO APIs. If VFIO cdev FD is provided then do not open
the device instead use the FD for any interaction with the device.

This API will allow to write selftests where VFIO device FD is preserved
using liveupdate and retrieved later using liveupdate ioctl after kexec.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../lib/include/libvfio/vfio_pci_device.h     |  3 ++
 .../selftests/vfio/lib/vfio_pci_device.c      | 33 ++++++++++++++-----
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 2858885a89bb..896dfde88118 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -38,6 +38,9 @@ struct vfio_pci_device {
 #define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
 
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd);
 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
 void vfio_pci_device_cleanup(struct vfio_pci_device *device);
 
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_device.c b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
index 4e5871f1ebc3..e9215c712cda 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -340,19 +340,27 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
 	ioctl_assert(device_fd, VFIO_DEVICE_ATTACH_IOMMUFD_PT, &args);
 }
 
-static void vfio_pci_iommufd_setup(struct vfio_pci_device *device, const char *bdf)
+static void vfio_pci_iommufd_setup(struct vfio_pci_device *device,
+				   const char *bdf, int device_fd)
 {
-	const char *cdev_path = vfio_pci_get_cdev_path(bdf);
+	const char *cdev_path;
 
-	device->fd = open(cdev_path, O_RDWR);
-	VFIO_ASSERT_GE(device->fd, 0);
-	free((void *)cdev_path);
+	if (device_fd >= 0) {
+		device->fd = device_fd;
+	} else {
+		cdev_path = vfio_pci_get_cdev_path(bdf);
+		device->fd = open(cdev_path, O_RDWR);
+		VFIO_ASSERT_GE(device->fd, 0);
+		free((void *)cdev_path);
+	}
 
 	vfio_device_bind_iommufd(device->fd, device->iommu->iommufd);
 	vfio_device_attach_iommufd_pt(device->fd, device->iommu->ioas_id);
 }
 
-struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+struct vfio_pci_device *__vfio_pci_device_init(const char *bdf,
+					       struct iommu *iommu,
+					       int device_fd)
 {
 	struct vfio_pci_device *device;
 
@@ -363,10 +371,12 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	device->iommu = iommu;
 	device->bdf = bdf;
 
-	if (iommu->mode->container_path)
+	if (iommu->mode->container_path) {
+		VFIO_ASSERT_EQ(device_fd, -1);
 		vfio_pci_container_setup(device, bdf);
-	else
-		vfio_pci_iommufd_setup(device, bdf);
+	} else {
+		vfio_pci_iommufd_setup(device, bdf, device_fd);
+	}
 
 	vfio_pci_device_setup(device);
 	vfio_pci_driver_probe(device);
@@ -374,6 +384,11 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
 	return device;
 }
 
+struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu)
+{
+	return __vfio_pci_device_init(bdf, iommu, /*device_fd=*/-1);
+}
+
 void vfio_pci_device_cleanup(struct vfio_pci_device *device)
 {
 	int i;
-- 
2.53.0.983.g0bb29b3bc5-goog


