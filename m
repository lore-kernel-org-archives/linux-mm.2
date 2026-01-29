Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8B3D73E8D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:25:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625516B0098; Thu, 29 Jan 2026 16:25:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF146B0099; Thu, 29 Jan 2026 16:25:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 460A46B009B; Thu, 29 Jan 2026 16:25:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B7526B0098
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:52 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF3A214026F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:51 +0000 (UTC)
X-FDA: 84386283702.22.ABE46AE
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DBA2C000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aTcWs5m9;
	spf=pass (imf22.hostedemail.com: domain of 3XdB7aQgKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3XdB7aQgKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVUDzL5NEoLRiR0kq4rtjTLHEzT2c4a+QSQgWmkEpoo=;
	b=bn/PB++2smJh33btmxIIDIT7D+pEqCKLGNnZu8WxY455scRbaN5TQlQZGJMnyaCpd5tajz
	1glBr94ev0G1JT9qYvkMkpY1PdMAJkTNBL0dNcjvto7yaBJYS0FI+7OcxH9LpGqB8aWluK
	wGqD/1HAmTd2dvFjNNBDYwjc16ERGbs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aTcWs5m9;
	spf=pass (imf22.hostedemail.com: domain of 3XdB7aQgKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3XdB7aQgKCEAfocvncemiqqing.eqonkpwz-oomxcem.qti@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721950; a=rsa-sha256;
	cv=none;
	b=g4boil7RSHQ6Ys/lgUpCpboEkJhvpU3XlpLIHrhtB3kgS41K66yxYyuy5gDnAufVx3FDLV
	a82h1i0hbe6tb2CM2apPFGBi952xnWRpmrsBoe07kHxGrVl0ExgeerIF0UcVGhI/+nF+Xh
	lR3CIe6zbwzYKAQsP6MyNaaE9dmlQSQ=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0a0bad5dfso30902925ad.0
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721949; x=1770326749; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AVUDzL5NEoLRiR0kq4rtjTLHEzT2c4a+QSQgWmkEpoo=;
        b=aTcWs5m96/dMl95p+tcvStu+ZIwWpj2TIX7hJxFWkp73t4IDpP/bUEQvR0n0vNOAt/
         EXGcPw1X11IUeupmRLNbU77pMnIKFNNBaAEqoz+8LF5HN1aifA5T60CvWxscj95K3cz2
         1ps776NCyKXR+jJ/igsIAPpp8wHrXddsZw3xBn2w4xGfHudLnJ07P6RwF3OhxRO159Ak
         m0knFuCok7je6zW2W4Pmsd3kD7CtfUBgZQiDQmFlr6F/m2VRR3EdgtMdD8w65TJHWYjo
         f5yH5ZueASa2QTv3XPXcLt9aheWez5evZ3CsuVKDzEqEUJx63N9xM/+EM47KurTedJWs
         H4GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721949; x=1770326749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AVUDzL5NEoLRiR0kq4rtjTLHEzT2c4a+QSQgWmkEpoo=;
        b=iwVp6HDG1yDTm/6vxx7gEf4oBgqzyfh8E719ZnNiqbvVb5tXSU9XyBkmenbEl75xGE
         YsDW/97uye9J/qI5iBIL/5yIqTGZgHqPCGXAh3UiDUekXQpW33y1sCk0Wujcs9JLZ14s
         MTGaBdAr/D+jnze4MDkswwvITCqoNTiajmmx/eeGj5tof90F2rxBw1XhE6yOu3OBlRVV
         VNbqCe3AWqCV0TLoQoUc/jOVHB61JFnSsIf/lAGIrMV59RhxcMSkukKAllepYYpDhBok
         6ELahsOMG8Yso0PWqOXzDI7Nqsb/T7yz9Dp4TNJZ3sbt88RKZiwg1s0D/0dgUsxdpdYF
         GxQw==
X-Forwarded-Encrypted: i=1; AJvYcCXsK+co5oEV1lEY5YA4kXurXOL+yrtsKR2I5NvJszkYfe3aNetKEjVtbVCMcv3TQodfGYckMsgrow==@kvack.org
X-Gm-Message-State: AOJu0YxVSsOF/mErqIICsZRpZKJH1LTSAhhvP5KyOC0etfCiYwPfshNY
	vm/IQAEotNsWXSnwtkCAtDkUrWpis92Ou7fPefFwIveyiOux3PG2TrkUfoV3/8AdVgkgy+F3d8t
	McG5/Bg7QIRJj9A==
X-Received: from pllm10.prod.google.com ([2002:a17:902:768a:b0:2a0:a0e0:a9c3])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:124c:b0:2a1:3ade:c351 with SMTP id d9443c01a7336-2a8d959a4bamr5657375ad.2.1769721949051;
 Thu, 29 Jan 2026 13:25:49 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:54 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-8-dmatlack@google.com>
Subject: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5DBA2C000B
X-Stat-Signature: 1xfb9dyw99r35icik1ar3eskuwkgdn7t
X-Rspam-User: 
X-HE-Tag: 1769721950-221181
X-HE-Meta: U2FsdGVkX197sZYnzdVLY4k5uGEfWDfFSn0zT2/RdlZkhRv2yZDqQI1kx2SBY3DSINY1wTN5dIB7c/2nfGuAWalhfb5oc7r9xOwzB6z2hMtu5iGzufGz4J9kJqTm2JciMkrDRLPJZIOMIZRcLqKXrkH3bOeRq9LTAPxSVyoJT1sVRHpvEu4LAsORPva2/AMXHa9vQTu1lnlCIAlTOc5qBBwtxNZcx4eNFGjgPIi0K+9blAYVsCHV4LZ1fnx16Lc9bKYWTxRdFo/Hizap9kUSPfKWIss8nvnCZTEKTUMnqI2popjr8p05TphJMmj0YyDQoReuugxdSZGm54UhV2R/XuuyzC/4OQ1lJx2L7I2p4Sp3YqNpL+sIfyAS8ZLGkUO7GBmxA30OYnPIKmLJjtNuSrrqfU6fGGoSNbTtlrxyw0STZHZSeWYw6ar1SXzpd+xp5DPQw5cOnGlMPh3+AOZcs47VX22OwuVUzB5zGglJU/a8IPeyVN/LmYGk0qjXi7YcPRS/xbyswpJxyMIZEfb41E3WS2hhuy4ZHy/rXXQYnkh2F1oc/VIizsbQkBa/xf8ZN603WDkJ3cKAzFwymjP8uNq3nHgxSsvghdn3yxkX5gsRYrwSYruDBd3i/CNOSgBjIfldMLEOTRgKuJOeckcBCvYrRjvzP/DxTPPQZJoEz314HRarXW2QECCNFTIidfukY+ahGaFJFpgIxsUQKneeWrrIZJ0BAR6/tFbYHvUoGVwNiO4PtRZRenEr5EGOSCNUT4bEO2rR/wufPh0Q5BoVPdsedGCyQS51R1gOOGeuTvh7zv9xZY4KozyxC0X9qysC9nr03wRTJSSRb0urdTl4tk73ONNvjLcu5IdnavP93dkCjxTBVZycuu8nNdhMunt4ka4nVPrZQDoLzjkXMhVkREI2qv5yhxeto/RhoW6EVv/jkF/VeMa9ZEr9ZqKM+VFlgR0IdM2ykbfRq1or9uH
 vwGT8TjL
 AVQvZcn92IOpUugJBMlrY1y82L0/QZcldEPIx47qWq8S76ZLQZIKRM8bA+DY8mgkfn89OVaJtb5qsarT1CkNDg4BDXu21TbdoX0Jn9fy+9px95eQ0y1z2uPnv+NibRvo8dzDyCscff2/c6Vhyq9jdJCeMJVbwFS0V6wlrZ+HUONwqQAZqFMCkz8mlwThp5CXEvA6B/Q+o3glrOzJMg8qQvDsxWFTdKS18+p470dJBBDXx6tJR0cwC6xb+BcP6MMSaJnkCeqxjFAa+LbX2y3nLpInrng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Notify the PCI subsystem about devices vfio-pci is preserving across
Live Update by registering the vfio-pci liveupdate file handler with the
PCI subsystem's FLB handler.

Notably this will ensure that devices preserved through vfio-pci will
have their PCI bus numbers preserved across Live Update, allowing VFIO
to use BDF as a key to identify the device across the Live Update and
(in the future) allow the device to continue DMA operations across
the Live Update.

This also enables VFIO to detect that a device was preserved before
userspace first retrieves the file from it, which will be used in
subsequent commits.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 7f4117181fd0..ad915352303f 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 	if (IS_ERR(ser))
 		return PTR_ERR(ser);
 
+	pci_liveupdate_outgoing_preserve(pdev);
+
 	ser->bdf = pci_dev_id(pdev);
 	ser->domain = pci_domain_nr(pdev->bus);
 
@@ -62,6 +64,9 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 
 static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_outgoing_unpreserve(to_pci_dev(device->dev));
 	kho_unpreserve_free(phys_to_virt(args->serialized_data));
 }
 
@@ -171,6 +176,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_incoming_finish(to_pci_dev(device->dev));
 	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
@@ -192,10 +200,24 @@ static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
 
 int __init vfio_pci_liveupdate_init(void)
 {
+	int ret;
+
 	if (!liveupdate_enabled())
 		return 0;
 
-	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
+	if (ret)
+		return ret;
+
+	ret = pci_liveupdate_register_fh(&vfio_pci_liveupdate_fh);
+	if (ret)
+		goto error;
+
+	return 0;
+
+error:
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+	return ret;
 }
 
 void vfio_pci_liveupdate_cleanup(void)
@@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
 	if (!liveupdate_enabled())
 		return;
 
+	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));
 	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
 }
-- 
2.53.0.rc1.225.gd81095ad13-goog


