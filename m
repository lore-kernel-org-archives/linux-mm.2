Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72252D73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CB356B009D; Thu, 29 Jan 2026 16:25:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C946B009E; Thu, 29 Jan 2026 16:25:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704176B009F; Thu, 29 Jan 2026 16:25:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 531116B009D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:25:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1ED1816025E
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:57 +0000 (UTC)
X-FDA: 84386283954.04.FDFD1E3
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5BC241C000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:25:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="SNpX/YGz";
	spf=pass (imf18.hostedemail.com: domain of 3YdB7aQgKCEQjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3YdB7aQgKCEQjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ha2krivTi79qOGY9TNrpoF2Kn7NOugjkcaAbsESD6eI=;
	b=60V9XHANOqzgVtsbw7Tn5gxiVDvD9GJ2DxzfBwyDN6yxPbwENKKdscpSp+JbVkZ9EHajqt
	yWgve/APEnTfXEXpO8EQkPfaslJLHsA6J7oGQO13g6UCMdT0GxGko530JVuxEaM1PLJTJj
	hwcsZS0k315COEgBfkmrzsYWE7urYZE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="SNpX/YGz";
	spf=pass (imf18.hostedemail.com: domain of 3YdB7aQgKCEQjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3YdB7aQgKCEQjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721955; a=rsa-sha256;
	cv=none;
	b=n/9d4nB8QPE1eUb3kfOMCbpnVgNbK3pBCpulG6a2lPfyYFqUx2XEDGpCM7pf7jAtrF0kWk
	vwsEbBMNdBKzlpdqPr8CLn2vWw88rRuY0Z2im5X6iu5XZuQ1rgrKff8VZPUoyEwTNeGWln
	bLIyg/scDKMSIKdy+VRrjh9sj7fYzAQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a13be531b2so13517595ad.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721954; x=1770326754; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha2krivTi79qOGY9TNrpoF2Kn7NOugjkcaAbsESD6eI=;
        b=SNpX/YGzCoV7BmyIIxwqOMOLIJtKBCxQkNGUDH+nHwjZ9VAldDqdnj6Mz2cbH/QKRd
         50/dUaPwLeVlWY3rhWqv28sFpUB3X2BqBN81SLDG0AsBdvSLQRY7W/PBO8JrxxewnV37
         HZT0o6RCpeu/yllnoTrBmNhUS5rXe5xkgZYisa3SYijI6Ht4CO1rFtmwlMOvinnjQV5o
         2CNvgwn42ySSE7/e49g1BFj9GVzYH3g3KEtnVGkxWi+MPO5urgFLbNKz6TX2SMpvsNet
         y91eKtOjB258QQTarvlySghWPJdF2G1tmft/xQ9LH1fJdrsjrD0GdZMi1vwatCUMPUX/
         wZ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721954; x=1770326754;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ha2krivTi79qOGY9TNrpoF2Kn7NOugjkcaAbsESD6eI=;
        b=dj0N89pnC6ygRiY6hHpWS89GrFMuO8nMSTnPo8ViQchQvRBi3GJrnMEiQGDMfpTcJG
         MM/4l45GXHlJYYNq3R8h+GyDGs5RhWonxqzVDlK3rT42qI9WZabE4Rck9wPYPEgQeo0e
         NlHFMqBUqDftg37HBgdIrL+Sxp11TOOpMUsQhISG70T3F3uxGdh6akPTWF9lda2PM5ac
         zCbFiSBk9aRezI0t4OGvl+fLpTpGAPfJ73/uBRqFa2JoEkmZTeWIm2yiB1DOa4csDSFE
         zRDS0xgY3kagNgAkEvkaflofs5CkIw7vCkxJtRbrChNhRReTzzbkHWw5TRZf6Vy0urai
         hiqA==
X-Forwarded-Encrypted: i=1; AJvYcCXvQ1x7RRCgeBL5Xp3JDx2fYlW5XkhA8fkr62cm7ORp7cl5tA0FxCrit1xc000SMLTBoBS62L+0gQ==@kvack.org
X-Gm-Message-State: AOJu0YxMXuUTkAinX2vp+6TIFSgvltour1RGIkwcBAIH/HME0tfGnIdx
	2aX3Mexgk7zSKU+5WTVqTTzJ+iI7C8pk3tb8MmfBePsm92AdLcnppehiAn3m7QxBoJmQjz5ARQV
	EFjBA6J96fsf47g==
X-Received: from plba14.prod.google.com ([2002:a17:903:100e:b0:29f:1fb1:be7e])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4c9:b0:2a7:99c9:1086 with SMTP id d9443c01a7336-2a8d9a56c95mr4558805ad.47.1769721953965;
 Thu, 29 Jan 2026 13:25:53 -0800 (PST)
Date: Thu, 29 Jan 2026 21:24:57 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-11-dmatlack@google.com>
Subject: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after Live Update
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
X-Stat-Signature: scma3dbmadshw4et6g4378idbq7nj66o
X-Rspamd-Queue-Id: 5BC241C000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769721955-919727
X-HE-Meta: U2FsdGVkX18u7Suo8Yk1dne/9JzcSLpwO+fNzfJF6M2l43cAYxlSs9Hc+oLkeePEOpyAg5qYtwKh6wyJ9U4fwRyH69LYmBhpDNUVClZUcaac5xAihh3V+MKV5O50fjB9O2TyqJ0j+goPPLhHEny3LjJbacgMDn0wWZC0N34x4v6wEuKsZLEE2lqDOEDWFAaSI8BhMJr5mFgRsn9HQ19bNdVx/YoutHqqFcuETh04RCgL0kKvY9vWcG5iywGENn2eIzWxj9lO6NZgA6pjQlkkte6BQi9q9k7rDA57nylLK0xbfFbjw1D7WVxJfRKB/IhM5r0XwOP5JphIjoHI6t4VkwV4bU1VLYypT+WAxCUrwHtCrvO0756FPQFlPB+SQbP2VKRZHyRvic6Oc2dPngQWls9PnTxb4QkTigkZNKORGFGgniq6oCZGclskhIkZYpIwcVzInux228j05i4ljJhN+Ic9hEcT2dddqe2xOVEXOdF2DY4CX7asAQSU9QN1HuO+v+ICC7VDUUsLN3+1AXxLEs8CtOwnyI3J1Twx7Konat8ueDDfWflxxTrmNbejzOqJwYqoboyO/NNSJEdElaejxhck75HvYTXFEYaY9QuydLb0RaYcDb20gZmolNIRoLp4bzQkd4kNGtifoyB2btWzb5E83pw6PBWy1gVhLc7X0vyLmcYEexNk1ggIadqAt0ql1mxIfx399vSDYtwYdo2VXZ2QUcNsj3Aga+xr5bsx+ZeFXUSxKL2gW2l/VLDMj0riIbZdUiq6B1Fgd1Al1g+kheDP43Cj8uHpVomQQKMXyplApX42HLW7Py3yeR452DTuQL51h8bVawe3tUWReDA5HcaHPNTUQ1g5HdJJsCX1iPmmTAxu/rKB7i8E47Q8+8+gSdW5Fu+rCkUHWPMecAPr3HBYi+ErSOOsgYdg88zhXQaa4E+uVW6sXwg/KDI5ZcX7V7bWVc+HCYPppJEhZUt
 dm+i3RTl
 vVPtgVSVLF3q2WeSfdi1gZt9Pid4sguFIZsdYDgopzyfz1Mf5P1gBtIUwsfa3McfyEpQaU86D1HQWDQKa7XHQVX4AD7XkFtLk/yhO5b8tUCLq/pQ+hDW5ttRdHAYS+rdT6PgWKF6t9z5C93WaCcUpboSIRGdEc1Pi1o0YGRmlHuRXhdXa1YO5wP/BHKgsLFybiu50/G0cX7xk4BXY1R+4/M3ffTbz7WcIWjlDUgI5TpdW/KK2L0PRBxOrn7E1TijhQzF3dKoQXt7d//YjGaf7PNGV1sID56NSgrpAOg8QT8VC1OvdmBw1kh89nhE7R1AwvS/CDbBWKlr37ogcTE7qBAA6d4TJ87G7kOdDW/6Un+ICnEwWYm0gPEHC2wD0ctw80r/bGvQH8XlywEbKhKxvmyPjqojdROEKVxfZzaFENtOyHs2e4P9dYcCoTYDpYTbRnORs/0j0OArb7/QZJRmRKy0PAB0E958p0h+B1es5n28ewv3EQCx1Tw4XQs+hTCnxvjuQfby1QPHFpXrsnwIhH4FcB1+WhSFZATpbo+9Te2J4r10yK3fdIa5mA8Pzki8Cl91LSRlev7/3lb4EV+nO8D0IsKxWk/hWx0V6j2lAM1sjKYdWidXI+PoIPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Do not reset the device when a Live Update preserved vfio-pci device is
retrieved and first enabled. vfio_pci_liveupdate_freeze() guarantees the
device is reset prior to Live Update, so there's no reason to reset it
again after Live Update.

Since VFIO normally uses the initial reset to detect if the device
supports function resets, pass that from the previous kernel via
struct vfio_pci_core_dev_ser.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       | 22 +++++++++++++++++-----
 drivers/vfio/pci/vfio_pci_liveupdate.c |  1 +
 include/linux/kho/abi/vfio_pci.h       |  2 ++
 include/linux/vfio_pci_core.h          |  1 +
 4 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b01b94d81e28..c9f73f597797 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (ret)
 		goto out_power;
 
-	/* If reset fails because of the device lock, fail this path entirely */
-	ret = pci_try_reset_function(pdev);
-	if (ret == -EAGAIN)
-		goto out_disable_device;
+	if (vdev->liveupdate_incoming_state) {
+		/*
+		 * This device was preserved by the previous kernel across a
+		 * Live Update, so it does not need to be reset.
+		 */
+		vdev->reset_works = vdev->liveupdate_incoming_state->reset_works;
+	} else {
+		/*
+		 * If reset fails because of the device lock, fail this path
+		 * entirely.
+		 */
+		ret = pci_try_reset_function(pdev);
+		if (ret == -EAGAIN)
+			goto out_disable_device;
+
+		vdev->reset_works = !ret;
+	}
 
-	vdev->reset_works = !ret;
 	pci_save_state(pdev);
 	vdev->pci_saved_state = pci_store_saved_state(pdev);
 	if (!vdev->pci_saved_state)
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 1ad7379c70c4..c52d6bdb455f 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -57,6 +57,7 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 
 	ser->bdf = pci_dev_id(pdev);
 	ser->domain = pci_domain_nr(pdev->bus);
+	ser->reset_works = vdev->reset_works;
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
index 9bf58a2f3820..6c3d3c6dfc09 100644
--- a/include/linux/kho/abi/vfio_pci.h
+++ b/include/linux/kho/abi/vfio_pci.h
@@ -34,10 +34,12 @@
  *
  * @bdf: The device's PCI bus, device, and function number.
  * @domain: The device's PCI domain number (segment).
+ * @reset_works: Non-zero if the device supports function resets.
  */
 struct vfio_pci_core_device_ser {
 	u16 bdf;
 	u16 domain;
+	u8 reset_works;
 } __packed;
 
 #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 350c30f84a13..95835298e29e 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/uuid.h>
 #include <linux/notifier.h>
+#include <linux/kho/abi/vfio_pci.h>
 
 #ifndef VFIO_PCI_CORE_H
 #define VFIO_PCI_CORE_H
-- 
2.53.0.rc1.225.gd81095ad13-goog


