Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05301F532C0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EB156B00C1; Mon, 23 Mar 2026 19:59:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BF696B00C3; Mon, 23 Mar 2026 19:59:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614F26B00C4; Mon, 23 Mar 2026 19:59:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB566B00C1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2093F5CD97
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:21 +0000 (UTC)
X-FDA: 84578996922.17.B4C4431
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C74380003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:19 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eSmgaNPD;
	spf=pass (imf02.hostedemail.com: domain of 31tPBaQgKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=31tPBaQgKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR2QH2u4Z2w+nCWLa7H/5qSEeXCYEvILvD5RlzuPkZI=;
	b=tejVYLIcyQjX4zi/bKZ5+dIoF+7T7ZDcmbItowTGIPmuQ4KMo782Q8nRwj+O1M9RQNyfG3
	zHosaEeCSXe2Y6poNm53Ak/gfRX8MiWZUsPkmqVbiGNLA2n8kSpTRb5jw7ybMwSVqbQh/r
	yrVgsQC5Kk9oBsl96i8q+8Qdnn9z5IU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310359; a=rsa-sha256;
	cv=none;
	b=x8Se9TauOGxq/n9DfqpN2jnoZnvGv3Mmr2lda7GolvcP9BX6ibcy6FBta5MZRZANr4UxjS
	/Aha7jpLs6xaUaCeGOXg/+sGRKJC3e9YRgUCqpmjnEJYNvFsPH4Y9KkyPaZ6x+TaGDTw24
	QPAmBy+ebozsnPxGZFPOCXV5lz2DUiI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eSmgaNPD;
	spf=pass (imf02.hostedemail.com: domain of 31tPBaQgKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=31tPBaQgKCNk8H5OG57FBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b06395b7a7so58797275ad.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310358; x=1774915158; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sR2QH2u4Z2w+nCWLa7H/5qSEeXCYEvILvD5RlzuPkZI=;
        b=eSmgaNPDA1PDj6Mszh6GPkinDk4Yo5ZnvTpEDuAUzF8tnqn/Rp25551Y8ISjDbF2l5
         /hkFgECMgmjtKROuMP/HKwd5GTHG6AS8GCggt3lJYYOg1rdIHXogywakT4kR6qS5Tx1x
         rzu4tCwVJft0k5deCNV19ZjFm7hU8Mnou2nwG2yKOL4bO0OaM/xiBXMh/r/LZy8cEqMC
         YdisSHHznVsz3J+8NlY0YRoFgOO7akEFT1js/C7FmZ4nFuDeNkGuvjkrl0mats9QQ401
         jQyiliTr/FDEZeZmGCbFIsYDN34+jDEmMs4wYY82QqtkodkMwV6yeBkQdfQlNTpLO4tZ
         vZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310358; x=1774915158;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sR2QH2u4Z2w+nCWLa7H/5qSEeXCYEvILvD5RlzuPkZI=;
        b=S49HPHzA7Md37R9ddnXOmTp1wdOUEkrq2ChW7wLbKC4YcjvlxOf46C8k515rkG0wBQ
         TFU5CHR1IVz6bW1BhmuHMu3P+Slpoj95R9+q6AyFfMqJuhh1zOJCI3pZSdjg3Y5c/3k5
         5nrgWmcfoMa/JKDqRADyTBDYvaBNowxY9p6s1g5O9OxP1QaF8QU9wdBZrF6V+YD2m5SF
         HlVHOqSICYpCv6lom8kGTM7Abg2eOc8sgD7jPFFCISKTrTIsjCKXqdpWOCoRXOwC87jk
         uWBCDVnvunTKyaMBq6E/IC/lCk7FtWDY0K5j5IszAyQRgiMV1MJBzVrtGG57VDYSQZrL
         RCzg==
X-Forwarded-Encrypted: i=1; AJvYcCUMhAs2WSIpVxjM5SoTfKudN7gvnb6XpG8fdPu3lVwaoobONCorTJhUi3KDKKQGdVvCkT54ayvxjQ==@kvack.org
X-Gm-Message-State: AOJu0YycxhpSJzI0jK0jqWtNsN74nTJQqzWbYR0afpRDJUsPj6Um1V2S
	5zUIomqrBEi8DUNZQOmlq4srzQXVBqDv1EKdUUW0NxpfUugqMIfgFGv/JOD4GUnZ8l324Ss8/Cn
	MH7q78/+dYUsXDA==
X-Received: from plge5.prod.google.com ([2002:a17:902:cf45:b0:2a3:1bf9:d25])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e84f:b0:2b0:7114:23cf with SMTP id d9443c01a7336-2b0827dbc37mr127246635ad.36.1774310358090;
 Mon, 23 Mar 2026 16:59:18 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:15 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-24-dmatlack@google.com>
Subject: [PATCH v3 23/24] vfio: selftests: Verify that opening VFIO device
 fails during Live Update
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
X-Rspamd-Server: rspam12
X-Stat-Signature: ctbcu6g19awy6i6y6pom3pc4kc7h3s8g
X-Rspamd-Queue-Id: 6C74380003
X-Rspam-User: 
X-HE-Tag: 1774310359-660748
X-HE-Meta: U2FsdGVkX19f1828YCKg0jPliRCfIdfwmth/tvj/P0ODTI8p/1OZDPKvMVAIQF+jWr4E1eAQon/CfCiqCQiwVuUNtIjlOTcMMRmzph1UmEgrYWsha0yamsIEVzz1OfbrSxtamhjmMH8Hf7i3tSFYFRb350vxOz6YaUq9lm2rTj1g4/SoqACHfmGBWH3cLuOysoGyru+81tIWkJpVSc0uPDMgM5/d/UptG1l5y5iNpqYyactjDyH9ovnEOECS2TgNCTxlnjrVjLdJ5wGVgoDYEJP+/jDFzjjuDWaEt61XlNuq9MajdKn0uk5YQyWW11Fh6Gnc6Maaof+boFsqXAt+3RV3HwMtlujL9tsO8Qh4hTsHlKbLZTcgPBjMf0PbyLXHFIds1DWMd7v78pwgolUxEtnPbDG2AE/YM48opSbXzWzDGAcAqW0ZnUXWpszvaRwIWdiMdgLmzafZVuOjBztPKnE32Ac0LBKYhhMcES19MlfnCa7/v3l0rTcFXcuvMQ8YXx516DvZmaI+gYJx8Rhdb4Qkt5ggRFdQo6bLEltFvZhIBilEw/ug9d6xw4Di2enfiDB0VD1QIXqbbYUqrirp0uERDLU+k3VIvNy2/enRwDZSGKRlb/nW4aAXV5o7fvI9POC8govgvx4rrHbhNkn+YL8r8fIgQJmtwRU6lniyitoZ9m5rQ2tcktXRRYZC5yZNDKvnPaxQ6bhDfj8+gQOR/ZdXj44E0lH+1kjLm9y8bCY147r9F6skl2BvwcYiXAo+yjJ/tNaftxU9RcjPizpbKUu0Jp3sNPZvf2zPylhHgBviI+ZtfaoAitNcqE/9M4ngyEDOp0eGj/8mJYKFMS0773ZrfKnMLzjBhPC3RhmIrwLDso+RNXhAQbP4WWTCCNAnR/6Wk21PtUVSaBivTs1yn2NI/hOIBXlbUO9FnCL2UQU4w4ba3x8ab4g8jIh+lhn9fLBnYANY3YzYZDQD37D
 JQhdo03A
 at0eL5QAZjk7THAxAJ1jkqVltTJpIOG6qA8kZCBJib94PVIllF7Gb0diizdlwWz/b8S7epii9jgmrQJCCiBvqiuLR5/ypsP9jZEdKIJCj/LLu/0iDyuKwXxvxqFz5rABm/tQUdorQggtx+7xaVk+iKDv0PzXhDfvXCZxA5t1y/unHOoWFeMbQHDvaFCJxGhJV7yRW2o8D/Zo/XkUbwWblmQQeQVv9VNwyLe7Ejx0BrBVzh3T8m/vyVK98/8K0rnMYmMwiCrjGa9dvsj9M+94702xVUp2HjN2EEEUkrx9jwWcAYpeQz5aeB05GJ7d6Zr9OkFxkufHM8pnjb/wpPFeoDjLp9M+OyMow/RJOAfAoZyGk6MdkpA/bfh8yGo5xudzplIidmW03pRFIhmTvViLtPfal4mK6iLTHuOZegLaNAthLFHIQ9vD6MsSJKun21GHzpVKGBKcLbuWk50kWOF9I9t0e1jzqcDDx5Ub506UuGUxcNiSNMgR8grsxGOW70Wf5I2fx8d4tId2sfGs9ld6XnHCuchH7A0sWvlTSW9ahq5/V1/ykCFI3vUwJRo5irW6jCj351s5TBS1wlsE=
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
2.53.0.983.g0bb29b3bc5-goog


