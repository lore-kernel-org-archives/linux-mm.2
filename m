Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4E2C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 205A96B00E3; Tue, 14 Jul 2026 11:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFBE6B00E4; Tue, 14 Jul 2026 11:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6546B0109; Tue, 14 Jul 2026 11:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7EC16B00E3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:21:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B02F4043D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:45 +0000 (UTC)
X-FDA: 84987746970.17.BAB781C
Received: from mail-yx1-f74.google.com (mail-yx1-f74.google.com [74.125.224.74])
	by imf15.hostedemail.com (Postfix) with ESMTP id A119FA0013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s+xF1WJE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3h1JWagcKCN4VIPINSHGOOGLE.COMLINUX-MMKVACK.ORG@flex--vipinsh.bounces.google.com designates 74.125.224.74 as permitted sender) smtp.mailfrom=3h1JWagcKCN4VIPINSHGOOGLE.COMLINUX-MMKVACK.ORG@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EHEoo7An3D7oI8NS/D99aTdGzqKD9FxsvRgklpMZ9w=;
	b=w7VAWYxRo20AvtXAhfAytmbGlXkHuYekSeZ1jitk9xNIQiGOBagQbdlue0ZQYnelGd9CmJ
	KpwQDT11wBJX2WU9opH/uhxm89xQ7lwTH8BkURsJcxgRXdilkNlssXQW2wb8MFNf3340CS
	I/uwEUSQkggbY4ZZ68OG6jLNsGyc+V8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=s+xF1WJE;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3h1JWagcKCN4VIPINSHGOOGLE.COMLINUX-MMKVACK.ORG@flex--vipinsh.bounces.google.com designates 74.125.224.74 as permitted sender) smtp.mailfrom=3h1JWagcKCN4VIPINSHGOOGLE.COMLINUX-MMKVACK.ORG@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042503;
	b=Q3I4dRI5vDpy2qq3AD62iyVdcfQOUc545DlGh1HoAah1Of8+CxIY3ehT+3/LL2eLLkjs47
	R4NRbYX5jZOjNlD7mXio9QKkl8tUGlbBmE9nwDEx4gRgQX38lcN+rK0xujfu/SvEfkf3Wc
	TJ0dV4AHFUcdp+w2mfnHyiyp+hQ1Nyg=
Received: by mail-yx1-f74.google.com with SMTP id 956f58d0204a3-668095be86aso1482202d50.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042503; x=1784647303; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2EHEoo7An3D7oI8NS/D99aTdGzqKD9FxsvRgklpMZ9w=;
        b=s+xF1WJEcPA///JfS6503oZLnx1qZgmk+P405/Jh0szjsK3RVOzXL2hfgIQOdvJPrP
         SXsRKCWCGo913KjxDkCLXr9DZCGrI0554QHzDbWPRP4u3wYqwfz5XsJFZy5MT4Y6LDnB
         CEyNYLO0kunmPiY1bZaq96BcKovOjCXRkpRNtvmHcAKaYK9nziuPCQWVApD77QEwOZsL
         GtTcP0iwPGUENsLvnluylec1PUn6cdXOcFyE2hGsA6Xb5XvaNZ6N2sgBEk5kQRAsdGoM
         8CZjCRHeDy7x67gRylEB9+Clj2O2RbpkmK1vd6GsioO0Elddcna884xYpAvcvuz5Yzvm
         3Qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042503; x=1784647303;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2EHEoo7An3D7oI8NS/D99aTdGzqKD9FxsvRgklpMZ9w=;
        b=dRS4c9Eib9CGBqtNkMT7I/qo1xO0utt3QhjcnhKZlbh46JkoNVYxTpGK6AxuEwMKKR
         a+cr0cGTdWgQs8EDaZgvMk3W07lGLK0Rkthj0cBTdyQ5dUHK4DbQTpvQa1y+mJZhwgjQ
         s8oka0na+uvb3E79h37DYPdJm65Gdjq5fgtCAVQMQeaakBx13X2dDAmmsf5qnjZpB1We
         sPqTBCW0OSucTsFHYpNiD2ItyL/c6VXd4OJPnai5YrNiFheYxc5XH8FxBz0EDHOp4TR9
         HouhXOpWIiEvdmsa0svsftYmgUIE1UjiMlLI3/IrMGg62Ng/o6XKjtO+3wMu/SVmAtgu
         gcRA==
X-Forwarded-Encrypted: i=1; AHgh+RpM5Cbddbd24n3MscYxaW3hKW6G3QAIMsPLzQdtLIOryrK3Jm+kvCgZydvR/KuYICzRjD9m05w3RA==@kvack.org
X-Gm-Message-State: AOJu0YwRmqqn8vWfEQGcejSB67vOTAHrTC4iG07vAmPHaJRWGdyVekuN
	aqOSzExqjoY6zvZG78B8db1IAc+Jr6wkmUdYhc5F9TeNQ/JjmmdMu9CACAx6X/TqakClKwAOkRw
	f98VnOuq3KQ==
X-Received: from pfbdi5.prod.google.com ([2002:a05:6a00:4805:b0:848:4690:d658])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:c081:b0:84a:2d5c:528c
 with SMTP id d2e1a72fcca58-84a2d5c562cmr6425028b3a.61.1784042119955; Tue, 14
 Jul 2026 08:15:19 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:55 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-11-vipinsh@google.com>
Subject: [PATCH v5 10/20] vfio/pci: Retrieve preserved device files after Live Update
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A119FA0013
X-Stat-Signature: jyrrssf4xms3hrc3g8wxi6wnmnihbd8x
X-Rspam-User: 
X-HE-Tag: 1784042503-744991
X-HE-Meta: U2FsdGVkX182hSsCMNPm6J3+/FFEvZg47q6A7yLxShPuzVdx4pl9DJ0OYspB3yJg7/LWKQ06Fjt5+Ap6OE/AwYbVufHqOGO4hNfyH+rJ/TYfa3S8EcskNw3/mA0Y842dy2Ika+VpC7rA3HRaeFI7+FbLGtF3yBTcO6VW9X6YetDsmi3VC7ZZ9uRSQMMgm3ssGn8gIlokFYlaXOBvGevee0MtiyDAfpsKTMU7fiiIpE8mWXGstv5OZyEDhHYMrv+Et1ph/ek69TclNjyE9tws9R/Tcco+Yrv27i/3Wy1ltDvZSdmqGyjmw83dbJ5B8sM87fzxTTPh2POpraAiXJ2cmxXo2B+OshMooduhAM4VFDzj0jkJn2PufqJ+zTSkOxe7036P/ehDJb+iE5dsIDGCtCJDL4//XZyIqRJjbxpoY4xKqkqX1tHjM1xYMIbkw6QsN7fVVU8S2COj0+90zScD24tBNZhBzUsdYfAkjiSzIHnUw/OJttKUb4rd8ARzs1NBLIt8SU97z5LllvrFkixZrNUzkBdK1vGMLUO7tEQw4uaHbn6SI2yUz3/2uvZeiytkfL34UqYaZQAuwdY6MNDLNHfIQNVRswaBMd8EiA0UgB1fix0zpkeHGBxbtlUYAVKnHoPtlRr5SwJZYb/MEahxrCsev68AB8XlpWquTkTrNQ875A9xn95661I/FtX5lSIVEsy1Lal/mDLr0zB/OMkobK4g5dVUk0RApuVxh6KsV5C+tAbT3Mp4rd+7yTC6DaqBXziiPQTXVUrMI5rZZEELjs9OzphLiCj1PpFwGlf9IF6qf3zyPB/9bnnYTZcr0oaBRRg1TvAyLvFZfsbpoMJ42GrzXL0VbZS2J0Fgzbr05rkZOc5KtTf47RkHv42fK3lZh2O8W1OAEhs1ZwuAkm6yevQFj/I8ya6xfowRG8dP3NESHgyRfZqeDfo41esl3AVTQrZAyrI18N5/mwGnkBY
 5QjrkaZc
 ZKVfaOe2i/c5VhMxWBKxMcaQbIGffcbBzqKdiCF7t3XF1e73xWryavVj5sRY2J8OdjYAHvwxnJQf8KX/vTw44k0KJ22AEczhcdkARPyGfMvfgegx4xFvEcxfdoSgDq8Ug+zyxcINx1QGLUFWhVQAug57ZAtRfjk0f3Nw5POMLvv+TzkW7wXU1DNLLJx+J2ZXLAag3Jlgr38CXE9Zu3IP0E93/oG2fkORYV1+nec7hOvkFAiNtfxpiyBPJqFaXWML3rbwA8vh31oLiMwD1H5w8SFJ9XdOKfYKSbExJWrjnk4FjXIl6+Q/PoVokDNsPn/wSxZf5c8zI3McgVhqvQ1KYqyo4GtREWdmrqXR20a1In/tgA6eDrVAsdfeEv0JnZI78kM2JC4vmDgFJaTPsgyuERrWOGIk6m8vw5jQ1fuEABzjafTG+pMz2zN2AyZ//StdqIkYyB0A3jKEr4+tlye6r0jo13epRylyd3PEoHvp50I3gnR8xviLV17EUR8+98sc1SXEFDFfdgejURz8G8kp5quCxJTNWhet2tF3hql/k+JfviEiAVpEuc7biUbCiq2WclyBltW0vOni7xjIu7+hYGTiuQyqPCFpVvhbleMqVvGqQbRFf15sEHU7Gtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable userspace to retrieve preserved VFIO device files from VFIO after
a Live Update by implementing the retrieve(), can_finish() and finish()
file handler callbacks.

During retrieve, find the VFIO device using the BDF and domain
information from the serialized state, and open it using the new
vfio_device_liveupdate_cdev_open() API.

Disallow Live Update to finish if userspace hasn't opened the file
successfully or any error occurred during retrieve.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/pci/vfio_pci_liveupdate.c | 64 +++++++++++++++++++++++++-
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index e6eb7f6b53d7..4baac80d03f0 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -39,7 +39,13 @@
  *    preserved, so there is no way for the file to be destroyed or the device
  *    to be unbound from the vfio-pci driver while it is preserved.
  *
- * Retrieving the file after kexec is not yet supported.
+ * After kexec, the preserved VFIO device file can be retrieved from the session
+ * just like any other preserved file::
+ *
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg);
+ *   device_fd = arg.fd;
+ *   ...
+ *   ioctl(session_fd, LIVEUPDATE_SESSION_FINISH, ...);
  *
  * Restrictions
  * ============
@@ -93,6 +99,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
+#include <linux/file.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/vfio_pci.h>
 #include <linux/liveupdate.h>
@@ -223,13 +230,65 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
 	return 0;
 }
 
+static int match_device(struct device *dev, const void *arg)
+{
+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
+	const struct vfio_pci_core_device_ser *ser = arg;
+	struct pci_dev *pdev;
+
+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
+	if (!pdev)
+		return false;
+
+	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
+}
+
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
-	return -EOPNOTSUPP;
+	struct vfio_pci_core_device_ser *ser;
+	struct vfio_device *device;
+	struct file *file;
+	int ret = 0;
+
+	ser = phys_to_virt(args->serialized_data);
+
+	device = vfio_find_device(ser, match_device);
+	if (!device)
+		return -ENODEV;
+
+	file = vfio_device_liveupdate_cdev_open(device);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto out;
+	}
+
+	args->file = file;
+out:
+	/* Drop the reference from vfio_find_device() */
+	vfio_device_put_registration(device);
+	return ret;
+
+}
+
+
+static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
+{
+	struct vfio_device *device;
+
+	if (args->retrieve_status <= 0)
+		return false;
+
+	device = vfio_device_from_file(args->file);
+	guard(mutex)(&device->dev_set->lock);
+	return vfio_device_cdev_opened(device);
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
 {
+	struct vfio_device *device = vfio_device_from_file(args->file);
+
+	pci_liveupdate_finish(to_pci_dev(device->dev));
+	kho_restore_free(phys_to_virt(args->serialized_data));
 }
 
 static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
@@ -238,6 +297,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
 	.unpreserve = vfio_pci_liveupdate_unpreserve,
 	.freeze = vfio_pci_liveupdate_freeze,
 	.retrieve = vfio_pci_liveupdate_retrieve,
+	.can_finish = vfio_pci_liveupdate_can_finish,
 	.finish = vfio_pci_liveupdate_finish,
 	.owner = THIS_MODULE,
 };
-- 
2.55.0.795.g602f6c329a-goog


