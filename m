Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384B2F532C1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3386B00A5; Mon, 23 Mar 2026 19:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD7316B00A7; Mon, 23 Mar 2026 19:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3986B00A8; Mon, 23 Mar 2026 19:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3026B00A5
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:56 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BBBABCFF8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:56 +0000 (UTC)
X-FDA: 84578995872.12.0164C21
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8BBE24000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M3voyDC+;
	spf=pass (imf07.hostedemail.com: domain of 3vdPBaQgKCMAjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3vdPBaQgKCMAjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxGJfmbE6y6D4fg7v0R8cmHFXmMbzFJlr4dbGGaFVKE=;
	b=HNvm1RQ6uoyjqhEAEpYxlYdckqDA7limi/xxJzfipvLvR3O2uz1jSRdIhEIav97FbL+0cy
	0ChjIMS93MywuFXi5HjjfPC5n/GJ+bNIIx0fC0MuwD6bo9jsHDcxEe7uR6pCwd8GQeLgFJ
	7+/XTSDN0OwsCQq7lHvuNgBA1ZtfSS8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=M3voyDC+;
	spf=pass (imf07.hostedemail.com: domain of 3vdPBaQgKCMAjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3vdPBaQgKCMAjsgzrgiqmuumrk.iusrot03-ssq1giq.uxm@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310334; a=rsa-sha256;
	cv=none;
	b=iSH2cn5SBcbjI9Q3uBPZA93u4MUKp83dQMCDSfBrR6Ydv/wlpCaHwlRlMFMueh+1zKreSQ
	/YFXtTSzedGT1lFdUA2WiSbnH6FRO6A8AlnyshD8scqZeAj5/7HV7j73V7ZCKclzTGT+UP
	t9aQfOjkVJKzqJ90UjVhVQe2XCCivhw=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3568090851aso10695629a91.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310333; x=1774915133; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FxGJfmbE6y6D4fg7v0R8cmHFXmMbzFJlr4dbGGaFVKE=;
        b=M3voyDC+Xoe4YcsMKoVEyDkhuyuhVEXczLyVOuvK4Hd3d+VVx2B630ENKK1ovu3eL5
         Ftf4rO+8ZflYEKS+n6fEHN6RLg9E/DyV+tHJzLx5UZXmMuqTjomxzK4ImFibvX+5N17i
         xnTdgdTWyEQru0ZA4HjoKjHQrWIR6+C+fWbO2glSwKF2QLzZVnPJSOAQluRrGfEzYEke
         j52XPBwVL0D/q+cs6qRVCTIX9vePFbWDRPNHN0VvT8iKhSa4VxSTe5fyNjNBuAKPWXZw
         EMl0ZbRB5Ii0NUjHb6miy59eLLt95TuaGTq6esgNHFaUrJpMMbNM6CTFnoqk+hUhK67p
         3NzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310333; x=1774915133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FxGJfmbE6y6D4fg7v0R8cmHFXmMbzFJlr4dbGGaFVKE=;
        b=k0SQdpgMGBRqsixbY2ztiWPu9lAyD3MZHqUUJQl95o+D7fbR4tobs8SfUMQhmghbpm
         sOQA2dEBipaUL3J+tlYwVS5N/HLF2881j2VAFF/YEHtrAGgmrU6EhVDbwjmma673WgkJ
         mr1RWEhAOJXpIAc2hmWd2CYUG7XRlw7TNG62Cj0tIqO0YzkPVElNI+XqTzSryYbRH6TU
         eTruBgN4kMYW+cZfdcaW8hSLiALhhf909c0ZfLNAvE8LXITlc1yVHZUyB+YDnBXzCW7c
         kHdoeRerUshulwkNUjL+OTLq1izv9q3UXi5V5KDW3nNevN7V5IczrBMkg/xG3ile1lLU
         elWA==
X-Forwarded-Encrypted: i=1; AJvYcCWSIxBC4ejAu4SsEuXpNcemYCkhL4tFMW3wgbLrFLDPULf7FiFCraF2bGon+fmwdp2nc9Ot/VYncA==@kvack.org
X-Gm-Message-State: AOJu0YyvBa0LXkeS/t/9LwdR2e+FD6TeDG/iDRUSNwqR2NMeINgfDmTG
	m5OA7hXIgL4pif7hsC68kKIG2O4ybWueYKtE082UvJkcwSHLbnkoEGJ5+X0RH7A9B6gvYfirWmv
	8DaT8vWa4SuDv7w==
X-Received: from pjbca11.prod.google.com ([2002:a17:90a:f30b:b0:359:84f3:a9d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:384b:b0:35b:9ae3:9080 with SMTP id 98e67ed59e1d1-35bd2c62dc6mr13468908a91.14.1774310333147;
 Mon, 23 Mar 2026 16:58:53 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:01 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-10-dmatlack@google.com>
Subject: [PATCH v3 09/24] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8BBE24000B
X-Stat-Signature: d39pk4t6uq839smockjgkshaqq9sdwxz
X-Rspam-User: 
X-HE-Tag: 1774310334-159759
X-HE-Meta: U2FsdGVkX18kmyL0zL83B+9O4j9DUX6S++kDiYCJs5y1RE4a7YbwvTsxP9fwNoGCxMfQ7poi/iteinafeUIuC3oV3/qKfgEzhC3u54u4Q7MY9L2sur2hqcprv6sgMfxzvt+oJVcO0ZMqC396+P09lQzBU5PlYotjk3Lr/lBK4n9KXEiTrUm+qlRUvf2Wi5IXmJu+Z7gdZyiSgsK8PuaQk+UvcXYrI8EK8Nki6Z4fVJr29L+z754DkQgKKSFyrl7kBIxSrZjTO7sVcI+QmcjnAvJCc9zMZmzNnzkxncIgbDwwM/Q+lOyyyuBDT1ZL3+Sf13qglXDsIdojvLdEAvtGrqNDR5AU054Mr3wjLPgjZy7tocSTtgMYW89pkJtSXJVo4l/jlPxG/R44YQfH0wU3YtcTnafeTFh1XL/ZVZLI3gLEhzsRroCKOiZw/hlQf4M1bC0mYdGvaUB6YRpCqsSKsL4BEr9O3nZe7Pz6FIKQsuduqnpr2OUDOU5DZ5vYGMuTZbeseRUoI7GWyJFRxxGrXJOIszVU+sSUyWybZ98+xyFwrYRPBzbRl+IGg5wFc8N+AIFFF1KH/n8omaN6fZZuWwowiTS5PjlKpclXK5HJbUqo6Hf+5VtTKrTuDsbhAaryF9I0D3LypWyQsJxDITWRYxhbpuJv9m9NDdcJgIh8RHOpbbS0lHIIxzvC6B6BbCOeLjwlwkenim3bSF+4i5twFdlIsrUMT/N6CMCRjj95kTZ9yvtFG5QTMTbQCNkGmf5SL56wjkG4wn4K3Lpl/oxBoyjIVLMt1/0/Zl2ef3EFzOjVFZ4HPLRjQa71PTasoXemFmEYNllOkPEFDpIuQ5UbdPdwcKy2oa7Ddn3+tQPHxp1QCQ5/HnDZm8QcDO4Du/q/8CzCukgheEa+GIYsCOp6tltgnnZe2f/YOA4/8oDeuZ6wv7n5Q3ABCXcXp7F/vamMdMtz+QMTa9nWNAPDzf7
 MwnC2x2O
 0Ipd2wHH5JdWyJj/nXaii2k99U1tGbOfolQZMOg82Cy2LjVrlwVXrwPwTv/lK8pNlsar/+6fQwIlZg/92FH97rMV1OJdhsrB8qvxSBJL3dfmFSVEvC4zY8/4aUPxH6pbX/yrQliBH4hcgvBuK2GDceZkw/xkWmI4++csH6xY6lK78xdFINt9rqI0Qip9MZftprSc/iabfzP2hFosq6KsNQSUz0mKv2/hkU0DhNCusm/pbrVWrH2EpIVpgop9e+qdB0E6m0n/C0QmP9lFPgieGeuekp50n5YKu2XyjJ+WqPmDeet2Hq+cH0aBz8JBfmLedQCBlZ62lrFd95EqJZxM2do8hOFsN2UBt2f0NKFABFO5uvrUOyjky7KAd3lvZLHznrPtBNZxpAiUZL2OToRaXhBK3aeIdJuv6AoduzHSGhp1F/TOiwLkZHXTkDYv9C+Z9yQFEGYTYwUSkkJDuiZH5Il18Qhxah/xX3gJhIWf+RV2VaTA3OiIeYsilczo5lPOaUTJ7Z3yocUtp/NpKxDH3AB6jh6T5haZ+qa23kfRDCdh90/mukB01NUvLeWcBtHBig1KvoX5SsCm4pVhn1NA/jlQGjHrNBD0vnDztYAiM+ADxzvWd5/oYPohQWpqaCHJVQNcERE2rDI5nrkY=
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
 drivers/vfio/pci/vfio_pci_liveupdate.c | 44 +++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 4b83a02401aa..b960ec3ffbf2 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -67,6 +67,9 @@
  *    interrupts on the device will cause the ``reboot(LINUX_REBOOT_CMD_KEXEC)``
  *    syscall (to initiate the kexec) to fail.
  *
+ * In addition, the device must meet all of the restrictions imposed by the
+ * core PCI layer documented at :doc:`/PCI/liveupdate`.
+ *
  * Preservation Behavior
  * =====================
  *
@@ -136,23 +139,37 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
 	struct vfio_pci_core_device_ser *ser;
 	struct vfio_pci_core_device *vdev;
 	struct pci_dev *pdev;
+	int ret;
 
 	vdev = container_of(device, struct vfio_pci_core_device, vdev);
 	pdev = vdev->pdev;
 
+	ret = pci_liveupdate_preserve(pdev);
+	if (ret)
+		return ret;
+
 	ser = kho_alloc_preserve(sizeof(*ser));
-	if (IS_ERR(ser))
-		return PTR_ERR(ser);
+	if (IS_ERR(ser)) {
+		ret = PTR_ERR(ser);
+		goto err_unpreserve;
+	}
 
 	ser->bdf = pci_dev_id(pdev);
 	ser->domain = pci_domain_nr(pdev->bus);
 
 	args->serialized_data = virt_to_phys(ser);
 	return 0;
+
+err_unpreserve:
+	pci_liveupdate_unpreserve(pdev);
+	return ret;
 }
 
 static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_unpreserve(to_pci_dev(device->dev));
 	kho_unpreserve_free(phys_to_virt(args->serialized_data));
 }
 
@@ -213,6 +230,10 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 	if (!device)
 		return -ENODEV;
 
+	ret = pci_liveupdate_retrieve(to_pci_dev(device->dev));
+	if (ret)
+		goto out;
+
 	file = vfio_device_liveupdate_cdev_open(device);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
@@ -233,6 +254,9 @@ static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_finish(to_pci_dev(device->dev));
 	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
@@ -257,13 +281,23 @@ int __init vfio_pci_liveupdate_init(void)
 	int ret;
 
 	ret = liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
-	if (ret && ret != -EOPNOTSUPP)
-		return ret;
+	if (ret)
+		goto err_return;
+
+	ret = pci_liveupdate_register_flb(&vfio_pci_liveupdate_fh);
+	if (ret)
+		goto err_unregister;
 
 	return 0;
+
+err_unregister:
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+err_return:
+	return (ret == -EOPNOTSUPP) ? 0 : ret;
 }
 
 void vfio_pci_liveupdate_cleanup(void)
 {
-       liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
+	pci_liveupdate_unregister_flb(&vfio_pci_liveupdate_fh);
+	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
 }
-- 
2.53.0.983.g0bb29b3bc5-goog


