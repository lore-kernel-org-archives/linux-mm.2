Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 012D4D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6003D6B00A6; Thu, 29 Jan 2026 16:26:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EA16B00A5; Thu, 29 Jan 2026 16:26:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EB876B00A6; Thu, 29 Jan 2026 16:26:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 306256B00A4
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 036C7160144
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:08 +0000 (UTC)
X-FDA: 84386284458.21.6E41B9C
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1F8F0A000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0JjrRTGj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3bdB7aQgKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3bdB7aQgKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721967; a=rsa-sha256;
	cv=none;
	b=e5HSH2kMWviTFGKmcBBnrS1o0cXICw9LUedZMAPENOeiqBXzObpj6g+4M1g0obFBLTvg+x
	+Vv6jt4ke8mXvxM0QuzNqSQhVHcizeWf3NGJIAwN+KPEdgDyhBPNYZc6hRC/+02SOU6xKr
	0zSieCLgZ1QAIigKGjw6HcHIsRauRHQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0JjrRTGj;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3bdB7aQgKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3bdB7aQgKCFAv4sB3su2y66y3w.u64305CF-442Dsu2.69y@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEyO5iRGiN+9INh5ffm6tFBNJ0ZoJ+9Z1mvOjrL+acQ=;
	b=56E4jpuvwYGC/zXCcVKgznSN7jCa78+uA9bZTVhlVz2CPEDPOzhXk3ALpi1iE+ZmFZETin
	T6Msa9OtWTGhDxMrFlqw/+knwRaJUQdiqY7frO/m0N6nSOJiPawj5odP4VW5Q/rvHku1fE
	mZWtAAxq/Rha6u2c1pQlNbWMqFYlK64=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-352e6fcd72dso2299876a91.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721966; x=1770326766; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lEyO5iRGiN+9INh5ffm6tFBNJ0ZoJ+9Z1mvOjrL+acQ=;
        b=0JjrRTGjX6qqOKDk39QIbdJx3z4vEmixXyGGvUfpXlN+MGeNwWtkK9B9O5LxeaE+Dw
         TVqTkaDlayW5+WTInCaOEg4FbHQqqOSnB47Lhx+jH/mtEYIe4+47XIBhDyasbtcDFvnQ
         /fFylwkbFlw1ZWM3rFxUNioLD2KYeI8Hh22QVuPnAZlCb5LfM8EBqeR7Ju9Qlqjstml9
         RNo6zJ0sqDJFFxgK9Bhz644uPwSIdu9rZxrsp3ScAChwXFNBqjsbEIh6HtDad2J+LkZu
         XLrbUa0TiJtzFVN82cC8xpzdaFRSELFuNkGbjrKQQwadnvONUyTCk40rgov5YQNWYs9p
         Vh0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721966; x=1770326766;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lEyO5iRGiN+9INh5ffm6tFBNJ0ZoJ+9Z1mvOjrL+acQ=;
        b=iAgEY9VODfdvu5JhcMc0oZDfYE0DnlIhJpFnqmd/tWyv4ZWZaI6zcdPJnWBgr1YnXS
         tqVQ2F/g1lakSMpMJmvU+yuLY6bb+OIgsUPjcbhFf9nSKCIv5wHsz+14sxrcoghruROX
         2+MyjzMTisMUy8I7V/oJ0eFwPeWSDTGxBNAEUQsMecJx+pP/NebpOrYx3zMAvfa+88/X
         yGWS0UynMbg3UZMpkf5CRuWfgr3jACMP5V4W5eZBbaYMfKcdGCD2WPdmIUBqv4naFSiu
         4AOIyKGjwFbcVsVWCGMjULPPf/ZTEFFElrSAqx1gThOIuWNyropuAAUupgZ++z5CEKCv
         DF/w==
X-Forwarded-Encrypted: i=1; AJvYcCVZ3YawXd2cc/o+GznDc7JxXya57YcgdVRbc3ktrnWEv0ZEuuCuC/rqzlTwZHo1e03UW34LRhx8tA==@kvack.org
X-Gm-Message-State: AOJu0Yxzegm+aoOqNjJOBwQWHzT4e9mUr/RBATdwYeEToYxSpYpQN8z+
	CnpDEKV3cyYsI4He7V0PwktgYLlymERfMZHixxnHMP3VUp5S1uAIO4A/CBDtZzXb5ZGVkFpN3uO
	0TiKxJ8UoBINiLQ==
X-Received: from pgbdo6.prod.google.com ([2002:a05:6a02:e86:b0:c08:9db4:d5cb])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6f89:b0:35c:e441:e6d2 with SMTP id adf61e73a8af0-392dfff5a08mr409686637.7.1769721965922;
 Thu, 29 Jan 2026 13:26:05 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:04 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-18-dmatlack@google.com>
Subject: [PATCH v2 17/22] vfio: selftests: Initialize vfio_pci_device using a
 VFIO cdev FD
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1F8F0A000C
X-Stat-Signature: weydunhhy9s5e9twspa55i3wnedjkwjf
X-HE-Tag: 1769721966-872226
X-HE-Meta: U2FsdGVkX1905u0/cWjE/HIM4LIFPlZp4d25tMLA1b10ZOr6nqSapYJ0yAqEX1oizpdeA6y5nyxxQ+OGmIkBSLorswqz5KgZh4rvS9seMttQ7EEsTAhmhZBzpGv1owdmgP31oUoe5/D3G/zHjh5uFQWBQnW3ZjmnyCY5hePZhz57UNNJvyAa4STNTzJFIOANAuIohwlXEy5uXUzjcV4gPT9ljwYBavSu9SgjoRbxnZ/Z0Fe1XyjxLUmFPul60486ryEI+i3RH1OYO6HAc0qC1aRu8yeBVwHub6VF6OYtUouwfSyVzsRLFp1dPYOXElP2BfwIbX55fCvXPNJVPzTd56Bqn4Z2Qmn4HKulvqiu89eWYLoWJSWQaLsb9JcagqUJCDesZqSerGOYbgAI9klQSWIwYelVbteM8zDBh90kewWcqJjqkuaDxg/XDWf8nGaUipnStUYF86Pg5qkZTi6g+HCjPs0glvkm6R/2OCrs9NT5EloG0qf5OOOsp4gC3eGRHZliHcnPq63+6OvNPJh5aeWZ/pBslyqpXsWA/2jmodePZV3CL68UVruchDnW20PIWw2uK3rdX2ZU8aRXH0/sgem12efiv2fzwhWHIhd5lmn+HMdqEHVcJrZM/nyYtHRTODg9tIzQhbgkbIn0jIKzVJHbhhLS3hGeFBM+uE2fIkFftdszR2HyzsjY/UR9WQM3sMoEOPPIMtDrIRqTSH/lDIWVdSOOnun0PjxMkzhjI7rVLyloGrnSqN/fP2lLvypSGz1wfNQgLBZiljIWyOI+QASuRKgwigUGggwDMMpAcMKHC24ykkb/zkwq145eCQvOV1Zm8y5ymRImM4vNwQKFBNEktQmdKBN6EoDTM8pDzOrn/NhiLyTfRrY8Gdq+juYkfiEaYXbnhDYOppBvmaNZPUfBBsGMvmLDqr28F6U3aeUsEh/BH2jKKYzHxnanVs7DAIL629CLlaKemYQ8ED0
 mpcqH2Ry
 REoPWmFLK6WVTLeDB9MXNvNEXaUv/x1H/Jv/0hLuWKTbrhF/8joaK0m2NpbXf4gV/la4pySlMFMlZQuMoLl5/J6s+927orWGQMlVd803g2vJFqsiJJ8o7MeA8JQF9/k3J3wZmG5u7Sis4NjfzzfFZZVcmefN4tO6IvrI2183GJe/rXx+qioF9fyx4KyT41jRoJYVYcW4esyFeeUEwYHQ++Q4mA2Jz2+jFsmn1GWj9W28ForqKeeYCjkrU3nnDZG1YpQQWoGBP5nqm/4gYI0tLtxxqcVgG0n/U0JN9248SBxUuqO5C+r45R14wpl1uSsvZn1g6DpPkrA1yzL489vvh980fmo5cOFrID/Y9g+cAiD6Y4y3GH+kWllOSVzC+7KGTJ8xu1rcpptJaDTEdBNnrrUGA7QP+SSK0aCjAfRypd6DJnrLxmN1EH4o65O1Noyy+urEKd/DcN0qLu1fGN89UN33oYBWiNy1AgdDes1FrrV3qSvh7jGPUKcBuLceCn08jRKbopwD/AwWJyXNHKIUQXkBjYsGby7aj4uPt337sC6Z22Jm30Ymmk84wreFMoJZbNllJ78ClGeLz3pjxwTPcr/gOnKItZaQ7TtcZ21VQBEdsZkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index fac4c0ecadef..08bb582eaa8f 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_device.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_device.c
@@ -318,19 +318,27 @@ static void vfio_device_attach_iommufd_pt(int device_fd, u32 pt_id)
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
 
@@ -341,10 +349,12 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
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
@@ -352,6 +362,11 @@ struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iomm
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
2.53.0.rc1.225.gd81095ad13-goog


