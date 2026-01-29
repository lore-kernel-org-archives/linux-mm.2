Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08006D73E8C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2886B00A4; Thu, 29 Jan 2026 16:26:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4146B00A5; Thu, 29 Jan 2026 16:26:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20946B00A7; Thu, 29 Jan 2026 16:26:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1D2B6B00A4
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:10 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 816D11402C2
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:10 +0000 (UTC)
X-FDA: 84386284500.11.2D11309
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf17.hostedemail.com (Postfix) with ESMTP id A68464000B
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a+9dlUt/";
	spf=pass (imf17.hostedemail.com: domain of 3b9B7aQgKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3b9B7aQgKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JG18MDRMH4VUqggxYa+ZNtdyrKhzyTrjCDPr+CW7RY4=;
	b=kPbvap6zHHX17QqIvYHa81WuLkn/C0lgkII7mjhdJYqBES6Qs2WwPrlq3ZbRhuIPJxsUWa
	iFEFGXoQE7ujSPqRxaflpjU8gQVLTwK30wsAjDF+Uh+Fm8uXhrXE9rhSAwN8mgWuzcmVg2
	Zc7CagtIfWX/acp+Kh3YVF9TDx73R24=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="a+9dlUt/";
	spf=pass (imf17.hostedemail.com: domain of 3b9B7aQgKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3b9B7aQgKCFIx6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721968; a=rsa-sha256;
	cv=none;
	b=sCvyQRLSVBqj4fV1kVEvc6jBsWuYBUwKPqmkMlJTkkK5EROpwyRCM0bF5yUl6zpHPJKVZL
	RwHV6hwfJuoZ9B+g8DhrfxlR3kBSdefci8cQsGcz1LKH/qHhonFx2e65SBOAgoP9ZislQu
	f5Fn/L3s9BtqhVmj7EQe1gIN+UK9w1E=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0b7eb0a56so11725945ad.1
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721967; x=1770326767; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JG18MDRMH4VUqggxYa+ZNtdyrKhzyTrjCDPr+CW7RY4=;
        b=a+9dlUt/ntkjhZDx07VCy91sQHCgDiYz3xx+evmRwd5owrHEa/nB1jVUQ+F3gLf0Y/
         qaR2DZU6H1OnaUZAUS4NlvzeuY6ctKYSHLSD5W093hNBCN8Jr5cIYMzF+H/mOMB5bSY1
         o3HsGEVWrH/wXz8sPfBnuggF4FF2in3njnCEoCbD9+iHx7FN2XAemt4sNr+zYkKan5X6
         ITS6yt4oIoK+Mt/FIEpjJgOUgHPFe1xH0YmcDJrPkX5CCEVGXlnRDEUwAUcvc+YccZPi
         HI98ETTSM7qr3bD0jp6h2IaWGp5RRd2XCphCYlC7E3aUVyHd6pZarPw9puJ4BDuhkt94
         0vTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721967; x=1770326767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JG18MDRMH4VUqggxYa+ZNtdyrKhzyTrjCDPr+CW7RY4=;
        b=NUJ6rQjcsMxxy8x2RhavXc5SAXXDByZWXo34+SPo/bcsumKEivuRbpt8m5wuAG/45p
         hsBBkMT92vKghRg1WI8y0G1TmOoTWl9ZECI+qvIH8B5ULRZfz6oxRkP4iAz6SkrV6r4W
         LiKrnojNNYNOn/2LkBUP0+RQnu94zkW2+VpCG6t7UKtFjQJkqIRM83qvFjMDU4nme2M8
         UxzWlOOwdx0aXELQZZrCbke0qmhvQGJgiYsPfks5InXxIfcYateB2rqyA+IYOw+MjUT2
         M/IVjLZEVWS26e44mql8aUFikaSCNwUyamxun08cLsnAmPvqVZKeBZuRqkUVMcBce47T
         gseg==
X-Forwarded-Encrypted: i=1; AJvYcCUcIfT1wYd8HWy4OUj7h50AYUx0nyc8RqeZ8dLKlw7AOrwlHY4eVF8kmaoiUY9gBABS0eTrmS63Ag==@kvack.org
X-Gm-Message-State: AOJu0YwJinusihTNAn4yBOp4ErtVu+/NHuBNt67VX4ARfi1VDdSpaAZX
	o4mSROPWu71IXW9j8eRukSD4Mdl7HU6mg2W2EHixErqagKCCSoLSrkjqUYWY7ISskayRLLHsZZP
	QGdIeJIlgqIAblQ==
X-Received: from pldv20.prod.google.com ([2002:a17:902:ca94:b0:29f:2b44:973b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1c1:b0:2a7:90a5:2c95 with SMTP id d9443c01a7336-2a8d819ac05mr6111855ad.51.1769721967422;
 Thu, 29 Jan 2026 13:26:07 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:05 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-19-dmatlack@google.com>
Subject: [PATCH v2 18/22] vfio: selftests: Add vfio_pci_liveupdate_kexec_test
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A68464000B
X-Stat-Signature: 7t73dus3fatb1nx91u3wwxqkf94n6shz
X-Rspam-User: 
X-HE-Tag: 1769721968-482270
X-HE-Meta: U2FsdGVkX1/8bXvsF2WxvJBpMLafm5yAiY233KV8WC8j0ZsqlttKzL7gLneCuHpSzgJ1d8sdlwGEEutOfGYcOGnzVp4/T4N8yqvfOicrwisVafJzjcBORn6LLQdUvJ2F6HB8cTYQL48nVI5w/EKdFhb67ZvsGMLXITNaQoy/aJUrxRIlJ9NRWbmz2GawbWwf8Fvw7jYafzfZtJ02gS3ORNOUT4DjYt76VSWZFhxm4y/ouafy+6EuKFOdt40+BjTSx79Es0hZIjEJMXpF+OxgbG/P+b9Ig11iuYs3bY6gf8JklGX3S4vKf8YoVRZKQVFElfCtcoxiFP1NYa2seT1HqaAglyORyZkLC93ssaQLq+cPMN9ZSJv4Q0hJInojppij6NxFzjzTwcnHNA+dzDBXnkXPxtsFJz0LfJpeWS9WGv1hsmbPTbvb0sk+rYQBAhZNuAvFV2oxzWzAdRCK9HrzVbyG11KJQ/sQaJCqZal1wvdW78m8/bxupeaPJX+mx+//ASfoMHnGisIBdEPCVpSVqkVvQc8bYtl6m8RXusP2tR7W7jEGDMf+Hr2yqUBXOTcnL0yvzsiPKcHZLPKLKBZnGKLQ5sl6Lh7N7AftjksaEvQ1UE7lidm5Yj3MarfWQ6EjEfp/9PlxvKnJ+D3vO4bMR0FXAYSjEzBHp1v4QeWD1dJA5gkQQqquSIQ9SnVdF6hiSSYIKGsIRugJXEgMnxHEqkeeQrH6liXSFx3h4efs5AKRWVAW9VmL6z4JjHTuQVeEIkMFbnUEujFZDghBRSbTToB+uIENm+QYCJ8XU9TaNQQ/0RpW206MxkcTF29BcbdPKIXf6o5OLt/HAYlfbRqz2ibpUCepE6wxVVXwK1FlHakQ7AYz3YQZ/FDJ5vZvOSLZac2qnjaa9BLxXBwmX2TJf42zrXCpqsIL4NIdatf+8sVbFavijhb/dlPKjhKx68jUYIVfw1kCEePb1nWnrKU
 +dhs6lMu
 E/2qYJuslgs/269mM07RKyKtfGka7RZG4kq0OmaQVZXfaR7n0RHXd2jU4xe/nRtE4tL4ECIvBNDt4zyGnHOoASXxvV5RR1KvNxvzFXXtK7JI9lnLupwAB2WbMQ5j0XlNQPnMWhSpXReakB98ziHDYlPDUz20f5Usu95RZRld5CUr/6Z90vE6rPWJYIYxXK+jTd8we0twDXhpHANmwJxNXbWTO2WAxKtwsx1KKIHt2ARqthqz+7UC2yWlOcHvYoEbCnhG5s7hvwaWrzn9qsUeumC4r0X2ifnQJ+xjh9R9T/e+MuMmWyKh869jcw3Wpk23swToL0vzejJTxoS+v12UQ3IAP1XVPpkHW4Idp9/CUNGJmRJ7vC2ONOgGiR2zvaDA4W87i4IwfZrdJ3nzP7t71IO1XoX0luBBfR3JLavKlkMs28YDVHmHE3hmWC290U1ehjUtHUNpXCclxeVLX1zWsCvcNyoHFrzvk6pCQzpyv9ZjY7I6oySq1C2h82GVg5NS3DkDkVLkiMcBJFv178de4R4bY48XP0dMKDMapllqCqrlczJdIGQndvUE+kKIaHLbVqrz/cGqKczfcIt5t4rh25Tvk3mkrVGabWDrRAbuog4v6j3swPAywOamT/TntT+tG6l6l/wfXlLoCPio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

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

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile         |  4 +
 .../vfio/vfio_pci_liveupdate_kexec_test.c     | 89 +++++++++++++++++++
 2 files changed, 93 insertions(+)
 create mode 100644 tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test.c

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 666310872217..55d685f6e540 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -6,6 +6,10 @@ TEST_GEN_PROGS += vfio_pci_device_init_perf_test
 TEST_GEN_PROGS += vfio_pci_driver_test
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
2.53.0.rc1.225.gd81095ad13-goog


