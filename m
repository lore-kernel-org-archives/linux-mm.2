Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FFD4F532C5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 970346B00BB; Mon, 23 Mar 2026 19:59:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 921DE6B00BD; Mon, 23 Mar 2026 19:59:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E8D36B00BE; Mon, 23 Mar 2026 19:59:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 638E96B00BB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D2D5160D76
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:16 +0000 (UTC)
X-FDA: 84578996712.05.6FC41D8
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf06.hostedemail.com (Postfix) with ESMTP id 707DE18000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bQydh0Hc;
	spf=pass (imf06.hostedemail.com: domain of 30NPBaQgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=30NPBaQgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bQydh0Hc;
	spf=pass (imf06.hostedemail.com: domain of 30NPBaQgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=30NPBaQgKCNM2BzIAz195DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310354; a=rsa-sha256;
	cv=none;
	b=ObHwZyLZEy/fpgCDqB2Y7K5FvLRec+Kw/MNHfx4qk76/oLhxSbqgB/DFHiZijcE6KYE6WS
	ycpGk2YJ/5KAJWEt9dKhBPgOBMaJKncn+dnx/tJjxVl7nu3tbjJ+ySTB+/X3Fp5t7Qhrn6
	2qJIgDAOzK8e8APbCcve4c6dBOjG8Wc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXP5xRG4iZUBSse1Xd5a8GnmNvg4u/BwNl26bCYdYz4=;
	b=Yy2mz+KpOxmhJDZftIgglI08FN1/MqJwig7bxDmbUcsefvmXhOhzwMCAmjv/DWtj1IeA7x
	Q/UwtAm3P0s8Y2ZJrJ9rGoWycDEHk3WAPC6bKya+Td1Pwb0Gim9B+fzE8c0YhiW1sFq/93
	m9IOKM8LR5amIkVjmkJlgWwbiGeT6ZM=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35b96fbfc64so17612595a91.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310353; x=1774915153; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IXP5xRG4iZUBSse1Xd5a8GnmNvg4u/BwNl26bCYdYz4=;
        b=bQydh0HcbXHLUQHdLjHggJ0swyM5FMl6p0vnRmH4g4PoF9WKDMg7P+/RoGCNnZXUZE
         sgvpCRpaX0XOK7Kso/3RM+HQ6L8TAVaJy/3Xu4n+z4h+vTHCfsGkPsxvGi4KSORelkzq
         3r0K+uZ/RNk8JnLhP8Ds0OBRLYqtVw7s6+Lp7J4lmAfKAbaGzw4/861dyt9Im6i60OUi
         j5Ur/hPlVMh9TJgv9y4CtUkJZfXFx8rl83S74v7AEGPuuNp9fGDhejx7RAGTA4YX4hk4
         zj2qsfJZ6eE7iZdgHC91juD7PMcAbthiOVIw/xV73QzpIQ8GpMPXjSXq3BdrWeezEg0O
         t++Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310353; x=1774915153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IXP5xRG4iZUBSse1Xd5a8GnmNvg4u/BwNl26bCYdYz4=;
        b=L8nyHcCryfcCxHejLjnroLwykoLRTITrZvliFpvw4WDPSsUItxSeJFrBvlRCkZW5qg
         DI9A5xr46/AP7gjwZ0qpBCAb5Bs4DDCK+VYskxamHuuhju7ZygHeWqCGiGmrTUuEBstw
         fEZZHND4e+0Pg7WQ41jCAB4H3mJp3mWicMgcou9poSduVmkKqHcOjK+PvUejIRbI0PHm
         JmMosztQBZboa+zyRCgTgsmrcurRHCGWkYzX5cSrceJobBt10uyIj69W+YIm3MnTmlpm
         N1Jy4tN7pTCavq9qOgFzcAbpnerwPaus8H8xFl62MtGw/jLi4CbgiKtdHMpxaAhh7fJi
         6WJw==
X-Forwarded-Encrypted: i=1; AJvYcCVLbVe48f6AjdF/TIZZf+OU7JefmON46lrsXAdktaJMqxOE8yLZZ9DHVcjvhHxEaoMm6uqmyFjqag==@kvack.org
X-Gm-Message-State: AOJu0YytB0O4DlNiwm4S1Gf0gmS4mqUwCOtQVfCHc2XskWz5CkBplv8a
	JBujTmfN1yJHePjCFUgAIrjRTqtX0M/cm518Ggop2UyWew0L0t3j+VhF+5u0lbFtDUTRx2VoRG1
	xhoA0HBsQUVkrxg==
X-Received: from pjbil12.prod.google.com ([2002:a17:90b:164c:b0:35b:9d0e:7821])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d406:b0:35b:9c13:30cc with SMTP id 98e67ed59e1d1-35bd2d3fbffmr11092911a91.23.1774310352922;
 Mon, 23 Mar 2026 16:59:12 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:12 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-21-dmatlack@google.com>
Subject: [PATCH v3 20/24] vfio: selftests: Add vfio_pci_liveupdate_kexec_test
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 707DE18000D
X-Stat-Signature: ju7rgkzd1763kfidaobdmx15pzkxhgdy
X-Rspam-User: 
X-HE-Tag: 1774310354-718575
X-HE-Meta: U2FsdGVkX1+AXUQvAeqG1pA94l4D9PHU3aW9FPFJGCnV6HuWFg4iY7eSz5De56gCxOSC8AUn813Re/UY4GnBL9u7g1zYtxDzs6ueaLRc8Tm1AXLYHJwXMKEwDKB7NSBp4V9WvJ/NIZhnYZOdST3PSG27k3HNG5WjyPAJecxwKE7KYfHTc8sAixTaHKgsLQc10qLSVPO8RQQoAz6ySXDDdJmBXbBx1CnWzMlkr+6Ipa4CbBOVjpATODyE2RtLCcmewG9v1S18ic7XGbH6B1xpxTJWSUJeoEdUHKiOfDuVprWhkxyIYjWxCNXiWHSMhMSc7XTde623HpQADCbVPMAuAXxP0tIPHYA9QOG2XMDWXgHUQL4LK3RtBhETAY+cBUPR6t3ofIdEUgOA+Skqz8bDh06guFyi3ygpn8NqMSajMXQvVxZtNqv7+AM6nW1blSOke3XLDdb8X9gqHePlXCoMHDpBqmH/UrKT/fayXl0L8SIlMpM20Zvmac16GGPBVDlNKVxHa++XVNn4KHOjZoX/wYfIMO9zwKuCCpTGxKcylI4VHaIDtsPYiRqOh3gugV7yOBIV+LrGJcaaEjLPUpf+KOYXDeniPOO0bhernRnVkHSIeoBy7H/2O9Cw8H/3psdlOJMrmpk7dqbM+eOKmFso0hxlT+HGt21UhzFmLhCZ2kWfnPiGh0hwAw4eHFRD1ZY99BTnxmrrXVMmoPudvdpWOYQ4Eh72KtrTzKVksAB9cyjYEq8ELxmqO7mD17jENoraN/MRK8PWYPPeRYF97aKT8B4aT5HIVSOVIb1HHcdNq59Rd1e5JqfAMNjUiCflssj2Nii0ggl/YKDChCuWNdW0BgrvuhuPYKnkhEprBjn14/UR8YDgSGTkWJWsE8r4z6KI22FsKwLooQxfOxnZnJtMZ9A5aw4y/Zto04eN2PzehvP4u7iKFgzIXSIfPl8S7SSORbgoWoWgrLUpx/ly+l7
 Zxz0tMnP
 0OcJtFvytmndrgiMCutnmwqLg+5r6yoYUlk/ky5VwVNVvEzcPa1ztt67l9lATvpWibBBymNGBK2vo1vZtMwlf2zRC7E3WDaaPCGAMIRPuf8H/BFXw82GsUUoAp3f1NzGqxqmghbHcHy7HlfHo1oucrGCBJ/XEpHZ4rQa9nptwn2P0y2ONr99hJorhAk36rQn1JLnymDr9onBrInem0YdMdgXL3DveScJ2hh5wvhRAVG44hSmCKC7RCz0z/RbvSoe7Oo0XLE7Yr8Nriva2PeTBGJsg9LAKE4pjFiVHqsyYuZHkkX2apSdoUBZEH5pnCE1Qdxmtsg0iVQv1qmP4E+ioHoI6YrOhk+82kdTRoGkUb8+IvdUEJVvWzrhGUSn+AKv+1mq1a2NrXpXL6Rld9jIZ2jfPxH67Z8BXB4gmiRJmYzwNafV/D2KENMQU/ykWwPkTb8Iklgjzk60Uvr3xnutJYQbvJDfTc3ZWmkxOfP78bhF1ngSMobKokDA72cbqzMkTxY0IQNft29FVOVZ0sa2fgwatyA/NgSVRbERBJuJ/8RUh66Pch+PQzJ9LMqglVUybqn3mgm+oRshNXFUHn50oLHNe4jUsvHYOeLhWp2aNDxRB3ceIsVF/KjYfnQjlpmY61fsDLFTlvX3adQo6RHfEzQOBJiu9y67WUzX/IRlrH0dFZc9UrR+POya+TiUC/FF/LVZ8NSUdnA5wSJ/OBnWVRMRhYjn8KQgy2k+rgcPAkvsa+krK0Kb7TwKklA==
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
index 5b6e79593555..792c4245d4f7 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -14,6 +14,10 @@ TEST_GEN_PROGS += vfio_pci_device_init_perf_test
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
2.53.0.983.g0bb29b3bc5-goog


