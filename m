Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5294ED73E8D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CEE6B009B; Thu, 29 Jan 2026 16:25:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55B76B009D; Thu, 29 Jan 2026 16:25:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCE26B009E; Thu, 29 Jan 2026 16:25:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7FD486B009B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4BCDA1A02F2
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:55 +0000 (UTC)
X-FDA: 84386283870.21.01CED21
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8090A40005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Y/rntz9y";
	spf=pass (imf17.hostedemail.com: domain of 3YNB7aQgKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YNB7aQgKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cEITHmxK+p0fg2PKlGTWLUl48Yr7XTXbjGIRUwhwM+A=;
	b=ItoE/DJYNdVED8qTIX+rT6b81ctGmB7iQfSkAB8lHOj8FTWgaIodAd8iCKcLpPweZE1I8w
	+TrYbLAIMVVoXsVGrc+Q+lg/CjIGwfwAPPr4sYxxCnSwxkA/C2LRZuJSb77j9xJ9nGMIiR
	PTlBrNxN7pTC9n+9HRlUnTsl8hEA/Mw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Y/rntz9y";
	spf=pass (imf17.hostedemail.com: domain of 3YNB7aQgKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3YNB7aQgKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721953; a=rsa-sha256;
	cv=none;
	b=47PBDGfTMznysFDm08KfOKbOWXFa6gDh7MY6A3tCoci/IPli/hpL90hYrjpTT4XSfCVjnL
	d24BlGJdHFh4/ajWDic/FdxodwE97Bi78XXoEvSj1PPubHQ2zsy9wvLzRCyeHT4G21ygIU
	T9/5l9zUECL+1ZX0vGKy8OWlgkjVPdg=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c43f8ef9bso2425089a91.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721952; x=1770326752; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cEITHmxK+p0fg2PKlGTWLUl48Yr7XTXbjGIRUwhwM+A=;
        b=Y/rntz9ySJeGzha55l/G8ZSp0bMGALkV07AypzL8gARWklGCSwB9LukIix9UyH3LFh
         TfBtQgXCeWdNe3Ki/CmRHFqaYIXqZ26Xbm7UaeOAfy9AocGg9aJ9GzfmYY24jJm91vI2
         w8WWdL1xsotNW2UIv5ZeImjYXVIZjJBDd8s7VWyE3hMLJVX9bTK9zDyuuDyo1xP9n5rT
         vnjjPR7yMKqZl9InHrVKMmLfTD88TgH+7rtqDoXyR66bv/p69bqvTyMLqEulJ7PkqVwr
         v1QDuMzBnKSTGDGdM52bLyYXxORfVbpp11Il1aT4l5FxmXn7XRYKSCrJoZZlqcte1eoz
         YZVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721952; x=1770326752;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cEITHmxK+p0fg2PKlGTWLUl48Yr7XTXbjGIRUwhwM+A=;
        b=s79TIHjWf39a1gflXnAtM6zF8iFCIyJQoKg0j5cbmrG6LMg5l9Ye+zKOn/rgQCxvpT
         UhWH/mdDQrfXeQla6qdhyD3uubRHbFYoke44mfvOEienkRLMg8FNWd3FKQ7zBFWn6LEI
         96H37ijeA1EuD1H4OWN011vPAY+ECIJPN+dqVTiX1xxqfKibgIr3GpEaCbYpJHNJWsUp
         8zuVdDvXCnOTDp266mLC+5pN/KzTX2lEUYIUzxaf9lTVLyzTltET3OelAUNN5/K8bct6
         fe0zAXs5RS+FGMCQWHmT2hk4ibAw51cswutvcDFCK51KVJkolljiItWlYVhAHx0JIRzS
         XyGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCWO1UgG+5azXRuDhm2ouhvR3j6HyPaykq1AaIiwaHeD9wFbSL/T0Fcpe89E0u3rOPjg52SVjx3w==@kvack.org
X-Gm-Message-State: AOJu0Yy+sNhyTTmTZQpp5fAFf2OjyggVCfpASlCFjYnHQZvllUghvDg7
	/XSMs80FUoG2fW1R3EOaCr2ToyIRJbbC7U34b80F/WveHWHhwkOzU3q1Wt/VuXBMW6uic5cT1HQ
	mhQmG5K0402RukQ==
X-Received: from pjk11.prod.google.com ([2002:a17:90b:558b:b0:34c:489a:f4c9])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c10:b0:353:2972:74a4 with SMTP id 98e67ed59e1d1-35429af8f7amr3444629a91.13.1769721952367;
 Thu, 29 Jan 2026 13:25:52 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:56 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-10-dmatlack@google.com>
Subject: [PATCH v2 09/22] vfio/pci: Store incoming Live Update state in struct vfio_pci_core_device
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 8090A40005
X-Rspamd-Server: rspam07
X-Stat-Signature: x77t1d9imjzwzohc3et4xyumbh1r9rnu
X-HE-Tag: 1769721953-299121
X-HE-Meta: U2FsdGVkX19X/5FdIfYCakcK3LtqK1TMqTAJdu9KNI/19VR2wg/eyPO2ohjwgQo6+9oJ/7I8iA83XgtuaOh9iM3/WvB1ip+Nc5yZkVRZT0sp8AVWoAQZCrgs+pzOpE3YhEM8vbWnbBXwUYRARs2y/2CtZEGOwcsqlEIGQDDXSjSeE20zDL+G5jHGFLzmIU2dhYlX2us7zXBJNAmmyI76s/gYxj5SRAipdiK+x0EBf3L1J3pq83OsCwyALThwFrl42db01U/npUEkJMxqKqzGXFv6BjKoGbf/1VhKWUIIm5qlVbcLHX1RERN6zAJixmZDM0UvsF/VuF3hSFUhgWPbqEVoDPxwaePwiqCPabfCv9dd3j9zWo7dw9HaQLQnx6C+cQnxmZDMdu4wwPcxR5oyBLoCFdPdytK2hRJEQJ9eYm8O32LAhTCAR52mzek61/SUX5Yl5tfv8kC1mDLNlaP8ctPSCTDBq4oBC3WnCnXTJu76P0bbxh5eeaURLaR+pKJ7Q5S62viJYFNQ1Xo9TiRdSVJ+/vrJoGu4WuXZGC+c1dgVnP8W72Cy17IWhIzVOQ0Ua9DKklUK5bnsYOMrSjyP0IXXk6TTGyUQV+4LpAKw6Z4IYrWoBRUJDWH1Hv+09kv8WOUCo8ZzHZqf8h3nPHxpGFKzb+/hWmioaziy2oKRIZaQDY+jxSTe2Od1PKvKEtMGkVVrhOOILc0OZCiQipywkCPpfk4D891HWQw5niHmt6m7SyRr0M0RJuii0yJCYzDBbn1V9ECosfdO/DOyoXGSTIoaVV/kJi6t/9klpXKEC9IqcT4HamjGBdrD9n2XITBw5oIAX7adPmdjXZhstX2p9N9DjOY19gHOk/78HYYQN8uRydiJf5oLFsznnXDPTH+X1mX/KUFwgVEVBeg0+Y3ruNNzo+/0hCAEau0MIZ/8Wg29sqkbsc1YIZONTsfDFCWbg1g2x1x41DEarbDXHDQ
 JJaBQxpw
 yguL7ityhayuKG4XqnH5u2DMbDOgLaclxiIMcaFhi6N0c6AlnrNxVffC2N+JUh9WZCgEFJezrH0l5FaOFPlsV5RY9W8PdJFKKzMd7Vo7/WNNUwHDRViDZGzozP4fWmFVH5M34aPDxfrwCqAcdqBF1LDCzUQp72VFN0PLm5pmalQ112m1pKQ38hKcsxS7Q97gLu7d8YR3OatnJBi7dbjaFVOqoPT8sLTtZ0j3QiDsYmONtEp33donB5ItrKpgt4uok5NTf/ROM/Lgy7fxeHcGcFumpyouTTLyK7XsSuQp2UIhQnQO9ozFGGjOehUSmxFQHm2T8dwnN8QdRvdu5t6NJcnDqwLYyqjh1nDlrnQS74IQUIQSgCGYKM6bD5Exk33pznT0SWc9JkrDj/C8M53ze6CjdZIsi75sw83pl0XIRpayrBYyRxehw8JJda/+pOF41Fvgfa0WdrTFBdvpkgbm6E1CuhCjZRGY7Z2r2uDm/5D7fanQ1WFzk79Wrs0g9R/f47ehnAiEQT5A60qsguZTOSSbmXzxVVL7gRK+mQ6MBBjTSr7lseAu8T0gSJRVm04gEsIfSdKonvN4Mo2Ff/Q/WZifF5DWiL9c1bQz6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stash a pointer to a device's incoming Live Updated state in struct
vfio_pci_core_device. This will enable subsequent commits to use the
preserved state when initializing the device.

To enable VFIO to safely access this pointer during device enablement,
require that the device is fully enabled before returning true from
can_finish(). This is synchronized by vfio_pci_core.c setting
vdev->liveupdate_incoming_state to NULL under dev_set lock once it's
done using it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       |  2 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 17 ++++++++++++++++-
 include/linux/vfio_pci_core.h          |  1 +
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 3a11e6f450f7..b01b94d81e28 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -569,7 +569,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
+	vdev->liveupdate_incoming_state = NULL;
 	return 0;
 
 out_free_zdev:
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index ad915352303f..1ad7379c70c4 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -131,6 +131,7 @@ static int match_device(struct device *dev, const void *arg)
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	struct file *file;
 	int ret;
@@ -160,6 +161,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 		goto out;
 	}
 
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	vdev->liveupdate_incoming_state = ser;
+
 	args->file = file;
 
 out:
@@ -171,7 +175,18 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 
 static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 {
-	return args->retrieved;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+
+	if (!args->retrieved)
+		return false;
+
+	device = vfio_device_from_file(args->file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	/* Check that vdev->liveupdate_incoming_state is no longer in use. */
+	guard(mutex)(&device->dev_set->lock);
+	return !vdev->liveupdate_incoming_state;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 1ac86896875c..350c30f84a13 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -143,6 +143,7 @@ struct vfio_pci_core_device {
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
 	struct list_head	dmabufs;
+	struct vfio_pci_core_device_ser *liveupdate_incoming_state;
 };
 
 enum vfio_pci_io_width {
-- 
2.53.0.rc1.225.gd81095ad13-goog


