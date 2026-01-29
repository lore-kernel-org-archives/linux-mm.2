Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B237D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B6066B00A8; Thu, 29 Jan 2026 16:26:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 991596B00AB; Thu, 29 Jan 2026 16:26:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838EE6B00A8; Thu, 29 Jan 2026 16:26:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5C3B96B00A8
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:15 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B829B7426
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:15 +0000 (UTC)
X-FDA: 84386284710.01.1A999DC
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf15.hostedemail.com (Postfix) with ESMTP id 73244A0008
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rBpSReQM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3dNB7aQgKCFc2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dNB7aQgKCFc2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uE4aM7+RnwFNy7PeqMvvBM9KOovOI9GoqBkQFV8UcGE=;
	b=2n+YocYAaVcabF0kcNGIq9BzR4tlQ+Rdk3Rl5RH+UeMBjFj/vlq0SvX0E5UCdNofmgVMac
	95TjT2IZCJzKYAj3svJL9uJXqWNg1pE3XiFgLEqcfQy1zsDtQJmlSnx9oOAm195Isq7DdQ
	p21lMVajP9WHK0N/omQ20wgus940i80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721973; a=rsa-sha256;
	cv=none;
	b=yn4xosatP0igLkc59BAQge60Ofa0GyxDXZdqZA989PH4DfmZZj1SpBECc9+KQ8w7YGf6A+
	TrIflTwEhvfWDEqCu/cVq16OXFe/SJ8sSuQoZD/8doEmad+kukci2Rwt2mFe71AYVEWTJz
	V9TitYmSTxGH/KLt+lQYS2Pn4ufG8Co=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rBpSReQM;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3dNB7aQgKCFc2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3dNB7aQgKCFc2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c5d6193daso3265144a91.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721972; x=1770326772; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uE4aM7+RnwFNy7PeqMvvBM9KOovOI9GoqBkQFV8UcGE=;
        b=rBpSReQMvVs4E9yUgsyWOXolC/SMSPfAIJXBbrPKTBtCfS3TtoEph7QJzWu8AYzN9k
         D7xrpiBzdToEH3ofIjEg5G604hYEnFkXxMCVs4pTKAhgHMGd2QOme4WX3vdEttIXfYQ7
         ynB5uqsfo+P5JllJbFYW9Z9NOvWpRYQ/uSjS2Kdtnz+AEc5rvveXUG5eRlkWeVqcLD7+
         Y1fOpbOaaAPKiRWcToGAzIslI2z2heW8sNl3gxzoaWyPJJr6tKcpqutn4Xpc54DLJ7c/
         J238TRGmJgg02ZzhFpi4KJYMVIoKe11AcN7WH0eWzVyx6RMmrZNz+Yab3R65yD8qTjCX
         jU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721972; x=1770326772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uE4aM7+RnwFNy7PeqMvvBM9KOovOI9GoqBkQFV8UcGE=;
        b=JnJqq8cEGAWZE/MO5U5gDecWhKWlW7kmCN9UZvoLnzZDDYiIglgKtYz66vfutbUCrF
         7Bjya+c41F6dNtHZnhVIEf/uShJq0rAVvvj6uU+QJuoHabvkt6SOGQbvstgNnDlOsCgJ
         pzW9lxbZA+4opoQMoJ6tf18h5AZxvLCXCKjUAqT1OtmUe6iapjyAm7lM1nEcjM45SwWZ
         GZNCl/QJc+lBHSLEQj/r0EDzMIQ718vTk2hIGzpnk7uXrndxuf7XUhLz+RiHCLFAX9jE
         Lq5+YHJZhs8pirXWI4o99QMOtK0Tfx8ccEjYztswpXSohrX4FTFZhY0REBGmNeOuxojL
         vT+A==
X-Forwarded-Encrypted: i=1; AJvYcCUF79pJ+THd34EP3Sq6aKBKFx55CqTq5L9AE5yEgmWZ/2fKWZxoWUoQknyjEaVpYC/rO03VfiDzJg==@kvack.org
X-Gm-Message-State: AOJu0YyhJJvQy4TpscKVwLQnCpqtGLwRfRwROeHO033DmXSclrI90CyR
	jjPN+VqFmFARgtIqjjve4EpcLYf206nCuFRE3uA5O0suIlpOeutSHXgcsl+3YWxM0tw1Mh+hbwi
	WV3J3iQvhl9G1tw==
X-Received: from pjbok5.prod.google.com ([2002:a17:90b:1d45:b0:34e:795d:fe31])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:388c:b0:34a:8c77:d386 with SMTP id 98e67ed59e1d1-3543b2fbdccmr728738a91.9.1769721972187;
 Thu, 29 Jan 2026 13:26:12 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:08 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-22-dmatlack@google.com>
Subject: [PATCH v2 21/22] vfio: selftests: Verify that opening VFIO device
 fails during Live Update
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
X-Rspamd-Queue-Id: 73244A0008
X-Stat-Signature: igwryaeb8cjkuwi93mxg7e64qp8mgneb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769721973-106488
X-HE-Meta: U2FsdGVkX19GT8uNTuZkGLdpGUKCeyMAuxgDtfmMmWGnRBArkbrFVzY93vTmDieE4YAFr4E8UoXH2wT3+uVWn9soCHozHKYBqGk07YZz3OKHbgcfdHEkTk+Z2eqcZ8Vdf0lhK9oteIH0+ylykZQutNaU42iBEHLzZubJUbRKZUH83Z3MQgblViT8t+8w55iBQtieQYcgD5YclJ2AfMfDDa5JA2snpQcFN7WrlIVYlYDZdady1VVXvVEVisY4fpJAvarZWX5RsdOZ6esx60fcmxJJ4CYTfvdMTyh9RFze2qJN05ifOedptBtUVvyTeIyJfL5pfqUtBitzcCpzRIx27QB7xObI2gL9izHJ4x4GKYeUjP6LnX88HjsYCMGYnR7rQ2KyvW1T8eGSd8seC3LCID1zDSvAS1Iuezn1wsq9HoJ4DzLigXikgAtuKUQsOve78XfEgX3GrrCa6IIrYvd/V9nSX9I5X8qKOa3Aks3kNtapk7jT12tWD1KwBYDW+T4F96oUqvKeHWIrsQj7hNgQdVgbeEYXCClomfUR2aqtmAe6bdprQlwB5lMMXMT9+L21uafbJg7p4PEQkVBSo80kYH/ED97u8M4DTmR+SKHXuSVOyg2T3kcGHyc1a4s/sCKHhzlF0WT8RoNqjvStk7leaDBVWWNBu/CWRfbVB1nBaX/mm9knr8S6uY4yirB8JGTZtlxdZbYkXoCm+4fEt51igCuLfBGXernxHJ5LvGsuVI5+S5vYafi0Y/t84zW3fmCgtd4KgStzQM8xivIPRIHOo+6bfUztOYgOPCHE5VSoeCBKaRodxLO1WQUh5U+tSN3RDdFlqB27jvSYt+akUbmq06LSRlUVdGIPLE7q550yMn9mxVDHDCgYOdqBq1FFY0EvgGEF/zACK1qhL8hOlsdgLM1PfdgAUuhvImv2oq2kP8UVvVVrpukCLX3+HpHILkAHvPpfTMJJqrFatbtceM2
 ytfTly5L
 6IS4npej100UJhmQJv8TYOOQk8jTIxDUq9XPYNlOg/fShUppXClHgC80zvpUHhwvxnXnPzGVgVr8oT4OeXtie5ILB9OGT5MVEB1S89/+e7NVXxzhAXoxV2ympRsdS1yTmmwcxCYtFOsB7GTRmvzGfw5gf54ddTvTQOhMv5YmnvAIkA2RLffnV+88JcJfpjtbqXY1DwhvFWvrY0nBVTT4+TI+NbBlQJbcLt40MqdKVKmNAGIC04pgBGqw2EqWgsr2GuzRfTxM8gIHhUIehZ3oRuIylRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Verify that opening a VFIO device through its cdev file and via
VFIO_GROUP_GET_DEVICE_FD both fail with -EBUSY if the device was
preserved across a Live Update. When a device file is preserve across a
Live Update, the file must be retrieved from /dev/liveupdate, not from
VFIO directly.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 38 +++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
index 15b3e3af91d1..65c48196e44e 100644
--- a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -36,6 +36,42 @@ static void before_kexec(int luo_fd)
 	daemonize_and_wait();
 }
 
+static void check_open_vfio_device_fails(void)
+{
+	const char *cdev_path = vfio_pci_get_cdev_path(device_bdf);
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int ret, i;
+
+	printf("Checking open(%s) fails\n", cdev_path);
+	ret = open(cdev_path, O_RDWR);
+	VFIO_ASSERT_EQ(ret, -1);
+	VFIO_ASSERT_EQ(errno, EBUSY);
+	free((void *)cdev_path);
+
+	for (i = 0; i < nr_iommu_modes; i++) {
+		if (!iommu_modes[i].container_path)
+			continue;
+
+		iommu = iommu_init(iommu_modes[i].name);
+
+		device = vfio_pci_device_alloc(device_bdf, iommu);
+		vfio_pci_group_setup(device);
+		vfio_pci_iommu_setup(device);
+
+		printf("Checking ioctl(group_fd, VFIO_GROUP_GET_DEVICE_FD, \"%s\") fails (%s)\n",
+		       device_bdf, iommu_modes[i].name);
+
+		ret = ioctl(device->group_fd, VFIO_GROUP_GET_DEVICE_FD, device->bdf);
+		VFIO_ASSERT_EQ(ret, -1);
+		VFIO_ASSERT_EQ(errno, EBUSY);
+
+		close(device->group_fd);
+		free(device);
+		iommu_cleanup(iommu);
+	}
+}
+
 static void after_kexec(int luo_fd, int state_session_fd)
 {
 	struct vfio_pci_device *device;
@@ -44,6 +80,8 @@ static void after_kexec(int luo_fd, int state_session_fd)
 	int device_fd;
 	int stage;
 
+	check_open_vfio_device_fails();
+
 	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
 	VFIO_ASSERT_EQ(stage, 2);
 
-- 
2.53.0.rc1.225.gd81095ad13-goog


