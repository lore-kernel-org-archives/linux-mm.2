Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 379E5C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FB76B00FF; Tue, 14 Jul 2026 11:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836DB6B0101; Tue, 14 Jul 2026 11:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D78D6B0102; Tue, 14 Jul 2026 11:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE2B6B00FF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABA0F1C03B1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:30 +0000 (UTC)
X-FDA: 84987731220.13.2EBB407
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC16680008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eXFFZ4m3;
	spf=pass (imf02.hostedemail.com: domain of 3j1JWagcKCOYdQXQVaPOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vipinsh.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3j1JWagcKCOYdQXQVaPOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042128;
	b=t/glZe2d/0uAeKh4JrWdCnKiphoO8MSQMk9N1AA947l/i9LsKm4mcPgRImq6CUYaMlhmKa
	KgOiWZ5D42NvW5YWFvTFp4aPMWvKtIPfhKTbXV6dT7IXJohyToVruJ/5o+leZkkbW2jCET
	orc0XrHPP4qtqQJ6tF8eX086yprLTP0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eXFFZ4m3;
	spf=pass (imf02.hostedemail.com: domain of 3j1JWagcKCOYdQXQVaPOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vipinsh.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3j1JWagcKCOYdQXQVaPOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0/6OkiDA7soDeG3nK/kM6W+DTMONIYlLqtJZ7GmGRw=;
	b=Fp6/UxlD2NOr3sB4lhlmyaCj4JADsjrRy5tX+X5bXe+ZQfIbX5H9MqOhp5y3ngZ9Ce12J1
	VaGAIJecSJKhtgDAGJgjg27Qg76D1SIG+JQyuQYLT3pWqMad2mC+eHaLDbZ37e00MdiI24
	bWYWq8EWTBkklQ/NnJQkO6q3W4v3jkE=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2cee1ec30f2so16902065ad.3
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042128; x=1784646928; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=M0/6OkiDA7soDeG3nK/kM6W+DTMONIYlLqtJZ7GmGRw=;
        b=eXFFZ4m3uauroDHSlHqals+aqSig/DyFwqEvFhVhifKewahBqyr6T2K1mwJJmFZSB5
         wyQrDzhHjQ5wPfxAs4ll/0d6aRm0eYV6c2M+JcM2CXmzxdBnsrg86jpVXVwWKp2W0xom
         OcW55qlAyJV7GUWxLzb3Xbe6dbaxtQoiihgClaow6424/S9If1UE67zjIdW265LLpSs9
         zD6HCwP14pUMEhZ0s28ZemNXpObVheSN3OBRwSK7lJH6tkLzCFj+K322NOsbsAd+5ldw
         iHrUesTE2uPljnLVsyZfjL1xTSx2gdQQNlOlnhbN0omJ9d6HEJSm+FnxjlyByigJ8TgV
         q8Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042128; x=1784646928;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=M0/6OkiDA7soDeG3nK/kM6W+DTMONIYlLqtJZ7GmGRw=;
        b=kEJqx8BwD2vHVDI/7NEU8VMgh1y/015HowwBv0KrnMao34ujUYcII3IySm4qAoc1rv
         Usc1SIltzym+ZQKB+D1oL/Wb6xUesLH68azCN4p2wIKGXLuwiNLFY7tCuXWgCV8Pt0aq
         +9k6sjjZ1YH7fq2U5SLZ2GtFCOJldDvrGS2YA7+fQbHv3RjbrnvdPY77mbPzDVRdP0pU
         QaJPMt7KBMCpQsEnL097kkVn4CCf5pq7zx0f642hwPV4HLqp+dLCOspDAnEVGjjwiuqs
         rcwksxX4Lg3FrA7cWoDJgqckBxsp+c2Do9urMhMTmPohWxbe1p7NtfQ+Ds1YKmRPdLna
         14MA==
X-Forwarded-Encrypted: i=1; AHgh+RrLYAFIjidmKsrMWwFLNJbg/G5G2Hsv31WeT5qX2mhTmQUyyT+DyZBSrz8P58XNgHoURvUtY7tEJQ==@kvack.org
X-Gm-Message-State: AOJu0Yyc0VcuwDqsRSFXGJZ/K7RRCvEg1Ggisp52kfg+6a731U/Ih+dq
	adxaabtf6hwtiHXGji04IMabtpV3eWbBvRDK/ayWDdn0Az2FZ+WMQ7v6Aa67UW+eDvGUyuSBYcb
	zIV9RwwnvNQ==
X-Received: from plei5.prod.google.com ([2002:a17:902:e485:b0:2cb:d8fb:3da3])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1b08:b0:2ca:17a8:cfce
 with SMTP id d9443c01a7336-2ce9f2852b2mr140988325ad.29.1784042127310; Tue, 14
 Jul 2026 08:15:27 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:15:02 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-18-vipinsh@google.com>
Subject: [PATCH v5 17/20] vfio: selftests: Add vfio_pci_liveupdate_kexec_test
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EC16680008
X-Stat-Signature: 6yqc57wy9fi91zn3856inzhmdx945dur
X-HE-Tag: 1784042128-878185
X-HE-Meta: U2FsdGVkX1+nj+aIOlfjkLX1jiluBE6xywIGuxbsMLv5xV/iIv2795ks7qiRgpCWSGkOpl5zJ8Hi0RdYKB6r469MuXLHfdHD3KGG9C3eyaJ0nPcy5m/NOmUz6Desu7i/KXkXIzRyLMQr0Cu34WUuEOkCuFGbOmm4Ptan1PDqf48N3mubMeNNMsKwzn10eBmSSMHu/hPaO/zcCIIHh1YEBE4haPmVvfq5UXz6b1kqeW+nKlZTJ/TFIZqvXjs6iuCuGIKPDbQ9xYiA4fHD+jc7AaDBCUhn8hMAD1HGn532srQJVau5UOK62N7vBf1lugKKbMm/v1CQj6EZNhD9Tu6cFUpCLHYNTCKSu2O3Ad1hkhHHopq/EfQrSJa+sUf+MRDrtJ5V8deV3rxGGJNnltAeOgKmwZ96G643cPtiOANhtECgSbL0kKOwEle7FztJ/2WJiTODLkcGWAADLkt47TJbL9q2UVtKkfGDfQaYyf1oUHyrP5/yFVS5I7aDjjrdZhw+kDIr2wRWpUkrvKxeNBwGx1gknKB25tyxS5Maaw2rG61C4FRJSYV8pGXS8TMqCfY+T89wakMVjvKmHPZFqxGSFjkMnWCT/Fa55052fjkuphPlSU402IoNC9JCXZiyeG62meMIbxu2G70wFiKhdkbX//0oT3jNtbaqFL/yVB/W6wE6R3rpbUuFk346zajTKI4KIwsTJi605ztLlgoh5h4v5UyIl7WA1OoMY0Noq5EfOhEkaz+e8CeKJGdjuCL9tCgQVzM1A9p0actRsBYXM7/TvzZSTxhr1rtLtf3J/99b7CSumDSGx2yFFdUncm3bXCQXLRcU2QyDqJk4NAWyQYlrN44dml3f0UiYl42WgjHKxAKjI5gyfoB5FxDRgl4LS42p1UGILO+g9n3bNXoD1WjTNtUCF8L2I/yjziPWQGVv+VsTWPNYPJ4z10VNZstCTSSV0639KesB/5tcIG7Jobo
 Fqj00PFm
 X11w9cliMVKV5k6SI+LeYGgsf3OLM0WVVktq7cxa+vtiMSKD0bMYzpeU1nh5Pwght2AiOZOCl+3+lx4voaJGhFxHCn1L3n5kIWQyxpcMrCydHkMQy1YKtoRxh5tZVWq9okVtxoqdeRQzS9nvi3mIaAn3OQJ0U2wWFS1YuUf70UzCYNLrIIA6tUlyp/Jl2eSwu3tQu9dmwzM7sT8NmOEDPYj5dTfrvlXShgbpWSK9U8DM8xZFk0Gw42FBWx+KZBkNm5hVIw0mkiYF8Px14AIgKz4CbxYX98MdjhyNkbNhb9F+v5R2j2e0ULqz7cbRbHokzYqpLNgcRdC12Kv0XWHJvahogA2b4KdDFU4HJz8J6wYlM+Chf5+IaDy6hFgRb+d2w+xebNp0GWKY64H+EqhwMPmHvyf+m3AKN++7+UnymDU7q2GFsLGFokfhw+s7Dglxwj81K3jxzZwn4MRssdLY09Tlsi1Z6A1gDGcchCNeO2VTQFUQ4bPIsjEMZpHbiTt6inHK0MD2bTJSkUrlWRcxlHb8bmEEMoQQEidD9hwASGdGE/evFtWxHNd3+v5AxT5dqbULAlorHGQlCcekzyotjAXQJu5J6kIP2ODo7S8w9coL5SYUI3l8VJogZeohr7pM4A9GHG1IdVemruqIoiHglojEtRkXoiWi9zvTIkALlAPKhcVs+pdAgVZAmssnIsy0IPliw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest to exercise preserving a vfio-pci device across a Live
Update. For now the test is extremely simple and just verifies that the
device file can be preserved and retrieved. In the future this test will
be extended to verify more parts about device preservation as they are
implemented.

This test is added to TEST_GEN_PROGS_EXTENDED since it must be run
manually along with a kexec.

To run this test manually:

 $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
 $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0

 $ kexec ...   # NOTE: Exact method will be distro-dependent

 $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
 $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 2 0000:00:04.0

The second call to setup.sh is necessary because preserved devices are
not bound to a driver after Live Update. Such devices must be manually
bound by userspace after Live Update via driver_override.

This test is considered passing if all commands exit with 0.

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile         |  4 +
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 89 +++++++++++++++++++
 2 files changed, 93 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 591f1a52c310..a2f0a459e1f4 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -15,6 +15,10 @@ TEST_GEN_PROGS += vfio_pci_driver_test
 TEST_GEN_PROGS += vfio_pci_sriov_uapi_test
 TEST_GEN_PROGS += vfio_pci_liveupdate_uapi_test
 
+# This test must be run manually since it requires the user/automation to
+# perform a kexec during the test.
+TEST_GEN_PROGS_EXTENDED += vfio_pci_liveupdate_kexec_test
+
 TEST_FILES += scripts/cleanup.sh
 TEST_FILES += scripts/lib.sh
 TEST_FILES += scripts/run.sh
diff --git a/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
new file mode 100644
index 000000000000..15b3e3af91d1
--- /dev/null
+++ b/tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <libliveupdate.h>
+#include <libvfio.h>
+
+static const char *device_bdf;
+
+static char state_session[LIVEUPDATE_SESSION_NAME_LENGTH];
+static char device_session[LIVEUPDATE_SESSION_NAME_LENGTH];
+
+enum {
+	STATE_TOKEN,
+	DEVICE_TOKEN,
+};
+
+static void before_kexec(int luo_fd)
+{
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int session_fd;
+	int ret;
+
+	iommu = iommu_init("iommufd");
+	device = vfio_pci_device_init(device_bdf, iommu);
+
+	create_state_file(luo_fd, state_session, STATE_TOKEN, /*next_stage=*/2);
+
+	session_fd = luo_create_session(luo_fd, device_session);
+	VFIO_ASSERT_GE(session_fd, 0);
+
+	printf("Preserving device in session\n");
+	ret = luo_session_preserve_fd(session_fd, device->fd, DEVICE_TOKEN);
+	VFIO_ASSERT_EQ(ret, 0);
+
+	close(luo_fd);
+	daemonize_and_wait();
+}
+
+static void after_kexec(int luo_fd, int state_session_fd)
+{
+	struct vfio_pci_device *device;
+	struct iommu *iommu;
+	int session_fd;
+	int device_fd;
+	int stage;
+
+	restore_and_read_stage(state_session_fd, STATE_TOKEN, &stage);
+	VFIO_ASSERT_EQ(stage, 2);
+
+	session_fd = luo_retrieve_session(luo_fd, device_session);
+	VFIO_ASSERT_GE(session_fd, 0);
+
+	printf("Finishing the session before retrieving the device (should fail)\n");
+	VFIO_ASSERT_NE(luo_session_finish(session_fd), 0);
+
+	printf("Retrieving the device FD from LUO\n");
+	device_fd = luo_session_retrieve_fd(session_fd, DEVICE_TOKEN);
+	VFIO_ASSERT_GE(device_fd, 0);
+
+	printf("Finishing the session before binding to iommufd (should fail)\n");
+	VFIO_ASSERT_NE(luo_session_finish(session_fd), 0);
+
+	printf("Binding the device to an iommufd and setting it up\n");
+	iommu = iommu_init("iommufd");
+
+	/*
+	 * This will invoke various ioctls on device_fd such as
+	 * VFIO_DEVICE_GET_INFO. So this is a decent sanity test
+	 * that LUO actually handed us back a valid VFIO device
+	 * file and not something else.
+	 */
+	device = __vfio_pci_device_init(device_bdf, iommu, device_fd);
+
+	printf("Finishing the session\n");
+	VFIO_ASSERT_EQ(luo_session_finish(session_fd), 0);
+
+	vfio_pci_device_cleanup(device);
+	iommu_cleanup(iommu);
+}
+
+int main(int argc, char *argv[])
+{
+	device_bdf = vfio_selftests_get_bdf(&argc, argv);
+
+	sprintf(device_session, "device-%s", device_bdf);
+	sprintf(state_session, "state-%s", device_bdf);
+
+	return luo_test(argc, argv, state_session, before_kexec, after_kexec);
+}
-- 
2.55.0.795.g602f6c329a-goog


