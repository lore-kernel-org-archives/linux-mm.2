Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231EBC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:15:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C2C6B00EC; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CB36B00EF; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5006B00F0; Tue, 14 Jul 2026 11:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C63016B00EC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56A5940443
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:21 +0000 (UTC)
X-FDA: 84987730842.06.86BB4E6
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 56EB3180004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pp7TLTf2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3hVJWagcKCNwTGNGLQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3hVJWagcKCNwTGNGLQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEd+0Hxb+fZMWIajq41a/8wnr7549OLbqTKKS2EBeVQ=;
	b=STGaYPV0sEp3oQW+K40YhJJi5zNi4ppIuHWXfsnSx2LY4hQ7ngJ/uSIVwxgF/1psROjlee
	iSxqlVWKftxgac+SjeS56kDFTn5cQw5lqlUXZ+dZBOwoEm4Sb8olHetvck8qY/w+jqoTAG
	ApBDued4DZngxiykLRryJkgFMUZ7594=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pp7TLTf2;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3hVJWagcKCNwTGNGLQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3hVJWagcKCNwTGNGLQFEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042119;
	b=4eoKVBL3cdcsr+unJQWUhxRq2t6icliiaTI1t5eLXUCOKaRWvqpywhB2Rkx8D2dFGKq/te
	sxcArbI/FkViqo5FigYsZgvmlaT09hTrAgoDKs4/VN/NIetr0FPc9cjEYDjhcYg2hdazSk
	pcpHy9eHfOxApJjQB8tUPuoeWHaKE+0=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8487ed7f7beso1391595b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042118; x=1784646918; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tEd+0Hxb+fZMWIajq41a/8wnr7549OLbqTKKS2EBeVQ=;
        b=pp7TLTf2lfSntGkBFNP0KRRAxyH4Nx4FAO2c5Jwoi3QR6+fyQqXY1iHM5SdNq5qYC3
         qjJPQ9Z4Jj6wOhoF0NMhPp9A56b2+28iwOxXiJA6B0cA+AHmbI4Hjsc7XWaF6Amrh64j
         Op5t04raXx06W5JH2xLy7yznVltsRzfPNQ3XdiEzvUk3e4bl6FBjmNq8VnT7P1bzBoFh
         ua+2Rl6HncqzrP0OmrSoSejV3rq7wuPDPhnaZyEqULUoPNJZSE2je+Cz2X4AzGpuCyRX
         k+hG4c4bA5f1Jo1KBTdd9uFK3iM2nKNfxNJg1vm2MnYVOeuXRayVhhgUUzNXi0eGNxpb
         X3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042118; x=1784646918;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tEd+0Hxb+fZMWIajq41a/8wnr7549OLbqTKKS2EBeVQ=;
        b=axxv9UQtwwXKxWg+mQIiqEv4kyLOiKZhO4J91QzIhuYxgUFC7L1BA9AUMO+IVPhTek
         zio31cqEPJOLwo8kY9aiqOiFmKqVqjx4E1LjiMWsnyHgTj1Tnyh7klQXZ6Pxu8y8aYIy
         e9nvu6frefoKmSfQeP/J6omE8Fb5QrUUxhVTGOE3Kw6XR+mMiUrTuKjKj/tZHSdG3+FV
         3RnEbTHvwddQeMzcuGjHuv3JBR4IRn8TXGVzgVbzm2CoNrANO9DbqrCmaSj/DLG1xEiq
         P+s3IWWTpdV/T5+v0hAX35AhcocvfPVaSYlGU/yQY3z4hbpc4F591C9sH2WlDOpou17z
         5iyA==
X-Forwarded-Encrypted: i=1; AHgh+RoCDDh043XuU7FeGTbJeziZ7pUmHEYddacjJ9GdR4PPCyTQZu5uQVs2qdAu4StUtcBRGLPEMjgSFg==@kvack.org
X-Gm-Message-State: AOJu0YwvXSntEI6DLOiGEe5W2FNVeQqpVnMI7X6XjmD96shwa5ciZYia
	u+INcT/G+lZlV4TznSPrh/3xv0yvJrKgJEZMtH6WYE4CEb3lxRmwMwfiUQRP3J5Y2L8ov18cDTI
	TWx32ZO8POQ==
X-Received: from pfblh20.prod.google.com ([2002:a05:6a00:7114:b0:847:86de:a817])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2d9e:b0:848:7459:5f62
 with SMTP id d2e1a72fcca58-848897d2bbcmr12462324b3a.44.1784042117867; Tue, 14
 Jul 2026 08:15:17 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:53 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-9-vipinsh@google.com>
Subject: [PATCH v5 08/20] vfio: Refactor vfio_device_fops_cdev_open()
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
X-Stat-Signature: 377yrxxi6u9xneyrqizn1745x7ragqx9
X-Rspamd-Queue-Id: 56EB3180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784042119-973281
X-HE-Meta: U2FsdGVkX1/alRCYRpza3DlRwvW7xrLq5tVwt8nSumDtLfuMvVnIg+7UkGGO1FHmtWlccf26aXSl9XXZB+sb5uTsJnHF5mMlcOs8KeThYsgCr8QrdCqBNLanT5RjarMjGXl/7xS/k7vXeq5/IAEX/uRhFw6uXUgzoUDI8fG6i++k8u83Vd/jLiEL7IK3YRPvYzUwLSe29iRvxEi3MfNY/LN3tyKogqj1Dp/P11YsvQqLXF6mIeQ1V9H8O+1QyIL/82lR0dG0cPeYpDvXSlWR2ilyVJ/Vs12S27oRjKOj9ssHJwzqH0wXqlpgDvHxJgNEFp0QUSTVYgYLl62PEynhSpMqe4puoW9dDRD1kAzi4aD0eFFQHxbNjOUd4lIw27pOI7n+7eh1NGYjnUfj2tjYa0IeCsoIEt4pToL7c7YQ5CM3DomRuxw1wGBrmmjsglIjD1fN+Uynt5lu7Kc3vEeMFFUphwOVBiyQdYYb+iP67gB6KoL+StnF3IZ8OLlFFkqRi3MvfdoCghdkAhD2TUgnoTW7IT4uFmp9P24eVKUBPX7EmgIxXGPpWwxCWz9ZnQ8ztm/RuNa7/ItOce9bQBzOGygxZWy82w0Xudl0mWMSndLSqbJnGCzFlXK1780T9WUxbqIKmWe8OZnRPlUT/tifhezyuZuJdliMw6po5WuasgUy6wEtIpIjtOCJZeCpgBBcZwwZ29d5OB5OZAX87mOSKszRsNOYE/o2WyF06PZHHdDvDS3+NYMgvFA1WKHZJGyNulrrlSjateYUWynUW10zujhWZPbubptxNqXIxwG/3ls28rvIh1iD7J5X/LhQbmmZEbWJXbUOcgKsxzs9rPWFkF/88ZCqEIzjOO7w4AWSLAM3aTLtiT/Va6i9ipO4qAI763ggWSQqPGwjq/R5/m7eM0bwD2EYojNM4woqsvIH9mMh/zwDmJ74/ytXRjtwUqPjJqSpfj9xDbtgG36midk
 32/jrOCF
 umFt1dFAoWJxHtUbCbncYjog4mF+wo8HmhJq3Yja5w0z0lScuALoi51iS4RXTLjB8JqY0tad85AoX7BhjITSE7oUIXdPo9sDjxbmDmaqT2ujr0Q96PykERkuVoC9UhOy5LiKlIsALdJlCfGlmpRGD+lcAjL2RT5hSxc0fX+M3zfr4JnVeKGrXhiSYnSyk02a6HfV0VwERtSKP8ITIUgyrizgUjFLJ2ZmVZoJAG5lRqpanJQEsku7K5AG7Y8xG9aauxnOU+5kodxlk0cbinARhDXtQKnbcj9t3gpXDfIjhmAcnAenatR0wEZzED5PF04XX+OdAqSvYpw23hLlTw3zeDApRgtrT4poxH2MT2lVinVMZkDFRHUCj4jib7tnHs/MNr4RcDFlnvoj08jSI2ZDMAy7Q7EZTZptter0+W0rDvzLowta/nPzkw3sXv1moGpRHMiOgMPTOYyeCZEXFRzx+eydIWpDrLuoLWNq49cZ9V6R5Avmsy+XKn7DyWGGnVmDQWRzO8tjQb7w6kagjwo0V8yY693Shsp+kzFtDS6OWaAFdCpTBttYybmw36bdFf7X3Rya8KwXpPvDTwrNX3Y4K+VBURaglEC95C9ZywPQrX54eSCuMCgygTo/8lY+45TOsxpn+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor vfio_device_fops_cdev_open() to use a static helper
vfio_device_cdev_open(). This helper will be used in subsequent
patches to support opening the device file during Live Update restore.

No functional change intended.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 drivers/vfio/device_cdev.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 54abf312cf04..2231423fe56d 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
 	device->cdev.owner = THIS_MODULE;
 }
 
-/*
- * device access via the fd opened by this function is blocked until
- * .open_device() is called successfully during BIND_IOMMUFD.
- */
-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
+static int vfio_device_cdev_open(struct vfio_device *device, struct file *file)
 {
-	struct vfio_device *device = container_of(inode->i_cdev,
-						  struct vfio_device, cdev);
 	struct vfio_device_file *df;
 	int ret;
 
@@ -37,14 +31,14 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 		goto err_put_registration;
 	}
 
-	filep->private_data = df;
+	file->private_data = df;
 
 	/*
 	 * Use the pseudo fs inode on the device to link all mmaps
 	 * to the same address space, allowing us to unmap all vmas
 	 * associated to this device using unmap_mapping_range().
 	 */
-	filep->f_mapping = device->inode->i_mapping;
+	file->f_mapping = device->inode->i_mapping;
 
 	return 0;
 
@@ -53,6 +47,18 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
 	return ret;
 }
 
+/*
+ * device access via the fd opened by this function is blocked until
+ * .open_device() is called successfully during BIND_IOMMUFD.
+ */
+int vfio_device_fops_cdev_open(struct inode *inode, struct file *file)
+{
+	struct vfio_device *device = container_of(inode->i_cdev,
+						  struct vfio_device, cdev);
+
+	return vfio_device_cdev_open(device, file);
+}
+
 static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
 {
 	spin_lock(&df->kvm_ref_lock);
-- 
2.55.0.795.g602f6c329a-goog


